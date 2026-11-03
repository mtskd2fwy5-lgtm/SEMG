import csv, json, struct, tempfile, unittest
from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools"))
from decode_sd_record import decode

def p24(v):
    return struct.pack("<I", v & 0xffffff)[:3]

class DecodeTests(unittest.TestCase):
    def test_corrupt_tail_is_flagged_and_not_silently_relabelled(self):
        with tempfile.TemporaryDirectory() as d:
            src = Path(d) / 'EMG018.BIN'
            h = bytearray(512); h[:7] = b'SEMGSD1'
            struct.pack_into('<7I', h, 8, 2, 4000, 8, 52, 1, 2, 3)
            good = bytearray(52); struct.pack_into('<HB', good, 0, 100, 1)
            src.write_bytes(h+good+bytes([255])*52)
            _, filtered, meta, n, _ = decode(str(src), d)
            m = json.loads(Path(meta).read_text())
            self.assertFalse(m['frame_fields_valid'])
            self.assertEqual(m['invalid_action_frames'], 1)
            self.assertEqual(m['first_invalid_action_row'], 1)
            self.assertEqual(m['nonzero_reserved_frames'], 1)
            with open(filtered, newline='') as f: rows = list(csv.DictReader(f))
            self.assertEqual(rows[-1]['action'], 'unknown_255')
            self.assertEqual(n, 2)

    def test_v2_comb_and_rollback_are_not_huge_forward_loss(self):
        with tempfile.TemporaryDirectory() as d:
            src = Path(d) / "EMG005.BIN"
            h = bytearray(512); h[:7] = b"SEMGSD1"
            struct.pack_into("<7I", h, 8, 2, 4000, 8, 52, 1, 2, 2)
            frames = bytearray()
            for seq in (30565, 30566, 30055, 30056, 30056, 30058):
                p = bytearray(52); struct.pack_into("<HB", p, 0, seq, 1); frames += p
            src.write_bytes(h+frames)
            raw, filtered, meta, n, gaps = decode(str(src), d)
            self.assertEqual((n, gaps), (6, 1))
            m = json.loads(Path(meta).read_text())
            self.assertEqual((m['sequence_backwards'], m['sequence_duplicates']), (1, 1))
            self.assertIn('_notchcomb.csv', filtered)
            sidecar = json.loads(Path(filtered).with_suffix('.json').read_text())
            self.assertEqual(sidecar['filter']['comb_delay_samples'], 80)
            with open(raw, newline='') as f: rows = list(csv.DictReader(f))
            self.assertEqual([int(r['timestamp_us']) for r in rows], [0,250,500,750,1000,1500])

    def test_v2_final_waveform_filter_code(self):
        with tempfile.TemporaryDirectory() as d:
            src = Path(d) / 'EMG006.BIN'
            h = bytearray(512); h[:7] = b'SEMGSD1'
            struct.pack_into('<7I', h, 8, 2, 4000, 8, 52, 1, 2, 3)
            src.write_bytes(h+bytes(52))
            _, filtered, _, n, gaps = decode(str(src), d)
            self.assertEqual((n,gaps),(1,0))
            m = json.loads(Path(filtered).with_suffix('.json').read_text())
            self.assertEqual(m['signal'], 'processed')
            self.assertEqual(m['filter']['stages'], ['notch50_q10','comb50_bw1','hp20','lp215'])

    def test_pair_wrap_and_signed_values(self):
        with tempfile.TemporaryDirectory() as d:
            src = Path(d) / "EMG000.BIN"
            h = bytearray(512); h[:7] = b"SEMGSD1"; struct.pack_into("<6I", h, 8, 1, 4000, 8, 52, 1, 2)
            frames = bytearray()
            for seq in (65535, 0, 2):
                p = bytearray(52); struct.pack_into("<HB", p, 0, seq, 3)
                for i in range(8): p[4+i*3:7+i*3] = p24(-8388608+i)
                for i in range(8): p[28+i*3:31+i*3] = p24(8388607-i)
                frames += p
            src.write_bytes(h + frames)
            raw, notch, meta, n, gaps = decode(str(src), d)
            self.assertEqual((n, gaps), (3, 1))
            with open(raw, newline="") as f: rows = list(csv.DictReader(f))
            self.assertEqual(int(rows[0]["channel_0"]), -8388608); self.assertEqual(rows[0]["action"], "fist")
            self.assertEqual(json.loads(Path(meta).read_text())["sequence_gaps"], 1)

if __name__ == "__main__": unittest.main()

