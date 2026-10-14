# debug_ila_lcd.tcl v5 - LCD bring-up ILA (white-screen root-cause hunt).
#
# Flow = open_run synth_1 -> resolve every probed net through pin/net
# ladders -> create debug cores -> write_checkpoint -> reopen ->
# implement_debug_core -> probes.ltx -> place/route -> bitstream.
# NO BD changes, NO re-synthesis.  Run OUTSIDE the TRAE sandbox:
#   vivado -mode batch -source build/debug_ila_lcd.tcl \
#          -log build/debug_ila_lcd.log -jou build/debug_ila_lcd.jou
# Output: impl_1/design_1_wrapper_debug.bit + build/lcd_debug_probes.ltx
# Package with build\boot\boot_image_debug_ila.bif -> BOOT_DEBUG_ILA.BIN.
#
# Cores (all created here):
#   u_ila_g50  @ FCLK_CLK1 : probe0 id_pins (>=3 bits), probe1 mmcm_locked,
#                            probe2 id_reg[15:0], probe3 {id_settled,id_valid}
#   u_ila_pclk @ lcd_pclk  : probe0 hcnt[11:0], probe1 vcnt[11:0],
#                            probe2 {sel4384_sync,sel4384_meta},
#                            probe3 SYNC_INST FSM_onehot_state[0:12] (13/13
#                            all-or-nothing), probe4 {locked, first_sof,
#                            vid_io_out_reset} (subset that resolves)
#   u_ila_axis @ FCLK_CLK0 : probe0 {s_axis_video_tvalid, tready, tuser},
#                            probe1 s_axis_video_tdata[23:0] (optional),
#                            probe2 {m_axi_mm2s_arvalid, arready, rvalid,
#                            rlast} subset
#
# v5 (2026-10-13): add the AXI read channel to u_ila_axis (same FCLK_CLK0
# domain): probe2 {m_axi_mm2s_arvalid, arready, rvalid, rlast} - verdict tree
# for the VDMA "SR busy, FRMCNT parked at 1, TVALID hard-0" deadlock:
#   arvalid=0            -> VDMA never issues the read (internal FSM stall)
#   arready=0            -> smartconnect_1/HP0 refuses the read
#   rvalid=0 (AR done)   -> HP0/DDR read data never returns
#   rvalid=1, tvalid=0   -> VDMA stream-side gating dead
# Board CR experiment (v5 prep): CR bit3 (GenlockEn) is NOT writable on this
# IP config (wrote 0xB, read back 0x10003) -> genlock unconfigured, CR ruled
# out; the deadlock lives in the AXI-read path or the IP's internal FSM.
#
# v6 (2026-10-13): add u_ila_vdma @ FCLK_CLK0 - bisect the VDMA internal
# command chain (synth netlist recon 2026-10-13, all nets verified to exist
# and be logic-driven, not constants):
#   p0  U0/s_axis_mm2s_cmd_tvalid        VDMA cmd FSM -> DataMover cmd stream
#   p1  U0/I_CMDSTS/s_axis_cmd_tvalid0   cmd into DataMover cmd FIFO
#   p2  U0/mm2s_cmdsts_idle              DataMover idle flag
#   p3  U0/mm2s_dm_prmry_resetn          DataMover primary resetn (SUSPECT)
#   p4  U0/mm2s_prmry_resetn             MM2S engine resetn
#   p5  U0/mm2s_axis_resetn              AXIS-side resetn
#   p6  U0/mm2s_soft_reset               DMACR bit2 (dmacr_i_reg[2] net)
#   p7  U0/sof_reset                     SOF reset (xpm_fifo_sync_inst_i_1)
#   p8  I_DMA_REGISTER/mm2s_dmacr[0]     engine-domain RS mirror (CDC proof)
#   p9  I_MM2S_FULL_WRAPPER/m_axi_mm2s_arvalid  AR generation source
#   p10 U0/axi_resetn                    external reset reference
# Verdict tree for "RS=1 lite-side, SR busy, ARVALID hard-0":
#   p8=0                      -> register CDC broken (lite->engine never lands)
#   p8=1, any of p3/p4/p6=0   -> I_RST_MODULE internal reset stuck low
#   p8=1, resets ok, p0=0     -> DMA_MNGR command FSM never issues a command
#   p0=1, p9=0                -> DataMover stalls (cmd FIFO full / internal)
#   p9=1                      -> AR actually generated (contradicts v5: recheck)
#
# v4 lesson: probe nets are resolved from the spliced netlist by pin->net
# ladders that do NOT depend on MARK_DEBUG surviving synthesis (v2: all four
# adapter BUSES came back empty from the OOC-dcp splice).  Optional nets are
# dropped (logged) rather than failing the run; mandatory nets error out.
#   S1  exact net name        <prefix>/<leaf>[i] or <prefix>/<pin>
#   S2  exact FF cell name    <prefix>/<leaf>_reg[i] -> Q net
#   S2b IOBUF cell O pin      g_rgb_iobuf[i]* -> O net            (id_pins)
#   S3  one wildcard scan per leaf + local exact-index regexp match
#
# Probe bit order: ascending resolved index (probe[k] = listed bit k).

set script_dir [file dirname [file normalize [info script]]]
set proj_root  [file normalize [file join $script_dir ..]]
set xpr        [file join $proj_root build vivado hand_motion_reconstruction.xpr]
set ad_prefix  {lcd_panel_adapter_0}
set vo_prefix  {v_axi4s_vid_out_0}
set vd_prefix  {axi_vdma_0}

proc safe_name {o} { if {[catch {get_property NAME $o} n]} { return {?} } ; return $n }
proc name_list {objs} { set out {} ; foreach o $objs { lappend out [safe_name $o] } ; return $out }

# Q-pin net of an FF cell ({} if the cell has no Q or the net is gone)
proc q_net_of_cell {c} {
    set q [get_pins -quiet -of_objects $c -filter {REF_PIN_NAME == Q && DIRECTION == OUT}]
    if {[llength $q] == 0} { return {} }
    set nn [get_nets -quiet -of_objects [lindex $q 0]]
    if {[llength $nn] == 0} { return {} }
    return [lindex $nn 0]
}

# ---- bus resolution ladder: returns width slots, {} where unresolved ----
proc resolve_bus {leaf width prefix need_idx} {
    set slots {}
    for {set i 0} {$i < $width} {incr i} { lappend slots {} }

    # S1: exact RTL net name (best-effort; S3 is the catch-all)
    for {set i 0} {$i < $width} {incr i} {
        set o [get_nets -quiet "$prefix/${leaf}\[$i\]"]
        if {[llength $o]} { lset slots $i [lindex $o 0] }
    }
    # S2: exact FF cell name -> Q net (regs synthesize to <leaf>_reg[i])
    for {set i 0} {$i < $width} {incr i} {
        if {[lindex $slots $i] ne {}} continue
        set c [get_cells -quiet "$prefix/${leaf}_reg\[$i\]"]
        if {[llength $c]} {
            set nq [q_net_of_cell [lindex $c 0]]
            if {$nq ne {}} { lset slots $i $nq }
        }
    }
    # one catch-all scan per leaf (filter globs carry no brackets)
    set iobuf_cand {}
    if {$leaf eq "id_pins"} {
        set iobuf_cand [get_cells -quiet -hier -filter {NAME =~ */g_rgb_iobuf*}]
    }
    set cell_cand [get_cells -quiet -hier -filter "NAME =~ */${leaf}_reg*"]
    set net_cand  [get_nets  -quiet -hier -filter "NAME =~ */${leaf}*"]
    for {set i 0} {$i < $width} {incr i} {
        if {[lindex $slots $i] ne {}} continue
        # S2b: IOBUF readback O pin (id_pins)
        # (v3.1 lesson: patterns built via format+braces; a "\[" inside Tcl
        #  double quotes parses as backslash + command substitution and aborts)
        set iopat [format {/g_rgb_iobuf\[%d\]} $i]
        foreach c $iobuf_cand {
            if {![regexp $iopat [safe_name $c]]} continue
            set op [get_pins -quiet -of_objects $c -filter {REF_PIN_NAME == O && DIRECTION == OUT}]
            if {[llength $op]} {
                set nn [get_nets -quiet -of_objects [lindex $op 0]]
                if {[llength $nn]} { lset slots $i [lindex $nn 0] ; break }
            }
        }
        if {[lindex $slots $i] ne {}} continue
        # S3a: FF cells by wildcard + exact index
        set cpat [format {/%s_reg\[([0-9]+)\]$} $leaf]
        foreach c $cell_cand {
            if {[regexp $cpat [safe_name $c] -> gi] && $gi == $i} {
                set nq [q_net_of_cell $c]
                if {$nq ne {}} { lset slots $i $nq ; break }
            }
        }
        if {[lindex $slots $i] ne {}} continue
        # S3b: nets by wildcard + exact index
        set npat [format {/%s\[([0-9]+)\]$} $leaf]
        foreach o $net_cand {
            if {[regexp $npat [safe_name $o] -> gi] && $gi == $i} {
                lset slots $i $o ; break
            }
        }
    }
    set missing {}
    for {set i 0} {$i < $width} {incr i} { if {[lindex $slots $i] eq {}} { lappend missing $i } }
    foreach ri $need_idx {
        if {[lsearch -exact $missing $ri] >= 0} {
            puts "DIAG ${leaf} nets  : [name_list $net_cand]"
            puts "DIAG ${leaf} cells  : [name_list $cell_cand]"
            puts "DIAG ${leaf} iobufs : [name_list $iobuf_cand]"
            error "RESOLVE-FAIL: ${leaf} missing mandatory bit $ri (missing: $missing)"
        }
    }
    if {[llength $missing] > 0} {
        puts "RESOLVE-PARTIAL ${leaf}: dropped unloaded bits $missing"
    }
    return $slots
}

proc resolve_scalar {leaf prefix} {
    set o [get_nets -quiet "$prefix/$leaf"]
    if {[llength $o]} { return [lindex $o 0] }
    set o [get_nets -quiet -hier -filter "NAME =~ */${leaf}*"]
    if {[llength $o]} { return [lindex $o 0] }
    set c [get_cells -quiet "$prefix/${leaf}_reg"]
    if {[llength $c]} {
        set nq [q_net_of_cell [lindex $c 0]]
        if {$nq ne {}} { return $nq }
    }
    error "RESOLVE-FAIL: scalar $leaf not found"
}

proc slot_nets {slots} {
    set out {}
    foreach s $slots { if {$s ne {}} { lappend out $s } }
    return $out
}
proc slot_indices {slots} {
    set out {} ; set i 0
    foreach s $slots { if {$s ne {}} { lappend out $i } ; incr i }
    return $out
}
proc tune_ila {c} {
    set_property C_TRIGIN_EN false $c
    set_property C_TRIGOUT_EN false $c
    set_property C_ADV_TRIGGER false $c
    set_property C_INPUT_PIPE_STAGES 0 $c
    set_property C_EN_STRG_QUAL false $c
    set_property ALL_PROBE_SAME_MU true $c
    set_property ALL_PROBE_SAME_MU_CNT 1 $c
}
# pin->net ladder for IP pins: S1 top-level pin, S2 inst pin, S3 any pin
# under the prefix ending in /<pin> (format+braces, no quoted "\[")
proc net_of_pin {pats} {
    foreach pat $pats {
        set pin [get_pins -quiet $pat]
        if {[llength $pin]} {
            set nn [get_nets -quiet -of_objects [lindex $pin 0]]
            if {[llength $nn]} { return [lindex $nn 0] }
        }
    }
    return {}
}
proc net_of_cell_q {cell_pat} {
    set c [get_cells -quiet $cell_pat]
    if {[llength $c]} { return [q_net_of_cell [lindex $c 0]] }
    return {}
}

if {[llength [get_projects -quiet hand_motion_reconstruction]] == 0} {
    open_project $xpr
}
catch {close_design}
open_run synth_1 -name synth_1

# ---- clocks via adapter port pins (v2-proven) ----
set n_g50 [get_nets -quiet -of_objects [get_pins -quiet ${ad_prefix}/clk50_in]]
if {[llength $n_g50] == 0} { error "CLK-FAIL: clk50_in net not found" }
puts "G50-CLK [name_list $n_g50]"
set n_pclk [get_nets -quiet -of_objects [get_pins -quiet ${ad_prefix}/lcd_pclk]]
if {[llength $n_pclk] == 0} { error "CLK-FAIL: lcd_pclk net not found" }
puts "PCLK [name_list $n_pclk]"

# ---- resolve ALL probes BEFORE creating any core ----
set id_pins_slots [resolve_bus id_pins 24 $ad_prefix {7 15 23}]
set id_reg_slots  [resolve_bus id_reg  16 $ad_prefix {}]
set hcnt_slots    [resolve_bus hcnt    12 $ad_prefix {}]
set vcnt_slots    [resolve_bus vcnt    12 $ad_prefix {}]
set n_locked  [resolve_scalar mmcm_locked  $ad_prefix]
set n_settled [resolve_scalar id_settled   $ad_prefix]
set n_valid   [resolve_scalar id_valid     $ad_prefix]
set n_s4sync  [resolve_scalar sel4384_sync $ad_prefix]
set n_s4meta  [resolve_scalar sel4384_meta $ad_prefix]
puts "RESOLVE-OK id_pins bits=[slot_indices $id_pins_slots]"
puts "RESOLVE-OK id_reg   bits=[slot_indices $id_reg_slots]"
puts "RESOLVE-OK hcnt     bits=[slot_indices $hcnt_slots]"
puts "RESOLVE-OK vcnt     bits=[slot_indices $vcnt_slots]"

# ---- v4: vid_out stream + FSM probes ----
set n_aclk [net_of_pin [list [format {%s/aclk} $vo_prefix] \
                             [format {%s/inst/aclk} $vo_prefix]]]
if {$n_aclk eq {}} { error "RESOLVE-FAIL: vid_out aclk net not found" }
puts "VO-ACLK $n_aclk"

set n_tvalid [net_of_pin [list [format {%s/s_axis_video_tvalid} $vo_prefix] \
                                [format {%s/inst/s_axis_video_tvalid} $vo_prefix]]]
set n_tready [net_of_pin [list [format {%s/s_axis_video_tready} $vo_prefix] \
                                [format {%s/inst/s_axis_video_tready} $vo_prefix]]]
set n_tuser  [net_of_pin [list [format {%s/s_axis_video_tuser} $vo_prefix] \
                                [format {%s/inst/s_axis_video_tuser} $vo_prefix]]]
if {$n_tvalid eq {} || $n_tready eq {} || $n_tuser eq {}} {
    error "RESOLVE-FAIL: axis handshake (tvalid=$n_tvalid tready=$n_tready tuser=$n_tuser)"
}
puts "RESOLVE-OK axis tvalid=$n_tvalid tready=$n_tready tuser=$n_tuser"

# tdata[23:0] optional (intf-net member names may not survive the splice)
set tdata_slots {}
for {set i 0} {$i < 24} {incr i} { lappend tdata_slots {} }
for {set i 0} {$i < 24} {incr i} {
    set nn [net_of_pin [list [format {%s/s_axis_video_tdata\[%d\]} $vo_prefix $i] \
                             [format {%s/inst/s_axis_video_tdata\[%d\]} $vo_prefix $i]]]
    if {$nn ne {}} { lset tdata_slots $i $nn }
}
set td_nets [slot_nets $tdata_slots]
if {[llength $td_nets] == 24} {
    puts "RESOLVE-OK axis tdata 24/24"
} else {
    puts "RESOLVE-PARTIAL axis tdata bits=[slot_indices $tdata_slots] (optional)"
}

# FSM_onehot_state[0:12] - all-or-nothing 13/13 (one-hot mapping must not shift)
set fsm_nets {}
set fsm_ok 1
for {set i 0} {$i < 13} {incr i} {
    set nn [net_of_cell_q [format {%s/inst/SYNC_INST/FSM_onehot_state_reg\[%d\]} $vo_prefix $i]]
    if {$nn eq {}} { set fsm_ok 0 ; break }
    lappend fsm_nets $nn
}
if {!$fsm_ok} {
    puts "RESOLVE-PARTIAL FSM_onehot: not 13/13, dropped (optional)"
    set fsm_nets {}
}

# locked / first_sof / vid_io_out_reset (optional individually)
set n_vlocked [net_of_pin [list [format {%s/inst/locked} $vo_prefix]]]
if {$n_vlocked eq {}} {
    set n_vlocked [net_of_cell_q [format {%s/inst/locked_from_sync_dly_reg} $vo_prefix]]
}
set n_firstsof [net_of_cell_q [format {%s/inst/first_sof_reg} $vo_prefix]]
set n_vidrst [net_of_pin [list [format {%s/vid_rst_out} $ad_prefix] \
                                [format {%s/inst/vid_rst_out} $ad_prefix]]]
puts "RESOLVE-OPT vlocked=$n_vlocked firstsof=$n_firstsof vidrst=$n_vidrst"

# ---- v5: VDMA MM2S AXI read channel (same FCLK_CLK0 domain as u_ila_axis) ----
set n_arvalid [net_of_pin [list [format {%s/m_axi_mm2s_arvalid} $vd_prefix] \
                                 [format {%s/inst/m_axi_mm2s_arvalid} $vd_prefix]]]
set n_arready [net_of_pin [list [format {%s/m_axi_mm2s_arready} $vd_prefix] \
                                 [format {%s/inst/m_axi_mm2s_arready} $vd_prefix]]]
set n_rvalid  [net_of_pin [list [format {%s/m_axi_mm2s_rvalid} $vd_prefix] \
                                 [format {%s/inst/m_axi_mm2s_rvalid} $vd_prefix]]]
set n_rlast   [net_of_pin [list [format {%s/m_axi_mm2s_rlast} $vd_prefix] \
                                 [format {%s/inst/m_axi_mm2s_rlast} $vd_prefix]]]
if {$n_arvalid eq {} || $n_rvalid eq {}} {
    error "RESOLVE-FAIL: axi read (arvalid=$n_arvalid arready=$n_arready rvalid=$n_rvalid)"
}
puts "RESOLVE-OK axi arvalid=$n_arvalid arready=$n_arready rvalid=$n_rvalid rlast=$n_rlast"

# ---- core 1: 50 MHz domain (ID detect + MMCM lock) ----
set c1 [create_debug_core u_ila_g50 ila]
tune_ila $c1
set_property C_DATA_DEPTH 1024 $c1
connect_debug_port $c1/clk $n_g50

set r0 [get_debug_ports -quiet u_ila_g50/probe0]
if {[llength $r0] == 0} { set r0 [list [create_debug_port $c1 probe]] }
set ip_nets [slot_nets $id_pins_slots]
set_property port_width [llength $ip_nets] [lindex $r0 0]
connect_debug_port [lindex $r0 0] $ip_nets
puts "G50-CONNECT probe0 id_pins w=[llength $ip_nets] bits=[slot_indices $id_pins_slots]"

set q1 [create_debug_port $c1 probe]
set_property port_width 1 $q1
connect_debug_port $q1 [list $n_locked]
set q2 [create_debug_port $c1 probe]
set_property port_width 16 $q2
connect_debug_port $q2 [slot_nets $id_reg_slots]
set q3 [create_debug_port $c1 probe]
set_property port_width 2 $q3
connect_debug_port $q3 [list $n_settled $n_valid]
puts "G50-CONNECT probe1 locked, probe2 id_reg[15:0], probe3 {settled,valid}"

# ---- core 2: pixel-clock domain (timing gen + vid_out sync) ----
set c2 [create_debug_core u_ila_pclk ila]
tune_ila $c2
set_property C_DATA_DEPTH 1024 $c2
connect_debug_port $c2/clk $n_pclk

set p0 [get_debug_ports -quiet u_ila_pclk/probe0]
if {[llength $p0] == 0} { set p0 [list [create_debug_port $c2 probe]] }
set_property port_width 12 [lindex $p0 0]
connect_debug_port [lindex $p0 0] [slot_nets $hcnt_slots]
set p1 [create_debug_port $c2 probe]
set_property port_width 12 $p1
connect_debug_port $p1 [slot_nets $vcnt_slots]
set p2 [create_debug_port $c2 probe]
set_property port_width 2 $p2
connect_debug_port $p2 [list $n_s4sync $n_s4meta]
puts "PCLK-CONNECT probe0 hcnt, probe1 vcnt, probe2 {sel4384_sync,sel4384_meta}"

if {[llength $fsm_nets]} {
    set q3 [create_debug_port $c2 probe]
    set_property port_width [llength $fsm_nets] $q3
    connect_debug_port $q3 $fsm_nets
    puts "PCLK-CONNECT probe3 FSM_onehot[0:12] w=[llength $fsm_nets]"
}
set p4_nets {}
foreach nn [list $n_vlocked $n_firstsof $n_vidrst] {
    if {$nn ne {}} { lappend p4_nets $nn }
}
if {[llength $p4_nets]} {
    set q4 [create_debug_port $c2 probe]
    set_property port_width [llength $p4_nets] $q4
    connect_debug_port $q4 $p4_nets
    puts "PCLK-CONNECT probe4 {locked,first_sof,vid_io_out_reset} <- $p4_nets"
}

# ---- core 3: aclk domain (VDMA -> vid_out AXIS + VDMA AXI read) ----
set c3 [create_debug_core u_ila_axis ila]
tune_ila $c3
set_property C_DATA_DEPTH 4096 $c3
connect_debug_port $c3/clk $n_aclk

set r0 [get_debug_ports -quiet u_ila_axis/probe0]
if {[llength $r0] == 0} { set r0 [list [create_debug_port $c3 probe]] }
set_property port_width 3 [lindex $r0 0]
connect_debug_port [lindex $r0 0] [list $n_tvalid $n_tready $n_tuser]
puts "AXIS-CONNECT probe0 {tvalid,tready,tuser}"

if {[llength $td_nets]} {
    set r1 [create_debug_port $c3 probe]
    set_property port_width [llength $td_nets] $r1
    connect_debug_port $r1 $td_nets
    puts "AXIS-CONNECT probe1 tdata w=[llength $td_nets] bits=[slot_indices $tdata_slots]"
}

# v5: AXI read channel verdict probe
set ax_nets {}
foreach nn [list $n_arvalid $n_arready $n_rvalid $n_rlast] {
    if {$nn ne {}} { lappend ax_nets $nn }
}
set r2 [create_debug_port $c3 probe]
set_property port_width [llength $ax_nets] $r2
connect_debug_port $r2 $ax_nets
puts "AXIS-CONNECT probe2 axi-read w=[llength $ax_nets] order={arvalid,arready,rvalid,rlast}-minus-dropped"

# ---- core 4: VDMA internal command chain (v6, FCLK_CLK0 same as u_ila_axis) ----
# Exact-name first; for names with literal [ ] (glob metachars in get_nets
# patterns) fall back to a bracket-free prefix glob + exact string match.
proc v6_net {fullname} {
    # strip backslashes (brace-escape artifacts): Vivado glob patterns do NOT
    # honor \[ \] escapes, so compare against the cleaned name instead.
    set clean [string map {\\ {}} $fullname]
    set n [get_nets -quiet $clean]
    if {[llength $n]} { return [lindex $n 0] }
    set leaf [file tail $clean]
    # bracket-free prefix of the leaf for the -hier glob scan
    regsub {[\[\].*$?].*$} $leaf {} leafpfx
    if {$leafpfx eq {} || $leafpfx eq $leaf} { return {} }
    foreach c [get_nets -quiet -hier -filter "NAME =~ */$leafpfx*"] {
        if {[string equal [safe_name $c] $clean]} { return $c }
    }
    return {}
}
set v6_mandatory {}
array set v6p {}
set v6p(cmd_tvalid)  [v6_net {axi_vdma_0/U0/s_axis_mm2s_cmd_tvalid}]
set v6p(cmd_tv0)     [v6_net {axi_vdma_0/U0/I_CMDSTS/s_axis_cmd_tvalid0}]
set v6p(idle)        [v6_net {axi_vdma_0/U0/mm2s_cmdsts_idle}]
set v6p(dm_rstn)     [v6_net {axi_vdma_0/U0/mm2s_dm_prmry_resetn}]
set v6p(prm_rstn)    [v6_net {axi_vdma_0/U0/mm2s_prmry_resetn}]
set v6p(axis_rstn)   [v6_net {axi_vdma_0/U0/mm2s_axis_resetn}]
set v6p(soft_rst)    [v6_net {axi_vdma_0/U0/mm2s_soft_reset}]
set v6p(sof_rst)     [v6_net {axi_vdma_0/U0/sof_reset}]
set v6p(rs_mirror)   [v6_net {axi_vdma_0/U0/GEN_SPRT_FOR_MM2S.MM2S_REGISTER_MODULE_I/I_DMA_REGISTER/mm2s_dmacr[0]}]
set v6p(arvalid_int) [v6_net {axi_vdma_0/U0/I_PRMRY_DATAMOVER/GEN_MM2S_FULL.I_MM2S_FULL_WRAPPER/m_axi_mm2s_arvalid}]
set v6p(ext_rstn)    [v6_net {axi_vdma_0/U0/axi_resetn}]
set v6p(frame_sync)  [v6_net {axi_vdma_0/U0/mm2s_frame_sync}]
set v6p(all_idle)    [v6_net {axi_vdma_0/U0/mm2s_all_idle}]
set v6p(valid_prm)   [v6_net {axi_vdma_0/U0/mm2s_valid_video_prmtrs}]
foreach k [list cmd_tvalid dm_rstn prm_rstn] {
    if {$v6p($k) eq {}} { lappend v6_mandatory $k }
}
if {[llength $v6_mandatory]} {
    error "RESOLVE-FAIL: v6 mandatory nets missing: $v6_mandatory"
}
foreach k [list cmd_tvalid cmd_tv0 idle dm_rstn prm_rstn axis_rstn soft_rst sof_rst rs_mirror arvalid_int ext_rstn] {
    puts "V6-RESOLVE $k = $v6p($k)"
}

set c4 [create_debug_core u_ila_vdma ila]
tune_ila $c4
set_property C_DATA_DEPTH 1024 $c4
connect_debug_port $c4/clk $n_aclk
set v4p0 [get_debug_ports -quiet u_ila_vdma/probe0]
if {[llength $v4p0] == 0} { set v4p0 [list [create_debug_port $c4 probe]] }
set v6_order [list cmd_tvalid cmd_tv0 idle dm_rstn prm_rstn axis_rstn soft_rst sof_rst rs_mirror arvalid_int ext_rstn frame_sync all_idle valid_prm]
set v6_nets {}
set v6_dropped {}
foreach k $v6_order {
    if {$v6p($k) ne {}} { lappend v6_nets $v6p($k) } else { lappend v6_dropped $k }
}
set_property port_width [llength $v6_nets] [lindex $v4p0 0]
connect_debug_port [lindex $v4p0 0] $v6_nets
puts "VDMA-CONNECT probe0 w=[llength $v6_nets] order=$v6_order dropped=$v6_dropped"

# ---- implement (save DCP, reopen, insert cores) ----
set dcp [file join $proj_root build debug_lcd_netlist.dcp]
write_checkpoint -force $dcp
close_design
open_checkpoint $dcp
implement_debug_core
write_debug_probes -force [file join $proj_root build lcd_debug_probes.ltx]
place_design
route_design
# v5.1: the v5 route shipped WNS=-1.27/TNS=-2.52 (Route 35-57 estimate) and the
# on-board symptom was AXI-Lite writes silently dropped (VDMA regs stuck at
# reset, app+DAP writes ignored, reads OK) -> close timing before bitstream.
phys_opt_design
set wns [get_property SLACK [get_timing_paths -delay_type max]]
puts "FINAL-WNS $wns"
report_timing_summary -file [file join $proj_root build timing_debug.rpt]
if {$wns < 0.0} {
    puts "TIMING-STILL-VIOLATED wns=$wns - see build/timing_debug.rpt (bitstream still written for lab use)"
}
write_bitstream -force [file join [file dirname $dcp] .. impl_1 design_1_wrapper_debug.bit]
puts "V6-DONE wns=$wns bit=[file join [file dirname $dcp] .. impl_1 design_1_wrapper_debug.bit]"
