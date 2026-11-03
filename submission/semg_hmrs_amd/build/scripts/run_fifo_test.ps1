$ErrorActionPreference='Stop'
$root=(Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$out=Join-Path $root 'sim/results_fifo'
$bin='<amd-tools>/Vivado/bin'
New-Item -ItemType Directory -Force $out | Out-Null
Push-Location $out
try {
 & "$bin/xvlog.bat" -sv "$root/src/rtl/axis_async_fifo.v" "$root/sim/axis_async_fifo_tb.sv"
 if($LASTEXITCODE -ne 0){throw 'FIFO compile failed'}
 & "$bin/xelab.bat" axis_async_fifo_tb -s fifo_sim -debug typical
 if($LASTEXITCODE -ne 0){throw 'FIFO elaboration failed'}
 & "$bin/xsim.bat" fifo_sim -runall -log fifo.log
 if($LASTEXITCODE -ne 0 -or !(Select-String -Path fifo.log -SimpleMatch 'TEST_PASS BRAM FIFO coordinated reset')){throw 'FIFO verification failed'}
} finally {Pop-Location}

