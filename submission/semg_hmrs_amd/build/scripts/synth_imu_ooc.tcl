set root [file normalize [file join [file dirname [info script]] ../..]]
set out [file join $root report imu_pl_20261028 ooc]
file mkdir $out
create_project -in_memory -part xc7z020clg400-2
set_property include_dirs [list [file join $root src rtl]] [current_fileset]
read_verilog [list [file join $root src rtl learning_div64.v] [file join $root src rtl mpu_attitude_core.v] [file join $root src rtl mpu_attitude.v]]
synth_design -top mpu_attitude -mode out_of_context -part xc7z020clg400-2
create_clock -period 10.0 [get_ports clk]
report_utilization -file [file join $out utilization_synth.rpt]
report_timing_summary -file [file join $out timing_synth.rpt]
write_checkpoint -force [file join $out attitude_synth.dcp]
write_verilog -force -mode funcsim [file join $out attitude_funcsim.v]
puts "IMU_OOC_SYNTH_FINISHED"

