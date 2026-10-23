$ErrorActionPreference='Stop'
$root=(Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$out=Join-Path $root 'sim/results_grip_feedback'
New-Item -ItemType Directory -Force $out | Out-Null
& cmd /c "call `"D:\c++\VC\Auxiliary\Build\vcvars64.bat`" >nul && cl /nologo /utf-8 /std:c11 /O2 /W4 /WX `"$root/sim/synergy_feedback_test.c`" /Fo:`"$out/feedback.obj`" /Fe:`"$out/feedback.exe`""
if($LASTEXITCODE -ne 0){throw 'Grip test compile failed'}
& "$out/feedback.exe"
if($LASTEXITCODE -ne 0){throw 'Grip test failed'}
