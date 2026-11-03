param([string]$Python = 'D:\PYTHON\python.exe')
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$vivadoBin = '<amd-tools>\Vivado\bin'
$out = Join-Path $root 'sim\results_notch50'
& $Python "$root\tools\check_notch50_sim.py" gen
if ($LASTEXITCODE -ne 0) { throw 'notch stimulus failed' }
Push-Location $out
try {
    & "$vivadoBin\xvlog.bat" --sv "$root\src\rtl\emg_notch50.v" "$root\sim\emg_notch50_tb.sv"
    if ($LASTEXITCODE -ne 0) { throw 'notch compile failed' }
    & "$vivadoBin\xelab.bat" emg_notch50_tb -s notch50_sim
    if ($LASTEXITCODE -ne 0) { throw 'notch elaboration failed' }
    & "$vivadoBin\xsim.bat" notch50_sim -runall -log notch50_sim.log
    if ($LASTEXITCODE -ne 0) { throw 'notch simulation failed' }
    if (!(Select-String -Path notch50_sim.log -Pattern 'TEST_PASS notch50:' -Quiet)) { throw 'notch PASS missing' }
    & $Python "$root\tools\check_notch50_sim.py" check
    if ($LASTEXITCODE -ne 0) { throw 'notch reference/response failed' }
} finally { Pop-Location }

