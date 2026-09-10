# FINAL LAUNCH: stop -> ps7_init(UART0) -> fpga -> dow -> stp x2 -> con.
# Leaves the app running on UART0 @ MIO14/15. Watch COM3.
connect

targets -set -filter {name =~ "*Cortex-A9*#0"}
catch { stop }
after 300
puts "STATE-K0: [state]"

source {d:/FPGA/sEMG-HMRS/build/vitis_ws/ps_uart_print/_ide/psinit/ps7_init.tcl}
ps7_init
ps7_post_config
after 200

if {[catch {fpga d:/FPGA/sEMG-HMRS/build/vitis_ws/ps_uart_print/_ide/bitstream/design_1.bit} f]} {
    puts "FPGA ERR: $f"
} else {
    puts "FPGA OK"
}

dow {d:/FPGA/sEMG-HMRS/build/vitis_ws/ps_uart_print/build/ps_uart_print.elf}
stp
after 100
stp
after 100
puts "COMMIT-STEPS OK, releasing app..."

con
after 500
disconnect
exit
