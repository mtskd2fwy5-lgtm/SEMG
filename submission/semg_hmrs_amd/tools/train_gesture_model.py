"""Fit an OFFLINE 14-class candidate using whole-wear splits from a manifest.

Manifest columns: path,wear_id,split,effort. split=train/test;
effort=light/comfortable/unspecified. CSVs must contain final processed samples.
No INT8/PL export or production model replacement is performed here.
"""
import argparse
import csv
import hashlib
import json
from pathlib import Path

import joblib
import numpy as np
import pandas as pd
from sklearn.metrics import confusion_matrix, f1_score
from sklearn.neural_network import MLPClassifier
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler

from capture_actions import ACTIONS, LABELS, SCHEMA
from train_board_model import (ROOT, FS, HOP, WINDOW, read_capture, feature_windows,
                               remove_spike_windows, balance_rest)


def load_manifest(path):
    with Path(path).open(encoding='utf-8-sig', newline='') as fh:
        reader = csv.DictReader(fh)
        if not {'path','wear_id','split','effort'} <= set(reader.fieldnames or []):
            raise ValueError('manifest requires path,wear_id,split,effort')
        rows = list(reader)
    if not rows:
        raise ValueError('empty manifest')
    paths, digests, groups = set(), set(), {}
    for row in rows:
        row.update({k:row[k].strip() for k in ('path','wear_id','split','effort')})
        if not row['wear_id'] or row['split'] not in ('train','test'):
            raise ValueError('each capture needs wear_id and train/test split')
        if row['effort'] not in ('light','comfortable','unspecified'):
            raise ValueError('effort must be light, comfortable or unspecified')
        p = Path(row['path'])
        if not p.is_absolute():p = ROOT/p
        p = p.resolve()
        digest = hashlib.sha256(p.read_bytes()).hexdigest()
        if p in paths or digest in digests:
            raise ValueError(f'duplicate capture/path/content: {p}')
        if row['wear_id'] in groups and groups[row['wear_id']]!=row['split']:
            raise ValueError(f'wear appears in both train and test: {row["wear_id"]}')
        paths.add(p);digests.add(digest);groups[row['wear_id']]=row['split']
        row.update(resolved_path=p,sha256=digest)
    if set(groups.values())!={'train','test'}:
        raise ValueError('need separate training and held-out wear groups')
    return rows


def extract_capture(path):
    timing = pd.read_csv(path,usecols=['timestamp_us'])['timestamp_us'].to_numpy(np.int64)
    if len(timing)<WINDOW or not np.all(np.diff(timing)==250):
        raise ValueError(f'{path}: need continuous 4 kSPS timestamps; split/exclude damaged spans first')
    with Path(path).open(encoding='utf-8-sig', newline='') as fh:
        fields = next(csv.reader(fh), [])
    source_if_missing = None
    if 'source' not in fields:
        sidecar = Path(path).with_suffix('.json')
        if not sidecar.exists():
            raise ValueError(f'{path}: source column missing and no metadata sidecar')
        metadata = json.loads(sidecar.read_text(encoding='utf-8'))
        if metadata.get('signal') != 'processed' or metadata.get('action_schema') != SCHEMA:
            raise ValueError(f'{path}: source-less CSV requires a matching processed/schema-{SCHEMA} sidecar')
        source_if_missing = 'processed'
    x,y = read_capture(path, classes=LABELS, allow_unlabeled=True,
                       source_if_missing=source_if_missing)
    return feature_windows(x,y)[:2]


def require_classes(y, description):
    missing = [LABELS[i] for i in range(len(LABELS)) if not np.any(y==i)]
    if missing:
        raise ValueError(f'{description} missing classes after trimming/quality screening: {missing}')


def fit_candidate(x,y,seed):
    # Do not randomly split correlated windows for internal early-stopping.
    model = Pipeline([('scaler',StandardScaler()),('mlp',MLPClassifier(
        hidden_layer_sizes=(64,32),max_iter=300,early_stopping=False,random_state=seed))])
    bx,by = balance_rest(x,y,seed,classes=LABELS)
    model.fit(bx,by)
    return model,len(by)


def evaluate(model,x,y):
    pred = model.predict(x)
    cm = confusion_matrix(y,pred,labels=np.arange(len(LABELS)))
    counts = cm.sum(axis=1)
    return dict(windows=len(y),accuracy=float(np.trace(cm)/cm.sum()),
        macro_f1_present_classes=float(f1_score(y,pred,average='macro',zero_division=0)),
        counts=counts.tolist(),confusion=cm.tolist(),
        recall={name:float(cm[i,i]/counts[i]) if counts[i] else None for i,name in enumerate(LABELS)})


def train(rows,seed):
    captures=[]
    for row in rows:
        fx,fy = extract_capture(row['resolved_path'])
        before=len(fy)
        if row['split']=='train':fx,fy,_,_=remove_spike_windows(fx,fy,classes=LABELS)
        captures.append((row,fx,fy,before))
    train_rows=[c for c in captures if c[0]['split']=='train']
    test_rows=[c for c in captures if c[0]['split']=='test']
    x=np.concatenate([c[1] for c in train_rows]);y=np.concatenate([c[2] for c in train_rows])
    require_classes(y,'training')
    require_classes(np.concatenate([c[2] for c in test_rows]),'held-out test')
    model,nfit=fit_candidate(x,y,seed)
    report=dict(classes=LABELS,action_schema=SCHEMA,pl_compatible=False,model_changed_on_board=False,
        contract=dict(fs=FS,window=WINDOW,hop=HOP,trim_seconds_each_edge=1,
                      features=['MAV','WL','Energy','ZC','SSC'],early_stopping=False),
        training_windows=len(y),balanced_training_windows=nfit,seed=seed,
        sources=[dict(path=c[0]['path'],sha256=c[0]['sha256'],wear_id=c[0]['wear_id'],
            split=c[0]['split'],effort=c[0]['effort'],windows_before_screening=c[3],
            windows_used=len(c[2])) for c in captures],
        held_out_test={},by_test_effort={},leave_one_training_wear_out={})
    for row,fx,fy,_ in test_rows:report['held_out_test'][row['path']]=evaluate(model,fx,fy)
    for effort in ('light','comfortable','unspecified'):
        subset=[c for c in test_rows if c[0]['effort']==effort]
        if subset:
            report['by_test_effort'][effort]=evaluate(model,np.concatenate([c[1] for c in subset]),
                                                       np.concatenate([c[2] for c in subset]))
    groups=sorted({c[0]['wear_id'] for c in train_rows})
    for group in groups if len(groups)>1 else []:
        fit=[c for c in train_rows if c[0]['wear_id']!=group]
        # Validation uses unscreened held-out wear; never derive its quality cutoff.
        vx,vy=zip(*(extract_capture(c[0]['resolved_path']) for c in train_rows if c[0]['wear_id']==group))
        tx=np.concatenate([c[1] for c in fit]);ty=np.concatenate([c[2] for c in fit])
        require_classes(ty,f'fold excluding {group}')
        fold,_=fit_candidate(tx,ty,seed)
        report['leave_one_training_wear_out'][group]=evaluate(fold,np.concatenate(vx),np.concatenate(vy))
    report['limitations']=[
        'Offline candidate only; current five-class RTL/layout/protocol cannot load it.',
        'Overlapping windows are correlated; splits use whole wear IDs, not random windows.',
        'Only steady segments scored; separately validate transitions, rest false triggers and hold interruptions.',
        'Effort is a manually supplied session condition, not measured force.',
        'Combination classes need real combination samples; no waveform addition or unseen-combination claim.']
    return model,report


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--manifest',required=True)
    ap.add_argument('--out-dir',default='data/models/gesture14_candidate')
    ap.add_argument('--seed',type=int,default=20261023)
    args=ap.parse_args()
    out=Path(args.out_dir)
    if not out.is_absolute():out=ROOT/out
    out=out.resolve()
    production=(ROOT/'data/models/nn_int8_board_multiwear').resolve()
    if out==production or production in out.parents:
        ap.error('choose a separate offline candidate output directory')
    if out.exists():ap.error('output directory already exists; choose a new candidate directory')
    try:
        rows=load_manifest(args.manifest)
        model,report=train(rows,args.seed)
    except (OSError,ValueError) as exc:ap.error(str(exc))
    out.mkdir(parents=True)
    joblib.dump(dict(pipeline=model,classes=LABELS,action_schema=SCHEMA,pl_compatible=False),out/'candidate.joblib')
    (out/'metrics.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
    print(json.dumps(dict(output=str(out),pl_compatible=False,test=report['held_out_test']),indent=2))


if __name__=='__main__':main()

