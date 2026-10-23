#!/usr/bin/env python3
"""Collect implementation evidence into the competition metrics report."""

import re
from datetime import datetime
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
RUN_DIR = ROOT / "build" / "vivado" / "hand_motion_reconstruction.runs" / "impl_1"
TIMING = RUN_DIR / "design_1_timing_summary_routed.rpt"
UTIL = RUN_DIR / "design_1_utilization_placed.rpt"
POWER = RUN_DIR / "design_1_power_routed.rpt"
RUN_LOG = RUN_DIR / "runme.log"
BIT = RUN_DIR / "design_1.bit"
OUT = ROOT / "report" / "hardware_metrics.md"


def required(path):
    if not path.exists():
        raise FileNotFoundError(path)
    return path.read_text(encoding="utf-8", errors="replace")


def utilization_row(text, label):
    for line in text.splitlines():
        if "| %s " % label in line:
            parts = [item.strip() for item in line.split("|")]
            if len(parts) >= 7:
                return parts[2], parts[5], parts[6]
    raise ValueError("missing utilization row: %s" % label)


def main():
    timing = required(TIMING)
    util = required(UTIL)
    power = required(POWER)
    run_log = required(RUN_LOG)

    timing_match = re.search(
        r"^\s*([+-]?\d+\.\d+)\s+0\.000\s+0\s+\d+\s+"
        r"([+-]?\d+\.\d+)\s+0\.000",
        timing,
        re.MULTILINE,
    )
    if not timing_match:
        raise ValueError("could not parse timing summary")
    wns, whs = timing_match.groups()

    lut_used, _, lut_pct = utilization_row(util, "Slice LUTs")
    ff_used, _, ff_pct = utilization_row(util, "Slice Registers")
    bram_used, _, bram_pct = utilization_row(util, "Block RAM Tile")
    dsp_used, _, dsp_pct = utilization_row(util, "DSPs")

    power_match = re.search(r"Total On-Chip Power \(W\)\s*\|\s*([0-9.]+)", power)
    if not power_match:
        raise ValueError("could not parse power")
    power_w = power_match.group(1)

    drc = re.search(r"DRC finished with (\d+) Errors", run_log)
    warnings = re.findall(
        r"\d+ Infos, (\d+) Warnings, (\d+) Critical Warnings and (\d+) Errors",
        run_log,
    )
    if not drc or not warnings:
        raise ValueError("could not parse implementation status")
    critical_warnings = warnings[-1][1]
    rtl = required(ROOT / "src" / "rtl" / "emg_pl_export.v")
    firmware = required(ROOT / "sw" / "ps_uart_print" / "main.c")
    batch = int(re.search(r"parameter\s+integer\s+PACKET_WORDS\s*=\s*(\d+)", rtl).group(1))
    ps_batch = int(re.search(r"#define\s+BUF_PACKETS\s+(\d+)", firmware).group(1))
    if batch != ps_batch:
        raise ValueError("PL PACKET_WORDS and PS BUF_PACKETS disagree")

    raw_rate = 8 * 4000
    notch_rate = raw_rate
    feature_rate = 40 * 8 * 5
    nn_rate = 40 * 6
    fatigue_rate = 8 * 2
    total_rate = raw_rate + notch_rate + feature_rate + nn_rate + fatigue_rate
    batch_ms = 1000.0 * batch / total_rate
    bit_size = BIT.stat().st_size if BIT.exists() else "n/a"

    report = """# Hardware Metrics

Generated: {date}

## Implementation Evidence

| Metric | Result |
|---|---:|
| Target | XC7Z020-2CLG400-2 |
| Tool | Vivado 2025.2 |
| WNS | {wns} ns |
| WHS | {whs} ns |
| Slice LUTs | {lut_used} ({lut_pct}%) |
| Slice Registers | {ff_used} ({ff_pct}%) |
| Block RAM Tile | {bram_used} ({bram_pct}%) |
| DSPs | {dsp_used} ({dsp_pct}%) |
| Vectorless on-chip power | {power_w} W |
| DRC errors | {drc_errors} |
| Implementation final critical warnings | {critical_warnings} |
| Bitstream size | {bit_size} bytes |

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
| Raw | {raw_rate} packets/s |
| Notch50 | {notch_rate} packets/s |
| Features | {feature_rate} packets/s |
| NN results | {nn_rate} packets/s |
| Fatigue + spectrum results | {fatigue_rate} packets/s |
| Total | {total_rate} packets/s |
| {batch}-word DMA batch interval | {batch_ms:.3f} ms |

The DMA batch is {batch} 64-bit words, or {batch_bytes} bytes. The AXI TLAST position,
PS transfer length, and ping-pong buffer size must remain identical.
Exactly one waveform source goes to UART (112000 B/s, 1.12 Mbit/s at 8N1,
within 2 Mbaud). Each 4096x64 waveform FIFO infers LUTRAM rather than BRAM.
Isolated synthesis breakdowns are recorded in the notch validation report.

## Verification Evidence

- `build/scripts/run_data_path_sim.bat`: four lanes, TLAST, 174 backpressure
  checks, overflow/reset PASS.
- `build/scripts/run_pl_export_sim.bat`: 800-frame integration test,
  6400 raw + 6400 notch + 200 feature words bit-exact; five NN windows exact.
- `build/scripts/run_notch50_sim.ps1`: 225792 samples bit-exact; 50 Hz
  simulated gain -86.1947 dB, not a board interference measurement.
- `build/scripts/run_uart_record_test.ps1`: actual firmware frame assembly
  for both sources, signed samples, partial/mixed frames and switching PASS.
- Python UART/preprocessing regression: 26 tests PASS, no board port opened.
- `sw/ps_uart_print/build.bat`: PS firmware compiles with warnings enabled.
- `build/build_all.ps1`: all five parameter/netlist/timing/boot gates PASS
  on 2026-10-15. Build and artifact hashes are recorded in the notch report.
""".format(
        date=datetime.now().strftime("%Y-%m-%d"),
        wns=wns,
        whs=whs,
        lut_used=lut_used,
        lut_pct=lut_pct,
        ff_used=ff_used,
        ff_pct=ff_pct,
        bram_used=bram_used,
        bram_pct=bram_pct,
        dsp_used=dsp_used,
        dsp_pct=dsp_pct,
        power_w=power_w,
        drc_errors=drc.group(1),
        critical_warnings=critical_warnings,
        bit_size=bit_size,
        raw_rate=raw_rate,
        notch_rate=notch_rate,
        feature_rate=feature_rate,
        nn_rate=nn_rate,
        fatigue_rate=fatigue_rate,
        total_rate=total_rate,
        batch_ms=batch_ms,
        batch=batch,
        batch_bytes=batch * 8,
    )
    OUT.write_text(report, encoding="utf-8")
    print("metrics -> %s" % OUT.relative_to(ROOT))


if __name__ == "__main__":
    main()
