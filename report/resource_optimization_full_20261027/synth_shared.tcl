set root [file normalize [file join [file dirname [info script]] ../..]]
set out [file normalize [file dirname [info script]]]
foreach top {emg_feature_bank emg_line_filter} {
    create_project -in_memory -part xc7z020clg400-2
    foreach name {emg_bandpass emg_window_features emg_feature_bank emg_notch50 emg_comb50 emg_line_filter} {
        read_verilog $root/src/rtl/$name.v
    }
    if {$top eq "emg_feature_bank"} {set parameters BYPASS_BANDPASS=1} else {set parameters BANDPASS_ENABLE=1}
    synth_design -top $top -part xc7z020clg400-2 -mode out_of_context -generic $parameters
    create_clock -name processing_clock -period 40 [get_ports clk]
    report_utilization -file $out/${top}_synth_utilization.rpt
    write_verilog -force -mode funcsim $out/${top}_synth.v
    close_project
}
puts SHARED_SYNTH_COMPLETE
