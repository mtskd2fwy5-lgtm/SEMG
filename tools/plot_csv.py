#!/usr/bin/env python
"""Offline waveform viewer for board-captured sEMG CSVs (tools/record_uart.py output).

Renders the 8 channels as rolling strips with per-label background bands,
so a capture session can be sanity-checked (dead/shorted electrodes,
saturated channels, mis-labeled segments) before feeding prepare_dataset.py.

Usage:
  python tools/plot_csv.py data/raw/board/s30/S30_E2_A1_baseline.csv
  python tools/plot_csv.py --latest                    # newest CSV under data/raw/board
  python tools/plot_csv.py f1.csv f2.csv               # multiple files, stacked
  python tools/plot_csv.py --channels 1,5 file.csv     # subset of channels
  python tools/plot_csv.py --latest --raw --start 5 --duration 0.2
                                                    # every sample at 5..5.2 s

The CSV contract (record_uart.py): header
  timestamp_us,channel_0..channel_7,action,subject,session
A sidecar JSON of the same stem holds meta (rate, dropped frames, runs).
"""
import argparse
import json
import sys
from pathlib import Path

import numpy as np
import matplotlib
import matplotlib.pyplot as plt

ROOT = Path(__file__).resolve().parent.parent

LABEL_COLORS = {
    "rest": "#888888",
    "open_hand": "#3b82f6",
    "fist": "#ef4444",
    "wrist_flex": "#eab308",
    "wrist_extend": "#22c55e",
    "none": "#dddddd",
}


def find_latest():
    board = ROOT / "data" / "raw" / "board"
    csvs = sorted(board.rglob("*.csv"), key=lambda p: p.stat().st_mtime)
    if not csvs:
        sys.exit(f"no CSV under {board} - capture with record_uart.py first")
    return str(csvs[-1])


def load_csv(path):
    """-> (t_s float[N], data int32[N,8], labels str[N], meta dict)"""
    import pandas as pd  # only needed for CSV, keeps startup light

    df = pd.read_csv(path)
    need = ["timestamp_us", "action"] + [f"channel_{i}" for i in range(8)]
    missing = [c for c in need if c not in df.columns]
    if missing:
        sys.exit(f"{path}: missing columns {missing} - not a record_uart.py CSV?")
    if df.empty:
        sys.exit(f"{path}: no samples in CSV")
    t0 = df["timestamp_us"].to_numpy(np.int64)
    if np.any(np.diff(t0) <= 0):
        sys.exit(f"{path}: timestamps must be strictly increasing")
    t = (t0 - t0[0]) * 1e-6
    data = np.column_stack([df[f"channel_{i}"].to_numpy(np.int64) for i in range(8)])
    labels = df["action"].astype(str).to_numpy()
    meta = {}
    sidecar = Path(path).with_suffix(".json")
    if sidecar.exists():
        try:
            meta = json.loads(sidecar.read_text())
        except (ValueError, OSError):
            meta = {}
    return t, data, labels, meta


def envelope(t, ch, bins):
    """Min/max downsample for display: every bin keeps its extremes."""
    if bins < 1:
        raise ValueError("bins must be positive")
    n = len(t)
    if n <= bins:
        return t, ch.astype(float), ch.astype(float)
    # Uneven bins must include the final samples too.
    edges = np.linspace(0, n, bins + 1, dtype=int)
    starts = edges[:-1]
    lo = np.minimum.reduceat(ch, starts).astype(float)
    hi = np.maximum.reduceat(ch, starts).astype(float)
    tc = np.add.reduceat(t, starts) / np.diff(edges)
    return tc, lo, hi


def select_interval(t, data, labels, start, duration):
    """Select [start, start + duration), retaining time since capture start."""
    end = np.inf if duration is None else start + duration
    keep = (t >= start) & (t < end)
    if not np.any(keep):
        raise ValueError("selected interval contains no samples")
    return t[keep], data[keep], labels[keep]


def contiguous_slices(t, fs):
    """Do not draw a signal across missing samples or trimmed sections."""
    cuts = np.flatnonzero(np.diff(t) > 1.5 / fs) + 1 if fs > 0 else []
    edges = [0, *cuts, len(t)]
    return [slice(a, b) for a, b in zip(edges, edges[1:]) if b > a]


def label_segments(labels, t):
    """Consecutive same-label spans -> [(label, t_start, t_end)]"""
    segs = []
    start = 0
    for i in range(1, len(labels) + 1):
        if i == len(labels) or labels[i] != labels[start]:
            segs.append((labels[start], t[start], t[i - 1]))
            start = i
    return segs


def plot_file(axs, path, args):
    t, data, labels, meta = load_csv(path)
    fs = float(meta.get("sample_rate_hz", 0))
    if fs <= 0 and len(t) > 1:
        fs = 1.0 / np.median(np.diff(t))
    try:
        t, data, labels = select_interval(t, data, labels, args.start, args.duration)
    except ValueError as exc:
        sys.exit(f"{path}: {exc}")
    dur = t[-1] - t[0]
    slices = contiguous_slices(t, fs)

    segs = [seg for part in slices for seg in label_segments(labels[part], t[part])]
    print(f"\n{path}")
    print(f"  {len(t)} frames, {t[0]:.4f}..{t[-1]:.4f} s, fs = {fs:.0f} Hz", end="")
    if meta.get("frames_dropped_uart"):
        print(f", UART dropped = {meta['frames_dropped_uart']}", end="")
    print()
    print("  signal: %s" % meta.get("signal", "legacy/unspecified"))
    print(f"  display: {'every sample' if args.raw else 'min/max overview'}, "
          f"{len(slices) - 1} gap(s) in selected interval; units: ADC counts")
    for lab, a, b in segs:
        color = LABEL_COLORS.get(lab, "#dddddd")
        print(f"    {a:8.2f} - {b:8.2f} s  {lab:<13} ({color})")
        if lab == "none":
            continue
        for ax_idx, ch_idx in enumerate(args.channels):
            axs[ax_idx].axvspan(a, b, color=color, alpha=0.18, lw=0)

    for ax_idx, ch_idx in enumerate(args.channels):
        ax = axs[ax_idx]
        ch = data[:, ch_idx].astype(float)
        if args.dc == "mean":
            ch = ch - np.median(ch)  # median robust to bursts
        elif args.dc == "none":
            pass  # keep raw ADC codes incl. electrode offset
        for part in slices:
            # Draw each continuous part separately so gaps stay visible.
            if args.raw:
                ax.plot(t[part], ch[part], color="#1f2937", lw=0.65,
                        marker=".", markersize=2)
            else:
                bins = max(1, round(args.bins * len(t[part]) / len(t)))
                tc, lo, hi = envelope(t[part], ch[part], bins)
                if len(t[part]) <= bins:
                    ax.plot(tc, lo, color="#1f2937", lw=0.65,
                            marker=".", markersize=2)
                else:
                    ax.fill_between(tc, lo, hi, lw=0, color="#1f2937", alpha=0.85)
                    ax.vlines(tc, lo, hi, color="#1f2937", lw=0.5)
        ax.set_ylabel(f"CH{ch_idx + 1}\nADC counts")
        ax.grid(True, alpha=0.25)
        if ax_idx == 0:
            mode = "every sample" if args.raw else "min/max overview"
            title = f"{Path(path).name}  ({dur:.3f} s @ {fs:.0f} Hz, {mode}, DC={args.dc})"
            title += "  signal=" + meta.get("signal", "legacy/unspecified")
            if meta.get("frames_dropped_uart"):
                title += f"  dropped={meta['frames_dropped_uart']}"
            ax.set_title(title)
    return dur


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("csv", nargs="*", help="record_uart.py CSV file(s)")
    ap.add_argument("--latest", action="store_true", help="use newest CSV under data/raw/board")
    ap.add_argument("--channels", default="0,1,2,3,4,5,6,7",
                    help="comma list of channel indices to show (default all)")
    ap.add_argument("--bins", type=int, default=2000, help="display bins per strip (default 2000)")
    ap.add_argument("--dc", choices=["mean", "none"], default="mean",
                    help="subtract per-channel median before display (default mean)")
    ap.add_argument("--raw", action="store_true",
                    help="plot every original sample; use --start/--duration for detail")
    ap.add_argument("--start", type=float, default=0.0,
                    help="start time in seconds since first CSV sample (default 0)")
    ap.add_argument("--duration", type=float,
                    help="seconds to show, excluding the end point (default all remaining)")
    args = ap.parse_args()
    if args.bins < 1 or args.start < 0 or not np.isfinite(args.start):
        ap.error("--bins must be positive and --start must be finite and nonnegative")
    if args.duration is not None and (args.duration <= 0 or not np.isfinite(args.duration)):
        ap.error("--duration must be finite and positive")

    paths = [find_latest()] if args.latest else args.csv
    if not paths:
        sys.exit("give CSV path(s) or --latest")

    try:
        args.channels = [int(c) for c in args.channels.split(",") if c != ""]
    except ValueError:
        ap.error("--channels must be comma-separated indices 0..7")
    if not args.channels or any(c < 0 or c > 7 for c in args.channels):
        ap.error("--channels must contain at least one index in 0..7")

    fig, axs = plt.subplots(len(args.channels), 1, figsize=(13, 1.35 * len(args.channels)),
                            sharex=True, squeeze=False)
    axs = axs[:, 0]
    for p in paths:
        plot_file(axs, p, args)

    handles = [matplotlib.patches.Patch(color=c, label=l, alpha=0.35)
               for l, c in LABEL_COLORS.items() if l != "none"]
    axs[0].legend(handles=handles, loc="upper right", ncol=5, fontsize=8)
    axs[-1].set_xlabel("time (s)")
    fig.subplots_adjust(hspace=0.12, left=0.05, right=0.99, top=0.94, bottom=0.06)
    plt.show()  # interactive: pan / zoom to inspect segments


if __name__ == "__main__":
    main()
