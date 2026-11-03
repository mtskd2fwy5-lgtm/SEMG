# Extend existing MPU/GPIO architecture with a coherent raw six-axis snapshot.
set root [file normalize [file join [file dirname [info script]] .. ..]]
open_project [file join $root build vivado hand_motion_reconstruction.xpr]
if {![llength [get_files -quiet *mpu6050_motion.v]]} {
    add_files -norecurse [file join $root src rtl mpu6050_motion.v]
}
foreach f [get_files -quiet -of_objects [get_filesets sources_1]] {
    if {[string equal -nocase [file dirname [file normalize $f]] [file join $root src rtl]] &&
        ([string match *.v $f] || [string match *.sv $f])} {
        set_property IS_ENABLED true $f
    }
}
update_compile_order -fileset sources_1
open_bd_design [get_files design_1.bd]
proc motion_connect {a b} {
    set na [get_bd_nets -quiet -of_objects $a]
    set nb [get_bd_nets -quiet -of_objects $b]
    if {[llength $na] && $na eq $nb} {return}
    if {[llength $na] && [llength $nb]} {error "Conflicting motion nets: $a $b"}
    connect_bd_net $a $b
}
if {![llength [get_bd_pins -quiet mpu6050_tilt_0/motion_a]]} {
    # Recreate only the module reference to discover its changed port list;
    # the existing protocol nets, external ports and original GPIO remain.
    delete_bd_objs [get_bd_cells mpu6050_tilt_0]
    create_bd_cell -type module -reference mpu6050_motion mpu6050_tilt_0
    motion_connect [get_bd_pins processing_system7_0/FCLK_CLK1] [get_bd_pins mpu6050_tilt_0/clk]
    motion_connect [get_bd_pins proc_sys_reset_1/peripheral_reset] [get_bd_pins mpu6050_tilt_0/rst_in]
    motion_connect [get_bd_ports mpu_scl] [get_bd_pins mpu6050_tilt_0/mpu_scl]
    motion_connect [get_bd_ports mpu_sda_io] [get_bd_pins mpu6050_tilt_0/mpu_sda_io]
    motion_connect [get_bd_pins axi_gpio_2/gpio_io_i] [get_bd_pins mpu6050_tilt_0/mpu_data]
}
set g2 [get_bd_cells axi_gpio_2]
set_property -dict {CONFIG.C_IS_DUAL 1 CONFIG.C_GPIO2_WIDTH 32 CONFIG.C_ALL_INPUTS_2 1} $g2
motion_connect [get_bd_pins mpu6050_tilt_0/motion_a] [get_bd_pins axi_gpio_2/gpio2_io_i]
if {![llength [get_bd_cells -quiet axi_gpio_3]]} {
    create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_3
}
set_property -dict {CONFIG.C_GPIO_WIDTH 32 CONFIG.C_GPIO2_WIDTH 32 CONFIG.C_ALL_INPUTS 1 CONFIG.C_ALL_INPUTS_2 1 CONFIG.C_IS_DUAL 1} [get_bd_cells axi_gpio_3]
motion_connect [get_bd_pins mpu6050_tilt_0/motion_b] [get_bd_pins axi_gpio_3/gpio_io_i]
motion_connect [get_bd_pins mpu6050_tilt_0/motion_c] [get_bd_pins axi_gpio_3/gpio2_io_i]
motion_connect [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins axi_gpio_3/s_axi_aclk]
motion_connect [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_gpio_3/s_axi_aresetn]
if {![llength [get_bd_intf_nets -quiet -of_objects [get_bd_intf_pins axi_gpio_3/S_AXI]]]} {
    set slot -1
    for {set i 0} {$i<16} {incr i} {
        set pin [get_bd_intf_pins -quiet smartconnect_0/M[format %02d $i]_AXI]
        if {![llength $pin] || ![llength [get_bd_intf_nets -quiet -of_objects $pin]]} {set slot $i;break}
    }
    if {$slot<0} {error "No available GP0 SmartConnect slot"}
    set count [get_property CONFIG.NUM_MI [get_bd_cells smartconnect_0]]
    if {$slot >= $count} {
        set_property CONFIG.NUM_MI [expr {$slot+1}] [get_bd_cells smartconnect_0]
    }
    connect_bd_intf_net [get_bd_intf_pins smartconnect_0/M[format %02d $slot]_AXI] [get_bd_intf_pins axi_gpio_3/S_AXI]
}
assign_bd_address -offset 0x41230000 -range 0x10000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_gpio_3/S_AXI/Reg]
validate_bd_design -force
foreach cell {axi_gpio_2 axi_gpio_3} {
    foreach {property expected} {C_IS_DUAL 1 C_GPIO2_WIDTH 32 C_ALL_INPUTS_2 1} {
        if {[get_property CONFIG.$property [get_bd_cells $cell]] != $expected} {
            error "GPIO config mismatch: $cell $property"
        }
    }
    puts "GPIO_READBACK $cell dual=[get_property CONFIG.C_IS_DUAL [get_bd_cells $cell]] width2=[get_property CONFIG.C_GPIO2_WIDTH [get_bd_cells $cell]] input2=[get_property CONFIG.C_ALL_INPUTS_2 [get_bd_cells $cell]]"
}
foreach pin {axi_gpio_2/gpio2_io_i axi_gpio_3/gpio_io_i axi_gpio_3/gpio2_io_i} {
    if {[get_property DIR [get_bd_pins $pin]] ne "I" ||
        [get_property LEFT [get_bd_pins $pin]] != 31 ||
        [get_property RIGHT [get_bd_pins $pin]] != 0} {
        error "GPIO input width/direction mismatch: $pin"
    }
    puts "PIN_READBACK $pin dir=[get_property DIR [get_bd_pins $pin]] left=[get_property LEFT [get_bd_pins $pin]]"
}
puts "SMARTCONNECT_READBACK masters=[get_property CONFIG.NUM_MI [get_bd_cells smartconnect_0]] gpio3=[get_bd_intf_nets -of_objects [get_bd_intf_pins axi_gpio_3/S_AXI]]"
save_bd_design
puts "MOTION GPIO: A=0x41220008 B=0x41230000 C=0x41230008"
close_project

