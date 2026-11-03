"""Audit HDC claims without changing firmware or production models.

Reproduce the old D=2048/Q=16 experiment, then test a deployable label
contract: first 40 stable windows per class are guided calibration; after
all first class bouts end, freeze and score subsequent complete bouts.
Uses the existing PL feature extractor (400/100 samples, 1 s edge trim).
The test labels are used ONLY for scoring, except in the explicitly named
oracle experiment which replicates hdc_validate.py.
"""
import argparse
import hashlib
import json
import math
from pathlib import Path

import numpy as np
import pandas as pd
from sklearn.metrics import confusion_matrix, f1_score

from hdc_validate import bipolar, encode, batch_sim
from nmf_validate import envelopes
from train_board_model import CLASSES, FS, WINDOW, HOP, feature_windows

ROOT = Path(__file__).resolve().parents[1]
CAPTURES = [8, 9, 12, 13, 14, 16, 17, 18]


def score(y, pred):
    cm = confusion_matrix(y, pred, labels=np.arange(5))
    count = cm.sum(1)
    return dict(windows=len(y), accuracy=float(np.mean(y == pred)),
                macro_f1=float(f1_score(y, pred, labels=np.arange(5), average='macro', zero_division=0)),
                confusion=cm.tolist(), counts=count.tolist(),
                recall={c: float(cm[i, i] / count[i]) if count[i] else None
                        for i, c in enumerate(CLASSES)})


def guided_split(y, bouts, nfit=40):
    """All fit samples precede all tests; no bout occurs in both splits."""
    fit, first = [], []
    for cls in range(5):
        available = [b for b in np.unique(bouts) if np.sum((bouts == b) & (y == cls)) >= nfit]
        if not available:
            raise ValueError(f'no complete calibration bout for {CLASSES[cls]}')
        b = int(available[0])
        first.append(b)
        fit.extend(np.flatnonzero(bouts == b)[:nfit])
    test = np.flatnonzero(bouts > max(first))
    if not len(test) or set(y[test]) != set(range(5)):
        raise ValueError('not all five classes have later independent test bouts')
    return np.sort(fit), test, first


def memories(dim, levels, seed, ordered=False):
    rng = np.random.default_rng(seed)
    cim = bipolar(rng, (8, dim))
    if not ordered:
        return cim, bipolar(rng, (levels, dim))
    # Nearby scalar levels should have nearby vectors. Flip a disjoint
    # subset of half the bits across the whole range, once per dimension.
    vim = np.repeat(bipolar(rng, (1, dim)), levels, axis=0)
    order = rng.permutation(dim)[:dim // 2]
    for q in range(1, levels):
        vim[q, order[:q * len(order) // (levels - 1)]] *= -1
    return cim, vim


def fit_proto(q, y, bits=16, epochs=0):
    """Integer prototypes; saturate after EVERY accumulation/update."""
    lo, hi = -(1 << (bits - 1)), (1 << (bits - 1)) - 1
    p = np.zeros((5, q.shape[1]), np.int32)
    saturated = 0

    def add(c, delta):
        nonlocal saturated
        value = p[c] + delta
        saturated += int(np.count_nonzero((value < lo) | (value > hi)))
        p[c] = np.clip(value, lo, hi)

    for v, c in zip(q, y):
        add(int(c), v.astype(np.int32))
    for _ in range(epochs):
        for v, c in zip(q, y):
            v = v.astype(np.int32)
            pred = int(np.argmax(p @ v))
            if pred != c:
                add(int(c), v)
                add(pred, -v)
    return p, saturated


def frozen_predict(q, p):
    # No label argument: impossible to adapt on test labels here.
    return batch_sim(q, p).argmax(1)


def nearest_mean(train, y, test, scale=None):
    if scale is not None:
        train, test = train / scale, test / scale
    means = np.stack([train[y == c].mean(0) for c in range(5)])
    return ((test[:, None] - means) ** 2).sum(2).argmin(1)


def old_protocol(e, y):
    dim, levels = 2048, 16
    cut = int(len(e) * .3)
    rng = np.random.default_rng(7 + 1000 * dim + levels)
    cim, vim = bipolar(rng, (8, dim)), bipolar(rng, (levels, dim))
    q = encode(e, e[:cut].max(0), cim, vim)
    # Original classes are alphabetical, including any future-only class.
    names = sorted(set(y) - {'none', ''})
    ids = np.array([names.index(v) if v in names else -1 for v in y])
    p = np.zeros((len(names), dim), np.int32)
    for c in range(len(names)):
        p[c] = q[:cut][ids[:cut] == c].sum(0, dtype=np.int32)
    frozen = frozen_predict(q[cut:], p)
    pa, adapt, updates = p.copy(), [], 0
    for v, c in zip(q[cut:], ids[cut:]):
        v = v.astype(np.int32)
        pred = int(np.argmax(pa @ v))
        adapt.append(pred)
        if c >= 0 and pred != c:
            pa[c] += v
            pa[pred] -= v
            updates += 1
    means = np.stack([e[:cut][ids[:cut] == c].mean(0)
                      for c in range(len(names)) if np.any(ids[:cut] == c)])
    available = np.array([c for c in range(len(names)) if np.any(ids[:cut] == c)])
    mav = available[((e[cut:, None] - means) ** 2).sum(2).argmin(1)]
    # A trivial previous-true-label predictor exposes how easy dense label
    # feedback makes long sequential bouts. It is NOT a usable classifier.
    prev = ids[cut-1:-1]
    return dict(train_windows=cut, test_windows=len(e)-cut,
                train_counts={name: int(np.sum(ids[:cut] == c)) for c, name in enumerate(names)},
                unseen_test_classes=[name for c, name in enumerate(names)
                                     if not np.any(ids[:cut] == c) and np.any(ids[cut:] == c)],
                invalid_test_windows=int(np.sum(ids[cut:] < 0)),
                frozen=float(np.mean(frozen == ids[cut:])),
                supervised_every_window=float(np.mean(adapt == ids[cut:])),
                mav_centroid=float(np.mean(mav == ids[cut:])),
                previous_true_label_oracle=float(np.mean(prev == ids[cut:])),
                mistake_updates=updates, prototype_max_abs=int(np.abs(pa).max()))


def load_capture(path):
    df = pd.read_csv(path)
    meta = json.loads(path.with_suffix('.json').read_text(encoding='utf-8'))
    if meta.get('signal') != 'processed' or meta.get('sample_rate_hz') != FS:
        raise ValueError(f'{path}: expected processed/4000 metadata')
    if not np.all(np.diff(df.timestamp_us.to_numpy(np.int64)) == 250):
        raise ValueError(f'{path}: discontinuous timestamps')
    if not df.source.eq('processed').all():
        raise ValueError(f'{path}: unexpected signal source')
    if not df.action.isin(CLASSES + ['none']).all():
        raise ValueError(f'{path}: unsupported labels')
    return df


def run_capture(path, seeds):
    df = load_capture(path)
    x = df[[f'channel_{i}' for i in range(8)]].to_numpy(np.int32)
    labels = df.action.to_numpy()
    e, lab = envelopes(x, FS, labels, prefiltered=True)
    old = old_protocol(e, lab)
    del e
    y = np.array([CLASSES.index(v) if v in CLASSES else -1 for v in labels])
    fx, fy, bouts = feature_windows(x, y)
    try:
        fit, test, first = guided_split(fy, bouts)
    except ValueError as exc:
        return dict(path=str(path.relative_to(ROOT)),
                    sha256=hashlib.sha256(path.read_bytes()).hexdigest(),
                    sidecar_sha256=hashlib.sha256(path.with_suffix('.json').read_bytes()).hexdigest(),
                    old_protocol=old, guided=dict(eligible=False, reason=str(exc)))
    e = fx[:, :8] / WINDOW
    scale = np.maximum(e[fit].max(0), 1e-12)
    rows = {}
    for name, norm in [('mav_centroid', None), ('scaled_mav_centroid', scale)]:
        rows[name] = score(fy[test], nearest_mean(e[fit], fy[fit], e[test], norm))
    for seed in seeds:
        result = {}
        for ordered in (False, True):
            cim, vim = memories(2048, 16, seed, ordered)
            q = encode(e, scale, cim, vim)
            for bits, epochs, name in [(16, 0, 'sum16'), (16, 5, 'retrain16'), (8, 5, 'retrain8')]:
                p, sat = fit_proto(q[fit], fy[fit], bits, epochs)
                key = ('ordered_' if ordered else 'random_') + name
                result[key] = dict(**score(fy[test], frozen_predict(q[test], p)),
                                   saturated_dimension_updates=sat,
                                   prototype_max_abs=int(np.abs(p).max()))
                if not ordered and epochs == 0:
                    b = np.where(p >= 0, 1, -1).astype(np.int32)
                    result['random_majority1'] = score(fy[test], frozen_predict(q[test], b))
        rows[str(seed)] = result
    return dict(path=str(path.relative_to(ROOT)),
                sha256=hashlib.sha256(path.read_bytes()).hexdigest(),
                sidecar_sha256=hashlib.sha256(path.with_suffix('.json').read_bytes()).hexdigest(),
                old_protocol=old, guided=dict(eligible=True, fit_windows=len(fit), test_windows=len(test),
                    first_bouts=first, first_test_bout=int(bouts[test[0]]),
                    fit_counts=np.bincount(fy[fit], minlength=5).tolist(),
                    test_counts=np.bincount(fy[test], minlength=5).tolist(),
                    test_mav_quantizer_clip_fraction=float(np.mean(e[test] > scale)),
                    results=rows))


def resources(classes, bits):
    encoding = (8 + 16) * 2048
    proto = classes * 2048 * bits
    return dict(classes=classes, prototype_bits_per_dimension=bits,
                encoding_bytes=encoding//8, active_prototype_bytes=proto//8,
                ideal_bram36_lower_bound=math.ceil((encoding+proto)/36864),
                ideal_with_one_backup_lower_bound=math.ceil((encoding+2*proto)/36864))


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--out-dir', default='report/hdc_audit_20261024')
    ap.add_argument('--seeds', nargs='+', type=int, default=[7, 17, 27])
    ap.add_argument('--captures', nargs='+', type=int, default=CAPTURES)
    args = ap.parse_args()
    rows = []
    for n in args.captures:
        name = f'EMG{n:03d}' + ('_validprefix' if n == 18 else '') + '_processed.csv'
        path = ROOT / f'report/emg{n:03d}_20261022' / name
        row = run_capture(path, args.seeds)
        rows.append(row)
        if row['guided']['eligible']:
            g = row['guided']['results']
            print(f'{name}: old oracle={row["old_protocol"]["supervised_every_window"]:.3f}; '
                  f'guided centroid={g["mav_centroid"]["accuracy"]:.3f}, '
                  f'HDC16={np.mean([g[str(s)]["random_retrain16"]["accuracy"] for s in args.seeds]):.3f}', flush=True)
        else:
            print(f'{name}: guided skipped: {row["guided"]["reason"]}', flush=True)
    eligible = [r for r in rows if r['guided']['eligible']]
    if not eligible:
        raise ValueError('no captures support the complete five-class guided protocol')
    methods = list(eligible[0]['guided']['results'][str(args.seeds[0])])
    summary = {}
    for method in ['mav_centroid', 'scaled_mav_centroid'] + methods:
        vals = [r['guided']['results'][method] if method.endswith('centroid') else
                r['guided']['results'][str(s)][method] for r in eligible for s in
                ([args.seeds[0]] if method.endswith('centroid') else args.seeds)]
        summary[method] = dict(mean_capture_seed_accuracy=float(np.mean([v['accuracy'] for v in vals])),
                               mean_capture_seed_macro_f1=float(np.mean([v['macro_f1'] for v in vals])))
    provenance = {str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest()
                  for p in [Path(__file__).resolve(), ROOT/'tools/hdc_validate.py',
                            ROOT/'tools/nmf_validate.py', ROOT/'tools/train_board_model.py',
                            ROOT/'data/metrics/hdc_validate.json']}
    report = dict(dim=2048, levels=16, seeds=args.seeds, classes=CLASSES,
                  source_sha256=provenance,
                  firmware_changed=False, hardware_validated=False,
                  contract=dict(fs=FS, window=WINDOW, hop=HOP, edge_trim_s=1,
                                calibration_windows_per_class=40, retrain_epochs=5,
                                test_updates=0, saturation='signed per update',
                                split='first qualifying bout per class; test strictly after latest fit bout'),
                  captures=rows, guided_eligible_captures=len(eligible), summary=summary,
                  resources=[resources(c, b) for c in [5, 14] for b in [1, 8, 16, 32]],
                  limitations=[
                      'Retrospective protocol audit, not prospective or unseen-subject validation.',
                      'All records already used in development; hyperparameters require future untouched wear validation.',
                      '008 and 009 are one wear, not independent wears.',
                      'Only stable bouts; transitions and actuator policy not evaluated.',
                      'Guided local fit only; no cross-wear pretrained HDC or MLP-fusion claim.',
                      'No test quality screening; known contact artifacts retained.',
                      'Random and ordered encodings reported separately; ordered is a new candidate, not replication.',
                      'Resource numbers are storage lower bounds, not synthesis/implementation results.'])
    out = ROOT / args.out_dir
    out.mkdir(parents=True, exist_ok=True)
    (out / 'audit.json').write_text(json.dumps(report, indent=2), encoding='utf-8')
    print(json.dumps(summary, indent=2))


if __name__ == '__main__':
    main()

