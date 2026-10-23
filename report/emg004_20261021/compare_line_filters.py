"""Offline, causal floating-point filter comparison for EMG004. No RTL edits."""
from pathlib import Path
import json
import numpy as np
import pandas as pd
from scipy import signal
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

OUT=Path(__file__).resolve().parent
FS=4000
data=pd.read_csv(OUT/'EMG004_raw.csv')
raw=data[[f'channel_{i}' for i in range(8)]].to_numpy(float)
recorded=pd.read_csv(OUT/'EMG004_notch50.csv')[[f'channel_{i}' for i in range(8)]].to_numpy(float)
labels=data.action.to_numpy()
edges=np.r_[0,np.flatnonzero(labels[1:]!=labels[:-1])+1,len(labels)]
segments=[dict(start=int(a),stop=int(b),label=str(labels[a])) for a,b in zip(edges[:-1],edges[1:])]

def ba_filter(b,a,x):
    zi=signal.lfilter_zi(b,a)[:,None]*x[0][None,:]
    return signal.lfilter(b,a,x,axis=0,zi=zi)[0]

def sos_filter(sos,x):
    zi=signal.sosfilt_zi(sos)[:,:,None]*x[0][None,None,:]
    return signal.sosfilt(sos,x,axis=0,zi=zi)[0]

b50,a50=signal.iirnotch(50,10,fs=FS)
b250,a250=signal.iirnotch(250,250,fs=FS)  # 1 Hz -3 dB bandwidth
b1,a1=signal.iircomb(50,50,fs=FS)         # 1 Hz width, 80-sample delay
b2,a2=signal.iircomb(50,25,fs=FS)         # 2 Hz width sensitivity check
coefficients={'notch50':(b50,a50),'comb_1Hz':(b1,a1),'comb_2Hz':(b2,a2),
              'notch50_plus_comb1':(np.convolve(b50,b1),np.convolve(a50,a1)),
              'notch50_plus_comb2':(np.convolve(b50,b2),np.convolve(a50,a2)),
              'notch50_plus250':(np.convolve(b50,b250),np.convolve(a50,a250))}
streams={'raw':raw,'notch50':recorded,'comb_1Hz':ba_filter(b1,a1,raw),
         'comb_2Hz':ba_filter(b2,a2,raw),
         'notch50_plus_comb1':ba_filter(b1,a1,recorded),
         'notch50_plus_comb2':ba_filter(b2,a2,recorded),
         'notch50_plus250':ba_filter(b250,a250,recorded)}

# All branches get exactly the same causal analysis bandpass. This is not
# the existing PL's HP20/LP215 filter and is not a bit-exact hardware trial.
bp=np.vstack([signal.butter(2,20,btype='highpass',fs=FS,output='sos'),
              signal.butter(4,450,btype='lowpass',fs=FS,output='sos')])
filtered={name:sos_filter(bp,x) for name,x in streams.items()}

def psd(x):
    return signal.welch(x,fs=FS,nperseg=8192,noverlap=4096,axis=0,detrend='linear')

def metrics(f,p):
    df=f[1]-f[0]; band=(f>=20)&(f<=450)
    line=abs(f-50)<=1
    harm=np.zeros(len(f),bool); excluded=np.zeros(len(f),bool)
    for hz in range(50,451,50):
        excluded |= abs(f-hz)<=3
        if hz>=100: harm |= abs(f-hz)<=1
    harm &= band
    clean=band&~excluded
    total=p[band].sum(axis=0)*df
    cumulative=np.cumsum(p[band],axis=0)
    median=[float(f[band][np.searchsorted(cumulative[:,c],cumulative[-1,c]/2)]) for c in range(8)]
    return dict(rms=np.sqrt(total).tolist(),mains_power=(p[line].sum(axis=0)*df).tolist(),
                harmonic_power=(p[harm].sum(axis=0)*df).tolist(),
                mains_percent=(100*p[line].sum(axis=0)*df/total).tolist(),
                harmonic_percent=(100*p[harm].sum(axis=0)*df/total).tolist(),
                outside_line_power=(p[clean].sum(axis=0)*df).tolist(),
                median_frequency_hz=median)

results={}; spectra={}
for name,x in filtered.items():
    powers=[];weights=[];rows=[]
    for s in segments:
        a,b=s['start']+FS,s['stop']-FS
        f,p=psd(x[a:b]);powers.append(p);weights.append(b-a)
        rows.append(dict(label=s['label'],start_s=s['start']/FS,**metrics(f,p)))
    p=np.average(powers,axis=0,weights=weights)
    spectra[name]=(f,p)
    results[name]=dict(overall=metrics(f,p),segments=rows)
    action=[]
    for i,s in enumerate(segments):
        if s['label']=='rest':continue
        j=max(k for k in range(i) if segments[k]['label']=='rest')
        ratios=np.sqrt(np.array(rows[i]['outside_line_power'])/np.array(rows[j]['outside_line_power']))
        action.append(dict(label=s['label'],start_s=s['start']/FS,rms_ratio=ratios.tolist()))
    results[name]['action_vs_preceding_rest']=action
    burst=[]
    for s in segments:
        if s['label']!='fist':continue
        xch=x[s['start']+FS:s['stop']-FS,7]
        n=len(xch)//400;rms=np.sqrt(np.mean(xch[:400*n].reshape(n,400)**2,axis=1))
        k=int(np.ceil(.1*n))
        burst.append(dict(start_s=s['start']/FS,median_rms=float(np.median(rms)),
                          p95_rms=float(np.percentile(rms,95)),
                          top10percent_power=float(np.sort(rms*rms)[-k:].sum()/(rms*rms).sum())))
    results[name]['CH8_fist_bursts']=burst

# Response-based information loss is only a flat-spectrum model. Recorded
# EMG has no clean ground truth; attenuation is not an SNR improvement claim.
grid=np.arange(20,450,.01)
responses={};response_metrics={}
for name,(b,a) in coefficients.items():
    _,h=signal.freqz(b,a,worN=grid,fs=FS)
    responses[name]=h
    response_metrics[name]=dict(flat_band_power_removed_percent=float(100*(1-np.mean(abs(h)**2))),
        band_fraction_below_minus3db_percent=float(100*np.mean(abs(h)**2<.5)))

# Numerical checks: stable poles, sinusoid rejection and off-notch gain.
# Warm up synthetic tones for 8 s, then compare 2 s RMS with predicted gain.
checks=[]
t=np.arange(10*FS)/FS
for name,(b,a) in coefficients.items():
    poles=np.roots(a); assert max(abs(poles))<1
    for hz in [40,49.5,50,50.5,75,100,250]:
        x=np.sin(2*np.pi*hz*t)
        y=signal.lfilter(b,a,x)
        observed=np.sqrt(np.mean(y[-2*FS:]**2)/np.mean(x[-2*FS:]**2))
        expected=abs(signal.freqz(b,a,worN=[hz],fs=FS)[1][0])
        assert abs(observed-expected)<1e-4,(name,hz,observed,expected)
    impulse=np.zeros(3*FS);impulse[0]=1
    ir=signal.lfilter(b,a,impulse)
    tail=np.cumsum((ir*ir)[::-1])[::-1]
    after=np.flatnonzero(tail[1:]<=tail[1]*.001)
    response_metrics[name]['impulse_tail_99_9percent_energy_ms']=float((after[0]+1)*1000/FS) if len(after) else None
    response_metrics[name]['max_pole_radius']=float(max(abs(poles)))
    offsets={}
    for delta in [0,.1,.2]:
        freq=np.arange(1,10)* (50+delta)
        _,h=signal.freqz(b,a,worN=freq,fs=FS)
        offsets[str(delta)]=(20*np.log10(np.maximum(abs(h),1e-15))).tolist()
    response_metrics[name]['gain_db_at_harmonics_for_fundamental_offset_hz']=offsets
    checks.append(name+': stable poles and 7 synthetic tones passed')

reference=results['notch50']['overall']
for name,r in results.items():
    o=r['overall']
    r['relative_to_recorded_notch50']=dict(
      outside_line_power_change_percent=(100*(np.array(o['outside_line_power'])/np.array(reference['outside_line_power'])-1)).tolist(),
      mains_reduction_db=(10*np.log10(np.array(reference['mains_power'])/np.array(o['mains_power']))).tolist(),
      harmonic_reduction_db=(10*np.log10(np.array(reference['harmonic_power'])/np.array(o['harmonic_power']))).tolist())

output=dict(methods=dict(fs=FS,causal=True,trim_s=1,welch_n=8192,
    comb_widths_hz=[1,2],selective_added_notch_hz=[250],selective_width_hz=1,
    rationale='250 Hz was a visible narrow peak in EMG004; chosen on this recording, not independently validated',
    common_bandpass='offline floating-point causal HP Butterworth order2 20Hz + LP order4 450Hz',
    initialization='new filters use steady-state initial conditions; continuous across action labels',
    baseline='actual recorded fixed-point notch50; comb-only replaces it on raw; hybrid and selective cascade after recorded notch50',
    limitations='No clean EMG reference, no accuracy claim; CH8 is EMG with artifacts; no RTL changes, no fixed-point verification'),
    checks=checks,filter_responses=response_metrics,results=results)
(OUT/'EMG004_filter_comparison.json').write_text(json.dumps(output,indent=2),encoding='utf-8')

colors={'raw':'#999999','notch50':'#2463b3','comb_1Hz':'#138b60','comb_2Hz':'#d29520',
        'notch50_plus_comb1':'#7c3eaf','notch50_plus_comb2':'#0b9ca9','notch50_plus250':'#c24665'}
fig,axes=plt.subplots(3,1,figsize=(13,11))
for name,h in responses.items():
    axes[0].plot(grid,20*np.log10(np.maximum(abs(h),1e-6)),label=name,color=colors[name],lw=1)
axes[0].set(ylim=(-45,1),xlim=(20,450),ylabel='Gain (dB)',title='Line-filter response (analysis bandpass excluded)')
for ch,ax in [(3,axes[1]),(5,axes[2])]:
    for name,(f,p) in spectra.items():
        m=(f>=20)&(f<=450)
        ax.plot(f[m],10*np.log10(np.maximum(p[m,ch],1e-12)),label=name,color=colors[name],lw=.8)
    ax.set(title=f'CH{ch+1}: stable-segment absolute PSD, same analysis bandpass',ylabel='dB count^2/Hz',xlim=(20,450))
for ax in axes:
    ax.grid(alpha=.2);ax.legend(ncol=5,fontsize=8);ax.set_xlabel('Hz')
fig.tight_layout();fig.savefig(OUT/'EMG004_filter_comparison_spectra.png',dpi=140);plt.close(fig)

fig,axes=plt.subplots(3,1,figsize=(13,9))
n=len(raw)//400;time=(np.arange(n)+.5)*.1
for ch,ax in zip([2,4,7],axes):
    for name in ['notch50','notch50_plus_comb1','notch50_plus_comb2','notch50_plus250']:
        x=filtered[name][:n*400,ch].reshape(n,400)
        ax.plot(time,np.sqrt(np.mean(x*x,axis=1)),label=name,color=colors[name],lw=.9)
    for s in segments:
        ax.axvline(s['start']/FS,color='gray',alpha=.25,lw=.7)
    ax.set(title=f'CH{ch+1}: 100 ms causal filtered RMS',ylabel='ADC count',xlim=(0,len(raw)/FS));ax.grid(alpha=.2)
axes[0].legend(ncol=4);axes[-1].set_xlabel('Time (s)')
fig.tight_layout();fig.savefig(OUT/'EMG004_filter_comparison_actions.png',dpi=140);plt.close(fig)

print('NUMERICAL CHECKS',checks)
print('RESPONSE METRICS',json.dumps(response_metrics))
for name,r in results.items():
    print(name,'50%',np.round(r['overall']['mains_percent'],3),
          'harm%',np.round(r['overall']['harmonic_percent'],2),
          'outside-change%',np.round(r['relative_to_recorded_notch50']['outside_line_power_change_percent'],2),
          'harm-reduction-db',np.round(r['relative_to_recorded_notch50']['harmonic_reduction_db'],2),
          'CH8bursts',r['CH8_fist_bursts'])
