"""Verify Q32 HDC release evidence against the preserved workspace baseline."""
from pathlib import Path
import hashlib
import json
import re
import zipfile

ROOT = Path(__file__).resolve().parents[1]
REPORT = ROOT / 'report/hdc_resolution_20261102'
CHANGED = {
    'README.md', 'build/boot/build_pl_control_boot.ps1', 'tools/verify_control_boot.py',
    'tools/gen_hdc_memory.py', 'tools/gen_learning_vectors.py', 'data/models/hdc_memory.mem',
    'src/rtl/emg_learning_accel.v', 'sw/ps_uart_print/hand_control.h',
    'sw/ps_uart_print/hdc_learning.h', 'sw/ps_uart_print/hdc_memory.h',
    'sw/ps_uart_print/hdc_model_store.h', 'sw/ps_uart_print/lcd_font_zh.h',
    'sw/ps_uart_print/lcd_hand.h', 'sw/ps_uart_print/lcd_hdc.h',
    'sw/ps_uart_print/main.c', 'sw/ps_uart_print/pl_learning.h',
    'sw/ps_uart_print/pl_learning_api.h', 'sim/emg_learning_accel_tb.sv',
    'sim/hand_firmware_test.c', 'sim/hdc_learning_test.c',
    'sim/hdc_model_store_test.c', 'sim/imu_reference_test.c',
    'sim/lcd_firmware_test.c', 'sim/pl_learning_workflow_test.c',
    'sim/test_hdc_learning.py'}

def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def read_log(path):
    data = path.read_bytes()
    return data.decode('utf-16' if data.startswith((b'\xff\xfe', b'\xfe\xff')) else 'utf-8-sig', errors='replace')

def verify(xsa):
    baseline = json.loads((REPORT/'baseline_sources.json').read_text())
    inherited = 0
    for name, expected in baseline.items():
        if name not in CHANGED:
            assert digest(ROOT/name) == expected, 'Unexpected inherited change: '+name
            inherited += 1
    assert inherited > 250, 'Incomplete baseline inheritance'
    proof = json.loads((REPORT/'regression_sources.json').read_text())
    required = CHANGED | {'tools/verify_hdc_resolution_release.py',
        'build/scripts/rebuild_hdc_resolution.tcl',
        'build/scripts/close_hdc_resolution_timing.tcl','sim/hdc_model_sd_mock.h'}
    assert required <= proof.keys(), 'Incomplete current-source proof'
    for name, expected in proof.items():
        assert digest(ROOT/name) == expected, 'Stale HDC regression: '+name
    tests = {
        'learning_test.log': ['TEST_PASS learning accelerator complete', 'LEARNING_CYCLES job6'],
        'learning_netlist_test.log': ['TEST_PASS learning accelerator complete',
            'TEST_PASS legacy Q16 model encoding and single-class zero precise margin'],
        'golden_test.log': ['TEST_PASS C/NumPy exact packed-query'],
        'model_test.log': ['TEST_PASS HDC model Q16/Q32 contracts roundtrip without reinterpretation'],
        'hand_test.log': ['TEST_PASS HDC precise stability:', 'TEST_PASS hand firmware:'],
        'learning_workflow_test.log': ['TEST_PASS PL backend failures invalidate model and NMF without software fallback'],
        'lcd_test.log': ['precise 0.50% gap and 6-of-8 confirmation',
            'TEST_PASS HDC MODEL LIBRARY:', 'TEST_PASS NAV LIFECYCLE: 144 routes', 'TEST_PASS LCD:'],
        'imu_test.log': ['precise 0.50% gap and 6-of-8 confirmation', 'TEST_PASS LCD:'],
        'sd_test.log': ['TEST_PASS sd_record:'], 'uart_test.log': ['TEST_PASS'],
        'hardware_console.log': ['TEST_PASS HDC Q32 full-system reimplementation complete'],
        'timing_close_console.log': ['TEST_PASS HDC Q32 full-system timing closure complete']}
    for name, markers in tests.items():
        content = read_log(REPORT/name)
        assert all(marker in content for marker in markers), 'Missing HDC test: '+name
        assert not re.search(r'(?im)^(Fatal:|ERROR:|Assertion failed:|FAIL line)', content), 'Failed HDC test: '+name
    assert 'All user specified timing constraints are met' in read_log(REPORT/'timing_routed.rpt')
    netlist = json.loads((REPORT/'netlist_inputs.json').read_text())
    for name, expected in netlist.items():
        assert digest(ROOT/name) == expected, 'Stale synthesized learning test: '+name
    assert len((ROOT/'data/models/hdc_memory.mem').read_text().splitlines()) == 4096
    old_rom=(REPORT/'baseline/data/models/hdc_memory.mem').read_text().splitlines()
    new_rom=(ROOT/'data/models/hdc_memory.mem').read_text().splitlines()
    assert old_rom[:1536] == new_rom[:1536], 'Legacy Q16 ROM content changed'
    assert '0x13u' in (ROOT/'sw/ps_uart_print/pl_learning.h').read_text()
    with zipfile.ZipFile(REPORT/'baseline/design_1.xsa') as old, zipfile.ZipFile(xsa) as new:
        for name in old.namelist():
            if name.endswith(('ps7_init.c','ps7_init.h')):
                assert old.read(name) == new.read(name), 'PS initialization changed: '+name
    print(f'TEST_PASS HDC Q32 release: {inherited} inherited sources, exact Q16/Q32, precise page stability, real synthesized learning and routed system')

if __name__ == '__main__':
    verify(ROOT/'build/export/design_1.xsa')
