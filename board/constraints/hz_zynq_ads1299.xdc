# HZ-ZYNQ_MV01 / HZ-ZYNQ_CV01 ADS1299 interface constraints
# Sources: HZ-ZYNQ_MV01-20250910.pdf, HZ-ZYNQ_CV01.pdf,
# HZ-ZYNQ_CV01_管脚说明_202509916.xlsx
# Assumption: B34/B35 bank-voltage selection is 3.3 V.

# Core-board PL clock: PL_CLK = B34_L12P = U18 = OSC_25MHz
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports {clk}]
create_clock -name pl_clk -period 40.000 [get_ports {clk}]

# The RTL toggles adc_sclk every 10 PL_CLK cycles:
# 25 MHz / (2 * 10) = 1.25 MHz.
create_generated_clock -name ads1299_sclk \
    -source [get_ports {clk}] \
    -divide_by 20 \
    [get_ports {adc_sclk}]

# ADS1299 interface on ZYNQ-DIP expansion signals.
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {adc_sclk}]    ;# B34_L23N
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {adc_din}]     ;# B34_L23P
set_property -dict {PACKAGE_PIN V20 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {adc_cs_n}]    ;# B34_L16P
set_property -dict {PACKAGE_PIN W20 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {adc_reset_n}] ;# B34_L16N
set_property -dict {PACKAGE_PIN R16 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {adc_start}]   ;# B34_L19P
set_property -dict {PACKAGE_PIN R17 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {adc_pwdn_n}]  ;# B34_L19N
set_property -dict {PACKAGE_PIN W18 IOSTANDARD LVCMOS33} [get_ports {adc_dout}]                      ;# B34_L22P
set_property -dict {PACKAGE_PIN W19 IOSTANDARD LVCMOS33} [get_ports {adc_drdy_n}]                    ;# B34_L22N

# DRDY is asynchronous to PL_CLK and is synchronized in ads1299_spi.
set_false_path -from [get_ports {adc_drdy_n}]

# Board reset key: PL_KEY1 is active-low and has a board pull-up.
set_property -dict {PACKAGE_PIN K16 IOSTANDARD LVCMOS33} [get_ports {rst_n}]                         ;# B35_L24P
set_property PULLUP TRUE [get_ports {rst_n}]

# PL_LED0 indicates completed initialization.
set_property -dict {PACKAGE_PIN H15 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {status_led}]  ;# B35_L19P

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
