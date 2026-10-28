"""Use the skill renderer and installed Word for PDF conversion on Windows."""
import importlib.util
from pathlib import Path
import subprocess
import sys

sys.stdout.reconfigure(encoding='utf-8')
skill=Path('C:/Users/bvcm/.codex/plugins/cache/openai-primary-runtime/documents/26.905.11957/skills/documents/render_docx.py')
spec=importlib.util.spec_from_file_location('render_docx',skill)
renderer=importlib.util.module_from_spec(spec);spec.loader.exec_module(renderer)

def convert(doc_path,user_profile,convert_tmp_dir,stem,verbose):
    pdf=Path(convert_tmp_dir)/(stem+'.pdf')
    script=Path(__file__).with_name('word_pdf.ps1')
    proc=subprocess.run(['powershell','-NoProfile','-ExecutionPolicy','Bypass','-File',str(script),'-Source',str(Path(doc_path).resolve()),'-Destination',str(pdf)],capture_output=True,text=True,encoding='utf-8',errors='replace',timeout=180)
    log=(proc.stdout or '')+(proc.stderr or '')
    if proc.returncode or not pdf.is_file():return '',log
    return str(pdf),log

renderer.convert_to_pdf=convert
renderer.main()
