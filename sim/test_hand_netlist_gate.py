"""The legitimate PWM scale factor must not weaken filter coefficient gates."""
import importlib.util
from pathlib import Path

path=Path(__file__).resolve().parents[1]/'tools/scan_literal_b.py'
spec=importlib.util.spec_from_file_location('gate',path)
gate=importlib.util.module_from_spec(spec)
spec.loader.exec_module(gate)
for leaf in ['pwm2','pwm2__0','pwm2__1','pwm2__2','pwm2__3','pwm2__4']:
    assert gate.benign_literal('design_1_hand_servo_pwm',leaf,25)
    assert not gate.benign_literal('design_1_emg_bandpass',leaf,25)
    assert not gate.benign_literal('design_1_hand_servo_pwm',leaf,26)
assert not gate.benign_literal('design_1_hand_servo_pwm','pwm2__5',25)
assert not gate.benign_literal('design_1_hand_servo_pwm','coefficient',25)
print('TEST_PASS hand netlist gate: exact six servo constants; wrong module/value/leaf rejected')
