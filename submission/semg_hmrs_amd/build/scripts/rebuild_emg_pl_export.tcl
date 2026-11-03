# Rebuild emg_pl_export_0 (v2): purge the stale IP snapshots first.
#
# Root cause: Vivado identifies a module_ref cell's ports from its generated
# snapshot (.gen .../design_1_emg_pl_export_0_0_stub.v + component XML with
# x_ipCoreRevision=1), NOT from a fresh elaboration of src/rtl/emg_pl_export.v.
# The snapshot predates the reconfig_n port, so validate_bd_design -force,
# update_module_reference, a Vivado restart AND delete+create_bd_cell all
# reused it. Fix: drop the cell, remove the XCI from the project, wipe the
# .srcs and .gen snapshot directories, then re-add the cell.
#
# All external ports keep their XDC-bound names (adc_*_0, pl_clk_0, ...,
# reconfig_n_0 per hz_zynq_ads1299_bd.xdc). Internal wiring restored:
#   axis_clk   <- PS7 FCLK_CLK0
#   axis_rst_n <- axi_dma_0/s2mm_prmry_reset_out_n
#   m_axis     -> axi_dma_0/S_AXIS_S2MM
# raw/feature/result_overflow are left unconnected, as before.
#
# Run (Vivado Tcl console or batch):
#   source ./build/scripts/rebuild_emg_pl_export.tcl

set project_root [file normalize [file join [file dirname [info script]] .. ..]]
set owned 0
if {[llength [get_projects -quiet hand_motion_reconstruction]] == 0} {
    open_project [file join $project_root build vivado hand_motion_reconstruction.xpr]
    set owned 1
}
if {[llength [get_bd_designs -quiet design_1]] == 0} {
    open_bd_design [get_files design_1.bd]
}

if {[llength [get_bd_pins -quiet emg_pl_export_0/reconfig_n]] != 0} {
    puts "rebuild: reconfig_n already present on emg_pl_export_0 - skipping rebuild"
} else {
    # 1) Drop the cell if it exists (it may already be gone from a prior run).
    if {[llength [get_bd_cells -quiet emg_pl_export_0]] != 0} {
        delete_bd_objs [get_bd_cells emg_pl_export_0]
    }

    # 2) Remove the stale XCI from the project and wipe both snapshot dirs.
    set xci [get_files -quiet */design_1_emg_pl_export_0_0.xci]
    if {[llength $xci] != 0} {
        remove_files $xci
        puts "rebuild: removed XCI from project"
    }
    foreach d [list \
            [file join $project_root build vivado hand_motion_reconstruction.srcs sources_1 bd design_1 ip design_1_emg_pl_export_0_0] \
            [file join $project_root build vivado hand_motion_reconstruction.gen sources_1 bd design_1 ip design_1_emg_pl_export_0_0]] {
        if {[file exists $d]} {
            file delete -force $d
            puts "rebuild: wiped [file tail [file dirname $d]]"
        }
    }

    # 3) Re-add from source; with no snapshots left this elaborates fresh.
    create_bd_cell -type module -reference emg_pl_export emg_pl_export_0

    if {[llength [get_bd_pins -quiet emg_pl_export_0/reconfig_n]] == 0} {
        error "rebuild: emg_pl_export_0 still has no reconfig_n pin after snapshot purge"
    }

    # 4) Re-wire everything (external port names stay XDC-stable).
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

    # New button input; port name matches hz_zynq_ads1299_bd.xdc.
    if {[llength [get_bd_ports -quiet reconfig_n_0]] == 0} {
        create_bd_port -dir I reconfig_n_0
    }
    connect_bd_net [get_bd_ports reconfig_n_0] [get_bd_pins emg_pl_export_0/reconfig_n]

    validate_bd_design
    save_bd_design
    puts "rebuild: emg_pl_export_0 rebuilt; reconfig_n wired to external port reconfig_n_0"
}
if {$owned} {
    close_project
}

