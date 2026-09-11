#!/usr/bin/env python3
"""Export the trained baseline model to .mat for MATLAB visualization.

Writes data/models/model_params.mat with:
  W1 (40x64) b1 (1x64) W2 (64x32) b2 (1x32) W3 (32x5) b3 (1x5)
  scaler_mean (1x40) scaler_scale (1x40)
  windows  : struct with one 40x8 double matrix per class, taken from the
             middle of each movement's continuous block in S1_E2 (S1 is
             never in training, so this shows honest cross-subject behavior)
  classes  : 1x5 cell array of class names

Usage:  python tools/export_model_mat.py
Then:   tools/visualize_inference.m (MATLAB) reads the same file.
"""

import json
import os
import sys

import joblib
import numpy as np
from scipy.io import savemat

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MODEL_PATH = os.path.join(ROOT, "data", "models", "baseline_mlp.joblib")
CSV_PATH = os.path.join(ROOT, "data", "raw", "ninapro_db5", "s1", "S1_E2_A1_baseline.csv")
OUT_PATH = os.path.join(ROOT, "data", "models", "model_params.mat")

CLASSES = ["rest", "open_hand", "fist", "wrist_flex", "wrist_extend"]
WINDOW = 40  # 200 ms @ 200 Hz


def main():
    if not os.path.exists(MODEL_PATH):
        print("model not found - run tools/train_baseline.py first")
        return 1
    m = joblib.load(MODEL_PATH)
    scaler, mlp = m.named_steps["scaler"], m.named_steps["mlp"]
    W1, W2, W3 = mlp.coefs_
    b1, b2, b3 = mlp.intercepts_

    # one representative window per class from the held-out subject S1
    per_class = {a: [] for a in CLASSES}
    with open(CSV_PATH) as fh:
        next(fh)
        for line in fh:
            p = line.rstrip("\n").split(",")
            if p[9] in per_class:
                per_class[p[9]].append([int(v) for v in p[1:9]])
    windows = {}
    for a in CLASSES:
        x = np.asarray(per_class[a], dtype=np.float64)
        s = (len(x) - WINDOW) // 2
        windows[a] = x[s:s + WINDOW]           # (40, 8)

    savemat(OUT_PATH, {
        "W1": W1, "b1": b1.reshape(1, -1),
        "W2": W2, "b2": b2.reshape(1, -1),
        "W3": W3, "b3": b3.reshape(1, -1),
        "scaler_mean": scaler.mean_.reshape(1, -1),
        "scaler_scale": scaler.scale_.reshape(1, -1),
        "windows": windows,
        "classes": np.array(CLASSES, dtype=object).reshape(1, -1),
        "meta": np.array([["NinaPro DB5 s1", "S1_E2", "MLP 40-64-32-5",
                           "window 200ms hop 50ms @200Hz"]], dtype=object),
    })
    print("exported %s" % os.path.relpath(OUT_PATH, ROOT))
    print("params: W1%s W2%s W3%s" % (W1.shape, W2.shape, W3.shape))
    return 0


if __name__ == "__main__":
    sys.exit(main())
