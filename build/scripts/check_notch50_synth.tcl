# Isolated synthesis only: does not open/change the user's BD or program hardware.
# vivado -mode batch -source build/scripts/check_notch50_synth.tcl
set root [file normalize [file join [file dirname [info script]] .. ..]]
set out [file join $root sim results_notch50_synth]
file mkdir $out
create_project -in_memory -part xc7z020clg400-2
foreach src {ads1299_spi emg_notch50 emg_comb50 emg_line_filter emg_bandpass emg_window_features emg_feature_bank emg_nn_infer emg_fatigue axis_async_fifo axis_packet_mux emg_data_path emg_pl_export} {
    read_verilog [file join $root src rtl ${src}.v]
}
synth_design -top emg_pl_export -part xc7z020clg400-2 -mode out_of_context
# Match board/constraints/hz_zynq_ads1299_bd.xdc (25 MHz oscillator)
# and PS FCLK0 (100 MHz); neither clock is being relaxed for this check.
create_clock -name pl_clock -period 40 [get_ports pl_clk]
create_clock -name axis_clock -period 10 [get_ports axis_clk]
set_clock_groups -asynchronous -group [get_clocks pl_clock] -group [get_clocks axis_clock]
report_utilization -hierarchical -file [file join $out utilization.rpt]
report_timing_summary -max_paths 5 -file [file join $out timing_estimate.rpt]
report_timing -through [get_cells -hierarchical -filter {NAME =~ u_notch50/* && IS_SEQUENTIAL}] -max_paths 3 -file [file join $out notch_timing_estimate.rpt]
write_checkpoint -force [file join $out emg_pl_export_synth.dcp]
puts "SYNTH_PASS notch50: isolated emg_pl_export; routing/full-design timing not checked"
close_project
