#!/usr/bin/env python3
"""PC-side inference for the sEMG hand-motion baseline (PC-in-the-loop).

Two input sources:

  --csv FILE   Replay a contract CSV (data/raw/ninapro_db5/...): windows and
               features are computed exactly like training, then classified.
               Used to validate the inference path without hardware.
  --port COM3  Read the live F-rows emitted by sw/ps_uart_print over UART
               (one CSV line per 200 ms window = 40 model inputs, ordered
               MAV*8, WL*8, Energy*8, ZC*8, SSC*8) and classify in real time.

The model is data/models/baseline_mlp.joblib (StandardScaler + MLP), trained
by tools/train_baseline.py.

Usage:
  python tools/realtime_inference.py --csv data/raw/ninapro_db5/s1/S1_E2_A1_baseline.csv
  python tools/realtime_inference.py --port COM3
"""

import argparse
import os
import sys
import time

import joblib
import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from train_baseline import CLASSES, load_session_csv, make_windows  # noqa: E402

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MODEL_PATH = os.path.join(ROOT, "data", "models", "baseline_mlp.joblib")

CN = ["放松", "张手", "握拳", "屈腕", "伸腕"]


def load_model():
    if not os.path.exists(MODEL_PATH):
        print("model not found: %s (run tools/train_baseline.py first)" % MODEL_PATH)
        sys.exit(1)
    return joblib.load(MODEL_PATH)


def describe(proba):
    order = np.argsort(proba)[::-1]
    top = " ".join("%s %.0f%%" % (CLASSES[i], proba[i] * 100) for i in order[:2])
    return "%s(%s) | %s" % (CN[order[0]], CLASSES[order[0]], top)


def run_csv(model, path, every):
    x, y = load_session_csv(path)
    feat, win_y = make_windows(x, y)
    print("replay %s: %d windows" % (os.path.basename(path), len(feat)))
    pred = model.predict(feat)
    proba = model.predict_proba(feat)
    acc = float((pred == win_y).mean())
    for k in range(0, len(feat), every):
        truth = CN[int(win_y[k])]
        mark = " " if pred[k] == win_y[k] else "X"
        print("w%-6d true=%-6s -> %s %s" % (k, truth, describe(proba[k]), mark))
    print("\nreplay accuracy: %.3f over %d windows" % (acc, len(feat)))


def run_port(model, port, baud):
    try:
        import serial
    except ImportError:
        print("pyserial not installed: pip install pyserial")
        return 1
    ser = serial.Serial(port, baud, timeout=1)
    print("listening %s @ %d - waiting for F-rows (Ctrl+C to stop)" % (port, baud))
    n = 0
    try:
        while True:
            line = ser.readline().decode("ascii", "replace").strip()
            if not line:
                continue
            if line.startswith("[STAT]") or line.startswith("==="):
                print("[board] %s" % line)
                continue
            if not line.startswith("F,"):
                continue
            vals = np.fromstring(line[2:], dtype=np.float64, sep=",")
            if vals.size != 40:
                print("[bad row, %d values]" % vals.size)
                continue
            proba = model.predict_proba(vals.reshape(1, -1))[0]
            n += 1
            print("w%-6d -> %s" % (n, describe(proba)))
    except KeyboardInterrupt:
        print("\nstopped after %d windows" % n)
    finally:
        ser.close()
    return 0


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    src = ap.add_mutually_exclusive_group(required=True)
    src.add_argument("--csv", help="replay a contract CSV file")
    src.add_argument("--port", help="serial port with board F-rows (e.g. COM3)")
    ap.add_argument("--baud", type=int, default=115200)
    ap.add_argument("--every", type=int, default=20,
                    help="replay: print one line per N windows (default 20)")
    args = ap.parse_args()

    model = load_model()
    if args.csv:
        run_csv(model, os.path.abspath(args.csv), args.every)
        return 0
    return run_port(model, args.port, args.baud)


if __name__ == "__main__":
    sys.exit(main())
