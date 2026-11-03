# New attitude mailbox, same 100 MHz GP0 architecture as control / learning.
# The installed axi_gpio v2.0 component.xml documents C_IS_DUAL, channel widths
# and ALL_OUTPUTS / ALL_INPUTS_2. Requirements: ch1 command out, ch2 ack/data in,
# both 32 bits, default command=0, existing PS/pin/clock configuration retained.
set root [file normalize [file join [file dirname [info script]] ../..]]
source [file join $root build update_project.tcl]
open_project [file join $root build/vivado/hand_motion_reconstruction.xpr]
open_bd_design [get_files design_1.bd]
source -notrace {<user-path>
set ::ipcfg::native_log_path [file join $root report/imu_pl_20261028/add_pl_imu.log]
puts [ipcfg::python_status]
puts [ipcfg::python_exec -c {import argparse,base64,hashlib,json,pathlib,re,sys,typing;print("PYTHON_IMPORTS:OK")}]
set ledger {}
proc imu_cfg {cell d} {
    global ledger
    set intent {}
    foreach {k v} $d {lappend intent $k $v [get_property $k [get_bd_cells $cell]]}
    puts [ipcfg::apply_dict $cell $d]
    set stuck [ipcfg::verify_stuck $cell $d]
    set bad [ipcfg::verify_intent $cell $intent 0]
    if {[llength $stuck] || [llength $bad]} {error "IMU config mismatch $cell $stuck $bad"}
    dict set ledger $cell [dict create requested $d stuck $stuck intent $bad]
}
proc imu_wire {a b} {
    set na [get_bd_nets -quiet -of_objects [get_bd_pins $a]]
    set nb [get_bd_nets -quiet -of_objects [get_bd_pins $b]]
    if {[llength $na] && $na eq $nb} {return}
    if {[llength $na] && [llength $nb]} {error "IMU net conflict $a $b"}
    connect_bd_net [get_bd_pins $a] [get_bd_pins $b]
}
if {![llength [get_bd_cells -quiet mpu_attitude_0]]} {
    create_bd_cell -type module -reference mpu_attitude mpu_attitude_0
}
set gpio_cfg {CONFIG.C_GPIO_WIDTH 32 CONFIG.C_ALL_OUTPUTS 1 CONFIG.C_DOUT_DEFAULT 0x00000000 CONFIG.C_IS_DUAL 1 CONFIG.C_GPIO2_WIDTH 32 CONFIG.C_ALL_INPUTS_2 1}
if {![llength [get_bd_cells -quiet axi_gpio_7]]} {
    puts [ipcfg::create_cell_cfg xilinx.com:ip:axi_gpio:2.0 axi_gpio_7 $gpio_cfg]
}
imu_cfg axi_gpio_7 $gpio_cfg
if {[get_property CONFIG.NUM_MI [get_bd_cells smartconnect_0]]<10} {imu_cfg smartconnect_0 {CONFIG.NUM_MI 10}}
if {![llength [get_bd_intf_nets -quiet -of_objects [get_bd_intf_pins axi_gpio_7/S_AXI]]]} {
    connect_bd_intf_net [get_bd_intf_pins smartconnect_0/M09_AXI] [get_bd_intf_pins axi_gpio_7/S_AXI]
}
foreach p {axi_gpio_7/s_axi_aclk mpu_attitude_0/clk} {imu_wire processing_system7_0/FCLK_CLK0 $p}
foreach p {axi_gpio_7/s_axi_aresetn mpu_attitude_0/rst_n} {imu_wire proc_sys_reset_0/peripheral_aresetn $p}
foreach p {mpu_data motion_a motion_b motion_c} {imu_wire mpu6050_tilt_0/$p mpu_attitude_0/$p}
imu_wire axi_gpio_7/gpio_io_o mpu_attitude_0/command
imu_wire mpu_attitude_0/response axi_gpio_7/gpio2_io_i
assign_bd_address -offset 0x41270000 -range 0x10000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_gpio_7/S_AXI/Reg]
validate_bd_design -force
foreach {p direction} {mpu_attitude_0/command I mpu_attitude_0/response O axi_gpio_7/gpio_io_o O axi_gpio_7/gpio2_io_i I} {
    set pin [get_bd_pins $p]
    if {[get_property DIR $pin] ne $direction || [get_property LEFT $pin]!=31 || [get_property RIGHT $pin]!=0} {error "IMU interface mismatch $p"}
}
foreach {k v} $gpio_cfg {
    if {[get_property $k [get_bd_cells axi_gpio_7]] != $v} {error "IMU readback mismatch $k"}
}
save_bd_design
puts [ipcfg::write_evidence [file join $root report/imu_pl_20261028/ip_config.[clock seconds].tcldict] $ledger]
puts "TEST_PASS PL_IMU_BD mailbox=0x41270000 width=32 clock=100MHz ABI=0x17494d55 coverage=FULL"
close_project

