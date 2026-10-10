# debug_ila.tcl v13 - port-pin based resolution (v12 DP-PINS enumeration facts).
# The u_emg_data_path boundary cell exposes flat synthesized net names:
#   pl_clk     IN  -> emg_pl_export_0/inst/pl_clk          (ILA clock)
#   s_full_reg OUT -> emg_pl_export_0/inst/u_emg_data_path_n_0  (fifo write-side
#                   full flag; axis_async_fifo.v: s_ready = !s_full, so
#                   probing s_full == probing !raw_ready)
#   frame_valid survives as net emg_pl_export_0/inst/frame_valid (= raw_valid).
#
# Probes: probe0 raw_valid(1) probe1 s_full(1=full=!ready) probe2 seq[15:0]
#         probe3 raw_overflow(1).  Trigger: probe0==1 && probe1==1.
#
set script_dir [file dirname [file normalize [info script]]]
set proj_root  [file normalize [file join $script_dir ..]]
set xpr        [file join $proj_root build vivado hand_motion_reconstruction.xpr]
open_project $xpr
open_run synth_1 -name synth_1

proc safe_name {o} { if {[catch {get_property NAME $o} n]} { return {?} } ; return $n }
proc name_list {objs} { set out {} ; foreach o $objs { lappend out [safe_name $o] } ; return $out }
proc leaf_index {nm} { if {[regexp {\[([0-9]+)\]$} $nm -> i]} { return $i } ; return -1 }

# ---- enumerate the data_path cell's port pins ----
set dp [get_pins -quiet {emg_pl_export_0/inst/u_emg_data_path/*}]
puts "DP-PINS [llength $dp]"
set pin_v {} ; set pin_f {} ; set pin_o {} ; set pin_c {}
foreach p $dp {
    set nm [safe_name $p]
    if {![regexp {^emg_pl_export_0/inst/u_emg_data_path/([^/]+)$} $nm -> leaf]} { continue }
    set dir "?"
    catch { set dir [get_property DIRECTION $p] }
    set nn [get_nets -quiet -of_objects $p]
    set net [expr {[llength $nn] ? [safe_name [lindex $nn 0]] : "NONE"}]
    puts "  PORTPIN $leaf dir=$dir net=$net"
    if {$leaf eq "raw_valid"}    { set pin_v [lindex $nn 0] }
    if {$leaf eq "s_full_reg"}   { set pin_f [lindex $nn 0] }
    if {$leaf eq "raw_overflow"} { set pin_o [lindex $nn 0] }
    if {$leaf eq "pl_clk"}       { set pin_c [lindex $nn 0] }
}

# ---- probe 0: raw_valid ----
set n_valid $pin_v
if {$n_valid eq ""} {
    foreach o [get_nets -quiet -hier -filter {NAME =~ */frame_valid*}] {
        if {[safe_name $o] eq "emg_pl_export_0/inst/frame_valid"} { set n_valid $o ; break }
    }
}
if {$n_valid eq ""} { error "VALID-FAIL" }
puts "VALID-OK [safe_name $n_valid]"

# ---- probe 1: RAW fifo s_full via surviving hierarchical cell (survey v2).
# The three fifo cells live at u_emg_data_path/{raw,feature,result}_fifo; the
# v16 boundary pin "s_full_reg" was a hoisted alias of one of the other lanes
# (85-100% duty on a live system proves it was NOT raw).  Use the exact cell.
set ffr [get_cells -quiet emg_pl_export_0/inst/u_emg_data_path/raw_fifo/s_full_reg]
if {[llength $ffr] == 0} { error "FULL-FAIL: raw_fifo/s_full_reg cell not found" }
set q [get_pins -quiet -of_objects $ffr -filter {REF_PIN_NAME == Q}]
if {[llength $q] == 0} { error "FULL-FAIL: raw_fifo/s_full_reg has no Q pin" }
set nn_q [get_nets -quiet -of_objects [lindex $q 0]]
if {[llength $nn_q] == 0} { error "FULL-FAIL: raw_fifo/s_full_reg Q net not found" }
set n_ready [lindex $nn_q 0]
puts "FULL-OK raw_s_full net=[safe_name $n_ready]"

# ---- probe 3: raw_overflow ----
set n_ovf $pin_o
if {$n_ovf eq ""} {
    foreach o [get_nets -quiet -hier -filter {NAME =~ */raw_overflow*}] {
        if {[safe_name $o] eq "emg_pl_export_0/inst/raw_overflow"} { set n_ovf $o ; break }
    }
}
if {$n_ovf eq ""} { error "OVF-FAIL" }
puts "OVF-OK [safe_name $n_ovf]"

# ---- probe 2: raw_sequence[15:0] via counter FF Q nets ----
set ffs {}
foreach c [get_cells -quiet -hier -filter {NAME =~ *raw_sequence_reg*}] {
    if {[regexp {raw_sequence_reg\[[0-9]+\]$} [safe_name $c]]} { lappend ffs $c }
}
puts "SEQ-FF [llength $ffs]: [name_list $ffs]"
if {[llength $ffs] == 0} { error "SEQ-FAIL" }
set pairs {}
foreach c $ffs {
    set q [get_pins -quiet -of_objects $c -filter {REF_PIN_NAME == Q && DIRECTION == OUT}]
    if {[llength $q] == 0} { continue }
    set qn [get_nets -quiet -of_objects [lindex $q 0]]
    if {[llength $qn] == 0} { continue }
    lappend pairs [list [leaf_index [safe_name $c]] [lindex $qn 0]]
}
set pairs [lsort -integer -index 0 $pairs]
set s_nets {}
foreach p $pairs { lappend s_nets [lindex $p 1] }
puts "SEQ-NETS [llength $s_nets]: [name_list $s_nets]"
if {[llength $s_nets] == 0} { error "SEQ-FAIL: no Q nets" }

# ---- clock: pl_clk port pin first, then seq-FF pin walk ----
set clk_net $pin_c
if {$clk_net eq ""} {
    set ff0 [lindex $ffs 0]
    foreach p [get_pins -quiet -of_objects $ff0 -filter {DIRECTION == IN}] {
        set pnn [get_nets -quiet -of_objects $p]
        set nname [expr {[llength $pnn] ? [safe_name [lindex $pnn 0]] : ""}]
        puts "FF0-PIN [get_property REF_PIN_NAME $p] net=$nname"
        if {[string match *pl_clk* $nname]} { set clk_net [lindex $pnn 0] ; break }
    }
}
if {$clk_net eq ""} {
    set ff0 [lindex $ffs 0]
    set cp [get_pins -quiet -of_objects $ff0 -filter {REF_PIN_NAME == C}]
    if {[llength $cp] > 0} {
        set cn [get_nets -quiet -of_objects [lindex $cp 0]]
        if {[llength $cn] > 0} { set clk_net [lindex $cn 0] }
    }
}
if {$clk_net eq ""} { error "CLK-FAIL" }
puts "CLK-OK [safe_name $clk_net]"

# ---- one debug core ----
set core [create_debug_core u_ila_raw ila]
set_property C_DATA_DEPTH 4096 $core
connect_debug_port $core/clk $clk_net

# 2025.2 quirk: create_debug_core ila auto-creates an unconnected probe0 (w=1).
# Reuse it as the first probe port; leaving it dangling starves trigger match
# unit 0 and opt_design fails with [Opt 31-65] (undriven LUT u_trig ...G_NMU[0]).
set p0 [get_debug_ports -quiet u_ila_raw/probe0]
set plist [list]
if {[llength $p0] > 0} { lappend plist [lindex $p0 0] }
while {[llength $plist] < 4} { lappend plist [create_debug_port $core probe] }

foreach {p nets width} [list [lindex $plist 0] $n_valid 1 \
                             [lindex $plist 1] $n_ready 1 \
                             [lindex $plist 2] $s_nets 16 \
                             [lindex $plist 3] $n_ovf 1] {
    if {[llength $nets] == 0} { puts "SKIP w=$width" ; continue }
    set_property port_width $width $p
    connect_debug_port $p $nets
    puts "CONNECT [safe_name $p] w=$width <- [name_list $nets]"
}

# implement_debug_core requires a saved design (Common 17-69):
# save to DCP, reopen, then insert the core.
set dcp [file join $proj_root build debug_netlist.dcp]
write_checkpoint -force $dcp
close_design
open_checkpoint $dcp
implement_debug_core
write_debug_probes -force [file join $proj_root build debug_probes.ltx]
place_design
route_design
write_bitstream -force [file join $proj_root build vivado hand_motion_reconstruction.runs impl_1 design_1_wrapper_debug.bit]
puts "DEBUG-ILA: done. CHECK COMPLETE"
close_project
