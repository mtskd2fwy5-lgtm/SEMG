$ErrorActionPreference='Stop'
$root=(Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$out=Join-Path $root 'report/hdc_stability_20261027'
New-Item -ItemType Directory -Force $out | Out-Null
Push-Location $root
try {
 & cmd /c "powershell -NoProfile -ExecutionPolicy Bypass -File build/scripts/run_lcd_firmware_test.ps1 > `"$out/lcd_test.log`" 2>&1"
 if($LASTEXITCODE -ne 0){throw 'LCD HDC regression failed'}
 foreach($test in @(@('hand_firmware_test','hand_test.log'),@('pl_learning_workflow_test','learning_workflow_test.log'))) {
  $name=$test[0];$log=$test[1]
  & cmd /c "call `"D:\c++\VC\Auxiliary\Build\vcvars64.bat`" >nul && cl /nologo /utf-8 /std:c11 /O2 /D_CRT_SECURE_NO_WARNINGS sim/$name.c /Fo:`"$out/$name.obj`" /Fe:`"$out/$name.exe`" > `"$out/$name.compile.log`" 2>&1 && `"$out/$name.exe`" > `"$out/$log`" 2>&1"
  if($LASTEXITCODE -ne 0){throw "Failed: $name"}
 }
 & python -c "from pathlib import Path; import hashlib,json; paths=list(Path('sw/ps_uart_print').rglob('*')); paths += [Path(p) for p in ['sim/hand_firmware_test.c','sim/control_policy_reference.c','sim/lcd_firmware_test.c','sim/pl_learning_workflow_test.c','build/scripts/run_hdc_stability_test.ps1','build/scripts/run_lcd_firmware_test.ps1']]; proof={p.as_posix():hashlib.sha256(p.read_bytes()).hexdigest() for p in paths if p.is_file() and p.suffix.lower() in ('.c','.h','.s','.ld','.ps1')}; Path('report/hdc_stability_20261027/regression_sources.json').write_text(json.dumps(proof,indent=2))"
 if($LASTEXITCODE -ne 0){throw 'Could not bind regression sources'}
 Write-Host 'TEST_PASS V16 HDC stability regression complete'
} finally {Pop-Location}
