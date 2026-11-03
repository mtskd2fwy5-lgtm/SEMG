#!/usr/bin/env python3
"""Compare rectangular and Hann-window MDF stability on labeled captures."""
import argparse
import csv
import json
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
N = 2048
FS = 4000
CHANNELS = [f"channel_{i}" for i in range(8)]


def read_capture(path):
    xs, ys = [], []
    with path.open(newline="", encoding="utf-8") as fh:
        for row in csv.DictReader(fh):
            if row["source"] != "processed":
                raise ValueError(f"{path}: not processed data")
            xs.append([int(row[c]) for c in CHANNELS])
            ys.append(row["action"])
    return np.asarray(xs, dtype=np.float32), np.asarray(ys)


def median_frequency(w, taper):
    if taper is not None:
        w = w * taper[:, None]
    spec = np.abs(np.fft.rfft(w, axis=0)) ** 2
    hz = np.fft.rfftfreq(N, 1 / FS)
    band = (hz >= 20) & (hz <= 450)
    p = spec[band]
    f = hz[band]
    cdf = np.cumsum(p, axis=0)
    idx = np.argmax(cdf >= cdf[-1:, :] * 0.5, axis=0)
    return float(np.median(f[idx]))


def analyze(x, y):
    rect_steps, hann_steps, rect_mdf_all, hann_mdf_all = [], [], [], []
    edges = np.r_[0, np.flatnonzero(y[1:] != y[:-1]) + 1, len(y)]
    taper = np.hanning(N).astype(np.float32)
    for start, end in zip(edges[:-1], edges[1:]):
        start, end = int(start + FS), int(end - FS)
        r, h = [], []
        for p in range(start, end - N + 1, N):
            w = x[p:p + N]
            r.append(median_frequency(w, None))
            h.append(median_frequency(w, taper))
        rect_mdf_all.extend(r)
        hann_mdf_all.extend(h)
        rect_steps.extend(np.abs(np.diff(r)).tolist())
        hann_steps.extend(np.abs(np.diff(h)).tolist())
    return {
        "windows": len(rect_mdf_all),
        "rectangular_mdf_median_hz": float(np.median(rect_mdf_all)),
        "hann_mdf_median_hz": float(np.median(hann_mdf_all)),
        "rectangular_adjacent_abs_delta_median_hz": float(np.median(rect_steps)),
        "hann_adjacent_abs_delta_median_hz": float(np.median(hann_steps)),
        "rectangular_adjacent_abs_delta_p95_hz": float(np.percentile(rect_steps, 95)),
        "hann_adjacent_abs_delta_p95_hz": float(np.percentile(hann_steps, 95)),
    }


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("captures", nargs="*", default=[
        "report/emg008_20261022/EMG008_processed.csv",
        "report/emg009_20261022/EMG009_processed.csv",
        "report/emg017_20261022/EMG017_processed.csv",
    ])
    args = ap.parse_args()
    if not args.captures:
        args.captures = [
            "report/emg008_20261022/EMG008_processed.csv",
            "report/emg009_20261022/EMG009_processed.csv",
            "report/emg017_20261022/EMG017_processed.csv",
        ]
    results = {}
    for item in args.captures:
        path = ROOT / item
        results[path.stem] = analyze(*read_capture(path))
    print(json.dumps(results, indent=2))


if __name__ == "__main__":
    main()

