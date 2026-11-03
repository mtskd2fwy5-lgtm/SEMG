# HZ-ZYNQ_MV01 / HZ-ZYNQ_CV01 ADS1299 interface constraints
# Sources: HZ-ZYNQ_MV01-20250910.pdf, HZ-ZYNQ_CV01.pdf,
# HZ-ZYNQ_CV01_管脚说明_202509916.xlsx
# Assumption: B34/B35/B13 bank voltages are the board default 3.3 V.

# Core-board PL clock: PL_CLK = B34_L12P = U18 = OSC_25MHz
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports {clk}]
create_clock -name pl_clk -period 40.000 [get_ports {clk}]

# The RTL toggles adc_sclk every 5 PL_CLK cycles:
# 25 MHz / (2 * 5) = 2.5 MHz.
create_generated_clock -name ads1299_sclk \
    -source [get_ports {clk}] \
    -divide_by 10 \
    [get_ports {adc_sclk}]

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
set_property -dict {PACKAGE_PIN Y9  IOSTANDARD LVCMOS33} [get_ports {adc_drdy_n}]                     ;# B13_L14P (SRCC), J4-17
set_property -dict {PACKAGE_PIN Y8  IOSTANDARD LVCMOS33} [get_ports {adc_dout}]                       ;# B13_L14N (SRCC), J4-18
set_property -dict {PACKAGE_PIN W10 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {adc_sclk}]     ;# B13_L16P, J4-19
set_property -dict {PACKAGE_PIN W9  IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {adc_din}]      ;# B13_L16N, J4-20
set_property -dict {PACKAGE_PIN V11 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {adc_cs_n}]     ;# B13_L21P (DQS), J4-21
set_property -dict {PACKAGE_PIN V10 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {adc_start}]    ;# B13_L21N (DQS), J4-22
set_property -dict {PACKAGE_PIN Y13 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {adc_reset_n}]  ;# B13_L20N, J4-23
set_property -dict {PACKAGE_PIN Y12 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {adc_pwdn_n}]   ;# B13_L20P, J4-24

# DRDY is asynchronous to PL_CLK and is synchronized in ads1299_spi.
set_false_path -from [get_ports {adc_drdy_n}]
# Mechanical key: asynchronous input, synchronized/debounced in ads1299_spi.
set_false_path -from [get_ports {reconfig_n}]

# Board reset key: PL_KEY1 is active-low and has a board pull-up.
set_property -dict {PACKAGE_PIN K16 IOSTANDARD LVCMOS33} [get_ports {rst_n}]                         ;# B35_L24P
set_property PULLUP TRUE [get_ports {rst_n}]

# Board reconfig key: PL_KEY0 is active-low (4K7 pull-up + 1000pF on board).
# Press = replay the ADS1299 SDATAC/WREG/RDATAC/START command sequence.
# Ball L14 verified against xc7z020_clg400.pkg (B35_L22P; K16/H15 cross-check).
set_property -dict {PACKAGE_PIN L14 IOSTANDARD LVCMOS33} [get_ports {reconfig_n}]                    ;# B35_L22P
set_property PULLUP TRUE [get_ports {reconfig_n}]

# PL_LED0 indicates completed initialization.
set_property -dict {PACKAGE_PIN H15 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {status_led}]  ;# B35_L19P

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

