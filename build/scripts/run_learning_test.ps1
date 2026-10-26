$ErrorActionPreference='Stop'
$root=(Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$out=Join-Path $root 'sim/results_learning'
$bin='D:/FPGA/VIVADO/2025.2/Vivado/bin'
& python "$root/tools/gen_learning_vectors.py"
if($LASTEXITCODE -ne 0){throw 'Learning vector generation failed'}
& cmd /c "call `"D:\c++\VC\Auxiliary\Build\vcvars64.bat`" >nul && cl /nologo /utf-8 /std:c11 /O2 /D_CRT_SECURE_NO_WARNINGS `"$root/sim/pl_learning_workflow_test.c`" /Fo:`"$out/pl_learning_workflow_test.obj`" /Fe:`"$out/pl_learning_workflow_test.exe`""
if($LASTEXITCODE -ne 0){throw 'PL learning workflow compile failed'}
& "$out/pl_learning_workflow_test.exe"
if($LASTEXITCODE -ne 0){throw 'PL learning workflow failed'}
Push-Location $out
try {
 & "$bin/xvlog.bat" -sv "$root/src/rtl/learning_div64.v" "$root/src/rtl/emg_learning_accel.v" "$root/sim/emg_learning_accel_tb.sv"
 if($LASTEXITCODE -ne 0){throw 'Learning RTL compile failed'}
 & "$bin/xelab.bat" emg_learning_accel_tb -s learning_sim -debug typical
 if($LASTEXITCODE -ne 0){throw 'Learning RTL elaboration failed'}
 & "$bin/xsim.bat" learning_sim -runall -log learning.log
 if($LASTEXITCODE -ne 0 -or !(Select-String -Path learning.log -SimpleMatch 'TEST_PASS learning accelerator complete')){throw 'Learning RTL test failed'}
} finally {Pop-Location}
