# One-shot repair: re-validate design_1 so the emg_pl_export_0 module-ref
# XCI re-binds to the changed RTL (emg_pl_export.v now instantiates
# emg_nn_infer, which invalidates the module definition cached in the XCI
# -> [filemgmt 56-587] at launch_runs).
#
# Usage: vivado -mode batch -source build/fix_bd_refs.tcl

set project_root [file normalize [file join [file dirname [info script]] ..]]
set project_file [file join $project_root build vivado hand_motion_reconstruction.xpr]

open_project $project_file
set bd_file [get_files -quiet -of [get_filesets sources_1] design_1.bd]
if {[llength $bd_file] == 0} {
    error "design_1.bd not found in project sources_1"
}
open_bd_design [lindex $bd_file 0]
validate_bd_design -force
save_bd_design
generate_target all [get_files design_1.bd]
close_project
puts "BD-REFS FIXED"
