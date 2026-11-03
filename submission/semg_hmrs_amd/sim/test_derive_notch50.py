"""Regression tests for timestamp-aligned raw/notch50 pairing."""
import csv
import json
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools"))
from derive_notch50 import derive_capture
from emg_reference import Notch50, NotchComb, ProcessedSignal


class DeriveNotch50Tests(unittest.TestCase):
    def test_final_signed_waveform_derivation(self):
        with tempfile.TemporaryDirectory() as root:
            source, source_meta = self.write_capture(root, [i*250 for i in range(200)])
            _, _, target, meta = derive_capture(source, input_meta=source_meta, signal='processed')
            states = [ProcessedSignal() for _ in range(8)]
            with open(target, newline='') as f:
                for i, row in enumerate(csv.DictReader(f)):
                    for ch, state in enumerate(states):
                        self.assertEqual(int(row[f'channel_{ch}']), state.step(1000+i*(ch+1)))
            self.assertEqual(json.loads(Path(meta).read_text())['filter']['id'], ProcessedSignal.FILTER_ID)

    def test_comb_companion_uses_new_identity_and_integer_model(self):
        with tempfile.TemporaryDirectory() as root:
            source, source_meta = self.write_capture(root, [i*250 for i in range(200)])
            _, resets, target, target_meta = derive_capture(source, input_meta=source_meta,
                                                           signal='notchcomb')
            self.assertEqual(resets, 0)
            self.assertIn('_notchcomb.csv', target)
            states = [NotchComb() for _ in range(8)]
            with open(target, newline='') as f:
                for i, row in enumerate(csv.DictReader(f)):
                    for ch, state in enumerate(states):
                        self.assertEqual(int(row[f'channel_{ch}']), state.step(1000+i*(ch+1)))
            self.assertEqual(json.loads(Path(target_meta).read_text())['filter']['id'], NotchComb.FILTER_ID)

    def write_capture(self, root, timestamps, signal="raw"):
        csv_path = Path(root) / "raw.csv"
        json_path = csv_path.with_suffix(".json")
        header = ["timestamp_us"] + ["channel_%d" % c for c in range(8)] + [
            "action", "subject", "session"]
        with csv_path.open("w", newline="") as fh:
            writer = csv.writer(fh, lineterminator="\n")
            writer.writerow(header)
            for i, timestamp in enumerate(timestamps):
                writer.writerow([timestamp] + [1000 + i * (c + 1)
                                               for c in range(8)] +
                                ["fist", "s1", "e2"])
        json_path.write_text(json.dumps({
            "signal": signal,
            "sample_rate_hz": 4000,
            "keep_all": True,
        }))
        return csv_path, json_path

    def test_filter_and_columns_are_aligned(self):
        with tempfile.TemporaryDirectory() as root:
            source, source_meta = self.write_capture(root, [0, 250, 500, 750])
            target = Path(root) / "notch.csv"
            target_meta = Path(root) / "notch.json"
            rows, resets, _, _ = derive_capture(
                source, target, source_meta, target_meta)
            self.assertEqual((rows, resets), (4, 0))
            with target.open(newline="") as fh:
                out = list(csv.DictReader(fh))
            states = [Notch50() for _ in range(8)]
            for i, row in enumerate(out):
                self.assertEqual(int(row["timestamp_us"]), [0, 250, 500, 750][i])
                for ch, state in enumerate(states):
                    expected = state.step(1000 + i * (ch + 1))
                    self.assertEqual(int(row["channel_%d" % ch]), expected)
                self.assertEqual(row["action"], "fist")
            meta = json.loads(target_meta.read_text())
            self.assertEqual(meta["signal"], "notch50")
            self.assertEqual(meta["filter"]["id"], Notch50.FILTER_ID)
            self.assertTrue(meta["derived_from"].replace("\\", "/").endswith("/raw.csv") or
                            meta["derived_from"].replace("\\", "/") == "raw.csv")

    def test_gap_resets_filter_state_and_double_filter_is_rejected(self):
        with tempfile.TemporaryDirectory() as root:
            source, source_meta = self.write_capture(root, [0, 250, 1000, 1250])
            target = Path(root) / "notch.csv"
            rows, resets, _, _ = derive_capture(source, target, source_meta,
                                                 Path(root) / "notch.json")
            self.assertEqual((rows, resets), (4, 1))
            with target.open(newline="") as fh:
                out = list(csv.DictReader(fh))
            state = Notch50()
            for i in range(2):
                state.step(1000 + i)
            expected_after_reset = Notch50().step(1002)
            self.assertEqual(int(out[2]["channel_0"]), expected_after_reset)

            source_meta.write_text(json.dumps({"signal": "notch50",
                                                "sample_rate_hz": 4000}))
            with self.assertRaises(ValueError):
                derive_capture(source, Path(root) / "again.csv", source_meta,
                               Path(root) / "again.json")

            source_meta.write_text(json.dumps({"signal": "raw",
                                                "sample_rate_hz": 4000,
                                                "filter": {"id": "bandpass"}}))
            with self.assertRaises(ValueError):
                derive_capture(source, Path(root) / "bandpass.csv", source_meta,
                               Path(root) / "bandpass.json")


if __name__ == "__main__":
    unittest.main()

