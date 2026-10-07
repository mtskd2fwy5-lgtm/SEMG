#!/usr/bin/env python3
"""PC-side low-poly 3D hand driven by the board's UART text rows (pygame).

Reads the monitor stream of sw/ps_uart_print (115200-8N1) and animates a
3-D low-poly hand according to the PL INT8 MLP decisions:

  R s=<seq> c=<class> p=<conf>[ g=1]   -> pose + confidence
      c: 0=rest 1=open 2=fist 3=wrist flex 4=wrist extend
      p: indicative confidence 0..100; below --conf the hand falls back
         to rest.  g=1 means the PS rest-gate re-classified the window.
  T s=.. lv=<0..3> ..                  -> fatigue state (NORM/MILD/FATIG/LEVEL3)
      lv=1 tints the wrist band yellow, lv>=2 red.
  [CAL] ...                            -> shows the calibration status

The canonical 22-DOF hand pose (with legacy 15-parameter input support) is
linearly interpolated over the shared 220 ms transition time, so the hand glides
between poses instead of snapping.  If no R row arrives for 1.5 s the
hand relaxes back to rest.

Usage:
  python tools/virtual_hand.py --port COM3
  python tools/virtual_hand.py --demo      (no board needed, cycles poses)

Preview controls: left-drag to orbit, right-drag to pan, wheel to zoom, R to reset.

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

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from pose_contract import (POSE_CONFIRM_WINDOWS, POSE_FIELDS_V2, POSE_MIN_CONF,
                           POSE_NAMES, POSE_SCHEMA_V2, POSE_SMOOTH_MS,
                           POSE_STALE_MS, POSES_V2, sanitize_pose22)

# ---- Class / fatigue labels -------------------------------------------------

CLS_CN = ["放松", "张手", "握拳", "屈腕", "伸腕"]
CLS_EN = ["rest", "open", "fist", "wrist flex", "wrist extend"]
FAT_CN = ["正常", "轻度疲劳", "疲劳", "等级3"]
FAT_EN = ["NORM", "MILD", "FATIG", "LEVEL3"]

# PoseFrame v1 is the stable renderer contract.  Model class ids are only a
# fallback; new models should be adapted to this vector before rendering.
POSE_FIELDS = ("w", "s0", "s1", "s2", "s3", "m0", "m1", "m2", "m3",
               "p0", "p1", "p2", "p3", "ta", "ti")
POSE_SCHEMA_V1 = 1

# ---- Pose parameter tables ---------------------------------------------------
# Legacy PoseFrame v1 vector layout (15 floats):
#   [0]      wrist rotation (deg, + = flexed/clockwise on screen)
#   [1:5]    finger spread (deg, index..pinky; - = lean left)
#   [5:9]    MCP flex   (deg, bends out of the palm plane along world y)
#   [9:13]   PIP flex   (deg, added to the palm-normal bend)
#   [13]     thumb absolute direction from vertical (deg, - = out to left)
#   [14]     thumb PIP bend (deg)
POSES = {
    #        wrist  spread            MCP              PIP               thumb
    "rest":  [0,     -7, -3, 3, 7,     7, 6, 6, 8,      12, 10, 11, 15,   -35, 15],
    "open":  [0,     -18, -7, 7, 18,   2, 2, 2, 3,      4, 3, 3, 6,       -58, 6],
    "fist":  [0,     -4, -2, 2, 5,     74, 76, 79, 82, 78, 75, 72, 68, 36, 78],
    "flex":  [34,    -6, -3, 3, 6,     16, 14, 14, 18,  20, 17, 18, 24,   -30, 22],
    "ext":   [-34,   -7, -3, 3, 7,     6, 5, 5, 7,      10, 9, 9, 13,     -35, 15],
}

# The mesh template is stored as (x, arm-to-fingertip, palm-normal), then mapped
# to the display world as (x, palm-normal=y, arm-to-fingertip=z).
# Palm body is about 100 units long and 132 units wide; the four proximal
# finger diameters together are about 115 units, so the proportions stay close
# to an adult hand instead of a wide short block.
PALM_W, PALM_H, PALM_D = 132.0, 100.0, 30.0
PALM_OUTLINE = [
    (-36, 0), (-48, 8), (-56, 28), (-62, 56), (-66, 82), (-63, 96),
    (-55, 101), (-45, 96), (-36, 92), (-26, 96), (-17, 100),
    (-8, 95), (0, 91), (8, 95), (17, 100), (26, 96), (36, 92),
    (45, 96), (55, 101), (63, 96), (66, 82), (62, 56), (56, 28),
    (48, 8), (36, 0),
]
FINGER_X = [-43.0, -14.0, 15.0, 43.0]
FINGER_BASE_Y = [94.0, 100.0, 98.0, 90.0]
# Root end caps sit inside the palm; proximal radii produce a 29-31 unit width,
# matching the 30 unit palm thickness.
FINGER_BASE_DEPTH = [-8.0, -8.0, -8.0, -8.0]
FINGER_L1 = [43.0, 48.0, 45.0, 37.0]       # proximal phalanx
FINGER_L2 = [31.0, 34.0, 32.0, 26.0]       # middle phalanx
FINGER_L3 = [22.0, 25.0, 23.0, 19.0]       # distal phalanx
FINGER_RADII = [(14.8, 12.0, 9.6), (15.5, 12.6, 10.0),
                (14.4, 11.8, 9.5), (12.7, 10.2, 8.2)]
FINGER_DIP_RATIO = 0.42
THUMB_AT = (-46.0, 26.0, -4.0)
# Metacarpal stays buried inside the palm volume; only the proximal and
# distal phalanges emerge past the thenar edge (two visible segments).
THUMB_META, THUMB_L1, THUMB_L2 = 26.0, 32.0, 24.0
SMOOTH_S = POSE_SMOOTH_MS / 1000.0         # portable pose transition time
STALE_S = POSE_STALE_MS / 1000.0           # no R row -> relax to rest

VIEW_DEFAULT = {"yaw": 0.0, "pitch": 34.0, "zoom": 1.0,
                "pan_x": 0.0, "pan_y": 0.0}
VIEW = dict(VIEW_DEFAULT)


def handle_view_event(ev, drag):
    """Update the desktop preview camera; drag stores the active mouse mode."""
    if ev.type == pygame.KEYDOWN and ev.key == pygame.K_r:
        VIEW.update(VIEW_DEFAULT)
        return
    if ev.type == pygame.MOUSEBUTTONDOWN and ev.button in (1, 3):
        drag["button"] = ev.button
        drag["pos"] = ev.pos
    elif ev.type == pygame.MOUSEBUTTONUP and ev.button in (1, 3):
        if ev.button == drag["button"]:
            drag["button"] = 0
            drag["pos"] = None
    elif ev.type == pygame.MOUSEMOTION and drag["button"] and drag["pos"]:
        dx = ev.pos[0] - drag["pos"][0]
        dy = ev.pos[1] - drag["pos"][1]
        if drag["button"] == 1:
            VIEW["yaw"] = (VIEW["yaw"] + dx * 0.55) % 360.0
            VIEW["pitch"] = max(-75.0, min(75.0,
                                           VIEW["pitch"] + dy * 0.45))
        else:
            VIEW["pan_x"] += dx
            VIEW["pan_y"] += dy
        drag["pos"] = ev.pos
    elif ev.type == pygame.MOUSEWHEEL:
        VIEW["zoom"] = max(0.55, min(2.4,
                                     VIEW["zoom"] * (1.12 ** ev.y)))
    elif ev.type == pygame.MOUSEBUTTONDOWN and ev.button in (4, 5):
        step = 1.12 if ev.button == 4 else (1.0 / 1.12)
        VIEW["zoom"] = max(0.55, min(2.4, VIEW["zoom"] * step))

COL = {
    "bg": (22, 27, 36),
    "skin": (217, 160, 102),
    "arm": (58, 67, 86),
    "band": (74, 85, 104),
    "band_mild": (224, 195, 65),
    "band_fatig": (224, 85, 85),
    "text": (235, 240, 248),
    "muted": (140, 150, 165),
    "gate": (120, 200, 120),
    "crease": (163, 112, 75),
}


def lerp(a, b, k):
    return a + (b - a) * k


def _clamp(value, low, high):
    return max(low, min(high, float(value)))


def legacy_to_pose22(values):
    """Adapt the existing 15-value protocol into the 22-DOF skeleton."""
    if len(values) != 15:
        return None
    out = [float(values[0]), 0.0]
    for i in range(4):
        mcp = float(values[5 + i])
        pip = float(values[9 + i])
        out.extend((mcp, float(values[1 + i]), pip, pip * 0.62))
    out.extend((35.0, float(values[13]), 24.0, float(values[14])))
    return sanitize_pose22(out)


class HandState:
    """Interpolates between pose vectors and holds the parsed UART state."""

    def __init__(self):
        self.cur = list(POSES_V2["rest"])
        self.frm = list(POSES_V2["rest"])
        self.to = list(POSES_V2["rest"])
        self.t0 = 0.0
        self.cls = 0
        self.class_candidate = 0
        self.class_candidate_hits = 0
        self.conf = 0
        self.fat = 0
        self.gated = False
        self.has_pose_frame = False
        self.pose_schema = 0
        self.pose_mask = 0
        self.pose_phase = 0
        self.cal_state = "wait"            # wait / running / ready
        self.last_r = 0.0

    def set_pose(self, name, now):
        target = POSES_V2[name]
        if target == self.to:
            return
        self.frm = list(self.cur)
        self.to = list(target)
        self.t0 = now

    def observe_class(self, cls, now, immediate=False):
        """Debounce legacy R-only streams before changing the rendered pose."""
        if cls == self.cls:
            self.class_candidate = cls
            self.class_candidate_hits = 0
            return False
        if immediate:
            self.class_candidate = cls
            self.class_candidate_hits = POSE_CONFIRM_WINDOWS
        elif cls == self.class_candidate:
            self.class_candidate_hits += 1
        else:
            self.class_candidate = cls
            self.class_candidate_hits = 1
        if self.class_candidate_hits < POSE_CONFIRM_WINDOWS:
            return False
        self.cls = cls
        self.class_candidate_hits = 0
        self.set_pose(POSE_NAMES[cls], now)
        return True

    def set_pose_vector(self, values, now, schema=POSE_SCHEMA_V1,
                        mask=(1 << 15) - 1, phase=0):
        target = legacy_to_pose22(values) if schema == POSE_SCHEMA_V1 \
            else sanitize_pose22(values)
        if target is None:
            return False
        if len(target) != len(self.cur):
            return False
        if target == self.to:
            self.has_pose_frame = True
            self.pose_schema = schema
            self.pose_mask = mask
            self.pose_phase = phase
            return False
        self.frm = list(self.cur)
        self.to = target
        self.t0 = now
        self.has_pose_frame = True
        self.pose_schema = schema
        self.pose_mask = mask
        self.pose_phase = phase
        return True

    def step(self, now):
        k = min(1.0, max(0.0, (now - self.t0) / SMOOTH_S))
        eased = k * k * (3.0 - 2.0 * k)
        self.cur = [lerp(f, t, eased) for f, t in zip(self.frm, self.to)]

    def nearest_pose_class(self):
        """Return the label whose canonical pose is closest to the rendered pose."""
        best_i, best_d = 0, float("inf")
        # Wrist and joint angles carry the action meaning; spread contributes
        # less so a transition is not mislabeled by a small finger splay.
        weights = [1.4, 0.9] + [1.0, 0.7, 1.0, 0.8] * 4 \
                  + [0.9, 0.8, 1.0, 0.9]
        for i, name in enumerate(POSE_NAMES):
            d = sum(weight * (value - target) ** 2
                    for value, target, weight in zip(self.cur, POSES_V2[name], weights))
            if d < best_d:
                best_i, best_d = i, d
        return best_i


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
    if line.startswith("P "):
        return handle_pose_line(line, st, now, conf_min, log)
    if not line.startswith("R "):
        return False                        # F/T handled below, banner ignored
    had_pose_frame = st.has_pose_frame
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
    raw_c = max(0, min(c, len(POSE_NAMES) - 1))
    effective_c = 0 if g or p < conf_min else raw_c
    st.conf, st.gated = p, g
    st.last_r = now
    if g and log["gated"] is not True:
        print("[%08.2f] rest-gate caught a misfire (was c=%d)" %
              (now, raw_c))
        log["gated"] = True
    elif not g:
        log["gated"] = False
    accepted = False
    if not had_pose_frame:
        # Mirror the PS-side two-window confirmation for legacy R-only
        # streams. P frames are authoritative and bypass this fallback.
        accepted = st.observe_class(
            effective_c, now, immediate=(g or p < conf_min))
    if accepted:
        log["cls"] = st.cls
        names = CLS_CN if log["cn"] else CLS_EN
        print("[%08.2f] pose -> %s (p=%d%s)" %
              (now, names[st.cls], p,
                                                ", gated" if g else ""))
    return accepted


def handle_pose_line(line, st, now, conf_min, log):
    """Parse PoseFrame v1 while retaining R-row fallback compatibility."""
    try:
        fields = {}
        for tok in line.split()[1:]:
            if "=" in tok:
                key, value = tok.split("=", 1)
                fields[key] = value
        version = int(fields.get("v", "0"))
        schema = int(fields.get("schema", "0"))
        if version != 1 or schema not in (POSE_SCHEMA_V1, POSE_SCHEMA_V2):
            return False
        gid = max(0, min(int(fields.get("gid", "0")), len(POSE_NAMES) - 1))
        conf = int(fields.get("q", fields.get("p", "0")))
        mask_text = fields.get("mask", "0")
        mask = int(mask_text, 0) if mask_text.lower().startswith("0x") else int(mask_text, 16)
        phase = int(fields.get("phase", "0"))
        value_fields = POSE_FIELDS if schema == POSE_SCHEMA_V1 else POSE_FIELDS_V2
        values = [float(fields[name]) for name in value_fields]
        seq = int(fields.get("s", "0"))
    except (KeyError, TypeError, ValueError):
        return False

    if conf < conf_min:
        values = list(POSES_V2["rest"] if schema == POSE_SCHEMA_V2
                      else POSES["rest"])
        gid = 0
    st.conf, st.gated = conf, False
    st.last_r = now
    changed = gid != log["cls"]
    log["cls"] = gid
    if changed:
        names = CLS_CN if log["cn"] else CLS_EN
        print("[%08.2f] pose frame -> %s (q=%d schema=%d seq=%d)" %
              (now, names[gid], conf, schema, seq))
    st.set_pose_vector(values, now, schema=schema, mask=mask, phase=phase)
    st.cls = gid
    st.class_candidate = gid
    st.class_candidate_hits = 0
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
    level = max(0, min(lv, 3))
    st.fat = level
    if level != log["fat"]:
        log["fat"] = level
        names = FAT_CN if log["cn"] else FAT_EN
        print("[%08.2f] fatigue -> %s" % (now, names[level]))
        return True
    return False


def _vadd(a, b):
    return a[0] + b[0], a[1] + b[1], a[2] + b[2]


def _vsub(a, b):
    return a[0] - b[0], a[1] - b[1], a[2] - b[2]


def _vmul(a, k):
    return a[0] * k, a[1] * k, a[2] * k


def _dot(a, b):
    return a[0] * b[0] + a[1] * b[1] + a[2] * b[2]


def _cross(a, b):
    return (a[1] * b[2] - a[2] * b[1],
            a[2] * b[0] - a[0] * b[2],
            a[0] * b[1] - a[1] * b[0])


def _unit(a):
    import math
    n = math.sqrt(_dot(a, a)) or 1.0
    return _vmul(a, 1.0 / n)


def _model_to_world(p):
    """Map template (x, arm-axis, normal) to world (x, normal=y, arm=z)."""
    return p[0], p[2], p[1]


def _rotate_x(p, angle):
    import math
    c, s = math.cos(angle), math.sin(angle)
    return p[0], p[1] * c - p[2] * s, p[1] * s + p[2] * c


def _rotate_z(p, angle):
    import math
    c, s = math.cos(angle), math.sin(angle)
    return p[0] * c - p[1] * s, p[0] * s + p[1] * c, p[2]


def _mesh_palm(color):
    """Extrude an arched palm silhouette with a narrower wrist heel."""
    center = (0.0, 74.0)
    outer_f = [(x, y, -2.0) for x, y in PALM_OUTLINE]
    outer_b = [(x, y, -PALM_D / 2) for x, y in PALM_OUTLINE]
    inner_f = [(center[0] + (x - center[0]) * 0.91,
                center[1] + (y - center[1]) * 0.91, PALM_D / 2)
               for x, y in PALM_OUTLINE]
    inner_b = [(center[0] + (x - center[0]) * 0.91,
                center[1] + (y - center[1]) * 0.91, -PALM_D / 2)
               for x, y in PALM_OUTLINE]
    # Keep the front plane controlled; the thickness and camera angle provide
    # the 3-D cue without an artificial bump in the upper palm.
    center_f = (center[0], center[1], PALM_D / 2)
    center_b = (center[0], center[1], -PALM_D / 2)
    faces = []
    n = len(PALM_OUTLINE)
    for i in range(n):
        j = (i + 1) % n
        faces.append(([outer_f[i], outer_f[j], outer_b[j], outer_b[i]], color))
        faces.append(([outer_f[i], outer_f[j], inner_f[j], inner_f[i]],
                      color))
        faces.append(([outer_b[j], outer_b[i], inner_b[i], inner_b[j]], color))
        faces.append(([inner_f[i], inner_f[j], center_f], color))
        faces.append(([inner_b[j], inner_b[i], center_b], color))
    return faces


def _mesh_capsule(a, b, r0, r1, color, sides=14):
    """Tapered phalanx with a soft center bulge and recessed ends."""
    import math
    axis = _unit(_vsub(b, a))
    ref = (0.0, 0.0, 1.0) if abs(axis[2]) < 0.85 else (0.0, 1.0, 0.0)
    u = _unit(_cross(axis, ref))
    v = _cross(axis, u)
    profile = ((0.04, 0.80), (0.22, 1.00), (0.78, 1.00), (0.96, 0.80))
    rings = []
    for t, fullness in profile:
        c = _vadd(a, _vmul(_vsub(b, a), t))
        radius = lerp(r0, r1, t) * fullness
        ring = []
        for i in range(sides):
            ang = 2.0 * math.pi * i / sides
            off = _vadd(_vmul(u, math.cos(ang)), _vmul(v, math.sin(ang)))
            ring.append(_vadd(c, _vmul(off, radius)))
        rings.append(ring)
    faces = []
    for ring_i in range(len(rings) - 1):
        for i in range(sides):
            j = (i + 1) % sides
            faces.append(([rings[ring_i][i], rings[ring_i][j],
                           rings[ring_i + 1][j], rings[ring_i + 1][i]], color))
    for i in range(sides):
        j = (i + 1) % sides
        faces.append(([a, rings[0][j], rings[0][i]], color))
        faces.append(([b, rings[-1][i], rings[-1][j]], color))
    return faces


def _mesh_articulated_digit(points, radii, color, sides=16,
                            root_bury=1.15, root_scale=1.0):
    """Sweep one continuous skin surface through MCP, PIP and DIP joints."""
    import math
    directions = [_unit(_vsub(points[i + 1], points[i]))
                  for i in range(len(points) - 1)]
    stations = []
    for i, point in enumerate(points):
        if i == 0:
            tangent = directions[0]
            stations.append((_vadd(point, _vmul(tangent, -radii[i] * root_bury)),
                              radii[i] * 0.22 * root_scale, tangent))
            stations.append((_vadd(point, _vmul(tangent, -radii[i] * 0.62)),
                              radii[i] * 0.72 * root_scale, tangent))
            stations.append((point,
                            radii[i] * (root_scale if root_scale != 1.0 else 1.0),
                            tangent))
        elif i == len(points) - 1:
            tangent = directions[-1]
            stations.append((_vadd(point, _vmul(tangent, -radii[i] * 0.42),),
                              radii[i] * 0.92, tangent))
            stations.append((_vadd(point, _vmul(tangent, radii[i] * 0.22),),
                              radii[i] * 0.58, tangent))
        else:
            incoming, outgoing = directions[i - 1], directions[i]
            tangent = _unit(_vadd(incoming, outgoing))
            if tangent == (0.0, 0.0, 0.0):
                tangent = outgoing
            radius = radii[i] * 1.025
            stations.append((_vadd(point, _vmul(incoming, -radius * 0.30)),
                              radius * 0.98, incoming))
            stations.append((point, radius, tangent))
            stations.append((_vadd(point, _vmul(outgoing, radius * 0.30)),
                              radius * 0.98, outgoing))

    rings = []
    for center, radius, tangent in stations:
        tangent = _unit(tangent)
        ref = (0.0, 0.0, 1.0) if abs(tangent[2]) < 0.85 else (0.0, 1.0, 0.0)
        u = _unit(_cross(tangent, ref))
        v = _cross(tangent, u)
        ring = []
        for i in range(sides):
            ang = 2.0 * math.pi * i / sides
            off = _vadd(_vmul(u, math.cos(ang)), _vmul(v, math.sin(ang)))
            ring.append(_vadd(center, _vmul(off, radius)))
        rings.append(ring)

    faces = []
    for r in range(len(rings) - 1):
        for i in range(sides):
            j = (i + 1) % sides
            faces.append(([rings[r][i], rings[r][j],
                           rings[r + 1][j], rings[r + 1][i]], color))

    tip = _vadd(points[-1], _vmul(directions[-1], radii[-1] * 0.52))
    for i in range(sides):
        j = (i + 1) % sides
        faces.append(([rings[-1][i], rings[-1][j], tip], color))
    return faces


def _mesh_sphere(c, radius, color, rings=4, sides=8):
    import math
    faces = []
    rings_v = []
    for r in range(1, rings):
        phi = math.pi * r / rings
        ring = []
        for i in range(sides):
            a = 2.0 * math.pi * i / sides
            ring.append((c[0] + radius * math.sin(phi) * math.cos(a),
                         c[1] + radius * math.cos(phi),
                         c[2] + radius * math.sin(phi) * math.sin(a)))
        rings_v.append(ring)
    top = (c[0], c[1] + radius, c[2])
    bottom = (c[0], c[1] - radius, c[2])
    for i in range(sides):
        j = (i + 1) % sides
        faces.append(([top, rings_v[0][i], rings_v[0][j]], color))
        for r in range(len(rings_v) - 1):
            faces.append(([rings_v[r][i], rings_v[r + 1][i],
                           rings_v[r + 1][j], rings_v[r][j]], color))
        faces.append(([rings_v[-1][i], bottom, rings_v[-1][j]], color))
    return faces


def _mesh_ellipsoid(center, radii, color):
    unit_mesh = _mesh_sphere(center, 1.0, color, rings=5, sides=12)
    return [([(center[0] + (p[0] - center[0]) * radii[0],
               center[1] + (p[1] - center[1]) * radii[1],
               center[2] + (p[2] - center[2]) * radii[2])
              for p in verts], base)
            for verts, base in unit_mesh]


def _shade(color, intensity):
    intensity = max(0.68, min(1.12, intensity))
    return tuple(max(0, min(255, int(c * intensity))) for c in color)


def _project(p, pivot, scale):
    # Positive world y points toward the camera; world z runs along the arm.
    focal = 520.0
    q = focal / max(240.0, focal - p[1])
    return (int(round(pivot[0] + p[0] * scale * q)),
            int(round(pivot[1] - p[2] * scale * q)))


def _render_faces(screen, faces, pivot, scale, transform):
    light = _unit((-0.42, 0.72, 0.58))
    draw = []
    for verts, base in faces:
        tv = [transform(v) for v in verts]
        if len(tv) >= 3:
            normal = _unit(_cross(_vsub(tv[1], tv[0]), _vsub(tv[2], tv[0])))
            intensity = 0.76 + 0.30 * abs(_dot(normal, light))
        else:
            intensity = 0.85
        poly = [_project(v, pivot, scale) for v in tv]
        color = _shade(base, intensity)
        for i in range(1, len(poly) - 1):
            tri = [poly[0], poly[i], poly[i + 1]]
            tri_depth = (tv[0][1] + tv[i][1] + tv[i + 1][1]) / 3.0
            draw.append((tri_depth, tri, color))
    draw.sort(key=lambda item: item[0])
    for _, tri, color in draw:
        pygame.draw.polygon(screen, color, tri)


def _draw_opaque_base(screen, pivot, scale, hand_transform,
                      camera_transform):
    """Fill palm/forearm silhouettes before 3D faces close small mesh gaps."""
    palm = [_project(hand_transform((x, y, -1.0)), pivot, scale)
            for x, y in PALM_OUTLINE]
    pygame.draw.polygon(screen, COL["skin"], palm)
    forearm = [_project(camera_transform(p), pivot, scale) for p in (
        (-35.0, -174.0, -1.0), (35.0, -174.0, -1.0),
        (35.0, -3.0, -1.0), (-35.0, -3.0, -1.0))]
    pygame.draw.polygon(screen, COL["arm"], forearm)


def _draw_joint_crease(screen, center, direction, radius, pivot, scale,
                       transform):
    length = (direction[0] * direction[0] +
              direction[1] * direction[1]) ** 0.5 or 1.0
    nx, ny = -direction[1] / length, direction[0] / length
    half = radius * 0.68
    pts3 = [
        (center[0] - nx * half, center[1] - ny * half,
         center[2] + radius * 0.35),
        (center[0], center[1], center[2] + radius * 0.92),
        (center[0] + nx * half, center[1] + ny * half,
         center[2] + radius * 0.35),
    ]
    pts = [_project(transform(p), pivot, scale) for p in pts3]
    pygame.draw.lines(screen, _shade(COL["crease"], 0.88), False, pts,
                      max(1, round(scale * 0.9)))


def draw_hand(screen, st):
    import math
    w, h = screen.get_size()
    pivot = (w * 0.50 + VIEW["pan_x"], h * 0.84 + VIEW["pan_y"])
    scale = min(w / 480.0, h / 640.0) * 1.24 * VIEW["zoom"]
    cur = st.cur
    wrist = math.radians(cur[0])
    # Wrist flex rotates the hand about x; the forearm stays on the z axis.
    # The display convention is opposite to the classifier's positive angle,
    # so negate it here while keeping c=3 flex and c=4 extend unchanged.
    wrist_pitch = -wrist
    wrist_dev = math.radians(cur[1]) * 0.65
    camera_pitch = math.radians(VIEW["pitch"])
    camera_yaw = math.radians(VIEW["yaw"])

    def hand_transform(p):
        world = _model_to_world(p)
        world = _rotate_x(world, wrist_pitch)
        world = _rotate_z(world, wrist_dev)
        world = _rotate_z(world, camera_yaw)
        return _rotate_x(world, camera_pitch)

    def camera_transform(p):
        world = _model_to_world(p)
        world = _rotate_z(world, camera_yaw)
        return _rotate_x(world, camera_pitch)

    # Ground shadow and forearm are drawn first, then the hand meshes are depth
    # sorted.  The shadow is deliberately small so the hand stays the focus.
    px, py = int(pivot[0]), int(pivot[1])
    pygame.draw.ellipse(screen, (9, 12, 18),
                        (px - int(105 * scale), py + int(128 * scale),
                         int(210 * scale), int(35 * scale)))
    arm = _mesh_capsule((0, -174, -1), (0, -4, -1), 31, 35, COL["arm"])
    arm_mesh = arm
    band = COL["band"]
    if st.fat == 1:
        band = COL["band_mild"]
    elif st.fat >= 2:
        band = COL["band_fatig"]
    band_mesh = _mesh_capsule((0, -43, 0), (0, -5, 0), 34, 35, band)

    palm_mesh = _mesh_palm(COL["skin"])
    thenar_mesh = _mesh_ellipsoid((-31.0, 48.0, 13.5),
                                  (25.0, 34.0, 2.3), COL["skin"])
    digit_mesh = []
    web_mesh = []
    joints = []

    def direction(angle_deg, depth_deg=0.0):
        a = math.radians(angle_deg)
        b = math.radians(depth_deg)
        cb = math.cos(b)
        return math.sin(a) * cb, math.cos(a) * cb, math.sin(b)

    def thumb_direction(plane_deg, flex_deg):
        """Thumb direction: plane angle controls opposition, flex lifts in y."""
        plane = math.radians(plane_deg)
        flex = math.radians(_clamp(flex_deg, -10, 88))
        return (math.sin(plane) * math.cos(flex),
                math.cos(flex) * math.cos(plane),
                math.sin(flex))

    # MCP abduction stays in the palm xz plane. MCP/PIP/DIP flex are cumulative
    # angles toward the palm normal, with a mild DIP/PIP tendon coupling.
    for i in range(4):
        off = 2 + i * 4
        mcp, spread = cur[off], cur[off + 1]
        pip, dip = cur[off + 2], cur[off + 3]
        base = (FINGER_X[i], FINGER_BASE_Y[i], FINGER_BASE_DEPTH[i])
        flex1 = _clamp(mcp, 0, 90)
        flex2 = min(210.0, flex1 + _clamp(pip, 0, 125))
        dip_eff = _clamp(0.55 * pip + 0.45 * dip, 0, 88)
        # A full fist rolls ~250 degrees cumulative (MCP+PIP+DIP), tips
        # pressed back against the palm base - do not cap below that.
        flex3 = min(265.0, flex2 + dip_eff)
        d1 = direction(spread, flex1)
        d2 = direction(spread, flex2)
        d3 = direction(spread, flex3)
        j1 = _vadd(base, _vmul(d1, FINGER_L1[i]))
        j2 = _vadd(j1, _vmul(d2, FINGER_L2[i]))
        tip = _vadd(j2, _vmul(d3, FINGER_L3[i]))
        r0, r1, r2 = FINGER_RADII[i]
        digit_mesh += _mesh_articulated_digit(
            [base, j1, j2, tip], [r0, r1, r2, r2 * 0.82], COL["skin"])
        joints.append((j1, r1 * 0.78, d1))
        joints.append((j2, r2 * 0.76, d2))

    for i in range(3):
        left_x = FINGER_X[i] + FINGER_RADII[i][0] * 0.78
        right_x = FINGER_X[i + 1] - FINGER_RADII[i + 1][0] * 0.78
        left_y = FINGER_BASE_Y[i] - 3.0
        right_y = FINGER_BASE_Y[i + 1] - 3.0
        valley = ((left_x + right_x) * 0.5,
                  min(left_y, right_y) - 24.0, 15.5)
        web_mesh.append(([(left_x, left_y, 15.5),
                          (right_x, right_y, 15.5), valley],
                         COL["skin"]))

    # Thumb has one buried CMC base and two visible hinge joints (MCP/IP).
    # Its plane angle rotates toward the palm center as opposition increases.
    t_cmc, t_abd, t_mcp, t_ip = cur[18:22]
    opposition = _clamp((t_mcp + t_ip) / 140.0, 0.0, 1.0)
    plane1 = t_abd
    plane2 = t_abd + (90.0 - t_abd) * opposition
    plane3 = plane2 + (105.0 - plane2) * _clamp(t_ip / 80.0, 0.0, 1.0)
    # Thumb flexion is a normal-direction bend. The caps and coefficients let
    # a clenched fist (t_cmc=70, t_mcp/t_ip high) lift the whole chain clear
    # in front of the palm face (chain tip reaches ~n=61 vs palm front n=15),
    # so the thumb wraps over the folded fingers instead of diving through
    # them. Rest/open values stay low and keep the thumb beside the palm.
    d1 = thumb_direction(plane1, min(42.0, t_cmc * 0.60))
    d2 = thumb_direction(plane2, min(75.0, t_cmc * 0.40 + t_mcp * 0.60))
    d3 = thumb_direction(plane3, min(80.0,
                                      t_cmc * 0.25 + t_mcp * 0.40 +
                                      t_ip * 0.35))
    # Thumb: CMC base buried deep inside the palm, short metacarpal segment
    # hidden within the palm thickness, so only the proximal + distal
    # phalanges are visible beyond the thenar edge (two segments, one MCP
    # knuckle crease plus the IP crease).
    t0 = (THUMB_AT[0], THUMB_AT[1], -6.0)
    t1 = _vadd(t0, _vmul(d1, THUMB_META))
    t2 = _vadd(t1, _vmul(d2, THUMB_L1))
    t3 = _vadd(t2, _vmul(d3, THUMB_L2))
    digit_mesh += _mesh_articulated_digit(
        [t0, t1, t2, t3], [14.5, 13.0, 10.0, 8.2], COL["skin"],
        root_bury=1.0, root_scale=0.8)
    # Thenar webbing: a skin patch from the palm's left edge onto the
    # metacarpal, so the thumb root grows out of the hand instead of looking
    # glued on.  It follows the thumb in every pose.
    meta_mid = _vmul(_vadd(t0, t1), 0.5)
    web_mesh.append(([(-48.0, 14.0, 13.0), (-56.0, 48.0, 13.5),
                      (t1[0], t1[1], t1[2] + 5.0),
                      (meta_mid[0], meta_mid[1], meta_mid[2] + 5.0)],
                     COL["skin"]))
    joints.append((t1, 10.5, d1))
    joints.append((t2, 8.8, d2))

    arm_and_band = arm_mesh + band_mesh
    _draw_opaque_base(screen, pivot, scale, hand_transform, camera_transform)
    _render_faces(screen, arm_and_band, pivot, scale, camera_transform)
    edge_on = abs(math.sin(camera_yaw)) > 0.72
    hand_mesh = palm_mesh + thenar_mesh + web_mesh
    # One depth-sorted pass decides occlusion for every posture. The thumb
    # flex caps keep its chain in front of the palm face whenever it sweeps
    # across the fist, so per-triangle ordering never shows it intersecting
    # the folded fingers.
    _render_faces(screen, hand_mesh + digit_mesh, pivot, scale, hand_transform)
    if not edge_on:
        for center, radius, direction_v in joints:
            _draw_joint_crease(screen, center, direction_v, radius, pivot, scale,
                               hand_transform)


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
    elif st.fat >= 2:
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
    ap.add_argument("--conf", type=int, default=POSE_MIN_CONF,
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
    demo_seq = ["rest", "open", "fist", "flex", "ext"]
    demo_i, demo_t = 0, time.time()
    drag = {"button": 0, "pos": None}
    print("virtual hand: %s" % ("demo mode" if args.demo
                                else "%s @ %d" % (args.port, args.baud)))

    running = True
    while running:
        now = time.time()
        for ev in pygame.event.get():
            if ev.type == pygame.QUIT:
                running = False
            elif ev.type == pygame.KEYDOWN and ev.key == pygame.K_ESCAPE:
                running = False
            else:
                handle_view_event(ev, drag)

        if args.demo:
            if now - demo_t > 1.8:
                demo_t = now
                demo_i = (demo_i + 1) % len(demo_seq)
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
            if st.last_r and now - st.last_r > STALE_S:
                st.class_candidate = 0
                st.class_candidate_hits = 0
                if st.cls != 0:
                    st.cls = 0
                    st.set_pose("rest", now)
                print("[%08.2f] no R rows, relaxing" % now)

        st.step(now)
        if args.demo:
            # Keep the status label synchronized with the pose actually on
            # screen while the 350 ms interpolation is in progress.
            st.cls = st.nearest_pose_class()
        screen.fill(COL["bg"])
        draw_hand(screen, st)
        draw_status(screen, st, (big, small, has_cn))
        fat_en = FAT_EN[st.fat]
        pygame.display.set_caption(
            "sEMG virtual hand | %s %d%% | fatigue %s | drag: orbit, right-drag: pan, wheel: zoom, R: reset"
            % (CLS_EN[st.cls], st.conf, fat_en))
        pygame.display.flip()
        clock.tick(60)

    if ser:
        ser.close()
    pygame.quit()
    return 0


if __name__ == "__main__":
    sys.exit(main())
