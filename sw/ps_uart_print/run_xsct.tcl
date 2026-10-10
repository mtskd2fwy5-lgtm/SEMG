# XSCT script: program the FPGA, run ps7_init, download and start the
# bare-metal PS stream monitor. Invoked by run.ps1 (which extracts the
# ps7_init files from the exported XSA); can also be run manually with
#   xsct run_xsct.tcl
#
# After "con" completes, open a serial terminal on the board's USB-UART
# (UART0, MIO 14/15) at 115200-8N1 to inspect optional debug output.

set script_dir [file dirname [info script]]
set root       [file normalize [file join $script_dir .. ..]]
set bitfile    [file join $root build vivado hand_motion_reconstruction.runs \
                     impl_1 design_1.bit]
set elffile    [file join $script_dir ps_uart_print.elf]
set ps7init    [file join $root build export xsa ps7_init.tcl]

foreach f [list $bitfile $elffile $ps7init] {
    if {![file exists $f]} {
        error "Missing file: $f\n(export the XSA / build the ELF first)"
    }
}

puts "RUN bit  : $bitfile"
puts "RUN elf  : $elffile"
puts "RUN ps7  : $ps7init"

connect
targets -set -filter {name =~ "APU*"}
fpga $bitfile
source $ps7init
ps7_init
ps7_init
ps7_post_config
dow $elffile
con
puts "RUN RUNNING - serial terminal 115200-8N1 (UART0, MIO 14/15)"
