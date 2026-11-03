"""Validate a copied FPGA skill package using only the Python standard library.

Checks entrypoint identity, local Markdown links and Python syntax, then runs
portable-tool regression tests. Does not run vendor tools or certify RTL.
"""
import ast
import hashlib
import json
import re
import subprocess
import sys
from pathlib import Path

BASE=Path(__file__).resolve().parent
NAMES=('fpga-build-release','fpga-stream-validation','fpga-ps-pl-debug','fpga-design-report')


def main():
    errors=[]
    links=0
    for name in NAMES:
        entry=BASE/name/'SKILL.md'
        if not entry.is_file():
            errors.append('Missing entrypoint: '+name)
            continue
        content=entry.read_text(encoding='utf-8-sig')
        match=re.match(r'\A---\r?\n(.*?)\r?\n---(?:\r?\n|$)',content,re.S)
        if not match:
            errors.append('Missing frontmatter: '+name)
            continue
        if not re.search(r'^name: '+re.escape(name)+r'\s*$',match[1],re.M):
            errors.append('Entrypoint name mismatch: '+name)
        if not re.search(r'^description: \S.+$',match[1],re.M):
            errors.append('Missing description: '+name)
    files=sorted(p for p in BASE.rglob('*') if p.is_file() and '__pycache__' not in p.parts)
    for path in files:
        if path.suffix=='.py':
            try:ast.parse(path.read_text(encoding='utf-8-sig'),filename=str(path))
            except SyntaxError as exc:errors.append(str(exc))
        if path.suffix!='.md':continue
        for target in re.findall(r'\]\(([^)]+)\)',path.read_text(encoding='utf-8-sig')):
            if '://' in target or target.startswith('#'):continue
            target=target.split('#')[0]
            resolved=(path.parent/target).resolve()
            links+=1
            if not resolved.is_relative_to(BASE) or not resolved.exists():
                errors.append(f'Nonportable/broken link: {path.relative_to(BASE)} -> {target}')
    manifest=BASE/'package_manifest.json'
    manifest_verified=None
    if manifest.is_file():
        expected=json.loads(manifest.read_text(encoding='utf-8'))['sha256']
        actual={p.relative_to(BASE).as_posix():hashlib.sha256(p.read_bytes()).hexdigest()
                for p in files if p!=manifest}
        manifest_verified=expected==actual
        if not manifest_verified:errors.append('Package files differ from manifest')
    result=subprocess.run([sys.executable,'-X','utf8',str(BASE/'test_portable_tools.py')],
                          cwd=BASE,capture_output=True,text=True,encoding='utf-8')
    if result.returncode:errors.append('Portable tool tests failed')
    print(json.dumps(dict(passed=not errors,skills=len(NAMES),files=len(files),local_links=links,
                          manifest_verified=manifest_verified,
                          errors=errors,tool_tests=dict(exit_code=result.returncode,
                          stdout=result.stdout,stderr=result.stderr),
                          scope='Local package and portable tools only; entrypoint check is not a full YAML validator. No vendor build or board validation.'),
                     ensure_ascii=False,indent=2))
    return 1 if errors else 0


if __name__=='__main__':
    raise SystemExit(main())
