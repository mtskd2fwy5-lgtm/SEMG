# Read-only final routed checkpoint audit, native Vivado 2025.2.
set root [file normalize [file join [file dirname [info script]] .. ..]]
set out [file join $root report pl_control_20261023]
file mkdir $out
open_checkpoint [file join $root build vivado hand_motion_reconstruction.runs impl_1 design_1_routed.dcp]
report_cdc -details -file [file join $out cdc_routed.rpt]
report_bus_skew -file [file join $out bus_skew_routed.rpt]
report_utilization -file [file join $out utilization_routed.rpt]
write_xdc -force -exclude_physical [file join $out constraints_routed.xdc]
report_timing -max_paths 3 -from [get_cells -hier -filter {NAME =~ *g_control*u_control*}] -file [file join $out control_timing.rpt]
puts "CONTROL_CDC_AUDIT_COMPLETE read-only routed checkpoint"
close_design
