"""Compare complete routed designs and check V15's functional evidence."""
from pathlib import Path
import hashlib,json,re,shutil,sys,zipfile
sys.stdout.reconfigure(encoding='utf-8')
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
PREV=ROOT/'report/resource_optimization_full_20261027'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def value(path,label):
    m=re.search(r'^\|\s*'+re.escape(label)+r'\*?\s*\|\s*([\d.]+)\s*\|',path.read_text(encoding='utf-8',errors='replace'),re.M)
    assert m,(path,label)
    n=float(m[1]);return int(n) if n.is_integer() else n
def routed(folder):
    p=folder/'utilization_routed.rpt';text=p.read_text(encoding='utf-8',errors='replace')
    assert 'Design State : Routed' in text
    labels={'lut':'Slice LUTs','ff':'Slice Registers','slice':'Slice','bram':'Block RAM Tile','dsp':'DSPs'}
    result={k:value(p,v) for k,v in labels.items()}
    t=(folder/'timing_routed.rpt').read_text(encoding='utf-8',errors='replace')
    assert 'All user specified timing constraints are met.' in t
    m=re.search(r'WNS\(ns\).*?\n\s*[- ]+\n\s*([\d.\-]+)\s+([\d.\-]+)\s+(\d+)\s+(\d+)\s+([\d.\-]+)',t)
    assert m
    result.update(wns_ns=float(m[1]),whs_ns=float(m[5]),control_sets=value(folder/'control_sets.rpt','Total control sets'))
    assert value(p,'Register as Latch')==0
    return result

manifest=json.loads((HERE/'baseline/manifest.json').read_text(encoding='utf-8'))
inputs=[]
for rel,item in manifest['files'].items():
    if not rel.startswith(('src/rtl/','board/constraints/','data/models/')):continue
    new=sha(ROOT/rel)
    inputs.append(dict(path=rel,baseline=item['sha256'],candidate=new))
changed=[x['path'] for x in inputs if x['baseline']!=x['candidate']]
assert set(changed)=={'src/rtl/emg_nn_infer.v','src/rtl/hand_servo_pwm.v','src/rtl/emg_fatigue.v'},changed
for rel in changed:assert sha(HERE/'baseline'/rel)==manifest['files'][rel]['sha256']
old=json.loads((PREV/'comparison.json').read_text(encoding='utf-8'))
def old_flat(item):
    return {**{k.lower():v for k,v in item['resources'].items()},'wns_ns':item['timing']['WNS_ns'],'whs_ns':item['timing']['WHS_ns'],'control_sets':item['control_sets']}
results={'v13':old_flat(old['V13']),'v14':old_flat(old['candidate']),'v15':routed(HERE/'candidate'),'changed_inputs':changed,'inputs':inputs}
drc=(HERE/'candidate/drc.rpt').read_text(encoding='utf-8',errors='replace')
assert not re.search(r'^\|[^\n|]+\|\s*(?:Error|Critical Warning)\s*\|',drc,re.M)
skew=(HERE/'candidate/bus_skew.rpt').read_text(encoding='utf-8',errors='replace')
slacks=[float(s) for s in re.findall(r'^\s+(?:Slow|Fast)\s+[\d.]+\s+[\d.]+\s+([-\d.]+)\s*$',skew,re.M)]
assert slacks and min(slacks)>=0
results['bus_skew_min_slack_ns']=min(slacks)
checks={'equivalence.log':'TEST_PASS V15 MLP PWM equivalence complete',
 'fatigue_equivalence.log':'TEST_PASS V15 fatigue cycle-exact 576 words',
 'fatigue_regression.log':'TEST_PASS fatigue FFT 576 words',
 'netlist_test_complete.log':'TEST_PASS V15 synthesized modules complete',
 'integrated_test.log':'TEST_PASS V15 integrated OOC MLP FFT',
 'control_regression.log':'TEST_PASS PL shell',
 'final_gates.log':'PIPELINE RESULT: ALL GATES PASS'}
for file,terminal in checks.items():assert terminal in (HERE/file).read_text(encoding='utf-8',errors='replace'),file
with zipfile.ZipFile(HERE/'baseline/design_1.xsa') as a,zipfile.ZipFile(ROOT/'build/export/design_1.xsa') as b:
    matches=[]
    for name in a.namelist():
        if name.endswith(('.hwh','ps7_init.c','ps7_init.h')):
            aa,bb=a.read(name),b.read(name)
            if name.endswith('.hwh'):
                aa=re.sub(rb' TIMESTAMP="[^"]*"',b'',aa);bb=re.sub(rb' TIMESTAMP="[^"]*"',b'',bb)
            assert aa==bb,name
            matches.append(name)
    bit=ROOT/'build/vivado/hand_motion_reconstruction.runs/impl_1/design_1.bit'
    assert b.read('design_1.bit')==bit.read_bytes()
    results['hardware_interface_inherited']=matches
results['module_synthesis']={}
for module in ('emg_nn_infer','hand_servo_pwm','emg_fatigue'):
    results['module_synthesis'][module]={variant:{key:value(HERE/f'{variant}_{module}_utilization.rpt',label) for key,label in {'lut':'Slice LUTs','ff':'Slice Registers','dsp':'DSPs'}.items()} for variant in ('baseline','candidate')}
results['performance']={'sample_rate_per_channel_sps':4000,'window_samples':400,'hop_samples':100,'pwm_period_us':20000,'additional_latency_cycles':0,'learning_max_cycles_inherited':old['learning_max_cycles']['candidate'],'scope':'RTL cycle comparison, functional netlist and routed static timing; not on-board timing or power'}
rows=['| 指标 | V13 基线 | V14 | V15 | 较 V14 | 较 V13 |','|---|---:|---:|---:|---:|---:|']
for key in ('lut','ff','slice','bram','dsp','control_sets'):
    a,b,c=(results[v][key] for v in ('v13','v14','v15'))
    rows.append(f'| {key} | {a:g} | {b:g} | {c:g} | {(c-b)/b:+.2%} | {(c-a)/a:+.2%} |')
for key in ('wns_ns','whs_ns'):
    a,b,c=(results[v][key] for v in ('v13','v14','v15'))
    rows.append(f'| {key} | {a:+.3f} | {b:+.3f} | {c:+.3f} | — | — |')
(HERE/'resource_table.md').write_text('\n'.join(rows)+'\n',encoding='utf-8')
performance_rows=['| 性能指标 | V13 / V14 | V15 |','|---|---:|---:|',
 '| 每通道采样率 | 4 kSPS | 4 kSPS |',
 '| 特征窗口 / 更新间隔 | 100 / 25 ms | 100 / 25 ms |',
 '| 特征域 / 学习核时钟 | 25 / 100 MHz | 25 / 100 MHz |',
 '| 本轮增加流水延迟 | — | 0 周期 |',
 '| PWM 周期 | 20 ms | 20 ms |',
 '| NMF 最大核内仿真耗时 | 39.58 μs | 39.58 μs |',
 '| HDC 尺度更新最大核内仿真耗时 | 7.82 μs | 7.82 μs |',
 '| HDC 原型更新最大核内仿真耗时 | 238.63 μs | 238.63 μs |',
 '| HDC 六类推理最大核内仿真耗时 | 771.88 μs | 771.88 μs |',
 '', '学习核数字对应 100 MHz、相同测试向量及指定 AXI 背压模型。数值计算与输出周期按功能仿真核验，实际工作频率按 Routed 时序核验；此表不将核内周期等同于端到端板测响应。']
(HERE/'performance_table.md').write_text('\n'.join(performance_rows)+'\n',encoding='utf-8')
for path in (bit,ROOT/'build/export/design_1.xsa',ROOT/'build/vivado/hand_motion_reconstruction.runs/impl_1/design_1_routed.dcp'):
    shutil.copy2(path,HERE/'candidate'/path.name)
results['evidence_hashes']={p:sha(HERE/p) for p in checks}
results['artifact_hashes']={p.name:sha(p) for p in (HERE/'candidate').iterdir() if p.suffix in ('.bit','.xsa','.dcp')}
(HERE/'comparison.json').write_text(json.dumps(results,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print('\n'.join(rows));print('V15_RESOURCE_PERFORMANCE_COMPARISON_PASS')
