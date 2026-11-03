#!/usr/bin/env python3
"""Dual-task 1D-CNN on NinaPro DB5 continuous streams (LoSo evaluation).

Tasks (--task)
  cls  : 44-class DB5 movement recognition (E1 single-finger, E2 palm/wrist,
         E3 grasp mixes), evaluated on pure windows only  [default]
  dual : + 5 finger-DOF regression from Cyberglove II (R2 per finger)

Data contract
  data/raw/ninapro_db5/s*/S*_E*_full.csv written by
  tools/prepare_dataset.py --continuous (gap-free stream: 8 EMG channels,
  22 raw glove channels, local restimulus code, 200 Hz)

Architecture (INT8-friendly: foldable BN, ReLU, GAP, bounded sigmoid head)
  Conv1d(8->16, k7, s2) BN ReLU
  Conv1d(16->32, k5, s2) BN ReLU
  Conv1d(32->32, k3, s1) BN ReLU
  GlobalAvgPool -> Linear(32->5) logits / Linear(32->5) sigmoid angles

MACs per window ~= 75k (16-MAC @ 100 MHz -> ~0.5 ms), params ~= 7k.

Usage
  python tools/train_cnn.py --probe-glove   # derive + print finger map
  python tools/train_cnn.py                 # LoSo + final model + metrics
  python tools/train_cnn.py --epochs 5      # quick smoke run
"""

import argparse
import glob
import json
import os
import re
import sys

import numpy as np

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RAW_DIR = os.path.join(ROOT, "data", "raw", "ninapro_db5")
MODEL_PATH = os.path.join(ROOT, "data", "models", "cnn_dual.pt")
METRICS_PATH = os.path.join(ROOT, "data", "metrics", "cnn.json")

# DB5 protocol: 43 movements = E1 12 single-finger + E2 8 palm/wrist +
# E3 23 grasp/functional (multi-finger and finger+palm mixed movements).
# Global class id: 0 = rest, else EX_OFFSET[ex] + local restimulus code.
EX_OFFSET = {1: 0, 2: 12, 3: 20}
E1_NAMES = ["thumb_flex", "thumb_ext", "index_flex", "index_ext",
            "middle_flex", "middle_ext", "ring_flex", "ring_ext",
            "little_flex", "little_ext", "thumb_add", "thumb_abd"]
E2_NAMES = ["thumb_up", "wrist_ext", "wrist_flex", "radial_dev",
            "ulnar_dev", "supination", "pronation", "power_grip"]
E3_NAMES = ["e3_%02d" % (i + 1) for i in range(23)]   # grasp set, see DB5 doc
CLASSES = ["rest"] + E1_NAMES + E2_NAMES + E3_NAMES   # 44 classes

FS = 200
WINDOW = 40          # 200 ms
HOP = 10             # 50 ms
FINGERS = ["thumb", "index", "middle", "ring", "little"]
# E1-local restimulus codes per finger (flexion/extension pairs; thumb
# has adduction/abduction/flexion/extension in 9..12)
E1_MOVES = {"thumb": [9, 10, 11, 12], "index": [1, 2], "middle": [3, 4],
            "ring": [5, 6], "little": [7, 8]}


def load_streams():
    """Read every S*_E*_full.csv -> list of dicts."""
    import pandas as pd
    paths = sorted(glob.glob(os.path.join(RAW_DIR, "s*", "S*_E*_full.csv")))
    if not paths:
        print("no *_full.csv under %s - run tools/prepare_dataset.py "
              "--continuous first" % RAW_DIR)
        sys.exit(1)
    streams = []
    for p in paths:
        df = pd.read_csv(p)
        name = os.path.basename(p)
        subj_s, ex_s = re.match(r"S(\d+)_E(\d+)_", name).groups()
        streams.append({
            "subj": "s%d" % int(subj_s),
            "ex": int(ex_s),
            "emg": df[["channel_%d" % c for c in range(8)]].values.astype(np.float32),
            "glove": df[["glove_%d" % g for g in range(22)]].values.astype(np.float32),
            "restim": df["restimulus"].values.astype(np.int32),
        })
        print("  %s: %d samples" % (name, len(df)))
    return streams


def windowize(stream, window=WINDOW, rectify=False, lag=0):
    """One stream -> windows (M,8,W) float32, labels, purity, glove means.

    lag shifts the glove truth forward by `lag` samples relative to the
    EMG window (EMG leads force/joint angle by ~0.1-0.2 s physiologically).
    """
    emg, glove, restim = stream["emg"], stream["glove"], stream["restim"]
    if rectify:
        emg = np.abs(emg)                     # sEMG envelope standard step
    n = (len(emg) - window) // HOP + 1
    if n <= 0:
        return None
    import numpy.lib.stride_tricks as st
    v = st.sliding_window_view(emg, window, axis=0)[::HOP]   # (n,8,W) view
    x = np.ascontiguousarray(v.transpose(0, 2, 1))           # (n,W,8)
    idx = np.arange(window)[None, :] + HOP * np.arange(n)[:, None]
    rv = restim[idx]
    label = rv[:, 0]
    pure = (rv == rv[:, :1]).all(axis=1)
    gidx = np.clip(idx + lag, 0, len(glove) - 1)
    gmean = glove[gidx].mean(axis=1)                          # (n,22)
    # global DB5 class id: rest = 0, movement = EX_OFFSET[ex] + local code
    off = EX_OFFSET[stream["ex"]]
    cls = np.where(label == 0, 0, label + off).astype(np.int64)
    return {"x": x, "cls": cls, "pure": pure, "gmean": gmean,
            "moving": label > 0,
            "subj": stream["subj"], "ex": stream["ex"]}


def probe_glove(streams):
    """Derive finger->glove-channel map from E1 single-finger movements.

    Response of each glove channel per finger = max |act_mean - rest_mean|
    over that finger's E1 movement windows. Channels are assigned
    exclusively: scipy Hungarian assignment picks each finger's primary
    channel, then each finger gets the best remaining channel as its
    secondary (Cyberglove MCP+PIP pair).
    """
    streams_e1 = [s for s in streams if s["ex"] == 1]
    if not streams_e1:
        sys.exit("probe needs E1 streams")
    resp = {f: np.zeros(22) for f in FINGERS}
    for s in streams_e1:
        rest_mask = s["restim"] == 0
        if rest_mask.sum() < 100:
            continue
        rest_mean = s["glove"][rest_mask].mean(axis=0)
        for finger, codes in E1_MOVES.items():
            m = np.isin(s["restim"], codes)
            if m.sum() < 100:
                continue
            d = np.abs(s["glove"][m].mean(axis=0) - rest_mean)
            resp[finger] = np.maximum(resp[finger], d)
    from scipy.optimize import linear_sum_assignment
    R = np.stack([resp[f] for f in FINGERS])          # (5, 22)
    rows, cols = linear_sum_assignment(-R)            # exclusive primary
    primary = {FINGERS[r]: int(c) for r, c in zip(rows, cols)}
    finger_map, taken = {}, set(primary.values())
    print("glove probe (top-5 response channels per finger):")
    for finger in FINGERS:
        order = np.argsort(resp[finger])[::-1]
        print("  %-6s %s" % (finger, ["g%d=%.1f" % (c, resp[finger][c])
                                      for c in order[:5]]))
        sec = next(int(c) for c in order if int(c) not in taken)
        taken.add(sec)
        finger_map[finger] = [primary[finger], sec]
    print("finger map:", finger_map)
    return finger_map


def dof_from_gmean(gmean, finger_map):
    """(N,22) glove means -> (N,5) finger DOF (mean of mapped channels)."""
    return np.stack([gmean[:, finger_map[f]].mean(axis=1) for f in FINGERS],
                    axis=1)


class DualCNN:
    """Lazy torch import wrapper so --probe-glove works without torch."""

    def __init__(self):
        import torch
        import torch.nn as nn
        self.torch = torch
        self.net = nn.Sequential(
            nn.Conv1d(8, 16, 7, stride=2, padding=3), nn.BatchNorm1d(16),
            nn.ReLU(inplace=True),
            nn.Conv1d(16, 32, 5, stride=2, padding=2), nn.BatchNorm1d(32),
            nn.ReLU(inplace=True),
            nn.Conv1d(32, 32, 3, stride=1, padding=1), nn.BatchNorm1d(32),
            nn.ReLU(inplace=True),
            nn.AdaptiveAvgPool1d(1), nn.Flatten(),
        )
        self.cls_head = nn.Linear(32, len(CLASSES))
        # tanh head: aligned targets span [-1, 1] (negative = below rest)
        self.reg_head = nn.Sequential(nn.Linear(32, len(FINGERS)),
                                      nn.Tanh())

    def forward(self, xb):
        feat = self.net(xb)
        return self.cls_head(feat), self.reg_head(feat)


def count_macs(model, window=WINDOW):
    """MACs for one window (BN folded into conv for deployment)."""
    macs = 0
    chans_in, steps = 8, WINDOW
    convs = [(8, 16, 7, 2), (16, 32, 5, 2), (32, 32, 3, 1)]
    for ci, co, k, s in convs:
        steps_out = (steps - k) // s + 1
        macs += ci * co * k * steps_out
        steps = steps_out
    macs += 32 * 5 * 2
    return macs


def count_params(model):
    return sum(p.numel() for p in
               list(model.net.parameters()) +
               list(model.cls_head.parameters()) +
               list(model.reg_head.parameters()))


def rest_offsets(wins, finger_map):
    """Per-subject rest-median DOF offset (deployment: quiet calibration).

    Glove wear differs per subject, so each subject's raw DOF is shifted
    by its own rest-segment median. Returns {subj: offset (5,)}.
    """
    offs = {}
    for s in sorted({w["subj"] for w in wins}):
        g = np.concatenate([w["gmean"] for w in wins if w["subj"] == s])
        mv = np.concatenate([w["moving"] for w in wins if w["subj"] == s])
        d = dof_from_gmean(g[~mv], finger_map) if (~mv).any() \
            else dof_from_gmean(g, finger_map)
        offs[s] = np.median(d, axis=0)
    return offs


def train_fold(train_wins, test_wins, args, finger_map):
    import torch
    import torch.nn as nn
    th = torch

    # ---- input scaling from training subjects only ----
    tr_x = np.concatenate([w["x"] for w in train_wins])
    ch_mean = tr_x.mean(axis=(0, 1), keepdims=True)      # (1,1,8)
    ch_std = tr_x.std(axis=(0, 1), keepdims=True) + 1e-6

    # per-subject rest alignment of the regression targets
    tr_off = rest_offsets(train_wins, finger_map)
    te_off = rest_offsets(test_wins, finger_map)
    tr_dof_al = np.concatenate([
        dof_from_gmean(w["gmean"], finger_map) - tr_off[w["subj"]]
        for w in train_wins])
    dof_scale = np.percentile(np.abs(tr_dof_al), 98, axis=0) + 1e-6

    def prep(wins, offs):
        xs = np.concatenate([w["x"] for w in wins]) \
            if len(wins) > 1 else wins[0]["x"]
        x = (xs - ch_mean) / ch_std                       # (N,40,8)
        x = th.tensor(x.transpose(0, 2, 1), dtype=th.float32)
        cls = th.tensor(np.concatenate([w["cls"] for w in wins])
                        if len(wins) > 1 else wins[0]["cls"],
                        dtype=th.long)
        dof_al = np.concatenate([
            dof_from_gmean(w["gmean"], finger_map) - offs[w["subj"]]
            for w in wins])
        dof_t = th.tensor(np.clip(dof_al / dof_scale, -1, 1),
                          dtype=th.float32)
        pure = np.concatenate([w["pure"] for w in wins]) \
            if len(wins) > 1 else wins[0]["pure"]
        moving = np.concatenate([w["moving"] for w in wins]) \
            if len(wins) > 1 else wins[0]["moving"]
        return x, cls, dof_t, dof_al, pure, moving

    x_tr, cls_tr, dof_tr, dof_al_tr, _, moving_tr = prep(train_wins, tr_off)

    # rest windows dominate ~85% of the stream and drown the regression
    # task: cap rest windows at 2x the number of movement windows
    move_idx = np.where(moving_tr)[0]
    rest_idx = np.where(~moving_tr)[0]
    cap = 2 * len(move_idx)
    if len(rest_idx) > cap:
        keep_rest = np.random.default_rng(0).choice(rest_idx, cap,
                                                    replace=False)
        sel = np.sort(np.concatenate([move_idx, keep_rest]))
        x_tr, cls_tr, dof_tr = x_tr[sel], cls_tr[sel], dof_tr[sel]
        print("    rest downsampled: %d -> %d train windows"
              % (len(x_tr), len(sel)))

    x_te, cls_te, dof_te, dof_al_te, pure_te, moving_te = prep(test_wins,
                                                               te_off)

    model = DualCNN()
    opt = torch.optim.AdamW(
        list(model.net.parameters()) + list(model.cls_head.parameters()) +
        list(model.reg_head.parameters()), lr=args.lr)
    ce = nn.CrossEntropyLoss(ignore_index=-1)
    mse = nn.MSELoss()

    n = len(x_tr)
    rng = np.random.default_rng(0)
    model.net.train()
    for ep in range(args.epochs):
        perm = rng.permutation(n)
        tot_loss = tot_ce = tot_mse = nb = 0
        for i in range(0, n, args.batch):
            b = perm[i:i + args.batch]
            opt.zero_grad()
            logits, angles = model.forward(x_tr[b])
            l1 = ce(logits, cls_tr[b])
            l2 = mse(angles, dof_tr[b])
            loss = l1 + (l2 if args.task == "dual" else 0.0)
            loss.backward()
            opt.step()
            tot_loss += loss.item(); tot_ce += l1.item()
            tot_mse += l2.item(); nb += 1
        if (ep + 1) % 5 == 0 or ep == 0:
            print("    ep%02d loss=%.4f (ce=%.4f mse=%.4f)"
                  % (ep + 1, tot_loss / nb, tot_ce / nb, tot_mse / nb))

    model.net.eval()
    with th.no_grad():
        preds = []
        for i in range(0, len(x_te), 4096):
            logits, angles = model.forward(x_te[i:i + 4096])
            preds.append((logits, angles))
        logits = th.cat([p[0] for p in preds])
        angles = th.cat([p[1] for p in preds]).numpy()
    pred_cls = logits.argmax(dim=1).numpy()

    # classification accuracy on pure baseline windows (label >= 0)
    m_cls = pure_te & (cls_te.numpy() >= 0)
    y_true = cls_te.numpy()[m_cls]
    y_pred = pred_cls[m_cls]
    acc = float((y_true == y_pred).mean()) if len(y_true) else float("nan")

    # regression R2 per finger: all windows + movement windows only.
    # R2 is shift-invariant, so scoring in the aligned space equals
    # scoring in raw glove units (predictions already live there).
    def r2_of(mask):
        out = {}
        for j, f in enumerate(FINGERS):
            t = dof_al_te[mask, j]
            p = angles[mask, j] * dof_scale[j]
            ss_res = float(((t - p) ** 2).sum())
            ss_tot = float(((t - t.mean()) ** 2).sum())
            out[f] = round(1.0 - ss_res / ss_tot, 4) if ss_tot > 0 else float("nan")
        return out

    if args.task == "dual":
        r2 = {"all": r2_of(np.ones(len(angles), dtype=bool)),
              "moving": r2_of(moving_te)}
    else:
        r2 = {k: {f: float("nan") for f in FINGERS}
              for k in ("all", "moving")}
    te_subj = test_wins[0]["subj"]
    scaling = (ch_mean, ch_std, dof_scale, te_off[te_subj], tr_off)
    return model, scaling, acc, r2, (y_true, y_pred), (dof_al_te, angles)


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--probe-glove", action="store_true",
                    help="derive the finger->glove-channel map and exit")
    ap.add_argument("--epochs", type=int, default=25)
    ap.add_argument("--batch", type=int, default=256)
    ap.add_argument("--lr", type=float, default=1e-3)
    ap.add_argument("--subjects", type=int, nargs="+", default=None,
                    help="restrict to these subjects (default: all found)")
    ap.add_argument("--window", type=int, default=WINDOW,
                    help="window length in samples (40 = 200 ms)")
    ap.add_argument("--rectify", action="store_true",
                    help="full-wave rectify the EMG before windowing")
    ap.add_argument("--lag", type=int, default=0,
                    help="shift glove truth forward by N samples")
    ap.add_argument("--task", choices=["cls", "dual"], default="cls",
                    help="cls: classification only (default); "
                         "dual: + finger-DOF regression")
    ap.add_argument("--split", choices=["loso", "within"], default="loso",
                    help="loso: leave-one-subject-out (literature "
                         "protocol); within: per-subject 60/40 time "
                         "split (calibrated-device metric)")
    args = ap.parse_args()

    print("loading streams ...")
    streams = load_streams()
    if args.subjects:
        allowed = {"s%d" % n for n in args.subjects}
        streams = [s for s in streams if s["subj"] in allowed]

    finger_map = probe_glove(streams)
    if args.probe_glove:
        return 0

    print("windowizing ...")
    wins = [w for s in streams
            for w in [windowize(s, args.window, args.rectify,
                                args.lag)] if w is not None]
    subjects = sorted({w["subj"] for w in wins})
    n_windows = sum(len(w["x"]) for w in wins)
    print("%d windows, %d subjects: %s" % (n_windows, len(subjects), subjects))

    folds, pooled_true, pooled_pred = {}, [], []
    r2_all = {k: {f: [] for f in FINGERS} for k in ("all", "moving")}
    def slice_win(w, a, b):
        return {**w, "x": w["x"][a:b], "cls": w["cls"][a:b],
                "pure": w["pure"][a:b], "gmean": w["gmean"][a:b],
                "moving": w["moving"][a:b]}

    if args.split == "within":
        # per-subject time split 60/40: the deployment-relevant metric for
        # a calibrated rehab device (all 44 classes in both halves)
        for s in subjects:
            sw = [w for w in wins if w["subj"] == s]
            tr = [slice_win(w, 0, int(len(w["x"]) * 0.6)) for w in sw]
            te = [slice_win(w, int(len(w["x"]) * 0.6), len(w["x"]))
                  for w in sw]
            print("within %s (time split 60/40): train %d / test %d"
                  % (s, sum(len(w["x"]) for w in tr),
                     sum(len(w["x"]) for w in te)))
            _, _, acc, r2, (yt, yp), _ = train_fold(tr, te, args,
                                                    finger_map)
            folds[s] = {"acc": round(acc, 4), "r2": r2,
                        "n_cls_windows": int(len(yt))}
            print("within %s: acc=%.3f" % (s, acc))
            pooled_true.append(yt); pooled_pred.append(yp)
    else:
        for test_subj in subjects:
            tr = [w for w in wins if w["subj"] != test_subj]
            te = [w for w in wins if w["subj"] == test_subj]
            print("LoSo %s: train %d / test %d windows"
                  % (test_subj, sum(len(w["x"]) for w in tr),
                     sum(len(w["x"]) for w in te)))
            _, _, acc, r2, (yt, yp), _ = train_fold(tr, te, args,
                                                    finger_map)
            folds[test_subj] = {"acc": round(acc, 4),
                                "r2": r2,
                                "n_cls_windows": int(len(yt))}
            print("LoSo %s: acc=%.3f" % (test_subj, acc))
            for k in ("all", "moving"):
                print("    R2 %-6s %s" % (k, " ".join(
                    "%s=%.3f" % (f, r2[k][f]) for f in FINGERS)))
            pooled_true.append(yt); pooled_pred.append(yp)
            for k in ("all", "moving"):
                for f in FINGERS:
                    r2_all[k][f].append(r2[k][f])

    pooled_true = np.concatenate(pooled_true)
    pooled_pred = np.concatenate(pooled_pred)
    pooled_acc = round(float((pooled_true == pooled_pred).mean()), 4)
    pooled_r2 = {k: {f: round(float(np.nanmean(r2_all[k][f])), 4)
                     for f in FINGERS} for k in ("all", "moving")}

    print("\n===== pooled (split=%s) =====" % args.split)
    print("CNN classification acc=%.4f   (MLP baseline: see "
          "data/metrics/baseline.json)" % pooled_acc)
    for k in ("all", "moving"):
        print("  R2 %-6s %s" % (k, " ".join(
            "%s=%.4f" % (f, pooled_r2[k][f]) for f in FINGERS)))

    # top confused movement pairs (pooled) - drives the rehab design
    bad = pooled_true != pooled_pred
    from collections import Counter
    pairs = Counter(zip(pooled_true[bad].tolist(),
                        pooled_pred[bad].tolist()))
    print("top confused pairs (true -> pred):")
    for (t, p), cnt in pairs.most_common(12):
        print("    %-14s -> %-14s %d" % (CLASSES[t], CLASSES[p], cnt))

    # ---- final model on all subjects (LoSo runs only: the pretrained
    # backbone used as init for per-subject calibration fine-tuning) ----
    if args.split == "loso":
        print("training final model on all subjects ...")
        model, scaling, _, _, _, _ = train_fold(wins, wins, args,
                                                finger_map)
        os.makedirs(os.path.dirname(MODEL_PATH), exist_ok=True)
        th_pkg = __import__("torch")
        th_pkg.save({
            "state": {k: v for k, v in model.net.state_dict().items()},
            "cls_head": model.cls_head.state_dict(),
            "reg_head": model.reg_head.state_dict(),
            "ch_mean": scaling[0].tolist(), "ch_std": scaling[1].tolist(),
            "dof_scale": scaling[2].tolist(),
            "rest_offsets": {k: v.tolist() for k, v in scaling[4].items()},
            "finger_map": finger_map,
            "classes": CLASSES, "fingers": FINGERS,
        }, MODEL_PATH)
        n_params = count_params(model)
    else:
        n_params = count_params(DualCNN())

    metrics = {
        "config": {"fs_hz": FS, "window": args.window, "hop": HOP,
                   "task": args.task, "n_classes": len(CLASSES),
                   "rectify": bool(args.rectify),
                   "model": "DualCNN 8-16-32-32 GAP + cls/reg heads",
                   "epochs": args.epochs, "batch": args.batch,
                   "lr": args.lr, "finger_map": finger_map,
                   "rest_downsample": "rest capped at 2x movement windows",
                   "evaluation": args.split},
        "macs_per_window": count_macs(None, args.window),
        "params": n_params,
        "folds": folds,
        "pooled": {"accuracy": pooled_acc, "r2_per_finger": pooled_r2},
        "model_path": (os.path.relpath(MODEL_PATH, ROOT)
                       .replace("\\", "/")) if args.split == "loso" else None,
    }
    os.makedirs(os.path.dirname(METRICS_PATH), exist_ok=True)
    with open(METRICS_PATH, "w") as fh:
        json.dump(metrics, fh, indent=2)
    print("metrics -> %s" % os.path.relpath(METRICS_PATH, ROOT))
    print("model   -> %s" % os.path.relpath(MODEL_PATH, ROOT))
    return 0


if __name__ == "__main__":
    sys.exit(main())

