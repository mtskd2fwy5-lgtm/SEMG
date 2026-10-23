"""Reproduce the diagnosis of S30_E2_A1_waveform.csv; never edit raw data.

Plots and statistics are diagnostic derivatives, not recovered measurements.
"""
import hashlib
import json
import sys
from pathlib import Path

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np
from scipy import signal

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools"))
from plot_csv import load_csv, contiguous_slices

OUT = Path(__file__).resolve().parent
SOURCE = ROOT / "data/raw/board/s30/S30_E2_A1_waveform.csv"
FS = 4000


def overview(ax, t, y, color, bins=1400):
    """Show measured min/max in time bins without joining across gaps."""
    indices = np.minimum((t / (t[-1] + 1 / FS) * bins).astype(int), bins - 1)
    starts = np.r_[0, np.flatnonzero(np.diff(indices)) + 1]
    ends = np.r_[starts[1:], len(t)]
    lo = np.minimum.reduceat(y, starts)
    hi = np.maximum.reduceat(y, starts)
    centers = (t[starts] + t[ends - 1]) / 2
    ax.vlines(centers, lo, hi, color=color, lw=.7)


def gap_plot(ax, t, y, color):
    for part in contiguous_slices(t, FS):
        ax.plot(t[part], y[part], color=color, lw=.8)


def main():
    digest_before = hashlib.sha256(SOURCE.read_bytes()).hexdigest()
    t, x, labels, meta = load_csv(SOURCE)
    timestamp_us = np.rint(t * 1e6).astype(np.int64)
    gap_after = np.r_[np.diff(timestamp_us) > 250, False]
    aa_high = (x[:, 7] & 0xFF0000) == 0xAA0000
    bad = aa_high & gap_after
    tc, xc = t[~bad], x[~bad]
    assert np.all(gap_after[aa_high]), "Recheck capture-specific exclusion rule"
    # No points are repaired or inserted in either raw-waveform panel.
    # Only the spectral calculation below uses interpolation over short gaps.
    grid = np.arange(timestamp_us[-1] // 250 + 1) / FS
    uniform = np.column_stack([np.interp(grid, tc, xc[:, ch]) for ch in range(8)])
    freq, psd = signal.welch(uniform, FS, axis=0, nperseg=16000,
                             detrend="linear")
    band = (freq >= 20) & (freq <= 450)
    mains = (freq >= 49) & (freq <= 51)
    fraction = np.sum(psd[mains], axis=0) / np.sum(psd[band], axis=0)

    # Independent check: use ONLY uninterrupted 0.2 s measured windows.
    # Their 5 Hz resolution requires a wider 45..55 Hz peak-integration band.
    windows = []
    for part in contiguous_slices(tc, FS):
        for start in range(part.start, part.stop - 799, 800):
            windows.append(xc[start:start + 800])
    segments = np.stack(windows)
    freq_check, power_check = signal.periodogram(
        segments, FS, axis=1, window="hann", detrend="linear")
    power_check = power_check.mean(axis=0)
    check_band = (freq_check >= 20) & (freq_check <= 450)
    check_mains = (freq_check >= 45) & (freq_check <= 55)
    check_fraction = (power_check[check_mains].sum(axis=0)
                      / power_check[check_band].sum(axis=0))
    peak_check = freq_check[check_band][power_check[check_band].argmax(axis=0)]

    plt.rcParams.update({"font.family": "Microsoft YaHei", "font.size": 10,
                         "axes.unicode_minus": False, "axes.spines.top": False,
                         "axes.spines.right": False, "figure.facecolor": "white"})
    fig, ax = plt.subplots(2, 2, figsize=(14, 8.4), layout="constrained")
    fig.suptitle("真实采集诊断：错位尖峰与 50 Hz 工频干扰", fontsize=19, weight="bold")
    centered = x[:, 7] - np.median(xc[:, 7])
    overview(ax[0, 0], t, centered / 1e6, "#bf4d36")
    ax[0, 0].set(title=f"CH8 原始记录：{bad.sum():,} 帧符合错位特征",
                  xlabel="录制时间（秒）", ylabel="减去中位数后的 ADC counts（百万）")
    ax[0, 0].text(.04, .08, "巨大假尖峰压缩了正常信号\n原始文件保持不变",
                  transform=ax[0, 0].transAxes, fontsize=11,
                  bbox=dict(facecolor="white", alpha=.93, edgecolor="none", pad=4))
    overview(ax[0, 1], tc, xc[:, 7] - np.median(xc[:, 7]), "#25648b")
    ax[0, 1].set(title="CH8 排除这些整帧后的诊断视图",
                  xlabel="录制时间（秒）", ylabel="减去中位数后的 ADC counts")
    ax[0, 1].text(.04, .08, "时间保持原样，缺失值未补回\n仍有基线漂移与周期干扰",
                  transform=ax[0, 1].transAxes, fontsize=11)
    short = (tc >= 46.8) & (tc < 47.0)
    gap_plot(ax[1, 0], tc[short], xc[short, 7] - np.median(xc[short, 7]), "#25648b")
    ax[1, 0].set(title="CH8 连续 0.2 秒实测片段（未滤波）",
                  xlabel="录制时间（秒）", ylabel="减去片段中位数后的 ADC counts")
    ax[1, 0].text(.03, .91, "约每 20 ms 一个周期 = 50 Hz",
                  transform=ax[1, 0].transAxes, fontsize=11,
                  bbox=dict(facecolor="white", alpha=.93, edgecolor="none", pad=3))
    for ch in range(8):
        relative = 10 * np.log10(np.maximum(psd[:, ch] / psd[band, ch].max(), 1e-12))
        ax[1, 1].plot(freq[band], relative[band], lw=1 if ch == 7 else .7,
                       color="#25648b" if ch == 7 else "#aab3bb",
                       label="CH8" if ch == 7 else ("CH1–CH7" if ch == 0 else None))
    ax[1, 1].axvspan(49, 51, color="#bf4d36", alpha=.18)
    ax[1, 1].set(title="八通道频谱：50 Hz 峰占主导",
                  xlabel="频率（Hz）", ylabel="相对本通道峰值的功率谱（dB）",
                  xlim=(20, 450), ylim=(-65, 2))
    ax[1, 1].legend(frameon=False)
    for a in ax.flat:
        a.grid(alpha=.18)
    fig.get_layout_engine().set(rect=(0, .055, 1, .95))
    fig.text(.5, .017,
             "源文件 S30_E2_A1_waveform.csv，4 kSPS。上方为 min/max 概览；左下为逐点波形。"
             "仅频谱计算对短缺口插值；动作均未标注。",
             ha="center", fontsize=9)
    fig.savefig(OUT / "diagnosis_overview.png", dpi=145)
    plt.close(fig)

    fig, ax = plt.subplots(8, 2, figsize=(14, 13), layout="constrained")
    fig.suptitle("八通道实测短波形及功率谱", fontsize=19, weight="bold")
    for ch in range(8):
        gap_plot(ax[ch, 0], tc[short], xc[short, ch] - np.median(xc[short, ch]), "#25648b")
        ax[ch, 0].set_ylabel(f"CH{ch + 1}\nADC counts")
        relative = 10 * np.log10(np.maximum(psd[:, ch] / psd[band, ch].max(), 1e-12))
        ax[ch, 1].plot(freq[band], relative[band], color="#25648b", lw=.85)
        ax[ch, 1].axvspan(49, 51, color="#bf4d36", alpha=.18)
        ax[ch, 1].set(xlim=(20, 450), ylim=(-65, 2), ylabel="相对功率（dB）")
        ax[ch, 1].text(.96, .82, f"49–51 Hz 占比 {100 * fraction[ch]:.1f}%",
                       ha="right", transform=ax[ch, 1].transAxes, fontsize=10)
        for a in ax[ch]:
            a.grid(alpha=.18)
            if ch != 7:
                a.tick_params(labelbottom=False)
    ax[0, 0].set_title("46.8–47.0 秒连续实测，减去片段中位数，未滤波")
    ax[0, 1].set_title("排除坏帧后，短缺口插值仅用于 Welch 频谱")
    ax[-1, 0].set_xlabel("录制时间（秒）")
    ax[-1, 1].set_xlabel("频率（Hz）")
    fig.get_layout_engine().set(rect=(0, .025, 1, .96))
    fig.text(.5, .01, "占比：49–51 Hz 功率 / 20–450 Hz 功率。缺失及错位样本不能恢复；"
             "本图不能确定每次握拳和张手的时刻。", ha="center", fontsize=9)
    fig.savefig(OUT / "eight_channels.png", dpi=145)
    plt.close(fig)

    # Also retain a full-duration view without known corrupted frames.
    fig, ax = plt.subplots(8, 1, figsize=(14, 12), sharex=True, layout="constrained")
    fig.suptitle("排除已识别错位帧后的八通道概览（未滤波）", fontsize=18, weight="bold")
    for ch in range(8):
        overview(ax[ch], tc, xc[:, ch] - np.median(xc[:, ch]), "#25648b")
        ax[ch].set_ylabel(f"CH{ch + 1}\nADC counts")
        ax[ch].grid(alpha=.18)
    ax[-1].set_xlabel("录制时间（秒）")
    fig.get_layout_engine().set(rect=(0, .025, 1, .96))
    fig.text(.5, .01, "仅排除 1,522 个有明确错位特征的整帧，按时间分箱显示实测最小/最大值，"
             "每通道减去中位数。未插值、未恢复样本。", ha="center", fontsize=9)
    fig.savefig(OUT / "full_capture_excluded_frames.png", dpi=145)
    plt.close(fig)

    first = int(np.flatnonzero(bad)[0])
    jumps = np.max(np.abs(np.diff(x, axis=0)), axis=1) >= 100000
    touching_bad = bad[:-1] | bad[1:]
    stats = {
        "source": SOURCE.relative_to(ROOT).as_posix(),
        "source_sha256": digest_before,
        "sample_rate_hz": FS,
        "frames_original": len(t),
        "duration_s": float(t[-1]),
        "metadata_missing_sequences": meta["frames_dropped_uart"],
        "observed_timestamp_gaps": int(gap_after.sum()),
        "known_bad_frames": int(bad.sum()),
        "excluded_candidate_frames": len(tc),
        "exclusion_rule_capture_specific": "CH8 high byte AA AND immediately followed by timestamp gap >250 us; exclude whole row",
        "large_jumps_at_least_100000_counts": int(jumps.sum()),
        "large_jumps_not_touching_known_bad_frames": int((jumps & ~touching_bad).sum()),
        "retained_min_counts": xc.min(axis=0).tolist(),
        "retained_max_counts": xc.max(axis=0).tolist(),
        "mains_fraction_interpolated_49_51_over_20_450": fraction.tolist(),
        "spectral_method": "Welch, fs=4000, nperseg=16000, Hann, 50% overlap, linear detrend; linear interpolation only for spectrum",
        "continuous_check_windows": len(windows),
        "continuous_check_duration_s": len(windows) * .2,
        "continuous_check_peak_hz": peak_check.tolist(),
        "continuous_check_fraction_45_55_over_20_450": check_fraction.tolist(),
        "continuous_check_method": "Mean periodogram of disjoint 800-sample contiguous measured windows, Hann, linear detrend, no interpolation",
        "labels": np.unique(labels).tolist(),
        "first_bad_csv_line": first + 2,
        "first_bad_example": [{"timestamp_us": int(timestamp_us[i]), "values": x[i].tolist()}
                              for i in range(first - 1, first + 2)],
        "bad_csv_lines": (np.flatnonzero(bad) + 2).tolist(),
        "provenance": "Diagnostic exclusion is not recovered measurement data; original CSV and JSON are untouched; retained frames are not guaranteed corruption-free without CRC",
    }
    assert hashlib.sha256(SOURCE.read_bytes()).hexdigest() == digest_before
    (OUT / "statistics.json").write_text(json.dumps(stats, ensure_ascii=False, indent=2), encoding="utf-8")
    print(json.dumps({key: stats[key] for key in (
        "frames_original", "known_bad_frames", "duration_s", "observed_timestamp_gaps",
        "mains_fraction_interpolated_49_51_over_20_450", "continuous_check_windows",
        "continuous_check_peak_hz", "continuous_check_fraction_45_55_over_20_450",
        "large_jumps_not_touching_known_bad_frames", "source_sha256")}, indent=2))


if __name__ == "__main__":
    main()
