import csv
import json
import tempfile
import unittest
from pathlib import Path

import numpy as np

from tools.analyze_capture import build_report, html_report, load_capture


class CaptureAnalysisTests(unittest.TestCase):
    def make_capture(self, root):
        csv_path = Path(root) / "capture.csv"
        json_path = csv_path.with_suffix(".json")
        fs = 4000
        rows = []
        sample_count = 3200
        missing_at = 1400
        for i in range(sample_count):
            logical = i + (2 if i >= missing_at else 0)
            t_us = logical * 250
            values = [int(1000 * np.sin(2 * np.pi * 100 * logical / fs)) + c * 10
                      for c in range(8)]
            rows.append([t_us, *values, "fist" if i >= 1000 else "rest", "s1", "e1"])
        with csv_path.open("w", newline="", encoding="utf-8") as handle:
            writer = csv.writer(handle)
            writer.writerow(["timestamp_us", *[f"channel_{i}" for i in range(8)],
                             "action", "subject", "session"])
            writer.writerows(rows)
        json_path.write_text(json.dumps({"sample_rate_hz": fs, "signal": "raw"}),
                             encoding="utf-8")
        return csv_path

    def test_gap_and_report_contract(self):
        with tempfile.TemporaryDirectory() as temp:
            path = self.make_capture(temp)
            path, timestamps, samples, labels, meta, fs = load_capture(path)
            report = build_report(path, timestamps, samples, labels, meta, fs)
            self.assertEqual(report["quality"]["missing_frames"], 2)
            self.assertEqual(report["quality"]["gap_events"], 1)
            self.assertEqual(report["labels"]["counts"]["rest"], 1000)
            self.assertEqual(report["labels"]["counts"]["fist"], 2200)
            self.assertEqual(len(report["channel_metrics"]), 8)
            self.assertEqual(len(report["spectrum"]["channels"]), 8)
            self.assertTrue(0.0 <= report["spectrum"]["channels"][0]["harmonic_fraction"] <= 1.0)
            page = html_report(report)
            self.assertIn("Waveform overview", page)
            self.assertIn("Data quality and labels", page)
            self.assertIn("canvas id=\"spec\"", page)

    def test_sequence_replay_is_bad_despite_increasing_timestamps(self):
        with tempfile.TemporaryDirectory() as temp:
            path = self.make_capture(temp)
            path, timestamps, samples, labels, meta, fs = load_capture(path)
            for field in ("sequence_backwards", "sequence_duplicates",
                          "frames_backward_uart", "frames_duplicate_uart"):
                with self.subTest(field=field):
                    report = build_report(path, timestamps, samples, labels,
                                          {**meta, field: 1}, fs)
                    self.assertEqual(report["quality_status"], "BAD")
                    self.assertEqual(report["quality"]["sequence_backwards"] +
                                     report["quality"]["sequence_duplicates"], 1)


if __name__ == "__main__":
    unittest.main()

