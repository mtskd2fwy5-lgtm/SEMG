"""Read-only E3 diagnosis; keep source CSV and JSON unchanged."""
import hashlib
import json
import sys
from pathlib import Path

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
from scipy import signal

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'tools'))
from plot_csv import load_csv, contiguous_slices, envelope

OUT = Path(__file__).resolve().parent
SOURCE = ROOT / 'data/raw/board/s30/S30_E3_A1_waveform.csv'
FS = 4000


def main():
    sources = [SOURCE, SOURCE.with_suffix('.json')]
    before = {p.name: hashlib.sha256(p.read_bytes()).hexdigest() for p in sources}
    t, x, labels, meta = load_csv(SOURCE)
    ticks = np.rint(t * 1e6).astype(np.int64)
    dt = np.diff(ticks)
    missing = int(np.sum(dt // 250 - 1))
    assert meta['signal'] == 'notch50' and meta['parser_version'] == 3
    assert meta['filter']['id'] == 'notch50_q10_q24_v1'
    assert len(x) == meta['frames_written'] == meta['frames_captured']
    assert np.all(dt > 0) and np.all(dt % 250 == 0)
    assert missing == meta['frames_dropped_uart']
    # Interpolation is used ONLY for the full-duration spectral estimate.
    grid = np.arange(ticks[-1] // 250 + 1) / FS
    z = np.column_stack([np.interp(grid, t, x[:, c]) for c in range(8)])
    f, p = signal.welch(z, FS, axis=0, nperseg=16000, detrend='linear')
    band = (f >= 20) & (f <= 450)
    centers = np.arange(100, 401, 50)
    harmonic = np.any(abs(f[:, None] - centers[None, :]) <= 2, axis=1) & band
    mains_fraction = p[(f >= 49) & (f <= 51)].sum(0) / p[band].sum(0)
    harmonic_fraction = p[harmonic].sum(0) / p[band].sum(0)
    parts = contiguous_slices(t, FS)
    windows = [x[s:s + 800] for part in parts
               for s in range(part.start, part.stop - 799, 800)]
    # Independent check: no missing or interpolated points in these windows.
    fc, pc = signal.periodogram(np.stack(windows), FS, axis=1,
                                window='hann', detrend='linear')
    pc = pc.mean(0)
    bc = (fc >= 20) & (fc <= 450)
    hc = np.any(abs(fc[:, None] - centers[None, :]) <= 5, axis=1) & bc
    check_fraction = pc[hc].sum(0) / pc[bc].sum(0)
    peaks = fc[bc][pc[bc].argmax(0)]
    plt.rcParams.update({'font.family': 'Microsoft YaHei', 'font.size': 10,
                         'axes.unicode_minus': False, 'axes.spines.top': False,
                         'axes.spines.right': False, 'figure.facecolor': 'white'})
    colors = plt.colormaps['tab10'](np.arange(8))
    fig, ax = plt.subplots(2, 2, figsize=(14, 8.8), layout='constrained')
    fig.suptitle('E3 新录制：50 Hz 已受抑制，周期干扰仍占主导', fontsize=18, weight='bold')
    tc, lo, hi = envelope(t, x[:, 5], 1800)
    ax[0, 0].vlines(tc, lo / 1000, hi / 1000, color=colors[5], lw=.65)
    ax[0, 0].set(title='CH6 全程实测 min/max 概览',
                  xlabel='录制时间（秒）', ylabel='ADC counts（千）')
    short = (t >= 36.4) & (t < 36.48)
    assert np.all(np.diff(ticks[short]) == 250)
    ax[0, 1].plot(t[short], x[short, 5] / 1000, color=colors[5], lw=1)
    ax[0, 1].set(title='CH6 连续 80 ms 逐点实测：仍有重复脉冲',
                  xlabel='录制时间（秒）', ylabel='ADC counts（千）')
    for c in range(8):
        relative = 10 * np.log10(np.maximum(p[:, c] / p[band, c].max(), 1e-12))
        ax[1, 0].plot(f[band], relative[band], color=colors[c], lw=.8, label=f'CH{c+1}')
    for hz in [50, *centers]:
        ax[1, 0].axvline(hz, color='#6b7280', lw=.6, alpha=.25)
    ax[1, 0].set(title='主要峰在 100 Hz、150 Hz 及其倍频', xlabel='频率（Hz）',
                  ylabel='相对本通道峰值功率（dB）', xlim=(20, 450), ylim=(-65, 2))
    ax[1, 0].legend(ncol=4, fontsize=8, frameon=False)
    xx = np.arange(8)
    ax[1, 1].bar(xx, 100 * harmonic_fraction, color=colors, width=.7)
    ax[1, 1].set(title='100–400 Hz、间隔 50 Hz 的窄频带功率占比',
                  xlabel='通道', ylabel='占 20–450 Hz 功率（%）', ylim=(0, 110),
                  xticks=xx, xticklabels=[f'CH{c+1}' for c in xx])
    for c, value in enumerate(harmonic_fraction):
        ax[1, 1].text(c, 100 * value + 1, f'{100*value:.1f}%', ha='center', fontsize=9)
    for a in ax.flat:
        a.grid(alpha=.17)
    fig.get_layout_engine().set(rect=(0, .06, 1, .95))
    fig.text(.5, .018, '本次 BIAS 未接人体，动作连续变换但未标注时刻。功率占比不是信噪比或识别准确率。\n'
             '未叠加滤波。仅全程频谱对缺失点插值；右上为无缺口实测，柱图频带为各中心 ±2 Hz。',
             ha='center', fontsize=9)
    fig.savefig(OUT / 'diagnosis_overview.png', dpi=145)
    plt.close(fig)
    fig, axs = plt.subplots(8, 2, figsize=(14, 13), layout='constrained')
    short = (t >= 36.4) & (t < 36.6)
    assert np.all(np.diff(ticks[short]) == 250)
    for c in range(8):
        axs[c, 0].plot(t[short], x[short, c], color=colors[c], lw=.8)
        axs[c, 0].set_ylabel(f'CH{c+1}\nADC counts')
        rel = 10 * np.log10(np.maximum(p[:, c] / p[band, c].max(), 1e-12))
        axs[c, 1].plot(f[band], rel[band], color=colors[c], lw=.8)
        axs[c, 1].set(xlim=(20, 450), ylim=(-65, 2), ylabel='相对功率（dB）')
        axs[c, 1].text(.98, .78, f'49–51 Hz 占比 {100*mains_fraction[c]:.4f}%',
                        transform=axs[c, 1].transAxes, ha='right', fontsize=9)
        for a in axs[c]:
            a.grid(alpha=.17)
            if c != 7:
                a.tick_params(labelbottom=False)
    axs[0, 0].set_title('36.4–36.6 秒连续实测，未做额外滤波')
    axs[0, 1].set_title('全程 Welch 频谱，缺失点仅为频谱估计插值')
    axs[-1, 0].set_xlabel('录制时间（秒）')
    axs[-1, 1].set_xlabel('频率（Hz）')
    fig.suptitle('E3 八通道短波形与频谱（BIAS 未接人体）', fontsize=18)
    fig.savefig(OUT / 'eight_channels.png', dpi=135)
    plt.close(fig)
    stats = {
        'source': SOURCE.relative_to(ROOT).as_posix(), 'source_sha256': before,
        'sample_rate_hz': FS, 'frames': len(x), 'duration_s': float(t[-1] + 1 / FS),
        'missing_frame_sequences': missing, 'gap_events': int(np.sum(dt != 250)),
        'missing_fraction': missing / (missing + len(x)),
        'timestamp_step_us_counts': dict(zip(*[a.tolist() for a in np.unique(dt, return_counts=True)])),
        'rail_counts': ((x <= -8388608) | (x >= 8388607)).sum(0).tolist(),
        'ch8_old_AA_highbyte_signature_count': int(np.sum((x[:, 7] & 0xff0000) == 0xaa0000)),
        'labels': np.unique(labels).tolist(),
        'bias_contact_user_report': 'not touching body throughout E3',
        'calibration_bias_state_user_report': 'unknown',
        'bias_triggers_gate_user_report': 'observed in monitor mode, not recording; stale record-mode label is not the explanation',
        'actions_user_report': 'continuously alternating rest, fist, open; no timestamps',
        'mains_fraction_49_51_over_20_450': mains_fraction.tolist(),
        'harmonic_fraction_100_to_400_step50_pm2_over_20_450': harmonic_fraction.tolist(),
        'spectral_method': 'Welch Hann 16000 points, 50% overlap, linear detrend; interpolation for spectrum only',
        'continuous_check_windows': len(windows), 'continuous_check_seconds': len(windows) * .2,
        'continuous_check_peak_hz': peaks.tolist(),
        'continuous_check_harmonic_fraction_pm5': check_fraction.tolist(),
        'continuous_check_method': 'mean Hann periodogram of disjoint 800-sample measured contiguous windows; no interpolation, nonuniform coverage',
        'comparison_limitation': 'E2 raw with BIAS attached vs E3 notch50 with BIAS detached; not a controlled attenuation comparison',
        'wire_limitation': 'no CRC; boundary validation does not prove payload integrity',
    }
    for path in sources:
        assert hashlib.sha256(path.read_bytes()).hexdigest() == before[path.name]
    (OUT / 'statistics.json').write_text(json.dumps(stats, ensure_ascii=False, indent=2), encoding='utf-8')
    print(json.dumps(stats, ensure_ascii=False, indent=2))


if __name__ == '__main__':
    main()
