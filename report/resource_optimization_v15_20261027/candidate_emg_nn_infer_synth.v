// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
// Date        : Tue Oct 27 16:57:42 2026
// Host        : LAPTOP-VCCV41QO running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               D:/FPGA/sEMG-HMRS/report/resource_optimization_v15_20261027/candidate_emg_nn_infer_synth.v
// Design      : emg_nn_infer
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* A_B1 = "11'b01011010000" *) (* A_B2 = "11'b10100010010" *) (* A_B3 = "11'b10101011100" *) 
(* A_M_IN = "11'b00000000000" *) (* A_N_IN = "11'b00000101000" *) (* A_R1 = "11'b01100010000" *) 
(* A_R2 = "11'b10100110010" *) (* A_W1 = "11'b00001010000" *) (* A_W2 = "11'b01100010010" *) 
(* A_W3 = "11'b10100110100" *) (* LAYER1 = "2'b00" *) (* LAYER2 = "2'b01" *) 
(* LAYER3 = "2'b10" *) (* MEM_FILE = "d:/FPGA/sEMG-HMRS/data/models/nn_int8_board_multiwear/nn_int8_weights.mem" *) (* N_H1 = "64" *) 
(* N_H2 = "32" *) (* N_IN = "40" *) (* N_OUT = "5" *) 
(* S_AM = "5'b01111" *) (* S_IDLE = "5'b00000" *) (* S_LDB = "5'b00110" *) 
(* S_LDBN = "5'b10011" *) (* S_LDBW = "5'b00111" *) (* S_LST = "5'b10001" *) 
(* S_MAC0 = "5'b01000" *) (* S_MAC1 = "5'b01001" *) (* S_MAC2 = "5'b01010" *) 
(* S_MAC3 = "5'b01011" *) (* S_NEXT = "5'b01110" *) (* S_NM = "5'b00001" *) 
(* S_NN = "5'b00010" *) (* S_NX = "5'b00011" *) (* S_OUT = "5'b10000" *) 
(* S_REQ = "5'b01100" *) (* S_REQS = "5'b01101" *) (* S_RQM = "5'b00100" *) 
(* S_RQN = "5'b00101" *) (* S_WR = "5'b10010" *) 
(* NotValidForBitStream *)
module emg_nn_infer
   (clk,
    rst_n,
    feat_valid,
    feat_index,
    feat_data,
    feat_ready,
    out_valid,
    out_ready,
    out_id,
    out_data);
  input clk;
  input rst_n;
  input feat_valid;
  input [5:0]feat_index;
  input [31:0]feat_data;
  output feat_ready;
  output out_valid;
  input out_ready;
  output [2:0]out_id;
  output [31:0]out_data;

  wire [7:0]A;
  wire [7:0]B;
  wire \FSM_sequential_state[0]_i_2_n_0 ;
  wire \FSM_sequential_state[1]_i_2_n_0 ;
  wire \FSM_sequential_state[2]_i_2_n_0 ;
  wire \FSM_sequential_state[2]_i_3_n_0 ;
  wire \FSM_sequential_state[2]_i_4_n_0 ;
  wire \FSM_sequential_state[3]_i_2_n_0 ;
  wire \FSM_sequential_state[4]_i_1_n_0 ;
  wire \FSM_sequential_state[4]_i_3_n_0 ;
  wire \FSM_sequential_state[4]_i_5_n_0 ;
  wire \FSM_sequential_state[4]_i_6_n_0 ;
  wire \FSM_sequential_state[4]_i_7_n_0 ;
  wire [31:0]acc;
  wire [31:0]acc0;
  wire \acc[0]_i_1_n_0 ;
  wire \acc[10]_i_1_n_0 ;
  wire \acc[11]_i_1_n_0 ;
  wire \acc[11]_i_3_n_0 ;
  wire \acc[11]_i_4_n_0 ;
  wire \acc[11]_i_5_n_0 ;
  wire \acc[11]_i_6_n_0 ;
  wire \acc[12]_i_1_n_0 ;
  wire \acc[13]_i_1_n_0 ;
  wire \acc[14]_i_1_n_0 ;
  wire \acc[15]_i_100_n_0 ;
  wire \acc[15]_i_101_n_0 ;
  wire \acc[15]_i_102_n_0 ;
  wire \acc[15]_i_103_n_0 ;
  wire \acc[15]_i_107_n_0 ;
  wire \acc[15]_i_108_n_0 ;
  wire \acc[15]_i_109_n_0 ;
  wire \acc[15]_i_10_n_0 ;
  wire \acc[15]_i_110_n_0 ;
  wire \acc[15]_i_111_n_0 ;
  wire \acc[15]_i_112_n_0 ;
  wire \acc[15]_i_113_n_0 ;
  wire \acc[15]_i_118_n_0 ;
  wire \acc[15]_i_119_n_0 ;
  wire \acc[15]_i_11_n_0 ;
  wire \acc[15]_i_120_n_0 ;
  wire \acc[15]_i_121_n_0 ;
  wire \acc[15]_i_122_n_0 ;
  wire \acc[15]_i_123_n_0 ;
  wire \acc[15]_i_124_n_0 ;
  wire \acc[15]_i_125_n_0 ;
  wire \acc[15]_i_12_n_0 ;
  wire \acc[15]_i_13_n_0 ;
  wire \acc[15]_i_14_n_0 ;
  wire \acc[15]_i_15_n_0 ;
  wire \acc[15]_i_16_n_0 ;
  wire \acc[15]_i_17_n_0 ;
  wire \acc[15]_i_18_n_0 ;
  wire \acc[15]_i_19_n_0 ;
  wire \acc[15]_i_1_n_0 ;
  wire \acc[15]_i_20_n_0 ;
  wire \acc[15]_i_21_n_0 ;
  wire \acc[15]_i_22_n_0 ;
  wire \acc[15]_i_24_n_0 ;
  wire \acc[15]_i_25_n_0 ;
  wire \acc[15]_i_31_n_0 ;
  wire \acc[15]_i_32_n_0 ;
  wire \acc[15]_i_33_n_0 ;
  wire \acc[15]_i_34_n_0 ;
  wire \acc[15]_i_35_n_0 ;
  wire \acc[15]_i_36_n_0 ;
  wire \acc[15]_i_37_n_0 ;
  wire \acc[15]_i_38_n_0 ;
  wire \acc[15]_i_42_n_0 ;
  wire \acc[15]_i_43_n_0 ;
  wire \acc[15]_i_44_n_0 ;
  wire \acc[15]_i_45_n_0 ;
  wire \acc[15]_i_46_n_0 ;
  wire \acc[15]_i_47_n_0 ;
  wire \acc[15]_i_48_n_0 ;
  wire \acc[15]_i_49_n_0 ;
  wire \acc[15]_i_4_n_0 ;
  wire \acc[15]_i_50_n_0 ;
  wire \acc[15]_i_51_n_0 ;
  wire \acc[15]_i_52_n_0 ;
  wire \acc[15]_i_53_n_0 ;
  wire \acc[15]_i_54_n_0 ;
  wire \acc[15]_i_55_n_0 ;
  wire \acc[15]_i_56_n_0 ;
  wire \acc[15]_i_57_n_0 ;
  wire \acc[15]_i_58_n_0 ;
  wire \acc[15]_i_59_n_0 ;
  wire \acc[15]_i_5_n_0 ;
  wire \acc[15]_i_60_n_0 ;
  wire \acc[15]_i_61_n_0 ;
  wire \acc[15]_i_62_n_0 ;
  wire \acc[15]_i_63_n_0 ;
  wire \acc[15]_i_64_n_0 ;
  wire \acc[15]_i_65_n_0 ;
  wire \acc[15]_i_66_n_0 ;
  wire \acc[15]_i_67_n_0 ;
  wire \acc[15]_i_68_n_0 ;
  wire \acc[15]_i_69_n_0 ;
  wire \acc[15]_i_6_n_0 ;
  wire \acc[15]_i_70_n_0 ;
  wire \acc[15]_i_71_n_0 ;
  wire \acc[15]_i_72_n_0 ;
  wire \acc[15]_i_75_n_0 ;
  wire \acc[15]_i_76_n_0 ;
  wire \acc[15]_i_78_n_0 ;
  wire \acc[15]_i_7_n_0 ;
  wire \acc[15]_i_80_n_0 ;
  wire \acc[15]_i_81_n_0 ;
  wire \acc[15]_i_82_n_0 ;
  wire \acc[15]_i_83_n_0 ;
  wire \acc[15]_i_84_n_0 ;
  wire \acc[15]_i_85_n_0 ;
  wire \acc[15]_i_86_n_0 ;
  wire \acc[15]_i_87_n_0 ;
  wire \acc[15]_i_88_n_0 ;
  wire \acc[15]_i_89_n_0 ;
  wire \acc[15]_i_90_n_0 ;
  wire \acc[15]_i_91_n_0 ;
  wire \acc[15]_i_92_n_0 ;
  wire \acc[15]_i_93_n_0 ;
  wire \acc[15]_i_94_n_0 ;
  wire \acc[15]_i_95_n_0 ;
  wire \acc[15]_i_96_n_0 ;
  wire \acc[15]_i_97_n_0 ;
  wire \acc[15]_i_98_n_0 ;
  wire \acc[15]_i_99_n_0 ;
  wire \acc[16]_i_1_n_0 ;
  wire \acc[17]_i_1_n_0 ;
  wire \acc[18]_i_1_n_0 ;
  wire \acc[19]_i_1_n_0 ;
  wire \acc[19]_i_3_n_0 ;
  wire \acc[19]_i_4_n_0 ;
  wire \acc[19]_i_5_n_0 ;
  wire \acc[19]_i_6_n_0 ;
  wire \acc[19]_i_7_n_0 ;
  wire \acc[1]_i_1_n_0 ;
  wire \acc[20]_i_1_n_0 ;
  wire \acc[21]_i_1_n_0 ;
  wire \acc[22]_i_1_n_0 ;
  wire \acc[23]_i_1_n_0 ;
  wire \acc[23]_i_3_n_0 ;
  wire \acc[23]_i_4_n_0 ;
  wire \acc[23]_i_5_n_0 ;
  wire \acc[23]_i_6_n_0 ;
  wire \acc[24]_i_1_n_0 ;
  wire \acc[25]_i_1_n_0 ;
  wire \acc[26]_i_1_n_0 ;
  wire \acc[27]_i_1_n_0 ;
  wire \acc[27]_i_3_n_0 ;
  wire \acc[27]_i_4_n_0 ;
  wire \acc[27]_i_5_n_0 ;
  wire \acc[27]_i_6_n_0 ;
  wire \acc[28]_i_1_n_0 ;
  wire \acc[29]_i_1_n_0 ;
  wire \acc[2]_i_1_n_0 ;
  wire \acc[30]_i_1_n_0 ;
  wire \acc[31]_i_1_n_0 ;
  wire \acc[31]_i_3_n_0 ;
  wire \acc[31]_i_4_n_0 ;
  wire \acc[31]_i_5_n_0 ;
  wire \acc[31]_i_6_n_0 ;
  wire \acc[3]_i_10_n_0 ;
  wire \acc[3]_i_11_n_0 ;
  wire \acc[3]_i_12_n_0 ;
  wire \acc[3]_i_13_n_0 ;
  wire \acc[3]_i_14_n_0 ;
  wire \acc[3]_i_15_n_0 ;
  wire \acc[3]_i_16_n_0 ;
  wire \acc[3]_i_17_n_0 ;
  wire \acc[3]_i_18_n_0 ;
  wire \acc[3]_i_19_n_0 ;
  wire \acc[3]_i_1_n_0 ;
  wire \acc[3]_i_20_n_0 ;
  wire \acc[3]_i_21_n_0 ;
  wire \acc[3]_i_22_n_0 ;
  wire \acc[3]_i_30_n_0 ;
  wire \acc[3]_i_34_n_0 ;
  wire \acc[3]_i_35_n_0 ;
  wire \acc[3]_i_36_n_0 ;
  wire \acc[3]_i_37_n_0 ;
  wire \acc[3]_i_38_n_0 ;
  wire \acc[3]_i_39_n_0 ;
  wire \acc[3]_i_3_n_0 ;
  wire \acc[3]_i_40_n_0 ;
  wire \acc[3]_i_41_n_0 ;
  wire \acc[3]_i_4_n_0 ;
  wire \acc[3]_i_5_n_0 ;
  wire \acc[3]_i_6_n_0 ;
  wire \acc[3]_i_9_n_0 ;
  wire \acc[4]_i_1_n_0 ;
  wire \acc[5]_i_1_n_0 ;
  wire \acc[6]_i_1_n_0 ;
  wire \acc[7]_i_10_n_0 ;
  wire \acc[7]_i_11_n_0 ;
  wire \acc[7]_i_12_n_0 ;
  wire \acc[7]_i_13_n_0 ;
  wire \acc[7]_i_14_n_0 ;
  wire \acc[7]_i_15_n_0 ;
  wire \acc[7]_i_1_n_0 ;
  wire \acc[7]_i_3_n_0 ;
  wire \acc[7]_i_4_n_0 ;
  wire \acc[7]_i_5_n_0 ;
  wire \acc[7]_i_6_n_0 ;
  wire \acc[7]_i_8_n_0 ;
  wire \acc[7]_i_9_n_0 ;
  wire \acc[8]_i_1_n_0 ;
  wire \acc[9]_i_1_n_0 ;
  wire \acc_reg[11]_i_2_n_0 ;
  wire \acc_reg[11]_i_2_n_1 ;
  wire \acc_reg[11]_i_2_n_2 ;
  wire \acc_reg[11]_i_2_n_3 ;
  wire \acc_reg[15]_i_104_n_0 ;
  wire \acc_reg[15]_i_105_n_0 ;
  wire \acc_reg[15]_i_106_n_0 ;
  wire \acc_reg[15]_i_114_n_0 ;
  wire \acc_reg[15]_i_115_n_0 ;
  wire \acc_reg[15]_i_116_n_0 ;
  wire \acc_reg[15]_i_117_n_0 ;
  wire \acc_reg[15]_i_23_n_0 ;
  wire \acc_reg[15]_i_23_n_1 ;
  wire \acc_reg[15]_i_23_n_2 ;
  wire \acc_reg[15]_i_23_n_3 ;
  wire \acc_reg[15]_i_23_n_4 ;
  wire \acc_reg[15]_i_23_n_5 ;
  wire \acc_reg[15]_i_23_n_6 ;
  wire \acc_reg[15]_i_23_n_7 ;
  wire \acc_reg[15]_i_26_n_1 ;
  wire \acc_reg[15]_i_26_n_3 ;
  wire \acc_reg[15]_i_26_n_6 ;
  wire \acc_reg[15]_i_26_n_7 ;
  wire \acc_reg[15]_i_27_n_0 ;
  wire \acc_reg[15]_i_27_n_1 ;
  wire \acc_reg[15]_i_27_n_2 ;
  wire \acc_reg[15]_i_27_n_3 ;
  wire \acc_reg[15]_i_27_n_4 ;
  wire \acc_reg[15]_i_27_n_5 ;
  wire \acc_reg[15]_i_27_n_6 ;
  wire \acc_reg[15]_i_27_n_7 ;
  wire \acc_reg[15]_i_28_n_1 ;
  wire \acc_reg[15]_i_28_n_3 ;
  wire \acc_reg[15]_i_28_n_6 ;
  wire \acc_reg[15]_i_28_n_7 ;
  wire \acc_reg[15]_i_29_n_0 ;
  wire \acc_reg[15]_i_29_n_1 ;
  wire \acc_reg[15]_i_29_n_2 ;
  wire \acc_reg[15]_i_29_n_3 ;
  wire \acc_reg[15]_i_29_n_4 ;
  wire \acc_reg[15]_i_29_n_5 ;
  wire \acc_reg[15]_i_29_n_6 ;
  wire \acc_reg[15]_i_29_n_7 ;
  wire \acc_reg[15]_i_2_n_0 ;
  wire \acc_reg[15]_i_2_n_1 ;
  wire \acc_reg[15]_i_2_n_2 ;
  wire \acc_reg[15]_i_2_n_3 ;
  wire \acc_reg[15]_i_30_n_0 ;
  wire \acc_reg[15]_i_30_n_1 ;
  wire \acc_reg[15]_i_30_n_2 ;
  wire \acc_reg[15]_i_30_n_3 ;
  wire \acc_reg[15]_i_30_n_4 ;
  wire \acc_reg[15]_i_30_n_5 ;
  wire \acc_reg[15]_i_30_n_6 ;
  wire \acc_reg[15]_i_30_n_7 ;
  wire \acc_reg[15]_i_3_n_1 ;
  wire \acc_reg[15]_i_3_n_2 ;
  wire \acc_reg[15]_i_3_n_3 ;
  wire \acc_reg[15]_i_8_n_0 ;
  wire \acc_reg[15]_i_8_n_1 ;
  wire \acc_reg[15]_i_8_n_2 ;
  wire \acc_reg[15]_i_8_n_3 ;
  wire \acc_reg[15]_i_9_n_3 ;
  wire \acc_reg[15]_i_9_n_6 ;
  wire \acc_reg[15]_i_9_n_7 ;
  wire \acc_reg[19]_i_2_n_0 ;
  wire \acc_reg[19]_i_2_n_1 ;
  wire \acc_reg[19]_i_2_n_2 ;
  wire \acc_reg[19]_i_2_n_3 ;
  wire \acc_reg[23]_i_2_n_0 ;
  wire \acc_reg[23]_i_2_n_1 ;
  wire \acc_reg[23]_i_2_n_2 ;
  wire \acc_reg[23]_i_2_n_3 ;
  wire \acc_reg[27]_i_2_n_0 ;
  wire \acc_reg[27]_i_2_n_1 ;
  wire \acc_reg[27]_i_2_n_2 ;
  wire \acc_reg[27]_i_2_n_3 ;
  wire \acc_reg[31]_i_2_n_1 ;
  wire \acc_reg[31]_i_2_n_2 ;
  wire \acc_reg[31]_i_2_n_3 ;
  wire \acc_reg[3]_i_2_n_0 ;
  wire \acc_reg[3]_i_2_n_1 ;
  wire \acc_reg[3]_i_2_n_2 ;
  wire \acc_reg[3]_i_2_n_3 ;
  wire \acc_reg[3]_i_7_n_0 ;
  wire \acc_reg[3]_i_7_n_1 ;
  wire \acc_reg[3]_i_7_n_2 ;
  wire \acc_reg[3]_i_7_n_3 ;
  wire \acc_reg[3]_i_7_n_4 ;
  wire \acc_reg[3]_i_7_n_5 ;
  wire \acc_reg[3]_i_7_n_6 ;
  wire \acc_reg[3]_i_7_n_7 ;
  wire \acc_reg[3]_i_8_n_0 ;
  wire \acc_reg[3]_i_8_n_1 ;
  wire \acc_reg[3]_i_8_n_2 ;
  wire \acc_reg[3]_i_8_n_3 ;
  wire \acc_reg[3]_i_8_n_4 ;
  wire \acc_reg[7]_i_2_n_0 ;
  wire \acc_reg[7]_i_2_n_1 ;
  wire \acc_reg[7]_i_2_n_2 ;
  wire \acc_reg[7]_i_2_n_3 ;
  wire \acc_reg[7]_i_7_n_0 ;
  wire \acc_reg[7]_i_7_n_1 ;
  wire \acc_reg[7]_i_7_n_2 ;
  wire \acc_reg[7]_i_7_n_3 ;
  wire [6:0]act0;
  wire [6:0]act1;
  wire act2;
  wire [31:0]am_best;
  wire [0:0]amax_c;
  wire [8:8]b_base0;
  wire [0:0]bram_addr;
  wire \bram_addr[0]_i_1_n_0 ;
  wire \bram_addr[0]_i_2_n_0 ;
  wire \bram_addr[0]_i_3_n_0 ;
  wire \bram_addr[10]_i_15_n_0 ;
  wire \bram_addr[10]_i_16_n_0 ;
  wire \bram_addr[10]_i_18_n_0 ;
  wire \bram_addr[10]_i_22_n_0 ;
  wire \bram_addr[10]_i_23_n_0 ;
  wire \bram_addr[10]_i_24_n_0 ;
  wire \bram_addr[10]_i_25_n_0 ;
  wire \bram_addr[10]_i_26_n_0 ;
  wire \bram_addr[10]_i_27_n_0 ;
  wire \bram_addr[10]_i_28_n_0 ;
  wire \bram_addr[10]_i_29_n_0 ;
  wire \bram_addr[10]_i_2_n_0 ;
  wire \bram_addr[10]_i_30_n_0 ;
  wire \bram_addr[10]_i_31_n_0 ;
  wire \bram_addr[10]_i_32_n_0 ;
  wire \bram_addr[10]_i_34_n_0 ;
  wire \bram_addr[10]_i_35_n_0 ;
  wire \bram_addr[10]_i_36_n_0 ;
  wire \bram_addr[10]_i_38_n_0 ;
  wire \bram_addr[10]_i_39_n_0 ;
  wire \bram_addr[10]_i_40_n_0 ;
  wire \bram_addr[10]_i_41_n_0 ;
  wire \bram_addr[10]_i_42_n_0 ;
  wire \bram_addr[10]_i_43_n_0 ;
  wire \bram_addr[10]_i_45_n_0 ;
  wire \bram_addr[10]_i_47_n_0 ;
  wire \bram_addr[10]_i_48_n_0 ;
  wire \bram_addr[10]_i_49_n_0 ;
  wire \bram_addr[10]_i_4_n_0 ;
  wire \bram_addr[10]_i_5_n_0 ;
  wire \bram_addr[10]_i_7_n_0 ;
  wire \bram_addr[10]_i_8_n_0 ;
  wire \bram_addr[10]_i_9_n_0 ;
  wire \bram_addr[1]_i_2_n_0 ;
  wire \bram_addr[1]_i_3_n_0 ;
  wire \bram_addr[1]_i_4_n_0 ;
  wire \bram_addr[1]_i_6_n_0 ;
  wire \bram_addr[2]_i_11_n_0 ;
  wire \bram_addr[2]_i_12_n_0 ;
  wire \bram_addr[2]_i_13_n_0 ;
  wire \bram_addr[2]_i_14_n_0 ;
  wire \bram_addr[2]_i_1_n_0 ;
  wire \bram_addr[2]_i_3_n_0 ;
  wire \bram_addr[2]_i_4_n_0 ;
  wire \bram_addr[2]_i_5_n_0 ;
  wire \bram_addr[2]_i_6_n_0 ;
  wire \bram_addr[2]_i_7_n_0 ;
  wire \bram_addr[2]_i_8_n_0 ;
  wire \bram_addr[2]_i_9_n_0 ;
  wire \bram_addr[3]_i_2_n_0 ;
  wire \bram_addr[3]_i_3_n_0 ;
  wire \bram_addr[3]_i_4_n_0 ;
  wire \bram_addr[3]_i_5_n_0 ;
  wire \bram_addr[4]_i_2_n_0 ;
  wire \bram_addr[4]_i_3_n_0 ;
  wire \bram_addr[4]_i_4_n_0 ;
  wire \bram_addr[4]_i_6_n_0 ;
  wire \bram_addr[5]_i_10_n_0 ;
  wire \bram_addr[5]_i_2_n_0 ;
  wire \bram_addr[5]_i_3_n_0 ;
  wire \bram_addr[5]_i_5_n_0 ;
  wire \bram_addr[5]_i_6_n_0 ;
  wire \bram_addr[5]_i_8_n_0 ;
  wire \bram_addr[6]_i_2_n_0 ;
  wire \bram_addr[6]_i_3_n_0 ;
  wire \bram_addr[6]_i_4_n_0 ;
  wire \bram_addr[6]_i_5_n_0 ;
  wire \bram_addr[7]_i_2_n_0 ;
  wire \bram_addr[7]_i_3_n_0 ;
  wire \bram_addr[7]_i_4_n_0 ;
  wire \bram_addr[7]_i_5_n_0 ;
  wire \bram_addr[8]_i_2_n_0 ;
  wire \bram_addr[8]_i_3_n_0 ;
  wire \bram_addr[8]_i_4_n_0 ;
  wire \bram_addr[8]_i_5_n_0 ;
  wire \bram_addr[8]_i_6_n_0 ;
  wire \bram_addr[9]_i_1_n_0 ;
  wire \bram_addr[9]_i_2_n_0 ;
  wire \bram_addr[9]_i_3_n_0 ;
  wire \bram_addr_reg[10]_i_14_n_0 ;
  wire \bram_addr_reg[10]_i_14_n_1 ;
  wire \bram_addr_reg[10]_i_14_n_2 ;
  wire \bram_addr_reg[10]_i_14_n_3 ;
  wire \bram_addr_reg[10]_i_46_n_0 ;
  wire \bram_addr_reg[10]_i_46_n_1 ;
  wire \bram_addr_reg[10]_i_46_n_2 ;
  wire \bram_addr_reg[10]_i_46_n_3 ;
  wire \bram_addr_reg[10]_i_6_n_3 ;
  wire \bram_addr_reg[1]_i_1_n_0 ;
  wire \bram_addr_reg[2]_i_10_n_0 ;
  wire \bram_addr_reg[2]_i_10_n_1 ;
  wire \bram_addr_reg[2]_i_10_n_2 ;
  wire \bram_addr_reg[2]_i_10_n_3 ;
  wire \bram_addr_reg[2]_i_2_n_0 ;
  wire \bram_addr_reg[2]_i_2_n_1 ;
  wire \bram_addr_reg[2]_i_2_n_2 ;
  wire \bram_addr_reg[2]_i_2_n_3 ;
  wire \bram_addr_reg[3]_i_1_n_0 ;
  wire \bram_addr_reg[4]_i_1_n_0 ;
  wire \bram_addr_reg[5]_i_1_n_0 ;
  wire \bram_addr_reg[5]_i_4_n_0 ;
  wire \bram_addr_reg[6]_i_1_n_0 ;
  wire \bram_addr_reg[7]_i_1_n_0 ;
  wire \bram_addr_reg[8]_i_1_n_0 ;
  wire \bram_addr_reg_n_0_[0] ;
  wire \bram_addr_reg_n_0_[10] ;
  wire \bram_addr_reg_n_0_[1] ;
  wire \bram_addr_reg_n_0_[2] ;
  wire \bram_addr_reg_n_0_[3] ;
  wire \bram_addr_reg_n_0_[4] ;
  wire \bram_addr_reg_n_0_[5] ;
  wire \bram_addr_reg_n_0_[6] ;
  wire \bram_addr_reg_n_0_[7] ;
  wire \bram_addr_reg_n_0_[8] ;
  wire \bram_addr_reg_n_0_[9] ;
  wire bram_addr_reg_rep_0_i_10_n_0;
  wire bram_addr_reg_rep_0_i_11_n_0;
  wire bram_addr_reg_rep_0_i_12_n_0;
  wire bram_addr_reg_rep_0_i_13_n_0;
  wire bram_addr_reg_rep_0_i_14_n_0;
  wire bram_addr_reg_rep_0_i_15_n_0;
  wire bram_addr_reg_rep_0_i_1_n_0;
  wire bram_addr_reg_rep_0_i_2_n_0;
  wire bram_addr_reg_rep_0_i_3_n_0;
  wire bram_addr_reg_rep_0_i_4_n_0;
  wire bram_addr_reg_rep_0_i_5_n_0;
  wire bram_addr_reg_rep_0_i_6_n_0;
  wire bram_addr_reg_rep_0_i_7_n_0;
  wire bram_addr_reg_rep_0_i_8_n_0;
  wire bram_addr_reg_rep_0_i_9_n_0;
  wire bram_addr_reg_rep_0_n_20;
  wire bram_addr_reg_rep_0_n_21;
  wire bram_addr_reg_rep_0_n_22;
  wire bram_addr_reg_rep_0_n_23;
  wire bram_addr_reg_rep_0_n_24;
  wire bram_addr_reg_rep_0_n_25;
  wire bram_addr_reg_rep_0_n_26;
  wire bram_addr_reg_rep_0_n_27;
  wire bram_addr_reg_rep_0_n_28;
  wire bram_addr_reg_rep_0_n_29;
  wire bram_addr_reg_rep_0_n_30;
  wire bram_addr_reg_rep_0_n_31;
  wire bram_addr_reg_rep_0_n_32;
  wire bram_addr_reg_rep_0_n_33;
  wire bram_addr_reg_rep_0_n_34;
  wire bram_addr_reg_rep_0_n_35;
  wire bram_addr_reg_rep_1_n_20;
  wire bram_addr_reg_rep_1_n_21;
  wire bram_addr_reg_rep_1_n_22;
  wire bram_addr_reg_rep_1_n_23;
  wire bram_addr_reg_rep_1_n_24;
  wire bram_addr_reg_rep_1_n_25;
  wire bram_addr_reg_rep_1_n_26;
  wire bram_addr_reg_rep_1_n_27;
  wire bram_addr_reg_rep_1_n_28;
  wire bram_addr_reg_rep_1_n_29;
  wire bram_addr_reg_rep_1_n_30;
  wire bram_addr_reg_rep_1_n_31;
  wire bram_addr_reg_rep_1_n_32;
  wire bram_addr_reg_rep_1_n_33;
  wire bram_addr_reg_rep_1_n_34;
  wire bram_addr_reg_rep_1_n_35;
  wire clk;
  wire [5:1]feat_cnt;
  wire \feat_cnt[0]_i_1_n_0 ;
  wire \feat_cnt[5]_i_1_n_0 ;
  wire \feat_cnt_reg_n_0_[0] ;
  wire \feat_cnt_reg_n_0_[1] ;
  wire \feat_cnt_reg_n_0_[2] ;
  wire \feat_cnt_reg_n_0_[3] ;
  wire \feat_cnt_reg_n_0_[4] ;
  wire \feat_cnt_reg_n_0_[5] ;
  wire [31:0]feat_data;
  wire [5:0]feat_index;
  wire feat_ready;
  wire [5:0]feat_save_idx;
  wire [0:0]feat_save_idx__0;
  wire feat_valid;
  wire g0_b0_n_0;
  wire h1_reg_0_63_0_2_i_104_n_0;
  wire h1_reg_0_63_0_2_i_105_n_0;
  wire h1_reg_0_63_0_2_i_106_n_0;
  wire h1_reg_0_63_0_2_i_107_n_0;
  wire h1_reg_0_63_0_2_i_108_n_0;
  wire h1_reg_0_63_0_2_i_109_n_0;
  wire h1_reg_0_63_0_2_i_10_n_0;
  wire h1_reg_0_63_0_2_i_110_n_0;
  wire h1_reg_0_63_0_2_i_111_n_0;
  wire h1_reg_0_63_0_2_i_112_n_0;
  wire h1_reg_0_63_0_2_i_113_n_0;
  wire h1_reg_0_63_0_2_i_114_n_0;
  wire h1_reg_0_63_0_2_i_115_n_0;
  wire h1_reg_0_63_0_2_i_118_n_0;
  wire h1_reg_0_63_0_2_i_119_n_0;
  wire h1_reg_0_63_0_2_i_11_n_0;
  wire h1_reg_0_63_0_2_i_120_n_0;
  wire h1_reg_0_63_0_2_i_121_n_0;
  wire h1_reg_0_63_0_2_i_122_n_0;
  wire h1_reg_0_63_0_2_i_123_n_0;
  wire h1_reg_0_63_0_2_i_124_n_0;
  wire h1_reg_0_63_0_2_i_125_n_0;
  wire h1_reg_0_63_0_2_i_126_n_0;
  wire h1_reg_0_63_0_2_i_127_n_0;
  wire h1_reg_0_63_0_2_i_128_n_0;
  wire h1_reg_0_63_0_2_i_129_n_0;
  wire h1_reg_0_63_0_2_i_12_n_0;
  wire h1_reg_0_63_0_2_i_130_n_0;
  wire h1_reg_0_63_0_2_i_131_n_0;
  wire h1_reg_0_63_0_2_i_132_n_0;
  wire h1_reg_0_63_0_2_i_133_n_0;
  wire h1_reg_0_63_0_2_i_134_n_0;
  wire h1_reg_0_63_0_2_i_135_n_0;
  wire h1_reg_0_63_0_2_i_136_n_0;
  wire h1_reg_0_63_0_2_i_137_n_0;
  wire h1_reg_0_63_0_2_i_138_n_0;
  wire h1_reg_0_63_0_2_i_139_n_0;
  wire h1_reg_0_63_0_2_i_13_n_0;
  wire h1_reg_0_63_0_2_i_140_n_0;
  wire h1_reg_0_63_0_2_i_141_n_0;
  wire h1_reg_0_63_0_2_i_142_n_0;
  wire h1_reg_0_63_0_2_i_143_n_0;
  wire h1_reg_0_63_0_2_i_144_n_0;
  wire h1_reg_0_63_0_2_i_145_n_0;
  wire h1_reg_0_63_0_2_i_146_n_0;
  wire h1_reg_0_63_0_2_i_147_n_0;
  wire h1_reg_0_63_0_2_i_148_n_0;
  wire h1_reg_0_63_0_2_i_149_n_0;
  wire h1_reg_0_63_0_2_i_14_n_0;
  wire h1_reg_0_63_0_2_i_150_n_0;
  wire h1_reg_0_63_0_2_i_151_n_0;
  wire h1_reg_0_63_0_2_i_152_n_0;
  wire h1_reg_0_63_0_2_i_153_n_0;
  wire h1_reg_0_63_0_2_i_154_n_0;
  wire h1_reg_0_63_0_2_i_155_n_0;
  wire h1_reg_0_63_0_2_i_156_n_0;
  wire h1_reg_0_63_0_2_i_157_n_0;
  wire h1_reg_0_63_0_2_i_158_n_0;
  wire h1_reg_0_63_0_2_i_159_n_0;
  wire h1_reg_0_63_0_2_i_15_n_0;
  wire h1_reg_0_63_0_2_i_160_n_0;
  wire h1_reg_0_63_0_2_i_161_n_0;
  wire h1_reg_0_63_0_2_i_162_n_0;
  wire h1_reg_0_63_0_2_i_163_n_0;
  wire h1_reg_0_63_0_2_i_163_n_1;
  wire h1_reg_0_63_0_2_i_163_n_2;
  wire h1_reg_0_63_0_2_i_163_n_3;
  wire h1_reg_0_63_0_2_i_164_n_0;
  wire h1_reg_0_63_0_2_i_165_n_0;
  wire h1_reg_0_63_0_2_i_166_n_0;
  wire h1_reg_0_63_0_2_i_167_n_0;
  wire h1_reg_0_63_0_2_i_168_n_0;
  wire h1_reg_0_63_0_2_i_169_n_0;
  wire h1_reg_0_63_0_2_i_16_n_0;
  wire h1_reg_0_63_0_2_i_16_n_1;
  wire h1_reg_0_63_0_2_i_16_n_2;
  wire h1_reg_0_63_0_2_i_16_n_3;
  wire h1_reg_0_63_0_2_i_170_n_0;
  wire h1_reg_0_63_0_2_i_171_n_0;
  wire h1_reg_0_63_0_2_i_172_n_0;
  wire h1_reg_0_63_0_2_i_173_n_0;
  wire h1_reg_0_63_0_2_i_174_n_0;
  wire h1_reg_0_63_0_2_i_175_n_0;
  wire h1_reg_0_63_0_2_i_176_n_0;
  wire h1_reg_0_63_0_2_i_177_n_0;
  wire h1_reg_0_63_0_2_i_178_n_0;
  wire h1_reg_0_63_0_2_i_179_n_0;
  wire h1_reg_0_63_0_2_i_17_n_0;
  wire h1_reg_0_63_0_2_i_180_n_0;
  wire h1_reg_0_63_0_2_i_181_n_0;
  wire h1_reg_0_63_0_2_i_182_n_0;
  wire h1_reg_0_63_0_2_i_183_n_0;
  wire h1_reg_0_63_0_2_i_184_n_0;
  wire h1_reg_0_63_0_2_i_185_n_0;
  wire h1_reg_0_63_0_2_i_186_n_0;
  wire h1_reg_0_63_0_2_i_187_n_0;
  wire h1_reg_0_63_0_2_i_188_n_0;
  wire h1_reg_0_63_0_2_i_189_n_0;
  wire h1_reg_0_63_0_2_i_18_n_0;
  wire h1_reg_0_63_0_2_i_190_n_0;
  wire h1_reg_0_63_0_2_i_191_n_0;
  wire h1_reg_0_63_0_2_i_192_n_0;
  wire h1_reg_0_63_0_2_i_193_n_0;
  wire h1_reg_0_63_0_2_i_194_n_0;
  wire h1_reg_0_63_0_2_i_195_n_0;
  wire h1_reg_0_63_0_2_i_196_n_0;
  wire h1_reg_0_63_0_2_i_197_n_0;
  wire h1_reg_0_63_0_2_i_198_n_0;
  wire h1_reg_0_63_0_2_i_198_n_1;
  wire h1_reg_0_63_0_2_i_198_n_2;
  wire h1_reg_0_63_0_2_i_198_n_3;
  wire h1_reg_0_63_0_2_i_199_n_0;
  wire h1_reg_0_63_0_2_i_19_n_0;
  wire h1_reg_0_63_0_2_i_200_n_0;
  wire h1_reg_0_63_0_2_i_201_n_0;
  wire h1_reg_0_63_0_2_i_202_n_0;
  wire h1_reg_0_63_0_2_i_203_n_0;
  wire h1_reg_0_63_0_2_i_204_n_0;
  wire h1_reg_0_63_0_2_i_205_n_0;
  wire h1_reg_0_63_0_2_i_206_n_0;
  wire h1_reg_0_63_0_2_i_207_n_0;
  wire h1_reg_0_63_0_2_i_208_n_0;
  wire h1_reg_0_63_0_2_i_209_n_0;
  wire h1_reg_0_63_0_2_i_20_n_0;
  wire h1_reg_0_63_0_2_i_210_n_0;
  wire h1_reg_0_63_0_2_i_211_n_0;
  wire h1_reg_0_63_0_2_i_212_n_0;
  wire h1_reg_0_63_0_2_i_213_n_0;
  wire h1_reg_0_63_0_2_i_214_n_0;
  wire h1_reg_0_63_0_2_i_215_n_0;
  wire h1_reg_0_63_0_2_i_216_n_0;
  wire h1_reg_0_63_0_2_i_217_n_0;
  wire h1_reg_0_63_0_2_i_218_n_0;
  wire h1_reg_0_63_0_2_i_219_n_0;
  wire h1_reg_0_63_0_2_i_21_n_0;
  wire h1_reg_0_63_0_2_i_220_n_0;
  wire h1_reg_0_63_0_2_i_221_n_0;
  wire h1_reg_0_63_0_2_i_222_n_0;
  wire h1_reg_0_63_0_2_i_223_n_0;
  wire h1_reg_0_63_0_2_i_224_n_0;
  wire h1_reg_0_63_0_2_i_224_n_1;
  wire h1_reg_0_63_0_2_i_224_n_2;
  wire h1_reg_0_63_0_2_i_224_n_3;
  wire h1_reg_0_63_0_2_i_225_n_0;
  wire h1_reg_0_63_0_2_i_226_n_0;
  wire h1_reg_0_63_0_2_i_227_n_0;
  wire h1_reg_0_63_0_2_i_228_n_0;
  wire h1_reg_0_63_0_2_i_229_n_0;
  wire h1_reg_0_63_0_2_i_22_n_0;
  wire h1_reg_0_63_0_2_i_22_n_1;
  wire h1_reg_0_63_0_2_i_22_n_2;
  wire h1_reg_0_63_0_2_i_22_n_3;
  wire h1_reg_0_63_0_2_i_22_n_4;
  wire h1_reg_0_63_0_2_i_22_n_5;
  wire h1_reg_0_63_0_2_i_22_n_6;
  wire h1_reg_0_63_0_2_i_22_n_7;
  wire h1_reg_0_63_0_2_i_230_n_0;
  wire h1_reg_0_63_0_2_i_231_n_0;
  wire h1_reg_0_63_0_2_i_232_n_0;
  wire h1_reg_0_63_0_2_i_233_n_0;
  wire h1_reg_0_63_0_2_i_234_n_0;
  wire h1_reg_0_63_0_2_i_235_n_0;
  wire h1_reg_0_63_0_2_i_236_n_0;
  wire h1_reg_0_63_0_2_i_237_n_0;
  wire h1_reg_0_63_0_2_i_238_n_0;
  wire h1_reg_0_63_0_2_i_239_n_0;
  wire h1_reg_0_63_0_2_i_240_n_0;
  wire h1_reg_0_63_0_2_i_241_n_0;
  wire h1_reg_0_63_0_2_i_242_n_0;
  wire h1_reg_0_63_0_2_i_243_n_0;
  wire h1_reg_0_63_0_2_i_244_n_0;
  wire h1_reg_0_63_0_2_i_245_n_0;
  wire h1_reg_0_63_0_2_i_246_n_0;
  wire h1_reg_0_63_0_2_i_247_n_0;
  wire h1_reg_0_63_0_2_i_248_n_0;
  wire h1_reg_0_63_0_2_i_249_n_0;
  wire h1_reg_0_63_0_2_i_250_n_0;
  wire h1_reg_0_63_0_2_i_251_n_0;
  wire h1_reg_0_63_0_2_i_252_n_0;
  wire h1_reg_0_63_0_2_i_252_n_1;
  wire h1_reg_0_63_0_2_i_252_n_2;
  wire h1_reg_0_63_0_2_i_252_n_3;
  wire h1_reg_0_63_0_2_i_253_n_0;
  wire h1_reg_0_63_0_2_i_254_n_0;
  wire h1_reg_0_63_0_2_i_255_n_0;
  wire h1_reg_0_63_0_2_i_256_n_0;
  wire h1_reg_0_63_0_2_i_257_n_0;
  wire h1_reg_0_63_0_2_i_258_n_0;
  wire h1_reg_0_63_0_2_i_259_n_0;
  wire h1_reg_0_63_0_2_i_260_n_0;
  wire h1_reg_0_63_0_2_i_261_n_0;
  wire h1_reg_0_63_0_2_i_262_n_0;
  wire h1_reg_0_63_0_2_i_263_n_0;
  wire h1_reg_0_63_0_2_i_264_n_0;
  wire h1_reg_0_63_0_2_i_265_n_0;
  wire h1_reg_0_63_0_2_i_266_n_0;
  wire h1_reg_0_63_0_2_i_267_n_0;
  wire h1_reg_0_63_0_2_i_268_n_0;
  wire h1_reg_0_63_0_2_i_269_n_0;
  wire h1_reg_0_63_0_2_i_26_n_0;
  wire h1_reg_0_63_0_2_i_270_n_0;
  wire h1_reg_0_63_0_2_i_271_n_0;
  wire h1_reg_0_63_0_2_i_272_n_0;
  wire h1_reg_0_63_0_2_i_273_n_0;
  wire h1_reg_0_63_0_2_i_274_n_0;
  wire h1_reg_0_63_0_2_i_275_n_0;
  wire h1_reg_0_63_0_2_i_276_n_0;
  wire h1_reg_0_63_0_2_i_277_n_0;
  wire h1_reg_0_63_0_2_i_278_n_0;
  wire h1_reg_0_63_0_2_i_279_n_0;
  wire h1_reg_0_63_0_2_i_27_n_0;
  wire h1_reg_0_63_0_2_i_280_n_0;
  wire h1_reg_0_63_0_2_i_281_n_0;
  wire h1_reg_0_63_0_2_i_282_n_0;
  wire h1_reg_0_63_0_2_i_283_n_0;
  wire h1_reg_0_63_0_2_i_284_n_0;
  wire h1_reg_0_63_0_2_i_285_n_0;
  wire h1_reg_0_63_0_2_i_286_n_0;
  wire h1_reg_0_63_0_2_i_287_n_0;
  wire h1_reg_0_63_0_2_i_288_n_0;
  wire h1_reg_0_63_0_2_i_289_n_0;
  wire h1_reg_0_63_0_2_i_28_n_0;
  wire h1_reg_0_63_0_2_i_290_n_0;
  wire h1_reg_0_63_0_2_i_291_n_0;
  wire h1_reg_0_63_0_2_i_292_n_0;
  wire h1_reg_0_63_0_2_i_293_n_0;
  wire h1_reg_0_63_0_2_i_294_n_0;
  wire h1_reg_0_63_0_2_i_295_n_0;
  wire h1_reg_0_63_0_2_i_296_n_0;
  wire h1_reg_0_63_0_2_i_297_n_0;
  wire h1_reg_0_63_0_2_i_298_n_0;
  wire h1_reg_0_63_0_2_i_299_n_0;
  wire h1_reg_0_63_0_2_i_29_n_0;
  wire h1_reg_0_63_0_2_i_300_n_0;
  wire h1_reg_0_63_0_2_i_301_n_0;
  wire h1_reg_0_63_0_2_i_302_n_0;
  wire h1_reg_0_63_0_2_i_303_n_0;
  wire h1_reg_0_63_0_2_i_304_n_0;
  wire h1_reg_0_63_0_2_i_305_n_0;
  wire h1_reg_0_63_0_2_i_306_n_0;
  wire h1_reg_0_63_0_2_i_307_n_0;
  wire h1_reg_0_63_0_2_i_308_n_0;
  wire h1_reg_0_63_0_2_i_309_n_0;
  wire h1_reg_0_63_0_2_i_30_n_0;
  wire h1_reg_0_63_0_2_i_310_n_0;
  wire h1_reg_0_63_0_2_i_311_n_0;
  wire h1_reg_0_63_0_2_i_312_n_0;
  wire h1_reg_0_63_0_2_i_313_n_0;
  wire h1_reg_0_63_0_2_i_314_n_0;
  wire h1_reg_0_63_0_2_i_315_n_0;
  wire h1_reg_0_63_0_2_i_316_n_0;
  wire h1_reg_0_63_0_2_i_317_n_0;
  wire h1_reg_0_63_0_2_i_318_n_0;
  wire h1_reg_0_63_0_2_i_319_n_0;
  wire h1_reg_0_63_0_2_i_31_n_0;
  wire h1_reg_0_63_0_2_i_320_n_0;
  wire h1_reg_0_63_0_2_i_321_n_0;
  wire h1_reg_0_63_0_2_i_322_n_0;
  wire h1_reg_0_63_0_2_i_323_n_0;
  wire h1_reg_0_63_0_2_i_324_n_0;
  wire h1_reg_0_63_0_2_i_325_n_0;
  wire h1_reg_0_63_0_2_i_326_n_0;
  wire h1_reg_0_63_0_2_i_327_n_0;
  wire h1_reg_0_63_0_2_i_328_n_0;
  wire h1_reg_0_63_0_2_i_329_n_0;
  wire h1_reg_0_63_0_2_i_32_n_0;
  wire h1_reg_0_63_0_2_i_33_n_0;
  wire h1_reg_0_63_0_2_i_34_n_0;
  wire h1_reg_0_63_0_2_i_35_n_0;
  wire h1_reg_0_63_0_2_i_36_n_0;
  wire h1_reg_0_63_0_2_i_37_n_0;
  wire h1_reg_0_63_0_2_i_38_n_0;
  wire h1_reg_0_63_0_2_i_39_n_0;
  wire h1_reg_0_63_0_2_i_40_n_0;
  wire h1_reg_0_63_0_2_i_40_n_1;
  wire h1_reg_0_63_0_2_i_40_n_2;
  wire h1_reg_0_63_0_2_i_40_n_3;
  wire h1_reg_0_63_0_2_i_41_n_0;
  wire h1_reg_0_63_0_2_i_42_n_0;
  wire h1_reg_0_63_0_2_i_43_n_0;
  wire h1_reg_0_63_0_2_i_44_n_0;
  wire h1_reg_0_63_0_2_i_45_n_0;
  wire h1_reg_0_63_0_2_i_46_n_0;
  wire h1_reg_0_63_0_2_i_47_n_0;
  wire h1_reg_0_63_0_2_i_48_n_0;
  wire h1_reg_0_63_0_2_i_49_n_0;
  wire h1_reg_0_63_0_2_i_4_n_0;
  wire h1_reg_0_63_0_2_i_50_n_0;
  wire h1_reg_0_63_0_2_i_51_n_0;
  wire h1_reg_0_63_0_2_i_52_n_0;
  wire h1_reg_0_63_0_2_i_53_n_0;
  wire h1_reg_0_63_0_2_i_54_n_0;
  wire h1_reg_0_63_0_2_i_55_n_0;
  wire h1_reg_0_63_0_2_i_56_n_0;
  wire h1_reg_0_63_0_2_i_57_n_0;
  wire h1_reg_0_63_0_2_i_58_n_0;
  wire h1_reg_0_63_0_2_i_58_n_1;
  wire h1_reg_0_63_0_2_i_58_n_2;
  wire h1_reg_0_63_0_2_i_58_n_3;
  wire h1_reg_0_63_0_2_i_58_n_4;
  wire h1_reg_0_63_0_2_i_58_n_5;
  wire h1_reg_0_63_0_2_i_58_n_6;
  wire h1_reg_0_63_0_2_i_58_n_7;
  wire h1_reg_0_63_0_2_i_5_n_0;
  wire h1_reg_0_63_0_2_i_63_n_0;
  wire h1_reg_0_63_0_2_i_64_n_0;
  wire h1_reg_0_63_0_2_i_65_n_0;
  wire h1_reg_0_63_0_2_i_66_n_0;
  wire h1_reg_0_63_0_2_i_67_n_0;
  wire h1_reg_0_63_0_2_i_68_n_0;
  wire h1_reg_0_63_0_2_i_69_n_0;
  wire h1_reg_0_63_0_2_i_69_n_1;
  wire h1_reg_0_63_0_2_i_69_n_2;
  wire h1_reg_0_63_0_2_i_69_n_3;
  wire h1_reg_0_63_0_2_i_69_n_4;
  wire h1_reg_0_63_0_2_i_69_n_5;
  wire h1_reg_0_63_0_2_i_69_n_6;
  wire h1_reg_0_63_0_2_i_69_n_7;
  wire h1_reg_0_63_0_2_i_6_n_3;
  wire h1_reg_0_63_0_2_i_70_n_0;
  wire h1_reg_0_63_0_2_i_70_n_1;
  wire h1_reg_0_63_0_2_i_70_n_2;
  wire h1_reg_0_63_0_2_i_70_n_3;
  wire h1_reg_0_63_0_2_i_70_n_4;
  wire h1_reg_0_63_0_2_i_70_n_5;
  wire h1_reg_0_63_0_2_i_70_n_6;
  wire h1_reg_0_63_0_2_i_70_n_7;
  wire h1_reg_0_63_0_2_i_71_n_0;
  wire h1_reg_0_63_0_2_i_71_n_1;
  wire h1_reg_0_63_0_2_i_71_n_2;
  wire h1_reg_0_63_0_2_i_71_n_3;
  wire h1_reg_0_63_0_2_i_71_n_4;
  wire h1_reg_0_63_0_2_i_71_n_5;
  wire h1_reg_0_63_0_2_i_71_n_6;
  wire h1_reg_0_63_0_2_i_71_n_7;
  wire h1_reg_0_63_0_2_i_72_n_0;
  wire h1_reg_0_63_0_2_i_72_n_1;
  wire h1_reg_0_63_0_2_i_72_n_2;
  wire h1_reg_0_63_0_2_i_72_n_3;
  wire h1_reg_0_63_0_2_i_72_n_4;
  wire h1_reg_0_63_0_2_i_72_n_5;
  wire h1_reg_0_63_0_2_i_72_n_6;
  wire h1_reg_0_63_0_2_i_72_n_7;
  wire h1_reg_0_63_0_2_i_73_n_0;
  wire h1_reg_0_63_0_2_i_73_n_1;
  wire h1_reg_0_63_0_2_i_73_n_2;
  wire h1_reg_0_63_0_2_i_73_n_3;
  wire h1_reg_0_63_0_2_i_73_n_4;
  wire h1_reg_0_63_0_2_i_73_n_5;
  wire h1_reg_0_63_0_2_i_73_n_6;
  wire h1_reg_0_63_0_2_i_73_n_7;
  wire h1_reg_0_63_0_2_i_74_n_0;
  wire h1_reg_0_63_0_2_i_74_n_1;
  wire h1_reg_0_63_0_2_i_74_n_2;
  wire h1_reg_0_63_0_2_i_74_n_3;
  wire h1_reg_0_63_0_2_i_74_n_4;
  wire h1_reg_0_63_0_2_i_74_n_5;
  wire h1_reg_0_63_0_2_i_74_n_6;
  wire h1_reg_0_63_0_2_i_74_n_7;
  wire h1_reg_0_63_0_2_i_75_n_0;
  wire h1_reg_0_63_0_2_i_75_n_1;
  wire h1_reg_0_63_0_2_i_75_n_2;
  wire h1_reg_0_63_0_2_i_75_n_3;
  wire h1_reg_0_63_0_2_i_75_n_4;
  wire h1_reg_0_63_0_2_i_75_n_5;
  wire h1_reg_0_63_0_2_i_75_n_6;
  wire h1_reg_0_63_0_2_i_75_n_7;
  wire h1_reg_0_63_0_2_i_76_n_0;
  wire h1_reg_0_63_0_2_i_76_n_1;
  wire h1_reg_0_63_0_2_i_76_n_2;
  wire h1_reg_0_63_0_2_i_76_n_3;
  wire h1_reg_0_63_0_2_i_76_n_4;
  wire h1_reg_0_63_0_2_i_76_n_5;
  wire h1_reg_0_63_0_2_i_76_n_6;
  wire h1_reg_0_63_0_2_i_76_n_7;
  wire h1_reg_0_63_0_2_i_77_n_0;
  wire h1_reg_0_63_0_2_i_77_n_1;
  wire h1_reg_0_63_0_2_i_77_n_2;
  wire h1_reg_0_63_0_2_i_77_n_3;
  wire h1_reg_0_63_0_2_i_77_n_4;
  wire h1_reg_0_63_0_2_i_77_n_5;
  wire h1_reg_0_63_0_2_i_77_n_6;
  wire h1_reg_0_63_0_2_i_77_n_7;
  wire h1_reg_0_63_0_2_i_78_n_0;
  wire h1_reg_0_63_0_2_i_78_n_1;
  wire h1_reg_0_63_0_2_i_78_n_2;
  wire h1_reg_0_63_0_2_i_78_n_3;
  wire h1_reg_0_63_0_2_i_78_n_4;
  wire h1_reg_0_63_0_2_i_78_n_5;
  wire h1_reg_0_63_0_2_i_78_n_6;
  wire h1_reg_0_63_0_2_i_78_n_7;
  wire h1_reg_0_63_0_2_i_79_n_0;
  wire h1_reg_0_63_0_2_i_79_n_1;
  wire h1_reg_0_63_0_2_i_79_n_2;
  wire h1_reg_0_63_0_2_i_79_n_3;
  wire h1_reg_0_63_0_2_i_79_n_4;
  wire h1_reg_0_63_0_2_i_79_n_5;
  wire h1_reg_0_63_0_2_i_79_n_6;
  wire h1_reg_0_63_0_2_i_79_n_7;
  wire h1_reg_0_63_0_2_i_7_n_0;
  wire h1_reg_0_63_0_2_i_80_n_0;
  wire h1_reg_0_63_0_2_i_80_n_1;
  wire h1_reg_0_63_0_2_i_80_n_2;
  wire h1_reg_0_63_0_2_i_80_n_3;
  wire h1_reg_0_63_0_2_i_80_n_4;
  wire h1_reg_0_63_0_2_i_80_n_5;
  wire h1_reg_0_63_0_2_i_80_n_6;
  wire h1_reg_0_63_0_2_i_80_n_7;
  wire h1_reg_0_63_0_2_i_81_n_0;
  wire h1_reg_0_63_0_2_i_81_n_1;
  wire h1_reg_0_63_0_2_i_81_n_2;
  wire h1_reg_0_63_0_2_i_81_n_3;
  wire h1_reg_0_63_0_2_i_81_n_4;
  wire h1_reg_0_63_0_2_i_81_n_5;
  wire h1_reg_0_63_0_2_i_81_n_6;
  wire h1_reg_0_63_0_2_i_81_n_7;
  wire h1_reg_0_63_0_2_i_82_n_0;
  wire h1_reg_0_63_0_2_i_82_n_1;
  wire h1_reg_0_63_0_2_i_82_n_2;
  wire h1_reg_0_63_0_2_i_82_n_3;
  wire h1_reg_0_63_0_2_i_83_n_0;
  wire h1_reg_0_63_0_2_i_84_n_0;
  wire h1_reg_0_63_0_2_i_85_n_0;
  wire h1_reg_0_63_0_2_i_86_n_0;
  wire h1_reg_0_63_0_2_i_87_n_0;
  wire h1_reg_0_63_0_2_i_88_n_0;
  wire h1_reg_0_63_0_2_i_89_n_0;
  wire h1_reg_0_63_0_2_i_8_n_1;
  wire h1_reg_0_63_0_2_i_8_n_2;
  wire h1_reg_0_63_0_2_i_8_n_3;
  wire h1_reg_0_63_0_2_i_8_n_4;
  wire h1_reg_0_63_0_2_i_8_n_5;
  wire h1_reg_0_63_0_2_i_8_n_6;
  wire h1_reg_0_63_0_2_i_8_n_7;
  wire h1_reg_0_63_0_2_i_90_n_0;
  wire h1_reg_0_63_0_2_i_91_n_0;
  wire h1_reg_0_63_0_2_i_92_n_0;
  wire h1_reg_0_63_0_2_i_93_n_0;
  wire h1_reg_0_63_0_2_i_94_n_0;
  wire h1_reg_0_63_0_2_i_95_n_0;
  wire h1_reg_0_63_0_2_i_96_n_0;
  wire h1_reg_0_63_0_2_i_97_n_0;
  wire h1_reg_0_63_0_2_i_98_n_0;
  wire h1_reg_0_63_0_2_i_99_n_0;
  wire h1_reg_0_63_0_2_i_9_n_0;
  wire h1_reg_0_63_3_5_i_10_n_0;
  wire h1_reg_0_63_3_5_i_11_n_0;
  wire h1_reg_0_63_3_5_i_12_n_0;
  wire h1_reg_0_63_3_5_i_4_n_0;
  wire h1_reg_0_63_3_5_i_5_n_0;
  wire h1_reg_0_63_3_5_i_6_n_0;
  wire h1_reg_0_63_3_5_i_7_n_0;
  wire h1_reg_0_63_3_5_i_8_n_0;
  wire h1_reg_0_63_3_5_i_9_n_0;
  wire h1_reg_0_63_6_7_i_2_n_0;
  wire h1_reg_0_63_6_7_i_3_n_0;
  wire h1_reg_0_63_6_7_i_4_n_0;
  wire h2_reg_0_31_0_5_i_1_n_0;
  wire h2_reg_0_31_0_5_n_0;
  wire h2_reg_0_31_0_5_n_1;
  wire h2_reg_0_31_0_5_n_2;
  wire h2_reg_0_31_0_5_n_3;
  wire h2_reg_0_31_0_5_n_4;
  wire h2_reg_0_31_0_5_n_5;
  wire h2_reg_0_31_6_7__0_n_0;
  wire h2_reg_0_31_6_7_n_0;
  wire [6:0]hidden_activation;
  wire [8:1]in31;
  wire [10:1]in32;
  wire [10:3]in33;
  wire \layer[0]_i_1_n_0 ;
  wire \layer[1]_i_1_n_0 ;
  wire \layer[1]_i_2_n_0 ;
  wire [5:5]layer_last;
  wire \layer_reg_n_0_[0] ;
  wire \layer_reg_n_0_[1] ;
  wire [0:0]logits;
  wire \logits[0][31]_i_2_n_0 ;
  wire \logits[0][31]_i_3_n_0 ;
  wire \logits[0][31]_i_4_n_0 ;
  wire \logits[1][31]_i_1_n_0 ;
  wire \logits[1][31]_i_2_n_0 ;
  wire \logits[2][31]_i_1_n_0 ;
  wire \logits[3][31]_i_1_n_0 ;
  wire \logits[3][31]_i_2_n_0 ;
  wire \logits[4][31]_i_1_n_0 ;
  wire \logits[4][31]_i_2_n_0 ;
  wire [31:0]\logits_reg[0] ;
  wire [31:0]\logits_reg[1] ;
  wire [31:0]\logits_reg[2] ;
  wire [31:0]\logits_reg[3] ;
  wire [31:0]\logits_reg[4] ;
  wire [0:0]m_in_r;
  wire [1:0]mac_in;
  wire [5:2]mac_in__0;
  wire [15:0]mac_product;
  wire [0:0]n_in_r;
  wire \n_in_r_reg_n_0_[0] ;
  wire \n_in_r_reg_n_0_[10] ;
  wire \n_in_r_reg_n_0_[11] ;
  wire \n_in_r_reg_n_0_[12] ;
  wire \n_in_r_reg_n_0_[13] ;
  wire \n_in_r_reg_n_0_[14] ;
  wire \n_in_r_reg_n_0_[15] ;
  wire \n_in_r_reg_n_0_[16] ;
  wire \n_in_r_reg_n_0_[17] ;
  wire \n_in_r_reg_n_0_[18] ;
  wire \n_in_r_reg_n_0_[19] ;
  wire \n_in_r_reg_n_0_[1] ;
  wire \n_in_r_reg_n_0_[20] ;
  wire \n_in_r_reg_n_0_[21] ;
  wire \n_in_r_reg_n_0_[22] ;
  wire \n_in_r_reg_n_0_[23] ;
  wire \n_in_r_reg_n_0_[24] ;
  wire \n_in_r_reg_n_0_[25] ;
  wire \n_in_r_reg_n_0_[26] ;
  wire \n_in_r_reg_n_0_[27] ;
  wire \n_in_r_reg_n_0_[28] ;
  wire \n_in_r_reg_n_0_[29] ;
  wire \n_in_r_reg_n_0_[2] ;
  wire \n_in_r_reg_n_0_[30] ;
  wire \n_in_r_reg_n_0_[31] ;
  wire \n_in_r_reg_n_0_[3] ;
  wire \n_in_r_reg_n_0_[4] ;
  wire \n_in_r_reg_n_0_[5] ;
  wire \n_in_r_reg_n_0_[6] ;
  wire \n_in_r_reg_n_0_[7] ;
  wire \n_in_r_reg_n_0_[8] ;
  wire \n_in_r_reg_n_0_[9] ;
  wire [0:0]neuron;
  wire \neuron[0]_i_1_n_0 ;
  wire \neuron[1]_i_1_n_0 ;
  wire \neuron[2]_i_1_n_0 ;
  wire \neuron[3]_i_1_n_0 ;
  wire \neuron[4]_i_1_n_0 ;
  wire \neuron[5]_i_1_n_0 ;
  wire \neuron[5]_i_2_n_0 ;
  wire \neuron[6]_i_2_n_0 ;
  wire \neuron[6]_i_3_n_0 ;
  wire [0:0]norm_prod;
  wire norm_prod0__0_n_100;
  wire norm_prod0__0_n_101;
  wire norm_prod0__0_n_102;
  wire norm_prod0__0_n_103;
  wire norm_prod0__0_n_104;
  wire norm_prod0__0_n_105;
  wire norm_prod0__0_n_106;
  wire norm_prod0__0_n_107;
  wire norm_prod0__0_n_108;
  wire norm_prod0__0_n_109;
  wire norm_prod0__0_n_110;
  wire norm_prod0__0_n_111;
  wire norm_prod0__0_n_112;
  wire norm_prod0__0_n_113;
  wire norm_prod0__0_n_114;
  wire norm_prod0__0_n_115;
  wire norm_prod0__0_n_116;
  wire norm_prod0__0_n_117;
  wire norm_prod0__0_n_118;
  wire norm_prod0__0_n_119;
  wire norm_prod0__0_n_120;
  wire norm_prod0__0_n_121;
  wire norm_prod0__0_n_122;
  wire norm_prod0__0_n_123;
  wire norm_prod0__0_n_124;
  wire norm_prod0__0_n_125;
  wire norm_prod0__0_n_126;
  wire norm_prod0__0_n_127;
  wire norm_prod0__0_n_128;
  wire norm_prod0__0_n_129;
  wire norm_prod0__0_n_130;
  wire norm_prod0__0_n_131;
  wire norm_prod0__0_n_132;
  wire norm_prod0__0_n_133;
  wire norm_prod0__0_n_134;
  wire norm_prod0__0_n_135;
  wire norm_prod0__0_n_136;
  wire norm_prod0__0_n_137;
  wire norm_prod0__0_n_138;
  wire norm_prod0__0_n_139;
  wire norm_prod0__0_n_140;
  wire norm_prod0__0_n_141;
  wire norm_prod0__0_n_142;
  wire norm_prod0__0_n_143;
  wire norm_prod0__0_n_144;
  wire norm_prod0__0_n_145;
  wire norm_prod0__0_n_146;
  wire norm_prod0__0_n_147;
  wire norm_prod0__0_n_148;
  wire norm_prod0__0_n_149;
  wire norm_prod0__0_n_150;
  wire norm_prod0__0_n_151;
  wire norm_prod0__0_n_152;
  wire norm_prod0__0_n_153;
  wire norm_prod0__0_n_24;
  wire norm_prod0__0_n_25;
  wire norm_prod0__0_n_26;
  wire norm_prod0__0_n_27;
  wire norm_prod0__0_n_28;
  wire norm_prod0__0_n_29;
  wire norm_prod0__0_n_30;
  wire norm_prod0__0_n_31;
  wire norm_prod0__0_n_32;
  wire norm_prod0__0_n_33;
  wire norm_prod0__0_n_34;
  wire norm_prod0__0_n_35;
  wire norm_prod0__0_n_36;
  wire norm_prod0__0_n_37;
  wire norm_prod0__0_n_38;
  wire norm_prod0__0_n_39;
  wire norm_prod0__0_n_40;
  wire norm_prod0__0_n_41;
  wire norm_prod0__0_n_42;
  wire norm_prod0__0_n_43;
  wire norm_prod0__0_n_44;
  wire norm_prod0__0_n_45;
  wire norm_prod0__0_n_46;
  wire norm_prod0__0_n_47;
  wire norm_prod0__0_n_48;
  wire norm_prod0__0_n_49;
  wire norm_prod0__0_n_50;
  wire norm_prod0__0_n_51;
  wire norm_prod0__0_n_52;
  wire norm_prod0__0_n_53;
  wire norm_prod0__0_n_58;
  wire norm_prod0__0_n_59;
  wire norm_prod0__0_n_60;
  wire norm_prod0__0_n_61;
  wire norm_prod0__0_n_62;
  wire norm_prod0__0_n_63;
  wire norm_prod0__0_n_64;
  wire norm_prod0__0_n_65;
  wire norm_prod0__0_n_66;
  wire norm_prod0__0_n_67;
  wire norm_prod0__0_n_68;
  wire norm_prod0__0_n_69;
  wire norm_prod0__0_n_70;
  wire norm_prod0__0_n_71;
  wire norm_prod0__0_n_72;
  wire norm_prod0__0_n_73;
  wire norm_prod0__0_n_74;
  wire norm_prod0__0_n_75;
  wire norm_prod0__0_n_76;
  wire norm_prod0__0_n_77;
  wire norm_prod0__0_n_78;
  wire norm_prod0__0_n_79;
  wire norm_prod0__0_n_80;
  wire norm_prod0__0_n_81;
  wire norm_prod0__0_n_82;
  wire norm_prod0__0_n_83;
  wire norm_prod0__0_n_84;
  wire norm_prod0__0_n_85;
  wire norm_prod0__0_n_86;
  wire norm_prod0__0_n_87;
  wire norm_prod0__0_n_88;
  wire norm_prod0__0_n_89;
  wire norm_prod0__0_n_90;
  wire norm_prod0__0_n_91;
  wire norm_prod0__0_n_92;
  wire norm_prod0__0_n_93;
  wire norm_prod0__0_n_94;
  wire norm_prod0__0_n_95;
  wire norm_prod0__0_n_96;
  wire norm_prod0__0_n_97;
  wire norm_prod0__0_n_98;
  wire norm_prod0__0_n_99;
  wire norm_prod0_n_100;
  wire norm_prod0_n_101;
  wire norm_prod0_n_102;
  wire norm_prod0_n_103;
  wire norm_prod0_n_104;
  wire norm_prod0_n_105;
  wire norm_prod0_n_106;
  wire norm_prod0_n_107;
  wire norm_prod0_n_108;
  wire norm_prod0_n_109;
  wire norm_prod0_n_110;
  wire norm_prod0_n_111;
  wire norm_prod0_n_112;
  wire norm_prod0_n_113;
  wire norm_prod0_n_114;
  wire norm_prod0_n_115;
  wire norm_prod0_n_116;
  wire norm_prod0_n_117;
  wire norm_prod0_n_118;
  wire norm_prod0_n_119;
  wire norm_prod0_n_120;
  wire norm_prod0_n_121;
  wire norm_prod0_n_122;
  wire norm_prod0_n_123;
  wire norm_prod0_n_124;
  wire norm_prod0_n_125;
  wire norm_prod0_n_126;
  wire norm_prod0_n_127;
  wire norm_prod0_n_128;
  wire norm_prod0_n_129;
  wire norm_prod0_n_130;
  wire norm_prod0_n_131;
  wire norm_prod0_n_132;
  wire norm_prod0_n_133;
  wire norm_prod0_n_134;
  wire norm_prod0_n_135;
  wire norm_prod0_n_136;
  wire norm_prod0_n_137;
  wire norm_prod0_n_138;
  wire norm_prod0_n_139;
  wire norm_prod0_n_140;
  wire norm_prod0_n_141;
  wire norm_prod0_n_142;
  wire norm_prod0_n_143;
  wire norm_prod0_n_144;
  wire norm_prod0_n_145;
  wire norm_prod0_n_146;
  wire norm_prod0_n_147;
  wire norm_prod0_n_148;
  wire norm_prod0_n_149;
  wire norm_prod0_n_150;
  wire norm_prod0_n_151;
  wire norm_prod0_n_152;
  wire norm_prod0_n_153;
  wire norm_prod0_n_58;
  wire norm_prod0_n_59;
  wire norm_prod0_n_60;
  wire norm_prod0_n_61;
  wire norm_prod0_n_62;
  wire norm_prod0_n_63;
  wire norm_prod0_n_64;
  wire norm_prod0_n_65;
  wire norm_prod0_n_66;
  wire norm_prod0_n_67;
  wire norm_prod0_n_68;
  wire norm_prod0_n_69;
  wire norm_prod0_n_70;
  wire norm_prod0_n_71;
  wire norm_prod0_n_72;
  wire norm_prod0_n_73;
  wire norm_prod0_n_74;
  wire norm_prod0_n_75;
  wire norm_prod0_n_76;
  wire norm_prod0_n_77;
  wire norm_prod0_n_78;
  wire norm_prod0_n_79;
  wire norm_prod0_n_80;
  wire norm_prod0_n_81;
  wire norm_prod0_n_82;
  wire norm_prod0_n_83;
  wire norm_prod0_n_84;
  wire norm_prod0_n_85;
  wire norm_prod0_n_86;
  wire norm_prod0_n_87;
  wire norm_prod0_n_88;
  wire norm_prod0_n_89;
  wire norm_prod0_n_90;
  wire norm_prod0_n_91;
  wire norm_prod0_n_92;
  wire norm_prod0_n_93;
  wire norm_prod0_n_94;
  wire norm_prod0_n_95;
  wire norm_prod0_n_96;
  wire norm_prod0_n_97;
  wire norm_prod0_n_98;
  wire norm_prod0_n_99;
  wire \norm_prod_reg[0]__0_n_0 ;
  wire \norm_prod_reg[10]__0_n_0 ;
  wire \norm_prod_reg[11]__0_n_0 ;
  wire \norm_prod_reg[12]__0_n_0 ;
  wire \norm_prod_reg[13]__0_n_0 ;
  wire \norm_prod_reg[14]__0_n_0 ;
  wire \norm_prod_reg[15]__0_n_0 ;
  wire \norm_prod_reg[16]__0_n_0 ;
  wire \norm_prod_reg[1]__0_n_0 ;
  wire \norm_prod_reg[2]__0_n_0 ;
  wire \norm_prod_reg[3]__0_n_0 ;
  wire \norm_prod_reg[4]__0_n_0 ;
  wire \norm_prod_reg[5]__0_n_0 ;
  wire \norm_prod_reg[6]__0_n_0 ;
  wire \norm_prod_reg[7]__0_n_0 ;
  wire \norm_prod_reg[8]__0_n_0 ;
  wire \norm_prod_reg[9]__0_n_0 ;
  wire norm_prod_reg__0_n_100;
  wire norm_prod_reg__0_n_101;
  wire norm_prod_reg__0_n_102;
  wire norm_prod_reg__0_n_103;
  wire norm_prod_reg__0_n_104;
  wire norm_prod_reg__0_n_105;
  wire norm_prod_reg__0_n_58;
  wire norm_prod_reg__0_n_59;
  wire norm_prod_reg__0_n_60;
  wire norm_prod_reg__0_n_61;
  wire norm_prod_reg__0_n_62;
  wire norm_prod_reg__0_n_63;
  wire norm_prod_reg__0_n_64;
  wire norm_prod_reg__0_n_65;
  wire norm_prod_reg__0_n_66;
  wire norm_prod_reg__0_n_67;
  wire norm_prod_reg__0_n_68;
  wire norm_prod_reg__0_n_69;
  wire norm_prod_reg__0_n_70;
  wire norm_prod_reg__0_n_71;
  wire norm_prod_reg__0_n_72;
  wire norm_prod_reg__0_n_73;
  wire norm_prod_reg__0_n_74;
  wire norm_prod_reg__0_n_75;
  wire norm_prod_reg__0_n_76;
  wire norm_prod_reg__0_n_77;
  wire norm_prod_reg__0_n_78;
  wire norm_prod_reg__0_n_79;
  wire norm_prod_reg__0_n_80;
  wire norm_prod_reg__0_n_81;
  wire norm_prod_reg__0_n_82;
  wire norm_prod_reg__0_n_83;
  wire norm_prod_reg__0_n_84;
  wire norm_prod_reg__0_n_85;
  wire norm_prod_reg__0_n_86;
  wire norm_prod_reg__0_n_87;
  wire norm_prod_reg__0_n_88;
  wire norm_prod_reg__0_n_89;
  wire norm_prod_reg__0_n_90;
  wire norm_prod_reg__0_n_91;
  wire norm_prod_reg__0_n_92;
  wire norm_prod_reg__0_n_93;
  wire norm_prod_reg__0_n_94;
  wire norm_prod_reg__0_n_95;
  wire norm_prod_reg__0_n_96;
  wire norm_prod_reg__0_n_97;
  wire norm_prod_reg__0_n_98;
  wire norm_prod_reg__0_n_99;
  wire [63:16]norm_prod_reg__1;
  wire \norm_prod_reg_n_0_[0] ;
  wire \norm_prod_reg_n_0_[10] ;
  wire \norm_prod_reg_n_0_[11] ;
  wire \norm_prod_reg_n_0_[12] ;
  wire \norm_prod_reg_n_0_[13] ;
  wire \norm_prod_reg_n_0_[14] ;
  wire \norm_prod_reg_n_0_[15] ;
  wire \norm_prod_reg_n_0_[16] ;
  wire \norm_prod_reg_n_0_[1] ;
  wire \norm_prod_reg_n_0_[2] ;
  wire \norm_prod_reg_n_0_[3] ;
  wire \norm_prod_reg_n_0_[4] ;
  wire \norm_prod_reg_n_0_[5] ;
  wire \norm_prod_reg_n_0_[6] ;
  wire \norm_prod_reg_n_0_[7] ;
  wire \norm_prod_reg_n_0_[8] ;
  wire \norm_prod_reg_n_0_[9] ;
  wire norm_prod_reg_n_100;
  wire norm_prod_reg_n_101;
  wire norm_prod_reg_n_102;
  wire norm_prod_reg_n_103;
  wire norm_prod_reg_n_104;
  wire norm_prod_reg_n_105;
  wire norm_prod_reg_n_58;
  wire norm_prod_reg_n_59;
  wire norm_prod_reg_n_60;
  wire norm_prod_reg_n_61;
  wire norm_prod_reg_n_62;
  wire norm_prod_reg_n_63;
  wire norm_prod_reg_n_64;
  wire norm_prod_reg_n_65;
  wire norm_prod_reg_n_66;
  wire norm_prod_reg_n_67;
  wire norm_prod_reg_n_68;
  wire norm_prod_reg_n_69;
  wire norm_prod_reg_n_70;
  wire norm_prod_reg_n_71;
  wire norm_prod_reg_n_72;
  wire norm_prod_reg_n_73;
  wire norm_prod_reg_n_74;
  wire norm_prod_reg_n_75;
  wire norm_prod_reg_n_76;
  wire norm_prod_reg_n_77;
  wire norm_prod_reg_n_78;
  wire norm_prod_reg_n_79;
  wire norm_prod_reg_n_80;
  wire norm_prod_reg_n_81;
  wire norm_prod_reg_n_82;
  wire norm_prod_reg_n_83;
  wire norm_prod_reg_n_84;
  wire norm_prod_reg_n_85;
  wire norm_prod_reg_n_86;
  wire norm_prod_reg_n_87;
  wire norm_prod_reg_n_88;
  wire norm_prod_reg_n_89;
  wire norm_prod_reg_n_90;
  wire norm_prod_reg_n_91;
  wire norm_prod_reg_n_92;
  wire norm_prod_reg_n_93;
  wire norm_prod_reg_n_94;
  wire norm_prod_reg_n_95;
  wire norm_prod_reg_n_96;
  wire norm_prod_reg_n_97;
  wire norm_prod_reg_n_98;
  wire norm_prod_reg_n_99;
  wire [6:0]normalized_activation;
  wire [31:0]out_data;
  wire \out_data[0]_i_10_n_0 ;
  wire \out_data[0]_i_11_n_0 ;
  wire \out_data[0]_i_12_n_0 ;
  wire \out_data[0]_i_13_n_0 ;
  wire \out_data[0]_i_14_n_0 ;
  wire \out_data[0]_i_16_n_0 ;
  wire \out_data[0]_i_17_n_0 ;
  wire \out_data[0]_i_18_n_0 ;
  wire \out_data[0]_i_19_n_0 ;
  wire \out_data[0]_i_1_n_0 ;
  wire \out_data[0]_i_20_n_0 ;
  wire \out_data[0]_i_21_n_0 ;
  wire \out_data[0]_i_22_n_0 ;
  wire \out_data[0]_i_23_n_0 ;
  wire \out_data[0]_i_25_n_0 ;
  wire \out_data[0]_i_26_n_0 ;
  wire \out_data[0]_i_27_n_0 ;
  wire \out_data[0]_i_28_n_0 ;
  wire \out_data[0]_i_29_n_0 ;
  wire \out_data[0]_i_30_n_0 ;
  wire \out_data[0]_i_31_n_0 ;
  wire \out_data[0]_i_32_n_0 ;
  wire \out_data[0]_i_34_n_0 ;
  wire \out_data[0]_i_35_n_0 ;
  wire \out_data[0]_i_36_n_0 ;
  wire \out_data[0]_i_37_n_0 ;
  wire \out_data[0]_i_38_n_0 ;
  wire \out_data[0]_i_39_n_0 ;
  wire \out_data[0]_i_3_n_0 ;
  wire \out_data[0]_i_40_n_0 ;
  wire \out_data[0]_i_41_n_0 ;
  wire \out_data[0]_i_43_n_0 ;
  wire \out_data[0]_i_44_n_0 ;
  wire \out_data[0]_i_45_n_0 ;
  wire \out_data[0]_i_46_n_0 ;
  wire \out_data[0]_i_47_n_0 ;
  wire \out_data[0]_i_48_n_0 ;
  wire \out_data[0]_i_49_n_0 ;
  wire \out_data[0]_i_50_n_0 ;
  wire \out_data[0]_i_52_n_0 ;
  wire \out_data[0]_i_53_n_0 ;
  wire \out_data[0]_i_54_n_0 ;
  wire \out_data[0]_i_55_n_0 ;
  wire \out_data[0]_i_56_n_0 ;
  wire \out_data[0]_i_57_n_0 ;
  wire \out_data[0]_i_58_n_0 ;
  wire \out_data[0]_i_59_n_0 ;
  wire \out_data[0]_i_60_n_0 ;
  wire \out_data[0]_i_61_n_0 ;
  wire \out_data[0]_i_62_n_0 ;
  wire \out_data[0]_i_63_n_0 ;
  wire \out_data[0]_i_64_n_0 ;
  wire \out_data[0]_i_65_n_0 ;
  wire \out_data[0]_i_66_n_0 ;
  wire \out_data[0]_i_67_n_0 ;
  wire \out_data[0]_i_68_n_0 ;
  wire \out_data[0]_i_69_n_0 ;
  wire \out_data[0]_i_70_n_0 ;
  wire \out_data[0]_i_71_n_0 ;
  wire \out_data[0]_i_72_n_0 ;
  wire \out_data[0]_i_73_n_0 ;
  wire \out_data[0]_i_74_n_0 ;
  wire \out_data[0]_i_75_n_0 ;
  wire \out_data[0]_i_7_n_0 ;
  wire \out_data[0]_i_8_n_0 ;
  wire \out_data[0]_i_9_n_0 ;
  wire \out_data[10]_i_1_n_0 ;
  wire \out_data[10]_i_2_n_0 ;
  wire \out_data[11]_i_1_n_0 ;
  wire \out_data[11]_i_2_n_0 ;
  wire \out_data[12]_i_1_n_0 ;
  wire \out_data[12]_i_2_n_0 ;
  wire \out_data[13]_i_1_n_0 ;
  wire \out_data[13]_i_2_n_0 ;
  wire \out_data[14]_i_1_n_0 ;
  wire \out_data[14]_i_2_n_0 ;
  wire \out_data[15]_i_1_n_0 ;
  wire \out_data[15]_i_2_n_0 ;
  wire \out_data[16]_i_1_n_0 ;
  wire \out_data[16]_i_2_n_0 ;
  wire \out_data[17]_i_1_n_0 ;
  wire \out_data[17]_i_2_n_0 ;
  wire \out_data[18]_i_1_n_0 ;
  wire \out_data[18]_i_2_n_0 ;
  wire \out_data[19]_i_1_n_0 ;
  wire \out_data[19]_i_2_n_0 ;
  wire \out_data[1]_i_10_n_0 ;
  wire \out_data[1]_i_11_n_0 ;
  wire \out_data[1]_i_12_n_0 ;
  wire \out_data[1]_i_13_n_0 ;
  wire \out_data[1]_i_14_n_0 ;
  wire \out_data[1]_i_16_n_0 ;
  wire \out_data[1]_i_17_n_0 ;
  wire \out_data[1]_i_18_n_0 ;
  wire \out_data[1]_i_19_n_0 ;
  wire \out_data[1]_i_1_n_0 ;
  wire \out_data[1]_i_20_n_0 ;
  wire \out_data[1]_i_21_n_0 ;
  wire \out_data[1]_i_22_n_0 ;
  wire \out_data[1]_i_23_n_0 ;
  wire \out_data[1]_i_25_n_0 ;
  wire \out_data[1]_i_26_n_0 ;
  wire \out_data[1]_i_27_n_0 ;
  wire \out_data[1]_i_28_n_0 ;
  wire \out_data[1]_i_29_n_0 ;
  wire \out_data[1]_i_2_n_0 ;
  wire \out_data[1]_i_30_n_0 ;
  wire \out_data[1]_i_31_n_0 ;
  wire \out_data[1]_i_32_n_0 ;
  wire \out_data[1]_i_34_n_0 ;
  wire \out_data[1]_i_35_n_0 ;
  wire \out_data[1]_i_36_n_0 ;
  wire \out_data[1]_i_37_n_0 ;
  wire \out_data[1]_i_38_n_0 ;
  wire \out_data[1]_i_39_n_0 ;
  wire \out_data[1]_i_3_n_0 ;
  wire \out_data[1]_i_40_n_0 ;
  wire \out_data[1]_i_41_n_0 ;
  wire \out_data[1]_i_43_n_0 ;
  wire \out_data[1]_i_44_n_0 ;
  wire \out_data[1]_i_45_n_0 ;
  wire \out_data[1]_i_46_n_0 ;
  wire \out_data[1]_i_47_n_0 ;
  wire \out_data[1]_i_48_n_0 ;
  wire \out_data[1]_i_49_n_0 ;
  wire \out_data[1]_i_50_n_0 ;
  wire \out_data[1]_i_52_n_0 ;
  wire \out_data[1]_i_53_n_0 ;
  wire \out_data[1]_i_54_n_0 ;
  wire \out_data[1]_i_55_n_0 ;
  wire \out_data[1]_i_56_n_0 ;
  wire \out_data[1]_i_57_n_0 ;
  wire \out_data[1]_i_58_n_0 ;
  wire \out_data[1]_i_59_n_0 ;
  wire \out_data[1]_i_60_n_0 ;
  wire \out_data[1]_i_61_n_0 ;
  wire \out_data[1]_i_62_n_0 ;
  wire \out_data[1]_i_63_n_0 ;
  wire \out_data[1]_i_64_n_0 ;
  wire \out_data[1]_i_65_n_0 ;
  wire \out_data[1]_i_66_n_0 ;
  wire \out_data[1]_i_67_n_0 ;
  wire \out_data[1]_i_68_n_0 ;
  wire \out_data[1]_i_69_n_0 ;
  wire \out_data[1]_i_70_n_0 ;
  wire \out_data[1]_i_71_n_0 ;
  wire \out_data[1]_i_72_n_0 ;
  wire \out_data[1]_i_73_n_0 ;
  wire \out_data[1]_i_74_n_0 ;
  wire \out_data[1]_i_75_n_0 ;
  wire \out_data[1]_i_7_n_0 ;
  wire \out_data[1]_i_8_n_0 ;
  wire \out_data[1]_i_9_n_0 ;
  wire \out_data[20]_i_1_n_0 ;
  wire \out_data[20]_i_2_n_0 ;
  wire \out_data[21]_i_1_n_0 ;
  wire \out_data[21]_i_2_n_0 ;
  wire \out_data[22]_i_1_n_0 ;
  wire \out_data[22]_i_2_n_0 ;
  wire \out_data[23]_i_1_n_0 ;
  wire \out_data[23]_i_2_n_0 ;
  wire \out_data[24]_i_1_n_0 ;
  wire \out_data[24]_i_2_n_0 ;
  wire \out_data[25]_i_1_n_0 ;
  wire \out_data[25]_i_2_n_0 ;
  wire \out_data[26]_i_1_n_0 ;
  wire \out_data[26]_i_2_n_0 ;
  wire \out_data[27]_i_1_n_0 ;
  wire \out_data[27]_i_2_n_0 ;
  wire \out_data[28]_i_1_n_0 ;
  wire \out_data[28]_i_2_n_0 ;
  wire \out_data[29]_i_1_n_0 ;
  wire \out_data[29]_i_2_n_0 ;
  wire \out_data[2]_i_10_n_0 ;
  wire \out_data[2]_i_11_n_0 ;
  wire \out_data[2]_i_12_n_0 ;
  wire \out_data[2]_i_14_n_0 ;
  wire \out_data[2]_i_15_n_0 ;
  wire \out_data[2]_i_16_n_0 ;
  wire \out_data[2]_i_17_n_0 ;
  wire \out_data[2]_i_18_n_0 ;
  wire \out_data[2]_i_19_n_0 ;
  wire \out_data[2]_i_1_n_0 ;
  wire \out_data[2]_i_20_n_0 ;
  wire \out_data[2]_i_21_n_0 ;
  wire \out_data[2]_i_22_n_0 ;
  wire \out_data[2]_i_23_n_0 ;
  wire \out_data[2]_i_24_n_0 ;
  wire \out_data[2]_i_25_n_0 ;
  wire \out_data[2]_i_26_n_0 ;
  wire \out_data[2]_i_27_n_0 ;
  wire \out_data[2]_i_28_n_0 ;
  wire \out_data[2]_i_29_n_0 ;
  wire \out_data[2]_i_31_n_0 ;
  wire \out_data[2]_i_32_n_0 ;
  wire \out_data[2]_i_33_n_0 ;
  wire \out_data[2]_i_34_n_0 ;
  wire \out_data[2]_i_35_n_0 ;
  wire \out_data[2]_i_36_n_0 ;
  wire \out_data[2]_i_37_n_0 ;
  wire \out_data[2]_i_38_n_0 ;
  wire \out_data[2]_i_39_n_0 ;
  wire \out_data[2]_i_3_n_0 ;
  wire \out_data[2]_i_40_n_0 ;
  wire \out_data[2]_i_41_n_0 ;
  wire \out_data[2]_i_42_n_0 ;
  wire \out_data[2]_i_43_n_0 ;
  wire \out_data[2]_i_44_n_0 ;
  wire \out_data[2]_i_45_n_0 ;
  wire \out_data[2]_i_46_n_0 ;
  wire \out_data[2]_i_55_n_0 ;
  wire \out_data[2]_i_56_n_0 ;
  wire \out_data[2]_i_57_n_0 ;
  wire \out_data[2]_i_58_n_0 ;
  wire \out_data[2]_i_59_n_0 ;
  wire \out_data[2]_i_5_n_0 ;
  wire \out_data[2]_i_60_n_0 ;
  wire \out_data[2]_i_61_n_0 ;
  wire \out_data[2]_i_62_n_0 ;
  wire \out_data[2]_i_63_n_0 ;
  wire \out_data[2]_i_64_n_0 ;
  wire \out_data[2]_i_65_n_0 ;
  wire \out_data[2]_i_66_n_0 ;
  wire \out_data[2]_i_67_n_0 ;
  wire \out_data[2]_i_68_n_0 ;
  wire \out_data[2]_i_69_n_0 ;
  wire \out_data[2]_i_6_n_0 ;
  wire \out_data[2]_i_70_n_0 ;
  wire \out_data[2]_i_79_n_0 ;
  wire \out_data[2]_i_7_n_0 ;
  wire \out_data[2]_i_80_n_0 ;
  wire \out_data[2]_i_81_n_0 ;
  wire \out_data[2]_i_82_n_0 ;
  wire \out_data[2]_i_83_n_0 ;
  wire \out_data[2]_i_84_n_0 ;
  wire \out_data[2]_i_85_n_0 ;
  wire \out_data[2]_i_86_n_0 ;
  wire \out_data[2]_i_8_n_0 ;
  wire \out_data[2]_i_9_n_0 ;
  wire \out_data[30]_i_1_n_0 ;
  wire \out_data[30]_i_2_n_0 ;
  wire \out_data[31]_i_1_n_0 ;
  wire \out_data[31]_i_2_n_0 ;
  wire \out_data[3]_i_1_n_0 ;
  wire \out_data[3]_i_2_n_0 ;
  wire \out_data[4]_i_1_n_0 ;
  wire \out_data[4]_i_2_n_0 ;
  wire \out_data[5]_i_1_n_0 ;
  wire \out_data[5]_i_2_n_0 ;
  wire \out_data[6]_i_1_n_0 ;
  wire \out_data[6]_i_2_n_0 ;
  wire \out_data[7]_i_1_n_0 ;
  wire \out_data[7]_i_2_n_0 ;
  wire \out_data[8]_i_1_n_0 ;
  wire \out_data[8]_i_2_n_0 ;
  wire \out_data[9]_i_1_n_0 ;
  wire \out_data[9]_i_2_n_0 ;
  wire \out_data_reg[0]_i_15_n_0 ;
  wire \out_data_reg[0]_i_15_n_1 ;
  wire \out_data_reg[0]_i_15_n_2 ;
  wire \out_data_reg[0]_i_15_n_3 ;
  wire \out_data_reg[0]_i_24_n_0 ;
  wire \out_data_reg[0]_i_24_n_1 ;
  wire \out_data_reg[0]_i_24_n_2 ;
  wire \out_data_reg[0]_i_24_n_3 ;
  wire \out_data_reg[0]_i_33_n_0 ;
  wire \out_data_reg[0]_i_33_n_1 ;
  wire \out_data_reg[0]_i_33_n_2 ;
  wire \out_data_reg[0]_i_33_n_3 ;
  wire \out_data_reg[0]_i_42_n_0 ;
  wire \out_data_reg[0]_i_42_n_1 ;
  wire \out_data_reg[0]_i_42_n_2 ;
  wire \out_data_reg[0]_i_42_n_3 ;
  wire \out_data_reg[0]_i_4_n_0 ;
  wire \out_data_reg[0]_i_4_n_1 ;
  wire \out_data_reg[0]_i_4_n_2 ;
  wire \out_data_reg[0]_i_4_n_3 ;
  wire \out_data_reg[0]_i_51_n_0 ;
  wire \out_data_reg[0]_i_51_n_1 ;
  wire \out_data_reg[0]_i_51_n_2 ;
  wire \out_data_reg[0]_i_51_n_3 ;
  wire \out_data_reg[0]_i_5_n_0 ;
  wire \out_data_reg[0]_i_5_n_1 ;
  wire \out_data_reg[0]_i_5_n_2 ;
  wire \out_data_reg[0]_i_5_n_3 ;
  wire \out_data_reg[0]_i_6_n_0 ;
  wire \out_data_reg[0]_i_6_n_1 ;
  wire \out_data_reg[0]_i_6_n_2 ;
  wire \out_data_reg[0]_i_6_n_3 ;
  wire \out_data_reg[1]_i_15_n_0 ;
  wire \out_data_reg[1]_i_15_n_1 ;
  wire \out_data_reg[1]_i_15_n_2 ;
  wire \out_data_reg[1]_i_15_n_3 ;
  wire \out_data_reg[1]_i_24_n_0 ;
  wire \out_data_reg[1]_i_24_n_1 ;
  wire \out_data_reg[1]_i_24_n_2 ;
  wire \out_data_reg[1]_i_24_n_3 ;
  wire \out_data_reg[1]_i_33_n_0 ;
  wire \out_data_reg[1]_i_33_n_1 ;
  wire \out_data_reg[1]_i_33_n_2 ;
  wire \out_data_reg[1]_i_33_n_3 ;
  wire \out_data_reg[1]_i_42_n_0 ;
  wire \out_data_reg[1]_i_42_n_1 ;
  wire \out_data_reg[1]_i_42_n_2 ;
  wire \out_data_reg[1]_i_42_n_3 ;
  wire \out_data_reg[1]_i_4_n_0 ;
  wire \out_data_reg[1]_i_4_n_1 ;
  wire \out_data_reg[1]_i_4_n_2 ;
  wire \out_data_reg[1]_i_4_n_3 ;
  wire \out_data_reg[1]_i_51_n_0 ;
  wire \out_data_reg[1]_i_51_n_1 ;
  wire \out_data_reg[1]_i_51_n_2 ;
  wire \out_data_reg[1]_i_51_n_3 ;
  wire \out_data_reg[1]_i_5_n_0 ;
  wire \out_data_reg[1]_i_5_n_1 ;
  wire \out_data_reg[1]_i_5_n_2 ;
  wire \out_data_reg[1]_i_5_n_3 ;
  wire \out_data_reg[1]_i_6_n_0 ;
  wire \out_data_reg[1]_i_6_n_1 ;
  wire \out_data_reg[1]_i_6_n_2 ;
  wire \out_data_reg[1]_i_6_n_3 ;
  wire \out_data_reg[2]_i_13_n_0 ;
  wire \out_data_reg[2]_i_13_n_1 ;
  wire \out_data_reg[2]_i_13_n_2 ;
  wire \out_data_reg[2]_i_13_n_3 ;
  wire \out_data_reg[2]_i_2_n_0 ;
  wire \out_data_reg[2]_i_2_n_1 ;
  wire \out_data_reg[2]_i_2_n_2 ;
  wire \out_data_reg[2]_i_2_n_3 ;
  wire \out_data_reg[2]_i_30_n_0 ;
  wire \out_data_reg[2]_i_30_n_1 ;
  wire \out_data_reg[2]_i_30_n_2 ;
  wire \out_data_reg[2]_i_30_n_3 ;
  wire \out_data_reg[2]_i_4_n_0 ;
  wire \out_data_reg[2]_i_4_n_1 ;
  wire \out_data_reg[2]_i_4_n_2 ;
  wire \out_data_reg[2]_i_4_n_3 ;
  wire [2:0]out_id;
  wire \out_id[0]_i_1_n_0 ;
  wire \out_id[1]_i_1_n_0 ;
  wire \out_id[2]_i_1_n_0 ;
  wire \out_id[2]_i_2_n_0 ;
  wire \out_id[2]_i_3_n_0 ;
  wire \out_id[2]_i_4_n_0 ;
  wire out_ready;
  wire out_valid;
  wire out_valid_i_1_n_0;
  wire out_valid_i_2_n_0;
  wire out_valid_i_3_n_0;
  wire [10:4]p_0_in;
  wire [61:49]rq_half;
  wire [0:0]rq_m;
  wire [0:0]rq_n;
  wire \rq_n_reg_n_0_[0] ;
  wire \rq_n_reg_n_0_[1] ;
  wire \rq_n_reg_n_0_[2] ;
  wire \rq_n_reg_n_0_[3] ;
  wire \rq_n_reg_n_0_[4] ;
  wire \rq_n_reg_n_0_[5] ;
  wire [0:0]rq_prod;
  wire rq_prod0_n_100;
  wire rq_prod0_n_101;
  wire rq_prod0_n_102;
  wire rq_prod0_n_103;
  wire rq_prod0_n_104;
  wire rq_prod0_n_105;
  wire rq_prod0_n_106;
  wire rq_prod0_n_107;
  wire rq_prod0_n_108;
  wire rq_prod0_n_109;
  wire rq_prod0_n_110;
  wire rq_prod0_n_111;
  wire rq_prod0_n_112;
  wire rq_prod0_n_113;
  wire rq_prod0_n_114;
  wire rq_prod0_n_115;
  wire rq_prod0_n_116;
  wire rq_prod0_n_117;
  wire rq_prod0_n_118;
  wire rq_prod0_n_119;
  wire rq_prod0_n_120;
  wire rq_prod0_n_121;
  wire rq_prod0_n_122;
  wire rq_prod0_n_123;
  wire rq_prod0_n_124;
  wire rq_prod0_n_125;
  wire rq_prod0_n_126;
  wire rq_prod0_n_127;
  wire rq_prod0_n_128;
  wire rq_prod0_n_129;
  wire rq_prod0_n_130;
  wire rq_prod0_n_131;
  wire rq_prod0_n_132;
  wire rq_prod0_n_133;
  wire rq_prod0_n_134;
  wire rq_prod0_n_135;
  wire rq_prod0_n_136;
  wire rq_prod0_n_137;
  wire rq_prod0_n_138;
  wire rq_prod0_n_139;
  wire rq_prod0_n_140;
  wire rq_prod0_n_141;
  wire rq_prod0_n_142;
  wire rq_prod0_n_143;
  wire rq_prod0_n_144;
  wire rq_prod0_n_145;
  wire rq_prod0_n_146;
  wire rq_prod0_n_147;
  wire rq_prod0_n_148;
  wire rq_prod0_n_149;
  wire rq_prod0_n_150;
  wire rq_prod0_n_151;
  wire rq_prod0_n_152;
  wire rq_prod0_n_153;
  wire rq_prod0_n_58;
  wire rq_prod0_n_59;
  wire rq_prod0_n_60;
  wire rq_prod0_n_61;
  wire rq_prod0_n_62;
  wire rq_prod0_n_63;
  wire rq_prod0_n_64;
  wire rq_prod0_n_65;
  wire rq_prod0_n_66;
  wire rq_prod0_n_67;
  wire rq_prod0_n_68;
  wire rq_prod0_n_69;
  wire rq_prod0_n_70;
  wire rq_prod0_n_71;
  wire rq_prod0_n_72;
  wire rq_prod0_n_73;
  wire rq_prod0_n_74;
  wire rq_prod0_n_75;
  wire rq_prod0_n_76;
  wire rq_prod0_n_77;
  wire rq_prod0_n_78;
  wire rq_prod0_n_79;
  wire rq_prod0_n_80;
  wire rq_prod0_n_81;
  wire rq_prod0_n_82;
  wire rq_prod0_n_83;
  wire rq_prod0_n_84;
  wire rq_prod0_n_85;
  wire rq_prod0_n_86;
  wire rq_prod0_n_87;
  wire rq_prod0_n_88;
  wire rq_prod0_n_89;
  wire rq_prod0_n_90;
  wire rq_prod0_n_91;
  wire rq_prod0_n_92;
  wire rq_prod0_n_93;
  wire rq_prod0_n_94;
  wire rq_prod0_n_95;
  wire rq_prod0_n_96;
  wire rq_prod0_n_97;
  wire rq_prod0_n_98;
  wire rq_prod0_n_99;
  wire [49:0]rq_prod_reg__0;
  wire rq_prod_reg_n_58;
  wire rq_prod_reg_n_59;
  wire rq_prod_reg_n_60;
  wire rq_prod_reg_n_61;
  wire rq_prod_reg_n_62;
  wire rq_prod_reg_n_63;
  wire rq_prod_reg_n_64;
  wire rq_prod_reg_n_65;
  wire rq_prod_reg_n_66;
  wire rq_prod_reg_n_67;
  wire rq_prod_reg_n_68;
  wire rq_prod_reg_n_69;
  wire rq_prod_reg_n_70;
  wire rq_prod_reg_n_71;
  wire rq_prod_reg_n_72;
  wire rst_n;
  wire [4:0]state;
  wire [4:0]state__0;
  wire [4:0]state_reg;
  wire [8:8]w_base0;
  wire [10:2]w_base1;
  wire [0:0]word_buf;
  wire \word_buf_reg_n_0_[10] ;
  wire \word_buf_reg_n_0_[11] ;
  wire \word_buf_reg_n_0_[12] ;
  wire \word_buf_reg_n_0_[13] ;
  wire \word_buf_reg_n_0_[14] ;
  wire \word_buf_reg_n_0_[15] ;
  wire \word_buf_reg_n_0_[16] ;
  wire \word_buf_reg_n_0_[17] ;
  wire \word_buf_reg_n_0_[18] ;
  wire \word_buf_reg_n_0_[19] ;
  wire \word_buf_reg_n_0_[20] ;
  wire \word_buf_reg_n_0_[21] ;
  wire \word_buf_reg_n_0_[22] ;
  wire \word_buf_reg_n_0_[23] ;
  wire \word_buf_reg_n_0_[24] ;
  wire \word_buf_reg_n_0_[25] ;
  wire \word_buf_reg_n_0_[26] ;
  wire \word_buf_reg_n_0_[27] ;
  wire \word_buf_reg_n_0_[28] ;
  wire \word_buf_reg_n_0_[29] ;
  wire \word_buf_reg_n_0_[30] ;
  wire \word_buf_reg_n_0_[31] ;
  wire \word_buf_reg_n_0_[8] ;
  wire \word_buf_reg_n_0_[9] ;
  wire \word_idx[0]_i_1_n_0 ;
  wire \word_idx[1]_i_1_n_0 ;
  wire \word_idx[2]_i_1_n_0 ;
  wire \word_idx[3]_i_1_n_0 ;
  wire \word_idx[4]_i_1_n_0 ;
  wire \word_idx[4]_i_2_n_0 ;
  wire \word_idx[4]_i_3_n_0 ;
  wire \word_idx[4]_i_4_n_0 ;
  wire \word_idx[4]_i_5_n_0 ;
  wire \word_idx[4]_i_6_n_0 ;
  wire \word_idx[4]_i_7_n_0 ;
  wire \word_idx_reg_n_0_[4] ;
  wire xq_reg_0_63_0_2_i_100_n_0;
  wire xq_reg_0_63_0_2_i_101_n_0;
  wire xq_reg_0_63_0_2_i_102_n_0;
  wire xq_reg_0_63_0_2_i_103_n_0;
  wire xq_reg_0_63_0_2_i_104_n_0;
  wire xq_reg_0_63_0_2_i_105_n_0;
  wire xq_reg_0_63_0_2_i_106_n_0;
  wire xq_reg_0_63_0_2_i_107_n_0;
  wire xq_reg_0_63_0_2_i_107_n_1;
  wire xq_reg_0_63_0_2_i_107_n_2;
  wire xq_reg_0_63_0_2_i_107_n_3;
  wire xq_reg_0_63_0_2_i_108_n_0;
  wire xq_reg_0_63_0_2_i_109_n_0;
  wire xq_reg_0_63_0_2_i_10_n_0;
  wire xq_reg_0_63_0_2_i_110_n_0;
  wire xq_reg_0_63_0_2_i_111_n_0;
  wire xq_reg_0_63_0_2_i_112_n_0;
  wire xq_reg_0_63_0_2_i_112_n_1;
  wire xq_reg_0_63_0_2_i_112_n_2;
  wire xq_reg_0_63_0_2_i_112_n_3;
  wire xq_reg_0_63_0_2_i_113_n_0;
  wire xq_reg_0_63_0_2_i_114_n_0;
  wire xq_reg_0_63_0_2_i_115_n_0;
  wire xq_reg_0_63_0_2_i_116_n_0;
  wire xq_reg_0_63_0_2_i_117_n_0;
  wire xq_reg_0_63_0_2_i_117_n_1;
  wire xq_reg_0_63_0_2_i_117_n_2;
  wire xq_reg_0_63_0_2_i_117_n_3;
  wire xq_reg_0_63_0_2_i_118_n_0;
  wire xq_reg_0_63_0_2_i_119_n_0;
  wire xq_reg_0_63_0_2_i_11_n_0;
  wire xq_reg_0_63_0_2_i_120_n_0;
  wire xq_reg_0_63_0_2_i_121_n_0;
  wire xq_reg_0_63_0_2_i_122_n_0;
  wire xq_reg_0_63_0_2_i_123_n_0;
  wire xq_reg_0_63_0_2_i_124_n_0;
  wire xq_reg_0_63_0_2_i_125_n_0;
  wire xq_reg_0_63_0_2_i_126_n_0;
  wire xq_reg_0_63_0_2_i_126_n_1;
  wire xq_reg_0_63_0_2_i_126_n_2;
  wire xq_reg_0_63_0_2_i_126_n_3;
  wire xq_reg_0_63_0_2_i_127_n_0;
  wire xq_reg_0_63_0_2_i_128_n_0;
  wire xq_reg_0_63_0_2_i_129_n_0;
  wire xq_reg_0_63_0_2_i_12_n_0;
  wire xq_reg_0_63_0_2_i_130_n_0;
  wire xq_reg_0_63_0_2_i_131_n_0;
  wire xq_reg_0_63_0_2_i_131_n_1;
  wire xq_reg_0_63_0_2_i_131_n_2;
  wire xq_reg_0_63_0_2_i_131_n_3;
  wire xq_reg_0_63_0_2_i_132_n_0;
  wire xq_reg_0_63_0_2_i_133_n_0;
  wire xq_reg_0_63_0_2_i_134_n_0;
  wire xq_reg_0_63_0_2_i_135_n_0;
  wire xq_reg_0_63_0_2_i_136_n_0;
  wire xq_reg_0_63_0_2_i_136_n_1;
  wire xq_reg_0_63_0_2_i_136_n_2;
  wire xq_reg_0_63_0_2_i_136_n_3;
  wire xq_reg_0_63_0_2_i_137_n_0;
  wire xq_reg_0_63_0_2_i_138_n_0;
  wire xq_reg_0_63_0_2_i_139_n_0;
  wire xq_reg_0_63_0_2_i_13_n_0;
  wire xq_reg_0_63_0_2_i_140_n_0;
  wire xq_reg_0_63_0_2_i_141_n_0;
  wire xq_reg_0_63_0_2_i_141_n_1;
  wire xq_reg_0_63_0_2_i_141_n_2;
  wire xq_reg_0_63_0_2_i_141_n_3;
  wire xq_reg_0_63_0_2_i_142_n_0;
  wire xq_reg_0_63_0_2_i_143_n_0;
  wire xq_reg_0_63_0_2_i_144_n_0;
  wire xq_reg_0_63_0_2_i_145_n_0;
  wire xq_reg_0_63_0_2_i_146_n_0;
  wire xq_reg_0_63_0_2_i_147_n_0;
  wire xq_reg_0_63_0_2_i_148_n_0;
  wire xq_reg_0_63_0_2_i_149_n_0;
  wire xq_reg_0_63_0_2_i_14_n_0;
  wire xq_reg_0_63_0_2_i_150_n_0;
  wire xq_reg_0_63_0_2_i_151_n_0;
  wire xq_reg_0_63_0_2_i_152_n_0;
  wire xq_reg_0_63_0_2_i_153_n_0;
  wire xq_reg_0_63_0_2_i_154_n_0;
  wire xq_reg_0_63_0_2_i_155_n_0;
  wire xq_reg_0_63_0_2_i_156_n_0;
  wire xq_reg_0_63_0_2_i_157_n_0;
  wire xq_reg_0_63_0_2_i_158_n_0;
  wire xq_reg_0_63_0_2_i_159_n_0;
  wire xq_reg_0_63_0_2_i_15_n_0;
  wire xq_reg_0_63_0_2_i_160_n_0;
  wire xq_reg_0_63_0_2_i_161_n_0;
  wire xq_reg_0_63_0_2_i_162_n_0;
  wire xq_reg_0_63_0_2_i_163_n_0;
  wire xq_reg_0_63_0_2_i_164_n_0;
  wire xq_reg_0_63_0_2_i_165_n_0;
  wire xq_reg_0_63_0_2_i_166_n_0;
  wire xq_reg_0_63_0_2_i_167_n_0;
  wire xq_reg_0_63_0_2_i_168_n_0;
  wire xq_reg_0_63_0_2_i_169_n_0;
  wire xq_reg_0_63_0_2_i_16_n_0;
  wire xq_reg_0_63_0_2_i_170_n_0;
  wire xq_reg_0_63_0_2_i_171_n_0;
  wire xq_reg_0_63_0_2_i_172_n_0;
  wire xq_reg_0_63_0_2_i_173_n_0;
  wire xq_reg_0_63_0_2_i_174_n_0;
  wire xq_reg_0_63_0_2_i_175_n_0;
  wire xq_reg_0_63_0_2_i_176_n_0;
  wire xq_reg_0_63_0_2_i_177_n_0;
  wire xq_reg_0_63_0_2_i_178_n_0;
  wire xq_reg_0_63_0_2_i_179_n_0;
  wire xq_reg_0_63_0_2_i_17_n_0;
  wire xq_reg_0_63_0_2_i_180_n_0;
  wire xq_reg_0_63_0_2_i_181_n_0;
  wire xq_reg_0_63_0_2_i_182_n_0;
  wire xq_reg_0_63_0_2_i_183_n_0;
  wire xq_reg_0_63_0_2_i_184_n_0;
  wire xq_reg_0_63_0_2_i_185_n_0;
  wire xq_reg_0_63_0_2_i_186_n_0;
  wire xq_reg_0_63_0_2_i_187_n_0;
  wire xq_reg_0_63_0_2_i_188_n_0;
  wire xq_reg_0_63_0_2_i_189_n_0;
  wire xq_reg_0_63_0_2_i_18_n_0;
  wire xq_reg_0_63_0_2_i_190_n_0;
  wire xq_reg_0_63_0_2_i_191_n_0;
  wire xq_reg_0_63_0_2_i_192_n_0;
  wire xq_reg_0_63_0_2_i_193_n_0;
  wire xq_reg_0_63_0_2_i_194_n_0;
  wire xq_reg_0_63_0_2_i_195_n_0;
  wire xq_reg_0_63_0_2_i_196_n_0;
  wire xq_reg_0_63_0_2_i_197_n_0;
  wire xq_reg_0_63_0_2_i_198_n_0;
  wire xq_reg_0_63_0_2_i_199_n_0;
  wire xq_reg_0_63_0_2_i_19_n_0;
  wire xq_reg_0_63_0_2_i_200_n_0;
  wire xq_reg_0_63_0_2_i_201_n_0;
  wire xq_reg_0_63_0_2_i_202_n_0;
  wire xq_reg_0_63_0_2_i_203_n_0;
  wire xq_reg_0_63_0_2_i_204_n_0;
  wire xq_reg_0_63_0_2_i_205_n_0;
  wire xq_reg_0_63_0_2_i_206_n_0;
  wire xq_reg_0_63_0_2_i_207_n_0;
  wire xq_reg_0_63_0_2_i_208_n_0;
  wire xq_reg_0_63_0_2_i_209_n_0;
  wire xq_reg_0_63_0_2_i_20_n_0;
  wire xq_reg_0_63_0_2_i_210_n_0;
  wire xq_reg_0_63_0_2_i_211_n_0;
  wire xq_reg_0_63_0_2_i_212_n_0;
  wire xq_reg_0_63_0_2_i_213_n_0;
  wire xq_reg_0_63_0_2_i_214_n_0;
  wire xq_reg_0_63_0_2_i_215_n_0;
  wire xq_reg_0_63_0_2_i_216_n_0;
  wire xq_reg_0_63_0_2_i_217_n_0;
  wire xq_reg_0_63_0_2_i_217_n_1;
  wire xq_reg_0_63_0_2_i_217_n_2;
  wire xq_reg_0_63_0_2_i_217_n_3;
  wire xq_reg_0_63_0_2_i_218_n_0;
  wire xq_reg_0_63_0_2_i_219_n_0;
  wire xq_reg_0_63_0_2_i_21_n_0;
  wire xq_reg_0_63_0_2_i_21_n_1;
  wire xq_reg_0_63_0_2_i_21_n_2;
  wire xq_reg_0_63_0_2_i_21_n_3;
  wire xq_reg_0_63_0_2_i_220_n_0;
  wire xq_reg_0_63_0_2_i_221_n_0;
  wire xq_reg_0_63_0_2_i_222_n_0;
  wire xq_reg_0_63_0_2_i_223_n_0;
  wire xq_reg_0_63_0_2_i_224_n_0;
  wire xq_reg_0_63_0_2_i_225_n_0;
  wire xq_reg_0_63_0_2_i_226_n_0;
  wire xq_reg_0_63_0_2_i_227_n_0;
  wire xq_reg_0_63_0_2_i_228_n_0;
  wire xq_reg_0_63_0_2_i_229_n_0;
  wire xq_reg_0_63_0_2_i_22_n_0;
  wire xq_reg_0_63_0_2_i_230_n_0;
  wire xq_reg_0_63_0_2_i_231_n_0;
  wire xq_reg_0_63_0_2_i_232_n_0;
  wire xq_reg_0_63_0_2_i_233_n_0;
  wire xq_reg_0_63_0_2_i_234_n_0;
  wire xq_reg_0_63_0_2_i_235_n_0;
  wire xq_reg_0_63_0_2_i_236_n_0;
  wire xq_reg_0_63_0_2_i_237_n_0;
  wire xq_reg_0_63_0_2_i_238_n_0;
  wire xq_reg_0_63_0_2_i_239_n_0;
  wire xq_reg_0_63_0_2_i_239_n_1;
  wire xq_reg_0_63_0_2_i_239_n_2;
  wire xq_reg_0_63_0_2_i_239_n_3;
  wire xq_reg_0_63_0_2_i_23_n_0;
  wire xq_reg_0_63_0_2_i_240_n_0;
  wire xq_reg_0_63_0_2_i_241_n_0;
  wire xq_reg_0_63_0_2_i_242_n_0;
  wire xq_reg_0_63_0_2_i_243_n_0;
  wire xq_reg_0_63_0_2_i_244_n_0;
  wire xq_reg_0_63_0_2_i_245_n_0;
  wire xq_reg_0_63_0_2_i_246_n_0;
  wire xq_reg_0_63_0_2_i_247_n_0;
  wire xq_reg_0_63_0_2_i_248_n_0;
  wire xq_reg_0_63_0_2_i_249_n_0;
  wire xq_reg_0_63_0_2_i_24_n_0;
  wire xq_reg_0_63_0_2_i_250_n_0;
  wire xq_reg_0_63_0_2_i_251_n_0;
  wire xq_reg_0_63_0_2_i_252_n_0;
  wire xq_reg_0_63_0_2_i_253_n_0;
  wire xq_reg_0_63_0_2_i_254_n_0;
  wire xq_reg_0_63_0_2_i_255_n_0;
  wire xq_reg_0_63_0_2_i_256_n_0;
  wire xq_reg_0_63_0_2_i_257_n_0;
  wire xq_reg_0_63_0_2_i_258_n_0;
  wire xq_reg_0_63_0_2_i_259_n_0;
  wire xq_reg_0_63_0_2_i_25_n_0;
  wire xq_reg_0_63_0_2_i_260_n_0;
  wire xq_reg_0_63_0_2_i_261_n_0;
  wire xq_reg_0_63_0_2_i_262_n_0;
  wire xq_reg_0_63_0_2_i_263_n_0;
  wire xq_reg_0_63_0_2_i_264_n_0;
  wire xq_reg_0_63_0_2_i_265_n_0;
  wire xq_reg_0_63_0_2_i_266_n_0;
  wire xq_reg_0_63_0_2_i_267_n_0;
  wire xq_reg_0_63_0_2_i_268_n_0;
  wire xq_reg_0_63_0_2_i_269_n_0;
  wire xq_reg_0_63_0_2_i_269_n_1;
  wire xq_reg_0_63_0_2_i_269_n_2;
  wire xq_reg_0_63_0_2_i_269_n_3;
  wire xq_reg_0_63_0_2_i_26_n_0;
  wire xq_reg_0_63_0_2_i_270_n_0;
  wire xq_reg_0_63_0_2_i_271_n_0;
  wire xq_reg_0_63_0_2_i_272_n_0;
  wire xq_reg_0_63_0_2_i_273_n_0;
  wire xq_reg_0_63_0_2_i_274_n_0;
  wire xq_reg_0_63_0_2_i_275_n_0;
  wire xq_reg_0_63_0_2_i_276_n_0;
  wire xq_reg_0_63_0_2_i_277_n_0;
  wire xq_reg_0_63_0_2_i_278_n_0;
  wire xq_reg_0_63_0_2_i_279_n_0;
  wire xq_reg_0_63_0_2_i_27_n_0;
  wire xq_reg_0_63_0_2_i_280_n_0;
  wire xq_reg_0_63_0_2_i_281_n_0;
  wire xq_reg_0_63_0_2_i_282_n_0;
  wire xq_reg_0_63_0_2_i_283_n_0;
  wire xq_reg_0_63_0_2_i_284_n_0;
  wire xq_reg_0_63_0_2_i_285_n_0;
  wire xq_reg_0_63_0_2_i_286_n_0;
  wire xq_reg_0_63_0_2_i_287_n_0;
  wire xq_reg_0_63_0_2_i_288_n_0;
  wire xq_reg_0_63_0_2_i_289_n_0;
  wire xq_reg_0_63_0_2_i_28_n_0;
  wire xq_reg_0_63_0_2_i_290_n_0;
  wire xq_reg_0_63_0_2_i_291_n_0;
  wire xq_reg_0_63_0_2_i_292_n_0;
  wire xq_reg_0_63_0_2_i_293_n_0;
  wire xq_reg_0_63_0_2_i_294_n_0;
  wire xq_reg_0_63_0_2_i_295_n_0;
  wire xq_reg_0_63_0_2_i_296_n_0;
  wire xq_reg_0_63_0_2_i_297_n_0;
  wire xq_reg_0_63_0_2_i_298_n_0;
  wire xq_reg_0_63_0_2_i_299_n_0;
  wire xq_reg_0_63_0_2_i_29_n_0;
  wire xq_reg_0_63_0_2_i_29_n_1;
  wire xq_reg_0_63_0_2_i_29_n_2;
  wire xq_reg_0_63_0_2_i_29_n_3;
  wire xq_reg_0_63_0_2_i_29_n_4;
  wire xq_reg_0_63_0_2_i_29_n_5;
  wire xq_reg_0_63_0_2_i_29_n_6;
  wire xq_reg_0_63_0_2_i_29_n_7;
  wire xq_reg_0_63_0_2_i_300_n_0;
  wire xq_reg_0_63_0_2_i_301_n_0;
  wire xq_reg_0_63_0_2_i_302_n_0;
  wire xq_reg_0_63_0_2_i_302_n_1;
  wire xq_reg_0_63_0_2_i_302_n_2;
  wire xq_reg_0_63_0_2_i_302_n_3;
  wire xq_reg_0_63_0_2_i_303_n_0;
  wire xq_reg_0_63_0_2_i_304_n_0;
  wire xq_reg_0_63_0_2_i_305_n_0;
  wire xq_reg_0_63_0_2_i_306_n_0;
  wire xq_reg_0_63_0_2_i_307_n_0;
  wire xq_reg_0_63_0_2_i_308_n_0;
  wire xq_reg_0_63_0_2_i_309_n_0;
  wire xq_reg_0_63_0_2_i_30_n_0;
  wire xq_reg_0_63_0_2_i_30_n_1;
  wire xq_reg_0_63_0_2_i_30_n_2;
  wire xq_reg_0_63_0_2_i_30_n_3;
  wire xq_reg_0_63_0_2_i_30_n_4;
  wire xq_reg_0_63_0_2_i_30_n_5;
  wire xq_reg_0_63_0_2_i_30_n_6;
  wire xq_reg_0_63_0_2_i_30_n_7;
  wire xq_reg_0_63_0_2_i_310_n_0;
  wire xq_reg_0_63_0_2_i_311_n_0;
  wire xq_reg_0_63_0_2_i_312_n_0;
  wire xq_reg_0_63_0_2_i_313_n_0;
  wire xq_reg_0_63_0_2_i_314_n_0;
  wire xq_reg_0_63_0_2_i_315_n_0;
  wire xq_reg_0_63_0_2_i_316_n_0;
  wire xq_reg_0_63_0_2_i_317_n_0;
  wire xq_reg_0_63_0_2_i_318_n_0;
  wire xq_reg_0_63_0_2_i_319_n_0;
  wire xq_reg_0_63_0_2_i_31_n_1;
  wire xq_reg_0_63_0_2_i_31_n_2;
  wire xq_reg_0_63_0_2_i_31_n_3;
  wire xq_reg_0_63_0_2_i_31_n_4;
  wire xq_reg_0_63_0_2_i_31_n_5;
  wire xq_reg_0_63_0_2_i_31_n_6;
  wire xq_reg_0_63_0_2_i_31_n_7;
  wire xq_reg_0_63_0_2_i_320_n_0;
  wire xq_reg_0_63_0_2_i_321_n_0;
  wire xq_reg_0_63_0_2_i_322_n_0;
  wire xq_reg_0_63_0_2_i_323_n_0;
  wire xq_reg_0_63_0_2_i_324_n_0;
  wire xq_reg_0_63_0_2_i_325_n_0;
  wire xq_reg_0_63_0_2_i_326_n_0;
  wire xq_reg_0_63_0_2_i_327_n_0;
  wire xq_reg_0_63_0_2_i_328_n_0;
  wire xq_reg_0_63_0_2_i_329_n_0;
  wire xq_reg_0_63_0_2_i_32_n_0;
  wire xq_reg_0_63_0_2_i_32_n_1;
  wire xq_reg_0_63_0_2_i_32_n_2;
  wire xq_reg_0_63_0_2_i_32_n_3;
  wire xq_reg_0_63_0_2_i_32_n_4;
  wire xq_reg_0_63_0_2_i_32_n_5;
  wire xq_reg_0_63_0_2_i_32_n_6;
  wire xq_reg_0_63_0_2_i_32_n_7;
  wire xq_reg_0_63_0_2_i_330_n_0;
  wire xq_reg_0_63_0_2_i_331_n_0;
  wire xq_reg_0_63_0_2_i_332_n_0;
  wire xq_reg_0_63_0_2_i_333_n_0;
  wire xq_reg_0_63_0_2_i_334_n_0;
  wire xq_reg_0_63_0_2_i_335_n_0;
  wire xq_reg_0_63_0_2_i_336_n_0;
  wire xq_reg_0_63_0_2_i_337_n_0;
  wire xq_reg_0_63_0_2_i_338_n_0;
  wire xq_reg_0_63_0_2_i_339_n_0;
  wire xq_reg_0_63_0_2_i_33_n_0;
  wire xq_reg_0_63_0_2_i_33_n_1;
  wire xq_reg_0_63_0_2_i_33_n_2;
  wire xq_reg_0_63_0_2_i_33_n_3;
  wire xq_reg_0_63_0_2_i_33_n_4;
  wire xq_reg_0_63_0_2_i_33_n_5;
  wire xq_reg_0_63_0_2_i_33_n_6;
  wire xq_reg_0_63_0_2_i_33_n_7;
  wire xq_reg_0_63_0_2_i_340_n_0;
  wire xq_reg_0_63_0_2_i_341_n_0;
  wire xq_reg_0_63_0_2_i_342_n_0;
  wire xq_reg_0_63_0_2_i_343_n_0;
  wire xq_reg_0_63_0_2_i_344_n_0;
  wire xq_reg_0_63_0_2_i_345_n_0;
  wire xq_reg_0_63_0_2_i_346_n_0;
  wire xq_reg_0_63_0_2_i_347_n_0;
  wire xq_reg_0_63_0_2_i_348_n_0;
  wire xq_reg_0_63_0_2_i_349_n_0;
  wire xq_reg_0_63_0_2_i_34_n_0;
  wire xq_reg_0_63_0_2_i_34_n_1;
  wire xq_reg_0_63_0_2_i_34_n_2;
  wire xq_reg_0_63_0_2_i_34_n_3;
  wire xq_reg_0_63_0_2_i_34_n_4;
  wire xq_reg_0_63_0_2_i_34_n_5;
  wire xq_reg_0_63_0_2_i_34_n_6;
  wire xq_reg_0_63_0_2_i_34_n_7;
  wire xq_reg_0_63_0_2_i_350_n_0;
  wire xq_reg_0_63_0_2_i_351_n_0;
  wire xq_reg_0_63_0_2_i_352_n_0;
  wire xq_reg_0_63_0_2_i_353_n_0;
  wire xq_reg_0_63_0_2_i_354_n_0;
  wire xq_reg_0_63_0_2_i_355_n_0;
  wire xq_reg_0_63_0_2_i_356_n_0;
  wire xq_reg_0_63_0_2_i_357_n_0;
  wire xq_reg_0_63_0_2_i_358_n_0;
  wire xq_reg_0_63_0_2_i_359_n_0;
  wire xq_reg_0_63_0_2_i_35_n_0;
  wire xq_reg_0_63_0_2_i_35_n_1;
  wire xq_reg_0_63_0_2_i_35_n_2;
  wire xq_reg_0_63_0_2_i_35_n_3;
  wire xq_reg_0_63_0_2_i_35_n_4;
  wire xq_reg_0_63_0_2_i_35_n_5;
  wire xq_reg_0_63_0_2_i_35_n_6;
  wire xq_reg_0_63_0_2_i_35_n_7;
  wire xq_reg_0_63_0_2_i_360_n_0;
  wire xq_reg_0_63_0_2_i_361_n_0;
  wire xq_reg_0_63_0_2_i_362_n_0;
  wire xq_reg_0_63_0_2_i_363_n_0;
  wire xq_reg_0_63_0_2_i_364_n_0;
  wire xq_reg_0_63_0_2_i_365_n_0;
  wire xq_reg_0_63_0_2_i_366_n_0;
  wire xq_reg_0_63_0_2_i_367_n_0;
  wire xq_reg_0_63_0_2_i_368_n_0;
  wire xq_reg_0_63_0_2_i_369_n_0;
  wire xq_reg_0_63_0_2_i_36_n_0;
  wire xq_reg_0_63_0_2_i_36_n_1;
  wire xq_reg_0_63_0_2_i_36_n_2;
  wire xq_reg_0_63_0_2_i_36_n_3;
  wire xq_reg_0_63_0_2_i_36_n_4;
  wire xq_reg_0_63_0_2_i_36_n_5;
  wire xq_reg_0_63_0_2_i_36_n_6;
  wire xq_reg_0_63_0_2_i_36_n_7;
  wire xq_reg_0_63_0_2_i_370_n_0;
  wire xq_reg_0_63_0_2_i_371_n_0;
  wire xq_reg_0_63_0_2_i_372_n_0;
  wire xq_reg_0_63_0_2_i_373_n_0;
  wire xq_reg_0_63_0_2_i_374_n_0;
  wire xq_reg_0_63_0_2_i_375_n_0;
  wire xq_reg_0_63_0_2_i_376_n_0;
  wire xq_reg_0_63_0_2_i_377_n_0;
  wire xq_reg_0_63_0_2_i_378_n_0;
  wire xq_reg_0_63_0_2_i_37_n_0;
  wire xq_reg_0_63_0_2_i_37_n_1;
  wire xq_reg_0_63_0_2_i_37_n_2;
  wire xq_reg_0_63_0_2_i_37_n_3;
  wire xq_reg_0_63_0_2_i_37_n_4;
  wire xq_reg_0_63_0_2_i_37_n_5;
  wire xq_reg_0_63_0_2_i_37_n_6;
  wire xq_reg_0_63_0_2_i_37_n_7;
  wire xq_reg_0_63_0_2_i_38_n_0;
  wire xq_reg_0_63_0_2_i_38_n_1;
  wire xq_reg_0_63_0_2_i_38_n_2;
  wire xq_reg_0_63_0_2_i_38_n_3;
  wire xq_reg_0_63_0_2_i_38_n_4;
  wire xq_reg_0_63_0_2_i_38_n_5;
  wire xq_reg_0_63_0_2_i_38_n_6;
  wire xq_reg_0_63_0_2_i_38_n_7;
  wire xq_reg_0_63_0_2_i_39_n_0;
  wire xq_reg_0_63_0_2_i_39_n_1;
  wire xq_reg_0_63_0_2_i_39_n_2;
  wire xq_reg_0_63_0_2_i_39_n_3;
  wire xq_reg_0_63_0_2_i_39_n_4;
  wire xq_reg_0_63_0_2_i_39_n_5;
  wire xq_reg_0_63_0_2_i_39_n_6;
  wire xq_reg_0_63_0_2_i_39_n_7;
  wire xq_reg_0_63_0_2_i_40_n_0;
  wire xq_reg_0_63_0_2_i_40_n_1;
  wire xq_reg_0_63_0_2_i_40_n_2;
  wire xq_reg_0_63_0_2_i_40_n_3;
  wire xq_reg_0_63_0_2_i_40_n_4;
  wire xq_reg_0_63_0_2_i_40_n_5;
  wire xq_reg_0_63_0_2_i_40_n_6;
  wire xq_reg_0_63_0_2_i_40_n_7;
  wire xq_reg_0_63_0_2_i_41_n_0;
  wire xq_reg_0_63_0_2_i_41_n_1;
  wire xq_reg_0_63_0_2_i_41_n_2;
  wire xq_reg_0_63_0_2_i_41_n_3;
  wire xq_reg_0_63_0_2_i_41_n_4;
  wire xq_reg_0_63_0_2_i_41_n_5;
  wire xq_reg_0_63_0_2_i_41_n_6;
  wire xq_reg_0_63_0_2_i_41_n_7;
  wire xq_reg_0_63_0_2_i_42_n_0;
  wire xq_reg_0_63_0_2_i_42_n_1;
  wire xq_reg_0_63_0_2_i_42_n_2;
  wire xq_reg_0_63_0_2_i_42_n_3;
  wire xq_reg_0_63_0_2_i_42_n_4;
  wire xq_reg_0_63_0_2_i_42_n_5;
  wire xq_reg_0_63_0_2_i_42_n_6;
  wire xq_reg_0_63_0_2_i_42_n_7;
  wire xq_reg_0_63_0_2_i_43_n_0;
  wire xq_reg_0_63_0_2_i_43_n_1;
  wire xq_reg_0_63_0_2_i_43_n_2;
  wire xq_reg_0_63_0_2_i_43_n_3;
  wire xq_reg_0_63_0_2_i_43_n_4;
  wire xq_reg_0_63_0_2_i_43_n_5;
  wire xq_reg_0_63_0_2_i_43_n_6;
  wire xq_reg_0_63_0_2_i_43_n_7;
  wire xq_reg_0_63_0_2_i_44_n_0;
  wire xq_reg_0_63_0_2_i_44_n_1;
  wire xq_reg_0_63_0_2_i_44_n_2;
  wire xq_reg_0_63_0_2_i_44_n_3;
  wire xq_reg_0_63_0_2_i_44_n_4;
  wire xq_reg_0_63_0_2_i_44_n_5;
  wire xq_reg_0_63_0_2_i_44_n_6;
  wire xq_reg_0_63_0_2_i_44_n_7;
  wire xq_reg_0_63_0_2_i_45_n_0;
  wire xq_reg_0_63_0_2_i_45_n_1;
  wire xq_reg_0_63_0_2_i_45_n_2;
  wire xq_reg_0_63_0_2_i_45_n_3;
  wire xq_reg_0_63_0_2_i_46_n_0;
  wire xq_reg_0_63_0_2_i_47_n_0;
  wire xq_reg_0_63_0_2_i_48_n_0;
  wire xq_reg_0_63_0_2_i_49_n_0;
  wire xq_reg_0_63_0_2_i_4_n_0;
  wire xq_reg_0_63_0_2_i_50_n_0;
  wire xq_reg_0_63_0_2_i_51_n_0;
  wire xq_reg_0_63_0_2_i_52_n_0;
  wire xq_reg_0_63_0_2_i_53_n_0;
  wire xq_reg_0_63_0_2_i_54_n_0;
  wire xq_reg_0_63_0_2_i_55_n_0;
  wire xq_reg_0_63_0_2_i_56_n_0;
  wire xq_reg_0_63_0_2_i_57_n_0;
  wire xq_reg_0_63_0_2_i_58_n_0;
  wire xq_reg_0_63_0_2_i_59_n_0;
  wire xq_reg_0_63_0_2_i_60_n_0;
  wire xq_reg_0_63_0_2_i_61_n_0;
  wire xq_reg_0_63_0_2_i_62_n_0;
  wire xq_reg_0_63_0_2_i_63_n_0;
  wire xq_reg_0_63_0_2_i_64_n_0;
  wire xq_reg_0_63_0_2_i_65_n_0;
  wire xq_reg_0_63_0_2_i_66_n_0;
  wire xq_reg_0_63_0_2_i_67_n_0;
  wire xq_reg_0_63_0_2_i_68_n_0;
  wire xq_reg_0_63_0_2_i_69_n_0;
  wire xq_reg_0_63_0_2_i_69_n_1;
  wire xq_reg_0_63_0_2_i_69_n_2;
  wire xq_reg_0_63_0_2_i_69_n_3;
  wire xq_reg_0_63_0_2_i_70_n_0;
  wire xq_reg_0_63_0_2_i_71_n_0;
  wire xq_reg_0_63_0_2_i_72_n_0;
  wire xq_reg_0_63_0_2_i_73_n_0;
  wire xq_reg_0_63_0_2_i_74_n_1;
  wire xq_reg_0_63_0_2_i_74_n_2;
  wire xq_reg_0_63_0_2_i_74_n_3;
  wire xq_reg_0_63_0_2_i_75_n_0;
  wire xq_reg_0_63_0_2_i_76_n_0;
  wire xq_reg_0_63_0_2_i_77_n_0;
  wire xq_reg_0_63_0_2_i_78_n_0;
  wire xq_reg_0_63_0_2_i_79_n_0;
  wire xq_reg_0_63_0_2_i_79_n_1;
  wire xq_reg_0_63_0_2_i_79_n_2;
  wire xq_reg_0_63_0_2_i_79_n_3;
  wire xq_reg_0_63_0_2_i_7_n_0;
  wire xq_reg_0_63_0_2_i_80_n_0;
  wire xq_reg_0_63_0_2_i_81_n_0;
  wire xq_reg_0_63_0_2_i_82_n_0;
  wire xq_reg_0_63_0_2_i_83_n_0;
  wire xq_reg_0_63_0_2_i_84_n_0;
  wire xq_reg_0_63_0_2_i_85_n_0;
  wire xq_reg_0_63_0_2_i_86_n_0;
  wire xq_reg_0_63_0_2_i_87_n_0;
  wire xq_reg_0_63_0_2_i_88_n_0;
  wire xq_reg_0_63_0_2_i_88_n_1;
  wire xq_reg_0_63_0_2_i_88_n_2;
  wire xq_reg_0_63_0_2_i_88_n_3;
  wire xq_reg_0_63_0_2_i_89_n_0;
  wire xq_reg_0_63_0_2_i_8_n_0;
  wire xq_reg_0_63_0_2_i_90_n_0;
  wire xq_reg_0_63_0_2_i_91_n_0;
  wire xq_reg_0_63_0_2_i_92_n_0;
  wire xq_reg_0_63_0_2_i_93_n_0;
  wire xq_reg_0_63_0_2_i_93_n_1;
  wire xq_reg_0_63_0_2_i_93_n_2;
  wire xq_reg_0_63_0_2_i_93_n_3;
  wire xq_reg_0_63_0_2_i_94_n_0;
  wire xq_reg_0_63_0_2_i_95_n_0;
  wire xq_reg_0_63_0_2_i_96_n_0;
  wire xq_reg_0_63_0_2_i_97_n_0;
  wire xq_reg_0_63_0_2_i_98_n_0;
  wire xq_reg_0_63_0_2_i_98_n_1;
  wire xq_reg_0_63_0_2_i_98_n_2;
  wire xq_reg_0_63_0_2_i_98_n_3;
  wire xq_reg_0_63_0_2_i_99_n_0;
  wire xq_reg_0_63_0_2_i_9_n_3;
  wire xq_reg_0_63_3_5_i_10_n_0;
  wire xq_reg_0_63_3_5_i_4_n_0;
  wire xq_reg_0_63_3_5_i_5_n_0;
  wire xq_reg_0_63_3_5_i_6_n_0;
  wire xq_reg_0_63_3_5_i_7_n_0;
  wire xq_reg_0_63_3_5_i_8_n_0;
  wire xq_reg_0_63_3_5_i_9_n_0;
  wire xq_reg_0_63_6_7_i_2_n_0;
  wire xq_reg_0_63_6_7_i_3_n_0;
  wire xq_reg_0_63_6_7_i_4_n_0;
  wire \xq_seen[0]_i_1_n_0 ;
  wire \xq_seen[10]_i_1_n_0 ;
  wire \xq_seen[11]_i_1_n_0 ;
  wire \xq_seen[12]_i_1_n_0 ;
  wire \xq_seen[13]_i_1_n_0 ;
  wire \xq_seen[14]_i_1_n_0 ;
  wire \xq_seen[15]_i_1_n_0 ;
  wire \xq_seen[15]_i_2_n_0 ;
  wire \xq_seen[16]_i_1_n_0 ;
  wire \xq_seen[17]_i_1_n_0 ;
  wire \xq_seen[18]_i_1_n_0 ;
  wire \xq_seen[19]_i_1_n_0 ;
  wire \xq_seen[1]_i_1_n_0 ;
  wire \xq_seen[20]_i_1_n_0 ;
  wire \xq_seen[21]_i_1_n_0 ;
  wire \xq_seen[22]_i_1_n_0 ;
  wire \xq_seen[23]_i_1_n_0 ;
  wire \xq_seen[23]_i_2_n_0 ;
  wire \xq_seen[24]_i_1_n_0 ;
  wire \xq_seen[25]_i_1_n_0 ;
  wire \xq_seen[26]_i_1_n_0 ;
  wire \xq_seen[27]_i_1_n_0 ;
  wire \xq_seen[28]_i_1_n_0 ;
  wire \xq_seen[29]_i_1_n_0 ;
  wire \xq_seen[2]_i_1_n_0 ;
  wire \xq_seen[30]_i_1_n_0 ;
  wire \xq_seen[31]_i_1_n_0 ;
  wire \xq_seen[31]_i_2_n_0 ;
  wire \xq_seen[32]_i_1_n_0 ;
  wire \xq_seen[32]_i_2_n_0 ;
  wire \xq_seen[33]_i_1_n_0 ;
  wire \xq_seen[33]_i_2_n_0 ;
  wire \xq_seen[34]_i_1_n_0 ;
  wire \xq_seen[34]_i_2_n_0 ;
  wire \xq_seen[35]_i_1_n_0 ;
  wire \xq_seen[35]_i_2_n_0 ;
  wire \xq_seen[36]_i_1_n_0 ;
  wire \xq_seen[36]_i_2_n_0 ;
  wire \xq_seen[37]_i_1_n_0 ;
  wire \xq_seen[37]_i_2_n_0 ;
  wire \xq_seen[38]_i_1_n_0 ;
  wire \xq_seen[38]_i_2_n_0 ;
  wire \xq_seen[39]_i_1_n_0 ;
  wire \xq_seen[39]_i_2_n_0 ;
  wire \xq_seen[39]_i_3_n_0 ;
  wire \xq_seen[39]_i_4_n_0 ;
  wire \xq_seen[3]_i_1_n_0 ;
  wire \xq_seen[4]_i_1_n_0 ;
  wire \xq_seen[5]_i_1_n_0 ;
  wire \xq_seen[6]_i_1_n_0 ;
  wire \xq_seen[7]_i_1_n_0 ;
  wire \xq_seen[7]_i_2_n_0 ;
  wire \xq_seen[8]_i_1_n_0 ;
  wire \xq_seen[9]_i_1_n_0 ;
  wire \xq_seen_reg_n_0_[0] ;
  wire \xq_seen_reg_n_0_[10] ;
  wire \xq_seen_reg_n_0_[11] ;
  wire \xq_seen_reg_n_0_[12] ;
  wire \xq_seen_reg_n_0_[13] ;
  wire \xq_seen_reg_n_0_[14] ;
  wire \xq_seen_reg_n_0_[15] ;
  wire \xq_seen_reg_n_0_[16] ;
  wire \xq_seen_reg_n_0_[17] ;
  wire \xq_seen_reg_n_0_[18] ;
  wire \xq_seen_reg_n_0_[19] ;
  wire \xq_seen_reg_n_0_[1] ;
  wire \xq_seen_reg_n_0_[20] ;
  wire \xq_seen_reg_n_0_[21] ;
  wire \xq_seen_reg_n_0_[22] ;
  wire \xq_seen_reg_n_0_[23] ;
  wire \xq_seen_reg_n_0_[24] ;
  wire \xq_seen_reg_n_0_[25] ;
  wire \xq_seen_reg_n_0_[26] ;
  wire \xq_seen_reg_n_0_[27] ;
  wire \xq_seen_reg_n_0_[28] ;
  wire \xq_seen_reg_n_0_[29] ;
  wire \xq_seen_reg_n_0_[2] ;
  wire \xq_seen_reg_n_0_[30] ;
  wire \xq_seen_reg_n_0_[31] ;
  wire \xq_seen_reg_n_0_[32] ;
  wire \xq_seen_reg_n_0_[33] ;
  wire \xq_seen_reg_n_0_[34] ;
  wire \xq_seen_reg_n_0_[35] ;
  wire \xq_seen_reg_n_0_[36] ;
  wire \xq_seen_reg_n_0_[37] ;
  wire \xq_seen_reg_n_0_[38] ;
  wire \xq_seen_reg_n_0_[39] ;
  wire \xq_seen_reg_n_0_[3] ;
  wire \xq_seen_reg_n_0_[4] ;
  wire \xq_seen_reg_n_0_[5] ;
  wire \xq_seen_reg_n_0_[6] ;
  wire \xq_seen_reg_n_0_[7] ;
  wire \xq_seen_reg_n_0_[8] ;
  wire \xq_seen_reg_n_0_[9] ;
  wire [3:1]\NLW_acc_reg[15]_i_26_CO_UNCONNECTED ;
  wire [3:2]\NLW_acc_reg[15]_i_26_O_UNCONNECTED ;
  wire [3:1]\NLW_acc_reg[15]_i_28_CO_UNCONNECTED ;
  wire [3:2]\NLW_acc_reg[15]_i_28_O_UNCONNECTED ;
  wire [3:3]\NLW_acc_reg[15]_i_3_CO_UNCONNECTED ;
  wire [3:1]\NLW_acc_reg[15]_i_9_CO_UNCONNECTED ;
  wire [3:2]\NLW_acc_reg[15]_i_9_O_UNCONNECTED ;
  wire [3:3]\NLW_acc_reg[31]_i_2_CO_UNCONNECTED ;
  wire [3:1]\NLW_bram_addr_reg[10]_i_44_CO_UNCONNECTED ;
  wire [3:0]\NLW_bram_addr_reg[10]_i_44_O_UNCONNECTED ;
  wire [3:1]\NLW_bram_addr_reg[10]_i_6_CO_UNCONNECTED ;
  wire [3:2]\NLW_bram_addr_reg[10]_i_6_O_UNCONNECTED ;
  wire NLW_bram_addr_reg_rep_0_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_addr_reg_rep_0_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_addr_reg_rep_0_DBITERR_UNCONNECTED;
  wire NLW_bram_addr_reg_rep_0_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_addr_reg_rep_0_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_addr_reg_rep_0_SBITERR_UNCONNECTED;
  wire [31:16]NLW_bram_addr_reg_rep_0_DOADO_UNCONNECTED;
  wire [31:0]NLW_bram_addr_reg_rep_0_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_addr_reg_rep_0_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_addr_reg_rep_0_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_addr_reg_rep_0_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_addr_reg_rep_0_RDADDRECC_UNCONNECTED;
  wire NLW_bram_addr_reg_rep_1_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_addr_reg_rep_1_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_addr_reg_rep_1_DBITERR_UNCONNECTED;
  wire NLW_bram_addr_reg_rep_1_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_addr_reg_rep_1_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_addr_reg_rep_1_SBITERR_UNCONNECTED;
  wire [31:16]NLW_bram_addr_reg_rep_1_DOADO_UNCONNECTED;
  wire [31:0]NLW_bram_addr_reg_rep_1_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_addr_reg_rep_1_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_addr_reg_rep_1_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_addr_reg_rep_1_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_addr_reg_rep_1_RDADDRECC_UNCONNECTED;
  wire NLW_h1_reg_0_63_0_2_DOD_UNCONNECTED;
  wire [3:0]NLW_h1_reg_0_63_0_2_i_16_O_UNCONNECTED;
  wire [3:0]NLW_h1_reg_0_63_0_2_i_163_O_UNCONNECTED;
  wire [3:0]NLW_h1_reg_0_63_0_2_i_198_O_UNCONNECTED;
  wire [3:0]NLW_h1_reg_0_63_0_2_i_224_O_UNCONNECTED;
  wire [3:0]NLW_h1_reg_0_63_0_2_i_252_O_UNCONNECTED;
  wire [3:0]NLW_h1_reg_0_63_0_2_i_40_O_UNCONNECTED;
  wire [3:1]NLW_h1_reg_0_63_0_2_i_6_CO_UNCONNECTED;
  wire [3:0]NLW_h1_reg_0_63_0_2_i_6_O_UNCONNECTED;
  wire [3:3]NLW_h1_reg_0_63_0_2_i_8_CO_UNCONNECTED;
  wire [3:0]NLW_h1_reg_0_63_0_2_i_82_O_UNCONNECTED;
  wire NLW_h1_reg_0_63_3_5_DOD_UNCONNECTED;
  wire NLW_h1_reg_0_63_6_7_SPO_UNCONNECTED;
  wire [1:0]NLW_h2_reg_0_31_0_5_DOD_UNCONNECTED;
  wire NLW_h2_reg_0_31_6_7_SPO_UNCONNECTED;
  wire NLW_h2_reg_0_31_6_7__0_SPO_UNCONNECTED;
  wire NLW_norm_prod0_CARRYCASCOUT_UNCONNECTED;
  wire NLW_norm_prod0_MULTSIGNOUT_UNCONNECTED;
  wire NLW_norm_prod0_OVERFLOW_UNCONNECTED;
  wire NLW_norm_prod0_PATTERNBDETECT_UNCONNECTED;
  wire NLW_norm_prod0_PATTERNDETECT_UNCONNECTED;
  wire NLW_norm_prod0_UNDERFLOW_UNCONNECTED;
  wire [29:0]NLW_norm_prod0_ACOUT_UNCONNECTED;
  wire [17:0]NLW_norm_prod0_BCOUT_UNCONNECTED;
  wire [3:0]NLW_norm_prod0_CARRYOUT_UNCONNECTED;
  wire NLW_norm_prod0__0_CARRYCASCOUT_UNCONNECTED;
  wire NLW_norm_prod0__0_MULTSIGNOUT_UNCONNECTED;
  wire NLW_norm_prod0__0_OVERFLOW_UNCONNECTED;
  wire NLW_norm_prod0__0_PATTERNBDETECT_UNCONNECTED;
  wire NLW_norm_prod0__0_PATTERNDETECT_UNCONNECTED;
  wire NLW_norm_prod0__0_UNDERFLOW_UNCONNECTED;
  wire [17:0]NLW_norm_prod0__0_BCOUT_UNCONNECTED;
  wire [3:0]NLW_norm_prod0__0_CARRYOUT_UNCONNECTED;
  wire NLW_norm_prod_reg_CARRYCASCOUT_UNCONNECTED;
  wire NLW_norm_prod_reg_MULTSIGNOUT_UNCONNECTED;
  wire NLW_norm_prod_reg_OVERFLOW_UNCONNECTED;
  wire NLW_norm_prod_reg_PATTERNBDETECT_UNCONNECTED;
  wire NLW_norm_prod_reg_PATTERNDETECT_UNCONNECTED;
  wire NLW_norm_prod_reg_UNDERFLOW_UNCONNECTED;
  wire [29:0]NLW_norm_prod_reg_ACOUT_UNCONNECTED;
  wire [17:0]NLW_norm_prod_reg_BCOUT_UNCONNECTED;
  wire [3:0]NLW_norm_prod_reg_CARRYOUT_UNCONNECTED;
  wire [47:0]NLW_norm_prod_reg_PCOUT_UNCONNECTED;
  wire NLW_norm_prod_reg__0_CARRYCASCOUT_UNCONNECTED;
  wire NLW_norm_prod_reg__0_MULTSIGNOUT_UNCONNECTED;
  wire NLW_norm_prod_reg__0_OVERFLOW_UNCONNECTED;
  wire NLW_norm_prod_reg__0_PATTERNBDETECT_UNCONNECTED;
  wire NLW_norm_prod_reg__0_PATTERNDETECT_UNCONNECTED;
  wire NLW_norm_prod_reg__0_UNDERFLOW_UNCONNECTED;
  wire [29:0]NLW_norm_prod_reg__0_ACOUT_UNCONNECTED;
  wire [17:0]NLW_norm_prod_reg__0_BCOUT_UNCONNECTED;
  wire [3:0]NLW_norm_prod_reg__0_CARRYOUT_UNCONNECTED;
  wire [47:0]NLW_norm_prod_reg__0_PCOUT_UNCONNECTED;
  wire [3:0]\NLW_out_data_reg[0]_i_15_O_UNCONNECTED ;
  wire [3:0]\NLW_out_data_reg[0]_i_24_O_UNCONNECTED ;
  wire [3:0]\NLW_out_data_reg[0]_i_33_O_UNCONNECTED ;
  wire [3:0]\NLW_out_data_reg[0]_i_4_O_UNCONNECTED ;
  wire [3:0]\NLW_out_data_reg[0]_i_42_O_UNCONNECTED ;
  wire [3:0]\NLW_out_data_reg[0]_i_5_O_UNCONNECTED ;
  wire [3:0]\NLW_out_data_reg[0]_i_51_O_UNCONNECTED ;
  wire [3:0]\NLW_out_data_reg[0]_i_6_O_UNCONNECTED ;
  wire [3:0]\NLW_out_data_reg[1]_i_15_O_UNCONNECTED ;
  wire [3:0]\NLW_out_data_reg[1]_i_24_O_UNCONNECTED ;
  wire [3:0]\NLW_out_data_reg[1]_i_33_O_UNCONNECTED ;
  wire [3:0]\NLW_out_data_reg[1]_i_4_O_UNCONNECTED ;
  wire [3:0]\NLW_out_data_reg[1]_i_42_O_UNCONNECTED ;
  wire [3:0]\NLW_out_data_reg[1]_i_5_O_UNCONNECTED ;
  wire [3:0]\NLW_out_data_reg[1]_i_51_O_UNCONNECTED ;
  wire [3:0]\NLW_out_data_reg[1]_i_6_O_UNCONNECTED ;
  wire [3:0]\NLW_out_data_reg[2]_i_13_O_UNCONNECTED ;
  wire [3:0]\NLW_out_data_reg[2]_i_2_O_UNCONNECTED ;
  wire [3:0]\NLW_out_data_reg[2]_i_30_O_UNCONNECTED ;
  wire [3:0]\NLW_out_data_reg[2]_i_4_O_UNCONNECTED ;
  wire NLW_rq_prod0_CARRYCASCOUT_UNCONNECTED;
  wire NLW_rq_prod0_MULTSIGNOUT_UNCONNECTED;
  wire NLW_rq_prod0_OVERFLOW_UNCONNECTED;
  wire NLW_rq_prod0_PATTERNBDETECT_UNCONNECTED;
  wire NLW_rq_prod0_PATTERNDETECT_UNCONNECTED;
  wire NLW_rq_prod0_UNDERFLOW_UNCONNECTED;
  wire [29:0]NLW_rq_prod0_ACOUT_UNCONNECTED;
  wire [17:0]NLW_rq_prod0_BCOUT_UNCONNECTED;
  wire [3:0]NLW_rq_prod0_CARRYOUT_UNCONNECTED;
  wire NLW_rq_prod_reg_CARRYCASCOUT_UNCONNECTED;
  wire NLW_rq_prod_reg_MULTSIGNOUT_UNCONNECTED;
  wire NLW_rq_prod_reg_OVERFLOW_UNCONNECTED;
  wire NLW_rq_prod_reg_PATTERNBDETECT_UNCONNECTED;
  wire NLW_rq_prod_reg_PATTERNDETECT_UNCONNECTED;
  wire NLW_rq_prod_reg_UNDERFLOW_UNCONNECTED;
  wire [29:0]NLW_rq_prod_reg_ACOUT_UNCONNECTED;
  wire [17:0]NLW_rq_prod_reg_BCOUT_UNCONNECTED;
  wire [3:0]NLW_rq_prod_reg_CARRYOUT_UNCONNECTED;
  wire [47:0]NLW_rq_prod_reg_PCOUT_UNCONNECTED;
  wire NLW_xq_reg_0_63_0_2_DOD_UNCONNECTED;
  wire [3:0]NLW_xq_reg_0_63_0_2_i_141_O_UNCONNECTED;
  wire [3:0]NLW_xq_reg_0_63_0_2_i_21_O_UNCONNECTED;
  wire [3:0]NLW_xq_reg_0_63_0_2_i_217_O_UNCONNECTED;
  wire [3:0]NLW_xq_reg_0_63_0_2_i_239_O_UNCONNECTED;
  wire [3:0]NLW_xq_reg_0_63_0_2_i_269_O_UNCONNECTED;
  wire [3:0]NLW_xq_reg_0_63_0_2_i_302_O_UNCONNECTED;
  wire [3:3]NLW_xq_reg_0_63_0_2_i_31_CO_UNCONNECTED;
  wire [3:0]NLW_xq_reg_0_63_0_2_i_45_O_UNCONNECTED;
  wire [3:3]NLW_xq_reg_0_63_0_2_i_74_CO_UNCONNECTED;
  wire [3:1]NLW_xq_reg_0_63_0_2_i_9_CO_UNCONNECTED;
  wire [3:0]NLW_xq_reg_0_63_0_2_i_9_O_UNCONNECTED;
  wire NLW_xq_reg_0_63_3_5_DOD_UNCONNECTED;
  wire NLW_xq_reg_0_63_6_7_SPO_UNCONNECTED;

  LUT6 #(
    .INIT(64'h000000005F5E5F5F)) 
    \FSM_sequential_state[0]_i_1 
       (.I0(state[4]),
        .I1(state[3]),
        .I2(state[1]),
        .I3(\FSM_sequential_state[0]_i_2_n_0 ),
        .I4(state[2]),
        .I5(state[0]),
        .O(state__0[0]));
  LUT6 #(
    .INIT(64'h1000000000000000)) 
    \FSM_sequential_state[0]_i_2 
       (.I0(\feat_cnt_reg_n_0_[3] ),
        .I1(\feat_cnt_reg_n_0_[4] ),
        .I2(\feat_cnt_reg_n_0_[1] ),
        .I3(\feat_cnt_reg_n_0_[0] ),
        .I4(\feat_cnt_reg_n_0_[5] ),
        .I5(\feat_cnt_reg_n_0_[2] ),
        .O(\FSM_sequential_state[0]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h00FBFFFF00FB0000)) 
    \FSM_sequential_state[1]_i_1 
       (.I0(\layer_reg_n_0_[0] ),
        .I1(\FSM_sequential_state[4]_i_5_n_0 ),
        .I2(state[0]),
        .I3(state[1]),
        .I4(state[4]),
        .I5(\FSM_sequential_state[1]_i_2_n_0 ),
        .O(state__0[1]));
  LUT6 #(
    .INIT(64'h0000BFFFFFFF0000)) 
    \FSM_sequential_state[1]_i_2 
       (.I0(\layer_reg_n_0_[0] ),
        .I1(\layer_reg_n_0_[1] ),
        .I2(state[2]),
        .I3(state[3]),
        .I4(state[1]),
        .I5(state[0]),
        .O(\FSM_sequential_state[1]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h88BBBB88BB88B888)) 
    \FSM_sequential_state[2]_i_2 
       (.I0(\FSM_sequential_state[2]_i_4_n_0 ),
        .I1(state[3]),
        .I2(\FSM_sequential_state[0]_i_2_n_0 ),
        .I3(state[2]),
        .I4(state[1]),
        .I5(state[0]),
        .O(\FSM_sequential_state[2]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h00000004)) 
    \FSM_sequential_state[2]_i_3 
       (.I0(state[0]),
        .I1(\FSM_sequential_state[4]_i_5_n_0 ),
        .I2(\layer_reg_n_0_[1] ),
        .I3(\layer_reg_n_0_[0] ),
        .I4(state[1]),
        .O(\FSM_sequential_state[2]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h00FFBB00FF00F000)) 
    \FSM_sequential_state[2]_i_4 
       (.I0(\layer_reg_n_0_[0] ),
        .I1(\layer_reg_n_0_[1] ),
        .I2(\word_idx[4]_i_3_n_0 ),
        .I3(state[2]),
        .I4(state[1]),
        .I5(state[0]),
        .O(\FSM_sequential_state[2]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFFA505010505050)) 
    \FSM_sequential_state[3]_i_1 
       (.I0(state[4]),
        .I1(\FSM_sequential_state[3]_i_2_n_0 ),
        .I2(state[3]),
        .I3(state[2]),
        .I4(state[0]),
        .I5(state[1]),
        .O(state__0[3]));
  (* SOFT_HLUTNM = "soft_lutpair115" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \FSM_sequential_state[3]_i_2 
       (.I0(\layer_reg_n_0_[1] ),
        .I1(\layer_reg_n_0_[0] ),
        .O(\FSM_sequential_state[3]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h05040505FFFFFFFE)) 
    \FSM_sequential_state[4]_i_1 
       (.I0(state[2]),
        .I1(state[0]),
        .I2(state[3]),
        .I3(\FSM_sequential_state[4]_i_3_n_0 ),
        .I4(state[1]),
        .I5(state[4]),
        .O(\FSM_sequential_state[4]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00F7FFFF00F70000)) 
    \FSM_sequential_state[4]_i_2 
       (.I0(layer_last),
        .I1(\FSM_sequential_state[4]_i_5_n_0 ),
        .I2(state[0]),
        .I3(state[1]),
        .I4(state[4]),
        .I5(\FSM_sequential_state[4]_i_6_n_0 ),
        .O(state__0[4]));
  LUT6 #(
    .INIT(64'h2000FFFF20000000)) 
    \FSM_sequential_state[4]_i_3 
       (.I0(out_ready),
        .I1(out_id[1]),
        .I2(out_id[0]),
        .I3(out_id[2]),
        .I4(state[4]),
        .I5(feat_valid),
        .O(\FSM_sequential_state[4]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair115" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \FSM_sequential_state[4]_i_4 
       (.I0(\layer_reg_n_0_[0] ),
        .I1(\layer_reg_n_0_[1] ),
        .O(layer_last));
  LUT6 #(
    .INIT(64'h0000000040000800)) 
    \FSM_sequential_state[4]_i_5 
       (.I0(\layer_reg_n_0_[1] ),
        .I1(\FSM_sequential_state[4]_i_7_n_0 ),
        .I2(p_0_in[4]),
        .I3(p_0_in[6]),
        .I4(p_0_in[5]),
        .I5(p_0_in[10]),
        .O(\FSM_sequential_state[4]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h80A0808000000000)) 
    \FSM_sequential_state[4]_i_6 
       (.I0(state[3]),
        .I1(state[1]),
        .I2(state[0]),
        .I3(\layer_reg_n_0_[0] ),
        .I4(\layer_reg_n_0_[1] ),
        .I5(state[2]),
        .O(\FSM_sequential_state[4]_i_6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT5 #(
    .INIT(32'h02200044)) 
    \FSM_sequential_state[4]_i_7 
       (.I0(p_0_in[7]),
        .I1(\layer_reg_n_0_[1] ),
        .I2(\layer_reg_n_0_[0] ),
        .I3(p_0_in[9]),
        .I4(p_0_in[8]),
        .O(\FSM_sequential_state[4]_i_7_n_0 ));
  (* FSM_ENCODED_STATES = "S_NEXT:10000,S_REQS:01111,S_REQ:01110,S_LDBN:00111,S_WR:00100,S_NX:00011,S_LST:01101,S_NN:00010,S_OUT:10010,S_NM:00001,S_MAC3:01100,S_IDLE:00000,S_MAC2:01011,S_LDBW:01000,S_LDB:10011,S_MAC1:01010,S_MAC0:01001,S_RQN:00110,S_RQM:00101,S_AM:10001" *) 
  FDRE \FSM_sequential_state_reg[0] 
       (.C(clk),
        .CE(\FSM_sequential_state[4]_i_1_n_0 ),
        .D(state__0[0]),
        .Q(state[0]),
        .R(out_valid_i_1_n_0));
  (* FSM_ENCODED_STATES = "S_NEXT:10000,S_REQS:01111,S_REQ:01110,S_LDBN:00111,S_WR:00100,S_NX:00011,S_LST:01101,S_NN:00010,S_OUT:10010,S_NM:00001,S_MAC3:01100,S_IDLE:00000,S_MAC2:01011,S_LDBW:01000,S_LDB:10011,S_MAC1:01010,S_MAC0:01001,S_RQN:00110,S_RQM:00101,S_AM:10001" *) 
  FDRE \FSM_sequential_state_reg[1] 
       (.C(clk),
        .CE(\FSM_sequential_state[4]_i_1_n_0 ),
        .D(state__0[1]),
        .Q(state[1]),
        .R(out_valid_i_1_n_0));
  (* FSM_ENCODED_STATES = "S_NEXT:10000,S_REQS:01111,S_REQ:01110,S_LDBN:00111,S_WR:00100,S_NX:00011,S_LST:01101,S_NN:00010,S_OUT:10010,S_NM:00001,S_MAC3:01100,S_IDLE:00000,S_MAC2:01011,S_LDBW:01000,S_LDB:10011,S_MAC1:01010,S_MAC0:01001,S_RQN:00110,S_RQM:00101,S_AM:10001" *) 
  FDRE \FSM_sequential_state_reg[2] 
       (.C(clk),
        .CE(\FSM_sequential_state[4]_i_1_n_0 ),
        .D(state__0[2]),
        .Q(state[2]),
        .R(out_valid_i_1_n_0));
  MUXF7 \FSM_sequential_state_reg[2]_i_1 
       (.I0(\FSM_sequential_state[2]_i_2_n_0 ),
        .I1(\FSM_sequential_state[2]_i_3_n_0 ),
        .O(state__0[2]),
        .S(state[4]));
  (* FSM_ENCODED_STATES = "S_NEXT:10000,S_REQS:01111,S_REQ:01110,S_LDBN:00111,S_WR:00100,S_NX:00011,S_LST:01101,S_NN:00010,S_OUT:10010,S_NM:00001,S_MAC3:01100,S_IDLE:00000,S_MAC2:01011,S_LDBW:01000,S_LDB:10011,S_MAC1:01010,S_MAC0:01001,S_RQN:00110,S_RQM:00101,S_AM:10001" *) 
  FDRE \FSM_sequential_state_reg[3] 
       (.C(clk),
        .CE(\FSM_sequential_state[4]_i_1_n_0 ),
        .D(state__0[3]),
        .Q(state[3]),
        .R(out_valid_i_1_n_0));
  (* FSM_ENCODED_STATES = "S_NEXT:10000,S_REQS:01111,S_REQ:01110,S_LDBN:00111,S_WR:00100,S_NX:00011,S_LST:01101,S_NN:00010,S_OUT:10010,S_NM:00001,S_MAC3:01100,S_IDLE:00000,S_MAC2:01011,S_LDBW:01000,S_LDB:10011,S_MAC1:01010,S_MAC0:01001,S_RQN:00110,S_RQM:00101,S_AM:10001" *) 
  FDRE \FSM_sequential_state_reg[4] 
       (.C(clk),
        .CE(\FSM_sequential_state[4]_i_1_n_0 ),
        .D(state__0[4]),
        .Q(state[4]),
        .R(out_valid_i_1_n_0));
  LUT6 #(
    .INIT(64'h00000000FFFE0002)) 
    \acc[0]_i_1 
       (.I0(bram_addr_reg_rep_0_n_35),
        .I1(state[2]),
        .I2(state[0]),
        .I3(state[1]),
        .I4(acc0[0]),
        .I5(state[4]),
        .O(\acc[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFE0002)) 
    \acc[10]_i_1 
       (.I0(bram_addr_reg_rep_0_n_25),
        .I1(state[2]),
        .I2(state[0]),
        .I3(state[1]),
        .I4(acc0[10]),
        .I5(state[4]),
        .O(\acc[10]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFE0002)) 
    \acc[11]_i_1 
       (.I0(bram_addr_reg_rep_0_n_24),
        .I1(state[2]),
        .I2(state[0]),
        .I3(state[1]),
        .I4(acc0[11]),
        .I5(state[4]),
        .O(\acc[11]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \acc[11]_i_3 
       (.I0(acc[11]),
        .I1(mac_product[11]),
        .O(\acc[11]_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \acc[11]_i_4 
       (.I0(acc[10]),
        .I1(mac_product[10]),
        .O(\acc[11]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \acc[11]_i_5 
       (.I0(acc[9]),
        .I1(mac_product[9]),
        .O(\acc[11]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \acc[11]_i_6 
       (.I0(acc[8]),
        .I1(mac_product[8]),
        .O(\acc[11]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFE0002)) 
    \acc[12]_i_1 
       (.I0(bram_addr_reg_rep_0_n_23),
        .I1(state[2]),
        .I2(state[0]),
        .I3(state[1]),
        .I4(acc0[12]),
        .I5(state[4]),
        .O(\acc[12]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFE0002)) 
    \acc[13]_i_1 
       (.I0(bram_addr_reg_rep_0_n_22),
        .I1(state[2]),
        .I2(state[0]),
        .I3(state[1]),
        .I4(acc0[13]),
        .I5(state[4]),
        .O(\acc[13]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFE0002)) 
    \acc[14]_i_1 
       (.I0(bram_addr_reg_rep_0_n_21),
        .I1(state[2]),
        .I2(state[0]),
        .I3(state[1]),
        .I4(acc0[14]),
        .I5(state[4]),
        .O(\acc[14]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFE0002)) 
    \acc[15]_i_1 
       (.I0(bram_addr_reg_rep_0_n_20),
        .I1(state[2]),
        .I2(state[0]),
        .I3(state[1]),
        .I4(acc0[15]),
        .I5(state[4]),
        .O(\acc[15]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    \acc[15]_i_10 
       (.I0(\acc_reg[15]_i_26_n_6 ),
        .I1(\acc_reg[15]_i_23_n_5 ),
        .O(\acc[15]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'h001DFF1DFFFFFFFF)) 
    \acc[15]_i_100 
       (.I0(\acc[3]_i_38_n_0 ),
        .I1(\layer_reg_n_0_[0] ),
        .I2(act0[3]),
        .I3(\layer_reg_n_0_[1] ),
        .I4(h2_reg_0_31_0_5_n_2),
        .I5(B[1]),
        .O(\acc[15]_i_100_n_0 ));
  LUT6 #(
    .INIT(64'h001DFF1DFFFFFFFF)) 
    \acc[15]_i_101 
       (.I0(\acc[15]_i_110_n_0 ),
        .I1(\layer_reg_n_0_[0] ),
        .I2(act0[2]),
        .I3(\layer_reg_n_0_[1] ),
        .I4(h2_reg_0_31_0_5_n_3),
        .I5(B[2]),
        .O(\acc[15]_i_101_n_0 ));
  LUT6 #(
    .INIT(64'h001DFF1DFFFFFFFF)) 
    \acc[15]_i_102 
       (.I0(\acc[15]_i_110_n_0 ),
        .I1(\layer_reg_n_0_[0] ),
        .I2(act0[2]),
        .I3(\layer_reg_n_0_[1] ),
        .I4(h2_reg_0_31_0_5_n_3),
        .I5(B[1]),
        .O(\acc[15]_i_102_n_0 ));
  LUT6 #(
    .INIT(64'h001DFF1DFFFFFFFF)) 
    \acc[15]_i_103 
       (.I0(\acc[15]_i_111_n_0 ),
        .I1(\layer_reg_n_0_[0] ),
        .I2(act0[1]),
        .I3(\layer_reg_n_0_[1] ),
        .I4(h2_reg_0_31_0_5_n_0),
        .I5(B[2]),
        .O(\acc[15]_i_103_n_0 ));
  LUT6 #(
    .INIT(64'hFFE200E200000000)) 
    \acc[15]_i_107 
       (.I0(\acc_reg[15]_i_106_n_0 ),
        .I1(mac_in__0[4]),
        .I2(\acc_reg[15]_i_105_n_0 ),
        .I3(mac_in__0[5]),
        .I4(\acc_reg[15]_i_104_n_0 ),
        .I5(act1[5]),
        .O(\acc[15]_i_107_n_0 ));
  LUT6 #(
    .INIT(64'hFFE200E200000000)) 
    \acc[15]_i_108 
       (.I0(\acc_reg[15]_i_106_n_0 ),
        .I1(mac_in__0[4]),
        .I2(\acc_reg[15]_i_105_n_0 ),
        .I3(mac_in__0[5]),
        .I4(\acc_reg[15]_i_104_n_0 ),
        .I5(act1[4]),
        .O(\acc[15]_i_108_n_0 ));
  LUT6 #(
    .INIT(64'hFFE200E200000000)) 
    \acc[15]_i_109 
       (.I0(\acc_reg[15]_i_106_n_0 ),
        .I1(mac_in__0[4]),
        .I2(\acc_reg[15]_i_105_n_0 ),
        .I3(mac_in__0[5]),
        .I4(\acc_reg[15]_i_104_n_0 ),
        .I5(act1[6]),
        .O(\acc[15]_i_109_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    \acc[15]_i_11 
       (.I0(\acc_reg[15]_i_26_n_7 ),
        .I1(\acc_reg[15]_i_23_n_6 ),
        .O(\acc[15]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hFFE200E200000000)) 
    \acc[15]_i_110 
       (.I0(\acc_reg[15]_i_106_n_0 ),
        .I1(mac_in__0[4]),
        .I2(\acc_reg[15]_i_105_n_0 ),
        .I3(mac_in__0[5]),
        .I4(\acc_reg[15]_i_104_n_0 ),
        .I5(act1[2]),
        .O(\acc[15]_i_110_n_0 ));
  LUT6 #(
    .INIT(64'hFFE200E200000000)) 
    \acc[15]_i_111 
       (.I0(\acc_reg[15]_i_106_n_0 ),
        .I1(mac_in__0[4]),
        .I2(\acc_reg[15]_i_105_n_0 ),
        .I3(mac_in__0[5]),
        .I4(\acc_reg[15]_i_104_n_0 ),
        .I5(act1[1]),
        .O(\acc[15]_i_111_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \acc[15]_i_112 
       (.I0(\xq_seen_reg_n_0_[35] ),
        .I1(\xq_seen_reg_n_0_[34] ),
        .I2(mac_in[1]),
        .I3(\xq_seen_reg_n_0_[33] ),
        .I4(mac_in[0]),
        .I5(\xq_seen_reg_n_0_[32] ),
        .O(\acc[15]_i_112_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \acc[15]_i_113 
       (.I0(\xq_seen_reg_n_0_[39] ),
        .I1(\xq_seen_reg_n_0_[38] ),
        .I2(mac_in[1]),
        .I3(\xq_seen_reg_n_0_[37] ),
        .I4(mac_in[0]),
        .I5(\xq_seen_reg_n_0_[36] ),
        .O(\acc[15]_i_113_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \acc[15]_i_118 
       (.I0(\xq_seen_reg_n_0_[19] ),
        .I1(\xq_seen_reg_n_0_[18] ),
        .I2(mac_in[1]),
        .I3(\xq_seen_reg_n_0_[17] ),
        .I4(mac_in[0]),
        .I5(\xq_seen_reg_n_0_[16] ),
        .O(\acc[15]_i_118_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \acc[15]_i_119 
       (.I0(\xq_seen_reg_n_0_[23] ),
        .I1(\xq_seen_reg_n_0_[22] ),
        .I2(mac_in[1]),
        .I3(\xq_seen_reg_n_0_[21] ),
        .I4(mac_in[0]),
        .I5(\xq_seen_reg_n_0_[20] ),
        .O(\acc[15]_i_119_n_0 ));
  LUT3 #(
    .INIT(8'h78)) 
    \acc[15]_i_12 
       (.I0(\acc_reg[15]_i_26_n_1 ),
        .I1(\acc_reg[15]_i_23_n_4 ),
        .I2(\acc_reg[15]_i_9_n_7 ),
        .O(\acc[15]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \acc[15]_i_120 
       (.I0(\xq_seen_reg_n_0_[27] ),
        .I1(\xq_seen_reg_n_0_[26] ),
        .I2(mac_in[1]),
        .I3(\xq_seen_reg_n_0_[25] ),
        .I4(mac_in[0]),
        .I5(\xq_seen_reg_n_0_[24] ),
        .O(\acc[15]_i_120_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \acc[15]_i_121 
       (.I0(\xq_seen_reg_n_0_[31] ),
        .I1(\xq_seen_reg_n_0_[30] ),
        .I2(mac_in[1]),
        .I3(\xq_seen_reg_n_0_[29] ),
        .I4(mac_in[0]),
        .I5(\xq_seen_reg_n_0_[28] ),
        .O(\acc[15]_i_121_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \acc[15]_i_122 
       (.I0(\xq_seen_reg_n_0_[3] ),
        .I1(\xq_seen_reg_n_0_[2] ),
        .I2(mac_in[1]),
        .I3(\xq_seen_reg_n_0_[1] ),
        .I4(mac_in[0]),
        .I5(\xq_seen_reg_n_0_[0] ),
        .O(\acc[15]_i_122_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \acc[15]_i_123 
       (.I0(\xq_seen_reg_n_0_[7] ),
        .I1(\xq_seen_reg_n_0_[6] ),
        .I2(mac_in[1]),
        .I3(\xq_seen_reg_n_0_[5] ),
        .I4(mac_in[0]),
        .I5(\xq_seen_reg_n_0_[4] ),
        .O(\acc[15]_i_123_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \acc[15]_i_124 
       (.I0(\xq_seen_reg_n_0_[11] ),
        .I1(\xq_seen_reg_n_0_[10] ),
        .I2(mac_in[1]),
        .I3(\xq_seen_reg_n_0_[9] ),
        .I4(mac_in[0]),
        .I5(\xq_seen_reg_n_0_[8] ),
        .O(\acc[15]_i_124_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \acc[15]_i_125 
       (.I0(\xq_seen_reg_n_0_[15] ),
        .I1(\xq_seen_reg_n_0_[14] ),
        .I2(mac_in[1]),
        .I3(\xq_seen_reg_n_0_[13] ),
        .I4(mac_in[0]),
        .I5(\xq_seen_reg_n_0_[12] ),
        .O(\acc[15]_i_125_n_0 ));
  LUT4 #(
    .INIT(16'h8778)) 
    \acc[15]_i_13 
       (.I0(\acc_reg[15]_i_26_n_6 ),
        .I1(\acc_reg[15]_i_23_n_5 ),
        .I2(\acc_reg[15]_i_23_n_4 ),
        .I3(\acc_reg[15]_i_26_n_1 ),
        .O(\acc[15]_i_13_n_0 ));
  LUT4 #(
    .INIT(16'h8778)) 
    \acc[15]_i_14 
       (.I0(\acc_reg[15]_i_26_n_7 ),
        .I1(\acc_reg[15]_i_23_n_6 ),
        .I2(\acc_reg[15]_i_23_n_5 ),
        .I3(\acc_reg[15]_i_26_n_6 ),
        .O(\acc[15]_i_14_n_0 ));
  LUT3 #(
    .INIT(8'hE8)) 
    \acc[15]_i_15 
       (.I0(\acc_reg[15]_i_23_n_7 ),
        .I1(\acc_reg[15]_i_27_n_4 ),
        .I2(\acc_reg[15]_i_28_n_1 ),
        .O(\acc[15]_i_15_n_0 ));
  LUT3 #(
    .INIT(8'hE8)) 
    \acc[15]_i_16 
       (.I0(\acc_reg[15]_i_29_n_4 ),
        .I1(\acc_reg[15]_i_27_n_5 ),
        .I2(\acc_reg[15]_i_28_n_6 ),
        .O(\acc[15]_i_16_n_0 ));
  LUT3 #(
    .INIT(8'hE8)) 
    \acc[15]_i_17 
       (.I0(\acc_reg[15]_i_29_n_5 ),
        .I1(\acc_reg[15]_i_27_n_6 ),
        .I2(\acc_reg[15]_i_28_n_7 ),
        .O(\acc[15]_i_17_n_0 ));
  LUT3 #(
    .INIT(8'hE8)) 
    \acc[15]_i_18 
       (.I0(\acc_reg[15]_i_29_n_6 ),
        .I1(\acc_reg[15]_i_27_n_7 ),
        .I2(\acc_reg[15]_i_30_n_4 ),
        .O(\acc[15]_i_18_n_0 ));
  LUT5 #(
    .INIT(32'hE81717E8)) 
    \acc[15]_i_19 
       (.I0(\acc_reg[15]_i_28_n_1 ),
        .I1(\acc_reg[15]_i_27_n_4 ),
        .I2(\acc_reg[15]_i_23_n_7 ),
        .I3(\acc_reg[15]_i_23_n_6 ),
        .I4(\acc_reg[15]_i_26_n_7 ),
        .O(\acc[15]_i_19_n_0 ));
  LUT4 #(
    .INIT(16'h6996)) 
    \acc[15]_i_20 
       (.I0(\acc[15]_i_16_n_0 ),
        .I1(\acc_reg[15]_i_27_n_4 ),
        .I2(\acc_reg[15]_i_23_n_7 ),
        .I3(\acc_reg[15]_i_28_n_1 ),
        .O(\acc[15]_i_20_n_0 ));
  LUT4 #(
    .INIT(16'h6996)) 
    \acc[15]_i_21 
       (.I0(\acc_reg[15]_i_29_n_4 ),
        .I1(\acc_reg[15]_i_27_n_5 ),
        .I2(\acc_reg[15]_i_28_n_6 ),
        .I3(\acc[15]_i_17_n_0 ),
        .O(\acc[15]_i_21_n_0 ));
  LUT4 #(
    .INIT(16'h6996)) 
    \acc[15]_i_22 
       (.I0(\acc_reg[15]_i_29_n_5 ),
        .I1(\acc_reg[15]_i_27_n_6 ),
        .I2(\acc_reg[15]_i_28_n_7 ),
        .I3(\acc[15]_i_18_n_0 ),
        .O(\acc[15]_i_22_n_0 ));
  LUT5 #(
    .INIT(32'h07777777)) 
    \acc[15]_i_24 
       (.I0(B[7]),
        .I1(A[6]),
        .I2(B[6]),
        .I3(\layer_reg_n_0_[1] ),
        .I4(h2_reg_0_31_6_7__0_n_0),
        .O(\acc[15]_i_24_n_0 ));
  LUT5 #(
    .INIT(32'hE53F3F3F)) 
    \acc[15]_i_25 
       (.I0(B[6]),
        .I1(A[6]),
        .I2(B[7]),
        .I3(\layer_reg_n_0_[1] ),
        .I4(h2_reg_0_31_6_7__0_n_0),
        .O(\acc[15]_i_25_n_0 ));
  LUT4 #(
    .INIT(16'h7000)) 
    \acc[15]_i_31 
       (.I0(B[7]),
        .I1(A[5]),
        .I2(B[6]),
        .I3(A[6]),
        .O(\acc[15]_i_31_n_0 ));
  LUT4 #(
    .INIT(16'h7000)) 
    \acc[15]_i_32 
       (.I0(B[7]),
        .I1(A[4]),
        .I2(B[6]),
        .I3(A[5]),
        .O(\acc[15]_i_32_n_0 ));
  LUT4 #(
    .INIT(16'h7000)) 
    \acc[15]_i_33 
       (.I0(B[7]),
        .I1(A[3]),
        .I2(B[6]),
        .I3(A[4]),
        .O(\acc[15]_i_33_n_0 ));
  LUT4 #(
    .INIT(16'h7000)) 
    \acc[15]_i_34 
       (.I0(B[7]),
        .I1(A[2]),
        .I2(B[6]),
        .I3(A[3]),
        .O(\acc[15]_i_34_n_0 ));
  LUT6 #(
    .INIT(64'h738C8C8CC0C0C0C0)) 
    \acc[15]_i_35 
       (.I0(A[5]),
        .I1(A[6]),
        .I2(B[7]),
        .I3(h2_reg_0_31_6_7__0_n_0),
        .I4(\layer_reg_n_0_[1] ),
        .I5(B[6]),
        .O(\acc[15]_i_35_n_0 ));
  LUT5 #(
    .INIT(32'h8C733F3F)) 
    \acc[15]_i_36 
       (.I0(A[4]),
        .I1(A[5]),
        .I2(B[7]),
        .I3(A[6]),
        .I4(B[6]),
        .O(\acc[15]_i_36_n_0 ));
  LUT5 #(
    .INIT(32'h8C733F3F)) 
    \acc[15]_i_37 
       (.I0(A[3]),
        .I1(A[4]),
        .I2(B[7]),
        .I3(A[5]),
        .I4(B[6]),
        .O(\acc[15]_i_37_n_0 ));
  LUT5 #(
    .INIT(32'h8C733F3F)) 
    \acc[15]_i_38 
       (.I0(A[2]),
        .I1(A[3]),
        .I2(B[7]),
        .I3(A[4]),
        .I4(B[6]),
        .O(\acc[15]_i_38_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair56" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \acc[15]_i_39 
       (.I0(\word_buf_reg_n_0_[31] ),
        .I1(\acc[15]_i_75_n_0 ),
        .I2(\acc[15]_i_76_n_0 ),
        .O(B[7]));
  LUT2 #(
    .INIT(4'h6)) 
    \acc[15]_i_4 
       (.I0(mac_product[15]),
        .I1(acc[15]),
        .O(\acc[15]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hB8BBB888B888B888)) 
    \acc[15]_i_40 
       (.I0(h2_reg_0_31_6_7_n_0),
        .I1(\layer_reg_n_0_[1] ),
        .I2(act0[6]),
        .I3(\layer_reg_n_0_[0] ),
        .I4(act2),
        .I5(act1[6]),
        .O(A[6]));
  (* SOFT_HLUTNM = "soft_lutpair56" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \acc[15]_i_41 
       (.I0(\word_buf_reg_n_0_[30] ),
        .I1(\acc[15]_i_75_n_0 ),
        .I2(\acc[15]_i_78_n_0 ),
        .O(B[6]));
  LUT5 #(
    .INIT(32'h7F000000)) 
    \acc[15]_i_42 
       (.I0(B[4]),
        .I1(\layer_reg_n_0_[1] ),
        .I2(h2_reg_0_31_6_7__0_n_0),
        .I3(B[5]),
        .I4(A[6]),
        .O(\acc[15]_i_42_n_0 ));
  LUT6 #(
    .INIT(64'h8000F888F888F888)) 
    \acc[15]_i_43 
       (.I0(B[5]),
        .I1(A[5]),
        .I2(B[4]),
        .I3(A[6]),
        .I4(B[3]),
        .I5(A[7]),
        .O(\acc[15]_i_43_n_0 ));
  LUT5 #(
    .INIT(32'h2F5F5F5F)) 
    \acc[15]_i_44 
       (.I0(A[6]),
        .I1(B[4]),
        .I2(B[5]),
        .I3(\layer_reg_n_0_[1] ),
        .I4(h2_reg_0_31_6_7__0_n_0),
        .O(\acc[15]_i_44_n_0 ));
  LUT6 #(
    .INIT(64'h2450F30F4BFFC3FF)) 
    \acc[15]_i_45 
       (.I0(B[3]),
        .I1(A[5]),
        .I2(A[6]),
        .I3(B[5]),
        .I4(A[7]),
        .I5(B[4]),
        .O(\acc[15]_i_45_n_0 ));
  LUT6 #(
    .INIT(64'hF888800080008000)) 
    \acc[15]_i_46 
       (.I0(B[5]),
        .I1(A[4]),
        .I2(B[4]),
        .I3(A[5]),
        .I4(B[3]),
        .I5(A[6]),
        .O(\acc[15]_i_46_n_0 ));
  LUT6 #(
    .INIT(64'hF888800080008000)) 
    \acc[15]_i_47 
       (.I0(B[5]),
        .I1(A[3]),
        .I2(B[4]),
        .I3(A[4]),
        .I4(B[3]),
        .I5(A[5]),
        .O(\acc[15]_i_47_n_0 ));
  LUT6 #(
    .INIT(64'hF888800080008000)) 
    \acc[15]_i_48 
       (.I0(B[5]),
        .I1(A[2]),
        .I2(B[4]),
        .I3(A[3]),
        .I4(B[3]),
        .I5(A[4]),
        .O(\acc[15]_i_48_n_0 ));
  LUT6 #(
    .INIT(64'hF888800080008000)) 
    \acc[15]_i_49 
       (.I0(B[5]),
        .I1(A[1]),
        .I2(B[4]),
        .I3(A[2]),
        .I4(B[3]),
        .I5(A[3]),
        .O(\acc[15]_i_49_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \acc[15]_i_5 
       (.I0(acc[14]),
        .I1(mac_product[14]),
        .O(\acc[15]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h6A959595956A6A6A)) 
    \acc[15]_i_50 
       (.I0(\acc[15]_i_46_n_0 ),
        .I1(B[4]),
        .I2(A[6]),
        .I3(B[5]),
        .I4(A[5]),
        .I5(\acc[15]_i_80_n_0 ),
        .O(\acc[15]_i_50_n_0 ));
  LUT6 #(
    .INIT(64'h17E8E817E81717E8)) 
    \acc[15]_i_51 
       (.I0(\acc[15]_i_81_n_0 ),
        .I1(\acc[15]_i_82_n_0 ),
        .I2(\acc[15]_i_83_n_0 ),
        .I3(\acc[15]_i_84_n_0 ),
        .I4(\acc[15]_i_85_n_0 ),
        .I5(\acc[15]_i_86_n_0 ),
        .O(\acc[15]_i_51_n_0 ));
  LUT6 #(
    .INIT(64'h17E8E817E81717E8)) 
    \acc[15]_i_52 
       (.I0(\acc[15]_i_87_n_0 ),
        .I1(\acc[15]_i_88_n_0 ),
        .I2(\acc[15]_i_89_n_0 ),
        .I3(\acc[15]_i_82_n_0 ),
        .I4(\acc[15]_i_83_n_0 ),
        .I5(\acc[15]_i_81_n_0 ),
        .O(\acc[15]_i_52_n_0 ));
  LUT6 #(
    .INIT(64'h17E8E817E81717E8)) 
    \acc[15]_i_53 
       (.I0(\acc[3]_i_30_n_0 ),
        .I1(\acc[15]_i_90_n_0 ),
        .I2(\acc[15]_i_91_n_0 ),
        .I3(\acc[15]_i_88_n_0 ),
        .I4(\acc[15]_i_89_n_0 ),
        .I5(\acc[15]_i_87_n_0 ),
        .O(\acc[15]_i_53_n_0 ));
  LUT5 #(
    .INIT(32'h7F000000)) 
    \acc[15]_i_54 
       (.I0(B[1]),
        .I1(\layer_reg_n_0_[1] ),
        .I2(h2_reg_0_31_6_7__0_n_0),
        .I3(B[2]),
        .I4(A[6]),
        .O(\acc[15]_i_54_n_0 ));
  LUT6 #(
    .INIT(64'h8000F888F888F888)) 
    \acc[15]_i_55 
       (.I0(B[2]),
        .I1(A[5]),
        .I2(B[1]),
        .I3(A[6]),
        .I4(B[0]),
        .I5(A[7]),
        .O(\acc[15]_i_55_n_0 ));
  LUT5 #(
    .INIT(32'h2F5F5F5F)) 
    \acc[15]_i_56 
       (.I0(A[6]),
        .I1(B[1]),
        .I2(B[2]),
        .I3(\layer_reg_n_0_[1] ),
        .I4(h2_reg_0_31_6_7__0_n_0),
        .O(\acc[15]_i_56_n_0 ));
  LUT6 #(
    .INIT(64'h2450F30F4BFFC3FF)) 
    \acc[15]_i_57 
       (.I0(B[0]),
        .I1(A[5]),
        .I2(A[6]),
        .I3(B[2]),
        .I4(A[7]),
        .I5(B[1]),
        .O(\acc[15]_i_57_n_0 ));
  LUT2 #(
    .INIT(4'h7)) 
    \acc[15]_i_58 
       (.I0(A[1]),
        .I1(B[7]),
        .O(\acc[15]_i_58_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    \acc[15]_i_59 
       (.I0(B[7]),
        .I1(A[1]),
        .O(\acc[15]_i_59_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \acc[15]_i_6 
       (.I0(acc[13]),
        .I1(mac_product[13]),
        .O(\acc[15]_i_6_n_0 ));
  LUT2 #(
    .INIT(4'h7)) 
    \acc[15]_i_60 
       (.I0(A[0]),
        .I1(B[7]),
        .O(\acc[15]_i_60_n_0 ));
  LUT5 #(
    .INIT(32'h9F606060)) 
    \acc[15]_i_61 
       (.I0(A[1]),
        .I1(A[2]),
        .I2(B[7]),
        .I3(A[3]),
        .I4(B[6]),
        .O(\acc[15]_i_61_n_0 ));
  LUT4 #(
    .INIT(16'h7888)) 
    \acc[15]_i_62 
       (.I0(B[7]),
        .I1(A[1]),
        .I2(B[6]),
        .I3(A[2]),
        .O(\acc[15]_i_62_n_0 ));
  LUT4 #(
    .INIT(16'h8777)) 
    \acc[15]_i_63 
       (.I0(B[7]),
        .I1(A[0]),
        .I2(B[6]),
        .I3(A[1]),
        .O(\acc[15]_i_63_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    \acc[15]_i_64 
       (.I0(A[0]),
        .I1(B[6]),
        .O(\acc[15]_i_64_n_0 ));
  LUT6 #(
    .INIT(64'hF888800080008000)) 
    \acc[15]_i_65 
       (.I0(B[2]),
        .I1(A[4]),
        .I2(B[1]),
        .I3(A[5]),
        .I4(B[0]),
        .I5(A[6]),
        .O(\acc[15]_i_65_n_0 ));
  LUT6 #(
    .INIT(64'hF888800080008000)) 
    \acc[15]_i_66 
       (.I0(B[2]),
        .I1(A[3]),
        .I2(B[1]),
        .I3(A[4]),
        .I4(B[0]),
        .I5(A[5]),
        .O(\acc[15]_i_66_n_0 ));
  LUT6 #(
    .INIT(64'hF888800080008000)) 
    \acc[15]_i_67 
       (.I0(B[2]),
        .I1(A[2]),
        .I2(B[1]),
        .I3(A[3]),
        .I4(B[0]),
        .I5(A[4]),
        .O(\acc[15]_i_67_n_0 ));
  LUT6 #(
    .INIT(64'hF888800080008000)) 
    \acc[15]_i_68 
       (.I0(B[2]),
        .I1(A[1]),
        .I2(B[1]),
        .I3(A[2]),
        .I4(B[0]),
        .I5(A[3]),
        .O(\acc[15]_i_68_n_0 ));
  LUT6 #(
    .INIT(64'h6A959595956A6A6A)) 
    \acc[15]_i_69 
       (.I0(\acc[15]_i_65_n_0 ),
        .I1(B[1]),
        .I2(A[6]),
        .I3(B[2]),
        .I4(A[5]),
        .I5(\acc[15]_i_92_n_0 ),
        .O(\acc[15]_i_69_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \acc[15]_i_7 
       (.I0(acc[12]),
        .I1(mac_product[12]),
        .O(\acc[15]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h17E8E817E81717E8)) 
    \acc[15]_i_70 
       (.I0(\acc[15]_i_93_n_0 ),
        .I1(\acc[15]_i_94_n_0 ),
        .I2(\acc[15]_i_95_n_0 ),
        .I3(\acc[15]_i_96_n_0 ),
        .I4(\acc[15]_i_97_n_0 ),
        .I5(\acc[15]_i_98_n_0 ),
        .O(\acc[15]_i_70_n_0 ));
  LUT6 #(
    .INIT(64'h17E8E817E81717E8)) 
    \acc[15]_i_71 
       (.I0(\acc[15]_i_99_n_0 ),
        .I1(\acc[15]_i_100_n_0 ),
        .I2(\acc[15]_i_101_n_0 ),
        .I3(\acc[15]_i_94_n_0 ),
        .I4(\acc[15]_i_95_n_0 ),
        .I5(\acc[15]_i_93_n_0 ),
        .O(\acc[15]_i_71_n_0 ));
  LUT6 #(
    .INIT(64'h17E8E817E81717E8)) 
    \acc[15]_i_72 
       (.I0(\acc[3]_i_34_n_0 ),
        .I1(\acc[15]_i_102_n_0 ),
        .I2(\acc[15]_i_103_n_0 ),
        .I3(\acc[15]_i_100_n_0 ),
        .I4(\acc[15]_i_101_n_0 ),
        .I5(\acc[15]_i_99_n_0 ),
        .O(\acc[15]_i_72_n_0 ));
  LUT6 #(
    .INIT(64'hB8BBB888B888B888)) 
    \acc[15]_i_73 
       (.I0(h2_reg_0_31_0_5_n_4),
        .I1(\layer_reg_n_0_[1] ),
        .I2(act0[5]),
        .I3(\layer_reg_n_0_[0] ),
        .I4(act2),
        .I5(act1[5]),
        .O(A[5]));
  LUT6 #(
    .INIT(64'hB8BBB888B888B888)) 
    \acc[15]_i_74 
       (.I0(h2_reg_0_31_0_5_n_5),
        .I1(\layer_reg_n_0_[1] ),
        .I2(act0[4]),
        .I3(\layer_reg_n_0_[0] ),
        .I4(act2),
        .I5(act1[4]),
        .O(A[4]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'hFFFBBBBF)) 
    \acc[15]_i_75 
       (.I0(state[4]),
        .I1(state[3]),
        .I2(state[0]),
        .I3(state[1]),
        .I4(state[2]),
        .O(\acc[15]_i_75_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \acc[15]_i_76 
       (.I0(\word_buf_reg_n_0_[15] ),
        .I1(bram_addr_reg_rep_0_n_28),
        .I2(\word_buf_reg_n_0_[31] ),
        .I3(state_reg[0]),
        .I4(state_reg[1]),
        .I5(\word_buf_reg_n_0_[23] ),
        .O(\acc[15]_i_76_n_0 ));
  LUT5 #(
    .INIT(32'hB8BBB888)) 
    \acc[15]_i_77 
       (.I0(\acc_reg[15]_i_104_n_0 ),
        .I1(mac_in__0[5]),
        .I2(\acc_reg[15]_i_105_n_0 ),
        .I3(mac_in__0[4]),
        .I4(\acc_reg[15]_i_106_n_0 ),
        .O(act2));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \acc[15]_i_78 
       (.I0(\word_buf_reg_n_0_[14] ),
        .I1(bram_addr_reg_rep_0_n_29),
        .I2(\word_buf_reg_n_0_[30] ),
        .I3(state_reg[0]),
        .I4(state_reg[1]),
        .I5(\word_buf_reg_n_0_[22] ),
        .O(\acc[15]_i_78_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    \acc[15]_i_79 
       (.I0(\layer_reg_n_0_[1] ),
        .I1(h2_reg_0_31_6_7__0_n_0),
        .O(A[7]));
  (* SOFT_HLUTNM = "soft_lutpair55" *) 
  LUT3 #(
    .INIT(8'h7F)) 
    \acc[15]_i_80 
       (.I0(h2_reg_0_31_6_7__0_n_0),
        .I1(\layer_reg_n_0_[1] ),
        .I2(B[3]),
        .O(\acc[15]_i_80_n_0 ));
  LUT6 #(
    .INIT(64'h001DFF1DFFFFFFFF)) 
    \acc[15]_i_81 
       (.I0(\acc[15]_i_107_n_0 ),
        .I1(\layer_reg_n_0_[0] ),
        .I2(act0[5]),
        .I3(\layer_reg_n_0_[1] ),
        .I4(h2_reg_0_31_0_5_n_4),
        .I5(B[3]),
        .O(\acc[15]_i_81_n_0 ));
  LUT6 #(
    .INIT(64'h001DFF1DFFFFFFFF)) 
    \acc[15]_i_82 
       (.I0(\acc[15]_i_108_n_0 ),
        .I1(\layer_reg_n_0_[0] ),
        .I2(act0[4]),
        .I3(\layer_reg_n_0_[1] ),
        .I4(h2_reg_0_31_0_5_n_5),
        .I5(B[4]),
        .O(\acc[15]_i_82_n_0 ));
  LUT6 #(
    .INIT(64'h001DFF1DFFFFFFFF)) 
    \acc[15]_i_83 
       (.I0(\acc[3]_i_38_n_0 ),
        .I1(\layer_reg_n_0_[0] ),
        .I2(act0[3]),
        .I3(\layer_reg_n_0_[1] ),
        .I4(h2_reg_0_31_0_5_n_2),
        .I5(B[5]),
        .O(\acc[15]_i_83_n_0 ));
  LUT6 #(
    .INIT(64'h001DFF1DFFFFFFFF)) 
    \acc[15]_i_84 
       (.I0(\acc[15]_i_107_n_0 ),
        .I1(\layer_reg_n_0_[0] ),
        .I2(act0[5]),
        .I3(\layer_reg_n_0_[1] ),
        .I4(h2_reg_0_31_0_5_n_4),
        .I5(B[4]),
        .O(\acc[15]_i_84_n_0 ));
  LUT6 #(
    .INIT(64'h001DFF1DFFFFFFFF)) 
    \acc[15]_i_85 
       (.I0(\acc[15]_i_108_n_0 ),
        .I1(\layer_reg_n_0_[0] ),
        .I2(act0[4]),
        .I3(\layer_reg_n_0_[1] ),
        .I4(h2_reg_0_31_0_5_n_5),
        .I5(B[5]),
        .O(\acc[15]_i_85_n_0 ));
  LUT6 #(
    .INIT(64'h001DFF1DFFFFFFFF)) 
    \acc[15]_i_86 
       (.I0(\acc[15]_i_109_n_0 ),
        .I1(\layer_reg_n_0_[0] ),
        .I2(act0[6]),
        .I3(\layer_reg_n_0_[1] ),
        .I4(h2_reg_0_31_6_7_n_0),
        .I5(B[3]),
        .O(\acc[15]_i_86_n_0 ));
  LUT6 #(
    .INIT(64'h001DFF1DFFFFFFFF)) 
    \acc[15]_i_87 
       (.I0(\acc[15]_i_108_n_0 ),
        .I1(\layer_reg_n_0_[0] ),
        .I2(act0[4]),
        .I3(\layer_reg_n_0_[1] ),
        .I4(h2_reg_0_31_0_5_n_5),
        .I5(B[3]),
        .O(\acc[15]_i_87_n_0 ));
  LUT6 #(
    .INIT(64'h001DFF1DFFFFFFFF)) 
    \acc[15]_i_88 
       (.I0(\acc[3]_i_38_n_0 ),
        .I1(\layer_reg_n_0_[0] ),
        .I2(act0[3]),
        .I3(\layer_reg_n_0_[1] ),
        .I4(h2_reg_0_31_0_5_n_2),
        .I5(B[4]),
        .O(\acc[15]_i_88_n_0 ));
  LUT6 #(
    .INIT(64'h001DFF1DFFFFFFFF)) 
    \acc[15]_i_89 
       (.I0(\acc[15]_i_110_n_0 ),
        .I1(\layer_reg_n_0_[0] ),
        .I2(act0[2]),
        .I3(\layer_reg_n_0_[1] ),
        .I4(h2_reg_0_31_0_5_n_3),
        .I5(B[5]),
        .O(\acc[15]_i_89_n_0 ));
  LUT6 #(
    .INIT(64'h001DFF1DFFFFFFFF)) 
    \acc[15]_i_90 
       (.I0(\acc[15]_i_110_n_0 ),
        .I1(\layer_reg_n_0_[0] ),
        .I2(act0[2]),
        .I3(\layer_reg_n_0_[1] ),
        .I4(h2_reg_0_31_0_5_n_3),
        .I5(B[4]),
        .O(\acc[15]_i_90_n_0 ));
  LUT6 #(
    .INIT(64'h001DFF1DFFFFFFFF)) 
    \acc[15]_i_91 
       (.I0(\acc[15]_i_111_n_0 ),
        .I1(\layer_reg_n_0_[0] ),
        .I2(act0[1]),
        .I3(\layer_reg_n_0_[1] ),
        .I4(h2_reg_0_31_0_5_n_0),
        .I5(B[5]),
        .O(\acc[15]_i_91_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair55" *) 
  LUT3 #(
    .INIT(8'h7F)) 
    \acc[15]_i_92 
       (.I0(h2_reg_0_31_6_7__0_n_0),
        .I1(\layer_reg_n_0_[1] ),
        .I2(B[0]),
        .O(\acc[15]_i_92_n_0 ));
  LUT6 #(
    .INIT(64'h001DFF1DFFFFFFFF)) 
    \acc[15]_i_93 
       (.I0(\acc[15]_i_107_n_0 ),
        .I1(\layer_reg_n_0_[0] ),
        .I2(act0[5]),
        .I3(\layer_reg_n_0_[1] ),
        .I4(h2_reg_0_31_0_5_n_4),
        .I5(B[0]),
        .O(\acc[15]_i_93_n_0 ));
  LUT6 #(
    .INIT(64'h001DFF1DFFFFFFFF)) 
    \acc[15]_i_94 
       (.I0(\acc[15]_i_108_n_0 ),
        .I1(\layer_reg_n_0_[0] ),
        .I2(act0[4]),
        .I3(\layer_reg_n_0_[1] ),
        .I4(h2_reg_0_31_0_5_n_5),
        .I5(B[1]),
        .O(\acc[15]_i_94_n_0 ));
  LUT6 #(
    .INIT(64'h001DFF1DFFFFFFFF)) 
    \acc[15]_i_95 
       (.I0(\acc[3]_i_38_n_0 ),
        .I1(\layer_reg_n_0_[0] ),
        .I2(act0[3]),
        .I3(\layer_reg_n_0_[1] ),
        .I4(h2_reg_0_31_0_5_n_2),
        .I5(B[2]),
        .O(\acc[15]_i_95_n_0 ));
  LUT6 #(
    .INIT(64'h001DFF1DFFFFFFFF)) 
    \acc[15]_i_96 
       (.I0(\acc[15]_i_107_n_0 ),
        .I1(\layer_reg_n_0_[0] ),
        .I2(act0[5]),
        .I3(\layer_reg_n_0_[1] ),
        .I4(h2_reg_0_31_0_5_n_4),
        .I5(B[1]),
        .O(\acc[15]_i_96_n_0 ));
  LUT6 #(
    .INIT(64'h001DFF1DFFFFFFFF)) 
    \acc[15]_i_97 
       (.I0(\acc[15]_i_108_n_0 ),
        .I1(\layer_reg_n_0_[0] ),
        .I2(act0[4]),
        .I3(\layer_reg_n_0_[1] ),
        .I4(h2_reg_0_31_0_5_n_5),
        .I5(B[2]),
        .O(\acc[15]_i_97_n_0 ));
  LUT6 #(
    .INIT(64'h001DFF1DFFFFFFFF)) 
    \acc[15]_i_98 
       (.I0(\acc[15]_i_109_n_0 ),
        .I1(\layer_reg_n_0_[0] ),
        .I2(act0[6]),
        .I3(\layer_reg_n_0_[1] ),
        .I4(h2_reg_0_31_6_7_n_0),
        .I5(B[0]),
        .O(\acc[15]_i_98_n_0 ));
  LUT6 #(
    .INIT(64'h001DFF1DFFFFFFFF)) 
    \acc[15]_i_99 
       (.I0(\acc[15]_i_108_n_0 ),
        .I1(\layer_reg_n_0_[0] ),
        .I2(act0[4]),
        .I3(\layer_reg_n_0_[1] ),
        .I4(h2_reg_0_31_0_5_n_5),
        .I5(B[0]),
        .O(\acc[15]_i_99_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFE0002)) 
    \acc[16]_i_1 
       (.I0(bram_addr_reg_rep_1_n_35),
        .I1(state[2]),
        .I2(state[0]),
        .I3(state[1]),
        .I4(acc0[16]),
        .I5(state[4]),
        .O(\acc[16]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFE0002)) 
    \acc[17]_i_1 
       (.I0(bram_addr_reg_rep_1_n_34),
        .I1(state[2]),
        .I2(state[0]),
        .I3(state[1]),
        .I4(acc0[17]),
        .I5(state[4]),
        .O(\acc[17]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFE0002)) 
    \acc[18]_i_1 
       (.I0(bram_addr_reg_rep_1_n_33),
        .I1(state[2]),
        .I2(state[0]),
        .I3(state[1]),
        .I4(acc0[18]),
        .I5(state[4]),
        .O(\acc[18]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFE0002)) 
    \acc[19]_i_1 
       (.I0(bram_addr_reg_rep_1_n_32),
        .I1(state[2]),
        .I2(state[0]),
        .I3(state[1]),
        .I4(acc0[19]),
        .I5(state[4]),
        .O(\acc[19]_i_1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \acc[19]_i_3 
       (.I0(mac_product[15]),
        .O(\acc[19]_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \acc[19]_i_4 
       (.I0(acc[18]),
        .I1(acc[19]),
        .O(\acc[19]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \acc[19]_i_5 
       (.I0(acc[17]),
        .I1(acc[18]),
        .O(\acc[19]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \acc[19]_i_6 
       (.I0(acc[16]),
        .I1(acc[17]),
        .O(\acc[19]_i_6_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \acc[19]_i_7 
       (.I0(mac_product[15]),
        .I1(acc[16]),
        .O(\acc[19]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFE0002)) 
    \acc[1]_i_1 
       (.I0(bram_addr_reg_rep_0_n_34),
        .I1(state[2]),
        .I2(state[0]),
        .I3(state[1]),
        .I4(acc0[1]),
        .I5(state[4]),
        .O(\acc[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFE0002)) 
    \acc[20]_i_1 
       (.I0(bram_addr_reg_rep_1_n_31),
        .I1(state[2]),
        .I2(state[0]),
        .I3(state[1]),
        .I4(acc0[20]),
        .I5(state[4]),
        .O(\acc[20]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFE0002)) 
    \acc[21]_i_1 
       (.I0(bram_addr_reg_rep_1_n_30),
        .I1(state[2]),
        .I2(state[0]),
        .I3(state[1]),
        .I4(acc0[21]),
        .I5(state[4]),
        .O(\acc[21]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFE0002)) 
    \acc[22]_i_1 
       (.I0(bram_addr_reg_rep_1_n_29),
        .I1(state[2]),
        .I2(state[0]),
        .I3(state[1]),
        .I4(acc0[22]),
        .I5(state[4]),
        .O(\acc[22]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFE0002)) 
    \acc[23]_i_1 
       (.I0(bram_addr_reg_rep_1_n_28),
        .I1(state[2]),
        .I2(state[0]),
        .I3(state[1]),
        .I4(acc0[23]),
        .I5(state[4]),
        .O(\acc[23]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \acc[23]_i_3 
       (.I0(acc[22]),
        .I1(acc[23]),
        .O(\acc[23]_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \acc[23]_i_4 
       (.I0(acc[21]),
        .I1(acc[22]),
        .O(\acc[23]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \acc[23]_i_5 
       (.I0(acc[20]),
        .I1(acc[21]),
        .O(\acc[23]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \acc[23]_i_6 
       (.I0(acc[19]),
        .I1(acc[20]),
        .O(\acc[23]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFE0002)) 
    \acc[24]_i_1 
       (.I0(bram_addr_reg_rep_1_n_27),
        .I1(state[2]),
        .I2(state[0]),
        .I3(state[1]),
        .I4(acc0[24]),
        .I5(state[4]),
        .O(\acc[24]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFE0002)) 
    \acc[25]_i_1 
       (.I0(bram_addr_reg_rep_1_n_26),
        .I1(state[2]),
        .I2(state[0]),
        .I3(state[1]),
        .I4(acc0[25]),
        .I5(state[4]),
        .O(\acc[25]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFE0002)) 
    \acc[26]_i_1 
       (.I0(bram_addr_reg_rep_1_n_25),
        .I1(state[2]),
        .I2(state[0]),
        .I3(state[1]),
        .I4(acc0[26]),
        .I5(state[4]),
        .O(\acc[26]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFE0002)) 
    \acc[27]_i_1 
       (.I0(bram_addr_reg_rep_1_n_24),
        .I1(state[2]),
        .I2(state[0]),
        .I3(state[1]),
        .I4(acc0[27]),
        .I5(state[4]),
        .O(\acc[27]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \acc[27]_i_3 
       (.I0(acc[26]),
        .I1(acc[27]),
        .O(\acc[27]_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \acc[27]_i_4 
       (.I0(acc[25]),
        .I1(acc[26]),
        .O(\acc[27]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \acc[27]_i_5 
       (.I0(acc[24]),
        .I1(acc[25]),
        .O(\acc[27]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \acc[27]_i_6 
       (.I0(acc[23]),
        .I1(acc[24]),
        .O(\acc[27]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFE0002)) 
    \acc[28]_i_1 
       (.I0(bram_addr_reg_rep_1_n_23),
        .I1(state[2]),
        .I2(state[0]),
        .I3(state[1]),
        .I4(acc0[28]),
        .I5(state[4]),
        .O(\acc[28]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFE0002)) 
    \acc[29]_i_1 
       (.I0(bram_addr_reg_rep_1_n_22),
        .I1(state[2]),
        .I2(state[0]),
        .I3(state[1]),
        .I4(acc0[29]),
        .I5(state[4]),
        .O(\acc[29]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFE0002)) 
    \acc[2]_i_1 
       (.I0(bram_addr_reg_rep_0_n_33),
        .I1(state[2]),
        .I2(state[0]),
        .I3(state[1]),
        .I4(acc0[2]),
        .I5(state[4]),
        .O(\acc[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFE0002)) 
    \acc[30]_i_1 
       (.I0(bram_addr_reg_rep_1_n_21),
        .I1(state[2]),
        .I2(state[0]),
        .I3(state[1]),
        .I4(acc0[30]),
        .I5(state[4]),
        .O(\acc[30]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFE0002)) 
    \acc[31]_i_1 
       (.I0(bram_addr_reg_rep_1_n_20),
        .I1(state[2]),
        .I2(state[0]),
        .I3(state[1]),
        .I4(acc0[31]),
        .I5(state[4]),
        .O(\acc[31]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \acc[31]_i_3 
       (.I0(acc[30]),
        .I1(acc[31]),
        .O(\acc[31]_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \acc[31]_i_4 
       (.I0(acc[29]),
        .I1(acc[30]),
        .O(\acc[31]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \acc[31]_i_5 
       (.I0(acc[28]),
        .I1(acc[29]),
        .O(\acc[31]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \acc[31]_i_6 
       (.I0(acc[27]),
        .I1(acc[28]),
        .O(\acc[31]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFE0002)) 
    \acc[3]_i_1 
       (.I0(bram_addr_reg_rep_0_n_32),
        .I1(state[2]),
        .I2(state[0]),
        .I3(state[1]),
        .I4(acc0[3]),
        .I5(state[4]),
        .O(\acc[3]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h7888)) 
    \acc[3]_i_10 
       (.I0(B[4]),
        .I1(A[1]),
        .I2(B[5]),
        .I3(A[0]),
        .O(\acc[3]_i_10_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    \acc[3]_i_11 
       (.I0(B[3]),
        .I1(A[1]),
        .O(\acc[3]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'h99C369C399339933)) 
    \acc[3]_i_12 
       (.I0(A[2]),
        .I1(\acc[3]_i_30_n_0 ),
        .I2(A[1]),
        .I3(B[4]),
        .I4(A[0]),
        .I5(B[5]),
        .O(\acc[3]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'h8777788878887888)) 
    \acc[3]_i_13 
       (.I0(A[0]),
        .I1(B[5]),
        .I2(A[1]),
        .I3(B[4]),
        .I4(B[3]),
        .I5(A[2]),
        .O(\acc[3]_i_13_n_0 ));
  LUT4 #(
    .INIT(16'h7888)) 
    \acc[3]_i_14 
       (.I0(B[3]),
        .I1(A[1]),
        .I2(B[4]),
        .I3(A[0]),
        .O(\acc[3]_i_14_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    \acc[3]_i_15 
       (.I0(A[0]),
        .I1(B[3]),
        .O(\acc[3]_i_15_n_0 ));
  LUT6 #(
    .INIT(64'h8777788878887888)) 
    \acc[3]_i_16 
       (.I0(B[1]),
        .I1(A[2]),
        .I2(B[2]),
        .I3(A[1]),
        .I4(A[3]),
        .I5(B[0]),
        .O(\acc[3]_i_16_n_0 ));
  LUT4 #(
    .INIT(16'h7888)) 
    \acc[3]_i_17 
       (.I0(B[1]),
        .I1(A[1]),
        .I2(B[2]),
        .I3(A[0]),
        .O(\acc[3]_i_17_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    \acc[3]_i_18 
       (.I0(B[0]),
        .I1(A[1]),
        .O(\acc[3]_i_18_n_0 ));
  LUT6 #(
    .INIT(64'h99C369C399339933)) 
    \acc[3]_i_19 
       (.I0(A[2]),
        .I1(\acc[3]_i_34_n_0 ),
        .I2(A[1]),
        .I3(B[1]),
        .I4(A[0]),
        .I5(B[2]),
        .O(\acc[3]_i_19_n_0 ));
  LUT6 #(
    .INIT(64'h8777788878887888)) 
    \acc[3]_i_20 
       (.I0(A[0]),
        .I1(B[2]),
        .I2(A[1]),
        .I3(B[1]),
        .I4(B[0]),
        .I5(A[2]),
        .O(\acc[3]_i_20_n_0 ));
  LUT4 #(
    .INIT(16'h7888)) 
    \acc[3]_i_21 
       (.I0(B[0]),
        .I1(A[1]),
        .I2(B[1]),
        .I3(A[0]),
        .O(\acc[3]_i_21_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    \acc[3]_i_22 
       (.I0(A[0]),
        .I1(B[0]),
        .O(\acc[3]_i_22_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair57" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \acc[3]_i_23 
       (.I0(\word_buf_reg_n_0_[28] ),
        .I1(\acc[15]_i_75_n_0 ),
        .I2(\acc[3]_i_35_n_0 ),
        .O(B[4]));
  LUT6 #(
    .INIT(64'hB8BBB888B888B888)) 
    \acc[3]_i_24 
       (.I0(h2_reg_0_31_0_5_n_3),
        .I1(\layer_reg_n_0_[1] ),
        .I2(act0[2]),
        .I3(\layer_reg_n_0_[0] ),
        .I4(act2),
        .I5(act1[2]),
        .O(A[2]));
  (* SOFT_HLUTNM = "soft_lutpair57" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \acc[3]_i_25 
       (.I0(\word_buf_reg_n_0_[29] ),
        .I1(\acc[15]_i_75_n_0 ),
        .I2(\acc[3]_i_36_n_0 ),
        .O(B[5]));
  LUT6 #(
    .INIT(64'hB8BBB888B888B888)) 
    \acc[3]_i_26 
       (.I0(h2_reg_0_31_0_5_n_0),
        .I1(\layer_reg_n_0_[1] ),
        .I2(act0[1]),
        .I3(\layer_reg_n_0_[0] ),
        .I4(act2),
        .I5(act1[1]),
        .O(A[1]));
  LUT6 #(
    .INIT(64'hB8BBB888B888B888)) 
    \acc[3]_i_27 
       (.I0(h2_reg_0_31_0_5_n_2),
        .I1(\layer_reg_n_0_[1] ),
        .I2(act0[3]),
        .I3(\layer_reg_n_0_[0] ),
        .I4(act2),
        .I5(act1[3]),
        .O(A[3]));
  (* SOFT_HLUTNM = "soft_lutpair58" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \acc[3]_i_28 
       (.I0(\word_buf_reg_n_0_[27] ),
        .I1(\acc[15]_i_75_n_0 ),
        .I2(\acc[3]_i_37_n_0 ),
        .O(B[3]));
  LUT6 #(
    .INIT(64'hB8BBB888B888B888)) 
    \acc[3]_i_29 
       (.I0(h2_reg_0_31_0_5_n_1),
        .I1(\layer_reg_n_0_[1] ),
        .I2(act0[0]),
        .I3(\layer_reg_n_0_[0] ),
        .I4(act2),
        .I5(act1[0]),
        .O(A[0]));
  LUT3 #(
    .INIT(8'h96)) 
    \acc[3]_i_3 
       (.I0(acc[3]),
        .I1(\acc_reg[3]_i_7_n_7 ),
        .I2(\acc_reg[3]_i_8_n_4 ),
        .O(\acc[3]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h001DFF1DFFFFFFFF)) 
    \acc[3]_i_30 
       (.I0(\acc[3]_i_38_n_0 ),
        .I1(\layer_reg_n_0_[0] ),
        .I2(act0[3]),
        .I3(\layer_reg_n_0_[1] ),
        .I4(h2_reg_0_31_0_5_n_2),
        .I5(B[3]),
        .O(\acc[3]_i_30_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair59" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \acc[3]_i_31 
       (.I0(\word_buf_reg_n_0_[25] ),
        .I1(\acc[15]_i_75_n_0 ),
        .I2(\acc[3]_i_39_n_0 ),
        .O(B[1]));
  (* SOFT_HLUTNM = "soft_lutpair58" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \acc[3]_i_32 
       (.I0(\word_buf_reg_n_0_[26] ),
        .I1(\acc[15]_i_75_n_0 ),
        .I2(\acc[3]_i_40_n_0 ),
        .O(B[2]));
  (* SOFT_HLUTNM = "soft_lutpair59" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \acc[3]_i_33 
       (.I0(\word_buf_reg_n_0_[24] ),
        .I1(\acc[15]_i_75_n_0 ),
        .I2(\acc[3]_i_41_n_0 ),
        .O(B[0]));
  LUT6 #(
    .INIT(64'h001DFF1DFFFFFFFF)) 
    \acc[3]_i_34 
       (.I0(\acc[3]_i_38_n_0 ),
        .I1(\layer_reg_n_0_[0] ),
        .I2(act0[3]),
        .I3(\layer_reg_n_0_[1] ),
        .I4(h2_reg_0_31_0_5_n_2),
        .I5(B[0]),
        .O(\acc[3]_i_34_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \acc[3]_i_35 
       (.I0(\word_buf_reg_n_0_[12] ),
        .I1(bram_addr_reg_rep_0_n_31),
        .I2(\word_buf_reg_n_0_[28] ),
        .I3(state_reg[0]),
        .I4(state_reg[1]),
        .I5(\word_buf_reg_n_0_[20] ),
        .O(\acc[3]_i_35_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \acc[3]_i_36 
       (.I0(\word_buf_reg_n_0_[13] ),
        .I1(bram_addr_reg_rep_0_n_30),
        .I2(\word_buf_reg_n_0_[29] ),
        .I3(state_reg[0]),
        .I4(state_reg[1]),
        .I5(\word_buf_reg_n_0_[21] ),
        .O(\acc[3]_i_36_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \acc[3]_i_37 
       (.I0(\word_buf_reg_n_0_[11] ),
        .I1(bram_addr_reg_rep_0_n_32),
        .I2(\word_buf_reg_n_0_[27] ),
        .I3(state_reg[0]),
        .I4(state_reg[1]),
        .I5(\word_buf_reg_n_0_[19] ),
        .O(\acc[3]_i_37_n_0 ));
  LUT6 #(
    .INIT(64'hFFE200E200000000)) 
    \acc[3]_i_38 
       (.I0(\acc_reg[15]_i_106_n_0 ),
        .I1(mac_in__0[4]),
        .I2(\acc_reg[15]_i_105_n_0 ),
        .I3(mac_in__0[5]),
        .I4(\acc_reg[15]_i_104_n_0 ),
        .I5(act1[3]),
        .O(\acc[3]_i_38_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \acc[3]_i_39 
       (.I0(\word_buf_reg_n_0_[9] ),
        .I1(bram_addr_reg_rep_0_n_34),
        .I2(\word_buf_reg_n_0_[25] ),
        .I3(state_reg[0]),
        .I4(state_reg[1]),
        .I5(\word_buf_reg_n_0_[17] ),
        .O(\acc[3]_i_39_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \acc[3]_i_4 
       (.I0(acc[2]),
        .I1(mac_product[2]),
        .O(\acc[3]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \acc[3]_i_40 
       (.I0(\word_buf_reg_n_0_[10] ),
        .I1(bram_addr_reg_rep_0_n_33),
        .I2(\word_buf_reg_n_0_[26] ),
        .I3(state_reg[0]),
        .I4(state_reg[1]),
        .I5(\word_buf_reg_n_0_[18] ),
        .O(\acc[3]_i_40_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \acc[3]_i_41 
       (.I0(\word_buf_reg_n_0_[8] ),
        .I1(bram_addr_reg_rep_0_n_35),
        .I2(\word_buf_reg_n_0_[24] ),
        .I3(state_reg[0]),
        .I4(state_reg[1]),
        .I5(\word_buf_reg_n_0_[16] ),
        .O(\acc[3]_i_41_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \acc[3]_i_5 
       (.I0(acc[1]),
        .I1(mac_product[1]),
        .O(\acc[3]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \acc[3]_i_6 
       (.I0(acc[0]),
        .I1(mac_product[0]),
        .O(\acc[3]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h8777788878887888)) 
    \acc[3]_i_9 
       (.I0(B[4]),
        .I1(A[2]),
        .I2(B[5]),
        .I3(A[1]),
        .I4(A[3]),
        .I5(B[3]),
        .O(\acc[3]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFE0002)) 
    \acc[4]_i_1 
       (.I0(bram_addr_reg_rep_0_n_31),
        .I1(state[2]),
        .I2(state[0]),
        .I3(state[1]),
        .I4(acc0[4]),
        .I5(state[4]),
        .O(\acc[4]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFE0002)) 
    \acc[5]_i_1 
       (.I0(bram_addr_reg_rep_0_n_30),
        .I1(state[2]),
        .I2(state[0]),
        .I3(state[1]),
        .I4(acc0[5]),
        .I5(state[4]),
        .O(\acc[5]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFE0002)) 
    \acc[6]_i_1 
       (.I0(bram_addr_reg_rep_0_n_29),
        .I1(state[2]),
        .I2(state[0]),
        .I3(state[1]),
        .I4(acc0[6]),
        .I5(state[4]),
        .O(\acc[6]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFE0002)) 
    \acc[7]_i_1 
       (.I0(bram_addr_reg_rep_0_n_28),
        .I1(state[2]),
        .I2(state[0]),
        .I3(state[1]),
        .I4(acc0[7]),
        .I5(state[4]),
        .O(\acc[7]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    \acc[7]_i_10 
       (.I0(\acc_reg[15]_i_30_n_7 ),
        .I1(\acc_reg[3]_i_7_n_6 ),
        .O(\acc[7]_i_10_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    \acc[7]_i_11 
       (.I0(\acc_reg[3]_i_8_n_4 ),
        .I1(\acc_reg[3]_i_7_n_7 ),
        .O(\acc[7]_i_11_n_0 ));
  LUT4 #(
    .INIT(16'h6996)) 
    \acc[7]_i_12 
       (.I0(\acc_reg[15]_i_29_n_6 ),
        .I1(\acc_reg[15]_i_27_n_7 ),
        .I2(\acc_reg[15]_i_30_n_4 ),
        .I3(\acc[7]_i_8_n_0 ),
        .O(\acc[7]_i_12_n_0 ));
  (* HLUTNM = "lutpair0" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \acc[7]_i_13 
       (.I0(\acc_reg[15]_i_29_n_7 ),
        .I1(\acc_reg[3]_i_7_n_4 ),
        .I2(\acc_reg[15]_i_30_n_5 ),
        .I3(\acc[7]_i_9_n_0 ),
        .O(\acc[7]_i_13_n_0 ));
  (* HLUTNM = "lutpair1" *) 
  LUT4 #(
    .INIT(16'h9666)) 
    \acc[7]_i_14 
       (.I0(\acc_reg[3]_i_7_n_5 ),
        .I1(\acc_reg[15]_i_30_n_6 ),
        .I2(\acc_reg[15]_i_30_n_7 ),
        .I3(\acc_reg[3]_i_7_n_6 ),
        .O(\acc[7]_i_14_n_0 ));
  LUT4 #(
    .INIT(16'h8778)) 
    \acc[7]_i_15 
       (.I0(\acc_reg[3]_i_8_n_4 ),
        .I1(\acc_reg[3]_i_7_n_7 ),
        .I2(\acc_reg[3]_i_7_n_6 ),
        .I3(\acc_reg[15]_i_30_n_7 ),
        .O(\acc[7]_i_15_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \acc[7]_i_3 
       (.I0(acc[7]),
        .I1(mac_product[7]),
        .O(\acc[7]_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \acc[7]_i_4 
       (.I0(acc[6]),
        .I1(mac_product[6]),
        .O(\acc[7]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \acc[7]_i_5 
       (.I0(acc[5]),
        .I1(mac_product[5]),
        .O(\acc[7]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \acc[7]_i_6 
       (.I0(acc[4]),
        .I1(mac_product[4]),
        .O(\acc[7]_i_6_n_0 ));
  (* HLUTNM = "lutpair0" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \acc[7]_i_8 
       (.I0(\acc_reg[15]_i_29_n_7 ),
        .I1(\acc_reg[3]_i_7_n_4 ),
        .I2(\acc_reg[15]_i_30_n_5 ),
        .O(\acc[7]_i_8_n_0 ));
  (* HLUTNM = "lutpair1" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \acc[7]_i_9 
       (.I0(\acc_reg[3]_i_7_n_5 ),
        .I1(\acc_reg[15]_i_30_n_6 ),
        .O(\acc[7]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFE0002)) 
    \acc[8]_i_1 
       (.I0(bram_addr_reg_rep_0_n_27),
        .I1(state[2]),
        .I2(state[0]),
        .I3(state[1]),
        .I4(acc0[8]),
        .I5(state[4]),
        .O(\acc[8]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFE0002)) 
    \acc[9]_i_1 
       (.I0(bram_addr_reg_rep_0_n_26),
        .I1(state[2]),
        .I2(state[0]),
        .I3(state[1]),
        .I4(acc0[9]),
        .I5(state[4]),
        .O(\acc[9]_i_1_n_0 ));
  FDRE \acc_reg[0] 
       (.C(clk),
        .CE(g0_b0_n_0),
        .D(\acc[0]_i_1_n_0 ),
        .Q(acc[0]),
        .R(out_valid_i_1_n_0));
  FDRE \acc_reg[10] 
       (.C(clk),
        .CE(g0_b0_n_0),
        .D(\acc[10]_i_1_n_0 ),
        .Q(acc[10]),
        .R(out_valid_i_1_n_0));
  FDRE \acc_reg[11] 
       (.C(clk),
        .CE(g0_b0_n_0),
        .D(\acc[11]_i_1_n_0 ),
        .Q(acc[11]),
        .R(out_valid_i_1_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \acc_reg[11]_i_2 
       (.CI(\acc_reg[7]_i_2_n_0 ),
        .CO({\acc_reg[11]_i_2_n_0 ,\acc_reg[11]_i_2_n_1 ,\acc_reg[11]_i_2_n_2 ,\acc_reg[11]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI(acc[11:8]),
        .O(acc0[11:8]),
        .S({\acc[11]_i_3_n_0 ,\acc[11]_i_4_n_0 ,\acc[11]_i_5_n_0 ,\acc[11]_i_6_n_0 }));
  FDRE \acc_reg[12] 
       (.C(clk),
        .CE(g0_b0_n_0),
        .D(\acc[12]_i_1_n_0 ),
        .Q(acc[12]),
        .R(out_valid_i_1_n_0));
  FDRE \acc_reg[13] 
       (.C(clk),
        .CE(g0_b0_n_0),
        .D(\acc[13]_i_1_n_0 ),
        .Q(acc[13]),
        .R(out_valid_i_1_n_0));
  FDRE \acc_reg[14] 
       (.C(clk),
        .CE(g0_b0_n_0),
        .D(\acc[14]_i_1_n_0 ),
        .Q(acc[14]),
        .R(out_valid_i_1_n_0));
  FDRE \acc_reg[15] 
       (.C(clk),
        .CE(g0_b0_n_0),
        .D(\acc[15]_i_1_n_0 ),
        .Q(acc[15]),
        .R(out_valid_i_1_n_0));
  MUXF7 \acc_reg[15]_i_104 
       (.I0(\acc[15]_i_112_n_0 ),
        .I1(\acc[15]_i_113_n_0 ),
        .O(\acc_reg[15]_i_104_n_0 ),
        .S(mac_in__0[2]));
  MUXF8 \acc_reg[15]_i_105 
       (.I0(\acc_reg[15]_i_114_n_0 ),
        .I1(\acc_reg[15]_i_115_n_0 ),
        .O(\acc_reg[15]_i_105_n_0 ),
        .S(mac_in__0[3]));
  MUXF8 \acc_reg[15]_i_106 
       (.I0(\acc_reg[15]_i_116_n_0 ),
        .I1(\acc_reg[15]_i_117_n_0 ),
        .O(\acc_reg[15]_i_106_n_0 ),
        .S(mac_in__0[3]));
  MUXF7 \acc_reg[15]_i_114 
       (.I0(\acc[15]_i_118_n_0 ),
        .I1(\acc[15]_i_119_n_0 ),
        .O(\acc_reg[15]_i_114_n_0 ),
        .S(mac_in__0[2]));
  MUXF7 \acc_reg[15]_i_115 
       (.I0(\acc[15]_i_120_n_0 ),
        .I1(\acc[15]_i_121_n_0 ),
        .O(\acc_reg[15]_i_115_n_0 ),
        .S(mac_in__0[2]));
  MUXF7 \acc_reg[15]_i_116 
       (.I0(\acc[15]_i_122_n_0 ),
        .I1(\acc[15]_i_123_n_0 ),
        .O(\acc_reg[15]_i_116_n_0 ),
        .S(mac_in__0[2]));
  MUXF7 \acc_reg[15]_i_117 
       (.I0(\acc[15]_i_124_n_0 ),
        .I1(\acc[15]_i_125_n_0 ),
        .O(\acc_reg[15]_i_117_n_0 ),
        .S(mac_in__0[2]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \acc_reg[15]_i_2 
       (.CI(\acc_reg[11]_i_2_n_0 ),
        .CO({\acc_reg[15]_i_2_n_0 ,\acc_reg[15]_i_2_n_1 ,\acc_reg[15]_i_2_n_2 ,\acc_reg[15]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({mac_product[15],acc[14:12]}),
        .O(acc0[15:12]),
        .S({\acc[15]_i_4_n_0 ,\acc[15]_i_5_n_0 ,\acc[15]_i_6_n_0 ,\acc[15]_i_7_n_0 }));
  CARRY4 \acc_reg[15]_i_23 
       (.CI(\acc_reg[15]_i_29_n_0 ),
        .CO({\acc_reg[15]_i_23_n_0 ,\acc_reg[15]_i_23_n_1 ,\acc_reg[15]_i_23_n_2 ,\acc_reg[15]_i_23_n_3 }),
        .CYINIT(1'b0),
        .DI({\acc[15]_i_31_n_0 ,\acc[15]_i_32_n_0 ,\acc[15]_i_33_n_0 ,\acc[15]_i_34_n_0 }),
        .O({\acc_reg[15]_i_23_n_4 ,\acc_reg[15]_i_23_n_5 ,\acc_reg[15]_i_23_n_6 ,\acc_reg[15]_i_23_n_7 }),
        .S({\acc[15]_i_35_n_0 ,\acc[15]_i_36_n_0 ,\acc[15]_i_37_n_0 ,\acc[15]_i_38_n_0 }));
  CARRY4 \acc_reg[15]_i_26 
       (.CI(\acc_reg[15]_i_27_n_0 ),
        .CO({\NLW_acc_reg[15]_i_26_CO_UNCONNECTED [3],\acc_reg[15]_i_26_n_1 ,\NLW_acc_reg[15]_i_26_CO_UNCONNECTED [1],\acc_reg[15]_i_26_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,\acc[15]_i_42_n_0 ,\acc[15]_i_43_n_0 }),
        .O({\NLW_acc_reg[15]_i_26_O_UNCONNECTED [3:2],\acc_reg[15]_i_26_n_6 ,\acc_reg[15]_i_26_n_7 }),
        .S({1'b0,1'b1,\acc[15]_i_44_n_0 ,\acc[15]_i_45_n_0 }));
  CARRY4 \acc_reg[15]_i_27 
       (.CI(\acc_reg[3]_i_7_n_0 ),
        .CO({\acc_reg[15]_i_27_n_0 ,\acc_reg[15]_i_27_n_1 ,\acc_reg[15]_i_27_n_2 ,\acc_reg[15]_i_27_n_3 }),
        .CYINIT(1'b0),
        .DI({\acc[15]_i_46_n_0 ,\acc[15]_i_47_n_0 ,\acc[15]_i_48_n_0 ,\acc[15]_i_49_n_0 }),
        .O({\acc_reg[15]_i_27_n_4 ,\acc_reg[15]_i_27_n_5 ,\acc_reg[15]_i_27_n_6 ,\acc_reg[15]_i_27_n_7 }),
        .S({\acc[15]_i_50_n_0 ,\acc[15]_i_51_n_0 ,\acc[15]_i_52_n_0 ,\acc[15]_i_53_n_0 }));
  CARRY4 \acc_reg[15]_i_28 
       (.CI(\acc_reg[15]_i_30_n_0 ),
        .CO({\NLW_acc_reg[15]_i_28_CO_UNCONNECTED [3],\acc_reg[15]_i_28_n_1 ,\NLW_acc_reg[15]_i_28_CO_UNCONNECTED [1],\acc_reg[15]_i_28_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,\acc[15]_i_54_n_0 ,\acc[15]_i_55_n_0 }),
        .O({\NLW_acc_reg[15]_i_28_O_UNCONNECTED [3:2],\acc_reg[15]_i_28_n_6 ,\acc_reg[15]_i_28_n_7 }),
        .S({1'b0,1'b1,\acc[15]_i_56_n_0 ,\acc[15]_i_57_n_0 }));
  CARRY4 \acc_reg[15]_i_29 
       (.CI(1'b0),
        .CO({\acc_reg[15]_i_29_n_0 ,\acc_reg[15]_i_29_n_1 ,\acc_reg[15]_i_29_n_2 ,\acc_reg[15]_i_29_n_3 }),
        .CYINIT(1'b0),
        .DI({\acc[15]_i_58_n_0 ,\acc[15]_i_59_n_0 ,\acc[15]_i_60_n_0 ,1'b0}),
        .O({\acc_reg[15]_i_29_n_4 ,\acc_reg[15]_i_29_n_5 ,\acc_reg[15]_i_29_n_6 ,\acc_reg[15]_i_29_n_7 }),
        .S({\acc[15]_i_61_n_0 ,\acc[15]_i_62_n_0 ,\acc[15]_i_63_n_0 ,\acc[15]_i_64_n_0 }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \acc_reg[15]_i_3 
       (.CI(\acc_reg[15]_i_8_n_0 ),
        .CO({\NLW_acc_reg[15]_i_3_CO_UNCONNECTED [3],\acc_reg[15]_i_3_n_1 ,\acc_reg[15]_i_3_n_2 ,\acc_reg[15]_i_3_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,\acc_reg[15]_i_9_n_7 ,\acc[15]_i_10_n_0 ,\acc[15]_i_11_n_0 }),
        .O(mac_product[15:12]),
        .S({\acc_reg[15]_i_9_n_6 ,\acc[15]_i_12_n_0 ,\acc[15]_i_13_n_0 ,\acc[15]_i_14_n_0 }));
  CARRY4 \acc_reg[15]_i_30 
       (.CI(\acc_reg[3]_i_8_n_0 ),
        .CO({\acc_reg[15]_i_30_n_0 ,\acc_reg[15]_i_30_n_1 ,\acc_reg[15]_i_30_n_2 ,\acc_reg[15]_i_30_n_3 }),
        .CYINIT(1'b0),
        .DI({\acc[15]_i_65_n_0 ,\acc[15]_i_66_n_0 ,\acc[15]_i_67_n_0 ,\acc[15]_i_68_n_0 }),
        .O({\acc_reg[15]_i_30_n_4 ,\acc_reg[15]_i_30_n_5 ,\acc_reg[15]_i_30_n_6 ,\acc_reg[15]_i_30_n_7 }),
        .S({\acc[15]_i_69_n_0 ,\acc[15]_i_70_n_0 ,\acc[15]_i_71_n_0 ,\acc[15]_i_72_n_0 }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \acc_reg[15]_i_8 
       (.CI(\acc_reg[7]_i_7_n_0 ),
        .CO({\acc_reg[15]_i_8_n_0 ,\acc_reg[15]_i_8_n_1 ,\acc_reg[15]_i_8_n_2 ,\acc_reg[15]_i_8_n_3 }),
        .CYINIT(1'b0),
        .DI({\acc[15]_i_15_n_0 ,\acc[15]_i_16_n_0 ,\acc[15]_i_17_n_0 ,\acc[15]_i_18_n_0 }),
        .O(mac_product[11:8]),
        .S({\acc[15]_i_19_n_0 ,\acc[15]_i_20_n_0 ,\acc[15]_i_21_n_0 ,\acc[15]_i_22_n_0 }));
  CARRY4 \acc_reg[15]_i_9 
       (.CI(\acc_reg[15]_i_23_n_0 ),
        .CO({\NLW_acc_reg[15]_i_9_CO_UNCONNECTED [3:1],\acc_reg[15]_i_9_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,\acc[15]_i_24_n_0 }),
        .O({\NLW_acc_reg[15]_i_9_O_UNCONNECTED [3:2],\acc_reg[15]_i_9_n_6 ,\acc_reg[15]_i_9_n_7 }),
        .S({1'b0,1'b0,1'b1,\acc[15]_i_25_n_0 }));
  FDRE \acc_reg[16] 
       (.C(clk),
        .CE(g0_b0_n_0),
        .D(\acc[16]_i_1_n_0 ),
        .Q(acc[16]),
        .R(out_valid_i_1_n_0));
  FDRE \acc_reg[17] 
       (.C(clk),
        .CE(g0_b0_n_0),
        .D(\acc[17]_i_1_n_0 ),
        .Q(acc[17]),
        .R(out_valid_i_1_n_0));
  FDRE \acc_reg[18] 
       (.C(clk),
        .CE(g0_b0_n_0),
        .D(\acc[18]_i_1_n_0 ),
        .Q(acc[18]),
        .R(out_valid_i_1_n_0));
  FDRE \acc_reg[19] 
       (.C(clk),
        .CE(g0_b0_n_0),
        .D(\acc[19]_i_1_n_0 ),
        .Q(acc[19]),
        .R(out_valid_i_1_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \acc_reg[19]_i_2 
       (.CI(\acc_reg[15]_i_2_n_0 ),
        .CO({\acc_reg[19]_i_2_n_0 ,\acc_reg[19]_i_2_n_1 ,\acc_reg[19]_i_2_n_2 ,\acc_reg[19]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({acc[18:16],\acc[19]_i_3_n_0 }),
        .O(acc0[19:16]),
        .S({\acc[19]_i_4_n_0 ,\acc[19]_i_5_n_0 ,\acc[19]_i_6_n_0 ,\acc[19]_i_7_n_0 }));
  FDRE \acc_reg[1] 
       (.C(clk),
        .CE(g0_b0_n_0),
        .D(\acc[1]_i_1_n_0 ),
        .Q(acc[1]),
        .R(out_valid_i_1_n_0));
  FDRE \acc_reg[20] 
       (.C(clk),
        .CE(g0_b0_n_0),
        .D(\acc[20]_i_1_n_0 ),
        .Q(acc[20]),
        .R(out_valid_i_1_n_0));
  FDRE \acc_reg[21] 
       (.C(clk),
        .CE(g0_b0_n_0),
        .D(\acc[21]_i_1_n_0 ),
        .Q(acc[21]),
        .R(out_valid_i_1_n_0));
  FDRE \acc_reg[22] 
       (.C(clk),
        .CE(g0_b0_n_0),
        .D(\acc[22]_i_1_n_0 ),
        .Q(acc[22]),
        .R(out_valid_i_1_n_0));
  FDRE \acc_reg[23] 
       (.C(clk),
        .CE(g0_b0_n_0),
        .D(\acc[23]_i_1_n_0 ),
        .Q(acc[23]),
        .R(out_valid_i_1_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \acc_reg[23]_i_2 
       (.CI(\acc_reg[19]_i_2_n_0 ),
        .CO({\acc_reg[23]_i_2_n_0 ,\acc_reg[23]_i_2_n_1 ,\acc_reg[23]_i_2_n_2 ,\acc_reg[23]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI(acc[22:19]),
        .O(acc0[23:20]),
        .S({\acc[23]_i_3_n_0 ,\acc[23]_i_4_n_0 ,\acc[23]_i_5_n_0 ,\acc[23]_i_6_n_0 }));
  FDRE \acc_reg[24] 
       (.C(clk),
        .CE(g0_b0_n_0),
        .D(\acc[24]_i_1_n_0 ),
        .Q(acc[24]),
        .R(out_valid_i_1_n_0));
  FDRE \acc_reg[25] 
       (.C(clk),
        .CE(g0_b0_n_0),
        .D(\acc[25]_i_1_n_0 ),
        .Q(acc[25]),
        .R(out_valid_i_1_n_0));
  FDRE \acc_reg[26] 
       (.C(clk),
        .CE(g0_b0_n_0),
        .D(\acc[26]_i_1_n_0 ),
        .Q(acc[26]),
        .R(out_valid_i_1_n_0));
  FDRE \acc_reg[27] 
       (.C(clk),
        .CE(g0_b0_n_0),
        .D(\acc[27]_i_1_n_0 ),
        .Q(acc[27]),
        .R(out_valid_i_1_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \acc_reg[27]_i_2 
       (.CI(\acc_reg[23]_i_2_n_0 ),
        .CO({\acc_reg[27]_i_2_n_0 ,\acc_reg[27]_i_2_n_1 ,\acc_reg[27]_i_2_n_2 ,\acc_reg[27]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI(acc[26:23]),
        .O(acc0[27:24]),
        .S({\acc[27]_i_3_n_0 ,\acc[27]_i_4_n_0 ,\acc[27]_i_5_n_0 ,\acc[27]_i_6_n_0 }));
  FDRE \acc_reg[28] 
       (.C(clk),
        .CE(g0_b0_n_0),
        .D(\acc[28]_i_1_n_0 ),
        .Q(acc[28]),
        .R(out_valid_i_1_n_0));
  FDRE \acc_reg[29] 
       (.C(clk),
        .CE(g0_b0_n_0),
        .D(\acc[29]_i_1_n_0 ),
        .Q(acc[29]),
        .R(out_valid_i_1_n_0));
  FDRE \acc_reg[2] 
       (.C(clk),
        .CE(g0_b0_n_0),
        .D(\acc[2]_i_1_n_0 ),
        .Q(acc[2]),
        .R(out_valid_i_1_n_0));
  FDRE \acc_reg[30] 
       (.C(clk),
        .CE(g0_b0_n_0),
        .D(\acc[30]_i_1_n_0 ),
        .Q(acc[30]),
        .R(out_valid_i_1_n_0));
  FDRE \acc_reg[31] 
       (.C(clk),
        .CE(g0_b0_n_0),
        .D(\acc[31]_i_1_n_0 ),
        .Q(acc[31]),
        .R(out_valid_i_1_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \acc_reg[31]_i_2 
       (.CI(\acc_reg[27]_i_2_n_0 ),
        .CO({\NLW_acc_reg[31]_i_2_CO_UNCONNECTED [3],\acc_reg[31]_i_2_n_1 ,\acc_reg[31]_i_2_n_2 ,\acc_reg[31]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,acc[29:27]}),
        .O(acc0[31:28]),
        .S({\acc[31]_i_3_n_0 ,\acc[31]_i_4_n_0 ,\acc[31]_i_5_n_0 ,\acc[31]_i_6_n_0 }));
  FDRE \acc_reg[3] 
       (.C(clk),
        .CE(g0_b0_n_0),
        .D(\acc[3]_i_1_n_0 ),
        .Q(acc[3]),
        .R(out_valid_i_1_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \acc_reg[3]_i_2 
       (.CI(1'b0),
        .CO({\acc_reg[3]_i_2_n_0 ,\acc_reg[3]_i_2_n_1 ,\acc_reg[3]_i_2_n_2 ,\acc_reg[3]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI(acc[3:0]),
        .O(acc0[3:0]),
        .S({\acc[3]_i_3_n_0 ,\acc[3]_i_4_n_0 ,\acc[3]_i_5_n_0 ,\acc[3]_i_6_n_0 }));
  CARRY4 \acc_reg[3]_i_7 
       (.CI(1'b0),
        .CO({\acc_reg[3]_i_7_n_0 ,\acc_reg[3]_i_7_n_1 ,\acc_reg[3]_i_7_n_2 ,\acc_reg[3]_i_7_n_3 }),
        .CYINIT(1'b0),
        .DI({\acc[3]_i_9_n_0 ,\acc[3]_i_10_n_0 ,\acc[3]_i_11_n_0 ,1'b0}),
        .O({\acc_reg[3]_i_7_n_4 ,\acc_reg[3]_i_7_n_5 ,\acc_reg[3]_i_7_n_6 ,\acc_reg[3]_i_7_n_7 }),
        .S({\acc[3]_i_12_n_0 ,\acc[3]_i_13_n_0 ,\acc[3]_i_14_n_0 ,\acc[3]_i_15_n_0 }));
  CARRY4 \acc_reg[3]_i_8 
       (.CI(1'b0),
        .CO({\acc_reg[3]_i_8_n_0 ,\acc_reg[3]_i_8_n_1 ,\acc_reg[3]_i_8_n_2 ,\acc_reg[3]_i_8_n_3 }),
        .CYINIT(1'b0),
        .DI({\acc[3]_i_16_n_0 ,\acc[3]_i_17_n_0 ,\acc[3]_i_18_n_0 ,1'b0}),
        .O({\acc_reg[3]_i_8_n_4 ,mac_product[2:0]}),
        .S({\acc[3]_i_19_n_0 ,\acc[3]_i_20_n_0 ,\acc[3]_i_21_n_0 ,\acc[3]_i_22_n_0 }));
  FDRE \acc_reg[4] 
       (.C(clk),
        .CE(g0_b0_n_0),
        .D(\acc[4]_i_1_n_0 ),
        .Q(acc[4]),
        .R(out_valid_i_1_n_0));
  FDRE \acc_reg[5] 
       (.C(clk),
        .CE(g0_b0_n_0),
        .D(\acc[5]_i_1_n_0 ),
        .Q(acc[5]),
        .R(out_valid_i_1_n_0));
  FDRE \acc_reg[6] 
       (.C(clk),
        .CE(g0_b0_n_0),
        .D(\acc[6]_i_1_n_0 ),
        .Q(acc[6]),
        .R(out_valid_i_1_n_0));
  FDRE \acc_reg[7] 
       (.C(clk),
        .CE(g0_b0_n_0),
        .D(\acc[7]_i_1_n_0 ),
        .Q(acc[7]),
        .R(out_valid_i_1_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \acc_reg[7]_i_2 
       (.CI(\acc_reg[3]_i_2_n_0 ),
        .CO({\acc_reg[7]_i_2_n_0 ,\acc_reg[7]_i_2_n_1 ,\acc_reg[7]_i_2_n_2 ,\acc_reg[7]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI(acc[7:4]),
        .O(acc0[7:4]),
        .S({\acc[7]_i_3_n_0 ,\acc[7]_i_4_n_0 ,\acc[7]_i_5_n_0 ,\acc[7]_i_6_n_0 }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \acc_reg[7]_i_7 
       (.CI(1'b0),
        .CO({\acc_reg[7]_i_7_n_0 ,\acc_reg[7]_i_7_n_1 ,\acc_reg[7]_i_7_n_2 ,\acc_reg[7]_i_7_n_3 }),
        .CYINIT(1'b0),
        .DI({\acc[7]_i_8_n_0 ,\acc[7]_i_9_n_0 ,\acc[7]_i_10_n_0 ,\acc[7]_i_11_n_0 }),
        .O(mac_product[7:4]),
        .S({\acc[7]_i_12_n_0 ,\acc[7]_i_13_n_0 ,\acc[7]_i_14_n_0 ,\acc[7]_i_15_n_0 }));
  FDRE \acc_reg[8] 
       (.C(clk),
        .CE(g0_b0_n_0),
        .D(\acc[8]_i_1_n_0 ),
        .Q(acc[8]),
        .R(out_valid_i_1_n_0));
  FDRE \acc_reg[9] 
       (.C(clk),
        .CE(g0_b0_n_0),
        .D(\acc[9]_i_1_n_0 ),
        .Q(acc[9]),
        .R(out_valid_i_1_n_0));
  LUT6 #(
    .INIT(64'h888BFFFF888B0000)) 
    \bram_addr[0]_i_1 
       (.I0(mac_in__0[2]),
        .I1(state[1]),
        .I2(p_0_in[4]),
        .I3(\FSM_sequential_state[4]_i_5_n_0 ),
        .I4(state[4]),
        .I5(\bram_addr[0]_i_2_n_0 ),
        .O(\bram_addr[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hABA8ABABABA8A8A8)) 
    \bram_addr[0]_i_2 
       (.I0(\bram_addr[0]_i_3_n_0 ),
        .I1(state[2]),
        .I2(state[3]),
        .I3(feat_save_idx[0]),
        .I4(state[0]),
        .I5(feat_index[0]),
        .O(\bram_addr[0]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h7474777777444444)) 
    \bram_addr[0]_i_3 
       (.I0(\bram_addr_reg_n_0_[0] ),
        .I1(\bram_addr[10]_i_22_n_0 ),
        .I2(mac_in__0[2]),
        .I3(p_0_in[4]),
        .I4(state[1]),
        .I5(state[0]),
        .O(\bram_addr[0]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT5 #(
    .INIT(32'h44AE44EA)) 
    \bram_addr[10]_i_10 
       (.I0(state[4]),
        .I1(state[3]),
        .I2(state[0]),
        .I3(state[1]),
        .I4(state[2]),
        .O(state_reg[3]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'hEA50BAAE)) 
    \bram_addr[10]_i_11 
       (.I0(state[4]),
        .I1(state[3]),
        .I2(state[2]),
        .I3(state[0]),
        .I4(state[1]),
        .O(state_reg[2]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT5 #(
    .INIT(32'h5E1B1444)) 
    \bram_addr[10]_i_12 
       (.I0(state[4]),
        .I1(state[3]),
        .I2(state[1]),
        .I3(state[2]),
        .I4(state[0]),
        .O(state_reg[0]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT5 #(
    .INIT(32'hB0F1AFAE)) 
    \bram_addr[10]_i_13 
       (.I0(state[4]),
        .I1(state[3]),
        .I2(state[0]),
        .I3(state[2]),
        .I4(state[1]),
        .O(state_reg[1]));
  LUT4 #(
    .INIT(16'h7F70)) 
    \bram_addr[10]_i_15 
       (.I0(p_0_in[10]),
        .I1(\bram_addr[10]_i_28_n_0 ),
        .I2(\layer_reg_n_0_[1] ),
        .I3(\bram_addr[10]_i_29_n_0 ),
        .O(\bram_addr[10]_i_15_n_0 ));
  LUT4 #(
    .INIT(16'h6F60)) 
    \bram_addr[10]_i_16 
       (.I0(\bram_addr[10]_i_28_n_0 ),
        .I1(p_0_in[10]),
        .I2(\layer_reg_n_0_[1] ),
        .I3(\bram_addr[10]_i_30_n_0 ),
        .O(\bram_addr[10]_i_16_n_0 ));
  LUT6 #(
    .INIT(64'hF8C8C8C8F8C8FBFB)) 
    \bram_addr[10]_i_17 
       (.I0(\bram_addr[10]_i_31_n_0 ),
        .I1(\layer_reg_n_0_[1] ),
        .I2(p_0_in[10]),
        .I3(\bram_addr[10]_i_32_n_0 ),
        .I4(\layer_reg_n_0_[0] ),
        .I5(b_base0),
        .O(in31[7]));
  (* SOFT_HLUTNM = "soft_lutpair60" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \bram_addr[10]_i_18 
       (.I0(in31[5]),
        .I1(\bram_addr[4]_i_6_n_0 ),
        .I2(in31[4]),
        .O(\bram_addr[10]_i_18_n_0 ));
  LUT6 #(
    .INIT(64'h8BBB8B8874447477)) 
    \bram_addr[10]_i_19 
       (.I0(\bram_addr[10]_i_31_n_0 ),
        .I1(\layer_reg_n_0_[1] ),
        .I2(\bram_addr[10]_i_32_n_0 ),
        .I3(\layer_reg_n_0_[0] ),
        .I4(\bram_addr[10]_i_34_n_0 ),
        .I5(p_0_in[10]),
        .O(in31[6]));
  LUT6 #(
    .INIT(64'hB8FFB800B800B800)) 
    \bram_addr[10]_i_2 
       (.I0(in32[10]),
        .I1(state[1]),
        .I2(\bram_addr[10]_i_7_n_0 ),
        .I3(state[4]),
        .I4(\out_id[2]_i_3_n_0 ),
        .I5(\bram_addr[10]_i_8_n_0 ),
        .O(\bram_addr[10]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT5 #(
    .INIT(32'hFFFFFFEA)) 
    \bram_addr[10]_i_20 
       (.I0(\layer_reg_n_0_[1] ),
        .I1(p_0_in[8]),
        .I2(p_0_in[9]),
        .I3(p_0_in[10]),
        .I4(\layer_reg_n_0_[0] ),
        .O(in31[8]));
  LUT6 #(
    .INIT(64'h7FFFFFFF80000000)) 
    \bram_addr[10]_i_21 
       (.I0(\bram_addr_reg_n_0_[8] ),
        .I1(\bram_addr_reg_n_0_[6] ),
        .I2(\bram_addr[7]_i_5_n_0 ),
        .I3(\bram_addr_reg_n_0_[7] ),
        .I4(\bram_addr_reg_n_0_[9] ),
        .I5(\bram_addr_reg_n_0_[10] ),
        .O(in33[10]));
  LUT3 #(
    .INIT(8'hBA)) 
    \bram_addr[10]_i_22 
       (.I0(state[3]),
        .I1(state[2]),
        .I2(state[0]),
        .O(\bram_addr[10]_i_22_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT5 #(
    .INIT(32'hFFBFBFFF)) 
    \bram_addr[10]_i_23 
       (.I0(\word_idx_reg_n_0_[4] ),
        .I1(\word_idx[4]_i_7_n_0 ),
        .I2(mac_in__0[2]),
        .I3(mac_in__0[5]),
        .I4(\layer_reg_n_0_[1] ),
        .O(\bram_addr[10]_i_23_n_0 ));
  LUT6 #(
    .INIT(64'h909F9F9F909F9090)) 
    \bram_addr[10]_i_24 
       (.I0(\bram_addr[10]_i_35_n_0 ),
        .I1(p_0_in[9]),
        .I2(\layer_reg_n_0_[1] ),
        .I3(\bram_addr[10]_i_36_n_0 ),
        .I4(\layer_reg_n_0_[0] ),
        .I5(w_base0),
        .O(\bram_addr[10]_i_24_n_0 ));
  LUT6 #(
    .INIT(64'h1FE0FFFF1FE00000)) 
    \bram_addr[10]_i_25 
       (.I0(p_0_in[5]),
        .I1(p_0_in[6]),
        .I2(p_0_in[7]),
        .I3(p_0_in[8]),
        .I4(\layer_reg_n_0_[1] ),
        .I5(\bram_addr[10]_i_38_n_0 ),
        .O(\bram_addr[10]_i_25_n_0 ));
  LUT5 #(
    .INIT(32'h1EFF1E00)) 
    \bram_addr[10]_i_26 
       (.I0(p_0_in[6]),
        .I1(p_0_in[5]),
        .I2(p_0_in[7]),
        .I3(\layer_reg_n_0_[1] ),
        .I4(\bram_addr[10]_i_39_n_0 ),
        .O(\bram_addr[10]_i_26_n_0 ));
  LUT6 #(
    .INIT(64'h7444747774777444)) 
    \bram_addr[10]_i_27 
       (.I0(\bram_addr[10]_i_40_n_0 ),
        .I1(\layer_reg_n_0_[1] ),
        .I2(\bram_addr[10]_i_41_n_0 ),
        .I3(\layer_reg_n_0_[0] ),
        .I4(w_base1[4]),
        .I5(w_base1[5]),
        .O(\bram_addr[10]_i_27_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT5 #(
    .INIT(32'hFFFFA800)) 
    \bram_addr[10]_i_28 
       (.I0(p_0_in[7]),
        .I1(p_0_in[6]),
        .I2(p_0_in[5]),
        .I3(p_0_in[8]),
        .I4(p_0_in[9]),
        .O(\bram_addr[10]_i_28_n_0 ));
  LUT6 #(
    .INIT(64'h1E001EFF1EFF1E00)) 
    \bram_addr[10]_i_29 
       (.I0(p_0_in[9]),
        .I1(\bram_addr[10]_i_42_n_0 ),
        .I2(p_0_in[10]),
        .I3(\layer_reg_n_0_[0] ),
        .I4(\bram_addr[10]_i_43_n_0 ),
        .I5(w_base1[10]),
        .O(\bram_addr[10]_i_29_n_0 ));
  LUT5 #(
    .INIT(32'h1040AA10)) 
    \bram_addr[10]_i_3 
       (.I0(state[4]),
        .I1(state[3]),
        .I2(state[2]),
        .I3(state[1]),
        .I4(state[0]),
        .O(state_reg[4]));
  LUT6 #(
    .INIT(64'hE100E1FFE1FFE100)) 
    \bram_addr[10]_i_30 
       (.I0(p_0_in[8]),
        .I1(\neuron[5]_i_2_n_0 ),
        .I2(p_0_in[9]),
        .I3(\layer_reg_n_0_[0] ),
        .I4(\bram_addr[10]_i_45_n_0 ),
        .I5(w_base1[9]),
        .O(\bram_addr[10]_i_30_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair52" *) 
  LUT4 #(
    .INIT(16'hAAA8)) 
    \bram_addr[10]_i_31 
       (.I0(p_0_in[9]),
        .I1(p_0_in[8]),
        .I2(p_0_in[6]),
        .I3(p_0_in[7]),
        .O(\bram_addr[10]_i_31_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT5 #(
    .INIT(32'hA8888888)) 
    \bram_addr[10]_i_32 
       (.I0(p_0_in[9]),
        .I1(p_0_in[8]),
        .I2(p_0_in[7]),
        .I3(p_0_in[5]),
        .I4(p_0_in[6]),
        .O(\bram_addr[10]_i_32_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT3 #(
    .INIT(8'hF8)) 
    \bram_addr[10]_i_33 
       (.I0(p_0_in[8]),
        .I1(p_0_in[9]),
        .I2(p_0_in[10]),
        .O(b_base0));
  (* SOFT_HLUTNM = "soft_lutpair52" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \bram_addr[10]_i_34 
       (.I0(p_0_in[9]),
        .I1(p_0_in[8]),
        .O(\bram_addr[10]_i_34_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair49" *) 
  LUT4 #(
    .INIT(16'hA800)) 
    \bram_addr[10]_i_35 
       (.I0(p_0_in[8]),
        .I1(p_0_in[5]),
        .I2(p_0_in[6]),
        .I3(p_0_in[7]),
        .O(\bram_addr[10]_i_35_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    \bram_addr[10]_i_36 
       (.I0(p_0_in[6]),
        .I1(p_0_in[4]),
        .I2(p_0_in[5]),
        .I3(p_0_in[7]),
        .I4(p_0_in[8]),
        .O(\bram_addr[10]_i_36_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT5 #(
    .INIT(32'h07FFF800)) 
    \bram_addr[10]_i_37 
       (.I0(w_base1[4]),
        .I1(w_base1[5]),
        .I2(w_base1[6]),
        .I3(w_base1[7]),
        .I4(w_base1[8]),
        .O(w_base0));
  LUT6 #(
    .INIT(64'h888B8B8BBBB8B8B8)) 
    \bram_addr[10]_i_38 
       (.I0(\bram_addr[10]_i_47_n_0 ),
        .I1(\layer_reg_n_0_[0] ),
        .I2(w_base1[6]),
        .I3(w_base1[5]),
        .I4(w_base1[4]),
        .I5(w_base1[7]),
        .O(\bram_addr[10]_i_38_n_0 ));
  LUT6 #(
    .INIT(64'h6F606060606F6F6F)) 
    \bram_addr[10]_i_39 
       (.I0(\logits[3][31]_i_2_n_0 ),
        .I1(p_0_in[6]),
        .I2(\layer_reg_n_0_[0] ),
        .I3(w_base1[4]),
        .I4(w_base1[5]),
        .I5(w_base1[6]),
        .O(\bram_addr[10]_i_39_n_0 ));
  LUT6 #(
    .INIT(64'h8888B8B8BBBBBBB8)) 
    \bram_addr[10]_i_4 
       (.I0(\bram_addr[10]_i_9_n_0 ),
        .I1(state_reg[3]),
        .I2(state_reg[2]),
        .I3(feat_valid),
        .I4(state_reg[0]),
        .I5(state_reg[1]),
        .O(\bram_addr[10]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \bram_addr[10]_i_40 
       (.I0(p_0_in[5]),
        .I1(p_0_in[6]),
        .O(\bram_addr[10]_i_40_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair116" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \bram_addr[10]_i_41 
       (.I0(p_0_in[4]),
        .I1(p_0_in[5]),
        .O(\bram_addr[10]_i_41_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT5 #(
    .INIT(32'hFFFF8000)) 
    \bram_addr[10]_i_42 
       (.I0(p_0_in[6]),
        .I1(p_0_in[4]),
        .I2(p_0_in[5]),
        .I3(p_0_in[7]),
        .I4(p_0_in[8]),
        .O(\bram_addr[10]_i_42_n_0 ));
  LUT6 #(
    .INIT(64'h8880808000000000)) 
    \bram_addr[10]_i_43 
       (.I0(w_base1[9]),
        .I1(w_base1[7]),
        .I2(w_base1[6]),
        .I3(w_base1[5]),
        .I4(w_base1[4]),
        .I5(w_base1[8]),
        .O(\bram_addr[10]_i_43_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT5 #(
    .INIT(32'hAA800000)) 
    \bram_addr[10]_i_45 
       (.I0(w_base1[8]),
        .I1(w_base1[4]),
        .I2(w_base1[5]),
        .I3(w_base1[6]),
        .I4(w_base1[7]),
        .O(\bram_addr[10]_i_45_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair49" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \bram_addr[10]_i_47 
       (.I0(p_0_in[5]),
        .I1(p_0_in[4]),
        .I2(p_0_in[6]),
        .I3(p_0_in[7]),
        .O(\bram_addr[10]_i_47_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \bram_addr[10]_i_48 
       (.I0(p_0_in[10]),
        .I1(p_0_in[8]),
        .O(\bram_addr[10]_i_48_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \bram_addr[10]_i_49 
       (.I0(p_0_in[9]),
        .I1(p_0_in[7]),
        .O(\bram_addr[10]_i_49_n_0 ));
  LUT6 #(
    .INIT(64'h000000000000F028)) 
    \bram_addr[10]_i_5 
       (.I0(\word_idx[4]_i_4_n_0 ),
        .I1(state[2]),
        .I2(state[1]),
        .I3(state[0]),
        .I4(state[3]),
        .I5(state[4]),
        .O(\bram_addr[10]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hFBBBBBBBBBBBBBBB)) 
    \bram_addr[10]_i_7 
       (.I0(\FSM_sequential_state[4]_i_5_n_0 ),
        .I1(layer_last),
        .I2(in31[7]),
        .I3(\bram_addr[10]_i_18_n_0 ),
        .I4(in31[6]),
        .I5(in31[8]),
        .O(\bram_addr[10]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hB8888888B8BBBB88)) 
    \bram_addr[10]_i_8 
       (.I0(in33[10]),
        .I1(\bram_addr[10]_i_22_n_0 ),
        .I2(in32[10]),
        .I3(state[1]),
        .I4(state[0]),
        .I5(layer_last),
        .O(\bram_addr[10]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'h00700070000F0000)) 
    \bram_addr[10]_i_9 
       (.I0(\FSM_sequential_state[3]_i_2_n_0 ),
        .I1(\FSM_sequential_state[4]_i_5_n_0 ),
        .I2(state_reg[2]),
        .I3(state_reg[0]),
        .I4(\bram_addr[10]_i_23_n_0 ),
        .I5(state_reg[1]),
        .O(\bram_addr[10]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hABA8ABABABA8A8A8)) 
    \bram_addr[1]_i_2 
       (.I0(\bram_addr[1]_i_4_n_0 ),
        .I1(state[2]),
        .I2(state[3]),
        .I3(feat_save_idx[1]),
        .I4(state[0]),
        .I5(feat_index[1]),
        .O(\bram_addr[1]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hB888B8BBB8BBB888)) 
    \bram_addr[1]_i_3 
       (.I0(in32[1]),
        .I1(state[1]),
        .I2(layer_last),
        .I3(\FSM_sequential_state[4]_i_5_n_0 ),
        .I4(p_0_in[4]),
        .I5(in31[1]),
        .O(\bram_addr[1]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h6F666F6F60666060)) 
    \bram_addr[1]_i_4 
       (.I0(\bram_addr_reg_n_0_[0] ),
        .I1(\bram_addr_reg_n_0_[1] ),
        .I2(state[3]),
        .I3(state[2]),
        .I4(state[0]),
        .I5(\bram_addr[1]_i_6_n_0 ),
        .O(\bram_addr[1]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'hB4)) 
    \bram_addr[1]_i_5 
       (.I0(\layer_reg_n_0_[1] ),
        .I1(\layer_reg_n_0_[0] ),
        .I2(p_0_in[5]),
        .O(in31[1]));
  LUT6 #(
    .INIT(64'hAFC0AF30AFC0A0C0)) 
    \bram_addr[1]_i_6 
       (.I0(in32[1]),
        .I1(p_0_in[5]),
        .I2(state[1]),
        .I3(state[0]),
        .I4(\layer_reg_n_0_[1] ),
        .I5(\layer_reg_n_0_[0] ),
        .O(\bram_addr[1]_i_6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'hB8FFB800)) 
    \bram_addr[2]_i_1 
       (.I0(in32[2]),
        .I1(state[1]),
        .I2(\bram_addr[2]_i_3_n_0 ),
        .I3(state[4]),
        .I4(\bram_addr[2]_i_4_n_0 ),
        .O(\bram_addr[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h888B8B8BBBB8B8B8)) 
    \bram_addr[2]_i_11 
       (.I0(in32[2]),
        .I1(state[0]),
        .I2(\layer_reg_n_0_[1] ),
        .I3(p_0_in[5]),
        .I4(\layer_reg_n_0_[0] ),
        .I5(p_0_in[6]),
        .O(\bram_addr[2]_i_11_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \bram_addr[2]_i_12 
       (.I0(p_0_in[8]),
        .I1(p_0_in[6]),
        .O(\bram_addr[2]_i_12_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \bram_addr[2]_i_13 
       (.I0(p_0_in[7]),
        .I1(p_0_in[5]),
        .O(\bram_addr[2]_i_13_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \bram_addr[2]_i_14 
       (.I0(p_0_in[6]),
        .I1(p_0_in[4]),
        .O(\bram_addr[2]_i_14_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFF009336936C)) 
    \bram_addr[2]_i_3 
       (.I0(p_0_in[4]),
        .I1(p_0_in[6]),
        .I2(p_0_in[5]),
        .I3(\layer_reg_n_0_[1] ),
        .I4(\layer_reg_n_0_[0] ),
        .I5(\FSM_sequential_state[4]_i_5_n_0 ),
        .O(\bram_addr[2]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hABA8ABABABA8A8A8)) 
    \bram_addr[2]_i_4 
       (.I0(\bram_addr[2]_i_9_n_0 ),
        .I1(state[2]),
        .I2(state[3]),
        .I3(feat_save_idx[2]),
        .I4(state[0]),
        .I5(feat_index[2]),
        .O(\bram_addr[2]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hFFE200E2001DFF1D)) 
    \bram_addr[2]_i_5 
       (.I0(w_base1[4]),
        .I1(\layer_reg_n_0_[0] ),
        .I2(p_0_in[4]),
        .I3(\layer_reg_n_0_[1] ),
        .I4(p_0_in[5]),
        .I5(\word_idx_reg_n_0_[4] ),
        .O(\bram_addr[2]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'h0BFBF404)) 
    \bram_addr[2]_i_6 
       (.I0(\layer_reg_n_0_[0] ),
        .I1(w_base1[3]),
        .I2(\layer_reg_n_0_[1] ),
        .I3(p_0_in[4]),
        .I4(mac_in__0[5]),
        .O(\bram_addr[2]_i_6_n_0 ));
  LUT4 #(
    .INIT(16'h0DF2)) 
    \bram_addr[2]_i_7 
       (.I0(w_base1[2]),
        .I1(\layer_reg_n_0_[0] ),
        .I2(\layer_reg_n_0_[1] ),
        .I3(mac_in__0[4]),
        .O(\bram_addr[2]_i_7_n_0 ));
  LUT4 #(
    .INIT(16'hAB54)) 
    \bram_addr[2]_i_8 
       (.I0(\layer_reg_n_0_[1] ),
        .I1(\layer_reg_n_0_[0] ),
        .I2(p_0_in[4]),
        .I3(mac_in__0[3]),
        .O(\bram_addr[2]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'h78FF780078007800)) 
    \bram_addr[2]_i_9 
       (.I0(\bram_addr_reg_n_0_[0] ),
        .I1(\bram_addr_reg_n_0_[1] ),
        .I2(\bram_addr_reg_n_0_[2] ),
        .I3(\bram_addr[10]_i_22_n_0 ),
        .I4(state[1]),
        .I5(\bram_addr[2]_i_11_n_0 ),
        .O(\bram_addr[2]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hA8ABABABA8ABA8A8)) 
    \bram_addr[3]_i_2 
       (.I0(\bram_addr[3]_i_4_n_0 ),
        .I1(state[2]),
        .I2(state[3]),
        .I3(feat_save_idx[3]),
        .I4(state[0]),
        .I5(feat_index[3]),
        .O(\bram_addr[3]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hBBBBBB88B8B8B8B8)) 
    \bram_addr[3]_i_3 
       (.I0(in32[3]),
        .I1(state[1]),
        .I2(\bram_addr[3]_i_5_n_0 ),
        .I3(\layer_reg_n_0_[1] ),
        .I4(\layer_reg_n_0_[0] ),
        .I5(\FSM_sequential_state[4]_i_5_n_0 ),
        .O(\bram_addr[3]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hB8B8B8888888B888)) 
    \bram_addr[3]_i_4 
       (.I0(in33[3]),
        .I1(\bram_addr[10]_i_22_n_0 ),
        .I2(state[1]),
        .I3(in31[3]),
        .I4(state[0]),
        .I5(in32[3]),
        .O(\bram_addr[3]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hCC99CC3336CC6CCC)) 
    \bram_addr[3]_i_5 
       (.I0(p_0_in[4]),
        .I1(p_0_in[7]),
        .I2(\layer_reg_n_0_[0] ),
        .I3(p_0_in[6]),
        .I4(p_0_in[5]),
        .I5(\layer_reg_n_0_[1] ),
        .O(\bram_addr[3]_i_5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \bram_addr[3]_i_6 
       (.I0(\bram_addr_reg_n_0_[1] ),
        .I1(\bram_addr_reg_n_0_[0] ),
        .I2(\bram_addr_reg_n_0_[2] ),
        .I3(\bram_addr_reg_n_0_[3] ),
        .O(in33[3]));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT5 #(
    .INIT(32'hB5F54A0A)) 
    \bram_addr[3]_i_7 
       (.I0(\layer_reg_n_0_[1] ),
        .I1(p_0_in[5]),
        .I2(p_0_in[6]),
        .I3(\layer_reg_n_0_[0] ),
        .I4(p_0_in[7]),
        .O(in31[3]));
  LUT6 #(
    .INIT(64'h8BB8BBBB8BB88888)) 
    \bram_addr[4]_i_2 
       (.I0(\bram_addr[4]_i_4_n_0 ),
        .I1(\out_id[2]_i_3_n_0 ),
        .I2(feat_save_idx[3]),
        .I3(feat_save_idx[4]),
        .I4(\bram_addr[10]_i_22_n_0 ),
        .I5(feat_index[4]),
        .O(\bram_addr[4]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hB8BBBBB8)) 
    \bram_addr[4]_i_3 
       (.I0(in32[4]),
        .I1(state[1]),
        .I2(\FSM_sequential_state[4]_i_5_n_0 ),
        .I3(in31[4]),
        .I4(\bram_addr[4]_i_6_n_0 ),
        .O(\bram_addr[4]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hBBB888B8BBBBBBBB)) 
    \bram_addr[4]_i_4 
       (.I0(in33[4]),
        .I1(\bram_addr[10]_i_22_n_0 ),
        .I2(in31[4]),
        .I3(state[0]),
        .I4(in32[4]),
        .I5(state[1]),
        .O(\bram_addr[4]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hEA88AA8815775577)) 
    \bram_addr[4]_i_5 
       (.I0(\layer_reg_n_0_[1] ),
        .I1(p_0_in[6]),
        .I2(p_0_in[5]),
        .I3(p_0_in[7]),
        .I4(\layer_reg_n_0_[0] ),
        .I5(p_0_in[8]),
        .O(in31[4]));
  LUT6 #(
    .INIT(64'h0028000044000000)) 
    \bram_addr[4]_i_6 
       (.I0(p_0_in[7]),
        .I1(p_0_in[5]),
        .I2(\layer_reg_n_0_[0] ),
        .I3(\layer_reg_n_0_[1] ),
        .I4(p_0_in[4]),
        .I5(p_0_in[6]),
        .O(\bram_addr[4]_i_6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    \bram_addr[4]_i_7 
       (.I0(\bram_addr_reg_n_0_[2] ),
        .I1(\bram_addr_reg_n_0_[0] ),
        .I2(\bram_addr_reg_n_0_[1] ),
        .I3(\bram_addr_reg_n_0_[3] ),
        .I4(\bram_addr_reg_n_0_[4] ),
        .O(in33[4]));
  LUT6 #(
    .INIT(64'h00007FFFFFFF8000)) 
    \bram_addr[5]_i_10 
       (.I0(p_0_in[7]),
        .I1(p_0_in[5]),
        .I2(p_0_in[6]),
        .I3(\layer_reg_n_0_[0] ),
        .I4(p_0_in[8]),
        .I5(p_0_in[9]),
        .O(\bram_addr[5]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hB88BBBBBB88B8888)) 
    \bram_addr[5]_i_2 
       (.I0(\bram_addr_reg[5]_i_4_n_0 ),
        .I1(\out_id[2]_i_3_n_0 ),
        .I2(\bram_addr[5]_i_5_n_0 ),
        .I3(feat_save_idx[5]),
        .I4(\bram_addr[10]_i_22_n_0 ),
        .I5(feat_index[5]),
        .O(\bram_addr[5]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hB888B8BBB8BBB888)) 
    \bram_addr[5]_i_3 
       (.I0(in32[5]),
        .I1(state[1]),
        .I2(layer_last),
        .I3(\FSM_sequential_state[4]_i_5_n_0 ),
        .I4(\bram_addr[5]_i_6_n_0 ),
        .I5(in31[5]),
        .O(\bram_addr[5]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair114" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \bram_addr[5]_i_5 
       (.I0(feat_save_idx[4]),
        .I1(feat_save_idx[3]),
        .O(\bram_addr[5]_i_5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair60" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \bram_addr[5]_i_6 
       (.I0(in31[4]),
        .I1(\bram_addr[4]_i_6_n_0 ),
        .O(\bram_addr[5]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h01FEFFFF01FE0000)) 
    \bram_addr[5]_i_7 
       (.I0(p_0_in[8]),
        .I1(p_0_in[6]),
        .I2(p_0_in[7]),
        .I3(p_0_in[9]),
        .I4(\layer_reg_n_0_[1] ),
        .I5(\bram_addr[5]_i_10_n_0 ),
        .O(in31[5]));
  LUT6 #(
    .INIT(64'hAFC0AFC0AFC0A0C0)) 
    \bram_addr[5]_i_8 
       (.I0(in32[5]),
        .I1(in31[5]),
        .I2(state[1]),
        .I3(state[0]),
        .I4(\layer_reg_n_0_[1] ),
        .I5(\layer_reg_n_0_[0] ),
        .O(\bram_addr[5]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'h7FFFFFFF80000000)) 
    \bram_addr[5]_i_9 
       (.I0(\bram_addr_reg_n_0_[3] ),
        .I1(\bram_addr_reg_n_0_[1] ),
        .I2(\bram_addr_reg_n_0_[0] ),
        .I3(\bram_addr_reg_n_0_[2] ),
        .I4(\bram_addr_reg_n_0_[4] ),
        .I5(\bram_addr_reg_n_0_[5] ),
        .O(in33[5]));
  LUT6 #(
    .INIT(64'h6F60FFFF6F600000)) 
    \bram_addr[6]_i_2 
       (.I0(\bram_addr[7]_i_5_n_0 ),
        .I1(\bram_addr_reg_n_0_[6] ),
        .I2(\bram_addr[10]_i_22_n_0 ),
        .I3(\bram_addr[6]_i_4_n_0 ),
        .I4(\out_id[2]_i_3_n_0 ),
        .I5(\bram_addr[6]_i_5_n_0 ),
        .O(\bram_addr[6]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h8888BBBB8BB88BB8)) 
    \bram_addr[6]_i_3 
       (.I0(in32[6]),
        .I1(state[1]),
        .I2(\bram_addr[10]_i_18_n_0 ),
        .I3(in31[6]),
        .I4(h1_reg_0_63_0_2_i_11_n_0),
        .I5(\FSM_sequential_state[4]_i_5_n_0 ),
        .O(\bram_addr[6]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair51" *) 
  LUT4 #(
    .INIT(16'hA808)) 
    \bram_addr[6]_i_4 
       (.I0(state[1]),
        .I1(in31[6]),
        .I2(state[0]),
        .I3(in32[6]),
        .O(\bram_addr[6]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hF2F2F200F200F200)) 
    \bram_addr[6]_i_5 
       (.I0(state[0]),
        .I1(state[2]),
        .I2(state[3]),
        .I3(feat_save_idx[5]),
        .I4(feat_save_idx[4]),
        .I5(feat_save_idx[3]),
        .O(\bram_addr[6]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h08A8A808A808A808)) 
    \bram_addr[7]_i_2 
       (.I0(\out_id[2]_i_3_n_0 ),
        .I1(\bram_addr[7]_i_4_n_0 ),
        .I2(\bram_addr[10]_i_22_n_0 ),
        .I3(\bram_addr_reg_n_0_[7] ),
        .I4(\bram_addr_reg_n_0_[6] ),
        .I5(\bram_addr[7]_i_5_n_0 ),
        .O(\bram_addr[7]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hF000F000F077F088)) 
    \bram_addr[7]_i_3 
       (.I0(in31[6]),
        .I1(\bram_addr[10]_i_18_n_0 ),
        .I2(in32[7]),
        .I3(state[1]),
        .I4(in31[7]),
        .I5(\FSM_sequential_state[4]_i_5_n_0 ),
        .O(\bram_addr[7]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair50" *) 
  LUT4 #(
    .INIT(16'hA808)) 
    \bram_addr[7]_i_4 
       (.I0(state[1]),
        .I1(in31[7]),
        .I2(state[0]),
        .I3(in32[7]),
        .O(\bram_addr[7]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h8000000000000000)) 
    \bram_addr[7]_i_5 
       (.I0(\bram_addr_reg_n_0_[5] ),
        .I1(\bram_addr_reg_n_0_[3] ),
        .I2(\bram_addr_reg_n_0_[1] ),
        .I3(\bram_addr_reg_n_0_[0] ),
        .I4(\bram_addr_reg_n_0_[2] ),
        .I5(\bram_addr_reg_n_0_[4] ),
        .O(\bram_addr[7]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'h08F8F808)) 
    \bram_addr[8]_i_2 
       (.I0(\bram_addr[8]_i_4_n_0 ),
        .I1(state[2]),
        .I2(state[3]),
        .I3(\bram_addr_reg_n_0_[8] ),
        .I4(\bram_addr[8]_i_5_n_0 ),
        .O(\bram_addr[8]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hB8BBBBB8)) 
    \bram_addr[8]_i_3 
       (.I0(in32[8]),
        .I1(state[1]),
        .I2(\FSM_sequential_state[4]_i_5_n_0 ),
        .I3(in31[8]),
        .I4(\bram_addr[8]_i_6_n_0 ),
        .O(\bram_addr[8]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair54" *) 
  LUT4 #(
    .INIT(16'hE2FF)) 
    \bram_addr[8]_i_4 
       (.I0(in31[8]),
        .I1(state[0]),
        .I2(in32[8]),
        .I3(state[1]),
        .O(\bram_addr[8]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair61" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \bram_addr[8]_i_5 
       (.I0(\bram_addr_reg_n_0_[7] ),
        .I1(\bram_addr[7]_i_5_n_0 ),
        .I2(\bram_addr_reg_n_0_[6] ),
        .O(\bram_addr[8]_i_5_n_0 ));
  LUT3 #(
    .INIT(8'h80)) 
    \bram_addr[8]_i_6 
       (.I0(in31[7]),
        .I1(\bram_addr[10]_i_18_n_0 ),
        .I2(in31[6]),
        .O(\bram_addr[8]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hB8FFB800B800B800)) 
    \bram_addr[9]_i_1 
       (.I0(in32[9]),
        .I1(state[1]),
        .I2(\bram_addr[9]_i_2_n_0 ),
        .I3(state[4]),
        .I4(\out_id[2]_i_3_n_0 ),
        .I5(\bram_addr[9]_i_3_n_0 ),
        .O(\bram_addr[9]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h000000006AAAAAAA)) 
    \bram_addr[9]_i_2 
       (.I0(layer_last),
        .I1(in31[8]),
        .I2(in31[6]),
        .I3(\bram_addr[10]_i_18_n_0 ),
        .I4(in31[7]),
        .I5(\FSM_sequential_state[4]_i_5_n_0 ),
        .O(\bram_addr[9]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hB8BBB888BBBB88BB)) 
    \bram_addr[9]_i_3 
       (.I0(in33[9]),
        .I1(\bram_addr[10]_i_22_n_0 ),
        .I2(in32[9]),
        .I3(state[1]),
        .I4(layer_last),
        .I5(state[0]),
        .O(\bram_addr[9]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    \bram_addr[9]_i_4 
       (.I0(\bram_addr_reg_n_0_[7] ),
        .I1(\bram_addr[7]_i_5_n_0 ),
        .I2(\bram_addr_reg_n_0_[6] ),
        .I3(\bram_addr_reg_n_0_[8] ),
        .I4(\bram_addr_reg_n_0_[9] ),
        .O(in33[9]));
  (* equivalent_register_removal = "no" *) 
  FDRE \bram_addr_reg[0] 
       (.C(clk),
        .CE(bram_addr),
        .D(\bram_addr[0]_i_1_n_0 ),
        .Q(\bram_addr_reg_n_0_[0] ),
        .R(out_valid_i_1_n_0));
  (* equivalent_register_removal = "no" *) 
  FDRE \bram_addr_reg[10] 
       (.C(clk),
        .CE(bram_addr),
        .D(\bram_addr[10]_i_2_n_0 ),
        .Q(\bram_addr_reg_n_0_[10] ),
        .R(out_valid_i_1_n_0));
  MUXF7 \bram_addr_reg[10]_i_1 
       (.I0(\bram_addr[10]_i_4_n_0 ),
        .I1(\bram_addr[10]_i_5_n_0 ),
        .O(bram_addr),
        .S(state_reg[4]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \bram_addr_reg[10]_i_14 
       (.CI(\bram_addr_reg[2]_i_2_n_0 ),
        .CO({\bram_addr_reg[10]_i_14_n_0 ,\bram_addr_reg[10]_i_14_n_1 ,\bram_addr_reg[10]_i_14_n_2 ,\bram_addr_reg[10]_i_14_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(in32[8:5]),
        .S({\bram_addr[10]_i_24_n_0 ,\bram_addr[10]_i_25_n_0 ,\bram_addr[10]_i_26_n_0 ,\bram_addr[10]_i_27_n_0 }));
  CARRY4 \bram_addr_reg[10]_i_44 
       (.CI(\bram_addr_reg[10]_i_46_n_0 ),
        .CO({\NLW_bram_addr_reg[10]_i_44_CO_UNCONNECTED [3:1],w_base1[10]}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(\NLW_bram_addr_reg[10]_i_44_O_UNCONNECTED [3:0]),
        .S({1'b0,1'b0,1'b0,1'b1}));
  CARRY4 \bram_addr_reg[10]_i_46 
       (.CI(\bram_addr_reg[2]_i_10_n_0 ),
        .CO({\bram_addr_reg[10]_i_46_n_0 ,\bram_addr_reg[10]_i_46_n_1 ,\bram_addr_reg[10]_i_46_n_2 ,\bram_addr_reg[10]_i_46_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,p_0_in[10:9]}),
        .O(w_base1[9:6]),
        .S({p_0_in[10:9],\bram_addr[10]_i_48_n_0 ,\bram_addr[10]_i_49_n_0 }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \bram_addr_reg[10]_i_6 
       (.CI(\bram_addr_reg[10]_i_14_n_0 ),
        .CO({\NLW_bram_addr_reg[10]_i_6_CO_UNCONNECTED [3:1],\bram_addr_reg[10]_i_6_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\NLW_bram_addr_reg[10]_i_6_O_UNCONNECTED [3:2],in32[10:9]}),
        .S({1'b0,1'b0,\bram_addr[10]_i_15_n_0 ,\bram_addr[10]_i_16_n_0 }));
  (* equivalent_register_removal = "no" *) 
  FDRE \bram_addr_reg[1] 
       (.C(clk),
        .CE(bram_addr),
        .D(\bram_addr_reg[1]_i_1_n_0 ),
        .Q(\bram_addr_reg_n_0_[1] ),
        .R(out_valid_i_1_n_0));
  MUXF7 \bram_addr_reg[1]_i_1 
       (.I0(\bram_addr[1]_i_2_n_0 ),
        .I1(\bram_addr[1]_i_3_n_0 ),
        .O(\bram_addr_reg[1]_i_1_n_0 ),
        .S(state[4]));
  (* equivalent_register_removal = "no" *) 
  FDRE \bram_addr_reg[2] 
       (.C(clk),
        .CE(bram_addr),
        .D(\bram_addr[2]_i_1_n_0 ),
        .Q(\bram_addr_reg_n_0_[2] ),
        .R(out_valid_i_1_n_0));
  CARRY4 \bram_addr_reg[2]_i_10 
       (.CI(1'b0),
        .CO({\bram_addr_reg[2]_i_10_n_0 ,\bram_addr_reg[2]_i_10_n_1 ,\bram_addr_reg[2]_i_10_n_2 ,\bram_addr_reg[2]_i_10_n_3 }),
        .CYINIT(1'b0),
        .DI({p_0_in[8:6],1'b0}),
        .O(w_base1[5:2]),
        .S({\bram_addr[2]_i_12_n_0 ,\bram_addr[2]_i_13_n_0 ,\bram_addr[2]_i_14_n_0 ,p_0_in[5]}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \bram_addr_reg[2]_i_2 
       (.CI(1'b0),
        .CO({\bram_addr_reg[2]_i_2_n_0 ,\bram_addr_reg[2]_i_2_n_1 ,\bram_addr_reg[2]_i_2_n_2 ,\bram_addr_reg[2]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({\word_idx_reg_n_0_[4] ,mac_in__0[5:3]}),
        .O(in32[4:1]),
        .S({\bram_addr[2]_i_5_n_0 ,\bram_addr[2]_i_6_n_0 ,\bram_addr[2]_i_7_n_0 ,\bram_addr[2]_i_8_n_0 }));
  (* equivalent_register_removal = "no" *) 
  FDRE \bram_addr_reg[3] 
       (.C(clk),
        .CE(bram_addr),
        .D(\bram_addr_reg[3]_i_1_n_0 ),
        .Q(\bram_addr_reg_n_0_[3] ),
        .R(out_valid_i_1_n_0));
  MUXF7 \bram_addr_reg[3]_i_1 
       (.I0(\bram_addr[3]_i_2_n_0 ),
        .I1(\bram_addr[3]_i_3_n_0 ),
        .O(\bram_addr_reg[3]_i_1_n_0 ),
        .S(state[4]));
  (* equivalent_register_removal = "no" *) 
  FDRE \bram_addr_reg[4] 
       (.C(clk),
        .CE(bram_addr),
        .D(\bram_addr_reg[4]_i_1_n_0 ),
        .Q(\bram_addr_reg_n_0_[4] ),
        .R(out_valid_i_1_n_0));
  MUXF7 \bram_addr_reg[4]_i_1 
       (.I0(\bram_addr[4]_i_2_n_0 ),
        .I1(\bram_addr[4]_i_3_n_0 ),
        .O(\bram_addr_reg[4]_i_1_n_0 ),
        .S(state[4]));
  (* equivalent_register_removal = "no" *) 
  FDRE \bram_addr_reg[5] 
       (.C(clk),
        .CE(bram_addr),
        .D(\bram_addr_reg[5]_i_1_n_0 ),
        .Q(\bram_addr_reg_n_0_[5] ),
        .R(out_valid_i_1_n_0));
  MUXF7 \bram_addr_reg[5]_i_1 
       (.I0(\bram_addr[5]_i_2_n_0 ),
        .I1(\bram_addr[5]_i_3_n_0 ),
        .O(\bram_addr_reg[5]_i_1_n_0 ),
        .S(state[4]));
  MUXF7 \bram_addr_reg[5]_i_4 
       (.I0(\bram_addr[5]_i_8_n_0 ),
        .I1(in33[5]),
        .O(\bram_addr_reg[5]_i_4_n_0 ),
        .S(\bram_addr[10]_i_22_n_0 ));
  (* equivalent_register_removal = "no" *) 
  FDRE \bram_addr_reg[6] 
       (.C(clk),
        .CE(bram_addr),
        .D(\bram_addr_reg[6]_i_1_n_0 ),
        .Q(\bram_addr_reg_n_0_[6] ),
        .R(out_valid_i_1_n_0));
  MUXF7 \bram_addr_reg[6]_i_1 
       (.I0(\bram_addr[6]_i_2_n_0 ),
        .I1(\bram_addr[6]_i_3_n_0 ),
        .O(\bram_addr_reg[6]_i_1_n_0 ),
        .S(state[4]));
  (* equivalent_register_removal = "no" *) 
  FDRE \bram_addr_reg[7] 
       (.C(clk),
        .CE(bram_addr),
        .D(\bram_addr_reg[7]_i_1_n_0 ),
        .Q(\bram_addr_reg_n_0_[7] ),
        .R(out_valid_i_1_n_0));
  MUXF7 \bram_addr_reg[7]_i_1 
       (.I0(\bram_addr[7]_i_2_n_0 ),
        .I1(\bram_addr[7]_i_3_n_0 ),
        .O(\bram_addr_reg[7]_i_1_n_0 ),
        .S(state[4]));
  (* equivalent_register_removal = "no" *) 
  FDRE \bram_addr_reg[8] 
       (.C(clk),
        .CE(bram_addr),
        .D(\bram_addr_reg[8]_i_1_n_0 ),
        .Q(\bram_addr_reg_n_0_[8] ),
        .R(out_valid_i_1_n_0));
  MUXF7 \bram_addr_reg[8]_i_1 
       (.I0(\bram_addr[8]_i_2_n_0 ),
        .I1(\bram_addr[8]_i_3_n_0 ),
        .O(\bram_addr_reg[8]_i_1_n_0 ),
        .S(state[4]));
  (* equivalent_register_removal = "no" *) 
  FDRE \bram_addr_reg[9] 
       (.C(clk),
        .CE(bram_addr),
        .D(\bram_addr[9]_i_1_n_0 ),
        .Q(\bram_addr_reg_n_0_[9] ),
        .R(out_valid_i_1_n_0));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d16" *) 
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "65536" *) 
  (* RTL_RAM_NAME = "emg_nn_infer/bram_addr_reg_rep_0" *) 
  (* RTL_RAM_STYLE = "NONE" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "2047" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "0" *) 
  (* ram_slice_end = "15" *) 
  RAMB36E1 #(
    .DOA_REG(1),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h7208ABE5360302B38D8DD8D89AC3B5A80DD8A5E7237BC8A5552CCB62466A9025),
    .INIT_01(256'hD1740D79C925C11F0539BD3800A5ED801DDB8744A18C965E0B00D7E49B742E25),
    .INIT_02(256'h001A001A001C001A001C001A001A001B440D4C784EA4483548354EA44A53461D),
    .INIT_03(256'h0023002200270022002600220023002400170017001900160018001700170018),
    .INIT_04(256'h0011001100110011001100110011001100110010001100110010001100100011),
    .INIT_05(256'hD90DFFF698DF0C1AC805F422EE05FEF3E301F20D38ECD8D92D01DBD70A0CE9FD),
    .INIT_06(256'h1613E3E8FCFC14E900EFFBFE020BEADE22F3FFEB03E817002602FDF2F30CEAEA),
    .INIT_07(256'hFEF70F08F8E63031F8EE261EFAE6EB120810F003E6FAF3FE1428F5ED130300E8),
    .INIT_08(256'h13E0E1F8F4D717E2D6EDF500DC0D09F9F6052622070D29EC1B18E511F211F207),
    .INIT_09(256'h0A1AF7FE0915F60F13FBE0F00CF8D5F100040BF2DCFD12EB0FE500FF13D323F9),
    .INIT_0A(256'h0FFBE21DF416FCE01808FEE4FE081502FE0E10FDF6FA26FF0D1D09E7121807EE),
    .INIT_0B(256'hEAFB0203FC011D0FF1EC080C0FEF05D7FB27F83015FD110A03F0EF0502E7FA03),
    .INIT_0C(256'hFAE3E5F60CF413F408E7063005F5D9EE1CFA02FD0EF3EEF5130003D29C0AF22D),
    .INIT_0D(256'hC8FCEBDFE7040FF41F03EDFD08F113F7080DDEF41AFA0DF5EFEA11F7F7FC10F9),
    .INIT_0E(256'h0103FAF90110F1F0F5DF06C314ECF5FF0707DCE80FECF4FA18E6FBF62C2610C0),
    .INIT_0F(256'hBD2B0EF51126EEE9DB1EE413F30314FFF011F911DD0104080C2D05E9DE1C1706),
    .INIT_10(256'h1513F2E4040CF2E8150BF41F1D0F1B1CE60D282FEBF7191A09100CF9FEF90601),
    .INIT_11(256'h09F7FD1DD90DC000C50C1102F915D805F0F913F7010A11FF27F7EC08F922E4F5),
    .INIT_12(256'h282200C2FA05FE0C0B1308F5F418F80324011D140013E3381FE31A0F19F60DFF),
    .INIT_13(256'h2301050AFDE20008F51BF215151205F0111B1717E207F6F1EE07FC121A1A1113),
    .INIT_14(256'h260A0E2D06FCFC34EF18F4F00516020FDF101EEAC601E9EBE7180922CA10FC1D),
    .INIT_15(256'hF41609F90CE90CF9030BE90DE2E7E0B2F7EB05E70F060AFB010EF6F8F2EEEC0D),
    .INIT_16(256'h0EFDFC10F0DCD3EF1807EEDAFFF00AF01907F110FF1A180322E4E51C111B04CC),
    .INIT_17(256'h18F11C30DE1EFA0E0FF3141415F10706002C051302FCEAFF06FFFC030610FD08),
    .INIT_18(256'h14E814060AF7080AF70EEAF1EC1D1E21FD0322F311EE00FDF8DFEF00D71204F7),
    .INIT_19(256'h1DE81BE9EFE806DC09F913FF2BE2EA0B2D140606100D0804C50AF211E305FD0D),
    .INIT_1A(256'hF0E8EFF20713F3F4F51E0E1118CBFBC304DCE8FEF6E5F409F71BF303EF1105F6),
    .INIT_1B(256'hFBF4000F1D0725EE1215F3F8F002E2F5F1FA052BF000F310F1E51AE31AF31C19),
    .INIT_1C(256'h1E08D5FDE208E1ED02121A1CFFEB0B1C05F8EDFEF00C1EFC05E904D5F6041710),
    .INIT_1D(256'hF9FDE6FCDCF905E7E7E8DB1DDEF41AF803FC12EE02EB0F0AF2EDFA08F8DED2E5),
    .INIT_1E(256'hD9CEC0F3EBE010F415F4D2E3030919000C24141816E0FBE103EC02050EE5D5FE),
    .INIT_1F(256'hDD03F8EEF802E7E0021A021BD622F828F8052627E60106F0F90706FEFBEE0F07),
    .INIT_20(256'h01100314F31ED62320EEF538F6FE130C16F3FBF3E9F7F60CD6DE01F7B9E011FF),
    .INIT_21(256'h1BF32C0218DCDF1E0CF41411F8EEFDFE0E2B072813EAC90BEB1714170B1700F7),
    .INIT_22(256'hECEBEFEFFA1316E6D2FBF022120F1DFB0B001FFEEB0EF7F5E90CF50CF5E1FAFD),
    .INIT_23(256'h000625D3E4EBE3FA10EBEF0128FEF805EF08FC13EE19EB0BCF01081B09060A1D),
    .INIT_24(256'h0AF9EF19EC05F8FC190AFDFE1CE5E122CCEDE417E7FB0523F0FEF0F306000DF3),
    .INIT_25(256'h0BE2F8E9EDFFF3020CEB0DF2F3001BE8F3E8F1100E0BF0DB0A08FA1B120FF310),
    .INIT_26(256'hCC061412E40D00FFE1E9F90902FA0D07FEE5201C120AE8DBFBEB1B1FF903FFF6),
    .INIT_27(256'hED0010EFEDEF11EC1817C5E0EFFBF1130B18FD0811F1F8EF1A13F6FBDD12F1EF),
    .INIT_28(256'h06071AFF071824E50FF921E4F6F5E200FFFE14E3FCE40026080718EC0B02F60A),
    .INIT_29(256'hEAFF15C803070E1A0F10F80723032EDB0112F6E21814E8F3E8F101F30D0414EB),
    .INIT_2A(256'hFCE7FC2416FFC9D20606EFD4F904ECB50209011212FCF406F3E914DCFF18E2E0),
    .INIT_2B(256'hF61AE8DF091C09CA03F4F71AFAE2EBF5E71008C51304DDD9F61E16C3FE0D0EF1),
    .INIT_2C(256'hFD190AFBEFFEF6030DDC290709EE163907EC1FF0FC0104FC0706E80712E9EACB),
    .INIT_2D(256'h0AB1166D000608681C41E9EC0F18FA74FA143118097B10A305170A2211AF195B),
    .INIT_2E(256'hF70DF7C1F665EA52F2CA03CBF83AE965DB2917F9FA69F751FC8DF1E6ECF3F81D),
    .INIT_2F(256'h1DCE18DCED4BE47B13000760FE7FF05A20CA05B5EDBFF0551DBE12C1FF6AFE47),
    .INIT_30(256'h034B08681199131CFE71DA8E02FB24AD094B068113E9183219770E85099AE15E),
    .INIT_31(256'h2228EFDBDBDDFDFF0FEAE9D01D4904F7010125FCCCD4332A280FD81A0016051F),
    .INIT_32(256'h3711F70B03F4CFFA372710F2D831EA190AC82619F7EE340ED72A0BFE2F282836),
    .INIT_33(256'h062036252BF03633C90E302309262FD90F1AE4C5342E1EDF27010324093504FD),
    .INIT_34(256'hFDF842D328D24E0CA895EC1511FB1A0FF42E15B816DFF90400F91C23D9E71AD4),
    .INIT_35(256'h0B32CCF3F0110312364B2EF417F61F5740D60B1FD4E40FF5FF31F1E7E0FCE2A9),
    .INIT_36(256'h42130202E7EF1530EC0F27252805CF04C30B060E55FBE7FF0A16FD08190B111E),
    .INIT_37(256'hE912DA384317F80B221BC5051BFA36F534311D0B0C1DFAD439241222E2FB13FE),
    .INIT_38(256'h0CE5222405F10E39FE1C251EFEF4E9FBE11A05E616F5CCE5CFFF440FF7F11122),
    .INIT_39(256'h2117F1F3F8D51E0F011E18D7D038DEF3D3D60F0916C305FAEBFA0623E51AF5F1),
    .INIT_3A(256'hEAF2D735DB0C03F14ED80C1F100C1B0B07F318D801CBFD1BD40F2EEF0022F80C),
    .INIT_3B(256'hC0BFF8411F09FE18F6041E442F02F10E4201E2F306FFDFDEDD2207EA13ED1425),
    .INIT_3C(256'hC607062C0527E0EF0115E5662CE9031B0C10290AE811E2FFFD022505BFD90702),
    .INIT_3D(256'hF1FB17BA1C1928F4B5B6162F3139FECBCF25CFEC1107E5B812EE0F361FFDE812),
    .INIT_3E(256'h1610FA08BDD1F0C435F4E7FDD81FD7EA1CE43243E1DD2646E4AFD431F4EEFBCE),
    .INIT_3F(256'h1C1BEFE2F6E4F1214D2404C7E324E63AF0CD1719E0073101E623E30E53171BF2),
    .INIT_40(256'h0FF50302F71A2A1ECDF619363113EACBA312D1EC0E17FD04F4F9542520452231),
    .INIT_41(256'h0204E0FBF3FDD01C153A1CF1DFC8D425BC02FE2AF8F31EDACD2824BE0F1AFD0B),
    .INIT_42(256'hF61209251AFFF3F130FA00FB1CEB351F29C5FF27D0F011F9FA3CFF0C214513F2),
    .INIT_43(256'hF3041B113431E319EAED041723B5FD40252123D2003FE013E90F17F11D19FE16),
    .INIT_44(256'hEC04F40D092EAE00E6DF10231615FEF02CF41411ECBFF802F6E7341018C6D5DF),
    .INIT_45(256'h24E645220ADA4DFBA2CAF31E1537F0E8D644E0EE0B2405F91CD9142D3CD8FE07),
    .INIT_46(256'hEAE617F4061128F5E2C30B0BEC471413453025F706EF0C2E2917FD1FCED8ED0B),
    .INIT_47(256'hE400D4F0E32CE2EC0316D12B1FF71B1A1C00F20AF6FFF41AEAFB210B27FBF0F2),
    .INIT_48(256'h07200E00ECD609FA09DB2181FE111FFE11C9000FD9CA3BE91AC9B73932E9FF16),
    .INIT_49(256'hF733E6D514F5251E0CF91BE1E80927E7F1DF180AE80301D80BCFC31E361DF10C),
    .INIT_4A(256'h01E9F23A2B00263B1F37201F18E3FE10D42C1CE14B3BFDC0FC1FFBD9090DD4E8),
    .INIT_4B(256'hE4E8EC24F00BC31B2342191AE6CC0F1A0CE807F7F806FFEABD303EBD12E11EFA),
    .INIT_4C(256'h020D391BEBEF3BE90E07EB1F1403F7061C39BFB8341900FDD12114C501F8EAFD),
    .INIT_4D(256'hEDD2040FDEEDD6210E15EC391A00CDE6E8FB142E91FFF8431DE3BB2D25E9F4F2),
    .INIT_4E(256'h140A3B1625173324BFDC211C2427E6C1D83CE7D03A00AF023005103112361B30),
    .INIT_4F(256'hCFF9FC25ED40EFDA53E80D2704D2272B3EDA383C011A1E09F02924E7D5AAF5BC),
    .INIT_50(256'h28E7FB03F218D90218F6F927FAFACDC7CA1102330CEE3023EBF439283FDFE704),
    .INIT_51(256'h01D4060D0051033E00B30345FEB8FF6CFF1DFE0B016CFF6D022F0555161E0E1D),
    .INIT_52(256'h02CFFD55018DFE98FFF2032B00BA00B0039202F9FFEC03BB036CFD95012C0332),
    .INIT_53(256'h3EF203DBE1C60E1708433BCEA7C0EC5ECDF13C07361203C800197ECAFE89FE4C),
    .INIT_54(256'hAA45BAFF1EB8CEE0F8E010D6FCD72EE8C9FC1CB1BF16D3BEFB4FB0BC06F7EC20),
    .INIT_55(256'h01A0FF1FFF8DFF7EF1C9EC6717E63AC8EF2ABA35F40716334AAD1106093FC2C2),
    .INIT_56(256'h0000000000000000000000000000000000000000000000000000000000000106),
    .INIT_57(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_58(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_59(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_60(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_61(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_62(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_63(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_64(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_65(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_66(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_67(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_68(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_69(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_70(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_71(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_72(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_73(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_74(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_75(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_76(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_77(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_78(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_79(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(18),
    .READ_WIDTH_B(0),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(18),
    .WRITE_WIDTH_B(0)) 
    bram_addr_reg_rep_0
       (.ADDRARDADDR({1'b1,bram_addr_reg_rep_0_i_2_n_0,bram_addr_reg_rep_0_i_3_n_0,bram_addr_reg_rep_0_i_4_n_0,bram_addr_reg_rep_0_i_5_n_0,bram_addr_reg_rep_0_i_6_n_0,bram_addr_reg_rep_0_i_7_n_0,bram_addr_reg_rep_0_i_8_n_0,bram_addr_reg_rep_0_i_9_n_0,bram_addr_reg_rep_0_i_10_n_0,bram_addr_reg_rep_0_i_11_n_0,bram_addr_reg_rep_0_i_12_n_0,1'b0,1'b0,1'b0,1'b0}),
        .ADDRBWRADDR({1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(NLW_bram_addr_reg_rep_0_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_addr_reg_rep_0_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(1'b0),
        .DBITERR(NLW_bram_addr_reg_rep_0_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .DIBDI({1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b1,1'b1,1'b1,1'b1}),
        .DOADO({NLW_bram_addr_reg_rep_0_DOADO_UNCONNECTED[31:16],bram_addr_reg_rep_0_n_20,bram_addr_reg_rep_0_n_21,bram_addr_reg_rep_0_n_22,bram_addr_reg_rep_0_n_23,bram_addr_reg_rep_0_n_24,bram_addr_reg_rep_0_n_25,bram_addr_reg_rep_0_n_26,bram_addr_reg_rep_0_n_27,bram_addr_reg_rep_0_n_28,bram_addr_reg_rep_0_n_29,bram_addr_reg_rep_0_n_30,bram_addr_reg_rep_0_n_31,bram_addr_reg_rep_0_n_32,bram_addr_reg_rep_0_n_33,bram_addr_reg_rep_0_n_34,bram_addr_reg_rep_0_n_35}),
        .DOBDO(NLW_bram_addr_reg_rep_0_DOBDO_UNCONNECTED[31:0]),
        .DOPADOP(NLW_bram_addr_reg_rep_0_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_addr_reg_rep_0_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_addr_reg_rep_0_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_addr_reg_rep_0_i_1_n_0),
        .ENBWREN(1'b0),
        .INJECTDBITERR(NLW_bram_addr_reg_rep_0_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_addr_reg_rep_0_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_addr_reg_rep_0_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b1),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_addr_reg_rep_0_SBITERR_UNCONNECTED),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  LUT2 #(
    .INIT(4'hB)) 
    bram_addr_reg_rep_0_i_1
       (.I0(bram_addr),
        .I1(rst_n),
        .O(bram_addr_reg_rep_0_i_1_n_0));
  LUT6 #(
    .INIT(64'hEEE222E200000000)) 
    bram_addr_reg_rep_0_i_10
       (.I0(\bram_addr[2]_i_4_n_0 ),
        .I1(state[4]),
        .I2(\bram_addr[2]_i_3_n_0 ),
        .I3(state[1]),
        .I4(in32[2]),
        .I5(rst_n),
        .O(bram_addr_reg_rep_0_i_10_n_0));
  LUT6 #(
    .INIT(64'hEEE222E200000000)) 
    bram_addr_reg_rep_0_i_11
       (.I0(\bram_addr[1]_i_2_n_0 ),
        .I1(state[4]),
        .I2(bram_addr_reg_rep_0_i_15_n_0),
        .I3(state[1]),
        .I4(in32[1]),
        .I5(rst_n),
        .O(bram_addr_reg_rep_0_i_11_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    bram_addr_reg_rep_0_i_12
       (.I0(\bram_addr[0]_i_1_n_0 ),
        .I1(rst_n),
        .O(bram_addr_reg_rep_0_i_12_n_0));
  LUT6 #(
    .INIT(64'hBBB888B8BBBBBBBB)) 
    bram_addr_reg_rep_0_i_13
       (.I0(in33[8]),
        .I1(\bram_addr[10]_i_22_n_0 ),
        .I2(in31[8]),
        .I3(state[0]),
        .I4(in32[8]),
        .I5(state[1]),
        .O(bram_addr_reg_rep_0_i_13_n_0));
  LUT6 #(
    .INIT(64'hB8B8B8888888B888)) 
    bram_addr_reg_rep_0_i_14
       (.I0(in33[7]),
        .I1(\bram_addr[10]_i_22_n_0 ),
        .I2(state[1]),
        .I3(in31[7]),
        .I4(state[0]),
        .I5(in32[7]),
        .O(bram_addr_reg_rep_0_i_14_n_0));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT5 #(
    .INIT(32'h141441BE)) 
    bram_addr_reg_rep_0_i_15
       (.I0(\FSM_sequential_state[4]_i_5_n_0 ),
        .I1(p_0_in[4]),
        .I2(p_0_in[5]),
        .I3(\layer_reg_n_0_[0] ),
        .I4(\layer_reg_n_0_[1] ),
        .O(bram_addr_reg_rep_0_i_15_n_0));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    bram_addr_reg_rep_0_i_16
       (.I0(\bram_addr_reg_n_0_[6] ),
        .I1(\bram_addr[7]_i_5_n_0 ),
        .I2(\bram_addr_reg_n_0_[7] ),
        .I3(\bram_addr_reg_n_0_[8] ),
        .O(in33[8]));
  (* SOFT_HLUTNM = "soft_lutpair61" *) 
  LUT3 #(
    .INIT(8'h78)) 
    bram_addr_reg_rep_0_i_17
       (.I0(\bram_addr[7]_i_5_n_0 ),
        .I1(\bram_addr_reg_n_0_[6] ),
        .I2(\bram_addr_reg_n_0_[7] ),
        .O(in33[7]));
  LUT2 #(
    .INIT(4'h8)) 
    bram_addr_reg_rep_0_i_2
       (.I0(\bram_addr[10]_i_2_n_0 ),
        .I1(rst_n),
        .O(bram_addr_reg_rep_0_i_2_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    bram_addr_reg_rep_0_i_3
       (.I0(\bram_addr[9]_i_1_n_0 ),
        .I1(rst_n),
        .O(bram_addr_reg_rep_0_i_3_n_0));
  LUT6 #(
    .INIT(64'hFFA800A800000000)) 
    bram_addr_reg_rep_0_i_4
       (.I0(bram_addr_reg_rep_0_i_13_n_0),
        .I1(state[2]),
        .I2(state[3]),
        .I3(state[4]),
        .I4(\bram_addr[8]_i_3_n_0 ),
        .I5(rst_n),
        .O(bram_addr_reg_rep_0_i_4_n_0));
  LUT6 #(
    .INIT(64'hFFA800A800000000)) 
    bram_addr_reg_rep_0_i_5
       (.I0(bram_addr_reg_rep_0_i_14_n_0),
        .I1(state[2]),
        .I2(state[3]),
        .I3(state[4]),
        .I4(\bram_addr[7]_i_3_n_0 ),
        .I5(rst_n),
        .O(bram_addr_reg_rep_0_i_5_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    bram_addr_reg_rep_0_i_6
       (.I0(\bram_addr_reg[6]_i_1_n_0 ),
        .I1(rst_n),
        .O(bram_addr_reg_rep_0_i_6_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    bram_addr_reg_rep_0_i_7
       (.I0(\bram_addr_reg[5]_i_1_n_0 ),
        .I1(rst_n),
        .O(bram_addr_reg_rep_0_i_7_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    bram_addr_reg_rep_0_i_8
       (.I0(\bram_addr_reg[4]_i_1_n_0 ),
        .I1(rst_n),
        .O(bram_addr_reg_rep_0_i_8_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    bram_addr_reg_rep_0_i_9
       (.I0(\bram_addr_reg[3]_i_1_n_0 ),
        .I1(rst_n),
        .O(bram_addr_reg_rep_0_i_9_n_0));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d16" *) 
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "65536" *) 
  (* RTL_RAM_NAME = "emg_nn_infer/bram_addr_reg_rep_1" *) 
  (* RTL_RAM_STYLE = "NONE" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "2047" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "16" *) 
  (* ram_slice_end = "31" *) 
  RAMB36E1 #(
    .DOA_REG(1),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h0001000100010001000100010001000100010001000100010001000100010001),
    .INIT_01(256'h0001000100010001000100010001000100010001000100010001000100010001),
    .INIT_02(256'h0000000000000000000000000000000000010001000100010001000100010001),
    .INIT_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_05(256'h0F2AD1ECF100E6F3F926D507E6FDE108E1FEDC0EEFFED11F1916ED191EE7EA12),
    .INIT_06(256'h1ACB2CEFEDF7DF0F0209E31310DF131526181C02350127FC01FFEE10FD01EFEB),
    .INIT_07(256'h17F0FAF3F4FD1301E50604DE0F1CEFE7ECEF090F011BF60BEFF1351228DF08FF),
    .INIT_08(256'hFCD02AE5F9E326E60FF515FBFEE81CFDEDEA34EE1808E7FC040A04F3F6FCF0FC),
    .INIT_09(256'hF8F3F805050BFA0735C9E0EB242A38FA11E62DF5FEFDEE0A14DDEBEC1ADBC9EE),
    .INIT_0A(256'hB6F6D4E4EF2919EDD4112A0AF6FBE806F7F6E703F5F12404F3D20A24EEFE061A),
    .INIT_0B(256'hED12EDFD03E50014F805DF17F0CCCE160D36E7FC15FC1A0211FA0DE8FBE5040A),
    .INIT_0C(256'h0E0B081FF9091C0900F3B00CD61FF8F5F2EEF8EEF2D4040E14F727F4E2EE0CFF),
    .INIT_0D(256'hE6C801ED1A000DF6EA0E09FDEAF30CF428E8FEEE3C04EBF818EA0405FB0812ED),
    .INIT_0E(256'h0800F600F50AF9F307BEB7EC0F1FFF1C1BD9E1000B0E0B07F8EEFA001BFBE40E),
    .INIT_0F(256'h09FDD3D0F710ECF7DA21E2F614FCFCF40D17F7FAE8F3E5E7F1F111EB072A15E3),
    .INIT_10(256'hF6150318FFF10513F90F011FD11CD2DDF40A1500DB0909E71304F61912F11B05),
    .INIT_11(256'h00F3E2F4F4F8BD0A010AF11DE706381103EE1BF00F060EEEFF0605F2FAD1CC1E),
    .INIT_12(256'h16A3F207F40A190FF1EDF70ADE14F819F819EAF2F130D8FDE51C14040B0202E6),
    .INIT_13(256'hFF110C16FB290220E502070CE9F1D40306FF37F80AF6EEF6F6EDFE0A18DB071B),
    .INIT_14(256'h1C1F0A0AF827F3FAEE0CC20F02010918F9050003121DAAD5F6F727EC0029C9FC),
    .INIT_15(256'hEE0212EA05EFF80A0FE9FE02CFD4FFFB13550CFEF9E7F30508FDFC200AF3FC0A),
    .INIT_16(256'hF314F008B3F0D90102FB2E2DFBF40918F7030CF30CF51301B9DFE3F9F02210F2),
    .INIT_17(256'hE821080DCAF7FC0A0CF2F9FA1705FB01E4D22B1D19E1CF1010F711F7100A0BF8),
    .INIT_18(256'h061F0600F608F6FD220C0BF0E9D4C1DB020508EE0E14FD090B020BFCEED9D6FB),
    .INIT_19(256'h1012F3DD10CE11F213F32801FBF5EC15F4030512CA0BF8F204E9D91102E62006),
    .INIT_1A(256'h2D14C503E30DF4EFF10DED01CDEFD5F80B00E5151CE1E009000D0A0FF10F0B0D),
    .INIT_1B(256'h1118F312F32E14E1F404F5DFFE3201F7DEEFFD01D8DEECE929FFE0F1DDEBF9F4),
    .INIT_1C(256'hE91B071F0CDF3AF1EAF50F070ECFF6072BE3BEF0F91AF3043919E8F80D0307F4),
    .INIT_1D(256'h08DFFAF6F2EDF4E003E3251E18170500E2FC041907F40C07F900F007C1EC19FB),
    .INIT_1E(256'hDAE4F4312421F225F9DEB0F9091C02000708F105212C11EFE4E9D4F413E709FA),
    .INIT_1F(256'h2417E61002ECEA160B020A0ACBF611D8DBF9100AE629F2F2FBFB13F3F2020D0F),
    .INIT_20(256'h1413F0E9E402E4F71310140EF21C1BFCFBF20DE010FE16D8FBFEE91A24F1D6FB),
    .INIT_21(256'hECE5AADB082AEEE4031A1615E5E00EE1E132D5051B30F704EE0D0DFC160404F1),
    .INIT_22(256'h01F2F5EE1710EC04E10FDA09D0F61FE8F5F0EBFAFC0FF4FEF00AFCF8E94333FD),
    .INIT_23(256'h0CFA1613371EEBF723F0E8F61BF80F0E03EE01FC0AEEE20CFA1EC21FFF10111C),
    .INIT_24(256'hE4F51C0BF0F50A07FEFC1313EA3022F919DCEED71D072002F0FF000C000D1A0E),
    .INIT_25(256'hF00CEFE8EAD70FDFEF1314F11611FDF405000BF7E003E904EB194008E4FED5F2),
    .INIT_26(256'hEBDDE5F4EB2319FB18E80AEE180F10E4EFED09F5DA07EEFBC909DDF6FD13F6F8),
    .INIT_27(256'hE9F3FA020A0AF510C6E581F71956EFFBF607C00B0F08F1FB11FF0003ED1D0505),
    .INIT_28(256'h18080E0401E10AFA26F90905EBF60FE408E7FE04FE013AFCC7EF16FCDFF2F90F),
    .INIT_29(256'h0A010A061005120103F608050208F7F10D2A3CFBF91230030D00E3060D010720),
    .INIT_2A(256'h08E608ED2533CC14D01DFDEF0C0A09101C04F70AFBF9F5FA3A0139FAD9C645F6),
    .INIT_2B(256'hDDEF001805FD2604FB021402D2FE02062EDF0FF7D9F2FE001FF3260007E8F7F3),
    .INIT_2C(256'h07F7FDE10EEC0F01D8FBF3FB1CF1C8F60C04C51108FEF8F409FFFA04D4D72403),
    .INIT_2D(256'h00000000000000000000FFFF0000FFFFFFFF0000000000000000000000000000),
    .INIT_2E(256'hFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFF),
    .INIT_2F(256'h00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF),
    .INIT_30(256'h0000000000000000FFFFFFFF000000000000000000000000000000000000FFFF),
    .INIT_31(256'h0AD91DCE2DC2DA180C30FC0AE71B314EE620E0E63EDFE030FF09220100000001),
    .INIT_32(256'hDF1F031AF7F5122FB5F815EF1E0C041DFAC81900F61BEA0902FCED0ADA303220),
    .INIT_33(256'h22FFEF02F8F51EC9FD14041EDB1BF11ECFE6030D3305E7F51EF81818D2342D35),
    .INIT_34(256'h16EB1224F70BE4B9F818D20C0BEC183CAF1325E616E7D3D6201F4D2C1BDBDD13),
    .INIT_35(256'h2AFEF3F53F0B3751D2DC56E82DF61C1C10EBE23704110237F0EEDEF01BE2DD02),
    .INIT_36(256'h9314DB32032314F512EA47FC0AD408D703090607D63321B62559172024DE24F7),
    .INIT_37(256'h68103F09F8E4DA07F20710DE1751C064E5D3C00334DAFB080F0FD3DFEEDA121C),
    .INIT_38(256'hD939F531184C521212D22B1B32CEECC310FC042CD51BF4D0C50C22F2F901E2E5),
    .INIT_39(256'hF3F3040F2CE4BE04EF16342807F73014B104AEFBF70511161B20C32908DAF617),
    .INIT_3A(256'h1319CC13FBF220270AD44127E4E0FA05E40B141404EB30F6CFF809D2C4ED26FA),
    .INIT_3B(256'h302FF126E63D200DEDD7154E3513FDDFE8DB012023E62E311EDBD3FEFFF010F0),
    .INIT_3C(256'hCB151336DB2813191FFD0D0D54FAFACF461A3AFCE52649FCFBF726F95508DEE8),
    .INIT_3D(256'h11DFB3FFE5DF1A9A221ABB24F8F9243CF7F9C5EE44F9C7E92B26371B39FFEDE2),
    .INIT_3E(256'hAF050FF7ECEEF6F4FA26F9DA38FF2BE50F1809E2F9222D1B08D40A0A110712FA),
    .INIT_3F(256'hF308F61000F90112F9F816F00502153100F9EE2514EED3350831B507D5142D2A),
    .INIT_40(256'hC228E40B030D3DB60F12F51510F707F22BF847EFDD292FA8E52F42EFDDE60128),
    .INIT_41(256'hA438F50536572F24D8BF2DE328BD08CB150D11F5B92C45F8E61DD3E7F0232013),
    .INIT_42(256'h19E716E916040E43DAF721EB1101370E04D6CAF91BF2FD3307F4E1001BE80111),
    .INIT_43(256'h12E21809FC141C141D0F0E2F4133E81212CDE6252DF5FE3AE8CCF4FA1D15ECFF),
    .INIT_44(256'h0B2014ECE205CD1211EBE6C811150FBFFE1517DF042AFFF609CCF80966D1BEDC),
    .INIT_45(256'h4510FFF1EC07FC822717BC36F6F6143EDE3203E7350E10E215FC2629F731E90A),
    .INIT_46(256'h63E010D20AE2B0DD3D3DC800DE56152AE1180FE924D9051639DB082F0B34E9F1),
    .INIT_47(256'h0E1A0317D2D61817FC0B0FBC34200DF530F22E081A313F21CD0B12DC1A2E1109),
    .INIT_48(256'h1FD2E7B0EBBCE124150A051CE326294CE2ACCEF326069D57491AE2151821FCD0),
    .INIT_49(256'h2DCAF9B5FEAEEA0E0E381A1FDE170C51C7C0E5D537FCBF2B2DF4D131C7F5F923),
    .INIT_4A(256'h19340A32144F1DFCF2D82325EEF7FCD438EC3523CD12EAFED43CE8EBCCFC0615),
    .INIT_4B(256'hDC30011E1333442B16C73EF7260C15CC41E0F73DF31A09F7FCFFF5ED00E320ED),
    .INIT_4C(256'h2703EEE5E1EE2F2225093422E0130019ECEFE405FCE31D1AE9DAECDBFCE515DC),
    .INIT_4D(256'h0AF42C2014DDD1FA081124BB1ADA18C74D0F440106E5ECD8F2DC02F44905E9EE),
    .INIT_4E(256'hECDDCC1EEF0DEBC9F7FECA18F9D1030DE71707071A0708CB1E322C0F100A3801),
    .INIT_4F(256'hFD0125181938E44AE91C33E321EEF7FBF40A012AEEEA1236E4F412EDEBF6E805),
    .INIT_50(256'h9921150E1036F0DB201CFAD527E000E114454710060327C4FA1B58DF080907ED),
    .INIT_51(256'h000000000000000000000000FFFFFFFFFFFFFFFF0000FFFF00000000FB3A1BE3),
    .INIT_52(256'h0000FFFF0000FFFFFFFF00000000000000000000FFFF00000000FFFF00000000),
    .INIT_53(256'h21D228C707EC19BE10001B2FBBF420DA150A0A0B3AC681FA00000001FFFFFFFF),
    .INIT_54(256'h2EC5010929185E40CE3723290E281B4EC7D929472233F6074518CCF1BF3030DD),
    .INIT_55(256'h0000FFFFFFFFFFFFD5F7CCB479BFD8B0C933B8DCE429FD17FEAB0FD6B6DAD7ED),
    .INIT_56(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_57(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_58(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_59(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_60(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_61(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_62(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_63(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_64(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_65(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_66(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_67(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_68(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_69(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_70(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_71(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_72(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_73(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_74(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_75(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_76(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_77(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_78(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_79(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(18),
    .READ_WIDTH_B(0),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(18),
    .WRITE_WIDTH_B(0)) 
    bram_addr_reg_rep_1
       (.ADDRARDADDR({1'b1,bram_addr_reg_rep_0_i_2_n_0,bram_addr_reg_rep_0_i_3_n_0,bram_addr_reg_rep_0_i_4_n_0,bram_addr_reg_rep_0_i_5_n_0,bram_addr_reg_rep_0_i_6_n_0,bram_addr_reg_rep_0_i_7_n_0,bram_addr_reg_rep_0_i_8_n_0,bram_addr_reg_rep_0_i_9_n_0,bram_addr_reg_rep_0_i_10_n_0,bram_addr_reg_rep_0_i_11_n_0,bram_addr_reg_rep_0_i_12_n_0,1'b0,1'b0,1'b0,1'b0}),
        .ADDRBWRADDR({1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(NLW_bram_addr_reg_rep_1_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_addr_reg_rep_1_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(1'b0),
        .DBITERR(NLW_bram_addr_reg_rep_1_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .DIBDI({1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b1,1'b1,1'b1,1'b1}),
        .DOADO({NLW_bram_addr_reg_rep_1_DOADO_UNCONNECTED[31:16],bram_addr_reg_rep_1_n_20,bram_addr_reg_rep_1_n_21,bram_addr_reg_rep_1_n_22,bram_addr_reg_rep_1_n_23,bram_addr_reg_rep_1_n_24,bram_addr_reg_rep_1_n_25,bram_addr_reg_rep_1_n_26,bram_addr_reg_rep_1_n_27,bram_addr_reg_rep_1_n_28,bram_addr_reg_rep_1_n_29,bram_addr_reg_rep_1_n_30,bram_addr_reg_rep_1_n_31,bram_addr_reg_rep_1_n_32,bram_addr_reg_rep_1_n_33,bram_addr_reg_rep_1_n_34,bram_addr_reg_rep_1_n_35}),
        .DOBDO(NLW_bram_addr_reg_rep_1_DOBDO_UNCONNECTED[31:0]),
        .DOPADOP(NLW_bram_addr_reg_rep_1_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_addr_reg_rep_1_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_addr_reg_rep_1_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_addr_reg_rep_0_i_1_n_0),
        .ENBWREN(1'b0),
        .INJECTDBITERR(NLW_bram_addr_reg_rep_1_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_addr_reg_rep_1_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_addr_reg_rep_1_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b1),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_addr_reg_rep_1_SBITERR_UNCONNECTED),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* SOFT_HLUTNM = "soft_lutpair117" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \feat_cnt[0]_i_1 
       (.I0(\feat_cnt_reg_n_0_[0] ),
        .O(\feat_cnt[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair117" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \feat_cnt[1]_i_1 
       (.I0(\feat_cnt_reg_n_0_[0] ),
        .I1(\feat_cnt_reg_n_0_[1] ),
        .O(feat_cnt[1]));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT3 #(
    .INIT(8'h6A)) 
    \feat_cnt[2]_i_1 
       (.I0(\feat_cnt_reg_n_0_[2] ),
        .I1(\feat_cnt_reg_n_0_[0] ),
        .I2(\feat_cnt_reg_n_0_[1] ),
        .O(feat_cnt[2]));
  LUT6 #(
    .INIT(64'h7870F0F07878F0F0)) 
    \feat_cnt[3]_i_1 
       (.I0(\feat_cnt_reg_n_0_[2] ),
        .I1(\feat_cnt_reg_n_0_[0] ),
        .I2(\feat_cnt_reg_n_0_[3] ),
        .I3(\feat_cnt_reg_n_0_[4] ),
        .I4(\feat_cnt_reg_n_0_[1] ),
        .I5(\feat_cnt_reg_n_0_[5] ),
        .O(feat_cnt[3]));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT5 #(
    .INIT(32'h7F80FF00)) 
    \feat_cnt[4]_i_1 
       (.I0(\feat_cnt_reg_n_0_[2] ),
        .I1(\feat_cnt_reg_n_0_[0] ),
        .I2(\feat_cnt_reg_n_0_[3] ),
        .I3(\feat_cnt_reg_n_0_[4] ),
        .I4(\feat_cnt_reg_n_0_[1] ),
        .O(feat_cnt[4]));
  LUT5 #(
    .INIT(32'h00000002)) 
    \feat_cnt[5]_i_1 
       (.I0(state[2]),
        .I1(state[0]),
        .I2(state[1]),
        .I3(state[3]),
        .I4(state[4]),
        .O(\feat_cnt[5]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h7FF7FFFF80000000)) 
    \feat_cnt[5]_i_2 
       (.I0(\feat_cnt_reg_n_0_[2] ),
        .I1(\feat_cnt_reg_n_0_[0] ),
        .I2(\feat_cnt_reg_n_0_[3] ),
        .I3(\feat_cnt_reg_n_0_[4] ),
        .I4(\feat_cnt_reg_n_0_[1] ),
        .I5(\feat_cnt_reg_n_0_[5] ),
        .O(feat_cnt[5]));
  FDRE \feat_cnt_reg[0] 
       (.C(clk),
        .CE(\feat_cnt[5]_i_1_n_0 ),
        .D(\feat_cnt[0]_i_1_n_0 ),
        .Q(\feat_cnt_reg_n_0_[0] ),
        .R(out_valid_i_1_n_0));
  FDRE \feat_cnt_reg[1] 
       (.C(clk),
        .CE(\feat_cnt[5]_i_1_n_0 ),
        .D(feat_cnt[1]),
        .Q(\feat_cnt_reg_n_0_[1] ),
        .R(out_valid_i_1_n_0));
  FDRE \feat_cnt_reg[2] 
       (.C(clk),
        .CE(\feat_cnt[5]_i_1_n_0 ),
        .D(feat_cnt[2]),
        .Q(\feat_cnt_reg_n_0_[2] ),
        .R(out_valid_i_1_n_0));
  FDRE \feat_cnt_reg[3] 
       (.C(clk),
        .CE(\feat_cnt[5]_i_1_n_0 ),
        .D(feat_cnt[3]),
        .Q(\feat_cnt_reg_n_0_[3] ),
        .R(out_valid_i_1_n_0));
  FDRE \feat_cnt_reg[4] 
       (.C(clk),
        .CE(\feat_cnt[5]_i_1_n_0 ),
        .D(feat_cnt[4]),
        .Q(\feat_cnt_reg_n_0_[4] ),
        .R(out_valid_i_1_n_0));
  FDRE \feat_cnt_reg[5] 
       (.C(clk),
        .CE(\feat_cnt[5]_i_1_n_0 ),
        .D(feat_cnt[5]),
        .Q(\feat_cnt_reg_n_0_[5] ),
        .R(out_valid_i_1_n_0));
  LUT5 #(
    .INIT(32'h00000001)) 
    feat_ready_INST_0
       (.I0(state[3]),
        .I1(state[1]),
        .I2(state[0]),
        .I3(state[4]),
        .I4(state[2]),
        .O(feat_ready));
  LUT6 #(
    .INIT(64'h0000000000000100)) 
    \feat_save_idx[5]_i_1 
       (.I0(state[0]),
        .I1(state[4]),
        .I2(state[1]),
        .I3(feat_valid),
        .I4(state[3]),
        .I5(state[2]),
        .O(feat_save_idx__0));
  FDRE \feat_save_idx_reg[0] 
       (.C(clk),
        .CE(feat_save_idx__0),
        .D(feat_index[0]),
        .Q(feat_save_idx[0]),
        .R(out_valid_i_1_n_0));
  FDRE \feat_save_idx_reg[1] 
       (.C(clk),
        .CE(feat_save_idx__0),
        .D(feat_index[1]),
        .Q(feat_save_idx[1]),
        .R(out_valid_i_1_n_0));
  FDRE \feat_save_idx_reg[2] 
       (.C(clk),
        .CE(feat_save_idx__0),
        .D(feat_index[2]),
        .Q(feat_save_idx[2]),
        .R(out_valid_i_1_n_0));
  FDRE \feat_save_idx_reg[3] 
       (.C(clk),
        .CE(feat_save_idx__0),
        .D(feat_index[3]),
        .Q(feat_save_idx[3]),
        .R(out_valid_i_1_n_0));
  FDRE \feat_save_idx_reg[4] 
       (.C(clk),
        .CE(feat_save_idx__0),
        .D(feat_index[4]),
        .Q(feat_save_idx[4]),
        .R(out_valid_i_1_n_0));
  FDRE \feat_save_idx_reg[5] 
       (.C(clk),
        .CE(feat_save_idx__0),
        .D(feat_index[5]),
        .Q(feat_save_idx[5]),
        .R(out_valid_i_1_n_0));
  LUT5 #(
    .INIT(32'h00001F00)) 
    g0_b0
       (.I0(state[0]),
        .I1(state[1]),
        .I2(state[2]),
        .I3(state[3]),
        .I4(state[4]),
        .O(g0_b0_n_0));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "512" *) 
  (* RTL_RAM_NAME = "emg_nn_infer/h1_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "63" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "0" *) 
  (* ram_slice_end = "2" *) 
  RAM64M h1_reg_0_63_0_2
       (.ADDRA({mac_in__0,mac_in}),
        .ADDRB({mac_in__0,mac_in}),
        .ADDRC({mac_in__0,mac_in}),
        .ADDRD(p_0_in[9:4]),
        .DIA(hidden_activation[0]),
        .DIB(hidden_activation[1]),
        .DIC(hidden_activation[2]),
        .DID(1'b0),
        .DOA(act0[0]),
        .DOB(act0[1]),
        .DOC(act0[2]),
        .DOD(NLW_h1_reg_0_63_0_2_DOD_UNCONNECTED),
        .WCLK(clk),
        .WE(h1_reg_0_63_0_2_i_4_n_0));
  LUT5 #(
    .INIT(32'h0000FFF8)) 
    h1_reg_0_63_0_2_i_1
       (.I0(\rq_n_reg_n_0_[0] ),
        .I1(h1_reg_0_63_0_2_i_5_n_0),
        .I2(h1_reg_0_63_0_2_i_6_n_3),
        .I3(h1_reg_0_63_0_2_i_7_n_0),
        .I4(h1_reg_0_63_0_2_i_8_n_4),
        .O(hidden_activation[0]));
  (* SOFT_HLUTNM = "soft_lutpair83" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    h1_reg_0_63_0_2_i_10
       (.I0(h1_reg_0_63_0_2_i_31_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_13_n_0),
        .O(h1_reg_0_63_0_2_i_10_n_0));
  LUT6 #(
    .INIT(64'h0800000000000000)) 
    h1_reg_0_63_0_2_i_100
       (.I0(\rq_n_reg_n_0_[5] ),
        .I1(\rq_n_reg_n_0_[4] ),
        .I2(\rq_n_reg_n_0_[3] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(\rq_n_reg_n_0_[0] ),
        .I5(\rq_n_reg_n_0_[2] ),
        .O(rq_half[54]));
  LUT6 #(
    .INIT(64'h0008000000000000)) 
    h1_reg_0_63_0_2_i_101
       (.I0(\rq_n_reg_n_0_[5] ),
        .I1(\rq_n_reg_n_0_[4] ),
        .I2(\rq_n_reg_n_0_[3] ),
        .I3(\rq_n_reg_n_0_[0] ),
        .I4(\rq_n_reg_n_0_[2] ),
        .I5(\rq_n_reg_n_0_[1] ),
        .O(rq_half[53]));
  LUT6 #(
    .INIT(64'h0008000000000000)) 
    h1_reg_0_63_0_2_i_102
       (.I0(\rq_n_reg_n_0_[5] ),
        .I1(\rq_n_reg_n_0_[4] ),
        .I2(\rq_n_reg_n_0_[3] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(\rq_n_reg_n_0_[0] ),
        .I5(\rq_n_reg_n_0_[2] ),
        .O(rq_half[52]));
  LUT6 #(
    .INIT(64'h0000000800000000)) 
    h1_reg_0_63_0_2_i_103
       (.I0(\rq_n_reg_n_0_[5] ),
        .I1(\rq_n_reg_n_0_[4] ),
        .I2(\rq_n_reg_n_0_[3] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(\rq_n_reg_n_0_[0] ),
        .I5(\rq_n_reg_n_0_[2] ),
        .O(rq_half[51]));
  LUT6 #(
    .INIT(64'hFE7FFFFFFFFFFFFF)) 
    h1_reg_0_63_0_2_i_104
       (.I0(\rq_n_reg_n_0_[2] ),
        .I1(\rq_n_reg_n_0_[0] ),
        .I2(\rq_n_reg_n_0_[1] ),
        .I3(\rq_n_reg_n_0_[3] ),
        .I4(\rq_n_reg_n_0_[4] ),
        .I5(\rq_n_reg_n_0_[5] ),
        .O(h1_reg_0_63_0_2_i_104_n_0));
  LUT5 #(
    .INIT(32'hF7FFFFFF)) 
    h1_reg_0_63_0_2_i_105
       (.I0(\rq_n_reg_n_0_[2] ),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(\rq_n_reg_n_0_[3] ),
        .I3(\rq_n_reg_n_0_[4] ),
        .I4(\rq_n_reg_n_0_[5] ),
        .O(h1_reg_0_63_0_2_i_105_n_0));
  LUT6 #(
    .INIT(64'hFFB7FFFFFFFFFFFF)) 
    h1_reg_0_63_0_2_i_106
       (.I0(\rq_n_reg_n_0_[1] ),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[3] ),
        .I4(\rq_n_reg_n_0_[4] ),
        .I5(\rq_n_reg_n_0_[5] ),
        .O(h1_reg_0_63_0_2_i_106_n_0));
  LUT5 #(
    .INIT(32'hFDFFFFFF)) 
    h1_reg_0_63_0_2_i_107
       (.I0(\rq_n_reg_n_0_[2] ),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(\rq_n_reg_n_0_[3] ),
        .I3(\rq_n_reg_n_0_[4] ),
        .I4(\rq_n_reg_n_0_[5] ),
        .O(h1_reg_0_63_0_2_i_107_n_0));
  LUT5 #(
    .INIT(32'hAAA6AAAA)) 
    h1_reg_0_63_0_2_i_108
       (.I0(rq_prod_reg__0[3]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_191_n_0),
        .O(h1_reg_0_63_0_2_i_108_n_0));
  LUT5 #(
    .INIT(32'h9AAAAAAA)) 
    h1_reg_0_63_0_2_i_109
       (.I0(rq_prod_reg__0[2]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_191_n_0),
        .O(h1_reg_0_63_0_2_i_109_n_0));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT2 #(
    .INIT(4'h1)) 
    h1_reg_0_63_0_2_i_11
       (.I0(\layer_reg_n_0_[1] ),
        .I1(\layer_reg_n_0_[0] ),
        .O(h1_reg_0_63_0_2_i_11_n_0));
  LUT5 #(
    .INIT(32'hA9AAAAAA)) 
    h1_reg_0_63_0_2_i_110
       (.I0(rq_prod_reg__0[1]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_191_n_0),
        .O(h1_reg_0_63_0_2_i_110_n_0));
  LUT5 #(
    .INIT(32'hAA9AAAAA)) 
    h1_reg_0_63_0_2_i_111
       (.I0(rq_prod_reg__0[0]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_191_n_0),
        .O(h1_reg_0_63_0_2_i_111_n_0));
  LUT5 #(
    .INIT(32'hAAA6AAAA)) 
    h1_reg_0_63_0_2_i_112
       (.I0(rq_prod_reg__0[35]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_192_n_0),
        .O(h1_reg_0_63_0_2_i_112_n_0));
  LUT5 #(
    .INIT(32'h9AAAAAAA)) 
    h1_reg_0_63_0_2_i_113
       (.I0(rq_prod_reg__0[34]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_192_n_0),
        .O(h1_reg_0_63_0_2_i_113_n_0));
  LUT5 #(
    .INIT(32'hA9AAAAAA)) 
    h1_reg_0_63_0_2_i_114
       (.I0(rq_prod_reg__0[33]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_192_n_0),
        .O(h1_reg_0_63_0_2_i_114_n_0));
  LUT5 #(
    .INIT(32'hAA9AAAAA)) 
    h1_reg_0_63_0_2_i_115
       (.I0(rq_prod_reg__0[32]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_192_n_0),
        .O(h1_reg_0_63_0_2_i_115_n_0));
  LUT6 #(
    .INIT(64'h0000000008000000)) 
    h1_reg_0_63_0_2_i_116
       (.I0(\rq_n_reg_n_0_[5] ),
        .I1(\rq_n_reg_n_0_[4] ),
        .I2(\rq_n_reg_n_0_[3] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(\rq_n_reg_n_0_[0] ),
        .I5(\rq_n_reg_n_0_[2] ),
        .O(rq_half[50]));
  LUT6 #(
    .INIT(64'h0000000000000800)) 
    h1_reg_0_63_0_2_i_117
       (.I0(\rq_n_reg_n_0_[5] ),
        .I1(\rq_n_reg_n_0_[4] ),
        .I2(\rq_n_reg_n_0_[3] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(\rq_n_reg_n_0_[0] ),
        .I5(\rq_n_reg_n_0_[2] ),
        .O(rq_half[49]));
  LUT6 #(
    .INIT(64'hFFEFFFFFFFFFFFFF)) 
    h1_reg_0_63_0_2_i_118
       (.I0(\rq_n_reg_n_0_[2] ),
        .I1(\rq_n_reg_n_0_[0] ),
        .I2(\rq_n_reg_n_0_[1] ),
        .I3(\rq_n_reg_n_0_[3] ),
        .I4(\rq_n_reg_n_0_[4] ),
        .I5(\rq_n_reg_n_0_[5] ),
        .O(h1_reg_0_63_0_2_i_118_n_0));
  LUT6 #(
    .INIT(64'hFFBDFFFFFFFFFFFF)) 
    h1_reg_0_63_0_2_i_119
       (.I0(\rq_n_reg_n_0_[2] ),
        .I1(\rq_n_reg_n_0_[0] ),
        .I2(\rq_n_reg_n_0_[1] ),
        .I3(\rq_n_reg_n_0_[3] ),
        .I4(\rq_n_reg_n_0_[4] ),
        .I5(\rq_n_reg_n_0_[5] ),
        .O(h1_reg_0_63_0_2_i_119_n_0));
  (* SOFT_HLUTNM = "soft_lutpair51" *) 
  LUT2 #(
    .INIT(4'h8)) 
    h1_reg_0_63_0_2_i_12
       (.I0(state[1]),
        .I1(state[0]),
        .O(h1_reg_0_63_0_2_i_12_n_0));
  LUT5 #(
    .INIT(32'hFBFFFFFF)) 
    h1_reg_0_63_0_2_i_120
       (.I0(\rq_n_reg_n_0_[2] ),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(\rq_n_reg_n_0_[3] ),
        .I3(\rq_n_reg_n_0_[4] ),
        .I4(\rq_n_reg_n_0_[5] ),
        .O(h1_reg_0_63_0_2_i_120_n_0));
  LUT5 #(
    .INIT(32'hEFFF1000)) 
    h1_reg_0_63_0_2_i_121
       (.I0(\rq_n_reg_n_0_[2] ),
        .I1(\rq_n_reg_n_0_[0] ),
        .I2(\rq_n_reg_n_0_[1] ),
        .I3(h1_reg_0_63_0_2_i_193_n_0),
        .I4(rq_prod_reg__0[49]),
        .O(h1_reg_0_63_0_2_i_121_n_0));
  LUT5 #(
    .INIT(32'hAA9AAAAA)) 
    h1_reg_0_63_0_2_i_122
       (.I0(rq_prod_reg__0[48]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_193_n_0),
        .O(h1_reg_0_63_0_2_i_122_n_0));
  LUT5 #(
    .INIT(32'hAAA6AAAA)) 
    h1_reg_0_63_0_2_i_123
       (.I0(rq_prod_reg__0[19]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_194_n_0),
        .O(h1_reg_0_63_0_2_i_123_n_0));
  LUT5 #(
    .INIT(32'h9AAAAAAA)) 
    h1_reg_0_63_0_2_i_124
       (.I0(rq_prod_reg__0[18]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_194_n_0),
        .O(h1_reg_0_63_0_2_i_124_n_0));
  LUT5 #(
    .INIT(32'hA9AAAAAA)) 
    h1_reg_0_63_0_2_i_125
       (.I0(rq_prod_reg__0[17]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_194_n_0),
        .O(h1_reg_0_63_0_2_i_125_n_0));
  LUT5 #(
    .INIT(32'hAA9AAAAA)) 
    h1_reg_0_63_0_2_i_126
       (.I0(rq_prod_reg__0[16]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_194_n_0),
        .O(h1_reg_0_63_0_2_i_126_n_0));
  LUT5 #(
    .INIT(32'hAAA6AAAA)) 
    h1_reg_0_63_0_2_i_127
       (.I0(rq_prod_reg__0[11]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_195_n_0),
        .O(h1_reg_0_63_0_2_i_127_n_0));
  LUT5 #(
    .INIT(32'h9AAAAAAA)) 
    h1_reg_0_63_0_2_i_128
       (.I0(rq_prod_reg__0[10]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_195_n_0),
        .O(h1_reg_0_63_0_2_i_128_n_0));
  LUT5 #(
    .INIT(32'hA9AAAAAA)) 
    h1_reg_0_63_0_2_i_129
       (.I0(rq_prod_reg__0[9]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_195_n_0),
        .O(h1_reg_0_63_0_2_i_129_n_0));
  LUT6 #(
    .INIT(64'hFC0CFAFAFC0C0A0A)) 
    h1_reg_0_63_0_2_i_13
       (.I0(h1_reg_0_63_0_2_i_32_n_0),
        .I1(h1_reg_0_63_0_2_i_33_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_34_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_0_2_i_35_n_0),
        .O(h1_reg_0_63_0_2_i_13_n_0));
  LUT5 #(
    .INIT(32'hAA9AAAAA)) 
    h1_reg_0_63_0_2_i_130
       (.I0(rq_prod_reg__0[8]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_195_n_0),
        .O(h1_reg_0_63_0_2_i_130_n_0));
  LUT5 #(
    .INIT(32'hAAA6AAAA)) 
    h1_reg_0_63_0_2_i_131
       (.I0(rq_prod_reg__0[43]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_196_n_0),
        .O(h1_reg_0_63_0_2_i_131_n_0));
  LUT5 #(
    .INIT(32'h9AAAAAAA)) 
    h1_reg_0_63_0_2_i_132
       (.I0(rq_prod_reg__0[42]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_196_n_0),
        .O(h1_reg_0_63_0_2_i_132_n_0));
  LUT5 #(
    .INIT(32'hA9AAAAAA)) 
    h1_reg_0_63_0_2_i_133
       (.I0(rq_prod_reg__0[41]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_196_n_0),
        .O(h1_reg_0_63_0_2_i_133_n_0));
  LUT5 #(
    .INIT(32'hAA9AAAAA)) 
    h1_reg_0_63_0_2_i_134
       (.I0(rq_prod_reg__0[40]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_196_n_0),
        .O(h1_reg_0_63_0_2_i_134_n_0));
  LUT5 #(
    .INIT(32'hAAA6AAAA)) 
    h1_reg_0_63_0_2_i_135
       (.I0(rq_prod_reg__0[27]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_197_n_0),
        .O(h1_reg_0_63_0_2_i_135_n_0));
  LUT5 #(
    .INIT(32'h9AAAAAAA)) 
    h1_reg_0_63_0_2_i_136
       (.I0(rq_prod_reg__0[26]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_197_n_0),
        .O(h1_reg_0_63_0_2_i_136_n_0));
  LUT5 #(
    .INIT(32'hA9AAAAAA)) 
    h1_reg_0_63_0_2_i_137
       (.I0(rq_prod_reg__0[25]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_197_n_0),
        .O(h1_reg_0_63_0_2_i_137_n_0));
  LUT5 #(
    .INIT(32'hAA9AAAAA)) 
    h1_reg_0_63_0_2_i_138
       (.I0(rq_prod_reg__0[24]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_197_n_0),
        .O(h1_reg_0_63_0_2_i_138_n_0));
  LUT5 #(
    .INIT(32'hAAA9AAAA)) 
    h1_reg_0_63_0_2_i_139
       (.I0(rq_prod_reg__0[15]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_195_n_0),
        .O(h1_reg_0_63_0_2_i_139_n_0));
  LUT4 #(
    .INIT(16'h0B08)) 
    h1_reg_0_63_0_2_i_14
       (.I0(h1_reg_0_63_0_2_i_36_n_0),
        .I1(\rq_n_reg_n_0_[3] ),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_37_n_0),
        .O(h1_reg_0_63_0_2_i_14_n_0));
  LUT5 #(
    .INIT(32'h6AAAAAAA)) 
    h1_reg_0_63_0_2_i_140
       (.I0(rq_prod_reg__0[14]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_195_n_0),
        .O(h1_reg_0_63_0_2_i_140_n_0));
  LUT5 #(
    .INIT(32'hAA6AAAAA)) 
    h1_reg_0_63_0_2_i_141
       (.I0(rq_prod_reg__0[13]),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(\rq_n_reg_n_0_[0] ),
        .I4(h1_reg_0_63_0_2_i_195_n_0),
        .O(h1_reg_0_63_0_2_i_141_n_0));
  LUT5 #(
    .INIT(32'hAA6AAAAA)) 
    h1_reg_0_63_0_2_i_142
       (.I0(rq_prod_reg__0[12]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_195_n_0),
        .O(h1_reg_0_63_0_2_i_142_n_0));
  LUT5 #(
    .INIT(32'hAAA9AAAA)) 
    h1_reg_0_63_0_2_i_143
       (.I0(rq_prod_reg__0[47]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_196_n_0),
        .O(h1_reg_0_63_0_2_i_143_n_0));
  LUT5 #(
    .INIT(32'h6AAAAAAA)) 
    h1_reg_0_63_0_2_i_144
       (.I0(rq_prod_reg__0[46]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_196_n_0),
        .O(h1_reg_0_63_0_2_i_144_n_0));
  LUT5 #(
    .INIT(32'hAA6AAAAA)) 
    h1_reg_0_63_0_2_i_145
       (.I0(rq_prod_reg__0[45]),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(\rq_n_reg_n_0_[0] ),
        .I4(h1_reg_0_63_0_2_i_196_n_0),
        .O(h1_reg_0_63_0_2_i_145_n_0));
  LUT5 #(
    .INIT(32'hAA6AAAAA)) 
    h1_reg_0_63_0_2_i_146
       (.I0(rq_prod_reg__0[44]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_196_n_0),
        .O(h1_reg_0_63_0_2_i_146_n_0));
  LUT5 #(
    .INIT(32'hAAA9AAAA)) 
    h1_reg_0_63_0_2_i_147
       (.I0(rq_prod_reg__0[31]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_197_n_0),
        .O(h1_reg_0_63_0_2_i_147_n_0));
  LUT5 #(
    .INIT(32'h6AAAAAAA)) 
    h1_reg_0_63_0_2_i_148
       (.I0(rq_prod_reg__0[30]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_197_n_0),
        .O(h1_reg_0_63_0_2_i_148_n_0));
  LUT5 #(
    .INIT(32'hAA6AAAAA)) 
    h1_reg_0_63_0_2_i_149
       (.I0(rq_prod_reg__0[29]),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(\rq_n_reg_n_0_[0] ),
        .I4(h1_reg_0_63_0_2_i_197_n_0),
        .O(h1_reg_0_63_0_2_i_149_n_0));
  (* SOFT_HLUTNM = "soft_lutpair84" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    h1_reg_0_63_0_2_i_15
       (.I0(h1_reg_0_63_0_2_i_38_n_0),
        .I1(\rq_n_reg_n_0_[3] ),
        .I2(h1_reg_0_63_0_2_i_39_n_0),
        .O(h1_reg_0_63_0_2_i_15_n_0));
  LUT5 #(
    .INIT(32'hAA6AAAAA)) 
    h1_reg_0_63_0_2_i_150
       (.I0(rq_prod_reg__0[28]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_197_n_0),
        .O(h1_reg_0_63_0_2_i_150_n_0));
  LUT5 #(
    .INIT(32'hAAA9AAAA)) 
    h1_reg_0_63_0_2_i_151
       (.I0(rq_prod_reg__0[7]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_191_n_0),
        .O(h1_reg_0_63_0_2_i_151_n_0));
  LUT5 #(
    .INIT(32'h6AAAAAAA)) 
    h1_reg_0_63_0_2_i_152
       (.I0(rq_prod_reg__0[6]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_191_n_0),
        .O(h1_reg_0_63_0_2_i_152_n_0));
  LUT5 #(
    .INIT(32'hAA6AAAAA)) 
    h1_reg_0_63_0_2_i_153
       (.I0(rq_prod_reg__0[5]),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(\rq_n_reg_n_0_[0] ),
        .I4(h1_reg_0_63_0_2_i_191_n_0),
        .O(h1_reg_0_63_0_2_i_153_n_0));
  LUT5 #(
    .INIT(32'hAA6AAAAA)) 
    h1_reg_0_63_0_2_i_154
       (.I0(rq_prod_reg__0[4]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_191_n_0),
        .O(h1_reg_0_63_0_2_i_154_n_0));
  LUT5 #(
    .INIT(32'hAAA9AAAA)) 
    h1_reg_0_63_0_2_i_155
       (.I0(rq_prod_reg__0[39]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_192_n_0),
        .O(h1_reg_0_63_0_2_i_155_n_0));
  LUT5 #(
    .INIT(32'h6AAAAAAA)) 
    h1_reg_0_63_0_2_i_156
       (.I0(rq_prod_reg__0[38]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_192_n_0),
        .O(h1_reg_0_63_0_2_i_156_n_0));
  LUT5 #(
    .INIT(32'hAA6AAAAA)) 
    h1_reg_0_63_0_2_i_157
       (.I0(rq_prod_reg__0[37]),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(\rq_n_reg_n_0_[0] ),
        .I4(h1_reg_0_63_0_2_i_192_n_0),
        .O(h1_reg_0_63_0_2_i_157_n_0));
  LUT5 #(
    .INIT(32'hAA6AAAAA)) 
    h1_reg_0_63_0_2_i_158
       (.I0(rq_prod_reg__0[36]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_192_n_0),
        .O(h1_reg_0_63_0_2_i_158_n_0));
  LUT5 #(
    .INIT(32'hAAA9AAAA)) 
    h1_reg_0_63_0_2_i_159
       (.I0(rq_prod_reg__0[23]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_194_n_0),
        .O(h1_reg_0_63_0_2_i_159_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 h1_reg_0_63_0_2_i_16
       (.CI(h1_reg_0_63_0_2_i_40_n_0),
        .CO({h1_reg_0_63_0_2_i_16_n_0,h1_reg_0_63_0_2_i_16_n_1,h1_reg_0_63_0_2_i_16_n_2,h1_reg_0_63_0_2_i_16_n_3}),
        .CYINIT(1'b0),
        .DI({h1_reg_0_63_0_2_i_41_n_0,h1_reg_0_63_0_2_i_42_n_0,h1_reg_0_63_0_2_i_43_n_0,h1_reg_0_63_0_2_i_44_n_0}),
        .O(NLW_h1_reg_0_63_0_2_i_16_O_UNCONNECTED[3:0]),
        .S({h1_reg_0_63_0_2_i_45_n_0,h1_reg_0_63_0_2_i_46_n_0,h1_reg_0_63_0_2_i_47_n_0,h1_reg_0_63_0_2_i_48_n_0}));
  LUT5 #(
    .INIT(32'h6AAAAAAA)) 
    h1_reg_0_63_0_2_i_160
       (.I0(rq_prod_reg__0[22]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_194_n_0),
        .O(h1_reg_0_63_0_2_i_160_n_0));
  LUT5 #(
    .INIT(32'hAA6AAAAA)) 
    h1_reg_0_63_0_2_i_161
       (.I0(rq_prod_reg__0[21]),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(\rq_n_reg_n_0_[0] ),
        .I4(h1_reg_0_63_0_2_i_194_n_0),
        .O(h1_reg_0_63_0_2_i_161_n_0));
  LUT5 #(
    .INIT(32'hAA6AAAAA)) 
    h1_reg_0_63_0_2_i_162
       (.I0(rq_prod_reg__0[20]),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_194_n_0),
        .O(h1_reg_0_63_0_2_i_162_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 h1_reg_0_63_0_2_i_163
       (.CI(h1_reg_0_63_0_2_i_198_n_0),
        .CO({h1_reg_0_63_0_2_i_163_n_0,h1_reg_0_63_0_2_i_163_n_1,h1_reg_0_63_0_2_i_163_n_2,h1_reg_0_63_0_2_i_163_n_3}),
        .CYINIT(1'b0),
        .DI({h1_reg_0_63_0_2_i_199_n_0,h1_reg_0_63_0_2_i_200_n_0,h1_reg_0_63_0_2_i_201_n_0,h1_reg_0_63_0_2_i_202_n_0}),
        .O(NLW_h1_reg_0_63_0_2_i_163_O_UNCONNECTED[3:0]),
        .S({h1_reg_0_63_0_2_i_203_n_0,h1_reg_0_63_0_2_i_204_n_0,h1_reg_0_63_0_2_i_205_n_0,h1_reg_0_63_0_2_i_206_n_0}));
  LUT6 #(
    .INIT(64'hFFFFEE22FFFFB8B8)) 
    h1_reg_0_63_0_2_i_164
       (.I0(h1_reg_0_63_0_2_i_179_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_207_n_0),
        .I3(h1_reg_0_63_0_2_i_178_n_0),
        .I4(h1_reg_0_63_0_2_i_208_n_0),
        .I5(\rq_n_reg_n_0_[0] ),
        .O(h1_reg_0_63_0_2_i_164_n_0));
  LUT6 #(
    .INIT(64'hFFFFEE22FFFFB8B8)) 
    h1_reg_0_63_0_2_i_165
       (.I0(h1_reg_0_63_0_2_i_207_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_209_n_0),
        .I3(h1_reg_0_63_0_2_i_179_n_0),
        .I4(h1_reg_0_63_0_2_i_210_n_0),
        .I5(\rq_n_reg_n_0_[0] ),
        .O(h1_reg_0_63_0_2_i_165_n_0));
  LUT6 #(
    .INIT(64'hFFFFEE22FFFFB8B8)) 
    h1_reg_0_63_0_2_i_166
       (.I0(h1_reg_0_63_0_2_i_209_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_211_n_0),
        .I3(h1_reg_0_63_0_2_i_207_n_0),
        .I4(h1_reg_0_63_0_2_i_212_n_0),
        .I5(\rq_n_reg_n_0_[0] ),
        .O(h1_reg_0_63_0_2_i_166_n_0));
  LUT6 #(
    .INIT(64'hFFFFEE22FFFFB8B8)) 
    h1_reg_0_63_0_2_i_167
       (.I0(h1_reg_0_63_0_2_i_211_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_213_n_0),
        .I3(h1_reg_0_63_0_2_i_209_n_0),
        .I4(h1_reg_0_63_0_2_i_214_n_0),
        .I5(\rq_n_reg_n_0_[0] ),
        .O(h1_reg_0_63_0_2_i_167_n_0));
  LUT6 #(
    .INIT(64'h0000000011DD4747)) 
    h1_reg_0_63_0_2_i_168
       (.I0(h1_reg_0_63_0_2_i_179_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_207_n_0),
        .I3(h1_reg_0_63_0_2_i_178_n_0),
        .I4(\rq_n_reg_n_0_[0] ),
        .I5(h1_reg_0_63_0_2_i_208_n_0),
        .O(h1_reg_0_63_0_2_i_168_n_0));
  LUT6 #(
    .INIT(64'h0000000011DD4747)) 
    h1_reg_0_63_0_2_i_169
       (.I0(h1_reg_0_63_0_2_i_207_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_209_n_0),
        .I3(h1_reg_0_63_0_2_i_179_n_0),
        .I4(\rq_n_reg_n_0_[0] ),
        .I5(h1_reg_0_63_0_2_i_210_n_0),
        .O(h1_reg_0_63_0_2_i_169_n_0));
  LUT4 #(
    .INIT(16'h0002)) 
    h1_reg_0_63_0_2_i_17
       (.I0(h1_reg_0_63_0_2_i_49_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_17_n_0));
  LUT6 #(
    .INIT(64'h0000000011DD4747)) 
    h1_reg_0_63_0_2_i_170
       (.I0(h1_reg_0_63_0_2_i_209_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_211_n_0),
        .I3(h1_reg_0_63_0_2_i_207_n_0),
        .I4(\rq_n_reg_n_0_[0] ),
        .I5(h1_reg_0_63_0_2_i_212_n_0),
        .O(h1_reg_0_63_0_2_i_170_n_0));
  LUT6 #(
    .INIT(64'h0000000011DD4747)) 
    h1_reg_0_63_0_2_i_171
       (.I0(h1_reg_0_63_0_2_i_211_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_213_n_0),
        .I3(h1_reg_0_63_0_2_i_209_n_0),
        .I4(\rq_n_reg_n_0_[0] ),
        .I5(h1_reg_0_63_0_2_i_214_n_0),
        .O(h1_reg_0_63_0_2_i_171_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_172
       (.I0(h1_reg_0_63_0_2_i_182_n_0),
        .I1(h1_reg_0_63_0_2_i_188_n_0),
        .I2(\rq_n_reg_n_0_[1] ),
        .I3(h1_reg_0_63_0_2_i_185_n_0),
        .I4(\rq_n_reg_n_0_[2] ),
        .I5(h1_reg_0_63_0_2_i_215_n_0),
        .O(h1_reg_0_63_0_2_i_172_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_173
       (.I0(h1_reg_0_63_0_2_i_189_n_0),
        .I1(h1_reg_0_63_0_2_i_190_n_0),
        .I2(\rq_n_reg_n_0_[1] ),
        .I3(h1_reg_0_63_0_2_i_187_n_0),
        .I4(\rq_n_reg_n_0_[2] ),
        .I5(h1_reg_0_63_0_2_i_216_n_0),
        .O(h1_reg_0_63_0_2_i_173_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_174
       (.I0(h1_reg_0_63_0_2_i_185_n_0),
        .I1(h1_reg_0_63_0_2_i_215_n_0),
        .I2(\rq_n_reg_n_0_[1] ),
        .I3(h1_reg_0_63_0_2_i_188_n_0),
        .I4(\rq_n_reg_n_0_[2] ),
        .I5(h1_reg_0_63_0_2_i_217_n_0),
        .O(h1_reg_0_63_0_2_i_174_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_175
       (.I0(h1_reg_0_63_0_2_i_187_n_0),
        .I1(h1_reg_0_63_0_2_i_216_n_0),
        .I2(\rq_n_reg_n_0_[1] ),
        .I3(h1_reg_0_63_0_2_i_190_n_0),
        .I4(\rq_n_reg_n_0_[2] ),
        .I5(h1_reg_0_63_0_2_i_218_n_0),
        .O(h1_reg_0_63_0_2_i_175_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_176
       (.I0(h1_reg_0_63_0_2_i_188_n_0),
        .I1(h1_reg_0_63_0_2_i_217_n_0),
        .I2(\rq_n_reg_n_0_[1] ),
        .I3(h1_reg_0_63_0_2_i_215_n_0),
        .I4(\rq_n_reg_n_0_[2] ),
        .I5(h1_reg_0_63_0_2_i_219_n_0),
        .O(h1_reg_0_63_0_2_i_176_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_177
       (.I0(h1_reg_0_63_0_2_i_190_n_0),
        .I1(h1_reg_0_63_0_2_i_218_n_0),
        .I2(\rq_n_reg_n_0_[1] ),
        .I3(h1_reg_0_63_0_2_i_216_n_0),
        .I4(\rq_n_reg_n_0_[2] ),
        .I5(h1_reg_0_63_0_2_i_220_n_0),
        .O(h1_reg_0_63_0_2_i_177_n_0));
  LUT3 #(
    .INIT(8'hB8)) 
    h1_reg_0_63_0_2_i_178
       (.I0(h1_reg_0_63_0_2_i_215_n_0),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(h1_reg_0_63_0_2_i_219_n_0),
        .O(h1_reg_0_63_0_2_i_178_n_0));
  LUT5 #(
    .INIT(32'hB8BBB888)) 
    h1_reg_0_63_0_2_i_179
       (.I0(h1_reg_0_63_0_2_i_217_n_0),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(h1_reg_0_63_0_2_i_221_n_0),
        .I3(\rq_n_reg_n_0_[3] ),
        .I4(h1_reg_0_63_0_2_i_222_n_0),
        .O(h1_reg_0_63_0_2_i_179_n_0));
  LUT4 #(
    .INIT(16'h0F0D)) 
    h1_reg_0_63_0_2_i_18
       (.I0(h1_reg_0_63_0_2_i_49_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_8_n_4),
        .I3(\rq_n_reg_n_0_[0] ),
        .O(h1_reg_0_63_0_2_i_18_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_180
       (.I0(h1_reg_0_63_0_2_i_216_n_0),
        .I1(h1_reg_0_63_0_2_i_220_n_0),
        .I2(\rq_n_reg_n_0_[1] ),
        .I3(h1_reg_0_63_0_2_i_218_n_0),
        .I4(\rq_n_reg_n_0_[2] ),
        .I5(h1_reg_0_63_0_2_i_223_n_0),
        .O(h1_reg_0_63_0_2_i_180_n_0));
  LUT5 #(
    .INIT(32'hFFFE0002)) 
    h1_reg_0_63_0_2_i_181
       (.I0(h1_reg_0_63_0_2_i_8_n_5),
        .I1(\rq_n_reg_n_0_[5] ),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(\rq_n_reg_n_0_[3] ),
        .I4(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_181_n_0));
  LUT5 #(
    .INIT(32'hFFFE0002)) 
    h1_reg_0_63_0_2_i_182
       (.I0(h1_reg_0_63_0_2_i_22_n_5),
        .I1(\rq_n_reg_n_0_[5] ),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(\rq_n_reg_n_0_[3] ),
        .I4(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_182_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFE00000002)) 
    h1_reg_0_63_0_2_i_183
       (.I0(h1_reg_0_63_0_2_i_22_n_4),
        .I1(\rq_n_reg_n_0_[5] ),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(\rq_n_reg_n_0_[3] ),
        .I4(\rq_n_reg_n_0_[2] ),
        .I5(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_183_n_0));
  LUT5 #(
    .INIT(32'hFFFE0002)) 
    h1_reg_0_63_0_2_i_184
       (.I0(h1_reg_0_63_0_2_i_8_n_7),
        .I1(\rq_n_reg_n_0_[5] ),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(\rq_n_reg_n_0_[3] ),
        .I4(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_184_n_0));
  LUT5 #(
    .INIT(32'hFFFE0002)) 
    h1_reg_0_63_0_2_i_185
       (.I0(h1_reg_0_63_0_2_i_22_n_7),
        .I1(\rq_n_reg_n_0_[5] ),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(\rq_n_reg_n_0_[3] ),
        .I4(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_185_n_0));
  LUT5 #(
    .INIT(32'hFFFE0002)) 
    h1_reg_0_63_0_2_i_186
       (.I0(h1_reg_0_63_0_2_i_8_n_6),
        .I1(\rq_n_reg_n_0_[5] ),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(\rq_n_reg_n_0_[3] ),
        .I4(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_186_n_0));
  LUT5 #(
    .INIT(32'hFFFE0002)) 
    h1_reg_0_63_0_2_i_187
       (.I0(h1_reg_0_63_0_2_i_22_n_6),
        .I1(\rq_n_reg_n_0_[5] ),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(\rq_n_reg_n_0_[3] ),
        .I4(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_187_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFB8000000B8)) 
    h1_reg_0_63_0_2_i_188
       (.I0(h1_reg_0_63_0_2_i_8_n_5),
        .I1(\rq_n_reg_n_0_[3] ),
        .I2(h1_reg_0_63_0_2_i_58_n_5),
        .I3(\rq_n_reg_n_0_[5] ),
        .I4(\rq_n_reg_n_0_[4] ),
        .I5(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_188_n_0));
  LUT5 #(
    .INIT(32'hFFFE0002)) 
    h1_reg_0_63_0_2_i_189
       (.I0(h1_reg_0_63_0_2_i_22_n_4),
        .I1(\rq_n_reg_n_0_[5] ),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(\rq_n_reg_n_0_[3] ),
        .I4(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_189_n_0));
  LUT6 #(
    .INIT(64'hFC0CFAFAFC0C0A0A)) 
    h1_reg_0_63_0_2_i_19
       (.I0(h1_reg_0_63_0_2_i_50_n_0),
        .I1(h1_reg_0_63_0_2_i_51_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_52_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_0_2_i_53_n_0),
        .O(h1_reg_0_63_0_2_i_19_n_0));
  LUT5 #(
    .INIT(32'hFFFE0002)) 
    h1_reg_0_63_0_2_i_190
       (.I0(h1_reg_0_63_0_2_i_58_n_4),
        .I1(\rq_n_reg_n_0_[5] ),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(\rq_n_reg_n_0_[3] ),
        .I4(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_190_n_0));
  LUT6 #(
    .INIT(64'h0000000000015554)) 
    h1_reg_0_63_0_2_i_191
       (.I0(\rq_n_reg_n_0_[4] ),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(\rq_n_reg_n_0_[5] ),
        .O(h1_reg_0_63_0_2_i_191_n_0));
  LUT6 #(
    .INIT(64'h0001555400000000)) 
    h1_reg_0_63_0_2_i_192
       (.I0(\rq_n_reg_n_0_[4] ),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(\rq_n_reg_n_0_[5] ),
        .O(h1_reg_0_63_0_2_i_192_n_0));
  LUT6 #(
    .INIT(64'h5556000000000000)) 
    h1_reg_0_63_0_2_i_193
       (.I0(\rq_n_reg_n_0_[3] ),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[2] ),
        .I4(\rq_n_reg_n_0_[4] ),
        .I5(\rq_n_reg_n_0_[5] ),
        .O(h1_reg_0_63_0_2_i_193_n_0));
  LUT6 #(
    .INIT(64'h000000000002AAA8)) 
    h1_reg_0_63_0_2_i_194
       (.I0(\rq_n_reg_n_0_[4] ),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(\rq_n_reg_n_0_[5] ),
        .O(h1_reg_0_63_0_2_i_194_n_0));
  LUT6 #(
    .INIT(64'h0000000055540002)) 
    h1_reg_0_63_0_2_i_195
       (.I0(\rq_n_reg_n_0_[4] ),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(\rq_n_reg_n_0_[5] ),
        .O(h1_reg_0_63_0_2_i_195_n_0));
  LUT6 #(
    .INIT(64'h5554000200000000)) 
    h1_reg_0_63_0_2_i_196
       (.I0(\rq_n_reg_n_0_[4] ),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(\rq_n_reg_n_0_[5] ),
        .O(h1_reg_0_63_0_2_i_196_n_0));
  LUT6 #(
    .INIT(64'h00000001AAA80000)) 
    h1_reg_0_63_0_2_i_197
       (.I0(\rq_n_reg_n_0_[4] ),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(\rq_n_reg_n_0_[5] ),
        .O(h1_reg_0_63_0_2_i_197_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 h1_reg_0_63_0_2_i_198
       (.CI(h1_reg_0_63_0_2_i_224_n_0),
        .CO({h1_reg_0_63_0_2_i_198_n_0,h1_reg_0_63_0_2_i_198_n_1,h1_reg_0_63_0_2_i_198_n_2,h1_reg_0_63_0_2_i_198_n_3}),
        .CYINIT(1'b0),
        .DI({h1_reg_0_63_0_2_i_225_n_0,h1_reg_0_63_0_2_i_226_n_0,h1_reg_0_63_0_2_i_227_n_0,h1_reg_0_63_0_2_i_228_n_0}),
        .O(NLW_h1_reg_0_63_0_2_i_198_O_UNCONNECTED[3:0]),
        .S({h1_reg_0_63_0_2_i_229_n_0,h1_reg_0_63_0_2_i_230_n_0,h1_reg_0_63_0_2_i_231_n_0,h1_reg_0_63_0_2_i_232_n_0}));
  LUT6 #(
    .INIT(64'hFFFFEE22FFFFB8B8)) 
    h1_reg_0_63_0_2_i_199
       (.I0(h1_reg_0_63_0_2_i_213_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_233_n_0),
        .I3(h1_reg_0_63_0_2_i_211_n_0),
        .I4(h1_reg_0_63_0_2_i_234_n_0),
        .I5(\rq_n_reg_n_0_[0] ),
        .O(h1_reg_0_63_0_2_i_199_n_0));
  LUT5 #(
    .INIT(32'h0000FFB8)) 
    h1_reg_0_63_0_2_i_2
       (.I0(h1_reg_0_63_0_2_i_9_n_0),
        .I1(\rq_n_reg_n_0_[0] ),
        .I2(h1_reg_0_63_0_2_i_5_n_0),
        .I3(h1_reg_0_63_0_2_i_6_n_3),
        .I4(h1_reg_0_63_0_2_i_8_n_4),
        .O(hidden_activation[1]));
  LUT4 #(
    .INIT(16'h0B08)) 
    h1_reg_0_63_0_2_i_20
       (.I0(h1_reg_0_63_0_2_i_54_n_0),
        .I1(\rq_n_reg_n_0_[3] ),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_55_n_0),
        .O(h1_reg_0_63_0_2_i_20_n_0));
  LUT6 #(
    .INIT(64'hFFFFEE22FFFFB8B8)) 
    h1_reg_0_63_0_2_i_200
       (.I0(h1_reg_0_63_0_2_i_233_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_235_n_0),
        .I3(h1_reg_0_63_0_2_i_213_n_0),
        .I4(h1_reg_0_63_0_2_i_236_n_0),
        .I5(\rq_n_reg_n_0_[0] ),
        .O(h1_reg_0_63_0_2_i_200_n_0));
  LUT6 #(
    .INIT(64'hFFFFEE22FFFFB8B8)) 
    h1_reg_0_63_0_2_i_201
       (.I0(h1_reg_0_63_0_2_i_235_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_237_n_0),
        .I3(h1_reg_0_63_0_2_i_233_n_0),
        .I4(h1_reg_0_63_0_2_i_238_n_0),
        .I5(\rq_n_reg_n_0_[0] ),
        .O(h1_reg_0_63_0_2_i_201_n_0));
  LUT6 #(
    .INIT(64'hFFFFEE22FFFFB8B8)) 
    h1_reg_0_63_0_2_i_202
       (.I0(h1_reg_0_63_0_2_i_237_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_239_n_0),
        .I3(h1_reg_0_63_0_2_i_235_n_0),
        .I4(h1_reg_0_63_0_2_i_240_n_0),
        .I5(\rq_n_reg_n_0_[0] ),
        .O(h1_reg_0_63_0_2_i_202_n_0));
  LUT6 #(
    .INIT(64'h0000000011DD4747)) 
    h1_reg_0_63_0_2_i_203
       (.I0(h1_reg_0_63_0_2_i_213_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_233_n_0),
        .I3(h1_reg_0_63_0_2_i_211_n_0),
        .I4(\rq_n_reg_n_0_[0] ),
        .I5(h1_reg_0_63_0_2_i_234_n_0),
        .O(h1_reg_0_63_0_2_i_203_n_0));
  LUT6 #(
    .INIT(64'h0000000011DD4747)) 
    h1_reg_0_63_0_2_i_204
       (.I0(h1_reg_0_63_0_2_i_233_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_235_n_0),
        .I3(h1_reg_0_63_0_2_i_213_n_0),
        .I4(\rq_n_reg_n_0_[0] ),
        .I5(h1_reg_0_63_0_2_i_236_n_0),
        .O(h1_reg_0_63_0_2_i_204_n_0));
  LUT6 #(
    .INIT(64'h0000000011DD4747)) 
    h1_reg_0_63_0_2_i_205
       (.I0(h1_reg_0_63_0_2_i_235_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_237_n_0),
        .I3(h1_reg_0_63_0_2_i_233_n_0),
        .I4(\rq_n_reg_n_0_[0] ),
        .I5(h1_reg_0_63_0_2_i_238_n_0),
        .O(h1_reg_0_63_0_2_i_205_n_0));
  LUT6 #(
    .INIT(64'h0000000011DD4747)) 
    h1_reg_0_63_0_2_i_206
       (.I0(h1_reg_0_63_0_2_i_237_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_239_n_0),
        .I3(h1_reg_0_63_0_2_i_235_n_0),
        .I4(\rq_n_reg_n_0_[0] ),
        .I5(h1_reg_0_63_0_2_i_240_n_0),
        .O(h1_reg_0_63_0_2_i_206_n_0));
  LUT5 #(
    .INIT(32'hB8BBB888)) 
    h1_reg_0_63_0_2_i_207
       (.I0(h1_reg_0_63_0_2_i_219_n_0),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(h1_reg_0_63_0_2_i_241_n_0),
        .I3(\rq_n_reg_n_0_[3] ),
        .I4(h1_reg_0_63_0_2_i_242_n_0),
        .O(h1_reg_0_63_0_2_i_207_n_0));
  LUT5 #(
    .INIT(32'hB8FFB800)) 
    h1_reg_0_63_0_2_i_208
       (.I0(h1_reg_0_63_0_2_i_218_n_0),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(h1_reg_0_63_0_2_i_223_n_0),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(h1_reg_0_63_0_2_i_243_n_0),
        .O(h1_reg_0_63_0_2_i_208_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_209
       (.I0(h1_reg_0_63_0_2_i_221_n_0),
        .I1(h1_reg_0_63_0_2_i_222_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_244_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_0_2_i_245_n_0),
        .O(h1_reg_0_63_0_2_i_209_n_0));
  (* SOFT_HLUTNM = "soft_lutpair84" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    h1_reg_0_63_0_2_i_21
       (.I0(h1_reg_0_63_0_2_i_56_n_0),
        .I1(\rq_n_reg_n_0_[3] ),
        .I2(h1_reg_0_63_0_2_i_57_n_0),
        .O(h1_reg_0_63_0_2_i_21_n_0));
  (* SOFT_HLUTNM = "soft_lutpair89" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    h1_reg_0_63_0_2_i_210
       (.I0(h1_reg_0_63_0_2_i_243_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_246_n_0),
        .O(h1_reg_0_63_0_2_i_210_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_211
       (.I0(h1_reg_0_63_0_2_i_241_n_0),
        .I1(h1_reg_0_63_0_2_i_242_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_247_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_0_2_i_248_n_0),
        .O(h1_reg_0_63_0_2_i_211_n_0));
  (* SOFT_HLUTNM = "soft_lutpair90" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    h1_reg_0_63_0_2_i_212
       (.I0(h1_reg_0_63_0_2_i_246_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_249_n_0),
        .O(h1_reg_0_63_0_2_i_212_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_213
       (.I0(h1_reg_0_63_0_2_i_244_n_0),
        .I1(h1_reg_0_63_0_2_i_245_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_222_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_0_2_i_250_n_0),
        .O(h1_reg_0_63_0_2_i_213_n_0));
  (* SOFT_HLUTNM = "soft_lutpair90" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    h1_reg_0_63_0_2_i_214
       (.I0(h1_reg_0_63_0_2_i_249_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_251_n_0),
        .O(h1_reg_0_63_0_2_i_214_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFB8000000B8)) 
    h1_reg_0_63_0_2_i_215
       (.I0(h1_reg_0_63_0_2_i_8_n_7),
        .I1(\rq_n_reg_n_0_[3] ),
        .I2(h1_reg_0_63_0_2_i_58_n_7),
        .I3(\rq_n_reg_n_0_[5] ),
        .I4(\rq_n_reg_n_0_[4] ),
        .I5(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_215_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFB8000000B8)) 
    h1_reg_0_63_0_2_i_216
       (.I0(h1_reg_0_63_0_2_i_8_n_6),
        .I1(\rq_n_reg_n_0_[3] ),
        .I2(h1_reg_0_63_0_2_i_58_n_6),
        .I3(\rq_n_reg_n_0_[5] ),
        .I4(\rq_n_reg_n_0_[4] ),
        .I5(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_216_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFB8000000B8)) 
    h1_reg_0_63_0_2_i_217
       (.I0(h1_reg_0_63_0_2_i_22_n_5),
        .I1(\rq_n_reg_n_0_[3] ),
        .I2(h1_reg_0_63_0_2_i_71_n_5),
        .I3(\rq_n_reg_n_0_[5] ),
        .I4(\rq_n_reg_n_0_[4] ),
        .I5(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_217_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFB8000000B8)) 
    h1_reg_0_63_0_2_i_218
       (.I0(h1_reg_0_63_0_2_i_22_n_4),
        .I1(\rq_n_reg_n_0_[3] ),
        .I2(h1_reg_0_63_0_2_i_71_n_4),
        .I3(\rq_n_reg_n_0_[5] ),
        .I4(\rq_n_reg_n_0_[4] ),
        .I5(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_218_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFB8000000B8)) 
    h1_reg_0_63_0_2_i_219
       (.I0(h1_reg_0_63_0_2_i_22_n_7),
        .I1(\rq_n_reg_n_0_[3] ),
        .I2(h1_reg_0_63_0_2_i_71_n_7),
        .I3(\rq_n_reg_n_0_[5] ),
        .I4(\rq_n_reg_n_0_[4] ),
        .I5(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_219_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 h1_reg_0_63_0_2_i_22
       (.CI(h1_reg_0_63_0_2_i_58_n_0),
        .CO({h1_reg_0_63_0_2_i_22_n_0,h1_reg_0_63_0_2_i_22_n_1,h1_reg_0_63_0_2_i_22_n_2,h1_reg_0_63_0_2_i_22_n_3}),
        .CYINIT(1'b0),
        .DI(rq_half[58:55]),
        .O({h1_reg_0_63_0_2_i_22_n_4,h1_reg_0_63_0_2_i_22_n_5,h1_reg_0_63_0_2_i_22_n_6,h1_reg_0_63_0_2_i_22_n_7}),
        .S({h1_reg_0_63_0_2_i_63_n_0,h1_reg_0_63_0_2_i_64_n_0,h1_reg_0_63_0_2_i_65_n_0,h1_reg_0_63_0_2_i_66_n_0}));
  LUT6 #(
    .INIT(64'hFFFFFFB8000000B8)) 
    h1_reg_0_63_0_2_i_220
       (.I0(h1_reg_0_63_0_2_i_22_n_6),
        .I1(\rq_n_reg_n_0_[3] ),
        .I2(h1_reg_0_63_0_2_i_71_n_6),
        .I3(\rq_n_reg_n_0_[5] ),
        .I4(\rq_n_reg_n_0_[4] ),
        .I5(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_220_n_0));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT4 #(
    .INIT(16'hFE02)) 
    h1_reg_0_63_0_2_i_221
       (.I0(h1_reg_0_63_0_2_i_58_n_5),
        .I1(\rq_n_reg_n_0_[5] ),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_221_n_0));
  LUT5 #(
    .INIT(32'hFFB800B8)) 
    h1_reg_0_63_0_2_i_222
       (.I0(h1_reg_0_63_0_2_i_8_n_5),
        .I1(\rq_n_reg_n_0_[4] ),
        .I2(h1_reg_0_63_0_2_i_77_n_5),
        .I3(\rq_n_reg_n_0_[5] ),
        .I4(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_222_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFB8000000B8)) 
    h1_reg_0_63_0_2_i_223
       (.I0(h1_reg_0_63_0_2_i_58_n_4),
        .I1(\rq_n_reg_n_0_[3] ),
        .I2(h1_reg_0_63_0_2_i_77_n_4),
        .I3(\rq_n_reg_n_0_[5] ),
        .I4(\rq_n_reg_n_0_[4] ),
        .I5(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_223_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 h1_reg_0_63_0_2_i_224
       (.CI(h1_reg_0_63_0_2_i_252_n_0),
        .CO({h1_reg_0_63_0_2_i_224_n_0,h1_reg_0_63_0_2_i_224_n_1,h1_reg_0_63_0_2_i_224_n_2,h1_reg_0_63_0_2_i_224_n_3}),
        .CYINIT(1'b0),
        .DI({h1_reg_0_63_0_2_i_253_n_0,h1_reg_0_63_0_2_i_254_n_0,h1_reg_0_63_0_2_i_255_n_0,h1_reg_0_63_0_2_i_256_n_0}),
        .O(NLW_h1_reg_0_63_0_2_i_224_O_UNCONNECTED[3:0]),
        .S({h1_reg_0_63_0_2_i_257_n_0,h1_reg_0_63_0_2_i_258_n_0,h1_reg_0_63_0_2_i_259_n_0,h1_reg_0_63_0_2_i_260_n_0}));
  LUT6 #(
    .INIT(64'hFFFFEE22FFFFB8B8)) 
    h1_reg_0_63_0_2_i_225
       (.I0(h1_reg_0_63_0_2_i_239_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_261_n_0),
        .I3(h1_reg_0_63_0_2_i_237_n_0),
        .I4(h1_reg_0_63_0_2_i_262_n_0),
        .I5(\rq_n_reg_n_0_[0] ),
        .O(h1_reg_0_63_0_2_i_225_n_0));
  LUT6 #(
    .INIT(64'hFFFFEE22FFFFB8B8)) 
    h1_reg_0_63_0_2_i_226
       (.I0(h1_reg_0_63_0_2_i_261_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_263_n_0),
        .I3(h1_reg_0_63_0_2_i_239_n_0),
        .I4(h1_reg_0_63_0_2_i_264_n_0),
        .I5(\rq_n_reg_n_0_[0] ),
        .O(h1_reg_0_63_0_2_i_226_n_0));
  LUT6 #(
    .INIT(64'hFFB8FFFFFFB8FF00)) 
    h1_reg_0_63_0_2_i_227
       (.I0(h1_reg_0_63_0_2_i_261_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_263_n_0),
        .I3(h1_reg_0_63_0_2_i_265_n_0),
        .I4(\rq_n_reg_n_0_[0] ),
        .I5(h1_reg_0_63_0_2_i_266_n_0),
        .O(h1_reg_0_63_0_2_i_227_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFB8B8FFB8B8)) 
    h1_reg_0_63_0_2_i_228
       (.I0(h1_reg_0_63_0_2_i_267_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_268_n_0),
        .I3(\rq_n_reg_n_0_[0] ),
        .I4(h1_reg_0_63_0_2_i_269_n_0),
        .I5(h1_reg_0_63_0_2_i_266_n_0),
        .O(h1_reg_0_63_0_2_i_228_n_0));
  LUT6 #(
    .INIT(64'h0000000011DD4747)) 
    h1_reg_0_63_0_2_i_229
       (.I0(h1_reg_0_63_0_2_i_239_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_261_n_0),
        .I3(h1_reg_0_63_0_2_i_237_n_0),
        .I4(\rq_n_reg_n_0_[0] ),
        .I5(h1_reg_0_63_0_2_i_262_n_0),
        .O(h1_reg_0_63_0_2_i_229_n_0));
  LUT6 #(
    .INIT(64'h0080000000000000)) 
    h1_reg_0_63_0_2_i_23
       (.I0(\rq_n_reg_n_0_[5] ),
        .I1(\rq_n_reg_n_0_[4] ),
        .I2(\rq_n_reg_n_0_[3] ),
        .I3(\rq_n_reg_n_0_[0] ),
        .I4(\rq_n_reg_n_0_[2] ),
        .I5(\rq_n_reg_n_0_[1] ),
        .O(rq_half[61]));
  LUT6 #(
    .INIT(64'h0000000011DD4747)) 
    h1_reg_0_63_0_2_i_230
       (.I0(h1_reg_0_63_0_2_i_261_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_263_n_0),
        .I3(h1_reg_0_63_0_2_i_239_n_0),
        .I4(\rq_n_reg_n_0_[0] ),
        .I5(h1_reg_0_63_0_2_i_264_n_0),
        .O(h1_reg_0_63_0_2_i_230_n_0));
  LUT6 #(
    .INIT(64'h00000000474700FF)) 
    h1_reg_0_63_0_2_i_231
       (.I0(h1_reg_0_63_0_2_i_261_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_263_n_0),
        .I3(h1_reg_0_63_0_2_i_266_n_0),
        .I4(\rq_n_reg_n_0_[0] ),
        .I5(h1_reg_0_63_0_2_i_265_n_0),
        .O(h1_reg_0_63_0_2_i_231_n_0));
  LUT6 #(
    .INIT(64'h0047004700004747)) 
    h1_reg_0_63_0_2_i_232
       (.I0(h1_reg_0_63_0_2_i_267_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_268_n_0),
        .I3(h1_reg_0_63_0_2_i_266_n_0),
        .I4(h1_reg_0_63_0_2_i_269_n_0),
        .I5(\rq_n_reg_n_0_[0] ),
        .O(h1_reg_0_63_0_2_i_232_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_233
       (.I0(h1_reg_0_63_0_2_i_247_n_0),
        .I1(h1_reg_0_63_0_2_i_248_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_242_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_0_2_i_270_n_0),
        .O(h1_reg_0_63_0_2_i_233_n_0));
  (* SOFT_HLUTNM = "soft_lutpair91" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    h1_reg_0_63_0_2_i_234
       (.I0(h1_reg_0_63_0_2_i_251_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_271_n_0),
        .O(h1_reg_0_63_0_2_i_234_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_235
       (.I0(h1_reg_0_63_0_2_i_222_n_0),
        .I1(h1_reg_0_63_0_2_i_250_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_245_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_0_2_i_272_n_0),
        .O(h1_reg_0_63_0_2_i_235_n_0));
  (* SOFT_HLUTNM = "soft_lutpair91" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    h1_reg_0_63_0_2_i_236
       (.I0(h1_reg_0_63_0_2_i_271_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_273_n_0),
        .O(h1_reg_0_63_0_2_i_236_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_237
       (.I0(h1_reg_0_63_0_2_i_242_n_0),
        .I1(h1_reg_0_63_0_2_i_270_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_248_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_0_2_i_274_n_0),
        .O(h1_reg_0_63_0_2_i_237_n_0));
  (* SOFT_HLUTNM = "soft_lutpair92" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    h1_reg_0_63_0_2_i_238
       (.I0(h1_reg_0_63_0_2_i_273_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_275_n_0),
        .O(h1_reg_0_63_0_2_i_238_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_239
       (.I0(h1_reg_0_63_0_2_i_245_n_0),
        .I1(h1_reg_0_63_0_2_i_272_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_250_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_0_2_i_276_n_0),
        .O(h1_reg_0_63_0_2_i_239_n_0));
  LUT6 #(
    .INIT(64'h0080000000000000)) 
    h1_reg_0_63_0_2_i_24
       (.I0(\rq_n_reg_n_0_[5] ),
        .I1(\rq_n_reg_n_0_[4] ),
        .I2(\rq_n_reg_n_0_[3] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(\rq_n_reg_n_0_[0] ),
        .I5(\rq_n_reg_n_0_[2] ),
        .O(rq_half[60]));
  (* SOFT_HLUTNM = "soft_lutpair92" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    h1_reg_0_63_0_2_i_240
       (.I0(h1_reg_0_63_0_2_i_275_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_277_n_0),
        .O(h1_reg_0_63_0_2_i_240_n_0));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT4 #(
    .INIT(16'hFE02)) 
    h1_reg_0_63_0_2_i_241
       (.I0(h1_reg_0_63_0_2_i_58_n_7),
        .I1(\rq_n_reg_n_0_[5] ),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_241_n_0));
  LUT5 #(
    .INIT(32'hFFB800B8)) 
    h1_reg_0_63_0_2_i_242
       (.I0(h1_reg_0_63_0_2_i_8_n_7),
        .I1(\rq_n_reg_n_0_[4] ),
        .I2(h1_reg_0_63_0_2_i_77_n_7),
        .I3(\rq_n_reg_n_0_[5] ),
        .I4(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_242_n_0));
  LUT5 #(
    .INIT(32'hB8BBB888)) 
    h1_reg_0_63_0_2_i_243
       (.I0(h1_reg_0_63_0_2_i_220_n_0),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(h1_reg_0_63_0_2_i_278_n_0),
        .I3(\rq_n_reg_n_0_[3] ),
        .I4(h1_reg_0_63_0_2_i_279_n_0),
        .O(h1_reg_0_63_0_2_i_243_n_0));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT4 #(
    .INIT(16'hFE02)) 
    h1_reg_0_63_0_2_i_244
       (.I0(h1_reg_0_63_0_2_i_71_n_5),
        .I1(\rq_n_reg_n_0_[5] ),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_244_n_0));
  LUT5 #(
    .INIT(32'hFFB800B8)) 
    h1_reg_0_63_0_2_i_245
       (.I0(h1_reg_0_63_0_2_i_22_n_5),
        .I1(\rq_n_reg_n_0_[4] ),
        .I2(h1_reg_0_63_0_2_i_74_n_5),
        .I3(\rq_n_reg_n_0_[5] ),
        .I4(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_245_n_0));
  LUT5 #(
    .INIT(32'hB8BBB888)) 
    h1_reg_0_63_0_2_i_246
       (.I0(h1_reg_0_63_0_2_i_223_n_0),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(h1_reg_0_63_0_2_i_280_n_0),
        .I3(\rq_n_reg_n_0_[3] ),
        .I4(h1_reg_0_63_0_2_i_281_n_0),
        .O(h1_reg_0_63_0_2_i_246_n_0));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT4 #(
    .INIT(16'hFE02)) 
    h1_reg_0_63_0_2_i_247
       (.I0(h1_reg_0_63_0_2_i_71_n_7),
        .I1(\rq_n_reg_n_0_[5] ),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_247_n_0));
  LUT5 #(
    .INIT(32'hFFB800B8)) 
    h1_reg_0_63_0_2_i_248
       (.I0(h1_reg_0_63_0_2_i_22_n_7),
        .I1(\rq_n_reg_n_0_[4] ),
        .I2(h1_reg_0_63_0_2_i_74_n_7),
        .I3(\rq_n_reg_n_0_[5] ),
        .I4(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_248_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_249
       (.I0(h1_reg_0_63_0_2_i_278_n_0),
        .I1(h1_reg_0_63_0_2_i_279_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_282_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_0_2_i_283_n_0),
        .O(h1_reg_0_63_0_2_i_249_n_0));
  LUT6 #(
    .INIT(64'h0000008000000000)) 
    h1_reg_0_63_0_2_i_25
       (.I0(\rq_n_reg_n_0_[5] ),
        .I1(\rq_n_reg_n_0_[4] ),
        .I2(\rq_n_reg_n_0_[3] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(\rq_n_reg_n_0_[0] ),
        .I5(\rq_n_reg_n_0_[2] ),
        .O(rq_half[59]));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT5 #(
    .INIT(32'hFFB800B8)) 
    h1_reg_0_63_0_2_i_250
       (.I0(h1_reg_0_63_0_2_i_58_n_5),
        .I1(\rq_n_reg_n_0_[4] ),
        .I2(h1_reg_0_63_0_2_i_80_n_5),
        .I3(\rq_n_reg_n_0_[5] ),
        .I4(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_250_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_251
       (.I0(h1_reg_0_63_0_2_i_280_n_0),
        .I1(h1_reg_0_63_0_2_i_281_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_284_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_0_2_i_285_n_0),
        .O(h1_reg_0_63_0_2_i_251_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 h1_reg_0_63_0_2_i_252
       (.CI(1'b0),
        .CO({h1_reg_0_63_0_2_i_252_n_0,h1_reg_0_63_0_2_i_252_n_1,h1_reg_0_63_0_2_i_252_n_2,h1_reg_0_63_0_2_i_252_n_3}),
        .CYINIT(1'b0),
        .DI({h1_reg_0_63_0_2_i_286_n_0,h1_reg_0_63_0_2_i_287_n_0,h1_reg_0_63_0_2_i_288_n_0,h1_reg_0_63_0_2_i_289_n_0}),
        .O(NLW_h1_reg_0_63_0_2_i_252_O_UNCONNECTED[3:0]),
        .S({h1_reg_0_63_0_2_i_290_n_0,h1_reg_0_63_0_2_i_291_n_0,h1_reg_0_63_0_2_i_292_n_0,h1_reg_0_63_0_2_i_293_n_0}));
  LUT6 #(
    .INIT(64'hFFFFFFB8B8FFB8B8)) 
    h1_reg_0_63_0_2_i_253
       (.I0(h1_reg_0_63_0_2_i_268_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_294_n_0),
        .I3(\rq_n_reg_n_0_[0] ),
        .I4(h1_reg_0_63_0_2_i_295_n_0),
        .I5(h1_reg_0_63_0_2_i_269_n_0),
        .O(h1_reg_0_63_0_2_i_253_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFB8B8FFB8B8)) 
    h1_reg_0_63_0_2_i_254
       (.I0(h1_reg_0_63_0_2_i_294_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_296_n_0),
        .I3(\rq_n_reg_n_0_[0] ),
        .I4(h1_reg_0_63_0_2_i_297_n_0),
        .I5(h1_reg_0_63_0_2_i_295_n_0),
        .O(h1_reg_0_63_0_2_i_254_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFB8B8FFB8B8)) 
    h1_reg_0_63_0_2_i_255
       (.I0(h1_reg_0_63_0_2_i_296_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_298_n_0),
        .I3(\rq_n_reg_n_0_[0] ),
        .I4(h1_reg_0_63_0_2_i_299_n_0),
        .I5(h1_reg_0_63_0_2_i_297_n_0),
        .O(h1_reg_0_63_0_2_i_255_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFB8FF00FFB8)) 
    h1_reg_0_63_0_2_i_256
       (.I0(h1_reg_0_63_0_2_i_300_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_301_n_0),
        .I3(h1_reg_0_63_0_2_i_302_n_0),
        .I4(\rq_n_reg_n_0_[0] ),
        .I5(h1_reg_0_63_0_2_i_299_n_0),
        .O(h1_reg_0_63_0_2_i_256_n_0));
  LUT6 #(
    .INIT(64'h0047004700004747)) 
    h1_reg_0_63_0_2_i_257
       (.I0(h1_reg_0_63_0_2_i_268_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_294_n_0),
        .I3(h1_reg_0_63_0_2_i_269_n_0),
        .I4(h1_reg_0_63_0_2_i_295_n_0),
        .I5(\rq_n_reg_n_0_[0] ),
        .O(h1_reg_0_63_0_2_i_257_n_0));
  LUT6 #(
    .INIT(64'h0047004700004747)) 
    h1_reg_0_63_0_2_i_258
       (.I0(h1_reg_0_63_0_2_i_294_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_296_n_0),
        .I3(h1_reg_0_63_0_2_i_295_n_0),
        .I4(h1_reg_0_63_0_2_i_297_n_0),
        .I5(\rq_n_reg_n_0_[0] ),
        .O(h1_reg_0_63_0_2_i_258_n_0));
  LUT6 #(
    .INIT(64'h0047004700004747)) 
    h1_reg_0_63_0_2_i_259
       (.I0(h1_reg_0_63_0_2_i_296_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_298_n_0),
        .I3(h1_reg_0_63_0_2_i_297_n_0),
        .I4(h1_reg_0_63_0_2_i_299_n_0),
        .I5(\rq_n_reg_n_0_[0] ),
        .O(h1_reg_0_63_0_2_i_259_n_0));
  LUT6 #(
    .INIT(64'h7FFFFFFFFFFFFFFF)) 
    h1_reg_0_63_0_2_i_26
       (.I0(\rq_n_reg_n_0_[2] ),
        .I1(\rq_n_reg_n_0_[0] ),
        .I2(\rq_n_reg_n_0_[1] ),
        .I3(\rq_n_reg_n_0_[3] ),
        .I4(\rq_n_reg_n_0_[4] ),
        .I5(\rq_n_reg_n_0_[5] ),
        .O(h1_reg_0_63_0_2_i_26_n_0));
  LUT6 #(
    .INIT(64'h0000000000FF4747)) 
    h1_reg_0_63_0_2_i_260
       (.I0(h1_reg_0_63_0_2_i_300_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_301_n_0),
        .I3(h1_reg_0_63_0_2_i_299_n_0),
        .I4(\rq_n_reg_n_0_[0] ),
        .I5(h1_reg_0_63_0_2_i_302_n_0),
        .O(h1_reg_0_63_0_2_i_260_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_261
       (.I0(h1_reg_0_63_0_2_i_248_n_0),
        .I1(h1_reg_0_63_0_2_i_274_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_270_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_0_2_i_303_n_0),
        .O(h1_reg_0_63_0_2_i_261_n_0));
  (* SOFT_HLUTNM = "soft_lutpair93" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    h1_reg_0_63_0_2_i_262
       (.I0(h1_reg_0_63_0_2_i_277_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_304_n_0),
        .O(h1_reg_0_63_0_2_i_262_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_263
       (.I0(h1_reg_0_63_0_2_i_250_n_0),
        .I1(h1_reg_0_63_0_2_i_276_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_272_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_0_2_i_305_n_0),
        .O(h1_reg_0_63_0_2_i_263_n_0));
  (* SOFT_HLUTNM = "soft_lutpair93" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    h1_reg_0_63_0_2_i_264
       (.I0(h1_reg_0_63_0_2_i_304_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_306_n_0),
        .O(h1_reg_0_63_0_2_i_264_n_0));
  (* SOFT_HLUTNM = "soft_lutpair94" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    h1_reg_0_63_0_2_i_265
       (.I0(h1_reg_0_63_0_2_i_306_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_267_n_0),
        .O(h1_reg_0_63_0_2_i_265_n_0));
  (* SOFT_HLUTNM = "soft_lutpair94" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    h1_reg_0_63_0_2_i_266
       (.I0(h1_reg_0_63_0_2_i_263_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_307_n_0),
        .O(h1_reg_0_63_0_2_i_266_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_267
       (.I0(h1_reg_0_63_0_2_i_308_n_0),
        .I1(h1_reg_0_63_0_2_i_309_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_310_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_0_2_i_311_n_0),
        .O(h1_reg_0_63_0_2_i_267_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_268
       (.I0(h1_reg_0_63_0_2_i_312_n_0),
        .I1(h1_reg_0_63_0_2_i_313_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_314_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_0_2_i_315_n_0),
        .O(h1_reg_0_63_0_2_i_268_n_0));
  (* SOFT_HLUTNM = "soft_lutpair95" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    h1_reg_0_63_0_2_i_269
       (.I0(h1_reg_0_63_0_2_i_307_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_316_n_0),
        .O(h1_reg_0_63_0_2_i_269_n_0));
  LUT5 #(
    .INIT(32'h7FFFFFFF)) 
    h1_reg_0_63_0_2_i_27
       (.I0(\rq_n_reg_n_0_[2] ),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(\rq_n_reg_n_0_[3] ),
        .I3(\rq_n_reg_n_0_[4] ),
        .I4(\rq_n_reg_n_0_[5] ),
        .O(h1_reg_0_63_0_2_i_27_n_0));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT5 #(
    .INIT(32'hFFB800B8)) 
    h1_reg_0_63_0_2_i_270
       (.I0(h1_reg_0_63_0_2_i_58_n_7),
        .I1(\rq_n_reg_n_0_[4] ),
        .I2(h1_reg_0_63_0_2_i_80_n_7),
        .I3(\rq_n_reg_n_0_[5] ),
        .I4(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_270_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_271
       (.I0(h1_reg_0_63_0_2_i_282_n_0),
        .I1(h1_reg_0_63_0_2_i_283_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_279_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_0_2_i_308_n_0),
        .O(h1_reg_0_63_0_2_i_271_n_0));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT5 #(
    .INIT(32'hFFB800B8)) 
    h1_reg_0_63_0_2_i_272
       (.I0(h1_reg_0_63_0_2_i_71_n_5),
        .I1(\rq_n_reg_n_0_[4] ),
        .I2(h1_reg_0_63_0_2_i_70_n_5),
        .I3(\rq_n_reg_n_0_[5] ),
        .I4(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_272_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_273
       (.I0(h1_reg_0_63_0_2_i_284_n_0),
        .I1(h1_reg_0_63_0_2_i_285_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_281_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_0_2_i_312_n_0),
        .O(h1_reg_0_63_0_2_i_273_n_0));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT5 #(
    .INIT(32'hFFB800B8)) 
    h1_reg_0_63_0_2_i_274
       (.I0(h1_reg_0_63_0_2_i_71_n_7),
        .I1(\rq_n_reg_n_0_[4] ),
        .I2(h1_reg_0_63_0_2_i_70_n_7),
        .I3(\rq_n_reg_n_0_[5] ),
        .I4(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_274_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_275
       (.I0(h1_reg_0_63_0_2_i_279_n_0),
        .I1(h1_reg_0_63_0_2_i_308_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_283_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_0_2_i_310_n_0),
        .O(h1_reg_0_63_0_2_i_275_n_0));
  LUT6 #(
    .INIT(64'hCFC0AFAFCFC0A0A0)) 
    h1_reg_0_63_0_2_i_276
       (.I0(h1_reg_0_63_0_2_i_77_n_5),
        .I1(h1_reg_0_63_0_2_i_8_n_4),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_8_n_5),
        .I4(\rq_n_reg_n_0_[5] ),
        .I5(h1_reg_0_63_0_2_i_78_n_5),
        .O(h1_reg_0_63_0_2_i_276_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_277
       (.I0(h1_reg_0_63_0_2_i_281_n_0),
        .I1(h1_reg_0_63_0_2_i_312_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_285_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_0_2_i_314_n_0),
        .O(h1_reg_0_63_0_2_i_277_n_0));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT4 #(
    .INIT(16'hFE02)) 
    h1_reg_0_63_0_2_i_278
       (.I0(h1_reg_0_63_0_2_i_58_n_6),
        .I1(\rq_n_reg_n_0_[5] ),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_278_n_0));
  LUT5 #(
    .INIT(32'hFFB800B8)) 
    h1_reg_0_63_0_2_i_279
       (.I0(h1_reg_0_63_0_2_i_8_n_6),
        .I1(\rq_n_reg_n_0_[4] ),
        .I2(h1_reg_0_63_0_2_i_77_n_6),
        .I3(\rq_n_reg_n_0_[5] ),
        .I4(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_279_n_0));
  LUT6 #(
    .INIT(64'hB7FFFFFFFFFFFFFF)) 
    h1_reg_0_63_0_2_i_28
       (.I0(\rq_n_reg_n_0_[1] ),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(\rq_n_reg_n_0_[3] ),
        .I4(\rq_n_reg_n_0_[4] ),
        .I5(\rq_n_reg_n_0_[5] ),
        .O(h1_reg_0_63_0_2_i_28_n_0));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT4 #(
    .INIT(16'hFE02)) 
    h1_reg_0_63_0_2_i_280
       (.I0(h1_reg_0_63_0_2_i_71_n_4),
        .I1(\rq_n_reg_n_0_[5] ),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_280_n_0));
  LUT5 #(
    .INIT(32'hFFB800B8)) 
    h1_reg_0_63_0_2_i_281
       (.I0(h1_reg_0_63_0_2_i_22_n_4),
        .I1(\rq_n_reg_n_0_[4] ),
        .I2(h1_reg_0_63_0_2_i_74_n_4),
        .I3(\rq_n_reg_n_0_[5] ),
        .I4(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_281_n_0));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT4 #(
    .INIT(16'hFE02)) 
    h1_reg_0_63_0_2_i_282
       (.I0(h1_reg_0_63_0_2_i_71_n_6),
        .I1(\rq_n_reg_n_0_[5] ),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_282_n_0));
  LUT5 #(
    .INIT(32'hFFB800B8)) 
    h1_reg_0_63_0_2_i_283
       (.I0(h1_reg_0_63_0_2_i_22_n_6),
        .I1(\rq_n_reg_n_0_[4] ),
        .I2(h1_reg_0_63_0_2_i_74_n_6),
        .I3(\rq_n_reg_n_0_[5] ),
        .I4(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_283_n_0));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT4 #(
    .INIT(16'hFE02)) 
    h1_reg_0_63_0_2_i_284
       (.I0(h1_reg_0_63_0_2_i_77_n_4),
        .I1(\rq_n_reg_n_0_[5] ),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_284_n_0));
  LUT5 #(
    .INIT(32'hFFB800B8)) 
    h1_reg_0_63_0_2_i_285
       (.I0(h1_reg_0_63_0_2_i_58_n_4),
        .I1(\rq_n_reg_n_0_[4] ),
        .I2(h1_reg_0_63_0_2_i_80_n_4),
        .I3(\rq_n_reg_n_0_[5] ),
        .I4(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_285_n_0));
  LUT6 #(
    .INIT(64'hFFFFEE22FFFFB8B8)) 
    h1_reg_0_63_0_2_i_286
       (.I0(h1_reg_0_63_0_2_i_301_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_317_n_0),
        .I3(h1_reg_0_63_0_2_i_300_n_0),
        .I4(h1_reg_0_63_0_2_i_318_n_0),
        .I5(\rq_n_reg_n_0_[0] ),
        .O(h1_reg_0_63_0_2_i_286_n_0));
  LUT6 #(
    .INIT(64'hFFFFEE22FFFFB8B8)) 
    h1_reg_0_63_0_2_i_287
       (.I0(h1_reg_0_63_0_2_i_317_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_319_n_0),
        .I3(h1_reg_0_63_0_2_i_301_n_0),
        .I4(h1_reg_0_63_0_2_i_320_n_0),
        .I5(\rq_n_reg_n_0_[0] ),
        .O(h1_reg_0_63_0_2_i_287_n_0));
  LUT6 #(
    .INIT(64'hFFFFEE22FFFFB8B8)) 
    h1_reg_0_63_0_2_i_288
       (.I0(h1_reg_0_63_0_2_i_319_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_3_5_i_9_n_0),
        .I3(h1_reg_0_63_0_2_i_317_n_0),
        .I4(h1_reg_0_63_0_2_i_321_n_0),
        .I5(\rq_n_reg_n_0_[0] ),
        .O(h1_reg_0_63_0_2_i_288_n_0));
  LUT5 #(
    .INIT(32'hB8FFB800)) 
    h1_reg_0_63_0_2_i_289
       (.I0(h1_reg_0_63_0_2_i_319_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_3_5_i_9_n_0),
        .I3(\rq_n_reg_n_0_[0] ),
        .I4(h1_reg_0_63_0_2_i_322_n_0),
        .O(h1_reg_0_63_0_2_i_289_n_0));
  LUT5 #(
    .INIT(32'hDFFFFFFF)) 
    h1_reg_0_63_0_2_i_29
       (.I0(\rq_n_reg_n_0_[2] ),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(\rq_n_reg_n_0_[3] ),
        .I3(\rq_n_reg_n_0_[4] ),
        .I4(\rq_n_reg_n_0_[5] ),
        .O(h1_reg_0_63_0_2_i_29_n_0));
  LUT6 #(
    .INIT(64'h0000000011DD4747)) 
    h1_reg_0_63_0_2_i_290
       (.I0(h1_reg_0_63_0_2_i_301_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_317_n_0),
        .I3(h1_reg_0_63_0_2_i_300_n_0),
        .I4(\rq_n_reg_n_0_[0] ),
        .I5(h1_reg_0_63_0_2_i_318_n_0),
        .O(h1_reg_0_63_0_2_i_290_n_0));
  LUT6 #(
    .INIT(64'h0000000011DD4747)) 
    h1_reg_0_63_0_2_i_291
       (.I0(h1_reg_0_63_0_2_i_317_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_319_n_0),
        .I3(h1_reg_0_63_0_2_i_301_n_0),
        .I4(\rq_n_reg_n_0_[0] ),
        .I5(h1_reg_0_63_0_2_i_320_n_0),
        .O(h1_reg_0_63_0_2_i_291_n_0));
  LUT6 #(
    .INIT(64'h0000000011DD4747)) 
    h1_reg_0_63_0_2_i_292
       (.I0(h1_reg_0_63_0_2_i_319_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_3_5_i_9_n_0),
        .I3(h1_reg_0_63_0_2_i_317_n_0),
        .I4(\rq_n_reg_n_0_[0] ),
        .I5(h1_reg_0_63_0_2_i_321_n_0),
        .O(h1_reg_0_63_0_2_i_292_n_0));
  LUT6 #(
    .INIT(64'h474700000000FF00)) 
    h1_reg_0_63_0_2_i_293
       (.I0(h1_reg_0_63_0_2_i_319_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_3_5_i_9_n_0),
        .I3(h1_reg_0_63_3_5_i_6_n_0),
        .I4(h1_reg_0_63_0_2_i_322_n_0),
        .I5(\rq_n_reg_n_0_[0] ),
        .O(h1_reg_0_63_0_2_i_293_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_294
       (.I0(h1_reg_0_63_0_2_i_310_n_0),
        .I1(h1_reg_0_63_0_2_i_311_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_309_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_6_7_i_4_n_0),
        .O(h1_reg_0_63_0_2_i_294_n_0));
  (* SOFT_HLUTNM = "soft_lutpair95" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    h1_reg_0_63_0_2_i_295
       (.I0(h1_reg_0_63_0_2_i_316_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_323_n_0),
        .O(h1_reg_0_63_0_2_i_295_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_296
       (.I0(h1_reg_0_63_0_2_i_314_n_0),
        .I1(h1_reg_0_63_0_2_i_315_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_313_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_3_5_i_11_n_0),
        .O(h1_reg_0_63_0_2_i_296_n_0));
  (* SOFT_HLUTNM = "soft_lutpair96" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    h1_reg_0_63_0_2_i_297
       (.I0(h1_reg_0_63_0_2_i_323_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_324_n_0),
        .O(h1_reg_0_63_0_2_i_297_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_298
       (.I0(h1_reg_0_63_0_2_i_309_n_0),
        .I1(h1_reg_0_63_6_7_i_4_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_311_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_0_2_i_68_n_0),
        .O(h1_reg_0_63_0_2_i_298_n_0));
  (* SOFT_HLUTNM = "soft_lutpair96" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    h1_reg_0_63_0_2_i_299
       (.I0(h1_reg_0_63_0_2_i_324_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_300_n_0),
        .O(h1_reg_0_63_0_2_i_299_n_0));
  LUT5 #(
    .INIT(32'h0000FFB8)) 
    h1_reg_0_63_0_2_i_3
       (.I0(h1_reg_0_63_0_2_i_10_n_0),
        .I1(\rq_n_reg_n_0_[0] ),
        .I2(h1_reg_0_63_0_2_i_9_n_0),
        .I3(h1_reg_0_63_0_2_i_6_n_3),
        .I4(h1_reg_0_63_0_2_i_8_n_4),
        .O(hidden_activation[2]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_30
       (.I0(h1_reg_0_63_0_2_i_67_n_0),
        .I1(h1_reg_0_63_0_2_i_54_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_56_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_0_2_i_57_n_0),
        .O(h1_reg_0_63_0_2_i_30_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_300
       (.I0(h1_reg_0_63_0_2_i_303_n_0),
        .I1(h1_reg_0_63_3_5_i_12_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_325_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_0_2_i_67_n_0),
        .O(h1_reg_0_63_0_2_i_300_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_301
       (.I0(h1_reg_0_63_0_2_i_305_n_0),
        .I1(h1_reg_0_63_3_5_i_10_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_326_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_0_2_i_52_n_0),
        .O(h1_reg_0_63_0_2_i_301_n_0));
  (* SOFT_HLUTNM = "soft_lutpair87" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    h1_reg_0_63_0_2_i_302
       (.I0(h1_reg_0_63_0_2_i_298_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_327_n_0),
        .O(h1_reg_0_63_0_2_i_302_n_0));
  LUT6 #(
    .INIT(64'hCFC0AFAFCFC0A0A0)) 
    h1_reg_0_63_0_2_i_303
       (.I0(h1_reg_0_63_0_2_i_77_n_7),
        .I1(h1_reg_0_63_0_2_i_8_n_4),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_8_n_7),
        .I4(\rq_n_reg_n_0_[5] ),
        .I5(h1_reg_0_63_0_2_i_78_n_7),
        .O(h1_reg_0_63_0_2_i_303_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_304
       (.I0(h1_reg_0_63_0_2_i_283_n_0),
        .I1(h1_reg_0_63_0_2_i_310_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_308_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_0_2_i_309_n_0),
        .O(h1_reg_0_63_0_2_i_304_n_0));
  LUT6 #(
    .INIT(64'hCFC0AFAFCFC0A0A0)) 
    h1_reg_0_63_0_2_i_305
       (.I0(h1_reg_0_63_0_2_i_74_n_5),
        .I1(h1_reg_0_63_0_2_i_8_n_4),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_22_n_5),
        .I4(\rq_n_reg_n_0_[5] ),
        .I5(h1_reg_0_63_0_2_i_75_n_5),
        .O(h1_reg_0_63_0_2_i_305_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_306
       (.I0(h1_reg_0_63_0_2_i_285_n_0),
        .I1(h1_reg_0_63_0_2_i_314_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_312_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_0_2_i_313_n_0),
        .O(h1_reg_0_63_0_2_i_306_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_307
       (.I0(h1_reg_0_63_0_2_i_270_n_0),
        .I1(h1_reg_0_63_0_2_i_303_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_274_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_0_2_i_325_n_0),
        .O(h1_reg_0_63_0_2_i_307_n_0));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT5 #(
    .INIT(32'hFFB800B8)) 
    h1_reg_0_63_0_2_i_308
       (.I0(h1_reg_0_63_0_2_i_58_n_6),
        .I1(\rq_n_reg_n_0_[4] ),
        .I2(h1_reg_0_63_0_2_i_80_n_6),
        .I3(\rq_n_reg_n_0_[5] ),
        .I4(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_308_n_0));
  LUT6 #(
    .INIT(64'hCFC0AFAFCFC0A0A0)) 
    h1_reg_0_63_0_2_i_309
       (.I0(h1_reg_0_63_0_2_i_77_n_6),
        .I1(h1_reg_0_63_0_2_i_8_n_4),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_8_n_6),
        .I4(\rq_n_reg_n_0_[5] ),
        .I5(h1_reg_0_63_0_2_i_78_n_6),
        .O(h1_reg_0_63_0_2_i_309_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_31
       (.I0(h1_reg_0_63_0_2_i_68_n_0),
        .I1(h1_reg_0_63_0_2_i_36_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_38_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_0_2_i_39_n_0),
        .O(h1_reg_0_63_0_2_i_31_n_0));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT5 #(
    .INIT(32'hFFB800B8)) 
    h1_reg_0_63_0_2_i_310
       (.I0(h1_reg_0_63_0_2_i_71_n_6),
        .I1(\rq_n_reg_n_0_[4] ),
        .I2(h1_reg_0_63_0_2_i_70_n_6),
        .I3(\rq_n_reg_n_0_[5] ),
        .I4(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_310_n_0));
  LUT6 #(
    .INIT(64'hCFC0AFAFCFC0A0A0)) 
    h1_reg_0_63_0_2_i_311
       (.I0(h1_reg_0_63_0_2_i_74_n_6),
        .I1(h1_reg_0_63_0_2_i_8_n_4),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_22_n_6),
        .I4(\rq_n_reg_n_0_[5] ),
        .I5(h1_reg_0_63_0_2_i_75_n_6),
        .O(h1_reg_0_63_0_2_i_311_n_0));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT5 #(
    .INIT(32'hFFB800B8)) 
    h1_reg_0_63_0_2_i_312
       (.I0(h1_reg_0_63_0_2_i_71_n_4),
        .I1(\rq_n_reg_n_0_[4] ),
        .I2(h1_reg_0_63_0_2_i_70_n_4),
        .I3(\rq_n_reg_n_0_[5] ),
        .I4(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_312_n_0));
  LUT6 #(
    .INIT(64'hCFC0AFAFCFC0A0A0)) 
    h1_reg_0_63_0_2_i_313
       (.I0(h1_reg_0_63_0_2_i_74_n_4),
        .I1(h1_reg_0_63_0_2_i_8_n_4),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_22_n_4),
        .I4(\rq_n_reg_n_0_[5] ),
        .I5(h1_reg_0_63_0_2_i_75_n_4),
        .O(h1_reg_0_63_0_2_i_313_n_0));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT5 #(
    .INIT(32'hFFB800B8)) 
    h1_reg_0_63_0_2_i_314
       (.I0(h1_reg_0_63_0_2_i_77_n_4),
        .I1(\rq_n_reg_n_0_[4] ),
        .I2(h1_reg_0_63_0_2_i_78_n_4),
        .I3(\rq_n_reg_n_0_[5] ),
        .I4(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_314_n_0));
  LUT6 #(
    .INIT(64'hCFC0AFAFCFC0A0A0)) 
    h1_reg_0_63_0_2_i_315
       (.I0(h1_reg_0_63_0_2_i_80_n_4),
        .I1(h1_reg_0_63_0_2_i_8_n_4),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_58_n_4),
        .I4(\rq_n_reg_n_0_[5] ),
        .I5(h1_reg_0_63_0_2_i_81_n_4),
        .O(h1_reg_0_63_0_2_i_315_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_316
       (.I0(h1_reg_0_63_0_2_i_272_n_0),
        .I1(h1_reg_0_63_0_2_i_305_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_276_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_0_2_i_326_n_0),
        .O(h1_reg_0_63_0_2_i_316_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_317
       (.I0(h1_reg_0_63_0_2_i_325_n_0),
        .I1(h1_reg_0_63_0_2_i_67_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_3_5_i_12_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_0_2_i_56_n_0),
        .O(h1_reg_0_63_0_2_i_317_n_0));
  (* SOFT_HLUTNM = "soft_lutpair85" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    h1_reg_0_63_0_2_i_318
       (.I0(h1_reg_0_63_0_2_i_327_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_328_n_0),
        .O(h1_reg_0_63_0_2_i_318_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_319
       (.I0(h1_reg_0_63_0_2_i_326_n_0),
        .I1(h1_reg_0_63_0_2_i_52_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_3_5_i_10_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_0_2_i_51_n_0),
        .O(h1_reg_0_63_0_2_i_319_n_0));
  LUT6 #(
    .INIT(64'hFC0CFAFAFC0C0A0A)) 
    h1_reg_0_63_0_2_i_32
       (.I0(h1_reg_0_63_0_2_i_69_n_4),
        .I1(h1_reg_0_63_0_2_i_70_n_4),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_71_n_4),
        .I4(\rq_n_reg_n_0_[5] ),
        .I5(h1_reg_0_63_0_2_i_72_n_4),
        .O(h1_reg_0_63_0_2_i_32_n_0));
  (* SOFT_HLUTNM = "soft_lutpair86" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    h1_reg_0_63_0_2_i_320
       (.I0(h1_reg_0_63_0_2_i_328_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_329_n_0),
        .O(h1_reg_0_63_0_2_i_320_n_0));
  (* SOFT_HLUTNM = "soft_lutpair86" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    h1_reg_0_63_0_2_i_321
       (.I0(h1_reg_0_63_0_2_i_329_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_6_7_i_3_n_0),
        .O(h1_reg_0_63_0_2_i_321_n_0));
  (* SOFT_HLUTNM = "soft_lutpair87" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    h1_reg_0_63_0_2_i_322
       (.I0(h1_reg_0_63_6_7_i_3_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_3_5_i_8_n_0),
        .O(h1_reg_0_63_0_2_i_322_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_323
       (.I0(h1_reg_0_63_0_2_i_274_n_0),
        .I1(h1_reg_0_63_0_2_i_325_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_303_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_3_5_i_12_n_0),
        .O(h1_reg_0_63_0_2_i_323_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_324
       (.I0(h1_reg_0_63_0_2_i_276_n_0),
        .I1(h1_reg_0_63_0_2_i_326_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_305_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_3_5_i_10_n_0),
        .O(h1_reg_0_63_0_2_i_324_n_0));
  LUT6 #(
    .INIT(64'hCFC0AFAFCFC0A0A0)) 
    h1_reg_0_63_0_2_i_325
       (.I0(h1_reg_0_63_0_2_i_74_n_7),
        .I1(h1_reg_0_63_0_2_i_8_n_4),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_22_n_7),
        .I4(\rq_n_reg_n_0_[5] ),
        .I5(h1_reg_0_63_0_2_i_75_n_7),
        .O(h1_reg_0_63_0_2_i_325_n_0));
  LUT6 #(
    .INIT(64'hCFC0AFAFCFC0A0A0)) 
    h1_reg_0_63_0_2_i_326
       (.I0(h1_reg_0_63_0_2_i_80_n_5),
        .I1(h1_reg_0_63_0_2_i_8_n_4),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_58_n_5),
        .I4(\rq_n_reg_n_0_[5] ),
        .I5(h1_reg_0_63_0_2_i_81_n_5),
        .O(h1_reg_0_63_0_2_i_326_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_327
       (.I0(h1_reg_0_63_0_2_i_313_n_0),
        .I1(h1_reg_0_63_3_5_i_11_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_315_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_0_2_i_34_n_0),
        .O(h1_reg_0_63_0_2_i_327_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_328
       (.I0(h1_reg_0_63_0_2_i_311_n_0),
        .I1(h1_reg_0_63_0_2_i_68_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_6_7_i_4_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_0_2_i_38_n_0),
        .O(h1_reg_0_63_0_2_i_328_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_329
       (.I0(h1_reg_0_63_0_2_i_315_n_0),
        .I1(h1_reg_0_63_0_2_i_34_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_3_5_i_11_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_0_2_i_33_n_0),
        .O(h1_reg_0_63_0_2_i_329_n_0));
  LUT6 #(
    .INIT(64'hFC0CFAFAFC0C0A0A)) 
    h1_reg_0_63_0_2_i_33
       (.I0(h1_reg_0_63_0_2_i_73_n_4),
        .I1(h1_reg_0_63_0_2_i_74_n_4),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_22_n_4),
        .I4(\rq_n_reg_n_0_[5] ),
        .I5(h1_reg_0_63_0_2_i_75_n_4),
        .O(h1_reg_0_63_0_2_i_33_n_0));
  LUT6 #(
    .INIT(64'hFCFCFA0A0C0CFA0A)) 
    h1_reg_0_63_0_2_i_34
       (.I0(h1_reg_0_63_0_2_i_76_n_4),
        .I1(h1_reg_0_63_0_2_i_77_n_4),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_78_n_4),
        .I4(\rq_n_reg_n_0_[5] ),
        .I5(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_34_n_0));
  LUT6 #(
    .INIT(64'hFC0CFAFAFC0C0A0A)) 
    h1_reg_0_63_0_2_i_35
       (.I0(h1_reg_0_63_0_2_i_79_n_4),
        .I1(h1_reg_0_63_0_2_i_80_n_4),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_58_n_4),
        .I4(\rq_n_reg_n_0_[5] ),
        .I5(h1_reg_0_63_0_2_i_81_n_4),
        .O(h1_reg_0_63_0_2_i_35_n_0));
  LUT6 #(
    .INIT(64'hFC0CFAFAFC0C0A0A)) 
    h1_reg_0_63_0_2_i_36
       (.I0(h1_reg_0_63_0_2_i_73_n_6),
        .I1(h1_reg_0_63_0_2_i_74_n_6),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_22_n_6),
        .I4(\rq_n_reg_n_0_[5] ),
        .I5(h1_reg_0_63_0_2_i_75_n_6),
        .O(h1_reg_0_63_0_2_i_36_n_0));
  LUT6 #(
    .INIT(64'hFC0CFAFAFC0C0A0A)) 
    h1_reg_0_63_0_2_i_37
       (.I0(h1_reg_0_63_0_2_i_69_n_6),
        .I1(h1_reg_0_63_0_2_i_70_n_6),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_71_n_6),
        .I4(\rq_n_reg_n_0_[5] ),
        .I5(h1_reg_0_63_0_2_i_72_n_6),
        .O(h1_reg_0_63_0_2_i_37_n_0));
  LUT6 #(
    .INIT(64'hFC0CFAFAFC0C0A0A)) 
    h1_reg_0_63_0_2_i_38
       (.I0(h1_reg_0_63_0_2_i_76_n_6),
        .I1(h1_reg_0_63_0_2_i_77_n_6),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_8_n_6),
        .I4(\rq_n_reg_n_0_[5] ),
        .I5(h1_reg_0_63_0_2_i_78_n_6),
        .O(h1_reg_0_63_0_2_i_38_n_0));
  LUT6 #(
    .INIT(64'hFC0CFAFAFC0C0A0A)) 
    h1_reg_0_63_0_2_i_39
       (.I0(h1_reg_0_63_0_2_i_79_n_6),
        .I1(h1_reg_0_63_0_2_i_80_n_6),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_58_n_6),
        .I4(\rq_n_reg_n_0_[5] ),
        .I5(h1_reg_0_63_0_2_i_81_n_6),
        .O(h1_reg_0_63_0_2_i_39_n_0));
  LUT6 #(
    .INIT(64'h2000000000000000)) 
    h1_reg_0_63_0_2_i_4
       (.I0(h1_reg_0_63_0_2_i_11_n_0),
        .I1(state[4]),
        .I2(h1_reg_0_63_0_2_i_12_n_0),
        .I3(state[3]),
        .I4(state[2]),
        .I5(rst_n),
        .O(h1_reg_0_63_0_2_i_4_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 h1_reg_0_63_0_2_i_40
       (.CI(h1_reg_0_63_0_2_i_82_n_0),
        .CO({h1_reg_0_63_0_2_i_40_n_0,h1_reg_0_63_0_2_i_40_n_1,h1_reg_0_63_0_2_i_40_n_2,h1_reg_0_63_0_2_i_40_n_3}),
        .CYINIT(1'b0),
        .DI({h1_reg_0_63_0_2_i_83_n_0,h1_reg_0_63_0_2_i_84_n_0,h1_reg_0_63_0_2_i_85_n_0,h1_reg_0_63_0_2_i_86_n_0}),
        .O(NLW_h1_reg_0_63_0_2_i_40_O_UNCONNECTED[3:0]),
        .S({h1_reg_0_63_0_2_i_87_n_0,h1_reg_0_63_0_2_i_88_n_0,h1_reg_0_63_0_2_i_89_n_0,h1_reg_0_63_0_2_i_90_n_0}));
  LUT6 #(
    .INIT(64'hFFFFFCEE33F330E2)) 
    h1_reg_0_63_0_2_i_41
       (.I0(h1_reg_0_63_0_2_i_91_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_49_n_0),
        .I3(\rq_n_reg_n_0_[0] ),
        .I4(h1_reg_0_63_0_2_i_92_n_0),
        .I5(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_41_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFFAFA0FC0C)) 
    h1_reg_0_63_0_2_i_42
       (.I0(h1_reg_0_63_0_2_i_49_n_0),
        .I1(h1_reg_0_63_0_2_i_93_n_0),
        .I2(\rq_n_reg_n_0_[1] ),
        .I3(h1_reg_0_63_0_2_i_91_n_0),
        .I4(\rq_n_reg_n_0_[0] ),
        .I5(h1_reg_0_63_0_2_i_94_n_0),
        .O(h1_reg_0_63_0_2_i_42_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFFAFA0FC0C)) 
    h1_reg_0_63_0_2_i_43
       (.I0(h1_reg_0_63_0_2_i_91_n_0),
        .I1(h1_reg_0_63_0_2_i_95_n_0),
        .I2(\rq_n_reg_n_0_[1] ),
        .I3(h1_reg_0_63_0_2_i_93_n_0),
        .I4(\rq_n_reg_n_0_[0] ),
        .I5(h1_reg_0_63_0_2_i_96_n_0),
        .O(h1_reg_0_63_0_2_i_43_n_0));
  LUT4 #(
    .INIT(16'hFFAC)) 
    h1_reg_0_63_0_2_i_44
       (.I0(h1_reg_0_63_0_2_i_97_n_0),
        .I1(h1_reg_0_63_0_2_i_98_n_0),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(h1_reg_0_63_0_2_i_99_n_0),
        .O(h1_reg_0_63_0_2_i_44_n_0));
  LUT6 #(
    .INIT(64'h00000311CC0CCF1D)) 
    h1_reg_0_63_0_2_i_45
       (.I0(h1_reg_0_63_0_2_i_91_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_49_n_0),
        .I3(\rq_n_reg_n_0_[0] ),
        .I4(h1_reg_0_63_0_2_i_92_n_0),
        .I5(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_45_n_0));
  LUT6 #(
    .INIT(64'h00000000505F03F3)) 
    h1_reg_0_63_0_2_i_46
       (.I0(h1_reg_0_63_0_2_i_49_n_0),
        .I1(h1_reg_0_63_0_2_i_93_n_0),
        .I2(\rq_n_reg_n_0_[1] ),
        .I3(h1_reg_0_63_0_2_i_91_n_0),
        .I4(\rq_n_reg_n_0_[0] ),
        .I5(h1_reg_0_63_0_2_i_94_n_0),
        .O(h1_reg_0_63_0_2_i_46_n_0));
  LUT6 #(
    .INIT(64'h00000000505F03F3)) 
    h1_reg_0_63_0_2_i_47
       (.I0(h1_reg_0_63_0_2_i_91_n_0),
        .I1(h1_reg_0_63_0_2_i_95_n_0),
        .I2(\rq_n_reg_n_0_[1] ),
        .I3(h1_reg_0_63_0_2_i_93_n_0),
        .I4(\rq_n_reg_n_0_[0] ),
        .I5(h1_reg_0_63_0_2_i_96_n_0),
        .O(h1_reg_0_63_0_2_i_47_n_0));
  LUT4 #(
    .INIT(16'h0053)) 
    h1_reg_0_63_0_2_i_48
       (.I0(h1_reg_0_63_0_2_i_97_n_0),
        .I1(h1_reg_0_63_0_2_i_98_n_0),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(h1_reg_0_63_0_2_i_99_n_0),
        .O(h1_reg_0_63_0_2_i_48_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFE00000002)) 
    h1_reg_0_63_0_2_i_49
       (.I0(h1_reg_0_63_0_2_i_8_n_5),
        .I1(\rq_n_reg_n_0_[5] ),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(\rq_n_reg_n_0_[3] ),
        .I4(\rq_n_reg_n_0_[2] ),
        .I5(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_49_n_0));
  LUT5 #(
    .INIT(32'hBBB8B8B8)) 
    h1_reg_0_63_0_2_i_5
       (.I0(h1_reg_0_63_0_2_i_13_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_14_n_0),
        .I3(\rq_n_reg_n_0_[2] ),
        .I4(h1_reg_0_63_0_2_i_15_n_0),
        .O(h1_reg_0_63_0_2_i_5_n_0));
  LUT6 #(
    .INIT(64'hFC0CFAFAFC0C0A0A)) 
    h1_reg_0_63_0_2_i_50
       (.I0(h1_reg_0_63_0_2_i_69_n_5),
        .I1(h1_reg_0_63_0_2_i_70_n_5),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_71_n_5),
        .I4(\rq_n_reg_n_0_[5] ),
        .I5(h1_reg_0_63_0_2_i_72_n_5),
        .O(h1_reg_0_63_0_2_i_50_n_0));
  LUT6 #(
    .INIT(64'hFC0CFAFAFC0C0A0A)) 
    h1_reg_0_63_0_2_i_51
       (.I0(h1_reg_0_63_0_2_i_73_n_5),
        .I1(h1_reg_0_63_0_2_i_74_n_5),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_22_n_5),
        .I4(\rq_n_reg_n_0_[5] ),
        .I5(h1_reg_0_63_0_2_i_75_n_5),
        .O(h1_reg_0_63_0_2_i_51_n_0));
  LUT6 #(
    .INIT(64'hFC0CFAFAFC0C0A0A)) 
    h1_reg_0_63_0_2_i_52
       (.I0(h1_reg_0_63_0_2_i_76_n_5),
        .I1(h1_reg_0_63_0_2_i_77_n_5),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_8_n_5),
        .I4(\rq_n_reg_n_0_[5] ),
        .I5(h1_reg_0_63_0_2_i_78_n_5),
        .O(h1_reg_0_63_0_2_i_52_n_0));
  LUT6 #(
    .INIT(64'hFC0CFAFAFC0C0A0A)) 
    h1_reg_0_63_0_2_i_53
       (.I0(h1_reg_0_63_0_2_i_79_n_5),
        .I1(h1_reg_0_63_0_2_i_80_n_5),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_58_n_5),
        .I4(\rq_n_reg_n_0_[5] ),
        .I5(h1_reg_0_63_0_2_i_81_n_5),
        .O(h1_reg_0_63_0_2_i_53_n_0));
  LUT6 #(
    .INIT(64'hFC0CFAFAFC0C0A0A)) 
    h1_reg_0_63_0_2_i_54
       (.I0(h1_reg_0_63_0_2_i_73_n_7),
        .I1(h1_reg_0_63_0_2_i_74_n_7),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_22_n_7),
        .I4(\rq_n_reg_n_0_[5] ),
        .I5(h1_reg_0_63_0_2_i_75_n_7),
        .O(h1_reg_0_63_0_2_i_54_n_0));
  LUT6 #(
    .INIT(64'hFC0CFAFAFC0C0A0A)) 
    h1_reg_0_63_0_2_i_55
       (.I0(h1_reg_0_63_0_2_i_69_n_7),
        .I1(h1_reg_0_63_0_2_i_70_n_7),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_71_n_7),
        .I4(\rq_n_reg_n_0_[5] ),
        .I5(h1_reg_0_63_0_2_i_72_n_7),
        .O(h1_reg_0_63_0_2_i_55_n_0));
  LUT6 #(
    .INIT(64'hFC0CFAFAFC0C0A0A)) 
    h1_reg_0_63_0_2_i_56
       (.I0(h1_reg_0_63_0_2_i_76_n_7),
        .I1(h1_reg_0_63_0_2_i_77_n_7),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_8_n_7),
        .I4(\rq_n_reg_n_0_[5] ),
        .I5(h1_reg_0_63_0_2_i_78_n_7),
        .O(h1_reg_0_63_0_2_i_56_n_0));
  LUT6 #(
    .INIT(64'hFC0CFAFAFC0C0A0A)) 
    h1_reg_0_63_0_2_i_57
       (.I0(h1_reg_0_63_0_2_i_79_n_7),
        .I1(h1_reg_0_63_0_2_i_80_n_7),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_58_n_7),
        .I4(\rq_n_reg_n_0_[5] ),
        .I5(h1_reg_0_63_0_2_i_81_n_7),
        .O(h1_reg_0_63_0_2_i_57_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 h1_reg_0_63_0_2_i_58
       (.CI(h1_reg_0_63_0_2_i_71_n_0),
        .CO({h1_reg_0_63_0_2_i_58_n_0,h1_reg_0_63_0_2_i_58_n_1,h1_reg_0_63_0_2_i_58_n_2,h1_reg_0_63_0_2_i_58_n_3}),
        .CYINIT(1'b0),
        .DI(rq_half[54:51]),
        .O({h1_reg_0_63_0_2_i_58_n_4,h1_reg_0_63_0_2_i_58_n_5,h1_reg_0_63_0_2_i_58_n_6,h1_reg_0_63_0_2_i_58_n_7}),
        .S({h1_reg_0_63_0_2_i_104_n_0,h1_reg_0_63_0_2_i_105_n_0,h1_reg_0_63_0_2_i_106_n_0,h1_reg_0_63_0_2_i_107_n_0}));
  LUT6 #(
    .INIT(64'h0000000080000000)) 
    h1_reg_0_63_0_2_i_59
       (.I0(\rq_n_reg_n_0_[5] ),
        .I1(\rq_n_reg_n_0_[4] ),
        .I2(\rq_n_reg_n_0_[3] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(\rq_n_reg_n_0_[0] ),
        .I5(\rq_n_reg_n_0_[2] ),
        .O(rq_half[58]));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 h1_reg_0_63_0_2_i_6
       (.CI(h1_reg_0_63_0_2_i_16_n_0),
        .CO({NLW_h1_reg_0_63_0_2_i_6_CO_UNCONNECTED[3:1],h1_reg_0_63_0_2_i_6_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,h1_reg_0_63_0_2_i_17_n_0}),
        .O(NLW_h1_reg_0_63_0_2_i_6_O_UNCONNECTED[3:0]),
        .S({1'b0,1'b0,1'b0,h1_reg_0_63_0_2_i_18_n_0}));
  LUT6 #(
    .INIT(64'h0000000000008000)) 
    h1_reg_0_63_0_2_i_60
       (.I0(\rq_n_reg_n_0_[5] ),
        .I1(\rq_n_reg_n_0_[4] ),
        .I2(\rq_n_reg_n_0_[3] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(\rq_n_reg_n_0_[0] ),
        .I5(\rq_n_reg_n_0_[2] ),
        .O(rq_half[57]));
  LUT6 #(
    .INIT(64'h0000000000800000)) 
    h1_reg_0_63_0_2_i_61
       (.I0(\rq_n_reg_n_0_[5] ),
        .I1(\rq_n_reg_n_0_[4] ),
        .I2(\rq_n_reg_n_0_[3] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(\rq_n_reg_n_0_[0] ),
        .I5(\rq_n_reg_n_0_[2] ),
        .O(rq_half[56]));
  LUT6 #(
    .INIT(64'h0000000000000080)) 
    h1_reg_0_63_0_2_i_62
       (.I0(\rq_n_reg_n_0_[5] ),
        .I1(\rq_n_reg_n_0_[4] ),
        .I2(\rq_n_reg_n_0_[3] ),
        .I3(\rq_n_reg_n_0_[1] ),
        .I4(\rq_n_reg_n_0_[0] ),
        .I5(\rq_n_reg_n_0_[2] ),
        .O(rq_half[55]));
  LUT6 #(
    .INIT(64'hBDFFFFFFFFFFFFFF)) 
    h1_reg_0_63_0_2_i_63
       (.I0(\rq_n_reg_n_0_[2] ),
        .I1(\rq_n_reg_n_0_[0] ),
        .I2(\rq_n_reg_n_0_[1] ),
        .I3(\rq_n_reg_n_0_[3] ),
        .I4(\rq_n_reg_n_0_[4] ),
        .I5(\rq_n_reg_n_0_[5] ),
        .O(h1_reg_0_63_0_2_i_63_n_0));
  LUT5 #(
    .INIT(32'hBFFFFFFF)) 
    h1_reg_0_63_0_2_i_64
       (.I0(\rq_n_reg_n_0_[2] ),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(\rq_n_reg_n_0_[3] ),
        .I3(\rq_n_reg_n_0_[4] ),
        .I4(\rq_n_reg_n_0_[5] ),
        .O(h1_reg_0_63_0_2_i_64_n_0));
  LUT6 #(
    .INIT(64'hEBFFFFFFFFFFFFFF)) 
    h1_reg_0_63_0_2_i_65
       (.I0(\rq_n_reg_n_0_[2] ),
        .I1(\rq_n_reg_n_0_[0] ),
        .I2(\rq_n_reg_n_0_[1] ),
        .I3(\rq_n_reg_n_0_[3] ),
        .I4(\rq_n_reg_n_0_[4] ),
        .I5(\rq_n_reg_n_0_[5] ),
        .O(h1_reg_0_63_0_2_i_65_n_0));
  LUT5 #(
    .INIT(32'hEFFFFFFF)) 
    h1_reg_0_63_0_2_i_66
       (.I0(\rq_n_reg_n_0_[2] ),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(\rq_n_reg_n_0_[3] ),
        .I3(\rq_n_reg_n_0_[4] ),
        .I4(\rq_n_reg_n_0_[5] ),
        .O(h1_reg_0_63_0_2_i_66_n_0));
  LUT6 #(
    .INIT(64'hCFC0AFAFCFC0A0A0)) 
    h1_reg_0_63_0_2_i_67
       (.I0(h1_reg_0_63_0_2_i_70_n_7),
        .I1(h1_reg_0_63_0_2_i_8_n_4),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_71_n_7),
        .I4(\rq_n_reg_n_0_[5] ),
        .I5(h1_reg_0_63_0_2_i_72_n_7),
        .O(h1_reg_0_63_0_2_i_67_n_0));
  LUT6 #(
    .INIT(64'hCFC0AFAFCFC0A0A0)) 
    h1_reg_0_63_0_2_i_68
       (.I0(h1_reg_0_63_0_2_i_70_n_6),
        .I1(h1_reg_0_63_0_2_i_8_n_4),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_71_n_6),
        .I4(\rq_n_reg_n_0_[5] ),
        .I5(h1_reg_0_63_0_2_i_72_n_6),
        .O(h1_reg_0_63_0_2_i_68_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 h1_reg_0_63_0_2_i_69
       (.CI(1'b0),
        .CO({h1_reg_0_63_0_2_i_69_n_0,h1_reg_0_63_0_2_i_69_n_1,h1_reg_0_63_0_2_i_69_n_2,h1_reg_0_63_0_2_i_69_n_3}),
        .CYINIT(1'b0),
        .DI(rq_prod_reg__0[3:0]),
        .O({h1_reg_0_63_0_2_i_69_n_4,h1_reg_0_63_0_2_i_69_n_5,h1_reg_0_63_0_2_i_69_n_6,h1_reg_0_63_0_2_i_69_n_7}),
        .S({h1_reg_0_63_0_2_i_108_n_0,h1_reg_0_63_0_2_i_109_n_0,h1_reg_0_63_0_2_i_110_n_0,h1_reg_0_63_0_2_i_111_n_0}));
  LUT6 #(
    .INIT(64'h2323232023202320)) 
    h1_reg_0_63_0_2_i_7
       (.I0(h1_reg_0_63_0_2_i_19_n_0),
        .I1(\rq_n_reg_n_0_[0] ),
        .I2(\rq_n_reg_n_0_[1] ),
        .I3(h1_reg_0_63_0_2_i_20_n_0),
        .I4(\rq_n_reg_n_0_[2] ),
        .I5(h1_reg_0_63_0_2_i_21_n_0),
        .O(h1_reg_0_63_0_2_i_7_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 h1_reg_0_63_0_2_i_70
       (.CI(h1_reg_0_63_0_2_i_78_n_0),
        .CO({h1_reg_0_63_0_2_i_70_n_0,h1_reg_0_63_0_2_i_70_n_1,h1_reg_0_63_0_2_i_70_n_2,h1_reg_0_63_0_2_i_70_n_3}),
        .CYINIT(1'b0),
        .DI(rq_prod_reg__0[35:32]),
        .O({h1_reg_0_63_0_2_i_70_n_4,h1_reg_0_63_0_2_i_70_n_5,h1_reg_0_63_0_2_i_70_n_6,h1_reg_0_63_0_2_i_70_n_7}),
        .S({h1_reg_0_63_0_2_i_112_n_0,h1_reg_0_63_0_2_i_113_n_0,h1_reg_0_63_0_2_i_114_n_0,h1_reg_0_63_0_2_i_115_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 h1_reg_0_63_0_2_i_71
       (.CI(h1_reg_0_63_0_2_i_77_n_0),
        .CO({h1_reg_0_63_0_2_i_71_n_0,h1_reg_0_63_0_2_i_71_n_1,h1_reg_0_63_0_2_i_71_n_2,h1_reg_0_63_0_2_i_71_n_3}),
        .CYINIT(1'b0),
        .DI({rq_half[50:49],h1_reg_0_63_0_2_i_118_n_0,rq_prod_reg__0[48]}),
        .O({h1_reg_0_63_0_2_i_71_n_4,h1_reg_0_63_0_2_i_71_n_5,h1_reg_0_63_0_2_i_71_n_6,h1_reg_0_63_0_2_i_71_n_7}),
        .S({h1_reg_0_63_0_2_i_119_n_0,h1_reg_0_63_0_2_i_120_n_0,h1_reg_0_63_0_2_i_121_n_0,h1_reg_0_63_0_2_i_122_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 h1_reg_0_63_0_2_i_72
       (.CI(h1_reg_0_63_0_2_i_76_n_0),
        .CO({h1_reg_0_63_0_2_i_72_n_0,h1_reg_0_63_0_2_i_72_n_1,h1_reg_0_63_0_2_i_72_n_2,h1_reg_0_63_0_2_i_72_n_3}),
        .CYINIT(1'b0),
        .DI(rq_prod_reg__0[19:16]),
        .O({h1_reg_0_63_0_2_i_72_n_4,h1_reg_0_63_0_2_i_72_n_5,h1_reg_0_63_0_2_i_72_n_6,h1_reg_0_63_0_2_i_72_n_7}),
        .S({h1_reg_0_63_0_2_i_123_n_0,h1_reg_0_63_0_2_i_124_n_0,h1_reg_0_63_0_2_i_125_n_0,h1_reg_0_63_0_2_i_126_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 h1_reg_0_63_0_2_i_73
       (.CI(h1_reg_0_63_0_2_i_79_n_0),
        .CO({h1_reg_0_63_0_2_i_73_n_0,h1_reg_0_63_0_2_i_73_n_1,h1_reg_0_63_0_2_i_73_n_2,h1_reg_0_63_0_2_i_73_n_3}),
        .CYINIT(1'b0),
        .DI(rq_prod_reg__0[11:8]),
        .O({h1_reg_0_63_0_2_i_73_n_4,h1_reg_0_63_0_2_i_73_n_5,h1_reg_0_63_0_2_i_73_n_6,h1_reg_0_63_0_2_i_73_n_7}),
        .S({h1_reg_0_63_0_2_i_127_n_0,h1_reg_0_63_0_2_i_128_n_0,h1_reg_0_63_0_2_i_129_n_0,h1_reg_0_63_0_2_i_130_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 h1_reg_0_63_0_2_i_74
       (.CI(h1_reg_0_63_0_2_i_80_n_0),
        .CO({h1_reg_0_63_0_2_i_74_n_0,h1_reg_0_63_0_2_i_74_n_1,h1_reg_0_63_0_2_i_74_n_2,h1_reg_0_63_0_2_i_74_n_3}),
        .CYINIT(1'b0),
        .DI(rq_prod_reg__0[43:40]),
        .O({h1_reg_0_63_0_2_i_74_n_4,h1_reg_0_63_0_2_i_74_n_5,h1_reg_0_63_0_2_i_74_n_6,h1_reg_0_63_0_2_i_74_n_7}),
        .S({h1_reg_0_63_0_2_i_131_n_0,h1_reg_0_63_0_2_i_132_n_0,h1_reg_0_63_0_2_i_133_n_0,h1_reg_0_63_0_2_i_134_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 h1_reg_0_63_0_2_i_75
       (.CI(h1_reg_0_63_0_2_i_81_n_0),
        .CO({h1_reg_0_63_0_2_i_75_n_0,h1_reg_0_63_0_2_i_75_n_1,h1_reg_0_63_0_2_i_75_n_2,h1_reg_0_63_0_2_i_75_n_3}),
        .CYINIT(1'b0),
        .DI(rq_prod_reg__0[27:24]),
        .O({h1_reg_0_63_0_2_i_75_n_4,h1_reg_0_63_0_2_i_75_n_5,h1_reg_0_63_0_2_i_75_n_6,h1_reg_0_63_0_2_i_75_n_7}),
        .S({h1_reg_0_63_0_2_i_135_n_0,h1_reg_0_63_0_2_i_136_n_0,h1_reg_0_63_0_2_i_137_n_0,h1_reg_0_63_0_2_i_138_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 h1_reg_0_63_0_2_i_76
       (.CI(h1_reg_0_63_0_2_i_73_n_0),
        .CO({h1_reg_0_63_0_2_i_76_n_0,h1_reg_0_63_0_2_i_76_n_1,h1_reg_0_63_0_2_i_76_n_2,h1_reg_0_63_0_2_i_76_n_3}),
        .CYINIT(1'b0),
        .DI(rq_prod_reg__0[15:12]),
        .O({h1_reg_0_63_0_2_i_76_n_4,h1_reg_0_63_0_2_i_76_n_5,h1_reg_0_63_0_2_i_76_n_6,h1_reg_0_63_0_2_i_76_n_7}),
        .S({h1_reg_0_63_0_2_i_139_n_0,h1_reg_0_63_0_2_i_140_n_0,h1_reg_0_63_0_2_i_141_n_0,h1_reg_0_63_0_2_i_142_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 h1_reg_0_63_0_2_i_77
       (.CI(h1_reg_0_63_0_2_i_74_n_0),
        .CO({h1_reg_0_63_0_2_i_77_n_0,h1_reg_0_63_0_2_i_77_n_1,h1_reg_0_63_0_2_i_77_n_2,h1_reg_0_63_0_2_i_77_n_3}),
        .CYINIT(1'b0),
        .DI(rq_prod_reg__0[47:44]),
        .O({h1_reg_0_63_0_2_i_77_n_4,h1_reg_0_63_0_2_i_77_n_5,h1_reg_0_63_0_2_i_77_n_6,h1_reg_0_63_0_2_i_77_n_7}),
        .S({h1_reg_0_63_0_2_i_143_n_0,h1_reg_0_63_0_2_i_144_n_0,h1_reg_0_63_0_2_i_145_n_0,h1_reg_0_63_0_2_i_146_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 h1_reg_0_63_0_2_i_78
       (.CI(h1_reg_0_63_0_2_i_75_n_0),
        .CO({h1_reg_0_63_0_2_i_78_n_0,h1_reg_0_63_0_2_i_78_n_1,h1_reg_0_63_0_2_i_78_n_2,h1_reg_0_63_0_2_i_78_n_3}),
        .CYINIT(1'b0),
        .DI(rq_prod_reg__0[31:28]),
        .O({h1_reg_0_63_0_2_i_78_n_4,h1_reg_0_63_0_2_i_78_n_5,h1_reg_0_63_0_2_i_78_n_6,h1_reg_0_63_0_2_i_78_n_7}),
        .S({h1_reg_0_63_0_2_i_147_n_0,h1_reg_0_63_0_2_i_148_n_0,h1_reg_0_63_0_2_i_149_n_0,h1_reg_0_63_0_2_i_150_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 h1_reg_0_63_0_2_i_79
       (.CI(h1_reg_0_63_0_2_i_69_n_0),
        .CO({h1_reg_0_63_0_2_i_79_n_0,h1_reg_0_63_0_2_i_79_n_1,h1_reg_0_63_0_2_i_79_n_2,h1_reg_0_63_0_2_i_79_n_3}),
        .CYINIT(1'b0),
        .DI(rq_prod_reg__0[7:4]),
        .O({h1_reg_0_63_0_2_i_79_n_4,h1_reg_0_63_0_2_i_79_n_5,h1_reg_0_63_0_2_i_79_n_6,h1_reg_0_63_0_2_i_79_n_7}),
        .S({h1_reg_0_63_0_2_i_151_n_0,h1_reg_0_63_0_2_i_152_n_0,h1_reg_0_63_0_2_i_153_n_0,h1_reg_0_63_0_2_i_154_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 h1_reg_0_63_0_2_i_8
       (.CI(h1_reg_0_63_0_2_i_22_n_0),
        .CO({NLW_h1_reg_0_63_0_2_i_8_CO_UNCONNECTED[3],h1_reg_0_63_0_2_i_8_n_1,h1_reg_0_63_0_2_i_8_n_2,h1_reg_0_63_0_2_i_8_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,rq_half[61:59]}),
        .O({h1_reg_0_63_0_2_i_8_n_4,h1_reg_0_63_0_2_i_8_n_5,h1_reg_0_63_0_2_i_8_n_6,h1_reg_0_63_0_2_i_8_n_7}),
        .S({h1_reg_0_63_0_2_i_26_n_0,h1_reg_0_63_0_2_i_27_n_0,h1_reg_0_63_0_2_i_28_n_0,h1_reg_0_63_0_2_i_29_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 h1_reg_0_63_0_2_i_80
       (.CI(h1_reg_0_63_0_2_i_70_n_0),
        .CO({h1_reg_0_63_0_2_i_80_n_0,h1_reg_0_63_0_2_i_80_n_1,h1_reg_0_63_0_2_i_80_n_2,h1_reg_0_63_0_2_i_80_n_3}),
        .CYINIT(1'b0),
        .DI(rq_prod_reg__0[39:36]),
        .O({h1_reg_0_63_0_2_i_80_n_4,h1_reg_0_63_0_2_i_80_n_5,h1_reg_0_63_0_2_i_80_n_6,h1_reg_0_63_0_2_i_80_n_7}),
        .S({h1_reg_0_63_0_2_i_155_n_0,h1_reg_0_63_0_2_i_156_n_0,h1_reg_0_63_0_2_i_157_n_0,h1_reg_0_63_0_2_i_158_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 h1_reg_0_63_0_2_i_81
       (.CI(h1_reg_0_63_0_2_i_72_n_0),
        .CO({h1_reg_0_63_0_2_i_81_n_0,h1_reg_0_63_0_2_i_81_n_1,h1_reg_0_63_0_2_i_81_n_2,h1_reg_0_63_0_2_i_81_n_3}),
        .CYINIT(1'b0),
        .DI(rq_prod_reg__0[23:20]),
        .O({h1_reg_0_63_0_2_i_81_n_4,h1_reg_0_63_0_2_i_81_n_5,h1_reg_0_63_0_2_i_81_n_6,h1_reg_0_63_0_2_i_81_n_7}),
        .S({h1_reg_0_63_0_2_i_159_n_0,h1_reg_0_63_0_2_i_160_n_0,h1_reg_0_63_0_2_i_161_n_0,h1_reg_0_63_0_2_i_162_n_0}));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 h1_reg_0_63_0_2_i_82
       (.CI(h1_reg_0_63_0_2_i_163_n_0),
        .CO({h1_reg_0_63_0_2_i_82_n_0,h1_reg_0_63_0_2_i_82_n_1,h1_reg_0_63_0_2_i_82_n_2,h1_reg_0_63_0_2_i_82_n_3}),
        .CYINIT(1'b0),
        .DI({h1_reg_0_63_0_2_i_164_n_0,h1_reg_0_63_0_2_i_165_n_0,h1_reg_0_63_0_2_i_166_n_0,h1_reg_0_63_0_2_i_167_n_0}),
        .O(NLW_h1_reg_0_63_0_2_i_82_O_UNCONNECTED[3:0]),
        .S({h1_reg_0_63_0_2_i_168_n_0,h1_reg_0_63_0_2_i_169_n_0,h1_reg_0_63_0_2_i_170_n_0,h1_reg_0_63_0_2_i_171_n_0}));
  LUT4 #(
    .INIT(16'hFFAC)) 
    h1_reg_0_63_0_2_i_83
       (.I0(h1_reg_0_63_0_2_i_98_n_0),
        .I1(h1_reg_0_63_0_2_i_172_n_0),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(h1_reg_0_63_0_2_i_173_n_0),
        .O(h1_reg_0_63_0_2_i_83_n_0));
  LUT4 #(
    .INIT(16'hFFAC)) 
    h1_reg_0_63_0_2_i_84
       (.I0(h1_reg_0_63_0_2_i_172_n_0),
        .I1(h1_reg_0_63_0_2_i_174_n_0),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(h1_reg_0_63_0_2_i_175_n_0),
        .O(h1_reg_0_63_0_2_i_84_n_0));
  LUT4 #(
    .INIT(16'hFFAC)) 
    h1_reg_0_63_0_2_i_85
       (.I0(h1_reg_0_63_0_2_i_174_n_0),
        .I1(h1_reg_0_63_0_2_i_176_n_0),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(h1_reg_0_63_0_2_i_177_n_0),
        .O(h1_reg_0_63_0_2_i_85_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFB8FF00FFB8)) 
    h1_reg_0_63_0_2_i_86
       (.I0(h1_reg_0_63_0_2_i_178_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_179_n_0),
        .I3(h1_reg_0_63_0_2_i_180_n_0),
        .I4(\rq_n_reg_n_0_[0] ),
        .I5(h1_reg_0_63_0_2_i_176_n_0),
        .O(h1_reg_0_63_0_2_i_86_n_0));
  LUT4 #(
    .INIT(16'h0053)) 
    h1_reg_0_63_0_2_i_87
       (.I0(h1_reg_0_63_0_2_i_98_n_0),
        .I1(h1_reg_0_63_0_2_i_172_n_0),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(h1_reg_0_63_0_2_i_173_n_0),
        .O(h1_reg_0_63_0_2_i_87_n_0));
  LUT4 #(
    .INIT(16'h0053)) 
    h1_reg_0_63_0_2_i_88
       (.I0(h1_reg_0_63_0_2_i_172_n_0),
        .I1(h1_reg_0_63_0_2_i_174_n_0),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(h1_reg_0_63_0_2_i_175_n_0),
        .O(h1_reg_0_63_0_2_i_88_n_0));
  LUT4 #(
    .INIT(16'h0053)) 
    h1_reg_0_63_0_2_i_89
       (.I0(h1_reg_0_63_0_2_i_174_n_0),
        .I1(h1_reg_0_63_0_2_i_176_n_0),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(h1_reg_0_63_0_2_i_177_n_0),
        .O(h1_reg_0_63_0_2_i_89_n_0));
  (* SOFT_HLUTNM = "soft_lutpair82" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    h1_reg_0_63_0_2_i_9
       (.I0(h1_reg_0_63_0_2_i_30_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_19_n_0),
        .O(h1_reg_0_63_0_2_i_9_n_0));
  LUT6 #(
    .INIT(64'h0000000000FF4747)) 
    h1_reg_0_63_0_2_i_90
       (.I0(h1_reg_0_63_0_2_i_178_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_179_n_0),
        .I3(h1_reg_0_63_0_2_i_176_n_0),
        .I4(\rq_n_reg_n_0_[0] ),
        .I5(h1_reg_0_63_0_2_i_180_n_0),
        .O(h1_reg_0_63_0_2_i_90_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFE00000002)) 
    h1_reg_0_63_0_2_i_91
       (.I0(h1_reg_0_63_0_2_i_8_n_7),
        .I1(\rq_n_reg_n_0_[5] ),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(\rq_n_reg_n_0_[3] ),
        .I4(\rq_n_reg_n_0_[2] ),
        .I5(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_91_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFE00000002)) 
    h1_reg_0_63_0_2_i_92
       (.I0(h1_reg_0_63_0_2_i_8_n_6),
        .I1(\rq_n_reg_n_0_[5] ),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(\rq_n_reg_n_0_[3] ),
        .I4(\rq_n_reg_n_0_[2] ),
        .I5(h1_reg_0_63_0_2_i_8_n_4),
        .O(h1_reg_0_63_0_2_i_92_n_0));
  (* SOFT_HLUTNM = "soft_lutpair88" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    h1_reg_0_63_0_2_i_93
       (.I0(h1_reg_0_63_0_2_i_181_n_0),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(h1_reg_0_63_0_2_i_182_n_0),
        .O(h1_reg_0_63_0_2_i_93_n_0));
  (* SOFT_HLUTNM = "soft_lutpair89" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    h1_reg_0_63_0_2_i_94
       (.I0(h1_reg_0_63_0_2_i_92_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_183_n_0),
        .O(h1_reg_0_63_0_2_i_94_n_0));
  (* SOFT_HLUTNM = "soft_lutpair88" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    h1_reg_0_63_0_2_i_95
       (.I0(h1_reg_0_63_0_2_i_184_n_0),
        .I1(\rq_n_reg_n_0_[2] ),
        .I2(h1_reg_0_63_0_2_i_185_n_0),
        .O(h1_reg_0_63_0_2_i_95_n_0));
  LUT5 #(
    .INIT(32'hB8BBB888)) 
    h1_reg_0_63_0_2_i_96
       (.I0(h1_reg_0_63_0_2_i_183_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_186_n_0),
        .I3(\rq_n_reg_n_0_[2] ),
        .I4(h1_reg_0_63_0_2_i_187_n_0),
        .O(h1_reg_0_63_0_2_i_96_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_97
       (.I0(h1_reg_0_63_0_2_i_181_n_0),
        .I1(h1_reg_0_63_0_2_i_182_n_0),
        .I2(\rq_n_reg_n_0_[1] ),
        .I3(h1_reg_0_63_0_2_i_184_n_0),
        .I4(\rq_n_reg_n_0_[2] ),
        .I5(h1_reg_0_63_0_2_i_185_n_0),
        .O(h1_reg_0_63_0_2_i_97_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_98
       (.I0(h1_reg_0_63_0_2_i_184_n_0),
        .I1(h1_reg_0_63_0_2_i_185_n_0),
        .I2(\rq_n_reg_n_0_[1] ),
        .I3(h1_reg_0_63_0_2_i_182_n_0),
        .I4(\rq_n_reg_n_0_[2] ),
        .I5(h1_reg_0_63_0_2_i_188_n_0),
        .O(h1_reg_0_63_0_2_i_98_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_0_2_i_99
       (.I0(h1_reg_0_63_0_2_i_186_n_0),
        .I1(h1_reg_0_63_0_2_i_187_n_0),
        .I2(\rq_n_reg_n_0_[1] ),
        .I3(h1_reg_0_63_0_2_i_189_n_0),
        .I4(\rq_n_reg_n_0_[2] ),
        .I5(h1_reg_0_63_0_2_i_190_n_0),
        .O(h1_reg_0_63_0_2_i_99_n_0));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "512" *) 
  (* RTL_RAM_NAME = "emg_nn_infer/h1_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "63" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "3" *) 
  (* ram_slice_end = "5" *) 
  RAM64M h1_reg_0_63_3_5
       (.ADDRA({mac_in__0,mac_in}),
        .ADDRB({mac_in__0,mac_in}),
        .ADDRC({mac_in__0,mac_in}),
        .ADDRD(p_0_in[9:4]),
        .DIA(hidden_activation[3]),
        .DIB(hidden_activation[4]),
        .DIC(hidden_activation[5]),
        .DID(1'b0),
        .DOA(act0[3]),
        .DOB(act0[4]),
        .DOC(act0[5]),
        .DOD(NLW_h1_reg_0_63_3_5_DOD_UNCONNECTED),
        .WCLK(clk),
        .WE(h1_reg_0_63_0_2_i_4_n_0));
  LUT5 #(
    .INIT(32'h0000FFB8)) 
    h1_reg_0_63_3_5_i_1
       (.I0(h1_reg_0_63_3_5_i_4_n_0),
        .I1(\rq_n_reg_n_0_[0] ),
        .I2(h1_reg_0_63_0_2_i_10_n_0),
        .I3(h1_reg_0_63_0_2_i_6_n_3),
        .I4(h1_reg_0_63_0_2_i_8_n_4),
        .O(hidden_activation[3]));
  LUT6 #(
    .INIT(64'hCFC0AFAFCFC0A0A0)) 
    h1_reg_0_63_3_5_i_10
       (.I0(h1_reg_0_63_0_2_i_70_n_5),
        .I1(h1_reg_0_63_0_2_i_8_n_4),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_71_n_5),
        .I4(\rq_n_reg_n_0_[5] ),
        .I5(h1_reg_0_63_0_2_i_72_n_5),
        .O(h1_reg_0_63_3_5_i_10_n_0));
  LUT6 #(
    .INIT(64'hCFC0AFAFCFC0A0A0)) 
    h1_reg_0_63_3_5_i_11
       (.I0(h1_reg_0_63_0_2_i_70_n_4),
        .I1(h1_reg_0_63_0_2_i_8_n_4),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_71_n_4),
        .I4(\rq_n_reg_n_0_[5] ),
        .I5(h1_reg_0_63_0_2_i_72_n_4),
        .O(h1_reg_0_63_3_5_i_11_n_0));
  LUT6 #(
    .INIT(64'hCFC0AFAFCFC0A0A0)) 
    h1_reg_0_63_3_5_i_12
       (.I0(h1_reg_0_63_0_2_i_80_n_7),
        .I1(h1_reg_0_63_0_2_i_8_n_4),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_58_n_7),
        .I4(\rq_n_reg_n_0_[5] ),
        .I5(h1_reg_0_63_0_2_i_81_n_7),
        .O(h1_reg_0_63_3_5_i_12_n_0));
  LUT5 #(
    .INIT(32'h0000FFB8)) 
    h1_reg_0_63_3_5_i_2
       (.I0(h1_reg_0_63_3_5_i_5_n_0),
        .I1(\rq_n_reg_n_0_[0] ),
        .I2(h1_reg_0_63_3_5_i_4_n_0),
        .I3(h1_reg_0_63_0_2_i_6_n_3),
        .I4(h1_reg_0_63_0_2_i_8_n_4),
        .O(hidden_activation[4]));
  LUT5 #(
    .INIT(32'h0000FFB8)) 
    h1_reg_0_63_3_5_i_3
       (.I0(h1_reg_0_63_3_5_i_6_n_0),
        .I1(\rq_n_reg_n_0_[0] ),
        .I2(h1_reg_0_63_3_5_i_5_n_0),
        .I3(h1_reg_0_63_0_2_i_6_n_3),
        .I4(h1_reg_0_63_0_2_i_8_n_4),
        .O(hidden_activation[5]));
  (* SOFT_HLUTNM = "soft_lutpair82" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    h1_reg_0_63_3_5_i_4
       (.I0(h1_reg_0_63_3_5_i_7_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_30_n_0),
        .O(h1_reg_0_63_3_5_i_4_n_0));
  (* SOFT_HLUTNM = "soft_lutpair83" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    h1_reg_0_63_3_5_i_5
       (.I0(h1_reg_0_63_3_5_i_8_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_0_2_i_31_n_0),
        .O(h1_reg_0_63_3_5_i_5_n_0));
  (* SOFT_HLUTNM = "soft_lutpair85" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    h1_reg_0_63_3_5_i_6
       (.I0(h1_reg_0_63_3_5_i_9_n_0),
        .I1(\rq_n_reg_n_0_[1] ),
        .I2(h1_reg_0_63_3_5_i_7_n_0),
        .O(h1_reg_0_63_3_5_i_6_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_3_5_i_7
       (.I0(h1_reg_0_63_3_5_i_10_n_0),
        .I1(h1_reg_0_63_0_2_i_51_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_52_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_0_2_i_53_n_0),
        .O(h1_reg_0_63_3_5_i_7_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_3_5_i_8
       (.I0(h1_reg_0_63_3_5_i_11_n_0),
        .I1(h1_reg_0_63_0_2_i_33_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_34_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_0_2_i_35_n_0),
        .O(h1_reg_0_63_3_5_i_8_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_3_5_i_9
       (.I0(h1_reg_0_63_3_5_i_12_n_0),
        .I1(h1_reg_0_63_0_2_i_56_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_67_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_0_2_i_54_n_0),
        .O(h1_reg_0_63_3_5_i_9_n_0));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "512" *) 
  (* RTL_RAM_NAME = "emg_nn_infer/h1_reg_0_63_6_7" *) 
  (* RTL_RAM_STYLE = "NONE" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "63" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "6" *) 
  (* ram_slice_end = "6" *) 
  RAM64X1D h1_reg_0_63_6_7
       (.A0(p_0_in[4]),
        .A1(p_0_in[5]),
        .A2(p_0_in[6]),
        .A3(p_0_in[7]),
        .A4(p_0_in[8]),
        .A5(p_0_in[9]),
        .D(hidden_activation[6]),
        .DPO(act0[6]),
        .DPRA0(mac_in[0]),
        .DPRA1(mac_in[1]),
        .DPRA2(mac_in__0[2]),
        .DPRA3(mac_in__0[3]),
        .DPRA4(mac_in__0[4]),
        .DPRA5(mac_in__0[5]),
        .SPO(NLW_h1_reg_0_63_6_7_SPO_UNCONNECTED),
        .WCLK(clk),
        .WE(h1_reg_0_63_0_2_i_4_n_0));
  LUT3 #(
    .INIT(8'h32)) 
    h1_reg_0_63_6_7_i_1
       (.I0(h1_reg_0_63_6_7_i_2_n_0),
        .I1(h1_reg_0_63_0_2_i_8_n_4),
        .I2(h1_reg_0_63_0_2_i_6_n_3),
        .O(hidden_activation[6]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_6_7_i_2
       (.I0(h1_reg_0_63_6_7_i_3_n_0),
        .I1(h1_reg_0_63_3_5_i_8_n_0),
        .I2(\rq_n_reg_n_0_[0] ),
        .I3(h1_reg_0_63_3_5_i_9_n_0),
        .I4(\rq_n_reg_n_0_[1] ),
        .I5(h1_reg_0_63_3_5_i_7_n_0),
        .O(h1_reg_0_63_6_7_i_2_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    h1_reg_0_63_6_7_i_3
       (.I0(h1_reg_0_63_6_7_i_4_n_0),
        .I1(h1_reg_0_63_0_2_i_38_n_0),
        .I2(\rq_n_reg_n_0_[2] ),
        .I3(h1_reg_0_63_0_2_i_68_n_0),
        .I4(\rq_n_reg_n_0_[3] ),
        .I5(h1_reg_0_63_0_2_i_36_n_0),
        .O(h1_reg_0_63_6_7_i_3_n_0));
  LUT6 #(
    .INIT(64'hCFC0AFAFCFC0A0A0)) 
    h1_reg_0_63_6_7_i_4
       (.I0(h1_reg_0_63_0_2_i_80_n_6),
        .I1(h1_reg_0_63_0_2_i_8_n_4),
        .I2(\rq_n_reg_n_0_[4] ),
        .I3(h1_reg_0_63_0_2_i_58_n_6),
        .I4(\rq_n_reg_n_0_[5] ),
        .I5(h1_reg_0_63_0_2_i_81_n_6),
        .O(h1_reg_0_63_6_7_i_4_n_0));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "256" *) 
  (* RTL_RAM_NAME = "emg_nn_infer/h2_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "0" *) 
  (* ram_slice_end = "5" *) 
  RAM32M h2_reg_0_31_0_5
       (.ADDRA({mac_in__0[4:2],mac_in}),
        .ADDRB({mac_in__0[4:2],mac_in}),
        .ADDRC({mac_in__0[4:2],mac_in}),
        .ADDRD(p_0_in[8:4]),
        .DIA(hidden_activation[1:0]),
        .DIB(hidden_activation[3:2]),
        .DIC(hidden_activation[5:4]),
        .DID({1'b0,1'b0}),
        .DOA({h2_reg_0_31_0_5_n_0,h2_reg_0_31_0_5_n_1}),
        .DOB({h2_reg_0_31_0_5_n_2,h2_reg_0_31_0_5_n_3}),
        .DOC({h2_reg_0_31_0_5_n_4,h2_reg_0_31_0_5_n_5}),
        .DOD(NLW_h2_reg_0_31_0_5_DOD_UNCONNECTED[1:0]),
        .WCLK(clk),
        .WE(h2_reg_0_31_0_5_i_1_n_0));
  LUT6 #(
    .INIT(64'h0000000040000000)) 
    h2_reg_0_31_0_5_i_1
       (.I0(state[4]),
        .I1(h1_reg_0_63_0_2_i_12_n_0),
        .I2(state[3]),
        .I3(state[2]),
        .I4(rst_n),
        .I5(layer_last),
        .O(h2_reg_0_31_0_5_i_1_n_0));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "256" *) 
  (* RTL_RAM_NAME = "emg_nn_infer/h2_reg_0_31_6_7" *) 
  (* RTL_RAM_STYLE = "NONE" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "6" *) 
  (* ram_slice_end = "6" *) 
  RAM32X1D h2_reg_0_31_6_7
       (.A0(p_0_in[4]),
        .A1(p_0_in[5]),
        .A2(p_0_in[6]),
        .A3(p_0_in[7]),
        .A4(p_0_in[8]),
        .D(hidden_activation[6]),
        .DPO(h2_reg_0_31_6_7_n_0),
        .DPRA0(mac_in[0]),
        .DPRA1(mac_in[1]),
        .DPRA2(mac_in__0[2]),
        .DPRA3(mac_in__0[3]),
        .DPRA4(mac_in__0[4]),
        .SPO(NLW_h2_reg_0_31_6_7_SPO_UNCONNECTED),
        .WCLK(clk),
        .WE(h2_reg_0_31_0_5_i_1_n_0));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "256" *) 
  (* RTL_RAM_NAME = "emg_nn_infer/h2_reg_0_31_6_7" *) 
  (* RTL_RAM_STYLE = "NONE" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "7" *) 
  (* ram_slice_end = "7" *) 
  RAM32X1D h2_reg_0_31_6_7__0
       (.A0(p_0_in[4]),
        .A1(p_0_in[5]),
        .A2(p_0_in[6]),
        .A3(p_0_in[7]),
        .A4(p_0_in[8]),
        .D(1'b0),
        .DPO(h2_reg_0_31_6_7__0_n_0),
        .DPRA0(mac_in[0]),
        .DPRA1(mac_in[1]),
        .DPRA2(mac_in__0[2]),
        .DPRA3(mac_in__0[3]),
        .DPRA4(mac_in__0[4]),
        .SPO(NLW_h2_reg_0_31_6_7__0_SPO_UNCONNECTED),
        .WCLK(clk),
        .WE(h2_reg_0_31_0_5_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h00FF0100)) 
    \layer[0]_i_1 
       (.I0(\layer_reg_n_0_[1] ),
        .I1(state[3]),
        .I2(state[2]),
        .I3(\layer[1]_i_2_n_0 ),
        .I4(\layer_reg_n_0_[0] ),
        .O(\layer[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h02FF0200)) 
    \layer[1]_i_1 
       (.I0(\layer_reg_n_0_[0] ),
        .I1(state[3]),
        .I2(state[2]),
        .I3(\layer[1]_i_2_n_0 ),
        .I4(\layer_reg_n_0_[1] ),
        .O(\layer[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000005080008)) 
    \layer[1]_i_2 
       (.I0(state[4]),
        .I1(\FSM_sequential_state[4]_i_5_n_0 ),
        .I2(state[3]),
        .I3(state[2]),
        .I4(\word_idx[4]_i_4_n_0 ),
        .I5(\word_idx[4]_i_5_n_0 ),
        .O(\layer[1]_i_2_n_0 ));
  FDRE \layer_reg[0] 
       (.C(clk),
        .CE(1'b1),
        .D(\layer[0]_i_1_n_0 ),
        .Q(\layer_reg_n_0_[0] ),
        .R(out_valid_i_1_n_0));
  FDRE \layer_reg[1] 
       (.C(clk),
        .CE(1'b1),
        .D(\layer[1]_i_1_n_0 ),
        .Q(\layer_reg_n_0_[1] ),
        .R(out_valid_i_1_n_0));
  LUT6 #(
    .INIT(64'h0010000000000000)) 
    \logits[0][31]_i_1 
       (.I0(\logits[0][31]_i_2_n_0 ),
        .I1(\logits[0][31]_i_3_n_0 ),
        .I2(\logits[0][31]_i_4_n_0 ),
        .I3(p_0_in[5]),
        .I4(\FSM_sequential_state[3]_i_2_n_0 ),
        .I5(state[2]),
        .O(logits));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \logits[0][31]_i_2 
       (.I0(state[4]),
        .I1(state[1]),
        .O(\logits[0][31]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair54" *) 
  LUT2 #(
    .INIT(4'h7)) 
    \logits[0][31]_i_3 
       (.I0(state[3]),
        .I1(state[0]),
        .O(\logits[0][31]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair116" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \logits[0][31]_i_4 
       (.I0(p_0_in[4]),
        .I1(p_0_in[6]),
        .O(\logits[0][31]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h1000000000000000)) 
    \logits[1][31]_i_1 
       (.I0(\logits[0][31]_i_2_n_0 ),
        .I1(\logits[0][31]_i_3_n_0 ),
        .I2(p_0_in[4]),
        .I3(\FSM_sequential_state[3]_i_2_n_0 ),
        .I4(\logits[1][31]_i_2_n_0 ),
        .I5(state[2]),
        .O(\logits[1][31]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h1)) 
    \logits[1][31]_i_2 
       (.I0(p_0_in[5]),
        .I1(p_0_in[6]),
        .O(\logits[1][31]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h1000000000000000)) 
    \logits[2][31]_i_1 
       (.I0(\logits[0][31]_i_2_n_0 ),
        .I1(\logits[0][31]_i_3_n_0 ),
        .I2(p_0_in[5]),
        .I3(\FSM_sequential_state[3]_i_2_n_0 ),
        .I4(\logits[0][31]_i_4_n_0 ),
        .I5(state[2]),
        .O(\logits[2][31]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000100000000000)) 
    \logits[3][31]_i_1 
       (.I0(\logits[0][31]_i_2_n_0 ),
        .I1(\logits[0][31]_i_3_n_0 ),
        .I2(\logits[3][31]_i_2_n_0 ),
        .I3(\FSM_sequential_state[3]_i_2_n_0 ),
        .I4(p_0_in[6]),
        .I5(state[2]),
        .O(\logits[3][31]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair81" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \logits[3][31]_i_2 
       (.I0(p_0_in[5]),
        .I1(p_0_in[4]),
        .O(\logits[3][31]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h00001000)) 
    \logits[4][31]_i_1 
       (.I0(state[1]),
        .I1(state[4]),
        .I2(state[3]),
        .I3(state[0]),
        .I4(\logits[4][31]_i_2_n_0 ),
        .O(\logits[4][31]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFBFFFFFFFFF)) 
    \logits[4][31]_i_2 
       (.I0(\layer_reg_n_0_[0] ),
        .I1(\layer_reg_n_0_[1] ),
        .I2(p_0_in[6]),
        .I3(p_0_in[4]),
        .I4(p_0_in[5]),
        .I5(state[2]),
        .O(\logits[4][31]_i_2_n_0 ));
  FDRE \logits_reg[0][0] 
       (.C(clk),
        .CE(logits),
        .D(acc[0]),
        .Q(\logits_reg[0] [0]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[0][10] 
       (.C(clk),
        .CE(logits),
        .D(acc[10]),
        .Q(\logits_reg[0] [10]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[0][11] 
       (.C(clk),
        .CE(logits),
        .D(acc[11]),
        .Q(\logits_reg[0] [11]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[0][12] 
       (.C(clk),
        .CE(logits),
        .D(acc[12]),
        .Q(\logits_reg[0] [12]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[0][13] 
       (.C(clk),
        .CE(logits),
        .D(acc[13]),
        .Q(\logits_reg[0] [13]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[0][14] 
       (.C(clk),
        .CE(logits),
        .D(acc[14]),
        .Q(\logits_reg[0] [14]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[0][15] 
       (.C(clk),
        .CE(logits),
        .D(acc[15]),
        .Q(\logits_reg[0] [15]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[0][16] 
       (.C(clk),
        .CE(logits),
        .D(acc[16]),
        .Q(\logits_reg[0] [16]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[0][17] 
       (.C(clk),
        .CE(logits),
        .D(acc[17]),
        .Q(\logits_reg[0] [17]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[0][18] 
       (.C(clk),
        .CE(logits),
        .D(acc[18]),
        .Q(\logits_reg[0] [18]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[0][19] 
       (.C(clk),
        .CE(logits),
        .D(acc[19]),
        .Q(\logits_reg[0] [19]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[0][1] 
       (.C(clk),
        .CE(logits),
        .D(acc[1]),
        .Q(\logits_reg[0] [1]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[0][20] 
       (.C(clk),
        .CE(logits),
        .D(acc[20]),
        .Q(\logits_reg[0] [20]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[0][21] 
       (.C(clk),
        .CE(logits),
        .D(acc[21]),
        .Q(\logits_reg[0] [21]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[0][22] 
       (.C(clk),
        .CE(logits),
        .D(acc[22]),
        .Q(\logits_reg[0] [22]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[0][23] 
       (.C(clk),
        .CE(logits),
        .D(acc[23]),
        .Q(\logits_reg[0] [23]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[0][24] 
       (.C(clk),
        .CE(logits),
        .D(acc[24]),
        .Q(\logits_reg[0] [24]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[0][25] 
       (.C(clk),
        .CE(logits),
        .D(acc[25]),
        .Q(\logits_reg[0] [25]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[0][26] 
       (.C(clk),
        .CE(logits),
        .D(acc[26]),
        .Q(\logits_reg[0] [26]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[0][27] 
       (.C(clk),
        .CE(logits),
        .D(acc[27]),
        .Q(\logits_reg[0] [27]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[0][28] 
       (.C(clk),
        .CE(logits),
        .D(acc[28]),
        .Q(\logits_reg[0] [28]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[0][29] 
       (.C(clk),
        .CE(logits),
        .D(acc[29]),
        .Q(\logits_reg[0] [29]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[0][2] 
       (.C(clk),
        .CE(logits),
        .D(acc[2]),
        .Q(\logits_reg[0] [2]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[0][30] 
       (.C(clk),
        .CE(logits),
        .D(acc[30]),
        .Q(\logits_reg[0] [30]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[0][31] 
       (.C(clk),
        .CE(logits),
        .D(acc[31]),
        .Q(\logits_reg[0] [31]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[0][3] 
       (.C(clk),
        .CE(logits),
        .D(acc[3]),
        .Q(\logits_reg[0] [3]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[0][4] 
       (.C(clk),
        .CE(logits),
        .D(acc[4]),
        .Q(\logits_reg[0] [4]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[0][5] 
       (.C(clk),
        .CE(logits),
        .D(acc[5]),
        .Q(\logits_reg[0] [5]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[0][6] 
       (.C(clk),
        .CE(logits),
        .D(acc[6]),
        .Q(\logits_reg[0] [6]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[0][7] 
       (.C(clk),
        .CE(logits),
        .D(acc[7]),
        .Q(\logits_reg[0] [7]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[0][8] 
       (.C(clk),
        .CE(logits),
        .D(acc[8]),
        .Q(\logits_reg[0] [8]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[0][9] 
       (.C(clk),
        .CE(logits),
        .D(acc[9]),
        .Q(\logits_reg[0] [9]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[1][0] 
       (.C(clk),
        .CE(\logits[1][31]_i_1_n_0 ),
        .D(acc[0]),
        .Q(\logits_reg[1] [0]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[1][10] 
       (.C(clk),
        .CE(\logits[1][31]_i_1_n_0 ),
        .D(acc[10]),
        .Q(\logits_reg[1] [10]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[1][11] 
       (.C(clk),
        .CE(\logits[1][31]_i_1_n_0 ),
        .D(acc[11]),
        .Q(\logits_reg[1] [11]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[1][12] 
       (.C(clk),
        .CE(\logits[1][31]_i_1_n_0 ),
        .D(acc[12]),
        .Q(\logits_reg[1] [12]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[1][13] 
       (.C(clk),
        .CE(\logits[1][31]_i_1_n_0 ),
        .D(acc[13]),
        .Q(\logits_reg[1] [13]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[1][14] 
       (.C(clk),
        .CE(\logits[1][31]_i_1_n_0 ),
        .D(acc[14]),
        .Q(\logits_reg[1] [14]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[1][15] 
       (.C(clk),
        .CE(\logits[1][31]_i_1_n_0 ),
        .D(acc[15]),
        .Q(\logits_reg[1] [15]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[1][16] 
       (.C(clk),
        .CE(\logits[1][31]_i_1_n_0 ),
        .D(acc[16]),
        .Q(\logits_reg[1] [16]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[1][17] 
       (.C(clk),
        .CE(\logits[1][31]_i_1_n_0 ),
        .D(acc[17]),
        .Q(\logits_reg[1] [17]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[1][18] 
       (.C(clk),
        .CE(\logits[1][31]_i_1_n_0 ),
        .D(acc[18]),
        .Q(\logits_reg[1] [18]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[1][19] 
       (.C(clk),
        .CE(\logits[1][31]_i_1_n_0 ),
        .D(acc[19]),
        .Q(\logits_reg[1] [19]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[1][1] 
       (.C(clk),
        .CE(\logits[1][31]_i_1_n_0 ),
        .D(acc[1]),
        .Q(\logits_reg[1] [1]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[1][20] 
       (.C(clk),
        .CE(\logits[1][31]_i_1_n_0 ),
        .D(acc[20]),
        .Q(\logits_reg[1] [20]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[1][21] 
       (.C(clk),
        .CE(\logits[1][31]_i_1_n_0 ),
        .D(acc[21]),
        .Q(\logits_reg[1] [21]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[1][22] 
       (.C(clk),
        .CE(\logits[1][31]_i_1_n_0 ),
        .D(acc[22]),
        .Q(\logits_reg[1] [22]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[1][23] 
       (.C(clk),
        .CE(\logits[1][31]_i_1_n_0 ),
        .D(acc[23]),
        .Q(\logits_reg[1] [23]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[1][24] 
       (.C(clk),
        .CE(\logits[1][31]_i_1_n_0 ),
        .D(acc[24]),
        .Q(\logits_reg[1] [24]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[1][25] 
       (.C(clk),
        .CE(\logits[1][31]_i_1_n_0 ),
        .D(acc[25]),
        .Q(\logits_reg[1] [25]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[1][26] 
       (.C(clk),
        .CE(\logits[1][31]_i_1_n_0 ),
        .D(acc[26]),
        .Q(\logits_reg[1] [26]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[1][27] 
       (.C(clk),
        .CE(\logits[1][31]_i_1_n_0 ),
        .D(acc[27]),
        .Q(\logits_reg[1] [27]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[1][28] 
       (.C(clk),
        .CE(\logits[1][31]_i_1_n_0 ),
        .D(acc[28]),
        .Q(\logits_reg[1] [28]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[1][29] 
       (.C(clk),
        .CE(\logits[1][31]_i_1_n_0 ),
        .D(acc[29]),
        .Q(\logits_reg[1] [29]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[1][2] 
       (.C(clk),
        .CE(\logits[1][31]_i_1_n_0 ),
        .D(acc[2]),
        .Q(\logits_reg[1] [2]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[1][30] 
       (.C(clk),
        .CE(\logits[1][31]_i_1_n_0 ),
        .D(acc[30]),
        .Q(\logits_reg[1] [30]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[1][31] 
       (.C(clk),
        .CE(\logits[1][31]_i_1_n_0 ),
        .D(acc[31]),
        .Q(\logits_reg[1] [31]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[1][3] 
       (.C(clk),
        .CE(\logits[1][31]_i_1_n_0 ),
        .D(acc[3]),
        .Q(\logits_reg[1] [3]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[1][4] 
       (.C(clk),
        .CE(\logits[1][31]_i_1_n_0 ),
        .D(acc[4]),
        .Q(\logits_reg[1] [4]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[1][5] 
       (.C(clk),
        .CE(\logits[1][31]_i_1_n_0 ),
        .D(acc[5]),
        .Q(\logits_reg[1] [5]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[1][6] 
       (.C(clk),
        .CE(\logits[1][31]_i_1_n_0 ),
        .D(acc[6]),
        .Q(\logits_reg[1] [6]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[1][7] 
       (.C(clk),
        .CE(\logits[1][31]_i_1_n_0 ),
        .D(acc[7]),
        .Q(\logits_reg[1] [7]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[1][8] 
       (.C(clk),
        .CE(\logits[1][31]_i_1_n_0 ),
        .D(acc[8]),
        .Q(\logits_reg[1] [8]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[1][9] 
       (.C(clk),
        .CE(\logits[1][31]_i_1_n_0 ),
        .D(acc[9]),
        .Q(\logits_reg[1] [9]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[2][0] 
       (.C(clk),
        .CE(\logits[2][31]_i_1_n_0 ),
        .D(acc[0]),
        .Q(\logits_reg[2] [0]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[2][10] 
       (.C(clk),
        .CE(\logits[2][31]_i_1_n_0 ),
        .D(acc[10]),
        .Q(\logits_reg[2] [10]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[2][11] 
       (.C(clk),
        .CE(\logits[2][31]_i_1_n_0 ),
        .D(acc[11]),
        .Q(\logits_reg[2] [11]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[2][12] 
       (.C(clk),
        .CE(\logits[2][31]_i_1_n_0 ),
        .D(acc[12]),
        .Q(\logits_reg[2] [12]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[2][13] 
       (.C(clk),
        .CE(\logits[2][31]_i_1_n_0 ),
        .D(acc[13]),
        .Q(\logits_reg[2] [13]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[2][14] 
       (.C(clk),
        .CE(\logits[2][31]_i_1_n_0 ),
        .D(acc[14]),
        .Q(\logits_reg[2] [14]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[2][15] 
       (.C(clk),
        .CE(\logits[2][31]_i_1_n_0 ),
        .D(acc[15]),
        .Q(\logits_reg[2] [15]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[2][16] 
       (.C(clk),
        .CE(\logits[2][31]_i_1_n_0 ),
        .D(acc[16]),
        .Q(\logits_reg[2] [16]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[2][17] 
       (.C(clk),
        .CE(\logits[2][31]_i_1_n_0 ),
        .D(acc[17]),
        .Q(\logits_reg[2] [17]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[2][18] 
       (.C(clk),
        .CE(\logits[2][31]_i_1_n_0 ),
        .D(acc[18]),
        .Q(\logits_reg[2] [18]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[2][19] 
       (.C(clk),
        .CE(\logits[2][31]_i_1_n_0 ),
        .D(acc[19]),
        .Q(\logits_reg[2] [19]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[2][1] 
       (.C(clk),
        .CE(\logits[2][31]_i_1_n_0 ),
        .D(acc[1]),
        .Q(\logits_reg[2] [1]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[2][20] 
       (.C(clk),
        .CE(\logits[2][31]_i_1_n_0 ),
        .D(acc[20]),
        .Q(\logits_reg[2] [20]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[2][21] 
       (.C(clk),
        .CE(\logits[2][31]_i_1_n_0 ),
        .D(acc[21]),
        .Q(\logits_reg[2] [21]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[2][22] 
       (.C(clk),
        .CE(\logits[2][31]_i_1_n_0 ),
        .D(acc[22]),
        .Q(\logits_reg[2] [22]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[2][23] 
       (.C(clk),
        .CE(\logits[2][31]_i_1_n_0 ),
        .D(acc[23]),
        .Q(\logits_reg[2] [23]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[2][24] 
       (.C(clk),
        .CE(\logits[2][31]_i_1_n_0 ),
        .D(acc[24]),
        .Q(\logits_reg[2] [24]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[2][25] 
       (.C(clk),
        .CE(\logits[2][31]_i_1_n_0 ),
        .D(acc[25]),
        .Q(\logits_reg[2] [25]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[2][26] 
       (.C(clk),
        .CE(\logits[2][31]_i_1_n_0 ),
        .D(acc[26]),
        .Q(\logits_reg[2] [26]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[2][27] 
       (.C(clk),
        .CE(\logits[2][31]_i_1_n_0 ),
        .D(acc[27]),
        .Q(\logits_reg[2] [27]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[2][28] 
       (.C(clk),
        .CE(\logits[2][31]_i_1_n_0 ),
        .D(acc[28]),
        .Q(\logits_reg[2] [28]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[2][29] 
       (.C(clk),
        .CE(\logits[2][31]_i_1_n_0 ),
        .D(acc[29]),
        .Q(\logits_reg[2] [29]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[2][2] 
       (.C(clk),
        .CE(\logits[2][31]_i_1_n_0 ),
        .D(acc[2]),
        .Q(\logits_reg[2] [2]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[2][30] 
       (.C(clk),
        .CE(\logits[2][31]_i_1_n_0 ),
        .D(acc[30]),
        .Q(\logits_reg[2] [30]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[2][31] 
       (.C(clk),
        .CE(\logits[2][31]_i_1_n_0 ),
        .D(acc[31]),
        .Q(\logits_reg[2] [31]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[2][3] 
       (.C(clk),
        .CE(\logits[2][31]_i_1_n_0 ),
        .D(acc[3]),
        .Q(\logits_reg[2] [3]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[2][4] 
       (.C(clk),
        .CE(\logits[2][31]_i_1_n_0 ),
        .D(acc[4]),
        .Q(\logits_reg[2] [4]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[2][5] 
       (.C(clk),
        .CE(\logits[2][31]_i_1_n_0 ),
        .D(acc[5]),
        .Q(\logits_reg[2] [5]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[2][6] 
       (.C(clk),
        .CE(\logits[2][31]_i_1_n_0 ),
        .D(acc[6]),
        .Q(\logits_reg[2] [6]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[2][7] 
       (.C(clk),
        .CE(\logits[2][31]_i_1_n_0 ),
        .D(acc[7]),
        .Q(\logits_reg[2] [7]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[2][8] 
       (.C(clk),
        .CE(\logits[2][31]_i_1_n_0 ),
        .D(acc[8]),
        .Q(\logits_reg[2] [8]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[2][9] 
       (.C(clk),
        .CE(\logits[2][31]_i_1_n_0 ),
        .D(acc[9]),
        .Q(\logits_reg[2] [9]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[3][0] 
       (.C(clk),
        .CE(\logits[3][31]_i_1_n_0 ),
        .D(acc[0]),
        .Q(\logits_reg[3] [0]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[3][10] 
       (.C(clk),
        .CE(\logits[3][31]_i_1_n_0 ),
        .D(acc[10]),
        .Q(\logits_reg[3] [10]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[3][11] 
       (.C(clk),
        .CE(\logits[3][31]_i_1_n_0 ),
        .D(acc[11]),
        .Q(\logits_reg[3] [11]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[3][12] 
       (.C(clk),
        .CE(\logits[3][31]_i_1_n_0 ),
        .D(acc[12]),
        .Q(\logits_reg[3] [12]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[3][13] 
       (.C(clk),
        .CE(\logits[3][31]_i_1_n_0 ),
        .D(acc[13]),
        .Q(\logits_reg[3] [13]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[3][14] 
       (.C(clk),
        .CE(\logits[3][31]_i_1_n_0 ),
        .D(acc[14]),
        .Q(\logits_reg[3] [14]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[3][15] 
       (.C(clk),
        .CE(\logits[3][31]_i_1_n_0 ),
        .D(acc[15]),
        .Q(\logits_reg[3] [15]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[3][16] 
       (.C(clk),
        .CE(\logits[3][31]_i_1_n_0 ),
        .D(acc[16]),
        .Q(\logits_reg[3] [16]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[3][17] 
       (.C(clk),
        .CE(\logits[3][31]_i_1_n_0 ),
        .D(acc[17]),
        .Q(\logits_reg[3] [17]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[3][18] 
       (.C(clk),
        .CE(\logits[3][31]_i_1_n_0 ),
        .D(acc[18]),
        .Q(\logits_reg[3] [18]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[3][19] 
       (.C(clk),
        .CE(\logits[3][31]_i_1_n_0 ),
        .D(acc[19]),
        .Q(\logits_reg[3] [19]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[3][1] 
       (.C(clk),
        .CE(\logits[3][31]_i_1_n_0 ),
        .D(acc[1]),
        .Q(\logits_reg[3] [1]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[3][20] 
       (.C(clk),
        .CE(\logits[3][31]_i_1_n_0 ),
        .D(acc[20]),
        .Q(\logits_reg[3] [20]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[3][21] 
       (.C(clk),
        .CE(\logits[3][31]_i_1_n_0 ),
        .D(acc[21]),
        .Q(\logits_reg[3] [21]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[3][22] 
       (.C(clk),
        .CE(\logits[3][31]_i_1_n_0 ),
        .D(acc[22]),
        .Q(\logits_reg[3] [22]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[3][23] 
       (.C(clk),
        .CE(\logits[3][31]_i_1_n_0 ),
        .D(acc[23]),
        .Q(\logits_reg[3] [23]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[3][24] 
       (.C(clk),
        .CE(\logits[3][31]_i_1_n_0 ),
        .D(acc[24]),
        .Q(\logits_reg[3] [24]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[3][25] 
       (.C(clk),
        .CE(\logits[3][31]_i_1_n_0 ),
        .D(acc[25]),
        .Q(\logits_reg[3] [25]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[3][26] 
       (.C(clk),
        .CE(\logits[3][31]_i_1_n_0 ),
        .D(acc[26]),
        .Q(\logits_reg[3] [26]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[3][27] 
       (.C(clk),
        .CE(\logits[3][31]_i_1_n_0 ),
        .D(acc[27]),
        .Q(\logits_reg[3] [27]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[3][28] 
       (.C(clk),
        .CE(\logits[3][31]_i_1_n_0 ),
        .D(acc[28]),
        .Q(\logits_reg[3] [28]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[3][29] 
       (.C(clk),
        .CE(\logits[3][31]_i_1_n_0 ),
        .D(acc[29]),
        .Q(\logits_reg[3] [29]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[3][2] 
       (.C(clk),
        .CE(\logits[3][31]_i_1_n_0 ),
        .D(acc[2]),
        .Q(\logits_reg[3] [2]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[3][30] 
       (.C(clk),
        .CE(\logits[3][31]_i_1_n_0 ),
        .D(acc[30]),
        .Q(\logits_reg[3] [30]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[3][31] 
       (.C(clk),
        .CE(\logits[3][31]_i_1_n_0 ),
        .D(acc[31]),
        .Q(\logits_reg[3] [31]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[3][3] 
       (.C(clk),
        .CE(\logits[3][31]_i_1_n_0 ),
        .D(acc[3]),
        .Q(\logits_reg[3] [3]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[3][4] 
       (.C(clk),
        .CE(\logits[3][31]_i_1_n_0 ),
        .D(acc[4]),
        .Q(\logits_reg[3] [4]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[3][5] 
       (.C(clk),
        .CE(\logits[3][31]_i_1_n_0 ),
        .D(acc[5]),
        .Q(\logits_reg[3] [5]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[3][6] 
       (.C(clk),
        .CE(\logits[3][31]_i_1_n_0 ),
        .D(acc[6]),
        .Q(\logits_reg[3] [6]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[3][7] 
       (.C(clk),
        .CE(\logits[3][31]_i_1_n_0 ),
        .D(acc[7]),
        .Q(\logits_reg[3] [7]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[3][8] 
       (.C(clk),
        .CE(\logits[3][31]_i_1_n_0 ),
        .D(acc[8]),
        .Q(\logits_reg[3] [8]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[3][9] 
       (.C(clk),
        .CE(\logits[3][31]_i_1_n_0 ),
        .D(acc[9]),
        .Q(\logits_reg[3] [9]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[4][0] 
       (.C(clk),
        .CE(\logits[4][31]_i_1_n_0 ),
        .D(acc[0]),
        .Q(\logits_reg[4] [0]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[4][10] 
       (.C(clk),
        .CE(\logits[4][31]_i_1_n_0 ),
        .D(acc[10]),
        .Q(\logits_reg[4] [10]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[4][11] 
       (.C(clk),
        .CE(\logits[4][31]_i_1_n_0 ),
        .D(acc[11]),
        .Q(\logits_reg[4] [11]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[4][12] 
       (.C(clk),
        .CE(\logits[4][31]_i_1_n_0 ),
        .D(acc[12]),
        .Q(\logits_reg[4] [12]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[4][13] 
       (.C(clk),
        .CE(\logits[4][31]_i_1_n_0 ),
        .D(acc[13]),
        .Q(\logits_reg[4] [13]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[4][14] 
       (.C(clk),
        .CE(\logits[4][31]_i_1_n_0 ),
        .D(acc[14]),
        .Q(\logits_reg[4] [14]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[4][15] 
       (.C(clk),
        .CE(\logits[4][31]_i_1_n_0 ),
        .D(acc[15]),
        .Q(\logits_reg[4] [15]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[4][16] 
       (.C(clk),
        .CE(\logits[4][31]_i_1_n_0 ),
        .D(acc[16]),
        .Q(\logits_reg[4] [16]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[4][17] 
       (.C(clk),
        .CE(\logits[4][31]_i_1_n_0 ),
        .D(acc[17]),
        .Q(\logits_reg[4] [17]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[4][18] 
       (.C(clk),
        .CE(\logits[4][31]_i_1_n_0 ),
        .D(acc[18]),
        .Q(\logits_reg[4] [18]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[4][19] 
       (.C(clk),
        .CE(\logits[4][31]_i_1_n_0 ),
        .D(acc[19]),
        .Q(\logits_reg[4] [19]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[4][1] 
       (.C(clk),
        .CE(\logits[4][31]_i_1_n_0 ),
        .D(acc[1]),
        .Q(\logits_reg[4] [1]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[4][20] 
       (.C(clk),
        .CE(\logits[4][31]_i_1_n_0 ),
        .D(acc[20]),
        .Q(\logits_reg[4] [20]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[4][21] 
       (.C(clk),
        .CE(\logits[4][31]_i_1_n_0 ),
        .D(acc[21]),
        .Q(\logits_reg[4] [21]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[4][22] 
       (.C(clk),
        .CE(\logits[4][31]_i_1_n_0 ),
        .D(acc[22]),
        .Q(\logits_reg[4] [22]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[4][23] 
       (.C(clk),
        .CE(\logits[4][31]_i_1_n_0 ),
        .D(acc[23]),
        .Q(\logits_reg[4] [23]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[4][24] 
       (.C(clk),
        .CE(\logits[4][31]_i_1_n_0 ),
        .D(acc[24]),
        .Q(\logits_reg[4] [24]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[4][25] 
       (.C(clk),
        .CE(\logits[4][31]_i_1_n_0 ),
        .D(acc[25]),
        .Q(\logits_reg[4] [25]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[4][26] 
       (.C(clk),
        .CE(\logits[4][31]_i_1_n_0 ),
        .D(acc[26]),
        .Q(\logits_reg[4] [26]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[4][27] 
       (.C(clk),
        .CE(\logits[4][31]_i_1_n_0 ),
        .D(acc[27]),
        .Q(\logits_reg[4] [27]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[4][28] 
       (.C(clk),
        .CE(\logits[4][31]_i_1_n_0 ),
        .D(acc[28]),
        .Q(\logits_reg[4] [28]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[4][29] 
       (.C(clk),
        .CE(\logits[4][31]_i_1_n_0 ),
        .D(acc[29]),
        .Q(\logits_reg[4] [29]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[4][2] 
       (.C(clk),
        .CE(\logits[4][31]_i_1_n_0 ),
        .D(acc[2]),
        .Q(\logits_reg[4] [2]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[4][30] 
       (.C(clk),
        .CE(\logits[4][31]_i_1_n_0 ),
        .D(acc[30]),
        .Q(\logits_reg[4] [30]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[4][31] 
       (.C(clk),
        .CE(\logits[4][31]_i_1_n_0 ),
        .D(acc[31]),
        .Q(\logits_reg[4] [31]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[4][3] 
       (.C(clk),
        .CE(\logits[4][31]_i_1_n_0 ),
        .D(acc[3]),
        .Q(\logits_reg[4] [3]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[4][4] 
       (.C(clk),
        .CE(\logits[4][31]_i_1_n_0 ),
        .D(acc[4]),
        .Q(\logits_reg[4] [4]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[4][5] 
       (.C(clk),
        .CE(\logits[4][31]_i_1_n_0 ),
        .D(acc[5]),
        .Q(\logits_reg[4] [5]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[4][6] 
       (.C(clk),
        .CE(\logits[4][31]_i_1_n_0 ),
        .D(acc[6]),
        .Q(\logits_reg[4] [6]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[4][7] 
       (.C(clk),
        .CE(\logits[4][31]_i_1_n_0 ),
        .D(acc[7]),
        .Q(\logits_reg[4] [7]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[4][8] 
       (.C(clk),
        .CE(\logits[4][31]_i_1_n_0 ),
        .D(acc[8]),
        .Q(\logits_reg[4] [8]),
        .R(out_valid_i_1_n_0));
  FDRE \logits_reg[4][9] 
       (.C(clk),
        .CE(\logits[4][31]_i_1_n_0 ),
        .D(acc[9]),
        .Q(\logits_reg[4] [9]),
        .R(out_valid_i_1_n_0));
  LUT6 #(
    .INIT(64'h0000020000000000)) 
    \n_in_r[31]_i_1 
       (.I0(rst_n),
        .I1(state[4]),
        .I2(state[3]),
        .I3(state[1]),
        .I4(state[2]),
        .I5(state[0]),
        .O(n_in_r));
  FDRE \n_in_r_reg[0] 
       (.C(clk),
        .CE(n_in_r),
        .D(bram_addr_reg_rep_0_n_35),
        .Q(\n_in_r_reg_n_0_[0] ),
        .R(1'b0));
  FDRE \n_in_r_reg[10] 
       (.C(clk),
        .CE(n_in_r),
        .D(bram_addr_reg_rep_0_n_25),
        .Q(\n_in_r_reg_n_0_[10] ),
        .R(1'b0));
  FDRE \n_in_r_reg[11] 
       (.C(clk),
        .CE(n_in_r),
        .D(bram_addr_reg_rep_0_n_24),
        .Q(\n_in_r_reg_n_0_[11] ),
        .R(1'b0));
  FDRE \n_in_r_reg[12] 
       (.C(clk),
        .CE(n_in_r),
        .D(bram_addr_reg_rep_0_n_23),
        .Q(\n_in_r_reg_n_0_[12] ),
        .R(1'b0));
  FDRE \n_in_r_reg[13] 
       (.C(clk),
        .CE(n_in_r),
        .D(bram_addr_reg_rep_0_n_22),
        .Q(\n_in_r_reg_n_0_[13] ),
        .R(1'b0));
  FDRE \n_in_r_reg[14] 
       (.C(clk),
        .CE(n_in_r),
        .D(bram_addr_reg_rep_0_n_21),
        .Q(\n_in_r_reg_n_0_[14] ),
        .R(1'b0));
  FDRE \n_in_r_reg[15] 
       (.C(clk),
        .CE(n_in_r),
        .D(bram_addr_reg_rep_0_n_20),
        .Q(\n_in_r_reg_n_0_[15] ),
        .R(1'b0));
  FDRE \n_in_r_reg[16] 
       (.C(clk),
        .CE(n_in_r),
        .D(bram_addr_reg_rep_1_n_35),
        .Q(\n_in_r_reg_n_0_[16] ),
        .R(1'b0));
  FDRE \n_in_r_reg[17] 
       (.C(clk),
        .CE(n_in_r),
        .D(bram_addr_reg_rep_1_n_34),
        .Q(\n_in_r_reg_n_0_[17] ),
        .R(1'b0));
  FDRE \n_in_r_reg[18] 
       (.C(clk),
        .CE(n_in_r),
        .D(bram_addr_reg_rep_1_n_33),
        .Q(\n_in_r_reg_n_0_[18] ),
        .R(1'b0));
  FDRE \n_in_r_reg[19] 
       (.C(clk),
        .CE(n_in_r),
        .D(bram_addr_reg_rep_1_n_32),
        .Q(\n_in_r_reg_n_0_[19] ),
        .R(1'b0));
  FDRE \n_in_r_reg[1] 
       (.C(clk),
        .CE(n_in_r),
        .D(bram_addr_reg_rep_0_n_34),
        .Q(\n_in_r_reg_n_0_[1] ),
        .R(1'b0));
  FDRE \n_in_r_reg[20] 
       (.C(clk),
        .CE(n_in_r),
        .D(bram_addr_reg_rep_1_n_31),
        .Q(\n_in_r_reg_n_0_[20] ),
        .R(1'b0));
  FDRE \n_in_r_reg[21] 
       (.C(clk),
        .CE(n_in_r),
        .D(bram_addr_reg_rep_1_n_30),
        .Q(\n_in_r_reg_n_0_[21] ),
        .R(1'b0));
  FDRE \n_in_r_reg[22] 
       (.C(clk),
        .CE(n_in_r),
        .D(bram_addr_reg_rep_1_n_29),
        .Q(\n_in_r_reg_n_0_[22] ),
        .R(1'b0));
  FDRE \n_in_r_reg[23] 
       (.C(clk),
        .CE(n_in_r),
        .D(bram_addr_reg_rep_1_n_28),
        .Q(\n_in_r_reg_n_0_[23] ),
        .R(1'b0));
  FDRE \n_in_r_reg[24] 
       (.C(clk),
        .CE(n_in_r),
        .D(bram_addr_reg_rep_1_n_27),
        .Q(\n_in_r_reg_n_0_[24] ),
        .R(1'b0));
  FDRE \n_in_r_reg[25] 
       (.C(clk),
        .CE(n_in_r),
        .D(bram_addr_reg_rep_1_n_26),
        .Q(\n_in_r_reg_n_0_[25] ),
        .R(1'b0));
  FDRE \n_in_r_reg[26] 
       (.C(clk),
        .CE(n_in_r),
        .D(bram_addr_reg_rep_1_n_25),
        .Q(\n_in_r_reg_n_0_[26] ),
        .R(1'b0));
  FDRE \n_in_r_reg[27] 
       (.C(clk),
        .CE(n_in_r),
        .D(bram_addr_reg_rep_1_n_24),
        .Q(\n_in_r_reg_n_0_[27] ),
        .R(1'b0));
  FDRE \n_in_r_reg[28] 
       (.C(clk),
        .CE(n_in_r),
        .D(bram_addr_reg_rep_1_n_23),
        .Q(\n_in_r_reg_n_0_[28] ),
        .R(1'b0));
  FDRE \n_in_r_reg[29] 
       (.C(clk),
        .CE(n_in_r),
        .D(bram_addr_reg_rep_1_n_22),
        .Q(\n_in_r_reg_n_0_[29] ),
        .R(1'b0));
  FDRE \n_in_r_reg[2] 
       (.C(clk),
        .CE(n_in_r),
        .D(bram_addr_reg_rep_0_n_33),
        .Q(\n_in_r_reg_n_0_[2] ),
        .R(1'b0));
  FDRE \n_in_r_reg[30] 
       (.C(clk),
        .CE(n_in_r),
        .D(bram_addr_reg_rep_1_n_21),
        .Q(\n_in_r_reg_n_0_[30] ),
        .R(1'b0));
  FDRE \n_in_r_reg[31] 
       (.C(clk),
        .CE(n_in_r),
        .D(bram_addr_reg_rep_1_n_20),
        .Q(\n_in_r_reg_n_0_[31] ),
        .R(1'b0));
  FDRE \n_in_r_reg[3] 
       (.C(clk),
        .CE(n_in_r),
        .D(bram_addr_reg_rep_0_n_32),
        .Q(\n_in_r_reg_n_0_[3] ),
        .R(1'b0));
  FDRE \n_in_r_reg[4] 
       (.C(clk),
        .CE(n_in_r),
        .D(bram_addr_reg_rep_0_n_31),
        .Q(\n_in_r_reg_n_0_[4] ),
        .R(1'b0));
  FDRE \n_in_r_reg[5] 
       (.C(clk),
        .CE(n_in_r),
        .D(bram_addr_reg_rep_0_n_30),
        .Q(\n_in_r_reg_n_0_[5] ),
        .R(1'b0));
  FDRE \n_in_r_reg[6] 
       (.C(clk),
        .CE(n_in_r),
        .D(bram_addr_reg_rep_0_n_29),
        .Q(\n_in_r_reg_n_0_[6] ),
        .R(1'b0));
  FDRE \n_in_r_reg[7] 
       (.C(clk),
        .CE(n_in_r),
        .D(bram_addr_reg_rep_0_n_28),
        .Q(\n_in_r_reg_n_0_[7] ),
        .R(1'b0));
  FDRE \n_in_r_reg[8] 
       (.C(clk),
        .CE(n_in_r),
        .D(bram_addr_reg_rep_0_n_27),
        .Q(\n_in_r_reg_n_0_[8] ),
        .R(1'b0));
  FDRE \n_in_r_reg[9] 
       (.C(clk),
        .CE(n_in_r),
        .D(bram_addr_reg_rep_0_n_26),
        .Q(\n_in_r_reg_n_0_[9] ),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair81" *) 
  LUT3 #(
    .INIT(8'h01)) 
    \neuron[0]_i_1 
       (.I0(state[2]),
        .I1(p_0_in[4]),
        .I2(\FSM_sequential_state[4]_i_5_n_0 ),
        .O(\neuron[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT4 #(
    .INIT(16'h0014)) 
    \neuron[1]_i_1 
       (.I0(state[2]),
        .I1(p_0_in[5]),
        .I2(p_0_in[4]),
        .I3(\FSM_sequential_state[4]_i_5_n_0 ),
        .O(\neuron[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT5 #(
    .INIT(32'h00001444)) 
    \neuron[2]_i_1 
       (.I0(state[2]),
        .I1(p_0_in[6]),
        .I2(p_0_in[5]),
        .I3(p_0_in[4]),
        .I4(\FSM_sequential_state[4]_i_5_n_0 ),
        .O(\neuron[2]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h00001444)) 
    \neuron[3]_i_1 
       (.I0(state[2]),
        .I1(p_0_in[7]),
        .I2(p_0_in[6]),
        .I3(\logits[3][31]_i_2_n_0 ),
        .I4(\FSM_sequential_state[4]_i_5_n_0 ),
        .O(\neuron[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT4 #(
    .INIT(16'h0014)) 
    \neuron[4]_i_1 
       (.I0(state[2]),
        .I1(p_0_in[8]),
        .I2(\neuron[5]_i_2_n_0 ),
        .I3(\FSM_sequential_state[4]_i_5_n_0 ),
        .O(\neuron[4]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT5 #(
    .INIT(32'h00001444)) 
    \neuron[5]_i_1 
       (.I0(state[2]),
        .I1(p_0_in[9]),
        .I2(p_0_in[8]),
        .I3(\neuron[5]_i_2_n_0 ),
        .I4(\FSM_sequential_state[4]_i_5_n_0 ),
        .O(\neuron[5]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT4 #(
    .INIT(16'h8000)) 
    \neuron[5]_i_2 
       (.I0(p_0_in[7]),
        .I1(p_0_in[5]),
        .I2(p_0_in[4]),
        .I3(p_0_in[6]),
        .O(\neuron[5]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000062)) 
    \neuron[6]_i_1 
       (.I0(state[4]),
        .I1(state[2]),
        .I2(\word_idx[4]_i_4_n_0 ),
        .I3(state[1]),
        .I4(state[0]),
        .I5(state[3]),
        .O(neuron));
  LUT5 #(
    .INIT(32'h00001444)) 
    \neuron[6]_i_2 
       (.I0(state[2]),
        .I1(p_0_in[10]),
        .I2(p_0_in[9]),
        .I3(\neuron[6]_i_3_n_0 ),
        .I4(\FSM_sequential_state[4]_i_5_n_0 ),
        .O(\neuron[6]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT5 #(
    .INIT(32'h80000000)) 
    \neuron[6]_i_3 
       (.I0(p_0_in[8]),
        .I1(p_0_in[6]),
        .I2(p_0_in[4]),
        .I3(p_0_in[5]),
        .I4(p_0_in[7]),
        .O(\neuron[6]_i_3_n_0 ));
  FDRE \neuron_reg[0] 
       (.C(clk),
        .CE(neuron),
        .D(\neuron[0]_i_1_n_0 ),
        .Q(p_0_in[4]),
        .R(out_valid_i_1_n_0));
  FDRE \neuron_reg[1] 
       (.C(clk),
        .CE(neuron),
        .D(\neuron[1]_i_1_n_0 ),
        .Q(p_0_in[5]),
        .R(out_valid_i_1_n_0));
  FDRE \neuron_reg[2] 
       (.C(clk),
        .CE(neuron),
        .D(\neuron[2]_i_1_n_0 ),
        .Q(p_0_in[6]),
        .R(out_valid_i_1_n_0));
  FDRE \neuron_reg[3] 
       (.C(clk),
        .CE(neuron),
        .D(\neuron[3]_i_1_n_0 ),
        .Q(p_0_in[7]),
        .R(out_valid_i_1_n_0));
  FDRE \neuron_reg[4] 
       (.C(clk),
        .CE(neuron),
        .D(\neuron[4]_i_1_n_0 ),
        .Q(p_0_in[8]),
        .R(out_valid_i_1_n_0));
  FDRE \neuron_reg[5] 
       (.C(clk),
        .CE(neuron),
        .D(\neuron[5]_i_1_n_0 ),
        .Q(p_0_in[9]),
        .R(out_valid_i_1_n_0));
  FDRE \neuron_reg[6] 
       (.C(clk),
        .CE(neuron),
        .D(\neuron[6]_i_2_n_0 ),
        .Q(p_0_in[10]),
        .R(out_valid_i_1_n_0));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-10 {cell *THIS*} {string 16x18 4}}" *) 
  DSP48E1 #(
    .ACASCREG(1),
    .ADREG(1),
    .ALUMODEREG(0),
    .AREG(1),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(1),
    .BREG(1),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(1),
    .DREG(1),
    .INMODEREG(0),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREG(0),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_DPORT("FALSE"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48")) 
    norm_prod0
       (.A({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bram_addr_reg_rep_1_n_35,bram_addr_reg_rep_0_n_20,bram_addr_reg_rep_0_n_21,bram_addr_reg_rep_0_n_22,bram_addr_reg_rep_0_n_23,bram_addr_reg_rep_0_n_24,bram_addr_reg_rep_0_n_25,bram_addr_reg_rep_0_n_26,bram_addr_reg_rep_0_n_27,bram_addr_reg_rep_0_n_28,bram_addr_reg_rep_0_n_29,bram_addr_reg_rep_0_n_30,bram_addr_reg_rep_0_n_31,bram_addr_reg_rep_0_n_32,bram_addr_reg_rep_0_n_33,bram_addr_reg_rep_0_n_34,bram_addr_reg_rep_0_n_35}),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT(NLW_norm_prod0_ACOUT_UNCONNECTED[29:0]),
        .ALUMODE({1'b0,1'b0,1'b0,1'b0}),
        .B({1'b0,1'b0,1'b0,feat_data[31:17]}),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(NLW_norm_prod0_BCOUT_UNCONNECTED[17:0]),
        .C({1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(NLW_norm_prod0_CARRYCASCOUT_UNCONNECTED),
        .CARRYIN(1'b0),
        .CARRYINSEL({1'b0,1'b0,1'b0}),
        .CARRYOUT(NLW_norm_prod0_CARRYOUT_UNCONNECTED[3:0]),
        .CEA1(1'b0),
        .CEA2(m_in_r),
        .CEAD(1'b0),
        .CEALUMODE(1'b0),
        .CEB1(1'b0),
        .CEB2(feat_save_idx__0),
        .CEC(1'b0),
        .CECARRYIN(1'b0),
        .CECTRL(1'b0),
        .CED(1'b0),
        .CEINMODE(1'b0),
        .CEM(1'b0),
        .CEP(1'b0),
        .CLK(clk),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .INMODE({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .MULTSIGNIN(1'b0),
        .MULTSIGNOUT(NLW_norm_prod0_MULTSIGNOUT_UNCONNECTED),
        .OPMODE({1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,1'b1}),
        .OVERFLOW(NLW_norm_prod0_OVERFLOW_UNCONNECTED),
        .P({norm_prod0_n_58,norm_prod0_n_59,norm_prod0_n_60,norm_prod0_n_61,norm_prod0_n_62,norm_prod0_n_63,norm_prod0_n_64,norm_prod0_n_65,norm_prod0_n_66,norm_prod0_n_67,norm_prod0_n_68,norm_prod0_n_69,norm_prod0_n_70,norm_prod0_n_71,norm_prod0_n_72,norm_prod0_n_73,norm_prod0_n_74,norm_prod0_n_75,norm_prod0_n_76,norm_prod0_n_77,norm_prod0_n_78,norm_prod0_n_79,norm_prod0_n_80,norm_prod0_n_81,norm_prod0_n_82,norm_prod0_n_83,norm_prod0_n_84,norm_prod0_n_85,norm_prod0_n_86,norm_prod0_n_87,norm_prod0_n_88,norm_prod0_n_89,norm_prod0_n_90,norm_prod0_n_91,norm_prod0_n_92,norm_prod0_n_93,norm_prod0_n_94,norm_prod0_n_95,norm_prod0_n_96,norm_prod0_n_97,norm_prod0_n_98,norm_prod0_n_99,norm_prod0_n_100,norm_prod0_n_101,norm_prod0_n_102,norm_prod0_n_103,norm_prod0_n_104,norm_prod0_n_105}),
        .PATTERNBDETECT(NLW_norm_prod0_PATTERNBDETECT_UNCONNECTED),
        .PATTERNDETECT(NLW_norm_prod0_PATTERNDETECT_UNCONNECTED),
        .PCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .PCOUT({norm_prod0_n_106,norm_prod0_n_107,norm_prod0_n_108,norm_prod0_n_109,norm_prod0_n_110,norm_prod0_n_111,norm_prod0_n_112,norm_prod0_n_113,norm_prod0_n_114,norm_prod0_n_115,norm_prod0_n_116,norm_prod0_n_117,norm_prod0_n_118,norm_prod0_n_119,norm_prod0_n_120,norm_prod0_n_121,norm_prod0_n_122,norm_prod0_n_123,norm_prod0_n_124,norm_prod0_n_125,norm_prod0_n_126,norm_prod0_n_127,norm_prod0_n_128,norm_prod0_n_129,norm_prod0_n_130,norm_prod0_n_131,norm_prod0_n_132,norm_prod0_n_133,norm_prod0_n_134,norm_prod0_n_135,norm_prod0_n_136,norm_prod0_n_137,norm_prod0_n_138,norm_prod0_n_139,norm_prod0_n_140,norm_prod0_n_141,norm_prod0_n_142,norm_prod0_n_143,norm_prod0_n_144,norm_prod0_n_145,norm_prod0_n_146,norm_prod0_n_147,norm_prod0_n_148,norm_prod0_n_149,norm_prod0_n_150,norm_prod0_n_151,norm_prod0_n_152,norm_prod0_n_153}),
        .RSTA(out_valid_i_1_n_0),
        .RSTALLCARRYIN(1'b0),
        .RSTALUMODE(1'b0),
        .RSTB(out_valid_i_1_n_0),
        .RSTC(1'b0),
        .RSTCTRL(1'b0),
        .RSTD(1'b0),
        .RSTINMODE(1'b0),
        .RSTM(1'b0),
        .RSTP(1'b0),
        .UNDERFLOW(NLW_norm_prod0_UNDERFLOW_UNCONNECTED));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-10 {cell *THIS*} {string 18x18 4}}" *) 
  DSP48E1 #(
    .ACASCREG(1),
    .ADREG(1),
    .ALUMODEREG(0),
    .AREG(1),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(1),
    .BREG(1),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(1),
    .DREG(1),
    .INMODEREG(0),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREG(0),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_DPORT("FALSE"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48")) 
    norm_prod0__0
       (.A({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,feat_data[16:0]}),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT({norm_prod0__0_n_24,norm_prod0__0_n_25,norm_prod0__0_n_26,norm_prod0__0_n_27,norm_prod0__0_n_28,norm_prod0__0_n_29,norm_prod0__0_n_30,norm_prod0__0_n_31,norm_prod0__0_n_32,norm_prod0__0_n_33,norm_prod0__0_n_34,norm_prod0__0_n_35,norm_prod0__0_n_36,norm_prod0__0_n_37,norm_prod0__0_n_38,norm_prod0__0_n_39,norm_prod0__0_n_40,norm_prod0__0_n_41,norm_prod0__0_n_42,norm_prod0__0_n_43,norm_prod0__0_n_44,norm_prod0__0_n_45,norm_prod0__0_n_46,norm_prod0__0_n_47,norm_prod0__0_n_48,norm_prod0__0_n_49,norm_prod0__0_n_50,norm_prod0__0_n_51,norm_prod0__0_n_52,norm_prod0__0_n_53}),
        .ALUMODE({1'b0,1'b0,1'b0,1'b0}),
        .B({1'b0,bram_addr_reg_rep_1_n_35,bram_addr_reg_rep_0_n_20,bram_addr_reg_rep_0_n_21,bram_addr_reg_rep_0_n_22,bram_addr_reg_rep_0_n_23,bram_addr_reg_rep_0_n_24,bram_addr_reg_rep_0_n_25,bram_addr_reg_rep_0_n_26,bram_addr_reg_rep_0_n_27,bram_addr_reg_rep_0_n_28,bram_addr_reg_rep_0_n_29,bram_addr_reg_rep_0_n_30,bram_addr_reg_rep_0_n_31,bram_addr_reg_rep_0_n_32,bram_addr_reg_rep_0_n_33,bram_addr_reg_rep_0_n_34,bram_addr_reg_rep_0_n_35}),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(NLW_norm_prod0__0_BCOUT_UNCONNECTED[17:0]),
        .C({1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(NLW_norm_prod0__0_CARRYCASCOUT_UNCONNECTED),
        .CARRYIN(1'b0),
        .CARRYINSEL({1'b0,1'b0,1'b0}),
        .CARRYOUT(NLW_norm_prod0__0_CARRYOUT_UNCONNECTED[3:0]),
        .CEA1(1'b0),
        .CEA2(feat_save_idx__0),
        .CEAD(1'b0),
        .CEALUMODE(1'b0),
        .CEB1(1'b0),
        .CEB2(m_in_r),
        .CEC(1'b0),
        .CECARRYIN(1'b0),
        .CECTRL(1'b0),
        .CED(1'b0),
        .CEINMODE(1'b0),
        .CEM(1'b0),
        .CEP(1'b0),
        .CLK(clk),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .INMODE({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .MULTSIGNIN(1'b0),
        .MULTSIGNOUT(NLW_norm_prod0__0_MULTSIGNOUT_UNCONNECTED),
        .OPMODE({1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,1'b1}),
        .OVERFLOW(NLW_norm_prod0__0_OVERFLOW_UNCONNECTED),
        .P({norm_prod0__0_n_58,norm_prod0__0_n_59,norm_prod0__0_n_60,norm_prod0__0_n_61,norm_prod0__0_n_62,norm_prod0__0_n_63,norm_prod0__0_n_64,norm_prod0__0_n_65,norm_prod0__0_n_66,norm_prod0__0_n_67,norm_prod0__0_n_68,norm_prod0__0_n_69,norm_prod0__0_n_70,norm_prod0__0_n_71,norm_prod0__0_n_72,norm_prod0__0_n_73,norm_prod0__0_n_74,norm_prod0__0_n_75,norm_prod0__0_n_76,norm_prod0__0_n_77,norm_prod0__0_n_78,norm_prod0__0_n_79,norm_prod0__0_n_80,norm_prod0__0_n_81,norm_prod0__0_n_82,norm_prod0__0_n_83,norm_prod0__0_n_84,norm_prod0__0_n_85,norm_prod0__0_n_86,norm_prod0__0_n_87,norm_prod0__0_n_88,norm_prod0__0_n_89,norm_prod0__0_n_90,norm_prod0__0_n_91,norm_prod0__0_n_92,norm_prod0__0_n_93,norm_prod0__0_n_94,norm_prod0__0_n_95,norm_prod0__0_n_96,norm_prod0__0_n_97,norm_prod0__0_n_98,norm_prod0__0_n_99,norm_prod0__0_n_100,norm_prod0__0_n_101,norm_prod0__0_n_102,norm_prod0__0_n_103,norm_prod0__0_n_104,norm_prod0__0_n_105}),
        .PATTERNBDETECT(NLW_norm_prod0__0_PATTERNBDETECT_UNCONNECTED),
        .PATTERNDETECT(NLW_norm_prod0__0_PATTERNDETECT_UNCONNECTED),
        .PCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .PCOUT({norm_prod0__0_n_106,norm_prod0__0_n_107,norm_prod0__0_n_108,norm_prod0__0_n_109,norm_prod0__0_n_110,norm_prod0__0_n_111,norm_prod0__0_n_112,norm_prod0__0_n_113,norm_prod0__0_n_114,norm_prod0__0_n_115,norm_prod0__0_n_116,norm_prod0__0_n_117,norm_prod0__0_n_118,norm_prod0__0_n_119,norm_prod0__0_n_120,norm_prod0__0_n_121,norm_prod0__0_n_122,norm_prod0__0_n_123,norm_prod0__0_n_124,norm_prod0__0_n_125,norm_prod0__0_n_126,norm_prod0__0_n_127,norm_prod0__0_n_128,norm_prod0__0_n_129,norm_prod0__0_n_130,norm_prod0__0_n_131,norm_prod0__0_n_132,norm_prod0__0_n_133,norm_prod0__0_n_134,norm_prod0__0_n_135,norm_prod0__0_n_136,norm_prod0__0_n_137,norm_prod0__0_n_138,norm_prod0__0_n_139,norm_prod0__0_n_140,norm_prod0__0_n_141,norm_prod0__0_n_142,norm_prod0__0_n_143,norm_prod0__0_n_144,norm_prod0__0_n_145,norm_prod0__0_n_146,norm_prod0__0_n_147,norm_prod0__0_n_148,norm_prod0__0_n_149,norm_prod0__0_n_150,norm_prod0__0_n_151,norm_prod0__0_n_152,norm_prod0__0_n_153}),
        .RSTA(out_valid_i_1_n_0),
        .RSTALLCARRYIN(1'b0),
        .RSTALUMODE(1'b0),
        .RSTB(out_valid_i_1_n_0),
        .RSTC(1'b0),
        .RSTCTRL(1'b0),
        .RSTD(1'b0),
        .RSTINMODE(1'b0),
        .RSTM(1'b0),
        .RSTP(1'b0),
        .UNDERFLOW(NLW_norm_prod0__0_UNDERFLOW_UNCONNECTED));
  LUT5 #(
    .INIT(32'h00000002)) 
    norm_prod0_i_1
       (.I0(state[1]),
        .I1(state[2]),
        .I2(state[0]),
        .I3(state[3]),
        .I4(state[4]),
        .O(m_in_r));
  LUT5 #(
    .INIT(32'h00000020)) 
    \norm_prod[16]_i_1 
       (.I0(state[0]),
        .I1(state[2]),
        .I2(state[1]),
        .I3(state[3]),
        .I4(state[4]),
        .O(norm_prod));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-10 {cell *THIS*} {string 16x16 4}}" *) 
  DSP48E1 #(
    .ACASCREG(1),
    .ADREG(1),
    .ALUMODEREG(0),
    .AREG(1),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(1),
    .BREG(1),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(1),
    .DREG(1),
    .INMODEREG(0),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREG(1),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_DPORT("FALSE"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48")) 
    norm_prod_reg
       (.A({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,feat_data[31:17]}),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT(NLW_norm_prod_reg_ACOUT_UNCONNECTED[29:0]),
        .ALUMODE({1'b0,1'b0,1'b0,1'b0}),
        .B({1'b0,1'b0,1'b0,bram_addr_reg_rep_1_n_20,bram_addr_reg_rep_1_n_21,bram_addr_reg_rep_1_n_22,bram_addr_reg_rep_1_n_23,bram_addr_reg_rep_1_n_24,bram_addr_reg_rep_1_n_25,bram_addr_reg_rep_1_n_26,bram_addr_reg_rep_1_n_27,bram_addr_reg_rep_1_n_28,bram_addr_reg_rep_1_n_29,bram_addr_reg_rep_1_n_30,bram_addr_reg_rep_1_n_31,bram_addr_reg_rep_1_n_32,bram_addr_reg_rep_1_n_33,bram_addr_reg_rep_1_n_34}),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(NLW_norm_prod_reg_BCOUT_UNCONNECTED[17:0]),
        .C({1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(NLW_norm_prod_reg_CARRYCASCOUT_UNCONNECTED),
        .CARRYIN(1'b0),
        .CARRYINSEL({1'b0,1'b0,1'b0}),
        .CARRYOUT(NLW_norm_prod_reg_CARRYOUT_UNCONNECTED[3:0]),
        .CEA1(1'b0),
        .CEA2(feat_save_idx__0),
        .CEAD(1'b0),
        .CEALUMODE(1'b0),
        .CEB1(1'b0),
        .CEB2(m_in_r),
        .CEC(1'b0),
        .CECARRYIN(1'b0),
        .CECTRL(1'b0),
        .CED(1'b0),
        .CEINMODE(1'b0),
        .CEM(1'b0),
        .CEP(norm_prod),
        .CLK(clk),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .INMODE({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .MULTSIGNIN(1'b0),
        .MULTSIGNOUT(NLW_norm_prod_reg_MULTSIGNOUT_UNCONNECTED),
        .OPMODE({1'b1,1'b0,1'b1,1'b0,1'b1,1'b0,1'b1}),
        .OVERFLOW(NLW_norm_prod_reg_OVERFLOW_UNCONNECTED),
        .P({norm_prod_reg_n_58,norm_prod_reg_n_59,norm_prod_reg_n_60,norm_prod_reg_n_61,norm_prod_reg_n_62,norm_prod_reg_n_63,norm_prod_reg_n_64,norm_prod_reg_n_65,norm_prod_reg_n_66,norm_prod_reg_n_67,norm_prod_reg_n_68,norm_prod_reg_n_69,norm_prod_reg_n_70,norm_prod_reg_n_71,norm_prod_reg_n_72,norm_prod_reg_n_73,norm_prod_reg_n_74,norm_prod_reg_n_75,norm_prod_reg_n_76,norm_prod_reg_n_77,norm_prod_reg_n_78,norm_prod_reg_n_79,norm_prod_reg_n_80,norm_prod_reg_n_81,norm_prod_reg_n_82,norm_prod_reg_n_83,norm_prod_reg_n_84,norm_prod_reg_n_85,norm_prod_reg_n_86,norm_prod_reg_n_87,norm_prod_reg_n_88,norm_prod_reg_n_89,norm_prod_reg_n_90,norm_prod_reg_n_91,norm_prod_reg_n_92,norm_prod_reg_n_93,norm_prod_reg_n_94,norm_prod_reg_n_95,norm_prod_reg_n_96,norm_prod_reg_n_97,norm_prod_reg_n_98,norm_prod_reg_n_99,norm_prod_reg_n_100,norm_prod_reg_n_101,norm_prod_reg_n_102,norm_prod_reg_n_103,norm_prod_reg_n_104,norm_prod_reg_n_105}),
        .PATTERNBDETECT(NLW_norm_prod_reg_PATTERNBDETECT_UNCONNECTED),
        .PATTERNDETECT(NLW_norm_prod_reg_PATTERNDETECT_UNCONNECTED),
        .PCIN({norm_prod0_n_106,norm_prod0_n_107,norm_prod0_n_108,norm_prod0_n_109,norm_prod0_n_110,norm_prod0_n_111,norm_prod0_n_112,norm_prod0_n_113,norm_prod0_n_114,norm_prod0_n_115,norm_prod0_n_116,norm_prod0_n_117,norm_prod0_n_118,norm_prod0_n_119,norm_prod0_n_120,norm_prod0_n_121,norm_prod0_n_122,norm_prod0_n_123,norm_prod0_n_124,norm_prod0_n_125,norm_prod0_n_126,norm_prod0_n_127,norm_prod0_n_128,norm_prod0_n_129,norm_prod0_n_130,norm_prod0_n_131,norm_prod0_n_132,norm_prod0_n_133,norm_prod0_n_134,norm_prod0_n_135,norm_prod0_n_136,norm_prod0_n_137,norm_prod0_n_138,norm_prod0_n_139,norm_prod0_n_140,norm_prod0_n_141,norm_prod0_n_142,norm_prod0_n_143,norm_prod0_n_144,norm_prod0_n_145,norm_prod0_n_146,norm_prod0_n_147,norm_prod0_n_148,norm_prod0_n_149,norm_prod0_n_150,norm_prod0_n_151,norm_prod0_n_152,norm_prod0_n_153}),
        .PCOUT(NLW_norm_prod_reg_PCOUT_UNCONNECTED[47:0]),
        .RSTA(out_valid_i_1_n_0),
        .RSTALLCARRYIN(1'b0),
        .RSTALUMODE(1'b0),
        .RSTB(out_valid_i_1_n_0),
        .RSTC(1'b0),
        .RSTCTRL(1'b0),
        .RSTD(1'b0),
        .RSTINMODE(1'b0),
        .RSTM(1'b0),
        .RSTP(out_valid_i_1_n_0),
        .UNDERFLOW(NLW_norm_prod_reg_UNDERFLOW_UNCONNECTED));
  FDRE \norm_prod_reg[0] 
       (.C(clk),
        .CE(norm_prod),
        .D(norm_prod0_n_105),
        .Q(\norm_prod_reg_n_0_[0] ),
        .R(out_valid_i_1_n_0));
  FDRE \norm_prod_reg[0]__0 
       (.C(clk),
        .CE(norm_prod),
        .D(norm_prod0__0_n_105),
        .Q(\norm_prod_reg[0]__0_n_0 ),
        .R(out_valid_i_1_n_0));
  FDRE \norm_prod_reg[10] 
       (.C(clk),
        .CE(norm_prod),
        .D(norm_prod0_n_95),
        .Q(\norm_prod_reg_n_0_[10] ),
        .R(out_valid_i_1_n_0));
  FDRE \norm_prod_reg[10]__0 
       (.C(clk),
        .CE(norm_prod),
        .D(norm_prod0__0_n_95),
        .Q(\norm_prod_reg[10]__0_n_0 ),
        .R(out_valid_i_1_n_0));
  FDRE \norm_prod_reg[11] 
       (.C(clk),
        .CE(norm_prod),
        .D(norm_prod0_n_94),
        .Q(\norm_prod_reg_n_0_[11] ),
        .R(out_valid_i_1_n_0));
  FDRE \norm_prod_reg[11]__0 
       (.C(clk),
        .CE(norm_prod),
        .D(norm_prod0__0_n_94),
        .Q(\norm_prod_reg[11]__0_n_0 ),
        .R(out_valid_i_1_n_0));
  FDRE \norm_prod_reg[12] 
       (.C(clk),
        .CE(norm_prod),
        .D(norm_prod0_n_93),
        .Q(\norm_prod_reg_n_0_[12] ),
        .R(out_valid_i_1_n_0));
  FDRE \norm_prod_reg[12]__0 
       (.C(clk),
        .CE(norm_prod),
        .D(norm_prod0__0_n_93),
        .Q(\norm_prod_reg[12]__0_n_0 ),
        .R(out_valid_i_1_n_0));
  FDRE \norm_prod_reg[13] 
       (.C(clk),
        .CE(norm_prod),
        .D(norm_prod0_n_92),
        .Q(\norm_prod_reg_n_0_[13] ),
        .R(out_valid_i_1_n_0));
  FDRE \norm_prod_reg[13]__0 
       (.C(clk),
        .CE(norm_prod),
        .D(norm_prod0__0_n_92),
        .Q(\norm_prod_reg[13]__0_n_0 ),
        .R(out_valid_i_1_n_0));
  FDRE \norm_prod_reg[14] 
       (.C(clk),
        .CE(norm_prod),
        .D(norm_prod0_n_91),
        .Q(\norm_prod_reg_n_0_[14] ),
        .R(out_valid_i_1_n_0));
  FDRE \norm_prod_reg[14]__0 
       (.C(clk),
        .CE(norm_prod),
        .D(norm_prod0__0_n_91),
        .Q(\norm_prod_reg[14]__0_n_0 ),
        .R(out_valid_i_1_n_0));
  FDRE \norm_prod_reg[15] 
       (.C(clk),
        .CE(norm_prod),
        .D(norm_prod0_n_90),
        .Q(\norm_prod_reg_n_0_[15] ),
        .R(out_valid_i_1_n_0));
  FDRE \norm_prod_reg[15]__0 
       (.C(clk),
        .CE(norm_prod),
        .D(norm_prod0__0_n_90),
        .Q(\norm_prod_reg[15]__0_n_0 ),
        .R(out_valid_i_1_n_0));
  FDRE \norm_prod_reg[16] 
       (.C(clk),
        .CE(norm_prod),
        .D(norm_prod0_n_89),
        .Q(\norm_prod_reg_n_0_[16] ),
        .R(out_valid_i_1_n_0));
  FDRE \norm_prod_reg[16]__0 
       (.C(clk),
        .CE(norm_prod),
        .D(norm_prod0__0_n_89),
        .Q(\norm_prod_reg[16]__0_n_0 ),
        .R(out_valid_i_1_n_0));
  FDRE \norm_prod_reg[1] 
       (.C(clk),
        .CE(norm_prod),
        .D(norm_prod0_n_104),
        .Q(\norm_prod_reg_n_0_[1] ),
        .R(out_valid_i_1_n_0));
  FDRE \norm_prod_reg[1]__0 
       (.C(clk),
        .CE(norm_prod),
        .D(norm_prod0__0_n_104),
        .Q(\norm_prod_reg[1]__0_n_0 ),
        .R(out_valid_i_1_n_0));
  FDRE \norm_prod_reg[2] 
       (.C(clk),
        .CE(norm_prod),
        .D(norm_prod0_n_103),
        .Q(\norm_prod_reg_n_0_[2] ),
        .R(out_valid_i_1_n_0));
  FDRE \norm_prod_reg[2]__0 
       (.C(clk),
        .CE(norm_prod),
        .D(norm_prod0__0_n_103),
        .Q(\norm_prod_reg[2]__0_n_0 ),
        .R(out_valid_i_1_n_0));
  FDRE \norm_prod_reg[3] 
       (.C(clk),
        .CE(norm_prod),
        .D(norm_prod0_n_102),
        .Q(\norm_prod_reg_n_0_[3] ),
        .R(out_valid_i_1_n_0));
  FDRE \norm_prod_reg[3]__0 
       (.C(clk),
        .CE(norm_prod),
        .D(norm_prod0__0_n_102),
        .Q(\norm_prod_reg[3]__0_n_0 ),
        .R(out_valid_i_1_n_0));
  FDRE \norm_prod_reg[4] 
       (.C(clk),
        .CE(norm_prod),
        .D(norm_prod0_n_101),
        .Q(\norm_prod_reg_n_0_[4] ),
        .R(out_valid_i_1_n_0));
  FDRE \norm_prod_reg[4]__0 
       (.C(clk),
        .CE(norm_prod),
        .D(norm_prod0__0_n_101),
        .Q(\norm_prod_reg[4]__0_n_0 ),
        .R(out_valid_i_1_n_0));
  FDRE \norm_prod_reg[5] 
       (.C(clk),
        .CE(norm_prod),
        .D(norm_prod0_n_100),
        .Q(\norm_prod_reg_n_0_[5] ),
        .R(out_valid_i_1_n_0));
  FDRE \norm_prod_reg[5]__0 
       (.C(clk),
        .CE(norm_prod),
        .D(norm_prod0__0_n_100),
        .Q(\norm_prod_reg[5]__0_n_0 ),
        .R(out_valid_i_1_n_0));
  FDRE \norm_prod_reg[6] 
       (.C(clk),
        .CE(norm_prod),
        .D(norm_prod0_n_99),
        .Q(\norm_prod_reg_n_0_[6] ),
        .R(out_valid_i_1_n_0));
  FDRE \norm_prod_reg[6]__0 
       (.C(clk),
        .CE(norm_prod),
        .D(norm_prod0__0_n_99),
        .Q(\norm_prod_reg[6]__0_n_0 ),
        .R(out_valid_i_1_n_0));
  FDRE \norm_prod_reg[7] 
       (.C(clk),
        .CE(norm_prod),
        .D(norm_prod0_n_98),
        .Q(\norm_prod_reg_n_0_[7] ),
        .R(out_valid_i_1_n_0));
  FDRE \norm_prod_reg[7]__0 
       (.C(clk),
        .CE(norm_prod),
        .D(norm_prod0__0_n_98),
        .Q(\norm_prod_reg[7]__0_n_0 ),
        .R(out_valid_i_1_n_0));
  FDRE \norm_prod_reg[8] 
       (.C(clk),
        .CE(norm_prod),
        .D(norm_prod0_n_97),
        .Q(\norm_prod_reg_n_0_[8] ),
        .R(out_valid_i_1_n_0));
  FDRE \norm_prod_reg[8]__0 
       (.C(clk),
        .CE(norm_prod),
        .D(norm_prod0__0_n_97),
        .Q(\norm_prod_reg[8]__0_n_0 ),
        .R(out_valid_i_1_n_0));
  FDRE \norm_prod_reg[9] 
       (.C(clk),
        .CE(norm_prod),
        .D(norm_prod0_n_96),
        .Q(\norm_prod_reg_n_0_[9] ),
        .R(out_valid_i_1_n_0));
  FDRE \norm_prod_reg[9]__0 
       (.C(clk),
        .CE(norm_prod),
        .D(norm_prod0__0_n_96),
        .Q(\norm_prod_reg[9]__0_n_0 ),
        .R(out_valid_i_1_n_0));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-10 {cell *THIS*} {string 18x16 4}}" *) 
  DSP48E1 #(
    .ACASCREG(0),
    .ADREG(1),
    .ALUMODEREG(0),
    .AREG(0),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("CASCADE"),
    .BCASCREG(1),
    .BREG(1),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(1),
    .DREG(1),
    .INMODEREG(0),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREG(1),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_DPORT("FALSE"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48")) 
    norm_prod_reg__0
       (.A({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACIN({norm_prod0__0_n_24,norm_prod0__0_n_25,norm_prod0__0_n_26,norm_prod0__0_n_27,norm_prod0__0_n_28,norm_prod0__0_n_29,norm_prod0__0_n_30,norm_prod0__0_n_31,norm_prod0__0_n_32,norm_prod0__0_n_33,norm_prod0__0_n_34,norm_prod0__0_n_35,norm_prod0__0_n_36,norm_prod0__0_n_37,norm_prod0__0_n_38,norm_prod0__0_n_39,norm_prod0__0_n_40,norm_prod0__0_n_41,norm_prod0__0_n_42,norm_prod0__0_n_43,norm_prod0__0_n_44,norm_prod0__0_n_45,norm_prod0__0_n_46,norm_prod0__0_n_47,norm_prod0__0_n_48,norm_prod0__0_n_49,norm_prod0__0_n_50,norm_prod0__0_n_51,norm_prod0__0_n_52,norm_prod0__0_n_53}),
        .ACOUT(NLW_norm_prod_reg__0_ACOUT_UNCONNECTED[29:0]),
        .ALUMODE({1'b0,1'b0,1'b0,1'b0}),
        .B({1'b0,1'b0,1'b0,bram_addr_reg_rep_1_n_20,bram_addr_reg_rep_1_n_21,bram_addr_reg_rep_1_n_22,bram_addr_reg_rep_1_n_23,bram_addr_reg_rep_1_n_24,bram_addr_reg_rep_1_n_25,bram_addr_reg_rep_1_n_26,bram_addr_reg_rep_1_n_27,bram_addr_reg_rep_1_n_28,bram_addr_reg_rep_1_n_29,bram_addr_reg_rep_1_n_30,bram_addr_reg_rep_1_n_31,bram_addr_reg_rep_1_n_32,bram_addr_reg_rep_1_n_33,bram_addr_reg_rep_1_n_34}),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(NLW_norm_prod_reg__0_BCOUT_UNCONNECTED[17:0]),
        .C({1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(NLW_norm_prod_reg__0_CARRYCASCOUT_UNCONNECTED),
        .CARRYIN(1'b0),
        .CARRYINSEL({1'b0,1'b0,1'b0}),
        .CARRYOUT(NLW_norm_prod_reg__0_CARRYOUT_UNCONNECTED[3:0]),
        .CEA1(1'b0),
        .CEA2(1'b0),
        .CEAD(1'b0),
        .CEALUMODE(1'b0),
        .CEB1(1'b0),
        .CEB2(m_in_r),
        .CEC(1'b0),
        .CECARRYIN(1'b0),
        .CECTRL(1'b0),
        .CED(1'b0),
        .CEINMODE(1'b0),
        .CEM(1'b0),
        .CEP(norm_prod),
        .CLK(clk),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .INMODE({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .MULTSIGNIN(1'b0),
        .MULTSIGNOUT(NLW_norm_prod_reg__0_MULTSIGNOUT_UNCONNECTED),
        .OPMODE({1'b1,1'b0,1'b1,1'b0,1'b1,1'b0,1'b1}),
        .OVERFLOW(NLW_norm_prod_reg__0_OVERFLOW_UNCONNECTED),
        .P({norm_prod_reg__0_n_58,norm_prod_reg__0_n_59,norm_prod_reg__0_n_60,norm_prod_reg__0_n_61,norm_prod_reg__0_n_62,norm_prod_reg__0_n_63,norm_prod_reg__0_n_64,norm_prod_reg__0_n_65,norm_prod_reg__0_n_66,norm_prod_reg__0_n_67,norm_prod_reg__0_n_68,norm_prod_reg__0_n_69,norm_prod_reg__0_n_70,norm_prod_reg__0_n_71,norm_prod_reg__0_n_72,norm_prod_reg__0_n_73,norm_prod_reg__0_n_74,norm_prod_reg__0_n_75,norm_prod_reg__0_n_76,norm_prod_reg__0_n_77,norm_prod_reg__0_n_78,norm_prod_reg__0_n_79,norm_prod_reg__0_n_80,norm_prod_reg__0_n_81,norm_prod_reg__0_n_82,norm_prod_reg__0_n_83,norm_prod_reg__0_n_84,norm_prod_reg__0_n_85,norm_prod_reg__0_n_86,norm_prod_reg__0_n_87,norm_prod_reg__0_n_88,norm_prod_reg__0_n_89,norm_prod_reg__0_n_90,norm_prod_reg__0_n_91,norm_prod_reg__0_n_92,norm_prod_reg__0_n_93,norm_prod_reg__0_n_94,norm_prod_reg__0_n_95,norm_prod_reg__0_n_96,norm_prod_reg__0_n_97,norm_prod_reg__0_n_98,norm_prod_reg__0_n_99,norm_prod_reg__0_n_100,norm_prod_reg__0_n_101,norm_prod_reg__0_n_102,norm_prod_reg__0_n_103,norm_prod_reg__0_n_104,norm_prod_reg__0_n_105}),
        .PATTERNBDETECT(NLW_norm_prod_reg__0_PATTERNBDETECT_UNCONNECTED),
        .PATTERNDETECT(NLW_norm_prod_reg__0_PATTERNDETECT_UNCONNECTED),
        .PCIN({norm_prod0__0_n_106,norm_prod0__0_n_107,norm_prod0__0_n_108,norm_prod0__0_n_109,norm_prod0__0_n_110,norm_prod0__0_n_111,norm_prod0__0_n_112,norm_prod0__0_n_113,norm_prod0__0_n_114,norm_prod0__0_n_115,norm_prod0__0_n_116,norm_prod0__0_n_117,norm_prod0__0_n_118,norm_prod0__0_n_119,norm_prod0__0_n_120,norm_prod0__0_n_121,norm_prod0__0_n_122,norm_prod0__0_n_123,norm_prod0__0_n_124,norm_prod0__0_n_125,norm_prod0__0_n_126,norm_prod0__0_n_127,norm_prod0__0_n_128,norm_prod0__0_n_129,norm_prod0__0_n_130,norm_prod0__0_n_131,norm_prod0__0_n_132,norm_prod0__0_n_133,norm_prod0__0_n_134,norm_prod0__0_n_135,norm_prod0__0_n_136,norm_prod0__0_n_137,norm_prod0__0_n_138,norm_prod0__0_n_139,norm_prod0__0_n_140,norm_prod0__0_n_141,norm_prod0__0_n_142,norm_prod0__0_n_143,norm_prod0__0_n_144,norm_prod0__0_n_145,norm_prod0__0_n_146,norm_prod0__0_n_147,norm_prod0__0_n_148,norm_prod0__0_n_149,norm_prod0__0_n_150,norm_prod0__0_n_151,norm_prod0__0_n_152,norm_prod0__0_n_153}),
        .PCOUT(NLW_norm_prod_reg__0_PCOUT_UNCONNECTED[47:0]),
        .RSTA(1'b0),
        .RSTALLCARRYIN(1'b0),
        .RSTALUMODE(1'b0),
        .RSTB(out_valid_i_1_n_0),
        .RSTC(1'b0),
        .RSTCTRL(1'b0),
        .RSTD(1'b0),
        .RSTINMODE(1'b0),
        .RSTM(1'b0),
        .RSTP(out_valid_i_1_n_0),
        .UNDERFLOW(NLW_norm_prod_reg__0_UNDERFLOW_UNCONNECTED));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \out_data[0]_i_1 
       (.I0(out_id[1]),
        .I1(amax_c),
        .I2(out_id[2]),
        .I3(\out_data[0]_i_3_n_0 ),
        .I4(state[1]),
        .I5(\logits_reg[0] [0]),
        .O(\out_data[0]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[0]_i_10 
       (.I0(\logits_reg[1] [24]),
        .I1(\logits_reg[0] [24]),
        .I2(\logits_reg[0] [25]),
        .I3(\logits_reg[1] [25]),
        .O(\out_data[0]_i_10_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[0]_i_11 
       (.I0(\logits_reg[1] [30]),
        .I1(\logits_reg[0] [30]),
        .I2(\logits_reg[0] [31]),
        .I3(\logits_reg[1] [31]),
        .O(\out_data[0]_i_11_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[0]_i_12 
       (.I0(\logits_reg[1] [28]),
        .I1(\logits_reg[0] [28]),
        .I2(\logits_reg[1] [29]),
        .I3(\logits_reg[0] [29]),
        .O(\out_data[0]_i_12_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[0]_i_13 
       (.I0(\logits_reg[1] [26]),
        .I1(\logits_reg[0] [26]),
        .I2(\logits_reg[1] [27]),
        .I3(\logits_reg[0] [27]),
        .O(\out_data[0]_i_13_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[0]_i_14 
       (.I0(\logits_reg[1] [24]),
        .I1(\logits_reg[0] [24]),
        .I2(\logits_reg[1] [25]),
        .I3(\logits_reg[0] [25]),
        .O(\out_data[0]_i_14_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[0]_i_16 
       (.I0(\logits_reg[3] [30]),
        .I1(\logits_reg[2] [30]),
        .I2(\logits_reg[3] [31]),
        .I3(\logits_reg[2] [31]),
        .O(\out_data[0]_i_16_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[0]_i_17 
       (.I0(\logits_reg[3] [28]),
        .I1(\logits_reg[2] [28]),
        .I2(\logits_reg[2] [29]),
        .I3(\logits_reg[3] [29]),
        .O(\out_data[0]_i_17_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[0]_i_18 
       (.I0(\logits_reg[3] [26]),
        .I1(\logits_reg[2] [26]),
        .I2(\logits_reg[2] [27]),
        .I3(\logits_reg[3] [27]),
        .O(\out_data[0]_i_18_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[0]_i_19 
       (.I0(\logits_reg[3] [24]),
        .I1(\logits_reg[2] [24]),
        .I2(\logits_reg[2] [25]),
        .I3(\logits_reg[3] [25]),
        .O(\out_data[0]_i_19_n_0 ));
  LUT5 #(
    .INIT(32'h0000FE0E)) 
    \out_data[0]_i_2 
       (.I0(\out_data_reg[0]_i_4_n_0 ),
        .I1(\out_data_reg[1]_i_4_n_0 ),
        .I2(\out_data_reg[1]_i_5_n_0 ),
        .I3(\out_data_reg[0]_i_5_n_0 ),
        .I4(\out_data_reg[2]_i_2_n_0 ),
        .O(amax_c));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[0]_i_20 
       (.I0(\logits_reg[3] [30]),
        .I1(\logits_reg[2] [30]),
        .I2(\logits_reg[2] [31]),
        .I3(\logits_reg[3] [31]),
        .O(\out_data[0]_i_20_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[0]_i_21 
       (.I0(\logits_reg[3] [28]),
        .I1(\logits_reg[2] [28]),
        .I2(\logits_reg[3] [29]),
        .I3(\logits_reg[2] [29]),
        .O(\out_data[0]_i_21_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[0]_i_22 
       (.I0(\logits_reg[3] [26]),
        .I1(\logits_reg[2] [26]),
        .I2(\logits_reg[3] [27]),
        .I3(\logits_reg[2] [27]),
        .O(\out_data[0]_i_22_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[0]_i_23 
       (.I0(\logits_reg[3] [24]),
        .I1(\logits_reg[2] [24]),
        .I2(\logits_reg[3] [25]),
        .I3(\logits_reg[2] [25]),
        .O(\out_data[0]_i_23_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[0]_i_25 
       (.I0(\logits_reg[1] [22]),
        .I1(\logits_reg[0] [22]),
        .I2(\logits_reg[0] [23]),
        .I3(\logits_reg[1] [23]),
        .O(\out_data[0]_i_25_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[0]_i_26 
       (.I0(\logits_reg[1] [20]),
        .I1(\logits_reg[0] [20]),
        .I2(\logits_reg[0] [21]),
        .I3(\logits_reg[1] [21]),
        .O(\out_data[0]_i_26_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[0]_i_27 
       (.I0(\logits_reg[1] [18]),
        .I1(\logits_reg[0] [18]),
        .I2(\logits_reg[0] [19]),
        .I3(\logits_reg[1] [19]),
        .O(\out_data[0]_i_27_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[0]_i_28 
       (.I0(\logits_reg[1] [16]),
        .I1(\logits_reg[0] [16]),
        .I2(\logits_reg[0] [17]),
        .I3(\logits_reg[1] [17]),
        .O(\out_data[0]_i_28_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[0]_i_29 
       (.I0(\logits_reg[1] [22]),
        .I1(\logits_reg[0] [22]),
        .I2(\logits_reg[1] [23]),
        .I3(\logits_reg[0] [23]),
        .O(\out_data[0]_i_29_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \out_data[0]_i_3 
       (.I0(\logits_reg[4] [0]),
        .I1(\logits_reg[3] [0]),
        .I2(out_id[1]),
        .I3(\logits_reg[2] [0]),
        .I4(out_id[0]),
        .I5(\logits_reg[1] [0]),
        .O(\out_data[0]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[0]_i_30 
       (.I0(\logits_reg[1] [20]),
        .I1(\logits_reg[0] [20]),
        .I2(\logits_reg[1] [21]),
        .I3(\logits_reg[0] [21]),
        .O(\out_data[0]_i_30_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[0]_i_31 
       (.I0(\logits_reg[1] [18]),
        .I1(\logits_reg[0] [18]),
        .I2(\logits_reg[1] [19]),
        .I3(\logits_reg[0] [19]),
        .O(\out_data[0]_i_31_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[0]_i_32 
       (.I0(\logits_reg[1] [16]),
        .I1(\logits_reg[0] [16]),
        .I2(\logits_reg[1] [17]),
        .I3(\logits_reg[0] [17]),
        .O(\out_data[0]_i_32_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[0]_i_34 
       (.I0(\logits_reg[3] [22]),
        .I1(\logits_reg[2] [22]),
        .I2(\logits_reg[2] [23]),
        .I3(\logits_reg[3] [23]),
        .O(\out_data[0]_i_34_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[0]_i_35 
       (.I0(\logits_reg[3] [20]),
        .I1(\logits_reg[2] [20]),
        .I2(\logits_reg[2] [21]),
        .I3(\logits_reg[3] [21]),
        .O(\out_data[0]_i_35_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[0]_i_36 
       (.I0(\logits_reg[3] [18]),
        .I1(\logits_reg[2] [18]),
        .I2(\logits_reg[2] [19]),
        .I3(\logits_reg[3] [19]),
        .O(\out_data[0]_i_36_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[0]_i_37 
       (.I0(\logits_reg[3] [16]),
        .I1(\logits_reg[2] [16]),
        .I2(\logits_reg[2] [17]),
        .I3(\logits_reg[3] [17]),
        .O(\out_data[0]_i_37_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[0]_i_38 
       (.I0(\logits_reg[3] [22]),
        .I1(\logits_reg[2] [22]),
        .I2(\logits_reg[3] [23]),
        .I3(\logits_reg[2] [23]),
        .O(\out_data[0]_i_38_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[0]_i_39 
       (.I0(\logits_reg[3] [20]),
        .I1(\logits_reg[2] [20]),
        .I2(\logits_reg[3] [21]),
        .I3(\logits_reg[2] [21]),
        .O(\out_data[0]_i_39_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[0]_i_40 
       (.I0(\logits_reg[3] [18]),
        .I1(\logits_reg[2] [18]),
        .I2(\logits_reg[3] [19]),
        .I3(\logits_reg[2] [19]),
        .O(\out_data[0]_i_40_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[0]_i_41 
       (.I0(\logits_reg[3] [16]),
        .I1(\logits_reg[2] [16]),
        .I2(\logits_reg[3] [17]),
        .I3(\logits_reg[2] [17]),
        .O(\out_data[0]_i_41_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[0]_i_43 
       (.I0(\logits_reg[1] [14]),
        .I1(\logits_reg[0] [14]),
        .I2(\logits_reg[0] [15]),
        .I3(\logits_reg[1] [15]),
        .O(\out_data[0]_i_43_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[0]_i_44 
       (.I0(\logits_reg[1] [12]),
        .I1(\logits_reg[0] [12]),
        .I2(\logits_reg[0] [13]),
        .I3(\logits_reg[1] [13]),
        .O(\out_data[0]_i_44_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[0]_i_45 
       (.I0(\logits_reg[1] [10]),
        .I1(\logits_reg[0] [10]),
        .I2(\logits_reg[0] [11]),
        .I3(\logits_reg[1] [11]),
        .O(\out_data[0]_i_45_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[0]_i_46 
       (.I0(\logits_reg[1] [8]),
        .I1(\logits_reg[0] [8]),
        .I2(\logits_reg[0] [9]),
        .I3(\logits_reg[1] [9]),
        .O(\out_data[0]_i_46_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[0]_i_47 
       (.I0(\logits_reg[1] [14]),
        .I1(\logits_reg[0] [14]),
        .I2(\logits_reg[1] [15]),
        .I3(\logits_reg[0] [15]),
        .O(\out_data[0]_i_47_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[0]_i_48 
       (.I0(\logits_reg[1] [12]),
        .I1(\logits_reg[0] [12]),
        .I2(\logits_reg[1] [13]),
        .I3(\logits_reg[0] [13]),
        .O(\out_data[0]_i_48_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[0]_i_49 
       (.I0(\logits_reg[1] [10]),
        .I1(\logits_reg[0] [10]),
        .I2(\logits_reg[1] [11]),
        .I3(\logits_reg[0] [11]),
        .O(\out_data[0]_i_49_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[0]_i_50 
       (.I0(\logits_reg[1] [8]),
        .I1(\logits_reg[0] [8]),
        .I2(\logits_reg[1] [9]),
        .I3(\logits_reg[0] [9]),
        .O(\out_data[0]_i_50_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[0]_i_52 
       (.I0(\logits_reg[3] [14]),
        .I1(\logits_reg[2] [14]),
        .I2(\logits_reg[2] [15]),
        .I3(\logits_reg[3] [15]),
        .O(\out_data[0]_i_52_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[0]_i_53 
       (.I0(\logits_reg[3] [12]),
        .I1(\logits_reg[2] [12]),
        .I2(\logits_reg[2] [13]),
        .I3(\logits_reg[3] [13]),
        .O(\out_data[0]_i_53_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[0]_i_54 
       (.I0(\logits_reg[3] [10]),
        .I1(\logits_reg[2] [10]),
        .I2(\logits_reg[2] [11]),
        .I3(\logits_reg[3] [11]),
        .O(\out_data[0]_i_54_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[0]_i_55 
       (.I0(\logits_reg[3] [8]),
        .I1(\logits_reg[2] [8]),
        .I2(\logits_reg[2] [9]),
        .I3(\logits_reg[3] [9]),
        .O(\out_data[0]_i_55_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[0]_i_56 
       (.I0(\logits_reg[3] [14]),
        .I1(\logits_reg[2] [14]),
        .I2(\logits_reg[3] [15]),
        .I3(\logits_reg[2] [15]),
        .O(\out_data[0]_i_56_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[0]_i_57 
       (.I0(\logits_reg[3] [12]),
        .I1(\logits_reg[2] [12]),
        .I2(\logits_reg[3] [13]),
        .I3(\logits_reg[2] [13]),
        .O(\out_data[0]_i_57_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[0]_i_58 
       (.I0(\logits_reg[3] [10]),
        .I1(\logits_reg[2] [10]),
        .I2(\logits_reg[3] [11]),
        .I3(\logits_reg[2] [11]),
        .O(\out_data[0]_i_58_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[0]_i_59 
       (.I0(\logits_reg[3] [8]),
        .I1(\logits_reg[2] [8]),
        .I2(\logits_reg[3] [9]),
        .I3(\logits_reg[2] [9]),
        .O(\out_data[0]_i_59_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[0]_i_60 
       (.I0(\logits_reg[1] [6]),
        .I1(\logits_reg[0] [6]),
        .I2(\logits_reg[0] [7]),
        .I3(\logits_reg[1] [7]),
        .O(\out_data[0]_i_60_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[0]_i_61 
       (.I0(\logits_reg[1] [4]),
        .I1(\logits_reg[0] [4]),
        .I2(\logits_reg[0] [5]),
        .I3(\logits_reg[1] [5]),
        .O(\out_data[0]_i_61_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[0]_i_62 
       (.I0(\logits_reg[1] [2]),
        .I1(\logits_reg[0] [2]),
        .I2(\logits_reg[0] [3]),
        .I3(\logits_reg[1] [3]),
        .O(\out_data[0]_i_62_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[0]_i_63 
       (.I0(\logits_reg[1] [0]),
        .I1(\logits_reg[0] [0]),
        .I2(\logits_reg[0] [1]),
        .I3(\logits_reg[1] [1]),
        .O(\out_data[0]_i_63_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[0]_i_64 
       (.I0(\logits_reg[1] [6]),
        .I1(\logits_reg[0] [6]),
        .I2(\logits_reg[1] [7]),
        .I3(\logits_reg[0] [7]),
        .O(\out_data[0]_i_64_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[0]_i_65 
       (.I0(\logits_reg[1] [4]),
        .I1(\logits_reg[0] [4]),
        .I2(\logits_reg[1] [5]),
        .I3(\logits_reg[0] [5]),
        .O(\out_data[0]_i_65_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[0]_i_66 
       (.I0(\logits_reg[1] [2]),
        .I1(\logits_reg[0] [2]),
        .I2(\logits_reg[1] [3]),
        .I3(\logits_reg[0] [3]),
        .O(\out_data[0]_i_66_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[0]_i_67 
       (.I0(\logits_reg[1] [0]),
        .I1(\logits_reg[0] [0]),
        .I2(\logits_reg[1] [1]),
        .I3(\logits_reg[0] [1]),
        .O(\out_data[0]_i_67_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[0]_i_68 
       (.I0(\logits_reg[3] [6]),
        .I1(\logits_reg[2] [6]),
        .I2(\logits_reg[2] [7]),
        .I3(\logits_reg[3] [7]),
        .O(\out_data[0]_i_68_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[0]_i_69 
       (.I0(\logits_reg[3] [4]),
        .I1(\logits_reg[2] [4]),
        .I2(\logits_reg[2] [5]),
        .I3(\logits_reg[3] [5]),
        .O(\out_data[0]_i_69_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[0]_i_7 
       (.I0(\logits_reg[1] [30]),
        .I1(\logits_reg[0] [30]),
        .I2(\logits_reg[1] [31]),
        .I3(\logits_reg[0] [31]),
        .O(\out_data[0]_i_7_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[0]_i_70 
       (.I0(\logits_reg[3] [2]),
        .I1(\logits_reg[2] [2]),
        .I2(\logits_reg[2] [3]),
        .I3(\logits_reg[3] [3]),
        .O(\out_data[0]_i_70_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[0]_i_71 
       (.I0(\logits_reg[3] [0]),
        .I1(\logits_reg[2] [0]),
        .I2(\logits_reg[2] [1]),
        .I3(\logits_reg[3] [1]),
        .O(\out_data[0]_i_71_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[0]_i_72 
       (.I0(\logits_reg[3] [6]),
        .I1(\logits_reg[2] [6]),
        .I2(\logits_reg[3] [7]),
        .I3(\logits_reg[2] [7]),
        .O(\out_data[0]_i_72_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[0]_i_73 
       (.I0(\logits_reg[3] [4]),
        .I1(\logits_reg[2] [4]),
        .I2(\logits_reg[3] [5]),
        .I3(\logits_reg[2] [5]),
        .O(\out_data[0]_i_73_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[0]_i_74 
       (.I0(\logits_reg[3] [2]),
        .I1(\logits_reg[2] [2]),
        .I2(\logits_reg[3] [3]),
        .I3(\logits_reg[2] [3]),
        .O(\out_data[0]_i_74_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[0]_i_75 
       (.I0(\logits_reg[3] [0]),
        .I1(\logits_reg[2] [0]),
        .I2(\logits_reg[3] [1]),
        .I3(\logits_reg[2] [1]),
        .O(\out_data[0]_i_75_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[0]_i_8 
       (.I0(\logits_reg[1] [28]),
        .I1(\logits_reg[0] [28]),
        .I2(\logits_reg[0] [29]),
        .I3(\logits_reg[1] [29]),
        .O(\out_data[0]_i_8_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[0]_i_9 
       (.I0(\logits_reg[1] [26]),
        .I1(\logits_reg[0] [26]),
        .I2(\logits_reg[0] [27]),
        .I3(\logits_reg[1] [27]),
        .O(\out_data[0]_i_9_n_0 ));
  LUT5 #(
    .INIT(32'hB8FF3000)) 
    \out_data[10]_i_1 
       (.I0(out_id[1]),
        .I1(out_id[2]),
        .I2(\out_data[10]_i_2_n_0 ),
        .I3(state[1]),
        .I4(\logits_reg[0] [10]),
        .O(\out_data[10]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \out_data[10]_i_2 
       (.I0(\logits_reg[4] [10]),
        .I1(\logits_reg[3] [10]),
        .I2(out_id[1]),
        .I3(\logits_reg[2] [10]),
        .I4(out_id[0]),
        .I5(\logits_reg[1] [10]),
        .O(\out_data[10]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hB8FF3000)) 
    \out_data[11]_i_1 
       (.I0(out_id[1]),
        .I1(out_id[2]),
        .I2(\out_data[11]_i_2_n_0 ),
        .I3(state[1]),
        .I4(\logits_reg[0] [11]),
        .O(\out_data[11]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \out_data[11]_i_2 
       (.I0(\logits_reg[4] [11]),
        .I1(\logits_reg[3] [11]),
        .I2(out_id[1]),
        .I3(\logits_reg[2] [11]),
        .I4(out_id[0]),
        .I5(\logits_reg[1] [11]),
        .O(\out_data[11]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hB8FF3000)) 
    \out_data[12]_i_1 
       (.I0(out_id[1]),
        .I1(out_id[2]),
        .I2(\out_data[12]_i_2_n_0 ),
        .I3(state[1]),
        .I4(\logits_reg[0] [12]),
        .O(\out_data[12]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \out_data[12]_i_2 
       (.I0(\logits_reg[4] [12]),
        .I1(\logits_reg[3] [12]),
        .I2(out_id[1]),
        .I3(\logits_reg[2] [12]),
        .I4(out_id[0]),
        .I5(\logits_reg[1] [12]),
        .O(\out_data[12]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hB8FF3000)) 
    \out_data[13]_i_1 
       (.I0(out_id[1]),
        .I1(out_id[2]),
        .I2(\out_data[13]_i_2_n_0 ),
        .I3(state[1]),
        .I4(\logits_reg[0] [13]),
        .O(\out_data[13]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \out_data[13]_i_2 
       (.I0(\logits_reg[4] [13]),
        .I1(\logits_reg[3] [13]),
        .I2(out_id[1]),
        .I3(\logits_reg[2] [13]),
        .I4(out_id[0]),
        .I5(\logits_reg[1] [13]),
        .O(\out_data[13]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hB8FF3000)) 
    \out_data[14]_i_1 
       (.I0(out_id[1]),
        .I1(out_id[2]),
        .I2(\out_data[14]_i_2_n_0 ),
        .I3(state[1]),
        .I4(\logits_reg[0] [14]),
        .O(\out_data[14]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \out_data[14]_i_2 
       (.I0(\logits_reg[4] [14]),
        .I1(\logits_reg[3] [14]),
        .I2(out_id[1]),
        .I3(\logits_reg[2] [14]),
        .I4(out_id[0]),
        .I5(\logits_reg[1] [14]),
        .O(\out_data[14]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hB8FF3000)) 
    \out_data[15]_i_1 
       (.I0(out_id[1]),
        .I1(out_id[2]),
        .I2(\out_data[15]_i_2_n_0 ),
        .I3(state[1]),
        .I4(\logits_reg[0] [15]),
        .O(\out_data[15]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \out_data[15]_i_2 
       (.I0(\logits_reg[4] [15]),
        .I1(\logits_reg[3] [15]),
        .I2(out_id[1]),
        .I3(\logits_reg[2] [15]),
        .I4(out_id[0]),
        .I5(\logits_reg[1] [15]),
        .O(\out_data[15]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hB8FF3000)) 
    \out_data[16]_i_1 
       (.I0(out_id[1]),
        .I1(out_id[2]),
        .I2(\out_data[16]_i_2_n_0 ),
        .I3(state[1]),
        .I4(\logits_reg[0] [16]),
        .O(\out_data[16]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \out_data[16]_i_2 
       (.I0(\logits_reg[4] [16]),
        .I1(\logits_reg[3] [16]),
        .I2(out_id[1]),
        .I3(\logits_reg[2] [16]),
        .I4(out_id[0]),
        .I5(\logits_reg[1] [16]),
        .O(\out_data[16]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hB8FF3000)) 
    \out_data[17]_i_1 
       (.I0(out_id[1]),
        .I1(out_id[2]),
        .I2(\out_data[17]_i_2_n_0 ),
        .I3(state[1]),
        .I4(\logits_reg[0] [17]),
        .O(\out_data[17]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \out_data[17]_i_2 
       (.I0(\logits_reg[4] [17]),
        .I1(\logits_reg[3] [17]),
        .I2(out_id[1]),
        .I3(\logits_reg[2] [17]),
        .I4(out_id[0]),
        .I5(\logits_reg[1] [17]),
        .O(\out_data[17]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hB8FF3000)) 
    \out_data[18]_i_1 
       (.I0(out_id[1]),
        .I1(out_id[2]),
        .I2(\out_data[18]_i_2_n_0 ),
        .I3(state[1]),
        .I4(\logits_reg[0] [18]),
        .O(\out_data[18]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \out_data[18]_i_2 
       (.I0(\logits_reg[4] [18]),
        .I1(\logits_reg[3] [18]),
        .I2(out_id[1]),
        .I3(\logits_reg[2] [18]),
        .I4(out_id[0]),
        .I5(\logits_reg[1] [18]),
        .O(\out_data[18]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hB8FF3000)) 
    \out_data[19]_i_1 
       (.I0(out_id[1]),
        .I1(out_id[2]),
        .I2(\out_data[19]_i_2_n_0 ),
        .I3(state[1]),
        .I4(\logits_reg[0] [19]),
        .O(\out_data[19]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \out_data[19]_i_2 
       (.I0(\logits_reg[4] [19]),
        .I1(\logits_reg[3] [19]),
        .I2(out_id[1]),
        .I3(\logits_reg[2] [19]),
        .I4(out_id[0]),
        .I5(\logits_reg[1] [19]),
        .O(\out_data[19]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hB8FFB800)) 
    \out_data[1]_i_1 
       (.I0(\out_data[1]_i_2_n_0 ),
        .I1(out_id[2]),
        .I2(\out_data[1]_i_3_n_0 ),
        .I3(state[1]),
        .I4(\logits_reg[0] [1]),
        .O(\out_data[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h028AFFFF0000028A)) 
    \out_data[1]_i_10 
       (.I0(\logits_reg[3] [24]),
        .I1(\out_data_reg[0]_i_4_n_0 ),
        .I2(\logits_reg[0] [24]),
        .I3(\logits_reg[1] [24]),
        .I4(am_best[25]),
        .I5(\logits_reg[3] [25]),
        .O(\out_data[1]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'h99A50000000099A5)) 
    \out_data[1]_i_11 
       (.I0(\logits_reg[3] [30]),
        .I1(\logits_reg[1] [30]),
        .I2(\logits_reg[0] [30]),
        .I3(\out_data_reg[0]_i_4_n_0 ),
        .I4(am_best[31]),
        .I5(\logits_reg[3] [31]),
        .O(\out_data[1]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'h99A50000000099A5)) 
    \out_data[1]_i_12 
       (.I0(\logits_reg[3] [28]),
        .I1(\logits_reg[1] [28]),
        .I2(\logits_reg[0] [28]),
        .I3(\out_data_reg[0]_i_4_n_0 ),
        .I4(\logits_reg[3] [29]),
        .I5(am_best[29]),
        .O(\out_data[1]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'h99A50000000099A5)) 
    \out_data[1]_i_13 
       (.I0(\logits_reg[3] [26]),
        .I1(\logits_reg[1] [26]),
        .I2(\logits_reg[0] [26]),
        .I3(\out_data_reg[0]_i_4_n_0 ),
        .I4(\logits_reg[3] [27]),
        .I5(am_best[27]),
        .O(\out_data[1]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'h99A50000000099A5)) 
    \out_data[1]_i_14 
       (.I0(\logits_reg[3] [24]),
        .I1(\logits_reg[1] [24]),
        .I2(\logits_reg[0] [24]),
        .I3(\out_data_reg[0]_i_4_n_0 ),
        .I4(\logits_reg[3] [25]),
        .I5(am_best[25]),
        .O(\out_data[1]_i_14_n_0 ));
  LUT6 #(
    .INIT(64'h028AFFFF0000028A)) 
    \out_data[1]_i_16 
       (.I0(\logits_reg[2] [30]),
        .I1(\out_data_reg[0]_i_4_n_0 ),
        .I2(\logits_reg[0] [30]),
        .I3(\logits_reg[1] [30]),
        .I4(\logits_reg[2] [31]),
        .I5(am_best[31]),
        .O(\out_data[1]_i_16_n_0 ));
  LUT6 #(
    .INIT(64'h028AFFFF0000028A)) 
    \out_data[1]_i_17 
       (.I0(\logits_reg[2] [28]),
        .I1(\out_data_reg[0]_i_4_n_0 ),
        .I2(\logits_reg[0] [28]),
        .I3(\logits_reg[1] [28]),
        .I4(am_best[29]),
        .I5(\logits_reg[2] [29]),
        .O(\out_data[1]_i_17_n_0 ));
  LUT6 #(
    .INIT(64'h028AFFFF0000028A)) 
    \out_data[1]_i_18 
       (.I0(\logits_reg[2] [26]),
        .I1(\out_data_reg[0]_i_4_n_0 ),
        .I2(\logits_reg[0] [26]),
        .I3(\logits_reg[1] [26]),
        .I4(am_best[27]),
        .I5(\logits_reg[2] [27]),
        .O(\out_data[1]_i_18_n_0 ));
  LUT6 #(
    .INIT(64'h028AFFFF0000028A)) 
    \out_data[1]_i_19 
       (.I0(\logits_reg[2] [24]),
        .I1(\out_data_reg[0]_i_4_n_0 ),
        .I2(\logits_reg[0] [24]),
        .I3(\logits_reg[1] [24]),
        .I4(am_best[25]),
        .I5(\logits_reg[2] [25]),
        .O(\out_data[1]_i_19_n_0 ));
  LUT5 #(
    .INIT(32'h8888BBB8)) 
    \out_data[1]_i_2 
       (.I0(\logits_reg[0] [1]),
        .I1(out_id[1]),
        .I2(\out_data_reg[1]_i_4_n_0 ),
        .I3(\out_data_reg[1]_i_5_n_0 ),
        .I4(\out_data_reg[2]_i_2_n_0 ),
        .O(\out_data[1]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h99A50000000099A5)) 
    \out_data[1]_i_20 
       (.I0(\logits_reg[2] [30]),
        .I1(\logits_reg[1] [30]),
        .I2(\logits_reg[0] [30]),
        .I3(\out_data_reg[0]_i_4_n_0 ),
        .I4(am_best[31]),
        .I5(\logits_reg[2] [31]),
        .O(\out_data[1]_i_20_n_0 ));
  LUT6 #(
    .INIT(64'h99A50000000099A5)) 
    \out_data[1]_i_21 
       (.I0(\logits_reg[2] [28]),
        .I1(\logits_reg[1] [28]),
        .I2(\logits_reg[0] [28]),
        .I3(\out_data_reg[0]_i_4_n_0 ),
        .I4(\logits_reg[2] [29]),
        .I5(am_best[29]),
        .O(\out_data[1]_i_21_n_0 ));
  LUT6 #(
    .INIT(64'h99A50000000099A5)) 
    \out_data[1]_i_22 
       (.I0(\logits_reg[2] [26]),
        .I1(\logits_reg[1] [26]),
        .I2(\logits_reg[0] [26]),
        .I3(\out_data_reg[0]_i_4_n_0 ),
        .I4(\logits_reg[2] [27]),
        .I5(am_best[27]),
        .O(\out_data[1]_i_22_n_0 ));
  LUT6 #(
    .INIT(64'h99A50000000099A5)) 
    \out_data[1]_i_23 
       (.I0(\logits_reg[2] [24]),
        .I1(\logits_reg[1] [24]),
        .I2(\logits_reg[0] [24]),
        .I3(\out_data_reg[0]_i_4_n_0 ),
        .I4(\logits_reg[2] [25]),
        .I5(am_best[25]),
        .O(\out_data[1]_i_23_n_0 ));
  LUT6 #(
    .INIT(64'h028AFFFF0000028A)) 
    \out_data[1]_i_25 
       (.I0(\logits_reg[3] [22]),
        .I1(\out_data_reg[0]_i_4_n_0 ),
        .I2(\logits_reg[0] [22]),
        .I3(\logits_reg[1] [22]),
        .I4(am_best[23]),
        .I5(\logits_reg[3] [23]),
        .O(\out_data[1]_i_25_n_0 ));
  LUT6 #(
    .INIT(64'h028AFFFF0000028A)) 
    \out_data[1]_i_26 
       (.I0(\logits_reg[3] [20]),
        .I1(\out_data_reg[0]_i_4_n_0 ),
        .I2(\logits_reg[0] [20]),
        .I3(\logits_reg[1] [20]),
        .I4(am_best[21]),
        .I5(\logits_reg[3] [21]),
        .O(\out_data[1]_i_26_n_0 ));
  LUT6 #(
    .INIT(64'h028AFFFF0000028A)) 
    \out_data[1]_i_27 
       (.I0(\logits_reg[3] [18]),
        .I1(\out_data_reg[0]_i_4_n_0 ),
        .I2(\logits_reg[0] [18]),
        .I3(\logits_reg[1] [18]),
        .I4(am_best[19]),
        .I5(\logits_reg[3] [19]),
        .O(\out_data[1]_i_27_n_0 ));
  LUT6 #(
    .INIT(64'h028AFFFF0000028A)) 
    \out_data[1]_i_28 
       (.I0(\logits_reg[3] [16]),
        .I1(\out_data_reg[0]_i_4_n_0 ),
        .I2(\logits_reg[0] [16]),
        .I3(\logits_reg[1] [16]),
        .I4(am_best[17]),
        .I5(\logits_reg[3] [17]),
        .O(\out_data[1]_i_28_n_0 ));
  LUT6 #(
    .INIT(64'h99A50000000099A5)) 
    \out_data[1]_i_29 
       (.I0(\logits_reg[3] [22]),
        .I1(\logits_reg[1] [22]),
        .I2(\logits_reg[0] [22]),
        .I3(\out_data_reg[0]_i_4_n_0 ),
        .I4(\logits_reg[3] [23]),
        .I5(am_best[23]),
        .O(\out_data[1]_i_29_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \out_data[1]_i_3 
       (.I0(\logits_reg[4] [1]),
        .I1(\logits_reg[3] [1]),
        .I2(out_id[1]),
        .I3(\logits_reg[2] [1]),
        .I4(out_id[0]),
        .I5(\logits_reg[1] [1]),
        .O(\out_data[1]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h99A50000000099A5)) 
    \out_data[1]_i_30 
       (.I0(\logits_reg[3] [20]),
        .I1(\logits_reg[1] [20]),
        .I2(\logits_reg[0] [20]),
        .I3(\out_data_reg[0]_i_4_n_0 ),
        .I4(\logits_reg[3] [21]),
        .I5(am_best[21]),
        .O(\out_data[1]_i_30_n_0 ));
  LUT6 #(
    .INIT(64'h99A50000000099A5)) 
    \out_data[1]_i_31 
       (.I0(\logits_reg[3] [18]),
        .I1(\logits_reg[1] [18]),
        .I2(\logits_reg[0] [18]),
        .I3(\out_data_reg[0]_i_4_n_0 ),
        .I4(\logits_reg[3] [19]),
        .I5(am_best[19]),
        .O(\out_data[1]_i_31_n_0 ));
  LUT6 #(
    .INIT(64'h99A50000000099A5)) 
    \out_data[1]_i_32 
       (.I0(\logits_reg[3] [16]),
        .I1(\logits_reg[1] [16]),
        .I2(\logits_reg[0] [16]),
        .I3(\out_data_reg[0]_i_4_n_0 ),
        .I4(\logits_reg[3] [17]),
        .I5(am_best[17]),
        .O(\out_data[1]_i_32_n_0 ));
  LUT6 #(
    .INIT(64'h028AFFFF0000028A)) 
    \out_data[1]_i_34 
       (.I0(\logits_reg[2] [22]),
        .I1(\out_data_reg[0]_i_4_n_0 ),
        .I2(\logits_reg[0] [22]),
        .I3(\logits_reg[1] [22]),
        .I4(am_best[23]),
        .I5(\logits_reg[2] [23]),
        .O(\out_data[1]_i_34_n_0 ));
  LUT6 #(
    .INIT(64'h028AFFFF0000028A)) 
    \out_data[1]_i_35 
       (.I0(\logits_reg[2] [20]),
        .I1(\out_data_reg[0]_i_4_n_0 ),
        .I2(\logits_reg[0] [20]),
        .I3(\logits_reg[1] [20]),
        .I4(am_best[21]),
        .I5(\logits_reg[2] [21]),
        .O(\out_data[1]_i_35_n_0 ));
  LUT6 #(
    .INIT(64'h028AFFFF0000028A)) 
    \out_data[1]_i_36 
       (.I0(\logits_reg[2] [18]),
        .I1(\out_data_reg[0]_i_4_n_0 ),
        .I2(\logits_reg[0] [18]),
        .I3(\logits_reg[1] [18]),
        .I4(am_best[19]),
        .I5(\logits_reg[2] [19]),
        .O(\out_data[1]_i_36_n_0 ));
  LUT6 #(
    .INIT(64'h028AFFFF0000028A)) 
    \out_data[1]_i_37 
       (.I0(\logits_reg[2] [16]),
        .I1(\out_data_reg[0]_i_4_n_0 ),
        .I2(\logits_reg[0] [16]),
        .I3(\logits_reg[1] [16]),
        .I4(am_best[17]),
        .I5(\logits_reg[2] [17]),
        .O(\out_data[1]_i_37_n_0 ));
  LUT6 #(
    .INIT(64'h99A50000000099A5)) 
    \out_data[1]_i_38 
       (.I0(\logits_reg[2] [22]),
        .I1(\logits_reg[1] [22]),
        .I2(\logits_reg[0] [22]),
        .I3(\out_data_reg[0]_i_4_n_0 ),
        .I4(\logits_reg[2] [23]),
        .I5(am_best[23]),
        .O(\out_data[1]_i_38_n_0 ));
  LUT6 #(
    .INIT(64'h99A50000000099A5)) 
    \out_data[1]_i_39 
       (.I0(\logits_reg[2] [20]),
        .I1(\logits_reg[1] [20]),
        .I2(\logits_reg[0] [20]),
        .I3(\out_data_reg[0]_i_4_n_0 ),
        .I4(\logits_reg[2] [21]),
        .I5(am_best[21]),
        .O(\out_data[1]_i_39_n_0 ));
  LUT6 #(
    .INIT(64'h99A50000000099A5)) 
    \out_data[1]_i_40 
       (.I0(\logits_reg[2] [18]),
        .I1(\logits_reg[1] [18]),
        .I2(\logits_reg[0] [18]),
        .I3(\out_data_reg[0]_i_4_n_0 ),
        .I4(\logits_reg[2] [19]),
        .I5(am_best[19]),
        .O(\out_data[1]_i_40_n_0 ));
  LUT6 #(
    .INIT(64'h99A50000000099A5)) 
    \out_data[1]_i_41 
       (.I0(\logits_reg[2] [16]),
        .I1(\logits_reg[1] [16]),
        .I2(\logits_reg[0] [16]),
        .I3(\out_data_reg[0]_i_4_n_0 ),
        .I4(\logits_reg[2] [17]),
        .I5(am_best[17]),
        .O(\out_data[1]_i_41_n_0 ));
  LUT6 #(
    .INIT(64'h028AFFFF0000028A)) 
    \out_data[1]_i_43 
       (.I0(\logits_reg[3] [14]),
        .I1(\out_data_reg[0]_i_4_n_0 ),
        .I2(\logits_reg[0] [14]),
        .I3(\logits_reg[1] [14]),
        .I4(am_best[15]),
        .I5(\logits_reg[3] [15]),
        .O(\out_data[1]_i_43_n_0 ));
  LUT6 #(
    .INIT(64'h028AFFFF0000028A)) 
    \out_data[1]_i_44 
       (.I0(\logits_reg[3] [12]),
        .I1(\out_data_reg[0]_i_4_n_0 ),
        .I2(\logits_reg[0] [12]),
        .I3(\logits_reg[1] [12]),
        .I4(am_best[13]),
        .I5(\logits_reg[3] [13]),
        .O(\out_data[1]_i_44_n_0 ));
  LUT6 #(
    .INIT(64'h028AFFFF0000028A)) 
    \out_data[1]_i_45 
       (.I0(\logits_reg[3] [10]),
        .I1(\out_data_reg[0]_i_4_n_0 ),
        .I2(\logits_reg[0] [10]),
        .I3(\logits_reg[1] [10]),
        .I4(am_best[11]),
        .I5(\logits_reg[3] [11]),
        .O(\out_data[1]_i_45_n_0 ));
  LUT6 #(
    .INIT(64'h028AFFFF0000028A)) 
    \out_data[1]_i_46 
       (.I0(\logits_reg[3] [8]),
        .I1(\out_data_reg[0]_i_4_n_0 ),
        .I2(\logits_reg[0] [8]),
        .I3(\logits_reg[1] [8]),
        .I4(am_best[9]),
        .I5(\logits_reg[3] [9]),
        .O(\out_data[1]_i_46_n_0 ));
  LUT6 #(
    .INIT(64'h99A50000000099A5)) 
    \out_data[1]_i_47 
       (.I0(\logits_reg[3] [14]),
        .I1(\logits_reg[1] [14]),
        .I2(\logits_reg[0] [14]),
        .I3(\out_data_reg[0]_i_4_n_0 ),
        .I4(\logits_reg[3] [15]),
        .I5(am_best[15]),
        .O(\out_data[1]_i_47_n_0 ));
  LUT6 #(
    .INIT(64'h99A50000000099A5)) 
    \out_data[1]_i_48 
       (.I0(\logits_reg[3] [12]),
        .I1(\logits_reg[1] [12]),
        .I2(\logits_reg[0] [12]),
        .I3(\out_data_reg[0]_i_4_n_0 ),
        .I4(\logits_reg[3] [13]),
        .I5(am_best[13]),
        .O(\out_data[1]_i_48_n_0 ));
  LUT6 #(
    .INIT(64'h99A50000000099A5)) 
    \out_data[1]_i_49 
       (.I0(\logits_reg[3] [10]),
        .I1(\logits_reg[1] [10]),
        .I2(\logits_reg[0] [10]),
        .I3(\out_data_reg[0]_i_4_n_0 ),
        .I4(\logits_reg[3] [11]),
        .I5(am_best[11]),
        .O(\out_data[1]_i_49_n_0 ));
  LUT6 #(
    .INIT(64'h99A50000000099A5)) 
    \out_data[1]_i_50 
       (.I0(\logits_reg[3] [8]),
        .I1(\logits_reg[1] [8]),
        .I2(\logits_reg[0] [8]),
        .I3(\out_data_reg[0]_i_4_n_0 ),
        .I4(\logits_reg[3] [9]),
        .I5(am_best[9]),
        .O(\out_data[1]_i_50_n_0 ));
  LUT6 #(
    .INIT(64'h028AFFFF0000028A)) 
    \out_data[1]_i_52 
       (.I0(\logits_reg[2] [14]),
        .I1(\out_data_reg[0]_i_4_n_0 ),
        .I2(\logits_reg[0] [14]),
        .I3(\logits_reg[1] [14]),
        .I4(am_best[15]),
        .I5(\logits_reg[2] [15]),
        .O(\out_data[1]_i_52_n_0 ));
  LUT6 #(
    .INIT(64'h028AFFFF0000028A)) 
    \out_data[1]_i_53 
       (.I0(\logits_reg[2] [12]),
        .I1(\out_data_reg[0]_i_4_n_0 ),
        .I2(\logits_reg[0] [12]),
        .I3(\logits_reg[1] [12]),
        .I4(am_best[13]),
        .I5(\logits_reg[2] [13]),
        .O(\out_data[1]_i_53_n_0 ));
  LUT6 #(
    .INIT(64'h028AFFFF0000028A)) 
    \out_data[1]_i_54 
       (.I0(\logits_reg[2] [10]),
        .I1(\out_data_reg[0]_i_4_n_0 ),
        .I2(\logits_reg[0] [10]),
        .I3(\logits_reg[1] [10]),
        .I4(am_best[11]),
        .I5(\logits_reg[2] [11]),
        .O(\out_data[1]_i_54_n_0 ));
  LUT6 #(
    .INIT(64'h028AFFFF0000028A)) 
    \out_data[1]_i_55 
       (.I0(\logits_reg[2] [8]),
        .I1(\out_data_reg[0]_i_4_n_0 ),
        .I2(\logits_reg[0] [8]),
        .I3(\logits_reg[1] [8]),
        .I4(am_best[9]),
        .I5(\logits_reg[2] [9]),
        .O(\out_data[1]_i_55_n_0 ));
  LUT6 #(
    .INIT(64'h99A50000000099A5)) 
    \out_data[1]_i_56 
       (.I0(\logits_reg[2] [14]),
        .I1(\logits_reg[1] [14]),
        .I2(\logits_reg[0] [14]),
        .I3(\out_data_reg[0]_i_4_n_0 ),
        .I4(\logits_reg[2] [15]),
        .I5(am_best[15]),
        .O(\out_data[1]_i_56_n_0 ));
  LUT6 #(
    .INIT(64'h99A50000000099A5)) 
    \out_data[1]_i_57 
       (.I0(\logits_reg[2] [12]),
        .I1(\logits_reg[1] [12]),
        .I2(\logits_reg[0] [12]),
        .I3(\out_data_reg[0]_i_4_n_0 ),
        .I4(\logits_reg[2] [13]),
        .I5(am_best[13]),
        .O(\out_data[1]_i_57_n_0 ));
  LUT6 #(
    .INIT(64'h99A50000000099A5)) 
    \out_data[1]_i_58 
       (.I0(\logits_reg[2] [10]),
        .I1(\logits_reg[1] [10]),
        .I2(\logits_reg[0] [10]),
        .I3(\out_data_reg[0]_i_4_n_0 ),
        .I4(\logits_reg[2] [11]),
        .I5(am_best[11]),
        .O(\out_data[1]_i_58_n_0 ));
  LUT6 #(
    .INIT(64'h99A50000000099A5)) 
    \out_data[1]_i_59 
       (.I0(\logits_reg[2] [8]),
        .I1(\logits_reg[1] [8]),
        .I2(\logits_reg[0] [8]),
        .I3(\out_data_reg[0]_i_4_n_0 ),
        .I4(\logits_reg[2] [9]),
        .I5(am_best[9]),
        .O(\out_data[1]_i_59_n_0 ));
  LUT6 #(
    .INIT(64'h028AFFFF0000028A)) 
    \out_data[1]_i_60 
       (.I0(\logits_reg[3] [6]),
        .I1(\out_data_reg[0]_i_4_n_0 ),
        .I2(\logits_reg[0] [6]),
        .I3(\logits_reg[1] [6]),
        .I4(am_best[7]),
        .I5(\logits_reg[3] [7]),
        .O(\out_data[1]_i_60_n_0 ));
  LUT6 #(
    .INIT(64'h028AFFFF0000028A)) 
    \out_data[1]_i_61 
       (.I0(\logits_reg[3] [4]),
        .I1(\out_data_reg[0]_i_4_n_0 ),
        .I2(\logits_reg[0] [4]),
        .I3(\logits_reg[1] [4]),
        .I4(am_best[5]),
        .I5(\logits_reg[3] [5]),
        .O(\out_data[1]_i_61_n_0 ));
  LUT6 #(
    .INIT(64'h028AFFFF0000028A)) 
    \out_data[1]_i_62 
       (.I0(\logits_reg[3] [2]),
        .I1(\out_data_reg[0]_i_4_n_0 ),
        .I2(\logits_reg[0] [2]),
        .I3(\logits_reg[1] [2]),
        .I4(am_best[3]),
        .I5(\logits_reg[3] [3]),
        .O(\out_data[1]_i_62_n_0 ));
  LUT6 #(
    .INIT(64'h028AFFFF0000028A)) 
    \out_data[1]_i_63 
       (.I0(\logits_reg[3] [0]),
        .I1(\out_data_reg[0]_i_4_n_0 ),
        .I2(\logits_reg[0] [0]),
        .I3(\logits_reg[1] [0]),
        .I4(am_best[1]),
        .I5(\logits_reg[3] [1]),
        .O(\out_data[1]_i_63_n_0 ));
  LUT6 #(
    .INIT(64'h99A50000000099A5)) 
    \out_data[1]_i_64 
       (.I0(\logits_reg[3] [6]),
        .I1(\logits_reg[1] [6]),
        .I2(\logits_reg[0] [6]),
        .I3(\out_data_reg[0]_i_4_n_0 ),
        .I4(\logits_reg[3] [7]),
        .I5(am_best[7]),
        .O(\out_data[1]_i_64_n_0 ));
  LUT6 #(
    .INIT(64'h99A50000000099A5)) 
    \out_data[1]_i_65 
       (.I0(\logits_reg[3] [4]),
        .I1(\logits_reg[1] [4]),
        .I2(\logits_reg[0] [4]),
        .I3(\out_data_reg[0]_i_4_n_0 ),
        .I4(\logits_reg[3] [5]),
        .I5(am_best[5]),
        .O(\out_data[1]_i_65_n_0 ));
  LUT6 #(
    .INIT(64'h99A50000000099A5)) 
    \out_data[1]_i_66 
       (.I0(\logits_reg[3] [2]),
        .I1(\logits_reg[1] [2]),
        .I2(\logits_reg[0] [2]),
        .I3(\out_data_reg[0]_i_4_n_0 ),
        .I4(\logits_reg[3] [3]),
        .I5(am_best[3]),
        .O(\out_data[1]_i_66_n_0 ));
  LUT6 #(
    .INIT(64'h99A50000000099A5)) 
    \out_data[1]_i_67 
       (.I0(\logits_reg[3] [0]),
        .I1(\logits_reg[1] [0]),
        .I2(\logits_reg[0] [0]),
        .I3(\out_data_reg[0]_i_4_n_0 ),
        .I4(\logits_reg[3] [1]),
        .I5(am_best[1]),
        .O(\out_data[1]_i_67_n_0 ));
  LUT6 #(
    .INIT(64'h028AFFFF0000028A)) 
    \out_data[1]_i_68 
       (.I0(\logits_reg[2] [6]),
        .I1(\out_data_reg[0]_i_4_n_0 ),
        .I2(\logits_reg[0] [6]),
        .I3(\logits_reg[1] [6]),
        .I4(am_best[7]),
        .I5(\logits_reg[2] [7]),
        .O(\out_data[1]_i_68_n_0 ));
  LUT6 #(
    .INIT(64'h028AFFFF0000028A)) 
    \out_data[1]_i_69 
       (.I0(\logits_reg[2] [4]),
        .I1(\out_data_reg[0]_i_4_n_0 ),
        .I2(\logits_reg[0] [4]),
        .I3(\logits_reg[1] [4]),
        .I4(am_best[5]),
        .I5(\logits_reg[2] [5]),
        .O(\out_data[1]_i_69_n_0 ));
  LUT6 #(
    .INIT(64'h028AFFFF0000028A)) 
    \out_data[1]_i_7 
       (.I0(\logits_reg[3] [30]),
        .I1(\out_data_reg[0]_i_4_n_0 ),
        .I2(\logits_reg[0] [30]),
        .I3(\logits_reg[1] [30]),
        .I4(\logits_reg[3] [31]),
        .I5(am_best[31]),
        .O(\out_data[1]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h028AFFFF0000028A)) 
    \out_data[1]_i_70 
       (.I0(\logits_reg[2] [2]),
        .I1(\out_data_reg[0]_i_4_n_0 ),
        .I2(\logits_reg[0] [2]),
        .I3(\logits_reg[1] [2]),
        .I4(am_best[3]),
        .I5(\logits_reg[2] [3]),
        .O(\out_data[1]_i_70_n_0 ));
  LUT6 #(
    .INIT(64'h028AFFFF0000028A)) 
    \out_data[1]_i_71 
       (.I0(\logits_reg[2] [0]),
        .I1(\out_data_reg[0]_i_4_n_0 ),
        .I2(\logits_reg[0] [0]),
        .I3(\logits_reg[1] [0]),
        .I4(am_best[1]),
        .I5(\logits_reg[2] [1]),
        .O(\out_data[1]_i_71_n_0 ));
  LUT6 #(
    .INIT(64'h99A50000000099A5)) 
    \out_data[1]_i_72 
       (.I0(\logits_reg[2] [6]),
        .I1(\logits_reg[1] [6]),
        .I2(\logits_reg[0] [6]),
        .I3(\out_data_reg[0]_i_4_n_0 ),
        .I4(\logits_reg[2] [7]),
        .I5(am_best[7]),
        .O(\out_data[1]_i_72_n_0 ));
  LUT6 #(
    .INIT(64'h99A50000000099A5)) 
    \out_data[1]_i_73 
       (.I0(\logits_reg[2] [4]),
        .I1(\logits_reg[1] [4]),
        .I2(\logits_reg[0] [4]),
        .I3(\out_data_reg[0]_i_4_n_0 ),
        .I4(\logits_reg[2] [5]),
        .I5(am_best[5]),
        .O(\out_data[1]_i_73_n_0 ));
  LUT6 #(
    .INIT(64'h99A50000000099A5)) 
    \out_data[1]_i_74 
       (.I0(\logits_reg[2] [2]),
        .I1(\logits_reg[1] [2]),
        .I2(\logits_reg[0] [2]),
        .I3(\out_data_reg[0]_i_4_n_0 ),
        .I4(\logits_reg[2] [3]),
        .I5(am_best[3]),
        .O(\out_data[1]_i_74_n_0 ));
  LUT6 #(
    .INIT(64'h99A50000000099A5)) 
    \out_data[1]_i_75 
       (.I0(\logits_reg[2] [0]),
        .I1(\logits_reg[1] [0]),
        .I2(\logits_reg[0] [0]),
        .I3(\out_data_reg[0]_i_4_n_0 ),
        .I4(\logits_reg[2] [1]),
        .I5(am_best[1]),
        .O(\out_data[1]_i_75_n_0 ));
  LUT6 #(
    .INIT(64'h028AFFFF0000028A)) 
    \out_data[1]_i_8 
       (.I0(\logits_reg[3] [28]),
        .I1(\out_data_reg[0]_i_4_n_0 ),
        .I2(\logits_reg[0] [28]),
        .I3(\logits_reg[1] [28]),
        .I4(am_best[29]),
        .I5(\logits_reg[3] [29]),
        .O(\out_data[1]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'h028AFFFF0000028A)) 
    \out_data[1]_i_9 
       (.I0(\logits_reg[3] [26]),
        .I1(\out_data_reg[0]_i_4_n_0 ),
        .I2(\logits_reg[0] [26]),
        .I3(\logits_reg[1] [26]),
        .I4(am_best[27]),
        .I5(\logits_reg[3] [27]),
        .O(\out_data[1]_i_9_n_0 ));
  LUT5 #(
    .INIT(32'hB8FF3000)) 
    \out_data[20]_i_1 
       (.I0(out_id[1]),
        .I1(out_id[2]),
        .I2(\out_data[20]_i_2_n_0 ),
        .I3(state[1]),
        .I4(\logits_reg[0] [20]),
        .O(\out_data[20]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \out_data[20]_i_2 
       (.I0(\logits_reg[4] [20]),
        .I1(\logits_reg[3] [20]),
        .I2(out_id[1]),
        .I3(\logits_reg[2] [20]),
        .I4(out_id[0]),
        .I5(\logits_reg[1] [20]),
        .O(\out_data[20]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hB8FF3000)) 
    \out_data[21]_i_1 
       (.I0(out_id[1]),
        .I1(out_id[2]),
        .I2(\out_data[21]_i_2_n_0 ),
        .I3(state[1]),
        .I4(\logits_reg[0] [21]),
        .O(\out_data[21]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \out_data[21]_i_2 
       (.I0(\logits_reg[4] [21]),
        .I1(\logits_reg[3] [21]),
        .I2(out_id[1]),
        .I3(\logits_reg[2] [21]),
        .I4(out_id[0]),
        .I5(\logits_reg[1] [21]),
        .O(\out_data[21]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hB8FF3000)) 
    \out_data[22]_i_1 
       (.I0(out_id[1]),
        .I1(out_id[2]),
        .I2(\out_data[22]_i_2_n_0 ),
        .I3(state[1]),
        .I4(\logits_reg[0] [22]),
        .O(\out_data[22]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \out_data[22]_i_2 
       (.I0(\logits_reg[4] [22]),
        .I1(\logits_reg[3] [22]),
        .I2(out_id[1]),
        .I3(\logits_reg[2] [22]),
        .I4(out_id[0]),
        .I5(\logits_reg[1] [22]),
        .O(\out_data[22]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hB8FF3000)) 
    \out_data[23]_i_1 
       (.I0(out_id[1]),
        .I1(out_id[2]),
        .I2(\out_data[23]_i_2_n_0 ),
        .I3(state[1]),
        .I4(\logits_reg[0] [23]),
        .O(\out_data[23]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \out_data[23]_i_2 
       (.I0(\logits_reg[4] [23]),
        .I1(\logits_reg[3] [23]),
        .I2(out_id[1]),
        .I3(\logits_reg[2] [23]),
        .I4(out_id[0]),
        .I5(\logits_reg[1] [23]),
        .O(\out_data[23]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hB8FF3000)) 
    \out_data[24]_i_1 
       (.I0(out_id[1]),
        .I1(out_id[2]),
        .I2(\out_data[24]_i_2_n_0 ),
        .I3(state[1]),
        .I4(\logits_reg[0] [24]),
        .O(\out_data[24]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \out_data[24]_i_2 
       (.I0(\logits_reg[4] [24]),
        .I1(\logits_reg[3] [24]),
        .I2(out_id[1]),
        .I3(\logits_reg[2] [24]),
        .I4(out_id[0]),
        .I5(\logits_reg[1] [24]),
        .O(\out_data[24]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hB8FF3000)) 
    \out_data[25]_i_1 
       (.I0(out_id[1]),
        .I1(out_id[2]),
        .I2(\out_data[25]_i_2_n_0 ),
        .I3(state[1]),
        .I4(\logits_reg[0] [25]),
        .O(\out_data[25]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \out_data[25]_i_2 
       (.I0(\logits_reg[4] [25]),
        .I1(\logits_reg[3] [25]),
        .I2(out_id[1]),
        .I3(\logits_reg[2] [25]),
        .I4(out_id[0]),
        .I5(\logits_reg[1] [25]),
        .O(\out_data[25]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hB8FF3000)) 
    \out_data[26]_i_1 
       (.I0(out_id[1]),
        .I1(out_id[2]),
        .I2(\out_data[26]_i_2_n_0 ),
        .I3(state[1]),
        .I4(\logits_reg[0] [26]),
        .O(\out_data[26]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \out_data[26]_i_2 
       (.I0(\logits_reg[4] [26]),
        .I1(\logits_reg[3] [26]),
        .I2(out_id[1]),
        .I3(\logits_reg[2] [26]),
        .I4(out_id[0]),
        .I5(\logits_reg[1] [26]),
        .O(\out_data[26]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hB8FF3000)) 
    \out_data[27]_i_1 
       (.I0(out_id[1]),
        .I1(out_id[2]),
        .I2(\out_data[27]_i_2_n_0 ),
        .I3(state[1]),
        .I4(\logits_reg[0] [27]),
        .O(\out_data[27]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \out_data[27]_i_2 
       (.I0(\logits_reg[4] [27]),
        .I1(\logits_reg[3] [27]),
        .I2(out_id[1]),
        .I3(\logits_reg[2] [27]),
        .I4(out_id[0]),
        .I5(\logits_reg[1] [27]),
        .O(\out_data[27]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hB8FF3000)) 
    \out_data[28]_i_1 
       (.I0(out_id[1]),
        .I1(out_id[2]),
        .I2(\out_data[28]_i_2_n_0 ),
        .I3(state[1]),
        .I4(\logits_reg[0] [28]),
        .O(\out_data[28]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \out_data[28]_i_2 
       (.I0(\logits_reg[4] [28]),
        .I1(\logits_reg[3] [28]),
        .I2(out_id[1]),
        .I3(\logits_reg[2] [28]),
        .I4(out_id[0]),
        .I5(\logits_reg[1] [28]),
        .O(\out_data[28]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hB8FF3000)) 
    \out_data[29]_i_1 
       (.I0(out_id[1]),
        .I1(out_id[2]),
        .I2(\out_data[29]_i_2_n_0 ),
        .I3(state[1]),
        .I4(\logits_reg[0] [29]),
        .O(\out_data[29]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \out_data[29]_i_2 
       (.I0(\logits_reg[4] [29]),
        .I1(\logits_reg[3] [29]),
        .I2(out_id[1]),
        .I3(\logits_reg[2] [29]),
        .I4(out_id[0]),
        .I5(\logits_reg[1] [29]),
        .O(\out_data[29]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \out_data[2]_i_1 
       (.I0(out_id[1]),
        .I1(\out_data_reg[2]_i_2_n_0 ),
        .I2(out_id[2]),
        .I3(\out_data[2]_i_3_n_0 ),
        .I4(state[1]),
        .I5(\logits_reg[0] [2]),
        .O(\out_data[2]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[2]_i_10 
       (.I0(\logits_reg[4] [28]),
        .I1(\out_data[2]_i_24_n_0 ),
        .I2(\logits_reg[4] [29]),
        .I3(\out_data[2]_i_25_n_0 ),
        .O(\out_data[2]_i_10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair66" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_data[2]_i_100 
       (.I0(\logits_reg[1] [3]),
        .I1(\logits_reg[0] [3]),
        .I2(\out_data_reg[0]_i_4_n_0 ),
        .O(am_best[3]));
  (* SOFT_HLUTNM = "soft_lutpair65" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_data[2]_i_101 
       (.I0(\logits_reg[1] [0]),
        .I1(\logits_reg[0] [0]),
        .I2(\out_data_reg[0]_i_4_n_0 ),
        .O(am_best[0]));
  (* SOFT_HLUTNM = "soft_lutpair65" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_data[2]_i_102 
       (.I0(\logits_reg[1] [1]),
        .I1(\logits_reg[0] [1]),
        .I2(\out_data_reg[0]_i_4_n_0 ),
        .O(am_best[1]));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[2]_i_11 
       (.I0(\logits_reg[4] [26]),
        .I1(\out_data[2]_i_26_n_0 ),
        .I2(\logits_reg[4] [27]),
        .I3(\out_data[2]_i_27_n_0 ),
        .O(\out_data[2]_i_11_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[2]_i_12 
       (.I0(\logits_reg[4] [24]),
        .I1(\out_data[2]_i_28_n_0 ),
        .I2(\logits_reg[4] [25]),
        .I3(\out_data[2]_i_29_n_0 ),
        .O(\out_data[2]_i_12_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[2]_i_14 
       (.I0(\logits_reg[4] [22]),
        .I1(\out_data[2]_i_39_n_0 ),
        .I2(\out_data[2]_i_40_n_0 ),
        .I3(\logits_reg[4] [23]),
        .O(\out_data[2]_i_14_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[2]_i_15 
       (.I0(\logits_reg[4] [20]),
        .I1(\out_data[2]_i_41_n_0 ),
        .I2(\out_data[2]_i_42_n_0 ),
        .I3(\logits_reg[4] [21]),
        .O(\out_data[2]_i_15_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[2]_i_16 
       (.I0(\logits_reg[4] [18]),
        .I1(\out_data[2]_i_43_n_0 ),
        .I2(\out_data[2]_i_44_n_0 ),
        .I3(\logits_reg[4] [19]),
        .O(\out_data[2]_i_16_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[2]_i_17 
       (.I0(\logits_reg[4] [16]),
        .I1(\out_data[2]_i_45_n_0 ),
        .I2(\out_data[2]_i_46_n_0 ),
        .I3(\logits_reg[4] [17]),
        .O(\out_data[2]_i_17_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[2]_i_18 
       (.I0(\logits_reg[4] [22]),
        .I1(\out_data[2]_i_39_n_0 ),
        .I2(\logits_reg[4] [23]),
        .I3(\out_data[2]_i_40_n_0 ),
        .O(\out_data[2]_i_18_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[2]_i_19 
       (.I0(\logits_reg[4] [20]),
        .I1(\out_data[2]_i_41_n_0 ),
        .I2(\logits_reg[4] [21]),
        .I3(\out_data[2]_i_42_n_0 ),
        .O(\out_data[2]_i_19_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[2]_i_20 
       (.I0(\logits_reg[4] [18]),
        .I1(\out_data[2]_i_43_n_0 ),
        .I2(\logits_reg[4] [19]),
        .I3(\out_data[2]_i_44_n_0 ),
        .O(\out_data[2]_i_20_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[2]_i_21 
       (.I0(\logits_reg[4] [16]),
        .I1(\out_data[2]_i_45_n_0 ),
        .I2(\logits_reg[4] [17]),
        .I3(\out_data[2]_i_46_n_0 ),
        .O(\out_data[2]_i_21_n_0 ));
  LUT6 #(
    .INIT(64'hEF40EF4FEF40E040)) 
    \out_data[2]_i_22 
       (.I0(\out_data_reg[0]_i_5_n_0 ),
        .I1(\logits_reg[2] [30]),
        .I2(\out_data_reg[1]_i_5_n_0 ),
        .I3(\logits_reg[3] [30]),
        .I4(\out_data_reg[1]_i_4_n_0 ),
        .I5(am_best[30]),
        .O(\out_data[2]_i_22_n_0 ));
  LUT6 #(
    .INIT(64'hEF40EF4FEF40E040)) 
    \out_data[2]_i_23 
       (.I0(\out_data_reg[0]_i_5_n_0 ),
        .I1(\logits_reg[2] [31]),
        .I2(\out_data_reg[1]_i_5_n_0 ),
        .I3(\logits_reg[3] [31]),
        .I4(\out_data_reg[1]_i_4_n_0 ),
        .I5(am_best[31]),
        .O(\out_data[2]_i_23_n_0 ));
  LUT6 #(
    .INIT(64'hEF40EF4FEF40E040)) 
    \out_data[2]_i_24 
       (.I0(\out_data_reg[0]_i_5_n_0 ),
        .I1(\logits_reg[2] [28]),
        .I2(\out_data_reg[1]_i_5_n_0 ),
        .I3(\logits_reg[3] [28]),
        .I4(\out_data_reg[1]_i_4_n_0 ),
        .I5(am_best[28]),
        .O(\out_data[2]_i_24_n_0 ));
  LUT6 #(
    .INIT(64'hEF40EF4FEF40E040)) 
    \out_data[2]_i_25 
       (.I0(\out_data_reg[0]_i_5_n_0 ),
        .I1(\logits_reg[2] [29]),
        .I2(\out_data_reg[1]_i_5_n_0 ),
        .I3(\logits_reg[3] [29]),
        .I4(\out_data_reg[1]_i_4_n_0 ),
        .I5(am_best[29]),
        .O(\out_data[2]_i_25_n_0 ));
  LUT6 #(
    .INIT(64'hEF40EF4FEF40E040)) 
    \out_data[2]_i_26 
       (.I0(\out_data_reg[0]_i_5_n_0 ),
        .I1(\logits_reg[2] [26]),
        .I2(\out_data_reg[1]_i_5_n_0 ),
        .I3(\logits_reg[3] [26]),
        .I4(\out_data_reg[1]_i_4_n_0 ),
        .I5(am_best[26]),
        .O(\out_data[2]_i_26_n_0 ));
  LUT6 #(
    .INIT(64'hEF40EF4FEF40E040)) 
    \out_data[2]_i_27 
       (.I0(\out_data_reg[0]_i_5_n_0 ),
        .I1(\logits_reg[2] [27]),
        .I2(\out_data_reg[1]_i_5_n_0 ),
        .I3(\logits_reg[3] [27]),
        .I4(\out_data_reg[1]_i_4_n_0 ),
        .I5(am_best[27]),
        .O(\out_data[2]_i_27_n_0 ));
  LUT6 #(
    .INIT(64'hEF40EF4FEF40E040)) 
    \out_data[2]_i_28 
       (.I0(\out_data_reg[0]_i_5_n_0 ),
        .I1(\logits_reg[2] [24]),
        .I2(\out_data_reg[1]_i_5_n_0 ),
        .I3(\logits_reg[3] [24]),
        .I4(\out_data_reg[1]_i_4_n_0 ),
        .I5(am_best[24]),
        .O(\out_data[2]_i_28_n_0 ));
  LUT6 #(
    .INIT(64'hEF40EF4FEF40E040)) 
    \out_data[2]_i_29 
       (.I0(\out_data_reg[0]_i_5_n_0 ),
        .I1(\logits_reg[2] [25]),
        .I2(\out_data_reg[1]_i_5_n_0 ),
        .I3(\logits_reg[3] [25]),
        .I4(\out_data_reg[1]_i_4_n_0 ),
        .I5(am_best[25]),
        .O(\out_data[2]_i_29_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \out_data[2]_i_3 
       (.I0(\logits_reg[4] [2]),
        .I1(\logits_reg[3] [2]),
        .I2(out_id[1]),
        .I3(\logits_reg[2] [2]),
        .I4(out_id[0]),
        .I5(\logits_reg[1] [2]),
        .O(\out_data[2]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[2]_i_31 
       (.I0(\logits_reg[4] [14]),
        .I1(\out_data[2]_i_63_n_0 ),
        .I2(\out_data[2]_i_64_n_0 ),
        .I3(\logits_reg[4] [15]),
        .O(\out_data[2]_i_31_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[2]_i_32 
       (.I0(\logits_reg[4] [12]),
        .I1(\out_data[2]_i_65_n_0 ),
        .I2(\out_data[2]_i_66_n_0 ),
        .I3(\logits_reg[4] [13]),
        .O(\out_data[2]_i_32_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[2]_i_33 
       (.I0(\logits_reg[4] [10]),
        .I1(\out_data[2]_i_67_n_0 ),
        .I2(\out_data[2]_i_68_n_0 ),
        .I3(\logits_reg[4] [11]),
        .O(\out_data[2]_i_33_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[2]_i_34 
       (.I0(\logits_reg[4] [8]),
        .I1(\out_data[2]_i_69_n_0 ),
        .I2(\out_data[2]_i_70_n_0 ),
        .I3(\logits_reg[4] [9]),
        .O(\out_data[2]_i_34_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[2]_i_35 
       (.I0(\logits_reg[4] [14]),
        .I1(\out_data[2]_i_63_n_0 ),
        .I2(\logits_reg[4] [15]),
        .I3(\out_data[2]_i_64_n_0 ),
        .O(\out_data[2]_i_35_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[2]_i_36 
       (.I0(\logits_reg[4] [12]),
        .I1(\out_data[2]_i_65_n_0 ),
        .I2(\logits_reg[4] [13]),
        .I3(\out_data[2]_i_66_n_0 ),
        .O(\out_data[2]_i_36_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[2]_i_37 
       (.I0(\logits_reg[4] [10]),
        .I1(\out_data[2]_i_67_n_0 ),
        .I2(\logits_reg[4] [11]),
        .I3(\out_data[2]_i_68_n_0 ),
        .O(\out_data[2]_i_37_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[2]_i_38 
       (.I0(\logits_reg[4] [8]),
        .I1(\out_data[2]_i_69_n_0 ),
        .I2(\logits_reg[4] [9]),
        .I3(\out_data[2]_i_70_n_0 ),
        .O(\out_data[2]_i_38_n_0 ));
  LUT6 #(
    .INIT(64'hEF40EF4FEF40E040)) 
    \out_data[2]_i_39 
       (.I0(\out_data_reg[0]_i_5_n_0 ),
        .I1(\logits_reg[2] [22]),
        .I2(\out_data_reg[1]_i_5_n_0 ),
        .I3(\logits_reg[3] [22]),
        .I4(\out_data_reg[1]_i_4_n_0 ),
        .I5(am_best[22]),
        .O(\out_data[2]_i_39_n_0 ));
  LUT6 #(
    .INIT(64'hEF40EF4FEF40E040)) 
    \out_data[2]_i_40 
       (.I0(\out_data_reg[0]_i_5_n_0 ),
        .I1(\logits_reg[2] [23]),
        .I2(\out_data_reg[1]_i_5_n_0 ),
        .I3(\logits_reg[3] [23]),
        .I4(\out_data_reg[1]_i_4_n_0 ),
        .I5(am_best[23]),
        .O(\out_data[2]_i_40_n_0 ));
  LUT6 #(
    .INIT(64'hEF40EF4FEF40E040)) 
    \out_data[2]_i_41 
       (.I0(\out_data_reg[0]_i_5_n_0 ),
        .I1(\logits_reg[2] [20]),
        .I2(\out_data_reg[1]_i_5_n_0 ),
        .I3(\logits_reg[3] [20]),
        .I4(\out_data_reg[1]_i_4_n_0 ),
        .I5(am_best[20]),
        .O(\out_data[2]_i_41_n_0 ));
  LUT6 #(
    .INIT(64'hEF40EF4FEF40E040)) 
    \out_data[2]_i_42 
       (.I0(\out_data_reg[0]_i_5_n_0 ),
        .I1(\logits_reg[2] [21]),
        .I2(\out_data_reg[1]_i_5_n_0 ),
        .I3(\logits_reg[3] [21]),
        .I4(\out_data_reg[1]_i_4_n_0 ),
        .I5(am_best[21]),
        .O(\out_data[2]_i_42_n_0 ));
  LUT6 #(
    .INIT(64'hEF40EF4FEF40E040)) 
    \out_data[2]_i_43 
       (.I0(\out_data_reg[0]_i_5_n_0 ),
        .I1(\logits_reg[2] [18]),
        .I2(\out_data_reg[1]_i_5_n_0 ),
        .I3(\logits_reg[3] [18]),
        .I4(\out_data_reg[1]_i_4_n_0 ),
        .I5(am_best[18]),
        .O(\out_data[2]_i_43_n_0 ));
  LUT6 #(
    .INIT(64'hEF40EF4FEF40E040)) 
    \out_data[2]_i_44 
       (.I0(\out_data_reg[0]_i_5_n_0 ),
        .I1(\logits_reg[2] [19]),
        .I2(\out_data_reg[1]_i_5_n_0 ),
        .I3(\logits_reg[3] [19]),
        .I4(\out_data_reg[1]_i_4_n_0 ),
        .I5(am_best[19]),
        .O(\out_data[2]_i_44_n_0 ));
  LUT6 #(
    .INIT(64'hEF40EF4FEF40E040)) 
    \out_data[2]_i_45 
       (.I0(\out_data_reg[0]_i_5_n_0 ),
        .I1(\logits_reg[2] [16]),
        .I2(\out_data_reg[1]_i_5_n_0 ),
        .I3(\logits_reg[3] [16]),
        .I4(\out_data_reg[1]_i_4_n_0 ),
        .I5(am_best[16]),
        .O(\out_data[2]_i_45_n_0 ));
  LUT6 #(
    .INIT(64'hEF40EF4FEF40E040)) 
    \out_data[2]_i_46 
       (.I0(\out_data_reg[0]_i_5_n_0 ),
        .I1(\logits_reg[2] [17]),
        .I2(\out_data_reg[1]_i_5_n_0 ),
        .I3(\logits_reg[3] [17]),
        .I4(\out_data_reg[1]_i_4_n_0 ),
        .I5(am_best[17]),
        .O(\out_data[2]_i_46_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair80" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_data[2]_i_47 
       (.I0(\logits_reg[1] [30]),
        .I1(\logits_reg[0] [30]),
        .I2(\out_data_reg[0]_i_4_n_0 ),
        .O(am_best[30]));
  (* SOFT_HLUTNM = "soft_lutpair80" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_data[2]_i_48 
       (.I0(\logits_reg[1] [31]),
        .I1(\logits_reg[0] [31]),
        .I2(\out_data_reg[0]_i_4_n_0 ),
        .O(am_best[31]));
  (* SOFT_HLUTNM = "soft_lutpair79" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_data[2]_i_49 
       (.I0(\logits_reg[1] [28]),
        .I1(\logits_reg[0] [28]),
        .I2(\out_data_reg[0]_i_4_n_0 ),
        .O(am_best[28]));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[2]_i_5 
       (.I0(\logits_reg[4] [30]),
        .I1(\out_data[2]_i_22_n_0 ),
        .I2(\logits_reg[4] [31]),
        .I3(\out_data[2]_i_23_n_0 ),
        .O(\out_data[2]_i_5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair79" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_data[2]_i_50 
       (.I0(\logits_reg[1] [29]),
        .I1(\logits_reg[0] [29]),
        .I2(\out_data_reg[0]_i_4_n_0 ),
        .O(am_best[29]));
  (* SOFT_HLUTNM = "soft_lutpair78" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_data[2]_i_51 
       (.I0(\logits_reg[1] [26]),
        .I1(\logits_reg[0] [26]),
        .I2(\out_data_reg[0]_i_4_n_0 ),
        .O(am_best[26]));
  (* SOFT_HLUTNM = "soft_lutpair78" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_data[2]_i_52 
       (.I0(\logits_reg[1] [27]),
        .I1(\logits_reg[0] [27]),
        .I2(\out_data_reg[0]_i_4_n_0 ),
        .O(am_best[27]));
  (* SOFT_HLUTNM = "soft_lutpair77" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_data[2]_i_53 
       (.I0(\logits_reg[1] [24]),
        .I1(\logits_reg[0] [24]),
        .I2(\out_data_reg[0]_i_4_n_0 ),
        .O(am_best[24]));
  (* SOFT_HLUTNM = "soft_lutpair77" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_data[2]_i_54 
       (.I0(\logits_reg[1] [25]),
        .I1(\logits_reg[0] [25]),
        .I2(\out_data_reg[0]_i_4_n_0 ),
        .O(am_best[25]));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[2]_i_55 
       (.I0(\logits_reg[4] [6]),
        .I1(\out_data[2]_i_79_n_0 ),
        .I2(\out_data[2]_i_80_n_0 ),
        .I3(\logits_reg[4] [7]),
        .O(\out_data[2]_i_55_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[2]_i_56 
       (.I0(\logits_reg[4] [4]),
        .I1(\out_data[2]_i_81_n_0 ),
        .I2(\out_data[2]_i_82_n_0 ),
        .I3(\logits_reg[4] [5]),
        .O(\out_data[2]_i_56_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[2]_i_57 
       (.I0(\logits_reg[4] [2]),
        .I1(\out_data[2]_i_83_n_0 ),
        .I2(\out_data[2]_i_84_n_0 ),
        .I3(\logits_reg[4] [3]),
        .O(\out_data[2]_i_57_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[2]_i_58 
       (.I0(\logits_reg[4] [0]),
        .I1(\out_data[2]_i_85_n_0 ),
        .I2(\out_data[2]_i_86_n_0 ),
        .I3(\logits_reg[4] [1]),
        .O(\out_data[2]_i_58_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[2]_i_59 
       (.I0(\logits_reg[4] [6]),
        .I1(\out_data[2]_i_79_n_0 ),
        .I2(\logits_reg[4] [7]),
        .I3(\out_data[2]_i_80_n_0 ),
        .O(\out_data[2]_i_59_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[2]_i_6 
       (.I0(\logits_reg[4] [28]),
        .I1(\out_data[2]_i_24_n_0 ),
        .I2(\out_data[2]_i_25_n_0 ),
        .I3(\logits_reg[4] [29]),
        .O(\out_data[2]_i_6_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[2]_i_60 
       (.I0(\logits_reg[4] [4]),
        .I1(\out_data[2]_i_81_n_0 ),
        .I2(\logits_reg[4] [5]),
        .I3(\out_data[2]_i_82_n_0 ),
        .O(\out_data[2]_i_60_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[2]_i_61 
       (.I0(\logits_reg[4] [2]),
        .I1(\out_data[2]_i_83_n_0 ),
        .I2(\logits_reg[4] [3]),
        .I3(\out_data[2]_i_84_n_0 ),
        .O(\out_data[2]_i_61_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[2]_i_62 
       (.I0(\logits_reg[4] [0]),
        .I1(\out_data[2]_i_85_n_0 ),
        .I2(\logits_reg[4] [1]),
        .I3(\out_data[2]_i_86_n_0 ),
        .O(\out_data[2]_i_62_n_0 ));
  LUT6 #(
    .INIT(64'hEF40EF4FEF40E040)) 
    \out_data[2]_i_63 
       (.I0(\out_data_reg[0]_i_5_n_0 ),
        .I1(\logits_reg[2] [14]),
        .I2(\out_data_reg[1]_i_5_n_0 ),
        .I3(\logits_reg[3] [14]),
        .I4(\out_data_reg[1]_i_4_n_0 ),
        .I5(am_best[14]),
        .O(\out_data[2]_i_63_n_0 ));
  LUT6 #(
    .INIT(64'hEF40EF4FEF40E040)) 
    \out_data[2]_i_64 
       (.I0(\out_data_reg[0]_i_5_n_0 ),
        .I1(\logits_reg[2] [15]),
        .I2(\out_data_reg[1]_i_5_n_0 ),
        .I3(\logits_reg[3] [15]),
        .I4(\out_data_reg[1]_i_4_n_0 ),
        .I5(am_best[15]),
        .O(\out_data[2]_i_64_n_0 ));
  LUT6 #(
    .INIT(64'hEF40EF4FEF40E040)) 
    \out_data[2]_i_65 
       (.I0(\out_data_reg[0]_i_5_n_0 ),
        .I1(\logits_reg[2] [12]),
        .I2(\out_data_reg[1]_i_5_n_0 ),
        .I3(\logits_reg[3] [12]),
        .I4(\out_data_reg[1]_i_4_n_0 ),
        .I5(am_best[12]),
        .O(\out_data[2]_i_65_n_0 ));
  LUT6 #(
    .INIT(64'hEF40EF4FEF40E040)) 
    \out_data[2]_i_66 
       (.I0(\out_data_reg[0]_i_5_n_0 ),
        .I1(\logits_reg[2] [13]),
        .I2(\out_data_reg[1]_i_5_n_0 ),
        .I3(\logits_reg[3] [13]),
        .I4(\out_data_reg[1]_i_4_n_0 ),
        .I5(am_best[13]),
        .O(\out_data[2]_i_66_n_0 ));
  LUT6 #(
    .INIT(64'hEF40EF4FEF40E040)) 
    \out_data[2]_i_67 
       (.I0(\out_data_reg[0]_i_5_n_0 ),
        .I1(\logits_reg[2] [10]),
        .I2(\out_data_reg[1]_i_5_n_0 ),
        .I3(\logits_reg[3] [10]),
        .I4(\out_data_reg[1]_i_4_n_0 ),
        .I5(am_best[10]),
        .O(\out_data[2]_i_67_n_0 ));
  LUT6 #(
    .INIT(64'hEF40EF4FEF40E040)) 
    \out_data[2]_i_68 
       (.I0(\out_data_reg[0]_i_5_n_0 ),
        .I1(\logits_reg[2] [11]),
        .I2(\out_data_reg[1]_i_5_n_0 ),
        .I3(\logits_reg[3] [11]),
        .I4(\out_data_reg[1]_i_4_n_0 ),
        .I5(am_best[11]),
        .O(\out_data[2]_i_68_n_0 ));
  LUT6 #(
    .INIT(64'hEF40EF4FEF40E040)) 
    \out_data[2]_i_69 
       (.I0(\out_data_reg[0]_i_5_n_0 ),
        .I1(\logits_reg[2] [8]),
        .I2(\out_data_reg[1]_i_5_n_0 ),
        .I3(\logits_reg[3] [8]),
        .I4(\out_data_reg[1]_i_4_n_0 ),
        .I5(am_best[8]),
        .O(\out_data[2]_i_69_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[2]_i_7 
       (.I0(\logits_reg[4] [26]),
        .I1(\out_data[2]_i_26_n_0 ),
        .I2(\out_data[2]_i_27_n_0 ),
        .I3(\logits_reg[4] [27]),
        .O(\out_data[2]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hEF40EF4FEF40E040)) 
    \out_data[2]_i_70 
       (.I0(\out_data_reg[0]_i_5_n_0 ),
        .I1(\logits_reg[2] [9]),
        .I2(\out_data_reg[1]_i_5_n_0 ),
        .I3(\logits_reg[3] [9]),
        .I4(\out_data_reg[1]_i_4_n_0 ),
        .I5(am_best[9]),
        .O(\out_data[2]_i_70_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair76" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_data[2]_i_71 
       (.I0(\logits_reg[1] [22]),
        .I1(\logits_reg[0] [22]),
        .I2(\out_data_reg[0]_i_4_n_0 ),
        .O(am_best[22]));
  (* SOFT_HLUTNM = "soft_lutpair76" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_data[2]_i_72 
       (.I0(\logits_reg[1] [23]),
        .I1(\logits_reg[0] [23]),
        .I2(\out_data_reg[0]_i_4_n_0 ),
        .O(am_best[23]));
  (* SOFT_HLUTNM = "soft_lutpair75" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_data[2]_i_73 
       (.I0(\logits_reg[1] [20]),
        .I1(\logits_reg[0] [20]),
        .I2(\out_data_reg[0]_i_4_n_0 ),
        .O(am_best[20]));
  (* SOFT_HLUTNM = "soft_lutpair75" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_data[2]_i_74 
       (.I0(\logits_reg[1] [21]),
        .I1(\logits_reg[0] [21]),
        .I2(\out_data_reg[0]_i_4_n_0 ),
        .O(am_best[21]));
  (* SOFT_HLUTNM = "soft_lutpair74" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_data[2]_i_75 
       (.I0(\logits_reg[1] [18]),
        .I1(\logits_reg[0] [18]),
        .I2(\out_data_reg[0]_i_4_n_0 ),
        .O(am_best[18]));
  (* SOFT_HLUTNM = "soft_lutpair74" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_data[2]_i_76 
       (.I0(\logits_reg[1] [19]),
        .I1(\logits_reg[0] [19]),
        .I2(\out_data_reg[0]_i_4_n_0 ),
        .O(am_best[19]));
  (* SOFT_HLUTNM = "soft_lutpair73" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_data[2]_i_77 
       (.I0(\logits_reg[1] [16]),
        .I1(\logits_reg[0] [16]),
        .I2(\out_data_reg[0]_i_4_n_0 ),
        .O(am_best[16]));
  (* SOFT_HLUTNM = "soft_lutpair73" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_data[2]_i_78 
       (.I0(\logits_reg[1] [17]),
        .I1(\logits_reg[0] [17]),
        .I2(\out_data_reg[0]_i_4_n_0 ),
        .O(am_best[17]));
  LUT6 #(
    .INIT(64'hEF40EF4FEF40E040)) 
    \out_data[2]_i_79 
       (.I0(\out_data_reg[0]_i_5_n_0 ),
        .I1(\logits_reg[2] [6]),
        .I2(\out_data_reg[1]_i_5_n_0 ),
        .I3(\logits_reg[3] [6]),
        .I4(\out_data_reg[1]_i_4_n_0 ),
        .I5(am_best[6]),
        .O(\out_data[2]_i_79_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \out_data[2]_i_8 
       (.I0(\logits_reg[4] [24]),
        .I1(\out_data[2]_i_28_n_0 ),
        .I2(\out_data[2]_i_29_n_0 ),
        .I3(\logits_reg[4] [25]),
        .O(\out_data[2]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hEF40EF4FEF40E040)) 
    \out_data[2]_i_80 
       (.I0(\out_data_reg[0]_i_5_n_0 ),
        .I1(\logits_reg[2] [7]),
        .I2(\out_data_reg[1]_i_5_n_0 ),
        .I3(\logits_reg[3] [7]),
        .I4(\out_data_reg[1]_i_4_n_0 ),
        .I5(am_best[7]),
        .O(\out_data[2]_i_80_n_0 ));
  LUT6 #(
    .INIT(64'hEF40EF4FEF40E040)) 
    \out_data[2]_i_81 
       (.I0(\out_data_reg[0]_i_5_n_0 ),
        .I1(\logits_reg[2] [4]),
        .I2(\out_data_reg[1]_i_5_n_0 ),
        .I3(\logits_reg[3] [4]),
        .I4(\out_data_reg[1]_i_4_n_0 ),
        .I5(am_best[4]),
        .O(\out_data[2]_i_81_n_0 ));
  LUT6 #(
    .INIT(64'hEF40EF4FEF40E040)) 
    \out_data[2]_i_82 
       (.I0(\out_data_reg[0]_i_5_n_0 ),
        .I1(\logits_reg[2] [5]),
        .I2(\out_data_reg[1]_i_5_n_0 ),
        .I3(\logits_reg[3] [5]),
        .I4(\out_data_reg[1]_i_4_n_0 ),
        .I5(am_best[5]),
        .O(\out_data[2]_i_82_n_0 ));
  LUT6 #(
    .INIT(64'hEF40EF4FEF40E040)) 
    \out_data[2]_i_83 
       (.I0(\out_data_reg[0]_i_5_n_0 ),
        .I1(\logits_reg[2] [2]),
        .I2(\out_data_reg[1]_i_5_n_0 ),
        .I3(\logits_reg[3] [2]),
        .I4(\out_data_reg[1]_i_4_n_0 ),
        .I5(am_best[2]),
        .O(\out_data[2]_i_83_n_0 ));
  LUT6 #(
    .INIT(64'hEF40EF4FEF40E040)) 
    \out_data[2]_i_84 
       (.I0(\out_data_reg[0]_i_5_n_0 ),
        .I1(\logits_reg[2] [3]),
        .I2(\out_data_reg[1]_i_5_n_0 ),
        .I3(\logits_reg[3] [3]),
        .I4(\out_data_reg[1]_i_4_n_0 ),
        .I5(am_best[3]),
        .O(\out_data[2]_i_84_n_0 ));
  LUT6 #(
    .INIT(64'hEF40EF4FEF40E040)) 
    \out_data[2]_i_85 
       (.I0(\out_data_reg[0]_i_5_n_0 ),
        .I1(\logits_reg[2] [0]),
        .I2(\out_data_reg[1]_i_5_n_0 ),
        .I3(\logits_reg[3] [0]),
        .I4(\out_data_reg[1]_i_4_n_0 ),
        .I5(am_best[0]),
        .O(\out_data[2]_i_85_n_0 ));
  LUT6 #(
    .INIT(64'hEF40EF4FEF40E040)) 
    \out_data[2]_i_86 
       (.I0(\out_data_reg[0]_i_5_n_0 ),
        .I1(\logits_reg[2] [1]),
        .I2(\out_data_reg[1]_i_5_n_0 ),
        .I3(\logits_reg[3] [1]),
        .I4(\out_data_reg[1]_i_4_n_0 ),
        .I5(am_best[1]),
        .O(\out_data[2]_i_86_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair72" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_data[2]_i_87 
       (.I0(\logits_reg[1] [14]),
        .I1(\logits_reg[0] [14]),
        .I2(\out_data_reg[0]_i_4_n_0 ),
        .O(am_best[14]));
  (* SOFT_HLUTNM = "soft_lutpair72" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_data[2]_i_88 
       (.I0(\logits_reg[1] [15]),
        .I1(\logits_reg[0] [15]),
        .I2(\out_data_reg[0]_i_4_n_0 ),
        .O(am_best[15]));
  (* SOFT_HLUTNM = "soft_lutpair71" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_data[2]_i_89 
       (.I0(\logits_reg[1] [12]),
        .I1(\logits_reg[0] [12]),
        .I2(\out_data_reg[0]_i_4_n_0 ),
        .O(am_best[12]));
  LUT4 #(
    .INIT(16'h9009)) 
    \out_data[2]_i_9 
       (.I0(\logits_reg[4] [30]),
        .I1(\out_data[2]_i_22_n_0 ),
        .I2(\out_data[2]_i_23_n_0 ),
        .I3(\logits_reg[4] [31]),
        .O(\out_data[2]_i_9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair71" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_data[2]_i_90 
       (.I0(\logits_reg[1] [13]),
        .I1(\logits_reg[0] [13]),
        .I2(\out_data_reg[0]_i_4_n_0 ),
        .O(am_best[13]));
  (* SOFT_HLUTNM = "soft_lutpair70" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_data[2]_i_91 
       (.I0(\logits_reg[1] [10]),
        .I1(\logits_reg[0] [10]),
        .I2(\out_data_reg[0]_i_4_n_0 ),
        .O(am_best[10]));
  (* SOFT_HLUTNM = "soft_lutpair70" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_data[2]_i_92 
       (.I0(\logits_reg[1] [11]),
        .I1(\logits_reg[0] [11]),
        .I2(\out_data_reg[0]_i_4_n_0 ),
        .O(am_best[11]));
  (* SOFT_HLUTNM = "soft_lutpair69" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_data[2]_i_93 
       (.I0(\logits_reg[1] [8]),
        .I1(\logits_reg[0] [8]),
        .I2(\out_data_reg[0]_i_4_n_0 ),
        .O(am_best[8]));
  (* SOFT_HLUTNM = "soft_lutpair69" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_data[2]_i_94 
       (.I0(\logits_reg[1] [9]),
        .I1(\logits_reg[0] [9]),
        .I2(\out_data_reg[0]_i_4_n_0 ),
        .O(am_best[9]));
  (* SOFT_HLUTNM = "soft_lutpair68" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_data[2]_i_95 
       (.I0(\logits_reg[1] [6]),
        .I1(\logits_reg[0] [6]),
        .I2(\out_data_reg[0]_i_4_n_0 ),
        .O(am_best[6]));
  (* SOFT_HLUTNM = "soft_lutpair68" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_data[2]_i_96 
       (.I0(\logits_reg[1] [7]),
        .I1(\logits_reg[0] [7]),
        .I2(\out_data_reg[0]_i_4_n_0 ),
        .O(am_best[7]));
  (* SOFT_HLUTNM = "soft_lutpair67" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_data[2]_i_97 
       (.I0(\logits_reg[1] [4]),
        .I1(\logits_reg[0] [4]),
        .I2(\out_data_reg[0]_i_4_n_0 ),
        .O(am_best[4]));
  (* SOFT_HLUTNM = "soft_lutpair67" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_data[2]_i_98 
       (.I0(\logits_reg[1] [5]),
        .I1(\logits_reg[0] [5]),
        .I2(\out_data_reg[0]_i_4_n_0 ),
        .O(am_best[5]));
  (* SOFT_HLUTNM = "soft_lutpair66" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_data[2]_i_99 
       (.I0(\logits_reg[1] [2]),
        .I1(\logits_reg[0] [2]),
        .I2(\out_data_reg[0]_i_4_n_0 ),
        .O(am_best[2]));
  LUT5 #(
    .INIT(32'hB8FF3000)) 
    \out_data[30]_i_1 
       (.I0(out_id[1]),
        .I1(out_id[2]),
        .I2(\out_data[30]_i_2_n_0 ),
        .I3(state[1]),
        .I4(\logits_reg[0] [30]),
        .O(\out_data[30]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \out_data[30]_i_2 
       (.I0(\logits_reg[4] [30]),
        .I1(\logits_reg[3] [30]),
        .I2(out_id[1]),
        .I3(\logits_reg[2] [30]),
        .I4(out_id[0]),
        .I5(\logits_reg[1] [30]),
        .O(\out_data[30]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hB8FF3000)) 
    \out_data[31]_i_1 
       (.I0(out_id[1]),
        .I1(out_id[2]),
        .I2(\out_data[31]_i_2_n_0 ),
        .I3(state[1]),
        .I4(\logits_reg[0] [31]),
        .O(\out_data[31]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \out_data[31]_i_2 
       (.I0(\logits_reg[4] [31]),
        .I1(\logits_reg[3] [31]),
        .I2(out_id[1]),
        .I3(\logits_reg[2] [31]),
        .I4(out_id[0]),
        .I5(\logits_reg[1] [31]),
        .O(\out_data[31]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hB8FF3000)) 
    \out_data[3]_i_1 
       (.I0(out_id[1]),
        .I1(out_id[2]),
        .I2(\out_data[3]_i_2_n_0 ),
        .I3(state[1]),
        .I4(\logits_reg[0] [3]),
        .O(\out_data[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \out_data[3]_i_2 
       (.I0(\logits_reg[4] [3]),
        .I1(\logits_reg[3] [3]),
        .I2(out_id[1]),
        .I3(\logits_reg[2] [3]),
        .I4(out_id[0]),
        .I5(\logits_reg[1] [3]),
        .O(\out_data[3]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hB8FF3000)) 
    \out_data[4]_i_1 
       (.I0(out_id[1]),
        .I1(out_id[2]),
        .I2(\out_data[4]_i_2_n_0 ),
        .I3(state[1]),
        .I4(\logits_reg[0] [4]),
        .O(\out_data[4]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \out_data[4]_i_2 
       (.I0(\logits_reg[4] [4]),
        .I1(\logits_reg[3] [4]),
        .I2(out_id[1]),
        .I3(\logits_reg[2] [4]),
        .I4(out_id[0]),
        .I5(\logits_reg[1] [4]),
        .O(\out_data[4]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hB8FF3000)) 
    \out_data[5]_i_1 
       (.I0(out_id[1]),
        .I1(out_id[2]),
        .I2(\out_data[5]_i_2_n_0 ),
        .I3(state[1]),
        .I4(\logits_reg[0] [5]),
        .O(\out_data[5]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \out_data[5]_i_2 
       (.I0(\logits_reg[4] [5]),
        .I1(\logits_reg[3] [5]),
        .I2(out_id[1]),
        .I3(\logits_reg[2] [5]),
        .I4(out_id[0]),
        .I5(\logits_reg[1] [5]),
        .O(\out_data[5]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hB8FF3000)) 
    \out_data[6]_i_1 
       (.I0(out_id[1]),
        .I1(out_id[2]),
        .I2(\out_data[6]_i_2_n_0 ),
        .I3(state[1]),
        .I4(\logits_reg[0] [6]),
        .O(\out_data[6]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \out_data[6]_i_2 
       (.I0(\logits_reg[4] [6]),
        .I1(\logits_reg[3] [6]),
        .I2(out_id[1]),
        .I3(\logits_reg[2] [6]),
        .I4(out_id[0]),
        .I5(\logits_reg[1] [6]),
        .O(\out_data[6]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hB8FF3000)) 
    \out_data[7]_i_1 
       (.I0(out_id[1]),
        .I1(out_id[2]),
        .I2(\out_data[7]_i_2_n_0 ),
        .I3(state[1]),
        .I4(\logits_reg[0] [7]),
        .O(\out_data[7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \out_data[7]_i_2 
       (.I0(\logits_reg[4] [7]),
        .I1(\logits_reg[3] [7]),
        .I2(out_id[1]),
        .I3(\logits_reg[2] [7]),
        .I4(out_id[0]),
        .I5(\logits_reg[1] [7]),
        .O(\out_data[7]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hB8FF3000)) 
    \out_data[8]_i_1 
       (.I0(out_id[1]),
        .I1(out_id[2]),
        .I2(\out_data[8]_i_2_n_0 ),
        .I3(state[1]),
        .I4(\logits_reg[0] [8]),
        .O(\out_data[8]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \out_data[8]_i_2 
       (.I0(\logits_reg[4] [8]),
        .I1(\logits_reg[3] [8]),
        .I2(out_id[1]),
        .I3(\logits_reg[2] [8]),
        .I4(out_id[0]),
        .I5(\logits_reg[1] [8]),
        .O(\out_data[8]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hB8FF3000)) 
    \out_data[9]_i_1 
       (.I0(out_id[1]),
        .I1(out_id[2]),
        .I2(\out_data[9]_i_2_n_0 ),
        .I3(state[1]),
        .I4(\logits_reg[0] [9]),
        .O(\out_data[9]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \out_data[9]_i_2 
       (.I0(\logits_reg[4] [9]),
        .I1(\logits_reg[3] [9]),
        .I2(out_id[1]),
        .I3(\logits_reg[2] [9]),
        .I4(out_id[0]),
        .I5(\logits_reg[1] [9]),
        .O(\out_data[9]_i_2_n_0 ));
  FDRE \out_data_reg[0] 
       (.C(clk),
        .CE(\out_id[2]_i_1_n_0 ),
        .D(\out_data[0]_i_1_n_0 ),
        .Q(out_data[0]),
        .R(out_valid_i_1_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \out_data_reg[0]_i_15 
       (.CI(\out_data_reg[0]_i_33_n_0 ),
        .CO({\out_data_reg[0]_i_15_n_0 ,\out_data_reg[0]_i_15_n_1 ,\out_data_reg[0]_i_15_n_2 ,\out_data_reg[0]_i_15_n_3 }),
        .CYINIT(1'b0),
        .DI({\out_data[0]_i_34_n_0 ,\out_data[0]_i_35_n_0 ,\out_data[0]_i_36_n_0 ,\out_data[0]_i_37_n_0 }),
        .O(\NLW_out_data_reg[0]_i_15_O_UNCONNECTED [3:0]),
        .S({\out_data[0]_i_38_n_0 ,\out_data[0]_i_39_n_0 ,\out_data[0]_i_40_n_0 ,\out_data[0]_i_41_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \out_data_reg[0]_i_24 
       (.CI(\out_data_reg[0]_i_42_n_0 ),
        .CO({\out_data_reg[0]_i_24_n_0 ,\out_data_reg[0]_i_24_n_1 ,\out_data_reg[0]_i_24_n_2 ,\out_data_reg[0]_i_24_n_3 }),
        .CYINIT(1'b0),
        .DI({\out_data[0]_i_43_n_0 ,\out_data[0]_i_44_n_0 ,\out_data[0]_i_45_n_0 ,\out_data[0]_i_46_n_0 }),
        .O(\NLW_out_data_reg[0]_i_24_O_UNCONNECTED [3:0]),
        .S({\out_data[0]_i_47_n_0 ,\out_data[0]_i_48_n_0 ,\out_data[0]_i_49_n_0 ,\out_data[0]_i_50_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \out_data_reg[0]_i_33 
       (.CI(\out_data_reg[0]_i_51_n_0 ),
        .CO({\out_data_reg[0]_i_33_n_0 ,\out_data_reg[0]_i_33_n_1 ,\out_data_reg[0]_i_33_n_2 ,\out_data_reg[0]_i_33_n_3 }),
        .CYINIT(1'b0),
        .DI({\out_data[0]_i_52_n_0 ,\out_data[0]_i_53_n_0 ,\out_data[0]_i_54_n_0 ,\out_data[0]_i_55_n_0 }),
        .O(\NLW_out_data_reg[0]_i_33_O_UNCONNECTED [3:0]),
        .S({\out_data[0]_i_56_n_0 ,\out_data[0]_i_57_n_0 ,\out_data[0]_i_58_n_0 ,\out_data[0]_i_59_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \out_data_reg[0]_i_4 
       (.CI(\out_data_reg[0]_i_6_n_0 ),
        .CO({\out_data_reg[0]_i_4_n_0 ,\out_data_reg[0]_i_4_n_1 ,\out_data_reg[0]_i_4_n_2 ,\out_data_reg[0]_i_4_n_3 }),
        .CYINIT(1'b0),
        .DI({\out_data[0]_i_7_n_0 ,\out_data[0]_i_8_n_0 ,\out_data[0]_i_9_n_0 ,\out_data[0]_i_10_n_0 }),
        .O(\NLW_out_data_reg[0]_i_4_O_UNCONNECTED [3:0]),
        .S({\out_data[0]_i_11_n_0 ,\out_data[0]_i_12_n_0 ,\out_data[0]_i_13_n_0 ,\out_data[0]_i_14_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \out_data_reg[0]_i_42 
       (.CI(1'b0),
        .CO({\out_data_reg[0]_i_42_n_0 ,\out_data_reg[0]_i_42_n_1 ,\out_data_reg[0]_i_42_n_2 ,\out_data_reg[0]_i_42_n_3 }),
        .CYINIT(1'b0),
        .DI({\out_data[0]_i_60_n_0 ,\out_data[0]_i_61_n_0 ,\out_data[0]_i_62_n_0 ,\out_data[0]_i_63_n_0 }),
        .O(\NLW_out_data_reg[0]_i_42_O_UNCONNECTED [3:0]),
        .S({\out_data[0]_i_64_n_0 ,\out_data[0]_i_65_n_0 ,\out_data[0]_i_66_n_0 ,\out_data[0]_i_67_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \out_data_reg[0]_i_5 
       (.CI(\out_data_reg[0]_i_15_n_0 ),
        .CO({\out_data_reg[0]_i_5_n_0 ,\out_data_reg[0]_i_5_n_1 ,\out_data_reg[0]_i_5_n_2 ,\out_data_reg[0]_i_5_n_3 }),
        .CYINIT(1'b0),
        .DI({\out_data[0]_i_16_n_0 ,\out_data[0]_i_17_n_0 ,\out_data[0]_i_18_n_0 ,\out_data[0]_i_19_n_0 }),
        .O(\NLW_out_data_reg[0]_i_5_O_UNCONNECTED [3:0]),
        .S({\out_data[0]_i_20_n_0 ,\out_data[0]_i_21_n_0 ,\out_data[0]_i_22_n_0 ,\out_data[0]_i_23_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \out_data_reg[0]_i_51 
       (.CI(1'b0),
        .CO({\out_data_reg[0]_i_51_n_0 ,\out_data_reg[0]_i_51_n_1 ,\out_data_reg[0]_i_51_n_2 ,\out_data_reg[0]_i_51_n_3 }),
        .CYINIT(1'b0),
        .DI({\out_data[0]_i_68_n_0 ,\out_data[0]_i_69_n_0 ,\out_data[0]_i_70_n_0 ,\out_data[0]_i_71_n_0 }),
        .O(\NLW_out_data_reg[0]_i_51_O_UNCONNECTED [3:0]),
        .S({\out_data[0]_i_72_n_0 ,\out_data[0]_i_73_n_0 ,\out_data[0]_i_74_n_0 ,\out_data[0]_i_75_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \out_data_reg[0]_i_6 
       (.CI(\out_data_reg[0]_i_24_n_0 ),
        .CO({\out_data_reg[0]_i_6_n_0 ,\out_data_reg[0]_i_6_n_1 ,\out_data_reg[0]_i_6_n_2 ,\out_data_reg[0]_i_6_n_3 }),
        .CYINIT(1'b0),
        .DI({\out_data[0]_i_25_n_0 ,\out_data[0]_i_26_n_0 ,\out_data[0]_i_27_n_0 ,\out_data[0]_i_28_n_0 }),
        .O(\NLW_out_data_reg[0]_i_6_O_UNCONNECTED [3:0]),
        .S({\out_data[0]_i_29_n_0 ,\out_data[0]_i_30_n_0 ,\out_data[0]_i_31_n_0 ,\out_data[0]_i_32_n_0 }));
  FDRE \out_data_reg[10] 
       (.C(clk),
        .CE(\out_id[2]_i_1_n_0 ),
        .D(\out_data[10]_i_1_n_0 ),
        .Q(out_data[10]),
        .R(out_valid_i_1_n_0));
  FDRE \out_data_reg[11] 
       (.C(clk),
        .CE(\out_id[2]_i_1_n_0 ),
        .D(\out_data[11]_i_1_n_0 ),
        .Q(out_data[11]),
        .R(out_valid_i_1_n_0));
  FDRE \out_data_reg[12] 
       (.C(clk),
        .CE(\out_id[2]_i_1_n_0 ),
        .D(\out_data[12]_i_1_n_0 ),
        .Q(out_data[12]),
        .R(out_valid_i_1_n_0));
  FDRE \out_data_reg[13] 
       (.C(clk),
        .CE(\out_id[2]_i_1_n_0 ),
        .D(\out_data[13]_i_1_n_0 ),
        .Q(out_data[13]),
        .R(out_valid_i_1_n_0));
  FDRE \out_data_reg[14] 
       (.C(clk),
        .CE(\out_id[2]_i_1_n_0 ),
        .D(\out_data[14]_i_1_n_0 ),
        .Q(out_data[14]),
        .R(out_valid_i_1_n_0));
  FDRE \out_data_reg[15] 
       (.C(clk),
        .CE(\out_id[2]_i_1_n_0 ),
        .D(\out_data[15]_i_1_n_0 ),
        .Q(out_data[15]),
        .R(out_valid_i_1_n_0));
  FDRE \out_data_reg[16] 
       (.C(clk),
        .CE(\out_id[2]_i_1_n_0 ),
        .D(\out_data[16]_i_1_n_0 ),
        .Q(out_data[16]),
        .R(out_valid_i_1_n_0));
  FDRE \out_data_reg[17] 
       (.C(clk),
        .CE(\out_id[2]_i_1_n_0 ),
        .D(\out_data[17]_i_1_n_0 ),
        .Q(out_data[17]),
        .R(out_valid_i_1_n_0));
  FDRE \out_data_reg[18] 
       (.C(clk),
        .CE(\out_id[2]_i_1_n_0 ),
        .D(\out_data[18]_i_1_n_0 ),
        .Q(out_data[18]),
        .R(out_valid_i_1_n_0));
  FDRE \out_data_reg[19] 
       (.C(clk),
        .CE(\out_id[2]_i_1_n_0 ),
        .D(\out_data[19]_i_1_n_0 ),
        .Q(out_data[19]),
        .R(out_valid_i_1_n_0));
  FDRE \out_data_reg[1] 
       (.C(clk),
        .CE(\out_id[2]_i_1_n_0 ),
        .D(\out_data[1]_i_1_n_0 ),
        .Q(out_data[1]),
        .R(out_valid_i_1_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \out_data_reg[1]_i_15 
       (.CI(\out_data_reg[1]_i_33_n_0 ),
        .CO({\out_data_reg[1]_i_15_n_0 ,\out_data_reg[1]_i_15_n_1 ,\out_data_reg[1]_i_15_n_2 ,\out_data_reg[1]_i_15_n_3 }),
        .CYINIT(1'b0),
        .DI({\out_data[1]_i_34_n_0 ,\out_data[1]_i_35_n_0 ,\out_data[1]_i_36_n_0 ,\out_data[1]_i_37_n_0 }),
        .O(\NLW_out_data_reg[1]_i_15_O_UNCONNECTED [3:0]),
        .S({\out_data[1]_i_38_n_0 ,\out_data[1]_i_39_n_0 ,\out_data[1]_i_40_n_0 ,\out_data[1]_i_41_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \out_data_reg[1]_i_24 
       (.CI(\out_data_reg[1]_i_42_n_0 ),
        .CO({\out_data_reg[1]_i_24_n_0 ,\out_data_reg[1]_i_24_n_1 ,\out_data_reg[1]_i_24_n_2 ,\out_data_reg[1]_i_24_n_3 }),
        .CYINIT(1'b0),
        .DI({\out_data[1]_i_43_n_0 ,\out_data[1]_i_44_n_0 ,\out_data[1]_i_45_n_0 ,\out_data[1]_i_46_n_0 }),
        .O(\NLW_out_data_reg[1]_i_24_O_UNCONNECTED [3:0]),
        .S({\out_data[1]_i_47_n_0 ,\out_data[1]_i_48_n_0 ,\out_data[1]_i_49_n_0 ,\out_data[1]_i_50_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \out_data_reg[1]_i_33 
       (.CI(\out_data_reg[1]_i_51_n_0 ),
        .CO({\out_data_reg[1]_i_33_n_0 ,\out_data_reg[1]_i_33_n_1 ,\out_data_reg[1]_i_33_n_2 ,\out_data_reg[1]_i_33_n_3 }),
        .CYINIT(1'b0),
        .DI({\out_data[1]_i_52_n_0 ,\out_data[1]_i_53_n_0 ,\out_data[1]_i_54_n_0 ,\out_data[1]_i_55_n_0 }),
        .O(\NLW_out_data_reg[1]_i_33_O_UNCONNECTED [3:0]),
        .S({\out_data[1]_i_56_n_0 ,\out_data[1]_i_57_n_0 ,\out_data[1]_i_58_n_0 ,\out_data[1]_i_59_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \out_data_reg[1]_i_4 
       (.CI(\out_data_reg[1]_i_6_n_0 ),
        .CO({\out_data_reg[1]_i_4_n_0 ,\out_data_reg[1]_i_4_n_1 ,\out_data_reg[1]_i_4_n_2 ,\out_data_reg[1]_i_4_n_3 }),
        .CYINIT(1'b0),
        .DI({\out_data[1]_i_7_n_0 ,\out_data[1]_i_8_n_0 ,\out_data[1]_i_9_n_0 ,\out_data[1]_i_10_n_0 }),
        .O(\NLW_out_data_reg[1]_i_4_O_UNCONNECTED [3:0]),
        .S({\out_data[1]_i_11_n_0 ,\out_data[1]_i_12_n_0 ,\out_data[1]_i_13_n_0 ,\out_data[1]_i_14_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \out_data_reg[1]_i_42 
       (.CI(1'b0),
        .CO({\out_data_reg[1]_i_42_n_0 ,\out_data_reg[1]_i_42_n_1 ,\out_data_reg[1]_i_42_n_2 ,\out_data_reg[1]_i_42_n_3 }),
        .CYINIT(1'b0),
        .DI({\out_data[1]_i_60_n_0 ,\out_data[1]_i_61_n_0 ,\out_data[1]_i_62_n_0 ,\out_data[1]_i_63_n_0 }),
        .O(\NLW_out_data_reg[1]_i_42_O_UNCONNECTED [3:0]),
        .S({\out_data[1]_i_64_n_0 ,\out_data[1]_i_65_n_0 ,\out_data[1]_i_66_n_0 ,\out_data[1]_i_67_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \out_data_reg[1]_i_5 
       (.CI(\out_data_reg[1]_i_15_n_0 ),
        .CO({\out_data_reg[1]_i_5_n_0 ,\out_data_reg[1]_i_5_n_1 ,\out_data_reg[1]_i_5_n_2 ,\out_data_reg[1]_i_5_n_3 }),
        .CYINIT(1'b0),
        .DI({\out_data[1]_i_16_n_0 ,\out_data[1]_i_17_n_0 ,\out_data[1]_i_18_n_0 ,\out_data[1]_i_19_n_0 }),
        .O(\NLW_out_data_reg[1]_i_5_O_UNCONNECTED [3:0]),
        .S({\out_data[1]_i_20_n_0 ,\out_data[1]_i_21_n_0 ,\out_data[1]_i_22_n_0 ,\out_data[1]_i_23_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \out_data_reg[1]_i_51 
       (.CI(1'b0),
        .CO({\out_data_reg[1]_i_51_n_0 ,\out_data_reg[1]_i_51_n_1 ,\out_data_reg[1]_i_51_n_2 ,\out_data_reg[1]_i_51_n_3 }),
        .CYINIT(1'b0),
        .DI({\out_data[1]_i_68_n_0 ,\out_data[1]_i_69_n_0 ,\out_data[1]_i_70_n_0 ,\out_data[1]_i_71_n_0 }),
        .O(\NLW_out_data_reg[1]_i_51_O_UNCONNECTED [3:0]),
        .S({\out_data[1]_i_72_n_0 ,\out_data[1]_i_73_n_0 ,\out_data[1]_i_74_n_0 ,\out_data[1]_i_75_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \out_data_reg[1]_i_6 
       (.CI(\out_data_reg[1]_i_24_n_0 ),
        .CO({\out_data_reg[1]_i_6_n_0 ,\out_data_reg[1]_i_6_n_1 ,\out_data_reg[1]_i_6_n_2 ,\out_data_reg[1]_i_6_n_3 }),
        .CYINIT(1'b0),
        .DI({\out_data[1]_i_25_n_0 ,\out_data[1]_i_26_n_0 ,\out_data[1]_i_27_n_0 ,\out_data[1]_i_28_n_0 }),
        .O(\NLW_out_data_reg[1]_i_6_O_UNCONNECTED [3:0]),
        .S({\out_data[1]_i_29_n_0 ,\out_data[1]_i_30_n_0 ,\out_data[1]_i_31_n_0 ,\out_data[1]_i_32_n_0 }));
  FDRE \out_data_reg[20] 
       (.C(clk),
        .CE(\out_id[2]_i_1_n_0 ),
        .D(\out_data[20]_i_1_n_0 ),
        .Q(out_data[20]),
        .R(out_valid_i_1_n_0));
  FDRE \out_data_reg[21] 
       (.C(clk),
        .CE(\out_id[2]_i_1_n_0 ),
        .D(\out_data[21]_i_1_n_0 ),
        .Q(out_data[21]),
        .R(out_valid_i_1_n_0));
  FDRE \out_data_reg[22] 
       (.C(clk),
        .CE(\out_id[2]_i_1_n_0 ),
        .D(\out_data[22]_i_1_n_0 ),
        .Q(out_data[22]),
        .R(out_valid_i_1_n_0));
  FDRE \out_data_reg[23] 
       (.C(clk),
        .CE(\out_id[2]_i_1_n_0 ),
        .D(\out_data[23]_i_1_n_0 ),
        .Q(out_data[23]),
        .R(out_valid_i_1_n_0));
  FDRE \out_data_reg[24] 
       (.C(clk),
        .CE(\out_id[2]_i_1_n_0 ),
        .D(\out_data[24]_i_1_n_0 ),
        .Q(out_data[24]),
        .R(out_valid_i_1_n_0));
  FDRE \out_data_reg[25] 
       (.C(clk),
        .CE(\out_id[2]_i_1_n_0 ),
        .D(\out_data[25]_i_1_n_0 ),
        .Q(out_data[25]),
        .R(out_valid_i_1_n_0));
  FDRE \out_data_reg[26] 
       (.C(clk),
        .CE(\out_id[2]_i_1_n_0 ),
        .D(\out_data[26]_i_1_n_0 ),
        .Q(out_data[26]),
        .R(out_valid_i_1_n_0));
  FDRE \out_data_reg[27] 
       (.C(clk),
        .CE(\out_id[2]_i_1_n_0 ),
        .D(\out_data[27]_i_1_n_0 ),
        .Q(out_data[27]),
        .R(out_valid_i_1_n_0));
  FDRE \out_data_reg[28] 
       (.C(clk),
        .CE(\out_id[2]_i_1_n_0 ),
        .D(\out_data[28]_i_1_n_0 ),
        .Q(out_data[28]),
        .R(out_valid_i_1_n_0));
  FDRE \out_data_reg[29] 
       (.C(clk),
        .CE(\out_id[2]_i_1_n_0 ),
        .D(\out_data[29]_i_1_n_0 ),
        .Q(out_data[29]),
        .R(out_valid_i_1_n_0));
  FDRE \out_data_reg[2] 
       (.C(clk),
        .CE(\out_id[2]_i_1_n_0 ),
        .D(\out_data[2]_i_1_n_0 ),
        .Q(out_data[2]),
        .R(out_valid_i_1_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \out_data_reg[2]_i_13 
       (.CI(\out_data_reg[2]_i_30_n_0 ),
        .CO({\out_data_reg[2]_i_13_n_0 ,\out_data_reg[2]_i_13_n_1 ,\out_data_reg[2]_i_13_n_2 ,\out_data_reg[2]_i_13_n_3 }),
        .CYINIT(1'b0),
        .DI({\out_data[2]_i_31_n_0 ,\out_data[2]_i_32_n_0 ,\out_data[2]_i_33_n_0 ,\out_data[2]_i_34_n_0 }),
        .O(\NLW_out_data_reg[2]_i_13_O_UNCONNECTED [3:0]),
        .S({\out_data[2]_i_35_n_0 ,\out_data[2]_i_36_n_0 ,\out_data[2]_i_37_n_0 ,\out_data[2]_i_38_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \out_data_reg[2]_i_2 
       (.CI(\out_data_reg[2]_i_4_n_0 ),
        .CO({\out_data_reg[2]_i_2_n_0 ,\out_data_reg[2]_i_2_n_1 ,\out_data_reg[2]_i_2_n_2 ,\out_data_reg[2]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({\out_data[2]_i_5_n_0 ,\out_data[2]_i_6_n_0 ,\out_data[2]_i_7_n_0 ,\out_data[2]_i_8_n_0 }),
        .O(\NLW_out_data_reg[2]_i_2_O_UNCONNECTED [3:0]),
        .S({\out_data[2]_i_9_n_0 ,\out_data[2]_i_10_n_0 ,\out_data[2]_i_11_n_0 ,\out_data[2]_i_12_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \out_data_reg[2]_i_30 
       (.CI(1'b0),
        .CO({\out_data_reg[2]_i_30_n_0 ,\out_data_reg[2]_i_30_n_1 ,\out_data_reg[2]_i_30_n_2 ,\out_data_reg[2]_i_30_n_3 }),
        .CYINIT(1'b0),
        .DI({\out_data[2]_i_55_n_0 ,\out_data[2]_i_56_n_0 ,\out_data[2]_i_57_n_0 ,\out_data[2]_i_58_n_0 }),
        .O(\NLW_out_data_reg[2]_i_30_O_UNCONNECTED [3:0]),
        .S({\out_data[2]_i_59_n_0 ,\out_data[2]_i_60_n_0 ,\out_data[2]_i_61_n_0 ,\out_data[2]_i_62_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \out_data_reg[2]_i_4 
       (.CI(\out_data_reg[2]_i_13_n_0 ),
        .CO({\out_data_reg[2]_i_4_n_0 ,\out_data_reg[2]_i_4_n_1 ,\out_data_reg[2]_i_4_n_2 ,\out_data_reg[2]_i_4_n_3 }),
        .CYINIT(1'b0),
        .DI({\out_data[2]_i_14_n_0 ,\out_data[2]_i_15_n_0 ,\out_data[2]_i_16_n_0 ,\out_data[2]_i_17_n_0 }),
        .O(\NLW_out_data_reg[2]_i_4_O_UNCONNECTED [3:0]),
        .S({\out_data[2]_i_18_n_0 ,\out_data[2]_i_19_n_0 ,\out_data[2]_i_20_n_0 ,\out_data[2]_i_21_n_0 }));
  FDRE \out_data_reg[30] 
       (.C(clk),
        .CE(\out_id[2]_i_1_n_0 ),
        .D(\out_data[30]_i_1_n_0 ),
        .Q(out_data[30]),
        .R(out_valid_i_1_n_0));
  FDRE \out_data_reg[31] 
       (.C(clk),
        .CE(\out_id[2]_i_1_n_0 ),
        .D(\out_data[31]_i_1_n_0 ),
        .Q(out_data[31]),
        .R(out_valid_i_1_n_0));
  FDRE \out_data_reg[3] 
       (.C(clk),
        .CE(\out_id[2]_i_1_n_0 ),
        .D(\out_data[3]_i_1_n_0 ),
        .Q(out_data[3]),
        .R(out_valid_i_1_n_0));
  FDRE \out_data_reg[4] 
       (.C(clk),
        .CE(\out_id[2]_i_1_n_0 ),
        .D(\out_data[4]_i_1_n_0 ),
        .Q(out_data[4]),
        .R(out_valid_i_1_n_0));
  FDRE \out_data_reg[5] 
       (.C(clk),
        .CE(\out_id[2]_i_1_n_0 ),
        .D(\out_data[5]_i_1_n_0 ),
        .Q(out_data[5]),
        .R(out_valid_i_1_n_0));
  FDRE \out_data_reg[6] 
       (.C(clk),
        .CE(\out_id[2]_i_1_n_0 ),
        .D(\out_data[6]_i_1_n_0 ),
        .Q(out_data[6]),
        .R(out_valid_i_1_n_0));
  FDRE \out_data_reg[7] 
       (.C(clk),
        .CE(\out_id[2]_i_1_n_0 ),
        .D(\out_data[7]_i_1_n_0 ),
        .Q(out_data[7]),
        .R(out_valid_i_1_n_0));
  FDRE \out_data_reg[8] 
       (.C(clk),
        .CE(\out_id[2]_i_1_n_0 ),
        .D(\out_data[8]_i_1_n_0 ),
        .Q(out_data[8]),
        .R(out_valid_i_1_n_0));
  FDRE \out_data_reg[9] 
       (.C(clk),
        .CE(\out_id[2]_i_1_n_0 ),
        .D(\out_data[9]_i_1_n_0 ),
        .Q(out_data[9]),
        .R(out_valid_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT4 #(
    .INIT(16'h0010)) 
    \out_id[0]_i_1 
       (.I0(state[2]),
        .I1(state[3]),
        .I2(state[1]),
        .I3(out_id[0]),
        .O(\out_id[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT5 #(
    .INIT(32'h00101000)) 
    \out_id[1]_i_1 
       (.I0(state[2]),
        .I1(state[3]),
        .I2(state[1]),
        .I3(out_id[0]),
        .I4(out_id[1]),
        .O(\out_id[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000222200200000)) 
    \out_id[2]_i_1 
       (.I0(state[4]),
        .I1(\out_id[2]_i_3_n_0 ),
        .I2(out_ready),
        .I3(\out_id[2]_i_4_n_0 ),
        .I4(state[1]),
        .I5(state[0]),
        .O(\out_id[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0010101010000000)) 
    \out_id[2]_i_2 
       (.I0(state[2]),
        .I1(state[3]),
        .I2(state[1]),
        .I3(out_id[0]),
        .I4(out_id[1]),
        .I5(out_id[2]),
        .O(\out_id[2]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \out_id[2]_i_3 
       (.I0(state[2]),
        .I1(state[3]),
        .O(\out_id[2]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'h08)) 
    \out_id[2]_i_4 
       (.I0(out_id[2]),
        .I1(out_id[0]),
        .I2(out_id[1]),
        .O(\out_id[2]_i_4_n_0 ));
  FDRE \out_id_reg[0] 
       (.C(clk),
        .CE(\out_id[2]_i_1_n_0 ),
        .D(\out_id[0]_i_1_n_0 ),
        .Q(out_id[0]),
        .R(out_valid_i_1_n_0));
  FDRE \out_id_reg[1] 
       (.C(clk),
        .CE(\out_id[2]_i_1_n_0 ),
        .D(\out_id[1]_i_1_n_0 ),
        .Q(out_id[1]),
        .R(out_valid_i_1_n_0));
  FDRE \out_id_reg[2] 
       (.C(clk),
        .CE(\out_id[2]_i_1_n_0 ),
        .D(\out_id[2]_i_2_n_0 ),
        .Q(out_id[2]),
        .R(out_valid_i_1_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    out_valid_i_1
       (.I0(rst_n),
        .O(out_valid_i_1_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFF700000004)) 
    out_valid_i_2
       (.I0(state[1]),
        .I1(state[4]),
        .I2(state[2]),
        .I3(state[3]),
        .I4(out_valid_i_3_n_0),
        .I5(out_valid),
        .O(out_valid_i_2_n_0));
  LUT6 #(
    .INIT(64'hDDDD9DDDDDDDDDDD)) 
    out_valid_i_3
       (.I0(state[0]),
        .I1(state[1]),
        .I2(out_id[2]),
        .I3(out_id[0]),
        .I4(out_id[1]),
        .I5(out_ready),
        .O(out_valid_i_3_n_0));
  FDRE out_valid_reg
       (.C(clk),
        .CE(1'b1),
        .D(out_valid_i_2_n_0),
        .Q(out_valid),
        .R(out_valid_i_1_n_0));
  LUT5 #(
    .INIT(32'h00400000)) 
    \rq_n[5]_i_1 
       (.I0(state[3]),
        .I1(state[1]),
        .I2(state[0]),
        .I3(state[4]),
        .I4(state[2]),
        .O(rq_n));
  FDRE \rq_n_reg[0] 
       (.C(clk),
        .CE(rq_n),
        .D(bram_addr_reg_rep_0_n_35),
        .Q(\rq_n_reg_n_0_[0] ),
        .R(out_valid_i_1_n_0));
  FDRE \rq_n_reg[1] 
       (.C(clk),
        .CE(rq_n),
        .D(bram_addr_reg_rep_0_n_34),
        .Q(\rq_n_reg_n_0_[1] ),
        .R(out_valid_i_1_n_0));
  FDRE \rq_n_reg[2] 
       (.C(clk),
        .CE(rq_n),
        .D(bram_addr_reg_rep_0_n_33),
        .Q(\rq_n_reg_n_0_[2] ),
        .R(out_valid_i_1_n_0));
  FDRE \rq_n_reg[3] 
       (.C(clk),
        .CE(rq_n),
        .D(bram_addr_reg_rep_0_n_32),
        .Q(\rq_n_reg_n_0_[3] ),
        .R(out_valid_i_1_n_0));
  FDRE \rq_n_reg[4] 
       (.C(clk),
        .CE(rq_n),
        .D(bram_addr_reg_rep_0_n_31),
        .Q(\rq_n_reg_n_0_[4] ),
        .R(out_valid_i_1_n_0));
  FDRE \rq_n_reg[5] 
       (.C(clk),
        .CE(rq_n),
        .D(bram_addr_reg_rep_0_n_30),
        .Q(\rq_n_reg_n_0_[5] ),
        .R(out_valid_i_1_n_0));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-11 {cell *THIS*}}" *) 
  DSP48E1 #(
    .ACASCREG(1),
    .ADREG(1),
    .ALUMODEREG(0),
    .AREG(1),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(1),
    .BREG(1),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(1),
    .DREG(1),
    .INMODEREG(0),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREG(0),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_DPORT("FALSE"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48")) 
    rq_prod0
       (.A({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,\acc[16]_i_1_n_0 ,\acc[15]_i_1_n_0 ,\acc[14]_i_1_n_0 ,\acc[13]_i_1_n_0 ,\acc[12]_i_1_n_0 ,\acc[11]_i_1_n_0 ,\acc[10]_i_1_n_0 ,\acc[9]_i_1_n_0 ,\acc[8]_i_1_n_0 ,\acc[7]_i_1_n_0 ,\acc[6]_i_1_n_0 ,\acc[5]_i_1_n_0 ,\acc[4]_i_1_n_0 ,\acc[3]_i_1_n_0 ,\acc[2]_i_1_n_0 ,\acc[1]_i_1_n_0 ,\acc[0]_i_1_n_0 }),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT(NLW_rq_prod0_ACOUT_UNCONNECTED[29:0]),
        .ALUMODE({1'b0,1'b0,1'b0,1'b0}),
        .B({bram_addr_reg_rep_1_n_34,bram_addr_reg_rep_1_n_35,bram_addr_reg_rep_0_n_20,bram_addr_reg_rep_0_n_21,bram_addr_reg_rep_0_n_22,bram_addr_reg_rep_0_n_23,bram_addr_reg_rep_0_n_24,bram_addr_reg_rep_0_n_25,bram_addr_reg_rep_0_n_26,bram_addr_reg_rep_0_n_27,bram_addr_reg_rep_0_n_28,bram_addr_reg_rep_0_n_29,bram_addr_reg_rep_0_n_30,bram_addr_reg_rep_0_n_31,bram_addr_reg_rep_0_n_32,bram_addr_reg_rep_0_n_33,bram_addr_reg_rep_0_n_34,bram_addr_reg_rep_0_n_35}),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(NLW_rq_prod0_BCOUT_UNCONNECTED[17:0]),
        .C({1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(NLW_rq_prod0_CARRYCASCOUT_UNCONNECTED),
        .CARRYIN(1'b0),
        .CARRYINSEL({1'b0,1'b0,1'b0}),
        .CARRYOUT(NLW_rq_prod0_CARRYOUT_UNCONNECTED[3:0]),
        .CEA1(1'b0),
        .CEA2(g0_b0_n_0),
        .CEAD(1'b0),
        .CEALUMODE(1'b0),
        .CEB1(1'b0),
        .CEB2(rq_m),
        .CEC(1'b0),
        .CECARRYIN(1'b0),
        .CECTRL(1'b0),
        .CED(1'b0),
        .CEINMODE(1'b0),
        .CEM(1'b0),
        .CEP(1'b0),
        .CLK(clk),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .INMODE({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .MULTSIGNIN(1'b0),
        .MULTSIGNOUT(NLW_rq_prod0_MULTSIGNOUT_UNCONNECTED),
        .OPMODE({1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,1'b1}),
        .OVERFLOW(NLW_rq_prod0_OVERFLOW_UNCONNECTED),
        .P({rq_prod0_n_58,rq_prod0_n_59,rq_prod0_n_60,rq_prod0_n_61,rq_prod0_n_62,rq_prod0_n_63,rq_prod0_n_64,rq_prod0_n_65,rq_prod0_n_66,rq_prod0_n_67,rq_prod0_n_68,rq_prod0_n_69,rq_prod0_n_70,rq_prod0_n_71,rq_prod0_n_72,rq_prod0_n_73,rq_prod0_n_74,rq_prod0_n_75,rq_prod0_n_76,rq_prod0_n_77,rq_prod0_n_78,rq_prod0_n_79,rq_prod0_n_80,rq_prod0_n_81,rq_prod0_n_82,rq_prod0_n_83,rq_prod0_n_84,rq_prod0_n_85,rq_prod0_n_86,rq_prod0_n_87,rq_prod0_n_88,rq_prod0_n_89,rq_prod0_n_90,rq_prod0_n_91,rq_prod0_n_92,rq_prod0_n_93,rq_prod0_n_94,rq_prod0_n_95,rq_prod0_n_96,rq_prod0_n_97,rq_prod0_n_98,rq_prod0_n_99,rq_prod0_n_100,rq_prod0_n_101,rq_prod0_n_102,rq_prod0_n_103,rq_prod0_n_104,rq_prod0_n_105}),
        .PATTERNBDETECT(NLW_rq_prod0_PATTERNBDETECT_UNCONNECTED),
        .PATTERNDETECT(NLW_rq_prod0_PATTERNDETECT_UNCONNECTED),
        .PCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .PCOUT({rq_prod0_n_106,rq_prod0_n_107,rq_prod0_n_108,rq_prod0_n_109,rq_prod0_n_110,rq_prod0_n_111,rq_prod0_n_112,rq_prod0_n_113,rq_prod0_n_114,rq_prod0_n_115,rq_prod0_n_116,rq_prod0_n_117,rq_prod0_n_118,rq_prod0_n_119,rq_prod0_n_120,rq_prod0_n_121,rq_prod0_n_122,rq_prod0_n_123,rq_prod0_n_124,rq_prod0_n_125,rq_prod0_n_126,rq_prod0_n_127,rq_prod0_n_128,rq_prod0_n_129,rq_prod0_n_130,rq_prod0_n_131,rq_prod0_n_132,rq_prod0_n_133,rq_prod0_n_134,rq_prod0_n_135,rq_prod0_n_136,rq_prod0_n_137,rq_prod0_n_138,rq_prod0_n_139,rq_prod0_n_140,rq_prod0_n_141,rq_prod0_n_142,rq_prod0_n_143,rq_prod0_n_144,rq_prod0_n_145,rq_prod0_n_146,rq_prod0_n_147,rq_prod0_n_148,rq_prod0_n_149,rq_prod0_n_150,rq_prod0_n_151,rq_prod0_n_152,rq_prod0_n_153}),
        .RSTA(out_valid_i_1_n_0),
        .RSTALLCARRYIN(1'b0),
        .RSTALUMODE(1'b0),
        .RSTB(out_valid_i_1_n_0),
        .RSTC(1'b0),
        .RSTCTRL(1'b0),
        .RSTD(1'b0),
        .RSTINMODE(1'b0),
        .RSTM(1'b0),
        .RSTP(1'b0),
        .UNDERFLOW(NLW_rq_prod0_UNDERFLOW_UNCONNECTED));
  LUT5 #(
    .INIT(32'h00000020)) 
    rq_prod0_i_1
       (.I0(state[1]),
        .I1(state[0]),
        .I2(state[2]),
        .I3(state[3]),
        .I4(state[4]),
        .O(rq_m));
  LUT6 #(
    .INIT(64'h0000100000000000)) 
    \rq_prod[16]_i_1 
       (.I0(state[1]),
        .I1(state[4]),
        .I2(state[3]),
        .I3(state[0]),
        .I4(\FSM_sequential_state[3]_i_2_n_0 ),
        .I5(state[2]),
        .O(rq_prod));
  DSP48E1 #(
    .ACASCREG(1),
    .ADREG(1),
    .ALUMODEREG(0),
    .AREG(1),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(1),
    .BREG(1),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(1),
    .DREG(1),
    .INMODEREG(0),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREG(1),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_DPORT("FALSE"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48")) 
    rq_prod_reg
       (.A({bram_addr_reg_rep_1_n_34,bram_addr_reg_rep_1_n_34,bram_addr_reg_rep_1_n_34,bram_addr_reg_rep_1_n_34,bram_addr_reg_rep_1_n_34,bram_addr_reg_rep_1_n_34,bram_addr_reg_rep_1_n_34,bram_addr_reg_rep_1_n_34,bram_addr_reg_rep_1_n_34,bram_addr_reg_rep_1_n_34,bram_addr_reg_rep_1_n_34,bram_addr_reg_rep_1_n_34,bram_addr_reg_rep_1_n_34,bram_addr_reg_rep_1_n_35,bram_addr_reg_rep_0_n_20,bram_addr_reg_rep_0_n_21,bram_addr_reg_rep_0_n_22,bram_addr_reg_rep_0_n_23,bram_addr_reg_rep_0_n_24,bram_addr_reg_rep_0_n_25,bram_addr_reg_rep_0_n_26,bram_addr_reg_rep_0_n_27,bram_addr_reg_rep_0_n_28,bram_addr_reg_rep_0_n_29,bram_addr_reg_rep_0_n_30,bram_addr_reg_rep_0_n_31,bram_addr_reg_rep_0_n_32,bram_addr_reg_rep_0_n_33,bram_addr_reg_rep_0_n_34,bram_addr_reg_rep_0_n_35}),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT(NLW_rq_prod_reg_ACOUT_UNCONNECTED[29:0]),
        .ALUMODE({1'b0,1'b0,1'b0,1'b0}),
        .B({\acc[31]_i_1_n_0 ,\acc[31]_i_1_n_0 ,\acc[31]_i_1_n_0 ,\acc[31]_i_1_n_0 ,\acc[30]_i_1_n_0 ,\acc[29]_i_1_n_0 ,\acc[28]_i_1_n_0 ,\acc[27]_i_1_n_0 ,\acc[26]_i_1_n_0 ,\acc[25]_i_1_n_0 ,\acc[24]_i_1_n_0 ,\acc[23]_i_1_n_0 ,\acc[22]_i_1_n_0 ,\acc[21]_i_1_n_0 ,\acc[20]_i_1_n_0 ,\acc[19]_i_1_n_0 ,\acc[18]_i_1_n_0 ,\acc[17]_i_1_n_0 }),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(NLW_rq_prod_reg_BCOUT_UNCONNECTED[17:0]),
        .C({1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(NLW_rq_prod_reg_CARRYCASCOUT_UNCONNECTED),
        .CARRYIN(1'b0),
        .CARRYINSEL({1'b0,1'b0,1'b0}),
        .CARRYOUT(NLW_rq_prod_reg_CARRYOUT_UNCONNECTED[3:0]),
        .CEA1(1'b0),
        .CEA2(rq_m),
        .CEAD(1'b0),
        .CEALUMODE(1'b0),
        .CEB1(1'b0),
        .CEB2(g0_b0_n_0),
        .CEC(1'b0),
        .CECARRYIN(1'b0),
        .CECTRL(1'b0),
        .CED(1'b0),
        .CEINMODE(1'b0),
        .CEM(1'b0),
        .CEP(rq_prod),
        .CLK(clk),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .INMODE({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .MULTSIGNIN(1'b0),
        .MULTSIGNOUT(NLW_rq_prod_reg_MULTSIGNOUT_UNCONNECTED),
        .OPMODE({1'b1,1'b0,1'b1,1'b0,1'b1,1'b0,1'b1}),
        .OVERFLOW(NLW_rq_prod_reg_OVERFLOW_UNCONNECTED),
        .P({rq_prod_reg_n_58,rq_prod_reg_n_59,rq_prod_reg_n_60,rq_prod_reg_n_61,rq_prod_reg_n_62,rq_prod_reg_n_63,rq_prod_reg_n_64,rq_prod_reg_n_65,rq_prod_reg_n_66,rq_prod_reg_n_67,rq_prod_reg_n_68,rq_prod_reg_n_69,rq_prod_reg_n_70,rq_prod_reg_n_71,rq_prod_reg_n_72,rq_prod_reg__0[49:17]}),
        .PATTERNBDETECT(NLW_rq_prod_reg_PATTERNBDETECT_UNCONNECTED),
        .PATTERNDETECT(NLW_rq_prod_reg_PATTERNDETECT_UNCONNECTED),
        .PCIN({rq_prod0_n_106,rq_prod0_n_107,rq_prod0_n_108,rq_prod0_n_109,rq_prod0_n_110,rq_prod0_n_111,rq_prod0_n_112,rq_prod0_n_113,rq_prod0_n_114,rq_prod0_n_115,rq_prod0_n_116,rq_prod0_n_117,rq_prod0_n_118,rq_prod0_n_119,rq_prod0_n_120,rq_prod0_n_121,rq_prod0_n_122,rq_prod0_n_123,rq_prod0_n_124,rq_prod0_n_125,rq_prod0_n_126,rq_prod0_n_127,rq_prod0_n_128,rq_prod0_n_129,rq_prod0_n_130,rq_prod0_n_131,rq_prod0_n_132,rq_prod0_n_133,rq_prod0_n_134,rq_prod0_n_135,rq_prod0_n_136,rq_prod0_n_137,rq_prod0_n_138,rq_prod0_n_139,rq_prod0_n_140,rq_prod0_n_141,rq_prod0_n_142,rq_prod0_n_143,rq_prod0_n_144,rq_prod0_n_145,rq_prod0_n_146,rq_prod0_n_147,rq_prod0_n_148,rq_prod0_n_149,rq_prod0_n_150,rq_prod0_n_151,rq_prod0_n_152,rq_prod0_n_153}),
        .PCOUT(NLW_rq_prod_reg_PCOUT_UNCONNECTED[47:0]),
        .RSTA(out_valid_i_1_n_0),
        .RSTALLCARRYIN(1'b0),
        .RSTALUMODE(1'b0),
        .RSTB(out_valid_i_1_n_0),
        .RSTC(1'b0),
        .RSTCTRL(1'b0),
        .RSTD(1'b0),
        .RSTINMODE(1'b0),
        .RSTM(1'b0),
        .RSTP(out_valid_i_1_n_0),
        .UNDERFLOW(NLW_rq_prod_reg_UNDERFLOW_UNCONNECTED));
  FDRE \rq_prod_reg[0] 
       (.C(clk),
        .CE(rq_prod),
        .D(rq_prod0_n_105),
        .Q(rq_prod_reg__0[0]),
        .R(out_valid_i_1_n_0));
  FDRE \rq_prod_reg[10] 
       (.C(clk),
        .CE(rq_prod),
        .D(rq_prod0_n_95),
        .Q(rq_prod_reg__0[10]),
        .R(out_valid_i_1_n_0));
  FDRE \rq_prod_reg[11] 
       (.C(clk),
        .CE(rq_prod),
        .D(rq_prod0_n_94),
        .Q(rq_prod_reg__0[11]),
        .R(out_valid_i_1_n_0));
  FDRE \rq_prod_reg[12] 
       (.C(clk),
        .CE(rq_prod),
        .D(rq_prod0_n_93),
        .Q(rq_prod_reg__0[12]),
        .R(out_valid_i_1_n_0));
  FDRE \rq_prod_reg[13] 
       (.C(clk),
        .CE(rq_prod),
        .D(rq_prod0_n_92),
        .Q(rq_prod_reg__0[13]),
        .R(out_valid_i_1_n_0));
  FDRE \rq_prod_reg[14] 
       (.C(clk),
        .CE(rq_prod),
        .D(rq_prod0_n_91),
        .Q(rq_prod_reg__0[14]),
        .R(out_valid_i_1_n_0));
  FDRE \rq_prod_reg[15] 
       (.C(clk),
        .CE(rq_prod),
        .D(rq_prod0_n_90),
        .Q(rq_prod_reg__0[15]),
        .R(out_valid_i_1_n_0));
  FDRE \rq_prod_reg[16] 
       (.C(clk),
        .CE(rq_prod),
        .D(rq_prod0_n_89),
        .Q(rq_prod_reg__0[16]),
        .R(out_valid_i_1_n_0));
  FDRE \rq_prod_reg[1] 
       (.C(clk),
        .CE(rq_prod),
        .D(rq_prod0_n_104),
        .Q(rq_prod_reg__0[1]),
        .R(out_valid_i_1_n_0));
  FDRE \rq_prod_reg[2] 
       (.C(clk),
        .CE(rq_prod),
        .D(rq_prod0_n_103),
        .Q(rq_prod_reg__0[2]),
        .R(out_valid_i_1_n_0));
  FDRE \rq_prod_reg[3] 
       (.C(clk),
        .CE(rq_prod),
        .D(rq_prod0_n_102),
        .Q(rq_prod_reg__0[3]),
        .R(out_valid_i_1_n_0));
  FDRE \rq_prod_reg[4] 
       (.C(clk),
        .CE(rq_prod),
        .D(rq_prod0_n_101),
        .Q(rq_prod_reg__0[4]),
        .R(out_valid_i_1_n_0));
  FDRE \rq_prod_reg[5] 
       (.C(clk),
        .CE(rq_prod),
        .D(rq_prod0_n_100),
        .Q(rq_prod_reg__0[5]),
        .R(out_valid_i_1_n_0));
  FDRE \rq_prod_reg[6] 
       (.C(clk),
        .CE(rq_prod),
        .D(rq_prod0_n_99),
        .Q(rq_prod_reg__0[6]),
        .R(out_valid_i_1_n_0));
  FDRE \rq_prod_reg[7] 
       (.C(clk),
        .CE(rq_prod),
        .D(rq_prod0_n_98),
        .Q(rq_prod_reg__0[7]),
        .R(out_valid_i_1_n_0));
  FDRE \rq_prod_reg[8] 
       (.C(clk),
        .CE(rq_prod),
        .D(rq_prod0_n_97),
        .Q(rq_prod_reg__0[8]),
        .R(out_valid_i_1_n_0));
  FDRE \rq_prod_reg[9] 
       (.C(clk),
        .CE(rq_prod),
        .D(rq_prod0_n_96),
        .Q(rq_prod_reg__0[9]),
        .R(out_valid_i_1_n_0));
  LUT5 #(
    .INIT(32'h00000020)) 
    \word_buf[31]_i_1 
       (.I0(state[0]),
        .I1(state[2]),
        .I2(state[3]),
        .I3(state[1]),
        .I4(state[4]),
        .O(word_buf));
  FDRE \word_buf_reg[10] 
       (.C(clk),
        .CE(word_buf),
        .D(bram_addr_reg_rep_0_n_25),
        .Q(\word_buf_reg_n_0_[10] ),
        .R(out_valid_i_1_n_0));
  FDRE \word_buf_reg[11] 
       (.C(clk),
        .CE(word_buf),
        .D(bram_addr_reg_rep_0_n_24),
        .Q(\word_buf_reg_n_0_[11] ),
        .R(out_valid_i_1_n_0));
  FDRE \word_buf_reg[12] 
       (.C(clk),
        .CE(word_buf),
        .D(bram_addr_reg_rep_0_n_23),
        .Q(\word_buf_reg_n_0_[12] ),
        .R(out_valid_i_1_n_0));
  FDRE \word_buf_reg[13] 
       (.C(clk),
        .CE(word_buf),
        .D(bram_addr_reg_rep_0_n_22),
        .Q(\word_buf_reg_n_0_[13] ),
        .R(out_valid_i_1_n_0));
  FDRE \word_buf_reg[14] 
       (.C(clk),
        .CE(word_buf),
        .D(bram_addr_reg_rep_0_n_21),
        .Q(\word_buf_reg_n_0_[14] ),
        .R(out_valid_i_1_n_0));
  FDRE \word_buf_reg[15] 
       (.C(clk),
        .CE(word_buf),
        .D(bram_addr_reg_rep_0_n_20),
        .Q(\word_buf_reg_n_0_[15] ),
        .R(out_valid_i_1_n_0));
  FDRE \word_buf_reg[16] 
       (.C(clk),
        .CE(word_buf),
        .D(bram_addr_reg_rep_1_n_35),
        .Q(\word_buf_reg_n_0_[16] ),
        .R(out_valid_i_1_n_0));
  FDRE \word_buf_reg[17] 
       (.C(clk),
        .CE(word_buf),
        .D(bram_addr_reg_rep_1_n_34),
        .Q(\word_buf_reg_n_0_[17] ),
        .R(out_valid_i_1_n_0));
  FDRE \word_buf_reg[18] 
       (.C(clk),
        .CE(word_buf),
        .D(bram_addr_reg_rep_1_n_33),
        .Q(\word_buf_reg_n_0_[18] ),
        .R(out_valid_i_1_n_0));
  FDRE \word_buf_reg[19] 
       (.C(clk),
        .CE(word_buf),
        .D(bram_addr_reg_rep_1_n_32),
        .Q(\word_buf_reg_n_0_[19] ),
        .R(out_valid_i_1_n_0));
  FDRE \word_buf_reg[20] 
       (.C(clk),
        .CE(word_buf),
        .D(bram_addr_reg_rep_1_n_31),
        .Q(\word_buf_reg_n_0_[20] ),
        .R(out_valid_i_1_n_0));
  FDRE \word_buf_reg[21] 
       (.C(clk),
        .CE(word_buf),
        .D(bram_addr_reg_rep_1_n_30),
        .Q(\word_buf_reg_n_0_[21] ),
        .R(out_valid_i_1_n_0));
  FDRE \word_buf_reg[22] 
       (.C(clk),
        .CE(word_buf),
        .D(bram_addr_reg_rep_1_n_29),
        .Q(\word_buf_reg_n_0_[22] ),
        .R(out_valid_i_1_n_0));
  FDRE \word_buf_reg[23] 
       (.C(clk),
        .CE(word_buf),
        .D(bram_addr_reg_rep_1_n_28),
        .Q(\word_buf_reg_n_0_[23] ),
        .R(out_valid_i_1_n_0));
  FDRE \word_buf_reg[24] 
       (.C(clk),
        .CE(word_buf),
        .D(bram_addr_reg_rep_1_n_27),
        .Q(\word_buf_reg_n_0_[24] ),
        .R(out_valid_i_1_n_0));
  FDRE \word_buf_reg[25] 
       (.C(clk),
        .CE(word_buf),
        .D(bram_addr_reg_rep_1_n_26),
        .Q(\word_buf_reg_n_0_[25] ),
        .R(out_valid_i_1_n_0));
  FDRE \word_buf_reg[26] 
       (.C(clk),
        .CE(word_buf),
        .D(bram_addr_reg_rep_1_n_25),
        .Q(\word_buf_reg_n_0_[26] ),
        .R(out_valid_i_1_n_0));
  FDRE \word_buf_reg[27] 
       (.C(clk),
        .CE(word_buf),
        .D(bram_addr_reg_rep_1_n_24),
        .Q(\word_buf_reg_n_0_[27] ),
        .R(out_valid_i_1_n_0));
  FDRE \word_buf_reg[28] 
       (.C(clk),
        .CE(word_buf),
        .D(bram_addr_reg_rep_1_n_23),
        .Q(\word_buf_reg_n_0_[28] ),
        .R(out_valid_i_1_n_0));
  FDRE \word_buf_reg[29] 
       (.C(clk),
        .CE(word_buf),
        .D(bram_addr_reg_rep_1_n_22),
        .Q(\word_buf_reg_n_0_[29] ),
        .R(out_valid_i_1_n_0));
  FDRE \word_buf_reg[30] 
       (.C(clk),
        .CE(word_buf),
        .D(bram_addr_reg_rep_1_n_21),
        .Q(\word_buf_reg_n_0_[30] ),
        .R(out_valid_i_1_n_0));
  FDRE \word_buf_reg[31] 
       (.C(clk),
        .CE(word_buf),
        .D(bram_addr_reg_rep_1_n_20),
        .Q(\word_buf_reg_n_0_[31] ),
        .R(out_valid_i_1_n_0));
  FDRE \word_buf_reg[8] 
       (.C(clk),
        .CE(word_buf),
        .D(bram_addr_reg_rep_0_n_27),
        .Q(\word_buf_reg_n_0_[8] ),
        .R(out_valid_i_1_n_0));
  FDRE \word_buf_reg[9] 
       (.C(clk),
        .CE(word_buf),
        .D(bram_addr_reg_rep_0_n_26),
        .Q(\word_buf_reg_n_0_[9] ),
        .R(out_valid_i_1_n_0));
  LUT3 #(
    .INIT(8'h04)) 
    \word_idx[0]_i_1 
       (.I0(state[4]),
        .I1(state[3]),
        .I2(mac_in__0[2]),
        .O(\word_idx[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT4 #(
    .INIT(16'h0440)) 
    \word_idx[1]_i_1 
       (.I0(state[4]),
        .I1(state[3]),
        .I2(mac_in__0[2]),
        .I3(mac_in__0[3]),
        .O(\word_idx[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT5 #(
    .INIT(32'h04444000)) 
    \word_idx[2]_i_1 
       (.I0(state[4]),
        .I1(state[3]),
        .I2(mac_in__0[2]),
        .I3(mac_in__0[3]),
        .I4(mac_in__0[4]),
        .O(\word_idx[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0444444440000000)) 
    \word_idx[3]_i_1 
       (.I0(state[4]),
        .I1(state[3]),
        .I2(mac_in__0[3]),
        .I3(mac_in__0[2]),
        .I4(mac_in__0[4]),
        .I5(mac_in__0[5]),
        .O(\word_idx[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000014340424)) 
    \word_idx[4]_i_1 
       (.I0(state[3]),
        .I1(state[4]),
        .I2(state[2]),
        .I3(\word_idx[4]_i_3_n_0 ),
        .I4(\word_idx[4]_i_4_n_0 ),
        .I5(\word_idx[4]_i_5_n_0 ),
        .O(\word_idx[4]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h04444000)) 
    \word_idx[4]_i_2 
       (.I0(state[4]),
        .I1(state[3]),
        .I2(\word_idx[4]_i_6_n_0 ),
        .I3(mac_in__0[5]),
        .I4(\word_idx_reg_n_0_[4] ),
        .O(\word_idx[4]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT5 #(
    .INIT(32'h00004080)) 
    \word_idx[4]_i_3 
       (.I0(mac_in__0[5]),
        .I1(mac_in__0[2]),
        .I2(\word_idx[4]_i_7_n_0 ),
        .I3(\layer_reg_n_0_[1] ),
        .I4(\word_idx_reg_n_0_[4] ),
        .O(\word_idx[4]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0000000040000000)) 
    \word_idx[4]_i_4 
       (.I0(\feat_cnt_reg_n_0_[3] ),
        .I1(\feat_cnt_reg_n_0_[5] ),
        .I2(\feat_cnt_reg_n_0_[2] ),
        .I3(\feat_cnt_reg_n_0_[0] ),
        .I4(\feat_cnt_reg_n_0_[1] ),
        .I5(\feat_cnt_reg_n_0_[4] ),
        .O(\word_idx[4]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair50" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \word_idx[4]_i_5 
       (.I0(state[1]),
        .I1(state[0]),
        .O(\word_idx[4]_i_5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair48" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \word_idx[4]_i_6 
       (.I0(mac_in__0[4]),
        .I1(mac_in__0[2]),
        .I2(mac_in__0[3]),
        .O(\word_idx[4]_i_6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair48" *) 
  LUT4 #(
    .INIT(16'h8881)) 
    \word_idx[4]_i_7 
       (.I0(mac_in__0[3]),
        .I1(mac_in__0[4]),
        .I2(\layer_reg_n_0_[0] ),
        .I3(\layer_reg_n_0_[1] ),
        .O(\word_idx[4]_i_7_n_0 ));
  FDRE \word_idx_reg[0] 
       (.C(clk),
        .CE(\word_idx[4]_i_1_n_0 ),
        .D(\word_idx[0]_i_1_n_0 ),
        .Q(mac_in__0[2]),
        .R(out_valid_i_1_n_0));
  FDRE \word_idx_reg[1] 
       (.C(clk),
        .CE(\word_idx[4]_i_1_n_0 ),
        .D(\word_idx[1]_i_1_n_0 ),
        .Q(mac_in__0[3]),
        .R(out_valid_i_1_n_0));
  FDRE \word_idx_reg[2] 
       (.C(clk),
        .CE(\word_idx[4]_i_1_n_0 ),
        .D(\word_idx[2]_i_1_n_0 ),
        .Q(mac_in__0[4]),
        .R(out_valid_i_1_n_0));
  FDRE \word_idx_reg[3] 
       (.C(clk),
        .CE(\word_idx[4]_i_1_n_0 ),
        .D(\word_idx[3]_i_1_n_0 ),
        .Q(mac_in__0[5]),
        .R(out_valid_i_1_n_0));
  FDRE \word_idx_reg[4] 
       (.C(clk),
        .CE(\word_idx[4]_i_1_n_0 ),
        .D(\word_idx[4]_i_2_n_0 ),
        .Q(\word_idx_reg_n_0_[4] ),
        .R(out_valid_i_1_n_0));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "320" *) 
  (* RTL_RAM_NAME = "emg_nn_infer/xq_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "39" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "0" *) 
  (* ram_slice_end = "2" *) 
  RAM64M xq_reg_0_63_0_2
       (.ADDRA({mac_in__0,mac_in}),
        .ADDRB({mac_in__0,mac_in}),
        .ADDRC({mac_in__0,mac_in}),
        .ADDRD(feat_save_idx),
        .DIA(normalized_activation[0]),
        .DIB(normalized_activation[1]),
        .DIC(normalized_activation[2]),
        .DID(1'b0),
        .DOA(act1[0]),
        .DOB(act1[1]),
        .DOC(act1[2]),
        .DOD(NLW_xq_reg_0_63_0_2_DOD_UNCONNECTED),
        .WCLK(clk),
        .WE(xq_reg_0_63_0_2_i_4_n_0));
  LUT6 #(
    .INIT(64'hFFFFFF00FFE2FFE2)) 
    xq_reg_0_63_0_2_i_1
       (.I0(xq_reg_0_63_0_2_i_7_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_8_n_0),
        .I3(xq_reg_0_63_0_2_i_9_n_3),
        .I4(xq_reg_0_63_0_2_i_10_n_0),
        .I5(\n_in_r_reg_n_0_[0] ),
        .O(normalized_activation[0]));
  LUT5 #(
    .INIT(32'hBBB8B8B8)) 
    xq_reg_0_63_0_2_i_10
       (.I0(xq_reg_0_63_0_2_i_24_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_25_n_0),
        .I3(\n_in_r_reg_n_0_[2] ),
        .I4(xq_reg_0_63_0_2_i_26_n_0),
        .O(xq_reg_0_63_0_2_i_10_n_0));
  LUT5 #(
    .INIT(32'h6AAAAAAA)) 
    xq_reg_0_63_0_2_i_100
       (.I0(norm_prod_reg__1[22]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_193_n_0),
        .O(xq_reg_0_63_0_2_i_100_n_0));
  LUT5 #(
    .INIT(32'hA6AAAAAA)) 
    xq_reg_0_63_0_2_i_101
       (.I0(norm_prod_reg__1[21]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_193_n_0),
        .O(xq_reg_0_63_0_2_i_101_n_0));
  LUT5 #(
    .INIT(32'hAA6AAAAA)) 
    xq_reg_0_63_0_2_i_102
       (.I0(norm_prod_reg__1[20]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_193_n_0),
        .O(xq_reg_0_63_0_2_i_102_n_0));
  LUT5 #(
    .INIT(32'hAAA6AAAA)) 
    xq_reg_0_63_0_2_i_103
       (.I0(\norm_prod_reg[3]__0_n_0 ),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_178_n_0),
        .O(xq_reg_0_63_0_2_i_103_n_0));
  LUT5 #(
    .INIT(32'h9AAAAAAA)) 
    xq_reg_0_63_0_2_i_104
       (.I0(\norm_prod_reg[2]__0_n_0 ),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_178_n_0),
        .O(xq_reg_0_63_0_2_i_104_n_0));
  LUT5 #(
    .INIT(32'hA9AAAAAA)) 
    xq_reg_0_63_0_2_i_105
       (.I0(\norm_prod_reg[1]__0_n_0 ),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_178_n_0),
        .O(xq_reg_0_63_0_2_i_105_n_0));
  LUT5 #(
    .INIT(32'hAA9AAAAA)) 
    xq_reg_0_63_0_2_i_106
       (.I0(\norm_prod_reg[0]__0_n_0 ),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_178_n_0),
        .O(xq_reg_0_63_0_2_i_106_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 xq_reg_0_63_0_2_i_107
       (.CI(xq_reg_0_63_0_2_i_79_n_0),
        .CO({xq_reg_0_63_0_2_i_107_n_0,xq_reg_0_63_0_2_i_107_n_1,xq_reg_0_63_0_2_i_107_n_2,xq_reg_0_63_0_2_i_107_n_3}),
        .CYINIT(1'b0),
        .DI({norm_prod_reg__0_n_87,norm_prod_reg__0_n_88,norm_prod_reg__0_n_89,norm_prod_reg__0_n_90}),
        .O(norm_prod_reg__1[35:32]),
        .S({xq_reg_0_63_0_2_i_194_n_0,xq_reg_0_63_0_2_i_195_n_0,xq_reg_0_63_0_2_i_196_n_0,xq_reg_0_63_0_2_i_197_n_0}));
  LUT5 #(
    .INIT(32'hAAA6AAAA)) 
    xq_reg_0_63_0_2_i_108
       (.I0(norm_prod_reg__1[35]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_183_n_0),
        .O(xq_reg_0_63_0_2_i_108_n_0));
  LUT5 #(
    .INIT(32'h9AAAAAAA)) 
    xq_reg_0_63_0_2_i_109
       (.I0(norm_prod_reg__1[34]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_183_n_0),
        .O(xq_reg_0_63_0_2_i_109_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    xq_reg_0_63_0_2_i_11
       (.I0(xq_reg_0_63_0_2_i_27_n_0),
        .I1(xq_reg_0_63_0_2_i_16_n_0),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_13_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(xq_reg_0_63_0_2_i_14_n_0),
        .O(xq_reg_0_63_0_2_i_11_n_0));
  LUT5 #(
    .INIT(32'hA9AAAAAA)) 
    xq_reg_0_63_0_2_i_110
       (.I0(norm_prod_reg__1[33]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_183_n_0),
        .O(xq_reg_0_63_0_2_i_110_n_0));
  LUT5 #(
    .INIT(32'hAA9AAAAA)) 
    xq_reg_0_63_0_2_i_111
       (.I0(norm_prod_reg__1[32]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_183_n_0),
        .O(xq_reg_0_63_0_2_i_111_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 xq_reg_0_63_0_2_i_112
       (.CI(xq_reg_0_63_0_2_i_69_n_0),
        .CO({xq_reg_0_63_0_2_i_112_n_0,xq_reg_0_63_0_2_i_112_n_1,xq_reg_0_63_0_2_i_112_n_2,xq_reg_0_63_0_2_i_112_n_3}),
        .CYINIT(1'b0),
        .DI({norm_prod_reg__0_n_71,norm_prod_reg__0_n_72,norm_prod_reg__0_n_73,norm_prod_reg__0_n_74}),
        .O(norm_prod_reg__1[51:48]),
        .S({xq_reg_0_63_0_2_i_198_n_0,xq_reg_0_63_0_2_i_199_n_0,xq_reg_0_63_0_2_i_200_n_0,xq_reg_0_63_0_2_i_201_n_0}));
  LUT5 #(
    .INIT(32'hAAA6AAAA)) 
    xq_reg_0_63_0_2_i_113
       (.I0(norm_prod_reg__1[51]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_188_n_0),
        .O(xq_reg_0_63_0_2_i_113_n_0));
  LUT5 #(
    .INIT(32'h9AAAAAAA)) 
    xq_reg_0_63_0_2_i_114
       (.I0(norm_prod_reg__1[50]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_188_n_0),
        .O(xq_reg_0_63_0_2_i_114_n_0));
  LUT5 #(
    .INIT(32'hA9AAAAAA)) 
    xq_reg_0_63_0_2_i_115
       (.I0(norm_prod_reg__1[49]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_188_n_0),
        .O(xq_reg_0_63_0_2_i_115_n_0));
  LUT5 #(
    .INIT(32'hAA9AAAAA)) 
    xq_reg_0_63_0_2_i_116
       (.I0(norm_prod_reg__1[48]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_188_n_0),
        .O(xq_reg_0_63_0_2_i_116_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 xq_reg_0_63_0_2_i_117
       (.CI(1'b0),
        .CO({xq_reg_0_63_0_2_i_117_n_0,xq_reg_0_63_0_2_i_117_n_1,xq_reg_0_63_0_2_i_117_n_2,xq_reg_0_63_0_2_i_117_n_3}),
        .CYINIT(1'b0),
        .DI({norm_prod_reg__0_n_103,norm_prod_reg__0_n_104,norm_prod_reg__0_n_105,1'b0}),
        .O(norm_prod_reg__1[19:16]),
        .S({xq_reg_0_63_0_2_i_202_n_0,xq_reg_0_63_0_2_i_203_n_0,xq_reg_0_63_0_2_i_204_n_0,\norm_prod_reg[16]__0_n_0 }));
  LUT5 #(
    .INIT(32'hAAA6AAAA)) 
    xq_reg_0_63_0_2_i_118
       (.I0(norm_prod_reg__1[19]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_193_n_0),
        .O(xq_reg_0_63_0_2_i_118_n_0));
  LUT5 #(
    .INIT(32'h9AAAAAAA)) 
    xq_reg_0_63_0_2_i_119
       (.I0(norm_prod_reg__1[18]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_193_n_0),
        .O(xq_reg_0_63_0_2_i_119_n_0));
  (* SOFT_HLUTNM = "soft_lutpair97" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    xq_reg_0_63_0_2_i_12
       (.I0(xq_reg_0_63_0_2_i_28_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_24_n_0),
        .O(xq_reg_0_63_0_2_i_12_n_0));
  LUT5 #(
    .INIT(32'hA9AAAAAA)) 
    xq_reg_0_63_0_2_i_120
       (.I0(norm_prod_reg__1[17]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_193_n_0),
        .O(xq_reg_0_63_0_2_i_120_n_0));
  LUT5 #(
    .INIT(32'hAA9AAAAA)) 
    xq_reg_0_63_0_2_i_121
       (.I0(norm_prod_reg__1[16]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_193_n_0),
        .O(xq_reg_0_63_0_2_i_121_n_0));
  LUT5 #(
    .INIT(32'hAAA6AAAA)) 
    xq_reg_0_63_0_2_i_122
       (.I0(\norm_prod_reg[11]__0_n_0 ),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_162_n_0),
        .O(xq_reg_0_63_0_2_i_122_n_0));
  LUT5 #(
    .INIT(32'h9AAAAAAA)) 
    xq_reg_0_63_0_2_i_123
       (.I0(\norm_prod_reg[10]__0_n_0 ),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_162_n_0),
        .O(xq_reg_0_63_0_2_i_123_n_0));
  LUT5 #(
    .INIT(32'hA9AAAAAA)) 
    xq_reg_0_63_0_2_i_124
       (.I0(\norm_prod_reg[9]__0_n_0 ),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_162_n_0),
        .O(xq_reg_0_63_0_2_i_124_n_0));
  LUT5 #(
    .INIT(32'hAA9AAAAA)) 
    xq_reg_0_63_0_2_i_125
       (.I0(\norm_prod_reg[8]__0_n_0 ),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_162_n_0),
        .O(xq_reg_0_63_0_2_i_125_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 xq_reg_0_63_0_2_i_126
       (.CI(xq_reg_0_63_0_2_i_88_n_0),
        .CO({xq_reg_0_63_0_2_i_126_n_0,xq_reg_0_63_0_2_i_126_n_1,xq_reg_0_63_0_2_i_126_n_2,xq_reg_0_63_0_2_i_126_n_3}),
        .CYINIT(1'b0),
        .DI({norm_prod_reg__0_n_79,norm_prod_reg__0_n_80,norm_prod_reg__0_n_81,norm_prod_reg__0_n_82}),
        .O(norm_prod_reg__1[43:40]),
        .S({xq_reg_0_63_0_2_i_205_n_0,xq_reg_0_63_0_2_i_206_n_0,xq_reg_0_63_0_2_i_207_n_0,xq_reg_0_63_0_2_i_208_n_0}));
  LUT5 #(
    .INIT(32'hAAA6AAAA)) 
    xq_reg_0_63_0_2_i_127
       (.I0(norm_prod_reg__1[43]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_167_n_0),
        .O(xq_reg_0_63_0_2_i_127_n_0));
  LUT5 #(
    .INIT(32'h9AAAAAAA)) 
    xq_reg_0_63_0_2_i_128
       (.I0(norm_prod_reg__1[42]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_167_n_0),
        .O(xq_reg_0_63_0_2_i_128_n_0));
  LUT5 #(
    .INIT(32'hA9AAAAAA)) 
    xq_reg_0_63_0_2_i_129
       (.I0(norm_prod_reg__1[41]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_167_n_0),
        .O(xq_reg_0_63_0_2_i_129_n_0));
  LUT6 #(
    .INIT(64'hFC0CFAFAFC0C0A0A)) 
    xq_reg_0_63_0_2_i_13
       (.I0(xq_reg_0_63_0_2_i_29_n_7),
        .I1(xq_reg_0_63_0_2_i_30_n_7),
        .I2(\n_in_r_reg_n_0_[4] ),
        .I3(xq_reg_0_63_0_2_i_31_n_7),
        .I4(\n_in_r_reg_n_0_[5] ),
        .I5(xq_reg_0_63_0_2_i_32_n_7),
        .O(xq_reg_0_63_0_2_i_13_n_0));
  LUT5 #(
    .INIT(32'hAA9AAAAA)) 
    xq_reg_0_63_0_2_i_130
       (.I0(norm_prod_reg__1[40]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_167_n_0),
        .O(xq_reg_0_63_0_2_i_130_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 xq_reg_0_63_0_2_i_131
       (.CI(xq_reg_0_63_0_2_i_93_n_0),
        .CO({xq_reg_0_63_0_2_i_131_n_0,xq_reg_0_63_0_2_i_131_n_1,xq_reg_0_63_0_2_i_131_n_2,xq_reg_0_63_0_2_i_131_n_3}),
        .CYINIT(1'b0),
        .DI({norm_prod_reg__0_n_63,norm_prod_reg__0_n_64,norm_prod_reg__0_n_65,norm_prod_reg__0_n_66}),
        .O(norm_prod_reg__1[59:56]),
        .S({xq_reg_0_63_0_2_i_209_n_0,xq_reg_0_63_0_2_i_210_n_0,xq_reg_0_63_0_2_i_211_n_0,xq_reg_0_63_0_2_i_212_n_0}));
  LUT5 #(
    .INIT(32'hAAA6AAAA)) 
    xq_reg_0_63_0_2_i_132
       (.I0(norm_prod_reg__1[59]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_172_n_0),
        .O(xq_reg_0_63_0_2_i_132_n_0));
  LUT5 #(
    .INIT(32'h9AAAAAAA)) 
    xq_reg_0_63_0_2_i_133
       (.I0(norm_prod_reg__1[58]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_172_n_0),
        .O(xq_reg_0_63_0_2_i_133_n_0));
  LUT5 #(
    .INIT(32'hA9AAAAAA)) 
    xq_reg_0_63_0_2_i_134
       (.I0(norm_prod_reg__1[57]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_172_n_0),
        .O(xq_reg_0_63_0_2_i_134_n_0));
  LUT5 #(
    .INIT(32'hAA9AAAAA)) 
    xq_reg_0_63_0_2_i_135
       (.I0(norm_prod_reg__1[56]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_172_n_0),
        .O(xq_reg_0_63_0_2_i_135_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 xq_reg_0_63_0_2_i_136
       (.CI(xq_reg_0_63_0_2_i_98_n_0),
        .CO({xq_reg_0_63_0_2_i_136_n_0,xq_reg_0_63_0_2_i_136_n_1,xq_reg_0_63_0_2_i_136_n_2,xq_reg_0_63_0_2_i_136_n_3}),
        .CYINIT(1'b0),
        .DI({norm_prod_reg__0_n_95,norm_prod_reg__0_n_96,norm_prod_reg__0_n_97,norm_prod_reg__0_n_98}),
        .O(norm_prod_reg__1[27:24]),
        .S({xq_reg_0_63_0_2_i_213_n_0,xq_reg_0_63_0_2_i_214_n_0,xq_reg_0_63_0_2_i_215_n_0,xq_reg_0_63_0_2_i_216_n_0}));
  LUT5 #(
    .INIT(32'hAAA6AAAA)) 
    xq_reg_0_63_0_2_i_137
       (.I0(norm_prod_reg__1[27]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_177_n_0),
        .O(xq_reg_0_63_0_2_i_137_n_0));
  LUT5 #(
    .INIT(32'h9AAAAAAA)) 
    xq_reg_0_63_0_2_i_138
       (.I0(norm_prod_reg__1[26]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_177_n_0),
        .O(xq_reg_0_63_0_2_i_138_n_0));
  LUT5 #(
    .INIT(32'hA9AAAAAA)) 
    xq_reg_0_63_0_2_i_139
       (.I0(norm_prod_reg__1[25]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_177_n_0),
        .O(xq_reg_0_63_0_2_i_139_n_0));
  LUT6 #(
    .INIT(64'hFC0CFAFAFC0C0A0A)) 
    xq_reg_0_63_0_2_i_14
       (.I0(xq_reg_0_63_0_2_i_33_n_7),
        .I1(xq_reg_0_63_0_2_i_34_n_7),
        .I2(\n_in_r_reg_n_0_[4] ),
        .I3(xq_reg_0_63_0_2_i_35_n_7),
        .I4(\n_in_r_reg_n_0_[5] ),
        .I5(xq_reg_0_63_0_2_i_36_n_7),
        .O(xq_reg_0_63_0_2_i_14_n_0));
  LUT5 #(
    .INIT(32'hAA9AAAAA)) 
    xq_reg_0_63_0_2_i_140
       (.I0(norm_prod_reg__1[24]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_177_n_0),
        .O(xq_reg_0_63_0_2_i_140_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 xq_reg_0_63_0_2_i_141
       (.CI(xq_reg_0_63_0_2_i_217_n_0),
        .CO({xq_reg_0_63_0_2_i_141_n_0,xq_reg_0_63_0_2_i_141_n_1,xq_reg_0_63_0_2_i_141_n_2,xq_reg_0_63_0_2_i_141_n_3}),
        .CYINIT(1'b0),
        .DI({xq_reg_0_63_0_2_i_218_n_0,xq_reg_0_63_0_2_i_219_n_0,xq_reg_0_63_0_2_i_220_n_0,xq_reg_0_63_0_2_i_221_n_0}),
        .O(NLW_xq_reg_0_63_0_2_i_141_O_UNCONNECTED[3:0]),
        .S({xq_reg_0_63_0_2_i_222_n_0,xq_reg_0_63_0_2_i_223_n_0,xq_reg_0_63_0_2_i_224_n_0,xq_reg_0_63_0_2_i_225_n_0}));
  LUT6 #(
    .INIT(64'hFFFFFFFFAFA0FC0C)) 
    xq_reg_0_63_0_2_i_142
       (.I0(xq_reg_0_63_0_2_i_157_n_0),
        .I1(xq_reg_0_63_0_2_i_226_n_0),
        .I2(\n_in_r_reg_n_0_[1] ),
        .I3(xq_reg_0_63_0_2_i_160_n_0),
        .I4(\n_in_r_reg_n_0_[0] ),
        .I5(xq_reg_0_63_0_2_i_227_n_0),
        .O(xq_reg_0_63_0_2_i_142_n_0));
  LUT6 #(
    .INIT(64'hFEFBFEEABAFBBAEA)) 
    xq_reg_0_63_0_2_i_143
       (.I0(xq_reg_0_63_0_2_i_228_n_0),
        .I1(\n_in_r_reg_n_0_[0] ),
        .I2(xq_reg_0_63_0_2_i_226_n_0),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_229_n_0),
        .I5(xq_reg_0_63_0_2_i_160_n_0),
        .O(xq_reg_0_63_0_2_i_143_n_0));
  LUT6 #(
    .INIT(64'hFEFBFEEABAFBBAEA)) 
    xq_reg_0_63_0_2_i_144
       (.I0(xq_reg_0_63_0_2_i_230_n_0),
        .I1(\n_in_r_reg_n_0_[0] ),
        .I2(xq_reg_0_63_0_2_i_229_n_0),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_231_n_0),
        .I5(xq_reg_0_63_0_2_i_226_n_0),
        .O(xq_reg_0_63_0_2_i_144_n_0));
  LUT6 #(
    .INIT(64'hFEFBFEEABAFBBAEA)) 
    xq_reg_0_63_0_2_i_145
       (.I0(xq_reg_0_63_0_2_i_232_n_0),
        .I1(\n_in_r_reg_n_0_[0] ),
        .I2(xq_reg_0_63_0_2_i_231_n_0),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_233_n_0),
        .I5(xq_reg_0_63_0_2_i_229_n_0),
        .O(xq_reg_0_63_0_2_i_145_n_0));
  LUT6 #(
    .INIT(64'h00000000505F03F3)) 
    xq_reg_0_63_0_2_i_146
       (.I0(xq_reg_0_63_0_2_i_157_n_0),
        .I1(xq_reg_0_63_0_2_i_226_n_0),
        .I2(\n_in_r_reg_n_0_[1] ),
        .I3(xq_reg_0_63_0_2_i_160_n_0),
        .I4(\n_in_r_reg_n_0_[0] ),
        .I5(xq_reg_0_63_0_2_i_227_n_0),
        .O(xq_reg_0_63_0_2_i_146_n_0));
  LUT6 #(
    .INIT(64'h00000000505F03F3)) 
    xq_reg_0_63_0_2_i_147
       (.I0(xq_reg_0_63_0_2_i_160_n_0),
        .I1(xq_reg_0_63_0_2_i_229_n_0),
        .I2(\n_in_r_reg_n_0_[1] ),
        .I3(xq_reg_0_63_0_2_i_226_n_0),
        .I4(\n_in_r_reg_n_0_[0] ),
        .I5(xq_reg_0_63_0_2_i_228_n_0),
        .O(xq_reg_0_63_0_2_i_147_n_0));
  LUT6 #(
    .INIT(64'h00000000505F03F3)) 
    xq_reg_0_63_0_2_i_148
       (.I0(xq_reg_0_63_0_2_i_226_n_0),
        .I1(xq_reg_0_63_0_2_i_231_n_0),
        .I2(\n_in_r_reg_n_0_[1] ),
        .I3(xq_reg_0_63_0_2_i_229_n_0),
        .I4(\n_in_r_reg_n_0_[0] ),
        .I5(xq_reg_0_63_0_2_i_230_n_0),
        .O(xq_reg_0_63_0_2_i_148_n_0));
  LUT6 #(
    .INIT(64'h00000000505F03F3)) 
    xq_reg_0_63_0_2_i_149
       (.I0(xq_reg_0_63_0_2_i_229_n_0),
        .I1(xq_reg_0_63_0_2_i_233_n_0),
        .I2(\n_in_r_reg_n_0_[1] ),
        .I3(xq_reg_0_63_0_2_i_231_n_0),
        .I4(\n_in_r_reg_n_0_[0] ),
        .I5(xq_reg_0_63_0_2_i_232_n_0),
        .O(xq_reg_0_63_0_2_i_149_n_0));
  LUT6 #(
    .INIT(64'hFC0CFAFAFC0C0A0A)) 
    xq_reg_0_63_0_2_i_15
       (.I0(xq_reg_0_63_0_2_i_37_n_7),
        .I1(xq_reg_0_63_0_2_i_38_n_7),
        .I2(\n_in_r_reg_n_0_[4] ),
        .I3(xq_reg_0_63_0_2_i_39_n_7),
        .I4(\n_in_r_reg_n_0_[5] ),
        .I5(xq_reg_0_63_0_2_i_40_n_7),
        .O(xq_reg_0_63_0_2_i_15_n_0));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT3 #(
    .INIT(8'h02)) 
    xq_reg_0_63_0_2_i_150
       (.I0(xq_reg_0_63_0_2_i_31_n_7),
        .I1(\n_in_r_reg_n_0_[4] ),
        .I2(\n_in_r_reg_n_0_[5] ),
        .O(xq_reg_0_63_0_2_i_150_n_0));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT5 #(
    .INIT(32'h00000010)) 
    xq_reg_0_63_0_2_i_151
       (.I0(\n_in_r_reg_n_0_[5] ),
        .I1(\n_in_r_reg_n_0_[4] ),
        .I2(xq_reg_0_63_0_2_i_31_n_5),
        .I3(\n_in_r_reg_n_0_[2] ),
        .I4(\n_in_r_reg_n_0_[3] ),
        .O(xq_reg_0_63_0_2_i_151_n_0));
  LUT6 #(
    .INIT(64'h0000000000000B08)) 
    xq_reg_0_63_0_2_i_152
       (.I0(xq_reg_0_63_0_2_i_31_n_4),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_54_n_0),
        .I3(xq_reg_0_63_0_2_i_31_n_6),
        .I4(\n_in_r_reg_n_0_[2] ),
        .I5(\n_in_r_reg_n_0_[3] ),
        .O(xq_reg_0_63_0_2_i_152_n_0));
  LUT6 #(
    .INIT(64'h0000000000000B08)) 
    xq_reg_0_63_0_2_i_153
       (.I0(xq_reg_0_63_0_2_i_31_n_5),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_54_n_0),
        .I3(xq_reg_0_63_0_2_i_31_n_7),
        .I4(\n_in_r_reg_n_0_[2] ),
        .I5(\n_in_r_reg_n_0_[3] ),
        .O(xq_reg_0_63_0_2_i_153_n_0));
  LUT6 #(
    .INIT(64'h0004FFFF00040000)) 
    xq_reg_0_63_0_2_i_154
       (.I0(xq_reg_0_63_0_2_i_54_n_0),
        .I1(xq_reg_0_63_0_2_i_31_n_7),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(\n_in_r_reg_n_0_[3] ),
        .I4(\n_in_r_reg_n_0_[1] ),
        .I5(xq_reg_0_63_0_2_i_158_n_0),
        .O(xq_reg_0_63_0_2_i_154_n_0));
  LUT6 #(
    .INIT(64'h0004FFFF00040000)) 
    xq_reg_0_63_0_2_i_155
       (.I0(xq_reg_0_63_0_2_i_54_n_0),
        .I1(xq_reg_0_63_0_2_i_31_n_6),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(\n_in_r_reg_n_0_[3] ),
        .I4(\n_in_r_reg_n_0_[1] ),
        .I5(xq_reg_0_63_0_2_i_234_n_0),
        .O(xq_reg_0_63_0_2_i_155_n_0));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT5 #(
    .INIT(32'h00000010)) 
    xq_reg_0_63_0_2_i_156
       (.I0(\n_in_r_reg_n_0_[5] ),
        .I1(\n_in_r_reg_n_0_[4] ),
        .I2(xq_reg_0_63_0_2_i_31_n_7),
        .I3(\n_in_r_reg_n_0_[2] ),
        .I4(\n_in_r_reg_n_0_[3] ),
        .O(xq_reg_0_63_0_2_i_156_n_0));
  LUT6 #(
    .INIT(64'h0000000000002320)) 
    xq_reg_0_63_0_2_i_157
       (.I0(xq_reg_0_63_0_2_i_31_n_7),
        .I1(\n_in_r_reg_n_0_[3] ),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_43_n_7),
        .I4(\n_in_r_reg_n_0_[4] ),
        .I5(\n_in_r_reg_n_0_[5] ),
        .O(xq_reg_0_63_0_2_i_157_n_0));
  LUT6 #(
    .INIT(64'h0000000000002320)) 
    xq_reg_0_63_0_2_i_158
       (.I0(xq_reg_0_63_0_2_i_31_n_5),
        .I1(\n_in_r_reg_n_0_[3] ),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_43_n_5),
        .I4(\n_in_r_reg_n_0_[4] ),
        .I5(\n_in_r_reg_n_0_[5] ),
        .O(xq_reg_0_63_0_2_i_158_n_0));
  (* SOFT_HLUTNM = "soft_lutpair98" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    xq_reg_0_63_0_2_i_159
       (.I0(xq_reg_0_63_0_2_i_234_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_235_n_0),
        .O(xq_reg_0_63_0_2_i_159_n_0));
  LUT6 #(
    .INIT(64'hFC0CFAFAFC0C0A0A)) 
    xq_reg_0_63_0_2_i_16
       (.I0(xq_reg_0_63_0_2_i_41_n_7),
        .I1(xq_reg_0_63_0_2_i_42_n_7),
        .I2(\n_in_r_reg_n_0_[4] ),
        .I3(xq_reg_0_63_0_2_i_43_n_7),
        .I4(\n_in_r_reg_n_0_[5] ),
        .I5(xq_reg_0_63_0_2_i_44_n_7),
        .O(xq_reg_0_63_0_2_i_16_n_0));
  LUT6 #(
    .INIT(64'h0000000030BB3088)) 
    xq_reg_0_63_0_2_i_160
       (.I0(xq_reg_0_63_0_2_i_43_n_5),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(xq_reg_0_63_0_2_i_31_n_5),
        .I3(\n_in_r_reg_n_0_[3] ),
        .I4(xq_reg_0_63_0_2_i_35_n_5),
        .I5(xq_reg_0_63_0_2_i_54_n_0),
        .O(xq_reg_0_63_0_2_i_160_n_0));
  (* SOFT_HLUTNM = "soft_lutpair98" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    xq_reg_0_63_0_2_i_161
       (.I0(xq_reg_0_63_0_2_i_235_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_236_n_0),
        .O(xq_reg_0_63_0_2_i_161_n_0));
  LUT6 #(
    .INIT(64'h0000000022200008)) 
    xq_reg_0_63_0_2_i_162
       (.I0(xq_reg_0_63_0_2_i_237_n_0),
        .I1(\n_in_r_reg_n_0_[4] ),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_238_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(\n_in_r_reg_n_0_[5] ),
        .O(xq_reg_0_63_0_2_i_162_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_163
       (.I0(norm_prod_reg__0_n_75),
        .I1(norm_prod_reg_n_92),
        .O(xq_reg_0_63_0_2_i_163_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_164
       (.I0(norm_prod_reg__0_n_76),
        .I1(norm_prod_reg_n_93),
        .O(xq_reg_0_63_0_2_i_164_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_165
       (.I0(norm_prod_reg__0_n_77),
        .I1(norm_prod_reg_n_94),
        .O(xq_reg_0_63_0_2_i_165_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_166
       (.I0(norm_prod_reg__0_n_78),
        .I1(norm_prod_reg_n_95),
        .O(xq_reg_0_63_0_2_i_166_n_0));
  LUT6 #(
    .INIT(64'h2220000800000000)) 
    xq_reg_0_63_0_2_i_167
       (.I0(xq_reg_0_63_0_2_i_237_n_0),
        .I1(\n_in_r_reg_n_0_[4] ),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_238_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(\n_in_r_reg_n_0_[5] ),
        .O(xq_reg_0_63_0_2_i_167_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_168
       (.I0(norm_prod_reg__0_n_59),
        .I1(norm_prod_reg_n_76),
        .O(xq_reg_0_63_0_2_i_168_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_169
       (.I0(norm_prod_reg__0_n_60),
        .I1(norm_prod_reg_n_77),
        .O(xq_reg_0_63_0_2_i_169_n_0));
  LUT6 #(
    .INIT(64'hFC0CFAFAFC0C0A0A)) 
    xq_reg_0_63_0_2_i_17
       (.I0(xq_reg_0_63_0_2_i_37_n_5),
        .I1(xq_reg_0_63_0_2_i_38_n_5),
        .I2(\n_in_r_reg_n_0_[4] ),
        .I3(xq_reg_0_63_0_2_i_39_n_5),
        .I4(\n_in_r_reg_n_0_[5] ),
        .I5(xq_reg_0_63_0_2_i_40_n_5),
        .O(xq_reg_0_63_0_2_i_17_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_170
       (.I0(norm_prod_reg__0_n_61),
        .I1(norm_prod_reg_n_78),
        .O(xq_reg_0_63_0_2_i_170_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_171
       (.I0(norm_prod_reg__0_n_62),
        .I1(norm_prod_reg_n_79),
        .O(xq_reg_0_63_0_2_i_171_n_0));
  LUT6 #(
    .INIT(64'h8880000000000002)) 
    xq_reg_0_63_0_2_i_172
       (.I0(xq_reg_0_63_0_2_i_237_n_0),
        .I1(\n_in_r_reg_n_0_[3] ),
        .I2(xq_reg_0_63_0_2_i_238_n_0),
        .I3(\n_in_r_reg_n_0_[2] ),
        .I4(\n_in_r_reg_n_0_[4] ),
        .I5(\n_in_r_reg_n_0_[5] ),
        .O(xq_reg_0_63_0_2_i_172_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_173
       (.I0(norm_prod_reg__0_n_91),
        .I1(\norm_prod_reg_n_0_[14] ),
        .O(xq_reg_0_63_0_2_i_173_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_174
       (.I0(norm_prod_reg__0_n_92),
        .I1(\norm_prod_reg_n_0_[13] ),
        .O(xq_reg_0_63_0_2_i_174_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_175
       (.I0(norm_prod_reg__0_n_93),
        .I1(\norm_prod_reg_n_0_[12] ),
        .O(xq_reg_0_63_0_2_i_175_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_176
       (.I0(norm_prod_reg__0_n_94),
        .I1(\norm_prod_reg_n_0_[11] ),
        .O(xq_reg_0_63_0_2_i_176_n_0));
  LUT6 #(
    .INIT(64'h0000000288800000)) 
    xq_reg_0_63_0_2_i_177
       (.I0(xq_reg_0_63_0_2_i_237_n_0),
        .I1(\n_in_r_reg_n_0_[4] ),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_238_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(\n_in_r_reg_n_0_[5] ),
        .O(xq_reg_0_63_0_2_i_177_n_0));
  LUT6 #(
    .INIT(64'h0000000000022220)) 
    xq_reg_0_63_0_2_i_178
       (.I0(xq_reg_0_63_0_2_i_237_n_0),
        .I1(\n_in_r_reg_n_0_[4] ),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_238_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(\n_in_r_reg_n_0_[5] ),
        .O(xq_reg_0_63_0_2_i_178_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_179
       (.I0(norm_prod_reg__0_n_83),
        .I1(norm_prod_reg_n_100),
        .O(xq_reg_0_63_0_2_i_179_n_0));
  LUT6 #(
    .INIT(64'hFC0CFAFAFC0C0A0A)) 
    xq_reg_0_63_0_2_i_18
       (.I0(xq_reg_0_63_0_2_i_41_n_5),
        .I1(xq_reg_0_63_0_2_i_42_n_5),
        .I2(\n_in_r_reg_n_0_[4] ),
        .I3(xq_reg_0_63_0_2_i_43_n_5),
        .I4(\n_in_r_reg_n_0_[5] ),
        .I5(xq_reg_0_63_0_2_i_44_n_5),
        .O(xq_reg_0_63_0_2_i_18_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_180
       (.I0(norm_prod_reg__0_n_84),
        .I1(norm_prod_reg_n_101),
        .O(xq_reg_0_63_0_2_i_180_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_181
       (.I0(norm_prod_reg__0_n_85),
        .I1(norm_prod_reg_n_102),
        .O(xq_reg_0_63_0_2_i_181_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_182
       (.I0(norm_prod_reg__0_n_86),
        .I1(norm_prod_reg_n_103),
        .O(xq_reg_0_63_0_2_i_182_n_0));
  LUT6 #(
    .INIT(64'h0002222000000000)) 
    xq_reg_0_63_0_2_i_183
       (.I0(xq_reg_0_63_0_2_i_237_n_0),
        .I1(\n_in_r_reg_n_0_[4] ),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_238_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(\n_in_r_reg_n_0_[5] ),
        .O(xq_reg_0_63_0_2_i_183_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_184
       (.I0(norm_prod_reg__0_n_67),
        .I1(norm_prod_reg_n_84),
        .O(xq_reg_0_63_0_2_i_184_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_185
       (.I0(norm_prod_reg__0_n_68),
        .I1(norm_prod_reg_n_85),
        .O(xq_reg_0_63_0_2_i_185_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_186
       (.I0(norm_prod_reg__0_n_69),
        .I1(norm_prod_reg_n_86),
        .O(xq_reg_0_63_0_2_i_186_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_187
       (.I0(norm_prod_reg__0_n_70),
        .I1(norm_prod_reg_n_87),
        .O(xq_reg_0_63_0_2_i_187_n_0));
  LUT6 #(
    .INIT(64'h0008888000000000)) 
    xq_reg_0_63_0_2_i_188
       (.I0(xq_reg_0_63_0_2_i_237_n_0),
        .I1(\n_in_r_reg_n_0_[4] ),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_238_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(\n_in_r_reg_n_0_[5] ),
        .O(xq_reg_0_63_0_2_i_188_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_189
       (.I0(norm_prod_reg__0_n_99),
        .I1(\norm_prod_reg_n_0_[6] ),
        .O(xq_reg_0_63_0_2_i_189_n_0));
  LUT6 #(
    .INIT(64'hFC0CFAFAFC0C0A0A)) 
    xq_reg_0_63_0_2_i_19
       (.I0(xq_reg_0_63_0_2_i_29_n_5),
        .I1(xq_reg_0_63_0_2_i_30_n_5),
        .I2(\n_in_r_reg_n_0_[4] ),
        .I3(xq_reg_0_63_0_2_i_31_n_5),
        .I4(\n_in_r_reg_n_0_[5] ),
        .I5(xq_reg_0_63_0_2_i_32_n_5),
        .O(xq_reg_0_63_0_2_i_19_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_190
       (.I0(norm_prod_reg__0_n_100),
        .I1(\norm_prod_reg_n_0_[5] ),
        .O(xq_reg_0_63_0_2_i_190_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_191
       (.I0(norm_prod_reg__0_n_101),
        .I1(\norm_prod_reg_n_0_[4] ),
        .O(xq_reg_0_63_0_2_i_191_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_192
       (.I0(norm_prod_reg__0_n_102),
        .I1(\norm_prod_reg_n_0_[3] ),
        .O(xq_reg_0_63_0_2_i_192_n_0));
  LUT6 #(
    .INIT(64'h0000000000088880)) 
    xq_reg_0_63_0_2_i_193
       (.I0(xq_reg_0_63_0_2_i_237_n_0),
        .I1(\n_in_r_reg_n_0_[4] ),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_238_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(\n_in_r_reg_n_0_[5] ),
        .O(xq_reg_0_63_0_2_i_193_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_194
       (.I0(norm_prod_reg__0_n_87),
        .I1(norm_prod_reg_n_104),
        .O(xq_reg_0_63_0_2_i_194_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_195
       (.I0(norm_prod_reg__0_n_88),
        .I1(norm_prod_reg_n_105),
        .O(xq_reg_0_63_0_2_i_195_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_196
       (.I0(norm_prod_reg__0_n_89),
        .I1(\norm_prod_reg_n_0_[16] ),
        .O(xq_reg_0_63_0_2_i_196_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_197
       (.I0(norm_prod_reg__0_n_90),
        .I1(\norm_prod_reg_n_0_[15] ),
        .O(xq_reg_0_63_0_2_i_197_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_198
       (.I0(norm_prod_reg__0_n_71),
        .I1(norm_prod_reg_n_88),
        .O(xq_reg_0_63_0_2_i_198_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_199
       (.I0(norm_prod_reg__0_n_72),
        .I1(norm_prod_reg_n_89),
        .O(xq_reg_0_63_0_2_i_199_n_0));
  LUT6 #(
    .INIT(64'hFFB8FFB8FFFFFF00)) 
    xq_reg_0_63_0_2_i_2
       (.I0(xq_reg_0_63_0_2_i_11_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_8_n_0),
        .I3(xq_reg_0_63_0_2_i_9_n_3),
        .I4(xq_reg_0_63_0_2_i_10_n_0),
        .I5(\n_in_r_reg_n_0_[0] ),
        .O(normalized_activation[1]));
  LUT6 #(
    .INIT(64'hFC0CFAFAFC0C0A0A)) 
    xq_reg_0_63_0_2_i_20
       (.I0(xq_reg_0_63_0_2_i_33_n_5),
        .I1(xq_reg_0_63_0_2_i_34_n_5),
        .I2(\n_in_r_reg_n_0_[4] ),
        .I3(xq_reg_0_63_0_2_i_35_n_5),
        .I4(\n_in_r_reg_n_0_[5] ),
        .I5(xq_reg_0_63_0_2_i_36_n_5),
        .O(xq_reg_0_63_0_2_i_20_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_200
       (.I0(norm_prod_reg__0_n_73),
        .I1(norm_prod_reg_n_90),
        .O(xq_reg_0_63_0_2_i_200_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_201
       (.I0(norm_prod_reg__0_n_74),
        .I1(norm_prod_reg_n_91),
        .O(xq_reg_0_63_0_2_i_201_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_202
       (.I0(norm_prod_reg__0_n_103),
        .I1(\norm_prod_reg_n_0_[2] ),
        .O(xq_reg_0_63_0_2_i_202_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_203
       (.I0(norm_prod_reg__0_n_104),
        .I1(\norm_prod_reg_n_0_[1] ),
        .O(xq_reg_0_63_0_2_i_203_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_204
       (.I0(norm_prod_reg__0_n_105),
        .I1(\norm_prod_reg_n_0_[0] ),
        .O(xq_reg_0_63_0_2_i_204_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_205
       (.I0(norm_prod_reg__0_n_79),
        .I1(norm_prod_reg_n_96),
        .O(xq_reg_0_63_0_2_i_205_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_206
       (.I0(norm_prod_reg__0_n_80),
        .I1(norm_prod_reg_n_97),
        .O(xq_reg_0_63_0_2_i_206_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_207
       (.I0(norm_prod_reg__0_n_81),
        .I1(norm_prod_reg_n_98),
        .O(xq_reg_0_63_0_2_i_207_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_208
       (.I0(norm_prod_reg__0_n_82),
        .I1(norm_prod_reg_n_99),
        .O(xq_reg_0_63_0_2_i_208_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_209
       (.I0(norm_prod_reg__0_n_63),
        .I1(norm_prod_reg_n_80),
        .O(xq_reg_0_63_0_2_i_209_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 xq_reg_0_63_0_2_i_21
       (.CI(xq_reg_0_63_0_2_i_45_n_0),
        .CO({xq_reg_0_63_0_2_i_21_n_0,xq_reg_0_63_0_2_i_21_n_1,xq_reg_0_63_0_2_i_21_n_2,xq_reg_0_63_0_2_i_21_n_3}),
        .CYINIT(1'b0),
        .DI({xq_reg_0_63_0_2_i_46_n_0,xq_reg_0_63_0_2_i_47_n_0,xq_reg_0_63_0_2_i_48_n_0,xq_reg_0_63_0_2_i_49_n_0}),
        .O(NLW_xq_reg_0_63_0_2_i_21_O_UNCONNECTED[3:0]),
        .S({xq_reg_0_63_0_2_i_50_n_0,xq_reg_0_63_0_2_i_51_n_0,xq_reg_0_63_0_2_i_52_n_0,xq_reg_0_63_0_2_i_53_n_0}));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_210
       (.I0(norm_prod_reg__0_n_64),
        .I1(norm_prod_reg_n_81),
        .O(xq_reg_0_63_0_2_i_210_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_211
       (.I0(norm_prod_reg__0_n_65),
        .I1(norm_prod_reg_n_82),
        .O(xq_reg_0_63_0_2_i_211_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_212
       (.I0(norm_prod_reg__0_n_66),
        .I1(norm_prod_reg_n_83),
        .O(xq_reg_0_63_0_2_i_212_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_213
       (.I0(norm_prod_reg__0_n_95),
        .I1(\norm_prod_reg_n_0_[10] ),
        .O(xq_reg_0_63_0_2_i_213_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_214
       (.I0(norm_prod_reg__0_n_96),
        .I1(\norm_prod_reg_n_0_[9] ),
        .O(xq_reg_0_63_0_2_i_214_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_215
       (.I0(norm_prod_reg__0_n_97),
        .I1(\norm_prod_reg_n_0_[8] ),
        .O(xq_reg_0_63_0_2_i_215_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    xq_reg_0_63_0_2_i_216
       (.I0(norm_prod_reg__0_n_98),
        .I1(\norm_prod_reg_n_0_[7] ),
        .O(xq_reg_0_63_0_2_i_216_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 xq_reg_0_63_0_2_i_217
       (.CI(xq_reg_0_63_0_2_i_239_n_0),
        .CO({xq_reg_0_63_0_2_i_217_n_0,xq_reg_0_63_0_2_i_217_n_1,xq_reg_0_63_0_2_i_217_n_2,xq_reg_0_63_0_2_i_217_n_3}),
        .CYINIT(1'b0),
        .DI({xq_reg_0_63_0_2_i_240_n_0,xq_reg_0_63_0_2_i_241_n_0,xq_reg_0_63_0_2_i_242_n_0,xq_reg_0_63_0_2_i_243_n_0}),
        .O(NLW_xq_reg_0_63_0_2_i_217_O_UNCONNECTED[3:0]),
        .S({xq_reg_0_63_0_2_i_244_n_0,xq_reg_0_63_0_2_i_245_n_0,xq_reg_0_63_0_2_i_246_n_0,xq_reg_0_63_0_2_i_247_n_0}));
  LUT6 #(
    .INIT(64'hFEFBFEEABAFBBAEA)) 
    xq_reg_0_63_0_2_i_218
       (.I0(xq_reg_0_63_0_2_i_248_n_0),
        .I1(\n_in_r_reg_n_0_[0] ),
        .I2(xq_reg_0_63_0_2_i_233_n_0),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_249_n_0),
        .I5(xq_reg_0_63_0_2_i_231_n_0),
        .O(xq_reg_0_63_0_2_i_218_n_0));
  LUT6 #(
    .INIT(64'hFEFBFEEABAFBBAEA)) 
    xq_reg_0_63_0_2_i_219
       (.I0(xq_reg_0_63_0_2_i_250_n_0),
        .I1(\n_in_r_reg_n_0_[0] ),
        .I2(xq_reg_0_63_0_2_i_249_n_0),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_251_n_0),
        .I5(xq_reg_0_63_0_2_i_233_n_0),
        .O(xq_reg_0_63_0_2_i_219_n_0));
  LUT6 #(
    .INIT(64'h00000000000B000A)) 
    xq_reg_0_63_0_2_i_22
       (.I0(xq_reg_0_63_0_2_i_31_n_4),
        .I1(\n_in_r_reg_n_0_[0] ),
        .I2(\n_in_r_reg_n_0_[1] ),
        .I3(xq_reg_0_63_0_2_i_54_n_0),
        .I4(xq_reg_0_63_0_2_i_31_n_5),
        .I5(xq_reg_0_63_0_2_i_55_n_0),
        .O(xq_reg_0_63_0_2_i_22_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFFAFA0FC0C)) 
    xq_reg_0_63_0_2_i_220
       (.I0(xq_reg_0_63_0_2_i_249_n_0),
        .I1(xq_reg_0_63_0_2_i_252_n_0),
        .I2(\n_in_r_reg_n_0_[1] ),
        .I3(xq_reg_0_63_0_2_i_251_n_0),
        .I4(\n_in_r_reg_n_0_[0] ),
        .I5(xq_reg_0_63_0_2_i_253_n_0),
        .O(xq_reg_0_63_0_2_i_220_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFB8B8FFB8B8)) 
    xq_reg_0_63_0_2_i_221
       (.I0(xq_reg_0_63_0_2_i_254_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_255_n_0),
        .I3(\n_in_r_reg_n_0_[0] ),
        .I4(xq_reg_0_63_0_2_i_256_n_0),
        .I5(xq_reg_0_63_0_2_i_257_n_0),
        .O(xq_reg_0_63_0_2_i_221_n_0));
  LUT6 #(
    .INIT(64'h00000000505F03F3)) 
    xq_reg_0_63_0_2_i_222
       (.I0(xq_reg_0_63_0_2_i_231_n_0),
        .I1(xq_reg_0_63_0_2_i_249_n_0),
        .I2(\n_in_r_reg_n_0_[1] ),
        .I3(xq_reg_0_63_0_2_i_233_n_0),
        .I4(\n_in_r_reg_n_0_[0] ),
        .I5(xq_reg_0_63_0_2_i_248_n_0),
        .O(xq_reg_0_63_0_2_i_222_n_0));
  LUT6 #(
    .INIT(64'h00000000505F03F3)) 
    xq_reg_0_63_0_2_i_223
       (.I0(xq_reg_0_63_0_2_i_233_n_0),
        .I1(xq_reg_0_63_0_2_i_251_n_0),
        .I2(\n_in_r_reg_n_0_[1] ),
        .I3(xq_reg_0_63_0_2_i_249_n_0),
        .I4(\n_in_r_reg_n_0_[0] ),
        .I5(xq_reg_0_63_0_2_i_250_n_0),
        .O(xq_reg_0_63_0_2_i_223_n_0));
  LUT6 #(
    .INIT(64'h00000000505F03F3)) 
    xq_reg_0_63_0_2_i_224
       (.I0(xq_reg_0_63_0_2_i_249_n_0),
        .I1(xq_reg_0_63_0_2_i_252_n_0),
        .I2(\n_in_r_reg_n_0_[1] ),
        .I3(xq_reg_0_63_0_2_i_251_n_0),
        .I4(\n_in_r_reg_n_0_[0] ),
        .I5(xq_reg_0_63_0_2_i_253_n_0),
        .O(xq_reg_0_63_0_2_i_224_n_0));
  LUT6 #(
    .INIT(64'h0047004700004747)) 
    xq_reg_0_63_0_2_i_225
       (.I0(xq_reg_0_63_0_2_i_254_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_255_n_0),
        .I3(xq_reg_0_63_0_2_i_257_n_0),
        .I4(xq_reg_0_63_0_2_i_256_n_0),
        .I5(\n_in_r_reg_n_0_[0] ),
        .O(xq_reg_0_63_0_2_i_225_n_0));
  LUT6 #(
    .INIT(64'h0000000030BB3088)) 
    xq_reg_0_63_0_2_i_226
       (.I0(xq_reg_0_63_0_2_i_43_n_7),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(xq_reg_0_63_0_2_i_31_n_7),
        .I3(\n_in_r_reg_n_0_[3] ),
        .I4(xq_reg_0_63_0_2_i_35_n_7),
        .I5(xq_reg_0_63_0_2_i_54_n_0),
        .O(xq_reg_0_63_0_2_i_226_n_0));
  (* SOFT_HLUTNM = "soft_lutpair99" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    xq_reg_0_63_0_2_i_227
       (.I0(xq_reg_0_63_0_2_i_236_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_258_n_0),
        .O(xq_reg_0_63_0_2_i_227_n_0));
  (* SOFT_HLUTNM = "soft_lutpair99" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    xq_reg_0_63_0_2_i_228
       (.I0(xq_reg_0_63_0_2_i_258_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_259_n_0),
        .O(xq_reg_0_63_0_2_i_228_n_0));
  LUT6 #(
    .INIT(64'h00B8FFFF00B80000)) 
    xq_reg_0_63_0_2_i_229
       (.I0(xq_reg_0_63_0_2_i_31_n_5),
        .I1(\n_in_r_reg_n_0_[3] ),
        .I2(xq_reg_0_63_0_2_i_35_n_5),
        .I3(xq_reg_0_63_0_2_i_54_n_0),
        .I4(\n_in_r_reg_n_0_[2] ),
        .I5(xq_reg_0_63_0_2_i_260_n_0),
        .O(xq_reg_0_63_0_2_i_229_n_0));
  LUT6 #(
    .INIT(64'hFFFAFFFAFFFFFFFB)) 
    xq_reg_0_63_0_2_i_23
       (.I0(xq_reg_0_63_0_2_i_55_n_0),
        .I1(xq_reg_0_63_0_2_i_31_n_5),
        .I2(xq_reg_0_63_0_2_i_54_n_0),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(\n_in_r_reg_n_0_[0] ),
        .I5(xq_reg_0_63_0_2_i_31_n_4),
        .O(xq_reg_0_63_0_2_i_23_n_0));
  (* SOFT_HLUTNM = "soft_lutpair100" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    xq_reg_0_63_0_2_i_230
       (.I0(xq_reg_0_63_0_2_i_259_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_261_n_0),
        .O(xq_reg_0_63_0_2_i_230_n_0));
  LUT6 #(
    .INIT(64'h00B8FFFF00B80000)) 
    xq_reg_0_63_0_2_i_231
       (.I0(xq_reg_0_63_0_2_i_31_n_7),
        .I1(\n_in_r_reg_n_0_[3] ),
        .I2(xq_reg_0_63_0_2_i_35_n_7),
        .I3(xq_reg_0_63_0_2_i_54_n_0),
        .I4(\n_in_r_reg_n_0_[2] ),
        .I5(xq_reg_0_63_0_2_i_262_n_0),
        .O(xq_reg_0_63_0_2_i_231_n_0));
  (* SOFT_HLUTNM = "soft_lutpair100" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    xq_reg_0_63_0_2_i_232
       (.I0(xq_reg_0_63_0_2_i_261_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_263_n_0),
        .O(xq_reg_0_63_0_2_i_232_n_0));
  LUT6 #(
    .INIT(64'h00B8FFFF00B80000)) 
    xq_reg_0_63_0_2_i_233
       (.I0(xq_reg_0_63_0_2_i_43_n_5),
        .I1(\n_in_r_reg_n_0_[3] ),
        .I2(xq_reg_0_63_0_2_i_39_n_5),
        .I3(xq_reg_0_63_0_2_i_54_n_0),
        .I4(\n_in_r_reg_n_0_[2] ),
        .I5(xq_reg_0_63_0_2_i_264_n_0),
        .O(xq_reg_0_63_0_2_i_233_n_0));
  LUT6 #(
    .INIT(64'h0000000000002320)) 
    xq_reg_0_63_0_2_i_234
       (.I0(xq_reg_0_63_0_2_i_31_n_4),
        .I1(\n_in_r_reg_n_0_[3] ),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_43_n_4),
        .I4(\n_in_r_reg_n_0_[4] ),
        .I5(\n_in_r_reg_n_0_[5] ),
        .O(xq_reg_0_63_0_2_i_234_n_0));
  LUT6 #(
    .INIT(64'h0000000000002320)) 
    xq_reg_0_63_0_2_i_235
       (.I0(xq_reg_0_63_0_2_i_31_n_6),
        .I1(\n_in_r_reg_n_0_[3] ),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_43_n_6),
        .I4(\n_in_r_reg_n_0_[4] ),
        .I5(\n_in_r_reg_n_0_[5] ),
        .O(xq_reg_0_63_0_2_i_235_n_0));
  LUT6 #(
    .INIT(64'h0000000030BB3088)) 
    xq_reg_0_63_0_2_i_236
       (.I0(xq_reg_0_63_0_2_i_43_n_4),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(xq_reg_0_63_0_2_i_31_n_4),
        .I3(\n_in_r_reg_n_0_[3] ),
        .I4(xq_reg_0_63_0_2_i_35_n_4),
        .I5(xq_reg_0_63_0_2_i_54_n_0),
        .O(xq_reg_0_63_0_2_i_236_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    xq_reg_0_63_0_2_i_237
       (.I0(\n_in_r_reg_n_0_[12] ),
        .I1(\n_in_r_reg_n_0_[13] ),
        .I2(xq_reg_0_63_0_2_i_265_n_0),
        .I3(xq_reg_0_63_0_2_i_266_n_0),
        .I4(xq_reg_0_63_0_2_i_267_n_0),
        .I5(xq_reg_0_63_0_2_i_268_n_0),
        .O(xq_reg_0_63_0_2_i_237_n_0));
  (* SOFT_HLUTNM = "soft_lutpair53" *) 
  LUT2 #(
    .INIT(4'hE)) 
    xq_reg_0_63_0_2_i_238
       (.I0(\n_in_r_reg_n_0_[0] ),
        .I1(\n_in_r_reg_n_0_[1] ),
        .O(xq_reg_0_63_0_2_i_238_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 xq_reg_0_63_0_2_i_239
       (.CI(xq_reg_0_63_0_2_i_269_n_0),
        .CO({xq_reg_0_63_0_2_i_239_n_0,xq_reg_0_63_0_2_i_239_n_1,xq_reg_0_63_0_2_i_239_n_2,xq_reg_0_63_0_2_i_239_n_3}),
        .CYINIT(1'b0),
        .DI({xq_reg_0_63_0_2_i_270_n_0,xq_reg_0_63_0_2_i_271_n_0,xq_reg_0_63_0_2_i_272_n_0,xq_reg_0_63_0_2_i_273_n_0}),
        .O(NLW_xq_reg_0_63_0_2_i_239_O_UNCONNECTED[3:0]),
        .S({xq_reg_0_63_0_2_i_274_n_0,xq_reg_0_63_0_2_i_275_n_0,xq_reg_0_63_0_2_i_276_n_0,xq_reg_0_63_0_2_i_277_n_0}));
  LUT6 #(
    .INIT(64'hFC0CFAFAFC0C0A0A)) 
    xq_reg_0_63_0_2_i_24
       (.I0(xq_reg_0_63_0_2_i_56_n_0),
        .I1(xq_reg_0_63_0_2_i_57_n_0),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_58_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(xq_reg_0_63_0_2_i_59_n_0),
        .O(xq_reg_0_63_0_2_i_24_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFB8B8FFB8B8)) 
    xq_reg_0_63_0_2_i_240
       (.I0(xq_reg_0_63_0_2_i_255_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_278_n_0),
        .I3(\n_in_r_reg_n_0_[0] ),
        .I4(xq_reg_0_63_0_2_i_279_n_0),
        .I5(xq_reg_0_63_0_2_i_256_n_0),
        .O(xq_reg_0_63_0_2_i_240_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFB8B8FFB8B8)) 
    xq_reg_0_63_0_2_i_241
       (.I0(xq_reg_0_63_0_2_i_278_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_280_n_0),
        .I3(\n_in_r_reg_n_0_[0] ),
        .I4(xq_reg_0_63_0_2_i_281_n_0),
        .I5(xq_reg_0_63_0_2_i_279_n_0),
        .O(xq_reg_0_63_0_2_i_241_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFB8B8FFB8B8)) 
    xq_reg_0_63_0_2_i_242
       (.I0(xq_reg_0_63_0_2_i_280_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_282_n_0),
        .I3(\n_in_r_reg_n_0_[0] ),
        .I4(xq_reg_0_63_0_2_i_283_n_0),
        .I5(xq_reg_0_63_0_2_i_281_n_0),
        .O(xq_reg_0_63_0_2_i_242_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFB8B8FFB8B8)) 
    xq_reg_0_63_0_2_i_243
       (.I0(xq_reg_0_63_0_2_i_282_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_284_n_0),
        .I3(\n_in_r_reg_n_0_[0] ),
        .I4(xq_reg_0_63_0_2_i_285_n_0),
        .I5(xq_reg_0_63_0_2_i_283_n_0),
        .O(xq_reg_0_63_0_2_i_243_n_0));
  LUT6 #(
    .INIT(64'h0047004700004747)) 
    xq_reg_0_63_0_2_i_244
       (.I0(xq_reg_0_63_0_2_i_255_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_278_n_0),
        .I3(xq_reg_0_63_0_2_i_256_n_0),
        .I4(xq_reg_0_63_0_2_i_279_n_0),
        .I5(\n_in_r_reg_n_0_[0] ),
        .O(xq_reg_0_63_0_2_i_244_n_0));
  LUT6 #(
    .INIT(64'h0047004700004747)) 
    xq_reg_0_63_0_2_i_245
       (.I0(xq_reg_0_63_0_2_i_278_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_280_n_0),
        .I3(xq_reg_0_63_0_2_i_279_n_0),
        .I4(xq_reg_0_63_0_2_i_281_n_0),
        .I5(\n_in_r_reg_n_0_[0] ),
        .O(xq_reg_0_63_0_2_i_245_n_0));
  LUT6 #(
    .INIT(64'h0047004700004747)) 
    xq_reg_0_63_0_2_i_246
       (.I0(xq_reg_0_63_0_2_i_280_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_282_n_0),
        .I3(xq_reg_0_63_0_2_i_281_n_0),
        .I4(xq_reg_0_63_0_2_i_283_n_0),
        .I5(\n_in_r_reg_n_0_[0] ),
        .O(xq_reg_0_63_0_2_i_246_n_0));
  LUT6 #(
    .INIT(64'h0047004700004747)) 
    xq_reg_0_63_0_2_i_247
       (.I0(xq_reg_0_63_0_2_i_282_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_284_n_0),
        .I3(xq_reg_0_63_0_2_i_283_n_0),
        .I4(xq_reg_0_63_0_2_i_285_n_0),
        .I5(\n_in_r_reg_n_0_[0] ),
        .O(xq_reg_0_63_0_2_i_247_n_0));
  (* SOFT_HLUTNM = "soft_lutpair101" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    xq_reg_0_63_0_2_i_248
       (.I0(xq_reg_0_63_0_2_i_263_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_286_n_0),
        .O(xq_reg_0_63_0_2_i_248_n_0));
  LUT6 #(
    .INIT(64'h00B8FFFF00B80000)) 
    xq_reg_0_63_0_2_i_249
       (.I0(xq_reg_0_63_0_2_i_43_n_7),
        .I1(\n_in_r_reg_n_0_[3] ),
        .I2(xq_reg_0_63_0_2_i_39_n_7),
        .I3(xq_reg_0_63_0_2_i_54_n_0),
        .I4(\n_in_r_reg_n_0_[2] ),
        .I5(xq_reg_0_63_0_2_i_287_n_0),
        .O(xq_reg_0_63_0_2_i_249_n_0));
  LUT4 #(
    .INIT(16'h0B08)) 
    xq_reg_0_63_0_2_i_25
       (.I0(xq_reg_0_63_0_2_i_60_n_0),
        .I1(\n_in_r_reg_n_0_[3] ),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_61_n_0),
        .O(xq_reg_0_63_0_2_i_25_n_0));
  LUT5 #(
    .INIT(32'hFF00B8B8)) 
    xq_reg_0_63_0_2_i_250
       (.I0(xq_reg_0_63_0_2_i_288_n_0),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(xq_reg_0_63_0_2_i_289_n_0),
        .I3(xq_reg_0_63_0_2_i_286_n_0),
        .I4(\n_in_r_reg_n_0_[1] ),
        .O(xq_reg_0_63_0_2_i_250_n_0));
  (* SOFT_HLUTNM = "soft_lutpair102" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    xq_reg_0_63_0_2_i_251
       (.I0(xq_reg_0_63_0_2_i_264_n_0),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(xq_reg_0_63_0_2_i_290_n_0),
        .O(xq_reg_0_63_0_2_i_251_n_0));
  LUT3 #(
    .INIT(8'hB8)) 
    xq_reg_0_63_0_2_i_252
       (.I0(xq_reg_0_63_0_2_i_287_n_0),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(xq_reg_0_63_0_2_i_291_n_0),
        .O(xq_reg_0_63_0_2_i_252_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    xq_reg_0_63_0_2_i_253
       (.I0(xq_reg_0_63_0_2_i_288_n_0),
        .I1(xq_reg_0_63_0_2_i_289_n_0),
        .I2(\n_in_r_reg_n_0_[1] ),
        .I3(xq_reg_0_63_0_2_i_292_n_0),
        .I4(\n_in_r_reg_n_0_[2] ),
        .I5(xq_reg_0_63_0_2_i_293_n_0),
        .O(xq_reg_0_63_0_2_i_253_n_0));
  (* SOFT_HLUTNM = "soft_lutpair102" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    xq_reg_0_63_0_2_i_254
       (.I0(xq_reg_0_63_0_2_i_292_n_0),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(xq_reg_0_63_0_2_i_293_n_0),
        .O(xq_reg_0_63_0_2_i_254_n_0));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT5 #(
    .INIT(32'hB8BBB888)) 
    xq_reg_0_63_0_2_i_255
       (.I0(xq_reg_0_63_0_2_i_289_n_0),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(xq_reg_0_63_0_2_i_294_n_0),
        .I3(\n_in_r_reg_n_0_[3] ),
        .I4(xq_reg_0_63_0_2_i_295_n_0),
        .O(xq_reg_0_63_0_2_i_255_n_0));
  (* SOFT_HLUTNM = "soft_lutpair101" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    xq_reg_0_63_0_2_i_256
       (.I0(xq_reg_0_63_0_2_i_252_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_296_n_0),
        .O(xq_reg_0_63_0_2_i_256_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    xq_reg_0_63_0_2_i_257
       (.I0(xq_reg_0_63_0_2_i_264_n_0),
        .I1(xq_reg_0_63_0_2_i_290_n_0),
        .I2(\n_in_r_reg_n_0_[1] ),
        .I3(xq_reg_0_63_0_2_i_287_n_0),
        .I4(\n_in_r_reg_n_0_[2] ),
        .I5(xq_reg_0_63_0_2_i_291_n_0),
        .O(xq_reg_0_63_0_2_i_257_n_0));
  LUT6 #(
    .INIT(64'h0000000030BB3088)) 
    xq_reg_0_63_0_2_i_258
       (.I0(xq_reg_0_63_0_2_i_43_n_6),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(xq_reg_0_63_0_2_i_31_n_6),
        .I3(\n_in_r_reg_n_0_[3] ),
        .I4(xq_reg_0_63_0_2_i_35_n_6),
        .I5(xq_reg_0_63_0_2_i_54_n_0),
        .O(xq_reg_0_63_0_2_i_258_n_0));
  LUT6 #(
    .INIT(64'h00B8FFFF00B80000)) 
    xq_reg_0_63_0_2_i_259
       (.I0(xq_reg_0_63_0_2_i_31_n_4),
        .I1(\n_in_r_reg_n_0_[3] ),
        .I2(xq_reg_0_63_0_2_i_35_n_4),
        .I3(xq_reg_0_63_0_2_i_54_n_0),
        .I4(\n_in_r_reg_n_0_[2] ),
        .I5(xq_reg_0_63_0_2_i_297_n_0),
        .O(xq_reg_0_63_0_2_i_259_n_0));
  LUT3 #(
    .INIT(8'hB8)) 
    xq_reg_0_63_0_2_i_26
       (.I0(xq_reg_0_63_0_2_i_62_n_0),
        .I1(\n_in_r_reg_n_0_[3] ),
        .I2(xq_reg_0_63_0_2_i_63_n_0),
        .O(xq_reg_0_63_0_2_i_26_n_0));
  LUT5 #(
    .INIT(32'h000000B8)) 
    xq_reg_0_63_0_2_i_260
       (.I0(xq_reg_0_63_0_2_i_43_n_5),
        .I1(\n_in_r_reg_n_0_[3] ),
        .I2(xq_reg_0_63_0_2_i_39_n_5),
        .I3(\n_in_r_reg_n_0_[4] ),
        .I4(\n_in_r_reg_n_0_[5] ),
        .O(xq_reg_0_63_0_2_i_260_n_0));
  LUT6 #(
    .INIT(64'h00B8FFFF00B80000)) 
    xq_reg_0_63_0_2_i_261
       (.I0(xq_reg_0_63_0_2_i_31_n_6),
        .I1(\n_in_r_reg_n_0_[3] ),
        .I2(xq_reg_0_63_0_2_i_35_n_6),
        .I3(xq_reg_0_63_0_2_i_54_n_0),
        .I4(\n_in_r_reg_n_0_[2] ),
        .I5(xq_reg_0_63_0_2_i_298_n_0),
        .O(xq_reg_0_63_0_2_i_261_n_0));
  LUT5 #(
    .INIT(32'h000000B8)) 
    xq_reg_0_63_0_2_i_262
       (.I0(xq_reg_0_63_0_2_i_43_n_7),
        .I1(\n_in_r_reg_n_0_[3] ),
        .I2(xq_reg_0_63_0_2_i_39_n_7),
        .I3(\n_in_r_reg_n_0_[4] ),
        .I4(\n_in_r_reg_n_0_[5] ),
        .O(xq_reg_0_63_0_2_i_262_n_0));
  LUT6 #(
    .INIT(64'h00B8FFFF00B80000)) 
    xq_reg_0_63_0_2_i_263
       (.I0(xq_reg_0_63_0_2_i_43_n_4),
        .I1(\n_in_r_reg_n_0_[3] ),
        .I2(xq_reg_0_63_0_2_i_39_n_4),
        .I3(xq_reg_0_63_0_2_i_54_n_0),
        .I4(\n_in_r_reg_n_0_[2] ),
        .I5(xq_reg_0_63_0_2_i_288_n_0),
        .O(xq_reg_0_63_0_2_i_263_n_0));
  LUT6 #(
    .INIT(64'h003000BB00300088)) 
    xq_reg_0_63_0_2_i_264
       (.I0(xq_reg_0_63_0_2_i_35_n_5),
        .I1(\n_in_r_reg_n_0_[3] ),
        .I2(xq_reg_0_63_0_2_i_31_n_5),
        .I3(\n_in_r_reg_n_0_[5] ),
        .I4(\n_in_r_reg_n_0_[4] ),
        .I5(xq_reg_0_63_0_2_i_30_n_5),
        .O(xq_reg_0_63_0_2_i_264_n_0));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    xq_reg_0_63_0_2_i_265
       (.I0(\n_in_r_reg_n_0_[27] ),
        .I1(\n_in_r_reg_n_0_[26] ),
        .I2(\n_in_r_reg_n_0_[25] ),
        .I3(\n_in_r_reg_n_0_[24] ),
        .I4(xq_reg_0_63_0_2_i_299_n_0),
        .O(xq_reg_0_63_0_2_i_265_n_0));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    xq_reg_0_63_0_2_i_266
       (.I0(\n_in_r_reg_n_0_[19] ),
        .I1(\n_in_r_reg_n_0_[18] ),
        .I2(\n_in_r_reg_n_0_[17] ),
        .I3(\n_in_r_reg_n_0_[16] ),
        .I4(xq_reg_0_63_0_2_i_300_n_0),
        .O(xq_reg_0_63_0_2_i_266_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    xq_reg_0_63_0_2_i_267
       (.I0(\n_in_r_reg_n_0_[5] ),
        .I1(\n_in_r_reg_n_0_[4] ),
        .I2(\n_in_r_reg_n_0_[3] ),
        .I3(\n_in_r_reg_n_0_[2] ),
        .I4(\n_in_r_reg_n_0_[6] ),
        .I5(\n_in_r_reg_n_0_[7] ),
        .O(xq_reg_0_63_0_2_i_267_n_0));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    xq_reg_0_63_0_2_i_268
       (.I0(\n_in_r_reg_n_0_[11] ),
        .I1(\n_in_r_reg_n_0_[10] ),
        .I2(\n_in_r_reg_n_0_[9] ),
        .I3(\n_in_r_reg_n_0_[8] ),
        .I4(xq_reg_0_63_0_2_i_301_n_0),
        .O(xq_reg_0_63_0_2_i_268_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 xq_reg_0_63_0_2_i_269
       (.CI(xq_reg_0_63_0_2_i_302_n_0),
        .CO({xq_reg_0_63_0_2_i_269_n_0,xq_reg_0_63_0_2_i_269_n_1,xq_reg_0_63_0_2_i_269_n_2,xq_reg_0_63_0_2_i_269_n_3}),
        .CYINIT(1'b0),
        .DI({xq_reg_0_63_0_2_i_303_n_0,xq_reg_0_63_0_2_i_304_n_0,xq_reg_0_63_0_2_i_305_n_0,xq_reg_0_63_0_2_i_306_n_0}),
        .O(NLW_xq_reg_0_63_0_2_i_269_O_UNCONNECTED[3:0]),
        .S({xq_reg_0_63_0_2_i_307_n_0,xq_reg_0_63_0_2_i_308_n_0,xq_reg_0_63_0_2_i_309_n_0,xq_reg_0_63_0_2_i_310_n_0}));
  (* SOFT_HLUTNM = "soft_lutpair45" *) 
  LUT5 #(
    .INIT(32'h30BB3088)) 
    xq_reg_0_63_0_2_i_27
       (.I0(xq_reg_0_63_0_2_i_38_n_7),
        .I1(\n_in_r_reg_n_0_[4] ),
        .I2(xq_reg_0_63_0_2_i_39_n_7),
        .I3(\n_in_r_reg_n_0_[5] ),
        .I4(xq_reg_0_63_0_2_i_40_n_7),
        .O(xq_reg_0_63_0_2_i_27_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFB8B8FFB8B8)) 
    xq_reg_0_63_0_2_i_270
       (.I0(xq_reg_0_63_0_2_i_284_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_311_n_0),
        .I3(\n_in_r_reg_n_0_[0] ),
        .I4(xq_reg_0_63_0_2_i_312_n_0),
        .I5(xq_reg_0_63_0_2_i_285_n_0),
        .O(xq_reg_0_63_0_2_i_270_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFB8B8FFB8B8)) 
    xq_reg_0_63_0_2_i_271
       (.I0(xq_reg_0_63_0_2_i_311_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_313_n_0),
        .I3(\n_in_r_reg_n_0_[0] ),
        .I4(xq_reg_0_63_0_2_i_314_n_0),
        .I5(xq_reg_0_63_0_2_i_312_n_0),
        .O(xq_reg_0_63_0_2_i_271_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFB8B8FFB8B8)) 
    xq_reg_0_63_0_2_i_272
       (.I0(xq_reg_0_63_0_2_i_313_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_315_n_0),
        .I3(\n_in_r_reg_n_0_[0] ),
        .I4(xq_reg_0_63_0_2_i_316_n_0),
        .I5(xq_reg_0_63_0_2_i_314_n_0),
        .O(xq_reg_0_63_0_2_i_272_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFB8B8FFB8B8)) 
    xq_reg_0_63_0_2_i_273
       (.I0(xq_reg_0_63_0_2_i_315_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_317_n_0),
        .I3(\n_in_r_reg_n_0_[0] ),
        .I4(xq_reg_0_63_0_2_i_318_n_0),
        .I5(xq_reg_0_63_0_2_i_316_n_0),
        .O(xq_reg_0_63_0_2_i_273_n_0));
  LUT6 #(
    .INIT(64'h0047004700004747)) 
    xq_reg_0_63_0_2_i_274
       (.I0(xq_reg_0_63_0_2_i_284_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_311_n_0),
        .I3(xq_reg_0_63_0_2_i_285_n_0),
        .I4(xq_reg_0_63_0_2_i_312_n_0),
        .I5(\n_in_r_reg_n_0_[0] ),
        .O(xq_reg_0_63_0_2_i_274_n_0));
  LUT6 #(
    .INIT(64'h0047004700004747)) 
    xq_reg_0_63_0_2_i_275
       (.I0(xq_reg_0_63_0_2_i_311_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_313_n_0),
        .I3(xq_reg_0_63_0_2_i_312_n_0),
        .I4(xq_reg_0_63_0_2_i_314_n_0),
        .I5(\n_in_r_reg_n_0_[0] ),
        .O(xq_reg_0_63_0_2_i_275_n_0));
  LUT6 #(
    .INIT(64'h0047004700004747)) 
    xq_reg_0_63_0_2_i_276
       (.I0(xq_reg_0_63_0_2_i_313_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_315_n_0),
        .I3(xq_reg_0_63_0_2_i_314_n_0),
        .I4(xq_reg_0_63_0_2_i_316_n_0),
        .I5(\n_in_r_reg_n_0_[0] ),
        .O(xq_reg_0_63_0_2_i_276_n_0));
  LUT6 #(
    .INIT(64'h0047004700004747)) 
    xq_reg_0_63_0_2_i_277
       (.I0(xq_reg_0_63_0_2_i_315_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_317_n_0),
        .I3(xq_reg_0_63_0_2_i_316_n_0),
        .I4(xq_reg_0_63_0_2_i_318_n_0),
        .I5(\n_in_r_reg_n_0_[0] ),
        .O(xq_reg_0_63_0_2_i_277_n_0));
  LUT5 #(
    .INIT(32'hB8BBB888)) 
    xq_reg_0_63_0_2_i_278
       (.I0(xq_reg_0_63_0_2_i_293_n_0),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(xq_reg_0_63_0_2_i_319_n_0),
        .I3(\n_in_r_reg_n_0_[3] ),
        .I4(xq_reg_0_63_0_2_i_320_n_0),
        .O(xq_reg_0_63_0_2_i_278_n_0));
  (* SOFT_HLUTNM = "soft_lutpair103" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    xq_reg_0_63_0_2_i_279
       (.I0(xq_reg_0_63_0_2_i_296_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_321_n_0),
        .O(xq_reg_0_63_0_2_i_279_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    xq_reg_0_63_0_2_i_28
       (.I0(xq_reg_0_63_0_2_i_64_n_0),
        .I1(xq_reg_0_63_0_2_i_60_n_0),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_62_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(xq_reg_0_63_0_2_i_63_n_0),
        .O(xq_reg_0_63_0_2_i_28_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    xq_reg_0_63_0_2_i_280
       (.I0(xq_reg_0_63_0_2_i_294_n_0),
        .I1(xq_reg_0_63_0_2_i_295_n_0),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_322_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(xq_reg_0_63_0_2_i_323_n_0),
        .O(xq_reg_0_63_0_2_i_280_n_0));
  (* SOFT_HLUTNM = "soft_lutpair103" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    xq_reg_0_63_0_2_i_281
       (.I0(xq_reg_0_63_0_2_i_321_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_324_n_0),
        .O(xq_reg_0_63_0_2_i_281_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    xq_reg_0_63_0_2_i_282
       (.I0(xq_reg_0_63_0_2_i_319_n_0),
        .I1(xq_reg_0_63_0_2_i_320_n_0),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_325_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(xq_reg_0_63_0_2_i_326_n_0),
        .O(xq_reg_0_63_0_2_i_282_n_0));
  (* SOFT_HLUTNM = "soft_lutpair104" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    xq_reg_0_63_0_2_i_283
       (.I0(xq_reg_0_63_0_2_i_324_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_327_n_0),
        .O(xq_reg_0_63_0_2_i_283_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    xq_reg_0_63_0_2_i_284
       (.I0(xq_reg_0_63_0_2_i_322_n_0),
        .I1(xq_reg_0_63_0_2_i_323_n_0),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_295_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(xq_reg_0_63_0_2_i_328_n_0),
        .O(xq_reg_0_63_0_2_i_284_n_0));
  (* SOFT_HLUTNM = "soft_lutpair104" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    xq_reg_0_63_0_2_i_285
       (.I0(xq_reg_0_63_0_2_i_327_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_329_n_0),
        .O(xq_reg_0_63_0_2_i_285_n_0));
  LUT6 #(
    .INIT(64'h00B8FFFF00B80000)) 
    xq_reg_0_63_0_2_i_286
       (.I0(xq_reg_0_63_0_2_i_43_n_6),
        .I1(\n_in_r_reg_n_0_[3] ),
        .I2(xq_reg_0_63_0_2_i_39_n_6),
        .I3(xq_reg_0_63_0_2_i_54_n_0),
        .I4(\n_in_r_reg_n_0_[2] ),
        .I5(xq_reg_0_63_0_2_i_292_n_0),
        .O(xq_reg_0_63_0_2_i_286_n_0));
  LUT6 #(
    .INIT(64'h003000BB00300088)) 
    xq_reg_0_63_0_2_i_287
       (.I0(xq_reg_0_63_0_2_i_35_n_7),
        .I1(\n_in_r_reg_n_0_[3] ),
        .I2(xq_reg_0_63_0_2_i_31_n_7),
        .I3(\n_in_r_reg_n_0_[5] ),
        .I4(\n_in_r_reg_n_0_[4] ),
        .I5(xq_reg_0_63_0_2_i_30_n_7),
        .O(xq_reg_0_63_0_2_i_287_n_0));
  LUT6 #(
    .INIT(64'h003000BB00300088)) 
    xq_reg_0_63_0_2_i_288
       (.I0(xq_reg_0_63_0_2_i_35_n_4),
        .I1(\n_in_r_reg_n_0_[3] ),
        .I2(xq_reg_0_63_0_2_i_31_n_4),
        .I3(\n_in_r_reg_n_0_[5] ),
        .I4(\n_in_r_reg_n_0_[4] ),
        .I5(xq_reg_0_63_0_2_i_30_n_4),
        .O(xq_reg_0_63_0_2_i_288_n_0));
  LUT6 #(
    .INIT(64'h003000BB00300088)) 
    xq_reg_0_63_0_2_i_289
       (.I0(xq_reg_0_63_0_2_i_39_n_4),
        .I1(\n_in_r_reg_n_0_[3] ),
        .I2(xq_reg_0_63_0_2_i_43_n_4),
        .I3(\n_in_r_reg_n_0_[5] ),
        .I4(\n_in_r_reg_n_0_[4] ),
        .I5(xq_reg_0_63_0_2_i_42_n_4),
        .O(xq_reg_0_63_0_2_i_289_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 xq_reg_0_63_0_2_i_29
       (.CI(xq_reg_0_63_0_2_i_41_n_0),
        .CO({xq_reg_0_63_0_2_i_29_n_0,xq_reg_0_63_0_2_i_29_n_1,xq_reg_0_63_0_2_i_29_n_2,xq_reg_0_63_0_2_i_29_n_3}),
        .CYINIT(1'b0),
        .DI({\norm_prod_reg[15]__0_n_0 ,\norm_prod_reg[14]__0_n_0 ,\norm_prod_reg[13]__0_n_0 ,\norm_prod_reg[12]__0_n_0 }),
        .O({xq_reg_0_63_0_2_i_29_n_4,xq_reg_0_63_0_2_i_29_n_5,xq_reg_0_63_0_2_i_29_n_6,xq_reg_0_63_0_2_i_29_n_7}),
        .S({xq_reg_0_63_0_2_i_65_n_0,xq_reg_0_63_0_2_i_66_n_0,xq_reg_0_63_0_2_i_67_n_0,xq_reg_0_63_0_2_i_68_n_0}));
  LUT6 #(
    .INIT(64'h003000BB00300088)) 
    xq_reg_0_63_0_2_i_290
       (.I0(xq_reg_0_63_0_2_i_39_n_5),
        .I1(\n_in_r_reg_n_0_[3] ),
        .I2(xq_reg_0_63_0_2_i_43_n_5),
        .I3(\n_in_r_reg_n_0_[5] ),
        .I4(\n_in_r_reg_n_0_[4] ),
        .I5(xq_reg_0_63_0_2_i_42_n_5),
        .O(xq_reg_0_63_0_2_i_290_n_0));
  LUT6 #(
    .INIT(64'h003000BB00300088)) 
    xq_reg_0_63_0_2_i_291
       (.I0(xq_reg_0_63_0_2_i_39_n_7),
        .I1(\n_in_r_reg_n_0_[3] ),
        .I2(xq_reg_0_63_0_2_i_43_n_7),
        .I3(\n_in_r_reg_n_0_[5] ),
        .I4(\n_in_r_reg_n_0_[4] ),
        .I5(xq_reg_0_63_0_2_i_42_n_7),
        .O(xq_reg_0_63_0_2_i_291_n_0));
  LUT6 #(
    .INIT(64'h003000BB00300088)) 
    xq_reg_0_63_0_2_i_292
       (.I0(xq_reg_0_63_0_2_i_35_n_6),
        .I1(\n_in_r_reg_n_0_[3] ),
        .I2(xq_reg_0_63_0_2_i_31_n_6),
        .I3(\n_in_r_reg_n_0_[5] ),
        .I4(\n_in_r_reg_n_0_[4] ),
        .I5(xq_reg_0_63_0_2_i_30_n_6),
        .O(xq_reg_0_63_0_2_i_292_n_0));
  LUT6 #(
    .INIT(64'h003000BB00300088)) 
    xq_reg_0_63_0_2_i_293
       (.I0(xq_reg_0_63_0_2_i_39_n_6),
        .I1(\n_in_r_reg_n_0_[3] ),
        .I2(xq_reg_0_63_0_2_i_43_n_6),
        .I3(\n_in_r_reg_n_0_[5] ),
        .I4(\n_in_r_reg_n_0_[4] ),
        .I5(xq_reg_0_63_0_2_i_42_n_6),
        .O(xq_reg_0_63_0_2_i_293_n_0));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT4 #(
    .INIT(16'h2320)) 
    xq_reg_0_63_0_2_i_294
       (.I0(xq_reg_0_63_0_2_i_31_n_4),
        .I1(\n_in_r_reg_n_0_[5] ),
        .I2(\n_in_r_reg_n_0_[4] ),
        .I3(xq_reg_0_63_0_2_i_30_n_4),
        .O(xq_reg_0_63_0_2_i_294_n_0));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT4 #(
    .INIT(16'h2320)) 
    xq_reg_0_63_0_2_i_295
       (.I0(xq_reg_0_63_0_2_i_35_n_4),
        .I1(\n_in_r_reg_n_0_[5] ),
        .I2(\n_in_r_reg_n_0_[4] ),
        .I3(xq_reg_0_63_0_2_i_34_n_4),
        .O(xq_reg_0_63_0_2_i_295_n_0));
  LUT5 #(
    .INIT(32'hB8BBB888)) 
    xq_reg_0_63_0_2_i_296
       (.I0(xq_reg_0_63_0_2_i_290_n_0),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(xq_reg_0_63_0_2_i_330_n_0),
        .I3(\n_in_r_reg_n_0_[3] ),
        .I4(xq_reg_0_63_0_2_i_331_n_0),
        .O(xq_reg_0_63_0_2_i_296_n_0));
  LUT5 #(
    .INIT(32'h000000B8)) 
    xq_reg_0_63_0_2_i_297
       (.I0(xq_reg_0_63_0_2_i_43_n_4),
        .I1(\n_in_r_reg_n_0_[3] ),
        .I2(xq_reg_0_63_0_2_i_39_n_4),
        .I3(\n_in_r_reg_n_0_[4] ),
        .I4(\n_in_r_reg_n_0_[5] ),
        .O(xq_reg_0_63_0_2_i_297_n_0));
  LUT5 #(
    .INIT(32'h000000B8)) 
    xq_reg_0_63_0_2_i_298
       (.I0(xq_reg_0_63_0_2_i_43_n_6),
        .I1(\n_in_r_reg_n_0_[3] ),
        .I2(xq_reg_0_63_0_2_i_39_n_6),
        .I3(\n_in_r_reg_n_0_[4] ),
        .I4(\n_in_r_reg_n_0_[5] ),
        .O(xq_reg_0_63_0_2_i_298_n_0));
  LUT4 #(
    .INIT(16'hFFFE)) 
    xq_reg_0_63_0_2_i_299
       (.I0(\n_in_r_reg_n_0_[28] ),
        .I1(\n_in_r_reg_n_0_[29] ),
        .I2(\n_in_r_reg_n_0_[31] ),
        .I3(\n_in_r_reg_n_0_[30] ),
        .O(xq_reg_0_63_0_2_i_299_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFB8FF00FFB8)) 
    xq_reg_0_63_0_2_i_3
       (.I0(xq_reg_0_63_0_2_i_11_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_8_n_0),
        .I3(xq_reg_0_63_0_2_i_9_n_3),
        .I4(\n_in_r_reg_n_0_[0] ),
        .I5(xq_reg_0_63_0_2_i_12_n_0),
        .O(normalized_activation[2]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 xq_reg_0_63_0_2_i_30
       (.CI(xq_reg_0_63_0_2_i_42_n_0),
        .CO({xq_reg_0_63_0_2_i_30_n_0,xq_reg_0_63_0_2_i_30_n_1,xq_reg_0_63_0_2_i_30_n_2,xq_reg_0_63_0_2_i_30_n_3}),
        .CYINIT(1'b0),
        .DI(norm_prod_reg__1[47:44]),
        .O({xq_reg_0_63_0_2_i_30_n_4,xq_reg_0_63_0_2_i_30_n_5,xq_reg_0_63_0_2_i_30_n_6,xq_reg_0_63_0_2_i_30_n_7}),
        .S({xq_reg_0_63_0_2_i_70_n_0,xq_reg_0_63_0_2_i_71_n_0,xq_reg_0_63_0_2_i_72_n_0,xq_reg_0_63_0_2_i_73_n_0}));
  LUT4 #(
    .INIT(16'hFFFE)) 
    xq_reg_0_63_0_2_i_300
       (.I0(\n_in_r_reg_n_0_[20] ),
        .I1(\n_in_r_reg_n_0_[21] ),
        .I2(\n_in_r_reg_n_0_[22] ),
        .I3(\n_in_r_reg_n_0_[23] ),
        .O(xq_reg_0_63_0_2_i_300_n_0));
  (* SOFT_HLUTNM = "soft_lutpair53" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    xq_reg_0_63_0_2_i_301
       (.I0(\n_in_r_reg_n_0_[14] ),
        .I1(\n_in_r_reg_n_0_[15] ),
        .I2(\n_in_r_reg_n_0_[1] ),
        .I3(\n_in_r_reg_n_0_[0] ),
        .O(xq_reg_0_63_0_2_i_301_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 xq_reg_0_63_0_2_i_302
       (.CI(1'b0),
        .CO({xq_reg_0_63_0_2_i_302_n_0,xq_reg_0_63_0_2_i_302_n_1,xq_reg_0_63_0_2_i_302_n_2,xq_reg_0_63_0_2_i_302_n_3}),
        .CYINIT(1'b0),
        .DI({xq_reg_0_63_0_2_i_332_n_0,xq_reg_0_63_0_2_i_333_n_0,xq_reg_0_63_0_2_i_334_n_0,xq_reg_0_63_0_2_i_335_n_0}),
        .O(NLW_xq_reg_0_63_0_2_i_302_O_UNCONNECTED[3:0]),
        .S({xq_reg_0_63_0_2_i_336_n_0,xq_reg_0_63_0_2_i_337_n_0,xq_reg_0_63_0_2_i_338_n_0,xq_reg_0_63_0_2_i_339_n_0}));
  LUT6 #(
    .INIT(64'hFFFFFFB8B8FFB8B8)) 
    xq_reg_0_63_0_2_i_303
       (.I0(xq_reg_0_63_0_2_i_317_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_340_n_0),
        .I3(\n_in_r_reg_n_0_[0] ),
        .I4(xq_reg_0_63_0_2_i_341_n_0),
        .I5(xq_reg_0_63_0_2_i_318_n_0),
        .O(xq_reg_0_63_0_2_i_303_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFB8B8FFB8B8)) 
    xq_reg_0_63_0_2_i_304
       (.I0(xq_reg_0_63_0_2_i_340_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_342_n_0),
        .I3(\n_in_r_reg_n_0_[0] ),
        .I4(xq_reg_0_63_0_2_i_343_n_0),
        .I5(xq_reg_0_63_0_2_i_341_n_0),
        .O(xq_reg_0_63_0_2_i_304_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFB8B8FFB8B8)) 
    xq_reg_0_63_0_2_i_305
       (.I0(xq_reg_0_63_0_2_i_342_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_344_n_0),
        .I3(\n_in_r_reg_n_0_[0] ),
        .I4(xq_reg_0_63_0_2_i_345_n_0),
        .I5(xq_reg_0_63_0_2_i_343_n_0),
        .O(xq_reg_0_63_0_2_i_305_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFB8FF00FFB8)) 
    xq_reg_0_63_0_2_i_306
       (.I0(xq_reg_0_63_0_2_i_346_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_347_n_0),
        .I3(xq_reg_0_63_0_2_i_348_n_0),
        .I4(\n_in_r_reg_n_0_[0] ),
        .I5(xq_reg_0_63_0_2_i_345_n_0),
        .O(xq_reg_0_63_0_2_i_306_n_0));
  LUT6 #(
    .INIT(64'h0047004700004747)) 
    xq_reg_0_63_0_2_i_307
       (.I0(xq_reg_0_63_0_2_i_317_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_340_n_0),
        .I3(xq_reg_0_63_0_2_i_318_n_0),
        .I4(xq_reg_0_63_0_2_i_341_n_0),
        .I5(\n_in_r_reg_n_0_[0] ),
        .O(xq_reg_0_63_0_2_i_307_n_0));
  LUT6 #(
    .INIT(64'h0047004700004747)) 
    xq_reg_0_63_0_2_i_308
       (.I0(xq_reg_0_63_0_2_i_340_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_342_n_0),
        .I3(xq_reg_0_63_0_2_i_341_n_0),
        .I4(xq_reg_0_63_0_2_i_343_n_0),
        .I5(\n_in_r_reg_n_0_[0] ),
        .O(xq_reg_0_63_0_2_i_308_n_0));
  LUT6 #(
    .INIT(64'h0047004700004747)) 
    xq_reg_0_63_0_2_i_309
       (.I0(xq_reg_0_63_0_2_i_342_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_344_n_0),
        .I3(xq_reg_0_63_0_2_i_343_n_0),
        .I4(xq_reg_0_63_0_2_i_345_n_0),
        .I5(\n_in_r_reg_n_0_[0] ),
        .O(xq_reg_0_63_0_2_i_309_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 xq_reg_0_63_0_2_i_31
       (.CI(xq_reg_0_63_0_2_i_43_n_0),
        .CO({NLW_xq_reg_0_63_0_2_i_31_CO_UNCONNECTED[3],xq_reg_0_63_0_2_i_31_n_1,xq_reg_0_63_0_2_i_31_n_2,xq_reg_0_63_0_2_i_31_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,norm_prod_reg__1[62:60]}),
        .O({xq_reg_0_63_0_2_i_31_n_4,xq_reg_0_63_0_2_i_31_n_5,xq_reg_0_63_0_2_i_31_n_6,xq_reg_0_63_0_2_i_31_n_7}),
        .S({xq_reg_0_63_0_2_i_75_n_0,xq_reg_0_63_0_2_i_76_n_0,xq_reg_0_63_0_2_i_77_n_0,xq_reg_0_63_0_2_i_78_n_0}));
  LUT6 #(
    .INIT(64'h0000000000FF4747)) 
    xq_reg_0_63_0_2_i_310
       (.I0(xq_reg_0_63_0_2_i_346_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_347_n_0),
        .I3(xq_reg_0_63_0_2_i_345_n_0),
        .I4(\n_in_r_reg_n_0_[0] ),
        .I5(xq_reg_0_63_0_2_i_348_n_0),
        .O(xq_reg_0_63_0_2_i_310_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    xq_reg_0_63_0_2_i_311
       (.I0(xq_reg_0_63_0_2_i_325_n_0),
        .I1(xq_reg_0_63_0_2_i_326_n_0),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_320_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(xq_reg_0_63_0_2_i_349_n_0),
        .O(xq_reg_0_63_0_2_i_311_n_0));
  (* SOFT_HLUTNM = "soft_lutpair105" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    xq_reg_0_63_0_2_i_312
       (.I0(xq_reg_0_63_0_2_i_329_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_350_n_0),
        .O(xq_reg_0_63_0_2_i_312_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    xq_reg_0_63_0_2_i_313
       (.I0(xq_reg_0_63_0_2_i_295_n_0),
        .I1(xq_reg_0_63_0_2_i_328_n_0),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_323_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(xq_reg_0_63_0_2_i_351_n_0),
        .O(xq_reg_0_63_0_2_i_313_n_0));
  (* SOFT_HLUTNM = "soft_lutpair105" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    xq_reg_0_63_0_2_i_314
       (.I0(xq_reg_0_63_0_2_i_350_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_352_n_0),
        .O(xq_reg_0_63_0_2_i_314_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    xq_reg_0_63_0_2_i_315
       (.I0(xq_reg_0_63_0_2_i_320_n_0),
        .I1(xq_reg_0_63_0_2_i_349_n_0),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_326_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(xq_reg_0_63_0_2_i_353_n_0),
        .O(xq_reg_0_63_0_2_i_315_n_0));
  (* SOFT_HLUTNM = "soft_lutpair106" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    xq_reg_0_63_0_2_i_316
       (.I0(xq_reg_0_63_0_2_i_352_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_354_n_0),
        .O(xq_reg_0_63_0_2_i_316_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    xq_reg_0_63_0_2_i_317
       (.I0(xq_reg_0_63_0_2_i_323_n_0),
        .I1(xq_reg_0_63_0_2_i_351_n_0),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_328_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(xq_reg_0_63_0_2_i_355_n_0),
        .O(xq_reg_0_63_0_2_i_317_n_0));
  (* SOFT_HLUTNM = "soft_lutpair106" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    xq_reg_0_63_0_2_i_318
       (.I0(xq_reg_0_63_0_2_i_354_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_356_n_0),
        .O(xq_reg_0_63_0_2_i_318_n_0));
  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT4 #(
    .INIT(16'h2320)) 
    xq_reg_0_63_0_2_i_319
       (.I0(xq_reg_0_63_0_2_i_31_n_6),
        .I1(\n_in_r_reg_n_0_[5] ),
        .I2(\n_in_r_reg_n_0_[4] ),
        .I3(xq_reg_0_63_0_2_i_30_n_6),
        .O(xq_reg_0_63_0_2_i_319_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 xq_reg_0_63_0_2_i_32
       (.CI(xq_reg_0_63_0_2_i_44_n_0),
        .CO({xq_reg_0_63_0_2_i_32_n_0,xq_reg_0_63_0_2_i_32_n_1,xq_reg_0_63_0_2_i_32_n_2,xq_reg_0_63_0_2_i_32_n_3}),
        .CYINIT(1'b0),
        .DI(norm_prod_reg__1[31:28]),
        .O({xq_reg_0_63_0_2_i_32_n_4,xq_reg_0_63_0_2_i_32_n_5,xq_reg_0_63_0_2_i_32_n_6,xq_reg_0_63_0_2_i_32_n_7}),
        .S({xq_reg_0_63_0_2_i_80_n_0,xq_reg_0_63_0_2_i_81_n_0,xq_reg_0_63_0_2_i_82_n_0,xq_reg_0_63_0_2_i_83_n_0}));
  (* SOFT_HLUTNM = "soft_lutpair46" *) 
  LUT4 #(
    .INIT(16'h2320)) 
    xq_reg_0_63_0_2_i_320
       (.I0(xq_reg_0_63_0_2_i_35_n_6),
        .I1(\n_in_r_reg_n_0_[5] ),
        .I2(\n_in_r_reg_n_0_[4] ),
        .I3(xq_reg_0_63_0_2_i_34_n_6),
        .O(xq_reg_0_63_0_2_i_320_n_0));
  LUT5 #(
    .INIT(32'hB8BBB888)) 
    xq_reg_0_63_0_2_i_321
       (.I0(xq_reg_0_63_0_2_i_291_n_0),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(xq_reg_0_63_0_2_i_357_n_0),
        .I3(\n_in_r_reg_n_0_[3] ),
        .I4(xq_reg_0_63_0_2_i_358_n_0),
        .O(xq_reg_0_63_0_2_i_321_n_0));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT4 #(
    .INIT(16'h2320)) 
    xq_reg_0_63_0_2_i_322
       (.I0(xq_reg_0_63_0_2_i_43_n_4),
        .I1(\n_in_r_reg_n_0_[5] ),
        .I2(\n_in_r_reg_n_0_[4] ),
        .I3(xq_reg_0_63_0_2_i_42_n_4),
        .O(xq_reg_0_63_0_2_i_322_n_0));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT4 #(
    .INIT(16'h2320)) 
    xq_reg_0_63_0_2_i_323
       (.I0(xq_reg_0_63_0_2_i_39_n_4),
        .I1(\n_in_r_reg_n_0_[5] ),
        .I2(\n_in_r_reg_n_0_[4] ),
        .I3(xq_reg_0_63_0_2_i_38_n_4),
        .O(xq_reg_0_63_0_2_i_323_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    xq_reg_0_63_0_2_i_324
       (.I0(xq_reg_0_63_0_2_i_330_n_0),
        .I1(xq_reg_0_63_0_2_i_331_n_0),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_359_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(xq_reg_0_63_0_2_i_360_n_0),
        .O(xq_reg_0_63_0_2_i_324_n_0));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT4 #(
    .INIT(16'h2320)) 
    xq_reg_0_63_0_2_i_325
       (.I0(xq_reg_0_63_0_2_i_43_n_6),
        .I1(\n_in_r_reg_n_0_[5] ),
        .I2(\n_in_r_reg_n_0_[4] ),
        .I3(xq_reg_0_63_0_2_i_42_n_6),
        .O(xq_reg_0_63_0_2_i_325_n_0));
  (* SOFT_HLUTNM = "soft_lutpair47" *) 
  LUT4 #(
    .INIT(16'h2320)) 
    xq_reg_0_63_0_2_i_326
       (.I0(xq_reg_0_63_0_2_i_39_n_6),
        .I1(\n_in_r_reg_n_0_[5] ),
        .I2(\n_in_r_reg_n_0_[4] ),
        .I3(xq_reg_0_63_0_2_i_38_n_6),
        .O(xq_reg_0_63_0_2_i_326_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    xq_reg_0_63_0_2_i_327
       (.I0(xq_reg_0_63_0_2_i_357_n_0),
        .I1(xq_reg_0_63_0_2_i_358_n_0),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_361_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(xq_reg_0_63_0_2_i_362_n_0),
        .O(xq_reg_0_63_0_2_i_327_n_0));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT5 #(
    .INIT(32'h30BB3088)) 
    xq_reg_0_63_0_2_i_328
       (.I0(xq_reg_0_63_0_2_i_30_n_4),
        .I1(\n_in_r_reg_n_0_[4] ),
        .I2(xq_reg_0_63_0_2_i_31_n_4),
        .I3(\n_in_r_reg_n_0_[5] ),
        .I4(xq_reg_0_63_0_2_i_32_n_4),
        .O(xq_reg_0_63_0_2_i_328_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    xq_reg_0_63_0_2_i_329
       (.I0(xq_reg_0_63_0_2_i_359_n_0),
        .I1(xq_reg_0_63_0_2_i_360_n_0),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_331_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(xq_reg_0_63_0_2_i_363_n_0),
        .O(xq_reg_0_63_0_2_i_329_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 xq_reg_0_63_0_2_i_33
       (.CI(xq_reg_0_63_0_2_i_37_n_0),
        .CO({xq_reg_0_63_0_2_i_33_n_0,xq_reg_0_63_0_2_i_33_n_1,xq_reg_0_63_0_2_i_33_n_2,xq_reg_0_63_0_2_i_33_n_3}),
        .CYINIT(1'b0),
        .DI({\norm_prod_reg[7]__0_n_0 ,\norm_prod_reg[6]__0_n_0 ,\norm_prod_reg[5]__0_n_0 ,\norm_prod_reg[4]__0_n_0 }),
        .O({xq_reg_0_63_0_2_i_33_n_4,xq_reg_0_63_0_2_i_33_n_5,xq_reg_0_63_0_2_i_33_n_6,xq_reg_0_63_0_2_i_33_n_7}),
        .S({xq_reg_0_63_0_2_i_84_n_0,xq_reg_0_63_0_2_i_85_n_0,xq_reg_0_63_0_2_i_86_n_0,xq_reg_0_63_0_2_i_87_n_0}));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT4 #(
    .INIT(16'h2320)) 
    xq_reg_0_63_0_2_i_330
       (.I0(xq_reg_0_63_0_2_i_31_n_5),
        .I1(\n_in_r_reg_n_0_[5] ),
        .I2(\n_in_r_reg_n_0_[4] ),
        .I3(xq_reg_0_63_0_2_i_30_n_5),
        .O(xq_reg_0_63_0_2_i_330_n_0));
  (* SOFT_HLUTNM = "soft_lutpair42" *) 
  LUT4 #(
    .INIT(16'h2320)) 
    xq_reg_0_63_0_2_i_331
       (.I0(xq_reg_0_63_0_2_i_35_n_5),
        .I1(\n_in_r_reg_n_0_[5] ),
        .I2(\n_in_r_reg_n_0_[4] ),
        .I3(xq_reg_0_63_0_2_i_34_n_5),
        .O(xq_reg_0_63_0_2_i_331_n_0));
  LUT6 #(
    .INIT(64'hFFFFEE22FFFFB8B8)) 
    xq_reg_0_63_0_2_i_332
       (.I0(xq_reg_0_63_0_2_i_347_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_364_n_0),
        .I3(xq_reg_0_63_0_2_i_346_n_0),
        .I4(xq_reg_0_63_0_2_i_365_n_0),
        .I5(\n_in_r_reg_n_0_[0] ),
        .O(xq_reg_0_63_0_2_i_332_n_0));
  LUT6 #(
    .INIT(64'hFFFFEE22FFFFB8B8)) 
    xq_reg_0_63_0_2_i_333
       (.I0(xq_reg_0_63_0_2_i_364_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_366_n_0),
        .I3(xq_reg_0_63_0_2_i_347_n_0),
        .I4(xq_reg_0_63_0_2_i_367_n_0),
        .I5(\n_in_r_reg_n_0_[0] ),
        .O(xq_reg_0_63_0_2_i_333_n_0));
  LUT6 #(
    .INIT(64'hFFFFEE22FFFFB8B8)) 
    xq_reg_0_63_0_2_i_334
       (.I0(xq_reg_0_63_0_2_i_366_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_3_5_i_6_n_0),
        .I3(xq_reg_0_63_0_2_i_364_n_0),
        .I4(xq_reg_0_63_0_2_i_368_n_0),
        .I5(\n_in_r_reg_n_0_[0] ),
        .O(xq_reg_0_63_0_2_i_334_n_0));
  LUT5 #(
    .INIT(32'hB8FFB800)) 
    xq_reg_0_63_0_2_i_335
       (.I0(xq_reg_0_63_0_2_i_366_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_3_5_i_6_n_0),
        .I3(\n_in_r_reg_n_0_[0] ),
        .I4(xq_reg_0_63_0_2_i_369_n_0),
        .O(xq_reg_0_63_0_2_i_335_n_0));
  LUT6 #(
    .INIT(64'h0000000011DD4747)) 
    xq_reg_0_63_0_2_i_336
       (.I0(xq_reg_0_63_0_2_i_347_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_364_n_0),
        .I3(xq_reg_0_63_0_2_i_346_n_0),
        .I4(\n_in_r_reg_n_0_[0] ),
        .I5(xq_reg_0_63_0_2_i_365_n_0),
        .O(xq_reg_0_63_0_2_i_336_n_0));
  LUT6 #(
    .INIT(64'h0000000011DD4747)) 
    xq_reg_0_63_0_2_i_337
       (.I0(xq_reg_0_63_0_2_i_364_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_366_n_0),
        .I3(xq_reg_0_63_0_2_i_347_n_0),
        .I4(\n_in_r_reg_n_0_[0] ),
        .I5(xq_reg_0_63_0_2_i_367_n_0),
        .O(xq_reg_0_63_0_2_i_337_n_0));
  LUT6 #(
    .INIT(64'h0000000011DD4747)) 
    xq_reg_0_63_0_2_i_338
       (.I0(xq_reg_0_63_0_2_i_366_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_3_5_i_6_n_0),
        .I3(xq_reg_0_63_0_2_i_364_n_0),
        .I4(\n_in_r_reg_n_0_[0] ),
        .I5(xq_reg_0_63_0_2_i_368_n_0),
        .O(xq_reg_0_63_0_2_i_338_n_0));
  LUT6 #(
    .INIT(64'h474700000000F3C0)) 
    xq_reg_0_63_0_2_i_339
       (.I0(xq_reg_0_63_0_2_i_366_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_3_5_i_6_n_0),
        .I3(xq_reg_0_63_3_5_i_4_n_0),
        .I4(xq_reg_0_63_0_2_i_369_n_0),
        .I5(\n_in_r_reg_n_0_[0] ),
        .O(xq_reg_0_63_0_2_i_339_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 xq_reg_0_63_0_2_i_34
       (.CI(xq_reg_0_63_0_2_i_38_n_0),
        .CO({xq_reg_0_63_0_2_i_34_n_0,xq_reg_0_63_0_2_i_34_n_1,xq_reg_0_63_0_2_i_34_n_2,xq_reg_0_63_0_2_i_34_n_3}),
        .CYINIT(1'b0),
        .DI(norm_prod_reg__1[39:36]),
        .O({xq_reg_0_63_0_2_i_34_n_4,xq_reg_0_63_0_2_i_34_n_5,xq_reg_0_63_0_2_i_34_n_6,xq_reg_0_63_0_2_i_34_n_7}),
        .S({xq_reg_0_63_0_2_i_89_n_0,xq_reg_0_63_0_2_i_90_n_0,xq_reg_0_63_0_2_i_91_n_0,xq_reg_0_63_0_2_i_92_n_0}));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    xq_reg_0_63_0_2_i_340
       (.I0(xq_reg_0_63_0_2_i_326_n_0),
        .I1(xq_reg_0_63_0_2_i_353_n_0),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_349_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(xq_reg_0_63_6_7_i_4_n_0),
        .O(xq_reg_0_63_0_2_i_340_n_0));
  (* SOFT_HLUTNM = "soft_lutpair107" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    xq_reg_0_63_0_2_i_341
       (.I0(xq_reg_0_63_0_2_i_356_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_370_n_0),
        .O(xq_reg_0_63_0_2_i_341_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    xq_reg_0_63_0_2_i_342
       (.I0(xq_reg_0_63_0_2_i_328_n_0),
        .I1(xq_reg_0_63_0_2_i_355_n_0),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_351_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(xq_reg_0_63_3_5_i_10_n_0),
        .O(xq_reg_0_63_0_2_i_342_n_0));
  (* SOFT_HLUTNM = "soft_lutpair107" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    xq_reg_0_63_0_2_i_343
       (.I0(xq_reg_0_63_0_2_i_370_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_371_n_0),
        .O(xq_reg_0_63_0_2_i_343_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    xq_reg_0_63_0_2_i_344
       (.I0(xq_reg_0_63_0_2_i_349_n_0),
        .I1(xq_reg_0_63_6_7_i_4_n_0),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_353_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(xq_reg_0_63_0_2_i_64_n_0),
        .O(xq_reg_0_63_0_2_i_344_n_0));
  (* SOFT_HLUTNM = "soft_lutpair110" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    xq_reg_0_63_0_2_i_345
       (.I0(xq_reg_0_63_0_2_i_371_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_346_n_0),
        .O(xq_reg_0_63_0_2_i_345_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    xq_reg_0_63_0_2_i_346
       (.I0(xq_reg_0_63_0_2_i_372_n_0),
        .I1(xq_reg_0_63_3_5_i_9_n_0),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_373_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(xq_reg_0_63_0_2_i_27_n_0),
        .O(xq_reg_0_63_0_2_i_346_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    xq_reg_0_63_0_2_i_347
       (.I0(xq_reg_0_63_0_2_i_374_n_0),
        .I1(xq_reg_0_63_3_5_i_7_n_0),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_375_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(xq_reg_0_63_0_2_i_19_n_0),
        .O(xq_reg_0_63_0_2_i_347_n_0));
  (* SOFT_HLUTNM = "soft_lutpair108" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    xq_reg_0_63_0_2_i_348
       (.I0(xq_reg_0_63_0_2_i_344_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_376_n_0),
        .O(xq_reg_0_63_0_2_i_348_n_0));
  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT5 #(
    .INIT(32'h30BB3088)) 
    xq_reg_0_63_0_2_i_349
       (.I0(xq_reg_0_63_0_2_i_30_n_6),
        .I1(\n_in_r_reg_n_0_[4] ),
        .I2(xq_reg_0_63_0_2_i_31_n_6),
        .I3(\n_in_r_reg_n_0_[5] ),
        .I4(xq_reg_0_63_0_2_i_32_n_6),
        .O(xq_reg_0_63_0_2_i_349_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 xq_reg_0_63_0_2_i_35
       (.CI(xq_reg_0_63_0_2_i_39_n_0),
        .CO({xq_reg_0_63_0_2_i_35_n_0,xq_reg_0_63_0_2_i_35_n_1,xq_reg_0_63_0_2_i_35_n_2,xq_reg_0_63_0_2_i_35_n_3}),
        .CYINIT(1'b0),
        .DI(norm_prod_reg__1[55:52]),
        .O({xq_reg_0_63_0_2_i_35_n_4,xq_reg_0_63_0_2_i_35_n_5,xq_reg_0_63_0_2_i_35_n_6,xq_reg_0_63_0_2_i_35_n_7}),
        .S({xq_reg_0_63_0_2_i_94_n_0,xq_reg_0_63_0_2_i_95_n_0,xq_reg_0_63_0_2_i_96_n_0,xq_reg_0_63_0_2_i_97_n_0}));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    xq_reg_0_63_0_2_i_350
       (.I0(xq_reg_0_63_0_2_i_361_n_0),
        .I1(xq_reg_0_63_0_2_i_362_n_0),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_358_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(xq_reg_0_63_0_2_i_372_n_0),
        .O(xq_reg_0_63_0_2_i_350_n_0));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT5 #(
    .INIT(32'h30BB3088)) 
    xq_reg_0_63_0_2_i_351
       (.I0(xq_reg_0_63_0_2_i_42_n_4),
        .I1(\n_in_r_reg_n_0_[4] ),
        .I2(xq_reg_0_63_0_2_i_43_n_4),
        .I3(\n_in_r_reg_n_0_[5] ),
        .I4(xq_reg_0_63_0_2_i_44_n_4),
        .O(xq_reg_0_63_0_2_i_351_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    xq_reg_0_63_0_2_i_352
       (.I0(xq_reg_0_63_0_2_i_331_n_0),
        .I1(xq_reg_0_63_0_2_i_363_n_0),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_360_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(xq_reg_0_63_0_2_i_374_n_0),
        .O(xq_reg_0_63_0_2_i_352_n_0));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT5 #(
    .INIT(32'h30BB3088)) 
    xq_reg_0_63_0_2_i_353
       (.I0(xq_reg_0_63_0_2_i_42_n_6),
        .I1(\n_in_r_reg_n_0_[4] ),
        .I2(xq_reg_0_63_0_2_i_43_n_6),
        .I3(\n_in_r_reg_n_0_[5] ),
        .I4(xq_reg_0_63_0_2_i_44_n_6),
        .O(xq_reg_0_63_0_2_i_353_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    xq_reg_0_63_0_2_i_354
       (.I0(xq_reg_0_63_0_2_i_358_n_0),
        .I1(xq_reg_0_63_0_2_i_372_n_0),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_362_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(xq_reg_0_63_0_2_i_373_n_0),
        .O(xq_reg_0_63_0_2_i_354_n_0));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT5 #(
    .INIT(32'h30BB3088)) 
    xq_reg_0_63_0_2_i_355
       (.I0(xq_reg_0_63_0_2_i_34_n_4),
        .I1(\n_in_r_reg_n_0_[4] ),
        .I2(xq_reg_0_63_0_2_i_35_n_4),
        .I3(\n_in_r_reg_n_0_[5] ),
        .I4(xq_reg_0_63_0_2_i_36_n_4),
        .O(xq_reg_0_63_0_2_i_355_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    xq_reg_0_63_0_2_i_356
       (.I0(xq_reg_0_63_0_2_i_360_n_0),
        .I1(xq_reg_0_63_0_2_i_374_n_0),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_363_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(xq_reg_0_63_0_2_i_375_n_0),
        .O(xq_reg_0_63_0_2_i_356_n_0));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT4 #(
    .INIT(16'h2320)) 
    xq_reg_0_63_0_2_i_357
       (.I0(xq_reg_0_63_0_2_i_31_n_7),
        .I1(\n_in_r_reg_n_0_[5] ),
        .I2(\n_in_r_reg_n_0_[4] ),
        .I3(xq_reg_0_63_0_2_i_30_n_7),
        .O(xq_reg_0_63_0_2_i_357_n_0));
  (* SOFT_HLUTNM = "soft_lutpair44" *) 
  LUT4 #(
    .INIT(16'h2320)) 
    xq_reg_0_63_0_2_i_358
       (.I0(xq_reg_0_63_0_2_i_35_n_7),
        .I1(\n_in_r_reg_n_0_[5] ),
        .I2(\n_in_r_reg_n_0_[4] ),
        .I3(xq_reg_0_63_0_2_i_34_n_7),
        .O(xq_reg_0_63_0_2_i_358_n_0));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT4 #(
    .INIT(16'h2320)) 
    xq_reg_0_63_0_2_i_359
       (.I0(xq_reg_0_63_0_2_i_43_n_5),
        .I1(\n_in_r_reg_n_0_[5] ),
        .I2(\n_in_r_reg_n_0_[4] ),
        .I3(xq_reg_0_63_0_2_i_42_n_5),
        .O(xq_reg_0_63_0_2_i_359_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 xq_reg_0_63_0_2_i_36
       (.CI(xq_reg_0_63_0_2_i_40_n_0),
        .CO({xq_reg_0_63_0_2_i_36_n_0,xq_reg_0_63_0_2_i_36_n_1,xq_reg_0_63_0_2_i_36_n_2,xq_reg_0_63_0_2_i_36_n_3}),
        .CYINIT(1'b0),
        .DI(norm_prod_reg__1[23:20]),
        .O({xq_reg_0_63_0_2_i_36_n_4,xq_reg_0_63_0_2_i_36_n_5,xq_reg_0_63_0_2_i_36_n_6,xq_reg_0_63_0_2_i_36_n_7}),
        .S({xq_reg_0_63_0_2_i_99_n_0,xq_reg_0_63_0_2_i_100_n_0,xq_reg_0_63_0_2_i_101_n_0,xq_reg_0_63_0_2_i_102_n_0}));
  (* SOFT_HLUTNM = "soft_lutpair43" *) 
  LUT4 #(
    .INIT(16'h2320)) 
    xq_reg_0_63_0_2_i_360
       (.I0(xq_reg_0_63_0_2_i_39_n_5),
        .I1(\n_in_r_reg_n_0_[5] ),
        .I2(\n_in_r_reg_n_0_[4] ),
        .I3(xq_reg_0_63_0_2_i_38_n_5),
        .O(xq_reg_0_63_0_2_i_360_n_0));
  (* SOFT_HLUTNM = "soft_lutpair41" *) 
  LUT4 #(
    .INIT(16'h2320)) 
    xq_reg_0_63_0_2_i_361
       (.I0(xq_reg_0_63_0_2_i_43_n_7),
        .I1(\n_in_r_reg_n_0_[5] ),
        .I2(\n_in_r_reg_n_0_[4] ),
        .I3(xq_reg_0_63_0_2_i_42_n_7),
        .O(xq_reg_0_63_0_2_i_361_n_0));
  (* SOFT_HLUTNM = "soft_lutpair45" *) 
  LUT4 #(
    .INIT(16'h2320)) 
    xq_reg_0_63_0_2_i_362
       (.I0(xq_reg_0_63_0_2_i_39_n_7),
        .I1(\n_in_r_reg_n_0_[5] ),
        .I2(\n_in_r_reg_n_0_[4] ),
        .I3(xq_reg_0_63_0_2_i_38_n_7),
        .O(xq_reg_0_63_0_2_i_362_n_0));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT5 #(
    .INIT(32'h30BB3088)) 
    xq_reg_0_63_0_2_i_363
       (.I0(xq_reg_0_63_0_2_i_30_n_5),
        .I1(\n_in_r_reg_n_0_[4] ),
        .I2(xq_reg_0_63_0_2_i_31_n_5),
        .I3(\n_in_r_reg_n_0_[5] ),
        .I4(xq_reg_0_63_0_2_i_32_n_5),
        .O(xq_reg_0_63_0_2_i_363_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    xq_reg_0_63_0_2_i_364
       (.I0(xq_reg_0_63_0_2_i_373_n_0),
        .I1(xq_reg_0_63_0_2_i_27_n_0),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_3_5_i_9_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(xq_reg_0_63_0_2_i_13_n_0),
        .O(xq_reg_0_63_0_2_i_364_n_0));
  (* SOFT_HLUTNM = "soft_lutpair108" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    xq_reg_0_63_0_2_i_365
       (.I0(xq_reg_0_63_0_2_i_376_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_377_n_0),
        .O(xq_reg_0_63_0_2_i_365_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    xq_reg_0_63_0_2_i_366
       (.I0(xq_reg_0_63_0_2_i_375_n_0),
        .I1(xq_reg_0_63_0_2_i_19_n_0),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_3_5_i_7_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(xq_reg_0_63_0_2_i_18_n_0),
        .O(xq_reg_0_63_0_2_i_366_n_0));
  (* SOFT_HLUTNM = "soft_lutpair109" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    xq_reg_0_63_0_2_i_367
       (.I0(xq_reg_0_63_0_2_i_377_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_378_n_0),
        .O(xq_reg_0_63_0_2_i_367_n_0));
  (* SOFT_HLUTNM = "soft_lutpair109" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    xq_reg_0_63_0_2_i_368
       (.I0(xq_reg_0_63_0_2_i_378_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_6_7_i_3_n_0),
        .O(xq_reg_0_63_0_2_i_368_n_0));
  (* SOFT_HLUTNM = "soft_lutpair110" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    xq_reg_0_63_0_2_i_369
       (.I0(xq_reg_0_63_6_7_i_3_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_3_5_i_8_n_0),
        .O(xq_reg_0_63_0_2_i_369_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 xq_reg_0_63_0_2_i_37
       (.CI(1'b0),
        .CO({xq_reg_0_63_0_2_i_37_n_0,xq_reg_0_63_0_2_i_37_n_1,xq_reg_0_63_0_2_i_37_n_2,xq_reg_0_63_0_2_i_37_n_3}),
        .CYINIT(1'b0),
        .DI({\norm_prod_reg[3]__0_n_0 ,\norm_prod_reg[2]__0_n_0 ,\norm_prod_reg[1]__0_n_0 ,\norm_prod_reg[0]__0_n_0 }),
        .O({xq_reg_0_63_0_2_i_37_n_4,xq_reg_0_63_0_2_i_37_n_5,xq_reg_0_63_0_2_i_37_n_6,xq_reg_0_63_0_2_i_37_n_7}),
        .S({xq_reg_0_63_0_2_i_103_n_0,xq_reg_0_63_0_2_i_104_n_0,xq_reg_0_63_0_2_i_105_n_0,xq_reg_0_63_0_2_i_106_n_0}));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    xq_reg_0_63_0_2_i_370
       (.I0(xq_reg_0_63_0_2_i_362_n_0),
        .I1(xq_reg_0_63_0_2_i_373_n_0),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_372_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(xq_reg_0_63_3_5_i_9_n_0),
        .O(xq_reg_0_63_0_2_i_370_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    xq_reg_0_63_0_2_i_371
       (.I0(xq_reg_0_63_0_2_i_363_n_0),
        .I1(xq_reg_0_63_0_2_i_375_n_0),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_374_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(xq_reg_0_63_3_5_i_7_n_0),
        .O(xq_reg_0_63_0_2_i_371_n_0));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT5 #(
    .INIT(32'h30BB3088)) 
    xq_reg_0_63_0_2_i_372
       (.I0(xq_reg_0_63_0_2_i_30_n_7),
        .I1(\n_in_r_reg_n_0_[4] ),
        .I2(xq_reg_0_63_0_2_i_31_n_7),
        .I3(\n_in_r_reg_n_0_[5] ),
        .I4(xq_reg_0_63_0_2_i_32_n_7),
        .O(xq_reg_0_63_0_2_i_372_n_0));
  (* SOFT_HLUTNM = "soft_lutpair41" *) 
  LUT5 #(
    .INIT(32'h30BB3088)) 
    xq_reg_0_63_0_2_i_373
       (.I0(xq_reg_0_63_0_2_i_42_n_7),
        .I1(\n_in_r_reg_n_0_[4] ),
        .I2(xq_reg_0_63_0_2_i_43_n_7),
        .I3(\n_in_r_reg_n_0_[5] ),
        .I4(xq_reg_0_63_0_2_i_44_n_7),
        .O(xq_reg_0_63_0_2_i_373_n_0));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT5 #(
    .INIT(32'h30BB3088)) 
    xq_reg_0_63_0_2_i_374
       (.I0(xq_reg_0_63_0_2_i_42_n_5),
        .I1(\n_in_r_reg_n_0_[4] ),
        .I2(xq_reg_0_63_0_2_i_43_n_5),
        .I3(\n_in_r_reg_n_0_[5] ),
        .I4(xq_reg_0_63_0_2_i_44_n_5),
        .O(xq_reg_0_63_0_2_i_374_n_0));
  (* SOFT_HLUTNM = "soft_lutpair42" *) 
  LUT5 #(
    .INIT(32'h30BB3088)) 
    xq_reg_0_63_0_2_i_375
       (.I0(xq_reg_0_63_0_2_i_34_n_5),
        .I1(\n_in_r_reg_n_0_[4] ),
        .I2(xq_reg_0_63_0_2_i_35_n_5),
        .I3(\n_in_r_reg_n_0_[5] ),
        .I4(xq_reg_0_63_0_2_i_36_n_5),
        .O(xq_reg_0_63_0_2_i_375_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    xq_reg_0_63_0_2_i_376
       (.I0(xq_reg_0_63_0_2_i_351_n_0),
        .I1(xq_reg_0_63_3_5_i_10_n_0),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_355_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(xq_reg_0_63_0_2_i_58_n_0),
        .O(xq_reg_0_63_0_2_i_376_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    xq_reg_0_63_0_2_i_377
       (.I0(xq_reg_0_63_0_2_i_353_n_0),
        .I1(xq_reg_0_63_0_2_i_64_n_0),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_6_7_i_4_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(xq_reg_0_63_0_2_i_62_n_0),
        .O(xq_reg_0_63_0_2_i_377_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    xq_reg_0_63_0_2_i_378
       (.I0(xq_reg_0_63_0_2_i_355_n_0),
        .I1(xq_reg_0_63_0_2_i_58_n_0),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_3_5_i_10_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(xq_reg_0_63_0_2_i_57_n_0),
        .O(xq_reg_0_63_0_2_i_378_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 xq_reg_0_63_0_2_i_38
       (.CI(xq_reg_0_63_0_2_i_32_n_0),
        .CO({xq_reg_0_63_0_2_i_38_n_0,xq_reg_0_63_0_2_i_38_n_1,xq_reg_0_63_0_2_i_38_n_2,xq_reg_0_63_0_2_i_38_n_3}),
        .CYINIT(1'b0),
        .DI(norm_prod_reg__1[35:32]),
        .O({xq_reg_0_63_0_2_i_38_n_4,xq_reg_0_63_0_2_i_38_n_5,xq_reg_0_63_0_2_i_38_n_6,xq_reg_0_63_0_2_i_38_n_7}),
        .S({xq_reg_0_63_0_2_i_108_n_0,xq_reg_0_63_0_2_i_109_n_0,xq_reg_0_63_0_2_i_110_n_0,xq_reg_0_63_0_2_i_111_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 xq_reg_0_63_0_2_i_39
       (.CI(xq_reg_0_63_0_2_i_30_n_0),
        .CO({xq_reg_0_63_0_2_i_39_n_0,xq_reg_0_63_0_2_i_39_n_1,xq_reg_0_63_0_2_i_39_n_2,xq_reg_0_63_0_2_i_39_n_3}),
        .CYINIT(1'b0),
        .DI(norm_prod_reg__1[51:48]),
        .O({xq_reg_0_63_0_2_i_39_n_4,xq_reg_0_63_0_2_i_39_n_5,xq_reg_0_63_0_2_i_39_n_6,xq_reg_0_63_0_2_i_39_n_7}),
        .S({xq_reg_0_63_0_2_i_113_n_0,xq_reg_0_63_0_2_i_114_n_0,xq_reg_0_63_0_2_i_115_n_0,xq_reg_0_63_0_2_i_116_n_0}));
  LUT6 #(
    .INIT(64'h0000000200000000)) 
    xq_reg_0_63_0_2_i_4
       (.I0(rst_n),
        .I1(state[4]),
        .I2(state[3]),
        .I3(state[1]),
        .I4(state[0]),
        .I5(state[2]),
        .O(xq_reg_0_63_0_2_i_4_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 xq_reg_0_63_0_2_i_40
       (.CI(xq_reg_0_63_0_2_i_29_n_0),
        .CO({xq_reg_0_63_0_2_i_40_n_0,xq_reg_0_63_0_2_i_40_n_1,xq_reg_0_63_0_2_i_40_n_2,xq_reg_0_63_0_2_i_40_n_3}),
        .CYINIT(1'b0),
        .DI(norm_prod_reg__1[19:16]),
        .O({xq_reg_0_63_0_2_i_40_n_4,xq_reg_0_63_0_2_i_40_n_5,xq_reg_0_63_0_2_i_40_n_6,xq_reg_0_63_0_2_i_40_n_7}),
        .S({xq_reg_0_63_0_2_i_118_n_0,xq_reg_0_63_0_2_i_119_n_0,xq_reg_0_63_0_2_i_120_n_0,xq_reg_0_63_0_2_i_121_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 xq_reg_0_63_0_2_i_41
       (.CI(xq_reg_0_63_0_2_i_33_n_0),
        .CO({xq_reg_0_63_0_2_i_41_n_0,xq_reg_0_63_0_2_i_41_n_1,xq_reg_0_63_0_2_i_41_n_2,xq_reg_0_63_0_2_i_41_n_3}),
        .CYINIT(1'b0),
        .DI({\norm_prod_reg[11]__0_n_0 ,\norm_prod_reg[10]__0_n_0 ,\norm_prod_reg[9]__0_n_0 ,\norm_prod_reg[8]__0_n_0 }),
        .O({xq_reg_0_63_0_2_i_41_n_4,xq_reg_0_63_0_2_i_41_n_5,xq_reg_0_63_0_2_i_41_n_6,xq_reg_0_63_0_2_i_41_n_7}),
        .S({xq_reg_0_63_0_2_i_122_n_0,xq_reg_0_63_0_2_i_123_n_0,xq_reg_0_63_0_2_i_124_n_0,xq_reg_0_63_0_2_i_125_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 xq_reg_0_63_0_2_i_42
       (.CI(xq_reg_0_63_0_2_i_34_n_0),
        .CO({xq_reg_0_63_0_2_i_42_n_0,xq_reg_0_63_0_2_i_42_n_1,xq_reg_0_63_0_2_i_42_n_2,xq_reg_0_63_0_2_i_42_n_3}),
        .CYINIT(1'b0),
        .DI(norm_prod_reg__1[43:40]),
        .O({xq_reg_0_63_0_2_i_42_n_4,xq_reg_0_63_0_2_i_42_n_5,xq_reg_0_63_0_2_i_42_n_6,xq_reg_0_63_0_2_i_42_n_7}),
        .S({xq_reg_0_63_0_2_i_127_n_0,xq_reg_0_63_0_2_i_128_n_0,xq_reg_0_63_0_2_i_129_n_0,xq_reg_0_63_0_2_i_130_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 xq_reg_0_63_0_2_i_43
       (.CI(xq_reg_0_63_0_2_i_35_n_0),
        .CO({xq_reg_0_63_0_2_i_43_n_0,xq_reg_0_63_0_2_i_43_n_1,xq_reg_0_63_0_2_i_43_n_2,xq_reg_0_63_0_2_i_43_n_3}),
        .CYINIT(1'b0),
        .DI(norm_prod_reg__1[59:56]),
        .O({xq_reg_0_63_0_2_i_43_n_4,xq_reg_0_63_0_2_i_43_n_5,xq_reg_0_63_0_2_i_43_n_6,xq_reg_0_63_0_2_i_43_n_7}),
        .S({xq_reg_0_63_0_2_i_132_n_0,xq_reg_0_63_0_2_i_133_n_0,xq_reg_0_63_0_2_i_134_n_0,xq_reg_0_63_0_2_i_135_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 xq_reg_0_63_0_2_i_44
       (.CI(xq_reg_0_63_0_2_i_36_n_0),
        .CO({xq_reg_0_63_0_2_i_44_n_0,xq_reg_0_63_0_2_i_44_n_1,xq_reg_0_63_0_2_i_44_n_2,xq_reg_0_63_0_2_i_44_n_3}),
        .CYINIT(1'b0),
        .DI(norm_prod_reg__1[27:24]),
        .O({xq_reg_0_63_0_2_i_44_n_4,xq_reg_0_63_0_2_i_44_n_5,xq_reg_0_63_0_2_i_44_n_6,xq_reg_0_63_0_2_i_44_n_7}),
        .S({xq_reg_0_63_0_2_i_137_n_0,xq_reg_0_63_0_2_i_138_n_0,xq_reg_0_63_0_2_i_139_n_0,xq_reg_0_63_0_2_i_140_n_0}));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 xq_reg_0_63_0_2_i_45
       (.CI(xq_reg_0_63_0_2_i_141_n_0),
        .CO({xq_reg_0_63_0_2_i_45_n_0,xq_reg_0_63_0_2_i_45_n_1,xq_reg_0_63_0_2_i_45_n_2,xq_reg_0_63_0_2_i_45_n_3}),
        .CYINIT(1'b0),
        .DI({xq_reg_0_63_0_2_i_142_n_0,xq_reg_0_63_0_2_i_143_n_0,xq_reg_0_63_0_2_i_144_n_0,xq_reg_0_63_0_2_i_145_n_0}),
        .O(NLW_xq_reg_0_63_0_2_i_45_O_UNCONNECTED[3:0]),
        .S({xq_reg_0_63_0_2_i_146_n_0,xq_reg_0_63_0_2_i_147_n_0,xq_reg_0_63_0_2_i_148_n_0,xq_reg_0_63_0_2_i_149_n_0}));
  LUT6 #(
    .INIT(64'hFFFFFFFF0F00F404)) 
    xq_reg_0_63_0_2_i_46
       (.I0(xq_reg_0_63_0_2_i_55_n_0),
        .I1(xq_reg_0_63_0_2_i_150_n_0),
        .I2(\n_in_r_reg_n_0_[1] ),
        .I3(xq_reg_0_63_0_2_i_151_n_0),
        .I4(\n_in_r_reg_n_0_[0] ),
        .I5(xq_reg_0_63_0_2_i_152_n_0),
        .O(xq_reg_0_63_0_2_i_46_n_0));
  LUT4 #(
    .INIT(16'hFFAC)) 
    xq_reg_0_63_0_2_i_47
       (.I0(xq_reg_0_63_0_2_i_153_n_0),
        .I1(xq_reg_0_63_0_2_i_154_n_0),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(xq_reg_0_63_0_2_i_155_n_0),
        .O(xq_reg_0_63_0_2_i_47_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFFAFA0FC0C)) 
    xq_reg_0_63_0_2_i_48
       (.I0(xq_reg_0_63_0_2_i_156_n_0),
        .I1(xq_reg_0_63_0_2_i_157_n_0),
        .I2(\n_in_r_reg_n_0_[1] ),
        .I3(xq_reg_0_63_0_2_i_158_n_0),
        .I4(\n_in_r_reg_n_0_[0] ),
        .I5(xq_reg_0_63_0_2_i_159_n_0),
        .O(xq_reg_0_63_0_2_i_48_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFFAFA0FC0C)) 
    xq_reg_0_63_0_2_i_49
       (.I0(xq_reg_0_63_0_2_i_158_n_0),
        .I1(xq_reg_0_63_0_2_i_160_n_0),
        .I2(\n_in_r_reg_n_0_[1] ),
        .I3(xq_reg_0_63_0_2_i_157_n_0),
        .I4(\n_in_r_reg_n_0_[0] ),
        .I5(xq_reg_0_63_0_2_i_161_n_0),
        .O(xq_reg_0_63_0_2_i_49_n_0));
  LUT5 #(
    .INIT(32'h00004200)) 
    xq_reg_0_63_0_2_i_5
       (.I0(state[2]),
        .I1(state[1]),
        .I2(state[0]),
        .I3(state[3]),
        .I4(state[4]),
        .O(mac_in[1]));
  LUT6 #(
    .INIT(64'h00000000F0FF0BFB)) 
    xq_reg_0_63_0_2_i_50
       (.I0(xq_reg_0_63_0_2_i_55_n_0),
        .I1(xq_reg_0_63_0_2_i_150_n_0),
        .I2(\n_in_r_reg_n_0_[1] ),
        .I3(xq_reg_0_63_0_2_i_151_n_0),
        .I4(\n_in_r_reg_n_0_[0] ),
        .I5(xq_reg_0_63_0_2_i_152_n_0),
        .O(xq_reg_0_63_0_2_i_50_n_0));
  LUT4 #(
    .INIT(16'h0053)) 
    xq_reg_0_63_0_2_i_51
       (.I0(xq_reg_0_63_0_2_i_153_n_0),
        .I1(xq_reg_0_63_0_2_i_154_n_0),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(xq_reg_0_63_0_2_i_155_n_0),
        .O(xq_reg_0_63_0_2_i_51_n_0));
  LUT6 #(
    .INIT(64'h00000000505F03F3)) 
    xq_reg_0_63_0_2_i_52
       (.I0(xq_reg_0_63_0_2_i_156_n_0),
        .I1(xq_reg_0_63_0_2_i_157_n_0),
        .I2(\n_in_r_reg_n_0_[1] ),
        .I3(xq_reg_0_63_0_2_i_158_n_0),
        .I4(\n_in_r_reg_n_0_[0] ),
        .I5(xq_reg_0_63_0_2_i_159_n_0),
        .O(xq_reg_0_63_0_2_i_52_n_0));
  LUT6 #(
    .INIT(64'h00000000505F03F3)) 
    xq_reg_0_63_0_2_i_53
       (.I0(xq_reg_0_63_0_2_i_158_n_0),
        .I1(xq_reg_0_63_0_2_i_160_n_0),
        .I2(\n_in_r_reg_n_0_[1] ),
        .I3(xq_reg_0_63_0_2_i_157_n_0),
        .I4(\n_in_r_reg_n_0_[0] ),
        .I5(xq_reg_0_63_0_2_i_161_n_0),
        .O(xq_reg_0_63_0_2_i_53_n_0));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT2 #(
    .INIT(4'hE)) 
    xq_reg_0_63_0_2_i_54
       (.I0(\n_in_r_reg_n_0_[5] ),
        .I1(\n_in_r_reg_n_0_[4] ),
        .O(xq_reg_0_63_0_2_i_54_n_0));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT2 #(
    .INIT(4'hE)) 
    xq_reg_0_63_0_2_i_55
       (.I0(\n_in_r_reg_n_0_[3] ),
        .I1(\n_in_r_reg_n_0_[2] ),
        .O(xq_reg_0_63_0_2_i_55_n_0));
  LUT6 #(
    .INIT(64'hFC0CFAFAFC0C0A0A)) 
    xq_reg_0_63_0_2_i_56
       (.I0(xq_reg_0_63_0_2_i_37_n_4),
        .I1(xq_reg_0_63_0_2_i_38_n_4),
        .I2(\n_in_r_reg_n_0_[4] ),
        .I3(xq_reg_0_63_0_2_i_39_n_4),
        .I4(\n_in_r_reg_n_0_[5] ),
        .I5(xq_reg_0_63_0_2_i_40_n_4),
        .O(xq_reg_0_63_0_2_i_56_n_0));
  LUT6 #(
    .INIT(64'hFC0CFAFAFC0C0A0A)) 
    xq_reg_0_63_0_2_i_57
       (.I0(xq_reg_0_63_0_2_i_41_n_4),
        .I1(xq_reg_0_63_0_2_i_42_n_4),
        .I2(\n_in_r_reg_n_0_[4] ),
        .I3(xq_reg_0_63_0_2_i_43_n_4),
        .I4(\n_in_r_reg_n_0_[5] ),
        .I5(xq_reg_0_63_0_2_i_44_n_4),
        .O(xq_reg_0_63_0_2_i_57_n_0));
  LUT6 #(
    .INIT(64'hFC0CFAFAFC0C0A0A)) 
    xq_reg_0_63_0_2_i_58
       (.I0(xq_reg_0_63_0_2_i_29_n_4),
        .I1(xq_reg_0_63_0_2_i_30_n_4),
        .I2(\n_in_r_reg_n_0_[4] ),
        .I3(xq_reg_0_63_0_2_i_31_n_4),
        .I4(\n_in_r_reg_n_0_[5] ),
        .I5(xq_reg_0_63_0_2_i_32_n_4),
        .O(xq_reg_0_63_0_2_i_58_n_0));
  LUT6 #(
    .INIT(64'hFC0CFAFAFC0C0A0A)) 
    xq_reg_0_63_0_2_i_59
       (.I0(xq_reg_0_63_0_2_i_33_n_4),
        .I1(xq_reg_0_63_0_2_i_34_n_4),
        .I2(\n_in_r_reg_n_0_[4] ),
        .I3(xq_reg_0_63_0_2_i_35_n_4),
        .I4(\n_in_r_reg_n_0_[5] ),
        .I5(xq_reg_0_63_0_2_i_36_n_4),
        .O(xq_reg_0_63_0_2_i_59_n_0));
  LUT5 #(
    .INIT(32'h00000600)) 
    xq_reg_0_63_0_2_i_6
       (.I0(state[2]),
        .I1(state[1]),
        .I2(state[0]),
        .I3(state[3]),
        .I4(state[4]),
        .O(mac_in[0]));
  LUT6 #(
    .INIT(64'hFC0CFAFAFC0C0A0A)) 
    xq_reg_0_63_0_2_i_60
       (.I0(xq_reg_0_63_0_2_i_41_n_6),
        .I1(xq_reg_0_63_0_2_i_42_n_6),
        .I2(\n_in_r_reg_n_0_[4] ),
        .I3(xq_reg_0_63_0_2_i_43_n_6),
        .I4(\n_in_r_reg_n_0_[5] ),
        .I5(xq_reg_0_63_0_2_i_44_n_6),
        .O(xq_reg_0_63_0_2_i_60_n_0));
  LUT6 #(
    .INIT(64'hFC0CFAFAFC0C0A0A)) 
    xq_reg_0_63_0_2_i_61
       (.I0(xq_reg_0_63_0_2_i_37_n_6),
        .I1(xq_reg_0_63_0_2_i_38_n_6),
        .I2(\n_in_r_reg_n_0_[4] ),
        .I3(xq_reg_0_63_0_2_i_39_n_6),
        .I4(\n_in_r_reg_n_0_[5] ),
        .I5(xq_reg_0_63_0_2_i_40_n_6),
        .O(xq_reg_0_63_0_2_i_61_n_0));
  LUT6 #(
    .INIT(64'hFC0CFAFAFC0C0A0A)) 
    xq_reg_0_63_0_2_i_62
       (.I0(xq_reg_0_63_0_2_i_29_n_6),
        .I1(xq_reg_0_63_0_2_i_30_n_6),
        .I2(\n_in_r_reg_n_0_[4] ),
        .I3(xq_reg_0_63_0_2_i_31_n_6),
        .I4(\n_in_r_reg_n_0_[5] ),
        .I5(xq_reg_0_63_0_2_i_32_n_6),
        .O(xq_reg_0_63_0_2_i_62_n_0));
  LUT6 #(
    .INIT(64'hFC0CFAFAFC0C0A0A)) 
    xq_reg_0_63_0_2_i_63
       (.I0(xq_reg_0_63_0_2_i_33_n_6),
        .I1(xq_reg_0_63_0_2_i_34_n_6),
        .I2(\n_in_r_reg_n_0_[4] ),
        .I3(xq_reg_0_63_0_2_i_35_n_6),
        .I4(\n_in_r_reg_n_0_[5] ),
        .I5(xq_reg_0_63_0_2_i_36_n_6),
        .O(xq_reg_0_63_0_2_i_63_n_0));
  (* SOFT_HLUTNM = "soft_lutpair47" *) 
  LUT5 #(
    .INIT(32'h30BB3088)) 
    xq_reg_0_63_0_2_i_64
       (.I0(xq_reg_0_63_0_2_i_38_n_6),
        .I1(\n_in_r_reg_n_0_[4] ),
        .I2(xq_reg_0_63_0_2_i_39_n_6),
        .I3(\n_in_r_reg_n_0_[5] ),
        .I4(xq_reg_0_63_0_2_i_40_n_6),
        .O(xq_reg_0_63_0_2_i_64_n_0));
  LUT5 #(
    .INIT(32'hAAA9AAAA)) 
    xq_reg_0_63_0_2_i_65
       (.I0(\norm_prod_reg[15]__0_n_0 ),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[1] ),
        .I3(\n_in_r_reg_n_0_[0] ),
        .I4(xq_reg_0_63_0_2_i_162_n_0),
        .O(xq_reg_0_63_0_2_i_65_n_0));
  LUT5 #(
    .INIT(32'h6AAAAAAA)) 
    xq_reg_0_63_0_2_i_66
       (.I0(\norm_prod_reg[14]__0_n_0 ),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_162_n_0),
        .O(xq_reg_0_63_0_2_i_66_n_0));
  LUT5 #(
    .INIT(32'hA6AAAAAA)) 
    xq_reg_0_63_0_2_i_67
       (.I0(\norm_prod_reg[13]__0_n_0 ),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_162_n_0),
        .O(xq_reg_0_63_0_2_i_67_n_0));
  LUT5 #(
    .INIT(32'hAA6AAAAA)) 
    xq_reg_0_63_0_2_i_68
       (.I0(\norm_prod_reg[12]__0_n_0 ),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_162_n_0),
        .O(xq_reg_0_63_0_2_i_68_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 xq_reg_0_63_0_2_i_69
       (.CI(xq_reg_0_63_0_2_i_126_n_0),
        .CO({xq_reg_0_63_0_2_i_69_n_0,xq_reg_0_63_0_2_i_69_n_1,xq_reg_0_63_0_2_i_69_n_2,xq_reg_0_63_0_2_i_69_n_3}),
        .CYINIT(1'b0),
        .DI({norm_prod_reg__0_n_75,norm_prod_reg__0_n_76,norm_prod_reg__0_n_77,norm_prod_reg__0_n_78}),
        .O(norm_prod_reg__1[47:44]),
        .S({xq_reg_0_63_0_2_i_163_n_0,xq_reg_0_63_0_2_i_164_n_0,xq_reg_0_63_0_2_i_165_n_0,xq_reg_0_63_0_2_i_166_n_0}));
  LUT6 #(
    .INIT(64'hB8B8B8B8FFCC3300)) 
    xq_reg_0_63_0_2_i_7
       (.I0(xq_reg_0_63_0_2_i_13_n_0),
        .I1(\n_in_r_reg_n_0_[3] ),
        .I2(xq_reg_0_63_0_2_i_14_n_0),
        .I3(xq_reg_0_63_0_2_i_15_n_0),
        .I4(xq_reg_0_63_0_2_i_16_n_0),
        .I5(\n_in_r_reg_n_0_[2] ),
        .O(xq_reg_0_63_0_2_i_7_n_0));
  LUT5 #(
    .INIT(32'hAAA9AAAA)) 
    xq_reg_0_63_0_2_i_70
       (.I0(norm_prod_reg__1[47]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[1] ),
        .I3(\n_in_r_reg_n_0_[0] ),
        .I4(xq_reg_0_63_0_2_i_167_n_0),
        .O(xq_reg_0_63_0_2_i_70_n_0));
  LUT5 #(
    .INIT(32'h6AAAAAAA)) 
    xq_reg_0_63_0_2_i_71
       (.I0(norm_prod_reg__1[46]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_167_n_0),
        .O(xq_reg_0_63_0_2_i_71_n_0));
  LUT5 #(
    .INIT(32'hA6AAAAAA)) 
    xq_reg_0_63_0_2_i_72
       (.I0(norm_prod_reg__1[45]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_167_n_0),
        .O(xq_reg_0_63_0_2_i_72_n_0));
  LUT5 #(
    .INIT(32'hAA6AAAAA)) 
    xq_reg_0_63_0_2_i_73
       (.I0(norm_prod_reg__1[44]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_167_n_0),
        .O(xq_reg_0_63_0_2_i_73_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 xq_reg_0_63_0_2_i_74
       (.CI(xq_reg_0_63_0_2_i_131_n_0),
        .CO({NLW_xq_reg_0_63_0_2_i_74_CO_UNCONNECTED[3],xq_reg_0_63_0_2_i_74_n_1,xq_reg_0_63_0_2_i_74_n_2,xq_reg_0_63_0_2_i_74_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,norm_prod_reg__0_n_60,norm_prod_reg__0_n_61,norm_prod_reg__0_n_62}),
        .O(norm_prod_reg__1[63:60]),
        .S({xq_reg_0_63_0_2_i_168_n_0,xq_reg_0_63_0_2_i_169_n_0,xq_reg_0_63_0_2_i_170_n_0,xq_reg_0_63_0_2_i_171_n_0}));
  LUT5 #(
    .INIT(32'hAAA9AAAA)) 
    xq_reg_0_63_0_2_i_75
       (.I0(norm_prod_reg__1[63]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[1] ),
        .I3(\n_in_r_reg_n_0_[0] ),
        .I4(xq_reg_0_63_0_2_i_172_n_0),
        .O(xq_reg_0_63_0_2_i_75_n_0));
  LUT5 #(
    .INIT(32'h6AAAAAAA)) 
    xq_reg_0_63_0_2_i_76
       (.I0(norm_prod_reg__1[62]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_172_n_0),
        .O(xq_reg_0_63_0_2_i_76_n_0));
  LUT5 #(
    .INIT(32'hA6AAAAAA)) 
    xq_reg_0_63_0_2_i_77
       (.I0(norm_prod_reg__1[61]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_172_n_0),
        .O(xq_reg_0_63_0_2_i_77_n_0));
  LUT5 #(
    .INIT(32'hAA6AAAAA)) 
    xq_reg_0_63_0_2_i_78
       (.I0(norm_prod_reg__1[60]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_172_n_0),
        .O(xq_reg_0_63_0_2_i_78_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 xq_reg_0_63_0_2_i_79
       (.CI(xq_reg_0_63_0_2_i_136_n_0),
        .CO({xq_reg_0_63_0_2_i_79_n_0,xq_reg_0_63_0_2_i_79_n_1,xq_reg_0_63_0_2_i_79_n_2,xq_reg_0_63_0_2_i_79_n_3}),
        .CYINIT(1'b0),
        .DI({norm_prod_reg__0_n_91,norm_prod_reg__0_n_92,norm_prod_reg__0_n_93,norm_prod_reg__0_n_94}),
        .O(norm_prod_reg__1[31:28]),
        .S({xq_reg_0_63_0_2_i_173_n_0,xq_reg_0_63_0_2_i_174_n_0,xq_reg_0_63_0_2_i_175_n_0,xq_reg_0_63_0_2_i_176_n_0}));
  LUT6 #(
    .INIT(64'hFC0CFAFAFC0C0A0A)) 
    xq_reg_0_63_0_2_i_8
       (.I0(xq_reg_0_63_0_2_i_17_n_0),
        .I1(xq_reg_0_63_0_2_i_18_n_0),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_19_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(xq_reg_0_63_0_2_i_20_n_0),
        .O(xq_reg_0_63_0_2_i_8_n_0));
  LUT5 #(
    .INIT(32'hAAA9AAAA)) 
    xq_reg_0_63_0_2_i_80
       (.I0(norm_prod_reg__1[31]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[1] ),
        .I3(\n_in_r_reg_n_0_[0] ),
        .I4(xq_reg_0_63_0_2_i_177_n_0),
        .O(xq_reg_0_63_0_2_i_80_n_0));
  LUT5 #(
    .INIT(32'h6AAAAAAA)) 
    xq_reg_0_63_0_2_i_81
       (.I0(norm_prod_reg__1[30]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_177_n_0),
        .O(xq_reg_0_63_0_2_i_81_n_0));
  LUT5 #(
    .INIT(32'hA6AAAAAA)) 
    xq_reg_0_63_0_2_i_82
       (.I0(norm_prod_reg__1[29]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_177_n_0),
        .O(xq_reg_0_63_0_2_i_82_n_0));
  LUT5 #(
    .INIT(32'hAA6AAAAA)) 
    xq_reg_0_63_0_2_i_83
       (.I0(norm_prod_reg__1[28]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_177_n_0),
        .O(xq_reg_0_63_0_2_i_83_n_0));
  LUT5 #(
    .INIT(32'hAAA9AAAA)) 
    xq_reg_0_63_0_2_i_84
       (.I0(\norm_prod_reg[7]__0_n_0 ),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[1] ),
        .I3(\n_in_r_reg_n_0_[0] ),
        .I4(xq_reg_0_63_0_2_i_178_n_0),
        .O(xq_reg_0_63_0_2_i_84_n_0));
  LUT5 #(
    .INIT(32'h6AAAAAAA)) 
    xq_reg_0_63_0_2_i_85
       (.I0(\norm_prod_reg[6]__0_n_0 ),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_178_n_0),
        .O(xq_reg_0_63_0_2_i_85_n_0));
  LUT5 #(
    .INIT(32'hA6AAAAAA)) 
    xq_reg_0_63_0_2_i_86
       (.I0(\norm_prod_reg[5]__0_n_0 ),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_178_n_0),
        .O(xq_reg_0_63_0_2_i_86_n_0));
  LUT5 #(
    .INIT(32'hAA6AAAAA)) 
    xq_reg_0_63_0_2_i_87
       (.I0(\norm_prod_reg[4]__0_n_0 ),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_178_n_0),
        .O(xq_reg_0_63_0_2_i_87_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 xq_reg_0_63_0_2_i_88
       (.CI(xq_reg_0_63_0_2_i_107_n_0),
        .CO({xq_reg_0_63_0_2_i_88_n_0,xq_reg_0_63_0_2_i_88_n_1,xq_reg_0_63_0_2_i_88_n_2,xq_reg_0_63_0_2_i_88_n_3}),
        .CYINIT(1'b0),
        .DI({norm_prod_reg__0_n_83,norm_prod_reg__0_n_84,norm_prod_reg__0_n_85,norm_prod_reg__0_n_86}),
        .O(norm_prod_reg__1[39:36]),
        .S({xq_reg_0_63_0_2_i_179_n_0,xq_reg_0_63_0_2_i_180_n_0,xq_reg_0_63_0_2_i_181_n_0,xq_reg_0_63_0_2_i_182_n_0}));
  LUT5 #(
    .INIT(32'hAAA9AAAA)) 
    xq_reg_0_63_0_2_i_89
       (.I0(norm_prod_reg__1[39]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[1] ),
        .I3(\n_in_r_reg_n_0_[0] ),
        .I4(xq_reg_0_63_0_2_i_183_n_0),
        .O(xq_reg_0_63_0_2_i_89_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 xq_reg_0_63_0_2_i_9
       (.CI(xq_reg_0_63_0_2_i_21_n_0),
        .CO({NLW_xq_reg_0_63_0_2_i_9_CO_UNCONNECTED[3:1],xq_reg_0_63_0_2_i_9_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,xq_reg_0_63_0_2_i_22_n_0}),
        .O(NLW_xq_reg_0_63_0_2_i_9_O_UNCONNECTED[3:0]),
        .S({1'b0,1'b0,1'b0,xq_reg_0_63_0_2_i_23_n_0}));
  LUT5 #(
    .INIT(32'h6AAAAAAA)) 
    xq_reg_0_63_0_2_i_90
       (.I0(norm_prod_reg__1[38]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_183_n_0),
        .O(xq_reg_0_63_0_2_i_90_n_0));
  LUT5 #(
    .INIT(32'hA6AAAAAA)) 
    xq_reg_0_63_0_2_i_91
       (.I0(norm_prod_reg__1[37]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_183_n_0),
        .O(xq_reg_0_63_0_2_i_91_n_0));
  LUT5 #(
    .INIT(32'hAA6AAAAA)) 
    xq_reg_0_63_0_2_i_92
       (.I0(norm_prod_reg__1[36]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_183_n_0),
        .O(xq_reg_0_63_0_2_i_92_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 xq_reg_0_63_0_2_i_93
       (.CI(xq_reg_0_63_0_2_i_112_n_0),
        .CO({xq_reg_0_63_0_2_i_93_n_0,xq_reg_0_63_0_2_i_93_n_1,xq_reg_0_63_0_2_i_93_n_2,xq_reg_0_63_0_2_i_93_n_3}),
        .CYINIT(1'b0),
        .DI({norm_prod_reg__0_n_67,norm_prod_reg__0_n_68,norm_prod_reg__0_n_69,norm_prod_reg__0_n_70}),
        .O(norm_prod_reg__1[55:52]),
        .S({xq_reg_0_63_0_2_i_184_n_0,xq_reg_0_63_0_2_i_185_n_0,xq_reg_0_63_0_2_i_186_n_0,xq_reg_0_63_0_2_i_187_n_0}));
  LUT5 #(
    .INIT(32'hAAA9AAAA)) 
    xq_reg_0_63_0_2_i_94
       (.I0(norm_prod_reg__1[55]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[1] ),
        .I3(\n_in_r_reg_n_0_[0] ),
        .I4(xq_reg_0_63_0_2_i_188_n_0),
        .O(xq_reg_0_63_0_2_i_94_n_0));
  LUT5 #(
    .INIT(32'h6AAAAAAA)) 
    xq_reg_0_63_0_2_i_95
       (.I0(norm_prod_reg__1[54]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_188_n_0),
        .O(xq_reg_0_63_0_2_i_95_n_0));
  LUT5 #(
    .INIT(32'hA6AAAAAA)) 
    xq_reg_0_63_0_2_i_96
       (.I0(norm_prod_reg__1[53]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_188_n_0),
        .O(xq_reg_0_63_0_2_i_96_n_0));
  LUT5 #(
    .INIT(32'hAA6AAAAA)) 
    xq_reg_0_63_0_2_i_97
       (.I0(norm_prod_reg__1[52]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(\n_in_r_reg_n_0_[1] ),
        .I4(xq_reg_0_63_0_2_i_188_n_0),
        .O(xq_reg_0_63_0_2_i_97_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 xq_reg_0_63_0_2_i_98
       (.CI(xq_reg_0_63_0_2_i_117_n_0),
        .CO({xq_reg_0_63_0_2_i_98_n_0,xq_reg_0_63_0_2_i_98_n_1,xq_reg_0_63_0_2_i_98_n_2,xq_reg_0_63_0_2_i_98_n_3}),
        .CYINIT(1'b0),
        .DI({norm_prod_reg__0_n_99,norm_prod_reg__0_n_100,norm_prod_reg__0_n_101,norm_prod_reg__0_n_102}),
        .O(norm_prod_reg__1[23:20]),
        .S({xq_reg_0_63_0_2_i_189_n_0,xq_reg_0_63_0_2_i_190_n_0,xq_reg_0_63_0_2_i_191_n_0,xq_reg_0_63_0_2_i_192_n_0}));
  LUT5 #(
    .INIT(32'hAAA9AAAA)) 
    xq_reg_0_63_0_2_i_99
       (.I0(norm_prod_reg__1[23]),
        .I1(\n_in_r_reg_n_0_[2] ),
        .I2(\n_in_r_reg_n_0_[1] ),
        .I3(\n_in_r_reg_n_0_[0] ),
        .I4(xq_reg_0_63_0_2_i_193_n_0),
        .O(xq_reg_0_63_0_2_i_99_n_0));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "320" *) 
  (* RTL_RAM_NAME = "emg_nn_infer/xq_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "39" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "3" *) 
  (* ram_slice_end = "5" *) 
  RAM64M xq_reg_0_63_3_5
       (.ADDRA({mac_in__0,mac_in}),
        .ADDRB({mac_in__0,mac_in}),
        .ADDRC({mac_in__0,mac_in}),
        .ADDRD(feat_save_idx),
        .DIA(normalized_activation[3]),
        .DIB(normalized_activation[4]),
        .DIC(normalized_activation[5]),
        .DID(1'b0),
        .DOA(act1[3]),
        .DOB(act1[4]),
        .DOC(act1[5]),
        .DOD(NLW_xq_reg_0_63_3_5_DOD_UNCONNECTED),
        .WCLK(clk),
        .WE(xq_reg_0_63_0_2_i_4_n_0));
  LUT6 #(
    .INIT(64'hFFB8FFB8FFFFFF00)) 
    xq_reg_0_63_3_5_i_1
       (.I0(xq_reg_0_63_3_5_i_4_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_11_n_0),
        .I3(xq_reg_0_63_0_2_i_9_n_3),
        .I4(xq_reg_0_63_0_2_i_12_n_0),
        .I5(\n_in_r_reg_n_0_[0] ),
        .O(normalized_activation[3]));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT5 #(
    .INIT(32'h30BB3088)) 
    xq_reg_0_63_3_5_i_10
       (.I0(xq_reg_0_63_0_2_i_38_n_4),
        .I1(\n_in_r_reg_n_0_[4] ),
        .I2(xq_reg_0_63_0_2_i_39_n_4),
        .I3(\n_in_r_reg_n_0_[5] ),
        .I4(xq_reg_0_63_0_2_i_40_n_4),
        .O(xq_reg_0_63_3_5_i_10_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFB8FF00FFB8)) 
    xq_reg_0_63_3_5_i_2
       (.I0(xq_reg_0_63_3_5_i_4_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_11_n_0),
        .I3(xq_reg_0_63_0_2_i_9_n_3),
        .I4(\n_in_r_reg_n_0_[0] ),
        .I5(xq_reg_0_63_3_5_i_5_n_0),
        .O(normalized_activation[4]));
  LUT6 #(
    .INIT(64'hFFB8FFB8FFFFFF00)) 
    xq_reg_0_63_3_5_i_3
       (.I0(xq_reg_0_63_3_5_i_6_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_3_5_i_4_n_0),
        .I3(xq_reg_0_63_0_2_i_9_n_3),
        .I4(xq_reg_0_63_3_5_i_5_n_0),
        .I5(\n_in_r_reg_n_0_[0] ),
        .O(normalized_activation[5]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    xq_reg_0_63_3_5_i_4
       (.I0(xq_reg_0_63_3_5_i_7_n_0),
        .I1(xq_reg_0_63_0_2_i_18_n_0),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_19_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(xq_reg_0_63_0_2_i_20_n_0),
        .O(xq_reg_0_63_3_5_i_4_n_0));
  (* SOFT_HLUTNM = "soft_lutpair97" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    xq_reg_0_63_3_5_i_5
       (.I0(xq_reg_0_63_3_5_i_8_n_0),
        .I1(\n_in_r_reg_n_0_[1] ),
        .I2(xq_reg_0_63_0_2_i_28_n_0),
        .O(xq_reg_0_63_3_5_i_5_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    xq_reg_0_63_3_5_i_6
       (.I0(xq_reg_0_63_3_5_i_9_n_0),
        .I1(xq_reg_0_63_0_2_i_13_n_0),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_27_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(xq_reg_0_63_0_2_i_16_n_0),
        .O(xq_reg_0_63_3_5_i_6_n_0));
  (* SOFT_HLUTNM = "soft_lutpair43" *) 
  LUT5 #(
    .INIT(32'h30BB3088)) 
    xq_reg_0_63_3_5_i_7
       (.I0(xq_reg_0_63_0_2_i_38_n_5),
        .I1(\n_in_r_reg_n_0_[4] ),
        .I2(xq_reg_0_63_0_2_i_39_n_5),
        .I3(\n_in_r_reg_n_0_[5] ),
        .I4(xq_reg_0_63_0_2_i_40_n_5),
        .O(xq_reg_0_63_3_5_i_7_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    xq_reg_0_63_3_5_i_8
       (.I0(xq_reg_0_63_3_5_i_10_n_0),
        .I1(xq_reg_0_63_0_2_i_57_n_0),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_58_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(xq_reg_0_63_0_2_i_59_n_0),
        .O(xq_reg_0_63_3_5_i_8_n_0));
  (* SOFT_HLUTNM = "soft_lutpair44" *) 
  LUT5 #(
    .INIT(32'h30BB3088)) 
    xq_reg_0_63_3_5_i_9
       (.I0(xq_reg_0_63_0_2_i_34_n_7),
        .I1(\n_in_r_reg_n_0_[4] ),
        .I2(xq_reg_0_63_0_2_i_35_n_7),
        .I3(\n_in_r_reg_n_0_[5] ),
        .I4(xq_reg_0_63_0_2_i_36_n_7),
        .O(xq_reg_0_63_3_5_i_9_n_0));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "320" *) 
  (* RTL_RAM_NAME = "emg_nn_infer/xq_reg_0_63_6_7" *) 
  (* RTL_RAM_STYLE = "NONE" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "39" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "6" *) 
  (* ram_slice_end = "6" *) 
  RAM64X1D xq_reg_0_63_6_7
       (.A0(feat_save_idx[0]),
        .A1(feat_save_idx[1]),
        .A2(feat_save_idx[2]),
        .A3(feat_save_idx[3]),
        .A4(feat_save_idx[4]),
        .A5(feat_save_idx[5]),
        .D(normalized_activation[6]),
        .DPO(act1[6]),
        .DPRA0(mac_in[0]),
        .DPRA1(mac_in[1]),
        .DPRA2(mac_in__0[2]),
        .DPRA3(mac_in__0[3]),
        .DPRA4(mac_in__0[4]),
        .DPRA5(mac_in__0[5]),
        .SPO(NLW_xq_reg_0_63_6_7_SPO_UNCONNECTED),
        .WCLK(clk),
        .WE(xq_reg_0_63_0_2_i_4_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    xq_reg_0_63_6_7_i_1
       (.I0(xq_reg_0_63_6_7_i_2_n_0),
        .I1(xq_reg_0_63_0_2_i_9_n_3),
        .O(normalized_activation[6]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    xq_reg_0_63_6_7_i_2
       (.I0(xq_reg_0_63_6_7_i_3_n_0),
        .I1(xq_reg_0_63_3_5_i_8_n_0),
        .I2(\n_in_r_reg_n_0_[0] ),
        .I3(xq_reg_0_63_3_5_i_6_n_0),
        .I4(\n_in_r_reg_n_0_[1] ),
        .I5(xq_reg_0_63_3_5_i_4_n_0),
        .O(xq_reg_0_63_6_7_i_2_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    xq_reg_0_63_6_7_i_3
       (.I0(xq_reg_0_63_6_7_i_4_n_0),
        .I1(xq_reg_0_63_0_2_i_62_n_0),
        .I2(\n_in_r_reg_n_0_[2] ),
        .I3(xq_reg_0_63_0_2_i_64_n_0),
        .I4(\n_in_r_reg_n_0_[3] ),
        .I5(xq_reg_0_63_0_2_i_60_n_0),
        .O(xq_reg_0_63_6_7_i_3_n_0));
  (* SOFT_HLUTNM = "soft_lutpair46" *) 
  LUT5 #(
    .INIT(32'h30BB3088)) 
    xq_reg_0_63_6_7_i_4
       (.I0(xq_reg_0_63_0_2_i_34_n_6),
        .I1(\n_in_r_reg_n_0_[4] ),
        .I2(xq_reg_0_63_0_2_i_35_n_6),
        .I3(\n_in_r_reg_n_0_[5] ),
        .I4(xq_reg_0_63_0_2_i_36_n_6),
        .O(xq_reg_0_63_6_7_i_4_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[0]_i_1 
       (.I0(\xq_seen[7]_i_2_n_0 ),
        .I1(\xq_seen[32]_i_2_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[0] ),
        .O(\xq_seen[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[10]_i_1 
       (.I0(\xq_seen[15]_i_2_n_0 ),
        .I1(\xq_seen[34]_i_2_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[10] ),
        .O(\xq_seen[10]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[11]_i_1 
       (.I0(\xq_seen[15]_i_2_n_0 ),
        .I1(\xq_seen[35]_i_2_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[11] ),
        .O(\xq_seen[11]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[12]_i_1 
       (.I0(\xq_seen[15]_i_2_n_0 ),
        .I1(\xq_seen[36]_i_2_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[12] ),
        .O(\xq_seen[12]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[13]_i_1 
       (.I0(\xq_seen[15]_i_2_n_0 ),
        .I1(\xq_seen[37]_i_2_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[13] ),
        .O(\xq_seen[13]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[14]_i_1 
       (.I0(\xq_seen[15]_i_2_n_0 ),
        .I1(\xq_seen[38]_i_2_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[14] ),
        .O(\xq_seen[14]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[15]_i_1 
       (.I0(\xq_seen[15]_i_2_n_0 ),
        .I1(\xq_seen[39]_i_3_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[15] ),
        .O(\xq_seen[15]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair112" *) 
  LUT3 #(
    .INIT(8'hEF)) 
    \xq_seen[15]_i_2 
       (.I0(feat_save_idx[5]),
        .I1(feat_save_idx[4]),
        .I2(feat_save_idx[3]),
        .O(\xq_seen[15]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[16]_i_1 
       (.I0(\xq_seen[23]_i_2_n_0 ),
        .I1(\xq_seen[32]_i_2_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[16] ),
        .O(\xq_seen[16]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[17]_i_1 
       (.I0(\xq_seen[23]_i_2_n_0 ),
        .I1(\xq_seen[33]_i_2_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[17] ),
        .O(\xq_seen[17]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[18]_i_1 
       (.I0(\xq_seen[23]_i_2_n_0 ),
        .I1(\xq_seen[34]_i_2_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[18] ),
        .O(\xq_seen[18]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[19]_i_1 
       (.I0(\xq_seen[23]_i_2_n_0 ),
        .I1(\xq_seen[35]_i_2_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[19] ),
        .O(\xq_seen[19]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[1]_i_1 
       (.I0(\xq_seen[7]_i_2_n_0 ),
        .I1(\xq_seen[33]_i_2_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[1] ),
        .O(\xq_seen[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[20]_i_1 
       (.I0(\xq_seen[23]_i_2_n_0 ),
        .I1(\xq_seen[36]_i_2_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[20] ),
        .O(\xq_seen[20]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[21]_i_1 
       (.I0(\xq_seen[23]_i_2_n_0 ),
        .I1(\xq_seen[37]_i_2_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[21] ),
        .O(\xq_seen[21]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[22]_i_1 
       (.I0(\xq_seen[23]_i_2_n_0 ),
        .I1(\xq_seen[38]_i_2_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[22] ),
        .O(\xq_seen[22]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[23]_i_1 
       (.I0(\xq_seen[23]_i_2_n_0 ),
        .I1(\xq_seen[39]_i_3_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[23] ),
        .O(\xq_seen[23]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair112" *) 
  LUT3 #(
    .INIT(8'hEF)) 
    \xq_seen[23]_i_2 
       (.I0(feat_save_idx[5]),
        .I1(feat_save_idx[3]),
        .I2(feat_save_idx[4]),
        .O(\xq_seen[23]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[24]_i_1 
       (.I0(\xq_seen[31]_i_2_n_0 ),
        .I1(\xq_seen[32]_i_2_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[24] ),
        .O(\xq_seen[24]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[25]_i_1 
       (.I0(\xq_seen[31]_i_2_n_0 ),
        .I1(\xq_seen[33]_i_2_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[25] ),
        .O(\xq_seen[25]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[26]_i_1 
       (.I0(\xq_seen[31]_i_2_n_0 ),
        .I1(\xq_seen[34]_i_2_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[26] ),
        .O(\xq_seen[26]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[27]_i_1 
       (.I0(\xq_seen[31]_i_2_n_0 ),
        .I1(\xq_seen[35]_i_2_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[27] ),
        .O(\xq_seen[27]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[28]_i_1 
       (.I0(\xq_seen[31]_i_2_n_0 ),
        .I1(\xq_seen[36]_i_2_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[28] ),
        .O(\xq_seen[28]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[29]_i_1 
       (.I0(\xq_seen[31]_i_2_n_0 ),
        .I1(\xq_seen[37]_i_2_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[29] ),
        .O(\xq_seen[29]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[2]_i_1 
       (.I0(\xq_seen[7]_i_2_n_0 ),
        .I1(\xq_seen[34]_i_2_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[2] ),
        .O(\xq_seen[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[30]_i_1 
       (.I0(\xq_seen[31]_i_2_n_0 ),
        .I1(\xq_seen[38]_i_2_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[30] ),
        .O(\xq_seen[30]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[31]_i_1 
       (.I0(\xq_seen[31]_i_2_n_0 ),
        .I1(\xq_seen[39]_i_3_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[31] ),
        .O(\xq_seen[31]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair114" *) 
  LUT3 #(
    .INIT(8'hBF)) 
    \xq_seen[31]_i_2 
       (.I0(feat_save_idx[5]),
        .I1(feat_save_idx[3]),
        .I2(feat_save_idx[4]),
        .O(\xq_seen[31]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[32]_i_1 
       (.I0(\xq_seen[39]_i_2_n_0 ),
        .I1(\xq_seen[32]_i_2_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[32] ),
        .O(\xq_seen[32]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair111" *) 
  LUT3 #(
    .INIT(8'hFE)) 
    \xq_seen[32]_i_2 
       (.I0(feat_save_idx[2]),
        .I1(feat_save_idx[0]),
        .I2(feat_save_idx[1]),
        .O(\xq_seen[32]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[33]_i_1 
       (.I0(\xq_seen[39]_i_2_n_0 ),
        .I1(\xq_seen[33]_i_2_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[33] ),
        .O(\xq_seen[33]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair111" *) 
  LUT3 #(
    .INIT(8'hEF)) 
    \xq_seen[33]_i_2 
       (.I0(feat_save_idx[2]),
        .I1(feat_save_idx[1]),
        .I2(feat_save_idx[0]),
        .O(\xq_seen[33]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[34]_i_1 
       (.I0(\xq_seen[39]_i_2_n_0 ),
        .I1(\xq_seen[34]_i_2_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[34] ),
        .O(\xq_seen[34]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair113" *) 
  LUT3 #(
    .INIT(8'hEF)) 
    \xq_seen[34]_i_2 
       (.I0(feat_save_idx[2]),
        .I1(feat_save_idx[0]),
        .I2(feat_save_idx[1]),
        .O(\xq_seen[34]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[35]_i_1 
       (.I0(\xq_seen[39]_i_2_n_0 ),
        .I1(\xq_seen[35]_i_2_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[35] ),
        .O(\xq_seen[35]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair113" *) 
  LUT3 #(
    .INIT(8'hBF)) 
    \xq_seen[35]_i_2 
       (.I0(feat_save_idx[2]),
        .I1(feat_save_idx[0]),
        .I2(feat_save_idx[1]),
        .O(\xq_seen[35]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[36]_i_1 
       (.I0(\xq_seen[39]_i_2_n_0 ),
        .I1(\xq_seen[36]_i_2_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[36] ),
        .O(\xq_seen[36]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair62" *) 
  LUT3 #(
    .INIT(8'hFD)) 
    \xq_seen[36]_i_2 
       (.I0(feat_save_idx[2]),
        .I1(feat_save_idx[0]),
        .I2(feat_save_idx[1]),
        .O(\xq_seen[36]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[37]_i_1 
       (.I0(\xq_seen[39]_i_2_n_0 ),
        .I1(\xq_seen[37]_i_2_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[37] ),
        .O(\xq_seen[37]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair62" *) 
  LUT3 #(
    .INIT(8'hDF)) 
    \xq_seen[37]_i_2 
       (.I0(feat_save_idx[2]),
        .I1(feat_save_idx[1]),
        .I2(feat_save_idx[0]),
        .O(\xq_seen[37]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[38]_i_1 
       (.I0(\xq_seen[39]_i_2_n_0 ),
        .I1(\xq_seen[38]_i_2_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[38] ),
        .O(\xq_seen[38]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair63" *) 
  LUT3 #(
    .INIT(8'hDF)) 
    \xq_seen[38]_i_2 
       (.I0(feat_save_idx[2]),
        .I1(feat_save_idx[0]),
        .I2(feat_save_idx[1]),
        .O(\xq_seen[38]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[39]_i_1 
       (.I0(\xq_seen[39]_i_2_n_0 ),
        .I1(\xq_seen[39]_i_3_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[39] ),
        .O(\xq_seen[39]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair64" *) 
  LUT3 #(
    .INIT(8'hFD)) 
    \xq_seen[39]_i_2 
       (.I0(feat_save_idx[5]),
        .I1(feat_save_idx[3]),
        .I2(feat_save_idx[4]),
        .O(\xq_seen[39]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair63" *) 
  LUT3 #(
    .INIT(8'h7F)) 
    \xq_seen[39]_i_3 
       (.I0(feat_save_idx[2]),
        .I1(feat_save_idx[0]),
        .I2(feat_save_idx[1]),
        .O(\xq_seen[39]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'h01)) 
    \xq_seen[39]_i_4 
       (.I0(state[1]),
        .I1(state[3]),
        .I2(state[4]),
        .O(\xq_seen[39]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[3]_i_1 
       (.I0(\xq_seen[7]_i_2_n_0 ),
        .I1(\xq_seen[35]_i_2_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[3] ),
        .O(\xq_seen[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[4]_i_1 
       (.I0(\xq_seen[7]_i_2_n_0 ),
        .I1(\xq_seen[36]_i_2_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[4] ),
        .O(\xq_seen[4]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[5]_i_1 
       (.I0(\xq_seen[7]_i_2_n_0 ),
        .I1(\xq_seen[37]_i_2_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[5] ),
        .O(\xq_seen[5]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[6]_i_1 
       (.I0(\xq_seen[7]_i_2_n_0 ),
        .I1(\xq_seen[38]_i_2_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[6] ),
        .O(\xq_seen[6]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[7]_i_1 
       (.I0(\xq_seen[7]_i_2_n_0 ),
        .I1(\xq_seen[39]_i_3_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[7] ),
        .O(\xq_seen[7]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair64" *) 
  LUT3 #(
    .INIT(8'hFE)) 
    \xq_seen[7]_i_2 
       (.I0(feat_save_idx[5]),
        .I1(feat_save_idx[3]),
        .I2(feat_save_idx[4]),
        .O(\xq_seen[7]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[8]_i_1 
       (.I0(\xq_seen[15]_i_2_n_0 ),
        .I1(\xq_seen[32]_i_2_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[8] ),
        .O(\xq_seen[8]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \xq_seen[9]_i_1 
       (.I0(\xq_seen[15]_i_2_n_0 ),
        .I1(\xq_seen[33]_i_2_n_0 ),
        .I2(state[2]),
        .I3(state[0]),
        .I4(\xq_seen[39]_i_4_n_0 ),
        .I5(\xq_seen_reg_n_0_[9] ),
        .O(\xq_seen[9]_i_1_n_0 ));
  FDRE \xq_seen_reg[0] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[0]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[0] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[10] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[10]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[10] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[11] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[11]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[11] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[12] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[12]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[12] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[13] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[13]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[13] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[14] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[14]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[14] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[15] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[15]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[15] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[16] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[16]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[16] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[17] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[17]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[17] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[18] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[18]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[18] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[19] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[19]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[19] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[1] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[1]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[1] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[20] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[20]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[20] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[21] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[21]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[21] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[22] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[22]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[22] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[23] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[23]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[23] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[24] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[24]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[24] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[25] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[25]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[25] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[26] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[26]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[26] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[27] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[27]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[27] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[28] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[28]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[28] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[29] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[29]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[29] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[2] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[2]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[2] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[30] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[30]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[30] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[31] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[31]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[31] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[32] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[32]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[32] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[33] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[33]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[33] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[34] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[34]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[34] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[35] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[35]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[35] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[36] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[36]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[36] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[37] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[37]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[37] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[38] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[38]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[38] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[39] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[39]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[39] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[3] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[3]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[3] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[4] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[4]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[4] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[5] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[5]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[5] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[6] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[6]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[6] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[7] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[7]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[7] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[8] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[8]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[8] ),
        .R(out_valid_i_1_n_0));
  FDRE \xq_seen_reg[9] 
       (.C(clk),
        .CE(1'b1),
        .D(\xq_seen[9]_i_1_n_0 ),
        .Q(\xq_seen_reg_n_0_[9] ),
        .R(out_valid_i_1_n_0));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
