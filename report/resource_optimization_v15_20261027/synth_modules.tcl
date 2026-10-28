set root [file normalize [file join [file dirname [info script]] ../..]]
set out [file normalize [file dirname [info script]]]
foreach variant {baseline candidate} {
 foreach top {emg_nn_infer hand_servo_pwm emg_fatigue} {
    create_project -in_memory -part xc7z020clg400-2
    if {$variant eq "baseline"} {set source $out/baseline/src/rtl/$top.v} else {set source $root/src/rtl/$top.v}
    read_verilog $source
    synth_design -top $top -part xc7z020clg400-2 -mode out_of_context
    create_clock -name processing_clock -period 40 [get_ports clk]
    report_utilization -file $out/${variant}_${top}_utilization.rpt
    write_verilog -force -mode funcsim $out/${variant}_${top}_synth.v
    close_project
 }
}
puts V15_MODULE_SYNTH_COMPLETE
