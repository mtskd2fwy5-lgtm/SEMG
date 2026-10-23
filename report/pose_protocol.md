# Pose Protocol

## Compatibility layers

The PL packet stream remains unchanged.  Type 3 packets still carry the
current INT8 MLP logits (`id=0..4`) and argmax class (`id=5`).  The PS keeps
printing the legacy `R` and `T` UART rows for existing tools.

The PS emits a versioned `P` row after a gesture change. The board-side LCD
does not consume UART; it uses the same state directly inside the PS firmware.

```text
P v=1 s=<seq> schema=2 gid=<gesture> q=<confidence> mask=0x3fffff phase=0 \
  wf=<wrist-flex> wd=<wrist-dev> \
  i_mcp=<...> i_abd=<...> i_pip=<...> i_dip=<...> ... \
  t_cmc=<...> t_abd=<...> t_mcp=<...> t_ip=<...>
```

`schema=1` is the legacy 15 element vector. The PC adapts it internally to
the 22-DOF skeleton:

```text
w, s0..s3, m0..m3, p0..p3, ta, ti
```

The renderer also accepts `schema=2`, a 22-DOF skeleton for continuous
regression. Its fields are:

```text
wf wd,
i_mcp i_abd i_pip i_dip,
m_mcp m_abd m_pip m_dip,
r_mcp r_abd r_pip r_dip,
l_mcp l_abd l_pip l_dip,
t_cmc t_abd t_mcp t_ip
```

`wf/wd` are wrist flexion and radial/ulnar deviation. The four long fingers
have MCP flexion/abduction and PIP/DIP flexion. The thumb has CMC flexion and
abduction plus MCP/IP flexion. The PC renderer clamps joint limits, couples
DIP to PIP, tapers abduction at distal joints, and applies temporal smoothing
before drawing.

`gid` is a stable gesture id, while `q` is the confidence. `mask` marks valid
parameters and `phase` is reserved for a future continuous trajectory. The
renderer ignores unknown fields and falls back to `R` when no valid `P` frame
has arrived, so an old board image and a new PC tool can coexist.

The shared board/PC state policy is:

```text
POSE_MIN_CONF        = 70
POSE_HOLD_CONF       = 50
POSE_CONFIRM_WINDOWS = 3
POSE_REST_WINDOWS   = 6
POSE_UNCERTAIN_WINDOWS = 8
POSE_SMOOTH_MS       = 220
POSE_STALE_MS        = 1500
```

As of `20261022_POSE_STABLE_V2`, PS confidence is model-scaled, uncalibrated
softmax via a fixed-point exponential lookup; it is not an estimated empirical
correctness probability. Old images used max-positive-logit / sum-absolute-logits.
The PS confirms a new action after three valid windows (70 minimum score),
keeps the same action down to 50, confirms rest/MAV evidence for six windows,
and holds ambiguous input for at most eight windows before returning to rest.
Each hop is 25 ms. A discontinuous feature sequence resets pending confirmation.
The LCD score updates for its displayed class every inference window.

New P frames include `stable=1`: `gid` and the pose vector have already passed
this policy and must not be gated a second time by their instantaneous `q`.
The PC accepts that field; frames without it retain the old confidence fallback.
R-only PC fallback retains the old 30-point, two-window adapter, not the new PS hysteresis.
The LCD uses the accepted class directly and remains functional without UART.

## Model changes

The model output must be adapted in PS before it reaches the renderer:

```text
model logits/regression -> PoseAdapter -> P schema=1 -> PC/LCD renderer
```

Adding classes changes only the `gid` mapping and PoseAdapter. Replacing the
classifier with a classification-plus-regression model changes the adapter to
fill continuous joint values; the `P` contract and renderers do not change.

For a future binary transport, use the same fields with `version`, `schema`,
`length`, `seq`, `gid`, `confidence`, `valid_mask`, `pose[]`, `phase`, and CRC.
Angles should use signed Q8.8 degrees so the PS and LCD need no floating point.
