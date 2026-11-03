#!/usr/bin/env python3
"""Generate an offline waveform, spectrum, and data-quality report.

The report is intentionally self-contained: the HTML has no network or
browser-side Python dependency, so it can be copied with the CSV metadata and
opened on a lab PC that is not connected to the board.

Examples:
  python tools/analyze_capture.py --latest
  python tools/analyze_capture.py data/raw/board/s30/S30_E3_A1_waveform.csv
"""

import argparse
import html
import json
import math
import os
from pathlib import Path

import numpy as np
import pandas as pd
from scipy import signal

ROOT = Path(__file__).resolve().parent.parent
CHANNELS = 8
EXPECTED_PERIOD_US = 250


def find_latest():
    paths = sorted((ROOT / "data" / "raw" / "board").rglob("*.csv"),
                   key=lambda p: p.stat().st_mtime)
    if not paths:
        raise FileNotFoundError("no capture CSV under data/raw/board")
    return paths[-1]


def load_capture(path):
    path = Path(path).resolve()
    frame = pd.read_csv(path)
    required = ["timestamp_us", "action"] + [f"channel_{i}" for i in range(CHANNELS)]
    missing = [name for name in required if name not in frame.columns]
    if missing:
        raise ValueError(f"missing CSV columns: {', '.join(missing)}")
    if frame.empty:
        raise ValueError("capture CSV is empty")
    timestamps = frame["timestamp_us"].to_numpy(np.int64)
    if np.any(np.diff(timestamps) <= 0):
        raise ValueError("timestamp_us must be strictly increasing")
    samples = frame[[f"channel_{i}" for i in range(CHANNELS)]].to_numpy(np.float64)
    labels = frame["action"].astype(str).to_numpy()
    sidecar = path.with_suffix(".json")
    meta = json.loads(sidecar.read_text(encoding="utf-8")) if sidecar.exists() else {}
    fs = float(meta.get("sample_rate_hz", 0))
    if fs <= 0:
        fs = 1e6 / float(np.median(np.diff(timestamps)))
    return path, timestamps, samples, labels, meta, fs


def gap_metrics(timestamps, fs):
    period = 1e6 / fs
    deltas = np.diff(timestamps)
    missing_each = np.maximum(0, np.rint(deltas / period).astype(np.int64) - 1)
    gap_indices = np.flatnonzero(missing_each > 0)
    gap_samples = int(missing_each.sum())
    expected = len(timestamps) + gap_samples
    gap_events = int(len(gap_indices))
    largest_index = int(np.argmax(missing_each)) if gap_events else -1
    largest_samples = int(missing_each[largest_index]) if gap_events else 0
    largest_seconds = largest_samples / fs
    gap_rows = []
    for index in gap_indices[:200]:
        gap_rows.append({
            "time_s": float(timestamps[index] / 1e6),
            "missing_samples": int(missing_each[index]),
            "duration_ms": float(missing_each[index] * 1000 / fs),
        })
    return {
        "frames": int(len(timestamps)),
        "expected_frames": int(expected),
        "missing_frames": gap_samples,
        "missing_fraction": float(gap_samples / expected) if expected else 0.0,
        "gap_events": gap_events,
        "largest_gap_samples": largest_samples,
        "largest_gap_s": largest_seconds,
        "duration_s": float((timestamps[-1] - timestamps[0] + period) / 1e6),
        "period_us_median": float(np.median(deltas)),
        "period_us_p01": float(np.percentile(deltas, 1)),
        "period_us_p99": float(np.percentile(deltas, 99)),
        "gap_rows": gap_rows,
    }


def contiguous_segments(timestamps, fs, max_gap_samples=4):
    """Return index spans whose small gaps may be interpolated for Welch."""
    period = 1e6 / fs
    missing = np.maximum(0, np.rint(np.diff(timestamps) / period).astype(np.int64) - 1)
    cuts = np.flatnonzero(missing > max_gap_samples) + 1
    edges = np.r_[0, cuts, len(timestamps)]
    return [(int(a), int(b)) for a, b in zip(edges[:-1], edges[1:]) if b - a >= 256]


def regularize_segment(timestamps, samples, start, stop, fs):
    period = 1e6 / fs
    grid = np.arange(timestamps[start], timestamps[stop - 1] + period * 0.5,
                     period, dtype=np.float64)
    values = np.column_stack([
        np.interp(grid, timestamps[start:stop], samples[start:stop, channel])
        for channel in range(CHANNELS)
    ])
    return grid, values


def channel_metrics(samples):
    med = np.median(samples, axis=0)
    centered = samples - med
    rms = np.sqrt(np.mean(centered * centered, axis=0))
    rail = ((samples <= -8388608) | (samples >= 8388607)).sum(axis=0)
    result = []
    for channel in range(CHANNELS):
        result.append({
            "channel": channel + 1,
            "median": float(med[channel]),
            "mean": float(np.mean(samples[:, channel])),
            "rms_dc_removed": float(rms[channel]),
            "min": int(np.min(samples[:, channel])),
            "max": int(np.max(samples[:, channel])),
            "p01": float(np.percentile(samples[:, channel], 1)),
            "p99": float(np.percentile(samples[:, channel], 99)),
            "rail_count": int(rail[channel]),
        })
    covariance = np.cov(centered, rowvar=False)
    eigenvalues = np.linalg.eigvalsh(covariance)
    common_fraction = float(eigenvalues[-1] / max(eigenvalues.sum(), 1e-12))
    correlation = np.corrcoef(centered.T)
    return result, med, correlation, common_fraction


def spectrum_metrics(timestamps, samples, fs):
    segments = contiguous_segments(timestamps, fs)
    usable = []
    interpolated = 0
    excluded = 0
    period = 1e6 / fs
    for start, stop in segments:
        _, values = regularize_segment(timestamps, samples, start, stop, fs)
        raw_count = stop - start
        regular_count = len(values)
        interpolated += max(0, regular_count - raw_count)
        usable.append(values)
    if not usable:
        raise ValueError("no contiguous segment has at least 256 samples")
    nperseg = min(16384, max(len(values) for values in usable))
    nperseg = 2 ** int(math.floor(math.log2(max(256, nperseg))))
    nperseg = min(nperseg, max(len(values) for values in usable))
    spectra = []
    for values in usable:
        if len(values) < nperseg:
            continue
        _, power = signal.welch(values, fs=fs, axis=0, nperseg=nperseg,
                                 noverlap=nperseg // 2, detrend="linear")
        spectra.append(power)
    if not spectra:
        raise ValueError("no spectrum window survived the contiguous-segment check")
    frequencies = signal.welch(usable[0], fs=fs, axis=0, nperseg=nperseg,
                               noverlap=nperseg // 2, detrend="linear")[0]
    power = np.mean(np.stack(spectra), axis=0)
    band = (frequencies >= 20) & (frequencies <= min(450, fs / 2))
    harmonics = np.zeros_like(frequencies, dtype=bool)
    for center in (100, 200, 300, 400):
        harmonics |= np.abs(frequencies - center) <= 2
    harmonics &= band
    mains = (frequencies >= 49) & (frequencies <= 51)
    stats = []
    chart_f = frequencies[band]
    # Keep the dashboard compact without hiding the dominant peaks.
    stride = max(1, int(math.ceil(len(chart_f) / 900)))
    chart_f = chart_f[::stride]
    chart_db = []
    for channel in range(CHANNELS):
        band_power = float(np.trapezoid(power[band, channel], frequencies[band]))
        # The harmonic mask contains separated bands. Integrating the masked
        # array as one curve would incorrectly include the empty spans between
        # 100, 200, 300, and 400 Hz.
        df_hz = float(np.median(np.diff(frequencies)))
        harmonic_power = float(np.sum(power[harmonics, channel]) * df_hz)
        mains_power = float(np.trapezoid(power[mains, channel], frequencies[mains])) if np.any(mains) else 0.0
        peak_index = np.flatnonzero(band)[np.argmax(power[band, channel])]
        peak_power = max(float(np.max(power[band, channel])), 1e-30)
        db = 10 * np.log10(np.maximum(power[band, channel] / peak_power, 1e-30))
        chart_db.append(db[::stride].tolist())
        stats.append({
            "channel": channel + 1,
            "peak_hz": float(frequencies[peak_index]),
            "harmonic_fraction": float(harmonic_power / max(band_power, 1e-30)),
            "mains_fraction": float(mains_power / max(band_power, 1e-30)),
        })
    # Any timestamp gap larger than the interpolation budget is excluded from
    # the spectrum. This is separate from the complete gap count in quality.
    deltas = np.diff(timestamps)
    missing = np.maximum(0, np.rint(deltas / period).astype(np.int64) - 1)
    excluded = int(missing[missing > 4].sum())
    return {
        "window_n": int(nperseg),
        "usable_segments": int(len(spectra)),
        "interpolated_samples": int(interpolated),
        "excluded_gap_samples": excluded,
        "frequencies_hz": chart_f.tolist(),
        "channels": stats,
        "db": chart_db,
    }


def envelope_data(timestamps, samples, bins=1400):
    n = len(samples)
    edges = np.linspace(0, n, min(bins, n) + 1, dtype=np.int64)
    result = []
    relative_t = (timestamps - timestamps[0]) / 1e6
    for channel in range(CHANNELS):
        t_out, lo, hi = [], [], []
        for start, stop in zip(edges[:-1], edges[1:]):
            if stop <= start:
                continue
            t_out.append(float(np.mean(relative_t[start:stop])))
            lo.append(float(np.min(samples[start:stop, channel])))
            hi.append(float(np.max(samples[start:stop, channel])))
        result.append({"t": t_out, "lo": lo, "hi": hi})
    return result


def label_metrics(labels, timestamps):
    counts = {}
    segments = []
    start = 0
    for index, label in enumerate(labels):
        counts[label] = counts.get(label, 0) + 1
        if index == 0:
            continue
        if label != labels[start]:
            segments.append({"label": str(labels[start]),
                             "start_s": float((timestamps[start] - timestamps[0]) / 1e6),
                             "end_s": float((timestamps[index - 1] - timestamps[0]) / 1e6),
                             "frames": int(index - start)})
            start = index
    segments.append({"label": str(labels[start]),
                     "start_s": float((timestamps[start] - timestamps[0]) / 1e6),
                     "end_s": float((timestamps[-1] - timestamps[0]) / 1e6),
                     "frames": int(len(labels) - start)})
    return {"counts": counts, "segments": segments[:200]}


def build_report(path, timestamps, samples, labels, meta, fs):
    quality = gap_metrics(timestamps, fs)
    quality["sequence_backwards"] = int(meta.get("sequence_backwards", 0) or
                                        meta.get("frames_backward_uart", 0))
    quality["sequence_duplicates"] = int(meta.get("sequence_duplicates", 0) or
                                         meta.get("frames_duplicate_uart", 0))
    channels, medians, correlation, common_fraction = channel_metrics(samples)
    spectrum = spectrum_metrics(timestamps, samples, fs)
    labels_out = label_metrics(labels, timestamps)
    source = meta.get("signal", "unknown")
    periodic = max(item["harmonic_fraction"] for item in spectrum["channels"]) > 0.5
    has_rails = any(item["rail_count"] for item in channels)
    if (quality["missing_fraction"] > 0.01 or has_rails or
            quality["sequence_backwards"] or quality["sequence_duplicates"]):
        status = "BAD"
    elif periodic or common_fraction > 0.8 or quality["missing_fraction"] > 0.001:
        status = "CHECK"
    else:
        status = "PASS"
    return {
        "file": str(path.relative_to(ROOT)).replace("\\", "/")
        if path.is_relative_to(ROOT) else str(path),
        "source": source,
        "filter": meta.get("filter"),
        "sample_rate_hz": fs,
        "channels": CHANNELS,
        "quality_status": status,
        "quality": quality,
        "channel_metrics": channels,
        "common_mode": {
            "first_pca_fraction": common_fraction,
            "correlation": correlation.round(4).tolist(),
        },
        "spectrum": spectrum,
        "labels": labels_out,
        "waveform": envelope_data(timestamps, samples),
        "notes": [
            "The spectrum uses contiguous sections; gaps up to four samples are linearly interpolated only for spectral estimation.",
            "The CSV protocol has no CRC, so payload bit errors cannot be ruled out by timestamp checks alone.",
            "For any filtered capture, the 49-51 Hz metric describes the output and cannot establish interference rejection without a matching raw reference.",
            "A backward or duplicate sequence forces BAD even if timestamps were reconstructed as increasing; inspect the capture sidecar before training.",
            "A dominant common mode or periodic component is a data-quality warning, not a diagnosis of the hardware fault source.",
        ],
    }


def html_report(report):
    payload = json.dumps(report, ensure_ascii=True, separators=(",", ":"))
    safe_file = html.escape(report["file"])
    source = html.escape(str(report.get("source", "unknown")))
    status = report["quality_status"]
    status_class = status.lower()
    return f'''<!doctype html>
<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>sEMG capture analysis</title>
<style>
:root {{ color-scheme: light; --ink:#1f2933; --muted:#667085; --line:#d9dee7; --bg:#f5f7fa; --panel:#fff; --blue:#2563eb; --red:#c0392b; --amber:#a15c00; --green:#18794e; }}
* {{ box-sizing:border-box; }} body {{ margin:0; color:var(--ink); background:var(--bg); font:14px/1.45 system-ui,-apple-system,Segoe UI, sans-serif; }}
header {{ padding:22px 28px 18px; background:#17202a; color:#f8fafc; }} header h1 {{ margin:0 0 6px; font-size:24px; font-weight:650; }} header p {{ margin:0; color:#c5d0dc; }}
main {{ max-width:1500px; margin:0 auto; padding:20px 24px 42px; }} .grid {{ display:grid; grid-template-columns:repeat(auto-fit,minmax(170px,1fr)); gap:12px; margin-bottom:16px; }}
.card,.panel {{ background:var(--panel); border:1px solid var(--line); border-radius:7px; box-shadow:0 1px 2px #12213a0b; }} .card {{ padding:14px 16px; }} .card .label {{ color:var(--muted); font-size:12px; text-transform:uppercase; letter-spacing:.04em; }} .card .value {{ margin-top:3px; font-size:22px; font-weight:650; }}
.status-bad {{ color:var(--red); }} .status-check {{ color:var(--amber); }} .status-pass {{ color:var(--green); }} .panel {{ padding:16px; margin-bottom:16px; }} h2 {{ margin:0 0 11px; font-size:17px; }} h3 {{ margin:15px 0 8px; font-size:14px; }} .toolbar {{ display:flex; gap:10px; align-items:center; flex-wrap:wrap; margin-bottom:9px; color:var(--muted); }} select {{ padding:6px 9px; border:1px solid #b9c3d0; border-radius:5px; background:#fff; color:var(--ink); }}
canvas {{ display:block; width:100%; height:430px; border:1px solid #e1e6ee; background:#fbfcfe; }} .small-canvas {{ height:340px; }} table {{ width:100%; border-collapse:collapse; font-size:13px; }} th,td {{ padding:7px 8px; border-bottom:1px solid #edf0f4; text-align:right; white-space:nowrap; }} th:first-child,td:first-child {{ text-align:left; }} th {{ color:var(--muted); font-weight:600; }} .scroll {{ overflow:auto; }} .note {{ color:var(--muted); font-size:12px; margin:8px 0 0; }} ul {{ margin:7px 0 0 20px; padding:0; color:var(--muted); }} .badge {{ display:inline-block; padding:3px 8px; border-radius:999px; font-size:12px; font-weight:700; letter-spacing:.04em; }} .badge.bad {{ color:#fff; background:var(--red); }} .badge.check {{ color:#fff; background:var(--amber); }} .badge.pass {{ color:#fff; background:var(--green); }}
@media (max-width:700px) {{ main {{ padding:14px 10px 30px; }} header {{ padding:18px 14px; }} canvas {{ height:330px; }} th,td {{ padding:6px; }} }}
</style></head><body>
<header><h1>sEMG capture analysis</h1><p>{safe_file} &middot; source: {source}</p></header>
<main>
<section class="grid" id="summary"></section>
<section class="panel"><h2>Waveform overview</h2><div class="toolbar"><label for="waveChannel">Display</label><select id="waveChannel"><option value="all">All channels</option></select><span class="note">Envelope preserves extrema per time bin; the CSV remains unchanged.</span></div><canvas id="wave" width="1400" height="430"></canvas></section>
<section class="panel"><h2>Spectrum</h2><div class="toolbar"><label for="specChannel">Display</label><select id="specChannel"><option value="all">All channels</option></select><span class="note">20-450 Hz, contiguous sections only; dB is relative to each channel peak.</span></div><canvas id="spec" class="small-canvas" width="1400" height="340"></canvas></section>
<section class="panel"><h2>Channel metrics</h2><div class="scroll"><table id="channels"><thead><tr><th>Channel</th><th>Median</th><th>RMS after DC removal</th><th>Min</th><th>Max</th><th>P01</th><th>P99</th><th>ADC rail samples</th><th>Peak Hz</th><th>100 Hz harmonic share</th></tr></thead><tbody></tbody></table></div></section>
<section class="panel"><h2>Data quality and labels</h2><div class="scroll"><table id="quality"><tbody></tbody></table></div><h3>Notes</h3><ul id="notes"></ul></section>
</main>
<script>
const DATA = {payload};
const COLORS = ['#2563eb','#e07a22','#2f9e44','#d94841','#8b5cf6','#087f8c','#a66a00','#c22575'];
const fmt=(v,d=2)=>Number(v).toLocaleString(undefined,{{maximumFractionDigits:d}});
const summary=document.getElementById('summary');
const q=DATA.quality, cm=DATA.common_mode, spec=DATA.spectrum;
const cards=[['Quality',`<span class="badge {status_class}">${{DATA.quality_status}}</span>`],['Frames',fmt(q.frames,0)],['Duration',fmt(q.duration_s,2)+' s'],['Missing frames',fmt(q.missing_frames,0)+' ('+fmt(q.missing_fraction*100,2)+'%)'],['Largest gap',fmt(q.largest_gap_s*1000,2)+' ms'],['Common PC1',fmt(cm.first_pca_fraction*100,1)+'%'],['Source',DATA.source || 'unknown'],['Labels',Object.keys(DATA.labels.counts).join(', ')]];
for(const [label,value] of cards){{const el=document.createElement('div');el.className='card';el.innerHTML=`<div class="label">${{label}}</div><div class="value">${{value}}</div>`;summary.appendChild(el);}}
for(const id of ['waveChannel','specChannel']){{const sel=document.getElementById(id);for(let i=0;i<8;i++){{const o=document.createElement('option');o.value=i;o.textContent='CH'+(i+1);sel.appendChild(o);}}sel.addEventListener('change',()=>{{drawWave();drawSpec();}});}}
function axes(ctx,w,h,x0,x1,y0,y1,yLabel){{ctx.strokeStyle='#aeb7c5';ctx.lineWidth=1;ctx.beginPath();ctx.moveTo(48,12);ctx.lineTo(48,h-30);ctx.lineTo(w-12,h-30);ctx.stroke();ctx.fillStyle='#667085';ctx.font='12px system-ui';ctx.fillText(x0.toFixed(1),48,h-10);ctx.fillText(x1.toFixed(1),w-55,h-10);ctx.fillText(yLabel,5,18);}}
function drawWave(){{const c=document.getElementById('wave'),ctx=c.getContext('2d'),w=c.width,h=c.height;ctx.clearRect(0,0,w,h);const selected=document.getElementById('waveChannel').value;const list=selected==='all'?[0,1,2,3,4,5,6,7]:[Number(selected)];const sets=list.map(i=>DATA.waveform[i]);const t=DATA.waveform[0].t;const x0=t[0]||0,x1=t[t.length-1]||1;const band=(h-42)/list.length;for(let row=0;row<list.length;row++){{const ch=list[row],set=sets[row],top=12+row*band,mid=top+band/2,scale=Math.max(...set.hi.map((v,i)=>Math.max(Math.abs(v),Math.abs(set.lo[i]))),1);ctx.strokeStyle='#e3e8ef';ctx.beginPath();ctx.moveTo(48,mid);ctx.lineTo(w-12,mid);ctx.stroke();ctx.strokeStyle=COLORS[ch];ctx.globalAlpha=.82;for(let i=0;i<set.t.length;i++){{const px=48+(set.t[i]-x0)/(x1-x0)*(w-60);const yhi=mid-(set.hi[i]/scale)*(band*.42);const ylo=mid-(set.lo[i]/scale)*(band*.42);ctx.beginPath();ctx.moveTo(px,yhi);ctx.lineTo(px,ylo);ctx.stroke();}}ctx.globalAlpha=1;ctx.fillStyle=COLORS[ch];ctx.font='12px system-ui';ctx.fillText('CH'+(ch+1),5,top+15);}}axes(ctx,w,h,x0,x1,0,0,'ADC count (per-channel scale)');}}
function drawSpec(){{const c=document.getElementById('spec'),ctx=c.getContext('2d'),w=c.width,h=c.height;ctx.clearRect(0,0,w,h);const selected=document.getElementById('specChannel').value;const list=selected==='all'?[0,1,2,3,4,5,6,7]:[Number(selected)];const f=spec.frequencies_hz,x0=f[0]||20,x1=f[f.length-1]||450;axes(ctx,w,h,x0,x1,-65,0,'relative dB');for(const ch of list){{const db=spec.db[ch];ctx.strokeStyle=COLORS[ch];ctx.lineWidth=1.2;ctx.beginPath();for(let i=0;i<f.length;i++){{const px=48+(f[i]-x0)/(x1-x0)*(w-60);const py=12+(0-db[i])/65*(h-42);if(i===0)ctx.moveTo(px,py);else ctx.lineTo(px,py);}}ctx.stroke();}}ctx.fillStyle='#667085';ctx.font='12px system-ui';for(const hz of [50,100,200,300,400]){{const px=48+(hz-x0)/(x1-x0)*(w-60);ctx.strokeStyle=hz===50?'#c0392b':'#d9dee7';ctx.setLineDash(hz===50?[4,4]:[2,4]);ctx.beginPath();ctx.moveTo(px,12);ctx.lineTo(px,h-30);ctx.stroke();ctx.setLineDash([]);ctx.fillText(hz+' Hz',px+3,25);}}}}
const chBody=document.querySelector('#channels tbody');for(let i=0;i<8;i++){{const m=DATA.channel_metrics[i],s=spec.channels[i],tr=document.createElement('tr');tr.innerHTML=`<td>CH${{i+1}}</td><td>${{fmt(m.median,1)}}</td><td>${{fmt(m.rms_dc_removed,1)}}</td><td>${{fmt(m.min,0)}}</td><td>${{fmt(m.max,0)}}</td><td>${{fmt(m.p01,0)}}</td><td>${{fmt(m.p99,0)}}</td><td>${{fmt(m.rail_count,0)}}</td><td>${{fmt(s.peak_hz,2)}}</td><td>${{fmt(s.harmonic_fraction*100,1)}}%</td>`;chBody.appendChild(tr);}}
const qBody=document.querySelector('#quality tbody');const rows=[['Sample rate',fmt(DATA.sample_rate_hz,0)+' Hz'],['Median period',fmt(q.period_us_median,2)+' us'],['Period P01-P99',fmt(q.period_us_p01,2)+' - '+fmt(q.period_us_p99,2)+' us'],['Gap events',fmt(q.gap_events,0)],['Spectrum windows',fmt(spec.usable_segments,0)],['Spectrum interpolation',fmt(spec.interpolated_samples,0)+' samples'],['Excluded large gaps',fmt(spec.excluded_gap_samples,0)+' samples'],['Label counts',Object.entries(DATA.labels.counts).map(([k,v])=>k+': '+fmt(v,0)).join(' | ')]];for(const [k,v] of rows){{const tr=document.createElement('tr');tr.innerHTML=`<th>${{k}}</th><td>${{v}}</td>`;qBody.appendChild(tr);}}
const notes=document.getElementById('notes');for(const text of DATA.notes){{const li=document.createElement('li');li.textContent=text;notes.appendChild(li);}}
drawWave();drawSpec();
</script></body></html>'''


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("csv", nargs="?", help="record_uart.py CSV path")
    parser.add_argument("--latest", action="store_true", help="use newest board CSV")
    parser.add_argument("--out", help="HTML output path (default: beside CSV)")
    parser.add_argument("--json", dest="json_out", help="JSON metrics output path")
    args = parser.parse_args()
    if bool(args.csv) == bool(args.latest):
        parser.error("give exactly one of CSV path or --latest")
    path = find_latest() if args.latest else Path(args.csv)
    path, timestamps, samples, labels, meta, fs = load_capture(path)
    report = build_report(path, timestamps, samples, labels, meta, fs)
    out = Path(args.out) if args.out else path.with_name(path.stem + "_analysis.html")
    json_out = Path(args.json_out) if args.json_out else out.with_suffix(".json")
    out.parent.mkdir(parents=True, exist_ok=True)
    json_out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(html_report(report), encoding="utf-8")
    json_out.write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding="utf-8")
    print(json.dumps({"html": str(out), "json": str(json_out),
                      "quality_status": report["quality_status"],
                      "frames": report["quality"]["frames"],
                      "missing_frames": report["quality"]["missing_frames"]},
                     ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()

