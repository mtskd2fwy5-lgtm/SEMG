# Refresh module references after a reviewed RTL change; keep the saved BD.
set root [file normalize [file join [file dirname [info script]] ../..]]
source [file join $root build/update_project.tcl]
open_project [file join $root build/vivado/hand_motion_reconstruction.xpr]
open_bd_design [get_files design_1.bd]
foreach name {design_1_hdmi_scaler_0_0 design_1_hdmi_output_0_0} {
    upgrade_ip [get_ips $name]
}
set vo [get_bd_pins video_out_hdmi/aresetn]
disconnect_bd_net [get_bd_nets -of_objects $vo] $vo
connect_bd_net [get_bd_pins hdmi_output_0/stream_resetn] $vo
validate_bd_design -force
save_bd_design
generate_target all [get_files design_1.bd]
close_project
puts "TEST_PASS HDMI module references refreshed"
