# Supported GUI entry point: resolve lazy-loaded RTL module references
# before presenting IP status. Usage: vivado -source build/open_project.tcl
set root [file normalize [file join [file dirname [info script]] ..]]
open_project [file join $root build vivado hand_motion_reconstruction.xpr]
update_compile_order -fileset sources_1
open_bd_design [get_files design_1.bd]
validate_bd_design -force
puts "PROJECT_OPEN_READY: module references resolved and BD validated"

