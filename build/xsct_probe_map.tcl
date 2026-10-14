# Probe which XSCT target / command variant allows PL AXI access on 2025.2
connect -url tcp:127.0.0.1:3121

puts "=== targets ==="
if {[catch {targets} r]} { puts "targets ERR $r" } else { puts $r }

puts "=== select APU ==="
if {[catch {targets -set -filter {name =~ "APU"}} r]} { puts "sel APU ERR $r" } else { puts "sel APU ok" }
if {[catch {mrd -force 0x43000000 1} r]} { puts "APU mrd ERR $r" } else { puts "APU mrd => $r" }

puts "=== select MPCore #0 ==="
if {[catch {targets -set -filter {name =~ "ARM Cortex-A9 MPCore #0"}} r]} { puts "sel core ERR $r" } else { puts "sel core ok" }
if {[catch {mrd -force 0x43000000 1} r]} { puts "core mrd ERR $r" } else { puts "core mrd => $r" }

puts "=== mwr -force PARKPTR ==="
if {[catch {mwr -force 0x43000028 0x1} r]} { puts "mwr -force ERR $r" } else { puts "mwr -force => $r" }
if {[catch {mrd -force 0x43000028 1} r]} { puts "park rd => $r" } else { puts "park rd => $r" }
if {[catch {mwr -force 0x43000028 0x0} r]} { puts "mwr -force ERR $r" } else { puts "mwr -force => $r" }
if {[catch {mrd -force 0x43000028 1} r]} { puts "park rd => $r" } else { puts "park rd => $r" }

exit 0
