"""V18: bind baseline-free quality tests and exact reuse of accepted V17 PL."""
from pathlib import Path
import hashlib,json,re
ROOT=Path(__file__).resolve().parents[1]
REPORT=ROOT/'report/channel_quality_20261029'
TAG='20261029_HAND_CONTROL_HDC_DYNAMIC_QUALITY_V18'
CHANGED={
 'sw/ps_uart_print/channel_quality.h','sw/ps_uart_print/lcd_channel_quality.h',
 'sw/ps_uart_print/lcd_font_zh.h','sw/ps_uart_print/main.c',
 'sim/channel_quality_test.c','sim/lcd_firmware_test.c','sim/imu_reference_test.c',
 'sim/test_channel_quality_reference.py','tools/gen_imu_reference.py',
 'tools/verify_control_boot.py','build/boot/build_pl_control_boot.ps1'}
def digest(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def verify(xsa):
    old=json.loads((ROOT/'report/imu_pl_20261028/artifacts.json').read_text())
    old_sources=json.loads((ROOT/'report/imu_pl_20261028/regression_sources.json').read_text())
    baseline=json.loads((REPORT/'baseline/manifest.json').read_text())
    checked=[]
    for name,h in old_sources.items():
        if name in CHANGED:
            assert name in baseline and digest(REPORT/'baseline'/name)==h,'Wrong V17 source baseline: '+name
        else:
            assert digest(ROOT/name)==h,'Unexpected inherited source change: '+name
            checked.append(name)
    hardware=0
    for e in old['artifacts']:
        name=e['path'].replace(chr(92),'/');p=Path(name)
        is_hw=(name.startswith('src/rtl/') or p.suffix in ('.bit','.xsa','.xdc','.mem') or p.name in ('fsbl.elf','ps7_init.c'))
        if is_hw:
            assert digest(ROOT/name)==e['sha256'],'V17 hardware changed: '+name
            hardware+=1
        elif name.startswith('sw/ps_uart_print/') and p.suffix.lower() in ('.c','.h','.ld','.s') and name not in CHANGED:
            assert digest(ROOT/name)==e['sha256'],'Unrelated PS change: '+name
    required_hw={'build/vivado/hand_motion_reconstruction.runs/impl_1/design_1.bit',
      'build/export/design_1.xsa','build/vitis_ws/platform/export/platform/sw/boot/fsbl.elf',
      'build/vitis_ws/platform/zynq_fsbl/ps7_init.c','data/models/hdc_memory.mem',
      'board/constraints/hz_zynq_imu_clock_groups.xdc'}
    assert required_hw <= {e['path'].replace(chr(92),'/') for e in old['artifacts']}
    assert hardware>=9 and len(checked)>=90 and sum(n.startswith(('src/rtl/','board/constraints/')) for n in checked)>=40,'Incomplete inheritance verification' 
    assert xsa==ROOT/'build/export/design_1.xsa'
    proof=json.loads((REPORT/'regression_sources.json').read_text())
    assert CHANGED|{'sw/ps_uart_print/channel_quality_tables.h','tools/verify_quality_release.py'}<=proof.keys()
    for name,h in proof.items():assert digest(ROOT/name)==h,'Stale V18 regression: '+name
    tests={'quality_test.log':'TEST_PASS baseline-free quality C/NumPy/SciPy numerical validation',
           'lcd_test.log':'TEST_PASS LCD:', 'hand_test.log':'TEST_PASS hand firmware:',
           'learning_workflow_test.log':'TEST_PASS PL backend failures invalidate model and NMF without software fallback'}
    for name,marker in tests.items():
        data=(REPORT/name).read_bytes()
        text=data.decode('utf-16' if data.startswith((b'\xff\xfe',b'\xfe\xff')) else 'utf-8',errors='replace')
        assert marker in text,'Missing V18 test: '+name
        assert not re.search(r'(?im)^(Fatal:|ERROR:|Assertion failed:)',text),'Failure in V18 test: '+name
    code=(ROOT/'sw/ps_uart_print/channel_quality.h').read_text()
    ui=(ROOT/'sw/ps_uart_print/lcd_channel_quality.h').read_text(encoding='utf-8')
    assert not any(x in code+ui for x in ('cq_reference','cq_start_reference','q->base','activity_score'))
    numeric=json.loads((REPORT/'numeric_validation.json').read_text())
    assert sum(e['channel_windows'] for e in numeric.values())>=400
    assert max(e['max_mains_error_percentage_points'] for e in numeric.values())<1.5
    print(f'TEST_PASS V18 quality release inherited_sources={len(checked)} hardware_artifacts={hardware} baseline_free')
    return checked
if __name__=='__main__':verify(ROOT/'build/export/design_1.xsa')

