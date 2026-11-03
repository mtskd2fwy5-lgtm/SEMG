# Switch the RGB LCD panel timing in design_1 (dual-panel support):
#   vivado -mode batch -source build/scripts/set_lcd_panel.tcl -tclargs <panel>
#     <panel> = 4384 -> ATK-4384 4.3" 800x480, FCLK1 31 (resolves 31.25 MHz)
#               7016 -> ATK-7016 7"  1024x600, FCLK1 50 (original build)
#
# Companion switch on the firmware side: sw/ps_uart_print/main.c
# LCD_PANEL_4384 macro (1 = 4384, 0 = 7016).  Both sides must match, and any
# FCLK1 frequency change requires the full PS four-step flow (export XSA ->
# Vitis re-read -> verify zynq_fsbl\ps7_init.c -> rebuild FSBL + bootgen;
# see project memory).
#
# Timing sources: ATK RGB module spec table (hsync/vsync active low, DE
# active high - same polarity on both panels, GEN_* polarity props untouched).
#   4384: H 800 + HFP 40 + HSW 48 + HBP 88 =  976, V 480 + VFP 13 + VSW 3
#         + VBP 32 =  528, 31 MHz -> 60.6 fps
#   7016: H 1024 + HFP 130 + HSW 30 + HBP 160 = 1344, V 600 + VFP 12 + VSW
#         10 + VBP 23 = 635, 50 MHz -> 58.6 fps (values as first built)
#
# IMPORTANT: run OUTSIDE the TRAE sandbox - validate_bd_design regenerates
# IP products and needs the project .cache / boost_interprocess IPC.

set project_root [file normalize [file join [file dirname [info script]] .. ..]]
set owned 0
if {[llength [get_projects -quiet hand_motion_reconstruction]] == 0} {
    open_project [file join $project_root build vivado hand_motion_reconstruction.xpr]
    set owned 1
}
if {[llength [get_bd_designs -quiet design_1]] == 0} {
    open_bd_design [get_files design_1.bd]
}

# ---- Panel table.
array set PANEL {
    4384,fclk         31
    4384,hactive      800
    4384,hsync_start  840
    4384,hsync_end    888
    4384,hframe       976
    4384,vactive      480
    4384,vsync_start  493
    4384,vsync_end    496
    4384,vframe       528
    7016,fclk         50
    7016,hactive      1024
    7016,hsync_start  1154
    7016,hsync_end    1184
    7016,hframe       1344
    7016,vactive      600
    7016,vsync_start  602
    7016,vsync_end    612
    7016,vframe       635
}

# ---- Argument: exactly one known panel id.
if {$argc != 1} {
    error "usage: vivado -mode batch -source set_lcd_panel.tcl -tclargs <4384|7016>"
}
set panel [lindex $argv 0]
if {![info exists PANEL($panel,fclk)]} {
    error "unknown panel '$panel' - expected 4384 or 7016"
}

set ps7 [get_bd_cells processing_system7_0]
set vtc [get_bd_cells v_tc_0]

# ---- PS7: FCLK1 pixel clock.  Only the CLK1 divisor changes; the IO PLL
# itself is untouched, so SDIO0/UART (100 MHz from IO PLL) are unaffected.
set_property CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ $PANEL($panel,fclk) $ps7

# ---- VTC generation timing (VIDEO_MODE is already Custom; polarity props
# are unchanged - both panels are HS/VS low, DE high).
set_property -dict [list \
    CONFIG.GEN_HACTIVE_SIZE   $PANEL($panel,hactive) \
    CONFIG.GEN_HSYNC_START    $PANEL($panel,hsync_start) \
    CONFIG.GEN_HSYNC_END      $PANEL($panel,hsync_end) \
    CONFIG.GEN_HFRAME_SIZE    $PANEL($panel,hframe) \
    CONFIG.GEN_VACTIVE_SIZE   $PANEL($panel,vactive) \
    CONFIG.GEN_F0_VSYNC_VSTART $PANEL($panel,vsync_start) \
    CONFIG.GEN_F0_VSYNC_VEND  $PANEL($panel,vsync_end) \
    CONFIG.GEN_F0_VFRAME_SIZE $PANEL($panel,vframe)] $vtc

validate_bd_design
save_bd_design

# ---- Report what actually stuck (PS7 resolves the requested frequency to
# the achievable divisor - check the *_ACT_ value in the printout).
puts "================ set_lcd_panel: $panel ================"
puts "PCW_FPGA1_PERIPHERAL_FREQMHZ = [get_property CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ $ps7]"
puts "PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ = [get_property CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ $ps7]"
foreach p {hactive hsync_start hsync_end hframe vactive vsync_start vsync_end vframe} {
    set prop GEN_[string toupper $p]
    if {$p eq "vsync_start"} { set prop GEN_F0_VSYNC_VSTART }
    if {$p eq "vsync_end"}   { set prop GEN_F0_VSYNC_VEND }
    if {$p eq "vframe"}      { set prop GEN_F0_VFRAME_SIZE }
    puts "$prop = [get_property CONFIG.$prop $vtc]"
}
puts "Next: full build (build\\build_all.bat -SkipBoot), then the PS four-step"
puts "flow (re-read XSA -> verify ps7_init.c -> rebuild FSBL) and main.c must"
puts "have LCD_PANEL_4384 set to [expr {$panel eq {4384} ? 1 : 0}]."
if {$owned} {
    close_project
}

