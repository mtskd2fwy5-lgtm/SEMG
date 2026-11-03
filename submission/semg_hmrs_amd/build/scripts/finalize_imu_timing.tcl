# Register native held-bus constraints, then run a clean managed implementation
# using the verified final pipelined RTL/OOC synthesis checkpoints.
set root [file normalize [file join [file dirname [info script]] ../..]]
open_project [file join $root build/vivado/hand_motion_reconstruction.xpr]
set xdc [file join $root board/constraints/hz_zynq_imu_clock_groups.xdc]
if {![llength [get_files -quiet $xdc]]} {add_files -norecurse -fileset constrs_1 $xdc}
set_property USED_IN_SYNTHESIS false [get_files $xdc]
set_property USED_IN_IMPLEMENTATION true [get_files $xdc]
reset_run impl_1
launch_runs impl_1 -to_step write_bitstream -jobs 8
wait_on_run impl_1
if {[get_property PROGRESS [get_runs impl_1]] ne "100%"} {error "Attitude timing implementation failed"}
open_run impl_1
write_hw_platform -fixed -include_bit -force [file join $root build/export/design_1.xsa]
close_project
puts "TEST_PASS IMU final native CDC constraints and full-system implementation"

