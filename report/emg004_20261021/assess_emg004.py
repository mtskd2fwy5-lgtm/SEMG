"""Reproduce EMG004 quality metrics; ADC counts, no assumed voltage scaling."""
from pathlib import Path
import hashlib
import json
import sys
import numpy as np
import pandas as pd
from scipy import signal
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))
from tools.analyze_capture import load_capture, build_report, html_report

OUT = Path(__file__).resolve().parent
FS = 4000
raw_frame = pd.read_csv(OUT / 'EMG004_raw.csv')
raw = raw_frame[[f'channel_{i}' for i in range(8)]].to_numpy(float)
notch = pd.read_csv(OUT / 'EMG004_notch50.csv')[[f'channel_{i}' for i in range(8)]].to_numpy(float)
labels = raw_frame.action.to_numpy()
edges = np.r_[0, np.flatnonzero(labels[1:] != labels[:-1]) + 1, len(labels)]
segments = []
for a, b in zip(edges[:-1], edges[1:]):
    segments.append(dict(label=str(labels[a]), start_s=a/FS, end_s=b/FS,
                         stable_start_s=a/FS+1, stable_end_s=b/FS-1))

def psd(x):
    return signal.welch(x, fs=FS, nperseg=8192, noverlap=4096,
                        detrend='linear', axis=0)

def spectral_stats(f, p):
    df = f[1]-f[0]
    band = (f>=20)&(f<=450)
    mains = abs(f-50)<=1
    harmonics = np.zeros(len(f), bool)
    per = {}
    total = p[band].sum(axis=0)*df
    for hz in range(100,451,50):
        m=(abs(f-hz)<=1)&band
        harmonics |= m
        per[str(hz)] = (100*p[m].sum(axis=0)*df/total).tolist()
    clean = band & ~(mains|harmonics)
    broad = (f>=0.5)&(f<=450)
    low = (f>=0.5)&(f<20)
    return dict(rms_20_450=np.sqrt(total).tolist(),
                rms_excluding_line_bands=np.sqrt(p[clean].sum(axis=0)*df).tolist(),
                mains_percent=(100*p[mains].sum(axis=0)*df/total).tolist(),
                harmonics_100_to_450_percent=(100*p[harmonics].sum(axis=0)*df/total).tolist(),
                harmonic_percent_by_frequency=per,
                low_frequency_percent=(100*p[low].sum(axis=0)/p[broad].sum(axis=0)).tolist())

results = {}
spectra = {}
for name, x in [('raw',raw),('notch50',notch)]:
    weighted = []
    weights = []
    rows=[]
    for s in segments:
        a,b=int(s['stable_start_s']*FS),int(s['stable_end_s']*FS)
        f,p=psd(x[a:b])
        weighted.append(p); weights.append(b-a)
        rows.append({**s, **spectral_stats(f,p)})
    p=np.average(weighted, axis=0, weights=weights)
    spectra[name]=(f,p)
    results[name]=dict(stable=spectral_stats(f,p),segments=rows,
                      min=x.min(axis=0).tolist(),max=x.max(axis=0).tolist(),
                      rail_count=(((x<=-8388608)|(x>=8388607)).sum(axis=0)).tolist(),
                      max_abs_fraction_full_scale=(np.max(abs(x),axis=0)/8388608).tolist(),
                      median=np.median(x,axis=0).tolist())

# Compare each action to the immediately preceding rest segment. These are
# activity/rest power ratios, not physiological SNR or classifier accuracy.
comparisons=[]
for i,s in enumerate(segments):
    if s['label']=='rest': continue
    previous=max(j for j in range(i) if segments[j]['label']=='rest')
    active=np.array(results['notch50']['segments'][i]['rms_excluding_line_bands'])
    rest=np.array(results['notch50']['segments'][previous]['rms_excluding_line_bands'])
    comparisons.append(dict(label=s['label'],start_s=s['start_s'],
                            preceding_rest_start_s=segments[previous]['start_s'],
                            rms_ratio=(active/rest).tolist(),
                            power_ratio_db=(20*np.log10(active/rest)).tolist()))

bp=signal.butter(4,[20,450],fs=FS,btype='bandpass',output='sos')
filtered=signal.sosfiltfilt(bp,notch,axis=0)
burst_metrics=[]
for s in segments:
    a,b=int(s['stable_start_s']*FS),int(s['stable_end_s']*FS)
    x=filtered[a:b]; n=len(x)//400
    rms=np.sqrt(np.mean(x[:n*400].reshape(n,400,8)**2,axis=1))
    k=max(1,int(np.ceil(n*.1)))
    burst_metrics.append({**s,'median_100ms_rms':np.median(rms,axis=0).tolist(),
                          'p95_100ms_rms':np.percentile(rms,95,axis=0).tolist(),
                          'top10percent_windows_power_share':(np.sort(rms*rms,axis=0)[-k:].sum(axis=0)/(rms*rms).sum(axis=0)).tolist()})
def spatial(x):
    ev=np.linalg.eigvalsh(np.cov(x,rowvar=False))
    corr=np.corrcoef(x.T)
    return dict(pc1_fraction=float(ev[-1]/ev.sum()),
                median_abs_pairwise_correlation=float(np.median(abs(corr[np.triu_indices(8,1)]))),
                correlation=corr.tolist())
spatial_info=dict(raw=spatial(raw),notch50_bandpass_20_450=spatial(filtered))
f,pr=spectra['raw']; _,pn=spectra['notch50']
m=abs(f-50)<=1
attenuation=10*np.log10(pr[m].sum(axis=0)/pn[m].sum(axis=0))
summary=dict(input='F:/EMG004.BIN',sha256=hashlib.sha256(Path('F:/EMG004.BIN').read_bytes()).hexdigest(),
             frames=len(raw),duration_s=len(raw)/FS,sample_rate_hz=FS,
             channel_placement={'CH1-CH6':'wrist','CH7-CH8':'near elbow','all':'skin EMG electrodes; no BIAS monitor channel'},
             methods={'trim_each_segment_s':1,'welch_nperseg':8192,'df_hz':FS/8192,
                      'line_half_width_hz':1,'harmonics_hz':list(range(100,451,50)),
                      'low_frequency_band_hz':[0.5,20],
                      'aggregation':'duration-weighted stable-segment PSD; linear detrend per Welch window',
                      'important':'PCA/correlation are shared differential signal metrics, not input common-mode voltage; no voltage conversion without gain/reference readback'},
             streams=results,action_vs_preceding_rest=comparisons,spatial=spatial_info,
             burst_metrics=burst_metrics,
             notch_50hz_attenuation_db=attenuation.tolist())
(OUT/'EMG004_quality.json').write_text(json.dumps(summary,indent=2),encoding='utf-8')

# Give existing dashboards explicit source metadata; retain their generic
# automated verdict separately from this action-aware quality assessment.
for name in ['raw','notch50']:
    path=OUT/f'EMG004_{name}.csv'
    path.with_suffix('.json').write_text(json.dumps(dict(signal=name,sample_rate_hz=FS,
        channel_placement=summary['channel_placement'],sequence_gaps=0)),encoding='utf-8')
    path,t,x,l,meta,fs=load_capture(path)
    report=build_report(path,t,x,l,meta,fs)
    report['notes'].insert(0,'Generic PASS does not certify EMG quality: see EMG004_quality_report.md for drift, all 50 Hz harmonics, and action/rest assessment. All eight channels are skin EMG in this recording.')
    (OUT/f'EMG004_{name}_analysis.html').write_text(html_report(report),encoding='utf-8')
    (OUT/f'EMG004_{name}_analysis.json').write_text(json.dumps(report,indent=2),encoding='utf-8')

colors={'rest':'#d9e3ec','open_hand':'#a5d6a7','fist':'#ffcc80','wrist_flex':'#b39ddb','wrist_extend':'#81d4fa'}
fig,axes=plt.subplots(8,2,figsize=(17,15),sharex=True)
times=np.arange(len(raw))/FS
step=400
blocks=len(raw)//step
env=np.sqrt(np.mean(filtered[:blocks*step].reshape(blocks,step,8)**2,axis=1))
for ch in range(8):
    ax=axes[ch,0]
    ax.plot(times[::100],raw[::100,ch]/1000,lw=.6,color='#255da8')
    ax.set_ylabel(f'CH{ch+1}\nkcount')
    axes[ch,1].plot((np.arange(blocks)+.5)*step/FS,env[:,ch],lw=.9,color='#255da8')
    for a in axes[ch]:
        for s in segments:
            a.axvspan(s['start_s'],s['end_s'],color=colors[s['label']],alpha=.3)
        a.grid(alpha=.2)
axes[0,0].set_title('RAW baseline trajectory (decimated; not peak-preserving)')
axes[0,1].set_title('Recorded notch50 + offline 20-450 Hz: 100 ms RMS (count)')
from matplotlib.patches import Patch
fig.legend(handles=[Patch(facecolor=c,alpha=.5,label=l) for l,c in colors.items()],
           loc='upper center',ncol=5,frameon=False)
for a in axes[-1]: a.set_xlabel('Time (s)')
fig.tight_layout(rect=(0,0,1,.97));fig.savefig(OUT/'EMG004_waveform_quality.png',dpi=130);plt.close(fig)

fig,axes=plt.subplots(4,2,figsize=(15,13),sharex=True)
for ch,ax in enumerate(axes.flat):
    for name,(f,p) in spectra.items():
        m=(f>=20)&(f<=450)
        ax.plot(f[m],10*np.log10(np.maximum(p[m,ch],1e-12)),label=name,lw=.8)
    for hz in range(50,451,50): ax.axvline(hz,color='gray',alpha=.25,lw=.6)
    ax.set_title(f'CH{ch+1}');ax.set_ylabel('PSD (dB count^2/Hz)');ax.grid(alpha=.2)
axes[0,0].legend();axes[-1,0].set_xlabel('Hz');axes[-1,1].set_xlabel('Hz')
fig.suptitle('Stable segments: RAW versus recorded notch50 (absolute PSD, identical per-channel axes)')
fig.tight_layout();fig.savefig(OUT/'EMG004_spectrum_quality.png',dpi=130);plt.close(fig)

print('RAW STABLE',json.dumps(results['raw']['stable']))
print('NOTCH STABLE',json.dumps(results['notch50']['stable']))
print('ATTENUATION DB',attenuation.round(2))
print('ACTION RATIOS',json.dumps(comparisons))
print('SPATIAL',json.dumps({k:{a:b for a,b in v.items() if a!='correlation'} for k,v in spatial_info.items()}))
for i,s in enumerate(segments):
    print('SEGMENT',round(s['start_s'],2),s['label'],'clean_rms',np.round(results['notch50']['segments'][i]['rms_excluding_line_bands'],1).tolist(),
          'raw50%',np.round(results['raw']['segments'][i]['mains_percent'],1).tolist())
