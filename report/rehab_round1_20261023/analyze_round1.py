"""Reproduce first-round training summaries and independent waveform replay.

Run from the repository root after tools/decode_sd_record.py. No model fitting
or firmware changes; inference is a scenario with identity channel mapping.
"""
from pathlib import Path
import csv
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
INPUT = ROOT / 'data/rehab/20261023_round1'
sys.path.insert(0, str(ROOT / 'tools'))
from train_board_model import feature_windows, read_capture, FS, HOP, WINDOW, CLASSES
from export_int8 import Int8MLP
from validate_pose_stability import softmax_scores, stable_pose, c_crosscheck


def rehab_summary(name):
    with (INPUT / name).open(encoding='utf-8-sig', newline='') as fh:
        rows = list(csv.DictReader(fh))
    meta = {r['key']: r['value'] for r in rows if r['kind'] == 'meta'}
    trials = [{k: int(r[k]) for k in ('index', 'target', 'success', 'response_ms',
               'hold_ms', 'breaks', 'duration_ms')} for r in rows if r['kind'] == 'trial']
    assert len(trials) == int(meta['attempted'])
    assert sum(t['success'] for t in trials) == int(meta['successes'])
    success = [t for t in trials if t['success']]
    return dict(meta=meta, trials=trials, successes=len(success), attempted=len(trials),
                success_fraction=len(success)/int(meta['planned']),
                successful_response_mean_ms=float(np.mean([t['response_ms'] for t in success])),
                successful_duration_mean_ms=float(np.mean([t['duration_ms'] for t in success])),
                interruptions=sum(t['breaks'] for t in trials),
                baseline=[int(meta[f'rest_mav_ch{ch}']) for ch in range(1, 9)])


def metrics(y, pred, mask):
    cm = np.zeros((5, 5), dtype=int)
    np.add.at(cm, (y[mask], pred[mask]), 1)
    counts = cm.sum(axis=1)
    return dict(windows=int(mask.sum()), accuracy=float(np.trace(cm)/cm.sum()),
                confusion=cm.tolist(), counts=counts.tolist(),
                recall=[float(cm[i,i]/counts[i]) if counts[i] else None for i in range(5)])


def main():
    result = dict(rehab={n: rehab_summary(n) for n in ('RH000.CSV','RH001.CSV')})
    qp_file = ROOT/'data/models/nn_int8_board_multiwear/quant_params.json'
    qp = json.loads(qp_file.read_text(encoding='utf-8'))
    integrity = json.loads((OUT/'EMG000_decode.json').read_text(encoding='utf-8'))
    assert integrity['frame_fields_valid']
    assert all(integrity[k]==0 for k in ('sequence_gaps','sequence_duplicates','sequence_backwards'))
    x, sy = read_capture(OUT/'EMG000_processed.csv')
    fx, _, _ = feature_windows(x, np.zeros(len(x),dtype=np.int8), trim=0)
    assert np.max(fx) < 2**31, 'Need hardware feature saturation analysis'
    starts = np.arange(len(fx))*HOP
    ends = starts+WINDOW-1
    times = ends/FS
    edges = np.r_[0, np.flatnonzero(sy[1:]!=sy[:-1])+1, len(sy)]
    bi = np.searchsorted(edges, starts, side='right')-1
    mask = (starts>=edges[bi]+FS) & (ends<edges[bi+1]-FS)
    mask &= np.arange(len(fx))>=95  # exclude simulated startup calibration
    y = sy[ends]
    z = Int8MLP(qp).forward(fx)
    prob = softmax_scores(z, qp['logits_scale'])
    pred = z.argmax(axis=1)
    q = prob.max(axis=1)
    seq = (np.arange(len(fx))*40 % 65536).astype(np.uint16)
    replay = dict(raw_argmax=metrics(y,pred,mask))
    outputs = {}
    vectors = []
    baselines = dict(bin_start_assumption=(fx[80:96,:8].astype(np.uint64).sum(axis=0)//16).tolist(),
                     RH000=result['rehab']['RH000.CSV']['baseline'],
                     RH001=result['rehab']['RH001.CSV']['baseline'])
    for name, base in {'no_gate':None, **baselines}.items():
        gate = np.zeros(len(fx),dtype=bool) if base is None else np.all(fx[:,:8]<np.maximum(np.array(base)*3,1000),axis=1)
        out = stable_pose(pred,q,gate,seq)
        outputs[name] = out
        item = metrics(y,out,mask)
        pair = mask[1:] & mask[:-1] & (y[1:]==y[:-1])
        item['within_label_switches'] = int(np.count_nonzero((out[1:]!=out[:-1]) & pair))
        item['per_class'] = {}
        for cls in np.unique(y[mask]):
            m = mask & (y==cls)
            correct = pred==cls
            eligible = correct & (out==cls) & (q>=50) & ~gate
            item['per_class'][CLASSES[cls]] = dict(
                windows=int(m.sum()), gated_fraction=float(gate[m].mean()),
                correct_candidate_below_70_fraction=float((correct & (q<70))[m].mean()),
                wrong_candidate_fraction=float((~correct)[m].mean()),
                target_support_median=float(np.median(prob[m,cls])),
                training_match_fraction=float(eligible[m].mean()) if cls else None,
                max_mav_median=float(np.median(fx[m,:8].max(axis=1))),
                median_mav_per_channel=np.median(fx[m,:8],axis=0).tolist())
        replay[name]=item
        vectors.append((z,q,gate,seq,out))
    result.update(duration_s=len(x)/FS, features=len(fx), classes=CLASSES,
                  model_sha256=hashlib.sha256(qp_file.read_bytes()).hexdigest(),
                  baselines=baselines, replay=replay, c_crosscheck=c_crosscheck(vectors),
                  interpretation='Independent recording; no temporal alignment with RH trials. '
                  'Identity mapping; RH baselines are comparison scenarios, not BIN measured calibration. '
                  'Scores exclude simulated startup calibration and 1s on both sides of manual label boundaries; '
                  'overlapping windows are not independent trials.')
    # Absolute PSD integration uses the same band/FFT for raw and processed.
    raw = pd.read_csv(OUT/'EMG000_raw.csv',usecols=[f'channel_{i}' for i in range(8)]).to_numpy(float)
    f, pr = signal.welch(raw,fs=FS,axis=0,nperseg=16384,detrend='linear')
    _, pp = signal.welch(x,fs=FS,axis=0,nperseg=16384,detrend='linear')
    df = f[1]-f[0]
    mains = abs(f-50)<=1
    band = (f>=20)&(f<=450)
    result['line_noise'] = dict(
        raw_mains_fraction=(pr[mains].sum(axis=0)/pr[band].sum(axis=0)).tolist(),
        processed_mains_fraction=(pp[mains].sum(axis=0)/pp[band].sum(axis=0)).tolist(),
        mains_power_attenuation_db=(10*np.log10(pr[mains].sum(axis=0)/pp[mains].sum(axis=0))).tolist(),
        harmonic_bands={str(h):dict(raw_power=(pr[abs(f-h)<=1].sum(axis=0)*df).tolist(),
            processed_power=(pp[abs(f-h)<=1].sum(axis=0)*df).tolist()) for h in (50,100,150,200,250,300,350,400)})
    result['processed_amplitude']={}
    for cls in np.unique(y[mask]):
        m = mask & (y==cls)
        result['processed_amplitude'][CLASSES[cls]] = dict(
            median_mav_per_sample=(np.median(fx[m,:8],axis=0)/WINDOW).tolist(),
            sum_mav_median=float(np.median(fx[m,:8].sum(axis=1))))
    (OUT/'summary.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
    win = pd.DataFrame(dict(time_s=times,manual_class=y,raw_candidate=pred,
                           candidate_support=q,max_mav=fx[:,:8].max(axis=1),
                           stable_no_gate=outputs['no_gate'],stable_RH001=outputs['RH001'],scored=mask))
    win.to_csv(OUT/'window_diagnostics.csv',index=False)
    fig, axes = plt.subplots(3,1,figsize=(15,9),sharex=True,layout='constrained')
    for ch in range(8):axes[0].plot(times,fx[:,ch]/WINDOW,lw=.6,label=f'CH{ch+1}')
    axes[0].set(ylabel='MAV (ADC counts/sample)',title='Independent manually labeled recording; 100 ms windows / 25 ms hop')
    axes[0].legend(ncol=8,fontsize=8)
    axes[1].plot(times,q,lw=.6,label='Candidate support')
    axes[1].axhline(70,c='r',ls='--',label='New action 70')
    axes[1].axhline(50,c='gray',ls=':',label='Hold/rest 50')
    axes[1].set(ylabel='Model support (%)',ylim=(0,103));axes[1].legend(ncol=3)
    for name, values, offset in [('Manual label',y,0),('Argmax',pred,.08),('Stable / RH001 baseline scenario',outputs['RH001'],.16)]:
        axes[2].step(times,values+offset,where='post',lw=.8,label=name)
    axes[2].set(yticks=range(5),yticklabels=CLASSES,xlabel='Recording time (s)',ylabel='Class')
    axes[2].legend(ncol=3,loc='upper center')
    for ax in axes:ax.grid(alpha=.2)
    fig.savefig(OUT/'diagnostics.png',dpi=150)
    print(json.dumps({k:result[k] for k in ('duration_s','baselines','replay','c_crosscheck','line_noise')},indent=2))


if __name__=='__main__':
    main()
