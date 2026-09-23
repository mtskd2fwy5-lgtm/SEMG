# Match PS7 configuration to the HZ-ZYNQ_CV01 core board hardware.
#
# Usage: vivado -mode batch -source build/fix_ps7_board_config.tcl
#
# Verified against vendor documentation (D:\FPGA\合众恒跃):
#   - Core board spec: XC7Z020-2CLG400I, 1GB DDR3, PS_CLK 33.333 MHz
#   - Core board schematic p7: two x16 DDR3 chips, 32-bit bus,
#     A[14:0] row addressing -> MT41K256M16 class, 2x512MB = 1GB
#   - Vendor reference project (HZ_B2B_7z010_DDR_1G_lwip) uses
#     PCW_UIPARAM_DDR_PARTNO = MT41K256M16 RE-125, HIGHADDR 0x3FFFFFFF
#   - Core board pin table: MIO1=QSPI CS, MIO2..5=QSPI IO0..3, MIO6=SCLK
#     -> QSPI on MIO 1 .. 6 (same as vendor project)
#
# The old preset (Vivado default MT41J128M8 JP-125, 512MB, x8, 14 row
# address bits) does not match the board's 2 x16, 15-row-address wiring:
# only half of the DDR rows would be addressed and the timings would be
# for the wrong die class. This matters as soon as PS software touches
# DDR (PetaLinux, bare-metal apps linked to 0x100000).

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
    CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41K256M16 RE-125} \
    CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_QSPI_QSPI_IO {MIO 1 .. 6} \
    CONFIG.PCW_UART0_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_UART0_UART0_IO {MIO 14 .. 15} \
] $ps7

validate_bd_design
save_bd_design

# Report the effective values for the build log.
foreach p {PCW_UIPARAM_DDR_PARTNO PCW_DDR_RAM_HIGHADDR \
           PCW_UIPARAM_DDR_ROW_ADDR_COUNT PCW_UIPARAM_DDR_BUS_WIDTH \
           PCW_QSPI_PERIPHERAL_ENABLE PCW_QSPI_QSPI_IO \
           PCW_UART0_PERIPHERAL_ENABLE PCW_UART0_UART0_IO} {
    puts "FIX-PS7 $p = [get_property CONFIG.$p $ps7]"
}

generate_target all [get_files design_1.bd]
close_project
puts "FIX-PS7 DONE"
