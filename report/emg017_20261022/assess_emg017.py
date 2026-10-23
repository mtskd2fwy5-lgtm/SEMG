"""EMG017 quality assessment using the locally decoded, paired CSV streams.

The SD drive may be removed after decoding; source CSV hashes and decoder
integrity metadata are retained. No source BIN hash is claimed in that case.
"""
from pathlib import Path
import sys, json, hashlib
import numpy as np
import pandas as pd
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

OUT=Path(__file__).resolve().parent
ROOT=OUT.parents[1]
sys.path.insert(0,str(ROOT/'report/emg016_20261022'))
import assess_emg016 as previous
base=previous.base
FS=base.FS
CN=dict(zip(base.CLASS_NAMES,['放松','张手','握拳','屈腕','伸腕']))


def load_local(number, processed_only=False):
    folder=ROOT/f'report/emg{number}_20261022'
    cols=[f'channel_{i}' for i in range(8)]
    data=pd.read_csv(folder/f'EMG{number}_processed.csv')
    labels=data['action'].to_numpy()
    seq=data['sequence'].to_numpy(dtype=np.int64)
    assert np.all(np.diff(seq)%65536==1)
    assert np.all(np.diff(data['timestamp_us'].to_numpy())==250)
    meta=json.loads((folder/f'EMG{number}_decode.json').read_text(encoding='utf-8'))
    assert len(data)==meta['frames'] and not any(meta[k] for k in ('sequence_gaps','sequence_backwards','sequence_duplicates'))
    assert set(labels)<=set(CN)
    edges=np.r_[0,np.flatnonzero(labels[1:]!=labels[:-1])+1,len(labels)]
    segments=[dict(label=str(labels[a]),code=base.CLASS_NAMES.index(labels[a])+1,
        start_s=float(a/FS),end_s=float(b/FS),stable_start_s=float(a/FS+1),
        stable_end_s=float(b/FS-1),first=int(a),last=int(b)) for a,b in zip(edges[:-1],edges[1:])]
    rec=dict(frames=np.empty((len(data),0)),seq=seq,segments=segments,
             processed=data[cols].to_numpy(dtype=np.int32),raw=None,metadata=meta)
    if not processed_only:
        raw=pd.read_csv(folder/f'EMG{number}_raw.csv')
        assert np.array_equal(raw['sequence'],seq) and np.array_equal(raw['action'],labels)
        assert np.array_equal(raw['timestamp_us'],data['timestamp_us'])
        rec['raw']=raw[cols].to_numpy(dtype=np.int32)
    return rec


def main():
    rec=load_local('017')
    prior16=json.loads((ROOT/'report/emg016_20261022/EMG016_quality.json').read_text(encoding='utf-8'))
    prior15=json.loads((ROOT/'report/emg015_20261022/EMG015_quality.json').read_text(encoding='utf-8'))
    streams={};spectra={};rest={};comparison={}
    for key in ('raw','processed'):
        streams[key],spectra[key]=base.analyze_stream(rec,key)
        f,p=previous.stable_rest_psd(rec,key)
        rest[key]=base.spectral(f,p)
        comparison[key]={}
        for name,old in (('EMG016',prior16['stable_rest_comparison_EMG015'][key]['EMG016_rest']),
                         ('EMG015',prior15['streams'][key]['stable'])):
            comparison[key][name]={metric:(20*np.log10(np.maximum(rest[key][metric],1e-12)/np.maximum(old[metric],1e-12))).tolist()
                for metric in ('mains_rms','harmonic_rms','clean_rms','low_rms')}
    category=previous.previous.previous.prior.previous.category_clean_rms(streams['processed'])
    n=len(rec['frames'])//400
    rms=np.sqrt((rec['processed'][:n*400].astype(float).reshape(n,400,8)**2).mean(1))
    times=(np.arange(n)+.5)/10
    rest_index=np.concatenate([np.arange(round(s['stable_start_s']*FS),round(s['stable_end_s']*FS))
        for s in rec['segments'] if s['label']=='rest' and s['stable_end_s']>s['stable_start_s']])
    models={}
    train=load_local('008',processed_only=True)
    xt,yt,_=base.window_features(train);xf,yf,info=base.window_features(rec)
    for name,cols in (('8ch',np.arange(40)),('exclude_CH6',np.array([g*8+c for g in range(5) for c in range(8) if c!=5]))):
        model=base.evaluate(xt[:,cols],yt,xf[:,cols],yf,info,'EMG008 -> EMG017 '+name)
        models[name]=dict(metrics={k:model[k] for k in ('accuracy_mean','accuracy_sd','macro_f1_mean','action_bout_accuracy_mean')},
            recall=previous.previous.previous.prior.recall(model))
    # Check final PL chain around the largest CH1 and CH6 events.
    references=[]
    for ch in (0,5):
        peak_s=float(np.argmax(rms[:,ch])/10)
        start=max(0,int(peak_s)-5)
        stop=min(start+8,int(len(rec['frames'])/FS))
        filt=base.ProcessedSignal()
        pred=np.array([filt.step(int(x)) for x in rec['raw'][start*FS:stop*FS,ch]])
        err=pred[5*FS:]-rec['processed'][(start+5)*FS:stop*FS,ch]
        references.append(dict(channel=ch+1,start_s=start+5,end_s=stop,max_error_counts=int(abs(err).max())))
    page={k:json.loads((OUT/f'EMG017_{k}_analysis.json').read_text(encoding='utf-8')) for k in streams}
    top={f'CH{ch+1}':[dict(start_s=float(i/10),rms_counts=float(rms[i,ch]))
                      for i in np.argsort(rms[:,ch])[-5:][::-1]] for ch in (0,3,5)}
    result=dict(input='F:/EMG017.BIN',analysis_source='Locally decoded paired CSVs; F: became unavailable after decode. Source BIN hash unavailable.',
        frames=len(rec['frames']),duration_s=len(rec['frames'])/FS,decoder=rec['metadata'],
        source_csv_sha256={k:hashlib.sha256((OUT/f'EMG017_{k}.csv').read_bytes()).hexdigest() for k in streams},
        segments=rec['segments'],quality_status={k:page[k]['quality_status'] for k in streams},
        streams=streams,stable_rest=rest,stable_rest_comparison_db=comparison,
        class_clean_rms={k:category[k]['median_by_channel'] for k in base.CLASS_NAMES},
        processed_pc1=dict(full=base.pc1_fraction(rec['processed']),stable_rest=base.pc1_fraction(rec['processed'][rest_index])),
        rms_100ms=dict(median=np.median(rms,0).tolist(),p99=np.percentile(rms,99,axis=0).tolist(),maximum=rms.max(0).tolist()),
        top_windows=top,models=models,filter_reference=references,
        method='Stable bouts trim 1s each end; duration weighted Welch 4096, linear detrend; 50 +/-1 Hz, harmonics every 50 Hz from 100-450 +/-1 Hz. Transfer uses EMG008 only, five seeds, same 100ms/25ms MAV/WL/Energy/ZC/SSC and scaler+MLP(64,32).')
    assert all(x['max_error_counts']<=5 for x in references), references
    assert len(rec['frames'])==1098578 and not streams['raw']['rails'] and not streams['processed']['rails']
    (OUT/'EMG017_quality.json').write_text(json.dumps(result,indent=2,ensure_ascii=False,allow_nan=False),encoding='utf-8')
    fig,axes=plt.subplots(8,2,figsize=(16,15))
    for ch in range(8):
        ax=axes[ch,0];ax.plot(times,rms[:,ch],lw=.65,color='#177c83')
        for s in rec['segments']:ax.axvspan(s['start_s'],s['end_s'],color=base.COLORS[s['label']],alpha=.25)
        ax.set_ylabel(f'CH{ch+1} RMS');ax.grid(alpha=.2)
        ax=axes[ch,1]
        for key,color in (('raw','#b46d35'),('processed','#177c83')):
            f,p=spectra[key];mask=(f>=20)&(f<=450)
            ax.plot(f[mask],10*np.log10(np.maximum(p[mask,ch],1e-12)),lw=.7,color=color,label=key)
        ax.set_ylabel('dB counts²/Hz');ax.grid(alpha=.2)
    axes[0,0].set_title('EMG017 processed RMS / 100 ms');axes[0,1].set_title('Stable labeled bouts PSD');axes[0,1].legend()
    axes[-1,0].set_xlabel('Saved time (s)');axes[-1,1].set_xlabel('Hz')
    fig.tight_layout();fig.savefig(OUT/'EMG017_quality_overview.png',dpi=130);plt.close(fig)
    lines=['# EMG017：同等条件下信号质量评估','',
        '用户说明：与 EMG016 同等条件。按文件标注分开统计放松、张手、握拳、屈腕和伸腕。','',
        f"共 {result['frames']:,} 帧、{result['duration_s']:.4f} 秒、4000 Hz；序号连续，无缺帧、倒退或重复，无 raw/processed 数字满量程削顶。raw 峰值为数字量程的 {100*streams['raw']['max_fraction']:.1f}%。自动状态 raw/processed 均为 PASS；自动 PASS 不能排除短时伪迹或残余工频。",'',
        '## 相对 EMG016','',
        '| 指标 | EMG016 | EMG017 |','|---|---:|---:|',
        f"| CH6 100 ms RMS 最大值 | {prior16['processed_rms_100ms']['maximum'][5]:.1f} | {rms[:,5].max():.1f} |",
        f"| CH6 100 ms RMS P99 | {prior16['processed_rms_100ms']['p99'][5]:.1f} | {np.percentile(rms[:,5],99):.1f} |",
        f"| 全记录处理后 PC1 | 92.4% | {100*result['processed_pc1']['full']:.1f}% |",'',
        'PC1 是通道方差中第一主成分的占比；通道尺度和单路异常都会影响它，不是直接测得的共模电压。两次动作顺序和时长不同，因此总体 P99/PC1 只作补充比较。', '',
        '## 同类静息段对比','',
        '| 信号/指标 | 对 EMG016 变化 dB，CH1–8 范围 | 对 EMG015 变化 dB，CH1–8 范围 |', '|---|---:|---:|']
    for key in streams:
        for metric,label in (('mains_rms','50 Hz RMS'),('harmonic_rms','谐波 RMS'),('clean_rms','去线频宽带 RMS')):
            a=comparison[key]['EMG016'][metric];b=comparison[key]['EMG015'][metric]
            lines.append(f'| {key} {label} | {min(a):+.1f} 至 {max(a):+.1f} | {min(b):+.1f} 至 {max(b):+.1f} |')
    lines+=['','静息按所有放松段首尾各去 1 秒，分段 Welch 后按时长加权。不同放松段的时间和上下文仍有差异；谐波频带也含生理/背景功率，不能全部算作工频。','',
        '## 本次动作响应','', '| 动作 | CH1 | CH2 | CH3 | CH4 | CH5 | CH6 | CH7 | CH8 |','|---|---:|---:|---:|---:|---:|---:|---:|---:|']
    for c in base.CLASS_NAMES:lines.append('| '+CN[c]+' | '+' | '.join(f'{x:.1f}' for x in result['class_clean_rms'][c])+' |')
    lines+=['','指标为去线频 20–450 Hz RMS 的动作段中位数，单位 counts，仍可能含伪迹。', '',
        '## 突发复核','',
        f"CH6 最大突发约 {top['CH6'][0]['start_s']:.1f} 秒、{top['CH6'][0]['rms_counts']:.0f} counts，明显低于 EMG016，但尚未消失。CH1 约 {top['CH1'][0]['start_s']:.1f} 秒出现 {top['CH1'][0]['rms_counts']:.0f} counts 的突发，位于握拳段末尾；约 93.1 秒也有尖峰，需回看原始波形，不能直接视为稳定肌电。",'',
        f"CH1、CH6 峰值附近保存输出与现有 PL 整数参考最大误差 {max(x['max_error_counts'] for x in references)} counts；只说明抽查段与当前参考实现一致。",'',
        '## EMG008 训练、EMG017 留出测试','', '| 输入通道 | 窗口准确率（均值±种子标准差） | 宏 F1 | 动作段多数票 |','|---|---:|---:|---:|']
    for name,entry in models.items():
        m=entry['metrics'];lines.append(f"| {name} | {100*m['accuracy_mean']:.1f}% ± {100*m['accuracy_sd']:.1f}% | {100*m['macro_f1_mean']:.1f}% | {100*m['action_bout_accuracy_mean']:.1f}% |")
    lines+=['','仅用 EMG008 的本地解码数据重新训练，EMG017 未用于训练/标准化；剔除 CH6 是诊断对照，不能由准确率单独诊断通道故障。种子标准差不是置信区间。','',
        '| 动作 | 8ch 召回率 | 排除 CH6 召回率 |', '|---|---:|---:|']
    for c in base.CLASS_NAMES:lines.append(f"| {CN[c]} | {100*models['8ch']['recall'][c]:.1f}% | {100*models['exclude_CH6']['recall'][c]:.1f}% |")
    lines+=['','## 动作区间','']
    for s in rec['segments']:lines.append(f"- {CN[s['label']]}：{s['start_s']:.3f}–{s['end_s']:.3f} 秒。")
    lines+=['','## 复现与来源','', 'F 盘在成功解码和生成交互报告后不可访问。后续计算使用完整本地 raw/processed CSV，校验两路序号、时间、标注一致；未获得源 BIN 的 SHA256，不作虚构。', '',
        '本目录 assess_emg017.py 可在移除 SD 卡后复现。EMG017_quality.json 保存 CSV SHA256、解码完整性、指标和模型结果；EMG017_quality_overview.png 为时序与频谱总览。','']
    (OUT/'EMG017_quality_report.md').write_text('\n'.join(lines),encoding='utf-8')
    print(json.dumps(dict(duration_s=result['duration_s'],comparison=comparison,models=models,filter_reference=references),ensure_ascii=False))
    print('TEST_PASS: paired CSV sequence/time/label checks; no digital rails; finite metrics; reference error <=5 counts')


if __name__=='__main__':main()
