$ErrorActionPreference='Stop'
$root=Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
if (-not $env:AMD_VIVADO_ROOT) { throw 'Set AMD_VIVADO_ROOT to the AMD unified software installation root.' }
$bin=Join-Path $env:AMD_VIVADO_ROOT 'Vivado/bin'
$out=Join-Path $root 'report/hdmi_mirror_20261103'
New-Item -ItemType Directory -Force $out | Out-Null
Push-Location $out
try {
 foreach($tb in @('hdmi_scaler','hdmi_tmds')) {
  $rtl=if($tb -eq 'hdmi_tmds'){'hdmi_tmds_encoder'}else{$tb}
  & "$bin/xvlog.bat" --sv "$root/src/rtl/$rtl.v" "$root/sim/${tb}_tb.sv" *> "${tb}_compile.log"
  if($LASTEXITCODE -ne 0){throw "xvlog $tb failed"}
  & "$bin/xelab.bat" "${tb}_tb" -s "${tb}_sim" *> "${tb}_elaborate.log"
  if($LASTEXITCODE -ne 0){throw "xelab $tb failed"}
  & "$bin/xsim.bat" "${tb}_sim" -runall *> "${tb}_test.log"
  if($LASTEXITCODE -ne 0 -or !(Select-String "${tb}_test.log" -Pattern 'TEST_PASS HDMI')) {throw "xsim $tb failed"}
  Get-Content "${tb}_test.log" | Select-String 'TEST_PASS|Fatal|ERROR'
 }
 & "$bin/xvlog.bat" --sv "$root/src/rtl/hdmi_serializer.v" "$root/sim/hdmi_serializer_tb.sv" "$bin/../data/verilog/src/glbl.v" *> 'serializer_compile.log'
 if($LASTEXITCODE -ne 0){throw 'serializer compile failed'}
 & "$bin/xelab.bat" hdmi_serializer_tb glbl -L unisims_ver -L secureip -s hdmi_serializer_sim *> 'serializer_elaborate.log'
 if($LASTEXITCODE -ne 0){throw 'serializer elaborate failed'}
 & "$bin/xsim.bat" hdmi_serializer_sim -runall *> 'serializer_test.log'
 if($LASTEXITCODE -ne 0){throw 'serializer simulation failed'}
 & python "$root/sim/check_hdmi_serial.py" | Tee-Object -FilePath 'serializer_check.log'
 if($LASTEXITCODE -ne 0){throw 'serializer bit ordering failed'}
 & "$bin/xvlog.bat" --sv "$root/sim/hdmi_support/timing_serializer_stub.v" "$root/src/rtl/hdmi_output.v" "$root/sim/hdmi_output_tb.sv" *> 'output_compile.log'
 if($LASTEXITCODE -ne 0){throw 'output compile failed'}
 & "$bin/xelab.bat" hdmi_output_tb glbl -L unisims_ver -L secureip -s hdmi_output_sim *> 'output_elaborate.log'
 if($LASTEXITCODE -ne 0){throw 'output elaborate failed'}
 & "$bin/xsim.bat" hdmi_output_sim -runall *> 'output_test.log'
 if($LASTEXITCODE -ne 0 -or !(Select-String 'output_test.log' -Pattern 'TEST_PASS HDMI output:')){throw '720p clock/timing test failed'}
 if(Test-Path 'hdmi_scaler_netlist.v') {
  & "$bin/xvlog.bat" --sv hdmi_scaler_netlist.v "$root/sim/hdmi_scaler_tb.sv" *> 'scaler_netlist_compile.log'
  if($LASTEXITCODE -ne 0){throw 'scaler netlist compile failed'}
  & "$bin/xelab.bat" hdmi_scaler_tb glbl -L unisims_ver -L secureip -s hdmi_scaler_netlist_sim *> 'scaler_netlist_elaborate.log'
  if($LASTEXITCODE -ne 0){throw 'scaler netlist elaborate failed'}
  & "$bin/xsim.bat" hdmi_scaler_netlist_sim -runall *> 'scaler_netlist_test.log'
  if($LASTEXITCODE -ne 0 -or !(Select-String 'scaler_netlist_test.log' -Pattern 'TEST_PASS HDMI scaler complete')){throw 'scaler netlist pixel test failed'}
  Get-Content 'scaler_netlist_test.log' | Select-String 'TEST_PASS'
 }
} finally {Pop-Location}


