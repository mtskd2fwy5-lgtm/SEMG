"""V17 acceptance gates; retain all previous BOOT version gates unchanged."""
from pathlib import Path
import hashlib,json,re,xml.etree.ElementTree as ET,zipfile
ROOT=Path(__file__).resolve().parents[1]
REPORT=ROOT/'report/imu_pl_20261028'
def digest(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def evidence(p):
    data=p.read_bytes()
    return data.decode('utf-16' if data.startswith((b'\xff\xfe',b'\xfe\xff')) else 'utf-8',errors='replace')
def verify(xsa):
    old=json.loads((ROOT/'report/resource_optimization_v15_20261027/artifacts.json').read_text())
    inherited=[]
    for e in old['artifacts']:
        p=Path(e['path']);s=p.as_posix()
        if s.startswith('src/rtl/') or p.suffix in ('.xdc','.mem'):
            assert digest(ROOT/p)==e['sha256'],f'Inherited PL/constraint/model changed: {s}'
            inherited.append(s)
        if s.startswith('sw/ps_uart_print/') and p.suffix.lower() in ('.c','.h','.s','.ld'):
            if p.name in ('main.c','lcd_imu_3d.h','hand_control.h','lcd_hdc.h'):continue
            assert digest(ROOT/p)==e['sha256'],f'Unrelated PS behavior changed: {s}'
            inherited.append(s)
    for s in ('sw/ps_uart_print/hand_control.h','sw/ps_uart_print/lcd_hdc.h'):
        assert digest(ROOT/s)==digest(REPORT/'baseline'/s),f'V16 stability behavior changed: {s}'
    assert len(inherited)>=40,'Incomplete inheritance gate'
    cdc=(ROOT/'board/constraints/hz_zynq_imu_clock_groups.xdc').read_text()
    assert 'set_max_delay -datapath_only 20.0' in cdc and 'set_bus_skew 10.0' in cdc
    with zipfile.ZipFile(xsa) as z:
        docs=[ET.fromstring(z.read(n)) for n in z.namelist() if n.endswith('.hwh')]
    modules={m.attrib.get('INSTANCE'):m for d in docs for m in d.iter('MODULE')}
    assert 'mpu_attitude_0' in modules and 'axi_gpio_7' in modules,'Attitude hardware absent'
    params={p.attrib['NAME']:p.attrib.get('VALUE') for p in modules['axi_gpio_7'].iter('PARAMETER')}
    for k,v in {'C_GPIO_WIDTH':'32','C_GPIO2_WIDTH':'32','C_IS_DUAL':'1','C_ALL_OUTPUTS':'1','C_ALL_INPUTS_2':'1'}.items():
        assert params.get(k)==v,f'Attitude GPIO differs: {k}'
    with zipfile.ZipFile(REPORT/'baseline/build/export/design_1.xsa') as z:
        olddocs=[ET.fromstring(z.read(n)) for n in z.namelist() if n.endswith('.hwh')]
    def ps_params(docs):
        return {p.attrib['NAME']:p.attrib.get('VALUE') for d in docs for m in d.iter('MODULE')
                if m.attrib.get('INSTANCE')=='processing_system7_0' for p in m.iter('PARAMETER')
                if p.attrib.get('NAME','').startswith('PCW_')}
    assert ps_params(docs)==ps_params(olddocs),'Unexpected PS clock/pin/DDR change'
    proof=json.loads((REPORT/'regression_sources.json').read_text())
    for s,h in proof.items():assert digest(ROOT/s)==h,f'Stale V17 regression: {s}'
    for s in ('src/rtl/mpu_attitude_core.v','src/rtl/mpu_attitude.v','src/rtl/mpu_attitude_rom.vh',
              'sw/ps_uart_print/main.c','sw/ps_uart_print/lcd_imu_3d.h','sim/imu_host_model.h'):
        assert s in proof,f'Missing source binding: {s}'
    tests={'rtl_vectors.log':'TEST_PASS PL attitude bit-exact replay samples=',
           'rtl_mailbox.log':'TEST_PASS PL attitude mailbox CDC settling',
           'netlist_mailbox.log':'TEST_PASS synthesized PL attitude calibration, 60deg twist',
           'mailbox_firmware.log':'TEST_PASS PS attitude mailbox:',
           'lcd_test.log':'TEST_PASS LCD:', 'hand_test.log':'TEST_PASS hand firmware:',
           'learning_workflow_test.log':'TEST_PASS PL backend failures invalidate model and NMF without software fallback',
           'full_build.log':'PIPELINE RESULT: ALL GATES PASS',
           'float_comparison.log':'TEST_PASS Q24/float reference samples=13528'}
    for name,marker in tests.items():
        text=evidence(REPORT/name)
        assert marker in text,f'Missing V17 evidence {name}'
        assert not re.search(r'(?im)^(Fatal:|ERROR:|Assertion failed:)',text),f'Failure in V17 log {name}'
    f=json.loads((REPORT/'float_comparison.json').read_text())
    assert not f['differences'] and f['max_matrix_component_error']<=.006 and f['max_twist_error_degrees']<=2
    pre=(REPORT/'arm_preprocessed.c').read_text(encoding='utf-8',errors='replace')
    assert 'lcd_imu_poll();' in pre and '0x41270000u' in pre
    assert not any(s in pre for s in ('imu_inv_sqrt(', 'imu_gravity(', 'imu_host_run(', 'imu_mul(')), 'PS fusion still compiled'
    assert 'All user specified timing constraints are met' in (REPORT/'timing_routed.rpt').read_text(), 'Routed timing not met'
    methodology=evidence(REPORT/'methodology_routed.rpt')
    assert not re.search(r'^\|[^\n|]+\|\s*Critical Warning\s*\|',methodology,re.M), 'Unresolved critical methodology rule'
    assert 'TEST_PASS native IMU CDC constraints meta=8 data=96 source=96' in evidence(REPORT/'native_cdc_console.log')
    comparison=json.loads((REPORT/'comparison.json').read_text(encoding='utf-8'))
    assert comparison['v17']['wns_ns']>=0 and comparison['v17']['whs_ns']>=0
    assert comparison['bus_skew_min_slack_ns']>=0
    assert 'TEST_PASS IMU full-system routed audit exported' in evidence(REPORT/'routed_audit_console.log')
    print(f'TEST_PASS V17 attitude release gates inherited={len(inherited)} source_bindings={len(proof)} PS_fusion_absent')
    return inherited
if __name__=='__main__':verify(ROOT/'build/export/design_1.xsa')

