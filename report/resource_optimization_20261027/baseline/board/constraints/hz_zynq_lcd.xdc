# HZ-ZYNQ_MV01 / HZ-ZYNQ_CV01 RGB LCD constraints (ATK RGB module, DE mode)
#
# Panel auto-detection (ATK 21_lcd_rgb_char scheme): lcd_panel_adapter_0
# tri-states lcd_data while DE is idle and samples the panel ID bits
# (B7/G7/R7) once at boot; the pixel clock (MMCM 50M -> {50, 31.25} MHz +
# BUFGMUX) and the video timing are selected in the PL.  Both ATK-4384
# 4.3" 800x480 and ATK-7016 7" 1024x600 work from the same bitstream -
# no rebuild on panel swap.  FCLK_CLK1 stays at 50 MHz (MMCM base).
#
# Display path (created by build/scripts/add_lcd_vdma.tcl):
#   DDR -> axi_vdma_0 (MM2S, RGB888 24-bit) -> v_axi4s_vid_out_0
#   v_tc_0 supplies the panel timing (FCLK_CLK1 pixel clock)
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

# Clock-dependent LCD timing is in hz_zynq_lcd_timing.xdc (implementation only).

# Input direction of the bidirectional RGB pins: only the quasi-static
# panel ID levels (B7/G7/R7) are sampled, once at boot (~20 ms after
# reset).  No meaningful input timing to meet.  id_reg lives in the fixed
# c50 domain while the driving side may be c31 (4384), so also cut the
# paths at the sampler pins themselves.
set_false_path -to [get_pins -quiet {lcd_panel_adapter_0/inst/id_reg_reg[*]/D}]
set_false_path -from [get_ports {lcd_data[*]}]

# Backlight is a quasi-static GPIO toggled from the 100 MHz domain.
set_false_path -to [get_ports {lcd_bl}]

###################### touch (GT911, ATK capacitive) ######################

# Same J10 40P FPC as the RGB signals.  J10 pin numbers per the ATK module
# 40P table (user re-checked 2026-10-11 - an earlier draft was shifted up
# one row: T_CS is J10-35).  The ball mapping is keyed to the carrier NET
# names at J2, cross-validated against the working LCD pins, so it is
# unaffected by the J10 renumbering:
#   J10-35 T_CS     = CT_RST -> touch_rst    M19  (B35_L7P)
#   J10-36 IIC2_SDA = CT_SDA -> touch_sda_io P20  (B34_L14N, open drain)
#   J10-37 T_MISO              (unused on the capacitive module)
#   J10-38 IIC2_SCL = CT_SCL -> touch_scl    R19  (B34_IO0)
#   J10-39 T_PEN    = CT_INT -> touch_int_io U19  (B34_L12N)
#   J10-40 LCD_RST             (RC self-released on the carrier, not wired)
# The IIC2 bus is shared with the on-board HDMI transmitter; the GT911
# addresses (0x5D/0x14) never collide with it.  Module pull-ups exist on
# SDA/SCL/INT (MD0700R RP8/RP9).
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {touch_rst}]
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {touch_scl}]
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {touch_sda_io}]
set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {touch_int_io}]

# Bit-banged I2C at 200 kHz plus quasi-static reset/int strobes: there is
# no source-synchronous timing relationship to meet in either direction.
set_false_path -from [get_ports {touch_sda_io touch_int_io}]
set_false_path -to   [get_ports {touch_rst touch_scl touch_sda_io touch_int_io}]

###################### mpu6050 (GY-521 forearm tilt) ######################

# Carrier J11 "OLED&CAMERA" 2x9 2.54 mm header (carries 3.3V; CMOS_SCL/
# CMOS_SDA have carrier pull-ups R33/R34 4.7k).  Dedicated PL I2C - the
# bus is separate from the touch GT911 IIC2 and the board EEPROM IIC1.
# Ball mapping keyed to the carrier NET names at J2, cross-validated
# against the working LCD/touch balls in a7z020clg400_pkg.xml
# (IO_L1N_T0_34 / IO_L1P_T0_34 are plain IO, no special function):
#   CMOS_SCL = B34_L1N -> mpu_scl    T10
#   CMOS_SDA = B34_L1P -> mpu_sda_io T11 (open drain)
# GY-521 module side: VCC->3.3V, GND, SCL, SDA (AD0 grounded on module
# -> address 0x68).
set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {mpu_scl}]
set_property -dict {PACKAGE_PIN T11 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {mpu_sda_io}]

# Bit-banged I2C at 200 kHz: no source-synchronous timing to meet.
set_false_path -from [get_ports {mpu_sda_io}]
set_false_path -to   [get_ports {mpu_scl mpu_sda_io}]
