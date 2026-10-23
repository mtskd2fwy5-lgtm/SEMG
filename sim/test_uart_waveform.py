"""UART waveform regressions; no board or serial port is opened."""
import contextlib
import csv
import io
import json
import sys
import tempfile
import unittest
from pathlib import Path
from types import SimpleNamespace
from unittest.mock import patch

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools"))
import record_uart as recorder
import plot_csv as viewer


VALUES = [-8388608, -1, 0, 1, 8388607, 0x55AA, -123456, 654321]


def frame(seq, values=VALUES, signal="raw"):
    return recorder.SIGNAL_SYNC[signal] + seq.to_bytes(2, "little") + b"".join(
        v.to_bytes(3, "little", signed=True) for v in values)


def parse_stream(stream, chunk_size, signal="raw"):
    state = dict(quit=False, label="none", count=0, fs=4000,
                 dropped=0, false_sync=0, signal=signal)
    frames = []

    class FakeSerial:
        offset = 0

        def read(self, _):
            data = stream[self.offset:self.offset + chunk_size]
            self.offset += len(data)
            if not data:
                state["quit"] = True
            return data

    recorder.reader(FakeSerial(), frames, state)
    return frames, state


class WaveformTests(unittest.TestCase):
    def test_notch_marker_fragmentation_and_wrap(self):
        stream = b"NOTCHREC1 fs=4000\n" + b"".join(
            frame(seq, signal="notch50") for seq in [65534, 65535, 0, 1, 2])
        for size in (1, 2, 3, 27, 28, 29, 56, 4096):
            with self.subTest(size=size):
                frames, state = parse_stream(stream, size, "notch50")
                self.assertEqual([f[0] for f in frames], [0, 250, 500, 750])
                self.assertTrue(all(f[1] == VALUES for f in frames))
                self.assertEqual(state["dropped"], 0)
                self.assertEqual(state["unconfirmed_tail_bytes"], 28)

    def test_mismatched_source_is_never_accepted(self):
        for actual, requested in (("raw", "notch50"), ("notch50", "raw")):
            stream = b"".join(frame(seq, signal=actual) for seq in range(20))
            for size in (1, 29, 4096):
                with self.subTest(actual=actual, size=size):
                    frames, _ = parse_stream(stream, size, requested)
                    self.assertEqual(frames, [])

    def test_notch_missing_payload_byte_is_rejected(self):
        for offset in range(4, 28):
            source = frame(11, signal="notch50")
            broken = source[:offset] + source[offset + 1:]
            stream = (frame(10, signal="notch50") + broken + b"".join(
                frame(seq, signal="notch50") for seq in [12, 13, 14]))
            for size in (1, 27, 28, 29, 4096):
                with self.subTest(offset=offset, size=size):
                    frames, state = parse_stream(stream, size, "notch50")
                    self.assertEqual([f[0] for f in frames], [0, 500, 750])
                    self.assertTrue(all(f[1] == VALUES for f in frames))
                    self.assertEqual(state["dropped"], 1)

    def test_capture_metadata_identifies_selected_signal(self):
        for signal in ("raw", "notch50", "notchcomb", "processed"):
            with tempfile.TemporaryDirectory() as root, patch.object(recorder, "ROOT", root):
                paths = recorder.capture_paths("s30", "e2", True)
                args = SimpleNamespace(fs=4000, baud=2000000, trim=0,
                                       keep_all=True, subject="s30", session="e2")
                state = dict(signal=signal, dropped=0, false_sync=0)
                recorder.save_capture([(0, VALUES, "none")], state, args, *paths)
                meta = json.loads(Path(paths[1]).read_text())
                self.assertEqual(meta["signal"], signal)
                self.assertEqual(meta["wire_sync_hex"], recorder.SIGNAL_SYNC[signal].hex())
                if signal == "raw":
                    self.assertIsNone(meta["filter"])
                else:
                    self.assertEqual(meta["filter"]["id"], recorder.line_filter_metadata(signal)['id'])
                    self.assertEqual(meta["filter"]["location"], "PL")

    def test_fragmented_signed_frames_and_sequence_wrap(self):
        stream = b"RAWREC1 8ch24b\n" + b"".join(
            frame(seq) for seq in [65534, 65535, 0, 1, 2])
        for size in (1, 2, 3, 27, 28, 29, 56, 4096):
            with self.subTest(size=size):
                frames, state = parse_stream(stream, size)
                self.assertEqual([f[0] for f in frames], [0, 250, 500, 750])
                self.assertTrue(all(f[1] == VALUES for f in frames))
                self.assertEqual(state["dropped"], 0)
                self.assertEqual(state["false_sync"], 0)
                self.assertEqual(state["unconfirmed_tail_bytes"], 28)

    def test_comb_marker_and_backward_sequence(self):
        stream = b''.join(frame(seq, signal='notchcomb')
                          for seq in (30565,30566,30055,30056,30057))
        frames, state = parse_stream(stream, 4096, 'notchcomb')
        self.assertEqual([f[0] for f in frames], [0,250,500,750])
        self.assertEqual(state['backwards'], 1)
        self.assertEqual(state['dropped'], 0)

    def test_final_processed_marker_is_distinct_from_older_filters(self):
        stream = b''.join(frame(seq, signal='processed') for seq in (65535,0,1,2))
        for chunk in (1,28,4096):
            frames, state = parse_stream(stream, chunk, 'processed')
            self.assertEqual(len(frames), 3)
            self.assertEqual(state['dropped'], 0)
        for legacy in ('notch50','notchcomb','raw'):
            frames, _ = parse_stream(stream, 4096, legacy)
            self.assertEqual(frames, [])

    def test_dropped_frames_leave_real_time_gap(self):
        stream = b"".join(frame(seq) for seq in [20, 21, 25, 26, 27])
        for size in (1, 28, 4096):
            with self.subTest(size=size):
                frames, state = parse_stream(stream, size)
                self.assertEqual([f[0] for f in frames], [0, 250, 1250, 1500])
                self.assertEqual(state["dropped"], 3)

    def test_false_sync_does_not_create_fake_drops(self):
        stream = (frame(10) + frame(11) + frame(54321)[:15] +
                  frame(12) + frame(13) + frame(14))
        for size in (1, 29, 4096):
            with self.subTest(size=size):
                frames, state = parse_stream(stream, size)
                self.assertEqual(len(frames), 4)
                self.assertEqual(state["dropped"], 0)
                self.assertGreaterEqual(state["boundary_rejects"], 1)

    def test_duplicate_is_not_a_65535_frame_gap(self):
        frames, state = parse_stream(b"".join(
            frame(seq) for seq in [8, 9, 9, 10, 11]), 4096)
        self.assertEqual(len(frames), 3)
        self.assertEqual(state["dropped"], 0)
        self.assertEqual(state["duplicates"], 1)

    def test_missing_payload_byte_never_becomes_ch8_spike(self):
        for offset in range(4, 28):
            broken = frame(11)[:offset] + frame(11)[offset + 1:]
            stream = frame(10) + broken + frame(12) + frame(13) + frame(14)
            for size in (1, 27, 28, 29, 4096):
                with self.subTest(offset=offset, size=size):
                    frames, state = parse_stream(stream, size)
                    self.assertEqual([f[0] for f in frames], [0, 500, 750])
                    self.assertTrue(all(f[1] == VALUES for f in frames))
                    self.assertEqual(state["dropped"], 1)
                    self.assertGreaterEqual(state["boundary_rejects"], 1)

    def test_inserted_payload_byte_is_rejected(self):
        broken = frame(11)[:17] + b"\x99" + frame(11)[17:]
        stream = frame(10) + broken + frame(12) + frame(13) + frame(14)
        for size in (1, 29, 4096):
            with self.subTest(size=size):
                frames, state = parse_stream(stream, size)
                self.assertEqual([f[0] for f in frames], [0, 500, 750])
                self.assertTrue(all(f[1] == VALUES for f in frames))
                self.assertEqual(state["dropped"], 1)

    def test_last_frame_requires_confirming_header(self):
        frames, state = parse_stream(frame(100) + frame(101) + frame(102), 1)
        self.assertEqual(len(frames), 2)
        self.assertEqual(state["unconfirmed_tail_bytes"], 28)
        self.assertTrue(all(f[1] == VALUES for f in frames))

    def test_keep_all_and_default_boundary_trim(self):
        labels = ["none"] * 3 + ["rest"] * 5 + ["fist"] * 4 + ["none"]
        frames = [(i * 250, VALUES, label) for i, label in enumerate(labels)]
        keep, runs = recorder.select_frames(frames, 1)
        self.assertEqual([i for i, k in enumerate(keep) if k], [4, 5, 6, 9, 10])
        complete, same_runs = recorder.select_frames(frames, 999, keep_all=True)
        self.assertTrue(all(complete))
        self.assertEqual(runs, same_runs)

    def test_save_roundtrip_and_non_overwriting_paths(self):
        frames = [(i * 250, list(VALUES), label) for i, label in
                  enumerate(["none", "rest", "fist", "none"])]
        state = dict(dropped=0, false_sync=0)
        args = SimpleNamespace(fs=4000, baud=2000000, trim=0.5,
                               keep_all=True, subject="s30", session="e2")
        with tempfile.TemporaryDirectory() as root, patch.object(recorder, "ROOT", root):
            csv_path, json_path = recorder.capture_paths("s30", "e2", True)
            self.assertEqual(Path(csv_path).name, "S30_E2_A1_waveform.csv")
            written, _ = recorder.save_capture(frames, state, args, csv_path, json_path)
            self.assertEqual(written, len(frames))
            meta = json.loads(Path(json_path).read_text())
            self.assertTrue(meta["keep_all"])
            self.assertEqual(meta["trim_seconds"], 0)
            with open(csv_path, newline="") as fh:
                rows = list(csv.DictReader(fh))
            self.assertEqual([r["action"] for r in rows], [f[2] for f in frames])
            t, data, labels, _ = viewer.load_csv(csv_path)
            np.testing.assert_array_equal(data, [VALUES] * 4)
            np.testing.assert_allclose(t, [0, .00025, .0005, .00075])
            next_csv, _ = recorder.capture_paths("s30", "e2", True)
            self.assertNotEqual(csv_path, next_csv)
            with self.assertRaises(FileExistsError):
                recorder.save_capture(frames, state, args, csv_path, json_path)

    def test_envelope_includes_final_extreme(self):
        t = np.arange(103) / 4000
        signal = np.zeros(103)
        signal[-1] = 123456
        tc, lo, hi = viewer.envelope(t, signal, 10)
        self.assertEqual(len(tc), 10)
        self.assertEqual(hi[-1], 123456)
        self.assertEqual(hi.max(), signal.max())

    def test_interval_and_gap_detection(self):
        t = np.arange(8) / 4000
        data = np.arange(64).reshape(8, 8)
        labels = np.array(["none"] * 8)
        ts, ds, _ = viewer.select_interval(t, data, labels, .0005, .00075)
        np.testing.assert_array_equal(ts, t[2:5])
        np.testing.assert_array_equal(ds, data[2:5])
        with self.assertRaises(ValueError):
            viewer.select_interval(t, data, labels, 5, 1)
        spans = viewer.contiguous_slices(np.array([0, .00025, .001, .00125]), 4000)
        self.assertEqual([(s.start, s.stop) for s in spans], [(0, 2), (2, 4)])

    def test_raw_plot_uses_every_sample_and_preserves_gap(self):
        with tempfile.TemporaryDirectory() as root, patch.object(recorder, "ROOT", root):
            frames = [(i * 250, [v + i for v in VALUES], "none")
                      for i in [0, 1, 2, 5, 6, 7]]
            args = SimpleNamespace(fs=4000, baud=2000000, trim=0.5,
                                   keep_all=True, subject="s30", session="e2")
            paths = recorder.capture_paths("s30", "e2", True)
            recorder.save_capture(frames, dict(dropped=2, false_sync=0), args, *paths)
            plot_args = SimpleNamespace(channels=[0, 7], raw=True, bins=2,
                                        start=0, duration=None, dc="none")
            fig, axs = plt.subplots(2, 1)
            try:
                with contextlib.redirect_stdout(io.StringIO()):
                    viewer.plot_file(axs, paths[0], plot_args)
                for ax, channel in zip(axs, [0, 7]):
                    self.assertEqual(len(ax.lines), 2)
                    values = np.concatenate([line.get_ydata() for line in ax.lines])
                    np.testing.assert_array_equal(values, [f[1][channel] for f in frames])
                fig.canvas.draw()
            finally:
                plt.close(fig)


if __name__ == "__main__":
    unittest.main()
