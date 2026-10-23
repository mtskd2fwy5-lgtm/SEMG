#!/usr/bin/env python3
"""Train a deployable 5-class model from labeled board waveform CSV captures."""
import argparse
import csv
import json
from pathlib import Path

import joblib
import numpy as np
from sklearn.metrics import accuracy_score, classification_report, confusion_matrix, f1_score
from sklearn.neural_network import MLPClassifier
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler

ROOT = Path(__file__).resolve().parents[1]
CLASSES = ["rest", "open_hand", "fist", "wrist_flex", "wrist_extend"]
CLASS_TO_ID = {name: i for i, name in enumerate(CLASSES)}
CHANNELS = [f"channel_{i}" for i in range(8)]
FS = 4000
WINDOW = 400
HOP = 100


def read_capture(path):
    with open(path, newline="", encoding="utf-8") as fh:
        reader = csv.DictReader(fh)
        required = set(CHANNELS + ["action", "source"])
        if not required.issubset(reader.fieldnames or []):
            raise ValueError(f"{path}: missing required columns")
        signals, labels = [], []
        for row in reader:
            if row["source"] != "processed":
                raise ValueError(f"{path}: expected processed signal, got {row['source']!r}")
            label = row["action"]
            if label not in CLASS_TO_ID:
                raise ValueError(f"{path}: unsupported action label {label!r}")
            signals.append([int(row[c]) for c in CHANNELS])
            labels.append(CLASS_TO_ID[label])
    x = np.asarray(signals, dtype=np.int32)
    y = np.asarray(labels, dtype=np.int8)
    if len(x) == 0:
        raise ValueError(f"{path}: no samples")
    return x, y


def feature_windows(x, y, trim=FS):
    """Extract PL-matched MAV/WL/Energy/ZC/SSC features within stable bouts."""
    edges = np.r_[0, np.flatnonzero(y[1:] != y[:-1]) + 1, len(y)]
    features, labels, bouts = [], [], []
    for bout_id, (start, end) in enumerate(zip(edges[:-1], edges[1:])):
        start, end = int(start + trim), int(end - trim)
        label = int(y[int(edges[bout_id])])
        if end - start < WINDOW:
            continue
        for offset in range(start, end - WINDOW + 1, HOP):
            w = x[offset:offset + WINDOW].astype(np.int64)
            d = np.diff(w, axis=0)
            mav = np.abs(w).sum(axis=0)
            wl = np.abs(d).sum(axis=0)
            energy = (w * w).sum(axis=0)
            zc = ((w[:-1] < 0) != (w[1:] < 0)).sum(axis=0)
            s1, s2 = w[1:-1] - w[:-2], w[2:] - w[1:-1]
            ssc = (((s1 < 0) != (s2 < 0)) & (s1 != 0) & (s2 != 0)).sum(axis=0)
            features.append(np.concatenate((mav, wl, energy, zc, ssc)))
            labels.append(label)
            bouts.append(bout_id)
    if not features:
        raise ValueError("no complete stable windows found")
    return np.asarray(features, dtype=np.float64), np.asarray(labels), np.asarray(bouts)


def balance_rest(x, y, seed):
    rng = np.random.default_rng(seed)
    rest = np.flatnonzero(y == CLASS_TO_ID["rest"])
    moving_counts = [int(np.count_nonzero(y == c)) for c in range(1, len(CLASSES))]
    if not rest.size or not any(moving_counts):
        raise ValueError("training data must include rest and movement classes")
    cap = int(np.median(moving_counts))
    if len(rest) > cap:
        rest = np.sort(rng.choice(rest, size=cap, replace=False))
    keep = np.sort(np.r_[np.flatnonzero(y != CLASS_TO_ID["rest"]), rest])
    return x[keep], y[keep]


def remove_spike_windows(x, y, ratio=12.0):
    """Drop isolated windows whose per-channel MAV is an extreme class outlier."""
    amplitude = x[:, :8] / WINDOW
    keep = np.ones(len(y), dtype=bool)
    limits = {}
    for cls in np.unique(y):
        idx = np.flatnonzero(y == cls)
        med = np.median(amplitude[idx], axis=0)
        limit = np.maximum(med * ratio, med + 12.0 * np.median(
            np.abs(amplitude[idx] - med), axis=0))
        bad = np.any(amplitude[idx] > limit, axis=1)
        keep[idx[bad]] = False
        limits[CLASSES[int(cls)]] = limit.tolist()
    return x[keep], y[keep], int((~keep).sum()), limits


def new_model(seed):
    return Pipeline([
        ("scaler", StandardScaler()),
        ("mlp", MLPClassifier(hidden_layer_sizes=(64, 32), max_iter=300,
                               early_stopping=True, random_state=seed)),
    ])


def eval_model(model, x, y):
    pred = model.predict(x)
    report = classification_report(y, pred, labels=range(5), target_names=CLASSES,
                                   output_dict=True, zero_division=0)
    return {
        "windows": int(len(y)),
        "accuracy": float(accuracy_score(y, pred)),
        "macro_f1": float(f1_score(y, pred, average="macro")),
        "confusion": confusion_matrix(y, pred, labels=range(5)).tolist(),
        "per_class": {c: {k: float(report[c][k]) for k in ("precision", "recall", "f1-score", "support")}
                      for c in CLASSES},
    }


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--train-csvs", nargs="+", default=[
        "report/emg008_20261022/EMG008_processed.csv",
        "report/emg009_20261022/EMG009_processed.csv",
        "report/emg012_20261022/EMG012_processed.csv",
        "report/emg013_20261022/EMG013_processed.csv",
        "report/emg014_20261022/EMG014_processed.csv",
        "report/emg015_20261022/EMG015_processed.csv",
        "report/emg016_20261022/EMG016_processed.csv",
    ])
    ap.add_argument("--test-csvs", nargs="*", default=[
        "report/emg017_20261022/EMG017_processed.csv",
    ])
    ap.add_argument("--model", default="data/models/emg008_009_multiwear.joblib")
    ap.add_argument("--metrics", default="data/metrics/emg008_009_multiwear.json")
    ap.add_argument("--seed", type=int, default=20261023)
    args = ap.parse_args()

    train_x, train_y, holdout_x, holdout_y = [], [], [], []
    train_sources, spike_drops = [], {}
    test_data = {}
    capture_counts = {}
    for value in args.train_csvs:
        path = (ROOT / value).resolve()
        x, y = read_capture(path)
        fx, fy, _ = feature_windows(x, y)
        holdout_x.append(fx)
        holdout_y.append(fy)
        capture_counts[path.stem] = {CLASSES[i]: int(np.count_nonzero(fy == i)) for i in range(5)}
        fx, fy, dropped, limits = remove_spike_windows(fx, fy)
        train_x.append(fx)
        train_y.append(fy)
        spike_drops[path.stem] = {"windows_before_filter": int(len(holdout_y[-1]),),
                                  "windows_removed": dropped,
                                  "windows_retained": int(len(fy)),
                                  "max_channel_mav_ratio": 12.0,
                                  "mav_limits_by_class": limits}
        train_sources.append(str(path.relative_to(ROOT)))
    for value in args.test_csvs:
        path = (ROOT / value).resolve()
        x, y = read_capture(path)
        fx, fy, _ = feature_windows(x, y)
        test_data[path.stem] = (fx, fy)
        capture_counts[path.stem] = {CLASSES[i]: int(np.count_nonzero(fy == i)) for i in range(5)}

    x_train, y_train = np.concatenate(train_x), np.concatenate(train_y)
    x_bal, y_bal = balance_rest(x_train, y_train, args.seed)
    model = new_model(args.seed)
    model.fit(x_bal, y_bal)

    # Leave out whole captures; overlapping windows never cross this split.
    capture_holdout = {}
    if len(train_x) > 1:
        for idx, test_name in enumerate(args.train_csvs):
            fold_x = np.concatenate([a for i, a in enumerate(train_x) if i != idx])
            fold_y = np.concatenate([a for i, a in enumerate(train_y) if i != idx])
            fx, fy = balance_rest(fold_x, fold_y, args.seed)
            fold_model = new_model(args.seed)
            fold_model.fit(fx, fy)
            capture_holdout[Path(test_name).stem] = eval_model(
                fold_model, holdout_x[idx], holdout_y[idx])

    external = {name: eval_model(model, *data) for name, data in test_data.items()}
    model_path, metrics_path = ROOT / args.model, ROOT / args.metrics
    model_path.parent.mkdir(parents=True, exist_ok=True)
    metrics_path.parent.mkdir(parents=True, exist_ok=True)
    joblib.dump(model, model_path)
    metrics = {
        "dataset": train_sources,
        "signal": "processed: notch50 + comb50 + HP20 + LP215",
        "contract": {"sample_rate_hz": FS, "channels": 8, "window_samples": WINDOW,
                     "hop_samples": HOP, "features": ["MAV", "WL", "Energy", "ZC", "SSC"],
                     "classifier": "StandardScaler + MLP(64,32)", "trim_s_each_bout_edge": 1,
                     "rest_balancing": "downsample to median movement class count",
                     "spike_filter": "remove a window if any channel MAV exceeds 12x that capture/class/channel median"},
        "capture_windows_by_class": capture_counts,
        "spike_filter": spike_drops,
        "train_windows": int(len(y_train)),
        "balanced_train_windows": int(len(y_bal)),
        "whole_capture_holdout_cv": capture_holdout,
        "external_holdout": external,
        "final_fit_resubstitution": eval_model(model, x_train, y_train),
        "note": "Overlapping windows are correlated. Final-fit metrics are diagnostic only; use whole-capture holdouts for generalization.",
        "model_path": str(model_path.relative_to(ROOT)),
    }
    metrics_path.write_text(json.dumps(metrics, indent=2), encoding="utf-8")
    print(json.dumps({"model": str(model_path), "metrics": str(metrics_path),
                      "whole_capture_holdout_cv": {k: {"accuracy": v["accuracy"], "macro_f1": v["macro_f1"]}
                                                   for k, v in capture_holdout.items()},
                      "external_holdout": {k: {"accuracy": v["accuracy"], "macro_f1": v["macro_f1"]}
                                           for k, v in external.items()}}, indent=2))


if __name__ == "__main__":
    main()
