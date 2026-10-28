// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
// Date        : Tue Oct 27 16:02:24 2026
// Host        : LAPTOP-VCCV41QO running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               D:/FPGA/sEMG-HMRS/report/resource_optimization_full_20261027/emg_feature_bank_synth.v
// Design      : emg_feature_bank
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* BYPASS_BANDPASS = "1" *) (* CHANNELS = "8" *) (* CHANNEL_BITS = "3" *) 
(* CH_PTR_W = "3" *) (* HOP_SAMPLES = "100" *) (* HP_A1 = "18'sb100000101101011111" *) 
(* HP_A2 = "18'sb001111010011100000" *) (* HP_B0 = "18'sb001111101001100000" *) (* HP_B1 = "18'sb100000101101000000" *) 
(* HP_B2 = "18'sb001111101001100000" *) (* LP_ALPHA = "16'sb0010010010110000" *) (* RMS_INPUT_SHIFT = "12" *) 
(* SAMPLE_WIDTH = "24" *) (* SSC_THRESHOLD = "24'sb000000000000000000000000" *) (* WINDOW_SAMPLES = "400" *) 
(* ZC_THRESHOLD = "24'sb000000000000000000000000" *) 
(* NotValidForBitStream *)
module emg_feature_bank
   (clk,
    rst_n,
    sample_valid,
    sample_channel,
    sample_data,
    feature_ready,
    feature_valid,
    feature_id,
    feature_channel,
    feature_data,
    feature_sequence);
  input clk;
  input rst_n;
  input sample_valid;
  input [2:0]sample_channel;
  input [23:0]sample_data;
  input feature_ready;
  output feature_valid;
  output [3:0]feature_id;
  output [2:0]feature_channel;
  output [31:0]feature_data;
  output [15:0]feature_sequence;

  wire \<const0> ;
  wire \active_ch[0]_i_1_n_0 ;
  wire \active_ch[1]_i_1_n_0 ;
  wire \active_ch[2]_i_2_n_0 ;
  wire busy;
  wire busy0;
  wire busy_i_1_n_0;
  wire busy_i_2_n_0;
  wire busy_i_4_n_0;
  wire busy_i_5_n_0;
  wire clk;
  wire [2:0]feature_channel;
  wire [31:0]feature_data;
  wire \feature_data[0]_INST_0_i_1_n_0 ;
  wire \feature_data[10]_INST_0_i_1_n_0 ;
  wire \feature_data[11]_INST_0_i_1_n_0 ;
  wire \feature_data[12]_INST_0_i_1_n_0 ;
  wire \feature_data[13]_INST_0_i_1_n_0 ;
  wire \feature_data[14]_INST_0_i_1_n_0 ;
  wire \feature_data[15]_INST_0_i_1_n_0 ;
  wire \feature_data[16]_INST_0_i_1_n_0 ;
  wire \feature_data[17]_INST_0_i_1_n_0 ;
  wire \feature_data[18]_INST_0_i_1_n_0 ;
  wire \feature_data[19]_INST_0_i_1_n_0 ;
  wire \feature_data[1]_INST_0_i_1_n_0 ;
  wire \feature_data[20]_INST_0_i_1_n_0 ;
  wire \feature_data[21]_INST_0_i_1_n_0 ;
  wire \feature_data[22]_INST_0_i_1_n_0 ;
  wire \feature_data[23]_INST_0_i_1_n_0 ;
  wire \feature_data[24]_INST_0_i_1_n_0 ;
  wire \feature_data[25]_INST_0_i_1_n_0 ;
  wire \feature_data[26]_INST_0_i_1_n_0 ;
  wire \feature_data[27]_INST_0_i_1_n_0 ;
  wire \feature_data[28]_INST_0_i_1_n_0 ;
  wire \feature_data[29]_INST_0_i_1_n_0 ;
  wire \feature_data[2]_INST_0_i_1_n_0 ;
  wire \feature_data[30]_INST_0_i_1_n_0 ;
  wire \feature_data[31]_INST_0_i_1_n_0 ;
  wire \feature_data[31]_INST_0_i_2_n_0 ;
  wire \feature_data[31]_INST_0_i_3_n_0 ;
  wire \feature_data[31]_INST_0_i_4_n_0 ;
  wire \feature_data[3]_INST_0_i_1_n_0 ;
  wire \feature_data[4]_INST_0_i_1_n_0 ;
  wire \feature_data[5]_INST_0_i_1_n_0 ;
  wire \feature_data[6]_INST_0_i_1_n_0 ;
  wire \feature_data[7]_INST_0_i_1_n_0 ;
  wire \feature_data[8]_INST_0_i_1_n_0 ;
  wire \feature_data[9]_INST_0_i_1_n_0 ;
  wire [2:0]\^feature_id ;
  wire feature_ready;
  wire [15:0]feature_sequence;
  wire \feature_sequence[3]_i_2_n_0 ;
  wire \feature_sequence_reg[11]_i_1_n_0 ;
  wire \feature_sequence_reg[11]_i_1_n_1 ;
  wire \feature_sequence_reg[11]_i_1_n_2 ;
  wire \feature_sequence_reg[11]_i_1_n_3 ;
  wire \feature_sequence_reg[11]_i_1_n_4 ;
  wire \feature_sequence_reg[11]_i_1_n_5 ;
  wire \feature_sequence_reg[11]_i_1_n_6 ;
  wire \feature_sequence_reg[11]_i_1_n_7 ;
  wire \feature_sequence_reg[15]_i_2_n_1 ;
  wire \feature_sequence_reg[15]_i_2_n_2 ;
  wire \feature_sequence_reg[15]_i_2_n_3 ;
  wire \feature_sequence_reg[15]_i_2_n_4 ;
  wire \feature_sequence_reg[15]_i_2_n_5 ;
  wire \feature_sequence_reg[15]_i_2_n_6 ;
  wire \feature_sequence_reg[15]_i_2_n_7 ;
  wire \feature_sequence_reg[3]_i_1_n_0 ;
  wire \feature_sequence_reg[3]_i_1_n_1 ;
  wire \feature_sequence_reg[3]_i_1_n_2 ;
  wire \feature_sequence_reg[3]_i_1_n_3 ;
  wire \feature_sequence_reg[3]_i_1_n_4 ;
  wire \feature_sequence_reg[3]_i_1_n_5 ;
  wire \feature_sequence_reg[3]_i_1_n_6 ;
  wire \feature_sequence_reg[3]_i_1_n_7 ;
  wire \feature_sequence_reg[7]_i_1_n_0 ;
  wire \feature_sequence_reg[7]_i_1_n_1 ;
  wire \feature_sequence_reg[7]_i_1_n_2 ;
  wire \feature_sequence_reg[7]_i_1_n_3 ;
  wire \feature_sequence_reg[7]_i_1_n_4 ;
  wire \feature_sequence_reg[7]_i_1_n_5 ;
  wire \feature_sequence_reg[7]_i_1_n_6 ;
  wire \feature_sequence_reg[7]_i_1_n_7 ;
  wire feature_valid;
  wire \fidx[0]_i_1_n_0 ;
  wire \fidx[1]_i_1_n_0 ;
  wire \fidx[2]_i_1_n_0 ;
  wire [7:0]hold_seen;
  wire [159:0]hold_word0;
  wire p_0_in5_out;
  wire pending1;
  wire \pending_reg_n_0_[0] ;
  wire \pending_reg_n_0_[1] ;
  wire \pending_reg_n_0_[2] ;
  wire \pending_reg_n_0_[3] ;
  wire \pending_reg_n_0_[4] ;
  wire \pending_reg_n_0_[5] ;
  wire \pending_reg_n_0_[6] ;
  wire \pending_reg_n_0_[7] ;
  wire rst_n;
  wire [2:0]sample_channel;
  wire [23:0]sample_data;
  wire sample_valid;
  wire \scan_ptr[0]_i_1_n_0 ;
  wire \scan_ptr[1]_i_1_n_0 ;
  wire \scan_ptr[1]_i_2_n_0 ;
  wire \scan_ptr[2]_i_1_n_0 ;
  wire \scan_ptr[2]_i_2_n_0 ;
  wire \scan_ptr[2]_i_3_n_0 ;
  wire \scan_ptr[2]_i_4_n_0 ;
  wire \scan_ptr[2]_i_5_n_0 ;
  wire \scan_ptr_reg_n_0_[0] ;
  wire \scan_ptr_reg_n_0_[1] ;
  wire \scan_ptr_reg_n_0_[2] ;
  wire [2:0]shared_channel;
  wire [31:0]shared_energy;
  wire \shared_features.u_features_n_0 ;
  wire \shared_features.u_features_n_1 ;
  wire \shared_features.u_features_n_13 ;
  wire \shared_features.u_features_n_14 ;
  wire \shared_features.u_features_n_15 ;
  wire \shared_features.u_features_n_16 ;
  wire \shared_features.u_features_n_17 ;
  wire \shared_features.u_features_n_18 ;
  wire \shared_features.u_features_n_19 ;
  wire \shared_features.u_features_n_2 ;
  wire \shared_features.u_features_n_21 ;
  wire \shared_features.u_features_n_3 ;
  wire \shared_features.u_features_n_4 ;
  wire \shared_features.u_features_n_5 ;
  wire \shared_features.u_features_n_6 ;
  wire \shared_features.u_features_n_7 ;
  wire \shared_features.u_features_n_8 ;
  wire \shared_features.u_features_n_9 ;
  wire [31:0]shared_mav;
  wire [8:0]shared_ssc;
  wire [31:0]shared_wl;
  wire [8:0]shared_zc;
  wire [3:3]\NLW_feature_sequence_reg[15]_i_2_CO_UNCONNECTED ;
  wire [1:0]\NLW_shared_capture.hold_mem_reg_0_7_0_5_DOD_UNCONNECTED ;
  wire [1:0]\NLW_shared_capture.hold_mem_reg_0_7_102_107_DOD_UNCONNECTED ;
  wire [1:0]\NLW_shared_capture.hold_mem_reg_0_7_108_113_DOD_UNCONNECTED ;
  wire [1:0]\NLW_shared_capture.hold_mem_reg_0_7_114_119_DOD_UNCONNECTED ;
  wire [1:0]\NLW_shared_capture.hold_mem_reg_0_7_120_125_DOD_UNCONNECTED ;
  wire [1:0]\NLW_shared_capture.hold_mem_reg_0_7_126_131_DOD_UNCONNECTED ;
  wire [1:0]\NLW_shared_capture.hold_mem_reg_0_7_132_137_DOD_UNCONNECTED ;
  wire [1:0]\NLW_shared_capture.hold_mem_reg_0_7_138_143_DOD_UNCONNECTED ;
  wire [1:0]\NLW_shared_capture.hold_mem_reg_0_7_144_149_DOD_UNCONNECTED ;
  wire [1:0]\NLW_shared_capture.hold_mem_reg_0_7_150_155_DOD_UNCONNECTED ;
  wire [1:0]\NLW_shared_capture.hold_mem_reg_0_7_30_35_DOC_UNCONNECTED ;
  wire [1:0]\NLW_shared_capture.hold_mem_reg_0_7_30_35_DOD_UNCONNECTED ;
  wire [1:0]\NLW_shared_capture.hold_mem_reg_0_7_36_41_DOD_UNCONNECTED ;
  wire [1:0]\NLW_shared_capture.hold_mem_reg_0_7_60_65_DOD_UNCONNECTED ;
  wire [1:0]\NLW_shared_capture.hold_mem_reg_0_7_66_71_DOD_UNCONNECTED ;
  wire [1:0]\NLW_shared_capture.hold_mem_reg_0_7_6_11_DOC_UNCONNECTED ;
  wire [1:0]\NLW_shared_capture.hold_mem_reg_0_7_6_11_DOD_UNCONNECTED ;
  wire [1:0]\NLW_shared_capture.hold_mem_reg_0_7_72_77_DOD_UNCONNECTED ;
  wire [1:0]\NLW_shared_capture.hold_mem_reg_0_7_78_83_DOD_UNCONNECTED ;
  wire [1:0]\NLW_shared_capture.hold_mem_reg_0_7_84_89_DOD_UNCONNECTED ;
  wire [1:0]\NLW_shared_capture.hold_mem_reg_0_7_90_95_DOD_UNCONNECTED ;
  wire [1:0]\NLW_shared_capture.hold_mem_reg_0_7_96_101_DOD_UNCONNECTED ;

  assign feature_id[3] = \<const0> ;
  assign feature_id[2:0] = \^feature_id [2:0];
  GND GND
       (.G(\<const0> ));
  LUT3 #(
    .INIT(8'hB8)) 
    \active_ch[0]_i_1 
       (.I0(\scan_ptr_reg_n_0_[0] ),
        .I1(busy),
        .I2(feature_channel[0]),
        .O(\active_ch[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair208" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \active_ch[1]_i_1 
       (.I0(\scan_ptr_reg_n_0_[1] ),
        .I1(busy),
        .I2(feature_channel[1]),
        .O(\active_ch[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair208" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \active_ch[2]_i_2 
       (.I0(\scan_ptr_reg_n_0_[2] ),
        .I1(busy),
        .I2(feature_channel[2]),
        .O(\active_ch[2]_i_2_n_0 ));
  FDRE \active_ch_reg[0] 
       (.C(clk),
        .CE(1'b1),
        .D(\active_ch[0]_i_1_n_0 ),
        .Q(feature_channel[0]),
        .R(\shared_features.u_features_n_21 ));
  FDRE \active_ch_reg[1] 
       (.C(clk),
        .CE(1'b1),
        .D(\active_ch[1]_i_1_n_0 ),
        .Q(feature_channel[1]),
        .R(\shared_features.u_features_n_21 ));
  FDRE \active_ch_reg[2] 
       (.C(clk),
        .CE(1'b1),
        .D(\active_ch[2]_i_2_n_0 ),
        .Q(feature_channel[2]),
        .R(\shared_features.u_features_n_21 ));
  LUT6 #(
    .INIT(64'hDFDFFF0000000000)) 
    busy_i_1
       (.I0(\^feature_id [2]),
        .I1(busy_i_2_n_0),
        .I2(feature_ready),
        .I3(busy0),
        .I4(feature_valid),
        .I5(rst_n),
        .O(busy_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair206" *) 
  LUT2 #(
    .INIT(4'hE)) 
    busy_i_2
       (.I0(\^feature_id [1]),
        .I1(\^feature_id [0]),
        .O(busy_i_2_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    busy_i_4
       (.I0(\pending_reg_n_0_[3] ),
        .I1(\pending_reg_n_0_[2] ),
        .I2(\scan_ptr_reg_n_0_[1] ),
        .I3(\pending_reg_n_0_[1] ),
        .I4(\scan_ptr_reg_n_0_[0] ),
        .I5(\pending_reg_n_0_[0] ),
        .O(busy_i_4_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    busy_i_5
       (.I0(\pending_reg_n_0_[7] ),
        .I1(\pending_reg_n_0_[6] ),
        .I2(\scan_ptr_reg_n_0_[1] ),
        .I3(\pending_reg_n_0_[5] ),
        .I4(\scan_ptr_reg_n_0_[0] ),
        .I5(\pending_reg_n_0_[4] ),
        .O(busy_i_5_n_0));
  FDRE busy_reg
       (.C(clk),
        .CE(1'b1),
        .D(busy_i_1_n_0),
        .Q(feature_valid),
        .R(1'b0));
  MUXF7 busy_reg_i_3
       (.I0(busy_i_4_n_0),
        .I1(busy_i_5_n_0),
        .O(busy0),
        .S(\scan_ptr_reg_n_0_[2] ));
  LUT4 #(
    .INIT(16'hA808)) 
    \feature_data[0]_INST_0 
       (.I0(\feature_data[31]_INST_0_i_1_n_0 ),
        .I1(\feature_data[0]_INST_0_i_1_n_0 ),
        .I2(\^feature_id [2]),
        .I3(hold_word0[0]),
        .O(feature_data[0]));
  LUT6 #(
    .INIT(64'hFFCCAAF000CCAAF0)) 
    \feature_data[0]_INST_0_i_1 
       (.I0(hold_word0[96]),
        .I1(hold_word0[64]),
        .I2(hold_word0[128]),
        .I3(\^feature_id [0]),
        .I4(\^feature_id [1]),
        .I5(hold_word0[32]),
        .O(\feature_data[0]_INST_0_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \feature_data[10]_INST_0 
       (.I0(\feature_data[31]_INST_0_i_1_n_0 ),
        .I1(\feature_data[10]_INST_0_i_1_n_0 ),
        .O(feature_data[10]));
  LUT6 #(
    .INIT(64'hFBAAFBAFFBFAFBFF)) 
    \feature_data[10]_INST_0_i_1 
       (.I0(\^feature_id [2]),
        .I1(hold_word0[106]),
        .I2(\^feature_id [1]),
        .I3(\^feature_id [0]),
        .I4(hold_word0[138]),
        .I5(hold_word0[74]),
        .O(\feature_data[10]_INST_0_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \feature_data[11]_INST_0 
       (.I0(\feature_data[31]_INST_0_i_1_n_0 ),
        .I1(\feature_data[11]_INST_0_i_1_n_0 ),
        .O(feature_data[11]));
  LUT6 #(
    .INIT(64'hFBAAFBAFFBFAFBFF)) 
    \feature_data[11]_INST_0_i_1 
       (.I0(\^feature_id [2]),
        .I1(hold_word0[107]),
        .I2(\^feature_id [1]),
        .I3(\^feature_id [0]),
        .I4(hold_word0[139]),
        .I5(hold_word0[75]),
        .O(\feature_data[11]_INST_0_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \feature_data[12]_INST_0 
       (.I0(\feature_data[31]_INST_0_i_1_n_0 ),
        .I1(\feature_data[12]_INST_0_i_1_n_0 ),
        .O(feature_data[12]));
  LUT6 #(
    .INIT(64'hFBAAFBAFFBFAFBFF)) 
    \feature_data[12]_INST_0_i_1 
       (.I0(\^feature_id [2]),
        .I1(hold_word0[108]),
        .I2(\^feature_id [1]),
        .I3(\^feature_id [0]),
        .I4(hold_word0[140]),
        .I5(hold_word0[76]),
        .O(\feature_data[12]_INST_0_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \feature_data[13]_INST_0 
       (.I0(\feature_data[31]_INST_0_i_1_n_0 ),
        .I1(\feature_data[13]_INST_0_i_1_n_0 ),
        .O(feature_data[13]));
  LUT6 #(
    .INIT(64'hFBAAFBAFFBFAFBFF)) 
    \feature_data[13]_INST_0_i_1 
       (.I0(\^feature_id [2]),
        .I1(hold_word0[109]),
        .I2(\^feature_id [1]),
        .I3(\^feature_id [0]),
        .I4(hold_word0[141]),
        .I5(hold_word0[77]),
        .O(\feature_data[13]_INST_0_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \feature_data[14]_INST_0 
       (.I0(\feature_data[31]_INST_0_i_1_n_0 ),
        .I1(\feature_data[14]_INST_0_i_1_n_0 ),
        .O(feature_data[14]));
  LUT6 #(
    .INIT(64'hFBAAFBAFFBFAFBFF)) 
    \feature_data[14]_INST_0_i_1 
       (.I0(\^feature_id [2]),
        .I1(hold_word0[110]),
        .I2(\^feature_id [1]),
        .I3(\^feature_id [0]),
        .I4(hold_word0[142]),
        .I5(hold_word0[78]),
        .O(\feature_data[14]_INST_0_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \feature_data[15]_INST_0 
       (.I0(\feature_data[31]_INST_0_i_1_n_0 ),
        .I1(\feature_data[15]_INST_0_i_1_n_0 ),
        .O(feature_data[15]));
  LUT6 #(
    .INIT(64'hFBAAFBAFFBFAFBFF)) 
    \feature_data[15]_INST_0_i_1 
       (.I0(\^feature_id [2]),
        .I1(hold_word0[111]),
        .I2(\^feature_id [1]),
        .I3(\^feature_id [0]),
        .I4(hold_word0[143]),
        .I5(hold_word0[79]),
        .O(\feature_data[15]_INST_0_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \feature_data[16]_INST_0 
       (.I0(\feature_data[31]_INST_0_i_1_n_0 ),
        .I1(\feature_data[16]_INST_0_i_1_n_0 ),
        .O(feature_data[16]));
  LUT6 #(
    .INIT(64'hFBAAFBAFFBFAFBFF)) 
    \feature_data[16]_INST_0_i_1 
       (.I0(\^feature_id [2]),
        .I1(hold_word0[112]),
        .I2(\^feature_id [1]),
        .I3(\^feature_id [0]),
        .I4(hold_word0[144]),
        .I5(hold_word0[80]),
        .O(\feature_data[16]_INST_0_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \feature_data[17]_INST_0 
       (.I0(\feature_data[31]_INST_0_i_1_n_0 ),
        .I1(\feature_data[17]_INST_0_i_1_n_0 ),
        .O(feature_data[17]));
  LUT6 #(
    .INIT(64'hFBAAFBAFFBFAFBFF)) 
    \feature_data[17]_INST_0_i_1 
       (.I0(\^feature_id [2]),
        .I1(hold_word0[113]),
        .I2(\^feature_id [1]),
        .I3(\^feature_id [0]),
        .I4(hold_word0[145]),
        .I5(hold_word0[81]),
        .O(\feature_data[17]_INST_0_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \feature_data[18]_INST_0 
       (.I0(\feature_data[31]_INST_0_i_1_n_0 ),
        .I1(\feature_data[18]_INST_0_i_1_n_0 ),
        .O(feature_data[18]));
  LUT6 #(
    .INIT(64'hFBAAFBAFFBFAFBFF)) 
    \feature_data[18]_INST_0_i_1 
       (.I0(\^feature_id [2]),
        .I1(hold_word0[114]),
        .I2(\^feature_id [1]),
        .I3(\^feature_id [0]),
        .I4(hold_word0[146]),
        .I5(hold_word0[82]),
        .O(\feature_data[18]_INST_0_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \feature_data[19]_INST_0 
       (.I0(\feature_data[31]_INST_0_i_1_n_0 ),
        .I1(\feature_data[19]_INST_0_i_1_n_0 ),
        .O(feature_data[19]));
  LUT6 #(
    .INIT(64'hFBAAFBAFFBFAFBFF)) 
    \feature_data[19]_INST_0_i_1 
       (.I0(\^feature_id [2]),
        .I1(hold_word0[115]),
        .I2(\^feature_id [1]),
        .I3(\^feature_id [0]),
        .I4(hold_word0[147]),
        .I5(hold_word0[83]),
        .O(\feature_data[19]_INST_0_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hA808)) 
    \feature_data[1]_INST_0 
       (.I0(\feature_data[31]_INST_0_i_1_n_0 ),
        .I1(\feature_data[1]_INST_0_i_1_n_0 ),
        .I2(\^feature_id [2]),
        .I3(hold_word0[1]),
        .O(feature_data[1]));
  LUT6 #(
    .INIT(64'hFFCCAAF000CCAAF0)) 
    \feature_data[1]_INST_0_i_1 
       (.I0(hold_word0[97]),
        .I1(hold_word0[65]),
        .I2(hold_word0[129]),
        .I3(\^feature_id [0]),
        .I4(\^feature_id [1]),
        .I5(hold_word0[33]),
        .O(\feature_data[1]_INST_0_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \feature_data[20]_INST_0 
       (.I0(\feature_data[31]_INST_0_i_1_n_0 ),
        .I1(\feature_data[20]_INST_0_i_1_n_0 ),
        .O(feature_data[20]));
  LUT6 #(
    .INIT(64'hFBAAFBAFFBFAFBFF)) 
    \feature_data[20]_INST_0_i_1 
       (.I0(\^feature_id [2]),
        .I1(hold_word0[116]),
        .I2(\^feature_id [1]),
        .I3(\^feature_id [0]),
        .I4(hold_word0[148]),
        .I5(hold_word0[84]),
        .O(\feature_data[20]_INST_0_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \feature_data[21]_INST_0 
       (.I0(\feature_data[31]_INST_0_i_1_n_0 ),
        .I1(\feature_data[21]_INST_0_i_1_n_0 ),
        .O(feature_data[21]));
  LUT6 #(
    .INIT(64'hFBAAFBAFFBFAFBFF)) 
    \feature_data[21]_INST_0_i_1 
       (.I0(\^feature_id [2]),
        .I1(hold_word0[117]),
        .I2(\^feature_id [1]),
        .I3(\^feature_id [0]),
        .I4(hold_word0[149]),
        .I5(hold_word0[85]),
        .O(\feature_data[21]_INST_0_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \feature_data[22]_INST_0 
       (.I0(\feature_data[31]_INST_0_i_1_n_0 ),
        .I1(\feature_data[22]_INST_0_i_1_n_0 ),
        .O(feature_data[22]));
  LUT6 #(
    .INIT(64'hFBAAFBAFFBFAFBFF)) 
    \feature_data[22]_INST_0_i_1 
       (.I0(\^feature_id [2]),
        .I1(hold_word0[118]),
        .I2(\^feature_id [1]),
        .I3(\^feature_id [0]),
        .I4(hold_word0[150]),
        .I5(hold_word0[86]),
        .O(\feature_data[22]_INST_0_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \feature_data[23]_INST_0 
       (.I0(\feature_data[31]_INST_0_i_1_n_0 ),
        .I1(\feature_data[23]_INST_0_i_1_n_0 ),
        .O(feature_data[23]));
  LUT6 #(
    .INIT(64'hFBAAFBAFFBFAFBFF)) 
    \feature_data[23]_INST_0_i_1 
       (.I0(\^feature_id [2]),
        .I1(hold_word0[119]),
        .I2(\^feature_id [1]),
        .I3(\^feature_id [0]),
        .I4(hold_word0[151]),
        .I5(hold_word0[87]),
        .O(\feature_data[23]_INST_0_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \feature_data[24]_INST_0 
       (.I0(\feature_data[31]_INST_0_i_1_n_0 ),
        .I1(\feature_data[24]_INST_0_i_1_n_0 ),
        .O(feature_data[24]));
  LUT6 #(
    .INIT(64'hFBAAFBAFFBFAFBFF)) 
    \feature_data[24]_INST_0_i_1 
       (.I0(\^feature_id [2]),
        .I1(hold_word0[120]),
        .I2(\^feature_id [1]),
        .I3(\^feature_id [0]),
        .I4(hold_word0[152]),
        .I5(hold_word0[88]),
        .O(\feature_data[24]_INST_0_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \feature_data[25]_INST_0 
       (.I0(\feature_data[31]_INST_0_i_1_n_0 ),
        .I1(\feature_data[25]_INST_0_i_1_n_0 ),
        .O(feature_data[25]));
  LUT6 #(
    .INIT(64'hFBAAFBAFFBFAFBFF)) 
    \feature_data[25]_INST_0_i_1 
       (.I0(\^feature_id [2]),
        .I1(hold_word0[121]),
        .I2(\^feature_id [1]),
        .I3(\^feature_id [0]),
        .I4(hold_word0[153]),
        .I5(hold_word0[89]),
        .O(\feature_data[25]_INST_0_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \feature_data[26]_INST_0 
       (.I0(\feature_data[31]_INST_0_i_1_n_0 ),
        .I1(\feature_data[26]_INST_0_i_1_n_0 ),
        .O(feature_data[26]));
  LUT6 #(
    .INIT(64'hFBAAFBAFFBFAFBFF)) 
    \feature_data[26]_INST_0_i_1 
       (.I0(\^feature_id [2]),
        .I1(hold_word0[122]),
        .I2(\^feature_id [1]),
        .I3(\^feature_id [0]),
        .I4(hold_word0[154]),
        .I5(hold_word0[90]),
        .O(\feature_data[26]_INST_0_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \feature_data[27]_INST_0 
       (.I0(\feature_data[31]_INST_0_i_1_n_0 ),
        .I1(\feature_data[27]_INST_0_i_1_n_0 ),
        .O(feature_data[27]));
  LUT6 #(
    .INIT(64'hFBAAFBAFFBFAFBFF)) 
    \feature_data[27]_INST_0_i_1 
       (.I0(\^feature_id [2]),
        .I1(hold_word0[123]),
        .I2(\^feature_id [1]),
        .I3(\^feature_id [0]),
        .I4(hold_word0[155]),
        .I5(hold_word0[91]),
        .O(\feature_data[27]_INST_0_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \feature_data[28]_INST_0 
       (.I0(\feature_data[31]_INST_0_i_1_n_0 ),
        .I1(\feature_data[28]_INST_0_i_1_n_0 ),
        .O(feature_data[28]));
  LUT6 #(
    .INIT(64'hFBAAFBAFFBFAFBFF)) 
    \feature_data[28]_INST_0_i_1 
       (.I0(\^feature_id [2]),
        .I1(hold_word0[124]),
        .I2(\^feature_id [1]),
        .I3(\^feature_id [0]),
        .I4(hold_word0[156]),
        .I5(hold_word0[92]),
        .O(\feature_data[28]_INST_0_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \feature_data[29]_INST_0 
       (.I0(\feature_data[31]_INST_0_i_1_n_0 ),
        .I1(\feature_data[29]_INST_0_i_1_n_0 ),
        .O(feature_data[29]));
  LUT6 #(
    .INIT(64'hFBAAFBAFFBFAFBFF)) 
    \feature_data[29]_INST_0_i_1 
       (.I0(\^feature_id [2]),
        .I1(hold_word0[125]),
        .I2(\^feature_id [1]),
        .I3(\^feature_id [0]),
        .I4(hold_word0[157]),
        .I5(hold_word0[93]),
        .O(\feature_data[29]_INST_0_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hA808)) 
    \feature_data[2]_INST_0 
       (.I0(\feature_data[31]_INST_0_i_1_n_0 ),
        .I1(\feature_data[2]_INST_0_i_1_n_0 ),
        .I2(\^feature_id [2]),
        .I3(hold_word0[2]),
        .O(feature_data[2]));
  LUT6 #(
    .INIT(64'hFFCCAAF000CCAAF0)) 
    \feature_data[2]_INST_0_i_1 
       (.I0(hold_word0[98]),
        .I1(hold_word0[66]),
        .I2(hold_word0[130]),
        .I3(\^feature_id [0]),
        .I4(\^feature_id [1]),
        .I5(hold_word0[34]),
        .O(\feature_data[2]_INST_0_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \feature_data[30]_INST_0 
       (.I0(\feature_data[31]_INST_0_i_1_n_0 ),
        .I1(\feature_data[30]_INST_0_i_1_n_0 ),
        .O(feature_data[30]));
  LUT6 #(
    .INIT(64'hFBAAFBAFFBFAFBFF)) 
    \feature_data[30]_INST_0_i_1 
       (.I0(\^feature_id [2]),
        .I1(hold_word0[126]),
        .I2(\^feature_id [1]),
        .I3(\^feature_id [0]),
        .I4(hold_word0[158]),
        .I5(hold_word0[94]),
        .O(\feature_data[30]_INST_0_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \feature_data[31]_INST_0 
       (.I0(\feature_data[31]_INST_0_i_1_n_0 ),
        .I1(\feature_data[31]_INST_0_i_2_n_0 ),
        .O(feature_data[31]));
  MUXF7 \feature_data[31]_INST_0_i_1 
       (.I0(\feature_data[31]_INST_0_i_3_n_0 ),
        .I1(\feature_data[31]_INST_0_i_4_n_0 ),
        .O(\feature_data[31]_INST_0_i_1_n_0 ),
        .S(feature_channel[2]));
  LUT6 #(
    .INIT(64'hFBAAFBAFFBFAFBFF)) 
    \feature_data[31]_INST_0_i_2 
       (.I0(\^feature_id [2]),
        .I1(hold_word0[127]),
        .I2(\^feature_id [1]),
        .I3(\^feature_id [0]),
        .I4(hold_word0[159]),
        .I5(hold_word0[95]),
        .O(\feature_data[31]_INST_0_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \feature_data[31]_INST_0_i_3 
       (.I0(hold_seen[3]),
        .I1(hold_seen[2]),
        .I2(feature_channel[1]),
        .I3(hold_seen[1]),
        .I4(feature_channel[0]),
        .I5(hold_seen[0]),
        .O(\feature_data[31]_INST_0_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \feature_data[31]_INST_0_i_4 
       (.I0(hold_seen[7]),
        .I1(hold_seen[6]),
        .I2(feature_channel[1]),
        .I3(hold_seen[5]),
        .I4(feature_channel[0]),
        .I5(hold_seen[4]),
        .O(\feature_data[31]_INST_0_i_4_n_0 ));
  LUT4 #(
    .INIT(16'hA808)) 
    \feature_data[3]_INST_0 
       (.I0(\feature_data[31]_INST_0_i_1_n_0 ),
        .I1(\feature_data[3]_INST_0_i_1_n_0 ),
        .I2(\^feature_id [2]),
        .I3(hold_word0[3]),
        .O(feature_data[3]));
  LUT6 #(
    .INIT(64'hFFCCAAF000CCAAF0)) 
    \feature_data[3]_INST_0_i_1 
       (.I0(hold_word0[99]),
        .I1(hold_word0[67]),
        .I2(hold_word0[131]),
        .I3(\^feature_id [0]),
        .I4(\^feature_id [1]),
        .I5(hold_word0[35]),
        .O(\feature_data[3]_INST_0_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hA808)) 
    \feature_data[4]_INST_0 
       (.I0(\feature_data[31]_INST_0_i_1_n_0 ),
        .I1(\feature_data[4]_INST_0_i_1_n_0 ),
        .I2(\^feature_id [2]),
        .I3(hold_word0[4]),
        .O(feature_data[4]));
  LUT6 #(
    .INIT(64'hFFCCAAF000CCAAF0)) 
    \feature_data[4]_INST_0_i_1 
       (.I0(hold_word0[100]),
        .I1(hold_word0[68]),
        .I2(hold_word0[132]),
        .I3(\^feature_id [0]),
        .I4(\^feature_id [1]),
        .I5(hold_word0[36]),
        .O(\feature_data[4]_INST_0_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hA808)) 
    \feature_data[5]_INST_0 
       (.I0(\feature_data[31]_INST_0_i_1_n_0 ),
        .I1(\feature_data[5]_INST_0_i_1_n_0 ),
        .I2(\^feature_id [2]),
        .I3(hold_word0[5]),
        .O(feature_data[5]));
  LUT6 #(
    .INIT(64'hFFCCAAF000CCAAF0)) 
    \feature_data[5]_INST_0_i_1 
       (.I0(hold_word0[101]),
        .I1(hold_word0[69]),
        .I2(hold_word0[133]),
        .I3(\^feature_id [0]),
        .I4(\^feature_id [1]),
        .I5(hold_word0[37]),
        .O(\feature_data[5]_INST_0_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hA808)) 
    \feature_data[6]_INST_0 
       (.I0(\feature_data[31]_INST_0_i_1_n_0 ),
        .I1(\feature_data[6]_INST_0_i_1_n_0 ),
        .I2(\^feature_id [2]),
        .I3(hold_word0[6]),
        .O(feature_data[6]));
  LUT6 #(
    .INIT(64'hFFCCAAF000CCAAF0)) 
    \feature_data[6]_INST_0_i_1 
       (.I0(hold_word0[102]),
        .I1(hold_word0[70]),
        .I2(hold_word0[134]),
        .I3(\^feature_id [0]),
        .I4(\^feature_id [1]),
        .I5(hold_word0[38]),
        .O(\feature_data[6]_INST_0_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hA808)) 
    \feature_data[7]_INST_0 
       (.I0(\feature_data[31]_INST_0_i_1_n_0 ),
        .I1(\feature_data[7]_INST_0_i_1_n_0 ),
        .I2(\^feature_id [2]),
        .I3(hold_word0[7]),
        .O(feature_data[7]));
  LUT6 #(
    .INIT(64'hFFCCAAF000CCAAF0)) 
    \feature_data[7]_INST_0_i_1 
       (.I0(hold_word0[103]),
        .I1(hold_word0[71]),
        .I2(hold_word0[135]),
        .I3(\^feature_id [0]),
        .I4(\^feature_id [1]),
        .I5(hold_word0[39]),
        .O(\feature_data[7]_INST_0_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hA808)) 
    \feature_data[8]_INST_0 
       (.I0(\feature_data[31]_INST_0_i_1_n_0 ),
        .I1(\feature_data[8]_INST_0_i_1_n_0 ),
        .I2(\^feature_id [2]),
        .I3(hold_word0[8]),
        .O(feature_data[8]));
  LUT6 #(
    .INIT(64'hFFCCAAF000CCAAF0)) 
    \feature_data[8]_INST_0_i_1 
       (.I0(hold_word0[104]),
        .I1(hold_word0[72]),
        .I2(hold_word0[136]),
        .I3(\^feature_id [0]),
        .I4(\^feature_id [1]),
        .I5(hold_word0[40]),
        .O(\feature_data[8]_INST_0_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hA808)) 
    \feature_data[9]_INST_0 
       (.I0(\feature_data[31]_INST_0_i_1_n_0 ),
        .I1(\feature_data[9]_INST_0_i_1_n_0 ),
        .I2(\^feature_id [2]),
        .I3(hold_word0[9]),
        .O(feature_data[9]));
  LUT6 #(
    .INIT(64'hFFCCAAF000CCAAF0)) 
    \feature_data[9]_INST_0_i_1 
       (.I0(hold_word0[105]),
        .I1(hold_word0[73]),
        .I2(hold_word0[137]),
        .I3(\^feature_id [0]),
        .I4(\^feature_id [1]),
        .I5(hold_word0[41]),
        .O(\feature_data[9]_INST_0_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    \feature_sequence[15]_i_1 
       (.I0(feature_ready),
        .I1(feature_valid),
        .O(pending1));
  LUT1 #(
    .INIT(2'h1)) 
    \feature_sequence[3]_i_2 
       (.I0(feature_sequence[0]),
        .O(\feature_sequence[3]_i_2_n_0 ));
  FDRE \feature_sequence_reg[0] 
       (.C(clk),
        .CE(pending1),
        .D(\feature_sequence_reg[3]_i_1_n_7 ),
        .Q(feature_sequence[0]),
        .R(\shared_features.u_features_n_21 ));
  FDRE \feature_sequence_reg[10] 
       (.C(clk),
        .CE(pending1),
        .D(\feature_sequence_reg[11]_i_1_n_5 ),
        .Q(feature_sequence[10]),
        .R(\shared_features.u_features_n_21 ));
  FDRE \feature_sequence_reg[11] 
       (.C(clk),
        .CE(pending1),
        .D(\feature_sequence_reg[11]_i_1_n_4 ),
        .Q(feature_sequence[11]),
        .R(\shared_features.u_features_n_21 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \feature_sequence_reg[11]_i_1 
       (.CI(\feature_sequence_reg[7]_i_1_n_0 ),
        .CO({\feature_sequence_reg[11]_i_1_n_0 ,\feature_sequence_reg[11]_i_1_n_1 ,\feature_sequence_reg[11]_i_1_n_2 ,\feature_sequence_reg[11]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\feature_sequence_reg[11]_i_1_n_4 ,\feature_sequence_reg[11]_i_1_n_5 ,\feature_sequence_reg[11]_i_1_n_6 ,\feature_sequence_reg[11]_i_1_n_7 }),
        .S(feature_sequence[11:8]));
  FDRE \feature_sequence_reg[12] 
       (.C(clk),
        .CE(pending1),
        .D(\feature_sequence_reg[15]_i_2_n_7 ),
        .Q(feature_sequence[12]),
        .R(\shared_features.u_features_n_21 ));
  FDRE \feature_sequence_reg[13] 
       (.C(clk),
        .CE(pending1),
        .D(\feature_sequence_reg[15]_i_2_n_6 ),
        .Q(feature_sequence[13]),
        .R(\shared_features.u_features_n_21 ));
  FDRE \feature_sequence_reg[14] 
       (.C(clk),
        .CE(pending1),
        .D(\feature_sequence_reg[15]_i_2_n_5 ),
        .Q(feature_sequence[14]),
        .R(\shared_features.u_features_n_21 ));
  FDRE \feature_sequence_reg[15] 
       (.C(clk),
        .CE(pending1),
        .D(\feature_sequence_reg[15]_i_2_n_4 ),
        .Q(feature_sequence[15]),
        .R(\shared_features.u_features_n_21 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \feature_sequence_reg[15]_i_2 
       (.CI(\feature_sequence_reg[11]_i_1_n_0 ),
        .CO({\NLW_feature_sequence_reg[15]_i_2_CO_UNCONNECTED [3],\feature_sequence_reg[15]_i_2_n_1 ,\feature_sequence_reg[15]_i_2_n_2 ,\feature_sequence_reg[15]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\feature_sequence_reg[15]_i_2_n_4 ,\feature_sequence_reg[15]_i_2_n_5 ,\feature_sequence_reg[15]_i_2_n_6 ,\feature_sequence_reg[15]_i_2_n_7 }),
        .S(feature_sequence[15:12]));
  FDRE \feature_sequence_reg[1] 
       (.C(clk),
        .CE(pending1),
        .D(\feature_sequence_reg[3]_i_1_n_6 ),
        .Q(feature_sequence[1]),
        .R(\shared_features.u_features_n_21 ));
  FDRE \feature_sequence_reg[2] 
       (.C(clk),
        .CE(pending1),
        .D(\feature_sequence_reg[3]_i_1_n_5 ),
        .Q(feature_sequence[2]),
        .R(\shared_features.u_features_n_21 ));
  FDRE \feature_sequence_reg[3] 
       (.C(clk),
        .CE(pending1),
        .D(\feature_sequence_reg[3]_i_1_n_4 ),
        .Q(feature_sequence[3]),
        .R(\shared_features.u_features_n_21 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \feature_sequence_reg[3]_i_1 
       (.CI(1'b0),
        .CO({\feature_sequence_reg[3]_i_1_n_0 ,\feature_sequence_reg[3]_i_1_n_1 ,\feature_sequence_reg[3]_i_1_n_2 ,\feature_sequence_reg[3]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b1}),
        .O({\feature_sequence_reg[3]_i_1_n_4 ,\feature_sequence_reg[3]_i_1_n_5 ,\feature_sequence_reg[3]_i_1_n_6 ,\feature_sequence_reg[3]_i_1_n_7 }),
        .S({feature_sequence[3:1],\feature_sequence[3]_i_2_n_0 }));
  FDRE \feature_sequence_reg[4] 
       (.C(clk),
        .CE(pending1),
        .D(\feature_sequence_reg[7]_i_1_n_7 ),
        .Q(feature_sequence[4]),
        .R(\shared_features.u_features_n_21 ));
  FDRE \feature_sequence_reg[5] 
       (.C(clk),
        .CE(pending1),
        .D(\feature_sequence_reg[7]_i_1_n_6 ),
        .Q(feature_sequence[5]),
        .R(\shared_features.u_features_n_21 ));
  FDRE \feature_sequence_reg[6] 
       (.C(clk),
        .CE(pending1),
        .D(\feature_sequence_reg[7]_i_1_n_5 ),
        .Q(feature_sequence[6]),
        .R(\shared_features.u_features_n_21 ));
  FDRE \feature_sequence_reg[7] 
       (.C(clk),
        .CE(pending1),
        .D(\feature_sequence_reg[7]_i_1_n_4 ),
        .Q(feature_sequence[7]),
        .R(\shared_features.u_features_n_21 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \feature_sequence_reg[7]_i_1 
       (.CI(\feature_sequence_reg[3]_i_1_n_0 ),
        .CO({\feature_sequence_reg[7]_i_1_n_0 ,\feature_sequence_reg[7]_i_1_n_1 ,\feature_sequence_reg[7]_i_1_n_2 ,\feature_sequence_reg[7]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\feature_sequence_reg[7]_i_1_n_4 ,\feature_sequence_reg[7]_i_1_n_5 ,\feature_sequence_reg[7]_i_1_n_6 ,\feature_sequence_reg[7]_i_1_n_7 }),
        .S(feature_sequence[7:4]));
  FDRE \feature_sequence_reg[8] 
       (.C(clk),
        .CE(pending1),
        .D(\feature_sequence_reg[11]_i_1_n_7 ),
        .Q(feature_sequence[8]),
        .R(\shared_features.u_features_n_21 ));
  FDRE \feature_sequence_reg[9] 
       (.C(clk),
        .CE(pending1),
        .D(\feature_sequence_reg[11]_i_1_n_6 ),
        .Q(feature_sequence[9]),
        .R(\shared_features.u_features_n_21 ));
  LUT6 #(
    .INIT(64'h0000000062660000)) 
    \fidx[0]_i_1 
       (.I0(\^feature_id [0]),
        .I1(pending1),
        .I2(\^feature_id [1]),
        .I3(\^feature_id [2]),
        .I4(rst_n),
        .I5(busy),
        .O(\fidx[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair206" *) 
  LUT5 #(
    .INIT(32'h00006C00)) 
    \fidx[1]_i_1 
       (.I0(\^feature_id [0]),
        .I1(\^feature_id [1]),
        .I2(pending1),
        .I3(rst_n),
        .I4(busy),
        .O(\fidx[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h000000006AAA0000)) 
    \fidx[2]_i_1 
       (.I0(\^feature_id [2]),
        .I1(\^feature_id [0]),
        .I2(\^feature_id [1]),
        .I3(pending1),
        .I4(rst_n),
        .I5(busy),
        .O(\fidx[2]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \fidx[2]_i_2 
       (.I0(busy0),
        .I1(feature_valid),
        .O(busy));
  FDRE \fidx_reg[0] 
       (.C(clk),
        .CE(1'b1),
        .D(\fidx[0]_i_1_n_0 ),
        .Q(\^feature_id [0]),
        .R(1'b0));
  FDRE \fidx_reg[1] 
       (.C(clk),
        .CE(1'b1),
        .D(\fidx[1]_i_1_n_0 ),
        .Q(\^feature_id [1]),
        .R(1'b0));
  FDRE \fidx_reg[2] 
       (.C(clk),
        .CE(1'b1),
        .D(\fidx[2]_i_1_n_0 ),
        .Q(\^feature_id [2]),
        .R(1'b0));
  FDRE \hold_seen_reg[0] 
       (.C(clk),
        .CE(1'b1),
        .D(\shared_features.u_features_n_9 ),
        .Q(hold_seen[0]),
        .R(\shared_features.u_features_n_21 ));
  FDRE \hold_seen_reg[1] 
       (.C(clk),
        .CE(1'b1),
        .D(\shared_features.u_features_n_13 ),
        .Q(hold_seen[1]),
        .R(\shared_features.u_features_n_21 ));
  FDRE \hold_seen_reg[2] 
       (.C(clk),
        .CE(1'b1),
        .D(\shared_features.u_features_n_14 ),
        .Q(hold_seen[2]),
        .R(\shared_features.u_features_n_21 ));
  FDRE \hold_seen_reg[3] 
       (.C(clk),
        .CE(1'b1),
        .D(\shared_features.u_features_n_15 ),
        .Q(hold_seen[3]),
        .R(\shared_features.u_features_n_21 ));
  FDRE \hold_seen_reg[4] 
       (.C(clk),
        .CE(1'b1),
        .D(\shared_features.u_features_n_16 ),
        .Q(hold_seen[4]),
        .R(\shared_features.u_features_n_21 ));
  FDRE \hold_seen_reg[5] 
       (.C(clk),
        .CE(1'b1),
        .D(\shared_features.u_features_n_17 ),
        .Q(hold_seen[5]),
        .R(\shared_features.u_features_n_21 ));
  FDRE \hold_seen_reg[6] 
       (.C(clk),
        .CE(1'b1),
        .D(\shared_features.u_features_n_18 ),
        .Q(hold_seen[6]),
        .R(\shared_features.u_features_n_21 ));
  FDRE \hold_seen_reg[7] 
       (.C(clk),
        .CE(1'b1),
        .D(\shared_features.u_features_n_19 ),
        .Q(hold_seen[7]),
        .R(\shared_features.u_features_n_21 ));
  FDRE \pending_reg[0] 
       (.C(clk),
        .CE(1'b1),
        .D(\shared_features.u_features_n_8 ),
        .Q(\pending_reg_n_0_[0] ),
        .R(\shared_features.u_features_n_21 ));
  FDRE \pending_reg[1] 
       (.C(clk),
        .CE(1'b1),
        .D(\shared_features.u_features_n_7 ),
        .Q(\pending_reg_n_0_[1] ),
        .R(\shared_features.u_features_n_21 ));
  FDRE \pending_reg[2] 
       (.C(clk),
        .CE(1'b1),
        .D(\shared_features.u_features_n_6 ),
        .Q(\pending_reg_n_0_[2] ),
        .R(\shared_features.u_features_n_21 ));
  FDRE \pending_reg[3] 
       (.C(clk),
        .CE(1'b1),
        .D(\shared_features.u_features_n_5 ),
        .Q(\pending_reg_n_0_[3] ),
        .R(\shared_features.u_features_n_21 ));
  FDRE \pending_reg[4] 
       (.C(clk),
        .CE(1'b1),
        .D(\shared_features.u_features_n_4 ),
        .Q(\pending_reg_n_0_[4] ),
        .R(\shared_features.u_features_n_21 ));
  FDRE \pending_reg[5] 
       (.C(clk),
        .CE(1'b1),
        .D(\shared_features.u_features_n_3 ),
        .Q(\pending_reg_n_0_[5] ),
        .R(\shared_features.u_features_n_21 ));
  FDRE \pending_reg[6] 
       (.C(clk),
        .CE(1'b1),
        .D(\shared_features.u_features_n_2 ),
        .Q(\pending_reg_n_0_[6] ),
        .R(\shared_features.u_features_n_21 ));
  FDRE \pending_reg[7] 
       (.C(clk),
        .CE(1'b1),
        .D(\shared_features.u_features_n_0 ),
        .Q(\pending_reg_n_0_[7] ),
        .R(\shared_features.u_features_n_21 ));
  LUT6 #(
    .INIT(64'h000000002666E666)) 
    \scan_ptr[0]_i_1 
       (.I0(\scan_ptr_reg_n_0_[0] ),
        .I1(\scan_ptr[2]_i_2_n_0 ),
        .I2(feature_valid),
        .I3(feature_ready),
        .I4(feature_channel[0]),
        .I5(\scan_ptr[2]_i_4_n_0 ),
        .O(\scan_ptr[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8888888808888888)) 
    \scan_ptr[1]_i_1 
       (.I0(\scan_ptr[1]_i_2_n_0 ),
        .I1(rst_n),
        .I2(feature_channel[2]),
        .I3(feature_channel[0]),
        .I4(feature_channel[1]),
        .I5(\shared_features.u_features_n_1 ),
        .O(\scan_ptr[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h606FFFFF6F600000)) 
    \scan_ptr[1]_i_2 
       (.I0(feature_channel[0]),
        .I1(feature_channel[1]),
        .I2(pending1),
        .I3(\scan_ptr_reg_n_0_[0] ),
        .I4(\scan_ptr[2]_i_2_n_0 ),
        .I5(\scan_ptr_reg_n_0_[1] ),
        .O(\scan_ptr[1]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'h00E2)) 
    \scan_ptr[2]_i_1 
       (.I0(\scan_ptr_reg_n_0_[2] ),
        .I1(\scan_ptr[2]_i_2_n_0 ),
        .I2(\scan_ptr[2]_i_3_n_0 ),
        .I3(\scan_ptr[2]_i_4_n_0 ),
        .O(\scan_ptr[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h000C000055555555)) 
    \scan_ptr[2]_i_2 
       (.I0(busy0),
        .I1(\^feature_id [2]),
        .I2(\^feature_id [0]),
        .I3(\^feature_id [1]),
        .I4(feature_ready),
        .I5(feature_valid),
        .O(\scan_ptr[2]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h606F6F606F606F60)) 
    \scan_ptr[2]_i_3 
       (.I0(feature_channel[2]),
        .I1(\scan_ptr[2]_i_5_n_0 ),
        .I2(pending1),
        .I3(\scan_ptr_reg_n_0_[2] ),
        .I4(\scan_ptr_reg_n_0_[1] ),
        .I5(\scan_ptr_reg_n_0_[0] ),
        .O(\scan_ptr[2]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair207" *) 
  LUT5 #(
    .INIT(32'h4000FFFF)) 
    \scan_ptr[2]_i_4 
       (.I0(\shared_features.u_features_n_1 ),
        .I1(feature_channel[1]),
        .I2(feature_channel[0]),
        .I3(feature_channel[2]),
        .I4(rst_n),
        .O(\scan_ptr[2]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair207" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \scan_ptr[2]_i_5 
       (.I0(feature_channel[0]),
        .I1(feature_channel[1]),
        .O(\scan_ptr[2]_i_5_n_0 ));
  FDRE \scan_ptr_reg[0] 
       (.C(clk),
        .CE(1'b1),
        .D(\scan_ptr[0]_i_1_n_0 ),
        .Q(\scan_ptr_reg_n_0_[0] ),
        .R(1'b0));
  FDRE \scan_ptr_reg[1] 
       (.C(clk),
        .CE(1'b1),
        .D(\scan_ptr[1]_i_1_n_0 ),
        .Q(\scan_ptr_reg_n_0_[1] ),
        .R(1'b0));
  FDRE \scan_ptr_reg[2] 
       (.C(clk),
        .CE(1'b1),
        .D(\scan_ptr[2]_i_1_n_0 ),
        .Q(\scan_ptr_reg_n_0_[2] ),
        .R(1'b0));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "1280" *) 
  (* RTL_RAM_NAME = "emg_feature_bank/shared_capture.hold_mem_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "0" *) 
  (* ram_slice_end = "5" *) 
  RAM32M \shared_capture.hold_mem_reg_0_7_0_5 
       (.ADDRA({1'b0,1'b0,feature_channel}),
        .ADDRB({1'b0,1'b0,feature_channel}),
        .ADDRC({1'b0,1'b0,feature_channel}),
        .ADDRD({1'b0,1'b0,shared_channel}),
        .DIA(shared_ssc[1:0]),
        .DIB(shared_ssc[3:2]),
        .DIC(shared_ssc[5:4]),
        .DID({1'b0,1'b0}),
        .DOA(hold_word0[1:0]),
        .DOB(hold_word0[3:2]),
        .DOC(hold_word0[5:4]),
        .DOD(\NLW_shared_capture.hold_mem_reg_0_7_0_5_DOD_UNCONNECTED [1:0]),
        .WCLK(clk),
        .WE(p_0_in5_out));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "1280" *) 
  (* RTL_RAM_NAME = "emg_feature_bank/shared_capture.hold_mem_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "102" *) 
  (* ram_slice_end = "107" *) 
  RAM32M \shared_capture.hold_mem_reg_0_7_102_107 
       (.ADDRA({1'b0,1'b0,feature_channel}),
        .ADDRB({1'b0,1'b0,feature_channel}),
        .ADDRC({1'b0,1'b0,feature_channel}),
        .ADDRD({1'b0,1'b0,shared_channel}),
        .DIA(shared_wl[7:6]),
        .DIB(shared_wl[9:8]),
        .DIC(shared_wl[11:10]),
        .DID({1'b0,1'b0}),
        .DOA(hold_word0[103:102]),
        .DOB(hold_word0[105:104]),
        .DOC(hold_word0[107:106]),
        .DOD(\NLW_shared_capture.hold_mem_reg_0_7_102_107_DOD_UNCONNECTED [1:0]),
        .WCLK(clk),
        .WE(p_0_in5_out));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "1280" *) 
  (* RTL_RAM_NAME = "emg_feature_bank/shared_capture.hold_mem_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "108" *) 
  (* ram_slice_end = "113" *) 
  RAM32M \shared_capture.hold_mem_reg_0_7_108_113 
       (.ADDRA({1'b0,1'b0,feature_channel}),
        .ADDRB({1'b0,1'b0,feature_channel}),
        .ADDRC({1'b0,1'b0,feature_channel}),
        .ADDRD({1'b0,1'b0,shared_channel}),
        .DIA(shared_wl[13:12]),
        .DIB(shared_wl[15:14]),
        .DIC(shared_wl[17:16]),
        .DID({1'b0,1'b0}),
        .DOA(hold_word0[109:108]),
        .DOB(hold_word0[111:110]),
        .DOC(hold_word0[113:112]),
        .DOD(\NLW_shared_capture.hold_mem_reg_0_7_108_113_DOD_UNCONNECTED [1:0]),
        .WCLK(clk),
        .WE(p_0_in5_out));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "1280" *) 
  (* RTL_RAM_NAME = "emg_feature_bank/shared_capture.hold_mem_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "114" *) 
  (* ram_slice_end = "119" *) 
  RAM32M \shared_capture.hold_mem_reg_0_7_114_119 
       (.ADDRA({1'b0,1'b0,feature_channel}),
        .ADDRB({1'b0,1'b0,feature_channel}),
        .ADDRC({1'b0,1'b0,feature_channel}),
        .ADDRD({1'b0,1'b0,shared_channel}),
        .DIA(shared_wl[19:18]),
        .DIB(shared_wl[21:20]),
        .DIC(shared_wl[23:22]),
        .DID({1'b0,1'b0}),
        .DOA(hold_word0[115:114]),
        .DOB(hold_word0[117:116]),
        .DOC(hold_word0[119:118]),
        .DOD(\NLW_shared_capture.hold_mem_reg_0_7_114_119_DOD_UNCONNECTED [1:0]),
        .WCLK(clk),
        .WE(p_0_in5_out));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "1280" *) 
  (* RTL_RAM_NAME = "emg_feature_bank/shared_capture.hold_mem_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "120" *) 
  (* ram_slice_end = "125" *) 
  RAM32M \shared_capture.hold_mem_reg_0_7_120_125 
       (.ADDRA({1'b0,1'b0,feature_channel}),
        .ADDRB({1'b0,1'b0,feature_channel}),
        .ADDRC({1'b0,1'b0,feature_channel}),
        .ADDRD({1'b0,1'b0,shared_channel}),
        .DIA(shared_wl[25:24]),
        .DIB(shared_wl[27:26]),
        .DIC(shared_wl[29:28]),
        .DID({1'b0,1'b0}),
        .DOA(hold_word0[121:120]),
        .DOB(hold_word0[123:122]),
        .DOC(hold_word0[125:124]),
        .DOD(\NLW_shared_capture.hold_mem_reg_0_7_120_125_DOD_UNCONNECTED [1:0]),
        .WCLK(clk),
        .WE(p_0_in5_out));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "1280" *) 
  (* RTL_RAM_NAME = "emg_feature_bank/shared_capture.hold_mem_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "126" *) 
  (* ram_slice_end = "131" *) 
  RAM32M \shared_capture.hold_mem_reg_0_7_126_131 
       (.ADDRA({1'b0,1'b0,feature_channel}),
        .ADDRB({1'b0,1'b0,feature_channel}),
        .ADDRC({1'b0,1'b0,feature_channel}),
        .ADDRD({1'b0,1'b0,shared_channel}),
        .DIA(shared_wl[31:30]),
        .DIB(shared_mav[1:0]),
        .DIC(shared_mav[3:2]),
        .DID({1'b0,1'b0}),
        .DOA(hold_word0[127:126]),
        .DOB(hold_word0[129:128]),
        .DOC(hold_word0[131:130]),
        .DOD(\NLW_shared_capture.hold_mem_reg_0_7_126_131_DOD_UNCONNECTED [1:0]),
        .WCLK(clk),
        .WE(p_0_in5_out));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "1280" *) 
  (* RTL_RAM_NAME = "emg_feature_bank/shared_capture.hold_mem_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "132" *) 
  (* ram_slice_end = "137" *) 
  RAM32M \shared_capture.hold_mem_reg_0_7_132_137 
       (.ADDRA({1'b0,1'b0,feature_channel}),
        .ADDRB({1'b0,1'b0,feature_channel}),
        .ADDRC({1'b0,1'b0,feature_channel}),
        .ADDRD({1'b0,1'b0,shared_channel}),
        .DIA(shared_mav[5:4]),
        .DIB(shared_mav[7:6]),
        .DIC(shared_mav[9:8]),
        .DID({1'b0,1'b0}),
        .DOA(hold_word0[133:132]),
        .DOB(hold_word0[135:134]),
        .DOC(hold_word0[137:136]),
        .DOD(\NLW_shared_capture.hold_mem_reg_0_7_132_137_DOD_UNCONNECTED [1:0]),
        .WCLK(clk),
        .WE(p_0_in5_out));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "1280" *) 
  (* RTL_RAM_NAME = "emg_feature_bank/shared_capture.hold_mem_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "138" *) 
  (* ram_slice_end = "143" *) 
  RAM32M \shared_capture.hold_mem_reg_0_7_138_143 
       (.ADDRA({1'b0,1'b0,feature_channel}),
        .ADDRB({1'b0,1'b0,feature_channel}),
        .ADDRC({1'b0,1'b0,feature_channel}),
        .ADDRD({1'b0,1'b0,shared_channel}),
        .DIA(shared_mav[11:10]),
        .DIB(shared_mav[13:12]),
        .DIC(shared_mav[15:14]),
        .DID({1'b0,1'b0}),
        .DOA(hold_word0[139:138]),
        .DOB(hold_word0[141:140]),
        .DOC(hold_word0[143:142]),
        .DOD(\NLW_shared_capture.hold_mem_reg_0_7_138_143_DOD_UNCONNECTED [1:0]),
        .WCLK(clk),
        .WE(p_0_in5_out));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "1280" *) 
  (* RTL_RAM_NAME = "emg_feature_bank/shared_capture.hold_mem_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "144" *) 
  (* ram_slice_end = "149" *) 
  RAM32M \shared_capture.hold_mem_reg_0_7_144_149 
       (.ADDRA({1'b0,1'b0,feature_channel}),
        .ADDRB({1'b0,1'b0,feature_channel}),
        .ADDRC({1'b0,1'b0,feature_channel}),
        .ADDRD({1'b0,1'b0,shared_channel}),
        .DIA(shared_mav[17:16]),
        .DIB(shared_mav[19:18]),
        .DIC(shared_mav[21:20]),
        .DID({1'b0,1'b0}),
        .DOA(hold_word0[145:144]),
        .DOB(hold_word0[147:146]),
        .DOC(hold_word0[149:148]),
        .DOD(\NLW_shared_capture.hold_mem_reg_0_7_144_149_DOD_UNCONNECTED [1:0]),
        .WCLK(clk),
        .WE(p_0_in5_out));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "1280" *) 
  (* RTL_RAM_NAME = "emg_feature_bank/shared_capture.hold_mem_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "150" *) 
  (* ram_slice_end = "155" *) 
  RAM32M \shared_capture.hold_mem_reg_0_7_150_155 
       (.ADDRA({1'b0,1'b0,feature_channel}),
        .ADDRB({1'b0,1'b0,feature_channel}),
        .ADDRC({1'b0,1'b0,feature_channel}),
        .ADDRD({1'b0,1'b0,shared_channel}),
        .DIA(shared_mav[23:22]),
        .DIB(shared_mav[25:24]),
        .DIC(shared_mav[27:26]),
        .DID({1'b0,1'b0}),
        .DOA(hold_word0[151:150]),
        .DOB(hold_word0[153:152]),
        .DOC(hold_word0[155:154]),
        .DOD(\NLW_shared_capture.hold_mem_reg_0_7_150_155_DOD_UNCONNECTED [1:0]),
        .WCLK(clk),
        .WE(p_0_in5_out));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "1280" *) 
  (* RTL_RAM_NAME = "emg_feature_bank/shared_capture.hold_mem_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "30" *) 
  (* ram_slice_end = "35" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000)) 
    \shared_capture.hold_mem_reg_0_7_30_35 
       (.ADDRA({1'b0,1'b0,feature_channel}),
        .ADDRB({1'b0,1'b0,feature_channel}),
        .ADDRC({1'b0,1'b0,feature_channel}),
        .ADDRD({1'b0,1'b0,shared_channel}),
        .DIA(shared_zc[1:0]),
        .DIB(shared_zc[3:2]),
        .DIC({1'b0,1'b0}),
        .DID({1'b0,1'b0}),
        .DOA(hold_word0[33:32]),
        .DOB(hold_word0[35:34]),
        .DOC(\NLW_shared_capture.hold_mem_reg_0_7_30_35_DOC_UNCONNECTED [1:0]),
        .DOD(\NLW_shared_capture.hold_mem_reg_0_7_30_35_DOD_UNCONNECTED [1:0]),
        .WCLK(clk),
        .WE(p_0_in5_out));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "1280" *) 
  (* RTL_RAM_NAME = "emg_feature_bank/shared_capture.hold_mem_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "36" *) 
  (* ram_slice_end = "41" *) 
  RAM32M \shared_capture.hold_mem_reg_0_7_36_41 
       (.ADDRA({1'b0,1'b0,feature_channel}),
        .ADDRB({1'b0,1'b0,feature_channel}),
        .ADDRC({1'b0,1'b0,feature_channel}),
        .ADDRD({1'b0,1'b0,shared_channel}),
        .DIA(shared_zc[5:4]),
        .DIB(shared_zc[7:6]),
        .DIC({1'b0,shared_zc[8]}),
        .DID({1'b0,1'b0}),
        .DOA(hold_word0[37:36]),
        .DOB(hold_word0[39:38]),
        .DOC(hold_word0[41:40]),
        .DOD(\NLW_shared_capture.hold_mem_reg_0_7_36_41_DOD_UNCONNECTED [1:0]),
        .WCLK(clk),
        .WE(p_0_in5_out));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "1280" *) 
  (* RTL_RAM_NAME = "emg_feature_bank/shared_capture.hold_mem_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "60" *) 
  (* ram_slice_end = "65" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_C(64'h0000000000000000)) 
    \shared_capture.hold_mem_reg_0_7_60_65 
       (.ADDRA({1'b0,1'b0,feature_channel}),
        .ADDRB({1'b0,1'b0,feature_channel}),
        .ADDRC({1'b0,1'b0,feature_channel}),
        .ADDRD({1'b0,1'b0,shared_channel}),
        .DIA(shared_energy[1:0]),
        .DIB(shared_mav[29:28]),
        .DIC(shared_mav[31:30]),
        .DID({1'b0,1'b0}),
        .DOA(hold_word0[65:64]),
        .DOB(hold_word0[157:156]),
        .DOC(hold_word0[159:158]),
        .DOD(\NLW_shared_capture.hold_mem_reg_0_7_60_65_DOD_UNCONNECTED [1:0]),
        .WCLK(clk),
        .WE(p_0_in5_out));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "1280" *) 
  (* RTL_RAM_NAME = "emg_feature_bank/shared_capture.hold_mem_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "66" *) 
  (* ram_slice_end = "71" *) 
  RAM32M \shared_capture.hold_mem_reg_0_7_66_71 
       (.ADDRA({1'b0,1'b0,feature_channel}),
        .ADDRB({1'b0,1'b0,feature_channel}),
        .ADDRC({1'b0,1'b0,feature_channel}),
        .ADDRD({1'b0,1'b0,shared_channel}),
        .DIA(shared_energy[3:2]),
        .DIB(shared_energy[5:4]),
        .DIC(shared_energy[7:6]),
        .DID({1'b0,1'b0}),
        .DOA(hold_word0[67:66]),
        .DOB(hold_word0[69:68]),
        .DOC(hold_word0[71:70]),
        .DOD(\NLW_shared_capture.hold_mem_reg_0_7_66_71_DOD_UNCONNECTED [1:0]),
        .WCLK(clk),
        .WE(p_0_in5_out));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "1280" *) 
  (* RTL_RAM_NAME = "emg_feature_bank/shared_capture.hold_mem_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "6" *) 
  (* ram_slice_end = "11" *) 
  RAM32M \shared_capture.hold_mem_reg_0_7_6_11 
       (.ADDRA({1'b0,1'b0,feature_channel}),
        .ADDRB({1'b0,1'b0,feature_channel}),
        .ADDRC({1'b0,1'b0,feature_channel}),
        .ADDRD({1'b0,1'b0,shared_channel}),
        .DIA(shared_ssc[7:6]),
        .DIB({1'b0,shared_ssc[8]}),
        .DIC({1'b0,1'b0}),
        .DID({1'b0,1'b0}),
        .DOA(hold_word0[7:6]),
        .DOB(hold_word0[9:8]),
        .DOC(\NLW_shared_capture.hold_mem_reg_0_7_6_11_DOC_UNCONNECTED [1:0]),
        .DOD(\NLW_shared_capture.hold_mem_reg_0_7_6_11_DOD_UNCONNECTED [1:0]),
        .WCLK(clk),
        .WE(p_0_in5_out));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "1280" *) 
  (* RTL_RAM_NAME = "emg_feature_bank/shared_capture.hold_mem_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "72" *) 
  (* ram_slice_end = "77" *) 
  RAM32M \shared_capture.hold_mem_reg_0_7_72_77 
       (.ADDRA({1'b0,1'b0,feature_channel}),
        .ADDRB({1'b0,1'b0,feature_channel}),
        .ADDRC({1'b0,1'b0,feature_channel}),
        .ADDRD({1'b0,1'b0,shared_channel}),
        .DIA(shared_energy[9:8]),
        .DIB(shared_energy[11:10]),
        .DIC(shared_energy[13:12]),
        .DID({1'b0,1'b0}),
        .DOA(hold_word0[73:72]),
        .DOB(hold_word0[75:74]),
        .DOC(hold_word0[77:76]),
        .DOD(\NLW_shared_capture.hold_mem_reg_0_7_72_77_DOD_UNCONNECTED [1:0]),
        .WCLK(clk),
        .WE(p_0_in5_out));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "1280" *) 
  (* RTL_RAM_NAME = "emg_feature_bank/shared_capture.hold_mem_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "78" *) 
  (* ram_slice_end = "83" *) 
  RAM32M \shared_capture.hold_mem_reg_0_7_78_83 
       (.ADDRA({1'b0,1'b0,feature_channel}),
        .ADDRB({1'b0,1'b0,feature_channel}),
        .ADDRC({1'b0,1'b0,feature_channel}),
        .ADDRD({1'b0,1'b0,shared_channel}),
        .DIA(shared_energy[15:14]),
        .DIB(shared_energy[17:16]),
        .DIC(shared_energy[19:18]),
        .DID({1'b0,1'b0}),
        .DOA(hold_word0[79:78]),
        .DOB(hold_word0[81:80]),
        .DOC(hold_word0[83:82]),
        .DOD(\NLW_shared_capture.hold_mem_reg_0_7_78_83_DOD_UNCONNECTED [1:0]),
        .WCLK(clk),
        .WE(p_0_in5_out));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "1280" *) 
  (* RTL_RAM_NAME = "emg_feature_bank/shared_capture.hold_mem_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "84" *) 
  (* ram_slice_end = "89" *) 
  RAM32M \shared_capture.hold_mem_reg_0_7_84_89 
       (.ADDRA({1'b0,1'b0,feature_channel}),
        .ADDRB({1'b0,1'b0,feature_channel}),
        .ADDRC({1'b0,1'b0,feature_channel}),
        .ADDRD({1'b0,1'b0,shared_channel}),
        .DIA(shared_energy[21:20]),
        .DIB(shared_energy[23:22]),
        .DIC(shared_energy[25:24]),
        .DID({1'b0,1'b0}),
        .DOA(hold_word0[85:84]),
        .DOB(hold_word0[87:86]),
        .DOC(hold_word0[89:88]),
        .DOD(\NLW_shared_capture.hold_mem_reg_0_7_84_89_DOD_UNCONNECTED [1:0]),
        .WCLK(clk),
        .WE(p_0_in5_out));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "1280" *) 
  (* RTL_RAM_NAME = "emg_feature_bank/shared_capture.hold_mem_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "90" *) 
  (* ram_slice_end = "95" *) 
  RAM32M \shared_capture.hold_mem_reg_0_7_90_95 
       (.ADDRA({1'b0,1'b0,feature_channel}),
        .ADDRB({1'b0,1'b0,feature_channel}),
        .ADDRC({1'b0,1'b0,feature_channel}),
        .ADDRD({1'b0,1'b0,shared_channel}),
        .DIA(shared_energy[27:26]),
        .DIB(shared_energy[29:28]),
        .DIC(shared_energy[31:30]),
        .DID({1'b0,1'b0}),
        .DOA(hold_word0[91:90]),
        .DOB(hold_word0[93:92]),
        .DOC(hold_word0[95:94]),
        .DOD(\NLW_shared_capture.hold_mem_reg_0_7_90_95_DOD_UNCONNECTED [1:0]),
        .WCLK(clk),
        .WE(p_0_in5_out));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "1280" *) 
  (* RTL_RAM_NAME = "emg_feature_bank/shared_capture.hold_mem_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "96" *) 
  (* ram_slice_end = "101" *) 
  RAM32M \shared_capture.hold_mem_reg_0_7_96_101 
       (.ADDRA({1'b0,1'b0,feature_channel}),
        .ADDRB({1'b0,1'b0,feature_channel}),
        .ADDRC({1'b0,1'b0,feature_channel}),
        .ADDRD({1'b0,1'b0,shared_channel}),
        .DIA(shared_wl[1:0]),
        .DIB(shared_wl[3:2]),
        .DIC(shared_wl[5:4]),
        .DID({1'b0,1'b0}),
        .DOA(hold_word0[97:96]),
        .DOB(hold_word0[99:98]),
        .DOC(hold_word0[101:100]),
        .DOD(\NLW_shared_capture.hold_mem_reg_0_7_96_101_DOD_UNCONNECTED [1:0]),
        .WCLK(clk),
        .WE(p_0_in5_out));
  emg_window_features_shared \shared_features.u_features 
       (.I11({shared_mav[27:0],shared_wl,shared_energy[31:2],shared_mav[31:30],shared_zc[8:2],shared_ssc}),
        .\active_ch_reg[1] (\shared_features.u_features_n_0 ),
        .\active_ch_reg[2] (\shared_features.u_features_n_2 ),
        .\active_ch_reg[2]_0 (\shared_features.u_features_n_3 ),
        .\active_ch_reg[2]_1 (\shared_features.u_features_n_4 ),
        .\active_ch_reg[2]_2 (\shared_features.u_features_n_5 ),
        .\active_ch_reg[2]_3 (\shared_features.u_features_n_6 ),
        .\active_ch_reg[2]_4 (\shared_features.u_features_n_7 ),
        .\active_ch_reg[2]_5 (\shared_features.u_features_n_8 ),
        .busy_reg(\shared_features.u_features_n_1 ),
        .clk(clk),
        .energy_sum(shared_energy[1:0]),
        .feature_ready(feature_ready),
        .hold_seen(hold_seen),
        .mav_sum(shared_mav[29:28]),
        .p_0_in5_out(p_0_in5_out),
        .\pending_reg[0] (\pending_reg_n_0_[0] ),
        .\pending_reg[1] (\pending_reg_n_0_[1] ),
        .\pending_reg[2] (\pending_reg_n_0_[2] ),
        .\pending_reg[3] (\pending_reg_n_0_[3] ),
        .\pending_reg[4] (\pending_reg_n_0_[4] ),
        .\pending_reg[5] (\pending_reg_n_0_[5] ),
        .\pending_reg[6] (\pending_reg_n_0_[6] ),
        .\pending_reg[7] (feature_channel[1]),
        .\pending_reg[7]_0 (feature_channel[0]),
        .\pending_reg[7]_1 (feature_channel[2]),
        .\pending_reg[7]_2 (\pending_reg_n_0_[7] ),
        .\pending_reg[7]_3 (feature_valid),
        .\pending_reg[7]_4 (\^feature_id [1]),
        .\pending_reg[7]_5 (\^feature_id [0]),
        .\pending_reg[7]_6 (\^feature_id [2]),
        .rst_n(rst_n),
        .rst_n_0(\shared_features.u_features_n_21 ),
        .sample_channel(sample_channel),
        .sample_data(sample_data),
        .sample_valid(sample_valid),
        .window_channel(shared_channel),
        .\window_channel_reg[1]_0 (\shared_features.u_features_n_9 ),
        .\window_channel_reg[1]_1 (\shared_features.u_features_n_13 ),
        .\window_channel_reg[1]_2 (\shared_features.u_features_n_16 ),
        .\window_channel_reg[1]_3 (\shared_features.u_features_n_17 ),
        .\window_channel_reg[2]_0 (\shared_features.u_features_n_18 ),
        .\window_channel_reg[2]_1 (\shared_features.u_features_n_19 ),
        .window_valid_reg_0(\shared_features.u_features_n_14 ),
        .window_valid_reg_1(\shared_features.u_features_n_15 ),
        .zc_count(shared_zc[1:0]));
endmodule

module emg_window_features_shared
   (\active_ch_reg[1] ,
    busy_reg,
    \active_ch_reg[2] ,
    \active_ch_reg[2]_0 ,
    \active_ch_reg[2]_1 ,
    \active_ch_reg[2]_2 ,
    \active_ch_reg[2]_3 ,
    \active_ch_reg[2]_4 ,
    \active_ch_reg[2]_5 ,
    \window_channel_reg[1]_0 ,
    window_channel,
    \window_channel_reg[1]_1 ,
    window_valid_reg_0,
    window_valid_reg_1,
    \window_channel_reg[1]_2 ,
    \window_channel_reg[1]_3 ,
    \window_channel_reg[2]_0 ,
    \window_channel_reg[2]_1 ,
    p_0_in5_out,
    rst_n_0,
    I11,
    mav_sum,
    energy_sum,
    zc_count,
    \pending_reg[7] ,
    \pending_reg[7]_0 ,
    \pending_reg[7]_1 ,
    \pending_reg[7]_2 ,
    \pending_reg[6] ,
    \pending_reg[5] ,
    \pending_reg[4] ,
    \pending_reg[3] ,
    \pending_reg[2] ,
    \pending_reg[1] ,
    \pending_reg[0] ,
    hold_seen,
    \pending_reg[7]_3 ,
    feature_ready,
    \pending_reg[7]_4 ,
    \pending_reg[7]_5 ,
    \pending_reg[7]_6 ,
    rst_n,
    sample_data,
    sample_channel,
    sample_valid,
    clk);
  output \active_ch_reg[1] ;
  output busy_reg;
  output \active_ch_reg[2] ;
  output \active_ch_reg[2]_0 ;
  output \active_ch_reg[2]_1 ;
  output \active_ch_reg[2]_2 ;
  output \active_ch_reg[2]_3 ;
  output \active_ch_reg[2]_4 ;
  output \active_ch_reg[2]_5 ;
  output \window_channel_reg[1]_0 ;
  output [2:0]window_channel;
  output \window_channel_reg[1]_1 ;
  output window_valid_reg_0;
  output window_valid_reg_1;
  output \window_channel_reg[1]_2 ;
  output \window_channel_reg[1]_3 ;
  output \window_channel_reg[2]_0 ;
  output \window_channel_reg[2]_1 ;
  output p_0_in5_out;
  output rst_n_0;
  output [107:0]I11;
  output [1:0]mav_sum;
  output [1:0]energy_sum;
  output [1:0]zc_count;
  input \pending_reg[7] ;
  input \pending_reg[7]_0 ;
  input \pending_reg[7]_1 ;
  input \pending_reg[7]_2 ;
  input \pending_reg[6] ;
  input \pending_reg[5] ;
  input \pending_reg[4] ;
  input \pending_reg[3] ;
  input \pending_reg[2] ;
  input \pending_reg[1] ;
  input \pending_reg[0] ;
  input [7:0]hold_seen;
  input \pending_reg[7]_3 ;
  input feature_ready;
  input \pending_reg[7]_4 ;
  input \pending_reg[7]_5 ;
  input \pending_reg[7]_6 ;
  input rst_n;
  input [23:0]sample_data;
  input [2:0]sample_channel;
  input sample_valid;
  input clk;

  wire [107:0]I11;
  wire [24:1]abs_diff;
  wire [24:1]abs_diff1;
  wire [23:0]abs_diff3;
  wire \active_ch_reg[1] ;
  wire \active_ch_reg[2] ;
  wire \active_ch_reg[2]_0 ;
  wire \active_ch_reg[2]_1 ;
  wire \active_ch_reg[2]_2 ;
  wire \active_ch_reg[2]_3 ;
  wire \active_ch_reg[2]_4 ;
  wire \active_ch_reg[2]_5 ;
  wire busy_reg;
  wire clamp321;
  wire clamp3210_in;
  wire clk;
  wire [31:0]completed_energy;
  wire [31:0]completed_mav;
  wire [5:1]completed_ssc;
  wire [31:0]completed_wl;
  wire [5:1]completed_zc;
  wire context_next3;
  wire [323:0]context_word0;
  wire context_word1;
  wire contexts_reg_0_7_0_0_i_1_n_0;
  wire contexts_reg_0_7_0_0_i_2_n_0;
  wire contexts_reg_0_7_0_0_i_3_n_0;
  wire contexts_reg_0_7_0_0_i_4_n_0;
  wire contexts_reg_0_7_100_100_i_1_n_0;
  wire contexts_reg_0_7_101_101_i_1_n_0;
  wire contexts_reg_0_7_102_102_i_1_n_0;
  wire contexts_reg_0_7_103_103_i_10_n_0;
  wire contexts_reg_0_7_103_103_i_11_n_0;
  wire contexts_reg_0_7_103_103_i_12_n_0;
  wire contexts_reg_0_7_103_103_i_13_n_0;
  wire contexts_reg_0_7_103_103_i_14_n_0;
  wire contexts_reg_0_7_103_103_i_15_n_0;
  wire contexts_reg_0_7_103_103_i_16_n_0;
  wire contexts_reg_0_7_103_103_i_17_n_0;
  wire contexts_reg_0_7_103_103_i_18_n_0;
  wire contexts_reg_0_7_103_103_i_19_n_0;
  wire contexts_reg_0_7_103_103_i_1_n_0;
  wire contexts_reg_0_7_103_103_i_20_n_0;
  wire contexts_reg_0_7_103_103_i_21_n_0;
  wire contexts_reg_0_7_103_103_i_22_n_0;
  wire contexts_reg_0_7_103_103_i_2_n_0;
  wire contexts_reg_0_7_103_103_i_2_n_1;
  wire contexts_reg_0_7_103_103_i_2_n_2;
  wire contexts_reg_0_7_103_103_i_2_n_3;
  wire contexts_reg_0_7_103_103_i_3_n_0;
  wire contexts_reg_0_7_103_103_i_4_n_0;
  wire contexts_reg_0_7_103_103_i_5_n_0;
  wire contexts_reg_0_7_103_103_i_6_n_0;
  wire contexts_reg_0_7_103_103_i_7_n_0;
  wire contexts_reg_0_7_103_103_i_8_n_0;
  wire contexts_reg_0_7_103_103_i_9_n_0;
  wire contexts_reg_0_7_104_104_i_1_n_0;
  wire contexts_reg_0_7_105_105_i_1_n_0;
  wire contexts_reg_0_7_106_106_i_1_n_0;
  wire contexts_reg_0_7_107_107_i_10_n_0;
  wire contexts_reg_0_7_107_107_i_11_n_0;
  wire contexts_reg_0_7_107_107_i_12_n_0;
  wire contexts_reg_0_7_107_107_i_1_n_0;
  wire contexts_reg_0_7_107_107_i_2_n_0;
  wire contexts_reg_0_7_107_107_i_2_n_1;
  wire contexts_reg_0_7_107_107_i_2_n_2;
  wire contexts_reg_0_7_107_107_i_2_n_3;
  wire contexts_reg_0_7_107_107_i_3_n_0;
  wire contexts_reg_0_7_107_107_i_4_n_0;
  wire contexts_reg_0_7_107_107_i_5_n_0;
  wire contexts_reg_0_7_107_107_i_6_n_0;
  wire contexts_reg_0_7_107_107_i_7_n_0;
  wire contexts_reg_0_7_107_107_i_8_n_0;
  wire contexts_reg_0_7_107_107_i_9_n_0;
  wire contexts_reg_0_7_108_108_i_1_n_0;
  wire contexts_reg_0_7_109_109_i_1_n_0;
  wire contexts_reg_0_7_10_10_i_1_n_0;
  wire contexts_reg_0_7_110_110_i_1_n_0;
  wire contexts_reg_0_7_111_111_i_1_n_0;
  wire contexts_reg_0_7_111_111_i_2_n_1;
  wire contexts_reg_0_7_111_111_i_2_n_2;
  wire contexts_reg_0_7_111_111_i_2_n_3;
  wire contexts_reg_0_7_111_111_i_3_n_0;
  wire contexts_reg_0_7_111_111_i_4_n_0;
  wire contexts_reg_0_7_111_111_i_5_n_0;
  wire contexts_reg_0_7_111_111_i_6_n_0;
  wire contexts_reg_0_7_111_111_i_7_n_0;
  wire contexts_reg_0_7_111_111_i_8_n_0;
  wire contexts_reg_0_7_111_111_i_9_n_0;
  wire contexts_reg_0_7_112_112_i_1_n_0;
  wire contexts_reg_0_7_113_113_i_1_n_0;
  wire contexts_reg_0_7_114_114_i_1_n_0;
  wire contexts_reg_0_7_115_115_i_10_n_0;
  wire contexts_reg_0_7_115_115_i_11_n_0;
  wire contexts_reg_0_7_115_115_i_13_n_0;
  wire contexts_reg_0_7_115_115_i_14_n_0;
  wire contexts_reg_0_7_115_115_i_15_n_0;
  wire contexts_reg_0_7_115_115_i_16_n_0;
  wire contexts_reg_0_7_115_115_i_17_n_0;
  wire contexts_reg_0_7_115_115_i_18_n_0;
  wire contexts_reg_0_7_115_115_i_19_n_0;
  wire contexts_reg_0_7_115_115_i_1_n_0;
  wire contexts_reg_0_7_115_115_i_20_n_0;
  wire contexts_reg_0_7_115_115_i_21_n_0;
  wire contexts_reg_0_7_115_115_i_2_n_0;
  wire contexts_reg_0_7_115_115_i_2_n_1;
  wire contexts_reg_0_7_115_115_i_2_n_2;
  wire contexts_reg_0_7_115_115_i_2_n_3;
  wire contexts_reg_0_7_115_115_i_3_n_0;
  wire contexts_reg_0_7_115_115_i_4_n_0;
  wire contexts_reg_0_7_115_115_i_5_n_0;
  wire contexts_reg_0_7_115_115_i_6_n_0;
  wire contexts_reg_0_7_115_115_i_7_n_0;
  wire contexts_reg_0_7_115_115_i_8_n_0;
  wire contexts_reg_0_7_115_115_i_9_n_0;
  wire contexts_reg_0_7_116_116_i_1_n_0;
  wire contexts_reg_0_7_117_117_i_1_n_0;
  wire contexts_reg_0_7_118_118_i_1_n_0;
  wire contexts_reg_0_7_119_119_i_10_n_0;
  wire contexts_reg_0_7_119_119_i_11_n_0;
  wire contexts_reg_0_7_119_119_i_13_n_0;
  wire contexts_reg_0_7_119_119_i_14_n_0;
  wire contexts_reg_0_7_119_119_i_16_n_0;
  wire contexts_reg_0_7_119_119_i_18_n_0;
  wire contexts_reg_0_7_119_119_i_19_n_0;
  wire contexts_reg_0_7_119_119_i_1_n_0;
  wire contexts_reg_0_7_119_119_i_21_n_0;
  wire contexts_reg_0_7_119_119_i_22_n_0;
  wire contexts_reg_0_7_119_119_i_23_n_0;
  wire contexts_reg_0_7_119_119_i_24_n_0;
  wire contexts_reg_0_7_119_119_i_25_n_0;
  wire contexts_reg_0_7_119_119_i_26_n_0;
  wire contexts_reg_0_7_119_119_i_27_n_0;
  wire contexts_reg_0_7_119_119_i_28_n_0;
  wire contexts_reg_0_7_119_119_i_2_n_0;
  wire contexts_reg_0_7_119_119_i_2_n_1;
  wire contexts_reg_0_7_119_119_i_2_n_2;
  wire contexts_reg_0_7_119_119_i_2_n_3;
  wire contexts_reg_0_7_119_119_i_3_n_0;
  wire contexts_reg_0_7_119_119_i_4_n_0;
  wire contexts_reg_0_7_119_119_i_5_n_0;
  wire contexts_reg_0_7_119_119_i_6_n_0;
  wire contexts_reg_0_7_119_119_i_7_n_0;
  wire contexts_reg_0_7_119_119_i_8_n_0;
  wire contexts_reg_0_7_119_119_i_9_n_0;
  wire contexts_reg_0_7_11_11_i_1_n_0;
  wire contexts_reg_0_7_11_11_i_2_n_0;
  wire contexts_reg_0_7_120_120_i_1_n_0;
  wire contexts_reg_0_7_121_121_i_1_n_0;
  wire contexts_reg_0_7_122_122_i_1_n_0;
  wire contexts_reg_0_7_123_123_i_10_n_0;
  wire contexts_reg_0_7_123_123_i_11_n_0;
  wire contexts_reg_0_7_123_123_i_13_n_0;
  wire contexts_reg_0_7_123_123_i_14_n_0;
  wire contexts_reg_0_7_123_123_i_15_n_0;
  wire contexts_reg_0_7_123_123_i_17_n_0;
  wire contexts_reg_0_7_123_123_i_19_n_0;
  wire contexts_reg_0_7_123_123_i_1_n_0;
  wire contexts_reg_0_7_123_123_i_20_n_0;
  wire contexts_reg_0_7_123_123_i_21_n_0;
  wire contexts_reg_0_7_123_123_i_23_n_0;
  wire contexts_reg_0_7_123_123_i_24_n_0;
  wire contexts_reg_0_7_123_123_i_25_n_0;
  wire contexts_reg_0_7_123_123_i_26_n_0;
  wire contexts_reg_0_7_123_123_i_27_n_0;
  wire contexts_reg_0_7_123_123_i_28_n_0;
  wire contexts_reg_0_7_123_123_i_29_n_0;
  wire contexts_reg_0_7_123_123_i_2_n_0;
  wire contexts_reg_0_7_123_123_i_2_n_1;
  wire contexts_reg_0_7_123_123_i_2_n_2;
  wire contexts_reg_0_7_123_123_i_2_n_3;
  wire contexts_reg_0_7_123_123_i_30_n_0;
  wire contexts_reg_0_7_123_123_i_31_n_0;
  wire contexts_reg_0_7_123_123_i_32_n_0;
  wire contexts_reg_0_7_123_123_i_3_n_0;
  wire contexts_reg_0_7_123_123_i_4_n_0;
  wire contexts_reg_0_7_123_123_i_5_n_0;
  wire contexts_reg_0_7_123_123_i_6_n_0;
  wire contexts_reg_0_7_123_123_i_7_n_0;
  wire contexts_reg_0_7_123_123_i_8_n_0;
  wire contexts_reg_0_7_123_123_i_9_n_0;
  wire contexts_reg_0_7_124_124_i_1_n_0;
  wire contexts_reg_0_7_125_125_i_1_n_0;
  wire contexts_reg_0_7_126_126_i_1_n_0;
  wire contexts_reg_0_7_127_127_i_10_n_0;
  wire contexts_reg_0_7_127_127_i_12_n_0;
  wire contexts_reg_0_7_127_127_i_13_n_0;
  wire contexts_reg_0_7_127_127_i_14_n_0;
  wire contexts_reg_0_7_127_127_i_16_n_0;
  wire contexts_reg_0_7_127_127_i_17_n_0;
  wire contexts_reg_0_7_127_127_i_19_n_0;
  wire contexts_reg_0_7_127_127_i_1_n_0;
  wire contexts_reg_0_7_127_127_i_21_n_0;
  wire contexts_reg_0_7_127_127_i_22_n_0;
  wire contexts_reg_0_7_127_127_i_23_n_0;
  wire contexts_reg_0_7_127_127_i_24_n_0;
  wire contexts_reg_0_7_127_127_i_25_n_0;
  wire contexts_reg_0_7_127_127_i_26_n_0;
  wire contexts_reg_0_7_127_127_i_27_n_0;
  wire contexts_reg_0_7_127_127_i_28_n_0;
  wire contexts_reg_0_7_127_127_i_29_n_0;
  wire contexts_reg_0_7_127_127_i_2_n_0;
  wire contexts_reg_0_7_127_127_i_2_n_1;
  wire contexts_reg_0_7_127_127_i_2_n_2;
  wire contexts_reg_0_7_127_127_i_2_n_3;
  wire contexts_reg_0_7_127_127_i_30_n_0;
  wire contexts_reg_0_7_127_127_i_3_n_0;
  wire contexts_reg_0_7_127_127_i_4_n_0;
  wire contexts_reg_0_7_127_127_i_5_n_0;
  wire contexts_reg_0_7_127_127_i_6_n_0;
  wire contexts_reg_0_7_127_127_i_7_n_0;
  wire contexts_reg_0_7_127_127_i_8_n_0;
  wire contexts_reg_0_7_127_127_i_9_n_0;
  wire contexts_reg_0_7_128_128_i_1_n_0;
  wire contexts_reg_0_7_129_129_i_1_n_0;
  wire contexts_reg_0_7_12_12_i_1_n_0;
  wire contexts_reg_0_7_12_12_i_2_n_0;
  wire contexts_reg_0_7_130_130_i_1_n_0;
  wire contexts_reg_0_7_131_131_i_10_n_0;
  wire contexts_reg_0_7_131_131_i_11_n_0;
  wire contexts_reg_0_7_131_131_i_13_n_0;
  wire contexts_reg_0_7_131_131_i_14_n_0;
  wire contexts_reg_0_7_131_131_i_16_n_0;
  wire contexts_reg_0_7_131_131_i_17_n_0;
  wire contexts_reg_0_7_131_131_i_19_n_0;
  wire contexts_reg_0_7_131_131_i_1_n_0;
  wire contexts_reg_0_7_131_131_i_20_n_0;
  wire contexts_reg_0_7_131_131_i_22_n_0;
  wire contexts_reg_0_7_131_131_i_23_n_0;
  wire contexts_reg_0_7_131_131_i_24_n_0;
  wire contexts_reg_0_7_131_131_i_25_n_0;
  wire contexts_reg_0_7_131_131_i_26_n_0;
  wire contexts_reg_0_7_131_131_i_27_n_0;
  wire contexts_reg_0_7_131_131_i_28_n_0;
  wire contexts_reg_0_7_131_131_i_29_n_0;
  wire contexts_reg_0_7_131_131_i_2_n_0;
  wire contexts_reg_0_7_131_131_i_2_n_1;
  wire contexts_reg_0_7_131_131_i_2_n_2;
  wire contexts_reg_0_7_131_131_i_2_n_3;
  wire contexts_reg_0_7_131_131_i_30_n_0;
  wire contexts_reg_0_7_131_131_i_3_n_0;
  wire contexts_reg_0_7_131_131_i_4_n_0;
  wire contexts_reg_0_7_131_131_i_5_n_0;
  wire contexts_reg_0_7_131_131_i_6_n_0;
  wire contexts_reg_0_7_131_131_i_7_n_0;
  wire contexts_reg_0_7_131_131_i_8_n_0;
  wire contexts_reg_0_7_131_131_i_9_n_0;
  wire contexts_reg_0_7_132_132_i_1_n_0;
  wire contexts_reg_0_7_133_133_i_1_n_0;
  wire contexts_reg_0_7_134_134_i_1_n_0;
  wire contexts_reg_0_7_135_135_i_10_n_0;
  wire contexts_reg_0_7_135_135_i_11_n_0;
  wire contexts_reg_0_7_135_135_i_13_n_0;
  wire contexts_reg_0_7_135_135_i_15_n_0;
  wire contexts_reg_0_7_135_135_i_16_n_0;
  wire contexts_reg_0_7_135_135_i_18_n_0;
  wire contexts_reg_0_7_135_135_i_19_n_0;
  wire contexts_reg_0_7_135_135_i_1_n_0;
  wire contexts_reg_0_7_135_135_i_21_n_0;
  wire contexts_reg_0_7_135_135_i_22_n_0;
  wire contexts_reg_0_7_135_135_i_23_n_0;
  wire contexts_reg_0_7_135_135_i_24_n_0;
  wire contexts_reg_0_7_135_135_i_25_n_0;
  wire contexts_reg_0_7_135_135_i_26_n_0;
  wire contexts_reg_0_7_135_135_i_27_n_0;
  wire contexts_reg_0_7_135_135_i_28_n_0;
  wire contexts_reg_0_7_135_135_i_29_n_0;
  wire contexts_reg_0_7_135_135_i_2_n_0;
  wire contexts_reg_0_7_135_135_i_2_n_1;
  wire contexts_reg_0_7_135_135_i_2_n_2;
  wire contexts_reg_0_7_135_135_i_2_n_3;
  wire contexts_reg_0_7_135_135_i_3_n_0;
  wire contexts_reg_0_7_135_135_i_4_n_0;
  wire contexts_reg_0_7_135_135_i_5_n_0;
  wire contexts_reg_0_7_135_135_i_6_n_0;
  wire contexts_reg_0_7_135_135_i_7_n_0;
  wire contexts_reg_0_7_135_135_i_8_n_0;
  wire contexts_reg_0_7_135_135_i_9_n_0;
  wire contexts_reg_0_7_136_136_i_1_n_0;
  wire contexts_reg_0_7_137_137_i_1_n_0;
  wire contexts_reg_0_7_138_138_i_1_n_0;
  wire contexts_reg_0_7_139_139_i_10_n_0;
  wire contexts_reg_0_7_139_139_i_11_n_0;
  wire contexts_reg_0_7_139_139_i_12_n_0;
  wire contexts_reg_0_7_139_139_i_13_n_0;
  wire contexts_reg_0_7_139_139_i_14_n_0;
  wire contexts_reg_0_7_139_139_i_15_n_0;
  wire contexts_reg_0_7_139_139_i_17_n_0;
  wire contexts_reg_0_7_139_139_i_18_n_0;
  wire contexts_reg_0_7_139_139_i_19_n_0;
  wire contexts_reg_0_7_139_139_i_1_n_0;
  wire contexts_reg_0_7_139_139_i_21_n_0;
  wire contexts_reg_0_7_139_139_i_22_n_0;
  wire contexts_reg_0_7_139_139_i_2_n_0;
  wire contexts_reg_0_7_139_139_i_2_n_1;
  wire contexts_reg_0_7_139_139_i_2_n_2;
  wire contexts_reg_0_7_139_139_i_2_n_3;
  wire contexts_reg_0_7_139_139_i_3_n_0;
  wire contexts_reg_0_7_139_139_i_4_n_0;
  wire contexts_reg_0_7_139_139_i_5_n_0;
  wire contexts_reg_0_7_139_139_i_6_n_0;
  wire contexts_reg_0_7_139_139_i_7_n_0;
  wire contexts_reg_0_7_139_139_i_8_n_0;
  wire contexts_reg_0_7_139_139_i_9_n_0;
  wire contexts_reg_0_7_13_13_i_1_n_0;
  wire contexts_reg_0_7_140_140_i_1_n_0;
  wire contexts_reg_0_7_141_141_i_1_n_0;
  wire contexts_reg_0_7_142_142_i_1_n_0;
  wire contexts_reg_0_7_143_143_i_10_n_0;
  wire contexts_reg_0_7_143_143_i_11_n_0;
  wire contexts_reg_0_7_143_143_i_12_n_0;
  wire contexts_reg_0_7_143_143_i_13_n_0;
  wire contexts_reg_0_7_143_143_i_14_n_0;
  wire contexts_reg_0_7_143_143_i_15_n_0;
  wire contexts_reg_0_7_143_143_i_16_n_0;
  wire contexts_reg_0_7_143_143_i_17_n_0;
  wire contexts_reg_0_7_143_143_i_18_n_0;
  wire contexts_reg_0_7_143_143_i_19_n_0;
  wire contexts_reg_0_7_143_143_i_1_n_0;
  wire contexts_reg_0_7_143_143_i_20_n_0;
  wire contexts_reg_0_7_143_143_i_21_n_0;
  wire contexts_reg_0_7_143_143_i_22_n_0;
  wire contexts_reg_0_7_143_143_i_2_n_0;
  wire contexts_reg_0_7_143_143_i_2_n_1;
  wire contexts_reg_0_7_143_143_i_2_n_2;
  wire contexts_reg_0_7_143_143_i_2_n_3;
  wire contexts_reg_0_7_143_143_i_3_n_0;
  wire contexts_reg_0_7_143_143_i_4_n_0;
  wire contexts_reg_0_7_143_143_i_5_n_0;
  wire contexts_reg_0_7_143_143_i_6_n_0;
  wire contexts_reg_0_7_143_143_i_7_n_0;
  wire contexts_reg_0_7_143_143_i_8_n_0;
  wire contexts_reg_0_7_143_143_i_9_n_0;
  wire contexts_reg_0_7_144_144_i_1_n_0;
  wire contexts_reg_0_7_145_145_i_1_n_0;
  wire contexts_reg_0_7_146_146_i_1_n_0;
  wire contexts_reg_0_7_147_147_i_10_n_0;
  wire contexts_reg_0_7_147_147_i_11_n_0;
  wire contexts_reg_0_7_147_147_i_12_n_0;
  wire contexts_reg_0_7_147_147_i_1_n_0;
  wire contexts_reg_0_7_147_147_i_2_n_0;
  wire contexts_reg_0_7_147_147_i_2_n_1;
  wire contexts_reg_0_7_147_147_i_2_n_2;
  wire contexts_reg_0_7_147_147_i_2_n_3;
  wire contexts_reg_0_7_147_147_i_3_n_0;
  wire contexts_reg_0_7_147_147_i_4_n_0;
  wire contexts_reg_0_7_147_147_i_5_n_0;
  wire contexts_reg_0_7_147_147_i_6_n_0;
  wire contexts_reg_0_7_147_147_i_7_n_0;
  wire contexts_reg_0_7_147_147_i_8_n_0;
  wire contexts_reg_0_7_147_147_i_9_n_0;
  wire contexts_reg_0_7_148_148_i_1_n_0;
  wire contexts_reg_0_7_149_149_i_1_n_0;
  wire contexts_reg_0_7_14_14_i_1_n_0;
  wire contexts_reg_0_7_14_14_i_2_n_0;
  wire contexts_reg_0_7_150_150_i_1_n_0;
  wire contexts_reg_0_7_151_151_i_1_n_0;
  wire contexts_reg_0_7_151_151_i_2_n_1;
  wire contexts_reg_0_7_151_151_i_2_n_2;
  wire contexts_reg_0_7_151_151_i_2_n_3;
  wire contexts_reg_0_7_151_151_i_3_n_0;
  wire contexts_reg_0_7_151_151_i_4_n_0;
  wire contexts_reg_0_7_151_151_i_5_n_0;
  wire contexts_reg_0_7_151_151_i_6_n_0;
  wire contexts_reg_0_7_151_151_i_7_n_0;
  wire contexts_reg_0_7_151_151_i_8_n_0;
  wire contexts_reg_0_7_151_151_i_9_n_0;
  wire contexts_reg_0_7_152_152_i_1_n_0;
  wire contexts_reg_0_7_153_153_i_1_n_0;
  wire contexts_reg_0_7_154_154_i_1_n_0;
  wire contexts_reg_0_7_157_157_i_100_n_0;
  wire contexts_reg_0_7_157_157_i_101_n_0;
  wire contexts_reg_0_7_157_157_i_102_n_0;
  wire contexts_reg_0_7_157_157_i_103_n_0;
  wire contexts_reg_0_7_157_157_i_104_n_0;
  wire contexts_reg_0_7_157_157_i_105_n_0;
  wire contexts_reg_0_7_157_157_i_106_n_0;
  wire contexts_reg_0_7_157_157_i_107_n_0;
  wire contexts_reg_0_7_157_157_i_108_n_0;
  wire contexts_reg_0_7_157_157_i_109_n_0;
  wire contexts_reg_0_7_157_157_i_10_n_0;
  wire contexts_reg_0_7_157_157_i_110_n_0;
  wire contexts_reg_0_7_157_157_i_111_n_0;
  wire contexts_reg_0_7_157_157_i_112_n_0;
  wire contexts_reg_0_7_157_157_i_113_n_0;
  wire contexts_reg_0_7_157_157_i_114_n_0;
  wire contexts_reg_0_7_157_157_i_115_n_0;
  wire contexts_reg_0_7_157_157_i_116_n_0;
  wire contexts_reg_0_7_157_157_i_117_n_0;
  wire contexts_reg_0_7_157_157_i_118_n_0;
  wire contexts_reg_0_7_157_157_i_119_n_0;
  wire contexts_reg_0_7_157_157_i_11_n_0;
  wire contexts_reg_0_7_157_157_i_11_n_1;
  wire contexts_reg_0_7_157_157_i_11_n_2;
  wire contexts_reg_0_7_157_157_i_11_n_3;
  wire contexts_reg_0_7_157_157_i_11_n_4;
  wire contexts_reg_0_7_157_157_i_11_n_5;
  wire contexts_reg_0_7_157_157_i_11_n_6;
  wire contexts_reg_0_7_157_157_i_11_n_7;
  wire contexts_reg_0_7_157_157_i_12_n_0;
  wire contexts_reg_0_7_157_157_i_13_n_0;
  wire contexts_reg_0_7_157_157_i_14_n_0;
  wire contexts_reg_0_7_157_157_i_15_n_0;
  wire contexts_reg_0_7_157_157_i_16_n_0;
  wire contexts_reg_0_7_157_157_i_17_n_0;
  wire contexts_reg_0_7_157_157_i_18_n_0;
  wire contexts_reg_0_7_157_157_i_19_n_0;
  wire contexts_reg_0_7_157_157_i_20_n_0;
  wire contexts_reg_0_7_157_157_i_20_n_1;
  wire contexts_reg_0_7_157_157_i_20_n_2;
  wire contexts_reg_0_7_157_157_i_20_n_3;
  wire contexts_reg_0_7_157_157_i_21_n_0;
  wire contexts_reg_0_7_157_157_i_22_n_0;
  wire contexts_reg_0_7_157_157_i_23_n_0;
  wire contexts_reg_0_7_157_157_i_24_n_0;
  wire contexts_reg_0_7_157_157_i_25_n_0;
  wire contexts_reg_0_7_157_157_i_26_n_0;
  wire contexts_reg_0_7_157_157_i_27_n_0;
  wire contexts_reg_0_7_157_157_i_28_n_0;
  wire contexts_reg_0_7_157_157_i_29_n_1;
  wire contexts_reg_0_7_157_157_i_29_n_2;
  wire contexts_reg_0_7_157_157_i_29_n_3;
  wire contexts_reg_0_7_157_157_i_30_n_0;
  wire contexts_reg_0_7_157_157_i_30_n_1;
  wire contexts_reg_0_7_157_157_i_30_n_2;
  wire contexts_reg_0_7_157_157_i_30_n_3;
  wire contexts_reg_0_7_157_157_i_30_n_4;
  wire contexts_reg_0_7_157_157_i_30_n_5;
  wire contexts_reg_0_7_157_157_i_30_n_6;
  wire contexts_reg_0_7_157_157_i_30_n_7;
  wire contexts_reg_0_7_157_157_i_31_n_0;
  wire contexts_reg_0_7_157_157_i_32_n_0;
  wire contexts_reg_0_7_157_157_i_33_n_0;
  wire contexts_reg_0_7_157_157_i_34_n_0;
  wire contexts_reg_0_7_157_157_i_35_n_0;
  wire contexts_reg_0_7_157_157_i_36_n_0;
  wire contexts_reg_0_7_157_157_i_37_n_0;
  wire contexts_reg_0_7_157_157_i_38_n_0;
  wire contexts_reg_0_7_157_157_i_39_n_0;
  wire contexts_reg_0_7_157_157_i_39_n_1;
  wire contexts_reg_0_7_157_157_i_39_n_2;
  wire contexts_reg_0_7_157_157_i_39_n_3;
  wire contexts_reg_0_7_157_157_i_3_n_0;
  wire contexts_reg_0_7_157_157_i_40_n_0;
  wire contexts_reg_0_7_157_157_i_41_n_0;
  wire contexts_reg_0_7_157_157_i_42_n_0;
  wire contexts_reg_0_7_157_157_i_43_n_0;
  wire contexts_reg_0_7_157_157_i_44_n_0;
  wire contexts_reg_0_7_157_157_i_45_n_0;
  wire contexts_reg_0_7_157_157_i_46_n_0;
  wire contexts_reg_0_7_157_157_i_47_n_0;
  wire contexts_reg_0_7_157_157_i_48_n_0;
  wire contexts_reg_0_7_157_157_i_48_n_1;
  wire contexts_reg_0_7_157_157_i_48_n_2;
  wire contexts_reg_0_7_157_157_i_48_n_3;
  wire contexts_reg_0_7_157_157_i_49_n_0;
  wire contexts_reg_0_7_157_157_i_49_n_1;
  wire contexts_reg_0_7_157_157_i_49_n_2;
  wire contexts_reg_0_7_157_157_i_49_n_3;
  wire contexts_reg_0_7_157_157_i_4_n_0;
  wire contexts_reg_0_7_157_157_i_50_n_0;
  wire contexts_reg_0_7_157_157_i_51_n_0;
  wire contexts_reg_0_7_157_157_i_52_n_0;
  wire contexts_reg_0_7_157_157_i_53_n_0;
  wire contexts_reg_0_7_157_157_i_53_n_1;
  wire contexts_reg_0_7_157_157_i_53_n_2;
  wire contexts_reg_0_7_157_157_i_53_n_3;
  wire contexts_reg_0_7_157_157_i_53_n_4;
  wire contexts_reg_0_7_157_157_i_53_n_5;
  wire contexts_reg_0_7_157_157_i_53_n_6;
  wire contexts_reg_0_7_157_157_i_53_n_7;
  wire contexts_reg_0_7_157_157_i_54_n_0;
  wire contexts_reg_0_7_157_157_i_55_n_0;
  wire contexts_reg_0_7_157_157_i_56_n_0;
  wire contexts_reg_0_7_157_157_i_57_n_0;
  wire contexts_reg_0_7_157_157_i_58_n_0;
  wire contexts_reg_0_7_157_157_i_59_n_0;
  wire contexts_reg_0_7_157_157_i_5_n_3;
  wire contexts_reg_0_7_157_157_i_60_n_0;
  wire contexts_reg_0_7_157_157_i_61_n_0;
  wire contexts_reg_0_7_157_157_i_62_n_0;
  wire contexts_reg_0_7_157_157_i_63_n_0;
  wire contexts_reg_0_7_157_157_i_64_n_0;
  wire contexts_reg_0_7_157_157_i_65_n_0;
  wire contexts_reg_0_7_157_157_i_66_n_0;
  wire contexts_reg_0_7_157_157_i_67_n_0;
  wire contexts_reg_0_7_157_157_i_68_n_0;
  wire contexts_reg_0_7_157_157_i_69_n_0;
  wire contexts_reg_0_7_157_157_i_6_n_3;
  wire contexts_reg_0_7_157_157_i_70_n_0;
  wire contexts_reg_0_7_157_157_i_70_n_1;
  wire contexts_reg_0_7_157_157_i_70_n_2;
  wire contexts_reg_0_7_157_157_i_70_n_3;
  wire contexts_reg_0_7_157_157_i_71_n_0;
  wire contexts_reg_0_7_157_157_i_71_n_1;
  wire contexts_reg_0_7_157_157_i_71_n_2;
  wire contexts_reg_0_7_157_157_i_71_n_3;
  wire contexts_reg_0_7_157_157_i_72_n_0;
  wire contexts_reg_0_7_157_157_i_73_n_0;
  wire contexts_reg_0_7_157_157_i_74_n_0;
  wire contexts_reg_0_7_157_157_i_75_n_0;
  wire contexts_reg_0_7_157_157_i_76_n_0;
  wire contexts_reg_0_7_157_157_i_77_n_0;
  wire contexts_reg_0_7_157_157_i_78_n_0;
  wire contexts_reg_0_7_157_157_i_79_n_0;
  wire contexts_reg_0_7_157_157_i_80_n_0;
  wire contexts_reg_0_7_157_157_i_80_n_1;
  wire contexts_reg_0_7_157_157_i_80_n_2;
  wire contexts_reg_0_7_157_157_i_80_n_3;
  wire contexts_reg_0_7_157_157_i_80_n_4;
  wire contexts_reg_0_7_157_157_i_80_n_5;
  wire contexts_reg_0_7_157_157_i_80_n_6;
  wire contexts_reg_0_7_157_157_i_80_n_7;
  wire contexts_reg_0_7_157_157_i_81_n_0;
  wire contexts_reg_0_7_157_157_i_82_n_0;
  wire contexts_reg_0_7_157_157_i_83_n_0;
  wire contexts_reg_0_7_157_157_i_84_n_0;
  wire contexts_reg_0_7_157_157_i_85_n_0;
  wire contexts_reg_0_7_157_157_i_86_n_0;
  wire contexts_reg_0_7_157_157_i_87_n_0;
  wire contexts_reg_0_7_157_157_i_88_n_0;
  wire contexts_reg_0_7_157_157_i_89_n_0;
  wire contexts_reg_0_7_157_157_i_89_n_1;
  wire contexts_reg_0_7_157_157_i_89_n_2;
  wire contexts_reg_0_7_157_157_i_89_n_3;
  wire contexts_reg_0_7_157_157_i_8_n_0;
  wire contexts_reg_0_7_157_157_i_8_n_1;
  wire contexts_reg_0_7_157_157_i_8_n_2;
  wire contexts_reg_0_7_157_157_i_8_n_3;
  wire contexts_reg_0_7_157_157_i_8_n_4;
  wire contexts_reg_0_7_157_157_i_8_n_5;
  wire contexts_reg_0_7_157_157_i_8_n_6;
  wire contexts_reg_0_7_157_157_i_8_n_7;
  wire contexts_reg_0_7_157_157_i_90_n_0;
  wire contexts_reg_0_7_157_157_i_90_n_1;
  wire contexts_reg_0_7_157_157_i_90_n_2;
  wire contexts_reg_0_7_157_157_i_90_n_3;
  wire contexts_reg_0_7_157_157_i_90_n_4;
  wire contexts_reg_0_7_157_157_i_90_n_5;
  wire contexts_reg_0_7_157_157_i_90_n_6;
  wire contexts_reg_0_7_157_157_i_90_n_7;
  wire contexts_reg_0_7_157_157_i_91_n_0;
  wire contexts_reg_0_7_157_157_i_92_n_0;
  wire contexts_reg_0_7_157_157_i_93_n_0;
  wire contexts_reg_0_7_157_157_i_94_n_0;
  wire contexts_reg_0_7_157_157_i_95_n_0;
  wire contexts_reg_0_7_157_157_i_96_n_0;
  wire contexts_reg_0_7_157_157_i_97_n_0;
  wire contexts_reg_0_7_157_157_i_98_n_0;
  wire contexts_reg_0_7_157_157_i_99_n_0;
  wire contexts_reg_0_7_157_157_i_9_n_0;
  wire contexts_reg_0_7_157_157_i_9_n_1;
  wire contexts_reg_0_7_157_157_i_9_n_2;
  wire contexts_reg_0_7_157_157_i_9_n_3;
  wire contexts_reg_0_7_15_15_i_1_n_0;
  wire contexts_reg_0_7_15_15_i_2_n_0;
  wire contexts_reg_0_7_160_160_i_1_n_0;
  wire contexts_reg_0_7_161_161_i_1_n_0;
  wire contexts_reg_0_7_161_161_i_2_n_0;
  wire contexts_reg_0_7_162_162_i_1_n_0;
  wire contexts_reg_0_7_163_163_i_1_n_0;
  wire contexts_reg_0_7_164_164_i_10_n_0;
  wire contexts_reg_0_7_164_164_i_11_n_0;
  wire contexts_reg_0_7_164_164_i_12_n_0;
  wire contexts_reg_0_7_164_164_i_13_n_0;
  wire contexts_reg_0_7_164_164_i_14_n_0;
  wire contexts_reg_0_7_164_164_i_14_n_1;
  wire contexts_reg_0_7_164_164_i_14_n_2;
  wire contexts_reg_0_7_164_164_i_14_n_3;
  wire contexts_reg_0_7_164_164_i_15_n_0;
  wire contexts_reg_0_7_164_164_i_16_n_0;
  wire contexts_reg_0_7_164_164_i_17_n_0;
  wire contexts_reg_0_7_164_164_i_18_n_0;
  wire contexts_reg_0_7_164_164_i_19_n_0;
  wire contexts_reg_0_7_164_164_i_20_n_0;
  wire contexts_reg_0_7_164_164_i_21_n_0;
  wire contexts_reg_0_7_164_164_i_22_n_0;
  wire contexts_reg_0_7_164_164_i_23_n_0;
  wire contexts_reg_0_7_164_164_i_24_n_0;
  wire contexts_reg_0_7_164_164_i_25_n_0;
  wire contexts_reg_0_7_164_164_i_26_n_0;
  wire contexts_reg_0_7_164_164_i_27_n_0;
  wire contexts_reg_0_7_164_164_i_28_n_0;
  wire contexts_reg_0_7_164_164_i_29_n_0;
  wire contexts_reg_0_7_164_164_i_30_n_0;
  wire contexts_reg_0_7_164_164_i_3_n_0;
  wire contexts_reg_0_7_164_164_i_3_n_1;
  wire contexts_reg_0_7_164_164_i_3_n_2;
  wire contexts_reg_0_7_164_164_i_3_n_3;
  wire contexts_reg_0_7_164_164_i_4_n_0;
  wire contexts_reg_0_7_164_164_i_5_n_0;
  wire contexts_reg_0_7_164_164_i_5_n_1;
  wire contexts_reg_0_7_164_164_i_5_n_2;
  wire contexts_reg_0_7_164_164_i_5_n_3;
  wire contexts_reg_0_7_164_164_i_6_n_0;
  wire contexts_reg_0_7_164_164_i_7_n_0;
  wire contexts_reg_0_7_164_164_i_8_n_0;
  wire contexts_reg_0_7_164_164_i_9_n_0;
  wire contexts_reg_0_7_165_165_i_2_n_0;
  wire contexts_reg_0_7_167_167_i_1_n_0;
  wire contexts_reg_0_7_167_167_i_2_n_0;
  wire contexts_reg_0_7_168_168_i_1_n_0;
  wire contexts_reg_0_7_169_169_i_1_n_0;
  wire contexts_reg_0_7_169_169_i_2_n_0;
  wire contexts_reg_0_7_16_16_i_2_n_0;
  wire contexts_reg_0_7_16_16_i_3_n_0;
  wire contexts_reg_0_7_170_170_i_1_n_0;
  wire contexts_reg_0_7_17_17_i_2_n_0;
  wire contexts_reg_0_7_17_17_i_3_n_0;
  wire contexts_reg_0_7_17_17_i_4_n_0;
  wire contexts_reg_0_7_1_1_i_1_n_0;
  wire contexts_reg_0_7_272_272_i_2_n_0;
  wire contexts_reg_0_7_272_272_i_3_n_0;
  wire contexts_reg_0_7_272_272_i_4_n_0;
  wire contexts_reg_0_7_274_274_i_2_n_0;
  wire contexts_reg_0_7_274_274_i_3_n_0;
  wire contexts_reg_0_7_276_276_i_1_n_0;
  wire contexts_reg_0_7_277_277_i_1_n_0;
  wire contexts_reg_0_7_278_278_i_1_n_0;
  wire contexts_reg_0_7_279_279_i_1_n_0;
  wire contexts_reg_0_7_280_280_i_1_n_0;
  wire contexts_reg_0_7_281_281_i_1_n_0;
  wire contexts_reg_0_7_282_282_i_1_n_0;
  wire contexts_reg_0_7_283_283_i_1_n_0;
  wire contexts_reg_0_7_284_284_i_1_n_0;
  wire contexts_reg_0_7_285_285_i_1_n_0;
  wire contexts_reg_0_7_286_286_i_1_n_0;
  wire contexts_reg_0_7_287_287_i_1_n_0;
  wire contexts_reg_0_7_288_288_i_1_n_0;
  wire contexts_reg_0_7_289_289_i_1_n_0;
  wire contexts_reg_0_7_290_290_i_1_n_0;
  wire contexts_reg_0_7_291_291_i_1_n_0;
  wire contexts_reg_0_7_292_292_i_1_n_0;
  wire contexts_reg_0_7_293_293_i_1_n_0;
  wire contexts_reg_0_7_294_294_i_1_n_0;
  wire contexts_reg_0_7_295_295_i_1_n_0;
  wire contexts_reg_0_7_296_296_i_1_n_0;
  wire contexts_reg_0_7_297_297_i_1_n_0;
  wire contexts_reg_0_7_298_298_i_1_n_0;
  wire contexts_reg_0_7_299_299_i_1_n_0;
  wire contexts_reg_0_7_2_2_i_1_n_0;
  wire contexts_reg_0_7_2_2_i_2_n_0;
  wire contexts_reg_0_7_2_2_i_3_n_0;
  wire contexts_reg_0_7_35_35_i_10_n_0;
  wire contexts_reg_0_7_35_35_i_11_n_0;
  wire contexts_reg_0_7_35_35_i_12_n_0;
  wire contexts_reg_0_7_35_35_i_13_n_0;
  wire contexts_reg_0_7_35_35_i_14_n_0;
  wire contexts_reg_0_7_35_35_i_15_n_0;
  wire contexts_reg_0_7_35_35_i_1_n_0;
  wire contexts_reg_0_7_35_35_i_2_n_0;
  wire contexts_reg_0_7_35_35_i_2_n_1;
  wire contexts_reg_0_7_35_35_i_2_n_2;
  wire contexts_reg_0_7_35_35_i_2_n_3;
  wire contexts_reg_0_7_35_35_i_3_n_0;
  wire contexts_reg_0_7_35_35_i_4_n_0;
  wire contexts_reg_0_7_35_35_i_5_n_0;
  wire contexts_reg_0_7_35_35_i_6_n_0;
  wire contexts_reg_0_7_35_35_i_7_n_0;
  wire contexts_reg_0_7_35_35_i_8_n_0;
  wire contexts_reg_0_7_35_35_i_9_n_0;
  wire contexts_reg_0_7_36_36_i_1_n_0;
  wire contexts_reg_0_7_37_37_i_1_n_0;
  wire contexts_reg_0_7_38_38_i_1_n_0;
  wire contexts_reg_0_7_39_39_i_10_n_0;
  wire contexts_reg_0_7_39_39_i_11_n_0;
  wire contexts_reg_0_7_39_39_i_12_n_0;
  wire contexts_reg_0_7_39_39_i_13_n_0;
  wire contexts_reg_0_7_39_39_i_14_n_0;
  wire contexts_reg_0_7_39_39_i_15_n_0;
  wire contexts_reg_0_7_39_39_i_16_n_0;
  wire contexts_reg_0_7_39_39_i_17_n_0;
  wire contexts_reg_0_7_39_39_i_18_n_0;
  wire contexts_reg_0_7_39_39_i_19_n_0;
  wire contexts_reg_0_7_39_39_i_1_n_0;
  wire contexts_reg_0_7_39_39_i_20_n_0;
  wire contexts_reg_0_7_39_39_i_21_n_0;
  wire contexts_reg_0_7_39_39_i_22_n_0;
  wire contexts_reg_0_7_39_39_i_2_n_0;
  wire contexts_reg_0_7_39_39_i_2_n_1;
  wire contexts_reg_0_7_39_39_i_2_n_2;
  wire contexts_reg_0_7_39_39_i_2_n_3;
  wire contexts_reg_0_7_39_39_i_3_n_0;
  wire contexts_reg_0_7_39_39_i_4_n_0;
  wire contexts_reg_0_7_39_39_i_5_n_0;
  wire contexts_reg_0_7_39_39_i_6_n_0;
  wire contexts_reg_0_7_39_39_i_7_n_0;
  wire contexts_reg_0_7_39_39_i_8_n_0;
  wire contexts_reg_0_7_39_39_i_9_n_0;
  wire contexts_reg_0_7_3_3_i_1_n_0;
  wire contexts_reg_0_7_3_3_i_2_n_0;
  wire contexts_reg_0_7_40_40_i_1_n_0;
  wire contexts_reg_0_7_41_41_i_1_n_0;
  wire contexts_reg_0_7_42_42_i_1_n_0;
  wire contexts_reg_0_7_43_43_i_10_n_0;
  wire contexts_reg_0_7_43_43_i_11_n_0;
  wire contexts_reg_0_7_43_43_i_12_n_0;
  wire contexts_reg_0_7_43_43_i_13_n_0;
  wire contexts_reg_0_7_43_43_i_14_n_0;
  wire contexts_reg_0_7_43_43_i_15_n_0;
  wire contexts_reg_0_7_43_43_i_16_n_0;
  wire contexts_reg_0_7_43_43_i_17_n_0;
  wire contexts_reg_0_7_43_43_i_18_n_0;
  wire contexts_reg_0_7_43_43_i_19_n_0;
  wire contexts_reg_0_7_43_43_i_1_n_0;
  wire contexts_reg_0_7_43_43_i_20_n_0;
  wire contexts_reg_0_7_43_43_i_21_n_0;
  wire contexts_reg_0_7_43_43_i_22_n_0;
  wire contexts_reg_0_7_43_43_i_2_n_0;
  wire contexts_reg_0_7_43_43_i_2_n_1;
  wire contexts_reg_0_7_43_43_i_2_n_2;
  wire contexts_reg_0_7_43_43_i_2_n_3;
  wire contexts_reg_0_7_43_43_i_3_n_0;
  wire contexts_reg_0_7_43_43_i_4_n_0;
  wire contexts_reg_0_7_43_43_i_5_n_0;
  wire contexts_reg_0_7_43_43_i_6_n_0;
  wire contexts_reg_0_7_43_43_i_7_n_0;
  wire contexts_reg_0_7_43_43_i_8_n_0;
  wire contexts_reg_0_7_43_43_i_9_n_0;
  wire contexts_reg_0_7_44_44_i_1_n_0;
  wire contexts_reg_0_7_45_45_i_1_n_0;
  wire contexts_reg_0_7_46_46_i_1_n_0;
  wire contexts_reg_0_7_47_47_i_10_n_0;
  wire contexts_reg_0_7_47_47_i_11_n_0;
  wire contexts_reg_0_7_47_47_i_12_n_0;
  wire contexts_reg_0_7_47_47_i_13_n_0;
  wire contexts_reg_0_7_47_47_i_14_n_0;
  wire contexts_reg_0_7_47_47_i_15_n_0;
  wire contexts_reg_0_7_47_47_i_16_n_0;
  wire contexts_reg_0_7_47_47_i_17_n_0;
  wire contexts_reg_0_7_47_47_i_18_n_0;
  wire contexts_reg_0_7_47_47_i_19_n_0;
  wire contexts_reg_0_7_47_47_i_1_n_0;
  wire contexts_reg_0_7_47_47_i_20_n_0;
  wire contexts_reg_0_7_47_47_i_21_n_0;
  wire contexts_reg_0_7_47_47_i_2_n_0;
  wire contexts_reg_0_7_47_47_i_2_n_1;
  wire contexts_reg_0_7_47_47_i_2_n_2;
  wire contexts_reg_0_7_47_47_i_2_n_3;
  wire contexts_reg_0_7_47_47_i_3_n_0;
  wire contexts_reg_0_7_47_47_i_4_n_0;
  wire contexts_reg_0_7_47_47_i_5_n_0;
  wire contexts_reg_0_7_47_47_i_6_n_0;
  wire contexts_reg_0_7_47_47_i_7_n_0;
  wire contexts_reg_0_7_47_47_i_8_n_0;
  wire contexts_reg_0_7_47_47_i_9_n_0;
  wire contexts_reg_0_7_48_48_i_1_n_0;
  wire contexts_reg_0_7_49_49_i_1_n_0;
  wire contexts_reg_0_7_4_4_i_1_n_0;
  wire contexts_reg_0_7_4_4_i_2_n_0;
  wire contexts_reg_0_7_50_50_i_1_n_0;
  wire contexts_reg_0_7_51_51_i_10_n_0;
  wire contexts_reg_0_7_51_51_i_11_n_0;
  wire contexts_reg_0_7_51_51_i_12_n_0;
  wire contexts_reg_0_7_51_51_i_13_n_0;
  wire contexts_reg_0_7_51_51_i_14_n_0;
  wire contexts_reg_0_7_51_51_i_15_n_0;
  wire contexts_reg_0_7_51_51_i_16_n_0;
  wire contexts_reg_0_7_51_51_i_17_n_0;
  wire contexts_reg_0_7_51_51_i_18_n_0;
  wire contexts_reg_0_7_51_51_i_19_n_0;
  wire contexts_reg_0_7_51_51_i_1_n_0;
  wire contexts_reg_0_7_51_51_i_20_n_0;
  wire contexts_reg_0_7_51_51_i_21_n_0;
  wire contexts_reg_0_7_51_51_i_2_n_0;
  wire contexts_reg_0_7_51_51_i_2_n_1;
  wire contexts_reg_0_7_51_51_i_2_n_2;
  wire contexts_reg_0_7_51_51_i_2_n_3;
  wire contexts_reg_0_7_51_51_i_3_n_0;
  wire contexts_reg_0_7_51_51_i_4_n_0;
  wire contexts_reg_0_7_51_51_i_5_n_0;
  wire contexts_reg_0_7_51_51_i_6_n_0;
  wire contexts_reg_0_7_51_51_i_7_n_0;
  wire contexts_reg_0_7_51_51_i_8_n_0;
  wire contexts_reg_0_7_51_51_i_9_n_0;
  wire contexts_reg_0_7_52_52_i_1_n_0;
  wire contexts_reg_0_7_53_53_i_1_n_0;
  wire contexts_reg_0_7_54_54_i_1_n_0;
  wire contexts_reg_0_7_55_55_i_10_n_0;
  wire contexts_reg_0_7_55_55_i_11_n_0;
  wire contexts_reg_0_7_55_55_i_12_n_0;
  wire contexts_reg_0_7_55_55_i_13_n_0;
  wire contexts_reg_0_7_55_55_i_14_n_0;
  wire contexts_reg_0_7_55_55_i_15_n_0;
  wire contexts_reg_0_7_55_55_i_16_n_0;
  wire contexts_reg_0_7_55_55_i_17_n_0;
  wire contexts_reg_0_7_55_55_i_18_n_0;
  wire contexts_reg_0_7_55_55_i_19_n_0;
  wire contexts_reg_0_7_55_55_i_1_n_0;
  wire contexts_reg_0_7_55_55_i_20_n_0;
  wire contexts_reg_0_7_55_55_i_21_n_0;
  wire contexts_reg_0_7_55_55_i_22_n_0;
  wire contexts_reg_0_7_55_55_i_2_n_0;
  wire contexts_reg_0_7_55_55_i_2_n_1;
  wire contexts_reg_0_7_55_55_i_2_n_2;
  wire contexts_reg_0_7_55_55_i_2_n_3;
  wire contexts_reg_0_7_55_55_i_3_n_0;
  wire contexts_reg_0_7_55_55_i_4_n_0;
  wire contexts_reg_0_7_55_55_i_5_n_0;
  wire contexts_reg_0_7_55_55_i_6_n_0;
  wire contexts_reg_0_7_55_55_i_7_n_0;
  wire contexts_reg_0_7_55_55_i_8_n_0;
  wire contexts_reg_0_7_55_55_i_9_n_0;
  wire contexts_reg_0_7_56_56_i_1_n_0;
  wire contexts_reg_0_7_57_57_i_1_n_0;
  wire contexts_reg_0_7_58_58_i_1_n_0;
  wire contexts_reg_0_7_59_59_i_10_n_0;
  wire contexts_reg_0_7_59_59_i_11_n_0;
  wire contexts_reg_0_7_59_59_i_12_n_0;
  wire contexts_reg_0_7_59_59_i_13_n_0;
  wire contexts_reg_0_7_59_59_i_14_n_0;
  wire contexts_reg_0_7_59_59_i_15_n_0;
  wire contexts_reg_0_7_59_59_i_16_n_0;
  wire contexts_reg_0_7_59_59_i_17_n_0;
  wire contexts_reg_0_7_59_59_i_18_n_0;
  wire contexts_reg_0_7_59_59_i_19_n_0;
  wire contexts_reg_0_7_59_59_i_1_n_0;
  wire contexts_reg_0_7_59_59_i_20_n_0;
  wire contexts_reg_0_7_59_59_i_21_n_0;
  wire contexts_reg_0_7_59_59_i_22_n_0;
  wire contexts_reg_0_7_59_59_i_2_n_0;
  wire contexts_reg_0_7_59_59_i_2_n_1;
  wire contexts_reg_0_7_59_59_i_2_n_2;
  wire contexts_reg_0_7_59_59_i_2_n_3;
  wire contexts_reg_0_7_59_59_i_3_n_0;
  wire contexts_reg_0_7_59_59_i_4_n_0;
  wire contexts_reg_0_7_59_59_i_5_n_0;
  wire contexts_reg_0_7_59_59_i_6_n_0;
  wire contexts_reg_0_7_59_59_i_7_n_0;
  wire contexts_reg_0_7_59_59_i_8_n_0;
  wire contexts_reg_0_7_59_59_i_9_n_0;
  wire contexts_reg_0_7_5_5_i_1_n_0;
  wire contexts_reg_0_7_60_60_i_1_n_0;
  wire contexts_reg_0_7_61_61_i_1_n_0;
  wire contexts_reg_0_7_62_62_i_1_n_0;
  wire contexts_reg_0_7_63_63_i_10_n_0;
  wire contexts_reg_0_7_63_63_i_11_n_0;
  wire contexts_reg_0_7_63_63_i_12_n_0;
  wire contexts_reg_0_7_63_63_i_13_n_0;
  wire contexts_reg_0_7_63_63_i_14_n_0;
  wire contexts_reg_0_7_63_63_i_15_n_0;
  wire contexts_reg_0_7_63_63_i_16_n_0;
  wire contexts_reg_0_7_63_63_i_17_n_0;
  wire contexts_reg_0_7_63_63_i_18_n_0;
  wire contexts_reg_0_7_63_63_i_19_n_0;
  wire contexts_reg_0_7_63_63_i_1_n_0;
  wire contexts_reg_0_7_63_63_i_20_n_0;
  wire contexts_reg_0_7_63_63_i_21_n_0;
  wire contexts_reg_0_7_63_63_i_2_n_0;
  wire contexts_reg_0_7_63_63_i_2_n_1;
  wire contexts_reg_0_7_63_63_i_2_n_2;
  wire contexts_reg_0_7_63_63_i_2_n_3;
  wire contexts_reg_0_7_63_63_i_3_n_0;
  wire contexts_reg_0_7_63_63_i_4_n_0;
  wire contexts_reg_0_7_63_63_i_5_n_0;
  wire contexts_reg_0_7_63_63_i_6_n_0;
  wire contexts_reg_0_7_63_63_i_7_n_0;
  wire contexts_reg_0_7_63_63_i_8_n_0;
  wire contexts_reg_0_7_63_63_i_9_n_0;
  wire contexts_reg_0_7_64_64_i_1_n_0;
  wire contexts_reg_0_7_65_65_i_1_n_0;
  wire contexts_reg_0_7_66_66_i_1_n_0;
  wire contexts_reg_0_7_67_67_i_10_n_0;
  wire contexts_reg_0_7_67_67_i_11_n_0;
  wire contexts_reg_0_7_67_67_i_12_n_0;
  wire contexts_reg_0_7_67_67_i_1_n_0;
  wire contexts_reg_0_7_67_67_i_2_n_0;
  wire contexts_reg_0_7_67_67_i_2_n_1;
  wire contexts_reg_0_7_67_67_i_2_n_2;
  wire contexts_reg_0_7_67_67_i_2_n_3;
  wire contexts_reg_0_7_67_67_i_3_n_0;
  wire contexts_reg_0_7_67_67_i_4_n_0;
  wire contexts_reg_0_7_67_67_i_5_n_0;
  wire contexts_reg_0_7_67_67_i_6_n_0;
  wire contexts_reg_0_7_67_67_i_7_n_0;
  wire contexts_reg_0_7_67_67_i_8_n_0;
  wire contexts_reg_0_7_67_67_i_9_n_0;
  wire contexts_reg_0_7_68_68_i_1_n_0;
  wire contexts_reg_0_7_69_69_i_1_n_0;
  wire contexts_reg_0_7_6_6_i_1_n_0;
  wire contexts_reg_0_7_6_6_i_2_n_0;
  wire contexts_reg_0_7_6_6_i_3_n_0;
  wire contexts_reg_0_7_6_6_i_4_n_0;
  wire contexts_reg_0_7_70_70_i_1_n_0;
  wire contexts_reg_0_7_71_71_i_1_n_0;
  wire contexts_reg_0_7_71_71_i_2_n_1;
  wire contexts_reg_0_7_71_71_i_2_n_2;
  wire contexts_reg_0_7_71_71_i_2_n_3;
  wire contexts_reg_0_7_71_71_i_3_n_0;
  wire contexts_reg_0_7_71_71_i_4_n_0;
  wire contexts_reg_0_7_71_71_i_5_n_0;
  wire contexts_reg_0_7_71_71_i_6_n_0;
  wire contexts_reg_0_7_71_71_i_7_n_0;
  wire contexts_reg_0_7_71_71_i_8_n_0;
  wire contexts_reg_0_7_71_71_i_9_n_0;
  wire contexts_reg_0_7_72_72_i_1_n_0;
  wire contexts_reg_0_7_73_73_i_1_n_0;
  wire contexts_reg_0_7_74_74_i_1_n_0;
  wire contexts_reg_0_7_75_75_i_10_n_0;
  wire contexts_reg_0_7_75_75_i_11_n_0;
  wire contexts_reg_0_7_75_75_i_12_n_0;
  wire contexts_reg_0_7_75_75_i_13_n_0;
  wire contexts_reg_0_7_75_75_i_14_n_0;
  wire contexts_reg_0_7_75_75_i_15_n_0;
  wire contexts_reg_0_7_75_75_i_16_n_0;
  wire contexts_reg_0_7_75_75_i_17_n_0;
  wire contexts_reg_0_7_75_75_i_18_n_0;
  wire contexts_reg_0_7_75_75_i_1_n_0;
  wire contexts_reg_0_7_75_75_i_2_n_0;
  wire contexts_reg_0_7_75_75_i_2_n_1;
  wire contexts_reg_0_7_75_75_i_2_n_2;
  wire contexts_reg_0_7_75_75_i_2_n_3;
  wire contexts_reg_0_7_75_75_i_3_n_0;
  wire contexts_reg_0_7_75_75_i_4_n_0;
  wire contexts_reg_0_7_75_75_i_5_n_0;
  wire contexts_reg_0_7_75_75_i_6_n_0;
  wire contexts_reg_0_7_75_75_i_7_n_0;
  wire contexts_reg_0_7_75_75_i_8_n_0;
  wire contexts_reg_0_7_75_75_i_9_n_0;
  wire contexts_reg_0_7_76_76_i_1_n_0;
  wire contexts_reg_0_7_77_77_i_1_n_0;
  wire contexts_reg_0_7_78_78_i_1_n_0;
  wire contexts_reg_0_7_79_79_i_10_n_0;
  wire contexts_reg_0_7_79_79_i_11_n_0;
  wire contexts_reg_0_7_79_79_i_12_n_0;
  wire contexts_reg_0_7_79_79_i_13_n_0;
  wire contexts_reg_0_7_79_79_i_14_n_0;
  wire contexts_reg_0_7_79_79_i_15_n_0;
  wire contexts_reg_0_7_79_79_i_16_n_0;
  wire contexts_reg_0_7_79_79_i_17_n_0;
  wire contexts_reg_0_7_79_79_i_18_n_0;
  wire contexts_reg_0_7_79_79_i_19_n_0;
  wire contexts_reg_0_7_79_79_i_1_n_0;
  wire contexts_reg_0_7_79_79_i_20_n_0;
  wire contexts_reg_0_7_79_79_i_21_n_0;
  wire contexts_reg_0_7_79_79_i_22_n_0;
  wire contexts_reg_0_7_79_79_i_2_n_0;
  wire contexts_reg_0_7_79_79_i_2_n_1;
  wire contexts_reg_0_7_79_79_i_2_n_2;
  wire contexts_reg_0_7_79_79_i_2_n_3;
  wire contexts_reg_0_7_79_79_i_3_n_0;
  wire contexts_reg_0_7_79_79_i_4_n_0;
  wire contexts_reg_0_7_79_79_i_5_n_0;
  wire contexts_reg_0_7_79_79_i_6_n_0;
  wire contexts_reg_0_7_79_79_i_7_n_0;
  wire contexts_reg_0_7_79_79_i_8_n_0;
  wire contexts_reg_0_7_79_79_i_9_n_0;
  wire contexts_reg_0_7_7_7_i_1_n_0;
  wire contexts_reg_0_7_7_7_i_2_n_0;
  wire contexts_reg_0_7_7_7_i_3_n_0;
  wire contexts_reg_0_7_7_7_i_4_n_0;
  wire contexts_reg_0_7_80_80_i_1_n_0;
  wire contexts_reg_0_7_81_81_i_1_n_0;
  wire contexts_reg_0_7_82_82_i_1_n_0;
  wire contexts_reg_0_7_83_83_i_10_n_0;
  wire contexts_reg_0_7_83_83_i_11_n_0;
  wire contexts_reg_0_7_83_83_i_12_n_0;
  wire contexts_reg_0_7_83_83_i_13_n_0;
  wire contexts_reg_0_7_83_83_i_14_n_0;
  wire contexts_reg_0_7_83_83_i_15_n_0;
  wire contexts_reg_0_7_83_83_i_16_n_0;
  wire contexts_reg_0_7_83_83_i_17_n_0;
  wire contexts_reg_0_7_83_83_i_18_n_0;
  wire contexts_reg_0_7_83_83_i_19_n_0;
  wire contexts_reg_0_7_83_83_i_1_n_0;
  wire contexts_reg_0_7_83_83_i_20_n_0;
  wire contexts_reg_0_7_83_83_i_21_n_0;
  wire contexts_reg_0_7_83_83_i_22_n_0;
  wire contexts_reg_0_7_83_83_i_2_n_0;
  wire contexts_reg_0_7_83_83_i_2_n_1;
  wire contexts_reg_0_7_83_83_i_2_n_2;
  wire contexts_reg_0_7_83_83_i_2_n_3;
  wire contexts_reg_0_7_83_83_i_3_n_0;
  wire contexts_reg_0_7_83_83_i_4_n_0;
  wire contexts_reg_0_7_83_83_i_5_n_0;
  wire contexts_reg_0_7_83_83_i_6_n_0;
  wire contexts_reg_0_7_83_83_i_7_n_0;
  wire contexts_reg_0_7_83_83_i_8_n_0;
  wire contexts_reg_0_7_83_83_i_9_n_0;
  wire contexts_reg_0_7_84_84_i_1_n_0;
  wire contexts_reg_0_7_85_85_i_1_n_0;
  wire contexts_reg_0_7_86_86_i_1_n_0;
  wire contexts_reg_0_7_87_87_i_10_n_0;
  wire contexts_reg_0_7_87_87_i_11_n_0;
  wire contexts_reg_0_7_87_87_i_12_n_0;
  wire contexts_reg_0_7_87_87_i_13_n_0;
  wire contexts_reg_0_7_87_87_i_14_n_0;
  wire contexts_reg_0_7_87_87_i_15_n_0;
  wire contexts_reg_0_7_87_87_i_16_n_0;
  wire contexts_reg_0_7_87_87_i_17_n_0;
  wire contexts_reg_0_7_87_87_i_18_n_0;
  wire contexts_reg_0_7_87_87_i_19_n_0;
  wire contexts_reg_0_7_87_87_i_1_n_0;
  wire contexts_reg_0_7_87_87_i_20_n_0;
  wire contexts_reg_0_7_87_87_i_21_n_0;
  wire contexts_reg_0_7_87_87_i_22_n_0;
  wire contexts_reg_0_7_87_87_i_2_n_0;
  wire contexts_reg_0_7_87_87_i_2_n_1;
  wire contexts_reg_0_7_87_87_i_2_n_2;
  wire contexts_reg_0_7_87_87_i_2_n_3;
  wire contexts_reg_0_7_87_87_i_3_n_0;
  wire contexts_reg_0_7_87_87_i_4_n_0;
  wire contexts_reg_0_7_87_87_i_5_n_0;
  wire contexts_reg_0_7_87_87_i_6_n_0;
  wire contexts_reg_0_7_87_87_i_7_n_0;
  wire contexts_reg_0_7_87_87_i_8_n_0;
  wire contexts_reg_0_7_87_87_i_9_n_0;
  wire contexts_reg_0_7_88_88_i_1_n_0;
  wire contexts_reg_0_7_89_89_i_1_n_0;
  wire contexts_reg_0_7_8_8_i_1_n_0;
  wire contexts_reg_0_7_90_90_i_1_n_0;
  wire contexts_reg_0_7_91_91_i_10_n_0;
  wire contexts_reg_0_7_91_91_i_11_n_0;
  wire contexts_reg_0_7_91_91_i_12_n_0;
  wire contexts_reg_0_7_91_91_i_13_n_0;
  wire contexts_reg_0_7_91_91_i_14_n_0;
  wire contexts_reg_0_7_91_91_i_15_n_0;
  wire contexts_reg_0_7_91_91_i_16_n_0;
  wire contexts_reg_0_7_91_91_i_17_n_0;
  wire contexts_reg_0_7_91_91_i_18_n_0;
  wire contexts_reg_0_7_91_91_i_19_n_0;
  wire contexts_reg_0_7_91_91_i_1_n_0;
  wire contexts_reg_0_7_91_91_i_20_n_0;
  wire contexts_reg_0_7_91_91_i_21_n_0;
  wire contexts_reg_0_7_91_91_i_22_n_0;
  wire contexts_reg_0_7_91_91_i_2_n_0;
  wire contexts_reg_0_7_91_91_i_2_n_1;
  wire contexts_reg_0_7_91_91_i_2_n_2;
  wire contexts_reg_0_7_91_91_i_2_n_3;
  wire contexts_reg_0_7_91_91_i_3_n_0;
  wire contexts_reg_0_7_91_91_i_4_n_0;
  wire contexts_reg_0_7_91_91_i_5_n_0;
  wire contexts_reg_0_7_91_91_i_6_n_0;
  wire contexts_reg_0_7_91_91_i_7_n_0;
  wire contexts_reg_0_7_91_91_i_8_n_0;
  wire contexts_reg_0_7_91_91_i_9_n_0;
  wire contexts_reg_0_7_92_92_i_1_n_0;
  wire contexts_reg_0_7_93_93_i_1_n_0;
  wire contexts_reg_0_7_94_94_i_1_n_0;
  wire contexts_reg_0_7_95_95_i_10_n_0;
  wire contexts_reg_0_7_95_95_i_11_n_0;
  wire contexts_reg_0_7_95_95_i_12_n_0;
  wire contexts_reg_0_7_95_95_i_13_n_0;
  wire contexts_reg_0_7_95_95_i_14_n_0;
  wire contexts_reg_0_7_95_95_i_15_n_0;
  wire contexts_reg_0_7_95_95_i_16_n_0;
  wire contexts_reg_0_7_95_95_i_17_n_0;
  wire contexts_reg_0_7_95_95_i_18_n_0;
  wire contexts_reg_0_7_95_95_i_19_n_0;
  wire contexts_reg_0_7_95_95_i_1_n_0;
  wire contexts_reg_0_7_95_95_i_20_n_0;
  wire contexts_reg_0_7_95_95_i_21_n_0;
  wire contexts_reg_0_7_95_95_i_22_n_0;
  wire contexts_reg_0_7_95_95_i_2_n_0;
  wire contexts_reg_0_7_95_95_i_2_n_1;
  wire contexts_reg_0_7_95_95_i_2_n_2;
  wire contexts_reg_0_7_95_95_i_2_n_3;
  wire contexts_reg_0_7_95_95_i_3_n_0;
  wire contexts_reg_0_7_95_95_i_4_n_0;
  wire contexts_reg_0_7_95_95_i_5_n_0;
  wire contexts_reg_0_7_95_95_i_6_n_0;
  wire contexts_reg_0_7_95_95_i_7_n_0;
  wire contexts_reg_0_7_95_95_i_8_n_0;
  wire contexts_reg_0_7_95_95_i_9_n_0;
  wire contexts_reg_0_7_96_96_i_1_n_0;
  wire contexts_reg_0_7_97_97_i_1_n_0;
  wire contexts_reg_0_7_98_98_i_1_n_0;
  wire contexts_reg_0_7_99_99_i_10_n_0;
  wire contexts_reg_0_7_99_99_i_11_n_0;
  wire contexts_reg_0_7_99_99_i_12_n_0;
  wire contexts_reg_0_7_99_99_i_13_n_0;
  wire contexts_reg_0_7_99_99_i_14_n_0;
  wire contexts_reg_0_7_99_99_i_15_n_0;
  wire contexts_reg_0_7_99_99_i_16_n_0;
  wire contexts_reg_0_7_99_99_i_17_n_0;
  wire contexts_reg_0_7_99_99_i_18_n_0;
  wire contexts_reg_0_7_99_99_i_1_n_0;
  wire contexts_reg_0_7_99_99_i_20_n_0;
  wire contexts_reg_0_7_99_99_i_21_n_0;
  wire contexts_reg_0_7_99_99_i_22_n_0;
  wire contexts_reg_0_7_99_99_i_2_n_0;
  wire contexts_reg_0_7_99_99_i_2_n_1;
  wire contexts_reg_0_7_99_99_i_2_n_2;
  wire contexts_reg_0_7_99_99_i_2_n_3;
  wire contexts_reg_0_7_99_99_i_3_n_0;
  wire contexts_reg_0_7_99_99_i_4_n_0;
  wire contexts_reg_0_7_99_99_i_5_n_0;
  wire contexts_reg_0_7_99_99_i_6_n_0;
  wire contexts_reg_0_7_99_99_i_7_n_0;
  wire contexts_reg_0_7_99_99_i_8_n_0;
  wire contexts_reg_0_7_99_99_i_9_n_0;
  wire contexts_reg_0_7_9_9_i_1_n_0;
  wire [1:0]energy_sum;
  wire \energy_sum[30]_i_10_n_0 ;
  wire \energy_sum[30]_i_11_n_0 ;
  wire \energy_sum[30]_i_12_n_0 ;
  wire \energy_sum[30]_i_13_n_0 ;
  wire \energy_sum[30]_i_14_n_0 ;
  wire \energy_sum[30]_i_15_n_0 ;
  wire \energy_sum[30]_i_16_n_0 ;
  wire \energy_sum[30]_i_17_n_0 ;
  wire \energy_sum[30]_i_18_n_0 ;
  wire \energy_sum[30]_i_19_n_0 ;
  wire \energy_sum[30]_i_20_n_0 ;
  wire \energy_sum[30]_i_21_n_0 ;
  wire \energy_sum[30]_i_22_n_0 ;
  wire \energy_sum[30]_i_23_n_0 ;
  wire \energy_sum[30]_i_24_n_0 ;
  wire \energy_sum[30]_i_25_n_0 ;
  wire \energy_sum[30]_i_5_n_0 ;
  wire \energy_sum[30]_i_6_n_0 ;
  wire \energy_sum[30]_i_8_n_0 ;
  wire \energy_sum[30]_i_9_n_0 ;
  wire \energy_sum[31]_i_1_n_0 ;
  wire \energy_sum[31]_i_2_n_0 ;
  wire \energy_sum_reg[30]_i_2_n_3 ;
  wire \energy_sum_reg[30]_i_3_n_3 ;
  wire \energy_sum_reg[30]_i_4_n_0 ;
  wire \energy_sum_reg[30]_i_4_n_1 ;
  wire \energy_sum_reg[30]_i_4_n_2 ;
  wire \energy_sum_reg[30]_i_4_n_3 ;
  wire \energy_sum_reg[30]_i_7_n_0 ;
  wire \energy_sum_reg[30]_i_7_n_1 ;
  wire \energy_sum_reg[30]_i_7_n_2 ;
  wire \energy_sum_reg[30]_i_7_n_3 ;
  wire feature_ready;
  wire history_reg_0_31_0_0_i_1_n_0;
  wire history_reg_0_31_0_0_i_2_n_0;
  wire history_reg_0_31_102_102_i_1_n_0;
  wire history_reg_0_31_102_102_i_1_n_1;
  wire history_reg_0_31_102_102_i_1_n_2;
  wire history_reg_0_31_102_102_i_1_n_3;
  wire history_reg_0_31_102_102_i_2_n_0;
  wire history_reg_0_31_102_102_i_3_n_0;
  wire history_reg_0_31_102_102_i_4_n_0;
  wire history_reg_0_31_102_102_i_5_n_0;
  wire history_reg_0_31_102_102_i_6_n_0;
  wire history_reg_0_31_106_106_i_1_n_1;
  wire history_reg_0_31_106_106_i_1_n_2;
  wire history_reg_0_31_106_106_i_1_n_3;
  wire history_reg_0_31_106_106_i_2_n_0;
  wire history_reg_0_31_106_106_i_3_n_0;
  wire history_reg_0_31_106_106_i_4_n_0;
  wire history_reg_0_31_106_106_i_5_n_0;
  wire history_reg_0_31_13_13_i_1_n_0;
  wire history_reg_0_31_14_14_i_1_n_0;
  wire history_reg_0_31_14_14_i_1_n_1;
  wire history_reg_0_31_14_14_i_1_n_2;
  wire history_reg_0_31_14_14_i_1_n_3;
  wire history_reg_0_31_14_14_i_2_n_0;
  wire history_reg_0_31_14_14_i_3_n_0;
  wire history_reg_0_31_14_14_i_4_n_0;
  wire history_reg_0_31_14_14_i_5_n_0;
  wire history_reg_0_31_14_14_i_6_n_0;
  wire history_reg_0_31_14_14_i_7_n_0;
  wire history_reg_0_31_14_14_i_8_n_0;
  wire history_reg_0_31_14_14_i_9_n_0;
  wire history_reg_0_31_18_18_i_1_n_0;
  wire history_reg_0_31_18_18_i_1_n_1;
  wire history_reg_0_31_18_18_i_1_n_2;
  wire history_reg_0_31_18_18_i_1_n_3;
  wire history_reg_0_31_18_18_i_2_n_0;
  wire history_reg_0_31_18_18_i_3_n_0;
  wire history_reg_0_31_18_18_i_4_n_0;
  wire history_reg_0_31_18_18_i_5_n_0;
  wire history_reg_0_31_18_18_i_6_n_0;
  wire history_reg_0_31_18_18_i_7_n_0;
  wire history_reg_0_31_18_18_i_8_n_0;
  wire history_reg_0_31_18_18_i_9_n_0;
  wire history_reg_0_31_22_22_i_1_n_0;
  wire history_reg_0_31_22_22_i_1_n_1;
  wire history_reg_0_31_22_22_i_1_n_2;
  wire history_reg_0_31_22_22_i_1_n_3;
  wire history_reg_0_31_22_22_i_2_n_0;
  wire history_reg_0_31_22_22_i_3_n_0;
  wire history_reg_0_31_22_22_i_4_n_0;
  wire history_reg_0_31_22_22_i_5_n_0;
  wire history_reg_0_31_22_22_i_6_n_0;
  wire history_reg_0_31_22_22_i_7_n_0;
  wire history_reg_0_31_22_22_i_8_n_0;
  wire history_reg_0_31_22_22_i_9_n_0;
  wire history_reg_0_31_26_26_i_1_n_0;
  wire history_reg_0_31_26_26_i_1_n_1;
  wire history_reg_0_31_26_26_i_1_n_2;
  wire history_reg_0_31_26_26_i_1_n_3;
  wire history_reg_0_31_26_26_i_2_n_0;
  wire history_reg_0_31_26_26_i_3_n_0;
  wire history_reg_0_31_26_26_i_4_n_0;
  wire history_reg_0_31_26_26_i_5_n_0;
  wire history_reg_0_31_26_26_i_6_n_0;
  wire history_reg_0_31_26_26_i_7_n_0;
  wire history_reg_0_31_26_26_i_8_n_0;
  wire history_reg_0_31_26_26_i_9_n_0;
  wire history_reg_0_31_30_30_i_1_n_0;
  wire history_reg_0_31_30_30_i_1_n_1;
  wire history_reg_0_31_30_30_i_1_n_2;
  wire history_reg_0_31_30_30_i_1_n_3;
  wire history_reg_0_31_30_30_i_2_n_0;
  wire history_reg_0_31_30_30_i_3_n_0;
  wire history_reg_0_31_30_30_i_4_n_0;
  wire history_reg_0_31_30_30_i_5_n_0;
  wire history_reg_0_31_30_30_i_6_n_0;
  wire history_reg_0_31_30_30_i_7_n_0;
  wire history_reg_0_31_30_30_i_8_n_0;
  wire history_reg_0_31_30_30_i_9_n_0;
  wire history_reg_0_31_34_34_i_1_n_0;
  wire history_reg_0_31_34_34_i_1_n_1;
  wire history_reg_0_31_34_34_i_1_n_2;
  wire history_reg_0_31_34_34_i_1_n_3;
  wire history_reg_0_31_34_34_i_2_n_0;
  wire history_reg_0_31_34_34_i_3_n_0;
  wire history_reg_0_31_34_34_i_4_n_0;
  wire history_reg_0_31_34_34_i_5_n_0;
  wire history_reg_0_31_34_34_i_6_n_0;
  wire history_reg_0_31_34_34_i_7_n_0;
  wire history_reg_0_31_34_34_i_8_n_0;
  wire history_reg_0_31_34_34_i_9_n_0;
  wire history_reg_0_31_38_38_i_1_n_0;
  wire history_reg_0_31_38_38_i_1_n_1;
  wire history_reg_0_31_38_38_i_1_n_2;
  wire history_reg_0_31_38_38_i_1_n_3;
  wire history_reg_0_31_38_38_i_2_n_0;
  wire history_reg_0_31_38_38_i_3_n_0;
  wire history_reg_0_31_38_38_i_4_n_0;
  wire history_reg_0_31_38_38_i_5_n_0;
  wire history_reg_0_31_38_38_i_6_n_0;
  wire history_reg_0_31_38_38_i_7_n_0;
  wire history_reg_0_31_38_38_i_8_n_0;
  wire history_reg_0_31_38_38_i_9_n_0;
  wire history_reg_0_31_42_42_i_1_n_1;
  wire history_reg_0_31_42_42_i_1_n_2;
  wire history_reg_0_31_42_42_i_1_n_3;
  wire history_reg_0_31_42_42_i_2_n_0;
  wire history_reg_0_31_42_42_i_3_n_0;
  wire history_reg_0_31_42_42_i_4_n_0;
  wire history_reg_0_31_42_42_i_5_n_0;
  wire history_reg_0_31_42_42_i_6_n_0;
  wire history_reg_0_31_42_42_i_7_n_0;
  wire history_reg_0_31_42_42_i_8_n_0;
  wire history_reg_0_31_46_46_i_10_n_0;
  wire history_reg_0_31_46_46_i_10_n_1;
  wire history_reg_0_31_46_46_i_10_n_2;
  wire history_reg_0_31_46_46_i_10_n_3;
  wire history_reg_0_31_46_46_i_11_n_0;
  wire history_reg_0_31_46_46_i_11_n_1;
  wire history_reg_0_31_46_46_i_11_n_2;
  wire history_reg_0_31_46_46_i_11_n_3;
  wire history_reg_0_31_46_46_i_12_n_0;
  wire history_reg_0_31_46_46_i_13_n_0;
  wire history_reg_0_31_46_46_i_14_n_0;
  wire history_reg_0_31_46_46_i_15_n_0;
  wire history_reg_0_31_46_46_i_16_n_0;
  wire history_reg_0_31_46_46_i_17_n_0;
  wire history_reg_0_31_46_46_i_18_n_0;
  wire history_reg_0_31_46_46_i_19_n_0;
  wire history_reg_0_31_46_46_i_1_n_0;
  wire history_reg_0_31_46_46_i_1_n_1;
  wire history_reg_0_31_46_46_i_1_n_2;
  wire history_reg_0_31_46_46_i_1_n_3;
  wire history_reg_0_31_46_46_i_20_n_0;
  wire history_reg_0_31_46_46_i_2_n_0;
  wire history_reg_0_31_46_46_i_3_n_0;
  wire history_reg_0_31_46_46_i_4_n_0;
  wire history_reg_0_31_46_46_i_5_n_0;
  wire history_reg_0_31_46_46_i_6_n_0;
  wire history_reg_0_31_46_46_i_7_n_0;
  wire history_reg_0_31_46_46_i_8_n_0;
  wire history_reg_0_31_46_46_i_9_n_0;
  wire history_reg_0_31_50_50_i_10_n_0;
  wire history_reg_0_31_50_50_i_10_n_1;
  wire history_reg_0_31_50_50_i_10_n_2;
  wire history_reg_0_31_50_50_i_10_n_3;
  wire history_reg_0_31_50_50_i_11_n_0;
  wire history_reg_0_31_50_50_i_11_n_1;
  wire history_reg_0_31_50_50_i_11_n_2;
  wire history_reg_0_31_50_50_i_11_n_3;
  wire history_reg_0_31_50_50_i_12_n_0;
  wire history_reg_0_31_50_50_i_13_n_0;
  wire history_reg_0_31_50_50_i_14_n_0;
  wire history_reg_0_31_50_50_i_15_n_0;
  wire history_reg_0_31_50_50_i_16_n_0;
  wire history_reg_0_31_50_50_i_17_n_0;
  wire history_reg_0_31_50_50_i_18_n_0;
  wire history_reg_0_31_50_50_i_19_n_0;
  wire history_reg_0_31_50_50_i_1_n_0;
  wire history_reg_0_31_50_50_i_1_n_1;
  wire history_reg_0_31_50_50_i_1_n_2;
  wire history_reg_0_31_50_50_i_1_n_3;
  wire history_reg_0_31_50_50_i_2_n_0;
  wire history_reg_0_31_50_50_i_3_n_0;
  wire history_reg_0_31_50_50_i_4_n_0;
  wire history_reg_0_31_50_50_i_5_n_0;
  wire history_reg_0_31_50_50_i_6_n_0;
  wire history_reg_0_31_50_50_i_7_n_0;
  wire history_reg_0_31_50_50_i_8_n_0;
  wire history_reg_0_31_50_50_i_9_n_0;
  wire history_reg_0_31_54_54_i_10_n_0;
  wire history_reg_0_31_54_54_i_10_n_1;
  wire history_reg_0_31_54_54_i_10_n_2;
  wire history_reg_0_31_54_54_i_10_n_3;
  wire history_reg_0_31_54_54_i_11_n_0;
  wire history_reg_0_31_54_54_i_11_n_1;
  wire history_reg_0_31_54_54_i_11_n_2;
  wire history_reg_0_31_54_54_i_11_n_3;
  wire history_reg_0_31_54_54_i_12_n_0;
  wire history_reg_0_31_54_54_i_13_n_0;
  wire history_reg_0_31_54_54_i_14_n_0;
  wire history_reg_0_31_54_54_i_15_n_0;
  wire history_reg_0_31_54_54_i_16_n_0;
  wire history_reg_0_31_54_54_i_17_n_0;
  wire history_reg_0_31_54_54_i_18_n_0;
  wire history_reg_0_31_54_54_i_19_n_0;
  wire history_reg_0_31_54_54_i_1_n_0;
  wire history_reg_0_31_54_54_i_1_n_1;
  wire history_reg_0_31_54_54_i_1_n_2;
  wire history_reg_0_31_54_54_i_1_n_3;
  wire history_reg_0_31_54_54_i_2_n_0;
  wire history_reg_0_31_54_54_i_3_n_0;
  wire history_reg_0_31_54_54_i_4_n_0;
  wire history_reg_0_31_54_54_i_5_n_0;
  wire history_reg_0_31_54_54_i_6_n_0;
  wire history_reg_0_31_54_54_i_7_n_0;
  wire history_reg_0_31_54_54_i_8_n_0;
  wire history_reg_0_31_54_54_i_9_n_0;
  wire history_reg_0_31_58_58_i_10_n_0;
  wire history_reg_0_31_58_58_i_10_n_1;
  wire history_reg_0_31_58_58_i_10_n_2;
  wire history_reg_0_31_58_58_i_10_n_3;
  wire history_reg_0_31_58_58_i_11_n_0;
  wire history_reg_0_31_58_58_i_11_n_1;
  wire history_reg_0_31_58_58_i_11_n_2;
  wire history_reg_0_31_58_58_i_11_n_3;
  wire history_reg_0_31_58_58_i_12_n_0;
  wire history_reg_0_31_58_58_i_13_n_0;
  wire history_reg_0_31_58_58_i_14_n_0;
  wire history_reg_0_31_58_58_i_15_n_0;
  wire history_reg_0_31_58_58_i_16_n_0;
  wire history_reg_0_31_58_58_i_17_n_0;
  wire history_reg_0_31_58_58_i_18_n_0;
  wire history_reg_0_31_58_58_i_19_n_0;
  wire history_reg_0_31_58_58_i_1_n_0;
  wire history_reg_0_31_58_58_i_1_n_1;
  wire history_reg_0_31_58_58_i_1_n_2;
  wire history_reg_0_31_58_58_i_1_n_3;
  wire history_reg_0_31_58_58_i_2_n_0;
  wire history_reg_0_31_58_58_i_3_n_0;
  wire history_reg_0_31_58_58_i_4_n_0;
  wire history_reg_0_31_58_58_i_5_n_0;
  wire history_reg_0_31_58_58_i_6_n_0;
  wire history_reg_0_31_58_58_i_7_n_0;
  wire history_reg_0_31_58_58_i_8_n_0;
  wire history_reg_0_31_58_58_i_9_n_0;
  wire history_reg_0_31_62_62_i_10_n_0;
  wire history_reg_0_31_62_62_i_10_n_1;
  wire history_reg_0_31_62_62_i_10_n_2;
  wire history_reg_0_31_62_62_i_10_n_3;
  wire history_reg_0_31_62_62_i_11_n_0;
  wire history_reg_0_31_62_62_i_11_n_1;
  wire history_reg_0_31_62_62_i_11_n_2;
  wire history_reg_0_31_62_62_i_11_n_3;
  wire history_reg_0_31_62_62_i_12_n_0;
  wire history_reg_0_31_62_62_i_13_n_0;
  wire history_reg_0_31_62_62_i_14_n_0;
  wire history_reg_0_31_62_62_i_15_n_0;
  wire history_reg_0_31_62_62_i_16_n_0;
  wire history_reg_0_31_62_62_i_17_n_0;
  wire history_reg_0_31_62_62_i_18_n_0;
  wire history_reg_0_31_62_62_i_19_n_0;
  wire history_reg_0_31_62_62_i_1_n_0;
  wire history_reg_0_31_62_62_i_1_n_1;
  wire history_reg_0_31_62_62_i_1_n_2;
  wire history_reg_0_31_62_62_i_1_n_3;
  wire history_reg_0_31_62_62_i_2_n_0;
  wire history_reg_0_31_62_62_i_3_n_0;
  wire history_reg_0_31_62_62_i_4_n_0;
  wire history_reg_0_31_62_62_i_5_n_0;
  wire history_reg_0_31_62_62_i_6_n_0;
  wire history_reg_0_31_62_62_i_7_n_0;
  wire history_reg_0_31_62_62_i_8_n_0;
  wire history_reg_0_31_62_62_i_9_n_0;
  wire history_reg_0_31_66_66_i_10_n_0;
  wire history_reg_0_31_66_66_i_10_n_1;
  wire history_reg_0_31_66_66_i_10_n_2;
  wire history_reg_0_31_66_66_i_10_n_3;
  wire history_reg_0_31_66_66_i_11_n_1;
  wire history_reg_0_31_66_66_i_11_n_2;
  wire history_reg_0_31_66_66_i_11_n_3;
  wire history_reg_0_31_66_66_i_12_n_0;
  wire history_reg_0_31_66_66_i_13_n_0;
  wire history_reg_0_31_66_66_i_14_n_0;
  wire history_reg_0_31_66_66_i_15_n_0;
  wire history_reg_0_31_66_66_i_16_n_0;
  wire history_reg_0_31_66_66_i_17_n_0;
  wire history_reg_0_31_66_66_i_18_n_0;
  wire history_reg_0_31_66_66_i_19_n_0;
  wire history_reg_0_31_66_66_i_1_n_0;
  wire history_reg_0_31_66_66_i_1_n_1;
  wire history_reg_0_31_66_66_i_1_n_2;
  wire history_reg_0_31_66_66_i_1_n_3;
  wire history_reg_0_31_66_66_i_2_n_0;
  wire history_reg_0_31_66_66_i_3_n_0;
  wire history_reg_0_31_66_66_i_4_n_0;
  wire history_reg_0_31_66_66_i_5_n_0;
  wire history_reg_0_31_66_66_i_6_n_0;
  wire history_reg_0_31_66_66_i_7_n_0;
  wire history_reg_0_31_66_66_i_8_n_0;
  wire history_reg_0_31_66_66_i_9_n_0;
  wire history_reg_0_31_6_6_i_1_n_0;
  wire history_reg_0_31_70_70_i_1_n_0;
  wire history_reg_0_31_70_70_i_1_n_1;
  wire history_reg_0_31_70_70_i_1_n_2;
  wire history_reg_0_31_70_70_i_1_n_3;
  wire history_reg_0_31_70_70_i_2_n_0;
  wire history_reg_0_31_70_70_i_3_n_0;
  wire history_reg_0_31_70_70_i_4_n_0;
  wire history_reg_0_31_70_70_i_5_n_0;
  wire history_reg_0_31_70_70_i_6_n_0;
  wire history_reg_0_31_74_74_i_1_n_1;
  wire history_reg_0_31_74_74_i_1_n_2;
  wire history_reg_0_31_74_74_i_1_n_3;
  wire history_reg_0_31_74_74_i_2_n_0;
  wire history_reg_0_31_74_74_i_3_n_0;
  wire history_reg_0_31_74_74_i_4_n_0;
  wire history_reg_0_31_74_74_i_5_n_0;
  wire history_reg_0_31_78_78_i_10_n_0;
  wire history_reg_0_31_78_78_i_10_n_1;
  wire history_reg_0_31_78_78_i_10_n_2;
  wire history_reg_0_31_78_78_i_10_n_3;
  wire history_reg_0_31_78_78_i_11_n_0;
  wire history_reg_0_31_78_78_i_12_n_0;
  wire history_reg_0_31_78_78_i_13_n_0;
  wire history_reg_0_31_78_78_i_14_n_0;
  wire history_reg_0_31_78_78_i_15_n_0;
  wire history_reg_0_31_78_78_i_1_n_0;
  wire history_reg_0_31_78_78_i_1_n_1;
  wire history_reg_0_31_78_78_i_1_n_2;
  wire history_reg_0_31_78_78_i_1_n_3;
  wire history_reg_0_31_78_78_i_2_n_0;
  wire history_reg_0_31_78_78_i_3_n_0;
  wire history_reg_0_31_78_78_i_4_n_0;
  wire history_reg_0_31_78_78_i_5_n_0;
  wire history_reg_0_31_78_78_i_6_n_0;
  wire history_reg_0_31_78_78_i_7_n_0;
  wire history_reg_0_31_78_78_i_8_n_0;
  wire history_reg_0_31_78_78_i_9_n_0;
  wire history_reg_0_31_7_7_i_1_n_0;
  wire history_reg_0_31_82_82_i_10_n_0;
  wire history_reg_0_31_82_82_i_10_n_1;
  wire history_reg_0_31_82_82_i_10_n_2;
  wire history_reg_0_31_82_82_i_10_n_3;
  wire history_reg_0_31_82_82_i_11_n_0;
  wire history_reg_0_31_82_82_i_12_n_0;
  wire history_reg_0_31_82_82_i_13_n_0;
  wire history_reg_0_31_82_82_i_14_n_0;
  wire history_reg_0_31_82_82_i_1_n_0;
  wire history_reg_0_31_82_82_i_1_n_1;
  wire history_reg_0_31_82_82_i_1_n_2;
  wire history_reg_0_31_82_82_i_1_n_3;
  wire history_reg_0_31_82_82_i_2_n_0;
  wire history_reg_0_31_82_82_i_3_n_0;
  wire history_reg_0_31_82_82_i_4_n_0;
  wire history_reg_0_31_82_82_i_5_n_0;
  wire history_reg_0_31_82_82_i_6_n_0;
  wire history_reg_0_31_82_82_i_7_n_0;
  wire history_reg_0_31_82_82_i_8_n_0;
  wire history_reg_0_31_82_82_i_9_n_0;
  wire history_reg_0_31_86_86_i_10_n_0;
  wire history_reg_0_31_86_86_i_10_n_1;
  wire history_reg_0_31_86_86_i_10_n_2;
  wire history_reg_0_31_86_86_i_10_n_3;
  wire history_reg_0_31_86_86_i_11_n_0;
  wire history_reg_0_31_86_86_i_12_n_0;
  wire history_reg_0_31_86_86_i_13_n_0;
  wire history_reg_0_31_86_86_i_14_n_0;
  wire history_reg_0_31_86_86_i_1_n_0;
  wire history_reg_0_31_86_86_i_1_n_1;
  wire history_reg_0_31_86_86_i_1_n_2;
  wire history_reg_0_31_86_86_i_1_n_3;
  wire history_reg_0_31_86_86_i_2_n_0;
  wire history_reg_0_31_86_86_i_3_n_0;
  wire history_reg_0_31_86_86_i_4_n_0;
  wire history_reg_0_31_86_86_i_5_n_0;
  wire history_reg_0_31_86_86_i_6_n_0;
  wire history_reg_0_31_86_86_i_7_n_0;
  wire history_reg_0_31_86_86_i_8_n_0;
  wire history_reg_0_31_86_86_i_9_n_0;
  wire history_reg_0_31_90_90_i_10_n_0;
  wire history_reg_0_31_90_90_i_10_n_1;
  wire history_reg_0_31_90_90_i_10_n_2;
  wire history_reg_0_31_90_90_i_10_n_3;
  wire history_reg_0_31_90_90_i_11_n_0;
  wire history_reg_0_31_90_90_i_12_n_0;
  wire history_reg_0_31_90_90_i_13_n_0;
  wire history_reg_0_31_90_90_i_14_n_0;
  wire history_reg_0_31_90_90_i_1_n_0;
  wire history_reg_0_31_90_90_i_1_n_1;
  wire history_reg_0_31_90_90_i_1_n_2;
  wire history_reg_0_31_90_90_i_1_n_3;
  wire history_reg_0_31_90_90_i_2_n_0;
  wire history_reg_0_31_90_90_i_3_n_0;
  wire history_reg_0_31_90_90_i_4_n_0;
  wire history_reg_0_31_90_90_i_5_n_0;
  wire history_reg_0_31_90_90_i_6_n_0;
  wire history_reg_0_31_90_90_i_7_n_0;
  wire history_reg_0_31_90_90_i_8_n_0;
  wire history_reg_0_31_90_90_i_9_n_0;
  wire history_reg_0_31_94_94_i_10_n_0;
  wire history_reg_0_31_94_94_i_10_n_1;
  wire history_reg_0_31_94_94_i_10_n_2;
  wire history_reg_0_31_94_94_i_10_n_3;
  wire history_reg_0_31_94_94_i_11_n_0;
  wire history_reg_0_31_94_94_i_12_n_0;
  wire history_reg_0_31_94_94_i_13_n_0;
  wire history_reg_0_31_94_94_i_14_n_0;
  wire history_reg_0_31_94_94_i_1_n_0;
  wire history_reg_0_31_94_94_i_1_n_1;
  wire history_reg_0_31_94_94_i_1_n_2;
  wire history_reg_0_31_94_94_i_1_n_3;
  wire history_reg_0_31_94_94_i_2_n_0;
  wire history_reg_0_31_94_94_i_3_n_0;
  wire history_reg_0_31_94_94_i_4_n_0;
  wire history_reg_0_31_94_94_i_5_n_0;
  wire history_reg_0_31_94_94_i_6_n_0;
  wire history_reg_0_31_94_94_i_7_n_0;
  wire history_reg_0_31_94_94_i_8_n_0;
  wire history_reg_0_31_94_94_i_9_n_0;
  wire history_reg_0_31_98_98_i_10_n_0;
  wire history_reg_0_31_98_98_i_10_n_2;
  wire history_reg_0_31_98_98_i_10_n_3;
  wire history_reg_0_31_98_98_i_11_n_0;
  wire history_reg_0_31_98_98_i_12_n_0;
  wire history_reg_0_31_98_98_i_13_n_0;
  wire history_reg_0_31_98_98_i_1_n_0;
  wire history_reg_0_31_98_98_i_1_n_1;
  wire history_reg_0_31_98_98_i_1_n_2;
  wire history_reg_0_31_98_98_i_1_n_3;
  wire history_reg_0_31_98_98_i_2_n_0;
  wire history_reg_0_31_98_98_i_3_n_0;
  wire history_reg_0_31_98_98_i_4_n_0;
  wire history_reg_0_31_98_98_i_5_n_0;
  wire history_reg_0_31_98_98_i_6_n_0;
  wire history_reg_0_31_98_98_i_7_n_0;
  wire history_reg_0_31_98_98_i_8_n_0;
  wire history_reg_0_31_98_98_i_9_n_0;
  wire [7:0]hold_seen;
  wire [1:0]mav_sum;
  wire \mav_sum[30]_i_10_n_0 ;
  wire \mav_sum[30]_i_11_n_0 ;
  wire \mav_sum[30]_i_12_n_0 ;
  wire \mav_sum[30]_i_13_n_0 ;
  wire \mav_sum[30]_i_14_n_0 ;
  wire \mav_sum[30]_i_15_n_0 ;
  wire \mav_sum[30]_i_16_n_0 ;
  wire \mav_sum[30]_i_17_n_0 ;
  wire \mav_sum[30]_i_18_n_0 ;
  wire \mav_sum[30]_i_19_n_0 ;
  wire \mav_sum[30]_i_20_n_0 ;
  wire \mav_sum[30]_i_21_n_0 ;
  wire \mav_sum[30]_i_22_n_0 ;
  wire \mav_sum[30]_i_23_n_0 ;
  wire \mav_sum[30]_i_24_n_0 ;
  wire \mav_sum[30]_i_25_n_0 ;
  wire \mav_sum[30]_i_26_n_0 ;
  wire \mav_sum[30]_i_3_n_0 ;
  wire \mav_sum[30]_i_6_n_0 ;
  wire \mav_sum[30]_i_7_n_0 ;
  wire \mav_sum[30]_i_9_n_0 ;
  wire \mav_sum[31]_i_1_n_0 ;
  wire \mav_sum[31]_i_2_n_0 ;
  wire \mav_sum_reg[30]_i_5_n_0 ;
  wire \mav_sum_reg[30]_i_5_n_1 ;
  wire \mav_sum_reg[30]_i_5_n_2 ;
  wire \mav_sum_reg[30]_i_5_n_3 ;
  wire \mav_sum_reg[30]_i_8_n_0 ;
  wire \mav_sum_reg[30]_i_8_n_1 ;
  wire \mav_sum_reg[30]_i_8_n_2 ;
  wire \mav_sum_reg[30]_i_8_n_3 ;
  wire [39:0]next_energy0;
  wire [31:0]next_energy1__1;
  wire next_energy1_n_106;
  wire next_energy1_n_107;
  wire next_energy1_n_108;
  wire next_energy1_n_109;
  wire next_energy1_n_110;
  wire next_energy1_n_111;
  wire next_energy1_n_112;
  wire next_energy1_n_113;
  wire next_energy1_n_114;
  wire next_energy1_n_115;
  wire next_energy1_n_116;
  wire next_energy1_n_117;
  wire next_energy1_n_118;
  wire next_energy1_n_119;
  wire next_energy1_n_120;
  wire next_energy1_n_121;
  wire next_energy1_n_122;
  wire next_energy1_n_123;
  wire next_energy1_n_124;
  wire next_energy1_n_125;
  wire next_energy1_n_126;
  wire next_energy1_n_127;
  wire next_energy1_n_128;
  wire next_energy1_n_129;
  wire next_energy1_n_130;
  wire next_energy1_n_131;
  wire next_energy1_n_132;
  wire next_energy1_n_133;
  wire next_energy1_n_134;
  wire next_energy1_n_135;
  wire next_energy1_n_136;
  wire next_energy1_n_137;
  wire next_energy1_n_138;
  wire next_energy1_n_139;
  wire next_energy1_n_140;
  wire next_energy1_n_141;
  wire next_energy1_n_142;
  wire next_energy1_n_143;
  wire next_energy1_n_144;
  wire next_energy1_n_145;
  wire next_energy1_n_146;
  wire next_energy1_n_147;
  wire next_energy1_n_148;
  wire next_energy1_n_149;
  wire next_energy1_n_150;
  wire next_energy1_n_151;
  wire next_energy1_n_152;
  wire next_energy1_n_153;
  wire next_energy1_n_58;
  wire next_energy1_n_59;
  wire next_energy1_n_60;
  wire next_energy1_n_61;
  wire next_energy1_n_62;
  wire next_energy1_n_63;
  wire next_energy1_n_64;
  wire next_energy1_n_65;
  wire next_energy1_n_66;
  wire next_energy1_n_67;
  wire next_energy1_n_68;
  wire next_energy1_n_69;
  wire next_energy1_n_70;
  wire next_energy1_n_71;
  wire next_energy1_n_72;
  wire next_energy1_n_73;
  wire next_energy1_n_74;
  wire next_energy1_n_75;
  wire next_energy1_n_76;
  wire next_energy1_n_77;
  wire next_energy1_n_78;
  wire next_energy1_n_79;
  wire next_energy1_n_80;
  wire next_energy1_n_81;
  wire next_energy1_n_82;
  wire next_energy1_n_83;
  wire next_energy1_n_84;
  wire next_energy1_n_85;
  wire next_energy1_n_86;
  wire next_energy1_n_87;
  wire next_energy1_n_88;
  wire [39:0]next_mav0;
  wire [24:1]next_mav1;
  wire [23:1]next_mav2;
  wire [109:0]next_mav4;
  wire [39:0]next_wl0;
  wire [1:0]p_0_in0_in;
  wire p_0_in5_out;
  wire p_3_out;
  wire \pending[0]_i_2_n_0 ;
  wire \pending[1]_i_2_n_0 ;
  wire \pending[2]_i_2_n_0 ;
  wire \pending[3]_i_2_n_0 ;
  wire \pending[4]_i_2_n_0 ;
  wire \pending[5]_i_2_n_0 ;
  wire \pending[6]_i_2_n_0 ;
  wire \pending[7]_i_2_n_0 ;
  wire \pending_reg[0] ;
  wire \pending_reg[1] ;
  wire \pending_reg[2] ;
  wire \pending_reg[3] ;
  wire \pending_reg[4] ;
  wire \pending_reg[5] ;
  wire \pending_reg[6] ;
  wire \pending_reg[7] ;
  wire \pending_reg[7]_0 ;
  wire \pending_reg[7]_1 ;
  wire \pending_reg[7]_2 ;
  wire \pending_reg[7]_3 ;
  wire \pending_reg[7]_4 ;
  wire \pending_reg[7]_5 ;
  wire \pending_reg[7]_6 ;
  wire [30:0]result_energy_sum;
  wire [30:0]result_mav_sum;
  wire [30:0]result_wl_sum;
  wire rst_n;
  wire rst_n_0;
  wire [2:0]sample_channel;
  wire [23:0]sample_data;
  wire sample_valid;
  wire [7:0]seen;
  wire \seen[0]_i_1_n_0 ;
  wire \seen[1]_i_1_n_0 ;
  wire \seen[2]_i_1_n_0 ;
  wire \seen[3]_i_1_n_0 ;
  wire \seen[4]_i_1_n_0 ;
  wire \seen[5]_i_1_n_0 ;
  wire \seen[6]_i_1_n_0 ;
  wire \seen[7]_i_1_n_0 ;
  wire [6:0]seg_count;
  wire [31:0]seg_energy;
  wire [31:0]seg_mav;
  wire [2:0]seg_ssc;
  wire [31:0]seg_wl;
  wire [2:0]seg_zc;
  wire shared_valid;
  wire \ssc_count[3]_i_10_n_0 ;
  wire \ssc_count[3]_i_11_n_0 ;
  wire \ssc_count[3]_i_12_n_0 ;
  wire \ssc_count[3]_i_2_n_0 ;
  wire \ssc_count[3]_i_3_n_0 ;
  wire \ssc_count[3]_i_4_n_0 ;
  wire \ssc_count[3]_i_5_n_0 ;
  wire \ssc_count[3]_i_6_n_0 ;
  wire \ssc_count[3]_i_7_n_0 ;
  wire \ssc_count[3]_i_8_n_0 ;
  wire \ssc_count[3]_i_9_n_0 ;
  wire \ssc_count[7]_i_10_n_0 ;
  wire \ssc_count[7]_i_11_n_0 ;
  wire \ssc_count[7]_i_12_n_0 ;
  wire \ssc_count[7]_i_13_n_0 ;
  wire \ssc_count[7]_i_14_n_0 ;
  wire \ssc_count[7]_i_15_n_0 ;
  wire \ssc_count[7]_i_16_n_0 ;
  wire \ssc_count[7]_i_17_n_0 ;
  wire \ssc_count[7]_i_2_n_0 ;
  wire \ssc_count[7]_i_3_n_0 ;
  wire \ssc_count[7]_i_4_n_0 ;
  wire \ssc_count[7]_i_5_n_0 ;
  wire \ssc_count[7]_i_6_n_0 ;
  wire \ssc_count[7]_i_7_n_0 ;
  wire \ssc_count[7]_i_8_n_0 ;
  wire \ssc_count[7]_i_9_n_0 ;
  wire \ssc_count[8]_i_2_n_0 ;
  wire \ssc_count[8]_i_3_n_0 ;
  wire \ssc_count_reg[3]_i_1_n_0 ;
  wire \ssc_count_reg[3]_i_1_n_1 ;
  wire \ssc_count_reg[3]_i_1_n_2 ;
  wire \ssc_count_reg[3]_i_1_n_3 ;
  wire \ssc_count_reg[3]_i_1_n_4 ;
  wire \ssc_count_reg[3]_i_1_n_5 ;
  wire \ssc_count_reg[3]_i_1_n_6 ;
  wire \ssc_count_reg[3]_i_1_n_7 ;
  wire \ssc_count_reg[7]_i_1_n_0 ;
  wire \ssc_count_reg[7]_i_1_n_1 ;
  wire \ssc_count_reg[7]_i_1_n_2 ;
  wire \ssc_count_reg[7]_i_1_n_3 ;
  wire \ssc_count_reg[7]_i_1_n_4 ;
  wire \ssc_count_reg[7]_i_1_n_5 ;
  wire \ssc_count_reg[7]_i_1_n_6 ;
  wire \ssc_count_reg[7]_i_1_n_7 ;
  wire \ssc_count_reg[8]_i_1_n_7 ;
  wire ssc_event2;
  wire [24:1]ssc_event4;
  wire [8:0]win_ssc;
  wire [8:0]win_zc;
  wire [2:0]window_channel;
  wire \window_channel[2]_i_1_n_0 ;
  wire \window_channel[2]_i_2_n_0 ;
  wire \window_channel_reg[1]_0 ;
  wire \window_channel_reg[1]_1 ;
  wire \window_channel_reg[1]_2 ;
  wire \window_channel_reg[1]_3 ;
  wire \window_channel_reg[2]_0 ;
  wire \window_channel_reg[2]_1 ;
  wire window_valid_i_1_n_0;
  wire window_valid_i_2_n_0;
  wire window_valid_i_3_n_0;
  wire window_valid_i_4_n_0;
  wire window_valid_i_5_n_0;
  wire window_valid_reg_0;
  wire window_valid_reg_1;
  wire \wl_sum[30]_i_10_n_0 ;
  wire \wl_sum[30]_i_11_n_0 ;
  wire \wl_sum[30]_i_12_n_0 ;
  wire \wl_sum[30]_i_13_n_0 ;
  wire \wl_sum[30]_i_14_n_0 ;
  wire \wl_sum[30]_i_15_n_0 ;
  wire \wl_sum[30]_i_16_n_0 ;
  wire \wl_sum[30]_i_17_n_0 ;
  wire \wl_sum[30]_i_18_n_0 ;
  wire \wl_sum[30]_i_19_n_0 ;
  wire \wl_sum[30]_i_20_n_0 ;
  wire \wl_sum[30]_i_21_n_0 ;
  wire \wl_sum[30]_i_22_n_0 ;
  wire \wl_sum[30]_i_23_n_0 ;
  wire \wl_sum[30]_i_24_n_0 ;
  wire \wl_sum[30]_i_25_n_0 ;
  wire \wl_sum[30]_i_5_n_0 ;
  wire \wl_sum[30]_i_6_n_0 ;
  wire \wl_sum[30]_i_8_n_0 ;
  wire \wl_sum[30]_i_9_n_0 ;
  wire \wl_sum[31]_i_1_n_0 ;
  wire \wl_sum[31]_i_2_n_0 ;
  wire \wl_sum_reg[30]_i_2_n_3 ;
  wire \wl_sum_reg[30]_i_3_n_3 ;
  wire \wl_sum_reg[30]_i_4_n_0 ;
  wire \wl_sum_reg[30]_i_4_n_1 ;
  wire \wl_sum_reg[30]_i_4_n_2 ;
  wire \wl_sum_reg[30]_i_4_n_3 ;
  wire \wl_sum_reg[30]_i_7_n_0 ;
  wire \wl_sum_reg[30]_i_7_n_1 ;
  wire \wl_sum_reg[30]_i_7_n_2 ;
  wire \wl_sum_reg[30]_i_7_n_3 ;
  wire [1:0]wr_ptr;
  wire [1:0]zc_count;
  wire \zc_count[3]_i_10_n_0 ;
  wire \zc_count[3]_i_11_n_0 ;
  wire \zc_count[3]_i_12_n_0 ;
  wire \zc_count[3]_i_2_n_0 ;
  wire \zc_count[3]_i_3_n_0 ;
  wire \zc_count[3]_i_4_n_0 ;
  wire \zc_count[3]_i_5_n_0 ;
  wire \zc_count[3]_i_6_n_0 ;
  wire \zc_count[3]_i_7_n_0 ;
  wire \zc_count[3]_i_8_n_0 ;
  wire \zc_count[3]_i_9_n_0 ;
  wire \zc_count[7]_i_10_n_0 ;
  wire \zc_count[7]_i_11_n_0 ;
  wire \zc_count[7]_i_12_n_0 ;
  wire \zc_count[7]_i_13_n_0 ;
  wire \zc_count[7]_i_14_n_0 ;
  wire \zc_count[7]_i_15_n_0 ;
  wire \zc_count[7]_i_16_n_0 ;
  wire \zc_count[7]_i_17_n_0 ;
  wire \zc_count[7]_i_2_n_0 ;
  wire \zc_count[7]_i_3_n_0 ;
  wire \zc_count[7]_i_4_n_0 ;
  wire \zc_count[7]_i_5_n_0 ;
  wire \zc_count[7]_i_6_n_0 ;
  wire \zc_count[7]_i_7_n_0 ;
  wire \zc_count[7]_i_8_n_0 ;
  wire \zc_count[7]_i_9_n_0 ;
  wire \zc_count[8]_i_2_n_0 ;
  wire \zc_count[8]_i_3_n_0 ;
  wire \zc_count_reg[3]_i_1_n_0 ;
  wire \zc_count_reg[3]_i_1_n_1 ;
  wire \zc_count_reg[3]_i_1_n_2 ;
  wire \zc_count_reg[3]_i_1_n_3 ;
  wire \zc_count_reg[3]_i_1_n_4 ;
  wire \zc_count_reg[3]_i_1_n_5 ;
  wire \zc_count_reg[3]_i_1_n_6 ;
  wire \zc_count_reg[3]_i_1_n_7 ;
  wire \zc_count_reg[7]_i_1_n_0 ;
  wire \zc_count_reg[7]_i_1_n_1 ;
  wire \zc_count_reg[7]_i_1_n_2 ;
  wire \zc_count_reg[7]_i_1_n_3 ;
  wire \zc_count_reg[7]_i_1_n_4 ;
  wire \zc_count_reg[7]_i_1_n_5 ;
  wire \zc_count_reg[7]_i_1_n_6 ;
  wire \zc_count_reg[7]_i_1_n_7 ;
  wire \zc_count_reg[8]_i_1_n_7 ;
  wire zc_event1;
  wire [3:3]NLW_contexts_reg_0_7_111_111_i_2_CO_UNCONNECTED;
  wire [3:3]NLW_contexts_reg_0_7_151_151_i_2_CO_UNCONNECTED;
  wire [3:0]NLW_contexts_reg_0_7_157_157_i_20_O_UNCONNECTED;
  wire [3:3]NLW_contexts_reg_0_7_157_157_i_29_CO_UNCONNECTED;
  wire [3:0]NLW_contexts_reg_0_7_157_157_i_39_O_UNCONNECTED;
  wire [3:1]NLW_contexts_reg_0_7_157_157_i_5_CO_UNCONNECTED;
  wire [3:0]NLW_contexts_reg_0_7_157_157_i_5_O_UNCONNECTED;
  wire [3:1]NLW_contexts_reg_0_7_157_157_i_6_CO_UNCONNECTED;
  wire [3:0]NLW_contexts_reg_0_7_157_157_i_6_O_UNCONNECTED;
  wire [3:1]NLW_contexts_reg_0_7_157_157_i_7_CO_UNCONNECTED;
  wire [3:0]NLW_contexts_reg_0_7_157_157_i_7_O_UNCONNECTED;
  wire [3:0]NLW_contexts_reg_0_7_157_157_i_9_O_UNCONNECTED;
  wire [3:0]NLW_contexts_reg_0_7_164_164_i_14_O_UNCONNECTED;
  wire [3:1]NLW_contexts_reg_0_7_164_164_i_2_CO_UNCONNECTED;
  wire [3:0]NLW_contexts_reg_0_7_164_164_i_2_O_UNCONNECTED;
  wire [3:0]NLW_contexts_reg_0_7_164_164_i_3_O_UNCONNECTED;
  wire [3:0]NLW_contexts_reg_0_7_164_164_i_5_O_UNCONNECTED;
  wire [3:3]NLW_contexts_reg_0_7_71_71_i_2_CO_UNCONNECTED;
  wire [3:1]\NLW_energy_sum_reg[30]_i_2_CO_UNCONNECTED ;
  wire [3:0]\NLW_energy_sum_reg[30]_i_2_O_UNCONNECTED ;
  wire [3:1]\NLW_energy_sum_reg[30]_i_3_CO_UNCONNECTED ;
  wire [3:0]\NLW_energy_sum_reg[30]_i_3_O_UNCONNECTED ;
  wire [3:0]\NLW_energy_sum_reg[30]_i_4_O_UNCONNECTED ;
  wire [3:0]\NLW_energy_sum_reg[30]_i_7_O_UNCONNECTED ;
  wire [3:3]NLW_history_reg_0_31_106_106_i_1_CO_UNCONNECTED;
  wire [3:3]NLW_history_reg_0_31_42_42_i_1_CO_UNCONNECTED;
  wire [3:3]NLW_history_reg_0_31_66_66_i_11_CO_UNCONNECTED;
  wire [3:3]NLW_history_reg_0_31_74_74_i_1_CO_UNCONNECTED;
  wire [2:2]NLW_history_reg_0_31_98_98_i_10_CO_UNCONNECTED;
  wire [3:3]NLW_history_reg_0_31_98_98_i_10_O_UNCONNECTED;
  wire [3:1]\NLW_mav_sum_reg[30]_i_2_CO_UNCONNECTED ;
  wire [3:0]\NLW_mav_sum_reg[30]_i_2_O_UNCONNECTED ;
  wire [3:1]\NLW_mav_sum_reg[30]_i_4_CO_UNCONNECTED ;
  wire [3:0]\NLW_mav_sum_reg[30]_i_4_O_UNCONNECTED ;
  wire [3:0]\NLW_mav_sum_reg[30]_i_5_O_UNCONNECTED ;
  wire [3:0]\NLW_mav_sum_reg[30]_i_8_O_UNCONNECTED ;
  wire NLW_next_energy1_CARRYCASCOUT_UNCONNECTED;
  wire NLW_next_energy1_MULTSIGNOUT_UNCONNECTED;
  wire NLW_next_energy1_OVERFLOW_UNCONNECTED;
  wire NLW_next_energy1_PATTERNBDETECT_UNCONNECTED;
  wire NLW_next_energy1_PATTERNDETECT_UNCONNECTED;
  wire NLW_next_energy1_UNDERFLOW_UNCONNECTED;
  wire [29:0]NLW_next_energy1_ACOUT_UNCONNECTED;
  wire [17:0]NLW_next_energy1_BCOUT_UNCONNECTED;
  wire [3:0]NLW_next_energy1_CARRYOUT_UNCONNECTED;
  wire NLW_next_energy1__0_CARRYCASCOUT_UNCONNECTED;
  wire NLW_next_energy1__0_MULTSIGNOUT_UNCONNECTED;
  wire NLW_next_energy1__0_OVERFLOW_UNCONNECTED;
  wire NLW_next_energy1__0_PATTERNBDETECT_UNCONNECTED;
  wire NLW_next_energy1__0_PATTERNDETECT_UNCONNECTED;
  wire NLW_next_energy1__0_UNDERFLOW_UNCONNECTED;
  wire [29:0]NLW_next_energy1__0_ACOUT_UNCONNECTED;
  wire [17:0]NLW_next_energy1__0_BCOUT_UNCONNECTED;
  wire [3:0]NLW_next_energy1__0_CARRYOUT_UNCONNECTED;
  wire [47:15]NLW_next_energy1__0_P_UNCONNECTED;
  wire [47:0]NLW_next_energy1__0_PCOUT_UNCONNECTED;
  wire [3:0]\NLW_ssc_count_reg[8]_i_1_CO_UNCONNECTED ;
  wire [3:1]\NLW_ssc_count_reg[8]_i_1_O_UNCONNECTED ;
  wire [3:1]\NLW_wl_sum_reg[30]_i_2_CO_UNCONNECTED ;
  wire [3:0]\NLW_wl_sum_reg[30]_i_2_O_UNCONNECTED ;
  wire [3:1]\NLW_wl_sum_reg[30]_i_3_CO_UNCONNECTED ;
  wire [3:0]\NLW_wl_sum_reg[30]_i_3_O_UNCONNECTED ;
  wire [3:0]\NLW_wl_sum_reg[30]_i_4_O_UNCONNECTED ;
  wire [3:0]\NLW_wl_sum_reg[30]_i_7_O_UNCONNECTED ;
  wire [3:0]\NLW_zc_count_reg[8]_i_1_CO_UNCONNECTED ;
  wire [3:1]\NLW_zc_count_reg[8]_i_1_O_UNCONNECTED ;

  LUT1 #(
    .INIT(2'h1)) 
    \active_ch[2]_i_1 
       (.I0(rst_n),
        .O(rst_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "0" *) 
  (* ram_slice_end = "0" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_0_0
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_0_0_i_1_n_0),
        .O(context_word0[0]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_0_0_i_2_n_0));
  LUT3 #(
    .INIT(8'h04)) 
    contexts_reg_0_7_0_0_i_1
       (.I0(context_word0[0]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_0_0_i_1_n_0));
  LUT6 #(
    .INIT(64'h00AA02AAAAAAAAAA)) 
    contexts_reg_0_7_0_0_i_2
       (.I0(p_3_out),
        .I1(contexts_reg_0_7_0_0_i_3_n_0),
        .I2(contexts_reg_0_7_0_0_i_4_n_0),
        .I3(context_word1),
        .I4(context_word0[12]),
        .I5(context_word0[16]),
        .O(contexts_reg_0_7_0_0_i_2_n_0));
  (* SOFT_HLUTNM = "soft_lutpair95" *) 
  LUT5 #(
    .INIT(32'hFFFFF7FF)) 
    contexts_reg_0_7_0_0_i_3
       (.I0(context_word0[10]),
        .I1(context_word0[9]),
        .I2(context_word0[13]),
        .I3(context_word1),
        .I4(context_word0[11]),
        .O(contexts_reg_0_7_0_0_i_3_n_0));
  LUT5 #(
    .INIT(32'h7FFFFFFF)) 
    contexts_reg_0_7_0_0_i_4
       (.I0(context_word0[8]),
        .I1(context_word0[7]),
        .I2(context_word0[14]),
        .I3(context_word0[15]),
        .I4(context_word1),
        .O(contexts_reg_0_7_0_0_i_4_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "100" *) 
  (* ram_slice_end = "100" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_100_100
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_100_100_i_1_n_0),
        .O(context_word0[100]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_100_100_i_1
       (.I0(next_wl0[25]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_100_100_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "101" *) 
  (* ram_slice_end = "101" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_101_101
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_101_101_i_1_n_0),
        .O(context_word0[101]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_101_101_i_1
       (.I0(next_wl0[26]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_101_101_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "102" *) 
  (* ram_slice_end = "102" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_102_102
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_102_102_i_1_n_0),
        .O(context_word0[102]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_102_102_i_1
       (.I0(next_wl0[27]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_102_102_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "103" *) 
  (* ram_slice_end = "103" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_103_103
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_103_103_i_1_n_0),
        .O(context_word0[103]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_103_103_i_1
       (.I0(next_wl0[28]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_103_103_i_1_n_0));
  (* HLUTNM = "lutpair1" *) 
  LUT3 #(
    .INIT(8'h96)) 
    contexts_reg_0_7_103_103_i_10
       (.I0(contexts_reg_0_7_103_103_i_15_n_0),
        .I1(contexts_reg_0_7_103_103_i_16_n_0),
        .I2(contexts_reg_0_7_103_103_i_6_n_0),
        .O(contexts_reg_0_7_103_103_i_10_n_0));
  LUT6 #(
    .INIT(64'h02FDFD02FF00FF00)) 
    contexts_reg_0_7_103_103_i_11
       (.I0(next_mav4[75]),
        .I1(context_word0[16]),
        .I2(context_word0[232]),
        .I3(contexts_reg_0_7_103_103_i_19_n_0),
        .I4(context_word0[105]),
        .I5(context_word1),
        .O(contexts_reg_0_7_103_103_i_11_n_0));
  LUT6 #(
    .INIT(64'h8F8F8F8F8F0D8F8F)) 
    contexts_reg_0_7_103_103_i_12
       (.I0(context_word1),
        .I1(context_word0[104]),
        .I2(contexts_reg_0_7_103_103_i_20_n_0),
        .I3(context_word0[16]),
        .I4(next_mav4[74]),
        .I5(context_word0[231]),
        .O(contexts_reg_0_7_103_103_i_12_n_0));
  LUT6 #(
    .INIT(64'h04FBFB04FF00FF00)) 
    contexts_reg_0_7_103_103_i_13
       (.I0(context_word0[231]),
        .I1(next_mav4[74]),
        .I2(context_word0[16]),
        .I3(contexts_reg_0_7_103_103_i_20_n_0),
        .I4(context_word0[104]),
        .I5(context_word1),
        .O(contexts_reg_0_7_103_103_i_13_n_0));
  LUT6 #(
    .INIT(64'h8F8F8F8F8F0D8F8F)) 
    contexts_reg_0_7_103_103_i_14
       (.I0(context_word1),
        .I1(context_word0[103]),
        .I2(contexts_reg_0_7_103_103_i_21_n_0),
        .I3(context_word0[16]),
        .I4(next_mav4[73]),
        .I5(context_word0[230]),
        .O(contexts_reg_0_7_103_103_i_14_n_0));
  LUT6 #(
    .INIT(64'h04FBFB04FF00FF00)) 
    contexts_reg_0_7_103_103_i_15
       (.I0(context_word0[230]),
        .I1(next_mav4[73]),
        .I2(context_word0[16]),
        .I3(contexts_reg_0_7_103_103_i_21_n_0),
        .I4(context_word0[103]),
        .I5(context_word1),
        .O(contexts_reg_0_7_103_103_i_15_n_0));
  LUT6 #(
    .INIT(64'h8F8F8F8F8F0D8F8F)) 
    contexts_reg_0_7_103_103_i_16
       (.I0(context_word1),
        .I1(context_word0[102]),
        .I2(contexts_reg_0_7_99_99_i_22_n_0),
        .I3(context_word0[16]),
        .I4(next_mav4[72]),
        .I5(context_word0[229]),
        .O(contexts_reg_0_7_103_103_i_16_n_0));
  LUT6 #(
    .INIT(64'h707070F270707070)) 
    contexts_reg_0_7_103_103_i_17
       (.I0(context_word1),
        .I1(context_word0[105]),
        .I2(contexts_reg_0_7_103_103_i_19_n_0),
        .I3(context_word0[232]),
        .I4(context_word0[16]),
        .I5(next_mav4[75]),
        .O(contexts_reg_0_7_103_103_i_17_n_0));
  LUT6 #(
    .INIT(64'hFB0404FB00FF00FF)) 
    contexts_reg_0_7_103_103_i_18
       (.I0(context_word0[16]),
        .I1(next_mav4[76]),
        .I2(context_word0[233]),
        .I3(contexts_reg_0_7_103_103_i_22_n_0),
        .I4(context_word0[106]),
        .I5(context_word1),
        .O(contexts_reg_0_7_103_103_i_18_n_0));
  (* SOFT_HLUTNM = "soft_lutpair101" *) 
  LUT4 #(
    .INIT(16'h59FF)) 
    contexts_reg_0_7_103_103_i_19
       (.I0(context_word0[233]),
        .I1(next_mav4[76]),
        .I2(context_word0[16]),
        .I3(context_word1),
        .O(contexts_reg_0_7_103_103_i_19_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 contexts_reg_0_7_103_103_i_2
       (.CI(contexts_reg_0_7_99_99_i_2_n_0),
        .CO({contexts_reg_0_7_103_103_i_2_n_0,contexts_reg_0_7_103_103_i_2_n_1,contexts_reg_0_7_103_103_i_2_n_2,contexts_reg_0_7_103_103_i_2_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_103_103_i_3_n_0,contexts_reg_0_7_103_103_i_4_n_0,contexts_reg_0_7_103_103_i_5_n_0,contexts_reg_0_7_103_103_i_6_n_0}),
        .O(next_wl0[31:28]),
        .S({contexts_reg_0_7_103_103_i_7_n_0,contexts_reg_0_7_103_103_i_8_n_0,contexts_reg_0_7_103_103_i_9_n_0,contexts_reg_0_7_103_103_i_10_n_0}));
  (* SOFT_HLUTNM = "soft_lutpair109" *) 
  LUT4 #(
    .INIT(16'h6F5F)) 
    contexts_reg_0_7_103_103_i_20
       (.I0(context_word0[232]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[75]),
        .O(contexts_reg_0_7_103_103_i_20_n_0));
  (* SOFT_HLUTNM = "soft_lutpair110" *) 
  LUT4 #(
    .INIT(16'h6F5F)) 
    contexts_reg_0_7_103_103_i_21
       (.I0(context_word0[231]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[74]),
        .O(contexts_reg_0_7_103_103_i_21_n_0));
  (* SOFT_HLUTNM = "soft_lutpair99" *) 
  LUT4 #(
    .INIT(16'h59FF)) 
    contexts_reg_0_7_103_103_i_22
       (.I0(context_word0[234]),
        .I1(next_mav4[77]),
        .I2(context_word0[16]),
        .I3(context_word1),
        .O(contexts_reg_0_7_103_103_i_22_n_0));
  (* HLUTNM = "lutpair3" *) 
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_103_103_i_3
       (.I0(contexts_reg_0_7_103_103_i_11_n_0),
        .I1(contexts_reg_0_7_103_103_i_12_n_0),
        .O(contexts_reg_0_7_103_103_i_3_n_0));
  (* HLUTNM = "lutpair2" *) 
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_103_103_i_4
       (.I0(contexts_reg_0_7_103_103_i_13_n_0),
        .I1(contexts_reg_0_7_103_103_i_14_n_0),
        .O(contexts_reg_0_7_103_103_i_4_n_0));
  (* HLUTNM = "lutpair1" *) 
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_103_103_i_5
       (.I0(contexts_reg_0_7_103_103_i_15_n_0),
        .I1(contexts_reg_0_7_103_103_i_16_n_0),
        .O(contexts_reg_0_7_103_103_i_5_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_103_103_i_6
       (.I0(contexts_reg_0_7_99_99_i_16_n_0),
        .I1(contexts_reg_0_7_99_99_i_17_n_0),
        .O(contexts_reg_0_7_103_103_i_6_n_0));
  LUT3 #(
    .INIT(8'h96)) 
    contexts_reg_0_7_103_103_i_7
       (.I0(contexts_reg_0_7_103_103_i_3_n_0),
        .I1(contexts_reg_0_7_103_103_i_17_n_0),
        .I2(contexts_reg_0_7_103_103_i_18_n_0),
        .O(contexts_reg_0_7_103_103_i_7_n_0));
  (* HLUTNM = "lutpair3" *) 
  LUT3 #(
    .INIT(8'h96)) 
    contexts_reg_0_7_103_103_i_8
       (.I0(contexts_reg_0_7_103_103_i_11_n_0),
        .I1(contexts_reg_0_7_103_103_i_12_n_0),
        .I2(contexts_reg_0_7_103_103_i_4_n_0),
        .O(contexts_reg_0_7_103_103_i_8_n_0));
  (* HLUTNM = "lutpair2" *) 
  LUT3 #(
    .INIT(8'h96)) 
    contexts_reg_0_7_103_103_i_9
       (.I0(contexts_reg_0_7_103_103_i_13_n_0),
        .I1(contexts_reg_0_7_103_103_i_14_n_0),
        .I2(contexts_reg_0_7_103_103_i_5_n_0),
        .O(contexts_reg_0_7_103_103_i_9_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "104" *) 
  (* ram_slice_end = "104" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_104_104
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_104_104_i_1_n_0),
        .O(context_word0[104]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_104_104_i_1
       (.I0(next_wl0[29]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_104_104_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "105" *) 
  (* ram_slice_end = "105" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_105_105
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_105_105_i_1_n_0),
        .O(context_word0[105]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_105_105_i_1
       (.I0(next_wl0[30]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_105_105_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "106" *) 
  (* ram_slice_end = "106" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_106_106
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_106_106_i_1_n_0),
        .O(context_word0[106]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_106_106_i_1
       (.I0(next_wl0[31]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_106_106_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "107" *) 
  (* ram_slice_end = "107" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_107_107
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_107_107_i_1_n_0),
        .O(context_word0[107]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_107_107_i_1
       (.I0(next_wl0[32]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_107_107_i_1_n_0));
  LUT6 #(
    .INIT(64'h1EE1E11EE11EE11E)) 
    contexts_reg_0_7_107_107_i_10
       (.I0(contexts_reg_0_7_103_103_i_18_n_0),
        .I1(contexts_reg_0_7_103_103_i_17_n_0),
        .I2(contexts_reg_0_7_107_107_i_11_n_0),
        .I3(contexts_reg_0_7_107_107_i_12_n_0),
        .I4(context_word0[107]),
        .I5(context_word1),
        .O(contexts_reg_0_7_107_107_i_10_n_0));
  LUT6 #(
    .INIT(64'h8F8F8F8F8F0D8F8F)) 
    contexts_reg_0_7_107_107_i_11
       (.I0(context_word1),
        .I1(context_word0[106]),
        .I2(contexts_reg_0_7_103_103_i_22_n_0),
        .I3(context_word0[233]),
        .I4(next_mav4[76]),
        .I5(context_word0[16]),
        .O(contexts_reg_0_7_107_107_i_11_n_0));
  (* SOFT_HLUTNM = "soft_lutpair99" *) 
  LUT4 #(
    .INIT(16'h0400)) 
    contexts_reg_0_7_107_107_i_12
       (.I0(context_word0[234]),
        .I1(next_mav4[77]),
        .I2(context_word0[16]),
        .I3(context_word1),
        .O(contexts_reg_0_7_107_107_i_12_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 contexts_reg_0_7_107_107_i_2
       (.CI(contexts_reg_0_7_103_103_i_2_n_0),
        .CO({contexts_reg_0_7_107_107_i_2_n_0,contexts_reg_0_7_107_107_i_2_n_1,contexts_reg_0_7_107_107_i_2_n_2,contexts_reg_0_7_107_107_i_2_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_107_107_i_3_n_0,contexts_reg_0_7_107_107_i_4_n_0,contexts_reg_0_7_107_107_i_5_n_0,contexts_reg_0_7_107_107_i_6_n_0}),
        .O(next_wl0[35:32]),
        .S({contexts_reg_0_7_107_107_i_7_n_0,contexts_reg_0_7_107_107_i_8_n_0,contexts_reg_0_7_107_107_i_9_n_0,contexts_reg_0_7_107_107_i_10_n_0}));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_107_107_i_3
       (.I0(context_word0[109]),
        .I1(context_word1),
        .O(contexts_reg_0_7_107_107_i_3_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_107_107_i_4
       (.I0(context_word0[108]),
        .I1(context_word1),
        .O(contexts_reg_0_7_107_107_i_4_n_0));
  LUT6 #(
    .INIT(64'hFFEFAAAAAA8AAAAA)) 
    contexts_reg_0_7_107_107_i_5
       (.I0(contexts_reg_0_7_107_107_i_11_n_0),
        .I1(context_word0[16]),
        .I2(next_mav4[77]),
        .I3(context_word0[234]),
        .I4(context_word1),
        .I5(context_word0[107]),
        .O(contexts_reg_0_7_107_107_i_5_n_0));
  LUT2 #(
    .INIT(4'h1)) 
    contexts_reg_0_7_107_107_i_6
       (.I0(contexts_reg_0_7_103_103_i_18_n_0),
        .I1(contexts_reg_0_7_103_103_i_17_n_0),
        .O(contexts_reg_0_7_107_107_i_6_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_107_107_i_7
       (.I0(context_word0[109]),
        .I1(context_word1),
        .I2(context_word0[110]),
        .O(contexts_reg_0_7_107_107_i_7_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_107_107_i_8
       (.I0(context_word0[108]),
        .I1(context_word1),
        .I2(context_word0[109]),
        .O(contexts_reg_0_7_107_107_i_8_n_0));
  LUT3 #(
    .INIT(8'h95)) 
    contexts_reg_0_7_107_107_i_9
       (.I0(contexts_reg_0_7_107_107_i_5_n_0),
        .I1(context_word1),
        .I2(context_word0[108]),
        .O(contexts_reg_0_7_107_107_i_9_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "108" *) 
  (* ram_slice_end = "108" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_108_108
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_108_108_i_1_n_0),
        .O(context_word0[108]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_108_108_i_1
       (.I0(next_wl0[33]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_108_108_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "109" *) 
  (* ram_slice_end = "109" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_109_109
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_109_109_i_1_n_0),
        .O(context_word0[109]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_109_109_i_1
       (.I0(next_wl0[34]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_109_109_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "10" *) 
  (* ram_slice_end = "10" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_10_10
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_10_10_i_1_n_0),
        .O(context_word0[10]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_7_7_i_2_n_0));
  LUT6 #(
    .INIT(64'h6AAA000000000000)) 
    contexts_reg_0_7_10_10_i_1
       (.I0(context_word0[10]),
        .I1(context_word0[8]),
        .I2(context_word0[7]),
        .I3(context_word0[9]),
        .I4(context_word1),
        .I5(context_word0[16]),
        .O(contexts_reg_0_7_10_10_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "110" *) 
  (* ram_slice_end = "110" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_110_110
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_110_110_i_1_n_0),
        .O(context_word0[110]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_110_110_i_1
       (.I0(next_wl0[35]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_110_110_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "111" *) 
  (* ram_slice_end = "111" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_111_111
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_111_111_i_1_n_0),
        .O(context_word0[111]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_111_111_i_1
       (.I0(next_wl0[36]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_111_111_i_1_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 contexts_reg_0_7_111_111_i_2
       (.CI(contexts_reg_0_7_107_107_i_2_n_0),
        .CO({NLW_contexts_reg_0_7_111_111_i_2_CO_UNCONNECTED[3],contexts_reg_0_7_111_111_i_2_n_1,contexts_reg_0_7_111_111_i_2_n_2,contexts_reg_0_7_111_111_i_2_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,contexts_reg_0_7_111_111_i_3_n_0,contexts_reg_0_7_111_111_i_4_n_0,contexts_reg_0_7_111_111_i_5_n_0}),
        .O(next_wl0[39:36]),
        .S({contexts_reg_0_7_111_111_i_6_n_0,contexts_reg_0_7_111_111_i_7_n_0,contexts_reg_0_7_111_111_i_8_n_0,contexts_reg_0_7_111_111_i_9_n_0}));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_111_111_i_3
       (.I0(context_word0[112]),
        .I1(context_word1),
        .O(contexts_reg_0_7_111_111_i_3_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_111_111_i_4
       (.I0(context_word0[111]),
        .I1(context_word1),
        .O(contexts_reg_0_7_111_111_i_4_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_111_111_i_5
       (.I0(context_word0[110]),
        .I1(context_word1),
        .O(contexts_reg_0_7_111_111_i_5_n_0));
  LUT3 #(
    .INIT(8'hD7)) 
    contexts_reg_0_7_111_111_i_6
       (.I0(context_word1),
        .I1(context_word0[114]),
        .I2(context_word0[113]),
        .O(contexts_reg_0_7_111_111_i_6_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_111_111_i_7
       (.I0(context_word0[112]),
        .I1(context_word1),
        .I2(context_word0[113]),
        .O(contexts_reg_0_7_111_111_i_7_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_111_111_i_8
       (.I0(context_word0[111]),
        .I1(context_word1),
        .I2(context_word0[112]),
        .O(contexts_reg_0_7_111_111_i_8_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_111_111_i_9
       (.I0(context_word0[110]),
        .I1(context_word1),
        .I2(context_word0[111]),
        .O(contexts_reg_0_7_111_111_i_9_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "112" *) 
  (* ram_slice_end = "112" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_112_112
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_112_112_i_1_n_0),
        .O(context_word0[112]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_112_112_i_1
       (.I0(next_wl0[37]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_112_112_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "113" *) 
  (* ram_slice_end = "113" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_113_113
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_113_113_i_1_n_0),
        .O(context_word0[113]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_113_113_i_1
       (.I0(next_wl0[38]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_113_113_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "114" *) 
  (* ram_slice_end = "114" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_114_114
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_114_114_i_1_n_0),
        .O(context_word0[114]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_114_114_i_1
       (.I0(next_wl0[39]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_114_114_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "115" *) 
  (* ram_slice_end = "115" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_115_115
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_115_115_i_1_n_0),
        .O(context_word0[115]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_115_115_i_1
       (.I0(next_mav0[0]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_115_115_i_1_n_0));
  LUT6 #(
    .INIT(64'hD22DFFFF2DD20000)) 
    contexts_reg_0_7_115_115_i_10
       (.I0(next_mav4[78]),
        .I1(context_word0[16]),
        .I2(context_word0[235]),
        .I3(context_word0[115]),
        .I4(context_word1),
        .I5(sample_data[0]),
        .O(contexts_reg_0_7_115_115_i_10_n_0));
  LUT6 #(
    .INIT(64'hE2E21DE21D1DE21D)) 
    contexts_reg_0_7_115_115_i_11
       (.I0(sample_data[2]),
        .I1(sample_data[23]),
        .I2(next_mav2[2]),
        .I3(next_mav4[80]),
        .I4(contexts_reg_0_7_115_115_i_18_n_0),
        .I5(contexts_reg_0_7_115_115_i_19_n_0),
        .O(contexts_reg_0_7_115_115_i_11_n_0));
  (* SOFT_HLUTNM = "soft_lutpair195" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    contexts_reg_0_7_115_115_i_12
       (.I0(next_mav2[1]),
        .I1(sample_data[23]),
        .I2(sample_data[1]),
        .O(next_mav1[1]));
  (* SOFT_HLUTNM = "soft_lutpair63" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_115_115_i_13
       (.I0(next_mav4[79]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_115_115_i_13_n_0));
  LUT6 #(
    .INIT(64'hE2E21DE21D1DE21D)) 
    contexts_reg_0_7_115_115_i_14
       (.I0(sample_data[1]),
        .I1(sample_data[23]),
        .I2(next_mav2[1]),
        .I3(next_mav4[79]),
        .I4(contexts_reg_0_7_115_115_i_18_n_0),
        .I5(contexts_reg_0_7_115_115_i_20_n_0),
        .O(contexts_reg_0_7_115_115_i_14_n_0));
  LUT6 #(
    .INIT(64'h1D1DE21DE2E21DE2)) 
    contexts_reg_0_7_115_115_i_15
       (.I0(sample_data[3]),
        .I1(sample_data[23]),
        .I2(next_mav2[3]),
        .I3(next_mav4[81]),
        .I4(contexts_reg_0_7_115_115_i_18_n_0),
        .I5(contexts_reg_0_7_115_115_i_21_n_0),
        .O(contexts_reg_0_7_115_115_i_15_n_0));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT5 #(
    .INIT(32'hEF8AAAAA)) 
    contexts_reg_0_7_115_115_i_16
       (.I0(next_mav1[2]),
        .I1(context_word0[16]),
        .I2(next_mav4[80]),
        .I3(context_word0[237]),
        .I4(context_word1),
        .O(contexts_reg_0_7_115_115_i_16_n_0));
  (* SOFT_HLUTNM = "soft_lutpair63" *) 
  LUT5 #(
    .INIT(32'h17551155)) 
    contexts_reg_0_7_115_115_i_17
       (.I0(next_mav1[1]),
        .I1(context_word0[236]),
        .I2(context_word0[16]),
        .I3(context_word1),
        .I4(next_mav4[79]),
        .O(contexts_reg_0_7_115_115_i_17_n_0));
  (* SOFT_HLUTNM = "soft_lutpair119" *) 
  LUT2 #(
    .INIT(4'hB)) 
    contexts_reg_0_7_115_115_i_18
       (.I0(context_word0[16]),
        .I1(context_word1),
        .O(contexts_reg_0_7_115_115_i_18_n_0));
  (* SOFT_HLUTNM = "soft_lutpair114" *) 
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_115_115_i_19
       (.I0(context_word1),
        .I1(context_word0[237]),
        .O(contexts_reg_0_7_115_115_i_19_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 contexts_reg_0_7_115_115_i_2
       (.CI(1'b0),
        .CO({contexts_reg_0_7_115_115_i_2_n_0,contexts_reg_0_7_115_115_i_2_n_1,contexts_reg_0_7_115_115_i_2_n_2,contexts_reg_0_7_115_115_i_2_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_115_115_i_3_n_0,contexts_reg_0_7_115_115_i_4_n_0,contexts_reg_0_7_115_115_i_5_n_0,contexts_reg_0_7_115_115_i_6_n_0}),
        .O(next_mav0[3:0]),
        .S({contexts_reg_0_7_115_115_i_7_n_0,contexts_reg_0_7_115_115_i_8_n_0,contexts_reg_0_7_115_115_i_9_n_0,contexts_reg_0_7_115_115_i_10_n_0}));
  (* SOFT_HLUTNM = "soft_lutpair136" *) 
  LUT2 #(
    .INIT(4'h7)) 
    contexts_reg_0_7_115_115_i_20
       (.I0(context_word0[236]),
        .I1(context_word1),
        .O(contexts_reg_0_7_115_115_i_20_n_0));
  (* SOFT_HLUTNM = "soft_lutpair135" *) 
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_115_115_i_21
       (.I0(context_word0[238]),
        .I1(context_word1),
        .O(contexts_reg_0_7_115_115_i_21_n_0));
  LUT6 #(
    .INIT(64'hF8808080F8A8F880)) 
    contexts_reg_0_7_115_115_i_3
       (.I0(context_word1),
        .I1(context_word0[117]),
        .I2(contexts_reg_0_7_115_115_i_11_n_0),
        .I3(next_mav1[1]),
        .I4(context_word0[236]),
        .I5(contexts_reg_0_7_115_115_i_13_n_0),
        .O(contexts_reg_0_7_115_115_i_3_n_0));
  LUT5 #(
    .INIT(32'h8000EA00)) 
    contexts_reg_0_7_115_115_i_4
       (.I0(context_word0[116]),
        .I1(sample_data[0]),
        .I2(context_word0[115]),
        .I3(context_word1),
        .I4(contexts_reg_0_7_115_115_i_14_n_0),
        .O(contexts_reg_0_7_115_115_i_4_n_0));
  LUT5 #(
    .INIT(32'h65959595)) 
    contexts_reg_0_7_115_115_i_5
       (.I0(contexts_reg_0_7_115_115_i_14_n_0),
        .I1(context_word0[116]),
        .I2(context_word1),
        .I3(context_word0[115]),
        .I4(sample_data[0]),
        .O(contexts_reg_0_7_115_115_i_5_n_0));
  LUT4 #(
    .INIT(16'h90A0)) 
    contexts_reg_0_7_115_115_i_6
       (.I0(context_word0[235]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[78]),
        .O(contexts_reg_0_7_115_115_i_6_n_0));
  LUT5 #(
    .INIT(32'h956A6A95)) 
    contexts_reg_0_7_115_115_i_7
       (.I0(contexts_reg_0_7_115_115_i_3_n_0),
        .I1(context_word1),
        .I2(context_word0[118]),
        .I3(contexts_reg_0_7_115_115_i_15_n_0),
        .I4(contexts_reg_0_7_115_115_i_16_n_0),
        .O(contexts_reg_0_7_115_115_i_7_n_0));
  LUT5 #(
    .INIT(32'h96666999)) 
    contexts_reg_0_7_115_115_i_8
       (.I0(contexts_reg_0_7_115_115_i_4_n_0),
        .I1(contexts_reg_0_7_115_115_i_11_n_0),
        .I2(context_word0[117]),
        .I3(context_word1),
        .I4(contexts_reg_0_7_115_115_i_17_n_0),
        .O(contexts_reg_0_7_115_115_i_8_n_0));
  LUT5 #(
    .INIT(32'h55555595)) 
    contexts_reg_0_7_115_115_i_9
       (.I0(contexts_reg_0_7_115_115_i_5_n_0),
        .I1(next_mav4[78]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(context_word0[235]),
        .O(contexts_reg_0_7_115_115_i_9_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "116" *) 
  (* ram_slice_end = "116" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_116_116
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_116_116_i_1_n_0),
        .O(context_word0[116]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_116_116_i_1
       (.I0(next_mav0[1]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_116_116_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "117" *) 
  (* ram_slice_end = "117" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_117_117
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_117_117_i_1_n_0),
        .O(context_word0[117]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_117_117_i_1
       (.I0(next_mav0[2]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_117_117_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "118" *) 
  (* ram_slice_end = "118" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_118_118
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_118_118_i_1_n_0),
        .O(context_word0[118]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_118_118_i_1
       (.I0(next_mav0[3]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_118_118_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "119" *) 
  (* ram_slice_end = "119" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_119_119
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_119_119_i_1_n_0),
        .O(context_word0[119]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_119_119_i_1
       (.I0(next_mav0[4]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_119_119_i_1_n_0));
  LUT5 #(
    .INIT(32'h96666999)) 
    contexts_reg_0_7_119_119_i_10
       (.I0(contexts_reg_0_7_119_119_i_6_n_0),
        .I1(contexts_reg_0_7_119_119_i_26_n_0),
        .I2(context_word1),
        .I3(context_word0[119]),
        .I4(contexts_reg_0_7_119_119_i_19_n_0),
        .O(contexts_reg_0_7_119_119_i_10_n_0));
  (* SOFT_HLUTNM = "soft_lutpair59" *) 
  LUT5 #(
    .INIT(32'hA5655595)) 
    contexts_reg_0_7_119_119_i_11
       (.I0(next_mav1[6]),
        .I1(next_mav4[84]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(context_word0[241]),
        .O(contexts_reg_0_7_119_119_i_11_n_0));
  (* SOFT_HLUTNM = "soft_lutpair197" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    contexts_reg_0_7_119_119_i_12
       (.I0(next_mav2[5]),
        .I1(sample_data[23]),
        .I2(sample_data[5]),
        .O(next_mav1[5]));
  (* SOFT_HLUTNM = "soft_lutpair60" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_119_119_i_13
       (.I0(next_mav4[83]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_119_119_i_13_n_0));
  (* SOFT_HLUTNM = "soft_lutpair61" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_119_119_i_14
       (.I0(next_mav4[82]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_119_119_i_14_n_0));
  (* SOFT_HLUTNM = "soft_lutpair196" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    contexts_reg_0_7_119_119_i_15
       (.I0(next_mav2[4]),
        .I1(sample_data[23]),
        .I2(sample_data[4]),
        .O(next_mav1[4]));
  LUT6 #(
    .INIT(64'hE2E21DE21D1DE21D)) 
    contexts_reg_0_7_119_119_i_16
       (.I0(sample_data[5]),
        .I1(sample_data[23]),
        .I2(next_mav2[5]),
        .I3(next_mav4[83]),
        .I4(contexts_reg_0_7_115_115_i_18_n_0),
        .I5(contexts_reg_0_7_119_119_i_27_n_0),
        .O(contexts_reg_0_7_119_119_i_16_n_0));
  (* SOFT_HLUTNM = "soft_lutpair196" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    contexts_reg_0_7_119_119_i_17
       (.I0(next_mav2[3]),
        .I1(sample_data[23]),
        .I2(sample_data[3]),
        .O(next_mav1[3]));
  (* SOFT_HLUTNM = "soft_lutpair62" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_119_119_i_18
       (.I0(next_mav4[81]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_119_119_i_18_n_0));
  LUT6 #(
    .INIT(64'h1D1DE21DE2E21DE2)) 
    contexts_reg_0_7_119_119_i_19
       (.I0(sample_data[4]),
        .I1(sample_data[23]),
        .I2(next_mav2[4]),
        .I3(next_mav4[82]),
        .I4(contexts_reg_0_7_115_115_i_18_n_0),
        .I5(contexts_reg_0_7_119_119_i_28_n_0),
        .O(contexts_reg_0_7_119_119_i_19_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 contexts_reg_0_7_119_119_i_2
       (.CI(contexts_reg_0_7_115_115_i_2_n_0),
        .CO({contexts_reg_0_7_119_119_i_2_n_0,contexts_reg_0_7_119_119_i_2_n_1,contexts_reg_0_7_119_119_i_2_n_2,contexts_reg_0_7_119_119_i_2_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_119_119_i_3_n_0,contexts_reg_0_7_119_119_i_4_n_0,contexts_reg_0_7_119_119_i_5_n_0,contexts_reg_0_7_119_119_i_6_n_0}),
        .O(next_mav0[7:4]),
        .S({contexts_reg_0_7_119_119_i_7_n_0,contexts_reg_0_7_119_119_i_8_n_0,contexts_reg_0_7_119_119_i_9_n_0,contexts_reg_0_7_119_119_i_10_n_0}));
  (* SOFT_HLUTNM = "soft_lutpair195" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    contexts_reg_0_7_119_119_i_20
       (.I0(next_mav2[2]),
        .I1(sample_data[23]),
        .I2(sample_data[2]),
        .O(next_mav1[2]));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_119_119_i_21
       (.I0(next_mav4[80]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_119_119_i_21_n_0));
  (* SOFT_HLUTNM = "soft_lutpair60" *) 
  LUT5 #(
    .INIT(32'hEFAA8AAA)) 
    contexts_reg_0_7_119_119_i_22
       (.I0(next_mav1[5]),
        .I1(context_word0[16]),
        .I2(next_mav4[83]),
        .I3(context_word1),
        .I4(context_word0[240]),
        .O(contexts_reg_0_7_119_119_i_22_n_0));
  LUT6 #(
    .INIT(64'hAA6A5A9A5A9AAA6A)) 
    contexts_reg_0_7_119_119_i_23
       (.I0(next_mav1[7]),
        .I1(next_mav4[85]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(context_word0[242]),
        .I5(context_word0[122]),
        .O(contexts_reg_0_7_119_119_i_23_n_0));
  (* SOFT_HLUTNM = "soft_lutpair59" *) 
  LUT5 #(
    .INIT(32'h004073FF)) 
    contexts_reg_0_7_119_119_i_24
       (.I0(context_word0[16]),
        .I1(context_word1),
        .I2(next_mav4[84]),
        .I3(context_word0[241]),
        .I4(next_mav1[6]),
        .O(contexts_reg_0_7_119_119_i_24_n_0));
  (* SOFT_HLUTNM = "soft_lutpair61" *) 
  LUT5 #(
    .INIT(32'hEFFF80A0)) 
    contexts_reg_0_7_119_119_i_25
       (.I0(context_word0[239]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[82]),
        .I4(next_mav1[4]),
        .O(contexts_reg_0_7_119_119_i_25_n_0));
  (* SOFT_HLUTNM = "soft_lutpair62" *) 
  LUT5 #(
    .INIT(32'hEFAA8AAA)) 
    contexts_reg_0_7_119_119_i_26
       (.I0(next_mav1[3]),
        .I1(context_word0[16]),
        .I2(next_mav4[81]),
        .I3(context_word1),
        .I4(context_word0[238]),
        .O(contexts_reg_0_7_119_119_i_26_n_0));
  (* SOFT_HLUTNM = "soft_lutpair133" *) 
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_119_119_i_27
       (.I0(context_word0[240]),
        .I1(context_word1),
        .O(contexts_reg_0_7_119_119_i_27_n_0));
  (* SOFT_HLUTNM = "soft_lutpair134" *) 
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_119_119_i_28
       (.I0(context_word0[239]),
        .I1(context_word1),
        .O(contexts_reg_0_7_119_119_i_28_n_0));
  LUT6 #(
    .INIT(64'hF880F8A88080F880)) 
    contexts_reg_0_7_119_119_i_3
       (.I0(context_word1),
        .I1(context_word0[121]),
        .I2(contexts_reg_0_7_119_119_i_11_n_0),
        .I3(next_mav1[5]),
        .I4(contexts_reg_0_7_119_119_i_13_n_0),
        .I5(context_word0[240]),
        .O(contexts_reg_0_7_119_119_i_3_n_0));
  LUT6 #(
    .INIT(64'hEFAACF088A080000)) 
    contexts_reg_0_7_119_119_i_4
       (.I0(context_word1),
        .I1(context_word0[239]),
        .I2(contexts_reg_0_7_119_119_i_14_n_0),
        .I3(next_mav1[4]),
        .I4(context_word0[120]),
        .I5(contexts_reg_0_7_119_119_i_16_n_0),
        .O(contexts_reg_0_7_119_119_i_4_n_0));
  LUT6 #(
    .INIT(64'hB020FAF20000BA22)) 
    contexts_reg_0_7_119_119_i_5
       (.I0(next_mav1[3]),
        .I1(contexts_reg_0_7_119_119_i_18_n_0),
        .I2(context_word1),
        .I3(context_word0[238]),
        .I4(contexts_reg_0_7_119_119_i_19_n_0),
        .I5(context_word0[119]),
        .O(contexts_reg_0_7_119_119_i_5_n_0));
  LUT6 #(
    .INIT(64'hB200FFA20000B2A2)) 
    contexts_reg_0_7_119_119_i_6
       (.I0(next_mav1[2]),
        .I1(contexts_reg_0_7_119_119_i_21_n_0),
        .I2(context_word0[237]),
        .I3(context_word1),
        .I4(contexts_reg_0_7_115_115_i_15_n_0),
        .I5(context_word0[118]),
        .O(contexts_reg_0_7_119_119_i_6_n_0));
  LUT6 #(
    .INIT(64'hE88817771777E888)) 
    contexts_reg_0_7_119_119_i_7
       (.I0(contexts_reg_0_7_119_119_i_22_n_0),
        .I1(contexts_reg_0_7_119_119_i_11_n_0),
        .I2(context_word0[121]),
        .I3(context_word1),
        .I4(contexts_reg_0_7_119_119_i_23_n_0),
        .I5(contexts_reg_0_7_119_119_i_24_n_0),
        .O(contexts_reg_0_7_119_119_i_7_n_0));
  LUT5 #(
    .INIT(32'h6A95956A)) 
    contexts_reg_0_7_119_119_i_8
       (.I0(contexts_reg_0_7_119_119_i_4_n_0),
        .I1(context_word1),
        .I2(context_word0[121]),
        .I3(contexts_reg_0_7_119_119_i_11_n_0),
        .I4(contexts_reg_0_7_119_119_i_22_n_0),
        .O(contexts_reg_0_7_119_119_i_8_n_0));
  LUT5 #(
    .INIT(32'h69999666)) 
    contexts_reg_0_7_119_119_i_9
       (.I0(contexts_reg_0_7_119_119_i_5_n_0),
        .I1(contexts_reg_0_7_119_119_i_25_n_0),
        .I2(context_word1),
        .I3(context_word0[120]),
        .I4(contexts_reg_0_7_119_119_i_16_n_0),
        .O(contexts_reg_0_7_119_119_i_9_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "11" *) 
  (* ram_slice_end = "11" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_11_11
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_11_11_i_1_n_0),
        .O(context_word0[11]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_7_7_i_2_n_0));
  LUT6 #(
    .INIT(64'h0000000088788888)) 
    contexts_reg_0_7_11_11_i_1
       (.I0(context_word0[11]),
        .I1(context_word1),
        .I2(context_word0[9]),
        .I3(contexts_reg_0_7_11_11_i_2_n_0),
        .I4(context_word0[10]),
        .I5(contexts_reg_0_7_7_7_i_3_n_0),
        .O(contexts_reg_0_7_11_11_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair44" *) 
  LUT3 #(
    .INIT(8'h7F)) 
    contexts_reg_0_7_11_11_i_2
       (.I0(context_word1),
        .I1(context_word0[7]),
        .I2(context_word0[8]),
        .O(contexts_reg_0_7_11_11_i_2_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "120" *) 
  (* ram_slice_end = "120" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_120_120
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_120_120_i_1_n_0),
        .O(context_word0[120]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_120_120_i_1
       (.I0(next_mav0[5]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_120_120_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "121" *) 
  (* ram_slice_end = "121" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_121_121
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_121_121_i_1_n_0),
        .O(context_word0[121]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_121_121_i_1
       (.I0(next_mav0[6]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_121_121_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "122" *) 
  (* ram_slice_end = "122" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_122_122
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_122_122_i_1_n_0),
        .O(context_word0[122]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_122_122_i_1
       (.I0(next_mav0[7]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_122_122_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "123" *) 
  (* ram_slice_end = "123" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_123_123
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_123_123_i_1_n_0),
        .O(context_word0[123]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_123_123_i_1
       (.I0(next_mav0[8]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_123_123_i_1_n_0));
  LUT5 #(
    .INIT(32'h96666999)) 
    contexts_reg_0_7_123_123_i_10
       (.I0(contexts_reg_0_7_123_123_i_6_n_0),
        .I1(contexts_reg_0_7_123_123_i_17_n_0),
        .I2(context_word0[123]),
        .I3(context_word1),
        .I4(contexts_reg_0_7_123_123_i_28_n_0),
        .O(contexts_reg_0_7_123_123_i_10_n_0));
  LUT6 #(
    .INIT(64'hE2E21DE21D1DE21D)) 
    contexts_reg_0_7_123_123_i_11
       (.I0(sample_data[10]),
        .I1(sample_data[23]),
        .I2(next_mav2[10]),
        .I3(next_mav4[88]),
        .I4(contexts_reg_0_7_115_115_i_18_n_0),
        .I5(contexts_reg_0_7_123_123_i_29_n_0),
        .O(contexts_reg_0_7_123_123_i_11_n_0));
  (* SOFT_HLUTNM = "soft_lutpair199" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    contexts_reg_0_7_123_123_i_12
       (.I0(next_mav2[9]),
        .I1(sample_data[23]),
        .I2(sample_data[9]),
        .O(next_mav1[9]));
  (* SOFT_HLUTNM = "soft_lutpair96" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_123_123_i_13
       (.I0(next_mav4[87]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_123_123_i_13_n_0));
  (* SOFT_HLUTNM = "soft_lutpair56" *) 
  LUT5 #(
    .INIT(32'hA5655595)) 
    contexts_reg_0_7_123_123_i_14
       (.I0(next_mav1[9]),
        .I1(next_mav4[87]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(context_word0[244]),
        .O(contexts_reg_0_7_123_123_i_14_n_0));
  (* SOFT_HLUTNM = "soft_lutpair57" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_123_123_i_15
       (.I0(next_mav4[86]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_123_123_i_15_n_0));
  (* SOFT_HLUTNM = "soft_lutpair198" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    contexts_reg_0_7_123_123_i_16
       (.I0(next_mav2[8]),
        .I1(sample_data[23]),
        .I2(sample_data[8]),
        .O(next_mav1[8]));
  LUT6 #(
    .INIT(64'hE2E21DE21D1DE21D)) 
    contexts_reg_0_7_123_123_i_17
       (.I0(sample_data[8]),
        .I1(sample_data[23]),
        .I2(next_mav2[8]),
        .I3(next_mav4[86]),
        .I4(contexts_reg_0_7_115_115_i_18_n_0),
        .I5(contexts_reg_0_7_123_123_i_30_n_0),
        .O(contexts_reg_0_7_123_123_i_17_n_0));
  (* SOFT_HLUTNM = "soft_lutpair198" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    contexts_reg_0_7_123_123_i_18
       (.I0(next_mav2[7]),
        .I1(sample_data[23]),
        .I2(sample_data[7]),
        .O(next_mav1[7]));
  (* SOFT_HLUTNM = "soft_lutpair58" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_123_123_i_19
       (.I0(next_mav4[85]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_123_123_i_19_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 contexts_reg_0_7_123_123_i_2
       (.CI(contexts_reg_0_7_119_119_i_2_n_0),
        .CO({contexts_reg_0_7_123_123_i_2_n_0,contexts_reg_0_7_123_123_i_2_n_1,contexts_reg_0_7_123_123_i_2_n_2,contexts_reg_0_7_123_123_i_2_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_123_123_i_3_n_0,contexts_reg_0_7_123_123_i_4_n_0,contexts_reg_0_7_123_123_i_5_n_0,contexts_reg_0_7_123_123_i_6_n_0}),
        .O(next_mav0[11:8]),
        .S({contexts_reg_0_7_123_123_i_7_n_0,contexts_reg_0_7_123_123_i_8_n_0,contexts_reg_0_7_123_123_i_9_n_0,contexts_reg_0_7_123_123_i_10_n_0}));
  LUT6 #(
    .INIT(64'hE2E21DE21D1DE21D)) 
    contexts_reg_0_7_123_123_i_20
       (.I0(sample_data[7]),
        .I1(sample_data[23]),
        .I2(next_mav2[7]),
        .I3(next_mav4[85]),
        .I4(contexts_reg_0_7_115_115_i_18_n_0),
        .I5(contexts_reg_0_7_123_123_i_31_n_0),
        .O(contexts_reg_0_7_123_123_i_20_n_0));
  (* SOFT_HLUTNM = "soft_lutpair100" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_123_123_i_21
       (.I0(next_mav4[84]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_123_123_i_21_n_0));
  (* SOFT_HLUTNM = "soft_lutpair197" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    contexts_reg_0_7_123_123_i_22
       (.I0(next_mav2[6]),
        .I1(sample_data[23]),
        .I2(sample_data[6]),
        .O(next_mav1[6]));
  LUT6 #(
    .INIT(64'hE2E21DE21D1DE21D)) 
    contexts_reg_0_7_123_123_i_23
       (.I0(sample_data[11]),
        .I1(sample_data[23]),
        .I2(next_mav2[11]),
        .I3(next_mav4[89]),
        .I4(contexts_reg_0_7_115_115_i_18_n_0),
        .I5(contexts_reg_0_7_123_123_i_32_n_0),
        .O(contexts_reg_0_7_123_123_i_23_n_0));
  (* SOFT_HLUTNM = "soft_lutpair55" *) 
  LUT5 #(
    .INIT(32'hE8AAEEAA)) 
    contexts_reg_0_7_123_123_i_24
       (.I0(next_mav1[10]),
        .I1(context_word0[245]),
        .I2(context_word0[16]),
        .I3(context_word1),
        .I4(next_mav4[88]),
        .O(contexts_reg_0_7_123_123_i_24_n_0));
  (* SOFT_HLUTNM = "soft_lutpair57" *) 
  LUT5 #(
    .INIT(32'hFFBF8C00)) 
    contexts_reg_0_7_123_123_i_25
       (.I0(context_word0[16]),
        .I1(context_word1),
        .I2(next_mav4[86]),
        .I3(context_word0[243]),
        .I4(next_mav1[8]),
        .O(contexts_reg_0_7_123_123_i_25_n_0));
  LUT6 #(
    .INIT(64'h5595A565A5655595)) 
    contexts_reg_0_7_123_123_i_26
       (.I0(next_mav1[10]),
        .I1(next_mav4[88]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(context_word0[245]),
        .I5(context_word0[125]),
        .O(contexts_reg_0_7_123_123_i_26_n_0));
  (* SOFT_HLUTNM = "soft_lutpair56" *) 
  LUT5 #(
    .INIT(32'hE8AAEEAA)) 
    contexts_reg_0_7_123_123_i_27
       (.I0(next_mav1[9]),
        .I1(context_word0[244]),
        .I2(context_word0[16]),
        .I3(context_word1),
        .I4(next_mav4[87]),
        .O(contexts_reg_0_7_123_123_i_27_n_0));
  (* SOFT_HLUTNM = "soft_lutpair58" *) 
  LUT5 #(
    .INIT(32'hEFAA8AAA)) 
    contexts_reg_0_7_123_123_i_28
       (.I0(next_mav1[7]),
        .I1(context_word0[16]),
        .I2(next_mav4[85]),
        .I3(context_word1),
        .I4(context_word0[242]),
        .O(contexts_reg_0_7_123_123_i_28_n_0));
  (* SOFT_HLUTNM = "soft_lutpair130" *) 
  LUT2 #(
    .INIT(4'h7)) 
    contexts_reg_0_7_123_123_i_29
       (.I0(context_word0[245]),
        .I1(context_word1),
        .O(contexts_reg_0_7_123_123_i_29_n_0));
  LUT6 #(
    .INIT(64'hD5404040D5C4D540)) 
    contexts_reg_0_7_123_123_i_3
       (.I0(contexts_reg_0_7_123_123_i_11_n_0),
        .I1(context_word1),
        .I2(context_word0[125]),
        .I3(next_mav1[9]),
        .I4(context_word0[244]),
        .I5(contexts_reg_0_7_123_123_i_13_n_0),
        .O(contexts_reg_0_7_123_123_i_3_n_0));
  (* SOFT_HLUTNM = "soft_lutpair131" *) 
  LUT2 #(
    .INIT(4'h7)) 
    contexts_reg_0_7_123_123_i_30
       (.I0(context_word0[243]),
        .I1(context_word1),
        .O(contexts_reg_0_7_123_123_i_30_n_0));
  (* SOFT_HLUTNM = "soft_lutpair132" *) 
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_123_123_i_31
       (.I0(context_word0[242]),
        .I1(context_word1),
        .O(contexts_reg_0_7_123_123_i_31_n_0));
  (* SOFT_HLUTNM = "soft_lutpair129" *) 
  LUT2 #(
    .INIT(4'h7)) 
    contexts_reg_0_7_123_123_i_32
       (.I0(context_word0[246]),
        .I1(context_word1),
        .O(contexts_reg_0_7_123_123_i_32_n_0));
  LUT6 #(
    .INIT(64'hF8F880F880A88080)) 
    contexts_reg_0_7_123_123_i_4
       (.I0(context_word1),
        .I1(context_word0[124]),
        .I2(contexts_reg_0_7_123_123_i_14_n_0),
        .I3(contexts_reg_0_7_123_123_i_15_n_0),
        .I4(context_word0[243]),
        .I5(next_mav1[8]),
        .O(contexts_reg_0_7_123_123_i_4_n_0));
  LUT6 #(
    .INIT(64'hD540D5C44040D540)) 
    contexts_reg_0_7_123_123_i_5
       (.I0(contexts_reg_0_7_123_123_i_17_n_0),
        .I1(context_word1),
        .I2(context_word0[123]),
        .I3(next_mav1[7]),
        .I4(contexts_reg_0_7_123_123_i_19_n_0),
        .I5(context_word0[242]),
        .O(contexts_reg_0_7_123_123_i_5_n_0));
  LUT6 #(
    .INIT(64'hF8F880F880A88080)) 
    contexts_reg_0_7_123_123_i_6
       (.I0(context_word1),
        .I1(context_word0[122]),
        .I2(contexts_reg_0_7_123_123_i_20_n_0),
        .I3(contexts_reg_0_7_123_123_i_21_n_0),
        .I4(context_word0[241]),
        .I5(next_mav1[6]),
        .O(contexts_reg_0_7_123_123_i_6_n_0));
  LUT5 #(
    .INIT(32'h96666999)) 
    contexts_reg_0_7_123_123_i_7
       (.I0(contexts_reg_0_7_123_123_i_3_n_0),
        .I1(contexts_reg_0_7_123_123_i_23_n_0),
        .I2(context_word0[126]),
        .I3(context_word1),
        .I4(contexts_reg_0_7_123_123_i_24_n_0),
        .O(contexts_reg_0_7_123_123_i_7_n_0));
  LUT6 #(
    .INIT(64'hE88817771777E888)) 
    contexts_reg_0_7_123_123_i_8
       (.I0(contexts_reg_0_7_123_123_i_25_n_0),
        .I1(contexts_reg_0_7_123_123_i_14_n_0),
        .I2(context_word0[124]),
        .I3(context_word1),
        .I4(contexts_reg_0_7_123_123_i_26_n_0),
        .I5(contexts_reg_0_7_123_123_i_27_n_0),
        .O(contexts_reg_0_7_123_123_i_8_n_0));
  LUT5 #(
    .INIT(32'h6A95956A)) 
    contexts_reg_0_7_123_123_i_9
       (.I0(contexts_reg_0_7_123_123_i_5_n_0),
        .I1(context_word1),
        .I2(context_word0[124]),
        .I3(contexts_reg_0_7_123_123_i_14_n_0),
        .I4(contexts_reg_0_7_123_123_i_25_n_0),
        .O(contexts_reg_0_7_123_123_i_9_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "124" *) 
  (* ram_slice_end = "124" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_124_124
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_124_124_i_1_n_0),
        .O(context_word0[124]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_124_124_i_1
       (.I0(next_mav0[9]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_124_124_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "125" *) 
  (* ram_slice_end = "125" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_125_125
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_125_125_i_1_n_0),
        .O(context_word0[125]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_125_125_i_1
       (.I0(next_mav0[10]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_125_125_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "126" *) 
  (* ram_slice_end = "126" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_126_126
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_126_126_i_1_n_0),
        .O(context_word0[126]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_126_126_i_1
       (.I0(next_mav0[11]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_126_126_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "127" *) 
  (* ram_slice_end = "127" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_127_127
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_127_127_i_1_n_0),
        .O(context_word0[127]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_127_127_i_1
       (.I0(next_mav0[12]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_127_127_i_1_n_0));
  LUT5 #(
    .INIT(32'h96666999)) 
    contexts_reg_0_7_127_127_i_10
       (.I0(contexts_reg_0_7_127_127_i_6_n_0),
        .I1(contexts_reg_0_7_127_127_i_17_n_0),
        .I2(context_word0[127]),
        .I3(context_word1),
        .I4(contexts_reg_0_7_127_127_i_26_n_0),
        .O(contexts_reg_0_7_127_127_i_10_n_0));
  (* SOFT_HLUTNM = "soft_lutpair201" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    contexts_reg_0_7_127_127_i_11
       (.I0(next_mav2[13]),
        .I1(sample_data[23]),
        .I2(sample_data[13]),
        .O(next_mav1[13]));
  (* SOFT_HLUTNM = "soft_lutpair52" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_127_127_i_12
       (.I0(next_mav4[91]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_127_127_i_12_n_0));
  LUT6 #(
    .INIT(64'h1D1DE21DE2E21DE2)) 
    contexts_reg_0_7_127_127_i_13
       (.I0(sample_data[14]),
        .I1(sample_data[23]),
        .I2(next_mav2[14]),
        .I3(next_mav4[92]),
        .I4(contexts_reg_0_7_115_115_i_18_n_0),
        .I5(contexts_reg_0_7_127_127_i_27_n_0),
        .O(contexts_reg_0_7_127_127_i_13_n_0));
  LUT6 #(
    .INIT(64'hE2E21DE21D1DE21D)) 
    contexts_reg_0_7_127_127_i_14
       (.I0(sample_data[13]),
        .I1(sample_data[23]),
        .I2(next_mav2[13]),
        .I3(next_mav4[91]),
        .I4(contexts_reg_0_7_115_115_i_18_n_0),
        .I5(contexts_reg_0_7_127_127_i_28_n_0),
        .O(contexts_reg_0_7_127_127_i_14_n_0));
  (* SOFT_HLUTNM = "soft_lutpair200" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    contexts_reg_0_7_127_127_i_15
       (.I0(next_mav2[12]),
        .I1(sample_data[23]),
        .I2(sample_data[12]),
        .O(next_mav1[12]));
  (* SOFT_HLUTNM = "soft_lutpair53" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_127_127_i_16
       (.I0(next_mav4[90]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_127_127_i_16_n_0));
  LUT6 #(
    .INIT(64'hE2E21DE21D1DE21D)) 
    contexts_reg_0_7_127_127_i_17
       (.I0(sample_data[12]),
        .I1(sample_data[23]),
        .I2(next_mav2[12]),
        .I3(next_mav4[90]),
        .I4(contexts_reg_0_7_115_115_i_18_n_0),
        .I5(contexts_reg_0_7_127_127_i_29_n_0),
        .O(contexts_reg_0_7_127_127_i_17_n_0));
  (* SOFT_HLUTNM = "soft_lutpair200" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    contexts_reg_0_7_127_127_i_18
       (.I0(next_mav2[11]),
        .I1(sample_data[23]),
        .I2(sample_data[11]),
        .O(next_mav1[11]));
  (* SOFT_HLUTNM = "soft_lutpair54" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_127_127_i_19
       (.I0(next_mav4[89]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_127_127_i_19_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 contexts_reg_0_7_127_127_i_2
       (.CI(contexts_reg_0_7_123_123_i_2_n_0),
        .CO({contexts_reg_0_7_127_127_i_2_n_0,contexts_reg_0_7_127_127_i_2_n_1,contexts_reg_0_7_127_127_i_2_n_2,contexts_reg_0_7_127_127_i_2_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_127_127_i_3_n_0,contexts_reg_0_7_127_127_i_4_n_0,contexts_reg_0_7_127_127_i_5_n_0,contexts_reg_0_7_127_127_i_6_n_0}),
        .O(next_mav0[15:12]),
        .S({contexts_reg_0_7_127_127_i_7_n_0,contexts_reg_0_7_127_127_i_8_n_0,contexts_reg_0_7_127_127_i_9_n_0,contexts_reg_0_7_127_127_i_10_n_0}));
  (* SOFT_HLUTNM = "soft_lutpair199" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    contexts_reg_0_7_127_127_i_20
       (.I0(next_mav2[10]),
        .I1(sample_data[23]),
        .I2(sample_data[10]),
        .O(next_mav1[10]));
  (* SOFT_HLUTNM = "soft_lutpair55" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_127_127_i_21
       (.I0(next_mav4[88]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_127_127_i_21_n_0));
  (* SOFT_HLUTNM = "soft_lutpair51" *) 
  LUT5 #(
    .INIT(32'hEFFF80A0)) 
    contexts_reg_0_7_127_127_i_22
       (.I0(context_word0[249]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[92]),
        .I4(next_mav1[14]),
        .O(contexts_reg_0_7_127_127_i_22_n_0));
  LUT6 #(
    .INIT(64'h1D1DE21DE2E21DE2)) 
    contexts_reg_0_7_127_127_i_23
       (.I0(sample_data[15]),
        .I1(sample_data[23]),
        .I2(next_mav2[15]),
        .I3(next_mav4[93]),
        .I4(contexts_reg_0_7_115_115_i_18_n_0),
        .I5(contexts_reg_0_7_127_127_i_30_n_0),
        .O(contexts_reg_0_7_127_127_i_23_n_0));
  (* SOFT_HLUTNM = "soft_lutpair52" *) 
  LUT5 #(
    .INIT(32'hE8AAEEAA)) 
    contexts_reg_0_7_127_127_i_24
       (.I0(next_mav1[13]),
        .I1(context_word0[248]),
        .I2(context_word0[16]),
        .I3(context_word1),
        .I4(next_mav4[91]),
        .O(contexts_reg_0_7_127_127_i_24_n_0));
  (* SOFT_HLUTNM = "soft_lutpair53" *) 
  LUT5 #(
    .INIT(32'hE8AAEEAA)) 
    contexts_reg_0_7_127_127_i_25
       (.I0(next_mav1[12]),
        .I1(context_word0[247]),
        .I2(context_word0[16]),
        .I3(context_word1),
        .I4(next_mav4[90]),
        .O(contexts_reg_0_7_127_127_i_25_n_0));
  (* SOFT_HLUTNM = "soft_lutpair54" *) 
  LUT5 #(
    .INIT(32'hE8AAEEAA)) 
    contexts_reg_0_7_127_127_i_26
       (.I0(next_mav1[11]),
        .I1(context_word0[246]),
        .I2(context_word0[16]),
        .I3(context_word1),
        .I4(next_mav4[89]),
        .O(contexts_reg_0_7_127_127_i_26_n_0));
  (* SOFT_HLUTNM = "soft_lutpair126" *) 
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_127_127_i_27
       (.I0(context_word0[249]),
        .I1(context_word1),
        .O(contexts_reg_0_7_127_127_i_27_n_0));
  (* SOFT_HLUTNM = "soft_lutpair127" *) 
  LUT2 #(
    .INIT(4'h7)) 
    contexts_reg_0_7_127_127_i_28
       (.I0(context_word0[248]),
        .I1(context_word1),
        .O(contexts_reg_0_7_127_127_i_28_n_0));
  (* SOFT_HLUTNM = "soft_lutpair128" *) 
  LUT2 #(
    .INIT(4'h7)) 
    contexts_reg_0_7_127_127_i_29
       (.I0(context_word0[247]),
        .I1(context_word1),
        .O(contexts_reg_0_7_127_127_i_29_n_0));
  LUT6 #(
    .INIT(64'h80C8ECEE0000A0EA)) 
    contexts_reg_0_7_127_127_i_3
       (.I0(next_mav1[13]),
        .I1(context_word1),
        .I2(context_word0[248]),
        .I3(contexts_reg_0_7_127_127_i_12_n_0),
        .I4(contexts_reg_0_7_127_127_i_13_n_0),
        .I5(context_word0[129]),
        .O(contexts_reg_0_7_127_127_i_3_n_0));
  (* SOFT_HLUTNM = "soft_lutpair125" *) 
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_127_127_i_30
       (.I0(context_word0[250]),
        .I1(context_word1),
        .O(contexts_reg_0_7_127_127_i_30_n_0));
  LUT6 #(
    .INIT(64'hD5404040D5C4D540)) 
    contexts_reg_0_7_127_127_i_4
       (.I0(contexts_reg_0_7_127_127_i_14_n_0),
        .I1(context_word1),
        .I2(context_word0[128]),
        .I3(next_mav1[12]),
        .I4(context_word0[247]),
        .I5(contexts_reg_0_7_127_127_i_16_n_0),
        .O(contexts_reg_0_7_127_127_i_4_n_0));
  LUT6 #(
    .INIT(64'hD5404040D5C4D540)) 
    contexts_reg_0_7_127_127_i_5
       (.I0(contexts_reg_0_7_127_127_i_17_n_0),
        .I1(context_word1),
        .I2(context_word0[127]),
        .I3(next_mav1[11]),
        .I4(context_word0[246]),
        .I5(contexts_reg_0_7_127_127_i_19_n_0),
        .O(contexts_reg_0_7_127_127_i_5_n_0));
  LUT6 #(
    .INIT(64'hD5404040D5C4D540)) 
    contexts_reg_0_7_127_127_i_6
       (.I0(contexts_reg_0_7_123_123_i_23_n_0),
        .I1(context_word1),
        .I2(context_word0[126]),
        .I3(next_mav1[10]),
        .I4(context_word0[245]),
        .I5(contexts_reg_0_7_127_127_i_21_n_0),
        .O(contexts_reg_0_7_127_127_i_6_n_0));
  LUT5 #(
    .INIT(32'h96666999)) 
    contexts_reg_0_7_127_127_i_7
       (.I0(contexts_reg_0_7_127_127_i_3_n_0),
        .I1(contexts_reg_0_7_127_127_i_22_n_0),
        .I2(context_word1),
        .I3(context_word0[130]),
        .I4(contexts_reg_0_7_127_127_i_23_n_0),
        .O(contexts_reg_0_7_127_127_i_7_n_0));
  LUT5 #(
    .INIT(32'h956A6A95)) 
    contexts_reg_0_7_127_127_i_8
       (.I0(contexts_reg_0_7_127_127_i_4_n_0),
        .I1(context_word1),
        .I2(context_word0[129]),
        .I3(contexts_reg_0_7_127_127_i_13_n_0),
        .I4(contexts_reg_0_7_127_127_i_24_n_0),
        .O(contexts_reg_0_7_127_127_i_8_n_0));
  LUT5 #(
    .INIT(32'h96666999)) 
    contexts_reg_0_7_127_127_i_9
       (.I0(contexts_reg_0_7_127_127_i_5_n_0),
        .I1(contexts_reg_0_7_127_127_i_14_n_0),
        .I2(context_word0[128]),
        .I3(context_word1),
        .I4(contexts_reg_0_7_127_127_i_25_n_0),
        .O(contexts_reg_0_7_127_127_i_9_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "128" *) 
  (* ram_slice_end = "128" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_128_128
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_128_128_i_1_n_0),
        .O(context_word0[128]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_128_128_i_1
       (.I0(next_mav0[13]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_128_128_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "129" *) 
  (* ram_slice_end = "129" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_129_129
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_129_129_i_1_n_0),
        .O(context_word0[129]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_129_129_i_1
       (.I0(next_mav0[14]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_129_129_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "12" *) 
  (* ram_slice_end = "12" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_12_12
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_12_12_i_1_n_0),
        .O(context_word0[12]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_7_7_i_2_n_0));
  LUT5 #(
    .INIT(32'h80A02000)) 
    contexts_reg_0_7_12_12_i_1
       (.I0(context_word0[16]),
        .I1(contexts_reg_0_7_12_12_i_2_n_0),
        .I2(context_word1),
        .I3(context_word0[11]),
        .I4(context_word0[12]),
        .O(contexts_reg_0_7_12_12_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair44" *) 
  LUT5 #(
    .INIT(32'h7FFFFFFF)) 
    contexts_reg_0_7_12_12_i_2
       (.I0(context_word0[9]),
        .I1(context_word1),
        .I2(context_word0[7]),
        .I3(context_word0[8]),
        .I4(context_word0[10]),
        .O(contexts_reg_0_7_12_12_i_2_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "130" *) 
  (* ram_slice_end = "130" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_130_130
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_130_130_i_1_n_0),
        .O(context_word0[130]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_130_130_i_1
       (.I0(next_mav0[15]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_130_130_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "131" *) 
  (* ram_slice_end = "131" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_131_131
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_131_131_i_1_n_0),
        .O(context_word0[131]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_131_131_i_1
       (.I0(next_mav0[16]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_131_131_i_1_n_0));
  LUT5 #(
    .INIT(32'h96666999)) 
    contexts_reg_0_7_131_131_i_10
       (.I0(contexts_reg_0_7_131_131_i_6_n_0),
        .I1(contexts_reg_0_7_131_131_i_26_n_0),
        .I2(context_word1),
        .I3(context_word0[131]),
        .I4(contexts_reg_0_7_131_131_i_19_n_0),
        .O(contexts_reg_0_7_131_131_i_10_n_0));
  LUT6 #(
    .INIT(64'hE2E21DE21D1DE21D)) 
    contexts_reg_0_7_131_131_i_11
       (.I0(sample_data[18]),
        .I1(sample_data[23]),
        .I2(next_mav2[18]),
        .I3(next_mav4[96]),
        .I4(contexts_reg_0_7_115_115_i_18_n_0),
        .I5(contexts_reg_0_7_131_131_i_27_n_0),
        .O(contexts_reg_0_7_131_131_i_11_n_0));
  (* SOFT_HLUTNM = "soft_lutpair203" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    contexts_reg_0_7_131_131_i_12
       (.I0(next_mav2[17]),
        .I1(sample_data[23]),
        .I2(sample_data[17]),
        .O(next_mav1[17]));
  (* SOFT_HLUTNM = "soft_lutpair48" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_131_131_i_13
       (.I0(next_mav4[95]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_131_131_i_13_n_0));
  (* SOFT_HLUTNM = "soft_lutpair49" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_131_131_i_14
       (.I0(next_mav4[94]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_131_131_i_14_n_0));
  (* SOFT_HLUTNM = "soft_lutpair202" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    contexts_reg_0_7_131_131_i_15
       (.I0(next_mav2[16]),
        .I1(sample_data[23]),
        .I2(sample_data[16]),
        .O(next_mav1[16]));
  LUT6 #(
    .INIT(64'hE2E21DE21D1DE21D)) 
    contexts_reg_0_7_131_131_i_16
       (.I0(sample_data[17]),
        .I1(sample_data[23]),
        .I2(next_mav2[17]),
        .I3(next_mav4[95]),
        .I4(contexts_reg_0_7_115_115_i_18_n_0),
        .I5(contexts_reg_0_7_131_131_i_28_n_0),
        .O(contexts_reg_0_7_131_131_i_16_n_0));
  (* SOFT_HLUTNM = "soft_lutpair50" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_131_131_i_17
       (.I0(next_mav4[93]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_131_131_i_17_n_0));
  (* SOFT_HLUTNM = "soft_lutpair202" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    contexts_reg_0_7_131_131_i_18
       (.I0(next_mav2[15]),
        .I1(sample_data[23]),
        .I2(sample_data[15]),
        .O(next_mav1[15]));
  LUT6 #(
    .INIT(64'h1D1DE21DE2E21DE2)) 
    contexts_reg_0_7_131_131_i_19
       (.I0(sample_data[16]),
        .I1(sample_data[23]),
        .I2(next_mav2[16]),
        .I3(next_mav4[94]),
        .I4(contexts_reg_0_7_115_115_i_18_n_0),
        .I5(contexts_reg_0_7_131_131_i_29_n_0),
        .O(contexts_reg_0_7_131_131_i_19_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 contexts_reg_0_7_131_131_i_2
       (.CI(contexts_reg_0_7_127_127_i_2_n_0),
        .CO({contexts_reg_0_7_131_131_i_2_n_0,contexts_reg_0_7_131_131_i_2_n_1,contexts_reg_0_7_131_131_i_2_n_2,contexts_reg_0_7_131_131_i_2_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_131_131_i_3_n_0,contexts_reg_0_7_131_131_i_4_n_0,contexts_reg_0_7_131_131_i_5_n_0,contexts_reg_0_7_131_131_i_6_n_0}),
        .O(next_mav0[19:16]),
        .S({contexts_reg_0_7_131_131_i_7_n_0,contexts_reg_0_7_131_131_i_8_n_0,contexts_reg_0_7_131_131_i_9_n_0,contexts_reg_0_7_131_131_i_10_n_0}));
  (* SOFT_HLUTNM = "soft_lutpair51" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_131_131_i_20
       (.I0(next_mav4[92]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_131_131_i_20_n_0));
  (* SOFT_HLUTNM = "soft_lutpair201" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    contexts_reg_0_7_131_131_i_21
       (.I0(next_mav2[14]),
        .I1(sample_data[23]),
        .I2(sample_data[14]),
        .O(next_mav1[14]));
  LUT6 #(
    .INIT(64'hE2E21DE21D1DE21D)) 
    contexts_reg_0_7_131_131_i_22
       (.I0(sample_data[19]),
        .I1(sample_data[23]),
        .I2(next_mav2[19]),
        .I3(next_mav4[97]),
        .I4(contexts_reg_0_7_115_115_i_18_n_0),
        .I5(contexts_reg_0_7_131_131_i_30_n_0),
        .O(contexts_reg_0_7_131_131_i_22_n_0));
  (* SOFT_HLUTNM = "soft_lutpair47" *) 
  LUT5 #(
    .INIT(32'h17551155)) 
    contexts_reg_0_7_131_131_i_23
       (.I0(next_mav1[18]),
        .I1(context_word0[253]),
        .I2(context_word0[16]),
        .I3(context_word1),
        .I4(next_mav4[96]),
        .O(contexts_reg_0_7_131_131_i_23_n_0));
  (* SOFT_HLUTNM = "soft_lutpair48" *) 
  LUT5 #(
    .INIT(32'hEFAA8AAA)) 
    contexts_reg_0_7_131_131_i_24
       (.I0(next_mav1[17]),
        .I1(context_word0[16]),
        .I2(next_mav4[95]),
        .I3(context_word1),
        .I4(context_word0[252]),
        .O(contexts_reg_0_7_131_131_i_24_n_0));
  (* SOFT_HLUTNM = "soft_lutpair49" *) 
  LUT5 #(
    .INIT(32'hEFFF80A0)) 
    contexts_reg_0_7_131_131_i_25
       (.I0(context_word0[251]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[94]),
        .I4(next_mav1[16]),
        .O(contexts_reg_0_7_131_131_i_25_n_0));
  (* SOFT_HLUTNM = "soft_lutpair50" *) 
  LUT5 #(
    .INIT(32'hEFFF80A0)) 
    contexts_reg_0_7_131_131_i_26
       (.I0(context_word0[250]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[93]),
        .I4(next_mav1[15]),
        .O(contexts_reg_0_7_131_131_i_26_n_0));
  (* SOFT_HLUTNM = "soft_lutpair122" *) 
  LUT2 #(
    .INIT(4'h7)) 
    contexts_reg_0_7_131_131_i_27
       (.I0(context_word0[253]),
        .I1(context_word1),
        .O(contexts_reg_0_7_131_131_i_27_n_0));
  (* SOFT_HLUTNM = "soft_lutpair123" *) 
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_131_131_i_28
       (.I0(context_word0[252]),
        .I1(context_word1),
        .O(contexts_reg_0_7_131_131_i_28_n_0));
  (* SOFT_HLUTNM = "soft_lutpair124" *) 
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_131_131_i_29
       (.I0(context_word0[251]),
        .I1(context_word1),
        .O(contexts_reg_0_7_131_131_i_29_n_0));
  LUT6 #(
    .INIT(64'hD540D5C44040D540)) 
    contexts_reg_0_7_131_131_i_3
       (.I0(contexts_reg_0_7_131_131_i_11_n_0),
        .I1(context_word1),
        .I2(context_word0[133]),
        .I3(next_mav1[17]),
        .I4(contexts_reg_0_7_131_131_i_13_n_0),
        .I5(context_word0[252]),
        .O(contexts_reg_0_7_131_131_i_3_n_0));
  (* SOFT_HLUTNM = "soft_lutpair116" *) 
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_131_131_i_30
       (.I0(context_word1),
        .I1(context_word0[254]),
        .O(contexts_reg_0_7_131_131_i_30_n_0));
  LUT6 #(
    .INIT(64'hEFAACF088A080000)) 
    contexts_reg_0_7_131_131_i_4
       (.I0(context_word1),
        .I1(context_word0[251]),
        .I2(contexts_reg_0_7_131_131_i_14_n_0),
        .I3(next_mav1[16]),
        .I4(context_word0[132]),
        .I5(contexts_reg_0_7_131_131_i_16_n_0),
        .O(contexts_reg_0_7_131_131_i_4_n_0));
  LUT6 #(
    .INIT(64'h8A08EFAA0000CF08)) 
    contexts_reg_0_7_131_131_i_5
       (.I0(context_word1),
        .I1(context_word0[250]),
        .I2(contexts_reg_0_7_131_131_i_17_n_0),
        .I3(next_mav1[15]),
        .I4(contexts_reg_0_7_131_131_i_19_n_0),
        .I5(context_word0[131]),
        .O(contexts_reg_0_7_131_131_i_5_n_0));
  LUT6 #(
    .INIT(64'h8A08EFAA0000CF08)) 
    contexts_reg_0_7_131_131_i_6
       (.I0(context_word1),
        .I1(context_word0[249]),
        .I2(contexts_reg_0_7_131_131_i_20_n_0),
        .I3(next_mav1[14]),
        .I4(contexts_reg_0_7_127_127_i_23_n_0),
        .I5(context_word0[130]),
        .O(contexts_reg_0_7_131_131_i_6_n_0));
  LUT5 #(
    .INIT(32'h96666999)) 
    contexts_reg_0_7_131_131_i_7
       (.I0(contexts_reg_0_7_131_131_i_3_n_0),
        .I1(contexts_reg_0_7_131_131_i_22_n_0),
        .I2(context_word0[134]),
        .I3(context_word1),
        .I4(contexts_reg_0_7_131_131_i_23_n_0),
        .O(contexts_reg_0_7_131_131_i_7_n_0));
  LUT5 #(
    .INIT(32'h96666999)) 
    contexts_reg_0_7_131_131_i_8
       (.I0(contexts_reg_0_7_131_131_i_4_n_0),
        .I1(contexts_reg_0_7_131_131_i_11_n_0),
        .I2(context_word0[133]),
        .I3(context_word1),
        .I4(contexts_reg_0_7_131_131_i_24_n_0),
        .O(contexts_reg_0_7_131_131_i_8_n_0));
  LUT5 #(
    .INIT(32'h69999666)) 
    contexts_reg_0_7_131_131_i_9
       (.I0(contexts_reg_0_7_131_131_i_5_n_0),
        .I1(contexts_reg_0_7_131_131_i_25_n_0),
        .I2(context_word1),
        .I3(context_word0[132]),
        .I4(contexts_reg_0_7_131_131_i_16_n_0),
        .O(contexts_reg_0_7_131_131_i_9_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "132" *) 
  (* ram_slice_end = "132" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_132_132
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_132_132_i_1_n_0),
        .O(context_word0[132]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_132_132_i_1
       (.I0(next_mav0[17]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_132_132_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "133" *) 
  (* ram_slice_end = "133" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_133_133
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_133_133_i_1_n_0),
        .O(context_word0[133]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_133_133_i_1
       (.I0(next_mav0[18]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_133_133_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "134" *) 
  (* ram_slice_end = "134" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_134_134
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_134_134_i_1_n_0),
        .O(context_word0[134]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_134_134_i_1
       (.I0(next_mav0[19]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_134_134_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "135" *) 
  (* ram_slice_end = "135" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_135_135
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_135_135_i_1_n_0),
        .O(context_word0[135]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_135_135_i_1
       (.I0(next_mav0[20]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_135_135_i_1_n_0));
  LUT5 #(
    .INIT(32'h956A6A95)) 
    contexts_reg_0_7_135_135_i_10
       (.I0(contexts_reg_0_7_135_135_i_6_n_0),
        .I1(context_word1),
        .I2(context_word0[135]),
        .I3(contexts_reg_0_7_135_135_i_19_n_0),
        .I4(contexts_reg_0_7_135_135_i_26_n_0),
        .O(contexts_reg_0_7_135_135_i_10_n_0));
  (* SOFT_HLUTNM = "soft_lutpair45" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_135_135_i_11
       (.I0(next_mav4[99]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_135_135_i_11_n_0));
  (* SOFT_HLUTNM = "soft_lutpair205" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    contexts_reg_0_7_135_135_i_12
       (.I0(next_mav2[21]),
        .I1(sample_data[23]),
        .I2(sample_data[21]),
        .O(next_mav1[21]));
  LUT6 #(
    .INIT(64'h1D1DE21DE2E21DE2)) 
    contexts_reg_0_7_135_135_i_13
       (.I0(sample_data[22]),
        .I1(sample_data[23]),
        .I2(next_mav2[22]),
        .I3(next_mav4[100]),
        .I4(contexts_reg_0_7_115_115_i_18_n_0),
        .I5(contexts_reg_0_7_135_135_i_27_n_0),
        .O(contexts_reg_0_7_135_135_i_13_n_0));
  (* SOFT_HLUTNM = "soft_lutpair204" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    contexts_reg_0_7_135_135_i_14
       (.I0(next_mav2[20]),
        .I1(sample_data[23]),
        .I2(sample_data[20]),
        .O(next_mav1[20]));
  (* SOFT_HLUTNM = "soft_lutpair46" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_135_135_i_15
       (.I0(next_mav4[98]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_135_135_i_15_n_0));
  LUT6 #(
    .INIT(64'h1D1DE21DE2E21DE2)) 
    contexts_reg_0_7_135_135_i_16
       (.I0(sample_data[21]),
        .I1(sample_data[23]),
        .I2(next_mav2[21]),
        .I3(next_mav4[99]),
        .I4(contexts_reg_0_7_115_115_i_18_n_0),
        .I5(contexts_reg_0_7_135_135_i_28_n_0),
        .O(contexts_reg_0_7_135_135_i_16_n_0));
  (* SOFT_HLUTNM = "soft_lutpair204" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    contexts_reg_0_7_135_135_i_17
       (.I0(next_mav2[19]),
        .I1(sample_data[23]),
        .I2(sample_data[19]),
        .O(next_mav1[19]));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_135_135_i_18
       (.I0(next_mav4[97]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_135_135_i_18_n_0));
  LUT6 #(
    .INIT(64'h1D1DE21DE2E21DE2)) 
    contexts_reg_0_7_135_135_i_19
       (.I0(sample_data[20]),
        .I1(sample_data[23]),
        .I2(next_mav2[20]),
        .I3(next_mav4[98]),
        .I4(contexts_reg_0_7_115_115_i_18_n_0),
        .I5(contexts_reg_0_7_135_135_i_29_n_0),
        .O(contexts_reg_0_7_135_135_i_19_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 contexts_reg_0_7_135_135_i_2
       (.CI(contexts_reg_0_7_131_131_i_2_n_0),
        .CO({contexts_reg_0_7_135_135_i_2_n_0,contexts_reg_0_7_135_135_i_2_n_1,contexts_reg_0_7_135_135_i_2_n_2,contexts_reg_0_7_135_135_i_2_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_135_135_i_3_n_0,contexts_reg_0_7_135_135_i_4_n_0,contexts_reg_0_7_135_135_i_5_n_0,contexts_reg_0_7_135_135_i_6_n_0}),
        .O(next_mav0[23:20]),
        .S({contexts_reg_0_7_135_135_i_7_n_0,contexts_reg_0_7_135_135_i_8_n_0,contexts_reg_0_7_135_135_i_9_n_0,contexts_reg_0_7_135_135_i_10_n_0}));
  (* SOFT_HLUTNM = "soft_lutpair203" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    contexts_reg_0_7_135_135_i_20
       (.I0(next_mav2[18]),
        .I1(sample_data[23]),
        .I2(sample_data[18]),
        .O(next_mav1[18]));
  (* SOFT_HLUTNM = "soft_lutpair47" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_135_135_i_21
       (.I0(next_mav4[96]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_135_135_i_21_n_0));
  LUT6 #(
    .INIT(64'h7788878888887888)) 
    contexts_reg_0_7_135_135_i_22
       (.I0(next_mav2[23]),
        .I1(sample_data[23]),
        .I2(next_mav4[101]),
        .I3(context_word1),
        .I4(context_word0[16]),
        .I5(context_word0[258]),
        .O(contexts_reg_0_7_135_135_i_22_n_0));
  (* SOFT_HLUTNM = "soft_lutpair41" *) 
  LUT5 #(
    .INIT(32'h10007F5F)) 
    contexts_reg_0_7_135_135_i_23
       (.I0(context_word0[257]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[100]),
        .I4(next_mav1[22]),
        .O(contexts_reg_0_7_135_135_i_23_n_0));
  (* SOFT_HLUTNM = "soft_lutpair45" *) 
  LUT5 #(
    .INIT(32'hEFFF80A0)) 
    contexts_reg_0_7_135_135_i_24
       (.I0(context_word0[256]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[99]),
        .I4(next_mav1[21]),
        .O(contexts_reg_0_7_135_135_i_24_n_0));
  (* SOFT_HLUTNM = "soft_lutpair46" *) 
  LUT5 #(
    .INIT(32'hEFAA8AAA)) 
    contexts_reg_0_7_135_135_i_25
       (.I0(next_mav1[20]),
        .I1(context_word0[16]),
        .I2(next_mav4[98]),
        .I3(context_word1),
        .I4(context_word0[255]),
        .O(contexts_reg_0_7_135_135_i_25_n_0));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT5 #(
    .INIT(32'hEAEAA2EA)) 
    contexts_reg_0_7_135_135_i_26
       (.I0(next_mav1[19]),
        .I1(context_word1),
        .I2(context_word0[254]),
        .I3(next_mav4[97]),
        .I4(context_word0[16]),
        .O(contexts_reg_0_7_135_135_i_26_n_0));
  (* SOFT_HLUTNM = "soft_lutpair117" *) 
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_135_135_i_27
       (.I0(context_word1),
        .I1(context_word0[257]),
        .O(contexts_reg_0_7_135_135_i_27_n_0));
  (* SOFT_HLUTNM = "soft_lutpair120" *) 
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_135_135_i_28
       (.I0(context_word0[256]),
        .I1(context_word1),
        .O(contexts_reg_0_7_135_135_i_28_n_0));
  (* SOFT_HLUTNM = "soft_lutpair121" *) 
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_135_135_i_29
       (.I0(context_word0[255]),
        .I1(context_word1),
        .O(contexts_reg_0_7_135_135_i_29_n_0));
  LUT6 #(
    .INIT(64'h8A08EFAA0000CF08)) 
    contexts_reg_0_7_135_135_i_3
       (.I0(context_word1),
        .I1(context_word0[256]),
        .I2(contexts_reg_0_7_135_135_i_11_n_0),
        .I3(next_mav1[21]),
        .I4(contexts_reg_0_7_135_135_i_13_n_0),
        .I5(context_word0[137]),
        .O(contexts_reg_0_7_135_135_i_3_n_0));
  LUT6 #(
    .INIT(64'hB020FAF20000BA22)) 
    contexts_reg_0_7_135_135_i_4
       (.I0(next_mav1[20]),
        .I1(contexts_reg_0_7_135_135_i_15_n_0),
        .I2(context_word1),
        .I3(context_word0[255]),
        .I4(contexts_reg_0_7_135_135_i_16_n_0),
        .I5(context_word0[136]),
        .O(contexts_reg_0_7_135_135_i_4_n_0));
  LUT6 #(
    .INIT(64'h80C8ECEE0000A0EA)) 
    contexts_reg_0_7_135_135_i_5
       (.I0(next_mav1[19]),
        .I1(context_word1),
        .I2(context_word0[254]),
        .I3(contexts_reg_0_7_135_135_i_18_n_0),
        .I4(contexts_reg_0_7_135_135_i_19_n_0),
        .I5(context_word0[135]),
        .O(contexts_reg_0_7_135_135_i_5_n_0));
  LUT6 #(
    .INIT(64'hF8808080F8A8F880)) 
    contexts_reg_0_7_135_135_i_6
       (.I0(context_word1),
        .I1(context_word0[134]),
        .I2(contexts_reg_0_7_131_131_i_22_n_0),
        .I3(next_mav1[18]),
        .I4(context_word0[253]),
        .I5(contexts_reg_0_7_135_135_i_21_n_0),
        .O(contexts_reg_0_7_135_135_i_6_n_0));
  LUT5 #(
    .INIT(32'h6A95956A)) 
    contexts_reg_0_7_135_135_i_7
       (.I0(contexts_reg_0_7_135_135_i_3_n_0),
        .I1(context_word1),
        .I2(context_word0[138]),
        .I3(contexts_reg_0_7_135_135_i_22_n_0),
        .I4(contexts_reg_0_7_135_135_i_23_n_0),
        .O(contexts_reg_0_7_135_135_i_7_n_0));
  LUT5 #(
    .INIT(32'h96666999)) 
    contexts_reg_0_7_135_135_i_8
       (.I0(contexts_reg_0_7_135_135_i_4_n_0),
        .I1(contexts_reg_0_7_135_135_i_24_n_0),
        .I2(context_word1),
        .I3(context_word0[137]),
        .I4(contexts_reg_0_7_135_135_i_13_n_0),
        .O(contexts_reg_0_7_135_135_i_8_n_0));
  LUT5 #(
    .INIT(32'h96666999)) 
    contexts_reg_0_7_135_135_i_9
       (.I0(contexts_reg_0_7_135_135_i_5_n_0),
        .I1(contexts_reg_0_7_135_135_i_25_n_0),
        .I2(context_word1),
        .I3(context_word0[136]),
        .I4(contexts_reg_0_7_135_135_i_16_n_0),
        .O(contexts_reg_0_7_135_135_i_9_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "136" *) 
  (* ram_slice_end = "136" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_136_136
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_136_136_i_1_n_0),
        .O(context_word0[136]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_136_136_i_1
       (.I0(next_mav0[21]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_136_136_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "137" *) 
  (* ram_slice_end = "137" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_137_137
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_137_137_i_1_n_0),
        .O(context_word0[137]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_137_137_i_1
       (.I0(next_mav0[22]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_137_137_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "138" *) 
  (* ram_slice_end = "138" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_138_138
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_138_138_i_1_n_0),
        .O(context_word0[138]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_138_138_i_1
       (.I0(next_mav0[23]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_138_138_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "139" *) 
  (* ram_slice_end = "139" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_139_139
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_139_139_i_1_n_0),
        .O(context_word0[139]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_139_139_i_1
       (.I0(next_mav0[24]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_139_139_i_1_n_0));
  LUT6 #(
    .INIT(64'h9669699669966996)) 
    contexts_reg_0_7_139_139_i_10
       (.I0(contexts_reg_0_7_139_139_i_6_n_0),
        .I1(contexts_reg_0_7_139_139_i_13_n_0),
        .I2(contexts_reg_0_7_139_139_i_14_n_0),
        .I3(next_mav1[24]),
        .I4(context_word1),
        .I5(context_word0[139]),
        .O(contexts_reg_0_7_139_139_i_10_n_0));
  LUT6 #(
    .INIT(64'h9F9F5F9F6060A060)) 
    contexts_reg_0_7_139_139_i_11
       (.I0(context_word0[140]),
        .I1(context_word0[139]),
        .I2(context_word1),
        .I3(sample_data[23]),
        .I4(history_reg_0_31_98_98_i_10_n_0),
        .I5(contexts_reg_0_7_139_139_i_19_n_0),
        .O(contexts_reg_0_7_139_139_i_11_n_0));
  LUT6 #(
    .INIT(64'hFB0404FB00FF00FF)) 
    contexts_reg_0_7_139_139_i_12
       (.I0(context_word0[16]),
        .I1(next_mav4[103]),
        .I2(context_word0[260]),
        .I3(contexts_reg_0_7_139_139_i_21_n_0),
        .I4(context_word0[141]),
        .I5(context_word1),
        .O(contexts_reg_0_7_139_139_i_12_n_0));
  LUT6 #(
    .INIT(64'h004073FF73FF73FF)) 
    contexts_reg_0_7_139_139_i_13
       (.I0(context_word0[16]),
        .I1(context_word1),
        .I2(next_mav4[101]),
        .I3(context_word0[258]),
        .I4(sample_data[23]),
        .I5(next_mav2[23]),
        .O(contexts_reg_0_7_139_139_i_13_n_0));
  (* SOFT_HLUTNM = "soft_lutpair108" *) 
  LUT4 #(
    .INIT(16'h90A0)) 
    contexts_reg_0_7_139_139_i_14
       (.I0(context_word0[259]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[102]),
        .O(contexts_reg_0_7_139_139_i_14_n_0));
  (* SOFT_HLUTNM = "soft_lutpair41" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_139_139_i_15
       (.I0(next_mav4[100]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_139_139_i_15_n_0));
  (* SOFT_HLUTNM = "soft_lutpair205" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    contexts_reg_0_7_139_139_i_16
       (.I0(next_mav2[22]),
        .I1(sample_data[23]),
        .I2(sample_data[22]),
        .O(next_mav1[22]));
  LUT6 #(
    .INIT(64'h04FBFB04FF00FF00)) 
    contexts_reg_0_7_139_139_i_17
       (.I0(context_word0[261]),
        .I1(next_mav4[104]),
        .I2(context_word0[16]),
        .I3(contexts_reg_0_7_139_139_i_22_n_0),
        .I4(context_word0[142]),
        .I5(context_word1),
        .O(contexts_reg_0_7_139_139_i_17_n_0));
  LUT6 #(
    .INIT(64'h8F8F8F8F8F0D8F8F)) 
    contexts_reg_0_7_139_139_i_18
       (.I0(context_word1),
        .I1(context_word0[141]),
        .I2(contexts_reg_0_7_139_139_i_21_n_0),
        .I3(context_word0[260]),
        .I4(next_mav4[103]),
        .I5(context_word0[16]),
        .O(contexts_reg_0_7_139_139_i_18_n_0));
  (* SOFT_HLUTNM = "soft_lutpair102" *) 
  LUT4 #(
    .INIT(16'h59FF)) 
    contexts_reg_0_7_139_139_i_19
       (.I0(context_word0[260]),
        .I1(next_mav4[103]),
        .I2(context_word0[16]),
        .I3(context_word1),
        .O(contexts_reg_0_7_139_139_i_19_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 contexts_reg_0_7_139_139_i_2
       (.CI(contexts_reg_0_7_135_135_i_2_n_0),
        .CO({contexts_reg_0_7_139_139_i_2_n_0,contexts_reg_0_7_139_139_i_2_n_1,contexts_reg_0_7_139_139_i_2_n_2,contexts_reg_0_7_139_139_i_2_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_139_139_i_3_n_0,contexts_reg_0_7_139_139_i_4_n_0,contexts_reg_0_7_139_139_i_5_n_0,contexts_reg_0_7_139_139_i_6_n_0}),
        .O(next_mav0[27:24]),
        .S({contexts_reg_0_7_139_139_i_7_n_0,contexts_reg_0_7_139_139_i_8_n_0,contexts_reg_0_7_139_139_i_9_n_0,contexts_reg_0_7_139_139_i_10_n_0}));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_139_139_i_20
       (.I0(sample_data[23]),
        .I1(history_reg_0_31_98_98_i_10_n_0),
        .O(next_mav1[24]));
  (* SOFT_HLUTNM = "soft_lutpair107" *) 
  LUT4 #(
    .INIT(16'h6F5F)) 
    contexts_reg_0_7_139_139_i_21
       (.I0(context_word0[261]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[104]),
        .O(contexts_reg_0_7_139_139_i_21_n_0));
  (* SOFT_HLUTNM = "soft_lutpair106" *) 
  LUT4 #(
    .INIT(16'h6F5F)) 
    contexts_reg_0_7_139_139_i_22
       (.I0(context_word0[262]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[105]),
        .O(contexts_reg_0_7_139_139_i_22_n_0));
  LUT6 #(
    .INIT(64'h0000000055554555)) 
    contexts_reg_0_7_139_139_i_3
       (.I0(contexts_reg_0_7_139_139_i_11_n_0),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[102]),
        .I4(context_word0[259]),
        .I5(contexts_reg_0_7_139_139_i_12_n_0),
        .O(contexts_reg_0_7_139_139_i_3_n_0));
  LUT6 #(
    .INIT(64'h55554555AAAABAAA)) 
    contexts_reg_0_7_139_139_i_4
       (.I0(contexts_reg_0_7_139_139_i_11_n_0),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[102]),
        .I4(context_word0[259]),
        .I5(contexts_reg_0_7_139_139_i_12_n_0),
        .O(contexts_reg_0_7_139_139_i_4_n_0));
  LUT6 #(
    .INIT(64'h7F7FD57F15154015)) 
    contexts_reg_0_7_139_139_i_5
       (.I0(contexts_reg_0_7_139_139_i_13_n_0),
        .I1(context_word0[139]),
        .I2(context_word1),
        .I3(sample_data[23]),
        .I4(history_reg_0_31_98_98_i_10_n_0),
        .I5(contexts_reg_0_7_139_139_i_14_n_0),
        .O(contexts_reg_0_7_139_139_i_5_n_0));
  LUT6 #(
    .INIT(64'hB2000000FFB2B0B0)) 
    contexts_reg_0_7_139_139_i_6
       (.I0(context_word0[257]),
        .I1(contexts_reg_0_7_139_139_i_15_n_0),
        .I2(next_mav1[22]),
        .I3(context_word0[138]),
        .I4(context_word1),
        .I5(contexts_reg_0_7_135_135_i_22_n_0),
        .O(contexts_reg_0_7_139_139_i_6_n_0));
  (* HLUTNM = "lutpair4" *) 
  LUT3 #(
    .INIT(8'h96)) 
    contexts_reg_0_7_139_139_i_7
       (.I0(contexts_reg_0_7_139_139_i_17_n_0),
        .I1(contexts_reg_0_7_139_139_i_18_n_0),
        .I2(contexts_reg_0_7_139_139_i_3_n_0),
        .O(contexts_reg_0_7_139_139_i_7_n_0));
  LUT6 #(
    .INIT(64'h9599AAAAA9AAAAAA)) 
    contexts_reg_0_7_139_139_i_8
       (.I0(contexts_reg_0_7_139_139_i_4_n_0),
        .I1(contexts_reg_0_7_139_139_i_19_n_0),
        .I2(next_mav1[24]),
        .I3(context_word0[139]),
        .I4(context_word1),
        .I5(context_word0[140]),
        .O(contexts_reg_0_7_139_139_i_8_n_0));
  LUT6 #(
    .INIT(64'h6666666669666666)) 
    contexts_reg_0_7_139_139_i_9
       (.I0(contexts_reg_0_7_139_139_i_5_n_0),
        .I1(contexts_reg_0_7_139_139_i_11_n_0),
        .I2(context_word0[16]),
        .I3(context_word1),
        .I4(next_mav4[102]),
        .I5(context_word0[259]),
        .O(contexts_reg_0_7_139_139_i_9_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "13" *) 
  (* ram_slice_end = "13" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_13_13
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_13_13_i_1_n_0),
        .O(context_word0[13]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_7_7_i_2_n_0));
  LUT6 #(
    .INIT(64'hA020A0A000800000)) 
    contexts_reg_0_7_13_13_i_1
       (.I0(context_word0[16]),
        .I1(context_word0[11]),
        .I2(context_word1),
        .I3(contexts_reg_0_7_12_12_i_2_n_0),
        .I4(context_word0[12]),
        .I5(context_word0[13]),
        .O(contexts_reg_0_7_13_13_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "140" *) 
  (* ram_slice_end = "140" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_140_140
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_140_140_i_1_n_0),
        .O(context_word0[140]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_140_140_i_1
       (.I0(next_mav0[25]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_140_140_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "141" *) 
  (* ram_slice_end = "141" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_141_141
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_141_141_i_1_n_0),
        .O(context_word0[141]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_141_141_i_1
       (.I0(next_mav0[26]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_141_141_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "142" *) 
  (* ram_slice_end = "142" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_142_142
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_142_142_i_1_n_0),
        .O(context_word0[142]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_142_142_i_1
       (.I0(next_mav0[27]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_142_142_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "143" *) 
  (* ram_slice_end = "143" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_143_143
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_143_143_i_1_n_0),
        .O(context_word0[143]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_143_143_i_1
       (.I0(next_mav0[28]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_143_143_i_1_n_0));
  (* HLUTNM = "lutpair5" *) 
  LUT3 #(
    .INIT(8'h96)) 
    contexts_reg_0_7_143_143_i_10
       (.I0(contexts_reg_0_7_143_143_i_15_n_0),
        .I1(contexts_reg_0_7_143_143_i_16_n_0),
        .I2(contexts_reg_0_7_143_143_i_6_n_0),
        .O(contexts_reg_0_7_143_143_i_10_n_0));
  LUT6 #(
    .INIT(64'hFB00040004FFFBFF)) 
    contexts_reg_0_7_143_143_i_11
       (.I0(context_word0[16]),
        .I1(next_mav4[107]),
        .I2(context_word0[264]),
        .I3(context_word1),
        .I4(context_word0[145]),
        .I5(contexts_reg_0_7_143_143_i_19_n_0),
        .O(contexts_reg_0_7_143_143_i_11_n_0));
  LUT6 #(
    .INIT(64'h707070F270707070)) 
    contexts_reg_0_7_143_143_i_12
       (.I0(context_word1),
        .I1(context_word0[144]),
        .I2(contexts_reg_0_7_143_143_i_20_n_0),
        .I3(context_word0[263]),
        .I4(context_word0[16]),
        .I5(next_mav4[106]),
        .O(contexts_reg_0_7_143_143_i_12_n_0));
  LUT6 #(
    .INIT(64'h02FDFD02FF00FF00)) 
    contexts_reg_0_7_143_143_i_13
       (.I0(next_mav4[106]),
        .I1(context_word0[16]),
        .I2(context_word0[263]),
        .I3(contexts_reg_0_7_143_143_i_20_n_0),
        .I4(context_word0[144]),
        .I5(context_word1),
        .O(contexts_reg_0_7_143_143_i_13_n_0));
  LUT6 #(
    .INIT(64'h8F8F8F8F8F0D8F8F)) 
    contexts_reg_0_7_143_143_i_14
       (.I0(context_word1),
        .I1(context_word0[143]),
        .I2(contexts_reg_0_7_143_143_i_21_n_0),
        .I3(context_word0[16]),
        .I4(next_mav4[105]),
        .I5(context_word0[262]),
        .O(contexts_reg_0_7_143_143_i_14_n_0));
  LUT6 #(
    .INIT(64'h04FBFB04FF00FF00)) 
    contexts_reg_0_7_143_143_i_15
       (.I0(context_word0[262]),
        .I1(next_mav4[105]),
        .I2(context_word0[16]),
        .I3(contexts_reg_0_7_143_143_i_21_n_0),
        .I4(context_word0[143]),
        .I5(context_word1),
        .O(contexts_reg_0_7_143_143_i_15_n_0));
  LUT6 #(
    .INIT(64'h8F8F8F8F8F0D8F8F)) 
    contexts_reg_0_7_143_143_i_16
       (.I0(context_word1),
        .I1(context_word0[142]),
        .I2(contexts_reg_0_7_139_139_i_22_n_0),
        .I3(context_word0[16]),
        .I4(next_mav4[104]),
        .I5(context_word0[261]),
        .O(contexts_reg_0_7_143_143_i_16_n_0));
  LUT6 #(
    .INIT(64'h7070707070F27070)) 
    contexts_reg_0_7_143_143_i_17
       (.I0(context_word1),
        .I1(context_word0[145]),
        .I2(contexts_reg_0_7_143_143_i_19_n_0),
        .I3(context_word0[264]),
        .I4(next_mav4[107]),
        .I5(context_word0[16]),
        .O(contexts_reg_0_7_143_143_i_17_n_0));
  LUT6 #(
    .INIT(64'hFB0404FB00FF00FF)) 
    contexts_reg_0_7_143_143_i_18
       (.I0(context_word0[16]),
        .I1(next_mav4[108]),
        .I2(context_word0[265]),
        .I3(contexts_reg_0_7_143_143_i_22_n_0),
        .I4(context_word0[146]),
        .I5(context_word1),
        .O(contexts_reg_0_7_143_143_i_18_n_0));
  (* SOFT_HLUTNM = "soft_lutpair103" *) 
  LUT4 #(
    .INIT(16'h59FF)) 
    contexts_reg_0_7_143_143_i_19
       (.I0(context_word0[265]),
        .I1(next_mav4[108]),
        .I2(context_word0[16]),
        .I3(context_word1),
        .O(contexts_reg_0_7_143_143_i_19_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 contexts_reg_0_7_143_143_i_2
       (.CI(contexts_reg_0_7_139_139_i_2_n_0),
        .CO({contexts_reg_0_7_143_143_i_2_n_0,contexts_reg_0_7_143_143_i_2_n_1,contexts_reg_0_7_143_143_i_2_n_2,contexts_reg_0_7_143_143_i_2_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_143_143_i_3_n_0,contexts_reg_0_7_143_143_i_4_n_0,contexts_reg_0_7_143_143_i_5_n_0,contexts_reg_0_7_143_143_i_6_n_0}),
        .O(next_mav0[31:28]),
        .S({contexts_reg_0_7_143_143_i_7_n_0,contexts_reg_0_7_143_143_i_8_n_0,contexts_reg_0_7_143_143_i_9_n_0,contexts_reg_0_7_143_143_i_10_n_0}));
  (* SOFT_HLUTNM = "soft_lutpair104" *) 
  LUT4 #(
    .INIT(16'h59FF)) 
    contexts_reg_0_7_143_143_i_20
       (.I0(context_word0[264]),
        .I1(next_mav4[107]),
        .I2(context_word0[16]),
        .I3(context_word1),
        .O(contexts_reg_0_7_143_143_i_20_n_0));
  (* SOFT_HLUTNM = "soft_lutpair105" *) 
  LUT4 #(
    .INIT(16'h6F5F)) 
    contexts_reg_0_7_143_143_i_21
       (.I0(context_word0[263]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[106]),
        .O(contexts_reg_0_7_143_143_i_21_n_0));
  (* SOFT_HLUTNM = "soft_lutpair98" *) 
  LUT4 #(
    .INIT(16'h59FF)) 
    contexts_reg_0_7_143_143_i_22
       (.I0(context_word0[266]),
        .I1(next_mav4[109]),
        .I2(context_word0[16]),
        .I3(context_word1),
        .O(contexts_reg_0_7_143_143_i_22_n_0));
  (* HLUTNM = "lutpair7" *) 
  LUT2 #(
    .INIT(4'h1)) 
    contexts_reg_0_7_143_143_i_3
       (.I0(contexts_reg_0_7_143_143_i_11_n_0),
        .I1(contexts_reg_0_7_143_143_i_12_n_0),
        .O(contexts_reg_0_7_143_143_i_3_n_0));
  (* HLUTNM = "lutpair6" *) 
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_143_143_i_4
       (.I0(contexts_reg_0_7_143_143_i_13_n_0),
        .I1(contexts_reg_0_7_143_143_i_14_n_0),
        .O(contexts_reg_0_7_143_143_i_4_n_0));
  (* HLUTNM = "lutpair5" *) 
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_143_143_i_5
       (.I0(contexts_reg_0_7_143_143_i_15_n_0),
        .I1(contexts_reg_0_7_143_143_i_16_n_0),
        .O(contexts_reg_0_7_143_143_i_5_n_0));
  (* HLUTNM = "lutpair4" *) 
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_143_143_i_6
       (.I0(contexts_reg_0_7_139_139_i_17_n_0),
        .I1(contexts_reg_0_7_139_139_i_18_n_0),
        .O(contexts_reg_0_7_143_143_i_6_n_0));
  LUT3 #(
    .INIT(8'h96)) 
    contexts_reg_0_7_143_143_i_7
       (.I0(contexts_reg_0_7_143_143_i_3_n_0),
        .I1(contexts_reg_0_7_143_143_i_17_n_0),
        .I2(contexts_reg_0_7_143_143_i_18_n_0),
        .O(contexts_reg_0_7_143_143_i_7_n_0));
  (* HLUTNM = "lutpair7" *) 
  LUT3 #(
    .INIT(8'h96)) 
    contexts_reg_0_7_143_143_i_8
       (.I0(contexts_reg_0_7_143_143_i_11_n_0),
        .I1(contexts_reg_0_7_143_143_i_12_n_0),
        .I2(contexts_reg_0_7_143_143_i_4_n_0),
        .O(contexts_reg_0_7_143_143_i_8_n_0));
  (* HLUTNM = "lutpair6" *) 
  LUT3 #(
    .INIT(8'h96)) 
    contexts_reg_0_7_143_143_i_9
       (.I0(contexts_reg_0_7_143_143_i_13_n_0),
        .I1(contexts_reg_0_7_143_143_i_14_n_0),
        .I2(contexts_reg_0_7_143_143_i_5_n_0),
        .O(contexts_reg_0_7_143_143_i_9_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "144" *) 
  (* ram_slice_end = "144" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_144_144
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_144_144_i_1_n_0),
        .O(context_word0[144]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_144_144_i_1
       (.I0(next_mav0[29]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_144_144_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "145" *) 
  (* ram_slice_end = "145" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_145_145
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_145_145_i_1_n_0),
        .O(context_word0[145]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_145_145_i_1
       (.I0(next_mav0[30]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_145_145_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "146" *) 
  (* ram_slice_end = "146" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_146_146
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_146_146_i_1_n_0),
        .O(context_word0[146]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_146_146_i_1
       (.I0(next_mav0[31]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_146_146_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "147" *) 
  (* ram_slice_end = "147" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_147_147
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_147_147_i_1_n_0),
        .O(context_word0[147]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_147_147_i_1
       (.I0(next_mav0[32]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_147_147_i_1_n_0));
  LUT6 #(
    .INIT(64'h1EE1E11EE11EE11E)) 
    contexts_reg_0_7_147_147_i_10
       (.I0(contexts_reg_0_7_143_143_i_18_n_0),
        .I1(contexts_reg_0_7_143_143_i_17_n_0),
        .I2(contexts_reg_0_7_147_147_i_11_n_0),
        .I3(contexts_reg_0_7_147_147_i_12_n_0),
        .I4(context_word0[147]),
        .I5(context_word1),
        .O(contexts_reg_0_7_147_147_i_10_n_0));
  LUT6 #(
    .INIT(64'h8F8F8F8F8F0D8F8F)) 
    contexts_reg_0_7_147_147_i_11
       (.I0(context_word1),
        .I1(context_word0[146]),
        .I2(contexts_reg_0_7_143_143_i_22_n_0),
        .I3(context_word0[265]),
        .I4(next_mav4[108]),
        .I5(context_word0[16]),
        .O(contexts_reg_0_7_147_147_i_11_n_0));
  (* SOFT_HLUTNM = "soft_lutpair98" *) 
  LUT4 #(
    .INIT(16'h0400)) 
    contexts_reg_0_7_147_147_i_12
       (.I0(context_word0[266]),
        .I1(next_mav4[109]),
        .I2(context_word0[16]),
        .I3(context_word1),
        .O(contexts_reg_0_7_147_147_i_12_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 contexts_reg_0_7_147_147_i_2
       (.CI(contexts_reg_0_7_143_143_i_2_n_0),
        .CO({contexts_reg_0_7_147_147_i_2_n_0,contexts_reg_0_7_147_147_i_2_n_1,contexts_reg_0_7_147_147_i_2_n_2,contexts_reg_0_7_147_147_i_2_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_147_147_i_3_n_0,contexts_reg_0_7_147_147_i_4_n_0,contexts_reg_0_7_147_147_i_5_n_0,contexts_reg_0_7_147_147_i_6_n_0}),
        .O(next_mav0[35:32]),
        .S({contexts_reg_0_7_147_147_i_7_n_0,contexts_reg_0_7_147_147_i_8_n_0,contexts_reg_0_7_147_147_i_9_n_0,contexts_reg_0_7_147_147_i_10_n_0}));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_147_147_i_3
       (.I0(context_word0[149]),
        .I1(context_word1),
        .O(contexts_reg_0_7_147_147_i_3_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_147_147_i_4
       (.I0(context_word0[148]),
        .I1(context_word1),
        .O(contexts_reg_0_7_147_147_i_4_n_0));
  LUT6 #(
    .INIT(64'hFFEFAAAAAA8AAAAA)) 
    contexts_reg_0_7_147_147_i_5
       (.I0(contexts_reg_0_7_147_147_i_11_n_0),
        .I1(context_word0[16]),
        .I2(next_mav4[109]),
        .I3(context_word0[266]),
        .I4(context_word1),
        .I5(context_word0[147]),
        .O(contexts_reg_0_7_147_147_i_5_n_0));
  LUT2 #(
    .INIT(4'h1)) 
    contexts_reg_0_7_147_147_i_6
       (.I0(contexts_reg_0_7_143_143_i_18_n_0),
        .I1(contexts_reg_0_7_143_143_i_17_n_0),
        .O(contexts_reg_0_7_147_147_i_6_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_147_147_i_7
       (.I0(context_word0[149]),
        .I1(context_word1),
        .I2(context_word0[150]),
        .O(contexts_reg_0_7_147_147_i_7_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_147_147_i_8
       (.I0(context_word0[148]),
        .I1(context_word1),
        .I2(context_word0[149]),
        .O(contexts_reg_0_7_147_147_i_8_n_0));
  LUT3 #(
    .INIT(8'h95)) 
    contexts_reg_0_7_147_147_i_9
       (.I0(contexts_reg_0_7_147_147_i_5_n_0),
        .I1(context_word1),
        .I2(context_word0[148]),
        .O(contexts_reg_0_7_147_147_i_9_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "148" *) 
  (* ram_slice_end = "148" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_148_148
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_148_148_i_1_n_0),
        .O(context_word0[148]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_148_148_i_1
       (.I0(next_mav0[33]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_148_148_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "149" *) 
  (* ram_slice_end = "149" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_149_149
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_149_149_i_1_n_0),
        .O(context_word0[149]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_149_149_i_1
       (.I0(next_mav0[34]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_149_149_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "14" *) 
  (* ram_slice_end = "14" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_14_14
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_14_14_i_1_n_0),
        .O(context_word0[14]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_7_7_i_2_n_0));
  LUT6 #(
    .INIT(64'h00000000A060A0A0)) 
    contexts_reg_0_7_14_14_i_1
       (.I0(context_word0[14]),
        .I1(context_word0[13]),
        .I2(context_word1),
        .I3(contexts_reg_0_7_14_14_i_2_n_0),
        .I4(context_word0[12]),
        .I5(contexts_reg_0_7_7_7_i_3_n_0),
        .O(contexts_reg_0_7_14_14_i_1_n_0));
  LUT6 #(
    .INIT(64'h7FFFFFFFFFFFFFFF)) 
    contexts_reg_0_7_14_14_i_2
       (.I0(context_word0[10]),
        .I1(context_word0[8]),
        .I2(context_word0[7]),
        .I3(context_word0[9]),
        .I4(context_word1),
        .I5(context_word0[11]),
        .O(contexts_reg_0_7_14_14_i_2_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "150" *) 
  (* ram_slice_end = "150" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_150_150
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_150_150_i_1_n_0),
        .O(context_word0[150]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_150_150_i_1
       (.I0(next_mav0[35]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_150_150_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "151" *) 
  (* ram_slice_end = "151" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_151_151
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_151_151_i_1_n_0),
        .O(context_word0[151]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_151_151_i_1
       (.I0(next_mav0[36]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_151_151_i_1_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 contexts_reg_0_7_151_151_i_2
       (.CI(contexts_reg_0_7_147_147_i_2_n_0),
        .CO({NLW_contexts_reg_0_7_151_151_i_2_CO_UNCONNECTED[3],contexts_reg_0_7_151_151_i_2_n_1,contexts_reg_0_7_151_151_i_2_n_2,contexts_reg_0_7_151_151_i_2_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,contexts_reg_0_7_151_151_i_3_n_0,contexts_reg_0_7_151_151_i_4_n_0,contexts_reg_0_7_151_151_i_5_n_0}),
        .O(next_mav0[39:36]),
        .S({contexts_reg_0_7_151_151_i_6_n_0,contexts_reg_0_7_151_151_i_7_n_0,contexts_reg_0_7_151_151_i_8_n_0,contexts_reg_0_7_151_151_i_9_n_0}));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_151_151_i_3
       (.I0(context_word0[152]),
        .I1(context_word1),
        .O(contexts_reg_0_7_151_151_i_3_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_151_151_i_4
       (.I0(context_word0[151]),
        .I1(context_word1),
        .O(contexts_reg_0_7_151_151_i_4_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_151_151_i_5
       (.I0(context_word0[150]),
        .I1(context_word1),
        .O(contexts_reg_0_7_151_151_i_5_n_0));
  LUT3 #(
    .INIT(8'hD7)) 
    contexts_reg_0_7_151_151_i_6
       (.I0(context_word1),
        .I1(context_word0[154]),
        .I2(context_word0[153]),
        .O(contexts_reg_0_7_151_151_i_6_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_151_151_i_7
       (.I0(context_word0[152]),
        .I1(context_word1),
        .I2(context_word0[153]),
        .O(contexts_reg_0_7_151_151_i_7_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_151_151_i_8
       (.I0(context_word0[151]),
        .I1(context_word1),
        .I2(context_word0[152]),
        .O(contexts_reg_0_7_151_151_i_8_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_151_151_i_9
       (.I0(context_word0[150]),
        .I1(context_word1),
        .I2(context_word0[151]),
        .O(contexts_reg_0_7_151_151_i_9_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "152" *) 
  (* ram_slice_end = "152" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_152_152
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_152_152_i_1_n_0),
        .O(context_word0[152]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_152_152_i_1
       (.I0(next_mav0[37]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_152_152_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "153" *) 
  (* ram_slice_end = "153" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_153_153
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_153_153_i_1_n_0),
        .O(context_word0[153]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_153_153_i_1
       (.I0(next_mav0[38]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_153_153_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "154" *) 
  (* ram_slice_end = "154" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_154_154
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_154_154_i_1_n_0),
        .O(context_word0[154]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_154_154_i_1
       (.I0(next_mav0[39]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_154_154_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "155" *) 
  (* ram_slice_end = "155" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_155_155
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(wr_ptr[0]),
        .O(context_word0[155]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT3 #(
    .INIT(8'h15)) 
    contexts_reg_0_7_155_155_i_1
       (.I0(contexts_reg_0_7_17_17_i_3_n_0),
        .I1(context_word1),
        .I2(context_word0[155]),
        .O(wr_ptr[0]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "156" *) 
  (* ram_slice_end = "156" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_156_156
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(wr_ptr[1]),
        .O(context_word0[156]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT4 #(
    .INIT(16'h0048)) 
    contexts_reg_0_7_156_156_i_1
       (.I0(context_word0[155]),
        .I1(context_word1),
        .I2(context_word0[156]),
        .I3(contexts_reg_0_7_17_17_i_3_n_0),
        .O(wr_ptr[1]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "157" *) 
  (* ram_slice_end = "157" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_157_157
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_ssc[0]),
        .O(context_word0[157]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT4 #(
    .INIT(16'h802A)) 
    contexts_reg_0_7_157_157_i_1
       (.I0(contexts_reg_0_7_157_157_i_3_n_0),
        .I1(context_word1),
        .I2(context_word0[157]),
        .I3(contexts_reg_0_7_157_157_i_4_n_0),
        .O(seg_ssc[0]));
  LUT2 #(
    .INIT(4'hB)) 
    contexts_reg_0_7_157_157_i_10
       (.I0(contexts_reg_0_7_157_157_i_5_n_3),
        .I1(ssc_event4[24]),
        .O(contexts_reg_0_7_157_157_i_10_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_157_157_i_100
       (.I0(context_word0[306]),
        .I1(context_word1),
        .O(contexts_reg_0_7_157_157_i_100_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_157_157_i_101
       (.I0(context_word0[305]),
        .I1(context_word1),
        .O(contexts_reg_0_7_157_157_i_101_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_157_157_i_102
       (.I0(context_word0[304]),
        .I1(context_word1),
        .O(contexts_reg_0_7_157_157_i_102_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_157_157_i_103
       (.I0(context_word0[307]),
        .I1(context_word1),
        .I2(context_word0[283]),
        .O(contexts_reg_0_7_157_157_i_103_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_157_157_i_104
       (.I0(context_word0[306]),
        .I1(context_word1),
        .I2(context_word0[282]),
        .O(contexts_reg_0_7_157_157_i_104_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_157_157_i_105
       (.I0(context_word0[305]),
        .I1(context_word1),
        .I2(context_word0[281]),
        .O(contexts_reg_0_7_157_157_i_105_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_157_157_i_106
       (.I0(context_word0[304]),
        .I1(context_word1),
        .I2(context_word0[280]),
        .O(contexts_reg_0_7_157_157_i_106_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    contexts_reg_0_7_157_157_i_107
       (.I0(contexts_reg_0_7_157_157_i_90_n_7),
        .O(contexts_reg_0_7_157_157_i_107_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    contexts_reg_0_7_157_157_i_108
       (.I0(contexts_reg_0_7_157_157_i_80_n_7),
        .O(contexts_reg_0_7_157_157_i_108_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    contexts_reg_0_7_157_157_i_109
       (.I0(contexts_reg_0_7_157_157_i_90_n_4),
        .O(contexts_reg_0_7_157_157_i_109_n_0));
  CARRY4 contexts_reg_0_7_157_157_i_11
       (.CI(contexts_reg_0_7_157_157_i_30_n_0),
        .CO({contexts_reg_0_7_157_157_i_11_n_0,contexts_reg_0_7_157_157_i_11_n_1,contexts_reg_0_7_157_157_i_11_n_2,contexts_reg_0_7_157_157_i_11_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_157_157_i_31_n_0,contexts_reg_0_7_157_157_i_32_n_0,contexts_reg_0_7_157_157_i_33_n_0,contexts_reg_0_7_157_157_i_34_n_0}),
        .O({contexts_reg_0_7_157_157_i_11_n_4,contexts_reg_0_7_157_157_i_11_n_5,contexts_reg_0_7_157_157_i_11_n_6,contexts_reg_0_7_157_157_i_11_n_7}),
        .S({contexts_reg_0_7_157_157_i_35_n_0,contexts_reg_0_7_157_157_i_36_n_0,contexts_reg_0_7_157_157_i_37_n_0,contexts_reg_0_7_157_157_i_38_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    contexts_reg_0_7_157_157_i_110
       (.I0(contexts_reg_0_7_157_157_i_90_n_5),
        .O(contexts_reg_0_7_157_157_i_110_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    contexts_reg_0_7_157_157_i_111
       (.I0(contexts_reg_0_7_157_157_i_90_n_6),
        .O(contexts_reg_0_7_157_157_i_111_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_157_157_i_112
       (.I0(context_word0[303]),
        .I1(context_word1),
        .O(contexts_reg_0_7_157_157_i_112_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_157_157_i_113
       (.I0(context_word0[302]),
        .I1(context_word1),
        .O(contexts_reg_0_7_157_157_i_113_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_157_157_i_114
       (.I0(context_word0[301]),
        .I1(context_word1),
        .O(contexts_reg_0_7_157_157_i_114_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_157_157_i_115
       (.I0(context_word0[300]),
        .I1(context_word1),
        .O(contexts_reg_0_7_157_157_i_115_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_157_157_i_116
       (.I0(context_word0[303]),
        .I1(context_word1),
        .I2(context_word0[279]),
        .O(contexts_reg_0_7_157_157_i_116_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_157_157_i_117
       (.I0(context_word0[302]),
        .I1(context_word1),
        .I2(context_word0[278]),
        .O(contexts_reg_0_7_157_157_i_117_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_157_157_i_118
       (.I0(context_word0[301]),
        .I1(context_word1),
        .I2(context_word0[277]),
        .O(contexts_reg_0_7_157_157_i_118_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_157_157_i_119
       (.I0(context_word0[300]),
        .I1(context_word1),
        .I2(context_word0[276]),
        .O(contexts_reg_0_7_157_157_i_119_n_0));
  LUT2 #(
    .INIT(4'h7)) 
    contexts_reg_0_7_157_157_i_12
       (.I0(context_word1),
        .I1(context_word0[323]),
        .O(contexts_reg_0_7_157_157_i_12_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_157_157_i_13
       (.I0(context_word0[322]),
        .I1(context_word1),
        .O(contexts_reg_0_7_157_157_i_13_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_157_157_i_14
       (.I0(context_word0[321]),
        .I1(context_word1),
        .O(contexts_reg_0_7_157_157_i_14_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_157_157_i_15
       (.I0(context_word0[320]),
        .I1(context_word1),
        .O(contexts_reg_0_7_157_157_i_15_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_157_157_i_16
       (.I0(context_word0[323]),
        .I1(context_word1),
        .I2(context_word0[299]),
        .O(contexts_reg_0_7_157_157_i_16_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_157_157_i_17
       (.I0(context_word0[322]),
        .I1(context_word1),
        .I2(context_word0[298]),
        .O(contexts_reg_0_7_157_157_i_17_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_157_157_i_18
       (.I0(context_word0[321]),
        .I1(context_word1),
        .I2(context_word0[297]),
        .O(contexts_reg_0_7_157_157_i_18_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_157_157_i_19
       (.I0(context_word0[320]),
        .I1(context_word1),
        .I2(context_word0[296]),
        .O(contexts_reg_0_7_157_157_i_19_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_157_157_i_2
       (.I0(rst_n),
        .I1(sample_valid),
        .O(p_3_out));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 contexts_reg_0_7_157_157_i_20
       (.CI(contexts_reg_0_7_157_157_i_39_n_0),
        .CO({contexts_reg_0_7_157_157_i_20_n_0,contexts_reg_0_7_157_157_i_20_n_1,contexts_reg_0_7_157_157_i_20_n_2,contexts_reg_0_7_157_157_i_20_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_157_157_i_40_n_0,contexts_reg_0_7_157_157_i_41_n_0,contexts_reg_0_7_157_157_i_42_n_0,contexts_reg_0_7_157_157_i_43_n_0}),
        .O(NLW_contexts_reg_0_7_157_157_i_20_O_UNCONNECTED[3:0]),
        .S({contexts_reg_0_7_157_157_i_44_n_0,contexts_reg_0_7_157_157_i_45_n_0,contexts_reg_0_7_157_157_i_46_n_0,contexts_reg_0_7_157_157_i_47_n_0}));
  LUT5 #(
    .INIT(32'hFEFEFE0E)) 
    contexts_reg_0_7_157_157_i_21
       (.I0(ssc_event4[23]),
        .I1(ssc_event4[22]),
        .I2(contexts_reg_0_7_157_157_i_5_n_3),
        .I3(contexts_reg_0_7_157_157_i_8_n_4),
        .I4(contexts_reg_0_7_157_157_i_8_n_5),
        .O(contexts_reg_0_7_157_157_i_21_n_0));
  LUT5 #(
    .INIT(32'hFEFEFE0E)) 
    contexts_reg_0_7_157_157_i_22
       (.I0(ssc_event4[21]),
        .I1(ssc_event4[20]),
        .I2(contexts_reg_0_7_157_157_i_5_n_3),
        .I3(contexts_reg_0_7_157_157_i_8_n_6),
        .I4(contexts_reg_0_7_157_157_i_8_n_7),
        .O(contexts_reg_0_7_157_157_i_22_n_0));
  LUT5 #(
    .INIT(32'hFEFEFE0E)) 
    contexts_reg_0_7_157_157_i_23
       (.I0(ssc_event4[19]),
        .I1(ssc_event4[18]),
        .I2(contexts_reg_0_7_157_157_i_5_n_3),
        .I3(contexts_reg_0_7_157_157_i_11_n_4),
        .I4(contexts_reg_0_7_157_157_i_11_n_5),
        .O(contexts_reg_0_7_157_157_i_23_n_0));
  LUT5 #(
    .INIT(32'hFEFEFE0E)) 
    contexts_reg_0_7_157_157_i_24
       (.I0(ssc_event4[17]),
        .I1(ssc_event4[16]),
        .I2(contexts_reg_0_7_157_157_i_5_n_3),
        .I3(contexts_reg_0_7_157_157_i_11_n_6),
        .I4(contexts_reg_0_7_157_157_i_11_n_7),
        .O(contexts_reg_0_7_157_157_i_24_n_0));
  LUT5 #(
    .INIT(32'h1010101F)) 
    contexts_reg_0_7_157_157_i_25
       (.I0(contexts_reg_0_7_157_157_i_8_n_5),
        .I1(contexts_reg_0_7_157_157_i_8_n_4),
        .I2(contexts_reg_0_7_157_157_i_5_n_3),
        .I3(ssc_event4[22]),
        .I4(ssc_event4[23]),
        .O(contexts_reg_0_7_157_157_i_25_n_0));
  LUT5 #(
    .INIT(32'h1010101F)) 
    contexts_reg_0_7_157_157_i_26
       (.I0(contexts_reg_0_7_157_157_i_8_n_7),
        .I1(contexts_reg_0_7_157_157_i_8_n_6),
        .I2(contexts_reg_0_7_157_157_i_5_n_3),
        .I3(ssc_event4[20]),
        .I4(ssc_event4[21]),
        .O(contexts_reg_0_7_157_157_i_26_n_0));
  LUT5 #(
    .INIT(32'h1010101F)) 
    contexts_reg_0_7_157_157_i_27
       (.I0(contexts_reg_0_7_157_157_i_11_n_5),
        .I1(contexts_reg_0_7_157_157_i_11_n_4),
        .I2(contexts_reg_0_7_157_157_i_5_n_3),
        .I3(ssc_event4[18]),
        .I4(ssc_event4[19]),
        .O(contexts_reg_0_7_157_157_i_27_n_0));
  LUT5 #(
    .INIT(32'h1010101F)) 
    contexts_reg_0_7_157_157_i_28
       (.I0(contexts_reg_0_7_157_157_i_11_n_7),
        .I1(contexts_reg_0_7_157_157_i_11_n_6),
        .I2(contexts_reg_0_7_157_157_i_5_n_3),
        .I3(ssc_event4[16]),
        .I4(ssc_event4[17]),
        .O(contexts_reg_0_7_157_157_i_28_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 contexts_reg_0_7_157_157_i_29
       (.CI(contexts_reg_0_7_157_157_i_48_n_0),
        .CO({NLW_contexts_reg_0_7_157_157_i_29_CO_UNCONNECTED[3],contexts_reg_0_7_157_157_i_29_n_1,contexts_reg_0_7_157_157_i_29_n_2,contexts_reg_0_7_157_157_i_29_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(ssc_event4[24:21]),
        .S({contexts_reg_0_7_157_157_i_5_n_3,contexts_reg_0_7_157_157_i_50_n_0,contexts_reg_0_7_157_157_i_51_n_0,contexts_reg_0_7_157_157_i_52_n_0}));
  LUT4 #(
    .INIT(16'hFF7F)) 
    contexts_reg_0_7_157_157_i_3
       (.I0(context_word0[268]),
        .I1(context_word0[267]),
        .I2(context_word1),
        .I3(contexts_reg_0_7_17_17_i_4_n_0),
        .O(contexts_reg_0_7_157_157_i_3_n_0));
  CARRY4 contexts_reg_0_7_157_157_i_30
       (.CI(contexts_reg_0_7_157_157_i_53_n_0),
        .CO({contexts_reg_0_7_157_157_i_30_n_0,contexts_reg_0_7_157_157_i_30_n_1,contexts_reg_0_7_157_157_i_30_n_2,contexts_reg_0_7_157_157_i_30_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_157_157_i_54_n_0,contexts_reg_0_7_157_157_i_55_n_0,contexts_reg_0_7_157_157_i_56_n_0,contexts_reg_0_7_157_157_i_57_n_0}),
        .O({contexts_reg_0_7_157_157_i_30_n_4,contexts_reg_0_7_157_157_i_30_n_5,contexts_reg_0_7_157_157_i_30_n_6,contexts_reg_0_7_157_157_i_30_n_7}),
        .S({contexts_reg_0_7_157_157_i_58_n_0,contexts_reg_0_7_157_157_i_59_n_0,contexts_reg_0_7_157_157_i_60_n_0,contexts_reg_0_7_157_157_i_61_n_0}));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_157_157_i_31
       (.I0(context_word0[319]),
        .I1(context_word1),
        .O(contexts_reg_0_7_157_157_i_31_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_157_157_i_32
       (.I0(context_word0[318]),
        .I1(context_word1),
        .O(contexts_reg_0_7_157_157_i_32_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_157_157_i_33
       (.I0(context_word0[317]),
        .I1(context_word1),
        .O(contexts_reg_0_7_157_157_i_33_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_157_157_i_34
       (.I0(context_word0[316]),
        .I1(context_word1),
        .O(contexts_reg_0_7_157_157_i_34_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_157_157_i_35
       (.I0(context_word0[319]),
        .I1(context_word1),
        .I2(context_word0[295]),
        .O(contexts_reg_0_7_157_157_i_35_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_157_157_i_36
       (.I0(context_word0[318]),
        .I1(context_word1),
        .I2(context_word0[294]),
        .O(contexts_reg_0_7_157_157_i_36_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_157_157_i_37
       (.I0(context_word0[317]),
        .I1(context_word1),
        .I2(context_word0[293]),
        .O(contexts_reg_0_7_157_157_i_37_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_157_157_i_38
       (.I0(context_word0[316]),
        .I1(context_word1),
        .I2(context_word0[292]),
        .O(contexts_reg_0_7_157_157_i_38_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 contexts_reg_0_7_157_157_i_39
       (.CI(1'b0),
        .CO({contexts_reg_0_7_157_157_i_39_n_0,contexts_reg_0_7_157_157_i_39_n_1,contexts_reg_0_7_157_157_i_39_n_2,contexts_reg_0_7_157_157_i_39_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_157_157_i_62_n_0,contexts_reg_0_7_157_157_i_63_n_0,contexts_reg_0_7_157_157_i_64_n_0,contexts_reg_0_7_157_157_i_65_n_0}),
        .O(NLW_contexts_reg_0_7_157_157_i_39_O_UNCONNECTED[3:0]),
        .S({contexts_reg_0_7_157_157_i_66_n_0,contexts_reg_0_7_157_157_i_67_n_0,contexts_reg_0_7_157_157_i_68_n_0,contexts_reg_0_7_157_157_i_69_n_0}));
  LUT6 #(
    .INIT(64'hF77FFFFFFFFFFFFF)) 
    contexts_reg_0_7_157_157_i_4
       (.I0(context_word1),
        .I1(zc_event1),
        .I2(contexts_reg_0_7_157_157_i_5_n_3),
        .I3(contexts_reg_0_7_157_157_i_6_n_3),
        .I4(context_word0[274]),
        .I5(ssc_event2),
        .O(contexts_reg_0_7_157_157_i_4_n_0));
  LUT5 #(
    .INIT(32'hFEFEFE0E)) 
    contexts_reg_0_7_157_157_i_40
       (.I0(ssc_event4[15]),
        .I1(ssc_event4[14]),
        .I2(contexts_reg_0_7_157_157_i_5_n_3),
        .I3(contexts_reg_0_7_157_157_i_30_n_4),
        .I4(contexts_reg_0_7_157_157_i_30_n_5),
        .O(contexts_reg_0_7_157_157_i_40_n_0));
  LUT5 #(
    .INIT(32'hFEFEFE0E)) 
    contexts_reg_0_7_157_157_i_41
       (.I0(ssc_event4[13]),
        .I1(ssc_event4[12]),
        .I2(contexts_reg_0_7_157_157_i_5_n_3),
        .I3(contexts_reg_0_7_157_157_i_30_n_6),
        .I4(contexts_reg_0_7_157_157_i_30_n_7),
        .O(contexts_reg_0_7_157_157_i_41_n_0));
  LUT5 #(
    .INIT(32'hFEFEFE0E)) 
    contexts_reg_0_7_157_157_i_42
       (.I0(ssc_event4[11]),
        .I1(ssc_event4[10]),
        .I2(contexts_reg_0_7_157_157_i_5_n_3),
        .I3(contexts_reg_0_7_157_157_i_53_n_4),
        .I4(contexts_reg_0_7_157_157_i_53_n_5),
        .O(contexts_reg_0_7_157_157_i_42_n_0));
  LUT5 #(
    .INIT(32'hFEFEFE0E)) 
    contexts_reg_0_7_157_157_i_43
       (.I0(ssc_event4[9]),
        .I1(ssc_event4[8]),
        .I2(contexts_reg_0_7_157_157_i_5_n_3),
        .I3(contexts_reg_0_7_157_157_i_53_n_6),
        .I4(contexts_reg_0_7_157_157_i_53_n_7),
        .O(contexts_reg_0_7_157_157_i_43_n_0));
  LUT5 #(
    .INIT(32'h1010101F)) 
    contexts_reg_0_7_157_157_i_44
       (.I0(contexts_reg_0_7_157_157_i_30_n_5),
        .I1(contexts_reg_0_7_157_157_i_30_n_4),
        .I2(contexts_reg_0_7_157_157_i_5_n_3),
        .I3(ssc_event4[14]),
        .I4(ssc_event4[15]),
        .O(contexts_reg_0_7_157_157_i_44_n_0));
  LUT5 #(
    .INIT(32'h1010101F)) 
    contexts_reg_0_7_157_157_i_45
       (.I0(contexts_reg_0_7_157_157_i_30_n_7),
        .I1(contexts_reg_0_7_157_157_i_30_n_6),
        .I2(contexts_reg_0_7_157_157_i_5_n_3),
        .I3(ssc_event4[12]),
        .I4(ssc_event4[13]),
        .O(contexts_reg_0_7_157_157_i_45_n_0));
  LUT5 #(
    .INIT(32'h1010101F)) 
    contexts_reg_0_7_157_157_i_46
       (.I0(contexts_reg_0_7_157_157_i_53_n_5),
        .I1(contexts_reg_0_7_157_157_i_53_n_4),
        .I2(contexts_reg_0_7_157_157_i_5_n_3),
        .I3(ssc_event4[10]),
        .I4(ssc_event4[11]),
        .O(contexts_reg_0_7_157_157_i_46_n_0));
  LUT5 #(
    .INIT(32'h1010101F)) 
    contexts_reg_0_7_157_157_i_47
       (.I0(contexts_reg_0_7_157_157_i_53_n_7),
        .I1(contexts_reg_0_7_157_157_i_53_n_6),
        .I2(contexts_reg_0_7_157_157_i_5_n_3),
        .I3(ssc_event4[8]),
        .I4(ssc_event4[9]),
        .O(contexts_reg_0_7_157_157_i_47_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 contexts_reg_0_7_157_157_i_48
       (.CI(contexts_reg_0_7_157_157_i_49_n_0),
        .CO({contexts_reg_0_7_157_157_i_48_n_0,contexts_reg_0_7_157_157_i_48_n_1,contexts_reg_0_7_157_157_i_48_n_2,contexts_reg_0_7_157_157_i_48_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(ssc_event4[20:17]),
        .S({contexts_reg_0_7_157_157_i_72_n_0,contexts_reg_0_7_157_157_i_73_n_0,contexts_reg_0_7_157_157_i_74_n_0,contexts_reg_0_7_157_157_i_75_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 contexts_reg_0_7_157_157_i_49
       (.CI(contexts_reg_0_7_157_157_i_70_n_0),
        .CO({contexts_reg_0_7_157_157_i_49_n_0,contexts_reg_0_7_157_157_i_49_n_1,contexts_reg_0_7_157_157_i_49_n_2,contexts_reg_0_7_157_157_i_49_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(ssc_event4[16:13]),
        .S({contexts_reg_0_7_157_157_i_76_n_0,contexts_reg_0_7_157_157_i_77_n_0,contexts_reg_0_7_157_157_i_78_n_0,contexts_reg_0_7_157_157_i_79_n_0}));
  CARRY4 contexts_reg_0_7_157_157_i_5
       (.CI(contexts_reg_0_7_157_157_i_8_n_0),
        .CO({NLW_contexts_reg_0_7_157_157_i_5_CO_UNCONNECTED[3:1],contexts_reg_0_7_157_157_i_5_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_contexts_reg_0_7_157_157_i_5_O_UNCONNECTED[3:0]),
        .S({1'b0,1'b0,1'b0,1'b1}));
  LUT1 #(
    .INIT(2'h1)) 
    contexts_reg_0_7_157_157_i_50
       (.I0(contexts_reg_0_7_157_157_i_8_n_4),
        .O(contexts_reg_0_7_157_157_i_50_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    contexts_reg_0_7_157_157_i_51
       (.I0(contexts_reg_0_7_157_157_i_8_n_5),
        .O(contexts_reg_0_7_157_157_i_51_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    contexts_reg_0_7_157_157_i_52
       (.I0(contexts_reg_0_7_157_157_i_8_n_6),
        .O(contexts_reg_0_7_157_157_i_52_n_0));
  CARRY4 contexts_reg_0_7_157_157_i_53
       (.CI(contexts_reg_0_7_157_157_i_80_n_0),
        .CO({contexts_reg_0_7_157_157_i_53_n_0,contexts_reg_0_7_157_157_i_53_n_1,contexts_reg_0_7_157_157_i_53_n_2,contexts_reg_0_7_157_157_i_53_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_157_157_i_81_n_0,contexts_reg_0_7_157_157_i_82_n_0,contexts_reg_0_7_157_157_i_83_n_0,contexts_reg_0_7_157_157_i_84_n_0}),
        .O({contexts_reg_0_7_157_157_i_53_n_4,contexts_reg_0_7_157_157_i_53_n_5,contexts_reg_0_7_157_157_i_53_n_6,contexts_reg_0_7_157_157_i_53_n_7}),
        .S({contexts_reg_0_7_157_157_i_85_n_0,contexts_reg_0_7_157_157_i_86_n_0,contexts_reg_0_7_157_157_i_87_n_0,contexts_reg_0_7_157_157_i_88_n_0}));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_157_157_i_54
       (.I0(context_word0[315]),
        .I1(context_word1),
        .O(contexts_reg_0_7_157_157_i_54_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_157_157_i_55
       (.I0(context_word0[314]),
        .I1(context_word1),
        .O(contexts_reg_0_7_157_157_i_55_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_157_157_i_56
       (.I0(context_word0[313]),
        .I1(context_word1),
        .O(contexts_reg_0_7_157_157_i_56_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_157_157_i_57
       (.I0(context_word0[312]),
        .I1(context_word1),
        .O(contexts_reg_0_7_157_157_i_57_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_157_157_i_58
       (.I0(context_word0[315]),
        .I1(context_word1),
        .I2(context_word0[291]),
        .O(contexts_reg_0_7_157_157_i_58_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_157_157_i_59
       (.I0(context_word0[314]),
        .I1(context_word1),
        .I2(context_word0[290]),
        .O(contexts_reg_0_7_157_157_i_59_n_0));
  CARRY4 contexts_reg_0_7_157_157_i_6
       (.CI(history_reg_0_31_66_66_i_10_n_0),
        .CO({NLW_contexts_reg_0_7_157_157_i_6_CO_UNCONNECTED[3:1],contexts_reg_0_7_157_157_i_6_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_contexts_reg_0_7_157_157_i_6_O_UNCONNECTED[3:0]),
        .S({1'b0,1'b0,1'b0,1'b1}));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_157_157_i_60
       (.I0(context_word0[313]),
        .I1(context_word1),
        .I2(context_word0[289]),
        .O(contexts_reg_0_7_157_157_i_60_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_157_157_i_61
       (.I0(context_word0[312]),
        .I1(context_word1),
        .I2(context_word0[288]),
        .O(contexts_reg_0_7_157_157_i_61_n_0));
  LUT5 #(
    .INIT(32'hFEFEFE0E)) 
    contexts_reg_0_7_157_157_i_62
       (.I0(ssc_event4[7]),
        .I1(ssc_event4[6]),
        .I2(contexts_reg_0_7_157_157_i_5_n_3),
        .I3(contexts_reg_0_7_157_157_i_80_n_4),
        .I4(contexts_reg_0_7_157_157_i_80_n_5),
        .O(contexts_reg_0_7_157_157_i_62_n_0));
  LUT5 #(
    .INIT(32'hFEFEFE0E)) 
    contexts_reg_0_7_157_157_i_63
       (.I0(ssc_event4[5]),
        .I1(ssc_event4[4]),
        .I2(contexts_reg_0_7_157_157_i_5_n_3),
        .I3(contexts_reg_0_7_157_157_i_80_n_6),
        .I4(contexts_reg_0_7_157_157_i_80_n_7),
        .O(contexts_reg_0_7_157_157_i_63_n_0));
  LUT5 #(
    .INIT(32'hFEFEFE0E)) 
    contexts_reg_0_7_157_157_i_64
       (.I0(ssc_event4[3]),
        .I1(ssc_event4[2]),
        .I2(contexts_reg_0_7_157_157_i_5_n_3),
        .I3(contexts_reg_0_7_157_157_i_90_n_4),
        .I4(contexts_reg_0_7_157_157_i_90_n_5),
        .O(contexts_reg_0_7_157_157_i_64_n_0));
  LUT4 #(
    .INIT(16'hFFB8)) 
    contexts_reg_0_7_157_157_i_65
       (.I0(contexts_reg_0_7_157_157_i_90_n_6),
        .I1(contexts_reg_0_7_157_157_i_5_n_3),
        .I2(ssc_event4[1]),
        .I3(contexts_reg_0_7_157_157_i_90_n_7),
        .O(contexts_reg_0_7_157_157_i_65_n_0));
  LUT5 #(
    .INIT(32'h1010101F)) 
    contexts_reg_0_7_157_157_i_66
       (.I0(contexts_reg_0_7_157_157_i_80_n_5),
        .I1(contexts_reg_0_7_157_157_i_80_n_4),
        .I2(contexts_reg_0_7_157_157_i_5_n_3),
        .I3(ssc_event4[6]),
        .I4(ssc_event4[7]),
        .O(contexts_reg_0_7_157_157_i_66_n_0));
  LUT5 #(
    .INIT(32'h1010101F)) 
    contexts_reg_0_7_157_157_i_67
       (.I0(contexts_reg_0_7_157_157_i_80_n_7),
        .I1(contexts_reg_0_7_157_157_i_80_n_6),
        .I2(contexts_reg_0_7_157_157_i_5_n_3),
        .I3(ssc_event4[4]),
        .I4(ssc_event4[5]),
        .O(contexts_reg_0_7_157_157_i_67_n_0));
  LUT5 #(
    .INIT(32'h1010101F)) 
    contexts_reg_0_7_157_157_i_68
       (.I0(contexts_reg_0_7_157_157_i_90_n_5),
        .I1(contexts_reg_0_7_157_157_i_90_n_4),
        .I2(contexts_reg_0_7_157_157_i_5_n_3),
        .I3(ssc_event4[2]),
        .I4(ssc_event4[3]),
        .O(contexts_reg_0_7_157_157_i_68_n_0));
  LUT4 #(
    .INIT(16'h0151)) 
    contexts_reg_0_7_157_157_i_69
       (.I0(contexts_reg_0_7_157_157_i_90_n_7),
        .I1(ssc_event4[1]),
        .I2(contexts_reg_0_7_157_157_i_5_n_3),
        .I3(contexts_reg_0_7_157_157_i_90_n_6),
        .O(contexts_reg_0_7_157_157_i_69_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 contexts_reg_0_7_157_157_i_7
       (.CI(contexts_reg_0_7_157_157_i_9_n_0),
        .CO({NLW_contexts_reg_0_7_157_157_i_7_CO_UNCONNECTED[3:1],ssc_event2}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_contexts_reg_0_7_157_157_i_7_O_UNCONNECTED[3:0]),
        .S({1'b0,1'b0,1'b0,contexts_reg_0_7_157_157_i_10_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 contexts_reg_0_7_157_157_i_70
       (.CI(contexts_reg_0_7_157_157_i_71_n_0),
        .CO({contexts_reg_0_7_157_157_i_70_n_0,contexts_reg_0_7_157_157_i_70_n_1,contexts_reg_0_7_157_157_i_70_n_2,contexts_reg_0_7_157_157_i_70_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(ssc_event4[12:9]),
        .S({contexts_reg_0_7_157_157_i_91_n_0,contexts_reg_0_7_157_157_i_92_n_0,contexts_reg_0_7_157_157_i_93_n_0,contexts_reg_0_7_157_157_i_94_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 contexts_reg_0_7_157_157_i_71
       (.CI(contexts_reg_0_7_157_157_i_89_n_0),
        .CO({contexts_reg_0_7_157_157_i_71_n_0,contexts_reg_0_7_157_157_i_71_n_1,contexts_reg_0_7_157_157_i_71_n_2,contexts_reg_0_7_157_157_i_71_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(ssc_event4[8:5]),
        .S({contexts_reg_0_7_157_157_i_95_n_0,contexts_reg_0_7_157_157_i_96_n_0,contexts_reg_0_7_157_157_i_97_n_0,contexts_reg_0_7_157_157_i_98_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    contexts_reg_0_7_157_157_i_72
       (.I0(contexts_reg_0_7_157_157_i_8_n_7),
        .O(contexts_reg_0_7_157_157_i_72_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    contexts_reg_0_7_157_157_i_73
       (.I0(contexts_reg_0_7_157_157_i_11_n_4),
        .O(contexts_reg_0_7_157_157_i_73_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    contexts_reg_0_7_157_157_i_74
       (.I0(contexts_reg_0_7_157_157_i_11_n_5),
        .O(contexts_reg_0_7_157_157_i_74_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    contexts_reg_0_7_157_157_i_75
       (.I0(contexts_reg_0_7_157_157_i_11_n_6),
        .O(contexts_reg_0_7_157_157_i_75_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    contexts_reg_0_7_157_157_i_76
       (.I0(contexts_reg_0_7_157_157_i_11_n_7),
        .O(contexts_reg_0_7_157_157_i_76_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    contexts_reg_0_7_157_157_i_77
       (.I0(contexts_reg_0_7_157_157_i_30_n_4),
        .O(contexts_reg_0_7_157_157_i_77_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    contexts_reg_0_7_157_157_i_78
       (.I0(contexts_reg_0_7_157_157_i_30_n_5),
        .O(contexts_reg_0_7_157_157_i_78_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    contexts_reg_0_7_157_157_i_79
       (.I0(contexts_reg_0_7_157_157_i_30_n_6),
        .O(contexts_reg_0_7_157_157_i_79_n_0));
  CARRY4 contexts_reg_0_7_157_157_i_8
       (.CI(contexts_reg_0_7_157_157_i_11_n_0),
        .CO({contexts_reg_0_7_157_157_i_8_n_0,contexts_reg_0_7_157_157_i_8_n_1,contexts_reg_0_7_157_157_i_8_n_2,contexts_reg_0_7_157_157_i_8_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_157_157_i_12_n_0,contexts_reg_0_7_157_157_i_13_n_0,contexts_reg_0_7_157_157_i_14_n_0,contexts_reg_0_7_157_157_i_15_n_0}),
        .O({contexts_reg_0_7_157_157_i_8_n_4,contexts_reg_0_7_157_157_i_8_n_5,contexts_reg_0_7_157_157_i_8_n_6,contexts_reg_0_7_157_157_i_8_n_7}),
        .S({contexts_reg_0_7_157_157_i_16_n_0,contexts_reg_0_7_157_157_i_17_n_0,contexts_reg_0_7_157_157_i_18_n_0,contexts_reg_0_7_157_157_i_19_n_0}));
  CARRY4 contexts_reg_0_7_157_157_i_80
       (.CI(contexts_reg_0_7_157_157_i_90_n_0),
        .CO({contexts_reg_0_7_157_157_i_80_n_0,contexts_reg_0_7_157_157_i_80_n_1,contexts_reg_0_7_157_157_i_80_n_2,contexts_reg_0_7_157_157_i_80_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_157_157_i_99_n_0,contexts_reg_0_7_157_157_i_100_n_0,contexts_reg_0_7_157_157_i_101_n_0,contexts_reg_0_7_157_157_i_102_n_0}),
        .O({contexts_reg_0_7_157_157_i_80_n_4,contexts_reg_0_7_157_157_i_80_n_5,contexts_reg_0_7_157_157_i_80_n_6,contexts_reg_0_7_157_157_i_80_n_7}),
        .S({contexts_reg_0_7_157_157_i_103_n_0,contexts_reg_0_7_157_157_i_104_n_0,contexts_reg_0_7_157_157_i_105_n_0,contexts_reg_0_7_157_157_i_106_n_0}));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_157_157_i_81
       (.I0(context_word0[311]),
        .I1(context_word1),
        .O(contexts_reg_0_7_157_157_i_81_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_157_157_i_82
       (.I0(context_word0[310]),
        .I1(context_word1),
        .O(contexts_reg_0_7_157_157_i_82_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_157_157_i_83
       (.I0(context_word0[309]),
        .I1(context_word1),
        .O(contexts_reg_0_7_157_157_i_83_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_157_157_i_84
       (.I0(context_word0[308]),
        .I1(context_word1),
        .O(contexts_reg_0_7_157_157_i_84_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_157_157_i_85
       (.I0(context_word0[311]),
        .I1(context_word1),
        .I2(context_word0[287]),
        .O(contexts_reg_0_7_157_157_i_85_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_157_157_i_86
       (.I0(context_word0[310]),
        .I1(context_word1),
        .I2(context_word0[286]),
        .O(contexts_reg_0_7_157_157_i_86_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_157_157_i_87
       (.I0(context_word0[309]),
        .I1(context_word1),
        .I2(context_word0[285]),
        .O(contexts_reg_0_7_157_157_i_87_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_157_157_i_88
       (.I0(context_word0[308]),
        .I1(context_word1),
        .I2(context_word0[284]),
        .O(contexts_reg_0_7_157_157_i_88_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 contexts_reg_0_7_157_157_i_89
       (.CI(1'b0),
        .CO({contexts_reg_0_7_157_157_i_89_n_0,contexts_reg_0_7_157_157_i_89_n_1,contexts_reg_0_7_157_157_i_89_n_2,contexts_reg_0_7_157_157_i_89_n_3}),
        .CYINIT(contexts_reg_0_7_157_157_i_107_n_0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(ssc_event4[4:1]),
        .S({contexts_reg_0_7_157_157_i_108_n_0,contexts_reg_0_7_157_157_i_109_n_0,contexts_reg_0_7_157_157_i_110_n_0,contexts_reg_0_7_157_157_i_111_n_0}));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 contexts_reg_0_7_157_157_i_9
       (.CI(contexts_reg_0_7_157_157_i_20_n_0),
        .CO({contexts_reg_0_7_157_157_i_9_n_0,contexts_reg_0_7_157_157_i_9_n_1,contexts_reg_0_7_157_157_i_9_n_2,contexts_reg_0_7_157_157_i_9_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_157_157_i_21_n_0,contexts_reg_0_7_157_157_i_22_n_0,contexts_reg_0_7_157_157_i_23_n_0,contexts_reg_0_7_157_157_i_24_n_0}),
        .O(NLW_contexts_reg_0_7_157_157_i_9_O_UNCONNECTED[3:0]),
        .S({contexts_reg_0_7_157_157_i_25_n_0,contexts_reg_0_7_157_157_i_26_n_0,contexts_reg_0_7_157_157_i_27_n_0,contexts_reg_0_7_157_157_i_28_n_0}));
  CARRY4 contexts_reg_0_7_157_157_i_90
       (.CI(1'b0),
        .CO({contexts_reg_0_7_157_157_i_90_n_0,contexts_reg_0_7_157_157_i_90_n_1,contexts_reg_0_7_157_157_i_90_n_2,contexts_reg_0_7_157_157_i_90_n_3}),
        .CYINIT(1'b1),
        .DI({contexts_reg_0_7_157_157_i_112_n_0,contexts_reg_0_7_157_157_i_113_n_0,contexts_reg_0_7_157_157_i_114_n_0,contexts_reg_0_7_157_157_i_115_n_0}),
        .O({contexts_reg_0_7_157_157_i_90_n_4,contexts_reg_0_7_157_157_i_90_n_5,contexts_reg_0_7_157_157_i_90_n_6,contexts_reg_0_7_157_157_i_90_n_7}),
        .S({contexts_reg_0_7_157_157_i_116_n_0,contexts_reg_0_7_157_157_i_117_n_0,contexts_reg_0_7_157_157_i_118_n_0,contexts_reg_0_7_157_157_i_119_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    contexts_reg_0_7_157_157_i_91
       (.I0(contexts_reg_0_7_157_157_i_30_n_7),
        .O(contexts_reg_0_7_157_157_i_91_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    contexts_reg_0_7_157_157_i_92
       (.I0(contexts_reg_0_7_157_157_i_53_n_4),
        .O(contexts_reg_0_7_157_157_i_92_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    contexts_reg_0_7_157_157_i_93
       (.I0(contexts_reg_0_7_157_157_i_53_n_5),
        .O(contexts_reg_0_7_157_157_i_93_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    contexts_reg_0_7_157_157_i_94
       (.I0(contexts_reg_0_7_157_157_i_53_n_6),
        .O(contexts_reg_0_7_157_157_i_94_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    contexts_reg_0_7_157_157_i_95
       (.I0(contexts_reg_0_7_157_157_i_53_n_7),
        .O(contexts_reg_0_7_157_157_i_95_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    contexts_reg_0_7_157_157_i_96
       (.I0(contexts_reg_0_7_157_157_i_80_n_4),
        .O(contexts_reg_0_7_157_157_i_96_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    contexts_reg_0_7_157_157_i_97
       (.I0(contexts_reg_0_7_157_157_i_80_n_5),
        .O(contexts_reg_0_7_157_157_i_97_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    contexts_reg_0_7_157_157_i_98
       (.I0(contexts_reg_0_7_157_157_i_80_n_6),
        .O(contexts_reg_0_7_157_157_i_98_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_157_157_i_99
       (.I0(context_word0[307]),
        .I1(context_word1),
        .O(contexts_reg_0_7_157_157_i_99_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "158" *) 
  (* ram_slice_end = "158" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_158_158
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_ssc[1]),
        .O(context_word0[158]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT5 #(
    .INIT(32'h8A202020)) 
    contexts_reg_0_7_158_158_i_1
       (.I0(contexts_reg_0_7_157_157_i_3_n_0),
        .I1(contexts_reg_0_7_157_157_i_4_n_0),
        .I2(context_word0[157]),
        .I3(context_word0[158]),
        .I4(context_word1),
        .O(seg_ssc[1]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "159" *) 
  (* ram_slice_end = "159" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_159_159
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_ssc[2]),
        .O(context_word0[159]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT6 #(
    .INIT(64'h8888088800008000)) 
    contexts_reg_0_7_159_159_i_1
       (.I0(contexts_reg_0_7_157_157_i_3_n_0),
        .I1(context_word1),
        .I2(context_word0[158]),
        .I3(context_word0[157]),
        .I4(contexts_reg_0_7_157_157_i_4_n_0),
        .I5(context_word0[159]),
        .O(seg_ssc[2]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "15" *) 
  (* ram_slice_end = "15" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_15_15
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_15_15_i_1_n_0),
        .O(context_word0[15]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_7_7_i_2_n_0));
  LUT6 #(
    .INIT(64'h00000000C4CC0800)) 
    contexts_reg_0_7_15_15_i_1
       (.I0(context_word0[13]),
        .I1(context_word1),
        .I2(contexts_reg_0_7_15_15_i_2_n_0),
        .I3(context_word0[14]),
        .I4(context_word0[15]),
        .I5(contexts_reg_0_7_7_7_i_3_n_0),
        .O(contexts_reg_0_7_15_15_i_1_n_0));
  LUT6 #(
    .INIT(64'hFF7FFFFFFFFFFFFF)) 
    contexts_reg_0_7_15_15_i_2
       (.I0(context_word0[11]),
        .I1(context_word1),
        .I2(context_word0[9]),
        .I3(contexts_reg_0_7_11_11_i_2_n_0),
        .I4(context_word0[10]),
        .I5(context_word0[12]),
        .O(contexts_reg_0_7_15_15_i_2_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "160" *) 
  (* ram_slice_end = "160" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_160_160
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_160_160_i_1_n_0),
        .O(context_word0[160]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_160_160_i_1
       (.I0(completed_ssc[3]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(contexts_reg_0_7_160_160_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "161" *) 
  (* ram_slice_end = "161" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_161_161
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_161_161_i_1_n_0),
        .O(context_word0[161]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT4 #(
    .INIT(16'h9100)) 
    contexts_reg_0_7_161_161_i_1
       (.I0(context_word0[161]),
        .I1(contexts_reg_0_7_161_161_i_2_n_0),
        .I2(context_word1),
        .I3(contexts_reg_0_7_157_157_i_3_n_0),
        .O(contexts_reg_0_7_161_161_i_1_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFF7FFFFFFF)) 
    contexts_reg_0_7_161_161_i_2
       (.I0(context_word0[160]),
        .I1(context_word0[159]),
        .I2(context_word1),
        .I3(context_word0[158]),
        .I4(context_word0[157]),
        .I5(contexts_reg_0_7_157_157_i_4_n_0),
        .O(contexts_reg_0_7_161_161_i_2_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "162" *) 
  (* ram_slice_end = "162" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_162_162
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_162_162_i_1_n_0),
        .O(context_word0[162]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT5 #(
    .INIT(32'hD2220000)) 
    contexts_reg_0_7_162_162_i_1
       (.I0(context_word0[161]),
        .I1(contexts_reg_0_7_161_161_i_2_n_0),
        .I2(context_word0[162]),
        .I3(context_word1),
        .I4(contexts_reg_0_7_157_157_i_3_n_0),
        .O(contexts_reg_0_7_162_162_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "163" *) 
  (* ram_slice_end = "163" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_163_163
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_163_163_i_1_n_0),
        .O(context_word0[163]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT6 #(
    .INIT(64'hF070008000000000)) 
    contexts_reg_0_7_163_163_i_1
       (.I0(context_word0[162]),
        .I1(context_word0[161]),
        .I2(context_word1),
        .I3(contexts_reg_0_7_161_161_i_2_n_0),
        .I4(context_word0[163]),
        .I5(contexts_reg_0_7_157_157_i_3_n_0),
        .O(contexts_reg_0_7_163_163_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "164" *) 
  (* ram_slice_end = "164" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_164_164
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_zc[0]),
        .O(context_word0[164]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT6 #(
    .INIT(64'h8080088008808080)) 
    contexts_reg_0_7_164_164_i_1
       (.I0(contexts_reg_0_7_157_157_i_3_n_0),
        .I1(context_word1),
        .I2(context_word0[164]),
        .I3(zc_event1),
        .I4(context_word0[323]),
        .I5(sample_data[23]),
        .O(seg_zc[0]));
  LUT5 #(
    .INIT(32'h00053305)) 
    contexts_reg_0_7_164_164_i_10
       (.I0(abs_diff1[23]),
        .I1(abs_diff3[23]),
        .I2(abs_diff1[22]),
        .I3(contexts_reg_0_7_157_157_i_6_n_3),
        .I4(abs_diff3[22]),
        .O(contexts_reg_0_7_164_164_i_10_n_0));
  LUT5 #(
    .INIT(32'h00053305)) 
    contexts_reg_0_7_164_164_i_11
       (.I0(abs_diff1[21]),
        .I1(abs_diff3[21]),
        .I2(abs_diff1[20]),
        .I3(contexts_reg_0_7_157_157_i_6_n_3),
        .I4(abs_diff3[20]),
        .O(contexts_reg_0_7_164_164_i_11_n_0));
  LUT5 #(
    .INIT(32'h00053305)) 
    contexts_reg_0_7_164_164_i_12
       (.I0(abs_diff1[19]),
        .I1(abs_diff3[19]),
        .I2(abs_diff1[18]),
        .I3(contexts_reg_0_7_157_157_i_6_n_3),
        .I4(abs_diff3[18]),
        .O(contexts_reg_0_7_164_164_i_12_n_0));
  LUT5 #(
    .INIT(32'h00053305)) 
    contexts_reg_0_7_164_164_i_13
       (.I0(abs_diff1[17]),
        .I1(abs_diff3[17]),
        .I2(abs_diff1[16]),
        .I3(contexts_reg_0_7_157_157_i_6_n_3),
        .I4(abs_diff3[16]),
        .O(contexts_reg_0_7_164_164_i_13_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 contexts_reg_0_7_164_164_i_14
       (.CI(1'b0),
        .CO({contexts_reg_0_7_164_164_i_14_n_0,contexts_reg_0_7_164_164_i_14_n_1,contexts_reg_0_7_164_164_i_14_n_2,contexts_reg_0_7_164_164_i_14_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_164_164_i_23_n_0,contexts_reg_0_7_164_164_i_24_n_0,contexts_reg_0_7_164_164_i_25_n_0,contexts_reg_0_7_164_164_i_26_n_0}),
        .O(NLW_contexts_reg_0_7_164_164_i_14_O_UNCONNECTED[3:0]),
        .S({contexts_reg_0_7_164_164_i_27_n_0,contexts_reg_0_7_164_164_i_28_n_0,contexts_reg_0_7_164_164_i_29_n_0,contexts_reg_0_7_164_164_i_30_n_0}));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    contexts_reg_0_7_164_164_i_15
       (.I0(abs_diff3[14]),
        .I1(contexts_reg_0_7_157_157_i_6_n_3),
        .I2(abs_diff1[14]),
        .I3(abs_diff3[15]),
        .I4(abs_diff1[15]),
        .O(contexts_reg_0_7_164_164_i_15_n_0));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    contexts_reg_0_7_164_164_i_16
       (.I0(abs_diff3[12]),
        .I1(contexts_reg_0_7_157_157_i_6_n_3),
        .I2(abs_diff1[12]),
        .I3(abs_diff3[13]),
        .I4(abs_diff1[13]),
        .O(contexts_reg_0_7_164_164_i_16_n_0));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    contexts_reg_0_7_164_164_i_17
       (.I0(abs_diff3[10]),
        .I1(contexts_reg_0_7_157_157_i_6_n_3),
        .I2(abs_diff1[10]),
        .I3(abs_diff3[11]),
        .I4(abs_diff1[11]),
        .O(contexts_reg_0_7_164_164_i_17_n_0));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    contexts_reg_0_7_164_164_i_18
       (.I0(abs_diff3[8]),
        .I1(contexts_reg_0_7_157_157_i_6_n_3),
        .I2(abs_diff1[8]),
        .I3(abs_diff3[9]),
        .I4(abs_diff1[9]),
        .O(contexts_reg_0_7_164_164_i_18_n_0));
  LUT5 #(
    .INIT(32'h00053305)) 
    contexts_reg_0_7_164_164_i_19
       (.I0(abs_diff1[15]),
        .I1(abs_diff3[15]),
        .I2(abs_diff1[14]),
        .I3(contexts_reg_0_7_157_157_i_6_n_3),
        .I4(abs_diff3[14]),
        .O(contexts_reg_0_7_164_164_i_19_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 contexts_reg_0_7_164_164_i_2
       (.CI(contexts_reg_0_7_164_164_i_3_n_0),
        .CO({NLW_contexts_reg_0_7_164_164_i_2_CO_UNCONNECTED[3:1],zc_event1}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_contexts_reg_0_7_164_164_i_2_O_UNCONNECTED[3:0]),
        .S({1'b0,1'b0,1'b0,contexts_reg_0_7_164_164_i_4_n_0}));
  LUT5 #(
    .INIT(32'h00053305)) 
    contexts_reg_0_7_164_164_i_20
       (.I0(abs_diff1[13]),
        .I1(abs_diff3[13]),
        .I2(abs_diff1[12]),
        .I3(contexts_reg_0_7_157_157_i_6_n_3),
        .I4(abs_diff3[12]),
        .O(contexts_reg_0_7_164_164_i_20_n_0));
  LUT5 #(
    .INIT(32'h00053305)) 
    contexts_reg_0_7_164_164_i_21
       (.I0(abs_diff1[11]),
        .I1(abs_diff3[11]),
        .I2(abs_diff1[10]),
        .I3(contexts_reg_0_7_157_157_i_6_n_3),
        .I4(abs_diff3[10]),
        .O(contexts_reg_0_7_164_164_i_21_n_0));
  LUT5 #(
    .INIT(32'h00053305)) 
    contexts_reg_0_7_164_164_i_22
       (.I0(abs_diff1[9]),
        .I1(abs_diff3[9]),
        .I2(abs_diff1[8]),
        .I3(contexts_reg_0_7_157_157_i_6_n_3),
        .I4(abs_diff3[8]),
        .O(contexts_reg_0_7_164_164_i_22_n_0));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    contexts_reg_0_7_164_164_i_23
       (.I0(abs_diff3[6]),
        .I1(contexts_reg_0_7_157_157_i_6_n_3),
        .I2(abs_diff1[6]),
        .I3(abs_diff3[7]),
        .I4(abs_diff1[7]),
        .O(contexts_reg_0_7_164_164_i_23_n_0));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    contexts_reg_0_7_164_164_i_24
       (.I0(abs_diff3[4]),
        .I1(contexts_reg_0_7_157_157_i_6_n_3),
        .I2(abs_diff1[4]),
        .I3(abs_diff3[5]),
        .I4(abs_diff1[5]),
        .O(contexts_reg_0_7_164_164_i_24_n_0));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    contexts_reg_0_7_164_164_i_25
       (.I0(abs_diff3[2]),
        .I1(contexts_reg_0_7_157_157_i_6_n_3),
        .I2(abs_diff1[2]),
        .I3(abs_diff3[3]),
        .I4(abs_diff1[3]),
        .O(contexts_reg_0_7_164_164_i_25_n_0));
  LUT4 #(
    .INIT(16'hFFB8)) 
    contexts_reg_0_7_164_164_i_26
       (.I0(abs_diff3[1]),
        .I1(contexts_reg_0_7_157_157_i_6_n_3),
        .I2(abs_diff1[1]),
        .I3(abs_diff3[0]),
        .O(contexts_reg_0_7_164_164_i_26_n_0));
  LUT5 #(
    .INIT(32'h00053305)) 
    contexts_reg_0_7_164_164_i_27
       (.I0(abs_diff1[7]),
        .I1(abs_diff3[7]),
        .I2(abs_diff1[6]),
        .I3(contexts_reg_0_7_157_157_i_6_n_3),
        .I4(abs_diff3[6]),
        .O(contexts_reg_0_7_164_164_i_27_n_0));
  LUT5 #(
    .INIT(32'h00053305)) 
    contexts_reg_0_7_164_164_i_28
       (.I0(abs_diff1[5]),
        .I1(abs_diff3[5]),
        .I2(abs_diff1[4]),
        .I3(contexts_reg_0_7_157_157_i_6_n_3),
        .I4(abs_diff3[4]),
        .O(contexts_reg_0_7_164_164_i_28_n_0));
  LUT5 #(
    .INIT(32'h00053305)) 
    contexts_reg_0_7_164_164_i_29
       (.I0(abs_diff1[3]),
        .I1(abs_diff3[3]),
        .I2(abs_diff1[2]),
        .I3(contexts_reg_0_7_157_157_i_6_n_3),
        .I4(abs_diff3[2]),
        .O(contexts_reg_0_7_164_164_i_29_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 contexts_reg_0_7_164_164_i_3
       (.CI(contexts_reg_0_7_164_164_i_5_n_0),
        .CO({contexts_reg_0_7_164_164_i_3_n_0,contexts_reg_0_7_164_164_i_3_n_1,contexts_reg_0_7_164_164_i_3_n_2,contexts_reg_0_7_164_164_i_3_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_164_164_i_6_n_0,contexts_reg_0_7_164_164_i_7_n_0,contexts_reg_0_7_164_164_i_8_n_0,contexts_reg_0_7_164_164_i_9_n_0}),
        .O(NLW_contexts_reg_0_7_164_164_i_3_O_UNCONNECTED[3:0]),
        .S({contexts_reg_0_7_164_164_i_10_n_0,contexts_reg_0_7_164_164_i_11_n_0,contexts_reg_0_7_164_164_i_12_n_0,contexts_reg_0_7_164_164_i_13_n_0}));
  LUT4 #(
    .INIT(16'h0151)) 
    contexts_reg_0_7_164_164_i_30
       (.I0(abs_diff3[0]),
        .I1(abs_diff1[1]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff3[1]),
        .O(contexts_reg_0_7_164_164_i_30_n_0));
  LUT2 #(
    .INIT(4'hB)) 
    contexts_reg_0_7_164_164_i_4
       (.I0(contexts_reg_0_7_157_157_i_6_n_3),
        .I1(abs_diff1[24]),
        .O(contexts_reg_0_7_164_164_i_4_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 contexts_reg_0_7_164_164_i_5
       (.CI(contexts_reg_0_7_164_164_i_14_n_0),
        .CO({contexts_reg_0_7_164_164_i_5_n_0,contexts_reg_0_7_164_164_i_5_n_1,contexts_reg_0_7_164_164_i_5_n_2,contexts_reg_0_7_164_164_i_5_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_164_164_i_15_n_0,contexts_reg_0_7_164_164_i_16_n_0,contexts_reg_0_7_164_164_i_17_n_0,contexts_reg_0_7_164_164_i_18_n_0}),
        .O(NLW_contexts_reg_0_7_164_164_i_5_O_UNCONNECTED[3:0]),
        .S({contexts_reg_0_7_164_164_i_19_n_0,contexts_reg_0_7_164_164_i_20_n_0,contexts_reg_0_7_164_164_i_21_n_0,contexts_reg_0_7_164_164_i_22_n_0}));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    contexts_reg_0_7_164_164_i_6
       (.I0(abs_diff3[22]),
        .I1(contexts_reg_0_7_157_157_i_6_n_3),
        .I2(abs_diff1[22]),
        .I3(abs_diff3[23]),
        .I4(abs_diff1[23]),
        .O(contexts_reg_0_7_164_164_i_6_n_0));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    contexts_reg_0_7_164_164_i_7
       (.I0(abs_diff3[20]),
        .I1(contexts_reg_0_7_157_157_i_6_n_3),
        .I2(abs_diff1[20]),
        .I3(abs_diff3[21]),
        .I4(abs_diff1[21]),
        .O(contexts_reg_0_7_164_164_i_7_n_0));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    contexts_reg_0_7_164_164_i_8
       (.I0(abs_diff3[18]),
        .I1(contexts_reg_0_7_157_157_i_6_n_3),
        .I2(abs_diff1[18]),
        .I3(abs_diff3[19]),
        .I4(abs_diff1[19]),
        .O(contexts_reg_0_7_164_164_i_8_n_0));
  LUT5 #(
    .INIT(32'hFFBBFCB8)) 
    contexts_reg_0_7_164_164_i_9
       (.I0(abs_diff3[16]),
        .I1(contexts_reg_0_7_157_157_i_6_n_3),
        .I2(abs_diff1[16]),
        .I3(abs_diff3[17]),
        .I4(abs_diff1[17]),
        .O(contexts_reg_0_7_164_164_i_9_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "165" *) 
  (* ram_slice_end = "165" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_165_165
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_zc[1]),
        .O(context_word0[165]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT5 #(
    .INIT(32'h8A202020)) 
    contexts_reg_0_7_165_165_i_1
       (.I0(contexts_reg_0_7_157_157_i_3_n_0),
        .I1(contexts_reg_0_7_165_165_i_2_n_0),
        .I2(context_word0[164]),
        .I3(context_word0[165]),
        .I4(context_word1),
        .O(seg_zc[1]));
  (* SOFT_HLUTNM = "soft_lutpair114" *) 
  LUT4 #(
    .INIT(16'hF77F)) 
    contexts_reg_0_7_165_165_i_2
       (.I0(context_word1),
        .I1(zc_event1),
        .I2(context_word0[323]),
        .I3(sample_data[23]),
        .O(contexts_reg_0_7_165_165_i_2_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "166" *) 
  (* ram_slice_end = "166" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_166_166
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_zc[2]),
        .O(context_word0[166]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT6 #(
    .INIT(64'h8888088800008000)) 
    contexts_reg_0_7_166_166_i_1
       (.I0(contexts_reg_0_7_157_157_i_3_n_0),
        .I1(context_word1),
        .I2(context_word0[165]),
        .I3(context_word0[164]),
        .I4(contexts_reg_0_7_165_165_i_2_n_0),
        .I5(context_word0[166]),
        .O(seg_zc[2]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "167" *) 
  (* ram_slice_end = "167" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_167_167
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_167_167_i_1_n_0),
        .O(context_word0[167]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT5 #(
    .INIT(32'hB4440000)) 
    contexts_reg_0_7_167_167_i_1
       (.I0(contexts_reg_0_7_167_167_i_2_n_0),
        .I1(context_word0[166]),
        .I2(context_word0[167]),
        .I3(context_word1),
        .I4(contexts_reg_0_7_157_157_i_3_n_0),
        .O(contexts_reg_0_7_167_167_i_1_n_0));
  LUT6 #(
    .INIT(64'hFFFF7FFF7FFFFFFF)) 
    contexts_reg_0_7_167_167_i_2
       (.I0(context_word0[165]),
        .I1(context_word0[164]),
        .I2(context_word1),
        .I3(zc_event1),
        .I4(context_word0[323]),
        .I5(sample_data[23]),
        .O(contexts_reg_0_7_167_167_i_2_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "168" *) 
  (* ram_slice_end = "168" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_168_168
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_168_168_i_1_n_0),
        .O(context_word0[168]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT6 #(
    .INIT(64'h9AAA000000000000)) 
    contexts_reg_0_7_168_168_i_1
       (.I0(context_word0[168]),
        .I1(contexts_reg_0_7_167_167_i_2_n_0),
        .I2(context_word0[166]),
        .I3(context_word0[167]),
        .I4(context_word1),
        .I5(contexts_reg_0_7_157_157_i_3_n_0),
        .O(contexts_reg_0_7_168_168_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "169" *) 
  (* ram_slice_end = "169" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_169_169
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_169_169_i_1_n_0),
        .O(context_word0[169]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT4 #(
    .INIT(16'h6A00)) 
    contexts_reg_0_7_169_169_i_1
       (.I0(contexts_reg_0_7_169_169_i_2_n_0),
        .I1(context_word0[169]),
        .I2(context_word1),
        .I3(contexts_reg_0_7_157_157_i_3_n_0),
        .O(contexts_reg_0_7_169_169_i_1_n_0));
  LUT5 #(
    .INIT(32'h20000000)) 
    contexts_reg_0_7_169_169_i_2
       (.I0(context_word0[168]),
        .I1(contexts_reg_0_7_167_167_i_2_n_0),
        .I2(context_word0[166]),
        .I3(context_word0[167]),
        .I4(context_word1),
        .O(contexts_reg_0_7_169_169_i_2_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "16" *) 
  (* ram_slice_end = "16" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_16_16
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(context_next3),
        .O(context_word0[16]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_16_16_i_2_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFFFBFFFFFF)) 
    contexts_reg_0_7_16_16_i_1
       (.I0(contexts_reg_0_7_12_12_i_2_n_0),
        .I1(context_word0[16]),
        .I2(context_word0[12]),
        .I3(context_word1),
        .I4(context_word0[14]),
        .I5(contexts_reg_0_7_16_16_i_3_n_0),
        .O(context_next3));
  LUT3 #(
    .INIT(8'hA2)) 
    contexts_reg_0_7_16_16_i_2
       (.I0(p_3_out),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_16_16_i_2_n_0));
  LUT3 #(
    .INIT(8'hEF)) 
    contexts_reg_0_7_16_16_i_3
       (.I0(context_word0[13]),
        .I1(context_word0[11]),
        .I2(context_word0[15]),
        .O(contexts_reg_0_7_16_16_i_3_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "170" *) 
  (* ram_slice_end = "170" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_170_170
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_170_170_i_1_n_0),
        .O(context_word0[170]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT5 #(
    .INIT(32'h2A800000)) 
    contexts_reg_0_7_170_170_i_1
       (.I0(context_word1),
        .I1(context_word0[169]),
        .I2(contexts_reg_0_7_169_169_i_2_n_0),
        .I3(context_word0[170]),
        .I4(contexts_reg_0_7_157_157_i_3_n_0),
        .O(contexts_reg_0_7_170_170_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "171" *) 
  (* ram_slice_end = "171" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_171_171
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_energy[0]),
        .O(context_word0[171]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_171_171_i_1
       (.I0(completed_energy[0]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_energy[0]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "172" *) 
  (* ram_slice_end = "172" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_172_172
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_energy[1]),
        .O(context_word0[172]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_172_172_i_1
       (.I0(completed_energy[1]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_energy[1]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "173" *) 
  (* ram_slice_end = "173" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_173_173
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_energy[2]),
        .O(context_word0[173]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_173_173_i_1
       (.I0(completed_energy[2]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_energy[2]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "174" *) 
  (* ram_slice_end = "174" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_174_174
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_energy[3]),
        .O(context_word0[174]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_174_174_i_1
       (.I0(completed_energy[3]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_energy[3]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "175" *) 
  (* ram_slice_end = "175" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_175_175
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_energy[4]),
        .O(context_word0[175]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_175_175_i_1
       (.I0(completed_energy[4]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_energy[4]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "176" *) 
  (* ram_slice_end = "176" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_176_176
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_energy[5]),
        .O(context_word0[176]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_176_176_i_1
       (.I0(completed_energy[5]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_energy[5]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "177" *) 
  (* ram_slice_end = "177" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_177_177
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_energy[6]),
        .O(context_word0[177]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_177_177_i_1
       (.I0(completed_energy[6]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_energy[6]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "178" *) 
  (* ram_slice_end = "178" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_178_178
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_energy[7]),
        .O(context_word0[178]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_178_178_i_1
       (.I0(completed_energy[7]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_energy[7]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "179" *) 
  (* ram_slice_end = "179" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_179_179
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_energy[8]),
        .O(context_word0[179]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_179_179_i_1
       (.I0(completed_energy[8]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_energy[8]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "17" *) 
  (* ram_slice_end = "17" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_17_17
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(win_ssc[0]),
        .O(context_word0[17]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_17_17_i_1
       (.I0(\ssc_count_reg[3]_i_1_n_7 ),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(win_ssc[0]));
  LUT3 #(
    .INIT(8'h2A)) 
    contexts_reg_0_7_17_17_i_2
       (.I0(p_3_out),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .I2(context_word1),
        .O(contexts_reg_0_7_17_17_i_2_n_0));
  LUT4 #(
    .INIT(16'hFF7F)) 
    contexts_reg_0_7_17_17_i_3
       (.I0(context_word0[268]),
        .I1(context_word0[267]),
        .I2(context_word1),
        .I3(contexts_reg_0_7_17_17_i_4_n_0),
        .O(contexts_reg_0_7_17_17_i_3_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFFFBFFFFFF)) 
    contexts_reg_0_7_17_17_i_4
       (.I0(context_word0[271]),
        .I1(context_word0[273]),
        .I2(context_word0[269]),
        .I3(context_word0[272]),
        .I4(context_word1),
        .I5(context_word0[270]),
        .O(contexts_reg_0_7_17_17_i_4_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "180" *) 
  (* ram_slice_end = "180" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_180_180
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_energy[9]),
        .O(context_word0[180]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_180_180_i_1
       (.I0(completed_energy[9]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_energy[9]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "181" *) 
  (* ram_slice_end = "181" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_181_181
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_energy[10]),
        .O(context_word0[181]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_181_181_i_1
       (.I0(completed_energy[10]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_energy[10]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "182" *) 
  (* ram_slice_end = "182" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_182_182
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_energy[11]),
        .O(context_word0[182]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_182_182_i_1
       (.I0(completed_energy[11]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_energy[11]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "183" *) 
  (* ram_slice_end = "183" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_183_183
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_energy[12]),
        .O(context_word0[183]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_183_183_i_1
       (.I0(completed_energy[12]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_energy[12]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "184" *) 
  (* ram_slice_end = "184" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_184_184
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_energy[13]),
        .O(context_word0[184]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_184_184_i_1
       (.I0(completed_energy[13]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_energy[13]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "185" *) 
  (* ram_slice_end = "185" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_185_185
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_energy[14]),
        .O(context_word0[185]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_185_185_i_1
       (.I0(completed_energy[14]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_energy[14]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "186" *) 
  (* ram_slice_end = "186" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_186_186
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_energy[15]),
        .O(context_word0[186]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_186_186_i_1
       (.I0(completed_energy[15]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_energy[15]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "187" *) 
  (* ram_slice_end = "187" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_187_187
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_energy[16]),
        .O(context_word0[187]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_187_187_i_1
       (.I0(completed_energy[16]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_energy[16]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "188" *) 
  (* ram_slice_end = "188" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_188_188
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_energy[17]),
        .O(context_word0[188]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_188_188_i_1
       (.I0(completed_energy[17]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_energy[17]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "189" *) 
  (* ram_slice_end = "189" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_189_189
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_energy[18]),
        .O(context_word0[189]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_189_189_i_1
       (.I0(completed_energy[18]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_energy[18]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "18" *) 
  (* ram_slice_end = "18" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_18_18
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(win_ssc[1]),
        .O(context_word0[18]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_18_18_i_1
       (.I0(\ssc_count_reg[3]_i_1_n_6 ),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(win_ssc[1]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "190" *) 
  (* ram_slice_end = "190" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_190_190
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_energy[19]),
        .O(context_word0[190]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_190_190_i_1
       (.I0(completed_energy[19]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_energy[19]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "191" *) 
  (* ram_slice_end = "191" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_191_191
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_energy[20]),
        .O(context_word0[191]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_191_191_i_1
       (.I0(completed_energy[20]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_energy[20]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "192" *) 
  (* ram_slice_end = "192" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_192_192
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_energy[21]),
        .O(context_word0[192]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_192_192_i_1
       (.I0(completed_energy[21]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_energy[21]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "193" *) 
  (* ram_slice_end = "193" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_193_193
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_energy[22]),
        .O(context_word0[193]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_193_193_i_1
       (.I0(completed_energy[22]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_energy[22]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "194" *) 
  (* ram_slice_end = "194" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_194_194
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_energy[23]),
        .O(context_word0[194]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_194_194_i_1
       (.I0(completed_energy[23]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_energy[23]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "195" *) 
  (* ram_slice_end = "195" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_195_195
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_energy[24]),
        .O(context_word0[195]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_195_195_i_1
       (.I0(completed_energy[24]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_energy[24]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "196" *) 
  (* ram_slice_end = "196" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_196_196
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_energy[25]),
        .O(context_word0[196]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_196_196_i_1
       (.I0(completed_energy[25]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_energy[25]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "197" *) 
  (* ram_slice_end = "197" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_197_197
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_energy[26]),
        .O(context_word0[197]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_197_197_i_1
       (.I0(completed_energy[26]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_energy[26]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "198" *) 
  (* ram_slice_end = "198" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_198_198
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_energy[27]),
        .O(context_word0[198]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_198_198_i_1
       (.I0(completed_energy[27]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_energy[27]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "199" *) 
  (* ram_slice_end = "199" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_199_199
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_energy[28]),
        .O(context_word0[199]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_199_199_i_1
       (.I0(completed_energy[28]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_energy[28]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "19" *) 
  (* ram_slice_end = "19" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_19_19
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(win_ssc[2]),
        .O(context_word0[19]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_19_19_i_1
       (.I0(\ssc_count_reg[3]_i_1_n_5 ),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(win_ssc[2]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "1" *) 
  (* ram_slice_end = "1" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_1_1
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_1_1_i_1_n_0),
        .O(context_word0[1]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_0_0_i_2_n_0));
  LUT4 #(
    .INIT(16'h0060)) 
    contexts_reg_0_7_1_1_i_1
       (.I0(context_word0[1]),
        .I1(context_word0[0]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .O(contexts_reg_0_7_1_1_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "200" *) 
  (* ram_slice_end = "200" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_200_200
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_energy[29]),
        .O(context_word0[200]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_200_200_i_1
       (.I0(completed_energy[29]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_energy[29]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "201" *) 
  (* ram_slice_end = "201" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_201_201
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_energy[30]),
        .O(context_word0[201]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_201_201_i_1
       (.I0(completed_energy[30]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_energy[30]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "202" *) 
  (* ram_slice_end = "202" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_202_202
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_energy[31]),
        .O(context_word0[202]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_202_202_i_1
       (.I0(completed_energy[31]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_energy[31]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "203" *) 
  (* ram_slice_end = "203" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_203_203
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_wl[0]),
        .O(context_word0[203]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_203_203_i_1
       (.I0(completed_wl[0]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_wl[0]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "204" *) 
  (* ram_slice_end = "204" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_204_204
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_wl[1]),
        .O(context_word0[204]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_204_204_i_1
       (.I0(completed_wl[1]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_wl[1]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "205" *) 
  (* ram_slice_end = "205" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_205_205
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_wl[2]),
        .O(context_word0[205]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_205_205_i_1
       (.I0(completed_wl[2]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_wl[2]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "206" *) 
  (* ram_slice_end = "206" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_206_206
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_wl[3]),
        .O(context_word0[206]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_206_206_i_1
       (.I0(completed_wl[3]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_wl[3]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "207" *) 
  (* ram_slice_end = "207" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_207_207
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_wl[4]),
        .O(context_word0[207]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_207_207_i_1
       (.I0(completed_wl[4]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_wl[4]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "208" *) 
  (* ram_slice_end = "208" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_208_208
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_wl[5]),
        .O(context_word0[208]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_208_208_i_1
       (.I0(completed_wl[5]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_wl[5]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "209" *) 
  (* ram_slice_end = "209" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_209_209
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_wl[6]),
        .O(context_word0[209]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_209_209_i_1
       (.I0(completed_wl[6]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_wl[6]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "20" *) 
  (* ram_slice_end = "20" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_20_20
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(win_ssc[3]),
        .O(context_word0[20]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_20_20_i_1
       (.I0(\ssc_count_reg[3]_i_1_n_4 ),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(win_ssc[3]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "210" *) 
  (* ram_slice_end = "210" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_210_210
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_wl[7]),
        .O(context_word0[210]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_210_210_i_1
       (.I0(completed_wl[7]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_wl[7]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "211" *) 
  (* ram_slice_end = "211" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_211_211
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_wl[8]),
        .O(context_word0[211]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_211_211_i_1
       (.I0(completed_wl[8]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_wl[8]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "212" *) 
  (* ram_slice_end = "212" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_212_212
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_wl[9]),
        .O(context_word0[212]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_212_212_i_1
       (.I0(completed_wl[9]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_wl[9]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "213" *) 
  (* ram_slice_end = "213" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_213_213
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_wl[10]),
        .O(context_word0[213]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_213_213_i_1
       (.I0(completed_wl[10]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_wl[10]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "214" *) 
  (* ram_slice_end = "214" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_214_214
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_wl[11]),
        .O(context_word0[214]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_214_214_i_1
       (.I0(completed_wl[11]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_wl[11]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "215" *) 
  (* ram_slice_end = "215" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_215_215
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_wl[12]),
        .O(context_word0[215]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_215_215_i_1
       (.I0(completed_wl[12]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_wl[12]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "216" *) 
  (* ram_slice_end = "216" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_216_216
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_wl[13]),
        .O(context_word0[216]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_216_216_i_1
       (.I0(completed_wl[13]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_wl[13]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "217" *) 
  (* ram_slice_end = "217" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_217_217
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_wl[14]),
        .O(context_word0[217]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_217_217_i_1
       (.I0(completed_wl[14]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_wl[14]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "218" *) 
  (* ram_slice_end = "218" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_218_218
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_wl[15]),
        .O(context_word0[218]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_218_218_i_1
       (.I0(completed_wl[15]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_wl[15]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "219" *) 
  (* ram_slice_end = "219" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_219_219
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_wl[16]),
        .O(context_word0[219]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_219_219_i_1
       (.I0(completed_wl[16]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_wl[16]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "21" *) 
  (* ram_slice_end = "21" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_21_21
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(win_ssc[4]),
        .O(context_word0[21]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_21_21_i_1
       (.I0(\ssc_count_reg[7]_i_1_n_7 ),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(win_ssc[4]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "220" *) 
  (* ram_slice_end = "220" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_220_220
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_wl[17]),
        .O(context_word0[220]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_220_220_i_1
       (.I0(completed_wl[17]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_wl[17]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "221" *) 
  (* ram_slice_end = "221" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_221_221
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_wl[18]),
        .O(context_word0[221]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_221_221_i_1
       (.I0(completed_wl[18]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_wl[18]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "222" *) 
  (* ram_slice_end = "222" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_222_222
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_wl[19]),
        .O(context_word0[222]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_222_222_i_1
       (.I0(completed_wl[19]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_wl[19]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "223" *) 
  (* ram_slice_end = "223" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_223_223
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_wl[20]),
        .O(context_word0[223]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_223_223_i_1
       (.I0(completed_wl[20]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_wl[20]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "224" *) 
  (* ram_slice_end = "224" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_224_224
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_wl[21]),
        .O(context_word0[224]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_224_224_i_1
       (.I0(completed_wl[21]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_wl[21]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "225" *) 
  (* ram_slice_end = "225" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_225_225
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_wl[22]),
        .O(context_word0[225]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_225_225_i_1
       (.I0(completed_wl[22]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_wl[22]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "226" *) 
  (* ram_slice_end = "226" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_226_226
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_wl[23]),
        .O(context_word0[226]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_226_226_i_1
       (.I0(completed_wl[23]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_wl[23]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "227" *) 
  (* ram_slice_end = "227" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_227_227
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_wl[24]),
        .O(context_word0[227]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_227_227_i_1
       (.I0(completed_wl[24]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_wl[24]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "228" *) 
  (* ram_slice_end = "228" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_228_228
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_wl[25]),
        .O(context_word0[228]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_228_228_i_1
       (.I0(completed_wl[25]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_wl[25]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "229" *) 
  (* ram_slice_end = "229" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_229_229
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_wl[26]),
        .O(context_word0[229]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_229_229_i_1
       (.I0(completed_wl[26]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_wl[26]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "22" *) 
  (* ram_slice_end = "22" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_22_22
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(win_ssc[5]),
        .O(context_word0[22]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_22_22_i_1
       (.I0(\ssc_count_reg[7]_i_1_n_6 ),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(win_ssc[5]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "230" *) 
  (* ram_slice_end = "230" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_230_230
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_wl[27]),
        .O(context_word0[230]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_230_230_i_1
       (.I0(completed_wl[27]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_wl[27]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "231" *) 
  (* ram_slice_end = "231" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_231_231
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_wl[28]),
        .O(context_word0[231]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_231_231_i_1
       (.I0(completed_wl[28]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_wl[28]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "232" *) 
  (* ram_slice_end = "232" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_232_232
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_wl[29]),
        .O(context_word0[232]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_232_232_i_1
       (.I0(completed_wl[29]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_wl[29]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "233" *) 
  (* ram_slice_end = "233" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_233_233
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_wl[30]),
        .O(context_word0[233]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_233_233_i_1
       (.I0(completed_wl[30]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_wl[30]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "234" *) 
  (* ram_slice_end = "234" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_234_234
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_wl[31]),
        .O(context_word0[234]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_234_234_i_1
       (.I0(completed_wl[31]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_wl[31]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "235" *) 
  (* ram_slice_end = "235" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_235_235
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_mav[0]),
        .O(context_word0[235]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_235_235_i_1
       (.I0(completed_mav[0]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_mav[0]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "236" *) 
  (* ram_slice_end = "236" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_236_236
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_mav[1]),
        .O(context_word0[236]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_236_236_i_1
       (.I0(completed_mav[1]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_mav[1]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "237" *) 
  (* ram_slice_end = "237" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_237_237
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_mav[2]),
        .O(context_word0[237]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_237_237_i_1
       (.I0(completed_mav[2]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_mav[2]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "238" *) 
  (* ram_slice_end = "238" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_238_238
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_mav[3]),
        .O(context_word0[238]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_238_238_i_1
       (.I0(completed_mav[3]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_mav[3]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "239" *) 
  (* ram_slice_end = "239" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_239_239
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_mav[4]),
        .O(context_word0[239]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_239_239_i_1
       (.I0(completed_mav[4]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_mav[4]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "23" *) 
  (* ram_slice_end = "23" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_23_23
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(win_ssc[6]),
        .O(context_word0[23]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_23_23_i_1
       (.I0(\ssc_count_reg[7]_i_1_n_5 ),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(win_ssc[6]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "240" *) 
  (* ram_slice_end = "240" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_240_240
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_mav[5]),
        .O(context_word0[240]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_240_240_i_1
       (.I0(completed_mav[5]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_mav[5]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "241" *) 
  (* ram_slice_end = "241" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_241_241
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_mav[6]),
        .O(context_word0[241]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_241_241_i_1
       (.I0(completed_mav[6]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_mav[6]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "242" *) 
  (* ram_slice_end = "242" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_242_242
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_mav[7]),
        .O(context_word0[242]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_242_242_i_1
       (.I0(completed_mav[7]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_mav[7]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "243" *) 
  (* ram_slice_end = "243" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_243_243
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_mav[8]),
        .O(context_word0[243]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_243_243_i_1
       (.I0(completed_mav[8]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_mav[8]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "244" *) 
  (* ram_slice_end = "244" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_244_244
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_mav[9]),
        .O(context_word0[244]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_244_244_i_1
       (.I0(completed_mav[9]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_mav[9]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "245" *) 
  (* ram_slice_end = "245" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_245_245
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_mav[10]),
        .O(context_word0[245]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_245_245_i_1
       (.I0(completed_mav[10]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_mav[10]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "246" *) 
  (* ram_slice_end = "246" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_246_246
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_mav[11]),
        .O(context_word0[246]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_246_246_i_1
       (.I0(completed_mav[11]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_mav[11]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "247" *) 
  (* ram_slice_end = "247" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_247_247
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_mav[12]),
        .O(context_word0[247]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_247_247_i_1
       (.I0(completed_mav[12]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_mav[12]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "248" *) 
  (* ram_slice_end = "248" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_248_248
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_mav[13]),
        .O(context_word0[248]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_248_248_i_1
       (.I0(completed_mav[13]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_mav[13]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "249" *) 
  (* ram_slice_end = "249" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_249_249
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_mav[14]),
        .O(context_word0[249]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_249_249_i_1
       (.I0(completed_mav[14]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_mav[14]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "24" *) 
  (* ram_slice_end = "24" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_24_24
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(win_ssc[7]),
        .O(context_word0[24]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_24_24_i_1
       (.I0(\ssc_count_reg[7]_i_1_n_4 ),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(win_ssc[7]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "250" *) 
  (* ram_slice_end = "250" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_250_250
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_mav[15]),
        .O(context_word0[250]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_250_250_i_1
       (.I0(completed_mav[15]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_mav[15]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "251" *) 
  (* ram_slice_end = "251" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_251_251
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_mav[16]),
        .O(context_word0[251]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_251_251_i_1
       (.I0(completed_mav[16]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_mav[16]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "252" *) 
  (* ram_slice_end = "252" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_252_252
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_mav[17]),
        .O(context_word0[252]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_252_252_i_1
       (.I0(completed_mav[17]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_mav[17]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "253" *) 
  (* ram_slice_end = "253" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_253_253
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_mav[18]),
        .O(context_word0[253]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_253_253_i_1
       (.I0(completed_mav[18]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_mav[18]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "254" *) 
  (* ram_slice_end = "254" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_254_254
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_mav[19]),
        .O(context_word0[254]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_254_254_i_1
       (.I0(completed_mav[19]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_mav[19]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "255" *) 
  (* ram_slice_end = "255" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_255_255
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_mav[20]),
        .O(context_word0[255]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_255_255_i_1
       (.I0(completed_mav[20]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_mav[20]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "256" *) 
  (* ram_slice_end = "256" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_256_256
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_mav[21]),
        .O(context_word0[256]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_256_256_i_1
       (.I0(completed_mav[21]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_mav[21]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "257" *) 
  (* ram_slice_end = "257" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_257_257
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_mav[22]),
        .O(context_word0[257]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_257_257_i_1
       (.I0(completed_mav[22]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_mav[22]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "258" *) 
  (* ram_slice_end = "258" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_258_258
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_mav[23]),
        .O(context_word0[258]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_258_258_i_1
       (.I0(completed_mav[23]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_mav[23]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "259" *) 
  (* ram_slice_end = "259" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_259_259
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_mav[24]),
        .O(context_word0[259]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_259_259_i_1
       (.I0(completed_mav[24]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_mav[24]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "25" *) 
  (* ram_slice_end = "25" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_25_25
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(win_ssc[8]),
        .O(context_word0[25]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_25_25_i_1
       (.I0(\ssc_count_reg[8]_i_1_n_7 ),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(win_ssc[8]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "260" *) 
  (* ram_slice_end = "260" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_260_260
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_mav[25]),
        .O(context_word0[260]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_260_260_i_1
       (.I0(completed_mav[25]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_mav[25]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "261" *) 
  (* ram_slice_end = "261" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_261_261
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_mav[26]),
        .O(context_word0[261]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_261_261_i_1
       (.I0(completed_mav[26]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_mav[26]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "262" *) 
  (* ram_slice_end = "262" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_262_262
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_mav[27]),
        .O(context_word0[262]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_262_262_i_1
       (.I0(completed_mav[27]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_mav[27]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "263" *) 
  (* ram_slice_end = "263" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_263_263
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_mav[28]),
        .O(context_word0[263]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_263_263_i_1
       (.I0(completed_mav[28]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_mav[28]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "264" *) 
  (* ram_slice_end = "264" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_264_264
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_mav[29]),
        .O(context_word0[264]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_264_264_i_1
       (.I0(completed_mav[29]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_mav[29]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "265" *) 
  (* ram_slice_end = "265" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_265_265
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_mav[30]),
        .O(context_word0[265]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_265_265_i_1
       (.I0(completed_mav[30]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_mav[30]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "266" *) 
  (* ram_slice_end = "266" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_266_266
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_mav[31]),
        .O(context_word0[266]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_266_266_i_1
       (.I0(completed_mav[31]),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(seg_mav[31]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "267" *) 
  (* ram_slice_end = "267" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_267_267
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_count[0]),
        .O(context_word0[267]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h7)) 
    contexts_reg_0_7_267_267_i_1
       (.I0(context_word0[267]),
        .I1(context_word1),
        .O(seg_count[0]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "268" *) 
  (* ram_slice_end = "268" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_268_268
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_count[1]),
        .O(context_word0[268]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT3 #(
    .INIT(8'h48)) 
    contexts_reg_0_7_268_268_i_1
       (.I0(context_word0[267]),
        .I1(context_word1),
        .I2(context_word0[268]),
        .O(seg_count[1]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "269" *) 
  (* ram_slice_end = "269" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_269_269
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_count[2]),
        .O(context_word0[269]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT5 #(
    .INIT(32'h08808080)) 
    contexts_reg_0_7_269_269_i_1
       (.I0(contexts_reg_0_7_157_157_i_3_n_0),
        .I1(context_word1),
        .I2(context_word0[269]),
        .I3(context_word0[267]),
        .I4(context_word0[268]),
        .O(seg_count[2]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "26" *) 
  (* ram_slice_end = "26" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_26_26
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(win_zc[0]),
        .O(context_word0[26]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_26_26_i_1
       (.I0(\zc_count_reg[3]_i_1_n_7 ),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(win_zc[0]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "270" *) 
  (* ram_slice_end = "270" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_270_270
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_count[3]),
        .O(context_word0[270]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT5 #(
    .INIT(32'h48888888)) 
    contexts_reg_0_7_270_270_i_1
       (.I0(context_word0[270]),
        .I1(context_word1),
        .I2(context_word0[268]),
        .I3(context_word0[267]),
        .I4(context_word0[269]),
        .O(seg_count[3]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "271" *) 
  (* ram_slice_end = "271" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_271_271
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_count[4]),
        .O(context_word0[271]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT6 #(
    .INIT(64'h7F00FF0080000000)) 
    contexts_reg_0_7_271_271_i_1
       (.I0(context_word0[269]),
        .I1(context_word0[267]),
        .I2(context_word0[268]),
        .I3(context_word1),
        .I4(context_word0[270]),
        .I5(context_word0[271]),
        .O(seg_count[4]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "272" *) 
  (* ram_slice_end = "272" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_272_272
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_count[5]),
        .O(context_word0[272]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT4 #(
    .INIT(16'h1444)) 
    contexts_reg_0_7_272_272_i_1
       (.I0(contexts_reg_0_7_272_272_i_2_n_0),
        .I1(contexts_reg_0_7_272_272_i_3_n_0),
        .I2(context_word0[272]),
        .I3(context_word1),
        .O(seg_count[5]));
  LUT5 #(
    .INIT(32'h0A0A0A2A)) 
    contexts_reg_0_7_272_272_i_2
       (.I0(contexts_reg_0_7_272_272_i_4_n_0),
        .I1(context_word0[269]),
        .I2(context_word1),
        .I3(context_word0[270]),
        .I4(context_word0[271]),
        .O(contexts_reg_0_7_272_272_i_2_n_0));
  LUT6 #(
    .INIT(64'h8000000000000000)) 
    contexts_reg_0_7_272_272_i_3
       (.I0(context_word0[271]),
        .I1(context_word0[270]),
        .I2(context_word1),
        .I3(context_word0[268]),
        .I4(context_word0[267]),
        .I5(context_word0[269]),
        .O(contexts_reg_0_7_272_272_i_3_n_0));
  LUT5 #(
    .INIT(32'h80000000)) 
    contexts_reg_0_7_272_272_i_4
       (.I0(context_word0[268]),
        .I1(context_word0[267]),
        .I2(context_word0[273]),
        .I3(context_word1),
        .I4(context_word0[272]),
        .O(contexts_reg_0_7_272_272_i_4_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "273" *) 
  (* ram_slice_end = "273" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_273_273
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(seg_count[6]),
        .O(context_word0[273]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT5 #(
    .INIT(32'h00004888)) 
    contexts_reg_0_7_273_273_i_1
       (.I0(context_word0[273]),
        .I1(context_word1),
        .I2(contexts_reg_0_7_272_272_i_3_n_0),
        .I3(context_word0[272]),
        .I4(contexts_reg_0_7_272_272_i_2_n_0),
        .O(seg_count[6]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "274" *) 
  (* ram_slice_end = "274" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_274_274
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(context_word1),
        .O(context_word0[274]),
        .WCLK(clk),
        .WE(p_3_out));
  MUXF7 contexts_reg_0_7_274_274_i_1
       (.I0(contexts_reg_0_7_274_274_i_2_n_0),
        .I1(contexts_reg_0_7_274_274_i_3_n_0),
        .O(context_word1),
        .S(sample_channel[2]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    contexts_reg_0_7_274_274_i_2
       (.I0(seen[3]),
        .I1(seen[2]),
        .I2(sample_channel[1]),
        .I3(seen[1]),
        .I4(sample_channel[0]),
        .I5(seen[0]),
        .O(contexts_reg_0_7_274_274_i_2_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    contexts_reg_0_7_274_274_i_3
       (.I0(seen[7]),
        .I1(seen[6]),
        .I2(sample_channel[1]),
        .I3(seen[5]),
        .I4(sample_channel[0]),
        .I5(seen[4]),
        .O(contexts_reg_0_7_274_274_i_3_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "276" *) 
  (* ram_slice_end = "276" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_276_276
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_276_276_i_1_n_0),
        .O(context_word0[276]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_276_276_i_1
       (.I0(context_word0[300]),
        .I1(context_word1),
        .O(contexts_reg_0_7_276_276_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "277" *) 
  (* ram_slice_end = "277" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_277_277
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_277_277_i_1_n_0),
        .O(context_word0[277]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_277_277_i_1
       (.I0(context_word0[301]),
        .I1(context_word1),
        .O(contexts_reg_0_7_277_277_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "278" *) 
  (* ram_slice_end = "278" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_278_278
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_278_278_i_1_n_0),
        .O(context_word0[278]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_278_278_i_1
       (.I0(context_word0[302]),
        .I1(context_word1),
        .O(contexts_reg_0_7_278_278_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "279" *) 
  (* ram_slice_end = "279" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_279_279
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_279_279_i_1_n_0),
        .O(context_word0[279]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_279_279_i_1
       (.I0(context_word0[303]),
        .I1(context_word1),
        .O(contexts_reg_0_7_279_279_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "27" *) 
  (* ram_slice_end = "27" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_27_27
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(win_zc[1]),
        .O(context_word0[27]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_27_27_i_1
       (.I0(\zc_count_reg[3]_i_1_n_6 ),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(win_zc[1]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "280" *) 
  (* ram_slice_end = "280" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_280_280
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_280_280_i_1_n_0),
        .O(context_word0[280]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_280_280_i_1
       (.I0(context_word0[304]),
        .I1(context_word1),
        .O(contexts_reg_0_7_280_280_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "281" *) 
  (* ram_slice_end = "281" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_281_281
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_281_281_i_1_n_0),
        .O(context_word0[281]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_281_281_i_1
       (.I0(context_word0[305]),
        .I1(context_word1),
        .O(contexts_reg_0_7_281_281_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "282" *) 
  (* ram_slice_end = "282" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_282_282
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_282_282_i_1_n_0),
        .O(context_word0[282]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_282_282_i_1
       (.I0(context_word0[306]),
        .I1(context_word1),
        .O(contexts_reg_0_7_282_282_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "283" *) 
  (* ram_slice_end = "283" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_283_283
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_283_283_i_1_n_0),
        .O(context_word0[283]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_283_283_i_1
       (.I0(context_word0[307]),
        .I1(context_word1),
        .O(contexts_reg_0_7_283_283_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "284" *) 
  (* ram_slice_end = "284" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_284_284
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_284_284_i_1_n_0),
        .O(context_word0[284]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_284_284_i_1
       (.I0(context_word0[308]),
        .I1(context_word1),
        .O(contexts_reg_0_7_284_284_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "285" *) 
  (* ram_slice_end = "285" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_285_285
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_285_285_i_1_n_0),
        .O(context_word0[285]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_285_285_i_1
       (.I0(context_word0[309]),
        .I1(context_word1),
        .O(contexts_reg_0_7_285_285_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "286" *) 
  (* ram_slice_end = "286" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_286_286
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_286_286_i_1_n_0),
        .O(context_word0[286]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_286_286_i_1
       (.I0(context_word0[310]),
        .I1(context_word1),
        .O(contexts_reg_0_7_286_286_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "287" *) 
  (* ram_slice_end = "287" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_287_287
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_287_287_i_1_n_0),
        .O(context_word0[287]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_287_287_i_1
       (.I0(context_word0[311]),
        .I1(context_word1),
        .O(contexts_reg_0_7_287_287_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "288" *) 
  (* ram_slice_end = "288" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_288_288
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_288_288_i_1_n_0),
        .O(context_word0[288]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_288_288_i_1
       (.I0(context_word0[312]),
        .I1(context_word1),
        .O(contexts_reg_0_7_288_288_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "289" *) 
  (* ram_slice_end = "289" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_289_289
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_289_289_i_1_n_0),
        .O(context_word0[289]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_289_289_i_1
       (.I0(context_word0[313]),
        .I1(context_word1),
        .O(contexts_reg_0_7_289_289_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "28" *) 
  (* ram_slice_end = "28" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_28_28
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(win_zc[2]),
        .O(context_word0[28]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_28_28_i_1
       (.I0(\zc_count_reg[3]_i_1_n_5 ),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(win_zc[2]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "290" *) 
  (* ram_slice_end = "290" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_290_290
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_290_290_i_1_n_0),
        .O(context_word0[290]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_290_290_i_1
       (.I0(context_word0[314]),
        .I1(context_word1),
        .O(contexts_reg_0_7_290_290_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "291" *) 
  (* ram_slice_end = "291" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_291_291
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_291_291_i_1_n_0),
        .O(context_word0[291]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_291_291_i_1
       (.I0(context_word0[315]),
        .I1(context_word1),
        .O(contexts_reg_0_7_291_291_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "292" *) 
  (* ram_slice_end = "292" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_292_292
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_292_292_i_1_n_0),
        .O(context_word0[292]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_292_292_i_1
       (.I0(context_word0[316]),
        .I1(context_word1),
        .O(contexts_reg_0_7_292_292_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "293" *) 
  (* ram_slice_end = "293" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_293_293
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_293_293_i_1_n_0),
        .O(context_word0[293]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_293_293_i_1
       (.I0(context_word0[317]),
        .I1(context_word1),
        .O(contexts_reg_0_7_293_293_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "294" *) 
  (* ram_slice_end = "294" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_294_294
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_294_294_i_1_n_0),
        .O(context_word0[294]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_294_294_i_1
       (.I0(context_word0[318]),
        .I1(context_word1),
        .O(contexts_reg_0_7_294_294_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "295" *) 
  (* ram_slice_end = "295" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_295_295
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_295_295_i_1_n_0),
        .O(context_word0[295]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_295_295_i_1
       (.I0(context_word0[319]),
        .I1(context_word1),
        .O(contexts_reg_0_7_295_295_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "296" *) 
  (* ram_slice_end = "296" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_296_296
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_296_296_i_1_n_0),
        .O(context_word0[296]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_296_296_i_1
       (.I0(context_word0[320]),
        .I1(context_word1),
        .O(contexts_reg_0_7_296_296_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "297" *) 
  (* ram_slice_end = "297" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_297_297
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_297_297_i_1_n_0),
        .O(context_word0[297]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_297_297_i_1
       (.I0(context_word0[321]),
        .I1(context_word1),
        .O(contexts_reg_0_7_297_297_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "298" *) 
  (* ram_slice_end = "298" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_298_298
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_298_298_i_1_n_0),
        .O(context_word0[298]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_298_298_i_1
       (.I0(context_word0[322]),
        .I1(context_word1),
        .O(contexts_reg_0_7_298_298_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "299" *) 
  (* ram_slice_end = "299" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_299_299
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_299_299_i_1_n_0),
        .O(context_word0[299]),
        .WCLK(clk),
        .WE(p_3_out));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_299_299_i_1
       (.I0(context_word0[323]),
        .I1(context_word1),
        .O(contexts_reg_0_7_299_299_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "29" *) 
  (* ram_slice_end = "29" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_29_29
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(win_zc[3]),
        .O(context_word0[29]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_29_29_i_1
       (.I0(\zc_count_reg[3]_i_1_n_4 ),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(win_zc[3]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "2" *) 
  (* ram_slice_end = "2" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_2_2
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_2_2_i_1_n_0),
        .O(context_word0[2]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_0_0_i_2_n_0));
  LUT6 #(
    .INIT(64'h000000000D00D000)) 
    contexts_reg_0_7_2_2_i_1
       (.I0(context_word0[6]),
        .I1(contexts_reg_0_7_2_2_i_2_n_0),
        .I2(contexts_reg_0_7_2_2_i_3_n_0),
        .I3(context_word1),
        .I4(context_word0[2]),
        .I5(context_word0[16]),
        .O(contexts_reg_0_7_2_2_i_1_n_0));
  LUT6 #(
    .INIT(64'hFFFBFFFFFFFFFFFF)) 
    contexts_reg_0_7_2_2_i_2
       (.I0(context_word0[4]),
        .I1(context_word0[1]),
        .I2(context_word0[2]),
        .I3(context_word0[3]),
        .I4(context_word1),
        .I5(context_word0[5]),
        .O(contexts_reg_0_7_2_2_i_2_n_0));
  (* SOFT_HLUTNM = "soft_lutpair97" *) 
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_2_2_i_3
       (.I0(context_word0[0]),
        .I1(context_word0[1]),
        .O(contexts_reg_0_7_2_2_i_3_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "300" *) 
  (* ram_slice_end = "300" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_300_300
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(sample_data[0]),
        .O(context_word0[300]),
        .WCLK(clk),
        .WE(p_3_out));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "301" *) 
  (* ram_slice_end = "301" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_301_301
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(sample_data[1]),
        .O(context_word0[301]),
        .WCLK(clk),
        .WE(p_3_out));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "302" *) 
  (* ram_slice_end = "302" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_302_302
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(sample_data[2]),
        .O(context_word0[302]),
        .WCLK(clk),
        .WE(p_3_out));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "303" *) 
  (* ram_slice_end = "303" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_303_303
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(sample_data[3]),
        .O(context_word0[303]),
        .WCLK(clk),
        .WE(p_3_out));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "304" *) 
  (* ram_slice_end = "304" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_304_304
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(sample_data[4]),
        .O(context_word0[304]),
        .WCLK(clk),
        .WE(p_3_out));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "305" *) 
  (* ram_slice_end = "305" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_305_305
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(sample_data[5]),
        .O(context_word0[305]),
        .WCLK(clk),
        .WE(p_3_out));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "306" *) 
  (* ram_slice_end = "306" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_306_306
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(sample_data[6]),
        .O(context_word0[306]),
        .WCLK(clk),
        .WE(p_3_out));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "307" *) 
  (* ram_slice_end = "307" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_307_307
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(sample_data[7]),
        .O(context_word0[307]),
        .WCLK(clk),
        .WE(p_3_out));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "308" *) 
  (* ram_slice_end = "308" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_308_308
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(sample_data[8]),
        .O(context_word0[308]),
        .WCLK(clk),
        .WE(p_3_out));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "309" *) 
  (* ram_slice_end = "309" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_309_309
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(sample_data[9]),
        .O(context_word0[309]),
        .WCLK(clk),
        .WE(p_3_out));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "30" *) 
  (* ram_slice_end = "30" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_30_30
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(win_zc[4]),
        .O(context_word0[30]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_30_30_i_1
       (.I0(\zc_count_reg[7]_i_1_n_7 ),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(win_zc[4]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "310" *) 
  (* ram_slice_end = "310" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_310_310
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(sample_data[10]),
        .O(context_word0[310]),
        .WCLK(clk),
        .WE(p_3_out));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "311" *) 
  (* ram_slice_end = "311" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_311_311
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(sample_data[11]),
        .O(context_word0[311]),
        .WCLK(clk),
        .WE(p_3_out));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "312" *) 
  (* ram_slice_end = "312" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_312_312
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(sample_data[12]),
        .O(context_word0[312]),
        .WCLK(clk),
        .WE(p_3_out));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "313" *) 
  (* ram_slice_end = "313" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_313_313
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(sample_data[13]),
        .O(context_word0[313]),
        .WCLK(clk),
        .WE(p_3_out));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "314" *) 
  (* ram_slice_end = "314" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_314_314
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(sample_data[14]),
        .O(context_word0[314]),
        .WCLK(clk),
        .WE(p_3_out));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "315" *) 
  (* ram_slice_end = "315" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_315_315
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(sample_data[15]),
        .O(context_word0[315]),
        .WCLK(clk),
        .WE(p_3_out));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "316" *) 
  (* ram_slice_end = "316" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_316_316
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(sample_data[16]),
        .O(context_word0[316]),
        .WCLK(clk),
        .WE(p_3_out));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "317" *) 
  (* ram_slice_end = "317" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_317_317
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(sample_data[17]),
        .O(context_word0[317]),
        .WCLK(clk),
        .WE(p_3_out));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "318" *) 
  (* ram_slice_end = "318" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_318_318
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(sample_data[18]),
        .O(context_word0[318]),
        .WCLK(clk),
        .WE(p_3_out));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "319" *) 
  (* ram_slice_end = "319" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_319_319
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(sample_data[19]),
        .O(context_word0[319]),
        .WCLK(clk),
        .WE(p_3_out));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "31" *) 
  (* ram_slice_end = "31" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_31_31
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(win_zc[5]),
        .O(context_word0[31]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_31_31_i_1
       (.I0(\zc_count_reg[7]_i_1_n_6 ),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(win_zc[5]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "320" *) 
  (* ram_slice_end = "320" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_320_320
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(sample_data[20]),
        .O(context_word0[320]),
        .WCLK(clk),
        .WE(p_3_out));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "321" *) 
  (* ram_slice_end = "321" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_321_321
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(sample_data[21]),
        .O(context_word0[321]),
        .WCLK(clk),
        .WE(p_3_out));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "322" *) 
  (* ram_slice_end = "322" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_322_322
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(sample_data[22]),
        .O(context_word0[322]),
        .WCLK(clk),
        .WE(p_3_out));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "323" *) 
  (* ram_slice_end = "323" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_323_323
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(sample_data[23]),
        .O(context_word0[323]),
        .WCLK(clk),
        .WE(p_3_out));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "32" *) 
  (* ram_slice_end = "32" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_32_32
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(win_zc[6]),
        .O(context_word0[32]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_32_32_i_1
       (.I0(\zc_count_reg[7]_i_1_n_5 ),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(win_zc[6]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "33" *) 
  (* ram_slice_end = "33" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_33_33
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(win_zc[7]),
        .O(context_word0[33]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_33_33_i_1
       (.I0(\zc_count_reg[7]_i_1_n_4 ),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(win_zc[7]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "34" *) 
  (* ram_slice_end = "34" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_34_34
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(win_zc[8]),
        .O(context_word0[34]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_34_34_i_1
       (.I0(\zc_count_reg[8]_i_1_n_7 ),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(win_zc[8]));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "35" *) 
  (* ram_slice_end = "35" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_35_35
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_35_35_i_1_n_0),
        .O(context_word0[35]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_35_35_i_1
       (.I0(next_energy0[0]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_35_35_i_1_n_0));
  LUT6 #(
    .INIT(64'hD22DFFFF2DD20000)) 
    contexts_reg_0_7_35_35_i_10
       (.I0(next_mav4[14]),
        .I1(context_word0[16]),
        .I2(context_word0[171]),
        .I3(context_word0[35]),
        .I4(context_word1),
        .I5(next_energy1__1[0]),
        .O(contexts_reg_0_7_35_35_i_10_n_0));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT5 #(
    .INIT(32'h10007F5F)) 
    contexts_reg_0_7_35_35_i_11
       (.I0(context_word0[172]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[15]),
        .I4(next_energy1__1[1]),
        .O(contexts_reg_0_7_35_35_i_11_n_0));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT5 #(
    .INIT(32'h5A9AAA6A)) 
    contexts_reg_0_7_35_35_i_12
       (.I0(next_energy1__1[2]),
        .I1(next_mav4[16]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(context_word0[173]),
        .O(contexts_reg_0_7_35_35_i_12_n_0));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT5 #(
    .INIT(32'h95A56555)) 
    contexts_reg_0_7_35_35_i_13
       (.I0(next_energy1__1[1]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[15]),
        .I4(context_word0[172]),
        .O(contexts_reg_0_7_35_35_i_13_n_0));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT5 #(
    .INIT(32'h10007F5F)) 
    contexts_reg_0_7_35_35_i_14
       (.I0(context_word0[173]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[16]),
        .I4(next_energy1__1[2]),
        .O(contexts_reg_0_7_35_35_i_14_n_0));
  (* SOFT_HLUTNM = "soft_lutpair86" *) 
  LUT5 #(
    .INIT(32'hA5655595)) 
    contexts_reg_0_7_35_35_i_15
       (.I0(next_energy1__1[3]),
        .I1(next_mav4[17]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(context_word0[174]),
        .O(contexts_reg_0_7_35_35_i_15_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 contexts_reg_0_7_35_35_i_2
       (.CI(1'b0),
        .CO({contexts_reg_0_7_35_35_i_2_n_0,contexts_reg_0_7_35_35_i_2_n_1,contexts_reg_0_7_35_35_i_2_n_2,contexts_reg_0_7_35_35_i_2_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_35_35_i_3_n_0,contexts_reg_0_7_35_35_i_4_n_0,contexts_reg_0_7_35_35_i_5_n_0,contexts_reg_0_7_35_35_i_6_n_0}),
        .O(next_energy0[3:0]),
        .S({contexts_reg_0_7_35_35_i_7_n_0,contexts_reg_0_7_35_35_i_8_n_0,contexts_reg_0_7_35_35_i_9_n_0,contexts_reg_0_7_35_35_i_10_n_0}));
  LUT4 #(
    .INIT(16'h7111)) 
    contexts_reg_0_7_35_35_i_3
       (.I0(contexts_reg_0_7_35_35_i_11_n_0),
        .I1(contexts_reg_0_7_35_35_i_12_n_0),
        .I2(context_word1),
        .I3(context_word0[37]),
        .O(contexts_reg_0_7_35_35_i_3_n_0));
  LUT5 #(
    .INIT(32'hF0808000)) 
    contexts_reg_0_7_35_35_i_4
       (.I0(context_word0[35]),
        .I1(next_energy1__1[0]),
        .I2(context_word1),
        .I3(context_word0[36]),
        .I4(contexts_reg_0_7_35_35_i_13_n_0),
        .O(contexts_reg_0_7_35_35_i_4_n_0));
  LUT5 #(
    .INIT(32'h9A6A6A6A)) 
    contexts_reg_0_7_35_35_i_5
       (.I0(contexts_reg_0_7_35_35_i_13_n_0),
        .I1(context_word0[36]),
        .I2(context_word1),
        .I3(next_energy1__1[0]),
        .I4(context_word0[35]),
        .O(contexts_reg_0_7_35_35_i_5_n_0));
  LUT4 #(
    .INIT(16'h90A0)) 
    contexts_reg_0_7_35_35_i_6
       (.I0(context_word0[171]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[14]),
        .O(contexts_reg_0_7_35_35_i_6_n_0));
  LUT5 #(
    .INIT(32'h96696969)) 
    contexts_reg_0_7_35_35_i_7
       (.I0(contexts_reg_0_7_35_35_i_3_n_0),
        .I1(contexts_reg_0_7_35_35_i_14_n_0),
        .I2(contexts_reg_0_7_35_35_i_15_n_0),
        .I3(context_word0[38]),
        .I4(context_word1),
        .O(contexts_reg_0_7_35_35_i_7_n_0));
  LUT5 #(
    .INIT(32'h69999666)) 
    contexts_reg_0_7_35_35_i_8
       (.I0(contexts_reg_0_7_35_35_i_4_n_0),
        .I1(contexts_reg_0_7_35_35_i_11_n_0),
        .I2(context_word1),
        .I3(context_word0[37]),
        .I4(contexts_reg_0_7_35_35_i_12_n_0),
        .O(contexts_reg_0_7_35_35_i_8_n_0));
  LUT5 #(
    .INIT(32'h55555595)) 
    contexts_reg_0_7_35_35_i_9
       (.I0(contexts_reg_0_7_35_35_i_5_n_0),
        .I1(next_mav4[14]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(context_word0[171]),
        .O(contexts_reg_0_7_35_35_i_9_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "36" *) 
  (* ram_slice_end = "36" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_36_36
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_36_36_i_1_n_0),
        .O(context_word0[36]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_36_36_i_1
       (.I0(next_energy0[1]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_36_36_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "37" *) 
  (* ram_slice_end = "37" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_37_37
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_37_37_i_1_n_0),
        .O(context_word0[37]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_37_37_i_1
       (.I0(next_energy0[2]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_37_37_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "38" *) 
  (* ram_slice_end = "38" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_38_38
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_38_38_i_1_n_0),
        .O(context_word0[38]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_38_38_i_1
       (.I0(next_energy0[3]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_38_38_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "39" *) 
  (* ram_slice_end = "39" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_39_39
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_39_39_i_1_n_0),
        .O(context_word0[39]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_39_39_i_1
       (.I0(next_energy0[4]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_39_39_i_1_n_0));
  LUT5 #(
    .INIT(32'h96666999)) 
    contexts_reg_0_7_39_39_i_10
       (.I0(contexts_reg_0_7_39_39_i_6_n_0),
        .I1(contexts_reg_0_7_39_39_i_15_n_0),
        .I2(context_word0[39]),
        .I3(context_word1),
        .I4(contexts_reg_0_7_39_39_i_22_n_0),
        .O(contexts_reg_0_7_39_39_i_10_n_0));
  (* SOFT_HLUTNM = "soft_lutpair191" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_39_39_i_11
       (.I0(next_mav4[19]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_39_39_i_11_n_0));
  (* SOFT_HLUTNM = "soft_lutpair83" *) 
  LUT5 #(
    .INIT(32'hA5655595)) 
    contexts_reg_0_7_39_39_i_12
       (.I0(next_energy1__1[6]),
        .I1(next_mav4[20]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(context_word0[177]),
        .O(contexts_reg_0_7_39_39_i_12_n_0));
  (* SOFT_HLUTNM = "soft_lutpair84" *) 
  LUT5 #(
    .INIT(32'h5A9AAA6A)) 
    contexts_reg_0_7_39_39_i_13
       (.I0(next_energy1__1[5]),
        .I1(next_mav4[19]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(context_word0[176]),
        .O(contexts_reg_0_7_39_39_i_13_n_0));
  (* SOFT_HLUTNM = "soft_lutpair192" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_39_39_i_14
       (.I0(next_mav4[18]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_39_39_i_14_n_0));
  (* SOFT_HLUTNM = "soft_lutpair85" *) 
  LUT5 #(
    .INIT(32'h5A9AAA6A)) 
    contexts_reg_0_7_39_39_i_15
       (.I0(next_energy1__1[4]),
        .I1(next_mav4[18]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(context_word0[175]),
        .O(contexts_reg_0_7_39_39_i_15_n_0));
  (* SOFT_HLUTNM = "soft_lutpair192" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_39_39_i_16
       (.I0(next_mav4[17]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_39_39_i_16_n_0));
  (* SOFT_HLUTNM = "soft_lutpair193" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_39_39_i_17
       (.I0(next_mav4[16]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_39_39_i_17_n_0));
  (* SOFT_HLUTNM = "soft_lutpair82" *) 
  LUT5 #(
    .INIT(32'h5A9AAA6A)) 
    contexts_reg_0_7_39_39_i_18
       (.I0(next_energy1__1[7]),
        .I1(next_mav4[21]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(context_word0[178]),
        .O(contexts_reg_0_7_39_39_i_18_n_0));
  (* SOFT_HLUTNM = "soft_lutpair83" *) 
  LUT5 #(
    .INIT(32'hFFBF8C00)) 
    contexts_reg_0_7_39_39_i_19
       (.I0(context_word0[16]),
        .I1(context_word1),
        .I2(next_mav4[20]),
        .I3(context_word0[177]),
        .I4(next_energy1__1[6]),
        .O(contexts_reg_0_7_39_39_i_19_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 contexts_reg_0_7_39_39_i_2
       (.CI(contexts_reg_0_7_35_35_i_2_n_0),
        .CO({contexts_reg_0_7_39_39_i_2_n_0,contexts_reg_0_7_39_39_i_2_n_1,contexts_reg_0_7_39_39_i_2_n_2,contexts_reg_0_7_39_39_i_2_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_39_39_i_3_n_0,contexts_reg_0_7_39_39_i_4_n_0,contexts_reg_0_7_39_39_i_5_n_0,contexts_reg_0_7_39_39_i_6_n_0}),
        .O(next_energy0[7:4]),
        .S({contexts_reg_0_7_39_39_i_7_n_0,contexts_reg_0_7_39_39_i_8_n_0,contexts_reg_0_7_39_39_i_9_n_0,contexts_reg_0_7_39_39_i_10_n_0}));
  (* SOFT_HLUTNM = "soft_lutpair84" *) 
  LUT5 #(
    .INIT(32'hEEAA8EAA)) 
    contexts_reg_0_7_39_39_i_20
       (.I0(next_energy1__1[5]),
        .I1(context_word0[176]),
        .I2(next_mav4[19]),
        .I3(context_word1),
        .I4(context_word0[16]),
        .O(contexts_reg_0_7_39_39_i_20_n_0));
  (* SOFT_HLUTNM = "soft_lutpair85" *) 
  LUT5 #(
    .INIT(32'hFFBF8C00)) 
    contexts_reg_0_7_39_39_i_21
       (.I0(context_word0[16]),
        .I1(context_word1),
        .I2(next_mav4[18]),
        .I3(context_word0[175]),
        .I4(next_energy1__1[4]),
        .O(contexts_reg_0_7_39_39_i_21_n_0));
  (* SOFT_HLUTNM = "soft_lutpair86" *) 
  LUT5 #(
    .INIT(32'hFFBF8C00)) 
    contexts_reg_0_7_39_39_i_22
       (.I0(context_word0[16]),
        .I1(context_word1),
        .I2(next_mav4[17]),
        .I3(context_word0[174]),
        .I4(next_energy1__1[3]),
        .O(contexts_reg_0_7_39_39_i_22_n_0));
  LUT6 #(
    .INIT(64'hEAEEC0EC80A80000)) 
    contexts_reg_0_7_39_39_i_3
       (.I0(context_word1),
        .I1(next_energy1__1[5]),
        .I2(context_word0[176]),
        .I3(contexts_reg_0_7_39_39_i_11_n_0),
        .I4(context_word0[41]),
        .I5(contexts_reg_0_7_39_39_i_12_n_0),
        .O(contexts_reg_0_7_39_39_i_3_n_0));
  LUT6 #(
    .INIT(64'hD5D540D540C44040)) 
    contexts_reg_0_7_39_39_i_4
       (.I0(contexts_reg_0_7_39_39_i_13_n_0),
        .I1(context_word1),
        .I2(context_word0[40]),
        .I3(contexts_reg_0_7_39_39_i_14_n_0),
        .I4(context_word0[175]),
        .I5(next_energy1__1[4]),
        .O(contexts_reg_0_7_39_39_i_4_n_0));
  LUT6 #(
    .INIT(64'hD5D540D540C44040)) 
    contexts_reg_0_7_39_39_i_5
       (.I0(contexts_reg_0_7_39_39_i_15_n_0),
        .I1(context_word1),
        .I2(context_word0[39]),
        .I3(contexts_reg_0_7_39_39_i_16_n_0),
        .I4(context_word0[174]),
        .I5(next_energy1__1[3]),
        .O(contexts_reg_0_7_39_39_i_5_n_0));
  LUT6 #(
    .INIT(64'hEFCCAF088C080000)) 
    contexts_reg_0_7_39_39_i_6
       (.I0(context_word0[173]),
        .I1(context_word1),
        .I2(contexts_reg_0_7_39_39_i_17_n_0),
        .I3(next_energy1__1[2]),
        .I4(context_word0[38]),
        .I5(contexts_reg_0_7_35_35_i_15_n_0),
        .O(contexts_reg_0_7_39_39_i_6_n_0));
  LUT5 #(
    .INIT(32'h96666999)) 
    contexts_reg_0_7_39_39_i_7
       (.I0(contexts_reg_0_7_39_39_i_3_n_0),
        .I1(contexts_reg_0_7_39_39_i_18_n_0),
        .I2(context_word0[42]),
        .I3(context_word1),
        .I4(contexts_reg_0_7_39_39_i_19_n_0),
        .O(contexts_reg_0_7_39_39_i_7_n_0));
  LUT5 #(
    .INIT(32'h69999666)) 
    contexts_reg_0_7_39_39_i_8
       (.I0(contexts_reg_0_7_39_39_i_4_n_0),
        .I1(contexts_reg_0_7_39_39_i_20_n_0),
        .I2(context_word1),
        .I3(context_word0[41]),
        .I4(contexts_reg_0_7_39_39_i_12_n_0),
        .O(contexts_reg_0_7_39_39_i_8_n_0));
  LUT5 #(
    .INIT(32'h956A6A95)) 
    contexts_reg_0_7_39_39_i_9
       (.I0(contexts_reg_0_7_39_39_i_5_n_0),
        .I1(context_word0[40]),
        .I2(context_word1),
        .I3(contexts_reg_0_7_39_39_i_13_n_0),
        .I4(contexts_reg_0_7_39_39_i_21_n_0),
        .O(contexts_reg_0_7_39_39_i_9_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "3" *) 
  (* ram_slice_end = "3" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_3_3
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_3_3_i_1_n_0),
        .O(context_word0[3]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_0_0_i_2_n_0));
  LUT6 #(
    .INIT(64'h2AAAAAAA80000000)) 
    contexts_reg_0_7_3_3_i_1
       (.I0(contexts_reg_0_7_3_3_i_2_n_0),
        .I1(context_word0[0]),
        .I2(context_word0[1]),
        .I3(context_word1),
        .I4(context_word0[2]),
        .I5(context_word0[3]),
        .O(contexts_reg_0_7_3_3_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair96" *) 
  LUT4 #(
    .INIT(16'h4050)) 
    contexts_reg_0_7_3_3_i_2
       (.I0(context_word0[16]),
        .I1(contexts_reg_0_7_6_6_i_2_n_0),
        .I2(context_word1),
        .I3(context_word0[6]),
        .O(contexts_reg_0_7_3_3_i_2_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "40" *) 
  (* ram_slice_end = "40" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_40_40
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_40_40_i_1_n_0),
        .O(context_word0[40]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_40_40_i_1
       (.I0(next_energy0[5]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_40_40_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "41" *) 
  (* ram_slice_end = "41" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_41_41
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_41_41_i_1_n_0),
        .O(context_word0[41]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_41_41_i_1
       (.I0(next_energy0[6]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_41_41_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "42" *) 
  (* ram_slice_end = "42" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_42_42
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_42_42_i_1_n_0),
        .O(context_word0[42]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_42_42_i_1
       (.I0(next_energy0[7]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_42_42_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "43" *) 
  (* ram_slice_end = "43" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_43_43
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_43_43_i_1_n_0),
        .O(context_word0[43]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_43_43_i_1
       (.I0(next_energy0[8]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_43_43_i_1_n_0));
  LUT5 #(
    .INIT(32'h96666999)) 
    contexts_reg_0_7_43_43_i_10
       (.I0(contexts_reg_0_7_43_43_i_6_n_0),
        .I1(contexts_reg_0_7_43_43_i_15_n_0),
        .I2(context_word0[43]),
        .I3(context_word1),
        .I4(contexts_reg_0_7_43_43_i_22_n_0),
        .O(contexts_reg_0_7_43_43_i_10_n_0));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT5 #(
    .INIT(32'h5A9AAA6A)) 
    contexts_reg_0_7_43_43_i_11
       (.I0(next_energy1__1[10]),
        .I1(next_mav4[24]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(context_word0[181]),
        .O(contexts_reg_0_7_43_43_i_11_n_0));
  (* SOFT_HLUTNM = "soft_lutpair189" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_43_43_i_12
       (.I0(next_mav4[23]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_43_43_i_12_n_0));
  (* SOFT_HLUTNM = "soft_lutpair80" *) 
  LUT5 #(
    .INIT(32'h5A9AAA6A)) 
    contexts_reg_0_7_43_43_i_13
       (.I0(next_energy1__1[9]),
        .I1(next_mav4[23]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(context_word0[180]),
        .O(contexts_reg_0_7_43_43_i_13_n_0));
  (* SOFT_HLUTNM = "soft_lutpair190" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_43_43_i_14
       (.I0(next_mav4[22]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_43_43_i_14_n_0));
  (* SOFT_HLUTNM = "soft_lutpair81" *) 
  LUT5 #(
    .INIT(32'h5A9AAA6A)) 
    contexts_reg_0_7_43_43_i_15
       (.I0(next_energy1__1[8]),
        .I1(next_mav4[22]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(context_word0[179]),
        .O(contexts_reg_0_7_43_43_i_15_n_0));
  (* SOFT_HLUTNM = "soft_lutpair190" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_43_43_i_16
       (.I0(next_mav4[21]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_43_43_i_16_n_0));
  (* SOFT_HLUTNM = "soft_lutpair191" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_43_43_i_17
       (.I0(next_mav4[20]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_43_43_i_17_n_0));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT5 #(
    .INIT(32'h10007F5F)) 
    contexts_reg_0_7_43_43_i_18
       (.I0(context_word0[181]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[24]),
        .I4(next_energy1__1[10]),
        .O(contexts_reg_0_7_43_43_i_18_n_0));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT5 #(
    .INIT(32'h5A9AAA6A)) 
    contexts_reg_0_7_43_43_i_19
       (.I0(next_energy1__1[11]),
        .I1(next_mav4[25]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(context_word0[182]),
        .O(contexts_reg_0_7_43_43_i_19_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 contexts_reg_0_7_43_43_i_2
       (.CI(contexts_reg_0_7_39_39_i_2_n_0),
        .CO({contexts_reg_0_7_43_43_i_2_n_0,contexts_reg_0_7_43_43_i_2_n_1,contexts_reg_0_7_43_43_i_2_n_2,contexts_reg_0_7_43_43_i_2_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_43_43_i_3_n_0,contexts_reg_0_7_43_43_i_4_n_0,contexts_reg_0_7_43_43_i_5_n_0,contexts_reg_0_7_43_43_i_6_n_0}),
        .O(next_energy0[11:8]),
        .S({contexts_reg_0_7_43_43_i_7_n_0,contexts_reg_0_7_43_43_i_8_n_0,contexts_reg_0_7_43_43_i_9_n_0,contexts_reg_0_7_43_43_i_10_n_0}));
  (* SOFT_HLUTNM = "soft_lutpair80" *) 
  LUT5 #(
    .INIT(32'hEFFF80A0)) 
    contexts_reg_0_7_43_43_i_20
       (.I0(context_word0[180]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[23]),
        .I4(next_energy1__1[9]),
        .O(contexts_reg_0_7_43_43_i_20_n_0));
  (* SOFT_HLUTNM = "soft_lutpair81" *) 
  LUT5 #(
    .INIT(32'hEFFF80A0)) 
    contexts_reg_0_7_43_43_i_21
       (.I0(context_word0[179]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[22]),
        .I4(next_energy1__1[8]),
        .O(contexts_reg_0_7_43_43_i_21_n_0));
  (* SOFT_HLUTNM = "soft_lutpair82" *) 
  LUT5 #(
    .INIT(32'hEFFF80A0)) 
    contexts_reg_0_7_43_43_i_22
       (.I0(context_word0[178]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[21]),
        .I4(next_energy1__1[7]),
        .O(contexts_reg_0_7_43_43_i_22_n_0));
  LUT6 #(
    .INIT(64'hD540D5D54040C440)) 
    contexts_reg_0_7_43_43_i_3
       (.I0(contexts_reg_0_7_43_43_i_11_n_0),
        .I1(context_word1),
        .I2(context_word0[45]),
        .I3(context_word0[180]),
        .I4(contexts_reg_0_7_43_43_i_12_n_0),
        .I5(next_energy1__1[9]),
        .O(contexts_reg_0_7_43_43_i_3_n_0));
  LUT6 #(
    .INIT(64'hD540D5D54040C440)) 
    contexts_reg_0_7_43_43_i_4
       (.I0(contexts_reg_0_7_43_43_i_13_n_0),
        .I1(context_word1),
        .I2(context_word0[44]),
        .I3(context_word0[179]),
        .I4(contexts_reg_0_7_43_43_i_14_n_0),
        .I5(next_energy1__1[8]),
        .O(contexts_reg_0_7_43_43_i_4_n_0));
  LUT6 #(
    .INIT(64'hD540D5D54040C440)) 
    contexts_reg_0_7_43_43_i_5
       (.I0(contexts_reg_0_7_43_43_i_15_n_0),
        .I1(context_word1),
        .I2(context_word0[43]),
        .I3(context_word0[178]),
        .I4(contexts_reg_0_7_43_43_i_16_n_0),
        .I5(next_energy1__1[7]),
        .O(contexts_reg_0_7_43_43_i_5_n_0));
  LUT6 #(
    .INIT(64'hD5D540D540C44040)) 
    contexts_reg_0_7_43_43_i_6
       (.I0(contexts_reg_0_7_39_39_i_18_n_0),
        .I1(context_word1),
        .I2(context_word0[42]),
        .I3(contexts_reg_0_7_43_43_i_17_n_0),
        .I4(context_word0[177]),
        .I5(next_energy1__1[6]),
        .O(contexts_reg_0_7_43_43_i_6_n_0));
  LUT5 #(
    .INIT(32'h69999666)) 
    contexts_reg_0_7_43_43_i_7
       (.I0(contexts_reg_0_7_43_43_i_3_n_0),
        .I1(contexts_reg_0_7_43_43_i_18_n_0),
        .I2(context_word1),
        .I3(context_word0[46]),
        .I4(contexts_reg_0_7_43_43_i_19_n_0),
        .O(contexts_reg_0_7_43_43_i_7_n_0));
  LUT5 #(
    .INIT(32'h956A6A95)) 
    contexts_reg_0_7_43_43_i_8
       (.I0(contexts_reg_0_7_43_43_i_4_n_0),
        .I1(context_word0[45]),
        .I2(context_word1),
        .I3(contexts_reg_0_7_43_43_i_11_n_0),
        .I4(contexts_reg_0_7_43_43_i_20_n_0),
        .O(contexts_reg_0_7_43_43_i_8_n_0));
  LUT5 #(
    .INIT(32'h96666999)) 
    contexts_reg_0_7_43_43_i_9
       (.I0(contexts_reg_0_7_43_43_i_5_n_0),
        .I1(contexts_reg_0_7_43_43_i_13_n_0),
        .I2(context_word0[44]),
        .I3(context_word1),
        .I4(contexts_reg_0_7_43_43_i_21_n_0),
        .O(contexts_reg_0_7_43_43_i_9_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "44" *) 
  (* ram_slice_end = "44" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_44_44
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_44_44_i_1_n_0),
        .O(context_word0[44]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_44_44_i_1
       (.I0(next_energy0[9]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_44_44_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "45" *) 
  (* ram_slice_end = "45" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_45_45
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_45_45_i_1_n_0),
        .O(context_word0[45]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_45_45_i_1
       (.I0(next_energy0[10]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_45_45_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "46" *) 
  (* ram_slice_end = "46" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_46_46
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_46_46_i_1_n_0),
        .O(context_word0[46]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_46_46_i_1
       (.I0(next_energy0[11]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_46_46_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "47" *) 
  (* ram_slice_end = "47" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_47_47
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_47_47_i_1_n_0),
        .O(context_word0[47]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_47_47_i_1
       (.I0(next_energy0[12]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_47_47_i_1_n_0));
  LUT5 #(
    .INIT(32'h96696969)) 
    contexts_reg_0_7_47_47_i_10
       (.I0(contexts_reg_0_7_47_47_i_6_n_0),
        .I1(contexts_reg_0_7_47_47_i_21_n_0),
        .I2(contexts_reg_0_7_47_47_i_16_n_0),
        .I3(context_word0[47]),
        .I4(context_word1),
        .O(contexts_reg_0_7_47_47_i_10_n_0));
  (* SOFT_HLUTNM = "soft_lutpair77" *) 
  LUT5 #(
    .INIT(32'hA5655595)) 
    contexts_reg_0_7_47_47_i_11
       (.I0(next_energy1__1[14]),
        .I1(next_mav4[28]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(context_word0[185]),
        .O(contexts_reg_0_7_47_47_i_11_n_0));
  (* SOFT_HLUTNM = "soft_lutpair188" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_47_47_i_12
       (.I0(next_mav4[27]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_47_47_i_12_n_0));
  (* SOFT_HLUTNM = "soft_lutpair78" *) 
  LUT5 #(
    .INIT(32'hA5655595)) 
    contexts_reg_0_7_47_47_i_13
       (.I0(next_energy1__1[13]),
        .I1(next_mav4[27]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(context_word0[184]),
        .O(contexts_reg_0_7_47_47_i_13_n_0));
  (* SOFT_HLUTNM = "soft_lutpair79" *) 
  LUT5 #(
    .INIT(32'hEFFF80A0)) 
    contexts_reg_0_7_47_47_i_14
       (.I0(context_word0[183]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[26]),
        .I4(next_energy1__1[12]),
        .O(contexts_reg_0_7_47_47_i_14_n_0));
  (* SOFT_HLUTNM = "soft_lutpair188" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_47_47_i_15
       (.I0(next_mav4[25]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_47_47_i_15_n_0));
  (* SOFT_HLUTNM = "soft_lutpair79" *) 
  LUT5 #(
    .INIT(32'h96559955)) 
    contexts_reg_0_7_47_47_i_16
       (.I0(next_energy1__1[12]),
        .I1(context_word0[183]),
        .I2(context_word0[16]),
        .I3(context_word1),
        .I4(next_mav4[26]),
        .O(contexts_reg_0_7_47_47_i_16_n_0));
  (* SOFT_HLUTNM = "soft_lutpair189" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_47_47_i_17
       (.I0(next_mav4[24]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_47_47_i_17_n_0));
  (* SOFT_HLUTNM = "soft_lutpair76" *) 
  LUT5 #(
    .INIT(32'h5A9AAA6A)) 
    contexts_reg_0_7_47_47_i_18
       (.I0(next_energy1__1[15]),
        .I1(next_mav4[29]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(context_word0[186]),
        .O(contexts_reg_0_7_47_47_i_18_n_0));
  (* SOFT_HLUTNM = "soft_lutpair77" *) 
  LUT5 #(
    .INIT(32'hFFBF8C00)) 
    contexts_reg_0_7_47_47_i_19
       (.I0(context_word0[16]),
        .I1(context_word1),
        .I2(next_mav4[28]),
        .I3(context_word0[185]),
        .I4(next_energy1__1[14]),
        .O(contexts_reg_0_7_47_47_i_19_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 contexts_reg_0_7_47_47_i_2
       (.CI(contexts_reg_0_7_43_43_i_2_n_0),
        .CO({contexts_reg_0_7_47_47_i_2_n_0,contexts_reg_0_7_47_47_i_2_n_1,contexts_reg_0_7_47_47_i_2_n_2,contexts_reg_0_7_47_47_i_2_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_47_47_i_3_n_0,contexts_reg_0_7_47_47_i_4_n_0,contexts_reg_0_7_47_47_i_5_n_0,contexts_reg_0_7_47_47_i_6_n_0}),
        .O(next_energy0[15:12]),
        .S({contexts_reg_0_7_47_47_i_7_n_0,contexts_reg_0_7_47_47_i_8_n_0,contexts_reg_0_7_47_47_i_9_n_0,contexts_reg_0_7_47_47_i_10_n_0}));
  (* SOFT_HLUTNM = "soft_lutpair78" *) 
  LUT5 #(
    .INIT(32'hFFBF8C00)) 
    contexts_reg_0_7_47_47_i_20
       (.I0(context_word0[16]),
        .I1(context_word1),
        .I2(next_mav4[27]),
        .I3(context_word0[184]),
        .I4(next_energy1__1[13]),
        .O(contexts_reg_0_7_47_47_i_20_n_0));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT5 #(
    .INIT(32'h10007F5F)) 
    contexts_reg_0_7_47_47_i_21
       (.I0(context_word0[182]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[25]),
        .I4(next_energy1__1[11]),
        .O(contexts_reg_0_7_47_47_i_21_n_0));
  LUT6 #(
    .INIT(64'hF8F880F880A88080)) 
    contexts_reg_0_7_47_47_i_3
       (.I0(context_word1),
        .I1(context_word0[49]),
        .I2(contexts_reg_0_7_47_47_i_11_n_0),
        .I3(contexts_reg_0_7_47_47_i_12_n_0),
        .I4(context_word0[184]),
        .I5(next_energy1__1[13]),
        .O(contexts_reg_0_7_47_47_i_3_n_0));
  (* HLUTNM = "lutpair0" *) 
  LUT4 #(
    .INIT(16'hF880)) 
    contexts_reg_0_7_47_47_i_4
       (.I0(context_word1),
        .I1(context_word0[48]),
        .I2(contexts_reg_0_7_47_47_i_13_n_0),
        .I3(contexts_reg_0_7_47_47_i_14_n_0),
        .O(contexts_reg_0_7_47_47_i_4_n_0));
  LUT6 #(
    .INIT(64'hEFCCAF088C080000)) 
    contexts_reg_0_7_47_47_i_5
       (.I0(context_word0[182]),
        .I1(context_word1),
        .I2(contexts_reg_0_7_47_47_i_15_n_0),
        .I3(next_energy1__1[11]),
        .I4(context_word0[47]),
        .I5(contexts_reg_0_7_47_47_i_16_n_0),
        .O(contexts_reg_0_7_47_47_i_5_n_0));
  LUT6 #(
    .INIT(64'h8C08EFCC0000AF08)) 
    contexts_reg_0_7_47_47_i_6
       (.I0(context_word0[181]),
        .I1(context_word1),
        .I2(contexts_reg_0_7_47_47_i_17_n_0),
        .I3(next_energy1__1[10]),
        .I4(contexts_reg_0_7_43_43_i_19_n_0),
        .I5(context_word0[46]),
        .O(contexts_reg_0_7_47_47_i_6_n_0));
  LUT5 #(
    .INIT(32'h96666999)) 
    contexts_reg_0_7_47_47_i_7
       (.I0(contexts_reg_0_7_47_47_i_3_n_0),
        .I1(contexts_reg_0_7_47_47_i_18_n_0),
        .I2(context_word0[50]),
        .I3(context_word1),
        .I4(contexts_reg_0_7_47_47_i_19_n_0),
        .O(contexts_reg_0_7_47_47_i_7_n_0));
  LUT5 #(
    .INIT(32'h6A95956A)) 
    contexts_reg_0_7_47_47_i_8
       (.I0(contexts_reg_0_7_47_47_i_4_n_0),
        .I1(context_word1),
        .I2(context_word0[49]),
        .I3(contexts_reg_0_7_47_47_i_11_n_0),
        .I4(contexts_reg_0_7_47_47_i_20_n_0),
        .O(contexts_reg_0_7_47_47_i_8_n_0));
  (* HLUTNM = "lutpair0" *) 
  LUT5 #(
    .INIT(32'h78878778)) 
    contexts_reg_0_7_47_47_i_9
       (.I0(context_word1),
        .I1(context_word0[48]),
        .I2(contexts_reg_0_7_47_47_i_13_n_0),
        .I3(contexts_reg_0_7_47_47_i_14_n_0),
        .I4(contexts_reg_0_7_47_47_i_5_n_0),
        .O(contexts_reg_0_7_47_47_i_9_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "48" *) 
  (* ram_slice_end = "48" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_48_48
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_48_48_i_1_n_0),
        .O(context_word0[48]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_48_48_i_1
       (.I0(next_energy0[13]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_48_48_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "49" *) 
  (* ram_slice_end = "49" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_49_49
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_49_49_i_1_n_0),
        .O(context_word0[49]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_49_49_i_1
       (.I0(next_energy0[14]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_49_49_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "4" *) 
  (* ram_slice_end = "4" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_4_4
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_4_4_i_1_n_0),
        .O(context_word0[4]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_0_0_i_2_n_0));
  LUT4 #(
    .INIT(16'h8A20)) 
    contexts_reg_0_7_4_4_i_1
       (.I0(contexts_reg_0_7_3_3_i_2_n_0),
        .I1(contexts_reg_0_7_4_4_i_2_n_0),
        .I2(context_word0[3]),
        .I3(context_word0[4]),
        .O(contexts_reg_0_7_4_4_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair97" *) 
  LUT4 #(
    .INIT(16'h7FFF)) 
    contexts_reg_0_7_4_4_i_2
       (.I0(context_word0[0]),
        .I1(context_word0[1]),
        .I2(context_word1),
        .I3(context_word0[2]),
        .O(contexts_reg_0_7_4_4_i_2_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "50" *) 
  (* ram_slice_end = "50" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_50_50
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_50_50_i_1_n_0),
        .O(context_word0[50]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_50_50_i_1
       (.I0(next_energy0[15]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_50_50_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "51" *) 
  (* ram_slice_end = "51" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_51_51
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_51_51_i_1_n_0),
        .O(context_word0[51]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_51_51_i_1
       (.I0(next_energy0[16]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_51_51_i_1_n_0));
  LUT5 #(
    .INIT(32'h6A95956A)) 
    contexts_reg_0_7_51_51_i_10
       (.I0(contexts_reg_0_7_51_51_i_6_n_0),
        .I1(context_word1),
        .I2(context_word0[51]),
        .I3(contexts_reg_0_7_51_51_i_14_n_0),
        .I4(contexts_reg_0_7_51_51_i_21_n_0),
        .O(contexts_reg_0_7_51_51_i_10_n_0));
  (* SOFT_HLUTNM = "soft_lutpair185" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_51_51_i_11
       (.I0(next_mav4[31]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_51_51_i_11_n_0));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT5 #(
    .INIT(32'h5A9AAA6A)) 
    contexts_reg_0_7_51_51_i_12
       (.I0(next_energy1__1[18]),
        .I1(next_mav4[32]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(context_word0[189]),
        .O(contexts_reg_0_7_51_51_i_12_n_0));
  (* SOFT_HLUTNM = "soft_lutpair75" *) 
  LUT5 #(
    .INIT(32'hEFFF80A0)) 
    contexts_reg_0_7_51_51_i_13
       (.I0(context_word0[187]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[30]),
        .I4(next_energy1__1[16]),
        .O(contexts_reg_0_7_51_51_i_13_n_0));
  (* SOFT_HLUTNM = "soft_lutpair75" *) 
  LUT5 #(
    .INIT(32'h96559955)) 
    contexts_reg_0_7_51_51_i_14
       (.I0(next_energy1__1[16]),
        .I1(context_word0[187]),
        .I2(context_word0[16]),
        .I3(context_word1),
        .I4(next_mav4[30]),
        .O(contexts_reg_0_7_51_51_i_14_n_0));
  (* SOFT_HLUTNM = "soft_lutpair187" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_51_51_i_15
       (.I0(next_mav4[29]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_51_51_i_15_n_0));
  (* SOFT_HLUTNM = "soft_lutpair187" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_51_51_i_16
       (.I0(next_mav4[28]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_51_51_i_16_n_0));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT5 #(
    .INIT(32'h10007F5F)) 
    contexts_reg_0_7_51_51_i_17
       (.I0(context_word0[189]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[32]),
        .I4(next_energy1__1[18]),
        .O(contexts_reg_0_7_51_51_i_17_n_0));
  (* SOFT_HLUTNM = "soft_lutpair74" *) 
  LUT5 #(
    .INIT(32'hA5655595)) 
    contexts_reg_0_7_51_51_i_18
       (.I0(next_energy1__1[19]),
        .I1(next_mav4[33]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(context_word0[190]),
        .O(contexts_reg_0_7_51_51_i_18_n_0));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT5 #(
    .INIT(32'h10007F5F)) 
    contexts_reg_0_7_51_51_i_19
       (.I0(context_word0[188]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[31]),
        .I4(next_energy1__1[17]),
        .O(contexts_reg_0_7_51_51_i_19_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 contexts_reg_0_7_51_51_i_2
       (.CI(contexts_reg_0_7_47_47_i_2_n_0),
        .CO({contexts_reg_0_7_51_51_i_2_n_0,contexts_reg_0_7_51_51_i_2_n_1,contexts_reg_0_7_51_51_i_2_n_2,contexts_reg_0_7_51_51_i_2_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_51_51_i_3_n_0,contexts_reg_0_7_51_51_i_4_n_0,contexts_reg_0_7_51_51_i_5_n_0,contexts_reg_0_7_51_51_i_6_n_0}),
        .O(next_energy0[19:16]),
        .S({contexts_reg_0_7_51_51_i_7_n_0,contexts_reg_0_7_51_51_i_8_n_0,contexts_reg_0_7_51_51_i_9_n_0,contexts_reg_0_7_51_51_i_10_n_0}));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT5 #(
    .INIT(32'h5A9AAA6A)) 
    contexts_reg_0_7_51_51_i_20
       (.I0(next_energy1__1[17]),
        .I1(next_mav4[31]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(context_word0[188]),
        .O(contexts_reg_0_7_51_51_i_20_n_0));
  (* SOFT_HLUTNM = "soft_lutpair76" *) 
  LUT5 #(
    .INIT(32'hFFBF8C00)) 
    contexts_reg_0_7_51_51_i_21
       (.I0(context_word0[16]),
        .I1(context_word1),
        .I2(next_mav4[29]),
        .I3(context_word0[186]),
        .I4(next_energy1__1[15]),
        .O(contexts_reg_0_7_51_51_i_21_n_0));
  LUT6 #(
    .INIT(64'h8C08EFCC0000AF08)) 
    contexts_reg_0_7_51_51_i_3
       (.I0(context_word0[188]),
        .I1(context_word1),
        .I2(contexts_reg_0_7_51_51_i_11_n_0),
        .I3(next_energy1__1[17]),
        .I4(contexts_reg_0_7_51_51_i_12_n_0),
        .I5(context_word0[53]),
        .O(contexts_reg_0_7_51_51_i_3_n_0));
  LUT6 #(
    .INIT(64'hFFC369C369000000)) 
    contexts_reg_0_7_51_51_i_4
       (.I0(context_word0[188]),
        .I1(contexts_reg_0_7_51_51_i_11_n_0),
        .I2(next_energy1__1[17]),
        .I3(context_word1),
        .I4(context_word0[52]),
        .I5(contexts_reg_0_7_51_51_i_13_n_0),
        .O(contexts_reg_0_7_51_51_i_4_n_0));
  LUT6 #(
    .INIT(64'hF8F880F880A88080)) 
    contexts_reg_0_7_51_51_i_5
       (.I0(context_word1),
        .I1(context_word0[51]),
        .I2(contexts_reg_0_7_51_51_i_14_n_0),
        .I3(contexts_reg_0_7_51_51_i_15_n_0),
        .I4(context_word0[186]),
        .I5(next_energy1__1[15]),
        .O(contexts_reg_0_7_51_51_i_5_n_0));
  LUT6 #(
    .INIT(64'hD5D540D540C44040)) 
    contexts_reg_0_7_51_51_i_6
       (.I0(contexts_reg_0_7_47_47_i_18_n_0),
        .I1(context_word1),
        .I2(context_word0[50]),
        .I3(contexts_reg_0_7_51_51_i_16_n_0),
        .I4(context_word0[185]),
        .I5(next_energy1__1[14]),
        .O(contexts_reg_0_7_51_51_i_6_n_0));
  LUT5 #(
    .INIT(32'h96696969)) 
    contexts_reg_0_7_51_51_i_7
       (.I0(contexts_reg_0_7_51_51_i_3_n_0),
        .I1(contexts_reg_0_7_51_51_i_17_n_0),
        .I2(contexts_reg_0_7_51_51_i_18_n_0),
        .I3(context_word0[54]),
        .I4(context_word1),
        .O(contexts_reg_0_7_51_51_i_7_n_0));
  LUT5 #(
    .INIT(32'h69999666)) 
    contexts_reg_0_7_51_51_i_8
       (.I0(contexts_reg_0_7_51_51_i_4_n_0),
        .I1(contexts_reg_0_7_51_51_i_19_n_0),
        .I2(context_word1),
        .I3(context_word0[53]),
        .I4(contexts_reg_0_7_51_51_i_12_n_0),
        .O(contexts_reg_0_7_51_51_i_8_n_0));
  LUT5 #(
    .INIT(32'h956A6A95)) 
    contexts_reg_0_7_51_51_i_9
       (.I0(contexts_reg_0_7_51_51_i_5_n_0),
        .I1(context_word0[52]),
        .I2(context_word1),
        .I3(contexts_reg_0_7_51_51_i_20_n_0),
        .I4(contexts_reg_0_7_51_51_i_13_n_0),
        .O(contexts_reg_0_7_51_51_i_9_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "52" *) 
  (* ram_slice_end = "52" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_52_52
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_52_52_i_1_n_0),
        .O(context_word0[52]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_52_52_i_1
       (.I0(next_energy0[17]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_52_52_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "53" *) 
  (* ram_slice_end = "53" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_53_53
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_53_53_i_1_n_0),
        .O(context_word0[53]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_53_53_i_1
       (.I0(next_energy0[18]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_53_53_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "54" *) 
  (* ram_slice_end = "54" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_54_54
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_54_54_i_1_n_0),
        .O(context_word0[54]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_54_54_i_1
       (.I0(next_energy0[19]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_54_54_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "55" *) 
  (* ram_slice_end = "55" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_55_55
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_55_55_i_1_n_0),
        .O(context_word0[55]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_55_55_i_1
       (.I0(next_energy0[20]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_55_55_i_1_n_0));
  LUT5 #(
    .INIT(32'h96666999)) 
    contexts_reg_0_7_55_55_i_10
       (.I0(contexts_reg_0_7_55_55_i_6_n_0),
        .I1(contexts_reg_0_7_55_55_i_15_n_0),
        .I2(context_word0[55]),
        .I3(context_word1),
        .I4(contexts_reg_0_7_55_55_i_22_n_0),
        .O(contexts_reg_0_7_55_55_i_10_n_0));
  (* SOFT_HLUTNM = "soft_lutpair71" *) 
  LUT5 #(
    .INIT(32'h5A9AAA6A)) 
    contexts_reg_0_7_55_55_i_11
       (.I0(next_energy1__1[22]),
        .I1(next_mav4[36]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(context_word0[193]),
        .O(contexts_reg_0_7_55_55_i_11_n_0));
  (* SOFT_HLUTNM = "soft_lutpair110" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_55_55_i_12
       (.I0(next_mav4[35]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_55_55_i_12_n_0));
  (* SOFT_HLUTNM = "soft_lutpair72" *) 
  LUT5 #(
    .INIT(32'hA5655595)) 
    contexts_reg_0_7_55_55_i_13
       (.I0(next_energy1__1[21]),
        .I1(next_mav4[35]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(context_word0[192]),
        .O(contexts_reg_0_7_55_55_i_13_n_0));
  (* SOFT_HLUTNM = "soft_lutpair111" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_55_55_i_14
       (.I0(next_mav4[34]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_55_55_i_14_n_0));
  (* SOFT_HLUTNM = "soft_lutpair73" *) 
  LUT5 #(
    .INIT(32'h5A9AAA6A)) 
    contexts_reg_0_7_55_55_i_15
       (.I0(next_energy1__1[20]),
        .I1(next_mav4[34]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(context_word0[191]),
        .O(contexts_reg_0_7_55_55_i_15_n_0));
  (* SOFT_HLUTNM = "soft_lutpair112" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_55_55_i_16
       (.I0(next_mav4[33]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_55_55_i_16_n_0));
  (* SOFT_HLUTNM = "soft_lutpair113" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_55_55_i_17
       (.I0(next_mav4[32]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_55_55_i_17_n_0));
  (* SOFT_HLUTNM = "soft_lutpair71" *) 
  LUT5 #(
    .INIT(32'hEEAA8EAA)) 
    contexts_reg_0_7_55_55_i_18
       (.I0(next_energy1__1[22]),
        .I1(context_word0[193]),
        .I2(next_mav4[36]),
        .I3(context_word1),
        .I4(context_word0[16]),
        .O(contexts_reg_0_7_55_55_i_18_n_0));
  (* SOFT_HLUTNM = "soft_lutpair70" *) 
  LUT5 #(
    .INIT(32'hA5655595)) 
    contexts_reg_0_7_55_55_i_19
       (.I0(next_energy1__1[23]),
        .I1(next_mav4[37]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(context_word0[194]),
        .O(contexts_reg_0_7_55_55_i_19_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 contexts_reg_0_7_55_55_i_2
       (.CI(contexts_reg_0_7_51_51_i_2_n_0),
        .CO({contexts_reg_0_7_55_55_i_2_n_0,contexts_reg_0_7_55_55_i_2_n_1,contexts_reg_0_7_55_55_i_2_n_2,contexts_reg_0_7_55_55_i_2_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_55_55_i_3_n_0,contexts_reg_0_7_55_55_i_4_n_0,contexts_reg_0_7_55_55_i_5_n_0,contexts_reg_0_7_55_55_i_6_n_0}),
        .O(next_energy0[23:20]),
        .S({contexts_reg_0_7_55_55_i_7_n_0,contexts_reg_0_7_55_55_i_8_n_0,contexts_reg_0_7_55_55_i_9_n_0,contexts_reg_0_7_55_55_i_10_n_0}));
  (* SOFT_HLUTNM = "soft_lutpair72" *) 
  LUT5 #(
    .INIT(32'hFFBF8C00)) 
    contexts_reg_0_7_55_55_i_20
       (.I0(context_word0[16]),
        .I1(context_word1),
        .I2(next_mav4[35]),
        .I3(context_word0[192]),
        .I4(next_energy1__1[21]),
        .O(contexts_reg_0_7_55_55_i_20_n_0));
  (* SOFT_HLUTNM = "soft_lutpair73" *) 
  LUT5 #(
    .INIT(32'hFFBF8C00)) 
    contexts_reg_0_7_55_55_i_21
       (.I0(context_word0[16]),
        .I1(context_word1),
        .I2(next_mav4[34]),
        .I3(context_word0[191]),
        .I4(next_energy1__1[20]),
        .O(contexts_reg_0_7_55_55_i_21_n_0));
  (* SOFT_HLUTNM = "soft_lutpair74" *) 
  LUT5 #(
    .INIT(32'hFFBF8C00)) 
    contexts_reg_0_7_55_55_i_22
       (.I0(context_word0[16]),
        .I1(context_word1),
        .I2(next_mav4[33]),
        .I3(context_word0[190]),
        .I4(next_energy1__1[19]),
        .O(contexts_reg_0_7_55_55_i_22_n_0));
  LUT6 #(
    .INIT(64'hD5D540D540C44040)) 
    contexts_reg_0_7_55_55_i_3
       (.I0(contexts_reg_0_7_55_55_i_11_n_0),
        .I1(context_word1),
        .I2(context_word0[57]),
        .I3(contexts_reg_0_7_55_55_i_12_n_0),
        .I4(context_word0[192]),
        .I5(next_energy1__1[21]),
        .O(contexts_reg_0_7_55_55_i_3_n_0));
  LUT6 #(
    .INIT(64'hF8F880F880A88080)) 
    contexts_reg_0_7_55_55_i_4
       (.I0(context_word1),
        .I1(context_word0[56]),
        .I2(contexts_reg_0_7_55_55_i_13_n_0),
        .I3(contexts_reg_0_7_55_55_i_14_n_0),
        .I4(context_word0[191]),
        .I5(next_energy1__1[20]),
        .O(contexts_reg_0_7_55_55_i_4_n_0));
  LUT6 #(
    .INIT(64'hD5D540D540C44040)) 
    contexts_reg_0_7_55_55_i_5
       (.I0(contexts_reg_0_7_55_55_i_15_n_0),
        .I1(context_word1),
        .I2(context_word0[55]),
        .I3(contexts_reg_0_7_55_55_i_16_n_0),
        .I4(context_word0[190]),
        .I5(next_energy1__1[19]),
        .O(contexts_reg_0_7_55_55_i_5_n_0));
  LUT6 #(
    .INIT(64'hEFCCAF088C080000)) 
    contexts_reg_0_7_55_55_i_6
       (.I0(context_word0[189]),
        .I1(context_word1),
        .I2(contexts_reg_0_7_55_55_i_17_n_0),
        .I3(next_energy1__1[18]),
        .I4(context_word0[54]),
        .I5(contexts_reg_0_7_51_51_i_18_n_0),
        .O(contexts_reg_0_7_55_55_i_6_n_0));
  LUT5 #(
    .INIT(32'h69999666)) 
    contexts_reg_0_7_55_55_i_7
       (.I0(contexts_reg_0_7_55_55_i_3_n_0),
        .I1(contexts_reg_0_7_55_55_i_18_n_0),
        .I2(context_word1),
        .I3(context_word0[58]),
        .I4(contexts_reg_0_7_55_55_i_19_n_0),
        .O(contexts_reg_0_7_55_55_i_7_n_0));
  LUT5 #(
    .INIT(32'h96666999)) 
    contexts_reg_0_7_55_55_i_8
       (.I0(contexts_reg_0_7_55_55_i_4_n_0),
        .I1(contexts_reg_0_7_55_55_i_11_n_0),
        .I2(context_word0[57]),
        .I3(context_word1),
        .I4(contexts_reg_0_7_55_55_i_20_n_0),
        .O(contexts_reg_0_7_55_55_i_8_n_0));
  LUT5 #(
    .INIT(32'h6A95956A)) 
    contexts_reg_0_7_55_55_i_9
       (.I0(contexts_reg_0_7_55_55_i_5_n_0),
        .I1(context_word1),
        .I2(context_word0[56]),
        .I3(contexts_reg_0_7_55_55_i_13_n_0),
        .I4(contexts_reg_0_7_55_55_i_21_n_0),
        .O(contexts_reg_0_7_55_55_i_9_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "56" *) 
  (* ram_slice_end = "56" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_56_56
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_56_56_i_1_n_0),
        .O(context_word0[56]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_56_56_i_1
       (.I0(next_energy0[21]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_56_56_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "57" *) 
  (* ram_slice_end = "57" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_57_57
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_57_57_i_1_n_0),
        .O(context_word0[57]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_57_57_i_1
       (.I0(next_energy0[22]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_57_57_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "58" *) 
  (* ram_slice_end = "58" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_58_58
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_58_58_i_1_n_0),
        .O(context_word0[58]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_58_58_i_1
       (.I0(next_energy0[23]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_58_58_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "59" *) 
  (* ram_slice_end = "59" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_59_59
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_59_59_i_1_n_0),
        .O(context_word0[59]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_59_59_i_1
       (.I0(next_energy0[24]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_59_59_i_1_n_0));
  LUT5 #(
    .INIT(32'h96666999)) 
    contexts_reg_0_7_59_59_i_10
       (.I0(contexts_reg_0_7_59_59_i_6_n_0),
        .I1(contexts_reg_0_7_59_59_i_15_n_0),
        .I2(context_word0[59]),
        .I3(context_word1),
        .I4(contexts_reg_0_7_59_59_i_22_n_0),
        .O(contexts_reg_0_7_59_59_i_10_n_0));
  (* SOFT_HLUTNM = "soft_lutpair106" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_59_59_i_11
       (.I0(next_mav4[40]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_59_59_i_11_n_0));
  (* SOFT_HLUTNM = "soft_lutpair69" *) 
  LUT5 #(
    .INIT(32'hEFFF80A0)) 
    contexts_reg_0_7_59_59_i_12
       (.I0(context_word0[196]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[39]),
        .I4(next_energy1__1[25]),
        .O(contexts_reg_0_7_59_59_i_12_n_0));
  (* SOFT_HLUTNM = "soft_lutpair107" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_59_59_i_13
       (.I0(next_mav4[38]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_59_59_i_13_n_0));
  (* SOFT_HLUTNM = "soft_lutpair69" *) 
  LUT5 #(
    .INIT(32'h96559955)) 
    contexts_reg_0_7_59_59_i_14
       (.I0(next_energy1__1[25]),
        .I1(context_word0[196]),
        .I2(context_word0[16]),
        .I3(context_word1),
        .I4(next_mav4[39]),
        .O(contexts_reg_0_7_59_59_i_14_n_0));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT5 #(
    .INIT(32'h5A9AAA6A)) 
    contexts_reg_0_7_59_59_i_15
       (.I0(next_energy1__1[24]),
        .I1(next_mav4[38]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(context_word0[195]),
        .O(contexts_reg_0_7_59_59_i_15_n_0));
  (* SOFT_HLUTNM = "soft_lutpair108" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_59_59_i_16
       (.I0(next_mav4[37]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_59_59_i_16_n_0));
  (* SOFT_HLUTNM = "soft_lutpair109" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_59_59_i_17
       (.I0(next_mav4[36]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_59_59_i_17_n_0));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT5 #(
    .INIT(32'h10007F5F)) 
    contexts_reg_0_7_59_59_i_18
       (.I0(context_word0[197]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[40]),
        .I4(next_energy1__1[26]),
        .O(contexts_reg_0_7_59_59_i_18_n_0));
  (* SOFT_HLUTNM = "soft_lutpair68" *) 
  LUT5 #(
    .INIT(32'hA5655595)) 
    contexts_reg_0_7_59_59_i_19
       (.I0(next_energy1__1[27]),
        .I1(next_mav4[41]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(context_word0[198]),
        .O(contexts_reg_0_7_59_59_i_19_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 contexts_reg_0_7_59_59_i_2
       (.CI(contexts_reg_0_7_55_55_i_2_n_0),
        .CO({contexts_reg_0_7_59_59_i_2_n_0,contexts_reg_0_7_59_59_i_2_n_1,contexts_reg_0_7_59_59_i_2_n_2,contexts_reg_0_7_59_59_i_2_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_59_59_i_3_n_0,contexts_reg_0_7_59_59_i_4_n_0,contexts_reg_0_7_59_59_i_5_n_0,contexts_reg_0_7_59_59_i_6_n_0}),
        .O(next_energy0[27:24]),
        .S({contexts_reg_0_7_59_59_i_7_n_0,contexts_reg_0_7_59_59_i_8_n_0,contexts_reg_0_7_59_59_i_9_n_0,contexts_reg_0_7_59_59_i_10_n_0}));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT5 #(
    .INIT(32'h5A9AAA6A)) 
    contexts_reg_0_7_59_59_i_20
       (.I0(next_energy1__1[26]),
        .I1(next_mav4[40]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(context_word0[197]),
        .O(contexts_reg_0_7_59_59_i_20_n_0));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT5 #(
    .INIT(32'h10007F5F)) 
    contexts_reg_0_7_59_59_i_21
       (.I0(context_word0[195]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[38]),
        .I4(next_energy1__1[24]),
        .O(contexts_reg_0_7_59_59_i_21_n_0));
  (* SOFT_HLUTNM = "soft_lutpair70" *) 
  LUT5 #(
    .INIT(32'hFFBF8C00)) 
    contexts_reg_0_7_59_59_i_22
       (.I0(context_word0[16]),
        .I1(context_word1),
        .I2(next_mav4[37]),
        .I3(context_word0[194]),
        .I4(next_energy1__1[23]),
        .O(contexts_reg_0_7_59_59_i_22_n_0));
  LUT6 #(
    .INIT(64'hFFC369C369000000)) 
    contexts_reg_0_7_59_59_i_3
       (.I0(context_word0[197]),
        .I1(contexts_reg_0_7_59_59_i_11_n_0),
        .I2(next_energy1__1[26]),
        .I3(context_word1),
        .I4(context_word0[61]),
        .I5(contexts_reg_0_7_59_59_i_12_n_0),
        .O(contexts_reg_0_7_59_59_i_3_n_0));
  LUT6 #(
    .INIT(64'hEFCCAF088C080000)) 
    contexts_reg_0_7_59_59_i_4
       (.I0(context_word0[195]),
        .I1(context_word1),
        .I2(contexts_reg_0_7_59_59_i_13_n_0),
        .I3(next_energy1__1[24]),
        .I4(context_word0[60]),
        .I5(contexts_reg_0_7_59_59_i_14_n_0),
        .O(contexts_reg_0_7_59_59_i_4_n_0));
  LUT6 #(
    .INIT(64'hD5D540D540C44040)) 
    contexts_reg_0_7_59_59_i_5
       (.I0(contexts_reg_0_7_59_59_i_15_n_0),
        .I1(context_word1),
        .I2(context_word0[59]),
        .I3(contexts_reg_0_7_59_59_i_16_n_0),
        .I4(context_word0[194]),
        .I5(next_energy1__1[23]),
        .O(contexts_reg_0_7_59_59_i_5_n_0));
  LUT6 #(
    .INIT(64'hEAEEC0EC80A80000)) 
    contexts_reg_0_7_59_59_i_6
       (.I0(context_word1),
        .I1(next_energy1__1[22]),
        .I2(context_word0[193]),
        .I3(contexts_reg_0_7_59_59_i_17_n_0),
        .I4(context_word0[58]),
        .I5(contexts_reg_0_7_55_55_i_19_n_0),
        .O(contexts_reg_0_7_59_59_i_6_n_0));
  LUT5 #(
    .INIT(32'h96696969)) 
    contexts_reg_0_7_59_59_i_7
       (.I0(contexts_reg_0_7_59_59_i_3_n_0),
        .I1(contexts_reg_0_7_59_59_i_18_n_0),
        .I2(contexts_reg_0_7_59_59_i_19_n_0),
        .I3(context_word0[62]),
        .I4(context_word1),
        .O(contexts_reg_0_7_59_59_i_7_n_0));
  LUT5 #(
    .INIT(32'h956A6A95)) 
    contexts_reg_0_7_59_59_i_8
       (.I0(contexts_reg_0_7_59_59_i_4_n_0),
        .I1(context_word0[61]),
        .I2(context_word1),
        .I3(contexts_reg_0_7_59_59_i_20_n_0),
        .I4(contexts_reg_0_7_59_59_i_12_n_0),
        .O(contexts_reg_0_7_59_59_i_8_n_0));
  LUT5 #(
    .INIT(32'h96696969)) 
    contexts_reg_0_7_59_59_i_9
       (.I0(contexts_reg_0_7_59_59_i_5_n_0),
        .I1(contexts_reg_0_7_59_59_i_21_n_0),
        .I2(contexts_reg_0_7_59_59_i_14_n_0),
        .I3(context_word0[60]),
        .I4(context_word1),
        .O(contexts_reg_0_7_59_59_i_9_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "5" *) 
  (* ram_slice_end = "5" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_5_5
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_5_5_i_1_n_0),
        .O(context_word0[5]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_0_0_i_2_n_0));
  LUT6 #(
    .INIT(64'hA2AA080008000800)) 
    contexts_reg_0_7_5_5_i_1
       (.I0(contexts_reg_0_7_3_3_i_2_n_0),
        .I1(context_word0[3]),
        .I2(contexts_reg_0_7_4_4_i_2_n_0),
        .I3(context_word0[4]),
        .I4(context_word0[5]),
        .I5(context_word1),
        .O(contexts_reg_0_7_5_5_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "60" *) 
  (* ram_slice_end = "60" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_60_60
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_60_60_i_1_n_0),
        .O(context_word0[60]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_60_60_i_1
       (.I0(next_energy0[25]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_60_60_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "61" *) 
  (* ram_slice_end = "61" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_61_61
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_61_61_i_1_n_0),
        .O(context_word0[61]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_61_61_i_1
       (.I0(next_energy0[26]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_61_61_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "62" *) 
  (* ram_slice_end = "62" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_62_62
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_62_62_i_1_n_0),
        .O(context_word0[62]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_62_62_i_1
       (.I0(next_energy0[27]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_62_62_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "63" *) 
  (* ram_slice_end = "63" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_63_63
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_63_63_i_1_n_0),
        .O(context_word0[63]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_63_63_i_1
       (.I0(next_energy0[28]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_63_63_i_1_n_0));
  LUT5 #(
    .INIT(32'h96666999)) 
    contexts_reg_0_7_63_63_i_10
       (.I0(contexts_reg_0_7_63_63_i_6_n_0),
        .I1(contexts_reg_0_7_63_63_i_15_n_0),
        .I2(context_word0[63]),
        .I3(context_word1),
        .I4(contexts_reg_0_7_63_63_i_21_n_0),
        .O(contexts_reg_0_7_63_63_i_10_n_0));
  (* SOFT_HLUTNM = "soft_lutpair65" *) 
  LUT5 #(
    .INIT(32'h5A9AAA6A)) 
    contexts_reg_0_7_63_63_i_11
       (.I0(next_energy1__1[30]),
        .I1(next_mav4[44]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(context_word0[201]),
        .O(contexts_reg_0_7_63_63_i_11_n_0));
  (* SOFT_HLUTNM = "soft_lutpair103" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_63_63_i_12
       (.I0(next_mav4[43]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_63_63_i_12_n_0));
  (* SOFT_HLUTNM = "soft_lutpair66" *) 
  LUT5 #(
    .INIT(32'hA5655595)) 
    contexts_reg_0_7_63_63_i_13
       (.I0(next_energy1__1[29]),
        .I1(next_mav4[43]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(context_word0[200]),
        .O(contexts_reg_0_7_63_63_i_13_n_0));
  (* SOFT_HLUTNM = "soft_lutpair104" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_63_63_i_14
       (.I0(next_mav4[42]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_63_63_i_14_n_0));
  (* SOFT_HLUTNM = "soft_lutpair67" *) 
  LUT5 #(
    .INIT(32'h5A9AAA6A)) 
    contexts_reg_0_7_63_63_i_15
       (.I0(next_energy1__1[28]),
        .I1(next_mav4[42]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(context_word0[199]),
        .O(contexts_reg_0_7_63_63_i_15_n_0));
  (* SOFT_HLUTNM = "soft_lutpair105" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_63_63_i_16
       (.I0(next_mav4[41]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_63_63_i_16_n_0));
  (* SOFT_HLUTNM = "soft_lutpair64" *) 
  LUT5 #(
    .INIT(32'hD2002DFF)) 
    contexts_reg_0_7_63_63_i_17
       (.I0(next_mav4[45]),
        .I1(context_word0[16]),
        .I2(context_word0[202]),
        .I3(context_word1),
        .I4(next_energy1__1[31]),
        .O(contexts_reg_0_7_63_63_i_17_n_0));
  (* SOFT_HLUTNM = "soft_lutpair65" *) 
  LUT5 #(
    .INIT(32'hFFBF8C00)) 
    contexts_reg_0_7_63_63_i_18
       (.I0(context_word0[16]),
        .I1(context_word1),
        .I2(next_mav4[44]),
        .I3(context_word0[201]),
        .I4(next_energy1__1[30]),
        .O(contexts_reg_0_7_63_63_i_18_n_0));
  (* SOFT_HLUTNM = "soft_lutpair66" *) 
  LUT5 #(
    .INIT(32'hFFBF8C00)) 
    contexts_reg_0_7_63_63_i_19
       (.I0(context_word0[16]),
        .I1(context_word1),
        .I2(next_mav4[43]),
        .I3(context_word0[200]),
        .I4(next_energy1__1[29]),
        .O(contexts_reg_0_7_63_63_i_19_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 contexts_reg_0_7_63_63_i_2
       (.CI(contexts_reg_0_7_59_59_i_2_n_0),
        .CO({contexts_reg_0_7_63_63_i_2_n_0,contexts_reg_0_7_63_63_i_2_n_1,contexts_reg_0_7_63_63_i_2_n_2,contexts_reg_0_7_63_63_i_2_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_63_63_i_3_n_0,contexts_reg_0_7_63_63_i_4_n_0,contexts_reg_0_7_63_63_i_5_n_0,contexts_reg_0_7_63_63_i_6_n_0}),
        .O(next_energy0[31:28]),
        .S({contexts_reg_0_7_63_63_i_7_n_0,contexts_reg_0_7_63_63_i_8_n_0,contexts_reg_0_7_63_63_i_9_n_0,contexts_reg_0_7_63_63_i_10_n_0}));
  (* SOFT_HLUTNM = "soft_lutpair67" *) 
  LUT5 #(
    .INIT(32'hFFBF8C00)) 
    contexts_reg_0_7_63_63_i_20
       (.I0(context_word0[16]),
        .I1(context_word1),
        .I2(next_mav4[42]),
        .I3(context_word0[199]),
        .I4(next_energy1__1[28]),
        .O(contexts_reg_0_7_63_63_i_20_n_0));
  (* SOFT_HLUTNM = "soft_lutpair68" *) 
  LUT5 #(
    .INIT(32'hFFBF8C00)) 
    contexts_reg_0_7_63_63_i_21
       (.I0(context_word0[16]),
        .I1(context_word1),
        .I2(next_mav4[41]),
        .I3(context_word0[198]),
        .I4(next_energy1__1[27]),
        .O(contexts_reg_0_7_63_63_i_21_n_0));
  LUT6 #(
    .INIT(64'hD5D540D540C44040)) 
    contexts_reg_0_7_63_63_i_3
       (.I0(contexts_reg_0_7_63_63_i_11_n_0),
        .I1(context_word1),
        .I2(context_word0[65]),
        .I3(contexts_reg_0_7_63_63_i_12_n_0),
        .I4(context_word0[200]),
        .I5(next_energy1__1[29]),
        .O(contexts_reg_0_7_63_63_i_3_n_0));
  LUT6 #(
    .INIT(64'hF8F880F880A88080)) 
    contexts_reg_0_7_63_63_i_4
       (.I0(context_word1),
        .I1(context_word0[64]),
        .I2(contexts_reg_0_7_63_63_i_13_n_0),
        .I3(contexts_reg_0_7_63_63_i_14_n_0),
        .I4(context_word0[199]),
        .I5(next_energy1__1[28]),
        .O(contexts_reg_0_7_63_63_i_4_n_0));
  LUT6 #(
    .INIT(64'hD5D540D540C44040)) 
    contexts_reg_0_7_63_63_i_5
       (.I0(contexts_reg_0_7_63_63_i_15_n_0),
        .I1(context_word1),
        .I2(context_word0[63]),
        .I3(contexts_reg_0_7_63_63_i_16_n_0),
        .I4(context_word0[198]),
        .I5(next_energy1__1[27]),
        .O(contexts_reg_0_7_63_63_i_5_n_0));
  LUT6 #(
    .INIT(64'hEFCCAF088C080000)) 
    contexts_reg_0_7_63_63_i_6
       (.I0(context_word0[197]),
        .I1(context_word1),
        .I2(contexts_reg_0_7_59_59_i_11_n_0),
        .I3(next_energy1__1[26]),
        .I4(context_word0[62]),
        .I5(contexts_reg_0_7_59_59_i_19_n_0),
        .O(contexts_reg_0_7_63_63_i_6_n_0));
  LUT5 #(
    .INIT(32'h6A95956A)) 
    contexts_reg_0_7_63_63_i_7
       (.I0(contexts_reg_0_7_63_63_i_3_n_0),
        .I1(context_word1),
        .I2(context_word0[66]),
        .I3(contexts_reg_0_7_63_63_i_17_n_0),
        .I4(contexts_reg_0_7_63_63_i_18_n_0),
        .O(contexts_reg_0_7_63_63_i_7_n_0));
  LUT5 #(
    .INIT(32'h96666999)) 
    contexts_reg_0_7_63_63_i_8
       (.I0(contexts_reg_0_7_63_63_i_4_n_0),
        .I1(contexts_reg_0_7_63_63_i_11_n_0),
        .I2(context_word0[65]),
        .I3(context_word1),
        .I4(contexts_reg_0_7_63_63_i_19_n_0),
        .O(contexts_reg_0_7_63_63_i_8_n_0));
  LUT5 #(
    .INIT(32'h6A95956A)) 
    contexts_reg_0_7_63_63_i_9
       (.I0(contexts_reg_0_7_63_63_i_5_n_0),
        .I1(context_word1),
        .I2(context_word0[64]),
        .I3(contexts_reg_0_7_63_63_i_13_n_0),
        .I4(contexts_reg_0_7_63_63_i_20_n_0),
        .O(contexts_reg_0_7_63_63_i_9_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "64" *) 
  (* ram_slice_end = "64" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_64_64
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_64_64_i_1_n_0),
        .O(context_word0[64]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_64_64_i_1
       (.I0(next_energy0[29]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_64_64_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "65" *) 
  (* ram_slice_end = "65" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_65_65
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_65_65_i_1_n_0),
        .O(context_word0[65]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_65_65_i_1
       (.I0(next_energy0[30]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_65_65_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "66" *) 
  (* ram_slice_end = "66" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_66_66
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_66_66_i_1_n_0),
        .O(context_word0[66]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_66_66_i_1
       (.I0(next_energy0[31]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_66_66_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "67" *) 
  (* ram_slice_end = "67" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_67_67
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_67_67_i_1_n_0),
        .O(context_word0[67]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_67_67_i_1
       (.I0(next_energy0[32]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_67_67_i_1_n_0));
  LUT6 #(
    .INIT(64'h1788E888E8771777)) 
    contexts_reg_0_7_67_67_i_10
       (.I0(contexts_reg_0_7_63_63_i_18_n_0),
        .I1(contexts_reg_0_7_63_63_i_17_n_0),
        .I2(context_word0[66]),
        .I3(context_word1),
        .I4(context_word0[67]),
        .I5(contexts_reg_0_7_67_67_i_12_n_0),
        .O(contexts_reg_0_7_67_67_i_10_n_0));
  (* SOFT_HLUTNM = "soft_lutpair102" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_67_67_i_11
       (.I0(next_mav4[44]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_67_67_i_11_n_0));
  (* SOFT_HLUTNM = "soft_lutpair64" *) 
  LUT5 #(
    .INIT(32'hFF8ADF00)) 
    contexts_reg_0_7_67_67_i_12
       (.I0(context_word1),
        .I1(context_word0[16]),
        .I2(next_mav4[45]),
        .I3(next_energy1__1[31]),
        .I4(context_word0[202]),
        .O(contexts_reg_0_7_67_67_i_12_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 contexts_reg_0_7_67_67_i_2
       (.CI(contexts_reg_0_7_63_63_i_2_n_0),
        .CO({contexts_reg_0_7_67_67_i_2_n_0,contexts_reg_0_7_67_67_i_2_n_1,contexts_reg_0_7_67_67_i_2_n_2,contexts_reg_0_7_67_67_i_2_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_67_67_i_3_n_0,contexts_reg_0_7_67_67_i_4_n_0,contexts_reg_0_7_67_67_i_5_n_0,contexts_reg_0_7_67_67_i_6_n_0}),
        .O(next_energy0[35:32]),
        .S({contexts_reg_0_7_67_67_i_7_n_0,contexts_reg_0_7_67_67_i_8_n_0,contexts_reg_0_7_67_67_i_9_n_0,contexts_reg_0_7_67_67_i_10_n_0}));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_67_67_i_3
       (.I0(context_word0[69]),
        .I1(context_word1),
        .O(contexts_reg_0_7_67_67_i_3_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_67_67_i_4
       (.I0(context_word0[68]),
        .I1(context_word1),
        .O(contexts_reg_0_7_67_67_i_4_n_0));
  LUT6 #(
    .INIT(64'hFEFEEAFEF0F0F0F0)) 
    contexts_reg_0_7_67_67_i_5
       (.I0(context_word0[67]),
        .I1(context_word0[202]),
        .I2(next_energy1__1[31]),
        .I3(next_mav4[45]),
        .I4(context_word0[16]),
        .I5(context_word1),
        .O(contexts_reg_0_7_67_67_i_5_n_0));
  LUT6 #(
    .INIT(64'hF8F880F880A88080)) 
    contexts_reg_0_7_67_67_i_6
       (.I0(context_word1),
        .I1(context_word0[66]),
        .I2(contexts_reg_0_7_63_63_i_17_n_0),
        .I3(contexts_reg_0_7_67_67_i_11_n_0),
        .I4(context_word0[201]),
        .I5(next_energy1__1[30]),
        .O(contexts_reg_0_7_67_67_i_6_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_67_67_i_7
       (.I0(context_word0[69]),
        .I1(context_word1),
        .I2(context_word0[70]),
        .O(contexts_reg_0_7_67_67_i_7_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_67_67_i_8
       (.I0(context_word0[68]),
        .I1(context_word1),
        .I2(context_word0[69]),
        .O(contexts_reg_0_7_67_67_i_8_n_0));
  LUT3 #(
    .INIT(8'h95)) 
    contexts_reg_0_7_67_67_i_9
       (.I0(contexts_reg_0_7_67_67_i_5_n_0),
        .I1(context_word1),
        .I2(context_word0[68]),
        .O(contexts_reg_0_7_67_67_i_9_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "68" *) 
  (* ram_slice_end = "68" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_68_68
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_68_68_i_1_n_0),
        .O(context_word0[68]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_68_68_i_1
       (.I0(next_energy0[33]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_68_68_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "69" *) 
  (* ram_slice_end = "69" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_69_69
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_69_69_i_1_n_0),
        .O(context_word0[69]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_69_69_i_1
       (.I0(next_energy0[34]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_69_69_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "6" *) 
  (* ram_slice_end = "6" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_6_6
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_6_6_i_1_n_0),
        .O(context_word0[6]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_0_0_i_2_n_0));
  LUT6 #(
    .INIT(64'h4005404000000000)) 
    contexts_reg_0_7_6_6_i_1
       (.I0(context_word0[16]),
        .I1(contexts_reg_0_7_6_6_i_2_n_0),
        .I2(context_word0[6]),
        .I3(contexts_reg_0_7_6_6_i_3_n_0),
        .I4(context_word0[5]),
        .I5(context_word1),
        .O(contexts_reg_0_7_6_6_i_1_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFFFDFFFFFF)) 
    contexts_reg_0_7_6_6_i_2
       (.I0(contexts_reg_0_7_6_6_i_4_n_0),
        .I1(context_word0[3]),
        .I2(context_word0[4]),
        .I3(context_word0[0]),
        .I4(context_word0[1]),
        .I5(context_word0[2]),
        .O(contexts_reg_0_7_6_6_i_2_n_0));
  LUT6 #(
    .INIT(64'h7FFFFFFFFFFFFFFF)) 
    contexts_reg_0_7_6_6_i_3
       (.I0(context_word0[3]),
        .I1(context_word0[0]),
        .I2(context_word0[1]),
        .I3(context_word1),
        .I4(context_word0[2]),
        .I5(context_word0[4]),
        .O(contexts_reg_0_7_6_6_i_3_n_0));
  (* SOFT_HLUTNM = "soft_lutpair118" *) 
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_6_6_i_4
       (.I0(context_word0[5]),
        .I1(context_word1),
        .O(contexts_reg_0_7_6_6_i_4_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "70" *) 
  (* ram_slice_end = "70" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_70_70
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_70_70_i_1_n_0),
        .O(context_word0[70]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_70_70_i_1
       (.I0(next_energy0[35]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_70_70_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "71" *) 
  (* ram_slice_end = "71" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_71_71
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_71_71_i_1_n_0),
        .O(context_word0[71]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_71_71_i_1
       (.I0(next_energy0[36]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_71_71_i_1_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 contexts_reg_0_7_71_71_i_2
       (.CI(contexts_reg_0_7_67_67_i_2_n_0),
        .CO({NLW_contexts_reg_0_7_71_71_i_2_CO_UNCONNECTED[3],contexts_reg_0_7_71_71_i_2_n_1,contexts_reg_0_7_71_71_i_2_n_2,contexts_reg_0_7_71_71_i_2_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,contexts_reg_0_7_71_71_i_3_n_0,contexts_reg_0_7_71_71_i_4_n_0,contexts_reg_0_7_71_71_i_5_n_0}),
        .O(next_energy0[39:36]),
        .S({contexts_reg_0_7_71_71_i_6_n_0,contexts_reg_0_7_71_71_i_7_n_0,contexts_reg_0_7_71_71_i_8_n_0,contexts_reg_0_7_71_71_i_9_n_0}));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_71_71_i_3
       (.I0(context_word0[72]),
        .I1(context_word1),
        .O(contexts_reg_0_7_71_71_i_3_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_71_71_i_4
       (.I0(context_word0[71]),
        .I1(context_word1),
        .O(contexts_reg_0_7_71_71_i_4_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    contexts_reg_0_7_71_71_i_5
       (.I0(context_word0[70]),
        .I1(context_word1),
        .O(contexts_reg_0_7_71_71_i_5_n_0));
  LUT3 #(
    .INIT(8'hD7)) 
    contexts_reg_0_7_71_71_i_6
       (.I0(context_word1),
        .I1(context_word0[74]),
        .I2(context_word0[73]),
        .O(contexts_reg_0_7_71_71_i_6_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_71_71_i_7
       (.I0(context_word0[72]),
        .I1(context_word1),
        .I2(context_word0[73]),
        .O(contexts_reg_0_7_71_71_i_7_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_71_71_i_8
       (.I0(context_word0[71]),
        .I1(context_word1),
        .I2(context_word0[72]),
        .O(contexts_reg_0_7_71_71_i_8_n_0));
  LUT3 #(
    .INIT(8'hB7)) 
    contexts_reg_0_7_71_71_i_9
       (.I0(context_word0[70]),
        .I1(context_word1),
        .I2(context_word0[71]),
        .O(contexts_reg_0_7_71_71_i_9_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "72" *) 
  (* ram_slice_end = "72" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_72_72
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_72_72_i_1_n_0),
        .O(context_word0[72]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_72_72_i_1
       (.I0(next_energy0[37]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_72_72_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "73" *) 
  (* ram_slice_end = "73" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_73_73
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_73_73_i_1_n_0),
        .O(context_word0[73]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_73_73_i_1
       (.I0(next_energy0[38]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_73_73_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "74" *) 
  (* ram_slice_end = "74" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_74_74
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_74_74_i_1_n_0),
        .O(context_word0[74]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_74_74_i_1
       (.I0(next_energy0[39]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_74_74_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "75" *) 
  (* ram_slice_end = "75" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_75_75
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_75_75_i_1_n_0),
        .O(context_word0[75]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_75_75_i_1
       (.I0(next_wl0[0]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_75_75_i_1_n_0));
  LUT6 #(
    .INIT(64'hD2002D002D00D200)) 
    contexts_reg_0_7_75_75_i_10
       (.I0(next_mav4[46]),
        .I1(context_word0[16]),
        .I2(context_word0[203]),
        .I3(context_word1),
        .I4(abs_diff3[0]),
        .I5(context_word0[75]),
        .O(contexts_reg_0_7_75_75_i_10_n_0));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT5 #(
    .INIT(32'h10007F5F)) 
    contexts_reg_0_7_75_75_i_11
       (.I0(context_word0[204]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[47]),
        .I4(abs_diff[1]),
        .O(contexts_reg_0_7_75_75_i_11_n_0));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT5 #(
    .INIT(32'h95A56555)) 
    contexts_reg_0_7_75_75_i_12
       (.I0(abs_diff[2]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[48]),
        .I4(context_word0[205]),
        .O(contexts_reg_0_7_75_75_i_12_n_0));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT5 #(
    .INIT(32'h95A56555)) 
    contexts_reg_0_7_75_75_i_13
       (.I0(abs_diff[1]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[47]),
        .I4(context_word0[204]),
        .O(contexts_reg_0_7_75_75_i_13_n_0));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT5 #(
    .INIT(32'h10007F5F)) 
    contexts_reg_0_7_75_75_i_14
       (.I0(context_word0[205]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[48]),
        .I4(abs_diff[2]),
        .O(contexts_reg_0_7_75_75_i_14_n_0));
  LUT6 #(
    .INIT(64'h9AAA6A5A6A5A9AAA)) 
    contexts_reg_0_7_75_75_i_15
       (.I0(abs_diff[3]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[49]),
        .I4(context_word0[206]),
        .I5(context_word0[78]),
        .O(contexts_reg_0_7_75_75_i_15_n_0));
  (* SOFT_HLUTNM = "soft_lutpair185" *) 
  LUT3 #(
    .INIT(8'h80)) 
    contexts_reg_0_7_75_75_i_16
       (.I0(context_word1),
        .I1(context_word0[75]),
        .I2(abs_diff3[0]),
        .O(contexts_reg_0_7_75_75_i_16_n_0));
  LUT6 #(
    .INIT(64'h9AAA6A5A6A5A9AAA)) 
    contexts_reg_0_7_75_75_i_17
       (.I0(abs_diff[2]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[48]),
        .I4(context_word0[205]),
        .I5(context_word0[77]),
        .O(contexts_reg_0_7_75_75_i_17_n_0));
  (* SOFT_HLUTNM = "soft_lutpair101" *) 
  LUT3 #(
    .INIT(8'h08)) 
    contexts_reg_0_7_75_75_i_18
       (.I0(next_mav4[46]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_75_75_i_18_n_0));
  LUT4 #(
    .INIT(16'hA808)) 
    contexts_reg_0_7_75_75_i_19
       (.I0(context_word1),
        .I1(abs_diff1[1]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff3[1]),
        .O(abs_diff[1]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 contexts_reg_0_7_75_75_i_2
       (.CI(1'b0),
        .CO({contexts_reg_0_7_75_75_i_2_n_0,contexts_reg_0_7_75_75_i_2_n_1,contexts_reg_0_7_75_75_i_2_n_2,contexts_reg_0_7_75_75_i_2_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_75_75_i_3_n_0,contexts_reg_0_7_75_75_i_4_n_0,contexts_reg_0_7_75_75_i_5_n_0,contexts_reg_0_7_75_75_i_6_n_0}),
        .O(next_wl0[3:0]),
        .S({contexts_reg_0_7_75_75_i_7_n_0,contexts_reg_0_7_75_75_i_8_n_0,contexts_reg_0_7_75_75_i_9_n_0,contexts_reg_0_7_75_75_i_10_n_0}));
  LUT4 #(
    .INIT(16'hA808)) 
    contexts_reg_0_7_75_75_i_20
       (.I0(context_word1),
        .I1(abs_diff1[2]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff3[2]),
        .O(abs_diff[2]));
  (* SOFT_HLUTNM = "soft_lutpair136" *) 
  LUT4 #(
    .INIT(16'hA808)) 
    contexts_reg_0_7_75_75_i_21
       (.I0(context_word1),
        .I1(abs_diff1[3]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff3[3]),
        .O(abs_diff[3]));
  LUT4 #(
    .INIT(16'hD540)) 
    contexts_reg_0_7_75_75_i_3
       (.I0(contexts_reg_0_7_75_75_i_11_n_0),
        .I1(context_word1),
        .I2(context_word0[77]),
        .I3(contexts_reg_0_7_75_75_i_12_n_0),
        .O(contexts_reg_0_7_75_75_i_3_n_0));
  LUT5 #(
    .INIT(32'hF0808000)) 
    contexts_reg_0_7_75_75_i_4
       (.I0(abs_diff3[0]),
        .I1(context_word0[75]),
        .I2(context_word1),
        .I3(context_word0[76]),
        .I4(contexts_reg_0_7_75_75_i_13_n_0),
        .O(contexts_reg_0_7_75_75_i_4_n_0));
  LUT5 #(
    .INIT(32'h9A6A6A6A)) 
    contexts_reg_0_7_75_75_i_5
       (.I0(contexts_reg_0_7_75_75_i_13_n_0),
        .I1(context_word0[76]),
        .I2(context_word1),
        .I3(context_word0[75]),
        .I4(abs_diff3[0]),
        .O(contexts_reg_0_7_75_75_i_5_n_0));
  LUT4 #(
    .INIT(16'h90A0)) 
    contexts_reg_0_7_75_75_i_6
       (.I0(context_word0[203]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[46]),
        .O(contexts_reg_0_7_75_75_i_6_n_0));
  LUT6 #(
    .INIT(64'h80EA7F157F1580EA)) 
    contexts_reg_0_7_75_75_i_7
       (.I0(contexts_reg_0_7_75_75_i_12_n_0),
        .I1(context_word0[77]),
        .I2(context_word1),
        .I3(contexts_reg_0_7_75_75_i_11_n_0),
        .I4(contexts_reg_0_7_75_75_i_14_n_0),
        .I5(contexts_reg_0_7_75_75_i_15_n_0),
        .O(contexts_reg_0_7_75_75_i_7_n_0));
  LUT6 #(
    .INIT(64'hEE80117F117FEE80)) 
    contexts_reg_0_7_75_75_i_8
       (.I0(contexts_reg_0_7_75_75_i_13_n_0),
        .I1(context_word0[76]),
        .I2(context_word1),
        .I3(contexts_reg_0_7_75_75_i_16_n_0),
        .I4(contexts_reg_0_7_75_75_i_11_n_0),
        .I5(contexts_reg_0_7_75_75_i_17_n_0),
        .O(contexts_reg_0_7_75_75_i_8_n_0));
  LUT6 #(
    .INIT(64'h6A956A95956A6A95)) 
    contexts_reg_0_7_75_75_i_9
       (.I0(contexts_reg_0_7_75_75_i_16_n_0),
        .I1(context_word1),
        .I2(context_word0[76]),
        .I3(contexts_reg_0_7_75_75_i_13_n_0),
        .I4(contexts_reg_0_7_75_75_i_18_n_0),
        .I5(context_word0[203]),
        .O(contexts_reg_0_7_75_75_i_9_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "76" *) 
  (* ram_slice_end = "76" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_76_76
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_76_76_i_1_n_0),
        .O(context_word0[76]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_76_76_i_1
       (.I0(next_wl0[1]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_76_76_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "77" *) 
  (* ram_slice_end = "77" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_77_77
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_77_77_i_1_n_0),
        .O(context_word0[77]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_77_77_i_1
       (.I0(next_wl0[2]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_77_77_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "78" *) 
  (* ram_slice_end = "78" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_78_78
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_78_78_i_1_n_0),
        .O(context_word0[78]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_78_78_i_1
       (.I0(next_wl0[3]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_78_78_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "79" *) 
  (* ram_slice_end = "79" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_79_79
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_79_79_i_1_n_0),
        .O(context_word0[79]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_79_79_i_1
       (.I0(next_wl0[4]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_79_79_i_1_n_0));
  LUT6 #(
    .INIT(64'h80EA7F157F1580EA)) 
    contexts_reg_0_7_79_79_i_10
       (.I0(contexts_reg_0_7_79_79_i_17_n_0),
        .I1(context_word0[78]),
        .I2(context_word1),
        .I3(contexts_reg_0_7_75_75_i_14_n_0),
        .I4(contexts_reg_0_7_79_79_i_15_n_0),
        .I5(contexts_reg_0_7_79_79_i_22_n_0),
        .O(contexts_reg_0_7_79_79_i_10_n_0));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT5 #(
    .INIT(32'h10007F5F)) 
    contexts_reg_0_7_79_79_i_11
       (.I0(context_word0[208]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[51]),
        .I4(abs_diff[5]),
        .O(contexts_reg_0_7_79_79_i_11_n_0));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT5 #(
    .INIT(32'h95A56555)) 
    contexts_reg_0_7_79_79_i_12
       (.I0(abs_diff[6]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[52]),
        .I4(context_word0[209]),
        .O(contexts_reg_0_7_79_79_i_12_n_0));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT5 #(
    .INIT(32'h10007F5F)) 
    contexts_reg_0_7_79_79_i_13
       (.I0(context_word0[207]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[50]),
        .I4(abs_diff[4]),
        .O(contexts_reg_0_7_79_79_i_13_n_0));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT5 #(
    .INIT(32'h95A56555)) 
    contexts_reg_0_7_79_79_i_14
       (.I0(abs_diff[5]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[51]),
        .I4(context_word0[208]),
        .O(contexts_reg_0_7_79_79_i_14_n_0));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT5 #(
    .INIT(32'h10007F5F)) 
    contexts_reg_0_7_79_79_i_15
       (.I0(context_word0[206]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[49]),
        .I4(abs_diff[3]),
        .O(contexts_reg_0_7_79_79_i_15_n_0));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT5 #(
    .INIT(32'h95A56555)) 
    contexts_reg_0_7_79_79_i_16
       (.I0(abs_diff[4]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[50]),
        .I4(context_word0[207]),
        .O(contexts_reg_0_7_79_79_i_16_n_0));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT5 #(
    .INIT(32'h95A56555)) 
    contexts_reg_0_7_79_79_i_17
       (.I0(abs_diff[3]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[49]),
        .I4(context_word0[206]),
        .O(contexts_reg_0_7_79_79_i_17_n_0));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT5 #(
    .INIT(32'h10007F5F)) 
    contexts_reg_0_7_79_79_i_18
       (.I0(context_word0[209]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[52]),
        .I4(abs_diff[6]),
        .O(contexts_reg_0_7_79_79_i_18_n_0));
  LUT6 #(
    .INIT(64'h9AAA6A5A6A5A9AAA)) 
    contexts_reg_0_7_79_79_i_19
       (.I0(abs_diff[7]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[53]),
        .I4(context_word0[210]),
        .I5(context_word0[82]),
        .O(contexts_reg_0_7_79_79_i_19_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 contexts_reg_0_7_79_79_i_2
       (.CI(contexts_reg_0_7_75_75_i_2_n_0),
        .CO({contexts_reg_0_7_79_79_i_2_n_0,contexts_reg_0_7_79_79_i_2_n_1,contexts_reg_0_7_79_79_i_2_n_2,contexts_reg_0_7_79_79_i_2_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_79_79_i_3_n_0,contexts_reg_0_7_79_79_i_4_n_0,contexts_reg_0_7_79_79_i_5_n_0,contexts_reg_0_7_79_79_i_6_n_0}),
        .O(next_wl0[7:4]),
        .S({contexts_reg_0_7_79_79_i_7_n_0,contexts_reg_0_7_79_79_i_8_n_0,contexts_reg_0_7_79_79_i_9_n_0,contexts_reg_0_7_79_79_i_10_n_0}));
  LUT6 #(
    .INIT(64'h9AAA6A5A6A5A9AAA)) 
    contexts_reg_0_7_79_79_i_20
       (.I0(abs_diff[6]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[52]),
        .I4(context_word0[209]),
        .I5(context_word0[81]),
        .O(contexts_reg_0_7_79_79_i_20_n_0));
  LUT6 #(
    .INIT(64'h9AAA6A5A6A5A9AAA)) 
    contexts_reg_0_7_79_79_i_21
       (.I0(abs_diff[5]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[51]),
        .I4(context_word0[208]),
        .I5(context_word0[80]),
        .O(contexts_reg_0_7_79_79_i_21_n_0));
  LUT6 #(
    .INIT(64'h9AAA6A5A6A5A9AAA)) 
    contexts_reg_0_7_79_79_i_22
       (.I0(abs_diff[4]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[50]),
        .I4(context_word0[207]),
        .I5(context_word0[79]),
        .O(contexts_reg_0_7_79_79_i_22_n_0));
  (* SOFT_HLUTNM = "soft_lutpair134" *) 
  LUT4 #(
    .INIT(16'hA808)) 
    contexts_reg_0_7_79_79_i_23
       (.I0(context_word1),
        .I1(abs_diff1[5]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff3[5]),
        .O(abs_diff[5]));
  (* SOFT_HLUTNM = "soft_lutpair133" *) 
  LUT4 #(
    .INIT(16'hA808)) 
    contexts_reg_0_7_79_79_i_24
       (.I0(context_word1),
        .I1(abs_diff1[6]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff3[6]),
        .O(abs_diff[6]));
  (* SOFT_HLUTNM = "soft_lutpair135" *) 
  LUT4 #(
    .INIT(16'hA808)) 
    contexts_reg_0_7_79_79_i_25
       (.I0(context_word1),
        .I1(abs_diff1[4]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff3[4]),
        .O(abs_diff[4]));
  (* SOFT_HLUTNM = "soft_lutpair132" *) 
  LUT4 #(
    .INIT(16'hA808)) 
    contexts_reg_0_7_79_79_i_26
       (.I0(context_word1),
        .I1(abs_diff1[7]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff3[7]),
        .O(abs_diff[7]));
  LUT4 #(
    .INIT(16'hD540)) 
    contexts_reg_0_7_79_79_i_3
       (.I0(contexts_reg_0_7_79_79_i_11_n_0),
        .I1(context_word1),
        .I2(context_word0[81]),
        .I3(contexts_reg_0_7_79_79_i_12_n_0),
        .O(contexts_reg_0_7_79_79_i_3_n_0));
  LUT4 #(
    .INIT(16'hD540)) 
    contexts_reg_0_7_79_79_i_4
       (.I0(contexts_reg_0_7_79_79_i_13_n_0),
        .I1(context_word1),
        .I2(context_word0[80]),
        .I3(contexts_reg_0_7_79_79_i_14_n_0),
        .O(contexts_reg_0_7_79_79_i_4_n_0));
  LUT4 #(
    .INIT(16'hD540)) 
    contexts_reg_0_7_79_79_i_5
       (.I0(contexts_reg_0_7_79_79_i_15_n_0),
        .I1(context_word1),
        .I2(context_word0[79]),
        .I3(contexts_reg_0_7_79_79_i_16_n_0),
        .O(contexts_reg_0_7_79_79_i_5_n_0));
  LUT4 #(
    .INIT(16'hD540)) 
    contexts_reg_0_7_79_79_i_6
       (.I0(contexts_reg_0_7_75_75_i_14_n_0),
        .I1(context_word1),
        .I2(context_word0[78]),
        .I3(contexts_reg_0_7_79_79_i_17_n_0),
        .O(contexts_reg_0_7_79_79_i_6_n_0));
  LUT6 #(
    .INIT(64'h80EA7F157F1580EA)) 
    contexts_reg_0_7_79_79_i_7
       (.I0(contexts_reg_0_7_79_79_i_12_n_0),
        .I1(context_word0[81]),
        .I2(context_word1),
        .I3(contexts_reg_0_7_79_79_i_11_n_0),
        .I4(contexts_reg_0_7_79_79_i_18_n_0),
        .I5(contexts_reg_0_7_79_79_i_19_n_0),
        .O(contexts_reg_0_7_79_79_i_7_n_0));
  LUT6 #(
    .INIT(64'h80EA7F157F1580EA)) 
    contexts_reg_0_7_79_79_i_8
       (.I0(contexts_reg_0_7_79_79_i_14_n_0),
        .I1(context_word0[80]),
        .I2(context_word1),
        .I3(contexts_reg_0_7_79_79_i_13_n_0),
        .I4(contexts_reg_0_7_79_79_i_11_n_0),
        .I5(contexts_reg_0_7_79_79_i_20_n_0),
        .O(contexts_reg_0_7_79_79_i_8_n_0));
  LUT6 #(
    .INIT(64'h80EA7F157F1580EA)) 
    contexts_reg_0_7_79_79_i_9
       (.I0(contexts_reg_0_7_79_79_i_16_n_0),
        .I1(context_word0[79]),
        .I2(context_word1),
        .I3(contexts_reg_0_7_79_79_i_15_n_0),
        .I4(contexts_reg_0_7_79_79_i_13_n_0),
        .I5(contexts_reg_0_7_79_79_i_21_n_0),
        .O(contexts_reg_0_7_79_79_i_9_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "7" *) 
  (* ram_slice_end = "7" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_7_7
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_7_7_i_1_n_0),
        .O(context_word0[7]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_7_7_i_2_n_0));
  LUT3 #(
    .INIT(8'h73)) 
    contexts_reg_0_7_7_7_i_1
       (.I0(context_word0[7]),
        .I1(context_word1),
        .I2(context_word0[16]),
        .O(contexts_reg_0_7_7_7_i_1_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_7_7_i_2
       (.I0(p_3_out),
        .I1(contexts_reg_0_7_7_7_i_3_n_0),
        .O(contexts_reg_0_7_7_7_i_2_n_0));
  LUT6 #(
    .INIT(64'h00400000FFFF0000)) 
    contexts_reg_0_7_7_7_i_3
       (.I0(contexts_reg_0_7_11_11_i_2_n_0),
        .I1(context_word0[14]),
        .I2(context_word0[15]),
        .I3(contexts_reg_0_7_7_7_i_4_n_0),
        .I4(context_word1),
        .I5(context_word0[16]),
        .O(contexts_reg_0_7_7_7_i_3_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFF7FF)) 
    contexts_reg_0_7_7_7_i_4
       (.I0(context_word1),
        .I1(context_word0[9]),
        .I2(context_word0[12]),
        .I3(context_word0[10]),
        .I4(context_word0[11]),
        .I5(context_word0[13]),
        .O(contexts_reg_0_7_7_7_i_4_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "80" *) 
  (* ram_slice_end = "80" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_80_80
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_80_80_i_1_n_0),
        .O(context_word0[80]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_80_80_i_1
       (.I0(next_wl0[5]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_80_80_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "81" *) 
  (* ram_slice_end = "81" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_81_81
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_81_81_i_1_n_0),
        .O(context_word0[81]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_81_81_i_1
       (.I0(next_wl0[6]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_81_81_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "82" *) 
  (* ram_slice_end = "82" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_82_82
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_82_82_i_1_n_0),
        .O(context_word0[82]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_82_82_i_1
       (.I0(next_wl0[7]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_82_82_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "83" *) 
  (* ram_slice_end = "83" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_83_83
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_83_83_i_1_n_0),
        .O(context_word0[83]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_83_83_i_1
       (.I0(next_wl0[8]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_83_83_i_1_n_0));
  LUT6 #(
    .INIT(64'h80EA7F157F1580EA)) 
    contexts_reg_0_7_83_83_i_10
       (.I0(contexts_reg_0_7_83_83_i_17_n_0),
        .I1(context_word0[82]),
        .I2(context_word1),
        .I3(contexts_reg_0_7_79_79_i_18_n_0),
        .I4(contexts_reg_0_7_83_83_i_15_n_0),
        .I5(contexts_reg_0_7_83_83_i_22_n_0),
        .O(contexts_reg_0_7_83_83_i_10_n_0));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT5 #(
    .INIT(32'h10007F5F)) 
    contexts_reg_0_7_83_83_i_11
       (.I0(context_word0[212]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[55]),
        .I4(abs_diff[9]),
        .O(contexts_reg_0_7_83_83_i_11_n_0));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT5 #(
    .INIT(32'h95A56555)) 
    contexts_reg_0_7_83_83_i_12
       (.I0(abs_diff[10]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[56]),
        .I4(context_word0[213]),
        .O(contexts_reg_0_7_83_83_i_12_n_0));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT5 #(
    .INIT(32'h10007F5F)) 
    contexts_reg_0_7_83_83_i_13
       (.I0(context_word0[211]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[54]),
        .I4(abs_diff[8]),
        .O(contexts_reg_0_7_83_83_i_13_n_0));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT5 #(
    .INIT(32'h95A56555)) 
    contexts_reg_0_7_83_83_i_14
       (.I0(abs_diff[9]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[55]),
        .I4(context_word0[212]),
        .O(contexts_reg_0_7_83_83_i_14_n_0));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT5 #(
    .INIT(32'h10007F5F)) 
    contexts_reg_0_7_83_83_i_15
       (.I0(context_word0[210]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[53]),
        .I4(abs_diff[7]),
        .O(contexts_reg_0_7_83_83_i_15_n_0));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT5 #(
    .INIT(32'h95A56555)) 
    contexts_reg_0_7_83_83_i_16
       (.I0(abs_diff[8]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[54]),
        .I4(context_word0[211]),
        .O(contexts_reg_0_7_83_83_i_16_n_0));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT5 #(
    .INIT(32'h95A56555)) 
    contexts_reg_0_7_83_83_i_17
       (.I0(abs_diff[7]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[53]),
        .I4(context_word0[210]),
        .O(contexts_reg_0_7_83_83_i_17_n_0));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT5 #(
    .INIT(32'h10007F5F)) 
    contexts_reg_0_7_83_83_i_18
       (.I0(context_word0[213]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[56]),
        .I4(abs_diff[10]),
        .O(contexts_reg_0_7_83_83_i_18_n_0));
  LUT6 #(
    .INIT(64'h9AAA6A5A6A5A9AAA)) 
    contexts_reg_0_7_83_83_i_19
       (.I0(abs_diff[11]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[57]),
        .I4(context_word0[214]),
        .I5(context_word0[86]),
        .O(contexts_reg_0_7_83_83_i_19_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 contexts_reg_0_7_83_83_i_2
       (.CI(contexts_reg_0_7_79_79_i_2_n_0),
        .CO({contexts_reg_0_7_83_83_i_2_n_0,contexts_reg_0_7_83_83_i_2_n_1,contexts_reg_0_7_83_83_i_2_n_2,contexts_reg_0_7_83_83_i_2_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_83_83_i_3_n_0,contexts_reg_0_7_83_83_i_4_n_0,contexts_reg_0_7_83_83_i_5_n_0,contexts_reg_0_7_83_83_i_6_n_0}),
        .O(next_wl0[11:8]),
        .S({contexts_reg_0_7_83_83_i_7_n_0,contexts_reg_0_7_83_83_i_8_n_0,contexts_reg_0_7_83_83_i_9_n_0,contexts_reg_0_7_83_83_i_10_n_0}));
  LUT6 #(
    .INIT(64'h9AAA6A5A6A5A9AAA)) 
    contexts_reg_0_7_83_83_i_20
       (.I0(abs_diff[10]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[56]),
        .I4(context_word0[213]),
        .I5(context_word0[85]),
        .O(contexts_reg_0_7_83_83_i_20_n_0));
  LUT6 #(
    .INIT(64'h9AAA6A5A6A5A9AAA)) 
    contexts_reg_0_7_83_83_i_21
       (.I0(abs_diff[9]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[55]),
        .I4(context_word0[212]),
        .I5(context_word0[84]),
        .O(contexts_reg_0_7_83_83_i_21_n_0));
  LUT6 #(
    .INIT(64'h9AAA6A5A6A5A9AAA)) 
    contexts_reg_0_7_83_83_i_22
       (.I0(abs_diff[8]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[54]),
        .I4(context_word0[211]),
        .I5(context_word0[83]),
        .O(contexts_reg_0_7_83_83_i_22_n_0));
  (* SOFT_HLUTNM = "soft_lutpair130" *) 
  LUT4 #(
    .INIT(16'hA808)) 
    contexts_reg_0_7_83_83_i_23
       (.I0(context_word1),
        .I1(abs_diff1[9]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff3[9]),
        .O(abs_diff[9]));
  (* SOFT_HLUTNM = "soft_lutpair129" *) 
  LUT4 #(
    .INIT(16'hA808)) 
    contexts_reg_0_7_83_83_i_24
       (.I0(context_word1),
        .I1(abs_diff1[10]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff3[10]),
        .O(abs_diff[10]));
  (* SOFT_HLUTNM = "soft_lutpair131" *) 
  LUT4 #(
    .INIT(16'hA808)) 
    contexts_reg_0_7_83_83_i_25
       (.I0(context_word1),
        .I1(abs_diff1[8]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff3[8]),
        .O(abs_diff[8]));
  (* SOFT_HLUTNM = "soft_lutpair128" *) 
  LUT4 #(
    .INIT(16'hA808)) 
    contexts_reg_0_7_83_83_i_26
       (.I0(context_word1),
        .I1(abs_diff1[11]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff3[11]),
        .O(abs_diff[11]));
  LUT4 #(
    .INIT(16'hD540)) 
    contexts_reg_0_7_83_83_i_3
       (.I0(contexts_reg_0_7_83_83_i_11_n_0),
        .I1(context_word1),
        .I2(context_word0[85]),
        .I3(contexts_reg_0_7_83_83_i_12_n_0),
        .O(contexts_reg_0_7_83_83_i_3_n_0));
  LUT4 #(
    .INIT(16'hD540)) 
    contexts_reg_0_7_83_83_i_4
       (.I0(contexts_reg_0_7_83_83_i_13_n_0),
        .I1(context_word1),
        .I2(context_word0[84]),
        .I3(contexts_reg_0_7_83_83_i_14_n_0),
        .O(contexts_reg_0_7_83_83_i_4_n_0));
  LUT4 #(
    .INIT(16'hD540)) 
    contexts_reg_0_7_83_83_i_5
       (.I0(contexts_reg_0_7_83_83_i_15_n_0),
        .I1(context_word1),
        .I2(context_word0[83]),
        .I3(contexts_reg_0_7_83_83_i_16_n_0),
        .O(contexts_reg_0_7_83_83_i_5_n_0));
  LUT4 #(
    .INIT(16'hD540)) 
    contexts_reg_0_7_83_83_i_6
       (.I0(contexts_reg_0_7_79_79_i_18_n_0),
        .I1(context_word1),
        .I2(context_word0[82]),
        .I3(contexts_reg_0_7_83_83_i_17_n_0),
        .O(contexts_reg_0_7_83_83_i_6_n_0));
  LUT6 #(
    .INIT(64'h80EA7F157F1580EA)) 
    contexts_reg_0_7_83_83_i_7
       (.I0(contexts_reg_0_7_83_83_i_12_n_0),
        .I1(context_word0[85]),
        .I2(context_word1),
        .I3(contexts_reg_0_7_83_83_i_11_n_0),
        .I4(contexts_reg_0_7_83_83_i_18_n_0),
        .I5(contexts_reg_0_7_83_83_i_19_n_0),
        .O(contexts_reg_0_7_83_83_i_7_n_0));
  LUT6 #(
    .INIT(64'h80EA7F157F1580EA)) 
    contexts_reg_0_7_83_83_i_8
       (.I0(contexts_reg_0_7_83_83_i_14_n_0),
        .I1(context_word0[84]),
        .I2(context_word1),
        .I3(contexts_reg_0_7_83_83_i_13_n_0),
        .I4(contexts_reg_0_7_83_83_i_11_n_0),
        .I5(contexts_reg_0_7_83_83_i_20_n_0),
        .O(contexts_reg_0_7_83_83_i_8_n_0));
  LUT6 #(
    .INIT(64'h80EA7F157F1580EA)) 
    contexts_reg_0_7_83_83_i_9
       (.I0(contexts_reg_0_7_83_83_i_16_n_0),
        .I1(context_word0[83]),
        .I2(context_word1),
        .I3(contexts_reg_0_7_83_83_i_15_n_0),
        .I4(contexts_reg_0_7_83_83_i_13_n_0),
        .I5(contexts_reg_0_7_83_83_i_21_n_0),
        .O(contexts_reg_0_7_83_83_i_9_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "84" *) 
  (* ram_slice_end = "84" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_84_84
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_84_84_i_1_n_0),
        .O(context_word0[84]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_84_84_i_1
       (.I0(next_wl0[9]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_84_84_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "85" *) 
  (* ram_slice_end = "85" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_85_85
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_85_85_i_1_n_0),
        .O(context_word0[85]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_85_85_i_1
       (.I0(next_wl0[10]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_85_85_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "86" *) 
  (* ram_slice_end = "86" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_86_86
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_86_86_i_1_n_0),
        .O(context_word0[86]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_86_86_i_1
       (.I0(next_wl0[11]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_86_86_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "87" *) 
  (* ram_slice_end = "87" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_87_87
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_87_87_i_1_n_0),
        .O(context_word0[87]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_87_87_i_1
       (.I0(next_wl0[12]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_87_87_i_1_n_0));
  LUT6 #(
    .INIT(64'h80EA7F157F1580EA)) 
    contexts_reg_0_7_87_87_i_10
       (.I0(contexts_reg_0_7_87_87_i_17_n_0),
        .I1(context_word0[86]),
        .I2(context_word1),
        .I3(contexts_reg_0_7_83_83_i_18_n_0),
        .I4(contexts_reg_0_7_87_87_i_15_n_0),
        .I5(contexts_reg_0_7_87_87_i_22_n_0),
        .O(contexts_reg_0_7_87_87_i_10_n_0));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT5 #(
    .INIT(32'h10007F5F)) 
    contexts_reg_0_7_87_87_i_11
       (.I0(context_word0[216]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[59]),
        .I4(abs_diff[13]),
        .O(contexts_reg_0_7_87_87_i_11_n_0));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT5 #(
    .INIT(32'h95A56555)) 
    contexts_reg_0_7_87_87_i_12
       (.I0(abs_diff[14]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[60]),
        .I4(context_word0[217]),
        .O(contexts_reg_0_7_87_87_i_12_n_0));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT5 #(
    .INIT(32'h10007F5F)) 
    contexts_reg_0_7_87_87_i_13
       (.I0(context_word0[215]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[58]),
        .I4(abs_diff[12]),
        .O(contexts_reg_0_7_87_87_i_13_n_0));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT5 #(
    .INIT(32'h95A56555)) 
    contexts_reg_0_7_87_87_i_14
       (.I0(abs_diff[13]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[59]),
        .I4(context_word0[216]),
        .O(contexts_reg_0_7_87_87_i_14_n_0));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT5 #(
    .INIT(32'h10007F5F)) 
    contexts_reg_0_7_87_87_i_15
       (.I0(context_word0[214]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[57]),
        .I4(abs_diff[11]),
        .O(contexts_reg_0_7_87_87_i_15_n_0));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT5 #(
    .INIT(32'h95A56555)) 
    contexts_reg_0_7_87_87_i_16
       (.I0(abs_diff[12]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[58]),
        .I4(context_word0[215]),
        .O(contexts_reg_0_7_87_87_i_16_n_0));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT5 #(
    .INIT(32'h95A56555)) 
    contexts_reg_0_7_87_87_i_17
       (.I0(abs_diff[11]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[57]),
        .I4(context_word0[214]),
        .O(contexts_reg_0_7_87_87_i_17_n_0));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT5 #(
    .INIT(32'h10007F5F)) 
    contexts_reg_0_7_87_87_i_18
       (.I0(context_word0[217]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[60]),
        .I4(abs_diff[14]),
        .O(contexts_reg_0_7_87_87_i_18_n_0));
  LUT6 #(
    .INIT(64'h9AAA6A5A6A5A9AAA)) 
    contexts_reg_0_7_87_87_i_19
       (.I0(abs_diff[15]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[61]),
        .I4(context_word0[218]),
        .I5(context_word0[90]),
        .O(contexts_reg_0_7_87_87_i_19_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 contexts_reg_0_7_87_87_i_2
       (.CI(contexts_reg_0_7_83_83_i_2_n_0),
        .CO({contexts_reg_0_7_87_87_i_2_n_0,contexts_reg_0_7_87_87_i_2_n_1,contexts_reg_0_7_87_87_i_2_n_2,contexts_reg_0_7_87_87_i_2_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_87_87_i_3_n_0,contexts_reg_0_7_87_87_i_4_n_0,contexts_reg_0_7_87_87_i_5_n_0,contexts_reg_0_7_87_87_i_6_n_0}),
        .O(next_wl0[15:12]),
        .S({contexts_reg_0_7_87_87_i_7_n_0,contexts_reg_0_7_87_87_i_8_n_0,contexts_reg_0_7_87_87_i_9_n_0,contexts_reg_0_7_87_87_i_10_n_0}));
  LUT6 #(
    .INIT(64'h9AAA6A5A6A5A9AAA)) 
    contexts_reg_0_7_87_87_i_20
       (.I0(abs_diff[14]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[60]),
        .I4(context_word0[217]),
        .I5(context_word0[89]),
        .O(contexts_reg_0_7_87_87_i_20_n_0));
  LUT6 #(
    .INIT(64'h9AAA6A5A6A5A9AAA)) 
    contexts_reg_0_7_87_87_i_21
       (.I0(abs_diff[13]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[59]),
        .I4(context_word0[216]),
        .I5(context_word0[88]),
        .O(contexts_reg_0_7_87_87_i_21_n_0));
  LUT6 #(
    .INIT(64'h9AAA6A5A6A5A9AAA)) 
    contexts_reg_0_7_87_87_i_22
       (.I0(abs_diff[12]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[58]),
        .I4(context_word0[215]),
        .I5(context_word0[87]),
        .O(contexts_reg_0_7_87_87_i_22_n_0));
  (* SOFT_HLUTNM = "soft_lutpair126" *) 
  LUT4 #(
    .INIT(16'hA808)) 
    contexts_reg_0_7_87_87_i_23
       (.I0(context_word1),
        .I1(abs_diff1[13]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff3[13]),
        .O(abs_diff[13]));
  (* SOFT_HLUTNM = "soft_lutpair125" *) 
  LUT4 #(
    .INIT(16'hA808)) 
    contexts_reg_0_7_87_87_i_24
       (.I0(context_word1),
        .I1(abs_diff1[14]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff3[14]),
        .O(abs_diff[14]));
  (* SOFT_HLUTNM = "soft_lutpair127" *) 
  LUT4 #(
    .INIT(16'hA808)) 
    contexts_reg_0_7_87_87_i_25
       (.I0(context_word1),
        .I1(abs_diff1[12]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff3[12]),
        .O(abs_diff[12]));
  (* SOFT_HLUTNM = "soft_lutpair124" *) 
  LUT4 #(
    .INIT(16'hA808)) 
    contexts_reg_0_7_87_87_i_26
       (.I0(context_word1),
        .I1(abs_diff1[15]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff3[15]),
        .O(abs_diff[15]));
  LUT4 #(
    .INIT(16'hD540)) 
    contexts_reg_0_7_87_87_i_3
       (.I0(contexts_reg_0_7_87_87_i_11_n_0),
        .I1(context_word1),
        .I2(context_word0[89]),
        .I3(contexts_reg_0_7_87_87_i_12_n_0),
        .O(contexts_reg_0_7_87_87_i_3_n_0));
  LUT4 #(
    .INIT(16'hD540)) 
    contexts_reg_0_7_87_87_i_4
       (.I0(contexts_reg_0_7_87_87_i_13_n_0),
        .I1(context_word1),
        .I2(context_word0[88]),
        .I3(contexts_reg_0_7_87_87_i_14_n_0),
        .O(contexts_reg_0_7_87_87_i_4_n_0));
  LUT4 #(
    .INIT(16'hD540)) 
    contexts_reg_0_7_87_87_i_5
       (.I0(contexts_reg_0_7_87_87_i_15_n_0),
        .I1(context_word1),
        .I2(context_word0[87]),
        .I3(contexts_reg_0_7_87_87_i_16_n_0),
        .O(contexts_reg_0_7_87_87_i_5_n_0));
  LUT4 #(
    .INIT(16'hD540)) 
    contexts_reg_0_7_87_87_i_6
       (.I0(contexts_reg_0_7_83_83_i_18_n_0),
        .I1(context_word1),
        .I2(context_word0[86]),
        .I3(contexts_reg_0_7_87_87_i_17_n_0),
        .O(contexts_reg_0_7_87_87_i_6_n_0));
  LUT6 #(
    .INIT(64'h80EA7F157F1580EA)) 
    contexts_reg_0_7_87_87_i_7
       (.I0(contexts_reg_0_7_87_87_i_12_n_0),
        .I1(context_word0[89]),
        .I2(context_word1),
        .I3(contexts_reg_0_7_87_87_i_11_n_0),
        .I4(contexts_reg_0_7_87_87_i_18_n_0),
        .I5(contexts_reg_0_7_87_87_i_19_n_0),
        .O(contexts_reg_0_7_87_87_i_7_n_0));
  LUT6 #(
    .INIT(64'h80EA7F157F1580EA)) 
    contexts_reg_0_7_87_87_i_8
       (.I0(contexts_reg_0_7_87_87_i_14_n_0),
        .I1(context_word0[88]),
        .I2(context_word1),
        .I3(contexts_reg_0_7_87_87_i_13_n_0),
        .I4(contexts_reg_0_7_87_87_i_11_n_0),
        .I5(contexts_reg_0_7_87_87_i_20_n_0),
        .O(contexts_reg_0_7_87_87_i_8_n_0));
  LUT6 #(
    .INIT(64'h80EA7F157F1580EA)) 
    contexts_reg_0_7_87_87_i_9
       (.I0(contexts_reg_0_7_87_87_i_16_n_0),
        .I1(context_word0[87]),
        .I2(context_word1),
        .I3(contexts_reg_0_7_87_87_i_15_n_0),
        .I4(contexts_reg_0_7_87_87_i_13_n_0),
        .I5(contexts_reg_0_7_87_87_i_21_n_0),
        .O(contexts_reg_0_7_87_87_i_9_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "88" *) 
  (* ram_slice_end = "88" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_88_88
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_88_88_i_1_n_0),
        .O(context_word0[88]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_88_88_i_1
       (.I0(next_wl0[13]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_88_88_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "89" *) 
  (* ram_slice_end = "89" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_89_89
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_89_89_i_1_n_0),
        .O(context_word0[89]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_89_89_i_1
       (.I0(next_wl0[14]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_89_89_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "8" *) 
  (* ram_slice_end = "8" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_8_8
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_8_8_i_1_n_0),
        .O(context_word0[8]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_7_7_i_2_n_0));
  LUT4 #(
    .INIT(16'h0880)) 
    contexts_reg_0_7_8_8_i_1
       (.I0(context_word0[16]),
        .I1(context_word1),
        .I2(context_word0[8]),
        .I3(context_word0[7]),
        .O(contexts_reg_0_7_8_8_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "90" *) 
  (* ram_slice_end = "90" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_90_90
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_90_90_i_1_n_0),
        .O(context_word0[90]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_90_90_i_1
       (.I0(next_wl0[15]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_90_90_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "91" *) 
  (* ram_slice_end = "91" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_91_91
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_91_91_i_1_n_0),
        .O(context_word0[91]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_91_91_i_1
       (.I0(next_wl0[16]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_91_91_i_1_n_0));
  LUT6 #(
    .INIT(64'h80EA7F157F1580EA)) 
    contexts_reg_0_7_91_91_i_10
       (.I0(contexts_reg_0_7_91_91_i_17_n_0),
        .I1(context_word0[90]),
        .I2(context_word1),
        .I3(contexts_reg_0_7_87_87_i_18_n_0),
        .I4(contexts_reg_0_7_91_91_i_15_n_0),
        .I5(contexts_reg_0_7_91_91_i_22_n_0),
        .O(contexts_reg_0_7_91_91_i_10_n_0));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT5 #(
    .INIT(32'h10007F5F)) 
    contexts_reg_0_7_91_91_i_11
       (.I0(context_word0[220]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[63]),
        .I4(abs_diff[17]),
        .O(contexts_reg_0_7_91_91_i_11_n_0));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT5 #(
    .INIT(32'h95A56555)) 
    contexts_reg_0_7_91_91_i_12
       (.I0(abs_diff[18]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[64]),
        .I4(context_word0[221]),
        .O(contexts_reg_0_7_91_91_i_12_n_0));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT5 #(
    .INIT(32'h10007F5F)) 
    contexts_reg_0_7_91_91_i_13
       (.I0(context_word0[219]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[62]),
        .I4(abs_diff[16]),
        .O(contexts_reg_0_7_91_91_i_13_n_0));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT5 #(
    .INIT(32'h95A56555)) 
    contexts_reg_0_7_91_91_i_14
       (.I0(abs_diff[17]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[63]),
        .I4(context_word0[220]),
        .O(contexts_reg_0_7_91_91_i_14_n_0));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT5 #(
    .INIT(32'h10007F5F)) 
    contexts_reg_0_7_91_91_i_15
       (.I0(context_word0[218]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[61]),
        .I4(abs_diff[15]),
        .O(contexts_reg_0_7_91_91_i_15_n_0));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT5 #(
    .INIT(32'h95A56555)) 
    contexts_reg_0_7_91_91_i_16
       (.I0(abs_diff[16]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[62]),
        .I4(context_word0[219]),
        .O(contexts_reg_0_7_91_91_i_16_n_0));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT5 #(
    .INIT(32'h95A56555)) 
    contexts_reg_0_7_91_91_i_17
       (.I0(abs_diff[15]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[61]),
        .I4(context_word0[218]),
        .O(contexts_reg_0_7_91_91_i_17_n_0));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT5 #(
    .INIT(32'h10007F5F)) 
    contexts_reg_0_7_91_91_i_18
       (.I0(context_word0[221]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[64]),
        .I4(abs_diff[18]),
        .O(contexts_reg_0_7_91_91_i_18_n_0));
  LUT6 #(
    .INIT(64'h9AAA6A5A6A5A9AAA)) 
    contexts_reg_0_7_91_91_i_19
       (.I0(abs_diff[19]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[65]),
        .I4(context_word0[222]),
        .I5(context_word0[94]),
        .O(contexts_reg_0_7_91_91_i_19_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 contexts_reg_0_7_91_91_i_2
       (.CI(contexts_reg_0_7_87_87_i_2_n_0),
        .CO({contexts_reg_0_7_91_91_i_2_n_0,contexts_reg_0_7_91_91_i_2_n_1,contexts_reg_0_7_91_91_i_2_n_2,contexts_reg_0_7_91_91_i_2_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_91_91_i_3_n_0,contexts_reg_0_7_91_91_i_4_n_0,contexts_reg_0_7_91_91_i_5_n_0,contexts_reg_0_7_91_91_i_6_n_0}),
        .O(next_wl0[19:16]),
        .S({contexts_reg_0_7_91_91_i_7_n_0,contexts_reg_0_7_91_91_i_8_n_0,contexts_reg_0_7_91_91_i_9_n_0,contexts_reg_0_7_91_91_i_10_n_0}));
  LUT6 #(
    .INIT(64'h9AAA6A5A6A5A9AAA)) 
    contexts_reg_0_7_91_91_i_20
       (.I0(abs_diff[18]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[64]),
        .I4(context_word0[221]),
        .I5(context_word0[93]),
        .O(contexts_reg_0_7_91_91_i_20_n_0));
  LUT6 #(
    .INIT(64'h9AAA6A5A6A5A9AAA)) 
    contexts_reg_0_7_91_91_i_21
       (.I0(abs_diff[17]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[63]),
        .I4(context_word0[220]),
        .I5(context_word0[92]),
        .O(contexts_reg_0_7_91_91_i_21_n_0));
  LUT6 #(
    .INIT(64'h9AAA6A5A6A5A9AAA)) 
    contexts_reg_0_7_91_91_i_22
       (.I0(abs_diff[16]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[62]),
        .I4(context_word0[219]),
        .I5(context_word0[91]),
        .O(contexts_reg_0_7_91_91_i_22_n_0));
  (* SOFT_HLUTNM = "soft_lutpair122" *) 
  LUT4 #(
    .INIT(16'hA808)) 
    contexts_reg_0_7_91_91_i_23
       (.I0(context_word1),
        .I1(abs_diff1[17]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff3[17]),
        .O(abs_diff[17]));
  (* SOFT_HLUTNM = "soft_lutpair121" *) 
  LUT4 #(
    .INIT(16'hA808)) 
    contexts_reg_0_7_91_91_i_24
       (.I0(context_word1),
        .I1(abs_diff1[18]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff3[18]),
        .O(abs_diff[18]));
  (* SOFT_HLUTNM = "soft_lutpair123" *) 
  LUT4 #(
    .INIT(16'hA808)) 
    contexts_reg_0_7_91_91_i_25
       (.I0(context_word1),
        .I1(abs_diff1[16]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff3[16]),
        .O(abs_diff[16]));
  (* SOFT_HLUTNM = "soft_lutpair120" *) 
  LUT4 #(
    .INIT(16'hA808)) 
    contexts_reg_0_7_91_91_i_26
       (.I0(context_word1),
        .I1(abs_diff1[19]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff3[19]),
        .O(abs_diff[19]));
  LUT4 #(
    .INIT(16'hD540)) 
    contexts_reg_0_7_91_91_i_3
       (.I0(contexts_reg_0_7_91_91_i_11_n_0),
        .I1(context_word1),
        .I2(context_word0[93]),
        .I3(contexts_reg_0_7_91_91_i_12_n_0),
        .O(contexts_reg_0_7_91_91_i_3_n_0));
  LUT4 #(
    .INIT(16'hD540)) 
    contexts_reg_0_7_91_91_i_4
       (.I0(contexts_reg_0_7_91_91_i_13_n_0),
        .I1(context_word1),
        .I2(context_word0[92]),
        .I3(contexts_reg_0_7_91_91_i_14_n_0),
        .O(contexts_reg_0_7_91_91_i_4_n_0));
  LUT4 #(
    .INIT(16'hD540)) 
    contexts_reg_0_7_91_91_i_5
       (.I0(contexts_reg_0_7_91_91_i_15_n_0),
        .I1(context_word1),
        .I2(context_word0[91]),
        .I3(contexts_reg_0_7_91_91_i_16_n_0),
        .O(contexts_reg_0_7_91_91_i_5_n_0));
  LUT4 #(
    .INIT(16'hD540)) 
    contexts_reg_0_7_91_91_i_6
       (.I0(contexts_reg_0_7_87_87_i_18_n_0),
        .I1(context_word1),
        .I2(context_word0[90]),
        .I3(contexts_reg_0_7_91_91_i_17_n_0),
        .O(contexts_reg_0_7_91_91_i_6_n_0));
  LUT6 #(
    .INIT(64'h80EA7F157F1580EA)) 
    contexts_reg_0_7_91_91_i_7
       (.I0(contexts_reg_0_7_91_91_i_12_n_0),
        .I1(context_word0[93]),
        .I2(context_word1),
        .I3(contexts_reg_0_7_91_91_i_11_n_0),
        .I4(contexts_reg_0_7_91_91_i_18_n_0),
        .I5(contexts_reg_0_7_91_91_i_19_n_0),
        .O(contexts_reg_0_7_91_91_i_7_n_0));
  LUT6 #(
    .INIT(64'h80EA7F157F1580EA)) 
    contexts_reg_0_7_91_91_i_8
       (.I0(contexts_reg_0_7_91_91_i_14_n_0),
        .I1(context_word0[92]),
        .I2(context_word1),
        .I3(contexts_reg_0_7_91_91_i_13_n_0),
        .I4(contexts_reg_0_7_91_91_i_11_n_0),
        .I5(contexts_reg_0_7_91_91_i_20_n_0),
        .O(contexts_reg_0_7_91_91_i_8_n_0));
  LUT6 #(
    .INIT(64'h80EA7F157F1580EA)) 
    contexts_reg_0_7_91_91_i_9
       (.I0(contexts_reg_0_7_91_91_i_16_n_0),
        .I1(context_word0[91]),
        .I2(context_word1),
        .I3(contexts_reg_0_7_91_91_i_15_n_0),
        .I4(contexts_reg_0_7_91_91_i_13_n_0),
        .I5(contexts_reg_0_7_91_91_i_21_n_0),
        .O(contexts_reg_0_7_91_91_i_9_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "92" *) 
  (* ram_slice_end = "92" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_92_92
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_92_92_i_1_n_0),
        .O(context_word0[92]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_92_92_i_1
       (.I0(next_wl0[17]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_92_92_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "93" *) 
  (* ram_slice_end = "93" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_93_93
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_93_93_i_1_n_0),
        .O(context_word0[93]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_93_93_i_1
       (.I0(next_wl0[18]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_93_93_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "94" *) 
  (* ram_slice_end = "94" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_94_94
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_94_94_i_1_n_0),
        .O(context_word0[94]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_94_94_i_1
       (.I0(next_wl0[19]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_94_94_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "95" *) 
  (* ram_slice_end = "95" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_95_95
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_95_95_i_1_n_0),
        .O(context_word0[95]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_95_95_i_1
       (.I0(next_wl0[20]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_95_95_i_1_n_0));
  LUT6 #(
    .INIT(64'h80EA7F157F1580EA)) 
    contexts_reg_0_7_95_95_i_10
       (.I0(contexts_reg_0_7_95_95_i_17_n_0),
        .I1(context_word0[94]),
        .I2(context_word1),
        .I3(contexts_reg_0_7_91_91_i_18_n_0),
        .I4(contexts_reg_0_7_95_95_i_15_n_0),
        .I5(contexts_reg_0_7_95_95_i_22_n_0),
        .O(contexts_reg_0_7_95_95_i_10_n_0));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT5 #(
    .INIT(32'h10007F5F)) 
    contexts_reg_0_7_95_95_i_11
       (.I0(context_word0[224]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[67]),
        .I4(abs_diff[21]),
        .O(contexts_reg_0_7_95_95_i_11_n_0));
  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT5 #(
    .INIT(32'h95A56555)) 
    contexts_reg_0_7_95_95_i_12
       (.I0(abs_diff[22]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[68]),
        .I4(context_word0[225]),
        .O(contexts_reg_0_7_95_95_i_12_n_0));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT5 #(
    .INIT(32'h10007F5F)) 
    contexts_reg_0_7_95_95_i_13
       (.I0(context_word0[223]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[66]),
        .I4(abs_diff[20]),
        .O(contexts_reg_0_7_95_95_i_13_n_0));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT5 #(
    .INIT(32'h95A56555)) 
    contexts_reg_0_7_95_95_i_14
       (.I0(abs_diff[21]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[67]),
        .I4(context_word0[224]),
        .O(contexts_reg_0_7_95_95_i_14_n_0));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT5 #(
    .INIT(32'h10007F5F)) 
    contexts_reg_0_7_95_95_i_15
       (.I0(context_word0[222]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[65]),
        .I4(abs_diff[19]),
        .O(contexts_reg_0_7_95_95_i_15_n_0));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT5 #(
    .INIT(32'h95A56555)) 
    contexts_reg_0_7_95_95_i_16
       (.I0(abs_diff[20]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[66]),
        .I4(context_word0[223]),
        .O(contexts_reg_0_7_95_95_i_16_n_0));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT5 #(
    .INIT(32'h95A56555)) 
    contexts_reg_0_7_95_95_i_17
       (.I0(abs_diff[19]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[65]),
        .I4(context_word0[222]),
        .O(contexts_reg_0_7_95_95_i_17_n_0));
  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT5 #(
    .INIT(32'h10007F5F)) 
    contexts_reg_0_7_95_95_i_18
       (.I0(context_word0[225]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[68]),
        .I4(abs_diff[22]),
        .O(contexts_reg_0_7_95_95_i_18_n_0));
  LUT6 #(
    .INIT(64'h9AAA6A5A6A5A9AAA)) 
    contexts_reg_0_7_95_95_i_19
       (.I0(abs_diff[23]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[69]),
        .I4(context_word0[226]),
        .I5(context_word0[98]),
        .O(contexts_reg_0_7_95_95_i_19_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 contexts_reg_0_7_95_95_i_2
       (.CI(contexts_reg_0_7_91_91_i_2_n_0),
        .CO({contexts_reg_0_7_95_95_i_2_n_0,contexts_reg_0_7_95_95_i_2_n_1,contexts_reg_0_7_95_95_i_2_n_2,contexts_reg_0_7_95_95_i_2_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_95_95_i_3_n_0,contexts_reg_0_7_95_95_i_4_n_0,contexts_reg_0_7_95_95_i_5_n_0,contexts_reg_0_7_95_95_i_6_n_0}),
        .O(next_wl0[23:20]),
        .S({contexts_reg_0_7_95_95_i_7_n_0,contexts_reg_0_7_95_95_i_8_n_0,contexts_reg_0_7_95_95_i_9_n_0,contexts_reg_0_7_95_95_i_10_n_0}));
  LUT6 #(
    .INIT(64'h9AAA6A5A6A5A9AAA)) 
    contexts_reg_0_7_95_95_i_20
       (.I0(abs_diff[22]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[68]),
        .I4(context_word0[225]),
        .I5(context_word0[97]),
        .O(contexts_reg_0_7_95_95_i_20_n_0));
  LUT6 #(
    .INIT(64'h9AAA6A5A6A5A9AAA)) 
    contexts_reg_0_7_95_95_i_21
       (.I0(abs_diff[21]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[67]),
        .I4(context_word0[224]),
        .I5(context_word0[96]),
        .O(contexts_reg_0_7_95_95_i_21_n_0));
  LUT6 #(
    .INIT(64'h9AAA6A5A6A5A9AAA)) 
    contexts_reg_0_7_95_95_i_22
       (.I0(abs_diff[20]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[66]),
        .I4(context_word0[223]),
        .I5(context_word0[95]),
        .O(contexts_reg_0_7_95_95_i_22_n_0));
  (* SOFT_HLUTNM = "soft_lutpair118" *) 
  LUT4 #(
    .INIT(16'hA808)) 
    contexts_reg_0_7_95_95_i_23
       (.I0(context_word1),
        .I1(abs_diff1[21]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff3[21]),
        .O(abs_diff[21]));
  (* SOFT_HLUTNM = "soft_lutpair117" *) 
  LUT4 #(
    .INIT(16'hA808)) 
    contexts_reg_0_7_95_95_i_24
       (.I0(context_word1),
        .I1(abs_diff1[22]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff3[22]),
        .O(abs_diff[22]));
  (* SOFT_HLUTNM = "soft_lutpair119" *) 
  LUT4 #(
    .INIT(16'hA808)) 
    contexts_reg_0_7_95_95_i_25
       (.I0(context_word1),
        .I1(abs_diff1[20]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff3[20]),
        .O(abs_diff[20]));
  (* SOFT_HLUTNM = "soft_lutpair116" *) 
  LUT4 #(
    .INIT(16'hA808)) 
    contexts_reg_0_7_95_95_i_26
       (.I0(context_word1),
        .I1(abs_diff1[23]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff3[23]),
        .O(abs_diff[23]));
  LUT4 #(
    .INIT(16'hD540)) 
    contexts_reg_0_7_95_95_i_3
       (.I0(contexts_reg_0_7_95_95_i_11_n_0),
        .I1(context_word1),
        .I2(context_word0[97]),
        .I3(contexts_reg_0_7_95_95_i_12_n_0),
        .O(contexts_reg_0_7_95_95_i_3_n_0));
  LUT4 #(
    .INIT(16'hD540)) 
    contexts_reg_0_7_95_95_i_4
       (.I0(contexts_reg_0_7_95_95_i_13_n_0),
        .I1(context_word1),
        .I2(context_word0[96]),
        .I3(contexts_reg_0_7_95_95_i_14_n_0),
        .O(contexts_reg_0_7_95_95_i_4_n_0));
  LUT4 #(
    .INIT(16'hD540)) 
    contexts_reg_0_7_95_95_i_5
       (.I0(contexts_reg_0_7_95_95_i_15_n_0),
        .I1(context_word1),
        .I2(context_word0[95]),
        .I3(contexts_reg_0_7_95_95_i_16_n_0),
        .O(contexts_reg_0_7_95_95_i_5_n_0));
  LUT4 #(
    .INIT(16'hD540)) 
    contexts_reg_0_7_95_95_i_6
       (.I0(contexts_reg_0_7_91_91_i_18_n_0),
        .I1(context_word1),
        .I2(context_word0[94]),
        .I3(contexts_reg_0_7_95_95_i_17_n_0),
        .O(contexts_reg_0_7_95_95_i_6_n_0));
  LUT6 #(
    .INIT(64'h80EA7F157F1580EA)) 
    contexts_reg_0_7_95_95_i_7
       (.I0(contexts_reg_0_7_95_95_i_12_n_0),
        .I1(context_word0[97]),
        .I2(context_word1),
        .I3(contexts_reg_0_7_95_95_i_11_n_0),
        .I4(contexts_reg_0_7_95_95_i_18_n_0),
        .I5(contexts_reg_0_7_95_95_i_19_n_0),
        .O(contexts_reg_0_7_95_95_i_7_n_0));
  LUT6 #(
    .INIT(64'h80EA7F157F1580EA)) 
    contexts_reg_0_7_95_95_i_8
       (.I0(contexts_reg_0_7_95_95_i_14_n_0),
        .I1(context_word0[96]),
        .I2(context_word1),
        .I3(contexts_reg_0_7_95_95_i_13_n_0),
        .I4(contexts_reg_0_7_95_95_i_11_n_0),
        .I5(contexts_reg_0_7_95_95_i_20_n_0),
        .O(contexts_reg_0_7_95_95_i_8_n_0));
  LUT6 #(
    .INIT(64'h80EA7F157F1580EA)) 
    contexts_reg_0_7_95_95_i_9
       (.I0(contexts_reg_0_7_95_95_i_16_n_0),
        .I1(context_word0[95]),
        .I2(context_word1),
        .I3(contexts_reg_0_7_95_95_i_15_n_0),
        .I4(contexts_reg_0_7_95_95_i_13_n_0),
        .I5(contexts_reg_0_7_95_95_i_21_n_0),
        .O(contexts_reg_0_7_95_95_i_9_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "96" *) 
  (* ram_slice_end = "96" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_96_96
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_96_96_i_1_n_0),
        .O(context_word0[96]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_96_96_i_1
       (.I0(next_wl0[21]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_96_96_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "97" *) 
  (* ram_slice_end = "97" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_97_97
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_97_97_i_1_n_0),
        .O(context_word0[97]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_97_97_i_1
       (.I0(next_wl0[22]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_97_97_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "98" *) 
  (* ram_slice_end = "98" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_98_98
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_98_98_i_1_n_0),
        .O(context_word0[98]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_98_98_i_1
       (.I0(next_wl0[23]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_98_98_i_1_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "99" *) 
  (* ram_slice_end = "99" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_99_99
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_99_99_i_1_n_0),
        .O(context_word0[99]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_17_17_i_2_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    contexts_reg_0_7_99_99_i_1
       (.I0(next_wl0[24]),
        .I1(contexts_reg_0_7_17_17_i_3_n_0),
        .O(contexts_reg_0_7_99_99_i_1_n_0));
  LUT4 #(
    .INIT(16'h6996)) 
    contexts_reg_0_7_99_99_i_10
       (.I0(contexts_reg_0_7_99_99_i_6_n_0),
        .I1(contexts_reg_0_7_99_99_i_13_n_0),
        .I2(contexts_reg_0_7_99_99_i_14_n_0),
        .I3(contexts_reg_0_7_99_99_i_20_n_0),
        .O(contexts_reg_0_7_99_99_i_10_n_0));
  LUT6 #(
    .INIT(64'h9F5F9F9F60A06060)) 
    contexts_reg_0_7_99_99_i_11
       (.I0(context_word0[100]),
        .I1(context_word0[99]),
        .I2(context_word1),
        .I3(contexts_reg_0_7_157_157_i_6_n_3),
        .I4(abs_diff1[24]),
        .I5(contexts_reg_0_7_99_99_i_18_n_0),
        .O(contexts_reg_0_7_99_99_i_11_n_0));
  LUT6 #(
    .INIT(64'hFB0404FB00FF00FF)) 
    contexts_reg_0_7_99_99_i_12
       (.I0(context_word0[16]),
        .I1(next_mav4[71]),
        .I2(context_word0[228]),
        .I3(contexts_reg_0_7_99_99_i_21_n_0),
        .I4(context_word0[101]),
        .I5(context_word1),
        .O(contexts_reg_0_7_99_99_i_12_n_0));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT5 #(
    .INIT(32'h10007F5F)) 
    contexts_reg_0_7_99_99_i_13
       (.I0(context_word0[226]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[69]),
        .I4(abs_diff[23]),
        .O(contexts_reg_0_7_99_99_i_13_n_0));
  (* SOFT_HLUTNM = "soft_lutpair115" *) 
  LUT4 #(
    .INIT(16'hD020)) 
    contexts_reg_0_7_99_99_i_14
       (.I0(abs_diff1[24]),
        .I1(contexts_reg_0_7_157_157_i_6_n_3),
        .I2(context_word1),
        .I3(context_word0[99]),
        .O(contexts_reg_0_7_99_99_i_14_n_0));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT5 #(
    .INIT(32'h95A56555)) 
    contexts_reg_0_7_99_99_i_15
       (.I0(abs_diff[23]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[69]),
        .I4(context_word0[226]),
        .O(contexts_reg_0_7_99_99_i_15_n_0));
  LUT6 #(
    .INIT(64'h04FBFB04FF00FF00)) 
    contexts_reg_0_7_99_99_i_16
       (.I0(context_word0[229]),
        .I1(next_mav4[72]),
        .I2(context_word0[16]),
        .I3(contexts_reg_0_7_99_99_i_22_n_0),
        .I4(context_word0[102]),
        .I5(context_word1),
        .O(contexts_reg_0_7_99_99_i_16_n_0));
  LUT6 #(
    .INIT(64'h8F8F8F8F8F0D8F8F)) 
    contexts_reg_0_7_99_99_i_17
       (.I0(context_word1),
        .I1(context_word0[101]),
        .I2(contexts_reg_0_7_99_99_i_21_n_0),
        .I3(context_word0[228]),
        .I4(next_mav4[71]),
        .I5(context_word0[16]),
        .O(contexts_reg_0_7_99_99_i_17_n_0));
  (* SOFT_HLUTNM = "soft_lutpair100" *) 
  LUT4 #(
    .INIT(16'h59FF)) 
    contexts_reg_0_7_99_99_i_18
       (.I0(context_word0[228]),
        .I1(next_mav4[71]),
        .I2(context_word0[16]),
        .I3(context_word1),
        .O(contexts_reg_0_7_99_99_i_18_n_0));
  (* SOFT_HLUTNM = "soft_lutpair115" *) 
  LUT3 #(
    .INIT(8'h20)) 
    contexts_reg_0_7_99_99_i_19
       (.I0(context_word1),
        .I1(contexts_reg_0_7_157_157_i_6_n_3),
        .I2(abs_diff1[24]),
        .O(abs_diff[24]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 contexts_reg_0_7_99_99_i_2
       (.CI(contexts_reg_0_7_95_95_i_2_n_0),
        .CO({contexts_reg_0_7_99_99_i_2_n_0,contexts_reg_0_7_99_99_i_2_n_1,contexts_reg_0_7_99_99_i_2_n_2,contexts_reg_0_7_99_99_i_2_n_3}),
        .CYINIT(1'b0),
        .DI({contexts_reg_0_7_99_99_i_3_n_0,contexts_reg_0_7_99_99_i_4_n_0,contexts_reg_0_7_99_99_i_5_n_0,contexts_reg_0_7_99_99_i_6_n_0}),
        .O(next_wl0[27:24]),
        .S({contexts_reg_0_7_99_99_i_7_n_0,contexts_reg_0_7_99_99_i_8_n_0,contexts_reg_0_7_99_99_i_9_n_0,contexts_reg_0_7_99_99_i_10_n_0}));
  (* SOFT_HLUTNM = "soft_lutpair113" *) 
  LUT4 #(
    .INIT(16'h90A0)) 
    contexts_reg_0_7_99_99_i_20
       (.I0(context_word0[227]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[70]),
        .O(contexts_reg_0_7_99_99_i_20_n_0));
  (* SOFT_HLUTNM = "soft_lutpair112" *) 
  LUT4 #(
    .INIT(16'h6F5F)) 
    contexts_reg_0_7_99_99_i_21
       (.I0(context_word0[229]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[72]),
        .O(contexts_reg_0_7_99_99_i_21_n_0));
  (* SOFT_HLUTNM = "soft_lutpair111" *) 
  LUT4 #(
    .INIT(16'h6F5F)) 
    contexts_reg_0_7_99_99_i_22
       (.I0(context_word0[230]),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[73]),
        .O(contexts_reg_0_7_99_99_i_22_n_0));
  LUT6 #(
    .INIT(64'h0000000055554555)) 
    contexts_reg_0_7_99_99_i_3
       (.I0(contexts_reg_0_7_99_99_i_11_n_0),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[70]),
        .I4(context_word0[227]),
        .I5(contexts_reg_0_7_99_99_i_12_n_0),
        .O(contexts_reg_0_7_99_99_i_3_n_0));
  LUT6 #(
    .INIT(64'h55554555AAAABAAA)) 
    contexts_reg_0_7_99_99_i_4
       (.I0(contexts_reg_0_7_99_99_i_11_n_0),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[70]),
        .I4(context_word0[227]),
        .I5(contexts_reg_0_7_99_99_i_12_n_0),
        .O(contexts_reg_0_7_99_99_i_4_n_0));
  LUT6 #(
    .INIT(64'h50100040F57555D5)) 
    contexts_reg_0_7_99_99_i_5
       (.I0(contexts_reg_0_7_99_99_i_13_n_0),
        .I1(next_mav4[70]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(context_word0[227]),
        .I5(contexts_reg_0_7_99_99_i_14_n_0),
        .O(contexts_reg_0_7_99_99_i_5_n_0));
  LUT4 #(
    .INIT(16'hD540)) 
    contexts_reg_0_7_99_99_i_6
       (.I0(contexts_reg_0_7_95_95_i_18_n_0),
        .I1(context_word1),
        .I2(context_word0[98]),
        .I3(contexts_reg_0_7_99_99_i_15_n_0),
        .O(contexts_reg_0_7_99_99_i_6_n_0));
  LUT3 #(
    .INIT(8'h96)) 
    contexts_reg_0_7_99_99_i_7
       (.I0(contexts_reg_0_7_99_99_i_16_n_0),
        .I1(contexts_reg_0_7_99_99_i_17_n_0),
        .I2(contexts_reg_0_7_99_99_i_3_n_0),
        .O(contexts_reg_0_7_99_99_i_7_n_0));
  LUT6 #(
    .INIT(64'h9599AAAAA9AAAAAA)) 
    contexts_reg_0_7_99_99_i_8
       (.I0(contexts_reg_0_7_99_99_i_4_n_0),
        .I1(contexts_reg_0_7_99_99_i_18_n_0),
        .I2(abs_diff[24]),
        .I3(context_word0[99]),
        .I4(context_word1),
        .I5(context_word0[100]),
        .O(contexts_reg_0_7_99_99_i_8_n_0));
  LUT6 #(
    .INIT(64'h6666666669666666)) 
    contexts_reg_0_7_99_99_i_9
       (.I0(contexts_reg_0_7_99_99_i_5_n_0),
        .I1(contexts_reg_0_7_99_99_i_11_n_0),
        .I2(context_word0[16]),
        .I3(context_word1),
        .I4(next_mav4[70]),
        .I5(context_word0[227]),
        .O(contexts_reg_0_7_99_99_i_9_n_0));
  (* RTL_RAM_BITS = "2592" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/contexts_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "7" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "9" *) 
  (* ram_slice_end = "9" *) 
  RAM32X1S #(
    .INIT(32'h00000000)) 
    contexts_reg_0_7_9_9
       (.A0(sample_channel[0]),
        .A1(sample_channel[1]),
        .A2(sample_channel[2]),
        .A3(1'b0),
        .A4(1'b0),
        .D(contexts_reg_0_7_9_9_i_1_n_0),
        .O(context_word0[9]),
        .WCLK(clk),
        .WE(contexts_reg_0_7_7_7_i_2_n_0));
  LUT5 #(
    .INIT(32'h6A000000)) 
    contexts_reg_0_7_9_9_i_1
       (.I0(context_word0[9]),
        .I1(context_word0[7]),
        .I2(context_word0[8]),
        .I3(context_word1),
        .I4(context_word0[16]),
        .O(contexts_reg_0_7_9_9_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair184" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \energy_sum[0]_i_1 
       (.I0(\energy_sum_reg[30]_i_2_n_3 ),
        .I1(next_energy0[0]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\energy_sum_reg[30]_i_3_n_3 ),
        .O(result_energy_sum[0]));
  (* SOFT_HLUTNM = "soft_lutpair179" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \energy_sum[10]_i_1 
       (.I0(\energy_sum_reg[30]_i_2_n_3 ),
        .I1(next_energy0[10]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\energy_sum_reg[30]_i_3_n_3 ),
        .O(result_energy_sum[10]));
  (* SOFT_HLUTNM = "soft_lutpair178" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \energy_sum[11]_i_1 
       (.I0(\energy_sum_reg[30]_i_2_n_3 ),
        .I1(next_energy0[11]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\energy_sum_reg[30]_i_3_n_3 ),
        .O(result_energy_sum[11]));
  (* SOFT_HLUTNM = "soft_lutpair178" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \energy_sum[12]_i_1 
       (.I0(\energy_sum_reg[30]_i_2_n_3 ),
        .I1(next_energy0[12]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\energy_sum_reg[30]_i_3_n_3 ),
        .O(result_energy_sum[12]));
  (* SOFT_HLUTNM = "soft_lutpair177" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \energy_sum[13]_i_1 
       (.I0(\energy_sum_reg[30]_i_2_n_3 ),
        .I1(next_energy0[13]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\energy_sum_reg[30]_i_3_n_3 ),
        .O(result_energy_sum[13]));
  (* SOFT_HLUTNM = "soft_lutpair177" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \energy_sum[14]_i_1 
       (.I0(\energy_sum_reg[30]_i_2_n_3 ),
        .I1(next_energy0[14]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\energy_sum_reg[30]_i_3_n_3 ),
        .O(result_energy_sum[14]));
  (* SOFT_HLUTNM = "soft_lutpair176" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \energy_sum[15]_i_1 
       (.I0(\energy_sum_reg[30]_i_2_n_3 ),
        .I1(next_energy0[15]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\energy_sum_reg[30]_i_3_n_3 ),
        .O(result_energy_sum[15]));
  (* SOFT_HLUTNM = "soft_lutpair176" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \energy_sum[16]_i_1 
       (.I0(\energy_sum_reg[30]_i_2_n_3 ),
        .I1(next_energy0[16]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\energy_sum_reg[30]_i_3_n_3 ),
        .O(result_energy_sum[16]));
  (* SOFT_HLUTNM = "soft_lutpair175" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \energy_sum[17]_i_1 
       (.I0(\energy_sum_reg[30]_i_2_n_3 ),
        .I1(next_energy0[17]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\energy_sum_reg[30]_i_3_n_3 ),
        .O(result_energy_sum[17]));
  (* SOFT_HLUTNM = "soft_lutpair175" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \energy_sum[18]_i_1 
       (.I0(\energy_sum_reg[30]_i_2_n_3 ),
        .I1(next_energy0[18]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\energy_sum_reg[30]_i_3_n_3 ),
        .O(result_energy_sum[18]));
  (* SOFT_HLUTNM = "soft_lutpair174" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \energy_sum[19]_i_1 
       (.I0(\energy_sum_reg[30]_i_2_n_3 ),
        .I1(next_energy0[19]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\energy_sum_reg[30]_i_3_n_3 ),
        .O(result_energy_sum[19]));
  (* SOFT_HLUTNM = "soft_lutpair183" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \energy_sum[1]_i_1 
       (.I0(\energy_sum_reg[30]_i_2_n_3 ),
        .I1(next_energy0[1]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\energy_sum_reg[30]_i_3_n_3 ),
        .O(result_energy_sum[1]));
  (* SOFT_HLUTNM = "soft_lutpair174" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \energy_sum[20]_i_1 
       (.I0(\energy_sum_reg[30]_i_2_n_3 ),
        .I1(next_energy0[20]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\energy_sum_reg[30]_i_3_n_3 ),
        .O(result_energy_sum[20]));
  (* SOFT_HLUTNM = "soft_lutpair173" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \energy_sum[21]_i_1 
       (.I0(\energy_sum_reg[30]_i_2_n_3 ),
        .I1(next_energy0[21]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\energy_sum_reg[30]_i_3_n_3 ),
        .O(result_energy_sum[21]));
  (* SOFT_HLUTNM = "soft_lutpair173" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \energy_sum[22]_i_1 
       (.I0(\energy_sum_reg[30]_i_2_n_3 ),
        .I1(next_energy0[22]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\energy_sum_reg[30]_i_3_n_3 ),
        .O(result_energy_sum[22]));
  (* SOFT_HLUTNM = "soft_lutpair172" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \energy_sum[23]_i_1 
       (.I0(\energy_sum_reg[30]_i_2_n_3 ),
        .I1(next_energy0[23]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\energy_sum_reg[30]_i_3_n_3 ),
        .O(result_energy_sum[23]));
  (* SOFT_HLUTNM = "soft_lutpair172" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \energy_sum[24]_i_1 
       (.I0(\energy_sum_reg[30]_i_2_n_3 ),
        .I1(next_energy0[24]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\energy_sum_reg[30]_i_3_n_3 ),
        .O(result_energy_sum[24]));
  (* SOFT_HLUTNM = "soft_lutpair171" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \energy_sum[25]_i_1 
       (.I0(\energy_sum_reg[30]_i_2_n_3 ),
        .I1(next_energy0[25]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\energy_sum_reg[30]_i_3_n_3 ),
        .O(result_energy_sum[25]));
  (* SOFT_HLUTNM = "soft_lutpair171" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \energy_sum[26]_i_1 
       (.I0(\energy_sum_reg[30]_i_2_n_3 ),
        .I1(next_energy0[26]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\energy_sum_reg[30]_i_3_n_3 ),
        .O(result_energy_sum[26]));
  (* SOFT_HLUTNM = "soft_lutpair170" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \energy_sum[27]_i_1 
       (.I0(\energy_sum_reg[30]_i_2_n_3 ),
        .I1(next_energy0[27]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\energy_sum_reg[30]_i_3_n_3 ),
        .O(result_energy_sum[27]));
  (* SOFT_HLUTNM = "soft_lutpair170" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \energy_sum[28]_i_1 
       (.I0(\energy_sum_reg[30]_i_2_n_3 ),
        .I1(next_energy0[28]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\energy_sum_reg[30]_i_3_n_3 ),
        .O(result_energy_sum[28]));
  (* SOFT_HLUTNM = "soft_lutpair169" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \energy_sum[29]_i_1 
       (.I0(\energy_sum_reg[30]_i_2_n_3 ),
        .I1(next_energy0[29]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\energy_sum_reg[30]_i_3_n_3 ),
        .O(result_energy_sum[29]));
  (* SOFT_HLUTNM = "soft_lutpair183" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \energy_sum[2]_i_1 
       (.I0(\energy_sum_reg[30]_i_2_n_3 ),
        .I1(next_energy0[2]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\energy_sum_reg[30]_i_3_n_3 ),
        .O(result_energy_sum[2]));
  (* SOFT_HLUTNM = "soft_lutpair169" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \energy_sum[30]_i_1 
       (.I0(\energy_sum_reg[30]_i_2_n_3 ),
        .I1(next_energy0[30]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\energy_sum_reg[30]_i_3_n_3 ),
        .O(result_energy_sum[30]));
  LUT3 #(
    .INIT(8'hDF)) 
    \energy_sum[30]_i_10 
       (.I0(next_energy0[36]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_energy0[37]),
        .O(\energy_sum[30]_i_10_n_0 ));
  LUT3 #(
    .INIT(8'hDF)) 
    \energy_sum[30]_i_11 
       (.I0(next_energy0[34]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_energy0[35]),
        .O(\energy_sum[30]_i_11_n_0 ));
  LUT3 #(
    .INIT(8'hDF)) 
    \energy_sum[30]_i_12 
       (.I0(next_energy0[32]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_energy0[33]),
        .O(\energy_sum[30]_i_12_n_0 ));
  LUT2 #(
    .INIT(4'hB)) 
    \energy_sum[30]_i_13 
       (.I0(\mav_sum[30]_i_3_n_0 ),
        .I1(next_energy0[31]),
        .O(\energy_sum[30]_i_13_n_0 ));
  LUT3 #(
    .INIT(8'h20)) 
    \energy_sum[30]_i_14 
       (.I0(next_energy0[37]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_energy0[36]),
        .O(\energy_sum[30]_i_14_n_0 ));
  LUT3 #(
    .INIT(8'h20)) 
    \energy_sum[30]_i_15 
       (.I0(next_energy0[35]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_energy0[34]),
        .O(\energy_sum[30]_i_15_n_0 ));
  LUT3 #(
    .INIT(8'h20)) 
    \energy_sum[30]_i_16 
       (.I0(next_energy0[33]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_energy0[32]),
        .O(\energy_sum[30]_i_16_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \energy_sum[30]_i_17 
       (.I0(next_energy0[30]),
        .I1(next_energy0[31]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .O(\energy_sum[30]_i_17_n_0 ));
  LUT3 #(
    .INIT(8'h32)) 
    \energy_sum[30]_i_18 
       (.I0(next_energy0[36]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_energy0[37]),
        .O(\energy_sum[30]_i_18_n_0 ));
  LUT3 #(
    .INIT(8'h32)) 
    \energy_sum[30]_i_19 
       (.I0(next_energy0[34]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_energy0[35]),
        .O(\energy_sum[30]_i_19_n_0 ));
  LUT3 #(
    .INIT(8'h32)) 
    \energy_sum[30]_i_20 
       (.I0(next_energy0[32]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_energy0[33]),
        .O(\energy_sum[30]_i_20_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \energy_sum[30]_i_21 
       (.I0(next_energy0[31]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .O(\energy_sum[30]_i_21_n_0 ));
  LUT3 #(
    .INIT(8'hCD)) 
    \energy_sum[30]_i_22 
       (.I0(next_energy0[37]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_energy0[36]),
        .O(\energy_sum[30]_i_22_n_0 ));
  LUT3 #(
    .INIT(8'hCD)) 
    \energy_sum[30]_i_23 
       (.I0(next_energy0[35]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_energy0[34]),
        .O(\energy_sum[30]_i_23_n_0 ));
  LUT3 #(
    .INIT(8'hCD)) 
    \energy_sum[30]_i_24 
       (.I0(next_energy0[33]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_energy0[32]),
        .O(\energy_sum[30]_i_24_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \energy_sum[30]_i_25 
       (.I0(next_energy0[31]),
        .I1(next_energy0[30]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .O(\energy_sum[30]_i_25_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \energy_sum[30]_i_5 
       (.I0(next_energy0[38]),
        .I1(next_energy0[39]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .O(\energy_sum[30]_i_5_n_0 ));
  LUT3 #(
    .INIT(8'h40)) 
    \energy_sum[30]_i_6 
       (.I0(\mav_sum[30]_i_3_n_0 ),
        .I1(next_energy0[38]),
        .I2(next_energy0[39]),
        .O(\energy_sum[30]_i_6_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \energy_sum[30]_i_8 
       (.I0(\mav_sum[30]_i_3_n_0 ),
        .I1(next_energy0[38]),
        .I2(next_energy0[39]),
        .O(\energy_sum[30]_i_8_n_0 ));
  LUT3 #(
    .INIT(8'hCD)) 
    \energy_sum[30]_i_9 
       (.I0(next_energy0[39]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_energy0[38]),
        .O(\energy_sum[30]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'h0CCC5CCC00000000)) 
    \energy_sum[31]_i_1 
       (.I0(\energy_sum_reg[30]_i_3_n_3 ),
        .I1(I11[47]),
        .I2(sample_valid),
        .I3(\window_channel[2]_i_2_n_0 ),
        .I4(\energy_sum[31]_i_2_n_0 ),
        .I5(rst_n),
        .O(\energy_sum[31]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair184" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \energy_sum[31]_i_2 
       (.I0(next_energy0[31]),
        .I1(\energy_sum_reg[30]_i_2_n_3 ),
        .O(\energy_sum[31]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair182" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \energy_sum[3]_i_1 
       (.I0(\energy_sum_reg[30]_i_2_n_3 ),
        .I1(next_energy0[3]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\energy_sum_reg[30]_i_3_n_3 ),
        .O(result_energy_sum[3]));
  (* SOFT_HLUTNM = "soft_lutpair182" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \energy_sum[4]_i_1 
       (.I0(\energy_sum_reg[30]_i_2_n_3 ),
        .I1(next_energy0[4]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\energy_sum_reg[30]_i_3_n_3 ),
        .O(result_energy_sum[4]));
  (* SOFT_HLUTNM = "soft_lutpair181" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \energy_sum[5]_i_1 
       (.I0(\energy_sum_reg[30]_i_2_n_3 ),
        .I1(next_energy0[5]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\energy_sum_reg[30]_i_3_n_3 ),
        .O(result_energy_sum[5]));
  (* SOFT_HLUTNM = "soft_lutpair181" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \energy_sum[6]_i_1 
       (.I0(\energy_sum_reg[30]_i_2_n_3 ),
        .I1(next_energy0[6]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\energy_sum_reg[30]_i_3_n_3 ),
        .O(result_energy_sum[6]));
  (* SOFT_HLUTNM = "soft_lutpair180" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \energy_sum[7]_i_1 
       (.I0(\energy_sum_reg[30]_i_2_n_3 ),
        .I1(next_energy0[7]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\energy_sum_reg[30]_i_3_n_3 ),
        .O(result_energy_sum[7]));
  (* SOFT_HLUTNM = "soft_lutpair180" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \energy_sum[8]_i_1 
       (.I0(\energy_sum_reg[30]_i_2_n_3 ),
        .I1(next_energy0[8]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\energy_sum_reg[30]_i_3_n_3 ),
        .O(result_energy_sum[8]));
  (* SOFT_HLUTNM = "soft_lutpair179" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \energy_sum[9]_i_1 
       (.I0(\energy_sum_reg[30]_i_2_n_3 ),
        .I1(next_energy0[9]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\energy_sum_reg[30]_i_3_n_3 ),
        .O(result_energy_sum[9]));
  FDRE \energy_sum_reg[0] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_energy_sum[0]),
        .Q(energy_sum[0]),
        .R(rst_n_0));
  FDRE \energy_sum_reg[10] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_energy_sum[10]),
        .Q(I11[26]),
        .R(rst_n_0));
  FDRE \energy_sum_reg[11] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_energy_sum[11]),
        .Q(I11[27]),
        .R(rst_n_0));
  FDRE \energy_sum_reg[12] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_energy_sum[12]),
        .Q(I11[28]),
        .R(rst_n_0));
  FDRE \energy_sum_reg[13] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_energy_sum[13]),
        .Q(I11[29]),
        .R(rst_n_0));
  FDRE \energy_sum_reg[14] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_energy_sum[14]),
        .Q(I11[30]),
        .R(rst_n_0));
  FDRE \energy_sum_reg[15] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_energy_sum[15]),
        .Q(I11[31]),
        .R(rst_n_0));
  FDRE \energy_sum_reg[16] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_energy_sum[16]),
        .Q(I11[32]),
        .R(rst_n_0));
  FDRE \energy_sum_reg[17] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_energy_sum[17]),
        .Q(I11[33]),
        .R(rst_n_0));
  FDRE \energy_sum_reg[18] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_energy_sum[18]),
        .Q(I11[34]),
        .R(rst_n_0));
  FDRE \energy_sum_reg[19] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_energy_sum[19]),
        .Q(I11[35]),
        .R(rst_n_0));
  FDRE \energy_sum_reg[1] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_energy_sum[1]),
        .Q(energy_sum[1]),
        .R(rst_n_0));
  FDRE \energy_sum_reg[20] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_energy_sum[20]),
        .Q(I11[36]),
        .R(rst_n_0));
  FDRE \energy_sum_reg[21] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_energy_sum[21]),
        .Q(I11[37]),
        .R(rst_n_0));
  FDRE \energy_sum_reg[22] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_energy_sum[22]),
        .Q(I11[38]),
        .R(rst_n_0));
  FDRE \energy_sum_reg[23] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_energy_sum[23]),
        .Q(I11[39]),
        .R(rst_n_0));
  FDRE \energy_sum_reg[24] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_energy_sum[24]),
        .Q(I11[40]),
        .R(rst_n_0));
  FDRE \energy_sum_reg[25] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_energy_sum[25]),
        .Q(I11[41]),
        .R(rst_n_0));
  FDRE \energy_sum_reg[26] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_energy_sum[26]),
        .Q(I11[42]),
        .R(rst_n_0));
  FDRE \energy_sum_reg[27] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_energy_sum[27]),
        .Q(I11[43]),
        .R(rst_n_0));
  FDRE \energy_sum_reg[28] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_energy_sum[28]),
        .Q(I11[44]),
        .R(rst_n_0));
  FDRE \energy_sum_reg[29] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_energy_sum[29]),
        .Q(I11[45]),
        .R(rst_n_0));
  FDRE \energy_sum_reg[2] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_energy_sum[2]),
        .Q(I11[18]),
        .R(rst_n_0));
  FDRE \energy_sum_reg[30] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_energy_sum[30]),
        .Q(I11[46]),
        .R(rst_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \energy_sum_reg[30]_i_2 
       (.CI(\energy_sum_reg[30]_i_4_n_0 ),
        .CO({\NLW_energy_sum_reg[30]_i_2_CO_UNCONNECTED [3:1],\energy_sum_reg[30]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,\energy_sum[30]_i_5_n_0 }),
        .O(\NLW_energy_sum_reg[30]_i_2_O_UNCONNECTED [3:0]),
        .S({1'b0,1'b0,1'b0,\energy_sum[30]_i_6_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \energy_sum_reg[30]_i_3 
       (.CI(\energy_sum_reg[30]_i_7_n_0 ),
        .CO({\NLW_energy_sum_reg[30]_i_3_CO_UNCONNECTED [3:1],\energy_sum_reg[30]_i_3_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,\energy_sum[30]_i_8_n_0 }),
        .O(\NLW_energy_sum_reg[30]_i_3_O_UNCONNECTED [3:0]),
        .S({1'b0,1'b0,1'b0,\energy_sum[30]_i_9_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \energy_sum_reg[30]_i_4 
       (.CI(1'b0),
        .CO({\energy_sum_reg[30]_i_4_n_0 ,\energy_sum_reg[30]_i_4_n_1 ,\energy_sum_reg[30]_i_4_n_2 ,\energy_sum_reg[30]_i_4_n_3 }),
        .CYINIT(1'b0),
        .DI({\energy_sum[30]_i_10_n_0 ,\energy_sum[30]_i_11_n_0 ,\energy_sum[30]_i_12_n_0 ,\energy_sum[30]_i_13_n_0 }),
        .O(\NLW_energy_sum_reg[30]_i_4_O_UNCONNECTED [3:0]),
        .S({\energy_sum[30]_i_14_n_0 ,\energy_sum[30]_i_15_n_0 ,\energy_sum[30]_i_16_n_0 ,\energy_sum[30]_i_17_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \energy_sum_reg[30]_i_7 
       (.CI(1'b0),
        .CO({\energy_sum_reg[30]_i_7_n_0 ,\energy_sum_reg[30]_i_7_n_1 ,\energy_sum_reg[30]_i_7_n_2 ,\energy_sum_reg[30]_i_7_n_3 }),
        .CYINIT(1'b0),
        .DI({\energy_sum[30]_i_18_n_0 ,\energy_sum[30]_i_19_n_0 ,\energy_sum[30]_i_20_n_0 ,\energy_sum[30]_i_21_n_0 }),
        .O(\NLW_energy_sum_reg[30]_i_7_O_UNCONNECTED [3:0]),
        .S({\energy_sum[30]_i_22_n_0 ,\energy_sum[30]_i_23_n_0 ,\energy_sum[30]_i_24_n_0 ,\energy_sum[30]_i_25_n_0 }));
  FDRE \energy_sum_reg[31] 
       (.C(clk),
        .CE(1'b1),
        .D(\energy_sum[31]_i_1_n_0 ),
        .Q(I11[47]),
        .R(1'b0));
  FDRE \energy_sum_reg[3] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_energy_sum[3]),
        .Q(I11[19]),
        .R(rst_n_0));
  FDRE \energy_sum_reg[4] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_energy_sum[4]),
        .Q(I11[20]),
        .R(rst_n_0));
  FDRE \energy_sum_reg[5] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_energy_sum[5]),
        .Q(I11[21]),
        .R(rst_n_0));
  FDRE \energy_sum_reg[6] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_energy_sum[6]),
        .Q(I11[22]),
        .R(rst_n_0));
  FDRE \energy_sum_reg[7] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_energy_sum[7]),
        .Q(I11[23]),
        .R(rst_n_0));
  FDRE \energy_sum_reg[8] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_energy_sum[8]),
        .Q(I11[24]),
        .R(rst_n_0));
  FDRE \energy_sum_reg[9] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_energy_sum[9]),
        .Q(I11[25]),
        .R(rst_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "0" *) 
  (* ram_slice_end = "0" *) 
  RAM32X1S history_reg_0_31_0_0
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(history_reg_0_31_0_0_i_1_n_0),
        .O(next_mav4[0]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  LUT3 #(
    .INIT(8'h95)) 
    history_reg_0_31_0_0_i_1
       (.I0(contexts_reg_0_7_157_157_i_4_n_0),
        .I1(context_word0[157]),
        .I2(context_word1),
        .O(history_reg_0_31_0_0_i_1_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    history_reg_0_31_0_0_i_2
       (.I0(p_3_out),
        .I1(contexts_reg_0_7_157_157_i_3_n_0),
        .O(history_reg_0_31_0_0_i_2_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_0_0_i_3
       (.I0(context_word0[155]),
        .I1(context_word1),
        .O(p_0_in0_in[0]));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_0_0_i_4
       (.I0(context_word0[156]),
        .I1(context_word1),
        .O(p_0_in0_in[1]));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "100" *) 
  (* ram_slice_end = "100" *) 
  RAM32X1S history_reg_0_31_100_100
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_mav[22]),
        .O(next_mav4[100]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "101" *) 
  (* ram_slice_end = "101" *) 
  RAM32X1S history_reg_0_31_101_101
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_mav[23]),
        .O(next_mav4[101]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "102" *) 
  (* ram_slice_end = "102" *) 
  RAM32X1S history_reg_0_31_102_102
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_mav[24]),
        .O(next_mav4[102]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 history_reg_0_31_102_102_i_1
       (.CI(history_reg_0_31_98_98_i_1_n_0),
        .CO({history_reg_0_31_102_102_i_1_n_0,history_reg_0_31_102_102_i_1_n_1,history_reg_0_31_102_102_i_1_n_2,history_reg_0_31_102_102_i_1_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,history_reg_0_31_102_102_i_2_n_0}),
        .O(completed_mav[27:24]),
        .S({history_reg_0_31_102_102_i_3_n_0,history_reg_0_31_102_102_i_4_n_0,history_reg_0_31_102_102_i_5_n_0,history_reg_0_31_102_102_i_6_n_0}));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_102_102_i_2
       (.I0(context_word0[259]),
        .I1(context_word1),
        .O(history_reg_0_31_102_102_i_2_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_102_102_i_3
       (.I0(context_word1),
        .I1(context_word0[262]),
        .O(history_reg_0_31_102_102_i_3_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_102_102_i_4
       (.I0(context_word1),
        .I1(context_word0[261]),
        .O(history_reg_0_31_102_102_i_4_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_102_102_i_5
       (.I0(context_word1),
        .I1(context_word0[260]),
        .O(history_reg_0_31_102_102_i_5_n_0));
  LUT4 #(
    .INIT(16'h8788)) 
    history_reg_0_31_102_102_i_6
       (.I0(context_word1),
        .I1(context_word0[259]),
        .I2(history_reg_0_31_98_98_i_10_n_0),
        .I3(sample_data[23]),
        .O(history_reg_0_31_102_102_i_6_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "103" *) 
  (* ram_slice_end = "103" *) 
  RAM32X1S history_reg_0_31_103_103
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_mav[25]),
        .O(next_mav4[103]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "104" *) 
  (* ram_slice_end = "104" *) 
  RAM32X1S history_reg_0_31_104_104
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_mav[26]),
        .O(next_mav4[104]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "105" *) 
  (* ram_slice_end = "105" *) 
  RAM32X1S history_reg_0_31_105_105
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_mav[27]),
        .O(next_mav4[105]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "106" *) 
  (* ram_slice_end = "106" *) 
  RAM32X1S history_reg_0_31_106_106
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_mav[28]),
        .O(next_mav4[106]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 history_reg_0_31_106_106_i_1
       (.CI(history_reg_0_31_102_102_i_1_n_0),
        .CO({NLW_history_reg_0_31_106_106_i_1_CO_UNCONNECTED[3],history_reg_0_31_106_106_i_1_n_1,history_reg_0_31_106_106_i_1_n_2,history_reg_0_31_106_106_i_1_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(completed_mav[31:28]),
        .S({history_reg_0_31_106_106_i_2_n_0,history_reg_0_31_106_106_i_3_n_0,history_reg_0_31_106_106_i_4_n_0,history_reg_0_31_106_106_i_5_n_0}));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_106_106_i_2
       (.I0(context_word1),
        .I1(context_word0[266]),
        .O(history_reg_0_31_106_106_i_2_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_106_106_i_3
       (.I0(context_word1),
        .I1(context_word0[265]),
        .O(history_reg_0_31_106_106_i_3_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_106_106_i_4
       (.I0(context_word0[264]),
        .I1(context_word1),
        .O(history_reg_0_31_106_106_i_4_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_106_106_i_5
       (.I0(context_word1),
        .I1(context_word0[263]),
        .O(history_reg_0_31_106_106_i_5_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "107" *) 
  (* ram_slice_end = "107" *) 
  RAM32X1S history_reg_0_31_107_107
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_mav[29]),
        .O(next_mav4[107]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "108" *) 
  (* ram_slice_end = "108" *) 
  RAM32X1S history_reg_0_31_108_108
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_mav[30]),
        .O(next_mav4[108]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "109" *) 
  (* ram_slice_end = "109" *) 
  RAM32X1S history_reg_0_31_109_109
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_mav[31]),
        .O(next_mav4[109]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "10" *) 
  (* ram_slice_end = "10" *) 
  RAM32X1S history_reg_0_31_10_10
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_zc[3]),
        .O(next_mav4[10]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  LUT6 #(
    .INIT(64'hA0A0A0A060A0A0A0)) 
    history_reg_0_31_10_10_i_1
       (.I0(context_word0[167]),
        .I1(context_word0[166]),
        .I2(context_word1),
        .I3(context_word0[165]),
        .I4(context_word0[164]),
        .I5(contexts_reg_0_7_165_165_i_2_n_0),
        .O(completed_zc[3]));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "11" *) 
  (* ram_slice_end = "11" *) 
  RAM32X1S history_reg_0_31_11_11
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_zc[4]),
        .O(next_mav4[11]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  LUT5 #(
    .INIT(32'hAA2A0080)) 
    history_reg_0_31_11_11_i_1
       (.I0(context_word1),
        .I1(context_word0[167]),
        .I2(context_word0[166]),
        .I3(contexts_reg_0_7_167_167_i_2_n_0),
        .I4(context_word0[168]),
        .O(completed_zc[4]));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "12" *) 
  (* ram_slice_end = "12" *) 
  RAM32X1S history_reg_0_31_12_12
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_zc[5]),
        .O(next_mav4[12]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  LUT6 #(
    .INIT(64'h8888488888888888)) 
    history_reg_0_31_12_12_i_1
       (.I0(context_word0[169]),
        .I1(context_word1),
        .I2(context_word0[167]),
        .I3(context_word0[166]),
        .I4(contexts_reg_0_7_167_167_i_2_n_0),
        .I5(context_word0[168]),
        .O(completed_zc[5]));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "13" *) 
  (* ram_slice_end = "13" *) 
  RAM32X1S history_reg_0_31_13_13
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(history_reg_0_31_13_13_i_1_n_0),
        .O(next_mav4[13]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  LUT4 #(
    .INIT(16'h6A00)) 
    history_reg_0_31_13_13_i_1
       (.I0(context_word0[170]),
        .I1(contexts_reg_0_7_169_169_i_2_n_0),
        .I2(context_word0[169]),
        .I3(context_word1),
        .O(history_reg_0_31_13_13_i_1_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "14" *) 
  (* ram_slice_end = "14" *) 
  RAM32X1S history_reg_0_31_14_14
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_energy[0]),
        .O(next_mav4[14]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 history_reg_0_31_14_14_i_1
       (.CI(1'b0),
        .CO({history_reg_0_31_14_14_i_1_n_0,history_reg_0_31_14_14_i_1_n_1,history_reg_0_31_14_14_i_1_n_2,history_reg_0_31_14_14_i_1_n_3}),
        .CYINIT(1'b0),
        .DI({history_reg_0_31_14_14_i_2_n_0,history_reg_0_31_14_14_i_3_n_0,history_reg_0_31_14_14_i_4_n_0,history_reg_0_31_14_14_i_5_n_0}),
        .O(completed_energy[3:0]),
        .S({history_reg_0_31_14_14_i_6_n_0,history_reg_0_31_14_14_i_7_n_0,history_reg_0_31_14_14_i_8_n_0,history_reg_0_31_14_14_i_9_n_0}));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_14_14_i_2
       (.I0(context_word0[174]),
        .I1(context_word1),
        .O(history_reg_0_31_14_14_i_2_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_14_14_i_3
       (.I0(context_word1),
        .I1(context_word0[173]),
        .O(history_reg_0_31_14_14_i_3_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_14_14_i_4
       (.I0(context_word1),
        .I1(context_word0[172]),
        .O(history_reg_0_31_14_14_i_4_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_14_14_i_5
       (.I0(context_word0[171]),
        .I1(context_word1),
        .O(history_reg_0_31_14_14_i_5_n_0));
  LUT3 #(
    .INIT(8'h78)) 
    history_reg_0_31_14_14_i_6
       (.I0(context_word1),
        .I1(context_word0[174]),
        .I2(next_energy1__1[3]),
        .O(history_reg_0_31_14_14_i_6_n_0));
  LUT3 #(
    .INIT(8'h78)) 
    history_reg_0_31_14_14_i_7
       (.I0(context_word0[173]),
        .I1(context_word1),
        .I2(next_energy1__1[2]),
        .O(history_reg_0_31_14_14_i_7_n_0));
  LUT3 #(
    .INIT(8'h78)) 
    history_reg_0_31_14_14_i_8
       (.I0(context_word0[172]),
        .I1(context_word1),
        .I2(next_energy1__1[1]),
        .O(history_reg_0_31_14_14_i_8_n_0));
  LUT3 #(
    .INIT(8'h78)) 
    history_reg_0_31_14_14_i_9
       (.I0(context_word1),
        .I1(context_word0[171]),
        .I2(next_energy1__1[0]),
        .O(history_reg_0_31_14_14_i_9_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "15" *) 
  (* ram_slice_end = "15" *) 
  RAM32X1S history_reg_0_31_15_15
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_energy[1]),
        .O(next_mav4[15]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "16" *) 
  (* ram_slice_end = "16" *) 
  RAM32X1S history_reg_0_31_16_16
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_energy[2]),
        .O(next_mav4[16]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "17" *) 
  (* ram_slice_end = "17" *) 
  RAM32X1S history_reg_0_31_17_17
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_energy[3]),
        .O(next_mav4[17]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "18" *) 
  (* ram_slice_end = "18" *) 
  RAM32X1S history_reg_0_31_18_18
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_energy[4]),
        .O(next_mav4[18]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 history_reg_0_31_18_18_i_1
       (.CI(history_reg_0_31_14_14_i_1_n_0),
        .CO({history_reg_0_31_18_18_i_1_n_0,history_reg_0_31_18_18_i_1_n_1,history_reg_0_31_18_18_i_1_n_2,history_reg_0_31_18_18_i_1_n_3}),
        .CYINIT(1'b0),
        .DI({history_reg_0_31_18_18_i_2_n_0,history_reg_0_31_18_18_i_3_n_0,history_reg_0_31_18_18_i_4_n_0,history_reg_0_31_18_18_i_5_n_0}),
        .O(completed_energy[7:4]),
        .S({history_reg_0_31_18_18_i_6_n_0,history_reg_0_31_18_18_i_7_n_0,history_reg_0_31_18_18_i_8_n_0,history_reg_0_31_18_18_i_9_n_0}));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_18_18_i_2
       (.I0(context_word0[178]),
        .I1(context_word1),
        .O(history_reg_0_31_18_18_i_2_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_18_18_i_3
       (.I0(context_word0[177]),
        .I1(context_word1),
        .O(history_reg_0_31_18_18_i_3_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_18_18_i_4
       (.I0(context_word0[176]),
        .I1(context_word1),
        .O(history_reg_0_31_18_18_i_4_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_18_18_i_5
       (.I0(context_word0[175]),
        .I1(context_word1),
        .O(history_reg_0_31_18_18_i_5_n_0));
  LUT3 #(
    .INIT(8'h78)) 
    history_reg_0_31_18_18_i_6
       (.I0(context_word1),
        .I1(context_word0[178]),
        .I2(next_energy1__1[7]),
        .O(history_reg_0_31_18_18_i_6_n_0));
  LUT3 #(
    .INIT(8'h78)) 
    history_reg_0_31_18_18_i_7
       (.I0(context_word1),
        .I1(context_word0[177]),
        .I2(next_energy1__1[6]),
        .O(history_reg_0_31_18_18_i_7_n_0));
  LUT3 #(
    .INIT(8'h78)) 
    history_reg_0_31_18_18_i_8
       (.I0(context_word1),
        .I1(context_word0[176]),
        .I2(next_energy1__1[5]),
        .O(history_reg_0_31_18_18_i_8_n_0));
  LUT3 #(
    .INIT(8'h78)) 
    history_reg_0_31_18_18_i_9
       (.I0(context_word1),
        .I1(context_word0[175]),
        .I2(next_energy1__1[4]),
        .O(history_reg_0_31_18_18_i_9_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "19" *) 
  (* ram_slice_end = "19" *) 
  RAM32X1S history_reg_0_31_19_19
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_energy[5]),
        .O(next_mav4[19]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "1" *) 
  (* ram_slice_end = "1" *) 
  RAM32X1S history_reg_0_31_1_1
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_ssc[1]),
        .O(next_mav4[1]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  LUT4 #(
    .INIT(16'h8878)) 
    history_reg_0_31_1_1_i_1
       (.I0(context_word1),
        .I1(context_word0[158]),
        .I2(context_word0[157]),
        .I3(contexts_reg_0_7_157_157_i_4_n_0),
        .O(completed_ssc[1]));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "20" *) 
  (* ram_slice_end = "20" *) 
  RAM32X1S history_reg_0_31_20_20
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_energy[6]),
        .O(next_mav4[20]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "21" *) 
  (* ram_slice_end = "21" *) 
  RAM32X1S history_reg_0_31_21_21
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_energy[7]),
        .O(next_mav4[21]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "22" *) 
  (* ram_slice_end = "22" *) 
  RAM32X1S history_reg_0_31_22_22
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_energy[8]),
        .O(next_mav4[22]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 history_reg_0_31_22_22_i_1
       (.CI(history_reg_0_31_18_18_i_1_n_0),
        .CO({history_reg_0_31_22_22_i_1_n_0,history_reg_0_31_22_22_i_1_n_1,history_reg_0_31_22_22_i_1_n_2,history_reg_0_31_22_22_i_1_n_3}),
        .CYINIT(1'b0),
        .DI({history_reg_0_31_22_22_i_2_n_0,history_reg_0_31_22_22_i_3_n_0,history_reg_0_31_22_22_i_4_n_0,history_reg_0_31_22_22_i_5_n_0}),
        .O(completed_energy[11:8]),
        .S({history_reg_0_31_22_22_i_6_n_0,history_reg_0_31_22_22_i_7_n_0,history_reg_0_31_22_22_i_8_n_0,history_reg_0_31_22_22_i_9_n_0}));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_22_22_i_2
       (.I0(context_word1),
        .I1(context_word0[182]),
        .O(history_reg_0_31_22_22_i_2_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_22_22_i_3
       (.I0(context_word1),
        .I1(context_word0[181]),
        .O(history_reg_0_31_22_22_i_3_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_22_22_i_4
       (.I0(context_word0[180]),
        .I1(context_word1),
        .O(history_reg_0_31_22_22_i_4_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_22_22_i_5
       (.I0(context_word0[179]),
        .I1(context_word1),
        .O(history_reg_0_31_22_22_i_5_n_0));
  LUT3 #(
    .INIT(8'h78)) 
    history_reg_0_31_22_22_i_6
       (.I0(context_word0[182]),
        .I1(context_word1),
        .I2(next_energy1__1[11]),
        .O(history_reg_0_31_22_22_i_6_n_0));
  LUT3 #(
    .INIT(8'h78)) 
    history_reg_0_31_22_22_i_7
       (.I0(context_word0[181]),
        .I1(context_word1),
        .I2(next_energy1__1[10]),
        .O(history_reg_0_31_22_22_i_7_n_0));
  LUT3 #(
    .INIT(8'h78)) 
    history_reg_0_31_22_22_i_8
       (.I0(context_word1),
        .I1(context_word0[180]),
        .I2(next_energy1__1[9]),
        .O(history_reg_0_31_22_22_i_8_n_0));
  LUT3 #(
    .INIT(8'h78)) 
    history_reg_0_31_22_22_i_9
       (.I0(context_word1),
        .I1(context_word0[179]),
        .I2(next_energy1__1[8]),
        .O(history_reg_0_31_22_22_i_9_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "23" *) 
  (* ram_slice_end = "23" *) 
  RAM32X1S history_reg_0_31_23_23
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_energy[9]),
        .O(next_mav4[23]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "24" *) 
  (* ram_slice_end = "24" *) 
  RAM32X1S history_reg_0_31_24_24
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_energy[10]),
        .O(next_mav4[24]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "25" *) 
  (* ram_slice_end = "25" *) 
  RAM32X1S history_reg_0_31_25_25
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_energy[11]),
        .O(next_mav4[25]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "26" *) 
  (* ram_slice_end = "26" *) 
  RAM32X1S history_reg_0_31_26_26
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_energy[12]),
        .O(next_mav4[26]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 history_reg_0_31_26_26_i_1
       (.CI(history_reg_0_31_22_22_i_1_n_0),
        .CO({history_reg_0_31_26_26_i_1_n_0,history_reg_0_31_26_26_i_1_n_1,history_reg_0_31_26_26_i_1_n_2,history_reg_0_31_26_26_i_1_n_3}),
        .CYINIT(1'b0),
        .DI({history_reg_0_31_26_26_i_2_n_0,history_reg_0_31_26_26_i_3_n_0,history_reg_0_31_26_26_i_4_n_0,history_reg_0_31_26_26_i_5_n_0}),
        .O(completed_energy[15:12]),
        .S({history_reg_0_31_26_26_i_6_n_0,history_reg_0_31_26_26_i_7_n_0,history_reg_0_31_26_26_i_8_n_0,history_reg_0_31_26_26_i_9_n_0}));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_26_26_i_2
       (.I0(context_word0[186]),
        .I1(context_word1),
        .O(history_reg_0_31_26_26_i_2_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_26_26_i_3
       (.I0(context_word0[185]),
        .I1(context_word1),
        .O(history_reg_0_31_26_26_i_3_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_26_26_i_4
       (.I0(context_word0[184]),
        .I1(context_word1),
        .O(history_reg_0_31_26_26_i_4_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_26_26_i_5
       (.I0(context_word0[183]),
        .I1(context_word1),
        .O(history_reg_0_31_26_26_i_5_n_0));
  LUT3 #(
    .INIT(8'h78)) 
    history_reg_0_31_26_26_i_6
       (.I0(context_word1),
        .I1(context_word0[186]),
        .I2(next_energy1__1[15]),
        .O(history_reg_0_31_26_26_i_6_n_0));
  LUT3 #(
    .INIT(8'h78)) 
    history_reg_0_31_26_26_i_7
       (.I0(context_word1),
        .I1(context_word0[185]),
        .I2(next_energy1__1[14]),
        .O(history_reg_0_31_26_26_i_7_n_0));
  LUT3 #(
    .INIT(8'h78)) 
    history_reg_0_31_26_26_i_8
       (.I0(context_word1),
        .I1(context_word0[184]),
        .I2(next_energy1__1[13]),
        .O(history_reg_0_31_26_26_i_8_n_0));
  LUT3 #(
    .INIT(8'h78)) 
    history_reg_0_31_26_26_i_9
       (.I0(context_word1),
        .I1(context_word0[183]),
        .I2(next_energy1__1[12]),
        .O(history_reg_0_31_26_26_i_9_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "27" *) 
  (* ram_slice_end = "27" *) 
  RAM32X1S history_reg_0_31_27_27
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_energy[13]),
        .O(next_mav4[27]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "28" *) 
  (* ram_slice_end = "28" *) 
  RAM32X1S history_reg_0_31_28_28
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_energy[14]),
        .O(next_mav4[28]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "29" *) 
  (* ram_slice_end = "29" *) 
  RAM32X1S history_reg_0_31_29_29
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_energy[15]),
        .O(next_mav4[29]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "2" *) 
  (* ram_slice_end = "2" *) 
  RAM32X1S history_reg_0_31_2_2
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_ssc[2]),
        .O(next_mav4[2]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  LUT5 #(
    .INIT(32'hAA2A0080)) 
    history_reg_0_31_2_2_i_1
       (.I0(context_word1),
        .I1(context_word0[158]),
        .I2(context_word0[157]),
        .I3(contexts_reg_0_7_157_157_i_4_n_0),
        .I4(context_word0[159]),
        .O(completed_ssc[2]));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "30" *) 
  (* ram_slice_end = "30" *) 
  RAM32X1S history_reg_0_31_30_30
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_energy[16]),
        .O(next_mav4[30]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 history_reg_0_31_30_30_i_1
       (.CI(history_reg_0_31_26_26_i_1_n_0),
        .CO({history_reg_0_31_30_30_i_1_n_0,history_reg_0_31_30_30_i_1_n_1,history_reg_0_31_30_30_i_1_n_2,history_reg_0_31_30_30_i_1_n_3}),
        .CYINIT(1'b0),
        .DI({history_reg_0_31_30_30_i_2_n_0,history_reg_0_31_30_30_i_3_n_0,history_reg_0_31_30_30_i_4_n_0,history_reg_0_31_30_30_i_5_n_0}),
        .O(completed_energy[19:16]),
        .S({history_reg_0_31_30_30_i_6_n_0,history_reg_0_31_30_30_i_7_n_0,history_reg_0_31_30_30_i_8_n_0,history_reg_0_31_30_30_i_9_n_0}));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_30_30_i_2
       (.I0(context_word0[190]),
        .I1(context_word1),
        .O(history_reg_0_31_30_30_i_2_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_30_30_i_3
       (.I0(context_word1),
        .I1(context_word0[189]),
        .O(history_reg_0_31_30_30_i_3_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_30_30_i_4
       (.I0(context_word1),
        .I1(context_word0[188]),
        .O(history_reg_0_31_30_30_i_4_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_30_30_i_5
       (.I0(context_word0[187]),
        .I1(context_word1),
        .O(history_reg_0_31_30_30_i_5_n_0));
  LUT3 #(
    .INIT(8'h78)) 
    history_reg_0_31_30_30_i_6
       (.I0(context_word1),
        .I1(context_word0[190]),
        .I2(next_energy1__1[19]),
        .O(history_reg_0_31_30_30_i_6_n_0));
  LUT3 #(
    .INIT(8'h78)) 
    history_reg_0_31_30_30_i_7
       (.I0(context_word0[189]),
        .I1(context_word1),
        .I2(next_energy1__1[18]),
        .O(history_reg_0_31_30_30_i_7_n_0));
  LUT3 #(
    .INIT(8'h78)) 
    history_reg_0_31_30_30_i_8
       (.I0(context_word0[188]),
        .I1(context_word1),
        .I2(next_energy1__1[17]),
        .O(history_reg_0_31_30_30_i_8_n_0));
  LUT3 #(
    .INIT(8'h78)) 
    history_reg_0_31_30_30_i_9
       (.I0(context_word1),
        .I1(context_word0[187]),
        .I2(next_energy1__1[16]),
        .O(history_reg_0_31_30_30_i_9_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "31" *) 
  (* ram_slice_end = "31" *) 
  RAM32X1S history_reg_0_31_31_31
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_energy[17]),
        .O(next_mav4[31]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "32" *) 
  (* ram_slice_end = "32" *) 
  RAM32X1S history_reg_0_31_32_32
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_energy[18]),
        .O(next_mav4[32]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "33" *) 
  (* ram_slice_end = "33" *) 
  RAM32X1S history_reg_0_31_33_33
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_energy[19]),
        .O(next_mav4[33]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "34" *) 
  (* ram_slice_end = "34" *) 
  RAM32X1S history_reg_0_31_34_34
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_energy[20]),
        .O(next_mav4[34]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 history_reg_0_31_34_34_i_1
       (.CI(history_reg_0_31_30_30_i_1_n_0),
        .CO({history_reg_0_31_34_34_i_1_n_0,history_reg_0_31_34_34_i_1_n_1,history_reg_0_31_34_34_i_1_n_2,history_reg_0_31_34_34_i_1_n_3}),
        .CYINIT(1'b0),
        .DI({history_reg_0_31_34_34_i_2_n_0,history_reg_0_31_34_34_i_3_n_0,history_reg_0_31_34_34_i_4_n_0,history_reg_0_31_34_34_i_5_n_0}),
        .O(completed_energy[23:20]),
        .S({history_reg_0_31_34_34_i_6_n_0,history_reg_0_31_34_34_i_7_n_0,history_reg_0_31_34_34_i_8_n_0,history_reg_0_31_34_34_i_9_n_0}));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_34_34_i_2
       (.I0(context_word0[194]),
        .I1(context_word1),
        .O(history_reg_0_31_34_34_i_2_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_34_34_i_3
       (.I0(context_word0[193]),
        .I1(context_word1),
        .O(history_reg_0_31_34_34_i_3_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_34_34_i_4
       (.I0(context_word0[192]),
        .I1(context_word1),
        .O(history_reg_0_31_34_34_i_4_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_34_34_i_5
       (.I0(context_word0[191]),
        .I1(context_word1),
        .O(history_reg_0_31_34_34_i_5_n_0));
  LUT3 #(
    .INIT(8'h78)) 
    history_reg_0_31_34_34_i_6
       (.I0(context_word1),
        .I1(context_word0[194]),
        .I2(next_energy1__1[23]),
        .O(history_reg_0_31_34_34_i_6_n_0));
  LUT3 #(
    .INIT(8'h78)) 
    history_reg_0_31_34_34_i_7
       (.I0(context_word1),
        .I1(context_word0[193]),
        .I2(next_energy1__1[22]),
        .O(history_reg_0_31_34_34_i_7_n_0));
  LUT3 #(
    .INIT(8'h78)) 
    history_reg_0_31_34_34_i_8
       (.I0(context_word1),
        .I1(context_word0[192]),
        .I2(next_energy1__1[21]),
        .O(history_reg_0_31_34_34_i_8_n_0));
  LUT3 #(
    .INIT(8'h78)) 
    history_reg_0_31_34_34_i_9
       (.I0(context_word1),
        .I1(context_word0[191]),
        .I2(next_energy1__1[20]),
        .O(history_reg_0_31_34_34_i_9_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "35" *) 
  (* ram_slice_end = "35" *) 
  RAM32X1S history_reg_0_31_35_35
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_energy[21]),
        .O(next_mav4[35]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "36" *) 
  (* ram_slice_end = "36" *) 
  RAM32X1S history_reg_0_31_36_36
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_energy[22]),
        .O(next_mav4[36]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "37" *) 
  (* ram_slice_end = "37" *) 
  RAM32X1S history_reg_0_31_37_37
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_energy[23]),
        .O(next_mav4[37]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "38" *) 
  (* ram_slice_end = "38" *) 
  RAM32X1S history_reg_0_31_38_38
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_energy[24]),
        .O(next_mav4[38]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 history_reg_0_31_38_38_i_1
       (.CI(history_reg_0_31_34_34_i_1_n_0),
        .CO({history_reg_0_31_38_38_i_1_n_0,history_reg_0_31_38_38_i_1_n_1,history_reg_0_31_38_38_i_1_n_2,history_reg_0_31_38_38_i_1_n_3}),
        .CYINIT(1'b0),
        .DI({history_reg_0_31_38_38_i_2_n_0,history_reg_0_31_38_38_i_3_n_0,history_reg_0_31_38_38_i_4_n_0,history_reg_0_31_38_38_i_5_n_0}),
        .O(completed_energy[27:24]),
        .S({history_reg_0_31_38_38_i_6_n_0,history_reg_0_31_38_38_i_7_n_0,history_reg_0_31_38_38_i_8_n_0,history_reg_0_31_38_38_i_9_n_0}));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_38_38_i_2
       (.I0(context_word1),
        .I1(context_word0[198]),
        .O(history_reg_0_31_38_38_i_2_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_38_38_i_3
       (.I0(context_word1),
        .I1(context_word0[197]),
        .O(history_reg_0_31_38_38_i_3_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_38_38_i_4
       (.I0(context_word0[196]),
        .I1(context_word1),
        .O(history_reg_0_31_38_38_i_4_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_38_38_i_5
       (.I0(context_word1),
        .I1(context_word0[195]),
        .O(history_reg_0_31_38_38_i_5_n_0));
  LUT3 #(
    .INIT(8'h78)) 
    history_reg_0_31_38_38_i_6
       (.I0(context_word1),
        .I1(context_word0[198]),
        .I2(next_energy1__1[27]),
        .O(history_reg_0_31_38_38_i_6_n_0));
  LUT3 #(
    .INIT(8'h78)) 
    history_reg_0_31_38_38_i_7
       (.I0(context_word0[197]),
        .I1(context_word1),
        .I2(next_energy1__1[26]),
        .O(history_reg_0_31_38_38_i_7_n_0));
  LUT3 #(
    .INIT(8'h78)) 
    history_reg_0_31_38_38_i_8
       (.I0(context_word1),
        .I1(context_word0[196]),
        .I2(next_energy1__1[25]),
        .O(history_reg_0_31_38_38_i_8_n_0));
  LUT3 #(
    .INIT(8'h78)) 
    history_reg_0_31_38_38_i_9
       (.I0(context_word0[195]),
        .I1(context_word1),
        .I2(next_energy1__1[24]),
        .O(history_reg_0_31_38_38_i_9_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "39" *) 
  (* ram_slice_end = "39" *) 
  RAM32X1S history_reg_0_31_39_39
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_energy[25]),
        .O(next_mav4[39]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "3" *) 
  (* ram_slice_end = "3" *) 
  RAM32X1S history_reg_0_31_3_3
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_ssc[3]),
        .O(next_mav4[3]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  LUT6 #(
    .INIT(64'hA0A0A0A060A0A0A0)) 
    history_reg_0_31_3_3_i_1
       (.I0(context_word0[160]),
        .I1(context_word0[159]),
        .I2(context_word1),
        .I3(context_word0[158]),
        .I4(context_word0[157]),
        .I5(contexts_reg_0_7_157_157_i_4_n_0),
        .O(completed_ssc[3]));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "40" *) 
  (* ram_slice_end = "40" *) 
  RAM32X1S history_reg_0_31_40_40
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_energy[26]),
        .O(next_mav4[40]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "41" *) 
  (* ram_slice_end = "41" *) 
  RAM32X1S history_reg_0_31_41_41
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_energy[27]),
        .O(next_mav4[41]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "42" *) 
  (* ram_slice_end = "42" *) 
  RAM32X1S history_reg_0_31_42_42
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_energy[28]),
        .O(next_mav4[42]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 history_reg_0_31_42_42_i_1
       (.CI(history_reg_0_31_38_38_i_1_n_0),
        .CO({NLW_history_reg_0_31_42_42_i_1_CO_UNCONNECTED[3],history_reg_0_31_42_42_i_1_n_1,history_reg_0_31_42_42_i_1_n_2,history_reg_0_31_42_42_i_1_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,history_reg_0_31_42_42_i_2_n_0,history_reg_0_31_42_42_i_3_n_0,history_reg_0_31_42_42_i_4_n_0}),
        .O(completed_energy[31:28]),
        .S({history_reg_0_31_42_42_i_5_n_0,history_reg_0_31_42_42_i_6_n_0,history_reg_0_31_42_42_i_7_n_0,history_reg_0_31_42_42_i_8_n_0}));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_42_42_i_2
       (.I0(context_word0[201]),
        .I1(context_word1),
        .O(history_reg_0_31_42_42_i_2_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_42_42_i_3
       (.I0(context_word0[200]),
        .I1(context_word1),
        .O(history_reg_0_31_42_42_i_3_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_42_42_i_4
       (.I0(context_word0[199]),
        .I1(context_word1),
        .O(history_reg_0_31_42_42_i_4_n_0));
  LUT3 #(
    .INIT(8'h6A)) 
    history_reg_0_31_42_42_i_5
       (.I0(next_energy1__1[31]),
        .I1(context_word1),
        .I2(context_word0[202]),
        .O(history_reg_0_31_42_42_i_5_n_0));
  LUT3 #(
    .INIT(8'h78)) 
    history_reg_0_31_42_42_i_6
       (.I0(context_word1),
        .I1(context_word0[201]),
        .I2(next_energy1__1[30]),
        .O(history_reg_0_31_42_42_i_6_n_0));
  LUT3 #(
    .INIT(8'h78)) 
    history_reg_0_31_42_42_i_7
       (.I0(context_word1),
        .I1(context_word0[200]),
        .I2(next_energy1__1[29]),
        .O(history_reg_0_31_42_42_i_7_n_0));
  LUT3 #(
    .INIT(8'h78)) 
    history_reg_0_31_42_42_i_8
       (.I0(context_word1),
        .I1(context_word0[199]),
        .I2(next_energy1__1[28]),
        .O(history_reg_0_31_42_42_i_8_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "43" *) 
  (* ram_slice_end = "43" *) 
  RAM32X1S history_reg_0_31_43_43
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_energy[29]),
        .O(next_mav4[43]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "44" *) 
  (* ram_slice_end = "44" *) 
  RAM32X1S history_reg_0_31_44_44
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_energy[30]),
        .O(next_mav4[44]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "45" *) 
  (* ram_slice_end = "45" *) 
  RAM32X1S history_reg_0_31_45_45
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_energy[31]),
        .O(next_mav4[45]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "46" *) 
  (* ram_slice_end = "46" *) 
  RAM32X1S history_reg_0_31_46_46
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_wl[0]),
        .O(next_mav4[46]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 history_reg_0_31_46_46_i_1
       (.CI(1'b0),
        .CO({history_reg_0_31_46_46_i_1_n_0,history_reg_0_31_46_46_i_1_n_1,history_reg_0_31_46_46_i_1_n_2,history_reg_0_31_46_46_i_1_n_3}),
        .CYINIT(1'b0),
        .DI({history_reg_0_31_46_46_i_2_n_0,history_reg_0_31_46_46_i_3_n_0,history_reg_0_31_46_46_i_4_n_0,history_reg_0_31_46_46_i_5_n_0}),
        .O(completed_wl[3:0]),
        .S({history_reg_0_31_46_46_i_6_n_0,history_reg_0_31_46_46_i_7_n_0,history_reg_0_31_46_46_i_8_n_0,history_reg_0_31_46_46_i_9_n_0}));
  CARRY4 history_reg_0_31_46_46_i_10
       (.CI(1'b0),
        .CO({history_reg_0_31_46_46_i_10_n_0,history_reg_0_31_46_46_i_10_n_1,history_reg_0_31_46_46_i_10_n_2,history_reg_0_31_46_46_i_10_n_3}),
        .CYINIT(1'b1),
        .DI(sample_data[3:0]),
        .O(abs_diff3[3:0]),
        .S({history_reg_0_31_46_46_i_12_n_0,history_reg_0_31_46_46_i_13_n_0,history_reg_0_31_46_46_i_14_n_0,history_reg_0_31_46_46_i_15_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 history_reg_0_31_46_46_i_11
       (.CI(1'b0),
        .CO({history_reg_0_31_46_46_i_11_n_0,history_reg_0_31_46_46_i_11_n_1,history_reg_0_31_46_46_i_11_n_2,history_reg_0_31_46_46_i_11_n_3}),
        .CYINIT(history_reg_0_31_46_46_i_16_n_0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(abs_diff1[4:1]),
        .S({history_reg_0_31_46_46_i_17_n_0,history_reg_0_31_46_46_i_18_n_0,history_reg_0_31_46_46_i_19_n_0,history_reg_0_31_46_46_i_20_n_0}));
  LUT3 #(
    .INIT(8'h95)) 
    history_reg_0_31_46_46_i_12
       (.I0(sample_data[3]),
        .I1(context_word1),
        .I2(context_word0[303]),
        .O(history_reg_0_31_46_46_i_12_n_0));
  LUT3 #(
    .INIT(8'h95)) 
    history_reg_0_31_46_46_i_13
       (.I0(sample_data[2]),
        .I1(context_word1),
        .I2(context_word0[302]),
        .O(history_reg_0_31_46_46_i_13_n_0));
  LUT3 #(
    .INIT(8'h95)) 
    history_reg_0_31_46_46_i_14
       (.I0(sample_data[1]),
        .I1(context_word1),
        .I2(context_word0[301]),
        .O(history_reg_0_31_46_46_i_14_n_0));
  LUT3 #(
    .INIT(8'h95)) 
    history_reg_0_31_46_46_i_15
       (.I0(sample_data[0]),
        .I1(context_word1),
        .I2(context_word0[300]),
        .O(history_reg_0_31_46_46_i_15_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_46_46_i_16
       (.I0(abs_diff3[0]),
        .O(history_reg_0_31_46_46_i_16_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_46_46_i_17
       (.I0(abs_diff3[4]),
        .O(history_reg_0_31_46_46_i_17_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_46_46_i_18
       (.I0(abs_diff3[3]),
        .O(history_reg_0_31_46_46_i_18_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_46_46_i_19
       (.I0(abs_diff3[2]),
        .O(history_reg_0_31_46_46_i_19_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_46_46_i_2
       (.I0(context_word1),
        .I1(context_word0[206]),
        .O(history_reg_0_31_46_46_i_2_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_46_46_i_20
       (.I0(abs_diff3[1]),
        .O(history_reg_0_31_46_46_i_20_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_46_46_i_3
       (.I0(context_word1),
        .I1(context_word0[205]),
        .O(history_reg_0_31_46_46_i_3_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_46_46_i_4
       (.I0(context_word1),
        .I1(context_word0[204]),
        .O(history_reg_0_31_46_46_i_4_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_46_46_i_5
       (.I0(context_word0[203]),
        .I1(context_word1),
        .O(history_reg_0_31_46_46_i_5_n_0));
  LUT5 #(
    .INIT(32'h656A0000)) 
    history_reg_0_31_46_46_i_6
       (.I0(context_word0[206]),
        .I1(abs_diff3[3]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff1[3]),
        .I4(context_word1),
        .O(history_reg_0_31_46_46_i_6_n_0));
  LUT5 #(
    .INIT(32'h656A0000)) 
    history_reg_0_31_46_46_i_7
       (.I0(context_word0[205]),
        .I1(abs_diff3[2]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff1[2]),
        .I4(context_word1),
        .O(history_reg_0_31_46_46_i_7_n_0));
  LUT5 #(
    .INIT(32'h656A0000)) 
    history_reg_0_31_46_46_i_8
       (.I0(context_word0[204]),
        .I1(abs_diff3[1]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff1[1]),
        .I4(context_word1),
        .O(history_reg_0_31_46_46_i_8_n_0));
  LUT3 #(
    .INIT(8'h60)) 
    history_reg_0_31_46_46_i_9
       (.I0(context_word0[203]),
        .I1(abs_diff3[0]),
        .I2(context_word1),
        .O(history_reg_0_31_46_46_i_9_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "47" *) 
  (* ram_slice_end = "47" *) 
  RAM32X1S history_reg_0_31_47_47
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_wl[1]),
        .O(next_mav4[47]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "48" *) 
  (* ram_slice_end = "48" *) 
  RAM32X1S history_reg_0_31_48_48
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_wl[2]),
        .O(next_mav4[48]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "49" *) 
  (* ram_slice_end = "49" *) 
  RAM32X1S history_reg_0_31_49_49
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_wl[3]),
        .O(next_mav4[49]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "4" *) 
  (* ram_slice_end = "4" *) 
  RAM32X1S history_reg_0_31_4_4
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_ssc[4]),
        .O(next_mav4[4]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  LUT3 #(
    .INIT(8'h83)) 
    history_reg_0_31_4_4_i_1
       (.I0(context_word1),
        .I1(contexts_reg_0_7_161_161_i_2_n_0),
        .I2(context_word0[161]),
        .O(completed_ssc[4]));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "50" *) 
  (* ram_slice_end = "50" *) 
  RAM32X1S history_reg_0_31_50_50
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_wl[4]),
        .O(next_mav4[50]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 history_reg_0_31_50_50_i_1
       (.CI(history_reg_0_31_46_46_i_1_n_0),
        .CO({history_reg_0_31_50_50_i_1_n_0,history_reg_0_31_50_50_i_1_n_1,history_reg_0_31_50_50_i_1_n_2,history_reg_0_31_50_50_i_1_n_3}),
        .CYINIT(1'b0),
        .DI({history_reg_0_31_50_50_i_2_n_0,history_reg_0_31_50_50_i_3_n_0,history_reg_0_31_50_50_i_4_n_0,history_reg_0_31_50_50_i_5_n_0}),
        .O(completed_wl[7:4]),
        .S({history_reg_0_31_50_50_i_6_n_0,history_reg_0_31_50_50_i_7_n_0,history_reg_0_31_50_50_i_8_n_0,history_reg_0_31_50_50_i_9_n_0}));
  CARRY4 history_reg_0_31_50_50_i_10
       (.CI(history_reg_0_31_46_46_i_10_n_0),
        .CO({history_reg_0_31_50_50_i_10_n_0,history_reg_0_31_50_50_i_10_n_1,history_reg_0_31_50_50_i_10_n_2,history_reg_0_31_50_50_i_10_n_3}),
        .CYINIT(1'b0),
        .DI(sample_data[7:4]),
        .O(abs_diff3[7:4]),
        .S({history_reg_0_31_50_50_i_12_n_0,history_reg_0_31_50_50_i_13_n_0,history_reg_0_31_50_50_i_14_n_0,history_reg_0_31_50_50_i_15_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 history_reg_0_31_50_50_i_11
       (.CI(history_reg_0_31_46_46_i_11_n_0),
        .CO({history_reg_0_31_50_50_i_11_n_0,history_reg_0_31_50_50_i_11_n_1,history_reg_0_31_50_50_i_11_n_2,history_reg_0_31_50_50_i_11_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(abs_diff1[8:5]),
        .S({history_reg_0_31_50_50_i_16_n_0,history_reg_0_31_50_50_i_17_n_0,history_reg_0_31_50_50_i_18_n_0,history_reg_0_31_50_50_i_19_n_0}));
  LUT3 #(
    .INIT(8'h95)) 
    history_reg_0_31_50_50_i_12
       (.I0(sample_data[7]),
        .I1(context_word1),
        .I2(context_word0[307]),
        .O(history_reg_0_31_50_50_i_12_n_0));
  LUT3 #(
    .INIT(8'h95)) 
    history_reg_0_31_50_50_i_13
       (.I0(sample_data[6]),
        .I1(context_word1),
        .I2(context_word0[306]),
        .O(history_reg_0_31_50_50_i_13_n_0));
  LUT3 #(
    .INIT(8'h95)) 
    history_reg_0_31_50_50_i_14
       (.I0(sample_data[5]),
        .I1(context_word1),
        .I2(context_word0[305]),
        .O(history_reg_0_31_50_50_i_14_n_0));
  LUT3 #(
    .INIT(8'h95)) 
    history_reg_0_31_50_50_i_15
       (.I0(sample_data[4]),
        .I1(context_word1),
        .I2(context_word0[304]),
        .O(history_reg_0_31_50_50_i_15_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_50_50_i_16
       (.I0(abs_diff3[8]),
        .O(history_reg_0_31_50_50_i_16_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_50_50_i_17
       (.I0(abs_diff3[7]),
        .O(history_reg_0_31_50_50_i_17_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_50_50_i_18
       (.I0(abs_diff3[6]),
        .O(history_reg_0_31_50_50_i_18_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_50_50_i_19
       (.I0(abs_diff3[5]),
        .O(history_reg_0_31_50_50_i_19_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_50_50_i_2
       (.I0(context_word1),
        .I1(context_word0[210]),
        .O(history_reg_0_31_50_50_i_2_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_50_50_i_3
       (.I0(context_word1),
        .I1(context_word0[209]),
        .O(history_reg_0_31_50_50_i_3_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_50_50_i_4
       (.I0(context_word1),
        .I1(context_word0[208]),
        .O(history_reg_0_31_50_50_i_4_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_50_50_i_5
       (.I0(context_word1),
        .I1(context_word0[207]),
        .O(history_reg_0_31_50_50_i_5_n_0));
  LUT5 #(
    .INIT(32'h656A0000)) 
    history_reg_0_31_50_50_i_6
       (.I0(context_word0[210]),
        .I1(abs_diff3[7]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff1[7]),
        .I4(context_word1),
        .O(history_reg_0_31_50_50_i_6_n_0));
  LUT5 #(
    .INIT(32'h656A0000)) 
    history_reg_0_31_50_50_i_7
       (.I0(context_word0[209]),
        .I1(abs_diff3[6]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff1[6]),
        .I4(context_word1),
        .O(history_reg_0_31_50_50_i_7_n_0));
  LUT5 #(
    .INIT(32'h656A0000)) 
    history_reg_0_31_50_50_i_8
       (.I0(context_word0[208]),
        .I1(abs_diff3[5]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff1[5]),
        .I4(context_word1),
        .O(history_reg_0_31_50_50_i_8_n_0));
  LUT5 #(
    .INIT(32'h656A0000)) 
    history_reg_0_31_50_50_i_9
       (.I0(context_word0[207]),
        .I1(abs_diff3[4]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff1[4]),
        .I4(context_word1),
        .O(history_reg_0_31_50_50_i_9_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "51" *) 
  (* ram_slice_end = "51" *) 
  RAM32X1S history_reg_0_31_51_51
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_wl[5]),
        .O(next_mav4[51]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "52" *) 
  (* ram_slice_end = "52" *) 
  RAM32X1S history_reg_0_31_52_52
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_wl[6]),
        .O(next_mav4[52]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "53" *) 
  (* ram_slice_end = "53" *) 
  RAM32X1S history_reg_0_31_53_53
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_wl[7]),
        .O(next_mav4[53]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "54" *) 
  (* ram_slice_end = "54" *) 
  RAM32X1S history_reg_0_31_54_54
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_wl[8]),
        .O(next_mav4[54]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 history_reg_0_31_54_54_i_1
       (.CI(history_reg_0_31_50_50_i_1_n_0),
        .CO({history_reg_0_31_54_54_i_1_n_0,history_reg_0_31_54_54_i_1_n_1,history_reg_0_31_54_54_i_1_n_2,history_reg_0_31_54_54_i_1_n_3}),
        .CYINIT(1'b0),
        .DI({history_reg_0_31_54_54_i_2_n_0,history_reg_0_31_54_54_i_3_n_0,history_reg_0_31_54_54_i_4_n_0,history_reg_0_31_54_54_i_5_n_0}),
        .O(completed_wl[11:8]),
        .S({history_reg_0_31_54_54_i_6_n_0,history_reg_0_31_54_54_i_7_n_0,history_reg_0_31_54_54_i_8_n_0,history_reg_0_31_54_54_i_9_n_0}));
  CARRY4 history_reg_0_31_54_54_i_10
       (.CI(history_reg_0_31_50_50_i_10_n_0),
        .CO({history_reg_0_31_54_54_i_10_n_0,history_reg_0_31_54_54_i_10_n_1,history_reg_0_31_54_54_i_10_n_2,history_reg_0_31_54_54_i_10_n_3}),
        .CYINIT(1'b0),
        .DI(sample_data[11:8]),
        .O(abs_diff3[11:8]),
        .S({history_reg_0_31_54_54_i_12_n_0,history_reg_0_31_54_54_i_13_n_0,history_reg_0_31_54_54_i_14_n_0,history_reg_0_31_54_54_i_15_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 history_reg_0_31_54_54_i_11
       (.CI(history_reg_0_31_50_50_i_11_n_0),
        .CO({history_reg_0_31_54_54_i_11_n_0,history_reg_0_31_54_54_i_11_n_1,history_reg_0_31_54_54_i_11_n_2,history_reg_0_31_54_54_i_11_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(abs_diff1[12:9]),
        .S({history_reg_0_31_54_54_i_16_n_0,history_reg_0_31_54_54_i_17_n_0,history_reg_0_31_54_54_i_18_n_0,history_reg_0_31_54_54_i_19_n_0}));
  LUT3 #(
    .INIT(8'h95)) 
    history_reg_0_31_54_54_i_12
       (.I0(sample_data[11]),
        .I1(context_word1),
        .I2(context_word0[311]),
        .O(history_reg_0_31_54_54_i_12_n_0));
  LUT3 #(
    .INIT(8'h95)) 
    history_reg_0_31_54_54_i_13
       (.I0(sample_data[10]),
        .I1(context_word1),
        .I2(context_word0[310]),
        .O(history_reg_0_31_54_54_i_13_n_0));
  LUT3 #(
    .INIT(8'h95)) 
    history_reg_0_31_54_54_i_14
       (.I0(sample_data[9]),
        .I1(context_word1),
        .I2(context_word0[309]),
        .O(history_reg_0_31_54_54_i_14_n_0));
  LUT3 #(
    .INIT(8'h95)) 
    history_reg_0_31_54_54_i_15
       (.I0(sample_data[8]),
        .I1(context_word1),
        .I2(context_word0[308]),
        .O(history_reg_0_31_54_54_i_15_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_54_54_i_16
       (.I0(abs_diff3[12]),
        .O(history_reg_0_31_54_54_i_16_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_54_54_i_17
       (.I0(abs_diff3[11]),
        .O(history_reg_0_31_54_54_i_17_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_54_54_i_18
       (.I0(abs_diff3[10]),
        .O(history_reg_0_31_54_54_i_18_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_54_54_i_19
       (.I0(abs_diff3[9]),
        .O(history_reg_0_31_54_54_i_19_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_54_54_i_2
       (.I0(context_word1),
        .I1(context_word0[214]),
        .O(history_reg_0_31_54_54_i_2_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_54_54_i_3
       (.I0(context_word1),
        .I1(context_word0[213]),
        .O(history_reg_0_31_54_54_i_3_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_54_54_i_4
       (.I0(context_word1),
        .I1(context_word0[212]),
        .O(history_reg_0_31_54_54_i_4_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_54_54_i_5
       (.I0(context_word1),
        .I1(context_word0[211]),
        .O(history_reg_0_31_54_54_i_5_n_0));
  LUT5 #(
    .INIT(32'h656A0000)) 
    history_reg_0_31_54_54_i_6
       (.I0(context_word0[214]),
        .I1(abs_diff3[11]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff1[11]),
        .I4(context_word1),
        .O(history_reg_0_31_54_54_i_6_n_0));
  LUT5 #(
    .INIT(32'h656A0000)) 
    history_reg_0_31_54_54_i_7
       (.I0(context_word0[213]),
        .I1(abs_diff3[10]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff1[10]),
        .I4(context_word1),
        .O(history_reg_0_31_54_54_i_7_n_0));
  LUT5 #(
    .INIT(32'h656A0000)) 
    history_reg_0_31_54_54_i_8
       (.I0(context_word0[212]),
        .I1(abs_diff3[9]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff1[9]),
        .I4(context_word1),
        .O(history_reg_0_31_54_54_i_8_n_0));
  LUT5 #(
    .INIT(32'h656A0000)) 
    history_reg_0_31_54_54_i_9
       (.I0(context_word0[211]),
        .I1(abs_diff3[8]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff1[8]),
        .I4(context_word1),
        .O(history_reg_0_31_54_54_i_9_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "55" *) 
  (* ram_slice_end = "55" *) 
  RAM32X1S history_reg_0_31_55_55
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_wl[9]),
        .O(next_mav4[55]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "56" *) 
  (* ram_slice_end = "56" *) 
  RAM32X1S history_reg_0_31_56_56
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_wl[10]),
        .O(next_mav4[56]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "57" *) 
  (* ram_slice_end = "57" *) 
  RAM32X1S history_reg_0_31_57_57
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_wl[11]),
        .O(next_mav4[57]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "58" *) 
  (* ram_slice_end = "58" *) 
  RAM32X1S history_reg_0_31_58_58
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_wl[12]),
        .O(next_mav4[58]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 history_reg_0_31_58_58_i_1
       (.CI(history_reg_0_31_54_54_i_1_n_0),
        .CO({history_reg_0_31_58_58_i_1_n_0,history_reg_0_31_58_58_i_1_n_1,history_reg_0_31_58_58_i_1_n_2,history_reg_0_31_58_58_i_1_n_3}),
        .CYINIT(1'b0),
        .DI({history_reg_0_31_58_58_i_2_n_0,history_reg_0_31_58_58_i_3_n_0,history_reg_0_31_58_58_i_4_n_0,history_reg_0_31_58_58_i_5_n_0}),
        .O(completed_wl[15:12]),
        .S({history_reg_0_31_58_58_i_6_n_0,history_reg_0_31_58_58_i_7_n_0,history_reg_0_31_58_58_i_8_n_0,history_reg_0_31_58_58_i_9_n_0}));
  CARRY4 history_reg_0_31_58_58_i_10
       (.CI(history_reg_0_31_54_54_i_10_n_0),
        .CO({history_reg_0_31_58_58_i_10_n_0,history_reg_0_31_58_58_i_10_n_1,history_reg_0_31_58_58_i_10_n_2,history_reg_0_31_58_58_i_10_n_3}),
        .CYINIT(1'b0),
        .DI(sample_data[15:12]),
        .O(abs_diff3[15:12]),
        .S({history_reg_0_31_58_58_i_12_n_0,history_reg_0_31_58_58_i_13_n_0,history_reg_0_31_58_58_i_14_n_0,history_reg_0_31_58_58_i_15_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 history_reg_0_31_58_58_i_11
       (.CI(history_reg_0_31_54_54_i_11_n_0),
        .CO({history_reg_0_31_58_58_i_11_n_0,history_reg_0_31_58_58_i_11_n_1,history_reg_0_31_58_58_i_11_n_2,history_reg_0_31_58_58_i_11_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(abs_diff1[16:13]),
        .S({history_reg_0_31_58_58_i_16_n_0,history_reg_0_31_58_58_i_17_n_0,history_reg_0_31_58_58_i_18_n_0,history_reg_0_31_58_58_i_19_n_0}));
  LUT3 #(
    .INIT(8'h95)) 
    history_reg_0_31_58_58_i_12
       (.I0(sample_data[15]),
        .I1(context_word1),
        .I2(context_word0[315]),
        .O(history_reg_0_31_58_58_i_12_n_0));
  LUT3 #(
    .INIT(8'h95)) 
    history_reg_0_31_58_58_i_13
       (.I0(sample_data[14]),
        .I1(context_word1),
        .I2(context_word0[314]),
        .O(history_reg_0_31_58_58_i_13_n_0));
  LUT3 #(
    .INIT(8'h95)) 
    history_reg_0_31_58_58_i_14
       (.I0(sample_data[13]),
        .I1(context_word1),
        .I2(context_word0[313]),
        .O(history_reg_0_31_58_58_i_14_n_0));
  LUT3 #(
    .INIT(8'h95)) 
    history_reg_0_31_58_58_i_15
       (.I0(sample_data[12]),
        .I1(context_word1),
        .I2(context_word0[312]),
        .O(history_reg_0_31_58_58_i_15_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_58_58_i_16
       (.I0(abs_diff3[16]),
        .O(history_reg_0_31_58_58_i_16_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_58_58_i_17
       (.I0(abs_diff3[15]),
        .O(history_reg_0_31_58_58_i_17_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_58_58_i_18
       (.I0(abs_diff3[14]),
        .O(history_reg_0_31_58_58_i_18_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_58_58_i_19
       (.I0(abs_diff3[13]),
        .O(history_reg_0_31_58_58_i_19_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_58_58_i_2
       (.I0(context_word1),
        .I1(context_word0[218]),
        .O(history_reg_0_31_58_58_i_2_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_58_58_i_3
       (.I0(context_word1),
        .I1(context_word0[217]),
        .O(history_reg_0_31_58_58_i_3_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_58_58_i_4
       (.I0(context_word1),
        .I1(context_word0[216]),
        .O(history_reg_0_31_58_58_i_4_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_58_58_i_5
       (.I0(context_word1),
        .I1(context_word0[215]),
        .O(history_reg_0_31_58_58_i_5_n_0));
  LUT5 #(
    .INIT(32'h656A0000)) 
    history_reg_0_31_58_58_i_6
       (.I0(context_word0[218]),
        .I1(abs_diff3[15]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff1[15]),
        .I4(context_word1),
        .O(history_reg_0_31_58_58_i_6_n_0));
  LUT5 #(
    .INIT(32'h656A0000)) 
    history_reg_0_31_58_58_i_7
       (.I0(context_word0[217]),
        .I1(abs_diff3[14]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff1[14]),
        .I4(context_word1),
        .O(history_reg_0_31_58_58_i_7_n_0));
  LUT5 #(
    .INIT(32'h656A0000)) 
    history_reg_0_31_58_58_i_8
       (.I0(context_word0[216]),
        .I1(abs_diff3[13]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff1[13]),
        .I4(context_word1),
        .O(history_reg_0_31_58_58_i_8_n_0));
  LUT5 #(
    .INIT(32'h656A0000)) 
    history_reg_0_31_58_58_i_9
       (.I0(context_word0[215]),
        .I1(abs_diff3[12]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff1[12]),
        .I4(context_word1),
        .O(history_reg_0_31_58_58_i_9_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "59" *) 
  (* ram_slice_end = "59" *) 
  RAM32X1S history_reg_0_31_59_59
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_wl[13]),
        .O(next_mav4[59]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "5" *) 
  (* ram_slice_end = "5" *) 
  RAM32X1S history_reg_0_31_5_5
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_ssc[5]),
        .O(next_mav4[5]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  LUT4 #(
    .INIT(16'h8788)) 
    history_reg_0_31_5_5_i_1
       (.I0(context_word1),
        .I1(context_word0[162]),
        .I2(contexts_reg_0_7_161_161_i_2_n_0),
        .I3(context_word0[161]),
        .O(completed_ssc[5]));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "60" *) 
  (* ram_slice_end = "60" *) 
  RAM32X1S history_reg_0_31_60_60
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_wl[14]),
        .O(next_mav4[60]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "61" *) 
  (* ram_slice_end = "61" *) 
  RAM32X1S history_reg_0_31_61_61
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_wl[15]),
        .O(next_mav4[61]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "62" *) 
  (* ram_slice_end = "62" *) 
  RAM32X1S history_reg_0_31_62_62
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_wl[16]),
        .O(next_mav4[62]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 history_reg_0_31_62_62_i_1
       (.CI(history_reg_0_31_58_58_i_1_n_0),
        .CO({history_reg_0_31_62_62_i_1_n_0,history_reg_0_31_62_62_i_1_n_1,history_reg_0_31_62_62_i_1_n_2,history_reg_0_31_62_62_i_1_n_3}),
        .CYINIT(1'b0),
        .DI({history_reg_0_31_62_62_i_2_n_0,history_reg_0_31_62_62_i_3_n_0,history_reg_0_31_62_62_i_4_n_0,history_reg_0_31_62_62_i_5_n_0}),
        .O(completed_wl[19:16]),
        .S({history_reg_0_31_62_62_i_6_n_0,history_reg_0_31_62_62_i_7_n_0,history_reg_0_31_62_62_i_8_n_0,history_reg_0_31_62_62_i_9_n_0}));
  CARRY4 history_reg_0_31_62_62_i_10
       (.CI(history_reg_0_31_58_58_i_10_n_0),
        .CO({history_reg_0_31_62_62_i_10_n_0,history_reg_0_31_62_62_i_10_n_1,history_reg_0_31_62_62_i_10_n_2,history_reg_0_31_62_62_i_10_n_3}),
        .CYINIT(1'b0),
        .DI(sample_data[19:16]),
        .O(abs_diff3[19:16]),
        .S({history_reg_0_31_62_62_i_12_n_0,history_reg_0_31_62_62_i_13_n_0,history_reg_0_31_62_62_i_14_n_0,history_reg_0_31_62_62_i_15_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 history_reg_0_31_62_62_i_11
       (.CI(history_reg_0_31_58_58_i_11_n_0),
        .CO({history_reg_0_31_62_62_i_11_n_0,history_reg_0_31_62_62_i_11_n_1,history_reg_0_31_62_62_i_11_n_2,history_reg_0_31_62_62_i_11_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(abs_diff1[20:17]),
        .S({history_reg_0_31_62_62_i_16_n_0,history_reg_0_31_62_62_i_17_n_0,history_reg_0_31_62_62_i_18_n_0,history_reg_0_31_62_62_i_19_n_0}));
  LUT3 #(
    .INIT(8'h95)) 
    history_reg_0_31_62_62_i_12
       (.I0(sample_data[19]),
        .I1(context_word1),
        .I2(context_word0[319]),
        .O(history_reg_0_31_62_62_i_12_n_0));
  LUT3 #(
    .INIT(8'h95)) 
    history_reg_0_31_62_62_i_13
       (.I0(sample_data[18]),
        .I1(context_word1),
        .I2(context_word0[318]),
        .O(history_reg_0_31_62_62_i_13_n_0));
  LUT3 #(
    .INIT(8'h95)) 
    history_reg_0_31_62_62_i_14
       (.I0(sample_data[17]),
        .I1(context_word1),
        .I2(context_word0[317]),
        .O(history_reg_0_31_62_62_i_14_n_0));
  LUT3 #(
    .INIT(8'h95)) 
    history_reg_0_31_62_62_i_15
       (.I0(sample_data[16]),
        .I1(context_word1),
        .I2(context_word0[316]),
        .O(history_reg_0_31_62_62_i_15_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_62_62_i_16
       (.I0(abs_diff3[20]),
        .O(history_reg_0_31_62_62_i_16_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_62_62_i_17
       (.I0(abs_diff3[19]),
        .O(history_reg_0_31_62_62_i_17_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_62_62_i_18
       (.I0(abs_diff3[18]),
        .O(history_reg_0_31_62_62_i_18_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_62_62_i_19
       (.I0(abs_diff3[17]),
        .O(history_reg_0_31_62_62_i_19_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_62_62_i_2
       (.I0(context_word1),
        .I1(context_word0[222]),
        .O(history_reg_0_31_62_62_i_2_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_62_62_i_3
       (.I0(context_word1),
        .I1(context_word0[221]),
        .O(history_reg_0_31_62_62_i_3_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_62_62_i_4
       (.I0(context_word1),
        .I1(context_word0[220]),
        .O(history_reg_0_31_62_62_i_4_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_62_62_i_5
       (.I0(context_word1),
        .I1(context_word0[219]),
        .O(history_reg_0_31_62_62_i_5_n_0));
  LUT5 #(
    .INIT(32'h656A0000)) 
    history_reg_0_31_62_62_i_6
       (.I0(context_word0[222]),
        .I1(abs_diff3[19]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff1[19]),
        .I4(context_word1),
        .O(history_reg_0_31_62_62_i_6_n_0));
  LUT5 #(
    .INIT(32'h656A0000)) 
    history_reg_0_31_62_62_i_7
       (.I0(context_word0[221]),
        .I1(abs_diff3[18]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff1[18]),
        .I4(context_word1),
        .O(history_reg_0_31_62_62_i_7_n_0));
  LUT5 #(
    .INIT(32'h656A0000)) 
    history_reg_0_31_62_62_i_8
       (.I0(context_word0[220]),
        .I1(abs_diff3[17]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff1[17]),
        .I4(context_word1),
        .O(history_reg_0_31_62_62_i_8_n_0));
  LUT5 #(
    .INIT(32'h656A0000)) 
    history_reg_0_31_62_62_i_9
       (.I0(context_word0[219]),
        .I1(abs_diff3[16]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff1[16]),
        .I4(context_word1),
        .O(history_reg_0_31_62_62_i_9_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "63" *) 
  (* ram_slice_end = "63" *) 
  RAM32X1S history_reg_0_31_63_63
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_wl[17]),
        .O(next_mav4[63]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "64" *) 
  (* ram_slice_end = "64" *) 
  RAM32X1S history_reg_0_31_64_64
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_wl[18]),
        .O(next_mav4[64]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "65" *) 
  (* ram_slice_end = "65" *) 
  RAM32X1S history_reg_0_31_65_65
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_wl[19]),
        .O(next_mav4[65]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "66" *) 
  (* ram_slice_end = "66" *) 
  RAM32X1S history_reg_0_31_66_66
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_wl[20]),
        .O(next_mav4[66]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 history_reg_0_31_66_66_i_1
       (.CI(history_reg_0_31_62_62_i_1_n_0),
        .CO({history_reg_0_31_66_66_i_1_n_0,history_reg_0_31_66_66_i_1_n_1,history_reg_0_31_66_66_i_1_n_2,history_reg_0_31_66_66_i_1_n_3}),
        .CYINIT(1'b0),
        .DI({history_reg_0_31_66_66_i_2_n_0,history_reg_0_31_66_66_i_3_n_0,history_reg_0_31_66_66_i_4_n_0,history_reg_0_31_66_66_i_5_n_0}),
        .O(completed_wl[23:20]),
        .S({history_reg_0_31_66_66_i_6_n_0,history_reg_0_31_66_66_i_7_n_0,history_reg_0_31_66_66_i_8_n_0,history_reg_0_31_66_66_i_9_n_0}));
  CARRY4 history_reg_0_31_66_66_i_10
       (.CI(history_reg_0_31_62_62_i_10_n_0),
        .CO({history_reg_0_31_66_66_i_10_n_0,history_reg_0_31_66_66_i_10_n_1,history_reg_0_31_66_66_i_10_n_2,history_reg_0_31_66_66_i_10_n_3}),
        .CYINIT(1'b0),
        .DI({history_reg_0_31_66_66_i_12_n_0,sample_data[22:20]}),
        .O(abs_diff3[23:20]),
        .S({history_reg_0_31_66_66_i_13_n_0,history_reg_0_31_66_66_i_14_n_0,history_reg_0_31_66_66_i_15_n_0,history_reg_0_31_66_66_i_16_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 history_reg_0_31_66_66_i_11
       (.CI(history_reg_0_31_62_62_i_11_n_0),
        .CO({NLW_history_reg_0_31_66_66_i_11_CO_UNCONNECTED[3],history_reg_0_31_66_66_i_11_n_1,history_reg_0_31_66_66_i_11_n_2,history_reg_0_31_66_66_i_11_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(abs_diff1[24:21]),
        .S({contexts_reg_0_7_157_157_i_6_n_3,history_reg_0_31_66_66_i_17_n_0,history_reg_0_31_66_66_i_18_n_0,history_reg_0_31_66_66_i_19_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_66_66_i_12
       (.I0(sample_data[23]),
        .O(history_reg_0_31_66_66_i_12_n_0));
  LUT3 #(
    .INIT(8'h95)) 
    history_reg_0_31_66_66_i_13
       (.I0(sample_data[23]),
        .I1(context_word1),
        .I2(context_word0[323]),
        .O(history_reg_0_31_66_66_i_13_n_0));
  LUT3 #(
    .INIT(8'h95)) 
    history_reg_0_31_66_66_i_14
       (.I0(sample_data[22]),
        .I1(context_word1),
        .I2(context_word0[322]),
        .O(history_reg_0_31_66_66_i_14_n_0));
  LUT3 #(
    .INIT(8'h95)) 
    history_reg_0_31_66_66_i_15
       (.I0(sample_data[21]),
        .I1(context_word1),
        .I2(context_word0[321]),
        .O(history_reg_0_31_66_66_i_15_n_0));
  LUT3 #(
    .INIT(8'h95)) 
    history_reg_0_31_66_66_i_16
       (.I0(sample_data[20]),
        .I1(context_word1),
        .I2(context_word0[320]),
        .O(history_reg_0_31_66_66_i_16_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_66_66_i_17
       (.I0(abs_diff3[23]),
        .O(history_reg_0_31_66_66_i_17_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_66_66_i_18
       (.I0(abs_diff3[22]),
        .O(history_reg_0_31_66_66_i_18_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_66_66_i_19
       (.I0(abs_diff3[21]),
        .O(history_reg_0_31_66_66_i_19_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_66_66_i_2
       (.I0(context_word1),
        .I1(context_word0[226]),
        .O(history_reg_0_31_66_66_i_2_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_66_66_i_3
       (.I0(context_word1),
        .I1(context_word0[225]),
        .O(history_reg_0_31_66_66_i_3_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_66_66_i_4
       (.I0(context_word1),
        .I1(context_word0[224]),
        .O(history_reg_0_31_66_66_i_4_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_66_66_i_5
       (.I0(context_word1),
        .I1(context_word0[223]),
        .O(history_reg_0_31_66_66_i_5_n_0));
  LUT5 #(
    .INIT(32'h656A0000)) 
    history_reg_0_31_66_66_i_6
       (.I0(context_word0[226]),
        .I1(abs_diff3[23]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff1[23]),
        .I4(context_word1),
        .O(history_reg_0_31_66_66_i_6_n_0));
  LUT5 #(
    .INIT(32'h656A0000)) 
    history_reg_0_31_66_66_i_7
       (.I0(context_word0[225]),
        .I1(abs_diff3[22]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff1[22]),
        .I4(context_word1),
        .O(history_reg_0_31_66_66_i_7_n_0));
  LUT5 #(
    .INIT(32'h656A0000)) 
    history_reg_0_31_66_66_i_8
       (.I0(context_word0[224]),
        .I1(abs_diff3[21]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff1[21]),
        .I4(context_word1),
        .O(history_reg_0_31_66_66_i_8_n_0));
  LUT5 #(
    .INIT(32'h656A0000)) 
    history_reg_0_31_66_66_i_9
       (.I0(context_word0[223]),
        .I1(abs_diff3[20]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(abs_diff1[20]),
        .I4(context_word1),
        .O(history_reg_0_31_66_66_i_9_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "67" *) 
  (* ram_slice_end = "67" *) 
  RAM32X1S history_reg_0_31_67_67
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_wl[21]),
        .O(next_mav4[67]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "68" *) 
  (* ram_slice_end = "68" *) 
  RAM32X1S history_reg_0_31_68_68
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_wl[22]),
        .O(next_mav4[68]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "69" *) 
  (* ram_slice_end = "69" *) 
  RAM32X1S history_reg_0_31_69_69
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_wl[23]),
        .O(next_mav4[69]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "6" *) 
  (* ram_slice_end = "6" *) 
  RAM32X1S history_reg_0_31_6_6
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(history_reg_0_31_6_6_i_1_n_0),
        .O(next_mav4[6]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  LUT5 #(
    .INIT(32'h90A0A0A0)) 
    history_reg_0_31_6_6_i_1
       (.I0(context_word0[163]),
        .I1(contexts_reg_0_7_161_161_i_2_n_0),
        .I2(context_word1),
        .I3(context_word0[161]),
        .I4(context_word0[162]),
        .O(history_reg_0_31_6_6_i_1_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "70" *) 
  (* ram_slice_end = "70" *) 
  RAM32X1S history_reg_0_31_70_70
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_wl[24]),
        .O(next_mav4[70]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 history_reg_0_31_70_70_i_1
       (.CI(history_reg_0_31_66_66_i_1_n_0),
        .CO({history_reg_0_31_70_70_i_1_n_0,history_reg_0_31_70_70_i_1_n_1,history_reg_0_31_70_70_i_1_n_2,history_reg_0_31_70_70_i_1_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,history_reg_0_31_70_70_i_2_n_0}),
        .O(completed_wl[27:24]),
        .S({history_reg_0_31_70_70_i_3_n_0,history_reg_0_31_70_70_i_4_n_0,history_reg_0_31_70_70_i_5_n_0,history_reg_0_31_70_70_i_6_n_0}));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_70_70_i_2
       (.I0(context_word0[227]),
        .I1(context_word1),
        .O(history_reg_0_31_70_70_i_2_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_70_70_i_3
       (.I0(context_word1),
        .I1(context_word0[230]),
        .O(history_reg_0_31_70_70_i_3_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_70_70_i_4
       (.I0(context_word1),
        .I1(context_word0[229]),
        .O(history_reg_0_31_70_70_i_4_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_70_70_i_5
       (.I0(context_word1),
        .I1(context_word0[228]),
        .O(history_reg_0_31_70_70_i_5_n_0));
  LUT4 #(
    .INIT(16'hA600)) 
    history_reg_0_31_70_70_i_6
       (.I0(context_word0[227]),
        .I1(abs_diff1[24]),
        .I2(contexts_reg_0_7_157_157_i_6_n_3),
        .I3(context_word1),
        .O(history_reg_0_31_70_70_i_6_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "71" *) 
  (* ram_slice_end = "71" *) 
  RAM32X1S history_reg_0_31_71_71
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_wl[25]),
        .O(next_mav4[71]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "72" *) 
  (* ram_slice_end = "72" *) 
  RAM32X1S history_reg_0_31_72_72
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_wl[26]),
        .O(next_mav4[72]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "73" *) 
  (* ram_slice_end = "73" *) 
  RAM32X1S history_reg_0_31_73_73
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_wl[27]),
        .O(next_mav4[73]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "74" *) 
  (* ram_slice_end = "74" *) 
  RAM32X1S history_reg_0_31_74_74
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_wl[28]),
        .O(next_mav4[74]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 history_reg_0_31_74_74_i_1
       (.CI(history_reg_0_31_70_70_i_1_n_0),
        .CO({NLW_history_reg_0_31_74_74_i_1_CO_UNCONNECTED[3],history_reg_0_31_74_74_i_1_n_1,history_reg_0_31_74_74_i_1_n_2,history_reg_0_31_74_74_i_1_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(completed_wl[31:28]),
        .S({history_reg_0_31_74_74_i_2_n_0,history_reg_0_31_74_74_i_3_n_0,history_reg_0_31_74_74_i_4_n_0,history_reg_0_31_74_74_i_5_n_0}));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_74_74_i_2
       (.I0(context_word1),
        .I1(context_word0[234]),
        .O(history_reg_0_31_74_74_i_2_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_74_74_i_3
       (.I0(context_word1),
        .I1(context_word0[233]),
        .O(history_reg_0_31_74_74_i_3_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_74_74_i_4
       (.I0(context_word1),
        .I1(context_word0[232]),
        .O(history_reg_0_31_74_74_i_4_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_74_74_i_5
       (.I0(context_word1),
        .I1(context_word0[231]),
        .O(history_reg_0_31_74_74_i_5_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "75" *) 
  (* ram_slice_end = "75" *) 
  RAM32X1S history_reg_0_31_75_75
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_wl[29]),
        .O(next_mav4[75]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "76" *) 
  (* ram_slice_end = "76" *) 
  RAM32X1S history_reg_0_31_76_76
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_wl[30]),
        .O(next_mav4[76]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "77" *) 
  (* ram_slice_end = "77" *) 
  RAM32X1S history_reg_0_31_77_77
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_wl[31]),
        .O(next_mav4[77]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "78" *) 
  (* ram_slice_end = "78" *) 
  RAM32X1S history_reg_0_31_78_78
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_mav[0]),
        .O(next_mav4[78]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 history_reg_0_31_78_78_i_1
       (.CI(1'b0),
        .CO({history_reg_0_31_78_78_i_1_n_0,history_reg_0_31_78_78_i_1_n_1,history_reg_0_31_78_78_i_1_n_2,history_reg_0_31_78_78_i_1_n_3}),
        .CYINIT(1'b0),
        .DI({history_reg_0_31_78_78_i_2_n_0,history_reg_0_31_78_78_i_3_n_0,history_reg_0_31_78_78_i_4_n_0,history_reg_0_31_78_78_i_5_n_0}),
        .O(completed_mav[3:0]),
        .S({history_reg_0_31_78_78_i_6_n_0,history_reg_0_31_78_78_i_7_n_0,history_reg_0_31_78_78_i_8_n_0,history_reg_0_31_78_78_i_9_n_0}));
  CARRY4 history_reg_0_31_78_78_i_10
       (.CI(1'b0),
        .CO({history_reg_0_31_78_78_i_10_n_0,history_reg_0_31_78_78_i_10_n_1,history_reg_0_31_78_78_i_10_n_2,history_reg_0_31_78_78_i_10_n_3}),
        .CYINIT(history_reg_0_31_78_78_i_11_n_0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(next_mav2[4:1]),
        .S({history_reg_0_31_78_78_i_12_n_0,history_reg_0_31_78_78_i_13_n_0,history_reg_0_31_78_78_i_14_n_0,history_reg_0_31_78_78_i_15_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_78_78_i_11
       (.I0(sample_data[0]),
        .O(history_reg_0_31_78_78_i_11_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_78_78_i_12
       (.I0(sample_data[4]),
        .O(history_reg_0_31_78_78_i_12_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_78_78_i_13
       (.I0(sample_data[3]),
        .O(history_reg_0_31_78_78_i_13_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_78_78_i_14
       (.I0(sample_data[2]),
        .O(history_reg_0_31_78_78_i_14_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_78_78_i_15
       (.I0(sample_data[1]),
        .O(history_reg_0_31_78_78_i_15_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_78_78_i_2
       (.I0(context_word0[238]),
        .I1(context_word1),
        .O(history_reg_0_31_78_78_i_2_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_78_78_i_3
       (.I0(context_word1),
        .I1(context_word0[237]),
        .O(history_reg_0_31_78_78_i_3_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_78_78_i_4
       (.I0(context_word1),
        .I1(context_word0[236]),
        .O(history_reg_0_31_78_78_i_4_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_78_78_i_5
       (.I0(context_word0[235]),
        .I1(context_word1),
        .O(history_reg_0_31_78_78_i_5_n_0));
  LUT5 #(
    .INIT(32'h77788878)) 
    history_reg_0_31_78_78_i_6
       (.I0(context_word1),
        .I1(context_word0[238]),
        .I2(sample_data[3]),
        .I3(sample_data[23]),
        .I4(next_mav2[3]),
        .O(history_reg_0_31_78_78_i_6_n_0));
  LUT5 #(
    .INIT(32'h77788878)) 
    history_reg_0_31_78_78_i_7
       (.I0(context_word0[237]),
        .I1(context_word1),
        .I2(sample_data[2]),
        .I3(sample_data[23]),
        .I4(next_mav2[2]),
        .O(history_reg_0_31_78_78_i_7_n_0));
  LUT5 #(
    .INIT(32'h77788878)) 
    history_reg_0_31_78_78_i_8
       (.I0(context_word1),
        .I1(context_word0[236]),
        .I2(sample_data[1]),
        .I3(sample_data[23]),
        .I4(next_mav2[1]),
        .O(history_reg_0_31_78_78_i_8_n_0));
  LUT3 #(
    .INIT(8'h78)) 
    history_reg_0_31_78_78_i_9
       (.I0(context_word1),
        .I1(context_word0[235]),
        .I2(sample_data[0]),
        .O(history_reg_0_31_78_78_i_9_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "79" *) 
  (* ram_slice_end = "79" *) 
  RAM32X1S history_reg_0_31_79_79
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_mav[1]),
        .O(next_mav4[79]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "7" *) 
  (* ram_slice_end = "7" *) 
  RAM32X1S history_reg_0_31_7_7
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(history_reg_0_31_7_7_i_1_n_0),
        .O(next_mav4[7]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  LUT5 #(
    .INIT(32'h9F600000)) 
    history_reg_0_31_7_7_i_1
       (.I0(sample_data[23]),
        .I1(context_word0[323]),
        .I2(zc_event1),
        .I3(context_word0[164]),
        .I4(context_word1),
        .O(history_reg_0_31_7_7_i_1_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "80" *) 
  (* ram_slice_end = "80" *) 
  RAM32X1S history_reg_0_31_80_80
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_mav[2]),
        .O(next_mav4[80]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "81" *) 
  (* ram_slice_end = "81" *) 
  RAM32X1S history_reg_0_31_81_81
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_mav[3]),
        .O(next_mav4[81]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "82" *) 
  (* ram_slice_end = "82" *) 
  RAM32X1S history_reg_0_31_82_82
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_mav[4]),
        .O(next_mav4[82]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 history_reg_0_31_82_82_i_1
       (.CI(history_reg_0_31_78_78_i_1_n_0),
        .CO({history_reg_0_31_82_82_i_1_n_0,history_reg_0_31_82_82_i_1_n_1,history_reg_0_31_82_82_i_1_n_2,history_reg_0_31_82_82_i_1_n_3}),
        .CYINIT(1'b0),
        .DI({history_reg_0_31_82_82_i_2_n_0,history_reg_0_31_82_82_i_3_n_0,history_reg_0_31_82_82_i_4_n_0,history_reg_0_31_82_82_i_5_n_0}),
        .O(completed_mav[7:4]),
        .S({history_reg_0_31_82_82_i_6_n_0,history_reg_0_31_82_82_i_7_n_0,history_reg_0_31_82_82_i_8_n_0,history_reg_0_31_82_82_i_9_n_0}));
  CARRY4 history_reg_0_31_82_82_i_10
       (.CI(history_reg_0_31_78_78_i_10_n_0),
        .CO({history_reg_0_31_82_82_i_10_n_0,history_reg_0_31_82_82_i_10_n_1,history_reg_0_31_82_82_i_10_n_2,history_reg_0_31_82_82_i_10_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(next_mav2[8:5]),
        .S({history_reg_0_31_82_82_i_11_n_0,history_reg_0_31_82_82_i_12_n_0,history_reg_0_31_82_82_i_13_n_0,history_reg_0_31_82_82_i_14_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_82_82_i_11
       (.I0(sample_data[8]),
        .O(history_reg_0_31_82_82_i_11_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_82_82_i_12
       (.I0(sample_data[7]),
        .O(history_reg_0_31_82_82_i_12_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_82_82_i_13
       (.I0(sample_data[6]),
        .O(history_reg_0_31_82_82_i_13_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_82_82_i_14
       (.I0(sample_data[5]),
        .O(history_reg_0_31_82_82_i_14_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_82_82_i_2
       (.I0(context_word0[242]),
        .I1(context_word1),
        .O(history_reg_0_31_82_82_i_2_n_0));
  LUT3 #(
    .INIT(8'hB8)) 
    history_reg_0_31_82_82_i_3
       (.I0(next_mav2[6]),
        .I1(sample_data[23]),
        .I2(sample_data[6]),
        .O(history_reg_0_31_82_82_i_3_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_82_82_i_4
       (.I0(context_word0[240]),
        .I1(context_word1),
        .O(history_reg_0_31_82_82_i_4_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_82_82_i_5
       (.I0(context_word0[239]),
        .I1(context_word1),
        .O(history_reg_0_31_82_82_i_5_n_0));
  LUT5 #(
    .INIT(32'h77788878)) 
    history_reg_0_31_82_82_i_6
       (.I0(context_word1),
        .I1(context_word0[242]),
        .I2(sample_data[7]),
        .I3(sample_data[23]),
        .I4(next_mav2[7]),
        .O(history_reg_0_31_82_82_i_6_n_0));
  LUT5 #(
    .INIT(32'h77788878)) 
    history_reg_0_31_82_82_i_7
       (.I0(context_word1),
        .I1(context_word0[241]),
        .I2(sample_data[6]),
        .I3(sample_data[23]),
        .I4(next_mav2[6]),
        .O(history_reg_0_31_82_82_i_7_n_0));
  LUT5 #(
    .INIT(32'h77788878)) 
    history_reg_0_31_82_82_i_8
       (.I0(context_word1),
        .I1(context_word0[240]),
        .I2(sample_data[5]),
        .I3(sample_data[23]),
        .I4(next_mav2[5]),
        .O(history_reg_0_31_82_82_i_8_n_0));
  LUT5 #(
    .INIT(32'h77788878)) 
    history_reg_0_31_82_82_i_9
       (.I0(context_word1),
        .I1(context_word0[239]),
        .I2(sample_data[4]),
        .I3(sample_data[23]),
        .I4(next_mav2[4]),
        .O(history_reg_0_31_82_82_i_9_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "83" *) 
  (* ram_slice_end = "83" *) 
  RAM32X1S history_reg_0_31_83_83
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_mav[5]),
        .O(next_mav4[83]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "84" *) 
  (* ram_slice_end = "84" *) 
  RAM32X1S history_reg_0_31_84_84
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_mav[6]),
        .O(next_mav4[84]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "85" *) 
  (* ram_slice_end = "85" *) 
  RAM32X1S history_reg_0_31_85_85
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_mav[7]),
        .O(next_mav4[85]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "86" *) 
  (* ram_slice_end = "86" *) 
  RAM32X1S history_reg_0_31_86_86
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_mav[8]),
        .O(next_mav4[86]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 history_reg_0_31_86_86_i_1
       (.CI(history_reg_0_31_82_82_i_1_n_0),
        .CO({history_reg_0_31_86_86_i_1_n_0,history_reg_0_31_86_86_i_1_n_1,history_reg_0_31_86_86_i_1_n_2,history_reg_0_31_86_86_i_1_n_3}),
        .CYINIT(1'b0),
        .DI({history_reg_0_31_86_86_i_2_n_0,history_reg_0_31_86_86_i_3_n_0,history_reg_0_31_86_86_i_4_n_0,history_reg_0_31_86_86_i_5_n_0}),
        .O(completed_mav[11:8]),
        .S({history_reg_0_31_86_86_i_6_n_0,history_reg_0_31_86_86_i_7_n_0,history_reg_0_31_86_86_i_8_n_0,history_reg_0_31_86_86_i_9_n_0}));
  CARRY4 history_reg_0_31_86_86_i_10
       (.CI(history_reg_0_31_82_82_i_10_n_0),
        .CO({history_reg_0_31_86_86_i_10_n_0,history_reg_0_31_86_86_i_10_n_1,history_reg_0_31_86_86_i_10_n_2,history_reg_0_31_86_86_i_10_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(next_mav2[12:9]),
        .S({history_reg_0_31_86_86_i_11_n_0,history_reg_0_31_86_86_i_12_n_0,history_reg_0_31_86_86_i_13_n_0,history_reg_0_31_86_86_i_14_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_86_86_i_11
       (.I0(sample_data[12]),
        .O(history_reg_0_31_86_86_i_11_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_86_86_i_12
       (.I0(sample_data[11]),
        .O(history_reg_0_31_86_86_i_12_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_86_86_i_13
       (.I0(sample_data[10]),
        .O(history_reg_0_31_86_86_i_13_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_86_86_i_14
       (.I0(sample_data[9]),
        .O(history_reg_0_31_86_86_i_14_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_86_86_i_2
       (.I0(context_word1),
        .I1(context_word0[246]),
        .O(history_reg_0_31_86_86_i_2_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_86_86_i_3
       (.I0(context_word1),
        .I1(context_word0[245]),
        .O(history_reg_0_31_86_86_i_3_n_0));
  LUT3 #(
    .INIT(8'hB8)) 
    history_reg_0_31_86_86_i_4
       (.I0(next_mav2[9]),
        .I1(sample_data[23]),
        .I2(sample_data[9]),
        .O(history_reg_0_31_86_86_i_4_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_86_86_i_5
       (.I0(context_word1),
        .I1(context_word0[243]),
        .O(history_reg_0_31_86_86_i_5_n_0));
  LUT5 #(
    .INIT(32'h77788878)) 
    history_reg_0_31_86_86_i_6
       (.I0(context_word1),
        .I1(context_word0[246]),
        .I2(sample_data[11]),
        .I3(sample_data[23]),
        .I4(next_mav2[11]),
        .O(history_reg_0_31_86_86_i_6_n_0));
  LUT5 #(
    .INIT(32'h77788878)) 
    history_reg_0_31_86_86_i_7
       (.I0(context_word1),
        .I1(context_word0[245]),
        .I2(sample_data[10]),
        .I3(sample_data[23]),
        .I4(next_mav2[10]),
        .O(history_reg_0_31_86_86_i_7_n_0));
  LUT5 #(
    .INIT(32'h77788878)) 
    history_reg_0_31_86_86_i_8
       (.I0(context_word1),
        .I1(context_word0[244]),
        .I2(sample_data[9]),
        .I3(sample_data[23]),
        .I4(next_mav2[9]),
        .O(history_reg_0_31_86_86_i_8_n_0));
  LUT5 #(
    .INIT(32'h77788878)) 
    history_reg_0_31_86_86_i_9
       (.I0(context_word1),
        .I1(context_word0[243]),
        .I2(sample_data[8]),
        .I3(sample_data[23]),
        .I4(next_mav2[8]),
        .O(history_reg_0_31_86_86_i_9_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "87" *) 
  (* ram_slice_end = "87" *) 
  RAM32X1S history_reg_0_31_87_87
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_mav[9]),
        .O(next_mav4[87]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "88" *) 
  (* ram_slice_end = "88" *) 
  RAM32X1S history_reg_0_31_88_88
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_mav[10]),
        .O(next_mav4[88]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "89" *) 
  (* ram_slice_end = "89" *) 
  RAM32X1S history_reg_0_31_89_89
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_mav[11]),
        .O(next_mav4[89]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "8" *) 
  (* ram_slice_end = "8" *) 
  RAM32X1S history_reg_0_31_8_8
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_zc[1]),
        .O(next_mav4[8]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  LUT6 #(
    .INIT(64'hA0A060A060A0A0A0)) 
    history_reg_0_31_8_8_i_1
       (.I0(context_word0[165]),
        .I1(context_word0[164]),
        .I2(context_word1),
        .I3(zc_event1),
        .I4(context_word0[323]),
        .I5(sample_data[23]),
        .O(completed_zc[1]));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "90" *) 
  (* ram_slice_end = "90" *) 
  RAM32X1S history_reg_0_31_90_90
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_mav[12]),
        .O(next_mav4[90]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 history_reg_0_31_90_90_i_1
       (.CI(history_reg_0_31_86_86_i_1_n_0),
        .CO({history_reg_0_31_90_90_i_1_n_0,history_reg_0_31_90_90_i_1_n_1,history_reg_0_31_90_90_i_1_n_2,history_reg_0_31_90_90_i_1_n_3}),
        .CYINIT(1'b0),
        .DI({history_reg_0_31_90_90_i_2_n_0,history_reg_0_31_90_90_i_3_n_0,history_reg_0_31_90_90_i_4_n_0,history_reg_0_31_90_90_i_5_n_0}),
        .O(completed_mav[15:12]),
        .S({history_reg_0_31_90_90_i_6_n_0,history_reg_0_31_90_90_i_7_n_0,history_reg_0_31_90_90_i_8_n_0,history_reg_0_31_90_90_i_9_n_0}));
  CARRY4 history_reg_0_31_90_90_i_10
       (.CI(history_reg_0_31_86_86_i_10_n_0),
        .CO({history_reg_0_31_90_90_i_10_n_0,history_reg_0_31_90_90_i_10_n_1,history_reg_0_31_90_90_i_10_n_2,history_reg_0_31_90_90_i_10_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(next_mav2[16:13]),
        .S({history_reg_0_31_90_90_i_11_n_0,history_reg_0_31_90_90_i_12_n_0,history_reg_0_31_90_90_i_13_n_0,history_reg_0_31_90_90_i_14_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_90_90_i_11
       (.I0(sample_data[16]),
        .O(history_reg_0_31_90_90_i_11_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_90_90_i_12
       (.I0(sample_data[15]),
        .O(history_reg_0_31_90_90_i_12_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_90_90_i_13
       (.I0(sample_data[14]),
        .O(history_reg_0_31_90_90_i_13_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_90_90_i_14
       (.I0(sample_data[13]),
        .O(history_reg_0_31_90_90_i_14_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_90_90_i_2
       (.I0(context_word0[250]),
        .I1(context_word1),
        .O(history_reg_0_31_90_90_i_2_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_90_90_i_3
       (.I0(context_word0[249]),
        .I1(context_word1),
        .O(history_reg_0_31_90_90_i_3_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_90_90_i_4
       (.I0(context_word1),
        .I1(context_word0[248]),
        .O(history_reg_0_31_90_90_i_4_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_90_90_i_5
       (.I0(context_word1),
        .I1(context_word0[247]),
        .O(history_reg_0_31_90_90_i_5_n_0));
  LUT5 #(
    .INIT(32'h77788878)) 
    history_reg_0_31_90_90_i_6
       (.I0(context_word1),
        .I1(context_word0[250]),
        .I2(sample_data[15]),
        .I3(sample_data[23]),
        .I4(next_mav2[15]),
        .O(history_reg_0_31_90_90_i_6_n_0));
  LUT5 #(
    .INIT(32'h77788878)) 
    history_reg_0_31_90_90_i_7
       (.I0(context_word1),
        .I1(context_word0[249]),
        .I2(sample_data[14]),
        .I3(sample_data[23]),
        .I4(next_mav2[14]),
        .O(history_reg_0_31_90_90_i_7_n_0));
  LUT5 #(
    .INIT(32'h77788878)) 
    history_reg_0_31_90_90_i_8
       (.I0(context_word1),
        .I1(context_word0[248]),
        .I2(sample_data[13]),
        .I3(sample_data[23]),
        .I4(next_mav2[13]),
        .O(history_reg_0_31_90_90_i_8_n_0));
  LUT5 #(
    .INIT(32'h77788878)) 
    history_reg_0_31_90_90_i_9
       (.I0(context_word1),
        .I1(context_word0[247]),
        .I2(sample_data[12]),
        .I3(sample_data[23]),
        .I4(next_mav2[12]),
        .O(history_reg_0_31_90_90_i_9_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "91" *) 
  (* ram_slice_end = "91" *) 
  RAM32X1S history_reg_0_31_91_91
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_mav[13]),
        .O(next_mav4[91]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "92" *) 
  (* ram_slice_end = "92" *) 
  RAM32X1S history_reg_0_31_92_92
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_mav[14]),
        .O(next_mav4[92]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "93" *) 
  (* ram_slice_end = "93" *) 
  RAM32X1S history_reg_0_31_93_93
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_mav[15]),
        .O(next_mav4[93]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "94" *) 
  (* ram_slice_end = "94" *) 
  RAM32X1S history_reg_0_31_94_94
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_mav[16]),
        .O(next_mav4[94]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 history_reg_0_31_94_94_i_1
       (.CI(history_reg_0_31_90_90_i_1_n_0),
        .CO({history_reg_0_31_94_94_i_1_n_0,history_reg_0_31_94_94_i_1_n_1,history_reg_0_31_94_94_i_1_n_2,history_reg_0_31_94_94_i_1_n_3}),
        .CYINIT(1'b0),
        .DI({history_reg_0_31_94_94_i_2_n_0,history_reg_0_31_94_94_i_3_n_0,history_reg_0_31_94_94_i_4_n_0,history_reg_0_31_94_94_i_5_n_0}),
        .O(completed_mav[19:16]),
        .S({history_reg_0_31_94_94_i_6_n_0,history_reg_0_31_94_94_i_7_n_0,history_reg_0_31_94_94_i_8_n_0,history_reg_0_31_94_94_i_9_n_0}));
  CARRY4 history_reg_0_31_94_94_i_10
       (.CI(history_reg_0_31_90_90_i_10_n_0),
        .CO({history_reg_0_31_94_94_i_10_n_0,history_reg_0_31_94_94_i_10_n_1,history_reg_0_31_94_94_i_10_n_2,history_reg_0_31_94_94_i_10_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(next_mav2[20:17]),
        .S({history_reg_0_31_94_94_i_11_n_0,history_reg_0_31_94_94_i_12_n_0,history_reg_0_31_94_94_i_13_n_0,history_reg_0_31_94_94_i_14_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_94_94_i_11
       (.I0(sample_data[20]),
        .O(history_reg_0_31_94_94_i_11_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_94_94_i_12
       (.I0(sample_data[19]),
        .O(history_reg_0_31_94_94_i_12_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_94_94_i_13
       (.I0(sample_data[18]),
        .O(history_reg_0_31_94_94_i_13_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_94_94_i_14
       (.I0(sample_data[17]),
        .O(history_reg_0_31_94_94_i_14_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_94_94_i_2
       (.I0(context_word1),
        .I1(context_word0[254]),
        .O(history_reg_0_31_94_94_i_2_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_94_94_i_3
       (.I0(context_word1),
        .I1(context_word0[253]),
        .O(history_reg_0_31_94_94_i_3_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_94_94_i_4
       (.I0(context_word0[252]),
        .I1(context_word1),
        .O(history_reg_0_31_94_94_i_4_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_94_94_i_5
       (.I0(context_word0[251]),
        .I1(context_word1),
        .O(history_reg_0_31_94_94_i_5_n_0));
  LUT5 #(
    .INIT(32'h77788878)) 
    history_reg_0_31_94_94_i_6
       (.I0(context_word0[254]),
        .I1(context_word1),
        .I2(sample_data[19]),
        .I3(sample_data[23]),
        .I4(next_mav2[19]),
        .O(history_reg_0_31_94_94_i_6_n_0));
  LUT5 #(
    .INIT(32'h77788878)) 
    history_reg_0_31_94_94_i_7
       (.I0(context_word1),
        .I1(context_word0[253]),
        .I2(sample_data[18]),
        .I3(sample_data[23]),
        .I4(next_mav2[18]),
        .O(history_reg_0_31_94_94_i_7_n_0));
  LUT5 #(
    .INIT(32'h77788878)) 
    history_reg_0_31_94_94_i_8
       (.I0(context_word1),
        .I1(context_word0[252]),
        .I2(sample_data[17]),
        .I3(sample_data[23]),
        .I4(next_mav2[17]),
        .O(history_reg_0_31_94_94_i_8_n_0));
  LUT5 #(
    .INIT(32'h77788878)) 
    history_reg_0_31_94_94_i_9
       (.I0(context_word1),
        .I1(context_word0[251]),
        .I2(sample_data[16]),
        .I3(sample_data[23]),
        .I4(next_mav2[16]),
        .O(history_reg_0_31_94_94_i_9_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "95" *) 
  (* ram_slice_end = "95" *) 
  RAM32X1S history_reg_0_31_95_95
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_mav[17]),
        .O(next_mav4[95]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "96" *) 
  (* ram_slice_end = "96" *) 
  RAM32X1S history_reg_0_31_96_96
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_mav[18]),
        .O(next_mav4[96]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "97" *) 
  (* ram_slice_end = "97" *) 
  RAM32X1S history_reg_0_31_97_97
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_mav[19]),
        .O(next_mav4[97]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "98" *) 
  (* ram_slice_end = "98" *) 
  RAM32X1S history_reg_0_31_98_98
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_mav[20]),
        .O(next_mav4[98]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 history_reg_0_31_98_98_i_1
       (.CI(history_reg_0_31_94_94_i_1_n_0),
        .CO({history_reg_0_31_98_98_i_1_n_0,history_reg_0_31_98_98_i_1_n_1,history_reg_0_31_98_98_i_1_n_2,history_reg_0_31_98_98_i_1_n_3}),
        .CYINIT(1'b0),
        .DI({history_reg_0_31_98_98_i_2_n_0,history_reg_0_31_98_98_i_3_n_0,history_reg_0_31_98_98_i_4_n_0,history_reg_0_31_98_98_i_5_n_0}),
        .O(completed_mav[23:20]),
        .S({history_reg_0_31_98_98_i_6_n_0,history_reg_0_31_98_98_i_7_n_0,history_reg_0_31_98_98_i_8_n_0,history_reg_0_31_98_98_i_9_n_0}));
  CARRY4 history_reg_0_31_98_98_i_10
       (.CI(history_reg_0_31_94_94_i_10_n_0),
        .CO({history_reg_0_31_98_98_i_10_n_0,NLW_history_reg_0_31_98_98_i_10_CO_UNCONNECTED[2],history_reg_0_31_98_98_i_10_n_2,history_reg_0_31_98_98_i_10_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b1,1'b0,1'b0}),
        .O({NLW_history_reg_0_31_98_98_i_10_O_UNCONNECTED[3],next_mav2[23:21]}),
        .S({1'b1,history_reg_0_31_98_98_i_11_n_0,history_reg_0_31_98_98_i_12_n_0,history_reg_0_31_98_98_i_13_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_98_98_i_11
       (.I0(sample_data[23]),
        .O(history_reg_0_31_98_98_i_11_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_98_98_i_12
       (.I0(sample_data[22]),
        .O(history_reg_0_31_98_98_i_12_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    history_reg_0_31_98_98_i_13
       (.I0(sample_data[21]),
        .O(history_reg_0_31_98_98_i_13_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_98_98_i_2
       (.I0(context_word1),
        .I1(context_word0[258]),
        .O(history_reg_0_31_98_98_i_2_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_98_98_i_3
       (.I0(context_word1),
        .I1(context_word0[257]),
        .O(history_reg_0_31_98_98_i_3_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_98_98_i_4
       (.I0(context_word0[256]),
        .I1(context_word1),
        .O(history_reg_0_31_98_98_i_4_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    history_reg_0_31_98_98_i_5
       (.I0(context_word0[255]),
        .I1(context_word1),
        .O(history_reg_0_31_98_98_i_5_n_0));
  LUT4 #(
    .INIT(16'h7888)) 
    history_reg_0_31_98_98_i_6
       (.I0(context_word1),
        .I1(context_word0[258]),
        .I2(next_mav2[23]),
        .I3(sample_data[23]),
        .O(history_reg_0_31_98_98_i_6_n_0));
  LUT5 #(
    .INIT(32'h77788878)) 
    history_reg_0_31_98_98_i_7
       (.I0(context_word0[257]),
        .I1(context_word1),
        .I2(sample_data[22]),
        .I3(sample_data[23]),
        .I4(next_mav2[22]),
        .O(history_reg_0_31_98_98_i_7_n_0));
  LUT5 #(
    .INIT(32'h77788878)) 
    history_reg_0_31_98_98_i_8
       (.I0(context_word1),
        .I1(context_word0[256]),
        .I2(sample_data[21]),
        .I3(sample_data[23]),
        .I4(next_mav2[21]),
        .O(history_reg_0_31_98_98_i_8_n_0));
  LUT5 #(
    .INIT(32'h77788878)) 
    history_reg_0_31_98_98_i_9
       (.I0(context_word1),
        .I1(context_word0[255]),
        .I2(sample_data[20]),
        .I3(sample_data[23]),
        .I4(next_mav2[20]),
        .O(history_reg_0_31_98_98_i_9_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "99" *) 
  (* ram_slice_end = "99" *) 
  RAM32X1S history_reg_0_31_99_99
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_mav[21]),
        .O(next_mav4[99]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  (* RTL_RAM_BITS = "3520" *) 
  (* RTL_RAM_NAME = "emg_window_features_shared/history_reg" *) 
  (* RTL_RAM_STYLE = "distributed" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "31" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "9" *) 
  (* ram_slice_end = "9" *) 
  RAM32X1S history_reg_0_31_9_9
       (.A0(p_0_in0_in[0]),
        .A1(p_0_in0_in[1]),
        .A2(sample_channel[0]),
        .A3(sample_channel[1]),
        .A4(sample_channel[2]),
        .D(completed_zc[2]),
        .O(next_mav4[9]),
        .WCLK(clk),
        .WE(history_reg_0_31_0_0_i_2_n_0));
  LUT5 #(
    .INIT(32'hAA2A0080)) 
    history_reg_0_31_9_9_i_1
       (.I0(context_word1),
        .I1(context_word0[165]),
        .I2(context_word0[164]),
        .I3(contexts_reg_0_7_165_165_i_2_n_0),
        .I4(context_word0[166]),
        .O(completed_zc[2]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'hFFFF0004)) 
    \hold_seen[0]_i_1 
       (.I0(window_channel[1]),
        .I1(shared_valid),
        .I2(window_channel[2]),
        .I3(window_channel[0]),
        .I4(hold_seen[0]),
        .O(\window_channel_reg[1]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'hFFFF0400)) 
    \hold_seen[1]_i_1 
       (.I0(window_channel[1]),
        .I1(shared_valid),
        .I2(window_channel[2]),
        .I3(window_channel[0]),
        .I4(hold_seen[1]),
        .O(\window_channel_reg[1]_1 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'hFFFF0020)) 
    \hold_seen[2]_i_1 
       (.I0(shared_valid),
        .I1(window_channel[2]),
        .I2(window_channel[1]),
        .I3(window_channel[0]),
        .I4(hold_seen[2]),
        .O(window_valid_reg_0));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT5 #(
    .INIT(32'hFFFF2000)) 
    \hold_seen[3]_i_1 
       (.I0(shared_valid),
        .I1(window_channel[2]),
        .I2(window_channel[1]),
        .I3(window_channel[0]),
        .I4(hold_seen[3]),
        .O(window_valid_reg_1));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT5 #(
    .INIT(32'hFFFF0040)) 
    \hold_seen[4]_i_1 
       (.I0(window_channel[1]),
        .I1(window_channel[2]),
        .I2(shared_valid),
        .I3(window_channel[0]),
        .I4(hold_seen[4]),
        .O(\window_channel_reg[1]_2 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT5 #(
    .INIT(32'hFFFF4000)) 
    \hold_seen[5]_i_1 
       (.I0(window_channel[1]),
        .I1(window_channel[2]),
        .I2(shared_valid),
        .I3(window_channel[0]),
        .I4(hold_seen[5]),
        .O(\window_channel_reg[1]_3 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT5 #(
    .INIT(32'hFFFF0080)) 
    \hold_seen[6]_i_1 
       (.I0(window_channel[2]),
        .I1(shared_valid),
        .I2(window_channel[1]),
        .I3(window_channel[0]),
        .I4(hold_seen[6]),
        .O(\window_channel_reg[2]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT5 #(
    .INIT(32'hFFFF8000)) 
    \hold_seen[7]_i_1 
       (.I0(window_channel[2]),
        .I1(shared_valid),
        .I2(window_channel[1]),
        .I3(window_channel[0]),
        .I4(hold_seen[7]),
        .O(\window_channel_reg[2]_1 ));
  (* SOFT_HLUTNM = "soft_lutpair152" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \mav_sum[0]_i_1 
       (.I0(clamp321),
        .I1(next_mav0[0]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(clamp3210_in),
        .O(result_mav_sum[0]));
  (* SOFT_HLUTNM = "soft_lutpair147" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \mav_sum[10]_i_1 
       (.I0(clamp321),
        .I1(next_mav0[10]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(clamp3210_in),
        .O(result_mav_sum[10]));
  (* SOFT_HLUTNM = "soft_lutpair146" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \mav_sum[11]_i_1 
       (.I0(clamp321),
        .I1(next_mav0[11]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(clamp3210_in),
        .O(result_mav_sum[11]));
  (* SOFT_HLUTNM = "soft_lutpair146" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \mav_sum[12]_i_1 
       (.I0(clamp321),
        .I1(next_mav0[12]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(clamp3210_in),
        .O(result_mav_sum[12]));
  (* SOFT_HLUTNM = "soft_lutpair145" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \mav_sum[13]_i_1 
       (.I0(clamp321),
        .I1(next_mav0[13]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(clamp3210_in),
        .O(result_mav_sum[13]));
  (* SOFT_HLUTNM = "soft_lutpair145" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \mav_sum[14]_i_1 
       (.I0(clamp321),
        .I1(next_mav0[14]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(clamp3210_in),
        .O(result_mav_sum[14]));
  (* SOFT_HLUTNM = "soft_lutpair144" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \mav_sum[15]_i_1 
       (.I0(clamp321),
        .I1(next_mav0[15]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(clamp3210_in),
        .O(result_mav_sum[15]));
  (* SOFT_HLUTNM = "soft_lutpair144" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \mav_sum[16]_i_1 
       (.I0(clamp321),
        .I1(next_mav0[16]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(clamp3210_in),
        .O(result_mav_sum[16]));
  (* SOFT_HLUTNM = "soft_lutpair143" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \mav_sum[17]_i_1 
       (.I0(clamp321),
        .I1(next_mav0[17]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(clamp3210_in),
        .O(result_mav_sum[17]));
  (* SOFT_HLUTNM = "soft_lutpair143" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \mav_sum[18]_i_1 
       (.I0(clamp321),
        .I1(next_mav0[18]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(clamp3210_in),
        .O(result_mav_sum[18]));
  (* SOFT_HLUTNM = "soft_lutpair142" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \mav_sum[19]_i_1 
       (.I0(clamp321),
        .I1(next_mav0[19]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(clamp3210_in),
        .O(result_mav_sum[19]));
  (* SOFT_HLUTNM = "soft_lutpair151" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \mav_sum[1]_i_1 
       (.I0(clamp321),
        .I1(next_mav0[1]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(clamp3210_in),
        .O(result_mav_sum[1]));
  (* SOFT_HLUTNM = "soft_lutpair142" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \mav_sum[20]_i_1 
       (.I0(clamp321),
        .I1(next_mav0[20]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(clamp3210_in),
        .O(result_mav_sum[20]));
  (* SOFT_HLUTNM = "soft_lutpair141" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \mav_sum[21]_i_1 
       (.I0(clamp321),
        .I1(next_mav0[21]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(clamp3210_in),
        .O(result_mav_sum[21]));
  (* SOFT_HLUTNM = "soft_lutpair141" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \mav_sum[22]_i_1 
       (.I0(clamp321),
        .I1(next_mav0[22]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(clamp3210_in),
        .O(result_mav_sum[22]));
  (* SOFT_HLUTNM = "soft_lutpair140" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \mav_sum[23]_i_1 
       (.I0(clamp321),
        .I1(next_mav0[23]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(clamp3210_in),
        .O(result_mav_sum[23]));
  (* SOFT_HLUTNM = "soft_lutpair140" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \mav_sum[24]_i_1 
       (.I0(clamp321),
        .I1(next_mav0[24]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(clamp3210_in),
        .O(result_mav_sum[24]));
  (* SOFT_HLUTNM = "soft_lutpair139" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \mav_sum[25]_i_1 
       (.I0(clamp321),
        .I1(next_mav0[25]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(clamp3210_in),
        .O(result_mav_sum[25]));
  (* SOFT_HLUTNM = "soft_lutpair139" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \mav_sum[26]_i_1 
       (.I0(clamp321),
        .I1(next_mav0[26]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(clamp3210_in),
        .O(result_mav_sum[26]));
  (* SOFT_HLUTNM = "soft_lutpair138" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \mav_sum[27]_i_1 
       (.I0(clamp321),
        .I1(next_mav0[27]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(clamp3210_in),
        .O(result_mav_sum[27]));
  (* SOFT_HLUTNM = "soft_lutpair138" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \mav_sum[28]_i_1 
       (.I0(clamp321),
        .I1(next_mav0[28]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(clamp3210_in),
        .O(result_mav_sum[28]));
  (* SOFT_HLUTNM = "soft_lutpair137" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \mav_sum[29]_i_1 
       (.I0(clamp321),
        .I1(next_mav0[29]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(clamp3210_in),
        .O(result_mav_sum[29]));
  (* SOFT_HLUTNM = "soft_lutpair151" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \mav_sum[2]_i_1 
       (.I0(clamp321),
        .I1(next_mav0[2]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(clamp3210_in),
        .O(result_mav_sum[2]));
  (* SOFT_HLUTNM = "soft_lutpair137" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \mav_sum[30]_i_1 
       (.I0(clamp321),
        .I1(next_mav0[30]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(clamp3210_in),
        .O(result_mav_sum[30]));
  LUT3 #(
    .INIT(8'hCD)) 
    \mav_sum[30]_i_10 
       (.I0(next_mav0[39]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_mav0[38]),
        .O(\mav_sum[30]_i_10_n_0 ));
  LUT3 #(
    .INIT(8'hDF)) 
    \mav_sum[30]_i_11 
       (.I0(next_mav0[36]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_mav0[37]),
        .O(\mav_sum[30]_i_11_n_0 ));
  LUT3 #(
    .INIT(8'hDF)) 
    \mav_sum[30]_i_12 
       (.I0(next_mav0[34]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_mav0[35]),
        .O(\mav_sum[30]_i_12_n_0 ));
  LUT3 #(
    .INIT(8'hDF)) 
    \mav_sum[30]_i_13 
       (.I0(next_mav0[32]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_mav0[33]),
        .O(\mav_sum[30]_i_13_n_0 ));
  LUT2 #(
    .INIT(4'hB)) 
    \mav_sum[30]_i_14 
       (.I0(\mav_sum[30]_i_3_n_0 ),
        .I1(next_mav0[31]),
        .O(\mav_sum[30]_i_14_n_0 ));
  LUT3 #(
    .INIT(8'h20)) 
    \mav_sum[30]_i_15 
       (.I0(next_mav0[37]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_mav0[36]),
        .O(\mav_sum[30]_i_15_n_0 ));
  LUT3 #(
    .INIT(8'h20)) 
    \mav_sum[30]_i_16 
       (.I0(next_mav0[35]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_mav0[34]),
        .O(\mav_sum[30]_i_16_n_0 ));
  LUT3 #(
    .INIT(8'h20)) 
    \mav_sum[30]_i_17 
       (.I0(next_mav0[33]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_mav0[32]),
        .O(\mav_sum[30]_i_17_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \mav_sum[30]_i_18 
       (.I0(next_mav0[30]),
        .I1(next_mav0[31]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .O(\mav_sum[30]_i_18_n_0 ));
  LUT3 #(
    .INIT(8'h32)) 
    \mav_sum[30]_i_19 
       (.I0(next_mav0[36]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_mav0[37]),
        .O(\mav_sum[30]_i_19_n_0 ));
  LUT3 #(
    .INIT(8'h32)) 
    \mav_sum[30]_i_20 
       (.I0(next_mav0[34]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_mav0[35]),
        .O(\mav_sum[30]_i_20_n_0 ));
  LUT3 #(
    .INIT(8'h32)) 
    \mav_sum[30]_i_21 
       (.I0(next_mav0[32]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_mav0[33]),
        .O(\mav_sum[30]_i_21_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \mav_sum[30]_i_22 
       (.I0(next_mav0[31]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .O(\mav_sum[30]_i_22_n_0 ));
  LUT3 #(
    .INIT(8'hCD)) 
    \mav_sum[30]_i_23 
       (.I0(next_mav0[37]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_mav0[36]),
        .O(\mav_sum[30]_i_23_n_0 ));
  LUT3 #(
    .INIT(8'hCD)) 
    \mav_sum[30]_i_24 
       (.I0(next_mav0[35]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_mav0[34]),
        .O(\mav_sum[30]_i_24_n_0 ));
  LUT3 #(
    .INIT(8'hCD)) 
    \mav_sum[30]_i_25 
       (.I0(next_mav0[33]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_mav0[32]),
        .O(\mav_sum[30]_i_25_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \mav_sum[30]_i_26 
       (.I0(next_mav0[31]),
        .I1(next_mav0[30]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .O(\mav_sum[30]_i_26_n_0 ));
  LUT4 #(
    .INIT(16'hFF7F)) 
    \mav_sum[30]_i_3 
       (.I0(context_word0[268]),
        .I1(context_word0[267]),
        .I2(context_word1),
        .I3(contexts_reg_0_7_17_17_i_4_n_0),
        .O(\mav_sum[30]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \mav_sum[30]_i_6 
       (.I0(next_mav0[38]),
        .I1(next_mav0[39]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .O(\mav_sum[30]_i_6_n_0 ));
  LUT3 #(
    .INIT(8'h40)) 
    \mav_sum[30]_i_7 
       (.I0(\mav_sum[30]_i_3_n_0 ),
        .I1(next_mav0[38]),
        .I2(next_mav0[39]),
        .O(\mav_sum[30]_i_7_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \mav_sum[30]_i_9 
       (.I0(\mav_sum[30]_i_3_n_0 ),
        .I1(next_mav0[38]),
        .I2(next_mav0[39]),
        .O(\mav_sum[30]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'h0CCC5CCC00000000)) 
    \mav_sum[31]_i_1 
       (.I0(clamp3210_in),
        .I1(I11[17]),
        .I2(sample_valid),
        .I3(\window_channel[2]_i_2_n_0 ),
        .I4(\mav_sum[31]_i_2_n_0 ),
        .I5(rst_n),
        .O(\mav_sum[31]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair152" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \mav_sum[31]_i_2 
       (.I0(next_mav0[31]),
        .I1(clamp321),
        .O(\mav_sum[31]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair150" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \mav_sum[3]_i_1 
       (.I0(clamp321),
        .I1(next_mav0[3]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(clamp3210_in),
        .O(result_mav_sum[3]));
  (* SOFT_HLUTNM = "soft_lutpair150" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \mav_sum[4]_i_1 
       (.I0(clamp321),
        .I1(next_mav0[4]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(clamp3210_in),
        .O(result_mav_sum[4]));
  (* SOFT_HLUTNM = "soft_lutpair149" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \mav_sum[5]_i_1 
       (.I0(clamp321),
        .I1(next_mav0[5]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(clamp3210_in),
        .O(result_mav_sum[5]));
  (* SOFT_HLUTNM = "soft_lutpair149" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \mav_sum[6]_i_1 
       (.I0(clamp321),
        .I1(next_mav0[6]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(clamp3210_in),
        .O(result_mav_sum[6]));
  (* SOFT_HLUTNM = "soft_lutpair148" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \mav_sum[7]_i_1 
       (.I0(clamp321),
        .I1(next_mav0[7]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(clamp3210_in),
        .O(result_mav_sum[7]));
  (* SOFT_HLUTNM = "soft_lutpair148" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \mav_sum[8]_i_1 
       (.I0(clamp321),
        .I1(next_mav0[8]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(clamp3210_in),
        .O(result_mav_sum[8]));
  (* SOFT_HLUTNM = "soft_lutpair147" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \mav_sum[9]_i_1 
       (.I0(clamp321),
        .I1(next_mav0[9]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(clamp3210_in),
        .O(result_mav_sum[9]));
  FDRE \mav_sum_reg[0] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_mav_sum[0]),
        .Q(I11[80]),
        .R(rst_n_0));
  FDRE \mav_sum_reg[10] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_mav_sum[10]),
        .Q(I11[90]),
        .R(rst_n_0));
  FDRE \mav_sum_reg[11] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_mav_sum[11]),
        .Q(I11[91]),
        .R(rst_n_0));
  FDRE \mav_sum_reg[12] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_mav_sum[12]),
        .Q(I11[92]),
        .R(rst_n_0));
  FDRE \mav_sum_reg[13] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_mav_sum[13]),
        .Q(I11[93]),
        .R(rst_n_0));
  FDRE \mav_sum_reg[14] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_mav_sum[14]),
        .Q(I11[94]),
        .R(rst_n_0));
  FDRE \mav_sum_reg[15] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_mav_sum[15]),
        .Q(I11[95]),
        .R(rst_n_0));
  FDRE \mav_sum_reg[16] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_mav_sum[16]),
        .Q(I11[96]),
        .R(rst_n_0));
  FDRE \mav_sum_reg[17] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_mav_sum[17]),
        .Q(I11[97]),
        .R(rst_n_0));
  FDRE \mav_sum_reg[18] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_mav_sum[18]),
        .Q(I11[98]),
        .R(rst_n_0));
  FDRE \mav_sum_reg[19] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_mav_sum[19]),
        .Q(I11[99]),
        .R(rst_n_0));
  FDRE \mav_sum_reg[1] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_mav_sum[1]),
        .Q(I11[81]),
        .R(rst_n_0));
  FDRE \mav_sum_reg[20] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_mav_sum[20]),
        .Q(I11[100]),
        .R(rst_n_0));
  FDRE \mav_sum_reg[21] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_mav_sum[21]),
        .Q(I11[101]),
        .R(rst_n_0));
  FDRE \mav_sum_reg[22] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_mav_sum[22]),
        .Q(I11[102]),
        .R(rst_n_0));
  FDRE \mav_sum_reg[23] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_mav_sum[23]),
        .Q(I11[103]),
        .R(rst_n_0));
  FDRE \mav_sum_reg[24] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_mav_sum[24]),
        .Q(I11[104]),
        .R(rst_n_0));
  FDRE \mav_sum_reg[25] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_mav_sum[25]),
        .Q(I11[105]),
        .R(rst_n_0));
  FDRE \mav_sum_reg[26] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_mav_sum[26]),
        .Q(I11[106]),
        .R(rst_n_0));
  FDRE \mav_sum_reg[27] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_mav_sum[27]),
        .Q(I11[107]),
        .R(rst_n_0));
  FDRE \mav_sum_reg[28] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_mav_sum[28]),
        .Q(mav_sum[0]),
        .R(rst_n_0));
  FDRE \mav_sum_reg[29] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_mav_sum[29]),
        .Q(mav_sum[1]),
        .R(rst_n_0));
  FDRE \mav_sum_reg[2] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_mav_sum[2]),
        .Q(I11[82]),
        .R(rst_n_0));
  FDRE \mav_sum_reg[30] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_mav_sum[30]),
        .Q(I11[16]),
        .R(rst_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \mav_sum_reg[30]_i_2 
       (.CI(\mav_sum_reg[30]_i_5_n_0 ),
        .CO({\NLW_mav_sum_reg[30]_i_2_CO_UNCONNECTED [3:1],clamp321}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,\mav_sum[30]_i_6_n_0 }),
        .O(\NLW_mav_sum_reg[30]_i_2_O_UNCONNECTED [3:0]),
        .S({1'b0,1'b0,1'b0,\mav_sum[30]_i_7_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \mav_sum_reg[30]_i_4 
       (.CI(\mav_sum_reg[30]_i_8_n_0 ),
        .CO({\NLW_mav_sum_reg[30]_i_4_CO_UNCONNECTED [3:1],clamp3210_in}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,\mav_sum[30]_i_9_n_0 }),
        .O(\NLW_mav_sum_reg[30]_i_4_O_UNCONNECTED [3:0]),
        .S({1'b0,1'b0,1'b0,\mav_sum[30]_i_10_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \mav_sum_reg[30]_i_5 
       (.CI(1'b0),
        .CO({\mav_sum_reg[30]_i_5_n_0 ,\mav_sum_reg[30]_i_5_n_1 ,\mav_sum_reg[30]_i_5_n_2 ,\mav_sum_reg[30]_i_5_n_3 }),
        .CYINIT(1'b0),
        .DI({\mav_sum[30]_i_11_n_0 ,\mav_sum[30]_i_12_n_0 ,\mav_sum[30]_i_13_n_0 ,\mav_sum[30]_i_14_n_0 }),
        .O(\NLW_mav_sum_reg[30]_i_5_O_UNCONNECTED [3:0]),
        .S({\mav_sum[30]_i_15_n_0 ,\mav_sum[30]_i_16_n_0 ,\mav_sum[30]_i_17_n_0 ,\mav_sum[30]_i_18_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \mav_sum_reg[30]_i_8 
       (.CI(1'b0),
        .CO({\mav_sum_reg[30]_i_8_n_0 ,\mav_sum_reg[30]_i_8_n_1 ,\mav_sum_reg[30]_i_8_n_2 ,\mav_sum_reg[30]_i_8_n_3 }),
        .CYINIT(1'b0),
        .DI({\mav_sum[30]_i_19_n_0 ,\mav_sum[30]_i_20_n_0 ,\mav_sum[30]_i_21_n_0 ,\mav_sum[30]_i_22_n_0 }),
        .O(\NLW_mav_sum_reg[30]_i_8_O_UNCONNECTED [3:0]),
        .S({\mav_sum[30]_i_23_n_0 ,\mav_sum[30]_i_24_n_0 ,\mav_sum[30]_i_25_n_0 ,\mav_sum[30]_i_26_n_0 }));
  FDRE \mav_sum_reg[31] 
       (.C(clk),
        .CE(1'b1),
        .D(\mav_sum[31]_i_1_n_0 ),
        .Q(I11[17]),
        .R(1'b0));
  FDRE \mav_sum_reg[3] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_mav_sum[3]),
        .Q(I11[83]),
        .R(rst_n_0));
  FDRE \mav_sum_reg[4] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_mav_sum[4]),
        .Q(I11[84]),
        .R(rst_n_0));
  FDRE \mav_sum_reg[5] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_mav_sum[5]),
        .Q(I11[85]),
        .R(rst_n_0));
  FDRE \mav_sum_reg[6] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_mav_sum[6]),
        .Q(I11[86]),
        .R(rst_n_0));
  FDRE \mav_sum_reg[7] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_mav_sum[7]),
        .Q(I11[87]),
        .R(rst_n_0));
  FDRE \mav_sum_reg[8] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_mav_sum[8]),
        .Q(I11[88]),
        .R(rst_n_0));
  FDRE \mav_sum_reg[9] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_mav_sum[9]),
        .Q(I11[89]),
        .R(rst_n_0));
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
    next_energy1
       (.A({sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23:12]}),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT(NLW_next_energy1_ACOUT_UNCONNECTED[29:0]),
        .ALUMODE({1'b0,1'b0,1'b0,1'b0}),
        .B({1'b0,sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23:12]}),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(NLW_next_energy1_BCOUT_UNCONNECTED[17:0]),
        .C({1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(NLW_next_energy1_CARRYCASCOUT_UNCONNECTED),
        .CARRYIN(1'b0),
        .CARRYINSEL({1'b0,1'b0,1'b0}),
        .CARRYOUT(NLW_next_energy1_CARRYOUT_UNCONNECTED[3:0]),
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
        .MULTSIGNOUT(NLW_next_energy1_MULTSIGNOUT_UNCONNECTED),
        .OPMODE({1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,1'b1}),
        .OVERFLOW(NLW_next_energy1_OVERFLOW_UNCONNECTED),
        .P({next_energy1_n_58,next_energy1_n_59,next_energy1_n_60,next_energy1_n_61,next_energy1_n_62,next_energy1_n_63,next_energy1_n_64,next_energy1_n_65,next_energy1_n_66,next_energy1_n_67,next_energy1_n_68,next_energy1_n_69,next_energy1_n_70,next_energy1_n_71,next_energy1_n_72,next_energy1_n_73,next_energy1_n_74,next_energy1_n_75,next_energy1_n_76,next_energy1_n_77,next_energy1_n_78,next_energy1_n_79,next_energy1_n_80,next_energy1_n_81,next_energy1_n_82,next_energy1_n_83,next_energy1_n_84,next_energy1_n_85,next_energy1_n_86,next_energy1_n_87,next_energy1_n_88,next_energy1__1[16:0]}),
        .PATTERNBDETECT(NLW_next_energy1_PATTERNBDETECT_UNCONNECTED),
        .PATTERNDETECT(NLW_next_energy1_PATTERNDETECT_UNCONNECTED),
        .PCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .PCOUT({next_energy1_n_106,next_energy1_n_107,next_energy1_n_108,next_energy1_n_109,next_energy1_n_110,next_energy1_n_111,next_energy1_n_112,next_energy1_n_113,next_energy1_n_114,next_energy1_n_115,next_energy1_n_116,next_energy1_n_117,next_energy1_n_118,next_energy1_n_119,next_energy1_n_120,next_energy1_n_121,next_energy1_n_122,next_energy1_n_123,next_energy1_n_124,next_energy1_n_125,next_energy1_n_126,next_energy1_n_127,next_energy1_n_128,next_energy1_n_129,next_energy1_n_130,next_energy1_n_131,next_energy1_n_132,next_energy1_n_133,next_energy1_n_134,next_energy1_n_135,next_energy1_n_136,next_energy1_n_137,next_energy1_n_138,next_energy1_n_139,next_energy1_n_140,next_energy1_n_141,next_energy1_n_142,next_energy1_n_143,next_energy1_n_144,next_energy1_n_145,next_energy1_n_146,next_energy1_n_147,next_energy1_n_148,next_energy1_n_149,next_energy1_n_150,next_energy1_n_151,next_energy1_n_152,next_energy1_n_153}),
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
        .UNDERFLOW(NLW_next_energy1_UNDERFLOW_UNCONNECTED));
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
    next_energy1__0
       (.A({sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23:12]}),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT(NLW_next_energy1__0_ACOUT_UNCONNECTED[29:0]),
        .ALUMODE({1'b0,1'b0,1'b0,1'b0}),
        .B({sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23],sample_data[23]}),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(NLW_next_energy1__0_BCOUT_UNCONNECTED[17:0]),
        .C({1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(NLW_next_energy1__0_CARRYCASCOUT_UNCONNECTED),
        .CARRYIN(1'b0),
        .CARRYINSEL({1'b0,1'b0,1'b0}),
        .CARRYOUT(NLW_next_energy1__0_CARRYOUT_UNCONNECTED[3:0]),
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
        .MULTSIGNOUT(NLW_next_energy1__0_MULTSIGNOUT_UNCONNECTED),
        .OPMODE({1'b1,1'b0,1'b1,1'b0,1'b1,1'b0,1'b1}),
        .OVERFLOW(NLW_next_energy1__0_OVERFLOW_UNCONNECTED),
        .P({NLW_next_energy1__0_P_UNCONNECTED[47:15],next_energy1__1[31:17]}),
        .PATTERNBDETECT(NLW_next_energy1__0_PATTERNBDETECT_UNCONNECTED),
        .PATTERNDETECT(NLW_next_energy1__0_PATTERNDETECT_UNCONNECTED),
        .PCIN({next_energy1_n_106,next_energy1_n_107,next_energy1_n_108,next_energy1_n_109,next_energy1_n_110,next_energy1_n_111,next_energy1_n_112,next_energy1_n_113,next_energy1_n_114,next_energy1_n_115,next_energy1_n_116,next_energy1_n_117,next_energy1_n_118,next_energy1_n_119,next_energy1_n_120,next_energy1_n_121,next_energy1_n_122,next_energy1_n_123,next_energy1_n_124,next_energy1_n_125,next_energy1_n_126,next_energy1_n_127,next_energy1_n_128,next_energy1_n_129,next_energy1_n_130,next_energy1_n_131,next_energy1_n_132,next_energy1_n_133,next_energy1_n_134,next_energy1_n_135,next_energy1_n_136,next_energy1_n_137,next_energy1_n_138,next_energy1_n_139,next_energy1_n_140,next_energy1_n_141,next_energy1_n_142,next_energy1_n_143,next_energy1_n_144,next_energy1_n_145,next_energy1_n_146,next_energy1_n_147,next_energy1_n_148,next_energy1_n_149,next_energy1_n_150,next_energy1_n_151,next_energy1_n_152,next_energy1_n_153}),
        .PCOUT(NLW_next_energy1__0_PCOUT_UNCONNECTED[47:0]),
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
        .UNDERFLOW(NLW_next_energy1__0_UNDERFLOW_UNCONNECTED));
  LUT6 #(
    .INIT(64'hFFFFFFFEFFFF0000)) 
    \pending[0]_i_1 
       (.I0(\pending_reg[7]_1 ),
        .I1(busy_reg),
        .I2(\pending_reg[7]_0 ),
        .I3(\pending_reg[7] ),
        .I4(\pending[0]_i_2_n_0 ),
        .I5(\pending_reg[0] ),
        .O(\active_ch_reg[2]_5 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT4 #(
    .INIT(16'h0010)) 
    \pending[0]_i_2 
       (.I0(window_channel[0]),
        .I1(window_channel[2]),
        .I2(shared_valid),
        .I3(window_channel[1]),
        .O(\pending[0]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFEFFFFF0000)) 
    \pending[1]_i_1 
       (.I0(\pending_reg[7]_1 ),
        .I1(busy_reg),
        .I2(\pending_reg[7]_0 ),
        .I3(\pending_reg[7] ),
        .I4(\pending[1]_i_2_n_0 ),
        .I5(\pending_reg[1] ),
        .O(\active_ch_reg[2]_4 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'h0020)) 
    \pending[1]_i_2 
       (.I0(window_channel[0]),
        .I1(window_channel[2]),
        .I2(shared_valid),
        .I3(window_channel[1]),
        .O(\pending[1]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFEFFFFF0000)) 
    \pending[2]_i_1 
       (.I0(\pending_reg[7]_1 ),
        .I1(busy_reg),
        .I2(\pending_reg[7] ),
        .I3(\pending_reg[7]_0 ),
        .I4(\pending[2]_i_2_n_0 ),
        .I5(\pending_reg[2] ),
        .O(\active_ch_reg[2]_3 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT4 #(
    .INIT(16'h0400)) 
    \pending[2]_i_2 
       (.I0(window_channel[0]),
        .I1(window_channel[1]),
        .I2(window_channel[2]),
        .I3(shared_valid),
        .O(\pending[2]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFEFFFFFFF0000)) 
    \pending[3]_i_1 
       (.I0(\pending_reg[7]_1 ),
        .I1(busy_reg),
        .I2(\pending_reg[7]_0 ),
        .I3(\pending_reg[7] ),
        .I4(\pending[3]_i_2_n_0 ),
        .I5(\pending_reg[3] ),
        .O(\active_ch_reg[2]_2 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'h0800)) 
    \pending[3]_i_2 
       (.I0(window_channel[0]),
        .I1(window_channel[1]),
        .I2(window_channel[2]),
        .I3(shared_valid),
        .O(\pending[3]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFBFFFF0000)) 
    \pending[4]_i_1 
       (.I0(busy_reg),
        .I1(\pending_reg[7]_1 ),
        .I2(\pending_reg[7]_0 ),
        .I3(\pending_reg[7] ),
        .I4(\pending[4]_i_2_n_0 ),
        .I5(\pending_reg[4] ),
        .O(\active_ch_reg[2]_1 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT4 #(
    .INIT(16'h0040)) 
    \pending[4]_i_2 
       (.I0(window_channel[0]),
        .I1(shared_valid),
        .I2(window_channel[2]),
        .I3(window_channel[1]),
        .O(\pending[4]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFBFFFFF0000)) 
    \pending[5]_i_1 
       (.I0(busy_reg),
        .I1(\pending_reg[7]_1 ),
        .I2(\pending_reg[7]_0 ),
        .I3(\pending_reg[7] ),
        .I4(\pending[5]_i_2_n_0 ),
        .I5(\pending_reg[5] ),
        .O(\active_ch_reg[2]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'h0080)) 
    \pending[5]_i_2 
       (.I0(window_channel[0]),
        .I1(shared_valid),
        .I2(window_channel[2]),
        .I3(window_channel[1]),
        .O(\pending[5]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFBFFFFF0000)) 
    \pending[6]_i_1 
       (.I0(busy_reg),
        .I1(\pending_reg[7]_1 ),
        .I2(\pending_reg[7] ),
        .I3(\pending_reg[7]_0 ),
        .I4(\pending[6]_i_2_n_0 ),
        .I5(\pending_reg[6] ),
        .O(\active_ch_reg[2] ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT4 #(
    .INIT(16'h4000)) 
    \pending[6]_i_2 
       (.I0(window_channel[0]),
        .I1(window_channel[1]),
        .I2(shared_valid),
        .I3(window_channel[2]),
        .O(\pending[6]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFBFFFFFFF0000)) 
    \pending[7]_i_1 
       (.I0(busy_reg),
        .I1(\pending_reg[7] ),
        .I2(\pending_reg[7]_0 ),
        .I3(\pending_reg[7]_1 ),
        .I4(\pending[7]_i_2_n_0 ),
        .I5(\pending_reg[7]_2 ),
        .O(\active_ch_reg[1] ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h8000)) 
    \pending[7]_i_2 
       (.I0(window_channel[0]),
        .I1(window_channel[1]),
        .I2(shared_valid),
        .I3(window_channel[2]),
        .O(\pending[7]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hFFF7FFFF)) 
    \scan_ptr[1]_i_3 
       (.I0(\pending_reg[7]_3 ),
        .I1(feature_ready),
        .I2(\pending_reg[7]_4 ),
        .I3(\pending_reg[7]_5 ),
        .I4(\pending_reg[7]_6 ),
        .O(busy_reg));
  LUT5 #(
    .INIT(32'hFFFF0004)) 
    \seen[0]_i_1 
       (.I0(sample_channel[2]),
        .I1(sample_valid),
        .I2(sample_channel[0]),
        .I3(sample_channel[1]),
        .I4(seen[0]),
        .O(\seen[0]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hFFFF0040)) 
    \seen[1]_i_1 
       (.I0(sample_channel[2]),
        .I1(sample_valid),
        .I2(sample_channel[0]),
        .I3(sample_channel[1]),
        .I4(seen[1]),
        .O(\seen[1]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hFFFF0040)) 
    \seen[2]_i_1 
       (.I0(sample_channel[2]),
        .I1(sample_valid),
        .I2(sample_channel[1]),
        .I3(sample_channel[0]),
        .I4(seen[2]),
        .O(\seen[2]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hFFFF4000)) 
    \seen[3]_i_1 
       (.I0(sample_channel[2]),
        .I1(sample_valid),
        .I2(sample_channel[0]),
        .I3(sample_channel[1]),
        .I4(seen[3]),
        .O(\seen[3]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hFFFF0008)) 
    \seen[4]_i_1 
       (.I0(sample_valid),
        .I1(sample_channel[2]),
        .I2(sample_channel[0]),
        .I3(sample_channel[1]),
        .I4(seen[4]),
        .O(\seen[4]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hFFFF0080)) 
    \seen[5]_i_1 
       (.I0(sample_valid),
        .I1(sample_channel[2]),
        .I2(sample_channel[0]),
        .I3(sample_channel[1]),
        .I4(seen[5]),
        .O(\seen[5]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hFFFF0080)) 
    \seen[6]_i_1 
       (.I0(sample_valid),
        .I1(sample_channel[2]),
        .I2(sample_channel[1]),
        .I3(sample_channel[0]),
        .I4(seen[6]),
        .O(\seen[6]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hFFFF8000)) 
    \seen[7]_i_1 
       (.I0(sample_valid),
        .I1(sample_channel[2]),
        .I2(sample_channel[0]),
        .I3(sample_channel[1]),
        .I4(seen[7]),
        .O(\seen[7]_i_1_n_0 ));
  FDRE \seen_reg[0] 
       (.C(clk),
        .CE(1'b1),
        .D(\seen[0]_i_1_n_0 ),
        .Q(seen[0]),
        .R(rst_n_0));
  FDRE \seen_reg[1] 
       (.C(clk),
        .CE(1'b1),
        .D(\seen[1]_i_1_n_0 ),
        .Q(seen[1]),
        .R(rst_n_0));
  FDRE \seen_reg[2] 
       (.C(clk),
        .CE(1'b1),
        .D(\seen[2]_i_1_n_0 ),
        .Q(seen[2]),
        .R(rst_n_0));
  FDRE \seen_reg[3] 
       (.C(clk),
        .CE(1'b1),
        .D(\seen[3]_i_1_n_0 ),
        .Q(seen[3]),
        .R(rst_n_0));
  FDRE \seen_reg[4] 
       (.C(clk),
        .CE(1'b1),
        .D(\seen[4]_i_1_n_0 ),
        .Q(seen[4]),
        .R(rst_n_0));
  FDRE \seen_reg[5] 
       (.C(clk),
        .CE(1'b1),
        .D(\seen[5]_i_1_n_0 ),
        .Q(seen[5]),
        .R(rst_n_0));
  FDRE \seen_reg[6] 
       (.C(clk),
        .CE(1'b1),
        .D(\seen[6]_i_1_n_0 ),
        .Q(seen[6]),
        .R(rst_n_0));
  FDRE \seen_reg[7] 
       (.C(clk),
        .CE(1'b1),
        .D(\seen[7]_i_1_n_0 ),
        .Q(seen[7]),
        .R(rst_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    \shared_capture.hold_mem_reg_0_7_0_5_i_1 
       (.I0(rst_n),
        .I1(shared_valid),
        .O(p_0_in5_out));
  (* SOFT_HLUTNM = "soft_lutpair43" *) 
  LUT5 #(
    .INIT(32'hB77BB7B7)) 
    \ssc_count[3]_i_10 
       (.I0(context_word0[19]),
        .I1(context_word1),
        .I2(context_word0[159]),
        .I3(context_word0[16]),
        .I4(next_mav4[2]),
        .O(\ssc_count[3]_i_10_n_0 ));
  LUT3 #(
    .INIT(8'hDF)) 
    \ssc_count[3]_i_11 
       (.I0(context_word1),
        .I1(context_word0[16]),
        .I2(next_mav4[1]),
        .O(\ssc_count[3]_i_11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair43" *) 
  LUT3 #(
    .INIT(8'hDF)) 
    \ssc_count[3]_i_12 
       (.I0(context_word1),
        .I1(context_word0[16]),
        .I2(next_mav4[2]),
        .O(\ssc_count[3]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hFB00B00000000000)) 
    \ssc_count[3]_i_2 
       (.I0(context_word0[16]),
        .I1(next_mav4[1]),
        .I2(context_word0[158]),
        .I3(context_word1),
        .I4(context_word0[18]),
        .I5(\ssc_count[3]_i_10_n_0 ),
        .O(\ssc_count[3]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h8000080008008000)) 
    \ssc_count[3]_i_3 
       (.I0(context_word0[157]),
        .I1(context_word0[17]),
        .I2(\ssc_count[3]_i_11_n_0 ),
        .I3(context_word1),
        .I4(context_word0[158]),
        .I5(context_word0[18]),
        .O(\ssc_count[3]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h69AA96AA96AA96AA)) 
    \ssc_count[3]_i_4 
       (.I0(\ssc_count[3]_i_11_n_0 ),
        .I1(context_word0[158]),
        .I2(context_word0[18]),
        .I3(context_word1),
        .I4(context_word0[157]),
        .I5(context_word0[17]),
        .O(\ssc_count[3]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'h6555)) 
    \ssc_count[3]_i_5 
       (.I0(contexts_reg_0_7_157_157_i_4_n_0),
        .I1(context_word0[16]),
        .I2(context_word1),
        .I3(next_mav4[0]),
        .O(\ssc_count[3]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h9966966696666666)) 
    \ssc_count[3]_i_6 
       (.I0(\ssc_count[3]_i_2_n_0 ),
        .I1(\ssc_count[7]_i_13_n_0 ),
        .I2(context_word0[19]),
        .I3(context_word1),
        .I4(\ssc_count[3]_i_12_n_0 ),
        .I5(context_word0[159]),
        .O(\ssc_count[3]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h9966966696666666)) 
    \ssc_count[3]_i_7 
       (.I0(\ssc_count[3]_i_3_n_0 ),
        .I1(\ssc_count[3]_i_10_n_0 ),
        .I2(context_word0[18]),
        .I3(context_word1),
        .I4(context_word0[158]),
        .I5(\ssc_count[3]_i_11_n_0 ),
        .O(\ssc_count[3]_i_7_n_0 ));
  LUT5 #(
    .INIT(32'h55955555)) 
    \ssc_count[3]_i_8 
       (.I0(\ssc_count[3]_i_4_n_0 ),
        .I1(next_mav4[0]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(contexts_reg_0_7_157_157_i_4_n_0),
        .O(\ssc_count[3]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'h2DD20F0FD22D0F0F)) 
    \ssc_count[3]_i_9 
       (.I0(next_mav4[0]),
        .I1(context_word0[16]),
        .I2(contexts_reg_0_7_157_157_i_4_n_0),
        .I3(context_word0[17]),
        .I4(context_word1),
        .I5(context_word0[157]),
        .O(\ssc_count[3]_i_9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair91" *) 
  LUT5 #(
    .INIT(32'h9F6F9F9F)) 
    \ssc_count[7]_i_10 
       (.I0(context_word0[23]),
        .I1(context_word0[163]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(next_mav4[6]),
        .O(\ssc_count[7]_i_10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair92" *) 
  LUT5 #(
    .INIT(32'h9F6F9F9F)) 
    \ssc_count[7]_i_11 
       (.I0(context_word0[22]),
        .I1(context_word0[162]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(next_mav4[5]),
        .O(\ssc_count[7]_i_11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair93" *) 
  LUT5 #(
    .INIT(32'h9F6F9F9F)) 
    \ssc_count[7]_i_12 
       (.I0(context_word0[21]),
        .I1(context_word0[161]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(next_mav4[4]),
        .O(\ssc_count[7]_i_12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair94" *) 
  LUT5 #(
    .INIT(32'h9F6F9F9F)) 
    \ssc_count[7]_i_13 
       (.I0(context_word0[20]),
        .I1(context_word0[160]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(next_mav4[3]),
        .O(\ssc_count[7]_i_13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair92" *) 
  LUT5 #(
    .INIT(32'hCC8C8808)) 
    \ssc_count[7]_i_14 
       (.I0(context_word0[22]),
        .I1(context_word1),
        .I2(next_mav4[5]),
        .I3(context_word0[16]),
        .I4(context_word0[162]),
        .O(\ssc_count[7]_i_14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair194" *) 
  LUT3 #(
    .INIT(8'hDF)) 
    \ssc_count[7]_i_15 
       (.I0(context_word1),
        .I1(context_word0[16]),
        .I2(next_mav4[5]),
        .O(\ssc_count[7]_i_15_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair93" *) 
  LUT3 #(
    .INIT(8'hDF)) 
    \ssc_count[7]_i_16 
       (.I0(context_word1),
        .I1(context_word0[16]),
        .I2(next_mav4[4]),
        .O(\ssc_count[7]_i_16_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair94" *) 
  LUT3 #(
    .INIT(8'hDF)) 
    \ssc_count[7]_i_17 
       (.I0(context_word1),
        .I1(context_word0[16]),
        .I2(next_mav4[3]),
        .O(\ssc_count[7]_i_17_n_0 ));
  LUT6 #(
    .INIT(64'hEF008A0000000000)) 
    \ssc_count[7]_i_2 
       (.I0(context_word0[162]),
        .I1(context_word0[16]),
        .I2(next_mav4[5]),
        .I3(context_word1),
        .I4(context_word0[22]),
        .I5(\ssc_count[7]_i_10_n_0 ),
        .O(\ssc_count[7]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEF008A0000000000)) 
    \ssc_count[7]_i_3 
       (.I0(context_word0[161]),
        .I1(context_word0[16]),
        .I2(next_mav4[4]),
        .I3(context_word1),
        .I4(context_word0[21]),
        .I5(\ssc_count[7]_i_11_n_0 ),
        .O(\ssc_count[7]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFB00B00000000000)) 
    \ssc_count[7]_i_4 
       (.I0(context_word0[16]),
        .I1(next_mav4[3]),
        .I2(context_word0[160]),
        .I3(context_word1),
        .I4(context_word0[20]),
        .I5(\ssc_count[7]_i_12_n_0 ),
        .O(\ssc_count[7]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hEF008A0000000000)) 
    \ssc_count[7]_i_5 
       (.I0(context_word0[159]),
        .I1(context_word0[16]),
        .I2(next_mav4[2]),
        .I3(context_word1),
        .I4(context_word0[19]),
        .I5(\ssc_count[7]_i_13_n_0 ),
        .O(\ssc_count[7]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h75E5EF8F85151F7F)) 
    \ssc_count[7]_i_6 
       (.I0(\ssc_count[7]_i_14_n_0 ),
        .I1(context_word0[23]),
        .I2(context_word1),
        .I3(context_word0[163]),
        .I4(\ssc_count[8]_i_3_n_0 ),
        .I5(context_word0[24]),
        .O(\ssc_count[7]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h9966966696666666)) 
    \ssc_count[7]_i_7 
       (.I0(\ssc_count[7]_i_3_n_0 ),
        .I1(\ssc_count[7]_i_10_n_0 ),
        .I2(context_word0[22]),
        .I3(context_word1),
        .I4(\ssc_count[7]_i_15_n_0 ),
        .I5(context_word0[162]),
        .O(\ssc_count[7]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h9966966696666666)) 
    \ssc_count[7]_i_8 
       (.I0(\ssc_count[7]_i_4_n_0 ),
        .I1(\ssc_count[7]_i_11_n_0 ),
        .I2(context_word0[21]),
        .I3(context_word1),
        .I4(\ssc_count[7]_i_16_n_0 ),
        .I5(context_word0[161]),
        .O(\ssc_count[7]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'h9966966696666666)) 
    \ssc_count[7]_i_9 
       (.I0(\ssc_count[7]_i_5_n_0 ),
        .I1(\ssc_count[7]_i_12_n_0 ),
        .I2(context_word0[20]),
        .I3(context_word1),
        .I4(context_word0[160]),
        .I5(\ssc_count[7]_i_17_n_0 ),
        .O(\ssc_count[7]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hFFE8FFFF0017FFFF)) 
    \ssc_count[8]_i_2 
       (.I0(context_word0[23]),
        .I1(context_word0[163]),
        .I2(\ssc_count[8]_i_3_n_0 ),
        .I3(context_word0[24]),
        .I4(context_word1),
        .I5(context_word0[25]),
        .O(\ssc_count[8]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair91" *) 
  LUT3 #(
    .INIT(8'hDF)) 
    \ssc_count[8]_i_3 
       (.I0(context_word1),
        .I1(context_word0[16]),
        .I2(next_mav4[6]),
        .O(\ssc_count[8]_i_3_n_0 ));
  FDRE \ssc_count_reg[0] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(\ssc_count_reg[3]_i_1_n_7 ),
        .Q(I11[0]),
        .R(rst_n_0));
  FDRE \ssc_count_reg[1] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(\ssc_count_reg[3]_i_1_n_6 ),
        .Q(I11[1]),
        .R(rst_n_0));
  FDRE \ssc_count_reg[2] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(\ssc_count_reg[3]_i_1_n_5 ),
        .Q(I11[2]),
        .R(rst_n_0));
  FDRE \ssc_count_reg[3] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(\ssc_count_reg[3]_i_1_n_4 ),
        .Q(I11[3]),
        .R(rst_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ssc_count_reg[3]_i_1 
       (.CI(1'b0),
        .CO({\ssc_count_reg[3]_i_1_n_0 ,\ssc_count_reg[3]_i_1_n_1 ,\ssc_count_reg[3]_i_1_n_2 ,\ssc_count_reg[3]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\ssc_count[3]_i_2_n_0 ,\ssc_count[3]_i_3_n_0 ,\ssc_count[3]_i_4_n_0 ,\ssc_count[3]_i_5_n_0 }),
        .O({\ssc_count_reg[3]_i_1_n_4 ,\ssc_count_reg[3]_i_1_n_5 ,\ssc_count_reg[3]_i_1_n_6 ,\ssc_count_reg[3]_i_1_n_7 }),
        .S({\ssc_count[3]_i_6_n_0 ,\ssc_count[3]_i_7_n_0 ,\ssc_count[3]_i_8_n_0 ,\ssc_count[3]_i_9_n_0 }));
  FDRE \ssc_count_reg[4] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(\ssc_count_reg[7]_i_1_n_7 ),
        .Q(I11[4]),
        .R(rst_n_0));
  FDRE \ssc_count_reg[5] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(\ssc_count_reg[7]_i_1_n_6 ),
        .Q(I11[5]),
        .R(rst_n_0));
  FDRE \ssc_count_reg[6] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(\ssc_count_reg[7]_i_1_n_5 ),
        .Q(I11[6]),
        .R(rst_n_0));
  FDRE \ssc_count_reg[7] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(\ssc_count_reg[7]_i_1_n_4 ),
        .Q(I11[7]),
        .R(rst_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ssc_count_reg[7]_i_1 
       (.CI(\ssc_count_reg[3]_i_1_n_0 ),
        .CO({\ssc_count_reg[7]_i_1_n_0 ,\ssc_count_reg[7]_i_1_n_1 ,\ssc_count_reg[7]_i_1_n_2 ,\ssc_count_reg[7]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\ssc_count[7]_i_2_n_0 ,\ssc_count[7]_i_3_n_0 ,\ssc_count[7]_i_4_n_0 ,\ssc_count[7]_i_5_n_0 }),
        .O({\ssc_count_reg[7]_i_1_n_4 ,\ssc_count_reg[7]_i_1_n_5 ,\ssc_count_reg[7]_i_1_n_6 ,\ssc_count_reg[7]_i_1_n_7 }),
        .S({\ssc_count[7]_i_6_n_0 ,\ssc_count[7]_i_7_n_0 ,\ssc_count[7]_i_8_n_0 ,\ssc_count[7]_i_9_n_0 }));
  FDRE \ssc_count_reg[8] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(\ssc_count_reg[8]_i_1_n_7 ),
        .Q(I11[8]),
        .R(rst_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \ssc_count_reg[8]_i_1 
       (.CI(\ssc_count_reg[7]_i_1_n_0 ),
        .CO(\NLW_ssc_count_reg[8]_i_1_CO_UNCONNECTED [3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\NLW_ssc_count_reg[8]_i_1_O_UNCONNECTED [3:1],\ssc_count_reg[8]_i_1_n_7 }),
        .S({1'b0,1'b0,1'b0,\ssc_count[8]_i_2_n_0 }));
  LUT2 #(
    .INIT(4'h8)) 
    \window_channel[2]_i_1 
       (.I0(\window_channel[2]_i_2_n_0 ),
        .I1(sample_valid),
        .O(\window_channel[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair186" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \window_channel[2]_i_2 
       (.I0(\mav_sum[30]_i_3_n_0 ),
        .I1(window_valid_i_2_n_0),
        .O(\window_channel[2]_i_2_n_0 ));
  FDRE \window_channel_reg[0] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(sample_channel[0]),
        .Q(window_channel[0]),
        .R(rst_n_0));
  FDRE \window_channel_reg[1] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(sample_channel[1]),
        .Q(window_channel[1]),
        .R(rst_n_0));
  FDRE \window_channel_reg[2] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(sample_channel[2]),
        .Q(window_channel[2]),
        .R(rst_n_0));
  (* SOFT_HLUTNM = "soft_lutpair186" *) 
  LUT3 #(
    .INIT(8'h02)) 
    window_valid_i_1
       (.I0(p_3_out),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(window_valid_i_2_n_0),
        .O(window_valid_i_1_n_0));
  LUT6 #(
    .INIT(64'hEEEE0EEEEEEEEEEE)) 
    window_valid_i_2
       (.I0(window_valid_i_3_n_0),
        .I1(contexts_reg_0_7_12_12_i_2_n_0),
        .I2(contexts_reg_0_7_2_2_i_3_n_0),
        .I3(context_word1),
        .I4(window_valid_i_4_n_0),
        .I5(context_word0[5]),
        .O(window_valid_i_2_n_0));
  LUT6 #(
    .INIT(64'hFFFFBFFFFFFFFFFF)) 
    window_valid_i_3
       (.I0(window_valid_i_5_n_0),
        .I1(context_word0[15]),
        .I2(context_word0[14]),
        .I3(context_word1),
        .I4(context_word0[12]),
        .I5(context_word0[16]),
        .O(window_valid_i_3_n_0));
  LUT5 #(
    .INIT(32'hFFFFFEFF)) 
    window_valid_i_4
       (.I0(context_word0[3]),
        .I1(context_word0[2]),
        .I2(context_word0[16]),
        .I3(context_word0[6]),
        .I4(context_word0[4]),
        .O(window_valid_i_4_n_0));
  (* SOFT_HLUTNM = "soft_lutpair95" *) 
  LUT2 #(
    .INIT(4'hE)) 
    window_valid_i_5
       (.I0(context_word0[11]),
        .I1(context_word0[13]),
        .O(window_valid_i_5_n_0));
  FDRE window_valid_reg
       (.C(clk),
        .CE(1'b1),
        .D(window_valid_i_1_n_0),
        .Q(shared_valid),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair168" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \wl_sum[0]_i_1 
       (.I0(\wl_sum_reg[30]_i_2_n_3 ),
        .I1(next_wl0[0]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\wl_sum_reg[30]_i_3_n_3 ),
        .O(result_wl_sum[0]));
  (* SOFT_HLUTNM = "soft_lutpair163" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \wl_sum[10]_i_1 
       (.I0(\wl_sum_reg[30]_i_2_n_3 ),
        .I1(next_wl0[10]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\wl_sum_reg[30]_i_3_n_3 ),
        .O(result_wl_sum[10]));
  (* SOFT_HLUTNM = "soft_lutpair162" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \wl_sum[11]_i_1 
       (.I0(\wl_sum_reg[30]_i_2_n_3 ),
        .I1(next_wl0[11]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\wl_sum_reg[30]_i_3_n_3 ),
        .O(result_wl_sum[11]));
  (* SOFT_HLUTNM = "soft_lutpair162" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \wl_sum[12]_i_1 
       (.I0(\wl_sum_reg[30]_i_2_n_3 ),
        .I1(next_wl0[12]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\wl_sum_reg[30]_i_3_n_3 ),
        .O(result_wl_sum[12]));
  (* SOFT_HLUTNM = "soft_lutpair161" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \wl_sum[13]_i_1 
       (.I0(\wl_sum_reg[30]_i_2_n_3 ),
        .I1(next_wl0[13]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\wl_sum_reg[30]_i_3_n_3 ),
        .O(result_wl_sum[13]));
  (* SOFT_HLUTNM = "soft_lutpair161" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \wl_sum[14]_i_1 
       (.I0(\wl_sum_reg[30]_i_2_n_3 ),
        .I1(next_wl0[14]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\wl_sum_reg[30]_i_3_n_3 ),
        .O(result_wl_sum[14]));
  (* SOFT_HLUTNM = "soft_lutpair160" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \wl_sum[15]_i_1 
       (.I0(\wl_sum_reg[30]_i_2_n_3 ),
        .I1(next_wl0[15]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\wl_sum_reg[30]_i_3_n_3 ),
        .O(result_wl_sum[15]));
  (* SOFT_HLUTNM = "soft_lutpair160" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \wl_sum[16]_i_1 
       (.I0(\wl_sum_reg[30]_i_2_n_3 ),
        .I1(next_wl0[16]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\wl_sum_reg[30]_i_3_n_3 ),
        .O(result_wl_sum[16]));
  (* SOFT_HLUTNM = "soft_lutpair159" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \wl_sum[17]_i_1 
       (.I0(\wl_sum_reg[30]_i_2_n_3 ),
        .I1(next_wl0[17]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\wl_sum_reg[30]_i_3_n_3 ),
        .O(result_wl_sum[17]));
  (* SOFT_HLUTNM = "soft_lutpair159" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \wl_sum[18]_i_1 
       (.I0(\wl_sum_reg[30]_i_2_n_3 ),
        .I1(next_wl0[18]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\wl_sum_reg[30]_i_3_n_3 ),
        .O(result_wl_sum[18]));
  (* SOFT_HLUTNM = "soft_lutpair158" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \wl_sum[19]_i_1 
       (.I0(\wl_sum_reg[30]_i_2_n_3 ),
        .I1(next_wl0[19]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\wl_sum_reg[30]_i_3_n_3 ),
        .O(result_wl_sum[19]));
  (* SOFT_HLUTNM = "soft_lutpair167" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \wl_sum[1]_i_1 
       (.I0(\wl_sum_reg[30]_i_2_n_3 ),
        .I1(next_wl0[1]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\wl_sum_reg[30]_i_3_n_3 ),
        .O(result_wl_sum[1]));
  (* SOFT_HLUTNM = "soft_lutpair158" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \wl_sum[20]_i_1 
       (.I0(\wl_sum_reg[30]_i_2_n_3 ),
        .I1(next_wl0[20]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\wl_sum_reg[30]_i_3_n_3 ),
        .O(result_wl_sum[20]));
  (* SOFT_HLUTNM = "soft_lutpair157" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \wl_sum[21]_i_1 
       (.I0(\wl_sum_reg[30]_i_2_n_3 ),
        .I1(next_wl0[21]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\wl_sum_reg[30]_i_3_n_3 ),
        .O(result_wl_sum[21]));
  (* SOFT_HLUTNM = "soft_lutpair157" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \wl_sum[22]_i_1 
       (.I0(\wl_sum_reg[30]_i_2_n_3 ),
        .I1(next_wl0[22]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\wl_sum_reg[30]_i_3_n_3 ),
        .O(result_wl_sum[22]));
  (* SOFT_HLUTNM = "soft_lutpair156" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \wl_sum[23]_i_1 
       (.I0(\wl_sum_reg[30]_i_2_n_3 ),
        .I1(next_wl0[23]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\wl_sum_reg[30]_i_3_n_3 ),
        .O(result_wl_sum[23]));
  (* SOFT_HLUTNM = "soft_lutpair156" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \wl_sum[24]_i_1 
       (.I0(\wl_sum_reg[30]_i_2_n_3 ),
        .I1(next_wl0[24]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\wl_sum_reg[30]_i_3_n_3 ),
        .O(result_wl_sum[24]));
  (* SOFT_HLUTNM = "soft_lutpair155" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \wl_sum[25]_i_1 
       (.I0(\wl_sum_reg[30]_i_2_n_3 ),
        .I1(next_wl0[25]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\wl_sum_reg[30]_i_3_n_3 ),
        .O(result_wl_sum[25]));
  (* SOFT_HLUTNM = "soft_lutpair155" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \wl_sum[26]_i_1 
       (.I0(\wl_sum_reg[30]_i_2_n_3 ),
        .I1(next_wl0[26]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\wl_sum_reg[30]_i_3_n_3 ),
        .O(result_wl_sum[26]));
  (* SOFT_HLUTNM = "soft_lutpair154" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \wl_sum[27]_i_1 
       (.I0(\wl_sum_reg[30]_i_2_n_3 ),
        .I1(next_wl0[27]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\wl_sum_reg[30]_i_3_n_3 ),
        .O(result_wl_sum[27]));
  (* SOFT_HLUTNM = "soft_lutpair154" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \wl_sum[28]_i_1 
       (.I0(\wl_sum_reg[30]_i_2_n_3 ),
        .I1(next_wl0[28]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\wl_sum_reg[30]_i_3_n_3 ),
        .O(result_wl_sum[28]));
  (* SOFT_HLUTNM = "soft_lutpair153" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \wl_sum[29]_i_1 
       (.I0(\wl_sum_reg[30]_i_2_n_3 ),
        .I1(next_wl0[29]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\wl_sum_reg[30]_i_3_n_3 ),
        .O(result_wl_sum[29]));
  (* SOFT_HLUTNM = "soft_lutpair167" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \wl_sum[2]_i_1 
       (.I0(\wl_sum_reg[30]_i_2_n_3 ),
        .I1(next_wl0[2]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\wl_sum_reg[30]_i_3_n_3 ),
        .O(result_wl_sum[2]));
  (* SOFT_HLUTNM = "soft_lutpair153" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \wl_sum[30]_i_1 
       (.I0(\wl_sum_reg[30]_i_2_n_3 ),
        .I1(next_wl0[30]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\wl_sum_reg[30]_i_3_n_3 ),
        .O(result_wl_sum[30]));
  LUT3 #(
    .INIT(8'hDF)) 
    \wl_sum[30]_i_10 
       (.I0(next_wl0[36]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_wl0[37]),
        .O(\wl_sum[30]_i_10_n_0 ));
  LUT3 #(
    .INIT(8'hDF)) 
    \wl_sum[30]_i_11 
       (.I0(next_wl0[34]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_wl0[35]),
        .O(\wl_sum[30]_i_11_n_0 ));
  LUT3 #(
    .INIT(8'hDF)) 
    \wl_sum[30]_i_12 
       (.I0(next_wl0[32]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_wl0[33]),
        .O(\wl_sum[30]_i_12_n_0 ));
  LUT2 #(
    .INIT(4'hB)) 
    \wl_sum[30]_i_13 
       (.I0(\mav_sum[30]_i_3_n_0 ),
        .I1(next_wl0[31]),
        .O(\wl_sum[30]_i_13_n_0 ));
  LUT3 #(
    .INIT(8'h20)) 
    \wl_sum[30]_i_14 
       (.I0(next_wl0[37]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_wl0[36]),
        .O(\wl_sum[30]_i_14_n_0 ));
  LUT3 #(
    .INIT(8'h20)) 
    \wl_sum[30]_i_15 
       (.I0(next_wl0[35]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_wl0[34]),
        .O(\wl_sum[30]_i_15_n_0 ));
  LUT3 #(
    .INIT(8'h20)) 
    \wl_sum[30]_i_16 
       (.I0(next_wl0[33]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_wl0[32]),
        .O(\wl_sum[30]_i_16_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \wl_sum[30]_i_17 
       (.I0(next_wl0[30]),
        .I1(next_wl0[31]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .O(\wl_sum[30]_i_17_n_0 ));
  LUT3 #(
    .INIT(8'h32)) 
    \wl_sum[30]_i_18 
       (.I0(next_wl0[36]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_wl0[37]),
        .O(\wl_sum[30]_i_18_n_0 ));
  LUT3 #(
    .INIT(8'h32)) 
    \wl_sum[30]_i_19 
       (.I0(next_wl0[34]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_wl0[35]),
        .O(\wl_sum[30]_i_19_n_0 ));
  LUT3 #(
    .INIT(8'h32)) 
    \wl_sum[30]_i_20 
       (.I0(next_wl0[32]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_wl0[33]),
        .O(\wl_sum[30]_i_20_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \wl_sum[30]_i_21 
       (.I0(next_wl0[31]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .O(\wl_sum[30]_i_21_n_0 ));
  LUT3 #(
    .INIT(8'hCD)) 
    \wl_sum[30]_i_22 
       (.I0(next_wl0[37]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_wl0[36]),
        .O(\wl_sum[30]_i_22_n_0 ));
  LUT3 #(
    .INIT(8'hCD)) 
    \wl_sum[30]_i_23 
       (.I0(next_wl0[35]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_wl0[34]),
        .O(\wl_sum[30]_i_23_n_0 ));
  LUT3 #(
    .INIT(8'hCD)) 
    \wl_sum[30]_i_24 
       (.I0(next_wl0[33]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_wl0[32]),
        .O(\wl_sum[30]_i_24_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \wl_sum[30]_i_25 
       (.I0(next_wl0[31]),
        .I1(next_wl0[30]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .O(\wl_sum[30]_i_25_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \wl_sum[30]_i_5 
       (.I0(next_wl0[38]),
        .I1(next_wl0[39]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .O(\wl_sum[30]_i_5_n_0 ));
  LUT3 #(
    .INIT(8'h40)) 
    \wl_sum[30]_i_6 
       (.I0(\mav_sum[30]_i_3_n_0 ),
        .I1(next_wl0[38]),
        .I2(next_wl0[39]),
        .O(\wl_sum[30]_i_6_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \wl_sum[30]_i_8 
       (.I0(\mav_sum[30]_i_3_n_0 ),
        .I1(next_wl0[38]),
        .I2(next_wl0[39]),
        .O(\wl_sum[30]_i_8_n_0 ));
  LUT3 #(
    .INIT(8'hCD)) 
    \wl_sum[30]_i_9 
       (.I0(next_wl0[39]),
        .I1(\mav_sum[30]_i_3_n_0 ),
        .I2(next_wl0[38]),
        .O(\wl_sum[30]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'h0CCC5CCC00000000)) 
    \wl_sum[31]_i_1 
       (.I0(\wl_sum_reg[30]_i_3_n_3 ),
        .I1(I11[79]),
        .I2(sample_valid),
        .I3(\window_channel[2]_i_2_n_0 ),
        .I4(\wl_sum[31]_i_2_n_0 ),
        .I5(rst_n),
        .O(\wl_sum[31]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair168" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \wl_sum[31]_i_2 
       (.I0(next_wl0[31]),
        .I1(\wl_sum_reg[30]_i_2_n_3 ),
        .O(\wl_sum[31]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair166" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \wl_sum[3]_i_1 
       (.I0(\wl_sum_reg[30]_i_2_n_3 ),
        .I1(next_wl0[3]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\wl_sum_reg[30]_i_3_n_3 ),
        .O(result_wl_sum[3]));
  (* SOFT_HLUTNM = "soft_lutpair166" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \wl_sum[4]_i_1 
       (.I0(\wl_sum_reg[30]_i_2_n_3 ),
        .I1(next_wl0[4]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\wl_sum_reg[30]_i_3_n_3 ),
        .O(result_wl_sum[4]));
  (* SOFT_HLUTNM = "soft_lutpair165" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \wl_sum[5]_i_1 
       (.I0(\wl_sum_reg[30]_i_2_n_3 ),
        .I1(next_wl0[5]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\wl_sum_reg[30]_i_3_n_3 ),
        .O(result_wl_sum[5]));
  (* SOFT_HLUTNM = "soft_lutpair165" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \wl_sum[6]_i_1 
       (.I0(\wl_sum_reg[30]_i_2_n_3 ),
        .I1(next_wl0[6]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\wl_sum_reg[30]_i_3_n_3 ),
        .O(result_wl_sum[6]));
  (* SOFT_HLUTNM = "soft_lutpair164" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \wl_sum[7]_i_1 
       (.I0(\wl_sum_reg[30]_i_2_n_3 ),
        .I1(next_wl0[7]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\wl_sum_reg[30]_i_3_n_3 ),
        .O(result_wl_sum[7]));
  (* SOFT_HLUTNM = "soft_lutpair164" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \wl_sum[8]_i_1 
       (.I0(\wl_sum_reg[30]_i_2_n_3 ),
        .I1(next_wl0[8]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\wl_sum_reg[30]_i_3_n_3 ),
        .O(result_wl_sum[8]));
  (* SOFT_HLUTNM = "soft_lutpair163" *) 
  LUT4 #(
    .INIT(16'hFF04)) 
    \wl_sum[9]_i_1 
       (.I0(\wl_sum_reg[30]_i_2_n_3 ),
        .I1(next_wl0[9]),
        .I2(\mav_sum[30]_i_3_n_0 ),
        .I3(\wl_sum_reg[30]_i_3_n_3 ),
        .O(result_wl_sum[9]));
  FDRE \wl_sum_reg[0] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_wl_sum[0]),
        .Q(I11[48]),
        .R(rst_n_0));
  FDRE \wl_sum_reg[10] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_wl_sum[10]),
        .Q(I11[58]),
        .R(rst_n_0));
  FDRE \wl_sum_reg[11] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_wl_sum[11]),
        .Q(I11[59]),
        .R(rst_n_0));
  FDRE \wl_sum_reg[12] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_wl_sum[12]),
        .Q(I11[60]),
        .R(rst_n_0));
  FDRE \wl_sum_reg[13] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_wl_sum[13]),
        .Q(I11[61]),
        .R(rst_n_0));
  FDRE \wl_sum_reg[14] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_wl_sum[14]),
        .Q(I11[62]),
        .R(rst_n_0));
  FDRE \wl_sum_reg[15] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_wl_sum[15]),
        .Q(I11[63]),
        .R(rst_n_0));
  FDRE \wl_sum_reg[16] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_wl_sum[16]),
        .Q(I11[64]),
        .R(rst_n_0));
  FDRE \wl_sum_reg[17] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_wl_sum[17]),
        .Q(I11[65]),
        .R(rst_n_0));
  FDRE \wl_sum_reg[18] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_wl_sum[18]),
        .Q(I11[66]),
        .R(rst_n_0));
  FDRE \wl_sum_reg[19] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_wl_sum[19]),
        .Q(I11[67]),
        .R(rst_n_0));
  FDRE \wl_sum_reg[1] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_wl_sum[1]),
        .Q(I11[49]),
        .R(rst_n_0));
  FDRE \wl_sum_reg[20] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_wl_sum[20]),
        .Q(I11[68]),
        .R(rst_n_0));
  FDRE \wl_sum_reg[21] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_wl_sum[21]),
        .Q(I11[69]),
        .R(rst_n_0));
  FDRE \wl_sum_reg[22] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_wl_sum[22]),
        .Q(I11[70]),
        .R(rst_n_0));
  FDRE \wl_sum_reg[23] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_wl_sum[23]),
        .Q(I11[71]),
        .R(rst_n_0));
  FDRE \wl_sum_reg[24] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_wl_sum[24]),
        .Q(I11[72]),
        .R(rst_n_0));
  FDRE \wl_sum_reg[25] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_wl_sum[25]),
        .Q(I11[73]),
        .R(rst_n_0));
  FDRE \wl_sum_reg[26] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_wl_sum[26]),
        .Q(I11[74]),
        .R(rst_n_0));
  FDRE \wl_sum_reg[27] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_wl_sum[27]),
        .Q(I11[75]),
        .R(rst_n_0));
  FDRE \wl_sum_reg[28] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_wl_sum[28]),
        .Q(I11[76]),
        .R(rst_n_0));
  FDRE \wl_sum_reg[29] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_wl_sum[29]),
        .Q(I11[77]),
        .R(rst_n_0));
  FDRE \wl_sum_reg[2] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_wl_sum[2]),
        .Q(I11[50]),
        .R(rst_n_0));
  FDRE \wl_sum_reg[30] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_wl_sum[30]),
        .Q(I11[78]),
        .R(rst_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \wl_sum_reg[30]_i_2 
       (.CI(\wl_sum_reg[30]_i_4_n_0 ),
        .CO({\NLW_wl_sum_reg[30]_i_2_CO_UNCONNECTED [3:1],\wl_sum_reg[30]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,\wl_sum[30]_i_5_n_0 }),
        .O(\NLW_wl_sum_reg[30]_i_2_O_UNCONNECTED [3:0]),
        .S({1'b0,1'b0,1'b0,\wl_sum[30]_i_6_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \wl_sum_reg[30]_i_3 
       (.CI(\wl_sum_reg[30]_i_7_n_0 ),
        .CO({\NLW_wl_sum_reg[30]_i_3_CO_UNCONNECTED [3:1],\wl_sum_reg[30]_i_3_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,\wl_sum[30]_i_8_n_0 }),
        .O(\NLW_wl_sum_reg[30]_i_3_O_UNCONNECTED [3:0]),
        .S({1'b0,1'b0,1'b0,\wl_sum[30]_i_9_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \wl_sum_reg[30]_i_4 
       (.CI(1'b0),
        .CO({\wl_sum_reg[30]_i_4_n_0 ,\wl_sum_reg[30]_i_4_n_1 ,\wl_sum_reg[30]_i_4_n_2 ,\wl_sum_reg[30]_i_4_n_3 }),
        .CYINIT(1'b0),
        .DI({\wl_sum[30]_i_10_n_0 ,\wl_sum[30]_i_11_n_0 ,\wl_sum[30]_i_12_n_0 ,\wl_sum[30]_i_13_n_0 }),
        .O(\NLW_wl_sum_reg[30]_i_4_O_UNCONNECTED [3:0]),
        .S({\wl_sum[30]_i_14_n_0 ,\wl_sum[30]_i_15_n_0 ,\wl_sum[30]_i_16_n_0 ,\wl_sum[30]_i_17_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \wl_sum_reg[30]_i_7 
       (.CI(1'b0),
        .CO({\wl_sum_reg[30]_i_7_n_0 ,\wl_sum_reg[30]_i_7_n_1 ,\wl_sum_reg[30]_i_7_n_2 ,\wl_sum_reg[30]_i_7_n_3 }),
        .CYINIT(1'b0),
        .DI({\wl_sum[30]_i_18_n_0 ,\wl_sum[30]_i_19_n_0 ,\wl_sum[30]_i_20_n_0 ,\wl_sum[30]_i_21_n_0 }),
        .O(\NLW_wl_sum_reg[30]_i_7_O_UNCONNECTED [3:0]),
        .S({\wl_sum[30]_i_22_n_0 ,\wl_sum[30]_i_23_n_0 ,\wl_sum[30]_i_24_n_0 ,\wl_sum[30]_i_25_n_0 }));
  FDRE \wl_sum_reg[31] 
       (.C(clk),
        .CE(1'b1),
        .D(\wl_sum[31]_i_1_n_0 ),
        .Q(I11[79]),
        .R(1'b0));
  FDRE \wl_sum_reg[3] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_wl_sum[3]),
        .Q(I11[51]),
        .R(rst_n_0));
  FDRE \wl_sum_reg[4] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_wl_sum[4]),
        .Q(I11[52]),
        .R(rst_n_0));
  FDRE \wl_sum_reg[5] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_wl_sum[5]),
        .Q(I11[53]),
        .R(rst_n_0));
  FDRE \wl_sum_reg[6] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_wl_sum[6]),
        .Q(I11[54]),
        .R(rst_n_0));
  FDRE \wl_sum_reg[7] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_wl_sum[7]),
        .Q(I11[55]),
        .R(rst_n_0));
  FDRE \wl_sum_reg[8] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_wl_sum[8]),
        .Q(I11[56]),
        .R(rst_n_0));
  FDRE \wl_sum_reg[9] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(result_wl_sum[9]),
        .Q(I11[57]),
        .R(rst_n_0));
  (* SOFT_HLUTNM = "soft_lutpair42" *) 
  LUT5 #(
    .INIT(32'hB77BB7B7)) 
    \zc_count[3]_i_10 
       (.I0(context_word0[28]),
        .I1(context_word1),
        .I2(context_word0[166]),
        .I3(context_word0[16]),
        .I4(next_mav4[9]),
        .O(\zc_count[3]_i_10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair194" *) 
  LUT3 #(
    .INIT(8'hDF)) 
    \zc_count[3]_i_11 
       (.I0(context_word1),
        .I1(context_word0[16]),
        .I2(next_mav4[8]),
        .O(\zc_count[3]_i_11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair42" *) 
  LUT3 #(
    .INIT(8'hDF)) 
    \zc_count[3]_i_12 
       (.I0(context_word1),
        .I1(context_word0[16]),
        .I2(next_mav4[9]),
        .O(\zc_count[3]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hFB00B00000000000)) 
    \zc_count[3]_i_2 
       (.I0(context_word0[16]),
        .I1(next_mav4[8]),
        .I2(context_word0[165]),
        .I3(context_word1),
        .I4(context_word0[27]),
        .I5(\zc_count[3]_i_10_n_0 ),
        .O(\zc_count[3]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h8000080008008000)) 
    \zc_count[3]_i_3 
       (.I0(context_word0[164]),
        .I1(context_word0[26]),
        .I2(\zc_count[3]_i_11_n_0 ),
        .I3(context_word1),
        .I4(context_word0[165]),
        .I5(context_word0[27]),
        .O(\zc_count[3]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h69AA96AA96AA96AA)) 
    \zc_count[3]_i_4 
       (.I0(\zc_count[3]_i_11_n_0 ),
        .I1(context_word0[165]),
        .I2(context_word0[27]),
        .I3(context_word1),
        .I4(context_word0[164]),
        .I5(context_word0[26]),
        .O(\zc_count[3]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h609F000060600000)) 
    \zc_count[3]_i_5 
       (.I0(sample_data[23]),
        .I1(context_word0[323]),
        .I2(zc_event1),
        .I3(context_word0[16]),
        .I4(context_word1),
        .I5(next_mav4[7]),
        .O(\zc_count[3]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h9966966696666666)) 
    \zc_count[3]_i_6 
       (.I0(\zc_count[3]_i_2_n_0 ),
        .I1(\zc_count[7]_i_13_n_0 ),
        .I2(context_word0[28]),
        .I3(context_word1),
        .I4(\zc_count[3]_i_12_n_0 ),
        .I5(context_word0[166]),
        .O(\zc_count[3]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h9966966696666666)) 
    \zc_count[3]_i_7 
       (.I0(\zc_count[3]_i_3_n_0 ),
        .I1(\zc_count[3]_i_10_n_0 ),
        .I2(context_word0[27]),
        .I3(context_word1),
        .I4(context_word0[165]),
        .I5(\zc_count[3]_i_11_n_0 ),
        .O(\zc_count[3]_i_7_n_0 ));
  LUT5 #(
    .INIT(32'h55955555)) 
    \zc_count[3]_i_8 
       (.I0(\zc_count[3]_i_4_n_0 ),
        .I1(next_mav4[7]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(contexts_reg_0_7_165_165_i_2_n_0),
        .O(\zc_count[3]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'h2DD20F0FD22D0F0F)) 
    \zc_count[3]_i_9 
       (.I0(next_mav4[7]),
        .I1(context_word0[16]),
        .I2(contexts_reg_0_7_165_165_i_2_n_0),
        .I3(context_word0[26]),
        .I4(context_word1),
        .I5(context_word0[164]),
        .O(\zc_count[3]_i_9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair87" *) 
  LUT5 #(
    .INIT(32'h9F6F9F9F)) 
    \zc_count[7]_i_10 
       (.I0(context_word0[32]),
        .I1(context_word0[170]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(next_mav4[13]),
        .O(\zc_count[7]_i_10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair88" *) 
  LUT5 #(
    .INIT(32'h9F6F9F9F)) 
    \zc_count[7]_i_11 
       (.I0(context_word0[31]),
        .I1(context_word0[169]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(next_mav4[12]),
        .O(\zc_count[7]_i_11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair89" *) 
  LUT5 #(
    .INIT(32'h9F6F9F9F)) 
    \zc_count[7]_i_12 
       (.I0(context_word0[30]),
        .I1(context_word0[168]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(next_mav4[11]),
        .O(\zc_count[7]_i_12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair90" *) 
  LUT5 #(
    .INIT(32'h9F6F9F9F)) 
    \zc_count[7]_i_13 
       (.I0(context_word0[29]),
        .I1(context_word0[167]),
        .I2(context_word1),
        .I3(context_word0[16]),
        .I4(next_mav4[10]),
        .O(\zc_count[7]_i_13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair88" *) 
  LUT5 #(
    .INIT(32'hCC8C8808)) 
    \zc_count[7]_i_14 
       (.I0(context_word0[31]),
        .I1(context_word1),
        .I2(next_mav4[12]),
        .I3(context_word0[16]),
        .I4(context_word0[169]),
        .O(\zc_count[7]_i_14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair193" *) 
  LUT3 #(
    .INIT(8'hDF)) 
    \zc_count[7]_i_15 
       (.I0(context_word1),
        .I1(context_word0[16]),
        .I2(next_mav4[12]),
        .O(\zc_count[7]_i_15_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair89" *) 
  LUT3 #(
    .INIT(8'hDF)) 
    \zc_count[7]_i_16 
       (.I0(context_word1),
        .I1(context_word0[16]),
        .I2(next_mav4[11]),
        .O(\zc_count[7]_i_16_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair90" *) 
  LUT3 #(
    .INIT(8'hDF)) 
    \zc_count[7]_i_17 
       (.I0(context_word1),
        .I1(context_word0[16]),
        .I2(next_mav4[10]),
        .O(\zc_count[7]_i_17_n_0 ));
  LUT6 #(
    .INIT(64'hEF008A0000000000)) 
    \zc_count[7]_i_2 
       (.I0(context_word0[169]),
        .I1(context_word0[16]),
        .I2(next_mav4[12]),
        .I3(context_word1),
        .I4(context_word0[31]),
        .I5(\zc_count[7]_i_10_n_0 ),
        .O(\zc_count[7]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEF008A0000000000)) 
    \zc_count[7]_i_3 
       (.I0(context_word0[168]),
        .I1(context_word0[16]),
        .I2(next_mav4[11]),
        .I3(context_word1),
        .I4(context_word0[30]),
        .I5(\zc_count[7]_i_11_n_0 ),
        .O(\zc_count[7]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFB00B00000000000)) 
    \zc_count[7]_i_4 
       (.I0(context_word0[16]),
        .I1(next_mav4[10]),
        .I2(context_word0[167]),
        .I3(context_word1),
        .I4(context_word0[29]),
        .I5(\zc_count[7]_i_12_n_0 ),
        .O(\zc_count[7]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hEF008A0000000000)) 
    \zc_count[7]_i_5 
       (.I0(context_word0[166]),
        .I1(context_word0[16]),
        .I2(next_mav4[9]),
        .I3(context_word1),
        .I4(context_word0[28]),
        .I5(\zc_count[7]_i_13_n_0 ),
        .O(\zc_count[7]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h75E5EF8F85151F7F)) 
    \zc_count[7]_i_6 
       (.I0(\zc_count[7]_i_14_n_0 ),
        .I1(context_word0[32]),
        .I2(context_word1),
        .I3(context_word0[170]),
        .I4(\zc_count[8]_i_3_n_0 ),
        .I5(context_word0[33]),
        .O(\zc_count[7]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h9966966696666666)) 
    \zc_count[7]_i_7 
       (.I0(\zc_count[7]_i_3_n_0 ),
        .I1(\zc_count[7]_i_10_n_0 ),
        .I2(context_word0[31]),
        .I3(context_word1),
        .I4(\zc_count[7]_i_15_n_0 ),
        .I5(context_word0[169]),
        .O(\zc_count[7]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h9966966696666666)) 
    \zc_count[7]_i_8 
       (.I0(\zc_count[7]_i_4_n_0 ),
        .I1(\zc_count[7]_i_11_n_0 ),
        .I2(context_word0[30]),
        .I3(context_word1),
        .I4(\zc_count[7]_i_16_n_0 ),
        .I5(context_word0[168]),
        .O(\zc_count[7]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'h9966966696666666)) 
    \zc_count[7]_i_9 
       (.I0(\zc_count[7]_i_5_n_0 ),
        .I1(\zc_count[7]_i_12_n_0 ),
        .I2(context_word0[29]),
        .I3(context_word1),
        .I4(context_word0[167]),
        .I5(\zc_count[7]_i_17_n_0 ),
        .O(\zc_count[7]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hFFE8FFFF0017FFFF)) 
    \zc_count[8]_i_2 
       (.I0(context_word0[32]),
        .I1(context_word0[170]),
        .I2(\zc_count[8]_i_3_n_0 ),
        .I3(context_word0[33]),
        .I4(context_word1),
        .I5(context_word0[34]),
        .O(\zc_count[8]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair87" *) 
  LUT3 #(
    .INIT(8'hDF)) 
    \zc_count[8]_i_3 
       (.I0(context_word1),
        .I1(context_word0[16]),
        .I2(next_mav4[13]),
        .O(\zc_count[8]_i_3_n_0 ));
  FDRE \zc_count_reg[0] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(\zc_count_reg[3]_i_1_n_7 ),
        .Q(zc_count[0]),
        .R(rst_n_0));
  FDRE \zc_count_reg[1] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(\zc_count_reg[3]_i_1_n_6 ),
        .Q(zc_count[1]),
        .R(rst_n_0));
  FDRE \zc_count_reg[2] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(\zc_count_reg[3]_i_1_n_5 ),
        .Q(I11[9]),
        .R(rst_n_0));
  FDRE \zc_count_reg[3] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(\zc_count_reg[3]_i_1_n_4 ),
        .Q(I11[10]),
        .R(rst_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \zc_count_reg[3]_i_1 
       (.CI(1'b0),
        .CO({\zc_count_reg[3]_i_1_n_0 ,\zc_count_reg[3]_i_1_n_1 ,\zc_count_reg[3]_i_1_n_2 ,\zc_count_reg[3]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\zc_count[3]_i_2_n_0 ,\zc_count[3]_i_3_n_0 ,\zc_count[3]_i_4_n_0 ,\zc_count[3]_i_5_n_0 }),
        .O({\zc_count_reg[3]_i_1_n_4 ,\zc_count_reg[3]_i_1_n_5 ,\zc_count_reg[3]_i_1_n_6 ,\zc_count_reg[3]_i_1_n_7 }),
        .S({\zc_count[3]_i_6_n_0 ,\zc_count[3]_i_7_n_0 ,\zc_count[3]_i_8_n_0 ,\zc_count[3]_i_9_n_0 }));
  FDRE \zc_count_reg[4] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(\zc_count_reg[7]_i_1_n_7 ),
        .Q(I11[11]),
        .R(rst_n_0));
  FDRE \zc_count_reg[5] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(\zc_count_reg[7]_i_1_n_6 ),
        .Q(I11[12]),
        .R(rst_n_0));
  FDRE \zc_count_reg[6] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(\zc_count_reg[7]_i_1_n_5 ),
        .Q(I11[13]),
        .R(rst_n_0));
  FDRE \zc_count_reg[7] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(\zc_count_reg[7]_i_1_n_4 ),
        .Q(I11[14]),
        .R(rst_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \zc_count_reg[7]_i_1 
       (.CI(\zc_count_reg[3]_i_1_n_0 ),
        .CO({\zc_count_reg[7]_i_1_n_0 ,\zc_count_reg[7]_i_1_n_1 ,\zc_count_reg[7]_i_1_n_2 ,\zc_count_reg[7]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\zc_count[7]_i_2_n_0 ,\zc_count[7]_i_3_n_0 ,\zc_count[7]_i_4_n_0 ,\zc_count[7]_i_5_n_0 }),
        .O({\zc_count_reg[7]_i_1_n_4 ,\zc_count_reg[7]_i_1_n_5 ,\zc_count_reg[7]_i_1_n_6 ,\zc_count_reg[7]_i_1_n_7 }),
        .S({\zc_count[7]_i_6_n_0 ,\zc_count[7]_i_7_n_0 ,\zc_count[7]_i_8_n_0 ,\zc_count[7]_i_9_n_0 }));
  FDRE \zc_count_reg[8] 
       (.C(clk),
        .CE(\window_channel[2]_i_1_n_0 ),
        .D(\zc_count_reg[8]_i_1_n_7 ),
        .Q(I11[15]),
        .R(rst_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \zc_count_reg[8]_i_1 
       (.CI(\zc_count_reg[7]_i_1_n_0 ),
        .CO(\NLW_zc_count_reg[8]_i_1_CO_UNCONNECTED [3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\NLW_zc_count_reg[8]_i_1_O_UNCONNECTED [3:1],\zc_count_reg[8]_i_1_n_7 }),
        .S({1'b0,1'b0,1'b0,\zc_count[8]_i_2_n_0 }));
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
