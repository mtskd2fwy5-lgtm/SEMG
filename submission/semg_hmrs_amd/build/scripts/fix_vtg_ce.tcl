# Wire v_axi4s_vid_out_0/vtg_ce into lcd_panel_adapter_0/vtg_ce.
#
# Root cause of the permanent white screen: v_axi4s_vid_out is a VTG *slave*
# (C_VTG_MASTER_SLAVE=0).  Its synchronizer stalls the timing master through
# vtg_ce while it waits for the stream SOF and fills its FIFO, and can only
# reach FALN_LOCK that way.  The old v_tc_0 received vtg_ce on gen_clken;
# when v_tc_0 was replaced by lcd_panel_adapter (add_lcd_autodetect.tcl) the
# vtg_ce output was left dangling and the free-running generator never let
# vid_out lock (locked=0, DE never asserted).  Reproduced in xsim against
# the IP's own RTL: free-running VTG -> never locks, vtg_ce-gated -> locks.
#
# The adapter now has a vtg_ce input; this script refreshes the module_ref
# and connects the net.
#
# IMPORTANT: run OUTSIDE the TRAE sandbox:
#   vivado -mode batch -source build/scripts/fix_vtg_ce.tcl
# Then rebuild: build\build_all.bat (full build + gates + BOOT.BIN).

set project_root [file normalize [file join [file dirname [info script]] .. ..]]
set owned 0
if {[llength [get_projects -quiet hand_motion_reconstruction]] == 0} {
    open_project [file join $project_root build vivado hand_motion_reconstruction.xpr]
    set owned 1
}
if {[llength [get_bd_designs -quiet design_1]] == 0} {
    open_bd_design [get_files design_1.bd]
}

update_compile_order -fileset sources_1

set ad [get_bd_cells lcd_panel_adapter_0]
set vo [get_bd_cells v_axi4s_vid_out_0]

# Pick up the new vtg_ce port on the module reference.
update_module_reference [get_ips -quiet design_1_lcd_panel_adapter_0_1]
# The upgrade replaces the cell's pins; re-resolve everything by name.
set ad [get_bd_cells lcd_panel_adapter_0]
set vo [get_bd_cells v_axi4s_vid_out_0]
puts "FIX-VTG-CE adapter pins: [get_bd_pins -quiet -of_objects $ad]"
if {[llength [get_bd_pins -quiet -of_objects $ad -filter {NAME == vtg_ce}]] == 0} {
    error "FIX-VTG-CE: adapter has no vtg_ce pin after update_module_reference"
}

set old [get_bd_nets -quiet -of_objects [get_bd_pins -of_objects $ad -filter {NAME == vtg_ce}]]
if {[llength $old]} {
    puts "FIX-VTG-CE: adapter/vtg_ce already on net $old - reconnecting"
    disconnect_bd_net $old [get_bd_pins -of_objects $ad -filter {NAME == vtg_ce}]
}
set oldvo [get_bd_nets -quiet -of_objects [get_bd_pins -of_objects $vo -filter {NAME == vtg_ce}]]
if {[llength $oldvo]} {
    disconnect_bd_net $oldvo [get_bd_pins -of_objects $vo -filter {NAME == vtg_ce}]
}
connect_bd_net [get_bd_pins -of_objects $vo -filter {NAME == vtg_ce}] [get_bd_pins -of_objects $ad -filter {NAME == vtg_ce}]

validate_bd_design -force
save_bd_design
generate_target all [get_files design_1.bd]

puts "FIX-VTG-CE net: [get_bd_nets -of_objects [get_bd_pins -of_objects $ad -filter {NAME == vtg_ce}]]"
puts "FIX-VTG-CE DONE"
if {$owned} {
    close_project
}

