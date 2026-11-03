param([switch]$SkipCore,[switch]$SkipHost,[switch]$Netlist)
$ErrorActionPreference='Stop'
$root=(Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$report=Join-Path $root 'report/imu_pl_20261028'
$bin='<amd-tools>/Vivado/bin'
New-Item -ItemType Directory -Force $report | Out-Null
function Check-Exit($message) {if($LASTEXITCODE -ne 0){throw $message}}
Push-Location $root
try {
 if(!$Netlist) {
  if(!$SkipHost) {
  # Compile the exact ROM tested in RTL into the test-only host interpreter.
  & cmd /c "python tools/verify_imu_vectors.py > `"$report/float_comparison.log`" 2>&1"
  Check-Exit 'Q24/float comparison failed'
  foreach($name in @('imu_mailbox_firmware','hand_firmware','pl_learning_workflow')) {
   $source=if($name -eq 'imu_mailbox_firmware'){'imu_mailbox_firmware_test'}else{"${name}_test"}
   $log=if($name -eq 'imu_mailbox_firmware'){'mailbox_firmware'}elseif($name -eq 'pl_learning_workflow'){'learning_workflow_test'}else{'hand_test'}
   & cmd /c "call `"<msvc-tools> >nul && cl /nologo /utf-8 /std:c11 /O2 /w sim/$source.c /Fo:`"$report/$source.obj`" /Fe:`"$report/$source.exe`" > `"$report/$source.compile.log`" 2>&1 && `"$report/$source.exe`" > `"$report/$log.log`" 2>&1"
   Check-Exit "Host IMU regression failed: $source"
  }
  & cmd /c "set PSModulePath=C:\Windows\System32\WindowsPowerShell\v1.0\Modules&& powershell -NoProfile -ExecutionPolicy Bypass -File build/scripts/run_lcd_firmware_test.ps1 > `"$report/lcd_test.log`" 2>&1"
  Check-Exit 'LCD Q24 consumer regression failed'
  }
  $sources=@('src/rtl/learning_div64.v','src/rtl/mpu_attitude_core.v','src/rtl/mpu_attitude.v')
  $cases=,@('mpu_attitude_mailbox_tb','rtl_mailbox','TEST_PASS PL attitude mailbox CDC settling')
  if(!$SkipCore){$cases+=,@('mpu_attitude_vectors_tb','rtl_vectors','TEST_PASS PL attitude bit-exact replay samples=')}
 } else {
  $sources=@("$report/ooc/attitude_funcsim.v","$bin/../data/verilog/src/glbl.v")
  $cases=,@('mpu_attitude_mailbox_tb','netlist_mailbox','TEST_PASS synthesized PL attitude calibration, 60deg twist')
 }
 foreach($case in $cases) {
  $top=$case[0];$name=$case[1];$pass=$case[2]
  $defines=if($Netlist){@('-d','IMU_NETLIST_TEST')}else{@()}
  & "$bin/xvlog.bat" -sv -i src/rtl @defines @sources "sim/$top.sv"
  Check-Exit 'Attitude RTL/netlist compile failed'
  $libraries=if($Netlist){@('glbl','-L','unisims_ver','-L','unimacro_ver')}else{@()}
  & "$bin/xelab.bat" $top @libraries -s "imu_$name" -debug typical
  Check-Exit 'Attitude elaboration failed'
  & "$bin/xsim.bat" "imu_$name" -runall -log "$report/$name.log"
  Check-Exit 'Attitude simulation failed'
  if(!(Select-String -Path "$report/$name.log" -SimpleMatch $pass)){throw "Attitude functional PASS absent: $name"}
 }
 Write-Output 'TEST_PASS IMU migration regression complete'
}finally{Pop-Location}

