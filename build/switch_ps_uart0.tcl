# Switch the PS7 debug UART back to UART0 (MIO 14/15).
#
# Physical check on hardware 2026-09-10 (user): the CH340C USB-UART bridge
# is wired to MIO 14/15, NOT MIO 48/49. The baseboard-manual claim that put
# the bridge on UART1 @ MIO48/49 (and switch_ps_uart1.tcl) was wrong.
# On Zynq-7000 the only UART function available on MIO 14/15 is UART0
# (RXD=MIO14, TXD=MIO15), regardless of the silkscreen label.
#
# Run in batch mode:
#   vivado -mode batch -source build/switch_ps_uart0.tcl
#
# PL logic is untouched (PS7 MIO pinmux only), so the existing bitstream
# stays valid. Only ps7_init and the XSA metadata change.

set project_root [file normalize [file join [file dirname [info script]] ..]]

open_project [file join $project_root build vivado hand_motion_reconstruction.xpr]
open_bd_design [file join $project_root build vivado \
    hand_motion_reconstruction.srcs sources_1 bd design_1 design_1.bd]

set ps7 [get_bd_cells processing_system7_0]
if {[llength $ps7] != 1} {
    error "processing_system7_0 cell not found in the block design"
}

set_property -dict [list \
    CONFIG.PCW_UART0_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_UART0_UART0_IO {MIO 14 .. 15} \
    CONFIG.PCW_UART0_BAUD_RATE {115200} \
    CONFIG.PCW_UART1_PERIPHERAL_ENABLE {0} \
] $ps7

validate_bd_design
save_bd_design
generate_target all [get_files design_1.bd]

set act [get_property CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ $ps7]
puts "SWITCH-PS-UART0 UART0 on MIO 14/15 enabled (UART1 off), ref clock = $act MHz"

if {[catch {open_run impl_1} run_msg]} {
    puts "SWITCH-PS-UART0 WARN open_run impl_1 failed: $run_msg"
    puts "SWITCH-PS-UART0 exporting XSA WITHOUT bitstream"
    write_hw_platform -fixed -force [file join $project_root build export design_1.xsa]
} else {
    write_hw_platform -fixed -include_bit -force \
        [file join $project_root build export design_1.xsa]
}

close_project
puts "SWITCH-PS-UART0 DONE"
