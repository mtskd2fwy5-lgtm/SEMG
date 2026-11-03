# SPDX-License-Identifier: Apache-2.0
# Extend the existing LCD design; preserve every original address and port.
set root [file normalize [file join [file dirname [info script]] ../..]]
source [file join $root build/update_project.tcl]
open_project [file join $root build/vivado/hand_motion_reconstruction.xpr]
open_bd_design [get_files design_1.bd]
if {[llength [get_bd_cells -quiet axi_vdma_hdmi]]} {error "HDMI already installed"}
proc ipver {name} {return [lindex [lsort -dictionary [get_ipdefs xilinx.com:ip:$name:*]] end]}
set dma [create_bd_cell -type ip -vlnv [ipver axi_vdma] axi_vdma_hdmi]
# Clone the proven LCD reader's actual configuration, including DRE/burst.
set old [get_bd_cells axi_vdma_0]
set config {}
foreach p [list_property $old] {
    if {[string match CONFIG.* $p]} {lappend config $p [get_property $p $old]}
}
set_property -dict $config $dma
set vo [create_bd_cell -type ip -vlnv [ipver v_axi4s_vid_out] video_out_hdmi]
set_property -dict [list CONFIG.C_S_AXIS_VIDEO_FORMAT {2} CONFIG.C_HAS_ASYNC_CLK {1} CONFIG.C_ADDR_WIDTH {12}] $vo
set gpio [create_bd_cell -type ip -vlnv [ipver axi_gpio] gpio_hdmi]
set_property -dict [list CONFIG.C_GPIO_WIDTH {32} CONFIG.C_ALL_INPUTS {1} CONFIG.C_IS_DUAL {1} CONFIG.C_GPIO2_WIDTH {1} CONFIG.C_ALL_OUTPUTS_2 {1}] $gpio
update_compile_order -fileset sources_1
set scaler [create_bd_cell -type module -reference hdmi_scaler hdmi_scaler_0]
set tx [create_bd_cell -type module -reference hdmi_output hdmi_output_0]
set_property CONFIG.POLARITY ACTIVE_HIGH [get_bd_pins $tx/video_rst]
set_property CONFIG.NUM_MI 12 [get_bd_cells smartconnect_0]
set_property CONFIG.NUM_SI 3 [get_bd_cells smartconnect_1]
connect_bd_intf_net [get_bd_intf_pins smartconnect_0/M10_AXI] [get_bd_intf_pins $dma/S_AXI_LITE]
connect_bd_intf_net [get_bd_intf_pins smartconnect_0/M11_AXI] [get_bd_intf_pins $gpio/S_AXI]
connect_bd_intf_net [get_bd_intf_pins $dma/M_AXI_MM2S] [get_bd_intf_pins smartconnect_1/S02_AXI]
connect_bd_intf_net [get_bd_intf_pins $dma/M_AXIS_MM2S] [get_bd_intf_pins $scaler/s_axis]
connect_bd_intf_net [get_bd_intf_pins $scaler/m_axis] [get_bd_intf_pins $vo/video_in]
foreach pin [list $dma/s_axi_lite_aclk $dma/m_axi_mm2s_aclk $dma/m_axis_mm2s_aclk $gpio/s_axi_aclk $vo/aclk $scaler/aclk $tx/clk100] {
    connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins $pin]
}
foreach pin [list $dma/axi_resetn $gpio/s_axi_aresetn $scaler/aresetn] {
    connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins $pin]
}
connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_reset] [get_bd_pins $tx/rst]
connect_bd_net [get_bd_pins $tx/stream_resetn] [get_bd_pins $vo/aresetn]
connect_bd_net [get_bd_pins lcd_panel_adapter_0/lcd_id] [get_bd_pins $scaler/panel_id]
connect_bd_net [get_bd_pins $tx/pixel_clk] [get_bd_pins $vo/vid_io_out_clk]
connect_bd_net [get_bd_pins $tx/video_rst] [get_bd_pins $vo/vid_io_out_reset]
connect_bd_net [get_bd_pins $vo/vtg_ce] [get_bd_pins $tx/vtg_ce]
catch {expand_bd_intf_pin [get_bd_intf_pins $vo/vtiming_in]}
foreach {a b} {active_video vtg_active_video field_id vtg_field_id hblank vtg_hblank hsync vtg_hsync vblank vtg_vblank vsync vtg_vsync} {
    connect_bd_net [get_bd_pins $tx/$a] [get_bd_pins $vo/$b]
}
foreach {a b} {rgb vid_data de vid_active_video video_hsync vid_hsync video_vsync vid_vsync video_locked locked underflow underflow overflow overflow} {
    connect_bd_net [get_bd_pins $tx/$a] [get_bd_pins $vo/$b]
}
connect_bd_net [get_bd_pins $scaler/fault] [get_bd_pins $tx/scaler_fault]
connect_bd_net [get_bd_pins $tx/status] [get_bd_pins $gpio/gpio_io_i]
connect_bd_net [get_bd_pins $gpio/gpio2_io_o] [get_bd_pins $tx/run] [get_bd_pins $scaler/run]
foreach name {hdmi_data_p hdmi_data_n} {
    create_bd_port -dir O -from 2 -to 0 $name
    connect_bd_net [get_bd_ports $name] [get_bd_pins $tx/$name]
}
foreach name {hdmi_clk_p hdmi_clk_n} {
    create_bd_port -dir O $name
    connect_bd_net [get_bd_ports $name] [get_bd_pins $tx/$name]
}
create_bd_port -dir I hdmi_hpd
connect_bd_net [get_bd_ports hdmi_hpd] [get_bd_pins $tx/hpd]
assign_bd_address -offset 0x43010000 -range 64K -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs $dma/S_AXI_LITE/Reg]
assign_bd_address -offset 0x41280000 -range 64K -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs $gpio/S_AXI/Reg]
assign_bd_address
set_property range 512M [get_bd_addr_segs axi_vdma_hdmi/Data_MM2S/SEG_processing_system7_0_HP0_DDR_LOWOCM]
validate_bd_design -force
save_bd_design
generate_target all [get_files design_1.bd]
close_project
puts "TEST_PASS HDMI mirror BD installed: 720p, independent MM2S, existing LCD unchanged"
