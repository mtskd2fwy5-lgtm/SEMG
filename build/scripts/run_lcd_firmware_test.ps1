$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$vcvars = 'D:\c++\VC\Auxiliary\Build\vcvars64.bat'
$out = Join-Path $root 'sim\results_lcd'
New-Item -ItemType Directory -Force $out | Out-Null
& cmd /c "call `"$vcvars`" >nul && cl /nologo /utf-8 /std:c11 /O2 /W3 /wd4244 /wd4267 /wd4312 /wd4334 /wd4996 `"$root\sim\lcd_firmware_test.c`" /Fo:`"$out\lcd_firmware_test.obj`" /Fe:`"$out\lcd_firmware_test.exe`""
if ($LASTEXITCODE -ne 0) { throw 'LCD host test compile failed' }
Push-Location $out
try {
    & '.\lcd_firmware_test.exe' | Tee-Object -FilePath 'firmware_test.log'
    if ($LASTEXITCODE -ne 0) { throw 'LCD host test failed' }
} finally { Pop-Location }
