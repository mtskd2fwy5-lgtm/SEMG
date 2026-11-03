# SPDX-License-Identifier: Apache-2.0
set root [file normalize [file join [file dirname [info script]] ../..]]
set out [file join $root report/hdmi_mirror_20261103]
open_project [file join $root build/vivado/hand_motion_reconstruction.xpr]
open_bd_design [get_files design_1.bd]
set n 0
set fp [open [file join $out dma_configuration.txt] w]
foreach p [list_property [get_bd_cells axi_vdma_0]] {
    if {![string match CONFIG.* $p] || $p in {CONFIG.Component_Name CONFIG.C_COMPONENT_NAME}} {continue}
    set a [get_property $p [get_bd_cells axi_vdma_0]]
    set b [get_property $p [get_bd_cells axi_vdma_hdmi]]
    puts $fp "$p LCD=$a HDMI=$b"
    if {$a ne $b} {error "HDMI DMA actual configuration mismatch: $p LCD=$a HDMI=$b"}
    incr n
}
close $fp
close_bd_design [current_bd_design]
open_run impl_1
set os [get_cells -hier -filter {REF_NAME == OSERDESE2}]
if {[llength $os]!=8} {error "Expected 8 real OSERDES master/slave cells, got [llength $os]"}
set ram [get_cells -hier -filter {REF_NAME =~ RAMB* && NAME =~ hdmi_scaler_0/*}]
if {[llength $ram]!=2} {error "Actual scaler uses [llength $ram] BRAM cells, expected 2"}
set fp [open [file join $out output_pins.txt] w]
foreach {name ball} {hdmi_clk_p J18 hdmi_clk_n H18 hdmi_data_p[0] G19 hdmi_data_n[0] G20 hdmi_data_p[1] K19 hdmi_data_n[1] J19 hdmi_data_p[2] J20 hdmi_data_n[2] H20 hdmi_hpd L19} {
    set p [get_ports $name]
    set actual [get_property PACKAGE_PIN $p]
    puts $fp "$name $actual [get_property IOSTANDARD $p]"
    if {$actual ne $ball} {error "HDMI pin mismatch: $name expected $ball got $actual"}
}
close $fp
set px [get_clocks -of_objects [get_pins hdmi_output_0/inst/mmcm/CLKOUT0]]
set fast [get_clocks -of_objects [get_pins hdmi_output_0/inst/mmcm/CLKOUT1]]
if {[llength $px]!=1 || abs([get_property PERIOD $px]-13.468)>0.002} {error "HDMI pixel clock incorrect: $px"}
if {[llength $fast]!=1 || abs([get_property PERIOD $fast]-2.694)>0.002} {error "HDMI serialization clock incorrect: $fast"}
report_clocks -file [file join $out clocks.rpt]
report_exceptions -file [file join $out exceptions.rpt]
report_cdc -details -file [file join $out cdc_detailed.rpt]
write_verilog -force -mode funcsim [file join $out full_system_netlist.v]
close_project
puts "TEST_PASS HDMI routed audit: $n exact DMA settings, 2 BRAMs, 8 OSERDES, 9 schematic pins, 74.25/371.25MHz clocks"

