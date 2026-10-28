$ErrorActionPreference='Stop'
$root=(Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$python='C:/Users/bvcm/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/python.exe'
Push-Location $root
try {
    $integrated=Join-Path $PSScriptRoot 'integrated_test.log'
    $deadline=(Get-Date).AddMinutes(60)
    while($true) {
        $text=Get-Content -LiteralPath $integrated -Raw
        if($text -match 'TEST_PASS V15 integrated OOC MLP FFT') {break}
        if($text -match '(?m)^Fatal:|(?m)^ERROR:|integrated coverage incomplete') {throw 'Integrated simulation failed; release was not packaged'}
        if((Get-Date) -gt $deadline) {throw 'Integrated simulation deadline exceeded; release was not packaged'}
        if(!(Get-Process -Name xsimk -ErrorAction SilentlyContinue)) {throw 'Simulator stopped without terminal PASS; release was not packaged'}
        Start-Sleep -Seconds 15
    }
    & cmd /d /c ('"' + $python + '" report/resource_optimization_v15_20261027/compare_resources.py > report/resource_optimization_v15_20261027/comparison.log 2>&1')
    if($LASTEXITCODE -ne 0) {throw 'Resource and performance comparison failed'}
    & cmd /d /c 'powershell -NoProfile -ExecutionPolicy Bypass -File build/boot/build_pl_control_boot.ps1 > report/resource_optimization_v15_20261027/boot_build.log 2>&1'
    if($LASTEXITCODE -ne 0) {throw 'BOOT build failed'}
    & $python (Join-Path $PSScriptRoot 'finalize_readme.py')
    if($LASTEXITCODE -ne 0) {throw 'README release reference update failed'}
    & cmd /d /c ('"' + $python + '" tools/verify_control_boot.py --report-dir report/resource_optimization_v15_20261027 > report/resource_optimization_v15_20261027/final_verify.log 2>&1')
    if($LASTEXITCODE -ne 0) {throw 'Final BOOT verification failed'}
    Write-Output 'V15_RELEASE_FINALIZATION_PASS'
} finally {Pop-Location}
