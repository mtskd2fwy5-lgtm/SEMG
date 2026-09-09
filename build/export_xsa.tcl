# Quick re-export of the hardware platform (XSA) from the completed
# impl_1 run. Separate from check_design.tcl so an export hiccup never
# costs a re-implementation.
#
# Usage: vivado -mode batch -source build/export_xsa.tcl

set script_dir [file dirname [info script]]
set project_root [file normalize [file join $script_dir ..]]
set project_file [file join $project_root build vivado hand_motion_reconstruction.xpr]
set export_dir [file join $project_root build export]
file mkdir $export_dir

open_project $project_file
open_run impl_1
write_hw_platform -fixed -include_bit -force \
    [file join $export_dir design_1.xsa]
close_project
puts "EXPORT-XSA DONE"
