"""Compare two exported metric JSON files without mixing stages/contracts.

Input: metadata {target, tool_version, stage, constraints, workload}, metrics {name: number}.
This compares supplied measurements; it does not extract or certify vendor reports.
"""
import argparse
import json
import math
from pathlib import Path


def compare(before, after):
    required=['target','tool_version','stage','constraints','workload']
    for key in required:
        a=before.get('metadata',{}).get(key)
        b=after.get('metadata',{}).get(key)
        if not isinstance(a,str) or not a.strip() or not isinstance(b,str) or a!=b:
            raise ValueError('incomparable metadata: '+key)
    a=before.get('metrics',{})
    b=after.get('metrics',{})
    if not a or a.keys()!=b.keys():
        raise ValueError('provide the same nonempty metric keys in both files')
    result={}
    for key,x in a.items():
        y=b[key]
        if any(isinstance(v,bool) or not isinstance(v,(int,float)) or not math.isfinite(v) for v in [x,y]):
            raise ValueError('metric must be finite numeric: '+key)
        result[key]=dict(before=x,after=y,delta=y-x,
                         relative_change_percent=(y-x)/x*100 if x>0 else None)
    return dict(metadata=before['metadata'],metrics=result,
                interpretation='Compare original reports too. Positive timing slack is not measured Fmax; no automatic faster/better judgment.')


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('baseline',type=Path);p.add_argument('candidate',type=Path)
    args=p.parse_args()
    print(json.dumps(compare(json.loads(args.baseline.read_text(encoding='utf-8-sig')),
                             json.loads(args.candidate.read_text(encoding='utf-8-sig'))),indent=2,allow_nan=False))


if __name__=='__main__':
    main()
