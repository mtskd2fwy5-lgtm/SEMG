# Add one isolated HP1 memory master and one acknowledged command mailbox.
# Parameter descriptions are verified against the installed 2025.2 IP XML:
# PS7 PCW_USE_S_AXI_HP1 enables HP1; GPIO dual channel1=output/channel2=input;
# SmartConnect NUM_SI/NUM_MI count slave/master interfaces respectively.
set root [file normalize [file join [file dirname [info script]] ../..]]
source [file join $root build update_project.tcl]
open_project [file join $root build/vivado/hand_motion_reconstruction.xpr]
open_bd_design [get_files design_1.bd]
source {<user-path>
set ::ipcfg::native_log_path [file join $root report/pl_learning_nmf_20261026/add_pl_learning.log]
puts [ipcfg::python_status]
puts [ipcfg::python_exec -c {import argparse,base64,hashlib,json,pathlib,re,sys,typing;print("PYTHON_IMPORTS:OK")}]
set ledger {}
proc cfg {cell d} {
    global ledger
    set intent {}
    foreach {k v} $d {lappend intent $k $v [get_property $k [get_bd_cells $cell]]}
    puts [ipcfg::apply_dict $cell $d]
    set stuck [ipcfg::verify_stuck $cell $d]
    set bad [ipcfg::verify_intent $cell $intent 0]
    if {[llength $stuck] || [llength $bad]} {error "PL learning config mismatch $cell: $stuck $bad"}
    dict set ledger $cell [dict create requested $d stuck $stuck intent $bad]
    puts "LEARNING_CONFIG_PASS $cell $d"
}
proc ensure_ip {name core d} {
    if {![llength [get_bd_cells -quiet $name]]} {
        set vlnv [lindex [lsort -dictionary [get_ipdefs -all -filter "NAME == $core"]] end]
        if {$vlnv eq ""} {error "IP not found $core"}
        puts [ipcfg::create_cell_cfg $vlnv $name $d]
    }
    cfg $name $d
}
proc wire_pin {a b} {
    set pa [get_bd_pins $a];set pb [get_bd_pins $b]
    set na [get_bd_nets -quiet -of_objects $pa];set nb [get_bd_nets -quiet -of_objects $pb]
    if {[llength $na] && $na eq $nb} {return}
    if {[llength $na] && [llength $nb]} {error "Conflicting nets $a $b"}
    connect_bd_net $pa $pb
}
proc wire_bus {a b} {
    set pa [get_bd_intf_pins $a];set pb [get_bd_intf_pins $b]
    if {![llength [get_bd_intf_nets -quiet -of_objects $pa]]} {connect_bd_intf_net $pa $pb}
}
if {![llength [get_bd_cells -quiet emg_learning_0]]} {
    create_bd_cell -type module -reference emg_learning_accel emg_learning_0
}
cfg processing_system7_0 {CONFIG.PCW_USE_S_AXI_HP1 1}
ensure_ip smartconnect_learning smartconnect {CONFIG.NUM_SI 1 CONFIG.NUM_MI 1}
ensure_ip axi_gpio_6 axi_gpio {CONFIG.C_GPIO_WIDTH 32 CONFIG.C_ALL_OUTPUTS 1 CONFIG.C_DOUT_DEFAULT 0x00000000 CONFIG.C_IS_DUAL 1 CONFIG.C_GPIO2_WIDTH 32 CONFIG.C_ALL_INPUTS_2 1}
if {[get_property CONFIG.NUM_MI [get_bd_cells smartconnect_0]]<9} {cfg smartconnect_0 {CONFIG.NUM_MI 9}}
wire_bus smartconnect_0/M08_AXI axi_gpio_6/S_AXI
wire_bus emg_learning_0/M_AXI smartconnect_learning/S00_AXI
wire_bus smartconnect_learning/M00_AXI processing_system7_0/S_AXI_HP1
foreach p {emg_learning_0/clk smartconnect_learning/aclk axi_gpio_6/s_axi_aclk processing_system7_0/S_AXI_HP1_ACLK} {
    wire_pin processing_system7_0/FCLK_CLK0 $p
}
foreach p {emg_learning_0/rst_n smartconnect_learning/aresetn axi_gpio_6/s_axi_aresetn} {
    wire_pin proc_sys_reset_0/peripheral_aresetn $p
}
wire_pin axi_gpio_6/gpio_io_o emg_learning_0/command
wire_pin emg_learning_0/status axi_gpio_6/gpio2_io_i
assign_bd_address -offset 0x41260000 -range 0x10000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_gpio_6/S_AXI/Reg]
assign_bd_address -offset 0x00000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces emg_learning_0/M_AXI] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM]
validate_bd_design -force
save_bd_design
puts [ipcfg::write_evidence [file join $root report/pl_learning_nmf_20261026/ip_config.tcldict] $ledger]
puts "PL_LEARNING_BD_PASS mailbox=0x41260000 DDR=HP1 clock=100MHz ABI=0x12"
close_project

