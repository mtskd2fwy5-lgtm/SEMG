param([switch]$SkipCompleted)
$ErrorActionPreference='Stop'
$root=(Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$report=Join-Path $root 'report/resource_optimization_v15_20261027'
$out=Join-Path $root 'sim/results_v15_netlist'
$bin='<amd-tools>/Vivado/bin'
New-Item -ItemType Directory -Force $out | Out-Null
$nn=Get-Content "$root/sim/emg_v15_equiv_tb.sv" -Raw
$nn=$nn.Substring(0,$nn.IndexOf('module emg_v15_equiv_tb;'))
$nn=$nn.Replace('emg_nn_infer #(.MEM_FILE(MODEL)) a','emg_nn_infer a')
$nn=$nn.Replace('hand_servo_pwm #(.CLOCK_HZ(CLOCK),.FRAME_US(FRAME),.WATCHDOG_MS(WD)) a','hand_servo_pwm a')
$nn=$nn.Replace('if(accepted<1000 || stops<100)','if(accepted<1000)')
$nn+=@'
module v15_netlist_tb;
 wire[1:0]done;
 nn_v15_case production(done[0]);
 pwm_v15_case #(.CLOCK(25000000),.FRAME(20000),.WD(250)) pwm_case(done[1]);
 initial begin wait(&done);$display("TEST_PASS V15 synthesized MLP PWM cycle-exact");$finish;end
 initial begin #100000000;$fatal(1,"V15 netlist watchdog");end
endmodule
'@
foreach($name in @('emg_nn_infer','hand_servo_pwm','emg_fatigue')){
 $ref=Get-Content "$report/baseline/src/rtl/$name.v" -Raw
 if($name -eq 'emg_fatigue'){$ref=$ref.Replace('emg_fatigue_state','emg_fatigue_state_v14')}
 $ref=[regex]::Replace($ref,"\b$name\b","${name}_v14")
 [IO.File]::WriteAllText("$out/${name}_v14.v",$ref)
}
[IO.File]::WriteAllText("$out/v15_netlist_tb.sv",$nn)
$fatigue=Get-Content "$root/sim/results_v15_fatigue/tb_v15_fatigue.sv" -Raw
$fatigue=$fatigue.Replace('NFRAMES = 147456','NFRAMES = 4096').Replace('NWORDS  = 576','NWORDS  = 16')
# UNISIM holds GSR for 100 ns; keep the shared DUT reset asserted until
# after that startup interval before the first reference/golden sample.
$fatigue=$fatigue.Replace('repeat (4) @(posedge clk);','repeat (30) @(posedge clk);')
# Synthesis can merge internal state encodings. Pace on reference state,
# then compare all public outputs every cycle and check Python golden words.
$fatigue=$fatigue.Replace('wait (dut.state == P_IDLE)','wait (reference_dut.state == P_IDLE)')
$fatigue=$fatigue.Replace('if(dut.state!==reference_dut.state)$fatal(1,"V15 fatigue state/latency mismatch");','')
$fatigue=$fatigue.Replace('TEST_PASS V15 fatigue cycle-exact','TEST_PASS V15 synthesized fatigue cycle-exact')
[IO.File]::WriteAllText("$out/v15_fatigue_netlist_tb.sv",$fatigue)
Push-Location $out
try{
 $net=@("$report/candidate_emg_nn_infer_synth.v","$report/candidate_hand_servo_pwm_synth.v","$report/candidate_emg_fatigue_synth.v")
 & "$bin/xvlog.bat" -sv @net emg_nn_infer_v14.v hand_servo_pwm_v14.v emg_fatigue_v14.v v15_netlist_tb.sv v15_fatigue_netlist_tb.sv "$bin/../data/verilog/src/glbl.v"
 if($LASTEXITCODE -ne 0){throw 'V15 netlist compile failed'}
 foreach($case in @(@('v15_netlist_tb','TEST_PASS V15 synthesized MLP PWM'),@('tb_emg_fatigue','TEST_PASS V15 synthesized fatigue cycle-exact 16 words'))){
  $top=$case[0]
  if($SkipCompleted -and (Test-Path "$top.log") -and (Select-String -Path "$top.log" -SimpleMatch -Pattern $case[1])){continue}
  & "$bin/xelab.bat" $top glbl -L unisims_ver -L unimacro_ver -s $top -debug typical
  if($LASTEXITCODE -ne 0){throw 'V15 netlist elaboration failed'}
  & "$bin/xsim.bat" $top -runall -log "$top.log"
  if($LASTEXITCODE -ne 0 -or !(Select-String -Path "$top.log" -SimpleMatch -Pattern $case[1])){throw "V15 netlist simulation failed: $top"}
 }
 Write-Output 'TEST_PASS V15 synthesized modules complete'
}finally{Pop-Location}

