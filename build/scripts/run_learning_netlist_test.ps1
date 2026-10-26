$ErrorActionPreference='Stop'
$root=(Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$out=Join-Path $root 'sim/results_learning'
$bin='D:/FPGA/VIVADO/2025.2/Vivado/bin'
& "$bin/vivado.bat" -mode batch -source "$root/build/scripts/export_learning_netlist.tcl" -log "$out/export_netlist.log" -journal "$out/export_netlist.jou"
if($LASTEXITCODE -ne 0){throw 'Learning netlist export failed'}
Push-Location $out
try {
 Copy-Item learning_vectors.mem learning_vectors_full.mem -Force
 & python "$root/tools/gen_learning_vectors.py" --quick
 if($LASTEXITCODE -ne 0){throw 'Netlist vectors failed'}
 & "$bin/xvlog.bat" -sv -d LEARNING_NETLIST learning_synth.v "$root/sim/emg_learning_accel_tb.sv" "$bin/../data/verilog/src/glbl.v"
 if($LASTEXITCODE -ne 0){throw 'Learning netlist compile failed'}
 & "$bin/xelab.bat" emg_learning_accel_tb glbl -L unisims_ver -L unimacro_ver -s learning_net_sim -debug typical
 if($LASTEXITCODE -ne 0){throw 'Learning netlist elaboration failed'}
 & "$bin/xsim.bat" learning_net_sim -runall -log learning_netlist.log
 if($LASTEXITCODE -ne 0 -or !(Select-String -Path learning_netlist.log -SimpleMatch 'TEST_PASS learning accelerator complete')){throw 'Learning synthesized arithmetic verification failed'}
} finally {
 if(Test-Path learning_vectors_full.mem){Move-Item learning_vectors_full.mem learning_vectors.mem -Force}
 Pop-Location
}
