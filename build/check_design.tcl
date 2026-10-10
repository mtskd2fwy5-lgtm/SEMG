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

# Re-validate the BD before launching runs: when a module_ref module's
# internals change (e.g. emg_pl_export gaining the NN instance), the module
# definition cached in the XCI goes stale and launch_runs dies with
# [filemgmt 56-587] "Nothing was found ... to match the name emg_pl_export".
# validate_bd_design re-binds the reference (same as build/fix_bd_refs.tcl).
set bd_file [get_files -quiet -of [get_filesets sources_1] design_1.bd]
if {[llength $bd_file] > 0} {
    # Re-enable RTL sources Vivado auto-disabled (AutoDisabled=1 removes the
    # module from elaboration, so module_ref blocks die with [filemgmt
    # 56-587]; seen on lcd_clk_fwd after the 2026-10-09 cleanup).  A disabled
    # RTL source is never intentional; disabled XDCs are left alone.
    foreach f [get_files -quiet -of [get_filesets sources_1]] {
        if {([string match *.v $f] || [string match *.sv $f]) &&
            ![get_property IS_ENABLED $f]} {
            set_property IS_ENABLED true $f
            puts "REBIND: re-enabled auto-disabled RTL source $f"
        }
    }
    # Rebind compile order first: if the project was touched by cleanup or
    # a new session, module_ref sources can drop out of the compile order
    # and validate/launch die with [filemgmt 56-587] (e.g. lcd_clk_fwd,
    # 2026-10-09).  Automatic order re-discovers every src/rtl module.
    update_compile_order -fileset sources_1
    open_bd_design [lindex $bd_file 0]
    validate_bd_design -force
    save_bd_design
    generate_target all [get_files design_1.bd]
    close_bd_design [current_bd_design]
}

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
