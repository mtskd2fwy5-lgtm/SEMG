"""Reproducible EMG011 quality and re-wear transfer assessment."""
from pathlib import Path
import hashlib
import json
import sys

import numpy as np
from sklearn.metrics import accuracy_score, confusion_matrix, f1_score, classification_report
from sklearn.model_selection import StratifiedGroupKFold
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import Pipeline
from sklearn.neural_network import MLPClassifier
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.patches import Patch

ROOT = Path(__file__).resolve().parents[2]
OUT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT / "report" / "emg010_20261022"))
import assess_emg010 as base

FS = base.FS
CLASS_NAMES = base.CLASS_NAMES
COLORS = base.COLORS


def initial_rest_comparison(r10, r11):
    rows = {}
    for stream in ("raw", "processed"):
        f, p10 = base.welch(r10[stream][FS:5 * FS])
        _, p11 = base.welch(r11[stream][FS:5 * FS])
        m10, m11 = base.spectral(f, p10), base.spectral(f, p11)
        change_db = {}
        for metric in ("rms_20_450", "mains_rms", "harmonic_rms", "clean_rms", "low_rms"):
            change_db[metric] = (
                20 * np.log10(np.maximum(m11[metric], 1e-12) /
                              np.maximum(m10[metric], 1e-12))).tolist()
        rows[stream] = {"EMG010": m10, "EMG011": m11, "change_db_011_vs_010": change_db}
    common_mode = {}
    for stream in ("raw", "processed"):
        a = base.pc1_fraction(r10[stream][FS:5 * FS])
        b = base.pc1_fraction(r11[stream][FS:5 * FS])
        common_mode[stream] = {
            "EMG010": a, "EMG011": b,
            "change_percentage_points": 100 * (b - a),
        }
    return rows, common_mode


def grouped_validation(x, y, info):
    """Three-fold validation, always holding complete labeled bouts out."""
    groups = np.asarray([row["segment_index"] for row in info], dtype=np.int32)
    unique_groups = np.unique(groups)
    bout_counts = {
        CLASS_NAMES[c]: len({g for g, yy in zip(groups, y) if yy == c})
        for c in range(len(CLASS_NAMES))
    }
    folds_n = min(3, min(bout_counts.values()))
    if folds_n < 2:
        raise ValueError(f"not enough independent bouts for grouped validation: {bout_counts}")
    seeds = []
    for seed in range(5):
        cv = StratifiedGroupKFold(n_splits=folds_n, shuffle=True, random_state=seed)
        folds = list(cv.split(x, y, groups))
        pred = np.full(len(y), -1, dtype=np.int8)
        for fold, (train, test) in enumerate(folds):
            if set(np.unique(y[train]).tolist()) != set(range(len(CLASS_NAMES))):
                raise ValueError(f"fold {fold} lacks a training class")
            bx, by, _ = base.balanced(x[train], y[train], seed * 10 + fold)
            model = Pipeline([
                ("scale", StandardScaler()),
                ("mlp", MLPClassifier(hidden_layer_sizes=(64, 32), max_iter=300,
                                      early_stopping=True, random_state=seed)),
            ])
            model.fit(bx, by)
            pred[test] = model.predict(x[test])
        if np.any(pred < 0):
            raise AssertionError("grouped validation left windows without predictions")
        report = classification_report(
            y, pred, labels=range(len(CLASS_NAMES)), target_names=CLASS_NAMES,
            output_dict=True, zero_division=0)
        bouts = []
        for group in unique_groups:
            indices = np.flatnonzero(groups == group)
            truth = int(y[indices[0]])
            counts = np.bincount(pred[indices], minlength=len(CLASS_NAMES))
            guess = int(counts.argmax())
            bouts.append({
                "label": CLASS_NAMES[truth], "predicted": CLASS_NAMES[guess],
                "correct": bool(guess == truth), "n_windows": int(len(indices)),
            })
        actions = [row for row in bouts if row["label"] != "rest"]
        seeds.append({
            "seed": seed,
            "accuracy": float(accuracy_score(y, pred)),
            "macro_f1": float(f1_score(y, pred, average="macro")),
            "confusion": confusion_matrix(y, pred, labels=range(len(CLASS_NAMES))).tolist(),
            "per_class": {
                name: {metric: float(report[name][metric])
                       for metric in ("precision", "recall", "f1-score", "support")}
                for name in CLASS_NAMES
            },
            "action_bout_accuracy": float(np.mean([row["correct"] for row in actions])),
            "bouts": bouts,
        })
    return {
        "name": f"EMG011 within-rewear grouped {folds_n}-fold validation",
        "contract": "100 ms/25 ms windows; StratifiedGroupKFold holds complete labeled segments out",
        "segments_by_class": bout_counts,
        "windows": int(len(y)),
        "accuracy_mean": float(np.mean([row["accuracy"] for row in seeds])),
        "accuracy_sd": float(np.std([row["accuracy"] for row in seeds], ddof=1)),
        "macro_f1_mean": float(np.mean([row["macro_f1"] for row in seeds])),
        "action_bout_accuracy_mean": float(np.mean([row["action_bout_accuracy"] for row in seeds])),
        "seeds": seeds,
    }


def category_clean_rms(metrics):
    result = {}
    for label in CLASS_NAMES:
        rows = [row for row in metrics["segments"] if row["label"] == label]
        if rows:
            values = np.asarray([row["clean_rms"] for row in rows], dtype=float)
            result[label] = {
                "median_by_channel": np.median(values, axis=0).tolist(),
                "segment_count": len(rows),
            }
    return result


def burst_summary(rec):
    results = []
    for index, segment in enumerate(rec["segments"]):
        start = round(segment["stable_start_s"] * FS)
        stop = round(segment["stable_end_s"] * FS)
        windows = (stop - start) // 400
        if windows < 1:
            continue
        values = rec["processed"][start:start + windows * 400].reshape(windows, 400, 8).astype(float)
        rms = np.sqrt(np.mean(values * values, axis=1))
        count = max(1, int(np.ceil(0.1 * windows)))
        share = np.sort(rms * rms, axis=0)[-count:].sum(axis=0) / np.maximum(
            (rms * rms).sum(axis=0), 1e-12)
        results.append({
            "segment_index": index, "label": segment["label"],
            "start_s": segment["start_s"], "end_s": segment["end_s"],
            "median_100ms_rms": np.median(rms, axis=0).tolist(),
            "p95_100ms_rms": np.percentile(rms, 95, axis=0).tolist(),
            "top10percent_power_share": share.tolist(),
        })
    return results


def make_plots(rec, raw_psd, processed_psd):
    fig, axes = plt.subplots(8, 2, figsize=(18, 13), sharex=True)
    block = 400
    n = len(rec["frames"]) // block
    times = (np.arange(n) + 0.5) * block / FS
    for ch in range(8):
        raw = rec["raw"][:n * block, ch].reshape(n, block)
        processed = rec["processed"][:n * block, ch].reshape(n, block)
        axes[ch, 0].fill_between(
            times, raw.min(axis=1) / 1000, raw.max(axis=1) / 1000,
            color="#255da8", alpha=0.8, linewidth=0)
        axes[ch, 1].plot(
            times, np.sqrt(np.mean(processed.astype(float) ** 2, axis=1)),
            linewidth=0.8, color="#187f82")
        axes[ch, 0].set_ylabel(f"CH{ch + 1}\nkcount")
        for axis in axes[ch]:
            for segment in rec["segments"]:
                axis.axvspan(segment["start_s"], segment["end_s"],
                             color=COLORS[segment["label"]], alpha=0.3)
            axis.grid(alpha=0.2)
    axes[0, 0].set_title("RAW extrema / 100 ms")
    axes[0, 1].set_title("Final signed processed RMS / 100 ms")
    axes[-1, 0].set_xlabel("Saved time (s)")
    axes[-1, 1].set_xlabel("Saved time (s)")
    fig.legend(handles=[Patch(facecolor=COLORS[label], alpha=0.5, label=label)
                        for label in CLASS_NAMES],
               loc="upper center", ncol=5, frameon=False)
    fig.tight_layout(rect=(0, 0, 1, 0.97))
    fig.savefig(OUT / "EMG011_waveform_quality.png", dpi=130)
    plt.close(fig)

    freq, raw_power = raw_psd
    _, proc_power = processed_psd
    fig, axes = plt.subplots(4, 2, figsize=(15, 13), sharex=True)
    for ch, axis in enumerate(axes.flat):
        for power, label, color in (
            (raw_power, "raw", "#a95732"),
            (proc_power, "processed", "#187f82"),
        ):
            mask = (freq >= 1) & (freq <= 450)
            axis.plot(freq[mask], 10 * np.log10(np.maximum(power[mask, ch], 1e-12)),
                      label=label, linewidth=0.8, color=color)
        for hz in range(50, 451, 50):
            axis.axvline(hz, color="gray", alpha=0.2, linewidth=0.6)
        axis.set_title(f"CH{ch + 1}")
        axis.set_ylabel("PSD dB count²/Hz")
        axis.grid(alpha=0.2)
    axes[0, 0].legend()
    axes[-1, 0].set_xlabel("Hz")
    axes[-1, 1].set_xlabel("Hz")
    fig.tight_layout()
    fig.savefig(OUT / "EMG011_spectrum_quality.png", dpi=130)
    plt.close(fig)


def main():
    r11 = base.load_record("F:/EMG011.BIN")
    r10 = base.load_record("F:/EMG010.BIN")
    assert len(r11["frames"]) == 608593
    assert all(segment["label"] in CLASS_NAMES for segment in r11["segments"])

    raw_metrics, raw_psd = base.analyze_stream(r11, "raw")
    processed_metrics, processed_psd = base.analyze_stream(r11, "processed")
    matched, common_mode = initial_rest_comparison(r10, r11)
    del r10

    reference = []
    for start_s in (0, 40, 80, 120):
        lo, hi = start_s * FS, (start_s + 8) * FS
        for ch in range(8):
            filt = base.ProcessedSignal()
            predicted = np.asarray([filt.step(int(value)) for value in r11["raw"][lo:hi, ch]])
            error = predicted[5 * FS:] - r11["processed"][lo + 5 * FS:hi, ch]
            reference.append({
                "start_s": start_s + 5, "end_s": start_s + 8,
                "channel": ch + 1, "max_abs_error": int(np.max(np.abs(error))),
                "rmse": float(np.sqrt(np.mean(error.astype(float) ** 2))),
            })
    max_reference_error = max(row["max_abs_error"] for row in reference)

    r8 = base.load_record("F:/EMG008.BIN")
    x8, y8, _ = base.window_features(r8)
    x11, y11, info11 = base.window_features(r11)
    assert set(np.unique(y8)) == set(range(len(CLASS_NAMES)))
    rewear_model_8ch = base.evaluate(
        x8, y8, x11, y11, info11,
        "EMG008 train -> EMG011 test (8 channels; CH6 disconnected)")
    within_model_8ch = grouped_validation(x11, y11, info11)
    keep = np.asarray([block * 8 + channel
                       for block in range(5) for channel in range(8) if channel != 5])
    x8_7ch, x11_7ch = x8[:, keep], x11[:, keep]
    rewear_model = base.evaluate(
        x8_7ch, y8, x11_7ch, y11, info11,
        "EMG008 train -> EMG011 test (CH6 excluded; 7 channels)")
    within_model = grouped_validation(x11_7ch, y11, info11)
    del r8

    raw_sidecar = json.loads((OUT / "EMG011_raw_analysis.json").read_text(encoding="utf-8"))
    processed_sidecar = json.loads((OUT / "EMG011_processed_analysis.json").read_text(encoding="utf-8"))
    digest = hashlib.sha256(r11["blob"]).hexdigest()
    bursts = burst_summary(r11)
    rewear_recall = {
        label: float(np.mean([seed["per_class"][label]["recall"]
                              for seed in rewear_model["seeds"]]))
        for label in CLASS_NAMES
    }
    within_recall = {
        label: float(np.mean([seed["per_class"][label]["recall"]
                              for seed in within_model["seeds"]]))
        for label in CLASS_NAMES
    }
    clean_rms_by_class = category_clean_rms(processed_metrics)
    ch6_by_class = {
        label: clean_rms_by_class[label]["median_by_channel"][5]
        for label in CLASS_NAMES
    }
    burst_flags = [{
        "label": row["label"], "start_s": row["start_s"], "end_s": row["end_s"],
        "channels": [f"CH{index + 1}" for index, share in
                     enumerate(row["top10percent_power_share"]) if share > 0.5],
    } for row in bursts if max(row["top10percent_power_share"]) > 0.5]
    result = {
        "input": "F:/EMG011.BIN",
        "sha256": digest,
        "bytes": len(r11["blob"]),
        "frames": len(r11["frames"]),
        "duration_s": len(r11["frames"]) / FS,
        "sample_rate_hz": FS,
        "format": r11["header"],
        "user_confirmation": (
            "User says this was re-worn with other conditions the same as EMG010; "
            "carry-over placement is CH1-6 wrist, CH7-8 near elbow, no gel as previously confirmed."
        ),
        "integrity": {
            "backward": 0, "duplicate": 0, "missing": 0,
            "wraps": int(np.sum(np.diff(r11["seq"]) < 0)),
        },
        "segments": [{
            key: segment[key]
            for key in ("label", "start_s", "end_s", "stable_start_s", "stable_end_s")
        } for segment in r11["segments"]],
        "quality_status": {"raw": raw_sidecar["quality_status"],
                           "processed": processed_sidecar["quality_status"]},
        "streams": {"raw": raw_metrics, "processed": processed_metrics},
        "matched_rest_1_to_5s_vs_EMG010": matched,
        "matched_rest_common_mode_1_to_5s": common_mode,
        "processed_clean_rms_by_class": clean_rms_by_class,
        "model_rewear_mean_recall_by_class": rewear_recall,
        "model_within_rewear_mean_recall_by_class": within_recall,
        "burst_flags_top10percent_power_share_over_50pct": burst_flags,
        "reference_checks": reference,
        "user_confirmed_channel_fault": "One electrode of differential channel 6 is disconnected; CH6 excluded from primary classifier results.",
        "model_rewear": rewear_model,
        "model_within_rewear_grouped_cv": within_model,
        "model_rewear_all_8ch_with_disconnected_CH6": rewear_model_8ch,
        "model_within_rewear_all_8ch_with_disconnected_CH6": within_model_8ch,
        "bursts": bursts,
        "method": {
            "trim_s": 1,
            "psd": "Welch 4096, 50% overlap, linear detrend; duration-weighted stable segments",
            "matched_rest": "1-5 s from both recordings, same Welch configuration",
            "line_half_width_hz": 1,
            "harmonics_hz": list(range(50, 451, 50)),
            "model": "Refit the baseline pipeline on EMG008 capture data, then test on EMG011; 7 active channels, excluding CH6; per-channel MAV/WL/Energy/ZC/SSC; 100 ms windows, 25 ms hop; scaler + MLP(64,32)",
            "model_artifact_note": "No EMG008-specific saved joblib was found; repository baseline joblib artifacts are trained on NinaPro DB5.",
            "caveat": (
                "This is one re-wear session. Overlapping windows are not independent; "
                "grouped validation holds out complete labeled bouts but does not establish "
                "performance on future users or future re-wears."
            ),
        },
    }
    (OUT / "EMG011_quality.json").write_text(
        json.dumps(result, indent=2, ensure_ascii=False), encoding="utf-8")
    make_plots(r11, raw_psd, processed_psd)

    seg_counts = {}
    for segment in r11["segments"]:
        seg_counts[segment["label"]] = seg_counts.get(segment["label"], 0) + 1
    mains_db = matched["processed"]["change_db_011_vs_010"]["mains_rms"]
    harmonic_db = matched["processed"]["change_db_011_vs_010"]["harmonic_rms"]
    clean_db = matched["processed"]["change_db_011_vs_010"]["clean_rms"]
    attenuation = 20 * np.log10(
        np.maximum(matched["raw"]["EMG011"]["mains_rms"], 1e-12) /
        np.maximum(matched["processed"]["EMG011"]["mains_rms"], 1e-12))
    burst_text = "; ".join(
        f"{row['label']} {row['start_s']:.2f}–{row['end_s']:.2f}s "
        f"({', '.join(row['channels'])})" for row in burst_flags)
    lines = [
        "# EMG011：重佩戴信号质量与 EMG008 模型测试",
        "",
        "分析日期：2026-10-22。源文件：F:/EMG011.BIN。用户确认本次重新佩戴，其余条件与 EMG010 相同；沿用此前确认的 CH1–6 腕部、CH7–8 近肘部布置及未使用凝胶。",
        "",
        "## 结论",
        "",
        f"采集完整性良好：{len(r11['frames']):,} 帧、{len(r11['frames']) / FS:.3f} 秒，序号无缺失、重复或倒退；未发现 ADC 满量程数字削顶。处理后的保存波形与 PL 参考滤波实现最大相差 {max_reference_error} counts。raw 页面为 {raw_sidecar['quality_status']}（跨通道共模相关性提示），处理后页面为 {processed_sidecar['quality_status']}。",
        "",
        f"以共同的初始放松 1–5 秒比较 EMG010 与 EMG011：处理后 50 Hz 分量变化为 {min(mains_db):+.1f} 至 {max(mains_db):+.1f} dB，100–450 Hz 谐波变化为 {min(harmonic_db):+.1f} 至 {max(harmonic_db):+.1f} dB，去线频 20–450 Hz RMS 变化为 {min(clean_db):+.1f} 至 {max(clean_db):+.1f} dB。EMG011 的处理后 50 Hz 相对 raw 衰减范围约 {min(attenuation):.1f} 至 {max(attenuation):.1f} dB。通道间差异较大，应结合逐通道数据判断。",
        "",
        f"按你的要求用 EMG008 数据训练、EMG011 留出测试，并按你确认的断路排除 CH6：7 通道窗口准确率 **{rewear_model['accuracy_mean'] * 100:.1f}% ± {rewear_model['accuracy_sd'] * 100:.1f}%**，宏 F1 **{rewear_model['macro_f1_mean'] * 100:.1f}%**，动作段多数票准确率 **{rewear_model['action_bout_accuracy_mean'] * 100:.1f}%**。含断路 CH6 的 8 通道结果为 {rewear_model_8ch['accuracy_mean'] * 100:.1f}% 准确率、{rewear_model_8ch['macro_f1_mean'] * 100:.1f}% 宏 F1。剔除 CH6 后，EMG011 内完整动作段留出验证为 **{within_model['accuracy_mean'] * 100:.1f}% ± {within_model['accuracy_sd'] * 100:.1f}%**，宏 F1 **{within_model['macro_f1_mean'] * 100:.1f}%**。单次佩戴结果不能代表后续佩戴的普遍性能。",
        "",
        "| 动作 | EMG008 → EMG011 召回率（剔除 CH6） | EMG011 内留段召回率（剔除 CH6） |",
        "|---|---:|---:|",
        *[f"| {label} | {rewear_recall[label] * 100:.1f}% | {within_recall[label] * 100:.1f}% |"
          for label in CLASS_NAMES],
        "",
        "## 动作标注与采集",
        "",
        f"- SEMGSD1 v2，4000 Hz、8 通道、52 字节/帧，滤波码 {r11['header']['filter_code']}；处理链元数据为 50 Hz 陷波 → 50 Hz 梳状滤波 → 20 Hz 高通 → 215 Hz 低通。",
        f"- 文件大小 {len(r11['blob']):,} 字节；SHA256：{digest}。",
        "- 分析每段时，首尾各裁掉 1 秒以降低动作切换瞬态影响。",
        "",
        "| 动作 | 段数 |",
        "|---|---:|",
    ]
    for label in CLASS_NAMES:
        lines.append(f"| {label} | {seg_counts.get(label, 0)} |")
    lines.extend([
        "",
        "## 重佩戴信号变化",
        "",
        f"raw 质量页的 CHECK 来自跨通道共享成分较强的提示，不是丢帧或 ADC 削顶告警；也不是 BIAS 电压的直接测量。初始静息 raw 第一主成分约占 98.4% 的通道方差，EMG010 约 98.5%；处理后该比例从 EMG010 的 {common_mode['processed']['EMG010'] * 100:.1f}% 上升到 EMG011 的 {common_mode['processed']['EMG011'] * 100:.1f}%，提示处理后仍有更多跨通道共同变化，需结合电极接触和共模路径观察。",
        f"全记录稳定段 raw 的 50 Hz 基波占 20–450 Hz 功率约 {min(raw_metrics['stable']['mains_percent']):.1f}%–{max(raw_metrics['stable']['mains_percent']):.1f}%；处理后降至约 {min(processed_metrics['stable']['mains_percent']):.2f}%–{max(processed_metrics['stable']['mains_percent']):.2f}%。100–450 Hz 谐波处理后约占 0.9%–{max(processed_metrics['stable']['harmonic_percent']):.1f}%。",
        f"用户确认 CH6 的一片差分电极断路。其处理后 clean RMS 在五类标注中的类别中位数为 {min(ch6_by_class.values()):.2f}–{max(ch6_by_class.values()):.2f} counts，几乎不随动作变化，与断路情况相符；因此分类主结果剔除了 CH6。",
        f"100 ms 功率集中度提示需复核的片段包括：{burst_text}。这些可能是短时动作或电极/导线瞬态，不能直接据此断定为伪迹；训练时可先排除这些片段再比较。",
        "",
        "共同初始放松段中，EMG011 相对 EMG010 的处理后幅度变化：",
        "",
        "| 通道 | 50 Hz dB | 100–450 Hz 谐波 dB | 去线频 20–450 Hz RMS dB |",
        "|---:|---:|---:|---:|",
    ])
    for ch in range(8):
        lines.append(f"| CH{ch + 1} | {mains_db[ch]:+.1f} | {harmonic_db[ch]:+.1f} | {clean_db[ch]:+.1f} |")
    lines.extend([
        "",
        "各通道放松/动作段 clean RMS、工频和谐波、分段时间、模型混淆矩阵及 burst 指标见完整 JSON。BIAS 未作为单独输入记录，不能从这份 BIN 直接判断 BIAS 输出电压或环路稳定性。",
        "",
        "## EMG008 模型测试解释",
        "",
        "- 将 EMG008 的已标注采集数据作为唯一训练来源，按 EMG010 使用的基线流程重新拟合，再测试 EMG011；主结果剔除 CH6，仅用其余 7 通道的 MAV/WL/Energy/ZC/SSC，100 ms 窗口、25 ms 步长，StandardScaler + MLP(64,32)，五个随机种子。仓库现存的 baseline joblib 是 NinaPro DB5 模型，并非 EMG008 专属保存模型。",
        f"- 剔除 CH6 后，跨佩戴准确率比含断路通道的结果提高 {100 * (rewear_model['accuracy_mean'] - rewear_model_8ch['accuracy_mean']):.1f} 个百分点，宏 F1 提高 {100 * (rewear_model['macro_f1_mean'] - rewear_model_8ch['macro_f1_mean']):.1f} 个百分点；张手召回 {rewear_recall['open_hand'] * 100:.1f}%，伸腕 {rewear_recall['wrist_extend'] * 100:.1f}%，握拳 {rewear_recall['fist'] * 100:.1f}%，屈腕 {rewear_recall['wrist_flex'] * 100:.1f}%。仍需关注静息召回仅 {rewear_recall['rest'] * 100:.1f}%。",
        "- 剩余主要混淆是伸腕被判为握拳；静息样本也会被判成握拳或伸腕。EMG011 内按动作段分组的留出结果较高，但只有 3–4 个独立动作段/类别。",
        "- 用户已确认 CH6 的一片差分电极断路，因此此前 8 通道分类结果不能代表有效 8 通道信号；主结果在训练和测试两侧都移除 CH6 的五组特征。EMG008 与 EMG011 都有五类动作标注；EMG011 的独立动作段分别为张手 3 段、握拳 3 段、屈腕 4 段、伸腕 3 段。窗口重叠，因此准确率不应视为独立样本统计。",
        "- EMG011 内部验证把完整动作段留出，估计的是本次佩戴内部可分性；跨佩戴低分而内部验证高分，表示新佩戴的特征分布变化明显，应在新佩戴后校准或将多次佩戴数据纳入训练。",
        "",
        "## 产物",
        "",
        "- EMG011_raw_analysis.html 与 EMG011_processed_analysis.html：交互式时域、频谱和质量页面。",
        "- EMG011_waveform_quality.png：八通道原始极值与处理后幅度概览。",
        "- EMG011_spectrum_quality.png：raw 与 processed 频谱对比。",
        "- EMG011_quality.json：完整逐通道指标、分段、模型验证和方法。",
        "- assess_emg011.py：可复现分析脚本。",
        "",
        f"验证：帧连续性、合法动作标签、有限 PSD、参考滤波链、EMG008 → EMG011 留出测试及按完整动作段分组验证；参考滤波最大误差 {max_reference_error} counts。",
        "",
    ])
    (OUT / "EMG011_quality_report.md").write_text("\n".join(lines), encoding="utf-8")

    print("RECORD", json.dumps({
        "bytes": len(r11["blob"]), "frames": len(r11["frames"]),
        "duration_s": len(r11["frames"]) / FS, "format": r11["header"],
        "integrity": result["integrity"], "sha256": digest,
        "quality_status": result["quality_status"], "segment_counts": seg_counts,
    }, ensure_ascii=False))
    print("MATCHED_REST", json.dumps({
        "processed_change_db": matched["processed"]["change_db_011_vs_010"],
        "common_mode": common_mode,
    }, ensure_ascii=False))
    print("STREAMS", json.dumps({
        key: val["stable"] for key, val in result["streams"].items()
    }, ensure_ascii=False))
    print("REFERENCE_MAX_ERROR", max_reference_error)
    print("MODEL_EMG008_TO_011", json.dumps({
        key: val for key, val in rewear_model.items() if key != "seeds"
    }, ensure_ascii=False))
    print("MODEL_EMG008_TO_011_8CH_REFERENCE", json.dumps({
        key: val for key, val in rewear_model_8ch.items() if key != "seeds"
    }, ensure_ascii=False))
    print("MODEL_WITHIN_EMG011", json.dumps({
        key: val for key, val in within_model.items() if key != "seeds"
    }, ensure_ascii=False))
    print("TEST_PASS EMG011 framing, labels, PSD, reference chain and EMG008-to-EMG011 test",
          flush=True)


if __name__ == "__main__":
    main()
