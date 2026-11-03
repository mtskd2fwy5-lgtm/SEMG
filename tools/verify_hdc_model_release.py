"""V19 persistent HDC model library, pinned to accepted V18 PS/PL lineage."""
from pathlib import Path
import hashlib,json,re
ROOT=Path(__file__).resolve().parents[1]
REPORT=ROOT/'report/hdc_model_sd_20261029'
TAG='20261029_HAND_CONTROL_HDC_DYNAMIC_MODEL_SD_V19'
CHANGED={
 'sw/ps_uart_print/main.c','sw/ps_uart_print/lcd_hdc.h','sw/ps_uart_print/sd_record.h',
 'sw/ps_uart_print/sd_record.c','sw/ps_uart_print/lcd_virtual.h','sw/ps_uart_print/lcd_font_zh.h',
 'sim/lcd_firmware_test.c','sim/imu_reference_test.c','sim/control_policy_reference.c',
 'sim/uart_record_firmware_test.c','sim/sd_record_test.c','sim/sd_record_platform_mock.h',
 'sim/pl_learning_workflow_test.c','tools/gen_imu_reference.py','tools/gen_hz_glyphs.py',
 'tools/verify_control_boot.py','build/boot/build_pl_control_boot.ps1','README.md'}
NEW={'sw/ps_uart_print/hdc_model_store.h','sw/ps_uart_print/lcd_hdc_models.h',
 'sim/hdc_model_store_test.c','sim/hdc_model_sd_mock.h','build/scripts/run_hdc_model_test.ps1',
 'tools/verify_hdc_model_release.py'}
def digest(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def textfile(p):
    b=p.read_bytes()
    return b.decode('utf-16' if b.startswith((b'\xff\xfe',b'\xfe\xff')) else 'utf-8',errors='replace')
def verify(xsa):
    old=json.loads((ROOT/'report/channel_quality_20261029/artifacts.json').read_text())
    old_proof=json.loads((ROOT/'report/channel_quality_20261029/regression_sources.json').read_text())
    baseline=json.loads((REPORT/'baseline/manifest.json').read_text())
    for name,h in baseline.items():assert digest(REPORT/'baseline'/name)==h,'Changed V18 baseline: '+name
    def inherited(name,h):
        if name in CHANGED:
            assert baseline.get(name)==h,'Wrong V18 change baseline: '+name
        else:assert digest(ROOT/name)==h,'Unexpected inherited change: '+name
    checked=[]
    for name,h in old_proof.items():inherited(name,h);checked.append(name)
    hardware=0
    for e in old['artifacts']:
        name=e['path'].replace(chr(92),'/');p=Path(name)
        is_hw=name.startswith('src/rtl/') or p.suffix in ('.bit','.xsa','.xdc','.mem') or p.name in ('fsbl.elf','ps7_init.c')
        if is_hw:
            assert digest(ROOT/name)==e['sha256'],'V18 hardware changed: '+name;hardware+=1
        elif name.startswith('sw/ps_uart_print/') and p.suffix.lower() in ('.c','.h','.ld','.s'):
            inherited(name,e['sha256'])
    # V18 reuses V17 hardware; its compact artifact list omits some IMU RTL.
    # Verify those inherited files as well, rather than treating omission as evidence.
    v17=json.loads((ROOT/'report/imu_pl_20261028/artifacts.json').read_text())
    names={e['path'].replace(chr(92),'/') for e in old['artifacts']}
    for e in v17['artifacts']:
        name=e['path'].replace(chr(92),'/');p=Path(name)
        if name.startswith('src/rtl/') or p.suffix in ('.bit','.xsa','.xdc','.mem') or p.name in ('fsbl.elf','ps7_init.c'):
            assert digest(ROOT/name)==e['sha256'],'Inherited V17 hardware changed: '+name
            if name not in names:hardware+=1;names.add(name)
    hw_proof=json.loads((ROOT/'report/imu_pl_20261028/regression_sources.json').read_text())
    for name,h in hw_proof.items():
        if name.startswith(('src/rtl/','board/constraints/')):
            assert digest(ROOT/name)==h,'Inherited hardware source changed: '+name
    assert hardware>=24 and len(checked)>=45,'Incomplete V18 inheritance checks' 
    assert xsa==ROOT/'build/export/design_1.xsa'
    proof=json.loads((REPORT/'regression_sources.json').read_text())
    assert CHANGED|NEW<=proof.keys(),'Incomplete V19 proof'
    for name,h in proof.items():assert digest(ROOT/name)==h,'Stale V19 regression: '+name
    tests={
      'model_test.log':['TEST_PASS HDC model codec:'],
      'sd_test.log':['TEST_PASS model SD IO:','TEST_PASS sd_record:'],
      'lcd_test.log':['TEST_PASS HDC MODEL LIBRARY:','TEST_PASS VIRTUAL MAPPING:',
                      'TEST_PASS NAV LIFECYCLE: 144 routes','TEST_PASS LCD:'],
      'hand_test.log':['TEST_PASS hand firmware:'],
      'learning_workflow_test.log':['TEST_PASS PL model restore:',
            'TEST_PASS PL backend failures invalidate model and NMF without software fallback'],
      'uart_test.log':['TEST_PASS']}
    for name,markers in tests.items():
        data=textfile(REPORT/name)
        for marker in markers:assert marker in data,'Missing V19 test: '+name+' '+marker
        assert not re.search(r'(?im)^(Fatal:|ERROR:|Assertion failed:|FAIL line)',data),'Failed V19 test: '+name
    assert digest(ROOT/'sw/ps_uart_print/hdc_learning.h')==old_proof['sw/ps_uart_print/hdc_learning.h']
    assert digest(ROOT/'sw/ps_uart_print/pl_learning.h')==old_proof['sw/ps_uart_print/pl_learning.h']
    assert '0x07105003u' in (ROOT/'sw/ps_uart_print/hdc_model_store.h').read_text()
    print(f'TEST_PASS V19 model release inherited_sources={len(checked)} hardware_artifacts={hardware} transactional_SD_models')
if __name__=='__main__':verify(ROOT/'build/export/design_1.xsa')
