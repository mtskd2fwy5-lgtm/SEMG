$ErrorActionPreference='Stop'
$root=(Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$out=Join-Path $root 'sim/results_hand'
$bin='D:/FPGA/VIVADO/2025.2/Vivado/bin'
New-Item -ItemType Directory -Force $out | Out-Null
& cmd /c "call `"D:\c++\VC\Auxiliary\Build\vcvars64.bat`" >nul && cl /nologo /utf-8 /std:c11 /O2 /D_CRT_SECURE_NO_WARNINGS `"$root/sim/hand_firmware_test.c`" /Fo:`"$out/hand_firmware_test.obj`" /Fe:`"$out/hand_firmware_test.exe`""
if($LASTEXITCODE -ne 0){throw 'Hand firmware test compile failed'}
Push-Location $root
try {& "$out/hand_firmware_test.exe";if($LASTEXITCODE -ne 0){throw 'Hand firmware test failed'}} finally {Pop-Location}
Push-Location $out
try {
 & "$bin/xvlog.bat" -sv "$root/src/rtl/hand_servo_pwm.v" "$root/src/rtl/hand_control.v" "$root/sim/hand_control_tb.sv"
 if($LASTEXITCODE -ne 0){throw 'Hand RTL compile failed'}
 & "$bin/xelab.bat" hand_control_tb -s hand_sim -debug typical
 if($LASTEXITCODE -ne 0){throw 'Hand RTL elaboration failed'}
 & "$bin/xsim.bat" hand_sim -runall -log hand.log
 if($LASTEXITCODE -ne 0 -or !(Select-String -Path hand.log -SimpleMatch 'TEST_PASS hand control:')){throw 'Hand controller simulation failed'}
} finally {Pop-Location}
