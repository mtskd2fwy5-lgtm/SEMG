$ErrorActionPreference='Stop'
$root=(Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$out=Join-Path $root 'sim/results_v15_equiv'
$base=Join-Path $root 'report/resource_optimization_v15_20261027/baseline/src/rtl'
$bin='D:/FPGA/VIVADO/2025.2/Vivado/bin'
New-Item -ItemType Directory -Force $out | Out-Null
foreach($name in @('emg_nn_infer','hand_servo_pwm')){
 $source=Get-Content -LiteralPath "$base/$name.v" -Raw
 $source=[regex]::Replace($source,"\b$name\b","${name}_v14")
 [IO.File]::WriteAllText("$out/${name}_v14.v",$source)
}
& python "$root/tools/gen_v15_test_model.py" "$out/random_model.mem"
if($LASTEXITCODE -ne 0){throw 'Alternate model generation failed'}
Push-Location $out
try {
 & "$bin/xvlog.bat" -sv "$root/src/rtl/emg_nn_infer.v" "$root/src/rtl/hand_servo_pwm.v" emg_nn_infer_v14.v hand_servo_pwm_v14.v "$root/sim/emg_v15_equiv_tb.sv"
 if($LASTEXITCODE -ne 0){throw 'V15 equivalence compile failed'}
 & "$bin/xelab.bat" emg_v15_equiv_tb -s v15_equiv -debug typical
 if($LASTEXITCODE -ne 0){throw 'V15 equivalence elaboration failed'}
 & "$bin/xsim.bat" v15_equiv -runall -log v15_equiv.log
 if($LASTEXITCODE -ne 0 -or !(Select-String -Path v15_equiv.log -SimpleMatch 'TEST_PASS V15 MLP PWM equivalence complete')){throw 'V15 equivalence failed'}
} finally {Pop-Location}
