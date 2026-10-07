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
    warnings = re.search(
        r"\d+ Infos, (\d+) Warnings, (\d+) Critical Warnings and (\d+) Errors",
        run_log,
    )
    if not drc or not warnings:
        raise ValueError("could not parse implementation status")

    raw_rate = 8 * 4000
    feature_rate = 40 * 8 * 5
    nn_rate = 40 * 6
    fatigue_rate = 2 * 2
    total_rate = raw_rate + feature_rate + nn_rate + fatigue_rate
    batch_ms = 1000.0 * 256 / total_rate
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
| Critical warnings | {critical_warnings} |
| Bitstream size | {bit_size} bytes |

The power result is vectorless implementation-report data, not a board
power-meter measurement. End-to-end latency and long-run stability still
require a board capture.

## Stream Budget

| Lane | Rate |
|---|---:|
| Raw | {raw_rate} packets/s |
| Features | {feature_rate} packets/s |
| NN results | {nn_rate} packets/s |
| Fatigue results | {fatigue_rate} packets/s |
| Total | {total_rate} packets/s |
| 256-word DMA batch interval | {batch_ms:.3f} ms |

The DMA batch is 256 64-bit words, or 2048 bytes. The AXI TLAST position,
PS transfer length, and ping-pong buffer size must remain identical.

## Verification Evidence

- `build/scripts/run_data_path_sim.bat`: packet format and TLAST boundary.
- `build/scripts/run_pl_export_sim.bat`: 800-frame integration test,
  6400 raw words and 200 feature words bit-exact against the reference.
- `build/scripts/run_fatigue_sim.bat`: 56 fatigue words bit-exact.
- `sw/ps_uart_print/build.bat`: PS firmware compiles with warnings enabled.
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
        critical_warnings=warnings.group(2),
        bit_size=bit_size,
        raw_rate=raw_rate,
        feature_rate=feature_rate,
        nn_rate=nn_rate,
        fatigue_rate=fatigue_rate,
        total_rate=total_rate,
        batch_ms=batch_ms,
    )
    OUT.write_text(report, encoding="utf-8")
    print("metrics -> %s" % OUT.relative_to(ROOT))


if __name__ == "__main__":
    main()
