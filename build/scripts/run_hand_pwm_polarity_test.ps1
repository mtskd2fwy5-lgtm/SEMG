param([switch]$Netlist,[switch]$SkipReference)
$ErrorActionPreference='Stop'
$root=(Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$out=Join-Path $root 'report/hand_pwm_inverted_20261029'
$bin='D:/FPGA/VIVADO/2025.2/Vivado/bin'
New-Item -ItemType Directory -Force $out | Out-Null
function Check($message){if($LASTEXITCODE -ne 0){throw $message}}
Push-Location $out
try {
 if($Netlist){
  & "$bin/xvlog.bat" -sv -d HAND_NETLIST "$out/hand_control_funcsim.v" "$root/sim/hand_pwm_polarity_tb.sv" "$bin/../data/verilog/src/glbl.v" > pin_netlist_compile.log 2>&1
  Check 'Pin netlist compile failed'
  & "$bin/xelab.bat" hand_pwm_polarity_tb glbl -L unisims_ver -L unimacro_ver -s pin_netlist -debug typical > pin_netlist_elaborate.log 2>&1
  Check 'Pin netlist elaboration failed'
  & "$bin/xsim.bat" pin_netlist -runall -log pin_netlist.log > pin_netlist_console.log 2>&1
  Check 'Pin netlist simulation failed'
  if(!(Select-String -Path pin_netlist.log -SimpleMatch 'TEST_PASS pin polarity:')){throw 'Pin netlist contract failed'}
 }else{
  if(!$SkipReference){
   & "$bin/xvlog.bat" -sv -d HAND_POLARITY_REFERENCE "$root/src/rtl/hand_servo_pwm.v" "$root/src/rtl/hand_control.v" "$out/hand_control_reference.v" "$root/sim/hand_control_tb.sv" > compile.log 2>&1
   Check 'Hand polarity compile failed'
   & "$bin/xelab.bat" hand_control_tb -s hand_inverted -debug typical > elaborate.log 2>&1
   Check 'Hand polarity elaboration failed'
   & "$bin/xsim.bat" hand_inverted -runall -log polarity_rtl.log > sim_console.log 2>&1
   Check 'Hand polarity simulation failed'
   if(!(Select-String -Path polarity_rtl.log -SimpleMatch 'TEST_PASS inverted PWM cycle-equivalence:')){throw 'Hand polarity equivalence failed'}
  }
  & "$bin/xvlog.bat" -sv "$root/src/rtl/hand_servo_pwm.v" "$root/src/rtl/hand_control.v" "$root/sim/hand_pwm_polarity_tb.sv" > pin_rtl_compile.log 2>&1
  Check 'Pin RTL compile failed'
  & "$bin/xelab.bat" hand_pwm_polarity_tb -s pin_rtl -debug typical > pin_rtl_elaborate.log 2>&1
  Check 'Pin RTL elaboration failed'
  & "$bin/xsim.bat" pin_rtl -runall -log pin_rtl.log > pin_rtl_console.log 2>&1
  Check 'Pin RTL simulation failed'
  if(!(Select-String -Path pin_rtl.log -SimpleMatch 'TEST_PASS pin polarity:')){throw 'Pin RTL contract failed'}
 }
} finally {Pop-Location}
