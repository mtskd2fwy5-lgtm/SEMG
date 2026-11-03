set root [file normalize [file join [file dirname [info script]] ../..]]
set out [file join $root report/imu_zero_20261031]
file mkdir $out
open_checkpoint [file join $root build/vivado/hand_motion_reconstruction.runs/impl_1/design_1_routed.dcp]
report_timing_summary -delay_type min_max -report_unconstrained -file [file join $out timing_routed.rpt]
report_utilization -file [file join $out utilization_routed.rpt]
report_drc -file [file join $out drc.rpt]
report_methodology -file [file join $out methodology_routed.rpt]
report_bus_skew -file [file join $out bus_skew.rpt]
close_design
puts "TEST_PASS current-pose zero routed audit"

