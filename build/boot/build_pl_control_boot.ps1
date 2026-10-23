param([string]$Tag='20261023_GRIP_FEEDBACK_V1',
      [string]$ReportDir='report/grip_feedback_20261023')
$ErrorActionPreference='Stop'
if($Tag -notmatch '^[A-Za-z0-9_]+$'){throw 'Invalid BOOT tag'}
$root=(Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
Push-Location $root
try {
 & powershell -ExecutionPolicy Bypass -File build/build_all.ps1 -SkipBuild -SkipBoot
 if($LASTEXITCODE -ne 0){throw 'Hardware acceptance gates failed'}
 & python tools/verify_control_boot.py --hardware-only
 if($LASTEXITCODE -ne 0){throw 'Hardware does not contain the matching PL control mailbox'}
 Push-Location sw/ps_uart_print
 try {& cmd /c build.bat --pl-control;if($LASTEXITCODE -ne 0){throw 'PL-control ARM build failed'}}
 finally {Pop-Location}
 & python tools/verify_control_boot.py --application-only --tag $Tag
 if($LASTEXITCODE -ne 0){throw 'Application build tag mismatch; BOOT was not written'}
 & 'D:/FPGA/VIVADO/2025.2/Vitis/bin/bootgen.bat' -arch zynq -image build/boot/boot_image_pl_control.bif -w -o i "build/boot/BOOT_$Tag.BIN"
 if($LASTEXITCODE -ne 0){throw 'PL-control bootgen failed'}
 & python tools/verify_control_boot.py --tag $Tag --report-dir $ReportDir
 if($LASTEXITCODE -ne 0){throw 'Matched hardware/application BOOT verification failed'}
} finally {Pop-Location}
