# Rewire smartconnect_0 after v_tc_0 removal and shrink it to 3 masters.
#
# Topology (from add_lcd_vdma.tcl): M00=axi_dma_0, M01=vdma S_AXI_LITE,
# M02=v_tc ctrl (cell deleted by add_lcd_autodetect.tcl -> dangling),
# M03=axi_gpio_0. The dangling M02 leaves the smartconnect re-customization
# with a broken embedded-BD netlist (bd_48ac_m02e_0 module missing at OOC
# synth, Synth 8-439). Fix: move GPIO M03->M02, NUM_MI 4->3, full regen.
#
# Usage: vivado -mode batch -source build/scripts/fix_smartconnect.tcl

set script_dir [file dirname [info script]]
set project_root [file normalize [file join $script_dir .. ..]]
set project_file [file join $project_root build vivado hand_motion_reconstruction.xpr]

open_project $project_file
set bd_file [lindex [get_files -quiet -of [get_filesets sources_1] design_1.bd] 0]
open_bd_design $bd_file

set sc [lindex [get_bd_cells smartconnect_0] 0]
puts "SC-FIX cell=$sc NUM_MI=[get_property CONFIG.NUM_MI $sc]"

# ---- verify expected topology before touching anything ---------------------
set net02 [get_bd_intf_nets -quiet -of_objects [get_bd_intf_pins $sc/M02_AXI]]
set net03 [get_bd_intf_nets -quiet -of_objects [get_bd_intf_pins $sc/M03_AXI]]
if {[llength $net02] != 0} { error "SC-FIX M02 not dangling - topology changed, refusing to guess" }
if {[llength $net03] != 1} { error "SC-FIX M03 not connected - topology changed, refusing to guess" }

# ---- move GPIO M03 -> M02, shrink to 3 --------------------------------------
# NOTE: filter NAME matches the RELATIVE pin name (no path prefix).
set other [get_bd_intf_pins -of_objects $net03 -filter {NAME !~ "M03_AXI" && NAME =~ "S_AXI"}]
if {[llength $other] != 1} { error "SC-FIX expected exactly one slave endpoint on M03 net, got: $other" }
puts "SC-FIX moving $other from M03 to M02"
disconnect_bd_intf_net $net03 [get_bd_intf_pins $sc/M03_AXI]
set_property CONFIG.NUM_MI 3 $sc
connect_bd_intf_net [get_bd_intf_pins $sc/M02_AXI] $other

validate_bd_design -force
save_bd_design
puts "SC-FIX new NUM_MI=[get_property CONFIG.NUM_MI $sc]"

# ---- full parent-driven regeneration ----------------------------------------
generate_target all [get_files design_1.bd]

# ---- verify the smartconnect embedded-BD carries the M02 exit pipeline ------
set scdir [file dirname [file normalize [get_property IP_FILE [get_ips design_1_smartconnect_0_0]]]]
set m02e [glob -nocomplain $scdir/bd_0/ip/*/bd_48ac_m02e_0/synth/*]
puts "SC-FIX m02e files: [llength $m02e]"
if {[llength $m02e] == 0} {
    error "SC-FIX bd_48ac_m02e_0.v still missing under $scdir"
}

close_project
puts "SC-FIX DONE"
