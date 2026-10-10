#!/usr/bin/env python3
"""INT8 quantization for the baseline MLP -> RTL-ready weights + validation.

Quantization scheme (must stay bit-exact with src/rtl/emg_nn_infer.v):

  input   xq = clip((x * M_in + 2^(n_in-1)) >> n_in, -127, 127)
          per-channel multiply-shift normalisation, absorbs the huge dynamic
          range of the raw PL integer features (MAV/WL/Energy/ZC/SSC)
  layer   acc = sum(w8 * x8) + b32          (w8: INT8, per-tensor symmetric;
          b32: INT32 in the accumulator domain)
  requant q  = (acc * M + 2^(n-1)) >> n, clip(-127, 127); ReLU layers clip to
          [0, 127] instead (unsigned INT8 domain)
  output  INT32 logits (softmax-invariant common scale; softmax is done on
          the PC/PS side)

The StandardScaler is fused into layer 1:
  x_hat = (x - mu) / sigma, x_in = x * a_i  with a_i = M_in/2^n_in
  =>  W1'[j,i] = W1[j,i] / (sigma_i * a_i),  b1'[j] = b1[j] - sum_i W1[j,i]*mu_i/sigma_i

Outputs:
  data/models/nn_int8/quant_params.json     all scales/shifts + memory layout
  data/models/nn_int8/nn_int8_weights.mem   $readmemh image for the RTL BRAM
  data/metrics/int8_validation.json         LoSo fold-by-fold INT8 vs float

Usage:
  python tools/export_int8.py            # preserve the historical export path
  python tools/export_int8.py --resample 20 --win-samples 400 \
      --hop-samples 100 --pl-filter --out-dir data/models/nn_int8_pl_filter
      # export a PL-aligned experiment without replacing nn_int8/
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

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import train_baseline
from train_baseline import (CLASSES, RAW_DIR, ROOT, balance_downsample,
                            load_training_session, make_windows, new_model,
                            prepare_samples)

INT8_DIR = os.path.join(ROOT, "data", "models", "nn_int8")
VAL_PATH = os.path.join(ROOT, "data", "metrics", "int8_validation.json")

# fixed-point conventions shared with the RTL
CLIP = 127
Q999 = 99.9          # calibration percentile used for output-domain scales
IN_TARGET = 100.0    # target |x| after input normalisation (headroom to 127)
M_BITS = 17          # max bits of any multiply-shift constant (fits DSP)


# ---------------------------------------------------------------------------
# fixed-point helpers (these exact operations are what the RTL implements)
# ---------------------------------------------------------------------------

def mul_shift(v, m, n):
    """(v * m + 2^(n-1)) >> n with floor semantics == RTL arithmetic shift."""
    v = np.asarray(v, dtype=np.int64)
    return (v * m + (1 << (n - 1))) >> n


def fit_shift(target):
    """Find (M, n) so round(x*M/2^n) ~ x*target, M <= 2^M_BITS-1.

    Picks the largest valid n (largest M) for maximum precision.
    """
    a = float(target)
    if a <= 0:
        return 1, 0
    best = (1, 0)
    for n in range(0, 62):
        m = int(round(a * (1 << n)))
        if m < 1:
            continue
        if m > (1 << M_BITS) - 1:
            break
        best = (m, n)
    return best


def quant_sym(w, bits=8):
    """Symmetric per-tensor quantisation to [-127, 127]."""
    s = float(np.abs(w).max()) / CLIP
    if s == 0:
        s = 1.0
    q = np.clip(np.round(w / s), -CLIP, CLIP).astype(np.int64)
    return q, s


def calib_scale(v, bits=8):
    """Scale so the Q999 percentile of |v| maps to CLIP."""
    p = np.percentile(np.abs(v), Q999)
    return float(p) / CLIP if p > 0 else 1.0


# ---------------------------------------------------------------------------
# INT8 network (bit-exact software model of the future RTL)
# ---------------------------------------------------------------------------

class Int8MLP:
    """Bit-exact INT8 inference; every op matches the planned RTL semantics."""

    def __init__(self, qp):
        self.qp = qp
        self.w = {k: np.asarray(qp[k]["q"], dtype=np.int64)
                  for k in ("w1", "w2", "w3")}
        self.b = {k: np.asarray(qp[k]["b"], dtype=np.int64)
                  for k in ("b1", "b2", "b3")}
        self.m_in = np.asarray(qp["in_shift"]["m"], dtype=np.int64)
        self.n_in = np.asarray(qp["in_shift"]["n"], dtype=np.int64)
        self.m = {k: int(qp["requant"][k]["m"]) for k in ("r1", "r2")}
        self.n = {k: int(qp["requant"][k]["n"]) for k in ("r1", "r2")}

    def forward(self, x_int):
        """x_int: (n, 40) raw PL integer features -> (n, 5) INT32 logits."""
        x = np.asarray(x_int, dtype=np.int64)
        xq = mul_shift(x, self.m_in[None, :], self.n_in[None, :])
        xq = np.clip(xq, -CLIP, CLIP)
        acc = xq @ self.w["w1"] + self.b["b1"]
        h1 = np.clip(mul_shift(acc, self.m["r1"], self.n["r1"]), 0, CLIP)
        acc = h1 @ self.w["w2"] + self.b["b2"]
        h2 = np.clip(mul_shift(acc, self.m["r2"], self.n["r2"]), 0, CLIP)
        acc = h2 @ self.w["w3"] + self.b["b3"]
        return acc                       # raw INT32 logits, no requant

    def predict(self, x_int):
        return np.argmax(self.forward(x_int), axis=1)


# ---------------------------------------------------------------------------
# quantisation of one trained float model
# ---------------------------------------------------------------------------

def quantize_model(pipeline, calib_x):
    """pipeline: StandardScaler+MLP.  calib_x: raw integer features (n, 40)."""
    scaler = pipeline.named_steps["scaler"]
    mlp = pipeline.named_steps["mlp"]
    mu, sigma = scaler.mean_.astype(np.float64), scaler.scale_.astype(np.float64)
    w1, b1 = mlp.coefs_[0].astype(np.float64), mlp.intercepts_[0].astype(np.float64)
    w2, b2 = mlp.coefs_[1].astype(np.float64), mlp.intercepts_[1].astype(np.float64)
    w3, b3 = mlp.coefs_[2].astype(np.float64), mlp.intercepts_[2].astype(np.float64)

    # ---- input normalisation: per-channel |x| Q999 -> IN_TARGET -----------
    q999 = np.percentile(np.abs(calib_x.astype(np.float64)), Q999, axis=0)
    q999 = np.maximum(q999, 1.0)
    a = IN_TARGET / q999                                    # ~= 100/quantile
    m_in, n_in = zip(*(fit_shift(a[i]) for i in range(len(a))))
    m_in, n_in = np.array(m_in, dtype=np.int64), np.array(n_in, dtype=np.int64)
    a_eff = m_in.astype(np.float64) / (1 << n_in)           # implemented gain

    # ---- fuse scaler (+ input gain) into layer 1 ---------------------------
    # sklearn coefs_[0] is (n_in, n_out) = (40, 64); normalise per input column
    # x_hat = (x - mu)/sigma, x_in = x * a_eff:
    #   W1'[j,i] = W1[j,i] / (sigma_j * a_j)
    #   b1'[i]   = b1[i] - sum_j W1[j,i] * (mu_j / sigma_j)
    w1f = w1 / (sigma[:, None] * a_eff[:, None])
    b1f = b1 - (w1 * (mu / sigma)[:, None]).sum(axis=0)

    # calibrate layer output ranges in float domain on the calibration set
    xq = np.clip(np.round(calib_x.astype(np.float64) * a_eff[None, :]),
                 -CLIP, CLIP)
    h1f = np.maximum(xq @ w1f + b1f, 0.0)
    h2f = np.maximum(h1f @ w2 + b2, 0.0)

    # ---- layer 1: per-tensor weights, INT32 bias in accumulator domain -----
    w1q, s_w1 = quant_sym(w1f)
    s_out1 = calib_scale(h1f)
    s_r1 = s_w1 / s_out1
    m1, n1 = fit_shift(s_r1)
    b1q = np.clip(np.round(b1f / s_w1), -(1 << 30), (1 << 30)).astype(np.int64)

    # ---- layer 2: accumulator scale is s_out1 * s_w2 (h1 carries s_out1) ----
    w2q, s_w2 = quant_sym(w2)
    s_acc2 = s_out1 * s_w2
    s_out2 = calib_scale(h2f)
    s_r2 = s_acc2 / s_out2
    m2, n2 = fit_shift(s_r2)
    b2q = np.clip(np.round(b2 / s_acc2), -(1 << 30), (1 << 30)).astype(np.int64)

    # ---- layer 3: output stays INT32 (logits), no requant -------------------
    # accumulator scale is s_out2 * s_w3; recorded so PC/PS can float-ify
    w3q, s_w3 = quant_sym(w3)
    s_acc3 = s_out2 * s_w3
    b3q = np.clip(np.round(b3 / s_acc3), -(1 << 30), (1 << 30)).astype(np.int64)

    qp = {
        "in_shift": {"m": m_in.tolist(), "n": n_in.tolist(),
                     "note": "xq = (x*M + 2^(n-1)) >> n, clip to [-127,127]"},
        "w1": {"q": w1q.tolist(), "scale": s_w1},
        "b1": {"b": b1q.tolist()},
        "requant": {"r1": {"m": m1, "n": n1}, "r2": {"m": m2, "n": n2}},
        "w2": {"q": w2q.tolist(), "scale": s_w2},
        "b2": {"b": b2q.tolist()},
        "w3": {"q": w3q.tolist(), "scale": s_w3},
        "b3": {"b": b3q.tolist()},
        "logits_scale": s_acc3,
        "classes": CLASSES,
        "conventions": {
            "requant": "(acc*M + 2^(n-1)) >> n, floor; clip [-127,127]",
            "relu_layers": "clip to [0,127] after requant",
            "logits": "INT32, common scale is softmax-invariant",
            "calibration": "Q%d percentile of |layer output|, %s" % (Q999, "train split"),
        },
    }
    return qp


# ---------------------------------------------------------------------------
# memory image for the RTL BRAM ($readmemh, @word address, 32-bit words)
# ---------------------------------------------------------------------------

def u8(v):
    return "%02x" % (int(v) & 0xFF)


def u32(v):
    return "%08x" % (int(v) & 0xFFFFFFFF)


# word addresses of every segment (MUST stay in sync with emg_nn_infer.v)
# w1 spans 640 words [0x050..0x2CF], w2 512 [0x312..0x511], w3 40 [0x534..0x55B]
MEM_LAYOUT = {
    "m_in": 0x000, "n_in": 0x028,
    "w1": 0x050, "b1": 0x2D0, "requant1": 0x310,
    "w2": 0x312, "b2": 0x512, "requant2": 0x532,
    "w3": 0x534, "b3": 0x55C,
    "word_width_bits": 32,
    "w_words": [10, 16, 8],          # words per neuron: 40/4, 64/4, 32/4
    "note": "weights stored neuron-major (W^T flattened), 4 INT8 per 32-bit "
            "word, little-endian: byte k = (in_index & 3) -> bits [8k+7:8k]",
}


def pack_words(bytes_seq):
    """Pack a byte sequence little-endian into 32-bit words.

    Mask every byte to 0xFF first: raw negative Python ints carry infinite
    sign-extension whose 1-bits would pollute every higher byte of the word.
    """
    vals = [int(v) & 0xFF for v in bytes_seq]
    if len(vals) % 4:
        vals += [0] * (4 - len(vals) % 4)
    return [vals[i] | (vals[i + 1] << 8) | (vals[i + 2] << 16)
            | (vals[i + 3] << 24) for i in range(0, len(vals), 4)]


def build_mem(qp):
    lines = []
    w1 = np.asarray(qp["w1"]["q"]).T                  # (64, 40) neuron-major
    w2 = np.asarray(qp["w2"]["q"]).T                  # (32, 64)
    w3 = np.asarray(qp["w3"]["q"]).T                  # (5, 32)

    def seg(addr, words, comment):
        lines.append("// %s @0x%03x" % (comment, addr))
        for i, v in enumerate(words):
            lines.append("@%04x %08x" % (addr + i, v & 0xFFFFFFFF))

    m_in = np.asarray(qp["in_shift"]["m"]) & 0xFFFFFFFF
    n_in = np.asarray(qp["in_shift"]["n"]) & 0xFFFFFFFF
    seg(MEM_LAYOUT["m_in"], m_in.tolist(), "input gain M[40] u32")
    seg(MEM_LAYOUT["n_in"], n_in.tolist(), "input shift n[40] u32")
    seg(MEM_LAYOUT["w1"], pack_words(w1.reshape(-1).tolist()),
        "W1 INT8 neuron-major (64 neurons x 40 inputs)")
    seg(MEM_LAYOUT["b1"], qp["b1"]["b"], "b1 INT32[64]")
    seg(MEM_LAYOUT["requant1"],
        [qp["requant"]["r1"]["m"], qp["requant"]["r1"]["n"]],
        "requant1 (m, n)")
    seg(MEM_LAYOUT["w2"], pack_words(w2.reshape(-1).tolist()),
        "W2 INT8 neuron-major (32 x 64)")
    seg(MEM_LAYOUT["b2"], qp["b2"]["b"], "b2 INT32[32]")
    seg(MEM_LAYOUT["requant2"],
        [qp["requant"]["r2"]["m"], qp["requant"]["r2"]["n"]],
        "requant2 (m, n)")
    seg(MEM_LAYOUT["w3"], pack_words(w3.reshape(-1).tolist()),
        "W3 INT8 neuron-major (5 x 32)")
    seg(MEM_LAYOUT["b3"], qp["b3"]["b"], "b3 INT32[5]")
    return "\n".join(lines) + "\n"


# ---------------------------------------------------------------------------
# data loading (same as training pipeline)
# ---------------------------------------------------------------------------

def load_all(sessions, fs=200, decim=1, resample=1,
             win_samples=0, hop_samples=0, pl_filter=False,
             requested_subjects=None, input_mode="baseline"):
    """Load features using the same preprocessing contract as training."""
    train_baseline.FS = fs
    train_baseline.WINDOW = (
        win_samples or train_baseline.WINDOW_MS * fs // 1000)
    train_baseline.HOP = hop_samples or train_baseline.HOP_MS * fs // 1000
    input_suffix = "full" if input_mode == "full" else "baseline"
    subjects = sorted({
        os.path.basename(os.path.dirname(p))
        for p in glob.glob(os.path.join(
            RAW_DIR, "s*", "*_E*_A1_%s.csv" % input_suffix))
    })
    if requested_subjects:
        requested = {s.lower() for s in requested_subjects}
        subjects = [s for s in subjects if s.lower() in requested]
    data = {}
    for subj in subjects:
        xs, ys = [], []
        for e in sessions:
            x, y = load_training_session(RAW_DIR, subj, e, input_mode)
            x, y = prepare_samples(x, y, decim, resample, pl_filter)
            f, wy = make_windows(x, y)
            xs.append(f)
            ys.append(wy)
        data[subj] = (np.concatenate(xs), np.concatenate(ys))
    return data


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--sessions", type=int, nargs="+", default=[2])
    ap.add_argument("--subjects", nargs="+", default=None,
                    help="subject directory names to include (default: all)")
    ap.add_argument("--input-mode", choices=("baseline", "full"),
                    default="baseline",
                    help="baseline rows or continuous *_full.csv stream")
    ap.add_argument("--fs", type=int, default=200)
    ap.add_argument("--decim", type=int, default=1)
    ap.add_argument("--resample", type=int, default=1,
                    help="repeat each input sample before filtering/windowing")
    ap.add_argument("--win-samples", type=int, default=0,
                    help="window length; default is 200 ms at --fs")
    ap.add_argument("--hop-samples", type=int, default=0,
                    help="hop length; default is 50 ms at --fs")
    ap.add_argument("--pl-filter", action="store_true",
                    help="apply the exact integer PL bandpass")
    ap.add_argument("--hidden", type=int, nargs="+", default=[64, 32])
    ap.add_argument("--seed", type=int, default=0)
    ap.add_argument("--no-balance", action="store_true")
    ap.add_argument("--out-dir", default=INT8_DIR,
                    help="directory for quant params, vectors and weights")
    ap.add_argument("--metrics-path", default=VAL_PATH)
    args = ap.parse_args()

    sessions = args.sessions
    seed = args.seed
    hidden = args.hidden
    data = load_all(
        sessions, fs=args.fs, decim=args.decim, resample=args.resample,
        win_samples=args.win_samples, hop_samples=args.hop_samples,
        pl_filter=args.pl_filter, requested_subjects=args.subjects,
        input_mode=args.input_mode)
    subjects = sorted(data)
    print("subjects: %s, windows: %s" % (
        subjects, {s: len(data[s][1]) for s in subjects}))
    rng = np.random.default_rng(seed)

    report = {"config": {
                  "sessions": sessions, "subjects": subjects, "seed": seed,
                  "hidden": hidden, "fs_hz": args.fs,
                  "decim": args.decim, "resample": args.resample,
                  "window_samples": train_baseline.WINDOW,
                  "hop_samples": train_baseline.HOP,
                  "effective_fs_hz": args.fs * args.resample // args.decim,
                  "pl_filter": args.pl_filter,
                  "input_mode": args.input_mode,
                  "balance": "none" if args.no_balance else "rest downsampled",
                  "classes": CLASSES},
              "folds": {}}

    # ---- LoSo folds: quantize each fold model, evaluate on its test set ----
    for test_subj in subjects:
        tr_x = np.concatenate([data[s][0] for s in subjects if s != test_subj])
        tr_y = np.concatenate([data[s][1] for s in subjects if s != test_subj])
        te_x, te_y = data[test_subj]
        if args.no_balance:
            tr_xb, tr_yb = tr_x, tr_y
        else:
            tr_xb, tr_yb = balance_downsample(tr_x, tr_y, rng)
        model = new_model(hidden, seed)
        model.fit(tr_xb, tr_yb)
        f_pred = model.predict(te_x)
        f_acc = float(accuracy_score(te_y, f_pred))

        qp = quantize_model(model, tr_x)                 # calibrate on train split
        i_pred = Int8MLP(qp).predict(te_x)
        i_acc = float(accuracy_score(te_y, i_pred))
        agree = float((f_pred == i_pred).mean())
        report["folds"][test_subj] = {
            "float_acc": round(f_acc, 4),
            "int8_acc": round(i_acc, 4),
            "float_f1": round(float(f1_score(te_y, f_pred, average="macro")), 4),
            "int8_f1": round(float(f1_score(te_y, i_pred, average="macro")), 4),
            "prediction_agreement": round(agree, 4),
            "test_windows": int(len(te_y)),
        }
        print("LoSo %s: float %.4f -> int8 %.4f (agree %.4f)"
              % (test_subj, f_acc, i_acc, agree))

    # ---- final model: full data, calibrate on raw distribution -------------
    all_x = np.concatenate([data[s][0] for s in subjects])
    all_y = np.concatenate([data[s][1] for s in subjects])
    if args.no_balance:
        all_xb, all_yb = all_x, all_y
    else:
        all_xb, all_yb = balance_downsample(all_x, all_y, rng)
    final = new_model(hidden, seed)
    final.fit(all_xb, all_yb)
    f_pred = final.predict(all_xb)
    qp = quantize_model(final, all_x)                    # raw distribution calib
    net = Int8MLP(qp)
    i_pred = net.predict(all_xb)
    agree = float((f_pred == i_pred).mean())
    report["final"] = {
        "float_train_acc": round(float(accuracy_score(all_yb, f_pred)), 4),
        "int8_train_acc": round(float(accuracy_score(all_yb, i_pred)), 4),
        "prediction_agreement": round(agree, 4),
        "note": "quantisation fidelity on training windows; generalisation "
                "is the LoSo table above",
    }
    print("final: float %.4f -> int8 %.4f (agree %.4f)"
          % (report["final"]["float_train_acc"],
             report["final"]["int8_train_acc"], agree))

    # ---- persist ------------------------------------------------------------
    qp["mem_layout"] = MEM_LAYOUT
    out_dir = args.out_dir
    metrics_path = args.metrics_path
    os.makedirs(out_dir, exist_ok=True)
    demo = all_xb[:64]
    # $readmemh golden vectors for the RTL testbench: 64 windows, one u32
    # feature / logit per word, row-major.
    with open(os.path.join(out_dir, "tb_inputs.mem"), "w") as fh:
        for v in demo.reshape(-1).tolist():
            fh.write("%08x\n" % (int(v) & 0xFFFFFFFF))
    with open(os.path.join(out_dir, "tb_logits.mem"), "w") as fh:
        for v in net.forward(demo).reshape(-1).tolist():
            fh.write("%08x\n" % (int(v) & 0xFFFFFFFF))
    with open(os.path.join(out_dir, "quant_params.json"), "w") as fh:
        json.dump(qp, fh, indent=1)
    with open(os.path.join(out_dir, "nn_int8_weights.mem"), "w") as fh:
        fh.write(build_mem(qp))
    os.makedirs(os.path.dirname(metrics_path), exist_ok=True)
    with open(metrics_path, "w") as fh:
        json.dump(report, fh, indent=2)

    print("weights  -> %s" % os.path.relpath(
        os.path.join(out_dir, "nn_int8_weights.mem"), ROOT))
    print("params   -> %s" % os.path.relpath(
        os.path.join(out_dir, "quant_params.json"), ROOT))
    print("metrics  -> %s" % os.path.relpath(metrics_path, ROOT))
    return 0


if __name__ == "__main__":
    sys.exit(main())
