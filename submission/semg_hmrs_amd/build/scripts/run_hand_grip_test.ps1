$ErrorActionPreference='Stop'
$root=(Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$out=Join-Path $root 'report/grip_control_20261031'
New-Item -ItemType Directory -Force $out | Out-Null
& cmd /c "call `"<msvc-tools> >nul && cl /nologo /utf-8 /std:c11 /O2 /D_CRT_SECURE_NO_WARNINGS `"$root/sim/hand_grip_test.c`" /Fo:`"$out/hand_grip_test.obj`" /Fe:`"$out/hand_grip_test.exe`""
if($LASTEXITCODE -ne 0){throw 'Grip firmware test compile failed'}
Push-Location $root
try {
 & "$out/hand_grip_test.exe" 2>&1 | Tee-Object -FilePath "$out/grip_test.log"
 if($LASTEXITCODE -ne 0){throw 'Grip firmware test failed'}
} finally {Pop-Location}

