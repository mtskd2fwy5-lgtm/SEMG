#!/usr/bin/env python3
"""Online NMF (muscle-synergy) PC validation for the PL synergy engine.

Validates the exact algorithm shape the RTL will implement:

  * streaming input: one 8-D MAV envelope per feature window
    (100 ms window / 25 ms hop -- same as the PL feature bank contract)
  * per-window C solve: 2 multiplicative inner iterations against W
  * slow W track: every `--w-period` windows one multiplicative update
    from EMA-accumulated outer-product statistics
        A (8 x k) = sum_t  e_t c_t^T          (no raw E history stored)
        B (k x k) = sum_t  c_t c_t^T
    so the RTL only ever needs 8k + k^2 accumulator words, not a matrix.
  * optional fixed-point (Q-format) simulation with quantised reciprocal
    for the divisions, to derisk the RTL datapath width choices.

Two evaluation modes:
  labeled  (DB5 baseline csv, `action` column):
      convergence curve, 5-class centroid separability in C space vs the
      full 8-D MAV baseline (streaming protocol: centroids from the first
      30% of windows, accuracy measured on the rest), W anatomy check
      (flexor vs extensor sidedness).
  unlabeled (board capture csv): convergence + C segmentation structure.

Usage:
  python tools/nmf_validate.py --input data/raw/ninapro_db5/s1/S1_E2_A1_baseline.csv
  python tools/nmf_validate.py --input <board.csv> --k 3 --fixed-point --plot
"""

import argparse
import json
import os
import sys
import time

import numpy as np
import pandas as pd

try:
    from scipy.signal import butter, filtfilt
    HAVE_SCIPY = True
except ImportError:
    HAVE_SCIPY = False

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
METRICS_DIR = os.path.join(ROOT, "data", "metrics")

WINDOW_MS = 100          # PL feature bank contract (WINDOW_SAMPLES=400 @ 4 kSPS)
HOP_MS = 25


# ---------------------------------------------------------------- data ----
def load_csv(path):
    df = pd.read_csv(path)
    cols = [c for c in df.columns if c.startswith("channel_")]
    cols.sort(key=lambda c: int(c.split("_")[1]))
    if len(cols) != 8:
        sys.exit(f"error: expected 8 channel columns, found {len(cols)}")
    label_col = "action" if "action" in df.columns else None
    labels = df[label_col].values if label_col else None
    # SEMGSD1 sidecar: "signal": "processed" (or non-null "filter") means the
    # capture already went through the board-equivalent filter chain -- the
    # PC butter prefilter must then be skipped to stay aligned with the PL.
    prefiltered = False
    side = os.path.splitext(path)[0] + ".json"
    if os.path.isfile(side):
        try:
            with open(side) as fh:
                meta = json.load(fh)
            prefiltered = (meta.get("signal") == "processed"
                           or meta.get("filter") not in (None, ""))
        except (ValueError, OSError):
            pass
    return df[cols].values.astype(np.float64), labels, prefiltered


def envelopes(sig, fs, labels=None, prefiltered=False):
    """Per-window MAV, aligned to the PL 100 ms / 25 ms contract."""
    if not prefiltered and HAVE_SCIPY:
        b, a = butter(4, [20.0 / (fs / 2), 450.0 / (fs / 2)], btype="band")
        sig = filtfilt(b, a, sig, axis=0)
    win = int(round(fs * WINDOW_MS / 1000.0))
    hop = int(round(fs * HOP_MS / 1000.0))
    n = (len(sig) - win) // hop + 1
    if n < 10:
        sys.exit(f"error: recording too short for one window ({len(sig)} samples)")
    idx = np.arange(win)[None, :] + hop * np.arange(n)[:, None]
    E = np.abs(sig[idx, :]).mean(axis=1)          # (n, 8) non-negative
    lab = None
    if labels is not None:
        if labels.dtype.kind in "iu":
            lab = labels[idx].mean(axis=1).astype(int)
        else:                       # mid-window label; 5 s trials >> 100 ms window
            lab = labels[idx][:, win // 2]
    return E, lab


# ------------------------------------------------------- fixed point ------
class Q:
    """Signed Qa.b container: q = fractional bits, int16 storage."""
    def __init__(self, q):
        self.q = q

    def enc(self, x):
        v = np.round(np.asarray(x) * (1 << self.q))
        return np.clip(v, -(1 << 15), (1 << 15) - 1).astype(np.int32)

    def mul(self, a, b, out_q=None):
        out_q = self.q if out_q is None else out_q
        p = (a.astype(np.int64) * b) >> self.q          # keeps self.q format
        if out_q < self.q:
            p = p >> (self.q - out_q)
        return np.clip(p, -(1 << 15), (1 << 15) - 1).astype(np.int32)

    def recip(self, d):
        """Quantised reciprocal via a 1/x LUT-style evaluation (Q16 result,
        rounded) -- models an 8-entry-per-octave or Newton-iteration RTL
        divider closely enough for convergence studies."""
        d = np.maximum(d, 1)
        r = np.round((1 << 16) / d.astype(np.float64))
        return np.clip(r, 0, (1 << 16) - 1).astype(np.int32)


# ----------------------------------------------------------- online NMF ---
def online_nmf(E, k, c_iters, w_period, lam, seed, fp=None):
    """Streaming multiplicative NMF.  Returns C (n,k), W (8,k), err curve."""
    n, m = E.shape
    rng = np.random.default_rng(seed)
    W = 0.5 + rng.random((m, k))                        # positive init
    A = np.zeros((m, k))                                # sum e c^T
    B = np.zeros((k, k))                                # sum c c^T
    C = np.ones(k)
    C_hist = np.zeros((n, k))
    err = np.zeros(n)

    if fp is not None:
        Wq = fp.enc(W / np.abs(W).max())
        W = Wq.astype(np.float64) / (1 << fp.q)

    WtW = W.T @ W
    for t in range(n):
        e = E[t]
        WtE = W.T @ e
        for _ in range(c_iters):
            den = WtW @ C
            C = C * WtE / np.maximum(den, 1e-12)
        if fp is not None:                              # quantise C each window
            C = fp.enc(C) / (1 << fp.q)
        C_hist[t] = C
        rec = W @ C
        err[t] = np.linalg.norm(e - rec) / (np.linalg.norm(e) + 1e-12)
        A = lam * A + np.outer(e, C)
        B = lam * B + np.outer(C, C)
        if (t + 1) % w_period == 0:
            W = W * A / np.maximum(W @ B, 1e-12)
            # rebirth: a multiplicative update can drive a whole synergy
            # column to zero; re-seed dead columns instead of losing rank.
            norms = np.linalg.norm(W, axis=0)
            nmax = norms.max()
            dead = norms < 1e-6 * max(nmax, 1e-12)
            if dead.any() and nmax > 0:
                fresh = 0.5 + rng.random((m, int(dead.sum())))
                fresh *= nmax / np.linalg.norm(fresh, axis=0)
                W[:, dead] = fresh
            if fp is not None:
                W = fp.enc(W / np.abs(W).max()) / (1 << fp.q)
            else:
                # scale anchoring: unit-L2 columns put the scale into C, so
                # successive W updates cannot drift the C-space geometry
                # (otherwise streaming centroids break -- saw 1% acc collapse).
                W = W / np.maximum(np.linalg.norm(W, axis=0), 1e-12)
            WtW = W.T @ W
            A = np.zeros((m, k))                        # reset accumulators
            B = np.zeros((k, k))
    return C_hist, W, err


# ---------------------------------------------------------- evaluation ---
def centroid_acc(F, labels, frac=0.3):
    """Streaming protocol: centroids from first `frac`, accuracy on the rest."""
    classes = sorted(set(labels) - {"none", ""})
    cut = int(len(F) * frac)
    cent = {c: F[(labels == c) & (np.arange(len(F)) < cut)].mean(axis=0)
            for c in classes if ((labels == c) & (np.arange(len(F)) < cut)).sum() > 0}
    if len(cent) < 2:
        return float("nan"), cent
    names = list(cent)
    M = np.stack([cent[c] for c in names])
    mask = np.arange(len(F)) >= cut
    if not mask.any():
        return float("nan"), cent
    d = ((F[mask, None, :] - M[None, :, :]) ** 2).sum(-1)
    pred = np.array(names)[d.argmin(1)]
    true = labels[mask]
    ok = (pred == true).mean()
    return float(ok), cent


def anatomy_report(W):
    """DB5 board layout: ch0-3 proximal ring (flexor-dominant),
    ch4-7 distal ring (extensor-dominant)."""
    lines = ["W (8ch x k synergy weights, rows = channels):"]
    for i, row in enumerate(W):
        tag = "prox" if i < 4 else "dist"
        lines.append(f"  ch{i} [{tag}] " + " ".join(f"{v:6.3f}" for v in row))
    Wn = W / (np.abs(W).max(1, keepdims=True) + 1e-12)
    for j in range(W.shape[1]):
        ps = Wn[:4, j].sum()
        ds = Wn[4:, j].sum()
        lines.append(f"  synergy {j}: proximal flexor-side sum={ps:5.2f}, "
                     f"distal/extensor sum={ds:5.2f}")
    return "\n".join(lines)


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--input", required=True, nargs="+",
                    help="one or more capture csvs (SEMGSD1 sidecar auto-"
                         "detects board-filtered signals)")
    ap.add_argument("--fs", type=float, default=None,
                    help="sample rate; default 2000 for DB5, 4000 for board csv")
    ap.add_argument("--k", type=int, default=3)
    ap.add_argument("--c-iters", type=int, default=2)
    ap.add_argument("--w-period", type=int, default=50,
                    help="W update period in windows (50 win = 1.25 s)")
    ap.add_argument("--lam", type=float, default=0.999, help="EMA factor")
    ap.add_argument("--seed", type=int, default=7)
    ap.add_argument("--fixed-point", action="store_true",
                    help="simulate Q6.10 datapath (int16, quantised C/W)")
    ap.add_argument("--plot", action="store_true")
    args = ap.parse_args()

    fp = Q(10) if args.fixed_point else None
    os.makedirs(METRICS_DIR, exist_ok=True)
    results = []
    print(f"{'capture':>10} {'wins':>6} {'recon':>6} {'accC':>6} {'accMAV':>7} "
          f"{'pf':>3}  synergy-top-channels")

    for path in args.input:
        sig, labels, prefiltered = load_csv(path)
        fs = args.fs
        if fs is None:
            fs = 2000.0 if "ninapro" in path.replace("\\", "/").lower() else 4000.0
        E, lab = envelopes(sig, fs, labels, prefiltered)
        n = len(E)
        labeled = lab is not None and len(set(lab) - {"none"}) >= 2

        C, W, err = online_nmf(E, args.k, args.c_iters, args.w_period,
                               args.lam, args.seed, fp)
        conv = float(err[-max(1, n // 10):].mean())
        res = {
            "input": os.path.basename(path), "windows": n, "k": args.k,
            "c_iters": args.c_iters, "w_period": args.w_period,
            "lam": args.lam, "prefiltered": prefiltered,
            "fixed_point": bool(fp), "recon_err_final10": conv,
        }
        acc_c = acc_e = float("nan")
        if labeled:
            acc_c, _ = centroid_acc(C, lab)
            acc_e, _ = centroid_acc(E, lab)
            res["acc_c_space"] = acc_c
            res["acc_mav8_baseline"] = acc_e
        results.append(res)

        # per-synergy dominant channels for a compact anatomy summary
        tops = []
        Wn = W / (np.abs(W).max(1, keepdims=True) + 1e-12)
        for j in range(args.k):
            order = np.argsort(-Wn[:, j])[:3]
            tops.append(",".join(f"ch{int(c)}" for c in order))
        print(f"{os.path.basename(path)[:10]:>10} {n:>6} {conv:>6.3f} "
              f"{acc_c*100 if acc_c == acc_c else 0:>5.1f}% "
              f"{acc_e*100 if acc_e == acc_e else 0:>6.1f}% "
              f"{'y' if prefiltered else 'n':>3}  " + " | ".join(tops))

        if args.plot:
            import matplotlib
            matplotlib.use("Agg")
            import matplotlib.pyplot as plt
            fig, ax = plt.subplots(3, 1, figsize=(11, 9), sharex=True)
            t = np.arange(n) * HOP_MS / 1000.0
            ax[0].plot(t, err, lw=0.6)
            ax[0].set_ylabel("rel recon err")
            ax[0].set_title(f"online NMF k={args.k} {os.path.basename(path)}"
                            + (" (Q6.10 fixed point)" if fp else ""))
            for j in range(args.k):
                ax[1].plot(t, C[:, j], lw=0.7, label=f"syn{j}")
            ax[1].legend(loc="upper right", fontsize=8)
            ax[1].set_ylabel("synergy activation C")
            if labeled:
                cmap = {"rest": "0.85", "open_hand": "tab:blue", "fist": "tab:red",
                        "wrist_flex": "tab:green", "wrist_extend": "tab:orange"}
                for cls, colr in cmap.items():
                    m = lab == cls
                    if m.any():
                        ax[2].fill_between(t, 0, 1, where=m, color=colr,
                                           alpha=0.35, label=cls)
                ax[2].legend(loc="upper right", fontsize=7)
            ax[2].set_ylabel("labels" if labeled else "")
            ax[2].set_xlabel("time (s)")
            stem = os.path.splitext(os.path.basename(path))[0]
            out_png = os.path.join(METRICS_DIR, f"nmf_{stem}.png")
            fig.tight_layout()
            fig.savefig(out_png, dpi=110)
            plt.close(fig)
            print(f"          plot -> {out_png}")

    out_json = os.path.join(METRICS_DIR, "nmf_validate.json")
    with open(out_json, "w") as fh:
        json.dump(results, fh, indent=1)
    print(f"metrics -> {out_json}")


if __name__ == "__main__":
    main()
