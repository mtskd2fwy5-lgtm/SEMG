# Reuse touch GPIO channel 2 for the ADC register-readback mailbox.
# Native Tcl fallback: this installation has no Vivado MCP connector.
# Parameter definitions/register offset were checked in the installed
# axi_gpio_v2_0/component.xml (GPIO2 enable, width, all-input, DATA offset 8).
set root [file normalize [file join [file dirname [info script]] .. ..]]
source [file join $root build update_project.tcl]
open_project [file join $root build vivado hand_motion_reconstruction.xpr]
puts "ADC_GPIO_PREFLIGHT part=[get_property PART [current_project]] simulator=[get_property TARGET_SIMULATOR [current_project]] top=[get_property TOP [get_filesets sources_1]]"
open_bd_design [get_files design_1.bd]
set name emg_pl_export_0
if {![llength [get_bd_pins -quiet $name/adc_config_status]]} {
    # Preserve every existing connection and parameter while refreshing the
    # module reference's port list, as in add_lcd_motion_gpio.tcl.
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
    create_bd_cell -type module -reference emg_pl_export_status $name
    if {[llength $params]} {set_property -dict $params [get_bd_cells $name]}
    dict for {pin net} $intf_nets {
        # Join the retained receiver explicitly; Vivado 2025.2 rejects the
        # one-endpoint -intf_net form with an empty BD 17-3926 diagnostic.
        connect_bd_intf_net [get_bd_intf_pins $name/$pin] [get_bd_intf_pins -of_objects [get_bd_intf_nets $net]]
    }
    dict for {pin net} $pin_nets {
        set port [get_bd_pins $name/$pin]
        if {![llength [get_bd_nets -quiet -of_objects $port]]} {
            connect_bd_net -net $net $port
        }
    }
    puts "ADC_MODULE_REFRESH restored_pins=[dict size $pin_nets] interfaces=[dict size $intf_nets]"
}
set gpio [get_bd_cells axi_gpio_1]
puts "ADC_GPIO_BEFORE dual=[get_property CONFIG.C_IS_DUAL $gpio] width1=[get_property CONFIG.C_GPIO_WIDTH $gpio] input1=[get_property CONFIG.C_ALL_INPUTS $gpio]"
set_property -dict {CONFIG.C_IS_DUAL 1 CONFIG.C_GPIO2_WIDTH 32 CONFIG.C_ALL_INPUTS_2 1} $gpio
set target [get_bd_pins axi_gpio_1/gpio2_io_i]
set source [get_bd_pins emg_pl_export_0/adc_config_status]
if {![llength [get_bd_nets -quiet -of_objects $target]]} {
    connect_bd_net $source $target
}
validate_bd_design -force
foreach {p expected} {C_IS_DUAL 1 C_GPIO2_WIDTH 32 C_ALL_INPUTS_2 1 C_GPIO_WIDTH 32 C_ALL_INPUTS 1} {
    set actual [get_property CONFIG.$p $gpio]
    if {$actual != $expected} {error "ADC_GPIO config mismatch $p=$actual expected=$expected"}
    puts "ADC_GPIO_READBACK $p=$actual"
}
if {[get_property DIR $target] ne "I" || [get_property LEFT $target] != 31 ||
    [get_property RIGHT $target] != 0 || [get_property DIR $source] ne "O" ||
    [get_property LEFT $source] != 31 || [get_property RIGHT $source] != 0 ||
    [get_bd_nets -of_objects $target] ne [get_bd_nets -of_objects $source]} {
    error "ADC_GPIO observed width/direction/connection mismatch"
}
if {[get_bd_nets -of_objects [get_bd_pins axi_gpio_1/gpio_io_i]] ne
    [get_bd_nets -of_objects [get_bd_pins touch_gt911_0/touch_data]]} {
    error "Touch channel 1 connection changed"
}
save_bd_design
puts "ADC_GPIO_CONFIG_PASS channel2=0x41210008 width=32 inputs=all; touch channel1 verified"
close_project
