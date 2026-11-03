"""Independent NumPy/SciPy check of baseline-free final-waveform diagnostics."""
import json
from pathlib import Path
import subprocess
import numpy as np
import pandas as pd
from scipy.signal import butter, lfilter
ROOT=Path(__file__).resolve().parents[1]
EXE=ROOT/'sim/results_quality/channel_quality_test.exe'
OUT=ROOT/'report/channel_quality_20261029'

def pli_stat(psd, fc):
    f=np.fft.rfftfreq(2048,1/4000)
    d=f-fc
    band=abs(d)<=2
    left=(d>=-15)&(d<=-3)
    right=(d>=3)&(d<=15)
    if band.sum()==0 or left.sum()<3 or right.sum()<3:return None
    correction=1/(1-2/36)**3
    base=np.interp(f[band],[f[left].mean(),f[right].mean()],
                   [np.median(psd[left])*correction,np.median(psd[right])*correction]).sum()
    power=psd[band].sum()
    return power,base,power/base if base>0 else 1e9 if power>0 else 0

def metrics(v):
    # Same engineering definitions, evaluated in floating point with SciPy
    # filters and NumPy's FFT, independently of the C fixed-point engine.
    v=v.astype(float)-int(v.sum()/len(v))
    fft=[]
    for start in (0,1024):fft.append(abs(np.fft.rfft(v[start:start+2048]*np.hanning(2048)))**2)
    psd=np.sum(fft,axis=0)
    null=[]
    for f in range(20,216):
        if min(f%50,50-f%50,f%60,60-f%60)>=17:
            stat=pli_stat(psd,f)
            if stat is not None:null.append(stat[2])
    med=np.median(null)
    threshold=med+6*1.4826*np.median(abs(np.array(null)-med)) if len(null)>=10 else 1e9
    pli=0
    for f in (50,100,150,200):
        power,base,ratio=pli_stat(psd,f)
        if ratio>threshold:pli+=max(power-base,0)
    total=psd[1:].sum()
    energy=np.sum(v*v)
    low=lfilter(*butter(2,5,fs=4000),v)
    noise=lfilter(*butter(2,20,fs=4000),lfilter(*butter(2,2,fs=4000,btype='highpass'),v))
    return [pli/total*1000 if total else 0,
            np.sum(low*low)/energy*1000 if energy else 0,
            np.sum(noise*noise)/energy*1000 if energy else 0,
            np.mean(v**4)/np.mean(v*v)**2*10 if energy else 0]

def check(name,x):
    x=np.rint(x).astype(np.int32)
    x=x[:len(x)//4000*4000]
    data='\n'.join(' '.join(map(str,row)) for row in x)+'\n'
    proc=subprocess.run([str(EXE),'--stream'],input=data,text=True,capture_output=True,check=True)
    actual=np.fromstring(proc.stdout,sep=' ').reshape(-1,8,15)
    z=x.reshape(-1,4000,8).astype(float)
    rms=np.std(z,axis=1)
    reference=np.array([[metrics(v[:,i]) for i in range(8)] for v in z])
    measured=actual[:,:,[3,7,8,9]]
    err=abs(measured-reference)
    assert (actual[:,:,0]==np.arange(8)).all()
    assert abs(actual[:,:,1]-rms).max()<1.01,(name,'rms')
    # Welch integer FFT and power-floor precision, not the old single-bin DFT.
    assert err[:,:,0].max()<15,(name,'mains',err[:,:,0].max())
    assert err[:,:,1:3].max()<6,(name,'low frequency',err[:,:,1:3].max())
    assert np.all(err[:,:,3] < np.maximum(2,reference[:,:,3]*0.005)),(name,'kurtosis',err[:,:,3].max())
    assert (actual[:,:,4]==np.sum(abs(z)>=8304721,axis=1)).all()
    assert (actual[:,:,5]==np.max(abs(z),axis=1)).all()
    assert np.isin(actual[:,:,11],[0,1,2,3]).all()
    return {'windows':len(z),'channel_windows':int(rms.size),
            'max_rms_error_counts':float(abs(actual[:,:,1]-rms).max()),
            'max_mains_error_percentage_points':float(err[:,:,0].max()/10),
            'max_low_band_error_percentage_points':float(err[:,:,1:3].max()/10),
            'max_kurtosis_error':float(err[:,:,3].max()/10),
            'median_scores':np.median(actual[:,:,10],axis=0).tolist()}

def main():
    rng=np.random.default_rng(43)
    n=np.arange(4000*8)
    x=np.column_stack([rng.normal(0,30,len(n)),100*np.sin(2*np.pi*50*n/4000),
                      100*np.sin(2*np.pi*100*n/4000),100*np.sin(2*np.pi*150*n/4000),
                      100*np.sin(2*np.pi*200*n/4000),100*np.sin(2*np.pi*49.5*n/4000),
                      1000000+200*np.sin(2*np.pi*137*n/4000),rng.normal(0,300,len(n))])
    result={'synthetic':check('synthetic',x)}
    # Broadband, low-frequency movement, intermittent bursts, spikes and rail
    # coverage protect against a self-reference simply rewarding bad contact.
    x=np.column_stack([rng.normal(0,100,len(n)),np.zeros(len(n)),
        2000*np.sin(2*np.pi*2*n/4000),2000*np.sin(2*np.pi*10*n/4000),
        100*np.sin(2*np.pi*52*n/4000),np.full(len(n),8388607),
        rng.normal(0,100,len(n))*(n%4000<800),rng.normal(0,100,len(n))])
    x[::1000,7]+=15000
    result['artifacts']=check('artifacts',x)
    for index in (8,15,18):
        stem=f'EMG{index:03d}'+('_validprefix' if index==18 else '')
        path=ROOT/f'report/emg{index:03d}_20261022/{stem}_processed.csv'
        frame=pd.read_csv(path,nrows=4000*12)
        assert set(frame.source)=={'processed'}
        assert (np.diff(frame.timestamp_us)==250).all()
        result[stem]=check(stem,frame[[f'channel_{i}' for i in range(8)]].to_numpy())
    OUT.mkdir(exist_ok=True)
    (OUT/'numeric_validation.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
    print(json.dumps(result,indent=2))
    print('TEST_PASS baseline-free quality C/NumPy/SciPy numerical validation')
if __name__=='__main__':main()

