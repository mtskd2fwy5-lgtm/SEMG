set root [file normalize [file join [file dirname [info script]] ../..]]
set out [file join $root report/hand_pwm_inverted_20261029]
open_checkpoint [file join $root build/vivado/hand_motion_reconstruction.runs/impl_1/design_1_routed.dcp]
report_utilization -file [file join $out utilization_routed.rpt]
report_timing_summary -delay_type min_max -report_unconstrained -file [file join $out timing_routed.rpt]
report_drc -file [file join $out drc.rpt]
report_methodology -file [file join $out methodology_routed.rpt]
report_bus_skew -file [file join $out bus_skew.rpt]
set f [open [file join $out output_pins.txt] w]
set balls {V7 U7 W8 V8 U9 U8}
for {set i 0} {$i<6} {incr i} {
 set p [get_ports [format {hand_pwm[%d]} $i]]
 if {[get_property PACKAGE_PIN $p] ne [lindex $balls $i] || [get_property IOSTANDARD $p] ne "LVCMOS33"} {error "PWM pin mismatch $p"}
 puts $f "$p PACKAGE_PIN=[get_property PACKAGE_PIN $p] IOSTANDARD=[get_property IOSTANDARD $p]"
}
close $f
puts "TEST_PASS hand PWM routed six pins and full-system audit exported"
close_design

