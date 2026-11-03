# HZ-ZYNQ_MV01 / HZ-ZYNQ_CV01 ADS1299 Block Design wrapper constraints
# Use this file after creating design_1_wrapper from the Vivado Block Design.
# Port names carry the _0 suffix the BD added to the external ports.

# Core-board PL clock: PL_CLK = B34_L12P = U18 = OSC_25MHz
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports {pl_clk_0}]
create_clock -name pl_clk -period 40.000 [get_ports {pl_clk_0}]

# The RTL toggles adc_sclk every 5 PL_CLK cycles:
# 25 MHz / (2 * 5) = 2.5 MHz.
create_generated_clock -name ads1299_sclk \
    -source [get_ports {pl_clk_0}] \
    -divide_by 10 \
    [get_ports {adc_sclk_0}]

# ADS1299 interface on bank 13, MOVED off J3/LCD_B[7:0] (2026-09-21).
# Why: bank 34 is shared with the carrier's RGB LCD bus, so the planned
# onboard virtual-hand display (VDMA + VTC driving LCD_B) would fight the
# ADC SPI.  The eight signals now sit on eight CONTIGUOUS J4 (2x20) pins
# 17..24.  Verified against HZ-ZYNQ_MV01-20250910 schematic: bank 13 nets
# appear ONLY on passive headers (J4 + the ZYNQ-DIP sockets); no LCD,
# HDMI or USB0 device drives them (USB0 UTMI lives on the PS MIO bank).
# BANK13 is 3.3 V by default per the core-board doc "B13 B34 B35 changed
# to 1.8V operation guide" (only re-soldering L23 -> L24 changes it).
# Ball numbers verified against the Vivado package file xc7z020_clg400.pkg
# (the vendor pin-description xlsx has shifted rows and its B13 ball
# column is WRONG - do not use it for ball mapping).
set_property -dict {PACKAGE_PIN Y9  IOSTANDARD LVCMOS33} [get_ports {adc_drdy_n_0}]                    ;# B13_L14P (SRCC), J4-17
set_property -dict {PACKAGE_PIN Y8  IOSTANDARD LVCMOS33} [get_ports {adc_dout_0}]                      ;# B13_L14N (SRCC), J4-18
set_property -dict {PACKAGE_PIN W10 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {adc_sclk_0}]    ;# B13_L16P, J4-19
set_property -dict {PACKAGE_PIN W9  IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {adc_din_0}]     ;# B13_L16N, J4-20
set_property -dict {PACKAGE_PIN V11 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {adc_cs_n_0}]    ;# B13_L21P (DQS), J4-21
set_property -dict {PACKAGE_PIN V10 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {adc_start_0}]   ;# B13_L21N (DQS), J4-22
set_property -dict {PACKAGE_PIN Y13 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {adc_reset_n_0}] ;# B13_L20N, J4-23
set_property -dict {PACKAGE_PIN Y12 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {adc_pwdn_n_0}]  ;# B13_L20P, J4-24

# PL_KEY1 is the active-low acquisition reset input.
set_property -dict {PACKAGE_PIN K16 IOSTANDARD LVCMOS33} [get_ports {pl_rst_n_0}]                      ;# B35_L24P
set_property PULLUP TRUE [get_ports {pl_rst_n_0}]

# PL_KEY0 is the active-low ADS1299 reconfig button (press = replay the
# SDATAC/WREG/RDATAC/START command sequence).  Board has a 4K7 pull-up and
# 1000pF to GND on the net; ball L14 verified against xc7z020_clg400.pkg
# (B35_L22P; K16/H15 cross-check).
set_property -dict {PACKAGE_PIN L14 IOSTANDARD LVCMOS33} [get_ports {reconfig_n_0}]                    ;# B35_L22P
set_property PULLUP TRUE [get_ports {reconfig_n_0}]

# PL_LED0 indicates that ADS1299 initialization has completed.
set_property -dict {PACKAGE_PIN H15 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {status_led_0}]  ;# B35_L19P

# DRDY is asynchronous to pl_clk and is double-synchronized in ads1299_spi.
# The key reset is asynchronous (synchronized inside emg_pl_export); the
# status LED has no timing requirement.
set_false_path -from [get_ports {adc_drdy_n_0}]
set_false_path -from [get_ports {pl_rst_n_0}]
set_false_path -from [get_ports {reconfig_n_0}]
set_false_path -to   [get_ports {status_led_0}]

# ADS1299 source-synchronous SPI timing. SCLK runs at 2.5 MHz (200 ns
# half period), so these generous ADS1299 datasheet-class values still
# leave an enormous margin: DOUT settles within ~25 ns of the SCLK edge,
# device inputs need ~10 ns setup / ~5 ns hold.
# Delays are given for both references: ads1299_sclk (source-sync) and
# pl_clk (the domain of the internal FFs driving/sampling these pins).
# Note: XDC rejects combining -max and -min in one set_*_delay call.
set_input_delay  -clock ads1299_sclk -max 25.0 [get_ports {adc_dout_0}]
set_input_delay  -clock ads1299_sclk -min  0.0 [get_ports {adc_dout_0}]
set_input_delay  -clock pl_clk -max 25.0 [get_ports {adc_dout_0}]
set_input_delay  -clock pl_clk -min  0.0 [get_ports {adc_dout_0}]
set_output_delay -clock ads1299_sclk -max 10.0 [get_ports {adc_din_0}]
set_output_delay -clock ads1299_sclk -min -5.0 [get_ports {adc_din_0}]
set_output_delay -clock pl_clk -max 10.0 [get_ports {adc_din_0}]
set_output_delay -clock pl_clk -min -5.0 [get_ports {adc_din_0}]
set_output_delay -clock ads1299_sclk -max 10.0 [get_ports {adc_cs_n_0}]
set_output_delay -clock ads1299_sclk -min -5.0 [get_ports {adc_cs_n_0}]
set_output_delay -clock pl_clk -max 10.0 [get_ports {adc_cs_n_0}]
set_output_delay -clock pl_clk -min -5.0 [get_ports {adc_cs_n_0}]
set_output_delay -clock ads1299_sclk -max 10.0 [get_ports {adc_start_0}]
set_output_delay -clock ads1299_sclk -min -5.0 [get_ports {adc_start_0}]
set_output_delay -clock pl_clk -max 10.0 [get_ports {adc_start_0}]
set_output_delay -clock pl_clk -min -5.0 [get_ports {adc_start_0}]
set_output_delay -clock ads1299_sclk -max 10.0 [get_ports {adc_reset_n_0}]
set_output_delay -clock ads1299_sclk -min -5.0 [get_ports {adc_reset_n_0}]
set_output_delay -clock pl_clk -max 10.0 [get_ports {adc_reset_n_0}]
set_output_delay -clock pl_clk -min -5.0 [get_ports {adc_reset_n_0}]
set_output_delay -clock ads1299_sclk -max 10.0 [get_ports {adc_pwdn_n_0}]
set_output_delay -clock ads1299_sclk -min -5.0 [get_ports {adc_pwdn_n_0}]
set_output_delay -clock pl_clk -max 10.0 [get_ports {adc_pwdn_n_0}]
set_output_delay -clock pl_clk -min -5.0 [get_ports {adc_pwdn_n_0}]

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

