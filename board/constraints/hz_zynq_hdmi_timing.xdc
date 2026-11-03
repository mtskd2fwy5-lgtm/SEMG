# Implementation-only, LATE. Exceptions stop at real synchronizer inputs;
# pixel/TMDS datapaths and all second-stage/functional registers remain timed.
set hdmi_status_meta [get_cells -hier -filter {NAME =~ hdmi_output_0/inst/stat_meta_reg*}]
if {[llength $hdmi_status_meta]!=6} {error "HDMI status synchronizer missing"}
set_false_path -to [get_pins -of_objects $hdmi_status_meta -filter {REF_PIN_NAME == D}]
set hdmi_panel_meta [get_cells -hier -filter {NAME == hdmi_scaler_0/inst/panel_meta_reg}]
if {[llength $hdmi_panel_meta]!=1} {error "HDMI panel mode synchronizer missing"}
set_false_path -to [get_pins -of_objects $hdmi_panel_meta -filter {REF_PIN_NAME == D}]
# These flops implement asynchronous assertion / synchronous deassertion.
# Do not time the asynchronous preset against the unrelated launch clocks.
# The synchronous shift-register path and all functional reset destinations
# remain checked. Include the existing LCD reset synchronizer for both modes.
set video_reset_sync [get_cells -hier -filter {NAME =~ hdmi_output_0/inst/reset_sync_reg* || NAME == lcd_panel_adapter_0/inst/vid_rst_meta_reg || NAME == lcd_panel_adapter_0/inst/vid_rst_sync_reg}]
set_false_path -to [get_pins -of_objects $video_reset_sync -filter {REF_PIN_NAME == PRE}]
