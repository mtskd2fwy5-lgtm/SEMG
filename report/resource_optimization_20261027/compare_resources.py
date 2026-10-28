"""Compare same-stage routed reports; fail on changed inputs or missing evidence."""
from pathlib import Path
import hashlib
import json
import re
import shutil
import zipfile

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]


def table_value(path, label):
    text = path.read_text(encoding="utf-8", errors="replace")
    match = re.search(r"^\|\s*" + re.escape(label) + r"\s*\|\s*([\d.]+)\s*\|", text, re.M)
    if not match:
        raise ValueError(f"Missing {label} in {path}")
    return float(match[1])


def timing(path):
    text = path.read_text(encoding="utf-8", errors="replace")
    assert "Design State : Routed" in text
    assert "All user specified timing constraints are met." in text
    match = re.search(r"WNS\(ns\).*?\n\s*[- ]+\n\s*([\d.\-]+)\s+([\d.\-]+)\s+(\d+)\s+(\d+)\s+([\d.\-]+)", text)
    if not match:
        raise ValueError(f"Missing timing summary in {path}")
    clocks = {}
    for name in ("pl_clk", "clk_fpga_0"):
        row = re.search(r"^" + name + r"\s+([\d.\-]+)\s+([\d.\-]+)\s+(\d+)\s+(\d+)\s+([\d.\-]+)", text, re.M)
        if not row:
            raise ValueError(f"Missing clock {name}")
        clocks[name] = {"WNS_ns": float(row[1]), "WHS_ns": float(row[5])}
    return {"WNS_ns": float(match[1]), "WHS_ns": float(match[5]), "clocks": clocks}


def hierarchy(path):
    result = {}
    for line in path.read_text(encoding="utf-8", errors="replace").splitlines():
        fields = [x.strip() for x in line.split("|")[1:-1]]
        if len(fields) == 10 and fields[0] in ("u_feature_bank", "gen_ch[0].u_features", "emg_learning_0", "u_fatigue", "u_line_filter"):
            result[fields[0]] = dict(zip(("LUT", "FF", "BRAM36", "BRAM18", "DSP"),
                (int(fields[2]), int(fields[6]), int(fields[7]), int(fields[8]), int(fields[9]))))
    return result


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


baseline_manifest = json.loads((HERE / "baseline/manifest.json").read_text(encoding="utf-8"))
inputs = []
for rel, info in baseline_manifest["files"].items():
    normalized = rel.replace("\\", "/")
    if not normalized.startswith(("src/rtl/", "board/constraints/")):
        continue
    frozen = HERE / "baseline" / normalized
    current = ROOT / normalized
    assert sha(frozen) == info["sha256"], f"Frozen baseline modified: {rel}"
    inputs.append({"path": normalized, "baseline": info["sha256"], "candidate": sha(current)})
changed = [x["path"] for x in inputs if x["baseline"] != x["candidate"]]
assert changed == ["src/rtl/emg_window_features.v"], changed

labels = {"LUT": "Slice LUTs", "FF": "Slice Registers", "Slice": "Slice", "BRAM": "Block RAM Tile", "DSP": "DSPs"}
capacity = {"LUT": 53200, "FF": 106400, "Slice": 13300, "BRAM": 140, "DSP": 220}
results = {"changed_inputs": changed, "inputs": inputs}
with zipfile.ZipFile(HERE / "baseline/design_1.xsa") as old_xsa, zipfile.ZipFile(ROOT / "build/export/design_1.xsa") as new_xsa:
    handoff_checks = []
    for name in old_xsa.namelist():
        if not name.endswith((".hwh", "ps7_init.c", "ps7_init.h")):
            continue
        old, new = old_xsa.read(name), new_xsa.read(name)
        if name.endswith(".hwh"):
            old = re.sub(rb' TIMESTAMP="[^"]*"', b'', old)
            new = re.sub(rb' TIMESTAMP="[^"]*"', b'', new)
        assert old == new, f"Unexpected hardware handoff change: {name}"
        handoff_checks.append(name)
    assert new_xsa.read("design_1.bit") == (ROOT / "build/vivado/hand_motion_reconstruction.runs/impl_1/design_1.bit").read_bytes()
    results["hardware_handoff_match_ignoring_timestamp"] = handoff_checks
for variant in ("baseline", "candidate"):
    folder = HERE / variant
    utilization = folder / "utilization_routed.rpt"
    assert "Design State : Routed" in utilization.read_text(encoding="utf-8", errors="replace")
    results[variant] = {"resources": {key: table_value(utilization, label) for key, label in labels.items()},
        "control_sets": table_value(folder / "control_sets.rpt", "Total control sets"),
        "timing": timing(folder / "timing_routed.rpt"),
        "hierarchy": hierarchy(folder / "utilization_hierarchical.rpt")}

for filename in ("feature_rtl_runner.log", "feature_netlist_runner.log"):
    log = (HERE / filename).read_text(encoding="utf-8", errors="replace")
    assert "TEST_PASS feature width equivalence complete" in log, filename
    assert "first_span_cycles=399 output_interval_cycles=100 continuous_windows=117" in log, filename
assert "TEST_PASS PL shell" in (HERE / "control_regression.log").read_text(encoding="utf-8", errors="replace")
assert "PIPELINE RESULT: ALL GATES PASS" in (HERE / "full_build.log").read_text(encoding="utf-8", errors="replace")
learning_cycles = {}
for variant, filename in (("baseline", "baseline_learning_regression.log"), ("candidate", "learning_regression.log")):
    log = (HERE / filename).read_text(encoding="utf-8", errors="replace")
    assert "TEST_PASS learning accelerator complete" in log
    learning_cycles[variant] = {int(job): int(count) for job, count in re.findall(r"LEARNING_CYCLES job(\d+) max=(\d+)", log)}
    assert len(learning_cycles[variant]) == 4
assert learning_cycles["baseline"] == learning_cycles["candidate"], "Learning kernel cycle regression"
results["learning_max_cycles"] = learning_cycles

rows = ["| 资源 | 优化前 | 优化后 | 变化 | 相对变化 |", "|---|---:|---:|---:|---:|"]
for key, available in capacity.items():
    old, new = (results[v]["resources"][key] for v in ("baseline", "candidate"))
    rows.append(f"| {key} | {old:g}（{old/available:.2%}） | {new:g}（{new/available:.2%}） | {new-old:+g} | {(new-old)/old:+.2%} |")
old, new = (results[v]["control_sets"] for v in ("baseline", "candidate"))
rows.append(f"| 控制集 | {old:g} | {new:g} | {new-old:+g} | {(new-old)/old:+.2%} |")
(HERE / "resource_table.md").write_text("\n".join(rows) + "\n", encoding="utf-8")

rows = ["| 性能指标 | 优化前 | 优化后 |", "|---|---:|---:|"]
for name, old, new in (
    ("采样率/通道", "4 kSPS", "4 kSPS"),
    ("特征窗长/步长", "400/100 样本", "400/100 样本"),
    ("窗口时长/更新间隔", "100/25 ms", "100/25 ms"),
    ("特征核输入启动间隔 II", "1 周期", "1 周期"),
    ("连续输入首样本到首窗跨度", "399 周期", "399 周期"),
    ("连续输入后续输出间隔", "100 周期", "100 周期"),
    ("实际特征时钟 / 学习核时钟", "25/100 MHz", "25/100 MHz"),
):
    rows.append(f"| {name} | {old} | {new} |")
for label, field in (("整机 WNS", "WNS_ns"), ("整机 WHS", "WHS_ns")):
    old, new = (results[v]["timing"][field] for v in ("baseline", "candidate"))
    rows.append(f"| {label} | {old:+.3f} ns | {new:+.3f} ns |")
for clock in ("pl_clk", "clk_fpga_0"):
    old, new = (results[v]["timing"]["clocks"][clock]["WNS_ns"] for v in ("baseline", "candidate"))
    rows.append(f"| {clock} 域 WNS | {old:+.3f} ns | {new:+.3f} ns |")
for job, label in ((1, "NMF / 窗"), (2, "HDC 尺度更新"), (3, "HDC 原型更新 / 样本"), (4, "HDC 六类推理")):
    old, new = (learning_cycles[v][job] for v in ("baseline", "candidate"))
    rows.append(f"| {label}仿真最大耗时 | {old:,} 周期 / {old/100:.2f} µs | {new:,} 周期 / {new/100:.2f} µs |")
(HERE / "performance_table.md").write_text("\n".join(rows) + "\n", encoding="utf-8")
candidate_artifacts = (
    ROOT / "build/vivado/hand_motion_reconstruction.runs/impl_1/design_1.bit",
    ROOT / "build/vivado/hand_motion_reconstruction.runs/impl_1/design_1_routed.dcp",
    ROOT / "build/export/design_1.xsa",
)
for path in candidate_artifacts:
    shutil.copy2(path, HERE / "candidate" / path.name)
results["artifact_hashes"] = {str(p.relative_to(ROOT)).replace("\\", "/"): sha(p) for p in candidate_artifacts}
results["evidence_hashes"] = {str(p.relative_to(ROOT)).replace("\\", "/"): sha(p) for p in (
    ROOT / "sim/emg_feature_width_equiv_tb.sv", ROOT / "sim/emg_learning_accel_tb.sv",
    ROOT / "sim/results_learning/learning_vectors.mem", ROOT / "build/scripts/run_feature_width_equiv_test.ps1",
    HERE / "feature_rtl_runner.log", HERE / "feature_netlist_runner.log", HERE / "control_regression.log",
    HERE / "learning_regression.log", HERE / "baseline_learning_regression.log", HERE / "full_build.log",
)}
(HERE / "comparison.json").write_text(json.dumps(results, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
print("RESOURCE_PERFORMANCE_COMPARISON_PASS")
print("\n".join(rows))
