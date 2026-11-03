#!/usr/bin/env python3
"""Validate temporal feature stacking without changing the production model.

Each feature window has 40 values (five features for eight channels).  A
stack of four consecutive windows produces a 160-value input covering about
175 ms at the current 100 ms window / 25 ms hop contract.  Windows are built
from the continuous ``*_full.csv`` stream and a stack is kept only when all
four windows are adjacent, pure, and have the same label.

The script compares a one-window MLP and the requested multi-window MLP with
the same leave-one-subject-out split.  It writes metrics only; it does not
write model weights or modify the production INT8 assets.

Example:
  python tools/evaluate_temporal_stack.py --subjects s1 s2 s3 --stack 4
"""

import argparse
import csv
import glob
import json
import os
import sys

import joblib
import numpy as np
from sklearn.metrics import accuracy_score, confusion_matrix, f1_score

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import train_baseline


CLASSES = train_baseline.CLASSES
RAW_DIR = train_baseline.RAW_DIR


def window_records(x, y, window, hop):
    """Return all windows, including impure ones, with their start indices.

    Keeping impure windows in the returned arrays is important: temporal
    stacking must not bridge over an omitted transition window.
    """
    x = np.asarray(x, dtype=np.int32)
    y = np.asarray(y, dtype=np.int8)
    n = (len(x) - window) // hop + 1
    if n <= 0:
        empty = np.empty((0, 40), dtype=np.float64)
        return empty, np.empty(0, dtype=np.int8), np.empty(0, dtype=np.int64), np.empty(0, dtype=bool)

    starts = np.arange(n, dtype=np.int64) * hop
    idx = starts[:, None] + np.arange(window, dtype=np.int64)[None, :]
    yv = y[idx]
    pure = (yv == yv[:, :1]).all(axis=1) & (yv[:, 0] >= 0)
    w = x[idx]
    d = np.diff(w, axis=1)
    mav = np.abs(w).sum(axis=1, dtype=np.int64)
    wl = np.abs(d).sum(axis=1, dtype=np.int64)
    energy = (w.astype(np.int64) ** 2).sum(axis=1)
    zc = (((w[:, :-1, :] < 0) != (w[:, 1:, :] < 0))
          & (np.abs(d) > train_baseline.ZC_TH)).sum(axis=1)
    s1 = w[:, 1:-1, :] - w[:, :-2, :]
    s2 = w[:, 2:, :] - w[:, 1:-1, :]
    ssc = (((s1 < 0) != (s2 < 0))
           & (np.abs(s1) > train_baseline.SSC_TH)
           & (np.abs(s2) > train_baseline.SSC_TH)).sum(axis=1)
    feat = np.concatenate([mav, wl, energy, zc, ssc], axis=1)
    return feat.astype(np.float64), yv[:, 0], starts, pure


def stack_records(feat, labels, starts, pure, stack, hop):
    """Stack adjacent windows without crossing invalid or label boundaries."""
    if stack < 1:
        raise ValueError("stack must be >= 1")
    if len(feat) < stack:
        return np.empty((0, feat.shape[1] * stack)), np.empty(0, dtype=np.int8)

    xs, ys = [], []
    for end in range(stack - 1, len(feat)):
        begin = end - stack + 1
        if starts[end] - starts[begin] != hop * (stack - 1):
            continue
        if not np.all(pure[begin:end + 1]):
            continue
        window_labels = labels[begin:end + 1]
        if not np.all(window_labels == window_labels[-1]):
            continue
        xs.append(feat[begin:end + 1].reshape(-1))
        ys.append(labels[end])
    if not xs:
        return np.empty((0, feat.shape[1] * stack)), np.empty(0, dtype=np.int8)
    return np.asarray(xs, dtype=np.float64), np.asarray(ys, dtype=np.int8)


def load_full_session(data_dir, subject, session, fs, decim, resample,
                      pl_filter, window, hop, stack):
    path = os.path.join(
        data_dir, subject, "%s_E%d_A1_full.csv" % (subject.upper(), session))
    x, y = train_baseline.load_full_session_csv(path)
    x, y = train_baseline.prepare_samples(
        x, y, decim=decim, resample=resample, pl_filter=pl_filter, fs=fs)
    feat, labels, starts, pure = window_records(x, y, window, hop)
    return stack_records(feat, labels, starts, pure, stack, hop)


def load_subject_data(data_dir, subject, sessions, fs, decim, resample,
                      pl_filter, window, hop, stack):
    parts = []
    for session in sessions:
        x, y = load_full_session(
            data_dir, subject, session, fs, decim, resample, pl_filter,
            window, hop, stack)
        parts.append((x, y))
        print("%s E%d stack=%d: %d samples" %
              (subject, session, stack, len(y)))
    if not parts:
        return np.empty((0, 40 * stack)), np.empty(0, dtype=np.int8)
    return np.concatenate([p[0] for p in parts]), np.concatenate([p[1] for p in parts])


def evaluate(data, subjects, hidden, seed, no_balance):
    rng = np.random.default_rng(seed)
    folds = {}
    pooled_true, pooled_pred = [], []
    for test_subject in subjects:
        train_subjects = [s for s in subjects if s != test_subject]
        train_x = np.concatenate([data[s][0] for s in train_subjects])
        train_y = np.concatenate([data[s][1] for s in train_subjects])
        test_x, test_y = data[test_subject]
        if not no_balance:
            train_x, train_y = train_baseline.balance_downsample(
                train_x, train_y, rng)
        model = train_baseline.new_model(hidden, seed)
        model.fit(train_x, train_y)
        pred = model.predict(test_x)
        folds[test_subject] = {
            "train_windows": int(len(train_y)),
            "test_windows": int(len(test_y)),
            "accuracy": round(float(accuracy_score(test_y, pred)), 4),
            "f1_macro": round(float(f1_score(test_y, pred, average="macro")), 4),
            "confusion": confusion_matrix(
                test_y, pred, labels=range(len(CLASSES))).tolist(),
        }
        print("LoSo %s: acc=%.4f f1_macro=%.4f" % (
            test_subject, folds[test_subject]["accuracy"],
            folds[test_subject]["f1_macro"]))
        pooled_true.append(test_y)
        pooled_pred.append(pred)

    y_true = np.concatenate(pooled_true)
    y_pred = np.concatenate(pooled_pred)
    pooled = {
        "accuracy": round(float(accuracy_score(y_true, y_pred)), 4),
        "f1_macro": round(float(f1_score(y_true, y_pred, average="macro")), 4),
        "confusion": confusion_matrix(
            y_true, y_pred, labels=range(len(CLASSES))).tolist(),
    }
    return folds, pooled


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--sessions", type=int, nargs="+", default=[2])
    ap.add_argument("--subjects", nargs="+", default=None)
    ap.add_argument("--data-dir", default=RAW_DIR)
    ap.add_argument("--fs", type=int, default=200)
    ap.add_argument("--decim", type=int, default=1)
    ap.add_argument("--resample", type=int, default=1)
    ap.add_argument("--win-samples", type=int, default=0)
    ap.add_argument("--hop-samples", type=int, default=0)
    ap.add_argument("--pl-filter", action="store_true")
    ap.add_argument("--stack", type=int, default=4)
    ap.add_argument("--hidden", type=int, nargs="+", default=[64, 32])
    ap.add_argument("--seed", type=int, default=0)
    ap.add_argument("--no-balance", action="store_true")
    ap.add_argument("--metrics-path", default=os.path.join(
        train_baseline.ROOT, "data", "metrics", "temporal_stack_validation.json"))
    args = ap.parse_args()

    if args.stack < 2:
        raise SystemExit("--stack must be >= 2; use train_baseline.py for one-window baseline")

    train_baseline.FS = args.fs
    window = args.win_samples or train_baseline.WINDOW_MS * args.fs // 1000
    hop = args.hop_samples or train_baseline.HOP_MS * args.fs // 1000
    data_dir = os.path.abspath(args.data_dir)
    paths = sorted(glob.glob(os.path.join(data_dir, "s*", "*_E*_A1_full.csv")))
    subjects = sorted({os.path.basename(os.path.dirname(p)) for p in paths})
    if args.subjects:
        requested = {s.lower() for s in args.subjects}
        subjects = [s for s in subjects if s.lower() in requested]
    if len(subjects) < 2:
        raise SystemExit("need at least two subjects with *_full.csv")

    print("subjects: %s" % subjects)
    print("contract: fs=%d resample=%d window=%d hop=%d pl_filter=%s" %
          (args.fs, args.resample, window, hop, args.pl_filter))

    # Build the one-window reference and the temporal stack on the same full
    # streams so that the comparison measures temporal context, not a change
    # in source data or label filtering.
    single = {}
    stacked = {}
    for subject in subjects:
        single[subject] = load_subject_data(
            data_dir, subject, args.sessions, args.fs, args.decim,
            args.resample, args.pl_filter, window, hop, 1)
        stacked[subject] = load_subject_data(
            data_dir, subject, args.sessions, args.fs, args.decim,
            args.resample, args.pl_filter, window, hop, args.stack)

    print("\n=== single-window reference ===")
    single_folds, single_pooled = evaluate(
        single, subjects, args.hidden, args.seed, args.no_balance)
    print("single pooled: acc=%.4f f1_macro=%.4f" %
          (single_pooled["accuracy"], single_pooled["f1_macro"]))
    print("\n=== temporal stack (%d windows) ===" % args.stack)
    stack_folds, stack_pooled = evaluate(
        stacked, subjects, args.hidden, args.seed, args.no_balance)
    print("stack pooled: acc=%.4f f1_macro=%.4f" %
          (stack_pooled["accuracy"], stack_pooled["f1_macro"]))

    eff_fs = args.fs * args.resample // args.decim
    report = {
        "config": {
            "sessions": args.sessions,
            "subjects": subjects,
            "seed": args.seed,
            "hidden": args.hidden,
            "fs_hz": args.fs,
            "decim": args.decim,
            "resample": args.resample,
            "effective_fs_hz": eff_fs,
            "window_samples": window,
            "hop_samples": hop,
            "window_ms": window * 1000 // eff_fs,
            "hop_ms": hop * 1000 // eff_fs,
            "stack_windows": args.stack,
            "stack_context_ms": ((args.stack - 1) * hop + window) * 1000 // eff_fs,
            "pl_filter": args.pl_filter,
            "source": "continuous *_full.csv; stacks do not cross impure windows",
            "balance": "rest downsampled to median class size" if not args.no_balance else "none",
            "evaluation": "leave-one-subject-out",
        },
        "single_window": {"folds": single_folds, "pooled": single_pooled},
        "temporal_stack": {"folds": stack_folds, "pooled": stack_pooled},
        "delta": {
            "accuracy": round(stack_pooled["accuracy"] - single_pooled["accuracy"], 4),
            "f1_macro": round(stack_pooled["f1_macro"] - single_pooled["f1_macro"], 4),
        },
    }
    os.makedirs(os.path.dirname(args.metrics_path), exist_ok=True)
    with open(args.metrics_path, "w", encoding="utf-8") as fh:
        json.dump(report, fh, indent=2)
    print("metrics -> %s" % os.path.relpath(args.metrics_path, train_baseline.ROOT))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

