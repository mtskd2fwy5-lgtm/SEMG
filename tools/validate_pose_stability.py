#!/usr/bin/env python3
"""Validate fixed PS pose policy on continuous streams; never fit or tune weights."""
import argparse
import hashlib
import json
import subprocess
from pathlib import Path

import numpy as np

from export_int8 import Int8MLP
from pose_contract import (POSE_MIN_CONF, POSE_HOLD_CONF, POSE_CONFIRM_WINDOWS,
                           POSE_REST_WINDOWS, POSE_UNCERTAIN_WINDOWS)
from train_board_model import ROOT, FS, WINDOW, HOP, read_capture, feature_windows
from verify_board_confidence import firmware_confidence, replay_pose, scores


def softmax_scores(z, scale):
    """Bit-exact lookup matching the PS; independent float softmax checked below."""
    z = np.asarray(z, dtype=np.int64)
    bins = ((z.max(axis=1, keepdims=True) - z) * round(scale * 16 * (1 << 24)) + (1 << 23)) >> 24
    lut = np.rint(np.exp(-np.arange(257) / 16) * (1 << 20)).astype(np.int64)
    exp = np.where(bins <= 256, lut[np.minimum(bins, 256)], 0)
    return exp * 100 // exp.sum(axis=1, keepdims=True)


def stable_pose(pred, conf, gated, sequence=None):
    active = pending = count = uncertain = 0
    out = np.zeros(len(pred), dtype=np.int8)
    for i, (cls, q, gate) in enumerate(zip(pred, conf, gated)):
        if sequence is not None and i and (int(sequence[i]) - int(sequence[i-1])) % 65536 != 40:
            count = uncertain = 0
        target = int(cls)
        valid = 0 <= target < 5
        if gate:
            target, valid = 0, True
        elif target == 0 or target == active:
            valid = valid and q >= POSE_HOLD_CONF
        else:
            valid = valid and q >= POSE_MIN_CONF
        if not valid:
            count = 0
            uncertain = min(uncertain + 1, POSE_UNCERTAIN_WINDOWS)
            if uncertain >= POSE_UNCERTAIN_WINDOWS and active != 0:
                active, count, uncertain = 0, 0, 0
        else:
            if target == active:
                count = uncertain = 0
            else:
                uncertain = min(uncertain + 1, POSE_UNCERTAIN_WINDOWS)
                if target == pending:
                    count += 1
                else:
                    pending, count = target, 1
                need = POSE_REST_WINDOWS if target == 0 else POSE_CONFIRM_WINDOWS
                if count >= need:
                    active, count, uncertain = target, 0, 0
                elif uncertain >= POSE_UNCERTAIN_WINDOWS and active != 0:
                    active, count, uncertain = 0, 0, 0
        out[i] = active
    return out


def c_crosscheck(vectors):
    """Compile unmodified function bodies, and verify confidence and accepted class."""
    firmware = (ROOT / "sw/ps_uart_print/main.c").read_text(encoding="utf-8")
    def extract(name, return_type):
        start = firmware.index(f"static {return_type} {name}(")
        end = firmware.index("{", start) + 1
        depth = 1
        while depth:
            depth += (firmware[end] == "{") - (firmware[end] == "}")
            end += 1
        return firmware[start:end]

    out = ROOT / "sim/results_pose_stability"
    out.mkdir(parents=True, exist_ok=True)
    src = out / "firmware_pose_check.c"
    src.write_text('''#include <stdint.h>
#include <stdio.h>
typedef uint32_t u32;typedef uint16_t u16;typedef int32_t i32;
#include "../../sw/ps_uart_print/pose_contract.h"
#include "../../sw/ps_uart_print/nn_confidence.h"
static u32 res_logits[5],pose_active_cls,pose_active_conf,pose_active_gated;
static u32 pose_pending_cls,pose_pending_count,pose_uncertain_count,pose_observe_seen;
static u16 pose_observe_seq;
static u32 fat_level,mpu_tilt_q,mpu_shift_q;
static void lcd_show_state(u32 a,u32 b,u32 c,u32 d,u32 e,u32 f) {}
static void pose_accept(u32 s,u32 c,u32 q,u32 g) {
 pose_active_cls=c;pose_active_conf=q;pose_active_gated=g;
 pose_pending_count=pose_uncertain_count=0;
}
''' + extract("logit_conf_for", "u32") + "\n" + extract("logit_conf", "u32") + "\n" +
                   extract("pose_observe", "void") + '''
int main(void) {
 unsigned reset,seq,g,expected_q,expected_cls,n=0;int a,b,c,d,e;
 while(scanf("%u %u %d %d %d %d %d %u %u %u",&reset,&seq,&a,&b,&c,&d,&e,
             &g,&expected_q,&expected_cls)==10) {
  if(reset) {pose_active_cls=pose_active_conf=pose_active_gated=0;
   pose_pending_cls=pose_pending_count=pose_uncertain_count=pose_observe_seen=0;}
  res_logits[0]=a;res_logits[1]=b;res_logits[2]=c;res_logits[3]=d;res_logits[4]=e;
  u32 cls=0;for(u32 i=1;i<5;i++)if((i32)res_logits[i]>(i32)res_logits[cls])cls=i;
  u32 q=logit_conf();pose_observe(seq,g?0:cls,q,g);
  if(q!=expected_q || pose_active_cls!=expected_cls || pose_active_conf!=logit_conf_for(pose_active_cls)) {
   fprintf(stderr,"row %u q=%u/%u class=%u/%u\\n",n,q,expected_q,pose_active_cls,expected_cls);return 1;
  }n++;
 }
 if(!feof(stdin)) return 2;
 printf("PASS: %u actual C confidence/pose rows\\n",n);return 0;
}
''', encoding="utf-8")
    exe = out / "firmware_pose_check.exe"
    batch = out / "compile_check.bat"
    batch.write_text('@echo off\ncall "D:\\c++\\VC\\Auxiliary\\Build\\vcvars64.bat" >nul && '
                     f'cl /nologo /std:c11 /O2 "{src}" /Fo:"{out / "check.obj"}" /Fe:"{exe}"\n', encoding="utf-8")
    build = subprocess.run(["cmd", "/c", str(batch)], text=True, capture_output=True)
    if build.returncode:
        raise RuntimeError(build.stdout + build.stderr)
    rows = []
    for z, q, gate, seq, expected in vectors:
        for i in range(len(z)):
            rows.append(" ".join(map(str, [int(i == 0), seq[i], *z[i], int(gate[i]), q[i], expected[i]])))
    run = subprocess.run([str(exe)], input="\n".join(rows)+"\n", capture_output=True, text=True)
    if run.returncode:
        raise RuntimeError(run.stdout + run.stderr)
    return run.stdout.strip()


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--csvs", nargs="+", default=[
        "report/emg017_20261022/EMG017_processed.csv",
        "report/emg018_20261022/EMG018_validprefix_processed.csv"])
    ap.add_argument("--out", default="data/metrics/pose_stability_20261022.json")
    args = ap.parse_args()
    qp_path = ROOT / "data/models/nn_int8_board_multiwear/quant_params.json"
    qp = json.loads(qp_path.read_text(encoding="utf-8"))
    model = Int8MLP(qp)
    result = {"model_sha256": hashlib.sha256(qp_path.read_bytes()).hexdigest(),
              "weights_unchanged": True,
              "policy": dict(entry=POSE_MIN_CONF, hold=POSE_HOLD_CONF, action_windows=POSE_CONFIRM_WINDOWS,
                             rest_windows=POSE_REST_WINDOWS, uncertain_windows=POSE_UNCERTAIN_WINDOWS),
              "captures": {}}
    vectors = []
    max_error = 0.0
    for value in args.csvs:
        path = ROOT / value
        # Fail closed: no concatenation across corrupt frames, loss or unknown labels.
        import pandas as pd
        timing = pd.read_csv(path, usecols=["timestamp_us", "sequence"])
        if not np.all(np.diff(timing.timestamp_us.to_numpy()) == 250):
            raise ValueError(f"{path}: non-continuous timestamps")
        if not np.all(np.diff(timing.sequence.to_numpy(dtype=np.int64)) % 65536 == 1):
            raise ValueError(f"{path}: non-continuous sample sequence")
        x, sy = read_capture(path)
        fx, _, _ = feature_windows(x, np.zeros(len(x), dtype=np.int8), trim=0)
        starts = np.arange(len(fx)) * HOP
        ends = starts + WINDOW - 1
        edges = np.r_[0, np.flatnonzero(sy[1:] != sy[:-1]) + 1, len(sy)]
        bi = np.searchsorted(edges, starts, side="right") - 1
        mask = (starts >= edges[bi] + FS) & (ends < edges[bi+1] - FS)
        ready = np.arange(len(fx)) >= 95
        mask &= ready
        y = sy[ends]
        z = model.forward(fx)
        pred = z.argmax(axis=1)
        old_q = firmware_confidence(z)
        q_all = softmax_scores(z, qp["logits_scale"])
        q = q_all.max(axis=1)
        fp = np.exp((z - z.max(axis=1, keepdims=True)) * qp["logits_scale"])
        fp = fp / fp.sum(axis=1, keepdims=True) * 100
        max_error = max(max_error, float(np.abs(fp - q_all).max()))
        base = fx[80:96, :8].astype(np.uint64).sum(axis=0) // 16
        gate = np.all(fx[:, :8] < np.maximum(base * 3, 1000), axis=1) & (pred != 0)
        seq = (np.arange(len(fx)) * 40 % 65536).astype(np.uint16)
        variants = {"raw_argmax": scores(y, pred, mask)}
        for enabled, g in ((False, np.zeros(len(z), dtype=bool)), (True, gate)):
            before = np.zeros(len(pred), dtype=np.int8)
            after = before.copy()
            before[ready] = replay_pose(pred[ready], old_q[ready], g[ready], 30, 2)
            after[ready] = stable_pose(pred[ready], q[ready], g[ready], seq[ready])
            for key, p in ((f"old_mav{int(enabled)}", before), (f"new_mav{int(enabled)}", after)):
                variants[key] = scores(y, p, mask)
                stable_pair = mask[1:] & mask[:-1] & (y[1:] == y[:-1])
                variants[key]["switches_within_stable_labels"] = int(np.count_nonzero((p[1:] != p[:-1]) & stable_pair))
                variants[key]["switches_whole_stream"] = int(np.count_nonzero(np.diff(p[ready])))
            vectors.append((z[ready], q[ready], g[ready], seq[ready], after[ready]))
        segments = [dict(start_s=int(a)/FS, end_s=int(b)/FS, cls=int(sy[a])) for a, b in zip(edges[:-1], edges[1:])]
        result["captures"][path.stem] = dict(source=value, frames=len(x), duration_s=len(x)/FS,
            csv_sha256=hashlib.sha256(path.read_bytes()).hexdigest(),
            calibration_assumption="MAV calibration at CSV start; actual board baseline unavailable",
            calibration_all_rest=bool(np.all(sy[:ends[95]+1] == 0)), baseline=base.tolist(),
            variants=variants, segments=segments,
            processed_rms_counts=np.sqrt(np.mean(x.astype(float)**2, axis=0)).tolist(),
            processed_rails=int(np.count_nonzero((x == 8388607) | (x == -8388608))))
        print(path.stem)
        for name, metrics in variants.items():
            print(name, 'accuracy', round(metrics['accuracy'], 4), 'recall', np.round(metrics['recall'], 4).tolist(),
                  'stable switches', metrics.get('switches_within_stable_labels'))

    # Extreme inputs, equal scores, offset invariance and broken feature sequence.
    stress = np.array([[0]*5, [-2147483648,2147483647,0,0,0], [2147483647]*5,
                       [0,10000,0,0,0], [100000000,100010000,100000000,100000000,100000000]], dtype=np.int64)
    stress = np.repeat(stress, 10, axis=0)
    sq = softmax_scores(stress, qp["logits_scale"]).max(axis=1)
    sp = stress.argmax(axis=1)
    sg = np.zeros(len(stress), dtype=bool)
    ss = np.arange(len(stress))*40
    ss[21:] += 40
    vectors.append((stress, sq, sg, ss, stable_pose(sp, sq, sg, ss)))
    result["c_crosscheck"] = c_crosscheck(vectors)
    if max_error > 2.0:
        raise AssertionError(f"PS softmax lookup error exceeds 2 percentage points: {max_error}")
    result["softmax_max_error_percentage_points"] = max_error
    result["limitations"] = ["MAV-on is a simulated calibration scenario, not measured board accuracy.",
        "State is continuous through transitions; scores exclude 1s at bout edges and calibration startup.",
        "EMG017 was used for exploration; EMG018 baseline was inspected before implementation; development validation only.",
        "LCD interpolation, real packet arrival timing and exact hardware feature-window phase are not replayed.",
        "Softmax scores are uncalibrated and are not empirical correctness probabilities."]
    (ROOT / args.out).write_text(json.dumps(result, indent=2), encoding="utf-8")
    print(result["c_crosscheck"], "softmax max error", max_error)


if __name__ == "__main__":
    main()
