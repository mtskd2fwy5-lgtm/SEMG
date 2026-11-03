# Recreate the current XC7Z020 design from version-controlled inputs.
# Usage: vivado -mode batch -source build/recreate_project.tcl
set root [file normalize [file join [file dirname [info script]] ..]]
set project_dir [file join $root build vivado]
set project_file [file join $project_dir hand_motion_reconstruction.xpr]
set part xc7z020clg400-2

if {[file exists $project_file]} { error "Project already exists: $project_file" }
create_project hand_motion_reconstruction $project_dir -part $part
set_property target_language Verilog [current_project]
set_property simulator_language Mixed [current_project]

set rtl [glob -nocomplain -directory [file join $root src rtl] -types f *.v *.sv *.vh]
if {[llength $rtl]} { add_files -norecurse -fileset sources_1 $rtl }
set sim [glob -nocomplain -directory [file join $root sim] -types f *.v *.sv]
if {[llength $sim]} { add_files -norecurse -fileset sim_1 $sim }
set xdc [glob -nocomplain -directory [file join $root board constraints] -types f *.xdc]
if {[llength $xdc]} { add_files -norecurse -fileset constrs_1 $xdc }

set bd [file join $root build vivado hand_motion_reconstruction.srcs sources_1 bd design_1 design_1.bd]
if {![file exists $bd]} { error "Canonical block design missing: $bd" }
add_files -norecurse -fileset sources_1 $bd
set_property top design_1 [get_filesets sources_1]
set_property top ads1299_functional_tb [get_filesets sim_1]
set_property include_dirs [list [file join $root src rtl]] [get_filesets sources_1]
set_property include_dirs [list [file join $root src rtl]] [get_filesets sim_1]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
generate_target all [get_files $bd]
validate_bd_design
save_bd_design
close_project
puts "TEST_PASS project recreated: $project_file ($part)"

