# Evaluation Record

## Hardware

- FPGA: `XC7Z020-2CLG400-2`
- ADC/front-end revision:
- ADS1299 gain / input range:
- Channel count:
- Sample rate per channel:

## Signal quality

| Test | Setup | Result | Pass condition |
|---|---|---:|---|
| Input short noise | ADC input shorted |  | Record RMS and peak-to-peak |
| Fixed voltage | Calibrated source |  | No missing codes in test range |
| Sampling rate | Logic analyzer/ILA |  | Within 1% of target |
| Channel order | Known multi-channel pattern |  | No channel swap |
| 50 Hz interference | Electrode or test source |  | Record before/after filtering |

## Algorithm and system

- Window / hop:
- Features:
- Model:
- Quantization:
- PL latency:
- End-to-end latency:
- Accuracy / F1:
- FPGA LUT / FF / BRAM / DSP:
- Fmax:

## Reproduction

Record the exact Vivado/Vitis version, Tcl command, commit id, input data file and result file used to produce each number.
