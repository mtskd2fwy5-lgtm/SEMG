# Audit the actual full-system routed checkpoint, not an isolated estimate.
set root [file normalize [file join [file dirname [info script]] ../..]]
set out [file join $root report/imu_pl_20261028]
open_checkpoint [file join $root build/vivado/hand_motion_reconstruction.runs/impl_1/design_1_routed.dcp]
report_utilization -file [file join $out utilization_routed.rpt]
report_utilization -hierarchical -hierarchical_depth 5 -file [file join $out utilization_hierarchical.rpt]
report_timing_summary -delay_type min_max -report_unconstrained -file [file join $out timing_routed.rpt]
report_cdc -file [file join $out cdc.rpt]
report_drc -file [file join $out drc.rpt]
report_methodology -file [file join $out methodology_routed.rpt]
report_bus_skew -file [file join $out bus_skew.rpt]
set f [open [file join $out attitude_clock_paths.txt] w]
set captured {}
foreach pattern {*mpu_attitude_0/*/sequence_meta_reg* *mpu_attitude_0/*/sensor_a_reg* *mpu_attitude_0/*/sensor_b_reg* *mpu_attitude_0/*/sensor_c_reg*} {
    set cells [get_cells -hier -quiet -filter "NAME =~ $pattern"]
    foreach c $cells {
        set clocks [get_clocks -quiet -of_objects [get_pins -quiet $c/C]]
        if {[llength $clocks]!=1 || [get_property PERIOD $clocks]!=10.0} {error "Attitude register clock mismatch: $c $clocks"}
        puts $f "$c clocks=$clocks"
        lappend captured $c
    }
}
close $f
if {[llength $captured]<50} {error "Attitude capture registers not found in routed design"}
report_timing -to [get_pins -quiet -of_objects [get_cells -hier -filter {NAME =~ *mpu_attitude_0/*/sensor_?_reg*}] -filter {REF_PIN_NAME == D}] -max_paths 10 -path_type full_clock_expanded -file [file join $out attitude_capture_timing.rpt]
puts "TEST_PASS IMU full-system routed audit exported"
close_design

