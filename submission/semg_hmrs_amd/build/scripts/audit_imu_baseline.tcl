# Separate original methodology warnings from those introduced by migration.
set root [file normalize [file join [file dirname [info script]] ../..]]
set out [file join $root report/imu_pl_20261028/baseline_audit]
file mkdir $out
open_checkpoint [file join $root report/resource_optimization_v15_20261027/candidate/design_1_routed.dcp]
report_methodology -file [file join $out methodology.rpt]
report_cdc -file [file join $out cdc.rpt]
report_timing_summary -delay_type min_max -file [file join $out timing.rpt]
puts "TEST_PASS V16 inherited hardware methodology exported"
close_design

