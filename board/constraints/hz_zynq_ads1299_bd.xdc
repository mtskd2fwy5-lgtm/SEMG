# HZ-ZYNQ_MV01 / HZ-ZYNQ_CV01 ADS1299 Block Design wrapper constraints
# Use this file after creating system_wrapper from the Vivado Block Design.
# The external ports are named by emg_pl_export module reference.

# Core-board PL clock: PL_CLK = B34_L12P = U18 = OSC_25MHz
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports {pl_clk}]
create_clock -name pl_clk -period 40.000 [get_ports {pl_clk}]

# ADS1299 interface on the selected B34 expansion signals.
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {adc_sclk}]    ;# B34_L23N
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {adc_din}]     ;# B34_L23P
set_property -dict {PACKAGE_PIN V20 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {adc_cs_n}]    ;# B34_L16P
set_property -dict {PACKAGE_PIN W20 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {adc_reset_n}] ;# B34_L16N
set_property -dict {PACKAGE_PIN R16 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {adc_start}]   ;# B34_L19P
set_property -dict {PACKAGE_PIN R17 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {adc_pwdn_n}]  ;# B34_L19N
set_property -dict {PACKAGE_PIN W18 IOSTANDARD LVCMOS33} [get_ports {adc_dout}]                      ;# B34_L22P
set_property -dict {PACKAGE_PIN W19 IOSTANDARD LVCMOS33} [get_ports {adc_drdy_n}]                    ;# B34_L22N

# PL_KEY1 is the active-low acquisition reset input.
set_property -dict {PACKAGE_PIN K16 IOSTANDARD LVCMOS33} [get_ports {pl_rst_n}]                      ;# B35_L24P
set_property PULLUP TRUE [get_ports {pl_rst_n}]

# PL_LED0 indicates that ADS1299 initialization has completed.
set_property -dict {PACKAGE_PIN H15 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {status_led}]  ;# B35_L19P

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
