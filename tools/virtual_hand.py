#!/usr/bin/env python3
"""PC-side virtual hand driven by the board's UART text rows (pygame).

Reads the monitor stream of sw/ps_uart_print (115200-8N1) and animates a
2-D hand according to the PL INT8 MLP decisions:

  R s=<seq> c=<class> p=<conf>[ g=1]   -> pose + confidence
      c: 0=rest 1=open 2=fist 3=wrist flex 4=wrist extend
      p: indicative confidence 0..100; below --conf the hand falls back
         to rest.  g=1 means the PS rest-gate re-classified the window.
  T s=.. lv=<0..2> ..                  -> fatigue state (NORM/MILD/FATIG)
      lv=1 tints the wrist band yellow, lv=2 red.
  [CAL] ...                            -> shows the calibration status

Every 15 animation parameters (wrist angle, per-finger spread/MCP/PIP,
thumb angle) are linearly interpolated over ~350 ms, so the hand glides
between poses instead of snapping.  If no R row arrives for 1.5 s the
hand relaxes back to rest.

Usage:
  python tools/virtual_hand.py --port COM3
  python tools/virtual_hand.py --demo      (no board needed, cycles poses)

Requires: pygame (pip install pygame), pyserial for live mode.
"""

import argparse
import os
import sys
import time

try:
    import pygame
except ImportError:
    print("pygame not installed: pip install pygame")
    sys.exit(1)

# ---- Class / fatigue labels -------------------------------------------------

CLS_CN = ["放松", "张手", "握拳", "屈腕", "伸腕"]
CLS_EN = ["rest", "open", "fist", "wrist flex", "wrist extend"]
FAT_CN = ["正常", "轻度疲劳", "疲劳"]
FAT_EN = ["NORM", "MILD", "FATIG"]

# ---- Pose parameter tables ---------------------------------------------------
# Vector layout (15 floats):
#   [0]      wrist rotation (deg, + = flexed/clockwise on screen)
#   [1:5]    finger spread (deg, index..pinky; - = lean left)
#   [5:9]    MCP bend   (deg, 0 = straight up, ~90 = folded over palm)
#   [9:13]   PIP bend   (deg, added on top of MCP)
#   [13]     thumb absolute direction from vertical (deg, - = out to left)
#   [14]     thumb PIP bend (deg)
POSES = {
    #        wrist  spread            MCP              PIP               thumb
    "rest":  [0,     -7, -3, 3, 7,     7, 6, 6, 8,      12, 10, 11, 15,   -35, 15],
    "open":  [0,     -18, -7, 7, 18,   2, 2, 2, 3,      4, 3, 3, 6,       -58, 6],
    "fist":  [0,     -2, -1, 1, 2,     88, 90, 90, 92,  95, 100, 100, 105, 118, 48],
    "flex":  [34,    -6, -3, 3, 6,     16, 14, 14, 18,  20, 17, 18, 24,   -30, 22],
    "ext":   [-34,   -7, -3, 3, 7,     6, 5, 5, 7,      10, 9, 9, 13,     -35, 15],
}

# class index -> pose key (c: 0=rest 1=open 2=fist 3=wrist flex 4=extend)
POSE_NAMES = ["rest", "open", "fist", "flex", "ext"]

# Geometry (unrotated local frame; origin = wrist pivot at bottom center)
PALM = (-72, -152, 72, -8)                 # left, top, right, bottom
FINGER_X = [-52, -19, 13, 46]              # MCP x offsets from palm center
FINGER_L1 = [40, 46, 43, 34]               # proximal segment lengths
FINGER_L2 = [36, 40, 38, 28]               # distal segment lengths
FINGER_SIGN = [1, 1, -1, -1]               # curl direction toward palm center
THUMB_AT = (-66, -118)                     # attachment point
THUMB_L1, THUMB_L2 = 44, 34
SMOOTH_S = 0.35                            # pose interpolation time (s)
STALE_S = 1.5                              # no R row -> relax to rest

COL = {
    "bg": (22, 27, 36),
    "skin": (217, 160, 102),
    "skin_mid": (198, 139, 86),            # fingers, reads against the palm
    "skin_dark": (122, 82, 48),
    "joint": (181, 127, 69),
    "arm": (58, 67, 86),
    "band": (74, 85, 104),
    "band_mild": (224, 195, 65),
    "band_fatig": (224, 85, 85),
    "text": (235, 240, 248),
    "muted": (140, 150, 165),
    "gate": (120, 200, 120),
}


def lerp(a, b, k):
    return a + (b - a) * k


class HandState:
    """Interpolates between pose vectors and holds the parsed UART state."""

    def __init__(self):
        self.cur = list(POSES["rest"])
        self.frm = list(POSES["rest"])
        self.to = list(POSES["rest"])
        self.t0 = 0.0
        self.cls = 0
        self.conf = 0
        self.fat = 0
        self.gated = False
        self.cal_state = "wait"            # wait / running / ready
        self.last_r = 0.0

    def set_pose(self, name, now):
        target = POSES[name]
        if target == self.to:
            return
        self.frm = list(self.cur)
        self.to = list(target)
        self.t0 = now

    def step(self, now):
        k = min(1.0, (now - self.t0) / SMOOTH_S)
        self.cur = [lerp(f, t, k) for f, t in zip(self.frm, self.to)]


def handle_line(line, st, now, conf_min, log):
    """Parse one UART line; mutates st.  Returns True on state change."""
    line = line.strip()
    if not line:
        return False
    if line.startswith("[CAL]"):
        if "ready" in line or "baseline" in line:
            st.cal_state = "ready"
        else:
            st.cal_state = "running"
        return True
    if not line.startswith("R "):
        return False                        # F/T handled below, banner ignored
    try:
        f = {}
        for tok in line.split()[1:]:
            if "=" in tok:
                k, v = tok.split("=", 1)
                f[k] = v
        c = int(f.get("c", "0"))
        p = int(f.get("p", "0"))
        g = f.get("g", "0") == "1"
    except ValueError:
        return False
    st.cls, st.conf, st.gated = c, p, g
    st.last_r = now
    changed = False
    if g and log["gated"] is not True:
        print("[%08.2f] rest-gate caught a misfire (was c=%d)" % (now, c))
        log["gated"] = True
    elif not g:
        log["gated"] = False
    if g or p < conf_min:
        c = 0                               # low confidence / gated -> rest
    if c != log["cls"]:
        log["cls"] = c
        changed = True
        names = CLS_CN if log["cn"] else CLS_EN
        print("[%08.2f] pose -> %s (p=%d%s)" % (now, names[c], p,
                                                ", gated" if g else ""))
    st.set_pose(POSE_NAMES[min(c, 4)], now)
    return changed


def handle_fatigue(line, st, now, log):
    try:
        for tok in line.split()[1:]:
            if tok.startswith("lv="):
                lv = int(tok[3:])
                break
        else:
            return False
    except ValueError:
        return False
    st.fat = min(lv, 2)
    if lv != log["fat"]:
        log["fat"] = lv
        names = FAT_CN if log["cn"] else FAT_EN
        print("[%08.2f] fatigue -> %s" % (now, names[min(lv, 2)]))
        return True
    return False


def rot(points, pivot, deg):
    import math
    rad = math.radians(deg)
    cs, sn = math.cos(rad), math.sin(rad)
    px, py = pivot
    out = []
    for x, y in points:
        dx, dy = x, y                       # pivot == local origin, no offset
        out.append((px + dx * cs - dy * sn, py + dx * sn + dy * cs))
    return out


def seg(screen, p0, p1, width, fill, outline):
    pygame.draw.line(screen, outline, p0, p1, width + 6)
    pygame.draw.line(screen, fill, p0, p1, width)
    for p in (p0, p1):
        pygame.draw.circle(screen, fill, p, width // 2)


def draw_hand(screen, st):
    import math
    w, h = screen.get_size()
    pivot = (w // 2, h - 130)
    cur = st.cur
    wrist = cur[0]

    # forearm + fatigue band (fixed, below the rotating hand)
    pygame.draw.line(screen, COL["arm"], (pivot[0], pivot[1] + 118),
                     (pivot[0], pivot[1] - 6), 52)
    band = COL["band"]
    if st.fat == 1:
        band = COL["band_mild"]
    elif st.fat == 2:
        band = COL["band_fatig"]
    pygame.draw.rect(screen, band, (pivot[0] - 30, pivot[1] + 8, 60, 34),
                     border_radius=10)

    # palm (rotated polygon)
    pl, pt, pr, pb = PALM
    corners = [(pl, pt), (pr, pt), (pr, pb), (pl, pb)]
    palm = rot(corners, pivot, wrist)
    pygame.draw.polygon(screen, COL["skin_dark"], palm)
    pygame.draw.polygon(screen, COL["skin"],
                        [(p[0], p[1] - 2) for p in palm])

    def direction(angle_deg):
        rad = math.radians(angle_deg)
        return math.sin(rad), -math.cos(rad)

    # fingers: two segments per finger, angles from vertical
    for i in range(4):
        a1 = cur[1 + i] + FINGER_SIGN[i] * cur[5 + i]
        a2 = a1 + FINGER_SIGN[i] * cur[9 + i]
        base = (FINGER_X[i], pt + 6)
        d1 = direction(a1)
        d2 = direction(a2)
        j1 = (base[0] + d1[0] * FINGER_L1[i], base[1] + d1[1] * FINGER_L1[i])
        j2 = (j1[0] + d2[0] * FINGER_L2[i], j1[1] + d2[1] * FINGER_L2[i])
        pts = rot([base, j1, j2], pivot, wrist)
        seg(screen, pts[0], pts[1], 24, COL["skin_mid"], COL["skin_dark"])
        seg(screen, pts[1], pts[2], 19, COL["skin_mid"], COL["skin_dark"])
        pygame.draw.circle(screen, COL["joint"], pts[1], 5)

    # thumb
    ta1 = cur[13]
    ta2 = ta1 + cur[14]
    at = THUMB_AT
    d1 = direction(ta1)
    d2 = direction(ta2)
    tj1 = (at[0] + d1[0] * THUMB_L1, at[1] + d1[1] * THUMB_L1)
    tj2 = (tj1[0] + d2[0] * THUMB_L2, tj1[1] + d2[1] * THUMB_L2)
    pts = rot([at, tj1, tj2], pivot, wrist)
    seg(screen, pts[0], pts[1], 26, COL["skin_mid"], COL["skin_dark"])
    seg(screen, pts[1], pts[2], 21, COL["skin_mid"], COL["skin_dark"])
    pygame.draw.circle(screen, COL["joint"], pts[1], 5)


def draw_status(screen, st, fonts):
    big, small, cn_ok = fonts
    cn = CLS_CN if cn_ok else CLS_EN
    fat = FAT_CN if cn_ok else FAT_EN
    label = "%s %d%%" % (cn[st.cls], st.conf)
    if st.gated:
        label += "  [gate]"
    screen.blit(big.render(label, True, COL["text"]), (18, 14))
    cal = {"wait": "cal: waiting", "running": "cal: running...",
           "ready": "cal: ready"}[st.cal_state]
    line2 = "fatigue: %s   %s" % (fat[st.fat], cal)
    color = COL["muted"]
    if st.fat == 1:
        color = COL["band_mild"]
    elif st.fat == 2:
        color = COL["band_fatig"]
    screen.blit(small.render(line2, True, color), (18, 52))


def make_fonts():
    # pygame.font.SysFont crashes on some Windows registry states (font
    # entries with non-string values), so load font files directly.
    for path in (r"C:\Windows\Fonts\msyh.ttc",     # Microsoft YaHei
                 r"C:\Windows\Fonts\simhei.ttf",   # SimHei
                 r"C:\Windows\Fonts\simsun.ttc"):  # SimSun
        if os.path.exists(path):
            try:
                f = pygame.font.Font(path, 30)
                if f.metrics("放") and f.metrics("放")[0]:
                    return f, pygame.font.Font(path, 19), True
            except Exception:
                continue
    return pygame.font.Font(None, 32), pygame.font.Font(None, 22), False


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--port", default="COM3", help="serial port (default COM3)")
    ap.add_argument("--baud", type=int, default=115200)
    ap.add_argument("--conf", type=int, default=30,
                    help="confidence below this falls back to rest (0..100)")
    ap.add_argument("--demo", action="store_true",
                    help="no board: cycle poses automatically")
    args = ap.parse_args()

    ser = None
    if not args.demo:
        try:
            import serial
        except ImportError:
            print("pyserial not installed: pip install pyserial")
            return 1
        ser = serial.Serial(args.port, args.baud, timeout=0)

    pygame.init()
    screen = pygame.display.set_mode((480, 640))
    pygame.display.set_caption("sEMG virtual hand")
    big, small, has_cn = make_fonts()
    clock = pygame.time.Clock()
    st = HandState()
    log = {"cls": -1, "fat": -1, "gated": False, "cn": has_cn}
    buf = b""
    demo_seq = ["rest", "open", "fist", "wrist_flex", "wrist_ext"]
    demo_i, demo_t = 0, time.time()
    print("virtual hand: %s" % ("demo mode" if args.demo
                                else "%s @ %d" % (args.port, args.baud)))

    running = True
    while running:
        now = time.time()
        for ev in pygame.event.get():
            if ev.type == pygame.QUIT or (ev.type == pygame.KEYDOWN
                                          and ev.key == pygame.K_ESCAPE):
                running = False

        if args.demo:
            if now - demo_t > 1.8:
                demo_t = now
                demo_i = (demo_i + 1) % len(demo_seq)
            st.cls = demo_i
            st.conf = 87
            st.set_pose(demo_seq[demo_i], now)
        else:
            if ser.in_waiting:
                buf += ser.read(ser.in_waiting)
            while b"\n" in buf:
                raw, buf = buf.split(b"\n", 1)
                line = raw.decode("ascii", "replace").strip()
                if line.startswith("T "):
                    handle_fatigue(line, st, now, log)
                else:
                    handle_line(line, st, now, args.conf, log)
            if st.last_r and now - st.last_r > STALE_S \
                    and st.cls != 0:
                st.cls = 0
                st.set_pose("rest", now)
                print("[%08.2f] no R rows, relaxing" % now)

        st.step(now)
        screen.fill(COL["bg"])
        draw_hand(screen, st)
        draw_status(screen, st, (big, small, has_cn))
        fat_en = FAT_EN[st.fat]
        pygame.display.set_caption("sEMG virtual hand | %s %d%% | fatigue %s"
                                   % (CLS_EN[st.cls], st.conf, fat_en))
        pygame.display.flip()
        clock.tick(60)

    if ser:
        ser.close()
    pygame.quit()
    return 0


if __name__ == "__main__":
    sys.exit(main())
