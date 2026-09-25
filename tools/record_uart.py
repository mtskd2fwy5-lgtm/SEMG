#!/usr/bin/env python3
"""Record raw 8-ch sEMG from the board's RAWREC UART stream into contract CSV.

Firmware side: sw/ps_uart_print in monitor mode -- send 'r' on the port to
switch the board into record mode (2 Mbaud binary frames).  Pass --enter
and this tool does the two-step itself: it opens the port at 115200, sends
'r', then reopens at 2 Mbaud.  The board then streams binary frames:
  AA 55 | seq u16 LE | 8 x int24 LE (ch0..ch7) = 28 B/frame.

PC side (this tool): opens the port, you label segments interactively,
and on quit writes a NinaPro-contract CSV plus a sidecar JSON:

  data/raw/board/<subject>/S<NN>_E<ss>_A1_baseline.csv
  data/raw/board/<subject>/S<NN>_E<ss>_A1_baseline.json

Interactive commands (type + Enter in this console):
  m     put the board back into monitor mode and quit without writing
  1..5  label from now on: 1=rest 2=open_hand 3=fist 4=wrist_flex
        5=wrist_extend
  0     stop labelling (frames marked "none", dropped from the CSV)
  q     quit and write the CSV

With --plot the recorder opens a pygame rolling-waveform window (8
channel strips + a colour-coded label band, 3 s window) and the same
commands become keyboard keys in that window: 1..5 label, 0 unlabeled,
q save & quit, m back to monitor & quit without writing.  Closing the
window saves (treated like q).  The serial reader and the CSV writer
are identical in both modes.

Each labelled run is trimmed by --trim seconds on both ends (transition
margin).  Usage:

  python tools/record_uart.py --port COM3 --subject s30 --session e2
"""

import argparse
import json
import os
import time

import serial  # pyserial

FS_DEFAULT = 4000
LABELS = ["rest", "open_hand", "fist", "wrist_flex", "wrist_extend"]
SYNC = b"\xAA\x55"
FRAME = 28  # 2 sync + 2 seq + 24 data

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def reader(ser, frames, state):
    """Reader thread: sync, parse frames, append (t_us, vals, label_at)."""
    buf = b""
    seq_prev = None
    dropped = 0
    while not state["quit"]:
        buf += ser.read(4096)
        while True:
            i = buf.find(SYNC)
            if i < 0:
                buf = buf[-1:]
                break
            if len(buf) - i < FRAME:
                buf = buf[i:]
                break
            chunk = buf[i:i + FRAME]
            buf = buf[i + FRAME:]
            seq = chunk[2] | (chunk[3] << 8)
            if seq_prev is not None and ((seq_prev + 1) & 0xFFFF) != seq:
                gap = (seq - seq_prev) & 0xFFFF
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
            frames.append((state["count"] * state["t_us_step"], vals,
                           state["label"]))
            state["count"] += 1


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
    pygame.display.set_caption("sEMG recorder (record mode)")
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
                if pygame.K_1 <= ev.key <= pygame.K_1 + len(LABELS) - 1:
                    state["label"] = LABELS[ev.key - pygame.K_1]
                    print("  label -> %s" % state["label"])
                elif ev.key == pygame.K_0:
                    state["label"] = "none"
                    print("  label -> none")
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
            screen.blit(font.render("ch%d" % c, True, DIM), (4, y0 + 2))
        for i, (lab, _, _) in enumerate(bins):
            col = LAB_COL.get(lab)
            if col:
                pygame.draw.rect(screen, col,
                                 (int(i * step), H - BAND_H,
                                  int(step) + 1, BAND_H))
        screen.blit(font.render(
            "[%ds | %s | drop %d]   1-5 label  0 none  q save  m monitor" %
            (state["count"] // fs, state["label"], state["dropped"]),
            True, TXT), (6, 7))
        pygame.display.flip()
        clock.tick(30)
    state["quit"] = True
    pygame.quit()


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--port", default="COM3")
    ap.add_argument("--baud", type=int, default=2000000)
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
    ap.add_argument("--enter", action="store_true",
                    help="board is in monitor mode: send 'r' at 115200 to "
                         "switch it into record mode, then reopen at --baud")
    ap.add_argument("--plot", action="store_true",
                    help="pygame rolling-waveform window with in-window "
                         "labelling (keys 1..5/0/q/m) instead of console input")
    args = ap.parse_args()

    subj = args.subject.lower()
    fname = "%s_E%s_A1_baseline" % (subj.upper(), args.session)
    outdir = os.path.join(ROOT, "data", "raw", "board", subj)
    os.makedirs(outdir, exist_ok=True)
    csv_path = os.path.join(outdir, fname + ".csv")
    json_path = os.path.join(outdir, fname + ".json")

    frames = []
    state = {"quit": False, "label": "none", "count": 0,
             "t_us_step": 1000000 // args.fs, "dropped": 0}

    if args.enter:
        # 'r' must arrive while the board still runs the 115200 monitor
        # baud rate, so toggle first at 115200, then reopen at 2 Mbaud.
        mon = serial.Serial(args.port, 115200, timeout=0.5)
        mon.write(b"r")
        mon.close()
        time.sleep(0.3)

    ser = serial.Serial(args.port, args.baud, timeout=0.1)
    ser.reset_input_buffer()
    import threading
    th = threading.Thread(target=reader, args=(ser, frames, state), daemon=True)
    th.start()

    print("recording from %s @ %d (fs=%d Hz)" % (args.port, args.baud, args.fs))
    print("commands: m = back to monitor & quit | 1..5 = %s |" %
          "/".join("%d=%s" % (i + 1, l) for i, l in enumerate(LABELS)))
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
                if cmd == "0":
                    state["label"] = "none"
                elif cmd.isdigit() and 1 <= int(cmd) <= len(LABELS):
                    state["label"] = LABELS[int(cmd) - 1]
                elif cmd == "":
                    continue
                else:
                    print("  ? (m, 1..5, 0, q)")
    finally:
        th.join(timeout=2)
        ser.close()

    if state.get("aborted"):
        print("aborted by user - nothing written")
        return 1
    n = len(frames)
    if n == 0:
        print("no frames captured - nothing written")
        return 1

    # trim each contiguous labelled run by --trim on both ends
    trim_n = int(args.trim * args.fs)
    keep = [False] * n
    runs = []
    i = 0
    while i < n:
        j = i
        while j < n and frames[j][2] == frames[i][2]:
            j += 1
        runs.append((frames[i][2], j - i))
        if frames[i][2] != "none":
            a, b = i + trim_n, j - trim_n
            for k in range(max(a, i), max(b, i)):
                keep[k] = True
        i = j

    written = 0
    with open(csv_path, "w", newline="\n") as fh:
        fh.write("timestamp_us," + ",".join("channel_%d" % c for c in range(8))
                 + ",action,subject,session\n")
        for k in range(n):
            if not keep[k]:
                continue
            t, vals, lab = frames[k]
            fh.write("%d,%s,%s,%s,%s\n" % (
                t, ",".join(str(v) for v in vals), lab, subj, args.session))
            written += 1

    meta = {
        "file": os.path.relpath(csv_path, ROOT).replace("\\", "/"),
        "source": "board RAWREC UART stream (RAW_REC_MODE firmware)",
        "sample_rate_hz": args.fs,
        "channels": 8,
        "units": "raw ADC codes, int24 signed",
        "baud": args.baud,
        "frames_captured": n,
        "frames_written": written,
        "frames_dropped_uart": state["dropped"],
        "trim_seconds": args.trim,
        "runs": runs,
    }
    with open(json_path, "w") as fh:
        json.dump(meta, fh, indent=2)

    print("\nruns (label, frames): %s" % runs)
    print("wrote %d/%d frames -> %s" % (written, n,
          os.path.relpath(csv_path, ROOT)))
    print("meta -> %s" % os.path.relpath(json_path, ROOT))
    if state["dropped"]:
        print("WARNING: %d UART frames dropped (reduce load / lower baud)"
              % state["dropped"])
    return 0


if __name__ == "__main__":
    import sys
    sys.exit(main())
