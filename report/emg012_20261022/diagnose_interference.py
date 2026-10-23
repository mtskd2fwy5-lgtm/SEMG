"""Additional spectral checks only; does not refit any classifier."""
from pathlib import Path
import json
import sys
import numpy as np
from scipy import signal
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

OUT = Path(__file__).resolve().parent
sys.path.insert(0, str(OUT))
from assess_emg012 import base


def metrics(f, p):
    df = f[1]-f[0]
    band = (f >= 20) & (f <= 450)
    near = (f >= 45) & (f <= 55)
    center = abs(f-50) <= 1
    indices = np.flatnonzero(near)
    return dict(peak_45_55_hz=f[indices[np.argmax(p[near], axis=0)]].tolist(),
                rms_45_55=np.sqrt(p[near].sum(0)*df).tolist(),
                power_45_55_percent=(100*p[near].sum(0)/p[band].sum(0)).tolist(),
                power_49_51_percent=(100*p[center].sum(0)/p[band].sum(0)).tolist())


def main():
    result = {}
    fig, axes = plt.subplots(2, 2, figsize=(13, 8))
    colors = {'008':'#999999','011':'#e99829','012':'#007d76'}
    for number in ('008', '011', '012'):
        rec = base.load_record('F:/EMG'+number+'.BIN')
        rows = {}
        for key in ('raw', 'processed'):
            f, p = signal.welch(rec[key][4000:20000].astype(float), fs=4000,
                nperseg=16000, detrend='linear', axis=0)
            rows[key] = metrics(f, p)
            for j, ch in enumerate((0, 5)):
                ax = axes[j, int(key=='processed')]
                mask = (f>=35) & (f<=65)
                ax.plot(f[mask], 10*np.log10(np.maximum(p[mask,ch],1e-12)),
                        color=colors[number], label='EMG'+number)
                ax.set_title(f'CH{ch+1} {key}; rest 1-5 s, 0.25 Hz bins')
                ax.set_xlabel('Hz'); ax.set_ylabel('PSD dB counts^2/Hz')
                ax.grid(alpha=.2)
        if number == '012':
            all_p = {key:[] for key in ('raw','processed')}
            weights = []
            for s in rec['segments']:
                a, b = round(s['stable_start_s']*4000), round(s['stable_end_s']*4000)
                if b-a < 16384:
                    continue
                weights.append(b-a)
                for key in all_p:
                    f, p = base.welch(rec[key][a:b].astype(float), 16384)
                    all_p[key].append(p)
            rows['stable_0p244Hz'] = {key:metrics(f,np.average(ps,axis=0,weights=weights))
                                     for key,ps in all_p.items()}
            x = rec['processed'].astype(float)
            n = len(x)//400
            rms = np.sqrt((x[:n*400].reshape(n,400,8)**2).mean(1))
            score = np.median(rms,axis=1)
            top = np.argsort(score)[-5:][::-1]
            rows['top_shared_100ms_rms'] = [dict(start_s=float(i/10),
                rms_counts=rms[i].tolist()) for i in top]
            rows['median_100ms_rms'] = np.median(rms,axis=0).tolist()
        result['EMG'+number] = rows
        del rec
    q = json.loads((OUT/'EMG012_quality.json').read_text(encoding='utf-8'))
    cm = np.mean([s['confusion'] for s in q['models']['8ch']['transfer']['seeds']], axis=0)
    result['EMG008_to_012_mean_confusion_percent'] = (100*cm/cm.sum(1,keepdims=True)).tolist()
    for ax in axes.flat:
        ax.axvline(50,color='black',lw=.6,ls='--'); ax.legend()
    fig.tight_layout(); fig.savefig(OUT/'EMG012_line_comparison.png',dpi=140); plt.close(fig)
    assert all(np.isfinite(v).all() for v in (cm,))
    (OUT/'EMG012_interference.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
    print(json.dumps(result, indent=2))
    print('TEST_PASS: high-resolution spectra and saved confusion comparison')


if __name__ == '__main__':
    main()
