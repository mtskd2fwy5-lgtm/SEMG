param([switch]$Integrated)
$ErrorActionPreference='Stop'
$root=(Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$out=Join-Path $root $(if($Integrated){'sim/results_shared_integrated_netlist'}else{'sim/results_shared_netlist'})
$report=Join-Path $root 'report/resource_optimization_full_20261027'
$base=Join-Path $report 'baseline/src/rtl'
$original=Join-Path $root 'report/resource_optimization_20261027/baseline/src/rtl'
$bin='<amd-tools>/Vivado/bin'
New-Item -ItemType Directory -Force $out | Out-Null
$names=@('emg_bandpass','emg_window_features','emg_feature_bank','emg_line_filter','emg_notch50','emg_comb50')
foreach($name in $names){
 $inputFile="$base/$name.v"
 if(!(Test-Path $inputFile)){$inputFile="$original/$name.v"}
 $source=Get-Content -LiteralPath $inputFile -Raw
 foreach($module in $names){$source=[regex]::Replace($source,"\b$module\b","${module}_reference")}
 [IO.File]::WriteAllText("$out/${name}_reference.v",$source)
}
Push-Location $out
try {
 $refs=$names | ForEach-Object {"$out/${_}_reference.v"}
 $netlists=@("$report/emg_feature_bank_synth.v","$report/emg_line_filter_synth.v")
 $testbench="$root/sim/emg_shared_netlist_tb.sv"
 if($Integrated){
  $net=Get-Item "$report/integrated_pl_export.v" -ErrorAction SilentlyContinue
  if(!$net){$net=Get-ChildItem "$root/build/vivado/*.gen/sources_1/bd/design_1/ip/*emg_pl_export*/*_sim_netlist.v" | Sort-Object LastWriteTime -Descending | Select-Object -First 1}
  if(!$net){throw 'Integrated netlist missing: finish the guarded build first'}
  $netlists=@($net.FullName)
  # Cross-boundary synthesis changes internal module ports. Exercise the real
  # OOC top, injecting only at its retained ADC decoded-sample boundary.
  $testbench="$root/sim/emg_shared_integrated_netlist_tb.sv"
 }
 & "$bin/xvlog.bat" -sv @netlists @refs $testbench "$bin/../data/verilog/src/glbl.v"
 if($LASTEXITCODE -ne 0){throw 'Shared netlist compile failed'}
 & "$bin/xelab.bat" emg_shared_netlist_tb glbl -L unisims_ver -L unimacro_ver -s shared_netlist -debug typical
 if($LASTEXITCODE -ne 0){throw 'Shared netlist elaboration failed'}
 & "$bin/xsim.bat" shared_netlist -runall -log shared_netlist.log
 if($LASTEXITCODE -ne 0 -or !(Select-String -Path shared_netlist.log -SimpleMatch 'TEST_PASS shared synthesized pipeline')){
  throw 'Shared netlist regression failed'
 }
} finally {Pop-Location}

