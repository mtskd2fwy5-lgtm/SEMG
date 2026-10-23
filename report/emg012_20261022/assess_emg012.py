"""EMG012 quality and EMG008-only training transfer; reuse existing methods."""
from pathlib import Path
import sys
import json
import hashlib
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

ROOT = Path(__file__).resolve().parents[2]
OUT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT / 'report/emg011_20261022'))
import assess_emg011 as previous
base = previous.base
FS = base.FS
NAMES = base.CLASS_NAMES
CN = ['放松', '张手', '握拳', '屈腕', '伸腕']


def summarize(model):
    return {k: model[k] for k in ('accuracy_mean', 'accuracy_sd', 'macro_f1_mean',
                                  'action_bout_accuracy_mean')}


def recall(model):
    return {c: float(np.mean([s['per_class'][c]['recall'] for s in model['seeds']]))
            for c in NAMES}


def main():
    rec = base.load_record('F:/EMG012.BIN')
    train = base.load_record('F:/EMG008.BIN')
    streams, spectra = {}, {}
    for key in ('raw', 'processed'):
        streams[key], spectra[key] = base.analyze_stream(rec, key)
    clean = previous.category_clean_rms(streams['processed'])
    bursts = previous.burst_summary(rec)
    reference = []
    for start in (0, 80, 160, 235):
        for ch in range(8):
            a, b = start * FS, (start + 8) * FS
            filt = base.ProcessedSignal()
            pred = np.array([filt.step(int(v)) for v in rec['raw'][a:b, ch]])
            err = pred[5 * FS:] - rec['processed'][a + 5 * FS:b, ch]
            reference.append(dict(start_s=start+5, end_s=start+8, channel=ch+1,
                                  max_abs_error=int(abs(err).max())))
    assert max(r['max_abs_error'] for r in reference) <= 5, reference

    matched = {}
    for number in ('008', '011'):
        old = train if number == '008' else base.load_record('F:/EMG011.BIN')
        comparison = {}
        assert rec['segments'][0]['label'] == old['segments'][0]['label'] == 'rest'
        assert min(rec['segments'][0]['end_s'], old['segments'][0]['end_s']) > 5
        for stream in ('raw', 'processed'):
            f, po = base.welch(old[stream][FS:5*FS])
            _, pn = base.welch(rec[stream][FS:5*FS])
            mo, mn = base.spectral(f, po), base.spectral(f, pn)
            comparison[stream] = dict(prior=mo, EMG012=mn,
                change_db={k: (20*np.log10(np.maximum(mn[k], 1e-12) /
                                          np.maximum(mo[k], 1e-12))).tolist()
                           for k in ('mains_rms', 'harmonic_rms', 'clean_rms', 'low_rms')},
                pc1_prior=base.pc1_fraction(old[stream][FS:5*FS]),
                pc1_EMG012=base.pc1_fraction(rec[stream][FS:5*FS]))
        matched['EMG'+number] = comparison
        if number != '008':
            del old

    xt, yt, _ = base.window_features(train)
    x, y, info = base.window_features(rec)
    keep = np.array([block*8+ch for block in range(5) for ch in range(8) if ch != 5])
    models = {}
    for key, indices in (('8ch', np.arange(40)), ('7ch_without_CH6', keep)):
        transfer = base.evaluate(xt[:, indices], yt, x[:, indices], y, info,
                                'EMG008 train -> EMG012 test ('+key+')')
        transfer['contract'] = ('EMG008 only; saved PL processed waveform; '
            'per-channel MAV/WL/Energy/ZC/SSC; 100 ms/25 ms; StandardScaler + MLP(64,32); '
            'feature_columns='+str(len(indices)))
        within = previous.grouped_validation(x[:, indices], y, info)
        within['name'] = within['name'].replace('EMG011', 'EMG012')+' ('+key+')'
        models[key] = dict(transfer=transfer, within=within,
                           transfer_recall=recall(transfer), within_recall=recall(within))
    digest = hashlib.sha256(rec['blob']).hexdigest()
    pages = {k: json.loads((OUT/('EMG012_'+k+'_analysis.json')).read_text(encoding='utf-8'))
             for k in ('raw', 'processed')}
    result = dict(input='F:/EMG012.BIN', sha256=digest, bytes=len(rec['blob']),
        frames=len(rec['frames']), duration_s=len(rec['frames'])/FS, format=rec['header'],
        user_confirmation='Re-worn, other conditions same; CH6 disconnected electrode repaired before recording. Placement CH1-6 wrist, CH7-8 near elbow, no gel carried over from prior confirmed setup.',
        integrity=dict(missing=0, backward=0, duplicate=0, wraps=int((np.diff(rec['seq'])<0).sum())),
        segments=[{k:s[k] for k in ('label','start_s','end_s')} for s in rec['segments']],
        quality_status={k:pages[k]['quality_status'] for k in pages}, streams=streams,
        class_clean_rms=clean, matched_rest_1_to_5s=matched, reference_checks=reference,
        bursts=bursts, models=models,
        method=dict(trim_s=1, psd='Duration-weighted stable segments; Welch 4096; linear detrend; 50% overlap',
            line_bands='50 +/-1 Hz; harmonics every 50 Hz, 100-450 Hz +/-1 Hz; includes physiological power inside these bands',
            model='Refit EMG008-only baseline with fixed training settings and five seeds; no EMG012 used in transfer training or scaling',
            within='Complete labeled bouts held out in outer StratifiedGroupKFold; internal MLP early stopping uses random training windows',
            limitations='Overlapping windows are correlated. Three action bouts per class, one wearing session. Seed SD is not a confidence interval. PC1 of differential channels is shared variance, not a direct common-mode voltage measurement.'))
    (OUT/'EMG012_quality.json').write_text(json.dumps(result,indent=2,ensure_ascii=False),encoding='utf-8')

    fig, axes = plt.subplots(8,2,figsize=(17,13),sharex=True)
    n=len(rec['frames'])//400
    times=(np.arange(n)+.5)/10
    for ch in range(8):
        raw=rec['raw'][:n*400,ch].reshape(n,400)
        pro=rec['processed'][:n*400,ch].reshape(n,400).astype(float)
        axes[ch,0].fill_between(times,raw.min(1)/1000,raw.max(1)/1000,lw=0,color='#356ab5')
        axes[ch,1].plot(times,np.sqrt((pro*pro).mean(1)),lw=.7,color='#188578')
        axes[ch,0].set_ylabel(f'CH{ch+1}\nkcounts')
        axes[ch,1].set_ylabel('RMS counts')
        for ax in axes[ch]:
            for s in rec['segments']:
                ax.axvspan(s['start_s'],s['end_s'],color=base.COLORS[s['label']],alpha=.3)
            ax.grid(alpha=.2)
    axes[0,0].set_title('RAW extrema / 100 ms')
    axes[0,1].set_title('Processed RMS / 100 ms; CH6 repaired')
    for ax in axes[-1]: ax.set_xlabel('Saved time (s)')
    fig.tight_layout()
    fig.savefig(OUT/'EMG012_waveform_quality.png',dpi=130)
    plt.close(fig)
    fig, axes=plt.subplots(4,2,figsize=(15,12),sharex=True)
    for ch,ax in enumerate(axes.flat):
        for key,color in (('raw','#b5653e'),('processed','#188578')):
            f,p=spectra[key]; m=(f>=1)&(f<=450)
            ax.plot(f[m],10*np.log10(np.maximum(p[m,ch],1e-12)),lw=.8,label=key,color=color)
        ax.set_title('CH'+str(ch+1));ax.set_ylabel('PSD dB counts²/Hz');ax.grid(alpha=.2)
    axes[0,0].legend()
    for ax in axes[-1]:ax.set_xlabel('Hz')
    fig.tight_layout();fig.savefig(OUT/'EMG012_spectrum_quality.png',dpi=130);plt.close(fig)

    lines=['# EMG012：CH6 修复后的重新佩戴评估','',
        '用户确认：重新佩戴，其余条件相同；CH6 断路电极已修好。沿用 CH1–6 手腕、CH7–8 近肘部、未使用凝胶的既有条件描述。','',
        f"共 {len(rec['frames']):,} 帧，{len(rec['frames'])/FS:.3f} 秒，4000 Hz；序号连续，未发现丢帧、倒退或重复。raw 数字满量程样本 {streams['raw']['rails']}，峰值为量程的 {100*streams['raw']['max_fraction']:.1f}%。",
        f"raw 质量状态 {pages['raw']['quality_status']}；processed 为 {pages['processed']['quality_status']}。PL 保存输出与整数参考最大误差 {max(r['max_abs_error'] for r in reference)} counts。",'',
        '## EMG008 → EMG012 跨佩戴测试','',
        '仅用 EMG008 标注数据按既有基线重新训练；没有找到 EMG008 专属已保存模型。8 通道为主，排除 CH6 的 7 通道仅作对照。','',
        '| 通道 | 窗口准确率（五种子均值±标准差） | 宏 F1 | 动作段多数票准确率 |',
        '|---|---:|---:|---:|']
    for key in models:
        m=models[key]['transfer']
        lines.append(f"| {key} | {100*m['accuracy_mean']:.1f}% ± {100*m['accuracy_sd']:.1f}% | {100*m['macro_f1_mean']:.1f}% | {100*m['action_bout_accuracy_mean']:.1f}% |")
    lines += ['', '| 动作 | 8 通道召回率 | 排除 CH6 召回率 |', '|---|---:|---:|']
    for en,cn in zip(NAMES,CN):
        lines.append(f"| {cn} | {100*models['8ch']['transfer_recall'][en]:.1f}% | {100*models['7ch_without_CH6']['transfer_recall'][en]:.1f}% |")
    lines += ['', '## 本次佩戴内按完整动作段留出','']
    for key in models:
        m=models[key]['within']
        lines.append(f"- {key}：准确率 {100*m['accuracy_mean']:.1f}% ± {100*m['accuracy_sd']:.1f}%，宏 F1 {100*m['macro_f1_mean']:.1f}%。")
    lines += ['', '首尾各裁掉 1 秒；外层按完整动作段分组，避免同一段的重叠窗口跨训练/测试。内部早停仍用训练折内的随机窗口；每类仅 3 个动作段，不能当成未来重佩戴准确率。种子标准差也不是置信区间。','',
        '## CH6 与通道响应','', '| 动作 | CH1 | CH2 | CH3 | CH4 | CH5 | CH6 | CH7 | CH8 |', '|---|---:|---:|---:|---:|---:|---:|---:|---:|']
    for en,cn in zip(NAMES,CN):
        lines.append('| '+cn+' | '+' | '.join(f'{v:.2f}' for v in clean[en]['median_by_channel'])+' |')
    lines += ['', '上表为各动作段稳定区的去线频 20–450 Hz RMS 类别中位数（ADC counts）；排除了 50 Hz 及其谐波附近频点，但仍可能含宽带噪声或运动伪迹，不能直接视为纯肌电。','',
        '## 工频、谐波与共同变化','', '| 通道 | raw 50 Hz RMS | processed 50 Hz RMS | 50 Hz 衰减 dB | processed 谐波功率占比 |', '|---|---:|---:|---:|---:|']
    for ch in range(8):
        a=streams['raw']['stable']['mains_rms'][ch];b=streams['processed']['stable']['mains_rms'][ch]
        h=streams['processed']['stable']['harmonic_percent'][ch]
        lines.append(f'| CH{ch+1} | {a:.2f} | {b:.2f} | {20*np.log10(a/max(b,1e-12)):.1f} | {h:.2f}% |')
    lines += ['', '谐波指标为 100–450 Hz、每 50 Hz ±1 Hz 的功率；其中也包含该频带内的生理信号，不能全部算作残留干扰。不同动作时长会改变全记录统计，重佩戴对比另用共同静息 1–5 秒。','']
    for prior in matched:
        p=matched[prior]['processed'];r=matched[prior]['raw']
        lines.append(f"- 对比 {prior} 静息 1–5 秒：processed 50 Hz 变化 {min(p['change_db']['mains_rms']):+.1f} 至 {max(p['change_db']['mains_rms']):+.1f} dB；谐波变化 {min(p['change_db']['harmonic_rms']):+.1f} 至 {max(p['change_db']['harmonic_rms']):+.1f} dB。raw PC1 方差占比 {100*r['pc1_prior']:.1f}% → {100*r['pc1_EMG012']:.1f}%；processed {100*p['pc1_prior']:.1f}% → {100*p['pc1_EMG012']:.1f}%。")
    lines += ['', 'PC1 是差分通道共享方差比例，受通道尺度、漂移影响，不等于实测共模电压；这份文件未单独记录 BIAS 输出。','', '## 需复核的瞬态片段','']
    for row in bursts:
        hits=[f'CH{i+1}: {100*v:.0f}%' for i,v in enumerate(row['top10percent_power_share']) if v>.5]
        if hits:
            lines.append(f"- {row['label']} {row['start_s']:.2f}–{row['end_s']:.2f} 秒：前 10% 高功率窗口贡献该段功率 {'；'.join(hits)}。")
    lines += ['', '这些是复核线索，不能仅凭集中度判为伪迹；建议训练前查看具体波形。','', '## 动作区间','']
    for s in rec['segments']:
        lines.append(f"- {s['label']}：{s['start_s']:.3f}–{s['end_s']:.3f} 秒。")
    lines += ['', '## 复现与文件','', f'SHA256：{digest}', '',
        '- assess_emg012.py：复现脚本，复用前次分析函数。',
        '- EMG012_quality.json：完整质量与分类指标。',
        '- EMG012_raw_analysis.html / EMG012_processed_analysis.html：交互波形与频谱。',
        '- EMG012_waveform_quality.png / EMG012_spectrum_quality.png：概览图。', '']
    (OUT/'EMG012_quality_report.md').write_text('\n'.join(lines),encoding='utf-8')
    print('SUMMARY',json.dumps({k:result[k] for k in ('frames','duration_s','integrity','quality_status')},ensure_ascii=False))
    print('CH6', json.dumps({c:clean[c]['median_by_channel'][5] for c in NAMES}))
    for key in models:
        print('MODEL',key,json.dumps(dict(transfer=summarize(models[key]['transfer']),within=summarize(models[key]['within']),recall=models[key]['transfer_recall'])))
    print('TEST_PASS: framing, finite PSD, filter reference, EMG008 held-out transfer and grouped validation')


if __name__ == '__main__':
    main()
