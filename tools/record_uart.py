#!/usr/bin/env python3
"""Record final processed or original 8-ch sEMG into contract CSV.

Firmware side: sw/ps_uart_print in monitor mode -- send 'r' on the port to
switch the board into record mode (2 Mbaud binary frames).  Pass --enter
and this tool selects the source at 115200, sends 'r', then reopens at
2 Mbaud. The board streams one selected source, 28 B/frame:
  AA 58 (processed, default) or AA 55 (raw) | seq u16 LE | 8 x int24 LE.
--signal notch50 aliases processed: notch + comb + signed HP/LP output.
AA 56/57 remain available for historical notch/comb firmware explicitly.
Matching PL and PS firmware are required. Per-frame source
markers are checked; no verified matching frames means no CSV is saved.

PC side (this tool): opens the port, you label segments interactively,
and on quit writes a NinaPro-contract CSV plus a sidecar JSON:

  data/raw/board/<subject>/S<NN>_E<ss>_A1_baseline.csv
  data/raw/board/<subject>/S<NN>_E<ss>_A1_baseline.json

Interactive commands (type + Enter in this console):
  m     put the board back into monitor mode and quit without writing
  1..14 manual action labels; 1..5 keep rest/open/fist/flex/extend
        6..8 thumb/index/middle alone, 9..10 fist+flex/extend,
        11..14 thumb+index/thumb+middle/index+middle/all three
  a..e  single-key aliases for labels 10..14 (also in console)
  0     stop labelling (frames marked "none"; saved with --keep-all)
  q     quit and write the CSV

With --plot the recorder opens a pygame rolling-waveform window (8
channel strips + a colour-coded label band, 3 s window) and the same
commands become keyboard keys in that window: 1..9/a..e label, 0 unlabeled,
q save & quit, m back to monitor & quit without writing.  Closing the
window saves (treated like q).  The serial reader and the CSV writer
are identical in both modes.

By default each labelled run is trimmed by --trim seconds on both ends
and unlabelled samples are dropped. With --keep-all every accepted frame
is saved, including unlabelled samples and transitions, without trimming.
These captures use a separate *_waveform.csv name. Existing recordings
are preserved by adding a timestamp suffix when necessary. Every frame
requires a confirming next header at the 28-byte boundary, so an unconfirmed
terminal tail is withheld. This is not a CRC or a guarantee against all
payload corruption. Usage:

  python tools/record_uart.py --port COM3 --subject s30 --session e2
  python tools/record_uart.py --port COM16 --enter --plot --keep-all
  python tools/record_uart.py --port COM16 --signal raw --plot --keep-all --save-both
"""

import argparse
import json
import os
import time

import serial  # pyserial
from emg_reference import line_filter_metadata
from capture_actions import ACTIONS, KEYS, LABELS, SCHEMA, label_for_command

FS_DEFAULT = 4000
SYNC = b"\xAA\x55"
SIGNAL_SYNC = {"raw": SYNC, "notch50": b"\xAA\x56", "notchcomb": b"\xAA\x57", "processed":b"\xAA\x58"}
SIGNAL_COMMAND = {"raw": b"u", "notch50": b"n", "notchcomb": b"n", "processed":b"n"}
FRAME = 28  # 2 sync + 2 seq + 24 data

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def reader(ser, frames, state):
    """Reader thread: sync, parse frames, append (t_us, vals, label_at)."""
    buf = b""
    seq_prev = None
    sample_index = 0
    dropped = 0
    false_sync = 0
    sync = SIGNAL_SYNC[state.get("signal", "raw")]
    while not state["quit"]:
        buf += ser.read(4096)
        while True:
            i = buf.find(sync)
            if i < 0:
                buf = buf[-1:]
                break
            if len(buf) - i < FRAME:
                buf = buf[i:]
                break
            chunk = buf[i:i + FRAME]
            seq = chunk[2] | (chunk[3] << 8)

            # A correct sequence alone does not prove a complete payload.
            # A missing payload byte shifts the next frame's AA into CH8
            # while this frame still has the expected sequence number.
            # Require the following header at exactly the frame boundary
            # for EVERY candidate. Keep one frame pending between reads.
            if len(buf) - i < FRAME + 4:
                buf = buf[i:]
                break
            if buf[i + FRAME:i + FRAME + 2] != sync:
                state["boundary_rejects"] = state.get("boundary_rejects", 0) + 1
                buf = buf[i + 1:]
                continue

            # The payload is arbitrary binary, so either marker can occur inside
            # a corrupted or misaligned stream.  When the sequence does not
            # continue, require a second aligned frame before accepting this
            # candidate.  Otherwise discard one byte and search again; this
            # prevents a false sync from turning into millions of fake drops.
            if seq_prev is None or seq != ((seq_prev + 1) & 0xFFFF):
                aligned = False
                for step in (FRAME, 2 * FRAME):
                    j = i + step
                    if len(buf) - j >= 4 and buf[j:j + 2] == sync:
                        next_seq = buf[j + 2] | (buf[j + 3] << 8)
                        if next_seq == ((seq + step // FRAME) & 0xFFFF):
                            aligned = True
                            break
                if not aligned:
                    # Serial reads may split a frame/header anywhere. Wait
                    # for both lookahead positions before rejecting it.
                    if len(buf) - i < 2 * FRAME + 4:
                        buf = buf[i:]
                        break
                    buf = buf[i + 1:]
                    false_sync += 1
                    state["false_sync"] = false_sync
                    continue

            buf = buf[i + FRAME:]
            if seq_prev is not None:
                gap = (seq - seq_prev) & 0xFFFF
                if gap == 0:
                    # A duplicate must not look like 65535 missing frames.
                    state["duplicates"] = state.get("duplicates", 0) + 1
                    continue
                if gap >= 0x8000:
                    state["backwards"] = state.get("backwards", 0) + 1
                    sample_index += 1
                else:
                    sample_index += gap
                    dropped += gap - 1
                state["dropped"] = dropped
            seq_prev = seq
            vals = []
            for c in range(8):
                b = chunk[4 + 3 * c:7 + 3 * c]
                v = b[0] | (b[1] << 8) | (b[2] << 16)
                if v & 0x800000:
                    v -= 1 << 24
                vals.append(v)
            # Keep sequence gaps in time instead of compressing lost samples.
            frames.append((sample_index * 1000000 // state["fs"], vals,
                           state["label"]))
            state["count"] += 1
    # The tail has no confirming next header. Do not pass it off as verified.
    state["unconfirmed_tail_bytes"] = len(buf)


def plot_loop(ser, frames, state, fs):
    """pygame rolling waveform (--plot): 8 channel strips + label band.

    Display-only path: the reader thread and the CSV writer are shared
    with console mode.  Per channel the raw int24 stream carries a large
    electrode DC offset, so each strip shows (value - slow EMA) instead
    of the absolute code, auto-scaled with a slow decay.
    """
    import pygame
    from collections import deque

    pygame.init()
    W, H = 960, 620
    screen = pygame.display.set_mode((W, H))
    pygame.display.set_caption("sEMG recorder (%s)" % state.get("signal", "raw"))
    clock = pygame.time.Clock()
    # pygame.font.SysFont crashes on 2.6.1/Windows (registry enum bug):
    # load the font file directly.
    try:
        font = pygame.font.Font(r"C:\Windows\Fonts\msyh.ttc", 13)
    except Exception:
        font = pygame.font.Font(None, 16)

    BG = (18, 20, 22)
    GRID = (46, 50, 54)
    TXT = (225, 228, 226)
    DIM = (112, 120, 116)
    CH_COL = [(96, 170, 255), (255, 170, 80), (120, 220, 140), (255, 120, 120),
              (190, 140, 255), (90, 210, 210), (240, 220, 110), (255, 140, 200)]
    LAB_COL = {"rest": (108, 116, 112), "open_hand": (66, 128, 238),
               "fist": (226, 88, 60), "wrist_flex": (235, 178, 46),
               "wrist_extend": (92, 198, 122)}
    import colorsys
    for i, lab in enumerate(LABELS[5:]):
        LAB_COL[lab] = tuple(int(c*255) for c in colorsys.hsv_to_rgb(i/9, .55, .9))

    D = max(1, fs // 100)                  # ~100 display samples/s
    n_bins = max(60, int(3.0 * fs / D))    # ~3 s rolling window
    bins = deque(maxlen=n_bins)            # (label, min[8], max[8])
    consumed = 0
    cur_bin = -1
    b_min, b_max = [0] * 8, [0] * 8
    b_label = "none"
    scale = [1.0] * 8
    dc = None                              # per-channel slow EMA baseline

    STATUS_H, BAND_H = 30, 20
    strip_h = (H - STATUS_H - BAND_H) // 8

    running = True
    while running:
        for ev in pygame.event.get():
            if ev.type == pygame.QUIT:
                running = False                       # window X = save
            elif ev.type == pygame.KEYDOWN:
                selected = label_for_command(ev.unicode)
                if selected is not None:
                    state["label"] = selected
                    print("  label -> %s" % state["label"])
                elif ev.key in (pygame.K_q, pygame.K_ESCAPE):
                    running = False
                elif ev.key == pygame.K_m:
                    ser.write(b"r")
                    print("  -> sent 'r': board switched to monitor mode")
                    state["aborted"] = True           # no CSV on 'm'
                    running = False

        # decimate new frames into display bins (min/max per channel)
        n = len(frames)
        for fr in frames[consumed:n]:
            if dc is None:
                dc = list(fr[1])
            b = consumed // D
            if b != cur_bin:
                if cur_bin >= 0:
                    bins.append((b_label, tuple(b_min), tuple(b_max)))
                cur_bin = b
                b_min = [1 << 62] * 8
                b_max = [-(1 << 62)] * 8
            vals = fr[1]
            for c in range(8):
                v = vals[c]
                dc[c] += (v - dc[c]) >> 12            # tau ~ 1 s at 4 kSPS
                w = v - dc[c]
                if w < b_min[c]:
                    b_min[c] = w
                if w > b_max[c]:
                    b_max[c] = w
            b_label = fr[2]
            consumed += 1

        # per-channel auto scale, slow decay so quiet spans stay readable
        for _, mins, maxs in bins:
            for c in range(8):
                m = max(-mins[c], maxs[c])
                if m > scale[c]:
                    scale[c] = m
        for c in range(8):
            scale[c] = max(scale[c] * 0.98, 1.0)

        step = W / float(n_bins - 1) if n_bins > 1 else float(W)
        screen.fill(BG)
        for c in range(8):
            y0 = STATUS_H + c * strip_h
            cy = y0 + strip_h // 2
            half = strip_h // 2 - 2
            pygame.draw.line(screen, GRID, (0, cy), (W, cy))
            col = CH_COL[c]
            for i, (_, mins, maxs) in enumerate(bins):
                off1 = int(maxs[c] / scale[c] * half)
                off2 = int(mins[c] / scale[c] * half)
                y1 = cy - max(-half, min(half, off1))
                y2 = cy - max(-half, min(half, off2))
                if y1 == y2:
                    y2 += 1
                pygame.draw.line(screen, col, (int(i * step), y1),
                                 (int(i * step), y2))
            screen.blit(font.render("CH%d (ch%d)" % (c + 1, c), True, DIM), (4, y0 + 2))
        for i, (lab, _, _) in enumerate(bins):
            col = LAB_COL.get(lab)
            if col:
                pygame.draw.rect(screen, col,
                                 (int(i * step), H - BAND_H,
                                  int(step) + 1, BAND_H))
        screen.blit(font.render(
            "[%ds | %s | drop %d | bad %d]  1-9/A-E labels  0 clear  Q save  M discard" %
            (state["count"] // fs, state["label"], state["dropped"],
             state.get("boundary_rejects", 0)),
            True, TXT), (6, 7))
        pygame.display.flip()
        clock.tick(30)
    state["quit"] = True
    pygame.quit()


def capture_paths(subject, session, keep_all):
    """Choose a non-overwriting capture name before opening the serial port."""
    session_tag = session[1:] if session[:1].lower() == "e" else session
    suffix = "waveform" if keep_all else "baseline"
    stem = "%s_E%s_A1_%s" % (subject.upper(), session_tag, suffix)
    outdir = os.path.join(ROOT, "data", "raw", "board", subject)
    os.makedirs(outdir, exist_ok=True)
    candidate = stem
    serial_no = 0
    while any(os.path.exists(os.path.join(outdir, candidate + ext))
              for ext in (".csv", ".json")):
        serial_no += 1
        candidate = "%s_%s_%d" % (stem, time.strftime("%Y%m%d_%H%M%S"), serial_no)
    return tuple(os.path.join(outdir, candidate + ext) for ext in (".csv", ".json"))


def select_frames(frames, trim_n, keep_all=False):
    """Return save mask and label runs; complete captures ignore trimming."""
    n = len(frames)
    keep = [bool(keep_all)] * n
    runs = []
    i = 0
    while i < n:
        j = i + 1
        while j < n and frames[j][2] == frames[i][2]:
            j += 1
        runs.append((frames[i][2], j - i))
        if not keep_all and frames[i][2] != "none":
            for k in range(i + trim_n, j - trim_n):
                keep[k] = True
        i = j
    return keep, runs


def save_capture(frames, state, args, csv_path, json_path):
    """Write selected PL sample codes; display removal never touches these."""
    keep, runs = select_frames(frames, int(args.trim * args.fs), args.keep_all)
    written = 0
    with open(csv_path, "x", newline="\n") as fh:
        fh.write("timestamp_us," + ",".join("channel_%d" % c for c in range(8))
                 + ",action,subject,session\n")
        for save, (t, vals, lab) in zip(keep, frames):
            if save:
                fh.write("%d,%s,%s,%s,%s\n" % (
                    t, ",".join(str(v) for v in vals), lab,
                    args.subject.lower(), args.session))
                written += 1
    meta = {
        "file": os.path.relpath(csv_path, ROOT).replace("\\", "/"),
        "source": "board %s UART stream" % state.get("signal", "raw"),
        "signal": state.get("signal", "raw"),
        "filter": line_filter_metadata(state.get("signal", "raw")),
        "wire_sync_hex": SIGNAL_SYNC[state.get("signal", "raw")].hex(),
        "sample_rate_hz": args.fs,
        "channels": 8,
        "units": "ADC counts, int24 signed (%s)" % state.get("signal", "raw"),
        "baud": args.baud,
        "frames_captured": len(frames),
        "frames_written": written,
        "frames_dropped_uart": state["dropped"],
        "frames_backward_uart": state.get("backwards", 0),
        "frames_duplicate_uart": state.get("duplicates", 0),
        "false_sync_candidates": state["false_sync"],
        "boundary_rejects": state.get("boundary_rejects", 0),
        "unconfirmed_tail_bytes": state.get("unconfirmed_tail_bytes", 0),
        "parser_version": 3,
        "frame_validation": "next header must occur at byte 28; sequence checked during resync; no CRC in wire format",
        "duplicate_frames": state.get("duplicates", 0),
        "keep_all": args.keep_all,
        "trim_seconds": 0.0 if args.keep_all else args.trim,
        "timestamp_source": "unwrapped uint16 frame sequence, relative to first accepted frame",
        "runs": runs,
        "action_schema": SCHEMA,
        "manual_action_labels": {str(i): a[1] for i,a in enumerate(ACTIONS)},
    }
    with open(json_path, "x") as fh:
        json.dump(meta, fh, indent=2)
    return written, runs


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--port", default="COM3")
    ap.add_argument("--baud", type=int, default=2000000)
    ap.add_argument("--signal", choices=["notch50", "processed", "notchcomb", "legacy-notch50", "raw"], default="notch50",
                    help="notch50/processed: current final signed waveform; legacy-notch50: older pure notch firmware")
    ap.add_argument("--fs", type=int, default=FS_DEFAULT,
                    help="board sample rate in Hz (frames per second)")
    ap.add_argument("--subject", default="s30",
                    help="subject code, e.g. s30 (kept separate from "
                         "NinaPro s1..s10)")
    ap.add_argument("--session", default="e2",
                    help="session tag used in the file name (e2/e3/...); "
                         "record several runs as e2, e3, ... and pass "
                         "--sessions 2 3 to train_baseline.py")
    ap.add_argument("--trim", type=float, default=0.5,
                    help="seconds dropped at each labelled run boundary")
    ap.add_argument("--keep-all", action="store_true",
                    help="save all accepted samples, including unlabelled data "
                         "and transitions; ignore --trim; use *_waveform.csv")
    ap.add_argument("--save-both", action="store_true",
                    help="with --signal raw, also write a timestamp-aligned "
                         "processed companion using the exact PL reference")
    ap.add_argument("--enter", action="store_true",
                    help="board is in monitor mode: send 'r' at 115200 to "
                         "switch it into record mode, then reopen at --baud")
    ap.add_argument("--plot", action="store_true",
                    help="pygame rolling-waveform window with in-window "
                         "labelling (keys 1..9/a..e/0/q/m) instead of console input")
    args = ap.parse_args()
    args.signal = {"notch50":"processed", "legacy-notch50":"notch50"}.get(args.signal, args.signal)
    if args.fs <= 0 or args.trim < 0:
        ap.error("--fs must be positive and --trim must be nonnegative")
    if args.signal != "raw" and args.fs != 4000:
        ap.error("the PL notch50 coefficients require --fs 4000")
    if args.save_both and args.signal != "raw":
        ap.error("--save-both requires --signal raw")
    if args.save_both and args.fs != 4000:
        ap.error("--save-both requires --fs 4000 for the PL notch50 coefficients")

    subj = args.subject.lower()
    csv_path, json_path = capture_paths(subj, args.session, args.keep_all)

    frames = []
    state = {"quit": False, "label": "none", "count": 0,
             "fs": args.fs, "dropped": 0,
             "false_sync": 0, "signal": args.signal}

    if args.enter:
        # 'r' must arrive while the board still runs the 115200 monitor
        # baud rate, so toggle first at 115200, then reopen at 2 Mbaud.
        mon = serial.Serial(args.port, 115200, timeout=0.5)
        mon.write(SIGNAL_COMMAND[args.signal] + b"r")
        mon.flush()
        mon.close()
        time.sleep(0.3)

    ser = serial.Serial(args.port, args.baud, timeout=0.1)
    ser.reset_input_buffer()
    ser.write(SIGNAL_COMMAND[args.signal])
    ser.flush()
    import threading
    th = threading.Thread(target=reader, args=(ser, frames, state), daemon=True)
    th.start()
    # The marker is emitted only from the matching PL packet type. A stale
    # bitstream/firmware cannot silently turn raw data into 'filtered' CSV.
    deadline = time.monotonic() + 3.0
    while state["count"] == 0 and time.monotonic() < deadline:
        time.sleep(0.02)
    if state["count"] == 0:
        state["quit"] = True
        th.join(timeout=1.0)
        ser.close()
        ap.exit(1, "No verified %s frames in 3 s. Check matching PL/firmware, baud and mode; no CSV written.\n" % args.signal)

    print("recording verified %s from %s @ %d (fs=%d Hz)" %
          (args.signal, args.port, args.baud, args.fs))
    print("save target: %s" % csv_path)
    print("retention: %s" % ("ALL accepted samples (no trimming)" if args.keep_all
                              else "labelled samples only, trimmed at boundaries"))
    print("manual action labels (number in console, shortcut key in plot):")
    for i, label in enumerate(LABELS):
        print("  %2d / %s = %s" % (i+1, KEYS[i], label))
    print("commands: m = DISCARD & return to monitor")
    print("          0 = unlabeled | q = quit & write")
    use_plot = args.plot
    if use_plot:
        try:
            import pygame  # noqa: F401  (display lib check)
        except ImportError:
            print("pygame not installed: pip install pygame - console mode")
            use_plot = False
    try:
        if use_plot:
            plot_loop(ser, frames, state, args.fs)
        else:
            while True:
                cmd = input("[%ds | %s] > " % (
                    state["count"] // args.fs, state["label"])).strip().lower()
                if cmd == "q":
                    state["quit"] = True
                    break
                if cmd == "m":
                    state["quit"] = True
                    state["aborted"] = True
                    ser.write(b"r")    # board toggles back to monitor mode
                    print("  -> sent 'r': board switched to monitor mode (115200)")
                    break
                selected = label_for_command(cmd)
                if selected is not None:
                    state["label"] = selected
                elif cmd == "":
                    continue
                else:
                    print("  ? (m, 1..14 / a..e, 0, q)")
    finally:
        state["quit"] = True
        th.join(timeout=2)
        ser.close()

    if state.get("aborted"):
        print("aborted by user - nothing written")
        return 1
    n = len(frames)
    if n == 0:
        print("no frames captured - nothing written")
        return 1

    written, runs = save_capture(frames, state, args, csv_path, json_path)

    if args.save_both:
        from derive_notch50 import derive_capture
        notch_rows, notch_resets, notch_csv, notch_json = derive_capture(
            csv_path, input_meta=json_path, expected_fs=args.fs, signal="processed")
        print("wrote synchronized processed companion: %d/%d frames -> %s" %
              (notch_rows, written, os.path.relpath(notch_csv, ROOT)))
        print("processed meta -> %s" % os.path.relpath(notch_json, ROOT))
        if notch_resets:
            print("WARNING: processed state reset at %d timestamp gap(s); "
                 "missing UART samples cannot be reconstructed" % notch_resets)

    print("\nruns (label, frames): %s" % runs)
    print("wrote %d/%d frames -> %s" % (written, n,
          os.path.relpath(csv_path, ROOT)))
    print("meta -> %s" % os.path.relpath(json_path, ROOT))
    if state["dropped"]:
        print("WARNING: %d missing frame sequences (check link / reduce PC load)"
              % state["dropped"])
    print("rejected boundary candidates: %d; unconfirmed tail: %d bytes" %
          (state.get("boundary_rejects", 0), state.get("unconfirmed_tail_bytes", 0)))
    print("board remains in record mode; omit --enter on the next capture")
    return 0


if __name__ == "__main__":
    import sys
    sys.exit(main())
