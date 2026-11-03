"""Executable examples for the two portable skill utilities; no hardware access."""
import csv
import importlib.util
import json
import math
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

sys.dont_write_bytecode=True
BASE=Path(__file__).resolve().parent


def load(name,relative):
    spec=importlib.util.spec_from_file_location(name,BASE/relative)
    module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
    return module


def main():
    audit=load('stream_audit','fpga-stream-validation/scripts/audit_stream.py').audit
    compare=load('resource_compare','fpga-build-release/scripts/compare_resources.py').compare
    with tempfile.TemporaryDirectory() as folder:
        p=Path(folder)/'input.csv'
        with p.open('w',newline='',encoding='utf-8') as f:
            w=csv.writer(f);w.writerow(['seq','adc'])
            w.writerows(zip([65534,65535,0,2,2,1],[-8388608,8388607,0,3,-3,0]))
        h=p.read_bytes();r=audit(p,['adc'],'seq',16,8388608)
        assert (r['rows'],r['wraps'],r['forward_missing'],r['duplicates'],r['backwards_or_ambiguous'])==(6,1,1,1,1)
        assert r['signal_columns']['adc']['rail_samples']==2 and p.read_bytes()==h
        assert audit(p,['adc'],'seq')['signal_columns']['adc']['rail_samples'] is None
        try:audit(p,['missing'],'seq')
        except ValueError:pass
        else:raise AssertionError('missing column accepted')
        p.write_text('seq,adc\n70000,1\n',encoding='utf-8')
        try:audit(p,['adc'],'seq')
        except ValueError:pass
        else:raise AssertionError('out-of-range counter accepted')
        p.write_text('seq,adc\n0,not_an_integer\n',encoding='utf-8')
        try:audit(p,['adc'],'seq')
        except ValueError:pass
        else:raise AssertionError('noninteger ADC accepted')
    meta=dict(target='example_fpga',tool_version='example_version',stage='routed',constraints='clock_and_io_v1',workload='fixed_contract')
    a=dict(metadata=meta,metrics=dict(lut=100,wns_ns=0.0))
    b=dict(metadata=dict(meta),metrics=dict(lut=70,wns_ns=0.1))
    r=compare(a,b);assert r['metrics']['lut']['relative_change_percent']==-30
    assert r['metrics']['wns_ns']['relative_change_percent'] is None
    b['metadata']['stage']='synth'
    try:compare(a,b)
    except ValueError:pass
    else:raise AssertionError('mixed implementation stages accepted')
    b['metadata']['stage']='routed'
    b['metadata']['constraints']='clock_and_io_v2'
    try:compare(a,b)
    except ValueError:pass
    else:raise AssertionError('mixed constraints accepted')
    invalid=dict(metadata=dict(meta),metrics=dict(lut=float('nan'),wns_ns=0.1))
    try:compare(a,invalid)
    except ValueError:pass
    else:raise AssertionError('nonfinite metric accepted')
    with tempfile.TemporaryDirectory() as folder:
        folder=Path(folder)
        source=folder/'input.csv'
        source.write_text('seq,adc\n0,8388606\n1,8388607\n',encoding='utf-8')
        result=folder/'audit.json'
        # Exercise portable copies outside the repository and from an unrelated cwd.
        isolated=folder/'copied_tools'
        isolated.mkdir()
        for path in ['fpga-stream-validation/scripts/audit_stream.py','fpga-build-release/scripts/compare_resources.py']:
            shutil.copy2(BASE/path,isolated/Path(path).name)
        audit_cli=[sys.executable,'-X','utf8',str(isolated/'audit_stream.py')]
        compare_cli=[sys.executable,'-X','utf8',str(isolated/'compare_resources.py')]
        for cli in [audit_cli,compare_cli]:
            subprocess.run(cli+['--help'],cwd=folder,check=True,capture_output=True)
        args=[str(source),'--signal-columns','adc','--sequence-column','seq','--signed-rail-limit','8388608','--output',str(result)]
        original=source.read_bytes()
        subprocess.run(audit_cli+args,cwd=folder,check=True,capture_output=True)
        parsed=json.loads(result.read_text(encoding='utf-8'))
        assert math.isclose(parsed['signal_columns']['adc']['ac_rms_counts'],0.5)
        assert source.read_bytes()==original
        saved=result.read_bytes()
        assert subprocess.run(audit_cli+args,capture_output=True).returncode!=0
        assert result.read_bytes()==saved
        source.write_text('seq,adc,adc\n0,1,2\n',encoding='utf-8')
        assert subprocess.run(audit_cli+[str(source),'--signal-columns','adc','--sequence-column','seq'],capture_output=True).returncode!=0
        before=folder/'before.json';after=folder/'after.json'
        before.write_text(json.dumps(a),encoding='utf-8')
        b['metadata']['constraints']='clock_and_io_v1'
        after.write_text(json.dumps(b),encoding='utf-8')
        proc=subprocess.run(compare_cli+[str(before),str(after)],cwd=folder,check=True,capture_output=True,text=True)
        assert json.loads(proc.stdout)['metrics']['lut']['delta']==-30
        b['metadata']['stage']='synth';after.write_text(json.dumps(b),encoding='utf-8')
        assert subprocess.run(compare_cli+[str(before),str(after)],capture_output=True).returncode!=0
    print('TEST_PASS portable tools: sequence wrap/gap/duplicate/ambiguous-backward, exact signed rails, immutable input, schema rejection, comparable resource delta and stage mismatch refusal')
    print('TEST_PASS CLI: help, JSON output, no overwrite, duplicate headers, small AC on large DC, resource comparison, stage/constraint mismatch refusal')
    print('TEST_PASS portability: copied standalone scripts run outside repository with unrelated working directory')


if __name__=='__main__':
    main()

