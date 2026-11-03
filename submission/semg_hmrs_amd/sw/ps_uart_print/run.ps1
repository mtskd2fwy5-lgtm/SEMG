# One-shot host script: extract ps7_init from the exported XSA, then run
# the XSCT download flow (run_xsct.tcl) which programs the FPGA and
# starts the bare-metal stream monitor.
#
# Prerequisites:
#   - build\export\design_1.xsa  (from build\check_design.tcl)
#   - ps_uart_print.elf          (from build.bat in this directory)
#   - board powered, JTAG connected, serial terminal at 115200-8N1
#
# Usage:  powershell -ExecutionPolicy Bypass -File run.ps1

$ErrorActionPreference = "Stop"

if (-not $env:AMD_VIVADO_ROOT) { throw 'Set AMD_VIVADO_ROOT to the AMD unified software installation root.' }
$xsct = Join-Path $env:AMD_VIVADO_ROOT 'Vitis\bin\xsct.bat'
$root = (Resolve-Path "$PSScriptRoot\..\..").Path
$xsa  = Join-Path $root "build\export\design_1.xsa"
$xdir = Join-Path $root "build\export\xsa"

if (-not (Test-Path $xsa)) {
    Write-Error "XSA not found: $xsa`nRun build\check_design.tcl first."
}
if (-not (Test-Path "$PSScriptRoot\ps_uart_print.elf")) {
    Write-Error "ELF not found; run build.bat in $PSScriptRoot first."
}

# The XSA is a zip; ps7_init lives inside it. Extract when missing.
if (-not (Test-Path (Join-Path $xdir "ps7_init.tcl"))) {
    Write-Host "Extracting ps7_init from XSA..."
    $tmpZip = Join-Path $env:TEMP "design_1_xsa.zip"
    Copy-Item $xsa $tmpZip -Force
    Expand-Archive $tmpZip $xdir -Force
    Remove-Item $tmpZip -Force
}

Write-Host "Starting XSCT download flow..."
& $xsct (Join-Path $PSScriptRoot "run_xsct.tcl")

