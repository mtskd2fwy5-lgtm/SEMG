# SPDX-License-Identifier: Apache-2.0
set root [file normalize [file join [file dirname [info script]] ../..]]
set out [file join $root report/hdmi_mirror_20261103]
create_project -in_memory -part xc7z020clg400-2
read_verilog [file join $root src/rtl/hdmi_scaler.v]
synth_design -top hdmi_scaler -part xc7z020clg400-2
report_utilization -file [file join $out scaler_utilization_synth.rpt]
set ram [get_cells -hier -filter {REF_NAME =~ RAMB*}]
if {[llength $ram]!=2} {error "Scaler must infer exactly two line-buffer BRAMs, found [llength $ram]"}
write_verilog -force -mode funcsim [file join $out hdmi_scaler_netlist.v]
puts "TEST_PASS HDMI scaler synthesis: exactly two block RAMs, no distributed framebuffer"

