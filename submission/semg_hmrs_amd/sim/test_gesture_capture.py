import csv
import json
import struct
import sys
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))

from capture_actions import ACTIONS, KEYS, LABELS, SCHEMA, label_for_command, render_header
from decode_sd_record import decode
from train_board_model import feature_windows, read_capture
import train_gesture_model
from train_gesture_model import extract_capture, load_manifest, require_classes


class GestureCaptureTests(unittest.TestCase):
    def test_schema_and_console_aliases(self):
        self.assertEqual(len(LABELS), 14)
        self.assertEqual(SCHEMA, 2)
        self.assertEqual([label_for_command(k) for k in KEYS], LABELS)
        self.assertEqual(label_for_command("14"), LABELS[-1])
        self.assertEqual(label_for_command("0"), "none")
        self.assertIn("SD_ACTION_THUMB_INDEX_MIDDLE = 14", render_header())

    def test_old_sd_header_stays_legacy_and_schema_two_decodes_new_id(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            frame = bytearray(52)
            struct.pack_into("<HB", frame, 0, 7, 14)
            legacy = bytearray(512)
            legacy[:7] = b"SEMGSD1"
            struct.pack_into("<6I", legacy, 8, 1, 4000, 8, 52, 1, 2)
            (root / "legacy.BIN").write_bytes(legacy + frame)
            _, legacy_csv, legacy_meta, *_ = decode(str(root / "legacy.BIN"), root)
            self.assertEqual(json.loads(Path(legacy_meta).read_text())["action_schema"], 0)
            with open(legacy_csv, newline="") as fh:
                self.assertEqual(next(csv.DictReader(fh))["action"], "unknown_14")

            current = bytearray(legacy)
            struct.pack_into("<I", current, 8, 2)
            struct.pack_into("<I", current, 32, 3)
            struct.pack_into("<I", current, 36, SCHEMA)
            (root / "current.BIN").write_bytes(current + frame)
            _, current_csv, meta, *_ = decode(str(root / "current.BIN"), root)
            self.assertEqual(json.loads(Path(meta).read_text())["action_schema"], SCHEMA)
            with open(current_csv, newline="") as fh:
                self.assertEqual(next(csv.DictReader(fh))["action"], LABELS[-1])

    def test_unlabeled_bouts_are_not_joined_into_training_windows(self):
        x = [[i] * 8 for i in range(1200)]
        y = [0] * 600 + [-1] * 200 + [0] * 400
        fx, fy, _ = feature_windows(__import__("numpy").asarray(x),
                                     __import__("numpy").asarray(y), trim=0)
        self.assertGreater(len(fy), 0)
        self.assertTrue((fy == 0).all())

    def test_uart_processed_csv_requires_schema_sidecar_and_unlabeled_is_allowed(self):
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "capture.csv"
            with path.open("w", newline="") as fh:
                writer = csv.writer(fh)
                writer.writerow(["timestamp_us"] + [f"channel_{i}" for i in range(8)] +
                                ["action", "subject", "session"])
                for i in range(20001):
                    label = "none" if i < 4000 or i >= 16000 else "thumb_index_middle_extend"
                    writer.writerow([i * 250] + [str((i % 17) - 8)] * 8 + [label, "s30", "test"])
            with self.assertRaisesRegex(ValueError, "sidecar"):
                extract_capture(path)
            path.with_suffix(".json").write_text(json.dumps({"signal": "processed", "action_schema": SCHEMA}))
            fx, fy = extract_capture(path)
            self.assertGreater(len(fy), 0)
            self.assertTrue((fy == LABELS.index("thumb_index_middle_extend")).all())
            with self.assertRaisesRegex(ValueError, "expected processed"):
                read_capture(path, classes=LABELS, allow_unlabeled=True,
                             source_if_missing="raw")

    def test_manifest_rejects_wear_leakage_and_training_requires_all_classes(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            a, b = root / "a.csv", root / "b.csv"
            a.write_text("a")
            b.write_text("b")
            manifest = root / "manifest.csv"
            with manifest.open("w", newline="") as fh:
                writer = csv.writer(fh)
                writer.writerow(["path", "wear_id", "split", "effort"])
                writer.writerow([a, "wear1", "train", "light"])
                writer.writerow([b, "wear1", "test", "comfortable"])
            with self.assertRaisesRegex(ValueError, "both train and test"):
                load_manifest(manifest)
        with self.assertRaisesRegex(ValueError, "missing classes"):
            require_classes([0, 1, 1], "test")

    def test_offline_candidate_train_path_runs_without_board_export(self):
        import numpy as np

        rng = np.random.default_rng(8)
        samples = {}
        for split in ("train", "test"):
            features, labels = [], []
            for cls in range(len(LABELS)):
                for _ in range(6):
                    feature = rng.normal(0, 1, 40) + cls * 25
                    feature[:8] += 100 + cls * 10
                    features.append(feature)
                    labels.append(cls)
            samples[split] = (np.asarray(features), np.asarray(labels))
        rows = [dict(path="train.csv", resolved_path=Path("train.csv"), sha256="a",
                     wear_id="wear_a", split="train", effort="light"),
                dict(path="test.csv", resolved_path=Path("test.csv"), sha256="b",
                     wear_id="wear_b", split="test", effort="comfortable")]
        with patch.object(train_gesture_model, "extract_capture",
                          side_effect=lambda p: samples["train" if str(p)=="train.csv" else "test"]):
            model, report = train_gesture_model.train(rows, 8)
        self.assertFalse(report["pl_compatible"])
        self.assertFalse(report["model_changed_on_board"])
        self.assertEqual(len(report["held_out_test"]["test.csv"]["counts"]), 14)
        self.assertEqual(len(model.classes_), 14)


if __name__ == "__main__":
    unittest.main()

