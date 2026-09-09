# Enable PS UART1 on MIO 48/49 in the design_1 block design.
#
# Usage: vivado -mode batch -source build/enable_ps_uart.tcl
#
# The PS7 preset in the existing BD has no UART routed to MIO pins
# (PCW_UART1_PERIPHERAL_ENABLE=0), so nothing can be printed from the PS.
# This script flips the PS7 configuration to UART1 on MIO 48/49
# (the usual USB-to-UART bridge position on Zynq-7000 carrier boards,
# 115200-8N1) and regenerates the BD outputs so the next check_design
# run picks up the change.
#
# NOTE: verify MIO 48/49 against the actual carrier-board schematic; if
# the board wires the UART elsewhere (e.g. UART0 on MIO 14/15), change
# the CONFIG values below accordingly.

set project_root [file normalize [file join [file dirname [info script]] ..]]
set project_file [file join $project_root build vivado hand_motion_reconstruction.xpr]
set bd_file [file join $project_root build vivado hand_motion_reconstruction.srcs \
    sources_1 bd design_1 design_1.bd]

if {![file exists $bd_file]} {
    error "Block design not found: $bd_file"
}

open_project $project_file
open_bd_design $bd_file

set ps7 [get_bd_cells processing_system7_0]
if {[llength $ps7] != 1} {
    error "processing_system7_0 cell not found in the block design"
}

set_property -dict [list \
    CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_UART1_UART1_IO {MIO 48 .. 49} \
] $ps7

validate_bd_design
save_bd_design

# Report the UART reference clock the PS7 wizard computed, so the
# software baud divisor can be double-checked.
set act [get_property CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ $ps7]
puts "ENABLE-PS-UART UART1 on MIO 48/49 enabled, ref clock = $act MHz"

generate_target all [get_files design_1.bd]
close_project
puts "ENABLE-PS-UART DONE"
