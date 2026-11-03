# Rebuild the changed learning accelerator and the real routed system.
# Unchanged OOC IPs remain bound to this project, not substituted stubs.
set root [file normalize [file join [file dirname [info script]] ../..]]
set out [file join $root report/hdc_resolution_20261102]
file mkdir $out
source [file join $root build/update_project.tcl]
open_project [file join $root build/vivado/hand_motion_reconstruction.xpr]
update_compile_order -fileset sources_1
open_bd_design [get_files design_1.bd]
validate_bd_design -force
save_bd_design
generate_target all [get_files design_1.bd]
close_bd_design [current_bd_design]
reset_run design_1_emg_learning_0_0_synth_1
reset_run synth_1
launch_runs impl_1 -to_step write_bitstream -jobs 8
wait_on_run impl_1
if {[get_property PROGRESS [get_runs impl_1]] ne "100%"} {error "HDC reimplementation failed"}
open_run impl_1
report_timing_summary -file [file join $out timing_routed.rpt]
report_utilization -file [file join $out utilization_routed.rpt]
report_utilization -hierarchical -file [file join $out utilization_hierarchical.rpt]
report_methodology -file [file join $out methodology_routed.rpt]
report_drc -file [file join $out drc_routed.rpt]
foreach kind {max min} {
    set worst [get_timing_paths -delay_type $kind -max_paths 1]
    if {![llength $worst] || [get_property SLACK $worst] < 0} {
        error "HDC $kind timing failed; XSA export refused"
    }
}
write_hw_platform -fixed -include_bit -force [file join $root build/export/design_1.xsa]
close_project
puts "TEST_PASS HDC Q32 full-system reimplementation complete"
