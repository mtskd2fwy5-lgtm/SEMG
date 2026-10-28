param([string]$Tag='20261028_HAND_CONTROL_HDC_DYNAMIC_IMU_PL_V17',
      [string]$ReportDir='report/imu_pl_20261028')
$ErrorActionPreference='Stop'
if($Tag -notmatch '^[A-Za-z0-9_]+$'){throw 'Invalid BOOT tag'}
$root=(Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
Push-Location $root
try {
 if($Tag -in @('20261026_HAND_CONTROL_HDC_DYNAMIC_V12','20261026_HAND_CONTROL_HDC_DYNAMIC_V13','20261027_HAND_CONTROL_HDC_DYNAMIC_V14','20261027_HAND_CONTROL_HDC_DYNAMIC_V15')) {
  foreach($check in @(
   @('learning_test.log','^TEST_PASS learning accelerator complete$'),
   @('learning_test.log','^TEST_PASS PL backend failures invalidate model and NMF without software fallback$'),
   @('learning_netlist_test.log','^TEST_PASS learning accelerator complete$'),
   @('fifo_test.log','^TEST_PASS BRAM FIFO coordinated reset during traffic$'),
   @('platform_build.log','^PL_LEARNING_PLATFORM_BUILD_FINISHED$'))) {
   $log=Join-Path 'report/pl_learning_nmf_20261026' $check[0]
   if(!(Test-Path $log) -or !(Select-String -Path $log -Pattern $check[1])) {
    throw "V12 acceptance evidence missing: $log $($check[1])"
   }
  }
 }
 if($Tag -in @('20261026_HAND_CONTROL_HDC_DYNAMIC_V13','20261027_HAND_CONTROL_HDC_DYNAMIC_V14','20261027_HAND_CONTROL_HDC_DYNAMIC_V15')) {
  foreach($check in @(
   @('lcd_test.log','^TEST_PASS VIRTUAL MAPPING:'),
   @('lcd_test.log','^TEST_PASS NAV LIFECYCLE: 144 routes'),
   @('hand_test.log','^TEST_PASS hand firmware:'),
   @('learning_workflow_test.log','^TEST_PASS PL backend failures invalidate model and NMF without software fallback$'),
   @('hdc_golden_test.log','^TEST_PASS C/NumPy exact'))) {
   $uiEvidence=if($Tag -in @('20261027_HAND_CONTROL_HDC_DYNAMIC_V14','20261027_HAND_CONTROL_HDC_DYNAMIC_V15')){'report/virtual_mapping_20261026'}else{$ReportDir}
   $log=Join-Path $uiEvidence $check[0]
   if(!(Test-Path $log) -or !(Select-String -Path $log -Pattern $check[1])) {
    throw "V13 acceptance evidence missing: $log $($check[1])"
   }
  }
 }
 if($Tag -in @('20261027_HAND_CONTROL_HDC_DYNAMIC_V14','20261027_HAND_CONTROL_HDC_DYNAMIC_V15')) {
  foreach($check in @(
   @('shared_equiv.log','^TEST_PASS shared arithmetic equivalence complete$'),
   @('shared_integrated_netlist.log','^TEST_PASS shared synthesized pipeline'),
   @('processed_filter.log','^TEST_PASS line_filter: bit-exact'),
   @('control_regression.log','^TEST_PASS PL shell'),
   @('comparison.log','^FULL_RESOURCE_PERFORMANCE_COMPARISON_PASS$'))) {
   $v14Evidence=if($Tag -eq '20261027_HAND_CONTROL_HDC_DYNAMIC_V15'){'report/resource_optimization_full_20261027'}else{$ReportDir}
   $log=Join-Path $v14Evidence $check[0]
   if(!(Test-Path $log) -or !(Select-String -Path $log -Pattern $check[1])) {
    throw "V14 acceptance evidence missing: $log $($check[1])"
   }
  }
 }
 if($Tag -eq '20261027_HAND_CONTROL_HDC_DYNAMIC_V15') {
  foreach($check in @(
   @('equivalence.log','^TEST_PASS V15 MLP PWM equivalence complete$'),
   @('fatigue_equivalence.log','^TEST_PASS V15 fatigue cycle-exact 576 words'),
   @('netlist_test_complete.log','^TEST_PASS V15 synthesized modules complete$'),
   @('integrated_test.log','^TEST_PASS V15 integrated OOC MLP FFT'),
   @('control_regression.log','^TEST_PASS PL shell'),
   @('comparison.log','^V15_RESOURCE_PERFORMANCE_COMPARISON_PASS$'))) {
   $log=Join-Path $ReportDir $check[0]
   if(!(Test-Path $log) -or !(Select-String -Path $log -Pattern $check[1])) {
    throw "V15 acceptance evidence missing: $log $($check[1])"
   }
  }
 }
 & powershell -ExecutionPolicy Bypass -File build/build_all.ps1 -SkipBuild -SkipBoot
 if($LASTEXITCODE -ne 0){throw 'Hardware acceptance gates failed'}
 & python tools/verify_control_boot.py --hardware-only --tag $Tag
 if($LASTEXITCODE -ne 0){throw 'Hardware does not contain the matching PL control mailbox'}
 Push-Location sw/ps_uart_print
 try {& cmd /c build.bat --pl-control;if($LASTEXITCODE -ne 0){throw 'PL-control ARM build failed'}}
 finally {Pop-Location}
 & python tools/verify_control_boot.py --application-only --tag $Tag
 if($LASTEXITCODE -ne 0){throw 'Application build tag mismatch; BOOT was not written'}
 & 'D:/FPGA/VIVADO/2025.2/Vitis/bin/bootgen.bat' -arch zynq -image build/boot/boot_image_pl_control.bif -w -o i "build/boot/BOOT_$Tag.BIN"
 if($LASTEXITCODE -ne 0){throw 'PL-control bootgen failed'}
 & python tools/verify_control_boot.py --tag $Tag --report-dir $ReportDir
 if($LASTEXITCODE -ne 0){throw 'Matched hardware/application BOOT verification failed'}
} finally {Pop-Location}
