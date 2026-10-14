# Add the MPU6050 (GY-521) forearm-tilt path to design_1 (mpu-4):
#   mpu6050_tilt_0  module_ref cell (src/rtl/mpu6050_tilt.v)
#     - autonomous wake config + 100 Hz 14-byte burst reads + CORDIC
#       complementary filter (200 kHz dedicated I2C, addr 0x68/0x69)
#     - emits one 32-bit word: {valid, seq[6:0], pitch s12, roll s12}
#       (pitch/roll in 0.1 deg units)
#   axi_gpio_2     single-channel 32-bit all-input GPIO carrying that word;
#     - S_AXI hangs off the first free smartconnect_0 master slot
#
# Pins: mpu_scl T10 / mpu_sda_io T11 (carrier J11 OLED&CAMERA header,
# CMOS_SCL/CMOS_SDA nets, see hz_zynq_lcd.xdc mpu6050 section).
#
# IMPORTANT: run OUTSIDE the TRAE sandbox (module_ref resolution needs
# boost_interprocess IPC under C:\ProgramData which the sandbox blocks):
#   vivado -mode batch -source build/scripts/add_mpu6050.tcl
# The printed axi_gpio_2 address is the authoritative offset for main.c.

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

# Recover from a partial earlier run: remove leftovers before re-adding.
set c [get_bd_cells -quiet mpu6050_tilt_0]
if {[llength $c]} {
    foreach n [get_bd_nets -quiet -of_objects [get_bd_pins -quiet $c]] {
        delete_bd_objs $n
    }
    delete_bd_objs $c
}
foreach pn {mpu_scl mpu_sda_io} {
    set pt [get_bd_ports -quiet $pn]
    if {[llength $pt]} { delete_bd_objs $pt }
}
set g2 [get_bd_cells -quiet axi_gpio_2]
if {[llength $g2]} {
    set in [get_bd_intf_pins -quiet $g2/S_AXI]
    if {[llength $in]} {
        foreach n [get_bd_intf_nets -quiet -of_objects $in] { delete_bd_objs $n }
    }
    foreach n [get_bd_nets -quiet -of_objects [get_bd_pins -quiet $g2]] {
        delete_bd_objs $n
    }
    delete_bd_objs $g2
}

proc latest_vlnv {names} {
    foreach n $names {
        set defs [lsort -dictionary [get_ipdefs xilinx.com:ip:$n:*]]
        if {[llength $defs] > 0} { return [lindex $defs end] }
    }
    error "no ipdef found for any of $names"
}
set v_gpio [latest_vlnv {axi_gpio}]

# ---- RTL: MPU6050 front end as a module_ref cell.
if {[llength [get_files -quiet */mpu6050_tilt.v]] == 0} {
    add_files -norecurse [file join $project_root src rtl mpu6050_tilt.v]
}
update_compile_order -fileset sources_1
set mpu [create_bd_cell -type module -reference mpu6050_tilt mpu6050_tilt_0]
update_compile_order -fileset sources_1

# ---- Clock / reset: 50 MHz FCLK_CLK1 domain (fixed, panel-independent),
# same as the touch path.  Pin-to-pin connect: get_bd_nets -of_objects
# proved unreliable on the auto-generated FCLK/reset nets in 2025.2
# (returned empty, BD 41-701).
connect_bd_net [get_bd_pins $mpu/clk] \
    [get_bd_pins processing_system7_0/FCLK_CLK1]
connect_bd_net [get_bd_pins $mpu/rst_in] \
    [get_bd_pins proc_sys_reset_1/peripheral_reset]

# ---- MPU pins as BD ports (names must match hz_zynq_lcd.xdc).
create_bd_port -dir O mpu_scl
connect_bd_net [get_bd_ports mpu_scl] [get_bd_pins $mpu/mpu_scl]
create_bd_port -dir IO mpu_sda_io
connect_bd_net [get_bd_ports mpu_sda_io] [get_bd_pins $mpu/mpu_sda_io]

# ---- axi_gpio_2: 32-bit single-channel all-input, carries the tilt word.
set gpio2 [create_bd_cell -type ip -vlnv $v_gpio axi_gpio_2]
set_property -dict [list \
    CONFIG.C_GPIO_WIDTH {32} \
    CONFIG.C_ALL_INPUTS {1} \
    CONFIG.C_IS_DUAL {0}] $gpio2
connect_bd_net [get_bd_pins $gpio2/s_axi_aclk] \
    [get_bd_pins processing_system7_0/FCLK_CLK0]
connect_bd_net [get_bd_pins $gpio2/s_axi_aresetn] \
    [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
connect_bd_net [get_bd_pins $gpio2/gpio_io_i] [get_bd_pins $mpu/mpu_data]

# ---- AXI: one more GP0 master on the first free smartconnect_0 slot.
set sc0 [get_bd_cells smartconnect_0]
set slot -1
for {set i 0} {$i < 16} {incr i} {
    set p [get_bd_intf_pins -quiet smartconnect_0/M[format %02d $i]_AXI]
    if {[llength $p] == 0} { set slot $i; break }
    if {[llength [get_bd_intf_nets -quiet -of_objects $p]] == 0} { set slot $i; break }
}
if {$slot < 0} { error "no free smartconnect_0 master slot" }
set need [expr {$slot + 1}]
if {[get_property CONFIG.NUM_MI $sc0] < $need} {
    set_property CONFIG.NUM_MI $need $sc0
}
connect_bd_intf_net [get_bd_intf_pins smartconnect_0/M[format %02d $slot]_AXI] \
    [get_bd_intf_pins $gpio2/S_AXI]

# ---- Addresses: auto-assign (offsets are read-only afterwards).
assign_bd_address

validate_bd_design
save_bd_design

# ---- Regenerate the wrapper so the new mpu_* ports reach the top level.
make_wrapper -files [get_files design_1.bd] -top -force
update_compile_order -fileset sources_1

puts "================ MPU6050 PATH ADDRESS MAP (for mpu-5 main.c) ================"
foreach seg [get_bd_addr_segs -quiet] {
    if {[string match *axi_gpio_2* $seg]} {
        puts [format "MPUGPIO %-61s offset=%s range=%s" \
            $seg [get_property offset $seg] [get_property range $seg]]
    }
}
foreach seg [get_bd_addr_segs -quiet] {
    puts [format "ADDRSEG %-60s offset=%s range=%s" \
        $seg [get_property offset $seg] [get_property range $seg]]
}
puts "=============================================================================="
puts "add_mpu6050: tilt path added. Next: full build via build_all.bat"
if {$owned} {
    close_project
}
