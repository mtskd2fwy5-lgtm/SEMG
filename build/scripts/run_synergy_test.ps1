$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$vcvars = 'D:\c++\VC\Auxiliary\Build\vcvars64.bat'
$out = Join-Path $root 'sim\results_synergy'
New-Item -ItemType Directory -Force $out | Out-Null
& cmd /c "call `"$vcvars`" >nul && cl /nologo /utf-8 /std:c11 /O2 /W4 /WX /D_CRT_SECURE_NO_WARNINGS `"$root\sim\synergy_nmf_test.c`" /Fo:`"$out\synergy_nmf_test.obj`" /Fe:`"$out\synergy_nmf_test.exe`""
if ($LASTEXITCODE -ne 0) { throw 'Synergy host test compile failed' }
& "$out\synergy_nmf_test.exe"
if ($LASTEXITCODE -ne 0) { throw 'Synergy edge-case test failed' }
& python "$root\sim\test_synergy_reference.py"
if ($LASTEXITCODE -ne 0) { throw 'Synergy capture replay failed' }
