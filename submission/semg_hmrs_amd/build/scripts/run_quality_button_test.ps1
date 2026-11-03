$ErrorActionPreference='Stop'
$root=(Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$out=Join-Path $root 'report/hdc_custom_bridge_20261101'
$vcvars='<msvc-tools>
New-Item -ItemType Directory -Force $out | Out-Null
Push-Location $root
try {
  & cmd /c "call `"$vcvars`" >nul && cl /nologo /utf-8 /std:c11 /O2 /W3 /wd4244 /wd4267 /wd4312 /wd4334 /wd4996 sim/channel_quality_test.c /Fo:`"$out/channel_quality_test.obj`" /Fe:`"$out/channel_quality_test.exe`" > `"$out/quality_compile.log`" 2>&1"
  if($LASTEXITCODE -ne 0){throw 'channel_quality_test compile failed'}
  & "$out/channel_quality_test.exe" | Tee-Object -FilePath "$out/quality_test.log"
  if($LASTEXITCODE -ne 0){throw 'channel_quality_test failed'}
  & cmd /c "call `"$vcvars`" >nul && cl /nologo /utf-8 /std:c11 /O2 /W3 /wd4244 /wd4267 /wd4312 /wd4334 /wd4996 sim/lcd_work_budget_test.c /Fo:`"$out/lcd_work_budget_test.obj`" /Fe:`"$out/lcd_work_budget_test.exe`" > `"$out/budget_compile.log`" 2>&1"
  if($LASTEXITCODE -ne 0){throw 'lcd_work_budget_test compile failed'}
  & "$out/lcd_work_budget_test.exe" | Tee-Object -FilePath "$out/budget_test.log"
  if($LASTEXITCODE -ne 0){throw 'lcd_work_budget_test failed'}
  & python sim/test_channel_quality_reference.py *>&1 | Tee-Object -FilePath "$out/numeric_validation.log"
  if($LASTEXITCODE -ne 0){throw 'channel quality numerical reference failed'}
  Write-Host 'TEST_PASS quality button regression complete'
} finally {Pop-Location}

