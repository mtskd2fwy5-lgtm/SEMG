# Diagnose AND force-fix the emg_pl_export module_ref refresh problem.
#
# Known facts at this point:
#   - src/rtl/emg_pl_export.v on disk HAS the reconfig_n port (verified).
#   - Only one module emg_pl_export exists project-wide.
#   - validate -force / update_module_reference / restart / delete+create /
#     XCI+snapshot purge ALL left the cell without reconfig_n.
#
# This script prints what Vivado actually sees (file content, index state,
# cell pin set) and then force-reindexes the file and rebuilds the cell.
#
# Run: source D:/FPGA/sEMG-HMRS/build/scripts/diag_rebuild_emg.tcl

set path D:/FPGA/sEMG-HMRS/src/rtl/emg_pl_export.v

set project_root [file normalize [file join [file dirname [info script]] .. ..]]
set owned 0
if {[llength [get_projects -quiet hand_motion_reconstruction]] == 0} {
    open_project [file join $project_root build vivado hand_motion_reconstruction.xpr]
    set owned 1
}
if {[llength [get_bd_designs -quiet design_1]] == 0} {
    open_bd_design [get_files design_1.bd]
}

# A) What does Vivado's Tcl see in the file itself?
set fp [open $path r]
set data [read $fp]
close $fp
puts "DIAG-A vivado-reads-file: [expr {[string first reconfig_n $data] >= 0 ? "HAS reconfig_n" : "LACKS reconfig_n"}] (bytes [string length $data])"

# B) Project index state for that file.
set f [get_files -quiet */emg_pl_export.v]
if {[llength $f] != 0} {
    puts "DIAG-B file-object: $f"
    foreach p {FILE_TYPE USED_IN_SYNTHESIS USED_IN_SIMULATION FILE_TIMESTAMP} {
        if {[catch {puts "DIAG-B   $p = [get_property $p $f]"}]} {
            puts "DIAG-B   $p = <n/a>"
        }
    }
} else {
    puts "DIAG-B file NOT in project filesets!"
}
puts "DIAG-B disk mtime  = [clock format [file mtime $path]]"

# C) Current cell state (may have been deleted by a prior run).
puts "DIAG-C cell count  = [llength [get_bd_cells -quiet emg_pl_export_0]]"
puts "DIAG-C pin set     = [get_bd_pins -quiet emg_pl_export_0/*]"

# D) Force re-index: bump mtime, remove the file from the project, re-add it.
set fh [open $path a]
close $fh
if {[llength $f] != 0} {
    catch {remove_files $f}
}
add_files -fileset sources_1 $path
update_compile_order -fileset sources_1
puts "DIAG-D file re-indexed (remove+add+update_compile_order)"

# D2) Purge the module_ref internal IP snapshot - THE actual culprit.
#     .gen/sources_1/bd/mref/<mod>/component.xml is what create_bd_cell
#     -type module -reference consults; it kept the pre-reconfig_n port
#     list through every other refresh attempt.
set mrefdir [file join $project_root build vivado hand_motion_reconstruction.gen sources_1 bd mref emg_pl_export]
if {[file exists $mrefdir]} {
    if {[catch {file delete -force $mrefdir} derr]} {
        puts "DIAG-D2 FAILED to purge mref snapshot ($derr)"
        puts "DIAG-D2 close Vivado, delete it manually, reopen, rerun this script:"
        puts "DIAG-D2   $mrefdir"
        error "DIAG-D2 mref snapshot locked"
    }
    puts "DIAG-D2 purged mref snapshot"
} else {
    puts "DIAG-D2 mref snapshot already absent"
}

# D3) Upgrade restricted module_ref IP revisions. When the module source
#     changes, Vivado re-packages it under a NEW revision and marks the old
#     one restricted (IP_Flow 19-3571); the BD cell keeps the old one until
#     an explicit upgrade runs.
puts "DIAG-D3 ip status before upgrade:"
if {[catch {report_ip_status}]} {
    puts "DIAG-D3 report_ip_status unavailable"
}
foreach ip [get_ips -quiet *emg_pl_export*] {
    if {[catch {upgrade_ip $ip} uerr]} {
        puts "DIAG-D3 upgrade_ip failed for $ip: $uerr"
    } else {
        puts "DIAG-D3 upgraded $ip"
    }
}

# E) Force rebuild of the cell: a pre-existing cell keeps its stale pin set
#    even after the source file was re-indexed in step D.
if {[llength [get_bd_cells -quiet emg_pl_export_0]] != 0} {
    delete_bd_objs [get_bd_cells emg_pl_export_0]
}
create_bd_cell -type module -reference emg_pl_export emg_pl_export_0
set newpins [get_bd_pins -quiet emg_pl_export_0/*]
puts "DIAG-E pin set now = $newpins"

if {[llength [get_bd_pins -quiet emg_pl_export_0/reconfig_n]] == 0} {
    error "DIAG: still no reconfig_n - paste the DIAG output above"
}

# F) Success: re-wire everything (idempotent, XDC-stable port names).
connect_bd_net [get_bd_ports pl_clk_0]      [get_bd_pins emg_pl_export_0/pl_clk]
connect_bd_net [get_bd_ports pl_rst_n_0]    [get_bd_pins emg_pl_export_0/pl_rst_n]
connect_bd_net [get_bd_ports adc_drdy_n_0]  [get_bd_pins emg_pl_export_0/adc_drdy_n]
connect_bd_net [get_bd_ports adc_dout_0]    [get_bd_pins emg_pl_export_0/adc_dout]
connect_bd_net [get_bd_ports adc_sclk_0]    [get_bd_pins emg_pl_export_0/adc_sclk]
connect_bd_net [get_bd_ports adc_din_0]     [get_bd_pins emg_pl_export_0/adc_din]
connect_bd_net [get_bd_ports adc_cs_n_0]    [get_bd_pins emg_pl_export_0/adc_cs_n]
connect_bd_net [get_bd_ports adc_start_0]   [get_bd_pins emg_pl_export_0/adc_start]
connect_bd_net [get_bd_ports adc_reset_n_0] [get_bd_pins emg_pl_export_0/adc_reset_n]
connect_bd_net [get_bd_ports adc_pwdn_n_0]  [get_bd_pins emg_pl_export_0/adc_pwdn_n]
connect_bd_net [get_bd_ports status_led_0]  [get_bd_pins emg_pl_export_0/status_led]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0]   [get_bd_pins emg_pl_export_0/axis_clk]
connect_bd_net [get_bd_pins axi_dma_0/s2mm_prmry_reset_out_n] [get_bd_pins emg_pl_export_0/axis_rst_n]
connect_bd_intf_net [get_bd_intf_pins emg_pl_export_0/m_axis] [get_bd_intf_pins axi_dma_0/S_AXIS_S2MM]
if {[llength [get_bd_ports -quiet reconfig_n_0]] == 0} {
    create_bd_port -dir I reconfig_n_0
}
connect_bd_net [get_bd_ports reconfig_n_0] [get_bd_pins emg_pl_export_0/reconfig_n]

validate_bd_design
save_bd_design
save_project
puts "DONE: emg_pl_export_0 rebuilt; reconfig_n wired to external port reconfig_n_0"
if {$owned} {
    close_project
}
