"""Assess EMG008 against EMG007 without altering either capture."""
from pathlib import Path
import hashlib
import json
import struct
import sys

import numpy as np
from scipy import signal
from sklearn.metrics import accuracy_score, confusion_matrix, f1_score, classification_report
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

sys.path.insert(0, str(ROOT / "tools"))
from train_baseline import make_windows

NAMES = {1: "rest", 2: "open_hand", 3: "fist", 4: "wrist_flex", 5: "wrist_extend"}
CLASS_NAMES = ["rest", "open_hand", "fist", "wrist_flex", "wrist_extend"]
FS = 4000


def load_record(path):
    binary = Path(path).read_bytes()
    version, fs, chans, width, encoding, sources, code = struct.unpack_from("<7I", binary, 8)
    assert binary[:7] == b"SEMGSD1" and (version, fs, chans, width, encoding, sources, code) == (2, 4000, 8, 52, 1, 2, 3)
    assert (len(binary)-512) % width == 0
    frames = np.frombuffer(binary[512:], np.uint8).reshape(-1, width)
    seq = frames[:, 0].astype(np.int64) + 256*frames[:, 1].astype(np.int64)
    delta = np.diff(seq) % 65536
    assert np.all(delta == 1)
    label = frames[:, 2]
    assert set(np.unique(label)) <= set(NAMES)
    edges = np.r_[0, np.flatnonzero(label[1:] != label[:-1])+1, len(label)]
    segments = [dict(label=NAMES[int(label[a])], code=int(label[a]), start_s=a/fs, end_s=b/fs,
                     stable_start_s=a/fs+1, stable_end_s=b/fs-1, first=a, last=b)
                for a, b in zip(edges[:-1], edges[1:])]

    def decode(offset):
        b = frames[:, offset:offset+24].reshape(-1, 8, 3).astype(np.int32)
        x = b[:, :, 0] + (b[:, :, 1] << 8) + (b[:, :, 2] << 16)
        return ((x ^ 0x800000)-0x800000).astype(np.int32)

    return dict(path=str(path), binary=binary, frames=frames, seq=seq,
                raw=decode(4), processed=decode(28), segments=segments,
                header=dict(version=version, filter_code=code, filter_id=ProcessedSignal.FILTER_ID))


def welch(x, nperseg=4096):
    f, p = signal.welch(x, fs=FS, nperseg=nperseg,
                        noverlap=nperseg//2, detrend="linear", axis=0)
    assert np.isfinite(p).all()
    return f, p


def spectral(f, p):
    df = f[1]-f[0]
    band = (f >= 20) & (f <= 450)
    line = abs(f-50) <= 1
    harmonics = np.zeros(len(f), bool)
    for hz in range(100, 451, 50):
        harmonics |= (abs(f-hz) <= 1) & band
    clean = band & ~(line | harmonics)
    low, broad = (f >= .5) & (f < 20), (f >= .5) & (f <= 450)
    total = p[band].sum(axis=0)*df
    return dict(
        rms_20_450=np.sqrt(total).tolist(),
        mains_rms=np.sqrt(p[line].sum(axis=0)*df).tolist(),
        harmonic_rms=np.sqrt(p[harmonics].sum(axis=0)*df).tolist(),
        mains_percent=(100*p[line].sum(axis=0)*df/total).tolist(),
        harmonic_percent=(100*p[harmonics].sum(axis=0)*df/total).tolist(),
        clean_rms=np.sqrt(p[clean].sum(axis=0)*df).tolist(),
        low_rms=np.sqrt(p[low].sum(axis=0)*df).tolist(),
        low_percent=(100*p[low].sum(axis=0)/p[broad].sum(axis=0)).tolist())


def analyze_stream(record, key):
    x = record[key]
    ps, weights, rows = [], [], []
    for s in record["segments"]:
        a, b = round(s["stable_start_s"]*FS), round(s["stable_end_s"]*FS)
        f, p = welch(x[a:b])
        rows.append({"label":s["label"],"start_s":s["start_s"],"end_s":s["end_s"],
                     "stable_start_s":s["stable_start_s"],"stable_end_s":s["stable_end_s"],
                     **spectral(f,p), "mean":x[a:b].mean(axis=0).tolist()})
        ps.append(p)
        weights.append(b-a)
    total = np.average(ps, axis=0, weights=weights)
    return dict(stable=spectral(f,total), segments=rows, min=x.min(axis=0).tolist(),
                max=x.max(axis=0).tolist(), rails=int(((x <= -8388608) | (x >= 8388607)).sum()),
                max_fraction=float(abs(x).max()/8388608))


def extract_windows(record, excluded=()):
    feats, labels, info = [], [], []
    for segment_idx, s in enumerate(record["segments"]):
        a, b = round(s["stable_start_s"]*FS), round(s["stable_end_s"]*FS)
        x = record["processed"][a:b].astype(np.int64)
        y = np.full(len(x), s["code"]-1, np.int8)
        fx, fy = make_windows(x, y, window=400, hop=100)
        starts = a + 100*np.arange(len(fx))
        centers = (starts+200)/FS
        keep = np.ones(len(fx), bool)
        for lo, hi in excluded:
            keep &= ~((centers >= lo) & (centers < hi))
        feats.append(fx[keep])
        labels.append(fy[keep])
        info.extend(dict(segment_index=segment_idx,label=s["label"],center_s=float(t))
                    for t in centers[keep])
    return np.concatenate(feats), np.concatenate(labels), info


rec7 = load_record("F:/EMG007.BIN")
rec8 = load_record("F:/EMG008.BIN")
assert len([s for s in rec7["segments"] if s["label"] == "open_hand"]) == 3
for name in ("open_hand", "fist", "wrist_flex", "wrist_extend"):
    assert len([s for s in rec8["segments"] if s["label"] == name]) == 3

result = dict(
    input=rec8["path"], sha256=hashlib.sha256(rec8["binary"]).hexdigest(),
    bytes=len(rec8["binary"]), frames=len(rec8["frames"]), duration_s=len(rec8["frames"])/FS,
    sample_rate_hz=FS, format=rec8["header"],
    user_confirmation="Overnight re-wear; same channel/electrode locations and connections, no gel",
    integrity=dict(backward=0, duplicate=0, missing=0,
                   wraps=int(np.sum(np.diff(rec8["seq"]) < 0))),
    segments=[{k:s[k] for k in ("label","start_s","end_s","stable_start_s","stable_end_s")} for s in rec8["segments"]],
    streams={"raw":analyze_stream(rec8,"raw"),"processed":analyze_stream(rec8,"processed")},
    method=dict(trim_s=1, psd="Welch4096, 50% overlap, linear detrend, duration-weighted stable segments",
                spectral_units="ADC counts; frequencies use nominal 4000 Hz clock",
                line_half_width_hz=1,harmonics_hz=list(range(50,451,50)),
                repeated_validation="Train on EMG007 capture only, test on EMG008 only; 100ms windows, 25ms hop. Adjacent test windows overlap and are not independent trials."))

reference_checks=[]
for start_s in (0,55,135):
    lo,hi=start_s*FS,(start_s+8)*FS
    assert hi <= len(rec8["frames"])
    for ch in range(8):
        model=ProcessedSignal()
        predicted=np.array([model.step(int(v)) for v in rec8["raw"][lo:hi,ch]])
        err=predicted[5*FS:]-rec8["processed"][lo+5*FS:hi,ch]
        reference_checks.append(dict(interval_start_s=start_s+5,interval_end_s=start_s+8,
                                     channel=ch+1,max_abs_error=int(abs(err).max()),
                                     rmse=float(np.sqrt(np.mean(err.astype(float)**2)))))
assert max(x["max_abs_error"] for x in reference_checks) <= 5, reference_checks
result["integer_reference_checks_5s_after_local_start"] = reference_checks

# Matched initial-rest interval: the shorter rest lasts only 8.18 s.
matched = {}
for key in ("raw", "processed"):
    f7,p7 = welch(rec7[key][FS:7*FS])
    f8,p8 = welch(rec8[key][FS:7*FS])
    matched[key] = dict(EMG007=spectral(f7,p7), EMG008=spectral(f8,p8))
    for metric in ("mains_rms","harmonic_rms","clean_rms","low_rms"):
        matched[key]["change_db_008_vs_007_"+metric] = (20*np.log10(
            np.array(matched[key]["EMG008"][metric])/np.array(matched[key]["EMG007"][metric]))).tolist()
result["matched_rest_1_to_7s_vs_EMG007"] = matched

features7, y7, info7 = extract_windows(rec7)
features8, y8, info8 = extract_windows(rec8)
known_bad7 = ((169.30,169.80),(171.20,171.75),(171.75,172.05),
              (183.80,184.30),(241.50,242.20))
features7_clean, y7_clean, info7_clean = extract_windows(rec7, known_bad7)
rng = np.random.default_rng(20261022)
def balanced(x,y):
    ids = np.arange(len(y))
    counts = {c:int((y==c).sum()) for c in np.unique(y)}
    cap = int(np.median([n for c,n in counts.items() if c != 0]))
    rest = ids[y==0]
    chosen = np.sort(np.r_[ids[y!=0], rng.choice(rest,min(cap,len(rest)),replace=False)])
    return x[chosen],y[chosen],counts


def cross_test(train_x,train_y):
    bx,by,counts=balanced(train_x,train_y)
    seeds=[]
    for seed in (0,1,2,3,4):
        model=Pipeline([("scale",StandardScaler()),
                        ("mlp",MLPClassifier(hidden_layer_sizes=(64,32), max_iter=300,
                                             early_stopping=True,random_state=seed))])
        model.fit(bx,by)
        pred=model.predict(features8)
        seeds.append(dict(seed=seed,accuracy=float(accuracy_score(y8,pred)),
                          f1_macro=float(f1_score(y8,pred,average="macro")),
                          confusion=confusion_matrix(y8,pred,labels=range(5)).tolist(),
                          report=classification_report(y8,pred,labels=range(5),
                                                       target_names=CLASS_NAMES,output_dict=True,
                                                       zero_division=0)))
    return dict(training_windows_by_class={CLASS_NAMES[k]:v for k,v in counts.items()},
                balanced_training_windows=int(len(bx)),test_windows=int(len(y8)),
                train_mean_accuracy=float(np.mean([s["accuracy"] for s in seeds])),
                train_std_accuracy=float(np.std([s["accuracy"] for s in seeds],ddof=1)),
                mean_f1_macro=float(np.mean([s["f1_macro"] for s in seeds])),seeds=seeds)


result["model_cross_wear_test"] = dict(
    contract="tools/train_baseline.py window features MAV, WL, Energy, ZC, SSC; 400/100 samples; StandardScaler + MLP(64,32)",
    exclusions_from_emg007_only=[list(x) for x in known_bad7],
    all_emg007=cross_test(features7,y7),
    excluding_known_emg007_transient_windows=cross_test(features7_clean,y7_clean))

# Per-bout feature-energy table and obvious 100 ms burst concentration flags.
bursts=[]
for idx,s in enumerate(rec8["segments"]):
    a,b=round(s["stable_start_s"]*FS),round(s["stable_end_s"]*FS)
    x=rec8["processed"][a:b]
    n=len(x)//400
    rms=np.sqrt(np.mean(x[:n*400].reshape(n,400,8).astype(float)**2,axis=1))
    k=max(1,int(np.ceil(.1*n)))
    share=np.sort(rms*rms,axis=0)[-k:].sum(axis=0)/(rms*rms).sum(axis=0)
    bursts.append(dict(segment_index=idx,label=s["label"],start_s=s["start_s"],end_s=s["end_s"],
                       median_100ms_rms=np.median(rms,axis=0).tolist(),
                       p95_100ms_rms=np.percentile(rms,95,axis=0).tolist(),
                       top10percent_power_share=share.tolist()))
result["burst_metrics"] = bursts
(OUT/"EMG008_quality.json").write_text(json.dumps(result,indent=2),encoding="utf-8")

colors={"rest":"#d9e3ec","open_hand":"#a5d6a7","fist":"#ffcc80","wrist_flex":"#b39ddb","wrist_extend":"#81d4fa"}
fig,axes=plt.subplots(8,2,figsize=(18,13),sharex=True)
block=400;n=len(rec8["frames"])//block;times=(np.arange(n)+.5)*block/FS
for ch in range(8):
    raw=rec8["raw"][:n*block,ch].reshape(n,block)
    pro=rec8["processed"][:n*block,ch].reshape(n,block)
    axes[ch,0].fill_between(times,raw.min(axis=1)/1000,raw.max(axis=1)/1000,color="#255da8",alpha=.8,lw=0)
    axes[ch,1].plot(times,np.sqrt(np.mean(pro.astype(float)**2,axis=1)),lw=.8,color="#187f82")
    axes[ch,0].set_ylabel(f"CH{ch+1}\nkcount")
    for ax in axes[ch]:
        for s in rec8["segments"]:
            ax.axvspan(s["start_s"],s["end_s"],color=colors[s["label"]],alpha=.3)
        ax.grid(alpha=.2)
axes[0,0].set_title("RAW extrema / 100 ms");axes[0,1].set_title("Actual processed / 100 ms RMS")
axes[-1,0].set_xlabel("Saved time (s)");axes[-1,1].set_xlabel("Saved time (s)")
fig.legend(handles=[Patch(facecolor=c,alpha=.5,label=l) for l,c in colors.items()],loc="upper center",ncol=5,frameon=False)
fig.tight_layout(rect=(0,0,1,.97));fig.savefig(OUT/"EMG008_waveform_quality.png",dpi=130);plt.close(fig)

fig,axes=plt.subplots(4,2,figsize=(15,13),sharex=True)
for ch,ax in enumerate(axes.flat):
    for key,color in (("raw","#a95732"),("processed","#187f82")):
        x=rec8[key]
        pp,ww=[] ,[]
        for s in rec8["segments"]:
            lo,hi=round(s["stable_start_s"]*FS),round(s["stable_end_s"]*FS)
            f,p=welch(x[lo:hi]);pp.append(p);ww.append(hi-lo)
        p=np.average(pp,axis=0,weights=ww);m=(f>=1)&(f<=450)
        ax.plot(f[m],10*np.log10(np.maximum(p[m,ch],1e-12)),label=key,lw=.8,color=color)
    for hz in range(50,451,50):ax.axvline(hz,color="gray",alpha=.2,lw=.6)
    ax.set_title(f"CH{ch+1}");ax.set_ylabel("PSD dB count²/Hz");ax.grid(alpha=.2)
axes[0,0].legend();axes[-1,0].set_xlabel("Hz");axes[-1,1].set_xlabel("Hz")
fig.tight_layout();fig.savefig(OUT/"EMG008_spectrum_quality.png",dpi=130);plt.close(fig)

print("RECORD",json.dumps({k:result[k] for k in ("bytes","frames","duration_s","format","integrity")}))
print("INITIAL_REST",json.dumps(matched))
print("REFERENCE",json.dumps({"max_abs_error":max(x["max_abs_error"] for x in reference_checks),
                              "rmse_by_channel_and_start":reference_checks}))
print("MODEL_ALL",json.dumps(result["model_cross_wear_test"]["all_emg007"]))
print("MODEL_CLEAN",json.dumps(result["model_cross_wear_test"]["excluding_known_emg007_transient_windows"]))
print("BURSTS",json.dumps([dict(label=x["label"],start_s=x["start_s"],channels=[i+1 for i,v in enumerate(x["top10percent_power_share"]) if v>.5],share=np.round(x["top10percent_power_share"],2).tolist()) for x in bursts]))
print("TEST_PASS EMG008 continuous framing, all four repeat pairs, finite spectra and external re-wear evaluation",flush=True)
