"""Independent NumPy FFT/RMS reference for the compiled integer diagnostic."""
import json
from pathlib import Path
import subprocess
import numpy as np
import pandas as pd
ROOT=Path(__file__).resolve().parents[1]
EXE=ROOT/'sim/results_quality/channel_quality_test.exe'
OUT=ROOT/'report/channel_quality_20261023'

def check(name,x):
    x=np.rint(x).astype(np.int32)
    x=x[:len(x)//4000*4000]
    data='\n'.join(' '.join(map(str,row)) for row in x)+'\n'
    proc=subprocess.run([str(EXE),'--stream'],input=data,text=True,capture_output=True,check=True)
    actual=np.fromstring(proc.stdout,sep=' ').reshape(-1,8,6)
    z=x.reshape(-1,4000,8).astype(float)
    rms=np.std(z,axis=1)
    bins=np.fft.rfft(z,axis=1)[:,[50,100,150,200],:]
    frac=np.divide(2*np.sum(abs(bins)**2,axis=1)/4000**2,rms**2,
                   out=np.zeros_like(rms),where=rms>0)*1000
    rms_err=abs(actual[:,:,1]-rms)
    line_err=abs(actual[:,:,3]-frac)
    assert (actual[:,:,0]==np.arange(8)).all()
    assert rms_err.max()<1.01,(name,rms_err.max())
    assert line_err.max()<4,(name,line_err.max()) # 0.4 percentage points incl integer power floors
    assert (actual[:,:,4]==np.sum(abs(z)>=8304721,axis=1)).all()
    assert (actual[:,:,5]==np.max(abs(z),axis=1)).all()
    return {'windows':len(z),'channel_windows':int(rms.size),
            'max_rms_error_adc_counts':float(rms_err.max()),
            'max_residual_fraction_error_percentage_points':float(line_err.max()/10),
            'rms_median_counts':np.median(actual[:,:,1],axis=0).tolist()}

def main():
    rng=np.random.default_rng(43)
    n=np.arange(4000*8)
    x=np.column_stack([rng.normal(0,30,len(n)),100*np.sin(2*np.pi*50*n/4000),
                      100*np.sin(2*np.pi*100*n/4000),100*np.sin(2*np.pi*150*n/4000),
                      100*np.sin(2*np.pi*200*n/4000),100*np.sin(2*np.pi*49.5*n/4000),
                      1000000+200*np.sin(2*np.pi*137*n/4000),rng.normal(0,300,len(n))])
    result={'synthetic':check('synthetic',x)}
    for index in (8,15,18):
        stem=f'EMG{index:03d}'+('_validprefix' if index==18 else '')
        path=ROOT/f'report/emg{index:03d}_20261022/{stem}_processed.csv'
        frame=pd.read_csv(path,nrows=4000*24)
        assert set(frame.source)=={'processed'}
        assert (np.diff(frame.timestamp_us)==250).all()
        x=frame[[f'channel_{i}' for i in range(8)]].to_numpy()
        result[stem]=check(stem,x)
    OUT.mkdir(exist_ok=True)
    (OUT/'numeric_validation.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
    print(json.dumps(result,indent=2))
if __name__=='__main__':main()
