# HZ-ZYNQ_MV01 / HZ-ZYNQ_CV01 ADS1299 Block Design wrapper constraints
# Use this file after creating design_1_wrapper from the Vivado Block Design.
# Port names carry the _0 suffix the BD added to the external ports.

# Core-board PL clock: PL_CLK = B34_L12P = U18 = OSC_25MHz
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports {pl_clk_0}]
create_clock -name pl_clk -period 40.000 [get_ports {pl_clk_0}]

# The RTL toggles adc_sclk every 10 PL_CLK cycles:
# 25 MHz / (2 * 10) = 1.25 MHz.
create_generated_clock -name ads1299_sclk \
    -source [get_ports {pl_clk_0}] \
    -divide_by 20 \
    [get_ports {adc_sclk_0}]

# ADS1299 interface on the selected B34 expansion signals.
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {adc_sclk_0}]    ;# B34_L23N
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {adc_din_0}]     ;# B34_L23P
set_property -dict {PACKAGE_PIN V20 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {adc_cs_n_0}]    ;# B34_L16P
set_property -dict {PACKAGE_PIN W20 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {adc_reset_n_0}] ;# B34_L16N
set_property -dict {PACKAGE_PIN R16 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {adc_start_0}]   ;# B34_L19P
set_property -dict {PACKAGE_PIN R17 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {adc_pwdn_n_0}]  ;# B34_L19N
set_property -dict {PACKAGE_PIN W18 IOSTANDARD LVCMOS33} [get_ports {adc_dout_0}]                      ;# B34_L22P
set_property -dict {PACKAGE_PIN W19 IOSTANDARD LVCMOS33} [get_ports {adc_drdy_n_0}]                    ;# B34_L22N

# PL_KEY1 is the active-low acquisition reset input.
set_property -dict {PACKAGE_PIN K16 IOSTANDARD LVCMOS33} [get_ports {pl_rst_n_0}]                      ;# B35_L24P
set_property PULLUP TRUE [get_ports {pl_rst_n_0}]

# PL_LED0 indicates that ADS1299 initialization has completed.
set_property -dict {PACKAGE_PIN H15 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {status_led_0}]  ;# B35_L19P

# DRDY is asynchronous to pl_clk and is double-synchronized in ads1299_spi.
# The key reset is asynchronous (synchronized inside emg_pl_export); the
# status LED has no timing requirement.
set_false_path -from [get_ports {adc_drdy_n_0}]
set_false_path -from [get_ports {pl_rst_n_0}]
set_false_path -to   [get_ports {status_led_0}]

# ADS1299 source-synchronous SPI timing. SCLK runs at 1.25 MHz (400 ns
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
