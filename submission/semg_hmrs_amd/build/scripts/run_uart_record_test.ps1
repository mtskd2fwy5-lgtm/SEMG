$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$vcvars = '<msvc-tools>
$out = Join-Path $root 'sim\results_uart_record'
New-Item -ItemType Directory -Force $out | Out-Null
& cmd /c "call `"$vcvars`" >nul && cl /nologo /utf-8 /std:c11 /O2 /W3 /wd4244 /wd4267 /wd4312 /wd4334 /wd4996 `"$root\sim\uart_record_firmware_test.c`" /Fo:`"$out\uart_record_test.obj`" /Fe:`"$out\uart_record_test.exe`""
if ($LASTEXITCODE -ne 0) { throw 'UART firmware test compile failed' }
& "$out\uart_record_test.exe" | Tee-Object -FilePath "$out\firmware_test.log"
if ($LASTEXITCODE -ne 0) { throw 'UART firmware test failed' }
if (!(Select-String -Path "$out\firmware_test.log" -Pattern 'TEST_PASS uart_record:' -Quiet)) { throw 'UART firmware PASS missing' }

