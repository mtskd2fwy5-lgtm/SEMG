# SPDX-License-Identifier: Apache-2.0
# Assemble the clean, English-named AMD autonomous-track submission tree.
param([string]$Destination = 'submission/semg_hmrs_amd')
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$dest = Join-Path $root $Destination
$templateDir = Join-Path $root 'submission/semg_hmrs_amd'
$templateReadme = Get-Content (Join-Path $templateDir 'README.md') -Raw
$templateManifest = Get-Content (Join-Path $templateDir 'MANIFEST.md') -Raw
if (Test-Path $dest) { Remove-Item -LiteralPath $dest -Recurse -Force }
New-Item -ItemType Directory -Force $dest | Out-Null

function Copy-Tree([string]$relative) {
    $src = Join-Path $root $relative; $dst = Join-Path $dest $relative
    New-Item -ItemType Directory -Force (Split-Path $dst) | Out-Null
    Copy-Item -LiteralPath $src -Destination $dst -Recurse -Force
}
function Copy-Files([string]$relative, [string]$pattern) {
    $src = Join-Path $root $relative; $dst = Join-Path $dest $relative
    New-Item -ItemType Directory -Force $dst | Out-Null
    Get-ChildItem -LiteralPath $src -File -Filter $pattern | Copy-Item -Destination $dst -Force
}
function Copy-File([string]$relative) {
    $src = Join-Path $root $relative; $dst = Join-Path $dest $relative
    New-Item -ItemType Directory -Force (Split-Path $dst) | Out-Null
    Copy-Item -LiteralPath $src -Destination $dst -Force
}

foreach ($f in @('README.md','LICENSE','NOTICE','THIRD_PARTY_NOTICES.md','.gitattributes')) { Copy-File $f }
foreach ($d in @('src','sw/ps_uart_print','board','skill','tools')) { Copy-Tree $d }
Copy-Tree 'build/vivado/hand_motion_reconstruction.srcs/sources_1/bd'
foreach ($f in @('README.md')) { if (Test-Path (Join-Path $root "data/$f")) { Copy-File "data/$f" } }
foreach ($f in @('baseline.json','emg008_009_multiwear.json','hdc_validate.json','nmf_validate.json','int8_validation.json','pose_stability_20261022.json')) {
    if (Test-Path (Join-Path $root "data/metrics/$f")) { Copy-File "data/metrics/$f" }
}
foreach ($f in @('hdc_memory.mem','model_params.mat')) {
    if (Test-Path (Join-Path $root "data/models/$f")) { Copy-File "data/models/$f" }
}
Copy-Files 'data/models/nn_int8' '*.mem'; Copy-Files 'data/models/nn_int8' '*.json'

# Source-level simulation only: omit generated state, binaries and recordings.
Get-ChildItem (Join-Path $root 'sim') -Recurse -File | Where-Object {
    $_.FullName -notmatch '\\results[^\\]*\\' -and
    $_.FullName -notmatch '\\__pycache__\\' -and
    $_.Extension -in '.c','.h','.sv','.v','.py','.bat'
} | ForEach-Object {
    $rel = $_.FullName.Substring($root.Length + 1); $out = Join-Path $dest $rel
    New-Item -ItemType Directory -Force (Split-Path $out) | Out-Null; Copy-Item $_.FullName $out -Force
}

foreach ($f in @('build_all.ps1','build_all.bat','create_project.tcl','recreate_project.tcl','update_project.tcl','check_design.tcl','open_project.tcl','project.psd1')) { if (Test-Path (Join-Path $root "build/$f")) { Copy-File "build/$f" } }
Copy-Files 'build/scripts' '*.tcl'; Copy-Files 'build/scripts' '*.ps1'; Copy-Files 'build/scripts' '*.py'; Copy-Files 'build/scripts' '*.bat'; Copy-Files 'build/scripts' '*.md'
foreach ($f in @('build_pl_control_boot.ps1','boot_image_pl_control.bif','SourceHanSans-OFL.txt')) { if (Test-Path (Join-Path $root "build/boot/$f")) { Copy-File "build/boot/$f" } }

$evidence = 'report/submission_evidence'; New-Item -ItemType Directory -Force (Join-Path $dest $evidence) | Out-Null
foreach ($f in @('README.md','comparison.json','timing_routed.rpt','utilization_routed.rpt','utilization_hierarchical.rpt','methodology_routed.rpt','drc_routed.rpt','cdc.rpt','cdc_detailed.rpt','hardware_gates.log','boot_build.log','platform_build.log','bd_contract_test.log','routed_audit_console.log','pipeline_test.log','hdmi_scaler_test.log','hdmi_tmds_test.log','serializer_check.log','output_test.log','lcd_test.log','model_test.log','sd_test.log','hand_test.log','learning_workflow_test.log','uart_test.log','regression_sources.json','baseline_sources.json','baseline_bd_contract.json','artifacts.json')) {
    $src = Join-Path $root "report/hdmi_mirror_20261103/$f"; if (Test-Path $src) { Copy-Item $src (Join-Path $dest "$evidence/$f") -Force }
}
foreach ($f in @('README.md','performance_table.md','resource_table.md','comparison.json')) {
    $src = Join-Path $root "report/resource_optimization_v15_20261027/$f"; if (Test-Path $src) { Copy-Item $src (Join-Path $dest "$evidence/resource_$f") -Force }
}
foreach ($f in @('design_report.docx')) { if (Test-Path (Join-Path $root "report/design_report/$f")) { Copy-File "report/design_report/$f" } }
foreach ($f in @('competition_checklist.md')) { if (Test-Path (Join-Path $root "report/$f")) { Copy-File "report/$f" } }
if (Test-Path (Join-Path $root 'report/ai_collaboration_20261103/submission_guide_review.md')) { Copy-File 'report/ai_collaboration_20261103/submission_guide_review.md' }

# Remove developer-machine paths from copied text evidence. Source reports remain unchanged.
$textExtensions = @('.txt','.md','.json','.log','.rpt','.tcl','.ps1','.bat','.py','.c','.h','.sv','.v','.xdc','.xci','.bif','.psd1','.m')
Get-ChildItem -LiteralPath $dest -Recurse -File | Where-Object { $textExtensions -contains $_.Extension.ToLowerInvariant() } | ForEach-Object {
    $path = $_.FullName
    $text = Get-Content -LiteralPath $path -Raw -Encoding UTF8
    # Source/test inputs keep package-root-relative paths; evidence logs use a
    # neutral marker that cannot disclose the developer checkout.
    $text = $text.Replace($root, './').Replace($root.Replace('\\','/'), './')
    $text = $text.Replace('d:/FPGA/sEMG-HMRS/', './').Replace('D:/FPGA/sEMG-HMRS/', './')
    $text = $text.Replace('d:\\FPGA\\sEMG-HMRS\\', '.\\').Replace('D:\\FPGA\\sEMG-HMRS\\', '.\\')
    $text = $text.Replace('D:/FPGA/sEMG-HMRS', './').Replace('D:\\FPGA\\sEMG-HMRS', '.\\')
    $text = $text.Replace('D:/FPGA/sEMG-HM', '<build-path>').Replace('D:\\FPGA\\sEMG-HM', '<build-path>')
    $text = [regex]::Replace($text, '(?i)[A-Z]:/FPGA/sEMG-H(?:\r?\n)?M(?:\r?\n)?RS', '<repo>')
    $text = [regex]::Replace($text, '(?i)[A-Z]:[\\/]Users[\\/][^\\/\r\n ]+(?:[\\/][^\r\n ]+)*', '<user-path>')
    $text = [regex]::Replace($text, '(?i)[A-Z]:[\\/]FPGA[\\/]VIVADO[\\/][^\\/\r\n ]+', '<amd-tools>')
    $text = [regex]::Replace($text, '(?i)[A-Z]:[\\/]c\+\+[\\/][^\r\n ]+', '<msvc-tools>')
    $text = $text.Replace('D:/FPGA/VIVADO/2025.2/Vitis/bin/vitis.bat', '<amd-tools>/Vitis/bin/vitis.bat')
    $text = $text.Replace('D:/FPGA/VIVADO/2025.2/Vitis/bin/bootgen.bat', '<amd-tools>/Vitis/bin/bootgen.bat')
    $text = $text.Replace('D:\\c++\\VC\\Auxiliary\\Build\\vcvars64.bat', '%VCVARS64_BAT%')
    Set-Content -LiteralPath $path -Value $text -Encoding UTF8
}

# Never ship generated host/target outputs or interpreter caches.
Get-ChildItem -LiteralPath $dest -Recurse -File | Where-Object {
    $_.Extension.ToLowerInvariant() -in @('.elf','.bin','.bit','.dcp','.xsa','.exe','.obj','.pdb','.pyc','.wdb') -or
    $_.FullName -match '\\\.Xil\\|\\runs\\|\\vitis_ws\\'
} | Remove-Item -Force
Get-ChildItem -LiteralPath $dest -Recurse -Directory | Where-Object { $_.Name -in @('__pycache__','.Xil','vitis_ws','runs') } | Sort-Object FullName -Descending | Remove-Item -Recurse -Force

Set-Content -LiteralPath (Join-Path $dest 'README.md') -Value $templateReadme -Encoding utf8
Set-Content -LiteralPath (Join-Path $dest 'MANIFEST.md') -Value $templateManifest -Encoding utf8
Write-Host "ASSEMBLY_PASS $dest"
