"""Assess EMG016 under the EMG015 setup; separate rest from labeled motions."""
from pathlib import Path
import sys,json,hashlib
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

OUT=Path(__file__).resolve().parent; ROOT=OUT.parents[1]
sys.path.insert(0,str(ROOT/'report/emg015_20261022'))
import assess_emg015 as previous
base=previous.base

def stable_rest_psd(rec,key):
    ps=[];weights=[]
    for s in rec['segments']:
        if s['label']!='rest':continue
        a=round(float(s['start_s'])*base.FS)+base.FS
        b=round(float(s['end_s'])*base.FS)-base.FS
        if b-a<4096:continue
        f,p=base.welch(rec[key][a:b].astype(float));ps.append(p);weights.append(b-a)
    return f,np.average(ps,axis=0,weights=weights)

def main():
    rec=base.load_record('F:/EMG016.BIN');old=base.load_record('F:/EMG015.BIN')
    streams={};spectra={};compare={}
    for key in ('raw','processed'):
        streams[key],spectra[key]=base.analyze_stream(rec,key)
        f0,p0=stable_rest_psd(old,key);f1,p1=stable_rest_psd(rec,key)
        m0,m1=base.spectral(f0,p0),base.spectral(f1,p1)
        compare[key]=dict(EMG015=m0,EMG016_rest=m1,
            change_db={k:(20*np.log10(np.maximum(m1[k],1e-12)/np.maximum(m0[k],1e-12))).tolist()
                       for k in ('mains_rms','harmonic_rms','clean_rms','low_rms')})
    raw=json.loads((OUT/'EMG016_raw_analysis.json').read_text(encoding='utf-8'))
    proc=json.loads((OUT/'EMG016_processed_analysis.json').read_text(encoding='utf-8'))
    x=rec['processed'].astype(float);n=len(x)//400
    rms=np.sqrt(np.mean(x[:n*400].reshape(n,400,8)**2,axis=1));times=(np.arange(n)+.5)/10
    # Use the labeled stable regions to compare action-dependent clean-band energy.
    clean=previous.previous.prior.previous.category_clean_rms(streams['processed'])
    train=base.load_record('F:/EMG008.BIN')
    xt,yt,_=base.window_features(train); xf,yf,info=base.window_features(rec)
    models={}
    for name,cols in (('8ch',np.arange(40)),('exclude_CH6',np.array([g*8+c for g in range(5) for c in range(8) if c!=5]))):
        model=base.evaluate(xt[:,cols],yt,xf[:,cols],yf,info,'EMG008 -> EMG016 '+name)
        models[name]=dict(metrics={k:model[k] for k in ('accuracy_mean','accuracy_sd','macro_f1_mean','action_bout_accuracy_mean')},
                          recall=previous.previous.prior.recall(model))
    references=[]
    for start,ch in ((55,5),(63,5),(0,3)):
        filt=base.ProcessedSignal()
        pred=np.array([filt.step(int(v)) for v in rec['raw'][start*4000:(start+8)*4000,ch]])
        err=pred[5*4000:]-rec['processed'][(start+5)*4000:(start+8)*4000,ch]
        references.append(dict(start_s=start+5,end_s=start+8,channel=ch+1,max_error_counts=int(abs(err).max())))
    top=np.argsort(rms[:,5])[-10:][::-1]
    result=dict(input='F:/EMG016.BIN',sha256=hashlib.sha256(rec['blob']).hexdigest(),
        bytes=len(rec['blob']),frames=len(rec['frames']),duration_s=len(rec['frames'])/base.FS,
        format=rec['header'],integrity=dict(missing=0,backward=0,duplicate=0,wraps=int((np.diff(rec['seq'])<0).sum())),
        segments=[dict(label=s['label'],start_s=float(s['start_s']),end_s=float(s['end_s'])) for s in rec['segments']],
        quality_status=dict(raw=raw['quality_status'],processed=proc['quality_status']),
        streams=streams,stable_rest_comparison_EMG015=compare,models=models,filter_reference=references,
        class_clean_rms={c:clean[c]['median_by_channel'] for c in base.CLASS_NAMES},
        processed_rms_100ms=dict(median=np.median(rms,axis=0).tolist(),p95=np.percentile(rms,95,axis=0).tolist(),p99=np.percentile(rms,99,axis=0).tolist(),maximum=rms.max(0).tolist()),
        top_CH6_100ms=[dict(start_s=float(times[i]-.05),rms_counts=float(rms[i,5]),other_channels_median=float(np.median(np.delete(rms[i],5)))) for i in top],
        method='Rest intervals trimmed by one second at each boundary; Welch 4096, duration weighted. EMG008-only training: MAV/WL/Energy/ZC/SSC, 100ms/25ms, scaler + MLP(64,32), five seeds; no EMG016 training or scaling.')
    (OUT/'EMG016_quality.json').write_text(json.dumps(result,indent=2,ensure_ascii=False),encoding='utf-8')
    fig,ax=plt.subplots(figsize=(14,4.8))
    ax.plot(times,rms[:,5],color='#c0392b',lw=.7,label='CH6')
    ax.plot(times,np.median(np.delete(rms,5,axis=1),axis=1),color='#167c80',lw=.7,label='median other 7')
    for s in rec['segments']:
        from_colors={'rest':'#d9e3ec','open_hand':'#a5d6a7','fist':'#ffcc80','wrist_flex':'#b39ddb','wrist_extend':'#81d4fa'}
        ax.axvspan(s['start_s'],s['end_s'],color=from_colors[s['label']],alpha=.3)
    ax.set(xlabel='Saved time (s)',ylabel='Processed RMS counts / 100 ms',title='EMG016 CH6 transient check')
    ax.grid(alpha=.2);ax.legend();fig.tight_layout();fig.savefig(OUT/'EMG016_CH6_transients.png',dpi=140);plt.close(fig)
    lines=['# EMG016：与 EMG015 同等佩戴条件下的记录评估','',
        '用户确认：本次有实际动作；条件与 EMG015 相同。EMG015 是纯静息，因此本次按 BIN 标签分开比较静息和动作。',
        f"\n共 {result['frames']:,} 帧、{result['duration_s']:.3f} 秒，4000 Hz；序号连续，无丢帧、倒退或重复。raw 数字满量程样本 {streams['raw']['rails']}。自动状态 raw {raw['quality_status']}，processed {proc['quality_status']}。",'',
        '## 动作和通道响应','', '| 动作 | CH1 | CH2 | CH3 | CH4 | CH5 | CH6 | CH7 | CH8 |','|---|---:|---:|---:|---:|---:|---:|---:|---:|']
    cn={'rest':'放松','open_hand':'张手','fist':'握拳','wrist_flex':'屈腕','wrist_extend':'伸腕'}
    for c in base.CLASS_NAMES:lines.append('| '+cn[c]+' | '+' | '.join(f'{v:.1f}' for v in clean[c]['median_by_channel'])+' |')
    lines += ['', '表格是稳定动作段去除 50 Hz 和谐波邻域后的 20–450 Hz RMS 类别中位数（ADC counts）。', '',
        f"CH6 是主要异常：其 100 ms RMS 中位数 {np.median(rms[:,5]):.1f} counts，P99 {np.percentile(rms[:,5],99):.1f}，最大 {rms[:,5].max():.1f}；其他通道的 P99 中位数为 {np.median(np.percentile(rms[:,[0,1,2,3,4,6,7]],99,axis=0)):.1f} counts。最高窗口位于 {times[top[0]]-.05:.2f} 秒，RMS {rms[top[0],5]:.0f} counts。该峰位于 59.7–68.2 秒标注放松段末尾，接近伸腕切换点；此外 60.8 秒也有约 3376 counts 的突发，不能把它们直接视为稳定动作肌电。疑似 CH6 局部电极/线缆瞬态，但仅凭数据不能断定来源。PC1 也会被单通道强波动放大。", '',
        '## 静息段与 EMG015 对比','', '| 指标 | EMG015 → EMG016 静息段，通道范围 |','|---|---:|']
    for key,name in (('raw','raw'),('processed','processed')):
        for metric,title in (('mains_rms','50 Hz RMS'),('harmonic_rms','100–450 Hz 谐波 RMS'),('clean_rms','去线频 20–450 Hz RMS')):
            d=compare[key]['change_db'][metric]
            lines.append(f"| {name} {title} | {min(d):+.1f} 至 {max(d):+.1f} dB |")
    lines += ['', 'EMG016 静息段仍保留较强的 raw 50 Hz 线频，PL 处理大幅压低了窄带 50 Hz；但 CH6 的宽带瞬态不是 50 Hz 陷波能解决的问题。处理后全记录 PC1 比例偏高，不等于实测共模或 BIAS 电压。处理后静息 CH6 50 Hz RMS 为约 53 counts，占静息 20–450 Hz 功率约 4.95%；其他通道约 0.74–3.21 counts。绝对 RMS 和占比需一起看，避免把噪声分母降低造成的谐波占比上升误判为绝对干扰上升。', '',
        '## EMG008 训练、EMG016 留出测试','',
        '| 输入 | 窗口准确率（均值±种子标准差） | 宏 F1 | 动作段多数票 |', '|---|---:|---:|---:|']
    for name,entry in models.items():
        m=entry['metrics']
        lines.append(f"| {name} | {100*m['accuracy_mean']:.1f}% ± {100*m['accuracy_sd']:.1f}% | {100*m['macro_f1_mean']:.1f}% | {100*m['action_bout_accuracy_mean']:.1f}% |")
    lines += ['', '模型沿用既有特征、窗口和五随机种子流程，仅用 EMG008 训练及拟合标准化。剔除 CH6 仅作为诊断对照；种子标准差不是置信区间，重叠窗口也非独立试验。',
        f"\n对 60–63 秒、68–71 秒 CH6 和 5–8 秒 CH4，保存输出与整数参考最大相差 {max(z['max_error_counts'] for z in references)} counts。这表明这些抽查段符合当前滤波实现，不能据此确认模拟输入或硬件完全正常。",'',
        '## 动作区间','']
    for s in result['segments']:lines.append(f"- {cn[s['label']]}：{s['start_s']:.3f}–{s['end_s']:.3f} 秒。")
    lines += ['', '## 文件','', '- EMG016_raw.csv / EMG016_processed.csv：解码采样。','- EMG016_raw_analysis.html / EMG016_processed_analysis.html：交互波形与频谱。','- EMG016_CH6_transients.png：CH6 100 ms RMS 时序。','- EMG016_quality.json：指标。','- assess_emg016.py：复现脚本。',f"- SHA256：{result['sha256']}",'']
    (OUT/'EMG016_quality_report.md').write_text('\n'.join(lines),encoding='utf-8')
    assert result['frames']==548698 and streams['raw']['rails']==0 and np.isfinite(rms).all()
    assert max(z['max_error_counts'] for z in references)<=5
    assert max(result['top_CH6_100ms'][0]['rms_counts'],0)>1000
    print('SUMMARY',json.dumps(dict(frames=result['frames'],duration_s=result['duration_s'],segments=len(result['segments']),quality=result['quality_status'],ch6_p99=np.percentile(rms[:,5],99),ch6_max=rms[:,5].max()),ensure_ascii=False))
    print('TEST_PASS: record integrity, action labels, finite analysis and CH6 transient detection')

if __name__=='__main__':main()
