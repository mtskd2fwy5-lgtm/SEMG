$ErrorActionPreference='Stop'
$root=(Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$out=Join-Path $root 'sim/results_learning_resource_baseline'
$rtl=Join-Path $PSScriptRoot 'baseline/src/rtl'
$bin='D:/FPGA/VIVADO/2025.2/Vivado/bin'
New-Item -ItemType Directory -Force $out | Out-Null
Copy-Item -LiteralPath "$root/sim/results_learning/learning_vectors.mem" -Destination $out -Force
Push-Location $out
try {
 & "$bin/xvlog.bat" -sv "$rtl/learning_div64.v" "$rtl/emg_learning_accel.v" "$root/sim/emg_learning_accel_tb.sv"
 if($LASTEXITCODE -ne 0){throw 'Frozen learning RTL compile failed'}
 & "$bin/xelab.bat" emg_learning_accel_tb -s baseline_learning -debug typical
 if($LASTEXITCODE -ne 0){throw 'Frozen learning elaboration failed'}
 & "$bin/xsim.bat" baseline_learning -runall -log baseline_learning.log
 if($LASTEXITCODE -ne 0 -or !(Select-String -Path baseline_learning.log -SimpleMatch 'TEST_PASS learning accelerator complete')){
  throw 'Frozen learning regression failed'
 }
} finally {Pop-Location}
