"""Bind relative-zero/effort-band release to tests and previous source inputs."""
from pathlib import Path
import argparse
import hashlib
import json
import re

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'report/imu_zero_20261031'
PREVIOUS = ROOT / 'report/grip_control_20261031'
CHANGED = {'sw/ps_uart_print/main.c', 'sw/ps_uart_print/rehab_training.h',
           'sw/ps_uart_print/lcd_rehab.h', 'sim/lcd_firmware_test.c',
           'sim/imu_reference_test.c', 'tools/gen_imu_reference.py',
           'tools/verify_control_boot.py', 'build/boot/build_pl_control_boot.ps1', 'README.md'}
EXTRA = {'tools/gen_imu_microcode.py', 'src/rtl/mpu_attitude.v',
         'src/rtl/mpu_attitude_core.v', 'src/rtl/mpu_attitude_rom.vh',
         'src/rtl/mpu_attitude_regs.vh', 'sim/imu_program.json', 'sim/imu_program.h',
         'sim/imu_float_reference.h', 'sim/mpu_attitude_mailbox_tb.sv',
         'sim/mpu_attitude_vectors_tb.sv', 'sim/synergy_feedback_test.c',
         'tools/verify_imu_zero_release.py', 'build/scripts/audit_imu_zero.tcl',
         'tools/verify_imu_vectors.py', 'tools/imu_fixed_model.py', 'sim/imu_host_model.h'}


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def read_log(path):
    b = path.read_bytes()
    return b.decode('utf-16' if b.startswith((b'\xff\xfe', b'\xfe\xff')) else 'utf-8-sig', errors='replace')


def sources():
    hardware = {p.relative_to(ROOT).as_posix() for folder in ('src/rtl', 'board/constraints', 'data/models')
                for p in (ROOT / folder).rglob('*') if p.suffix in ('.v', '.sv', '.vh', '.xdc', '.mem')}
    return sorted(set(json.loads((PREVIOUS / 'regression_sources.json').read_text())) | EXTRA | CHANGED | hardware)


def verify(xsa):
    for name, h in json.loads((PREVIOUS / 'regression_sources.json').read_text()).items():
        if name not in CHANGED:
            assert digest(ROOT / name) == h, 'Unrelated V22 input changed: ' + name
    for e in json.loads((PREVIOUS / 'artifacts.json').read_text())['artifacts']:
        name = e['path'].replace('\\', '/')
        unchanged_rtl = name.startswith('src/rtl/') and name not in {
            'src/rtl/mpu_attitude_rom.vh', 'src/rtl/mpu_attitude_regs.vh'}
        if unchanged_rtl or Path(name).suffix.lower() in ('.mem', '.xdc') or name.endswith('/fsbl.elf') or name.endswith('/ps7_init.c'):
            assert digest(ROOT / name) == e['sha256'], 'Platform/model changed: ' + name
    proof = json.loads((OUT / 'regression_sources.json').read_text())
    assert set(proof) == set(sources()), 'Incomplete source binding'
    for name, h in proof.items():
        assert digest(ROOT / name) == h, 'Stale current-pose test: ' + name
    for name, markers in {
        'rtl_test.log': ('TEST_PASS IMU migration regression complete', 'TEST_PASS PL attitude bit-exact replay samples='),
        'mailbox_firmware.log': ('TEST_PASS PS attitude mailbox:',),
        'hand_test.log': ('TEST_PASS hand firmware:',),
        'learning_workflow_test.log': ('TEST_PASS PL backend failures invalidate model and NMF without software fallback',),
        'netlist_test.log': ('TEST_PASS arbitrary-pose recalibration:', 'TEST_PASS synthesized PL attitude calibration,'),
        'lcd_test.log': ('TEST_PASS LCD:', 'TEST_PASS NAV LIFECYCLE:'),
        'grip_test.log': ('TEST_PASS synergy grip:', 'TEST_PASS synergy grip UI:'),
        'feedback_test.log': ('TEST_PASS grip feedback:',),
        'arm_build.log': ('BUILD OK: ps_uart_print_pl_control.elf',),
        'hardware_build.log': ('TEST_PASS IMU full-system reimplementation complete',),
        'full_gates.log': ('PIPELINE RESULT: ALL GATES PASS',),
    }.items():
        text = read_log(OUT / name)
        assert all(m in text for m in markers), 'Missing evidence: ' + name
        assert not re.search(r'(?im)^(Fatal:|ERROR:|Assertion failed:)', text), 'Failed test: ' + name
    comparison = json.loads((OUT / 'float_comparison.json').read_text())
    assert comparison['samples'] == 13528 and not comparison['differences']
    assert comparison['max_matrix_component_error'] <= .006 and comparison['max_twist_error_degrees'] <= 2
    timing = read_log(OUT / 'timing_routed.rpt')
    assert 'All user specified timing constraints are met' in timing
    assert not re.search(r'^\|[^\n|]+\|\s*Critical Warning\s*\|', read_log(OUT / 'methodology_routed.rpt'), re.M)
    assert xsa.is_file()
    print('TEST_PASS V23 current-pose zero and 70-130 percent effort source-bound release')


if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('--record-sources', action='store_true')
    args = ap.parse_args()
    if args.record_sources:
        OUT.mkdir(parents=True, exist_ok=True)
        (OUT / 'regression_sources.json').write_text(json.dumps({n: digest(ROOT / n) for n in sources()}, indent=2))
    else:
        verify(ROOT / 'build/export/design_1.xsa')

