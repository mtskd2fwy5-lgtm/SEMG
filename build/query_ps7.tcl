# Query effective PS7 configuration values (including defaults).
set root "D:/FPGA/Hand Motion Reconstruction System Using sEMG"
open_project "$root/build/vivado/hand_motion_reconstruction.xpr"
open_bd_design "$root/build/vivado/hand_motion_reconstruction.srcs/sources_1/bd/design_1/design_1.bd"

set ps7 [get_bd_cells processing_system7_0]
foreach p {PCW_UIPARAM_DDR_PARTNO PCW_UIPARAM_DDR_MEMORY_TYPE \
           PCW_UIPARAM_DDR_BUS_WIDTH PCW_DDR_RAM_HIGHADDR \
           PCW_UIPARAM_DDR_FREQ_MHZ PCW_UIPARAM_DDR_CL \
           PCW_UIPARAM_DDR_BANK_ADDR_COUNT PCW_UIPARAM_DDR_ROW_ADDR_COUNT \
           PCW_UIPARAM_DDR_COL_ADDR_COUNT \
           PCW_PS_CLK_FREQ PCW_UART0_PERIPHERAL_ENABLE PCW_UART0_UART0_IO \
           PCW_UART1_PERIPHERAL_ENABLE PCW_QSPI_PERIPHERAL_ENABLE \
           PCW_ENET0_PERIPHERAL_ENABLE PCW_SD0_PERIPHERAL_ENABLE \
           PCW_USB0_PERIPHERAL_ENABLE PCW_TTC0_PERIPHERAL_ENABLE} {
    puts "PS7 $p = [get_property CONFIG.$p $ps7]"
}
close_project
puts "PS7-QUERY DONE"
