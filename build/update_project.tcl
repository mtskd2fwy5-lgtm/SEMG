# Synchronize source files and top modules in the existing Vivado project.
# Usage: vivado -mode batch -source build/update_project.tcl

set project_root [file normalize [file join [file dirname [info script]] ..]]
set project_file [file join $project_root build vivado hand_motion_reconstruction.xpr]

if {![file exists $project_file]} {
    error "Project does not exist: $project_file"
}

open_project $project_file

set rtl_files [glob -nocomplain -directory [file join $project_root src rtl] -types f *.v *.sv]
set sim_files [glob -nocomplain -directory [file join $project_root sim] -types f *.v *.sv]
set xdc_files [glob -nocomplain -directory [file join $project_root board constraints] -types f *.xdc]

if {[llength $rtl_files] > 0} {
    add_files -norecurse -fileset sources_1 $rtl_files
}
if {[llength $sim_files] > 0} {
    add_files -norecurse -fileset sim_1 $sim_files
}
if {[llength $xdc_files] > 0} {
    add_files -norecurse -fileset constrs_1 $xdc_files
}

set_property top ads1299_spi [get_filesets sources_1]
set_property top ads1299_functional_tb [get_filesets sim_1]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
save_project
close_project

puts "Updated project: $project_file"
