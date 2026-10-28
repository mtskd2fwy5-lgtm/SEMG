"""Validate frozen V13, first-pass and final routed evidence; emit comparison."""
from pathlib import Path
import hashlib
import json
import re
import shutil
import sys
import zipfile

sys.stdout.reconfigure(encoding='utf-8')

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
FIRST = ROOT / 'report/resource_optimization_20261027'


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def value(path, label):
    body = path.read_text(encoding='utf-8', errors='replace')
    m = re.search(r'^\|\s*' + re.escape(label) + r'\s*\|\s*([\d.]+)\s*\|', body, re.M)
    assert m, (path, label)
    return float(m[1])


def timing(path):
    body = path.read_text(encoding='utf-8', errors='replace')
    assert 'Design State : Routed' in body
    assert 'All user specified timing constraints are met.' in body
    m = re.search(r'WNS\(ns\).*?\n\s*[- ]+\n\s*([\d.\-]+)\s+([\d.\-]+)\s+(\d+)\s+(\d+)\s+([\d.\-]+)', body)
    assert m, path
    clocks = {}
    for clock in ('pl_clk', 'clk_fpga_0'):
        row = re.search(r'^' + clock + r'\s+([\d.\-]+)\s+([\d.\-]+)\s+(\d+)\s+(\d+)\s+([\d.\-]+)', body, re.M)
        assert row, clock
        clocks[clock] = {'WNS_ns': float(row[1]), 'WHS_ns': float(row[5])}
    return {'WNS_ns': float(m[1]), 'WHS_ns': float(m[5]), 'clocks': clocks}


def hierarchy(path):
    result = {}
    for line in path.read_text(encoding='utf-8', errors='replace').splitlines():
        cols = [x.strip() for x in line.split('|')[1:-1]]
        if len(cols) == 10 and cols[0] in ('u_feature_bank', 'u_notch50', 'u_emg_fatigue', 'emg_learning_0'):
            result[cols[0]] = dict(zip(('LUT', 'FF', 'BRAM36', 'BRAM18', 'DSP'),
                (int(cols[2]), int(cols[6]), int(cols[7]), int(cols[8]), int(cols[9]))))
    return result


manifest = json.loads((FIRST / 'baseline/manifest.json').read_text(encoding='utf-8'))
inputs = []
for rel, info in manifest['files'].items():
    rel = rel.replace('\\', '/')
    if not rel.startswith(('src/rtl/', 'board/constraints/')):
        continue
    assert sha(FIRST / 'baseline' / rel) == info['sha256'], f'Frozen V13 changed: {rel}'
    inputs.append({'path': rel, 'baseline': info['sha256'], 'candidate': sha(ROOT / rel)})
changed = [x['path'] for x in inputs if x['baseline'] != x['candidate']]
assert set(changed) == {'src/rtl/emg_window_features.v', 'src/rtl/emg_bandpass.v',
                       'src/rtl/emg_feature_bank.v', 'src/rtl/emg_line_filter.v'}, changed
first_evidence = json.loads((FIRST / 'comparison.json').read_text(encoding='utf-8'))
for item in first_evidence['inputs']:
    frozen = HERE / 'baseline' / item['path']
    if frozen.is_file():
        assert sha(frozen) == item['candidate'], f'First-pass source changed: {frozen}'

labels = {'LUT': 'Slice LUTs', 'FF': 'Slice Registers', 'Slice': 'Slice', 'BRAM': 'Block RAM Tile', 'DSP': 'DSPs'}
capacity = {'LUT': 53200, 'FF': 106400, 'Slice': 13300, 'BRAM': 140, 'DSP': 220}
results = {'changed_inputs': changed, 'inputs': inputs}
folders = {'V13': FIRST / 'baseline', 'first_pass': FIRST / 'candidate', 'candidate': HERE / 'candidate'}
for variant, folder in folders.items():
    path = folder / 'utilization_routed.rpt'
    assert 'Design State : Routed' in path.read_text(encoding='utf-8', errors='replace')
    results[variant] = {'resources': {k: value(path, label) for k, label in labels.items()},
        'control_sets': value(folder / 'control_sets.rpt', 'Total control sets'),
        'timing': timing(folder / 'timing_routed.rpt'), 'hierarchy': hierarchy(folder / 'utilization_hierarchical.rpt')}
assert results['V13']['resources'] == first_evidence['baseline']['resources']
assert results['first_pass']['resources'] == first_evidence['candidate']['resources']
assert value(HERE / 'candidate/utilization_routed.rpt', 'Register as Latch') == 0
drc = (HERE / 'candidate/drc.rpt').read_text(encoding='utf-8', errors='replace')
assert not re.search(r'^\|[^\n|]+\|\s*(?:Error|Critical Warning)\s*\|', drc, re.M)
skew = (HERE / 'candidate/bus_skew.rpt').read_text(encoding='utf-8', errors='replace')
skew_slacks = [float(s) for s in re.findall(r'^\s+(?:Slow|Fast)\s+[\d.]+\s+[\d.]+\s+([-\d.]+)\s*$', skew, re.M)]
assert skew_slacks and min(skew_slacks) >= 0, 'Bus skew constraints failed or missing'
results['bus_skew_min_slack_ns'] = min(skew_slacks)

with zipfile.ZipFile(FIRST / 'baseline/design_1.xsa') as old, zipfile.ZipFile(ROOT / 'build/export/design_1.xsa') as new:
    matches = []
    for name in old.namelist():
        if name.endswith(('.hwh', 'ps7_init.c', 'ps7_init.h')):
            a, b = old.read(name), new.read(name)
            if name.endswith('.hwh'):
                a = re.sub(rb' TIMESTAMP="[^"]*"', b'', a)
                b = re.sub(rb' TIMESTAMP="[^"]*"', b'', b)
            assert a == b, f'Platform handoff changed: {name}'
            matches.append(name)
    assert new.read('design_1.bit') == (ROOT / 'build/vivado/hand_motion_reconstruction.runs/impl_1/design_1.bit').read_bytes()
    results['hardware_handoff_match_ignoring_timestamp'] = matches

checks = {'shared_equiv.log': 'TEST_PASS shared arithmetic equivalence complete',
          'shared_netlist.log': 'TEST_PASS shared synthesized pipeline',
          'shared_integrated_netlist.log': 'TEST_PASS shared synthesized pipeline integrated OOC',
          'processed_filter.log': 'TEST_PASS line_filter: bit-exact',
          'control_regression.log': 'TEST_PASS PL shell',
          'full_build.log': 'PIPELINE RESULT: ALL GATES PASS'}
for filename, terminal in checks.items():
    assert terminal in (HERE / filename).read_text(encoding='utf-8', errors='replace'), filename
cycles = {}
for variant, path in (('V13', FIRST / 'baseline_learning_regression.log'), ('candidate', HERE / 'learning_regression.log')):
    log = path.read_text(encoding='utf-8', errors='replace')
    assert 'TEST_PASS learning accelerator complete' in log
    cycles[variant] = {int(job): int(count) for job, count in re.findall(r'LEARNING_CYCLES job(\d+) max=(\d+)', log)}
    assert len(cycles[variant]) == 4
assert cycles['V13'] == cycles['candidate']
results['learning_max_cycles'] = cycles
results['performance_scope'] = 'cycle-exact RTL/functional netlist and static routed timing; not on-board latency or power'

rows = ['| 资源 | 原 V13 | 首轮 | 本轮最终 | 相对 V13 |', '|---|---:|---:|---:|---:|']
for key, available in capacity.items():
    vals = [results[v]['resources'][key] for v in folders]
    formatted = [f'{v:g}（{v/available:.2%}）' for v in vals]
    rows.append('| ' + key + ' | ' + ' | '.join(formatted) + f' | {(vals[2]-vals[0])/vals[0]:+.2%} |')
vals = [results[v]['control_sets'] for v in folders]
rows.append('| 控制集 | ' + ' | '.join(f'{v:g}' for v in vals) + f' | {(vals[2]-vals[0])/vals[0]:+.2%} |')
(HERE / 'resource_table.md').write_text('\n'.join(rows) + '\n', encoding='utf-8')

rows = ['| 性能指标 | 原 V13 | 本轮最终 |', '|---|---:|---:|']
for label, val in (('每通道采样率', '4 kSPS'), ('窗口/更新间隔', '100/25 ms'),
    ('实际特征/学习核时钟', '25/100 MHz'), ('特征、带通共享核输入 II', '1 周期'),
    ('优化新增流水延迟', '0 周期')):
    rows.append(f'| {label} | {val} | {val} |')
for label, key in (('整机 WNS', 'WNS_ns'), ('整机 WHS', 'WHS_ns')):
    a, b = (results[v]['timing'][key] for v in ('V13', 'candidate'))
    rows.append(f'| {label} | {a:+.3f} ns | {b:+.3f} ns |')
for clock in ('pl_clk', 'clk_fpga_0'):
    a, b = (results[v]['timing']['clocks'][clock]['WNS_ns'] for v in ('V13', 'candidate'))
    rows.append(f'| {clock} 域 WNS | {a:+.3f} ns | {b:+.3f} ns |')
for job, label in ((1, 'NMF / 窗'), (2, 'HDC 尺度更新'), (3, 'HDC 原型更新 / 样本'), (4, 'HDC 六类推理')):
    a, b = (cycles[v][job] for v in ('V13', 'candidate'))
    rows.append(f'| {label}仿真最大耗时 | {a:,} 周期 / {a/100:.2f} µs | {b:,} 周期 / {b/100:.2f} µs |')
(HERE / 'performance_table.md').write_text('\n'.join(rows) + '\n', encoding='utf-8')

artifacts = [ROOT / 'build/vivado/hand_motion_reconstruction.runs/impl_1/design_1.bit',
             ROOT / 'build/vivado/hand_motion_reconstruction.runs/impl_1/design_1_routed.dcp',
             ROOT / 'build/export/design_1.xsa']
for path in artifacts:
    shutil.copy2(path, HERE / 'candidate' / path.name)
results['artifact_hashes'] = {p.relative_to(ROOT).as_posix(): sha(p) for p in artifacts}
evidence = [HERE / filename for filename in checks] + [HERE / 'learning_regression.log',
    HERE / 'integrated_pl_export.v', ROOT / 'sim/emg_shared_equiv_tb.sv',
    ROOT / 'sim/emg_shared_netlist_tb.sv', ROOT / 'sim/emg_shared_integrated_netlist_tb.sv',
    ROOT / 'sim/emg_learning_accel_tb.sv', ROOT / 'sim/results_learning/learning_vectors.mem',
    ROOT / 'build/scripts/run_shared_equiv_test.ps1', ROOT / 'build/scripts/run_shared_netlist_test.ps1']
results['evidence_hashes'] = {p.relative_to(ROOT).as_posix(): sha(p) for p in evidence}
(HERE / 'comparison.json').write_text(json.dumps(results, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print((HERE / 'resource_table.md').read_text(encoding='utf-8'))
print('\n'.join(rows))
print('FULL_RESOURCE_PERFORMANCE_COMPARISON_PASS')
