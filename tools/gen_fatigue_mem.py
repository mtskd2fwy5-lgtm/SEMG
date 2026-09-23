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
Q15 twiddles, 1025-bin power/MDF, 16-entry least-squares slope).  A numpy
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
INPUT_SHIFT = 8
T_MILD, T_FATIGUE, T_REST = -100, -300, -600
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
    for k in range(N // 2 + 1):
        total += re[k] * re[k] + im[k] * im[k]
    cum, mdf = 0, 0
    for k in range(N // 2 + 1):
        cum += re[k] * re[k] + im[k] * im[k]
        if cum >= (total >> 1):
            mdf = k
            break
    return mdf, total


def main():
    os.makedirs(OUT_DIR, exist_ok=True)
    words, tw = gen_twiddles()
    with open(os.path.join(OUT_DIR, "twiddle2048.mem"), "w") as fh:
        for w in words:
            fh.write("%08x\n" % w)

    # ---- synthetic stimulus: 28 windows, MDF flat then declining ----
    rng = np.random.default_rng(7)
    n_win = 28
    n_samp = n_win * N
    t = np.arange(n_samp) / FS
    f1 = np.where(np.arange(n_win) < 10, 80.0,
                  80.0 - 20.0 * (np.arange(n_win) - 9) / 18.0)
    f1 = np.repeat(f1, N)                     # per-sample carrier freq
    env = np.where((t * 1000).astype(int) % 512 < 300, 1.0, 0.05)
    ch_signals = []
    for ch in range(8):
        x = (2.0e6 * np.sin(2 * np.pi * f1 * t + 0.3 * ch)
             + 0.6e6 * np.sin(2 * np.pi * 150.0 * t + 0.7 * ch)
             + 0.05e6 * rng.standard_normal(n_samp)) * env
        x = x + 2.0e5 + 1.0e5 * np.sin(2 * np.pi * 1.0 * t)   # DC + drift
        ch_signals.append(x)

    # ---- golden model: continuous HP then per-window FFT/MDF ----
    hp_xd = [0] * 8
    hp_yd = [0] * 8
    filt = [[] for _ in range(8)]             # hp-filtered 16-bit stream
    for i in range(n_samp):
        for ch in range(8):
            x = int(round(ch_signals[ch][i]))
            x = sat(x, -(1 << 23), (1 << 23) - 1)
            y = (x - hp_xd[ch]) + ((hp_yd[ch] * ALPHA) >> 16)
            hp_xd[ch] = x
            hp_yd[ch] = sat(y, -(1 << 26), (1 << 26) - 1)
            filt[ch].append(sat16(hp_yd[ch] >> INPUT_SHIFT))

    # numpy cross-check on window 5 (flat region), channel 0
    seg = np.array(filt[0][5 * N:6 * N], dtype=np.float64)
    spec = np.abs(np.fft.rfft(seg)) ** 2
    tot = spec.sum()
    cum = np.cumsum(spec)
    mdf_np = int(np.searchsorted(cum, tot / 2.0))
    re0, im0 = fft_fixed(filt[0][5 * N:6 * N], tw)
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
    for w in range(n_win):
        mdf_sum = 0
        grand_total = 0
        for ch in range(8):
            re, im = fft_fixed(filt[ch][w * N:(w + 1) * N], tw)
            mdf_ch, tot_ch = mdf_of(re, im)
            mdf_sum += mdf_ch
            grand_total += tot_ch
        mdf_mean = mdf_sum >> 3
        hist.append(mdf_mean)
        if len(hist) > 16:
            hist = hist[-16:]
        if len(hist) == 16:
            num2 = sat16(sum((2 * i - 15) * hist[i] for i in range(16)))
            level = (3 if num2 <= T_REST else
                     2 if num2 <= T_FATIGUE else
                     1 if num2 <= T_MILD else 0)
        else:
            num2, level = 0, 0
        full = len(hist) == 16
        d8 = ((num2 & 0xFFFF) << 16) | (mdf_mean & 0xFFFF)
        energy = (grand_total >> 23) & 0x7FFFFF
        d9 = ((level & 3) << 30) | ((1 if full else 0) << 29) | energy
        exp_words.append((8, d8, {"win": w, "mdf": mdf_mean, "num2": num2}))
        exp_words.append((9, d9, {"win": w, "level": level, "full": full,
                                  "energy": energy}))
        print("win %2d: mdf=%3d num2=%6d level=%d" % (w, mdf_mean, num2,
                                                      level))

    with open(os.path.join(OUT_DIR, "tb_fatigue_exp_id.mem"), "w") as fh:
        for id_, _, _ in exp_words:
            fh.write("%x\n" % id_)
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

    print("wrote twiddle2048.mem, tb_fatigue_samples.mem (%d frames), "
          "%d expected words -> %s"
          % (n_samp, len(exp_words), OUT_DIR))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
