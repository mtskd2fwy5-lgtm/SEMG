$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$vcvars = 'D:\c++\VC\Auxiliary\Build\vcvars64.bat'
$out = Join-Path $root 'sim\results_rehab'
New-Item -ItemType Directory -Force $out | Out-Null
& cmd /c "call `"$vcvars`" >nul && cl /nologo /utf-8 /std:c11 /O2 /W3 `"$root\sim\rehab_training_test.c`" /Fo:`"$out\rehab_test.obj`" /Fe:`"$out\rehab_test.exe`""
if ($LASTEXITCODE -ne 0) { throw 'Training engine test compile failed' }
& "$out\rehab_test.exe" | Tee-Object -FilePath "$out\test.log"
if ($LASTEXITCODE -ne 0) { throw 'Training engine test failed' }
