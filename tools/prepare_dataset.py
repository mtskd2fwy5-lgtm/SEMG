#!/usr/bin/env python3
"""Convert NinaPro DB5 .mat files to the data/README.md contract CSV.

Baseline class mapping. `restimulus` codes in DB5 are LOCAL to each
exercise file (E1: 1-12, E2: 1-17, E3: 1-23); the global Ninapro
52-movement list shared by DB1/DB4/DB5 is recovered with the offsets
E1 +0, E2 +12, E3 +29:

    rest       <- 0 in every exercise (between-movement rest intervals)
    open_hand  <- E2 local 5  = global 17 "Abduction of all fingers" -
                      closest static open-hand configuration in the list
    fist       <- E2 local 6  = global 18 "Fingers flexed together in fist"
    wrist_flex <- E2 local 13 = global 25 "Wrist flexion"
    wrist_extend <- E2 local 14 = global 26 "Wrist extension"

Channels: 4+4 across the two Myo rings, selected by muscle function.
16-electrode activation analysis (5-class RMS contrast vs rest, s1-s3)
shows clear muscle groups: fist/wrist_flex dominate on the flexor-side
electrodes E03/E05/E06/E08 (proximal ring) and E13/E14/E15 (distal ring,
best SNR: E14 fist contrast 16.8x); open_hand/wrist_extend dominate on
E02/E03 (proximal) and E09/E10 (distal). Selected 8 channels give every
class >=2 strong channels with flexor/extensor coverage balanced:
  channel_0..3 = proximal ring emg cols E03,E05,E06,E08 (0-based 2,4,5,7)
  channel_4..7 = distal ring  emg cols E09,E10,E14,E15 (0-based 8,9,13,14)
Signal values are kept as raw Myo codes (-128..127), no uV scaling exists
for the Myo hardware; this is recorded in the sidecar JSON.

Per contract, training/test trials from the same recording are NOT mixed
silently: the sidecar records the subject-wise cross-validation advice
and every row keeps its subject and session columns so any split can be
reproduced.

Usage:
  python tools/prepare_dataset.py                    # all downloaded subjects
  python tools/prepare_dataset.py --subjects 1 2 3
  python tools/prepare_dataset.py --all-movements    # keep other moves as mv<global>

Output layout:
  data/raw/ninapro_db5/s{n}/S{n}_E{e}_baseline.csv   (contract rows)
  data/raw/ninapro_db5/s{n}/S{n}_E{e}_baseline.json  (sidecar)
"""

import argparse
import glob
import json
import os
import re
import sys

import numpy as np
from scipy.io import loadmat

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RAW_DIR = os.path.join(ROOT, "data", "raw", "ninapro_db5")

SOURCE = {
    "dataset": "NinaPro DB5 (double Myo armband)",
    "zenodo_record": "https://zenodo.org/records/1000116",
    "doi": "10.5281/zenodo.1000138",
    "reference": "Pizzolato et al., Comparison of six electromyography "
                 "acquisition setups on hand movement classification "
                 "tasks, PLoS ONE 2017",
}

# restimulus is LOCAL per exercise file; baseline classes live in E2.
BASELINE_BY_EXERCISE = {
    2: {5: "open_hand", 6: "fist", 13: "wrist_flex", 14: "wrist_extend"},
}
# global 52-movement list index = local code + offset (E1: 1-12, E2: 13-29,
# E3: 30-52); used to name non-baseline movements in --all-movements mode
GLOBAL_OFFSET = {1: 0, 2: 12, 3: 29}

SESSIONS = {
    1: "basic finger movements (Ninapro exercise A)",
    2: "hand configurations and wrist movements (exercise B)",
    3: "grasping and functional movements (exercise C)",
}

HEADER = ["timestamp_us"] + ["channel_%d" % c for c in range(8)] + \
         ["action", "subject", "session"]


def convert_mat(mat_path, all_movements):
    """Yield contract CSV lines for one .mat file. Returns (n_kept, n_total)."""
    m = loadmat(mat_path)
    # 4+4 across the two rings, muscle-function selected (see module docstring):
    # proximal E03,E05,E06,E08 + distal E09,E10,E14,E15 (1-based electrode ids)
    CH = [2, 4, 5, 7, 8, 9, 13, 14]
    emg = m["emg"][:, CH].astype(np.int32)      # raw Myo codes, int8 scale
    restim = m["restimulus"].ravel().astype(np.int32)
    freq = int(np.ravel(m["frequency"])[0]) if "frequency" in m else 200
    # subject/exercise come from the filename: the mat's own scalar fields
    # are not guaranteed to match (observed: exercise field off by one set)
    name = os.path.basename(mat_path)
    subj, exercise = (int(v) for v in
                      re.match(r"S(\d+)_E(\d+)_", name).groups())
    tick_us = 1_000_000 // freq

    kept = 0
    total = len(restim)
    lines = []
    stamp = 0
    baseline = BASELINE_BY_EXERCISE.get(exercise, {})
    offset = GLOBAL_OFFSET[exercise]
    for i in range(total):
        code = int(restim[i])
        if code == 0:
            action = "rest"
        elif code in baseline:
            action = baseline[code]
        elif all_movements:
            action = "mv%d" % (code + offset)
        else:
            stamp += tick_us
            continue
        row = emg[i]
        lines.append("%d,%s,%s,s%d,e%d" % (
            stamp, ",".join("%d" % v for v in row), action, subj, exercise))
        stamp += tick_us
        kept += 1
    return lines, kept, total, freq, subj, exercise


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--subjects", type=int, nargs="+", default=None,
                    help="subject numbers to convert (default: all found)")
    ap.add_argument("--all-movements", action="store_true",
                    help="keep non-baseline movements as mvNN rows")
    args = ap.parse_args()

    pattern = os.path.join(RAW_DIR, "s*", "S*_E*_A1.mat")
    mat_files = sorted(glob.glob(pattern))
    if args.subjects is not None:
        allowed = tuple("S%d_" % n for n in args.subjects)
        mat_files = [p for p in mat_files
                     if os.path.basename(p).startswith(allowed)]
    if not mat_files:
        print("no .mat files under %s - run tools/download_dataset.py first" % RAW_DIR)
        return 1

    for mat_path in mat_files:
        base = os.path.splitext(mat_path)[0]
        csv_path = base + "_baseline.csv"
        json_path = base + "_baseline.json"
        lines, kept, total, freq, subj, exercise = convert_mat(mat_path,
                                                               args.all_movements)
        with open(csv_path, "w", newline="\n") as fh:
            fh.write(",".join(HEADER) + "\n")
            fh.write("\n".join(lines))
            fh.write("\n")
        sidecar = {
            "file": os.path.relpath(csv_path, ROOT).replace("\\", "/"),
            "source": SOURCE,
            "sample_rate_hz": freq,
            "channels": 8,
            "channel_map": "muscle-function selected, 4+4 across the two Myo "
                           "rings: channel_0..3 = proximal ring electrodes "
                           "E03,E05,E06,E08 (flexor-dominant side); "
                           "channel_4..7 = distal ring E09,E10,E14,E15 "
                           "(extensor + best-SNR fist electrodes)",
            "units": "raw Myo ADC codes, int8 scale (-128..127)",
            "session": SESSIONS.get(exercise, "exercise %d" % exercise),
            "baseline_map": {
                "rest": "0 in every exercise",
                "open_hand": "E2 local 5 = global 17 (abduction of all fingers)",
                "fist": "E2 local 6 = global 18 (fingers flexed together in fist)",
                "wrist_flex": "E2 local 13 = global 25 (wrist flexion)",
                "wrist_extend": "E2 local 14 = global 26 (wrist extension)",
            },
            "rows_total": total,
            "rows_kept": kept,
            "dropped_non_baseline": total - kept,
            "split_advice": "subject-wise cross-validation: never mix train "
                            "and test rows from the same subject recording "
                            "without recording the split (data contract)",
        }
        with open(json_path, "w") as fh:
            json.dump(sidecar, fh, indent=2)
        print("s%d e%d: %d/%d rows -> %s" % (subj, exercise, kept, total,
                                             os.path.relpath(csv_path, ROOT)))
    print("done.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
