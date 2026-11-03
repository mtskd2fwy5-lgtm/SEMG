#!/usr/bin/env python3
"""Hyperdimensional computing (HDC) sEMG classifier validation on board data.

Validates the exact algorithm shape a PL HDC engine would implement:

  * encoding: per-channel random bipolar item memory (CIM) + per-quantisation-
    level item memory (VIM); bind (elementwise product) then bundle (sum +
    sign) into one D-dimensional bipolar query per feature window -- the
    same 100 ms / 25 ms envelope contract as the NMF validation
  * training: queries accumulate into per-class integer prototypes
    (associative memory) from the first 30% of windows -- identical
    streaming protocol to nmf_validate.centroid_acc, so accuracy columns
    are directly comparable with accMAV / accC
  * inference: dot-product similarity between the bipolar query and each
    prototype, nearest wins
  * online adaptation: on a misclassification, proto[true] += q and
    proto[pred] -= q -- single-sample retraining, something an MLP cannot
    do without a full backprop pass

All arithmetic is sign/POPcount friendly (bipolar queries, integer
prototypes), matching a cheap RTL datapath: 0 DSP, prototypes for D=4096
and 5 classes cost 2.5 KB of storage.

Usage:
  python tools/hdc_validate.py --input report/emg008_20261022/EMG008_processed.csv ...
"""

import argparse
import json
import os
import sys
import time

import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from nmf_validate import load_csv, envelopes, METRICS_DIR


def sidecar_fs(path):
    side = os.path.splitext(path)[0] + ".json"
    if os.path.isfile(side):
        try:
            with open(side) as fh:
                fs = json.load(fh).get("sample_rate_hz")
                if fs:
                    return float(fs)
        except (ValueError, OSError):
            pass
    return None


def bipolar(rng, shape):
    """Random +/-1 vectors, int8 storage (RTL-friendly representation)."""
    return (rng.integers(0, 2, shape, dtype=np.int8) * 2 - 1)


def encode(E, qmax, CIM, VIM, chunk=512):
    """Encode all windows into bipolar queries (n, D).

    Per channel: quantise the envelope to a VIM level, bind with the
    channel vector, then bundle (sum over channels + sign).
    """
    n, m = E.shape
    D = CIM.shape[1]
    Q = VIM.shape[0]
    scale = (Q - 1) / np.maximum(qmax, 1e-12)
    idx = np.clip((E * scale).round().astype(np.int64), 0, Q - 1)
    out = np.empty((n, D), dtype=np.int8)
    for s in range(0, n, chunk):
        bound = VIM[idx[s:s + chunk]] * CIM          # (b, m, D)
        out[s:s + chunk] = (bound.sum(1) >= 0).astype(np.int8) * 2 - 1
    return out


def batch_sim(queries, proto, chunk=1024):
    """Similarities (n, k) with chunked int32 matmul (keeps memory flat)."""
    out = np.empty((queries.shape[0], proto.shape[0]), dtype=np.int32)
    for s in range(0, queries.shape[0], chunk):
        out[s:s + chunk] = (queries[s:s + chunk].astype(np.int32) @ proto.T)
    return out


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--input", required=True, nargs="+",
                    help="one or more capture csvs (SEMGSD1 sidecar "
                         "auto-detects board-filtered signals)")
    ap.add_argument("--fs", type=float, default=None,
                    help="sample rate; default: sidecar sample_rate_hz or 4000")
    ap.add_argument("--dims", type=int, nargs="+",
                    default=[1024, 2048, 4096, 8192],
                    help="hypervector dimensions to sweep")
    ap.add_argument("--levels", type=int, nargs="+", default=[16, 32, 64],
                    help="per-channel envelope quantisation levels to sweep")
    ap.add_argument("--train-frac", type=float, default=0.3,
                    help="first fraction of windows used to build prototypes")
    ap.add_argument("--seed", type=int, default=7)
    args = ap.parse_args()

    os.makedirs(METRICS_DIR, exist_ok=True)
    results = []
    t0 = time.time()

    for path in args.input:
        stem = os.path.splitext(os.path.basename(path))[0]
        sig, labels, prefiltered = load_csv(path)
        fs = args.fs or sidecar_fs(path) or 4000.0
        E, lab = envelopes(sig, fs, labels, prefiltered)
        n = len(E)
        # same class filter as nmf_validate.centroid_acc
        classes = sorted(set(lab) - {"none", ""})
        cls_idx = {c: i for i, c in enumerate(classes)}
        true_all = np.array([cls_idx.get(l, -1) for l in lab], dtype=np.int64)
        cut = int(n * args.train_frac)
        print(f"\n{stem}: {n} windows, {len(classes)} classes {classes}, "
              f"train {cut}")
        if len(classes) < 2:
            print("  single/no-class capture -- skipped")
            continue
        # per-channel full scale from TRAINING windows only (no future leak)
        qmax = E[:cut].max(0)

        for D in args.dims:
            for Q in args.levels:
                rng = np.random.default_rng(args.seed + 1000 * D + Q)
                CIM = bipolar(rng, (E.shape[1], D))
                VIM = bipolar(rng, (Q, D))
                queries = encode(E, qmax, CIM, VIM)

                # train: bundle labelled training queries per class
                proto = np.zeros((len(classes), D), dtype=np.int32)
                for ci in range(len(classes)):
                    sel = np.nonzero(true_all[:cut] == ci)[0]
                    if len(sel):
                        proto[ci] = queries[sel].sum(0, dtype=np.int32)

                te = np.arange(cut, n)
                if not len(te):
                    continue
                te_true = true_all[te]

                # frozen evaluation
                sim = batch_sim(queries[te], proto)
                pred = sim.argmax(1)
                acc_frozen = float((pred == te_true).mean())

                # adaptive evaluation: single-sample retraining on errors
                proto_a = proto.copy()
                pred_a = np.empty(len(te), dtype=np.int64)
                for j in range(len(te)):
                    q = queries[te[j]].astype(np.int32)
                    p = int(np.argmax(proto_a @ q))
                    pred_a[j] = p
                    y = int(te_true[j])
                    if y >= 0 and p != y:
                        proto_a[y] += q
                        proto_a[p] -= q
                acc_adapt = float((pred_a == te_true).mean())

                results.append(dict(stem=stem, n=n, D=D, Q=Q,
                                    acc_frozen=round(acc_frozen, 4),
                                    acc_adapt=round(acc_adapt, 4)))
                print(f"  D={D:<5d} Q={Q:<3d} frozen {acc_frozen:6.1%}"
                      f"  adapt {acc_adapt:6.1%}")

    with open(os.path.join(METRICS_DIR, "hdc_validate.json"), "w") as fh:
        json.dump(results, fh, indent=1)

    print("\n=== cross-capture average ===")
    print(f"{'D':>6} {'Q':>4} {'frozen':>8} {'adapt':>8} {'captures':>9}")
    for D, Q in sorted({(r["D"], r["Q"]) for r in results}):
        rows = [r for r in results if r["D"] == D and r["Q"] == Q]
        f = np.mean([r["acc_frozen"] for r in rows])
        a = np.mean([r["acc_adapt"] for r in rows])
        print(f"{D:>6} {Q:>4} {f:8.1%} {a:8.1%} {len(rows):>9}")
    print(f"\ntotal {time.time() - t0:.1f}s -> data/metrics/hdc_validate.json")


if __name__ == "__main__":
    main()

