param([switch]$SkipVectors)
$ErrorActionPreference='Stop'
$root=(Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$out=Join-Path $root 'sim/results_control'
$bin='D:/FPGA/VIVADO/2025.2/Vivado/bin'
New-Item -ItemType Directory -Force $out | Out-Null
& cmd /c "call `"D:\c++\VC\Auxiliary\Build\vcvars64.bat`" >nul && cl /nologo /utf-8 /std:c11 /O2 /D_CRT_SECURE_NO_WARNINGS `"$root/sim/control_policy_reference.c`" /Fo:`"$out/control_policy_reference.obj`" /Fe:`"$out/control_policy_reference.exe`""
if($LASTEXITCODE -ne 0){throw 'PS oracle compile failed'}
& cmd /c "call `"D:\c++\VC\Auxiliary\Build\vcvars64.bat`" >nul && cl /nologo /utf-8 /std:c11 /O2 /D_CRT_SECURE_NO_WARNINGS `"$root/sim/pl_control_firmware_test.c`" /Fo:`"$out/pl_control_firmware_test.obj`" /Fe:`"$out/pl_control_firmware_test.exe`""
if($LASTEXITCODE -ne 0){throw 'PL firmware test compile failed'}
Push-Location $root
try {& "$out/pl_control_firmware_test.exe"} finally {Pop-Location}
if($LASTEXITCODE -ne 0){throw 'PL firmware test failed'}
& python "$root/tools/gen_pl_control_constants.py" --check
if($LASTEXITCODE -ne 0){throw 'Control constants differ from PS'}
if(!$SkipVectors){
 & python "$root/sim/test_pl_control.py"
 if($LASTEXITCODE -ne 0){throw 'Vector generation failed'}
}else{
 & python "$root/sim/test_pl_control.py" --check-mapping
 if($LASTEXITCODE -ne 0){throw 'PS selected mapping/MLP equivalence failed'}
}
Push-Location $out
try {
 & "$bin/xvlog.bat" -sv -i "$root/src/rtl" "$root/src/rtl/emg_control_policy.v" "$root/sim/emg_control_policy_tb.sv"
 if($LASTEXITCODE -ne 0){throw 'Policy compile failed'}
 & "$bin/xelab.bat" emg_control_policy_tb -s policy_sim -debug typical
 if($LASTEXITCODE -ne 0){throw 'Policy elaboration failed'}
 & "$bin/xsim.bat" policy_sim -runall -log policy.log
 if($LASTEXITCODE -ne 0 -or !(Select-String -Path policy.log -SimpleMatch 'TEST_PASS policy equivalence')){throw 'Policy equivalence failed'}
 & "$bin/xvlog.bat" -sv -i "$root/src/rtl" "$root/src/rtl/emg_nn_infer.v" "$root/src/rtl/emg_control_inference.v" "$root/src/rtl/hand_servo_pwm.v" "$root/sim/emg_control_inference_tb.sv" "$root/sim/hand_servo_pwm_tb.sv"
 if($LASTEXITCODE -ne 0){throw 'Control/PWM compile failed'}
 foreach($test in @(@('emg_control_inference_tb','inference_sim','TEST_PASS autonomous inference'),@('hand_servo_pwm_tb','pwm_sim','TEST_PASS six-channel PWM'))){
  & "$bin/xelab.bat" $test[0] -s $test[1] -debug typical
  if($LASTEXITCODE -ne 0){throw 'Control/PWM elaboration failed'}
  & "$bin/xsim.bat" $test[1] -runall -log "$($test[1]).log"
  if($LASTEXITCODE -ne 0 -or !(Select-String -Path "$($test[1]).log" -SimpleMatch $test[2])){throw "$($test[0]) failed"}
 }
 $sources=@('ads1299_spi','emg_notch50','emg_comb50','emg_line_filter','emg_bandpass','emg_window_features','emg_feature_bank','emg_fatigue','axis_async_fifo','axis_packet_mux','emg_data_path','hand_control','emg_pl_export','emg_pl_control') | ForEach-Object {"$root/src/rtl/$_.v"}
 & "$bin/xvlog.bat" -sv -i "$root/src/rtl" @sources "$root/sim/emg_pl_control_tb.sv"
 if($LASTEXITCODE -ne 0){throw 'PL shell compile failed'}
 & "$bin/xelab.bat" emg_pl_control_tb -s shell_sim -debug typical
 if($LASTEXITCODE -ne 0){throw 'PL shell elaboration failed'}
 & "$bin/xsim.bat" shell_sim -runall -log shell.log
 if($LASTEXITCODE -ne 0 -or !(Select-String -Path shell.log -SimpleMatch 'TEST_PASS PL shell')){throw 'PL shell test failed'}
} finally {Pop-Location}
