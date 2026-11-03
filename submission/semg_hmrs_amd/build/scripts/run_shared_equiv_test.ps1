$ErrorActionPreference='Stop'
$root=(Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$out=Join-Path $root 'sim/results_shared_equiv'
$base=Join-Path $root 'report/resource_optimization_full_20261027/baseline/src/rtl'
$bin='<amd-tools>/Vivado/bin'
New-Item -ItemType Directory -Force $out | Out-Null
foreach($name in @('emg_bandpass','emg_window_features','emg_feature_bank')){
 $source=Get-Content -LiteralPath "$base/$name.v" -Raw
 foreach($module in @('emg_bandpass','emg_window_features','emg_feature_bank')){
  $source=[regex]::Replace($source,"\b$module\b","${module}_reference")
 }
 [IO.File]::WriteAllText("$out/${name}_reference.v",$source)
}
Push-Location $out
try {
 $sources=@('emg_bandpass','emg_window_features','emg_feature_bank') | ForEach-Object {"$root/src/rtl/$_.v"}
 $refs=@('emg_bandpass','emg_window_features','emg_feature_bank') | ForEach-Object {"$out/${_}_reference.v"}
 & "$bin/xvlog.bat" -sv @sources @refs "$root/sim/emg_shared_equiv_tb.sv"
 if($LASTEXITCODE -ne 0){throw 'Shared compile failed'}
 & "$bin/xelab.bat" emg_shared_equiv_tb -s shared_equiv -debug typical
 if($LASTEXITCODE -ne 0){throw 'Shared elaboration failed'}
 & "$bin/xsim.bat" shared_equiv -runall -log shared_equiv.log
 if($LASTEXITCODE -ne 0 -or !(Select-String -Path shared_equiv.log -SimpleMatch 'TEST_PASS shared arithmetic equivalence complete')){
  throw 'Shared arithmetic regression failed'
 }
} finally {Pop-Location}

