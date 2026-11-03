set root [file normalize [file join [file dirname [info script]] ../..]]
open_checkpoint [file join $root build/vivado/hand_motion_reconstruction.runs/impl_1/design_1_opt.dcp]
read_xdc [file join $root board/constraints/hz_zynq_imu_clock_groups.xdc]
set meta [get_cells -hier -filter {NAME =~ mpu_attitude_0/inst/sequence_meta_reg*}]
set bus [get_cells -hier -filter {NAME =~ mpu_attitude_0/inst/sensor_?_reg*}]
set launch [get_cells -hier -filter {NAME =~ mpu6050_tilt_0/*/motion_?_reg*}]
if {[llength $meta]!=8 || [llength $bus]!=96 || [llength $launch]!=96} {error "CDC endpoint coverage mismatch"}
report_methodology -file [file join $root report/imu_pl_20261028/native_cdc_methodology.rpt]
puts "TEST_PASS native IMU CDC constraints meta=8 data=96 source=96"
close_design

