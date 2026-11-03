"""V21 PS scheduling change, byte-identical accepted V20 PL and control models."""
from pathlib import Path
import hashlib
import json

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT/'report/lcd_responsiveness_20261030'
PREVIOUS = ROOT/'report/hand_pwm_inverted_20261029'
CHANGED = {'sw/ps_uart_print/main.c', 'sw/ps_uart_print/channel_quality.h',
           'sim/channel_quality_test.c', 'tools/verify_control_boot.py',
           'build/boot/build_pl_control_boot.ps1', 'README.md'}


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def read_log(path):
    b=path.read_bytes()
    return b.decode('utf-16' if b.startswith((b'\xff\xfe', b'\xfe\xff')) else 'utf-8')


def verify(xsa):
    baseline=json.loads((OUT/'baseline/manifest.json').read_text())
    assert set(baseline)==CHANGED
    for name,h in baseline.items():
        assert digest(OUT/'baseline'/name)==h, 'Altered V20 baseline: '+name
    inherited=json.loads((PREVIOUS/'regression_sources.json').read_text())
    for name,h in inherited.items():
        assert (baseline.get(name) if name in CHANGED else digest(ROOT/name))==h, 'Unexpected inheritance change: '+name
    previous=json.loads((PREVIOUS/'artifacts.json').read_text())
    for e in previous['artifacts']:
        name=e['path'].replace('\\','/')
        if Path(name).suffix.lower() in ('.bit','.xsa','.mem') or name.endswith('/fsbl.elf'):
            assert digest(ROOT/name)==e['sha256'], 'Hardware or model changed: '+name
    assert digest(xsa)==digest(ROOT/'build/export/design_1.xsa')
    # Chunking changes yield points only; numerical worker and scoring stay exact.
    old=(OUT/'baseline/sw/ps_uart_print/channel_quality.h').read_bytes()
    new=(ROOT/'sw/ps_uart_print/channel_quality.h').read_bytes()
    assert new.replace(b'CQ_WORK_BUDGET 32u',b'CQ_WORK_BUDGET 128u').replace(
        b'<=32 sample/FFT',b'<=128 sample/FFT')==old
    proof=json.loads((OUT/'regression_sources.json').read_text())
    assert set(inherited)|CHANGED|{'tools/verify_ui_budget_release.py','sim/lcd_work_budget_test.c'}<=set(proof)
    for name,h in proof.items():
        assert digest(ROOT/name)==h,'Stale V21 regression input: '+name
    for name,marker in {'cpu_test.log':'TEST_PASS UI budget:',
                        'lcd_test.log':'TEST_PASS LCD:',
                        'quality_test.log':'TEST_PASS quality:'}.items():
        log=read_log(OUT/name)
        assert marker in log and 'Assertion failed:' not in log and 'Traceback' not in log, 'Test failed: '+name
    assert 'TEST_PASS hand firmware:' in read_log(OUT/'cpu_test.log')
    numeric=json.loads((OUT/'numeric_validation.json').read_text())
    assert numeric, 'Missing independent numerical reference'
    print('TEST_PASS V21 UI scheduling: inherited V20 PL/models/control, unchanged score math, CPU/LCD/quality regression')


if __name__=='__main__':
    verify(ROOT/'build/export/design_1.xsa')

