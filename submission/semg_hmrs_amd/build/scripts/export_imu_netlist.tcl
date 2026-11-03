set root [file normalize [file join [file dirname [info script]] ../..]]
set out [file join $root report imu_pl_20261028 ooc]
file mkdir $out
open_checkpoint [file join $root build vivado hand_motion_reconstruction.runs design_1_mpu_attitude_0_0_synth_1 design_1_mpu_attitude_0_0.dcp]
report_utilization -file [file join $out utilization_synth.rpt]
write_verilog -force -mode funcsim -rename_top mpu_attitude [file join $out attitude_funcsim.v]
puts "TEST_PASS IMU netlist exported from actual full-build OOC checkpoint"

