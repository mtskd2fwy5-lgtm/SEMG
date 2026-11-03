"""Pin the continuous-link firmware release to the accepted Q32 hardware."""
from pathlib import Path
import hashlib
import json
import re

ROOT = Path(__file__).resolve().parents[1]
PREVIOUS = ROOT / 'report/hdc_resolution_20261102'
CHANGED = {
    'README.md', 'sw/ps_uart_print/main.c', 'sw/ps_uart_print/hand_control.h',
    'sw/ps_uart_print/lcd_hand.h', 'sw/ps_uart_print/lcd_hdc.h',
    'sw/ps_uart_print/lcd_font_zh.h', 'sim/hand_firmware_test.c',
    'sim/lcd_firmware_test.c', 'build/boot/build_pl_control_boot.ps1',
    'tools/verify_control_boot.py',
}


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def verify(report):
    previous = json.loads((PREVIOUS / 'artifacts.json').read_text())
    assert previous['tag'] == '20261102_HAND_CONTROL_HDC_DYNAMIC_RESOLUTION_V29'
    hardware = 0
    for entry in previous['artifacts']:
        name = entry['path'].replace('\\', '/')
        path = Path(name)
        if (name.startswith('src/rtl/') or path.suffix in ('.bit', '.xsa', '.xdc', '.mem')
                or name.endswith('/fsbl.elf') or path.name == 'ps7_init.c'):
            assert digest(ROOT / path) == entry['sha256'], 'Q32 hardware changed: ' + name
            hardware += 1
    assert hardware >= 20, 'Incomplete hardware inheritance'
    inherited = json.loads((PREVIOUS / 'regression_sources.json').read_text())
    for name, expected in inherited.items():
        if name not in CHANGED:
            assert digest(ROOT / name) == expected, 'Unexpected inherited change: ' + name
    proof = json.loads((report / 'regression_sources.json').read_text())
    assert set(inherited) | CHANGED | {'tools/verify_hdc_continuous_release.py'} <= proof.keys()
    for name, expected in proof.items():
        assert digest(ROOT / name) == expected, 'Stale continuous-link test: ' + name
    for filename, markers in {
        'hand_test.log': ['TEST_PASS HDC continuous link: 3.5s production ACK/leases',
                          'TEST_PASS hand firmware:'],
        'lcd_test.log': ['TEST_PASS HDC continuous UI:', 'TEST_PASS LCD:',
                         'TEST_PASS NAV LIFECYCLE: 144 routes'],
        'imu_test.log': ['TEST_PASS LCD:'],
        'model_test.log': ['TEST_PASS HDC model Q16/Q32 contracts roundtrip'],
        'learning_workflow_test.log': ['TEST_PASS PL backend failures invalidate model and NMF without software fallback'],
        'sd_test.log': ['TEST_PASS sd_record:'],
        'uart_test.log': ['TEST_PASS'],
    }.items():
        content = (report / filename).read_bytes()
        text = content.decode('utf-16' if content.startswith((b'\xff\xfe', b'\xfe\xff'))
                              else 'utf-8-sig', errors='replace')
        assert all(marker in text for marker in markers), 'Missing regression: ' + filename
        assert not re.search(r'(?im)^(Fatal:|ERROR:|Assertion failed:|FAIL line)', text), filename
    print(f'TEST_PASS HDC continuous release: {hardware} Q32 hardware inputs/artifacts unchanged; '
          'current firmware, model, LCD/IMU and stream regressions verified')


if __name__ == '__main__':
    verify(ROOT / 'report/hdc_continuous_20261102')
