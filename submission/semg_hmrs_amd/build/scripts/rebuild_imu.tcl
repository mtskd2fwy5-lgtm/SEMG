# Reimplement the full system after an attitude-only internal timing edit.
# Reuse unchanged IP OOC checkpoints from this same full-system build.
set root [file normalize [file join [file dirname [info script]] ../..]]
source [file join $root build/update_project.tcl]
open_project [file join $root build/vivado/hand_motion_reconstruction.xpr]
update_compile_order -fileset sources_1
open_bd_design [get_files design_1.bd]
validate_bd_design -force
save_bd_design
generate_target all [get_files design_1.bd]
close_bd_design [current_bd_design]
reset_run design_1_mpu_attitude_0_0_synth_1
reset_run synth_1
launch_runs impl_1 -to_step write_bitstream -jobs 8
wait_on_run impl_1
if {[get_property PROGRESS [get_runs impl_1]] ne "100%"} {error "Attitude reimplementation failed"}
open_run impl_1
write_hw_platform -fixed -include_bit -force [file join $root build/export/design_1.xsa]
close_project
puts "TEST_PASS IMU full-system reimplementation complete"

