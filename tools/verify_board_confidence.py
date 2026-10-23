#!/usr/bin/env python3
"""Replay the historical 30-point PS policy; use validate_pose_stability for V2."""
import argparse
import hashlib
import json
import re
import subprocess
from pathlib import Path

import numpy as np
from sklearn.metrics import accuracy_score, confusion_matrix, f1_score

from export_int8 import Int8MLP
from train_board_model import ROOT, FS, HOP, WINDOW, feature_windows, read_capture


def firmware_confidence(logits):
    """Match logit_conf's uint32 sum/multiply, including C wraparound."""
    z = np.asarray(logits, dtype=np.int64)
    top = z.max(axis=1)
    denominator = (np.abs(z).sum(axis=1) + 1) & 0xffffffff
    if np.any(denominator == 0):
        raise ValueError("firmware confidence denominator wraps to zero")
    return np.where(top > 0, ((top * 100) & 0xffffffff) // denominator, 0)


def replay_pose(pred, confidence, gated, threshold=30, confirm=2):
    """Match pose_observe, including immediate rest on rejected confidence."""
    active = pending = count = 0
    result = np.zeros(len(pred), dtype=np.int8)
    for i, (cls, conf, gate) in enumerate(zip(pred, confidence, gated)):
        cls = int(cls)
        rejected = bool(gate or conf < threshold or cls >= 5)
        if rejected:
            cls = 0
        if cls == active:
            count = 0
        elif cls == 0 and (gate or conf < threshold):
            active, count = cls, 0
        else:
            if cls == pending:
                count += 1
            else:
                pending, count = cls, 1
            if count >= confirm:
                active, count = cls, 0
        result[i] = active
    return result


def scores(y, pred, mask):
    y, pred = y[mask], pred[mask]
    cm = confusion_matrix(y, pred, labels=range(5))
    rest = y == 0
    return {
        "windows": int(len(y)), "accuracy": float(accuracy_score(y, pred)),
        "macro_f1": float(f1_score(y, pred, labels=range(5), average="macro", zero_division=0)),
        "recall": (np.diag(cm) / np.maximum(cm.sum(axis=1), 1)).tolist(),
        "rest_false_action_rate": float(np.mean(pred[rest] != 0)) if rest.any() else None,
        "confusion": cm.tolist(),
    }


def check_firmware_c(firmware, logits, confidence, pred, gates, threshold, confirm):
    """Compile actual firmware function bodies and compare every replay row."""
    def body(name):
        start = firmware.index("static " + ("u32 " if name == "logit_conf" else "void ") + name + "(")
        brace = firmware.index("{", start)
        depth, end = 1, brace + 1
        while depth:
            depth += (firmware[end] == "{") - (firmware[end] == "}")
            end += 1
        return firmware[start:end]

    out = ROOT / "sim/results_confidence"
    out.mkdir(parents=True, exist_ok=True)
    source = out / "firmware_confidence_check.c"
    source.write_text("""#include <stdint.h>
#include <stdio.h>
typedef uint32_t u32;
typedef int32_t i32;
static u32 res_logits[5], pose_active_cls, pose_active_conf, pose_active_gated;
static u32 pose_pending_cls, pose_pending_count;
static u32 fat_level, mpu_tilt_q, mpu_shift_q;
#include "../../sw/ps_uart_print/pose_contract.h"
static void lcd_show_state(u32 a,u32 b,u32 c,u32 d,u32 e,u32 f) {}
static void pose_accept(u32 seq,u32 cls,u32 conf,u32 gated) {
    pose_active_cls=cls;pose_active_conf=conf;pose_active_gated=gated;
    pose_pending_count=0;
}
""" + body("logit_conf") + "\n" + body("pose_observe") + """
int main(void) {
    unsigned reset, gate, expected_conf, expected_cls, rows=0;
    int a,b,c,d,e;
    while(scanf("%u %d %d %d %d %d %u %u %u", &reset,&a,&b,&c,&d,&e,
                &gate,&expected_conf,&expected_cls)==9) {
        if(reset) {pose_active_cls=0;pose_active_conf=0;pose_active_gated=0;
                   pose_pending_cls=0;pose_pending_count=0;}
        res_logits[0]=a;res_logits[1]=b;res_logits[2]=c;res_logits[3]=d;res_logits[4]=e;
        u32 cls=0;for(u32 i=1;i<5;i++) if((i32)res_logits[i]>(i32)res_logits[cls])cls=i;
        u32 conf=logit_conf();pose_observe(rows,gate?0:cls,conf,gate);
        if(conf!=expected_conf || pose_active_cls!=expected_cls) {
            fprintf(stderr,"row %u mismatch conf=%u/%u cls=%u/%u\\n",rows,conf,
                    expected_conf,pose_active_cls,expected_cls);return 1;
        }
        rows++;
    }
    if(!feof(stdin)) return 2;
    printf("PASS: %u firmware confidence/pose rows\\n",rows);return 0;
}
""", encoding="utf-8")
    exe = out / "firmware_confidence_check.exe"
    command = (f'call "D:\\c++\\VC\\Auxiliary\\Build\\vcvars64.bat" >nul && '
               f'cl /nologo /std:c11 /O2 "{source}" /Fo:"{out / "check.obj"}" /Fe:"{exe}"')
    batch = out / "compile_check.bat"
    batch.write_text("@echo off\n" + command + "\n", encoding="utf-8")
    compiled = subprocess.run(["cmd", "/c", str(batch)], capture_output=True, text=True)
    if compiled.returncode:
        raise RuntimeError(compiled.stdout + compiled.stderr)
    rows = []
    for gate in gates:
        expected = replay_pose(pred, confidence, gate, threshold, confirm)
        for i, (z, conf, g, cls) in enumerate(zip(logits, confidence, gate, expected)):
            rows.append(" ".join(map(str, [int(i == 0), *z, int(g), int(conf), int(cls)])))
    check = subprocess.run([str(exe)], input="\n".join(rows)+"\n", text=True,
                           check=True, capture_output=True)
    return check.stdout.strip()


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--csv", default="report/emg017_20261022/EMG017_processed.csv")
    ap.add_argument("--out", default="data/metrics/board_confidence_validation_20261022.json")
    ap.add_argument("--c-check", action="store_true", help="cross-check actual firmware functions using MSVC")
    args = ap.parse_args()
    qp_path = ROOT / "data/models/nn_int8_board_multiwear/quant_params.json"
    qp = json.loads(qp_path.read_text(encoding="utf-8"))
    model = Int8MLP(qp)
    firmware = (ROOT / "sw/ps_uart_print/main.c").read_text(encoding="utf-8")
    contract = (ROOT / "sw/ps_uart_print/pose_contract.h").read_text(encoding="utf-8")
    const = lambda name, text: int(re.search(r"#define\s+" + name + r"\s+(\d+)u", text)[1])
    threshold, confirm = 30, 2  # Historical V1 policy, independent of current generated contract.
    if args.c_check and '20261022_POSE_STABLE_V2' in firmware:
        raise ValueError("V1 firmware has been replaced; use tools/validate_pose_stability.py for current C cross-check")
    discard, collect, floor = [const(k, firmware) for k in ("CAL_DISCARD_WIN", "CAL_WINDOWS", "CAL_FLOOR")]
    x, sample_y = read_capture(ROOT / args.csv)

    # Original published metric: trim each labeled bout by one second.
    stable_x, stable_y, _ = feature_windows(x, sample_y)
    stable_z = model.forward(stable_x)
    stable_conf = firmware_confidence(stable_z)
    stable_pred = stable_z.argmax(axis=1)

    # Replay every window on the fixed hardware time grid, including transitions.
    fx, _, _ = feature_windows(x, np.zeros(len(x), dtype=np.int8), trim=0)
    starts = np.arange(len(fx)) * HOP
    ends = starts + WINDOW - 1
    edges = np.r_[0, np.flatnonzero(sample_y[1:] != sample_y[:-1]) + 1, len(x)]
    bout_start = edges[np.searchsorted(edges, starts, side="right") - 1]
    bout_end = edges[np.searchsorted(edges, starts, side="right")]
    y = sample_y[ends]  # transition-inclusive diagnostic uses label at window end
    stable_mask = (starts >= bout_start + FS) & (ends < bout_end - FS)
    z = model.forward(fx)
    conf = firmware_confidence(z)
    pred = z.argmax(axis=1)

    # Hypothetical boot at CSV start: actual on-board baseline wasn't recorded.
    baseline = fx[discard:discard + collect, :8].astype(np.uint64).sum(axis=0) // collect
    mav_thresholds = np.maximum(3 * baseline, floor)
    mav_gate = np.all(fx[:, :8] < mav_thresholds, axis=1) & (pred != 0)
    ready = np.arange(len(fx)) >= discard + collect - 1
    evaluation = stable_mask & ready
    variants = {"int8_argmax": scores(y, pred, evaluation)}
    no_gate = np.zeros(len(pred), dtype=bool)
    for enabled, gate in ((False, no_gate), (True, mav_gate)):
        for t in sorted(set((0, 15, 20, 25, threshold, 35))):
            output = replay_pose(pred[ready], conf[ready], gate[ready], t, confirm)
            full_output = np.zeros(len(pred), dtype=np.int8)
            full_output[ready] = output
            key = f"legacy_t{t}_mav{int(enabled)}"
            variants[key] = scores(y, full_output, evaluation)
            variants[key]["output_switches_full_stream"] = int(np.count_nonzero(np.diff(output)))

    scaled = z.astype(np.float64) * qp["logits_scale"]
    exp = np.exp(scaled - scaled.max(axis=1, keepdims=True))
    softmax = (exp / exp.sum(axis=1, keepdims=True)).max(axis=1) * 100
    for t in (0, 50, 70, 80, 90):
        output = np.zeros(len(pred), dtype=np.int8)
        output[ready] = replay_pose(pred[ready], softmax[ready], no_gate[ready], t, confirm)
        variants[f"uncalibrated_softmax_t{t}"] = scores(y, output, evaluation)

    reject = stable_conf < threshold
    correct_action = (stable_pred == stable_y) & (stable_y != 0)
    subsets = {}
    for name, mask in [("all", np.ones(len(stable_y), dtype=bool)),
                       ("correct", stable_pred == stable_y), ("wrong", stable_pred != stable_y)] + [
                           (name, stable_y == i) for i, name in enumerate(qp["classes"])]:
        subsets[name] = {"windows": int(mask.sum()), "mean": float(stable_conf[mask].mean()),
                         "median": float(np.median(stable_conf[mask])),
                         "below_threshold_rate": float(reject[mask].mean())}
    result = {
        "source": args.csv, "classes": qp["classes"],
        "parameter_sha256": hashlib.sha256(qp_path.read_bytes()).hexdigest(),
        "original_stable_int8": scores(stable_y, stable_pred, np.ones(len(stable_y), dtype=bool)),
        "legacy_confidence": subsets,
        "correct_action_rejected_rate": float(reject[correct_action].mean()),
        "pose_policy": {"min_confidence": threshold, "confirm_windows": confirm,
                        "low_confidence_action": "immediate rest", "hop_ms": HOP * 1000 / FS},
        "mav_scenario": {"assumption": "boot/calibration at CSV start; not the recorded board baseline",
                         "first_calibration_windows_all_rest": bool(np.all(sample_y[:ends[discard + collect - 1] + 1] == 0)),
                         "baseline": baseline.tolist(), "thresholds": mav_thresholds.tolist(),
                         "calibration_discard_windows": discard, "calibration_collect_windows": collect},
        "continuous_replay": variants,
        "limitations": [
            "Raw argmax metric uses original per-bout window alignment; continuous replay uses one fixed grid.",
            "Continuous replay keeps state through transitions, scores only >=1s inside stable labels and after calibration.",
            "No actual board calibration baseline or packet timing available; MAV-on results are conditional.",
            "LCD 220ms geometric interpolation and rendering scheduling are not scored.",
            "Threshold/softmax sweeps are exploratory on EMG017; do not select production settings from this test.",
            "Softmax uses exported logits_scale; output probabilities are not calibrated.",
        ],
    }
    if args.c_check:
        result["firmware_c_crosscheck"] = check_firmware_c(
            firmware, z[ready], conf[ready], pred[ready],
            [no_gate[ready], mav_gate[ready]], threshold, confirm)
        print(result["firmware_c_crosscheck"])
    path = ROOT / args.out
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(result, indent=2), encoding="utf-8")
    print("original accuracy", result["original_stable_int8"]["accuracy"])
    print("correct action rejected", result["correct_action_rejected_rate"])
    for key, value in variants.items():
        print(key, "accuracy", round(value["accuracy"], 4), "recall", np.round(value["recall"], 4).tolist(),
              "rest false action", round(value["rest_false_action_rate"], 4))
    print("metrics ->", path)


if __name__ == "__main__":
    main()
