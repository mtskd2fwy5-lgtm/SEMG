#!/usr/bin/env python3
"""Decode SEMGSD1 files written by the LCD SD recorder.

Writes timestamped raw and versioned filtered CSVs plus metadata. Existing outputs
are never overwritten; sequence gaps and 16-bit wrap are reported in JSON.
"""
import argparse, csv, json, os, struct
from emg_reference import line_filter_metadata

ACTION = {0: "none", 1: "rest", 2: "open_hand", 3: "fist",
          4: "wrist_flex", 5: "wrist_extend"}
HEADER = 512
FRAME = 52

def s24(p):
    v = p[0] | (p[1] << 8) | (p[2] << 16)
    return v - (1 << 24) if v & (1 << 23) else v

def fresh(path):
    if not os.path.exists(path): return path
    stem, ext = os.path.splitext(path)
    i = 1
    while os.path.exists(f"{stem}_{i}{ext}"): i += 1
    return f"{stem}_{i}{ext}"

def decode(src, outdir=None):
    with open(src, "rb") as f:
        h = f.read(HEADER)
        if len(h) != HEADER or h[:7] != b"SEMGSD1": raise ValueError("invalid SEMGSD1 header")
        version, fs, chans, frame_bytes, encoding, sources = struct.unpack_from("<6I", h, 8)
        if version not in (1, 2) or fs == 0 or chans != 8 or frame_bytes != FRAME or encoding != 1 or sources != 2:
            raise ValueError("unsupported header fields")
        filter_code = 1 if version == 1 else struct.unpack_from("<I", h, 32)[0]
        if filter_code not in (1, 2, 3): raise ValueError("unsupported filter code")
        filtered_signal = {1:"notch50", 2:"notchcomb", 3:"processed"}[filter_code]
        body = f.read()
    if len(body) % FRAME: raise ValueError(f"truncated frame tail: {len(body)%FRAME} bytes")
    rows = []
    invalid_actions, invalid_reserved = [], []
    for off in range(0, len(body), FRAME):
        p = body[off:off+FRAME]
        seq, action = struct.unpack_from("<HB", p, 0)
        if action not in ACTION: invalid_actions.append(off // FRAME)
        if p[3] != 0: invalid_reserved.append(off // FRAME)
        raw = [s24(p[4+i*3:7+i*3]) for i in range(8)]
        notch = [s24(p[28+i*3:31+i*3]) for i in range(8)]
        rows.append((seq, ACTION.get(action, f"unknown_{action}"), raw, notch))
    if outdir is None: outdir = os.path.dirname(os.path.abspath(src)) or "."
    os.makedirs(outdir, exist_ok=True)
    stem = os.path.splitext(os.path.basename(src))[0]
    raw_path = fresh(os.path.join(outdir, stem + "_raw.csv"))
    notch_path = fresh(os.path.join(outdir, stem + "_" + filtered_signal + ".csv"))
    fields = ["timestamp_us"] + [f"channel_{i}" for i in range(8)] + ["action", "source", "sequence"]
    gaps = backwards = duplicates = wraps = 0
    events = []
    prev = None
    sample_index = 0
    with open(raw_path, "w", newline="", encoding="utf-8") as rf, open(notch_path, "w", newline="", encoding="utf-8") as nf:
        rw, nw = csv.writer(rf), csv.writer(nf)
        rw.writerow(fields); nw.writerow(fields)
        for i, (seq, action, raw, notch) in enumerate(rows):
            if prev is not None:
                step = (seq-prev) & 0xffff
                if step == 0:
                    duplicates += 1
                    kind = "duplicate"
                elif step >= 0x8000:
                    backwards += 1
                    kind = "backward"
                else:
                    gaps += step-1
                    wraps += int(seq < prev)
                    kind = "forward_gap" if step != 1 else None
                if kind:
                    events.append({"row": i, "previous": prev, "sequence": seq, "kind": kind})
                # Preserve forward gaps; a backwards event cannot recover real time.
                sample_index += step if 0 < step < 0x8000 else 1
            prev = seq
            t = sample_index * 1_000_000 // fs
            rw.writerow([t] + raw + [action, "raw", seq])
            nw.writerow([t] + notch + [action, filtered_signal, seq])
    meta = fresh(os.path.join(outdir, stem + "_decode.json"))
    common = {"format": "SEMGSD1", "version": version, "sample_rate_hz": fs,
              "channels": 8, "frames": len(rows), "sequence_gaps": gaps,
              "sequence_backwards": backwards, "sequence_duplicates": duplicates,
              "sequence_wraps": wraps, "sequence_events": events,
              "invalid_action_frames": len(invalid_actions),
              "first_invalid_action_row": invalid_actions[0] if invalid_actions else None,
              "nonzero_reserved_frames": len(invalid_reserved),
              "first_nonzero_reserved_row": invalid_reserved[0] if invalid_reserved else None,
              "frame_fields_valid": not invalid_actions and not invalid_reserved,
              "sequence_direction_limit": "modulo half-range; gaps >=32768 frames are ambiguous",
              "timestamp_alignment": "forward sequence steps; backwards/duplicate advances one row and is flagged",
              "keep_all": True, "hardware_filter_warm_start": True}
    with open(meta, "w", encoding="utf-8") as f:
        json.dump(dict(common, raw_csv=os.path.basename(raw_path),
                       filtered_csv=os.path.basename(notch_path), filtered_signal=filtered_signal), f, indent=2)
    for path, sig in ((raw_path, "raw"), (notch_path, filtered_signal)):
        with open(os.path.splitext(path)[0]+".json", "x", encoding="utf-8") as f:
            json.dump(dict(common, signal=sig, filter=line_filter_metadata(sig),
                           frames_written=len(rows)), f, indent=2)
    return raw_path, notch_path, meta, len(rows), gaps

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("input")
    ap.add_argument("--outdir")
    a = ap.parse_args()
    try:
        paths = decode(a.input, a.outdir)
    except (OSError, ValueError) as e:
        ap.error(str(e))
    print(json.dumps({"raw": paths[0], "filtered": paths[1], "meta": paths[2], "frames": paths[3], "sequence_gaps": paths[4]}))
    with open(paths[2], encoding="utf-8") as f: metadata = json.load(f)
    if not metadata["frame_fields_valid"]:
        import sys
        print("WARNING: invalid action/reserved fields; possible file corruption. "
              "Inspect integrity metadata before training or interpreting sequence gaps.", file=sys.stderr)
if __name__ == "__main__": main()
