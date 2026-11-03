# Synchronize version-controlled sources into the existing Vivado project.
# Usage: vivado -mode batch -source build/update_project.tcl
#
# Version-controlled inputs:
#   src/rtl/*.v *.sv         RTL         -> sources_1
#   sim/*.v *.sv             testbenches -> sim_1
#   board/constraints/*.xdc  constraints -> constrs_1
#
# The block design lives at build/vivado/hand_motion_reconstruction.srcs/
# sources_1/bd/design_1 (tracked in git via .gitignore exceptions). Its
# managed-IP .xci files are referenced with paths relative to that
# location, so the BD must stay there; this script only ensures the
# project references that canonical copy. The design top is the BD itself
# (design_1), so no HDL wrapper is needed.

set project_root [file normalize [file join [file dirname [info script]] ..]]
set project_file [file join $project_root build vivado hand_motion_reconstruction.xpr]

if {![file exists $project_file]} {
    error "Project does not exist: $project_file"
}

open_project $project_file

# A relocated simulation view and a removed module_ref revision were left
# as direct project inputs. Remove only missing views and the known retired
# checkpoint; current generated IP checkpoints remain Vivado-managed.
foreach f [get_files -all -quiet] {
    if {![file exists $f] &&
        ([file extension $f] eq ".wcfg" ||
         [file tail $f] eq "design_1_emg_pl_export_0_4.dcp")} {
        puts "Removing obsolete project reference: $f"
        remove_files [list $f]
    }
}
set sim_view [get_property XSIM.VIEW [get_filesets sim_1]]
if {$sim_view ne "" && ![file exists $sim_view]} {
    set_property XSIM.VIEW {} [get_filesets sim_1]
}

# Drop the stale incremental-synthesis checkpoint inherited from the
# original project (utils_1/imports/synth_1/ads1299_spi.dcp): it no
# longer matches this design and only triggers Synth 8-6895 while
# synthesis falls back to the default flow anyway.
catch { set_property INCREMENTAL_CHECKPOINT {} [get_runs synth_1] }

set rtl_files [glob -nocomplain -directory [file join $project_root src rtl] -types f *.v *.sv *.vh]
set_property include_dirs [list [file join $project_root src rtl]] [get_filesets sources_1]
set_property include_dirs [list [file join $project_root src rtl]] [get_filesets sim_1]
set sim_files [glob -nocomplain -directory [file join $project_root sim] -types f *.v *.sv]
set xdc_files [glob -nocomplain -directory [file join $project_root board constraints] -types f *.xdc]

foreach {fileset candidates} [list sources_1 $rtl_files sim_1 $sim_files constrs_1 $xdc_files] {
    foreach candidate $candidates {
        if {![llength [get_files -quiet -of_objects [get_filesets $fileset] $candidate]]} {
            add_files -norecurse -fileset $fileset [list $candidate]
        }
    }
}

# The clock-group declaration references clk_fpga_0, which is created by
# the PS7 IP constraints and does not exist while synthesis parses the
# user XDCs; keep that file implementation-only to avoid the lookup
# critical warning during synthesis.
set cg_files [get_files -quiet -of [get_filesets constrs_1] *clock_groups*.xdc]
if {[llength $cg_files] > 0} {
    set_property USED_IN_SYNTHESIS false $cg_files
}
set lcd_timing [get_files -quiet *hz_zynq_lcd_timing.xdc]
set_property USED_IN_SYNTHESIS false $lcd_timing
set_property USED_IN_IMPLEMENTATION true $lcd_timing
set_property PROCESSING_ORDER LATE $lcd_timing
set hdmi_timing [get_files -quiet *hz_zynq_hdmi_timing.xdc]
if {[llength $hdmi_timing]} {
    set_property USED_IN_SYNTHESIS false $hdmi_timing
    set_property USED_IN_IMPLEMENTATION true $hdmi_timing
    set_property PROCESSING_ORDER LATE $hdmi_timing
}

# Keep exactly one BD in the project: the canonical in-project copy.
set canonical_bd [file normalize [file join $project_root build vivado \
    hand_motion_reconstruction.srcs sources_1 bd design_1 design_1.bd]]
set have_canonical 0
foreach bd [get_files -quiet *.bd] {
    if {[file normalize $bd] eq $canonical_bd} {
        set have_canonical 1
    } else {
        puts "Removing non-canonical BD reference: $bd"
        # Wrap single paths in [list]: add_files/remove_files parse their
        # argument as a Tcl file list, so a bare path containing spaces
        # gets split at spaces (Vivado error 12-172).
        if {[catch {remove_files [list $bd]} msg]} {
            puts "  remove_files failed: $msg"
        }
    }
}
if {!$have_canonical && [file exists $canonical_bd]} {
    add_files -norecurse -fileset sources_1 [list $canonical_bd]
}

set_property top design_1 [get_filesets sources_1]
set_property top ads1299_functional_tb [get_filesets sim_1]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
# Note: Vivado 2025.2 removed save_project; project commands (add_files,
# remove_files, set_property, ...) persist to the .xpr immediately.
close_project

puts "Updated project: $project_file"

