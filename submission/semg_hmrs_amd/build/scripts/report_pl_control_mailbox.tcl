# Read-only routed mailbox audit: report paths excluded by asynchronous groups.
set root [file normalize [file join [file dirname [info script]] .. ..]]
set out [file join $root report pl_control_20261023]
open_checkpoint [file join $root build vivado hand_motion_reconstruction.runs impl_1 design_1_routed.dcp]
set payload_to [get_cells -hier -regexp {emg_pl_export_0/inst/(epoch_reg.*|shift_reg.*|recalibrate_reg)}]
set command_from [get_cells -hier -filter {NAME =~ axi_gpio_4/*gpio_Data_Out_reg*}]
set status_from [get_cells -hier -filter {NAME =~ emg_pl_export_0/inst/status_hold_reg*}]
set status_to [get_cells -hier -filter {NAME =~ emg_pl_export_0/inst/status_axis_reg*}]
if {[llength $payload_to]!=8 || [llength $status_from]!=11 || [llength $status_to]!=11} {
    error "Unexpected implemented mailbox register counts"
}
report_timing -user_ignored -from $command_from -to $payload_to -max_paths 32 -nworst 4 -file [file join $out mailbox_command_paths.rpt]
report_timing -user_ignored -from $status_from -to $status_to -max_paths 32 -file [file join $out mailbox_status_paths.rpt]
foreach pattern {emg_pl_export_0/inst/ack_sync_reg/C axi_gpio_4/*syncstages_ff_reg*15*/C} {
    foreach pin [get_pins -hier -filter "NAME =~ $pattern"] {puts "MAILBOX_CLOCK $pin [get_clocks -of_objects $pin]"}
}
puts "MAILBOX_AUDIT_COMPLETE"
close_design

