#!/usr/bin/env python3
"""Redesign the EMG bandpass coefficients for the native 4 kSPS ADC rate.

The old coefficients (HP_B0..A2 Q16, LP_ALPHA Q15) were designed for a
1 kSPS-equivalent stream (the 4:1-decimated design).  With the feature
chain now running at the native 4 kSPS they are regenerated for the
same physical response, same recipe as the original design:

  HP: RBJ cookbook 2nd-order Butterworth HP, fc = 20 Hz, Q = 1/sqrt(2)
  LP: 1st-order low-pass,             fc = 215 Hz (pole match of the
      old alpha = 24206 @ 1 kSPS, fc = 0.2145 * fs)

Both stay Q16/Q15 and keep the >>> 16 / >>> 15 shifts of
emg_bandpass.v unchanged.  b1/a1 land near -128200/-128160, inside the
signed 18-bit container with ~2% headroom.

Prints the RTL parameter block, the emg_reference.py constants and a
magnitude table of float vs quantised responses at the golden stimulus
frequencies.
"""

import math

FS = 4000
Q16 = 1 << 16
Q15 = 1 << 15

OLD = dict(fs=1000,
           hp=(59967, -119934, 59967, -119462, 54864),   # Q16
           lp_alpha=24206)                                # Q15


def rbj_hp2(fc, fs):
    """RBJ cookbook 2nd-order Butterworth HP (Q = 1/sqrt(2)), unit gain,
    (b0,b1,b2,a1,a2) with denominator 1 + a1 z^-1 + a2 z^-2."""
    w0 = 2 * math.pi * fc / fs
    cw = math.cos(w0)
    alpha = math.sin(w0) / math.sqrt(2)
    a0 = 1 + alpha
    b0 = (1 + cw) / 2 / a0
    b1 = -(1 + cw) / a0        # = -2*b0: quantised B1 = -(B0+B2) keeps DC gain exactly 0
    b2 = (1 + cw) / 2 / a0
    a1 = -2 * cw / a0
    a2 = (1 - alpha) / a0
    return b0, b1, b2, a1, a2


def lp1_pole(fc, fs):
    """1st-order LP y += alpha*(x-y): returns alpha."""
    p = math.exp(-2 * math.pi * fc / fs)
    return 1 - p


def hp1_alpha_for(fc, fs):
    """1st-order HP H=(1-z^-1)/(1-a z^-1): solve |H| = -3 dB at fc.
    cos(w) = (3a^2-1)/(4a^2-2a) -> quadratic in a."""
    c = math.cos(2 * math.pi * fc / fs)
    # (3-4c) a^2 + 2c a - 1 = 0
    a_q = 3 - 4 * c
    disc = 4 * c * c + 4 * a_q
    if abs(a_q) < 1e-12:
        return 1 / (2 * c)
    r = math.sqrt(disc)
    roots = [(-2 * c + r) / (2 * a_q), (-2 * c - r) / (2 * a_q)]
    return min((x for x in roots if 0 < x < 1), key=abs)


def hp2_mag(b, a1, a2, f, fs):
    w = 2 * math.pi * f / fs
    z = complex(math.cos(w), -math.sin(w))
    num = b[0] + b[1] * z + b[2] * z * z
    den = 1 + a1 * z + a2 * z * z
    return abs(num / den)


def lp1_mag(alpha, f, fs):
    w = 2 * math.pi * f / fs
    z = complex(math.cos(w), -math.sin(w))
    return abs(alpha / (1 - (1 - alpha) * z))


def hp1_mag(alpha, f, fs):
    w = 2 * math.pi * f / fs
    z = complex(math.cos(w), -math.sin(w))
    return abs((1 - z) / (1 - alpha * z))


def db(x):
    return 20 * math.log10(max(x, 1e-12))


def fmt(v):
    return f"{v:.4f}"


def main():
    # ---- HP 2nd order, fc=20 Hz @ 4 kSPS, Q16 (same recipe as 1k) ---
    b0, b1, b2, a1, a2 = rbj_hp2(20, FS)
    hp_q = [round(b0 * Q16), round(b1 * Q16), round(b2 * Q16),
            round(a1 * Q16), round(a2 * Q16)]
    # ---- LP 1st order, fc=215 Hz @ 4 kSPS, Q15 ----------------------
    lp_alpha = lp1_pole(215, FS)
    lp_q = round(lp_alpha * Q15)
    # ---- fatigue HP 1st order, fc=20 Hz @ 4 kSPS, Q16 ---------------
    f_alpha = hp1_alpha_for(20, FS)
    f_q = round(f_alpha * Q16)

    print("=== quantised coefficients (RTL / golden model) ===")
    print(f"HP_B0    = 18'sd{hp_q[0]}   // Q16 {b0:.6f}")
    print(f"HP_B1    = 18'sd{hp_q[1]}  // Q16 {b1:.6f}")
    print(f"HP_B2    = 18'sd{hp_q[2]}   // Q16 {b2:.6f}")
    print(f"HP_A1    = 18'sd{hp_q[3]}  // Q16 {a1:.6f}")
    print(f"HP_A2    = 18'sd{hp_q[4]}   // Q16 {a2:.6f}")
    print(f"LP_ALPHA = 16'sd{lp_q}    // Q15 {lp_alpha:.6f} (fc 215 Hz @ 4 kSPS)")
    print(f"FAT_HP_ALPHA_Q16 = 17'sd{f_q}   // Q16 {f_alpha:.6f} (fc 20 Hz @ 4 kSPS)")

    lim = (1 << 17) - 1
    worst = max(abs(v) for v in hp_q)
    assert worst <= lim, f"coefficient {worst} exceeds 18-bit range {lim}"
    print(f"\n18-bit range check: max |coef| = {worst} <= {lim}  OK")

    # ---- magnitude table: old@1k vs new@4k (float and quantised) ----
    ob = OLD['hp'][0] / (1 << 16)
    ob1, ob2 = OLD['hp'][1] / (1 << 16), OLD['hp'][2] / (1 << 16)
    oa1, oa2 = OLD['hp'][3] / (1 << 16), OLD['hp'][4] / (1 << 16)
    olp = OLD['lp_alpha'] / (1 << 15)

    fq = [10, 20, 50, 80, 150, 200, 300, 400, 500, 800]
    print(f"\n=== cascade |H| (HP*LP), dB ===")
    print(f"{'f [Hz]':>7} {'old@1k':>8} {'new@4k':>8} {'newQ':>8}")
    for f in fq:
        old_db = db(hp2_mag((ob, ob1, ob2), oa1, oa2, f, 1000) *
                    lp1_mag(olp, f, 1000))
        new_db = db(hp2_mag((b0, b1, b2), a1, a2, f, FS) *
                    lp1_mag(lp_alpha, f, FS))
        q0, q1, q2 = hp_q[0] / Q16, hp_q[1] / Q16, hp_q[2] / Q16
        qa1, qa2 = hp_q[3] / Q16, hp_q[4] / Q16
        q_db = db(hp2_mag((q0, q1, q2), qa1, qa2, f, FS) *
                  lp1_mag(lp_q / Q15, f, FS))
        print(f"{f:>7} {old_db:>8.2f} {new_db:>8.2f} {q_db:>8.2f}")

    # ---- quantisation error detail -----------------------------------
    print("\n=== quantisation check (new @ 4 kSPS) ===")
    for f in fq:
        fl = db(hp2_mag((b0, b1, b2), a1, a2, f, FS))
        q0, q1, q2 = hp_q[0] / Q16, hp_q[1] / Q16, hp_q[2] / Q16
        qa1, qa2 = hp_q[3] / Q16, hp_q[4] / Q16
        qt = db(hp2_mag((q0, q1, q2), qa1, qa2, f, FS))
        print(f"  {f:>4} Hz: float {fl:7.3f} dB, fixed {qt:7.3f} dB, "
              f"err {qt - fl:+.4f} dB")

    print(f"\nfatigue HP check: |H(20Hz)| = "
          f"{db(hp1_mag(f_q / Q16, 20, FS)):.2f} dB (target -3.01), "
          f"|H(5Hz)| = {db(hp1_mag(f_q / Q16, 5, FS)):.2f} dB")

    print("\n=== emg_reference.py constants ===")
    print(f"HP_B0, HP_B1, HP_B2 = {hp_q[0]}, {hp_q[1]}, {hp_q[2]}")
    print(f"HP_A1, HP_A2 = {hp_q[3]}, {hp_q[4]}")
    print(f"LP_ALPHA = {lp_q}")
    print(f"SCALE_Q = 16   # HP coefficients are Q16 at 4 kSPS")


if __name__ == "__main__":
    main()

