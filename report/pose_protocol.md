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
POSE_MIN_CONF        = 30
POSE_CONFIRM_WINDOWS = 2
POSE_SMOOTH_MS       = 220
POSE_STALE_MS        = 1500
```

The PS confirms a new classifier class only after two consecutive valid
windows. A gated or low-confidence rest decision takes effect immediately.
The PC renderer mirrors this policy for legacy `R`-only streams. The LCD
uses the accepted class directly and therefore remains functional with the
UART disconnected.

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
