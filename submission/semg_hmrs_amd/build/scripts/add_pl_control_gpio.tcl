# Native Vivado 2025.2 fallback (MCP unavailable). GPIO directions, dual
# channel enable, widths and DATA2 offset8 checked in installed component.xml.
set root [file normalize [file join [file dirname [info script]] .. ..]]
source [file join $root build update_project.tcl]
open_project [file join $root build vivado hand_motion_reconstruction.xpr]
open_bd_design [get_files design_1.bd]
proc control_connect {a b} {
    set na [get_bd_nets -quiet -of_objects $a]
    set nb [get_bd_nets -quiet -of_objects $b]
    if {[llength $na] && $na eq $nb} {return}
    if {[llength $na] && [llength $nb]} {error "Conflicting control nets: $a $b"}
    connect_bd_net $a $b
}
set name emg_pl_export_0
if {![llength [get_bd_pins -quiet $name/control_command]]} {
    set pin_nets [dict create]
    foreach pin [get_bd_pins -of_objects [get_bd_cells $name]] {
        set net [get_bd_nets -quiet -of_objects $pin]
        if {[llength $net]} {dict set pin_nets [file tail $pin] $net}
    }
    set intf_nets [dict create]
    foreach pin [get_bd_intf_pins -of_objects [get_bd_cells $name]] {
        set net [get_bd_intf_nets -quiet -of_objects $pin]
        if {[llength $net]} {dict set intf_nets [file tail $pin] $net}
    }
    set params [list]
    foreach p [list_property [get_bd_cells $name]] {
        if {[string match CONFIG.* $p] && $p ne "CONFIG.Component_Name"} {
            lappend params $p [get_property $p [get_bd_cells $name]]
        }
    }
    delete_bd_objs [get_bd_cells $name]
    create_bd_cell -type module -reference emg_pl_control $name
    if {[llength $params]} {set_property -dict $params [get_bd_cells $name]}
    dict for {pin net} $intf_nets {
        connect_bd_intf_net [get_bd_intf_pins $name/$pin] [get_bd_intf_pins -of_objects [get_bd_intf_nets $net]]
    }
    dict for {pin net} $pin_nets {
        set port [get_bd_pins $name/$pin]
        if {![llength [get_bd_nets -quiet -of_objects $port]]} {connect_bd_net -net $net $port}
    }
}
if {![llength [get_bd_cells -quiet axi_gpio_4]]} {
    create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_4
}
set_property -dict {CONFIG.C_GPIO_WIDTH 32 CONFIG.C_ALL_OUTPUTS 1 CONFIG.C_DOUT_DEFAULT 0x00000000 CONFIG.C_IS_DUAL 1 CONFIG.C_GPIO2_WIDTH 32 CONFIG.C_ALL_INPUTS_2 1} [get_bd_cells axi_gpio_4]
control_connect [get_bd_pins axi_gpio_4/gpio_io_o] [get_bd_pins emg_pl_export_0/control_command]
control_connect [get_bd_pins emg_pl_export_0/control_status] [get_bd_pins axi_gpio_4/gpio2_io_i]
control_connect [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins axi_gpio_4/s_axi_aclk]
control_connect [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_gpio_4/s_axi_aresetn]
if {![llength [get_bd_intf_nets -quiet -of_objects [get_bd_intf_pins axi_gpio_4/S_AXI]]]} {
    set slot -1
    for {set i 0} {$i<16} {incr i} {
        set pin [get_bd_intf_pins -quiet smartconnect_0/M[format %02d $i]_AXI]
        if {![llength $pin] || ![llength [get_bd_intf_nets -quiet -of_objects $pin]]} {set slot $i;break}
    }
    if {$slot<0} {error "No available GP0 SmartConnect slot"}
    set count [get_property CONFIG.NUM_MI [get_bd_cells smartconnect_0]]
    if {$slot >= $count} {set_property CONFIG.NUM_MI [expr {$slot+1}] [get_bd_cells smartconnect_0]}
    connect_bd_intf_net [get_bd_intf_pins smartconnect_0/M[format %02d $slot]_AXI] [get_bd_intf_pins axi_gpio_4/S_AXI]
}
assign_bd_address -offset 0x41240000 -range 0x10000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_gpio_4/S_AXI/Reg]
validate_bd_design -force
foreach {p expected} {C_IS_DUAL 1 C_GPIO_WIDTH 32 C_GPIO2_WIDTH 32 C_ALL_OUTPUTS 1 C_ALL_INPUTS_2 1} {
    set actual [get_property CONFIG.$p [get_bd_cells axi_gpio_4]]
    if {$actual != $expected} {error "PL control GPIO mismatch $p=$actual"}
    puts "CONTROL_GPIO_READBACK $p=$actual"
}
foreach {pin direction} {axi_gpio_4/gpio_io_o O axi_gpio_4/gpio2_io_i I emg_pl_export_0/control_command I emg_pl_export_0/control_status O} {
    set p [get_bd_pins $pin]
    if {[get_property DIR $p] ne $direction || [get_property LEFT $p]!=31 || [get_property RIGHT $p]!=0} {error "PL control port mismatch $pin"}
}
save_bd_design
puts "CONTROL_GPIO_PASS command=0x41240000 status=0x41240008 PWM_UNCONNECTED"
close_project

