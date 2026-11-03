"""Training/export regressions for the shared PL notch sample contract."""
import csv
import json
import sys
import tempfile
import unittest
from pathlib import Path

import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools"))
import train_baseline as train
import export_int8 as export
import evaluate_temporal_stack as temporal
from emg_reference import Bandpass, Notch50, NotchComb, ProcessedSignal, line_filter_metadata


def recording_meta(signal="raw"):
    return {"signal": signal, "sample_rate_hz": 4000, "keep_all": True,
            "filter": ({"id": Notch50.FILTER_ID, "sample_rate_hz": 4000}
                       if signal == "notch50" else None)}


def independent_filter(x, kind):
    channels = []
    for channel in x.T:
        state = kind()
        channels.append([state.step(int(v)) for v in channel])
    return np.asarray(channels, dtype=np.int32).T


class NotchPreprocessingTests(unittest.TestCase):
    def test_final_signed_waveform_is_not_bandpassed_twice(self):
        meta = {**recording_meta(), 'signal':'processed', 'filter':line_filter_metadata('processed')}
        expected = independent_filter(self.x, ProcessedSignal)
        for apply_bandpass in (False, True):
            raw, _ = train.prepare_samples(self.x, self.y, fs=4000, notch50='processed', pl_filter=apply_bandpass)
            filtered, _ = train.prepare_samples(expected, self.y, fs=4000, notch50='processed',
                                                pl_filter=apply_bandpass, metadata=meta)
            np.testing.assert_array_equal(raw, expected)
            np.testing.assert_array_equal(filtered, expected)
        with self.assertRaises(ValueError):
            train.prepare_samples(expected, self.y, fs=4000, notch50=True, metadata=meta)

    def test_comb_contract_matches_raw_and_never_filters_twice(self):
        meta = {**recording_meta(), 'signal':'notchcomb',
                'filter':line_filter_metadata('notchcomb')}
        notch = independent_filter(self.x, NotchComb)
        raw, _ = train.prepare_samples(self.x, self.y, fs=4000, notch50='notchcomb', pl_filter=True)
        filtered, _ = train.prepare_samples(notch, self.y, fs=4000, notch50='notchcomb',
                                            pl_filter=True, metadata=meta)
        np.testing.assert_array_equal(raw, filtered)
        for contract in (False, True):
            with self.assertRaises(ValueError):
                train.prepare_samples(notch, self.y, fs=4000, notch50=contract, metadata=meta)
        with self.assertRaises(ValueError):
            train.prepare_samples(notch, self.y, fs=4000, notch50='notchcomb',
                                  metadata={**meta,'sequence_backwards':1})

    def setUp(self):
        self.x = np.random.default_rng(57).integers(
            -100000, 100001, (1200, 8), dtype=np.int32)
        self.y = np.full(1200, 2, dtype=np.int8)

    def test_raw_and_matching_filtered_csv_have_identical_bandpass_input(self):
        notch = independent_filter(self.x, Notch50)
        raw, ry = train.prepare_samples(
            self.x, self.y, fs=4000, notch50=True, pl_filter=True,
            metadata=recording_meta())
        filtered, fy = train.prepare_samples(
            notch, self.y, fs=4000, notch50=True, pl_filter=True,
            metadata=recording_meta("notch50"))
        np.testing.assert_array_equal(raw, independent_filter(notch, Bandpass))
        np.testing.assert_array_equal(raw, filtered)
        np.testing.assert_array_equal(ry, fy)
        self.assertTrue(np.any(independent_filter(notch, Notch50) != notch))

    def test_notch_is_before_decimation(self):
        actual, labels = train.prepare_samples(
            self.x, self.y, fs=4000, decim=4, notch50=True)
        expected = independent_filter(self.x, Notch50)[::4]
        np.testing.assert_array_equal(actual, expected)
        np.testing.assert_array_equal(labels, self.y[::4])
        self.assertTrue(np.any(actual != independent_filter(self.x[::4], Notch50)))

    def test_sample_hold_is_before_notch(self):
        actual, labels = train.prepare_samples(
            self.x[:80], self.y[:80], fs=200, resample=20, notch50=True)
        expected = independent_filter(np.repeat(self.x[:80], 20, axis=0), Notch50)
        np.testing.assert_array_equal(actual, expected)
        np.testing.assert_array_equal(labels, np.repeat(self.y[:80], 20))

    def test_legacy_sample_order_and_bandpass_are_preserved(self):
        actual, labels = train.prepare_samples(self.x, self.y, decim=2, resample=3)
        np.testing.assert_array_equal(actual, np.repeat(self.x[::2], 3, axis=0))
        np.testing.assert_array_equal(labels, np.repeat(self.y[::2], 3))
        actual, _ = train.prepare_samples(
            self.x[:60], self.y[:60], resample=20, pl_filter=True)
        np.testing.assert_array_equal(actual, independent_filter(
            np.repeat(self.x[:60], 20, axis=0), Bandpass))

    def test_rate_and_provenance_conflicts_are_rejected(self):
        cases = [
            dict(fs=0), dict(fs=200, decim=3),
            dict(fs=200, notch50=True), dict(fs=200, pl_filter=True),
            dict(fs=4000, notch50=True, decim=2, pl_filter=True),
            dict(fs=4000, notch50=True, metadata={"sample_rate_hz": 200}),
            dict(fs=4000, notch50=True, metadata={"signal": "bandpass"}),
            dict(fs=4000, metadata=recording_meta("notch50")),
            dict(fs=4000, notch50=True, metadata={"signal": "notch50"}),
            dict(fs=4000, notch50=True, metadata={
                **recording_meta("notch50"), "filter": {"id": "old"}}),
            dict(fs=200, resample=20, notch50=True, metadata={
                **recording_meta("notch50"), "sample_rate_hz": 200}),
            dict(fs=4000, notch50=True, metadata={"signal": "raw",
                "filter": {"id": Notch50.FILTER_ID}}),
            dict(fs=4000, notch50=True, metadata={"keep_all": False}),
            dict(fs=4000, notch50=True, metadata={"dropped_non_baseline": 5}),
        ]
        for kwargs in cases:
            with self.subTest(kwargs=kwargs), self.assertRaises(ValueError):
                train.prepare_samples(self.x, self.y, **kwargs)

    def write_session(self, root, subject, x, signal="raw", full=False):
        folder = root / subject
        folder.mkdir(exist_ok=True)
        suffix = "full" if full else "baseline"
        path = folder / ("%s_E2_A1_%s.csv" % (subject.upper(), suffix))
        with path.open("w", newline="") as fh:
            writer = csv.writer(fh)
            writer.writerow(["timestamp_us"] + ["channel_%d" % c for c in range(8)]
                            + (["exercise", "restimulus"] if full else ["action"]))
            for i, row in enumerate(x):
                label = "none" if 400 <= i < 600 else "fist"
                tail = [2, 1 if label == "none" else 6] if full else [label]
                writer.writerow([i * 250] + row.tolist() + tail)
        path.with_suffix(".json").write_text(json.dumps(recording_meta(signal)))
        return path

    def test_unknown_labels_remain_in_filter_stream_and_export_matches_training(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            self.write_session(root, "s1", self.x)
            expected_y = self.y.copy()
            expected_y[400:600] = -1
            x, y, meta = train.load_training_session(
                root, "s1", 2, "baseline", with_metadata=True, keep_unknown=True)
            np.testing.assert_array_equal(x, self.x)
            np.testing.assert_array_equal(y, expected_y)
            expected, labels = train.prepare_samples(
                x, y, fs=4000, notch50=True, pl_filter=True, metadata=meta)
            expected_f, expected_y = train.make_windows(expected, labels, 100, 25)
            result = export.load_all(
                [2], fs=4000, win_samples=100, hop_samples=25,
                pl_filter=True, notch50=True, data_dir=root)
            np.testing.assert_array_equal(result["s1"][0], expected_f)
            np.testing.assert_array_equal(result["s1"][1], expected_y)
            self.assertTrue(np.all(expected_y >= 0))
            legacy_x, _ = train.load_training_session(root, "s1", 2, "baseline")
            self.assertEqual(len(legacy_x), 1000)

    def test_export_raw_and_pre_notched_files_produce_the_same_features(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            self.write_session(root, "s1", self.x)
            self.write_session(root, "s2", independent_filter(self.x, Notch50),
                               signal="notch50")
            result = export.load_all(
                [2], fs=4000, win_samples=100, hop_samples=25,
                pl_filter=True, notch50=True, data_dir=root)
            for a, b in zip(result["s1"], result["s2"]):
                np.testing.assert_array_equal(a, b)

    def test_temporal_existing_caller_passes_native_rate(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            self.write_session(root, "s1", self.x, full=True)
            x, y = temporal.load_full_session(
                root, "s1", 2, 4000, 1, 1, True, 100, 25, 1)
            self.assertGreater(len(y), 0)
            self.assertEqual(x.shape[1], 40)

    def test_continuous_board_waveform_file_is_loaded_without_renaming(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            path = self.write_session(root, "s1", self.x)
            path.rename(path.with_name("S1_E2_A1_waveform.csv"))
            path.with_suffix(".json").rename(path.with_name("S1_E2_A1_waveform.json"))
            result = export.load_all(
                [2], fs=4000, win_samples=100, hop_samples=25,
                input_mode="waveform", pl_filter=True, notch50=True, data_dir=root)
            self.assertGreater(len(result["s1"][1]), 0)


if __name__ == "__main__":
    unittest.main()

