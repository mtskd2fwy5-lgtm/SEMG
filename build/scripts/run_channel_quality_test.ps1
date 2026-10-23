$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$vcvars = 'D:\c++\VC\Auxiliary\Build\vcvars64.bat'
$out = Join-Path $root 'sim\results_quality'
New-Item -ItemType Directory -Force $out | Out-Null
& cmd /c "call `"$vcvars`" >nul && cl /nologo /utf-8 /std:c11 /O2 /W4 /WX /D_CRT_SECURE_NO_WARNINGS `"$root\sim\channel_quality_test.c`" /Fo:`"$out\channel_quality_test.obj`" /Fe:`"$out\channel_quality_test.exe`""
if ($LASTEXITCODE -ne 0) { throw 'Channel quality compile failed' }
& "$out\channel_quality_test.exe"
if ($LASTEXITCODE -ne 0) { throw 'Channel quality tests failed' }
& python "$root\sim\test_channel_quality_reference.py"
if ($LASTEXITCODE -ne 0) { throw 'Channel quality numerical reference failed' }
