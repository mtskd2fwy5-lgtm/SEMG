set root [file normalize [file join [file dirname [info script]] ../..]]
set out [file join $root report/hand_pwm_inverted_20261029]
create_project -in_memory -part xc7z020clg400-2
read_verilog [list [file join $root src/rtl/hand_servo_pwm.v] [file join $root src/rtl/hand_control.v]]
synth_design -top hand_control -mode out_of_context -part xc7z020clg400-2 -generic {CLOCK_HZ=1000000 TIMEOUT_MS=100}
write_verilog -mode funcsim -force [file join $out hand_control_funcsim.v]
report_utilization -file [file join $out hand_control_utilization.rpt]
puts "TEST_PASS hand PWM synthesis netlist exported CLOCK_HZ=1000000 TIMEOUT_MS=100"
close_project
