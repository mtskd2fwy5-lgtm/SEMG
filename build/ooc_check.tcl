# Re-synthesize ONLY the emg_pl_export module_ref OOC run after an RTL
# change, so a coefficient/parameter fix can be verified in minutes
# instead of a full ~13-minute check_design.tcl build. Derived from
# check_design.tcl (same source-sync + BD revalidate + run reset, but
# launches just the OOC synth run and stops).
#
# Usage: vivado -mode batch -source build/ooc_check.tcl
# Success marker: "OOC CHECK COMPLETE".
#
# NOTE: module_ref OOC runs are BD-scoped and RENAME when upgrade_ip
# resets the IP generation (observed 2026-10-08: the
# design_1_emg_pl_export_0_4_synth_1 run vanished after upgrade_ip and
# was not visible project-level). The run is therefore located by
# pattern WITH THE BD STILL OPEN, never by a hardcoded generation index.

set script_dir [file dirname [info script]]
set project_root [file normalize [file join $script_dir ..]]
set project_file [file join $project_root build vivado hand_motion_reconstruction.xpr]

# Phase 1 of check_design.tcl: sync version-controlled sources.
source [file join $project_root build update_project.tcl]

open_project $project_file

# Same defensive BD re-validation as check_design.tcl: module_ref content
# changes require re-binding before launch_runs (filemgmt 56-587).
# upgrade_ip refreshes the module_ref IP parameter model: a changed
# parameter DECLARATION (signed [17:0] -> integer, the wrapper-quoting
# fix) is not picked up by validate_bd_design alone - same class as
# port-list changes needing an IP revision bump.
set bd_file [get_files -quiet -of [get_filesets sources_1] design_1.bd]
if {[llength $bd_file] > 0} {
    open_bd_design [lindex $bd_file 0]
    catch { upgrade_ip [get_ips -quiet *emg_pl_export*] }
    validate_bd_design -force
    save_bd_design
    generate_target -force all [get_files design_1.bd]

    # Locate the OOC synth run by pattern while the BD is open.
    set oocruns [get_runs -quiet design_1_emg_pl_export*synth_1]
    puts "OOC RUNS FOUND: $oocruns"
    if {[llength $oocruns] == 0} {
        error "no emg_pl_export OOC synth run visible with BD open"
    }
    set oocrun [lindex $oocruns 0]
    catch { reset_run $oocrun }
    launch_runs $oocrun -jobs 8
    wait_on_run $oocrun
    puts "OOC STATUS  : [get_property STATUS $oocrun]"
    puts "OOC PROGRESS: [get_property PROGRESS $oocrun]"
    close_bd_design [current_bd_design]
}

close_project
puts "OOC CHECK COMPLETE"
