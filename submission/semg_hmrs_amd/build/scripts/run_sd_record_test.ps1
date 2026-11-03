$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$vcvars = '<msvc-tools>
$out = Join-Path $root 'sim\results_sd_record'
New-Item -ItemType Directory -Force $out | Out-Null
& cmd /c "call `"$vcvars`" >nul && cl /nologo /utf-8 /std:c11 /O2 /W3 `"$root\sim\sd_record_test.c`" /Fo:`"$out\sd_record_test.obj`" /Fe:`"$out\sd_record_test.exe`""
if ($LASTEXITCODE -ne 0) { throw 'SD recorder test compile failed' }
& "$out\sd_record_test.exe" | Tee-Object -FilePath "$out\test.log"
if ($LASTEXITCODE -ne 0) { throw 'SD recorder test failed' }

