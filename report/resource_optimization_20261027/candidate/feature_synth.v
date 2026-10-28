// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
// Date        : Tue Oct 27 15:27:02 2026
// Host        : LAPTOP-VCCV41QO running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               D:/FPGA/sEMG-HMRS/report/resource_optimization_20261027/candidate/feature_synth.v
// Design      : emg_window_features
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CLAMP32_MAX = "48'sb000000000000000001111111111111111111111111111111" *) (* CLAMP32_MIN = "48'sb111111111111111110000000000000000000000000000000" *) (* HOP_SAMPLES = "100" *) 
(* RMS_INPUT_SHIFT = "12" *) (* SAMPLE_WIDTH = "24" *) (* SEGMENTS = "4" *) 
(* SEG_CNT_W = "7" *) (* SEG_EVENT_W = "7" *) (* SEG_PTR_W = "2" *) 
(* SSC_THRESHOLD = "24'sb000000000000000000000000" *) (* WINDOW_SAMPLES = "400" *) (* WIN_CNT_W = "9" *) 
(* WIN_EVENT_W = "9" *) (* ZC_THRESHOLD = "24'sb000000000000000000000000" *) 
(* NotValidForBitStream *)
module emg_window_features
   (clk,
    rst_n,
    sample_valid,
    sample_in,
    window_valid,
    mav_sum,
    wl_sum,
    energy_sum,
    zc_count,
    ssc_count);
  input clk;
  input rst_n;
  input sample_valid;
  input [23:0]sample_in;
  output window_valid;
  output [31:0]mav_sum;
  output [31:0]wl_sum;
  output [31:0]energy_sum;
  output [31:0]zc_count;
  output [31:0]ssc_count;

  wire \<const0> ;
  wire [24:0]abs_diff;
  wire [24:1]abs_diff1;
  wire clamp321;
  wire clamp3210_in;
  wire clear;
  wire clk;
  wire [5:5]data0;
  wire [31:0]energy_sum;
  wire \energy_sum[0]_i_1_n_0 ;
  wire \energy_sum[10]_i_1_n_0 ;
  wire \energy_sum[11]_i_1_n_0 ;
  wire \energy_sum[12]_i_1_n_0 ;
  wire \energy_sum[13]_i_1_n_0 ;
  wire \energy_sum[14]_i_1_n_0 ;
  wire \energy_sum[15]_i_1_n_0 ;
  wire \energy_sum[16]_i_1_n_0 ;
  wire \energy_sum[17]_i_1_n_0 ;
  wire \energy_sum[18]_i_1_n_0 ;
  wire \energy_sum[19]_i_1_n_0 ;
  wire \energy_sum[1]_i_1_n_0 ;
  wire \energy_sum[20]_i_1_n_0 ;
  wire \energy_sum[21]_i_1_n_0 ;
  wire \energy_sum[22]_i_1_n_0 ;
  wire \energy_sum[23]_i_1_n_0 ;
  wire \energy_sum[24]_i_1_n_0 ;
  wire \energy_sum[25]_i_1_n_0 ;
  wire \energy_sum[26]_i_1_n_0 ;
  wire \energy_sum[27]_i_1_n_0 ;
  wire \energy_sum[28]_i_1_n_0 ;
  wire \energy_sum[29]_i_1_n_0 ;
  wire \energy_sum[2]_i_1_n_0 ;
  wire \energy_sum[30]_i_1_n_0 ;
  wire \energy_sum[31]_i_10_n_0 ;
  wire \energy_sum[31]_i_11_n_0 ;
  wire \energy_sum[31]_i_12_n_0 ;
  wire \energy_sum[31]_i_13_n_0 ;
  wire \energy_sum[31]_i_14_n_0 ;
  wire \energy_sum[31]_i_15_n_0 ;
  wire \energy_sum[31]_i_16_n_0 ;
  wire \energy_sum[31]_i_17_n_0 ;
  wire \energy_sum[31]_i_18_n_0 ;
  wire \energy_sum[31]_i_19_n_0 ;
  wire \energy_sum[31]_i_1_n_0 ;
  wire \energy_sum[31]_i_20_n_0 ;
  wire \energy_sum[31]_i_21_n_0 ;
  wire \energy_sum[31]_i_22_n_0 ;
  wire \energy_sum[31]_i_23_n_0 ;
  wire \energy_sum[31]_i_24_n_0 ;
  wire \energy_sum[31]_i_25_n_0 ;
  wire \energy_sum[31]_i_5_n_0 ;
  wire \energy_sum[31]_i_6_n_0 ;
  wire \energy_sum[31]_i_8_n_0 ;
  wire \energy_sum[31]_i_9_n_0 ;
  wire \energy_sum[3]_i_1_n_0 ;
  wire \energy_sum[4]_i_1_n_0 ;
  wire \energy_sum[5]_i_1_n_0 ;
  wire \energy_sum[6]_i_1_n_0 ;
  wire \energy_sum[7]_i_1_n_0 ;
  wire \energy_sum[8]_i_1_n_0 ;
  wire \energy_sum[9]_i_1_n_0 ;
  wire \energy_sum_reg[31]_i_2_n_3 ;
  wire \energy_sum_reg[31]_i_3_n_3 ;
  wire \energy_sum_reg[31]_i_4_n_0 ;
  wire \energy_sum_reg[31]_i_4_n_1 ;
  wire \energy_sum_reg[31]_i_4_n_2 ;
  wire \energy_sum_reg[31]_i_4_n_3 ;
  wire \energy_sum_reg[31]_i_7_n_0 ;
  wire \energy_sum_reg[31]_i_7_n_1 ;
  wire \energy_sum_reg[31]_i_7_n_2 ;
  wire \energy_sum_reg[31]_i_7_n_3 ;
  wire have_prev;
  wire have_prev2;
  wire [6:0]hop_count;
  wire \hop_count[4]_i_2_n_0 ;
  wire \hop_count[4]_i_3_n_0 ;
  wire \hop_count[6]_i_1_n_0 ;
  wire \hop_count[6]_i_2_n_0 ;
  wire \hop_count[6]_i_5_n_0 ;
  wire \hop_count[6]_i_6_n_0 ;
  wire \hop_count[6]_i_7_n_0 ;
  wire \hop_count_reg_n_0_[0] ;
  wire \hop_count_reg_n_0_[1] ;
  wire \hop_count_reg_n_0_[2] ;
  wire \hop_count_reg_n_0_[3] ;
  wire \hop_count_reg_n_0_[4] ;
  wire \hop_count_reg_n_0_[5] ;
  wire \hop_count_reg_n_0_[6] ;
  wire [24:1]in;
  wire [31:0]mav_sum;
  wire \mav_sum[0]_i_1_n_0 ;
  wire \mav_sum[10]_i_1_n_0 ;
  wire \mav_sum[11]_i_1_n_0 ;
  wire \mav_sum[12]_i_1_n_0 ;
  wire \mav_sum[13]_i_1_n_0 ;
  wire \mav_sum[14]_i_1_n_0 ;
  wire \mav_sum[15]_i_1_n_0 ;
  wire \mav_sum[16]_i_1_n_0 ;
  wire \mav_sum[17]_i_1_n_0 ;
  wire \mav_sum[18]_i_1_n_0 ;
  wire \mav_sum[19]_i_1_n_0 ;
  wire \mav_sum[1]_i_1_n_0 ;
  wire \mav_sum[20]_i_1_n_0 ;
  wire \mav_sum[21]_i_1_n_0 ;
  wire \mav_sum[22]_i_1_n_0 ;
  wire \mav_sum[23]_i_1_n_0 ;
  wire \mav_sum[24]_i_1_n_0 ;
  wire \mav_sum[25]_i_1_n_0 ;
  wire \mav_sum[26]_i_1_n_0 ;
  wire \mav_sum[27]_i_1_n_0 ;
  wire \mav_sum[28]_i_1_n_0 ;
  wire \mav_sum[29]_i_1_n_0 ;
  wire \mav_sum[2]_i_1_n_0 ;
  wire \mav_sum[30]_i_1_n_0 ;
  wire \mav_sum[30]_i_2_n_0 ;
  wire \mav_sum[30]_i_4_n_0 ;
  wire \mav_sum[31]_i_10_n_0 ;
  wire \mav_sum[31]_i_11_n_0 ;
  wire \mav_sum[31]_i_12_n_0 ;
  wire \mav_sum[31]_i_13_n_0 ;
  wire \mav_sum[31]_i_14_n_0 ;
  wire \mav_sum[31]_i_15_n_0 ;
  wire \mav_sum[31]_i_16_n_0 ;
  wire \mav_sum[31]_i_17_n_0 ;
  wire \mav_sum[31]_i_18_n_0 ;
  wire \mav_sum[31]_i_19_n_0 ;
  wire \mav_sum[31]_i_1_n_0 ;
  wire \mav_sum[31]_i_20_n_0 ;
  wire \mav_sum[31]_i_21_n_0 ;
  wire \mav_sum[31]_i_22_n_0 ;
  wire \mav_sum[31]_i_23_n_0 ;
  wire \mav_sum[31]_i_24_n_0 ;
  wire \mav_sum[31]_i_25_n_0 ;
  wire \mav_sum[31]_i_5_n_0 ;
  wire \mav_sum[31]_i_6_n_0 ;
  wire \mav_sum[31]_i_8_n_0 ;
  wire \mav_sum[31]_i_9_n_0 ;
  wire \mav_sum[3]_i_1_n_0 ;
  wire \mav_sum[4]_i_1_n_0 ;
  wire \mav_sum[5]_i_1_n_0 ;
  wire \mav_sum[6]_i_1_n_0 ;
  wire \mav_sum[7]_i_1_n_0 ;
  wire \mav_sum[8]_i_1_n_0 ;
  wire \mav_sum[9]_i_1_n_0 ;
  wire \mav_sum_reg[31]_i_4_n_0 ;
  wire \mav_sum_reg[31]_i_4_n_1 ;
  wire \mav_sum_reg[31]_i_4_n_2 ;
  wire \mav_sum_reg[31]_i_4_n_3 ;
  wire \mav_sum_reg[31]_i_7_n_0 ;
  wire \mav_sum_reg[31]_i_7_n_1 ;
  wire \mav_sum_reg[31]_i_7_n_2 ;
  wire \mav_sum_reg[31]_i_7_n_3 ;
  wire [39:0]next_energy;
  wire \next_energy[0]_i_1_n_0 ;
  wire \next_energy[10]_i_1_n_0 ;
  wire \next_energy[11]_i_1_n_0 ;
  wire \next_energy[12]_i_1_n_0 ;
  wire \next_energy[13]_i_1_n_0 ;
  wire \next_energy[14]_i_1_n_0 ;
  wire \next_energy[15]_i_1_n_0 ;
  wire \next_energy[16]_i_1_n_0 ;
  wire \next_energy[17]_i_1_n_0 ;
  wire \next_energy[18]_i_1_n_0 ;
  wire \next_energy[19]_i_1_n_0 ;
  wire \next_energy[1]_i_1_n_0 ;
  wire \next_energy[20]_i_1_n_0 ;
  wire \next_energy[21]_i_1_n_0 ;
  wire \next_energy[22]_i_1_n_0 ;
  wire \next_energy[23]_i_1_n_0 ;
  wire \next_energy[24]_i_1_n_0 ;
  wire \next_energy[25]_i_1_n_0 ;
  wire \next_energy[26]_i_1_n_0 ;
  wire \next_energy[27]_i_1_n_0 ;
  wire \next_energy[28]_i_1_n_0 ;
  wire \next_energy[29]_i_1_n_0 ;
  wire \next_energy[2]_i_1_n_0 ;
  wire \next_energy[30]_i_1_n_0 ;
  wire \next_energy[31]_i_1_n_0 ;
  wire \next_energy[32]_i_1_n_0 ;
  wire \next_energy[33]_i_1_n_0 ;
  wire \next_energy[34]_i_1_n_0 ;
  wire \next_energy[35]_i_1_n_0 ;
  wire \next_energy[36]_i_1_n_0 ;
  wire \next_energy[37]_i_1_n_0 ;
  wire \next_energy[38]_i_1_n_0 ;
  wire \next_energy[39]_i_1_n_0 ;
  wire \next_energy[3]_i_1_n_0 ;
  wire \next_energy[4]_i_1_n_0 ;
  wire \next_energy[5]_i_1_n_0 ;
  wire \next_energy[6]_i_1_n_0 ;
  wire \next_energy[7]_i_1_n_0 ;
  wire \next_energy[8]_i_1_n_0 ;
  wire \next_energy[9]_i_1_n_0 ;
  wire [39:0]next_mav;
  wire \next_mav[0]_i_1_n_0 ;
  wire \next_mav[10]_i_1_n_0 ;
  wire \next_mav[11]_i_1_n_0 ;
  wire \next_mav[12]_i_1_n_0 ;
  wire \next_mav[13]_i_1_n_0 ;
  wire \next_mav[14]_i_1_n_0 ;
  wire \next_mav[15]_i_1_n_0 ;
  wire \next_mav[16]_i_1_n_0 ;
  wire \next_mav[17]_i_1_n_0 ;
  wire \next_mav[18]_i_1_n_0 ;
  wire \next_mav[19]_i_1_n_0 ;
  wire \next_mav[1]_i_1_n_0 ;
  wire \next_mav[20]_i_1_n_0 ;
  wire \next_mav[21]_i_1_n_0 ;
  wire \next_mav[22]_i_1_n_0 ;
  wire \next_mav[23]_i_1_n_0 ;
  wire \next_mav[24]_i_1_n_0 ;
  wire \next_mav[25]_i_1_n_0 ;
  wire \next_mav[26]_i_1_n_0 ;
  wire \next_mav[27]_i_1_n_0 ;
  wire \next_mav[28]_i_1_n_0 ;
  wire \next_mav[29]_i_1_n_0 ;
  wire \next_mav[2]_i_1_n_0 ;
  wire \next_mav[30]_i_1_n_0 ;
  wire \next_mav[31]_i_1_n_0 ;
  wire \next_mav[32]_i_1_n_0 ;
  wire \next_mav[33]_i_1_n_0 ;
  wire \next_mav[34]_i_1_n_0 ;
  wire \next_mav[35]_i_1_n_0 ;
  wire \next_mav[36]_i_1_n_0 ;
  wire \next_mav[37]_i_1_n_0 ;
  wire \next_mav[38]_i_1_n_0 ;
  wire \next_mav[39]_i_2_n_0 ;
  wire \next_mav[3]_i_1_n_0 ;
  wire \next_mav[4]_i_1_n_0 ;
  wire \next_mav[5]_i_1_n_0 ;
  wire \next_mav[6]_i_1_n_0 ;
  wire \next_mav[7]_i_1_n_0 ;
  wire \next_mav[8]_i_1_n_0 ;
  wire \next_mav[9]_i_1_n_0 ;
  wire [8:0]next_ssc;
  wire [39:0]next_wl;
  wire \next_wl[0]_i_1_n_0 ;
  wire \next_wl[10]_i_1_n_0 ;
  wire \next_wl[11]_i_1_n_0 ;
  wire \next_wl[12]_i_1_n_0 ;
  wire \next_wl[13]_i_1_n_0 ;
  wire \next_wl[14]_i_1_n_0 ;
  wire \next_wl[15]_i_1_n_0 ;
  wire \next_wl[16]_i_1_n_0 ;
  wire \next_wl[17]_i_1_n_0 ;
  wire \next_wl[18]_i_1_n_0 ;
  wire \next_wl[19]_i_1_n_0 ;
  wire \next_wl[1]_i_1_n_0 ;
  wire \next_wl[20]_i_1_n_0 ;
  wire \next_wl[21]_i_1_n_0 ;
  wire \next_wl[22]_i_1_n_0 ;
  wire \next_wl[23]_i_1_n_0 ;
  wire \next_wl[24]_i_1_n_0 ;
  wire \next_wl[25]_i_1_n_0 ;
  wire \next_wl[26]_i_1_n_0 ;
  wire \next_wl[27]_i_1_n_0 ;
  wire \next_wl[28]_i_1_n_0 ;
  wire \next_wl[29]_i_1_n_0 ;
  wire \next_wl[2]_i_1_n_0 ;
  wire \next_wl[30]_i_1_n_0 ;
  wire \next_wl[31]_i_1_n_0 ;
  wire \next_wl[32]_i_1_n_0 ;
  wire \next_wl[33]_i_1_n_0 ;
  wire \next_wl[34]_i_1_n_0 ;
  wire \next_wl[35]_i_1_n_0 ;
  wire \next_wl[36]_i_1_n_0 ;
  wire \next_wl[37]_i_1_n_0 ;
  wire \next_wl[38]_i_1_n_0 ;
  wire \next_wl[39]_i_1_n_0 ;
  wire \next_wl[3]_i_1_n_0 ;
  wire \next_wl[4]_i_1_n_0 ;
  wire \next_wl[5]_i_1_n_0 ;
  wire \next_wl[6]_i_1_n_0 ;
  wire \next_wl[7]_i_1_n_0 ;
  wire \next_wl[8]_i_1_n_0 ;
  wire \next_wl[9]_i_1_n_0 ;
  wire [0:0]next_zc;
  wire \next_zc_reg_n_0_[0] ;
  wire \next_zc_reg_n_0_[1] ;
  wire \next_zc_reg_n_0_[2] ;
  wire \next_zc_reg_n_0_[3] ;
  wire \next_zc_reg_n_0_[4] ;
  wire \next_zc_reg_n_0_[5] ;
  wire \next_zc_reg_n_0_[6] ;
  wire \next_zc_reg_n_0_[7] ;
  wire \next_zc_reg_n_0_[8] ;
  wire [6:0]p_0_in;
  wire p_0_in0_in;
  wire [8:0]p_0_in__0;
  wire [23:0]prev2;
  wire \prev_reg_n_0_[0] ;
  wire \prev_reg_n_0_[10] ;
  wire \prev_reg_n_0_[11] ;
  wire \prev_reg_n_0_[12] ;
  wire \prev_reg_n_0_[13] ;
  wire \prev_reg_n_0_[14] ;
  wire \prev_reg_n_0_[15] ;
  wire \prev_reg_n_0_[16] ;
  wire \prev_reg_n_0_[17] ;
  wire \prev_reg_n_0_[18] ;
  wire \prev_reg_n_0_[19] ;
  wire \prev_reg_n_0_[1] ;
  wire \prev_reg_n_0_[20] ;
  wire \prev_reg_n_0_[21] ;
  wire \prev_reg_n_0_[22] ;
  wire \prev_reg_n_0_[2] ;
  wire \prev_reg_n_0_[3] ;
  wire \prev_reg_n_0_[4] ;
  wire \prev_reg_n_0_[5] ;
  wire \prev_reg_n_0_[6] ;
  wire \prev_reg_n_0_[7] ;
  wire \prev_reg_n_0_[8] ;
  wire \prev_reg_n_0_[9] ;
  wire [0:0]prime_count;
  wire \prime_count[2]_i_1_n_0 ;
  wire \prime_count[6]_i_2_n_0 ;
  wire \prime_count[8]_i_1_n_0 ;
  wire \prime_count[8]_i_3_n_0 ;
  wire [8:0]prime_count_reg;
  wire priming_i_1_n_0;
  wire priming_reg_n_0;
  wire [31:0]ring_energy;
  wire \ring_energy[3][11]_i_2_n_0 ;
  wire \ring_energy[3][11]_i_3_n_0 ;
  wire \ring_energy[3][11]_i_4_n_0 ;
  wire \ring_energy[3][11]_i_5_n_0 ;
  wire \ring_energy[3][15]_i_2_n_0 ;
  wire \ring_energy[3][15]_i_3_n_0 ;
  wire \ring_energy[3][15]_i_4_n_0 ;
  wire \ring_energy[3][15]_i_5_n_0 ;
  wire \ring_energy[3][19]_i_2_n_0 ;
  wire \ring_energy[3][19]_i_3_n_0 ;
  wire \ring_energy[3][19]_i_4_n_0 ;
  wire \ring_energy[3][19]_i_5_n_0 ;
  wire \ring_energy[3][23]_i_2_n_0 ;
  wire \ring_energy[3][23]_i_3_n_0 ;
  wire \ring_energy[3][23]_i_4_n_0 ;
  wire \ring_energy[3][23]_i_5_n_0 ;
  wire \ring_energy[3][27]_i_2_n_0 ;
  wire \ring_energy[3][27]_i_3_n_0 ;
  wire \ring_energy[3][27]_i_4_n_0 ;
  wire \ring_energy[3][27]_i_5_n_0 ;
  wire \ring_energy[3][31]_i_2_n_0 ;
  wire \ring_energy[3][31]_i_3_n_0 ;
  wire \ring_energy[3][31]_i_4_n_0 ;
  wire \ring_energy[3][31]_i_5_n_0 ;
  wire \ring_energy[3][3]_i_2_n_0 ;
  wire \ring_energy[3][3]_i_3_n_0 ;
  wire \ring_energy[3][3]_i_4_n_0 ;
  wire \ring_energy[3][3]_i_5_n_0 ;
  wire \ring_energy[3][7]_i_2_n_0 ;
  wire \ring_energy[3][7]_i_3_n_0 ;
  wire \ring_energy[3][7]_i_4_n_0 ;
  wire \ring_energy[3][7]_i_5_n_0 ;
  wire [31:0]\ring_energy_reg[0] ;
  wire [31:0]\ring_energy_reg[1] ;
  wire [31:0]\ring_energy_reg[2] ;
  wire [31:0]\ring_energy_reg[3] ;
  wire \ring_energy_reg[3][11]_i_1_n_0 ;
  wire \ring_energy_reg[3][11]_i_1_n_1 ;
  wire \ring_energy_reg[3][11]_i_1_n_2 ;
  wire \ring_energy_reg[3][11]_i_1_n_3 ;
  wire \ring_energy_reg[3][11]_i_1_n_4 ;
  wire \ring_energy_reg[3][11]_i_1_n_5 ;
  wire \ring_energy_reg[3][11]_i_1_n_6 ;
  wire \ring_energy_reg[3][11]_i_1_n_7 ;
  wire \ring_energy_reg[3][15]_i_1_n_0 ;
  wire \ring_energy_reg[3][15]_i_1_n_1 ;
  wire \ring_energy_reg[3][15]_i_1_n_2 ;
  wire \ring_energy_reg[3][15]_i_1_n_3 ;
  wire \ring_energy_reg[3][15]_i_1_n_4 ;
  wire \ring_energy_reg[3][15]_i_1_n_5 ;
  wire \ring_energy_reg[3][15]_i_1_n_6 ;
  wire \ring_energy_reg[3][15]_i_1_n_7 ;
  wire \ring_energy_reg[3][19]_i_1_n_0 ;
  wire \ring_energy_reg[3][19]_i_1_n_1 ;
  wire \ring_energy_reg[3][19]_i_1_n_2 ;
  wire \ring_energy_reg[3][19]_i_1_n_3 ;
  wire \ring_energy_reg[3][19]_i_1_n_4 ;
  wire \ring_energy_reg[3][19]_i_1_n_5 ;
  wire \ring_energy_reg[3][19]_i_1_n_6 ;
  wire \ring_energy_reg[3][19]_i_1_n_7 ;
  wire \ring_energy_reg[3][23]_i_1_n_0 ;
  wire \ring_energy_reg[3][23]_i_1_n_1 ;
  wire \ring_energy_reg[3][23]_i_1_n_2 ;
  wire \ring_energy_reg[3][23]_i_1_n_3 ;
  wire \ring_energy_reg[3][23]_i_1_n_4 ;
  wire \ring_energy_reg[3][23]_i_1_n_5 ;
  wire \ring_energy_reg[3][23]_i_1_n_6 ;
  wire \ring_energy_reg[3][23]_i_1_n_7 ;
  wire \ring_energy_reg[3][27]_i_1_n_0 ;
  wire \ring_energy_reg[3][27]_i_1_n_1 ;
  wire \ring_energy_reg[3][27]_i_1_n_2 ;
  wire \ring_energy_reg[3][27]_i_1_n_3 ;
  wire \ring_energy_reg[3][27]_i_1_n_4 ;
  wire \ring_energy_reg[3][27]_i_1_n_5 ;
  wire \ring_energy_reg[3][27]_i_1_n_6 ;
  wire \ring_energy_reg[3][27]_i_1_n_7 ;
  wire \ring_energy_reg[3][31]_i_1_n_1 ;
  wire \ring_energy_reg[3][31]_i_1_n_2 ;
  wire \ring_energy_reg[3][31]_i_1_n_3 ;
  wire \ring_energy_reg[3][31]_i_1_n_4 ;
  wire \ring_energy_reg[3][31]_i_1_n_5 ;
  wire \ring_energy_reg[3][31]_i_1_n_6 ;
  wire \ring_energy_reg[3][31]_i_1_n_7 ;
  wire \ring_energy_reg[3][3]_i_1_n_0 ;
  wire \ring_energy_reg[3][3]_i_1_n_1 ;
  wire \ring_energy_reg[3][3]_i_1_n_2 ;
  wire \ring_energy_reg[3][3]_i_1_n_3 ;
  wire \ring_energy_reg[3][3]_i_1_n_4 ;
  wire \ring_energy_reg[3][3]_i_1_n_5 ;
  wire \ring_energy_reg[3][3]_i_1_n_6 ;
  wire \ring_energy_reg[3][3]_i_1_n_7 ;
  wire \ring_energy_reg[3][7]_i_1_n_0 ;
  wire \ring_energy_reg[3][7]_i_1_n_1 ;
  wire \ring_energy_reg[3][7]_i_1_n_2 ;
  wire \ring_energy_reg[3][7]_i_1_n_3 ;
  wire \ring_energy_reg[3][7]_i_1_n_4 ;
  wire \ring_energy_reg[3][7]_i_1_n_5 ;
  wire \ring_energy_reg[3][7]_i_1_n_6 ;
  wire \ring_energy_reg[3][7]_i_1_n_7 ;
  wire [0:0]ring_mav;
  wire \ring_mav[1][31]_i_1_n_0 ;
  wire \ring_mav[2][31]_i_1_n_0 ;
  wire \ring_mav[3][11]_i_10_n_0 ;
  wire \ring_mav[3][11]_i_2_n_0 ;
  wire \ring_mav[3][11]_i_3_n_0 ;
  wire \ring_mav[3][11]_i_4_n_0 ;
  wire \ring_mav[3][11]_i_5_n_0 ;
  wire \ring_mav[3][11]_i_7_n_0 ;
  wire \ring_mav[3][11]_i_8_n_0 ;
  wire \ring_mav[3][11]_i_9_n_0 ;
  wire \ring_mav[3][15]_i_10_n_0 ;
  wire \ring_mav[3][15]_i_2_n_0 ;
  wire \ring_mav[3][15]_i_3_n_0 ;
  wire \ring_mav[3][15]_i_4_n_0 ;
  wire \ring_mav[3][15]_i_5_n_0 ;
  wire \ring_mav[3][15]_i_7_n_0 ;
  wire \ring_mav[3][15]_i_8_n_0 ;
  wire \ring_mav[3][15]_i_9_n_0 ;
  wire \ring_mav[3][19]_i_10_n_0 ;
  wire \ring_mav[3][19]_i_2_n_0 ;
  wire \ring_mav[3][19]_i_3_n_0 ;
  wire \ring_mav[3][19]_i_4_n_0 ;
  wire \ring_mav[3][19]_i_5_n_0 ;
  wire \ring_mav[3][19]_i_7_n_0 ;
  wire \ring_mav[3][19]_i_8_n_0 ;
  wire \ring_mav[3][19]_i_9_n_0 ;
  wire \ring_mav[3][23]_i_10_n_0 ;
  wire \ring_mav[3][23]_i_2_n_0 ;
  wire \ring_mav[3][23]_i_3_n_0 ;
  wire \ring_mav[3][23]_i_4_n_0 ;
  wire \ring_mav[3][23]_i_5_n_0 ;
  wire \ring_mav[3][23]_i_7_n_0 ;
  wire \ring_mav[3][23]_i_8_n_0 ;
  wire \ring_mav[3][23]_i_9_n_0 ;
  wire \ring_mav[3][27]_i_2_n_0 ;
  wire \ring_mav[3][27]_i_4_n_0 ;
  wire \ring_mav[3][27]_i_5_n_0 ;
  wire \ring_mav[3][27]_i_6_n_0 ;
  wire \ring_mav[3][31]_i_1_n_0 ;
  wire \ring_mav[3][3]_i_2_n_0 ;
  wire \ring_mav[3][3]_i_3_n_0 ;
  wire \ring_mav[3][3]_i_4_n_0 ;
  wire \ring_mav[3][3]_i_5_n_0 ;
  wire \ring_mav[3][7]_i_10_n_0 ;
  wire \ring_mav[3][7]_i_11_n_0 ;
  wire \ring_mav[3][7]_i_2_n_0 ;
  wire \ring_mav[3][7]_i_3_n_0 ;
  wire \ring_mav[3][7]_i_4_n_0 ;
  wire \ring_mav[3][7]_i_5_n_0 ;
  wire \ring_mav[3][7]_i_7_n_0 ;
  wire \ring_mav[3][7]_i_8_n_0 ;
  wire \ring_mav[3][7]_i_9_n_0 ;
  wire [31:0]\ring_mav_reg[0] ;
  wire [31:0]\ring_mav_reg[1] ;
  wire [31:0]\ring_mav_reg[2] ;
  wire [31:0]\ring_mav_reg[3] ;
  wire \ring_mav_reg[3][11]_i_1_n_0 ;
  wire \ring_mav_reg[3][11]_i_1_n_1 ;
  wire \ring_mav_reg[3][11]_i_1_n_2 ;
  wire \ring_mav_reg[3][11]_i_1_n_3 ;
  wire \ring_mav_reg[3][11]_i_1_n_4 ;
  wire \ring_mav_reg[3][11]_i_1_n_5 ;
  wire \ring_mav_reg[3][11]_i_1_n_6 ;
  wire \ring_mav_reg[3][11]_i_1_n_7 ;
  wire \ring_mav_reg[3][11]_i_6_n_0 ;
  wire \ring_mav_reg[3][11]_i_6_n_1 ;
  wire \ring_mav_reg[3][11]_i_6_n_2 ;
  wire \ring_mav_reg[3][11]_i_6_n_3 ;
  wire \ring_mav_reg[3][15]_i_1_n_0 ;
  wire \ring_mav_reg[3][15]_i_1_n_1 ;
  wire \ring_mav_reg[3][15]_i_1_n_2 ;
  wire \ring_mav_reg[3][15]_i_1_n_3 ;
  wire \ring_mav_reg[3][15]_i_1_n_4 ;
  wire \ring_mav_reg[3][15]_i_1_n_5 ;
  wire \ring_mav_reg[3][15]_i_1_n_6 ;
  wire \ring_mav_reg[3][15]_i_1_n_7 ;
  wire \ring_mav_reg[3][15]_i_6_n_0 ;
  wire \ring_mav_reg[3][15]_i_6_n_1 ;
  wire \ring_mav_reg[3][15]_i_6_n_2 ;
  wire \ring_mav_reg[3][15]_i_6_n_3 ;
  wire \ring_mav_reg[3][19]_i_1_n_0 ;
  wire \ring_mav_reg[3][19]_i_1_n_1 ;
  wire \ring_mav_reg[3][19]_i_1_n_2 ;
  wire \ring_mav_reg[3][19]_i_1_n_3 ;
  wire \ring_mav_reg[3][19]_i_1_n_4 ;
  wire \ring_mav_reg[3][19]_i_1_n_5 ;
  wire \ring_mav_reg[3][19]_i_1_n_6 ;
  wire \ring_mav_reg[3][19]_i_1_n_7 ;
  wire \ring_mav_reg[3][19]_i_6_n_0 ;
  wire \ring_mav_reg[3][19]_i_6_n_1 ;
  wire \ring_mav_reg[3][19]_i_6_n_2 ;
  wire \ring_mav_reg[3][19]_i_6_n_3 ;
  wire \ring_mav_reg[3][23]_i_1_n_0 ;
  wire \ring_mav_reg[3][23]_i_1_n_1 ;
  wire \ring_mav_reg[3][23]_i_1_n_2 ;
  wire \ring_mav_reg[3][23]_i_1_n_3 ;
  wire \ring_mav_reg[3][23]_i_1_n_4 ;
  wire \ring_mav_reg[3][23]_i_1_n_5 ;
  wire \ring_mav_reg[3][23]_i_1_n_6 ;
  wire \ring_mav_reg[3][23]_i_1_n_7 ;
  wire \ring_mav_reg[3][23]_i_6_n_0 ;
  wire \ring_mav_reg[3][23]_i_6_n_1 ;
  wire \ring_mav_reg[3][23]_i_6_n_2 ;
  wire \ring_mav_reg[3][23]_i_6_n_3 ;
  wire \ring_mav_reg[3][27]_i_1_n_0 ;
  wire \ring_mav_reg[3][27]_i_1_n_1 ;
  wire \ring_mav_reg[3][27]_i_1_n_2 ;
  wire \ring_mav_reg[3][27]_i_1_n_3 ;
  wire \ring_mav_reg[3][27]_i_1_n_4 ;
  wire \ring_mav_reg[3][27]_i_1_n_5 ;
  wire \ring_mav_reg[3][27]_i_1_n_6 ;
  wire \ring_mav_reg[3][27]_i_1_n_7 ;
  wire \ring_mav_reg[3][27]_i_3_n_0 ;
  wire \ring_mav_reg[3][27]_i_3_n_2 ;
  wire \ring_mav_reg[3][27]_i_3_n_3 ;
  wire \ring_mav_reg[3][31]_i_2_n_1 ;
  wire \ring_mav_reg[3][31]_i_2_n_2 ;
  wire \ring_mav_reg[3][31]_i_2_n_3 ;
  wire \ring_mav_reg[3][31]_i_2_n_4 ;
  wire \ring_mav_reg[3][31]_i_2_n_5 ;
  wire \ring_mav_reg[3][31]_i_2_n_6 ;
  wire \ring_mav_reg[3][31]_i_2_n_7 ;
  wire \ring_mav_reg[3][3]_i_1_n_0 ;
  wire \ring_mav_reg[3][3]_i_1_n_1 ;
  wire \ring_mav_reg[3][3]_i_1_n_2 ;
  wire \ring_mav_reg[3][3]_i_1_n_3 ;
  wire \ring_mav_reg[3][3]_i_1_n_4 ;
  wire \ring_mav_reg[3][3]_i_1_n_5 ;
  wire \ring_mav_reg[3][3]_i_1_n_6 ;
  wire \ring_mav_reg[3][3]_i_1_n_7 ;
  wire \ring_mav_reg[3][7]_i_1_n_0 ;
  wire \ring_mav_reg[3][7]_i_1_n_1 ;
  wire \ring_mav_reg[3][7]_i_1_n_2 ;
  wire \ring_mav_reg[3][7]_i_1_n_3 ;
  wire \ring_mav_reg[3][7]_i_1_n_4 ;
  wire \ring_mav_reg[3][7]_i_1_n_5 ;
  wire \ring_mav_reg[3][7]_i_1_n_6 ;
  wire \ring_mav_reg[3][7]_i_1_n_7 ;
  wire \ring_mav_reg[3][7]_i_6_n_0 ;
  wire \ring_mav_reg[3][7]_i_6_n_1 ;
  wire \ring_mav_reg[3][7]_i_6_n_2 ;
  wire \ring_mav_reg[3][7]_i_6_n_3 ;
  wire [6:0]ring_ssc;
  wire \ring_ssc[3][0]_i_1_n_0 ;
  wire \ring_ssc[3][1]_i_1_n_0 ;
  wire \ring_ssc[3][2]_i_1_n_0 ;
  wire \ring_ssc[3][3]_i_1_n_0 ;
  wire \ring_ssc[3][4]_i_10_n_0 ;
  wire \ring_ssc[3][4]_i_11_n_0 ;
  wire \ring_ssc[3][4]_i_12_n_0 ;
  wire \ring_ssc[3][4]_i_15_n_0 ;
  wire \ring_ssc[3][4]_i_16_n_0 ;
  wire \ring_ssc[3][4]_i_17_n_0 ;
  wire \ring_ssc[3][4]_i_18_n_0 ;
  wire \ring_ssc[3][4]_i_19_n_0 ;
  wire \ring_ssc[3][4]_i_1_n_0 ;
  wire \ring_ssc[3][4]_i_20_n_0 ;
  wire \ring_ssc[3][4]_i_21_n_0 ;
  wire \ring_ssc[3][4]_i_22_n_0 ;
  wire \ring_ssc[3][4]_i_26_n_0 ;
  wire \ring_ssc[3][4]_i_27_n_0 ;
  wire \ring_ssc[3][4]_i_28_n_0 ;
  wire \ring_ssc[3][4]_i_29_n_0 ;
  wire \ring_ssc[3][4]_i_30_n_0 ;
  wire \ring_ssc[3][4]_i_31_n_0 ;
  wire \ring_ssc[3][4]_i_32_n_0 ;
  wire \ring_ssc[3][4]_i_33_n_0 ;
  wire \ring_ssc[3][4]_i_34_n_0 ;
  wire \ring_ssc[3][4]_i_35_n_0 ;
  wire \ring_ssc[3][4]_i_36_n_0 ;
  wire \ring_ssc[3][4]_i_37_n_0 ;
  wire \ring_ssc[3][4]_i_38_n_0 ;
  wire \ring_ssc[3][4]_i_43_n_0 ;
  wire \ring_ssc[3][4]_i_44_n_0 ;
  wire \ring_ssc[3][4]_i_45_n_0 ;
  wire \ring_ssc[3][4]_i_46_n_0 ;
  wire \ring_ssc[3][4]_i_47_n_0 ;
  wire \ring_ssc[3][4]_i_48_n_0 ;
  wire \ring_ssc[3][4]_i_49_n_0 ;
  wire \ring_ssc[3][4]_i_50_n_0 ;
  wire \ring_ssc[3][4]_i_51_n_0 ;
  wire \ring_ssc[3][4]_i_52_n_0 ;
  wire \ring_ssc[3][4]_i_53_n_0 ;
  wire \ring_ssc[3][4]_i_58_n_0 ;
  wire \ring_ssc[3][4]_i_59_n_0 ;
  wire \ring_ssc[3][4]_i_60_n_0 ;
  wire \ring_ssc[3][4]_i_61_n_0 ;
  wire \ring_ssc[3][4]_i_62_n_0 ;
  wire \ring_ssc[3][4]_i_63_n_0 ;
  wire \ring_ssc[3][4]_i_64_n_0 ;
  wire \ring_ssc[3][4]_i_65_n_0 ;
  wire \ring_ssc[3][4]_i_66_n_0 ;
  wire \ring_ssc[3][4]_i_67_n_0 ;
  wire \ring_ssc[3][4]_i_68_n_0 ;
  wire \ring_ssc[3][4]_i_69_n_0 ;
  wire \ring_ssc[3][4]_i_6_n_0 ;
  wire \ring_ssc[3][4]_i_70_n_0 ;
  wire \ring_ssc[3][4]_i_71_n_0 ;
  wire \ring_ssc[3][4]_i_72_n_0 ;
  wire \ring_ssc[3][4]_i_73_n_0 ;
  wire \ring_ssc[3][4]_i_74_n_0 ;
  wire \ring_ssc[3][4]_i_75_n_0 ;
  wire \ring_ssc[3][4]_i_76_n_0 ;
  wire \ring_ssc[3][4]_i_77_n_0 ;
  wire \ring_ssc[3][4]_i_78_n_0 ;
  wire \ring_ssc[3][4]_i_79_n_0 ;
  wire \ring_ssc[3][4]_i_7_n_0 ;
  wire \ring_ssc[3][4]_i_80_n_0 ;
  wire \ring_ssc[3][4]_i_81_n_0 ;
  wire \ring_ssc[3][4]_i_82_n_0 ;
  wire \ring_ssc[3][4]_i_83_n_0 ;
  wire \ring_ssc[3][4]_i_84_n_0 ;
  wire \ring_ssc[3][4]_i_85_n_0 ;
  wire \ring_ssc[3][4]_i_86_n_0 ;
  wire \ring_ssc[3][4]_i_87_n_0 ;
  wire \ring_ssc[3][4]_i_88_n_0 ;
  wire \ring_ssc[3][4]_i_89_n_0 ;
  wire \ring_ssc[3][4]_i_8_n_0 ;
  wire \ring_ssc[3][4]_i_90_n_0 ;
  wire \ring_ssc[3][4]_i_9_n_0 ;
  wire \ring_ssc[3][5]_i_1_n_0 ;
  wire \ring_ssc[3][6]_i_1_n_0 ;
  wire \ring_ssc[3][6]_i_2_n_0 ;
  wire \ring_ssc_reg[3][4]_i_13_n_0 ;
  wire \ring_ssc_reg[3][4]_i_13_n_1 ;
  wire \ring_ssc_reg[3][4]_i_13_n_2 ;
  wire \ring_ssc_reg[3][4]_i_13_n_3 ;
  wire \ring_ssc_reg[3][4]_i_13_n_4 ;
  wire \ring_ssc_reg[3][4]_i_13_n_5 ;
  wire \ring_ssc_reg[3][4]_i_13_n_6 ;
  wire \ring_ssc_reg[3][4]_i_13_n_7 ;
  wire \ring_ssc_reg[3][4]_i_14_n_0 ;
  wire \ring_ssc_reg[3][4]_i_14_n_1 ;
  wire \ring_ssc_reg[3][4]_i_14_n_2 ;
  wire \ring_ssc_reg[3][4]_i_14_n_3 ;
  wire \ring_ssc_reg[3][4]_i_23_n_1 ;
  wire \ring_ssc_reg[3][4]_i_23_n_2 ;
  wire \ring_ssc_reg[3][4]_i_23_n_3 ;
  wire \ring_ssc_reg[3][4]_i_24_n_0 ;
  wire \ring_ssc_reg[3][4]_i_24_n_1 ;
  wire \ring_ssc_reg[3][4]_i_24_n_2 ;
  wire \ring_ssc_reg[3][4]_i_24_n_3 ;
  wire \ring_ssc_reg[3][4]_i_25_n_0 ;
  wire \ring_ssc_reg[3][4]_i_25_n_1 ;
  wire \ring_ssc_reg[3][4]_i_25_n_2 ;
  wire \ring_ssc_reg[3][4]_i_25_n_3 ;
  wire \ring_ssc_reg[3][4]_i_25_n_4 ;
  wire \ring_ssc_reg[3][4]_i_25_n_5 ;
  wire \ring_ssc_reg[3][4]_i_25_n_6 ;
  wire \ring_ssc_reg[3][4]_i_25_n_7 ;
  wire \ring_ssc_reg[3][4]_i_39_n_0 ;
  wire \ring_ssc_reg[3][4]_i_39_n_1 ;
  wire \ring_ssc_reg[3][4]_i_39_n_2 ;
  wire \ring_ssc_reg[3][4]_i_39_n_3 ;
  wire \ring_ssc_reg[3][4]_i_3_n_0 ;
  wire \ring_ssc_reg[3][4]_i_3_n_1 ;
  wire \ring_ssc_reg[3][4]_i_3_n_2 ;
  wire \ring_ssc_reg[3][4]_i_3_n_3 ;
  wire \ring_ssc_reg[3][4]_i_40_n_0 ;
  wire \ring_ssc_reg[3][4]_i_40_n_1 ;
  wire \ring_ssc_reg[3][4]_i_40_n_2 ;
  wire \ring_ssc_reg[3][4]_i_40_n_3 ;
  wire \ring_ssc_reg[3][4]_i_40_n_4 ;
  wire \ring_ssc_reg[3][4]_i_40_n_5 ;
  wire \ring_ssc_reg[3][4]_i_40_n_6 ;
  wire \ring_ssc_reg[3][4]_i_40_n_7 ;
  wire \ring_ssc_reg[3][4]_i_41_n_0 ;
  wire \ring_ssc_reg[3][4]_i_41_n_1 ;
  wire \ring_ssc_reg[3][4]_i_41_n_2 ;
  wire \ring_ssc_reg[3][4]_i_41_n_3 ;
  wire \ring_ssc_reg[3][4]_i_42_n_0 ;
  wire \ring_ssc_reg[3][4]_i_42_n_1 ;
  wire \ring_ssc_reg[3][4]_i_42_n_2 ;
  wire \ring_ssc_reg[3][4]_i_42_n_3 ;
  wire \ring_ssc_reg[3][4]_i_42_n_4 ;
  wire \ring_ssc_reg[3][4]_i_42_n_5 ;
  wire \ring_ssc_reg[3][4]_i_42_n_6 ;
  wire \ring_ssc_reg[3][4]_i_42_n_7 ;
  wire \ring_ssc_reg[3][4]_i_4_n_3 ;
  wire \ring_ssc_reg[3][4]_i_54_n_0 ;
  wire \ring_ssc_reg[3][4]_i_54_n_1 ;
  wire \ring_ssc_reg[3][4]_i_54_n_2 ;
  wire \ring_ssc_reg[3][4]_i_54_n_3 ;
  wire \ring_ssc_reg[3][4]_i_55_n_0 ;
  wire \ring_ssc_reg[3][4]_i_55_n_1 ;
  wire \ring_ssc_reg[3][4]_i_55_n_2 ;
  wire \ring_ssc_reg[3][4]_i_55_n_3 ;
  wire \ring_ssc_reg[3][4]_i_55_n_4 ;
  wire \ring_ssc_reg[3][4]_i_55_n_5 ;
  wire \ring_ssc_reg[3][4]_i_55_n_6 ;
  wire \ring_ssc_reg[3][4]_i_55_n_7 ;
  wire \ring_ssc_reg[3][4]_i_56_n_0 ;
  wire \ring_ssc_reg[3][4]_i_56_n_1 ;
  wire \ring_ssc_reg[3][4]_i_56_n_2 ;
  wire \ring_ssc_reg[3][4]_i_56_n_3 ;
  wire \ring_ssc_reg[3][4]_i_57_n_0 ;
  wire \ring_ssc_reg[3][4]_i_57_n_1 ;
  wire \ring_ssc_reg[3][4]_i_57_n_2 ;
  wire \ring_ssc_reg[3][4]_i_57_n_3 ;
  wire \ring_ssc_reg[3][4]_i_57_n_4 ;
  wire \ring_ssc_reg[3][4]_i_57_n_5 ;
  wire \ring_ssc_reg[3][4]_i_57_n_6 ;
  wire \ring_ssc_reg[3][4]_i_57_n_7 ;
  wire \ring_ssc_reg[3][4]_i_5_n_0 ;
  wire \ring_ssc_reg[3][4]_i_5_n_1 ;
  wire \ring_ssc_reg[3][4]_i_5_n_2 ;
  wire \ring_ssc_reg[3][4]_i_5_n_3 ;
  wire \ring_ssc_reg_n_0_[0][0] ;
  wire \ring_ssc_reg_n_0_[0][1] ;
  wire \ring_ssc_reg_n_0_[0][2] ;
  wire \ring_ssc_reg_n_0_[0][3] ;
  wire \ring_ssc_reg_n_0_[0][4] ;
  wire \ring_ssc_reg_n_0_[0][5] ;
  wire \ring_ssc_reg_n_0_[0][6] ;
  wire \ring_ssc_reg_n_0_[1][0] ;
  wire \ring_ssc_reg_n_0_[1][1] ;
  wire \ring_ssc_reg_n_0_[1][2] ;
  wire \ring_ssc_reg_n_0_[1][3] ;
  wire \ring_ssc_reg_n_0_[1][4] ;
  wire \ring_ssc_reg_n_0_[1][5] ;
  wire \ring_ssc_reg_n_0_[1][6] ;
  wire \ring_ssc_reg_n_0_[2][0] ;
  wire \ring_ssc_reg_n_0_[2][1] ;
  wire \ring_ssc_reg_n_0_[2][2] ;
  wire \ring_ssc_reg_n_0_[2][3] ;
  wire \ring_ssc_reg_n_0_[2][4] ;
  wire \ring_ssc_reg_n_0_[2][5] ;
  wire \ring_ssc_reg_n_0_[2][6] ;
  wire \ring_ssc_reg_n_0_[3][0] ;
  wire \ring_ssc_reg_n_0_[3][1] ;
  wire \ring_ssc_reg_n_0_[3][2] ;
  wire \ring_ssc_reg_n_0_[3][3] ;
  wire \ring_ssc_reg_n_0_[3][4] ;
  wire \ring_ssc_reg_n_0_[3][5] ;
  wire \ring_ssc_reg_n_0_[3][6] ;
  wire [31:0]ring_wl;
  wire \ring_wl[3][11]_i_10_n_0 ;
  wire \ring_wl[3][11]_i_11_n_0 ;
  wire \ring_wl[3][11]_i_12_n_0 ;
  wire \ring_wl[3][11]_i_13_n_0 ;
  wire \ring_wl[3][11]_i_14_n_0 ;
  wire \ring_wl[3][11]_i_15_n_0 ;
  wire \ring_wl[3][11]_i_2_n_0 ;
  wire \ring_wl[3][11]_i_3_n_0 ;
  wire \ring_wl[3][11]_i_4_n_0 ;
  wire \ring_wl[3][11]_i_5_n_0 ;
  wire \ring_wl[3][11]_i_8_n_0 ;
  wire \ring_wl[3][11]_i_9_n_0 ;
  wire \ring_wl[3][15]_i_10_n_0 ;
  wire \ring_wl[3][15]_i_11_n_0 ;
  wire \ring_wl[3][15]_i_12_n_0 ;
  wire \ring_wl[3][15]_i_13_n_0 ;
  wire \ring_wl[3][15]_i_14_n_0 ;
  wire \ring_wl[3][15]_i_15_n_0 ;
  wire \ring_wl[3][15]_i_2_n_0 ;
  wire \ring_wl[3][15]_i_3_n_0 ;
  wire \ring_wl[3][15]_i_4_n_0 ;
  wire \ring_wl[3][15]_i_5_n_0 ;
  wire \ring_wl[3][15]_i_8_n_0 ;
  wire \ring_wl[3][15]_i_9_n_0 ;
  wire \ring_wl[3][19]_i_10_n_0 ;
  wire \ring_wl[3][19]_i_11_n_0 ;
  wire \ring_wl[3][19]_i_12_n_0 ;
  wire \ring_wl[3][19]_i_13_n_0 ;
  wire \ring_wl[3][19]_i_14_n_0 ;
  wire \ring_wl[3][19]_i_15_n_0 ;
  wire \ring_wl[3][19]_i_2_n_0 ;
  wire \ring_wl[3][19]_i_3_n_0 ;
  wire \ring_wl[3][19]_i_4_n_0 ;
  wire \ring_wl[3][19]_i_5_n_0 ;
  wire \ring_wl[3][19]_i_8_n_0 ;
  wire \ring_wl[3][19]_i_9_n_0 ;
  wire \ring_wl[3][23]_i_10_n_0 ;
  wire \ring_wl[3][23]_i_11_n_0 ;
  wire \ring_wl[3][23]_i_12_n_0 ;
  wire \ring_wl[3][23]_i_13_n_0 ;
  wire \ring_wl[3][23]_i_14_n_0 ;
  wire \ring_wl[3][23]_i_15_n_0 ;
  wire \ring_wl[3][23]_i_2_n_0 ;
  wire \ring_wl[3][23]_i_3_n_0 ;
  wire \ring_wl[3][23]_i_4_n_0 ;
  wire \ring_wl[3][23]_i_5_n_0 ;
  wire \ring_wl[3][23]_i_8_n_0 ;
  wire \ring_wl[3][23]_i_9_n_0 ;
  wire \ring_wl[3][27]_i_2_n_0 ;
  wire \ring_wl[3][27]_i_5_n_0 ;
  wire \ring_wl[3][27]_i_6_n_0 ;
  wire \ring_wl[3][27]_i_7_n_0 ;
  wire \ring_wl[3][3]_i_10_n_0 ;
  wire \ring_wl[3][3]_i_2_n_0 ;
  wire \ring_wl[3][3]_i_3_n_0 ;
  wire \ring_wl[3][3]_i_4_n_0 ;
  wire \ring_wl[3][3]_i_5_n_0 ;
  wire \ring_wl[3][3]_i_7_n_0 ;
  wire \ring_wl[3][3]_i_8_n_0 ;
  wire \ring_wl[3][3]_i_9_n_0 ;
  wire \ring_wl[3][7]_i_10_n_0 ;
  wire \ring_wl[3][7]_i_11_n_0 ;
  wire \ring_wl[3][7]_i_12_n_0 ;
  wire \ring_wl[3][7]_i_13_n_0 ;
  wire \ring_wl[3][7]_i_14_n_0 ;
  wire \ring_wl[3][7]_i_15_n_0 ;
  wire \ring_wl[3][7]_i_16_n_0 ;
  wire \ring_wl[3][7]_i_2_n_0 ;
  wire \ring_wl[3][7]_i_3_n_0 ;
  wire \ring_wl[3][7]_i_4_n_0 ;
  wire \ring_wl[3][7]_i_5_n_0 ;
  wire \ring_wl[3][7]_i_8_n_0 ;
  wire \ring_wl[3][7]_i_9_n_0 ;
  wire [31:0]\ring_wl_reg[0] ;
  wire [31:0]\ring_wl_reg[1] ;
  wire [31:0]\ring_wl_reg[2] ;
  wire [31:0]\ring_wl_reg[3] ;
  wire \ring_wl_reg[3][11]_i_1_n_0 ;
  wire \ring_wl_reg[3][11]_i_1_n_1 ;
  wire \ring_wl_reg[3][11]_i_1_n_2 ;
  wire \ring_wl_reg[3][11]_i_1_n_3 ;
  wire \ring_wl_reg[3][11]_i_1_n_4 ;
  wire \ring_wl_reg[3][11]_i_1_n_5 ;
  wire \ring_wl_reg[3][11]_i_1_n_6 ;
  wire \ring_wl_reg[3][11]_i_1_n_7 ;
  wire \ring_wl_reg[3][11]_i_6_n_0 ;
  wire \ring_wl_reg[3][11]_i_6_n_1 ;
  wire \ring_wl_reg[3][11]_i_6_n_2 ;
  wire \ring_wl_reg[3][11]_i_6_n_3 ;
  wire \ring_wl_reg[3][11]_i_6_n_4 ;
  wire \ring_wl_reg[3][11]_i_6_n_5 ;
  wire \ring_wl_reg[3][11]_i_6_n_6 ;
  wire \ring_wl_reg[3][11]_i_6_n_7 ;
  wire \ring_wl_reg[3][11]_i_7_n_0 ;
  wire \ring_wl_reg[3][11]_i_7_n_1 ;
  wire \ring_wl_reg[3][11]_i_7_n_2 ;
  wire \ring_wl_reg[3][11]_i_7_n_3 ;
  wire \ring_wl_reg[3][15]_i_1_n_0 ;
  wire \ring_wl_reg[3][15]_i_1_n_1 ;
  wire \ring_wl_reg[3][15]_i_1_n_2 ;
  wire \ring_wl_reg[3][15]_i_1_n_3 ;
  wire \ring_wl_reg[3][15]_i_1_n_4 ;
  wire \ring_wl_reg[3][15]_i_1_n_5 ;
  wire \ring_wl_reg[3][15]_i_1_n_6 ;
  wire \ring_wl_reg[3][15]_i_1_n_7 ;
  wire \ring_wl_reg[3][15]_i_6_n_0 ;
  wire \ring_wl_reg[3][15]_i_6_n_1 ;
  wire \ring_wl_reg[3][15]_i_6_n_2 ;
  wire \ring_wl_reg[3][15]_i_6_n_3 ;
  wire \ring_wl_reg[3][15]_i_6_n_4 ;
  wire \ring_wl_reg[3][15]_i_6_n_5 ;
  wire \ring_wl_reg[3][15]_i_6_n_6 ;
  wire \ring_wl_reg[3][15]_i_6_n_7 ;
  wire \ring_wl_reg[3][15]_i_7_n_0 ;
  wire \ring_wl_reg[3][15]_i_7_n_1 ;
  wire \ring_wl_reg[3][15]_i_7_n_2 ;
  wire \ring_wl_reg[3][15]_i_7_n_3 ;
  wire \ring_wl_reg[3][19]_i_1_n_0 ;
  wire \ring_wl_reg[3][19]_i_1_n_1 ;
  wire \ring_wl_reg[3][19]_i_1_n_2 ;
  wire \ring_wl_reg[3][19]_i_1_n_3 ;
  wire \ring_wl_reg[3][19]_i_1_n_4 ;
  wire \ring_wl_reg[3][19]_i_1_n_5 ;
  wire \ring_wl_reg[3][19]_i_1_n_6 ;
  wire \ring_wl_reg[3][19]_i_1_n_7 ;
  wire \ring_wl_reg[3][19]_i_6_n_0 ;
  wire \ring_wl_reg[3][19]_i_6_n_1 ;
  wire \ring_wl_reg[3][19]_i_6_n_2 ;
  wire \ring_wl_reg[3][19]_i_6_n_3 ;
  wire \ring_wl_reg[3][19]_i_6_n_4 ;
  wire \ring_wl_reg[3][19]_i_6_n_5 ;
  wire \ring_wl_reg[3][19]_i_6_n_6 ;
  wire \ring_wl_reg[3][19]_i_6_n_7 ;
  wire \ring_wl_reg[3][19]_i_7_n_0 ;
  wire \ring_wl_reg[3][19]_i_7_n_1 ;
  wire \ring_wl_reg[3][19]_i_7_n_2 ;
  wire \ring_wl_reg[3][19]_i_7_n_3 ;
  wire \ring_wl_reg[3][23]_i_1_n_0 ;
  wire \ring_wl_reg[3][23]_i_1_n_1 ;
  wire \ring_wl_reg[3][23]_i_1_n_2 ;
  wire \ring_wl_reg[3][23]_i_1_n_3 ;
  wire \ring_wl_reg[3][23]_i_1_n_4 ;
  wire \ring_wl_reg[3][23]_i_1_n_5 ;
  wire \ring_wl_reg[3][23]_i_1_n_6 ;
  wire \ring_wl_reg[3][23]_i_1_n_7 ;
  wire \ring_wl_reg[3][23]_i_6_n_0 ;
  wire \ring_wl_reg[3][23]_i_6_n_1 ;
  wire \ring_wl_reg[3][23]_i_6_n_2 ;
  wire \ring_wl_reg[3][23]_i_6_n_3 ;
  wire \ring_wl_reg[3][23]_i_6_n_4 ;
  wire \ring_wl_reg[3][23]_i_6_n_5 ;
  wire \ring_wl_reg[3][23]_i_6_n_6 ;
  wire \ring_wl_reg[3][23]_i_6_n_7 ;
  wire \ring_wl_reg[3][23]_i_7_n_0 ;
  wire \ring_wl_reg[3][23]_i_7_n_1 ;
  wire \ring_wl_reg[3][23]_i_7_n_2 ;
  wire \ring_wl_reg[3][23]_i_7_n_3 ;
  wire \ring_wl_reg[3][27]_i_1_n_0 ;
  wire \ring_wl_reg[3][27]_i_1_n_1 ;
  wire \ring_wl_reg[3][27]_i_1_n_2 ;
  wire \ring_wl_reg[3][27]_i_1_n_3 ;
  wire \ring_wl_reg[3][27]_i_1_n_4 ;
  wire \ring_wl_reg[3][27]_i_1_n_5 ;
  wire \ring_wl_reg[3][27]_i_1_n_6 ;
  wire \ring_wl_reg[3][27]_i_1_n_7 ;
  wire \ring_wl_reg[3][27]_i_3_n_1 ;
  wire \ring_wl_reg[3][27]_i_3_n_2 ;
  wire \ring_wl_reg[3][27]_i_3_n_3 ;
  wire \ring_wl_reg[3][27]_i_4_n_3 ;
  wire \ring_wl_reg[3][31]_i_1_n_1 ;
  wire \ring_wl_reg[3][31]_i_1_n_2 ;
  wire \ring_wl_reg[3][31]_i_1_n_3 ;
  wire \ring_wl_reg[3][31]_i_1_n_4 ;
  wire \ring_wl_reg[3][31]_i_1_n_5 ;
  wire \ring_wl_reg[3][31]_i_1_n_6 ;
  wire \ring_wl_reg[3][31]_i_1_n_7 ;
  wire \ring_wl_reg[3][3]_i_1_n_0 ;
  wire \ring_wl_reg[3][3]_i_1_n_1 ;
  wire \ring_wl_reg[3][3]_i_1_n_2 ;
  wire \ring_wl_reg[3][3]_i_1_n_3 ;
  wire \ring_wl_reg[3][3]_i_1_n_4 ;
  wire \ring_wl_reg[3][3]_i_1_n_5 ;
  wire \ring_wl_reg[3][3]_i_1_n_6 ;
  wire \ring_wl_reg[3][3]_i_1_n_7 ;
  wire \ring_wl_reg[3][3]_i_6_n_0 ;
  wire \ring_wl_reg[3][3]_i_6_n_1 ;
  wire \ring_wl_reg[3][3]_i_6_n_2 ;
  wire \ring_wl_reg[3][3]_i_6_n_3 ;
  wire \ring_wl_reg[3][3]_i_6_n_4 ;
  wire \ring_wl_reg[3][3]_i_6_n_5 ;
  wire \ring_wl_reg[3][3]_i_6_n_6 ;
  wire \ring_wl_reg[3][3]_i_6_n_7 ;
  wire \ring_wl_reg[3][7]_i_1_n_0 ;
  wire \ring_wl_reg[3][7]_i_1_n_1 ;
  wire \ring_wl_reg[3][7]_i_1_n_2 ;
  wire \ring_wl_reg[3][7]_i_1_n_3 ;
  wire \ring_wl_reg[3][7]_i_1_n_4 ;
  wire \ring_wl_reg[3][7]_i_1_n_5 ;
  wire \ring_wl_reg[3][7]_i_1_n_6 ;
  wire \ring_wl_reg[3][7]_i_1_n_7 ;
  wire \ring_wl_reg[3][7]_i_6_n_0 ;
  wire \ring_wl_reg[3][7]_i_6_n_1 ;
  wire \ring_wl_reg[3][7]_i_6_n_2 ;
  wire \ring_wl_reg[3][7]_i_6_n_3 ;
  wire \ring_wl_reg[3][7]_i_6_n_4 ;
  wire \ring_wl_reg[3][7]_i_6_n_5 ;
  wire \ring_wl_reg[3][7]_i_6_n_6 ;
  wire \ring_wl_reg[3][7]_i_6_n_7 ;
  wire \ring_wl_reg[3][7]_i_7_n_0 ;
  wire \ring_wl_reg[3][7]_i_7_n_1 ;
  wire \ring_wl_reg[3][7]_i_7_n_2 ;
  wire \ring_wl_reg[3][7]_i_7_n_3 ;
  wire [6:0]ring_zc;
  wire \ring_zc[3][0]_i_1_n_0 ;
  wire \ring_zc[3][1]_i_10_n_0 ;
  wire \ring_zc[3][1]_i_12_n_0 ;
  wire \ring_zc[3][1]_i_13_n_0 ;
  wire \ring_zc[3][1]_i_14_n_0 ;
  wire \ring_zc[3][1]_i_15_n_0 ;
  wire \ring_zc[3][1]_i_16_n_0 ;
  wire \ring_zc[3][1]_i_17_n_0 ;
  wire \ring_zc[3][1]_i_18_n_0 ;
  wire \ring_zc[3][1]_i_19_n_0 ;
  wire \ring_zc[3][1]_i_1_n_0 ;
  wire \ring_zc[3][1]_i_20_n_0 ;
  wire \ring_zc[3][1]_i_21_n_0 ;
  wire \ring_zc[3][1]_i_22_n_0 ;
  wire \ring_zc[3][1]_i_23_n_0 ;
  wire \ring_zc[3][1]_i_24_n_0 ;
  wire \ring_zc[3][1]_i_25_n_0 ;
  wire \ring_zc[3][1]_i_26_n_0 ;
  wire \ring_zc[3][1]_i_27_n_0 ;
  wire \ring_zc[3][1]_i_28_n_0 ;
  wire \ring_zc[3][1]_i_4_n_0 ;
  wire \ring_zc[3][1]_i_5_n_0 ;
  wire \ring_zc[3][1]_i_6_n_0 ;
  wire \ring_zc[3][1]_i_7_n_0 ;
  wire \ring_zc[3][1]_i_8_n_0 ;
  wire \ring_zc[3][1]_i_9_n_0 ;
  wire \ring_zc[3][2]_i_1_n_0 ;
  wire \ring_zc[3][3]_i_1_n_0 ;
  wire \ring_zc[3][4]_i_1_n_0 ;
  wire \ring_zc[3][5]_i_1_n_0 ;
  wire \ring_zc[3][6]_i_1_n_0 ;
  wire \ring_zc[3][6]_i_2_n_0 ;
  wire [6:0]\ring_zc_reg[0] ;
  wire [6:0]\ring_zc_reg[1] ;
  wire [6:0]\ring_zc_reg[2] ;
  wire [6:0]\ring_zc_reg[3] ;
  wire \ring_zc_reg[3][1]_i_11_n_0 ;
  wire \ring_zc_reg[3][1]_i_11_n_1 ;
  wire \ring_zc_reg[3][1]_i_11_n_2 ;
  wire \ring_zc_reg[3][1]_i_11_n_3 ;
  wire \ring_zc_reg[3][1]_i_2_n_1 ;
  wire \ring_zc_reg[3][1]_i_2_n_2 ;
  wire \ring_zc_reg[3][1]_i_2_n_3 ;
  wire \ring_zc_reg[3][1]_i_3_n_0 ;
  wire \ring_zc_reg[3][1]_i_3_n_1 ;
  wire \ring_zc_reg[3][1]_i_3_n_2 ;
  wire \ring_zc_reg[3][1]_i_3_n_3 ;
  wire rst_n;
  wire [23:0]sample_in;
  wire sample_valid;
  wire \seg_count[6]_i_3_n_0 ;
  wire [6:0]seg_count_reg;
  wire [31:0]seg_energy1__1;
  wire seg_energy1_n_106;
  wire seg_energy1_n_107;
  wire seg_energy1_n_108;
  wire seg_energy1_n_109;
  wire seg_energy1_n_110;
  wire seg_energy1_n_111;
  wire seg_energy1_n_112;
  wire seg_energy1_n_113;
  wire seg_energy1_n_114;
  wire seg_energy1_n_115;
  wire seg_energy1_n_116;
  wire seg_energy1_n_117;
  wire seg_energy1_n_118;
  wire seg_energy1_n_119;
  wire seg_energy1_n_120;
  wire seg_energy1_n_121;
  wire seg_energy1_n_122;
  wire seg_energy1_n_123;
  wire seg_energy1_n_124;
  wire seg_energy1_n_125;
  wire seg_energy1_n_126;
  wire seg_energy1_n_127;
  wire seg_energy1_n_128;
  wire seg_energy1_n_129;
  wire seg_energy1_n_130;
  wire seg_energy1_n_131;
  wire seg_energy1_n_132;
  wire seg_energy1_n_133;
  wire seg_energy1_n_134;
  wire seg_energy1_n_135;
  wire seg_energy1_n_136;
  wire seg_energy1_n_137;
  wire seg_energy1_n_138;
  wire seg_energy1_n_139;
  wire seg_energy1_n_140;
  wire seg_energy1_n_141;
  wire seg_energy1_n_142;
  wire seg_energy1_n_143;
  wire seg_energy1_n_144;
  wire seg_energy1_n_145;
  wire seg_energy1_n_146;
  wire seg_energy1_n_147;
  wire seg_energy1_n_148;
  wire seg_energy1_n_149;
  wire seg_energy1_n_150;
  wire seg_energy1_n_151;
  wire seg_energy1_n_152;
  wire seg_energy1_n_153;
  wire seg_energy1_n_58;
  wire seg_energy1_n_59;
  wire seg_energy1_n_60;
  wire seg_energy1_n_61;
  wire seg_energy1_n_62;
  wire seg_energy1_n_63;
  wire seg_energy1_n_64;
  wire seg_energy1_n_65;
  wire seg_energy1_n_66;
  wire seg_energy1_n_67;
  wire seg_energy1_n_68;
  wire seg_energy1_n_69;
  wire seg_energy1_n_70;
  wire seg_energy1_n_71;
  wire seg_energy1_n_72;
  wire seg_energy1_n_73;
  wire seg_energy1_n_74;
  wire seg_energy1_n_75;
  wire seg_energy1_n_76;
  wire seg_energy1_n_77;
  wire seg_energy1_n_78;
  wire seg_energy1_n_79;
  wire seg_energy1_n_80;
  wire seg_energy1_n_81;
  wire seg_energy1_n_82;
  wire seg_energy1_n_83;
  wire seg_energy1_n_84;
  wire seg_energy1_n_85;
  wire seg_energy1_n_86;
  wire seg_energy1_n_87;
  wire seg_energy1_n_88;
  wire \seg_energy[0]_i_2_n_0 ;
  wire \seg_energy[0]_i_3_n_0 ;
  wire \seg_energy[0]_i_4_n_0 ;
  wire \seg_energy[0]_i_5_n_0 ;
  wire \seg_energy[12]_i_2_n_0 ;
  wire \seg_energy[12]_i_3_n_0 ;
  wire \seg_energy[12]_i_4_n_0 ;
  wire \seg_energy[12]_i_5_n_0 ;
  wire \seg_energy[16]_i_2_n_0 ;
  wire \seg_energy[16]_i_3_n_0 ;
  wire \seg_energy[16]_i_4_n_0 ;
  wire \seg_energy[16]_i_5_n_0 ;
  wire \seg_energy[20]_i_2_n_0 ;
  wire \seg_energy[20]_i_3_n_0 ;
  wire \seg_energy[20]_i_4_n_0 ;
  wire \seg_energy[20]_i_5_n_0 ;
  wire \seg_energy[24]_i_2_n_0 ;
  wire \seg_energy[24]_i_3_n_0 ;
  wire \seg_energy[24]_i_4_n_0 ;
  wire \seg_energy[24]_i_5_n_0 ;
  wire \seg_energy[28]_i_2_n_0 ;
  wire \seg_energy[28]_i_3_n_0 ;
  wire \seg_energy[28]_i_4_n_0 ;
  wire \seg_energy[28]_i_5_n_0 ;
  wire \seg_energy[4]_i_2_n_0 ;
  wire \seg_energy[4]_i_3_n_0 ;
  wire \seg_energy[4]_i_4_n_0 ;
  wire \seg_energy[4]_i_5_n_0 ;
  wire \seg_energy[8]_i_2_n_0 ;
  wire \seg_energy[8]_i_3_n_0 ;
  wire \seg_energy[8]_i_4_n_0 ;
  wire \seg_energy[8]_i_5_n_0 ;
  wire [31:0]seg_energy_reg;
  wire \seg_energy_reg[0]_i_1_n_0 ;
  wire \seg_energy_reg[0]_i_1_n_1 ;
  wire \seg_energy_reg[0]_i_1_n_2 ;
  wire \seg_energy_reg[0]_i_1_n_3 ;
  wire \seg_energy_reg[0]_i_1_n_4 ;
  wire \seg_energy_reg[0]_i_1_n_5 ;
  wire \seg_energy_reg[0]_i_1_n_6 ;
  wire \seg_energy_reg[0]_i_1_n_7 ;
  wire \seg_energy_reg[12]_i_1_n_0 ;
  wire \seg_energy_reg[12]_i_1_n_1 ;
  wire \seg_energy_reg[12]_i_1_n_2 ;
  wire \seg_energy_reg[12]_i_1_n_3 ;
  wire \seg_energy_reg[12]_i_1_n_4 ;
  wire \seg_energy_reg[12]_i_1_n_5 ;
  wire \seg_energy_reg[12]_i_1_n_6 ;
  wire \seg_energy_reg[12]_i_1_n_7 ;
  wire \seg_energy_reg[16]_i_1_n_0 ;
  wire \seg_energy_reg[16]_i_1_n_1 ;
  wire \seg_energy_reg[16]_i_1_n_2 ;
  wire \seg_energy_reg[16]_i_1_n_3 ;
  wire \seg_energy_reg[16]_i_1_n_4 ;
  wire \seg_energy_reg[16]_i_1_n_5 ;
  wire \seg_energy_reg[16]_i_1_n_6 ;
  wire \seg_energy_reg[16]_i_1_n_7 ;
  wire \seg_energy_reg[20]_i_1_n_0 ;
  wire \seg_energy_reg[20]_i_1_n_1 ;
  wire \seg_energy_reg[20]_i_1_n_2 ;
  wire \seg_energy_reg[20]_i_1_n_3 ;
  wire \seg_energy_reg[20]_i_1_n_4 ;
  wire \seg_energy_reg[20]_i_1_n_5 ;
  wire \seg_energy_reg[20]_i_1_n_6 ;
  wire \seg_energy_reg[20]_i_1_n_7 ;
  wire \seg_energy_reg[24]_i_1_n_0 ;
  wire \seg_energy_reg[24]_i_1_n_1 ;
  wire \seg_energy_reg[24]_i_1_n_2 ;
  wire \seg_energy_reg[24]_i_1_n_3 ;
  wire \seg_energy_reg[24]_i_1_n_4 ;
  wire \seg_energy_reg[24]_i_1_n_5 ;
  wire \seg_energy_reg[24]_i_1_n_6 ;
  wire \seg_energy_reg[24]_i_1_n_7 ;
  wire \seg_energy_reg[28]_i_1_n_1 ;
  wire \seg_energy_reg[28]_i_1_n_2 ;
  wire \seg_energy_reg[28]_i_1_n_3 ;
  wire \seg_energy_reg[28]_i_1_n_4 ;
  wire \seg_energy_reg[28]_i_1_n_5 ;
  wire \seg_energy_reg[28]_i_1_n_6 ;
  wire \seg_energy_reg[28]_i_1_n_7 ;
  wire \seg_energy_reg[4]_i_1_n_0 ;
  wire \seg_energy_reg[4]_i_1_n_1 ;
  wire \seg_energy_reg[4]_i_1_n_2 ;
  wire \seg_energy_reg[4]_i_1_n_3 ;
  wire \seg_energy_reg[4]_i_1_n_4 ;
  wire \seg_energy_reg[4]_i_1_n_5 ;
  wire \seg_energy_reg[4]_i_1_n_6 ;
  wire \seg_energy_reg[4]_i_1_n_7 ;
  wire \seg_energy_reg[8]_i_1_n_0 ;
  wire \seg_energy_reg[8]_i_1_n_1 ;
  wire \seg_energy_reg[8]_i_1_n_2 ;
  wire \seg_energy_reg[8]_i_1_n_3 ;
  wire \seg_energy_reg[8]_i_1_n_4 ;
  wire \seg_energy_reg[8]_i_1_n_5 ;
  wire \seg_energy_reg[8]_i_1_n_6 ;
  wire \seg_energy_reg[8]_i_1_n_7 ;
  wire [23:1]seg_mav2;
  wire \seg_mav[0]_i_5_n_0 ;
  wire \seg_mav[0]_i_6_n_0 ;
  wire \seg_mav[0]_i_7_n_0 ;
  wire \seg_mav[0]_i_8_n_0 ;
  wire \seg_mav[12]_i_6_n_0 ;
  wire \seg_mav[12]_i_7_n_0 ;
  wire \seg_mav[12]_i_8_n_0 ;
  wire \seg_mav[12]_i_9_n_0 ;
  wire \seg_mav[16]_i_6_n_0 ;
  wire \seg_mav[16]_i_7_n_0 ;
  wire \seg_mav[16]_i_8_n_0 ;
  wire \seg_mav[16]_i_9_n_0 ;
  wire \seg_mav[20]_i_6_n_0 ;
  wire \seg_mav[20]_i_7_n_0 ;
  wire \seg_mav[20]_i_8_n_0 ;
  wire \seg_mav[20]_i_9_n_0 ;
  wire \seg_mav[24]_i_3_n_0 ;
  wire \seg_mav[4]_i_6_n_0 ;
  wire \seg_mav[4]_i_7_n_0 ;
  wire \seg_mav[4]_i_8_n_0 ;
  wire \seg_mav[4]_i_9_n_0 ;
  wire \seg_mav[8]_i_6_n_0 ;
  wire \seg_mav[8]_i_7_n_0 ;
  wire \seg_mav[8]_i_8_n_0 ;
  wire \seg_mav[8]_i_9_n_0 ;
  wire [31:0]seg_mav_reg;
  wire \seg_mav_reg[0]_i_1_n_0 ;
  wire \seg_mav_reg[0]_i_1_n_1 ;
  wire \seg_mav_reg[0]_i_1_n_2 ;
  wire \seg_mav_reg[0]_i_1_n_3 ;
  wire \seg_mav_reg[0]_i_1_n_4 ;
  wire \seg_mav_reg[0]_i_1_n_5 ;
  wire \seg_mav_reg[0]_i_1_n_6 ;
  wire \seg_mav_reg[0]_i_1_n_7 ;
  wire \seg_mav_reg[12]_i_1_n_0 ;
  wire \seg_mav_reg[12]_i_1_n_1 ;
  wire \seg_mav_reg[12]_i_1_n_2 ;
  wire \seg_mav_reg[12]_i_1_n_3 ;
  wire \seg_mav_reg[12]_i_1_n_4 ;
  wire \seg_mav_reg[12]_i_1_n_5 ;
  wire \seg_mav_reg[12]_i_1_n_6 ;
  wire \seg_mav_reg[12]_i_1_n_7 ;
  wire \seg_mav_reg[16]_i_1_n_0 ;
  wire \seg_mav_reg[16]_i_1_n_1 ;
  wire \seg_mav_reg[16]_i_1_n_2 ;
  wire \seg_mav_reg[16]_i_1_n_3 ;
  wire \seg_mav_reg[16]_i_1_n_4 ;
  wire \seg_mav_reg[16]_i_1_n_5 ;
  wire \seg_mav_reg[16]_i_1_n_6 ;
  wire \seg_mav_reg[16]_i_1_n_7 ;
  wire \seg_mav_reg[20]_i_1_n_0 ;
  wire \seg_mav_reg[20]_i_1_n_1 ;
  wire \seg_mav_reg[20]_i_1_n_2 ;
  wire \seg_mav_reg[20]_i_1_n_3 ;
  wire \seg_mav_reg[20]_i_1_n_4 ;
  wire \seg_mav_reg[20]_i_1_n_5 ;
  wire \seg_mav_reg[20]_i_1_n_6 ;
  wire \seg_mav_reg[20]_i_1_n_7 ;
  wire \seg_mav_reg[24]_i_1_n_0 ;
  wire \seg_mav_reg[24]_i_1_n_1 ;
  wire \seg_mav_reg[24]_i_1_n_2 ;
  wire \seg_mav_reg[24]_i_1_n_3 ;
  wire \seg_mav_reg[24]_i_1_n_4 ;
  wire \seg_mav_reg[24]_i_1_n_5 ;
  wire \seg_mav_reg[24]_i_1_n_6 ;
  wire \seg_mav_reg[24]_i_1_n_7 ;
  wire \seg_mav_reg[28]_i_1_n_1 ;
  wire \seg_mav_reg[28]_i_1_n_2 ;
  wire \seg_mav_reg[28]_i_1_n_3 ;
  wire \seg_mav_reg[28]_i_1_n_4 ;
  wire \seg_mav_reg[28]_i_1_n_5 ;
  wire \seg_mav_reg[28]_i_1_n_6 ;
  wire \seg_mav_reg[28]_i_1_n_7 ;
  wire \seg_mav_reg[4]_i_1_n_0 ;
  wire \seg_mav_reg[4]_i_1_n_1 ;
  wire \seg_mav_reg[4]_i_1_n_2 ;
  wire \seg_mav_reg[4]_i_1_n_3 ;
  wire \seg_mav_reg[4]_i_1_n_4 ;
  wire \seg_mav_reg[4]_i_1_n_5 ;
  wire \seg_mav_reg[4]_i_1_n_6 ;
  wire \seg_mav_reg[4]_i_1_n_7 ;
  wire \seg_mav_reg[8]_i_1_n_0 ;
  wire \seg_mav_reg[8]_i_1_n_1 ;
  wire \seg_mav_reg[8]_i_1_n_2 ;
  wire \seg_mav_reg[8]_i_1_n_3 ;
  wire \seg_mav_reg[8]_i_1_n_4 ;
  wire \seg_mav_reg[8]_i_1_n_5 ;
  wire \seg_mav_reg[8]_i_1_n_6 ;
  wire \seg_mav_reg[8]_i_1_n_7 ;
  wire [0:0]seg_ssc;
  wire [6:0]seg_ssc_reg;
  wire \seg_wl[0]_i_5_n_0 ;
  wire \seg_wl[0]_i_6_n_0 ;
  wire \seg_wl[0]_i_7_n_0 ;
  wire \seg_wl[0]_i_8_n_0 ;
  wire \seg_wl[0]_i_9_n_0 ;
  wire \seg_wl[12]_i_6_n_0 ;
  wire \seg_wl[12]_i_7_n_0 ;
  wire \seg_wl[12]_i_8_n_0 ;
  wire \seg_wl[12]_i_9_n_0 ;
  wire \seg_wl[16]_i_6_n_0 ;
  wire \seg_wl[16]_i_7_n_0 ;
  wire \seg_wl[16]_i_8_n_0 ;
  wire \seg_wl[16]_i_9_n_0 ;
  wire \seg_wl[20]_i_6_n_0 ;
  wire \seg_wl[20]_i_7_n_0 ;
  wire \seg_wl[20]_i_8_n_0 ;
  wire \seg_wl[20]_i_9_n_0 ;
  wire \seg_wl[24]_i_2_n_0 ;
  wire \seg_wl[24]_i_3_n_0 ;
  wire \seg_wl[4]_i_6_n_0 ;
  wire \seg_wl[4]_i_7_n_0 ;
  wire \seg_wl[4]_i_8_n_0 ;
  wire \seg_wl[4]_i_9_n_0 ;
  wire \seg_wl[8]_i_6_n_0 ;
  wire \seg_wl[8]_i_7_n_0 ;
  wire \seg_wl[8]_i_8_n_0 ;
  wire \seg_wl[8]_i_9_n_0 ;
  wire [31:0]seg_wl_reg;
  wire \seg_wl_reg[0]_i_1_n_0 ;
  wire \seg_wl_reg[0]_i_1_n_1 ;
  wire \seg_wl_reg[0]_i_1_n_2 ;
  wire \seg_wl_reg[0]_i_1_n_3 ;
  wire \seg_wl_reg[0]_i_1_n_4 ;
  wire \seg_wl_reg[0]_i_1_n_5 ;
  wire \seg_wl_reg[0]_i_1_n_6 ;
  wire \seg_wl_reg[0]_i_1_n_7 ;
  wire \seg_wl_reg[12]_i_1_n_0 ;
  wire \seg_wl_reg[12]_i_1_n_1 ;
  wire \seg_wl_reg[12]_i_1_n_2 ;
  wire \seg_wl_reg[12]_i_1_n_3 ;
  wire \seg_wl_reg[12]_i_1_n_4 ;
  wire \seg_wl_reg[12]_i_1_n_5 ;
  wire \seg_wl_reg[12]_i_1_n_6 ;
  wire \seg_wl_reg[12]_i_1_n_7 ;
  wire \seg_wl_reg[16]_i_1_n_0 ;
  wire \seg_wl_reg[16]_i_1_n_1 ;
  wire \seg_wl_reg[16]_i_1_n_2 ;
  wire \seg_wl_reg[16]_i_1_n_3 ;
  wire \seg_wl_reg[16]_i_1_n_4 ;
  wire \seg_wl_reg[16]_i_1_n_5 ;
  wire \seg_wl_reg[16]_i_1_n_6 ;
  wire \seg_wl_reg[16]_i_1_n_7 ;
  wire \seg_wl_reg[20]_i_1_n_0 ;
  wire \seg_wl_reg[20]_i_1_n_1 ;
  wire \seg_wl_reg[20]_i_1_n_2 ;
  wire \seg_wl_reg[20]_i_1_n_3 ;
  wire \seg_wl_reg[20]_i_1_n_4 ;
  wire \seg_wl_reg[20]_i_1_n_5 ;
  wire \seg_wl_reg[20]_i_1_n_6 ;
  wire \seg_wl_reg[20]_i_1_n_7 ;
  wire \seg_wl_reg[24]_i_1_n_0 ;
  wire \seg_wl_reg[24]_i_1_n_1 ;
  wire \seg_wl_reg[24]_i_1_n_2 ;
  wire \seg_wl_reg[24]_i_1_n_3 ;
  wire \seg_wl_reg[24]_i_1_n_4 ;
  wire \seg_wl_reg[24]_i_1_n_5 ;
  wire \seg_wl_reg[24]_i_1_n_6 ;
  wire \seg_wl_reg[24]_i_1_n_7 ;
  wire \seg_wl_reg[28]_i_1_n_1 ;
  wire \seg_wl_reg[28]_i_1_n_2 ;
  wire \seg_wl_reg[28]_i_1_n_3 ;
  wire \seg_wl_reg[28]_i_1_n_4 ;
  wire \seg_wl_reg[28]_i_1_n_5 ;
  wire \seg_wl_reg[28]_i_1_n_6 ;
  wire \seg_wl_reg[28]_i_1_n_7 ;
  wire \seg_wl_reg[4]_i_1_n_0 ;
  wire \seg_wl_reg[4]_i_1_n_1 ;
  wire \seg_wl_reg[4]_i_1_n_2 ;
  wire \seg_wl_reg[4]_i_1_n_3 ;
  wire \seg_wl_reg[4]_i_1_n_4 ;
  wire \seg_wl_reg[4]_i_1_n_5 ;
  wire \seg_wl_reg[4]_i_1_n_6 ;
  wire \seg_wl_reg[4]_i_1_n_7 ;
  wire \seg_wl_reg[8]_i_1_n_0 ;
  wire \seg_wl_reg[8]_i_1_n_1 ;
  wire \seg_wl_reg[8]_i_1_n_2 ;
  wire \seg_wl_reg[8]_i_1_n_3 ;
  wire \seg_wl_reg[8]_i_1_n_4 ;
  wire \seg_wl_reg[8]_i_1_n_5 ;
  wire \seg_wl_reg[8]_i_1_n_6 ;
  wire \seg_wl_reg[8]_i_1_n_7 ;
  wire [6:0]seg_zc_reg;
  wire [8:0]\^ssc_count ;
  wire \ssc_count[0]_i_1_n_0 ;
  wire \ssc_count[1]_i_1_n_0 ;
  wire \ssc_count[2]_i_1_n_0 ;
  wire \ssc_count[3]_i_1_n_0 ;
  wire \ssc_count[4]_i_1_n_0 ;
  wire \ssc_count[5]_i_1_n_0 ;
  wire \ssc_count[6]_i_1_n_0 ;
  wire \ssc_count[7]_i_1_n_0 ;
  wire \ssc_count[8]_i_1_n_0 ;
  wire ssc_event;
  wire [24:1]ssc_event4;
  wire [39:0]win_energy;
  wire \win_energy[11]_i_11_n_0 ;
  wire \win_energy[11]_i_13_n_0 ;
  wire \win_energy[11]_i_15_n_0 ;
  wire \win_energy[11]_i_17_n_0 ;
  wire \win_energy[11]_i_2_n_0 ;
  wire \win_energy[11]_i_3_n_0 ;
  wire \win_energy[11]_i_4_n_0 ;
  wire \win_energy[11]_i_5_n_0 ;
  wire \win_energy[11]_i_6_n_0 ;
  wire \win_energy[11]_i_7_n_0 ;
  wire \win_energy[11]_i_8_n_0 ;
  wire \win_energy[11]_i_9_n_0 ;
  wire \win_energy[15]_i_11_n_0 ;
  wire \win_energy[15]_i_13_n_0 ;
  wire \win_energy[15]_i_15_n_0 ;
  wire \win_energy[15]_i_17_n_0 ;
  wire \win_energy[15]_i_2_n_0 ;
  wire \win_energy[15]_i_3_n_0 ;
  wire \win_energy[15]_i_4_n_0 ;
  wire \win_energy[15]_i_5_n_0 ;
  wire \win_energy[15]_i_6_n_0 ;
  wire \win_energy[15]_i_7_n_0 ;
  wire \win_energy[15]_i_8_n_0 ;
  wire \win_energy[15]_i_9_n_0 ;
  wire \win_energy[19]_i_11_n_0 ;
  wire \win_energy[19]_i_13_n_0 ;
  wire \win_energy[19]_i_15_n_0 ;
  wire \win_energy[19]_i_17_n_0 ;
  wire \win_energy[19]_i_2_n_0 ;
  wire \win_energy[19]_i_3_n_0 ;
  wire \win_energy[19]_i_4_n_0 ;
  wire \win_energy[19]_i_5_n_0 ;
  wire \win_energy[19]_i_6_n_0 ;
  wire \win_energy[19]_i_7_n_0 ;
  wire \win_energy[19]_i_8_n_0 ;
  wire \win_energy[19]_i_9_n_0 ;
  wire \win_energy[23]_i_11_n_0 ;
  wire \win_energy[23]_i_13_n_0 ;
  wire \win_energy[23]_i_15_n_0 ;
  wire \win_energy[23]_i_17_n_0 ;
  wire \win_energy[23]_i_2_n_0 ;
  wire \win_energy[23]_i_3_n_0 ;
  wire \win_energy[23]_i_4_n_0 ;
  wire \win_energy[23]_i_5_n_0 ;
  wire \win_energy[23]_i_6_n_0 ;
  wire \win_energy[23]_i_7_n_0 ;
  wire \win_energy[23]_i_8_n_0 ;
  wire \win_energy[23]_i_9_n_0 ;
  wire \win_energy[27]_i_11_n_0 ;
  wire \win_energy[27]_i_13_n_0 ;
  wire \win_energy[27]_i_15_n_0 ;
  wire \win_energy[27]_i_17_n_0 ;
  wire \win_energy[27]_i_2_n_0 ;
  wire \win_energy[27]_i_3_n_0 ;
  wire \win_energy[27]_i_4_n_0 ;
  wire \win_energy[27]_i_5_n_0 ;
  wire \win_energy[27]_i_6_n_0 ;
  wire \win_energy[27]_i_7_n_0 ;
  wire \win_energy[27]_i_8_n_0 ;
  wire \win_energy[27]_i_9_n_0 ;
  wire \win_energy[31]_i_11_n_0 ;
  wire \win_energy[31]_i_13_n_0 ;
  wire \win_energy[31]_i_15_n_0 ;
  wire \win_energy[31]_i_17_n_0 ;
  wire \win_energy[31]_i_2_n_0 ;
  wire \win_energy[31]_i_3_n_0 ;
  wire \win_energy[31]_i_4_n_0 ;
  wire \win_energy[31]_i_5_n_0 ;
  wire \win_energy[31]_i_6_n_0 ;
  wire \win_energy[31]_i_7_n_0 ;
  wire \win_energy[31]_i_8_n_0 ;
  wire \win_energy[31]_i_9_n_0 ;
  wire \win_energy[35]_i_10_n_0 ;
  wire \win_energy[35]_i_11_n_0 ;
  wire \win_energy[35]_i_2_n_0 ;
  wire \win_energy[35]_i_3_n_0 ;
  wire \win_energy[35]_i_4_n_0 ;
  wire \win_energy[35]_i_5_n_0 ;
  wire \win_energy[35]_i_6_n_0 ;
  wire \win_energy[35]_i_7_n_0 ;
  wire \win_energy[39]_i_2_n_0 ;
  wire \win_energy[39]_i_3_n_0 ;
  wire \win_energy[39]_i_4_n_0 ;
  wire \win_energy[39]_i_5_n_0 ;
  wire \win_energy[3]_i_11_n_0 ;
  wire \win_energy[3]_i_13_n_0 ;
  wire \win_energy[3]_i_2_n_0 ;
  wire \win_energy[3]_i_3_n_0 ;
  wire \win_energy[3]_i_4_n_0 ;
  wire \win_energy[3]_i_5_n_0 ;
  wire \win_energy[3]_i_6_n_0 ;
  wire \win_energy[3]_i_7_n_0 ;
  wire \win_energy[3]_i_8_n_0 ;
  wire \win_energy[3]_i_9_n_0 ;
  wire \win_energy[7]_i_11_n_0 ;
  wire \win_energy[7]_i_13_n_0 ;
  wire \win_energy[7]_i_15_n_0 ;
  wire \win_energy[7]_i_17_n_0 ;
  wire \win_energy[7]_i_2_n_0 ;
  wire \win_energy[7]_i_3_n_0 ;
  wire \win_energy[7]_i_4_n_0 ;
  wire \win_energy[7]_i_5_n_0 ;
  wire \win_energy[7]_i_6_n_0 ;
  wire \win_energy[7]_i_7_n_0 ;
  wire \win_energy[7]_i_8_n_0 ;
  wire \win_energy[7]_i_9_n_0 ;
  wire \win_energy_reg[11]_i_1_n_0 ;
  wire \win_energy_reg[11]_i_1_n_1 ;
  wire \win_energy_reg[11]_i_1_n_2 ;
  wire \win_energy_reg[11]_i_1_n_3 ;
  wire \win_energy_reg[11]_i_1_n_4 ;
  wire \win_energy_reg[11]_i_1_n_5 ;
  wire \win_energy_reg[11]_i_1_n_6 ;
  wire \win_energy_reg[11]_i_1_n_7 ;
  wire \win_energy_reg[15]_i_1_n_0 ;
  wire \win_energy_reg[15]_i_1_n_1 ;
  wire \win_energy_reg[15]_i_1_n_2 ;
  wire \win_energy_reg[15]_i_1_n_3 ;
  wire \win_energy_reg[15]_i_1_n_4 ;
  wire \win_energy_reg[15]_i_1_n_5 ;
  wire \win_energy_reg[15]_i_1_n_6 ;
  wire \win_energy_reg[15]_i_1_n_7 ;
  wire \win_energy_reg[19]_i_1_n_0 ;
  wire \win_energy_reg[19]_i_1_n_1 ;
  wire \win_energy_reg[19]_i_1_n_2 ;
  wire \win_energy_reg[19]_i_1_n_3 ;
  wire \win_energy_reg[19]_i_1_n_4 ;
  wire \win_energy_reg[19]_i_1_n_5 ;
  wire \win_energy_reg[19]_i_1_n_6 ;
  wire \win_energy_reg[19]_i_1_n_7 ;
  wire \win_energy_reg[23]_i_1_n_0 ;
  wire \win_energy_reg[23]_i_1_n_1 ;
  wire \win_energy_reg[23]_i_1_n_2 ;
  wire \win_energy_reg[23]_i_1_n_3 ;
  wire \win_energy_reg[23]_i_1_n_4 ;
  wire \win_energy_reg[23]_i_1_n_5 ;
  wire \win_energy_reg[23]_i_1_n_6 ;
  wire \win_energy_reg[23]_i_1_n_7 ;
  wire \win_energy_reg[27]_i_1_n_0 ;
  wire \win_energy_reg[27]_i_1_n_1 ;
  wire \win_energy_reg[27]_i_1_n_2 ;
  wire \win_energy_reg[27]_i_1_n_3 ;
  wire \win_energy_reg[27]_i_1_n_4 ;
  wire \win_energy_reg[27]_i_1_n_5 ;
  wire \win_energy_reg[27]_i_1_n_6 ;
  wire \win_energy_reg[27]_i_1_n_7 ;
  wire \win_energy_reg[31]_i_1_n_0 ;
  wire \win_energy_reg[31]_i_1_n_1 ;
  wire \win_energy_reg[31]_i_1_n_2 ;
  wire \win_energy_reg[31]_i_1_n_3 ;
  wire \win_energy_reg[31]_i_1_n_4 ;
  wire \win_energy_reg[31]_i_1_n_5 ;
  wire \win_energy_reg[31]_i_1_n_6 ;
  wire \win_energy_reg[31]_i_1_n_7 ;
  wire \win_energy_reg[35]_i_1_n_0 ;
  wire \win_energy_reg[35]_i_1_n_1 ;
  wire \win_energy_reg[35]_i_1_n_2 ;
  wire \win_energy_reg[35]_i_1_n_3 ;
  wire \win_energy_reg[35]_i_1_n_4 ;
  wire \win_energy_reg[35]_i_1_n_5 ;
  wire \win_energy_reg[35]_i_1_n_6 ;
  wire \win_energy_reg[35]_i_1_n_7 ;
  wire \win_energy_reg[39]_i_1_n_1 ;
  wire \win_energy_reg[39]_i_1_n_2 ;
  wire \win_energy_reg[39]_i_1_n_3 ;
  wire \win_energy_reg[39]_i_1_n_4 ;
  wire \win_energy_reg[39]_i_1_n_5 ;
  wire \win_energy_reg[39]_i_1_n_6 ;
  wire \win_energy_reg[39]_i_1_n_7 ;
  wire \win_energy_reg[3]_i_1_n_0 ;
  wire \win_energy_reg[3]_i_1_n_1 ;
  wire \win_energy_reg[3]_i_1_n_2 ;
  wire \win_energy_reg[3]_i_1_n_3 ;
  wire \win_energy_reg[3]_i_1_n_4 ;
  wire \win_energy_reg[3]_i_1_n_5 ;
  wire \win_energy_reg[3]_i_1_n_6 ;
  wire \win_energy_reg[3]_i_1_n_7 ;
  wire \win_energy_reg[7]_i_1_n_0 ;
  wire \win_energy_reg[7]_i_1_n_1 ;
  wire \win_energy_reg[7]_i_1_n_2 ;
  wire \win_energy_reg[7]_i_1_n_3 ;
  wire \win_energy_reg[7]_i_1_n_4 ;
  wire \win_energy_reg[7]_i_1_n_5 ;
  wire \win_energy_reg[7]_i_1_n_6 ;
  wire \win_energy_reg[7]_i_1_n_7 ;
  wire [0:0]win_mav;
  wire \win_mav[11]_i_10_n_0 ;
  wire \win_mav[11]_i_11_n_0 ;
  wire \win_mav[11]_i_12_n_0 ;
  wire \win_mav[11]_i_13_n_0 ;
  wire \win_mav[11]_i_14_n_0 ;
  wire \win_mav[11]_i_15_n_0 ;
  wire \win_mav[11]_i_16_n_0 ;
  wire \win_mav[11]_i_17_n_0 ;
  wire \win_mav[11]_i_18_n_0 ;
  wire \win_mav[11]_i_19_n_0 ;
  wire \win_mav[11]_i_20_n_0 ;
  wire \win_mav[11]_i_21_n_0 ;
  wire \win_mav[11]_i_2_n_0 ;
  wire \win_mav[11]_i_3_n_0 ;
  wire \win_mav[11]_i_4_n_0 ;
  wire \win_mav[11]_i_5_n_0 ;
  wire \win_mav[11]_i_6_n_0 ;
  wire \win_mav[11]_i_7_n_0 ;
  wire \win_mav[11]_i_8_n_0 ;
  wire \win_mav[11]_i_9_n_0 ;
  wire \win_mav[15]_i_10_n_0 ;
  wire \win_mav[15]_i_11_n_0 ;
  wire \win_mav[15]_i_12_n_0 ;
  wire \win_mav[15]_i_13_n_0 ;
  wire \win_mav[15]_i_14_n_0 ;
  wire \win_mav[15]_i_15_n_0 ;
  wire \win_mav[15]_i_16_n_0 ;
  wire \win_mav[15]_i_17_n_0 ;
  wire \win_mav[15]_i_18_n_0 ;
  wire \win_mav[15]_i_19_n_0 ;
  wire \win_mav[15]_i_20_n_0 ;
  wire \win_mav[15]_i_21_n_0 ;
  wire \win_mav[15]_i_2_n_0 ;
  wire \win_mav[15]_i_3_n_0 ;
  wire \win_mav[15]_i_4_n_0 ;
  wire \win_mav[15]_i_5_n_0 ;
  wire \win_mav[15]_i_6_n_0 ;
  wire \win_mav[15]_i_7_n_0 ;
  wire \win_mav[15]_i_8_n_0 ;
  wire \win_mav[15]_i_9_n_0 ;
  wire \win_mav[19]_i_10_n_0 ;
  wire \win_mav[19]_i_11_n_0 ;
  wire \win_mav[19]_i_12_n_0 ;
  wire \win_mav[19]_i_13_n_0 ;
  wire \win_mav[19]_i_14_n_0 ;
  wire \win_mav[19]_i_15_n_0 ;
  wire \win_mav[19]_i_16_n_0 ;
  wire \win_mav[19]_i_17_n_0 ;
  wire \win_mav[19]_i_18_n_0 ;
  wire \win_mav[19]_i_19_n_0 ;
  wire \win_mav[19]_i_20_n_0 ;
  wire \win_mav[19]_i_21_n_0 ;
  wire \win_mav[19]_i_2_n_0 ;
  wire \win_mav[19]_i_3_n_0 ;
  wire \win_mav[19]_i_4_n_0 ;
  wire \win_mav[19]_i_5_n_0 ;
  wire \win_mav[19]_i_6_n_0 ;
  wire \win_mav[19]_i_7_n_0 ;
  wire \win_mav[19]_i_8_n_0 ;
  wire \win_mav[19]_i_9_n_0 ;
  wire \win_mav[23]_i_10_n_0 ;
  wire \win_mav[23]_i_11_n_0 ;
  wire \win_mav[23]_i_12_n_0 ;
  wire \win_mav[23]_i_13_n_0 ;
  wire \win_mav[23]_i_14_n_0 ;
  wire \win_mav[23]_i_15_n_0 ;
  wire \win_mav[23]_i_16_n_0 ;
  wire \win_mav[23]_i_17_n_0 ;
  wire \win_mav[23]_i_18_n_0 ;
  wire \win_mav[23]_i_19_n_0 ;
  wire \win_mav[23]_i_20_n_0 ;
  wire \win_mav[23]_i_21_n_0 ;
  wire \win_mav[23]_i_22_n_0 ;
  wire \win_mav[23]_i_2_n_0 ;
  wire \win_mav[23]_i_3_n_0 ;
  wire \win_mav[23]_i_4_n_0 ;
  wire \win_mav[23]_i_5_n_0 ;
  wire \win_mav[23]_i_6_n_0 ;
  wire \win_mav[23]_i_7_n_0 ;
  wire \win_mav[23]_i_8_n_0 ;
  wire \win_mav[23]_i_9_n_0 ;
  wire \win_mav[27]_i_10_n_0 ;
  wire \win_mav[27]_i_11_n_0 ;
  wire \win_mav[27]_i_12_n_0 ;
  wire \win_mav[27]_i_13_n_0 ;
  wire \win_mav[27]_i_14_n_0 ;
  wire \win_mav[27]_i_15_n_0 ;
  wire \win_mav[27]_i_16_n_0 ;
  wire \win_mav[27]_i_17_n_0 ;
  wire \win_mav[27]_i_18_n_0 ;
  wire \win_mav[27]_i_19_n_0 ;
  wire \win_mav[27]_i_20_n_0 ;
  wire \win_mav[27]_i_2_n_0 ;
  wire \win_mav[27]_i_3_n_0 ;
  wire \win_mav[27]_i_4_n_0 ;
  wire \win_mav[27]_i_5_n_0 ;
  wire \win_mav[27]_i_6_n_0 ;
  wire \win_mav[27]_i_7_n_0 ;
  wire \win_mav[27]_i_8_n_0 ;
  wire \win_mav[27]_i_9_n_0 ;
  wire \win_mav[31]_i_10_n_0 ;
  wire \win_mav[31]_i_11_n_0 ;
  wire \win_mav[31]_i_12_n_0 ;
  wire \win_mav[31]_i_13_n_0 ;
  wire \win_mav[31]_i_14_n_0 ;
  wire \win_mav[31]_i_15_n_0 ;
  wire \win_mav[31]_i_16_n_0 ;
  wire \win_mav[31]_i_17_n_0 ;
  wire \win_mav[31]_i_18_n_0 ;
  wire \win_mav[31]_i_19_n_0 ;
  wire \win_mav[31]_i_20_n_0 ;
  wire \win_mav[31]_i_21_n_0 ;
  wire \win_mav[31]_i_22_n_0 ;
  wire \win_mav[31]_i_23_n_0 ;
  wire \win_mav[31]_i_24_n_0 ;
  wire \win_mav[31]_i_25_n_0 ;
  wire \win_mav[31]_i_26_n_0 ;
  wire \win_mav[31]_i_27_n_0 ;
  wire \win_mav[31]_i_28_n_0 ;
  wire \win_mav[31]_i_29_n_0 ;
  wire \win_mav[31]_i_2_n_0 ;
  wire \win_mav[31]_i_30_n_0 ;
  wire \win_mav[31]_i_3_n_0 ;
  wire \win_mav[31]_i_4_n_0 ;
  wire \win_mav[31]_i_5_n_0 ;
  wire \win_mav[31]_i_6_n_0 ;
  wire \win_mav[31]_i_7_n_0 ;
  wire \win_mav[31]_i_8_n_0 ;
  wire \win_mav[31]_i_9_n_0 ;
  wire \win_mav[35]_i_10_n_0 ;
  wire \win_mav[35]_i_11_n_0 ;
  wire \win_mav[35]_i_12_n_0 ;
  wire \win_mav[35]_i_2_n_0 ;
  wire \win_mav[35]_i_3_n_0 ;
  wire \win_mav[35]_i_4_n_0 ;
  wire \win_mav[35]_i_5_n_0 ;
  wire \win_mav[35]_i_6_n_0 ;
  wire \win_mav[35]_i_7_n_0 ;
  wire \win_mav[35]_i_8_n_0 ;
  wire \win_mav[35]_i_9_n_0 ;
  wire \win_mav[39]_i_2_n_0 ;
  wire \win_mav[39]_i_3_n_0 ;
  wire \win_mav[39]_i_4_n_0 ;
  wire \win_mav[39]_i_5_n_0 ;
  wire \win_mav[3]_i_10_n_0 ;
  wire \win_mav[3]_i_11_n_0 ;
  wire \win_mav[3]_i_12_n_0 ;
  wire \win_mav[3]_i_13_n_0 ;
  wire \win_mav[3]_i_14_n_0 ;
  wire \win_mav[3]_i_2_n_0 ;
  wire \win_mav[3]_i_3_n_0 ;
  wire \win_mav[3]_i_4_n_0 ;
  wire \win_mav[3]_i_5_n_0 ;
  wire \win_mav[3]_i_6_n_0 ;
  wire \win_mav[3]_i_7_n_0 ;
  wire \win_mav[3]_i_8_n_0 ;
  wire \win_mav[3]_i_9_n_0 ;
  wire \win_mav[7]_i_10_n_0 ;
  wire \win_mav[7]_i_11_n_0 ;
  wire \win_mav[7]_i_12_n_0 ;
  wire \win_mav[7]_i_13_n_0 ;
  wire \win_mav[7]_i_14_n_0 ;
  wire \win_mav[7]_i_15_n_0 ;
  wire \win_mav[7]_i_16_n_0 ;
  wire \win_mav[7]_i_17_n_0 ;
  wire \win_mav[7]_i_18_n_0 ;
  wire \win_mav[7]_i_19_n_0 ;
  wire \win_mav[7]_i_20_n_0 ;
  wire \win_mav[7]_i_21_n_0 ;
  wire \win_mav[7]_i_2_n_0 ;
  wire \win_mav[7]_i_3_n_0 ;
  wire \win_mav[7]_i_4_n_0 ;
  wire \win_mav[7]_i_5_n_0 ;
  wire \win_mav[7]_i_6_n_0 ;
  wire \win_mav[7]_i_7_n_0 ;
  wire \win_mav[7]_i_8_n_0 ;
  wire \win_mav[7]_i_9_n_0 ;
  wire \win_mav_reg[11]_i_1_n_0 ;
  wire \win_mav_reg[11]_i_1_n_1 ;
  wire \win_mav_reg[11]_i_1_n_2 ;
  wire \win_mav_reg[11]_i_1_n_3 ;
  wire \win_mav_reg[11]_i_1_n_4 ;
  wire \win_mav_reg[11]_i_1_n_5 ;
  wire \win_mav_reg[11]_i_1_n_6 ;
  wire \win_mav_reg[11]_i_1_n_7 ;
  wire \win_mav_reg[15]_i_1_n_0 ;
  wire \win_mav_reg[15]_i_1_n_1 ;
  wire \win_mav_reg[15]_i_1_n_2 ;
  wire \win_mav_reg[15]_i_1_n_3 ;
  wire \win_mav_reg[15]_i_1_n_4 ;
  wire \win_mav_reg[15]_i_1_n_5 ;
  wire \win_mav_reg[15]_i_1_n_6 ;
  wire \win_mav_reg[15]_i_1_n_7 ;
  wire \win_mav_reg[19]_i_1_n_0 ;
  wire \win_mav_reg[19]_i_1_n_1 ;
  wire \win_mav_reg[19]_i_1_n_2 ;
  wire \win_mav_reg[19]_i_1_n_3 ;
  wire \win_mav_reg[19]_i_1_n_4 ;
  wire \win_mav_reg[19]_i_1_n_5 ;
  wire \win_mav_reg[19]_i_1_n_6 ;
  wire \win_mav_reg[19]_i_1_n_7 ;
  wire \win_mav_reg[23]_i_1_n_0 ;
  wire \win_mav_reg[23]_i_1_n_1 ;
  wire \win_mav_reg[23]_i_1_n_2 ;
  wire \win_mav_reg[23]_i_1_n_3 ;
  wire \win_mav_reg[23]_i_1_n_4 ;
  wire \win_mav_reg[23]_i_1_n_5 ;
  wire \win_mav_reg[23]_i_1_n_6 ;
  wire \win_mav_reg[23]_i_1_n_7 ;
  wire \win_mav_reg[27]_i_1_n_0 ;
  wire \win_mav_reg[27]_i_1_n_1 ;
  wire \win_mav_reg[27]_i_1_n_2 ;
  wire \win_mav_reg[27]_i_1_n_3 ;
  wire \win_mav_reg[27]_i_1_n_4 ;
  wire \win_mav_reg[27]_i_1_n_5 ;
  wire \win_mav_reg[27]_i_1_n_6 ;
  wire \win_mav_reg[27]_i_1_n_7 ;
  wire \win_mav_reg[31]_i_1_n_0 ;
  wire \win_mav_reg[31]_i_1_n_1 ;
  wire \win_mav_reg[31]_i_1_n_2 ;
  wire \win_mav_reg[31]_i_1_n_3 ;
  wire \win_mav_reg[31]_i_1_n_4 ;
  wire \win_mav_reg[31]_i_1_n_5 ;
  wire \win_mav_reg[31]_i_1_n_6 ;
  wire \win_mav_reg[31]_i_1_n_7 ;
  wire \win_mav_reg[35]_i_1_n_0 ;
  wire \win_mav_reg[35]_i_1_n_1 ;
  wire \win_mav_reg[35]_i_1_n_2 ;
  wire \win_mav_reg[35]_i_1_n_3 ;
  wire \win_mav_reg[35]_i_1_n_4 ;
  wire \win_mav_reg[35]_i_1_n_5 ;
  wire \win_mav_reg[35]_i_1_n_6 ;
  wire \win_mav_reg[35]_i_1_n_7 ;
  wire \win_mav_reg[39]_i_1_n_1 ;
  wire \win_mav_reg[39]_i_1_n_2 ;
  wire \win_mav_reg[39]_i_1_n_3 ;
  wire \win_mav_reg[39]_i_1_n_4 ;
  wire \win_mav_reg[39]_i_1_n_5 ;
  wire \win_mav_reg[39]_i_1_n_6 ;
  wire \win_mav_reg[39]_i_1_n_7 ;
  wire \win_mav_reg[3]_i_1_n_0 ;
  wire \win_mav_reg[3]_i_1_n_1 ;
  wire \win_mav_reg[3]_i_1_n_2 ;
  wire \win_mav_reg[3]_i_1_n_3 ;
  wire \win_mav_reg[3]_i_1_n_4 ;
  wire \win_mav_reg[3]_i_1_n_5 ;
  wire \win_mav_reg[3]_i_1_n_6 ;
  wire \win_mav_reg[3]_i_1_n_7 ;
  wire \win_mav_reg[7]_i_1_n_0 ;
  wire \win_mav_reg[7]_i_1_n_1 ;
  wire \win_mav_reg[7]_i_1_n_2 ;
  wire \win_mav_reg[7]_i_1_n_3 ;
  wire \win_mav_reg[7]_i_1_n_4 ;
  wire \win_mav_reg[7]_i_1_n_5 ;
  wire \win_mav_reg[7]_i_1_n_6 ;
  wire \win_mav_reg[7]_i_1_n_7 ;
  wire \win_mav_reg_n_0_[0] ;
  wire \win_mav_reg_n_0_[10] ;
  wire \win_mav_reg_n_0_[11] ;
  wire \win_mav_reg_n_0_[12] ;
  wire \win_mav_reg_n_0_[13] ;
  wire \win_mav_reg_n_0_[14] ;
  wire \win_mav_reg_n_0_[15] ;
  wire \win_mav_reg_n_0_[16] ;
  wire \win_mav_reg_n_0_[17] ;
  wire \win_mav_reg_n_0_[18] ;
  wire \win_mav_reg_n_0_[19] ;
  wire \win_mav_reg_n_0_[1] ;
  wire \win_mav_reg_n_0_[20] ;
  wire \win_mav_reg_n_0_[21] ;
  wire \win_mav_reg_n_0_[22] ;
  wire \win_mav_reg_n_0_[23] ;
  wire \win_mav_reg_n_0_[24] ;
  wire \win_mav_reg_n_0_[25] ;
  wire \win_mav_reg_n_0_[26] ;
  wire \win_mav_reg_n_0_[27] ;
  wire \win_mav_reg_n_0_[28] ;
  wire \win_mav_reg_n_0_[29] ;
  wire \win_mav_reg_n_0_[2] ;
  wire \win_mav_reg_n_0_[30] ;
  wire \win_mav_reg_n_0_[31] ;
  wire \win_mav_reg_n_0_[32] ;
  wire \win_mav_reg_n_0_[33] ;
  wire \win_mav_reg_n_0_[34] ;
  wire \win_mav_reg_n_0_[35] ;
  wire \win_mav_reg_n_0_[36] ;
  wire \win_mav_reg_n_0_[37] ;
  wire \win_mav_reg_n_0_[38] ;
  wire \win_mav_reg_n_0_[39] ;
  wire \win_mav_reg_n_0_[3] ;
  wire \win_mav_reg_n_0_[4] ;
  wire \win_mav_reg_n_0_[5] ;
  wire \win_mav_reg_n_0_[6] ;
  wire \win_mav_reg_n_0_[7] ;
  wire \win_mav_reg_n_0_[8] ;
  wire \win_mav_reg_n_0_[9] ;
  wire [8:0]win_ssc;
  wire \win_ssc[3]_i_12_n_0 ;
  wire \win_ssc[3]_i_13_n_0 ;
  wire \win_ssc[3]_i_2_n_0 ;
  wire \win_ssc[3]_i_3_n_0 ;
  wire \win_ssc[3]_i_4_n_0 ;
  wire \win_ssc[3]_i_5_n_0 ;
  wire \win_ssc[3]_i_6_n_0 ;
  wire \win_ssc[3]_i_7_n_0 ;
  wire \win_ssc[3]_i_8_n_0 ;
  wire \win_ssc[3]_i_9_n_0 ;
  wire \win_ssc[7]_i_14_n_0 ;
  wire \win_ssc[7]_i_15_n_0 ;
  wire \win_ssc[7]_i_16_n_0 ;
  wire \win_ssc[7]_i_17_n_0 ;
  wire \win_ssc[7]_i_2_n_0 ;
  wire \win_ssc[7]_i_3_n_0 ;
  wire \win_ssc[7]_i_4_n_0 ;
  wire \win_ssc[7]_i_5_n_0 ;
  wire \win_ssc[7]_i_6_n_0 ;
  wire \win_ssc[7]_i_7_n_0 ;
  wire \win_ssc[7]_i_8_n_0 ;
  wire \win_ssc[7]_i_9_n_0 ;
  wire \win_ssc[8]_i_2_n_0 ;
  wire \win_ssc_reg[3]_i_1_n_0 ;
  wire \win_ssc_reg[3]_i_1_n_1 ;
  wire \win_ssc_reg[3]_i_1_n_2 ;
  wire \win_ssc_reg[3]_i_1_n_3 ;
  wire \win_ssc_reg[3]_i_1_n_4 ;
  wire \win_ssc_reg[3]_i_1_n_5 ;
  wire \win_ssc_reg[3]_i_1_n_6 ;
  wire \win_ssc_reg[3]_i_1_n_7 ;
  wire \win_ssc_reg[7]_i_1_n_0 ;
  wire \win_ssc_reg[7]_i_1_n_1 ;
  wire \win_ssc_reg[7]_i_1_n_2 ;
  wire \win_ssc_reg[7]_i_1_n_3 ;
  wire \win_ssc_reg[7]_i_1_n_4 ;
  wire \win_ssc_reg[7]_i_1_n_5 ;
  wire \win_ssc_reg[7]_i_1_n_6 ;
  wire \win_ssc_reg[7]_i_1_n_7 ;
  wire \win_ssc_reg[8]_i_1_n_7 ;
  wire [39:0]win_wl;
  wire \win_wl[11]_i_10_n_0 ;
  wire \win_wl[11]_i_11_n_0 ;
  wire \win_wl[11]_i_12_n_0 ;
  wire \win_wl[11]_i_13_n_0 ;
  wire \win_wl[11]_i_14_n_0 ;
  wire \win_wl[11]_i_15_n_0 ;
  wire \win_wl[11]_i_16_n_0 ;
  wire \win_wl[11]_i_17_n_0 ;
  wire \win_wl[11]_i_2_n_0 ;
  wire \win_wl[11]_i_3_n_0 ;
  wire \win_wl[11]_i_4_n_0 ;
  wire \win_wl[11]_i_5_n_0 ;
  wire \win_wl[11]_i_6_n_0 ;
  wire \win_wl[11]_i_7_n_0 ;
  wire \win_wl[11]_i_8_n_0 ;
  wire \win_wl[11]_i_9_n_0 ;
  wire \win_wl[15]_i_10_n_0 ;
  wire \win_wl[15]_i_11_n_0 ;
  wire \win_wl[15]_i_12_n_0 ;
  wire \win_wl[15]_i_13_n_0 ;
  wire \win_wl[15]_i_14_n_0 ;
  wire \win_wl[15]_i_15_n_0 ;
  wire \win_wl[15]_i_16_n_0 ;
  wire \win_wl[15]_i_17_n_0 ;
  wire \win_wl[15]_i_2_n_0 ;
  wire \win_wl[15]_i_3_n_0 ;
  wire \win_wl[15]_i_4_n_0 ;
  wire \win_wl[15]_i_5_n_0 ;
  wire \win_wl[15]_i_6_n_0 ;
  wire \win_wl[15]_i_7_n_0 ;
  wire \win_wl[15]_i_8_n_0 ;
  wire \win_wl[15]_i_9_n_0 ;
  wire \win_wl[19]_i_10_n_0 ;
  wire \win_wl[19]_i_11_n_0 ;
  wire \win_wl[19]_i_12_n_0 ;
  wire \win_wl[19]_i_13_n_0 ;
  wire \win_wl[19]_i_14_n_0 ;
  wire \win_wl[19]_i_15_n_0 ;
  wire \win_wl[19]_i_16_n_0 ;
  wire \win_wl[19]_i_17_n_0 ;
  wire \win_wl[19]_i_2_n_0 ;
  wire \win_wl[19]_i_3_n_0 ;
  wire \win_wl[19]_i_4_n_0 ;
  wire \win_wl[19]_i_5_n_0 ;
  wire \win_wl[19]_i_6_n_0 ;
  wire \win_wl[19]_i_7_n_0 ;
  wire \win_wl[19]_i_8_n_0 ;
  wire \win_wl[19]_i_9_n_0 ;
  wire \win_wl[23]_i_10_n_0 ;
  wire \win_wl[23]_i_11_n_0 ;
  wire \win_wl[23]_i_12_n_0 ;
  wire \win_wl[23]_i_13_n_0 ;
  wire \win_wl[23]_i_14_n_0 ;
  wire \win_wl[23]_i_15_n_0 ;
  wire \win_wl[23]_i_16_n_0 ;
  wire \win_wl[23]_i_17_n_0 ;
  wire \win_wl[23]_i_2_n_0 ;
  wire \win_wl[23]_i_3_n_0 ;
  wire \win_wl[23]_i_4_n_0 ;
  wire \win_wl[23]_i_5_n_0 ;
  wire \win_wl[23]_i_6_n_0 ;
  wire \win_wl[23]_i_7_n_0 ;
  wire \win_wl[23]_i_8_n_0 ;
  wire \win_wl[23]_i_9_n_0 ;
  wire \win_wl[27]_i_10_n_0 ;
  wire \win_wl[27]_i_11_n_0 ;
  wire \win_wl[27]_i_12_n_0 ;
  wire \win_wl[27]_i_13_n_0 ;
  wire \win_wl[27]_i_14_n_0 ;
  wire \win_wl[27]_i_15_n_0 ;
  wire \win_wl[27]_i_16_n_0 ;
  wire \win_wl[27]_i_17_n_0 ;
  wire \win_wl[27]_i_18_n_0 ;
  wire \win_wl[27]_i_20_n_0 ;
  wire \win_wl[27]_i_2_n_0 ;
  wire \win_wl[27]_i_3_n_0 ;
  wire \win_wl[27]_i_4_n_0 ;
  wire \win_wl[27]_i_5_n_0 ;
  wire \win_wl[27]_i_6_n_0 ;
  wire \win_wl[27]_i_7_n_0 ;
  wire \win_wl[27]_i_8_n_0 ;
  wire \win_wl[27]_i_9_n_0 ;
  wire \win_wl[31]_i_10_n_0 ;
  wire \win_wl[31]_i_12_n_0 ;
  wire \win_wl[31]_i_13_n_0 ;
  wire \win_wl[31]_i_15_n_0 ;
  wire \win_wl[31]_i_16_n_0 ;
  wire \win_wl[31]_i_18_n_0 ;
  wire \win_wl[31]_i_19_n_0 ;
  wire \win_wl[31]_i_21_n_0 ;
  wire \win_wl[31]_i_22_n_0 ;
  wire \win_wl[31]_i_23_n_0 ;
  wire \win_wl[31]_i_24_n_0 ;
  wire \win_wl[31]_i_25_n_0 ;
  wire \win_wl[31]_i_26_n_0 ;
  wire \win_wl[31]_i_27_n_0 ;
  wire \win_wl[31]_i_28_n_0 ;
  wire \win_wl[31]_i_29_n_0 ;
  wire \win_wl[31]_i_2_n_0 ;
  wire \win_wl[31]_i_3_n_0 ;
  wire \win_wl[31]_i_4_n_0 ;
  wire \win_wl[31]_i_5_n_0 ;
  wire \win_wl[31]_i_6_n_0 ;
  wire \win_wl[31]_i_7_n_0 ;
  wire \win_wl[31]_i_8_n_0 ;
  wire \win_wl[31]_i_9_n_0 ;
  wire \win_wl[35]_i_10_n_0 ;
  wire \win_wl[35]_i_11_n_0 ;
  wire \win_wl[35]_i_12_n_0 ;
  wire \win_wl[35]_i_2_n_0 ;
  wire \win_wl[35]_i_3_n_0 ;
  wire \win_wl[35]_i_4_n_0 ;
  wire \win_wl[35]_i_5_n_0 ;
  wire \win_wl[35]_i_6_n_0 ;
  wire \win_wl[35]_i_7_n_0 ;
  wire \win_wl[39]_i_2_n_0 ;
  wire \win_wl[39]_i_3_n_0 ;
  wire \win_wl[39]_i_4_n_0 ;
  wire \win_wl[39]_i_5_n_0 ;
  wire \win_wl[3]_i_10_n_0 ;
  wire \win_wl[3]_i_11_n_0 ;
  wire \win_wl[3]_i_12_n_0 ;
  wire \win_wl[3]_i_2_n_0 ;
  wire \win_wl[3]_i_3_n_0 ;
  wire \win_wl[3]_i_4_n_0 ;
  wire \win_wl[3]_i_5_n_0 ;
  wire \win_wl[3]_i_6_n_0 ;
  wire \win_wl[3]_i_7_n_0 ;
  wire \win_wl[3]_i_8_n_0 ;
  wire \win_wl[3]_i_9_n_0 ;
  wire \win_wl[7]_i_10_n_0 ;
  wire \win_wl[7]_i_11_n_0 ;
  wire \win_wl[7]_i_12_n_0 ;
  wire \win_wl[7]_i_13_n_0 ;
  wire \win_wl[7]_i_14_n_0 ;
  wire \win_wl[7]_i_15_n_0 ;
  wire \win_wl[7]_i_16_n_0 ;
  wire \win_wl[7]_i_17_n_0 ;
  wire \win_wl[7]_i_2_n_0 ;
  wire \win_wl[7]_i_3_n_0 ;
  wire \win_wl[7]_i_4_n_0 ;
  wire \win_wl[7]_i_5_n_0 ;
  wire \win_wl[7]_i_6_n_0 ;
  wire \win_wl[7]_i_7_n_0 ;
  wire \win_wl[7]_i_8_n_0 ;
  wire \win_wl[7]_i_9_n_0 ;
  wire \win_wl_reg[11]_i_1_n_0 ;
  wire \win_wl_reg[11]_i_1_n_1 ;
  wire \win_wl_reg[11]_i_1_n_2 ;
  wire \win_wl_reg[11]_i_1_n_3 ;
  wire \win_wl_reg[11]_i_1_n_4 ;
  wire \win_wl_reg[11]_i_1_n_5 ;
  wire \win_wl_reg[11]_i_1_n_6 ;
  wire \win_wl_reg[11]_i_1_n_7 ;
  wire \win_wl_reg[15]_i_1_n_0 ;
  wire \win_wl_reg[15]_i_1_n_1 ;
  wire \win_wl_reg[15]_i_1_n_2 ;
  wire \win_wl_reg[15]_i_1_n_3 ;
  wire \win_wl_reg[15]_i_1_n_4 ;
  wire \win_wl_reg[15]_i_1_n_5 ;
  wire \win_wl_reg[15]_i_1_n_6 ;
  wire \win_wl_reg[15]_i_1_n_7 ;
  wire \win_wl_reg[19]_i_1_n_0 ;
  wire \win_wl_reg[19]_i_1_n_1 ;
  wire \win_wl_reg[19]_i_1_n_2 ;
  wire \win_wl_reg[19]_i_1_n_3 ;
  wire \win_wl_reg[19]_i_1_n_4 ;
  wire \win_wl_reg[19]_i_1_n_5 ;
  wire \win_wl_reg[19]_i_1_n_6 ;
  wire \win_wl_reg[19]_i_1_n_7 ;
  wire \win_wl_reg[23]_i_1_n_0 ;
  wire \win_wl_reg[23]_i_1_n_1 ;
  wire \win_wl_reg[23]_i_1_n_2 ;
  wire \win_wl_reg[23]_i_1_n_3 ;
  wire \win_wl_reg[23]_i_1_n_4 ;
  wire \win_wl_reg[23]_i_1_n_5 ;
  wire \win_wl_reg[23]_i_1_n_6 ;
  wire \win_wl_reg[23]_i_1_n_7 ;
  wire \win_wl_reg[27]_i_1_n_0 ;
  wire \win_wl_reg[27]_i_1_n_1 ;
  wire \win_wl_reg[27]_i_1_n_2 ;
  wire \win_wl_reg[27]_i_1_n_3 ;
  wire \win_wl_reg[27]_i_1_n_4 ;
  wire \win_wl_reg[27]_i_1_n_5 ;
  wire \win_wl_reg[27]_i_1_n_6 ;
  wire \win_wl_reg[27]_i_1_n_7 ;
  wire \win_wl_reg[31]_i_1_n_0 ;
  wire \win_wl_reg[31]_i_1_n_1 ;
  wire \win_wl_reg[31]_i_1_n_2 ;
  wire \win_wl_reg[31]_i_1_n_3 ;
  wire \win_wl_reg[31]_i_1_n_4 ;
  wire \win_wl_reg[31]_i_1_n_5 ;
  wire \win_wl_reg[31]_i_1_n_6 ;
  wire \win_wl_reg[31]_i_1_n_7 ;
  wire \win_wl_reg[35]_i_1_n_0 ;
  wire \win_wl_reg[35]_i_1_n_1 ;
  wire \win_wl_reg[35]_i_1_n_2 ;
  wire \win_wl_reg[35]_i_1_n_3 ;
  wire \win_wl_reg[35]_i_1_n_4 ;
  wire \win_wl_reg[35]_i_1_n_5 ;
  wire \win_wl_reg[35]_i_1_n_6 ;
  wire \win_wl_reg[35]_i_1_n_7 ;
  wire \win_wl_reg[39]_i_1_n_1 ;
  wire \win_wl_reg[39]_i_1_n_2 ;
  wire \win_wl_reg[39]_i_1_n_3 ;
  wire \win_wl_reg[39]_i_1_n_4 ;
  wire \win_wl_reg[39]_i_1_n_5 ;
  wire \win_wl_reg[39]_i_1_n_6 ;
  wire \win_wl_reg[39]_i_1_n_7 ;
  wire \win_wl_reg[3]_i_1_n_0 ;
  wire \win_wl_reg[3]_i_1_n_1 ;
  wire \win_wl_reg[3]_i_1_n_2 ;
  wire \win_wl_reg[3]_i_1_n_3 ;
  wire \win_wl_reg[3]_i_1_n_4 ;
  wire \win_wl_reg[3]_i_1_n_5 ;
  wire \win_wl_reg[3]_i_1_n_6 ;
  wire \win_wl_reg[3]_i_1_n_7 ;
  wire \win_wl_reg[7]_i_1_n_0 ;
  wire \win_wl_reg[7]_i_1_n_1 ;
  wire \win_wl_reg[7]_i_1_n_2 ;
  wire \win_wl_reg[7]_i_1_n_3 ;
  wire \win_wl_reg[7]_i_1_n_4 ;
  wire \win_wl_reg[7]_i_1_n_5 ;
  wire \win_wl_reg[7]_i_1_n_6 ;
  wire \win_wl_reg[7]_i_1_n_7 ;
  wire [8:0]win_zc;
  wire \win_zc[3]_i_12_n_0 ;
  wire \win_zc[3]_i_13_n_0 ;
  wire \win_zc[3]_i_2_n_0 ;
  wire \win_zc[3]_i_3_n_0 ;
  wire \win_zc[3]_i_4_n_0 ;
  wire \win_zc[3]_i_5_n_0 ;
  wire \win_zc[3]_i_6_n_0 ;
  wire \win_zc[3]_i_7_n_0 ;
  wire \win_zc[3]_i_8_n_0 ;
  wire \win_zc[3]_i_9_n_0 ;
  wire \win_zc[7]_i_14_n_0 ;
  wire \win_zc[7]_i_15_n_0 ;
  wire \win_zc[7]_i_16_n_0 ;
  wire \win_zc[7]_i_17_n_0 ;
  wire \win_zc[7]_i_2_n_0 ;
  wire \win_zc[7]_i_3_n_0 ;
  wire \win_zc[7]_i_4_n_0 ;
  wire \win_zc[7]_i_5_n_0 ;
  wire \win_zc[7]_i_6_n_0 ;
  wire \win_zc[7]_i_7_n_0 ;
  wire \win_zc[7]_i_8_n_0 ;
  wire \win_zc[7]_i_9_n_0 ;
  wire \win_zc[8]_i_2_n_0 ;
  wire \win_zc_reg[3]_i_1_n_0 ;
  wire \win_zc_reg[3]_i_1_n_1 ;
  wire \win_zc_reg[3]_i_1_n_2 ;
  wire \win_zc_reg[3]_i_1_n_3 ;
  wire \win_zc_reg[3]_i_1_n_4 ;
  wire \win_zc_reg[3]_i_1_n_5 ;
  wire \win_zc_reg[3]_i_1_n_6 ;
  wire \win_zc_reg[3]_i_1_n_7 ;
  wire \win_zc_reg[7]_i_1_n_0 ;
  wire \win_zc_reg[7]_i_1_n_1 ;
  wire \win_zc_reg[7]_i_1_n_2 ;
  wire \win_zc_reg[7]_i_1_n_3 ;
  wire \win_zc_reg[7]_i_1_n_4 ;
  wire \win_zc_reg[7]_i_1_n_5 ;
  wire \win_zc_reg[7]_i_1_n_6 ;
  wire \win_zc_reg[7]_i_1_n_7 ;
  wire \win_zc_reg[8]_i_1_n_7 ;
  wire window_valid;
  wire window_valid0;
  wire window_valid13_in;
  wire window_valid_i_1_n_0;
  wire window_valid_i_3_n_0;
  wire window_valid_i_4_n_0;
  wire [31:0]wl_sum;
  wire \wl_sum[0]_i_1_n_0 ;
  wire \wl_sum[10]_i_1_n_0 ;
  wire \wl_sum[11]_i_1_n_0 ;
  wire \wl_sum[12]_i_1_n_0 ;
  wire \wl_sum[13]_i_1_n_0 ;
  wire \wl_sum[14]_i_1_n_0 ;
  wire \wl_sum[15]_i_1_n_0 ;
  wire \wl_sum[16]_i_1_n_0 ;
  wire \wl_sum[17]_i_1_n_0 ;
  wire \wl_sum[18]_i_1_n_0 ;
  wire \wl_sum[19]_i_1_n_0 ;
  wire \wl_sum[1]_i_1_n_0 ;
  wire \wl_sum[20]_i_1_n_0 ;
  wire \wl_sum[21]_i_1_n_0 ;
  wire \wl_sum[22]_i_1_n_0 ;
  wire \wl_sum[23]_i_1_n_0 ;
  wire \wl_sum[24]_i_1_n_0 ;
  wire \wl_sum[25]_i_1_n_0 ;
  wire \wl_sum[26]_i_1_n_0 ;
  wire \wl_sum[27]_i_1_n_0 ;
  wire \wl_sum[28]_i_1_n_0 ;
  wire \wl_sum[29]_i_1_n_0 ;
  wire \wl_sum[2]_i_1_n_0 ;
  wire \wl_sum[30]_i_1_n_0 ;
  wire \wl_sum[31]_i_10_n_0 ;
  wire \wl_sum[31]_i_11_n_0 ;
  wire \wl_sum[31]_i_12_n_0 ;
  wire \wl_sum[31]_i_13_n_0 ;
  wire \wl_sum[31]_i_14_n_0 ;
  wire \wl_sum[31]_i_15_n_0 ;
  wire \wl_sum[31]_i_16_n_0 ;
  wire \wl_sum[31]_i_17_n_0 ;
  wire \wl_sum[31]_i_18_n_0 ;
  wire \wl_sum[31]_i_19_n_0 ;
  wire \wl_sum[31]_i_1_n_0 ;
  wire \wl_sum[31]_i_20_n_0 ;
  wire \wl_sum[31]_i_21_n_0 ;
  wire \wl_sum[31]_i_22_n_0 ;
  wire \wl_sum[31]_i_23_n_0 ;
  wire \wl_sum[31]_i_24_n_0 ;
  wire \wl_sum[31]_i_25_n_0 ;
  wire \wl_sum[31]_i_5_n_0 ;
  wire \wl_sum[31]_i_6_n_0 ;
  wire \wl_sum[31]_i_8_n_0 ;
  wire \wl_sum[31]_i_9_n_0 ;
  wire \wl_sum[3]_i_1_n_0 ;
  wire \wl_sum[4]_i_1_n_0 ;
  wire \wl_sum[5]_i_1_n_0 ;
  wire \wl_sum[6]_i_1_n_0 ;
  wire \wl_sum[7]_i_1_n_0 ;
  wire \wl_sum[8]_i_1_n_0 ;
  wire \wl_sum[9]_i_1_n_0 ;
  wire \wl_sum_reg[31]_i_2_n_3 ;
  wire \wl_sum_reg[31]_i_3_n_3 ;
  wire \wl_sum_reg[31]_i_4_n_0 ;
  wire \wl_sum_reg[31]_i_4_n_1 ;
  wire \wl_sum_reg[31]_i_4_n_2 ;
  wire \wl_sum_reg[31]_i_4_n_3 ;
  wire \wl_sum_reg[31]_i_7_n_0 ;
  wire \wl_sum_reg[31]_i_7_n_1 ;
  wire \wl_sum_reg[31]_i_7_n_2 ;
  wire \wl_sum_reg[31]_i_7_n_3 ;
  wire [1:0]wr_ptr;
  wire \wr_ptr[0]_i_1_n_0 ;
  wire \wr_ptr[1]_i_2_n_0 ;
  wire [8:0]\^zc_count ;
  wire \zc_count[0]_i_1_n_0 ;
  wire \zc_count[1]_i_1_n_0 ;
  wire \zc_count[2]_i_1_n_0 ;
  wire \zc_count[3]_i_1_n_0 ;
  wire \zc_count[4]_i_1_n_0 ;
  wire \zc_count[5]_i_1_n_0 ;
  wire \zc_count[6]_i_1_n_0 ;
  wire \zc_count[7]_i_1_n_0 ;
  wire \zc_count[8]_i_2_n_0 ;
  wire \zc_count[8]_i_3_n_0 ;
  wire zc_event;
  wire zc_event1;
  wire [3:1]\NLW_energy_sum_reg[31]_i_2_CO_UNCONNECTED ;
  wire [3:0]\NLW_energy_sum_reg[31]_i_2_O_UNCONNECTED ;
  wire [3:1]\NLW_energy_sum_reg[31]_i_3_CO_UNCONNECTED ;
  wire [3:0]\NLW_energy_sum_reg[31]_i_3_O_UNCONNECTED ;
  wire [3:0]\NLW_energy_sum_reg[31]_i_4_O_UNCONNECTED ;
  wire [3:0]\NLW_energy_sum_reg[31]_i_7_O_UNCONNECTED ;
  wire [3:1]\NLW_mav_sum_reg[31]_i_2_CO_UNCONNECTED ;
  wire [3:0]\NLW_mav_sum_reg[31]_i_2_O_UNCONNECTED ;
  wire [3:1]\NLW_mav_sum_reg[31]_i_3_CO_UNCONNECTED ;
  wire [3:0]\NLW_mav_sum_reg[31]_i_3_O_UNCONNECTED ;
  wire [3:0]\NLW_mav_sum_reg[31]_i_4_O_UNCONNECTED ;
  wire [3:0]\NLW_mav_sum_reg[31]_i_7_O_UNCONNECTED ;
  wire [3:3]\NLW_ring_energy_reg[3][31]_i_1_CO_UNCONNECTED ;
  wire [2:2]\NLW_ring_mav_reg[3][27]_i_3_CO_UNCONNECTED ;
  wire [3:3]\NLW_ring_mav_reg[3][27]_i_3_O_UNCONNECTED ;
  wire [3:3]\NLW_ring_mav_reg[3][31]_i_2_CO_UNCONNECTED ;
  wire [3:0]\NLW_ring_ssc_reg[3][4]_i_14_O_UNCONNECTED ;
  wire [3:3]\NLW_ring_ssc_reg[3][4]_i_23_CO_UNCONNECTED ;
  wire [3:0]\NLW_ring_ssc_reg[3][4]_i_3_O_UNCONNECTED ;
  wire [3:1]\NLW_ring_ssc_reg[3][4]_i_4_CO_UNCONNECTED ;
  wire [3:0]\NLW_ring_ssc_reg[3][4]_i_4_O_UNCONNECTED ;
  wire [3:0]\NLW_ring_ssc_reg[3][4]_i_5_O_UNCONNECTED ;
  wire [3:3]\NLW_ring_wl_reg[3][27]_i_3_CO_UNCONNECTED ;
  wire [3:1]\NLW_ring_wl_reg[3][27]_i_4_CO_UNCONNECTED ;
  wire [3:0]\NLW_ring_wl_reg[3][27]_i_4_O_UNCONNECTED ;
  wire [3:3]\NLW_ring_wl_reg[3][31]_i_1_CO_UNCONNECTED ;
  wire [3:0]\NLW_ring_zc_reg[3][1]_i_11_O_UNCONNECTED ;
  wire [3:0]\NLW_ring_zc_reg[3][1]_i_2_O_UNCONNECTED ;
  wire [3:0]\NLW_ring_zc_reg[3][1]_i_3_O_UNCONNECTED ;
  wire NLW_seg_energy1_CARRYCASCOUT_UNCONNECTED;
  wire NLW_seg_energy1_MULTSIGNOUT_UNCONNECTED;
  wire NLW_seg_energy1_OVERFLOW_UNCONNECTED;
  wire NLW_seg_energy1_PATTERNBDETECT_UNCONNECTED;
  wire NLW_seg_energy1_PATTERNDETECT_UNCONNECTED;
  wire NLW_seg_energy1_UNDERFLOW_UNCONNECTED;
  wire [29:0]NLW_seg_energy1_ACOUT_UNCONNECTED;
  wire [17:0]NLW_seg_energy1_BCOUT_UNCONNECTED;
  wire [3:0]NLW_seg_energy1_CARRYOUT_UNCONNECTED;
  wire NLW_seg_energy1__0_CARRYCASCOUT_UNCONNECTED;
  wire NLW_seg_energy1__0_MULTSIGNOUT_UNCONNECTED;
  wire NLW_seg_energy1__0_OVERFLOW_UNCONNECTED;
  wire NLW_seg_energy1__0_PATTERNBDETECT_UNCONNECTED;
  wire NLW_seg_energy1__0_PATTERNDETECT_UNCONNECTED;
  wire NLW_seg_energy1__0_UNDERFLOW_UNCONNECTED;
  wire [29:0]NLW_seg_energy1__0_ACOUT_UNCONNECTED;
  wire [17:0]NLW_seg_energy1__0_BCOUT_UNCONNECTED;
  wire [3:0]NLW_seg_energy1__0_CARRYOUT_UNCONNECTED;
  wire [47:15]NLW_seg_energy1__0_P_UNCONNECTED;
  wire [47:0]NLW_seg_energy1__0_PCOUT_UNCONNECTED;
  wire [3:3]\NLW_seg_energy_reg[28]_i_1_CO_UNCONNECTED ;
  wire [3:3]\NLW_seg_mav_reg[28]_i_1_CO_UNCONNECTED ;
  wire [3:3]\NLW_seg_wl_reg[28]_i_1_CO_UNCONNECTED ;
  wire [3:3]\NLW_win_energy_reg[39]_i_1_CO_UNCONNECTED ;
  wire [3:3]\NLW_win_mav_reg[39]_i_1_CO_UNCONNECTED ;
  wire [3:0]\NLW_win_ssc_reg[8]_i_1_CO_UNCONNECTED ;
  wire [3:1]\NLW_win_ssc_reg[8]_i_1_O_UNCONNECTED ;
  wire [3:3]\NLW_win_wl_reg[39]_i_1_CO_UNCONNECTED ;
  wire [3:0]\NLW_win_zc_reg[8]_i_1_CO_UNCONNECTED ;
  wire [3:1]\NLW_win_zc_reg[8]_i_1_O_UNCONNECTED ;
  wire [3:1]\NLW_wl_sum_reg[31]_i_2_CO_UNCONNECTED ;
  wire [3:0]\NLW_wl_sum_reg[31]_i_2_O_UNCONNECTED ;
  wire [3:1]\NLW_wl_sum_reg[31]_i_3_CO_UNCONNECTED ;
  wire [3:0]\NLW_wl_sum_reg[31]_i_3_O_UNCONNECTED ;
  wire [3:0]\NLW_wl_sum_reg[31]_i_4_O_UNCONNECTED ;
  wire [3:0]\NLW_wl_sum_reg[31]_i_7_O_UNCONNECTED ;

  assign ssc_count[31] = \<const0> ;
  assign ssc_count[30] = \<const0> ;
  assign ssc_count[29] = \<const0> ;
  assign ssc_count[28] = \<const0> ;
  assign ssc_count[27] = \<const0> ;
  assign ssc_count[26] = \<const0> ;
  assign ssc_count[25] = \<const0> ;
  assign ssc_count[24] = \<const0> ;
  assign ssc_count[23] = \<const0> ;
  assign ssc_count[22] = \<const0> ;
  assign ssc_count[21] = \<const0> ;
  assign ssc_count[20] = \<const0> ;
  assign ssc_count[19] = \<const0> ;
  assign ssc_count[18] = \<const0> ;
  assign ssc_count[17] = \<const0> ;
  assign ssc_count[16] = \<const0> ;
  assign ssc_count[15] = \<const0> ;
  assign ssc_count[14] = \<const0> ;
  assign ssc_count[13] = \<const0> ;
  assign ssc_count[12] = \<const0> ;
  assign ssc_count[11] = \<const0> ;
  assign ssc_count[10] = \<const0> ;
  assign ssc_count[9] = \<const0> ;
  assign ssc_count[8:0] = \^ssc_count [8:0];
  assign zc_count[31] = \<const0> ;
  assign zc_count[30] = \<const0> ;
  assign zc_count[29] = \<const0> ;
  assign zc_count[28] = \<const0> ;
  assign zc_count[27] = \<const0> ;
  assign zc_count[26] = \<const0> ;
  assign zc_count[25] = \<const0> ;
  assign zc_count[24] = \<const0> ;
  assign zc_count[23] = \<const0> ;
  assign zc_count[22] = \<const0> ;
  assign zc_count[21] = \<const0> ;
  assign zc_count[20] = \<const0> ;
  assign zc_count[19] = \<const0> ;
  assign zc_count[18] = \<const0> ;
  assign zc_count[17] = \<const0> ;
  assign zc_count[16] = \<const0> ;
  assign zc_count[15] = \<const0> ;
  assign zc_count[14] = \<const0> ;
  assign zc_count[13] = \<const0> ;
  assign zc_count[12] = \<const0> ;
  assign zc_count[11] = \<const0> ;
  assign zc_count[10] = \<const0> ;
  assign zc_count[9] = \<const0> ;
  assign zc_count[8:0] = \^zc_count [8:0];
  GND GND
       (.G(\<const0> ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \energy_sum[0]_i_1 
       (.I0(rst_n),
        .I1(\energy_sum_reg[31]_i_2_n_3 ),
        .I2(\energy_sum_reg[31]_i_3_n_3 ),
        .I3(next_energy[0]),
        .I4(window_valid13_in),
        .I5(\win_energy_reg[3]_i_1_n_7 ),
        .O(\energy_sum[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \energy_sum[10]_i_1 
       (.I0(rst_n),
        .I1(\energy_sum_reg[31]_i_2_n_3 ),
        .I2(\energy_sum_reg[31]_i_3_n_3 ),
        .I3(next_energy[10]),
        .I4(window_valid13_in),
        .I5(\win_energy_reg[11]_i_1_n_5 ),
        .O(\energy_sum[10]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \energy_sum[11]_i_1 
       (.I0(rst_n),
        .I1(\energy_sum_reg[31]_i_2_n_3 ),
        .I2(\energy_sum_reg[31]_i_3_n_3 ),
        .I3(next_energy[11]),
        .I4(window_valid13_in),
        .I5(\win_energy_reg[11]_i_1_n_4 ),
        .O(\energy_sum[11]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \energy_sum[12]_i_1 
       (.I0(rst_n),
        .I1(\energy_sum_reg[31]_i_2_n_3 ),
        .I2(\energy_sum_reg[31]_i_3_n_3 ),
        .I3(next_energy[12]),
        .I4(window_valid13_in),
        .I5(\win_energy_reg[15]_i_1_n_7 ),
        .O(\energy_sum[12]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \energy_sum[13]_i_1 
       (.I0(rst_n),
        .I1(\energy_sum_reg[31]_i_2_n_3 ),
        .I2(\energy_sum_reg[31]_i_3_n_3 ),
        .I3(next_energy[13]),
        .I4(window_valid13_in),
        .I5(\win_energy_reg[15]_i_1_n_6 ),
        .O(\energy_sum[13]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \energy_sum[14]_i_1 
       (.I0(rst_n),
        .I1(\energy_sum_reg[31]_i_2_n_3 ),
        .I2(\energy_sum_reg[31]_i_3_n_3 ),
        .I3(next_energy[14]),
        .I4(window_valid13_in),
        .I5(\win_energy_reg[15]_i_1_n_5 ),
        .O(\energy_sum[14]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \energy_sum[15]_i_1 
       (.I0(rst_n),
        .I1(\energy_sum_reg[31]_i_2_n_3 ),
        .I2(\energy_sum_reg[31]_i_3_n_3 ),
        .I3(next_energy[15]),
        .I4(window_valid13_in),
        .I5(\win_energy_reg[15]_i_1_n_4 ),
        .O(\energy_sum[15]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \energy_sum[16]_i_1 
       (.I0(rst_n),
        .I1(\energy_sum_reg[31]_i_2_n_3 ),
        .I2(\energy_sum_reg[31]_i_3_n_3 ),
        .I3(next_energy[16]),
        .I4(window_valid13_in),
        .I5(\win_energy_reg[19]_i_1_n_7 ),
        .O(\energy_sum[16]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \energy_sum[17]_i_1 
       (.I0(rst_n),
        .I1(\energy_sum_reg[31]_i_2_n_3 ),
        .I2(\energy_sum_reg[31]_i_3_n_3 ),
        .I3(next_energy[17]),
        .I4(window_valid13_in),
        .I5(\win_energy_reg[19]_i_1_n_6 ),
        .O(\energy_sum[17]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \energy_sum[18]_i_1 
       (.I0(rst_n),
        .I1(\energy_sum_reg[31]_i_2_n_3 ),
        .I2(\energy_sum_reg[31]_i_3_n_3 ),
        .I3(next_energy[18]),
        .I4(window_valid13_in),
        .I5(\win_energy_reg[19]_i_1_n_5 ),
        .O(\energy_sum[18]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \energy_sum[19]_i_1 
       (.I0(rst_n),
        .I1(\energy_sum_reg[31]_i_2_n_3 ),
        .I2(\energy_sum_reg[31]_i_3_n_3 ),
        .I3(next_energy[19]),
        .I4(window_valid13_in),
        .I5(\win_energy_reg[19]_i_1_n_4 ),
        .O(\energy_sum[19]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \energy_sum[1]_i_1 
       (.I0(rst_n),
        .I1(\energy_sum_reg[31]_i_2_n_3 ),
        .I2(\energy_sum_reg[31]_i_3_n_3 ),
        .I3(next_energy[1]),
        .I4(window_valid13_in),
        .I5(\win_energy_reg[3]_i_1_n_6 ),
        .O(\energy_sum[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \energy_sum[20]_i_1 
       (.I0(rst_n),
        .I1(\energy_sum_reg[31]_i_2_n_3 ),
        .I2(\energy_sum_reg[31]_i_3_n_3 ),
        .I3(next_energy[20]),
        .I4(window_valid13_in),
        .I5(\win_energy_reg[23]_i_1_n_7 ),
        .O(\energy_sum[20]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \energy_sum[21]_i_1 
       (.I0(rst_n),
        .I1(\energy_sum_reg[31]_i_2_n_3 ),
        .I2(\energy_sum_reg[31]_i_3_n_3 ),
        .I3(next_energy[21]),
        .I4(window_valid13_in),
        .I5(\win_energy_reg[23]_i_1_n_6 ),
        .O(\energy_sum[21]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \energy_sum[22]_i_1 
       (.I0(rst_n),
        .I1(\energy_sum_reg[31]_i_2_n_3 ),
        .I2(\energy_sum_reg[31]_i_3_n_3 ),
        .I3(next_energy[22]),
        .I4(window_valid13_in),
        .I5(\win_energy_reg[23]_i_1_n_5 ),
        .O(\energy_sum[22]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \energy_sum[23]_i_1 
       (.I0(rst_n),
        .I1(\energy_sum_reg[31]_i_2_n_3 ),
        .I2(\energy_sum_reg[31]_i_3_n_3 ),
        .I3(next_energy[23]),
        .I4(window_valid13_in),
        .I5(\win_energy_reg[23]_i_1_n_4 ),
        .O(\energy_sum[23]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \energy_sum[24]_i_1 
       (.I0(rst_n),
        .I1(\energy_sum_reg[31]_i_2_n_3 ),
        .I2(\energy_sum_reg[31]_i_3_n_3 ),
        .I3(next_energy[24]),
        .I4(window_valid13_in),
        .I5(\win_energy_reg[27]_i_1_n_7 ),
        .O(\energy_sum[24]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \energy_sum[25]_i_1 
       (.I0(rst_n),
        .I1(\energy_sum_reg[31]_i_2_n_3 ),
        .I2(\energy_sum_reg[31]_i_3_n_3 ),
        .I3(next_energy[25]),
        .I4(window_valid13_in),
        .I5(\win_energy_reg[27]_i_1_n_6 ),
        .O(\energy_sum[25]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \energy_sum[26]_i_1 
       (.I0(rst_n),
        .I1(\energy_sum_reg[31]_i_2_n_3 ),
        .I2(\energy_sum_reg[31]_i_3_n_3 ),
        .I3(next_energy[26]),
        .I4(window_valid13_in),
        .I5(\win_energy_reg[27]_i_1_n_5 ),
        .O(\energy_sum[26]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \energy_sum[27]_i_1 
       (.I0(rst_n),
        .I1(\energy_sum_reg[31]_i_2_n_3 ),
        .I2(\energy_sum_reg[31]_i_3_n_3 ),
        .I3(next_energy[27]),
        .I4(window_valid13_in),
        .I5(\win_energy_reg[27]_i_1_n_4 ),
        .O(\energy_sum[27]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \energy_sum[28]_i_1 
       (.I0(rst_n),
        .I1(\energy_sum_reg[31]_i_2_n_3 ),
        .I2(\energy_sum_reg[31]_i_3_n_3 ),
        .I3(next_energy[28]),
        .I4(window_valid13_in),
        .I5(\win_energy_reg[31]_i_1_n_7 ),
        .O(\energy_sum[28]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \energy_sum[29]_i_1 
       (.I0(rst_n),
        .I1(\energy_sum_reg[31]_i_2_n_3 ),
        .I2(\energy_sum_reg[31]_i_3_n_3 ),
        .I3(next_energy[29]),
        .I4(window_valid13_in),
        .I5(\win_energy_reg[31]_i_1_n_6 ),
        .O(\energy_sum[29]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \energy_sum[2]_i_1 
       (.I0(rst_n),
        .I1(\energy_sum_reg[31]_i_2_n_3 ),
        .I2(\energy_sum_reg[31]_i_3_n_3 ),
        .I3(next_energy[2]),
        .I4(window_valid13_in),
        .I5(\win_energy_reg[3]_i_1_n_5 ),
        .O(\energy_sum[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \energy_sum[30]_i_1 
       (.I0(rst_n),
        .I1(\energy_sum_reg[31]_i_2_n_3 ),
        .I2(\energy_sum_reg[31]_i_3_n_3 ),
        .I3(next_energy[30]),
        .I4(window_valid13_in),
        .I5(\win_energy_reg[31]_i_1_n_5 ),
        .O(\energy_sum[30]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h4440FFFF44400000)) 
    \energy_sum[31]_i_1 
       (.I0(\energy_sum_reg[31]_i_2_n_3 ),
        .I1(rst_n),
        .I2(\next_energy[31]_i_1_n_0 ),
        .I3(\energy_sum_reg[31]_i_3_n_3 ),
        .I4(\mav_sum[30]_i_1_n_0 ),
        .I5(energy_sum[31]),
        .O(\energy_sum[31]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    \energy_sum[31]_i_10 
       (.I0(\win_energy_reg[39]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_energy[36]),
        .I3(\win_energy_reg[39]_i_1_n_6 ),
        .I4(next_energy[37]),
        .O(\energy_sum[31]_i_10_n_0 ));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    \energy_sum[31]_i_11 
       (.I0(\win_energy_reg[35]_i_1_n_5 ),
        .I1(window_valid13_in),
        .I2(next_energy[34]),
        .I3(\win_energy_reg[35]_i_1_n_4 ),
        .I4(next_energy[35]),
        .O(\energy_sum[31]_i_11_n_0 ));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    \energy_sum[31]_i_12 
       (.I0(\win_energy_reg[35]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_energy[32]),
        .I3(\win_energy_reg[35]_i_1_n_6 ),
        .I4(next_energy[33]),
        .O(\energy_sum[31]_i_12_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \energy_sum[31]_i_13 
       (.I0(\win_energy_reg[31]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_energy[31]),
        .O(\energy_sum[31]_i_13_n_0 ));
  LUT5 #(
    .INIT(32'h00053305)) 
    \energy_sum[31]_i_14 
       (.I0(next_energy[37]),
        .I1(\win_energy_reg[39]_i_1_n_6 ),
        .I2(next_energy[36]),
        .I3(window_valid13_in),
        .I4(\win_energy_reg[39]_i_1_n_7 ),
        .O(\energy_sum[31]_i_14_n_0 ));
  LUT5 #(
    .INIT(32'h00053305)) 
    \energy_sum[31]_i_15 
       (.I0(next_energy[35]),
        .I1(\win_energy_reg[35]_i_1_n_4 ),
        .I2(next_energy[34]),
        .I3(window_valid13_in),
        .I4(\win_energy_reg[35]_i_1_n_5 ),
        .O(\energy_sum[31]_i_15_n_0 ));
  LUT5 #(
    .INIT(32'h00053305)) 
    \energy_sum[31]_i_16 
       (.I0(next_energy[33]),
        .I1(\win_energy_reg[35]_i_1_n_6 ),
        .I2(next_energy[32]),
        .I3(window_valid13_in),
        .I4(\win_energy_reg[35]_i_1_n_7 ),
        .O(\energy_sum[31]_i_16_n_0 ));
  LUT5 #(
    .INIT(32'h000ACC0A)) 
    \energy_sum[31]_i_17 
       (.I0(next_energy[30]),
        .I1(\win_energy_reg[31]_i_1_n_5 ),
        .I2(next_energy[31]),
        .I3(window_valid13_in),
        .I4(\win_energy_reg[31]_i_1_n_4 ),
        .O(\energy_sum[31]_i_17_n_0 ));
  LUT5 #(
    .INIT(32'h47CF77FF)) 
    \energy_sum[31]_i_18 
       (.I0(\win_energy_reg[39]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_energy[37]),
        .I3(\win_energy_reg[39]_i_1_n_7 ),
        .I4(next_energy[36]),
        .O(\energy_sum[31]_i_18_n_0 ));
  LUT5 #(
    .INIT(32'h47CF77FF)) 
    \energy_sum[31]_i_19 
       (.I0(\win_energy_reg[35]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_energy[35]),
        .I3(\win_energy_reg[35]_i_1_n_5 ),
        .I4(next_energy[34]),
        .O(\energy_sum[31]_i_19_n_0 ));
  LUT5 #(
    .INIT(32'h47CF77FF)) 
    \energy_sum[31]_i_20 
       (.I0(\win_energy_reg[35]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_energy[33]),
        .I3(\win_energy_reg[35]_i_1_n_7 ),
        .I4(next_energy[32]),
        .O(\energy_sum[31]_i_20_n_0 ));
  LUT3 #(
    .INIT(8'h1D)) 
    \energy_sum[31]_i_21 
       (.I0(next_energy[31]),
        .I1(window_valid13_in),
        .I2(\win_energy_reg[31]_i_1_n_4 ),
        .O(\energy_sum[31]_i_21_n_0 ));
  LUT5 #(
    .INIT(32'hCCA000A0)) 
    \energy_sum[31]_i_22 
       (.I0(next_energy[36]),
        .I1(\win_energy_reg[39]_i_1_n_7 ),
        .I2(next_energy[37]),
        .I3(window_valid13_in),
        .I4(\win_energy_reg[39]_i_1_n_6 ),
        .O(\energy_sum[31]_i_22_n_0 ));
  LUT5 #(
    .INIT(32'hCCA000A0)) 
    \energy_sum[31]_i_23 
       (.I0(next_energy[34]),
        .I1(\win_energy_reg[35]_i_1_n_5 ),
        .I2(next_energy[35]),
        .I3(window_valid13_in),
        .I4(\win_energy_reg[35]_i_1_n_4 ),
        .O(\energy_sum[31]_i_23_n_0 ));
  LUT5 #(
    .INIT(32'hCCA000A0)) 
    \energy_sum[31]_i_24 
       (.I0(next_energy[32]),
        .I1(\win_energy_reg[35]_i_1_n_7 ),
        .I2(next_energy[33]),
        .I3(window_valid13_in),
        .I4(\win_energy_reg[35]_i_1_n_6 ),
        .O(\energy_sum[31]_i_24_n_0 ));
  LUT5 #(
    .INIT(32'h000ACC0A)) 
    \energy_sum[31]_i_25 
       (.I0(next_energy[31]),
        .I1(\win_energy_reg[31]_i_1_n_4 ),
        .I2(next_energy[30]),
        .I3(window_valid13_in),
        .I4(\win_energy_reg[31]_i_1_n_5 ),
        .O(\energy_sum[31]_i_25_n_0 ));
  LUT5 #(
    .INIT(32'h000ACC0A)) 
    \energy_sum[31]_i_5 
       (.I0(next_energy[38]),
        .I1(\win_energy_reg[39]_i_1_n_5 ),
        .I2(next_energy[39]),
        .I3(window_valid13_in),
        .I4(\win_energy_reg[39]_i_1_n_4 ),
        .O(\energy_sum[31]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'h00053305)) 
    \energy_sum[31]_i_6 
       (.I0(next_energy[38]),
        .I1(\win_energy_reg[39]_i_1_n_5 ),
        .I2(next_energy[39]),
        .I3(window_valid13_in),
        .I4(\win_energy_reg[39]_i_1_n_4 ),
        .O(\energy_sum[31]_i_6_n_0 ));
  LUT5 #(
    .INIT(32'h000ACC0A)) 
    \energy_sum[31]_i_8 
       (.I0(next_energy[39]),
        .I1(\win_energy_reg[39]_i_1_n_4 ),
        .I2(next_energy[38]),
        .I3(window_valid13_in),
        .I4(\win_energy_reg[39]_i_1_n_5 ),
        .O(\energy_sum[31]_i_8_n_0 ));
  LUT5 #(
    .INIT(32'hCCA000A0)) 
    \energy_sum[31]_i_9 
       (.I0(next_energy[38]),
        .I1(\win_energy_reg[39]_i_1_n_5 ),
        .I2(next_energy[39]),
        .I3(window_valid13_in),
        .I4(\win_energy_reg[39]_i_1_n_4 ),
        .O(\energy_sum[31]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \energy_sum[3]_i_1 
       (.I0(rst_n),
        .I1(\energy_sum_reg[31]_i_2_n_3 ),
        .I2(\energy_sum_reg[31]_i_3_n_3 ),
        .I3(next_energy[3]),
        .I4(window_valid13_in),
        .I5(\win_energy_reg[3]_i_1_n_4 ),
        .O(\energy_sum[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \energy_sum[4]_i_1 
       (.I0(rst_n),
        .I1(\energy_sum_reg[31]_i_2_n_3 ),
        .I2(\energy_sum_reg[31]_i_3_n_3 ),
        .I3(next_energy[4]),
        .I4(window_valid13_in),
        .I5(\win_energy_reg[7]_i_1_n_7 ),
        .O(\energy_sum[4]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \energy_sum[5]_i_1 
       (.I0(rst_n),
        .I1(\energy_sum_reg[31]_i_2_n_3 ),
        .I2(\energy_sum_reg[31]_i_3_n_3 ),
        .I3(next_energy[5]),
        .I4(window_valid13_in),
        .I5(\win_energy_reg[7]_i_1_n_6 ),
        .O(\energy_sum[5]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \energy_sum[6]_i_1 
       (.I0(rst_n),
        .I1(\energy_sum_reg[31]_i_2_n_3 ),
        .I2(\energy_sum_reg[31]_i_3_n_3 ),
        .I3(next_energy[6]),
        .I4(window_valid13_in),
        .I5(\win_energy_reg[7]_i_1_n_5 ),
        .O(\energy_sum[6]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \energy_sum[7]_i_1 
       (.I0(rst_n),
        .I1(\energy_sum_reg[31]_i_2_n_3 ),
        .I2(\energy_sum_reg[31]_i_3_n_3 ),
        .I3(next_energy[7]),
        .I4(window_valid13_in),
        .I5(\win_energy_reg[7]_i_1_n_4 ),
        .O(\energy_sum[7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \energy_sum[8]_i_1 
       (.I0(rst_n),
        .I1(\energy_sum_reg[31]_i_2_n_3 ),
        .I2(\energy_sum_reg[31]_i_3_n_3 ),
        .I3(next_energy[8]),
        .I4(window_valid13_in),
        .I5(\win_energy_reg[11]_i_1_n_7 ),
        .O(\energy_sum[8]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \energy_sum[9]_i_1 
       (.I0(rst_n),
        .I1(\energy_sum_reg[31]_i_2_n_3 ),
        .I2(\energy_sum_reg[31]_i_3_n_3 ),
        .I3(next_energy[9]),
        .I4(window_valid13_in),
        .I5(\win_energy_reg[11]_i_1_n_6 ),
        .O(\energy_sum[9]_i_1_n_0 ));
  FDSE \energy_sum_reg[0] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\energy_sum[0]_i_1_n_0 ),
        .Q(energy_sum[0]),
        .S(1'b0));
  FDSE \energy_sum_reg[10] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\energy_sum[10]_i_1_n_0 ),
        .Q(energy_sum[10]),
        .S(1'b0));
  FDSE \energy_sum_reg[11] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\energy_sum[11]_i_1_n_0 ),
        .Q(energy_sum[11]),
        .S(1'b0));
  FDSE \energy_sum_reg[12] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\energy_sum[12]_i_1_n_0 ),
        .Q(energy_sum[12]),
        .S(1'b0));
  FDSE \energy_sum_reg[13] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\energy_sum[13]_i_1_n_0 ),
        .Q(energy_sum[13]),
        .S(1'b0));
  FDSE \energy_sum_reg[14] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\energy_sum[14]_i_1_n_0 ),
        .Q(energy_sum[14]),
        .S(1'b0));
  FDSE \energy_sum_reg[15] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\energy_sum[15]_i_1_n_0 ),
        .Q(energy_sum[15]),
        .S(1'b0));
  FDSE \energy_sum_reg[16] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\energy_sum[16]_i_1_n_0 ),
        .Q(energy_sum[16]),
        .S(1'b0));
  FDSE \energy_sum_reg[17] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\energy_sum[17]_i_1_n_0 ),
        .Q(energy_sum[17]),
        .S(1'b0));
  FDSE \energy_sum_reg[18] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\energy_sum[18]_i_1_n_0 ),
        .Q(energy_sum[18]),
        .S(1'b0));
  FDSE \energy_sum_reg[19] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\energy_sum[19]_i_1_n_0 ),
        .Q(energy_sum[19]),
        .S(1'b0));
  FDSE \energy_sum_reg[1] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\energy_sum[1]_i_1_n_0 ),
        .Q(energy_sum[1]),
        .S(1'b0));
  FDSE \energy_sum_reg[20] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\energy_sum[20]_i_1_n_0 ),
        .Q(energy_sum[20]),
        .S(1'b0));
  FDSE \energy_sum_reg[21] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\energy_sum[21]_i_1_n_0 ),
        .Q(energy_sum[21]),
        .S(1'b0));
  FDSE \energy_sum_reg[22] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\energy_sum[22]_i_1_n_0 ),
        .Q(energy_sum[22]),
        .S(1'b0));
  FDSE \energy_sum_reg[23] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\energy_sum[23]_i_1_n_0 ),
        .Q(energy_sum[23]),
        .S(1'b0));
  FDSE \energy_sum_reg[24] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\energy_sum[24]_i_1_n_0 ),
        .Q(energy_sum[24]),
        .S(1'b0));
  FDSE \energy_sum_reg[25] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\energy_sum[25]_i_1_n_0 ),
        .Q(energy_sum[25]),
        .S(1'b0));
  FDSE \energy_sum_reg[26] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\energy_sum[26]_i_1_n_0 ),
        .Q(energy_sum[26]),
        .S(1'b0));
  FDSE \energy_sum_reg[27] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\energy_sum[27]_i_1_n_0 ),
        .Q(energy_sum[27]),
        .S(1'b0));
  FDSE \energy_sum_reg[28] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\energy_sum[28]_i_1_n_0 ),
        .Q(energy_sum[28]),
        .S(1'b0));
  FDSE \energy_sum_reg[29] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\energy_sum[29]_i_1_n_0 ),
        .Q(energy_sum[29]),
        .S(1'b0));
  FDSE \energy_sum_reg[2] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\energy_sum[2]_i_1_n_0 ),
        .Q(energy_sum[2]),
        .S(1'b0));
  FDSE \energy_sum_reg[30] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\energy_sum[30]_i_1_n_0 ),
        .Q(energy_sum[30]),
        .S(1'b0));
  FDRE \energy_sum_reg[31] 
       (.C(clk),
        .CE(1'b1),
        .D(\energy_sum[31]_i_1_n_0 ),
        .Q(energy_sum[31]),
        .R(1'b0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \energy_sum_reg[31]_i_2 
       (.CI(\energy_sum_reg[31]_i_4_n_0 ),
        .CO({\NLW_energy_sum_reg[31]_i_2_CO_UNCONNECTED [3:1],\energy_sum_reg[31]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,\energy_sum[31]_i_5_n_0 }),
        .O(\NLW_energy_sum_reg[31]_i_2_O_UNCONNECTED [3:0]),
        .S({1'b0,1'b0,1'b0,\energy_sum[31]_i_6_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \energy_sum_reg[31]_i_3 
       (.CI(\energy_sum_reg[31]_i_7_n_0 ),
        .CO({\NLW_energy_sum_reg[31]_i_3_CO_UNCONNECTED [3:1],\energy_sum_reg[31]_i_3_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,\energy_sum[31]_i_8_n_0 }),
        .O(\NLW_energy_sum_reg[31]_i_3_O_UNCONNECTED [3:0]),
        .S({1'b0,1'b0,1'b0,\energy_sum[31]_i_9_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \energy_sum_reg[31]_i_4 
       (.CI(1'b0),
        .CO({\energy_sum_reg[31]_i_4_n_0 ,\energy_sum_reg[31]_i_4_n_1 ,\energy_sum_reg[31]_i_4_n_2 ,\energy_sum_reg[31]_i_4_n_3 }),
        .CYINIT(1'b0),
        .DI({\energy_sum[31]_i_10_n_0 ,\energy_sum[31]_i_11_n_0 ,\energy_sum[31]_i_12_n_0 ,\energy_sum[31]_i_13_n_0 }),
        .O(\NLW_energy_sum_reg[31]_i_4_O_UNCONNECTED [3:0]),
        .S({\energy_sum[31]_i_14_n_0 ,\energy_sum[31]_i_15_n_0 ,\energy_sum[31]_i_16_n_0 ,\energy_sum[31]_i_17_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \energy_sum_reg[31]_i_7 
       (.CI(1'b0),
        .CO({\energy_sum_reg[31]_i_7_n_0 ,\energy_sum_reg[31]_i_7_n_1 ,\energy_sum_reg[31]_i_7_n_2 ,\energy_sum_reg[31]_i_7_n_3 }),
        .CYINIT(1'b0),
        .DI({\energy_sum[31]_i_18_n_0 ,\energy_sum[31]_i_19_n_0 ,\energy_sum[31]_i_20_n_0 ,\energy_sum[31]_i_21_n_0 }),
        .O(\NLW_energy_sum_reg[31]_i_7_O_UNCONNECTED [3:0]),
        .S({\energy_sum[31]_i_22_n_0 ,\energy_sum[31]_i_23_n_0 ,\energy_sum[31]_i_24_n_0 ,\energy_sum[31]_i_25_n_0 }));
  FDSE \energy_sum_reg[3] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\energy_sum[3]_i_1_n_0 ),
        .Q(energy_sum[3]),
        .S(1'b0));
  FDSE \energy_sum_reg[4] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\energy_sum[4]_i_1_n_0 ),
        .Q(energy_sum[4]),
        .S(1'b0));
  FDSE \energy_sum_reg[5] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\energy_sum[5]_i_1_n_0 ),
        .Q(energy_sum[5]),
        .S(1'b0));
  FDSE \energy_sum_reg[6] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\energy_sum[6]_i_1_n_0 ),
        .Q(energy_sum[6]),
        .S(1'b0));
  FDSE \energy_sum_reg[7] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\energy_sum[7]_i_1_n_0 ),
        .Q(energy_sum[7]),
        .S(1'b0));
  FDSE \energy_sum_reg[8] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\energy_sum[8]_i_1_n_0 ),
        .Q(energy_sum[8]),
        .S(1'b0));
  FDSE \energy_sum_reg[9] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\energy_sum[9]_i_1_n_0 ),
        .Q(energy_sum[9]),
        .S(1'b0));
  FDRE have_prev2_reg
       (.C(clk),
        .CE(sample_valid),
        .D(have_prev),
        .Q(have_prev2),
        .R(clear));
  FDRE have_prev_reg
       (.C(clk),
        .CE(sample_valid),
        .D(1'b1),
        .Q(have_prev),
        .R(clear));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'h0000FFDF)) 
    \hop_count[0]_i_1 
       (.I0(\hop_count_reg_n_0_[5] ),
        .I1(\hop_count_reg_n_0_[4] ),
        .I2(\hop_count_reg_n_0_[6] ),
        .I3(\hop_count[6]_i_5_n_0 ),
        .I4(\hop_count_reg_n_0_[0] ),
        .O(hop_count[0]));
  LUT6 #(
    .INIT(64'h0000FFDFFFDF0000)) 
    \hop_count[1]_i_1 
       (.I0(\hop_count_reg_n_0_[5] ),
        .I1(\hop_count_reg_n_0_[4] ),
        .I2(\hop_count_reg_n_0_[6] ),
        .I3(\hop_count[6]_i_5_n_0 ),
        .I4(\hop_count_reg_n_0_[1] ),
        .I5(\hop_count_reg_n_0_[0] ),
        .O(hop_count[1]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT5 #(
    .INIT(32'h0EE0E0E0)) 
    \hop_count[2]_i_1 
       (.I0(\hop_count[4]_i_2_n_0 ),
        .I1(\hop_count[6]_i_5_n_0 ),
        .I2(\hop_count_reg_n_0_[2] ),
        .I3(\hop_count_reg_n_0_[0] ),
        .I4(\hop_count_reg_n_0_[1] ),
        .O(hop_count[2]));
  LUT6 #(
    .INIT(64'h0EE0E0E0E0E0E0E0)) 
    \hop_count[3]_i_1 
       (.I0(\hop_count[4]_i_2_n_0 ),
        .I1(\hop_count[6]_i_5_n_0 ),
        .I2(\hop_count_reg_n_0_[3] ),
        .I3(\hop_count_reg_n_0_[2] ),
        .I4(\hop_count_reg_n_0_[1] ),
        .I5(\hop_count_reg_n_0_[0] ),
        .O(hop_count[3]));
  LUT6 #(
    .INIT(64'h0EE0E0E0E0E0E0E0)) 
    \hop_count[4]_i_1 
       (.I0(\hop_count[4]_i_2_n_0 ),
        .I1(\hop_count[6]_i_5_n_0 ),
        .I2(\hop_count_reg_n_0_[4] ),
        .I3(\hop_count_reg_n_0_[3] ),
        .I4(\hop_count[4]_i_3_n_0 ),
        .I5(\hop_count_reg_n_0_[2] ),
        .O(hop_count[4]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'hDF)) 
    \hop_count[4]_i_2 
       (.I0(\hop_count_reg_n_0_[5] ),
        .I1(\hop_count_reg_n_0_[4] ),
        .I2(\hop_count_reg_n_0_[6] ),
        .O(\hop_count[4]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair42" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \hop_count[4]_i_3 
       (.I0(\hop_count_reg_n_0_[0] ),
        .I1(\hop_count_reg_n_0_[1] ),
        .O(\hop_count[4]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'hFFDF0000)) 
    \hop_count[5]_i_1 
       (.I0(\hop_count_reg_n_0_[5] ),
        .I1(\hop_count_reg_n_0_[4] ),
        .I2(\hop_count_reg_n_0_[6] ),
        .I3(\hop_count[6]_i_5_n_0 ),
        .I4(data0),
        .O(hop_count[5]));
  LUT6 #(
    .INIT(64'h7FFFFFFF80000000)) 
    \hop_count[5]_i_2 
       (.I0(\hop_count_reg_n_0_[3] ),
        .I1(\hop_count_reg_n_0_[0] ),
        .I2(\hop_count_reg_n_0_[1] ),
        .I3(\hop_count_reg_n_0_[2] ),
        .I4(\hop_count_reg_n_0_[4] ),
        .I5(\hop_count_reg_n_0_[5] ),
        .O(data0));
  LUT4 #(
    .INIT(16'h40FF)) 
    \hop_count[6]_i_1 
       (.I0(prime_count),
        .I1(priming_reg_n_0),
        .I2(sample_valid),
        .I3(rst_n),
        .O(\hop_count[6]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \hop_count[6]_i_2 
       (.I0(sample_valid),
        .I1(priming_reg_n_0),
        .O(\hop_count[6]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h5A5AF0D0)) 
    \hop_count[6]_i_3 
       (.I0(\hop_count_reg_n_0_[5] ),
        .I1(\hop_count_reg_n_0_[4] ),
        .I2(\hop_count_reg_n_0_[6] ),
        .I3(\hop_count[6]_i_5_n_0 ),
        .I4(\hop_count[6]_i_6_n_0 ),
        .O(hop_count[6]));
  LUT5 #(
    .INIT(32'hFEFFFFFF)) 
    \hop_count[6]_i_4 
       (.I0(\hop_count[6]_i_7_n_0 ),
        .I1(prime_count_reg[6]),
        .I2(prime_count_reg[4]),
        .I3(prime_count_reg[7]),
        .I4(prime_count_reg[8]),
        .O(prime_count));
  LUT6 #(
    .INIT(64'hDFFFDFFFFFFFDFFF)) 
    \hop_count[6]_i_5 
       (.I0(\hop_count_reg_n_0_[1] ),
        .I1(\hop_count_reg_n_0_[2] ),
        .I2(\hop_count_reg_n_0_[0] ),
        .I3(\hop_count_reg_n_0_[5] ),
        .I4(\hop_count_reg_n_0_[3] ),
        .I5(\hop_count_reg_n_0_[4] ),
        .O(\hop_count[6]_i_5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair42" *) 
  LUT5 #(
    .INIT(32'h80000000)) 
    \hop_count[6]_i_6 
       (.I0(\hop_count_reg_n_0_[4] ),
        .I1(\hop_count_reg_n_0_[2] ),
        .I2(\hop_count_reg_n_0_[1] ),
        .I3(\hop_count_reg_n_0_[0] ),
        .I4(\hop_count_reg_n_0_[3] ),
        .O(\hop_count[6]_i_6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'hBFFFFFFF)) 
    \hop_count[6]_i_7 
       (.I0(prime_count_reg[5]),
        .I1(prime_count_reg[1]),
        .I2(prime_count_reg[0]),
        .I3(prime_count_reg[2]),
        .I4(prime_count_reg[3]),
        .O(\hop_count[6]_i_7_n_0 ));
  FDRE \hop_count_reg[0] 
       (.C(clk),
        .CE(\hop_count[6]_i_2_n_0 ),
        .D(hop_count[0]),
        .Q(\hop_count_reg_n_0_[0] ),
        .R(\hop_count[6]_i_1_n_0 ));
  FDRE \hop_count_reg[1] 
       (.C(clk),
        .CE(\hop_count[6]_i_2_n_0 ),
        .D(hop_count[1]),
        .Q(\hop_count_reg_n_0_[1] ),
        .R(\hop_count[6]_i_1_n_0 ));
  FDRE \hop_count_reg[2] 
       (.C(clk),
        .CE(\hop_count[6]_i_2_n_0 ),
        .D(hop_count[2]),
        .Q(\hop_count_reg_n_0_[2] ),
        .R(\hop_count[6]_i_1_n_0 ));
  FDRE \hop_count_reg[3] 
       (.C(clk),
        .CE(\hop_count[6]_i_2_n_0 ),
        .D(hop_count[3]),
        .Q(\hop_count_reg_n_0_[3] ),
        .R(\hop_count[6]_i_1_n_0 ));
  FDRE \hop_count_reg[4] 
       (.C(clk),
        .CE(\hop_count[6]_i_2_n_0 ),
        .D(hop_count[4]),
        .Q(\hop_count_reg_n_0_[4] ),
        .R(\hop_count[6]_i_1_n_0 ));
  FDRE \hop_count_reg[5] 
       (.C(clk),
        .CE(\hop_count[6]_i_2_n_0 ),
        .D(hop_count[5]),
        .Q(\hop_count_reg_n_0_[5] ),
        .R(\hop_count[6]_i_1_n_0 ));
  FDRE \hop_count_reg[6] 
       (.C(clk),
        .CE(\hop_count[6]_i_2_n_0 ),
        .D(hop_count[6]),
        .Q(\hop_count_reg_n_0_[6] ),
        .R(\hop_count[6]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \mav_sum[0]_i_1 
       (.I0(rst_n),
        .I1(clamp3210_in),
        .I2(clamp321),
        .I3(next_mav[0]),
        .I4(window_valid13_in),
        .I5(\win_mav_reg[3]_i_1_n_7 ),
        .O(\mav_sum[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \mav_sum[10]_i_1 
       (.I0(rst_n),
        .I1(clamp3210_in),
        .I2(clamp321),
        .I3(next_mav[10]),
        .I4(window_valid13_in),
        .I5(\win_mav_reg[11]_i_1_n_5 ),
        .O(\mav_sum[10]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \mav_sum[11]_i_1 
       (.I0(rst_n),
        .I1(clamp3210_in),
        .I2(clamp321),
        .I3(next_mav[11]),
        .I4(window_valid13_in),
        .I5(\win_mav_reg[11]_i_1_n_4 ),
        .O(\mav_sum[11]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \mav_sum[12]_i_1 
       (.I0(rst_n),
        .I1(clamp3210_in),
        .I2(clamp321),
        .I3(next_mav[12]),
        .I4(window_valid13_in),
        .I5(\win_mav_reg[15]_i_1_n_7 ),
        .O(\mav_sum[12]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \mav_sum[13]_i_1 
       (.I0(rst_n),
        .I1(clamp3210_in),
        .I2(clamp321),
        .I3(next_mav[13]),
        .I4(window_valid13_in),
        .I5(\win_mav_reg[15]_i_1_n_6 ),
        .O(\mav_sum[13]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \mav_sum[14]_i_1 
       (.I0(rst_n),
        .I1(clamp3210_in),
        .I2(clamp321),
        .I3(next_mav[14]),
        .I4(window_valid13_in),
        .I5(\win_mav_reg[15]_i_1_n_5 ),
        .O(\mav_sum[14]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \mav_sum[15]_i_1 
       (.I0(rst_n),
        .I1(clamp3210_in),
        .I2(clamp321),
        .I3(next_mav[15]),
        .I4(window_valid13_in),
        .I5(\win_mav_reg[15]_i_1_n_4 ),
        .O(\mav_sum[15]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \mav_sum[16]_i_1 
       (.I0(rst_n),
        .I1(clamp3210_in),
        .I2(clamp321),
        .I3(next_mav[16]),
        .I4(window_valid13_in),
        .I5(\win_mav_reg[19]_i_1_n_7 ),
        .O(\mav_sum[16]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \mav_sum[17]_i_1 
       (.I0(rst_n),
        .I1(clamp3210_in),
        .I2(clamp321),
        .I3(next_mav[17]),
        .I4(window_valid13_in),
        .I5(\win_mav_reg[19]_i_1_n_6 ),
        .O(\mav_sum[17]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \mav_sum[18]_i_1 
       (.I0(rst_n),
        .I1(clamp3210_in),
        .I2(clamp321),
        .I3(next_mav[18]),
        .I4(window_valid13_in),
        .I5(\win_mav_reg[19]_i_1_n_5 ),
        .O(\mav_sum[18]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \mav_sum[19]_i_1 
       (.I0(rst_n),
        .I1(clamp3210_in),
        .I2(clamp321),
        .I3(next_mav[19]),
        .I4(window_valid13_in),
        .I5(\win_mav_reg[19]_i_1_n_4 ),
        .O(\mav_sum[19]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \mav_sum[1]_i_1 
       (.I0(rst_n),
        .I1(clamp3210_in),
        .I2(clamp321),
        .I3(next_mav[1]),
        .I4(window_valid13_in),
        .I5(\win_mav_reg[3]_i_1_n_6 ),
        .O(\mav_sum[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \mav_sum[20]_i_1 
       (.I0(rst_n),
        .I1(clamp3210_in),
        .I2(clamp321),
        .I3(next_mav[20]),
        .I4(window_valid13_in),
        .I5(\win_mav_reg[23]_i_1_n_7 ),
        .O(\mav_sum[20]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \mav_sum[21]_i_1 
       (.I0(rst_n),
        .I1(clamp3210_in),
        .I2(clamp321),
        .I3(next_mav[21]),
        .I4(window_valid13_in),
        .I5(\win_mav_reg[23]_i_1_n_6 ),
        .O(\mav_sum[21]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \mav_sum[22]_i_1 
       (.I0(rst_n),
        .I1(clamp3210_in),
        .I2(clamp321),
        .I3(next_mav[22]),
        .I4(window_valid13_in),
        .I5(\win_mav_reg[23]_i_1_n_5 ),
        .O(\mav_sum[22]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \mav_sum[23]_i_1 
       (.I0(rst_n),
        .I1(clamp3210_in),
        .I2(clamp321),
        .I3(next_mav[23]),
        .I4(window_valid13_in),
        .I5(\win_mav_reg[23]_i_1_n_4 ),
        .O(\mav_sum[23]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \mav_sum[24]_i_1 
       (.I0(rst_n),
        .I1(clamp3210_in),
        .I2(clamp321),
        .I3(next_mav[24]),
        .I4(window_valid13_in),
        .I5(\win_mav_reg[27]_i_1_n_7 ),
        .O(\mav_sum[24]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \mav_sum[25]_i_1 
       (.I0(rst_n),
        .I1(clamp3210_in),
        .I2(clamp321),
        .I3(next_mav[25]),
        .I4(window_valid13_in),
        .I5(\win_mav_reg[27]_i_1_n_6 ),
        .O(\mav_sum[25]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \mav_sum[26]_i_1 
       (.I0(rst_n),
        .I1(clamp3210_in),
        .I2(clamp321),
        .I3(next_mav[26]),
        .I4(window_valid13_in),
        .I5(\win_mav_reg[27]_i_1_n_5 ),
        .O(\mav_sum[26]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \mav_sum[27]_i_1 
       (.I0(rst_n),
        .I1(clamp3210_in),
        .I2(clamp321),
        .I3(next_mav[27]),
        .I4(window_valid13_in),
        .I5(\win_mav_reg[27]_i_1_n_4 ),
        .O(\mav_sum[27]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \mav_sum[28]_i_1 
       (.I0(rst_n),
        .I1(clamp3210_in),
        .I2(clamp321),
        .I3(next_mav[28]),
        .I4(window_valid13_in),
        .I5(\win_mav_reg[31]_i_1_n_7 ),
        .O(\mav_sum[28]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \mav_sum[29]_i_1 
       (.I0(rst_n),
        .I1(clamp3210_in),
        .I2(clamp321),
        .I3(next_mav[29]),
        .I4(window_valid13_in),
        .I5(\win_mav_reg[31]_i_1_n_6 ),
        .O(\mav_sum[29]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \mav_sum[2]_i_1 
       (.I0(rst_n),
        .I1(clamp3210_in),
        .I2(clamp321),
        .I3(next_mav[2]),
        .I4(window_valid13_in),
        .I5(\win_mav_reg[3]_i_1_n_5 ),
        .O(\mav_sum[2]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h8F)) 
    \mav_sum[30]_i_1 
       (.I0(window_valid0),
        .I1(sample_valid),
        .I2(rst_n),
        .O(\mav_sum[30]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \mav_sum[30]_i_2 
       (.I0(rst_n),
        .I1(clamp3210_in),
        .I2(clamp321),
        .I3(next_mav[30]),
        .I4(window_valid13_in),
        .I5(\win_mav_reg[31]_i_1_n_5 ),
        .O(\mav_sum[30]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'h0080)) 
    \mav_sum[30]_i_3 
       (.I0(\mav_sum[30]_i_4_n_0 ),
        .I1(seg_count_reg[0]),
        .I2(seg_count_reg[1]),
        .I3(seg_count_reg[2]),
        .O(window_valid13_in));
  (* SOFT_HLUTNM = "soft_lutpair43" *) 
  LUT4 #(
    .INIT(16'h0008)) 
    \mav_sum[30]_i_4 
       (.I0(seg_count_reg[6]),
        .I1(seg_count_reg[5]),
        .I2(seg_count_reg[4]),
        .I3(seg_count_reg[3]),
        .O(\mav_sum[30]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h4440FFFF44400000)) 
    \mav_sum[31]_i_1 
       (.I0(clamp3210_in),
        .I1(rst_n),
        .I2(\next_mav[31]_i_1_n_0 ),
        .I3(clamp321),
        .I4(\mav_sum[30]_i_1_n_0 ),
        .I5(mav_sum[31]),
        .O(\mav_sum[31]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    \mav_sum[31]_i_10 
       (.I0(\win_mav_reg[39]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_mav[36]),
        .I3(\win_mav_reg[39]_i_1_n_6 ),
        .I4(next_mav[37]),
        .O(\mav_sum[31]_i_10_n_0 ));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    \mav_sum[31]_i_11 
       (.I0(\win_mav_reg[35]_i_1_n_5 ),
        .I1(window_valid13_in),
        .I2(next_mav[34]),
        .I3(\win_mav_reg[35]_i_1_n_4 ),
        .I4(next_mav[35]),
        .O(\mav_sum[31]_i_11_n_0 ));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    \mav_sum[31]_i_12 
       (.I0(\win_mav_reg[35]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_mav[32]),
        .I3(\win_mav_reg[35]_i_1_n_6 ),
        .I4(next_mav[33]),
        .O(\mav_sum[31]_i_12_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \mav_sum[31]_i_13 
       (.I0(\win_mav_reg[31]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_mav[31]),
        .O(\mav_sum[31]_i_13_n_0 ));
  LUT5 #(
    .INIT(32'h00053305)) 
    \mav_sum[31]_i_14 
       (.I0(next_mav[37]),
        .I1(\win_mav_reg[39]_i_1_n_6 ),
        .I2(next_mav[36]),
        .I3(window_valid13_in),
        .I4(\win_mav_reg[39]_i_1_n_7 ),
        .O(\mav_sum[31]_i_14_n_0 ));
  LUT5 #(
    .INIT(32'h00053305)) 
    \mav_sum[31]_i_15 
       (.I0(next_mav[35]),
        .I1(\win_mav_reg[35]_i_1_n_4 ),
        .I2(next_mav[34]),
        .I3(window_valid13_in),
        .I4(\win_mav_reg[35]_i_1_n_5 ),
        .O(\mav_sum[31]_i_15_n_0 ));
  LUT5 #(
    .INIT(32'h00053305)) 
    \mav_sum[31]_i_16 
       (.I0(next_mav[33]),
        .I1(\win_mav_reg[35]_i_1_n_6 ),
        .I2(next_mav[32]),
        .I3(window_valid13_in),
        .I4(\win_mav_reg[35]_i_1_n_7 ),
        .O(\mav_sum[31]_i_16_n_0 ));
  LUT5 #(
    .INIT(32'h000ACC0A)) 
    \mav_sum[31]_i_17 
       (.I0(next_mav[30]),
        .I1(\win_mav_reg[31]_i_1_n_5 ),
        .I2(next_mav[31]),
        .I3(window_valid13_in),
        .I4(\win_mav_reg[31]_i_1_n_4 ),
        .O(\mav_sum[31]_i_17_n_0 ));
  LUT5 #(
    .INIT(32'h47CF77FF)) 
    \mav_sum[31]_i_18 
       (.I0(\win_mav_reg[39]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_mav[37]),
        .I3(\win_mav_reg[39]_i_1_n_7 ),
        .I4(next_mav[36]),
        .O(\mav_sum[31]_i_18_n_0 ));
  LUT5 #(
    .INIT(32'h47CF77FF)) 
    \mav_sum[31]_i_19 
       (.I0(\win_mav_reg[35]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_mav[35]),
        .I3(\win_mav_reg[35]_i_1_n_5 ),
        .I4(next_mav[34]),
        .O(\mav_sum[31]_i_19_n_0 ));
  LUT5 #(
    .INIT(32'h47CF77FF)) 
    \mav_sum[31]_i_20 
       (.I0(\win_mav_reg[35]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_mav[33]),
        .I3(\win_mav_reg[35]_i_1_n_7 ),
        .I4(next_mav[32]),
        .O(\mav_sum[31]_i_20_n_0 ));
  LUT3 #(
    .INIT(8'h1D)) 
    \mav_sum[31]_i_21 
       (.I0(next_mav[31]),
        .I1(window_valid13_in),
        .I2(\win_mav_reg[31]_i_1_n_4 ),
        .O(\mav_sum[31]_i_21_n_0 ));
  LUT5 #(
    .INIT(32'hCCA000A0)) 
    \mav_sum[31]_i_22 
       (.I0(next_mav[36]),
        .I1(\win_mav_reg[39]_i_1_n_7 ),
        .I2(next_mav[37]),
        .I3(window_valid13_in),
        .I4(\win_mav_reg[39]_i_1_n_6 ),
        .O(\mav_sum[31]_i_22_n_0 ));
  LUT5 #(
    .INIT(32'hCCA000A0)) 
    \mav_sum[31]_i_23 
       (.I0(next_mav[34]),
        .I1(\win_mav_reg[35]_i_1_n_5 ),
        .I2(next_mav[35]),
        .I3(window_valid13_in),
        .I4(\win_mav_reg[35]_i_1_n_4 ),
        .O(\mav_sum[31]_i_23_n_0 ));
  LUT5 #(
    .INIT(32'hCCA000A0)) 
    \mav_sum[31]_i_24 
       (.I0(next_mav[32]),
        .I1(\win_mav_reg[35]_i_1_n_7 ),
        .I2(next_mav[33]),
        .I3(window_valid13_in),
        .I4(\win_mav_reg[35]_i_1_n_6 ),
        .O(\mav_sum[31]_i_24_n_0 ));
  LUT5 #(
    .INIT(32'h000ACC0A)) 
    \mav_sum[31]_i_25 
       (.I0(next_mav[31]),
        .I1(\win_mav_reg[31]_i_1_n_4 ),
        .I2(next_mav[30]),
        .I3(window_valid13_in),
        .I4(\win_mav_reg[31]_i_1_n_5 ),
        .O(\mav_sum[31]_i_25_n_0 ));
  LUT5 #(
    .INIT(32'h000ACC0A)) 
    \mav_sum[31]_i_5 
       (.I0(next_mav[38]),
        .I1(\win_mav_reg[39]_i_1_n_5 ),
        .I2(next_mav[39]),
        .I3(window_valid13_in),
        .I4(\win_mav_reg[39]_i_1_n_4 ),
        .O(\mav_sum[31]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'h00053305)) 
    \mav_sum[31]_i_6 
       (.I0(next_mav[38]),
        .I1(\win_mav_reg[39]_i_1_n_5 ),
        .I2(next_mav[39]),
        .I3(window_valid13_in),
        .I4(\win_mav_reg[39]_i_1_n_4 ),
        .O(\mav_sum[31]_i_6_n_0 ));
  LUT5 #(
    .INIT(32'h000ACC0A)) 
    \mav_sum[31]_i_8 
       (.I0(next_mav[39]),
        .I1(\win_mav_reg[39]_i_1_n_4 ),
        .I2(next_mav[38]),
        .I3(window_valid13_in),
        .I4(\win_mav_reg[39]_i_1_n_5 ),
        .O(\mav_sum[31]_i_8_n_0 ));
  LUT5 #(
    .INIT(32'hCCA000A0)) 
    \mav_sum[31]_i_9 
       (.I0(next_mav[38]),
        .I1(\win_mav_reg[39]_i_1_n_5 ),
        .I2(next_mav[39]),
        .I3(window_valid13_in),
        .I4(\win_mav_reg[39]_i_1_n_4 ),
        .O(\mav_sum[31]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \mav_sum[3]_i_1 
       (.I0(rst_n),
        .I1(clamp3210_in),
        .I2(clamp321),
        .I3(next_mav[3]),
        .I4(window_valid13_in),
        .I5(\win_mav_reg[3]_i_1_n_4 ),
        .O(\mav_sum[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \mav_sum[4]_i_1 
       (.I0(rst_n),
        .I1(clamp3210_in),
        .I2(clamp321),
        .I3(next_mav[4]),
        .I4(window_valid13_in),
        .I5(\win_mav_reg[7]_i_1_n_7 ),
        .O(\mav_sum[4]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \mav_sum[5]_i_1 
       (.I0(rst_n),
        .I1(clamp3210_in),
        .I2(clamp321),
        .I3(next_mav[5]),
        .I4(window_valid13_in),
        .I5(\win_mav_reg[7]_i_1_n_6 ),
        .O(\mav_sum[5]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \mav_sum[6]_i_1 
       (.I0(rst_n),
        .I1(clamp3210_in),
        .I2(clamp321),
        .I3(next_mav[6]),
        .I4(window_valid13_in),
        .I5(\win_mav_reg[7]_i_1_n_5 ),
        .O(\mav_sum[6]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \mav_sum[7]_i_1 
       (.I0(rst_n),
        .I1(clamp3210_in),
        .I2(clamp321),
        .I3(next_mav[7]),
        .I4(window_valid13_in),
        .I5(\win_mav_reg[7]_i_1_n_4 ),
        .O(\mav_sum[7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \mav_sum[8]_i_1 
       (.I0(rst_n),
        .I1(clamp3210_in),
        .I2(clamp321),
        .I3(next_mav[8]),
        .I4(window_valid13_in),
        .I5(\win_mav_reg[11]_i_1_n_7 ),
        .O(\mav_sum[8]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \mav_sum[9]_i_1 
       (.I0(rst_n),
        .I1(clamp3210_in),
        .I2(clamp321),
        .I3(next_mav[9]),
        .I4(window_valid13_in),
        .I5(\win_mav_reg[11]_i_1_n_6 ),
        .O(\mav_sum[9]_i_1_n_0 ));
  FDSE \mav_sum_reg[0] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\mav_sum[0]_i_1_n_0 ),
        .Q(mav_sum[0]),
        .S(1'b0));
  FDSE \mav_sum_reg[10] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\mav_sum[10]_i_1_n_0 ),
        .Q(mav_sum[10]),
        .S(1'b0));
  FDSE \mav_sum_reg[11] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\mav_sum[11]_i_1_n_0 ),
        .Q(mav_sum[11]),
        .S(1'b0));
  FDSE \mav_sum_reg[12] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\mav_sum[12]_i_1_n_0 ),
        .Q(mav_sum[12]),
        .S(1'b0));
  FDSE \mav_sum_reg[13] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\mav_sum[13]_i_1_n_0 ),
        .Q(mav_sum[13]),
        .S(1'b0));
  FDSE \mav_sum_reg[14] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\mav_sum[14]_i_1_n_0 ),
        .Q(mav_sum[14]),
        .S(1'b0));
  FDSE \mav_sum_reg[15] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\mav_sum[15]_i_1_n_0 ),
        .Q(mav_sum[15]),
        .S(1'b0));
  FDSE \mav_sum_reg[16] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\mav_sum[16]_i_1_n_0 ),
        .Q(mav_sum[16]),
        .S(1'b0));
  FDSE \mav_sum_reg[17] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\mav_sum[17]_i_1_n_0 ),
        .Q(mav_sum[17]),
        .S(1'b0));
  FDSE \mav_sum_reg[18] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\mav_sum[18]_i_1_n_0 ),
        .Q(mav_sum[18]),
        .S(1'b0));
  FDSE \mav_sum_reg[19] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\mav_sum[19]_i_1_n_0 ),
        .Q(mav_sum[19]),
        .S(1'b0));
  FDSE \mav_sum_reg[1] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\mav_sum[1]_i_1_n_0 ),
        .Q(mav_sum[1]),
        .S(1'b0));
  FDSE \mav_sum_reg[20] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\mav_sum[20]_i_1_n_0 ),
        .Q(mav_sum[20]),
        .S(1'b0));
  FDSE \mav_sum_reg[21] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\mav_sum[21]_i_1_n_0 ),
        .Q(mav_sum[21]),
        .S(1'b0));
  FDSE \mav_sum_reg[22] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\mav_sum[22]_i_1_n_0 ),
        .Q(mav_sum[22]),
        .S(1'b0));
  FDSE \mav_sum_reg[23] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\mav_sum[23]_i_1_n_0 ),
        .Q(mav_sum[23]),
        .S(1'b0));
  FDSE \mav_sum_reg[24] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\mav_sum[24]_i_1_n_0 ),
        .Q(mav_sum[24]),
        .S(1'b0));
  FDSE \mav_sum_reg[25] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\mav_sum[25]_i_1_n_0 ),
        .Q(mav_sum[25]),
        .S(1'b0));
  FDSE \mav_sum_reg[26] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\mav_sum[26]_i_1_n_0 ),
        .Q(mav_sum[26]),
        .S(1'b0));
  FDSE \mav_sum_reg[27] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\mav_sum[27]_i_1_n_0 ),
        .Q(mav_sum[27]),
        .S(1'b0));
  FDSE \mav_sum_reg[28] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\mav_sum[28]_i_1_n_0 ),
        .Q(mav_sum[28]),
        .S(1'b0));
  FDSE \mav_sum_reg[29] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\mav_sum[29]_i_1_n_0 ),
        .Q(mav_sum[29]),
        .S(1'b0));
  FDSE \mav_sum_reg[2] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\mav_sum[2]_i_1_n_0 ),
        .Q(mav_sum[2]),
        .S(1'b0));
  FDSE \mav_sum_reg[30] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\mav_sum[30]_i_2_n_0 ),
        .Q(mav_sum[30]),
        .S(1'b0));
  FDRE \mav_sum_reg[31] 
       (.C(clk),
        .CE(1'b1),
        .D(\mav_sum[31]_i_1_n_0 ),
        .Q(mav_sum[31]),
        .R(1'b0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \mav_sum_reg[31]_i_2 
       (.CI(\mav_sum_reg[31]_i_4_n_0 ),
        .CO({\NLW_mav_sum_reg[31]_i_2_CO_UNCONNECTED [3:1],clamp3210_in}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,\mav_sum[31]_i_5_n_0 }),
        .O(\NLW_mav_sum_reg[31]_i_2_O_UNCONNECTED [3:0]),
        .S({1'b0,1'b0,1'b0,\mav_sum[31]_i_6_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \mav_sum_reg[31]_i_3 
       (.CI(\mav_sum_reg[31]_i_7_n_0 ),
        .CO({\NLW_mav_sum_reg[31]_i_3_CO_UNCONNECTED [3:1],clamp321}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,\mav_sum[31]_i_8_n_0 }),
        .O(\NLW_mav_sum_reg[31]_i_3_O_UNCONNECTED [3:0]),
        .S({1'b0,1'b0,1'b0,\mav_sum[31]_i_9_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \mav_sum_reg[31]_i_4 
       (.CI(1'b0),
        .CO({\mav_sum_reg[31]_i_4_n_0 ,\mav_sum_reg[31]_i_4_n_1 ,\mav_sum_reg[31]_i_4_n_2 ,\mav_sum_reg[31]_i_4_n_3 }),
        .CYINIT(1'b0),
        .DI({\mav_sum[31]_i_10_n_0 ,\mav_sum[31]_i_11_n_0 ,\mav_sum[31]_i_12_n_0 ,\mav_sum[31]_i_13_n_0 }),
        .O(\NLW_mav_sum_reg[31]_i_4_O_UNCONNECTED [3:0]),
        .S({\mav_sum[31]_i_14_n_0 ,\mav_sum[31]_i_15_n_0 ,\mav_sum[31]_i_16_n_0 ,\mav_sum[31]_i_17_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \mav_sum_reg[31]_i_7 
       (.CI(1'b0),
        .CO({\mav_sum_reg[31]_i_7_n_0 ,\mav_sum_reg[31]_i_7_n_1 ,\mav_sum_reg[31]_i_7_n_2 ,\mav_sum_reg[31]_i_7_n_3 }),
        .CYINIT(1'b0),
        .DI({\mav_sum[31]_i_18_n_0 ,\mav_sum[31]_i_19_n_0 ,\mav_sum[31]_i_20_n_0 ,\mav_sum[31]_i_21_n_0 }),
        .O(\NLW_mav_sum_reg[31]_i_7_O_UNCONNECTED [3:0]),
        .S({\mav_sum[31]_i_22_n_0 ,\mav_sum[31]_i_23_n_0 ,\mav_sum[31]_i_24_n_0 ,\mav_sum[31]_i_25_n_0 }));
  FDSE \mav_sum_reg[3] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\mav_sum[3]_i_1_n_0 ),
        .Q(mav_sum[3]),
        .S(1'b0));
  FDSE \mav_sum_reg[4] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\mav_sum[4]_i_1_n_0 ),
        .Q(mav_sum[4]),
        .S(1'b0));
  FDSE \mav_sum_reg[5] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\mav_sum[5]_i_1_n_0 ),
        .Q(mav_sum[5]),
        .S(1'b0));
  FDSE \mav_sum_reg[6] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\mav_sum[6]_i_1_n_0 ),
        .Q(mav_sum[6]),
        .S(1'b0));
  FDSE \mav_sum_reg[7] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\mav_sum[7]_i_1_n_0 ),
        .Q(mav_sum[7]),
        .S(1'b0));
  FDSE \mav_sum_reg[8] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\mav_sum[8]_i_1_n_0 ),
        .Q(mav_sum[8]),
        .S(1'b0));
  FDSE \mav_sum_reg[9] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\mav_sum[9]_i_1_n_0 ),
        .Q(mav_sum[9]),
        .S(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair57" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[0]_i_1 
       (.I0(\win_energy_reg[3]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_energy[0]),
        .O(\next_energy[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair62" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[10]_i_1 
       (.I0(\win_energy_reg[11]_i_1_n_5 ),
        .I1(window_valid13_in),
        .I2(next_energy[10]),
        .O(\next_energy[10]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair62" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[11]_i_1 
       (.I0(\win_energy_reg[11]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_energy[11]),
        .O(\next_energy[11]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair63" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[12]_i_1 
       (.I0(\win_energy_reg[15]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_energy[12]),
        .O(\next_energy[12]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair63" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[13]_i_1 
       (.I0(\win_energy_reg[15]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_energy[13]),
        .O(\next_energy[13]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair64" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[14]_i_1 
       (.I0(\win_energy_reg[15]_i_1_n_5 ),
        .I1(window_valid13_in),
        .I2(next_energy[14]),
        .O(\next_energy[14]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair64" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[15]_i_1 
       (.I0(\win_energy_reg[15]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_energy[15]),
        .O(\next_energy[15]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair65" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[16]_i_1 
       (.I0(\win_energy_reg[19]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_energy[16]),
        .O(\next_energy[16]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair65" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[17]_i_1 
       (.I0(\win_energy_reg[19]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_energy[17]),
        .O(\next_energy[17]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair66" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[18]_i_1 
       (.I0(\win_energy_reg[19]_i_1_n_5 ),
        .I1(window_valid13_in),
        .I2(next_energy[18]),
        .O(\next_energy[18]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair66" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[19]_i_1 
       (.I0(\win_energy_reg[19]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_energy[19]),
        .O(\next_energy[19]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair57" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[1]_i_1 
       (.I0(\win_energy_reg[3]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_energy[1]),
        .O(\next_energy[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair67" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[20]_i_1 
       (.I0(\win_energy_reg[23]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_energy[20]),
        .O(\next_energy[20]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair67" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[21]_i_1 
       (.I0(\win_energy_reg[23]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_energy[21]),
        .O(\next_energy[21]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair68" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[22]_i_1 
       (.I0(\win_energy_reg[23]_i_1_n_5 ),
        .I1(window_valid13_in),
        .I2(next_energy[22]),
        .O(\next_energy[22]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair68" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[23]_i_1 
       (.I0(\win_energy_reg[23]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_energy[23]),
        .O(\next_energy[23]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair69" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[24]_i_1 
       (.I0(\win_energy_reg[27]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_energy[24]),
        .O(\next_energy[24]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair69" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[25]_i_1 
       (.I0(\win_energy_reg[27]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_energy[25]),
        .O(\next_energy[25]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair70" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[26]_i_1 
       (.I0(\win_energy_reg[27]_i_1_n_5 ),
        .I1(window_valid13_in),
        .I2(next_energy[26]),
        .O(\next_energy[26]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair70" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[27]_i_1 
       (.I0(\win_energy_reg[27]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_energy[27]),
        .O(\next_energy[27]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair71" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[28]_i_1 
       (.I0(\win_energy_reg[31]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_energy[28]),
        .O(\next_energy[28]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair71" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[29]_i_1 
       (.I0(\win_energy_reg[31]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_energy[29]),
        .O(\next_energy[29]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair58" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[2]_i_1 
       (.I0(\win_energy_reg[3]_i_1_n_5 ),
        .I1(window_valid13_in),
        .I2(next_energy[2]),
        .O(\next_energy[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair106" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[30]_i_1 
       (.I0(\win_energy_reg[31]_i_1_n_5 ),
        .I1(window_valid13_in),
        .I2(next_energy[30]),
        .O(\next_energy[30]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair106" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[31]_i_1 
       (.I0(\win_energy_reg[31]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_energy[31]),
        .O(\next_energy[31]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair105" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[32]_i_1 
       (.I0(\win_energy_reg[35]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_energy[32]),
        .O(\next_energy[32]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair105" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[33]_i_1 
       (.I0(\win_energy_reg[35]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_energy[33]),
        .O(\next_energy[33]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair104" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[34]_i_1 
       (.I0(\win_energy_reg[35]_i_1_n_5 ),
        .I1(window_valid13_in),
        .I2(next_energy[34]),
        .O(\next_energy[34]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair104" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[35]_i_1 
       (.I0(\win_energy_reg[35]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_energy[35]),
        .O(\next_energy[35]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair103" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[36]_i_1 
       (.I0(\win_energy_reg[39]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_energy[36]),
        .O(\next_energy[36]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair103" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[37]_i_1 
       (.I0(\win_energy_reg[39]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_energy[37]),
        .O(\next_energy[37]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair102" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[38]_i_1 
       (.I0(\win_energy_reg[39]_i_1_n_5 ),
        .I1(window_valid13_in),
        .I2(next_energy[38]),
        .O(\next_energy[38]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair102" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[39]_i_1 
       (.I0(\win_energy_reg[39]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_energy[39]),
        .O(\next_energy[39]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair58" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[3]_i_1 
       (.I0(\win_energy_reg[3]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_energy[3]),
        .O(\next_energy[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair59" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[4]_i_1 
       (.I0(\win_energy_reg[7]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_energy[4]),
        .O(\next_energy[4]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair59" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[5]_i_1 
       (.I0(\win_energy_reg[7]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_energy[5]),
        .O(\next_energy[5]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair60" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[6]_i_1 
       (.I0(\win_energy_reg[7]_i_1_n_5 ),
        .I1(window_valid13_in),
        .I2(next_energy[6]),
        .O(\next_energy[6]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair60" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[7]_i_1 
       (.I0(\win_energy_reg[7]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_energy[7]),
        .O(\next_energy[7]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair61" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[8]_i_1 
       (.I0(\win_energy_reg[11]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_energy[8]),
        .O(\next_energy[8]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair61" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_energy[9]_i_1 
       (.I0(\win_energy_reg[11]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_energy[9]),
        .O(\next_energy[9]_i_1_n_0 ));
  FDRE \next_energy_reg[0] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[0]_i_1_n_0 ),
        .Q(next_energy[0]),
        .R(1'b0));
  FDRE \next_energy_reg[10] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[10]_i_1_n_0 ),
        .Q(next_energy[10]),
        .R(1'b0));
  FDRE \next_energy_reg[11] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[11]_i_1_n_0 ),
        .Q(next_energy[11]),
        .R(1'b0));
  FDRE \next_energy_reg[12] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[12]_i_1_n_0 ),
        .Q(next_energy[12]),
        .R(1'b0));
  FDRE \next_energy_reg[13] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[13]_i_1_n_0 ),
        .Q(next_energy[13]),
        .R(1'b0));
  FDRE \next_energy_reg[14] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[14]_i_1_n_0 ),
        .Q(next_energy[14]),
        .R(1'b0));
  FDRE \next_energy_reg[15] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[15]_i_1_n_0 ),
        .Q(next_energy[15]),
        .R(1'b0));
  FDRE \next_energy_reg[16] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[16]_i_1_n_0 ),
        .Q(next_energy[16]),
        .R(1'b0));
  FDRE \next_energy_reg[17] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[17]_i_1_n_0 ),
        .Q(next_energy[17]),
        .R(1'b0));
  FDRE \next_energy_reg[18] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[18]_i_1_n_0 ),
        .Q(next_energy[18]),
        .R(1'b0));
  FDRE \next_energy_reg[19] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[19]_i_1_n_0 ),
        .Q(next_energy[19]),
        .R(1'b0));
  FDRE \next_energy_reg[1] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[1]_i_1_n_0 ),
        .Q(next_energy[1]),
        .R(1'b0));
  FDRE \next_energy_reg[20] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[20]_i_1_n_0 ),
        .Q(next_energy[20]),
        .R(1'b0));
  FDRE \next_energy_reg[21] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[21]_i_1_n_0 ),
        .Q(next_energy[21]),
        .R(1'b0));
  FDRE \next_energy_reg[22] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[22]_i_1_n_0 ),
        .Q(next_energy[22]),
        .R(1'b0));
  FDRE \next_energy_reg[23] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[23]_i_1_n_0 ),
        .Q(next_energy[23]),
        .R(1'b0));
  FDRE \next_energy_reg[24] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[24]_i_1_n_0 ),
        .Q(next_energy[24]),
        .R(1'b0));
  FDRE \next_energy_reg[25] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[25]_i_1_n_0 ),
        .Q(next_energy[25]),
        .R(1'b0));
  FDRE \next_energy_reg[26] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[26]_i_1_n_0 ),
        .Q(next_energy[26]),
        .R(1'b0));
  FDRE \next_energy_reg[27] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[27]_i_1_n_0 ),
        .Q(next_energy[27]),
        .R(1'b0));
  FDRE \next_energy_reg[28] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[28]_i_1_n_0 ),
        .Q(next_energy[28]),
        .R(1'b0));
  FDRE \next_energy_reg[29] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[29]_i_1_n_0 ),
        .Q(next_energy[29]),
        .R(1'b0));
  FDRE \next_energy_reg[2] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[2]_i_1_n_0 ),
        .Q(next_energy[2]),
        .R(1'b0));
  FDRE \next_energy_reg[30] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[30]_i_1_n_0 ),
        .Q(next_energy[30]),
        .R(1'b0));
  FDRE \next_energy_reg[31] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[31]_i_1_n_0 ),
        .Q(next_energy[31]),
        .R(1'b0));
  FDRE \next_energy_reg[32] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[32]_i_1_n_0 ),
        .Q(next_energy[32]),
        .R(1'b0));
  FDRE \next_energy_reg[33] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[33]_i_1_n_0 ),
        .Q(next_energy[33]),
        .R(1'b0));
  FDRE \next_energy_reg[34] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[34]_i_1_n_0 ),
        .Q(next_energy[34]),
        .R(1'b0));
  FDRE \next_energy_reg[35] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[35]_i_1_n_0 ),
        .Q(next_energy[35]),
        .R(1'b0));
  FDRE \next_energy_reg[36] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[36]_i_1_n_0 ),
        .Q(next_energy[36]),
        .R(1'b0));
  FDRE \next_energy_reg[37] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[37]_i_1_n_0 ),
        .Q(next_energy[37]),
        .R(1'b0));
  FDRE \next_energy_reg[38] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[38]_i_1_n_0 ),
        .Q(next_energy[38]),
        .R(1'b0));
  FDRE \next_energy_reg[39] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[39]_i_1_n_0 ),
        .Q(next_energy[39]),
        .R(1'b0));
  FDRE \next_energy_reg[3] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[3]_i_1_n_0 ),
        .Q(next_energy[3]),
        .R(1'b0));
  FDRE \next_energy_reg[4] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[4]_i_1_n_0 ),
        .Q(next_energy[4]),
        .R(1'b0));
  FDRE \next_energy_reg[5] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[5]_i_1_n_0 ),
        .Q(next_energy[5]),
        .R(1'b0));
  FDRE \next_energy_reg[6] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[6]_i_1_n_0 ),
        .Q(next_energy[6]),
        .R(1'b0));
  FDRE \next_energy_reg[7] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[7]_i_1_n_0 ),
        .Q(next_energy[7]),
        .R(1'b0));
  FDRE \next_energy_reg[8] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[8]_i_1_n_0 ),
        .Q(next_energy[8]),
        .R(1'b0));
  FDRE \next_energy_reg[9] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_energy[9]_i_1_n_0 ),
        .Q(next_energy[9]),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair87" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[0]_i_1 
       (.I0(\win_mav_reg[3]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_mav[0]),
        .O(\next_mav[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair92" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[10]_i_1 
       (.I0(\win_mav_reg[11]_i_1_n_5 ),
        .I1(window_valid13_in),
        .I2(next_mav[10]),
        .O(\next_mav[10]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair92" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[11]_i_1 
       (.I0(\win_mav_reg[11]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_mav[11]),
        .O(\next_mav[11]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair93" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[12]_i_1 
       (.I0(\win_mav_reg[15]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_mav[12]),
        .O(\next_mav[12]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair93" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[13]_i_1 
       (.I0(\win_mav_reg[15]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_mav[13]),
        .O(\next_mav[13]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair94" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[14]_i_1 
       (.I0(\win_mav_reg[15]_i_1_n_5 ),
        .I1(window_valid13_in),
        .I2(next_mav[14]),
        .O(\next_mav[14]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair94" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[15]_i_1 
       (.I0(\win_mav_reg[15]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_mav[15]),
        .O(\next_mav[15]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair95" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[16]_i_1 
       (.I0(\win_mav_reg[19]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_mav[16]),
        .O(\next_mav[16]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair95" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[17]_i_1 
       (.I0(\win_mav_reg[19]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_mav[17]),
        .O(\next_mav[17]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair96" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[18]_i_1 
       (.I0(\win_mav_reg[19]_i_1_n_5 ),
        .I1(window_valid13_in),
        .I2(next_mav[18]),
        .O(\next_mav[18]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair96" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[19]_i_1 
       (.I0(\win_mav_reg[19]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_mav[19]),
        .O(\next_mav[19]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair87" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[1]_i_1 
       (.I0(\win_mav_reg[3]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_mav[1]),
        .O(\next_mav[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair97" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[20]_i_1 
       (.I0(\win_mav_reg[23]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_mav[20]),
        .O(\next_mav[20]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair97" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[21]_i_1 
       (.I0(\win_mav_reg[23]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_mav[21]),
        .O(\next_mav[21]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair98" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[22]_i_1 
       (.I0(\win_mav_reg[23]_i_1_n_5 ),
        .I1(window_valid13_in),
        .I2(next_mav[22]),
        .O(\next_mav[22]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair98" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[23]_i_1 
       (.I0(\win_mav_reg[23]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_mav[23]),
        .O(\next_mav[23]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair99" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[24]_i_1 
       (.I0(\win_mav_reg[27]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_mav[24]),
        .O(\next_mav[24]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair99" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[25]_i_1 
       (.I0(\win_mav_reg[27]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_mav[25]),
        .O(\next_mav[25]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair100" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[26]_i_1 
       (.I0(\win_mav_reg[27]_i_1_n_5 ),
        .I1(window_valid13_in),
        .I2(next_mav[26]),
        .O(\next_mav[26]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair100" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[27]_i_1 
       (.I0(\win_mav_reg[27]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_mav[27]),
        .O(\next_mav[27]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair101" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[28]_i_1 
       (.I0(\win_mav_reg[31]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_mav[28]),
        .O(\next_mav[28]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair101" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[29]_i_1 
       (.I0(\win_mav_reg[31]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_mav[29]),
        .O(\next_mav[29]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair88" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[2]_i_1 
       (.I0(\win_mav_reg[3]_i_1_n_5 ),
        .I1(window_valid13_in),
        .I2(next_mav[2]),
        .O(\next_mav[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair116" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[30]_i_1 
       (.I0(\win_mav_reg[31]_i_1_n_5 ),
        .I1(window_valid13_in),
        .I2(next_mav[30]),
        .O(\next_mav[30]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair116" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[31]_i_1 
       (.I0(\win_mav_reg[31]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_mav[31]),
        .O(\next_mav[31]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair115" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[32]_i_1 
       (.I0(\win_mav_reg[35]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_mav[32]),
        .O(\next_mav[32]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair115" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[33]_i_1 
       (.I0(\win_mav_reg[35]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_mav[33]),
        .O(\next_mav[33]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair114" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[34]_i_1 
       (.I0(\win_mav_reg[35]_i_1_n_5 ),
        .I1(window_valid13_in),
        .I2(next_mav[34]),
        .O(\next_mav[34]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair114" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[35]_i_1 
       (.I0(\win_mav_reg[35]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_mav[35]),
        .O(\next_mav[35]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair113" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[36]_i_1 
       (.I0(\win_mav_reg[39]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_mav[36]),
        .O(\next_mav[36]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair113" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[37]_i_1 
       (.I0(\win_mav_reg[39]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_mav[37]),
        .O(\next_mav[37]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair112" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[38]_i_1 
       (.I0(\win_mav_reg[39]_i_1_n_5 ),
        .I1(window_valid13_in),
        .I2(next_mav[38]),
        .O(\next_mav[38]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    \next_mav[39]_i_1 
       (.I0(rst_n),
        .I1(sample_valid),
        .O(next_zc));
  (* SOFT_HLUTNM = "soft_lutpair112" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[39]_i_2 
       (.I0(\win_mav_reg[39]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_mav[39]),
        .O(\next_mav[39]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair88" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[3]_i_1 
       (.I0(\win_mav_reg[3]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_mav[3]),
        .O(\next_mav[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair89" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[4]_i_1 
       (.I0(\win_mav_reg[7]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_mav[4]),
        .O(\next_mav[4]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair89" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[5]_i_1 
       (.I0(\win_mav_reg[7]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_mav[5]),
        .O(\next_mav[5]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair90" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[6]_i_1 
       (.I0(\win_mav_reg[7]_i_1_n_5 ),
        .I1(window_valid13_in),
        .I2(next_mav[6]),
        .O(\next_mav[6]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair90" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[7]_i_1 
       (.I0(\win_mav_reg[7]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_mav[7]),
        .O(\next_mav[7]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair91" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[8]_i_1 
       (.I0(\win_mav_reg[11]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_mav[8]),
        .O(\next_mav[8]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair91" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_mav[9]_i_1 
       (.I0(\win_mav_reg[11]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_mav[9]),
        .O(\next_mav[9]_i_1_n_0 ));
  FDRE \next_mav_reg[0] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[0]_i_1_n_0 ),
        .Q(next_mav[0]),
        .R(1'b0));
  FDRE \next_mav_reg[10] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[10]_i_1_n_0 ),
        .Q(next_mav[10]),
        .R(1'b0));
  FDRE \next_mav_reg[11] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[11]_i_1_n_0 ),
        .Q(next_mav[11]),
        .R(1'b0));
  FDRE \next_mav_reg[12] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[12]_i_1_n_0 ),
        .Q(next_mav[12]),
        .R(1'b0));
  FDRE \next_mav_reg[13] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[13]_i_1_n_0 ),
        .Q(next_mav[13]),
        .R(1'b0));
  FDRE \next_mav_reg[14] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[14]_i_1_n_0 ),
        .Q(next_mav[14]),
        .R(1'b0));
  FDRE \next_mav_reg[15] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[15]_i_1_n_0 ),
        .Q(next_mav[15]),
        .R(1'b0));
  FDRE \next_mav_reg[16] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[16]_i_1_n_0 ),
        .Q(next_mav[16]),
        .R(1'b0));
  FDRE \next_mav_reg[17] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[17]_i_1_n_0 ),
        .Q(next_mav[17]),
        .R(1'b0));
  FDRE \next_mav_reg[18] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[18]_i_1_n_0 ),
        .Q(next_mav[18]),
        .R(1'b0));
  FDRE \next_mav_reg[19] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[19]_i_1_n_0 ),
        .Q(next_mav[19]),
        .R(1'b0));
  FDRE \next_mav_reg[1] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[1]_i_1_n_0 ),
        .Q(next_mav[1]),
        .R(1'b0));
  FDRE \next_mav_reg[20] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[20]_i_1_n_0 ),
        .Q(next_mav[20]),
        .R(1'b0));
  FDRE \next_mav_reg[21] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[21]_i_1_n_0 ),
        .Q(next_mav[21]),
        .R(1'b0));
  FDRE \next_mav_reg[22] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[22]_i_1_n_0 ),
        .Q(next_mav[22]),
        .R(1'b0));
  FDRE \next_mav_reg[23] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[23]_i_1_n_0 ),
        .Q(next_mav[23]),
        .R(1'b0));
  FDRE \next_mav_reg[24] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[24]_i_1_n_0 ),
        .Q(next_mav[24]),
        .R(1'b0));
  FDRE \next_mav_reg[25] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[25]_i_1_n_0 ),
        .Q(next_mav[25]),
        .R(1'b0));
  FDRE \next_mav_reg[26] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[26]_i_1_n_0 ),
        .Q(next_mav[26]),
        .R(1'b0));
  FDRE \next_mav_reg[27] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[27]_i_1_n_0 ),
        .Q(next_mav[27]),
        .R(1'b0));
  FDRE \next_mav_reg[28] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[28]_i_1_n_0 ),
        .Q(next_mav[28]),
        .R(1'b0));
  FDRE \next_mav_reg[29] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[29]_i_1_n_0 ),
        .Q(next_mav[29]),
        .R(1'b0));
  FDRE \next_mav_reg[2] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[2]_i_1_n_0 ),
        .Q(next_mav[2]),
        .R(1'b0));
  FDRE \next_mav_reg[30] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[30]_i_1_n_0 ),
        .Q(next_mav[30]),
        .R(1'b0));
  FDRE \next_mav_reg[31] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[31]_i_1_n_0 ),
        .Q(next_mav[31]),
        .R(1'b0));
  FDRE \next_mav_reg[32] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[32]_i_1_n_0 ),
        .Q(next_mav[32]),
        .R(1'b0));
  FDRE \next_mav_reg[33] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[33]_i_1_n_0 ),
        .Q(next_mav[33]),
        .R(1'b0));
  FDRE \next_mav_reg[34] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[34]_i_1_n_0 ),
        .Q(next_mav[34]),
        .R(1'b0));
  FDRE \next_mav_reg[35] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[35]_i_1_n_0 ),
        .Q(next_mav[35]),
        .R(1'b0));
  FDRE \next_mav_reg[36] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[36]_i_1_n_0 ),
        .Q(next_mav[36]),
        .R(1'b0));
  FDRE \next_mav_reg[37] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[37]_i_1_n_0 ),
        .Q(next_mav[37]),
        .R(1'b0));
  FDRE \next_mav_reg[38] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[38]_i_1_n_0 ),
        .Q(next_mav[38]),
        .R(1'b0));
  FDRE \next_mav_reg[39] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[39]_i_2_n_0 ),
        .Q(next_mav[39]),
        .R(1'b0));
  FDRE \next_mav_reg[3] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[3]_i_1_n_0 ),
        .Q(next_mav[3]),
        .R(1'b0));
  FDRE \next_mav_reg[4] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[4]_i_1_n_0 ),
        .Q(next_mav[4]),
        .R(1'b0));
  FDRE \next_mav_reg[5] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[5]_i_1_n_0 ),
        .Q(next_mav[5]),
        .R(1'b0));
  FDRE \next_mav_reg[6] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[6]_i_1_n_0 ),
        .Q(next_mav[6]),
        .R(1'b0));
  FDRE \next_mav_reg[7] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[7]_i_1_n_0 ),
        .Q(next_mav[7]),
        .R(1'b0));
  FDRE \next_mav_reg[8] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[8]_i_1_n_0 ),
        .Q(next_mav[8]),
        .R(1'b0));
  FDRE \next_mav_reg[9] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_mav[9]_i_1_n_0 ),
        .Q(next_mav[9]),
        .R(1'b0));
  FDRE \next_ssc_reg[0] 
       (.C(clk),
        .CE(next_zc),
        .D(\ssc_count[0]_i_1_n_0 ),
        .Q(next_ssc[0]),
        .R(1'b0));
  FDRE \next_ssc_reg[1] 
       (.C(clk),
        .CE(next_zc),
        .D(\ssc_count[1]_i_1_n_0 ),
        .Q(next_ssc[1]),
        .R(1'b0));
  FDRE \next_ssc_reg[2] 
       (.C(clk),
        .CE(next_zc),
        .D(\ssc_count[2]_i_1_n_0 ),
        .Q(next_ssc[2]),
        .R(1'b0));
  FDRE \next_ssc_reg[3] 
       (.C(clk),
        .CE(next_zc),
        .D(\ssc_count[3]_i_1_n_0 ),
        .Q(next_ssc[3]),
        .R(1'b0));
  FDRE \next_ssc_reg[4] 
       (.C(clk),
        .CE(next_zc),
        .D(\ssc_count[4]_i_1_n_0 ),
        .Q(next_ssc[4]),
        .R(1'b0));
  FDRE \next_ssc_reg[5] 
       (.C(clk),
        .CE(next_zc),
        .D(\ssc_count[5]_i_1_n_0 ),
        .Q(next_ssc[5]),
        .R(1'b0));
  FDRE \next_ssc_reg[6] 
       (.C(clk),
        .CE(next_zc),
        .D(\ssc_count[6]_i_1_n_0 ),
        .Q(next_ssc[6]),
        .R(1'b0));
  FDRE \next_ssc_reg[7] 
       (.C(clk),
        .CE(next_zc),
        .D(\ssc_count[7]_i_1_n_0 ),
        .Q(next_ssc[7]),
        .R(1'b0));
  FDRE \next_ssc_reg[8] 
       (.C(clk),
        .CE(next_zc),
        .D(\ssc_count[8]_i_1_n_0 ),
        .Q(next_ssc[8]),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair72" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[0]_i_1 
       (.I0(\win_wl_reg[3]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_wl[0]),
        .O(\next_wl[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair77" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[10]_i_1 
       (.I0(\win_wl_reg[11]_i_1_n_5 ),
        .I1(window_valid13_in),
        .I2(next_wl[10]),
        .O(\next_wl[10]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair77" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[11]_i_1 
       (.I0(\win_wl_reg[11]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_wl[11]),
        .O(\next_wl[11]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair78" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[12]_i_1 
       (.I0(\win_wl_reg[15]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_wl[12]),
        .O(\next_wl[12]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair78" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[13]_i_1 
       (.I0(\win_wl_reg[15]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_wl[13]),
        .O(\next_wl[13]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair79" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[14]_i_1 
       (.I0(\win_wl_reg[15]_i_1_n_5 ),
        .I1(window_valid13_in),
        .I2(next_wl[14]),
        .O(\next_wl[14]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair79" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[15]_i_1 
       (.I0(\win_wl_reg[15]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_wl[15]),
        .O(\next_wl[15]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair80" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[16]_i_1 
       (.I0(\win_wl_reg[19]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_wl[16]),
        .O(\next_wl[16]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair80" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[17]_i_1 
       (.I0(\win_wl_reg[19]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_wl[17]),
        .O(\next_wl[17]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair81" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[18]_i_1 
       (.I0(\win_wl_reg[19]_i_1_n_5 ),
        .I1(window_valid13_in),
        .I2(next_wl[18]),
        .O(\next_wl[18]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair81" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[19]_i_1 
       (.I0(\win_wl_reg[19]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_wl[19]),
        .O(\next_wl[19]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair72" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[1]_i_1 
       (.I0(\win_wl_reg[3]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_wl[1]),
        .O(\next_wl[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair82" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[20]_i_1 
       (.I0(\win_wl_reg[23]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_wl[20]),
        .O(\next_wl[20]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair82" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[21]_i_1 
       (.I0(\win_wl_reg[23]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_wl[21]),
        .O(\next_wl[21]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair83" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[22]_i_1 
       (.I0(\win_wl_reg[23]_i_1_n_5 ),
        .I1(window_valid13_in),
        .I2(next_wl[22]),
        .O(\next_wl[22]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair83" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[23]_i_1 
       (.I0(\win_wl_reg[23]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_wl[23]),
        .O(\next_wl[23]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair84" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[24]_i_1 
       (.I0(\win_wl_reg[27]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_wl[24]),
        .O(\next_wl[24]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair84" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[25]_i_1 
       (.I0(\win_wl_reg[27]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_wl[25]),
        .O(\next_wl[25]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair85" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[26]_i_1 
       (.I0(\win_wl_reg[27]_i_1_n_5 ),
        .I1(window_valid13_in),
        .I2(next_wl[26]),
        .O(\next_wl[26]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair85" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[27]_i_1 
       (.I0(\win_wl_reg[27]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_wl[27]),
        .O(\next_wl[27]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair86" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[28]_i_1 
       (.I0(\win_wl_reg[31]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_wl[28]),
        .O(\next_wl[28]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair86" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[29]_i_1 
       (.I0(\win_wl_reg[31]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_wl[29]),
        .O(\next_wl[29]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair73" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[2]_i_1 
       (.I0(\win_wl_reg[3]_i_1_n_5 ),
        .I1(window_valid13_in),
        .I2(next_wl[2]),
        .O(\next_wl[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair111" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[30]_i_1 
       (.I0(\win_wl_reg[31]_i_1_n_5 ),
        .I1(window_valid13_in),
        .I2(next_wl[30]),
        .O(\next_wl[30]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair111" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[31]_i_1 
       (.I0(\win_wl_reg[31]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_wl[31]),
        .O(\next_wl[31]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair110" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[32]_i_1 
       (.I0(\win_wl_reg[35]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_wl[32]),
        .O(\next_wl[32]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair110" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[33]_i_1 
       (.I0(\win_wl_reg[35]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_wl[33]),
        .O(\next_wl[33]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair109" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[34]_i_1 
       (.I0(\win_wl_reg[35]_i_1_n_5 ),
        .I1(window_valid13_in),
        .I2(next_wl[34]),
        .O(\next_wl[34]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair109" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[35]_i_1 
       (.I0(\win_wl_reg[35]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_wl[35]),
        .O(\next_wl[35]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair108" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[36]_i_1 
       (.I0(\win_wl_reg[39]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_wl[36]),
        .O(\next_wl[36]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair108" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[37]_i_1 
       (.I0(\win_wl_reg[39]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_wl[37]),
        .O(\next_wl[37]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair107" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[38]_i_1 
       (.I0(\win_wl_reg[39]_i_1_n_5 ),
        .I1(window_valid13_in),
        .I2(next_wl[38]),
        .O(\next_wl[38]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair107" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[39]_i_1 
       (.I0(\win_wl_reg[39]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_wl[39]),
        .O(\next_wl[39]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair73" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[3]_i_1 
       (.I0(\win_wl_reg[3]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_wl[3]),
        .O(\next_wl[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair74" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[4]_i_1 
       (.I0(\win_wl_reg[7]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_wl[4]),
        .O(\next_wl[4]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair74" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[5]_i_1 
       (.I0(\win_wl_reg[7]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_wl[5]),
        .O(\next_wl[5]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair75" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[6]_i_1 
       (.I0(\win_wl_reg[7]_i_1_n_5 ),
        .I1(window_valid13_in),
        .I2(next_wl[6]),
        .O(\next_wl[6]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair75" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[7]_i_1 
       (.I0(\win_wl_reg[7]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_wl[7]),
        .O(\next_wl[7]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair76" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[8]_i_1 
       (.I0(\win_wl_reg[11]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_wl[8]),
        .O(\next_wl[8]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair76" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \next_wl[9]_i_1 
       (.I0(\win_wl_reg[11]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_wl[9]),
        .O(\next_wl[9]_i_1_n_0 ));
  FDRE \next_wl_reg[0] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[0]_i_1_n_0 ),
        .Q(next_wl[0]),
        .R(1'b0));
  FDRE \next_wl_reg[10] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[10]_i_1_n_0 ),
        .Q(next_wl[10]),
        .R(1'b0));
  FDRE \next_wl_reg[11] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[11]_i_1_n_0 ),
        .Q(next_wl[11]),
        .R(1'b0));
  FDRE \next_wl_reg[12] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[12]_i_1_n_0 ),
        .Q(next_wl[12]),
        .R(1'b0));
  FDRE \next_wl_reg[13] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[13]_i_1_n_0 ),
        .Q(next_wl[13]),
        .R(1'b0));
  FDRE \next_wl_reg[14] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[14]_i_1_n_0 ),
        .Q(next_wl[14]),
        .R(1'b0));
  FDRE \next_wl_reg[15] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[15]_i_1_n_0 ),
        .Q(next_wl[15]),
        .R(1'b0));
  FDRE \next_wl_reg[16] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[16]_i_1_n_0 ),
        .Q(next_wl[16]),
        .R(1'b0));
  FDRE \next_wl_reg[17] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[17]_i_1_n_0 ),
        .Q(next_wl[17]),
        .R(1'b0));
  FDRE \next_wl_reg[18] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[18]_i_1_n_0 ),
        .Q(next_wl[18]),
        .R(1'b0));
  FDRE \next_wl_reg[19] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[19]_i_1_n_0 ),
        .Q(next_wl[19]),
        .R(1'b0));
  FDRE \next_wl_reg[1] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[1]_i_1_n_0 ),
        .Q(next_wl[1]),
        .R(1'b0));
  FDRE \next_wl_reg[20] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[20]_i_1_n_0 ),
        .Q(next_wl[20]),
        .R(1'b0));
  FDRE \next_wl_reg[21] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[21]_i_1_n_0 ),
        .Q(next_wl[21]),
        .R(1'b0));
  FDRE \next_wl_reg[22] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[22]_i_1_n_0 ),
        .Q(next_wl[22]),
        .R(1'b0));
  FDRE \next_wl_reg[23] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[23]_i_1_n_0 ),
        .Q(next_wl[23]),
        .R(1'b0));
  FDRE \next_wl_reg[24] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[24]_i_1_n_0 ),
        .Q(next_wl[24]),
        .R(1'b0));
  FDRE \next_wl_reg[25] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[25]_i_1_n_0 ),
        .Q(next_wl[25]),
        .R(1'b0));
  FDRE \next_wl_reg[26] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[26]_i_1_n_0 ),
        .Q(next_wl[26]),
        .R(1'b0));
  FDRE \next_wl_reg[27] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[27]_i_1_n_0 ),
        .Q(next_wl[27]),
        .R(1'b0));
  FDRE \next_wl_reg[28] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[28]_i_1_n_0 ),
        .Q(next_wl[28]),
        .R(1'b0));
  FDRE \next_wl_reg[29] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[29]_i_1_n_0 ),
        .Q(next_wl[29]),
        .R(1'b0));
  FDRE \next_wl_reg[2] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[2]_i_1_n_0 ),
        .Q(next_wl[2]),
        .R(1'b0));
  FDRE \next_wl_reg[30] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[30]_i_1_n_0 ),
        .Q(next_wl[30]),
        .R(1'b0));
  FDRE \next_wl_reg[31] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[31]_i_1_n_0 ),
        .Q(next_wl[31]),
        .R(1'b0));
  FDRE \next_wl_reg[32] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[32]_i_1_n_0 ),
        .Q(next_wl[32]),
        .R(1'b0));
  FDRE \next_wl_reg[33] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[33]_i_1_n_0 ),
        .Q(next_wl[33]),
        .R(1'b0));
  FDRE \next_wl_reg[34] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[34]_i_1_n_0 ),
        .Q(next_wl[34]),
        .R(1'b0));
  FDRE \next_wl_reg[35] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[35]_i_1_n_0 ),
        .Q(next_wl[35]),
        .R(1'b0));
  FDRE \next_wl_reg[36] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[36]_i_1_n_0 ),
        .Q(next_wl[36]),
        .R(1'b0));
  FDRE \next_wl_reg[37] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[37]_i_1_n_0 ),
        .Q(next_wl[37]),
        .R(1'b0));
  FDRE \next_wl_reg[38] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[38]_i_1_n_0 ),
        .Q(next_wl[38]),
        .R(1'b0));
  FDRE \next_wl_reg[39] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[39]_i_1_n_0 ),
        .Q(next_wl[39]),
        .R(1'b0));
  FDRE \next_wl_reg[3] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[3]_i_1_n_0 ),
        .Q(next_wl[3]),
        .R(1'b0));
  FDRE \next_wl_reg[4] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[4]_i_1_n_0 ),
        .Q(next_wl[4]),
        .R(1'b0));
  FDRE \next_wl_reg[5] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[5]_i_1_n_0 ),
        .Q(next_wl[5]),
        .R(1'b0));
  FDRE \next_wl_reg[6] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[6]_i_1_n_0 ),
        .Q(next_wl[6]),
        .R(1'b0));
  FDRE \next_wl_reg[7] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[7]_i_1_n_0 ),
        .Q(next_wl[7]),
        .R(1'b0));
  FDRE \next_wl_reg[8] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[8]_i_1_n_0 ),
        .Q(next_wl[8]),
        .R(1'b0));
  FDRE \next_wl_reg[9] 
       (.C(clk),
        .CE(next_zc),
        .D(\next_wl[9]_i_1_n_0 ),
        .Q(next_wl[9]),
        .R(1'b0));
  FDRE \next_zc_reg[0] 
       (.C(clk),
        .CE(next_zc),
        .D(\zc_count[0]_i_1_n_0 ),
        .Q(\next_zc_reg_n_0_[0] ),
        .R(1'b0));
  FDRE \next_zc_reg[1] 
       (.C(clk),
        .CE(next_zc),
        .D(\zc_count[1]_i_1_n_0 ),
        .Q(\next_zc_reg_n_0_[1] ),
        .R(1'b0));
  FDRE \next_zc_reg[2] 
       (.C(clk),
        .CE(next_zc),
        .D(\zc_count[2]_i_1_n_0 ),
        .Q(\next_zc_reg_n_0_[2] ),
        .R(1'b0));
  FDRE \next_zc_reg[3] 
       (.C(clk),
        .CE(next_zc),
        .D(\zc_count[3]_i_1_n_0 ),
        .Q(\next_zc_reg_n_0_[3] ),
        .R(1'b0));
  FDRE \next_zc_reg[4] 
       (.C(clk),
        .CE(next_zc),
        .D(\zc_count[4]_i_1_n_0 ),
        .Q(\next_zc_reg_n_0_[4] ),
        .R(1'b0));
  FDRE \next_zc_reg[5] 
       (.C(clk),
        .CE(next_zc),
        .D(\zc_count[5]_i_1_n_0 ),
        .Q(\next_zc_reg_n_0_[5] ),
        .R(1'b0));
  FDRE \next_zc_reg[6] 
       (.C(clk),
        .CE(next_zc),
        .D(\zc_count[6]_i_1_n_0 ),
        .Q(\next_zc_reg_n_0_[6] ),
        .R(1'b0));
  FDRE \next_zc_reg[7] 
       (.C(clk),
        .CE(next_zc),
        .D(\zc_count[7]_i_1_n_0 ),
        .Q(\next_zc_reg_n_0_[7] ),
        .R(1'b0));
  FDRE \next_zc_reg[8] 
       (.C(clk),
        .CE(next_zc),
        .D(\zc_count[8]_i_3_n_0 ),
        .Q(\next_zc_reg_n_0_[8] ),
        .R(1'b0));
  FDRE \prev2_reg[0] 
       (.C(clk),
        .CE(sample_valid),
        .D(\prev_reg_n_0_[0] ),
        .Q(prev2[0]),
        .R(clear));
  FDRE \prev2_reg[10] 
       (.C(clk),
        .CE(sample_valid),
        .D(\prev_reg_n_0_[10] ),
        .Q(prev2[10]),
        .R(clear));
  FDRE \prev2_reg[11] 
       (.C(clk),
        .CE(sample_valid),
        .D(\prev_reg_n_0_[11] ),
        .Q(prev2[11]),
        .R(clear));
  FDRE \prev2_reg[12] 
       (.C(clk),
        .CE(sample_valid),
        .D(\prev_reg_n_0_[12] ),
        .Q(prev2[12]),
        .R(clear));
  FDRE \prev2_reg[13] 
       (.C(clk),
        .CE(sample_valid),
        .D(\prev_reg_n_0_[13] ),
        .Q(prev2[13]),
        .R(clear));
  FDRE \prev2_reg[14] 
       (.C(clk),
        .CE(sample_valid),
        .D(\prev_reg_n_0_[14] ),
        .Q(prev2[14]),
        .R(clear));
  FDRE \prev2_reg[15] 
       (.C(clk),
        .CE(sample_valid),
        .D(\prev_reg_n_0_[15] ),
        .Q(prev2[15]),
        .R(clear));
  FDRE \prev2_reg[16] 
       (.C(clk),
        .CE(sample_valid),
        .D(\prev_reg_n_0_[16] ),
        .Q(prev2[16]),
        .R(clear));
  FDRE \prev2_reg[17] 
       (.C(clk),
        .CE(sample_valid),
        .D(\prev_reg_n_0_[17] ),
        .Q(prev2[17]),
        .R(clear));
  FDRE \prev2_reg[18] 
       (.C(clk),
        .CE(sample_valid),
        .D(\prev_reg_n_0_[18] ),
        .Q(prev2[18]),
        .R(clear));
  FDRE \prev2_reg[19] 
       (.C(clk),
        .CE(sample_valid),
        .D(\prev_reg_n_0_[19] ),
        .Q(prev2[19]),
        .R(clear));
  FDRE \prev2_reg[1] 
       (.C(clk),
        .CE(sample_valid),
        .D(\prev_reg_n_0_[1] ),
        .Q(prev2[1]),
        .R(clear));
  FDRE \prev2_reg[20] 
       (.C(clk),
        .CE(sample_valid),
        .D(\prev_reg_n_0_[20] ),
        .Q(prev2[20]),
        .R(clear));
  FDRE \prev2_reg[21] 
       (.C(clk),
        .CE(sample_valid),
        .D(\prev_reg_n_0_[21] ),
        .Q(prev2[21]),
        .R(clear));
  FDRE \prev2_reg[22] 
       (.C(clk),
        .CE(sample_valid),
        .D(\prev_reg_n_0_[22] ),
        .Q(prev2[22]),
        .R(clear));
  FDRE \prev2_reg[23] 
       (.C(clk),
        .CE(sample_valid),
        .D(p_0_in0_in),
        .Q(prev2[23]),
        .R(clear));
  FDRE \prev2_reg[2] 
       (.C(clk),
        .CE(sample_valid),
        .D(\prev_reg_n_0_[2] ),
        .Q(prev2[2]),
        .R(clear));
  FDRE \prev2_reg[3] 
       (.C(clk),
        .CE(sample_valid),
        .D(\prev_reg_n_0_[3] ),
        .Q(prev2[3]),
        .R(clear));
  FDRE \prev2_reg[4] 
       (.C(clk),
        .CE(sample_valid),
        .D(\prev_reg_n_0_[4] ),
        .Q(prev2[4]),
        .R(clear));
  FDRE \prev2_reg[5] 
       (.C(clk),
        .CE(sample_valid),
        .D(\prev_reg_n_0_[5] ),
        .Q(prev2[5]),
        .R(clear));
  FDRE \prev2_reg[6] 
       (.C(clk),
        .CE(sample_valid),
        .D(\prev_reg_n_0_[6] ),
        .Q(prev2[6]),
        .R(clear));
  FDRE \prev2_reg[7] 
       (.C(clk),
        .CE(sample_valid),
        .D(\prev_reg_n_0_[7] ),
        .Q(prev2[7]),
        .R(clear));
  FDRE \prev2_reg[8] 
       (.C(clk),
        .CE(sample_valid),
        .D(\prev_reg_n_0_[8] ),
        .Q(prev2[8]),
        .R(clear));
  FDRE \prev2_reg[9] 
       (.C(clk),
        .CE(sample_valid),
        .D(\prev_reg_n_0_[9] ),
        .Q(prev2[9]),
        .R(clear));
  FDRE \prev_reg[0] 
       (.C(clk),
        .CE(sample_valid),
        .D(sample_in[0]),
        .Q(\prev_reg_n_0_[0] ),
        .R(clear));
  FDRE \prev_reg[10] 
       (.C(clk),
        .CE(sample_valid),
        .D(sample_in[10]),
        .Q(\prev_reg_n_0_[10] ),
        .R(clear));
  FDRE \prev_reg[11] 
       (.C(clk),
        .CE(sample_valid),
        .D(sample_in[11]),
        .Q(\prev_reg_n_0_[11] ),
        .R(clear));
  FDRE \prev_reg[12] 
       (.C(clk),
        .CE(sample_valid),
        .D(sample_in[12]),
        .Q(\prev_reg_n_0_[12] ),
        .R(clear));
  FDRE \prev_reg[13] 
       (.C(clk),
        .CE(sample_valid),
        .D(sample_in[13]),
        .Q(\prev_reg_n_0_[13] ),
        .R(clear));
  FDRE \prev_reg[14] 
       (.C(clk),
        .CE(sample_valid),
        .D(sample_in[14]),
        .Q(\prev_reg_n_0_[14] ),
        .R(clear));
  FDRE \prev_reg[15] 
       (.C(clk),
        .CE(sample_valid),
        .D(sample_in[15]),
        .Q(\prev_reg_n_0_[15] ),
        .R(clear));
  FDRE \prev_reg[16] 
       (.C(clk),
        .CE(sample_valid),
        .D(sample_in[16]),
        .Q(\prev_reg_n_0_[16] ),
        .R(clear));
  FDRE \prev_reg[17] 
       (.C(clk),
        .CE(sample_valid),
        .D(sample_in[17]),
        .Q(\prev_reg_n_0_[17] ),
        .R(clear));
  FDRE \prev_reg[18] 
       (.C(clk),
        .CE(sample_valid),
        .D(sample_in[18]),
        .Q(\prev_reg_n_0_[18] ),
        .R(clear));
  FDRE \prev_reg[19] 
       (.C(clk),
        .CE(sample_valid),
        .D(sample_in[19]),
        .Q(\prev_reg_n_0_[19] ),
        .R(clear));
  FDRE \prev_reg[1] 
       (.C(clk),
        .CE(sample_valid),
        .D(sample_in[1]),
        .Q(\prev_reg_n_0_[1] ),
        .R(clear));
  FDRE \prev_reg[20] 
       (.C(clk),
        .CE(sample_valid),
        .D(sample_in[20]),
        .Q(\prev_reg_n_0_[20] ),
        .R(clear));
  FDRE \prev_reg[21] 
       (.C(clk),
        .CE(sample_valid),
        .D(sample_in[21]),
        .Q(\prev_reg_n_0_[21] ),
        .R(clear));
  FDRE \prev_reg[22] 
       (.C(clk),
        .CE(sample_valid),
        .D(sample_in[22]),
        .Q(\prev_reg_n_0_[22] ),
        .R(clear));
  FDRE \prev_reg[23] 
       (.C(clk),
        .CE(sample_valid),
        .D(sample_in[23]),
        .Q(p_0_in0_in),
        .R(clear));
  FDRE \prev_reg[2] 
       (.C(clk),
        .CE(sample_valid),
        .D(sample_in[2]),
        .Q(\prev_reg_n_0_[2] ),
        .R(clear));
  FDRE \prev_reg[3] 
       (.C(clk),
        .CE(sample_valid),
        .D(sample_in[3]),
        .Q(\prev_reg_n_0_[3] ),
        .R(clear));
  FDRE \prev_reg[4] 
       (.C(clk),
        .CE(sample_valid),
        .D(sample_in[4]),
        .Q(\prev_reg_n_0_[4] ),
        .R(clear));
  FDRE \prev_reg[5] 
       (.C(clk),
        .CE(sample_valid),
        .D(sample_in[5]),
        .Q(\prev_reg_n_0_[5] ),
        .R(clear));
  FDRE \prev_reg[6] 
       (.C(clk),
        .CE(sample_valid),
        .D(sample_in[6]),
        .Q(\prev_reg_n_0_[6] ),
        .R(clear));
  FDRE \prev_reg[7] 
       (.C(clk),
        .CE(sample_valid),
        .D(sample_in[7]),
        .Q(\prev_reg_n_0_[7] ),
        .R(clear));
  FDRE \prev_reg[8] 
       (.C(clk),
        .CE(sample_valid),
        .D(sample_in[8]),
        .Q(\prev_reg_n_0_[8] ),
        .R(clear));
  FDRE \prev_reg[9] 
       (.C(clk),
        .CE(sample_valid),
        .D(sample_in[9]),
        .Q(\prev_reg_n_0_[9] ),
        .R(clear));
  LUT1 #(
    .INIT(2'h1)) 
    \prime_count[0]_i_1 
       (.I0(prime_count_reg[0]),
        .O(p_0_in__0[0]));
  (* SOFT_HLUTNM = "soft_lutpair123" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \prime_count[1]_i_1 
       (.I0(prime_count_reg[0]),
        .I1(prime_count_reg[1]),
        .O(p_0_in__0[1]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \prime_count[2]_i_1 
       (.I0(prime_count_reg[0]),
        .I1(prime_count_reg[1]),
        .I2(prime_count_reg[2]),
        .O(\prime_count[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \prime_count[3]_i_1 
       (.I0(prime_count_reg[1]),
        .I1(prime_count_reg[0]),
        .I2(prime_count_reg[2]),
        .I3(prime_count_reg[3]),
        .O(p_0_in__0[3]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    \prime_count[4]_i_1 
       (.I0(prime_count_reg[2]),
        .I1(prime_count_reg[0]),
        .I2(prime_count_reg[1]),
        .I3(prime_count_reg[3]),
        .I4(prime_count_reg[4]),
        .O(p_0_in__0[4]));
  LUT6 #(
    .INIT(64'h7FFFFFFF80000000)) 
    \prime_count[5]_i_1 
       (.I0(prime_count_reg[3]),
        .I1(prime_count_reg[1]),
        .I2(prime_count_reg[0]),
        .I3(prime_count_reg[2]),
        .I4(prime_count_reg[4]),
        .I5(prime_count_reg[5]),
        .O(p_0_in__0[5]));
  LUT6 #(
    .INIT(64'hF7FFFFFF08000000)) 
    \prime_count[6]_i_1 
       (.I0(prime_count_reg[4]),
        .I1(prime_count_reg[2]),
        .I2(\prime_count[6]_i_2_n_0 ),
        .I3(prime_count_reg[3]),
        .I4(prime_count_reg[5]),
        .I5(prime_count_reg[6]),
        .O(p_0_in__0[6]));
  (* SOFT_HLUTNM = "soft_lutpair123" *) 
  LUT2 #(
    .INIT(4'h7)) 
    \prime_count[6]_i_2 
       (.I0(prime_count_reg[1]),
        .I1(prime_count_reg[0]),
        .O(\prime_count[6]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair44" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \prime_count[7]_i_1 
       (.I0(\prime_count[8]_i_3_n_0 ),
        .I1(prime_count_reg[6]),
        .I2(prime_count_reg[7]),
        .O(p_0_in__0[7]));
  LUT3 #(
    .INIT(8'h80)) 
    \prime_count[8]_i_1 
       (.I0(sample_valid),
        .I1(priming_reg_n_0),
        .I2(prime_count),
        .O(\prime_count[8]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair44" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \prime_count[8]_i_2 
       (.I0(prime_count_reg[6]),
        .I1(\prime_count[8]_i_3_n_0 ),
        .I2(prime_count_reg[7]),
        .I3(prime_count_reg[8]),
        .O(p_0_in__0[8]));
  LUT6 #(
    .INIT(64'h8000000000000000)) 
    \prime_count[8]_i_3 
       (.I0(prime_count_reg[5]),
        .I1(prime_count_reg[3]),
        .I2(prime_count_reg[1]),
        .I3(prime_count_reg[0]),
        .I4(prime_count_reg[2]),
        .I5(prime_count_reg[4]),
        .O(\prime_count[8]_i_3_n_0 ));
  FDRE \prime_count_reg[0] 
       (.C(clk),
        .CE(\prime_count[8]_i_1_n_0 ),
        .D(p_0_in__0[0]),
        .Q(prime_count_reg[0]),
        .R(clear));
  FDRE \prime_count_reg[1] 
       (.C(clk),
        .CE(\prime_count[8]_i_1_n_0 ),
        .D(p_0_in__0[1]),
        .Q(prime_count_reg[1]),
        .R(clear));
  FDRE \prime_count_reg[2] 
       (.C(clk),
        .CE(\prime_count[8]_i_1_n_0 ),
        .D(\prime_count[2]_i_1_n_0 ),
        .Q(prime_count_reg[2]),
        .R(clear));
  FDRE \prime_count_reg[3] 
       (.C(clk),
        .CE(\prime_count[8]_i_1_n_0 ),
        .D(p_0_in__0[3]),
        .Q(prime_count_reg[3]),
        .R(clear));
  FDRE \prime_count_reg[4] 
       (.C(clk),
        .CE(\prime_count[8]_i_1_n_0 ),
        .D(p_0_in__0[4]),
        .Q(prime_count_reg[4]),
        .R(clear));
  FDRE \prime_count_reg[5] 
       (.C(clk),
        .CE(\prime_count[8]_i_1_n_0 ),
        .D(p_0_in__0[5]),
        .Q(prime_count_reg[5]),
        .R(clear));
  FDRE \prime_count_reg[6] 
       (.C(clk),
        .CE(\prime_count[8]_i_1_n_0 ),
        .D(p_0_in__0[6]),
        .Q(prime_count_reg[6]),
        .R(clear));
  FDRE \prime_count_reg[7] 
       (.C(clk),
        .CE(\prime_count[8]_i_1_n_0 ),
        .D(p_0_in__0[7]),
        .Q(prime_count_reg[7]),
        .R(clear));
  FDRE \prime_count_reg[8] 
       (.C(clk),
        .CE(\prime_count[8]_i_1_n_0 ),
        .D(p_0_in__0[8]),
        .Q(prime_count_reg[8]),
        .R(clear));
  (* SOFT_HLUTNM = "soft_lutpair47" *) 
  LUT4 #(
    .INIT(16'hC4FF)) 
    priming_i_1
       (.I0(sample_valid),
        .I1(priming_reg_n_0),
        .I2(prime_count),
        .I3(rst_n),
        .O(priming_i_1_n_0));
  FDRE priming_reg
       (.C(clk),
        .CE(1'b1),
        .D(priming_i_1_n_0),
        .Q(priming_reg_n_0),
        .R(1'b0));
  LUT2 #(
    .INIT(4'h6)) 
    \ring_energy[3][11]_i_2 
       (.I0(seg_energy_reg[11]),
        .I1(seg_energy1__1[11]),
        .O(\ring_energy[3][11]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \ring_energy[3][11]_i_3 
       (.I0(seg_energy_reg[10]),
        .I1(seg_energy1__1[10]),
        .O(\ring_energy[3][11]_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \ring_energy[3][11]_i_4 
       (.I0(seg_energy_reg[9]),
        .I1(seg_energy1__1[9]),
        .O(\ring_energy[3][11]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \ring_energy[3][11]_i_5 
       (.I0(seg_energy_reg[8]),
        .I1(seg_energy1__1[8]),
        .O(\ring_energy[3][11]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \ring_energy[3][15]_i_2 
       (.I0(seg_energy_reg[15]),
        .I1(seg_energy1__1[15]),
        .O(\ring_energy[3][15]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \ring_energy[3][15]_i_3 
       (.I0(seg_energy_reg[14]),
        .I1(seg_energy1__1[14]),
        .O(\ring_energy[3][15]_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \ring_energy[3][15]_i_4 
       (.I0(seg_energy_reg[13]),
        .I1(seg_energy1__1[13]),
        .O(\ring_energy[3][15]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \ring_energy[3][15]_i_5 
       (.I0(seg_energy_reg[12]),
        .I1(seg_energy1__1[12]),
        .O(\ring_energy[3][15]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \ring_energy[3][19]_i_2 
       (.I0(seg_energy_reg[19]),
        .I1(seg_energy1__1[19]),
        .O(\ring_energy[3][19]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \ring_energy[3][19]_i_3 
       (.I0(seg_energy_reg[18]),
        .I1(seg_energy1__1[18]),
        .O(\ring_energy[3][19]_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \ring_energy[3][19]_i_4 
       (.I0(seg_energy_reg[17]),
        .I1(seg_energy1__1[17]),
        .O(\ring_energy[3][19]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \ring_energy[3][19]_i_5 
       (.I0(seg_energy_reg[16]),
        .I1(seg_energy1__1[16]),
        .O(\ring_energy[3][19]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \ring_energy[3][23]_i_2 
       (.I0(seg_energy_reg[23]),
        .I1(seg_energy1__1[23]),
        .O(\ring_energy[3][23]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \ring_energy[3][23]_i_3 
       (.I0(seg_energy_reg[22]),
        .I1(seg_energy1__1[22]),
        .O(\ring_energy[3][23]_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \ring_energy[3][23]_i_4 
       (.I0(seg_energy_reg[21]),
        .I1(seg_energy1__1[21]),
        .O(\ring_energy[3][23]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \ring_energy[3][23]_i_5 
       (.I0(seg_energy_reg[20]),
        .I1(seg_energy1__1[20]),
        .O(\ring_energy[3][23]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \ring_energy[3][27]_i_2 
       (.I0(seg_energy_reg[27]),
        .I1(seg_energy1__1[27]),
        .O(\ring_energy[3][27]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \ring_energy[3][27]_i_3 
       (.I0(seg_energy_reg[26]),
        .I1(seg_energy1__1[26]),
        .O(\ring_energy[3][27]_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \ring_energy[3][27]_i_4 
       (.I0(seg_energy_reg[25]),
        .I1(seg_energy1__1[25]),
        .O(\ring_energy[3][27]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \ring_energy[3][27]_i_5 
       (.I0(seg_energy_reg[24]),
        .I1(seg_energy1__1[24]),
        .O(\ring_energy[3][27]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \ring_energy[3][31]_i_2 
       (.I0(seg_energy1__1[31]),
        .I1(seg_energy_reg[31]),
        .O(\ring_energy[3][31]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \ring_energy[3][31]_i_3 
       (.I0(seg_energy_reg[30]),
        .I1(seg_energy1__1[30]),
        .O(\ring_energy[3][31]_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \ring_energy[3][31]_i_4 
       (.I0(seg_energy_reg[29]),
        .I1(seg_energy1__1[29]),
        .O(\ring_energy[3][31]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \ring_energy[3][31]_i_5 
       (.I0(seg_energy_reg[28]),
        .I1(seg_energy1__1[28]),
        .O(\ring_energy[3][31]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \ring_energy[3][3]_i_2 
       (.I0(seg_energy_reg[3]),
        .I1(seg_energy1__1[3]),
        .O(\ring_energy[3][3]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \ring_energy[3][3]_i_3 
       (.I0(seg_energy_reg[2]),
        .I1(seg_energy1__1[2]),
        .O(\ring_energy[3][3]_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \ring_energy[3][3]_i_4 
       (.I0(seg_energy_reg[1]),
        .I1(seg_energy1__1[1]),
        .O(\ring_energy[3][3]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \ring_energy[3][3]_i_5 
       (.I0(seg_energy_reg[0]),
        .I1(seg_energy1__1[0]),
        .O(\ring_energy[3][3]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \ring_energy[3][7]_i_2 
       (.I0(seg_energy_reg[7]),
        .I1(seg_energy1__1[7]),
        .O(\ring_energy[3][7]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \ring_energy[3][7]_i_3 
       (.I0(seg_energy_reg[6]),
        .I1(seg_energy1__1[6]),
        .O(\ring_energy[3][7]_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \ring_energy[3][7]_i_4 
       (.I0(seg_energy_reg[5]),
        .I1(seg_energy1__1[5]),
        .O(\ring_energy[3][7]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \ring_energy[3][7]_i_5 
       (.I0(seg_energy_reg[4]),
        .I1(seg_energy1__1[4]),
        .O(\ring_energy[3][7]_i_5_n_0 ));
  FDRE \ring_energy_reg[0][0] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_energy_reg[3][3]_i_1_n_7 ),
        .Q(\ring_energy_reg[0] [0]),
        .R(clear));
  FDRE \ring_energy_reg[0][10] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_energy_reg[3][11]_i_1_n_5 ),
        .Q(\ring_energy_reg[0] [10]),
        .R(clear));
  FDRE \ring_energy_reg[0][11] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_energy_reg[3][11]_i_1_n_4 ),
        .Q(\ring_energy_reg[0] [11]),
        .R(clear));
  FDRE \ring_energy_reg[0][12] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_energy_reg[3][15]_i_1_n_7 ),
        .Q(\ring_energy_reg[0] [12]),
        .R(clear));
  FDRE \ring_energy_reg[0][13] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_energy_reg[3][15]_i_1_n_6 ),
        .Q(\ring_energy_reg[0] [13]),
        .R(clear));
  FDRE \ring_energy_reg[0][14] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_energy_reg[3][15]_i_1_n_5 ),
        .Q(\ring_energy_reg[0] [14]),
        .R(clear));
  FDRE \ring_energy_reg[0][15] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_energy_reg[3][15]_i_1_n_4 ),
        .Q(\ring_energy_reg[0] [15]),
        .R(clear));
  FDRE \ring_energy_reg[0][16] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_energy_reg[3][19]_i_1_n_7 ),
        .Q(\ring_energy_reg[0] [16]),
        .R(clear));
  FDRE \ring_energy_reg[0][17] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_energy_reg[3][19]_i_1_n_6 ),
        .Q(\ring_energy_reg[0] [17]),
        .R(clear));
  FDRE \ring_energy_reg[0][18] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_energy_reg[3][19]_i_1_n_5 ),
        .Q(\ring_energy_reg[0] [18]),
        .R(clear));
  FDRE \ring_energy_reg[0][19] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_energy_reg[3][19]_i_1_n_4 ),
        .Q(\ring_energy_reg[0] [19]),
        .R(clear));
  FDRE \ring_energy_reg[0][1] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_energy_reg[3][3]_i_1_n_6 ),
        .Q(\ring_energy_reg[0] [1]),
        .R(clear));
  FDRE \ring_energy_reg[0][20] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_energy_reg[3][23]_i_1_n_7 ),
        .Q(\ring_energy_reg[0] [20]),
        .R(clear));
  FDRE \ring_energy_reg[0][21] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_energy_reg[3][23]_i_1_n_6 ),
        .Q(\ring_energy_reg[0] [21]),
        .R(clear));
  FDRE \ring_energy_reg[0][22] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_energy_reg[3][23]_i_1_n_5 ),
        .Q(\ring_energy_reg[0] [22]),
        .R(clear));
  FDRE \ring_energy_reg[0][23] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_energy_reg[3][23]_i_1_n_4 ),
        .Q(\ring_energy_reg[0] [23]),
        .R(clear));
  FDRE \ring_energy_reg[0][24] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_energy_reg[3][27]_i_1_n_7 ),
        .Q(\ring_energy_reg[0] [24]),
        .R(clear));
  FDRE \ring_energy_reg[0][25] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_energy_reg[3][27]_i_1_n_6 ),
        .Q(\ring_energy_reg[0] [25]),
        .R(clear));
  FDRE \ring_energy_reg[0][26] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_energy_reg[3][27]_i_1_n_5 ),
        .Q(\ring_energy_reg[0] [26]),
        .R(clear));
  FDRE \ring_energy_reg[0][27] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_energy_reg[3][27]_i_1_n_4 ),
        .Q(\ring_energy_reg[0] [27]),
        .R(clear));
  FDRE \ring_energy_reg[0][28] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_energy_reg[3][31]_i_1_n_7 ),
        .Q(\ring_energy_reg[0] [28]),
        .R(clear));
  FDRE \ring_energy_reg[0][29] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_energy_reg[3][31]_i_1_n_6 ),
        .Q(\ring_energy_reg[0] [29]),
        .R(clear));
  FDRE \ring_energy_reg[0][2] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_energy_reg[3][3]_i_1_n_5 ),
        .Q(\ring_energy_reg[0] [2]),
        .R(clear));
  FDRE \ring_energy_reg[0][30] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_energy_reg[3][31]_i_1_n_5 ),
        .Q(\ring_energy_reg[0] [30]),
        .R(clear));
  FDRE \ring_energy_reg[0][31] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_energy_reg[3][31]_i_1_n_4 ),
        .Q(\ring_energy_reg[0] [31]),
        .R(clear));
  FDRE \ring_energy_reg[0][3] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_energy_reg[3][3]_i_1_n_4 ),
        .Q(\ring_energy_reg[0] [3]),
        .R(clear));
  FDRE \ring_energy_reg[0][4] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_energy_reg[3][7]_i_1_n_7 ),
        .Q(\ring_energy_reg[0] [4]),
        .R(clear));
  FDRE \ring_energy_reg[0][5] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_energy_reg[3][7]_i_1_n_6 ),
        .Q(\ring_energy_reg[0] [5]),
        .R(clear));
  FDRE \ring_energy_reg[0][6] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_energy_reg[3][7]_i_1_n_5 ),
        .Q(\ring_energy_reg[0] [6]),
        .R(clear));
  FDRE \ring_energy_reg[0][7] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_energy_reg[3][7]_i_1_n_4 ),
        .Q(\ring_energy_reg[0] [7]),
        .R(clear));
  FDRE \ring_energy_reg[0][8] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_energy_reg[3][11]_i_1_n_7 ),
        .Q(\ring_energy_reg[0] [8]),
        .R(clear));
  FDRE \ring_energy_reg[0][9] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_energy_reg[3][11]_i_1_n_6 ),
        .Q(\ring_energy_reg[0] [9]),
        .R(clear));
  FDRE \ring_energy_reg[1][0] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][3]_i_1_n_7 ),
        .Q(\ring_energy_reg[1] [0]),
        .R(clear));
  FDRE \ring_energy_reg[1][10] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][11]_i_1_n_5 ),
        .Q(\ring_energy_reg[1] [10]),
        .R(clear));
  FDRE \ring_energy_reg[1][11] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][11]_i_1_n_4 ),
        .Q(\ring_energy_reg[1] [11]),
        .R(clear));
  FDRE \ring_energy_reg[1][12] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][15]_i_1_n_7 ),
        .Q(\ring_energy_reg[1] [12]),
        .R(clear));
  FDRE \ring_energy_reg[1][13] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][15]_i_1_n_6 ),
        .Q(\ring_energy_reg[1] [13]),
        .R(clear));
  FDRE \ring_energy_reg[1][14] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][15]_i_1_n_5 ),
        .Q(\ring_energy_reg[1] [14]),
        .R(clear));
  FDRE \ring_energy_reg[1][15] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][15]_i_1_n_4 ),
        .Q(\ring_energy_reg[1] [15]),
        .R(clear));
  FDRE \ring_energy_reg[1][16] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][19]_i_1_n_7 ),
        .Q(\ring_energy_reg[1] [16]),
        .R(clear));
  FDRE \ring_energy_reg[1][17] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][19]_i_1_n_6 ),
        .Q(\ring_energy_reg[1] [17]),
        .R(clear));
  FDRE \ring_energy_reg[1][18] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][19]_i_1_n_5 ),
        .Q(\ring_energy_reg[1] [18]),
        .R(clear));
  FDRE \ring_energy_reg[1][19] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][19]_i_1_n_4 ),
        .Q(\ring_energy_reg[1] [19]),
        .R(clear));
  FDRE \ring_energy_reg[1][1] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][3]_i_1_n_6 ),
        .Q(\ring_energy_reg[1] [1]),
        .R(clear));
  FDRE \ring_energy_reg[1][20] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][23]_i_1_n_7 ),
        .Q(\ring_energy_reg[1] [20]),
        .R(clear));
  FDRE \ring_energy_reg[1][21] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][23]_i_1_n_6 ),
        .Q(\ring_energy_reg[1] [21]),
        .R(clear));
  FDRE \ring_energy_reg[1][22] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][23]_i_1_n_5 ),
        .Q(\ring_energy_reg[1] [22]),
        .R(clear));
  FDRE \ring_energy_reg[1][23] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][23]_i_1_n_4 ),
        .Q(\ring_energy_reg[1] [23]),
        .R(clear));
  FDRE \ring_energy_reg[1][24] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][27]_i_1_n_7 ),
        .Q(\ring_energy_reg[1] [24]),
        .R(clear));
  FDRE \ring_energy_reg[1][25] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][27]_i_1_n_6 ),
        .Q(\ring_energy_reg[1] [25]),
        .R(clear));
  FDRE \ring_energy_reg[1][26] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][27]_i_1_n_5 ),
        .Q(\ring_energy_reg[1] [26]),
        .R(clear));
  FDRE \ring_energy_reg[1][27] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][27]_i_1_n_4 ),
        .Q(\ring_energy_reg[1] [27]),
        .R(clear));
  FDRE \ring_energy_reg[1][28] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][31]_i_1_n_7 ),
        .Q(\ring_energy_reg[1] [28]),
        .R(clear));
  FDRE \ring_energy_reg[1][29] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][31]_i_1_n_6 ),
        .Q(\ring_energy_reg[1] [29]),
        .R(clear));
  FDRE \ring_energy_reg[1][2] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][3]_i_1_n_5 ),
        .Q(\ring_energy_reg[1] [2]),
        .R(clear));
  FDRE \ring_energy_reg[1][30] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][31]_i_1_n_5 ),
        .Q(\ring_energy_reg[1] [30]),
        .R(clear));
  FDRE \ring_energy_reg[1][31] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][31]_i_1_n_4 ),
        .Q(\ring_energy_reg[1] [31]),
        .R(clear));
  FDRE \ring_energy_reg[1][3] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][3]_i_1_n_4 ),
        .Q(\ring_energy_reg[1] [3]),
        .R(clear));
  FDRE \ring_energy_reg[1][4] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][7]_i_1_n_7 ),
        .Q(\ring_energy_reg[1] [4]),
        .R(clear));
  FDRE \ring_energy_reg[1][5] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][7]_i_1_n_6 ),
        .Q(\ring_energy_reg[1] [5]),
        .R(clear));
  FDRE \ring_energy_reg[1][6] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][7]_i_1_n_5 ),
        .Q(\ring_energy_reg[1] [6]),
        .R(clear));
  FDRE \ring_energy_reg[1][7] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][7]_i_1_n_4 ),
        .Q(\ring_energy_reg[1] [7]),
        .R(clear));
  FDRE \ring_energy_reg[1][8] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][11]_i_1_n_7 ),
        .Q(\ring_energy_reg[1] [8]),
        .R(clear));
  FDRE \ring_energy_reg[1][9] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][11]_i_1_n_6 ),
        .Q(\ring_energy_reg[1] [9]),
        .R(clear));
  FDRE \ring_energy_reg[2][0] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][3]_i_1_n_7 ),
        .Q(\ring_energy_reg[2] [0]),
        .R(clear));
  FDRE \ring_energy_reg[2][10] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][11]_i_1_n_5 ),
        .Q(\ring_energy_reg[2] [10]),
        .R(clear));
  FDRE \ring_energy_reg[2][11] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][11]_i_1_n_4 ),
        .Q(\ring_energy_reg[2] [11]),
        .R(clear));
  FDRE \ring_energy_reg[2][12] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][15]_i_1_n_7 ),
        .Q(\ring_energy_reg[2] [12]),
        .R(clear));
  FDRE \ring_energy_reg[2][13] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][15]_i_1_n_6 ),
        .Q(\ring_energy_reg[2] [13]),
        .R(clear));
  FDRE \ring_energy_reg[2][14] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][15]_i_1_n_5 ),
        .Q(\ring_energy_reg[2] [14]),
        .R(clear));
  FDRE \ring_energy_reg[2][15] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][15]_i_1_n_4 ),
        .Q(\ring_energy_reg[2] [15]),
        .R(clear));
  FDRE \ring_energy_reg[2][16] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][19]_i_1_n_7 ),
        .Q(\ring_energy_reg[2] [16]),
        .R(clear));
  FDRE \ring_energy_reg[2][17] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][19]_i_1_n_6 ),
        .Q(\ring_energy_reg[2] [17]),
        .R(clear));
  FDRE \ring_energy_reg[2][18] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][19]_i_1_n_5 ),
        .Q(\ring_energy_reg[2] [18]),
        .R(clear));
  FDRE \ring_energy_reg[2][19] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][19]_i_1_n_4 ),
        .Q(\ring_energy_reg[2] [19]),
        .R(clear));
  FDRE \ring_energy_reg[2][1] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][3]_i_1_n_6 ),
        .Q(\ring_energy_reg[2] [1]),
        .R(clear));
  FDRE \ring_energy_reg[2][20] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][23]_i_1_n_7 ),
        .Q(\ring_energy_reg[2] [20]),
        .R(clear));
  FDRE \ring_energy_reg[2][21] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][23]_i_1_n_6 ),
        .Q(\ring_energy_reg[2] [21]),
        .R(clear));
  FDRE \ring_energy_reg[2][22] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][23]_i_1_n_5 ),
        .Q(\ring_energy_reg[2] [22]),
        .R(clear));
  FDRE \ring_energy_reg[2][23] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][23]_i_1_n_4 ),
        .Q(\ring_energy_reg[2] [23]),
        .R(clear));
  FDRE \ring_energy_reg[2][24] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][27]_i_1_n_7 ),
        .Q(\ring_energy_reg[2] [24]),
        .R(clear));
  FDRE \ring_energy_reg[2][25] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][27]_i_1_n_6 ),
        .Q(\ring_energy_reg[2] [25]),
        .R(clear));
  FDRE \ring_energy_reg[2][26] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][27]_i_1_n_5 ),
        .Q(\ring_energy_reg[2] [26]),
        .R(clear));
  FDRE \ring_energy_reg[2][27] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][27]_i_1_n_4 ),
        .Q(\ring_energy_reg[2] [27]),
        .R(clear));
  FDRE \ring_energy_reg[2][28] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][31]_i_1_n_7 ),
        .Q(\ring_energy_reg[2] [28]),
        .R(clear));
  FDRE \ring_energy_reg[2][29] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][31]_i_1_n_6 ),
        .Q(\ring_energy_reg[2] [29]),
        .R(clear));
  FDRE \ring_energy_reg[2][2] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][3]_i_1_n_5 ),
        .Q(\ring_energy_reg[2] [2]),
        .R(clear));
  FDRE \ring_energy_reg[2][30] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][31]_i_1_n_5 ),
        .Q(\ring_energy_reg[2] [30]),
        .R(clear));
  FDRE \ring_energy_reg[2][31] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][31]_i_1_n_4 ),
        .Q(\ring_energy_reg[2] [31]),
        .R(clear));
  FDRE \ring_energy_reg[2][3] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][3]_i_1_n_4 ),
        .Q(\ring_energy_reg[2] [3]),
        .R(clear));
  FDRE \ring_energy_reg[2][4] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][7]_i_1_n_7 ),
        .Q(\ring_energy_reg[2] [4]),
        .R(clear));
  FDRE \ring_energy_reg[2][5] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][7]_i_1_n_6 ),
        .Q(\ring_energy_reg[2] [5]),
        .R(clear));
  FDRE \ring_energy_reg[2][6] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][7]_i_1_n_5 ),
        .Q(\ring_energy_reg[2] [6]),
        .R(clear));
  FDRE \ring_energy_reg[2][7] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][7]_i_1_n_4 ),
        .Q(\ring_energy_reg[2] [7]),
        .R(clear));
  FDRE \ring_energy_reg[2][8] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][11]_i_1_n_7 ),
        .Q(\ring_energy_reg[2] [8]),
        .R(clear));
  FDRE \ring_energy_reg[2][9] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][11]_i_1_n_6 ),
        .Q(\ring_energy_reg[2] [9]),
        .R(clear));
  FDRE \ring_energy_reg[3][0] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][3]_i_1_n_7 ),
        .Q(\ring_energy_reg[3] [0]),
        .R(clear));
  FDRE \ring_energy_reg[3][10] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][11]_i_1_n_5 ),
        .Q(\ring_energy_reg[3] [10]),
        .R(clear));
  FDRE \ring_energy_reg[3][11] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][11]_i_1_n_4 ),
        .Q(\ring_energy_reg[3] [11]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ring_energy_reg[3][11]_i_1 
       (.CI(\ring_energy_reg[3][7]_i_1_n_0 ),
        .CO({\ring_energy_reg[3][11]_i_1_n_0 ,\ring_energy_reg[3][11]_i_1_n_1 ,\ring_energy_reg[3][11]_i_1_n_2 ,\ring_energy_reg[3][11]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(seg_energy_reg[11:8]),
        .O({\ring_energy_reg[3][11]_i_1_n_4 ,\ring_energy_reg[3][11]_i_1_n_5 ,\ring_energy_reg[3][11]_i_1_n_6 ,\ring_energy_reg[3][11]_i_1_n_7 }),
        .S({\ring_energy[3][11]_i_2_n_0 ,\ring_energy[3][11]_i_3_n_0 ,\ring_energy[3][11]_i_4_n_0 ,\ring_energy[3][11]_i_5_n_0 }));
  FDRE \ring_energy_reg[3][12] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][15]_i_1_n_7 ),
        .Q(\ring_energy_reg[3] [12]),
        .R(clear));
  FDRE \ring_energy_reg[3][13] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][15]_i_1_n_6 ),
        .Q(\ring_energy_reg[3] [13]),
        .R(clear));
  FDRE \ring_energy_reg[3][14] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][15]_i_1_n_5 ),
        .Q(\ring_energy_reg[3] [14]),
        .R(clear));
  FDRE \ring_energy_reg[3][15] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][15]_i_1_n_4 ),
        .Q(\ring_energy_reg[3] [15]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ring_energy_reg[3][15]_i_1 
       (.CI(\ring_energy_reg[3][11]_i_1_n_0 ),
        .CO({\ring_energy_reg[3][15]_i_1_n_0 ,\ring_energy_reg[3][15]_i_1_n_1 ,\ring_energy_reg[3][15]_i_1_n_2 ,\ring_energy_reg[3][15]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(seg_energy_reg[15:12]),
        .O({\ring_energy_reg[3][15]_i_1_n_4 ,\ring_energy_reg[3][15]_i_1_n_5 ,\ring_energy_reg[3][15]_i_1_n_6 ,\ring_energy_reg[3][15]_i_1_n_7 }),
        .S({\ring_energy[3][15]_i_2_n_0 ,\ring_energy[3][15]_i_3_n_0 ,\ring_energy[3][15]_i_4_n_0 ,\ring_energy[3][15]_i_5_n_0 }));
  FDRE \ring_energy_reg[3][16] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][19]_i_1_n_7 ),
        .Q(\ring_energy_reg[3] [16]),
        .R(clear));
  FDRE \ring_energy_reg[3][17] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][19]_i_1_n_6 ),
        .Q(\ring_energy_reg[3] [17]),
        .R(clear));
  FDRE \ring_energy_reg[3][18] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][19]_i_1_n_5 ),
        .Q(\ring_energy_reg[3] [18]),
        .R(clear));
  FDRE \ring_energy_reg[3][19] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][19]_i_1_n_4 ),
        .Q(\ring_energy_reg[3] [19]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ring_energy_reg[3][19]_i_1 
       (.CI(\ring_energy_reg[3][15]_i_1_n_0 ),
        .CO({\ring_energy_reg[3][19]_i_1_n_0 ,\ring_energy_reg[3][19]_i_1_n_1 ,\ring_energy_reg[3][19]_i_1_n_2 ,\ring_energy_reg[3][19]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(seg_energy_reg[19:16]),
        .O({\ring_energy_reg[3][19]_i_1_n_4 ,\ring_energy_reg[3][19]_i_1_n_5 ,\ring_energy_reg[3][19]_i_1_n_6 ,\ring_energy_reg[3][19]_i_1_n_7 }),
        .S({\ring_energy[3][19]_i_2_n_0 ,\ring_energy[3][19]_i_3_n_0 ,\ring_energy[3][19]_i_4_n_0 ,\ring_energy[3][19]_i_5_n_0 }));
  FDRE \ring_energy_reg[3][1] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][3]_i_1_n_6 ),
        .Q(\ring_energy_reg[3] [1]),
        .R(clear));
  FDRE \ring_energy_reg[3][20] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][23]_i_1_n_7 ),
        .Q(\ring_energy_reg[3] [20]),
        .R(clear));
  FDRE \ring_energy_reg[3][21] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][23]_i_1_n_6 ),
        .Q(\ring_energy_reg[3] [21]),
        .R(clear));
  FDRE \ring_energy_reg[3][22] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][23]_i_1_n_5 ),
        .Q(\ring_energy_reg[3] [22]),
        .R(clear));
  FDRE \ring_energy_reg[3][23] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][23]_i_1_n_4 ),
        .Q(\ring_energy_reg[3] [23]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ring_energy_reg[3][23]_i_1 
       (.CI(\ring_energy_reg[3][19]_i_1_n_0 ),
        .CO({\ring_energy_reg[3][23]_i_1_n_0 ,\ring_energy_reg[3][23]_i_1_n_1 ,\ring_energy_reg[3][23]_i_1_n_2 ,\ring_energy_reg[3][23]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(seg_energy_reg[23:20]),
        .O({\ring_energy_reg[3][23]_i_1_n_4 ,\ring_energy_reg[3][23]_i_1_n_5 ,\ring_energy_reg[3][23]_i_1_n_6 ,\ring_energy_reg[3][23]_i_1_n_7 }),
        .S({\ring_energy[3][23]_i_2_n_0 ,\ring_energy[3][23]_i_3_n_0 ,\ring_energy[3][23]_i_4_n_0 ,\ring_energy[3][23]_i_5_n_0 }));
  FDRE \ring_energy_reg[3][24] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][27]_i_1_n_7 ),
        .Q(\ring_energy_reg[3] [24]),
        .R(clear));
  FDRE \ring_energy_reg[3][25] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][27]_i_1_n_6 ),
        .Q(\ring_energy_reg[3] [25]),
        .R(clear));
  FDRE \ring_energy_reg[3][26] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][27]_i_1_n_5 ),
        .Q(\ring_energy_reg[3] [26]),
        .R(clear));
  FDRE \ring_energy_reg[3][27] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][27]_i_1_n_4 ),
        .Q(\ring_energy_reg[3] [27]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ring_energy_reg[3][27]_i_1 
       (.CI(\ring_energy_reg[3][23]_i_1_n_0 ),
        .CO({\ring_energy_reg[3][27]_i_1_n_0 ,\ring_energy_reg[3][27]_i_1_n_1 ,\ring_energy_reg[3][27]_i_1_n_2 ,\ring_energy_reg[3][27]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(seg_energy_reg[27:24]),
        .O({\ring_energy_reg[3][27]_i_1_n_4 ,\ring_energy_reg[3][27]_i_1_n_5 ,\ring_energy_reg[3][27]_i_1_n_6 ,\ring_energy_reg[3][27]_i_1_n_7 }),
        .S({\ring_energy[3][27]_i_2_n_0 ,\ring_energy[3][27]_i_3_n_0 ,\ring_energy[3][27]_i_4_n_0 ,\ring_energy[3][27]_i_5_n_0 }));
  FDRE \ring_energy_reg[3][28] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][31]_i_1_n_7 ),
        .Q(\ring_energy_reg[3] [28]),
        .R(clear));
  FDRE \ring_energy_reg[3][29] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][31]_i_1_n_6 ),
        .Q(\ring_energy_reg[3] [29]),
        .R(clear));
  FDRE \ring_energy_reg[3][2] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][3]_i_1_n_5 ),
        .Q(\ring_energy_reg[3] [2]),
        .R(clear));
  FDRE \ring_energy_reg[3][30] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][31]_i_1_n_5 ),
        .Q(\ring_energy_reg[3] [30]),
        .R(clear));
  FDRE \ring_energy_reg[3][31] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][31]_i_1_n_4 ),
        .Q(\ring_energy_reg[3] [31]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ring_energy_reg[3][31]_i_1 
       (.CI(\ring_energy_reg[3][27]_i_1_n_0 ),
        .CO({\NLW_ring_energy_reg[3][31]_i_1_CO_UNCONNECTED [3],\ring_energy_reg[3][31]_i_1_n_1 ,\ring_energy_reg[3][31]_i_1_n_2 ,\ring_energy_reg[3][31]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,seg_energy_reg[30:28]}),
        .O({\ring_energy_reg[3][31]_i_1_n_4 ,\ring_energy_reg[3][31]_i_1_n_5 ,\ring_energy_reg[3][31]_i_1_n_6 ,\ring_energy_reg[3][31]_i_1_n_7 }),
        .S({\ring_energy[3][31]_i_2_n_0 ,\ring_energy[3][31]_i_3_n_0 ,\ring_energy[3][31]_i_4_n_0 ,\ring_energy[3][31]_i_5_n_0 }));
  FDRE \ring_energy_reg[3][3] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][3]_i_1_n_4 ),
        .Q(\ring_energy_reg[3] [3]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ring_energy_reg[3][3]_i_1 
       (.CI(1'b0),
        .CO({\ring_energy_reg[3][3]_i_1_n_0 ,\ring_energy_reg[3][3]_i_1_n_1 ,\ring_energy_reg[3][3]_i_1_n_2 ,\ring_energy_reg[3][3]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(seg_energy_reg[3:0]),
        .O({\ring_energy_reg[3][3]_i_1_n_4 ,\ring_energy_reg[3][3]_i_1_n_5 ,\ring_energy_reg[3][3]_i_1_n_6 ,\ring_energy_reg[3][3]_i_1_n_7 }),
        .S({\ring_energy[3][3]_i_2_n_0 ,\ring_energy[3][3]_i_3_n_0 ,\ring_energy[3][3]_i_4_n_0 ,\ring_energy[3][3]_i_5_n_0 }));
  FDRE \ring_energy_reg[3][4] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][7]_i_1_n_7 ),
        .Q(\ring_energy_reg[3] [4]),
        .R(clear));
  FDRE \ring_energy_reg[3][5] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][7]_i_1_n_6 ),
        .Q(\ring_energy_reg[3] [5]),
        .R(clear));
  FDRE \ring_energy_reg[3][6] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][7]_i_1_n_5 ),
        .Q(\ring_energy_reg[3] [6]),
        .R(clear));
  FDRE \ring_energy_reg[3][7] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][7]_i_1_n_4 ),
        .Q(\ring_energy_reg[3] [7]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ring_energy_reg[3][7]_i_1 
       (.CI(\ring_energy_reg[3][3]_i_1_n_0 ),
        .CO({\ring_energy_reg[3][7]_i_1_n_0 ,\ring_energy_reg[3][7]_i_1_n_1 ,\ring_energy_reg[3][7]_i_1_n_2 ,\ring_energy_reg[3][7]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(seg_energy_reg[7:4]),
        .O({\ring_energy_reg[3][7]_i_1_n_4 ,\ring_energy_reg[3][7]_i_1_n_5 ,\ring_energy_reg[3][7]_i_1_n_6 ,\ring_energy_reg[3][7]_i_1_n_7 }),
        .S({\ring_energy[3][7]_i_2_n_0 ,\ring_energy[3][7]_i_3_n_0 ,\ring_energy[3][7]_i_4_n_0 ,\ring_energy[3][7]_i_5_n_0 }));
  FDRE \ring_energy_reg[3][8] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][11]_i_1_n_7 ),
        .Q(\ring_energy_reg[3] [8]),
        .R(clear));
  FDRE \ring_energy_reg[3][9] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_energy_reg[3][11]_i_1_n_6 ),
        .Q(\ring_energy_reg[3] [9]),
        .R(clear));
  LUT4 #(
    .INIT(16'h0008)) 
    \ring_mav[0][31]_i_1 
       (.I0(sample_valid),
        .I1(window_valid13_in),
        .I2(wr_ptr[1]),
        .I3(wr_ptr[0]),
        .O(ring_mav));
  LUT4 #(
    .INIT(16'h0800)) 
    \ring_mav[1][31]_i_1 
       (.I0(sample_valid),
        .I1(window_valid13_in),
        .I2(wr_ptr[1]),
        .I3(wr_ptr[0]),
        .O(\ring_mav[1][31]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h0800)) 
    \ring_mav[2][31]_i_1 
       (.I0(sample_valid),
        .I1(window_valid13_in),
        .I2(wr_ptr[0]),
        .I3(wr_ptr[1]),
        .O(\ring_mav[2][31]_i_1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_mav[3][11]_i_10 
       (.I0(sample_in[5]),
        .O(\ring_mav[3][11]_i_10_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \ring_mav[3][11]_i_2 
       (.I0(seg_mav_reg[11]),
        .I1(sample_in[11]),
        .I2(sample_in[23]),
        .I3(seg_mav2[11]),
        .O(\ring_mav[3][11]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \ring_mav[3][11]_i_3 
       (.I0(seg_mav_reg[10]),
        .I1(sample_in[10]),
        .I2(sample_in[23]),
        .I3(seg_mav2[10]),
        .O(\ring_mav[3][11]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \ring_mav[3][11]_i_4 
       (.I0(seg_mav_reg[9]),
        .I1(sample_in[9]),
        .I2(sample_in[23]),
        .I3(seg_mav2[9]),
        .O(\ring_mav[3][11]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \ring_mav[3][11]_i_5 
       (.I0(seg_mav_reg[8]),
        .I1(sample_in[8]),
        .I2(sample_in[23]),
        .I3(seg_mav2[8]),
        .O(\ring_mav[3][11]_i_5_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_mav[3][11]_i_7 
       (.I0(sample_in[8]),
        .O(\ring_mav[3][11]_i_7_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_mav[3][11]_i_8 
       (.I0(sample_in[7]),
        .O(\ring_mav[3][11]_i_8_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_mav[3][11]_i_9 
       (.I0(sample_in[6]),
        .O(\ring_mav[3][11]_i_9_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_mav[3][15]_i_10 
       (.I0(sample_in[9]),
        .O(\ring_mav[3][15]_i_10_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \ring_mav[3][15]_i_2 
       (.I0(seg_mav_reg[15]),
        .I1(sample_in[15]),
        .I2(sample_in[23]),
        .I3(seg_mav2[15]),
        .O(\ring_mav[3][15]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \ring_mav[3][15]_i_3 
       (.I0(seg_mav_reg[14]),
        .I1(sample_in[14]),
        .I2(sample_in[23]),
        .I3(seg_mav2[14]),
        .O(\ring_mav[3][15]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \ring_mav[3][15]_i_4 
       (.I0(seg_mav_reg[13]),
        .I1(sample_in[13]),
        .I2(sample_in[23]),
        .I3(seg_mav2[13]),
        .O(\ring_mav[3][15]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \ring_mav[3][15]_i_5 
       (.I0(seg_mav_reg[12]),
        .I1(sample_in[12]),
        .I2(sample_in[23]),
        .I3(seg_mav2[12]),
        .O(\ring_mav[3][15]_i_5_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_mav[3][15]_i_7 
       (.I0(sample_in[12]),
        .O(\ring_mav[3][15]_i_7_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_mav[3][15]_i_8 
       (.I0(sample_in[11]),
        .O(\ring_mav[3][15]_i_8_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_mav[3][15]_i_9 
       (.I0(sample_in[10]),
        .O(\ring_mav[3][15]_i_9_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_mav[3][19]_i_10 
       (.I0(sample_in[13]),
        .O(\ring_mav[3][19]_i_10_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \ring_mav[3][19]_i_2 
       (.I0(seg_mav_reg[19]),
        .I1(sample_in[19]),
        .I2(sample_in[23]),
        .I3(seg_mav2[19]),
        .O(\ring_mav[3][19]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \ring_mav[3][19]_i_3 
       (.I0(seg_mav_reg[18]),
        .I1(sample_in[18]),
        .I2(sample_in[23]),
        .I3(seg_mav2[18]),
        .O(\ring_mav[3][19]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \ring_mav[3][19]_i_4 
       (.I0(seg_mav_reg[17]),
        .I1(sample_in[17]),
        .I2(sample_in[23]),
        .I3(seg_mav2[17]),
        .O(\ring_mav[3][19]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \ring_mav[3][19]_i_5 
       (.I0(seg_mav_reg[16]),
        .I1(sample_in[16]),
        .I2(sample_in[23]),
        .I3(seg_mav2[16]),
        .O(\ring_mav[3][19]_i_5_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_mav[3][19]_i_7 
       (.I0(sample_in[16]),
        .O(\ring_mav[3][19]_i_7_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_mav[3][19]_i_8 
       (.I0(sample_in[15]),
        .O(\ring_mav[3][19]_i_8_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_mav[3][19]_i_9 
       (.I0(sample_in[14]),
        .O(\ring_mav[3][19]_i_9_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_mav[3][23]_i_10 
       (.I0(sample_in[17]),
        .O(\ring_mav[3][23]_i_10_n_0 ));
  LUT3 #(
    .INIT(8'h6A)) 
    \ring_mav[3][23]_i_2 
       (.I0(seg_mav_reg[23]),
        .I1(seg_mav2[23]),
        .I2(sample_in[23]),
        .O(\ring_mav[3][23]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \ring_mav[3][23]_i_3 
       (.I0(seg_mav_reg[22]),
        .I1(sample_in[22]),
        .I2(sample_in[23]),
        .I3(seg_mav2[22]),
        .O(\ring_mav[3][23]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \ring_mav[3][23]_i_4 
       (.I0(seg_mav_reg[21]),
        .I1(sample_in[21]),
        .I2(sample_in[23]),
        .I3(seg_mav2[21]),
        .O(\ring_mav[3][23]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \ring_mav[3][23]_i_5 
       (.I0(seg_mav_reg[20]),
        .I1(sample_in[20]),
        .I2(sample_in[23]),
        .I3(seg_mav2[20]),
        .O(\ring_mav[3][23]_i_5_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_mav[3][23]_i_7 
       (.I0(sample_in[20]),
        .O(\ring_mav[3][23]_i_7_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_mav[3][23]_i_8 
       (.I0(sample_in[19]),
        .O(\ring_mav[3][23]_i_8_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_mav[3][23]_i_9 
       (.I0(sample_in[18]),
        .O(\ring_mav[3][23]_i_9_n_0 ));
  LUT3 #(
    .INIT(8'h9A)) 
    \ring_mav[3][27]_i_2 
       (.I0(seg_mav_reg[24]),
        .I1(\ring_mav_reg[3][27]_i_3_n_0 ),
        .I2(sample_in[23]),
        .O(\ring_mav[3][27]_i_2_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_mav[3][27]_i_4 
       (.I0(sample_in[23]),
        .O(\ring_mav[3][27]_i_4_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_mav[3][27]_i_5 
       (.I0(sample_in[22]),
        .O(\ring_mav[3][27]_i_5_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_mav[3][27]_i_6 
       (.I0(sample_in[21]),
        .O(\ring_mav[3][27]_i_6_n_0 ));
  LUT4 #(
    .INIT(16'h8000)) 
    \ring_mav[3][31]_i_1 
       (.I0(sample_valid),
        .I1(window_valid13_in),
        .I2(wr_ptr[1]),
        .I3(wr_ptr[0]),
        .O(\ring_mav[3][31]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \ring_mav[3][3]_i_2 
       (.I0(seg_mav_reg[3]),
        .I1(sample_in[3]),
        .I2(sample_in[23]),
        .I3(seg_mav2[3]),
        .O(\ring_mav[3][3]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \ring_mav[3][3]_i_3 
       (.I0(seg_mav_reg[2]),
        .I1(sample_in[2]),
        .I2(sample_in[23]),
        .I3(seg_mav2[2]),
        .O(\ring_mav[3][3]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \ring_mav[3][3]_i_4 
       (.I0(seg_mav_reg[1]),
        .I1(sample_in[1]),
        .I2(sample_in[23]),
        .I3(seg_mav2[1]),
        .O(\ring_mav[3][3]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \ring_mav[3][3]_i_5 
       (.I0(seg_mav_reg[0]),
        .I1(sample_in[0]),
        .O(\ring_mav[3][3]_i_5_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_mav[3][7]_i_10 
       (.I0(sample_in[2]),
        .O(\ring_mav[3][7]_i_10_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_mav[3][7]_i_11 
       (.I0(sample_in[1]),
        .O(\ring_mav[3][7]_i_11_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \ring_mav[3][7]_i_2 
       (.I0(seg_mav_reg[7]),
        .I1(sample_in[7]),
        .I2(sample_in[23]),
        .I3(seg_mav2[7]),
        .O(\ring_mav[3][7]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \ring_mav[3][7]_i_3 
       (.I0(seg_mav_reg[6]),
        .I1(sample_in[6]),
        .I2(sample_in[23]),
        .I3(seg_mav2[6]),
        .O(\ring_mav[3][7]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \ring_mav[3][7]_i_4 
       (.I0(seg_mav_reg[5]),
        .I1(sample_in[5]),
        .I2(sample_in[23]),
        .I3(seg_mav2[5]),
        .O(\ring_mav[3][7]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \ring_mav[3][7]_i_5 
       (.I0(seg_mav_reg[4]),
        .I1(sample_in[4]),
        .I2(sample_in[23]),
        .I3(seg_mav2[4]),
        .O(\ring_mav[3][7]_i_5_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_mav[3][7]_i_7 
       (.I0(sample_in[0]),
        .O(\ring_mav[3][7]_i_7_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_mav[3][7]_i_8 
       (.I0(sample_in[4]),
        .O(\ring_mav[3][7]_i_8_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_mav[3][7]_i_9 
       (.I0(sample_in[3]),
        .O(\ring_mav[3][7]_i_9_n_0 ));
  FDRE \ring_mav_reg[0][0] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_mav_reg[3][3]_i_1_n_7 ),
        .Q(\ring_mav_reg[0] [0]),
        .R(clear));
  FDRE \ring_mav_reg[0][10] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_mav_reg[3][11]_i_1_n_5 ),
        .Q(\ring_mav_reg[0] [10]),
        .R(clear));
  FDRE \ring_mav_reg[0][11] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_mav_reg[3][11]_i_1_n_4 ),
        .Q(\ring_mav_reg[0] [11]),
        .R(clear));
  FDRE \ring_mav_reg[0][12] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_mav_reg[3][15]_i_1_n_7 ),
        .Q(\ring_mav_reg[0] [12]),
        .R(clear));
  FDRE \ring_mav_reg[0][13] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_mav_reg[3][15]_i_1_n_6 ),
        .Q(\ring_mav_reg[0] [13]),
        .R(clear));
  FDRE \ring_mav_reg[0][14] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_mav_reg[3][15]_i_1_n_5 ),
        .Q(\ring_mav_reg[0] [14]),
        .R(clear));
  FDRE \ring_mav_reg[0][15] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_mav_reg[3][15]_i_1_n_4 ),
        .Q(\ring_mav_reg[0] [15]),
        .R(clear));
  FDRE \ring_mav_reg[0][16] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_mav_reg[3][19]_i_1_n_7 ),
        .Q(\ring_mav_reg[0] [16]),
        .R(clear));
  FDRE \ring_mav_reg[0][17] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_mav_reg[3][19]_i_1_n_6 ),
        .Q(\ring_mav_reg[0] [17]),
        .R(clear));
  FDRE \ring_mav_reg[0][18] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_mav_reg[3][19]_i_1_n_5 ),
        .Q(\ring_mav_reg[0] [18]),
        .R(clear));
  FDRE \ring_mav_reg[0][19] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_mav_reg[3][19]_i_1_n_4 ),
        .Q(\ring_mav_reg[0] [19]),
        .R(clear));
  FDRE \ring_mav_reg[0][1] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_mav_reg[3][3]_i_1_n_6 ),
        .Q(\ring_mav_reg[0] [1]),
        .R(clear));
  FDRE \ring_mav_reg[0][20] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_mav_reg[3][23]_i_1_n_7 ),
        .Q(\ring_mav_reg[0] [20]),
        .R(clear));
  FDRE \ring_mav_reg[0][21] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_mav_reg[3][23]_i_1_n_6 ),
        .Q(\ring_mav_reg[0] [21]),
        .R(clear));
  FDRE \ring_mav_reg[0][22] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_mav_reg[3][23]_i_1_n_5 ),
        .Q(\ring_mav_reg[0] [22]),
        .R(clear));
  FDRE \ring_mav_reg[0][23] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_mav_reg[3][23]_i_1_n_4 ),
        .Q(\ring_mav_reg[0] [23]),
        .R(clear));
  FDRE \ring_mav_reg[0][24] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_mav_reg[3][27]_i_1_n_7 ),
        .Q(\ring_mav_reg[0] [24]),
        .R(clear));
  FDRE \ring_mav_reg[0][25] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_mav_reg[3][27]_i_1_n_6 ),
        .Q(\ring_mav_reg[0] [25]),
        .R(clear));
  FDRE \ring_mav_reg[0][26] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_mav_reg[3][27]_i_1_n_5 ),
        .Q(\ring_mav_reg[0] [26]),
        .R(clear));
  FDRE \ring_mav_reg[0][27] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_mav_reg[3][27]_i_1_n_4 ),
        .Q(\ring_mav_reg[0] [27]),
        .R(clear));
  FDRE \ring_mav_reg[0][28] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_mav_reg[3][31]_i_2_n_7 ),
        .Q(\ring_mav_reg[0] [28]),
        .R(clear));
  FDRE \ring_mav_reg[0][29] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_mav_reg[3][31]_i_2_n_6 ),
        .Q(\ring_mav_reg[0] [29]),
        .R(clear));
  FDRE \ring_mav_reg[0][2] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_mav_reg[3][3]_i_1_n_5 ),
        .Q(\ring_mav_reg[0] [2]),
        .R(clear));
  FDRE \ring_mav_reg[0][30] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_mav_reg[3][31]_i_2_n_5 ),
        .Q(\ring_mav_reg[0] [30]),
        .R(clear));
  FDRE \ring_mav_reg[0][31] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_mav_reg[3][31]_i_2_n_4 ),
        .Q(\ring_mav_reg[0] [31]),
        .R(clear));
  FDRE \ring_mav_reg[0][3] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_mav_reg[3][3]_i_1_n_4 ),
        .Q(\ring_mav_reg[0] [3]),
        .R(clear));
  FDRE \ring_mav_reg[0][4] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_mav_reg[3][7]_i_1_n_7 ),
        .Q(\ring_mav_reg[0] [4]),
        .R(clear));
  FDRE \ring_mav_reg[0][5] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_mav_reg[3][7]_i_1_n_6 ),
        .Q(\ring_mav_reg[0] [5]),
        .R(clear));
  FDRE \ring_mav_reg[0][6] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_mav_reg[3][7]_i_1_n_5 ),
        .Q(\ring_mav_reg[0] [6]),
        .R(clear));
  FDRE \ring_mav_reg[0][7] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_mav_reg[3][7]_i_1_n_4 ),
        .Q(\ring_mav_reg[0] [7]),
        .R(clear));
  FDRE \ring_mav_reg[0][8] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_mav_reg[3][11]_i_1_n_7 ),
        .Q(\ring_mav_reg[0] [8]),
        .R(clear));
  FDRE \ring_mav_reg[0][9] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_mav_reg[3][11]_i_1_n_6 ),
        .Q(\ring_mav_reg[0] [9]),
        .R(clear));
  FDRE \ring_mav_reg[1][0] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][3]_i_1_n_7 ),
        .Q(\ring_mav_reg[1] [0]),
        .R(clear));
  FDRE \ring_mav_reg[1][10] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][11]_i_1_n_5 ),
        .Q(\ring_mav_reg[1] [10]),
        .R(clear));
  FDRE \ring_mav_reg[1][11] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][11]_i_1_n_4 ),
        .Q(\ring_mav_reg[1] [11]),
        .R(clear));
  FDRE \ring_mav_reg[1][12] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][15]_i_1_n_7 ),
        .Q(\ring_mav_reg[1] [12]),
        .R(clear));
  FDRE \ring_mav_reg[1][13] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][15]_i_1_n_6 ),
        .Q(\ring_mav_reg[1] [13]),
        .R(clear));
  FDRE \ring_mav_reg[1][14] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][15]_i_1_n_5 ),
        .Q(\ring_mav_reg[1] [14]),
        .R(clear));
  FDRE \ring_mav_reg[1][15] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][15]_i_1_n_4 ),
        .Q(\ring_mav_reg[1] [15]),
        .R(clear));
  FDRE \ring_mav_reg[1][16] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][19]_i_1_n_7 ),
        .Q(\ring_mav_reg[1] [16]),
        .R(clear));
  FDRE \ring_mav_reg[1][17] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][19]_i_1_n_6 ),
        .Q(\ring_mav_reg[1] [17]),
        .R(clear));
  FDRE \ring_mav_reg[1][18] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][19]_i_1_n_5 ),
        .Q(\ring_mav_reg[1] [18]),
        .R(clear));
  FDRE \ring_mav_reg[1][19] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][19]_i_1_n_4 ),
        .Q(\ring_mav_reg[1] [19]),
        .R(clear));
  FDRE \ring_mav_reg[1][1] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][3]_i_1_n_6 ),
        .Q(\ring_mav_reg[1] [1]),
        .R(clear));
  FDRE \ring_mav_reg[1][20] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][23]_i_1_n_7 ),
        .Q(\ring_mav_reg[1] [20]),
        .R(clear));
  FDRE \ring_mav_reg[1][21] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][23]_i_1_n_6 ),
        .Q(\ring_mav_reg[1] [21]),
        .R(clear));
  FDRE \ring_mav_reg[1][22] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][23]_i_1_n_5 ),
        .Q(\ring_mav_reg[1] [22]),
        .R(clear));
  FDRE \ring_mav_reg[1][23] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][23]_i_1_n_4 ),
        .Q(\ring_mav_reg[1] [23]),
        .R(clear));
  FDRE \ring_mav_reg[1][24] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][27]_i_1_n_7 ),
        .Q(\ring_mav_reg[1] [24]),
        .R(clear));
  FDRE \ring_mav_reg[1][25] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][27]_i_1_n_6 ),
        .Q(\ring_mav_reg[1] [25]),
        .R(clear));
  FDRE \ring_mav_reg[1][26] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][27]_i_1_n_5 ),
        .Q(\ring_mav_reg[1] [26]),
        .R(clear));
  FDRE \ring_mav_reg[1][27] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][27]_i_1_n_4 ),
        .Q(\ring_mav_reg[1] [27]),
        .R(clear));
  FDRE \ring_mav_reg[1][28] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][31]_i_2_n_7 ),
        .Q(\ring_mav_reg[1] [28]),
        .R(clear));
  FDRE \ring_mav_reg[1][29] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][31]_i_2_n_6 ),
        .Q(\ring_mav_reg[1] [29]),
        .R(clear));
  FDRE \ring_mav_reg[1][2] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][3]_i_1_n_5 ),
        .Q(\ring_mav_reg[1] [2]),
        .R(clear));
  FDRE \ring_mav_reg[1][30] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][31]_i_2_n_5 ),
        .Q(\ring_mav_reg[1] [30]),
        .R(clear));
  FDRE \ring_mav_reg[1][31] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][31]_i_2_n_4 ),
        .Q(\ring_mav_reg[1] [31]),
        .R(clear));
  FDRE \ring_mav_reg[1][3] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][3]_i_1_n_4 ),
        .Q(\ring_mav_reg[1] [3]),
        .R(clear));
  FDRE \ring_mav_reg[1][4] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][7]_i_1_n_7 ),
        .Q(\ring_mav_reg[1] [4]),
        .R(clear));
  FDRE \ring_mav_reg[1][5] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][7]_i_1_n_6 ),
        .Q(\ring_mav_reg[1] [5]),
        .R(clear));
  FDRE \ring_mav_reg[1][6] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][7]_i_1_n_5 ),
        .Q(\ring_mav_reg[1] [6]),
        .R(clear));
  FDRE \ring_mav_reg[1][7] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][7]_i_1_n_4 ),
        .Q(\ring_mav_reg[1] [7]),
        .R(clear));
  FDRE \ring_mav_reg[1][8] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][11]_i_1_n_7 ),
        .Q(\ring_mav_reg[1] [8]),
        .R(clear));
  FDRE \ring_mav_reg[1][9] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][11]_i_1_n_6 ),
        .Q(\ring_mav_reg[1] [9]),
        .R(clear));
  FDRE \ring_mav_reg[2][0] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][3]_i_1_n_7 ),
        .Q(\ring_mav_reg[2] [0]),
        .R(clear));
  FDRE \ring_mav_reg[2][10] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][11]_i_1_n_5 ),
        .Q(\ring_mav_reg[2] [10]),
        .R(clear));
  FDRE \ring_mav_reg[2][11] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][11]_i_1_n_4 ),
        .Q(\ring_mav_reg[2] [11]),
        .R(clear));
  FDRE \ring_mav_reg[2][12] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][15]_i_1_n_7 ),
        .Q(\ring_mav_reg[2] [12]),
        .R(clear));
  FDRE \ring_mav_reg[2][13] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][15]_i_1_n_6 ),
        .Q(\ring_mav_reg[2] [13]),
        .R(clear));
  FDRE \ring_mav_reg[2][14] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][15]_i_1_n_5 ),
        .Q(\ring_mav_reg[2] [14]),
        .R(clear));
  FDRE \ring_mav_reg[2][15] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][15]_i_1_n_4 ),
        .Q(\ring_mav_reg[2] [15]),
        .R(clear));
  FDRE \ring_mav_reg[2][16] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][19]_i_1_n_7 ),
        .Q(\ring_mav_reg[2] [16]),
        .R(clear));
  FDRE \ring_mav_reg[2][17] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][19]_i_1_n_6 ),
        .Q(\ring_mav_reg[2] [17]),
        .R(clear));
  FDRE \ring_mav_reg[2][18] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][19]_i_1_n_5 ),
        .Q(\ring_mav_reg[2] [18]),
        .R(clear));
  FDRE \ring_mav_reg[2][19] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][19]_i_1_n_4 ),
        .Q(\ring_mav_reg[2] [19]),
        .R(clear));
  FDRE \ring_mav_reg[2][1] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][3]_i_1_n_6 ),
        .Q(\ring_mav_reg[2] [1]),
        .R(clear));
  FDRE \ring_mav_reg[2][20] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][23]_i_1_n_7 ),
        .Q(\ring_mav_reg[2] [20]),
        .R(clear));
  FDRE \ring_mav_reg[2][21] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][23]_i_1_n_6 ),
        .Q(\ring_mav_reg[2] [21]),
        .R(clear));
  FDRE \ring_mav_reg[2][22] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][23]_i_1_n_5 ),
        .Q(\ring_mav_reg[2] [22]),
        .R(clear));
  FDRE \ring_mav_reg[2][23] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][23]_i_1_n_4 ),
        .Q(\ring_mav_reg[2] [23]),
        .R(clear));
  FDRE \ring_mav_reg[2][24] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][27]_i_1_n_7 ),
        .Q(\ring_mav_reg[2] [24]),
        .R(clear));
  FDRE \ring_mav_reg[2][25] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][27]_i_1_n_6 ),
        .Q(\ring_mav_reg[2] [25]),
        .R(clear));
  FDRE \ring_mav_reg[2][26] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][27]_i_1_n_5 ),
        .Q(\ring_mav_reg[2] [26]),
        .R(clear));
  FDRE \ring_mav_reg[2][27] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][27]_i_1_n_4 ),
        .Q(\ring_mav_reg[2] [27]),
        .R(clear));
  FDRE \ring_mav_reg[2][28] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][31]_i_2_n_7 ),
        .Q(\ring_mav_reg[2] [28]),
        .R(clear));
  FDRE \ring_mav_reg[2][29] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][31]_i_2_n_6 ),
        .Q(\ring_mav_reg[2] [29]),
        .R(clear));
  FDRE \ring_mav_reg[2][2] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][3]_i_1_n_5 ),
        .Q(\ring_mav_reg[2] [2]),
        .R(clear));
  FDRE \ring_mav_reg[2][30] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][31]_i_2_n_5 ),
        .Q(\ring_mav_reg[2] [30]),
        .R(clear));
  FDRE \ring_mav_reg[2][31] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][31]_i_2_n_4 ),
        .Q(\ring_mav_reg[2] [31]),
        .R(clear));
  FDRE \ring_mav_reg[2][3] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][3]_i_1_n_4 ),
        .Q(\ring_mav_reg[2] [3]),
        .R(clear));
  FDRE \ring_mav_reg[2][4] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][7]_i_1_n_7 ),
        .Q(\ring_mav_reg[2] [4]),
        .R(clear));
  FDRE \ring_mav_reg[2][5] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][7]_i_1_n_6 ),
        .Q(\ring_mav_reg[2] [5]),
        .R(clear));
  FDRE \ring_mav_reg[2][6] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][7]_i_1_n_5 ),
        .Q(\ring_mav_reg[2] [6]),
        .R(clear));
  FDRE \ring_mav_reg[2][7] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][7]_i_1_n_4 ),
        .Q(\ring_mav_reg[2] [7]),
        .R(clear));
  FDRE \ring_mav_reg[2][8] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][11]_i_1_n_7 ),
        .Q(\ring_mav_reg[2] [8]),
        .R(clear));
  FDRE \ring_mav_reg[2][9] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][11]_i_1_n_6 ),
        .Q(\ring_mav_reg[2] [9]),
        .R(clear));
  FDRE \ring_mav_reg[3][0] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][3]_i_1_n_7 ),
        .Q(\ring_mav_reg[3] [0]),
        .R(clear));
  FDRE \ring_mav_reg[3][10] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][11]_i_1_n_5 ),
        .Q(\ring_mav_reg[3] [10]),
        .R(clear));
  FDRE \ring_mav_reg[3][11] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][11]_i_1_n_4 ),
        .Q(\ring_mav_reg[3] [11]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ring_mav_reg[3][11]_i_1 
       (.CI(\ring_mav_reg[3][7]_i_1_n_0 ),
        .CO({\ring_mav_reg[3][11]_i_1_n_0 ,\ring_mav_reg[3][11]_i_1_n_1 ,\ring_mav_reg[3][11]_i_1_n_2 ,\ring_mav_reg[3][11]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(seg_mav_reg[11:8]),
        .O({\ring_mav_reg[3][11]_i_1_n_4 ,\ring_mav_reg[3][11]_i_1_n_5 ,\ring_mav_reg[3][11]_i_1_n_6 ,\ring_mav_reg[3][11]_i_1_n_7 }),
        .S({\ring_mav[3][11]_i_2_n_0 ,\ring_mav[3][11]_i_3_n_0 ,\ring_mav[3][11]_i_4_n_0 ,\ring_mav[3][11]_i_5_n_0 }));
  CARRY4 \ring_mav_reg[3][11]_i_6 
       (.CI(\ring_mav_reg[3][7]_i_6_n_0 ),
        .CO({\ring_mav_reg[3][11]_i_6_n_0 ,\ring_mav_reg[3][11]_i_6_n_1 ,\ring_mav_reg[3][11]_i_6_n_2 ,\ring_mav_reg[3][11]_i_6_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(seg_mav2[8:5]),
        .S({\ring_mav[3][11]_i_7_n_0 ,\ring_mav[3][11]_i_8_n_0 ,\ring_mav[3][11]_i_9_n_0 ,\ring_mav[3][11]_i_10_n_0 }));
  FDRE \ring_mav_reg[3][12] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][15]_i_1_n_7 ),
        .Q(\ring_mav_reg[3] [12]),
        .R(clear));
  FDRE \ring_mav_reg[3][13] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][15]_i_1_n_6 ),
        .Q(\ring_mav_reg[3] [13]),
        .R(clear));
  FDRE \ring_mav_reg[3][14] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][15]_i_1_n_5 ),
        .Q(\ring_mav_reg[3] [14]),
        .R(clear));
  FDRE \ring_mav_reg[3][15] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][15]_i_1_n_4 ),
        .Q(\ring_mav_reg[3] [15]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ring_mav_reg[3][15]_i_1 
       (.CI(\ring_mav_reg[3][11]_i_1_n_0 ),
        .CO({\ring_mav_reg[3][15]_i_1_n_0 ,\ring_mav_reg[3][15]_i_1_n_1 ,\ring_mav_reg[3][15]_i_1_n_2 ,\ring_mav_reg[3][15]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(seg_mav_reg[15:12]),
        .O({\ring_mav_reg[3][15]_i_1_n_4 ,\ring_mav_reg[3][15]_i_1_n_5 ,\ring_mav_reg[3][15]_i_1_n_6 ,\ring_mav_reg[3][15]_i_1_n_7 }),
        .S({\ring_mav[3][15]_i_2_n_0 ,\ring_mav[3][15]_i_3_n_0 ,\ring_mav[3][15]_i_4_n_0 ,\ring_mav[3][15]_i_5_n_0 }));
  CARRY4 \ring_mav_reg[3][15]_i_6 
       (.CI(\ring_mav_reg[3][11]_i_6_n_0 ),
        .CO({\ring_mav_reg[3][15]_i_6_n_0 ,\ring_mav_reg[3][15]_i_6_n_1 ,\ring_mav_reg[3][15]_i_6_n_2 ,\ring_mav_reg[3][15]_i_6_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(seg_mav2[12:9]),
        .S({\ring_mav[3][15]_i_7_n_0 ,\ring_mav[3][15]_i_8_n_0 ,\ring_mav[3][15]_i_9_n_0 ,\ring_mav[3][15]_i_10_n_0 }));
  FDRE \ring_mav_reg[3][16] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][19]_i_1_n_7 ),
        .Q(\ring_mav_reg[3] [16]),
        .R(clear));
  FDRE \ring_mav_reg[3][17] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][19]_i_1_n_6 ),
        .Q(\ring_mav_reg[3] [17]),
        .R(clear));
  FDRE \ring_mav_reg[3][18] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][19]_i_1_n_5 ),
        .Q(\ring_mav_reg[3] [18]),
        .R(clear));
  FDRE \ring_mav_reg[3][19] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][19]_i_1_n_4 ),
        .Q(\ring_mav_reg[3] [19]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ring_mav_reg[3][19]_i_1 
       (.CI(\ring_mav_reg[3][15]_i_1_n_0 ),
        .CO({\ring_mav_reg[3][19]_i_1_n_0 ,\ring_mav_reg[3][19]_i_1_n_1 ,\ring_mav_reg[3][19]_i_1_n_2 ,\ring_mav_reg[3][19]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(seg_mav_reg[19:16]),
        .O({\ring_mav_reg[3][19]_i_1_n_4 ,\ring_mav_reg[3][19]_i_1_n_5 ,\ring_mav_reg[3][19]_i_1_n_6 ,\ring_mav_reg[3][19]_i_1_n_7 }),
        .S({\ring_mav[3][19]_i_2_n_0 ,\ring_mav[3][19]_i_3_n_0 ,\ring_mav[3][19]_i_4_n_0 ,\ring_mav[3][19]_i_5_n_0 }));
  CARRY4 \ring_mav_reg[3][19]_i_6 
       (.CI(\ring_mav_reg[3][15]_i_6_n_0 ),
        .CO({\ring_mav_reg[3][19]_i_6_n_0 ,\ring_mav_reg[3][19]_i_6_n_1 ,\ring_mav_reg[3][19]_i_6_n_2 ,\ring_mav_reg[3][19]_i_6_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(seg_mav2[16:13]),
        .S({\ring_mav[3][19]_i_7_n_0 ,\ring_mav[3][19]_i_8_n_0 ,\ring_mav[3][19]_i_9_n_0 ,\ring_mav[3][19]_i_10_n_0 }));
  FDRE \ring_mav_reg[3][1] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][3]_i_1_n_6 ),
        .Q(\ring_mav_reg[3] [1]),
        .R(clear));
  FDRE \ring_mav_reg[3][20] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][23]_i_1_n_7 ),
        .Q(\ring_mav_reg[3] [20]),
        .R(clear));
  FDRE \ring_mav_reg[3][21] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][23]_i_1_n_6 ),
        .Q(\ring_mav_reg[3] [21]),
        .R(clear));
  FDRE \ring_mav_reg[3][22] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][23]_i_1_n_5 ),
        .Q(\ring_mav_reg[3] [22]),
        .R(clear));
  FDRE \ring_mav_reg[3][23] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][23]_i_1_n_4 ),
        .Q(\ring_mav_reg[3] [23]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ring_mav_reg[3][23]_i_1 
       (.CI(\ring_mav_reg[3][19]_i_1_n_0 ),
        .CO({\ring_mav_reg[3][23]_i_1_n_0 ,\ring_mav_reg[3][23]_i_1_n_1 ,\ring_mav_reg[3][23]_i_1_n_2 ,\ring_mav_reg[3][23]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(seg_mav_reg[23:20]),
        .O({\ring_mav_reg[3][23]_i_1_n_4 ,\ring_mav_reg[3][23]_i_1_n_5 ,\ring_mav_reg[3][23]_i_1_n_6 ,\ring_mav_reg[3][23]_i_1_n_7 }),
        .S({\ring_mav[3][23]_i_2_n_0 ,\ring_mav[3][23]_i_3_n_0 ,\ring_mav[3][23]_i_4_n_0 ,\ring_mav[3][23]_i_5_n_0 }));
  CARRY4 \ring_mav_reg[3][23]_i_6 
       (.CI(\ring_mav_reg[3][19]_i_6_n_0 ),
        .CO({\ring_mav_reg[3][23]_i_6_n_0 ,\ring_mav_reg[3][23]_i_6_n_1 ,\ring_mav_reg[3][23]_i_6_n_2 ,\ring_mav_reg[3][23]_i_6_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(seg_mav2[20:17]),
        .S({\ring_mav[3][23]_i_7_n_0 ,\ring_mav[3][23]_i_8_n_0 ,\ring_mav[3][23]_i_9_n_0 ,\ring_mav[3][23]_i_10_n_0 }));
  FDRE \ring_mav_reg[3][24] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][27]_i_1_n_7 ),
        .Q(\ring_mav_reg[3] [24]),
        .R(clear));
  FDRE \ring_mav_reg[3][25] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][27]_i_1_n_6 ),
        .Q(\ring_mav_reg[3] [25]),
        .R(clear));
  FDRE \ring_mav_reg[3][26] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][27]_i_1_n_5 ),
        .Q(\ring_mav_reg[3] [26]),
        .R(clear));
  FDRE \ring_mav_reg[3][27] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][27]_i_1_n_4 ),
        .Q(\ring_mav_reg[3] [27]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ring_mav_reg[3][27]_i_1 
       (.CI(\ring_mav_reg[3][23]_i_1_n_0 ),
        .CO({\ring_mav_reg[3][27]_i_1_n_0 ,\ring_mav_reg[3][27]_i_1_n_1 ,\ring_mav_reg[3][27]_i_1_n_2 ,\ring_mav_reg[3][27]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,seg_mav_reg[24]}),
        .O({\ring_mav_reg[3][27]_i_1_n_4 ,\ring_mav_reg[3][27]_i_1_n_5 ,\ring_mav_reg[3][27]_i_1_n_6 ,\ring_mav_reg[3][27]_i_1_n_7 }),
        .S({seg_mav_reg[27:25],\ring_mav[3][27]_i_2_n_0 }));
  CARRY4 \ring_mav_reg[3][27]_i_3 
       (.CI(\ring_mav_reg[3][23]_i_6_n_0 ),
        .CO({\ring_mav_reg[3][27]_i_3_n_0 ,\NLW_ring_mav_reg[3][27]_i_3_CO_UNCONNECTED [2],\ring_mav_reg[3][27]_i_3_n_2 ,\ring_mav_reg[3][27]_i_3_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b1,1'b0,1'b0}),
        .O({\NLW_ring_mav_reg[3][27]_i_3_O_UNCONNECTED [3],seg_mav2[23:21]}),
        .S({1'b1,\ring_mav[3][27]_i_4_n_0 ,\ring_mav[3][27]_i_5_n_0 ,\ring_mav[3][27]_i_6_n_0 }));
  FDRE \ring_mav_reg[3][28] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][31]_i_2_n_7 ),
        .Q(\ring_mav_reg[3] [28]),
        .R(clear));
  FDRE \ring_mav_reg[3][29] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][31]_i_2_n_6 ),
        .Q(\ring_mav_reg[3] [29]),
        .R(clear));
  FDRE \ring_mav_reg[3][2] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][3]_i_1_n_5 ),
        .Q(\ring_mav_reg[3] [2]),
        .R(clear));
  FDRE \ring_mav_reg[3][30] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][31]_i_2_n_5 ),
        .Q(\ring_mav_reg[3] [30]),
        .R(clear));
  FDRE \ring_mav_reg[3][31] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][31]_i_2_n_4 ),
        .Q(\ring_mav_reg[3] [31]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ring_mav_reg[3][31]_i_2 
       (.CI(\ring_mav_reg[3][27]_i_1_n_0 ),
        .CO({\NLW_ring_mav_reg[3][31]_i_2_CO_UNCONNECTED [3],\ring_mav_reg[3][31]_i_2_n_1 ,\ring_mav_reg[3][31]_i_2_n_2 ,\ring_mav_reg[3][31]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\ring_mav_reg[3][31]_i_2_n_4 ,\ring_mav_reg[3][31]_i_2_n_5 ,\ring_mav_reg[3][31]_i_2_n_6 ,\ring_mav_reg[3][31]_i_2_n_7 }),
        .S(seg_mav_reg[31:28]));
  FDRE \ring_mav_reg[3][3] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][3]_i_1_n_4 ),
        .Q(\ring_mav_reg[3] [3]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ring_mav_reg[3][3]_i_1 
       (.CI(1'b0),
        .CO({\ring_mav_reg[3][3]_i_1_n_0 ,\ring_mav_reg[3][3]_i_1_n_1 ,\ring_mav_reg[3][3]_i_1_n_2 ,\ring_mav_reg[3][3]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(seg_mav_reg[3:0]),
        .O({\ring_mav_reg[3][3]_i_1_n_4 ,\ring_mav_reg[3][3]_i_1_n_5 ,\ring_mav_reg[3][3]_i_1_n_6 ,\ring_mav_reg[3][3]_i_1_n_7 }),
        .S({\ring_mav[3][3]_i_2_n_0 ,\ring_mav[3][3]_i_3_n_0 ,\ring_mav[3][3]_i_4_n_0 ,\ring_mav[3][3]_i_5_n_0 }));
  FDRE \ring_mav_reg[3][4] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][7]_i_1_n_7 ),
        .Q(\ring_mav_reg[3] [4]),
        .R(clear));
  FDRE \ring_mav_reg[3][5] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][7]_i_1_n_6 ),
        .Q(\ring_mav_reg[3] [5]),
        .R(clear));
  FDRE \ring_mav_reg[3][6] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][7]_i_1_n_5 ),
        .Q(\ring_mav_reg[3] [6]),
        .R(clear));
  FDRE \ring_mav_reg[3][7] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][7]_i_1_n_4 ),
        .Q(\ring_mav_reg[3] [7]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ring_mav_reg[3][7]_i_1 
       (.CI(\ring_mav_reg[3][3]_i_1_n_0 ),
        .CO({\ring_mav_reg[3][7]_i_1_n_0 ,\ring_mav_reg[3][7]_i_1_n_1 ,\ring_mav_reg[3][7]_i_1_n_2 ,\ring_mav_reg[3][7]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(seg_mav_reg[7:4]),
        .O({\ring_mav_reg[3][7]_i_1_n_4 ,\ring_mav_reg[3][7]_i_1_n_5 ,\ring_mav_reg[3][7]_i_1_n_6 ,\ring_mav_reg[3][7]_i_1_n_7 }),
        .S({\ring_mav[3][7]_i_2_n_0 ,\ring_mav[3][7]_i_3_n_0 ,\ring_mav[3][7]_i_4_n_0 ,\ring_mav[3][7]_i_5_n_0 }));
  CARRY4 \ring_mav_reg[3][7]_i_6 
       (.CI(1'b0),
        .CO({\ring_mav_reg[3][7]_i_6_n_0 ,\ring_mav_reg[3][7]_i_6_n_1 ,\ring_mav_reg[3][7]_i_6_n_2 ,\ring_mav_reg[3][7]_i_6_n_3 }),
        .CYINIT(\ring_mav[3][7]_i_7_n_0 ),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(seg_mav2[4:1]),
        .S({\ring_mav[3][7]_i_8_n_0 ,\ring_mav[3][7]_i_9_n_0 ,\ring_mav[3][7]_i_10_n_0 ,\ring_mav[3][7]_i_11_n_0 }));
  FDRE \ring_mav_reg[3][8] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][11]_i_1_n_7 ),
        .Q(\ring_mav_reg[3] [8]),
        .R(clear));
  FDRE \ring_mav_reg[3][9] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_mav_reg[3][11]_i_1_n_6 ),
        .Q(\ring_mav_reg[3] [9]),
        .R(clear));
  (* SOFT_HLUTNM = "soft_lutpair122" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \ring_ssc[3][0]_i_1 
       (.I0(seg_ssc_reg[0]),
        .I1(ssc_event),
        .O(\ring_ssc[3][0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair122" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \ring_ssc[3][1]_i_1 
       (.I0(seg_ssc_reg[0]),
        .I1(ssc_event),
        .I2(seg_ssc_reg[1]),
        .O(\ring_ssc[3][1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \ring_ssc[3][2]_i_1 
       (.I0(ssc_event),
        .I1(seg_ssc_reg[0]),
        .I2(seg_ssc_reg[1]),
        .I3(seg_ssc_reg[2]),
        .O(\ring_ssc[3][2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    \ring_ssc[3][3]_i_1 
       (.I0(seg_ssc_reg[1]),
        .I1(seg_ssc_reg[0]),
        .I2(ssc_event),
        .I3(seg_ssc_reg[2]),
        .I4(seg_ssc_reg[3]),
        .O(\ring_ssc[3][3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h7FFFFFFF80000000)) 
    \ring_ssc[3][4]_i_1 
       (.I0(seg_ssc_reg[2]),
        .I1(ssc_event),
        .I2(seg_ssc_reg[0]),
        .I3(seg_ssc_reg[1]),
        .I4(seg_ssc_reg[3]),
        .I5(seg_ssc_reg[4]),
        .O(\ring_ssc[3][4]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h00053305)) 
    \ring_ssc[3][4]_i_10 
       (.I0(ssc_event4[23]),
        .I1(\ring_ssc_reg[3][4]_i_13_n_4 ),
        .I2(ssc_event4[22]),
        .I3(\ring_ssc_reg[3][4]_i_4_n_3 ),
        .I4(\ring_ssc_reg[3][4]_i_13_n_5 ),
        .O(\ring_ssc[3][4]_i_10_n_0 ));
  LUT5 #(
    .INIT(32'h00053305)) 
    \ring_ssc[3][4]_i_11 
       (.I0(ssc_event4[21]),
        .I1(\ring_ssc_reg[3][4]_i_13_n_6 ),
        .I2(ssc_event4[20]),
        .I3(\ring_ssc_reg[3][4]_i_4_n_3 ),
        .I4(\ring_ssc_reg[3][4]_i_13_n_7 ),
        .O(\ring_ssc[3][4]_i_11_n_0 ));
  LUT5 #(
    .INIT(32'h00053305)) 
    \ring_ssc[3][4]_i_12 
       (.I0(ssc_event4[19]),
        .I1(\ring_ssc_reg[3][4]_i_25_n_4 ),
        .I2(ssc_event4[18]),
        .I3(\ring_ssc_reg[3][4]_i_4_n_3 ),
        .I4(\ring_ssc_reg[3][4]_i_25_n_5 ),
        .O(\ring_ssc[3][4]_i_12_n_0 ));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    \ring_ssc[3][4]_i_15 
       (.I0(\ring_ssc_reg[3][4]_i_25_n_7 ),
        .I1(\ring_ssc_reg[3][4]_i_4_n_3 ),
        .I2(ssc_event4[16]),
        .I3(\ring_ssc_reg[3][4]_i_25_n_6 ),
        .I4(ssc_event4[17]),
        .O(\ring_ssc[3][4]_i_15_n_0 ));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    \ring_ssc[3][4]_i_16 
       (.I0(\ring_ssc_reg[3][4]_i_40_n_5 ),
        .I1(\ring_ssc_reg[3][4]_i_4_n_3 ),
        .I2(ssc_event4[14]),
        .I3(\ring_ssc_reg[3][4]_i_40_n_4 ),
        .I4(ssc_event4[15]),
        .O(\ring_ssc[3][4]_i_16_n_0 ));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    \ring_ssc[3][4]_i_17 
       (.I0(\ring_ssc_reg[3][4]_i_40_n_7 ),
        .I1(\ring_ssc_reg[3][4]_i_4_n_3 ),
        .I2(ssc_event4[12]),
        .I3(\ring_ssc_reg[3][4]_i_40_n_6 ),
        .I4(ssc_event4[13]),
        .O(\ring_ssc[3][4]_i_17_n_0 ));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    \ring_ssc[3][4]_i_18 
       (.I0(\ring_ssc_reg[3][4]_i_42_n_5 ),
        .I1(\ring_ssc_reg[3][4]_i_4_n_3 ),
        .I2(ssc_event4[10]),
        .I3(\ring_ssc_reg[3][4]_i_42_n_4 ),
        .I4(ssc_event4[11]),
        .O(\ring_ssc[3][4]_i_18_n_0 ));
  LUT5 #(
    .INIT(32'h00053305)) 
    \ring_ssc[3][4]_i_19 
       (.I0(ssc_event4[17]),
        .I1(\ring_ssc_reg[3][4]_i_25_n_6 ),
        .I2(ssc_event4[16]),
        .I3(\ring_ssc_reg[3][4]_i_4_n_3 ),
        .I4(\ring_ssc_reg[3][4]_i_25_n_7 ),
        .O(\ring_ssc[3][4]_i_19_n_0 ));
  LUT6 #(
    .INIT(64'h0000800080000000)) 
    \ring_ssc[3][4]_i_2 
       (.I0(\ring_ssc_reg[3][4]_i_3_n_0 ),
        .I1(have_prev2),
        .I2(zc_event1),
        .I3(have_prev),
        .I4(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I5(\ring_ssc_reg[3][4]_i_4_n_3 ),
        .O(ssc_event));
  LUT5 #(
    .INIT(32'h00053305)) 
    \ring_ssc[3][4]_i_20 
       (.I0(ssc_event4[15]),
        .I1(\ring_ssc_reg[3][4]_i_40_n_4 ),
        .I2(ssc_event4[14]),
        .I3(\ring_ssc_reg[3][4]_i_4_n_3 ),
        .I4(\ring_ssc_reg[3][4]_i_40_n_5 ),
        .O(\ring_ssc[3][4]_i_20_n_0 ));
  LUT5 #(
    .INIT(32'h00053305)) 
    \ring_ssc[3][4]_i_21 
       (.I0(ssc_event4[13]),
        .I1(\ring_ssc_reg[3][4]_i_40_n_6 ),
        .I2(ssc_event4[12]),
        .I3(\ring_ssc_reg[3][4]_i_4_n_3 ),
        .I4(\ring_ssc_reg[3][4]_i_40_n_7 ),
        .O(\ring_ssc[3][4]_i_21_n_0 ));
  LUT5 #(
    .INIT(32'h00053305)) 
    \ring_ssc[3][4]_i_22 
       (.I0(ssc_event4[11]),
        .I1(\ring_ssc_reg[3][4]_i_42_n_4 ),
        .I2(ssc_event4[10]),
        .I3(\ring_ssc_reg[3][4]_i_4_n_3 ),
        .I4(\ring_ssc_reg[3][4]_i_42_n_5 ),
        .O(\ring_ssc[3][4]_i_22_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_ssc[3][4]_i_26 
       (.I0(p_0_in0_in),
        .I1(prev2[23]),
        .O(\ring_ssc[3][4]_i_26_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_ssc[3][4]_i_27 
       (.I0(\prev_reg_n_0_[22] ),
        .I1(prev2[22]),
        .O(\ring_ssc[3][4]_i_27_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_ssc[3][4]_i_28 
       (.I0(\prev_reg_n_0_[21] ),
        .I1(prev2[21]),
        .O(\ring_ssc[3][4]_i_28_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_ssc[3][4]_i_29 
       (.I0(\prev_reg_n_0_[20] ),
        .I1(prev2[20]),
        .O(\ring_ssc[3][4]_i_29_n_0 ));
  LUT4 #(
    .INIT(16'hFFE2)) 
    \ring_ssc[3][4]_i_30 
       (.I0(ssc_event4[1]),
        .I1(\ring_ssc_reg[3][4]_i_4_n_3 ),
        .I2(\ring_ssc_reg[3][4]_i_55_n_6 ),
        .I3(\ring_ssc_reg[3][4]_i_55_n_7 ),
        .O(\ring_ssc[3][4]_i_30_n_0 ));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    \ring_ssc[3][4]_i_31 
       (.I0(\ring_ssc_reg[3][4]_i_42_n_7 ),
        .I1(\ring_ssc_reg[3][4]_i_4_n_3 ),
        .I2(ssc_event4[8]),
        .I3(\ring_ssc_reg[3][4]_i_42_n_6 ),
        .I4(ssc_event4[9]),
        .O(\ring_ssc[3][4]_i_31_n_0 ));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    \ring_ssc[3][4]_i_32 
       (.I0(\ring_ssc_reg[3][4]_i_57_n_5 ),
        .I1(\ring_ssc_reg[3][4]_i_4_n_3 ),
        .I2(ssc_event4[6]),
        .I3(\ring_ssc_reg[3][4]_i_57_n_4 ),
        .I4(ssc_event4[7]),
        .O(\ring_ssc[3][4]_i_32_n_0 ));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    \ring_ssc[3][4]_i_33 
       (.I0(\ring_ssc_reg[3][4]_i_57_n_7 ),
        .I1(\ring_ssc_reg[3][4]_i_4_n_3 ),
        .I2(ssc_event4[4]),
        .I3(\ring_ssc_reg[3][4]_i_57_n_6 ),
        .I4(ssc_event4[5]),
        .O(\ring_ssc[3][4]_i_33_n_0 ));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    \ring_ssc[3][4]_i_34 
       (.I0(\ring_ssc_reg[3][4]_i_55_n_5 ),
        .I1(\ring_ssc_reg[3][4]_i_4_n_3 ),
        .I2(ssc_event4[2]),
        .I3(\ring_ssc_reg[3][4]_i_55_n_4 ),
        .I4(ssc_event4[3]),
        .O(\ring_ssc[3][4]_i_34_n_0 ));
  LUT5 #(
    .INIT(32'h00053305)) 
    \ring_ssc[3][4]_i_35 
       (.I0(ssc_event4[9]),
        .I1(\ring_ssc_reg[3][4]_i_42_n_6 ),
        .I2(ssc_event4[8]),
        .I3(\ring_ssc_reg[3][4]_i_4_n_3 ),
        .I4(\ring_ssc_reg[3][4]_i_42_n_7 ),
        .O(\ring_ssc[3][4]_i_35_n_0 ));
  LUT5 #(
    .INIT(32'h00053305)) 
    \ring_ssc[3][4]_i_36 
       (.I0(ssc_event4[7]),
        .I1(\ring_ssc_reg[3][4]_i_57_n_4 ),
        .I2(ssc_event4[6]),
        .I3(\ring_ssc_reg[3][4]_i_4_n_3 ),
        .I4(\ring_ssc_reg[3][4]_i_57_n_5 ),
        .O(\ring_ssc[3][4]_i_36_n_0 ));
  LUT5 #(
    .INIT(32'h00053305)) 
    \ring_ssc[3][4]_i_37 
       (.I0(ssc_event4[5]),
        .I1(\ring_ssc_reg[3][4]_i_57_n_6 ),
        .I2(ssc_event4[4]),
        .I3(\ring_ssc_reg[3][4]_i_4_n_3 ),
        .I4(\ring_ssc_reg[3][4]_i_57_n_7 ),
        .O(\ring_ssc[3][4]_i_37_n_0 ));
  LUT5 #(
    .INIT(32'h00053305)) 
    \ring_ssc[3][4]_i_38 
       (.I0(ssc_event4[3]),
        .I1(\ring_ssc_reg[3][4]_i_55_n_4 ),
        .I2(ssc_event4[2]),
        .I3(\ring_ssc_reg[3][4]_i_4_n_3 ),
        .I4(\ring_ssc_reg[3][4]_i_55_n_5 ),
        .O(\ring_ssc[3][4]_i_38_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_ssc[3][4]_i_43 
       (.I0(\ring_ssc_reg[3][4]_i_13_n_4 ),
        .O(\ring_ssc[3][4]_i_43_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_ssc[3][4]_i_44 
       (.I0(\ring_ssc_reg[3][4]_i_13_n_5 ),
        .O(\ring_ssc[3][4]_i_44_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_ssc[3][4]_i_45 
       (.I0(\ring_ssc_reg[3][4]_i_13_n_6 ),
        .O(\ring_ssc[3][4]_i_45_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_ssc[3][4]_i_46 
       (.I0(\ring_ssc_reg[3][4]_i_13_n_7 ),
        .O(\ring_ssc[3][4]_i_46_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_ssc[3][4]_i_47 
       (.I0(\ring_ssc_reg[3][4]_i_25_n_4 ),
        .O(\ring_ssc[3][4]_i_47_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_ssc[3][4]_i_48 
       (.I0(\ring_ssc_reg[3][4]_i_25_n_5 ),
        .O(\ring_ssc[3][4]_i_48_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_ssc[3][4]_i_49 
       (.I0(\ring_ssc_reg[3][4]_i_25_n_6 ),
        .O(\ring_ssc[3][4]_i_49_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_ssc[3][4]_i_50 
       (.I0(\prev_reg_n_0_[19] ),
        .I1(prev2[19]),
        .O(\ring_ssc[3][4]_i_50_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_ssc[3][4]_i_51 
       (.I0(\prev_reg_n_0_[18] ),
        .I1(prev2[18]),
        .O(\ring_ssc[3][4]_i_51_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_ssc[3][4]_i_52 
       (.I0(\prev_reg_n_0_[17] ),
        .I1(prev2[17]),
        .O(\ring_ssc[3][4]_i_52_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_ssc[3][4]_i_53 
       (.I0(\prev_reg_n_0_[16] ),
        .I1(prev2[16]),
        .O(\ring_ssc[3][4]_i_53_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_ssc[3][4]_i_58 
       (.I0(\ring_ssc_reg[3][4]_i_25_n_7 ),
        .O(\ring_ssc[3][4]_i_58_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_ssc[3][4]_i_59 
       (.I0(\ring_ssc_reg[3][4]_i_40_n_4 ),
        .O(\ring_ssc[3][4]_i_59_n_0 ));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    \ring_ssc[3][4]_i_6 
       (.I0(\ring_ssc_reg[3][4]_i_13_n_5 ),
        .I1(\ring_ssc_reg[3][4]_i_4_n_3 ),
        .I2(ssc_event4[22]),
        .I3(\ring_ssc_reg[3][4]_i_13_n_4 ),
        .I4(ssc_event4[23]),
        .O(\ring_ssc[3][4]_i_6_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_ssc[3][4]_i_60 
       (.I0(\ring_ssc_reg[3][4]_i_40_n_5 ),
        .O(\ring_ssc[3][4]_i_60_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_ssc[3][4]_i_61 
       (.I0(\ring_ssc_reg[3][4]_i_40_n_6 ),
        .O(\ring_ssc[3][4]_i_61_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_ssc[3][4]_i_62 
       (.I0(\prev_reg_n_0_[15] ),
        .I1(prev2[15]),
        .O(\ring_ssc[3][4]_i_62_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_ssc[3][4]_i_63 
       (.I0(\prev_reg_n_0_[14] ),
        .I1(prev2[14]),
        .O(\ring_ssc[3][4]_i_63_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_ssc[3][4]_i_64 
       (.I0(\prev_reg_n_0_[13] ),
        .I1(prev2[13]),
        .O(\ring_ssc[3][4]_i_64_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_ssc[3][4]_i_65 
       (.I0(\prev_reg_n_0_[12] ),
        .I1(prev2[12]),
        .O(\ring_ssc[3][4]_i_65_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_ssc[3][4]_i_66 
       (.I0(\ring_ssc_reg[3][4]_i_40_n_7 ),
        .O(\ring_ssc[3][4]_i_66_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_ssc[3][4]_i_67 
       (.I0(\ring_ssc_reg[3][4]_i_42_n_4 ),
        .O(\ring_ssc[3][4]_i_67_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_ssc[3][4]_i_68 
       (.I0(\ring_ssc_reg[3][4]_i_42_n_5 ),
        .O(\ring_ssc[3][4]_i_68_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_ssc[3][4]_i_69 
       (.I0(\ring_ssc_reg[3][4]_i_42_n_6 ),
        .O(\ring_ssc[3][4]_i_69_n_0 ));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    \ring_ssc[3][4]_i_7 
       (.I0(\ring_ssc_reg[3][4]_i_13_n_7 ),
        .I1(\ring_ssc_reg[3][4]_i_4_n_3 ),
        .I2(ssc_event4[20]),
        .I3(\ring_ssc_reg[3][4]_i_13_n_6 ),
        .I4(ssc_event4[21]),
        .O(\ring_ssc[3][4]_i_7_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_ssc[3][4]_i_70 
       (.I0(\prev_reg_n_0_[11] ),
        .I1(prev2[11]),
        .O(\ring_ssc[3][4]_i_70_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_ssc[3][4]_i_71 
       (.I0(\prev_reg_n_0_[10] ),
        .I1(prev2[10]),
        .O(\ring_ssc[3][4]_i_71_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_ssc[3][4]_i_72 
       (.I0(\prev_reg_n_0_[9] ),
        .I1(prev2[9]),
        .O(\ring_ssc[3][4]_i_72_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_ssc[3][4]_i_73 
       (.I0(\prev_reg_n_0_[8] ),
        .I1(prev2[8]),
        .O(\ring_ssc[3][4]_i_73_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_ssc[3][4]_i_74 
       (.I0(\ring_ssc_reg[3][4]_i_55_n_7 ),
        .O(\ring_ssc[3][4]_i_74_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_ssc[3][4]_i_75 
       (.I0(\ring_ssc_reg[3][4]_i_57_n_7 ),
        .O(\ring_ssc[3][4]_i_75_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_ssc[3][4]_i_76 
       (.I0(\ring_ssc_reg[3][4]_i_55_n_4 ),
        .O(\ring_ssc[3][4]_i_76_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_ssc[3][4]_i_77 
       (.I0(\ring_ssc_reg[3][4]_i_55_n_5 ),
        .O(\ring_ssc[3][4]_i_77_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_ssc[3][4]_i_78 
       (.I0(\ring_ssc_reg[3][4]_i_55_n_6 ),
        .O(\ring_ssc[3][4]_i_78_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_ssc[3][4]_i_79 
       (.I0(\prev_reg_n_0_[3] ),
        .I1(prev2[3]),
        .O(\ring_ssc[3][4]_i_79_n_0 ));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    \ring_ssc[3][4]_i_8 
       (.I0(\ring_ssc_reg[3][4]_i_25_n_5 ),
        .I1(\ring_ssc_reg[3][4]_i_4_n_3 ),
        .I2(ssc_event4[18]),
        .I3(\ring_ssc_reg[3][4]_i_25_n_4 ),
        .I4(ssc_event4[19]),
        .O(\ring_ssc[3][4]_i_8_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_ssc[3][4]_i_80 
       (.I0(\prev_reg_n_0_[2] ),
        .I1(prev2[2]),
        .O(\ring_ssc[3][4]_i_80_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_ssc[3][4]_i_81 
       (.I0(\prev_reg_n_0_[1] ),
        .I1(prev2[1]),
        .O(\ring_ssc[3][4]_i_81_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_ssc[3][4]_i_82 
       (.I0(\prev_reg_n_0_[0] ),
        .I1(prev2[0]),
        .O(\ring_ssc[3][4]_i_82_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_ssc[3][4]_i_83 
       (.I0(\ring_ssc_reg[3][4]_i_42_n_7 ),
        .O(\ring_ssc[3][4]_i_83_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_ssc[3][4]_i_84 
       (.I0(\ring_ssc_reg[3][4]_i_57_n_4 ),
        .O(\ring_ssc[3][4]_i_84_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_ssc[3][4]_i_85 
       (.I0(\ring_ssc_reg[3][4]_i_57_n_5 ),
        .O(\ring_ssc[3][4]_i_85_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_ssc[3][4]_i_86 
       (.I0(\ring_ssc_reg[3][4]_i_57_n_6 ),
        .O(\ring_ssc[3][4]_i_86_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_ssc[3][4]_i_87 
       (.I0(\prev_reg_n_0_[7] ),
        .I1(prev2[7]),
        .O(\ring_ssc[3][4]_i_87_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_ssc[3][4]_i_88 
       (.I0(\prev_reg_n_0_[6] ),
        .I1(prev2[6]),
        .O(\ring_ssc[3][4]_i_88_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_ssc[3][4]_i_89 
       (.I0(\prev_reg_n_0_[5] ),
        .I1(prev2[5]),
        .O(\ring_ssc[3][4]_i_89_n_0 ));
  LUT2 #(
    .INIT(4'hB)) 
    \ring_ssc[3][4]_i_9 
       (.I0(\ring_ssc_reg[3][4]_i_4_n_3 ),
        .I1(ssc_event4[24]),
        .O(\ring_ssc[3][4]_i_9_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_ssc[3][4]_i_90 
       (.I0(\prev_reg_n_0_[4] ),
        .I1(prev2[4]),
        .O(\ring_ssc[3][4]_i_90_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \ring_ssc[3][5]_i_1 
       (.I0(\ring_ssc[3][6]_i_2_n_0 ),
        .I1(seg_ssc_reg[5]),
        .O(\ring_ssc[3][5]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair117" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \ring_ssc[3][6]_i_1 
       (.I0(\ring_ssc[3][6]_i_2_n_0 ),
        .I1(seg_ssc_reg[5]),
        .I2(seg_ssc_reg[6]),
        .O(\ring_ssc[3][6]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8000000000000000)) 
    \ring_ssc[3][6]_i_2 
       (.I0(seg_ssc_reg[4]),
        .I1(seg_ssc_reg[2]),
        .I2(ssc_event),
        .I3(seg_ssc_reg[0]),
        .I4(seg_ssc_reg[1]),
        .I5(seg_ssc_reg[3]),
        .O(\ring_ssc[3][6]_i_2_n_0 ));
  FDRE \ring_ssc_reg[0][0] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_ssc[3][0]_i_1_n_0 ),
        .Q(\ring_ssc_reg_n_0_[0][0] ),
        .R(clear));
  FDRE \ring_ssc_reg[0][1] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_ssc[3][1]_i_1_n_0 ),
        .Q(\ring_ssc_reg_n_0_[0][1] ),
        .R(clear));
  FDRE \ring_ssc_reg[0][2] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_ssc[3][2]_i_1_n_0 ),
        .Q(\ring_ssc_reg_n_0_[0][2] ),
        .R(clear));
  FDRE \ring_ssc_reg[0][3] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_ssc[3][3]_i_1_n_0 ),
        .Q(\ring_ssc_reg_n_0_[0][3] ),
        .R(clear));
  FDRE \ring_ssc_reg[0][4] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_ssc[3][4]_i_1_n_0 ),
        .Q(\ring_ssc_reg_n_0_[0][4] ),
        .R(clear));
  FDRE \ring_ssc_reg[0][5] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_ssc[3][5]_i_1_n_0 ),
        .Q(\ring_ssc_reg_n_0_[0][5] ),
        .R(clear));
  FDRE \ring_ssc_reg[0][6] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_ssc[3][6]_i_1_n_0 ),
        .Q(\ring_ssc_reg_n_0_[0][6] ),
        .R(clear));
  FDRE \ring_ssc_reg[1][0] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_ssc[3][0]_i_1_n_0 ),
        .Q(\ring_ssc_reg_n_0_[1][0] ),
        .R(clear));
  FDRE \ring_ssc_reg[1][1] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_ssc[3][1]_i_1_n_0 ),
        .Q(\ring_ssc_reg_n_0_[1][1] ),
        .R(clear));
  FDRE \ring_ssc_reg[1][2] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_ssc[3][2]_i_1_n_0 ),
        .Q(\ring_ssc_reg_n_0_[1][2] ),
        .R(clear));
  FDRE \ring_ssc_reg[1][3] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_ssc[3][3]_i_1_n_0 ),
        .Q(\ring_ssc_reg_n_0_[1][3] ),
        .R(clear));
  FDRE \ring_ssc_reg[1][4] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_ssc[3][4]_i_1_n_0 ),
        .Q(\ring_ssc_reg_n_0_[1][4] ),
        .R(clear));
  FDRE \ring_ssc_reg[1][5] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_ssc[3][5]_i_1_n_0 ),
        .Q(\ring_ssc_reg_n_0_[1][5] ),
        .R(clear));
  FDRE \ring_ssc_reg[1][6] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_ssc[3][6]_i_1_n_0 ),
        .Q(\ring_ssc_reg_n_0_[1][6] ),
        .R(clear));
  FDRE \ring_ssc_reg[2][0] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_ssc[3][0]_i_1_n_0 ),
        .Q(\ring_ssc_reg_n_0_[2][0] ),
        .R(clear));
  FDRE \ring_ssc_reg[2][1] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_ssc[3][1]_i_1_n_0 ),
        .Q(\ring_ssc_reg_n_0_[2][1] ),
        .R(clear));
  FDRE \ring_ssc_reg[2][2] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_ssc[3][2]_i_1_n_0 ),
        .Q(\ring_ssc_reg_n_0_[2][2] ),
        .R(clear));
  FDRE \ring_ssc_reg[2][3] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_ssc[3][3]_i_1_n_0 ),
        .Q(\ring_ssc_reg_n_0_[2][3] ),
        .R(clear));
  FDRE \ring_ssc_reg[2][4] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_ssc[3][4]_i_1_n_0 ),
        .Q(\ring_ssc_reg_n_0_[2][4] ),
        .R(clear));
  FDRE \ring_ssc_reg[2][5] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_ssc[3][5]_i_1_n_0 ),
        .Q(\ring_ssc_reg_n_0_[2][5] ),
        .R(clear));
  FDRE \ring_ssc_reg[2][6] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_ssc[3][6]_i_1_n_0 ),
        .Q(\ring_ssc_reg_n_0_[2][6] ),
        .R(clear));
  FDRE \ring_ssc_reg[3][0] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_ssc[3][0]_i_1_n_0 ),
        .Q(\ring_ssc_reg_n_0_[3][0] ),
        .R(clear));
  FDRE \ring_ssc_reg[3][1] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_ssc[3][1]_i_1_n_0 ),
        .Q(\ring_ssc_reg_n_0_[3][1] ),
        .R(clear));
  FDRE \ring_ssc_reg[3][2] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_ssc[3][2]_i_1_n_0 ),
        .Q(\ring_ssc_reg_n_0_[3][2] ),
        .R(clear));
  FDRE \ring_ssc_reg[3][3] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_ssc[3][3]_i_1_n_0 ),
        .Q(\ring_ssc_reg_n_0_[3][3] ),
        .R(clear));
  FDRE \ring_ssc_reg[3][4] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_ssc[3][4]_i_1_n_0 ),
        .Q(\ring_ssc_reg_n_0_[3][4] ),
        .R(clear));
  CARRY4 \ring_ssc_reg[3][4]_i_13 
       (.CI(\ring_ssc_reg[3][4]_i_25_n_0 ),
        .CO({\ring_ssc_reg[3][4]_i_13_n_0 ,\ring_ssc_reg[3][4]_i_13_n_1 ,\ring_ssc_reg[3][4]_i_13_n_2 ,\ring_ssc_reg[3][4]_i_13_n_3 }),
        .CYINIT(1'b0),
        .DI({prev2[23],\prev_reg_n_0_[22] ,\prev_reg_n_0_[21] ,\prev_reg_n_0_[20] }),
        .O({\ring_ssc_reg[3][4]_i_13_n_4 ,\ring_ssc_reg[3][4]_i_13_n_5 ,\ring_ssc_reg[3][4]_i_13_n_6 ,\ring_ssc_reg[3][4]_i_13_n_7 }),
        .S({\ring_ssc[3][4]_i_26_n_0 ,\ring_ssc[3][4]_i_27_n_0 ,\ring_ssc[3][4]_i_28_n_0 ,\ring_ssc[3][4]_i_29_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \ring_ssc_reg[3][4]_i_14 
       (.CI(1'b0),
        .CO({\ring_ssc_reg[3][4]_i_14_n_0 ,\ring_ssc_reg[3][4]_i_14_n_1 ,\ring_ssc_reg[3][4]_i_14_n_2 ,\ring_ssc_reg[3][4]_i_14_n_3 }),
        .CYINIT(\ring_ssc[3][4]_i_30_n_0 ),
        .DI({\ring_ssc[3][4]_i_31_n_0 ,\ring_ssc[3][4]_i_32_n_0 ,\ring_ssc[3][4]_i_33_n_0 ,\ring_ssc[3][4]_i_34_n_0 }),
        .O(\NLW_ring_ssc_reg[3][4]_i_14_O_UNCONNECTED [3:0]),
        .S({\ring_ssc[3][4]_i_35_n_0 ,\ring_ssc[3][4]_i_36_n_0 ,\ring_ssc[3][4]_i_37_n_0 ,\ring_ssc[3][4]_i_38_n_0 }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ring_ssc_reg[3][4]_i_23 
       (.CI(\ring_ssc_reg[3][4]_i_24_n_0 ),
        .CO({\NLW_ring_ssc_reg[3][4]_i_23_CO_UNCONNECTED [3],\ring_ssc_reg[3][4]_i_23_n_1 ,\ring_ssc_reg[3][4]_i_23_n_2 ,\ring_ssc_reg[3][4]_i_23_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(ssc_event4[24:21]),
        .S({\ring_ssc_reg[3][4]_i_4_n_3 ,\ring_ssc[3][4]_i_43_n_0 ,\ring_ssc[3][4]_i_44_n_0 ,\ring_ssc[3][4]_i_45_n_0 }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ring_ssc_reg[3][4]_i_24 
       (.CI(\ring_ssc_reg[3][4]_i_39_n_0 ),
        .CO({\ring_ssc_reg[3][4]_i_24_n_0 ,\ring_ssc_reg[3][4]_i_24_n_1 ,\ring_ssc_reg[3][4]_i_24_n_2 ,\ring_ssc_reg[3][4]_i_24_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(ssc_event4[20:17]),
        .S({\ring_ssc[3][4]_i_46_n_0 ,\ring_ssc[3][4]_i_47_n_0 ,\ring_ssc[3][4]_i_48_n_0 ,\ring_ssc[3][4]_i_49_n_0 }));
  CARRY4 \ring_ssc_reg[3][4]_i_25 
       (.CI(\ring_ssc_reg[3][4]_i_40_n_0 ),
        .CO({\ring_ssc_reg[3][4]_i_25_n_0 ,\ring_ssc_reg[3][4]_i_25_n_1 ,\ring_ssc_reg[3][4]_i_25_n_2 ,\ring_ssc_reg[3][4]_i_25_n_3 }),
        .CYINIT(1'b0),
        .DI({\prev_reg_n_0_[19] ,\prev_reg_n_0_[18] ,\prev_reg_n_0_[17] ,\prev_reg_n_0_[16] }),
        .O({\ring_ssc_reg[3][4]_i_25_n_4 ,\ring_ssc_reg[3][4]_i_25_n_5 ,\ring_ssc_reg[3][4]_i_25_n_6 ,\ring_ssc_reg[3][4]_i_25_n_7 }),
        .S({\ring_ssc[3][4]_i_50_n_0 ,\ring_ssc[3][4]_i_51_n_0 ,\ring_ssc[3][4]_i_52_n_0 ,\ring_ssc[3][4]_i_53_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \ring_ssc_reg[3][4]_i_3 
       (.CI(\ring_ssc_reg[3][4]_i_5_n_0 ),
        .CO({\ring_ssc_reg[3][4]_i_3_n_0 ,\ring_ssc_reg[3][4]_i_3_n_1 ,\ring_ssc_reg[3][4]_i_3_n_2 ,\ring_ssc_reg[3][4]_i_3_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,\ring_ssc[3][4]_i_6_n_0 ,\ring_ssc[3][4]_i_7_n_0 ,\ring_ssc[3][4]_i_8_n_0 }),
        .O(\NLW_ring_ssc_reg[3][4]_i_3_O_UNCONNECTED [3:0]),
        .S({\ring_ssc[3][4]_i_9_n_0 ,\ring_ssc[3][4]_i_10_n_0 ,\ring_ssc[3][4]_i_11_n_0 ,\ring_ssc[3][4]_i_12_n_0 }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ring_ssc_reg[3][4]_i_39 
       (.CI(\ring_ssc_reg[3][4]_i_41_n_0 ),
        .CO({\ring_ssc_reg[3][4]_i_39_n_0 ,\ring_ssc_reg[3][4]_i_39_n_1 ,\ring_ssc_reg[3][4]_i_39_n_2 ,\ring_ssc_reg[3][4]_i_39_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(ssc_event4[16:13]),
        .S({\ring_ssc[3][4]_i_58_n_0 ,\ring_ssc[3][4]_i_59_n_0 ,\ring_ssc[3][4]_i_60_n_0 ,\ring_ssc[3][4]_i_61_n_0 }));
  CARRY4 \ring_ssc_reg[3][4]_i_4 
       (.CI(\ring_ssc_reg[3][4]_i_13_n_0 ),
        .CO({\NLW_ring_ssc_reg[3][4]_i_4_CO_UNCONNECTED [3:1],\ring_ssc_reg[3][4]_i_4_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(\NLW_ring_ssc_reg[3][4]_i_4_O_UNCONNECTED [3:0]),
        .S({1'b0,1'b0,1'b0,1'b1}));
  CARRY4 \ring_ssc_reg[3][4]_i_40 
       (.CI(\ring_ssc_reg[3][4]_i_42_n_0 ),
        .CO({\ring_ssc_reg[3][4]_i_40_n_0 ,\ring_ssc_reg[3][4]_i_40_n_1 ,\ring_ssc_reg[3][4]_i_40_n_2 ,\ring_ssc_reg[3][4]_i_40_n_3 }),
        .CYINIT(1'b0),
        .DI({\prev_reg_n_0_[15] ,\prev_reg_n_0_[14] ,\prev_reg_n_0_[13] ,\prev_reg_n_0_[12] }),
        .O({\ring_ssc_reg[3][4]_i_40_n_4 ,\ring_ssc_reg[3][4]_i_40_n_5 ,\ring_ssc_reg[3][4]_i_40_n_6 ,\ring_ssc_reg[3][4]_i_40_n_7 }),
        .S({\ring_ssc[3][4]_i_62_n_0 ,\ring_ssc[3][4]_i_63_n_0 ,\ring_ssc[3][4]_i_64_n_0 ,\ring_ssc[3][4]_i_65_n_0 }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ring_ssc_reg[3][4]_i_41 
       (.CI(\ring_ssc_reg[3][4]_i_56_n_0 ),
        .CO({\ring_ssc_reg[3][4]_i_41_n_0 ,\ring_ssc_reg[3][4]_i_41_n_1 ,\ring_ssc_reg[3][4]_i_41_n_2 ,\ring_ssc_reg[3][4]_i_41_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(ssc_event4[12:9]),
        .S({\ring_ssc[3][4]_i_66_n_0 ,\ring_ssc[3][4]_i_67_n_0 ,\ring_ssc[3][4]_i_68_n_0 ,\ring_ssc[3][4]_i_69_n_0 }));
  CARRY4 \ring_ssc_reg[3][4]_i_42 
       (.CI(\ring_ssc_reg[3][4]_i_57_n_0 ),
        .CO({\ring_ssc_reg[3][4]_i_42_n_0 ,\ring_ssc_reg[3][4]_i_42_n_1 ,\ring_ssc_reg[3][4]_i_42_n_2 ,\ring_ssc_reg[3][4]_i_42_n_3 }),
        .CYINIT(1'b0),
        .DI({\prev_reg_n_0_[11] ,\prev_reg_n_0_[10] ,\prev_reg_n_0_[9] ,\prev_reg_n_0_[8] }),
        .O({\ring_ssc_reg[3][4]_i_42_n_4 ,\ring_ssc_reg[3][4]_i_42_n_5 ,\ring_ssc_reg[3][4]_i_42_n_6 ,\ring_ssc_reg[3][4]_i_42_n_7 }),
        .S({\ring_ssc[3][4]_i_70_n_0 ,\ring_ssc[3][4]_i_71_n_0 ,\ring_ssc[3][4]_i_72_n_0 ,\ring_ssc[3][4]_i_73_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \ring_ssc_reg[3][4]_i_5 
       (.CI(\ring_ssc_reg[3][4]_i_14_n_0 ),
        .CO({\ring_ssc_reg[3][4]_i_5_n_0 ,\ring_ssc_reg[3][4]_i_5_n_1 ,\ring_ssc_reg[3][4]_i_5_n_2 ,\ring_ssc_reg[3][4]_i_5_n_3 }),
        .CYINIT(1'b0),
        .DI({\ring_ssc[3][4]_i_15_n_0 ,\ring_ssc[3][4]_i_16_n_0 ,\ring_ssc[3][4]_i_17_n_0 ,\ring_ssc[3][4]_i_18_n_0 }),
        .O(\NLW_ring_ssc_reg[3][4]_i_5_O_UNCONNECTED [3:0]),
        .S({\ring_ssc[3][4]_i_19_n_0 ,\ring_ssc[3][4]_i_20_n_0 ,\ring_ssc[3][4]_i_21_n_0 ,\ring_ssc[3][4]_i_22_n_0 }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ring_ssc_reg[3][4]_i_54 
       (.CI(1'b0),
        .CO({\ring_ssc_reg[3][4]_i_54_n_0 ,\ring_ssc_reg[3][4]_i_54_n_1 ,\ring_ssc_reg[3][4]_i_54_n_2 ,\ring_ssc_reg[3][4]_i_54_n_3 }),
        .CYINIT(\ring_ssc[3][4]_i_74_n_0 ),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(ssc_event4[4:1]),
        .S({\ring_ssc[3][4]_i_75_n_0 ,\ring_ssc[3][4]_i_76_n_0 ,\ring_ssc[3][4]_i_77_n_0 ,\ring_ssc[3][4]_i_78_n_0 }));
  CARRY4 \ring_ssc_reg[3][4]_i_55 
       (.CI(1'b0),
        .CO({\ring_ssc_reg[3][4]_i_55_n_0 ,\ring_ssc_reg[3][4]_i_55_n_1 ,\ring_ssc_reg[3][4]_i_55_n_2 ,\ring_ssc_reg[3][4]_i_55_n_3 }),
        .CYINIT(1'b1),
        .DI({\prev_reg_n_0_[3] ,\prev_reg_n_0_[2] ,\prev_reg_n_0_[1] ,\prev_reg_n_0_[0] }),
        .O({\ring_ssc_reg[3][4]_i_55_n_4 ,\ring_ssc_reg[3][4]_i_55_n_5 ,\ring_ssc_reg[3][4]_i_55_n_6 ,\ring_ssc_reg[3][4]_i_55_n_7 }),
        .S({\ring_ssc[3][4]_i_79_n_0 ,\ring_ssc[3][4]_i_80_n_0 ,\ring_ssc[3][4]_i_81_n_0 ,\ring_ssc[3][4]_i_82_n_0 }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ring_ssc_reg[3][4]_i_56 
       (.CI(\ring_ssc_reg[3][4]_i_54_n_0 ),
        .CO({\ring_ssc_reg[3][4]_i_56_n_0 ,\ring_ssc_reg[3][4]_i_56_n_1 ,\ring_ssc_reg[3][4]_i_56_n_2 ,\ring_ssc_reg[3][4]_i_56_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(ssc_event4[8:5]),
        .S({\ring_ssc[3][4]_i_83_n_0 ,\ring_ssc[3][4]_i_84_n_0 ,\ring_ssc[3][4]_i_85_n_0 ,\ring_ssc[3][4]_i_86_n_0 }));
  CARRY4 \ring_ssc_reg[3][4]_i_57 
       (.CI(\ring_ssc_reg[3][4]_i_55_n_0 ),
        .CO({\ring_ssc_reg[3][4]_i_57_n_0 ,\ring_ssc_reg[3][4]_i_57_n_1 ,\ring_ssc_reg[3][4]_i_57_n_2 ,\ring_ssc_reg[3][4]_i_57_n_3 }),
        .CYINIT(1'b0),
        .DI({\prev_reg_n_0_[7] ,\prev_reg_n_0_[6] ,\prev_reg_n_0_[5] ,\prev_reg_n_0_[4] }),
        .O({\ring_ssc_reg[3][4]_i_57_n_4 ,\ring_ssc_reg[3][4]_i_57_n_5 ,\ring_ssc_reg[3][4]_i_57_n_6 ,\ring_ssc_reg[3][4]_i_57_n_7 }),
        .S({\ring_ssc[3][4]_i_87_n_0 ,\ring_ssc[3][4]_i_88_n_0 ,\ring_ssc[3][4]_i_89_n_0 ,\ring_ssc[3][4]_i_90_n_0 }));
  FDRE \ring_ssc_reg[3][5] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_ssc[3][5]_i_1_n_0 ),
        .Q(\ring_ssc_reg_n_0_[3][5] ),
        .R(clear));
  FDRE \ring_ssc_reg[3][6] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_ssc[3][6]_i_1_n_0 ),
        .Q(\ring_ssc_reg_n_0_[3][6] ),
        .R(clear));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_wl[3][11]_i_10 
       (.I0(sample_in[9]),
        .I1(\prev_reg_n_0_[9] ),
        .O(\ring_wl[3][11]_i_10_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_wl[3][11]_i_11 
       (.I0(sample_in[8]),
        .I1(\prev_reg_n_0_[8] ),
        .O(\ring_wl[3][11]_i_11_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_wl[3][11]_i_12 
       (.I0(\ring_wl_reg[3][11]_i_6_n_7 ),
        .O(\ring_wl[3][11]_i_12_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_wl[3][11]_i_13 
       (.I0(\ring_wl_reg[3][7]_i_6_n_4 ),
        .O(\ring_wl[3][11]_i_13_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_wl[3][11]_i_14 
       (.I0(\ring_wl_reg[3][7]_i_6_n_5 ),
        .O(\ring_wl[3][11]_i_14_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_wl[3][11]_i_15 
       (.I0(\ring_wl_reg[3][7]_i_6_n_6 ),
        .O(\ring_wl[3][11]_i_15_n_0 ));
  LUT5 #(
    .INIT(32'h656AAAAA)) 
    \ring_wl[3][11]_i_2 
       (.I0(seg_wl_reg[11]),
        .I1(\ring_wl_reg[3][11]_i_6_n_4 ),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(abs_diff1[11]),
        .I4(have_prev),
        .O(\ring_wl[3][11]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h656AAAAA)) 
    \ring_wl[3][11]_i_3 
       (.I0(seg_wl_reg[10]),
        .I1(\ring_wl_reg[3][11]_i_6_n_5 ),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(abs_diff1[10]),
        .I4(have_prev),
        .O(\ring_wl[3][11]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'h656AAAAA)) 
    \ring_wl[3][11]_i_4 
       (.I0(seg_wl_reg[9]),
        .I1(\ring_wl_reg[3][11]_i_6_n_6 ),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(abs_diff1[9]),
        .I4(have_prev),
        .O(\ring_wl[3][11]_i_4_n_0 ));
  LUT5 #(
    .INIT(32'h656AAAAA)) 
    \ring_wl[3][11]_i_5 
       (.I0(seg_wl_reg[8]),
        .I1(\ring_wl_reg[3][11]_i_6_n_7 ),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(abs_diff1[8]),
        .I4(have_prev),
        .O(\ring_wl[3][11]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_wl[3][11]_i_8 
       (.I0(sample_in[11]),
        .I1(\prev_reg_n_0_[11] ),
        .O(\ring_wl[3][11]_i_8_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_wl[3][11]_i_9 
       (.I0(sample_in[10]),
        .I1(\prev_reg_n_0_[10] ),
        .O(\ring_wl[3][11]_i_9_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_wl[3][15]_i_10 
       (.I0(sample_in[13]),
        .I1(\prev_reg_n_0_[13] ),
        .O(\ring_wl[3][15]_i_10_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_wl[3][15]_i_11 
       (.I0(sample_in[12]),
        .I1(\prev_reg_n_0_[12] ),
        .O(\ring_wl[3][15]_i_11_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_wl[3][15]_i_12 
       (.I0(\ring_wl_reg[3][15]_i_6_n_7 ),
        .O(\ring_wl[3][15]_i_12_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_wl[3][15]_i_13 
       (.I0(\ring_wl_reg[3][11]_i_6_n_4 ),
        .O(\ring_wl[3][15]_i_13_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_wl[3][15]_i_14 
       (.I0(\ring_wl_reg[3][11]_i_6_n_5 ),
        .O(\ring_wl[3][15]_i_14_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_wl[3][15]_i_15 
       (.I0(\ring_wl_reg[3][11]_i_6_n_6 ),
        .O(\ring_wl[3][15]_i_15_n_0 ));
  LUT5 #(
    .INIT(32'h656AAAAA)) 
    \ring_wl[3][15]_i_2 
       (.I0(seg_wl_reg[15]),
        .I1(\ring_wl_reg[3][15]_i_6_n_4 ),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(abs_diff1[15]),
        .I4(have_prev),
        .O(\ring_wl[3][15]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h656AAAAA)) 
    \ring_wl[3][15]_i_3 
       (.I0(seg_wl_reg[14]),
        .I1(\ring_wl_reg[3][15]_i_6_n_5 ),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(abs_diff1[14]),
        .I4(have_prev),
        .O(\ring_wl[3][15]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'h656AAAAA)) 
    \ring_wl[3][15]_i_4 
       (.I0(seg_wl_reg[13]),
        .I1(\ring_wl_reg[3][15]_i_6_n_6 ),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(abs_diff1[13]),
        .I4(have_prev),
        .O(\ring_wl[3][15]_i_4_n_0 ));
  LUT5 #(
    .INIT(32'h656AAAAA)) 
    \ring_wl[3][15]_i_5 
       (.I0(seg_wl_reg[12]),
        .I1(\ring_wl_reg[3][15]_i_6_n_7 ),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(abs_diff1[12]),
        .I4(have_prev),
        .O(\ring_wl[3][15]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_wl[3][15]_i_8 
       (.I0(sample_in[15]),
        .I1(\prev_reg_n_0_[15] ),
        .O(\ring_wl[3][15]_i_8_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_wl[3][15]_i_9 
       (.I0(sample_in[14]),
        .I1(\prev_reg_n_0_[14] ),
        .O(\ring_wl[3][15]_i_9_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_wl[3][19]_i_10 
       (.I0(sample_in[17]),
        .I1(\prev_reg_n_0_[17] ),
        .O(\ring_wl[3][19]_i_10_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_wl[3][19]_i_11 
       (.I0(sample_in[16]),
        .I1(\prev_reg_n_0_[16] ),
        .O(\ring_wl[3][19]_i_11_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_wl[3][19]_i_12 
       (.I0(\ring_wl_reg[3][19]_i_6_n_7 ),
        .O(\ring_wl[3][19]_i_12_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_wl[3][19]_i_13 
       (.I0(\ring_wl_reg[3][15]_i_6_n_4 ),
        .O(\ring_wl[3][19]_i_13_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_wl[3][19]_i_14 
       (.I0(\ring_wl_reg[3][15]_i_6_n_5 ),
        .O(\ring_wl[3][19]_i_14_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_wl[3][19]_i_15 
       (.I0(\ring_wl_reg[3][15]_i_6_n_6 ),
        .O(\ring_wl[3][19]_i_15_n_0 ));
  LUT5 #(
    .INIT(32'h656AAAAA)) 
    \ring_wl[3][19]_i_2 
       (.I0(seg_wl_reg[19]),
        .I1(\ring_wl_reg[3][19]_i_6_n_4 ),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(abs_diff1[19]),
        .I4(have_prev),
        .O(\ring_wl[3][19]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h656AAAAA)) 
    \ring_wl[3][19]_i_3 
       (.I0(seg_wl_reg[18]),
        .I1(\ring_wl_reg[3][19]_i_6_n_5 ),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(abs_diff1[18]),
        .I4(have_prev),
        .O(\ring_wl[3][19]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'h656AAAAA)) 
    \ring_wl[3][19]_i_4 
       (.I0(seg_wl_reg[17]),
        .I1(\ring_wl_reg[3][19]_i_6_n_6 ),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(abs_diff1[17]),
        .I4(have_prev),
        .O(\ring_wl[3][19]_i_4_n_0 ));
  LUT5 #(
    .INIT(32'h656AAAAA)) 
    \ring_wl[3][19]_i_5 
       (.I0(seg_wl_reg[16]),
        .I1(\ring_wl_reg[3][19]_i_6_n_7 ),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(abs_diff1[16]),
        .I4(have_prev),
        .O(\ring_wl[3][19]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_wl[3][19]_i_8 
       (.I0(sample_in[19]),
        .I1(\prev_reg_n_0_[19] ),
        .O(\ring_wl[3][19]_i_8_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_wl[3][19]_i_9 
       (.I0(sample_in[18]),
        .I1(\prev_reg_n_0_[18] ),
        .O(\ring_wl[3][19]_i_9_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_wl[3][23]_i_10 
       (.I0(sample_in[21]),
        .I1(\prev_reg_n_0_[21] ),
        .O(\ring_wl[3][23]_i_10_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_wl[3][23]_i_11 
       (.I0(sample_in[20]),
        .I1(\prev_reg_n_0_[20] ),
        .O(\ring_wl[3][23]_i_11_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_wl[3][23]_i_12 
       (.I0(\ring_wl_reg[3][23]_i_6_n_7 ),
        .O(\ring_wl[3][23]_i_12_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_wl[3][23]_i_13 
       (.I0(\ring_wl_reg[3][19]_i_6_n_4 ),
        .O(\ring_wl[3][23]_i_13_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_wl[3][23]_i_14 
       (.I0(\ring_wl_reg[3][19]_i_6_n_5 ),
        .O(\ring_wl[3][23]_i_14_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_wl[3][23]_i_15 
       (.I0(\ring_wl_reg[3][19]_i_6_n_6 ),
        .O(\ring_wl[3][23]_i_15_n_0 ));
  LUT5 #(
    .INIT(32'h656AAAAA)) 
    \ring_wl[3][23]_i_2 
       (.I0(seg_wl_reg[23]),
        .I1(\ring_wl_reg[3][23]_i_6_n_4 ),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(abs_diff1[23]),
        .I4(have_prev),
        .O(\ring_wl[3][23]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h656AAAAA)) 
    \ring_wl[3][23]_i_3 
       (.I0(seg_wl_reg[22]),
        .I1(\ring_wl_reg[3][23]_i_6_n_5 ),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(abs_diff1[22]),
        .I4(have_prev),
        .O(\ring_wl[3][23]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'h656AAAAA)) 
    \ring_wl[3][23]_i_4 
       (.I0(seg_wl_reg[21]),
        .I1(\ring_wl_reg[3][23]_i_6_n_6 ),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(abs_diff1[21]),
        .I4(have_prev),
        .O(\ring_wl[3][23]_i_4_n_0 ));
  LUT5 #(
    .INIT(32'h656AAAAA)) 
    \ring_wl[3][23]_i_5 
       (.I0(seg_wl_reg[20]),
        .I1(\ring_wl_reg[3][23]_i_6_n_7 ),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(abs_diff1[20]),
        .I4(have_prev),
        .O(\ring_wl[3][23]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_wl[3][23]_i_8 
       (.I0(sample_in[23]),
        .I1(p_0_in0_in),
        .O(\ring_wl[3][23]_i_8_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_wl[3][23]_i_9 
       (.I0(sample_in[22]),
        .I1(\prev_reg_n_0_[22] ),
        .O(\ring_wl[3][23]_i_9_n_0 ));
  LUT4 #(
    .INIT(16'hAA6A)) 
    \ring_wl[3][27]_i_2 
       (.I0(seg_wl_reg[24]),
        .I1(abs_diff1[24]),
        .I2(have_prev),
        .I3(\ring_wl_reg[3][27]_i_4_n_3 ),
        .O(\ring_wl[3][27]_i_2_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_wl[3][27]_i_5 
       (.I0(\ring_wl_reg[3][23]_i_6_n_4 ),
        .O(\ring_wl[3][27]_i_5_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_wl[3][27]_i_6 
       (.I0(\ring_wl_reg[3][23]_i_6_n_5 ),
        .O(\ring_wl[3][27]_i_6_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_wl[3][27]_i_7 
       (.I0(\ring_wl_reg[3][23]_i_6_n_6 ),
        .O(\ring_wl[3][27]_i_7_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_wl[3][3]_i_10 
       (.I0(sample_in[0]),
        .I1(\prev_reg_n_0_[0] ),
        .O(\ring_wl[3][3]_i_10_n_0 ));
  LUT5 #(
    .INIT(32'h656AAAAA)) 
    \ring_wl[3][3]_i_2 
       (.I0(seg_wl_reg[3]),
        .I1(\ring_wl_reg[3][3]_i_6_n_4 ),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(abs_diff1[3]),
        .I4(have_prev),
        .O(\ring_wl[3][3]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h656AAAAA)) 
    \ring_wl[3][3]_i_3 
       (.I0(seg_wl_reg[2]),
        .I1(\ring_wl_reg[3][3]_i_6_n_5 ),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(abs_diff1[2]),
        .I4(have_prev),
        .O(\ring_wl[3][3]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'h656AAAAA)) 
    \ring_wl[3][3]_i_4 
       (.I0(seg_wl_reg[1]),
        .I1(\ring_wl_reg[3][3]_i_6_n_6 ),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(abs_diff1[1]),
        .I4(have_prev),
        .O(\ring_wl[3][3]_i_4_n_0 ));
  LUT3 #(
    .INIT(8'h6A)) 
    \ring_wl[3][3]_i_5 
       (.I0(seg_wl_reg[0]),
        .I1(\ring_wl_reg[3][3]_i_6_n_7 ),
        .I2(have_prev),
        .O(\ring_wl[3][3]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_wl[3][3]_i_7 
       (.I0(sample_in[3]),
        .I1(\prev_reg_n_0_[3] ),
        .O(\ring_wl[3][3]_i_7_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_wl[3][3]_i_8 
       (.I0(sample_in[2]),
        .I1(\prev_reg_n_0_[2] ),
        .O(\ring_wl[3][3]_i_8_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_wl[3][3]_i_9 
       (.I0(sample_in[1]),
        .I1(\prev_reg_n_0_[1] ),
        .O(\ring_wl[3][3]_i_9_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_wl[3][7]_i_10 
       (.I0(sample_in[5]),
        .I1(\prev_reg_n_0_[5] ),
        .O(\ring_wl[3][7]_i_10_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_wl[3][7]_i_11 
       (.I0(sample_in[4]),
        .I1(\prev_reg_n_0_[4] ),
        .O(\ring_wl[3][7]_i_11_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_wl[3][7]_i_12 
       (.I0(\ring_wl_reg[3][3]_i_6_n_7 ),
        .O(\ring_wl[3][7]_i_12_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_wl[3][7]_i_13 
       (.I0(\ring_wl_reg[3][7]_i_6_n_7 ),
        .O(\ring_wl[3][7]_i_13_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_wl[3][7]_i_14 
       (.I0(\ring_wl_reg[3][3]_i_6_n_4 ),
        .O(\ring_wl[3][7]_i_14_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_wl[3][7]_i_15 
       (.I0(\ring_wl_reg[3][3]_i_6_n_5 ),
        .O(\ring_wl[3][7]_i_15_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ring_wl[3][7]_i_16 
       (.I0(\ring_wl_reg[3][3]_i_6_n_6 ),
        .O(\ring_wl[3][7]_i_16_n_0 ));
  LUT5 #(
    .INIT(32'h656AAAAA)) 
    \ring_wl[3][7]_i_2 
       (.I0(seg_wl_reg[7]),
        .I1(\ring_wl_reg[3][7]_i_6_n_4 ),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(abs_diff1[7]),
        .I4(have_prev),
        .O(\ring_wl[3][7]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h656AAAAA)) 
    \ring_wl[3][7]_i_3 
       (.I0(seg_wl_reg[6]),
        .I1(\ring_wl_reg[3][7]_i_6_n_5 ),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(abs_diff1[6]),
        .I4(have_prev),
        .O(\ring_wl[3][7]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'h656AAAAA)) 
    \ring_wl[3][7]_i_4 
       (.I0(seg_wl_reg[5]),
        .I1(\ring_wl_reg[3][7]_i_6_n_6 ),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(abs_diff1[5]),
        .I4(have_prev),
        .O(\ring_wl[3][7]_i_4_n_0 ));
  LUT5 #(
    .INIT(32'h656AAAAA)) 
    \ring_wl[3][7]_i_5 
       (.I0(seg_wl_reg[4]),
        .I1(\ring_wl_reg[3][7]_i_6_n_7 ),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(abs_diff1[4]),
        .I4(have_prev),
        .O(\ring_wl[3][7]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_wl[3][7]_i_8 
       (.I0(sample_in[7]),
        .I1(\prev_reg_n_0_[7] ),
        .O(\ring_wl[3][7]_i_8_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \ring_wl[3][7]_i_9 
       (.I0(sample_in[6]),
        .I1(\prev_reg_n_0_[6] ),
        .O(\ring_wl[3][7]_i_9_n_0 ));
  FDRE \ring_wl_reg[0][0] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_wl_reg[3][3]_i_1_n_7 ),
        .Q(\ring_wl_reg[0] [0]),
        .R(clear));
  FDRE \ring_wl_reg[0][10] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_wl_reg[3][11]_i_1_n_5 ),
        .Q(\ring_wl_reg[0] [10]),
        .R(clear));
  FDRE \ring_wl_reg[0][11] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_wl_reg[3][11]_i_1_n_4 ),
        .Q(\ring_wl_reg[0] [11]),
        .R(clear));
  FDRE \ring_wl_reg[0][12] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_wl_reg[3][15]_i_1_n_7 ),
        .Q(\ring_wl_reg[0] [12]),
        .R(clear));
  FDRE \ring_wl_reg[0][13] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_wl_reg[3][15]_i_1_n_6 ),
        .Q(\ring_wl_reg[0] [13]),
        .R(clear));
  FDRE \ring_wl_reg[0][14] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_wl_reg[3][15]_i_1_n_5 ),
        .Q(\ring_wl_reg[0] [14]),
        .R(clear));
  FDRE \ring_wl_reg[0][15] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_wl_reg[3][15]_i_1_n_4 ),
        .Q(\ring_wl_reg[0] [15]),
        .R(clear));
  FDRE \ring_wl_reg[0][16] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_wl_reg[3][19]_i_1_n_7 ),
        .Q(\ring_wl_reg[0] [16]),
        .R(clear));
  FDRE \ring_wl_reg[0][17] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_wl_reg[3][19]_i_1_n_6 ),
        .Q(\ring_wl_reg[0] [17]),
        .R(clear));
  FDRE \ring_wl_reg[0][18] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_wl_reg[3][19]_i_1_n_5 ),
        .Q(\ring_wl_reg[0] [18]),
        .R(clear));
  FDRE \ring_wl_reg[0][19] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_wl_reg[3][19]_i_1_n_4 ),
        .Q(\ring_wl_reg[0] [19]),
        .R(clear));
  FDRE \ring_wl_reg[0][1] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_wl_reg[3][3]_i_1_n_6 ),
        .Q(\ring_wl_reg[0] [1]),
        .R(clear));
  FDRE \ring_wl_reg[0][20] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_wl_reg[3][23]_i_1_n_7 ),
        .Q(\ring_wl_reg[0] [20]),
        .R(clear));
  FDRE \ring_wl_reg[0][21] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_wl_reg[3][23]_i_1_n_6 ),
        .Q(\ring_wl_reg[0] [21]),
        .R(clear));
  FDRE \ring_wl_reg[0][22] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_wl_reg[3][23]_i_1_n_5 ),
        .Q(\ring_wl_reg[0] [22]),
        .R(clear));
  FDRE \ring_wl_reg[0][23] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_wl_reg[3][23]_i_1_n_4 ),
        .Q(\ring_wl_reg[0] [23]),
        .R(clear));
  FDRE \ring_wl_reg[0][24] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_wl_reg[3][27]_i_1_n_7 ),
        .Q(\ring_wl_reg[0] [24]),
        .R(clear));
  FDRE \ring_wl_reg[0][25] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_wl_reg[3][27]_i_1_n_6 ),
        .Q(\ring_wl_reg[0] [25]),
        .R(clear));
  FDRE \ring_wl_reg[0][26] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_wl_reg[3][27]_i_1_n_5 ),
        .Q(\ring_wl_reg[0] [26]),
        .R(clear));
  FDRE \ring_wl_reg[0][27] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_wl_reg[3][27]_i_1_n_4 ),
        .Q(\ring_wl_reg[0] [27]),
        .R(clear));
  FDRE \ring_wl_reg[0][28] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_wl_reg[3][31]_i_1_n_7 ),
        .Q(\ring_wl_reg[0] [28]),
        .R(clear));
  FDRE \ring_wl_reg[0][29] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_wl_reg[3][31]_i_1_n_6 ),
        .Q(\ring_wl_reg[0] [29]),
        .R(clear));
  FDRE \ring_wl_reg[0][2] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_wl_reg[3][3]_i_1_n_5 ),
        .Q(\ring_wl_reg[0] [2]),
        .R(clear));
  FDRE \ring_wl_reg[0][30] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_wl_reg[3][31]_i_1_n_5 ),
        .Q(\ring_wl_reg[0] [30]),
        .R(clear));
  FDRE \ring_wl_reg[0][31] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_wl_reg[3][31]_i_1_n_4 ),
        .Q(\ring_wl_reg[0] [31]),
        .R(clear));
  FDRE \ring_wl_reg[0][3] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_wl_reg[3][3]_i_1_n_4 ),
        .Q(\ring_wl_reg[0] [3]),
        .R(clear));
  FDRE \ring_wl_reg[0][4] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_wl_reg[3][7]_i_1_n_7 ),
        .Q(\ring_wl_reg[0] [4]),
        .R(clear));
  FDRE \ring_wl_reg[0][5] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_wl_reg[3][7]_i_1_n_6 ),
        .Q(\ring_wl_reg[0] [5]),
        .R(clear));
  FDRE \ring_wl_reg[0][6] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_wl_reg[3][7]_i_1_n_5 ),
        .Q(\ring_wl_reg[0] [6]),
        .R(clear));
  FDRE \ring_wl_reg[0][7] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_wl_reg[3][7]_i_1_n_4 ),
        .Q(\ring_wl_reg[0] [7]),
        .R(clear));
  FDRE \ring_wl_reg[0][8] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_wl_reg[3][11]_i_1_n_7 ),
        .Q(\ring_wl_reg[0] [8]),
        .R(clear));
  FDRE \ring_wl_reg[0][9] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_wl_reg[3][11]_i_1_n_6 ),
        .Q(\ring_wl_reg[0] [9]),
        .R(clear));
  FDRE \ring_wl_reg[1][0] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][3]_i_1_n_7 ),
        .Q(\ring_wl_reg[1] [0]),
        .R(clear));
  FDRE \ring_wl_reg[1][10] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][11]_i_1_n_5 ),
        .Q(\ring_wl_reg[1] [10]),
        .R(clear));
  FDRE \ring_wl_reg[1][11] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][11]_i_1_n_4 ),
        .Q(\ring_wl_reg[1] [11]),
        .R(clear));
  FDRE \ring_wl_reg[1][12] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][15]_i_1_n_7 ),
        .Q(\ring_wl_reg[1] [12]),
        .R(clear));
  FDRE \ring_wl_reg[1][13] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][15]_i_1_n_6 ),
        .Q(\ring_wl_reg[1] [13]),
        .R(clear));
  FDRE \ring_wl_reg[1][14] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][15]_i_1_n_5 ),
        .Q(\ring_wl_reg[1] [14]),
        .R(clear));
  FDRE \ring_wl_reg[1][15] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][15]_i_1_n_4 ),
        .Q(\ring_wl_reg[1] [15]),
        .R(clear));
  FDRE \ring_wl_reg[1][16] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][19]_i_1_n_7 ),
        .Q(\ring_wl_reg[1] [16]),
        .R(clear));
  FDRE \ring_wl_reg[1][17] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][19]_i_1_n_6 ),
        .Q(\ring_wl_reg[1] [17]),
        .R(clear));
  FDRE \ring_wl_reg[1][18] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][19]_i_1_n_5 ),
        .Q(\ring_wl_reg[1] [18]),
        .R(clear));
  FDRE \ring_wl_reg[1][19] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][19]_i_1_n_4 ),
        .Q(\ring_wl_reg[1] [19]),
        .R(clear));
  FDRE \ring_wl_reg[1][1] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][3]_i_1_n_6 ),
        .Q(\ring_wl_reg[1] [1]),
        .R(clear));
  FDRE \ring_wl_reg[1][20] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][23]_i_1_n_7 ),
        .Q(\ring_wl_reg[1] [20]),
        .R(clear));
  FDRE \ring_wl_reg[1][21] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][23]_i_1_n_6 ),
        .Q(\ring_wl_reg[1] [21]),
        .R(clear));
  FDRE \ring_wl_reg[1][22] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][23]_i_1_n_5 ),
        .Q(\ring_wl_reg[1] [22]),
        .R(clear));
  FDRE \ring_wl_reg[1][23] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][23]_i_1_n_4 ),
        .Q(\ring_wl_reg[1] [23]),
        .R(clear));
  FDRE \ring_wl_reg[1][24] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][27]_i_1_n_7 ),
        .Q(\ring_wl_reg[1] [24]),
        .R(clear));
  FDRE \ring_wl_reg[1][25] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][27]_i_1_n_6 ),
        .Q(\ring_wl_reg[1] [25]),
        .R(clear));
  FDRE \ring_wl_reg[1][26] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][27]_i_1_n_5 ),
        .Q(\ring_wl_reg[1] [26]),
        .R(clear));
  FDRE \ring_wl_reg[1][27] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][27]_i_1_n_4 ),
        .Q(\ring_wl_reg[1] [27]),
        .R(clear));
  FDRE \ring_wl_reg[1][28] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][31]_i_1_n_7 ),
        .Q(\ring_wl_reg[1] [28]),
        .R(clear));
  FDRE \ring_wl_reg[1][29] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][31]_i_1_n_6 ),
        .Q(\ring_wl_reg[1] [29]),
        .R(clear));
  FDRE \ring_wl_reg[1][2] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][3]_i_1_n_5 ),
        .Q(\ring_wl_reg[1] [2]),
        .R(clear));
  FDRE \ring_wl_reg[1][30] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][31]_i_1_n_5 ),
        .Q(\ring_wl_reg[1] [30]),
        .R(clear));
  FDRE \ring_wl_reg[1][31] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][31]_i_1_n_4 ),
        .Q(\ring_wl_reg[1] [31]),
        .R(clear));
  FDRE \ring_wl_reg[1][3] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][3]_i_1_n_4 ),
        .Q(\ring_wl_reg[1] [3]),
        .R(clear));
  FDRE \ring_wl_reg[1][4] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][7]_i_1_n_7 ),
        .Q(\ring_wl_reg[1] [4]),
        .R(clear));
  FDRE \ring_wl_reg[1][5] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][7]_i_1_n_6 ),
        .Q(\ring_wl_reg[1] [5]),
        .R(clear));
  FDRE \ring_wl_reg[1][6] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][7]_i_1_n_5 ),
        .Q(\ring_wl_reg[1] [6]),
        .R(clear));
  FDRE \ring_wl_reg[1][7] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][7]_i_1_n_4 ),
        .Q(\ring_wl_reg[1] [7]),
        .R(clear));
  FDRE \ring_wl_reg[1][8] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][11]_i_1_n_7 ),
        .Q(\ring_wl_reg[1] [8]),
        .R(clear));
  FDRE \ring_wl_reg[1][9] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][11]_i_1_n_6 ),
        .Q(\ring_wl_reg[1] [9]),
        .R(clear));
  FDRE \ring_wl_reg[2][0] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][3]_i_1_n_7 ),
        .Q(\ring_wl_reg[2] [0]),
        .R(clear));
  FDRE \ring_wl_reg[2][10] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][11]_i_1_n_5 ),
        .Q(\ring_wl_reg[2] [10]),
        .R(clear));
  FDRE \ring_wl_reg[2][11] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][11]_i_1_n_4 ),
        .Q(\ring_wl_reg[2] [11]),
        .R(clear));
  FDRE \ring_wl_reg[2][12] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][15]_i_1_n_7 ),
        .Q(\ring_wl_reg[2] [12]),
        .R(clear));
  FDRE \ring_wl_reg[2][13] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][15]_i_1_n_6 ),
        .Q(\ring_wl_reg[2] [13]),
        .R(clear));
  FDRE \ring_wl_reg[2][14] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][15]_i_1_n_5 ),
        .Q(\ring_wl_reg[2] [14]),
        .R(clear));
  FDRE \ring_wl_reg[2][15] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][15]_i_1_n_4 ),
        .Q(\ring_wl_reg[2] [15]),
        .R(clear));
  FDRE \ring_wl_reg[2][16] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][19]_i_1_n_7 ),
        .Q(\ring_wl_reg[2] [16]),
        .R(clear));
  FDRE \ring_wl_reg[2][17] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][19]_i_1_n_6 ),
        .Q(\ring_wl_reg[2] [17]),
        .R(clear));
  FDRE \ring_wl_reg[2][18] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][19]_i_1_n_5 ),
        .Q(\ring_wl_reg[2] [18]),
        .R(clear));
  FDRE \ring_wl_reg[2][19] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][19]_i_1_n_4 ),
        .Q(\ring_wl_reg[2] [19]),
        .R(clear));
  FDRE \ring_wl_reg[2][1] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][3]_i_1_n_6 ),
        .Q(\ring_wl_reg[2] [1]),
        .R(clear));
  FDRE \ring_wl_reg[2][20] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][23]_i_1_n_7 ),
        .Q(\ring_wl_reg[2] [20]),
        .R(clear));
  FDRE \ring_wl_reg[2][21] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][23]_i_1_n_6 ),
        .Q(\ring_wl_reg[2] [21]),
        .R(clear));
  FDRE \ring_wl_reg[2][22] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][23]_i_1_n_5 ),
        .Q(\ring_wl_reg[2] [22]),
        .R(clear));
  FDRE \ring_wl_reg[2][23] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][23]_i_1_n_4 ),
        .Q(\ring_wl_reg[2] [23]),
        .R(clear));
  FDRE \ring_wl_reg[2][24] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][27]_i_1_n_7 ),
        .Q(\ring_wl_reg[2] [24]),
        .R(clear));
  FDRE \ring_wl_reg[2][25] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][27]_i_1_n_6 ),
        .Q(\ring_wl_reg[2] [25]),
        .R(clear));
  FDRE \ring_wl_reg[2][26] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][27]_i_1_n_5 ),
        .Q(\ring_wl_reg[2] [26]),
        .R(clear));
  FDRE \ring_wl_reg[2][27] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][27]_i_1_n_4 ),
        .Q(\ring_wl_reg[2] [27]),
        .R(clear));
  FDRE \ring_wl_reg[2][28] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][31]_i_1_n_7 ),
        .Q(\ring_wl_reg[2] [28]),
        .R(clear));
  FDRE \ring_wl_reg[2][29] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][31]_i_1_n_6 ),
        .Q(\ring_wl_reg[2] [29]),
        .R(clear));
  FDRE \ring_wl_reg[2][2] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][3]_i_1_n_5 ),
        .Q(\ring_wl_reg[2] [2]),
        .R(clear));
  FDRE \ring_wl_reg[2][30] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][31]_i_1_n_5 ),
        .Q(\ring_wl_reg[2] [30]),
        .R(clear));
  FDRE \ring_wl_reg[2][31] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][31]_i_1_n_4 ),
        .Q(\ring_wl_reg[2] [31]),
        .R(clear));
  FDRE \ring_wl_reg[2][3] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][3]_i_1_n_4 ),
        .Q(\ring_wl_reg[2] [3]),
        .R(clear));
  FDRE \ring_wl_reg[2][4] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][7]_i_1_n_7 ),
        .Q(\ring_wl_reg[2] [4]),
        .R(clear));
  FDRE \ring_wl_reg[2][5] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][7]_i_1_n_6 ),
        .Q(\ring_wl_reg[2] [5]),
        .R(clear));
  FDRE \ring_wl_reg[2][6] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][7]_i_1_n_5 ),
        .Q(\ring_wl_reg[2] [6]),
        .R(clear));
  FDRE \ring_wl_reg[2][7] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][7]_i_1_n_4 ),
        .Q(\ring_wl_reg[2] [7]),
        .R(clear));
  FDRE \ring_wl_reg[2][8] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][11]_i_1_n_7 ),
        .Q(\ring_wl_reg[2] [8]),
        .R(clear));
  FDRE \ring_wl_reg[2][9] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][11]_i_1_n_6 ),
        .Q(\ring_wl_reg[2] [9]),
        .R(clear));
  FDRE \ring_wl_reg[3][0] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][3]_i_1_n_7 ),
        .Q(\ring_wl_reg[3] [0]),
        .R(clear));
  FDRE \ring_wl_reg[3][10] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][11]_i_1_n_5 ),
        .Q(\ring_wl_reg[3] [10]),
        .R(clear));
  FDRE \ring_wl_reg[3][11] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][11]_i_1_n_4 ),
        .Q(\ring_wl_reg[3] [11]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ring_wl_reg[3][11]_i_1 
       (.CI(\ring_wl_reg[3][7]_i_1_n_0 ),
        .CO({\ring_wl_reg[3][11]_i_1_n_0 ,\ring_wl_reg[3][11]_i_1_n_1 ,\ring_wl_reg[3][11]_i_1_n_2 ,\ring_wl_reg[3][11]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(seg_wl_reg[11:8]),
        .O({\ring_wl_reg[3][11]_i_1_n_4 ,\ring_wl_reg[3][11]_i_1_n_5 ,\ring_wl_reg[3][11]_i_1_n_6 ,\ring_wl_reg[3][11]_i_1_n_7 }),
        .S({\ring_wl[3][11]_i_2_n_0 ,\ring_wl[3][11]_i_3_n_0 ,\ring_wl[3][11]_i_4_n_0 ,\ring_wl[3][11]_i_5_n_0 }));
  CARRY4 \ring_wl_reg[3][11]_i_6 
       (.CI(\ring_wl_reg[3][7]_i_6_n_0 ),
        .CO({\ring_wl_reg[3][11]_i_6_n_0 ,\ring_wl_reg[3][11]_i_6_n_1 ,\ring_wl_reg[3][11]_i_6_n_2 ,\ring_wl_reg[3][11]_i_6_n_3 }),
        .CYINIT(1'b0),
        .DI(sample_in[11:8]),
        .O({\ring_wl_reg[3][11]_i_6_n_4 ,\ring_wl_reg[3][11]_i_6_n_5 ,\ring_wl_reg[3][11]_i_6_n_6 ,\ring_wl_reg[3][11]_i_6_n_7 }),
        .S({\ring_wl[3][11]_i_8_n_0 ,\ring_wl[3][11]_i_9_n_0 ,\ring_wl[3][11]_i_10_n_0 ,\ring_wl[3][11]_i_11_n_0 }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ring_wl_reg[3][11]_i_7 
       (.CI(\ring_wl_reg[3][7]_i_7_n_0 ),
        .CO({\ring_wl_reg[3][11]_i_7_n_0 ,\ring_wl_reg[3][11]_i_7_n_1 ,\ring_wl_reg[3][11]_i_7_n_2 ,\ring_wl_reg[3][11]_i_7_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(abs_diff1[8:5]),
        .S({\ring_wl[3][11]_i_12_n_0 ,\ring_wl[3][11]_i_13_n_0 ,\ring_wl[3][11]_i_14_n_0 ,\ring_wl[3][11]_i_15_n_0 }));
  FDRE \ring_wl_reg[3][12] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][15]_i_1_n_7 ),
        .Q(\ring_wl_reg[3] [12]),
        .R(clear));
  FDRE \ring_wl_reg[3][13] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][15]_i_1_n_6 ),
        .Q(\ring_wl_reg[3] [13]),
        .R(clear));
  FDRE \ring_wl_reg[3][14] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][15]_i_1_n_5 ),
        .Q(\ring_wl_reg[3] [14]),
        .R(clear));
  FDRE \ring_wl_reg[3][15] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][15]_i_1_n_4 ),
        .Q(\ring_wl_reg[3] [15]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ring_wl_reg[3][15]_i_1 
       (.CI(\ring_wl_reg[3][11]_i_1_n_0 ),
        .CO({\ring_wl_reg[3][15]_i_1_n_0 ,\ring_wl_reg[3][15]_i_1_n_1 ,\ring_wl_reg[3][15]_i_1_n_2 ,\ring_wl_reg[3][15]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(seg_wl_reg[15:12]),
        .O({\ring_wl_reg[3][15]_i_1_n_4 ,\ring_wl_reg[3][15]_i_1_n_5 ,\ring_wl_reg[3][15]_i_1_n_6 ,\ring_wl_reg[3][15]_i_1_n_7 }),
        .S({\ring_wl[3][15]_i_2_n_0 ,\ring_wl[3][15]_i_3_n_0 ,\ring_wl[3][15]_i_4_n_0 ,\ring_wl[3][15]_i_5_n_0 }));
  CARRY4 \ring_wl_reg[3][15]_i_6 
       (.CI(\ring_wl_reg[3][11]_i_6_n_0 ),
        .CO({\ring_wl_reg[3][15]_i_6_n_0 ,\ring_wl_reg[3][15]_i_6_n_1 ,\ring_wl_reg[3][15]_i_6_n_2 ,\ring_wl_reg[3][15]_i_6_n_3 }),
        .CYINIT(1'b0),
        .DI(sample_in[15:12]),
        .O({\ring_wl_reg[3][15]_i_6_n_4 ,\ring_wl_reg[3][15]_i_6_n_5 ,\ring_wl_reg[3][15]_i_6_n_6 ,\ring_wl_reg[3][15]_i_6_n_7 }),
        .S({\ring_wl[3][15]_i_8_n_0 ,\ring_wl[3][15]_i_9_n_0 ,\ring_wl[3][15]_i_10_n_0 ,\ring_wl[3][15]_i_11_n_0 }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ring_wl_reg[3][15]_i_7 
       (.CI(\ring_wl_reg[3][11]_i_7_n_0 ),
        .CO({\ring_wl_reg[3][15]_i_7_n_0 ,\ring_wl_reg[3][15]_i_7_n_1 ,\ring_wl_reg[3][15]_i_7_n_2 ,\ring_wl_reg[3][15]_i_7_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(abs_diff1[12:9]),
        .S({\ring_wl[3][15]_i_12_n_0 ,\ring_wl[3][15]_i_13_n_0 ,\ring_wl[3][15]_i_14_n_0 ,\ring_wl[3][15]_i_15_n_0 }));
  FDRE \ring_wl_reg[3][16] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][19]_i_1_n_7 ),
        .Q(\ring_wl_reg[3] [16]),
        .R(clear));
  FDRE \ring_wl_reg[3][17] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][19]_i_1_n_6 ),
        .Q(\ring_wl_reg[3] [17]),
        .R(clear));
  FDRE \ring_wl_reg[3][18] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][19]_i_1_n_5 ),
        .Q(\ring_wl_reg[3] [18]),
        .R(clear));
  FDRE \ring_wl_reg[3][19] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][19]_i_1_n_4 ),
        .Q(\ring_wl_reg[3] [19]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ring_wl_reg[3][19]_i_1 
       (.CI(\ring_wl_reg[3][15]_i_1_n_0 ),
        .CO({\ring_wl_reg[3][19]_i_1_n_0 ,\ring_wl_reg[3][19]_i_1_n_1 ,\ring_wl_reg[3][19]_i_1_n_2 ,\ring_wl_reg[3][19]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(seg_wl_reg[19:16]),
        .O({\ring_wl_reg[3][19]_i_1_n_4 ,\ring_wl_reg[3][19]_i_1_n_5 ,\ring_wl_reg[3][19]_i_1_n_6 ,\ring_wl_reg[3][19]_i_1_n_7 }),
        .S({\ring_wl[3][19]_i_2_n_0 ,\ring_wl[3][19]_i_3_n_0 ,\ring_wl[3][19]_i_4_n_0 ,\ring_wl[3][19]_i_5_n_0 }));
  CARRY4 \ring_wl_reg[3][19]_i_6 
       (.CI(\ring_wl_reg[3][15]_i_6_n_0 ),
        .CO({\ring_wl_reg[3][19]_i_6_n_0 ,\ring_wl_reg[3][19]_i_6_n_1 ,\ring_wl_reg[3][19]_i_6_n_2 ,\ring_wl_reg[3][19]_i_6_n_3 }),
        .CYINIT(1'b0),
        .DI(sample_in[19:16]),
        .O({\ring_wl_reg[3][19]_i_6_n_4 ,\ring_wl_reg[3][19]_i_6_n_5 ,\ring_wl_reg[3][19]_i_6_n_6 ,\ring_wl_reg[3][19]_i_6_n_7 }),
        .S({\ring_wl[3][19]_i_8_n_0 ,\ring_wl[3][19]_i_9_n_0 ,\ring_wl[3][19]_i_10_n_0 ,\ring_wl[3][19]_i_11_n_0 }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ring_wl_reg[3][19]_i_7 
       (.CI(\ring_wl_reg[3][15]_i_7_n_0 ),
        .CO({\ring_wl_reg[3][19]_i_7_n_0 ,\ring_wl_reg[3][19]_i_7_n_1 ,\ring_wl_reg[3][19]_i_7_n_2 ,\ring_wl_reg[3][19]_i_7_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(abs_diff1[16:13]),
        .S({\ring_wl[3][19]_i_12_n_0 ,\ring_wl[3][19]_i_13_n_0 ,\ring_wl[3][19]_i_14_n_0 ,\ring_wl[3][19]_i_15_n_0 }));
  FDRE \ring_wl_reg[3][1] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][3]_i_1_n_6 ),
        .Q(\ring_wl_reg[3] [1]),
        .R(clear));
  FDRE \ring_wl_reg[3][20] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][23]_i_1_n_7 ),
        .Q(\ring_wl_reg[3] [20]),
        .R(clear));
  FDRE \ring_wl_reg[3][21] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][23]_i_1_n_6 ),
        .Q(\ring_wl_reg[3] [21]),
        .R(clear));
  FDRE \ring_wl_reg[3][22] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][23]_i_1_n_5 ),
        .Q(\ring_wl_reg[3] [22]),
        .R(clear));
  FDRE \ring_wl_reg[3][23] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][23]_i_1_n_4 ),
        .Q(\ring_wl_reg[3] [23]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ring_wl_reg[3][23]_i_1 
       (.CI(\ring_wl_reg[3][19]_i_1_n_0 ),
        .CO({\ring_wl_reg[3][23]_i_1_n_0 ,\ring_wl_reg[3][23]_i_1_n_1 ,\ring_wl_reg[3][23]_i_1_n_2 ,\ring_wl_reg[3][23]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(seg_wl_reg[23:20]),
        .O({\ring_wl_reg[3][23]_i_1_n_4 ,\ring_wl_reg[3][23]_i_1_n_5 ,\ring_wl_reg[3][23]_i_1_n_6 ,\ring_wl_reg[3][23]_i_1_n_7 }),
        .S({\ring_wl[3][23]_i_2_n_0 ,\ring_wl[3][23]_i_3_n_0 ,\ring_wl[3][23]_i_4_n_0 ,\ring_wl[3][23]_i_5_n_0 }));
  CARRY4 \ring_wl_reg[3][23]_i_6 
       (.CI(\ring_wl_reg[3][19]_i_6_n_0 ),
        .CO({\ring_wl_reg[3][23]_i_6_n_0 ,\ring_wl_reg[3][23]_i_6_n_1 ,\ring_wl_reg[3][23]_i_6_n_2 ,\ring_wl_reg[3][23]_i_6_n_3 }),
        .CYINIT(1'b0),
        .DI({p_0_in0_in,sample_in[22:20]}),
        .O({\ring_wl_reg[3][23]_i_6_n_4 ,\ring_wl_reg[3][23]_i_6_n_5 ,\ring_wl_reg[3][23]_i_6_n_6 ,\ring_wl_reg[3][23]_i_6_n_7 }),
        .S({\ring_wl[3][23]_i_8_n_0 ,\ring_wl[3][23]_i_9_n_0 ,\ring_wl[3][23]_i_10_n_0 ,\ring_wl[3][23]_i_11_n_0 }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ring_wl_reg[3][23]_i_7 
       (.CI(\ring_wl_reg[3][19]_i_7_n_0 ),
        .CO({\ring_wl_reg[3][23]_i_7_n_0 ,\ring_wl_reg[3][23]_i_7_n_1 ,\ring_wl_reg[3][23]_i_7_n_2 ,\ring_wl_reg[3][23]_i_7_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(abs_diff1[20:17]),
        .S({\ring_wl[3][23]_i_12_n_0 ,\ring_wl[3][23]_i_13_n_0 ,\ring_wl[3][23]_i_14_n_0 ,\ring_wl[3][23]_i_15_n_0 }));
  FDRE \ring_wl_reg[3][24] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][27]_i_1_n_7 ),
        .Q(\ring_wl_reg[3] [24]),
        .R(clear));
  FDRE \ring_wl_reg[3][25] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][27]_i_1_n_6 ),
        .Q(\ring_wl_reg[3] [25]),
        .R(clear));
  FDRE \ring_wl_reg[3][26] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][27]_i_1_n_5 ),
        .Q(\ring_wl_reg[3] [26]),
        .R(clear));
  FDRE \ring_wl_reg[3][27] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][27]_i_1_n_4 ),
        .Q(\ring_wl_reg[3] [27]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ring_wl_reg[3][27]_i_1 
       (.CI(\ring_wl_reg[3][23]_i_1_n_0 ),
        .CO({\ring_wl_reg[3][27]_i_1_n_0 ,\ring_wl_reg[3][27]_i_1_n_1 ,\ring_wl_reg[3][27]_i_1_n_2 ,\ring_wl_reg[3][27]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,seg_wl_reg[24]}),
        .O({\ring_wl_reg[3][27]_i_1_n_4 ,\ring_wl_reg[3][27]_i_1_n_5 ,\ring_wl_reg[3][27]_i_1_n_6 ,\ring_wl_reg[3][27]_i_1_n_7 }),
        .S({seg_wl_reg[27:25],\ring_wl[3][27]_i_2_n_0 }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ring_wl_reg[3][27]_i_3 
       (.CI(\ring_wl_reg[3][23]_i_7_n_0 ),
        .CO({\NLW_ring_wl_reg[3][27]_i_3_CO_UNCONNECTED [3],\ring_wl_reg[3][27]_i_3_n_1 ,\ring_wl_reg[3][27]_i_3_n_2 ,\ring_wl_reg[3][27]_i_3_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(abs_diff1[24:21]),
        .S({\ring_wl_reg[3][27]_i_4_n_3 ,\ring_wl[3][27]_i_5_n_0 ,\ring_wl[3][27]_i_6_n_0 ,\ring_wl[3][27]_i_7_n_0 }));
  CARRY4 \ring_wl_reg[3][27]_i_4 
       (.CI(\ring_wl_reg[3][23]_i_6_n_0 ),
        .CO({\NLW_ring_wl_reg[3][27]_i_4_CO_UNCONNECTED [3:1],\ring_wl_reg[3][27]_i_4_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(\NLW_ring_wl_reg[3][27]_i_4_O_UNCONNECTED [3:0]),
        .S({1'b0,1'b0,1'b0,1'b1}));
  FDRE \ring_wl_reg[3][28] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][31]_i_1_n_7 ),
        .Q(\ring_wl_reg[3] [28]),
        .R(clear));
  FDRE \ring_wl_reg[3][29] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][31]_i_1_n_6 ),
        .Q(\ring_wl_reg[3] [29]),
        .R(clear));
  FDRE \ring_wl_reg[3][2] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][3]_i_1_n_5 ),
        .Q(\ring_wl_reg[3] [2]),
        .R(clear));
  FDRE \ring_wl_reg[3][30] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][31]_i_1_n_5 ),
        .Q(\ring_wl_reg[3] [30]),
        .R(clear));
  FDRE \ring_wl_reg[3][31] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][31]_i_1_n_4 ),
        .Q(\ring_wl_reg[3] [31]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ring_wl_reg[3][31]_i_1 
       (.CI(\ring_wl_reg[3][27]_i_1_n_0 ),
        .CO({\NLW_ring_wl_reg[3][31]_i_1_CO_UNCONNECTED [3],\ring_wl_reg[3][31]_i_1_n_1 ,\ring_wl_reg[3][31]_i_1_n_2 ,\ring_wl_reg[3][31]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\ring_wl_reg[3][31]_i_1_n_4 ,\ring_wl_reg[3][31]_i_1_n_5 ,\ring_wl_reg[3][31]_i_1_n_6 ,\ring_wl_reg[3][31]_i_1_n_7 }),
        .S(seg_wl_reg[31:28]));
  FDRE \ring_wl_reg[3][3] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][3]_i_1_n_4 ),
        .Q(\ring_wl_reg[3] [3]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ring_wl_reg[3][3]_i_1 
       (.CI(1'b0),
        .CO({\ring_wl_reg[3][3]_i_1_n_0 ,\ring_wl_reg[3][3]_i_1_n_1 ,\ring_wl_reg[3][3]_i_1_n_2 ,\ring_wl_reg[3][3]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(seg_wl_reg[3:0]),
        .O({\ring_wl_reg[3][3]_i_1_n_4 ,\ring_wl_reg[3][3]_i_1_n_5 ,\ring_wl_reg[3][3]_i_1_n_6 ,\ring_wl_reg[3][3]_i_1_n_7 }),
        .S({\ring_wl[3][3]_i_2_n_0 ,\ring_wl[3][3]_i_3_n_0 ,\ring_wl[3][3]_i_4_n_0 ,\ring_wl[3][3]_i_5_n_0 }));
  CARRY4 \ring_wl_reg[3][3]_i_6 
       (.CI(1'b0),
        .CO({\ring_wl_reg[3][3]_i_6_n_0 ,\ring_wl_reg[3][3]_i_6_n_1 ,\ring_wl_reg[3][3]_i_6_n_2 ,\ring_wl_reg[3][3]_i_6_n_3 }),
        .CYINIT(1'b1),
        .DI(sample_in[3:0]),
        .O({\ring_wl_reg[3][3]_i_6_n_4 ,\ring_wl_reg[3][3]_i_6_n_5 ,\ring_wl_reg[3][3]_i_6_n_6 ,\ring_wl_reg[3][3]_i_6_n_7 }),
        .S({\ring_wl[3][3]_i_7_n_0 ,\ring_wl[3][3]_i_8_n_0 ,\ring_wl[3][3]_i_9_n_0 ,\ring_wl[3][3]_i_10_n_0 }));
  FDRE \ring_wl_reg[3][4] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][7]_i_1_n_7 ),
        .Q(\ring_wl_reg[3] [4]),
        .R(clear));
  FDRE \ring_wl_reg[3][5] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][7]_i_1_n_6 ),
        .Q(\ring_wl_reg[3] [5]),
        .R(clear));
  FDRE \ring_wl_reg[3][6] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][7]_i_1_n_5 ),
        .Q(\ring_wl_reg[3] [6]),
        .R(clear));
  FDRE \ring_wl_reg[3][7] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][7]_i_1_n_4 ),
        .Q(\ring_wl_reg[3] [7]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ring_wl_reg[3][7]_i_1 
       (.CI(\ring_wl_reg[3][3]_i_1_n_0 ),
        .CO({\ring_wl_reg[3][7]_i_1_n_0 ,\ring_wl_reg[3][7]_i_1_n_1 ,\ring_wl_reg[3][7]_i_1_n_2 ,\ring_wl_reg[3][7]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(seg_wl_reg[7:4]),
        .O({\ring_wl_reg[3][7]_i_1_n_4 ,\ring_wl_reg[3][7]_i_1_n_5 ,\ring_wl_reg[3][7]_i_1_n_6 ,\ring_wl_reg[3][7]_i_1_n_7 }),
        .S({\ring_wl[3][7]_i_2_n_0 ,\ring_wl[3][7]_i_3_n_0 ,\ring_wl[3][7]_i_4_n_0 ,\ring_wl[3][7]_i_5_n_0 }));
  CARRY4 \ring_wl_reg[3][7]_i_6 
       (.CI(\ring_wl_reg[3][3]_i_6_n_0 ),
        .CO({\ring_wl_reg[3][7]_i_6_n_0 ,\ring_wl_reg[3][7]_i_6_n_1 ,\ring_wl_reg[3][7]_i_6_n_2 ,\ring_wl_reg[3][7]_i_6_n_3 }),
        .CYINIT(1'b0),
        .DI(sample_in[7:4]),
        .O({\ring_wl_reg[3][7]_i_6_n_4 ,\ring_wl_reg[3][7]_i_6_n_5 ,\ring_wl_reg[3][7]_i_6_n_6 ,\ring_wl_reg[3][7]_i_6_n_7 }),
        .S({\ring_wl[3][7]_i_8_n_0 ,\ring_wl[3][7]_i_9_n_0 ,\ring_wl[3][7]_i_10_n_0 ,\ring_wl[3][7]_i_11_n_0 }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ring_wl_reg[3][7]_i_7 
       (.CI(1'b0),
        .CO({\ring_wl_reg[3][7]_i_7_n_0 ,\ring_wl_reg[3][7]_i_7_n_1 ,\ring_wl_reg[3][7]_i_7_n_2 ,\ring_wl_reg[3][7]_i_7_n_3 }),
        .CYINIT(\ring_wl[3][7]_i_12_n_0 ),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(abs_diff1[4:1]),
        .S({\ring_wl[3][7]_i_13_n_0 ,\ring_wl[3][7]_i_14_n_0 ,\ring_wl[3][7]_i_15_n_0 ,\ring_wl[3][7]_i_16_n_0 }));
  FDRE \ring_wl_reg[3][8] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][11]_i_1_n_7 ),
        .Q(\ring_wl_reg[3] [8]),
        .R(clear));
  FDRE \ring_wl_reg[3][9] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_wl_reg[3][11]_i_1_n_6 ),
        .Q(\ring_wl_reg[3] [9]),
        .R(clear));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT5 #(
    .INIT(32'h96AAAAAA)) 
    \ring_zc[3][0]_i_1 
       (.I0(seg_zc_reg[0]),
        .I1(sample_in[23]),
        .I2(p_0_in0_in),
        .I3(have_prev),
        .I4(zc_event1),
        .O(\ring_zc[3][0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFF7F7FFF00808000)) 
    \ring_zc[3][1]_i_1 
       (.I0(seg_zc_reg[0]),
        .I1(zc_event1),
        .I2(have_prev),
        .I3(p_0_in0_in),
        .I4(sample_in[23]),
        .I5(seg_zc_reg[1]),
        .O(\ring_zc[3][1]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h00053305)) 
    \ring_zc[3][1]_i_10 
       (.I0(abs_diff1[19]),
        .I1(\ring_wl_reg[3][19]_i_6_n_4 ),
        .I2(abs_diff1[18]),
        .I3(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I4(\ring_wl_reg[3][19]_i_6_n_5 ),
        .O(\ring_zc[3][1]_i_10_n_0 ));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    \ring_zc[3][1]_i_12 
       (.I0(\ring_wl_reg[3][19]_i_6_n_7 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[16]),
        .I3(\ring_wl_reg[3][19]_i_6_n_6 ),
        .I4(abs_diff1[17]),
        .O(\ring_zc[3][1]_i_12_n_0 ));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    \ring_zc[3][1]_i_13 
       (.I0(\ring_wl_reg[3][15]_i_6_n_5 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[14]),
        .I3(\ring_wl_reg[3][15]_i_6_n_4 ),
        .I4(abs_diff1[15]),
        .O(\ring_zc[3][1]_i_13_n_0 ));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    \ring_zc[3][1]_i_14 
       (.I0(\ring_wl_reg[3][15]_i_6_n_7 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[12]),
        .I3(\ring_wl_reg[3][15]_i_6_n_6 ),
        .I4(abs_diff1[13]),
        .O(\ring_zc[3][1]_i_14_n_0 ));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    \ring_zc[3][1]_i_15 
       (.I0(\ring_wl_reg[3][11]_i_6_n_5 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[10]),
        .I3(\ring_wl_reg[3][11]_i_6_n_4 ),
        .I4(abs_diff1[11]),
        .O(\ring_zc[3][1]_i_15_n_0 ));
  LUT5 #(
    .INIT(32'h00053305)) 
    \ring_zc[3][1]_i_16 
       (.I0(abs_diff1[17]),
        .I1(\ring_wl_reg[3][19]_i_6_n_6 ),
        .I2(abs_diff1[16]),
        .I3(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I4(\ring_wl_reg[3][19]_i_6_n_7 ),
        .O(\ring_zc[3][1]_i_16_n_0 ));
  LUT5 #(
    .INIT(32'h00053305)) 
    \ring_zc[3][1]_i_17 
       (.I0(abs_diff1[15]),
        .I1(\ring_wl_reg[3][15]_i_6_n_4 ),
        .I2(abs_diff1[14]),
        .I3(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I4(\ring_wl_reg[3][15]_i_6_n_5 ),
        .O(\ring_zc[3][1]_i_17_n_0 ));
  LUT5 #(
    .INIT(32'h00053305)) 
    \ring_zc[3][1]_i_18 
       (.I0(abs_diff1[13]),
        .I1(\ring_wl_reg[3][15]_i_6_n_6 ),
        .I2(abs_diff1[12]),
        .I3(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I4(\ring_wl_reg[3][15]_i_6_n_7 ),
        .O(\ring_zc[3][1]_i_18_n_0 ));
  LUT5 #(
    .INIT(32'h00053305)) 
    \ring_zc[3][1]_i_19 
       (.I0(abs_diff1[11]),
        .I1(\ring_wl_reg[3][11]_i_6_n_4 ),
        .I2(abs_diff1[10]),
        .I3(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I4(\ring_wl_reg[3][11]_i_6_n_5 ),
        .O(\ring_zc[3][1]_i_19_n_0 ));
  LUT4 #(
    .INIT(16'hFFE2)) 
    \ring_zc[3][1]_i_20 
       (.I0(abs_diff1[1]),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(\ring_wl_reg[3][3]_i_6_n_6 ),
        .I3(\ring_wl_reg[3][3]_i_6_n_7 ),
        .O(\ring_zc[3][1]_i_20_n_0 ));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    \ring_zc[3][1]_i_21 
       (.I0(\ring_wl_reg[3][11]_i_6_n_7 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[8]),
        .I3(\ring_wl_reg[3][11]_i_6_n_6 ),
        .I4(abs_diff1[9]),
        .O(\ring_zc[3][1]_i_21_n_0 ));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    \ring_zc[3][1]_i_22 
       (.I0(\ring_wl_reg[3][7]_i_6_n_5 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[6]),
        .I3(\ring_wl_reg[3][7]_i_6_n_4 ),
        .I4(abs_diff1[7]),
        .O(\ring_zc[3][1]_i_22_n_0 ));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    \ring_zc[3][1]_i_23 
       (.I0(\ring_wl_reg[3][7]_i_6_n_7 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[4]),
        .I3(\ring_wl_reg[3][7]_i_6_n_6 ),
        .I4(abs_diff1[5]),
        .O(\ring_zc[3][1]_i_23_n_0 ));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    \ring_zc[3][1]_i_24 
       (.I0(\ring_wl_reg[3][3]_i_6_n_5 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[2]),
        .I3(\ring_wl_reg[3][3]_i_6_n_4 ),
        .I4(abs_diff1[3]),
        .O(\ring_zc[3][1]_i_24_n_0 ));
  LUT5 #(
    .INIT(32'h00053305)) 
    \ring_zc[3][1]_i_25 
       (.I0(abs_diff1[9]),
        .I1(\ring_wl_reg[3][11]_i_6_n_6 ),
        .I2(abs_diff1[8]),
        .I3(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I4(\ring_wl_reg[3][11]_i_6_n_7 ),
        .O(\ring_zc[3][1]_i_25_n_0 ));
  LUT5 #(
    .INIT(32'h00053305)) 
    \ring_zc[3][1]_i_26 
       (.I0(abs_diff1[7]),
        .I1(\ring_wl_reg[3][7]_i_6_n_4 ),
        .I2(abs_diff1[6]),
        .I3(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I4(\ring_wl_reg[3][7]_i_6_n_5 ),
        .O(\ring_zc[3][1]_i_26_n_0 ));
  LUT5 #(
    .INIT(32'h00053305)) 
    \ring_zc[3][1]_i_27 
       (.I0(abs_diff1[5]),
        .I1(\ring_wl_reg[3][7]_i_6_n_6 ),
        .I2(abs_diff1[4]),
        .I3(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I4(\ring_wl_reg[3][7]_i_6_n_7 ),
        .O(\ring_zc[3][1]_i_27_n_0 ));
  LUT5 #(
    .INIT(32'h00053305)) 
    \ring_zc[3][1]_i_28 
       (.I0(abs_diff1[3]),
        .I1(\ring_wl_reg[3][3]_i_6_n_4 ),
        .I2(abs_diff1[2]),
        .I3(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I4(\ring_wl_reg[3][3]_i_6_n_5 ),
        .O(\ring_zc[3][1]_i_28_n_0 ));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    \ring_zc[3][1]_i_4 
       (.I0(\ring_wl_reg[3][23]_i_6_n_5 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[22]),
        .I3(\ring_wl_reg[3][23]_i_6_n_4 ),
        .I4(abs_diff1[23]),
        .O(\ring_zc[3][1]_i_4_n_0 ));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    \ring_zc[3][1]_i_5 
       (.I0(\ring_wl_reg[3][23]_i_6_n_7 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[20]),
        .I3(\ring_wl_reg[3][23]_i_6_n_6 ),
        .I4(abs_diff1[21]),
        .O(\ring_zc[3][1]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    \ring_zc[3][1]_i_6 
       (.I0(\ring_wl_reg[3][19]_i_6_n_5 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[18]),
        .I3(\ring_wl_reg[3][19]_i_6_n_4 ),
        .I4(abs_diff1[19]),
        .O(\ring_zc[3][1]_i_6_n_0 ));
  LUT2 #(
    .INIT(4'hB)) 
    \ring_zc[3][1]_i_7 
       (.I0(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I1(abs_diff1[24]),
        .O(\ring_zc[3][1]_i_7_n_0 ));
  LUT5 #(
    .INIT(32'h00053305)) 
    \ring_zc[3][1]_i_8 
       (.I0(abs_diff1[23]),
        .I1(\ring_wl_reg[3][23]_i_6_n_4 ),
        .I2(abs_diff1[22]),
        .I3(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I4(\ring_wl_reg[3][23]_i_6_n_5 ),
        .O(\ring_zc[3][1]_i_8_n_0 ));
  LUT5 #(
    .INIT(32'h00053305)) 
    \ring_zc[3][1]_i_9 
       (.I0(abs_diff1[21]),
        .I1(\ring_wl_reg[3][23]_i_6_n_6 ),
        .I2(abs_diff1[20]),
        .I3(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I4(\ring_wl_reg[3][23]_i_6_n_7 ),
        .O(\ring_zc[3][1]_i_9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair41" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \ring_zc[3][2]_i_1 
       (.I0(zc_event),
        .I1(seg_zc_reg[0]),
        .I2(seg_zc_reg[1]),
        .I3(seg_zc_reg[2]),
        .O(\ring_zc[3][2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair41" *) 
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    \ring_zc[3][3]_i_1 
       (.I0(seg_zc_reg[1]),
        .I1(seg_zc_reg[0]),
        .I2(zc_event),
        .I3(seg_zc_reg[2]),
        .I4(seg_zc_reg[3]),
        .O(\ring_zc[3][3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h7FFFFFFF80000000)) 
    \ring_zc[3][4]_i_1 
       (.I0(seg_zc_reg[2]),
        .I1(zc_event),
        .I2(seg_zc_reg[0]),
        .I3(seg_zc_reg[1]),
        .I4(seg_zc_reg[3]),
        .I5(seg_zc_reg[4]),
        .O(\ring_zc[3][4]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT4 #(
    .INIT(16'h0880)) 
    \ring_zc[3][4]_i_2 
       (.I0(zc_event1),
        .I1(have_prev),
        .I2(p_0_in0_in),
        .I3(sample_in[23]),
        .O(zc_event));
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    \ring_zc[3][5]_i_1 
       (.I0(seg_zc_reg[3]),
        .I1(\ring_zc[3][6]_i_2_n_0 ),
        .I2(seg_zc_reg[2]),
        .I3(seg_zc_reg[4]),
        .I4(seg_zc_reg[5]),
        .O(\ring_zc[3][5]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h7FFFFFFF80000000)) 
    \ring_zc[3][6]_i_1 
       (.I0(seg_zc_reg[4]),
        .I1(seg_zc_reg[2]),
        .I2(\ring_zc[3][6]_i_2_n_0 ),
        .I3(seg_zc_reg[3]),
        .I4(seg_zc_reg[5]),
        .I5(seg_zc_reg[6]),
        .O(\ring_zc[3][6]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000800080000000)) 
    \ring_zc[3][6]_i_2 
       (.I0(seg_zc_reg[1]),
        .I1(seg_zc_reg[0]),
        .I2(zc_event1),
        .I3(have_prev),
        .I4(p_0_in0_in),
        .I5(sample_in[23]),
        .O(\ring_zc[3][6]_i_2_n_0 ));
  FDRE \ring_zc_reg[0][0] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_zc[3][0]_i_1_n_0 ),
        .Q(\ring_zc_reg[0] [0]),
        .R(clear));
  FDRE \ring_zc_reg[0][1] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_zc[3][1]_i_1_n_0 ),
        .Q(\ring_zc_reg[0] [1]),
        .R(clear));
  FDRE \ring_zc_reg[0][2] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_zc[3][2]_i_1_n_0 ),
        .Q(\ring_zc_reg[0] [2]),
        .R(clear));
  FDRE \ring_zc_reg[0][3] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_zc[3][3]_i_1_n_0 ),
        .Q(\ring_zc_reg[0] [3]),
        .R(clear));
  FDRE \ring_zc_reg[0][4] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_zc[3][4]_i_1_n_0 ),
        .Q(\ring_zc_reg[0] [4]),
        .R(clear));
  FDRE \ring_zc_reg[0][5] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_zc[3][5]_i_1_n_0 ),
        .Q(\ring_zc_reg[0] [5]),
        .R(clear));
  FDRE \ring_zc_reg[0][6] 
       (.C(clk),
        .CE(ring_mav),
        .D(\ring_zc[3][6]_i_1_n_0 ),
        .Q(\ring_zc_reg[0] [6]),
        .R(clear));
  FDRE \ring_zc_reg[1][0] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_zc[3][0]_i_1_n_0 ),
        .Q(\ring_zc_reg[1] [0]),
        .R(clear));
  FDRE \ring_zc_reg[1][1] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_zc[3][1]_i_1_n_0 ),
        .Q(\ring_zc_reg[1] [1]),
        .R(clear));
  FDRE \ring_zc_reg[1][2] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_zc[3][2]_i_1_n_0 ),
        .Q(\ring_zc_reg[1] [2]),
        .R(clear));
  FDRE \ring_zc_reg[1][3] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_zc[3][3]_i_1_n_0 ),
        .Q(\ring_zc_reg[1] [3]),
        .R(clear));
  FDRE \ring_zc_reg[1][4] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_zc[3][4]_i_1_n_0 ),
        .Q(\ring_zc_reg[1] [4]),
        .R(clear));
  FDRE \ring_zc_reg[1][5] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_zc[3][5]_i_1_n_0 ),
        .Q(\ring_zc_reg[1] [5]),
        .R(clear));
  FDRE \ring_zc_reg[1][6] 
       (.C(clk),
        .CE(\ring_mav[1][31]_i_1_n_0 ),
        .D(\ring_zc[3][6]_i_1_n_0 ),
        .Q(\ring_zc_reg[1] [6]),
        .R(clear));
  FDRE \ring_zc_reg[2][0] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_zc[3][0]_i_1_n_0 ),
        .Q(\ring_zc_reg[2] [0]),
        .R(clear));
  FDRE \ring_zc_reg[2][1] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_zc[3][1]_i_1_n_0 ),
        .Q(\ring_zc_reg[2] [1]),
        .R(clear));
  FDRE \ring_zc_reg[2][2] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_zc[3][2]_i_1_n_0 ),
        .Q(\ring_zc_reg[2] [2]),
        .R(clear));
  FDRE \ring_zc_reg[2][3] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_zc[3][3]_i_1_n_0 ),
        .Q(\ring_zc_reg[2] [3]),
        .R(clear));
  FDRE \ring_zc_reg[2][4] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_zc[3][4]_i_1_n_0 ),
        .Q(\ring_zc_reg[2] [4]),
        .R(clear));
  FDRE \ring_zc_reg[2][5] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_zc[3][5]_i_1_n_0 ),
        .Q(\ring_zc_reg[2] [5]),
        .R(clear));
  FDRE \ring_zc_reg[2][6] 
       (.C(clk),
        .CE(\ring_mav[2][31]_i_1_n_0 ),
        .D(\ring_zc[3][6]_i_1_n_0 ),
        .Q(\ring_zc_reg[2] [6]),
        .R(clear));
  FDRE \ring_zc_reg[3][0] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_zc[3][0]_i_1_n_0 ),
        .Q(\ring_zc_reg[3] [0]),
        .R(clear));
  FDRE \ring_zc_reg[3][1] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_zc[3][1]_i_1_n_0 ),
        .Q(\ring_zc_reg[3] [1]),
        .R(clear));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \ring_zc_reg[3][1]_i_11 
       (.CI(1'b0),
        .CO({\ring_zc_reg[3][1]_i_11_n_0 ,\ring_zc_reg[3][1]_i_11_n_1 ,\ring_zc_reg[3][1]_i_11_n_2 ,\ring_zc_reg[3][1]_i_11_n_3 }),
        .CYINIT(\ring_zc[3][1]_i_20_n_0 ),
        .DI({\ring_zc[3][1]_i_21_n_0 ,\ring_zc[3][1]_i_22_n_0 ,\ring_zc[3][1]_i_23_n_0 ,\ring_zc[3][1]_i_24_n_0 }),
        .O(\NLW_ring_zc_reg[3][1]_i_11_O_UNCONNECTED [3:0]),
        .S({\ring_zc[3][1]_i_25_n_0 ,\ring_zc[3][1]_i_26_n_0 ,\ring_zc[3][1]_i_27_n_0 ,\ring_zc[3][1]_i_28_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \ring_zc_reg[3][1]_i_2 
       (.CI(\ring_zc_reg[3][1]_i_3_n_0 ),
        .CO({zc_event1,\ring_zc_reg[3][1]_i_2_n_1 ,\ring_zc_reg[3][1]_i_2_n_2 ,\ring_zc_reg[3][1]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,\ring_zc[3][1]_i_4_n_0 ,\ring_zc[3][1]_i_5_n_0 ,\ring_zc[3][1]_i_6_n_0 }),
        .O(\NLW_ring_zc_reg[3][1]_i_2_O_UNCONNECTED [3:0]),
        .S({\ring_zc[3][1]_i_7_n_0 ,\ring_zc[3][1]_i_8_n_0 ,\ring_zc[3][1]_i_9_n_0 ,\ring_zc[3][1]_i_10_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \ring_zc_reg[3][1]_i_3 
       (.CI(\ring_zc_reg[3][1]_i_11_n_0 ),
        .CO({\ring_zc_reg[3][1]_i_3_n_0 ,\ring_zc_reg[3][1]_i_3_n_1 ,\ring_zc_reg[3][1]_i_3_n_2 ,\ring_zc_reg[3][1]_i_3_n_3 }),
        .CYINIT(1'b0),
        .DI({\ring_zc[3][1]_i_12_n_0 ,\ring_zc[3][1]_i_13_n_0 ,\ring_zc[3][1]_i_14_n_0 ,\ring_zc[3][1]_i_15_n_0 }),
        .O(\NLW_ring_zc_reg[3][1]_i_3_O_UNCONNECTED [3:0]),
        .S({\ring_zc[3][1]_i_16_n_0 ,\ring_zc[3][1]_i_17_n_0 ,\ring_zc[3][1]_i_18_n_0 ,\ring_zc[3][1]_i_19_n_0 }));
  FDRE \ring_zc_reg[3][2] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_zc[3][2]_i_1_n_0 ),
        .Q(\ring_zc_reg[3] [2]),
        .R(clear));
  FDRE \ring_zc_reg[3][3] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_zc[3][3]_i_1_n_0 ),
        .Q(\ring_zc_reg[3] [3]),
        .R(clear));
  FDRE \ring_zc_reg[3][4] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_zc[3][4]_i_1_n_0 ),
        .Q(\ring_zc_reg[3] [4]),
        .R(clear));
  FDRE \ring_zc_reg[3][5] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_zc[3][5]_i_1_n_0 ),
        .Q(\ring_zc_reg[3] [5]),
        .R(clear));
  FDRE \ring_zc_reg[3][6] 
       (.C(clk),
        .CE(\ring_mav[3][31]_i_1_n_0 ),
        .D(\ring_zc[3][6]_i_1_n_0 ),
        .Q(\ring_zc_reg[3] [6]),
        .R(clear));
  (* SOFT_HLUTNM = "soft_lutpair124" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \seg_count[0]_i_1 
       (.I0(seg_count_reg[0]),
        .O(p_0_in[0]));
  (* SOFT_HLUTNM = "soft_lutpair124" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \seg_count[1]_i_1 
       (.I0(seg_count_reg[0]),
        .I1(seg_count_reg[1]),
        .O(p_0_in[1]));
  (* SOFT_HLUTNM = "soft_lutpair45" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \seg_count[2]_i_1 
       (.I0(seg_count_reg[1]),
        .I1(seg_count_reg[0]),
        .I2(seg_count_reg[2]),
        .O(p_0_in[2]));
  (* SOFT_HLUTNM = "soft_lutpair45" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \seg_count[3]_i_1 
       (.I0(seg_count_reg[0]),
        .I1(seg_count_reg[1]),
        .I2(seg_count_reg[2]),
        .I3(seg_count_reg[3]),
        .O(p_0_in[3]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    \seg_count[4]_i_1 
       (.I0(seg_count_reg[2]),
        .I1(seg_count_reg[1]),
        .I2(seg_count_reg[0]),
        .I3(seg_count_reg[3]),
        .I4(seg_count_reg[4]),
        .O(p_0_in[4]));
  LUT6 #(
    .INIT(64'h7FFFFFFF80000000)) 
    \seg_count[5]_i_1 
       (.I0(seg_count_reg[3]),
        .I1(seg_count_reg[0]),
        .I2(seg_count_reg[1]),
        .I3(seg_count_reg[2]),
        .I4(seg_count_reg[4]),
        .I5(seg_count_reg[5]),
        .O(p_0_in[5]));
  LUT3 #(
    .INIT(8'h8F)) 
    \seg_count[6]_i_1 
       (.I0(sample_valid),
        .I1(window_valid13_in),
        .I2(rst_n),
        .O(seg_ssc));
  (* SOFT_HLUTNM = "soft_lutpair43" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \seg_count[6]_i_2 
       (.I0(\seg_count[6]_i_3_n_0 ),
        .I1(seg_count_reg[5]),
        .I2(seg_count_reg[6]),
        .O(p_0_in[6]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT5 #(
    .INIT(32'h80000000)) 
    \seg_count[6]_i_3 
       (.I0(seg_count_reg[4]),
        .I1(seg_count_reg[2]),
        .I2(seg_count_reg[1]),
        .I3(seg_count_reg[0]),
        .I4(seg_count_reg[3]),
        .O(\seg_count[6]_i_3_n_0 ));
  FDRE \seg_count_reg[0] 
       (.C(clk),
        .CE(sample_valid),
        .D(p_0_in[0]),
        .Q(seg_count_reg[0]),
        .R(seg_ssc));
  FDRE \seg_count_reg[1] 
       (.C(clk),
        .CE(sample_valid),
        .D(p_0_in[1]),
        .Q(seg_count_reg[1]),
        .R(seg_ssc));
  FDRE \seg_count_reg[2] 
       (.C(clk),
        .CE(sample_valid),
        .D(p_0_in[2]),
        .Q(seg_count_reg[2]),
        .R(seg_ssc));
  FDRE \seg_count_reg[3] 
       (.C(clk),
        .CE(sample_valid),
        .D(p_0_in[3]),
        .Q(seg_count_reg[3]),
        .R(seg_ssc));
  FDRE \seg_count_reg[4] 
       (.C(clk),
        .CE(sample_valid),
        .D(p_0_in[4]),
        .Q(seg_count_reg[4]),
        .R(seg_ssc));
  FDRE \seg_count_reg[5] 
       (.C(clk),
        .CE(sample_valid),
        .D(p_0_in[5]),
        .Q(seg_count_reg[5]),
        .R(seg_ssc));
  FDRE \seg_count_reg[6] 
       (.C(clk),
        .CE(sample_valid),
        .D(p_0_in[6]),
        .Q(seg_count_reg[6]),
        .R(seg_ssc));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-13 {cell *THIS*}}" *) 
  DSP48E1 #(
    .ACASCREG(0),
    .ADREG(1),
    .ALUMODEREG(0),
    .AREG(0),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(0),
    .BREG(0),
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
    seg_energy1
       (.A({sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23:12]}),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT(NLW_seg_energy1_ACOUT_UNCONNECTED[29:0]),
        .ALUMODE({1'b0,1'b0,1'b0,1'b0}),
        .B({1'b0,sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23:12]}),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(NLW_seg_energy1_BCOUT_UNCONNECTED[17:0]),
        .C({1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(NLW_seg_energy1_CARRYCASCOUT_UNCONNECTED),
        .CARRYIN(1'b0),
        .CARRYINSEL({1'b0,1'b0,1'b0}),
        .CARRYOUT(NLW_seg_energy1_CARRYOUT_UNCONNECTED[3:0]),
        .CEA1(1'b0),
        .CEA2(1'b0),
        .CEAD(1'b0),
        .CEALUMODE(1'b0),
        .CEB1(1'b0),
        .CEB2(1'b0),
        .CEC(1'b0),
        .CECARRYIN(1'b0),
        .CECTRL(1'b0),
        .CED(1'b0),
        .CEINMODE(1'b0),
        .CEM(1'b0),
        .CEP(1'b0),
        .CLK(1'b0),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .INMODE({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .MULTSIGNIN(1'b0),
        .MULTSIGNOUT(NLW_seg_energy1_MULTSIGNOUT_UNCONNECTED),
        .OPMODE({1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,1'b1}),
        .OVERFLOW(NLW_seg_energy1_OVERFLOW_UNCONNECTED),
        .P({seg_energy1_n_58,seg_energy1_n_59,seg_energy1_n_60,seg_energy1_n_61,seg_energy1_n_62,seg_energy1_n_63,seg_energy1_n_64,seg_energy1_n_65,seg_energy1_n_66,seg_energy1_n_67,seg_energy1_n_68,seg_energy1_n_69,seg_energy1_n_70,seg_energy1_n_71,seg_energy1_n_72,seg_energy1_n_73,seg_energy1_n_74,seg_energy1_n_75,seg_energy1_n_76,seg_energy1_n_77,seg_energy1_n_78,seg_energy1_n_79,seg_energy1_n_80,seg_energy1_n_81,seg_energy1_n_82,seg_energy1_n_83,seg_energy1_n_84,seg_energy1_n_85,seg_energy1_n_86,seg_energy1_n_87,seg_energy1_n_88,seg_energy1__1[16:0]}),
        .PATTERNBDETECT(NLW_seg_energy1_PATTERNBDETECT_UNCONNECTED),
        .PATTERNDETECT(NLW_seg_energy1_PATTERNDETECT_UNCONNECTED),
        .PCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .PCOUT({seg_energy1_n_106,seg_energy1_n_107,seg_energy1_n_108,seg_energy1_n_109,seg_energy1_n_110,seg_energy1_n_111,seg_energy1_n_112,seg_energy1_n_113,seg_energy1_n_114,seg_energy1_n_115,seg_energy1_n_116,seg_energy1_n_117,seg_energy1_n_118,seg_energy1_n_119,seg_energy1_n_120,seg_energy1_n_121,seg_energy1_n_122,seg_energy1_n_123,seg_energy1_n_124,seg_energy1_n_125,seg_energy1_n_126,seg_energy1_n_127,seg_energy1_n_128,seg_energy1_n_129,seg_energy1_n_130,seg_energy1_n_131,seg_energy1_n_132,seg_energy1_n_133,seg_energy1_n_134,seg_energy1_n_135,seg_energy1_n_136,seg_energy1_n_137,seg_energy1_n_138,seg_energy1_n_139,seg_energy1_n_140,seg_energy1_n_141,seg_energy1_n_142,seg_energy1_n_143,seg_energy1_n_144,seg_energy1_n_145,seg_energy1_n_146,seg_energy1_n_147,seg_energy1_n_148,seg_energy1_n_149,seg_energy1_n_150,seg_energy1_n_151,seg_energy1_n_152,seg_energy1_n_153}),
        .RSTA(1'b0),
        .RSTALLCARRYIN(1'b0),
        .RSTALUMODE(1'b0),
        .RSTB(1'b0),
        .RSTC(1'b0),
        .RSTCTRL(1'b0),
        .RSTD(1'b0),
        .RSTINMODE(1'b0),
        .RSTM(1'b0),
        .RSTP(1'b0),
        .UNDERFLOW(NLW_seg_energy1_UNDERFLOW_UNCONNECTED));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-13 {cell *THIS*}}" *) 
  DSP48E1 #(
    .ACASCREG(0),
    .ADREG(1),
    .ALUMODEREG(0),
    .AREG(0),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(0),
    .BREG(0),
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
    seg_energy1__0
       (.A({sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23:12]}),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT(NLW_seg_energy1__0_ACOUT_UNCONNECTED[29:0]),
        .ALUMODE({1'b0,1'b0,1'b0,1'b0}),
        .B({sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23],sample_in[23]}),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(NLW_seg_energy1__0_BCOUT_UNCONNECTED[17:0]),
        .C({1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(NLW_seg_energy1__0_CARRYCASCOUT_UNCONNECTED),
        .CARRYIN(1'b0),
        .CARRYINSEL({1'b0,1'b0,1'b0}),
        .CARRYOUT(NLW_seg_energy1__0_CARRYOUT_UNCONNECTED[3:0]),
        .CEA1(1'b0),
        .CEA2(1'b0),
        .CEAD(1'b0),
        .CEALUMODE(1'b0),
        .CEB1(1'b0),
        .CEB2(1'b0),
        .CEC(1'b0),
        .CECARRYIN(1'b0),
        .CECTRL(1'b0),
        .CED(1'b0),
        .CEINMODE(1'b0),
        .CEM(1'b0),
        .CEP(1'b0),
        .CLK(1'b0),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .INMODE({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .MULTSIGNIN(1'b0),
        .MULTSIGNOUT(NLW_seg_energy1__0_MULTSIGNOUT_UNCONNECTED),
        .OPMODE({1'b1,1'b0,1'b1,1'b0,1'b1,1'b0,1'b1}),
        .OVERFLOW(NLW_seg_energy1__0_OVERFLOW_UNCONNECTED),
        .P({NLW_seg_energy1__0_P_UNCONNECTED[47:15],seg_energy1__1[31:17]}),
        .PATTERNBDETECT(NLW_seg_energy1__0_PATTERNBDETECT_UNCONNECTED),
        .PATTERNDETECT(NLW_seg_energy1__0_PATTERNDETECT_UNCONNECTED),
        .PCIN({seg_energy1_n_106,seg_energy1_n_107,seg_energy1_n_108,seg_energy1_n_109,seg_energy1_n_110,seg_energy1_n_111,seg_energy1_n_112,seg_energy1_n_113,seg_energy1_n_114,seg_energy1_n_115,seg_energy1_n_116,seg_energy1_n_117,seg_energy1_n_118,seg_energy1_n_119,seg_energy1_n_120,seg_energy1_n_121,seg_energy1_n_122,seg_energy1_n_123,seg_energy1_n_124,seg_energy1_n_125,seg_energy1_n_126,seg_energy1_n_127,seg_energy1_n_128,seg_energy1_n_129,seg_energy1_n_130,seg_energy1_n_131,seg_energy1_n_132,seg_energy1_n_133,seg_energy1_n_134,seg_energy1_n_135,seg_energy1_n_136,seg_energy1_n_137,seg_energy1_n_138,seg_energy1_n_139,seg_energy1_n_140,seg_energy1_n_141,seg_energy1_n_142,seg_energy1_n_143,seg_energy1_n_144,seg_energy1_n_145,seg_energy1_n_146,seg_energy1_n_147,seg_energy1_n_148,seg_energy1_n_149,seg_energy1_n_150,seg_energy1_n_151,seg_energy1_n_152,seg_energy1_n_153}),
        .PCOUT(NLW_seg_energy1__0_PCOUT_UNCONNECTED[47:0]),
        .RSTA(1'b0),
        .RSTALLCARRYIN(1'b0),
        .RSTALUMODE(1'b0),
        .RSTB(1'b0),
        .RSTC(1'b0),
        .RSTCTRL(1'b0),
        .RSTD(1'b0),
        .RSTINMODE(1'b0),
        .RSTM(1'b0),
        .RSTP(1'b0),
        .UNDERFLOW(NLW_seg_energy1__0_UNDERFLOW_UNCONNECTED));
  LUT2 #(
    .INIT(4'h6)) 
    \seg_energy[0]_i_2 
       (.I0(seg_energy1__1[3]),
        .I1(seg_energy_reg[3]),
        .O(\seg_energy[0]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \seg_energy[0]_i_3 
       (.I0(seg_energy1__1[2]),
        .I1(seg_energy_reg[2]),
        .O(\seg_energy[0]_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \seg_energy[0]_i_4 
       (.I0(seg_energy1__1[1]),
        .I1(seg_energy_reg[1]),
        .O(\seg_energy[0]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \seg_energy[0]_i_5 
       (.I0(seg_energy1__1[0]),
        .I1(seg_energy_reg[0]),
        .O(\seg_energy[0]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \seg_energy[12]_i_2 
       (.I0(seg_energy1__1[15]),
        .I1(seg_energy_reg[15]),
        .O(\seg_energy[12]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \seg_energy[12]_i_3 
       (.I0(seg_energy1__1[14]),
        .I1(seg_energy_reg[14]),
        .O(\seg_energy[12]_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \seg_energy[12]_i_4 
       (.I0(seg_energy1__1[13]),
        .I1(seg_energy_reg[13]),
        .O(\seg_energy[12]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \seg_energy[12]_i_5 
       (.I0(seg_energy1__1[12]),
        .I1(seg_energy_reg[12]),
        .O(\seg_energy[12]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \seg_energy[16]_i_2 
       (.I0(seg_energy1__1[19]),
        .I1(seg_energy_reg[19]),
        .O(\seg_energy[16]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \seg_energy[16]_i_3 
       (.I0(seg_energy1__1[18]),
        .I1(seg_energy_reg[18]),
        .O(\seg_energy[16]_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \seg_energy[16]_i_4 
       (.I0(seg_energy1__1[17]),
        .I1(seg_energy_reg[17]),
        .O(\seg_energy[16]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \seg_energy[16]_i_5 
       (.I0(seg_energy1__1[16]),
        .I1(seg_energy_reg[16]),
        .O(\seg_energy[16]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \seg_energy[20]_i_2 
       (.I0(seg_energy1__1[23]),
        .I1(seg_energy_reg[23]),
        .O(\seg_energy[20]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \seg_energy[20]_i_3 
       (.I0(seg_energy1__1[22]),
        .I1(seg_energy_reg[22]),
        .O(\seg_energy[20]_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \seg_energy[20]_i_4 
       (.I0(seg_energy1__1[21]),
        .I1(seg_energy_reg[21]),
        .O(\seg_energy[20]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \seg_energy[20]_i_5 
       (.I0(seg_energy1__1[20]),
        .I1(seg_energy_reg[20]),
        .O(\seg_energy[20]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \seg_energy[24]_i_2 
       (.I0(seg_energy1__1[27]),
        .I1(seg_energy_reg[27]),
        .O(\seg_energy[24]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \seg_energy[24]_i_3 
       (.I0(seg_energy1__1[26]),
        .I1(seg_energy_reg[26]),
        .O(\seg_energy[24]_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \seg_energy[24]_i_4 
       (.I0(seg_energy1__1[25]),
        .I1(seg_energy_reg[25]),
        .O(\seg_energy[24]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \seg_energy[24]_i_5 
       (.I0(seg_energy1__1[24]),
        .I1(seg_energy_reg[24]),
        .O(\seg_energy[24]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \seg_energy[28]_i_2 
       (.I0(seg_energy1__1[31]),
        .I1(seg_energy_reg[31]),
        .O(\seg_energy[28]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \seg_energy[28]_i_3 
       (.I0(seg_energy1__1[30]),
        .I1(seg_energy_reg[30]),
        .O(\seg_energy[28]_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \seg_energy[28]_i_4 
       (.I0(seg_energy1__1[29]),
        .I1(seg_energy_reg[29]),
        .O(\seg_energy[28]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \seg_energy[28]_i_5 
       (.I0(seg_energy1__1[28]),
        .I1(seg_energy_reg[28]),
        .O(\seg_energy[28]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \seg_energy[4]_i_2 
       (.I0(seg_energy1__1[7]),
        .I1(seg_energy_reg[7]),
        .O(\seg_energy[4]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \seg_energy[4]_i_3 
       (.I0(seg_energy1__1[6]),
        .I1(seg_energy_reg[6]),
        .O(\seg_energy[4]_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \seg_energy[4]_i_4 
       (.I0(seg_energy1__1[5]),
        .I1(seg_energy_reg[5]),
        .O(\seg_energy[4]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \seg_energy[4]_i_5 
       (.I0(seg_energy1__1[4]),
        .I1(seg_energy_reg[4]),
        .O(\seg_energy[4]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \seg_energy[8]_i_2 
       (.I0(seg_energy1__1[11]),
        .I1(seg_energy_reg[11]),
        .O(\seg_energy[8]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \seg_energy[8]_i_3 
       (.I0(seg_energy1__1[10]),
        .I1(seg_energy_reg[10]),
        .O(\seg_energy[8]_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \seg_energy[8]_i_4 
       (.I0(seg_energy1__1[9]),
        .I1(seg_energy_reg[9]),
        .O(\seg_energy[8]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \seg_energy[8]_i_5 
       (.I0(seg_energy1__1[8]),
        .I1(seg_energy_reg[8]),
        .O(\seg_energy[8]_i_5_n_0 ));
  FDRE \seg_energy_reg[0] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_energy_reg[0]_i_1_n_7 ),
        .Q(seg_energy_reg[0]),
        .R(seg_ssc));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \seg_energy_reg[0]_i_1 
       (.CI(1'b0),
        .CO({\seg_energy_reg[0]_i_1_n_0 ,\seg_energy_reg[0]_i_1_n_1 ,\seg_energy_reg[0]_i_1_n_2 ,\seg_energy_reg[0]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(seg_energy1__1[3:0]),
        .O({\seg_energy_reg[0]_i_1_n_4 ,\seg_energy_reg[0]_i_1_n_5 ,\seg_energy_reg[0]_i_1_n_6 ,\seg_energy_reg[0]_i_1_n_7 }),
        .S({\seg_energy[0]_i_2_n_0 ,\seg_energy[0]_i_3_n_0 ,\seg_energy[0]_i_4_n_0 ,\seg_energy[0]_i_5_n_0 }));
  FDRE \seg_energy_reg[10] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_energy_reg[8]_i_1_n_5 ),
        .Q(seg_energy_reg[10]),
        .R(seg_ssc));
  FDRE \seg_energy_reg[11] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_energy_reg[8]_i_1_n_4 ),
        .Q(seg_energy_reg[11]),
        .R(seg_ssc));
  FDRE \seg_energy_reg[12] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_energy_reg[12]_i_1_n_7 ),
        .Q(seg_energy_reg[12]),
        .R(seg_ssc));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \seg_energy_reg[12]_i_1 
       (.CI(\seg_energy_reg[8]_i_1_n_0 ),
        .CO({\seg_energy_reg[12]_i_1_n_0 ,\seg_energy_reg[12]_i_1_n_1 ,\seg_energy_reg[12]_i_1_n_2 ,\seg_energy_reg[12]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(seg_energy1__1[15:12]),
        .O({\seg_energy_reg[12]_i_1_n_4 ,\seg_energy_reg[12]_i_1_n_5 ,\seg_energy_reg[12]_i_1_n_6 ,\seg_energy_reg[12]_i_1_n_7 }),
        .S({\seg_energy[12]_i_2_n_0 ,\seg_energy[12]_i_3_n_0 ,\seg_energy[12]_i_4_n_0 ,\seg_energy[12]_i_5_n_0 }));
  FDRE \seg_energy_reg[13] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_energy_reg[12]_i_1_n_6 ),
        .Q(seg_energy_reg[13]),
        .R(seg_ssc));
  FDRE \seg_energy_reg[14] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_energy_reg[12]_i_1_n_5 ),
        .Q(seg_energy_reg[14]),
        .R(seg_ssc));
  FDRE \seg_energy_reg[15] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_energy_reg[12]_i_1_n_4 ),
        .Q(seg_energy_reg[15]),
        .R(seg_ssc));
  FDRE \seg_energy_reg[16] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_energy_reg[16]_i_1_n_7 ),
        .Q(seg_energy_reg[16]),
        .R(seg_ssc));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \seg_energy_reg[16]_i_1 
       (.CI(\seg_energy_reg[12]_i_1_n_0 ),
        .CO({\seg_energy_reg[16]_i_1_n_0 ,\seg_energy_reg[16]_i_1_n_1 ,\seg_energy_reg[16]_i_1_n_2 ,\seg_energy_reg[16]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(seg_energy1__1[19:16]),
        .O({\seg_energy_reg[16]_i_1_n_4 ,\seg_energy_reg[16]_i_1_n_5 ,\seg_energy_reg[16]_i_1_n_6 ,\seg_energy_reg[16]_i_1_n_7 }),
        .S({\seg_energy[16]_i_2_n_0 ,\seg_energy[16]_i_3_n_0 ,\seg_energy[16]_i_4_n_0 ,\seg_energy[16]_i_5_n_0 }));
  FDRE \seg_energy_reg[17] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_energy_reg[16]_i_1_n_6 ),
        .Q(seg_energy_reg[17]),
        .R(seg_ssc));
  FDRE \seg_energy_reg[18] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_energy_reg[16]_i_1_n_5 ),
        .Q(seg_energy_reg[18]),
        .R(seg_ssc));
  FDRE \seg_energy_reg[19] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_energy_reg[16]_i_1_n_4 ),
        .Q(seg_energy_reg[19]),
        .R(seg_ssc));
  FDRE \seg_energy_reg[1] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_energy_reg[0]_i_1_n_6 ),
        .Q(seg_energy_reg[1]),
        .R(seg_ssc));
  FDRE \seg_energy_reg[20] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_energy_reg[20]_i_1_n_7 ),
        .Q(seg_energy_reg[20]),
        .R(seg_ssc));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \seg_energy_reg[20]_i_1 
       (.CI(\seg_energy_reg[16]_i_1_n_0 ),
        .CO({\seg_energy_reg[20]_i_1_n_0 ,\seg_energy_reg[20]_i_1_n_1 ,\seg_energy_reg[20]_i_1_n_2 ,\seg_energy_reg[20]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(seg_energy1__1[23:20]),
        .O({\seg_energy_reg[20]_i_1_n_4 ,\seg_energy_reg[20]_i_1_n_5 ,\seg_energy_reg[20]_i_1_n_6 ,\seg_energy_reg[20]_i_1_n_7 }),
        .S({\seg_energy[20]_i_2_n_0 ,\seg_energy[20]_i_3_n_0 ,\seg_energy[20]_i_4_n_0 ,\seg_energy[20]_i_5_n_0 }));
  FDRE \seg_energy_reg[21] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_energy_reg[20]_i_1_n_6 ),
        .Q(seg_energy_reg[21]),
        .R(seg_ssc));
  FDRE \seg_energy_reg[22] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_energy_reg[20]_i_1_n_5 ),
        .Q(seg_energy_reg[22]),
        .R(seg_ssc));
  FDRE \seg_energy_reg[23] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_energy_reg[20]_i_1_n_4 ),
        .Q(seg_energy_reg[23]),
        .R(seg_ssc));
  FDRE \seg_energy_reg[24] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_energy_reg[24]_i_1_n_7 ),
        .Q(seg_energy_reg[24]),
        .R(seg_ssc));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \seg_energy_reg[24]_i_1 
       (.CI(\seg_energy_reg[20]_i_1_n_0 ),
        .CO({\seg_energy_reg[24]_i_1_n_0 ,\seg_energy_reg[24]_i_1_n_1 ,\seg_energy_reg[24]_i_1_n_2 ,\seg_energy_reg[24]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(seg_energy1__1[27:24]),
        .O({\seg_energy_reg[24]_i_1_n_4 ,\seg_energy_reg[24]_i_1_n_5 ,\seg_energy_reg[24]_i_1_n_6 ,\seg_energy_reg[24]_i_1_n_7 }),
        .S({\seg_energy[24]_i_2_n_0 ,\seg_energy[24]_i_3_n_0 ,\seg_energy[24]_i_4_n_0 ,\seg_energy[24]_i_5_n_0 }));
  FDRE \seg_energy_reg[25] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_energy_reg[24]_i_1_n_6 ),
        .Q(seg_energy_reg[25]),
        .R(seg_ssc));
  FDRE \seg_energy_reg[26] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_energy_reg[24]_i_1_n_5 ),
        .Q(seg_energy_reg[26]),
        .R(seg_ssc));
  FDRE \seg_energy_reg[27] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_energy_reg[24]_i_1_n_4 ),
        .Q(seg_energy_reg[27]),
        .R(seg_ssc));
  FDRE \seg_energy_reg[28] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_energy_reg[28]_i_1_n_7 ),
        .Q(seg_energy_reg[28]),
        .R(seg_ssc));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \seg_energy_reg[28]_i_1 
       (.CI(\seg_energy_reg[24]_i_1_n_0 ),
        .CO({\NLW_seg_energy_reg[28]_i_1_CO_UNCONNECTED [3],\seg_energy_reg[28]_i_1_n_1 ,\seg_energy_reg[28]_i_1_n_2 ,\seg_energy_reg[28]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,seg_energy1__1[30:28]}),
        .O({\seg_energy_reg[28]_i_1_n_4 ,\seg_energy_reg[28]_i_1_n_5 ,\seg_energy_reg[28]_i_1_n_6 ,\seg_energy_reg[28]_i_1_n_7 }),
        .S({\seg_energy[28]_i_2_n_0 ,\seg_energy[28]_i_3_n_0 ,\seg_energy[28]_i_4_n_0 ,\seg_energy[28]_i_5_n_0 }));
  FDRE \seg_energy_reg[29] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_energy_reg[28]_i_1_n_6 ),
        .Q(seg_energy_reg[29]),
        .R(seg_ssc));
  FDRE \seg_energy_reg[2] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_energy_reg[0]_i_1_n_5 ),
        .Q(seg_energy_reg[2]),
        .R(seg_ssc));
  FDRE \seg_energy_reg[30] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_energy_reg[28]_i_1_n_5 ),
        .Q(seg_energy_reg[30]),
        .R(seg_ssc));
  FDRE \seg_energy_reg[31] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_energy_reg[28]_i_1_n_4 ),
        .Q(seg_energy_reg[31]),
        .R(seg_ssc));
  FDRE \seg_energy_reg[3] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_energy_reg[0]_i_1_n_4 ),
        .Q(seg_energy_reg[3]),
        .R(seg_ssc));
  FDRE \seg_energy_reg[4] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_energy_reg[4]_i_1_n_7 ),
        .Q(seg_energy_reg[4]),
        .R(seg_ssc));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \seg_energy_reg[4]_i_1 
       (.CI(\seg_energy_reg[0]_i_1_n_0 ),
        .CO({\seg_energy_reg[4]_i_1_n_0 ,\seg_energy_reg[4]_i_1_n_1 ,\seg_energy_reg[4]_i_1_n_2 ,\seg_energy_reg[4]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(seg_energy1__1[7:4]),
        .O({\seg_energy_reg[4]_i_1_n_4 ,\seg_energy_reg[4]_i_1_n_5 ,\seg_energy_reg[4]_i_1_n_6 ,\seg_energy_reg[4]_i_1_n_7 }),
        .S({\seg_energy[4]_i_2_n_0 ,\seg_energy[4]_i_3_n_0 ,\seg_energy[4]_i_4_n_0 ,\seg_energy[4]_i_5_n_0 }));
  FDRE \seg_energy_reg[5] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_energy_reg[4]_i_1_n_6 ),
        .Q(seg_energy_reg[5]),
        .R(seg_ssc));
  FDRE \seg_energy_reg[6] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_energy_reg[4]_i_1_n_5 ),
        .Q(seg_energy_reg[6]),
        .R(seg_ssc));
  FDRE \seg_energy_reg[7] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_energy_reg[4]_i_1_n_4 ),
        .Q(seg_energy_reg[7]),
        .R(seg_ssc));
  FDRE \seg_energy_reg[8] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_energy_reg[8]_i_1_n_7 ),
        .Q(seg_energy_reg[8]),
        .R(seg_ssc));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \seg_energy_reg[8]_i_1 
       (.CI(\seg_energy_reg[4]_i_1_n_0 ),
        .CO({\seg_energy_reg[8]_i_1_n_0 ,\seg_energy_reg[8]_i_1_n_1 ,\seg_energy_reg[8]_i_1_n_2 ,\seg_energy_reg[8]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(seg_energy1__1[11:8]),
        .O({\seg_energy_reg[8]_i_1_n_4 ,\seg_energy_reg[8]_i_1_n_5 ,\seg_energy_reg[8]_i_1_n_6 ,\seg_energy_reg[8]_i_1_n_7 }),
        .S({\seg_energy[8]_i_2_n_0 ,\seg_energy[8]_i_3_n_0 ,\seg_energy[8]_i_4_n_0 ,\seg_energy[8]_i_5_n_0 }));
  FDRE \seg_energy_reg[9] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_energy_reg[8]_i_1_n_6 ),
        .Q(seg_energy_reg[9]),
        .R(seg_ssc));
  LUT3 #(
    .INIT(8'hB8)) 
    \seg_mav[0]_i_2 
       (.I0(seg_mav2[3]),
        .I1(sample_in[23]),
        .I2(sample_in[3]),
        .O(in[3]));
  LUT3 #(
    .INIT(8'hB8)) 
    \seg_mav[0]_i_3 
       (.I0(seg_mav2[2]),
        .I1(sample_in[23]),
        .I2(sample_in[2]),
        .O(in[2]));
  LUT3 #(
    .INIT(8'hB8)) 
    \seg_mav[0]_i_4 
       (.I0(seg_mav2[1]),
        .I1(sample_in[23]),
        .I2(sample_in[1]),
        .O(in[1]));
  LUT4 #(
    .INIT(16'h1DE2)) 
    \seg_mav[0]_i_5 
       (.I0(sample_in[3]),
        .I1(sample_in[23]),
        .I2(seg_mav2[3]),
        .I3(seg_mav_reg[3]),
        .O(\seg_mav[0]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'h1DE2)) 
    \seg_mav[0]_i_6 
       (.I0(sample_in[2]),
        .I1(sample_in[23]),
        .I2(seg_mav2[2]),
        .I3(seg_mav_reg[2]),
        .O(\seg_mav[0]_i_6_n_0 ));
  LUT4 #(
    .INIT(16'h1DE2)) 
    \seg_mav[0]_i_7 
       (.I0(sample_in[1]),
        .I1(sample_in[23]),
        .I2(seg_mav2[1]),
        .I3(seg_mav_reg[1]),
        .O(\seg_mav[0]_i_7_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \seg_mav[0]_i_8 
       (.I0(sample_in[0]),
        .I1(seg_mav_reg[0]),
        .O(\seg_mav[0]_i_8_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \seg_mav[12]_i_2 
       (.I0(seg_mav2[15]),
        .I1(sample_in[23]),
        .I2(sample_in[15]),
        .O(in[15]));
  LUT3 #(
    .INIT(8'hB8)) 
    \seg_mav[12]_i_3 
       (.I0(seg_mav2[14]),
        .I1(sample_in[23]),
        .I2(sample_in[14]),
        .O(in[14]));
  LUT3 #(
    .INIT(8'hB8)) 
    \seg_mav[12]_i_4 
       (.I0(seg_mav2[13]),
        .I1(sample_in[23]),
        .I2(sample_in[13]),
        .O(in[13]));
  LUT3 #(
    .INIT(8'hB8)) 
    \seg_mav[12]_i_5 
       (.I0(seg_mav2[12]),
        .I1(sample_in[23]),
        .I2(sample_in[12]),
        .O(in[12]));
  LUT4 #(
    .INIT(16'h1DE2)) 
    \seg_mav[12]_i_6 
       (.I0(sample_in[15]),
        .I1(sample_in[23]),
        .I2(seg_mav2[15]),
        .I3(seg_mav_reg[15]),
        .O(\seg_mav[12]_i_6_n_0 ));
  LUT4 #(
    .INIT(16'h1DE2)) 
    \seg_mav[12]_i_7 
       (.I0(sample_in[14]),
        .I1(sample_in[23]),
        .I2(seg_mav2[14]),
        .I3(seg_mav_reg[14]),
        .O(\seg_mav[12]_i_7_n_0 ));
  LUT4 #(
    .INIT(16'h1DE2)) 
    \seg_mav[12]_i_8 
       (.I0(sample_in[13]),
        .I1(sample_in[23]),
        .I2(seg_mav2[13]),
        .I3(seg_mav_reg[13]),
        .O(\seg_mav[12]_i_8_n_0 ));
  LUT4 #(
    .INIT(16'h1DE2)) 
    \seg_mav[12]_i_9 
       (.I0(sample_in[12]),
        .I1(sample_in[23]),
        .I2(seg_mav2[12]),
        .I3(seg_mav_reg[12]),
        .O(\seg_mav[12]_i_9_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \seg_mav[16]_i_2 
       (.I0(seg_mav2[19]),
        .I1(sample_in[23]),
        .I2(sample_in[19]),
        .O(in[19]));
  LUT3 #(
    .INIT(8'hB8)) 
    \seg_mav[16]_i_3 
       (.I0(seg_mav2[18]),
        .I1(sample_in[23]),
        .I2(sample_in[18]),
        .O(in[18]));
  LUT3 #(
    .INIT(8'hB8)) 
    \seg_mav[16]_i_4 
       (.I0(seg_mav2[17]),
        .I1(sample_in[23]),
        .I2(sample_in[17]),
        .O(in[17]));
  LUT3 #(
    .INIT(8'hB8)) 
    \seg_mav[16]_i_5 
       (.I0(seg_mav2[16]),
        .I1(sample_in[23]),
        .I2(sample_in[16]),
        .O(in[16]));
  LUT4 #(
    .INIT(16'h1DE2)) 
    \seg_mav[16]_i_6 
       (.I0(sample_in[19]),
        .I1(sample_in[23]),
        .I2(seg_mav2[19]),
        .I3(seg_mav_reg[19]),
        .O(\seg_mav[16]_i_6_n_0 ));
  LUT4 #(
    .INIT(16'h1DE2)) 
    \seg_mav[16]_i_7 
       (.I0(sample_in[18]),
        .I1(sample_in[23]),
        .I2(seg_mav2[18]),
        .I3(seg_mav_reg[18]),
        .O(\seg_mav[16]_i_7_n_0 ));
  LUT4 #(
    .INIT(16'h1DE2)) 
    \seg_mav[16]_i_8 
       (.I0(sample_in[17]),
        .I1(sample_in[23]),
        .I2(seg_mav2[17]),
        .I3(seg_mav_reg[17]),
        .O(\seg_mav[16]_i_8_n_0 ));
  LUT4 #(
    .INIT(16'h1DE2)) 
    \seg_mav[16]_i_9 
       (.I0(sample_in[16]),
        .I1(sample_in[23]),
        .I2(seg_mav2[16]),
        .I3(seg_mav_reg[16]),
        .O(\seg_mav[16]_i_9_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    \seg_mav[20]_i_2 
       (.I0(sample_in[23]),
        .I1(seg_mav2[23]),
        .O(in[23]));
  LUT3 #(
    .INIT(8'hB8)) 
    \seg_mav[20]_i_3 
       (.I0(seg_mav2[22]),
        .I1(sample_in[23]),
        .I2(sample_in[22]),
        .O(in[22]));
  LUT3 #(
    .INIT(8'hB8)) 
    \seg_mav[20]_i_4 
       (.I0(seg_mav2[21]),
        .I1(sample_in[23]),
        .I2(sample_in[21]),
        .O(in[21]));
  LUT3 #(
    .INIT(8'hB8)) 
    \seg_mav[20]_i_5 
       (.I0(seg_mav2[20]),
        .I1(sample_in[23]),
        .I2(sample_in[20]),
        .O(in[20]));
  LUT3 #(
    .INIT(8'h78)) 
    \seg_mav[20]_i_6 
       (.I0(seg_mav2[23]),
        .I1(sample_in[23]),
        .I2(seg_mav_reg[23]),
        .O(\seg_mav[20]_i_6_n_0 ));
  LUT4 #(
    .INIT(16'h1DE2)) 
    \seg_mav[20]_i_7 
       (.I0(sample_in[22]),
        .I1(sample_in[23]),
        .I2(seg_mav2[22]),
        .I3(seg_mav_reg[22]),
        .O(\seg_mav[20]_i_7_n_0 ));
  LUT4 #(
    .INIT(16'h1DE2)) 
    \seg_mav[20]_i_8 
       (.I0(sample_in[21]),
        .I1(sample_in[23]),
        .I2(seg_mav2[21]),
        .I3(seg_mav_reg[21]),
        .O(\seg_mav[20]_i_8_n_0 ));
  LUT4 #(
    .INIT(16'h1DE2)) 
    \seg_mav[20]_i_9 
       (.I0(sample_in[20]),
        .I1(sample_in[23]),
        .I2(seg_mav2[20]),
        .I3(seg_mav_reg[20]),
        .O(\seg_mav[20]_i_9_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \seg_mav[24]_i_2 
       (.I0(sample_in[23]),
        .I1(\ring_mav_reg[3][27]_i_3_n_0 ),
        .O(in[24]));
  LUT3 #(
    .INIT(8'hB4)) 
    \seg_mav[24]_i_3 
       (.I0(\ring_mav_reg[3][27]_i_3_n_0 ),
        .I1(sample_in[23]),
        .I2(seg_mav_reg[24]),
        .O(\seg_mav[24]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \seg_mav[4]_i_2 
       (.I0(seg_mav2[7]),
        .I1(sample_in[23]),
        .I2(sample_in[7]),
        .O(in[7]));
  LUT3 #(
    .INIT(8'hB8)) 
    \seg_mav[4]_i_3 
       (.I0(seg_mav2[6]),
        .I1(sample_in[23]),
        .I2(sample_in[6]),
        .O(in[6]));
  LUT3 #(
    .INIT(8'hB8)) 
    \seg_mav[4]_i_4 
       (.I0(seg_mav2[5]),
        .I1(sample_in[23]),
        .I2(sample_in[5]),
        .O(in[5]));
  LUT3 #(
    .INIT(8'hB8)) 
    \seg_mav[4]_i_5 
       (.I0(seg_mav2[4]),
        .I1(sample_in[23]),
        .I2(sample_in[4]),
        .O(in[4]));
  LUT4 #(
    .INIT(16'h1DE2)) 
    \seg_mav[4]_i_6 
       (.I0(sample_in[7]),
        .I1(sample_in[23]),
        .I2(seg_mav2[7]),
        .I3(seg_mav_reg[7]),
        .O(\seg_mav[4]_i_6_n_0 ));
  LUT4 #(
    .INIT(16'h1DE2)) 
    \seg_mav[4]_i_7 
       (.I0(sample_in[6]),
        .I1(sample_in[23]),
        .I2(seg_mav2[6]),
        .I3(seg_mav_reg[6]),
        .O(\seg_mav[4]_i_7_n_0 ));
  LUT4 #(
    .INIT(16'h1DE2)) 
    \seg_mav[4]_i_8 
       (.I0(sample_in[5]),
        .I1(sample_in[23]),
        .I2(seg_mav2[5]),
        .I3(seg_mav_reg[5]),
        .O(\seg_mav[4]_i_8_n_0 ));
  LUT4 #(
    .INIT(16'h1DE2)) 
    \seg_mav[4]_i_9 
       (.I0(sample_in[4]),
        .I1(sample_in[23]),
        .I2(seg_mav2[4]),
        .I3(seg_mav_reg[4]),
        .O(\seg_mav[4]_i_9_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \seg_mav[8]_i_2 
       (.I0(seg_mav2[11]),
        .I1(sample_in[23]),
        .I2(sample_in[11]),
        .O(in[11]));
  LUT3 #(
    .INIT(8'hB8)) 
    \seg_mav[8]_i_3 
       (.I0(seg_mav2[10]),
        .I1(sample_in[23]),
        .I2(sample_in[10]),
        .O(in[10]));
  LUT3 #(
    .INIT(8'hB8)) 
    \seg_mav[8]_i_4 
       (.I0(seg_mav2[9]),
        .I1(sample_in[23]),
        .I2(sample_in[9]),
        .O(in[9]));
  LUT3 #(
    .INIT(8'hB8)) 
    \seg_mav[8]_i_5 
       (.I0(seg_mav2[8]),
        .I1(sample_in[23]),
        .I2(sample_in[8]),
        .O(in[8]));
  LUT4 #(
    .INIT(16'h1DE2)) 
    \seg_mav[8]_i_6 
       (.I0(sample_in[11]),
        .I1(sample_in[23]),
        .I2(seg_mav2[11]),
        .I3(seg_mav_reg[11]),
        .O(\seg_mav[8]_i_6_n_0 ));
  LUT4 #(
    .INIT(16'h1DE2)) 
    \seg_mav[8]_i_7 
       (.I0(sample_in[10]),
        .I1(sample_in[23]),
        .I2(seg_mav2[10]),
        .I3(seg_mav_reg[10]),
        .O(\seg_mav[8]_i_7_n_0 ));
  LUT4 #(
    .INIT(16'h1DE2)) 
    \seg_mav[8]_i_8 
       (.I0(sample_in[9]),
        .I1(sample_in[23]),
        .I2(seg_mav2[9]),
        .I3(seg_mav_reg[9]),
        .O(\seg_mav[8]_i_8_n_0 ));
  LUT4 #(
    .INIT(16'h1DE2)) 
    \seg_mav[8]_i_9 
       (.I0(sample_in[8]),
        .I1(sample_in[23]),
        .I2(seg_mav2[8]),
        .I3(seg_mav_reg[8]),
        .O(\seg_mav[8]_i_9_n_0 ));
  FDRE \seg_mav_reg[0] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_mav_reg[0]_i_1_n_7 ),
        .Q(seg_mav_reg[0]),
        .R(seg_ssc));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \seg_mav_reg[0]_i_1 
       (.CI(1'b0),
        .CO({\seg_mav_reg[0]_i_1_n_0 ,\seg_mav_reg[0]_i_1_n_1 ,\seg_mav_reg[0]_i_1_n_2 ,\seg_mav_reg[0]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({in[3:1],sample_in[0]}),
        .O({\seg_mav_reg[0]_i_1_n_4 ,\seg_mav_reg[0]_i_1_n_5 ,\seg_mav_reg[0]_i_1_n_6 ,\seg_mav_reg[0]_i_1_n_7 }),
        .S({\seg_mav[0]_i_5_n_0 ,\seg_mav[0]_i_6_n_0 ,\seg_mav[0]_i_7_n_0 ,\seg_mav[0]_i_8_n_0 }));
  FDRE \seg_mav_reg[10] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_mav_reg[8]_i_1_n_5 ),
        .Q(seg_mav_reg[10]),
        .R(seg_ssc));
  FDRE \seg_mav_reg[11] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_mav_reg[8]_i_1_n_4 ),
        .Q(seg_mav_reg[11]),
        .R(seg_ssc));
  FDRE \seg_mav_reg[12] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_mav_reg[12]_i_1_n_7 ),
        .Q(seg_mav_reg[12]),
        .R(seg_ssc));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \seg_mav_reg[12]_i_1 
       (.CI(\seg_mav_reg[8]_i_1_n_0 ),
        .CO({\seg_mav_reg[12]_i_1_n_0 ,\seg_mav_reg[12]_i_1_n_1 ,\seg_mav_reg[12]_i_1_n_2 ,\seg_mav_reg[12]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(in[15:12]),
        .O({\seg_mav_reg[12]_i_1_n_4 ,\seg_mav_reg[12]_i_1_n_5 ,\seg_mav_reg[12]_i_1_n_6 ,\seg_mav_reg[12]_i_1_n_7 }),
        .S({\seg_mav[12]_i_6_n_0 ,\seg_mav[12]_i_7_n_0 ,\seg_mav[12]_i_8_n_0 ,\seg_mav[12]_i_9_n_0 }));
  FDRE \seg_mav_reg[13] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_mav_reg[12]_i_1_n_6 ),
        .Q(seg_mav_reg[13]),
        .R(seg_ssc));
  FDRE \seg_mav_reg[14] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_mav_reg[12]_i_1_n_5 ),
        .Q(seg_mav_reg[14]),
        .R(seg_ssc));
  FDRE \seg_mav_reg[15] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_mav_reg[12]_i_1_n_4 ),
        .Q(seg_mav_reg[15]),
        .R(seg_ssc));
  FDRE \seg_mav_reg[16] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_mav_reg[16]_i_1_n_7 ),
        .Q(seg_mav_reg[16]),
        .R(seg_ssc));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \seg_mav_reg[16]_i_1 
       (.CI(\seg_mav_reg[12]_i_1_n_0 ),
        .CO({\seg_mav_reg[16]_i_1_n_0 ,\seg_mav_reg[16]_i_1_n_1 ,\seg_mav_reg[16]_i_1_n_2 ,\seg_mav_reg[16]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(in[19:16]),
        .O({\seg_mav_reg[16]_i_1_n_4 ,\seg_mav_reg[16]_i_1_n_5 ,\seg_mav_reg[16]_i_1_n_6 ,\seg_mav_reg[16]_i_1_n_7 }),
        .S({\seg_mav[16]_i_6_n_0 ,\seg_mav[16]_i_7_n_0 ,\seg_mav[16]_i_8_n_0 ,\seg_mav[16]_i_9_n_0 }));
  FDRE \seg_mav_reg[17] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_mav_reg[16]_i_1_n_6 ),
        .Q(seg_mav_reg[17]),
        .R(seg_ssc));
  FDRE \seg_mav_reg[18] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_mav_reg[16]_i_1_n_5 ),
        .Q(seg_mav_reg[18]),
        .R(seg_ssc));
  FDRE \seg_mav_reg[19] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_mav_reg[16]_i_1_n_4 ),
        .Q(seg_mav_reg[19]),
        .R(seg_ssc));
  FDRE \seg_mav_reg[1] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_mav_reg[0]_i_1_n_6 ),
        .Q(seg_mav_reg[1]),
        .R(seg_ssc));
  FDRE \seg_mav_reg[20] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_mav_reg[20]_i_1_n_7 ),
        .Q(seg_mav_reg[20]),
        .R(seg_ssc));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \seg_mav_reg[20]_i_1 
       (.CI(\seg_mav_reg[16]_i_1_n_0 ),
        .CO({\seg_mav_reg[20]_i_1_n_0 ,\seg_mav_reg[20]_i_1_n_1 ,\seg_mav_reg[20]_i_1_n_2 ,\seg_mav_reg[20]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(in[23:20]),
        .O({\seg_mav_reg[20]_i_1_n_4 ,\seg_mav_reg[20]_i_1_n_5 ,\seg_mav_reg[20]_i_1_n_6 ,\seg_mav_reg[20]_i_1_n_7 }),
        .S({\seg_mav[20]_i_6_n_0 ,\seg_mav[20]_i_7_n_0 ,\seg_mav[20]_i_8_n_0 ,\seg_mav[20]_i_9_n_0 }));
  FDRE \seg_mav_reg[21] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_mav_reg[20]_i_1_n_6 ),
        .Q(seg_mav_reg[21]),
        .R(seg_ssc));
  FDRE \seg_mav_reg[22] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_mav_reg[20]_i_1_n_5 ),
        .Q(seg_mav_reg[22]),
        .R(seg_ssc));
  FDRE \seg_mav_reg[23] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_mav_reg[20]_i_1_n_4 ),
        .Q(seg_mav_reg[23]),
        .R(seg_ssc));
  FDRE \seg_mav_reg[24] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_mav_reg[24]_i_1_n_7 ),
        .Q(seg_mav_reg[24]),
        .R(seg_ssc));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \seg_mav_reg[24]_i_1 
       (.CI(\seg_mav_reg[20]_i_1_n_0 ),
        .CO({\seg_mav_reg[24]_i_1_n_0 ,\seg_mav_reg[24]_i_1_n_1 ,\seg_mav_reg[24]_i_1_n_2 ,\seg_mav_reg[24]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,in[24]}),
        .O({\seg_mav_reg[24]_i_1_n_4 ,\seg_mav_reg[24]_i_1_n_5 ,\seg_mav_reg[24]_i_1_n_6 ,\seg_mav_reg[24]_i_1_n_7 }),
        .S({seg_mav_reg[27:25],\seg_mav[24]_i_3_n_0 }));
  FDRE \seg_mav_reg[25] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_mav_reg[24]_i_1_n_6 ),
        .Q(seg_mav_reg[25]),
        .R(seg_ssc));
  FDRE \seg_mav_reg[26] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_mav_reg[24]_i_1_n_5 ),
        .Q(seg_mav_reg[26]),
        .R(seg_ssc));
  FDRE \seg_mav_reg[27] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_mav_reg[24]_i_1_n_4 ),
        .Q(seg_mav_reg[27]),
        .R(seg_ssc));
  FDRE \seg_mav_reg[28] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_mav_reg[28]_i_1_n_7 ),
        .Q(seg_mav_reg[28]),
        .R(seg_ssc));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \seg_mav_reg[28]_i_1 
       (.CI(\seg_mav_reg[24]_i_1_n_0 ),
        .CO({\NLW_seg_mav_reg[28]_i_1_CO_UNCONNECTED [3],\seg_mav_reg[28]_i_1_n_1 ,\seg_mav_reg[28]_i_1_n_2 ,\seg_mav_reg[28]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\seg_mav_reg[28]_i_1_n_4 ,\seg_mav_reg[28]_i_1_n_5 ,\seg_mav_reg[28]_i_1_n_6 ,\seg_mav_reg[28]_i_1_n_7 }),
        .S(seg_mav_reg[31:28]));
  FDRE \seg_mav_reg[29] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_mav_reg[28]_i_1_n_6 ),
        .Q(seg_mav_reg[29]),
        .R(seg_ssc));
  FDRE \seg_mav_reg[2] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_mav_reg[0]_i_1_n_5 ),
        .Q(seg_mav_reg[2]),
        .R(seg_ssc));
  FDRE \seg_mav_reg[30] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_mav_reg[28]_i_1_n_5 ),
        .Q(seg_mav_reg[30]),
        .R(seg_ssc));
  FDRE \seg_mav_reg[31] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_mav_reg[28]_i_1_n_4 ),
        .Q(seg_mav_reg[31]),
        .R(seg_ssc));
  FDRE \seg_mav_reg[3] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_mav_reg[0]_i_1_n_4 ),
        .Q(seg_mav_reg[3]),
        .R(seg_ssc));
  FDRE \seg_mav_reg[4] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_mav_reg[4]_i_1_n_7 ),
        .Q(seg_mav_reg[4]),
        .R(seg_ssc));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \seg_mav_reg[4]_i_1 
       (.CI(\seg_mav_reg[0]_i_1_n_0 ),
        .CO({\seg_mav_reg[4]_i_1_n_0 ,\seg_mav_reg[4]_i_1_n_1 ,\seg_mav_reg[4]_i_1_n_2 ,\seg_mav_reg[4]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(in[7:4]),
        .O({\seg_mav_reg[4]_i_1_n_4 ,\seg_mav_reg[4]_i_1_n_5 ,\seg_mav_reg[4]_i_1_n_6 ,\seg_mav_reg[4]_i_1_n_7 }),
        .S({\seg_mav[4]_i_6_n_0 ,\seg_mav[4]_i_7_n_0 ,\seg_mav[4]_i_8_n_0 ,\seg_mav[4]_i_9_n_0 }));
  FDRE \seg_mav_reg[5] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_mav_reg[4]_i_1_n_6 ),
        .Q(seg_mav_reg[5]),
        .R(seg_ssc));
  FDRE \seg_mav_reg[6] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_mav_reg[4]_i_1_n_5 ),
        .Q(seg_mav_reg[6]),
        .R(seg_ssc));
  FDRE \seg_mav_reg[7] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_mav_reg[4]_i_1_n_4 ),
        .Q(seg_mav_reg[7]),
        .R(seg_ssc));
  FDRE \seg_mav_reg[8] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_mav_reg[8]_i_1_n_7 ),
        .Q(seg_mav_reg[8]),
        .R(seg_ssc));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \seg_mav_reg[8]_i_1 
       (.CI(\seg_mav_reg[4]_i_1_n_0 ),
        .CO({\seg_mav_reg[8]_i_1_n_0 ,\seg_mav_reg[8]_i_1_n_1 ,\seg_mav_reg[8]_i_1_n_2 ,\seg_mav_reg[8]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(in[11:8]),
        .O({\seg_mav_reg[8]_i_1_n_4 ,\seg_mav_reg[8]_i_1_n_5 ,\seg_mav_reg[8]_i_1_n_6 ,\seg_mav_reg[8]_i_1_n_7 }),
        .S({\seg_mav[8]_i_6_n_0 ,\seg_mav[8]_i_7_n_0 ,\seg_mav[8]_i_8_n_0 ,\seg_mav[8]_i_9_n_0 }));
  FDRE \seg_mav_reg[9] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_mav_reg[8]_i_1_n_6 ),
        .Q(seg_mav_reg[9]),
        .R(seg_ssc));
  FDRE \seg_ssc_reg[0] 
       (.C(clk),
        .CE(sample_valid),
        .D(\ring_ssc[3][0]_i_1_n_0 ),
        .Q(seg_ssc_reg[0]),
        .R(seg_ssc));
  FDRE \seg_ssc_reg[1] 
       (.C(clk),
        .CE(sample_valid),
        .D(\ring_ssc[3][1]_i_1_n_0 ),
        .Q(seg_ssc_reg[1]),
        .R(seg_ssc));
  FDRE \seg_ssc_reg[2] 
       (.C(clk),
        .CE(sample_valid),
        .D(\ring_ssc[3][2]_i_1_n_0 ),
        .Q(seg_ssc_reg[2]),
        .R(seg_ssc));
  FDRE \seg_ssc_reg[3] 
       (.C(clk),
        .CE(sample_valid),
        .D(\ring_ssc[3][3]_i_1_n_0 ),
        .Q(seg_ssc_reg[3]),
        .R(seg_ssc));
  FDRE \seg_ssc_reg[4] 
       (.C(clk),
        .CE(sample_valid),
        .D(\ring_ssc[3][4]_i_1_n_0 ),
        .Q(seg_ssc_reg[4]),
        .R(seg_ssc));
  FDRE \seg_ssc_reg[5] 
       (.C(clk),
        .CE(sample_valid),
        .D(\ring_ssc[3][5]_i_1_n_0 ),
        .Q(seg_ssc_reg[5]),
        .R(seg_ssc));
  FDRE \seg_ssc_reg[6] 
       (.C(clk),
        .CE(sample_valid),
        .D(\ring_ssc[3][6]_i_1_n_0 ),
        .Q(seg_ssc_reg[6]),
        .R(seg_ssc));
  LUT4 #(
    .INIT(16'hA808)) 
    \seg_wl[0]_i_2 
       (.I0(have_prev),
        .I1(abs_diff1[3]),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(\ring_wl_reg[3][3]_i_6_n_4 ),
        .O(abs_diff[3]));
  LUT4 #(
    .INIT(16'hA808)) 
    \seg_wl[0]_i_3 
       (.I0(have_prev),
        .I1(abs_diff1[2]),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(\ring_wl_reg[3][3]_i_6_n_5 ),
        .O(abs_diff[2]));
  LUT4 #(
    .INIT(16'hA808)) 
    \seg_wl[0]_i_4 
       (.I0(have_prev),
        .I1(abs_diff1[1]),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(\ring_wl_reg[3][3]_i_6_n_6 ),
        .O(abs_diff[1]));
  LUT2 #(
    .INIT(4'h8)) 
    \seg_wl[0]_i_5 
       (.I0(have_prev),
        .I1(\ring_wl_reg[3][3]_i_6_n_7 ),
        .O(\seg_wl[0]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'h47FFB800)) 
    \seg_wl[0]_i_6 
       (.I0(\ring_wl_reg[3][3]_i_6_n_4 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[3]),
        .I3(have_prev),
        .I4(seg_wl_reg[3]),
        .O(\seg_wl[0]_i_6_n_0 ));
  LUT5 #(
    .INIT(32'h47FFB800)) 
    \seg_wl[0]_i_7 
       (.I0(\ring_wl_reg[3][3]_i_6_n_5 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[2]),
        .I3(have_prev),
        .I4(seg_wl_reg[2]),
        .O(\seg_wl[0]_i_7_n_0 ));
  LUT5 #(
    .INIT(32'h47FFB800)) 
    \seg_wl[0]_i_8 
       (.I0(\ring_wl_reg[3][3]_i_6_n_6 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[1]),
        .I3(have_prev),
        .I4(seg_wl_reg[1]),
        .O(\seg_wl[0]_i_8_n_0 ));
  LUT3 #(
    .INIT(8'h78)) 
    \seg_wl[0]_i_9 
       (.I0(\ring_wl_reg[3][3]_i_6_n_7 ),
        .I1(have_prev),
        .I2(seg_wl_reg[0]),
        .O(\seg_wl[0]_i_9_n_0 ));
  LUT4 #(
    .INIT(16'hA808)) 
    \seg_wl[12]_i_2 
       (.I0(have_prev),
        .I1(abs_diff1[15]),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(\ring_wl_reg[3][15]_i_6_n_4 ),
        .O(abs_diff[15]));
  LUT4 #(
    .INIT(16'hA808)) 
    \seg_wl[12]_i_3 
       (.I0(have_prev),
        .I1(abs_diff1[14]),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(\ring_wl_reg[3][15]_i_6_n_5 ),
        .O(abs_diff[14]));
  LUT4 #(
    .INIT(16'hA808)) 
    \seg_wl[12]_i_4 
       (.I0(have_prev),
        .I1(abs_diff1[13]),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(\ring_wl_reg[3][15]_i_6_n_6 ),
        .O(abs_diff[13]));
  LUT4 #(
    .INIT(16'hA808)) 
    \seg_wl[12]_i_5 
       (.I0(have_prev),
        .I1(abs_diff1[12]),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(\ring_wl_reg[3][15]_i_6_n_7 ),
        .O(abs_diff[12]));
  LUT5 #(
    .INIT(32'h47FFB800)) 
    \seg_wl[12]_i_6 
       (.I0(\ring_wl_reg[3][15]_i_6_n_4 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[15]),
        .I3(have_prev),
        .I4(seg_wl_reg[15]),
        .O(\seg_wl[12]_i_6_n_0 ));
  LUT5 #(
    .INIT(32'h47FFB800)) 
    \seg_wl[12]_i_7 
       (.I0(\ring_wl_reg[3][15]_i_6_n_5 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[14]),
        .I3(have_prev),
        .I4(seg_wl_reg[14]),
        .O(\seg_wl[12]_i_7_n_0 ));
  LUT5 #(
    .INIT(32'h47FFB800)) 
    \seg_wl[12]_i_8 
       (.I0(\ring_wl_reg[3][15]_i_6_n_6 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[13]),
        .I3(have_prev),
        .I4(seg_wl_reg[13]),
        .O(\seg_wl[12]_i_8_n_0 ));
  LUT5 #(
    .INIT(32'h47FFB800)) 
    \seg_wl[12]_i_9 
       (.I0(\ring_wl_reg[3][15]_i_6_n_7 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[12]),
        .I3(have_prev),
        .I4(seg_wl_reg[12]),
        .O(\seg_wl[12]_i_9_n_0 ));
  LUT4 #(
    .INIT(16'hA808)) 
    \seg_wl[16]_i_2 
       (.I0(have_prev),
        .I1(abs_diff1[19]),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(\ring_wl_reg[3][19]_i_6_n_4 ),
        .O(abs_diff[19]));
  LUT4 #(
    .INIT(16'hA808)) 
    \seg_wl[16]_i_3 
       (.I0(have_prev),
        .I1(abs_diff1[18]),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(\ring_wl_reg[3][19]_i_6_n_5 ),
        .O(abs_diff[18]));
  LUT4 #(
    .INIT(16'hA808)) 
    \seg_wl[16]_i_4 
       (.I0(have_prev),
        .I1(abs_diff1[17]),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(\ring_wl_reg[3][19]_i_6_n_6 ),
        .O(abs_diff[17]));
  LUT4 #(
    .INIT(16'hA808)) 
    \seg_wl[16]_i_5 
       (.I0(have_prev),
        .I1(abs_diff1[16]),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(\ring_wl_reg[3][19]_i_6_n_7 ),
        .O(abs_diff[16]));
  LUT5 #(
    .INIT(32'h47FFB800)) 
    \seg_wl[16]_i_6 
       (.I0(\ring_wl_reg[3][19]_i_6_n_4 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[19]),
        .I3(have_prev),
        .I4(seg_wl_reg[19]),
        .O(\seg_wl[16]_i_6_n_0 ));
  LUT5 #(
    .INIT(32'h47FFB800)) 
    \seg_wl[16]_i_7 
       (.I0(\ring_wl_reg[3][19]_i_6_n_5 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[18]),
        .I3(have_prev),
        .I4(seg_wl_reg[18]),
        .O(\seg_wl[16]_i_7_n_0 ));
  LUT5 #(
    .INIT(32'h47FFB800)) 
    \seg_wl[16]_i_8 
       (.I0(\ring_wl_reg[3][19]_i_6_n_6 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[17]),
        .I3(have_prev),
        .I4(seg_wl_reg[17]),
        .O(\seg_wl[16]_i_8_n_0 ));
  LUT5 #(
    .INIT(32'h47FFB800)) 
    \seg_wl[16]_i_9 
       (.I0(\ring_wl_reg[3][19]_i_6_n_7 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[16]),
        .I3(have_prev),
        .I4(seg_wl_reg[16]),
        .O(\seg_wl[16]_i_9_n_0 ));
  LUT4 #(
    .INIT(16'hA808)) 
    \seg_wl[20]_i_2 
       (.I0(have_prev),
        .I1(abs_diff1[23]),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(\ring_wl_reg[3][23]_i_6_n_4 ),
        .O(abs_diff[23]));
  LUT4 #(
    .INIT(16'hA808)) 
    \seg_wl[20]_i_3 
       (.I0(have_prev),
        .I1(abs_diff1[22]),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(\ring_wl_reg[3][23]_i_6_n_5 ),
        .O(abs_diff[22]));
  LUT4 #(
    .INIT(16'hA808)) 
    \seg_wl[20]_i_4 
       (.I0(have_prev),
        .I1(abs_diff1[21]),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(\ring_wl_reg[3][23]_i_6_n_6 ),
        .O(abs_diff[21]));
  LUT4 #(
    .INIT(16'hA808)) 
    \seg_wl[20]_i_5 
       (.I0(have_prev),
        .I1(abs_diff1[20]),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(\ring_wl_reg[3][23]_i_6_n_7 ),
        .O(abs_diff[20]));
  LUT5 #(
    .INIT(32'h47FFB800)) 
    \seg_wl[20]_i_6 
       (.I0(\ring_wl_reg[3][23]_i_6_n_4 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[23]),
        .I3(have_prev),
        .I4(seg_wl_reg[23]),
        .O(\seg_wl[20]_i_6_n_0 ));
  LUT5 #(
    .INIT(32'h47FFB800)) 
    \seg_wl[20]_i_7 
       (.I0(\ring_wl_reg[3][23]_i_6_n_5 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[22]),
        .I3(have_prev),
        .I4(seg_wl_reg[22]),
        .O(\seg_wl[20]_i_7_n_0 ));
  LUT5 #(
    .INIT(32'h47FFB800)) 
    \seg_wl[20]_i_8 
       (.I0(\ring_wl_reg[3][23]_i_6_n_6 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[21]),
        .I3(have_prev),
        .I4(seg_wl_reg[21]),
        .O(\seg_wl[20]_i_8_n_0 ));
  LUT5 #(
    .INIT(32'h47FFB800)) 
    \seg_wl[20]_i_9 
       (.I0(\ring_wl_reg[3][23]_i_6_n_7 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[20]),
        .I3(have_prev),
        .I4(seg_wl_reg[20]),
        .O(\seg_wl[20]_i_9_n_0 ));
  LUT3 #(
    .INIT(8'h40)) 
    \seg_wl[24]_i_2 
       (.I0(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I1(have_prev),
        .I2(abs_diff1[24]),
        .O(\seg_wl[24]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'hF708)) 
    \seg_wl[24]_i_3 
       (.I0(abs_diff1[24]),
        .I1(have_prev),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(seg_wl_reg[24]),
        .O(\seg_wl[24]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'hA808)) 
    \seg_wl[4]_i_2 
       (.I0(have_prev),
        .I1(abs_diff1[7]),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(\ring_wl_reg[3][7]_i_6_n_4 ),
        .O(abs_diff[7]));
  LUT4 #(
    .INIT(16'hA808)) 
    \seg_wl[4]_i_3 
       (.I0(have_prev),
        .I1(abs_diff1[6]),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(\ring_wl_reg[3][7]_i_6_n_5 ),
        .O(abs_diff[6]));
  LUT4 #(
    .INIT(16'hA808)) 
    \seg_wl[4]_i_4 
       (.I0(have_prev),
        .I1(abs_diff1[5]),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(\ring_wl_reg[3][7]_i_6_n_6 ),
        .O(abs_diff[5]));
  LUT4 #(
    .INIT(16'hA808)) 
    \seg_wl[4]_i_5 
       (.I0(have_prev),
        .I1(abs_diff1[4]),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(\ring_wl_reg[3][7]_i_6_n_7 ),
        .O(abs_diff[4]));
  LUT5 #(
    .INIT(32'h47FFB800)) 
    \seg_wl[4]_i_6 
       (.I0(\ring_wl_reg[3][7]_i_6_n_4 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[7]),
        .I3(have_prev),
        .I4(seg_wl_reg[7]),
        .O(\seg_wl[4]_i_6_n_0 ));
  LUT5 #(
    .INIT(32'h47FFB800)) 
    \seg_wl[4]_i_7 
       (.I0(\ring_wl_reg[3][7]_i_6_n_5 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[6]),
        .I3(have_prev),
        .I4(seg_wl_reg[6]),
        .O(\seg_wl[4]_i_7_n_0 ));
  LUT5 #(
    .INIT(32'h47FFB800)) 
    \seg_wl[4]_i_8 
       (.I0(\ring_wl_reg[3][7]_i_6_n_6 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[5]),
        .I3(have_prev),
        .I4(seg_wl_reg[5]),
        .O(\seg_wl[4]_i_8_n_0 ));
  LUT5 #(
    .INIT(32'h47FFB800)) 
    \seg_wl[4]_i_9 
       (.I0(\ring_wl_reg[3][7]_i_6_n_7 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[4]),
        .I3(have_prev),
        .I4(seg_wl_reg[4]),
        .O(\seg_wl[4]_i_9_n_0 ));
  LUT4 #(
    .INIT(16'hA808)) 
    \seg_wl[8]_i_2 
       (.I0(have_prev),
        .I1(abs_diff1[11]),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(\ring_wl_reg[3][11]_i_6_n_4 ),
        .O(abs_diff[11]));
  LUT4 #(
    .INIT(16'hA808)) 
    \seg_wl[8]_i_3 
       (.I0(have_prev),
        .I1(abs_diff1[10]),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(\ring_wl_reg[3][11]_i_6_n_5 ),
        .O(abs_diff[10]));
  LUT4 #(
    .INIT(16'hA808)) 
    \seg_wl[8]_i_4 
       (.I0(have_prev),
        .I1(abs_diff1[9]),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(\ring_wl_reg[3][11]_i_6_n_6 ),
        .O(abs_diff[9]));
  LUT4 #(
    .INIT(16'hA808)) 
    \seg_wl[8]_i_5 
       (.I0(have_prev),
        .I1(abs_diff1[8]),
        .I2(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I3(\ring_wl_reg[3][11]_i_6_n_7 ),
        .O(abs_diff[8]));
  LUT5 #(
    .INIT(32'h47FFB800)) 
    \seg_wl[8]_i_6 
       (.I0(\ring_wl_reg[3][11]_i_6_n_4 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[11]),
        .I3(have_prev),
        .I4(seg_wl_reg[11]),
        .O(\seg_wl[8]_i_6_n_0 ));
  LUT5 #(
    .INIT(32'h47FFB800)) 
    \seg_wl[8]_i_7 
       (.I0(\ring_wl_reg[3][11]_i_6_n_5 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[10]),
        .I3(have_prev),
        .I4(seg_wl_reg[10]),
        .O(\seg_wl[8]_i_7_n_0 ));
  LUT5 #(
    .INIT(32'h47FFB800)) 
    \seg_wl[8]_i_8 
       (.I0(\ring_wl_reg[3][11]_i_6_n_6 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[9]),
        .I3(have_prev),
        .I4(seg_wl_reg[9]),
        .O(\seg_wl[8]_i_8_n_0 ));
  LUT5 #(
    .INIT(32'h47FFB800)) 
    \seg_wl[8]_i_9 
       (.I0(\ring_wl_reg[3][11]_i_6_n_7 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[8]),
        .I3(have_prev),
        .I4(seg_wl_reg[8]),
        .O(\seg_wl[8]_i_9_n_0 ));
  FDRE \seg_wl_reg[0] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_wl_reg[0]_i_1_n_7 ),
        .Q(seg_wl_reg[0]),
        .R(seg_ssc));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \seg_wl_reg[0]_i_1 
       (.CI(1'b0),
        .CO({\seg_wl_reg[0]_i_1_n_0 ,\seg_wl_reg[0]_i_1_n_1 ,\seg_wl_reg[0]_i_1_n_2 ,\seg_wl_reg[0]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({abs_diff[3:1],\seg_wl[0]_i_5_n_0 }),
        .O({\seg_wl_reg[0]_i_1_n_4 ,\seg_wl_reg[0]_i_1_n_5 ,\seg_wl_reg[0]_i_1_n_6 ,\seg_wl_reg[0]_i_1_n_7 }),
        .S({\seg_wl[0]_i_6_n_0 ,\seg_wl[0]_i_7_n_0 ,\seg_wl[0]_i_8_n_0 ,\seg_wl[0]_i_9_n_0 }));
  FDRE \seg_wl_reg[10] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_wl_reg[8]_i_1_n_5 ),
        .Q(seg_wl_reg[10]),
        .R(seg_ssc));
  FDRE \seg_wl_reg[11] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_wl_reg[8]_i_1_n_4 ),
        .Q(seg_wl_reg[11]),
        .R(seg_ssc));
  FDRE \seg_wl_reg[12] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_wl_reg[12]_i_1_n_7 ),
        .Q(seg_wl_reg[12]),
        .R(seg_ssc));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \seg_wl_reg[12]_i_1 
       (.CI(\seg_wl_reg[8]_i_1_n_0 ),
        .CO({\seg_wl_reg[12]_i_1_n_0 ,\seg_wl_reg[12]_i_1_n_1 ,\seg_wl_reg[12]_i_1_n_2 ,\seg_wl_reg[12]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(abs_diff[15:12]),
        .O({\seg_wl_reg[12]_i_1_n_4 ,\seg_wl_reg[12]_i_1_n_5 ,\seg_wl_reg[12]_i_1_n_6 ,\seg_wl_reg[12]_i_1_n_7 }),
        .S({\seg_wl[12]_i_6_n_0 ,\seg_wl[12]_i_7_n_0 ,\seg_wl[12]_i_8_n_0 ,\seg_wl[12]_i_9_n_0 }));
  FDRE \seg_wl_reg[13] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_wl_reg[12]_i_1_n_6 ),
        .Q(seg_wl_reg[13]),
        .R(seg_ssc));
  FDRE \seg_wl_reg[14] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_wl_reg[12]_i_1_n_5 ),
        .Q(seg_wl_reg[14]),
        .R(seg_ssc));
  FDRE \seg_wl_reg[15] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_wl_reg[12]_i_1_n_4 ),
        .Q(seg_wl_reg[15]),
        .R(seg_ssc));
  FDRE \seg_wl_reg[16] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_wl_reg[16]_i_1_n_7 ),
        .Q(seg_wl_reg[16]),
        .R(seg_ssc));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \seg_wl_reg[16]_i_1 
       (.CI(\seg_wl_reg[12]_i_1_n_0 ),
        .CO({\seg_wl_reg[16]_i_1_n_0 ,\seg_wl_reg[16]_i_1_n_1 ,\seg_wl_reg[16]_i_1_n_2 ,\seg_wl_reg[16]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(abs_diff[19:16]),
        .O({\seg_wl_reg[16]_i_1_n_4 ,\seg_wl_reg[16]_i_1_n_5 ,\seg_wl_reg[16]_i_1_n_6 ,\seg_wl_reg[16]_i_1_n_7 }),
        .S({\seg_wl[16]_i_6_n_0 ,\seg_wl[16]_i_7_n_0 ,\seg_wl[16]_i_8_n_0 ,\seg_wl[16]_i_9_n_0 }));
  FDRE \seg_wl_reg[17] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_wl_reg[16]_i_1_n_6 ),
        .Q(seg_wl_reg[17]),
        .R(seg_ssc));
  FDRE \seg_wl_reg[18] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_wl_reg[16]_i_1_n_5 ),
        .Q(seg_wl_reg[18]),
        .R(seg_ssc));
  FDRE \seg_wl_reg[19] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_wl_reg[16]_i_1_n_4 ),
        .Q(seg_wl_reg[19]),
        .R(seg_ssc));
  FDRE \seg_wl_reg[1] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_wl_reg[0]_i_1_n_6 ),
        .Q(seg_wl_reg[1]),
        .R(seg_ssc));
  FDRE \seg_wl_reg[20] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_wl_reg[20]_i_1_n_7 ),
        .Q(seg_wl_reg[20]),
        .R(seg_ssc));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \seg_wl_reg[20]_i_1 
       (.CI(\seg_wl_reg[16]_i_1_n_0 ),
        .CO({\seg_wl_reg[20]_i_1_n_0 ,\seg_wl_reg[20]_i_1_n_1 ,\seg_wl_reg[20]_i_1_n_2 ,\seg_wl_reg[20]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(abs_diff[23:20]),
        .O({\seg_wl_reg[20]_i_1_n_4 ,\seg_wl_reg[20]_i_1_n_5 ,\seg_wl_reg[20]_i_1_n_6 ,\seg_wl_reg[20]_i_1_n_7 }),
        .S({\seg_wl[20]_i_6_n_0 ,\seg_wl[20]_i_7_n_0 ,\seg_wl[20]_i_8_n_0 ,\seg_wl[20]_i_9_n_0 }));
  FDRE \seg_wl_reg[21] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_wl_reg[20]_i_1_n_6 ),
        .Q(seg_wl_reg[21]),
        .R(seg_ssc));
  FDRE \seg_wl_reg[22] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_wl_reg[20]_i_1_n_5 ),
        .Q(seg_wl_reg[22]),
        .R(seg_ssc));
  FDRE \seg_wl_reg[23] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_wl_reg[20]_i_1_n_4 ),
        .Q(seg_wl_reg[23]),
        .R(seg_ssc));
  FDRE \seg_wl_reg[24] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_wl_reg[24]_i_1_n_7 ),
        .Q(seg_wl_reg[24]),
        .R(seg_ssc));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \seg_wl_reg[24]_i_1 
       (.CI(\seg_wl_reg[20]_i_1_n_0 ),
        .CO({\seg_wl_reg[24]_i_1_n_0 ,\seg_wl_reg[24]_i_1_n_1 ,\seg_wl_reg[24]_i_1_n_2 ,\seg_wl_reg[24]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,\seg_wl[24]_i_2_n_0 }),
        .O({\seg_wl_reg[24]_i_1_n_4 ,\seg_wl_reg[24]_i_1_n_5 ,\seg_wl_reg[24]_i_1_n_6 ,\seg_wl_reg[24]_i_1_n_7 }),
        .S({seg_wl_reg[27:25],\seg_wl[24]_i_3_n_0 }));
  FDRE \seg_wl_reg[25] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_wl_reg[24]_i_1_n_6 ),
        .Q(seg_wl_reg[25]),
        .R(seg_ssc));
  FDRE \seg_wl_reg[26] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_wl_reg[24]_i_1_n_5 ),
        .Q(seg_wl_reg[26]),
        .R(seg_ssc));
  FDRE \seg_wl_reg[27] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_wl_reg[24]_i_1_n_4 ),
        .Q(seg_wl_reg[27]),
        .R(seg_ssc));
  FDRE \seg_wl_reg[28] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_wl_reg[28]_i_1_n_7 ),
        .Q(seg_wl_reg[28]),
        .R(seg_ssc));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \seg_wl_reg[28]_i_1 
       (.CI(\seg_wl_reg[24]_i_1_n_0 ),
        .CO({\NLW_seg_wl_reg[28]_i_1_CO_UNCONNECTED [3],\seg_wl_reg[28]_i_1_n_1 ,\seg_wl_reg[28]_i_1_n_2 ,\seg_wl_reg[28]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\seg_wl_reg[28]_i_1_n_4 ,\seg_wl_reg[28]_i_1_n_5 ,\seg_wl_reg[28]_i_1_n_6 ,\seg_wl_reg[28]_i_1_n_7 }),
        .S(seg_wl_reg[31:28]));
  FDRE \seg_wl_reg[29] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_wl_reg[28]_i_1_n_6 ),
        .Q(seg_wl_reg[29]),
        .R(seg_ssc));
  FDRE \seg_wl_reg[2] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_wl_reg[0]_i_1_n_5 ),
        .Q(seg_wl_reg[2]),
        .R(seg_ssc));
  FDRE \seg_wl_reg[30] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_wl_reg[28]_i_1_n_5 ),
        .Q(seg_wl_reg[30]),
        .R(seg_ssc));
  FDRE \seg_wl_reg[31] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_wl_reg[28]_i_1_n_4 ),
        .Q(seg_wl_reg[31]),
        .R(seg_ssc));
  FDRE \seg_wl_reg[3] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_wl_reg[0]_i_1_n_4 ),
        .Q(seg_wl_reg[3]),
        .R(seg_ssc));
  FDRE \seg_wl_reg[4] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_wl_reg[4]_i_1_n_7 ),
        .Q(seg_wl_reg[4]),
        .R(seg_ssc));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \seg_wl_reg[4]_i_1 
       (.CI(\seg_wl_reg[0]_i_1_n_0 ),
        .CO({\seg_wl_reg[4]_i_1_n_0 ,\seg_wl_reg[4]_i_1_n_1 ,\seg_wl_reg[4]_i_1_n_2 ,\seg_wl_reg[4]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(abs_diff[7:4]),
        .O({\seg_wl_reg[4]_i_1_n_4 ,\seg_wl_reg[4]_i_1_n_5 ,\seg_wl_reg[4]_i_1_n_6 ,\seg_wl_reg[4]_i_1_n_7 }),
        .S({\seg_wl[4]_i_6_n_0 ,\seg_wl[4]_i_7_n_0 ,\seg_wl[4]_i_8_n_0 ,\seg_wl[4]_i_9_n_0 }));
  FDRE \seg_wl_reg[5] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_wl_reg[4]_i_1_n_6 ),
        .Q(seg_wl_reg[5]),
        .R(seg_ssc));
  FDRE \seg_wl_reg[6] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_wl_reg[4]_i_1_n_5 ),
        .Q(seg_wl_reg[6]),
        .R(seg_ssc));
  FDRE \seg_wl_reg[7] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_wl_reg[4]_i_1_n_4 ),
        .Q(seg_wl_reg[7]),
        .R(seg_ssc));
  FDRE \seg_wl_reg[8] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_wl_reg[8]_i_1_n_7 ),
        .Q(seg_wl_reg[8]),
        .R(seg_ssc));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \seg_wl_reg[8]_i_1 
       (.CI(\seg_wl_reg[4]_i_1_n_0 ),
        .CO({\seg_wl_reg[8]_i_1_n_0 ,\seg_wl_reg[8]_i_1_n_1 ,\seg_wl_reg[8]_i_1_n_2 ,\seg_wl_reg[8]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(abs_diff[11:8]),
        .O({\seg_wl_reg[8]_i_1_n_4 ,\seg_wl_reg[8]_i_1_n_5 ,\seg_wl_reg[8]_i_1_n_6 ,\seg_wl_reg[8]_i_1_n_7 }),
        .S({\seg_wl[8]_i_6_n_0 ,\seg_wl[8]_i_7_n_0 ,\seg_wl[8]_i_8_n_0 ,\seg_wl[8]_i_9_n_0 }));
  FDRE \seg_wl_reg[9] 
       (.C(clk),
        .CE(sample_valid),
        .D(\seg_wl_reg[8]_i_1_n_6 ),
        .Q(seg_wl_reg[9]),
        .R(seg_ssc));
  FDRE \seg_zc_reg[0] 
       (.C(clk),
        .CE(sample_valid),
        .D(\ring_zc[3][0]_i_1_n_0 ),
        .Q(seg_zc_reg[0]),
        .R(seg_ssc));
  FDRE \seg_zc_reg[1] 
       (.C(clk),
        .CE(sample_valid),
        .D(\ring_zc[3][1]_i_1_n_0 ),
        .Q(seg_zc_reg[1]),
        .R(seg_ssc));
  FDRE \seg_zc_reg[2] 
       (.C(clk),
        .CE(sample_valid),
        .D(\ring_zc[3][2]_i_1_n_0 ),
        .Q(seg_zc_reg[2]),
        .R(seg_ssc));
  FDRE \seg_zc_reg[3] 
       (.C(clk),
        .CE(sample_valid),
        .D(\ring_zc[3][3]_i_1_n_0 ),
        .Q(seg_zc_reg[3]),
        .R(seg_ssc));
  FDRE \seg_zc_reg[4] 
       (.C(clk),
        .CE(sample_valid),
        .D(\ring_zc[3][4]_i_1_n_0 ),
        .Q(seg_zc_reg[4]),
        .R(seg_ssc));
  FDRE \seg_zc_reg[5] 
       (.C(clk),
        .CE(sample_valid),
        .D(\ring_zc[3][5]_i_1_n_0 ),
        .Q(seg_zc_reg[5]),
        .R(seg_ssc));
  FDRE \seg_zc_reg[6] 
       (.C(clk),
        .CE(sample_valid),
        .D(\ring_zc[3][6]_i_1_n_0 ),
        .Q(seg_zc_reg[6]),
        .R(seg_ssc));
  (* SOFT_HLUTNM = "soft_lutpair48" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \ssc_count[0]_i_1 
       (.I0(\win_ssc_reg[3]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_ssc[0]),
        .O(\ssc_count[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair48" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \ssc_count[1]_i_1 
       (.I0(\win_ssc_reg[3]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_ssc[1]),
        .O(\ssc_count[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair49" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \ssc_count[2]_i_1 
       (.I0(\win_ssc_reg[3]_i_1_n_5 ),
        .I1(window_valid13_in),
        .I2(next_ssc[2]),
        .O(\ssc_count[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair49" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \ssc_count[3]_i_1 
       (.I0(\win_ssc_reg[3]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_ssc[3]),
        .O(\ssc_count[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair50" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \ssc_count[4]_i_1 
       (.I0(\win_ssc_reg[7]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_ssc[4]),
        .O(\ssc_count[4]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair50" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \ssc_count[5]_i_1 
       (.I0(\win_ssc_reg[7]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_ssc[5]),
        .O(\ssc_count[5]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair51" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \ssc_count[6]_i_1 
       (.I0(\win_ssc_reg[7]_i_1_n_5 ),
        .I1(window_valid13_in),
        .I2(next_ssc[6]),
        .O(\ssc_count[6]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair51" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \ssc_count[7]_i_1 
       (.I0(\win_ssc_reg[7]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_ssc[7]),
        .O(\ssc_count[7]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair52" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \ssc_count[8]_i_1 
       (.I0(\win_ssc_reg[8]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_ssc[8]),
        .O(\ssc_count[8]_i_1_n_0 ));
  FDRE \ssc_count_reg[0] 
       (.C(clk),
        .CE(\zc_count[8]_i_2_n_0 ),
        .D(\ssc_count[0]_i_1_n_0 ),
        .Q(\^ssc_count [0]),
        .R(clear));
  FDRE \ssc_count_reg[1] 
       (.C(clk),
        .CE(\zc_count[8]_i_2_n_0 ),
        .D(\ssc_count[1]_i_1_n_0 ),
        .Q(\^ssc_count [1]),
        .R(clear));
  FDRE \ssc_count_reg[2] 
       (.C(clk),
        .CE(\zc_count[8]_i_2_n_0 ),
        .D(\ssc_count[2]_i_1_n_0 ),
        .Q(\^ssc_count [2]),
        .R(clear));
  FDRE \ssc_count_reg[3] 
       (.C(clk),
        .CE(\zc_count[8]_i_2_n_0 ),
        .D(\ssc_count[3]_i_1_n_0 ),
        .Q(\^ssc_count [3]),
        .R(clear));
  FDRE \ssc_count_reg[4] 
       (.C(clk),
        .CE(\zc_count[8]_i_2_n_0 ),
        .D(\ssc_count[4]_i_1_n_0 ),
        .Q(\^ssc_count [4]),
        .R(clear));
  FDRE \ssc_count_reg[5] 
       (.C(clk),
        .CE(\zc_count[8]_i_2_n_0 ),
        .D(\ssc_count[5]_i_1_n_0 ),
        .Q(\^ssc_count [5]),
        .R(clear));
  FDRE \ssc_count_reg[6] 
       (.C(clk),
        .CE(\zc_count[8]_i_2_n_0 ),
        .D(\ssc_count[6]_i_1_n_0 ),
        .Q(\^ssc_count [6]),
        .R(clear));
  FDRE \ssc_count_reg[7] 
       (.C(clk),
        .CE(\zc_count[8]_i_2_n_0 ),
        .D(\ssc_count[7]_i_1_n_0 ),
        .Q(\^ssc_count [7]),
        .R(clear));
  FDRE \ssc_count_reg[8] 
       (.C(clk),
        .CE(\zc_count[8]_i_2_n_0 ),
        .D(\ssc_count[8]_i_1_n_0 ),
        .Q(\^ssc_count [8]),
        .R(clear));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_energy[11]_i_10 
       (.I0(\ring_energy_reg[2] [9]),
        .I1(\ring_energy_reg[3] [9]),
        .I2(\ring_energy_reg[0] [9]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_energy_reg[1] [9]),
        .O(ring_energy[9]));
  LUT3 #(
    .INIT(8'h69)) 
    \win_energy[11]_i_11 
       (.I0(seg_energy1__1[10]),
        .I1(ring_energy[10]),
        .I2(seg_energy_reg[10]),
        .O(\win_energy[11]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_energy[11]_i_12 
       (.I0(\ring_energy_reg[2] [8]),
        .I1(\ring_energy_reg[3] [8]),
        .I2(\ring_energy_reg[0] [8]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_energy_reg[1] [8]),
        .O(ring_energy[8]));
  LUT3 #(
    .INIT(8'h69)) 
    \win_energy[11]_i_13 
       (.I0(seg_energy1__1[9]),
        .I1(ring_energy[9]),
        .I2(seg_energy_reg[9]),
        .O(\win_energy[11]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_energy[11]_i_14 
       (.I0(\ring_energy_reg[2] [7]),
        .I1(\ring_energy_reg[3] [7]),
        .I2(\ring_energy_reg[0] [7]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_energy_reg[1] [7]),
        .O(ring_energy[7]));
  LUT3 #(
    .INIT(8'h69)) 
    \win_energy[11]_i_15 
       (.I0(seg_energy1__1[8]),
        .I1(ring_energy[8]),
        .I2(seg_energy_reg[8]),
        .O(\win_energy[11]_i_15_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_energy[11]_i_16 
       (.I0(\ring_energy_reg[2] [6]),
        .I1(\ring_energy_reg[3] [6]),
        .I2(\ring_energy_reg[0] [6]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_energy_reg[1] [6]),
        .O(ring_energy[6]));
  LUT3 #(
    .INIT(8'h69)) 
    \win_energy[11]_i_17 
       (.I0(seg_energy1__1[7]),
        .I1(ring_energy[7]),
        .I2(seg_energy_reg[7]),
        .O(\win_energy[11]_i_17_n_0 ));
  LUT5 #(
    .INIT(32'hFF8E8E00)) 
    \win_energy[11]_i_2 
       (.I0(seg_energy_reg[9]),
        .I1(seg_energy1__1[9]),
        .I2(ring_energy[9]),
        .I3(win_energy[10]),
        .I4(\win_energy[11]_i_11_n_0 ),
        .O(\win_energy[11]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hFF8E8E00)) 
    \win_energy[11]_i_3 
       (.I0(seg_energy_reg[8]),
        .I1(seg_energy1__1[8]),
        .I2(ring_energy[8]),
        .I3(win_energy[9]),
        .I4(\win_energy[11]_i_13_n_0 ),
        .O(\win_energy[11]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'hFF8E8E00)) 
    \win_energy[11]_i_4 
       (.I0(seg_energy_reg[7]),
        .I1(seg_energy1__1[7]),
        .I2(ring_energy[7]),
        .I3(win_energy[8]),
        .I4(\win_energy[11]_i_15_n_0 ),
        .O(\win_energy[11]_i_4_n_0 ));
  LUT5 #(
    .INIT(32'hFF8E8E00)) 
    \win_energy[11]_i_5 
       (.I0(seg_energy_reg[6]),
        .I1(seg_energy1__1[6]),
        .I2(ring_energy[6]),
        .I3(win_energy[7]),
        .I4(\win_energy[11]_i_17_n_0 ),
        .O(\win_energy[11]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h6969966996699696)) 
    \win_energy[11]_i_6 
       (.I0(\win_energy[11]_i_2_n_0 ),
        .I1(\win_energy[15]_i_17_n_0 ),
        .I2(win_energy[11]),
        .I3(ring_energy[10]),
        .I4(seg_energy1__1[10]),
        .I5(seg_energy_reg[10]),
        .O(\win_energy[11]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h6969966996699696)) 
    \win_energy[11]_i_7 
       (.I0(\win_energy[11]_i_3_n_0 ),
        .I1(\win_energy[11]_i_11_n_0 ),
        .I2(win_energy[10]),
        .I3(ring_energy[9]),
        .I4(seg_energy1__1[9]),
        .I5(seg_energy_reg[9]),
        .O(\win_energy[11]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h6969966996699696)) 
    \win_energy[11]_i_8 
       (.I0(\win_energy[11]_i_4_n_0 ),
        .I1(\win_energy[11]_i_13_n_0 ),
        .I2(win_energy[9]),
        .I3(ring_energy[8]),
        .I4(seg_energy1__1[8]),
        .I5(seg_energy_reg[8]),
        .O(\win_energy[11]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'h6969966996699696)) 
    \win_energy[11]_i_9 
       (.I0(\win_energy[11]_i_5_n_0 ),
        .I1(\win_energy[11]_i_15_n_0 ),
        .I2(win_energy[8]),
        .I3(ring_energy[7]),
        .I4(seg_energy1__1[7]),
        .I5(seg_energy_reg[7]),
        .O(\win_energy[11]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_energy[15]_i_10 
       (.I0(\ring_energy_reg[2] [13]),
        .I1(\ring_energy_reg[3] [13]),
        .I2(\ring_energy_reg[0] [13]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_energy_reg[1] [13]),
        .O(ring_energy[13]));
  LUT3 #(
    .INIT(8'h69)) 
    \win_energy[15]_i_11 
       (.I0(seg_energy1__1[14]),
        .I1(ring_energy[14]),
        .I2(seg_energy_reg[14]),
        .O(\win_energy[15]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_energy[15]_i_12 
       (.I0(\ring_energy_reg[2] [12]),
        .I1(\ring_energy_reg[3] [12]),
        .I2(\ring_energy_reg[0] [12]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_energy_reg[1] [12]),
        .O(ring_energy[12]));
  LUT3 #(
    .INIT(8'h69)) 
    \win_energy[15]_i_13 
       (.I0(seg_energy1__1[13]),
        .I1(ring_energy[13]),
        .I2(seg_energy_reg[13]),
        .O(\win_energy[15]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_energy[15]_i_14 
       (.I0(\ring_energy_reg[2] [11]),
        .I1(\ring_energy_reg[3] [11]),
        .I2(\ring_energy_reg[0] [11]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_energy_reg[1] [11]),
        .O(ring_energy[11]));
  LUT3 #(
    .INIT(8'h69)) 
    \win_energy[15]_i_15 
       (.I0(seg_energy1__1[12]),
        .I1(ring_energy[12]),
        .I2(seg_energy_reg[12]),
        .O(\win_energy[15]_i_15_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_energy[15]_i_16 
       (.I0(\ring_energy_reg[2] [10]),
        .I1(\ring_energy_reg[3] [10]),
        .I2(\ring_energy_reg[0] [10]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_energy_reg[1] [10]),
        .O(ring_energy[10]));
  LUT3 #(
    .INIT(8'h69)) 
    \win_energy[15]_i_17 
       (.I0(seg_energy1__1[11]),
        .I1(ring_energy[11]),
        .I2(seg_energy_reg[11]),
        .O(\win_energy[15]_i_17_n_0 ));
  LUT5 #(
    .INIT(32'hFF8E8E00)) 
    \win_energy[15]_i_2 
       (.I0(seg_energy_reg[13]),
        .I1(seg_energy1__1[13]),
        .I2(ring_energy[13]),
        .I3(win_energy[14]),
        .I4(\win_energy[15]_i_11_n_0 ),
        .O(\win_energy[15]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hFF8E8E00)) 
    \win_energy[15]_i_3 
       (.I0(seg_energy_reg[12]),
        .I1(seg_energy1__1[12]),
        .I2(ring_energy[12]),
        .I3(win_energy[13]),
        .I4(\win_energy[15]_i_13_n_0 ),
        .O(\win_energy[15]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'hFF8E8E00)) 
    \win_energy[15]_i_4 
       (.I0(seg_energy_reg[11]),
        .I1(seg_energy1__1[11]),
        .I2(ring_energy[11]),
        .I3(win_energy[12]),
        .I4(\win_energy[15]_i_15_n_0 ),
        .O(\win_energy[15]_i_4_n_0 ));
  LUT5 #(
    .INIT(32'hFF8E8E00)) 
    \win_energy[15]_i_5 
       (.I0(seg_energy_reg[10]),
        .I1(seg_energy1__1[10]),
        .I2(ring_energy[10]),
        .I3(win_energy[11]),
        .I4(\win_energy[15]_i_17_n_0 ),
        .O(\win_energy[15]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h6969966996699696)) 
    \win_energy[15]_i_6 
       (.I0(\win_energy[15]_i_2_n_0 ),
        .I1(\win_energy[19]_i_17_n_0 ),
        .I2(win_energy[15]),
        .I3(ring_energy[14]),
        .I4(seg_energy1__1[14]),
        .I5(seg_energy_reg[14]),
        .O(\win_energy[15]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h6969966996699696)) 
    \win_energy[15]_i_7 
       (.I0(\win_energy[15]_i_3_n_0 ),
        .I1(\win_energy[15]_i_11_n_0 ),
        .I2(win_energy[14]),
        .I3(ring_energy[13]),
        .I4(seg_energy1__1[13]),
        .I5(seg_energy_reg[13]),
        .O(\win_energy[15]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h6969966996699696)) 
    \win_energy[15]_i_8 
       (.I0(\win_energy[15]_i_4_n_0 ),
        .I1(\win_energy[15]_i_13_n_0 ),
        .I2(win_energy[13]),
        .I3(ring_energy[12]),
        .I4(seg_energy1__1[12]),
        .I5(seg_energy_reg[12]),
        .O(\win_energy[15]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'h6969966996699696)) 
    \win_energy[15]_i_9 
       (.I0(\win_energy[15]_i_5_n_0 ),
        .I1(\win_energy[15]_i_15_n_0 ),
        .I2(win_energy[12]),
        .I3(ring_energy[11]),
        .I4(seg_energy1__1[11]),
        .I5(seg_energy_reg[11]),
        .O(\win_energy[15]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_energy[19]_i_10 
       (.I0(\ring_energy_reg[2] [17]),
        .I1(\ring_energy_reg[3] [17]),
        .I2(\ring_energy_reg[0] [17]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_energy_reg[1] [17]),
        .O(ring_energy[17]));
  LUT3 #(
    .INIT(8'h69)) 
    \win_energy[19]_i_11 
       (.I0(seg_energy1__1[18]),
        .I1(ring_energy[18]),
        .I2(seg_energy_reg[18]),
        .O(\win_energy[19]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_energy[19]_i_12 
       (.I0(\ring_energy_reg[2] [16]),
        .I1(\ring_energy_reg[3] [16]),
        .I2(\ring_energy_reg[0] [16]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_energy_reg[1] [16]),
        .O(ring_energy[16]));
  LUT3 #(
    .INIT(8'h69)) 
    \win_energy[19]_i_13 
       (.I0(seg_energy1__1[17]),
        .I1(ring_energy[17]),
        .I2(seg_energy_reg[17]),
        .O(\win_energy[19]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_energy[19]_i_14 
       (.I0(\ring_energy_reg[2] [15]),
        .I1(\ring_energy_reg[3] [15]),
        .I2(\ring_energy_reg[0] [15]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_energy_reg[1] [15]),
        .O(ring_energy[15]));
  LUT3 #(
    .INIT(8'h69)) 
    \win_energy[19]_i_15 
       (.I0(seg_energy1__1[16]),
        .I1(ring_energy[16]),
        .I2(seg_energy_reg[16]),
        .O(\win_energy[19]_i_15_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_energy[19]_i_16 
       (.I0(\ring_energy_reg[2] [14]),
        .I1(\ring_energy_reg[3] [14]),
        .I2(\ring_energy_reg[0] [14]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_energy_reg[1] [14]),
        .O(ring_energy[14]));
  LUT3 #(
    .INIT(8'h69)) 
    \win_energy[19]_i_17 
       (.I0(seg_energy1__1[15]),
        .I1(ring_energy[15]),
        .I2(seg_energy_reg[15]),
        .O(\win_energy[19]_i_17_n_0 ));
  LUT5 #(
    .INIT(32'hFF8E8E00)) 
    \win_energy[19]_i_2 
       (.I0(seg_energy_reg[17]),
        .I1(seg_energy1__1[17]),
        .I2(ring_energy[17]),
        .I3(win_energy[18]),
        .I4(\win_energy[19]_i_11_n_0 ),
        .O(\win_energy[19]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hFF8E8E00)) 
    \win_energy[19]_i_3 
       (.I0(seg_energy_reg[16]),
        .I1(seg_energy1__1[16]),
        .I2(ring_energy[16]),
        .I3(win_energy[17]),
        .I4(\win_energy[19]_i_13_n_0 ),
        .O(\win_energy[19]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'hFF8E8E00)) 
    \win_energy[19]_i_4 
       (.I0(seg_energy_reg[15]),
        .I1(seg_energy1__1[15]),
        .I2(ring_energy[15]),
        .I3(win_energy[16]),
        .I4(\win_energy[19]_i_15_n_0 ),
        .O(\win_energy[19]_i_4_n_0 ));
  LUT5 #(
    .INIT(32'hFF8E8E00)) 
    \win_energy[19]_i_5 
       (.I0(seg_energy_reg[14]),
        .I1(seg_energy1__1[14]),
        .I2(ring_energy[14]),
        .I3(win_energy[15]),
        .I4(\win_energy[19]_i_17_n_0 ),
        .O(\win_energy[19]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h6969966996699696)) 
    \win_energy[19]_i_6 
       (.I0(\win_energy[19]_i_2_n_0 ),
        .I1(\win_energy[23]_i_17_n_0 ),
        .I2(win_energy[19]),
        .I3(ring_energy[18]),
        .I4(seg_energy1__1[18]),
        .I5(seg_energy_reg[18]),
        .O(\win_energy[19]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h6969966996699696)) 
    \win_energy[19]_i_7 
       (.I0(\win_energy[19]_i_3_n_0 ),
        .I1(\win_energy[19]_i_11_n_0 ),
        .I2(win_energy[18]),
        .I3(ring_energy[17]),
        .I4(seg_energy1__1[17]),
        .I5(seg_energy_reg[17]),
        .O(\win_energy[19]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h6969966996699696)) 
    \win_energy[19]_i_8 
       (.I0(\win_energy[19]_i_4_n_0 ),
        .I1(\win_energy[19]_i_13_n_0 ),
        .I2(win_energy[17]),
        .I3(ring_energy[16]),
        .I4(seg_energy1__1[16]),
        .I5(seg_energy_reg[16]),
        .O(\win_energy[19]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'h6969966996699696)) 
    \win_energy[19]_i_9 
       (.I0(\win_energy[19]_i_5_n_0 ),
        .I1(\win_energy[19]_i_15_n_0 ),
        .I2(win_energy[16]),
        .I3(ring_energy[15]),
        .I4(seg_energy1__1[15]),
        .I5(seg_energy_reg[15]),
        .O(\win_energy[19]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_energy[23]_i_10 
       (.I0(\ring_energy_reg[2] [21]),
        .I1(\ring_energy_reg[3] [21]),
        .I2(\ring_energy_reg[0] [21]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_energy_reg[1] [21]),
        .O(ring_energy[21]));
  LUT3 #(
    .INIT(8'h69)) 
    \win_energy[23]_i_11 
       (.I0(seg_energy1__1[22]),
        .I1(ring_energy[22]),
        .I2(seg_energy_reg[22]),
        .O(\win_energy[23]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_energy[23]_i_12 
       (.I0(\ring_energy_reg[2] [20]),
        .I1(\ring_energy_reg[3] [20]),
        .I2(\ring_energy_reg[0] [20]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_energy_reg[1] [20]),
        .O(ring_energy[20]));
  LUT3 #(
    .INIT(8'h69)) 
    \win_energy[23]_i_13 
       (.I0(seg_energy1__1[21]),
        .I1(ring_energy[21]),
        .I2(seg_energy_reg[21]),
        .O(\win_energy[23]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_energy[23]_i_14 
       (.I0(\ring_energy_reg[2] [19]),
        .I1(\ring_energy_reg[3] [19]),
        .I2(\ring_energy_reg[0] [19]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_energy_reg[1] [19]),
        .O(ring_energy[19]));
  LUT3 #(
    .INIT(8'h69)) 
    \win_energy[23]_i_15 
       (.I0(seg_energy1__1[20]),
        .I1(ring_energy[20]),
        .I2(seg_energy_reg[20]),
        .O(\win_energy[23]_i_15_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_energy[23]_i_16 
       (.I0(\ring_energy_reg[2] [18]),
        .I1(\ring_energy_reg[3] [18]),
        .I2(\ring_energy_reg[0] [18]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_energy_reg[1] [18]),
        .O(ring_energy[18]));
  LUT3 #(
    .INIT(8'h69)) 
    \win_energy[23]_i_17 
       (.I0(seg_energy1__1[19]),
        .I1(ring_energy[19]),
        .I2(seg_energy_reg[19]),
        .O(\win_energy[23]_i_17_n_0 ));
  LUT5 #(
    .INIT(32'hFF8E8E00)) 
    \win_energy[23]_i_2 
       (.I0(seg_energy_reg[21]),
        .I1(seg_energy1__1[21]),
        .I2(ring_energy[21]),
        .I3(win_energy[22]),
        .I4(\win_energy[23]_i_11_n_0 ),
        .O(\win_energy[23]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hFF8E8E00)) 
    \win_energy[23]_i_3 
       (.I0(seg_energy_reg[20]),
        .I1(seg_energy1__1[20]),
        .I2(ring_energy[20]),
        .I3(win_energy[21]),
        .I4(\win_energy[23]_i_13_n_0 ),
        .O(\win_energy[23]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'hFF8E8E00)) 
    \win_energy[23]_i_4 
       (.I0(seg_energy_reg[19]),
        .I1(seg_energy1__1[19]),
        .I2(ring_energy[19]),
        .I3(win_energy[20]),
        .I4(\win_energy[23]_i_15_n_0 ),
        .O(\win_energy[23]_i_4_n_0 ));
  LUT5 #(
    .INIT(32'hFF8E8E00)) 
    \win_energy[23]_i_5 
       (.I0(seg_energy_reg[18]),
        .I1(seg_energy1__1[18]),
        .I2(ring_energy[18]),
        .I3(win_energy[19]),
        .I4(\win_energy[23]_i_17_n_0 ),
        .O(\win_energy[23]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h6969966996699696)) 
    \win_energy[23]_i_6 
       (.I0(\win_energy[23]_i_2_n_0 ),
        .I1(\win_energy[27]_i_17_n_0 ),
        .I2(win_energy[23]),
        .I3(ring_energy[22]),
        .I4(seg_energy1__1[22]),
        .I5(seg_energy_reg[22]),
        .O(\win_energy[23]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h6969966996699696)) 
    \win_energy[23]_i_7 
       (.I0(\win_energy[23]_i_3_n_0 ),
        .I1(\win_energy[23]_i_11_n_0 ),
        .I2(win_energy[22]),
        .I3(ring_energy[21]),
        .I4(seg_energy1__1[21]),
        .I5(seg_energy_reg[21]),
        .O(\win_energy[23]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h6969966996699696)) 
    \win_energy[23]_i_8 
       (.I0(\win_energy[23]_i_4_n_0 ),
        .I1(\win_energy[23]_i_13_n_0 ),
        .I2(win_energy[21]),
        .I3(ring_energy[20]),
        .I4(seg_energy1__1[20]),
        .I5(seg_energy_reg[20]),
        .O(\win_energy[23]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'h6969966996699696)) 
    \win_energy[23]_i_9 
       (.I0(\win_energy[23]_i_5_n_0 ),
        .I1(\win_energy[23]_i_15_n_0 ),
        .I2(win_energy[20]),
        .I3(ring_energy[19]),
        .I4(seg_energy1__1[19]),
        .I5(seg_energy_reg[19]),
        .O(\win_energy[23]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_energy[27]_i_10 
       (.I0(\ring_energy_reg[2] [25]),
        .I1(\ring_energy_reg[3] [25]),
        .I2(\ring_energy_reg[0] [25]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_energy_reg[1] [25]),
        .O(ring_energy[25]));
  LUT3 #(
    .INIT(8'h69)) 
    \win_energy[27]_i_11 
       (.I0(seg_energy1__1[26]),
        .I1(ring_energy[26]),
        .I2(seg_energy_reg[26]),
        .O(\win_energy[27]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_energy[27]_i_12 
       (.I0(\ring_energy_reg[2] [24]),
        .I1(\ring_energy_reg[3] [24]),
        .I2(\ring_energy_reg[0] [24]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_energy_reg[1] [24]),
        .O(ring_energy[24]));
  LUT3 #(
    .INIT(8'h69)) 
    \win_energy[27]_i_13 
       (.I0(seg_energy1__1[25]),
        .I1(ring_energy[25]),
        .I2(seg_energy_reg[25]),
        .O(\win_energy[27]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_energy[27]_i_14 
       (.I0(\ring_energy_reg[2] [23]),
        .I1(\ring_energy_reg[3] [23]),
        .I2(\ring_energy_reg[0] [23]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_energy_reg[1] [23]),
        .O(ring_energy[23]));
  LUT3 #(
    .INIT(8'h69)) 
    \win_energy[27]_i_15 
       (.I0(seg_energy1__1[24]),
        .I1(ring_energy[24]),
        .I2(seg_energy_reg[24]),
        .O(\win_energy[27]_i_15_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_energy[27]_i_16 
       (.I0(\ring_energy_reg[2] [22]),
        .I1(\ring_energy_reg[3] [22]),
        .I2(\ring_energy_reg[0] [22]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_energy_reg[1] [22]),
        .O(ring_energy[22]));
  LUT3 #(
    .INIT(8'h69)) 
    \win_energy[27]_i_17 
       (.I0(seg_energy1__1[23]),
        .I1(ring_energy[23]),
        .I2(seg_energy_reg[23]),
        .O(\win_energy[27]_i_17_n_0 ));
  LUT5 #(
    .INIT(32'hFF8E8E00)) 
    \win_energy[27]_i_2 
       (.I0(seg_energy_reg[25]),
        .I1(seg_energy1__1[25]),
        .I2(ring_energy[25]),
        .I3(win_energy[26]),
        .I4(\win_energy[27]_i_11_n_0 ),
        .O(\win_energy[27]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hFF8E8E00)) 
    \win_energy[27]_i_3 
       (.I0(seg_energy_reg[24]),
        .I1(seg_energy1__1[24]),
        .I2(ring_energy[24]),
        .I3(win_energy[25]),
        .I4(\win_energy[27]_i_13_n_0 ),
        .O(\win_energy[27]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'hFF8E8E00)) 
    \win_energy[27]_i_4 
       (.I0(seg_energy_reg[23]),
        .I1(seg_energy1__1[23]),
        .I2(ring_energy[23]),
        .I3(win_energy[24]),
        .I4(\win_energy[27]_i_15_n_0 ),
        .O(\win_energy[27]_i_4_n_0 ));
  LUT5 #(
    .INIT(32'hFF8E8E00)) 
    \win_energy[27]_i_5 
       (.I0(seg_energy_reg[22]),
        .I1(seg_energy1__1[22]),
        .I2(ring_energy[22]),
        .I3(win_energy[23]),
        .I4(\win_energy[27]_i_17_n_0 ),
        .O(\win_energy[27]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h6969966996699696)) 
    \win_energy[27]_i_6 
       (.I0(\win_energy[27]_i_2_n_0 ),
        .I1(\win_energy[31]_i_17_n_0 ),
        .I2(win_energy[27]),
        .I3(ring_energy[26]),
        .I4(seg_energy1__1[26]),
        .I5(seg_energy_reg[26]),
        .O(\win_energy[27]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h6969966996699696)) 
    \win_energy[27]_i_7 
       (.I0(\win_energy[27]_i_3_n_0 ),
        .I1(\win_energy[27]_i_11_n_0 ),
        .I2(win_energy[26]),
        .I3(ring_energy[25]),
        .I4(seg_energy1__1[25]),
        .I5(seg_energy_reg[25]),
        .O(\win_energy[27]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h6969966996699696)) 
    \win_energy[27]_i_8 
       (.I0(\win_energy[27]_i_4_n_0 ),
        .I1(\win_energy[27]_i_13_n_0 ),
        .I2(win_energy[25]),
        .I3(ring_energy[24]),
        .I4(seg_energy1__1[24]),
        .I5(seg_energy_reg[24]),
        .O(\win_energy[27]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'h6969966996699696)) 
    \win_energy[27]_i_9 
       (.I0(\win_energy[27]_i_5_n_0 ),
        .I1(\win_energy[27]_i_15_n_0 ),
        .I2(win_energy[24]),
        .I3(ring_energy[23]),
        .I4(seg_energy1__1[23]),
        .I5(seg_energy_reg[23]),
        .O(\win_energy[27]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_energy[31]_i_10 
       (.I0(\ring_energy_reg[2] [29]),
        .I1(\ring_energy_reg[3] [29]),
        .I2(\ring_energy_reg[0] [29]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_energy_reg[1] [29]),
        .O(ring_energy[29]));
  (* SOFT_HLUTNM = "soft_lutpair120" *) 
  LUT3 #(
    .INIT(8'h69)) 
    \win_energy[31]_i_11 
       (.I0(seg_energy1__1[30]),
        .I1(ring_energy[30]),
        .I2(seg_energy_reg[30]),
        .O(\win_energy[31]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_energy[31]_i_12 
       (.I0(\ring_energy_reg[2] [28]),
        .I1(\ring_energy_reg[3] [28]),
        .I2(\ring_energy_reg[0] [28]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_energy_reg[1] [28]),
        .O(ring_energy[28]));
  LUT3 #(
    .INIT(8'h69)) 
    \win_energy[31]_i_13 
       (.I0(seg_energy1__1[29]),
        .I1(ring_energy[29]),
        .I2(seg_energy_reg[29]),
        .O(\win_energy[31]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_energy[31]_i_14 
       (.I0(\ring_energy_reg[2] [27]),
        .I1(\ring_energy_reg[3] [27]),
        .I2(\ring_energy_reg[0] [27]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_energy_reg[1] [27]),
        .O(ring_energy[27]));
  LUT3 #(
    .INIT(8'h69)) 
    \win_energy[31]_i_15 
       (.I0(seg_energy1__1[28]),
        .I1(ring_energy[28]),
        .I2(seg_energy_reg[28]),
        .O(\win_energy[31]_i_15_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_energy[31]_i_16 
       (.I0(\ring_energy_reg[2] [26]),
        .I1(\ring_energy_reg[3] [26]),
        .I2(\ring_energy_reg[0] [26]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_energy_reg[1] [26]),
        .O(ring_energy[26]));
  LUT3 #(
    .INIT(8'h69)) 
    \win_energy[31]_i_17 
       (.I0(seg_energy1__1[27]),
        .I1(ring_energy[27]),
        .I2(seg_energy_reg[27]),
        .O(\win_energy[31]_i_17_n_0 ));
  LUT5 #(
    .INIT(32'hFF8E8E00)) 
    \win_energy[31]_i_2 
       (.I0(seg_energy_reg[29]),
        .I1(seg_energy1__1[29]),
        .I2(ring_energy[29]),
        .I3(win_energy[30]),
        .I4(\win_energy[31]_i_11_n_0 ),
        .O(\win_energy[31]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hFF8E8E00)) 
    \win_energy[31]_i_3 
       (.I0(seg_energy_reg[28]),
        .I1(seg_energy1__1[28]),
        .I2(ring_energy[28]),
        .I3(win_energy[29]),
        .I4(\win_energy[31]_i_13_n_0 ),
        .O(\win_energy[31]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'hFF8E8E00)) 
    \win_energy[31]_i_4 
       (.I0(seg_energy_reg[27]),
        .I1(seg_energy1__1[27]),
        .I2(ring_energy[27]),
        .I3(win_energy[28]),
        .I4(\win_energy[31]_i_15_n_0 ),
        .O(\win_energy[31]_i_4_n_0 ));
  LUT5 #(
    .INIT(32'hFF8E8E00)) 
    \win_energy[31]_i_5 
       (.I0(seg_energy_reg[26]),
        .I1(seg_energy1__1[26]),
        .I2(ring_energy[26]),
        .I3(win_energy[27]),
        .I4(\win_energy[31]_i_17_n_0 ),
        .O(\win_energy[31]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h6969966996699696)) 
    \win_energy[31]_i_6 
       (.I0(\win_energy[31]_i_2_n_0 ),
        .I1(\win_energy[35]_i_10_n_0 ),
        .I2(win_energy[31]),
        .I3(ring_energy[30]),
        .I4(seg_energy1__1[30]),
        .I5(seg_energy_reg[30]),
        .O(\win_energy[31]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h6969966996699696)) 
    \win_energy[31]_i_7 
       (.I0(\win_energy[31]_i_3_n_0 ),
        .I1(\win_energy[31]_i_11_n_0 ),
        .I2(win_energy[30]),
        .I3(ring_energy[29]),
        .I4(seg_energy1__1[29]),
        .I5(seg_energy_reg[29]),
        .O(\win_energy[31]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h6969966996699696)) 
    \win_energy[31]_i_8 
       (.I0(\win_energy[31]_i_4_n_0 ),
        .I1(\win_energy[31]_i_13_n_0 ),
        .I2(win_energy[29]),
        .I3(ring_energy[28]),
        .I4(seg_energy1__1[28]),
        .I5(seg_energy_reg[28]),
        .O(\win_energy[31]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'h6969966996699696)) 
    \win_energy[31]_i_9 
       (.I0(\win_energy[31]_i_5_n_0 ),
        .I1(\win_energy[31]_i_15_n_0 ),
        .I2(win_energy[28]),
        .I3(ring_energy[27]),
        .I4(seg_energy1__1[27]),
        .I5(seg_energy_reg[27]),
        .O(\win_energy[31]_i_9_n_0 ));
  LUT3 #(
    .INIT(8'h69)) 
    \win_energy[35]_i_10 
       (.I0(seg_energy1__1[31]),
        .I1(ring_energy[31]),
        .I2(seg_energy_reg[31]),
        .O(\win_energy[35]_i_10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair120" *) 
  LUT3 #(
    .INIT(8'hD4)) 
    \win_energy[35]_i_11 
       (.I0(ring_energy[30]),
        .I1(seg_energy1__1[30]),
        .I2(seg_energy_reg[30]),
        .O(\win_energy[35]_i_11_n_0 ));
  LUT4 #(
    .INIT(16'hFF8E)) 
    \win_energy[35]_i_2 
       (.I0(seg_energy_reg[31]),
        .I1(seg_energy1__1[31]),
        .I2(ring_energy[31]),
        .I3(win_energy[32]),
        .O(\win_energy[35]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hFF8E8E00)) 
    \win_energy[35]_i_3 
       (.I0(seg_energy_reg[30]),
        .I1(seg_energy1__1[30]),
        .I2(ring_energy[30]),
        .I3(win_energy[31]),
        .I4(\win_energy[35]_i_10_n_0 ),
        .O(\win_energy[35]_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \win_energy[35]_i_4 
       (.I0(win_energy[34]),
        .I1(win_energy[35]),
        .O(\win_energy[35]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \win_energy[35]_i_5 
       (.I0(win_energy[33]),
        .I1(win_energy[34]),
        .O(\win_energy[35]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'hFBBA0445)) 
    \win_energy[35]_i_6 
       (.I0(win_energy[32]),
        .I1(ring_energy[31]),
        .I2(seg_energy1__1[31]),
        .I3(seg_energy_reg[31]),
        .I4(win_energy[33]),
        .O(\win_energy[35]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h781EE178E17887E1)) 
    \win_energy[35]_i_7 
       (.I0(win_energy[31]),
        .I1(\win_energy[35]_i_11_n_0 ),
        .I2(win_energy[32]),
        .I3(ring_energy[31]),
        .I4(seg_energy1__1[31]),
        .I5(seg_energy_reg[31]),
        .O(\win_energy[35]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_energy[35]_i_8 
       (.I0(\ring_energy_reg[2] [31]),
        .I1(\ring_energy_reg[3] [31]),
        .I2(\ring_energy_reg[0] [31]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_energy_reg[1] [31]),
        .O(ring_energy[31]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_energy[35]_i_9 
       (.I0(\ring_energy_reg[2] [30]),
        .I1(\ring_energy_reg[3] [30]),
        .I2(\ring_energy_reg[0] [30]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_energy_reg[1] [30]),
        .O(ring_energy[30]));
  LUT2 #(
    .INIT(4'h9)) 
    \win_energy[39]_i_2 
       (.I0(win_energy[38]),
        .I1(win_energy[39]),
        .O(\win_energy[39]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \win_energy[39]_i_3 
       (.I0(win_energy[37]),
        .I1(win_energy[38]),
        .O(\win_energy[39]_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \win_energy[39]_i_4 
       (.I0(win_energy[36]),
        .I1(win_energy[37]),
        .O(\win_energy[39]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \win_energy[39]_i_5 
       (.I0(win_energy[35]),
        .I1(win_energy[36]),
        .O(\win_energy[39]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_energy[3]_i_10 
       (.I0(\ring_energy_reg[2] [1]),
        .I1(\ring_energy_reg[3] [1]),
        .I2(\ring_energy_reg[0] [1]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_energy_reg[1] [1]),
        .O(ring_energy[1]));
  LUT3 #(
    .INIT(8'h69)) 
    \win_energy[3]_i_11 
       (.I0(seg_energy1__1[2]),
        .I1(ring_energy[2]),
        .I2(seg_energy_reg[2]),
        .O(\win_energy[3]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_energy[3]_i_12 
       (.I0(\ring_energy_reg[2] [0]),
        .I1(\ring_energy_reg[3] [0]),
        .I2(\ring_energy_reg[0] [0]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_energy_reg[1] [0]),
        .O(ring_energy[0]));
  LUT3 #(
    .INIT(8'h69)) 
    \win_energy[3]_i_13 
       (.I0(seg_energy1__1[1]),
        .I1(ring_energy[1]),
        .I2(seg_energy_reg[1]),
        .O(\win_energy[3]_i_13_n_0 ));
  LUT5 #(
    .INIT(32'hFF8E8E00)) 
    \win_energy[3]_i_2 
       (.I0(seg_energy_reg[1]),
        .I1(seg_energy1__1[1]),
        .I2(ring_energy[1]),
        .I3(win_energy[2]),
        .I4(\win_energy[3]_i_11_n_0 ),
        .O(\win_energy[3]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFF69690069006900)) 
    \win_energy[3]_i_3 
       (.I0(seg_energy_reg[1]),
        .I1(ring_energy[1]),
        .I2(seg_energy1__1[1]),
        .I3(win_energy[1]),
        .I4(seg_energy1__1[0]),
        .I5(win_energy[0]),
        .O(\win_energy[3]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h6996966996699669)) 
    \win_energy[3]_i_4 
       (.I0(seg_energy_reg[1]),
        .I1(ring_energy[1]),
        .I2(seg_energy1__1[1]),
        .I3(win_energy[1]),
        .I4(seg_energy1__1[0]),
        .I5(win_energy[0]),
        .O(\win_energy[3]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \win_energy[3]_i_5 
       (.I0(seg_energy_reg[0]),
        .I1(ring_energy[0]),
        .O(\win_energy[3]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h6969966996699696)) 
    \win_energy[3]_i_6 
       (.I0(\win_energy[3]_i_2_n_0 ),
        .I1(\win_energy[7]_i_17_n_0 ),
        .I2(win_energy[3]),
        .I3(ring_energy[2]),
        .I4(seg_energy1__1[2]),
        .I5(seg_energy_reg[2]),
        .O(\win_energy[3]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h6969966996699696)) 
    \win_energy[3]_i_7 
       (.I0(\win_energy[3]_i_3_n_0 ),
        .I1(\win_energy[3]_i_11_n_0 ),
        .I2(win_energy[2]),
        .I3(ring_energy[1]),
        .I4(seg_energy1__1[1]),
        .I5(seg_energy_reg[1]),
        .O(\win_energy[3]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h7887788787787887)) 
    \win_energy[3]_i_8 
       (.I0(win_energy[0]),
        .I1(seg_energy1__1[0]),
        .I2(win_energy[1]),
        .I3(\win_energy[3]_i_13_n_0 ),
        .I4(ring_energy[0]),
        .I5(seg_energy_reg[0]),
        .O(\win_energy[3]_i_8_n_0 ));
  LUT4 #(
    .INIT(16'h6996)) 
    \win_energy[3]_i_9 
       (.I0(ring_energy[0]),
        .I1(seg_energy_reg[0]),
        .I2(seg_energy1__1[0]),
        .I3(win_energy[0]),
        .O(\win_energy[3]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_energy[7]_i_10 
       (.I0(\ring_energy_reg[2] [5]),
        .I1(\ring_energy_reg[3] [5]),
        .I2(\ring_energy_reg[0] [5]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_energy_reg[1] [5]),
        .O(ring_energy[5]));
  LUT3 #(
    .INIT(8'h69)) 
    \win_energy[7]_i_11 
       (.I0(seg_energy1__1[6]),
        .I1(ring_energy[6]),
        .I2(seg_energy_reg[6]),
        .O(\win_energy[7]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_energy[7]_i_12 
       (.I0(\ring_energy_reg[2] [4]),
        .I1(\ring_energy_reg[3] [4]),
        .I2(\ring_energy_reg[0] [4]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_energy_reg[1] [4]),
        .O(ring_energy[4]));
  LUT3 #(
    .INIT(8'h69)) 
    \win_energy[7]_i_13 
       (.I0(seg_energy1__1[5]),
        .I1(ring_energy[5]),
        .I2(seg_energy_reg[5]),
        .O(\win_energy[7]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_energy[7]_i_14 
       (.I0(\ring_energy_reg[2] [3]),
        .I1(\ring_energy_reg[3] [3]),
        .I2(\ring_energy_reg[0] [3]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_energy_reg[1] [3]),
        .O(ring_energy[3]));
  LUT3 #(
    .INIT(8'h69)) 
    \win_energy[7]_i_15 
       (.I0(seg_energy1__1[4]),
        .I1(ring_energy[4]),
        .I2(seg_energy_reg[4]),
        .O(\win_energy[7]_i_15_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_energy[7]_i_16 
       (.I0(\ring_energy_reg[2] [2]),
        .I1(\ring_energy_reg[3] [2]),
        .I2(\ring_energy_reg[0] [2]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_energy_reg[1] [2]),
        .O(ring_energy[2]));
  LUT3 #(
    .INIT(8'h69)) 
    \win_energy[7]_i_17 
       (.I0(seg_energy1__1[3]),
        .I1(ring_energy[3]),
        .I2(seg_energy_reg[3]),
        .O(\win_energy[7]_i_17_n_0 ));
  LUT5 #(
    .INIT(32'hFF8E8E00)) 
    \win_energy[7]_i_2 
       (.I0(seg_energy_reg[5]),
        .I1(seg_energy1__1[5]),
        .I2(ring_energy[5]),
        .I3(win_energy[6]),
        .I4(\win_energy[7]_i_11_n_0 ),
        .O(\win_energy[7]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hFF8E8E00)) 
    \win_energy[7]_i_3 
       (.I0(seg_energy_reg[4]),
        .I1(seg_energy1__1[4]),
        .I2(ring_energy[4]),
        .I3(win_energy[5]),
        .I4(\win_energy[7]_i_13_n_0 ),
        .O(\win_energy[7]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'hFF8E8E00)) 
    \win_energy[7]_i_4 
       (.I0(seg_energy_reg[3]),
        .I1(seg_energy1__1[3]),
        .I2(ring_energy[3]),
        .I3(win_energy[4]),
        .I4(\win_energy[7]_i_15_n_0 ),
        .O(\win_energy[7]_i_4_n_0 ));
  LUT5 #(
    .INIT(32'hFF8E8E00)) 
    \win_energy[7]_i_5 
       (.I0(seg_energy_reg[2]),
        .I1(seg_energy1__1[2]),
        .I2(ring_energy[2]),
        .I3(win_energy[3]),
        .I4(\win_energy[7]_i_17_n_0 ),
        .O(\win_energy[7]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h6969966996699696)) 
    \win_energy[7]_i_6 
       (.I0(\win_energy[7]_i_2_n_0 ),
        .I1(\win_energy[11]_i_17_n_0 ),
        .I2(win_energy[7]),
        .I3(ring_energy[6]),
        .I4(seg_energy1__1[6]),
        .I5(seg_energy_reg[6]),
        .O(\win_energy[7]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h6969966996699696)) 
    \win_energy[7]_i_7 
       (.I0(\win_energy[7]_i_3_n_0 ),
        .I1(\win_energy[7]_i_11_n_0 ),
        .I2(win_energy[6]),
        .I3(ring_energy[5]),
        .I4(seg_energy1__1[5]),
        .I5(seg_energy_reg[5]),
        .O(\win_energy[7]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h6969966996699696)) 
    \win_energy[7]_i_8 
       (.I0(\win_energy[7]_i_4_n_0 ),
        .I1(\win_energy[7]_i_13_n_0 ),
        .I2(win_energy[5]),
        .I3(ring_energy[4]),
        .I4(seg_energy1__1[4]),
        .I5(seg_energy_reg[4]),
        .O(\win_energy[7]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'h6969966996699696)) 
    \win_energy[7]_i_9 
       (.I0(\win_energy[7]_i_5_n_0 ),
        .I1(\win_energy[7]_i_15_n_0 ),
        .I2(win_energy[4]),
        .I3(ring_energy[3]),
        .I4(seg_energy1__1[3]),
        .I5(seg_energy_reg[3]),
        .O(\win_energy[7]_i_9_n_0 ));
  FDRE \win_energy_reg[0] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[3]_i_1_n_7 ),
        .Q(win_energy[0]),
        .R(clear));
  FDRE \win_energy_reg[10] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[11]_i_1_n_5 ),
        .Q(win_energy[10]),
        .R(clear));
  FDRE \win_energy_reg[11] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[11]_i_1_n_4 ),
        .Q(win_energy[11]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \win_energy_reg[11]_i_1 
       (.CI(\win_energy_reg[7]_i_1_n_0 ),
        .CO({\win_energy_reg[11]_i_1_n_0 ,\win_energy_reg[11]_i_1_n_1 ,\win_energy_reg[11]_i_1_n_2 ,\win_energy_reg[11]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\win_energy[11]_i_2_n_0 ,\win_energy[11]_i_3_n_0 ,\win_energy[11]_i_4_n_0 ,\win_energy[11]_i_5_n_0 }),
        .O({\win_energy_reg[11]_i_1_n_4 ,\win_energy_reg[11]_i_1_n_5 ,\win_energy_reg[11]_i_1_n_6 ,\win_energy_reg[11]_i_1_n_7 }),
        .S({\win_energy[11]_i_6_n_0 ,\win_energy[11]_i_7_n_0 ,\win_energy[11]_i_8_n_0 ,\win_energy[11]_i_9_n_0 }));
  FDRE \win_energy_reg[12] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[15]_i_1_n_7 ),
        .Q(win_energy[12]),
        .R(clear));
  FDRE \win_energy_reg[13] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[15]_i_1_n_6 ),
        .Q(win_energy[13]),
        .R(clear));
  FDRE \win_energy_reg[14] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[15]_i_1_n_5 ),
        .Q(win_energy[14]),
        .R(clear));
  FDRE \win_energy_reg[15] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[15]_i_1_n_4 ),
        .Q(win_energy[15]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \win_energy_reg[15]_i_1 
       (.CI(\win_energy_reg[11]_i_1_n_0 ),
        .CO({\win_energy_reg[15]_i_1_n_0 ,\win_energy_reg[15]_i_1_n_1 ,\win_energy_reg[15]_i_1_n_2 ,\win_energy_reg[15]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\win_energy[15]_i_2_n_0 ,\win_energy[15]_i_3_n_0 ,\win_energy[15]_i_4_n_0 ,\win_energy[15]_i_5_n_0 }),
        .O({\win_energy_reg[15]_i_1_n_4 ,\win_energy_reg[15]_i_1_n_5 ,\win_energy_reg[15]_i_1_n_6 ,\win_energy_reg[15]_i_1_n_7 }),
        .S({\win_energy[15]_i_6_n_0 ,\win_energy[15]_i_7_n_0 ,\win_energy[15]_i_8_n_0 ,\win_energy[15]_i_9_n_0 }));
  FDRE \win_energy_reg[16] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[19]_i_1_n_7 ),
        .Q(win_energy[16]),
        .R(clear));
  FDRE \win_energy_reg[17] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[19]_i_1_n_6 ),
        .Q(win_energy[17]),
        .R(clear));
  FDRE \win_energy_reg[18] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[19]_i_1_n_5 ),
        .Q(win_energy[18]),
        .R(clear));
  FDRE \win_energy_reg[19] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[19]_i_1_n_4 ),
        .Q(win_energy[19]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \win_energy_reg[19]_i_1 
       (.CI(\win_energy_reg[15]_i_1_n_0 ),
        .CO({\win_energy_reg[19]_i_1_n_0 ,\win_energy_reg[19]_i_1_n_1 ,\win_energy_reg[19]_i_1_n_2 ,\win_energy_reg[19]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\win_energy[19]_i_2_n_0 ,\win_energy[19]_i_3_n_0 ,\win_energy[19]_i_4_n_0 ,\win_energy[19]_i_5_n_0 }),
        .O({\win_energy_reg[19]_i_1_n_4 ,\win_energy_reg[19]_i_1_n_5 ,\win_energy_reg[19]_i_1_n_6 ,\win_energy_reg[19]_i_1_n_7 }),
        .S({\win_energy[19]_i_6_n_0 ,\win_energy[19]_i_7_n_0 ,\win_energy[19]_i_8_n_0 ,\win_energy[19]_i_9_n_0 }));
  FDRE \win_energy_reg[1] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[3]_i_1_n_6 ),
        .Q(win_energy[1]),
        .R(clear));
  FDRE \win_energy_reg[20] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[23]_i_1_n_7 ),
        .Q(win_energy[20]),
        .R(clear));
  FDRE \win_energy_reg[21] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[23]_i_1_n_6 ),
        .Q(win_energy[21]),
        .R(clear));
  FDRE \win_energy_reg[22] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[23]_i_1_n_5 ),
        .Q(win_energy[22]),
        .R(clear));
  FDRE \win_energy_reg[23] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[23]_i_1_n_4 ),
        .Q(win_energy[23]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \win_energy_reg[23]_i_1 
       (.CI(\win_energy_reg[19]_i_1_n_0 ),
        .CO({\win_energy_reg[23]_i_1_n_0 ,\win_energy_reg[23]_i_1_n_1 ,\win_energy_reg[23]_i_1_n_2 ,\win_energy_reg[23]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\win_energy[23]_i_2_n_0 ,\win_energy[23]_i_3_n_0 ,\win_energy[23]_i_4_n_0 ,\win_energy[23]_i_5_n_0 }),
        .O({\win_energy_reg[23]_i_1_n_4 ,\win_energy_reg[23]_i_1_n_5 ,\win_energy_reg[23]_i_1_n_6 ,\win_energy_reg[23]_i_1_n_7 }),
        .S({\win_energy[23]_i_6_n_0 ,\win_energy[23]_i_7_n_0 ,\win_energy[23]_i_8_n_0 ,\win_energy[23]_i_9_n_0 }));
  FDRE \win_energy_reg[24] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[27]_i_1_n_7 ),
        .Q(win_energy[24]),
        .R(clear));
  FDRE \win_energy_reg[25] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[27]_i_1_n_6 ),
        .Q(win_energy[25]),
        .R(clear));
  FDRE \win_energy_reg[26] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[27]_i_1_n_5 ),
        .Q(win_energy[26]),
        .R(clear));
  FDRE \win_energy_reg[27] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[27]_i_1_n_4 ),
        .Q(win_energy[27]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \win_energy_reg[27]_i_1 
       (.CI(\win_energy_reg[23]_i_1_n_0 ),
        .CO({\win_energy_reg[27]_i_1_n_0 ,\win_energy_reg[27]_i_1_n_1 ,\win_energy_reg[27]_i_1_n_2 ,\win_energy_reg[27]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\win_energy[27]_i_2_n_0 ,\win_energy[27]_i_3_n_0 ,\win_energy[27]_i_4_n_0 ,\win_energy[27]_i_5_n_0 }),
        .O({\win_energy_reg[27]_i_1_n_4 ,\win_energy_reg[27]_i_1_n_5 ,\win_energy_reg[27]_i_1_n_6 ,\win_energy_reg[27]_i_1_n_7 }),
        .S({\win_energy[27]_i_6_n_0 ,\win_energy[27]_i_7_n_0 ,\win_energy[27]_i_8_n_0 ,\win_energy[27]_i_9_n_0 }));
  FDRE \win_energy_reg[28] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[31]_i_1_n_7 ),
        .Q(win_energy[28]),
        .R(clear));
  FDRE \win_energy_reg[29] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[31]_i_1_n_6 ),
        .Q(win_energy[29]),
        .R(clear));
  FDRE \win_energy_reg[2] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[3]_i_1_n_5 ),
        .Q(win_energy[2]),
        .R(clear));
  FDRE \win_energy_reg[30] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[31]_i_1_n_5 ),
        .Q(win_energy[30]),
        .R(clear));
  FDRE \win_energy_reg[31] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[31]_i_1_n_4 ),
        .Q(win_energy[31]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \win_energy_reg[31]_i_1 
       (.CI(\win_energy_reg[27]_i_1_n_0 ),
        .CO({\win_energy_reg[31]_i_1_n_0 ,\win_energy_reg[31]_i_1_n_1 ,\win_energy_reg[31]_i_1_n_2 ,\win_energy_reg[31]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\win_energy[31]_i_2_n_0 ,\win_energy[31]_i_3_n_0 ,\win_energy[31]_i_4_n_0 ,\win_energy[31]_i_5_n_0 }),
        .O({\win_energy_reg[31]_i_1_n_4 ,\win_energy_reg[31]_i_1_n_5 ,\win_energy_reg[31]_i_1_n_6 ,\win_energy_reg[31]_i_1_n_7 }),
        .S({\win_energy[31]_i_6_n_0 ,\win_energy[31]_i_7_n_0 ,\win_energy[31]_i_8_n_0 ,\win_energy[31]_i_9_n_0 }));
  FDRE \win_energy_reg[32] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[35]_i_1_n_7 ),
        .Q(win_energy[32]),
        .R(clear));
  FDRE \win_energy_reg[33] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[35]_i_1_n_6 ),
        .Q(win_energy[33]),
        .R(clear));
  FDRE \win_energy_reg[34] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[35]_i_1_n_5 ),
        .Q(win_energy[34]),
        .R(clear));
  FDRE \win_energy_reg[35] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[35]_i_1_n_4 ),
        .Q(win_energy[35]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \win_energy_reg[35]_i_1 
       (.CI(\win_energy_reg[31]_i_1_n_0 ),
        .CO({\win_energy_reg[35]_i_1_n_0 ,\win_energy_reg[35]_i_1_n_1 ,\win_energy_reg[35]_i_1_n_2 ,\win_energy_reg[35]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({win_energy[34:33],\win_energy[35]_i_2_n_0 ,\win_energy[35]_i_3_n_0 }),
        .O({\win_energy_reg[35]_i_1_n_4 ,\win_energy_reg[35]_i_1_n_5 ,\win_energy_reg[35]_i_1_n_6 ,\win_energy_reg[35]_i_1_n_7 }),
        .S({\win_energy[35]_i_4_n_0 ,\win_energy[35]_i_5_n_0 ,\win_energy[35]_i_6_n_0 ,\win_energy[35]_i_7_n_0 }));
  FDRE \win_energy_reg[36] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[39]_i_1_n_7 ),
        .Q(win_energy[36]),
        .R(clear));
  FDRE \win_energy_reg[37] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[39]_i_1_n_6 ),
        .Q(win_energy[37]),
        .R(clear));
  FDRE \win_energy_reg[38] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[39]_i_1_n_5 ),
        .Q(win_energy[38]),
        .R(clear));
  FDRE \win_energy_reg[39] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[39]_i_1_n_4 ),
        .Q(win_energy[39]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \win_energy_reg[39]_i_1 
       (.CI(\win_energy_reg[35]_i_1_n_0 ),
        .CO({\NLW_win_energy_reg[39]_i_1_CO_UNCONNECTED [3],\win_energy_reg[39]_i_1_n_1 ,\win_energy_reg[39]_i_1_n_2 ,\win_energy_reg[39]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,win_energy[37:35]}),
        .O({\win_energy_reg[39]_i_1_n_4 ,\win_energy_reg[39]_i_1_n_5 ,\win_energy_reg[39]_i_1_n_6 ,\win_energy_reg[39]_i_1_n_7 }),
        .S({\win_energy[39]_i_2_n_0 ,\win_energy[39]_i_3_n_0 ,\win_energy[39]_i_4_n_0 ,\win_energy[39]_i_5_n_0 }));
  FDRE \win_energy_reg[3] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[3]_i_1_n_4 ),
        .Q(win_energy[3]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \win_energy_reg[3]_i_1 
       (.CI(1'b0),
        .CO({\win_energy_reg[3]_i_1_n_0 ,\win_energy_reg[3]_i_1_n_1 ,\win_energy_reg[3]_i_1_n_2 ,\win_energy_reg[3]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\win_energy[3]_i_2_n_0 ,\win_energy[3]_i_3_n_0 ,\win_energy[3]_i_4_n_0 ,\win_energy[3]_i_5_n_0 }),
        .O({\win_energy_reg[3]_i_1_n_4 ,\win_energy_reg[3]_i_1_n_5 ,\win_energy_reg[3]_i_1_n_6 ,\win_energy_reg[3]_i_1_n_7 }),
        .S({\win_energy[3]_i_6_n_0 ,\win_energy[3]_i_7_n_0 ,\win_energy[3]_i_8_n_0 ,\win_energy[3]_i_9_n_0 }));
  FDRE \win_energy_reg[4] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[7]_i_1_n_7 ),
        .Q(win_energy[4]),
        .R(clear));
  FDRE \win_energy_reg[5] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[7]_i_1_n_6 ),
        .Q(win_energy[5]),
        .R(clear));
  FDRE \win_energy_reg[6] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[7]_i_1_n_5 ),
        .Q(win_energy[6]),
        .R(clear));
  FDRE \win_energy_reg[7] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[7]_i_1_n_4 ),
        .Q(win_energy[7]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \win_energy_reg[7]_i_1 
       (.CI(\win_energy_reg[3]_i_1_n_0 ),
        .CO({\win_energy_reg[7]_i_1_n_0 ,\win_energy_reg[7]_i_1_n_1 ,\win_energy_reg[7]_i_1_n_2 ,\win_energy_reg[7]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\win_energy[7]_i_2_n_0 ,\win_energy[7]_i_3_n_0 ,\win_energy[7]_i_4_n_0 ,\win_energy[7]_i_5_n_0 }),
        .O({\win_energy_reg[7]_i_1_n_4 ,\win_energy_reg[7]_i_1_n_5 ,\win_energy_reg[7]_i_1_n_6 ,\win_energy_reg[7]_i_1_n_7 }),
        .S({\win_energy[7]_i_6_n_0 ,\win_energy[7]_i_7_n_0 ,\win_energy[7]_i_8_n_0 ,\win_energy[7]_i_9_n_0 }));
  FDRE \win_energy_reg[8] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[11]_i_1_n_7 ),
        .Q(win_energy[8]),
        .R(clear));
  FDRE \win_energy_reg[9] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_energy_reg[11]_i_1_n_6 ),
        .Q(win_energy[9]),
        .R(clear));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT5 #(
    .INIT(32'hDFD54540)) 
    \win_mav[11]_i_10 
       (.I0(\win_mav[11]_i_18_n_0 ),
        .I1(seg_mav2[9]),
        .I2(sample_in[23]),
        .I3(sample_in[9]),
        .I4(seg_mav_reg[9]),
        .O(\win_mav[11]_i_10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT5 #(
    .INIT(32'h1DE2E21D)) 
    \win_mav[11]_i_11 
       (.I0(sample_in[10]),
        .I1(sample_in[23]),
        .I2(seg_mav2[10]),
        .I3(\win_mav[15]_i_21_n_0 ),
        .I4(seg_mav_reg[10]),
        .O(\win_mav[11]_i_11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT5 #(
    .INIT(32'hDFD54540)) 
    \win_mav[11]_i_12 
       (.I0(\win_mav[11]_i_19_n_0 ),
        .I1(seg_mav2[8]),
        .I2(sample_in[23]),
        .I3(sample_in[8]),
        .I4(seg_mav_reg[8]),
        .O(\win_mav[11]_i_12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT5 #(
    .INIT(32'h1DE2E21D)) 
    \win_mav[11]_i_13 
       (.I0(sample_in[9]),
        .I1(sample_in[23]),
        .I2(seg_mav2[9]),
        .I3(\win_mav[11]_i_18_n_0 ),
        .I4(seg_mav_reg[9]),
        .O(\win_mav[11]_i_13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT5 #(
    .INIT(32'hDFD54540)) 
    \win_mav[11]_i_14 
       (.I0(\win_mav[11]_i_20_n_0 ),
        .I1(seg_mav2[7]),
        .I2(sample_in[23]),
        .I3(sample_in[7]),
        .I4(seg_mav_reg[7]),
        .O(\win_mav[11]_i_14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT5 #(
    .INIT(32'h1DE2E21D)) 
    \win_mav[11]_i_15 
       (.I0(sample_in[8]),
        .I1(sample_in[23]),
        .I2(seg_mav2[8]),
        .I3(\win_mav[11]_i_19_n_0 ),
        .I4(seg_mav_reg[8]),
        .O(\win_mav[11]_i_15_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT5 #(
    .INIT(32'hDFD54540)) 
    \win_mav[11]_i_16 
       (.I0(\win_mav[11]_i_21_n_0 ),
        .I1(seg_mav2[6]),
        .I2(sample_in[23]),
        .I3(sample_in[6]),
        .I4(seg_mav_reg[6]),
        .O(\win_mav[11]_i_16_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT5 #(
    .INIT(32'h1DE2E21D)) 
    \win_mav[11]_i_17 
       (.I0(sample_in[7]),
        .I1(sample_in[23]),
        .I2(seg_mav2[7]),
        .I3(\win_mav[11]_i_20_n_0 ),
        .I4(seg_mav_reg[7]),
        .O(\win_mav[11]_i_17_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_mav[11]_i_18 
       (.I0(\ring_mav_reg[2] [9]),
        .I1(\ring_mav_reg[3] [9]),
        .I2(\ring_mav_reg[0] [9]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_mav_reg[1] [9]),
        .O(\win_mav[11]_i_18_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_mav[11]_i_19 
       (.I0(\ring_mav_reg[2] [8]),
        .I1(\ring_mav_reg[3] [8]),
        .I2(\ring_mav_reg[0] [8]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_mav_reg[1] [8]),
        .O(\win_mav[11]_i_19_n_0 ));
  (* HLUTNM = "lutpair8" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \win_mav[11]_i_2 
       (.I0(\win_mav[11]_i_10_n_0 ),
        .I1(\win_mav_reg_n_0_[10] ),
        .I2(\win_mav[11]_i_11_n_0 ),
        .O(\win_mav[11]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_mav[11]_i_20 
       (.I0(\ring_mav_reg[2] [7]),
        .I1(\ring_mav_reg[3] [7]),
        .I2(\ring_mav_reg[0] [7]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_mav_reg[1] [7]),
        .O(\win_mav[11]_i_20_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_mav[11]_i_21 
       (.I0(\ring_mav_reg[2] [6]),
        .I1(\ring_mav_reg[3] [6]),
        .I2(\ring_mav_reg[0] [6]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_mav_reg[1] [6]),
        .O(\win_mav[11]_i_21_n_0 ));
  (* HLUTNM = "lutpair7" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \win_mav[11]_i_3 
       (.I0(\win_mav[11]_i_12_n_0 ),
        .I1(\win_mav_reg_n_0_[9] ),
        .I2(\win_mav[11]_i_13_n_0 ),
        .O(\win_mav[11]_i_3_n_0 ));
  (* HLUTNM = "lutpair6" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \win_mav[11]_i_4 
       (.I0(\win_mav[11]_i_14_n_0 ),
        .I1(\win_mav_reg_n_0_[8] ),
        .I2(\win_mav[11]_i_15_n_0 ),
        .O(\win_mav[11]_i_4_n_0 ));
  (* HLUTNM = "lutpair5" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \win_mav[11]_i_5 
       (.I0(\win_mav[11]_i_16_n_0 ),
        .I1(\win_mav_reg_n_0_[7] ),
        .I2(\win_mav[11]_i_17_n_0 ),
        .O(\win_mav[11]_i_5_n_0 ));
  (* HLUTNM = "lutpair9" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \win_mav[11]_i_6 
       (.I0(\win_mav[15]_i_16_n_0 ),
        .I1(\win_mav_reg_n_0_[11] ),
        .I2(\win_mav[15]_i_17_n_0 ),
        .I3(\win_mav[11]_i_2_n_0 ),
        .O(\win_mav[11]_i_6_n_0 ));
  (* HLUTNM = "lutpair8" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \win_mav[11]_i_7 
       (.I0(\win_mav[11]_i_10_n_0 ),
        .I1(\win_mav_reg_n_0_[10] ),
        .I2(\win_mav[11]_i_11_n_0 ),
        .I3(\win_mav[11]_i_3_n_0 ),
        .O(\win_mav[11]_i_7_n_0 ));
  (* HLUTNM = "lutpair7" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \win_mav[11]_i_8 
       (.I0(\win_mav[11]_i_12_n_0 ),
        .I1(\win_mav_reg_n_0_[9] ),
        .I2(\win_mav[11]_i_13_n_0 ),
        .I3(\win_mav[11]_i_4_n_0 ),
        .O(\win_mav[11]_i_8_n_0 ));
  (* HLUTNM = "lutpair6" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \win_mav[11]_i_9 
       (.I0(\win_mav[11]_i_14_n_0 ),
        .I1(\win_mav_reg_n_0_[8] ),
        .I2(\win_mav[11]_i_15_n_0 ),
        .I3(\win_mav[11]_i_5_n_0 ),
        .O(\win_mav[11]_i_9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT5 #(
    .INIT(32'hDFD54540)) 
    \win_mav[15]_i_10 
       (.I0(\win_mav[15]_i_18_n_0 ),
        .I1(seg_mav2[13]),
        .I2(sample_in[23]),
        .I3(sample_in[13]),
        .I4(seg_mav_reg[13]),
        .O(\win_mav[15]_i_10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT5 #(
    .INIT(32'h1DE2E21D)) 
    \win_mav[15]_i_11 
       (.I0(sample_in[14]),
        .I1(sample_in[23]),
        .I2(seg_mav2[14]),
        .I3(\win_mav[19]_i_21_n_0 ),
        .I4(seg_mav_reg[14]),
        .O(\win_mav[15]_i_11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT5 #(
    .INIT(32'hDFD54540)) 
    \win_mav[15]_i_12 
       (.I0(\win_mav[15]_i_19_n_0 ),
        .I1(seg_mav2[12]),
        .I2(sample_in[23]),
        .I3(sample_in[12]),
        .I4(seg_mav_reg[12]),
        .O(\win_mav[15]_i_12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT5 #(
    .INIT(32'h1DE2E21D)) 
    \win_mav[15]_i_13 
       (.I0(sample_in[13]),
        .I1(sample_in[23]),
        .I2(seg_mav2[13]),
        .I3(\win_mav[15]_i_18_n_0 ),
        .I4(seg_mav_reg[13]),
        .O(\win_mav[15]_i_13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT5 #(
    .INIT(32'hDFD54540)) 
    \win_mav[15]_i_14 
       (.I0(\win_mav[15]_i_20_n_0 ),
        .I1(seg_mav2[11]),
        .I2(sample_in[23]),
        .I3(sample_in[11]),
        .I4(seg_mav_reg[11]),
        .O(\win_mav[15]_i_14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT5 #(
    .INIT(32'h1DE2E21D)) 
    \win_mav[15]_i_15 
       (.I0(sample_in[12]),
        .I1(sample_in[23]),
        .I2(seg_mav2[12]),
        .I3(\win_mav[15]_i_19_n_0 ),
        .I4(seg_mav_reg[12]),
        .O(\win_mav[15]_i_15_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT5 #(
    .INIT(32'hDFD54540)) 
    \win_mav[15]_i_16 
       (.I0(\win_mav[15]_i_21_n_0 ),
        .I1(seg_mav2[10]),
        .I2(sample_in[23]),
        .I3(sample_in[10]),
        .I4(seg_mav_reg[10]),
        .O(\win_mav[15]_i_16_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT5 #(
    .INIT(32'h1DE2E21D)) 
    \win_mav[15]_i_17 
       (.I0(sample_in[11]),
        .I1(sample_in[23]),
        .I2(seg_mav2[11]),
        .I3(\win_mav[15]_i_20_n_0 ),
        .I4(seg_mav_reg[11]),
        .O(\win_mav[15]_i_17_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_mav[15]_i_18 
       (.I0(\ring_mav_reg[2] [13]),
        .I1(\ring_mav_reg[3] [13]),
        .I2(\ring_mav_reg[0] [13]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_mav_reg[1] [13]),
        .O(\win_mav[15]_i_18_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_mav[15]_i_19 
       (.I0(\ring_mav_reg[2] [12]),
        .I1(\ring_mav_reg[3] [12]),
        .I2(\ring_mav_reg[0] [12]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_mav_reg[1] [12]),
        .O(\win_mav[15]_i_19_n_0 ));
  (* HLUTNM = "lutpair12" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \win_mav[15]_i_2 
       (.I0(\win_mav[15]_i_10_n_0 ),
        .I1(\win_mav_reg_n_0_[14] ),
        .I2(\win_mav[15]_i_11_n_0 ),
        .O(\win_mav[15]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_mav[15]_i_20 
       (.I0(\ring_mav_reg[2] [11]),
        .I1(\ring_mav_reg[3] [11]),
        .I2(\ring_mav_reg[0] [11]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_mav_reg[1] [11]),
        .O(\win_mav[15]_i_20_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_mav[15]_i_21 
       (.I0(\ring_mav_reg[2] [10]),
        .I1(\ring_mav_reg[3] [10]),
        .I2(\ring_mav_reg[0] [10]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_mav_reg[1] [10]),
        .O(\win_mav[15]_i_21_n_0 ));
  (* HLUTNM = "lutpair11" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \win_mav[15]_i_3 
       (.I0(\win_mav[15]_i_12_n_0 ),
        .I1(\win_mav_reg_n_0_[13] ),
        .I2(\win_mav[15]_i_13_n_0 ),
        .O(\win_mav[15]_i_3_n_0 ));
  (* HLUTNM = "lutpair10" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \win_mav[15]_i_4 
       (.I0(\win_mav[15]_i_14_n_0 ),
        .I1(\win_mav_reg_n_0_[12] ),
        .I2(\win_mav[15]_i_15_n_0 ),
        .O(\win_mav[15]_i_4_n_0 ));
  (* HLUTNM = "lutpair9" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \win_mav[15]_i_5 
       (.I0(\win_mav[15]_i_16_n_0 ),
        .I1(\win_mav_reg_n_0_[11] ),
        .I2(\win_mav[15]_i_17_n_0 ),
        .O(\win_mav[15]_i_5_n_0 ));
  (* HLUTNM = "lutpair13" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \win_mav[15]_i_6 
       (.I0(\win_mav[19]_i_16_n_0 ),
        .I1(\win_mav_reg_n_0_[15] ),
        .I2(\win_mav[19]_i_17_n_0 ),
        .I3(\win_mav[15]_i_2_n_0 ),
        .O(\win_mav[15]_i_6_n_0 ));
  (* HLUTNM = "lutpair12" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \win_mav[15]_i_7 
       (.I0(\win_mav[15]_i_10_n_0 ),
        .I1(\win_mav_reg_n_0_[14] ),
        .I2(\win_mav[15]_i_11_n_0 ),
        .I3(\win_mav[15]_i_3_n_0 ),
        .O(\win_mav[15]_i_7_n_0 ));
  (* HLUTNM = "lutpair11" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \win_mav[15]_i_8 
       (.I0(\win_mav[15]_i_12_n_0 ),
        .I1(\win_mav_reg_n_0_[13] ),
        .I2(\win_mav[15]_i_13_n_0 ),
        .I3(\win_mav[15]_i_4_n_0 ),
        .O(\win_mav[15]_i_8_n_0 ));
  (* HLUTNM = "lutpair10" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \win_mav[15]_i_9 
       (.I0(\win_mav[15]_i_14_n_0 ),
        .I1(\win_mav_reg_n_0_[12] ),
        .I2(\win_mav[15]_i_15_n_0 ),
        .I3(\win_mav[15]_i_5_n_0 ),
        .O(\win_mav[15]_i_9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT5 #(
    .INIT(32'hDFD54540)) 
    \win_mav[19]_i_10 
       (.I0(\win_mav[19]_i_18_n_0 ),
        .I1(seg_mav2[17]),
        .I2(sample_in[23]),
        .I3(sample_in[17]),
        .I4(seg_mav_reg[17]),
        .O(\win_mav[19]_i_10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT5 #(
    .INIT(32'h1DE2E21D)) 
    \win_mav[19]_i_11 
       (.I0(sample_in[18]),
        .I1(sample_in[23]),
        .I2(seg_mav2[18]),
        .I3(\win_mav[23]_i_22_n_0 ),
        .I4(seg_mav_reg[18]),
        .O(\win_mav[19]_i_11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT5 #(
    .INIT(32'hDFD54540)) 
    \win_mav[19]_i_12 
       (.I0(\win_mav[19]_i_19_n_0 ),
        .I1(seg_mav2[16]),
        .I2(sample_in[23]),
        .I3(sample_in[16]),
        .I4(seg_mav_reg[16]),
        .O(\win_mav[19]_i_12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT5 #(
    .INIT(32'h1DE2E21D)) 
    \win_mav[19]_i_13 
       (.I0(sample_in[17]),
        .I1(sample_in[23]),
        .I2(seg_mav2[17]),
        .I3(\win_mav[19]_i_18_n_0 ),
        .I4(seg_mav_reg[17]),
        .O(\win_mav[19]_i_13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT5 #(
    .INIT(32'hDFD54540)) 
    \win_mav[19]_i_14 
       (.I0(\win_mav[19]_i_20_n_0 ),
        .I1(seg_mav2[15]),
        .I2(sample_in[23]),
        .I3(sample_in[15]),
        .I4(seg_mav_reg[15]),
        .O(\win_mav[19]_i_14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT5 #(
    .INIT(32'h1DE2E21D)) 
    \win_mav[19]_i_15 
       (.I0(sample_in[16]),
        .I1(sample_in[23]),
        .I2(seg_mav2[16]),
        .I3(\win_mav[19]_i_19_n_0 ),
        .I4(seg_mav_reg[16]),
        .O(\win_mav[19]_i_15_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT5 #(
    .INIT(32'hDFD54540)) 
    \win_mav[19]_i_16 
       (.I0(\win_mav[19]_i_21_n_0 ),
        .I1(seg_mav2[14]),
        .I2(sample_in[23]),
        .I3(sample_in[14]),
        .I4(seg_mav_reg[14]),
        .O(\win_mav[19]_i_16_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT5 #(
    .INIT(32'h1DE2E21D)) 
    \win_mav[19]_i_17 
       (.I0(sample_in[15]),
        .I1(sample_in[23]),
        .I2(seg_mav2[15]),
        .I3(\win_mav[19]_i_20_n_0 ),
        .I4(seg_mav_reg[15]),
        .O(\win_mav[19]_i_17_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_mav[19]_i_18 
       (.I0(\ring_mav_reg[2] [17]),
        .I1(\ring_mav_reg[3] [17]),
        .I2(\ring_mav_reg[0] [17]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_mav_reg[1] [17]),
        .O(\win_mav[19]_i_18_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_mav[19]_i_19 
       (.I0(\ring_mav_reg[2] [16]),
        .I1(\ring_mav_reg[3] [16]),
        .I2(\ring_mav_reg[0] [16]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_mav_reg[1] [16]),
        .O(\win_mav[19]_i_19_n_0 ));
  (* HLUTNM = "lutpair16" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \win_mav[19]_i_2 
       (.I0(\win_mav[19]_i_10_n_0 ),
        .I1(\win_mav_reg_n_0_[18] ),
        .I2(\win_mav[19]_i_11_n_0 ),
        .O(\win_mav[19]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_mav[19]_i_20 
       (.I0(\ring_mav_reg[2] [15]),
        .I1(\ring_mav_reg[3] [15]),
        .I2(\ring_mav_reg[0] [15]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_mav_reg[1] [15]),
        .O(\win_mav[19]_i_20_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_mav[19]_i_21 
       (.I0(\ring_mav_reg[2] [14]),
        .I1(\ring_mav_reg[3] [14]),
        .I2(\ring_mav_reg[0] [14]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_mav_reg[1] [14]),
        .O(\win_mav[19]_i_21_n_0 ));
  (* HLUTNM = "lutpair15" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \win_mav[19]_i_3 
       (.I0(\win_mav[19]_i_12_n_0 ),
        .I1(\win_mav_reg_n_0_[17] ),
        .I2(\win_mav[19]_i_13_n_0 ),
        .O(\win_mav[19]_i_3_n_0 ));
  (* HLUTNM = "lutpair14" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \win_mav[19]_i_4 
       (.I0(\win_mav[19]_i_14_n_0 ),
        .I1(\win_mav_reg_n_0_[16] ),
        .I2(\win_mav[19]_i_15_n_0 ),
        .O(\win_mav[19]_i_4_n_0 ));
  (* HLUTNM = "lutpair13" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \win_mav[19]_i_5 
       (.I0(\win_mav[19]_i_16_n_0 ),
        .I1(\win_mav_reg_n_0_[15] ),
        .I2(\win_mav[19]_i_17_n_0 ),
        .O(\win_mav[19]_i_5_n_0 ));
  (* HLUTNM = "lutpair17" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \win_mav[19]_i_6 
       (.I0(\win_mav[23]_i_16_n_0 ),
        .I1(\win_mav_reg_n_0_[19] ),
        .I2(\win_mav[23]_i_17_n_0 ),
        .I3(\win_mav[19]_i_2_n_0 ),
        .O(\win_mav[19]_i_6_n_0 ));
  (* HLUTNM = "lutpair16" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \win_mav[19]_i_7 
       (.I0(\win_mav[19]_i_10_n_0 ),
        .I1(\win_mav_reg_n_0_[18] ),
        .I2(\win_mav[19]_i_11_n_0 ),
        .I3(\win_mav[19]_i_3_n_0 ),
        .O(\win_mav[19]_i_7_n_0 ));
  (* HLUTNM = "lutpair15" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \win_mav[19]_i_8 
       (.I0(\win_mav[19]_i_12_n_0 ),
        .I1(\win_mav_reg_n_0_[17] ),
        .I2(\win_mav[19]_i_13_n_0 ),
        .I3(\win_mav[19]_i_4_n_0 ),
        .O(\win_mav[19]_i_8_n_0 ));
  (* HLUTNM = "lutpair14" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \win_mav[19]_i_9 
       (.I0(\win_mav[19]_i_14_n_0 ),
        .I1(\win_mav_reg_n_0_[16] ),
        .I2(\win_mav[19]_i_15_n_0 ),
        .I3(\win_mav[19]_i_5_n_0 ),
        .O(\win_mav[19]_i_9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT5 #(
    .INIT(32'hDFD54540)) 
    \win_mav[23]_i_10 
       (.I0(\win_mav[23]_i_19_n_0 ),
        .I1(seg_mav2[21]),
        .I2(sample_in[23]),
        .I3(sample_in[21]),
        .I4(seg_mav_reg[21]),
        .O(\win_mav[23]_i_10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT5 #(
    .INIT(32'h1DE2E21D)) 
    \win_mav[23]_i_11 
       (.I0(sample_in[22]),
        .I1(sample_in[23]),
        .I2(seg_mav2[22]),
        .I3(\win_mav[27]_i_20_n_0 ),
        .I4(seg_mav_reg[22]),
        .O(\win_mav[23]_i_11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT5 #(
    .INIT(32'hDFD54540)) 
    \win_mav[23]_i_12 
       (.I0(\win_mav[23]_i_20_n_0 ),
        .I1(seg_mav2[20]),
        .I2(sample_in[23]),
        .I3(sample_in[20]),
        .I4(seg_mav_reg[20]),
        .O(\win_mav[23]_i_12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT5 #(
    .INIT(32'h1DE2E21D)) 
    \win_mav[23]_i_13 
       (.I0(sample_in[21]),
        .I1(sample_in[23]),
        .I2(seg_mav2[21]),
        .I3(\win_mav[23]_i_19_n_0 ),
        .I4(seg_mav_reg[21]),
        .O(\win_mav[23]_i_13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT5 #(
    .INIT(32'hDFD54540)) 
    \win_mav[23]_i_14 
       (.I0(\win_mav[23]_i_21_n_0 ),
        .I1(seg_mav2[19]),
        .I2(sample_in[23]),
        .I3(sample_in[19]),
        .I4(seg_mav_reg[19]),
        .O(\win_mav[23]_i_14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT5 #(
    .INIT(32'h1DE2E21D)) 
    \win_mav[23]_i_15 
       (.I0(sample_in[20]),
        .I1(sample_in[23]),
        .I2(seg_mav2[20]),
        .I3(\win_mav[23]_i_20_n_0 ),
        .I4(seg_mav_reg[20]),
        .O(\win_mav[23]_i_15_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT5 #(
    .INIT(32'hDFD54540)) 
    \win_mav[23]_i_16 
       (.I0(\win_mav[23]_i_22_n_0 ),
        .I1(seg_mav2[18]),
        .I2(sample_in[23]),
        .I3(sample_in[18]),
        .I4(seg_mav_reg[18]),
        .O(\win_mav[23]_i_16_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT5 #(
    .INIT(32'h1DE2E21D)) 
    \win_mav[23]_i_17 
       (.I0(sample_in[19]),
        .I1(sample_in[23]),
        .I2(seg_mav2[19]),
        .I3(\win_mav[23]_i_21_n_0 ),
        .I4(seg_mav_reg[19]),
        .O(\win_mav[23]_i_17_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair46" *) 
  LUT4 #(
    .INIT(16'h7887)) 
    \win_mav[23]_i_18 
       (.I0(seg_mav2[23]),
        .I1(sample_in[23]),
        .I2(\win_mav[27]_i_16_n_0 ),
        .I3(seg_mav_reg[23]),
        .O(\win_mav[23]_i_18_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_mav[23]_i_19 
       (.I0(\ring_mav_reg[2] [21]),
        .I1(\ring_mav_reg[3] [21]),
        .I2(\ring_mav_reg[0] [21]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_mav_reg[1] [21]),
        .O(\win_mav[23]_i_19_n_0 ));
  (* HLUTNM = "lutpair20" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \win_mav[23]_i_2 
       (.I0(\win_mav[23]_i_10_n_0 ),
        .I1(\win_mav_reg_n_0_[22] ),
        .I2(\win_mav[23]_i_11_n_0 ),
        .O(\win_mav[23]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_mav[23]_i_20 
       (.I0(\ring_mav_reg[2] [20]),
        .I1(\ring_mav_reg[3] [20]),
        .I2(\ring_mav_reg[0] [20]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_mav_reg[1] [20]),
        .O(\win_mav[23]_i_20_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_mav[23]_i_21 
       (.I0(\ring_mav_reg[2] [19]),
        .I1(\ring_mav_reg[3] [19]),
        .I2(\ring_mav_reg[0] [19]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_mav_reg[1] [19]),
        .O(\win_mav[23]_i_21_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_mav[23]_i_22 
       (.I0(\ring_mav_reg[2] [18]),
        .I1(\ring_mav_reg[3] [18]),
        .I2(\ring_mav_reg[0] [18]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_mav_reg[1] [18]),
        .O(\win_mav[23]_i_22_n_0 ));
  (* HLUTNM = "lutpair19" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \win_mav[23]_i_3 
       (.I0(\win_mav[23]_i_12_n_0 ),
        .I1(\win_mav_reg_n_0_[21] ),
        .I2(\win_mav[23]_i_13_n_0 ),
        .O(\win_mav[23]_i_3_n_0 ));
  (* HLUTNM = "lutpair18" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \win_mav[23]_i_4 
       (.I0(\win_mav[23]_i_14_n_0 ),
        .I1(\win_mav_reg_n_0_[20] ),
        .I2(\win_mav[23]_i_15_n_0 ),
        .O(\win_mav[23]_i_4_n_0 ));
  (* HLUTNM = "lutpair17" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \win_mav[23]_i_5 
       (.I0(\win_mav[23]_i_16_n_0 ),
        .I1(\win_mav_reg_n_0_[19] ),
        .I2(\win_mav[23]_i_17_n_0 ),
        .O(\win_mav[23]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'h6996)) 
    \win_mav[23]_i_6 
       (.I0(\win_mav[23]_i_2_n_0 ),
        .I1(\win_mav[23]_i_18_n_0 ),
        .I2(\win_mav_reg_n_0_[23] ),
        .I3(\win_mav[27]_i_15_n_0 ),
        .O(\win_mav[23]_i_6_n_0 ));
  (* HLUTNM = "lutpair20" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \win_mav[23]_i_7 
       (.I0(\win_mav[23]_i_10_n_0 ),
        .I1(\win_mav_reg_n_0_[22] ),
        .I2(\win_mav[23]_i_11_n_0 ),
        .I3(\win_mav[23]_i_3_n_0 ),
        .O(\win_mav[23]_i_7_n_0 ));
  (* HLUTNM = "lutpair19" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \win_mav[23]_i_8 
       (.I0(\win_mav[23]_i_12_n_0 ),
        .I1(\win_mav_reg_n_0_[21] ),
        .I2(\win_mav[23]_i_13_n_0 ),
        .I3(\win_mav[23]_i_4_n_0 ),
        .O(\win_mav[23]_i_8_n_0 ));
  (* HLUTNM = "lutpair18" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \win_mav[23]_i_9 
       (.I0(\win_mav[23]_i_14_n_0 ),
        .I1(\win_mav_reg_n_0_[20] ),
        .I2(\win_mav[23]_i_15_n_0 ),
        .I3(\win_mav[23]_i_5_n_0 ),
        .O(\win_mav[23]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_mav[27]_i_10 
       (.I0(\ring_mav_reg[2] [24]),
        .I1(\ring_mav_reg[3] [24]),
        .I2(\ring_mav_reg[0] [24]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_mav_reg[1] [24]),
        .O(\win_mav[27]_i_10_n_0 ));
  LUT5 #(
    .INIT(32'h96669696)) 
    \win_mav[27]_i_11 
       (.I0(\win_mav[27]_i_19_n_0 ),
        .I1(\win_mav_reg_n_0_[25] ),
        .I2(\win_mav_reg_n_0_[24] ),
        .I3(\ring_mav_reg[3][27]_i_3_n_0 ),
        .I4(sample_in[23]),
        .O(\win_mav[27]_i_11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT5 #(
    .INIT(32'h2DD2D22D)) 
    \win_mav[27]_i_12 
       (.I0(\win_mav[31]_i_30_n_0 ),
        .I1(seg_mav_reg[25]),
        .I2(\win_mav_reg_n_0_[26] ),
        .I3(seg_mav_reg[26]),
        .I4(\win_mav[31]_i_20_n_0 ),
        .O(\win_mav[27]_i_12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair46" *) 
  LUT4 #(
    .INIT(16'hD540)) 
    \win_mav[27]_i_13 
       (.I0(\win_mav[27]_i_16_n_0 ),
        .I1(sample_in[23]),
        .I2(seg_mav2[23]),
        .I3(seg_mav_reg[23]),
        .O(\win_mav[27]_i_13_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \win_mav[27]_i_14 
       (.I0(seg_mav_reg[24]),
        .I1(\win_mav[27]_i_10_n_0 ),
        .O(\win_mav[27]_i_14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT5 #(
    .INIT(32'hDFD54540)) 
    \win_mav[27]_i_15 
       (.I0(\win_mav[27]_i_20_n_0 ),
        .I1(seg_mav2[22]),
        .I2(sample_in[23]),
        .I3(sample_in[22]),
        .I4(seg_mav_reg[22]),
        .O(\win_mav[27]_i_15_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_mav[27]_i_16 
       (.I0(\ring_mav_reg[2] [23]),
        .I1(\ring_mav_reg[3] [23]),
        .I2(\ring_mav_reg[0] [23]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_mav_reg[1] [23]),
        .O(\win_mav[27]_i_16_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT5 #(
    .INIT(32'h2DD2D22D)) 
    \win_mav[27]_i_17 
       (.I0(\win_mav[31]_i_20_n_0 ),
        .I1(seg_mav_reg[26]),
        .I2(\win_mav_reg_n_0_[27] ),
        .I3(seg_mav_reg[27]),
        .I4(\win_mav[31]_i_17_n_0 ),
        .O(\win_mav[27]_i_17_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT5 #(
    .INIT(32'hD0FDFDD0)) 
    \win_mav[27]_i_18 
       (.I0(\win_mav[31]_i_30_n_0 ),
        .I1(seg_mav_reg[25]),
        .I2(\win_mav_reg_n_0_[26] ),
        .I3(seg_mav_reg[26]),
        .I4(\win_mav[31]_i_20_n_0 ),
        .O(\win_mav[27]_i_18_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair133" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \win_mav[27]_i_19 
       (.I0(seg_mav_reg[25]),
        .I1(\win_mav[31]_i_30_n_0 ),
        .O(\win_mav[27]_i_19_n_0 ));
  LUT4 #(
    .INIT(16'hB000)) 
    \win_mav[27]_i_2 
       (.I0(seg_mav_reg[24]),
        .I1(\win_mav[27]_i_10_n_0 ),
        .I2(\win_mav[27]_i_11_n_0 ),
        .I3(\win_mav[27]_i_12_n_0 ),
        .O(\win_mav[27]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_mav[27]_i_20 
       (.I0(\ring_mav_reg[2] [22]),
        .I1(\ring_mav_reg[3] [22]),
        .I2(\ring_mav_reg[0] [22]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_mav_reg[1] [22]),
        .O(\win_mav[27]_i_20_n_0 ));
  LUT4 #(
    .INIT(16'h4FB0)) 
    \win_mav[27]_i_3 
       (.I0(seg_mav_reg[24]),
        .I1(\win_mav[27]_i_10_n_0 ),
        .I2(\win_mav[27]_i_11_n_0 ),
        .I3(\win_mav[27]_i_12_n_0 ),
        .O(\win_mav[27]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'hBEBB2822)) 
    \win_mav[27]_i_4 
       (.I0(\win_mav[27]_i_13_n_0 ),
        .I1(\win_mav_reg_n_0_[24] ),
        .I2(\ring_mav_reg[3][27]_i_3_n_0 ),
        .I3(sample_in[23]),
        .I4(\win_mav[27]_i_14_n_0 ),
        .O(\win_mav[27]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h8EEEE888E8888EEE)) 
    \win_mav[27]_i_5 
       (.I0(\win_mav[27]_i_15_n_0 ),
        .I1(\win_mav_reg_n_0_[23] ),
        .I2(seg_mav2[23]),
        .I3(sample_in[23]),
        .I4(\win_mav[27]_i_16_n_0 ),
        .I5(seg_mav_reg[23]),
        .O(\win_mav[27]_i_5_n_0 ));
  LUT3 #(
    .INIT(8'h96)) 
    \win_mav[27]_i_6 
       (.I0(\win_mav[27]_i_2_n_0 ),
        .I1(\win_mav[27]_i_17_n_0 ),
        .I2(\win_mav[27]_i_18_n_0 ),
        .O(\win_mav[27]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h555559AA59AAAAAA)) 
    \win_mav[27]_i_7 
       (.I0(\win_mav[27]_i_3_n_0 ),
        .I1(sample_in[23]),
        .I2(\ring_mav_reg[3][27]_i_3_n_0 ),
        .I3(\win_mav_reg_n_0_[24] ),
        .I4(\win_mav_reg_n_0_[25] ),
        .I5(\win_mav[27]_i_19_n_0 ),
        .O(\win_mav[27]_i_7_n_0 ));
  LUT4 #(
    .INIT(16'hB44B)) 
    \win_mav[27]_i_8 
       (.I0(seg_mav_reg[24]),
        .I1(\win_mav[27]_i_10_n_0 ),
        .I2(\win_mav[27]_i_4_n_0 ),
        .I3(\win_mav[27]_i_11_n_0 ),
        .O(\win_mav[27]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'h9969669666969969)) 
    \win_mav[27]_i_9 
       (.I0(\win_mav[27]_i_5_n_0 ),
        .I1(\win_mav[27]_i_14_n_0 ),
        .I2(sample_in[23]),
        .I3(\ring_mav_reg[3][27]_i_3_n_0 ),
        .I4(\win_mav_reg_n_0_[24] ),
        .I5(\win_mav[27]_i_13_n_0 ),
        .O(\win_mav[27]_i_9_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \win_mav[31]_i_10 
       (.I0(seg_mav_reg[30]),
        .I1(\win_mav[35]_i_8_n_0 ),
        .O(\win_mav[31]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_mav[31]_i_11 
       (.I0(\ring_mav_reg[2] [29]),
        .I1(\ring_mav_reg[3] [29]),
        .I2(\ring_mav_reg[0] [29]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_mav_reg[1] [29]),
        .O(\win_mav[31]_i_11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair131" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \win_mav[31]_i_12 
       (.I0(seg_mav_reg[28]),
        .I1(\win_mav[31]_i_14_n_0 ),
        .O(\win_mav[31]_i_12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair130" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \win_mav[31]_i_13 
       (.I0(seg_mav_reg[29]),
        .I1(\win_mav[31]_i_11_n_0 ),
        .O(\win_mav[31]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_mav[31]_i_14 
       (.I0(\ring_mav_reg[2] [28]),
        .I1(\ring_mav_reg[3] [28]),
        .I2(\ring_mav_reg[0] [28]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_mav_reg[1] [28]),
        .O(\win_mav[31]_i_14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair132" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \win_mav[31]_i_15 
       (.I0(seg_mav_reg[27]),
        .I1(\win_mav[31]_i_17_n_0 ),
        .O(\win_mav[31]_i_15_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair131" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \win_mav[31]_i_16 
       (.I0(seg_mav_reg[28]),
        .I1(\win_mav[31]_i_14_n_0 ),
        .O(\win_mav[31]_i_16_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_mav[31]_i_17 
       (.I0(\ring_mav_reg[2] [27]),
        .I1(\ring_mav_reg[3] [27]),
        .I2(\ring_mav_reg[0] [27]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_mav_reg[1] [27]),
        .O(\win_mav[31]_i_17_n_0 ));
  LUT2 #(
    .INIT(4'hB)) 
    \win_mav[31]_i_18 
       (.I0(seg_mav_reg[26]),
        .I1(\win_mav[31]_i_20_n_0 ),
        .O(\win_mav[31]_i_18_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair132" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \win_mav[31]_i_19 
       (.I0(seg_mav_reg[27]),
        .I1(\win_mav[31]_i_17_n_0 ),
        .O(\win_mav[31]_i_19_n_0 ));
  LUT6 #(
    .INIT(64'h9969096009600000)) 
    \win_mav[31]_i_2 
       (.I0(\win_mav[31]_i_10_n_0 ),
        .I1(\win_mav_reg_n_0_[30] ),
        .I2(\win_mav[31]_i_11_n_0 ),
        .I3(seg_mav_reg[29]),
        .I4(\win_mav_reg_n_0_[29] ),
        .I5(\win_mav[31]_i_12_n_0 ),
        .O(\win_mav[31]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_mav[31]_i_20 
       (.I0(\ring_mav_reg[2] [26]),
        .I1(\ring_mav_reg[3] [26]),
        .I2(\ring_mav_reg[0] [26]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_mav_reg[1] [26]),
        .O(\win_mav[31]_i_20_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair133" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \win_mav[31]_i_21 
       (.I0(seg_mav_reg[25]),
        .I1(\win_mav[31]_i_30_n_0 ),
        .O(\win_mav[31]_i_21_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT5 #(
    .INIT(32'h2DD2D22D)) 
    \win_mav[31]_i_22 
       (.I0(\win_mav[35]_i_8_n_0 ),
        .I1(seg_mav_reg[30]),
        .I2(\win_mav_reg_n_0_[31] ),
        .I3(seg_mav_reg[31]),
        .I4(\win_mav[35]_i_9_n_0 ),
        .O(\win_mav[31]_i_22_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT5 #(
    .INIT(32'hD0FDFDD0)) 
    \win_mav[31]_i_23 
       (.I0(\win_mav[31]_i_11_n_0 ),
        .I1(seg_mav_reg[29]),
        .I2(\win_mav_reg_n_0_[30] ),
        .I3(seg_mav_reg[30]),
        .I4(\win_mav[35]_i_8_n_0 ),
        .O(\win_mav[31]_i_23_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT5 #(
    .INIT(32'h2DD2D22D)) 
    \win_mav[31]_i_24 
       (.I0(\win_mav[31]_i_11_n_0 ),
        .I1(seg_mav_reg[29]),
        .I2(\win_mav_reg_n_0_[30] ),
        .I3(seg_mav_reg[30]),
        .I4(\win_mav[35]_i_8_n_0 ),
        .O(\win_mav[31]_i_24_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT5 #(
    .INIT(32'hD0FDFDD0)) 
    \win_mav[31]_i_25 
       (.I0(\win_mav[31]_i_14_n_0 ),
        .I1(seg_mav_reg[28]),
        .I2(\win_mav_reg_n_0_[29] ),
        .I3(seg_mav_reg[29]),
        .I4(\win_mav[31]_i_11_n_0 ),
        .O(\win_mav[31]_i_25_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT5 #(
    .INIT(32'h2DD2D22D)) 
    \win_mav[31]_i_26 
       (.I0(\win_mav[31]_i_14_n_0 ),
        .I1(seg_mav_reg[28]),
        .I2(\win_mav_reg_n_0_[29] ),
        .I3(seg_mav_reg[29]),
        .I4(\win_mav[31]_i_11_n_0 ),
        .O(\win_mav[31]_i_26_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT5 #(
    .INIT(32'hD0FDFDD0)) 
    \win_mav[31]_i_27 
       (.I0(\win_mav[31]_i_17_n_0 ),
        .I1(seg_mav_reg[27]),
        .I2(\win_mav_reg_n_0_[28] ),
        .I3(seg_mav_reg[28]),
        .I4(\win_mav[31]_i_14_n_0 ),
        .O(\win_mav[31]_i_27_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT5 #(
    .INIT(32'h2DD2D22D)) 
    \win_mav[31]_i_28 
       (.I0(\win_mav[31]_i_17_n_0 ),
        .I1(seg_mav_reg[27]),
        .I2(\win_mav_reg_n_0_[28] ),
        .I3(seg_mav_reg[28]),
        .I4(\win_mav[31]_i_14_n_0 ),
        .O(\win_mav[31]_i_28_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT5 #(
    .INIT(32'hD0FDFDD0)) 
    \win_mav[31]_i_29 
       (.I0(\win_mav[31]_i_20_n_0 ),
        .I1(seg_mav_reg[26]),
        .I2(\win_mav_reg_n_0_[27] ),
        .I3(seg_mav_reg[27]),
        .I4(\win_mav[31]_i_17_n_0 ),
        .O(\win_mav[31]_i_29_n_0 ));
  LUT6 #(
    .INIT(64'h9969096009600000)) 
    \win_mav[31]_i_3 
       (.I0(\win_mav[31]_i_13_n_0 ),
        .I1(\win_mav_reg_n_0_[29] ),
        .I2(\win_mav[31]_i_14_n_0 ),
        .I3(seg_mav_reg[28]),
        .I4(\win_mav_reg_n_0_[28] ),
        .I5(\win_mav[31]_i_15_n_0 ),
        .O(\win_mav[31]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_mav[31]_i_30 
       (.I0(\ring_mav_reg[2] [25]),
        .I1(\ring_mav_reg[3] [25]),
        .I2(\ring_mav_reg[0] [25]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_mav_reg[1] [25]),
        .O(\win_mav[31]_i_30_n_0 ));
  LUT6 #(
    .INIT(64'h9969096009600000)) 
    \win_mav[31]_i_4 
       (.I0(\win_mav[31]_i_16_n_0 ),
        .I1(\win_mav_reg_n_0_[28] ),
        .I2(\win_mav[31]_i_17_n_0 ),
        .I3(seg_mav_reg[27]),
        .I4(\win_mav_reg_n_0_[27] ),
        .I5(\win_mav[31]_i_18_n_0 ),
        .O(\win_mav[31]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h9969096009600000)) 
    \win_mav[31]_i_5 
       (.I0(\win_mav[31]_i_19_n_0 ),
        .I1(\win_mav_reg_n_0_[27] ),
        .I2(\win_mav[31]_i_20_n_0 ),
        .I3(seg_mav_reg[26]),
        .I4(\win_mav_reg_n_0_[26] ),
        .I5(\win_mav[31]_i_21_n_0 ),
        .O(\win_mav[31]_i_5_n_0 ));
  LUT3 #(
    .INIT(8'h96)) 
    \win_mav[31]_i_6 
       (.I0(\win_mav[31]_i_2_n_0 ),
        .I1(\win_mav[31]_i_22_n_0 ),
        .I2(\win_mav[31]_i_23_n_0 ),
        .O(\win_mav[31]_i_6_n_0 ));
  LUT3 #(
    .INIT(8'h96)) 
    \win_mav[31]_i_7 
       (.I0(\win_mav[31]_i_3_n_0 ),
        .I1(\win_mav[31]_i_24_n_0 ),
        .I2(\win_mav[31]_i_25_n_0 ),
        .O(\win_mav[31]_i_7_n_0 ));
  LUT3 #(
    .INIT(8'h96)) 
    \win_mav[31]_i_8 
       (.I0(\win_mav[31]_i_4_n_0 ),
        .I1(\win_mav[31]_i_26_n_0 ),
        .I2(\win_mav[31]_i_27_n_0 ),
        .O(\win_mav[31]_i_8_n_0 ));
  LUT3 #(
    .INIT(8'h96)) 
    \win_mav[31]_i_9 
       (.I0(\win_mav[31]_i_5_n_0 ),
        .I1(\win_mav[31]_i_28_n_0 ),
        .I2(\win_mav[31]_i_29_n_0 ),
        .O(\win_mav[31]_i_9_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \win_mav[35]_i_10 
       (.I0(seg_mav_reg[31]),
        .I1(\win_mav[35]_i_9_n_0 ),
        .O(\win_mav[35]_i_10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair130" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \win_mav[35]_i_11 
       (.I0(seg_mav_reg[29]),
        .I1(\win_mav[31]_i_11_n_0 ),
        .O(\win_mav[35]_i_11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \win_mav[35]_i_12 
       (.I0(seg_mav_reg[30]),
        .I1(\win_mav[35]_i_8_n_0 ),
        .O(\win_mav[35]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hFF8AEF00FFEFFF8A)) 
    \win_mav[35]_i_2 
       (.I0(\win_mav_reg_n_0_[31] ),
        .I1(seg_mav_reg[30]),
        .I2(\win_mav[35]_i_8_n_0 ),
        .I3(\win_mav_reg_n_0_[32] ),
        .I4(seg_mav_reg[31]),
        .I5(\win_mav[35]_i_9_n_0 ),
        .O(\win_mav[35]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h9969096009600000)) 
    \win_mav[35]_i_3 
       (.I0(\win_mav[35]_i_10_n_0 ),
        .I1(\win_mav_reg_n_0_[31] ),
        .I2(\win_mav[35]_i_8_n_0 ),
        .I3(seg_mav_reg[30]),
        .I4(\win_mav_reg_n_0_[30] ),
        .I5(\win_mav[35]_i_11_n_0 ),
        .O(\win_mav[35]_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \win_mav[35]_i_4 
       (.I0(\win_mav_reg_n_0_[34] ),
        .I1(\win_mav_reg_n_0_[35] ),
        .O(\win_mav[35]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \win_mav[35]_i_5 
       (.I0(\win_mav_reg_n_0_[33] ),
        .I1(\win_mav_reg_n_0_[34] ),
        .O(\win_mav[35]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \win_mav[35]_i_6 
       (.I0(\win_mav[35]_i_2_n_0 ),
        .I1(\win_mav_reg_n_0_[33] ),
        .O(\win_mav[35]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h59A69A659A65A659)) 
    \win_mav[35]_i_7 
       (.I0(\win_mav[35]_i_3_n_0 ),
        .I1(\win_mav[35]_i_9_n_0 ),
        .I2(seg_mav_reg[31]),
        .I3(\win_mav_reg_n_0_[32] ),
        .I4(\win_mav[35]_i_12_n_0 ),
        .I5(\win_mav_reg_n_0_[31] ),
        .O(\win_mav[35]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_mav[35]_i_8 
       (.I0(\ring_mav_reg[2] [30]),
        .I1(\ring_mav_reg[3] [30]),
        .I2(\ring_mav_reg[0] [30]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_mav_reg[1] [30]),
        .O(\win_mav[35]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_mav[35]_i_9 
       (.I0(\ring_mav_reg[2] [31]),
        .I1(\ring_mav_reg[3] [31]),
        .I2(\ring_mav_reg[0] [31]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_mav_reg[1] [31]),
        .O(\win_mav[35]_i_9_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \win_mav[39]_i_2 
       (.I0(\win_mav_reg_n_0_[38] ),
        .I1(\win_mav_reg_n_0_[39] ),
        .O(\win_mav[39]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \win_mav[39]_i_3 
       (.I0(\win_mav_reg_n_0_[37] ),
        .I1(\win_mav_reg_n_0_[38] ),
        .O(\win_mav[39]_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \win_mav[39]_i_4 
       (.I0(\win_mav_reg_n_0_[36] ),
        .I1(\win_mav_reg_n_0_[37] ),
        .O(\win_mav[39]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \win_mav[39]_i_5 
       (.I0(\win_mav_reg_n_0_[35] ),
        .I1(\win_mav_reg_n_0_[36] ),
        .O(\win_mav[39]_i_5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT5 #(
    .INIT(32'hDFD54540)) 
    \win_mav[3]_i_10 
       (.I0(\win_mav[3]_i_14_n_0 ),
        .I1(seg_mav2[1]),
        .I2(sample_in[23]),
        .I3(sample_in[1]),
        .I4(seg_mav_reg[1]),
        .O(\win_mav[3]_i_10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT5 #(
    .INIT(32'h1DE2E21D)) 
    \win_mav[3]_i_11 
       (.I0(sample_in[2]),
        .I1(sample_in[23]),
        .I2(seg_mav2[2]),
        .I3(\win_mav[7]_i_21_n_0 ),
        .I4(seg_mav_reg[2]),
        .O(\win_mav[3]_i_11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT5 #(
    .INIT(32'h1DE2E21D)) 
    \win_mav[3]_i_12 
       (.I0(sample_in[1]),
        .I1(sample_in[23]),
        .I2(seg_mav2[1]),
        .I3(\win_mav[3]_i_14_n_0 ),
        .I4(seg_mav_reg[1]),
        .O(\win_mav[3]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_mav[3]_i_13 
       (.I0(\ring_mav_reg[2] [0]),
        .I1(\ring_mav_reg[3] [0]),
        .I2(\ring_mav_reg[0] [0]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_mav_reg[1] [0]),
        .O(\win_mav[3]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_mav[3]_i_14 
       (.I0(\ring_mav_reg[2] [1]),
        .I1(\ring_mav_reg[3] [1]),
        .I2(\ring_mav_reg[0] [1]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_mav_reg[1] [1]),
        .O(\win_mav[3]_i_14_n_0 ));
  (* HLUTNM = "lutpair0" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \win_mav[3]_i_2 
       (.I0(\win_mav[3]_i_10_n_0 ),
        .I1(\win_mav_reg_n_0_[2] ),
        .I2(\win_mav[3]_i_11_n_0 ),
        .O(\win_mav[3]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'hE888)) 
    \win_mav[3]_i_3 
       (.I0(\win_mav[3]_i_12_n_0 ),
        .I1(\win_mav_reg_n_0_[1] ),
        .I2(sample_in[0]),
        .I3(\win_mav_reg_n_0_[0] ),
        .O(\win_mav[3]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h9666)) 
    \win_mav[3]_i_4 
       (.I0(\win_mav[3]_i_12_n_0 ),
        .I1(\win_mav_reg_n_0_[1] ),
        .I2(sample_in[0]),
        .I3(\win_mav_reg_n_0_[0] ),
        .O(\win_mav[3]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \win_mav[3]_i_5 
       (.I0(seg_mav_reg[0]),
        .I1(\win_mav[3]_i_13_n_0 ),
        .O(\win_mav[3]_i_5_n_0 ));
  (* HLUTNM = "lutpair1" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \win_mav[3]_i_6 
       (.I0(\win_mav[7]_i_16_n_0 ),
        .I1(\win_mav_reg_n_0_[3] ),
        .I2(\win_mav[7]_i_17_n_0 ),
        .I3(\win_mav[3]_i_2_n_0 ),
        .O(\win_mav[3]_i_6_n_0 ));
  (* HLUTNM = "lutpair0" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \win_mav[3]_i_7 
       (.I0(\win_mav[3]_i_10_n_0 ),
        .I1(\win_mav_reg_n_0_[2] ),
        .I2(\win_mav[3]_i_11_n_0 ),
        .I3(\win_mav[3]_i_3_n_0 ),
        .O(\win_mav[3]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h7887788787787887)) 
    \win_mav[3]_i_8 
       (.I0(\win_mav_reg_n_0_[0] ),
        .I1(sample_in[0]),
        .I2(\win_mav_reg_n_0_[1] ),
        .I3(\win_mav[3]_i_12_n_0 ),
        .I4(\win_mav[3]_i_13_n_0 ),
        .I5(seg_mav_reg[0]),
        .O(\win_mav[3]_i_8_n_0 ));
  LUT4 #(
    .INIT(16'h6996)) 
    \win_mav[3]_i_9 
       (.I0(\win_mav[3]_i_13_n_0 ),
        .I1(seg_mav_reg[0]),
        .I2(sample_in[0]),
        .I3(\win_mav_reg_n_0_[0] ),
        .O(\win_mav[3]_i_9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT5 #(
    .INIT(32'hDFD54540)) 
    \win_mav[7]_i_10 
       (.I0(\win_mav[7]_i_18_n_0 ),
        .I1(seg_mav2[5]),
        .I2(sample_in[23]),
        .I3(sample_in[5]),
        .I4(seg_mav_reg[5]),
        .O(\win_mav[7]_i_10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT5 #(
    .INIT(32'h1DE2E21D)) 
    \win_mav[7]_i_11 
       (.I0(sample_in[6]),
        .I1(sample_in[23]),
        .I2(seg_mav2[6]),
        .I3(\win_mav[11]_i_21_n_0 ),
        .I4(seg_mav_reg[6]),
        .O(\win_mav[7]_i_11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT5 #(
    .INIT(32'hDFD54540)) 
    \win_mav[7]_i_12 
       (.I0(\win_mav[7]_i_19_n_0 ),
        .I1(seg_mav2[4]),
        .I2(sample_in[23]),
        .I3(sample_in[4]),
        .I4(seg_mav_reg[4]),
        .O(\win_mav[7]_i_12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT5 #(
    .INIT(32'h1DE2E21D)) 
    \win_mav[7]_i_13 
       (.I0(sample_in[5]),
        .I1(sample_in[23]),
        .I2(seg_mav2[5]),
        .I3(\win_mav[7]_i_18_n_0 ),
        .I4(seg_mav_reg[5]),
        .O(\win_mav[7]_i_13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT5 #(
    .INIT(32'hDFD54540)) 
    \win_mav[7]_i_14 
       (.I0(\win_mav[7]_i_20_n_0 ),
        .I1(seg_mav2[3]),
        .I2(sample_in[23]),
        .I3(sample_in[3]),
        .I4(seg_mav_reg[3]),
        .O(\win_mav[7]_i_14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT5 #(
    .INIT(32'h1DE2E21D)) 
    \win_mav[7]_i_15 
       (.I0(sample_in[4]),
        .I1(sample_in[23]),
        .I2(seg_mav2[4]),
        .I3(\win_mav[7]_i_19_n_0 ),
        .I4(seg_mav_reg[4]),
        .O(\win_mav[7]_i_15_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT5 #(
    .INIT(32'hDFD54540)) 
    \win_mav[7]_i_16 
       (.I0(\win_mav[7]_i_21_n_0 ),
        .I1(seg_mav2[2]),
        .I2(sample_in[23]),
        .I3(sample_in[2]),
        .I4(seg_mav_reg[2]),
        .O(\win_mav[7]_i_16_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT5 #(
    .INIT(32'h1DE2E21D)) 
    \win_mav[7]_i_17 
       (.I0(sample_in[3]),
        .I1(sample_in[23]),
        .I2(seg_mav2[3]),
        .I3(\win_mav[7]_i_20_n_0 ),
        .I4(seg_mav_reg[3]),
        .O(\win_mav[7]_i_17_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_mav[7]_i_18 
       (.I0(\ring_mav_reg[2] [5]),
        .I1(\ring_mav_reg[3] [5]),
        .I2(\ring_mav_reg[0] [5]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_mav_reg[1] [5]),
        .O(\win_mav[7]_i_18_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_mav[7]_i_19 
       (.I0(\ring_mav_reg[2] [4]),
        .I1(\ring_mav_reg[3] [4]),
        .I2(\ring_mav_reg[0] [4]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_mav_reg[1] [4]),
        .O(\win_mav[7]_i_19_n_0 ));
  (* HLUTNM = "lutpair4" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \win_mav[7]_i_2 
       (.I0(\win_mav[7]_i_10_n_0 ),
        .I1(\win_mav_reg_n_0_[6] ),
        .I2(\win_mav[7]_i_11_n_0 ),
        .O(\win_mav[7]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_mav[7]_i_20 
       (.I0(\ring_mav_reg[2] [3]),
        .I1(\ring_mav_reg[3] [3]),
        .I2(\ring_mav_reg[0] [3]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_mav_reg[1] [3]),
        .O(\win_mav[7]_i_20_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_mav[7]_i_21 
       (.I0(\ring_mav_reg[2] [2]),
        .I1(\ring_mav_reg[3] [2]),
        .I2(\ring_mav_reg[0] [2]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_mav_reg[1] [2]),
        .O(\win_mav[7]_i_21_n_0 ));
  (* HLUTNM = "lutpair3" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \win_mav[7]_i_3 
       (.I0(\win_mav[7]_i_12_n_0 ),
        .I1(\win_mav_reg_n_0_[5] ),
        .I2(\win_mav[7]_i_13_n_0 ),
        .O(\win_mav[7]_i_3_n_0 ));
  (* HLUTNM = "lutpair2" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \win_mav[7]_i_4 
       (.I0(\win_mav[7]_i_14_n_0 ),
        .I1(\win_mav_reg_n_0_[4] ),
        .I2(\win_mav[7]_i_15_n_0 ),
        .O(\win_mav[7]_i_4_n_0 ));
  (* HLUTNM = "lutpair1" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \win_mav[7]_i_5 
       (.I0(\win_mav[7]_i_16_n_0 ),
        .I1(\win_mav_reg_n_0_[3] ),
        .I2(\win_mav[7]_i_17_n_0 ),
        .O(\win_mav[7]_i_5_n_0 ));
  (* HLUTNM = "lutpair5" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \win_mav[7]_i_6 
       (.I0(\win_mav[11]_i_16_n_0 ),
        .I1(\win_mav_reg_n_0_[7] ),
        .I2(\win_mav[11]_i_17_n_0 ),
        .I3(\win_mav[7]_i_2_n_0 ),
        .O(\win_mav[7]_i_6_n_0 ));
  (* HLUTNM = "lutpair4" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \win_mav[7]_i_7 
       (.I0(\win_mav[7]_i_10_n_0 ),
        .I1(\win_mav_reg_n_0_[6] ),
        .I2(\win_mav[7]_i_11_n_0 ),
        .I3(\win_mav[7]_i_3_n_0 ),
        .O(\win_mav[7]_i_7_n_0 ));
  (* HLUTNM = "lutpair3" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \win_mav[7]_i_8 
       (.I0(\win_mav[7]_i_12_n_0 ),
        .I1(\win_mav_reg_n_0_[5] ),
        .I2(\win_mav[7]_i_13_n_0 ),
        .I3(\win_mav[7]_i_4_n_0 ),
        .O(\win_mav[7]_i_8_n_0 ));
  (* HLUTNM = "lutpair2" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \win_mav[7]_i_9 
       (.I0(\win_mav[7]_i_14_n_0 ),
        .I1(\win_mav_reg_n_0_[4] ),
        .I2(\win_mav[7]_i_15_n_0 ),
        .I3(\win_mav[7]_i_5_n_0 ),
        .O(\win_mav[7]_i_9_n_0 ));
  FDRE \win_mav_reg[0] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[3]_i_1_n_7 ),
        .Q(\win_mav_reg_n_0_[0] ),
        .R(clear));
  FDRE \win_mav_reg[10] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[11]_i_1_n_5 ),
        .Q(\win_mav_reg_n_0_[10] ),
        .R(clear));
  FDRE \win_mav_reg[11] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[11]_i_1_n_4 ),
        .Q(\win_mav_reg_n_0_[11] ),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \win_mav_reg[11]_i_1 
       (.CI(\win_mav_reg[7]_i_1_n_0 ),
        .CO({\win_mav_reg[11]_i_1_n_0 ,\win_mav_reg[11]_i_1_n_1 ,\win_mav_reg[11]_i_1_n_2 ,\win_mav_reg[11]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\win_mav[11]_i_2_n_0 ,\win_mav[11]_i_3_n_0 ,\win_mav[11]_i_4_n_0 ,\win_mav[11]_i_5_n_0 }),
        .O({\win_mav_reg[11]_i_1_n_4 ,\win_mav_reg[11]_i_1_n_5 ,\win_mav_reg[11]_i_1_n_6 ,\win_mav_reg[11]_i_1_n_7 }),
        .S({\win_mav[11]_i_6_n_0 ,\win_mav[11]_i_7_n_0 ,\win_mav[11]_i_8_n_0 ,\win_mav[11]_i_9_n_0 }));
  FDRE \win_mav_reg[12] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[15]_i_1_n_7 ),
        .Q(\win_mav_reg_n_0_[12] ),
        .R(clear));
  FDRE \win_mav_reg[13] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[15]_i_1_n_6 ),
        .Q(\win_mav_reg_n_0_[13] ),
        .R(clear));
  FDRE \win_mav_reg[14] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[15]_i_1_n_5 ),
        .Q(\win_mav_reg_n_0_[14] ),
        .R(clear));
  FDRE \win_mav_reg[15] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[15]_i_1_n_4 ),
        .Q(\win_mav_reg_n_0_[15] ),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \win_mav_reg[15]_i_1 
       (.CI(\win_mav_reg[11]_i_1_n_0 ),
        .CO({\win_mav_reg[15]_i_1_n_0 ,\win_mav_reg[15]_i_1_n_1 ,\win_mav_reg[15]_i_1_n_2 ,\win_mav_reg[15]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\win_mav[15]_i_2_n_0 ,\win_mav[15]_i_3_n_0 ,\win_mav[15]_i_4_n_0 ,\win_mav[15]_i_5_n_0 }),
        .O({\win_mav_reg[15]_i_1_n_4 ,\win_mav_reg[15]_i_1_n_5 ,\win_mav_reg[15]_i_1_n_6 ,\win_mav_reg[15]_i_1_n_7 }),
        .S({\win_mav[15]_i_6_n_0 ,\win_mav[15]_i_7_n_0 ,\win_mav[15]_i_8_n_0 ,\win_mav[15]_i_9_n_0 }));
  FDRE \win_mav_reg[16] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[19]_i_1_n_7 ),
        .Q(\win_mav_reg_n_0_[16] ),
        .R(clear));
  FDRE \win_mav_reg[17] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[19]_i_1_n_6 ),
        .Q(\win_mav_reg_n_0_[17] ),
        .R(clear));
  FDRE \win_mav_reg[18] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[19]_i_1_n_5 ),
        .Q(\win_mav_reg_n_0_[18] ),
        .R(clear));
  FDRE \win_mav_reg[19] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[19]_i_1_n_4 ),
        .Q(\win_mav_reg_n_0_[19] ),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \win_mav_reg[19]_i_1 
       (.CI(\win_mav_reg[15]_i_1_n_0 ),
        .CO({\win_mav_reg[19]_i_1_n_0 ,\win_mav_reg[19]_i_1_n_1 ,\win_mav_reg[19]_i_1_n_2 ,\win_mav_reg[19]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\win_mav[19]_i_2_n_0 ,\win_mav[19]_i_3_n_0 ,\win_mav[19]_i_4_n_0 ,\win_mav[19]_i_5_n_0 }),
        .O({\win_mav_reg[19]_i_1_n_4 ,\win_mav_reg[19]_i_1_n_5 ,\win_mav_reg[19]_i_1_n_6 ,\win_mav_reg[19]_i_1_n_7 }),
        .S({\win_mav[19]_i_6_n_0 ,\win_mav[19]_i_7_n_0 ,\win_mav[19]_i_8_n_0 ,\win_mav[19]_i_9_n_0 }));
  FDRE \win_mav_reg[1] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[3]_i_1_n_6 ),
        .Q(\win_mav_reg_n_0_[1] ),
        .R(clear));
  FDRE \win_mav_reg[20] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[23]_i_1_n_7 ),
        .Q(\win_mav_reg_n_0_[20] ),
        .R(clear));
  FDRE \win_mav_reg[21] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[23]_i_1_n_6 ),
        .Q(\win_mav_reg_n_0_[21] ),
        .R(clear));
  FDRE \win_mav_reg[22] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[23]_i_1_n_5 ),
        .Q(\win_mav_reg_n_0_[22] ),
        .R(clear));
  FDRE \win_mav_reg[23] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[23]_i_1_n_4 ),
        .Q(\win_mav_reg_n_0_[23] ),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \win_mav_reg[23]_i_1 
       (.CI(\win_mav_reg[19]_i_1_n_0 ),
        .CO({\win_mav_reg[23]_i_1_n_0 ,\win_mav_reg[23]_i_1_n_1 ,\win_mav_reg[23]_i_1_n_2 ,\win_mav_reg[23]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\win_mav[23]_i_2_n_0 ,\win_mav[23]_i_3_n_0 ,\win_mav[23]_i_4_n_0 ,\win_mav[23]_i_5_n_0 }),
        .O({\win_mav_reg[23]_i_1_n_4 ,\win_mav_reg[23]_i_1_n_5 ,\win_mav_reg[23]_i_1_n_6 ,\win_mav_reg[23]_i_1_n_7 }),
        .S({\win_mav[23]_i_6_n_0 ,\win_mav[23]_i_7_n_0 ,\win_mav[23]_i_8_n_0 ,\win_mav[23]_i_9_n_0 }));
  FDRE \win_mav_reg[24] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[27]_i_1_n_7 ),
        .Q(\win_mav_reg_n_0_[24] ),
        .R(clear));
  FDRE \win_mav_reg[25] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[27]_i_1_n_6 ),
        .Q(\win_mav_reg_n_0_[25] ),
        .R(clear));
  FDRE \win_mav_reg[26] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[27]_i_1_n_5 ),
        .Q(\win_mav_reg_n_0_[26] ),
        .R(clear));
  FDRE \win_mav_reg[27] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[27]_i_1_n_4 ),
        .Q(\win_mav_reg_n_0_[27] ),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \win_mav_reg[27]_i_1 
       (.CI(\win_mav_reg[23]_i_1_n_0 ),
        .CO({\win_mav_reg[27]_i_1_n_0 ,\win_mav_reg[27]_i_1_n_1 ,\win_mav_reg[27]_i_1_n_2 ,\win_mav_reg[27]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\win_mav[27]_i_2_n_0 ,\win_mav[27]_i_3_n_0 ,\win_mav[27]_i_4_n_0 ,\win_mav[27]_i_5_n_0 }),
        .O({\win_mav_reg[27]_i_1_n_4 ,\win_mav_reg[27]_i_1_n_5 ,\win_mav_reg[27]_i_1_n_6 ,\win_mav_reg[27]_i_1_n_7 }),
        .S({\win_mav[27]_i_6_n_0 ,\win_mav[27]_i_7_n_0 ,\win_mav[27]_i_8_n_0 ,\win_mav[27]_i_9_n_0 }));
  FDRE \win_mav_reg[28] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[31]_i_1_n_7 ),
        .Q(\win_mav_reg_n_0_[28] ),
        .R(clear));
  FDRE \win_mav_reg[29] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[31]_i_1_n_6 ),
        .Q(\win_mav_reg_n_0_[29] ),
        .R(clear));
  FDRE \win_mav_reg[2] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[3]_i_1_n_5 ),
        .Q(\win_mav_reg_n_0_[2] ),
        .R(clear));
  FDRE \win_mav_reg[30] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[31]_i_1_n_5 ),
        .Q(\win_mav_reg_n_0_[30] ),
        .R(clear));
  FDRE \win_mav_reg[31] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[31]_i_1_n_4 ),
        .Q(\win_mav_reg_n_0_[31] ),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \win_mav_reg[31]_i_1 
       (.CI(\win_mav_reg[27]_i_1_n_0 ),
        .CO({\win_mav_reg[31]_i_1_n_0 ,\win_mav_reg[31]_i_1_n_1 ,\win_mav_reg[31]_i_1_n_2 ,\win_mav_reg[31]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\win_mav[31]_i_2_n_0 ,\win_mav[31]_i_3_n_0 ,\win_mav[31]_i_4_n_0 ,\win_mav[31]_i_5_n_0 }),
        .O({\win_mav_reg[31]_i_1_n_4 ,\win_mav_reg[31]_i_1_n_5 ,\win_mav_reg[31]_i_1_n_6 ,\win_mav_reg[31]_i_1_n_7 }),
        .S({\win_mav[31]_i_6_n_0 ,\win_mav[31]_i_7_n_0 ,\win_mav[31]_i_8_n_0 ,\win_mav[31]_i_9_n_0 }));
  FDRE \win_mav_reg[32] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[35]_i_1_n_7 ),
        .Q(\win_mav_reg_n_0_[32] ),
        .R(clear));
  FDRE \win_mav_reg[33] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[35]_i_1_n_6 ),
        .Q(\win_mav_reg_n_0_[33] ),
        .R(clear));
  FDRE \win_mav_reg[34] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[35]_i_1_n_5 ),
        .Q(\win_mav_reg_n_0_[34] ),
        .R(clear));
  FDRE \win_mav_reg[35] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[35]_i_1_n_4 ),
        .Q(\win_mav_reg_n_0_[35] ),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \win_mav_reg[35]_i_1 
       (.CI(\win_mav_reg[31]_i_1_n_0 ),
        .CO({\win_mav_reg[35]_i_1_n_0 ,\win_mav_reg[35]_i_1_n_1 ,\win_mav_reg[35]_i_1_n_2 ,\win_mav_reg[35]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\win_mav_reg_n_0_[34] ,\win_mav_reg_n_0_[33] ,\win_mav[35]_i_2_n_0 ,\win_mav[35]_i_3_n_0 }),
        .O({\win_mav_reg[35]_i_1_n_4 ,\win_mav_reg[35]_i_1_n_5 ,\win_mav_reg[35]_i_1_n_6 ,\win_mav_reg[35]_i_1_n_7 }),
        .S({\win_mav[35]_i_4_n_0 ,\win_mav[35]_i_5_n_0 ,\win_mav[35]_i_6_n_0 ,\win_mav[35]_i_7_n_0 }));
  FDRE \win_mav_reg[36] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[39]_i_1_n_7 ),
        .Q(\win_mav_reg_n_0_[36] ),
        .R(clear));
  FDRE \win_mav_reg[37] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[39]_i_1_n_6 ),
        .Q(\win_mav_reg_n_0_[37] ),
        .R(clear));
  FDRE \win_mav_reg[38] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[39]_i_1_n_5 ),
        .Q(\win_mav_reg_n_0_[38] ),
        .R(clear));
  FDRE \win_mav_reg[39] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[39]_i_1_n_4 ),
        .Q(\win_mav_reg_n_0_[39] ),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \win_mav_reg[39]_i_1 
       (.CI(\win_mav_reg[35]_i_1_n_0 ),
        .CO({\NLW_win_mav_reg[39]_i_1_CO_UNCONNECTED [3],\win_mav_reg[39]_i_1_n_1 ,\win_mav_reg[39]_i_1_n_2 ,\win_mav_reg[39]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,\win_mav_reg_n_0_[37] ,\win_mav_reg_n_0_[36] ,\win_mav_reg_n_0_[35] }),
        .O({\win_mav_reg[39]_i_1_n_4 ,\win_mav_reg[39]_i_1_n_5 ,\win_mav_reg[39]_i_1_n_6 ,\win_mav_reg[39]_i_1_n_7 }),
        .S({\win_mav[39]_i_2_n_0 ,\win_mav[39]_i_3_n_0 ,\win_mav[39]_i_4_n_0 ,\win_mav[39]_i_5_n_0 }));
  FDRE \win_mav_reg[3] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[3]_i_1_n_4 ),
        .Q(\win_mav_reg_n_0_[3] ),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \win_mav_reg[3]_i_1 
       (.CI(1'b0),
        .CO({\win_mav_reg[3]_i_1_n_0 ,\win_mav_reg[3]_i_1_n_1 ,\win_mav_reg[3]_i_1_n_2 ,\win_mav_reg[3]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\win_mav[3]_i_2_n_0 ,\win_mav[3]_i_3_n_0 ,\win_mav[3]_i_4_n_0 ,\win_mav[3]_i_5_n_0 }),
        .O({\win_mav_reg[3]_i_1_n_4 ,\win_mav_reg[3]_i_1_n_5 ,\win_mav_reg[3]_i_1_n_6 ,\win_mav_reg[3]_i_1_n_7 }),
        .S({\win_mav[3]_i_6_n_0 ,\win_mav[3]_i_7_n_0 ,\win_mav[3]_i_8_n_0 ,\win_mav[3]_i_9_n_0 }));
  FDRE \win_mav_reg[4] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[7]_i_1_n_7 ),
        .Q(\win_mav_reg_n_0_[4] ),
        .R(clear));
  FDRE \win_mav_reg[5] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[7]_i_1_n_6 ),
        .Q(\win_mav_reg_n_0_[5] ),
        .R(clear));
  FDRE \win_mav_reg[6] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[7]_i_1_n_5 ),
        .Q(\win_mav_reg_n_0_[6] ),
        .R(clear));
  FDRE \win_mav_reg[7] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[7]_i_1_n_4 ),
        .Q(\win_mav_reg_n_0_[7] ),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \win_mav_reg[7]_i_1 
       (.CI(\win_mav_reg[3]_i_1_n_0 ),
        .CO({\win_mav_reg[7]_i_1_n_0 ,\win_mav_reg[7]_i_1_n_1 ,\win_mav_reg[7]_i_1_n_2 ,\win_mav_reg[7]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\win_mav[7]_i_2_n_0 ,\win_mav[7]_i_3_n_0 ,\win_mav[7]_i_4_n_0 ,\win_mav[7]_i_5_n_0 }),
        .O({\win_mav_reg[7]_i_1_n_4 ,\win_mav_reg[7]_i_1_n_5 ,\win_mav_reg[7]_i_1_n_6 ,\win_mav_reg[7]_i_1_n_7 }),
        .S({\win_mav[7]_i_6_n_0 ,\win_mav[7]_i_7_n_0 ,\win_mav[7]_i_8_n_0 ,\win_mav[7]_i_9_n_0 }));
  FDRE \win_mav_reg[8] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[11]_i_1_n_7 ),
        .Q(\win_mav_reg_n_0_[8] ),
        .R(clear));
  FDRE \win_mav_reg[9] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_mav_reg[11]_i_1_n_6 ),
        .Q(\win_mav_reg_n_0_[9] ),
        .R(clear));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_ssc[3]_i_10 
       (.I0(\ring_ssc_reg_n_0_[2][1] ),
        .I1(\ring_ssc_reg_n_0_[3][1] ),
        .I2(\ring_ssc_reg_n_0_[0][1] ),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_ssc_reg_n_0_[1][1] ),
        .O(ring_ssc[1]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_ssc[3]_i_11 
       (.I0(\ring_ssc_reg_n_0_[2][0] ),
        .I1(\ring_ssc_reg_n_0_[3][0] ),
        .I2(\ring_ssc_reg_n_0_[0][0] ),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_ssc_reg_n_0_[1][0] ),
        .O(ring_ssc[0]));
  LUT3 #(
    .INIT(8'h69)) 
    \win_ssc[3]_i_12 
       (.I0(win_ssc[3]),
        .I1(ring_ssc[3]),
        .I2(seg_ssc_reg[3]),
        .O(\win_ssc[3]_i_12_n_0 ));
  LUT3 #(
    .INIT(8'h69)) 
    \win_ssc[3]_i_13 
       (.I0(win_ssc[2]),
        .I1(ring_ssc[2]),
        .I2(seg_ssc_reg[2]),
        .O(\win_ssc[3]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'h6900000069696900)) 
    \win_ssc[3]_i_2 
       (.I0(seg_ssc_reg[2]),
        .I1(ring_ssc[2]),
        .I2(win_ssc[2]),
        .I3(seg_ssc_reg[1]),
        .I4(win_ssc[1]),
        .I5(ring_ssc[1]),
        .O(\win_ssc[3]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h08808008)) 
    \win_ssc[3]_i_3 
       (.I0(seg_ssc_reg[0]),
        .I1(win_ssc[0]),
        .I2(seg_ssc_reg[1]),
        .I3(ring_ssc[1]),
        .I4(win_ssc[1]),
        .O(\win_ssc[3]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'h96696969)) 
    \win_ssc[3]_i_4 
       (.I0(seg_ssc_reg[1]),
        .I1(ring_ssc[1]),
        .I2(win_ssc[1]),
        .I3(win_ssc[0]),
        .I4(seg_ssc_reg[0]),
        .O(\win_ssc[3]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \win_ssc[3]_i_5 
       (.I0(ssc_event),
        .I1(ring_ssc[0]),
        .O(\win_ssc[3]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'h99696966)) 
    \win_ssc[3]_i_6 
       (.I0(\win_ssc[3]_i_2_n_0 ),
        .I1(\win_ssc[3]_i_12_n_0 ),
        .I2(ring_ssc[2]),
        .I3(win_ssc[2]),
        .I4(seg_ssc_reg[2]),
        .O(\win_ssc[3]_i_6_n_0 ));
  LUT5 #(
    .INIT(32'h99696966)) 
    \win_ssc[3]_i_7 
       (.I0(\win_ssc[3]_i_3_n_0 ),
        .I1(\win_ssc[3]_i_13_n_0 ),
        .I2(ring_ssc[1]),
        .I3(win_ssc[1]),
        .I4(seg_ssc_reg[1]),
        .O(\win_ssc[3]_i_7_n_0 ));
  LUT3 #(
    .INIT(8'h59)) 
    \win_ssc[3]_i_8 
       (.I0(\win_ssc[3]_i_4_n_0 ),
        .I1(ring_ssc[0]),
        .I2(ssc_event),
        .O(\win_ssc[3]_i_8_n_0 ));
  LUT4 #(
    .INIT(16'h6996)) 
    \win_ssc[3]_i_9 
       (.I0(ring_ssc[0]),
        .I1(ssc_event),
        .I2(seg_ssc_reg[0]),
        .I3(win_ssc[0]),
        .O(\win_ssc[3]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_ssc[7]_i_10 
       (.I0(\ring_ssc_reg_n_0_[2][5] ),
        .I1(\ring_ssc_reg_n_0_[3][5] ),
        .I2(\ring_ssc_reg_n_0_[0][5] ),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_ssc_reg_n_0_[1][5] ),
        .O(ring_ssc[5]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_ssc[7]_i_11 
       (.I0(\ring_ssc_reg_n_0_[2][4] ),
        .I1(\ring_ssc_reg_n_0_[3][4] ),
        .I2(\ring_ssc_reg_n_0_[0][4] ),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_ssc_reg_n_0_[1][4] ),
        .O(ring_ssc[4]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_ssc[7]_i_12 
       (.I0(\ring_ssc_reg_n_0_[2][3] ),
        .I1(\ring_ssc_reg_n_0_[3][3] ),
        .I2(\ring_ssc_reg_n_0_[0][3] ),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_ssc_reg_n_0_[1][3] ),
        .O(ring_ssc[3]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_ssc[7]_i_13 
       (.I0(\ring_ssc_reg_n_0_[2][2] ),
        .I1(\ring_ssc_reg_n_0_[3][2] ),
        .I2(\ring_ssc_reg_n_0_[0][2] ),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_ssc_reg_n_0_[1][2] ),
        .O(ring_ssc[2]));
  (* SOFT_HLUTNM = "soft_lutpair118" *) 
  LUT3 #(
    .INIT(8'hD4)) 
    \win_ssc[7]_i_14 
       (.I0(ring_ssc[5]),
        .I1(win_ssc[5]),
        .I2(seg_ssc_reg[5]),
        .O(\win_ssc[7]_i_14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair117" *) 
  LUT3 #(
    .INIT(8'h69)) 
    \win_ssc[7]_i_15 
       (.I0(win_ssc[6]),
        .I1(ring_ssc[6]),
        .I2(seg_ssc_reg[6]),
        .O(\win_ssc[7]_i_15_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair118" *) 
  LUT3 #(
    .INIT(8'h69)) 
    \win_ssc[7]_i_16 
       (.I0(win_ssc[5]),
        .I1(ring_ssc[5]),
        .I2(seg_ssc_reg[5]),
        .O(\win_ssc[7]_i_16_n_0 ));
  LUT3 #(
    .INIT(8'h69)) 
    \win_ssc[7]_i_17 
       (.I0(win_ssc[4]),
        .I1(ring_ssc[4]),
        .I2(seg_ssc_reg[4]),
        .O(\win_ssc[7]_i_17_n_0 ));
  LUT6 #(
    .INIT(64'h6900000069696900)) 
    \win_ssc[7]_i_2 
       (.I0(seg_ssc_reg[6]),
        .I1(ring_ssc[6]),
        .I2(win_ssc[6]),
        .I3(seg_ssc_reg[5]),
        .I4(win_ssc[5]),
        .I5(ring_ssc[5]),
        .O(\win_ssc[7]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h6900000069696900)) 
    \win_ssc[7]_i_3 
       (.I0(seg_ssc_reg[5]),
        .I1(ring_ssc[5]),
        .I2(win_ssc[5]),
        .I3(seg_ssc_reg[4]),
        .I4(win_ssc[4]),
        .I5(ring_ssc[4]),
        .O(\win_ssc[7]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h6900000069696900)) 
    \win_ssc[7]_i_4 
       (.I0(seg_ssc_reg[4]),
        .I1(ring_ssc[4]),
        .I2(win_ssc[4]),
        .I3(seg_ssc_reg[3]),
        .I4(win_ssc[3]),
        .I5(ring_ssc[3]),
        .O(\win_ssc[7]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h6900000069696900)) 
    \win_ssc[7]_i_5 
       (.I0(seg_ssc_reg[3]),
        .I1(ring_ssc[3]),
        .I2(win_ssc[3]),
        .I3(seg_ssc_reg[2]),
        .I4(win_ssc[2]),
        .I5(ring_ssc[2]),
        .O(\win_ssc[7]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'hC69C9C39)) 
    \win_ssc[7]_i_6 
       (.I0(\win_ssc[7]_i_14_n_0 ),
        .I1(win_ssc[7]),
        .I2(ring_ssc[6]),
        .I3(win_ssc[6]),
        .I4(seg_ssc_reg[6]),
        .O(\win_ssc[7]_i_6_n_0 ));
  LUT5 #(
    .INIT(32'h99696966)) 
    \win_ssc[7]_i_7 
       (.I0(\win_ssc[7]_i_3_n_0 ),
        .I1(\win_ssc[7]_i_15_n_0 ),
        .I2(ring_ssc[5]),
        .I3(win_ssc[5]),
        .I4(seg_ssc_reg[5]),
        .O(\win_ssc[7]_i_7_n_0 ));
  LUT5 #(
    .INIT(32'h99696966)) 
    \win_ssc[7]_i_8 
       (.I0(\win_ssc[7]_i_4_n_0 ),
        .I1(\win_ssc[7]_i_16_n_0 ),
        .I2(ring_ssc[4]),
        .I3(win_ssc[4]),
        .I4(seg_ssc_reg[4]),
        .O(\win_ssc[7]_i_8_n_0 ));
  LUT5 #(
    .INIT(32'h99696966)) 
    \win_ssc[7]_i_9 
       (.I0(\win_ssc[7]_i_5_n_0 ),
        .I1(\win_ssc[7]_i_17_n_0 ),
        .I2(ring_ssc[3]),
        .I3(win_ssc[3]),
        .I4(seg_ssc_reg[3]),
        .O(\win_ssc[7]_i_9_n_0 ));
  LUT5 #(
    .INIT(32'hFBBA0445)) 
    \win_ssc[8]_i_2 
       (.I0(win_ssc[7]),
        .I1(ring_ssc[6]),
        .I2(win_ssc[6]),
        .I3(seg_ssc_reg[6]),
        .I4(win_ssc[8]),
        .O(\win_ssc[8]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_ssc[8]_i_3 
       (.I0(\ring_ssc_reg_n_0_[2][6] ),
        .I1(\ring_ssc_reg_n_0_[3][6] ),
        .I2(\ring_ssc_reg_n_0_[0][6] ),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_ssc_reg_n_0_[1][6] ),
        .O(ring_ssc[6]));
  FDRE \win_ssc_reg[0] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_ssc_reg[3]_i_1_n_7 ),
        .Q(win_ssc[0]),
        .R(clear));
  FDRE \win_ssc_reg[1] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_ssc_reg[3]_i_1_n_6 ),
        .Q(win_ssc[1]),
        .R(clear));
  FDRE \win_ssc_reg[2] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_ssc_reg[3]_i_1_n_5 ),
        .Q(win_ssc[2]),
        .R(clear));
  FDRE \win_ssc_reg[3] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_ssc_reg[3]_i_1_n_4 ),
        .Q(win_ssc[3]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \win_ssc_reg[3]_i_1 
       (.CI(1'b0),
        .CO({\win_ssc_reg[3]_i_1_n_0 ,\win_ssc_reg[3]_i_1_n_1 ,\win_ssc_reg[3]_i_1_n_2 ,\win_ssc_reg[3]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\win_ssc[3]_i_2_n_0 ,\win_ssc[3]_i_3_n_0 ,\win_ssc[3]_i_4_n_0 ,\win_ssc[3]_i_5_n_0 }),
        .O({\win_ssc_reg[3]_i_1_n_4 ,\win_ssc_reg[3]_i_1_n_5 ,\win_ssc_reg[3]_i_1_n_6 ,\win_ssc_reg[3]_i_1_n_7 }),
        .S({\win_ssc[3]_i_6_n_0 ,\win_ssc[3]_i_7_n_0 ,\win_ssc[3]_i_8_n_0 ,\win_ssc[3]_i_9_n_0 }));
  FDRE \win_ssc_reg[4] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_ssc_reg[7]_i_1_n_7 ),
        .Q(win_ssc[4]),
        .R(clear));
  FDRE \win_ssc_reg[5] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_ssc_reg[7]_i_1_n_6 ),
        .Q(win_ssc[5]),
        .R(clear));
  FDRE \win_ssc_reg[6] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_ssc_reg[7]_i_1_n_5 ),
        .Q(win_ssc[6]),
        .R(clear));
  FDRE \win_ssc_reg[7] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_ssc_reg[7]_i_1_n_4 ),
        .Q(win_ssc[7]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \win_ssc_reg[7]_i_1 
       (.CI(\win_ssc_reg[3]_i_1_n_0 ),
        .CO({\win_ssc_reg[7]_i_1_n_0 ,\win_ssc_reg[7]_i_1_n_1 ,\win_ssc_reg[7]_i_1_n_2 ,\win_ssc_reg[7]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\win_ssc[7]_i_2_n_0 ,\win_ssc[7]_i_3_n_0 ,\win_ssc[7]_i_4_n_0 ,\win_ssc[7]_i_5_n_0 }),
        .O({\win_ssc_reg[7]_i_1_n_4 ,\win_ssc_reg[7]_i_1_n_5 ,\win_ssc_reg[7]_i_1_n_6 ,\win_ssc_reg[7]_i_1_n_7 }),
        .S({\win_ssc[7]_i_6_n_0 ,\win_ssc[7]_i_7_n_0 ,\win_ssc[7]_i_8_n_0 ,\win_ssc[7]_i_9_n_0 }));
  FDRE \win_ssc_reg[8] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_ssc_reg[8]_i_1_n_7 ),
        .Q(win_ssc[8]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \win_ssc_reg[8]_i_1 
       (.CI(\win_ssc_reg[7]_i_1_n_0 ),
        .CO(\NLW_win_ssc_reg[8]_i_1_CO_UNCONNECTED [3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\NLW_win_ssc_reg[8]_i_1_O_UNCONNECTED [3:1],\win_ssc_reg[8]_i_1_n_7 }),
        .S({1'b0,1'b0,1'b0,\win_ssc[8]_i_2_n_0 }));
  LUT6 #(
    .INIT(64'hDDD555D544400040)) 
    \win_wl[11]_i_10 
       (.I0(ring_wl[9]),
        .I1(have_prev),
        .I2(abs_diff1[9]),
        .I3(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I4(\ring_wl_reg[3][11]_i_6_n_6 ),
        .I5(seg_wl_reg[9]),
        .O(\win_wl[11]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'h47FFB800B80047FF)) 
    \win_wl[11]_i_11 
       (.I0(\ring_wl_reg[3][11]_i_6_n_5 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[10]),
        .I3(have_prev),
        .I4(ring_wl[10]),
        .I5(seg_wl_reg[10]),
        .O(\win_wl[11]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hDDD555D544400040)) 
    \win_wl[11]_i_12 
       (.I0(ring_wl[8]),
        .I1(have_prev),
        .I2(abs_diff1[8]),
        .I3(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I4(\ring_wl_reg[3][11]_i_6_n_7 ),
        .I5(seg_wl_reg[8]),
        .O(\win_wl[11]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'h47FFB800B80047FF)) 
    \win_wl[11]_i_13 
       (.I0(\ring_wl_reg[3][11]_i_6_n_6 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[9]),
        .I3(have_prev),
        .I4(ring_wl[9]),
        .I5(seg_wl_reg[9]),
        .O(\win_wl[11]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hDDD555D544400040)) 
    \win_wl[11]_i_14 
       (.I0(ring_wl[7]),
        .I1(have_prev),
        .I2(abs_diff1[7]),
        .I3(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I4(\ring_wl_reg[3][7]_i_6_n_4 ),
        .I5(seg_wl_reg[7]),
        .O(\win_wl[11]_i_14_n_0 ));
  LUT6 #(
    .INIT(64'h47FFB800B80047FF)) 
    \win_wl[11]_i_15 
       (.I0(\ring_wl_reg[3][11]_i_6_n_7 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[8]),
        .I3(have_prev),
        .I4(ring_wl[8]),
        .I5(seg_wl_reg[8]),
        .O(\win_wl[11]_i_15_n_0 ));
  LUT6 #(
    .INIT(64'hDDD555D544400040)) 
    \win_wl[11]_i_16 
       (.I0(ring_wl[6]),
        .I1(have_prev),
        .I2(abs_diff1[6]),
        .I3(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I4(\ring_wl_reg[3][7]_i_6_n_5 ),
        .I5(seg_wl_reg[6]),
        .O(\win_wl[11]_i_16_n_0 ));
  LUT6 #(
    .INIT(64'h47FFB800B80047FF)) 
    \win_wl[11]_i_17 
       (.I0(\ring_wl_reg[3][7]_i_6_n_4 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[7]),
        .I3(have_prev),
        .I4(ring_wl[7]),
        .I5(seg_wl_reg[7]),
        .O(\win_wl[11]_i_17_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_wl[11]_i_18 
       (.I0(\ring_wl_reg[2] [9]),
        .I1(\ring_wl_reg[3] [9]),
        .I2(\ring_wl_reg[0] [9]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_wl_reg[1] [9]),
        .O(ring_wl[9]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_wl[11]_i_19 
       (.I0(\ring_wl_reg[2] [8]),
        .I1(\ring_wl_reg[3] [8]),
        .I2(\ring_wl_reg[0] [8]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_wl_reg[1] [8]),
        .O(ring_wl[8]));
  (* HLUTNM = "lutpair27" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \win_wl[11]_i_2 
       (.I0(\win_wl[11]_i_10_n_0 ),
        .I1(win_wl[10]),
        .I2(\win_wl[11]_i_11_n_0 ),
        .O(\win_wl[11]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_wl[11]_i_20 
       (.I0(\ring_wl_reg[2] [7]),
        .I1(\ring_wl_reg[3] [7]),
        .I2(\ring_wl_reg[0] [7]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_wl_reg[1] [7]),
        .O(ring_wl[7]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_wl[11]_i_21 
       (.I0(\ring_wl_reg[2] [6]),
        .I1(\ring_wl_reg[3] [6]),
        .I2(\ring_wl_reg[0] [6]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_wl_reg[1] [6]),
        .O(ring_wl[6]));
  LUT3 #(
    .INIT(8'hE8)) 
    \win_wl[11]_i_3 
       (.I0(\win_wl[11]_i_12_n_0 ),
        .I1(win_wl[9]),
        .I2(\win_wl[11]_i_13_n_0 ),
        .O(\win_wl[11]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'hE8)) 
    \win_wl[11]_i_4 
       (.I0(\win_wl[11]_i_14_n_0 ),
        .I1(win_wl[8]),
        .I2(\win_wl[11]_i_15_n_0 ),
        .O(\win_wl[11]_i_4_n_0 ));
  (* HLUTNM = "lutpair26" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \win_wl[11]_i_5 
       (.I0(\win_wl[11]_i_16_n_0 ),
        .I1(win_wl[7]),
        .I2(\win_wl[11]_i_17_n_0 ),
        .O(\win_wl[11]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'h6996)) 
    \win_wl[11]_i_6 
       (.I0(\win_wl[15]_i_16_n_0 ),
        .I1(win_wl[11]),
        .I2(\win_wl[15]_i_17_n_0 ),
        .I3(\win_wl[11]_i_2_n_0 ),
        .O(\win_wl[11]_i_6_n_0 ));
  (* HLUTNM = "lutpair27" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \win_wl[11]_i_7 
       (.I0(\win_wl[11]_i_10_n_0 ),
        .I1(win_wl[10]),
        .I2(\win_wl[11]_i_11_n_0 ),
        .I3(\win_wl[11]_i_3_n_0 ),
        .O(\win_wl[11]_i_7_n_0 ));
  LUT4 #(
    .INIT(16'h6996)) 
    \win_wl[11]_i_8 
       (.I0(\win_wl[11]_i_12_n_0 ),
        .I1(win_wl[9]),
        .I2(\win_wl[11]_i_13_n_0 ),
        .I3(\win_wl[11]_i_4_n_0 ),
        .O(\win_wl[11]_i_8_n_0 ));
  LUT4 #(
    .INIT(16'h6996)) 
    \win_wl[11]_i_9 
       (.I0(\win_wl[11]_i_14_n_0 ),
        .I1(win_wl[8]),
        .I2(\win_wl[11]_i_15_n_0 ),
        .I3(\win_wl[11]_i_5_n_0 ),
        .O(\win_wl[11]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hDDD555D544400040)) 
    \win_wl[15]_i_10 
       (.I0(ring_wl[13]),
        .I1(have_prev),
        .I2(abs_diff1[13]),
        .I3(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I4(\ring_wl_reg[3][15]_i_6_n_6 ),
        .I5(seg_wl_reg[13]),
        .O(\win_wl[15]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'h47FFB800B80047FF)) 
    \win_wl[15]_i_11 
       (.I0(\ring_wl_reg[3][15]_i_6_n_5 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[14]),
        .I3(have_prev),
        .I4(ring_wl[14]),
        .I5(seg_wl_reg[14]),
        .O(\win_wl[15]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hDDD555D544400040)) 
    \win_wl[15]_i_12 
       (.I0(ring_wl[12]),
        .I1(have_prev),
        .I2(abs_diff1[12]),
        .I3(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I4(\ring_wl_reg[3][15]_i_6_n_7 ),
        .I5(seg_wl_reg[12]),
        .O(\win_wl[15]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'h47FFB800B80047FF)) 
    \win_wl[15]_i_13 
       (.I0(\ring_wl_reg[3][15]_i_6_n_6 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[13]),
        .I3(have_prev),
        .I4(ring_wl[13]),
        .I5(seg_wl_reg[13]),
        .O(\win_wl[15]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hDDD555D544400040)) 
    \win_wl[15]_i_14 
       (.I0(ring_wl[11]),
        .I1(have_prev),
        .I2(abs_diff1[11]),
        .I3(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I4(\ring_wl_reg[3][11]_i_6_n_4 ),
        .I5(seg_wl_reg[11]),
        .O(\win_wl[15]_i_14_n_0 ));
  LUT6 #(
    .INIT(64'h47FFB800B80047FF)) 
    \win_wl[15]_i_15 
       (.I0(\ring_wl_reg[3][15]_i_6_n_7 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[12]),
        .I3(have_prev),
        .I4(ring_wl[12]),
        .I5(seg_wl_reg[12]),
        .O(\win_wl[15]_i_15_n_0 ));
  LUT6 #(
    .INIT(64'hDDD555D544400040)) 
    \win_wl[15]_i_16 
       (.I0(ring_wl[10]),
        .I1(have_prev),
        .I2(abs_diff1[10]),
        .I3(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I4(\ring_wl_reg[3][11]_i_6_n_5 ),
        .I5(seg_wl_reg[10]),
        .O(\win_wl[15]_i_16_n_0 ));
  LUT6 #(
    .INIT(64'h47FFB800B80047FF)) 
    \win_wl[15]_i_17 
       (.I0(\ring_wl_reg[3][11]_i_6_n_4 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[11]),
        .I3(have_prev),
        .I4(ring_wl[11]),
        .I5(seg_wl_reg[11]),
        .O(\win_wl[15]_i_17_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_wl[15]_i_18 
       (.I0(\ring_wl_reg[2] [13]),
        .I1(\ring_wl_reg[3] [13]),
        .I2(\ring_wl_reg[0] [13]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_wl_reg[1] [13]),
        .O(ring_wl[13]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_wl[15]_i_19 
       (.I0(\ring_wl_reg[2] [12]),
        .I1(\ring_wl_reg[3] [12]),
        .I2(\ring_wl_reg[0] [12]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_wl_reg[1] [12]),
        .O(ring_wl[12]));
  (* HLUTNM = "lutpair28" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \win_wl[15]_i_2 
       (.I0(\win_wl[15]_i_10_n_0 ),
        .I1(win_wl[14]),
        .I2(\win_wl[15]_i_11_n_0 ),
        .O(\win_wl[15]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_wl[15]_i_20 
       (.I0(\ring_wl_reg[2] [11]),
        .I1(\ring_wl_reg[3] [11]),
        .I2(\ring_wl_reg[0] [11]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_wl_reg[1] [11]),
        .O(ring_wl[11]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_wl[15]_i_21 
       (.I0(\ring_wl_reg[2] [10]),
        .I1(\ring_wl_reg[3] [10]),
        .I2(\ring_wl_reg[0] [10]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_wl_reg[1] [10]),
        .O(ring_wl[10]));
  LUT3 #(
    .INIT(8'hE8)) 
    \win_wl[15]_i_3 
       (.I0(\win_wl[15]_i_12_n_0 ),
        .I1(win_wl[13]),
        .I2(\win_wl[15]_i_13_n_0 ),
        .O(\win_wl[15]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'hE8)) 
    \win_wl[15]_i_4 
       (.I0(\win_wl[15]_i_14_n_0 ),
        .I1(win_wl[12]),
        .I2(\win_wl[15]_i_15_n_0 ),
        .O(\win_wl[15]_i_4_n_0 ));
  LUT3 #(
    .INIT(8'hE8)) 
    \win_wl[15]_i_5 
       (.I0(\win_wl[15]_i_16_n_0 ),
        .I1(win_wl[11]),
        .I2(\win_wl[15]_i_17_n_0 ),
        .O(\win_wl[15]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'h6996)) 
    \win_wl[15]_i_6 
       (.I0(\win_wl[19]_i_16_n_0 ),
        .I1(win_wl[15]),
        .I2(\win_wl[19]_i_17_n_0 ),
        .I3(\win_wl[15]_i_2_n_0 ),
        .O(\win_wl[15]_i_6_n_0 ));
  (* HLUTNM = "lutpair28" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \win_wl[15]_i_7 
       (.I0(\win_wl[15]_i_10_n_0 ),
        .I1(win_wl[14]),
        .I2(\win_wl[15]_i_11_n_0 ),
        .I3(\win_wl[15]_i_3_n_0 ),
        .O(\win_wl[15]_i_7_n_0 ));
  LUT4 #(
    .INIT(16'h6996)) 
    \win_wl[15]_i_8 
       (.I0(\win_wl[15]_i_12_n_0 ),
        .I1(win_wl[13]),
        .I2(\win_wl[15]_i_13_n_0 ),
        .I3(\win_wl[15]_i_4_n_0 ),
        .O(\win_wl[15]_i_8_n_0 ));
  LUT4 #(
    .INIT(16'h6996)) 
    \win_wl[15]_i_9 
       (.I0(\win_wl[15]_i_14_n_0 ),
        .I1(win_wl[12]),
        .I2(\win_wl[15]_i_15_n_0 ),
        .I3(\win_wl[15]_i_5_n_0 ),
        .O(\win_wl[15]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hDDD555D544400040)) 
    \win_wl[19]_i_10 
       (.I0(ring_wl[17]),
        .I1(have_prev),
        .I2(abs_diff1[17]),
        .I3(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I4(\ring_wl_reg[3][19]_i_6_n_6 ),
        .I5(seg_wl_reg[17]),
        .O(\win_wl[19]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'h47FFB800B80047FF)) 
    \win_wl[19]_i_11 
       (.I0(\ring_wl_reg[3][19]_i_6_n_5 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[18]),
        .I3(have_prev),
        .I4(ring_wl[18]),
        .I5(seg_wl_reg[18]),
        .O(\win_wl[19]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hDDD555D544400040)) 
    \win_wl[19]_i_12 
       (.I0(ring_wl[16]),
        .I1(have_prev),
        .I2(abs_diff1[16]),
        .I3(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I4(\ring_wl_reg[3][19]_i_6_n_7 ),
        .I5(seg_wl_reg[16]),
        .O(\win_wl[19]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'h47FFB800B80047FF)) 
    \win_wl[19]_i_13 
       (.I0(\ring_wl_reg[3][19]_i_6_n_6 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[17]),
        .I3(have_prev),
        .I4(ring_wl[17]),
        .I5(seg_wl_reg[17]),
        .O(\win_wl[19]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hDDD555D544400040)) 
    \win_wl[19]_i_14 
       (.I0(ring_wl[15]),
        .I1(have_prev),
        .I2(abs_diff1[15]),
        .I3(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I4(\ring_wl_reg[3][15]_i_6_n_4 ),
        .I5(seg_wl_reg[15]),
        .O(\win_wl[19]_i_14_n_0 ));
  LUT6 #(
    .INIT(64'h47FFB800B80047FF)) 
    \win_wl[19]_i_15 
       (.I0(\ring_wl_reg[3][19]_i_6_n_7 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[16]),
        .I3(have_prev),
        .I4(ring_wl[16]),
        .I5(seg_wl_reg[16]),
        .O(\win_wl[19]_i_15_n_0 ));
  LUT6 #(
    .INIT(64'hDDD555D544400040)) 
    \win_wl[19]_i_16 
       (.I0(ring_wl[14]),
        .I1(have_prev),
        .I2(abs_diff1[14]),
        .I3(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I4(\ring_wl_reg[3][15]_i_6_n_5 ),
        .I5(seg_wl_reg[14]),
        .O(\win_wl[19]_i_16_n_0 ));
  LUT6 #(
    .INIT(64'h47FFB800B80047FF)) 
    \win_wl[19]_i_17 
       (.I0(\ring_wl_reg[3][15]_i_6_n_4 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[15]),
        .I3(have_prev),
        .I4(ring_wl[15]),
        .I5(seg_wl_reg[15]),
        .O(\win_wl[19]_i_17_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_wl[19]_i_18 
       (.I0(\ring_wl_reg[2] [17]),
        .I1(\ring_wl_reg[3] [17]),
        .I2(\ring_wl_reg[0] [17]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_wl_reg[1] [17]),
        .O(ring_wl[17]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_wl[19]_i_19 
       (.I0(\ring_wl_reg[2] [16]),
        .I1(\ring_wl_reg[3] [16]),
        .I2(\ring_wl_reg[0] [16]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_wl_reg[1] [16]),
        .O(ring_wl[16]));
  (* HLUTNM = "lutpair29" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \win_wl[19]_i_2 
       (.I0(\win_wl[19]_i_10_n_0 ),
        .I1(win_wl[18]),
        .I2(\win_wl[19]_i_11_n_0 ),
        .O(\win_wl[19]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_wl[19]_i_20 
       (.I0(\ring_wl_reg[2] [15]),
        .I1(\ring_wl_reg[3] [15]),
        .I2(\ring_wl_reg[0] [15]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_wl_reg[1] [15]),
        .O(ring_wl[15]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_wl[19]_i_21 
       (.I0(\ring_wl_reg[2] [14]),
        .I1(\ring_wl_reg[3] [14]),
        .I2(\ring_wl_reg[0] [14]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_wl_reg[1] [14]),
        .O(ring_wl[14]));
  LUT3 #(
    .INIT(8'hE8)) 
    \win_wl[19]_i_3 
       (.I0(\win_wl[19]_i_12_n_0 ),
        .I1(win_wl[17]),
        .I2(\win_wl[19]_i_13_n_0 ),
        .O(\win_wl[19]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'hE8)) 
    \win_wl[19]_i_4 
       (.I0(\win_wl[19]_i_14_n_0 ),
        .I1(win_wl[16]),
        .I2(\win_wl[19]_i_15_n_0 ),
        .O(\win_wl[19]_i_4_n_0 ));
  LUT3 #(
    .INIT(8'hE8)) 
    \win_wl[19]_i_5 
       (.I0(\win_wl[19]_i_16_n_0 ),
        .I1(win_wl[15]),
        .I2(\win_wl[19]_i_17_n_0 ),
        .O(\win_wl[19]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'h6996)) 
    \win_wl[19]_i_6 
       (.I0(\win_wl[23]_i_16_n_0 ),
        .I1(win_wl[19]),
        .I2(\win_wl[23]_i_17_n_0 ),
        .I3(\win_wl[19]_i_2_n_0 ),
        .O(\win_wl[19]_i_6_n_0 ));
  (* HLUTNM = "lutpair29" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \win_wl[19]_i_7 
       (.I0(\win_wl[19]_i_10_n_0 ),
        .I1(win_wl[18]),
        .I2(\win_wl[19]_i_11_n_0 ),
        .I3(\win_wl[19]_i_3_n_0 ),
        .O(\win_wl[19]_i_7_n_0 ));
  LUT4 #(
    .INIT(16'h6996)) 
    \win_wl[19]_i_8 
       (.I0(\win_wl[19]_i_12_n_0 ),
        .I1(win_wl[17]),
        .I2(\win_wl[19]_i_13_n_0 ),
        .I3(\win_wl[19]_i_4_n_0 ),
        .O(\win_wl[19]_i_8_n_0 ));
  LUT4 #(
    .INIT(16'h6996)) 
    \win_wl[19]_i_9 
       (.I0(\win_wl[19]_i_14_n_0 ),
        .I1(win_wl[16]),
        .I2(\win_wl[19]_i_15_n_0 ),
        .I3(\win_wl[19]_i_5_n_0 ),
        .O(\win_wl[19]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hDDD555D544400040)) 
    \win_wl[23]_i_10 
       (.I0(ring_wl[21]),
        .I1(have_prev),
        .I2(abs_diff1[21]),
        .I3(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I4(\ring_wl_reg[3][23]_i_6_n_6 ),
        .I5(seg_wl_reg[21]),
        .O(\win_wl[23]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'h47FFB800B80047FF)) 
    \win_wl[23]_i_11 
       (.I0(\ring_wl_reg[3][23]_i_6_n_5 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[22]),
        .I3(have_prev),
        .I4(ring_wl[22]),
        .I5(seg_wl_reg[22]),
        .O(\win_wl[23]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hDDD555D544400040)) 
    \win_wl[23]_i_12 
       (.I0(ring_wl[20]),
        .I1(have_prev),
        .I2(abs_diff1[20]),
        .I3(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I4(\ring_wl_reg[3][23]_i_6_n_7 ),
        .I5(seg_wl_reg[20]),
        .O(\win_wl[23]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'h47FFB800B80047FF)) 
    \win_wl[23]_i_13 
       (.I0(\ring_wl_reg[3][23]_i_6_n_6 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[21]),
        .I3(have_prev),
        .I4(ring_wl[21]),
        .I5(seg_wl_reg[21]),
        .O(\win_wl[23]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hDDD555D544400040)) 
    \win_wl[23]_i_14 
       (.I0(ring_wl[19]),
        .I1(have_prev),
        .I2(abs_diff1[19]),
        .I3(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I4(\ring_wl_reg[3][19]_i_6_n_4 ),
        .I5(seg_wl_reg[19]),
        .O(\win_wl[23]_i_14_n_0 ));
  LUT6 #(
    .INIT(64'h47FFB800B80047FF)) 
    \win_wl[23]_i_15 
       (.I0(\ring_wl_reg[3][23]_i_6_n_7 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[20]),
        .I3(have_prev),
        .I4(ring_wl[20]),
        .I5(seg_wl_reg[20]),
        .O(\win_wl[23]_i_15_n_0 ));
  LUT6 #(
    .INIT(64'hDDD555D544400040)) 
    \win_wl[23]_i_16 
       (.I0(ring_wl[18]),
        .I1(have_prev),
        .I2(abs_diff1[18]),
        .I3(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I4(\ring_wl_reg[3][19]_i_6_n_5 ),
        .I5(seg_wl_reg[18]),
        .O(\win_wl[23]_i_16_n_0 ));
  LUT6 #(
    .INIT(64'h47FFB800B80047FF)) 
    \win_wl[23]_i_17 
       (.I0(\ring_wl_reg[3][19]_i_6_n_4 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[19]),
        .I3(have_prev),
        .I4(ring_wl[19]),
        .I5(seg_wl_reg[19]),
        .O(\win_wl[23]_i_17_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_wl[23]_i_18 
       (.I0(\ring_wl_reg[2] [21]),
        .I1(\ring_wl_reg[3] [21]),
        .I2(\ring_wl_reg[0] [21]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_wl_reg[1] [21]),
        .O(ring_wl[21]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_wl[23]_i_19 
       (.I0(\ring_wl_reg[2] [20]),
        .I1(\ring_wl_reg[3] [20]),
        .I2(\ring_wl_reg[0] [20]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_wl_reg[1] [20]),
        .O(ring_wl[20]));
  (* HLUTNM = "lutpair30" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \win_wl[23]_i_2 
       (.I0(\win_wl[23]_i_10_n_0 ),
        .I1(win_wl[22]),
        .I2(\win_wl[23]_i_11_n_0 ),
        .O(\win_wl[23]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_wl[23]_i_20 
       (.I0(\ring_wl_reg[2] [19]),
        .I1(\ring_wl_reg[3] [19]),
        .I2(\ring_wl_reg[0] [19]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_wl_reg[1] [19]),
        .O(ring_wl[19]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_wl[23]_i_21 
       (.I0(\ring_wl_reg[2] [18]),
        .I1(\ring_wl_reg[3] [18]),
        .I2(\ring_wl_reg[0] [18]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_wl_reg[1] [18]),
        .O(ring_wl[18]));
  LUT3 #(
    .INIT(8'hE8)) 
    \win_wl[23]_i_3 
       (.I0(\win_wl[23]_i_12_n_0 ),
        .I1(win_wl[21]),
        .I2(\win_wl[23]_i_13_n_0 ),
        .O(\win_wl[23]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'hE8)) 
    \win_wl[23]_i_4 
       (.I0(\win_wl[23]_i_14_n_0 ),
        .I1(win_wl[20]),
        .I2(\win_wl[23]_i_15_n_0 ),
        .O(\win_wl[23]_i_4_n_0 ));
  LUT3 #(
    .INIT(8'hE8)) 
    \win_wl[23]_i_5 
       (.I0(\win_wl[23]_i_16_n_0 ),
        .I1(win_wl[19]),
        .I2(\win_wl[23]_i_17_n_0 ),
        .O(\win_wl[23]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'h6996)) 
    \win_wl[23]_i_6 
       (.I0(\win_wl[27]_i_15_n_0 ),
        .I1(win_wl[23]),
        .I2(\win_wl[27]_i_16_n_0 ),
        .I3(\win_wl[23]_i_2_n_0 ),
        .O(\win_wl[23]_i_6_n_0 ));
  (* HLUTNM = "lutpair30" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \win_wl[23]_i_7 
       (.I0(\win_wl[23]_i_10_n_0 ),
        .I1(win_wl[22]),
        .I2(\win_wl[23]_i_11_n_0 ),
        .I3(\win_wl[23]_i_3_n_0 ),
        .O(\win_wl[23]_i_7_n_0 ));
  LUT4 #(
    .INIT(16'h6996)) 
    \win_wl[23]_i_8 
       (.I0(\win_wl[23]_i_12_n_0 ),
        .I1(win_wl[21]),
        .I2(\win_wl[23]_i_13_n_0 ),
        .I3(\win_wl[23]_i_4_n_0 ),
        .O(\win_wl[23]_i_8_n_0 ));
  LUT4 #(
    .INIT(16'h6996)) 
    \win_wl[23]_i_9 
       (.I0(\win_wl[23]_i_14_n_0 ),
        .I1(win_wl[20]),
        .I2(\win_wl[23]_i_15_n_0 ),
        .I3(\win_wl[23]_i_5_n_0 ),
        .O(\win_wl[23]_i_9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair129" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \win_wl[27]_i_10 
       (.I0(seg_wl_reg[24]),
        .I1(ring_wl[24]),
        .O(\win_wl[27]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'h9696969666969696)) 
    \win_wl[27]_i_11 
       (.I0(\win_wl[27]_i_20_n_0 ),
        .I1(win_wl[25]),
        .I2(win_wl[24]),
        .I3(abs_diff1[24]),
        .I4(have_prev),
        .I5(\ring_wl_reg[3][27]_i_4_n_3 ),
        .O(\win_wl[27]_i_11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT5 #(
    .INIT(32'h2DD2D22D)) 
    \win_wl[27]_i_12 
       (.I0(ring_wl[25]),
        .I1(seg_wl_reg[25]),
        .I2(win_wl[26]),
        .I3(seg_wl_reg[26]),
        .I4(ring_wl[26]),
        .O(\win_wl[27]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hDDD555D544400040)) 
    \win_wl[27]_i_13 
       (.I0(ring_wl[23]),
        .I1(have_prev),
        .I2(abs_diff1[23]),
        .I3(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I4(\ring_wl_reg[3][23]_i_6_n_4 ),
        .I5(seg_wl_reg[23]),
        .O(\win_wl[27]_i_13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair129" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \win_wl[27]_i_14 
       (.I0(seg_wl_reg[24]),
        .I1(ring_wl[24]),
        .O(\win_wl[27]_i_14_n_0 ));
  LUT6 #(
    .INIT(64'hDDD555D544400040)) 
    \win_wl[27]_i_15 
       (.I0(ring_wl[22]),
        .I1(have_prev),
        .I2(abs_diff1[22]),
        .I3(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I4(\ring_wl_reg[3][23]_i_6_n_5 ),
        .I5(seg_wl_reg[22]),
        .O(\win_wl[27]_i_15_n_0 ));
  LUT6 #(
    .INIT(64'h47FFB800B80047FF)) 
    \win_wl[27]_i_16 
       (.I0(\ring_wl_reg[3][23]_i_6_n_4 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[23]),
        .I3(have_prev),
        .I4(ring_wl[23]),
        .I5(seg_wl_reg[23]),
        .O(\win_wl[27]_i_16_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT5 #(
    .INIT(32'h2DD2D22D)) 
    \win_wl[27]_i_17 
       (.I0(ring_wl[26]),
        .I1(seg_wl_reg[26]),
        .I2(win_wl[27]),
        .I3(seg_wl_reg[27]),
        .I4(ring_wl[27]),
        .O(\win_wl[27]_i_17_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT5 #(
    .INIT(32'hD0FDFDD0)) 
    \win_wl[27]_i_18 
       (.I0(ring_wl[25]),
        .I1(seg_wl_reg[25]),
        .I2(win_wl[26]),
        .I3(seg_wl_reg[26]),
        .I4(ring_wl[26]),
        .O(\win_wl[27]_i_18_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair121" *) 
  LUT3 #(
    .INIT(8'h40)) 
    \win_wl[27]_i_19 
       (.I0(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I1(have_prev),
        .I2(abs_diff1[24]),
        .O(abs_diff[24]));
  LUT3 #(
    .INIT(8'h80)) 
    \win_wl[27]_i_2 
       (.I0(\win_wl[27]_i_10_n_0 ),
        .I1(\win_wl[27]_i_11_n_0 ),
        .I2(\win_wl[27]_i_12_n_0 ),
        .O(\win_wl[27]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair128" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \win_wl[27]_i_20 
       (.I0(seg_wl_reg[25]),
        .I1(ring_wl[25]),
        .O(\win_wl[27]_i_20_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_wl[27]_i_21 
       (.I0(\ring_wl_reg[2] [24]),
        .I1(\ring_wl_reg[3] [24]),
        .I2(\ring_wl_reg[0] [24]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_wl_reg[1] [24]),
        .O(ring_wl[24]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_wl[27]_i_22 
       (.I0(\ring_wl_reg[2] [23]),
        .I1(\ring_wl_reg[3] [23]),
        .I2(\ring_wl_reg[0] [23]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_wl_reg[1] [23]),
        .O(ring_wl[23]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_wl[27]_i_23 
       (.I0(\ring_wl_reg[2] [22]),
        .I1(\ring_wl_reg[3] [22]),
        .I2(\ring_wl_reg[0] [22]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_wl_reg[1] [22]),
        .O(ring_wl[22]));
  LUT3 #(
    .INIT(8'h78)) 
    \win_wl[27]_i_3 
       (.I0(\win_wl[27]_i_11_n_0 ),
        .I1(\win_wl[27]_i_10_n_0 ),
        .I2(\win_wl[27]_i_12_n_0 ),
        .O(\win_wl[27]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hBBBBEBBB22228222)) 
    \win_wl[27]_i_4 
       (.I0(\win_wl[27]_i_13_n_0 ),
        .I1(win_wl[24]),
        .I2(abs_diff1[24]),
        .I3(have_prev),
        .I4(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I5(\win_wl[27]_i_14_n_0 ),
        .O(\win_wl[27]_i_4_n_0 ));
  LUT3 #(
    .INIT(8'hE8)) 
    \win_wl[27]_i_5 
       (.I0(\win_wl[27]_i_15_n_0 ),
        .I1(win_wl[23]),
        .I2(\win_wl[27]_i_16_n_0 ),
        .O(\win_wl[27]_i_5_n_0 ));
  LUT3 #(
    .INIT(8'h96)) 
    \win_wl[27]_i_6 
       (.I0(\win_wl[27]_i_2_n_0 ),
        .I1(\win_wl[27]_i_17_n_0 ),
        .I2(\win_wl[27]_i_18_n_0 ),
        .O(\win_wl[27]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h595565666566A6AA)) 
    \win_wl[27]_i_7 
       (.I0(\win_wl[27]_i_12_n_0 ),
        .I1(\win_wl[27]_i_10_n_0 ),
        .I2(abs_diff[24]),
        .I3(win_wl[24]),
        .I4(win_wl[25]),
        .I5(\win_wl[27]_i_20_n_0 ),
        .O(\win_wl[27]_i_7_n_0 ));
  LUT3 #(
    .INIT(8'h96)) 
    \win_wl[27]_i_8 
       (.I0(\win_wl[27]_i_4_n_0 ),
        .I1(\win_wl[27]_i_10_n_0 ),
        .I2(\win_wl[27]_i_11_n_0 ),
        .O(\win_wl[27]_i_8_n_0 ));
  LUT5 #(
    .INIT(32'h69969669)) 
    \win_wl[27]_i_9 
       (.I0(\win_wl[27]_i_5_n_0 ),
        .I1(\win_wl[27]_i_14_n_0 ),
        .I2(abs_diff[24]),
        .I3(win_wl[24]),
        .I4(\win_wl[27]_i_13_n_0 ),
        .O(\win_wl[27]_i_9_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \win_wl[31]_i_10 
       (.I0(seg_wl_reg[30]),
        .I1(ring_wl[30]),
        .O(\win_wl[31]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_wl[31]_i_11 
       (.I0(\ring_wl_reg[2] [29]),
        .I1(\ring_wl_reg[3] [29]),
        .I2(\ring_wl_reg[0] [29]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_wl_reg[1] [29]),
        .O(ring_wl[29]));
  (* SOFT_HLUTNM = "soft_lutpair126" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \win_wl[31]_i_12 
       (.I0(seg_wl_reg[28]),
        .I1(ring_wl[28]),
        .O(\win_wl[31]_i_12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair125" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \win_wl[31]_i_13 
       (.I0(seg_wl_reg[29]),
        .I1(ring_wl[29]),
        .O(\win_wl[31]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_wl[31]_i_14 
       (.I0(\ring_wl_reg[2] [28]),
        .I1(\ring_wl_reg[3] [28]),
        .I2(\ring_wl_reg[0] [28]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_wl_reg[1] [28]),
        .O(ring_wl[28]));
  (* SOFT_HLUTNM = "soft_lutpair127" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \win_wl[31]_i_15 
       (.I0(seg_wl_reg[27]),
        .I1(ring_wl[27]),
        .O(\win_wl[31]_i_15_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair126" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \win_wl[31]_i_16 
       (.I0(seg_wl_reg[28]),
        .I1(ring_wl[28]),
        .O(\win_wl[31]_i_16_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_wl[31]_i_17 
       (.I0(\ring_wl_reg[2] [27]),
        .I1(\ring_wl_reg[3] [27]),
        .I2(\ring_wl_reg[0] [27]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_wl_reg[1] [27]),
        .O(ring_wl[27]));
  LUT2 #(
    .INIT(4'hB)) 
    \win_wl[31]_i_18 
       (.I0(seg_wl_reg[26]),
        .I1(ring_wl[26]),
        .O(\win_wl[31]_i_18_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair127" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \win_wl[31]_i_19 
       (.I0(seg_wl_reg[27]),
        .I1(ring_wl[27]),
        .O(\win_wl[31]_i_19_n_0 ));
  LUT6 #(
    .INIT(64'h9969096009600000)) 
    \win_wl[31]_i_2 
       (.I0(\win_wl[31]_i_10_n_0 ),
        .I1(win_wl[30]),
        .I2(ring_wl[29]),
        .I3(seg_wl_reg[29]),
        .I4(win_wl[29]),
        .I5(\win_wl[31]_i_12_n_0 ),
        .O(\win_wl[31]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_wl[31]_i_20 
       (.I0(\ring_wl_reg[2] [26]),
        .I1(\ring_wl_reg[3] [26]),
        .I2(\ring_wl_reg[0] [26]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_wl_reg[1] [26]),
        .O(ring_wl[26]));
  (* SOFT_HLUTNM = "soft_lutpair128" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \win_wl[31]_i_21 
       (.I0(seg_wl_reg[25]),
        .I1(ring_wl[25]),
        .O(\win_wl[31]_i_21_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT5 #(
    .INIT(32'h2DD2D22D)) 
    \win_wl[31]_i_22 
       (.I0(ring_wl[30]),
        .I1(seg_wl_reg[30]),
        .I2(win_wl[31]),
        .I3(seg_wl_reg[31]),
        .I4(ring_wl[31]),
        .O(\win_wl[31]_i_22_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT5 #(
    .INIT(32'hD0FDFDD0)) 
    \win_wl[31]_i_23 
       (.I0(ring_wl[29]),
        .I1(seg_wl_reg[29]),
        .I2(win_wl[30]),
        .I3(seg_wl_reg[30]),
        .I4(ring_wl[30]),
        .O(\win_wl[31]_i_23_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT5 #(
    .INIT(32'h2DD2D22D)) 
    \win_wl[31]_i_24 
       (.I0(ring_wl[29]),
        .I1(seg_wl_reg[29]),
        .I2(win_wl[30]),
        .I3(seg_wl_reg[30]),
        .I4(ring_wl[30]),
        .O(\win_wl[31]_i_24_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT5 #(
    .INIT(32'hD0FDFDD0)) 
    \win_wl[31]_i_25 
       (.I0(ring_wl[28]),
        .I1(seg_wl_reg[28]),
        .I2(win_wl[29]),
        .I3(seg_wl_reg[29]),
        .I4(ring_wl[29]),
        .O(\win_wl[31]_i_25_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT5 #(
    .INIT(32'h2DD2D22D)) 
    \win_wl[31]_i_26 
       (.I0(ring_wl[28]),
        .I1(seg_wl_reg[28]),
        .I2(win_wl[29]),
        .I3(seg_wl_reg[29]),
        .I4(ring_wl[29]),
        .O(\win_wl[31]_i_26_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT5 #(
    .INIT(32'hD0FDFDD0)) 
    \win_wl[31]_i_27 
       (.I0(ring_wl[27]),
        .I1(seg_wl_reg[27]),
        .I2(win_wl[28]),
        .I3(seg_wl_reg[28]),
        .I4(ring_wl[28]),
        .O(\win_wl[31]_i_27_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT5 #(
    .INIT(32'h2DD2D22D)) 
    \win_wl[31]_i_28 
       (.I0(ring_wl[27]),
        .I1(seg_wl_reg[27]),
        .I2(win_wl[28]),
        .I3(seg_wl_reg[28]),
        .I4(ring_wl[28]),
        .O(\win_wl[31]_i_28_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT5 #(
    .INIT(32'hD0FDFDD0)) 
    \win_wl[31]_i_29 
       (.I0(ring_wl[26]),
        .I1(seg_wl_reg[26]),
        .I2(win_wl[27]),
        .I3(seg_wl_reg[27]),
        .I4(ring_wl[27]),
        .O(\win_wl[31]_i_29_n_0 ));
  LUT6 #(
    .INIT(64'h9969096009600000)) 
    \win_wl[31]_i_3 
       (.I0(\win_wl[31]_i_13_n_0 ),
        .I1(win_wl[29]),
        .I2(ring_wl[28]),
        .I3(seg_wl_reg[28]),
        .I4(win_wl[28]),
        .I5(\win_wl[31]_i_15_n_0 ),
        .O(\win_wl[31]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_wl[31]_i_30 
       (.I0(\ring_wl_reg[2] [25]),
        .I1(\ring_wl_reg[3] [25]),
        .I2(\ring_wl_reg[0] [25]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_wl_reg[1] [25]),
        .O(ring_wl[25]));
  LUT6 #(
    .INIT(64'h9969096009600000)) 
    \win_wl[31]_i_4 
       (.I0(\win_wl[31]_i_16_n_0 ),
        .I1(win_wl[28]),
        .I2(ring_wl[27]),
        .I3(seg_wl_reg[27]),
        .I4(win_wl[27]),
        .I5(\win_wl[31]_i_18_n_0 ),
        .O(\win_wl[31]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h9969096009600000)) 
    \win_wl[31]_i_5 
       (.I0(\win_wl[31]_i_19_n_0 ),
        .I1(win_wl[27]),
        .I2(ring_wl[26]),
        .I3(seg_wl_reg[26]),
        .I4(win_wl[26]),
        .I5(\win_wl[31]_i_21_n_0 ),
        .O(\win_wl[31]_i_5_n_0 ));
  LUT3 #(
    .INIT(8'h96)) 
    \win_wl[31]_i_6 
       (.I0(\win_wl[31]_i_2_n_0 ),
        .I1(\win_wl[31]_i_22_n_0 ),
        .I2(\win_wl[31]_i_23_n_0 ),
        .O(\win_wl[31]_i_6_n_0 ));
  LUT3 #(
    .INIT(8'h96)) 
    \win_wl[31]_i_7 
       (.I0(\win_wl[31]_i_3_n_0 ),
        .I1(\win_wl[31]_i_24_n_0 ),
        .I2(\win_wl[31]_i_25_n_0 ),
        .O(\win_wl[31]_i_7_n_0 ));
  LUT3 #(
    .INIT(8'h96)) 
    \win_wl[31]_i_8 
       (.I0(\win_wl[31]_i_4_n_0 ),
        .I1(\win_wl[31]_i_26_n_0 ),
        .I2(\win_wl[31]_i_27_n_0 ),
        .O(\win_wl[31]_i_8_n_0 ));
  LUT3 #(
    .INIT(8'h96)) 
    \win_wl[31]_i_9 
       (.I0(\win_wl[31]_i_5_n_0 ),
        .I1(\win_wl[31]_i_28_n_0 ),
        .I2(\win_wl[31]_i_29_n_0 ),
        .O(\win_wl[31]_i_9_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \win_wl[35]_i_10 
       (.I0(seg_wl_reg[31]),
        .I1(ring_wl[31]),
        .O(\win_wl[35]_i_10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair125" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \win_wl[35]_i_11 
       (.I0(seg_wl_reg[29]),
        .I1(ring_wl[29]),
        .O(\win_wl[35]_i_11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \win_wl[35]_i_12 
       (.I0(seg_wl_reg[30]),
        .I1(ring_wl[30]),
        .O(\win_wl[35]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hFF8AEF00FFEFFF8A)) 
    \win_wl[35]_i_2 
       (.I0(win_wl[31]),
        .I1(seg_wl_reg[30]),
        .I2(ring_wl[30]),
        .I3(win_wl[32]),
        .I4(seg_wl_reg[31]),
        .I5(ring_wl[31]),
        .O(\win_wl[35]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h9969096009600000)) 
    \win_wl[35]_i_3 
       (.I0(\win_wl[35]_i_10_n_0 ),
        .I1(win_wl[31]),
        .I2(ring_wl[30]),
        .I3(seg_wl_reg[30]),
        .I4(win_wl[30]),
        .I5(\win_wl[35]_i_11_n_0 ),
        .O(\win_wl[35]_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \win_wl[35]_i_4 
       (.I0(win_wl[34]),
        .I1(win_wl[35]),
        .O(\win_wl[35]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \win_wl[35]_i_5 
       (.I0(win_wl[33]),
        .I1(win_wl[34]),
        .O(\win_wl[35]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \win_wl[35]_i_6 
       (.I0(\win_wl[35]_i_2_n_0 ),
        .I1(win_wl[33]),
        .O(\win_wl[35]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h59A69A659A65A659)) 
    \win_wl[35]_i_7 
       (.I0(\win_wl[35]_i_3_n_0 ),
        .I1(ring_wl[31]),
        .I2(seg_wl_reg[31]),
        .I3(win_wl[32]),
        .I4(\win_wl[35]_i_12_n_0 ),
        .I5(win_wl[31]),
        .O(\win_wl[35]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_wl[35]_i_8 
       (.I0(\ring_wl_reg[2] [30]),
        .I1(\ring_wl_reg[3] [30]),
        .I2(\ring_wl_reg[0] [30]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_wl_reg[1] [30]),
        .O(ring_wl[30]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_wl[35]_i_9 
       (.I0(\ring_wl_reg[2] [31]),
        .I1(\ring_wl_reg[3] [31]),
        .I2(\ring_wl_reg[0] [31]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_wl_reg[1] [31]),
        .O(ring_wl[31]));
  LUT2 #(
    .INIT(4'h9)) 
    \win_wl[39]_i_2 
       (.I0(win_wl[38]),
        .I1(win_wl[39]),
        .O(\win_wl[39]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \win_wl[39]_i_3 
       (.I0(win_wl[37]),
        .I1(win_wl[38]),
        .O(\win_wl[39]_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \win_wl[39]_i_4 
       (.I0(win_wl[36]),
        .I1(win_wl[37]),
        .O(\win_wl[39]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \win_wl[39]_i_5 
       (.I0(win_wl[35]),
        .I1(win_wl[36]),
        .O(\win_wl[39]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hDDD555D544400040)) 
    \win_wl[3]_i_10 
       (.I0(ring_wl[1]),
        .I1(have_prev),
        .I2(abs_diff1[1]),
        .I3(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I4(\ring_wl_reg[3][3]_i_6_n_6 ),
        .I5(seg_wl_reg[1]),
        .O(\win_wl[3]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'h47FFB800B80047FF)) 
    \win_wl[3]_i_11 
       (.I0(\ring_wl_reg[3][3]_i_6_n_5 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[2]),
        .I3(have_prev),
        .I4(ring_wl[2]),
        .I5(seg_wl_reg[2]),
        .O(\win_wl[3]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'h47FFB800B80047FF)) 
    \win_wl[3]_i_12 
       (.I0(\ring_wl_reg[3][3]_i_6_n_6 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[1]),
        .I3(have_prev),
        .I4(ring_wl[1]),
        .I5(seg_wl_reg[1]),
        .O(\win_wl[3]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_wl[3]_i_13 
       (.I0(\ring_wl_reg[2] [0]),
        .I1(\ring_wl_reg[3] [0]),
        .I2(\ring_wl_reg[0] [0]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_wl_reg[1] [0]),
        .O(ring_wl[0]));
  (* SOFT_HLUTNM = "soft_lutpair121" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \win_wl[3]_i_14 
       (.I0(have_prev),
        .I1(\ring_wl_reg[3][3]_i_6_n_7 ),
        .O(abs_diff[0]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_wl[3]_i_15 
       (.I0(\ring_wl_reg[2] [1]),
        .I1(\ring_wl_reg[3] [1]),
        .I2(\ring_wl_reg[0] [1]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_wl_reg[1] [1]),
        .O(ring_wl[1]));
  (* HLUTNM = "lutpair21" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \win_wl[3]_i_2 
       (.I0(\win_wl[3]_i_10_n_0 ),
        .I1(win_wl[2]),
        .I2(\win_wl[3]_i_11_n_0 ),
        .O(\win_wl[3]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hE8888888)) 
    \win_wl[3]_i_3 
       (.I0(\win_wl[3]_i_12_n_0 ),
        .I1(win_wl[1]),
        .I2(\ring_wl_reg[3][3]_i_6_n_7 ),
        .I3(have_prev),
        .I4(win_wl[0]),
        .O(\win_wl[3]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'h96666666)) 
    \win_wl[3]_i_4 
       (.I0(\win_wl[3]_i_12_n_0 ),
        .I1(win_wl[1]),
        .I2(\ring_wl_reg[3][3]_i_6_n_7 ),
        .I3(have_prev),
        .I4(win_wl[0]),
        .O(\win_wl[3]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \win_wl[3]_i_5 
       (.I0(seg_wl_reg[0]),
        .I1(ring_wl[0]),
        .O(\win_wl[3]_i_5_n_0 ));
  (* HLUTNM = "lutpair22" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \win_wl[3]_i_6 
       (.I0(\win_wl[7]_i_16_n_0 ),
        .I1(win_wl[3]),
        .I2(\win_wl[7]_i_17_n_0 ),
        .I3(\win_wl[3]_i_2_n_0 ),
        .O(\win_wl[3]_i_6_n_0 ));
  (* HLUTNM = "lutpair21" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \win_wl[3]_i_7 
       (.I0(\win_wl[3]_i_10_n_0 ),
        .I1(win_wl[2]),
        .I2(\win_wl[3]_i_11_n_0 ),
        .I3(\win_wl[3]_i_3_n_0 ),
        .O(\win_wl[3]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h7887788787787887)) 
    \win_wl[3]_i_8 
       (.I0(win_wl[0]),
        .I1(abs_diff[0]),
        .I2(win_wl[1]),
        .I3(\win_wl[3]_i_12_n_0 ),
        .I4(ring_wl[0]),
        .I5(seg_wl_reg[0]),
        .O(\win_wl[3]_i_8_n_0 ));
  LUT5 #(
    .INIT(32'h69999666)) 
    \win_wl[3]_i_9 
       (.I0(ring_wl[0]),
        .I1(seg_wl_reg[0]),
        .I2(have_prev),
        .I3(\ring_wl_reg[3][3]_i_6_n_7 ),
        .I4(win_wl[0]),
        .O(\win_wl[3]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hDDD555D544400040)) 
    \win_wl[7]_i_10 
       (.I0(ring_wl[5]),
        .I1(have_prev),
        .I2(abs_diff1[5]),
        .I3(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I4(\ring_wl_reg[3][7]_i_6_n_6 ),
        .I5(seg_wl_reg[5]),
        .O(\win_wl[7]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'h47FFB800B80047FF)) 
    \win_wl[7]_i_11 
       (.I0(\ring_wl_reg[3][7]_i_6_n_5 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[6]),
        .I3(have_prev),
        .I4(ring_wl[6]),
        .I5(seg_wl_reg[6]),
        .O(\win_wl[7]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hDDD555D544400040)) 
    \win_wl[7]_i_12 
       (.I0(ring_wl[4]),
        .I1(have_prev),
        .I2(abs_diff1[4]),
        .I3(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I4(\ring_wl_reg[3][7]_i_6_n_7 ),
        .I5(seg_wl_reg[4]),
        .O(\win_wl[7]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'h47FFB800B80047FF)) 
    \win_wl[7]_i_13 
       (.I0(\ring_wl_reg[3][7]_i_6_n_6 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[5]),
        .I3(have_prev),
        .I4(ring_wl[5]),
        .I5(seg_wl_reg[5]),
        .O(\win_wl[7]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hDDD555D544400040)) 
    \win_wl[7]_i_14 
       (.I0(ring_wl[3]),
        .I1(have_prev),
        .I2(abs_diff1[3]),
        .I3(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I4(\ring_wl_reg[3][3]_i_6_n_4 ),
        .I5(seg_wl_reg[3]),
        .O(\win_wl[7]_i_14_n_0 ));
  LUT6 #(
    .INIT(64'h47FFB800B80047FF)) 
    \win_wl[7]_i_15 
       (.I0(\ring_wl_reg[3][7]_i_6_n_7 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[4]),
        .I3(have_prev),
        .I4(ring_wl[4]),
        .I5(seg_wl_reg[4]),
        .O(\win_wl[7]_i_15_n_0 ));
  LUT6 #(
    .INIT(64'hDDD555D544400040)) 
    \win_wl[7]_i_16 
       (.I0(ring_wl[2]),
        .I1(have_prev),
        .I2(abs_diff1[2]),
        .I3(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I4(\ring_wl_reg[3][3]_i_6_n_5 ),
        .I5(seg_wl_reg[2]),
        .O(\win_wl[7]_i_16_n_0 ));
  LUT6 #(
    .INIT(64'h47FFB800B80047FF)) 
    \win_wl[7]_i_17 
       (.I0(\ring_wl_reg[3][3]_i_6_n_4 ),
        .I1(\ring_wl_reg[3][27]_i_4_n_3 ),
        .I2(abs_diff1[3]),
        .I3(have_prev),
        .I4(ring_wl[3]),
        .I5(seg_wl_reg[3]),
        .O(\win_wl[7]_i_17_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_wl[7]_i_18 
       (.I0(\ring_wl_reg[2] [5]),
        .I1(\ring_wl_reg[3] [5]),
        .I2(\ring_wl_reg[0] [5]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_wl_reg[1] [5]),
        .O(ring_wl[5]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_wl[7]_i_19 
       (.I0(\ring_wl_reg[2] [4]),
        .I1(\ring_wl_reg[3] [4]),
        .I2(\ring_wl_reg[0] [4]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_wl_reg[1] [4]),
        .O(ring_wl[4]));
  (* HLUTNM = "lutpair25" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \win_wl[7]_i_2 
       (.I0(\win_wl[7]_i_10_n_0 ),
        .I1(win_wl[6]),
        .I2(\win_wl[7]_i_11_n_0 ),
        .O(\win_wl[7]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_wl[7]_i_20 
       (.I0(\ring_wl_reg[2] [3]),
        .I1(\ring_wl_reg[3] [3]),
        .I2(\ring_wl_reg[0] [3]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_wl_reg[1] [3]),
        .O(ring_wl[3]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_wl[7]_i_21 
       (.I0(\ring_wl_reg[2] [2]),
        .I1(\ring_wl_reg[3] [2]),
        .I2(\ring_wl_reg[0] [2]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_wl_reg[1] [2]),
        .O(ring_wl[2]));
  (* HLUTNM = "lutpair24" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \win_wl[7]_i_3 
       (.I0(\win_wl[7]_i_12_n_0 ),
        .I1(win_wl[5]),
        .I2(\win_wl[7]_i_13_n_0 ),
        .O(\win_wl[7]_i_3_n_0 ));
  (* HLUTNM = "lutpair23" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \win_wl[7]_i_4 
       (.I0(\win_wl[7]_i_14_n_0 ),
        .I1(win_wl[4]),
        .I2(\win_wl[7]_i_15_n_0 ),
        .O(\win_wl[7]_i_4_n_0 ));
  (* HLUTNM = "lutpair22" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \win_wl[7]_i_5 
       (.I0(\win_wl[7]_i_16_n_0 ),
        .I1(win_wl[3]),
        .I2(\win_wl[7]_i_17_n_0 ),
        .O(\win_wl[7]_i_5_n_0 ));
  (* HLUTNM = "lutpair26" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \win_wl[7]_i_6 
       (.I0(\win_wl[11]_i_16_n_0 ),
        .I1(win_wl[7]),
        .I2(\win_wl[11]_i_17_n_0 ),
        .I3(\win_wl[7]_i_2_n_0 ),
        .O(\win_wl[7]_i_6_n_0 ));
  (* HLUTNM = "lutpair25" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \win_wl[7]_i_7 
       (.I0(\win_wl[7]_i_10_n_0 ),
        .I1(win_wl[6]),
        .I2(\win_wl[7]_i_11_n_0 ),
        .I3(\win_wl[7]_i_3_n_0 ),
        .O(\win_wl[7]_i_7_n_0 ));
  (* HLUTNM = "lutpair24" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \win_wl[7]_i_8 
       (.I0(\win_wl[7]_i_12_n_0 ),
        .I1(win_wl[5]),
        .I2(\win_wl[7]_i_13_n_0 ),
        .I3(\win_wl[7]_i_4_n_0 ),
        .O(\win_wl[7]_i_8_n_0 ));
  (* HLUTNM = "lutpair23" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \win_wl[7]_i_9 
       (.I0(\win_wl[7]_i_14_n_0 ),
        .I1(win_wl[4]),
        .I2(\win_wl[7]_i_15_n_0 ),
        .I3(\win_wl[7]_i_5_n_0 ),
        .O(\win_wl[7]_i_9_n_0 ));
  FDRE \win_wl_reg[0] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[3]_i_1_n_7 ),
        .Q(win_wl[0]),
        .R(clear));
  FDRE \win_wl_reg[10] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[11]_i_1_n_5 ),
        .Q(win_wl[10]),
        .R(clear));
  FDRE \win_wl_reg[11] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[11]_i_1_n_4 ),
        .Q(win_wl[11]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \win_wl_reg[11]_i_1 
       (.CI(\win_wl_reg[7]_i_1_n_0 ),
        .CO({\win_wl_reg[11]_i_1_n_0 ,\win_wl_reg[11]_i_1_n_1 ,\win_wl_reg[11]_i_1_n_2 ,\win_wl_reg[11]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\win_wl[11]_i_2_n_0 ,\win_wl[11]_i_3_n_0 ,\win_wl[11]_i_4_n_0 ,\win_wl[11]_i_5_n_0 }),
        .O({\win_wl_reg[11]_i_1_n_4 ,\win_wl_reg[11]_i_1_n_5 ,\win_wl_reg[11]_i_1_n_6 ,\win_wl_reg[11]_i_1_n_7 }),
        .S({\win_wl[11]_i_6_n_0 ,\win_wl[11]_i_7_n_0 ,\win_wl[11]_i_8_n_0 ,\win_wl[11]_i_9_n_0 }));
  FDRE \win_wl_reg[12] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[15]_i_1_n_7 ),
        .Q(win_wl[12]),
        .R(clear));
  FDRE \win_wl_reg[13] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[15]_i_1_n_6 ),
        .Q(win_wl[13]),
        .R(clear));
  FDRE \win_wl_reg[14] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[15]_i_1_n_5 ),
        .Q(win_wl[14]),
        .R(clear));
  FDRE \win_wl_reg[15] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[15]_i_1_n_4 ),
        .Q(win_wl[15]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \win_wl_reg[15]_i_1 
       (.CI(\win_wl_reg[11]_i_1_n_0 ),
        .CO({\win_wl_reg[15]_i_1_n_0 ,\win_wl_reg[15]_i_1_n_1 ,\win_wl_reg[15]_i_1_n_2 ,\win_wl_reg[15]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\win_wl[15]_i_2_n_0 ,\win_wl[15]_i_3_n_0 ,\win_wl[15]_i_4_n_0 ,\win_wl[15]_i_5_n_0 }),
        .O({\win_wl_reg[15]_i_1_n_4 ,\win_wl_reg[15]_i_1_n_5 ,\win_wl_reg[15]_i_1_n_6 ,\win_wl_reg[15]_i_1_n_7 }),
        .S({\win_wl[15]_i_6_n_0 ,\win_wl[15]_i_7_n_0 ,\win_wl[15]_i_8_n_0 ,\win_wl[15]_i_9_n_0 }));
  FDRE \win_wl_reg[16] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[19]_i_1_n_7 ),
        .Q(win_wl[16]),
        .R(clear));
  FDRE \win_wl_reg[17] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[19]_i_1_n_6 ),
        .Q(win_wl[17]),
        .R(clear));
  FDRE \win_wl_reg[18] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[19]_i_1_n_5 ),
        .Q(win_wl[18]),
        .R(clear));
  FDRE \win_wl_reg[19] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[19]_i_1_n_4 ),
        .Q(win_wl[19]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \win_wl_reg[19]_i_1 
       (.CI(\win_wl_reg[15]_i_1_n_0 ),
        .CO({\win_wl_reg[19]_i_1_n_0 ,\win_wl_reg[19]_i_1_n_1 ,\win_wl_reg[19]_i_1_n_2 ,\win_wl_reg[19]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\win_wl[19]_i_2_n_0 ,\win_wl[19]_i_3_n_0 ,\win_wl[19]_i_4_n_0 ,\win_wl[19]_i_5_n_0 }),
        .O({\win_wl_reg[19]_i_1_n_4 ,\win_wl_reg[19]_i_1_n_5 ,\win_wl_reg[19]_i_1_n_6 ,\win_wl_reg[19]_i_1_n_7 }),
        .S({\win_wl[19]_i_6_n_0 ,\win_wl[19]_i_7_n_0 ,\win_wl[19]_i_8_n_0 ,\win_wl[19]_i_9_n_0 }));
  FDRE \win_wl_reg[1] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[3]_i_1_n_6 ),
        .Q(win_wl[1]),
        .R(clear));
  FDRE \win_wl_reg[20] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[23]_i_1_n_7 ),
        .Q(win_wl[20]),
        .R(clear));
  FDRE \win_wl_reg[21] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[23]_i_1_n_6 ),
        .Q(win_wl[21]),
        .R(clear));
  FDRE \win_wl_reg[22] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[23]_i_1_n_5 ),
        .Q(win_wl[22]),
        .R(clear));
  FDRE \win_wl_reg[23] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[23]_i_1_n_4 ),
        .Q(win_wl[23]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \win_wl_reg[23]_i_1 
       (.CI(\win_wl_reg[19]_i_1_n_0 ),
        .CO({\win_wl_reg[23]_i_1_n_0 ,\win_wl_reg[23]_i_1_n_1 ,\win_wl_reg[23]_i_1_n_2 ,\win_wl_reg[23]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\win_wl[23]_i_2_n_0 ,\win_wl[23]_i_3_n_0 ,\win_wl[23]_i_4_n_0 ,\win_wl[23]_i_5_n_0 }),
        .O({\win_wl_reg[23]_i_1_n_4 ,\win_wl_reg[23]_i_1_n_5 ,\win_wl_reg[23]_i_1_n_6 ,\win_wl_reg[23]_i_1_n_7 }),
        .S({\win_wl[23]_i_6_n_0 ,\win_wl[23]_i_7_n_0 ,\win_wl[23]_i_8_n_0 ,\win_wl[23]_i_9_n_0 }));
  FDRE \win_wl_reg[24] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[27]_i_1_n_7 ),
        .Q(win_wl[24]),
        .R(clear));
  FDRE \win_wl_reg[25] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[27]_i_1_n_6 ),
        .Q(win_wl[25]),
        .R(clear));
  FDRE \win_wl_reg[26] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[27]_i_1_n_5 ),
        .Q(win_wl[26]),
        .R(clear));
  FDRE \win_wl_reg[27] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[27]_i_1_n_4 ),
        .Q(win_wl[27]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \win_wl_reg[27]_i_1 
       (.CI(\win_wl_reg[23]_i_1_n_0 ),
        .CO({\win_wl_reg[27]_i_1_n_0 ,\win_wl_reg[27]_i_1_n_1 ,\win_wl_reg[27]_i_1_n_2 ,\win_wl_reg[27]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\win_wl[27]_i_2_n_0 ,\win_wl[27]_i_3_n_0 ,\win_wl[27]_i_4_n_0 ,\win_wl[27]_i_5_n_0 }),
        .O({\win_wl_reg[27]_i_1_n_4 ,\win_wl_reg[27]_i_1_n_5 ,\win_wl_reg[27]_i_1_n_6 ,\win_wl_reg[27]_i_1_n_7 }),
        .S({\win_wl[27]_i_6_n_0 ,\win_wl[27]_i_7_n_0 ,\win_wl[27]_i_8_n_0 ,\win_wl[27]_i_9_n_0 }));
  FDRE \win_wl_reg[28] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[31]_i_1_n_7 ),
        .Q(win_wl[28]),
        .R(clear));
  FDRE \win_wl_reg[29] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[31]_i_1_n_6 ),
        .Q(win_wl[29]),
        .R(clear));
  FDRE \win_wl_reg[2] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[3]_i_1_n_5 ),
        .Q(win_wl[2]),
        .R(clear));
  FDRE \win_wl_reg[30] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[31]_i_1_n_5 ),
        .Q(win_wl[30]),
        .R(clear));
  FDRE \win_wl_reg[31] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[31]_i_1_n_4 ),
        .Q(win_wl[31]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \win_wl_reg[31]_i_1 
       (.CI(\win_wl_reg[27]_i_1_n_0 ),
        .CO({\win_wl_reg[31]_i_1_n_0 ,\win_wl_reg[31]_i_1_n_1 ,\win_wl_reg[31]_i_1_n_2 ,\win_wl_reg[31]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\win_wl[31]_i_2_n_0 ,\win_wl[31]_i_3_n_0 ,\win_wl[31]_i_4_n_0 ,\win_wl[31]_i_5_n_0 }),
        .O({\win_wl_reg[31]_i_1_n_4 ,\win_wl_reg[31]_i_1_n_5 ,\win_wl_reg[31]_i_1_n_6 ,\win_wl_reg[31]_i_1_n_7 }),
        .S({\win_wl[31]_i_6_n_0 ,\win_wl[31]_i_7_n_0 ,\win_wl[31]_i_8_n_0 ,\win_wl[31]_i_9_n_0 }));
  FDRE \win_wl_reg[32] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[35]_i_1_n_7 ),
        .Q(win_wl[32]),
        .R(clear));
  FDRE \win_wl_reg[33] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[35]_i_1_n_6 ),
        .Q(win_wl[33]),
        .R(clear));
  FDRE \win_wl_reg[34] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[35]_i_1_n_5 ),
        .Q(win_wl[34]),
        .R(clear));
  FDRE \win_wl_reg[35] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[35]_i_1_n_4 ),
        .Q(win_wl[35]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \win_wl_reg[35]_i_1 
       (.CI(\win_wl_reg[31]_i_1_n_0 ),
        .CO({\win_wl_reg[35]_i_1_n_0 ,\win_wl_reg[35]_i_1_n_1 ,\win_wl_reg[35]_i_1_n_2 ,\win_wl_reg[35]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({win_wl[34:33],\win_wl[35]_i_2_n_0 ,\win_wl[35]_i_3_n_0 }),
        .O({\win_wl_reg[35]_i_1_n_4 ,\win_wl_reg[35]_i_1_n_5 ,\win_wl_reg[35]_i_1_n_6 ,\win_wl_reg[35]_i_1_n_7 }),
        .S({\win_wl[35]_i_4_n_0 ,\win_wl[35]_i_5_n_0 ,\win_wl[35]_i_6_n_0 ,\win_wl[35]_i_7_n_0 }));
  FDRE \win_wl_reg[36] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[39]_i_1_n_7 ),
        .Q(win_wl[36]),
        .R(clear));
  FDRE \win_wl_reg[37] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[39]_i_1_n_6 ),
        .Q(win_wl[37]),
        .R(clear));
  FDRE \win_wl_reg[38] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[39]_i_1_n_5 ),
        .Q(win_wl[38]),
        .R(clear));
  FDRE \win_wl_reg[39] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[39]_i_1_n_4 ),
        .Q(win_wl[39]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \win_wl_reg[39]_i_1 
       (.CI(\win_wl_reg[35]_i_1_n_0 ),
        .CO({\NLW_win_wl_reg[39]_i_1_CO_UNCONNECTED [3],\win_wl_reg[39]_i_1_n_1 ,\win_wl_reg[39]_i_1_n_2 ,\win_wl_reg[39]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,win_wl[37:35]}),
        .O({\win_wl_reg[39]_i_1_n_4 ,\win_wl_reg[39]_i_1_n_5 ,\win_wl_reg[39]_i_1_n_6 ,\win_wl_reg[39]_i_1_n_7 }),
        .S({\win_wl[39]_i_2_n_0 ,\win_wl[39]_i_3_n_0 ,\win_wl[39]_i_4_n_0 ,\win_wl[39]_i_5_n_0 }));
  FDRE \win_wl_reg[3] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[3]_i_1_n_4 ),
        .Q(win_wl[3]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \win_wl_reg[3]_i_1 
       (.CI(1'b0),
        .CO({\win_wl_reg[3]_i_1_n_0 ,\win_wl_reg[3]_i_1_n_1 ,\win_wl_reg[3]_i_1_n_2 ,\win_wl_reg[3]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\win_wl[3]_i_2_n_0 ,\win_wl[3]_i_3_n_0 ,\win_wl[3]_i_4_n_0 ,\win_wl[3]_i_5_n_0 }),
        .O({\win_wl_reg[3]_i_1_n_4 ,\win_wl_reg[3]_i_1_n_5 ,\win_wl_reg[3]_i_1_n_6 ,\win_wl_reg[3]_i_1_n_7 }),
        .S({\win_wl[3]_i_6_n_0 ,\win_wl[3]_i_7_n_0 ,\win_wl[3]_i_8_n_0 ,\win_wl[3]_i_9_n_0 }));
  FDRE \win_wl_reg[4] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[7]_i_1_n_7 ),
        .Q(win_wl[4]),
        .R(clear));
  FDRE \win_wl_reg[5] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[7]_i_1_n_6 ),
        .Q(win_wl[5]),
        .R(clear));
  FDRE \win_wl_reg[6] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[7]_i_1_n_5 ),
        .Q(win_wl[6]),
        .R(clear));
  FDRE \win_wl_reg[7] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[7]_i_1_n_4 ),
        .Q(win_wl[7]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \win_wl_reg[7]_i_1 
       (.CI(\win_wl_reg[3]_i_1_n_0 ),
        .CO({\win_wl_reg[7]_i_1_n_0 ,\win_wl_reg[7]_i_1_n_1 ,\win_wl_reg[7]_i_1_n_2 ,\win_wl_reg[7]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\win_wl[7]_i_2_n_0 ,\win_wl[7]_i_3_n_0 ,\win_wl[7]_i_4_n_0 ,\win_wl[7]_i_5_n_0 }),
        .O({\win_wl_reg[7]_i_1_n_4 ,\win_wl_reg[7]_i_1_n_5 ,\win_wl_reg[7]_i_1_n_6 ,\win_wl_reg[7]_i_1_n_7 }),
        .S({\win_wl[7]_i_6_n_0 ,\win_wl[7]_i_7_n_0 ,\win_wl[7]_i_8_n_0 ,\win_wl[7]_i_9_n_0 }));
  FDRE \win_wl_reg[8] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[11]_i_1_n_7 ),
        .Q(win_wl[8]),
        .R(clear));
  FDRE \win_wl_reg[9] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_wl_reg[11]_i_1_n_6 ),
        .Q(win_wl[9]),
        .R(clear));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_zc[3]_i_10 
       (.I0(\ring_zc_reg[2] [1]),
        .I1(\ring_zc_reg[3] [1]),
        .I2(\ring_zc_reg[0] [1]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_zc_reg[1] [1]),
        .O(ring_zc[1]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_zc[3]_i_11 
       (.I0(\ring_zc_reg[2] [0]),
        .I1(\ring_zc_reg[3] [0]),
        .I2(\ring_zc_reg[0] [0]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_zc_reg[1] [0]),
        .O(ring_zc[0]));
  LUT3 #(
    .INIT(8'h69)) 
    \win_zc[3]_i_12 
       (.I0(win_zc[3]),
        .I1(ring_zc[3]),
        .I2(seg_zc_reg[3]),
        .O(\win_zc[3]_i_12_n_0 ));
  LUT3 #(
    .INIT(8'h69)) 
    \win_zc[3]_i_13 
       (.I0(win_zc[2]),
        .I1(ring_zc[2]),
        .I2(seg_zc_reg[2]),
        .O(\win_zc[3]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'h6900000069696900)) 
    \win_zc[3]_i_2 
       (.I0(seg_zc_reg[2]),
        .I1(ring_zc[2]),
        .I2(win_zc[2]),
        .I3(seg_zc_reg[1]),
        .I4(win_zc[1]),
        .I5(ring_zc[1]),
        .O(\win_zc[3]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h08808008)) 
    \win_zc[3]_i_3 
       (.I0(seg_zc_reg[0]),
        .I1(win_zc[0]),
        .I2(seg_zc_reg[1]),
        .I3(ring_zc[1]),
        .I4(win_zc[1]),
        .O(\win_zc[3]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'h96696969)) 
    \win_zc[3]_i_4 
       (.I0(seg_zc_reg[1]),
        .I1(ring_zc[1]),
        .I2(win_zc[1]),
        .I3(win_zc[0]),
        .I4(seg_zc_reg[0]),
        .O(\win_zc[3]_i_4_n_0 ));
  LUT5 #(
    .INIT(32'h9FFF6000)) 
    \win_zc[3]_i_5 
       (.I0(sample_in[23]),
        .I1(p_0_in0_in),
        .I2(have_prev),
        .I3(zc_event1),
        .I4(ring_zc[0]),
        .O(\win_zc[3]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'h99696966)) 
    \win_zc[3]_i_6 
       (.I0(\win_zc[3]_i_2_n_0 ),
        .I1(\win_zc[3]_i_12_n_0 ),
        .I2(ring_zc[2]),
        .I3(win_zc[2]),
        .I4(seg_zc_reg[2]),
        .O(\win_zc[3]_i_6_n_0 ));
  LUT5 #(
    .INIT(32'h99696966)) 
    \win_zc[3]_i_7 
       (.I0(\win_zc[3]_i_3_n_0 ),
        .I1(\win_zc[3]_i_13_n_0 ),
        .I2(ring_zc[1]),
        .I3(win_zc[1]),
        .I4(seg_zc_reg[1]),
        .O(\win_zc[3]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h9999599959999999)) 
    \win_zc[3]_i_8 
       (.I0(\win_zc[3]_i_4_n_0 ),
        .I1(ring_zc[0]),
        .I2(zc_event1),
        .I3(have_prev),
        .I4(p_0_in0_in),
        .I5(sample_in[23]),
        .O(\win_zc[3]_i_8_n_0 ));
  LUT3 #(
    .INIT(8'h96)) 
    \win_zc[3]_i_9 
       (.I0(\win_zc[3]_i_5_n_0 ),
        .I1(seg_zc_reg[0]),
        .I2(win_zc[0]),
        .O(\win_zc[3]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_zc[7]_i_10 
       (.I0(\ring_zc_reg[2] [5]),
        .I1(\ring_zc_reg[3] [5]),
        .I2(\ring_zc_reg[0] [5]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_zc_reg[1] [5]),
        .O(ring_zc[5]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_zc[7]_i_11 
       (.I0(\ring_zc_reg[2] [4]),
        .I1(\ring_zc_reg[3] [4]),
        .I2(\ring_zc_reg[0] [4]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_zc_reg[1] [4]),
        .O(ring_zc[4]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_zc[7]_i_12 
       (.I0(\ring_zc_reg[2] [3]),
        .I1(\ring_zc_reg[3] [3]),
        .I2(\ring_zc_reg[0] [3]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_zc_reg[1] [3]),
        .O(ring_zc[3]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_zc[7]_i_13 
       (.I0(\ring_zc_reg[2] [2]),
        .I1(\ring_zc_reg[3] [2]),
        .I2(\ring_zc_reg[0] [2]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_zc_reg[1] [2]),
        .O(ring_zc[2]));
  (* SOFT_HLUTNM = "soft_lutpair119" *) 
  LUT3 #(
    .INIT(8'hD4)) 
    \win_zc[7]_i_14 
       (.I0(ring_zc[5]),
        .I1(win_zc[5]),
        .I2(seg_zc_reg[5]),
        .O(\win_zc[7]_i_14_n_0 ));
  LUT3 #(
    .INIT(8'h69)) 
    \win_zc[7]_i_15 
       (.I0(win_zc[6]),
        .I1(ring_zc[6]),
        .I2(seg_zc_reg[6]),
        .O(\win_zc[7]_i_15_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair119" *) 
  LUT3 #(
    .INIT(8'h69)) 
    \win_zc[7]_i_16 
       (.I0(win_zc[5]),
        .I1(ring_zc[5]),
        .I2(seg_zc_reg[5]),
        .O(\win_zc[7]_i_16_n_0 ));
  LUT3 #(
    .INIT(8'h69)) 
    \win_zc[7]_i_17 
       (.I0(win_zc[4]),
        .I1(ring_zc[4]),
        .I2(seg_zc_reg[4]),
        .O(\win_zc[7]_i_17_n_0 ));
  LUT6 #(
    .INIT(64'h6900000069696900)) 
    \win_zc[7]_i_2 
       (.I0(seg_zc_reg[6]),
        .I1(ring_zc[6]),
        .I2(win_zc[6]),
        .I3(seg_zc_reg[5]),
        .I4(win_zc[5]),
        .I5(ring_zc[5]),
        .O(\win_zc[7]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h6900000069696900)) 
    \win_zc[7]_i_3 
       (.I0(seg_zc_reg[5]),
        .I1(ring_zc[5]),
        .I2(win_zc[5]),
        .I3(seg_zc_reg[4]),
        .I4(win_zc[4]),
        .I5(ring_zc[4]),
        .O(\win_zc[7]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h6900000069696900)) 
    \win_zc[7]_i_4 
       (.I0(seg_zc_reg[4]),
        .I1(ring_zc[4]),
        .I2(win_zc[4]),
        .I3(seg_zc_reg[3]),
        .I4(win_zc[3]),
        .I5(ring_zc[3]),
        .O(\win_zc[7]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h6900000069696900)) 
    \win_zc[7]_i_5 
       (.I0(seg_zc_reg[3]),
        .I1(ring_zc[3]),
        .I2(win_zc[3]),
        .I3(seg_zc_reg[2]),
        .I4(win_zc[2]),
        .I5(ring_zc[2]),
        .O(\win_zc[7]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'hC69C9C39)) 
    \win_zc[7]_i_6 
       (.I0(\win_zc[7]_i_14_n_0 ),
        .I1(win_zc[7]),
        .I2(ring_zc[6]),
        .I3(win_zc[6]),
        .I4(seg_zc_reg[6]),
        .O(\win_zc[7]_i_6_n_0 ));
  LUT5 #(
    .INIT(32'h99696966)) 
    \win_zc[7]_i_7 
       (.I0(\win_zc[7]_i_3_n_0 ),
        .I1(\win_zc[7]_i_15_n_0 ),
        .I2(ring_zc[5]),
        .I3(win_zc[5]),
        .I4(seg_zc_reg[5]),
        .O(\win_zc[7]_i_7_n_0 ));
  LUT5 #(
    .INIT(32'h99696966)) 
    \win_zc[7]_i_8 
       (.I0(\win_zc[7]_i_4_n_0 ),
        .I1(\win_zc[7]_i_16_n_0 ),
        .I2(ring_zc[4]),
        .I3(win_zc[4]),
        .I4(seg_zc_reg[4]),
        .O(\win_zc[7]_i_8_n_0 ));
  LUT5 #(
    .INIT(32'h99696966)) 
    \win_zc[7]_i_9 
       (.I0(\win_zc[7]_i_5_n_0 ),
        .I1(\win_zc[7]_i_17_n_0 ),
        .I2(ring_zc[3]),
        .I3(win_zc[3]),
        .I4(seg_zc_reg[3]),
        .O(\win_zc[7]_i_9_n_0 ));
  LUT5 #(
    .INIT(32'hFBBA0445)) 
    \win_zc[8]_i_2 
       (.I0(win_zc[7]),
        .I1(ring_zc[6]),
        .I2(win_zc[6]),
        .I3(seg_zc_reg[6]),
        .I4(win_zc[8]),
        .O(\win_zc[8]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \win_zc[8]_i_3 
       (.I0(\ring_zc_reg[2] [6]),
        .I1(\ring_zc_reg[3] [6]),
        .I2(\ring_zc_reg[0] [6]),
        .I3(wr_ptr[1]),
        .I4(wr_ptr[0]),
        .I5(\ring_zc_reg[1] [6]),
        .O(ring_zc[6]));
  FDRE \win_zc_reg[0] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_zc_reg[3]_i_1_n_7 ),
        .Q(win_zc[0]),
        .R(clear));
  FDRE \win_zc_reg[1] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_zc_reg[3]_i_1_n_6 ),
        .Q(win_zc[1]),
        .R(clear));
  FDRE \win_zc_reg[2] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_zc_reg[3]_i_1_n_5 ),
        .Q(win_zc[2]),
        .R(clear));
  FDRE \win_zc_reg[3] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_zc_reg[3]_i_1_n_4 ),
        .Q(win_zc[3]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \win_zc_reg[3]_i_1 
       (.CI(1'b0),
        .CO({\win_zc_reg[3]_i_1_n_0 ,\win_zc_reg[3]_i_1_n_1 ,\win_zc_reg[3]_i_1_n_2 ,\win_zc_reg[3]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\win_zc[3]_i_2_n_0 ,\win_zc[3]_i_3_n_0 ,\win_zc[3]_i_4_n_0 ,\win_zc[3]_i_5_n_0 }),
        .O({\win_zc_reg[3]_i_1_n_4 ,\win_zc_reg[3]_i_1_n_5 ,\win_zc_reg[3]_i_1_n_6 ,\win_zc_reg[3]_i_1_n_7 }),
        .S({\win_zc[3]_i_6_n_0 ,\win_zc[3]_i_7_n_0 ,\win_zc[3]_i_8_n_0 ,\win_zc[3]_i_9_n_0 }));
  FDRE \win_zc_reg[4] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_zc_reg[7]_i_1_n_7 ),
        .Q(win_zc[4]),
        .R(clear));
  FDRE \win_zc_reg[5] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_zc_reg[7]_i_1_n_6 ),
        .Q(win_zc[5]),
        .R(clear));
  FDRE \win_zc_reg[6] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_zc_reg[7]_i_1_n_5 ),
        .Q(win_zc[6]),
        .R(clear));
  FDRE \win_zc_reg[7] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_zc_reg[7]_i_1_n_4 ),
        .Q(win_zc[7]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \win_zc_reg[7]_i_1 
       (.CI(\win_zc_reg[3]_i_1_n_0 ),
        .CO({\win_zc_reg[7]_i_1_n_0 ,\win_zc_reg[7]_i_1_n_1 ,\win_zc_reg[7]_i_1_n_2 ,\win_zc_reg[7]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\win_zc[7]_i_2_n_0 ,\win_zc[7]_i_3_n_0 ,\win_zc[7]_i_4_n_0 ,\win_zc[7]_i_5_n_0 }),
        .O({\win_zc_reg[7]_i_1_n_4 ,\win_zc_reg[7]_i_1_n_5 ,\win_zc_reg[7]_i_1_n_6 ,\win_zc_reg[7]_i_1_n_7 }),
        .S({\win_zc[7]_i_6_n_0 ,\win_zc[7]_i_7_n_0 ,\win_zc[7]_i_8_n_0 ,\win_zc[7]_i_9_n_0 }));
  FDRE \win_zc_reg[8] 
       (.C(clk),
        .CE(win_mav),
        .D(\win_zc_reg[8]_i_1_n_7 ),
        .Q(win_zc[8]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \win_zc_reg[8]_i_1 
       (.CI(\win_zc_reg[7]_i_1_n_0 ),
        .CO(\NLW_win_zc_reg[8]_i_1_CO_UNCONNECTED [3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\NLW_win_zc_reg[8]_i_1_O_UNCONNECTED [3:1],\win_zc_reg[8]_i_1_n_7 }),
        .S({1'b0,1'b0,1'b0,\win_zc[8]_i_2_n_0 }));
  (* SOFT_HLUTNM = "soft_lutpair47" *) 
  LUT3 #(
    .INIT(8'h80)) 
    window_valid_i_1
       (.I0(rst_n),
        .I1(sample_valid),
        .I2(window_valid0),
        .O(window_valid_i_1_n_0));
  LUT6 #(
    .INIT(64'h44444444C0000000)) 
    window_valid_i_2
       (.I0(prime_count),
        .I1(window_valid13_in),
        .I2(window_valid_i_3_n_0),
        .I3(window_valid_i_4_n_0),
        .I4(\hop_count_reg_n_0_[0] ),
        .I5(priming_reg_n_0),
        .O(window_valid0));
  LUT4 #(
    .INIT(16'h0008)) 
    window_valid_i_3
       (.I0(\hop_count_reg_n_0_[6] ),
        .I1(\hop_count_reg_n_0_[5] ),
        .I2(\hop_count_reg_n_0_[4] ),
        .I3(\hop_count_reg_n_0_[3] ),
        .O(window_valid_i_3_n_0));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h2)) 
    window_valid_i_4
       (.I0(\hop_count_reg_n_0_[1] ),
        .I1(\hop_count_reg_n_0_[2] ),
        .O(window_valid_i_4_n_0));
  FDRE window_valid_reg
       (.C(clk),
        .CE(1'b1),
        .D(window_valid_i_1_n_0),
        .Q(window_valid),
        .R(1'b0));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \wl_sum[0]_i_1 
       (.I0(rst_n),
        .I1(\wl_sum_reg[31]_i_2_n_3 ),
        .I2(\wl_sum_reg[31]_i_3_n_3 ),
        .I3(next_wl[0]),
        .I4(window_valid13_in),
        .I5(\win_wl_reg[3]_i_1_n_7 ),
        .O(\wl_sum[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \wl_sum[10]_i_1 
       (.I0(rst_n),
        .I1(\wl_sum_reg[31]_i_2_n_3 ),
        .I2(\wl_sum_reg[31]_i_3_n_3 ),
        .I3(next_wl[10]),
        .I4(window_valid13_in),
        .I5(\win_wl_reg[11]_i_1_n_5 ),
        .O(\wl_sum[10]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \wl_sum[11]_i_1 
       (.I0(rst_n),
        .I1(\wl_sum_reg[31]_i_2_n_3 ),
        .I2(\wl_sum_reg[31]_i_3_n_3 ),
        .I3(next_wl[11]),
        .I4(window_valid13_in),
        .I5(\win_wl_reg[11]_i_1_n_4 ),
        .O(\wl_sum[11]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \wl_sum[12]_i_1 
       (.I0(rst_n),
        .I1(\wl_sum_reg[31]_i_2_n_3 ),
        .I2(\wl_sum_reg[31]_i_3_n_3 ),
        .I3(next_wl[12]),
        .I4(window_valid13_in),
        .I5(\win_wl_reg[15]_i_1_n_7 ),
        .O(\wl_sum[12]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \wl_sum[13]_i_1 
       (.I0(rst_n),
        .I1(\wl_sum_reg[31]_i_2_n_3 ),
        .I2(\wl_sum_reg[31]_i_3_n_3 ),
        .I3(next_wl[13]),
        .I4(window_valid13_in),
        .I5(\win_wl_reg[15]_i_1_n_6 ),
        .O(\wl_sum[13]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \wl_sum[14]_i_1 
       (.I0(rst_n),
        .I1(\wl_sum_reg[31]_i_2_n_3 ),
        .I2(\wl_sum_reg[31]_i_3_n_3 ),
        .I3(next_wl[14]),
        .I4(window_valid13_in),
        .I5(\win_wl_reg[15]_i_1_n_5 ),
        .O(\wl_sum[14]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \wl_sum[15]_i_1 
       (.I0(rst_n),
        .I1(\wl_sum_reg[31]_i_2_n_3 ),
        .I2(\wl_sum_reg[31]_i_3_n_3 ),
        .I3(next_wl[15]),
        .I4(window_valid13_in),
        .I5(\win_wl_reg[15]_i_1_n_4 ),
        .O(\wl_sum[15]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \wl_sum[16]_i_1 
       (.I0(rst_n),
        .I1(\wl_sum_reg[31]_i_2_n_3 ),
        .I2(\wl_sum_reg[31]_i_3_n_3 ),
        .I3(next_wl[16]),
        .I4(window_valid13_in),
        .I5(\win_wl_reg[19]_i_1_n_7 ),
        .O(\wl_sum[16]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \wl_sum[17]_i_1 
       (.I0(rst_n),
        .I1(\wl_sum_reg[31]_i_2_n_3 ),
        .I2(\wl_sum_reg[31]_i_3_n_3 ),
        .I3(next_wl[17]),
        .I4(window_valid13_in),
        .I5(\win_wl_reg[19]_i_1_n_6 ),
        .O(\wl_sum[17]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \wl_sum[18]_i_1 
       (.I0(rst_n),
        .I1(\wl_sum_reg[31]_i_2_n_3 ),
        .I2(\wl_sum_reg[31]_i_3_n_3 ),
        .I3(next_wl[18]),
        .I4(window_valid13_in),
        .I5(\win_wl_reg[19]_i_1_n_5 ),
        .O(\wl_sum[18]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \wl_sum[19]_i_1 
       (.I0(rst_n),
        .I1(\wl_sum_reg[31]_i_2_n_3 ),
        .I2(\wl_sum_reg[31]_i_3_n_3 ),
        .I3(next_wl[19]),
        .I4(window_valid13_in),
        .I5(\win_wl_reg[19]_i_1_n_4 ),
        .O(\wl_sum[19]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \wl_sum[1]_i_1 
       (.I0(rst_n),
        .I1(\wl_sum_reg[31]_i_2_n_3 ),
        .I2(\wl_sum_reg[31]_i_3_n_3 ),
        .I3(next_wl[1]),
        .I4(window_valid13_in),
        .I5(\win_wl_reg[3]_i_1_n_6 ),
        .O(\wl_sum[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \wl_sum[20]_i_1 
       (.I0(rst_n),
        .I1(\wl_sum_reg[31]_i_2_n_3 ),
        .I2(\wl_sum_reg[31]_i_3_n_3 ),
        .I3(next_wl[20]),
        .I4(window_valid13_in),
        .I5(\win_wl_reg[23]_i_1_n_7 ),
        .O(\wl_sum[20]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \wl_sum[21]_i_1 
       (.I0(rst_n),
        .I1(\wl_sum_reg[31]_i_2_n_3 ),
        .I2(\wl_sum_reg[31]_i_3_n_3 ),
        .I3(next_wl[21]),
        .I4(window_valid13_in),
        .I5(\win_wl_reg[23]_i_1_n_6 ),
        .O(\wl_sum[21]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \wl_sum[22]_i_1 
       (.I0(rst_n),
        .I1(\wl_sum_reg[31]_i_2_n_3 ),
        .I2(\wl_sum_reg[31]_i_3_n_3 ),
        .I3(next_wl[22]),
        .I4(window_valid13_in),
        .I5(\win_wl_reg[23]_i_1_n_5 ),
        .O(\wl_sum[22]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \wl_sum[23]_i_1 
       (.I0(rst_n),
        .I1(\wl_sum_reg[31]_i_2_n_3 ),
        .I2(\wl_sum_reg[31]_i_3_n_3 ),
        .I3(next_wl[23]),
        .I4(window_valid13_in),
        .I5(\win_wl_reg[23]_i_1_n_4 ),
        .O(\wl_sum[23]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \wl_sum[24]_i_1 
       (.I0(rst_n),
        .I1(\wl_sum_reg[31]_i_2_n_3 ),
        .I2(\wl_sum_reg[31]_i_3_n_3 ),
        .I3(next_wl[24]),
        .I4(window_valid13_in),
        .I5(\win_wl_reg[27]_i_1_n_7 ),
        .O(\wl_sum[24]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \wl_sum[25]_i_1 
       (.I0(rst_n),
        .I1(\wl_sum_reg[31]_i_2_n_3 ),
        .I2(\wl_sum_reg[31]_i_3_n_3 ),
        .I3(next_wl[25]),
        .I4(window_valid13_in),
        .I5(\win_wl_reg[27]_i_1_n_6 ),
        .O(\wl_sum[25]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \wl_sum[26]_i_1 
       (.I0(rst_n),
        .I1(\wl_sum_reg[31]_i_2_n_3 ),
        .I2(\wl_sum_reg[31]_i_3_n_3 ),
        .I3(next_wl[26]),
        .I4(window_valid13_in),
        .I5(\win_wl_reg[27]_i_1_n_5 ),
        .O(\wl_sum[26]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \wl_sum[27]_i_1 
       (.I0(rst_n),
        .I1(\wl_sum_reg[31]_i_2_n_3 ),
        .I2(\wl_sum_reg[31]_i_3_n_3 ),
        .I3(next_wl[27]),
        .I4(window_valid13_in),
        .I5(\win_wl_reg[27]_i_1_n_4 ),
        .O(\wl_sum[27]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \wl_sum[28]_i_1 
       (.I0(rst_n),
        .I1(\wl_sum_reg[31]_i_2_n_3 ),
        .I2(\wl_sum_reg[31]_i_3_n_3 ),
        .I3(next_wl[28]),
        .I4(window_valid13_in),
        .I5(\win_wl_reg[31]_i_1_n_7 ),
        .O(\wl_sum[28]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \wl_sum[29]_i_1 
       (.I0(rst_n),
        .I1(\wl_sum_reg[31]_i_2_n_3 ),
        .I2(\wl_sum_reg[31]_i_3_n_3 ),
        .I3(next_wl[29]),
        .I4(window_valid13_in),
        .I5(\win_wl_reg[31]_i_1_n_6 ),
        .O(\wl_sum[29]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \wl_sum[2]_i_1 
       (.I0(rst_n),
        .I1(\wl_sum_reg[31]_i_2_n_3 ),
        .I2(\wl_sum_reg[31]_i_3_n_3 ),
        .I3(next_wl[2]),
        .I4(window_valid13_in),
        .I5(\win_wl_reg[3]_i_1_n_5 ),
        .O(\wl_sum[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \wl_sum[30]_i_1 
       (.I0(rst_n),
        .I1(\wl_sum_reg[31]_i_2_n_3 ),
        .I2(\wl_sum_reg[31]_i_3_n_3 ),
        .I3(next_wl[30]),
        .I4(window_valid13_in),
        .I5(\win_wl_reg[31]_i_1_n_5 ),
        .O(\wl_sum[30]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h4440FFFF44400000)) 
    \wl_sum[31]_i_1 
       (.I0(\wl_sum_reg[31]_i_2_n_3 ),
        .I1(rst_n),
        .I2(\next_wl[31]_i_1_n_0 ),
        .I3(\wl_sum_reg[31]_i_3_n_3 ),
        .I4(\mav_sum[30]_i_1_n_0 ),
        .I5(wl_sum[31]),
        .O(\wl_sum[31]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    \wl_sum[31]_i_10 
       (.I0(\win_wl_reg[39]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_wl[36]),
        .I3(\win_wl_reg[39]_i_1_n_6 ),
        .I4(next_wl[37]),
        .O(\wl_sum[31]_i_10_n_0 ));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    \wl_sum[31]_i_11 
       (.I0(\win_wl_reg[35]_i_1_n_5 ),
        .I1(window_valid13_in),
        .I2(next_wl[34]),
        .I3(\win_wl_reg[35]_i_1_n_4 ),
        .I4(next_wl[35]),
        .O(\wl_sum[31]_i_11_n_0 ));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    \wl_sum[31]_i_12 
       (.I0(\win_wl_reg[35]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(next_wl[32]),
        .I3(\win_wl_reg[35]_i_1_n_6 ),
        .I4(next_wl[33]),
        .O(\wl_sum[31]_i_12_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \wl_sum[31]_i_13 
       (.I0(\win_wl_reg[31]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_wl[31]),
        .O(\wl_sum[31]_i_13_n_0 ));
  LUT5 #(
    .INIT(32'h00053305)) 
    \wl_sum[31]_i_14 
       (.I0(next_wl[37]),
        .I1(\win_wl_reg[39]_i_1_n_6 ),
        .I2(next_wl[36]),
        .I3(window_valid13_in),
        .I4(\win_wl_reg[39]_i_1_n_7 ),
        .O(\wl_sum[31]_i_14_n_0 ));
  LUT5 #(
    .INIT(32'h00053305)) 
    \wl_sum[31]_i_15 
       (.I0(next_wl[35]),
        .I1(\win_wl_reg[35]_i_1_n_4 ),
        .I2(next_wl[34]),
        .I3(window_valid13_in),
        .I4(\win_wl_reg[35]_i_1_n_5 ),
        .O(\wl_sum[31]_i_15_n_0 ));
  LUT5 #(
    .INIT(32'h00053305)) 
    \wl_sum[31]_i_16 
       (.I0(next_wl[33]),
        .I1(\win_wl_reg[35]_i_1_n_6 ),
        .I2(next_wl[32]),
        .I3(window_valid13_in),
        .I4(\win_wl_reg[35]_i_1_n_7 ),
        .O(\wl_sum[31]_i_16_n_0 ));
  LUT5 #(
    .INIT(32'h000ACC0A)) 
    \wl_sum[31]_i_17 
       (.I0(next_wl[30]),
        .I1(\win_wl_reg[31]_i_1_n_5 ),
        .I2(next_wl[31]),
        .I3(window_valid13_in),
        .I4(\win_wl_reg[31]_i_1_n_4 ),
        .O(\wl_sum[31]_i_17_n_0 ));
  LUT5 #(
    .INIT(32'h47CF77FF)) 
    \wl_sum[31]_i_18 
       (.I0(\win_wl_reg[39]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_wl[37]),
        .I3(\win_wl_reg[39]_i_1_n_7 ),
        .I4(next_wl[36]),
        .O(\wl_sum[31]_i_18_n_0 ));
  LUT5 #(
    .INIT(32'h47CF77FF)) 
    \wl_sum[31]_i_19 
       (.I0(\win_wl_reg[35]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(next_wl[35]),
        .I3(\win_wl_reg[35]_i_1_n_5 ),
        .I4(next_wl[34]),
        .O(\wl_sum[31]_i_19_n_0 ));
  LUT5 #(
    .INIT(32'h47CF77FF)) 
    \wl_sum[31]_i_20 
       (.I0(\win_wl_reg[35]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(next_wl[33]),
        .I3(\win_wl_reg[35]_i_1_n_7 ),
        .I4(next_wl[32]),
        .O(\wl_sum[31]_i_20_n_0 ));
  LUT3 #(
    .INIT(8'h1D)) 
    \wl_sum[31]_i_21 
       (.I0(next_wl[31]),
        .I1(window_valid13_in),
        .I2(\win_wl_reg[31]_i_1_n_4 ),
        .O(\wl_sum[31]_i_21_n_0 ));
  LUT5 #(
    .INIT(32'hCCA000A0)) 
    \wl_sum[31]_i_22 
       (.I0(next_wl[36]),
        .I1(\win_wl_reg[39]_i_1_n_7 ),
        .I2(next_wl[37]),
        .I3(window_valid13_in),
        .I4(\win_wl_reg[39]_i_1_n_6 ),
        .O(\wl_sum[31]_i_22_n_0 ));
  LUT5 #(
    .INIT(32'hCCA000A0)) 
    \wl_sum[31]_i_23 
       (.I0(next_wl[34]),
        .I1(\win_wl_reg[35]_i_1_n_5 ),
        .I2(next_wl[35]),
        .I3(window_valid13_in),
        .I4(\win_wl_reg[35]_i_1_n_4 ),
        .O(\wl_sum[31]_i_23_n_0 ));
  LUT5 #(
    .INIT(32'hCCA000A0)) 
    \wl_sum[31]_i_24 
       (.I0(next_wl[32]),
        .I1(\win_wl_reg[35]_i_1_n_7 ),
        .I2(next_wl[33]),
        .I3(window_valid13_in),
        .I4(\win_wl_reg[35]_i_1_n_6 ),
        .O(\wl_sum[31]_i_24_n_0 ));
  LUT5 #(
    .INIT(32'h000ACC0A)) 
    \wl_sum[31]_i_25 
       (.I0(next_wl[31]),
        .I1(\win_wl_reg[31]_i_1_n_4 ),
        .I2(next_wl[30]),
        .I3(window_valid13_in),
        .I4(\win_wl_reg[31]_i_1_n_5 ),
        .O(\wl_sum[31]_i_25_n_0 ));
  LUT5 #(
    .INIT(32'h000ACC0A)) 
    \wl_sum[31]_i_5 
       (.I0(next_wl[38]),
        .I1(\win_wl_reg[39]_i_1_n_5 ),
        .I2(next_wl[39]),
        .I3(window_valid13_in),
        .I4(\win_wl_reg[39]_i_1_n_4 ),
        .O(\wl_sum[31]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'h00053305)) 
    \wl_sum[31]_i_6 
       (.I0(next_wl[38]),
        .I1(\win_wl_reg[39]_i_1_n_5 ),
        .I2(next_wl[39]),
        .I3(window_valid13_in),
        .I4(\win_wl_reg[39]_i_1_n_4 ),
        .O(\wl_sum[31]_i_6_n_0 ));
  LUT5 #(
    .INIT(32'h000ACC0A)) 
    \wl_sum[31]_i_8 
       (.I0(next_wl[39]),
        .I1(\win_wl_reg[39]_i_1_n_4 ),
        .I2(next_wl[38]),
        .I3(window_valid13_in),
        .I4(\win_wl_reg[39]_i_1_n_5 ),
        .O(\wl_sum[31]_i_8_n_0 ));
  LUT5 #(
    .INIT(32'hCCA000A0)) 
    \wl_sum[31]_i_9 
       (.I0(next_wl[38]),
        .I1(\win_wl_reg[39]_i_1_n_5 ),
        .I2(next_wl[39]),
        .I3(window_valid13_in),
        .I4(\win_wl_reg[39]_i_1_n_4 ),
        .O(\wl_sum[31]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \wl_sum[3]_i_1 
       (.I0(rst_n),
        .I1(\wl_sum_reg[31]_i_2_n_3 ),
        .I2(\wl_sum_reg[31]_i_3_n_3 ),
        .I3(next_wl[3]),
        .I4(window_valid13_in),
        .I5(\win_wl_reg[3]_i_1_n_4 ),
        .O(\wl_sum[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \wl_sum[4]_i_1 
       (.I0(rst_n),
        .I1(\wl_sum_reg[31]_i_2_n_3 ),
        .I2(\wl_sum_reg[31]_i_3_n_3 ),
        .I3(next_wl[4]),
        .I4(window_valid13_in),
        .I5(\win_wl_reg[7]_i_1_n_7 ),
        .O(\wl_sum[4]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \wl_sum[5]_i_1 
       (.I0(rst_n),
        .I1(\wl_sum_reg[31]_i_2_n_3 ),
        .I2(\wl_sum_reg[31]_i_3_n_3 ),
        .I3(next_wl[5]),
        .I4(window_valid13_in),
        .I5(\win_wl_reg[7]_i_1_n_6 ),
        .O(\wl_sum[5]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \wl_sum[6]_i_1 
       (.I0(rst_n),
        .I1(\wl_sum_reg[31]_i_2_n_3 ),
        .I2(\wl_sum_reg[31]_i_3_n_3 ),
        .I3(next_wl[6]),
        .I4(window_valid13_in),
        .I5(\win_wl_reg[7]_i_1_n_5 ),
        .O(\wl_sum[6]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \wl_sum[7]_i_1 
       (.I0(rst_n),
        .I1(\wl_sum_reg[31]_i_2_n_3 ),
        .I2(\wl_sum_reg[31]_i_3_n_3 ),
        .I3(next_wl[7]),
        .I4(window_valid13_in),
        .I5(\win_wl_reg[7]_i_1_n_4 ),
        .O(\wl_sum[7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \wl_sum[8]_i_1 
       (.I0(rst_n),
        .I1(\wl_sum_reg[31]_i_2_n_3 ),
        .I2(\wl_sum_reg[31]_i_3_n_3 ),
        .I3(next_wl[8]),
        .I4(window_valid13_in),
        .I5(\win_wl_reg[11]_i_1_n_7 ),
        .O(\wl_sum[8]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \wl_sum[9]_i_1 
       (.I0(rst_n),
        .I1(\wl_sum_reg[31]_i_2_n_3 ),
        .I2(\wl_sum_reg[31]_i_3_n_3 ),
        .I3(next_wl[9]),
        .I4(window_valid13_in),
        .I5(\win_wl_reg[11]_i_1_n_6 ),
        .O(\wl_sum[9]_i_1_n_0 ));
  FDSE \wl_sum_reg[0] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\wl_sum[0]_i_1_n_0 ),
        .Q(wl_sum[0]),
        .S(1'b0));
  FDSE \wl_sum_reg[10] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\wl_sum[10]_i_1_n_0 ),
        .Q(wl_sum[10]),
        .S(1'b0));
  FDSE \wl_sum_reg[11] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\wl_sum[11]_i_1_n_0 ),
        .Q(wl_sum[11]),
        .S(1'b0));
  FDSE \wl_sum_reg[12] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\wl_sum[12]_i_1_n_0 ),
        .Q(wl_sum[12]),
        .S(1'b0));
  FDSE \wl_sum_reg[13] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\wl_sum[13]_i_1_n_0 ),
        .Q(wl_sum[13]),
        .S(1'b0));
  FDSE \wl_sum_reg[14] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\wl_sum[14]_i_1_n_0 ),
        .Q(wl_sum[14]),
        .S(1'b0));
  FDSE \wl_sum_reg[15] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\wl_sum[15]_i_1_n_0 ),
        .Q(wl_sum[15]),
        .S(1'b0));
  FDSE \wl_sum_reg[16] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\wl_sum[16]_i_1_n_0 ),
        .Q(wl_sum[16]),
        .S(1'b0));
  FDSE \wl_sum_reg[17] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\wl_sum[17]_i_1_n_0 ),
        .Q(wl_sum[17]),
        .S(1'b0));
  FDSE \wl_sum_reg[18] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\wl_sum[18]_i_1_n_0 ),
        .Q(wl_sum[18]),
        .S(1'b0));
  FDSE \wl_sum_reg[19] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\wl_sum[19]_i_1_n_0 ),
        .Q(wl_sum[19]),
        .S(1'b0));
  FDSE \wl_sum_reg[1] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\wl_sum[1]_i_1_n_0 ),
        .Q(wl_sum[1]),
        .S(1'b0));
  FDSE \wl_sum_reg[20] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\wl_sum[20]_i_1_n_0 ),
        .Q(wl_sum[20]),
        .S(1'b0));
  FDSE \wl_sum_reg[21] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\wl_sum[21]_i_1_n_0 ),
        .Q(wl_sum[21]),
        .S(1'b0));
  FDSE \wl_sum_reg[22] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\wl_sum[22]_i_1_n_0 ),
        .Q(wl_sum[22]),
        .S(1'b0));
  FDSE \wl_sum_reg[23] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\wl_sum[23]_i_1_n_0 ),
        .Q(wl_sum[23]),
        .S(1'b0));
  FDSE \wl_sum_reg[24] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\wl_sum[24]_i_1_n_0 ),
        .Q(wl_sum[24]),
        .S(1'b0));
  FDSE \wl_sum_reg[25] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\wl_sum[25]_i_1_n_0 ),
        .Q(wl_sum[25]),
        .S(1'b0));
  FDSE \wl_sum_reg[26] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\wl_sum[26]_i_1_n_0 ),
        .Q(wl_sum[26]),
        .S(1'b0));
  FDSE \wl_sum_reg[27] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\wl_sum[27]_i_1_n_0 ),
        .Q(wl_sum[27]),
        .S(1'b0));
  FDSE \wl_sum_reg[28] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\wl_sum[28]_i_1_n_0 ),
        .Q(wl_sum[28]),
        .S(1'b0));
  FDSE \wl_sum_reg[29] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\wl_sum[29]_i_1_n_0 ),
        .Q(wl_sum[29]),
        .S(1'b0));
  FDSE \wl_sum_reg[2] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\wl_sum[2]_i_1_n_0 ),
        .Q(wl_sum[2]),
        .S(1'b0));
  FDSE \wl_sum_reg[30] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\wl_sum[30]_i_1_n_0 ),
        .Q(wl_sum[30]),
        .S(1'b0));
  FDRE \wl_sum_reg[31] 
       (.C(clk),
        .CE(1'b1),
        .D(\wl_sum[31]_i_1_n_0 ),
        .Q(wl_sum[31]),
        .R(1'b0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \wl_sum_reg[31]_i_2 
       (.CI(\wl_sum_reg[31]_i_4_n_0 ),
        .CO({\NLW_wl_sum_reg[31]_i_2_CO_UNCONNECTED [3:1],\wl_sum_reg[31]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,\wl_sum[31]_i_5_n_0 }),
        .O(\NLW_wl_sum_reg[31]_i_2_O_UNCONNECTED [3:0]),
        .S({1'b0,1'b0,1'b0,\wl_sum[31]_i_6_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \wl_sum_reg[31]_i_3 
       (.CI(\wl_sum_reg[31]_i_7_n_0 ),
        .CO({\NLW_wl_sum_reg[31]_i_3_CO_UNCONNECTED [3:1],\wl_sum_reg[31]_i_3_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,\wl_sum[31]_i_8_n_0 }),
        .O(\NLW_wl_sum_reg[31]_i_3_O_UNCONNECTED [3:0]),
        .S({1'b0,1'b0,1'b0,\wl_sum[31]_i_9_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \wl_sum_reg[31]_i_4 
       (.CI(1'b0),
        .CO({\wl_sum_reg[31]_i_4_n_0 ,\wl_sum_reg[31]_i_4_n_1 ,\wl_sum_reg[31]_i_4_n_2 ,\wl_sum_reg[31]_i_4_n_3 }),
        .CYINIT(1'b0),
        .DI({\wl_sum[31]_i_10_n_0 ,\wl_sum[31]_i_11_n_0 ,\wl_sum[31]_i_12_n_0 ,\wl_sum[31]_i_13_n_0 }),
        .O(\NLW_wl_sum_reg[31]_i_4_O_UNCONNECTED [3:0]),
        .S({\wl_sum[31]_i_14_n_0 ,\wl_sum[31]_i_15_n_0 ,\wl_sum[31]_i_16_n_0 ,\wl_sum[31]_i_17_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \wl_sum_reg[31]_i_7 
       (.CI(1'b0),
        .CO({\wl_sum_reg[31]_i_7_n_0 ,\wl_sum_reg[31]_i_7_n_1 ,\wl_sum_reg[31]_i_7_n_2 ,\wl_sum_reg[31]_i_7_n_3 }),
        .CYINIT(1'b0),
        .DI({\wl_sum[31]_i_18_n_0 ,\wl_sum[31]_i_19_n_0 ,\wl_sum[31]_i_20_n_0 ,\wl_sum[31]_i_21_n_0 }),
        .O(\NLW_wl_sum_reg[31]_i_7_O_UNCONNECTED [3:0]),
        .S({\wl_sum[31]_i_22_n_0 ,\wl_sum[31]_i_23_n_0 ,\wl_sum[31]_i_24_n_0 ,\wl_sum[31]_i_25_n_0 }));
  FDSE \wl_sum_reg[3] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\wl_sum[3]_i_1_n_0 ),
        .Q(wl_sum[3]),
        .S(1'b0));
  FDSE \wl_sum_reg[4] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\wl_sum[4]_i_1_n_0 ),
        .Q(wl_sum[4]),
        .S(1'b0));
  FDSE \wl_sum_reg[5] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\wl_sum[5]_i_1_n_0 ),
        .Q(wl_sum[5]),
        .S(1'b0));
  FDSE \wl_sum_reg[6] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\wl_sum[6]_i_1_n_0 ),
        .Q(wl_sum[6]),
        .S(1'b0));
  FDSE \wl_sum_reg[7] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\wl_sum[7]_i_1_n_0 ),
        .Q(wl_sum[7]),
        .S(1'b0));
  FDSE \wl_sum_reg[8] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\wl_sum[8]_i_1_n_0 ),
        .Q(wl_sum[8]),
        .S(1'b0));
  FDSE \wl_sum_reg[9] 
       (.C(clk),
        .CE(\mav_sum[30]_i_1_n_0 ),
        .D(\wl_sum[9]_i_1_n_0 ),
        .Q(wl_sum[9]),
        .S(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair134" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \wr_ptr[0]_i_1 
       (.I0(wr_ptr[0]),
        .O(\wr_ptr[0]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    \wr_ptr[1]_i_1 
       (.I0(sample_valid),
        .I1(window_valid13_in),
        .O(win_mav));
  (* SOFT_HLUTNM = "soft_lutpair134" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \wr_ptr[1]_i_2 
       (.I0(wr_ptr[0]),
        .I1(wr_ptr[1]),
        .O(\wr_ptr[1]_i_2_n_0 ));
  FDRE \wr_ptr_reg[0] 
       (.C(clk),
        .CE(win_mav),
        .D(\wr_ptr[0]_i_1_n_0 ),
        .Q(wr_ptr[0]),
        .R(clear));
  FDRE \wr_ptr_reg[1] 
       (.C(clk),
        .CE(win_mav),
        .D(\wr_ptr[1]_i_2_n_0 ),
        .Q(wr_ptr[1]),
        .R(clear));
  (* SOFT_HLUTNM = "soft_lutpair52" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \zc_count[0]_i_1 
       (.I0(\win_zc_reg[3]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(\next_zc_reg_n_0_[0] ),
        .O(\zc_count[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair53" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \zc_count[1]_i_1 
       (.I0(\win_zc_reg[3]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(\next_zc_reg_n_0_[1] ),
        .O(\zc_count[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair53" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \zc_count[2]_i_1 
       (.I0(\win_zc_reg[3]_i_1_n_5 ),
        .I1(window_valid13_in),
        .I2(\next_zc_reg_n_0_[2] ),
        .O(\zc_count[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair54" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \zc_count[3]_i_1 
       (.I0(\win_zc_reg[3]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(\next_zc_reg_n_0_[3] ),
        .O(\zc_count[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair54" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \zc_count[4]_i_1 
       (.I0(\win_zc_reg[7]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(\next_zc_reg_n_0_[4] ),
        .O(\zc_count[4]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair55" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \zc_count[5]_i_1 
       (.I0(\win_zc_reg[7]_i_1_n_6 ),
        .I1(window_valid13_in),
        .I2(\next_zc_reg_n_0_[5] ),
        .O(\zc_count[5]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair55" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \zc_count[6]_i_1 
       (.I0(\win_zc_reg[7]_i_1_n_5 ),
        .I1(window_valid13_in),
        .I2(\next_zc_reg_n_0_[6] ),
        .O(\zc_count[6]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair56" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \zc_count[7]_i_1 
       (.I0(\win_zc_reg[7]_i_1_n_4 ),
        .I1(window_valid13_in),
        .I2(\next_zc_reg_n_0_[7] ),
        .O(\zc_count[7]_i_1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \zc_count[8]_i_1 
       (.I0(rst_n),
        .O(clear));
  LUT2 #(
    .INIT(4'h8)) 
    \zc_count[8]_i_2 
       (.I0(sample_valid),
        .I1(window_valid0),
        .O(\zc_count[8]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair56" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \zc_count[8]_i_3 
       (.I0(\win_zc_reg[8]_i_1_n_7 ),
        .I1(window_valid13_in),
        .I2(\next_zc_reg_n_0_[8] ),
        .O(\zc_count[8]_i_3_n_0 ));
  FDRE \zc_count_reg[0] 
       (.C(clk),
        .CE(\zc_count[8]_i_2_n_0 ),
        .D(\zc_count[0]_i_1_n_0 ),
        .Q(\^zc_count [0]),
        .R(clear));
  FDRE \zc_count_reg[1] 
       (.C(clk),
        .CE(\zc_count[8]_i_2_n_0 ),
        .D(\zc_count[1]_i_1_n_0 ),
        .Q(\^zc_count [1]),
        .R(clear));
  FDRE \zc_count_reg[2] 
       (.C(clk),
        .CE(\zc_count[8]_i_2_n_0 ),
        .D(\zc_count[2]_i_1_n_0 ),
        .Q(\^zc_count [2]),
        .R(clear));
  FDRE \zc_count_reg[3] 
       (.C(clk),
        .CE(\zc_count[8]_i_2_n_0 ),
        .D(\zc_count[3]_i_1_n_0 ),
        .Q(\^zc_count [3]),
        .R(clear));
  FDRE \zc_count_reg[4] 
       (.C(clk),
        .CE(\zc_count[8]_i_2_n_0 ),
        .D(\zc_count[4]_i_1_n_0 ),
        .Q(\^zc_count [4]),
        .R(clear));
  FDRE \zc_count_reg[5] 
       (.C(clk),
        .CE(\zc_count[8]_i_2_n_0 ),
        .D(\zc_count[5]_i_1_n_0 ),
        .Q(\^zc_count [5]),
        .R(clear));
  FDRE \zc_count_reg[6] 
       (.C(clk),
        .CE(\zc_count[8]_i_2_n_0 ),
        .D(\zc_count[6]_i_1_n_0 ),
        .Q(\^zc_count [6]),
        .R(clear));
  FDRE \zc_count_reg[7] 
       (.C(clk),
        .CE(\zc_count[8]_i_2_n_0 ),
        .D(\zc_count[7]_i_1_n_0 ),
        .Q(\^zc_count [7]),
        .R(clear));
  FDRE \zc_count_reg[8] 
       (.C(clk),
        .CE(\zc_count[8]_i_2_n_0 ),
        .D(\zc_count[8]_i_3_n_0 ),
        .Q(\^zc_count [8]),
        .R(clear));
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
