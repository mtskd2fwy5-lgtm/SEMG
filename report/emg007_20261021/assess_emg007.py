"""Assess actual EMG007 board outputs, preserving source and provenance."""
from pathlib import Path
import hashlib
import json
import struct
import sys

import numpy as np
from scipy import signal
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.patches import Patch

ROOT = Path(__file__).resolve().parents[2]
OUT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT / "tools"))
from emg_reference import Notch50, ProcessedSignal

SOURCE = Path("F:/EMG007.BIN")
binary = SOURCE.read_bytes()
version, fs, channels, width, encoding, sources, code = struct.unpack_from("<7I", binary, 8)
assert binary[:7] == b"SEMGSD1" and (version, fs, channels, width, encoding, sources, code) == (2, 4000, 8, 52, 1, 2, 3)
assert (len(binary) - 512) % width == 0
frames = np.frombuffer(binary[512:], np.uint8).reshape(-1, width)
seq = frames[:, 0].astype(np.int64) + 256 * frames[:, 1].astype(np.int64)
delta = np.diff(seq) % 65536
assert np.all(delta == 1), "EMG007 must be segmented at discontinuities"
labels = frames[:, 2]
names = {1: "rest", 2: "open_hand", 3: "fist", 4: "wrist_flex", 5: "wrist_extend"}
assert set(np.unique(labels)) <= set(names)
edges = np.r_[0, np.flatnonzero(labels[1:] != labels[:-1]) + 1, len(labels)]
segments = [dict(label=names[int(labels[a])], start_s=a/fs, end_s=b/fs,
                 stable_start_s=a/fs + 1, stable_end_s=b/fs - 1)
            for a, b in zip(edges[:-1], edges[1:])]


def decode(offset):
    b = frames[:, offset:offset + 24].reshape(-1, 8, 3).astype(np.int32)
    x = b[:, :, 0] + (b[:, :, 1] << 8) + (b[:, :, 2] << 16)
    return ((x ^ 0x800000) - 0x800000).astype(float)


def psd(x):
    assert len(x) >= 8192
    f, p = signal.welch(x, fs=fs, nperseg=8192, noverlap=4096, detrend="linear", axis=0)
    assert np.isfinite(p).all()
    return f, p


def spectral_stats(f, p):
    df = f[1] - f[0]
    band = (f >= 20) & (f <= 450)
    line = abs(f - 50) <= 1
    harmonic = np.zeros(len(f), bool)
    masks = {}
    for hz in range(100, 451, 50):
        masks[str(hz)] = (abs(f - hz) <= 1) & band
        harmonic |= masks[str(hz)]
    clean = band & ~(line | harmonic)
    low, broad = (f >= 0.5) & (f < 20), (f >= 0.5) & (f <= 450)
    total = p[band].sum(axis=0) * df
    assert np.all(total > 0)
    return dict(
        rms_20_450=np.sqrt(total).tolist(),
        rms_excluding_line_bands=np.sqrt(p[clean].sum(axis=0) * df).tolist(),
        mains_rms=np.sqrt(p[line].sum(axis=0) * df).tolist(),
        harmonic_neighborhood_rms=np.sqrt(p[harmonic].sum(axis=0) * df).tolist(),
        mains_percent=(100 * p[line].sum(axis=0) * df / total).tolist(),
        harmonics_100_to_450_percent=(100 * p[harmonic].sum(axis=0) * df / total).tolist(),
        harmonic_percent_by_frequency={hz: (100*p[m].sum(axis=0)*df/total).tolist() for hz, m in masks.items()},
        harmonic_rms_by_frequency={hz: np.sqrt(p[m].sum(axis=0)*df).tolist() for hz, m in masks.items()},
        low_frequency_percent=(100*p[low].sum(axis=0)/p[broad].sum(axis=0)).tolist(),
        low_frequency_rms=np.sqrt(p[low].sum(axis=0)*df).tolist(),
    )


streams = {"raw": decode(4), "processed": decode(28)}
# The old float transfer on exactly this raw input separates filter changes
# from differences between captures. It is not a third board-recorded lane.
b = np.array([Notch50.B0, Notch50.B1, Notch50.B0], float) / 2**24
a = np.array([1, Notch50.B1 / 2**24, Notch50.A2 / 2**24])
legacy = signal.lfilter(b, a, streams["raw"], axis=0)
spectra, results = {}, {}
for name, x in {**streams, "legacy_notch_float_same_raw": legacy}.items():
    powers, weights, rows = [], [], []
    for seg in segments:
        lo, hi = round(seg["stable_start_s"]*fs), round(seg["stable_end_s"]*fs)
        f, p = psd(x[lo:hi])
        rows.append({**seg, **spectral_stats(f, p),
                     "mean": x[lo:hi].mean(axis=0).tolist(),
                     "median": np.median(x[lo:hi], axis=0).tolist()})
        powers.append(p)
        weights.append(hi-lo)
    p = np.average(powers, axis=0, weights=weights)
    spectra[name] = (f, p)
    results[name] = dict(stable=spectral_stats(f, p), segments=rows)
    if name in streams:
        results[name].update(
            min=x.min(axis=0).tolist(), max=x.max(axis=0).tolist(),
            rail_count=((x <= -8388608) | (x >= 8388607)).sum(axis=0).tolist(),
            max_abs_fraction_full_scale=(abs(x).max(axis=0)/8388608).tolist(),
            median=np.median(x, axis=0).tolist(),
            positive_fraction=(x > 0).mean(axis=0).tolist(),
            negative_fraction=(x < 0).mean(axis=0).tolist(),
        )

summary = dict(
    input=str(SOURCE), sha256=hashlib.sha256(binary).hexdigest(),
    bytes=len(binary), frames=len(frames), duration_s=len(frames)/fs, sample_rate_hz=fs,
    header=dict(version=version, filter_code=code, filter_id=ProcessedSignal.FILTER_ID),
    user_confirmation="Only BOOT changed vs EMG006; CH1-6 wrist, CH7-8 near elbow, all EMG",
    segments=segments, streams=results,
    integrity=dict(forward_missing=0, backwards=0, adjacent_duplicates=0,
                   wraps=int(np.sum(np.diff(seq) < 0)),
                   first_sequence=int(seq[0]), last_sequence=int(seq[-1]),
                   startup_payload_replay_at512=bool(np.array_equal(frames[:339, 4:], frames[512:851, 4:]))),
    method=dict(trim_s=1, psd="Welch8192, 50% overlap, linear detrend, duration-weighted stable segments",
                line_half_width_hz=1, harmonics_hz=list(range(50, 451, 50)),
                units="ADC counts, no unverified voltage conversion",
                repeat_limits="Three labeled bouts per action, same capture and same wearing; not independent validation",
                synthetic_legacy="Float Q24-coefficient old single-notch transfer on identical raw; not measured old firmware"),
)

refrows = 12*fs
refcheck = []
for ch in range(8):
    model, oldmodel = ProcessedSignal(), Notch50()
    pred = np.array([model.step(int(v)) for v in streams["raw"][:refrows, ch]])
    old = np.array([oldmodel.step(int(v)) for v in streams["raw"][:refrows, ch]])
    e = pred[5*fs:] - streams["processed"][5*fs:refrows, ch]
    old_e = old[5*fs:] - legacy[5*fs:refrows, ch]
    refcheck.append(dict(channel=ch+1, max_abs_error=float(abs(e).max()),
                         rmse=float(np.sqrt(np.mean(e*e))),
                         p99_abs_error=float(np.percentile(abs(e), 99)),
                         old_float_vs_integer_max_error=float(abs(old_e).max())))
summary["integer_reference_5_to_12s"] = refcheck
spot_checks = []
for start_s in (165, 234, 279):
    lo, hi = start_s*fs, (start_s+12)*fs
    assert hi <= len(frames)
    for ch in range(8):
        model = ProcessedSignal()
        pred = np.array([model.step(int(v)) for v in streams["raw"][lo:hi, ch]])
        e = pred[5*fs:] - streams["processed"][lo+5*fs:hi, ch]
        spot_checks.append(dict(start_s=start_s+5, end_s=start_s+12, channel=ch+1,
                                 max_abs_error=float(abs(e).max()),
                                 rmse=float(np.sqrt(np.mean(e*e)))))
summary["integer_reference_middle_transients_and_end"] = spot_checks

attenuations = {}
for metric in ("mains_rms", "harmonic_neighborhood_rms", "low_frequency_rms"):
    raw = np.array(results["raw"]["stable"][metric])
    pro = np.array(results["processed"]["stable"][metric])
    old = np.array(results["legacy_notch_float_same_raw"]["stable"][metric])
    attenuations[metric] = dict(raw_to_processed_db=(20*np.log10(raw/pro)).tolist(),
                                legacy_float_to_processed_db=(20*np.log10(old/pro)).tolist())
summary["attenuation_db"] = attenuations
summary["harmonic_attenuation_by_frequency_db"] = {
    hz: (20*np.log10(np.array(results["raw"]["stable"]["harmonic_rms_by_frequency"][hz]) /
                     np.array(results["processed"]["stable"]["harmonic_rms_by_frequency"][hz]))).tolist()
    for hz in results["raw"]["stable"]["harmonic_rms_by_frequency"]}

bursts, actions = [], []
for i, seg in enumerate(segments):
    lo, hi = round(seg["stable_start_s"]*fs), round(seg["stable_end_s"]*fs)
    x = streams["processed"][lo:hi]
    n = len(x)//400
    rms = np.sqrt(np.mean(x[:n*400].reshape(n, 400, 8)**2, axis=1))
    k = int(np.ceil(n*0.1))
    top = np.argsort(rms[:, 4])[-min(10, n):][::-1]
    peak_index = np.argmax(rms, axis=0)
    item = dict(**seg, median_100ms_rms=np.median(rms, axis=0).tolist(),
                p95_100ms_rms=np.percentile(rms, 95, axis=0).tolist(),
                time_domain_rms=np.sqrt(np.mean(x*x, axis=0)).tolist(),
                peak_100ms_rms=rms[peak_index, np.arange(8)].tolist(),
                peak_100ms_times_s=(lo/fs+(peak_index+0.5)*0.1).tolist(),
                top10percent_windows_power_share=(np.sort(rms*rms, axis=0)[-k:].sum(axis=0)/(rms*rms).sum(axis=0)).tolist(),
                ch5_top_window_times_s=(lo/fs+(top+0.5)*0.1).tolist(),
                ch5_top_window_rms=rms[top, 4].tolist())
    bursts.append(item)
    if seg["label"] != "rest":
        j = max(j for j in range(i) if segments[j]["label"] == "rest")
        active = np.array(results["processed"]["segments"][i]["rms_excluding_line_bands"])
        rest = np.array(results["processed"]["segments"][j]["rms_excluding_line_bands"])
        medratio = np.array(item["median_100ms_rms"])/np.array(bursts[j]["median_100ms_rms"])
        actions.append(dict(segment_index=i, reference_rest_index=j,
                            reference_rest_immediately_preceding=(j == i-1), **seg,
                            rms=active.tolist(), rms_ratio=(active/rest).tolist(),
                            median_100ms_ratio=medratio.tolist()))
summary["burst_metrics"] = bursts
summary["transient_flags"] = [
    dict(segment_index=i, label=row["label"], channel=ch+1,
         start_s=row["start_s"], end_s=row["end_s"],
         top10percent_windows_power_share=share,
         median_100ms_rms=row["median_100ms_rms"][ch],
         peak_100ms_rms=row["peak_100ms_rms"][ch],
         peak_time_s=row["peak_100ms_times_s"][ch],
         time_domain_rms=row["time_domain_rms"][ch])
    for i, row in enumerate(bursts)
    for ch, share in enumerate(row["top10percent_windows_power_share"]) if share > 0.5
]
summary["action_vs_nearest_preceding_rest"] = actions
repeat = {}
for label in ("open_hand", "fist", "wrist_flex", "wrist_extend"):
    group = np.array([row["rms"] for row in actions if row["label"] == label])
    assert len(group) == 3
    ratios = np.array([row["rms_ratio"] for row in actions if row["label"] == label])
    normalized = group/np.linalg.norm(group, axis=1)[:, None]
    repeat[label] = dict(rms_per_bout=group.tolist(), ratio_per_bout=ratios.tolist(),
                          cv_across_bouts=(group.std(axis=0, ddof=1)/group.mean(axis=0)).tolist(),
                          spatial_cosine_similarity=(normalized@normalized.T).tolist())
summary["repeat_summary"] = repeat

previous = json.loads((OUT.parent/"emg006_20261021/EMG006_quality.json").read_text())
matched = {}
for name, oldname in (("raw", "raw"), ("processed", "notch50")):
    f, p = psd(streams[name][fs:10*fs])
    now = spectral_stats(f, p)
    old = previous["matched_rest_1_to_10s_comparison"][oldname]["EMG006"]
    matched[name] = dict(EMG006_branch=oldname, EMG006=old, EMG007=now,
                          change_db={key: (20*np.log10(np.array(now[key])/np.array(old[key]))).tolist()
                                     for key in ("mains_rms", "harmonic_neighborhood_rms", "rms_excluding_line_bands")})
summary["matched_rest_1_to_10s_vs_EMG006"] = matched

assert np.isfinite(np.array(results["processed"]["stable"]["rms_20_450"])).all()
assert max(row["max_abs_error"] for row in refcheck) <= 5, refcheck
assert max(row["max_abs_error"] for row in spot_checks) <= 5, spot_checks
assert all(np.array(results[name]["rail_count"]).sum() == 0 for name in streams)
(OUT/"EMG007_quality.json").write_text(json.dumps(summary, indent=2), encoding="utf-8")
print("HEADER", json.dumps(summary["header"]), flush=True)
print("INTEGRITY", json.dumps(summary["integrity"]), flush=True)
print("REFERENCE", json.dumps(refcheck), flush=True)
print("SPOT_REFERENCE", json.dumps(spot_checks), flush=True)
print("TRANSIENT_FLAGS", json.dumps(summary["transient_flags"]), flush=True)
for name in results:
    print(name.upper(), json.dumps(results[name]["stable"]), flush=True)
print("ATTENUATION", json.dumps(attenuations), flush=True)
print("REST_COMPARE", json.dumps(matched), flush=True)
for row in actions:
    print("ACTION", row["label"], round(row["start_s"], 2),
          "RMS", np.round(row["rms"], 1).tolist(),
          "RATIO", np.round(row["rms_ratio"], 2).tolist(), flush=True)
print("REPEATS", json.dumps(repeat), flush=True)
for i, row in enumerate(bursts):
    if row["label"] != "rest":
        print("BURST", i, row["label"],
              "TOP10_POWER", np.round(row["top10percent_windows_power_share"], 3).tolist(),
              "MEDIAN", np.round(row["median_100ms_rms"], 1).tolist(),
              "CH5_TIMES", np.round(row["ch5_top_window_times_s"][:3], 2).tolist(), flush=True)

colors = {"rest": "#d9e3ec", "open_hand": "#a5d6a7", "fist": "#ffcc80",
          "wrist_flex": "#b39ddb", "wrist_extend": "#81d4fa"}
block = 400
n = len(frames)//block
times = (np.arange(n)+0.5)*block/fs
fig, axes = plt.subplots(8, 2, figsize=(18, 15), sharex=True)
for ch in range(8):
    raw = streams["raw"][:n*block, ch].reshape(n, block)
    pro = streams["processed"][:n*block, ch].reshape(n, block)
    axes[ch, 0].fill_between(times, raw.min(axis=1)/1000, raw.max(axis=1)/1000,
                              color="#255da8", alpha=0.8, lw=0)
    axes[ch, 1].plot(times, np.sqrt(np.mean(pro*pro, axis=1)), lw=0.8, color="#255da8")
    axes[ch, 0].set_ylabel(f"CH{ch+1}\nkcount")
    axes[ch, 1].set_ylabel("RMS count")
    for ax in axes[ch]:
        for seg in segments:
            ax.axvspan(seg["start_s"], seg["end_s"], color=colors[seg["label"]], alpha=0.3)
        ax.grid(alpha=0.2)
axes[0, 0].set_title("Board RAW extrema per 100 ms (preserves peaks)")
axes[0, 1].set_title("Actual board PROCESSED: 100 ms RMS; no additional bandpass")
fig.legend(handles=[Patch(facecolor=c, alpha=0.5, label=l) for l, c in colors.items()],
           loc="upper center", ncol=5, frameon=False)
for ax in axes[-1]:
    ax.set_xlabel("Saved time (s)")
fig.tight_layout(rect=(0, 0, 1, 0.97))
fig.savefig(OUT/"EMG007_waveform_quality.png", dpi=130)
plt.close(fig)

fig, axes = plt.subplots(4, 2, figsize=(15, 13), sharex=True)
for ch, ax in enumerate(axes.flat):
    for name, color, style in (("raw", "#a95732", "-"),
                               ("legacy_notch_float_same_raw", "#777777", "--"),
                               ("processed", "#187f82", "-")):
        f, p = spectra[name]
        keep = (f >= 1) & (f <= 450)
        ax.plot(f[keep], 10*np.log10(np.maximum(p[keep, ch], 1e-12)),
                label=name, lw=0.8, color=color, ls=style)
    for hz in range(50, 451, 50):
        ax.axvline(hz, color="gray", alpha=0.2, lw=0.6)
    ax.set_title(f"CH{ch+1}")
    ax.set_ylabel("PSD (dB count^2/Hz)")
    ax.grid(alpha=0.2)
axes[0, 0].legend(fontsize=8)
for ax in axes[-1]:
    ax.set_xlabel("Hz")
fig.suptitle("EMG007 stable segments: measured RAW/PROCESSED; synthetic old notch on identical RAW")
fig.tight_layout()
fig.savefig(OUT/"EMG007_spectrum_quality.png", dpi=130)
plt.close(fig)

fig, axes = plt.subplots(2, 2, figsize=(13, 8))
for ax, (label, values) in zip(axes.flat, repeat.items()):
    group = np.array(values["rms_per_bout"])
    x = np.arange(8)
    for i, row in enumerate(group):
        ax.bar(x+(i-1)*0.25, row, width=0.25, label=f"Bout {i+1}")
    ax.set_xticks(x, [f"CH{i+1}" for i in x])
    ax.set_title(label)
    ax.set_ylabel("20-450 Hz RMS excluding line neighborhoods (count)")
    ax.grid(axis="y", alpha=0.2)
axes[0, 0].legend()
fig.tight_layout()
fig.savefig(OUT/"EMG007_action_repeats.png", dpi=130)
plt.close(fig)

fig, axes = plt.subplots(3, 2, figsize=(15, 9), sharex="col")
for col, center in enumerate((170, 241.5)):
    lo, hi = round((center-2)*fs), round((center+2)*fs)
    t = np.arange(lo, hi)/fs
    raw = streams["raw"][lo:hi, 5]
    pro = streams["processed"][lo:hi, 5]
    axes[0, col].plot(t, raw/1000, lw=0.7)
    axes[0, col].set_title(f"CH6 transient near {center:g} s")
    axes[0, col].set_ylabel("RAW kcount")
    axes[1, col].plot(t, pro, lw=0.7)
    axes[1, col].set_ylabel("PROCESSED count")
    rms = np.sqrt(np.mean(pro.reshape(-1, 400)**2, axis=1))
    axes[2, col].plot(t[::400]+0.05, rms, lw=1)
    axes[2, col].set_ylabel("100 ms RMS count")
    axes[2, col].set_xlabel("Saved time (s)")
    for ax in axes[:, col]:
        for seg in segments:
            if seg["end_s"] > lo/fs and seg["start_s"] < hi/fs:
                ax.axvspan(max(lo/fs, seg["start_s"]), min(hi/fs, seg["end_s"]),
                           color=colors[seg["label"]], alpha=0.3)
        ax.grid(alpha=0.2)
fig.tight_layout()
fig.savefig(OUT/"EMG007_ch6_transients.png", dpi=130)
plt.close(fig)
print("TEST_PASS header, continuous sequences, PSD, integer filter identity, repeated labels, ADC rails", flush=True)
