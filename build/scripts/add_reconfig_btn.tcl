# Add the PL_KEY0 ADS1299 reconfig button to design_1.
#
# Prerequisite: src/rtl/emg_pl_export.v now has a reconfig_n input port.
# This script refreshes the module_ref caches (validate_bd_design -force,
# required after any emg_pl_export change - see project memory), creates the
# external port and wires it to emg_pl_export_0/reconfig_n.
#
# Run (Vivado Tcl console or batch):
#   vivado -mode batch -source build/scripts/add_reconfig_btn.tcl
# The board constraint (PL_KEY0 = B35_L22P = L14) is already in
# board/constraints/hz_zynq_ads1299_bd.xdc as port reconfig_n_0.

set project_root [file normalize [file join [file dirname [info script]] .. ..]]
# Tolerate running from the GUI Tcl console with the project/BD already open.
set owned 0
if {[llength [get_projects -quiet hand_motion_reconstruction]] == 0} {
    open_project [file join $project_root build vivado hand_motion_reconstruction.xpr]
    set owned 1
}
if {[llength [get_bd_designs -quiet design_1]] == 0} {
    open_bd_design [get_files design_1.bd]
}

# Refresh module_ref so the new RTL port appears on the cell.
validate_bd_design -force
# New PORTS on the referenced module require an explicit refresh of the
# cell pin list; validate_bd_design alone only re-elaborates internals.
# Some Vivado sessions keep the module cache valid and reject the update -
# the pin assertion below is the hard check either way.
if {[catch {update_module_reference emg_pl_export_0} umsg]} {
    puts "INFO: update_module_reference rejected: $umsg"
    reset_target all [get_bd_cells emg_pl_export_0]
    validate_bd_design
}

set cell [get_bd_cells emg_pl_export_0]
if {[llength [get_bd_pins -quiet $cell/reconfig_n]] == 0} {
    error "emg_pl_export_0 has no reconfig_n pin - validate_bd_design -force did not pick up the RTL change"
}
if {[llength [get_bd_ports -quiet reconfig_n]] == 0} {
    create_bd_port -dir I reconfig_n
}
connect_bd_net [get_bd_ports reconfig_n] [get_bd_pins $cell/reconfig_n]

validate_bd_design
save_bd_design
puts "add_reconfig_btn: port reconfig_n created and connected to emg_pl_export_0/reconfig_n"
if {$owned} {
    close_project
}
