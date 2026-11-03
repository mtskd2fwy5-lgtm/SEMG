"""Compare the compiled firmware solver against a floating fixed-W reference."""
import json
from pathlib import Path
import subprocess
import sys

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools'))
from export_synergy_model import fixed_float
from nmf_validate import load_csv, envelopes


def main():
    manifest = json.loads((ROOT / 'report/synergy_20261023/model.json').read_text())
    W = np.asarray(manifest['weight_q15']) / 32768
    exe = ROOT / 'sim/results_synergy/synergy_nmf_test.exe'
    result = {}
    for index in (8, 9, 18):
        stem = f'EMG{index:03d}' + ('_validprefix' if index == 18 else '')
        source = ROOT / f'report/emg{index:03d}_20261022/{stem}_processed.csv'
        signal, _, filtered = load_csv(str(source))
        assert filtered
        E, _ = envelopes(signal, 4000, prefiltered=True)
        # Include silence and abrupt restart rather than testing only activity.
        summed = np.rint(np.concatenate([np.zeros((4, 8)), E]) * 400).astype(np.int64)
        data = '\n'.join(' '.join(map(str, row)) for row in summed) + '\n'
        proc = subprocess.run([str(exe), '--stream'], input=data, text=True,
                              capture_output=True, check=True)
        actual = np.fromstring(proc.stdout, sep=' ').reshape(-1, 3) / 256
        expected = fixed_float(summed / 400, W)
        # Relative L2 error avoids large percentages on components near zero.
        rel = np.linalg.norm(actual-expected, axis=1) / np.maximum(np.linalg.norm(expected, axis=1), 1)
        result[stem] = {'windows': len(actual), 'relative_l2_p99': float(np.percentile(rel, 99)),
                        'relative_l2_mean': float(rel.mean()),
                        'max_absolute_mean_adc_counts': float(np.abs(actual-expected).max())}
        residual = np.linalg.norm(actual @ W.T - summed / 400, axis=1) / np.maximum(np.linalg.norm(summed / 400, axis=1), 1)
        result[stem]['relative_reconstruction_p50'] = float(np.percentile(residual, 50))
        result[stem]['relative_reconstruction_p95'] = float(np.percentile(residual, 95))
        assert np.isfinite(actual).all() and (actual >= 0).all()
        assert np.percentile(rel, 99) < .005, result[stem]
    target = ROOT / 'report/synergy_20261023/numeric_validation.json'
    target.write_text(json.dumps(result, indent=2), encoding='utf-8')
    print(json.dumps(result, indent=2))


if __name__ == '__main__':
    main()

