"""Compare V16's accepted hardware against the actual V17 routed design."""
from pathlib import Path
import json,re

ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'report/imu_pl_20261028'

def value(text,label):
    m=re.search(r'^\|\s*'+re.escape(label)+r'\*?\s*\|\s*([\d.]+)\s*\|',text,re.M)
    assert m,label
    n=float(m[1]);return int(n) if n.is_integer() else n

def main():
    old=json.loads((ROOT/'report/resource_optimization_v15_20261027/comparison.json').read_text())['v15']
    util=(OUT/'utilization_routed.rpt').read_text()
    assert 'Design State : Routed' in util
    new={k:value(util,v) for k,v in {'lut':'Slice LUTs','ff':'Slice Registers','slice':'Slice','bram':'Block RAM Tile','dsp':'DSPs'}.items()}
    assert value(util,'Register as Latch')==0
    timing=(OUT/'timing_routed.rpt').read_text()
    assert 'All user specified timing constraints are met.' in timing
    m=re.search(r'WNS\(ns\).*?\n\s*[- ]+\n\s*([-\d.]+)\s+([-\d.]+)\s+(\d+)\s+(\d+)\s+([-\d.]+)',timing)
    assert m
    new.update(wns_ns=float(m[1]),whs_ns=float(m[5]))
    drc=(OUT/'drc.rpt').read_text()
    assert not re.search(r'^\|[^\n|]+\|\s*(?:Error|Critical Warning)\s*\|',drc,re.M)
    skew=(OUT/'bus_skew.rpt').read_text()
    slacks=[float(x) for x in re.findall(r'^\s+(?:Slow|Fast)\s+[\d.]+\s+[\d.]+\s+([-\d.]+)\s*$',skew,re.M)]
    assert slacks and min(slacks)>=0 and 'mpu_attitude_0/inst/sensor_' in skew
    rows=['| 指标 | V16（复用 V15 硬件） | V17 姿态迁移 | 增量 |', '|---|---:|---:|---:|']
    for key in ('lut','ff','slice','bram','dsp'):
        rows.append(f'| {key} | {old[key]:g} | {new[key]:g} | {new[key]-old[key]:+g} |')
    for key in ('wns_ns','whs_ns'):
        rows.append(f'| {key} | {old[key]:+.3f} | {new[key]:+.3f} | — |')
    comparison=json.loads((OUT/'float_comparison.json').read_text())
    rtl=(OUT/'rtl_vectors.log').read_text()
    m=re.search(r'TEST_PASS PL attitude bit-exact replay samples=\s*(\d+) resets=\s*(\d+) peak_cycles=\s*(\d+)',rtl)
    assert m
    perf={'clock_hz':100_000_000,'sensor_hz':100,'sample_count':int(m[1]),'resets':int(m[2]),
          'observed_peak_cycles':int(m[3]),'observed_peak_us':int(m[3])/100,
          'max_matrix_component_error':comparison['max_matrix_component_error'],
          'max_twist_error_degrees':comparison['max_twist_error_degrees'],
          'scope':'Trace-observed core latency and routed timing, not measured board latency or power.'}
    result={'v16':old,'v17':new,'delta':{k:new[k]-old[k] for k in ('lut','ff','slice','bram','dsp')},
            'bus_skew_min_slack_ns':min(slacks),'performance':perf}
    (OUT/'comparison.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    (OUT/'resource_table.md').write_text('\n'.join(rows)+'\n',encoding='utf-8')
    print('\n'.join(rows));print('TEST_PASS V17 routed resource and performance comparison')

if __name__=='__main__':main()
