"""Reproduce local package checks. Does not run FPGA tools or modify firmware."""
import hashlib
import json
import re
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

ROOT=Path(__file__).resolve().parents[2]
PACKAGE=ROOT/'skill'
REPORT=Path(__file__).resolve().parent
VALIDATOR=Path.home()/'.codex/skills/.system/skill-creator/scripts/quick_validate.py'


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def command(args):
    result=subprocess.run(args,cwd=ROOT,capture_output=True,text=True,encoding='utf-8')
    return dict(command=[str(x) for x in args],exit_code=result.returncode,
                stdout=result.stdout,stderr=result.stderr)


def main():
    skills=sorted(p for p in PACKAGE.glob('fpga-*') if p.is_dir())
    tests=[command([sys.executable,'-X','utf8',PACKAGE/'test_portable_tools.py'])]
    tests.extend(command([sys.executable,'-X','utf8',VALIDATOR,p]) for p in skills)
    missing=[];links=[];evidence=set()
    for path in PACKAGE.rglob('*.md'):
        content=path.read_text(encoding='utf-8-sig')
        for target in re.findall(r'\]\(([^)]+)\)',content):
            if '://' in target or target.startswith('#'):
                continue
            resolved=(path.parent/target.split('#')[0]).resolve()
            # validation.json is this check's output, created after collecting links.
            exists=resolved.exists() or resolved==REPORT/'validation.json'
            links.append(dict(source=str(path.relative_to(ROOT)),target=target,exists=exists))
            if not exists:missing.append(str(resolved))
        for target in re.findall(r'`((?:report|tools|build|sw|src|sim|board)/[^`\s]+)`',content):
            if any(part in target for part in ['本次','实际']):continue
            resolved=ROOT/target
            if not resolved.exists():missing.append(target)
            elif resolved.is_file():evidence.add(target)
    # Evidence named relative to a report directory in prose.
    relative_evidence={
        'resource_optimization_v15_20261027':['comparison.json','equivalence.log','netlist_test_complete.log','integrated_test.log'],
        'lcd_responsiveness_20261030':['artifacts.json','regression_sources.json','cpu_test.log'],
        'emg002_20261030':['quality_metrics.json','label_correction.json','old_model_metrics.json','single_finger_metrics.json','single_finger_report.md'],
        'hand_pwm_inverted_20261029':['polarity_rtl.log','pin_netlist.log'],
        'channel_quality_20261029':['numeric_validation.json'],
        'imu_pl_20261028':['float_comparison.json'],
    }
    for directory,names in relative_evidence.items():
        for name in names:
            target='report/'+directory+'/'+name
            if not (ROOT/target).is_file():missing.append(target)
            else:evidence.add(target)
    files={str(p.relative_to(ROOT)).replace('\\','/'):sha(p)
           for p in sorted(PACKAGE.rglob('*')) if p.is_file() and '__pycache__' not in p.parts}
    result=dict(timestamp_utc=datetime.now(timezone.utc).isoformat(),
                scope='Skill package format, portable tools, relative links and local evidence existence/hash. No new FPGA/board or cross-team end-to-end validation.',
                tests=tests,links=links,missing=sorted(set(missing)),
                package_sha256=files,evidence_sha256={p:sha(ROOT/p) for p in sorted(evidence)},
                passed=not missing and all(t['exit_code']==0 for t in tests))
    (REPORT/'validation.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(json.dumps(dict(passed=result['passed'],tests=len(tests),links=len(links),
                         package_files=len(files),evidence_files=len(evidence),missing=result['missing']),ensure_ascii=False))
    return 0 if result['passed'] else 1


if __name__=='__main__':
    raise SystemExit(main())
