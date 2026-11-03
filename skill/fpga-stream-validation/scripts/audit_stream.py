"""Read-only CSV sequence/rail audit, independent of any FPGA repository.

Python standard library only. Labels and physical units are never inferred.
"""
import argparse
import csv
import hashlib
import json
import math
from pathlib import Path


def audit(path, columns, sequence='sequence', bits=16, rail_limit=None):
    if not columns or len(set(columns)) != len(columns):
        raise ValueError('provide unique signal column names')
    if not 2 <= bits <= 32 or (rail_limit is not None and rail_limit < 2):
        raise ValueError('invalid counter width or signed ADC limit')
    modulus=1 << bits
    rows=gaps=duplicates=backwards=wraps=0
    previous=None
    events=[]
    stats={c: dict(min=None,max=None,sum=0,sumsq=0,rail_samples=0) for c in columns}
    with Path(path).open(encoding='utf-8-sig',newline='') as stream:
        reader=csv.DictReader(stream)
        if len(reader.fieldnames or []) != len(set(reader.fieldnames or [])):
            raise ValueError('duplicate CSV column names')
        missing=set(columns+[sequence])-set(reader.fieldnames or [])
        if missing:
            raise ValueError('missing CSV columns: '+', '.join(sorted(missing)))
        for line,row in enumerate(reader,2):
            try:
                seq=int(row[sequence])
                values=[int(row[c]) for c in columns]
            except (TypeError, ValueError) as e:
                raise ValueError(f'noninteger or missing value at CSV line {line}') from e
            if not 0 <= seq < modulus:
                raise ValueError(f'sequence outside declared counter width at line {line}')
            if previous is not None:
                delta=(seq-previous)%modulus
                kind=None
                if delta==0:
                    duplicates+=1;kind='duplicate'
                elif delta>=modulus//2:
                    backwards+=1;kind='backward_or_ambiguous_large_gap'
                else:
                    wraps+=int(seq<previous)
                    gaps+=delta-1
                    if delta>1:kind='forward_gap'
                if kind and len(events)<50:
                    events.append(dict(row=rows,previous=previous,sequence=seq,kind=kind))
            for c,v in zip(columns,values):
                s=stats[c]
                s['min']=v if s['min'] is None else min(s['min'],v)
                s['max']=v if s['max'] is None else max(s['max'],v)
                s['sum']+=v;s['sumsq']+=v*v
                if rail_limit is not None and (v<=-rail_limit or v>=rail_limit-1):
                    s['rail_samples']+=1
            previous=seq;rows+=1
    if not rows:
        raise ValueError('empty recording')
    for s in stats.values():
        total=s.pop('sum')
        mean=total/rows
        # Integer numerator avoids cancellation when a small AC signal has a large DC offset.
        s['ac_rms_counts']=math.sqrt((rows*s.pop('sumsq')-total*total)/(rows*rows))
        s['mean_counts']=mean
        if rail_limit is None:s['rail_samples']=None
    digest=hashlib.sha256()
    with Path(path).open('rb') as stream:
        for block in iter(lambda: stream.read(1024*1024),b''):digest.update(block)
    return dict(source=str(Path(path)),sha256=digest.hexdigest(),rows=rows,
                sequence_bits=bits,forward_missing=gaps,duplicates=duplicates,
                backwards_or_ambiguous=backwards,wraps=wraps,events_first50=events,
                signal_columns=stats,signed_rail_limit=rail_limit,
                interpretation='Counts only. Rail absence does not prove analog linearity; counter jumps of half-range or more are ambiguous. No label or real-time reconstruction.')


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('csv',type=Path)
    parser.add_argument('--signal-columns',required=True,help='comma-separated integer ADC columns')
    parser.add_argument('--sequence-column',default='sequence')
    parser.add_argument('--counter-bits',type=int,default=16)
    parser.add_argument('--signed-rail-limit',type=int,help='2^(ADC_bits-1), e.g. 8388608 for signed24')
    parser.add_argument('--output',type=Path,help='create a NEW JSON; existing file is refused')
    args=parser.parse_args()
    result=audit(args.csv,[c.strip() for c in args.signal_columns.split(',') if c.strip()],
                 args.sequence_column,args.counter_bits,args.signed_rail_limit)
    payload=json.dumps(result,ensure_ascii=False,indent=2,allow_nan=False)+'\n'
    if args.output:
        with args.output.open('x',encoding='utf-8') as f:f.write(payload)
    else:print(payload,end='')


if __name__=='__main__':
    main()
