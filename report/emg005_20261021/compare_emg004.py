"""Compare matched initial resting windows, not unequal full-record shares."""
from pathlib import Path
import json
import numpy as np
import pandas as pd
from scipy import signal
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

OUT=Path(__file__).resolve().parent
PREVIOUS=OUT.parent/'emg004_20261021'
FS=4000
result={'method':'Both initial rest windows 1.0-10.0 s, identical duration; Welch8192, 50% overlap, linear detrend; count units, no independent gain/reference verification. No causal attribution to gel alone.'}
for label,path in [('EMG004',PREVIOUS),('EMG005',OUT)]:
    row={}
    for name in ['raw','notch50']:
        d=pd.read_csv(path/f'{label}_{name}.csv',nrows=40000)
        x=d[[f'channel_{i}' for i in range(8)]].to_numpy(float)[4000:40000]
        f,p=signal.welch(x,fs=FS,nperseg=8192,noverlap=4096,axis=0,detrend='linear')
        df=f[1]-f[0];band=(f>=20)&(f<=450);mains=abs(f-50)<=1
        harmonics=np.zeros(len(f),bool)
        for hz in range(100,451,50):harmonics|=(abs(f-hz)<=1)&band
        clean=band&~(mains|harmonics)
        row[name]={'mains_rms':np.sqrt(p[mains].sum(axis=0)*df).tolist(),
                   'harmonic_neighborhood_rms':np.sqrt(p[harmonics].sum(axis=0)*df).tolist(),
                   'outside_line_rms':np.sqrt(p[clean].sum(axis=0)*df).tolist()}
    result[label]=row
for name in ['raw','notch50']:
    result[name+'_changes_db']={k:(20*np.log10(np.array(result['EMG005'][name][k])/np.array(result['EMG004'][name][k]))).tolist()
                                for k in result['EMG005'][name]}
(OUT/'EMG005_vs_EMG004.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
fig,axes=plt.subplots(2,1,figsize=(11,7))
channels=np.arange(1,9)
for ax,source,metric,title in [(axes[0],'raw','mains_rms','Matched initial rest 1-10 s: raw 49-51 Hz RMS'),
                               (axes[1],'notch50','harmonic_neighborhood_rms','Matched initial rest 1-10 s: notch50 harmonic neighborhoods 100-450 Hz')]:
    for shift,(name,color) in zip([-.18,.18],[('EMG004','#5078b3'),('EMG005','#db8541')]):
        ax.bar(channels+shift,result[name][source][metric],width=.36,label=name,color=color)
    ax.set(title=title,ylabel='ADC count RMS',xticks=channels);ax.legend();ax.grid(axis='y',alpha=.2)
axes[-1].set_xlabel('Channel')
fig.tight_layout();fig.savefig(OUT/'EMG005_vs_EMG004_rest.png',dpi=140);plt.close(fig)
print(json.dumps(result,indent=2))
