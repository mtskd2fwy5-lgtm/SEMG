"""Bit-exact XSim and independent frequency-response checks for notch + comb."""
import argparse
import csv
import json
import math
from pathlib import Path
import numpy as np
from scipy import signal
from emg_reference import NotchComb, Comb50, ProcessedSignal, HP_B0, HP_B1, HP_B2, HP_A1, HP_A2, LP_ALPHA

OUT = Path(__file__).resolve().parents[1] / "sim" / "results_line_filter"
TONES = [[50, 49, 51, 75, 100, 150, 250, 450],
         [40, 60, 125, 175, 200, 300, 350, 400]]
LENGTHS = [32000, 32000, 4096, 32000, 257]
MODEL = NotchComb
FINAL = False


def generate():
    OUT.mkdir(parents=True, exist_ok=True)
    rng = np.random.default_rng(20261021)
    n = 0
    with (OUT / "notch_stim.txt").open("w") as f:
        for block, length in enumerate(LENGTHS):
            if block != 3:
                models = [MODEL() for _ in range(8)]
            for frame in range(length):
                for ch in range(8):
                    reset = int(frame == ch == 0 and block != 3)
                    if block < 2:
                        x = 2000000 + round(500000 * math.sin(
                            2 * math.pi * TONES[block][ch] * frame / 4000 + ch * .17))
                    elif block == 2:
                        x = [8388607 if frame < 512 else -8388608, 0,
                             8388607, -8388608 if frame & 1 else 8388607,
                             int(rng.integers(-8388608, 8388608)), (frame % 3)-1,
                             -8388608 if frame == 0 else 8388607 if frame == 1024 else 0,
                             round(8388607 * math.sin(2 * math.pi * 50 * frame / 4000))][ch]
                    elif block == 3:
                        x = 0
                    else:
                        x = (ch+1) * 12345 if frame == 0 else 0
                    y = models[ch].step(x)
                    f.write(f"{reset} {block} {frame} {ch} {(65530+frame)&65535} {x} {y} {24+n%13}\n")
                    n += 1
    print(f"line filter stimulus: {n} beats, 16 tones, DC, full scale, channel isolation, reset/wrap")


def check():
    with (OUT / "notch_out.csv").open() as f:
        next(f)
        rows = np.loadtxt(f, delimiter=",", dtype=np.int64)
    assert rows.shape == (sum(LENGTHS)*8, 5), rows.shape
    with (OUT / "notch_stim.txt").open() as f:
        models = [MODEL() for _ in range(8)]
        for i, line in enumerate(f):
            reset, block, frame, ch, seq, x, _, _ = map(int, line.split())
            if reset:
                models = [MODEL() for _ in range(8)]
            expected = models[ch].step(x)
            assert rows[i].tolist() == [block, frame, ch, seq, expected], (i, rows[i], expected)
    # Floating-point scipy design is independent of the integer RTL model.
    b, a = signal.iirnotch(50, 10, fs=4000)
    bc, ac = signal.iircomb(50, 50, fs=4000)
    assert Comb50.R == 2*Comb50.B - 2**24
    assert np.max(np.abs(np.roots(ac))) < 1
    measurements = []
    for block, frequencies in enumerate(TONES):
        for ch, freq in enumerate(frequencies):
            part = rows[(rows[:,0] == block) & (rows[:,2] == ch) & (rows[:,1] >= 24000)]
            t = part[:,1] / 4000
            design = np.column_stack([np.sin(2*np.pi*freq*t), np.cos(2*np.pi*freq*t), np.ones(len(t))])
            fit = np.linalg.lstsq(design, part[:,4], rcond=None)[0]
            db = 20*np.log10(max(np.hypot(*fit[:2]), 1e-12)/500000)
            if freq % 50 == 0:
                assert db < -65, (freq, db)
            else:
                h = signal.freqz(b, a, worN=[freq], fs=4000)[1][0]
                hc = signal.freqz(bc, ac, worN=[freq], fs=4000)[1][0]
                if FINAL:
                    hp = signal.freqz([HP_B0,HP_B1,HP_B2], [65536,HP_A1,HP_A2], worN=[freq], fs=4000)[1][0]
                    lp = signal.freqz([LP_ALPHA], [32768,LP_ALPHA-32768], worN=[freq], fs=4000)[1][0]
                    h *= hp*lp
                expected = 20*np.log10(abs(h*hc))
                assert abs(db-expected) < .2, (freq, db, expected)
                if freq not in (49, 51) and not FINAL:
                    assert db > -.5, (freq, db)
            assert abs(fit[2]) < (1 if FINAL else 2), ("DC not rejected", freq, fit[2])
            measurements.append({"frequency_hz":freq, "rtl_gain_db":round(float(db),4),
                                 "dc_mean_counts":round(float(fit[2]),6)})
    assert np.all(rows[(rows[:,0]==2) & (rows[:,2]==1),4] == 0), "channel leakage"
    tail = rows[(rows[:,0]==3) & (rows[:,1]>=28000),4]
    assert np.max(np.abs(tail)) <= 1, ("recovery", np.max(np.abs(tail)))
    summary = dict(filter=MODEL.FILTER_ID, samples_bit_exact=len(rows), measurements=measurements,
                   recovery_max_counts=int(np.max(np.abs(tail))), hardware_measured=False)
    (OUT / "summary.json").write_text(json.dumps(summary, indent=2)+"\n")
    print(json.dumps(summary, indent=2))
    print("TEST_PASS line_filter: bit-exact, 50-450 Hz teeth, passband, DC, full-scale recovery, isolation")


if __name__ == "__main__":
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("command", choices=["gen", "check"])
    p.add_argument("--processed", action="store_true")
    args = p.parse_args()
    if args.processed:
        MODEL = ProcessedSignal
        FINAL = True
        OUT = OUT.parent / "results_processed_filter"
    (generate if args.command == "gen" else check)()

