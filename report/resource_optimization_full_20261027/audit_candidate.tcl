set root [file normalize [file join [file dirname [info script]] ../..]]
set out [file normalize [file join [file dirname [info script]] candidate]]
file mkdir $out
open_checkpoint $root/build/vivado/hand_motion_reconstruction.runs/impl_1/design_1_routed.dcp
report_utilization -file $out/utilization_routed.rpt
report_utilization -hierarchical -hierarchical_depth 5 -file $out/utilization_hierarchical.rpt
report_control_sets -verbose -file $out/control_sets.rpt
report_timing_summary -file $out/timing_routed.rpt
report_bus_skew -file $out/bus_skew.rpt
report_drc -file $out/drc.rpt
puts FULL_RESOURCE_CANDIDATE_AUDIT_COMPLETE
close_design
