"""Bind V22 grip regression to source and unchanged V21 PL/model artifacts."""
from pathlib import Path
import hashlib
import json
import argparse

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'report/grip_control_20261031'
PREVIOUS = ROOT / 'report/lcd_responsiveness_20261030'
CHANGED = {'sw/ps_uart_print/main.c', 'sw/ps_uart_print/hand_control.h',
           'sw/ps_uart_print/lcd_hand.h', 'sw/ps_uart_print/lcd_rehab.h',
           'sw/ps_uart_print/lcd_font_zh.h', 'tools/verify_control_boot.py',
           'build/boot/build_pl_control_boot.ps1', 'README.md'}
ADDED = {'sim/hand_grip_test.c', 'build/scripts/run_hand_grip_test.ps1',
         'tools/verify_grip_release.py'}


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def source_paths():
    previous = json.loads((PREVIOUS / 'regression_sources.json').read_text())
    return sorted(set(previous) | CHANGED | ADDED)


def read_log(path):
    b = path.read_bytes()
    return b.decode('utf-16' if b.startswith((b'\xff\xfe', b'\xfe\xff')) else 'utf-8-sig')


def verify(xsa):
    previous = json.loads((PREVIOUS / 'artifacts.json').read_text())
    for e in previous['artifacts']:
        name = e['path'].replace('\\', '/')
        if Path(name).suffix.lower() in ('.bit', '.xsa', '.mem', '.xdc') or name.startswith('src/rtl/') or name.endswith('/fsbl.elf'):
            assert digest(ROOT / name) == e['sha256'], 'Hardware/model changed: ' + name
    assert digest(xsa) == digest(ROOT / 'build/export/design_1.xsa')
    inherited = json.loads((PREVIOUS / 'regression_sources.json').read_text())
    for name, h in inherited.items():
        if name not in CHANGED:
            assert digest(ROOT / name) == h, 'Unexpected inherited source change: ' + name
    proof = json.loads((OUT / 'regression_sources.json').read_text())
    assert set(proof) == set(source_paths()), 'Incomplete source binding'
    for name, h in proof.items():
        assert digest(ROOT / name) == h, 'Stale grip regression: ' + name
    for filename, markers in {
        'grip_test.log': ('TEST_PASS synergy grip:', 'TEST_PASS synergy grip UI:'),
        'hand_test.log': ('TEST_PASS hand firmware:', 'TEST_PASS BOOT HOME:'),
        'lcd_test.log': ('TEST_PASS LCD:', 'TEST_PASS NAV LIFECYCLE:'),
        'arm_build.log': ('BUILD OK: ps_uart_print_pl_control.elf',),
        'font_test.log': ('OK',),
    }.items():
        log = read_log(OUT / filename)
        assert all(m in log for m in markers), 'Missing regression: ' + filename
        assert 'Assertion failed:' not in log and 'Traceback' not in log, 'Failed regression: ' + filename
    print('TEST_PASS V22 synergy grip: inherited PL/models/PWM protections, source-bound ARM/hand/LCD/grip regression')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--record-sources', action='store_true')
    args = parser.parse_args()
    if args.record_sources:
        OUT.mkdir(parents=True, exist_ok=True)
        (OUT / 'regression_sources.json').write_text(json.dumps(
            {name: digest(ROOT / name) for name in source_paths()}, indent=2))
    else:
        verify(ROOT / 'build/export/design_1.xsa')
