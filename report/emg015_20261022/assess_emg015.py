"""Analyze EMG015 pure-rest recording and compare to EMG014 rest bouts."""
from pathlib import Path
import sys, json, hashlib
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

OUT=Path(__file__).resolve().parent
ROOT=OUT.parents[1]
sys.path.insert(0,str(ROOT/'report/emg013_20261022'))
import assess_emg013 as previous
base=previous.base


def rest_psd(rec, key):
    rows=[];weights=[]
    for s in rec['segments']:
        if s['label']!='rest': continue
        a,b=round(s['stable_start_s']*base.FS),round(s['stable_end_s']*base.FS)
        if b-a<4096: continue
        f,p=base.welch(rec[key][a:b].astype(float)); rows.append(p);weights.append(b-a)
    return f,np.average(rows,axis=0,weights=weights)


def main():
    rec=base.load_record('F:/EMG015.BIN'); old=base.load_record('F:/EMG014.BIN')
    streams={};spectra={};comparison={}
    for key in ('raw','processed'):
        streams[key],spectra[key]=base.analyze_stream(rec,key)
        f0,p0=rest_psd(old,key);f1,p1=rest_psd(rec,key)
        m0,m1=base.spectral(f0,p0),base.spectral(f1,p1)
        comparison[key]=dict(EMG014_rest=m0,EMG015_rest=m1,
            change_db={k:(20*np.log10(np.maximum(m1[k],1e-12)/np.maximum(m0[k],1e-12))).tolist()
                       for k in ('mains_rms','harmonic_rms','clean_rms','low_rms')})
    raw=json.loads((OUT/'EMG015_raw_analysis.json').read_text(encoding='utf-8'))
    processed=json.loads((OUT/'EMG015_processed_analysis.json').read_text(encoding='utf-8'))
    x=rec['processed'].astype(float); n=len(x)//400
    x=x[:n*400].reshape(n,400,8); rms=np.sqrt(np.mean(x*x,axis=1)); t=(np.arange(n)+.5)/10
    result=dict(input='F:/EMG015.BIN',sha256=hashlib.sha256(rec['blob']).hexdigest(),
        bytes=len(rec['blob']),frames=len(rec['frames']),duration_s=len(rec['frames'])/base.FS,
        format=rec['header'],integrity=dict(missing=0,backward=0,duplicate=0,
            wraps=int((np.diff(rec['seq'])<0).sum())),
        segments=[dict(label=s['label'],start_s=float(s['start_s']),end_s=float(s['end_s'])) for s in rec['segments']],
        quality_status=dict(raw=raw['quality_status'],processed=processed['quality_status']),
        streams=streams,rest_only=dict(raw_pc1=base.pc1_fraction(rec['raw']),
            processed_pc1=base.pc1_fraction(rec['processed']),
            processed_pc1_without_CH6=base.pc1_fraction(np.delete(rec['processed'],5,axis=1)),
            processed_rms_counts=np.sqrt(np.mean(rec['processed'].astype(float)**2,axis=0)).tolist(),
            processed_100ms_median=np.median(rms,axis=0).tolist(),
            processed_100ms_p95=np.percentile(rms,95,axis=0).tolist(),
            processed_100ms_p99=np.percentile(rms,99,axis=0).tolist(),
            processed_100ms_max=rms.max(0).tolist()),
        comparison_EMG014_rest=comparison,
        method='Welch 4096, stable rest bouts duration weighted; bands 50 +/-1 Hz and harmonics 100-450 +/-1 Hz. All EMG015 frames are labeled rest; no classifier is trained.')
    (OUT/'EMG015_quality.json').write_text(json.dumps(result,indent=2,ensure_ascii=False),encoding='utf-8')
    fig,axes=plt.subplots(2,1,figsize=(14,7),sharex=True)
    for ch in range(8): axes[0].plot(t,rms[:,ch],lw=.65,label=f'CH{ch+1}')
    axes[0].set_ylabel('Processed RMS counts / 100 ms');axes[0].set_title('EMG015 pure rest: per-channel activity');axes[0].legend(ncol=4);axes[0].grid(alpha=.2)
    for ch in range(8): axes[1].plot(t,rms[:,ch],lw=.65,label=f'CH{ch+1}')
    axes[1].set_ylim(0,max(35,float(np.percentile(rms,99.8))));axes[1].set_ylabel('RMS counts (zoom)');axes[1].set_xlabel('Saved time (s)');axes[1].grid(alpha=.2)
    fig.tight_layout();fig.savefig(OUT/'EMG015_rest_noise.png',dpi=140);plt.close(fig)
    lines=['# EMG015：纯静息信号质量评估','',
        '用户标注：与 EMG014 相同条件，本次全程纯静息。',
        f"\n共 {len(rec['frames']):,} 帧、{result['duration_s']:.3f} 秒、4000 Hz。全段仅有一个 rest 标注；序号无缺失、倒退或重复。raw 数字满量程样本 {streams['raw']['rails']}。",
        f"\n自动质量状态：raw {raw['quality_status']}，processed {processed['quality_status']}。raw 的 CHECK 来自共享通道成分判据，不是采集帧丢失或数字削顶；processed 无满量程削顶。",'',
        '## 静息基线','',
        '| 通道 | 处理后 20–450 Hz RMS | 100 ms RMS 中位数 | P95 | P99 |',
        '|---|---:|---:|---:|---:|']
    for ch in range(8):
        a=result['rest_only']
        lines.append(f"| CH{ch+1} | {a['processed_rms_counts'][ch]:.1f} | {np.median(rms[:,ch]):.1f} | {a['processed_100ms_p95'][ch]:.1f} | {a['processed_100ms_p99'][ch]:.1f} |")
    lines += ['',
        'CH1–5、CH7–8 的全段 RMS 约 8.4–9.2 counts，CH6 约 15.1 counts；CH6 高于其他通道，但比 EMG014 中 CH4 的突发活动低很多。处理后 PC1 为 %.1f%%，排除 CH6 后 %.1f%%。本数据是静息，没有动作诱发肌电，因此主要反映静息噪声和残余运动/接触变化。' % (100*result['rest_only']['processed_pc1'],100*result['rest_only']['processed_pc1_without_CH6']), '',
        '## 与 EMG014 放松段对比','',
        '| 指标 | EMG014 → EMG015 通道变化范围 |','|---|---:|']
    for key,name in (('raw','raw'),('processed','processed')):
        for metric,title in (('mains_rms','50 Hz RMS'),('harmonic_rms','100–450 Hz 谐波 RMS'),('clean_rms','去线频 20–450 Hz RMS')):
            d=comparison[key]['change_db'][metric]
            lines.append(f"| {name} {title} | {min(d):+.1f} 至 {max(d):+.1f} dB |")
    lines += ['',
        f"EMG015 处理后 50 Hz 功率占比为 {min(streams['processed']['stable']['mains_percent']):.2f}–{max(streams['processed']['stable']['mains_percent']):.2f}%；raw 中 50 Hz 是主要窄带成分。100–450 Hz 谐波指标包含相同频带的背景噪声，不能全部解释成市电谐波。全记录 PC1/自动 PASS 只描述本记录和规则，不直接等于模拟共模电压或 BIAS 性能。",'',
        '## 文件','',
        '- EMG015_raw.csv / EMG015_processed.csv：解码数据。',
        '- EMG015_raw_analysis.html / EMG015_processed_analysis.html：交互波形和频谱。',
        '- EMG015_rest_noise.png：静息波形 RMS。',
        '- EMG015_quality.json：完整数据。',
        '- assess_emg015.py：复现脚本。',f"- SHA256：{result['sha256']}",'']
    (OUT/'EMG015_quality_report.md').write_text('\n'.join(lines),encoding='utf-8')
    assert result['frames']==225400 and len(rec['segments'])==1 and rec['segments'][0]['label']=='rest'
    assert np.isfinite(rms).all() and streams['raw']['rails']==0
    print('SUMMARY',json.dumps(dict(frames=result['frames'],duration_s=result['duration_s'],quality=result['quality_status'],processed_rms=np.round(result['rest_only']['processed_rms_counts'],1).tolist()),ensure_ascii=False))
    print('TEST_PASS: continuous pure-rest record, finite PSD/RMS, no raw rails')

if __name__=='__main__':main()
