set root [file normalize [file join [file dirname [info script]] ../..]]
set out [file dirname [info script]]
foreach variant {baseline candidate} {
    create_project -in_memory -part xc7z020clg400-2
    if {$variant eq "baseline"} {
        read_verilog $out/baseline/src/rtl/emg_window_features.v
    } else {
        read_verilog $root/src/rtl/emg_window_features.v
    }
    synth_design -top emg_window_features -part xc7z020clg400-2 -mode out_of_context
    create_clock -name feature_clock -period 40 [get_ports clk]
    report_utilization -file $out/$variant/feature_synth_utilization.rpt
    if {$variant eq "candidate"} {
        write_verilog -force -mode funcsim $out/candidate/feature_synth.v
    }
    close_project
}
puts FEATURE_SYNTH_COMPARISON_COMPLETE
