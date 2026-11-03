"""Portable pose contract shared by the PC renderer and PS/LCD tooling.

The renderer may use floating-point geometry, but the pose table itself stays
integer-valued in degrees. The generator emits the same table as C constants
for the freestanding Zynq application and a future LCD renderer.
"""

POSE_SCHEMA_V2 = 2
POSE_VALID_MASK = (1 << 22) - 1
POSE_MODEL_CLASSES = 5
POSE_MIN_CONF = 70
POSE_HOLD_CONF = 50
POSE_CONFIRM_WINDOWS = 3
POSE_REST_WINDOWS = 6
POSE_UNCERTAIN_WINDOWS = 8
# Legacy UART R/P streams use the old ratio score, not model-scaled softmax.
LEGACY_POSE_MIN_CONF = 30
LEGACY_POSE_CONFIRM_WINDOWS = 2
POSE_SMOOTH_MS = 220
POSE_STALE_MS = 1500
POSE_ANGLE_Q_SHIFT = 8
POSE_ANGLE_Q_SCALE = 1 << POSE_ANGLE_Q_SHIFT

POSE_NAMES = ["rest", "open", "fist", "flex", "ext"]

POSE_FIELDS_V2 = (
    "wf", "wd",
    "i_mcp", "i_abd", "i_pip", "i_dip",
    "m_mcp", "m_abd", "m_pip", "m_dip",
    "r_mcp", "r_abd", "r_pip", "r_dip",
    "l_mcp", "l_abd", "l_pip", "l_dip",
    "t_cmc", "t_abd", "t_mcp", "t_ip",
)

# Degrees: wrist flex/deviation, four long-finger MCP abduction/flexion and
# PIP/DIP flexion, then thumb CMC flex/abduction plus MCP/IP flexion.
POSES_V2 = {
    "rest": [0, 0, 18, -10, 20, 12, 14, -4, 18, 10,
             16, 4, 18, 10, 18, 11, 22, 14, 32, -62, 28, 20],
    "open": [0, 0, 4, -14, 5, 3, 2, -5, 4, 2,
             3, 4, 5, 3, 5, 13, 8, 5, 20, -78, 8, 4],
    "fist": [0, 0, 84, -4, 88, 60, 86, -1, 90, 62,
             88, 2, 92, 64, 90, 5, 94, 66, 70, -40, 54, 70],
    "flex": [34, 0, 20, -8, 28, 18, 18, -3, 26, 16,
             20, 4, 26, 18, 22, 9, 30, 20, 34, -55, 34, 24],
    "ext": [-34, 0, 8, -12, 10, 6, 7, -4, 8, 4,
            8, 4, 10, 5, 10, 8, 12, 6, 24, -65, 14, 8],
}

# Renderer-side limits. They are also emitted for future integer LCD drawing.
POSE_LIMITS = (
    (-45, 45), (-25, 25),
    (0, 95), (-25, 25), (0, 125), (0, 85),
    (0, 95), (-25, 25), (0, 125), (0, 85),
    (0, 95), (-25, 25), (0, 125), (0, 85),
    (0, 95), (-25, 25), (0, 125), (0, 85),
    (0, 70), (-85, 35), (0, 80), (0, 90),
)


def sanitize_pose22(values):
    """Clamp a pose vector to the portable contract limits."""
    if len(values) != len(POSE_FIELDS_V2):
        return None
    return [
        max(low, min(high, float(value)))
        for value, (low, high) in zip(values, POSE_LIMITS)
    ]

