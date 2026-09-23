#!/usr/bin/env python3
"""Train the 5-class baseline classifier on NinaPro DB5 contract CSVs.

Pipeline mirrors the PL signal chain so PC results transfer to RTL:

  - 8 channels (contract channel_0..7 = Myo ring), 200 Hz
  - 200 ms window / 50 ms hop  ->  40 samples / 10 samples
  - per-channel features with the same integer definitions as the PL
    (src/rtl/emg_window_features.v, mirrored in tools/emg_reference.py):
      MAV = sum|x|, WL = sum|dx|, Energy = sum(x^2), ZC, SSC
    with thresholds zc_th = ssc_th = 0 (PL defaults)
  - only windows whose samples carry a single movement label are kept
    (cross-boundary windows are dropped)
  - leave-one-subject-out (LoSo) evaluation: subject-wise split, as the
    data contract requires; a final model is fitted on all subjects

Outputs:
  data/models/baseline_mlp.joblib   (StandardScaler + MLP pipeline)
  data/metrics/baseline.json        (config, per-fold and pooled metrics)

Usage:
  python tools/train_baseline.py
  python tools/train_baseline.py --hidden 64 32 --seed 0 --no-balance
  python tools/train_baseline.py --resample 20 --win-samples 400 \
         --hop-samples 100
         # NinaPro 200 Hz upsampled to the PL's native 4 kSPS rate so the
         # feature magnitudes match the RTL 400/100 windows (100 ms/25 ms)
  python tools/train_baseline.py --data-dir data/raw/board --fs 4000 \
         --win-samples 400 --hop-samples 100
         # own 4 kSPS board raw data at the native feature pace
"""

import argparse
import glob
import json
import os
import sys

import joblib
import numpy as np
from sklearn.metrics import accuracy_score, confusion_matrix, f1_score
from sklearn.neural_network import MLPClassifier
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RAW_DIR = os.path.join(ROOT, "data", "raw", "ninapro_db5")
MODEL_PATH = os.path.join(ROOT, "data", "models", "baseline_mlp.joblib")
METRICS_PATH = os.path.join(ROOT, "data", "metrics", "baseline.json")

CLASSES = ["rest", "open_hand", "fist", "wrist_flex", "wrist_extend"]
FS = 200
WINDOW_MS = 200
HOP_MS = 50
WINDOW = WINDOW_MS * FS // 1000   # 40 samples
HOP = HOP_MS * FS // 1000         # 10 samples
ZC_TH = 0
SSC_TH = 0

DATASET = {
    "name": "NinaPro DB5 (double Myo armband)",
    "source": "https://zenodo.org/records/1000116",
    "baseline_map": {"rest": 0, "open_hand": "E2 local 5 (global 17)",
                     "fist": "E2 local 6 (global 18)",
                     "wrist_flex": "E2 local 13 (global 25)",
                     "wrist_extend": "E2 local 14 (global 26)"},
}


def load_session_csv(path):
    """Read one contract CSV -> (x int32 (N,8), y int8 (N,))."""
    act_idx = {a: i for i, a in enumerate(CLASSES)}
    xs, ys = [], []
    with open(path) as fh:
        next(fh)  # header
        for line in fh:
            p = line.rstrip("\n").split(",")
            a = p[9]
            k = act_idx.get(a)
            if k is not None:
                xs.append(p[1:9])
                ys.append(k)
    return np.asarray(xs, dtype=np.int32), np.asarray(ys, dtype=np.int8)


def make_windows(x, y):
    """Window x, keep single-label windows, return (features, labels).

    Feature matrix is (n_windows, 5*8): MAV, WL, Energy, ZC, SSC per
    channel - integer definitions identical to the PL chain.
    """
    n = (len(x) - WINDOW) // HOP + 1
    idx = np.arange(WINDOW)[None, :] + HOP * np.arange(n)[:, None]
    yv = y[idx]
    single = (yv == yv[:, :1]).all(axis=1)
    idx = idx[single]
    w = x[idx]                                    # (n, WINDOW, 8)
    d = np.diff(w, axis=1)                        # (n, WINDOW-1, 8)
    mav = np.abs(w).sum(axis=1, dtype=np.int64)
    wl = np.abs(d).sum(axis=1, dtype=np.int64)
    energy = (w.astype(np.int64) ** 2).sum(axis=1)
    zc = (((w[:, :-1, :] < 0) != (w[:, 1:, :] < 0))
          & (np.abs(d) > ZC_TH)).sum(axis=1)
    s1 = w[:, 1:-1, :] - w[:, :-2, :]
    s2 = w[:, 2:, :] - w[:, 1:-1, :]
    ssc = (((s1 < 0) != (s2 < 0))
           & (np.abs(s1) > SSC_TH) & (np.abs(s2) > SSC_TH)).sum(axis=1)
    feat = np.concatenate([mav, wl, energy, zc, ssc], axis=1)
    return feat.astype(np.float64), yv[single, 0]


def balance_downsample(x, y, rng):
    """Cap the majority (rest) class at the median size of the others."""
    counts = {c: int((y == c).sum()) for c in np.unique(y)}
    others = [v for c, v in counts.items() if c != 0]
    cap = int(np.median(others)) if others else counts.get(0, 0)
    rest_idx = np.where(y == 0)[0]
    if len(rest_idx) <= cap:
        return x, y
    drop = rng.choice(rest_idx, len(rest_idx) - cap, replace=False)
    keep = np.setdiff1d(np.arange(len(y)), drop)
    return x[keep], y[keep]


def new_model(hidden, seed):
    return Pipeline([
        ("scaler", StandardScaler()),
        ("mlp", MLPClassifier(hidden_layer_sizes=tuple(hidden), max_iter=300,
                              early_stopping=True, random_state=seed)),
    ])


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--sessions", type=int, nargs="+", default=[2],
                    help="exercise sessions to use (default: 2 = the only "
                         "session containing all baseline movements)")
    ap.add_argument("--data-dir", default=None,
                    help="dataset root with s*/ subdirs (default: NinaPro "
                         "%s)" % os.path.relpath(RAW_DIR, ROOT))
    ap.add_argument("--fs", type=int, default=200,
                    help="sample rate of the input CSVs in Hz (default 200)")
    ap.add_argument("--win-samples", type=int, default=0,
                    help="window length in samples (default: 200 ms worth)")
    ap.add_argument("--hop-samples", type=int, default=0,
                    help="hop length in samples (default: 50 ms worth)")
    ap.add_argument("--decim", type=int, default=1,
                    help="decimate loaded samples by this factor before "
                         "windowing")
    ap.add_argument("--resample", type=int, default=1,
                    help="repeat every sample this many times before "
                         "windowing (e.g. 20: NinaPro 200 Hz upsampled to "
                         "the PL's native 4 kSPS feature pace)")
    ap.add_argument("--hidden", type=int, nargs="+", default=[64, 32])
    ap.add_argument("--seed", type=int, default=0)
    ap.add_argument("--no-balance", action="store_true",
                    help="keep the full rest majority in training")
    args = ap.parse_args()

    global FS, WINDOW, HOP
    FS = args.fs
    WINDOW = args.win_samples or WINDOW_MS * FS // 1000
    HOP = args.hop_samples or HOP_MS * FS // 1000
    eff_fs = FS * args.resample // args.decim   # rate the windowed stream represents
    data_dir = args.data_dir or RAW_DIR

    paths = sorted(glob.glob(os.path.join(data_dir, "s*",
                                          "*_E*_A1_baseline.csv")))
    # subject key from the s*/ directory name (filename prefixes collide,
    # e.g. S30 vs S3 in a mixed dataset)
    subjects = sorted({os.path.basename(os.path.dirname(p)) for p in paths})
    if len(subjects) < 2:
        print("need at least 2 converted subjects under %s" % data_dir)
        return 1

    data = {}
    for subj in subjects:
        xs, ys = [], []
        for e in args.sessions:
            path = os.path.join(data_dir, subj,
                                "%s_E%d_A1_baseline.csv" % (subj.upper(), e))
            x, y = load_session_csv(path)
            if args.decim > 1:
                x, y = x[::args.decim], y[::args.decim]
            if args.resample > 1:
                # sample-and-hold upsample: window sums scale by the same
                # factor as the RTL feature sums at the higher rate
                x = np.repeat(x, args.resample, axis=0)
                y = np.repeat(y, args.resample, axis=0)
            f, wy = make_windows(x, y)
            xs.append(f)
            ys.append(wy)
            print("%s E%d: %d windows kept" % (subj, e, len(wy)))
        data[subj] = (np.concatenate(xs), np.concatenate(ys))

    rng = np.random.default_rng(args.seed)
    folds = {}
    pooled_true, pooled_pred = [], []
    for test_subj in subjects:
        tr_x = np.concatenate([data[s][0] for s in subjects if s != test_subj])
        tr_y = np.concatenate([data[s][1] for s in subjects if s != test_subj])
        te_x, te_y = data[test_subj]
        if not args.no_balance:
            tr_x, tr_y = balance_downsample(tr_x, tr_y, rng)
        model = new_model(args.hidden, args.seed)
        model.fit(tr_x, tr_y)
        pred = model.predict(te_x)
        folds[test_subj] = {
            "test_windows": int(len(te_y)),
            "train_windows": int(len(tr_y)),
            "accuracy": round(float(accuracy_score(te_y, pred)), 4),
            "f1_macro": round(float(f1_score(te_y, pred, average="macro")), 4),
            "confusion": confusion_matrix(te_y, pred, labels=range(len(CLASSES))).tolist(),
        }
        print("LoSo %s: acc=%.3f f1_macro=%.3f" % (test_subj,
              folds[test_subj]["accuracy"], folds[test_subj]["f1_macro"]))
        pooled_true.append(te_y)
        pooled_pred.append(pred)

    pooled_true = np.concatenate(pooled_true)
    pooled_pred = np.concatenate(pooled_pred)
    pooled = {
        "accuracy": round(float(accuracy_score(pooled_true, pooled_pred)), 4),
        "f1_macro": round(float(f1_score(pooled_true, pooled_pred, average="macro")), 4),
        "confusion": confusion_matrix(pooled_true, pooled_pred,
                                      labels=range(len(CLASSES))).tolist(),
    }

    # final model on all subjects (LoSo above is the honest estimate)
    all_x = np.concatenate([data[s][0] for s in subjects])
    all_y = np.concatenate([data[s][1] for s in subjects])
    if not args.no_balance:
        all_x, all_y = balance_downsample(all_x, all_y, rng)
    final = new_model(args.hidden, args.seed)
    final.fit(all_x, all_y)
    os.makedirs(os.path.dirname(MODEL_PATH), exist_ok=True)
    joblib.dump(final, MODEL_PATH)

    metrics = {
        "dataset": DATASET,
        "config": {
            "fs_hz": FS, "decim": args.decim, "resample": args.resample,
            "effective_fs_hz": eff_fs,
            "window_samples": WINDOW, "hop_samples": HOP,
            "window_ms": WINDOW * 1000 // eff_fs, "hop_ms": HOP * 1000 // eff_fs,
            "features": ["mav_sum", "wl_sum", "energy_sum", "zc_count", "ssc_count"],
            "zc_th": ZC_TH, "ssc_th": SSC_TH,
            "model": "StandardScaler + MLP(%s)" % ",".join(map(str, args.hidden)),
            "balance": "rest downsampled to median class size" if not args.no_balance else "none",
            "sessions": args.sessions, "seed": args.seed,
            "evaluation": "leave-one-subject-out",
        },
        "classes": CLASSES,
        "folds": folds,
        "pooled": pooled,
        "model_path": os.path.relpath(MODEL_PATH, ROOT).replace("\\", "/"),
        "trained_on": "%d subjects, %d windows" % (len(subjects), len(all_y)),
    }
    os.makedirs(os.path.dirname(METRICS_PATH), exist_ok=True)
    with open(METRICS_PATH, "w") as fh:
        json.dump(metrics, fh, indent=2)

    print("pooled: acc=%.3f f1_macro=%.3f" % (pooled["accuracy"], pooled["f1_macro"]))
    print("confusion (rows=true, cols=pred; %s):" % ",".join(
        "%d=%s" % (i, c) for i, c in enumerate(CLASSES)))
    for i, row in enumerate(pooled["confusion"]):
        print("  %s: %s" % (CLASSES[i], row))
    print("model -> %s" % os.path.relpath(MODEL_PATH, ROOT))
    print("metrics -> %s" % os.path.relpath(METRICS_PATH, ROOT))
    return 0


if __name__ == "__main__":
    sys.exit(main())
