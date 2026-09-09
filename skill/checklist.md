# Reproducibility Checklist

## Project

- [ ] Target part is `xc7z020clg400-2`.
- [ ] `build/create_project.tcl` runs in batch mode.
- [ ] Source and simulation compile order is visible in Vivado.
- [ ] Verified XDC is present for the actual carrier board.

## Acquisition

- [ ] ADS1299 schematic and pin map are archived in `board/`.
- [ ] ADS1299 register setup and 24-bit frame format are checked against the exact device variant.
- [ ] Reset, chip select, clock and data waveforms are captured.
- [ ] Fixed-input data is exported to `data/raw/`.

## Algorithm

- [ ] Python/reference implementation exists before RTL optimization.
- [ ] Filter and feature outputs are compared sample by sample.
- [ ] Train/test split is recorded by subject or trial.
- [ ] Model input scale and quantization parameters are versioned.

## Competition package

- [ ] Source, simulation, build scripts and measured results are included.
- [ ] Resource, timing and latency numbers are measured on the target board.
- [ ] Demo steps can be executed from a clean checkout.
- [ ] Report explains design decisions, failed attempts and validation evidence.
