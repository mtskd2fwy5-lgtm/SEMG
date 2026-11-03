# Add the shared notch dependency to an existing project, retaining BD wiring.
# Run before resynthesis: source build/scripts/add_notch50.tcl
set root [file normalize [file join [file dirname [info script]] .. ..]]
set owned 0
if {[llength [get_projects -quiet]] == 0} {
    open_project [file join $root build vivado hand_motion_reconstruction.xpr]
    set owned 1
}
foreach module {emg_notch50 emg_comb50 emg_line_filter} {
    set source_file [file join $root src rtl ${module}.v]
    if {[llength [get_files -quiet $source_file]] == 0} {
        add_files -fileset sources_1 -norecurse $source_file
    }
}
update_compile_order -fileset sources_1
if {[llength [get_bd_designs -quiet design_1]] == 0} {
    open_bd_design [get_files design_1.bd]
}
set cell [get_bd_cells -quiet emg_pl_export_0]
if {[llength $cell] != 1} { error "Expected existing emg_pl_export_0 module reference" }
# The external module interface is unchanged. Force validation, as in the
# existing check_design.tcl flow, to rebind the module source dependencies.
# update_module_reference returns an empty Tcl error in Vivado 2025.2 here.
validate_bd_design -force
save_bd_design
puts "NOTCH_SOURCE_READY: source added and existing BD validated"
if {$owned} { close_project }

