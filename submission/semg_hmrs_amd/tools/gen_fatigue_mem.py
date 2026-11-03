#!/usr/bin/env python3
"""Generate emg_fatigue simulation assets and a bit-exact golden model.

Outputs (data/models/fatigue/):
  twiddle2048.mem          1024 x 32-bit Q15 twiddles {cos[31:16], sin[15:0]}
  tb_fatigue_samples.mem    24-bit samples, ch0..ch7 interleaved per frame
  tb_fatigue_exp_id.mem     expected result ids (one hex digit per word)
  tb_fatigue_exp_data.mem   expected result data words (8 hex digits)
  tb_fatigue_expected.json  human-readable golden values per window

The golden model mirrors tools/../src/rtl/emg_fatigue.v exactly (1st-order
HP, bit-reversed load, 11-stage radix-2 DIT with per-stage 1/2 scaling and
Q15 twiddles, 20-450 Hz power/MDF, 16-entry least-squares slope and
same-bout reference/drop state). A numpy
cross-check validates the FFT indexing against rfft on the first flat
window.
"""

import json
import os

import numpy as np

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT_DIR = os.path.join(ROOT, "data", "models", "fatigue")

# ---- RTL parameter mirror ----
N = 2048
ALPHA = 63570            # HP_ALPHA_Q16 (~20 Hz @ 4 kSPS)
INPUT_SHIFT = -4
FS = 4000.0              # sample rate used for the synthetic stimulus
STAGES = 11              # log2(N)


def sat(v, lo, hi):
    return lo if v < lo else (hi if v > hi else v)


def sat18(v):
    return sat(v, -131072, 131071)


def sat16(v):
    return sat(v, -32768, 32767)


def gen_twiddles():
    """exp(-2j*pi*w/N) as {cos Q15, sin Q15} 32-bit words, w = 0..N/2-1."""
    words, tw = [], []
    for w in range(N // 2):
        c = int(round(np.cos(2 * np.pi * w / N) * 32767))
        s = int(round(np.sin(2 * np.pi * w / N) * 32767))
        c = sat(c, -32768, 32767)
        s = sat(s, -32768, 32767)
        tw.append((c, s))
        words.append(((c & 0xFFFF) << 16) | (s & 0xFFFF))
    return words, tw


def bitrev11(v):
    return int(format(v, "011b")[::-1], 2)


def fft_fixed(buf, tw):
    """N-pt radix-2 DIT, bit-reversed input, 1/2 scaling per stage."""
    re = [0] * N
    im = [0] * N
    for i in range(N):
        re[bitrev11(i)] = buf[i]
        im[bitrev11(i)] = 0
    for s in range(STAGES):
        half = 1 << s
        for k in range(0, N, 2 * half):
            for j in range(half):
                a = k + j
                b = a + half
                c, sn = tw[j << (STAGES - 1 - s)]
                ar, ai = re[a], im[a]
                br, bi = re[b], im[b]
                t_re = sat18((br * c + bi * sn) >> 15)
                t_im = sat18((bi * c - br * sn) >> 15)
                # both outputs use the OLD re[a]/im[a] (the RTL latches
                # a and b into registers before computing either result)
                re[a] = (ar + t_re) >> 1
                im[a] = (ai + t_im) >> 1
                re[b] = (ar - t_re) >> 1
                im[b] = (ai - t_im) >> 1
    return re, im


def mdf_of(re, im):
    """Two-pass MDF, first bin where cum >= total>>1 (RTL semantics)."""
    total = 0
    for k in range(11, 231):
        total += re[k] * re[k] + im[k] * im[k]
    cum, mdf = 0, 0
    for k in range(11, 231):
        cum += re[k] * re[k] + im[k] * im[k]
        if cum >= (total >> 1):
            mdf = k
            break
    return mdf, total


class FatigueState:
    """Cycle-boundary mirror of the independently tested PL trend state."""
    def __init__(self):
        self.reset()

    def reset(self):
        self.count = self.baseline_sum = self.bout_class = self.level = 0
        self.previous = [0, 0, 0]
        self.pending = self.pending_count = 0

    def step(self, active, cls, mdf):
        if not active or cls == 0 or not 11 <= mdf <= 230:
            self.reset()
        elif not self.count or cls != self.bout_class:
            self.count, self.baseline_sum, self.bout_class = 1, mdf, cls
            self.previous = [mdf] * 3
            self.level = self.pending = self.pending_count = 0
        else:
            smooth_values = [mdf] + self.previous
            smooth_sum = sum(smooth_values) - min(smooth_values) - max(smooth_values)
            candidate = next((lv for lv, drop in ((3, 30), (2, 20), (1, 10))
                              if smooth_sum * 400 <= self.baseline_sum * (100 - drop)), 0)
            self.previous = [mdf] + self.previous[:2]
            if self.count == 16 and candidate > self.level:
                if candidate == self.pending and self.pending_count >= 2:
                    self.level, self.pending_count = candidate, 0
                elif candidate == self.pending:
                    self.pending_count += 1
                else:
                    self.pending, self.pending_count = candidate, 1
            else:
                self.pending = self.pending_count = 0
            if self.count < 8:
                self.baseline_sum += mdf
            self.count = min(16, self.count + 1)
        return self.level, self.count == 16


def main():
    os.makedirs(OUT_DIR, exist_ok=True)
    words, tw = gen_twiddles()
    with open(os.path.join(OUT_DIR, "twiddle2048.mem"), "w") as fh:
        for w in words:
            fh.write("%08x\n" % w)

    # Physical-count amplitudes, rest with a declining noise MDF, stable
    # contraction, declining MDF, sustained low-frequency plateau, release,
    # fresh contraction, FFT saturation, then a different gesture.
    rng = np.random.default_rng(7)
    n_win = 72
    n_samp = n_win * N
    t = np.arange(n_samp) / FS
    frequency = np.full(n_win, 100.0)
    frequency[:8] = np.linspace(160, 50, 8)
    frequency[24:32] = np.linspace(95, 60, 8)
    frequency[32:52] = 60
    phase = np.cumsum(np.repeat(frequency, N)) * 2 * np.pi / FS
    activity = np.ones(n_win, dtype=int)
    activity[:8] = activity[48:52] = 0
    classes = np.where(activity, 1, 0)
    classes[70:] = 2
    amplitude = np.full(n_win, 200.0)
    amplitude[:8] = amplitude[48:52] = 12
    amplitude[68:70] = 10000  # saturates the FFT input, not the 24-bit ADC
    env = np.repeat(amplitude / 200, N)
    ch_signals = []
    for ch in range(8):
        x = (200 * np.sin(phase + 0.3 * ch)
             + 60 * np.sin(2 * np.pi * 150.0 * t + 0.7 * ch)
             + 5 * rng.standard_normal(n_samp)) * env
        x = x + 20 + 10 * np.sin(2 * np.pi * t)   # DC + drift
        ch_signals.append(x)

    # ---- golden model: continuous HP then per-window FFT/MDF ----
    hp_xd = [0] * 8
    hp_yd = [0] * 8
    filt = [[] for _ in range(8)]             # hp-filtered 16-bit stream
    unclipped = [True] * n_win
    for i in range(n_samp):
        for ch in range(8):
            x = int(round(ch_signals[ch][i]))
            x = sat(x, -(1 << 23), (1 << 23) - 1)
            y = (x - hp_xd[ch]) + ((hp_yd[ch] * ALPHA) >> 16)
            hp_xd[ch] = x
            hp_yd[ch] = sat(y, -(1 << 26), (1 << 26) - 1)
            scaled = hp_yd[ch] << (-INPUT_SHIFT)
            unclipped[i // N] &= -32768 <= scaled <= 32767
            filt[ch].append(sat16(scaled))

    # numpy cross-check on an active window, channel 0
    seg = np.array(filt[0][12 * N:13 * N], dtype=np.float64)
    spec = np.abs(np.fft.rfft(seg)) ** 2
    tot = spec[11:231].sum()
    cum = np.cumsum(spec[11:231])
    mdf_np = int(np.searchsorted(cum, tot / 2.0)) + 11
    re0, im0 = fft_fixed(filt[0][12 * N:13 * N], tw)
    mdf_fx, tot_fx = mdf_of(re0, im0)
    # the fixed FFT scales amplitudes by 1/N (1/2 per stage), power by 1/N^2
    print("numpy cross-check: mdf numpy=%d fixed=%d (power %.3e vs %.3e*N^2)"
          % (mdf_np, mdf_fx, tot, float(tot_fx)))
    assert abs(mdf_np - mdf_fx) <= 2, "FFT indexing mismatch vs numpy"
    assert abs(tot - tot_fx * N * N) / max(tot, 1) < 0.05, \
        "spectral power mismatch"

    # ---- debug dumps: window 0 golden values for tb_fatigue_dbg ----
    with open(os.path.join(OUT_DIR, "dbg_win0_sbuf.mem"), "w") as fh:
        for ch in range(8):
            for v in filt[ch][0:N]:
                fh.write("%d\n" % v)
    with open(os.path.join(OUT_DIR, "dbg_win0_spec_re.mem"), "w") as fre, \
         open(os.path.join(OUT_DIR, "dbg_win0_spec_im.mem"), "w") as fim, \
         open(os.path.join(OUT_DIR, "dbg_win0_tot.mem"), "w") as ft:
        for ch in range(8):
            re, im = fft_fixed(filt[ch][0:N], tw)
            mdf_ch, tot_ch = mdf_of(re, im)
            for k in range(N // 2 + 1):
                fre.write("%d\n" % re[k])
                fim.write("%d\n" % im[k])
            ft.write("%d\n" % tot_ch)

    # ---- per-window pipeline ----
    exp_words = []                            # (id, data, info)
    hist = []                                 # chronological MDF means
    tracker = FatigueState()
    hist_class = 0
    fatigue_levels, ready_values = [], []
    for w in range(n_win):
        mdf_sum = 0
        grand_total = 0
        spec_sum = [0] * 30
        peak_power, peak_bin = 0, 0
        for ch in range(8):
            re, im = fft_fixed(filt[ch][w * N:(w + 1) * N], tw)
            mdf_ch, tot_ch = mdf_of(re, im)
            mdf_sum += mdf_ch
            grand_total += tot_ch
            for k in range(11, 231):
                p = re[k] * re[k] + im[k] * im[k]
                if 11 <= k <= 230:
                    spec_sum[((k - 11) * 30) // 220] += p
                if p > peak_power:
                    peak_power, peak_bin = p, k
        mdf_mean = mdf_sum >> 3
        # Window 71 changes gesture halfway through in the RTL testbench.
        active = bool(activity[w] and unclipped[w] and grand_total > 0 and w != 71)
        if not active or classes[w] != hist_class:
            hist = []
        if active:
            hist.append(mdf_mean)
            hist = hist[-16:]
        hist_class = classes[w] if active else 0
        if len(hist) == 16:
            num2 = sat16(sum((2 * i - 15) * hist[i] for i in range(16)))
        else:
            num2 = 0
        level, full = tracker.step(active, int(classes[w]), mdf_mean)
        fatigue_levels.append(level)
        ready_values.append(full)
        d8 = ((num2 & 0xFFFF) << 16) | (mdf_mean & 0xFFFF)
        energy = (grand_total >> 23) & 0x7FFFFF
        d9 = ((level & 3) << 30) | ((1 if full else 0) << 29) | energy
        exp_words.append((8, d8, {"win": w, "mdf": mdf_mean, "num2": num2}))
        exp_words.append((9, d9, {"win": w, "level": level, "full": full,
                                  "energy": energy}))
        def power_level(value):
            if value == 0:
                return 0
            msb = value.bit_length() - 1
            return 1 if msb == 0 else min(31, msb)

        for packet in range(5):
            payload = 0
            levels = []
            for j in range(6):
                idx = packet * 6 + j
                level = power_level(spec_sum[idx])
                levels.append(level)
                payload |= level << (5 * j)
            exp_words.append((10 + packet, payload,
                              {"win": w, "bands": packet, "levels": levels}))
        d15 = ((peak_bin & 0x7FF) << 21) | (peak_power & 0x1FFFFF)
        exp_words.append((15, d15, {"win": w, "peak_bin": peak_bin}))
        print("win %2d: mdf=%3d num2=%6d level=%d" % (w, mdf_mean, num2,
                                                      fatigue_levels[-1]))

    with open(os.path.join(OUT_DIR, "tb_fatigue_exp_id.mem"), "w") as fh:
        for id_, _, _ in exp_words:
            fh.write("%x\n" % id_)
    with open(os.path.join(OUT_DIR, "tb_fatigue_activity.mem"), "w") as fh:
        for a, c in zip(activity, classes):
            fh.write("%x\n" % ((int(a) << 3) | int(c)))
    with open(os.path.join(OUT_DIR, "tb_fatigue_exp_data.mem"), "w") as fh:
        for _, d, _ in exp_words:
            fh.write("%08x\n" % d)
    with open(os.path.join(OUT_DIR, "tb_fatigue_expected.json"), "w") as fh:
        json.dump([{"id": i, "data": d, **info} for i, d, info in exp_words],
                  fh, indent=1)

    # ---- sample stream mem: ch0..ch7 interleaved per frame ----
    with open(os.path.join(OUT_DIR, "tb_fatigue_samples.mem"), "w") as fh:
        for i in range(n_samp):
            for ch in range(8):
                x = int(round(ch_signals[ch][i]))
                x = sat(x, -(1 << 23), (1 << 23) - 1)
                fh.write("%06x\n" % (x & 0xFFFFFF))

    # Behavioral requirements independent of the bit-exact word comparison.
    assert not any(fatigue_levels[:24]), "rest/stable force must not trigger fatigue"
    assert fatigue_levels[47] == 3, "large sustained MDF decrease must be detected"
    assert all(b >= a for a, b in zip(fatigue_levels[32:47], fatigue_levels[33:48])), "plateau must not downgrade"
    assert not any(fatigue_levels[48:]), "rest/new bout/clipped windows must reset fatigue"
    assert not any(ready_values[48:52] + ready_values[68:]), "invalid windows must clear readiness"
    print("TEST_PASS fatigue behavioral scenarios: rest, contraction, decline, plateau, recovery, clipping, gesture change")

    print("wrote twiddle2048.mem, tb_fatigue_samples.mem (%d frames), "
          "%d expected words -> %s"
          % (n_samp, len(exp_words), OUT_DIR))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

