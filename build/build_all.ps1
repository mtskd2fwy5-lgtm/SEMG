# build_all.ps1 - guarded build + package pipeline for sEMG-HMRS
#
# Generic engine: all project-specific constants live in project.psd1
# (same directory). The expected parameter values for Gate 1/2 are NOT
# stored here - they are extracted from the RTL declaration file at
# runtime, so the RTL stays the single source of truth and a BD-level
# parameter override or a forgotten RTL edit is caught, not propagated.
#
# Runs the Vivado build (build\check_design.tcl), then enforces the five
# acceptance gates established after the 2026-10-08 MAV saturation incident
# (Vivado 2025.2 OOC wrapper stringified positive module_ref parameters,
# corrupting the IIR coefficients in the shipped netlist while RTL and
# behavioral sim stayed green). Do NOT flash a BOOT.BIN unless this script
# prints "PIPELINE RESULT: ALL GATES PASS".
#
# Gates:
#   G1  OOC synth runme.log: every guarded parameter binding is the
#       value declared in the RTL AND type=integer (catches wrapper
#       stringification)
#   G2  tools\verify_coeff_regs.py: decode the coefficients from the
#       dont_touch FF INIT attributes in the OOC sim netlist (expected
#       values passed in via --expect, extracted from the RTL)
#   G3  tools\scan_literal_b.py: no unexpected constant-B DSP48E1 in the
#       EMG coefficient paths, no known-bad literals folded into the datapath
#   G4  Routed timing: "All user specified timing constraints are met"
#   G5  tools\verify_boot_partition.py: BOOT.BIN bitstream partition is a
#       byte-exact wordrev of the bitstream (header length auto-probed)
#
# Usage (Windows PowerShell 5.1 compatible; or just run build_all.bat):
#   powershell -ExecutionPolicy Bypass -File build\build_all.ps1
#       Full build + gates + BOOT.BIN package (the normal path).
#   powershell -ExecutionPolicy Bypass -File build\build_all.ps1 -SkipBuild
#       Re-run gates + package against the existing bitstream/runs.
#   powershell -ExecutionPolicy Bypass -File build\build_all.ps1 -SkipBoot
#       Build + gates only, no bootgen.
#
# Fast single-module pre-check before a full build (optional):
#   vivado -mode batch -source build\ooc_check.tcl

param(
    [switch]$SkipBuild,
    [switch]$SkipBoot
)

$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $PSScriptRoot

try {
    $cfg = Import-PowerShellDataFile (Join-Path $PSScriptRoot 'project.psd1')
} catch {
    Write-Host "FAIL: cannot read build\project.psd1: $_" -ForegroundColor Red
    exit 1
}

$VivadoBat = $cfg.VivadoBat
$Xpr       = Join-Path $Root $cfg.ProjectXpr
$Bit       = Join-Path $Root $cfg.BitFile
$BootBin   = Join-Path $Root $cfg.BootBin
$FsblElf   = Join-Path $Root $cfg.FsblElf
$AppElf    = Join-Path $Root $cfg.AppElf

$GateResults = New-Object System.Collections.Generic.List[object]
$Failed = $false

function Add-Gate {
    param([string]$Name, [bool]$Pass, [string]$Detail)
    $script:GateResults.Add([pscustomobject]@{
        Gate   = $Name
        Status = $(if ($Pass) { 'PASS' } else { 'FAIL' })
        Detail = $Detail
    })
    if (-not $Pass) { $script:Failed = $true }
}

function Fail {
    param([string]$Message)
    Write-Host "FAIL: $Message" -ForegroundColor Red
    exit 1
}

# Extract the expected values of the guarded parameters from the RTL
# module declaration (`parameter integer NAME = VALUE`). If the block
# design overrides any of them, Gate 1 will fail on the mismatch - that
# is intentional: the override then has to be resolved by a human.
function Get-ExpectedParams {
    param([string]$RtlFile, [string[]]$Names)
    if (-not (Test-Path $RtlFile)) { Fail "parameter source RTL not found: $RtlFile" }
    $txt = Get-Content $RtlFile -Raw
    $expect = [ordered]@{}
    foreach ($n in $Names) {
        $pattern = '(?m)^\s*parameter\s+integer\s+{0}\s*=\s*(-?\d+)' -f [regex]::Escape($n)
        if ($txt -match $pattern) { $expect[$n] = $Matches[1] }
        else { Fail ("cannot extract 'parameter integer {0} = ...' from {1}" -f $n, (Split-Path -Leaf $RtlFile)) }
    }
    return $expect
}

# ---------------------------------------------------------------------------
# Stage 0: preflight
# ---------------------------------------------------------------------------
Write-Host '=== sEMG-HMRS guarded build pipeline ===' -ForegroundColor Cyan
Write-Host ("repo : {0}" -f $Root)
$modeParts = @()
if ($SkipBuild) { $modeParts += 'reuse existing build' } else { $modeParts += 'full Vivado build' }
if ($SkipBoot)  { $modeParts += 'no packaging' }       else { $modeParts += 'BOOT.BIN package' }
Write-Host ("mode : {0}" -f ($modeParts -join ' + '))

if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Fail 'python not found on PATH (gates 2/3/5 need it)'
}

if (-not (Test-Path $Xpr)) { Fail "Vivado project missing: $Xpr (run build\create_project.tcl first)" }

if ($SkipBuild) {
    if (-not (Test-Path $Bit)) { Fail "-SkipBuild but no bitstream exists: $Bit" }
} else {
    if (-not (Test-Path $VivadoBat)) { Fail "vivado.bat not found: $VivadoBat" }
}

if (-not $SkipBoot) {
    foreach ($f in @($FsblElf, $AppElf)) {
        if (-not (Test-Path $f)) {
            Fail ("packaging input missing: {0} (FSBL comes from the XSA -> Vitis platform flow, app from the sw\ app directory - see project memory)" -f $f)
        }
    }
}

# Single source of truth: expected parameter values come from the RTL.
$ExpectedCoeff = Get-ExpectedParams -RtlFile (Join-Path $Root $cfg.ParamSourceRtl) -Names $cfg.GuardedParams
$expectSummary = ($ExpectedCoeff.GetEnumerator() | ForEach-Object { '{0}={1}' -f $_.Key, $_.Value }) -join ' '
Write-Host ("expected params (from RTL): {0}" -f $expectSummary)

# Gate 2 arguments: --expect REG=VAL for every guarded parameter.
foreach ($key in $cfg.GuardedParams) {
    if (-not $cfg.NetlistRegMap.ContainsKey($key)) {
        Fail ("project.psd1: NetlistRegMap has no entry for guarded parameter {0}" -f $key)
    }
}
$g2ExpectArgs = @()
foreach ($key in $cfg.GuardedParams) {
    $g2ExpectArgs += @('--expect', ('{0}={1}' -f $cfg.NetlistRegMap[$key], $ExpectedCoeff[$key]))
}

# ---------------------------------------------------------------------------
# Stage 1: Vivado build
# ---------------------------------------------------------------------------
$BuildStart = $null
if (-not $SkipBuild) {
    Write-Host "`n[Stage 1] Vivado build: build\check_design.tcl" -ForegroundColor Cyan
    $BuildStart = Get-Date
    $CheckLog = Join-Path $Root $cfg.CheckLog
    $CheckJou = Join-Path $Root $cfg.CheckJou
    # Remove stale log so success markers provably come from THIS run.
    Remove-Item -Path $CheckLog, $CheckJou -ErrorAction SilentlyContinue

    & $VivadoBat -mode batch -source (Join-Path $Root 'build\check_design.tcl') -log $CheckLog -journal $CheckJou
    $BuildExit = $LASTEXITCODE

    $LogText = ''
    if (Test-Path $CheckLog) { $LogText = Get-Content $CheckLog -Raw }
    $okComplete  = $LogText -match 'CHECK COMPLETE'
    $okBitstream = $LogText -match 'write_bitstream completed successfully'
    $bitFresh    = (Test-Path $Bit) -and ((Get-Item $Bit).LastWriteTime -ge $BuildStart)

    if ($BuildExit -ne 0 -or -not $okComplete -or -not $okBitstream -or -not $bitFresh) {
        Fail ("Vivado build failed: exit={0} CHECK_COMPLETE={1} bitstream_marker={2} bit_fresh={3} - inspect {4}" -f `
            $BuildExit, $okComplete, $okBitstream, $bitFresh, $CheckLog)
    }
    $bitItem = Get-Item $Bit
    Write-Host ("build OK: design_1.bit ({0}, {1:N0} bytes)" -f $bitItem.LastWriteTime, $bitItem.Length)
}

# ---------------------------------------------------------------------------
# Gate 1: OOC synth log parameter binding vs RTL-declared values
# ---------------------------------------------------------------------------
Write-Host "`n[Gate 1] OOC synth runme.log: parameter binding vs RTL" -ForegroundColor Cyan
$RunsDir = Join-Path $Root $cfg.RunsDir
$oocLog = Get-ChildItem -Path $RunsDir -Recurse -Filter 'runme.log' -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -match $cfg.OocRunPattern -and $_.FullName -match 'synth_1' } |
    Sort-Object LastWriteTime -Descending | Select-Object -First 1

if (-not $oocLog) {
    Add-Gate 'G1 coeff-bind' $false ("no *{0}*synth_1 runme.log found (upgrade_ip renames BD-scoped OOC runs - run the full build)" -f $cfg.OocRunPattern)
} elseif ($null -ne $BuildStart -and $oocLog.LastWriteTime -lt $BuildStart) {
    Add-Gate 'G1 coeff-bind' $false ("stale OOC log ({0}) - expected from this run" -f $oocLog.LastWriteTime)
} else {
    $txt = Get-Content $oocLog.FullName -Raw
    $bad = @()
    foreach ($key in $cfg.GuardedParams) {
        $want = [string]$ExpectedCoeff[$key]
        $ms = [regex]::Matches($txt, ("Parameter {0} bound to:\s*(-?\d+)\s*-\s*type:\s*(\S+)" -f $key))
        if ($ms.Count -eq 0) {
            $bad += ("{0}: no binding line" -f $key)
            continue
        }
        foreach ($m in $ms) {
            if ($m.Groups[1].Value -ne $want -or $m.Groups[2].Value -ne 'integer') {
                $bad += ("{0}={1}/{2} (RTL declares {3}/integer)" -f $key, $m.Groups[1].Value, $m.Groups[2].Value, $want)
            }
        }
    }
    if ($bad.Count -eq 0) {
        Add-Gate 'G1 coeff-bind' $true ("{0}: all {1} guarded parameters bound as declared in RTL" -f $oocLog.Directory.Name, $cfg.GuardedParams.Count)
    } else {
        Add-Gate 'G1 coeff-bind' $false ($bad -join '; ')
    }
}

# ---------------------------------------------------------------------------
# Gates 2 & 3: netlist coefficient decode + DSP literal-B scan
# ---------------------------------------------------------------------------
$pyGates = @(
    @{ Gate = 'G2 netlist-decode'; Script = 'verify_coeff_regs.py'; PassMark = 'CORRECT'; ExtraArgs = $g2ExpectArgs },
    @{ Gate = 'G3 literal-B scan'; Script = 'scan_literal_b.py';    PassMark = 'RESULT: OK'; ExtraArgs = @() }
)
foreach ($g in $pyGates) {
    Write-Host ("`n[{0}] tools\{1}" -f $g.Gate, $g.Script) -ForegroundColor Cyan
    $allArgs = @((Join-Path $Root ("tools\" + $g.Script))) + @($g.ExtraArgs)
    $out = @( & python @allArgs )
    $exit = $LASTEXITCODE
    $resultLine = ($out | Where-Object { "$_" -match '^RESULT:' } | Select-Object -First 1)
    if (-not $resultLine) { $resultLine = ($out | Select-Object -Last 1) }
    $pass = ($exit -eq 0) -and ("$resultLine" -match [regex]::Escape($g.PassMark))
    Add-Gate $g.Gate $pass ("exit={0} {1}" -f $exit, $resultLine)
}

# ---------------------------------------------------------------------------
# Gate 4: routed timing
# ---------------------------------------------------------------------------
Write-Host "`n[Gate 4] Routed timing" -ForegroundColor Cyan
$ImplDir = Join-Path $RunsDir 'impl_1'
$timingRpt = Get-ChildItem -Path $ImplDir -Filter $cfg.TimingRptPattern -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending | Select-Object -First 1

if (-not $timingRpt) {
    Add-Gate 'G4 timing' $false ("no {0} in impl_1 - run the full build" -f $cfg.TimingRptPattern)
} elseif ($null -ne $BuildStart -and $timingRpt.LastWriteTime -lt $BuildStart) {
    Add-Gate 'G4 timing' $false ("stale report ({0}) - expected from this run" -f $timingRpt.LastWriteTime)
} else {
    $rptLines = Get-Content $timingRpt.FullName
    $notMet = ($rptLines | Where-Object { $_ -match 'timing constraints are not met' })
    $met    = ($rptLines | Where-Object { $_ -match 'All user specified timing constraints are met' })
    if ($notMet) {
        Add-Gate 'G4 timing' $false ("{0}: timing constraints NOT met" -f $timingRpt.Name)
    } elseif ($met) {
        $wns = ''; $whs = ''
        for ($i = 0; $i -lt $rptLines.Count; $i++) {
            if ($rptLines[$i] -match '^\s*WNS\(ns\)') {
                # The header line is followed by a dashed separator row; the
                # first row whose leading token is numeric carries the values.
                $lim = [Math]::Min($i + 4, $rptLines.Count - 1)
                for ($j = $i + 1; $j -le $lim; $j++) {
                    $vals = ($rptLines[$j] -split '\s+') | Where-Object { $_ -ne '' }
                    if ($vals.Count -ge 5 -and $vals[0] -match '^-?\d+(\.\d+)?$') {
                        $wns = $vals[0]; $whs = $vals[4]; break
                    }
                }
                break
            }
        }
        Add-Gate 'G4 timing' $true ("{0}: all constraints met (WNS={1} WHS={2})" -f $timingRpt.Name, $wns, $whs)
    } else {
        Add-Gate 'G4 timing' $false ("{0}: no met/not-met verdict found in report" -f $timingRpt.Name)
    }
}

# ---------------------------------------------------------------------------
# Stage 3: BOOT.BIN package + Gate 5
# ---------------------------------------------------------------------------
if (-not $SkipBoot) {
    Write-Host "`n[Stage 3] bootgen: BOOT.BIN" -ForegroundColor Cyan
    $PackStart = Get-Date
    & (Join-Path $Root 'build\boot\build_boot_bin.bat')
    $PackExit = $LASTEXITCODE
    $bootFresh = (Test-Path $BootBin) -and ((Get-Item $BootBin).LastWriteTime -ge $PackStart)

    if ($PackExit -ne 0 -or -not $bootFresh) {
        Add-Gate 'G5 boot-partition' $false ("bootgen failed (exit={0}, BOOT.BIN fresh={1}) - gate 5 not run" -f $PackExit, $bootFresh)
    } else {
        Write-Host "`n[Gate 5] tools\verify_boot_partition.py" -ForegroundColor Cyan
        $out = @( & python (Join-Path $Root 'tools\verify_boot_partition.py') $Bit $BootBin )
        $exit = $LASTEXITCODE
        $resultLine = ($out | Where-Object { "$_" -match '^RESULT:' } | Select-Object -First 1)
        if (-not $resultLine) { $resultLine = ($out | Select-Object -Last 1) }
        $pass = ($exit -eq 0) -and ("$resultLine" -match 'RESULT: OK')
        Add-Gate 'G5 boot-partition' $pass ("exit={0} {1}" -f $exit, $resultLine)
    }
}

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
Write-Host "`n=== Gate summary ===" -ForegroundColor Cyan
foreach ($g in $GateResults) {
    $color = if ($g.Status -eq 'PASS') { 'Green' } else { 'Red' }
    Write-Host ("  {0,-18} {1}  {2}" -f $g.Gate, $g.Status, $g.Detail) -ForegroundColor $color
}

if ($Failed) {
    Write-Host "`nPIPELINE RESULT: FAIL - do NOT flash this BOOT.BIN" -ForegroundColor Red
    exit 1
}

Write-Host "`nPIPELINE RESULT: ALL GATES PASS" -ForegroundColor Green
$bitItem = Get-Item $Bit
Write-Host ("  bitstream : {0}  ({1:N0} bytes, {2})" -f $bitItem.FullName, $bitItem.Length, $bitItem.LastWriteTime)
if (-not $SkipBoot) {
    $bootItem = Get-Item $BootBin
    Write-Host ("  BOOT.BIN  : {0}  ({1:N0} bytes, {2})" -f $bootItem.FullName, $bootItem.Length, $bootItem.LastWriteTime)
}
exit 0
