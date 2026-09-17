#!/usr/bin/env python3
"""Fixed-point reference for the PL EMG signal chain and sim comparison.

Bit-exact mirror of src/rtl/emg_bandpass.v, src/rtl/emg_window_features.v
and src/rtl/emg_feature_bank.v using pure integer math. Any RTL change to
the filter, window or feature arithmetic must be mirrored here.

Subcommands:
  gen                write all stimulus files into sim/results
  compare-bandpass   compare RTL bandpass_out.csv against the model
  compare-features   compare RTL features_out.csv against the model
  compare-bank       compare RTL bank_out.csv against the model
  compare-export     compare RTL export_out.csv (raw + feature) against the model
"""

import argparse
import math
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SIM_DIR = os.path.join(ROOT, "sim", "results")

# ---------------------------------------------------------------------------
# Fixed-point chain (must match src/rtl/emg_bandpass.v parameters exactly)
# ---------------------------------------------------------------------------

SAMPLE_WIDTH = 24
HP_B0, HP_B1, HP_B2 = 59967, -119934, 59967
HP_A1, HP_A2 = -119462, 54864
LP_ALPHA = 24206


def sat24(v):
    if v > (1 << 23) - 1:
        return (1 << 23) - 1
    if v < -(1 << 23):
        return -(1 << 23)
    return v


def clamp32(v):
    if v > (1 << 31) - 1:
        return (1 << 31) - 1
    if v < -(1 << 31):
        return -(1 << 31)
    return v


class Bandpass:
    """HP biquad (DF-I, quantized feedback) + first-order LP."""

    def __init__(self):
        self.x1 = self.x2 = 0
        self.y1 = self.y2 = 0
        self.lp_y = 0

    def step(self, x):
        acc = (HP_B0 * x + HP_B1 * self.x1 + HP_B2 * self.x2
               - HP_A1 * self.y1 - HP_A2 * self.y2)
        hp_y = sat24(acc >> 16)
        diff = hp_y - self.lp_y
        self.lp_y = sat24(self.lp_y + ((LP_ALPHA * diff) >> 15))
        self.x2, self.x1 = self.x1, x
        self.y2, self.y1 = self.y1, hp_y
        return self.lp_y


def window_features(samples, window, hop, shift, zc_th, ssc_th):
    """Direct sliding-window computation.

    Mathematically identical to the RTL segment-sum implementation: every
    feature contribution is an integer owned by the sample that produced
    it, so segment sums and direct sums agree exactly.
    """
    n = len(samples)
    mav = [abs(x) for x in samples]
    energy = [(x >> shift) ** 2 for x in samples]
    wl = [0] * n
    zc = [0] * n
    ssc = [0] * n
    for i in range(1, n):
        d = samples[i] - samples[i - 1]
        wl[i] = abs(d)
        if (samples[i] < 0) != (samples[i - 1] < 0) and abs(d) > zc_th:
            zc[i] = 1
    for i in range(2, n):
        s2 = samples[i] - samples[i - 1]
        s1 = samples[i - 1] - samples[i - 2]
        if (s1 < 0) != (s2 < 0) and abs(s1) > ssc_th and abs(s2) > ssc_th:
            ssc[i] = 1
    out = []
    for start in range(0, n - window + 1, hop):
        sl = slice(start, start + window)
        out.append((clamp32(sum(mav[sl])),
                    clamp32(sum(wl[sl])),
                    clamp32(sum(energy[sl])),
                    sum(zc[sl]),
                    sum(ssc[sl])))
    return out


class BankModel:
    """Eight-channel bandpass + window feature reference."""

    def __init__(self, channels=8, window=200, hop=50, shift=12,
                 zc_th=0, ssc_th=0):
        self.channels = channels
        self.window = window
        self.hop = hop
        self.shift = shift
        self.zc_th = zc_th
        self.ssc_th = ssc_th
        self.bp = [Bandpass() for _ in range(channels)]
        self.filtered = [[] for _ in range(channels)]

    def feed_frame(self, frame):
        for ch, x in enumerate(frame):
            self.filtered[ch].append(self.bp[ch].step(x))

    def windows(self):
        return [window_features(self.filtered[ch], self.window, self.hop,
                                self.shift, self.zc_th, self.ssc_th)
                for ch in range(self.channels)]


# ---------------------------------------------------------------------------
# Deterministic stimulus generation (no numpy, no random module state)
# ---------------------------------------------------------------------------

def lcg(state):
    return (1103515245 * state + 12345) & 0x7FFFFFFF


def gen_bandpass_stim(path, n_extra=500):
    rows = []
    rows.extend([50000] * 300)                     # DC block
    for t in range(600):                           # 10 Hz (stopband)
        rows.append(round(30000 * math.sin(2 * math.pi * 10 * t / 1000)))
    for t in range(600):                           # 80 Hz + DC offset
        rows.append(round(20000 * math.sin(2 * math.pi * 80 * t / 1000)) - 20000)
    for t in range(600):                           # 150 Hz (passband)
        rows.append(round(15000 * math.sin(2 * math.pi * 150 * t / 1000)))
    for t in range(400):                           # 400 Hz (LP rolloff)
        rows.append(round(10000 * math.sin(2 * math.pi * 400 * t / 1000)))
    state = 12345
    for _ in range(n_extra):                       # noise
        state = lcg(state)
        rows.append((state >> 8) % 8001 - 4000)
    with open(path, "w") as f:
        f.write("\n".join(str(v) for v in rows) + "\n")
    return len(rows)


def gen_features_stim(path, n=200):
    state = 999
    rows = []
    for t in range(n):
        state = lcg(state)
        noise = (state >> 8) % 4001 - 2000
        v = (round(9000 * math.sin(2 * math.pi * 70 * t / 1000))
             + round(5000 * math.sin(2 * math.pi * 13 * t / 1000))
             + 12000 + noise)
        rows.append(v)
    with open(path, "w") as f:
        f.write("\n".join(str(v) for v in rows) + "\n")
    return len(rows)


def gen_emg_frames(n_frames):
    """Synthetic 8-channel EMG: bursts, per-channel carriers, DC, noise."""
    frames = []
    state = 4242
    for t in range(n_frames):
        frame = []
        for ch in range(8):
            env = max(0.0, math.sin(2 * math.pi * 0.8 * t / 1000 + 0.7 * ch)) ** 2
            carrier = math.sin(2 * math.pi * (40 + 15 * ch) * t / 1000 + 0.3 * ch)
            carrier2 = 0.4 * math.sin(2 * math.pi * (90 + 20 * ch) * t / 1000)
            state = lcg(state)
            noise = (state >> 8) % 4001 - 2000
            amp = 12000 + 5000 * ch
            dc = 15000 * (ch - 3.5)
            frame.append(int(env * amp * (carrier + carrier2) + dc + noise))
        frames.append(frame)
    return frames


def gen_bank_stim(path, n_frames=310):
    frames = gen_emg_frames(n_frames)
    with open(path, "w") as f:
        for frame in frames:
            f.write(" ".join(str(v) for v in frame) + "\n")
    return len(frames)


def gen_export_stim(path, n_frames=260):
    frames = gen_emg_frames(n_frames)
    with open(path, "w") as f:
        for frame in frames:
            f.write(" ".join(str(v) for v in frame) + "\n")
    return len(frames)


# ---------------------------------------------------------------------------
# Comparators
# ---------------------------------------------------------------------------

def read_int_lines(path):
    with open(path) as f:
        return [int(line) for line in f if line.strip()]


def read_csv_rows(path, n_cols):
    rows = []
    with open(path) as f:
        header = f.readline()
        for line in f:
            parts = line.strip().split(",")
            if not parts or parts == [""]:
                continue
            if len(parts) != n_cols:
                raise ValueError(f"{path}: bad row {parts!r}")
            rows.append([int(p) for p in parts])
    return rows


def fail(name, msg):
    print(f"{name} FAILED: {msg}")
    sys.exit(1)


def compare_bandpass():
    stim = read_int_lines(os.path.join(SIM_DIR, "bandpass_stim.txt"))
    rows = read_csv_rows(os.path.join(SIM_DIR, "bandpass_out.csv"), 2)
    if len(rows) != len(stim):
        fail("compare-bandpass", f"row count {len(rows)} != stim {len(stim)}")
    bp = Bandpass()
    for i, (row, x) in enumerate(zip(rows, stim)):
        expect = bp.step(x)
        if row[0] != x or row[1] != expect:
            fail("compare-bandpass",
                 f"sample {i}: in={row[0]} (want {x}) out={row[1]} (want {expect})")
    print(f"compare-bandpass PASSED: {len(rows)} samples bit-exact")


def compare_features():
    stim = read_int_lines(os.path.join(SIM_DIR, "features_stim.txt"))
    rows = read_csv_rows(os.path.join(SIM_DIR, "features_out.csv"), 6)
    bp = Bandpass()
    filtered = [bp.step(x) for x in stim]
    expect = window_features(filtered, window=8, hop=4, shift=0,
                             zc_th=0, ssc_th=0)
    if len(rows) != len(expect):
        fail("compare-features",
             f"window count {len(rows)} != expected {len(expect)}")
    for k, (row, exp) in enumerate(zip(rows, expect)):
        if tuple(row[1:]) != exp:
            fail("compare-features",
                 f"window {k}: rtl={tuple(row[1:])} expected={exp}")
    print(f"compare-features PASSED: {len(rows)} windows bit-exact")


def check_feature_stream(name, rows, bank_windows):
    """rows: [channel, id, sequence, payload]; bank_windows[ch][k][id]."""
    per_ch = {ch: {fid: [] for fid in range(5)} for ch in range(8)}
    last_seq = None
    for row in rows:
        ch, fid, seq, payload = row
        if ch > 7 or fid > 4:
            fail(name, f"bad channel/id: {row}")
        if last_seq is not None and seq != (last_seq + 1) & 0xFFFF:
            fail(name, f"sequence gap: {seq} after {last_seq}")
        last_seq = seq
        per_ch[ch][fid].append(payload)
    total = 0
    for ch in range(8):
        wins = bank_windows[ch]
        for fid in range(5):
            got = per_ch[ch][fid]
            if len(got) != len(wins):
                fail(name, f"ch{ch} id{fid}: {len(got)} words, expected {len(wins)}")
            for k, (g, w) in enumerate(zip(got, wins)):
                if g != w[fid]:
                    fail(name, f"ch{ch} id{fid} window {k}: rtl={g} expected={w[fid]}")
            total += len(got)
    return total


def compare_bank():
    stim_path = os.path.join(SIM_DIR, "bank_stim.txt")
    frames = [[int(v) for v in line.split()]
              for line in open(stim_path) if line.strip()]
    rows = read_csv_rows(os.path.join(SIM_DIR, "bank_out.csv"), 5)
    bank = BankModel()
    for frame in frames:
        bank.feed_frame(frame)
    wins = bank.windows()
    feat = [r[1:] for r in rows]
    total = check_feature_stream("compare-bank", feat, wins)
    print(f"compare-bank PASSED: {total} feature words bit-exact "
          f"({len(wins[0])} windows x 8 channels x 5 features)")


def compare_export():
    stim_path = os.path.join(SIM_DIR, "export_stim.txt")
    frames = [[int(v) for v in line.split()]
              for line in open(stim_path) if line.strip()]
    rows = read_csv_rows(os.path.join(SIM_DIR, "export_out.csv"), 5)
    bank = BankModel()
    for frame in frames:
        bank.feed_frame(frame)
    wins = bank.windows()

    raw_rows = [r for r in rows if r[0] == 1]
    feat_rows = [r for r in rows if r[0] == 2]
    other = [r for r in rows if r[0] not in (1, 2, 3)]
    if other:
        fail("compare-export", f"unexpected packet types: {other[:3]}")
    # type-3 result words are verified by tools/check_pl_nn_sim.py

    if len(raw_rows) != len(frames) * 8:
        fail("compare-export",
             f"raw words {len(raw_rows)} != {len(frames) * 8}")
    for i, r in enumerate(raw_rows):
        ptype, ch, fid, seq, payload = r
        frame_i = i // 8
        ch_i = i % 8
        if ch != ch_i or fid != 0 or seq != frame_i:
            fail("compare-export", f"raw word {i}: {r}")
        val = payload & 0xFFFFFF
        if val >= 1 << 23:
            val -= 1 << 24
        if val != frames[frame_i][ch_i]:
            fail("compare-export",
                 f"raw word {i}: payload {val} != stimulus {frames[frame_i][ch_i]}")

    feat = [[r[1], r[2], r[3], r[4]] for r in feat_rows]
    total = check_feature_stream("compare-export", feat, wins)
    print(f"compare-export PASSED: {len(raw_rows)} raw words + "
          f"{total} feature words bit-exact")


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("command",
                    choices=["gen", "compare-bandpass", "compare-features",
                             "compare-bank", "compare-export"])
    args = ap.parse_args()
    os.makedirs(SIM_DIR, exist_ok=True)

    if args.command == "gen":
        n1 = gen_bandpass_stim(os.path.join(SIM_DIR, "bandpass_stim.txt"))
        n2 = gen_features_stim(os.path.join(SIM_DIR, "features_stim.txt"))
        n3 = gen_bank_stim(os.path.join(SIM_DIR, "bank_stim.txt"))
        n4 = gen_export_stim(os.path.join(SIM_DIR, "export_stim.txt"))
        print(f"stimulus written: bandpass={n1} features={n2} "
              f"bank={n3}x8 export={n4}x8")
    elif args.command == "compare-bandpass":
        compare_bandpass()
    elif args.command == "compare-features":
        compare_features()
    elif args.command == "compare-bank":
        compare_bank()
    elif args.command == "compare-export":
        compare_export()


if __name__ == "__main__":
    main()
