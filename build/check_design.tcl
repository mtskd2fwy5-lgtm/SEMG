# Full-system implementation check: design_1 (PS7 + AXI DMA + SmartConnect
# + emg_pl_export SPI/filter/feature signal chain) through bitstream.
#
# Usage: vivado -mode batch -source build/check_design.tcl
#
# Phase 1 synchronizes version-controlled sources into the project via
# update_project.tcl. Phase 2 enables the BD constraints, resets the runs
# and takes the design through write_bitstream, then exports the hardware
# platform (XSA with bitstream) for bare-metal software.
# Timing / utilization / DRC reports land in the usual impl_1 directory.

set script_dir [file dirname [info script]]
set project_root [file normalize [file join $script_dir ..]]
set project_file [file join $project_root build vivado hand_motion_reconstruction.xpr]
set export_dir [file join $project_root build export]
file mkdir $export_dir

# ---- Phase 1: sync versioned sources into the project --------------------
source [file join $script_dir update_project.tcl]

# ---- Phase 2: configure, implement, export ---------------------------------
open_project $project_file

# hz_zynq_ads1299.xdc targets hand_motion_top ports (clk/rst_n) that do
# not exist on design_1; the _bd file carries the correct _0-suffixed
# port names.
set_property IS_ENABLED false [get_files hz_zynq_ads1299.xdc]
set_property IS_ENABLED true  [get_files hz_zynq_ads1299_bd.xdc]

# Reset every run (top synth/impl plus out-of-context IP synth runs) so
# leftovers from a killed parent process cannot wedge the launch.
foreach run [get_runs] {
    catch { reset_run $run }
}
launch_runs impl_1 -to_step write_bitstream -jobs 8
wait_on_run impl_1

puts "CHECK synth_1  STATUS  : [get_property STATUS [get_runs synth_1]]"
puts "CHECK impl_1   STATUS  : [get_property STATUS [get_runs impl_1]]"
puts "CHECK impl_1   PROGRESS: [get_property PROGRESS [get_runs impl_1]]"

# Hardware platform export (XSA includes the bitstream and, for Zynq-7000,
# the ps7_init files used by the bare-metal download flow). The run must
# be opened in memory first: without open_run the export fails with
# "No IPI block design hardware handoff files present".
open_run impl_1
write_hw_platform -fixed -include_bit -force \
    [file join $export_dir design_1.xsa]

close_project
puts "CHECK COMPLETE"
