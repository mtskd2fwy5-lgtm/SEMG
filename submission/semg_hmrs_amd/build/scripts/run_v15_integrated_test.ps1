$ErrorActionPreference='Stop'
$root=(Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$out=Join-Path $root 'sim/results_v15_integrated'
$bin='<amd-tools>/Vivado/bin'
New-Item -ItemType Directory -Force $out | Out-Null
$names=@('ads1299_spi','emg_notch50','emg_comb50','emg_line_filter','emg_bandpass','emg_window_features','emg_feature_bank','emg_fatigue','axis_async_fifo','axis_packet_mux','emg_data_path','hand_control','hand_servo_pwm','emg_nn_infer','emg_control_inference','emg_control_policy','emg_pl_export','emg_pl_control')
$sources=$names | ForEach-Object {"$root/src/rtl/$_.v"}
Push-Location $out
try{
 & "$bin/xvlog.bat" -sv -i "$root/src/rtl" "$root/report/resource_optimization_v15_20261027/integrated_pl_export.v" @sources "$root/sim/emg_v15_integrated_tb.sv" "$bin/../data/verilog/src/glbl.v"
 if($LASTEXITCODE -ne 0){throw 'V15 integrated compile failed'}
 & "$bin/xelab.bat" emg_v15_integrated_tb glbl -L unisims_ver -L unimacro_ver -s v15_integrated -debug off
 if($LASTEXITCODE -ne 0){throw 'V15 integrated elaboration failed'}
 & "$bin/xsim.bat" v15_integrated -runall -log v15_integrated.log
 if($LASTEXITCODE -ne 0 -or !(Select-String -Path v15_integrated.log -Pattern 'TEST_PASS V15 integrated OOC MLP FFT')){throw 'V15 integrated simulation failed'}
}finally{Pop-Location}

