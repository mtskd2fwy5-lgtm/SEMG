set root [file normalize [file join [file dirname [info script]] ../..]]
set out [file normalize [file dirname [info script]]]
set dcp $root/build/vivado/hand_motion_reconstruction.runs/design_1_emg_pl_export_0_7_synth_1/design_1_emg_pl_export_0_7.dcp
open_checkpoint $dcp
write_verilog -force -mode funcsim $out/integrated_pl_export.v
puts INTEGRATED_NETLIST_EXPORTED
close_design
