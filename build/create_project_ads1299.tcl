# Create a clean Vivado project with the physical ADS1299 top level.
# Usage from a Vivado Tcl Console:
#   source {build/create_project_ads1299.tcl}

set project_root [file normalize [file join [file dirname [info script]] ..]]
set project_name "hand_motion_reconstruction"
set project_dir [file join $project_root build vivado]
set part_name "xc7z020clg400-2"

file mkdir $project_dir
create_project $project_name $project_dir -part $part_name -force
set_property target_language Verilog [current_project]
set_property simulator_language Mixed [current_project]

set rtl_dir [file join $project_root src rtl]
set sim_dir [file join $project_root sim]
set xdc_dir [file join $project_root board constraints]

set rtl_files [glob -nocomplain -directory $rtl_dir -types f *.v *.sv]
set sim_files [glob -nocomplain -directory $sim_dir -types f *.v *.sv]
set xdc_files [glob -nocomplain -directory $xdc_dir -types f *.xdc]

if {[llength $rtl_files] > 0} { add_files -fileset sources_1 $rtl_files }
if {[llength $sim_files] > 0} { add_files -fileset sim_1 $sim_files }
if {[llength $xdc_files] > 0} { add_files -fileset constrs_1 $xdc_files }

set_property top hand_motion_top [get_filesets sources_1]
set_property top ads1299_functional_tb [get_filesets sim_1]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

puts "Project created: $project_dir/$project_name.xpr"
puts "Synthesis top: hand_motion_top"
puts "Simulation top: ads1299_functional_tb"
puts "Constraint files: $xdc_files"
