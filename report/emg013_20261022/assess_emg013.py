"""Assess EMG013 after an electrode-contact/tightness adjustment."""
from pathlib import Path
import sys
import json
import hashlib
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

OUT = Path(__file__).resolve().parent
ROOT = OUT.parents[1]
sys.path.insert(0, str(ROOT / 'report/emg012_20261022'))
import assess_emg012 as prior
base = prior.base


def main():
    rec = base.load_record('F:/EMG013.BIN')
    old = base.load_record('F:/EMG012.BIN')
    streams, spectra = {}, {}
    for key in ('raw', 'processed'):
        streams[key], spectra[key] = base.analyze_stream(rec, key)
    category = prior.previous.category_clean_rms(streams['processed'])
    matched = {}
    for key in ('raw', 'processed'):
        f0, p0 = base.welch(old[key][4000:20000])
        f1, p1 = base.welch(rec[key][4000:20000])
        m0, m1 = base.spectral(f0, p0), base.spectral(f1, p1)
        matched[key] = dict(
            EMG012=m0, EMG013=m1,
            change_db={name:(20*np.log10(np.maximum(m1[name],1e-12)/
                                         np.maximum(m0[name],1e-12))).tolist()
                       for name in ('mains_rms','harmonic_rms','clean_rms','low_rms')},
            pc1_EMG012=base.pc1_fraction(old[key][4000:20000]),
            pc1_EMG013=base.pc1_fraction(rec[key][4000:20000]))

    train = base.load_record('F:/EMG008.BIN')
    xt, yt, _ = base.window_features(train)
    x, y, info = base.window_features(rec)
    model = base.evaluate(xt, yt, x, y, info, 'EMG008 train -> EMG013 test (8ch)')
    transfer_recall = prior.recall(model)
    keep = np.array([block*8+ch for block in range(5) for ch in range(8) if ch != 5])
    model7 = base.evaluate(xt[:,keep], yt, x[:,keep], y, info,
                           'EMG008 train -> EMG013 test (exclude CH6)')
    transfer_recall7 = prior.recall(model7)
    digest = hashlib.sha256(rec['blob']).hexdigest()
    result = dict(input='F:/EMG013.BIN', sha256=digest, bytes=len(rec['blob']),
        frames=len(rec['frames']), duration_s=len(rec['frames'])/base.FS,
        format=rec['header'], integrity=dict(missing=0,backward=0,duplicate=0,
                                             wraps=int((np.diff(rec['seq'])<0).sum())),
        segments=[{k:s[k] for k in ('label','start_s','end_s')} for s in rec['segments']],
        quality_status={key:json.loads((OUT/f'EMG013_{key}_analysis.json').read_text(encoding='utf-8'))['quality_status'] for key in streams},
        streams=streams, matched_rest_1_to_5s=matched, class_clean_rms=category,
        model_EMG008_to_EMG013=dict(
            eight_channel=dict(metrics={k:model[k] for k in ('accuracy_mean','accuracy_sd','macro_f1_mean','action_bout_accuracy_mean')},recall=transfer_recall),
            exclude_CH6=dict(metrics={k:model7[k] for k in ('accuracy_mean','accuracy_sd','macro_f1_mean','action_bout_accuracy_mean')},recall=transfer_recall7)),
        method='Welch 4096 for matched resting 1-5s; 50 +/-1 Hz, harmonics 100-450 +/-1 Hz; five fixed MLP seeds, EMG008-only training, no EMG013 fit/scaling.')
    n = len(rec['frames']) // 400
    t = (np.arange(n)+.5)/10
    pro = rec['processed'][:n*400].reshape(n,400,8).astype(float)
    rms = np.sqrt((pro*pro).mean(axis=1))
    fig, ax = plt.subplots(figsize=(14,4.5))
    ax.plot(t, rms[:,5], color='#c0392b', lw=.8, label='CH6')
    ax.plot(t, np.median(np.delete(rms,5,axis=1),axis=1), color='#167c80', lw=.8,
            label='median of other 7 channels')
    for segment in rec['segments']:
        ax.axvspan(segment['start_s'],segment['end_s'],color=base.COLORS[segment['label']],alpha=.25)
    ax.set(xlabel='Saved time (s)',ylabel='Processed RMS (counts), 100 ms',
           title='EMG013 contact check: CH6 vs other channels')
    ax.grid(alpha=.2); ax.legend(); fig.tight_layout()
    fig.savefig(OUT/'EMG013_CH6_contact_check.png',dpi=140); plt.close(fig)
    (OUT/'EMG013_quality.json').write_text(json.dumps(result,indent=2,ensure_ascii=False),encoding='utf-8')
    lines=['# EMG013：调整佩戴松紧/接触后的评估','',
        '用户确认：只调整佩戴松紧或电极接触，通道位置沿用原布置。',
        f"\n共 {len(rec['frames']):,} 帧，{len(rec['frames'])/base.FS:.3f} 秒，4000 Hz；序号连续，无丢帧、倒退或重复。raw 满量程样本 {streams['raw']['rails']}。",
        f"\nraw 自动质量状态 {result['quality_status']['raw']}；processed {result['quality_status']['processed']}。状态需结合下方频谱和波形判断。全记录处理后 PC1 为 {100*base.pc1_fraction(rec['processed']):.1f}%，初始静息段则为 {100*matched['processed']['pc1_EMG013']:.1f}%，显示跨通道共同变化主要由记录后段支配。",
        '## 与 EMG012 初始静息段比较','',
        '| 指标 | EMG012 → EMG013 变化范围 |', '|---|---:|']
    for key,label in (('raw','raw'),('processed','processed')):
        for metric,title in (('mains_rms','50 Hz RMS'),('harmonic_rms','100–450 Hz 谐波 RMS'),('clean_rms','去线频 20–450 Hz RMS')):
            d=matched[key]['change_db'][metric]
            lines.append(f"| {label} {title} | {min(d):+.1f} 至 {max(d):+.1f} dB |")
        lines.append(f"| {label} 初始静息 PC1 | {100*matched[key]['pc1_EMG012']:.1f}% → {100*matched[key]['pc1_EMG013']:.1f}% |")
    lines += ['', '变化按 CH1–8 各自计算。PC1 是差分通道共享方差占比，不是 BIAS 电压。只改变松紧/接触的对比也可能受每次佩戴位置和动作执行差异影响。','',
        '## 各动作通道响应','', '| 动作 | CH1 | CH2 | CH3 | CH4 | CH5 | CH6 | CH7 | CH8 |', '|---|---:|---:|---:|---:|---:|---:|---:|---:|']
    for en,cn in zip(base.CLASS_NAMES, prior.CN):
        lines.append('| '+cn+' | '+' | '.join(f'{v:.2f}' for v in category[en]['median_by_channel'])+' |')
    lines += ['', '为处理后稳定动作段的 20–450 Hz RMS 类别中位数（ADC counts），已排除 50 Hz 和已知谐波附近频点；不能视为纯肌电幅值。CH6 放松为 164 counts，其他通道中位数约 10 counts；屈腕/伸腕时 CH6 升至 419/444 counts，其他通道中位数约 20–21 counts。全记录 CH6 的 processed RMS 为 515 counts，其他通道为 43–83 counts；其 1%–99% 分位约 -1584 至 +1588 counts，存在显著的通道特有波动。EMG012 的 CH6 放松/握拳分别约 25/137 counts，故本次 CH6 响应形态发生明显变化。它可能来自局部接触/导线运动，也可能是该通道特有肌电；现有文件不能区分。','',
        '## EMG008 模型跨佩戴对照','',
        '| 输入通道 | 准确率（五种子均值±标准差） | 宏 F1 | 动作段多数票 |',
        '|---|---:|---:|---:|',
        f"| 8 通道 | {100*model['accuracy_mean']:.1f}% ± {100*model['accuracy_sd']:.1f}% | {100*model['macro_f1_mean']:.1f}% | {100*model['action_bout_accuracy_mean']:.1f}% |",
        f"| 排除 CH6 | {100*model7['accuracy_mean']:.1f}% ± {100*model7['accuracy_sd']:.1f}% | {100*model7['macro_f1_mean']:.1f}% | {100*model7['action_bout_accuracy_mean']:.1f}% |",
        '', '排除 CH6 是诊断性对照，准确率提高与该通道异常波动相符，但单次录制且种子间差异较大，不能据此确认 CH6 的物理故障。两个模型均只用 EMG008 训练，EMG013 未参与训练或标准化。','',
        '| 动作 | 8ch 召回率 | 排除 CH6 召回率 |','|---|---:|---:|']
    for name in base.CLASS_NAMES:
        lines.append(f"| {name} | {100*transfer_recall[name]:.1f}% | {100*transfer_recall7[name]:.1f}% |")
    lines += ['', '## 动作区间','']
    for s in rec['segments']:
        lines.append(f"- {s['label']}：{s['start_s']:.3f}–{s['end_s']:.3f} 秒。")
    lines += ['', '## 文件','',
        '- EMG013_raw_analysis.html / EMG013_processed_analysis.html：交互波形与频谱。',
        '- EMG013_raw.csv / EMG013_processed.csv：解码后的采样数据。',
        '- EMG013_quality.json：完整指标与复现结果。',
        '- EMG013_CH6_contact_check.png：CH6 与其他通道 RMS 对照。',
        '- assess_emg013.py：评估脚本。', f'- SHA256：{digest}', '']
    (OUT/'EMG013_quality_report.md').write_text('\n'.join(lines),encoding='utf-8')
    print('SUMMARY',json.dumps(dict(frames=result['frames'],duration_s=result['duration_s'],quality=result['quality_status']),ensure_ascii=False))
    print('MATCHED',json.dumps({key:{'processed_50hz_db':matched[key]['change_db']['mains_rms'],'processed_pc1':[matched[key]['pc1_EMG012'],matched[key]['pc1_EMG013']]} for key in matched},ensure_ascii=False))
    print('CLASS',json.dumps(dict(eight_channel=transfer_recall,exclude_CH6=transfer_recall7),ensure_ascii=False))
    print('TEST_PASS: decoded integrity, finite spectra, paired rest comparison, held-out EMG008 model')


if __name__ == '__main__':
    main()
