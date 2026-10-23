#!/usr/bin/env python3
"""End-to-end check of the emg_pl_export sim stream incl. the on-chip INT8 MLP.

Reads sim/results/export_out.csv (written by sim/emg_pl_export_tb.v) and:

  1. verifies every raw and feature word bit-exact against the integer
     reference chain (delegated to emg_reference.compare_export);
  2. groups the type-2 feature words into windows exactly as the RTL
     feeder does (window starts at id 0/ch 0, ends at id 4/ch 7, index
     = feature_id*8 + channel);
  3. replays the exact INT8 MLP semantics of src/rtl/emg_nn_infer.v with
     the quant_params.json beside the RTL's default MEM_FILE on the RTL's
     own feature values and compares the six type-3 result words
     (logits 0..4 + argmax class) bit-exact, matched by the window-start
     sequence number (the RTL stamps every result with it).

Pure stdlib: the one-window forward pass needs no numpy.

Usage: python tools/check_pl_nn_sim.py
"""

import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, "tools"))
import emg_reference

SIM_DIR = emg_reference.SIM_DIR
with open(os.path.join(ROOT, "src", "rtl", "emg_nn_infer.v"), encoding="utf-8") as fh:
    _match = re.search(r'parameter\s+MEM_FILE\s*=\s*"([^"]+)"', fh.read())
if not _match:
    raise ValueError("cannot determine RTL default model MEM_FILE")
QP_PATH = os.path.join(os.path.dirname(_match.group(1)), "quant_params.json")


def mul_shift(v, m, n):
    """(v*m + 2^(n-1)) >> n with floor semantics, mirroring emg_nn_infer.v
    (n == 0 means an exact scale: no half-round constant)."""
    half = 0 if n == 0 else (1 << (n - 1))
    return (v * m + half) >> n


class Int8MLPpy:
    """Pure-stdlib mirror of tools/export_int8.py Int8MLP.forward for one
    window (the RTL engine is a one-window engine too)."""

    def __init__(self, qp):
        self.m_in = qp["in_shift"]["m"]
        self.n_in = qp["in_shift"]["n"]
        self.w1 = qp["w1"]["q"]            # (40, 64), sklearn orientation
        self.b1 = qp["b1"]["b"]
        self.w2 = qp["w2"]["q"]            # (64, 32)
        self.b2 = qp["b2"]["b"]
        self.w3 = qp["w3"]["q"]            # (32, 5)
        self.b3 = qp["b3"]["b"]
        self.r1 = qp["requant"]["r1"]
        self.r2 = qp["requant"]["r2"]

    @staticmethod
    def _clip(v, lo, hi):
        return lo if v < lo else hi if v > hi else v

    def forward(self, x):
        xq = [self._clip(mul_shift(xi, m, n), -127, 127)
              for xi, m, n in zip(x, self.m_in, self.n_in)]
        acc1 = [self.b1[j] + sum(self.w1[i][j] * xq[i] for i in range(40))
                for j in range(64)]
        h1 = [self._clip(mul_shift(a, self.r1["m"], self.r1["n"]), 0, 127)
              for a in acc1]
        acc2 = [self.b2[j] + sum(self.w2[i][j] * h1[i] for i in range(64))
                for j in range(32)]
        h2 = [self._clip(mul_shift(a, self.r2["m"], self.r2["n"]), 0, 127)
              for a in acc2]
        return [self.b3[j] + sum(self.w3[i][j] * h2[i] for i in range(32))
                for j in range(5)]


def argmax5(logits):
    """numpy-argmax semantics: strict >, ties keep the lowest index."""
    best, amax = logits[0], 0
    for k in range(1, 5):
        if logits[k] > best:
            best, amax = logits[k], k
    return amax


def to_signed32(v):
    return v - (1 << 32) if v >= (1 << 31) else v


def group_windows(feat_rows):
    """feat_rows: [(ch, id, seq, payload)] in stream order.
    Returns (windows dict seq -> x[40], ordered window-start seqs)."""
    windows = {}
    order = []
    x = None
    x_seq = None
    for ch, fid, seq, payload in feat_rows:
        if fid == 0 and ch == 0:
            x = [0] * 40
            x_seq = seq
            order.append(seq)
        if x is None:
            continue
        x[fid * 8 + ch] = payload
        if fid == 4 and ch == 7:
            windows[x_seq] = x
            x = None
    return windows, order


def group_results(res_rows):
    """res_rows: [(ch, id, seq, payload)]. Returns {seq: {id: payload}}."""
    results = {}
    for _ch, fid, seq, payload in res_rows:
        results.setdefault(seq, {})[fid] = payload
    return results


def main():
    with open(QP_PATH) as fh:
        qp = json.load(fh)

    # 1) raw + feature words vs the integer reference chain
    emg_reference.compare_export()

    rows = emg_reference.read_csv_rows(os.path.join(SIM_DIR, "export_out.csv"), 5)
    feat_rows = [(r[1], r[2], r[3], r[4]) for r in rows if r[0] == 2]
    res_rows = [(r[1], r[2], r[3], r[4]) for r in rows if r[0] == 3]

    # 2) replay the on-chip INT8 MLP on the RTL's own feature windows
    windows, order = group_windows(feat_rows)
    if not windows:
        print("check-pl-nn FAILED: no complete feature window in the stream")
        sys.exit(1)

    results = group_results(res_rows)
    missing = [s for s in order if s not in results]
    extra = sorted(s for s in results if s not in windows)
    if missing:
        print(f"check-pl-nn FAILED: {len(missing)}/{len(order)} windows have "
              f"no result words (seqs {missing[:5]}...)")
        sys.exit(1)
    if extra:
        print(f"check-pl-nn FAILED: result words for unknown windows "
              f"(seqs {extra[:5]}...)")
        sys.exit(1)

    net = Int8MLPpy(qp)
    errors = 0
    for seq in order:
        got = results[seq]
        if set(got) != set(range(6)):
            print(f"check-pl-nn FAILED: window seq {seq}: result ids "
                  f"{sorted(got)} != 0..5")
            sys.exit(1)
        want = net.forward(windows[seq])
        want_cls = argmax5(want)
        win_err = []
        for k in range(5):
            if to_signed32(got[k]) != want[k]:
                win_err.append(f"logit[{k}] got {to_signed32(got[k])} "
                               f"want {want[k]}")
        if got[5] != want_cls:
            win_err.append(f"class got {got[5]} want {want_cls}")
        if win_err:
            errors += 1
            print(f"check-pl-nn FAILED: window seq {seq}: "
                  + "; ".join(win_err))
        else:
            print(f"PASS window seq {seq}: class {want_cls} "
                  f"logits {want}")

    if errors:
        print(f"check-pl-nn FAILED: {errors}/{len(order)} windows mismatched")
        sys.exit(1)
    print(f"check-pl-nn PASSED: {len(order)} windows x (5 logits + class) "
          f"bit-exact vs the INT8 model")
    sys.exit(0)


if __name__ == "__main__":
    main()
