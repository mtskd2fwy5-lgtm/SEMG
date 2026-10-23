"""Accepted PS poses must survive transport without a second confidence gate."""
import os
import sys
import unittest
from pathlib import Path

os.environ.setdefault("PYGAME_HIDE_SUPPORT_PROMPT", "1")
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools"))
from virtual_hand import HandState, handle_pose_line, POSE_MIN_CONF, POSE_CONFIRM_WINDOWS
from pose_contract import POSES_V2, POSE_FIELDS_V2


class PoseTransportTest(unittest.TestCase):
    def parse(self, extra):
        values = " ".join(f"{k}={v}" for k, v in zip(POSE_FIELDS_V2, POSES_V2["ext"]))
        line = f"P v=1 s=40 schema=2 gid=4 q=20 mask=0x3fffff phase=0 {extra} {values}"
        state = HandState()
        handle_pose_line(line, state, 1.0, 55, {"cls": 0, "cn": False})
        return state

    def test_stable_pose_is_authoritative(self):
        st = self.parse("stable=1")
        self.assertEqual(st.cls, 4)
        self.assertEqual(st.to, POSES_V2["ext"])
        self.assertEqual(st.conf, 20)

    def test_legacy_pose_keeps_confidence_fallback(self):
        st = self.parse("")
        self.assertEqual(st.cls, 0)
        self.assertEqual(st.to, POSES_V2["rest"])

    def test_old_firmware_default_threshold_is_preserved(self):
        self.assertEqual(POSE_MIN_CONF, 30)
        self.assertEqual(POSE_CONFIRM_WINDOWS, 2)


if __name__ == "__main__":
    unittest.main()
