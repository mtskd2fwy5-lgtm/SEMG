"""Reproducible quality and re-wear transfer assessment for EMG010."""
from pathlib import Path
import hashlib
import json
import struct
import sys

import numpy as np
from scipy import signal
from sklearn.metrics import accuracy_score, confusion_matrix, f1_score, classification_report
from sklearn.model_selection import GroupKFold
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import Pipeline
from sklearn.neural_network import MLPClassifier
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.patches import Patch

ROOT = Path(__file__).resolve().parents[2]
OUT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT / "tools"))
from emg_reference import ProcessedSignal
from train_baseline import make_windows

FS = 4000
NAMES = {1: "rest", 2: "open_hand", 3: "fist", 4: "wrist_flex", 5: "wrist_extend"}
CLASS_NAMES = ["rest", "open_hand", "fist", "wrist_flex", "wrist_extend"]
COLORS = {"rest":"#d9e3ec", "open_hand":"#a5d6a7", "fist":"#ffcc80",
          "wrist_flex":"#b39ddb", "wrist_extend":"#81d4fa"}


def load_record(path, decode_raw=True, decode_processed=True):
    blob = Path(path).read_bytes()
    version, fs, chans, width, encoding, sources, code = struct.unpack_from("<7I", blob, 8)
    assert blob[:7] == b"SEMGSD1" and (version, fs, chans, width, encoding, sources, code) == (2, 4000, 8, 52, 1, 2, 3)
    assert (len(blob)-512) % width == 0
    frames = np.frombuffer(blob, np.uint8, offset=512).reshape(-1, width)
    seq = frames[:, 0].astype(np.int64) + 256*frames[:, 1].astype(np.int64)
    delta = np.diff(seq) % 65536
    assert np.all(delta == 1), (path, np.unique(delta, return_counts=True))
    labels = frames[:, 2]
    assert set(np.unique(labels)) <= set(NAMES)
    edges = np.r_[0, np.flatnonzero(labels[1:] != labels[:-1])+1, len(labels)]
    segments = [dict(label=NAMES[int(labels[a])], code=int(labels[a]), start_s=a/FS, end_s=b/FS,
                     stable_start_s=a/FS+1, stable_end_s=b/FS-1, first=a, last=b)
                for a,b in zip(edges[:-1], edges[1:])]

    def decode(offset):
        b = frames[:, offset:offset+24].reshape(-1,8,3).astype(np.int32)
        x = b[:,:,0] + (b[:,:,1] << 8) + (b[:,:,2] << 16)
        return ((x ^ 0x800000)-0x800000).astype(np.int32)

    return dict(path=str(path), blob=blob, frames=frames, seq=seq, segments=segments,
                raw=decode(4) if decode_raw else None,
                processed=decode(28) if decode_processed else None,
                header=dict(version=version, fs=fs, channels=chans, frame_bytes=width, filter_code=code))


def welch(x, nperseg=4096):
    f,p = signal.welch(x, fs=FS, nperseg=nperseg, noverlap=nperseg//2,
                       detrend="linear", axis=0)
    assert np.isfinite(p).all()
    return f,p


def spectral(f,p):
    df=f[1]-f[0]
    band=(f>=20)&(f<=450)
    mains=abs(f-50)<=1
    harm=np.zeros(len(f),bool)
    for hz in range(100,451,50): harm |= (abs(f-hz)<=1)&band
    clean=band&~(mains|harm)
    low=(f>=.5)&(f<20)
    broad=(f>=.5)&(f<=450)
    total=p[band].sum(axis=0)*df
    return dict(rms_20_450=np.sqrt(total).tolist(),
                mains_rms=np.sqrt(p[mains].sum(axis=0)*df).tolist(),
                harmonic_rms=np.sqrt(p[harm].sum(axis=0)*df).tolist(),
                mains_percent=(100*p[mains].sum(axis=0)*df/total).tolist(),
                harmonic_percent=(100*p[harm].sum(axis=0)*df/total).tolist(),
                clean_rms=np.sqrt(p[clean].sum(axis=0)*df).tolist(),
                low_rms=np.sqrt(p[low].sum(axis=0)*df).tolist(),
                low_percent=(100*p[low].sum(axis=0)/p[broad].sum(axis=0)).tolist())


def pc1_fraction(x):
    """Fraction of centered eight-channel variance in the first PCA component."""
    x=np.asarray(x,dtype=np.float64)
    x=x-x.mean(axis=0,keepdims=True)
    cov=x.T@x/max(1,len(x)-1)
    eig=np.linalg.eigvalsh(cov)
    return float(eig[-1]/eig.sum())


def analyze_stream(rec,key):
    x=rec[key]
    ps=[]; weights=[]; rows=[]
    for s in rec["segments"]:
        a,b=round(s["stable_start_s"]*FS),round(s["stable_end_s"]*FS)
        if b-a < 4096: continue
        f,p=welch(x[a:b])
        rows.append(dict(label=s["label"],start_s=s["start_s"],end_s=s["end_s"],
                         **spectral(f,p),mean=x[a:b].mean(axis=0).tolist()))
        ps.append(p);weights.append(b-a)
    total=np.average(ps,axis=0,weights=weights)
    return dict(stable=spectral(f,total),segments=rows,min=x.min(axis=0).tolist(),
                max=x.max(axis=0).tolist(),
                rails=int(((x<=-8388608)|(x>=8388607)).sum()),
                max_fraction=float(abs(x).max()/8388608)), (f,total)


def window_features(rec):
    all_x=[]; all_y=[]; all_info=[]
    for idx,s in enumerate(rec["segments"]):
        a,b=round(s["stable_start_s"]*FS),round(s["stable_end_s"]*FS)
        if b-a < 400: continue
        x=rec["processed"][a:b].astype(np.int64)
        y=np.full(len(x),s["code"]-1,np.int8)
        fx,fy=make_windows(x,y,window=400,hop=100)
        centers=(a+100*np.arange(len(fx))+200)/FS
        all_x.append(fx);all_y.append(fy)
        all_info.extend(dict(segment_index=idx,label=s["label"],center_s=float(t)) for t in centers)
    return np.concatenate(all_x),np.concatenate(all_y),all_info


def balanced(x,y,seed):
    rng=np.random.default_rng(seed)
    ids=np.arange(len(y)); counts={c:int((y==c).sum()) for c in np.unique(y)}
    cap=int(np.median([n for c,n in counts.items() if c!=0]))
    rest=ids[y==0]
    chosen=np.sort(np.r_[ids[y!=0],rng.choice(rest,min(cap,len(rest)),replace=False)])
    return x[chosen],y[chosen],counts


def evaluate(train_x,train_y,test_x,test_y,test_info,name):
    bx,by,counts=balanced(train_x,train_y,20261023)
    seeds=[]
    for seed in range(5):
        model=Pipeline([("scale",StandardScaler()),
                        ("mlp",MLPClassifier(hidden_layer_sizes=(64,32),max_iter=300,
                                              early_stopping=True,random_state=seed))])
        model.fit(bx,by);pred=model.predict(test_x)
        report=classification_report(test_y,pred,labels=range(5),target_names=CLASS_NAMES,
                                     output_dict=True,zero_division=0)
        # One majority vote per labeled action/rest bout; this is a useful
        # complementary count, not an independent population estimate.
        votes={}
        for info,predicted in zip(test_info,pred):
            votes.setdefault(info["segment_index"],[]).append(int(predicted))
        bout=[]
        for seg,ps in votes.items():
            label=test_info[next(i for i,z in enumerate(test_info) if z["segment_index"]==seg)]["label"]
            truth=CLASS_NAMES.index(label)
            counts_pred=np.bincount(ps,minlength=5)
            bout.append(dict(label=label,predicted=CLASS_NAMES[int(counts_pred.argmax())],
                             correct=bool(counts_pred.argmax()==truth),n_windows=len(ps)))
        action_bouts=[z for z in bout if z["label"]!="rest"]
        seeds.append(dict(seed=seed,accuracy=float(accuracy_score(test_y,pred)),
                          f1_macro=float(f1_score(test_y,pred,average="macro")),
                          confusion=confusion_matrix(test_y,pred,labels=range(5)).tolist(),
                          per_class={k:{m:float(report[k][m]) for m in ("precision","recall","f1-score","support")}
                                     for k in CLASS_NAMES},bout_accuracy=float(np.mean([z["correct"] for z in bout])),
                          action_bout_accuracy=float(np.mean([z["correct"] for z in action_bouts])),
                          bouts=bout))
    return dict(name=name,contract="tools/train_baseline.py features MAV/WL/Energy/ZC/SSC, 8 channels; 100 ms/25 ms; StandardScaler + MLP(64,32)",
                train_windows_by_class={CLASS_NAMES[k]:v for k,v in counts.items()},
                train_balanced_windows=int(len(by)),test_windows=int(len(test_y)),
                accuracy_mean=float(np.mean([z["accuracy"] for z in seeds])),
                accuracy_sd=float(np.std([z["accuracy"] for z in seeds],ddof=1)),
                macro_f1_mean=float(np.mean([z["f1_macro"] for z in seeds])),
                bout_accuracy_mean=float(np.mean([z["bout_accuracy"] for z in seeds])),
                action_bout_accuracy_mean=float(np.mean([z["action_bout_accuracy"] for z in seeds])),
                action_bout_correct_by_class={c:sum(z["correct"] for seed in seeds for z in seed["bouts"] if z["label"]==c)
                                              for c in CLASS_NAMES[1:]},
                action_bout_count_by_class={c:sum(1 for seed in seeds for z in seed["bouts"] if z["label"]==c)
                                            for c in CLASS_NAMES[1:]},seeds=seeds)


def evaluate_grouped(x,y,info):
    """Leave whole labeled bouts out so overlapping windows cannot cross splits."""
    groups=np.asarray([z["segment_index"] for z in info],dtype=np.int32)
    splitter=GroupKFold(n_splits=5)
    folds=list(splitter.split(x,y,groups))
    seeds=[]
    for seed in range(5):
        pred=np.full(len(y),-1,dtype=np.int8)
        for fold,(tr,te) in enumerate(folds):
            bx,by,_=balanced(x[tr],y[tr],seed*10+fold)
            model=Pipeline([("scale",StandardScaler()),
                            ("mlp",MLPClassifier(hidden_layer_sizes=(64,32),max_iter=300,
                                                  early_stopping=True,random_state=seed))])
            model.fit(bx,by);pred[te]=model.predict(x[te])
        assert np.all(pred>=0)
        report=classification_report(y,pred,labels=range(5),target_names=CLASS_NAMES,
                                     output_dict=True,zero_division=0)
        bouts=[]
        for group in sorted(set(groups.tolist())):
            ix=np.flatnonzero(groups==group)
            counts=np.bincount(pred[ix],minlength=5)
            true=int(y[ix[0]]);guess=int(counts.argmax())
            bouts.append(dict(label=CLASS_NAMES[true],predicted=CLASS_NAMES[guess],
                              correct=bool(true==guess),n_windows=int(len(ix))))
        actions=[z for z in bouts if z["label"]!="rest"]
        seeds.append(dict(seed=seed,accuracy=float(accuracy_score(y,pred)),
                          f1_macro=float(f1_score(y,pred,average="macro")),
                          confusion=confusion_matrix(y,pred,labels=range(5)).tolist(),
                          per_class={c:{m:float(report[c][m]) for m in ("precision","recall","f1-score","support")}
                                     for c in CLASS_NAMES},
                          action_bout_accuracy=float(np.mean([z["correct"] for z in actions])),
                          bouts=bouts))
    return dict(name="EMG010 within-rewear grouped 5-fold validation",
                contract="same 100 ms/25 ms feature windows; GroupKFold splits entire labeled segments, so a segment never appears in both train and test",
                action_segments_by_class={c:len(set(g for g,z in zip(groups,info) if z["label"]==c))
                                          for c in CLASS_NAMES[1:]},
                windows=int(len(y)),accuracy_mean=float(np.mean([z["accuracy"] for z in seeds])),
                accuracy_sd=float(np.std([z["accuracy"] for z in seeds],ddof=1)),
                macro_f1_mean=float(np.mean([z["f1_macro"] for z in seeds])),
                action_bout_accuracy_mean=float(np.mean([z["action_bout_accuracy"] for z in seeds])),
                seeds=seeds)


def main():
    r9=load_record("F:/EMG010.BIN")
    assert len([s for s in r9["segments"] if s["label"]=="open_hand"])>=3
    for name in ("fist","wrist_flex","wrist_extend"):
        assert len([s for s in r9["segments"] if s["label"]==name])>=3
    raw_metrics,raw_psd=analyze_stream(r9,"raw")
    processed_metrics,proc_psd=analyze_stream(r9,"processed")

    # Verify the saved processed stream against the project's integer reference
    # after local filter warm-up, on start/middle/end regions and every channel.
    reference=[]
    for start_s in (0,80,180,260):
        lo,hi=start_s*FS,(start_s+8)*FS
        for ch in range(8):
            filt=ProcessedSignal()
            pred=np.array([filt.step(int(v)) for v in r9["raw"][lo:hi,ch]])
            err=pred[5*FS:]-r9["processed"][lo+5*FS:hi,ch]
            reference.append(dict(start_s=start_s+5,end_s=start_s+8,channel=ch+1,
                                  max_abs_error=int(abs(err).max()),rmse=float(np.sqrt(np.mean(err.astype(float)**2)))))
    assert max(x["max_abs_error"] for x in reference)<=5,reference

    # Matched 1-7 s rest window versus the prior no-rewear EMG009 recording.
    r8=load_record("F:/EMG009.BIN")
    matched={}
    for key in ("raw","processed"):
        f,p8=welch(r8[key][FS:7*FS]);_,p9=welch(r9[key][FS:7*FS])
        m8=spectral(f,p8);m9=spectral(f,p9)
        matched[key]=dict(EMG009=m8,EMG010=m9)
        for metric in ("rms_20_450","mains_rms","harmonic_rms","clean_rms","low_rms"):
            matched[key]["change_db_010_vs_009_"+metric]=(20*np.log10(
                np.maximum(m9[metric],1e-12)/np.maximum(m8[metric],1e-12))).tolist()
    matched_common_mode={}
    for key in ("raw","processed"):
        a=pc1_fraction(r8[key][FS:7*FS]);b=pc1_fraction(r9[key][FS:7*FS])
        matched_common_mode[key]=dict(EMG009=a,EMG010=b,change_percentage_points=100*(b-a))

    # Features are extracted from labeled segments after trimming 1 s at both
    # ends. EMG009 is the direct pre-rewear train capture; EMG008+009 is also
    # included as a mixed-capture supplemental baseline.
    x9,y9,i9=window_features(r9)
    model_within=evaluate_grouped(x9,y9,i9)
    x8,y8,_=window_features(r8)
    del r8
    r7=load_record("F:/EMG008.BIN",decode_raw=False,decode_processed=True)
    x7,y7,_=window_features(r7)
    del r7
    model_rewear=evaluate(x8,y8,x9,y9,i9,"EMG009 train -> EMG010 test (rewear)")
    model_mixed=evaluate(np.concatenate([x7,x8]),np.concatenate([y7,y8]),x9,y9,i9,
                         "EMG008+EMG009 train -> EMG010 test (rewear, two prior captures)")

    # 100 ms envelope concentration, to expose short bursts dominating a bout.
    burst=[]
    for idx,s in enumerate(r9["segments"]):
        a,b=round(s["stable_start_s"]*FS),round(s["stable_end_s"]*FS)
        n=(b-a)//400
        if n<1: continue
        q=r9["processed"][a:a+n*400].reshape(n,400,8).astype(float)
        rms=np.sqrt(np.mean(q*q,axis=1)); k=max(1,int(np.ceil(.1*n)))
        share=np.sort(rms*rms,axis=0)[-k:].sum(axis=0)/(rms*rms).sum(axis=0)
        burst.append(dict(segment_index=idx,label=s["label"],start_s=s["start_s"],end_s=s["end_s"],
                          median_100ms_rms=np.median(rms,axis=0).tolist(),p95_100ms_rms=np.percentile(rms,95,axis=0).tolist(),
                          top10percent_power_share=share.tolist()))

    result=dict(input=r9["path"],sha256=hashlib.sha256(r9["blob"]).hexdigest(),bytes=len(r9["blob"]),
                frames=len(r9["frames"]),duration_s=len(r9["frames"])/FS,sample_rate_hz=FS,
                format=r9["header"],user_confirmation="Same electrode/setup conditions as EMG009, but re-worn; no gel per prior confirmation; CH1-6 wrist and CH7-8 near elbow",
                integrity=dict(backward=0,duplicate=0,missing=0,wraps=int(np.sum(np.diff(r9["seq"])<0))),
                segments=[{k:s[k] for k in ("label","start_s","end_s","stable_start_s","stable_end_s")} for s in r9["segments"]],
                streams={"raw":raw_metrics,"processed":processed_metrics},
                matched_rest_1_to_7s_vs_EMG009=matched,
                matched_rest_common_mode_1_to_7s=matched_common_mode,
                reference_checks=reference,
                model_within_rewear_grouped_cv=model_within,
                model_rewear=model_rewear,model_two_capture_rewear=model_mixed,bursts=burst,
                method=dict(trim_s=1,psd="Welch 4096, 50% overlap, linear detrend; duration-weighted stable segments",
                            line_half_width_hz=1,harmonics_hz=list(range(50,451,50)),
                            model="five random initializations; rest balanced to median movement windows",
                            caveat="25 ms hop means adjacent 100 ms evaluation windows overlap 75%; bouts, not windows, are the independent repeats here."))
    (OUT/"EMG010_quality.json").write_text(json.dumps(result,indent=2),encoding="utf-8")

    # Time overview: raw extrema and final signed waveform RMS at 100 ms.
    fig,axes=plt.subplots(8,2,figsize=(18,13),sharex=True)
    block=400;n=len(r9["frames"])//block;times=(np.arange(n)+.5)*block/FS
    for ch in range(8):
        raw=r9["raw"][:n*block,ch].reshape(n,block)
        pro=r9["processed"][:n*block,ch].reshape(n,block)
        axes[ch,0].fill_between(times,raw.min(axis=1)/1000,raw.max(axis=1)/1000,color="#255da8",alpha=.8,lw=0)
        axes[ch,1].plot(times,np.sqrt(np.mean(pro.astype(float)**2,axis=1)),lw=.8,color="#187f82")
        axes[ch,0].set_ylabel(f"CH{ch+1}\nkcount")
        for ax in axes[ch]:
            for s in r9["segments"]: ax.axvspan(s["start_s"],s["end_s"],color=COLORS[s["label"]],alpha=.3)
            ax.grid(alpha=.2)
    axes[0,0].set_title("RAW extrema / 100 ms");axes[0,1].set_title("Final signed processed RMS / 100 ms")
    axes[-1,0].set_xlabel("Saved time (s)");axes[-1,1].set_xlabel("Saved time (s)")
    fig.legend(handles=[Patch(facecolor=c,alpha=.5,label=l) for l,c in COLORS.items()],loc="upper center",ncol=5,frameon=False)
    fig.tight_layout(rect=(0,0,1,.97));fig.savefig(OUT/"EMG010_waveform_quality.png",dpi=130);plt.close(fig)

    # Aggregate spectra use the same stationary segments and bins for all channels.
    f,pr=raw_psd;_,pp=proc_psd
    fig,axes=plt.subplots(4,2,figsize=(15,13),sharex=True)
    for ch,ax in enumerate(axes.flat):
        for p,label,color in ((pr,"raw","#a95732"),(pp,"processed","#187f82")):
            m=(f>=1)&(f<=450)
            ax.plot(f[m],10*np.log10(np.maximum(p[m,ch],1e-12)),label=label,lw=.8,color=color)
        for hz in range(50,451,50):ax.axvline(hz,color="gray",alpha=.2,lw=.6)
        ax.set_title(f"CH{ch+1}");ax.set_ylabel("PSD dB count²/Hz");ax.grid(alpha=.2)
    axes[0,0].legend();axes[-1,0].set_xlabel("Hz");axes[-1,1].set_xlabel("Hz")
    fig.tight_layout();fig.savefig(OUT/"EMG010_spectrum_quality.png",dpi=130);plt.close(fig)

    print("RECORD",json.dumps({k:result[k] for k in ("bytes","frames","duration_s","format","integrity")}))
    print("INITIAL_REST",json.dumps({k:{m:v for m,v in z.items() if m.startswith("change_db")}
                                   for k,z in matched.items()}))
    print("INITIAL_REST_COMMON_MODE",json.dumps(matched_common_mode))
    print("STREAMS",json.dumps({k:v["stable"] for k,v in result["streams"].items()}))
    print("REFERENCE_MAX_ERROR",max(x["max_abs_error"] for x in reference))
    print("MODEL_REWEAR",json.dumps({k:v for k,v in model_rewear.items() if k!="seeds"}))
    print("MODEL_MIXED",json.dumps({k:v for k,v in model_mixed.items() if k!="seeds"}))
    print("MODEL_WITHIN_REWEAR",json.dumps({k:v for k,v in model_within.items() if k!="seeds"}))
    print("MODEL_CLASS_MEAN",json.dumps({name:{c:{metric:float(np.mean([seed["per_class"][c][metric] for seed in model["seeds"]]))
                                                   for metric in ("recall","f1-score")}
                                             for c in CLASS_NAMES} for name,model in (("rewear",model_rewear),("two_capture",model_mixed))}))
    print("BURST_FLAGS",json.dumps([{k:z[k] for k in ("label","start_s","end_s","top10percent_power_share")} for z in burst]))
    print("TEST_PASS EMG010 framing, labels, finite PSD, reference chain, rewear and prior-capture held-out models",flush=True)


if __name__=="__main__": main()
