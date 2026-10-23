foreach cmd {reset_timing reset_path report_timing set_clock_groups} {if {[catch {help $cmd} out]} {puts "ERROR $cmd: $out"} else {puts $out}}
exit
