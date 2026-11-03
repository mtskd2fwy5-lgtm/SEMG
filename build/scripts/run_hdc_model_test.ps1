param([string]$ReportDir='report/hdc_model_sd_20261029',[switch]$SkipLCD)
$ErrorActionPreference='Stop'
$root=(Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$vcvars='D:\c++\VC\Auxiliary\Build\vcvars64.bat'
$out=Join-Path $root $ReportDir
New-Item -ItemType Directory -Force $out | Out-Null
Push-Location $root
try {
 foreach($case in @(
  @('hdc_model_store_test','model_test'),@('sd_record_test','sd_test'),
  @('hand_firmware_test','hand_test'),@('pl_learning_workflow_test','learning_workflow_test'),
  @('uart_record_firmware_test','uart_test'))) {
  $source=$case[0];$log=$case[1]
  & cmd /c "call `"$vcvars`" >nul && cl /nologo /utf-8 /std:c11 /O2 /D_CRT_SECURE_NO_WARNINGS sim/$source.c /Fo:`"$out/$source.obj`" /Fe:`"$out/$source.exe`" > `"$out/$log.log`" 2>&1 && `"$out/$source.exe`" >> `"$out/$log.log`" 2>&1"
  if($LASTEXITCODE -ne 0){throw "HDC model regression failed: $source"}
 }
 if(!$SkipLCD){
  & powershell -NoProfile -ExecutionPolicy Bypass -File build/scripts/run_lcd_firmware_test.ps1 > "$out/lcd_test.log" 2>&1
  if($LASTEXITCODE -ne 0){throw 'LCD model library regression failed'}
 }
} finally {Pop-Location}
