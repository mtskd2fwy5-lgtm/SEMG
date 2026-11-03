"""Compile and compare actual board learner to an independent integer NumPy
reference. Optional --captures replays old gestures using full held-out bouts;
it cannot establish performance of custom gestures that were never recorded.
"""
from pathlib import Path
import argparse
import hashlib
import json
import subprocess
import sys

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools'))
from audit_hdc import memories, load_capture, score
from train_board_model import feature_windows, CLASSES


def check(exe, out, name, train, test, y, levels=32):
    classes = len(train)
    train = np.asarray(train, dtype='<u4')
    test = np.asarray(test, dtype='<u4')
    source, result = out / f'{name}.input', out / f'{name}.output'
    with source.open('wb') as f:
        f.write(np.array([classes, len(test)], '<u4').tobytes())
        f.write(train.tobytes())
        for label, row in zip(y, test):
            f.write(np.array([label], '<u4').tobytes());f.write(row.tobytes())
    subprocess.run([str(exe), str(source), str(result), str(levels)], check=True)
    data = result.read_bytes()
    scale = np.maximum(train.max((0, 1)), 1).astype(np.uint64)
    np.testing.assert_array_equal(np.frombuffer(data[:32], '<u4'), train.max((0, 1)))
    cim, vim = memories(2048, levels, 7, True)

    def encode(rows):
        idx = np.minimum((rows.astype(np.uint64)*(levels-1)+scale//2)//scale, levels-1).astype(int)
        return np.where((cim[None]*vim[idx]).sum(1) >= 0, 1, -1).astype(np.int32)

    # Chunk independent reference encoding to avoid multi-GB temporaries.
    proto = np.stack([encode(row).sum(0) for row in train]).astype(np.int32)
    end = 32 + classes*2048*2
    np.testing.assert_array_equal(np.frombuffer(data[32:end], '<i2').reshape(classes, 2048), proto)
    query = encode(test[:1])[0]
    packed = np.packbits(query > 0, bitorder='little').view('<u4')
    np.testing.assert_array_equal(np.frombuffer(data[end:end+256], '<u4'), packed)
    actual = np.frombuffer(data[end+256:], '<u4').reshape(-1, 4)
    normalized = train.astype(np.uint64)*1024//scale
    means = normalized.sum(1)//120
    preds, margins, precise = [], [], []
    for start in range(0, len(test), 128):
        sims = encode(test[start:start+128]) @ proto.T
        preds.extend(sims.argmax(1))
        ranks = np.sort(sims, axis=1)
        margins.extend((ranks[:, -1]-ranks[:, -2])*100//(2*120*2048))
        precise.extend((ranks[:, -1]-ranks[:, -2])*10000//(2*120*2048))
    norm = np.minimum(test.astype(np.uint64)*1024//scale, 65535).astype(np.int64)
    centroid = ((norm[:, None]-means.astype(np.int64))**2).sum(2).argmin(1)
    np.testing.assert_array_equal(actual[:, 0], preds)
    np.testing.assert_array_equal(actual[:, 1], centroid)
    np.testing.assert_array_equal(actual[:, 2], margins)
    np.testing.assert_array_equal(actual[:, 3], precise)
    row = dict(levels=levels, median_gap_bp=float(np.median(precise)), encoding_prototype_prediction_parity=True, classes=classes, test_windows=len(test),
               hdc_accuracy=float(np.mean(actual[:, 0] == y)), centroid_accuracy=float(np.mean(centroid == y)))
    if classes == 5:
        row.update(hdc=score(y, actual[:, 0]), centroid=score(y, centroid))
    return row


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--captures', action='store_true')
    ap.add_argument('--out', default='sim/results_hdc')
    ap.add_argument('--replay-existing', action='store_true')
    args = ap.parse_args()
    out = ROOT / args.out;out.mkdir(parents=True, exist_ok=True)
    exe = out/'hdc_learning_test.exe'
    command = f'call "D:\\c++\\VC\\Auxiliary\\Build\\vcvars64.bat" >nul && cl /nologo /std:c11 /O2 /W3 "{ROOT / "sim/hdc_learning_test.c"}" /Fo:"{out / "hdc_learning_test.obj"}" /Fe:"{exe}"'
    batch = out/'compile.bat'
    batch.write_text('@echo off\n'+command+'\nexit /b %errorlevel%\n')
    subprocess.run(['cmd', '/c', str(batch)], check=True)
    subprocess.run([str(exe)], check=True)
    rng = np.random.default_rng(824)
    train = rng.integers(0, 1_000_000, (8, 120, 8), dtype=np.uint32)
    # Zero scale, quantization ties, clipping and full uint32 inputs.
    train[:, :, 0] = 0
    test = rng.integers(0, 2**32, (257, 8), dtype=np.uint32)
    test[:8] = train[:, 0];test[-1] = 0
    rows = {'synthetic_parity': check(exe, out, 'parity', train, test, np.zeros(len(test), int))}
    train_many = rng.integers(0, 1_000_000, (23, 120, 8), dtype=np.uint32)
    rows['dynamic_parity'] = check(exe, out, 'dynamic_parity', train_many, test,
                                   np.zeros(len(test), int))
    for levels in (16,32):
        # Three close patterns collapse to the same Q16 bin, but are distinct
        # Q32 bins. A shared calibration maximum is deliberately present.
        similar = np.full((3,120,8),5000,dtype=np.uint32)
        similar[1,:,0]=5400;similar[2,:,1]=5400;similar[:,0,:]=10000
        tx=np.stack([similar[c,1] for c in range(3) for _ in range(40)])
        ty=np.repeat(np.arange(3),40)
        rows[f'close_patterns_Q{levels}']=check(exe,out,f'close_patterns_Q{levels}',similar,tx,ty,levels)
    if args.replay_existing:
        for path in sorted((ROOT/'sim/results_hdc').glob('EMG*.input')):
            data=np.fromfile(path,dtype='<u4');nc,nt=map(int,data[:2])
            train=data[2:2+nc*120*8].reshape(nc,120,8)
            tests=data[2+nc*120*8:].reshape(nt,9)
            rows[path.stem]={str(levels):check(exe,out,f'{path.stem}_Q{levels}',train,tests[:,1:],tests[:,0],levels) for levels in (16,32)}
    if args.captures:
        for number in [8, 9, 12, 13, 16]:
            path = ROOT/f'report/emg{number:03d}_20261022/EMG{number:03d}_processed.csv'
            df = load_capture(path)
            x = df[[f'channel_{i}' for i in range(8)]].to_numpy(np.int32)
            y = np.array([CLASSES.index(v) if v in CLASSES else -1 for v in df.action])
            fx, fy, bouts = feature_windows(x, y)
            indices, first = [], []
            for c in range(5):
                possible = [b for b in np.unique(bouts) if np.sum((bouts == b)&(fy == c)) >= 120]
                if not possible: break
                b = possible[0];first.append(b);indices.append(np.flatnonzero(bouts == b)[:120])
            if len(indices) < 5:
                rows[f'EMG{number:03d}'] = dict(eligible=False, reason='first calibration bout too short for 120 stable windows');continue
            held = np.flatnonzero(bouts > max(first))
            if set(fy[held]) != set(range(5)):
                rows[f'EMG{number:03d}'] = dict(eligible=False, reason='later bouts do not contain all five classes');continue
            row = check(exe, out, f'EMG{number:03d}', fx[np.array(indices), :8], fx[held, :8], fy[held])
            row.update(source=str(path.relative_to(ROOT)), sha256=hashlib.sha256(path.read_bytes()).hexdigest(),
                       protocol='first 120 stable windows/class in first bout; all tests in later independent bouts; no test updates')
            rows[f'EMG{number:03d}'] = row
    report = out;report.mkdir(parents=True, exist_ok=True)
    (report/'replay.json').write_text(json.dumps(rows, indent=2), encoding='utf-8')
    print(json.dumps({k: {a: b for a, b in v.items() if a not in ('hdc', 'centroid')} for k, v in rows.items()}, indent=2))
    print('TEST_PASS C/NumPy exact packed-query, all prototypes, predictions, margins and centroid parity; frozen model.')


if __name__ == '__main__':main()
