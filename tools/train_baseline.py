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
  data/models/baseline_mlp_pl_filter.joblib and
  data/metrics/baseline_pl_filter.json when --pl-filter is enabled

Usage:
  python tools/train_baseline.py
  python tools/train_baseline.py --hidden 64 32 --seed 0 --no-balance
  python tools/train_baseline.py --resample 20 --win-samples 400 \
         --hop-samples 100
         # NinaPro 200 Hz upsampled to the PL's native 4 kSPS rate so the
         # feature magnitudes match the RTL 400/100 windows (100 ms/25 ms)
  python tools/train_baseline.py --resample 20 --win-samples 400 \
         --hop-samples 100 --pl-filter
         # exact RTL integer bandpass after the 4 kSPS sample-and-hold stream
  python tools/train_baseline.py --data-dir data/raw/board --input-mode waveform --fs 4000 \
         --win-samples 400 --hop-samples 100 --notch50 --pl-filter
         # raw input: notch then bandpass; verified notch50 CSV: bandpass only
         # use continuous captures (--keep-all) to retain filter state
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
from sklearn.neural_network import MLPClassifier
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from emg_reference import Bandpass, Notch50, NotchComb, ProcessedSignal

RAW_DIR = os.path.join(ROOT, "data", "raw", "ninapro_db5")
MODEL_PATH = os.path.join(ROOT, "data", "models", "baseline_mlp.joblib")
METRICS_PATH = os.path.join(ROOT, "data", "metrics", "baseline.json")
PL_FILTER_MODEL_PATH = os.path.join(
    ROOT, "data", "models", "baseline_mlp_pl_filter.joblib")
PL_FILTER_METRICS_PATH = os.path.join(
    ROOT, "data", "metrics", "baseline_pl_filter.json")

CLASSES = ["rest", "open_hand", "fist", "wrist_flex", "wrist_extend"]
FULL_BASELINE_CODES = {
    2: {0: 0, 5: 1, 6: 2, 13: 3, 14: 4},
}
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


def load_session_csv(path, keep_unknown=False):
    """Read one contract CSV -> (x int32 (N,8), y int8 (N,))."""
    act_idx = {a: i for i, a in enumerate(CLASSES)}
    xs, ys = [], []
    with open(path) as fh:
        next(fh)  # header
        for line in fh:
            p = line.rstrip("\n").split(",")
            a = p[9]
            k = act_idx.get(a, -1)
            if k >= 0 or keep_unknown:
                xs.append(p[1:9])
                ys.append(k)
    return np.asarray(xs, dtype=np.int32), np.asarray(ys, dtype=np.int8)


def load_full_session_csv(path):
    """Read a continuous stream, retaining non-target labels as -1."""
    xs, ys = [], []
    channels = ["channel_%d" % i for i in range(8)]
    with open(path, newline="") as fh:
        for row in csv.DictReader(fh):
            exercise = int(row["exercise"].lstrip("eE"))
            code = int(row["restimulus"])
            xs.append([row[c] for c in channels])
            ys.append(FULL_BASELINE_CODES.get(exercise, {}).get(code, -1))
    return np.asarray(xs, dtype=np.int32), np.asarray(ys, dtype=np.int8)


def load_training_session(data_dir, subject, session, input_mode,
                          with_metadata=False, keep_unknown=False):
    """Load one session from the selected dataset representation."""
    if input_mode not in ("baseline", "full", "waveform"):
        raise ValueError("unsupported input mode: %s" % input_mode)
    suffix = input_mode
    path = os.path.join(
        data_dir, subject, "%s_E%d_A1_%s.csv" %
        (subject.upper(), session, suffix))
    if input_mode == "full":
        x, y = load_full_session_csv(path)
    else:
        x, y = load_session_csv(path, keep_unknown=keep_unknown)
    if not with_metadata:
        return x, y
    sidecar = os.path.splitext(path)[0] + ".json"
    meta = {}
    if os.path.exists(sidecar):
        with open(sidecar, encoding="utf-8") as fh:
            meta = json.load(fh)
        if not isinstance(meta, dict):
            raise ValueError("%s: expected a metadata object" % sidecar)
    return x, y, meta


def apply_pl_bandpass(x):
    """Apply the exact RTL bandpass independently to every channel."""
    x = np.asarray(x, dtype=np.int32)
    out = np.empty(x.shape, dtype=np.int32)
    for ch in range(x.shape[1]):
        bp = Bandpass()
        for i, sample in enumerate(x[:, ch]):
            out[i, ch] = bp.step(int(sample))
    return out


def notch_model(notch50):
    if notch50 == "processed":
        return ProcessedSignal
    return NotchComb if notch50 == "notchcomb" else Notch50


def apply_pl_notch50(x, notch50=True):
    """Apply the tested RTL integer notch with independent channel states."""
    x = np.asarray(x, dtype=np.int32)
    out = np.empty(x.shape, dtype=np.int32)
    for ch in range(x.shape[1]):
        filt = notch_model(notch50)()
        for i, sample in enumerate(x[:, ch]):
            out[i, ch] = filt.step(int(sample))
    return out


def check_sample_contract(fs, decim, resample, pl_filter=False, notch50=False,
                          metadata=None):
    """Check rates and provenance; return whether input already has this notch.

    Missing signal/filter fields retain the historical dataset contract.
    An explicitly filtered recording must identify the exact filter, so it
    cannot silently enter a legacy model or be notched a second time.
    """
    if min(fs, decim, resample) < 1 or (fs * resample) % decim:
        raise ValueError("fs/decim/resample must give a positive integer sample rate")
    if pl_filter and fs * resample // decim != 4000:
        raise ValueError("the PL bandpass requires an effective sample rate of 4000 Hz")
    if notch50 and fs * resample != 4000:
        raise ValueError("notch50 requires 4000 Hz before decimation (fs * resample)")
    meta = metadata or {}
    if meta.get("sample_rate_hz", fs) != fs:
        raise ValueError("CSV metadata sample_rate_hz disagrees with --fs")
    signal = meta.get("signal")
    filt = meta.get("filter")
    if signal not in (None, "raw", "notch50", "notchcomb", "processed"):
        raise ValueError("unsupported input signal: %s" % signal)
    already = signal in ("notch50", "notchcomb", "processed")
    if already:
        if not notch50:
            raise ValueError("notch50 CSV requires --notch50 to record the model contract")
        expected_signal = notch50 if isinstance(notch50, str) else "notch50"
        if signal != expected_signal:
            raise ValueError("CSV signal does not match the selected --notch50/--notch-comb contract")
        if not isinstance(filt, dict) or filt.get("id") != notch_model(notch50).FILTER_ID:
            raise ValueError("notch50 CSV has a missing or incompatible filter id")
        if fs != 4000 or resample != 1 or filt.get("sample_rate_hz") != 4000:
            raise ValueError("pre-filtered notch50 CSV must be native 4000 Hz")
    elif filt is not None:
        raise ValueError("input filter metadata conflicts with the raw/legacy signal")
    if notch50 and (meta.get("keep_all") is False or
                    meta.get("dropped_non_baseline", 0) > 0):
        raise ValueError("notch50 training requires a continuous CSV; retain all rows")
    if notch50 and any(meta.get(k, 0) for k in
                       ("sequence_gaps", "sequence_backwards", "sequence_duplicates",
                        "frames_backward_uart", "frames_duplicate_uart", "frames_dropped_uart")):
        raise ValueError("SD recording has sequence discontinuities; split into continuous segments first")
    return already


def filter_contract(pl_filter=False, notch50=False):
    if notch50 == "processed":
        return ("sample-hold to 4000 Hz; exact RTL notch50 Q10 -> comb50 BW1 -> "
                "HP20/LP215 unless verified processed CSV; decimate; no second bandpass")
    if notch50:
        return ("sample-hold to 4000 Hz; exact RTL " + notch_model(notch50).FILTER_ID + " unless the CSV "
                "identifies that filter; decimate; " +
                ("exact RTL integer bandpass" if pl_filter else "no bandpass"))
    return ("decimate; sample-hold to effective rate; exact RTL integer bandpass"
            if pl_filter else "decimate; sample-hold to effective rate; no filter")


def prepare_samples(x, y, decim=1, resample=1, pl_filter=False,
                    notch50=False, fs=200, metadata=None):
    """Shared training/export preprocessing, preserving the legacy default.

    In the new chain the 4 kHz notch precedes the export decimation gate,
    just as in emg_pl_export.v. The old decimate/repeat ordering is kept
    when --notch50 is absent. All states reset at a session boundary.
    """
    already = check_sample_contract(fs, decim, resample, pl_filter, notch50,
                                    metadata)
    x = np.asarray(x, dtype=np.int32)
    y = np.asarray(y, dtype=np.int8)
    if not notch50 and decim > 1:
        x, y = x[::decim], y[::decim]
    if resample > 1:
        # Sample-and-hold upsample: the RTL feature sums see each source
        # sample for the same number of native-rate cycles.
        x = np.repeat(x, resample, axis=0)
        y = np.repeat(y, resample, axis=0)
    if notch50:
        if not already:
            x = apply_pl_notch50(x, notch50)
        x, y = x[::decim], y[::decim]
    if pl_filter and notch50 != "processed":
        x = apply_pl_bandpass(x)
    return x, y


def make_windows(x, y, window=None, hop=None):
    """Window x, keep single-label windows, return (features, labels).

    Feature matrix is (n_windows, 5*8): MAV, WL, Energy, ZC, SSC per
    channel - integer definitions identical to the PL chain.
    """
    window = WINDOW if window is None else window
    hop = HOP if hop is None else hop
    n = (len(x) - window) // hop + 1
    idx = np.arange(window)[None, :] + hop * np.arange(n)[:, None]
    yv = y[idx]
    single = (yv == yv[:, :1]).all(axis=1) & (yv[:, 0] >= 0)
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
    ap.add_argument("--input-mode", choices=("baseline", "full", "waveform"),
                    default="baseline",
                    help="baseline rows, continuous NinaPro full stream, or board waveform capture")
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
    ap.add_argument("--pl-filter", action="store_true",
                    help="apply the exact integer PL bandpass after "
                         "resampling and before feature windowing")
    line_filter = ap.add_mutually_exclusive_group()
    line_filter.add_argument("--notch-comb", dest="notch50", action="store_const", const="notchcomb",
                            help="use the deployed 50 Hz notch + 1 Hz comb contract")
    line_filter.add_argument("--notch50", dest="notch50", action="store_const", const="processed",
                            help="current final signed waveform: notch + comb + bandpass; never apply bandpass twice")
    line_filter.add_argument("--legacy-notch50", dest="notch50", action="store_true",
                    help="use the 4 kHz PL notch contract; automatically skip "
                         "a second notch for verified notch50 CSVs")
    ap.add_argument("--subjects", nargs="+", default=None,
                    help="subject directory names to include (default: all)")
    ap.add_argument("--hidden", type=int, nargs="+", default=[64, 32])
    ap.add_argument("--seed", type=int, default=0)
    ap.add_argument("--no-balance", action="store_true",
                    help="keep the full rest majority in training")
    ap.add_argument("--model-path", default=None,
                    help="override the output model path")
    ap.add_argument("--metrics-path", default=None,
                    help="override the output metrics path")
    args = ap.parse_args()
    try:
        check_sample_contract(args.fs, args.decim, args.resample,
                              args.pl_filter, args.notch50)
    except ValueError as exc:
        ap.error(str(exc))

    global FS, WINDOW, HOP
    FS = args.fs
    WINDOW = args.win_samples or WINDOW_MS * FS // 1000
    HOP = args.hop_samples or HOP_MS * FS // 1000
    eff_fs = FS * args.resample // args.decim   # rate the windowed stream represents
    data_dir = args.data_dir or RAW_DIR

    input_suffix = args.input_mode
    paths = sorted(glob.glob(os.path.join(
        data_dir, "s*", "*_E*_A1_%s.csv" % input_suffix)))
    # subject key from the s*/ directory name (filename prefixes collide,
    # e.g. S30 vs S3 in a mixed dataset)
    subjects = sorted({os.path.basename(os.path.dirname(p)) for p in paths})
    if args.subjects:
        requested = {s.lower() for s in args.subjects}
        subjects = [s for s in subjects if s.lower() in requested]
    if len(subjects) < 2:
        print("need at least 2 converted subjects under %s" % data_dir)
        return 1

    data = {}
    for subj in subjects:
        xs, ys = [], []
        for e in args.sessions:
            x, y, meta = load_training_session(
                data_dir, subj, e, args.input_mode, with_metadata=True,
                keep_unknown=args.notch50)
            x, y = prepare_samples(x, y, args.decim, args.resample,
                                    args.pl_filter, notch50=args.notch50,
                                    fs=FS, metadata=meta)
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
    suffix = ("_processed" if args.notch50 == "processed" else "_notchcomb" if args.notch50 == "notchcomb" else "_notch50") + ("_pl_filter" if args.pl_filter else "")
    model_path = args.model_path or (
        MODEL_PATH.replace(".joblib", suffix + ".joblib") if args.notch50
        else PL_FILTER_MODEL_PATH if args.pl_filter else MODEL_PATH)
    metrics_path = args.metrics_path or (
        METRICS_PATH.replace(".json", suffix + ".json") if args.notch50
        else PL_FILTER_METRICS_PATH if args.pl_filter else METRICS_PATH)
    os.makedirs(os.path.dirname(model_path), exist_ok=True)
    joblib.dump(final, model_path)

    metrics = {
        "dataset": DATASET,
        "config": {
            "fs_hz": FS, "decim": args.decim, "resample": args.resample,
            "effective_fs_hz": eff_fs,
            "window_samples": WINDOW, "hop_samples": HOP,
            "window_ms": WINDOW * 1000 // eff_fs, "hop_ms": HOP * 1000 // eff_fs,
            "features": ["mav_sum", "wl_sum", "energy_sum", "zc_count", "ssc_count"],
            "zc_th": ZC_TH, "ssc_th": SSC_TH,
            "pl_filter": args.pl_filter,
            "notch50": args.notch50,
            "notch_filter_id": notch_model(args.notch50).FILTER_ID if args.notch50 else None,
            "input_mode": args.input_mode,
            "filter_contract": filter_contract(args.pl_filter, args.notch50),
            "model": "StandardScaler + MLP(%s)" % ",".join(map(str, args.hidden)),
            "balance": "rest downsampled to median class size" if not args.no_balance else "none",
            "sessions": args.sessions, "subjects": subjects, "seed": args.seed,
            "evaluation": "leave-one-subject-out",
        },
        "classes": CLASSES,
        "folds": folds,
        "pooled": pooled,
        "model_path": os.path.relpath(model_path, ROOT).replace("\\", "/"),
        "trained_on": "%d subjects, %d windows" % (len(subjects), len(all_y)),
    }
    os.makedirs(os.path.dirname(metrics_path), exist_ok=True)
    with open(metrics_path, "w") as fh:
        json.dump(metrics, fh, indent=2)

    print("pooled: acc=%.3f f1_macro=%.3f" % (pooled["accuracy"], pooled["f1_macro"]))
    print("confusion (rows=true, cols=pred; %s):" % ",".join(
        "%d=%s" % (i, c) for i, c in enumerate(CLASSES)))
    for i, row in enumerate(pooled["confusion"]):
        print("  %s: %s" % (CLASSES[i], row))
    print("model -> %s" % os.path.relpath(model_path, ROOT))
    print("metrics -> %s" % os.path.relpath(metrics_path, ROOT))
    return 0


if __name__ == "__main__":
    sys.exit(main())
