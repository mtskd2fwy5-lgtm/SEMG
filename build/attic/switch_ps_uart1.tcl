# [OBSOLETE 2026-09-10] Do NOT source this script - route disproven.
# Final truth: CH340C is physically wired to MIO 14/15 (= UART0), and the
# carrier-board manual 2.3.8 is wrong. Use build/switch_ps_uart0.tcl instead.
# Kept only as a record of the failed UART1/MIO48/49 investigation.
#
# Switch the PS7 debug UART from UART0 (MIO 14/15) to UART1 (MIO 48/49).
#
# The carrier-board CH340C USB-UART bridge is wired to UART1 (MIO 48/49),
# confirmed on hardware 2026-09-10: UART0 @ MIO14/15 transmitted correctly
# (PC verified in dma_wait, TX FIFO drained) but the CH340 received zero
# bytes. The earlier assumption in enable_ps_uart.tcl was wrong.
#
# Source this INSIDE an open Vivado GUI Tcl Console (project already open):
#   source build/switch_ps_uart1.tcl
#
# PL logic is untouched (PS7 MIO pinmux only), so existing synthesis,
# implementation and the bitstream remain valid. Only ps7_init and the
# XSA metadata change; the design runs are left stale on purpose.

set project_root [file normalize [file join [file dirname [info script]] ..]]
set bd_file [file join $project_root build vivado hand_motion_reconstruction.srcs \
    sources_1 bd design_1 design_1.bd]

if {![file exists $bd_file]} {
    error "Block design not found: $bd_file"
}
if {[catch {current_project}]} {
    error "No project open - open hand_motion_reconstruction.xpr in the GUI first"
}

open_bd_design $bd_file

set ps7 [get_bd_cells processing_system7_0]
if {[llength $ps7] != 1} {
    error "processing_system7_0 cell not found in the block design"
}

set_property -dict [list \
    CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_UART1_UART1_IO {MIO 48 .. 49} \
    CONFIG.PCW_UART0_PERIPHERAL_ENABLE {0} \
] $ps7

validate_bd_design
save_bd_design

# Both UARTs share the same reference clock; report it so the software
# divisor in sw/ps_uart_print/main.c can be double-checked (expects 100).
set act [get_property CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ $ps7]
puts "SWITCH-PS-UART1 UART1 on MIO 48/49 enabled (UART0 off), ref clock = $act MHz"

generate_target all [get_files design_1.bd]

# Re-export the XSA. impl_1 results are stale-but-valid (PL unchanged);
# open the existing run so write_hw_platform has a netlist/bitstream.
if {[catch {open_run impl_1} run_msg]} {
    puts "SWITCH-PS-UART1 WARN open_run impl_1 failed: $run_msg"
    puts "SWITCH-PS-UART1 WARN export the XSA later via build/export_xsa.tcl"
} else {
    write_hw_platform -fixed -include_bit -force \
        [file join $project_root build export design_1.xsa]
    puts "SWITCH-PS-UART1 XSA re-exported: build/export/design_1.xsa"
}
puts "SWITCH-PS-UART1 DONE"
