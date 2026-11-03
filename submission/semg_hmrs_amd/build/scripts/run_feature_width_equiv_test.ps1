param(
    [string]$BaselineRtl='report/resource_optimization_20261027/baseline/src/rtl/emg_window_features.v',
    [switch]$Netlist
)
$ErrorActionPreference='Stop'
$root=(Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$out=Join-Path $root 'sim/results_feature_width'
$bin='<amd-tools>/Vivado/bin'
New-Item -ItemType Directory -Force $out | Out-Null
$baseline=(Resolve-Path (Join-Path $root $BaselineRtl)).Path
# The baseline is a frozen input, not generated from the candidate.
$old=Get-Content -LiteralPath $baseline -Raw
if($old -notmatch 'module emg_window_features #\('){throw 'Unexpected baseline module'}
$reference=Join-Path $out 'emg_window_features_baseline.v'
[IO.File]::WriteAllText($reference,$old.Replace('module emg_window_features #(','module emg_window_features_baseline #('))
$defines=@()
$libraries=@()
$candidate=Join-Path $root 'src/rtl/emg_window_features.v'
$extra=@()
$snapshot='feature_width_rtl'
if($Netlist){
    $candidate=Join-Path $root 'report/resource_optimization_20261027/candidate/feature_synth.v'
    if(!(Test-Path $candidate)){throw 'Run synth_feature.tcl before netlist verification'}
    $defines=@('-d','FEATURE_NETLIST')
    $libraries=@('-L','unisims_ver','-L','unimacro_ver')
    $extra=@("$bin/../data/verilog/src/glbl.v")
    $snapshot='feature_width_netlist'
}
Push-Location $out
try {
    & "$bin/xvlog.bat" -sv @defines $candidate $reference "$root/sim/emg_feature_width_equiv_tb.sv" @extra
    if($LASTEXITCODE -ne 0){throw 'Feature comparison compile failed'}
    $tops=@('emg_feature_width_equiv_tb')
    if($Netlist){$tops+=@('glbl')}
    & "$bin/xelab.bat" @tops @libraries -s $snapshot -debug typical
    if($LASTEXITCODE -ne 0){throw 'Feature comparison elaboration failed'}
    & "$bin/xsim.bat" $snapshot -runall -log "$snapshot.log"
    if($LASTEXITCODE -ne 0 -or !(Select-String -Path "$snapshot.log" -SimpleMatch 'TEST_PASS feature width equivalence complete')){
        throw 'Feature comparison failed or did not reach terminal PASS'
    }
} finally {Pop-Location}

