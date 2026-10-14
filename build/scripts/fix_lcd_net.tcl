# Split the LCD data net: vid_out's vid_data must NOT sit on the tri-state
# pad net. Correct topology (mirrors the official lcd_rgb_char scheme):
#   netA (clean drive):  v_axi4s_vid_out_0/vid_data -> lcd_panel_adapter_0/rgb_o
#   netB (tri-state pad): lcd_panel_adapter_0/lcd_data_io <-> top port lcd_data
# Previously all four endpoints shared one net, so the top-level IOBUF readback
# (lcd_data_io[*]_INST_0/O) and vid_out's in_data_mux_reg[*]/Q both drove the
# same net -> DRC MDRV-1 at opt_design, 24x.
#
# Usage: vivado -mode batch -source build/scripts/fix_lcd_net.tcl

set script_dir [file dirname [info script]]
set project_root [file normalize [file join $script_dir .. ..]]
set project_file [file join $project_root build vivado hand_motion_reconstruction.xpr]

open_project $project_file
set bd_file [lindex [get_files -quiet -of [get_filesets sources_1] design_1.bd] 0]
open_bd_design $bd_file

set vid_data_pin [get_bd_pins v_axi4s_vid_out_0/vid_data]
set rgb_o_pin    [get_bd_pins lcd_panel_adapter_0/rgb_o]
set pad_pin      [get_bd_pins lcd_panel_adapter_0/lcd_data_io]

set netA [get_bd_nets -quiet -of_objects $vid_data_pin]
puts "LCDNET-FIX vid_data net: $netA"
if {[llength $netA] != 1} { error "LCDNET-FIX unexpected net count on vid_data" }

# Disconnect both vid_out and adapter.rgb_o from the shared pad net...
disconnect_bd_net $netA $vid_data_pin
disconnect_bd_net $netA $rgb_o_pin
# ...then give them their own clean net.
connect_bd_net $vid_data_pin $rgb_o_pin

puts "LCDNET-FIX after rewire:"
puts "  vid_data -> [get_bd_nets -of_objects $vid_data_pin]"
puts "  pad net  -> [get_bd_nets -of_objects $pad_pin]"

validate_bd_design -force
save_bd_design
generate_target all [get_files design_1.bd]
close_project
puts "LCDNET-FIX DONE"
