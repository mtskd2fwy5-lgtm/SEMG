#!/usr/bin/env python3
"""Diff tb_fatigue_dbg RTL dumps (dbg_rtl_*) against the golden model.

Checks, in order:
  1. load snapshot: fft_re after bit-reversed load == sbuf[bitrev(k)]
  2. butterfly operand trace (ch0): (s,k,j,a_re,a_im,b_re,b_im,tw) per line
     replayed against a stage-by-stage golden FFT, first mismatch printed
  3. final spectrum / totals (existing dbg_win0 comparisons)
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from gen_fatigue_mem import (N, STAGES, ALPHA, INPUT_SHIFT, sat, sat16,
                             sat18, bitrev11, gen_twiddles, fft_fixed,
                             mdf_of)

D = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
                 "data", "models", "fatigue")


def rd(name):
    return [l.strip() for l in open(os.path.join(D, name)) if l.strip()]


def ints(name):
    return [int(x) for x in rd(name)]


def main():
    # rebuild golden filtered stream (same stimulus as gen_fatigue_mem)
    import numpy as np
    rng = np.random.default_rng(7)
    n_win = 28
    n_samp = n_win * N
    t = np.arange(n_samp) / 4000.0
    f1 = np.where(np.arange(n_win) < 10, 80.0,
                  80.0 - 20.0 * (np.arange(n_win) - 9) / 18.0)
    f1 = np.repeat(f1, N)
    env = np.where((t * 1000).astype(int) % 512 < 300, 1.0, 0.05)
    ch_sig = []
    for ch in range(8):
        x = (2.0e6 * np.sin(2 * np.pi * f1 * t + 0.3 * ch)
             + 0.6e6 * np.sin(2 * np.pi * 150.0 * t + 0.7 * ch)
             + 0.05e6 * rng.standard_normal(n_samp)) * env
        x = x + 2.0e5 + 1.0e5 * np.sin(2 * np.pi * 1.0 * t)
        ch_sig.append(x)

    hp_xd, hp_yd = [0] * 8, [0] * 8
    filt = [[] for _ in range(8)]
    for i in range(n_samp):
        for ch in range(8):
            x = sat(int(round(ch_sig[ch][i])), -(1 << 23), (1 << 23) - 1)
            y = (x - hp_xd[ch]) + ((hp_yd[ch] * ALPHA) >> 16)
            hp_xd[ch] = x
            hp_yd[ch] = sat(y, -(1 << 26), (1 << 26) - 1)
            filt[ch].append(sat16(hp_yd[ch] >> INPUT_SHIFT))

    _, tw = gen_twiddles()

    # ---- 1. load snapshot ----
    load = [tuple(map(int, l.split())) for l in rd("dbg_rtl_load_re.mem")]
    bad = 0
    for ch_i in range(0, len(load), N):
        ch = load[ch_i][0]
        vals = [v for _, v in load[ch_i:ch_i + N]]
        gold = [filt[ch][bitrev11(k)] for k in range(N)]
        for k, (r, g) in enumerate(zip(vals, gold)):
            if r != g:
                print("LOAD ch%d k=%d: rtl=%d gold=%d" % (ch, k, r, g))
                bad += 1
                if bad > 8:
                    return 1
    print("load snapshot: %s" % ("MISMATCH" if bad else "OK (8x2048)"))

    # ---- 2. butterfly operand trace, channel 0 ----
    ops = [tuple(map(int, l.split())) for l in rd("dbg_rtl_ops.mem")]
    # golden stage-by-stage replay of ch0
    buf = filt[0]
    re = [0] * N
    im = [0] * N
    for i in range(N):
        re[bitrev11(i)] = buf[i]
        im[bitrev11(i)] = 0
    mism = 0
    oi = 0
    for s in range(STAGES):
        half = 1 << s
        for k in range(0, N, 2 * half):
            for j in range(half):
                a, b = k + j, k + j + half
                c, sn = tw[j << (STAGES - 1 - s)]
                ar, ai, br, bi = re[a], im[a], re[b], im[b]
                # RTL latches these exact registers before computing
                if oi < len(ops):
                    r = ops[oi]
                    if (r[0], r[1], r[2]) != (s, k, j):
                        print("OPS order mismatch line %d: rtl s=%d k=%d j=%d"
                              " exp s=%d k=%d j=%d" % (oi, r[0], r[1], r[2],
                                                       s, k, j))
                        return 1
                    exp = (ar, ai, br, bi, (c & 0xFFFF) << 16 | (sn & 0xFFFF))
                    got = (r[3], r[4], r[5], r[6], r[7])
                    # RTL writes tw_q as 32-bit unsigned decimal
                    if got[:4] != exp[:4] or got[4] != exp[4]:
                        print("BFLY s=%d k=%d j=%d line %d:" % (s, k, j, oi))
                        print("  rtl a=(%d,%d) b=(%d,%d) tw=%d"
                              % got)
                        print("  exp a=(%d,%d) b=(%d,%d) tw=%d"
                              % exp)
                        mism += 1
                        if mism > 8:
                            return 1
                else:
                    print("OPS short: rtl has %d lines, golden %d"
                          % (len(ops), STAGES * N // 2))
                    return 1
                t_re = sat18((br * c + bi * sn) >> 15)
                t_im = sat18((bi * c - br * sn) >> 15)
                re[a] = (ar + t_re) >> 1
                im[a] = (ai + t_im) >> 1
                re[b] = (ar - t_re) >> 1
                im[b] = (ai - t_im) >> 1
                oi += 1
    print("butterfly trace ch0: %d lines, %s"
          % (len(ops), "MISMATCH %d" % mism if mism else "OK"))

    # ---- 3. totals ----
    rtl_tot = ints("dbg_rtl_tot.mem")
    for ch in range(8):
        _, g_tot = mdf_of(*fft_fixed(filt[ch][0:N], tw))
        if rtl_tot[ch] != g_tot:
            print("TOT ch%d: rtl=%d gold=%d ratio=%.3f"
                  % (ch, rtl_tot[ch], g_tot, rtl_tot[ch] / max(g_tot, 1)))
    print("totals checked")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
