"""Regression: only the exact control/spectrum constants may bypass the gate."""
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'tools'))
from scan_literal_b import benign_literal


class LiteralGateTest(unittest.TestCase):
    def test_exact_scope_and_constant(self):
        self.assertTrue(benign_literal('design_emg_control_policy','numerator_reg',100))
        self.assertTrue(benign_literal('design_emg_fatigue','p_0_out__1',30))
        for module,name,value in (
            ('design_emg_bandpass','numerator_reg',100),
            ('design_emg_control_policy','numerator_reg',101),
            ('design_emg_control_policy','other',100),
            ('design_emg_bandpass','p_0_out__1',30)):
            self.assertFalse(benign_literal(module,name,value))

    def test_parser_and_fail_closed(self):
        for module,value,expected in (('design_emg_control_policy',100,0),
                                     ('design_emg_control_policy',101,1),
                                     ('design_emg_bandpass',100,1),
                                     ('design_emg_bandpass',14646,1)):
            with tempfile.TemporaryDirectory() as folder:
                net=Path(folder)/'sim.v'
                net.write_text(f'module {module};\nDSP48E1 #(.BREG(0))\n numerator_reg (\n.B(18\'h{value:x}),\n.P(foo));\nendmodule\n')
                run=subprocess.run([sys.executable,str(ROOT/'tools/scan_literal_b.py'),str(net)],capture_output=True,text=True)
                self.assertEqual(run.returncode,expected,run.stdout+run.stderr)


if __name__=='__main__':unittest.main()

