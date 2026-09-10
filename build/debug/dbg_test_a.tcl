# Debug flow test A: ps7_init -> dow app -> breakpoint at main -> con.
# Proves whether breakpoints work and the app runs when NOT going through FSBL.
connect

targets -set -filter {name =~ "*Cortex-A9*#0"}
catch { stop }
after 500
puts "STATE-A0: [state]"
catch { configparams force-mem-accesses 1 }

source {d:/FPGA/sEMG-HMRS/build/vitis_ws/ps_uart_print/_ide/psinit/ps7_init.tcl}
ps7_init
ps7_post_config
after 200

if {[catch {mrd 0xF8000738 1} r]} { puts "SLCR READ FAIL: $r"; disconnect; exit }
puts "MIO_PIN_14: $r (expect 000016E1 = UART0 RXD)"
if {![string match "*16E1*" $r]} { puts "ABORT: ps7_init did not stick"; disconnect; exit }

puts "=== dow app (19:29 build) ==="
dow {d:/FPGA/sEMG-HMRS/build/vitis_ws/ps_uart_print/build/ps_uart_print.elf}
stp
after 100
stp
after 100
puts "PC after commit steps: [rrd pc]"
if {[catch {bpadd -addr 0x10000EB0} bp]} { set bp [bpadd 0x10000EB0] }
puts "BP set: $bp (main @ 0x10000EB0)"

puts "=== con - blocks until bp hits; silence here means bp NEVER hits ==="
con
puts "=== after con (reached only if bp hit) ==="
puts "STATE-A1: [state]"
catch { rrd pc }

disconnect
exit
