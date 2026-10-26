set root [file normalize [file join [file dirname [info script]] ../..]]
open_checkpoint [file join $root build/vivado/hand_motion_reconstruction.runs/design_1_emg_learning_0_0_synth_1/design_1_emg_learning_0_0.dcp]
write_verilog -mode funcsim -force [file join $root sim/results_learning/learning_synth.v]
puts "LEARNING_FUNC_NETLIST_EXPORTED"
