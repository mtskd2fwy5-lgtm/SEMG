"""Reproduce EMG006 quality analysis without changing the source recording."""
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
OUT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT / 'tools'))
from emg_reference import Notch50

SOURCE = Path('F:/EMG006.BIN')
binary = SOURCE.read_bytes()
frames = np.frombuffer(binary[512:], np.uint8).reshape(-1, 52)
FS = int.from_bytes(binary[12:16], 'little')
assert FS == 4000 and len(frames) == 690150
seq = frames[:, 0].astype(np.int64) + 256*frames[:, 1].astype(np.int64)
delta = np.diff(seq) % 65536
back = np.flatnonzero(delta >= 32768) + 1
labels = frames[:, 2]
names = {1:'rest', 2:'open_hand', 3:'fist', 4:'wrist_flex', 5:'wrist_extend'}
assert set(np.unique(labels)) <= set(names)

def decode(offset):
    b = frames[:, offset:offset+24].reshape(-1, 8, 3).astype(np.int32)
    x = b[:, :, 0] + (b[:, :, 1] << 8) + (b[:, :, 2] << 16)
    return ((x ^ 0x800000)-0x800000).astype(float)

streams = {'raw':decode(4), 'notch50':decode(28)}
edges = np.r_[0, np.flatnonzero(labels[1:] != labels[:-1])+1, len(labels)]
segments = [dict(label=names[int(labels[a])], start_s=a/FS, end_s=b/FS,
                 stable_start_s=a/FS+1, stable_end_s=b/FS-1)
            for a,b in zip(edges[:-1], edges[1:])]

def psd(x):
    assert len(x) >= 8192
    return signal.welch(x, fs=FS, nperseg=8192, noverlap=4096,
                        detrend='linear', axis=0)

def spectral_stats(f,p):
    df = f[1]-f[0]
    band = (f>=20)&(f<=450)
    line = abs(f-50)<=1
    harmonic = np.zeros(len(f), bool)
    per = {}
    total = p[band].sum(axis=0)*df
    assert np.all(total > 0)
    for hz in range(100,451,50):
        mask=(abs(f-hz)<=1)&band
        harmonic |= mask
        per[str(hz)]=(100*p[mask].sum(axis=0)*df/total).tolist()
    clean = band & ~(line|harmonic)
    low = (f>=0.5)&(f<20)
    broad = (f>=0.5)&(f<=450)
    return dict(rms_20_450=np.sqrt(total).tolist(),
                rms_excluding_line_bands=np.sqrt(p[clean].sum(axis=0)*df).tolist(),
                mains_rms=np.sqrt(p[line].sum(axis=0)*df).tolist(),
                harmonic_neighborhood_rms=np.sqrt(p[harmonic].sum(axis=0)*df).tolist(),
                mains_percent=(100*p[line].sum(axis=0)*df/total).tolist(),
                harmonics_100_to_450_percent=(100*p[harmonic].sum(axis=0)*df/total).tolist(),
                harmonic_percent_by_frequency=per,
                low_frequency_percent=(100*p[low].sum(axis=0)/p[broad].sum(axis=0)).tolist())

results, spectra = {}, {}
for name,x in streams.items():
    powers, weights, rows = [], [], []
    for s in segments:
        a,b=round(s['stable_start_s']*FS),round(s['stable_end_s']*FS)
        assert np.all((np.diff(seq[a:b]) % 65536)==1), s
        f,p=psd(x[a:b])
        powers.append(p);weights.append(b-a)
        rows.append({**s, **spectral_stats(f,p)})
    p=np.average(powers, axis=0, weights=weights)
    spectra[name]=(f,p)
    results[name]=dict(stable=spectral_stats(f,p),segments=rows,
                      min=x.min(axis=0).tolist(),max=x.max(axis=0).tolist(),
                      rail_count=(((x<=-8388608)|(x>=8388607)).sum(axis=0)).tolist(),
                      max_abs_fraction_full_scale=(abs(x).max(axis=0)/8388608).tolist(),
                      median=np.median(x,axis=0).tolist())

bp=signal.butter(4,[20,450],fs=FS,btype='bandpass',output='sos')
filtered=signal.sosfiltfilt(bp,streams['notch50'],axis=0)
bursts=[]
for s in segments:
    a,b=round(s['stable_start_s']*FS),round(s['stable_end_s']*FS)
    x=filtered[a:b];n=len(x)//400
    rms=np.sqrt(np.mean(x[:n*400].reshape(n,400,8)**2,axis=1))
    k=max(1,int(np.ceil(n*.1)))
    bursts.append({**s,'median_100ms_rms':np.median(rms,axis=0).tolist(),
                   'p95_100ms_rms':np.percentile(rms,95,axis=0).tolist(),
                   'top10percent_windows_power_share':(np.sort(rms*rms,axis=0)[-k:].sum(axis=0)/(rms*rms).sum(axis=0)).tolist()})

comparisons=[]
for i,s in enumerate(segments):
    if s['label']=='rest':continue
    assert i>0 and segments[i-1]['label']=='rest'
    rest=np.array(results['notch50']['segments'][i-1]['rms_excluding_line_bands'])
    active=np.array(results['notch50']['segments'][i]['rms_excluding_line_bands'])
    comparisons.append({**s,'rms_ratio':(active/rest).tolist(),
                        'power_ratio_db':(20*np.log10(active/rest)).tolist()})

def spatial(x):
    ev=np.linalg.eigvalsh(np.cov(x,rowvar=False));corr=np.corrcoef(x.T)
    return dict(pc1_fraction=float(ev[-1]/ev.sum()),
                median_abs_pairwise_correlation=float(np.median(abs(corr[np.triu_indices(8,1)]))),
                correlation=corr.tolist())

f,pr=spectra['raw'];_,pn=spectra['notch50'];m=abs(f-50)<=1
summary=dict(input=str(SOURCE),sha256=hashlib.sha256(binary).hexdigest(),
             frames=len(frames),duration_s=len(frames)/FS,sample_rate_hz=FS,
             placement='User confirmed CH1-6 wrist, CH7-8 near elbow; all eight are EMG',
             firmware='User confirmed previous BOOT, not new notch+comb+bandpass',
             segments=segments,streams=results,burst_metrics=bursts,
             action_vs_preceding_rest=comparisons,
             spatial={'raw':spatial(streams['raw']),'notch50_bandpass_20_450':spatial(filtered)},
             notch_50hz_attenuation_db=(10*np.log10(pr[m].sum(axis=0)/pn[m].sum(axis=0))).tolist(),
             integrity=dict(backward_rows=back.tolist(),forward_missing=int(np.sum(delta[(delta>1)&(delta<32768)]-1)),
                            duplicates=int(np.sum(delta==0)),wraps=int(np.sum((np.diff(seq)<0)&(delta<32768))),
                            replay_first339_at512=bool(np.array_equal(frames[:339,4:],frames[512:851,4:]))),
             method=dict(segment_trim_s=1,psd='Welch8192, 50% overlap, linear detrend, duration-weighted stable segments',
                         line_half_width_hz=1,all_harmonics=list(range(50,451,50)),
                         units='ADC counts; no assumed gain/reference conversion',
                         time_axis='Saved row time, not independent hardware clock; backwards startup is flagged',
                         comparisons='Action/rest activity ratios, not physiological SNR or prediction accuracy'))

# Same nine-second resting interval and spectral parameters as the prior report.
previous=json.loads((OUT.parent/'emg005_20261021/EMG005_vs_EMG004.json').read_text())['EMG005']
rest_compare={}
for name,x in streams.items():
    f,p=psd(x[4000:40000]);now=spectral_stats(f,p)
    old={k:previous[name][oldk] for k,oldk in [('mains_rms','mains_rms'),
         ('harmonic_neighborhood_rms','harmonic_neighborhood_rms'),('rms_excluding_line_bands','outside_line_rms')]}
    rest_compare[name]={'EMG005':old,'EMG006':now,
                        'change_db':{k:(20*np.log10(np.array(now[k])/np.array(v))).tolist() for k,v in old.items()}}
summary['matched_rest_1_to_10s_comparison']=rest_compare

# After five seconds, the zero-start reference should have settled to the
# recorded warm notch; this independently checks which filter was recorded.
errors=[]
for ch in range(8):
    model=Notch50();expected=np.array([model.step(int(x)) for x in streams['raw'][:40000,ch]])
    e=abs(expected[20000:]-streams['notch50'][20000:40000,ch])
    errors.append(int(e.max()))
summary['legacy_notch_reference_max_error_5_to_10s_counts']=errors
assert max(errors)<=2, errors
(OUT/'EMG006_quality.json').write_text(json.dumps(summary,indent=2),encoding='utf-8')

colors={'rest':'#d9e3ec','open_hand':'#a5d6a7','fist':'#ffcc80','wrist_flex':'#b39ddb','wrist_extend':'#81d4fa'}
fig,axes=plt.subplots(8,2,figsize=(17,15),sharex=True)
block=400;n=len(filtered)//block;times=(np.arange(n)+.5)*block/FS
env=np.sqrt(np.mean(filtered[:n*block].reshape(n,block,8)**2,axis=1))
for ch in range(8):
    lo=streams['raw'][:n*block,ch].reshape(n,block).min(axis=1)
    hi=streams['raw'][:n*block,ch].reshape(n,block).max(axis=1)
    axes[ch,0].fill_between(times,lo/1000,hi/1000,color='#255da8',alpha=.8,lw=0)
    axes[ch,1].plot(times,env[:,ch],lw=.8,color='#255da8')
    axes[ch,0].set_ylabel(f'CH{ch+1}\nkcount')
    for ax in axes[ch]:
        for s in segments:ax.axvspan(s['start_s'],s['end_s'],color=colors[s['label']],alpha=.3)
        ax.grid(alpha=.2)
axes[0,0].set_title('RAW extrema per 100 ms (preserves peaks)')
axes[0,1].set_title('Recorded notch + offline zero-phase 20-450 Hz: 100 ms RMS')
from matplotlib.patches import Patch
fig.legend(handles=[Patch(facecolor=c,alpha=.5,label=l) for l,c in colors.items()],loc='upper center',ncol=5,frameon=False)
for ax in axes[-1]:ax.set_xlabel('Saved time (s)')
fig.tight_layout(rect=(0,0,1,.97));fig.savefig(OUT/'EMG006_waveform_quality.png',dpi=130);plt.close(fig)
fig,axes=plt.subplots(4,2,figsize=(15,13),sharex=True)
for ch,ax in enumerate(axes.flat):
    for name,(f,p) in spectra.items():
        mask=(f>=20)&(f<=450)
        ax.plot(f[mask],10*np.log10(np.maximum(p[mask,ch],1e-12)),label=name,lw=.8)
    for hz in range(50,451,50):ax.axvline(hz,color='gray',alpha=.25,lw=.6)
    ax.set_title(f'CH{ch+1}');ax.set_ylabel('PSD (dB count^2/Hz)');ax.grid(alpha=.2)
axes[0,0].legend()
for ax in axes[-1]:ax.set_xlabel('Hz')
fig.suptitle('Stable segments: recorded RAW / legacy notch50, same axes')
fig.tight_layout();fig.savefig(OUT/'EMG006_spectrum_quality.png',dpi=130);plt.close(fig)
print(json.dumps({k:summary[k] for k in ['frames','duration_s','integrity','legacy_notch_reference_max_error_5_to_10s_counts','notch_50hz_attenuation_db']},indent=2))
for name,value in results.items():print(name.upper(),'STABLE',json.dumps(value['stable']))
for i,s in enumerate(segments):print('SEGMENT',i,s['label'],round(s['start_s'],2),round(s['end_s'],2),'CLEAN_RMS',np.round(results['notch50']['segments'][i]['rms_excluding_line_bands'],1).tolist())
print('REST_COMPARE_DB',json.dumps({name:r['change_db'] for name,r in rest_compare.items()}))
print('ACTION_RATIO',json.dumps(comparisons))
print('BURSTS',json.dumps([{k:v for k,v in r.items() if k in ['label','median_100ms_rms','p95_100ms_rms','top10percent_windows_power_share']} for r in bursts]))
print('TEST_PASS analysis: framing, continuous stable segments, known old-filter reference, finite PSD, local-rest labels')
