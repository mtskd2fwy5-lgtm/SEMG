# Data Contract

Raw samples use one CSV row per sample frame:

```text
timestamp_us,channel_0,channel_1,channel_2,channel_3,action,subject,session
```

Rules:

- Keep ADC codes and converted voltage in separate files or columns.
- Record the configured sample rate, input range and board revision in the file header or sidecar JSON.
- Use `action=rest,open_hand,fist,wrist_flex,wrist_extend` for the first baseline.
- Never mix training and test trials from the same continuous recording without recording the split.

Recommended files:

- `raw/<subject>/<session>.csv`
- `processed/<subject>/<session>_features.csv`
- `labels/<subject>/<session>_labels.csv`
- `metrics/baseline.json`
