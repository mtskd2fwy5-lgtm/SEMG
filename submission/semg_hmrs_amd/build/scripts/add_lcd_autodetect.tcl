# Convert the LCD display path to PL-side panel auto-detection
# (ATK 21_lcd_rgb_char scheme):
#   - delete v_tc_0 (timing generation moves into lcd_panel_adapter_0)
#   - add src/rtl/lcd_panel_adapter.v as module_ref lcd_panel_adapter_0:
#       * RGB pins tri-state while DE idle, panel ID (B7/G7/R7) sampled once
#       * MMCM 50M -> {50, 31.25} MHz + BUFGMUX selected by the panel id
#       * video_timing master outputs replace v_tc_0/vtiming_out
#       * qualified vid_io_out_reset for v_axi4s_vid_out_0
#   - lcd_data BD port O -> IO (tri-state at the top level)
#   - axi_gpio_0 becomes dual: ch1 BL output (unchanged), ch2 16-bit input
#     = latched panel id for the PS
#   - FCLK1 back to 50 MHz (MMCM base clock for both panels)
#
# After this script: full build (build\build_all.bat -SkipBoot), then the PS
# four-step flow (XSA changed: port direction, v_tc removed, gpio dual).
#
# IMPORTANT: run OUTSIDE the TRAE sandbox - module_ref resolution needs the
# project .cache / boost_interprocess IPC:
#   vivado -mode batch -source build/scripts/add_lcd_autodetect.tcl

set project_root [file normalize [file join [file dirname [info script]] .. ..]]
set owned 0
if {[llength [get_projects -quiet hand_motion_reconstruction]] == 0} {
    open_project [file join $project_root build vivado hand_motion_reconstruction.xpr]
    set owned 1
}
if {[llength [get_bd_designs -quiet design_1]] == 0} {
    open_bd_design [get_files design_1.bd]
}

# Clean slate: remove any partial state from an interrupted earlier run
# (upgrade_ip auto-saves the BD mid-surgery, so remnants are possible).
if {[llength [get_bd_cells -quiet lcd_panel_adapter_0]]} {
    delete_bd_objs [get_bd_cells lcd_panel_adapter_0]
}
if {[llength [get_bd_cells -quiet v_tc_0]]} {
    delete_bd_objs [get_bd_cells v_tc_0]
}
if {[llength [get_bd_ports -quiet lcd_data]]} {
    delete_bd_objs [get_bd_ports lcd_data]
}

# ---- RTL: adapter module (module_ref, like lcd_clk_fwd).
add_files -norecurse [file join $project_root src rtl lcd_panel_adapter.v]
update_compile_order -fileset sources_1

set vo    [get_bd_cells v_axi4s_vid_out_0]
set gpio  [get_bd_cells axi_gpio_0]
set ps7   [get_bd_cells processing_system7_0]

# ---- Remove v_tc_0 (its vtiming net goes with it; smartconnect M02 is left
# unconnected - harmless, reported as warning only).
delete_bd_objs [get_bd_cells v_tc_0]

# ---- Instantiate the adapter.
update_compile_order -fileset sources_1
set ad [create_bd_cell -type module -reference lcd_panel_adapter lcd_panel_adapter_0]
# Refresh the module_ref IP def if a stale one exists from an earlier scan.
set adip [get_ips -quiet design_1_lcd_panel_adapter_0_0]
if {[llength $adip]} {
    upgrade_ip $adip
}
puts "adapter pins: [get_bd_pins -of_objects $ad]"
puts "adapter intf pins: [get_bd_intf_pins -of_objects $ad]"

# Disconnect helper that tolerates already-unconnected pins.
proc disc_net {pin} {
    set n [get_bd_nets -quiet -of_objects [get_bd_pins $pin]]
    if {[llength $n]} { disconnect_bd_net $n [get_bd_pins $pin] }
}

# ---- lcd_data: BD port O -> IO, routed through the adapter tri-state.
delete_bd_objs [get_bd_ports lcd_data]
create_bd_port -dir IO -from 23 -to 0 lcd_data
connect_bd_net [get_bd_pins $vo/vid_data] [get_bd_pins $ad/rgb_o] \
    [get_bd_pins $ad/lcd_data_io] [get_bd_ports lcd_data]

# ---- DE: join the adapter into the existing lcd_de net.
connect_bd_net [get_bd_pins $vo/vid_active_video] [get_bd_pins $ad/de_o]

# ---- Reset: adapter input = FCLK1-domain peripheral reset; adapter output =
# pixel-domain-synchronized reset for vid_out.
disc_net $vo/vid_io_out_reset
connect_bd_net [get_bd_pins proc_sys_reset_1/peripheral_reset] [get_bd_pins $ad/rst_in]
connect_bd_net [get_bd_pins $ad/vid_rst_out] [get_bd_pins $vo/vid_io_out_reset]

# ---- Clocks: FCLK1 (50 MHz, fixed) becomes the adapter input; the muxed
# pixel clock feeds vid_out and the ODDR forwarder.
disc_net $vo/vid_io_out_clk
disc_net lcd_clk_fwd_0/clk_in
connect_bd_net [get_bd_pins $ad/lcd_pclk] \
    [get_bd_pins $vo/vid_io_out_clk] [get_bd_pins lcd_clk_fwd_0/clk_in]
connect_bd_net [get_bd_pins $ps7/FCLK_CLK1] [get_bd_pins $ad/clk50_in]

# ---- Timing: expand vid_out's vtiming_in interface pin and wire the
# adapter's six plain timing ports one by one.
set vtin [get_bd_intf_pins -quiet $vo/vtiming_in]
if {[llength $vtin]} {
    if {[catch {expand_bd_intf_pin $vtin} err]} {
        puts "NOTE: expand_bd_intf_pin: $err"
        puts "NOTE: falling back to direct sub-pin connection"
    }
}
foreach {mypin theirpin} {
    vtiming_out_active_video vtg_active_video
    vtiming_out_field        vtg_field_id
    vtiming_out_hblank       vtg_hblank
    vtiming_out_hsync        vtg_hsync
    vtiming_out_vblank       vtg_vblank
    vtiming_out_vsync        vtg_vsync
} {
    connect_bd_net [get_bd_pins $ad/$mypin] [get_bd_pins $vo/$theirpin]
}

# ---- GPIO: channel 2 = 16-bit input for the latched panel id.
set_property -dict [list \
    CONFIG.C_IS_DUAL      {1}  \
    CONFIG.C_GPIO2_WIDTH  {16} \
    CONFIG.C_ALL_INPUTS_2 {1}] $gpio
connect_bd_net [get_bd_pins $ad/lcd_id] [get_bd_pins $gpio/gpio2_io_i]

# ---- PS7: FCLK1 back to the 50 MHz base clock (MMCM derives both pixel
# clocks in the PL; the PS never switches it again).
set_property CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {50} $ps7

validate_bd_design
save_bd_design

# ---- Regenerate the wrapper (lcd_data direction changes to INOUT).
make_wrapper -files [get_files design_1.bd] -top -force
update_compile_order -fileset sources_1

puts "================ add_lcd_autodetect ================"
puts "PCW_FPGA1_PERIPHERAL_FREQMHZ    = [get_property CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ $ps7]"
puts "PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ = [get_property CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ $ps7]"
puts "gpio C_IS_DUAL = [get_property CONFIG.C_IS_DUAL $gpio]"
puts "Next: full build (build\\build_all.bat -SkipBoot), then the PS four-step"
puts "flow (export XSA -> re-read -> verify ps7_init.c -> rebuild FSBL+app)."
if {$owned} {
    close_project
}

