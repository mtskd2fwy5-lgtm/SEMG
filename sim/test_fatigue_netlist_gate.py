"""End-to-end gate fixtures: legitimate MDF math must not mask corruption."""
from pathlib import Path
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]
SCRIPT = ROOT / "tools/scan_literal_b.py"
cases = []
for leaf, value in (("candidate2", 70), ("candidate3", 80),
                    ("candidate4", 90), ("current_scaled", 400)):
    cases += [("test_emg_fatigue_state", leaf, value, True),
              ("test_emg_bandpass", leaf, value, False),
              ("test_emg_fatigue_state", leaf, value + 1, False),
              ("test_emg_fatigue_state", "unexpected_" + leaf, value, False)]
cases += [("test_emg_fatigue", "p_0_out", 30, True),
          ("test_emg_fatigue", "p_0_out__1", 30, True),
          ("test_emg_bandpass", "p_0_out", 30, False),
          ("test_emg_fatigue_state", "candidate2", 14646, False),
          ("test_emg_fatigue_state", "candidate2", -116680, False),
          ("test_emg_fatigue_state", "current_scaled", 14642, False)]
with tempfile.TemporaryDirectory(prefix="fatigue_gate_") as folder:
    path = Path(folder) / "fixture.v"
    for module, leaf, value, accept in cases:
        path.write_text(f"module {module};\nDSP48E1 #(.AREG(0))\n"
                        f"{leaf} (.B(18'h{value & ((1 << 18) - 1):05x}),.A(dynamic));\nendmodule\n")
        result = subprocess.run([sys.executable, str(SCRIPT), str(path)],
                                capture_output=True, text=True)
        assert "total DSP48E1 instances : 1" in result.stdout, result.stdout
        assert (result.returncode == 0) == accept, (module, leaf, value, result.stdout)
print(f"TEST_PASS fatigue netlist gate: {len(cases)} real parser fixtures; filter paths, wrong leaves/values and known corruption rejected")
