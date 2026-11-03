param([string]$Python = 'D:\PYTHON\python.exe', [switch]$Processed)
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$vivadoBin = '<amd-tools>\Vivado\bin'
$out = Join-Path $root $(if ($Processed) {'sim\results_processed_filter'} else {'sim\results_line_filter'})
$extra = @()
if ($Processed) { $extra = @('--processed') }
& $Python "$root\tools\check_line_filter_sim.py" gen @extra
if ($LASTEXITCODE -ne 0) { throw 'line stimulus failed' }
Push-Location $out
try {
    $defines = @('-d', 'LINE_FILTER_TEST')
    if ($Processed) { $defines += @('-d', 'FINAL_PROCESSED_TEST') }
    & "$vivadoBin\xvlog.bat" --sv @defines "$root\src\rtl\emg_notch50.v" "$root\src\rtl\emg_comb50.v" "$root\src\rtl\emg_bandpass.v" "$root\src\rtl\emg_line_filter.v" "$root\sim\emg_notch50_tb.sv"
    if ($LASTEXITCODE -ne 0) { throw 'line compile failed' }
    & "$vivadoBin\xelab.bat" emg_notch50_tb -s line_filter_sim
    if ($LASTEXITCODE -ne 0) { throw 'line elaboration failed' }
    & "$vivadoBin\xsim.bat" line_filter_sim -runall -log line_filter_sim.log
    if ($LASTEXITCODE -ne 0) { throw 'line simulation failed' }
    if (!(Select-String -Path line_filter_sim.log -Pattern 'TEST_PASS notch50:' -Quiet)) { throw 'line PASS missing' }
    & $Python "$root\tools\check_line_filter_sim.py" check @extra
    if ($LASTEXITCODE -ne 0) { throw 'line reference/response failed' }
} finally { Pop-Location }

