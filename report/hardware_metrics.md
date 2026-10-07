# Hardware Metrics

Generated: 2026-10-01

## Implementation Evidence

| Metric | Result |
|---|---:|
| Target | XC7Z020-2CLG400-2 |
| Tool | Vivado 2025.2 |
| WNS | 1.561 ns |
| WHS | 0.036 ns |
| Slice LUTs | 19779 (37.18%) |
| Slice Registers | 27563 (25.91%) |
| Block RAM Tile | 26 (18.57%) |
| DSPs | 85 (38.64%) |
| Vectorless on-chip power | 1.813 W |
| DRC errors | 0 |
| Critical warnings | 0 |
| Bitstream size | 4045684 bytes |

The power result is vectorless implementation-report data, not a board
power-meter measurement. End-to-end latency and long-run stability still
require a board capture.

## Stream Budget

| Lane | Rate |
|---|---:|
| Raw | 32000 packets/s |
| Features | 1600 packets/s |
| NN results | 240 packets/s |
| Fatigue results | 4 packets/s |
| Total | 33844 packets/s |
| 256-word DMA batch interval | 7.564 ms |

The DMA batch is 256 64-bit words, or 2048 bytes. The AXI TLAST position,
PS transfer length, and ping-pong buffer size must remain identical.

## Verification Evidence

- `build/scripts/run_data_path_sim.bat`: packet format and TLAST boundary.
- `build/scripts/run_pl_export_sim.bat`: 800-frame integration test,
  6400 raw words and 200 feature words bit-exact against the reference.
- `build/scripts/run_fatigue_sim.bat`: 56 fatigue words bit-exact.
- `sw/ps_uart_print/build.bat`: PS firmware compiles with warnings enabled.
