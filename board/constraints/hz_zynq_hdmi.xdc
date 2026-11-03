# HZ-ZYNQ_MV01 J17, schematic pages 1/5 and CV01 FPGA package cross-check.
# Direct TMDS (no external transmitter IC). Bank35 VCCO=3.3V.
set_property -dict {PACKAGE_PIN G19 IOSTANDARD TMDS_33} [get_ports {hdmi_data_p[0]}]
set_property -dict {PACKAGE_PIN G20 IOSTANDARD TMDS_33} [get_ports {hdmi_data_n[0]}]
set_property -dict {PACKAGE_PIN K19 IOSTANDARD TMDS_33} [get_ports {hdmi_data_p[1]}]
set_property -dict {PACKAGE_PIN J19 IOSTANDARD TMDS_33} [get_ports {hdmi_data_n[1]}]
set_property -dict {PACKAGE_PIN J20 IOSTANDARD TMDS_33} [get_ports {hdmi_data_p[2]}]
set_property -dict {PACKAGE_PIN H20 IOSTANDARD TMDS_33} [get_ports {hdmi_data_n[2]}]
set_property -dict {PACKAGE_PIN J18 IOSTANDARD TMDS_33} [get_ports hdmi_clk_p]
set_property -dict {PACKAGE_PIN H18 IOSTANDARD TMDS_33} [get_ports hdmi_clk_n]
set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVCMOS33} [get_ports hdmi_hpd]
# Only the asynchronous external HPD input to its first synchronizer stage.
set_false_path -from [get_ports hdmi_hpd]
# TMDS is serialized by OSERDES directly into OBUFDS. There is no external
# synchronous receiving clock at FPGA pins; internal pixel/5x timing is checked.
