#!/usr/bin/env python3
"""Generate/check file-driven XSim notch tests; never opens board hardware."""
import argparse
import csv
import json
import math
from pathlib import Path

import numpy as np
from emg_reference import Notch50

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "sim" / "results_notch50"
FREQUENCIES = [50, 49, 51, 40, 60, 100, 215, 450]


def generate():
    OUT.mkdir(parents=True, exist_ok=True)
    models = [Notch50() for _ in range(8)]
    count = 0
    rng = np.random.default_rng(20261015)
    with (OUT / "notch_stim.txt").open("w") as fh:
        # Reset -> tones; reset -> full-scale stress -> zero recovery;
        # reset -> repeated cold-start impulse. CH1 stress stays exactly zero.
        for block, length in enumerate([16000, 4096, 8000, 128]):
            if block != 2:
                models = [Notch50() for _ in range(8)]
            for frame in range(length):
                for ch in range(8):
                    reset = int(frame == ch == 0 and block != 2)
                    if block == 0:
                        dc = [3000000, -2500000, 0, 2000000, 0, -1000000, 0, 0][ch]
                        x = dc + round(500000 * math.sin(
                            2 * math.pi * FREQUENCIES[ch] * frame / 4000 + ch * .17))
                    elif block == 1:
                        x = [8388607 if frame < 512 else -8388608, 0,
                             8388607, -8388608 if frame & 1 else 8388607,
                             int(rng.integers(-8388608, 8388608)),
                             (frame % 3) - 1,
                             -8388608 if frame == 0 else 8388607 if frame == 1024 else 0,
                             round(8388607 * math.sin(2 * math.pi * 50 * frame / 4000))][ch]
                    elif block == 2:
                        x = 0
                    else:
                        x = (ch + 1) * 12345 if frame == 0 else 0
                    y = models[ch].step(x)
                    seq = (65530 + frame) & 0xffff
                    gap = [12, 13, 23][count % 3]
                    fh.write(f"{reset} {block} {frame} {ch} {seq} {x} {y} {gap}\n")
                    count += 1
    print(f"notch stimulus: {count} beats; independent tones, full scale, recovery, reset, wrap")


def check():
    with (OUT / "notch_out.csv").open() as fh:
        rows = np.asarray([[int(x) for x in r] for r in list(csv.reader(fh))[1:]])
    assert rows.shape == ((16000 + 4096 + 8000 + 128) * 8, 5), rows.shape
    # Recompute expected states without reading the stimulus golden column.
    with (OUT / "notch_stim.txt").open() as fh:
        models = [Notch50() for _ in range(8)]
        for i, line in enumerate(fh):
            reset, block, frame, ch, seq, x, _, _ = map(int, line.split())
            if reset:
                models = [Notch50() for _ in range(8)]
            expected = models[ch].step(x)
            assert list(rows[i]) == [block, frame, ch, seq, expected], (i, rows[i], expected)
    measurements = []
    for ch, freq in enumerate(FREQUENCIES):
        select = (rows[:, 0] == 0) & (rows[:, 2] == ch) & (rows[:, 1] >= 4000)
        part = rows[select]
        t = part[:, 1] / 4000
        design = np.column_stack([np.sin(2 * np.pi * freq * t),
                                  np.cos(2 * np.pi * freq * t), np.ones(len(t))])
        fit = np.linalg.lstsq(design, part[:, 4], rcond=None)[0]
        db = 20 * np.log10(max(np.hypot(*fit[:2]), 1e-12) / 500000)
        z = np.exp(-2j * np.pi * freq / 4000)
        expected = 20 * np.log10(abs(
            (Notch50.B0 + Notch50.B1*z + Notch50.B0*z*z) /
            ((1 << 24) + Notch50.B1*z + Notch50.A2*z*z)))
        assert abs(db - expected) < .15, (freq, db, expected)
        if freq == 50:
            assert db < -65, db
        if freq in (40, 60):
            assert db > -.4, (freq, db)
        measurements.append({"frequency_hz": freq, "rtl_gain_db": round(float(db), 4)})
    quiet = rows[(rows[:, 0] == 1) & (rows[:, 2] == 1), 4]
    assert np.all(quiet == 0), "cross-channel state leakage"
    tail = rows[(rows[:, 0] == 2) & (rows[:, 1] >= 4000), 4]
    assert np.max(np.abs(tail)) <= 1, "feedback did not recover after full-scale stress"
    summary = {"filter": Notch50.FILTER_ID, "samples_bit_exact": len(rows),
               "measurements": measurements, "full_scale_recovery_max_counts": int(np.max(np.abs(tail))),
               "hardware_measured": False}
    (OUT / "notch_summary.json").write_text(json.dumps(summary, indent=2) + "\n")
    print(json.dumps(summary, indent=2))
    print("check-notch50 PASSED: bit-exact RTL, attenuation, passband, isolation, recovery")


if __name__ == "__main__":
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("command", choices=["gen", "check"])
    (generate if ap.parse_args().command == "gen" else check)()

