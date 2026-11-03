"""Generate deterministic vectors; the decision oracle is the actual PS C code."""
from pathlib import Path
import json
import random
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'sim/results_control'
sys.path.insert(0, str(ROOT / 'tools'))


def check_mapping():
    rows=[list(map(int,line.split())) for line in (OUT/'inference_vectors.txt').read_text().splitlines()]
    inputs=''.join(' '.join(map(str,row[1:42]))+'\n' for row in rows)
    oracle=subprocess.run([str(OUT/'control_policy_reference.exe'),'--mapping'],input=inputs,text=True,capture_output=True,check=True)
    actual=[list(map(int,line.split())) for line in oracle.stdout.splitlines()]
    assert len(actual)==len(rows)
    for n,(row,got) in enumerate(zip(rows,actual)):
        assert got==row[42:47],f'PS selfcal mapping/logits differ from PL reference at row {n}: {got} != {row[42:47]}'
    print(f'TEST_PASS actual PS selfcal mapping and MLP {len(rows)} windows vs PL reference')


def main():
    OUT.mkdir(exist_ok=True)
    rng = random.Random(20261023)
    rows = []
    seq = 65500
    for session in range(5):
        for n in range(1500):
            seq = (seq + (80 if n % 137 == 0 else 40)) & 65535
            mav = [rng.randrange(50, 150) for _ in range(8)] if n < 96 or n % 17 < 7 else [rng.randrange(1000, 50000) for _ in range(8)]
            if session == 4 and n < 96:
                mav = [rng.randrange(0, 2**32) for _ in range(8)]
            mode = n % 101
            cls = (n // 11) % 5
            logits = [-1000] * 5
            logits[cls] = 1000
            if mode < 15:
                logits = [rng.randrange(-130, 131) for _ in range(5)]
            elif mode == 15:
                logits = [-2**31, 2**31-1, 0, -1, 1]
            elif mode == 16:
                logits = [100] * 5
            elif mode < 30:
                common = rng.choice([-2**30, 0, 2**30])
                logits = [common + rng.randrange(-200, 201) for _ in range(5)]
            rows.append([int(n == 0), seq, *mav, *logits])
    # Replay all stable feature windows from recorded sessions, preserving uint32
    # feature saturation used by the PL and INT8 normalization.
    import numpy as np
    from train_board_model import read_capture, feature_windows
    from export_int8 import Int8MLP
    model = Int8MLP(json.loads((ROOT / 'data/models/nn_int8_board_multiwear/quant_params.json').read_text()))
    sources = {}
    replay_features = []
    for number in (8, 9, 15, 18):
        pattern = '*validprefix_processed.csv' if number == 18 else '*processed.csv'
        files = list((ROOT / f'report/emg{number:03d}_20261022').glob(pattern))
        if not files:
            raise RuntimeError(f'missing capture {number}')
        signals, labels = read_capture(files[0])
        features, _, _ = feature_windows(signals, labels)
        features = np.minimum(features, 2**31-1).astype(np.int64)
        logits = model.forward(features)
        sources[str(files[0].relative_to(ROOT))] = len(features)
        replay_features.extend(features[::max(1, len(features)//12)][:12])
        for n, (f, l) in enumerate(zip(features, logits)):
            seq = (seq + 40) & 65535
            rows.append([int(n == 0), seq, *map(int, f[:8]), *map(int, l)])
    inputs = ''.join(' '.join(map(str, r))+'\n' for r in rows)
    oracle = subprocess.run([str(OUT/'control_policy_reference.exe')], input=inputs, text=True, capture_output=True, check=True)
    expected = [list(map(int, line.split())) for line in oracle.stdout.splitlines()]
    assert len(expected) == len(rows), (len(expected), len(rows), oracle.stderr)
    with (OUT/'policy_vectors.txt').open('w') as f:
        for row, exp in zip(rows, expected):
            f.write(' '.join(map(str, row+exp))+'\n')
    (OUT/'vectors.json').write_text(json.dumps({'rows':len(rows), 'synthetic':7500, 'captures':sources}, indent=2))
    ring = [3,0,1,2,4,5]
    with (OUT/'inference_vectors.txt').open('w') as f:
        sequence = 65500
        for n in range(96 + 6*len(replay_features)):
            shift = 0 if n < 96 else (n-96)//len(replay_features)
            feat = np.full(40, 100, dtype=np.int64) if n < 96 else replay_features[(n-96)%len(replay_features)]
            mapped = feat.reshape(5,8).copy()
            for dest, ch in enumerate(ring):
                mapped[:,ch] = feat.reshape(5,8)[:,ring[(dest+shift)%6]]
            logit = model.forward(mapped.reshape(1,40))[0]
            f.write(' '.join(map(str,[sequence,shift,*map(int,feat),*map(int,logit)]))+'\n')
            sequence = (sequence+40)&65535
    print(f'Generated {len(rows)} policy vectors using actual PS oracle')
    check_mapping()


if __name__ == '__main__':
    if '--check-mapping' in sys.argv:check_mapping()
    else:main()

