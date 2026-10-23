# Hardware Metrics

Generated: 2026-10-15

## Latest Frequency Display Revision

The 2026-10-16 30-band spectrum revision passed isolated XC7Z020 OOC
synthesis with Vivado 2025.2: 28040 LUTs, 21107 FFs, 21 RAMB36 and 90 DSP
blocks, with 0 synthesis errors and 0 critical warnings. This is a synthesis
estimate for the revised RTL; it does not replace the routed implementation
metrics below.

## Implementation Evidence

| Metric | Result |
|---|---:|
| Target | XC7Z020-2CLG400-2 |
| Tool | Vivado 2025.2 |
| WNS | 0.570 ns |
| WHS | 0.031 ns |
| Slice LUTs | 32108 (60.35%) |
| Slice Registers | 30021 (28.22%) |
| Block RAM Tile | 27.5 (19.64%) |
| DSPs | 96 (43.64%) |
| Vectorless on-chip power | 1.968 W |
| DRC errors | 0 |
| Implementation final critical warnings | 0 |
| Bitstream size | 4045684 bytes |

The power result is vectorless implementation-report data, not a board
power-meter measurement (confidence: low). End-to-end latency and long-run
stability still require a board capture. The final implementation summary
is not a count of top-level synthesis warnings: synthesis has four LCD
clock-group critical warnings because the auto-derived pixel clocks are
not available at that stage. Routed methodology reports 36 warnings:
LUTAR-1 (1), TIMING-18 (28), TIMING-28 (6), ULMTCS-1 (1). These have not
been waived or resolved by the notch change. Both 31.25/50 MHz pixel clocks
exist in the final timing report; positive WNS does not imply full
methodology closure. See `report/notch50_validation_20261015.md`.

## Stream Budget

| Lane | Rate |
|---|---:|
| Raw | 32000 packets/s |
| Notch50 | 32000 packets/s |
| Features | 1600 packets/s |
| NN results | 240 packets/s |
| Fatigue + spectrum results | 16 packets/s |
| Total | 65856 packets/s |
| 1024-word DMA batch interval | 15.552 ms |

The DMA batch is 1024 64-bit words, or 8192 bytes. The AXI TLAST position,
PS transfer length, and ping-pong buffer size must remain identical.
Exactly one waveform source goes to UART (112000 B/s, 1.12 Mbit/s at 8N1,
within 2 Mbaud). Each 4096x64 waveform FIFO infers LUTRAM rather than BRAM.
Isolated synthesis breakdowns are recorded in the notch validation report.

The frequency summary remains six result words per 512 ms FFT window: five
packets carry 30 packed levels and id 15 carries the peak. The stream figures
above are a budget calculation, not a new Vivado post-route resource report.
Run full synthesis and implementation before using a new bitstream; the
previous WNS/WHS numbers do not validate this RTL revision.

## Verification Evidence

- `build/scripts/run_data_path_sim.bat`: four lanes, TLAST, 174 backpressure
  checks, overflow/reset PASS.
- `build/scripts/run_pl_export_sim.bat`: 800-frame integration test,
  6400 raw + 6400 notch + 200 feature words bit-exact; five NN windows exact.
- `sim/tb_emg_fatigue.v`: 28 FFT windows, 224 fatigue/spectrum words
  bit-exact, including ids 8..15.
- `build/scripts/run_notch50_sim.ps1`: 225792 samples bit-exact; 50 Hz
  simulated gain -86.1947 dB, not a board interference measurement.
- `build/scripts/run_uart_record_test.ps1`: actual firmware frame assembly
  for both sources, signed samples, partial/mixed frames and switching PASS.
- Python UART/preprocessing regression: 26 tests PASS, no board port opened.
- `sw/ps_uart_print/build.bat`: PS firmware compiles with warnings enabled.
- `build/scripts/run_lcd_firmware_test.ps1`: 800x480/1024x600 LCD host
  render PASS, including DATA and SPEC pages.
- `build/build_all.ps1`: all five parameter/netlist/timing/boot gates PASS
  on 2026-10-15. Build and artifact hashes are recorded in the notch report.
