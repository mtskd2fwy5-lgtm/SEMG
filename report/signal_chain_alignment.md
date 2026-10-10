# Signal Chain Alignment

Date: 2026-09-30

## Purpose

The original training and export scripts did not share one explicit
preprocessing contract:

- `train_baseline.py` could emulate 4 kSPS with `--resample 20`,
  `--win-samples 400`, and `--hop-samples 100`.
- `export_int8.py` previously used the default 200 Hz, 40/10-sample path,
  so its calibration distribution did not match the PL feature bank.
- Neither path applied the RTL integer bandpass by default.

This phase adds an opt-in, reproducible PL-aligned path without replacing the
existing production model assets.

## Implemented Contract

`tools/train_baseline.py` and `tools/export_int8.py` now share:

1. source CSV rate: 200 Hz;
2. sample-and-hold upsample: 20x to 4 kSPS;
3. exact integer RTL bandpass from `tools/emg_reference.py`;
4. feature window: 400 samples;
5. hop: 100 samples;
6. feature order: `channel_0..7` for each of MAV, WL, Energy, ZC, SSC.

For continuous `*_full.csv` data, non-target movement samples are retained
with label `-1` while filtering, so the recursive filter state follows the
real stream. Only windows containing one target class are used for training.

## LoSo Results

| Experiment | Input stream | PL filter | Accuracy | Macro F1 |
|---|---|---:|---:|---:|
| Existing baseline | baseline rows | no | 0.8404 | 0.5004 |
| Diagnostic | baseline rows | yes | 0.8309 | 0.4908 |
| Aligned experiment | continuous full stream | yes | 0.8346 | 0.4912 |

The aligned result is lower than the current baseline by 0.58 percentage
points. The diagnostic result is lower by 0.95 points because filtering after
removing non-target movements creates an artificial discontinuity. Therefore
the current evidence does not justify replacing the production model with the
filtered experiment.

The largest generalization weakness remains subject `s3`; the aligned
float-model LoSo accuracies are `s1=0.9253`, `s2=0.8979`, and `s3=0.6772`.
This points to data distribution and calibration work as the next accuracy
priority, rather than more INT8 tuning.

## INT8 And RTL Evidence

The aligned INT8 experiment reports:

- weighted LoSo accuracy: `0.8364`;
- float-to-INT8 prediction agreement: `0.9836` to `0.9925` by subject;
- independent Vivado simulation: 64/64 windows pass bit-exactly.

The existing production INT8 model was also rerun after testbench
parameterization: 64/64 windows pass bit-exactly.

## Reproduction

```text
python tools/train_baseline.py --sessions 2 --subjects s1 s2 s3 ^
  --input-mode full --resample 20 --win-samples 400 --hop-samples 100 ^
  --pl-filter --model-path data/models/baseline_mlp_pl_filter_fullstream.joblib ^
  --metrics-path data/metrics/baseline_pl_filter_fullstream.json

python tools/export_int8.py --sessions 2 --subjects s1 s2 s3 ^
  --input-mode full --resample 20 --win-samples 400 --hop-samples 100 ^
  --pl-filter --out-dir data/models/nn_int8_pl_filter_fullstream ^
  --metrics-path data/metrics/int8_validation_pl_filter_fullstream.json

cmd /c build\scripts\run_nn_infer_pl_filter_sim.bat
```

The default `nn_int8` directory remains unchanged. The new model directory is
an experiment until board-level latency, stability, and recognition results
are collected.
