# Add the RGB LCD display path to design_1 (vh-2):
#   axi_vdma_0    MM2S only, 24-bit RGB888 stream, 3 frame stores, 64-bit AXI
#   v_tc_0        1024x600@50MHz DE-mode timing baked in, AXI-Lite ctrl
#   v_axi4s_vid_out_0  AXIS -> video (RGB888, async 100M/50M clocks)
#   axi_gpio_0    backlight enable (1 output)
#   proc_sys_reset_1    reset synchronizer for the 50 MHz pixel domain
#   lcd_clk_fwd_0 module_ref ODDR clock forwarder (src/rtl/lcd_clk_fwd.v)
#
# Wiring (validated in the lcd_dryrun temp project, Vivado 2025.2):
#   GP0 -> smartconnect_0 M01/M02/M03 -> vdma/vtc/gpio registers
#   vdma M_AXI_MM2S -> smartconnect_1 S01 (spare slot) -> HP0
#   vdma M_AXIS_MM2S -> vid_out video_in; vtc vtiming_out -> vid_out vtiming_in
#   FCLK_CLK0 (100M) clocks all AXI; FCLK_CLK1 (50M) clocks the video domain
#
# IMPORTANT: run OUTSIDE the TRAE sandbox (plain shell or Vivado GUI Tcl
# console) - module_ref resolution needs boost_interprocess IPC under
# C:\ProgramData which the sandbox blocks:
#   vivado -mode batch -source build/scripts/add_lcd_vdma.tcl
# Constraints land in board/constraints/hz_zynq_lcd.xdc (added to constrs_1).

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

# Idempotency: refuse to run twice.
if {[llength [get_bd_cells -quiet axi_vdma_0]]} {
    error "axi_vdma_0 already exists - the LCD display path looks added already"
}

# Sanity: the two smartconnects must be in the expected shape.
if {[llength [get_bd_intf_pins -quiet smartconnect_0/M01_AXI]]} {
    error "smartconnect_0 already has M01_AXI - unexpected topology, refusing to guess"
}
if {[llength [get_bd_intf_pins -quiet smartconnect_1/S01_AXI]] == 0} {
    # Expected the spare S01 slot; create it if this design was rebuilt without it.
    set sc1 [get_bd_cells smartconnect_1]
    set_property CONFIG.NUM_SI [expr {[get_property CONFIG.NUM_SI $sc1] + 1}] $sc1
}

proc latest_vlnv {names} {
    foreach n $names {
        set defs [lsort -dictionary [get_ipdefs xilinx.com:ip:$n:*]]
        if {[llength $defs] > 0} { return [lindex $defs end] }
    }
    error "no ipdef found for any of $names"
}
set v_rst  [latest_vlnv {proc_sys_reset}]
set v_vdma [latest_vlnv {axi_vdma}]
set v_vtc  [latest_vlnv {v_tc}]
set v_vo   [latest_vlnv {axi4stream_vid_out v_axi4s_vid_out}]
set v_gpio [latest_vlnv {axi_gpio}]

set ps7 [get_bd_cells processing_system7_0]

# ---- PS7: enable FCLK1 (50 MHz pixel clock) and its reset port.
set_property -dict [list \
    CONFIG.PCW_EN_CLK1_PORT {1} \
    CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {50} \
    CONFIG.PCW_EN_RST1_PORT {1}] $ps7

# ---- RTL: ODDR clock forwarder as a module_ref cell.
add_files -norecurse [file join $project_root src rtl lcd_clk_fwd.v]
update_compile_order -fileset sources_1

# ---- Create cells.
set rst50 [create_bd_cell -type ip -vlnv $v_rst proc_sys_reset_1]
set vdma  [create_bd_cell -type ip -vlnv $v_vdma axi_vdma_0]
set vtc   [create_bd_cell -type ip -vlnv $v_vtc v_tc_0]
set vo    [create_bd_cell -type ip -vlnv $v_vo v_axi4s_vid_out_0]
set gpio  [create_bd_cell -type ip -vlnv $v_gpio axi_gpio_0]

# VDMA: read channel only, 3 frame stores, 24-bit stream, 64-bit AXI read.
set_property -dict [list \
    CONFIG.c_include_mm2s {1} \
    CONFIG.c_include_s2mm {0} \
    CONFIG.c_num_fstores {3} \
    CONFIG.c_m_axis_mm2s_tdata_width {24} \
    CONFIG.c_m_axi_mm2s_data_width {64}] $vdma

# VTC: generation only, 1024x600 DE-mode timing baked into the IP.
# VIDEO_MODE must be "Custom" or the GEN_* parameters are disabled and
# silently ignored (BD 41-721) - dry-run v4 lesson.
#   th: 1024 active + 130 HFP + 30 HPW + 160 HBP = 1344
#   tv:  600 active +   2 VFP + 10 VPW +  23 VBP =  635
set_property -dict [list \
    CONFIG.enable_generation {true} \
    CONFIG.enable_detection {false} \
    CONFIG.VIDEO_MODE {Custom} \
    CONFIG.GEN_HACTIVE_SIZE {1024} \
    CONFIG.GEN_HSYNC_START {1154} \
    CONFIG.GEN_HSYNC_END {1184} \
    CONFIG.GEN_HFRAME_SIZE {1344} \
    CONFIG.GEN_VACTIVE_SIZE {600} \
    CONFIG.GEN_F0_VSYNC_VSTART {602} \
    CONFIG.GEN_F0_VSYNC_VEND {612} \
    CONFIG.GEN_F0_VFRAME_SIZE {635} \
    CONFIG.GEN_HSYNC_POLARITY {Low} \
    CONFIG.GEN_VSYNC_POLARITY {Low} \
    CONFIG.GEN_AVIDEO_POLARITY {High}] $vtc

# Video out: RGB888 + asynchronous AXI/video clocks.
# v_axi4s_vid_out 4.0 format encoding (component.xml): 0=YUV422 1=YUV444
# 2=RGB 3=YUV420 ... - "2" is RGB, "3" is NOT RGB (dry-run v4 lesson).
set_property -dict [list \
    CONFIG.C_S_AXIS_VIDEO_FORMAT {2} \
    CONFIG.C_HAS_ASYNC_CLK {1}] $vo

# GPIO: backlight, single push-pull output.
set_property -dict [list \
    CONFIG.C_GPIO_WIDTH {1} \
    CONFIG.C_ALL_OUTPUTS {1}] $gpio

# ODDR forwarder (needs the module indexed before the cell is created).
update_compile_order -fileset sources_1
set clkw [create_bd_cell -type module -reference lcd_clk_fwd lcd_clk_fwd_0]

# ---- Clocks (100M AXI domain rides the existing FCLK_CLK0 net).
connect_bd_net [get_bd_pins $ps7/FCLK_CLK0] \
    [get_bd_pins $vdma/s_axi_lite_aclk] [get_bd_pins $vdma/m_axi_mm2s_aclk] \
    [get_bd_pins $vdma/m_axis_mm2s_aclk] [get_bd_pins $vo/aclk] \
    [get_bd_pins $gpio/s_axi_aclk] [get_bd_pins $vtc/s_axi_aclk]
connect_bd_net [get_bd_pins $ps7/FCLK_CLK1] \
    [get_bd_pins $rst50/slowest_sync_clk] [get_bd_pins $vtc/clk] \
    [get_bd_pins $vo/vid_io_out_clk] [get_bd_pins $clkw/clk_in]

# ---- Resets. proc_sys_reset polarity auto-adapts to the active-low
# FCLK_RESETx_N driver (C_EXT_RESET_HIGH is propagate-only).
connect_bd_net [get_bd_pins $ps7/FCLK_RESET1_N] [get_bd_pins $rst50/ext_reset_in]
connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] \
    [get_bd_pins $vdma/axi_resetn] [get_bd_pins $vo/aresetn] \
    [get_bd_pins $gpio/s_axi_aresetn] [get_bd_pins $vtc/s_axi_aresetn]
connect_bd_net [get_bd_pins $rst50/peripheral_aresetn] [get_bd_pins $vtc/resetn]
connect_bd_net [get_bd_pins $rst50/peripheral_reset] [get_bd_pins $vo/vid_io_out_reset]

# ---- AXI: three more GP0 masters (M00 stays axi_dma_0).
set sc0 [get_bd_cells smartconnect_0]
set_property CONFIG.NUM_MI [expr {[get_property CONFIG.NUM_MI $sc0] + 3}] $sc0
connect_bd_intf_net [get_bd_intf_pins $sc0/M01_AXI] [get_bd_intf_pins $vdma/S_AXI_LITE]
connect_bd_intf_net [get_bd_intf_pins $sc0/M02_AXI] [get_bd_intf_pins $vtc/ctrl]
connect_bd_intf_net [get_bd_intf_pins $sc0/M03_AXI] [get_bd_intf_pins $gpio/S_AXI]

# ---- AXI: VDMA read master -> HP0 through the spare smartconnect_1 S01.
connect_bd_intf_net [get_bd_intf_pins $vdma/M_AXI_MM2S] [get_bd_intf_pins smartconnect_1/S01_AXI]

# ---- Video pipe.
connect_bd_intf_net [get_bd_intf_pins $vdma/M_AXIS_MM2S] [get_bd_intf_pins $vo/video_in]
connect_bd_intf_net [get_bd_intf_pins $vtc/vtiming_out] [get_bd_intf_pins $vo/vtiming_in]

# ---- LCD pins as individual BD ports (NOT the vid_io_out interface:
#      that would also externalize lcd_field/hblank/vblank which have no
#      package pins). BD auto-ties vtc/clken, vo/aclken etc. to constants.
create_bd_port -dir O -from 23 -to 0 lcd_data
connect_bd_net [get_bd_ports lcd_data] [get_bd_pins $vo/vid_data]
create_bd_port -dir O lcd_de
connect_bd_net [get_bd_ports lcd_de] [get_bd_pins $vo/vid_active_video]
create_bd_port -dir O lcd_hsync
connect_bd_net [get_bd_ports lcd_hsync] [get_bd_pins $vo/vid_hsync]
create_bd_port -dir O lcd_vsync
connect_bd_net [get_bd_ports lcd_vsync] [get_bd_pins $vo/vid_vsync]
create_bd_port -dir O lcd_bl
connect_bd_net [get_bd_ports lcd_bl] [get_bd_pins $gpio/gpio_io_o]
create_bd_port -dir O lcd_clk
connect_bd_net [get_bd_ports lcd_clk] [get_bd_pins $clkw/clk_out]

# ---- Addresses: auto-assign (offsets are read-only afterwards).
# Dry run gave vdma 0x43000000 / vtc 0x43C00000 / gpio 0x41200000;
# the printed table below is the authoritative map for main.c.
assign_bd_address

validate_bd_design
save_bd_design

# ---- Constraints.
add_files -fileset constrs_1 -norecurse [file join $project_root board constraints hz_zynq_lcd.xdc]

# ---- Regenerate the wrapper so the new lcd_* ports reach the top level.
make_wrapper -files [get_files design_1.bd] -top -force
update_compile_order -fileset sources_1

puts "================ LCD DISPLAY PATH ADDRESS MAP (for vh-3 main.c) ================"
foreach seg [get_bd_addr_segs -quiet] {
    puts [format "ADDRSEG %-60s offset=%s range=%s" \
        $seg [get_property offset $seg] [get_property range $seg]]
}
puts "=============================================================================="
puts "add_lcd_vdma: display path added. Next: re-run synthesis + implementation."
if {$owned} {
    close_project
}

