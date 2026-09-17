import os, sys, glob
import numpy as np
import joblib

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from train_baseline import load_session_csv, make_windows, CLASSES, RAW_DIR
from export_int8 import quantize_model, Int8MLP, CLIP

model = joblib.load(os.path.join(os.path.dirname(os.path.dirname(
    os.path.abspath(__file__))), "data", "models", "baseline_mlp.joblib"))

xs, ys = [], []
for p in sorted(glob.glob(os.path.join(RAW_DIR, "s*", "S*_E2_A1_baseline.csv"))):
    x, y = load_session_csv(p)
    f, wy = make_windows(x, y)
    xs.append(f)
    ys.append(wy)
X = np.concatenate(xs)
Y = np.concatenate(ys)
print("data:", X.shape, "labels:", np.bincount(Y))

qp = quantize_model(model, X)
net = Int8MLP(qp)

m_in = np.array(qp["in_shift"]["m"]); n_in = np.array(qp["in_shift"]["n"])
a_eff = m_in / (1 << n_in)
print("\na_eff range: %.3g .. %.3g" % (a_eff.min(), a_eff.max()))
print("w1q range:", np.array(qp["w1"]["q"]).min(), np.array(qp["w1"]["q"]).max(),
      "scale %.3g" % qp["w1"]["scale"])
b1 = np.array(qp["b1"]["b"]); print("b1q range:", b1.min(), b1.max())
w2 = np.array(qp["w2"]["q"]); print("w2q range:", w2.min(), w2.max(),
      "scale %.3g" % qp["w2"]["scale"])
b2 = np.array(qp["b2"]["b"]); print("b2q range:", b2.min(), b2.max())
w3 = np.array(qp["w3"]["q"]); print("w3q range:", w3.min(), w3.max(),
      "scale %.3g" % qp["w3"]["scale"])
print("r1:", qp["requant"]["r1"], " r2:", qp["requant"]["r2"])

# step-by-step on 8 windows
x = X[:8].astype(np.int64)
xq = np.clip((x * m_in[None, :] + (1 << (n_in[None, :] - 1))) >> n_in[None, :],
             -CLIP, CLIP)
print("\nxq range:", xq.min(), xq.max())
acc1 = xq @ np.array(qp["w1"]["q"]) + b1
print("acc1 range:", acc1.min(), acc1.max())
m1, n1 = qp["requant"]["r1"]["m"], qp["requant"]["r1"]["n"]
h1 = np.clip((acc1 * m1 + (1 << (n1 - 1))) >> n1, 0, CLIP)
print("h1 range:", h1.min(), h1.max(), "nonzero frac %.3f" % (h1 > 0).mean())
acc2 = h1 @ np.array(qp["w2"]["q"]) + b2
print("acc2 range:", acc2.min(), acc2.max())
m2, n2 = qp["requant"]["r2"]["m"], qp["requant"]["r2"]["n"]
h2 = np.clip((acc2 * m2 + (1 << (n2 - 1))) >> n2, 0, CLIP)
print("h2 range:", h2.min(), h2.max(), "nonzero frac %.3f" % (h2 > 0).mean())
logits = h2 @ np.array(qp["w3"]["q"]) + np.array(qp["b3"]["b"])
print("logits range:", logits.min(), logits.max())
print("logits[0]:", logits[0])

# ---- per-layer scale consistency check ----------------------------------
import export_int8 as ex
from sklearn.preprocessing import StandardScaler
scaler = model.named_steps["scaler"]
mu, sigma = scaler.mean_, scaler.scale_
mlp = model.named_steps["mlp"]
w1f = mlp.coefs_[0] / (sigma[:, None] * a_eff[:, None])
b1f = mlp.intercepts_[0] - (mlp.coefs_[0] * (mu / sigma)[:, None]).sum(axis=0)
xf8 = np.round(X[:8] * a_eff[None, :])
h1f_ref = np.maximum(xf8 @ w1f + b1f, 0.0)
h2f_ref = np.maximum(h1f_ref @ mlp.coefs_[1] + mlp.intercepts_[1], 0.0)
# recompute calibration scales exactly as quantize_model does
xq_f = np.clip(xf8, -CLIP, CLIP)
H1 = np.maximum(xq_f @ w1f + b1f, 0.0)
H2 = np.maximum(H1 @ mlp.coefs_[1] + mlp.intercepts_[1], 0.0)
s_out1 = ex.calib_scale(H1)
s_out2 = ex.calib_scale(H2)
s_w2 = qp["w2"]["scale"]
print("\ns_out1=%.4g s_out2=%.4g s_w2=%.4g" % (s_out1, s_out2, s_w2))
print("h1f[0,:6]:", np.round(h1f_ref[0, :6], 2))
print("h1*s_out1 :", np.round(h1[0, :6] * s_out1, 2))
print("h2f[0,:6]:", np.round(h2f_ref[0, :6], 2))
print("h2*s_out2 :", np.round(h2[0, :6] * s_out2, 2))
acc2_f_equiv = acc2 * (s_out1 * s_w2)
print("acc2*sacc2 :", np.round(acc2_f_equiv[0, :6], 2))
print("y2f ref    :", np.round((h1f_ref @ mlp.coefs_[1]
                               + mlp.intercepts_[1])[0, :6], 2))

# float reference
sc = model.named_steps["scaler"]
xf = (X[:8] - sc.mean_) / sc.scale_
mlp = model.named_steps["mlp"]
f1 = np.maximum(xf @ mlp.coefs_[0] + mlp.intercepts_[0], 0)
f2 = np.maximum(f1 @ mlp.coefs_[1] + mlp.intercepts_[1], 0)
fl = f2 @ mlp.coefs_[2] + mlp.intercepts_[2]
print("float logits[0]:", fl[0])

pred_i = net.predict(X[:2000])
pred_f = model.predict(X[:2000])
print("\nfirst-2000 agree float vs int8: %.3f" % (pred_i == pred_f).mean())
