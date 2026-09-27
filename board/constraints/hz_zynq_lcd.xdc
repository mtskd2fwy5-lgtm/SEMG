# HZ-ZYNQ_MV01 / HZ-ZYNQ_CV01 RGB LCD constraints (ATK 7" 1024x600, DE mode)
#
# Display path (created by build/scripts/add_lcd_vdma.tcl):
#   DDR -> axi_vdma_0 (MM2S, RGB888 24-bit) -> v_axi4s_vid_out_0
#   v_tc_0 supplies 1024x600@50 MHz timing (FCLK_CLK1 pixel clock)
#   lcd_clk_fwd_0 (ODDR) forwards the inverted pixel clock as LCD DCLK
#   axi_gpio_0 drives the backlight enable
#
# Wrapper port names have NO _0 suffix: these ports were created with
# create_bd_port (unlike the emg_pl_export_0 pins which got auto _0 names).
# Ball numbers verified against the Vivado package file query of banks
# 34/35 (bank34_35_pins.txt) plus the carrier schematic cross-check.

###################### electrical ######################

# RGB888 mapping: lcd_data[23:16]=R, [15:8]=G, [7:0]=B.
# v_axi4s_vid_out vid_data[23:16]=R; DDR bytes are B,G,R (little-endian
# 24-bit VDMA stream), so main.c writes pixel = (R<<16)|(G<<8)|B directly.
# R0..R7 -> lcd_data[16..23]
set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS33 DRIVE 8 SLEW FAST} [get_ports {lcd_data[16]}] ;# LCD_R0 B34
set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS33 DRIVE 8 SLEW FAST} [get_ports {lcd_data[17]}] ;# LCD_R1 B34
set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS33 DRIVE 8 SLEW FAST} [get_ports {lcd_data[18]}] ;# LCD_R2 B34
set_property -dict {PACKAGE_PIN T15 IOSTANDARD LVCMOS33 DRIVE 8 SLEW FAST} [get_ports {lcd_data[19]}] ;# LCD_R3 B34
set_property -dict {PACKAGE_PIN Y17 IOSTANDARD LVCMOS33 DRIVE 8 SLEW FAST} [get_ports {lcd_data[20]}] ;# LCD_R4 B34
set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS33 DRIVE 8 SLEW FAST} [get_ports {lcd_data[21]}] ;# LCD_R5 B34
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS33 DRIVE 8 SLEW FAST} [get_ports {lcd_data[22]}] ;# LCD_R6 B34
set_property -dict {PACKAGE_PIN U17 IOSTANDARD LVCMOS33 DRIVE 8 SLEW FAST} [get_ports {lcd_data[23]}] ;# LCD_R7 B34
# G0..G7 -> lcd_data[8..15]
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33 DRIVE 8 SLEW FAST} [get_ports {lcd_data[8]}]  ;# LCD_G0 B34
set_property -dict {PACKAGE_PIN V18 IOSTANDARD LVCMOS33 DRIVE 8 SLEW FAST} [get_ports {lcd_data[9]}]  ;# LCD_G1 B34
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS33 DRIVE 8 SLEW FAST} [get_ports {lcd_data[10]}] ;# LCD_G2 B34
set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS33 DRIVE 8 SLEW FAST} [get_ports {lcd_data[11]}] ;# LCD_G3 B34
set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS33 DRIVE 8 SLEW FAST} [get_ports {lcd_data[12]}] ;# LCD_G4 B34
set_property -dict {PACKAGE_PIN Y19 IOSTANDARD LVCMOS33 DRIVE 8 SLEW FAST} [get_ports {lcd_data[13]}] ;# LCD_G5 B34
set_property -dict {PACKAGE_PIN P15 IOSTANDARD LVCMOS33 DRIVE 8 SLEW FAST} [get_ports {lcd_data[14]}] ;# LCD_G6 B34
set_property -dict {PACKAGE_PIN P16 IOSTANDARD LVCMOS33 DRIVE 8 SLEW FAST} [get_ports {lcd_data[15]}] ;# LCD_G7 B34
# B0..B7 -> lcd_data[0..7]
set_property -dict {PACKAGE_PIN W18 IOSTANDARD LVCMOS33 DRIVE 8 SLEW FAST} [get_ports {lcd_data[0]}]  ;# LCD_B0 B34
set_property -dict {PACKAGE_PIN W19 IOSTANDARD LVCMOS33 DRIVE 8 SLEW FAST} [get_ports {lcd_data[1]}]  ;# LCD_B1 B34
set_property -dict {PACKAGE_PIN R16 IOSTANDARD LVCMOS33 DRIVE 8 SLEW FAST} [get_ports {lcd_data[2]}]  ;# LCD_B2 B34
set_property -dict {PACKAGE_PIN R17 IOSTANDARD LVCMOS33 DRIVE 8 SLEW FAST} [get_ports {lcd_data[3]}]  ;# LCD_B3 B34
set_property -dict {PACKAGE_PIN W20 IOSTANDARD LVCMOS33 DRIVE 8 SLEW FAST} [get_ports {lcd_data[4]}]  ;# LCD_B4 B34
set_property -dict {PACKAGE_PIN V20 IOSTANDARD LVCMOS33 DRIVE 8 SLEW FAST} [get_ports {lcd_data[5]}]  ;# LCD_B5 B34
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS33 DRIVE 8 SLEW FAST} [get_ports {lcd_data[6]}]  ;# LCD_B6 B34
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS33 DRIVE 8 SLEW FAST} [get_ports {lcd_data[7]}]  ;# LCD_B7 B34

set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS33 DRIVE 8 SLEW FAST} [get_ports {lcd_hsync}] ;# LCD_HSYNC B34
set_property -dict {PACKAGE_PIN T20 IOSTANDARD LVCMOS33 DRIVE 8 SLEW FAST} [get_ports {lcd_vsync}] ;# LCD_VSYNC B34
set_property -dict {PACKAGE_PIN U20 IOSTANDARD LVCMOS33 DRIVE 8 SLEW FAST} [get_ports {lcd_de}]     ;# LCD_DE   B34
set_property -dict {PACKAGE_PIN P19 IOSTANDARD LVCMOS33 DRIVE 8 SLEW FAST} [get_ports {lcd_clk}]    ;# LCD_DCLK B34
# Backlight enable (GPIO, quasi-static): B35, slow slew is plenty.
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {lcd_bl}]     ;# LCD_BL   B35

###################### timing ######################

# PS7 FCLKs are auto-constrained by the PS7 IP (verified in
# design_1_routed.dcp: FCLK_CLK0 appears as auto clock "clk_fpga_0"),
# so no create_clock is needed for the 50 MHz FCLK_CLK1 pixel clock.
#
# lcd_clk_fwd_0 uses ODDR D1=0/D2=1 => Q = ~C: the LCD DCLK rising edge
# coincides with the FCLK_CLK1 falling edge, giving vid_data a half
# period (10 ns) to reach the pins (UG471 clock forwarding).
create_generated_clock -name lcd_pclk -divide_by 1 -invert \
    -source [get_pins -hier -filter {NAME =~ *oddr_lcd_dclk/C}] \
    [get_ports {lcd_clk}]

# The ATK panel spec has no per-pixel tsu/th numbers (bare DE panel);
# assume 5 ns setup / 5 ns hold against the 10 ns half period.
set_output_delay -clock lcd_pclk -max 5.0 [get_ports {lcd_data[*] lcd_de lcd_hsync lcd_vsync}]
set_output_delay -clock lcd_pclk -min -5.0 [get_ports {lcd_data[*] lcd_de lcd_hsync lcd_vsync}]

# Backlight is a quasi-static GPIO toggled from the 100 MHz domain.
set_false_path -to [get_ports {lcd_bl}]
