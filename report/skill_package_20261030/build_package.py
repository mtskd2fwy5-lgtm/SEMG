"""Build and validate a portable FPGA skill ZIP from the repository skill/ directory."""
import hashlib
import json
import subprocess
import sys
import tempfile
import zipfile
from pathlib import Path

ROOT=Path(__file__).resolve().parents[2]
SOURCE=ROOT/'skill'
REPORT=Path(__file__).resolve().parent
DEST=REPORT/'FPGA_Development_Skills_20261030.zip'


def digest(data):
    return hashlib.sha256(data).hexdigest()


def main():
    paths=sorted(p for p in SOURCE.rglob('*') if p.is_file() and '__pycache__' not in p.parts)
    payload={p.relative_to(SOURCE).as_posix():p.read_bytes() for p in paths}
    assert 'package_manifest.json' not in payload
    manifest=dict(name='FPGA Development Skills',version='20261030-generic-v2',
                  scope='Generic FPGA workflows, portable tools and summarized source cases; no vendor toolchain or raw project data.',
                  sha256={name:digest(data) for name,data in payload.items()})
    payload['package_manifest.json']=(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n').encode('utf-8')
    # Explicit owned output; input files are never altered by packaging.
    with zipfile.ZipFile(DEST,'w',compression=zipfile.ZIP_DEFLATED) as archive:
        for name,data in payload.items():
            info=zipfile.ZipInfo('fpga-skills/'+name,date_time=(2026,10,30,0,0,0))
            info.compress_type=zipfile.ZIP_DEFLATED
            archive.writestr(info,data)
    with tempfile.TemporaryDirectory() as folder:
        folder=Path(folder)
        with zipfile.ZipFile(DEST) as archive:
            assert archive.testzip() is None
            for entry in archive.infolist():
                target=(folder/entry.filename).resolve()
                assert target.is_relative_to(folder.resolve())
            archive.extractall(folder)
        extracted=folder/'fpga-skills'
        for name,data in payload.items():
            assert (extracted/name).read_bytes()==data
        check=subprocess.run([sys.executable,'-X','utf8',str(extracted/'validate_package.py')],
                             cwd=folder,capture_output=True,text=True,encoding='utf-8')
        details=json.loads(check.stdout)
        assert check.returncode==0 and details['passed'] and details['manifest_verified'] is True,check.stdout+check.stderr
        example_results=[]
        commands=[['fpga-stream-validation/scripts/audit_stream.py','examples/stream.csv',
                   '--signal-columns','value0,value1','--sequence-column','seq'],
                  ['fpga-build-release/scripts/compare_resources.py','examples/baseline.json','examples/candidate.json']]
        for args in commands:
            result=subprocess.run([sys.executable,'-X','utf8']+args,cwd=extracted,
                                  capture_output=True,text=True,encoding='utf-8')
            assert result.returncode==0,result.stderr
            example_results.append(json.loads(result.stdout))
        assert example_results[0]['wraps']==1 and example_results[0]['forward_missing']==1
        assert example_results[1]['metrics']['lut']['relative_change_percent']==-30
        assert example_results[1]['metrics']['latency_cycles']['delta']==0
        # Ensure the manifest actually detects altered content.
        altered=extracted/'examples/stream.csv'
        altered.write_bytes(altered.read_bytes()+b'3,0,0\n')
        bad=subprocess.run([sys.executable,'-X','utf8',str(extracted/'validate_package.py')],
                           cwd=folder,capture_output=True,text=True,encoding='utf-8')
        bad_details=json.loads(bad.stdout)
        assert bad.returncode!=0 and bad_details['manifest_verified'] is False
    report=dict(passed=True,archive=DEST.name,archive_sha256=digest(DEST.read_bytes()),
                archive_bytes=DEST.stat().st_size,source_files=len(paths),archive_files=len(payload),
                extracted_check=details,examples_passed=True,tamper_rejected=True,
                file_sha256=manifest['sha256'],
                scope='Temporary extraction outside repository; self-check and example tools. No FPGA build, board or independent-team validation.')
    (REPORT/'distribution.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(json.dumps({k:report[k] for k in ['passed','archive','archive_sha256','archive_bytes','source_files','archive_files','examples_passed']}))


if __name__=='__main__':
    main()
