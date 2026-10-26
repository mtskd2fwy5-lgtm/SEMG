# Extend current module_ref and reuse the existing acknowledged GPIO pattern.
set root [file normalize [file join [file dirname [info script]] ../..]]
source [file join $root build update_project.tcl]
open_project [file join $root build/vivado/hand_motion_reconstruction.xpr]
open_bd_design [get_files design_1.bd]
set name emg_pl_export_0
if {![llength [get_bd_pins -quiet $name/hand_command]]} {
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
    # Vivado 2025.2 can retain an obsolete module interface in its mref cache.
    # Reindex the real source and discard only this generated cache directory.
    set rtl [file join $root src rtl emg_pl_control.v]
    remove_files [get_files $rtl]
    add_files -norecurse -fileset sources_1 $rtl
    update_compile_order -fileset sources_1
    set cache [file normalize [file join $root build vivado hand_motion_reconstruction.gen sources_1 bd mref emg_pl_control]]
    if {[string first "$root/build/vivado/" $cache]!=0} {error "Unexpected generated cache path $cache"}
    if {[file exists $cache]} {file delete -force $cache}
    foreach ip [get_ips -quiet *emg_pl_export*] {
        puts "HAND_REFRESH upgrade $ip"
        upgrade_ip $ip
    }
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
if {![llength [get_bd_pins -quiet $name/hand_command]]} {error "Stale hand module interface after reindex"}
proc hand_connect {a b} {
    set na [get_bd_nets -quiet -of_objects $a]
    set nb [get_bd_nets -quiet -of_objects $b]
    if {[llength $na] && $na eq $nb} {return}
    if {[llength $na] && [llength $nb]} {error "Conflicting hand nets: $a $b"}
    connect_bd_net $a $b
}
if {![llength [get_bd_cells -quiet axi_gpio_5]]} {
    create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_5
}
# Same IP/version as existing control mailbox. Verify component.xml and readbacks.
set_property -dict {CONFIG.C_GPIO_WIDTH 32 CONFIG.C_ALL_OUTPUTS 1 CONFIG.C_DOUT_DEFAULT 0x00000000 CONFIG.C_IS_DUAL 1 CONFIG.C_GPIO2_WIDTH 32 CONFIG.C_ALL_INPUTS_2 1} [get_bd_cells axi_gpio_5]
hand_connect [get_bd_pins axi_gpio_5/gpio_io_o] [get_bd_pins emg_pl_export_0/hand_command]
hand_connect [get_bd_pins emg_pl_export_0/hand_status] [get_bd_pins axi_gpio_5/gpio2_io_i]
hand_connect [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins axi_gpio_5/s_axi_aclk]
hand_connect [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_gpio_5/s_axi_aresetn]
if {![llength [get_bd_intf_nets -quiet -of_objects [get_bd_intf_pins axi_gpio_5/S_AXI]]]} {
    set slot -1
    for {set i 0} {$i<16} {incr i} {
        set pin [get_bd_intf_pins -quiet smartconnect_0/M[format %02d $i]_AXI]
        if {![llength $pin] || ![llength [get_bd_intf_nets -quiet -of_objects $pin]]} {set slot $i;break}
    }
    if {$slot<0} {error "No available GP0 slot"}
    set count [get_property CONFIG.NUM_MI [get_bd_cells smartconnect_0]]
    if {$slot >= $count} {set_property CONFIG.NUM_MI [expr {$slot+1}] [get_bd_cells smartconnect_0]}
    connect_bd_intf_net [get_bd_intf_pins smartconnect_0/M[format %02d $slot]_AXI] [get_bd_intf_pins axi_gpio_5/S_AXI]
}
assign_bd_address -offset 0x41250000 -range 0x10000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_gpio_5/S_AXI/Reg]
if {![llength [get_bd_ports -quiet hand_pwm]]} {create_bd_port -dir O -from 5 -to 0 hand_pwm}
hand_connect [get_bd_pins emg_pl_export_0/hand_pwm] [get_bd_ports hand_pwm]
validate_bd_design -force
foreach {key expected} {C_GPIO_WIDTH 32 C_ALL_OUTPUTS 1 C_IS_DUAL 1 C_GPIO2_WIDTH 32 C_ALL_INPUTS_2 1} {
    set value [get_property CONFIG.$key [get_bd_cells axi_gpio_5]]
    if {$value!=$expected} {error "Hand GPIO mismatch $key=$value"}
    puts "HAND_GPIO_READBACK $key=$value"
}
foreach {name dir left} {axi_gpio_5/gpio_io_o O 31 axi_gpio_5/gpio2_io_i I 31 emg_pl_export_0/hand_command I 31 emg_pl_export_0/hand_status O 31 emg_pl_export_0/hand_pwm O 5} {
    set p [get_bd_pins $name]
    if {[get_property DIR $p] ne $dir || [get_property LEFT $p]!=$left || [get_property RIGHT $p]!=0} {error "Hand port mismatch $name"}
}
save_bd_design
puts "HAND_CONTROL_PASS command=0x41250000 status=0x41250008 PWM=J4-5..10"
close_project
