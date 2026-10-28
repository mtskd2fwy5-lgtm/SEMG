set root [file normalize [pwd]]
open_checkpoint $root/build/vivado/hand_motion_reconstruction.runs/design_1_emg_pl_export_0_7_synth_1/design_1_emg_pl_export_0_7.dcp
write_verilog -force -mode funcsim $root/report/resource_optimization_v15_20261027/integrated_pl_export.v
puts V15_INTEGRATED_NETLIST_EXPORTED
close_design