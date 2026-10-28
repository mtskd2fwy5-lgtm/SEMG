// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
// Date        : Tue Oct 27 16:58:09 2026
// Host        : LAPTOP-VCCV41QO running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               D:/FPGA/sEMG-HMRS/report/resource_optimization_v15_20261027/candidate_hand_servo_pwm_synth.v
// Design      : hand_servo_pwm
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* AGE_W = "23" *) (* CHANNELS = "6" *) (* CLOCK_HZ = "25000000" *) 
(* FRAME_TICKS = "500000" *) (* FRAME_US = "20000" *) (* MAX_STEP_US = "20" *) 
(* MAX_US = "2500" *) (* MIN_US = "500" *) (* SUB_W = "5" *) 
(* TICKS_US = "25" *) (* US_W = "15" *) (* WATCHDOG_MS = "250" *) 
(* WD_TICKS = "6250000" *) 
(* NotValidForBitStream *)
module hand_servo_pwm
   (clk,
    rst_n,
    enable,
    estop,
    command_valid,
    command_us,
    pwm,
    armed,
    fault,
    current_us);
  input clk;
  input rst_n;
  input enable;
  input estop;
  input command_valid;
  input [95:0]command_us;
  output [5:0]pwm;
  output armed;
  output fault;
  output [95:0]current_us;

  wire \age[0]_i_1_n_0 ;
  wire \age[0]_i_2_n_0 ;
  wire \age[0]_i_4_n_0 ;
  wire [22:4]age_reg;
  wire \age_reg[0]_i_3_n_0 ;
  wire \age_reg[0]_i_3_n_1 ;
  wire \age_reg[0]_i_3_n_2 ;
  wire \age_reg[0]_i_3_n_3 ;
  wire \age_reg[0]_i_3_n_4 ;
  wire \age_reg[0]_i_3_n_5 ;
  wire \age_reg[0]_i_3_n_6 ;
  wire \age_reg[0]_i_3_n_7 ;
  wire \age_reg[12]_i_1_n_0 ;
  wire \age_reg[12]_i_1_n_1 ;
  wire \age_reg[12]_i_1_n_2 ;
  wire \age_reg[12]_i_1_n_3 ;
  wire \age_reg[12]_i_1_n_4 ;
  wire \age_reg[12]_i_1_n_5 ;
  wire \age_reg[12]_i_1_n_6 ;
  wire \age_reg[12]_i_1_n_7 ;
  wire \age_reg[16]_i_1_n_0 ;
  wire \age_reg[16]_i_1_n_1 ;
  wire \age_reg[16]_i_1_n_2 ;
  wire \age_reg[16]_i_1_n_3 ;
  wire \age_reg[16]_i_1_n_4 ;
  wire \age_reg[16]_i_1_n_5 ;
  wire \age_reg[16]_i_1_n_6 ;
  wire \age_reg[16]_i_1_n_7 ;
  wire \age_reg[20]_i_1_n_2 ;
  wire \age_reg[20]_i_1_n_3 ;
  wire \age_reg[20]_i_1_n_5 ;
  wire \age_reg[20]_i_1_n_6 ;
  wire \age_reg[20]_i_1_n_7 ;
  wire \age_reg[4]_i_1_n_0 ;
  wire \age_reg[4]_i_1_n_1 ;
  wire \age_reg[4]_i_1_n_2 ;
  wire \age_reg[4]_i_1_n_3 ;
  wire \age_reg[4]_i_1_n_4 ;
  wire \age_reg[4]_i_1_n_5 ;
  wire \age_reg[4]_i_1_n_6 ;
  wire \age_reg[4]_i_1_n_7 ;
  wire \age_reg[8]_i_1_n_0 ;
  wire \age_reg[8]_i_1_n_1 ;
  wire \age_reg[8]_i_1_n_2 ;
  wire \age_reg[8]_i_1_n_3 ;
  wire \age_reg[8]_i_1_n_4 ;
  wire \age_reg[8]_i_1_n_5 ;
  wire \age_reg[8]_i_1_n_6 ;
  wire \age_reg[8]_i_1_n_7 ;
  wire \age_reg_n_0_[0] ;
  wire \age_reg_n_0_[1] ;
  wire \age_reg_n_0_[2] ;
  wire \age_reg_n_0_[3] ;
  wire armed;
  wire armed6_out;
  wire armed_i_1_n_0;
  wire armed_i_2_n_0;
  wire clk;
  wire [95:0]command_us;
  wire command_valid;
  wire [95:0]current_us;
  wire \current_us[0]_i_2_n_0 ;
  wire \current_us[0]_i_4_n_0 ;
  wire \current_us[0]_i_5_n_0 ;
  wire \current_us[0]_i_6_n_0 ;
  wire \current_us[0]_i_7_n_0 ;
  wire \current_us[10]_i_2_n_0 ;
  wire \current_us[11]_i_2_n_0 ;
  wire \current_us[12]_i_3_n_0 ;
  wire \current_us[12]_i_5_n_0 ;
  wire \current_us[12]_i_6_n_0 ;
  wire \current_us[12]_i_7_n_0 ;
  wire \current_us[12]_i_8_n_0 ;
  wire \current_us[13]_i_2_n_0 ;
  wire \current_us[14]_i_2_n_0 ;
  wire \current_us[15]_i_10_n_0 ;
  wire \current_us[15]_i_11_n_0 ;
  wire \current_us[15]_i_12_n_0 ;
  wire \current_us[15]_i_13_n_0 ;
  wire \current_us[15]_i_14_n_0 ;
  wire \current_us[15]_i_15_n_0 ;
  wire \current_us[15]_i_16_n_0 ;
  wire \current_us[15]_i_18_n_0 ;
  wire \current_us[15]_i_19_n_0 ;
  wire \current_us[15]_i_1_n_0 ;
  wire \current_us[15]_i_20_n_0 ;
  wire \current_us[15]_i_21_n_0 ;
  wire \current_us[15]_i_22_n_0 ;
  wire \current_us[15]_i_23_n_0 ;
  wire \current_us[15]_i_24_n_0 ;
  wire \current_us[15]_i_25_n_0 ;
  wire \current_us[15]_i_26_n_0 ;
  wire \current_us[15]_i_28_n_0 ;
  wire \current_us[15]_i_29_n_0 ;
  wire \current_us[15]_i_30_n_0 ;
  wire \current_us[15]_i_31_n_0 ;
  wire \current_us[15]_i_32_n_0 ;
  wire \current_us[15]_i_33_n_0 ;
  wire \current_us[15]_i_35_n_0 ;
  wire \current_us[15]_i_36_n_0 ;
  wire \current_us[15]_i_37_n_0 ;
  wire \current_us[15]_i_38_n_0 ;
  wire \current_us[15]_i_39_n_0 ;
  wire \current_us[15]_i_40_n_0 ;
  wire \current_us[15]_i_41_n_0 ;
  wire \current_us[15]_i_42_n_0 ;
  wire \current_us[15]_i_43_n_0 ;
  wire \current_us[15]_i_44_n_0 ;
  wire \current_us[15]_i_45_n_0 ;
  wire \current_us[15]_i_46_n_0 ;
  wire \current_us[15]_i_47_n_0 ;
  wire \current_us[15]_i_48_n_0 ;
  wire \current_us[15]_i_49_n_0 ;
  wire \current_us[15]_i_50_n_0 ;
  wire \current_us[15]_i_52_n_0 ;
  wire \current_us[15]_i_53_n_0 ;
  wire \current_us[15]_i_54_n_0 ;
  wire \current_us[15]_i_55_n_0 ;
  wire \current_us[15]_i_5_n_0 ;
  wire \current_us[15]_i_63_n_0 ;
  wire \current_us[15]_i_64_n_0 ;
  wire \current_us[15]_i_65_n_0 ;
  wire \current_us[15]_i_66_n_0 ;
  wire \current_us[15]_i_67_n_0 ;
  wire \current_us[15]_i_68_n_0 ;
  wire \current_us[15]_i_69_n_0 ;
  wire \current_us[15]_i_70_n_0 ;
  wire \current_us[15]_i_71_n_0 ;
  wire \current_us[15]_i_72_n_0 ;
  wire \current_us[15]_i_73_n_0 ;
  wire \current_us[15]_i_74_n_0 ;
  wire \current_us[15]_i_75_n_0 ;
  wire \current_us[15]_i_76_n_0 ;
  wire \current_us[15]_i_77_n_0 ;
  wire \current_us[15]_i_78_n_0 ;
  wire \current_us[15]_i_79_n_0 ;
  wire \current_us[15]_i_7_n_0 ;
  wire \current_us[15]_i_80_n_0 ;
  wire \current_us[15]_i_81_n_0 ;
  wire \current_us[15]_i_82_n_0 ;
  wire \current_us[15]_i_83_n_0 ;
  wire \current_us[15]_i_84_n_0 ;
  wire \current_us[15]_i_85_n_0 ;
  wire \current_us[15]_i_86_n_0 ;
  wire \current_us[15]_i_87_n_0 ;
  wire \current_us[15]_i_88_n_0 ;
  wire \current_us[15]_i_89_n_0 ;
  wire \current_us[15]_i_9_n_0 ;
  wire \current_us[16]_i_2_n_0 ;
  wire \current_us[16]_i_4_n_0 ;
  wire \current_us[16]_i_5_n_0 ;
  wire \current_us[16]_i_6_n_0 ;
  wire \current_us[16]_i_7_n_0 ;
  wire \current_us[17]_i_3_n_0 ;
  wire \current_us[17]_i_4_n_0 ;
  wire \current_us[17]_i_5_n_0 ;
  wire \current_us[18]_i_2_n_0 ;
  wire \current_us[19]_i_2_n_0 ;
  wire \current_us[1]_i_3_n_0 ;
  wire \current_us[1]_i_4_n_0 ;
  wire \current_us[1]_i_5_n_0 ;
  wire \current_us[20]_i_3_n_0 ;
  wire \current_us[20]_i_4_n_0 ;
  wire \current_us[20]_i_5_n_0 ;
  wire \current_us[21]_i_2_n_0 ;
  wire \current_us[22]_i_2_n_0 ;
  wire \current_us[23]_i_2_n_0 ;
  wire \current_us[24]_i_3_n_0 ;
  wire \current_us[24]_i_5_n_0 ;
  wire \current_us[24]_i_6_n_0 ;
  wire \current_us[24]_i_7_n_0 ;
  wire \current_us[24]_i_8_n_0 ;
  wire \current_us[25]_i_2_n_0 ;
  wire \current_us[26]_i_2_n_0 ;
  wire \current_us[27]_i_2_n_0 ;
  wire \current_us[28]_i_3_n_0 ;
  wire \current_us[28]_i_5_n_0 ;
  wire \current_us[28]_i_6_n_0 ;
  wire \current_us[28]_i_7_n_0 ;
  wire \current_us[28]_i_8_n_0 ;
  wire \current_us[29]_i_2_n_0 ;
  wire \current_us[2]_i_2_n_0 ;
  wire \current_us[30]_i_2_n_0 ;
  wire \current_us[31]_i_10_n_0 ;
  wire \current_us[31]_i_11_n_0 ;
  wire \current_us[31]_i_12_n_0 ;
  wire \current_us[31]_i_13_n_0 ;
  wire \current_us[31]_i_14_n_0 ;
  wire \current_us[31]_i_15_n_0 ;
  wire \current_us[31]_i_16_n_0 ;
  wire \current_us[31]_i_18_n_0 ;
  wire \current_us[31]_i_19_n_0 ;
  wire \current_us[31]_i_1_n_0 ;
  wire \current_us[31]_i_20_n_0 ;
  wire \current_us[31]_i_21_n_0 ;
  wire \current_us[31]_i_22_n_0 ;
  wire \current_us[31]_i_23_n_0 ;
  wire \current_us[31]_i_24_n_0 ;
  wire \current_us[31]_i_25_n_0 ;
  wire \current_us[31]_i_26_n_0 ;
  wire \current_us[31]_i_28_n_0 ;
  wire \current_us[31]_i_29_n_0 ;
  wire \current_us[31]_i_30_n_0 ;
  wire \current_us[31]_i_31_n_0 ;
  wire \current_us[31]_i_32_n_0 ;
  wire \current_us[31]_i_33_n_0 ;
  wire \current_us[31]_i_35_n_0 ;
  wire \current_us[31]_i_36_n_0 ;
  wire \current_us[31]_i_37_n_0 ;
  wire \current_us[31]_i_38_n_0 ;
  wire \current_us[31]_i_39_n_0 ;
  wire \current_us[31]_i_40_n_0 ;
  wire \current_us[31]_i_41_n_0 ;
  wire \current_us[31]_i_42_n_0 ;
  wire \current_us[31]_i_43_n_0 ;
  wire \current_us[31]_i_44_n_0 ;
  wire \current_us[31]_i_45_n_0 ;
  wire \current_us[31]_i_46_n_0 ;
  wire \current_us[31]_i_47_n_0 ;
  wire \current_us[31]_i_48_n_0 ;
  wire \current_us[31]_i_49_n_0 ;
  wire \current_us[31]_i_50_n_0 ;
  wire \current_us[31]_i_52_n_0 ;
  wire \current_us[31]_i_53_n_0 ;
  wire \current_us[31]_i_54_n_0 ;
  wire \current_us[31]_i_55_n_0 ;
  wire \current_us[31]_i_5_n_0 ;
  wire \current_us[31]_i_63_n_0 ;
  wire \current_us[31]_i_64_n_0 ;
  wire \current_us[31]_i_65_n_0 ;
  wire \current_us[31]_i_66_n_0 ;
  wire \current_us[31]_i_67_n_0 ;
  wire \current_us[31]_i_68_n_0 ;
  wire \current_us[31]_i_69_n_0 ;
  wire \current_us[31]_i_70_n_0 ;
  wire \current_us[31]_i_71_n_0 ;
  wire \current_us[31]_i_72_n_0 ;
  wire \current_us[31]_i_73_n_0 ;
  wire \current_us[31]_i_74_n_0 ;
  wire \current_us[31]_i_75_n_0 ;
  wire \current_us[31]_i_76_n_0 ;
  wire \current_us[31]_i_77_n_0 ;
  wire \current_us[31]_i_78_n_0 ;
  wire \current_us[31]_i_79_n_0 ;
  wire \current_us[31]_i_7_n_0 ;
  wire \current_us[31]_i_80_n_0 ;
  wire \current_us[31]_i_81_n_0 ;
  wire \current_us[31]_i_82_n_0 ;
  wire \current_us[31]_i_83_n_0 ;
  wire \current_us[31]_i_84_n_0 ;
  wire \current_us[31]_i_85_n_0 ;
  wire \current_us[31]_i_86_n_0 ;
  wire \current_us[31]_i_87_n_0 ;
  wire \current_us[31]_i_88_n_0 ;
  wire \current_us[31]_i_89_n_0 ;
  wire \current_us[31]_i_9_n_0 ;
  wire \current_us[32]_i_2_n_0 ;
  wire \current_us[32]_i_4_n_0 ;
  wire \current_us[32]_i_5_n_0 ;
  wire \current_us[32]_i_6_n_0 ;
  wire \current_us[32]_i_7_n_0 ;
  wire \current_us[33]_i_3_n_0 ;
  wire \current_us[33]_i_4_n_0 ;
  wire \current_us[33]_i_5_n_0 ;
  wire \current_us[34]_i_2_n_0 ;
  wire \current_us[35]_i_2_n_0 ;
  wire \current_us[36]_i_3_n_0 ;
  wire \current_us[36]_i_4_n_0 ;
  wire \current_us[36]_i_5_n_0 ;
  wire \current_us[37]_i_2_n_0 ;
  wire \current_us[38]_i_2_n_0 ;
  wire \current_us[39]_i_2_n_0 ;
  wire \current_us[3]_i_2_n_0 ;
  wire \current_us[40]_i_3_n_0 ;
  wire \current_us[40]_i_5_n_0 ;
  wire \current_us[40]_i_6_n_0 ;
  wire \current_us[40]_i_7_n_0 ;
  wire \current_us[40]_i_8_n_0 ;
  wire \current_us[41]_i_2_n_0 ;
  wire \current_us[42]_i_2_n_0 ;
  wire \current_us[43]_i_2_n_0 ;
  wire \current_us[44]_i_3_n_0 ;
  wire \current_us[44]_i_5_n_0 ;
  wire \current_us[44]_i_6_n_0 ;
  wire \current_us[44]_i_7_n_0 ;
  wire \current_us[44]_i_8_n_0 ;
  wire \current_us[45]_i_2_n_0 ;
  wire \current_us[46]_i_2_n_0 ;
  wire \current_us[47]_i_10_n_0 ;
  wire \current_us[47]_i_11_n_0 ;
  wire \current_us[47]_i_12_n_0 ;
  wire \current_us[47]_i_13_n_0 ;
  wire \current_us[47]_i_14_n_0 ;
  wire \current_us[47]_i_15_n_0 ;
  wire \current_us[47]_i_16_n_0 ;
  wire \current_us[47]_i_18_n_0 ;
  wire \current_us[47]_i_19_n_0 ;
  wire \current_us[47]_i_1_n_0 ;
  wire \current_us[47]_i_20_n_0 ;
  wire \current_us[47]_i_21_n_0 ;
  wire \current_us[47]_i_22_n_0 ;
  wire \current_us[47]_i_23_n_0 ;
  wire \current_us[47]_i_24_n_0 ;
  wire \current_us[47]_i_25_n_0 ;
  wire \current_us[47]_i_26_n_0 ;
  wire \current_us[47]_i_28_n_0 ;
  wire \current_us[47]_i_29_n_0 ;
  wire \current_us[47]_i_30_n_0 ;
  wire \current_us[47]_i_31_n_0 ;
  wire \current_us[47]_i_32_n_0 ;
  wire \current_us[47]_i_33_n_0 ;
  wire \current_us[47]_i_35_n_0 ;
  wire \current_us[47]_i_36_n_0 ;
  wire \current_us[47]_i_37_n_0 ;
  wire \current_us[47]_i_38_n_0 ;
  wire \current_us[47]_i_39_n_0 ;
  wire \current_us[47]_i_40_n_0 ;
  wire \current_us[47]_i_41_n_0 ;
  wire \current_us[47]_i_42_n_0 ;
  wire \current_us[47]_i_43_n_0 ;
  wire \current_us[47]_i_44_n_0 ;
  wire \current_us[47]_i_45_n_0 ;
  wire \current_us[47]_i_46_n_0 ;
  wire \current_us[47]_i_47_n_0 ;
  wire \current_us[47]_i_48_n_0 ;
  wire \current_us[47]_i_49_n_0 ;
  wire \current_us[47]_i_50_n_0 ;
  wire \current_us[47]_i_52_n_0 ;
  wire \current_us[47]_i_53_n_0 ;
  wire \current_us[47]_i_54_n_0 ;
  wire \current_us[47]_i_55_n_0 ;
  wire \current_us[47]_i_5_n_0 ;
  wire \current_us[47]_i_63_n_0 ;
  wire \current_us[47]_i_64_n_0 ;
  wire \current_us[47]_i_65_n_0 ;
  wire \current_us[47]_i_66_n_0 ;
  wire \current_us[47]_i_67_n_0 ;
  wire \current_us[47]_i_68_n_0 ;
  wire \current_us[47]_i_69_n_0 ;
  wire \current_us[47]_i_70_n_0 ;
  wire \current_us[47]_i_71_n_0 ;
  wire \current_us[47]_i_72_n_0 ;
  wire \current_us[47]_i_73_n_0 ;
  wire \current_us[47]_i_74_n_0 ;
  wire \current_us[47]_i_75_n_0 ;
  wire \current_us[47]_i_76_n_0 ;
  wire \current_us[47]_i_77_n_0 ;
  wire \current_us[47]_i_78_n_0 ;
  wire \current_us[47]_i_79_n_0 ;
  wire \current_us[47]_i_7_n_0 ;
  wire \current_us[47]_i_80_n_0 ;
  wire \current_us[47]_i_81_n_0 ;
  wire \current_us[47]_i_82_n_0 ;
  wire \current_us[47]_i_83_n_0 ;
  wire \current_us[47]_i_84_n_0 ;
  wire \current_us[47]_i_85_n_0 ;
  wire \current_us[47]_i_86_n_0 ;
  wire \current_us[47]_i_87_n_0 ;
  wire \current_us[47]_i_88_n_0 ;
  wire \current_us[47]_i_89_n_0 ;
  wire \current_us[47]_i_9_n_0 ;
  wire \current_us[48]_i_2_n_0 ;
  wire \current_us[48]_i_4_n_0 ;
  wire \current_us[48]_i_5_n_0 ;
  wire \current_us[48]_i_6_n_0 ;
  wire \current_us[48]_i_7_n_0 ;
  wire \current_us[49]_i_3_n_0 ;
  wire \current_us[49]_i_4_n_0 ;
  wire \current_us[49]_i_5_n_0 ;
  wire \current_us[4]_i_3_n_0 ;
  wire \current_us[4]_i_4_n_0 ;
  wire \current_us[4]_i_5_n_0 ;
  wire \current_us[50]_i_2_n_0 ;
  wire \current_us[51]_i_2_n_0 ;
  wire \current_us[52]_i_3_n_0 ;
  wire \current_us[52]_i_4_n_0 ;
  wire \current_us[52]_i_5_n_0 ;
  wire \current_us[53]_i_2_n_0 ;
  wire \current_us[54]_i_2_n_0 ;
  wire \current_us[55]_i_2_n_0 ;
  wire \current_us[56]_i_3_n_0 ;
  wire \current_us[56]_i_5_n_0 ;
  wire \current_us[56]_i_6_n_0 ;
  wire \current_us[56]_i_7_n_0 ;
  wire \current_us[56]_i_8_n_0 ;
  wire \current_us[57]_i_2_n_0 ;
  wire \current_us[58]_i_2_n_0 ;
  wire \current_us[59]_i_2_n_0 ;
  wire \current_us[5]_i_2_n_0 ;
  wire \current_us[60]_i_3_n_0 ;
  wire \current_us[60]_i_5_n_0 ;
  wire \current_us[60]_i_6_n_0 ;
  wire \current_us[60]_i_7_n_0 ;
  wire \current_us[60]_i_8_n_0 ;
  wire \current_us[61]_i_2_n_0 ;
  wire \current_us[62]_i_2_n_0 ;
  wire \current_us[63]_i_10_n_0 ;
  wire \current_us[63]_i_11_n_0 ;
  wire \current_us[63]_i_12_n_0 ;
  wire \current_us[63]_i_13_n_0 ;
  wire \current_us[63]_i_14_n_0 ;
  wire \current_us[63]_i_15_n_0 ;
  wire \current_us[63]_i_16_n_0 ;
  wire \current_us[63]_i_18_n_0 ;
  wire \current_us[63]_i_19_n_0 ;
  wire \current_us[63]_i_1_n_0 ;
  wire \current_us[63]_i_20_n_0 ;
  wire \current_us[63]_i_21_n_0 ;
  wire \current_us[63]_i_22_n_0 ;
  wire \current_us[63]_i_23_n_0 ;
  wire \current_us[63]_i_24_n_0 ;
  wire \current_us[63]_i_25_n_0 ;
  wire \current_us[63]_i_26_n_0 ;
  wire \current_us[63]_i_28_n_0 ;
  wire \current_us[63]_i_29_n_0 ;
  wire \current_us[63]_i_30_n_0 ;
  wire \current_us[63]_i_31_n_0 ;
  wire \current_us[63]_i_32_n_0 ;
  wire \current_us[63]_i_33_n_0 ;
  wire \current_us[63]_i_35_n_0 ;
  wire \current_us[63]_i_36_n_0 ;
  wire \current_us[63]_i_37_n_0 ;
  wire \current_us[63]_i_38_n_0 ;
  wire \current_us[63]_i_39_n_0 ;
  wire \current_us[63]_i_40_n_0 ;
  wire \current_us[63]_i_41_n_0 ;
  wire \current_us[63]_i_42_n_0 ;
  wire \current_us[63]_i_43_n_0 ;
  wire \current_us[63]_i_44_n_0 ;
  wire \current_us[63]_i_45_n_0 ;
  wire \current_us[63]_i_46_n_0 ;
  wire \current_us[63]_i_47_n_0 ;
  wire \current_us[63]_i_48_n_0 ;
  wire \current_us[63]_i_49_n_0 ;
  wire \current_us[63]_i_50_n_0 ;
  wire \current_us[63]_i_52_n_0 ;
  wire \current_us[63]_i_53_n_0 ;
  wire \current_us[63]_i_54_n_0 ;
  wire \current_us[63]_i_55_n_0 ;
  wire \current_us[63]_i_5_n_0 ;
  wire \current_us[63]_i_63_n_0 ;
  wire \current_us[63]_i_64_n_0 ;
  wire \current_us[63]_i_65_n_0 ;
  wire \current_us[63]_i_66_n_0 ;
  wire \current_us[63]_i_67_n_0 ;
  wire \current_us[63]_i_68_n_0 ;
  wire \current_us[63]_i_69_n_0 ;
  wire \current_us[63]_i_70_n_0 ;
  wire \current_us[63]_i_71_n_0 ;
  wire \current_us[63]_i_72_n_0 ;
  wire \current_us[63]_i_73_n_0 ;
  wire \current_us[63]_i_74_n_0 ;
  wire \current_us[63]_i_75_n_0 ;
  wire \current_us[63]_i_76_n_0 ;
  wire \current_us[63]_i_77_n_0 ;
  wire \current_us[63]_i_78_n_0 ;
  wire \current_us[63]_i_79_n_0 ;
  wire \current_us[63]_i_7_n_0 ;
  wire \current_us[63]_i_80_n_0 ;
  wire \current_us[63]_i_81_n_0 ;
  wire \current_us[63]_i_82_n_0 ;
  wire \current_us[63]_i_83_n_0 ;
  wire \current_us[63]_i_84_n_0 ;
  wire \current_us[63]_i_85_n_0 ;
  wire \current_us[63]_i_86_n_0 ;
  wire \current_us[63]_i_87_n_0 ;
  wire \current_us[63]_i_88_n_0 ;
  wire \current_us[63]_i_89_n_0 ;
  wire \current_us[63]_i_9_n_0 ;
  wire \current_us[64]_i_2_n_0 ;
  wire \current_us[64]_i_4_n_0 ;
  wire \current_us[64]_i_5_n_0 ;
  wire \current_us[64]_i_6_n_0 ;
  wire \current_us[64]_i_7_n_0 ;
  wire \current_us[65]_i_3_n_0 ;
  wire \current_us[65]_i_4_n_0 ;
  wire \current_us[65]_i_5_n_0 ;
  wire \current_us[66]_i_2_n_0 ;
  wire \current_us[67]_i_2_n_0 ;
  wire \current_us[68]_i_3_n_0 ;
  wire \current_us[68]_i_4_n_0 ;
  wire \current_us[68]_i_5_n_0 ;
  wire \current_us[69]_i_2_n_0 ;
  wire \current_us[6]_i_2_n_0 ;
  wire \current_us[70]_i_2_n_0 ;
  wire \current_us[71]_i_2_n_0 ;
  wire \current_us[72]_i_3_n_0 ;
  wire \current_us[72]_i_5_n_0 ;
  wire \current_us[72]_i_6_n_0 ;
  wire \current_us[72]_i_7_n_0 ;
  wire \current_us[72]_i_8_n_0 ;
  wire \current_us[73]_i_2_n_0 ;
  wire \current_us[74]_i_2_n_0 ;
  wire \current_us[75]_i_2_n_0 ;
  wire \current_us[76]_i_3_n_0 ;
  wire \current_us[76]_i_5_n_0 ;
  wire \current_us[76]_i_6_n_0 ;
  wire \current_us[76]_i_7_n_0 ;
  wire \current_us[76]_i_8_n_0 ;
  wire \current_us[77]_i_2_n_0 ;
  wire \current_us[78]_i_2_n_0 ;
  wire \current_us[79]_i_10_n_0 ;
  wire \current_us[79]_i_11_n_0 ;
  wire \current_us[79]_i_12_n_0 ;
  wire \current_us[79]_i_13_n_0 ;
  wire \current_us[79]_i_14_n_0 ;
  wire \current_us[79]_i_15_n_0 ;
  wire \current_us[79]_i_16_n_0 ;
  wire \current_us[79]_i_18_n_0 ;
  wire \current_us[79]_i_19_n_0 ;
  wire \current_us[79]_i_1_n_0 ;
  wire \current_us[79]_i_20_n_0 ;
  wire \current_us[79]_i_21_n_0 ;
  wire \current_us[79]_i_22_n_0 ;
  wire \current_us[79]_i_23_n_0 ;
  wire \current_us[79]_i_24_n_0 ;
  wire \current_us[79]_i_25_n_0 ;
  wire \current_us[79]_i_26_n_0 ;
  wire \current_us[79]_i_28_n_0 ;
  wire \current_us[79]_i_29_n_0 ;
  wire \current_us[79]_i_30_n_0 ;
  wire \current_us[79]_i_31_n_0 ;
  wire \current_us[79]_i_32_n_0 ;
  wire \current_us[79]_i_33_n_0 ;
  wire \current_us[79]_i_35_n_0 ;
  wire \current_us[79]_i_36_n_0 ;
  wire \current_us[79]_i_37_n_0 ;
  wire \current_us[79]_i_38_n_0 ;
  wire \current_us[79]_i_39_n_0 ;
  wire \current_us[79]_i_40_n_0 ;
  wire \current_us[79]_i_41_n_0 ;
  wire \current_us[79]_i_42_n_0 ;
  wire \current_us[79]_i_43_n_0 ;
  wire \current_us[79]_i_44_n_0 ;
  wire \current_us[79]_i_45_n_0 ;
  wire \current_us[79]_i_46_n_0 ;
  wire \current_us[79]_i_47_n_0 ;
  wire \current_us[79]_i_48_n_0 ;
  wire \current_us[79]_i_49_n_0 ;
  wire \current_us[79]_i_50_n_0 ;
  wire \current_us[79]_i_52_n_0 ;
  wire \current_us[79]_i_53_n_0 ;
  wire \current_us[79]_i_54_n_0 ;
  wire \current_us[79]_i_55_n_0 ;
  wire \current_us[79]_i_5_n_0 ;
  wire \current_us[79]_i_63_n_0 ;
  wire \current_us[79]_i_64_n_0 ;
  wire \current_us[79]_i_65_n_0 ;
  wire \current_us[79]_i_66_n_0 ;
  wire \current_us[79]_i_67_n_0 ;
  wire \current_us[79]_i_68_n_0 ;
  wire \current_us[79]_i_69_n_0 ;
  wire \current_us[79]_i_70_n_0 ;
  wire \current_us[79]_i_71_n_0 ;
  wire \current_us[79]_i_72_n_0 ;
  wire \current_us[79]_i_73_n_0 ;
  wire \current_us[79]_i_74_n_0 ;
  wire \current_us[79]_i_75_n_0 ;
  wire \current_us[79]_i_76_n_0 ;
  wire \current_us[79]_i_77_n_0 ;
  wire \current_us[79]_i_78_n_0 ;
  wire \current_us[79]_i_79_n_0 ;
  wire \current_us[79]_i_7_n_0 ;
  wire \current_us[79]_i_80_n_0 ;
  wire \current_us[79]_i_81_n_0 ;
  wire \current_us[79]_i_82_n_0 ;
  wire \current_us[79]_i_83_n_0 ;
  wire \current_us[79]_i_84_n_0 ;
  wire \current_us[79]_i_85_n_0 ;
  wire \current_us[79]_i_86_n_0 ;
  wire \current_us[79]_i_87_n_0 ;
  wire \current_us[79]_i_88_n_0 ;
  wire \current_us[79]_i_89_n_0 ;
  wire \current_us[79]_i_9_n_0 ;
  wire \current_us[7]_i_2_n_0 ;
  wire \current_us[80]_i_2_n_0 ;
  wire \current_us[80]_i_4_n_0 ;
  wire \current_us[80]_i_5_n_0 ;
  wire \current_us[80]_i_6_n_0 ;
  wire \current_us[80]_i_7_n_0 ;
  wire \current_us[81]_i_3_n_0 ;
  wire \current_us[81]_i_4_n_0 ;
  wire \current_us[81]_i_5_n_0 ;
  wire \current_us[82]_i_2_n_0 ;
  wire \current_us[83]_i_2_n_0 ;
  wire \current_us[84]_i_3_n_0 ;
  wire \current_us[84]_i_4_n_0 ;
  wire \current_us[84]_i_5_n_0 ;
  wire \current_us[85]_i_2_n_0 ;
  wire \current_us[86]_i_2_n_0 ;
  wire \current_us[87]_i_2_n_0 ;
  wire \current_us[88]_i_3_n_0 ;
  wire \current_us[88]_i_5_n_0 ;
  wire \current_us[88]_i_6_n_0 ;
  wire \current_us[88]_i_7_n_0 ;
  wire \current_us[88]_i_8_n_0 ;
  wire \current_us[89]_i_2_n_0 ;
  wire \current_us[8]_i_3_n_0 ;
  wire \current_us[8]_i_5_n_0 ;
  wire \current_us[8]_i_6_n_0 ;
  wire \current_us[8]_i_7_n_0 ;
  wire \current_us[8]_i_8_n_0 ;
  wire \current_us[90]_i_2_n_0 ;
  wire \current_us[91]_i_2_n_0 ;
  wire \current_us[92]_i_3_n_0 ;
  wire \current_us[92]_i_5_n_0 ;
  wire \current_us[92]_i_6_n_0 ;
  wire \current_us[92]_i_7_n_0 ;
  wire \current_us[92]_i_8_n_0 ;
  wire \current_us[93]_i_2_n_0 ;
  wire \current_us[94]_i_2_n_0 ;
  wire \current_us[95]_i_11_n_0 ;
  wire \current_us[95]_i_12_n_0 ;
  wire \current_us[95]_i_13_n_0 ;
  wire \current_us[95]_i_14_n_0 ;
  wire \current_us[95]_i_15_n_0 ;
  wire \current_us[95]_i_16_n_0 ;
  wire \current_us[95]_i_17_n_0 ;
  wire \current_us[95]_i_18_n_0 ;
  wire \current_us[95]_i_20_n_0 ;
  wire \current_us[95]_i_21_n_0 ;
  wire \current_us[95]_i_22_n_0 ;
  wire \current_us[95]_i_23_n_0 ;
  wire \current_us[95]_i_24_n_0 ;
  wire \current_us[95]_i_25_n_0 ;
  wire \current_us[95]_i_26_n_0 ;
  wire \current_us[95]_i_27_n_0 ;
  wire \current_us[95]_i_28_n_0 ;
  wire \current_us[95]_i_2_n_0 ;
  wire \current_us[95]_i_30_n_0 ;
  wire \current_us[95]_i_31_n_0 ;
  wire \current_us[95]_i_32_n_0 ;
  wire \current_us[95]_i_33_n_0 ;
  wire \current_us[95]_i_34_n_0 ;
  wire \current_us[95]_i_35_n_0 ;
  wire \current_us[95]_i_37_n_0 ;
  wire \current_us[95]_i_38_n_0 ;
  wire \current_us[95]_i_39_n_0 ;
  wire \current_us[95]_i_40_n_0 ;
  wire \current_us[95]_i_41_n_0 ;
  wire \current_us[95]_i_42_n_0 ;
  wire \current_us[95]_i_43_n_0 ;
  wire \current_us[95]_i_44_n_0 ;
  wire \current_us[95]_i_45_n_0 ;
  wire \current_us[95]_i_46_n_0 ;
  wire \current_us[95]_i_47_n_0 ;
  wire \current_us[95]_i_48_n_0 ;
  wire \current_us[95]_i_49_n_0 ;
  wire \current_us[95]_i_4_n_0 ;
  wire \current_us[95]_i_50_n_0 ;
  wire \current_us[95]_i_51_n_0 ;
  wire \current_us[95]_i_52_n_0 ;
  wire \current_us[95]_i_54_n_0 ;
  wire \current_us[95]_i_55_n_0 ;
  wire \current_us[95]_i_56_n_0 ;
  wire \current_us[95]_i_57_n_0 ;
  wire \current_us[95]_i_65_n_0 ;
  wire \current_us[95]_i_66_n_0 ;
  wire \current_us[95]_i_67_n_0 ;
  wire \current_us[95]_i_68_n_0 ;
  wire \current_us[95]_i_69_n_0 ;
  wire \current_us[95]_i_70_n_0 ;
  wire \current_us[95]_i_71_n_0 ;
  wire \current_us[95]_i_72_n_0 ;
  wire \current_us[95]_i_73_n_0 ;
  wire \current_us[95]_i_74_n_0 ;
  wire \current_us[95]_i_75_n_0 ;
  wire \current_us[95]_i_76_n_0 ;
  wire \current_us[95]_i_77_n_0 ;
  wire \current_us[95]_i_78_n_0 ;
  wire \current_us[95]_i_79_n_0 ;
  wire \current_us[95]_i_7_n_0 ;
  wire \current_us[95]_i_80_n_0 ;
  wire \current_us[95]_i_81_n_0 ;
  wire \current_us[95]_i_82_n_0 ;
  wire \current_us[95]_i_83_n_0 ;
  wire \current_us[95]_i_84_n_0 ;
  wire \current_us[95]_i_85_n_0 ;
  wire \current_us[95]_i_86_n_0 ;
  wire \current_us[95]_i_87_n_0 ;
  wire \current_us[95]_i_88_n_0 ;
  wire \current_us[95]_i_89_n_0 ;
  wire \current_us[95]_i_90_n_0 ;
  wire \current_us[95]_i_91_n_0 ;
  wire \current_us[95]_i_9_n_0 ;
  wire \current_us[9]_i_2_n_0 ;
  wire \current_us_reg[0]_i_3_n_0 ;
  wire \current_us_reg[0]_i_3_n_1 ;
  wire \current_us_reg[0]_i_3_n_2 ;
  wire \current_us_reg[0]_i_3_n_3 ;
  wire \current_us_reg[0]_i_3_n_4 ;
  wire \current_us_reg[0]_i_3_n_5 ;
  wire \current_us_reg[0]_i_3_n_6 ;
  wire \current_us_reg[0]_i_3_n_7 ;
  wire \current_us_reg[12]_i_2_n_0 ;
  wire \current_us_reg[12]_i_2_n_1 ;
  wire \current_us_reg[12]_i_2_n_2 ;
  wire \current_us_reg[12]_i_2_n_3 ;
  wire \current_us_reg[12]_i_4_n_0 ;
  wire \current_us_reg[12]_i_4_n_1 ;
  wire \current_us_reg[12]_i_4_n_2 ;
  wire \current_us_reg[12]_i_4_n_3 ;
  wire \current_us_reg[15]_i_17_n_0 ;
  wire \current_us_reg[15]_i_17_n_1 ;
  wire \current_us_reg[15]_i_17_n_2 ;
  wire \current_us_reg[15]_i_17_n_3 ;
  wire \current_us_reg[15]_i_27_n_0 ;
  wire \current_us_reg[15]_i_27_n_1 ;
  wire \current_us_reg[15]_i_27_n_2 ;
  wire \current_us_reg[15]_i_27_n_3 ;
  wire \current_us_reg[15]_i_27_n_4 ;
  wire \current_us_reg[15]_i_27_n_5 ;
  wire \current_us_reg[15]_i_27_n_6 ;
  wire \current_us_reg[15]_i_27_n_7 ;
  wire \current_us_reg[15]_i_34_n_2 ;
  wire \current_us_reg[15]_i_34_n_3 ;
  wire \current_us_reg[15]_i_3_n_1 ;
  wire \current_us_reg[15]_i_3_n_2 ;
  wire \current_us_reg[15]_i_3_n_3 ;
  wire \current_us_reg[15]_i_4_n_1 ;
  wire \current_us_reg[15]_i_4_n_2 ;
  wire \current_us_reg[15]_i_4_n_3 ;
  wire \current_us_reg[15]_i_51_n_0 ;
  wire \current_us_reg[15]_i_51_n_1 ;
  wire \current_us_reg[15]_i_51_n_2 ;
  wire \current_us_reg[15]_i_51_n_3 ;
  wire \current_us_reg[15]_i_51_n_4 ;
  wire \current_us_reg[15]_i_51_n_5 ;
  wire \current_us_reg[15]_i_51_n_6 ;
  wire \current_us_reg[15]_i_51_n_7 ;
  wire \current_us_reg[15]_i_56_n_3 ;
  wire \current_us_reg[15]_i_57_n_0 ;
  wire \current_us_reg[15]_i_57_n_1 ;
  wire \current_us_reg[15]_i_57_n_2 ;
  wire \current_us_reg[15]_i_57_n_3 ;
  wire \current_us_reg[15]_i_57_n_4 ;
  wire \current_us_reg[15]_i_57_n_5 ;
  wire \current_us_reg[15]_i_57_n_6 ;
  wire \current_us_reg[15]_i_57_n_7 ;
  wire \current_us_reg[15]_i_58_n_0 ;
  wire \current_us_reg[15]_i_58_n_1 ;
  wire \current_us_reg[15]_i_58_n_2 ;
  wire \current_us_reg[15]_i_58_n_3 ;
  wire \current_us_reg[15]_i_58_n_4 ;
  wire \current_us_reg[15]_i_58_n_5 ;
  wire \current_us_reg[15]_i_58_n_6 ;
  wire \current_us_reg[15]_i_58_n_7 ;
  wire \current_us_reg[15]_i_59_n_0 ;
  wire \current_us_reg[15]_i_59_n_1 ;
  wire \current_us_reg[15]_i_59_n_2 ;
  wire \current_us_reg[15]_i_59_n_3 ;
  wire \current_us_reg[15]_i_59_n_4 ;
  wire \current_us_reg[15]_i_59_n_5 ;
  wire \current_us_reg[15]_i_59_n_6 ;
  wire \current_us_reg[15]_i_59_n_7 ;
  wire \current_us_reg[15]_i_60_n_3 ;
  wire \current_us_reg[15]_i_61_n_0 ;
  wire \current_us_reg[15]_i_61_n_1 ;
  wire \current_us_reg[15]_i_61_n_2 ;
  wire \current_us_reg[15]_i_61_n_3 ;
  wire \current_us_reg[15]_i_61_n_4 ;
  wire \current_us_reg[15]_i_61_n_5 ;
  wire \current_us_reg[15]_i_61_n_6 ;
  wire \current_us_reg[15]_i_61_n_7 ;
  wire \current_us_reg[15]_i_62_n_0 ;
  wire \current_us_reg[15]_i_62_n_1 ;
  wire \current_us_reg[15]_i_62_n_2 ;
  wire \current_us_reg[15]_i_62_n_3 ;
  wire \current_us_reg[15]_i_62_n_4 ;
  wire \current_us_reg[15]_i_62_n_5 ;
  wire \current_us_reg[15]_i_62_n_6 ;
  wire \current_us_reg[15]_i_62_n_7 ;
  wire \current_us_reg[15]_i_6_n_2 ;
  wire \current_us_reg[15]_i_6_n_3 ;
  wire \current_us_reg[15]_i_8_n_0 ;
  wire \current_us_reg[15]_i_8_n_1 ;
  wire \current_us_reg[15]_i_8_n_2 ;
  wire \current_us_reg[15]_i_8_n_3 ;
  wire \current_us_reg[16]_i_3_n_0 ;
  wire \current_us_reg[16]_i_3_n_1 ;
  wire \current_us_reg[16]_i_3_n_2 ;
  wire \current_us_reg[16]_i_3_n_3 ;
  wire \current_us_reg[16]_i_3_n_4 ;
  wire \current_us_reg[16]_i_3_n_5 ;
  wire \current_us_reg[16]_i_3_n_6 ;
  wire \current_us_reg[16]_i_3_n_7 ;
  wire \current_us_reg[17]_i_2_n_0 ;
  wire \current_us_reg[17]_i_2_n_1 ;
  wire \current_us_reg[17]_i_2_n_2 ;
  wire \current_us_reg[17]_i_2_n_3 ;
  wire \current_us_reg[1]_i_2_n_0 ;
  wire \current_us_reg[1]_i_2_n_1 ;
  wire \current_us_reg[1]_i_2_n_2 ;
  wire \current_us_reg[1]_i_2_n_3 ;
  wire \current_us_reg[20]_i_2_n_0 ;
  wire \current_us_reg[20]_i_2_n_1 ;
  wire \current_us_reg[20]_i_2_n_2 ;
  wire \current_us_reg[20]_i_2_n_3 ;
  wire \current_us_reg[24]_i_2_n_0 ;
  wire \current_us_reg[24]_i_2_n_1 ;
  wire \current_us_reg[24]_i_2_n_2 ;
  wire \current_us_reg[24]_i_2_n_3 ;
  wire \current_us_reg[24]_i_4_n_0 ;
  wire \current_us_reg[24]_i_4_n_1 ;
  wire \current_us_reg[24]_i_4_n_2 ;
  wire \current_us_reg[24]_i_4_n_3 ;
  wire \current_us_reg[28]_i_2_n_0 ;
  wire \current_us_reg[28]_i_2_n_1 ;
  wire \current_us_reg[28]_i_2_n_2 ;
  wire \current_us_reg[28]_i_2_n_3 ;
  wire \current_us_reg[28]_i_4_n_0 ;
  wire \current_us_reg[28]_i_4_n_1 ;
  wire \current_us_reg[28]_i_4_n_2 ;
  wire \current_us_reg[28]_i_4_n_3 ;
  wire \current_us_reg[31]_i_17_n_0 ;
  wire \current_us_reg[31]_i_17_n_1 ;
  wire \current_us_reg[31]_i_17_n_2 ;
  wire \current_us_reg[31]_i_17_n_3 ;
  wire \current_us_reg[31]_i_27_n_0 ;
  wire \current_us_reg[31]_i_27_n_1 ;
  wire \current_us_reg[31]_i_27_n_2 ;
  wire \current_us_reg[31]_i_27_n_3 ;
  wire \current_us_reg[31]_i_27_n_4 ;
  wire \current_us_reg[31]_i_27_n_5 ;
  wire \current_us_reg[31]_i_27_n_6 ;
  wire \current_us_reg[31]_i_27_n_7 ;
  wire \current_us_reg[31]_i_34_n_2 ;
  wire \current_us_reg[31]_i_34_n_3 ;
  wire \current_us_reg[31]_i_3_n_1 ;
  wire \current_us_reg[31]_i_3_n_2 ;
  wire \current_us_reg[31]_i_3_n_3 ;
  wire \current_us_reg[31]_i_4_n_0 ;
  wire \current_us_reg[31]_i_4_n_1 ;
  wire \current_us_reg[31]_i_4_n_2 ;
  wire \current_us_reg[31]_i_4_n_3 ;
  wire \current_us_reg[31]_i_51_n_0 ;
  wire \current_us_reg[31]_i_51_n_1 ;
  wire \current_us_reg[31]_i_51_n_2 ;
  wire \current_us_reg[31]_i_51_n_3 ;
  wire \current_us_reg[31]_i_51_n_4 ;
  wire \current_us_reg[31]_i_51_n_5 ;
  wire \current_us_reg[31]_i_51_n_6 ;
  wire \current_us_reg[31]_i_51_n_7 ;
  wire \current_us_reg[31]_i_56_n_3 ;
  wire \current_us_reg[31]_i_57_n_0 ;
  wire \current_us_reg[31]_i_57_n_1 ;
  wire \current_us_reg[31]_i_57_n_2 ;
  wire \current_us_reg[31]_i_57_n_3 ;
  wire \current_us_reg[31]_i_57_n_4 ;
  wire \current_us_reg[31]_i_57_n_5 ;
  wire \current_us_reg[31]_i_57_n_6 ;
  wire \current_us_reg[31]_i_57_n_7 ;
  wire \current_us_reg[31]_i_58_n_0 ;
  wire \current_us_reg[31]_i_58_n_1 ;
  wire \current_us_reg[31]_i_58_n_2 ;
  wire \current_us_reg[31]_i_58_n_3 ;
  wire \current_us_reg[31]_i_58_n_4 ;
  wire \current_us_reg[31]_i_58_n_5 ;
  wire \current_us_reg[31]_i_58_n_6 ;
  wire \current_us_reg[31]_i_58_n_7 ;
  wire \current_us_reg[31]_i_59_n_0 ;
  wire \current_us_reg[31]_i_59_n_1 ;
  wire \current_us_reg[31]_i_59_n_2 ;
  wire \current_us_reg[31]_i_59_n_3 ;
  wire \current_us_reg[31]_i_59_n_4 ;
  wire \current_us_reg[31]_i_59_n_5 ;
  wire \current_us_reg[31]_i_59_n_6 ;
  wire \current_us_reg[31]_i_59_n_7 ;
  wire \current_us_reg[31]_i_60_n_3 ;
  wire \current_us_reg[31]_i_61_n_0 ;
  wire \current_us_reg[31]_i_61_n_1 ;
  wire \current_us_reg[31]_i_61_n_2 ;
  wire \current_us_reg[31]_i_61_n_3 ;
  wire \current_us_reg[31]_i_61_n_4 ;
  wire \current_us_reg[31]_i_61_n_5 ;
  wire \current_us_reg[31]_i_61_n_6 ;
  wire \current_us_reg[31]_i_61_n_7 ;
  wire \current_us_reg[31]_i_62_n_0 ;
  wire \current_us_reg[31]_i_62_n_1 ;
  wire \current_us_reg[31]_i_62_n_2 ;
  wire \current_us_reg[31]_i_62_n_3 ;
  wire \current_us_reg[31]_i_62_n_4 ;
  wire \current_us_reg[31]_i_62_n_5 ;
  wire \current_us_reg[31]_i_62_n_6 ;
  wire \current_us_reg[31]_i_62_n_7 ;
  wire \current_us_reg[31]_i_6_n_2 ;
  wire \current_us_reg[31]_i_6_n_3 ;
  wire \current_us_reg[31]_i_8_n_0 ;
  wire \current_us_reg[31]_i_8_n_1 ;
  wire \current_us_reg[31]_i_8_n_2 ;
  wire \current_us_reg[31]_i_8_n_3 ;
  wire \current_us_reg[32]_i_3_n_0 ;
  wire \current_us_reg[32]_i_3_n_1 ;
  wire \current_us_reg[32]_i_3_n_2 ;
  wire \current_us_reg[32]_i_3_n_3 ;
  wire \current_us_reg[32]_i_3_n_4 ;
  wire \current_us_reg[32]_i_3_n_5 ;
  wire \current_us_reg[32]_i_3_n_6 ;
  wire \current_us_reg[32]_i_3_n_7 ;
  wire \current_us_reg[33]_i_2_n_0 ;
  wire \current_us_reg[33]_i_2_n_1 ;
  wire \current_us_reg[33]_i_2_n_2 ;
  wire \current_us_reg[33]_i_2_n_3 ;
  wire \current_us_reg[36]_i_2_n_0 ;
  wire \current_us_reg[36]_i_2_n_1 ;
  wire \current_us_reg[36]_i_2_n_2 ;
  wire \current_us_reg[36]_i_2_n_3 ;
  wire \current_us_reg[40]_i_2_n_0 ;
  wire \current_us_reg[40]_i_2_n_1 ;
  wire \current_us_reg[40]_i_2_n_2 ;
  wire \current_us_reg[40]_i_2_n_3 ;
  wire \current_us_reg[40]_i_4_n_0 ;
  wire \current_us_reg[40]_i_4_n_1 ;
  wire \current_us_reg[40]_i_4_n_2 ;
  wire \current_us_reg[40]_i_4_n_3 ;
  wire \current_us_reg[44]_i_2_n_0 ;
  wire \current_us_reg[44]_i_2_n_1 ;
  wire \current_us_reg[44]_i_2_n_2 ;
  wire \current_us_reg[44]_i_2_n_3 ;
  wire \current_us_reg[44]_i_4_n_0 ;
  wire \current_us_reg[44]_i_4_n_1 ;
  wire \current_us_reg[44]_i_4_n_2 ;
  wire \current_us_reg[44]_i_4_n_3 ;
  wire \current_us_reg[47]_i_17_n_0 ;
  wire \current_us_reg[47]_i_17_n_1 ;
  wire \current_us_reg[47]_i_17_n_2 ;
  wire \current_us_reg[47]_i_17_n_3 ;
  wire \current_us_reg[47]_i_27_n_0 ;
  wire \current_us_reg[47]_i_27_n_1 ;
  wire \current_us_reg[47]_i_27_n_2 ;
  wire \current_us_reg[47]_i_27_n_3 ;
  wire \current_us_reg[47]_i_27_n_4 ;
  wire \current_us_reg[47]_i_27_n_5 ;
  wire \current_us_reg[47]_i_27_n_6 ;
  wire \current_us_reg[47]_i_27_n_7 ;
  wire \current_us_reg[47]_i_34_n_2 ;
  wire \current_us_reg[47]_i_34_n_3 ;
  wire \current_us_reg[47]_i_3_n_1 ;
  wire \current_us_reg[47]_i_3_n_2 ;
  wire \current_us_reg[47]_i_3_n_3 ;
  wire \current_us_reg[47]_i_4_n_1 ;
  wire \current_us_reg[47]_i_4_n_2 ;
  wire \current_us_reg[47]_i_4_n_3 ;
  wire \current_us_reg[47]_i_51_n_0 ;
  wire \current_us_reg[47]_i_51_n_1 ;
  wire \current_us_reg[47]_i_51_n_2 ;
  wire \current_us_reg[47]_i_51_n_3 ;
  wire \current_us_reg[47]_i_51_n_4 ;
  wire \current_us_reg[47]_i_51_n_5 ;
  wire \current_us_reg[47]_i_51_n_6 ;
  wire \current_us_reg[47]_i_51_n_7 ;
  wire \current_us_reg[47]_i_56_n_3 ;
  wire \current_us_reg[47]_i_57_n_0 ;
  wire \current_us_reg[47]_i_57_n_1 ;
  wire \current_us_reg[47]_i_57_n_2 ;
  wire \current_us_reg[47]_i_57_n_3 ;
  wire \current_us_reg[47]_i_57_n_4 ;
  wire \current_us_reg[47]_i_57_n_5 ;
  wire \current_us_reg[47]_i_57_n_6 ;
  wire \current_us_reg[47]_i_57_n_7 ;
  wire \current_us_reg[47]_i_58_n_0 ;
  wire \current_us_reg[47]_i_58_n_1 ;
  wire \current_us_reg[47]_i_58_n_2 ;
  wire \current_us_reg[47]_i_58_n_3 ;
  wire \current_us_reg[47]_i_58_n_4 ;
  wire \current_us_reg[47]_i_58_n_5 ;
  wire \current_us_reg[47]_i_58_n_6 ;
  wire \current_us_reg[47]_i_58_n_7 ;
  wire \current_us_reg[47]_i_59_n_0 ;
  wire \current_us_reg[47]_i_59_n_1 ;
  wire \current_us_reg[47]_i_59_n_2 ;
  wire \current_us_reg[47]_i_59_n_3 ;
  wire \current_us_reg[47]_i_59_n_4 ;
  wire \current_us_reg[47]_i_59_n_5 ;
  wire \current_us_reg[47]_i_59_n_6 ;
  wire \current_us_reg[47]_i_59_n_7 ;
  wire \current_us_reg[47]_i_60_n_3 ;
  wire \current_us_reg[47]_i_61_n_0 ;
  wire \current_us_reg[47]_i_61_n_1 ;
  wire \current_us_reg[47]_i_61_n_2 ;
  wire \current_us_reg[47]_i_61_n_3 ;
  wire \current_us_reg[47]_i_61_n_4 ;
  wire \current_us_reg[47]_i_61_n_5 ;
  wire \current_us_reg[47]_i_61_n_6 ;
  wire \current_us_reg[47]_i_61_n_7 ;
  wire \current_us_reg[47]_i_62_n_0 ;
  wire \current_us_reg[47]_i_62_n_1 ;
  wire \current_us_reg[47]_i_62_n_2 ;
  wire \current_us_reg[47]_i_62_n_3 ;
  wire \current_us_reg[47]_i_62_n_4 ;
  wire \current_us_reg[47]_i_62_n_5 ;
  wire \current_us_reg[47]_i_62_n_6 ;
  wire \current_us_reg[47]_i_62_n_7 ;
  wire \current_us_reg[47]_i_6_n_2 ;
  wire \current_us_reg[47]_i_6_n_3 ;
  wire \current_us_reg[47]_i_8_n_0 ;
  wire \current_us_reg[47]_i_8_n_1 ;
  wire \current_us_reg[47]_i_8_n_2 ;
  wire \current_us_reg[47]_i_8_n_3 ;
  wire \current_us_reg[48]_i_3_n_0 ;
  wire \current_us_reg[48]_i_3_n_1 ;
  wire \current_us_reg[48]_i_3_n_2 ;
  wire \current_us_reg[48]_i_3_n_3 ;
  wire \current_us_reg[48]_i_3_n_4 ;
  wire \current_us_reg[48]_i_3_n_5 ;
  wire \current_us_reg[48]_i_3_n_6 ;
  wire \current_us_reg[48]_i_3_n_7 ;
  wire \current_us_reg[49]_i_2_n_0 ;
  wire \current_us_reg[49]_i_2_n_1 ;
  wire \current_us_reg[49]_i_2_n_2 ;
  wire \current_us_reg[49]_i_2_n_3 ;
  wire \current_us_reg[4]_i_2_n_0 ;
  wire \current_us_reg[4]_i_2_n_1 ;
  wire \current_us_reg[4]_i_2_n_2 ;
  wire \current_us_reg[4]_i_2_n_3 ;
  wire \current_us_reg[52]_i_2_n_0 ;
  wire \current_us_reg[52]_i_2_n_1 ;
  wire \current_us_reg[52]_i_2_n_2 ;
  wire \current_us_reg[52]_i_2_n_3 ;
  wire \current_us_reg[56]_i_2_n_0 ;
  wire \current_us_reg[56]_i_2_n_1 ;
  wire \current_us_reg[56]_i_2_n_2 ;
  wire \current_us_reg[56]_i_2_n_3 ;
  wire \current_us_reg[56]_i_4_n_0 ;
  wire \current_us_reg[56]_i_4_n_1 ;
  wire \current_us_reg[56]_i_4_n_2 ;
  wire \current_us_reg[56]_i_4_n_3 ;
  wire \current_us_reg[60]_i_2_n_0 ;
  wire \current_us_reg[60]_i_2_n_1 ;
  wire \current_us_reg[60]_i_2_n_2 ;
  wire \current_us_reg[60]_i_2_n_3 ;
  wire \current_us_reg[60]_i_4_n_0 ;
  wire \current_us_reg[60]_i_4_n_1 ;
  wire \current_us_reg[60]_i_4_n_2 ;
  wire \current_us_reg[60]_i_4_n_3 ;
  wire \current_us_reg[63]_i_17_n_0 ;
  wire \current_us_reg[63]_i_17_n_1 ;
  wire \current_us_reg[63]_i_17_n_2 ;
  wire \current_us_reg[63]_i_17_n_3 ;
  wire \current_us_reg[63]_i_27_n_0 ;
  wire \current_us_reg[63]_i_27_n_1 ;
  wire \current_us_reg[63]_i_27_n_2 ;
  wire \current_us_reg[63]_i_27_n_3 ;
  wire \current_us_reg[63]_i_27_n_4 ;
  wire \current_us_reg[63]_i_27_n_5 ;
  wire \current_us_reg[63]_i_27_n_6 ;
  wire \current_us_reg[63]_i_27_n_7 ;
  wire \current_us_reg[63]_i_34_n_2 ;
  wire \current_us_reg[63]_i_34_n_3 ;
  wire \current_us_reg[63]_i_3_n_1 ;
  wire \current_us_reg[63]_i_3_n_2 ;
  wire \current_us_reg[63]_i_3_n_3 ;
  wire \current_us_reg[63]_i_4_n_1 ;
  wire \current_us_reg[63]_i_4_n_2 ;
  wire \current_us_reg[63]_i_4_n_3 ;
  wire \current_us_reg[63]_i_51_n_0 ;
  wire \current_us_reg[63]_i_51_n_1 ;
  wire \current_us_reg[63]_i_51_n_2 ;
  wire \current_us_reg[63]_i_51_n_3 ;
  wire \current_us_reg[63]_i_51_n_4 ;
  wire \current_us_reg[63]_i_51_n_5 ;
  wire \current_us_reg[63]_i_51_n_6 ;
  wire \current_us_reg[63]_i_51_n_7 ;
  wire \current_us_reg[63]_i_56_n_3 ;
  wire \current_us_reg[63]_i_57_n_0 ;
  wire \current_us_reg[63]_i_57_n_1 ;
  wire \current_us_reg[63]_i_57_n_2 ;
  wire \current_us_reg[63]_i_57_n_3 ;
  wire \current_us_reg[63]_i_57_n_4 ;
  wire \current_us_reg[63]_i_57_n_5 ;
  wire \current_us_reg[63]_i_57_n_6 ;
  wire \current_us_reg[63]_i_57_n_7 ;
  wire \current_us_reg[63]_i_58_n_0 ;
  wire \current_us_reg[63]_i_58_n_1 ;
  wire \current_us_reg[63]_i_58_n_2 ;
  wire \current_us_reg[63]_i_58_n_3 ;
  wire \current_us_reg[63]_i_58_n_4 ;
  wire \current_us_reg[63]_i_58_n_5 ;
  wire \current_us_reg[63]_i_58_n_6 ;
  wire \current_us_reg[63]_i_58_n_7 ;
  wire \current_us_reg[63]_i_59_n_0 ;
  wire \current_us_reg[63]_i_59_n_1 ;
  wire \current_us_reg[63]_i_59_n_2 ;
  wire \current_us_reg[63]_i_59_n_3 ;
  wire \current_us_reg[63]_i_59_n_4 ;
  wire \current_us_reg[63]_i_59_n_5 ;
  wire \current_us_reg[63]_i_59_n_6 ;
  wire \current_us_reg[63]_i_59_n_7 ;
  wire \current_us_reg[63]_i_60_n_3 ;
  wire \current_us_reg[63]_i_61_n_0 ;
  wire \current_us_reg[63]_i_61_n_1 ;
  wire \current_us_reg[63]_i_61_n_2 ;
  wire \current_us_reg[63]_i_61_n_3 ;
  wire \current_us_reg[63]_i_61_n_4 ;
  wire \current_us_reg[63]_i_61_n_5 ;
  wire \current_us_reg[63]_i_61_n_6 ;
  wire \current_us_reg[63]_i_61_n_7 ;
  wire \current_us_reg[63]_i_62_n_0 ;
  wire \current_us_reg[63]_i_62_n_1 ;
  wire \current_us_reg[63]_i_62_n_2 ;
  wire \current_us_reg[63]_i_62_n_3 ;
  wire \current_us_reg[63]_i_62_n_4 ;
  wire \current_us_reg[63]_i_62_n_5 ;
  wire \current_us_reg[63]_i_62_n_6 ;
  wire \current_us_reg[63]_i_62_n_7 ;
  wire \current_us_reg[63]_i_6_n_2 ;
  wire \current_us_reg[63]_i_6_n_3 ;
  wire \current_us_reg[63]_i_8_n_0 ;
  wire \current_us_reg[63]_i_8_n_1 ;
  wire \current_us_reg[63]_i_8_n_2 ;
  wire \current_us_reg[63]_i_8_n_3 ;
  wire \current_us_reg[64]_i_3_n_0 ;
  wire \current_us_reg[64]_i_3_n_1 ;
  wire \current_us_reg[64]_i_3_n_2 ;
  wire \current_us_reg[64]_i_3_n_3 ;
  wire \current_us_reg[64]_i_3_n_4 ;
  wire \current_us_reg[64]_i_3_n_5 ;
  wire \current_us_reg[64]_i_3_n_6 ;
  wire \current_us_reg[64]_i_3_n_7 ;
  wire \current_us_reg[65]_i_2_n_0 ;
  wire \current_us_reg[65]_i_2_n_1 ;
  wire \current_us_reg[65]_i_2_n_2 ;
  wire \current_us_reg[65]_i_2_n_3 ;
  wire \current_us_reg[68]_i_2_n_0 ;
  wire \current_us_reg[68]_i_2_n_1 ;
  wire \current_us_reg[68]_i_2_n_2 ;
  wire \current_us_reg[68]_i_2_n_3 ;
  wire \current_us_reg[72]_i_2_n_0 ;
  wire \current_us_reg[72]_i_2_n_1 ;
  wire \current_us_reg[72]_i_2_n_2 ;
  wire \current_us_reg[72]_i_2_n_3 ;
  wire \current_us_reg[72]_i_4_n_0 ;
  wire \current_us_reg[72]_i_4_n_1 ;
  wire \current_us_reg[72]_i_4_n_2 ;
  wire \current_us_reg[72]_i_4_n_3 ;
  wire \current_us_reg[76]_i_2_n_0 ;
  wire \current_us_reg[76]_i_2_n_1 ;
  wire \current_us_reg[76]_i_2_n_2 ;
  wire \current_us_reg[76]_i_2_n_3 ;
  wire \current_us_reg[76]_i_4_n_0 ;
  wire \current_us_reg[76]_i_4_n_1 ;
  wire \current_us_reg[76]_i_4_n_2 ;
  wire \current_us_reg[76]_i_4_n_3 ;
  wire \current_us_reg[79]_i_17_n_0 ;
  wire \current_us_reg[79]_i_17_n_1 ;
  wire \current_us_reg[79]_i_17_n_2 ;
  wire \current_us_reg[79]_i_17_n_3 ;
  wire \current_us_reg[79]_i_27_n_0 ;
  wire \current_us_reg[79]_i_27_n_1 ;
  wire \current_us_reg[79]_i_27_n_2 ;
  wire \current_us_reg[79]_i_27_n_3 ;
  wire \current_us_reg[79]_i_27_n_4 ;
  wire \current_us_reg[79]_i_27_n_5 ;
  wire \current_us_reg[79]_i_27_n_6 ;
  wire \current_us_reg[79]_i_27_n_7 ;
  wire \current_us_reg[79]_i_34_n_2 ;
  wire \current_us_reg[79]_i_34_n_3 ;
  wire \current_us_reg[79]_i_3_n_1 ;
  wire \current_us_reg[79]_i_3_n_2 ;
  wire \current_us_reg[79]_i_3_n_3 ;
  wire \current_us_reg[79]_i_4_n_1 ;
  wire \current_us_reg[79]_i_4_n_2 ;
  wire \current_us_reg[79]_i_4_n_3 ;
  wire \current_us_reg[79]_i_51_n_0 ;
  wire \current_us_reg[79]_i_51_n_1 ;
  wire \current_us_reg[79]_i_51_n_2 ;
  wire \current_us_reg[79]_i_51_n_3 ;
  wire \current_us_reg[79]_i_51_n_4 ;
  wire \current_us_reg[79]_i_51_n_5 ;
  wire \current_us_reg[79]_i_51_n_6 ;
  wire \current_us_reg[79]_i_51_n_7 ;
  wire \current_us_reg[79]_i_56_n_3 ;
  wire \current_us_reg[79]_i_57_n_0 ;
  wire \current_us_reg[79]_i_57_n_1 ;
  wire \current_us_reg[79]_i_57_n_2 ;
  wire \current_us_reg[79]_i_57_n_3 ;
  wire \current_us_reg[79]_i_57_n_4 ;
  wire \current_us_reg[79]_i_57_n_5 ;
  wire \current_us_reg[79]_i_57_n_6 ;
  wire \current_us_reg[79]_i_57_n_7 ;
  wire \current_us_reg[79]_i_58_n_0 ;
  wire \current_us_reg[79]_i_58_n_1 ;
  wire \current_us_reg[79]_i_58_n_2 ;
  wire \current_us_reg[79]_i_58_n_3 ;
  wire \current_us_reg[79]_i_58_n_4 ;
  wire \current_us_reg[79]_i_58_n_5 ;
  wire \current_us_reg[79]_i_58_n_6 ;
  wire \current_us_reg[79]_i_58_n_7 ;
  wire \current_us_reg[79]_i_59_n_0 ;
  wire \current_us_reg[79]_i_59_n_1 ;
  wire \current_us_reg[79]_i_59_n_2 ;
  wire \current_us_reg[79]_i_59_n_3 ;
  wire \current_us_reg[79]_i_59_n_4 ;
  wire \current_us_reg[79]_i_59_n_5 ;
  wire \current_us_reg[79]_i_59_n_6 ;
  wire \current_us_reg[79]_i_59_n_7 ;
  wire \current_us_reg[79]_i_60_n_3 ;
  wire \current_us_reg[79]_i_61_n_0 ;
  wire \current_us_reg[79]_i_61_n_1 ;
  wire \current_us_reg[79]_i_61_n_2 ;
  wire \current_us_reg[79]_i_61_n_3 ;
  wire \current_us_reg[79]_i_61_n_4 ;
  wire \current_us_reg[79]_i_61_n_5 ;
  wire \current_us_reg[79]_i_61_n_6 ;
  wire \current_us_reg[79]_i_61_n_7 ;
  wire \current_us_reg[79]_i_62_n_0 ;
  wire \current_us_reg[79]_i_62_n_1 ;
  wire \current_us_reg[79]_i_62_n_2 ;
  wire \current_us_reg[79]_i_62_n_3 ;
  wire \current_us_reg[79]_i_62_n_4 ;
  wire \current_us_reg[79]_i_62_n_5 ;
  wire \current_us_reg[79]_i_62_n_6 ;
  wire \current_us_reg[79]_i_62_n_7 ;
  wire \current_us_reg[79]_i_6_n_2 ;
  wire \current_us_reg[79]_i_6_n_3 ;
  wire \current_us_reg[79]_i_8_n_0 ;
  wire \current_us_reg[79]_i_8_n_1 ;
  wire \current_us_reg[79]_i_8_n_2 ;
  wire \current_us_reg[79]_i_8_n_3 ;
  wire \current_us_reg[80]_i_3_n_0 ;
  wire \current_us_reg[80]_i_3_n_1 ;
  wire \current_us_reg[80]_i_3_n_2 ;
  wire \current_us_reg[80]_i_3_n_3 ;
  wire \current_us_reg[80]_i_3_n_4 ;
  wire \current_us_reg[80]_i_3_n_5 ;
  wire \current_us_reg[80]_i_3_n_6 ;
  wire \current_us_reg[80]_i_3_n_7 ;
  wire \current_us_reg[81]_i_2_n_0 ;
  wire \current_us_reg[81]_i_2_n_1 ;
  wire \current_us_reg[81]_i_2_n_2 ;
  wire \current_us_reg[81]_i_2_n_3 ;
  wire \current_us_reg[84]_i_2_n_0 ;
  wire \current_us_reg[84]_i_2_n_1 ;
  wire \current_us_reg[84]_i_2_n_2 ;
  wire \current_us_reg[84]_i_2_n_3 ;
  wire \current_us_reg[88]_i_2_n_0 ;
  wire \current_us_reg[88]_i_2_n_1 ;
  wire \current_us_reg[88]_i_2_n_2 ;
  wire \current_us_reg[88]_i_2_n_3 ;
  wire \current_us_reg[88]_i_4_n_0 ;
  wire \current_us_reg[88]_i_4_n_1 ;
  wire \current_us_reg[88]_i_4_n_2 ;
  wire \current_us_reg[88]_i_4_n_3 ;
  wire \current_us_reg[8]_i_2_n_0 ;
  wire \current_us_reg[8]_i_2_n_1 ;
  wire \current_us_reg[8]_i_2_n_2 ;
  wire \current_us_reg[8]_i_2_n_3 ;
  wire \current_us_reg[8]_i_4_n_0 ;
  wire \current_us_reg[8]_i_4_n_1 ;
  wire \current_us_reg[8]_i_4_n_2 ;
  wire \current_us_reg[8]_i_4_n_3 ;
  wire \current_us_reg[92]_i_2_n_0 ;
  wire \current_us_reg[92]_i_2_n_1 ;
  wire \current_us_reg[92]_i_2_n_2 ;
  wire \current_us_reg[92]_i_2_n_3 ;
  wire \current_us_reg[92]_i_4_n_0 ;
  wire \current_us_reg[92]_i_4_n_1 ;
  wire \current_us_reg[92]_i_4_n_2 ;
  wire \current_us_reg[92]_i_4_n_3 ;
  wire \current_us_reg[95]_i_10_n_0 ;
  wire \current_us_reg[95]_i_10_n_1 ;
  wire \current_us_reg[95]_i_10_n_2 ;
  wire \current_us_reg[95]_i_10_n_3 ;
  wire \current_us_reg[95]_i_19_n_0 ;
  wire \current_us_reg[95]_i_19_n_1 ;
  wire \current_us_reg[95]_i_19_n_2 ;
  wire \current_us_reg[95]_i_19_n_3 ;
  wire \current_us_reg[95]_i_29_n_0 ;
  wire \current_us_reg[95]_i_29_n_1 ;
  wire \current_us_reg[95]_i_29_n_2 ;
  wire \current_us_reg[95]_i_29_n_3 ;
  wire \current_us_reg[95]_i_36_n_2 ;
  wire \current_us_reg[95]_i_36_n_3 ;
  wire \current_us_reg[95]_i_53_n_0 ;
  wire \current_us_reg[95]_i_53_n_1 ;
  wire \current_us_reg[95]_i_53_n_2 ;
  wire \current_us_reg[95]_i_53_n_3 ;
  wire \current_us_reg[95]_i_58_n_3 ;
  wire \current_us_reg[95]_i_59_n_0 ;
  wire \current_us_reg[95]_i_59_n_1 ;
  wire \current_us_reg[95]_i_59_n_2 ;
  wire \current_us_reg[95]_i_59_n_3 ;
  wire \current_us_reg[95]_i_5_n_1 ;
  wire \current_us_reg[95]_i_5_n_2 ;
  wire \current_us_reg[95]_i_5_n_3 ;
  wire \current_us_reg[95]_i_60_n_0 ;
  wire \current_us_reg[95]_i_60_n_1 ;
  wire \current_us_reg[95]_i_60_n_2 ;
  wire \current_us_reg[95]_i_60_n_3 ;
  wire \current_us_reg[95]_i_61_n_0 ;
  wire \current_us_reg[95]_i_61_n_1 ;
  wire \current_us_reg[95]_i_61_n_2 ;
  wire \current_us_reg[95]_i_61_n_3 ;
  wire \current_us_reg[95]_i_61_n_4 ;
  wire \current_us_reg[95]_i_61_n_5 ;
  wire \current_us_reg[95]_i_61_n_6 ;
  wire \current_us_reg[95]_i_61_n_7 ;
  wire \current_us_reg[95]_i_62_n_3 ;
  wire \current_us_reg[95]_i_63_n_0 ;
  wire \current_us_reg[95]_i_63_n_1 ;
  wire \current_us_reg[95]_i_63_n_2 ;
  wire \current_us_reg[95]_i_63_n_3 ;
  wire \current_us_reg[95]_i_63_n_4 ;
  wire \current_us_reg[95]_i_63_n_5 ;
  wire \current_us_reg[95]_i_63_n_6 ;
  wire \current_us_reg[95]_i_63_n_7 ;
  wire \current_us_reg[95]_i_64_n_0 ;
  wire \current_us_reg[95]_i_64_n_1 ;
  wire \current_us_reg[95]_i_64_n_2 ;
  wire \current_us_reg[95]_i_64_n_3 ;
  wire \current_us_reg[95]_i_64_n_4 ;
  wire \current_us_reg[95]_i_64_n_5 ;
  wire \current_us_reg[95]_i_64_n_6 ;
  wire \current_us_reg[95]_i_64_n_7 ;
  wire \current_us_reg[95]_i_6_n_1 ;
  wire \current_us_reg[95]_i_6_n_2 ;
  wire \current_us_reg[95]_i_6_n_3 ;
  wire \current_us_reg[95]_i_8_n_2 ;
  wire \current_us_reg[95]_i_8_n_3 ;
  wire [14:1]data0;
  wire enable;
  wire estop;
  wire fault;
  wire fault_i_1_n_0;
  wire fault_i_3_n_0;
  wire fault_i_4_n_0;
  wire fault_i_5_n_0;
  wire [14:0]frame_us;
  wire \frame_us[14]_i_1_n_0 ;
  wire \frame_us[14]_i_4_n_0 ;
  wire \frame_us[14]_i_5_n_0 ;
  wire \frame_us[14]_i_6_n_0 ;
  wire \frame_us[14]_i_7_n_0 ;
  wire \frame_us_reg[12]_i_2_n_0 ;
  wire \frame_us_reg[12]_i_2_n_1 ;
  wire \frame_us_reg[12]_i_2_n_2 ;
  wire \frame_us_reg[12]_i_2_n_3 ;
  wire \frame_us_reg[14]_i_3_n_3 ;
  wire \frame_us_reg[4]_i_2_n_0 ;
  wire \frame_us_reg[4]_i_2_n_1 ;
  wire \frame_us_reg[4]_i_2_n_2 ;
  wire \frame_us_reg[4]_i_2_n_3 ;
  wire \frame_us_reg[8]_i_2_n_0 ;
  wire \frame_us_reg[8]_i_2_n_1 ;
  wire \frame_us_reg[8]_i_2_n_2 ;
  wire \frame_us_reg[8]_i_2_n_3 ;
  wire \frame_us_reg_n_0_[0] ;
  wire \frame_us_reg_n_0_[10] ;
  wire \frame_us_reg_n_0_[11] ;
  wire \frame_us_reg_n_0_[12] ;
  wire \frame_us_reg_n_0_[13] ;
  wire \frame_us_reg_n_0_[14] ;
  wire \frame_us_reg_n_0_[1] ;
  wire \frame_us_reg_n_0_[2] ;
  wire \frame_us_reg_n_0_[3] ;
  wire \frame_us_reg_n_0_[4] ;
  wire \frame_us_reg_n_0_[5] ;
  wire \frame_us_reg_n_0_[6] ;
  wire \frame_us_reg_n_0_[7] ;
  wire \frame_us_reg_n_0_[8] ;
  wire \frame_us_reg_n_0_[9] ;
  wire have_target2_out;
  wire have_target_i_1_n_0;
  wire have_target_reg_n_0;
  wire p_0_in;
  wire p_11_in;
  wire p_1_in;
  wire [95:0]p_34_out;
  wire p_5_in;
  wire p_7_in;
  wire p_9_in;
  wire \pending[0][15]_i_1_n_0 ;
  wire [15:0]\pending_reg[0] ;
  wire [15:0]\pending_reg[1] ;
  wire [15:0]\pending_reg[2] ;
  wire [15:0]\pending_reg[3] ;
  wire [15:0]\pending_reg[4] ;
  wire [15:0]\pending_reg[5] ;
  wire [15:2]position1;
  wire [15:1]position111_in;
  wire position112_in;
  wire [15:2]position114_in;
  wire [15:1]position116_in;
  wire position117_in;
  wire [15:2]position119_in;
  wire [15:1]position11_in;
  wire [15:1]position121_in;
  wire position122_in;
  wire [15:2]position124_in;
  wire [15:1]position126_in;
  wire position127_in;
  wire position12_in;
  wire [15:2]position14_in;
  wire [15:1]position16_in;
  wire position17_in;
  wire [15:2]position19_in;
  wire [15:0]position3;
  wire [5:0]pwm;
  wire \pwm[0]_i_10_n_0 ;
  wire \pwm[0]_i_11_n_0 ;
  wire \pwm[0]_i_12_n_0 ;
  wire \pwm[0]_i_13_n_0 ;
  wire \pwm[0]_i_14_n_0 ;
  wire \pwm[0]_i_15_n_0 ;
  wire \pwm[0]_i_16_n_0 ;
  wire \pwm[0]_i_17_n_0 ;
  wire \pwm[0]_i_18_n_0 ;
  wire \pwm[0]_i_19_n_0 ;
  wire \pwm[0]_i_1_n_0 ;
  wire \pwm[0]_i_4_n_0 ;
  wire \pwm[0]_i_5_n_0 ;
  wire \pwm[0]_i_6_n_0 ;
  wire \pwm[0]_i_7_n_0 ;
  wire \pwm[0]_i_8_n_0 ;
  wire \pwm[0]_i_9_n_0 ;
  wire \pwm[1]_i_10_n_0 ;
  wire \pwm[1]_i_11_n_0 ;
  wire \pwm[1]_i_12_n_0 ;
  wire \pwm[1]_i_13_n_0 ;
  wire \pwm[1]_i_14_n_0 ;
  wire \pwm[1]_i_15_n_0 ;
  wire \pwm[1]_i_16_n_0 ;
  wire \pwm[1]_i_17_n_0 ;
  wire \pwm[1]_i_18_n_0 ;
  wire \pwm[1]_i_19_n_0 ;
  wire \pwm[1]_i_1_n_0 ;
  wire \pwm[1]_i_4_n_0 ;
  wire \pwm[1]_i_5_n_0 ;
  wire \pwm[1]_i_6_n_0 ;
  wire \pwm[1]_i_7_n_0 ;
  wire \pwm[1]_i_8_n_0 ;
  wire \pwm[1]_i_9_n_0 ;
  wire \pwm[2]_i_10_n_0 ;
  wire \pwm[2]_i_11_n_0 ;
  wire \pwm[2]_i_12_n_0 ;
  wire \pwm[2]_i_13_n_0 ;
  wire \pwm[2]_i_14_n_0 ;
  wire \pwm[2]_i_15_n_0 ;
  wire \pwm[2]_i_16_n_0 ;
  wire \pwm[2]_i_17_n_0 ;
  wire \pwm[2]_i_18_n_0 ;
  wire \pwm[2]_i_19_n_0 ;
  wire \pwm[2]_i_1_n_0 ;
  wire \pwm[2]_i_4_n_0 ;
  wire \pwm[2]_i_5_n_0 ;
  wire \pwm[2]_i_6_n_0 ;
  wire \pwm[2]_i_7_n_0 ;
  wire \pwm[2]_i_8_n_0 ;
  wire \pwm[2]_i_9_n_0 ;
  wire \pwm[3]_i_10_n_0 ;
  wire \pwm[3]_i_11_n_0 ;
  wire \pwm[3]_i_12_n_0 ;
  wire \pwm[3]_i_13_n_0 ;
  wire \pwm[3]_i_14_n_0 ;
  wire \pwm[3]_i_15_n_0 ;
  wire \pwm[3]_i_16_n_0 ;
  wire \pwm[3]_i_17_n_0 ;
  wire \pwm[3]_i_18_n_0 ;
  wire \pwm[3]_i_19_n_0 ;
  wire \pwm[3]_i_1_n_0 ;
  wire \pwm[3]_i_4_n_0 ;
  wire \pwm[3]_i_5_n_0 ;
  wire \pwm[3]_i_6_n_0 ;
  wire \pwm[3]_i_7_n_0 ;
  wire \pwm[3]_i_8_n_0 ;
  wire \pwm[3]_i_9_n_0 ;
  wire \pwm[4]_i_10_n_0 ;
  wire \pwm[4]_i_11_n_0 ;
  wire \pwm[4]_i_12_n_0 ;
  wire \pwm[4]_i_13_n_0 ;
  wire \pwm[4]_i_14_n_0 ;
  wire \pwm[4]_i_15_n_0 ;
  wire \pwm[4]_i_16_n_0 ;
  wire \pwm[4]_i_17_n_0 ;
  wire \pwm[4]_i_18_n_0 ;
  wire \pwm[4]_i_19_n_0 ;
  wire \pwm[4]_i_1_n_0 ;
  wire \pwm[4]_i_4_n_0 ;
  wire \pwm[4]_i_5_n_0 ;
  wire \pwm[4]_i_6_n_0 ;
  wire \pwm[4]_i_7_n_0 ;
  wire \pwm[4]_i_8_n_0 ;
  wire \pwm[4]_i_9_n_0 ;
  wire \pwm[5]_i_10_n_0 ;
  wire \pwm[5]_i_11_n_0 ;
  wire \pwm[5]_i_13_n_0 ;
  wire \pwm[5]_i_14_n_0 ;
  wire \pwm[5]_i_15_n_0 ;
  wire \pwm[5]_i_16_n_0 ;
  wire \pwm[5]_i_17_n_0 ;
  wire \pwm[5]_i_18_n_0 ;
  wire \pwm[5]_i_19_n_0 ;
  wire \pwm[5]_i_1_n_0 ;
  wire \pwm[5]_i_20_n_0 ;
  wire \pwm[5]_i_21_n_0 ;
  wire \pwm[5]_i_22_n_0 ;
  wire \pwm[5]_i_23_n_0 ;
  wire \pwm[5]_i_24_n_0 ;
  wire \pwm[5]_i_25_n_0 ;
  wire \pwm[5]_i_26_n_0 ;
  wire \pwm[5]_i_27_n_0 ;
  wire \pwm[5]_i_28_n_0 ;
  wire \pwm[5]_i_29_n_0 ;
  wire \pwm[5]_i_2_n_0 ;
  wire \pwm[5]_i_30_n_0 ;
  wire \pwm[5]_i_31_n_0 ;
  wire \pwm[5]_i_32_n_0 ;
  wire \pwm[5]_i_33_n_0 ;
  wire \pwm[5]_i_34_n_0 ;
  wire \pwm[5]_i_35_n_0 ;
  wire \pwm[5]_i_36_n_0 ;
  wire \pwm[5]_i_37_n_0 ;
  wire \pwm[5]_i_38_n_0 ;
  wire \pwm[5]_i_39_n_0 ;
  wire \pwm[5]_i_40_n_0 ;
  wire \pwm[5]_i_41_n_0 ;
  wire \pwm[5]_i_42_n_0 ;
  wire \pwm[5]_i_43_n_0 ;
  wire \pwm[5]_i_44_n_0 ;
  wire \pwm[5]_i_45_n_0 ;
  wire \pwm[5]_i_46_n_0 ;
  wire \pwm[5]_i_47_n_0 ;
  wire \pwm[5]_i_48_n_0 ;
  wire \pwm[5]_i_49_n_0 ;
  wire \pwm[5]_i_4_n_0 ;
  wire \pwm[5]_i_50_n_0 ;
  wire \pwm[5]_i_51_n_0 ;
  wire \pwm[5]_i_52_n_0 ;
  wire \pwm[5]_i_53_n_0 ;
  wire \pwm[5]_i_54_n_0 ;
  wire \pwm[5]_i_55_n_0 ;
  wire \pwm[5]_i_56_n_0 ;
  wire \pwm[5]_i_57_n_0 ;
  wire \pwm[5]_i_58_n_0 ;
  wire \pwm[5]_i_59_n_0 ;
  wire \pwm[5]_i_60_n_0 ;
  wire \pwm[5]_i_61_n_0 ;
  wire \pwm[5]_i_62_n_0 ;
  wire \pwm[5]_i_63_n_0 ;
  wire \pwm[5]_i_64_n_0 ;
  wire \pwm[5]_i_65_n_0 ;
  wire \pwm[5]_i_66_n_0 ;
  wire \pwm[5]_i_6_n_0 ;
  wire \pwm[5]_i_7_n_0 ;
  wire \pwm[5]_i_8_n_0 ;
  wire \pwm[5]_i_9_n_0 ;
  wire \pwm_reg[0]_i_2_n_0 ;
  wire \pwm_reg[0]_i_2_n_1 ;
  wire \pwm_reg[0]_i_2_n_2 ;
  wire \pwm_reg[0]_i_2_n_3 ;
  wire \pwm_reg[0]_i_3_n_0 ;
  wire \pwm_reg[0]_i_3_n_1 ;
  wire \pwm_reg[0]_i_3_n_2 ;
  wire \pwm_reg[0]_i_3_n_3 ;
  wire \pwm_reg[1]_i_2_n_0 ;
  wire \pwm_reg[1]_i_2_n_1 ;
  wire \pwm_reg[1]_i_2_n_2 ;
  wire \pwm_reg[1]_i_2_n_3 ;
  wire \pwm_reg[1]_i_3_n_0 ;
  wire \pwm_reg[1]_i_3_n_1 ;
  wire \pwm_reg[1]_i_3_n_2 ;
  wire \pwm_reg[1]_i_3_n_3 ;
  wire \pwm_reg[2]_i_2_n_0 ;
  wire \pwm_reg[2]_i_2_n_1 ;
  wire \pwm_reg[2]_i_2_n_2 ;
  wire \pwm_reg[2]_i_2_n_3 ;
  wire \pwm_reg[2]_i_3_n_0 ;
  wire \pwm_reg[2]_i_3_n_1 ;
  wire \pwm_reg[2]_i_3_n_2 ;
  wire \pwm_reg[2]_i_3_n_3 ;
  wire \pwm_reg[3]_i_2_n_0 ;
  wire \pwm_reg[3]_i_2_n_1 ;
  wire \pwm_reg[3]_i_2_n_2 ;
  wire \pwm_reg[3]_i_2_n_3 ;
  wire \pwm_reg[3]_i_3_n_0 ;
  wire \pwm_reg[3]_i_3_n_1 ;
  wire \pwm_reg[3]_i_3_n_2 ;
  wire \pwm_reg[3]_i_3_n_3 ;
  wire \pwm_reg[4]_i_2_n_0 ;
  wire \pwm_reg[4]_i_2_n_1 ;
  wire \pwm_reg[4]_i_2_n_2 ;
  wire \pwm_reg[4]_i_2_n_3 ;
  wire \pwm_reg[4]_i_3_n_0 ;
  wire \pwm_reg[4]_i_3_n_1 ;
  wire \pwm_reg[4]_i_3_n_2 ;
  wire \pwm_reg[4]_i_3_n_3 ;
  wire \pwm_reg[5]_i_12_n_0 ;
  wire \pwm_reg[5]_i_12_n_1 ;
  wire \pwm_reg[5]_i_12_n_2 ;
  wire \pwm_reg[5]_i_12_n_3 ;
  wire \pwm_reg[5]_i_5_n_0 ;
  wire \pwm_reg[5]_i_5_n_1 ;
  wire \pwm_reg[5]_i_5_n_2 ;
  wire \pwm_reg[5]_i_5_n_3 ;
  wire rst_n;
  wire \sub_tick[0]_i_1_n_0 ;
  wire \sub_tick[1]_i_1_n_0 ;
  wire \sub_tick[2]_i_1_n_0 ;
  wire \sub_tick[3]_i_1_n_0 ;
  wire \sub_tick[4]_i_1_n_0 ;
  wire \sub_tick[4]_i_2_n_0 ;
  wire \sub_tick[4]_i_3_n_0 ;
  wire \sub_tick[4]_i_4_n_0 ;
  wire \sub_tick[4]_i_5_n_0 ;
  wire \sub_tick[4]_i_6_n_0 ;
  wire \sub_tick[4]_i_7_n_0 ;
  wire \sub_tick_reg_n_0_[0] ;
  wire \sub_tick_reg_n_0_[1] ;
  wire \sub_tick_reg_n_0_[2] ;
  wire \sub_tick_reg_n_0_[3] ;
  wire \sub_tick_reg_n_0_[4] ;
  wire [3:2]\NLW_age_reg[20]_i_1_CO_UNCONNECTED ;
  wire [3:3]\NLW_age_reg[20]_i_1_O_UNCONNECTED ;
  wire [3:0]\NLW_current_us_reg[15]_i_17_O_UNCONNECTED ;
  wire [3:0]\NLW_current_us_reg[15]_i_3_O_UNCONNECTED ;
  wire [3:2]\NLW_current_us_reg[15]_i_34_CO_UNCONNECTED ;
  wire [3:3]\NLW_current_us_reg[15]_i_34_O_UNCONNECTED ;
  wire [3:0]\NLW_current_us_reg[15]_i_4_O_UNCONNECTED ;
  wire [3:1]\NLW_current_us_reg[15]_i_56_CO_UNCONNECTED ;
  wire [3:0]\NLW_current_us_reg[15]_i_56_O_UNCONNECTED ;
  wire [3:2]\NLW_current_us_reg[15]_i_6_CO_UNCONNECTED ;
  wire [3:3]\NLW_current_us_reg[15]_i_6_O_UNCONNECTED ;
  wire [3:1]\NLW_current_us_reg[15]_i_60_CO_UNCONNECTED ;
  wire [3:0]\NLW_current_us_reg[15]_i_60_O_UNCONNECTED ;
  wire [3:0]\NLW_current_us_reg[15]_i_8_O_UNCONNECTED ;
  wire [0:0]\NLW_current_us_reg[20]_i_2_O_UNCONNECTED ;
  wire [3:0]\NLW_current_us_reg[31]_i_17_O_UNCONNECTED ;
  wire [3:0]\NLW_current_us_reg[31]_i_3_O_UNCONNECTED ;
  wire [3:2]\NLW_current_us_reg[31]_i_34_CO_UNCONNECTED ;
  wire [3:3]\NLW_current_us_reg[31]_i_34_O_UNCONNECTED ;
  wire [3:0]\NLW_current_us_reg[31]_i_4_O_UNCONNECTED ;
  wire [3:1]\NLW_current_us_reg[31]_i_56_CO_UNCONNECTED ;
  wire [3:0]\NLW_current_us_reg[31]_i_56_O_UNCONNECTED ;
  wire [3:2]\NLW_current_us_reg[31]_i_6_CO_UNCONNECTED ;
  wire [3:3]\NLW_current_us_reg[31]_i_6_O_UNCONNECTED ;
  wire [3:1]\NLW_current_us_reg[31]_i_60_CO_UNCONNECTED ;
  wire [3:0]\NLW_current_us_reg[31]_i_60_O_UNCONNECTED ;
  wire [3:0]\NLW_current_us_reg[31]_i_8_O_UNCONNECTED ;
  wire [0:0]\NLW_current_us_reg[36]_i_2_O_UNCONNECTED ;
  wire [3:0]\NLW_current_us_reg[47]_i_17_O_UNCONNECTED ;
  wire [3:0]\NLW_current_us_reg[47]_i_3_O_UNCONNECTED ;
  wire [3:2]\NLW_current_us_reg[47]_i_34_CO_UNCONNECTED ;
  wire [3:3]\NLW_current_us_reg[47]_i_34_O_UNCONNECTED ;
  wire [3:0]\NLW_current_us_reg[47]_i_4_O_UNCONNECTED ;
  wire [3:1]\NLW_current_us_reg[47]_i_56_CO_UNCONNECTED ;
  wire [3:0]\NLW_current_us_reg[47]_i_56_O_UNCONNECTED ;
  wire [3:2]\NLW_current_us_reg[47]_i_6_CO_UNCONNECTED ;
  wire [3:3]\NLW_current_us_reg[47]_i_6_O_UNCONNECTED ;
  wire [3:1]\NLW_current_us_reg[47]_i_60_CO_UNCONNECTED ;
  wire [3:0]\NLW_current_us_reg[47]_i_60_O_UNCONNECTED ;
  wire [3:0]\NLW_current_us_reg[47]_i_8_O_UNCONNECTED ;
  wire [0:0]\NLW_current_us_reg[4]_i_2_O_UNCONNECTED ;
  wire [0:0]\NLW_current_us_reg[52]_i_2_O_UNCONNECTED ;
  wire [3:0]\NLW_current_us_reg[63]_i_17_O_UNCONNECTED ;
  wire [3:0]\NLW_current_us_reg[63]_i_3_O_UNCONNECTED ;
  wire [3:2]\NLW_current_us_reg[63]_i_34_CO_UNCONNECTED ;
  wire [3:3]\NLW_current_us_reg[63]_i_34_O_UNCONNECTED ;
  wire [3:0]\NLW_current_us_reg[63]_i_4_O_UNCONNECTED ;
  wire [3:1]\NLW_current_us_reg[63]_i_56_CO_UNCONNECTED ;
  wire [3:0]\NLW_current_us_reg[63]_i_56_O_UNCONNECTED ;
  wire [3:2]\NLW_current_us_reg[63]_i_6_CO_UNCONNECTED ;
  wire [3:3]\NLW_current_us_reg[63]_i_6_O_UNCONNECTED ;
  wire [3:1]\NLW_current_us_reg[63]_i_60_CO_UNCONNECTED ;
  wire [3:0]\NLW_current_us_reg[63]_i_60_O_UNCONNECTED ;
  wire [3:0]\NLW_current_us_reg[63]_i_8_O_UNCONNECTED ;
  wire [0:0]\NLW_current_us_reg[68]_i_2_O_UNCONNECTED ;
  wire [3:0]\NLW_current_us_reg[79]_i_17_O_UNCONNECTED ;
  wire [3:0]\NLW_current_us_reg[79]_i_3_O_UNCONNECTED ;
  wire [3:2]\NLW_current_us_reg[79]_i_34_CO_UNCONNECTED ;
  wire [3:3]\NLW_current_us_reg[79]_i_34_O_UNCONNECTED ;
  wire [3:0]\NLW_current_us_reg[79]_i_4_O_UNCONNECTED ;
  wire [3:1]\NLW_current_us_reg[79]_i_56_CO_UNCONNECTED ;
  wire [3:0]\NLW_current_us_reg[79]_i_56_O_UNCONNECTED ;
  wire [3:2]\NLW_current_us_reg[79]_i_6_CO_UNCONNECTED ;
  wire [3:3]\NLW_current_us_reg[79]_i_6_O_UNCONNECTED ;
  wire [3:1]\NLW_current_us_reg[79]_i_60_CO_UNCONNECTED ;
  wire [3:0]\NLW_current_us_reg[79]_i_60_O_UNCONNECTED ;
  wire [3:0]\NLW_current_us_reg[79]_i_8_O_UNCONNECTED ;
  wire [0:0]\NLW_current_us_reg[84]_i_2_O_UNCONNECTED ;
  wire [3:0]\NLW_current_us_reg[95]_i_10_O_UNCONNECTED ;
  wire [3:0]\NLW_current_us_reg[95]_i_19_O_UNCONNECTED ;
  wire [3:2]\NLW_current_us_reg[95]_i_36_CO_UNCONNECTED ;
  wire [3:3]\NLW_current_us_reg[95]_i_36_O_UNCONNECTED ;
  wire [3:0]\NLW_current_us_reg[95]_i_5_O_UNCONNECTED ;
  wire [3:1]\NLW_current_us_reg[95]_i_58_CO_UNCONNECTED ;
  wire [3:0]\NLW_current_us_reg[95]_i_58_O_UNCONNECTED ;
  wire [3:0]\NLW_current_us_reg[95]_i_6_O_UNCONNECTED ;
  wire [3:1]\NLW_current_us_reg[95]_i_62_CO_UNCONNECTED ;
  wire [3:0]\NLW_current_us_reg[95]_i_62_O_UNCONNECTED ;
  wire [3:2]\NLW_current_us_reg[95]_i_8_CO_UNCONNECTED ;
  wire [3:3]\NLW_current_us_reg[95]_i_8_O_UNCONNECTED ;
  wire [3:1]\NLW_frame_us_reg[14]_i_3_CO_UNCONNECTED ;
  wire [3:2]\NLW_frame_us_reg[14]_i_3_O_UNCONNECTED ;
  wire [3:0]\NLW_pwm_reg[0]_i_2_O_UNCONNECTED ;
  wire [3:0]\NLW_pwm_reg[0]_i_3_O_UNCONNECTED ;
  wire [3:0]\NLW_pwm_reg[1]_i_2_O_UNCONNECTED ;
  wire [3:0]\NLW_pwm_reg[1]_i_3_O_UNCONNECTED ;
  wire [3:0]\NLW_pwm_reg[2]_i_2_O_UNCONNECTED ;
  wire [3:0]\NLW_pwm_reg[2]_i_3_O_UNCONNECTED ;
  wire [3:0]\NLW_pwm_reg[3]_i_2_O_UNCONNECTED ;
  wire [3:0]\NLW_pwm_reg[3]_i_3_O_UNCONNECTED ;
  wire [3:0]\NLW_pwm_reg[4]_i_2_O_UNCONNECTED ;
  wire [3:0]\NLW_pwm_reg[4]_i_3_O_UNCONNECTED ;
  wire [3:0]\NLW_pwm_reg[5]_i_12_O_UNCONNECTED ;
  wire [3:0]\NLW_pwm_reg[5]_i_5_O_UNCONNECTED ;

  LUT5 #(
    .INIT(32'hFF4FFFFF)) 
    \age[0]_i_1 
       (.I0(fault),
        .I1(have_target2_out),
        .I2(rst_n),
        .I3(estop),
        .I4(enable),
        .O(\age[0]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h1)) 
    \age[0]_i_2 
       (.I0(fault),
        .I1(\sub_tick[4]_i_4_n_0 ),
        .O(\age[0]_i_2_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \age[0]_i_4 
       (.I0(\age_reg_n_0_[0] ),
        .O(\age[0]_i_4_n_0 ));
  FDRE \age_reg[0] 
       (.C(clk),
        .CE(\age[0]_i_2_n_0 ),
        .D(\age_reg[0]_i_3_n_7 ),
        .Q(\age_reg_n_0_[0] ),
        .R(\age[0]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \age_reg[0]_i_3 
       (.CI(1'b0),
        .CO({\age_reg[0]_i_3_n_0 ,\age_reg[0]_i_3_n_1 ,\age_reg[0]_i_3_n_2 ,\age_reg[0]_i_3_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b1}),
        .O({\age_reg[0]_i_3_n_4 ,\age_reg[0]_i_3_n_5 ,\age_reg[0]_i_3_n_6 ,\age_reg[0]_i_3_n_7 }),
        .S({\age_reg_n_0_[3] ,\age_reg_n_0_[2] ,\age_reg_n_0_[1] ,\age[0]_i_4_n_0 }));
  FDRE \age_reg[10] 
       (.C(clk),
        .CE(\age[0]_i_2_n_0 ),
        .D(\age_reg[8]_i_1_n_5 ),
        .Q(age_reg[10]),
        .R(\age[0]_i_1_n_0 ));
  FDRE \age_reg[11] 
       (.C(clk),
        .CE(\age[0]_i_2_n_0 ),
        .D(\age_reg[8]_i_1_n_4 ),
        .Q(age_reg[11]),
        .R(\age[0]_i_1_n_0 ));
  FDRE \age_reg[12] 
       (.C(clk),
        .CE(\age[0]_i_2_n_0 ),
        .D(\age_reg[12]_i_1_n_7 ),
        .Q(age_reg[12]),
        .R(\age[0]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \age_reg[12]_i_1 
       (.CI(\age_reg[8]_i_1_n_0 ),
        .CO({\age_reg[12]_i_1_n_0 ,\age_reg[12]_i_1_n_1 ,\age_reg[12]_i_1_n_2 ,\age_reg[12]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\age_reg[12]_i_1_n_4 ,\age_reg[12]_i_1_n_5 ,\age_reg[12]_i_1_n_6 ,\age_reg[12]_i_1_n_7 }),
        .S(age_reg[15:12]));
  FDRE \age_reg[13] 
       (.C(clk),
        .CE(\age[0]_i_2_n_0 ),
        .D(\age_reg[12]_i_1_n_6 ),
        .Q(age_reg[13]),
        .R(\age[0]_i_1_n_0 ));
  FDRE \age_reg[14] 
       (.C(clk),
        .CE(\age[0]_i_2_n_0 ),
        .D(\age_reg[12]_i_1_n_5 ),
        .Q(age_reg[14]),
        .R(\age[0]_i_1_n_0 ));
  FDRE \age_reg[15] 
       (.C(clk),
        .CE(\age[0]_i_2_n_0 ),
        .D(\age_reg[12]_i_1_n_4 ),
        .Q(age_reg[15]),
        .R(\age[0]_i_1_n_0 ));
  FDRE \age_reg[16] 
       (.C(clk),
        .CE(\age[0]_i_2_n_0 ),
        .D(\age_reg[16]_i_1_n_7 ),
        .Q(age_reg[16]),
        .R(\age[0]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \age_reg[16]_i_1 
       (.CI(\age_reg[12]_i_1_n_0 ),
        .CO({\age_reg[16]_i_1_n_0 ,\age_reg[16]_i_1_n_1 ,\age_reg[16]_i_1_n_2 ,\age_reg[16]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\age_reg[16]_i_1_n_4 ,\age_reg[16]_i_1_n_5 ,\age_reg[16]_i_1_n_6 ,\age_reg[16]_i_1_n_7 }),
        .S(age_reg[19:16]));
  FDRE \age_reg[17] 
       (.C(clk),
        .CE(\age[0]_i_2_n_0 ),
        .D(\age_reg[16]_i_1_n_6 ),
        .Q(age_reg[17]),
        .R(\age[0]_i_1_n_0 ));
  FDRE \age_reg[18] 
       (.C(clk),
        .CE(\age[0]_i_2_n_0 ),
        .D(\age_reg[16]_i_1_n_5 ),
        .Q(age_reg[18]),
        .R(\age[0]_i_1_n_0 ));
  FDRE \age_reg[19] 
       (.C(clk),
        .CE(\age[0]_i_2_n_0 ),
        .D(\age_reg[16]_i_1_n_4 ),
        .Q(age_reg[19]),
        .R(\age[0]_i_1_n_0 ));
  FDRE \age_reg[1] 
       (.C(clk),
        .CE(\age[0]_i_2_n_0 ),
        .D(\age_reg[0]_i_3_n_6 ),
        .Q(\age_reg_n_0_[1] ),
        .R(\age[0]_i_1_n_0 ));
  FDRE \age_reg[20] 
       (.C(clk),
        .CE(\age[0]_i_2_n_0 ),
        .D(\age_reg[20]_i_1_n_7 ),
        .Q(age_reg[20]),
        .R(\age[0]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \age_reg[20]_i_1 
       (.CI(\age_reg[16]_i_1_n_0 ),
        .CO({\NLW_age_reg[20]_i_1_CO_UNCONNECTED [3:2],\age_reg[20]_i_1_n_2 ,\age_reg[20]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\NLW_age_reg[20]_i_1_O_UNCONNECTED [3],\age_reg[20]_i_1_n_5 ,\age_reg[20]_i_1_n_6 ,\age_reg[20]_i_1_n_7 }),
        .S({1'b0,age_reg[22:20]}));
  FDRE \age_reg[21] 
       (.C(clk),
        .CE(\age[0]_i_2_n_0 ),
        .D(\age_reg[20]_i_1_n_6 ),
        .Q(age_reg[21]),
        .R(\age[0]_i_1_n_0 ));
  FDRE \age_reg[22] 
       (.C(clk),
        .CE(\age[0]_i_2_n_0 ),
        .D(\age_reg[20]_i_1_n_5 ),
        .Q(age_reg[22]),
        .R(\age[0]_i_1_n_0 ));
  FDRE \age_reg[2] 
       (.C(clk),
        .CE(\age[0]_i_2_n_0 ),
        .D(\age_reg[0]_i_3_n_5 ),
        .Q(\age_reg_n_0_[2] ),
        .R(\age[0]_i_1_n_0 ));
  FDRE \age_reg[3] 
       (.C(clk),
        .CE(\age[0]_i_2_n_0 ),
        .D(\age_reg[0]_i_3_n_4 ),
        .Q(\age_reg_n_0_[3] ),
        .R(\age[0]_i_1_n_0 ));
  FDRE \age_reg[4] 
       (.C(clk),
        .CE(\age[0]_i_2_n_0 ),
        .D(\age_reg[4]_i_1_n_7 ),
        .Q(age_reg[4]),
        .R(\age[0]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \age_reg[4]_i_1 
       (.CI(\age_reg[0]_i_3_n_0 ),
        .CO({\age_reg[4]_i_1_n_0 ,\age_reg[4]_i_1_n_1 ,\age_reg[4]_i_1_n_2 ,\age_reg[4]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\age_reg[4]_i_1_n_4 ,\age_reg[4]_i_1_n_5 ,\age_reg[4]_i_1_n_6 ,\age_reg[4]_i_1_n_7 }),
        .S(age_reg[7:4]));
  FDRE \age_reg[5] 
       (.C(clk),
        .CE(\age[0]_i_2_n_0 ),
        .D(\age_reg[4]_i_1_n_6 ),
        .Q(age_reg[5]),
        .R(\age[0]_i_1_n_0 ));
  FDRE \age_reg[6] 
       (.C(clk),
        .CE(\age[0]_i_2_n_0 ),
        .D(\age_reg[4]_i_1_n_5 ),
        .Q(age_reg[6]),
        .R(\age[0]_i_1_n_0 ));
  FDRE \age_reg[7] 
       (.C(clk),
        .CE(\age[0]_i_2_n_0 ),
        .D(\age_reg[4]_i_1_n_4 ),
        .Q(age_reg[7]),
        .R(\age[0]_i_1_n_0 ));
  FDRE \age_reg[8] 
       (.C(clk),
        .CE(\age[0]_i_2_n_0 ),
        .D(\age_reg[8]_i_1_n_7 ),
        .Q(age_reg[8]),
        .R(\age[0]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \age_reg[8]_i_1 
       (.CI(\age_reg[4]_i_1_n_0 ),
        .CO({\age_reg[8]_i_1_n_0 ,\age_reg[8]_i_1_n_1 ,\age_reg[8]_i_1_n_2 ,\age_reg[8]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\age_reg[8]_i_1_n_4 ,\age_reg[8]_i_1_n_5 ,\age_reg[8]_i_1_n_6 ,\age_reg[8]_i_1_n_7 }),
        .S(age_reg[11:8]));
  FDRE \age_reg[9] 
       (.C(clk),
        .CE(\age[0]_i_2_n_0 ),
        .D(\age_reg[8]_i_1_n_6 ),
        .Q(age_reg[9]),
        .R(\age[0]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'hE)) 
    armed_i_1
       (.I0(armed_i_2_n_0),
        .I1(armed),
        .O(armed_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT2 #(
    .INIT(4'h8)) 
    armed_i_2
       (.I0(have_target_reg_n_0),
        .I1(\pwm[5]_i_4_n_0 ),
        .O(armed_i_2_n_0));
  FDRE armed_reg
       (.C(clk),
        .CE(1'b1),
        .D(armed_i_1_n_0),
        .Q(armed),
        .R(\pwm[5]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFB8FFFF47000000)) 
    \current_us[0]_i_1 
       (.I0(\current_us[15]_i_5_n_0 ),
        .I1(position12_in),
        .I2(\current_us[0]_i_2_n_0 ),
        .I3(current_us[0]),
        .I4(armed),
        .I5(\pending_reg[0] [0]),
        .O(p_34_out[0]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT5 #(
    .INIT(32'h00000001)) 
    \current_us[0]_i_2 
       (.I0(\current_us[15]_i_30_n_0 ),
        .I1(\current_us_reg[0]_i_3_n_5 ),
        .I2(\current_us_reg[0]_i_3_n_4 ),
        .I3(\current_us[15]_i_32_n_0 ),
        .I4(\current_us[15]_i_33_n_0 ),
        .O(\current_us[0]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[0]_i_4 
       (.I0(current_us[15]),
        .I1(\pending_reg[0] [15]),
        .O(\current_us[0]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[0]_i_5 
       (.I0(current_us[14]),
        .I1(\pending_reg[0] [14]),
        .O(\current_us[0]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[0]_i_6 
       (.I0(current_us[13]),
        .I1(\pending_reg[0] [13]),
        .O(\current_us[0]_i_6_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[0]_i_7 
       (.I0(current_us[12]),
        .I1(\pending_reg[0] [12]),
        .O(\current_us[0]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[10]_i_1 
       (.I0(\current_us[15]_i_5_n_0 ),
        .I1(position11_in[10]),
        .I2(position12_in),
        .I3(\current_us[10]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[0] [10]),
        .O(p_34_out[10]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[10]_i_2 
       (.I0(\pending_reg[0] [10]),
        .I1(\current_us[15]_i_30_n_0 ),
        .I2(\current_us[15]_i_31_n_0 ),
        .I3(\current_us[15]_i_32_n_0 ),
        .I4(\current_us[15]_i_33_n_0 ),
        .I5(position1[10]),
        .O(\current_us[10]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[11]_i_1 
       (.I0(\current_us[15]_i_5_n_0 ),
        .I1(position11_in[11]),
        .I2(position12_in),
        .I3(\current_us[11]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[0] [11]),
        .O(p_34_out[11]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[11]_i_2 
       (.I0(\pending_reg[0] [11]),
        .I1(\current_us[15]_i_30_n_0 ),
        .I2(\current_us[15]_i_31_n_0 ),
        .I3(\current_us[15]_i_32_n_0 ),
        .I4(\current_us[15]_i_33_n_0 ),
        .I5(position1[11]),
        .O(\current_us[11]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[12]_i_1 
       (.I0(\current_us[15]_i_5_n_0 ),
        .I1(position11_in[12]),
        .I2(position12_in),
        .I3(\current_us[12]_i_3_n_0 ),
        .I4(armed),
        .I5(\pending_reg[0] [12]),
        .O(p_34_out[12]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[12]_i_3 
       (.I0(\pending_reg[0] [12]),
        .I1(\current_us[15]_i_30_n_0 ),
        .I2(\current_us[15]_i_31_n_0 ),
        .I3(\current_us[15]_i_32_n_0 ),
        .I4(\current_us[15]_i_33_n_0 ),
        .I5(position1[12]),
        .O(\current_us[12]_i_3_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[12]_i_5 
       (.I0(current_us[12]),
        .O(\current_us[12]_i_5_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[12]_i_6 
       (.I0(current_us[11]),
        .O(\current_us[12]_i_6_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[12]_i_7 
       (.I0(current_us[10]),
        .O(\current_us[12]_i_7_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[12]_i_8 
       (.I0(current_us[9]),
        .O(\current_us[12]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[13]_i_1 
       (.I0(\current_us[15]_i_5_n_0 ),
        .I1(position11_in[13]),
        .I2(position12_in),
        .I3(\current_us[13]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[0] [13]),
        .O(p_34_out[13]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[13]_i_2 
       (.I0(\pending_reg[0] [13]),
        .I1(\current_us[15]_i_30_n_0 ),
        .I2(\current_us[15]_i_31_n_0 ),
        .I3(\current_us[15]_i_32_n_0 ),
        .I4(\current_us[15]_i_33_n_0 ),
        .I5(position1[13]),
        .O(\current_us[13]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[14]_i_1 
       (.I0(\current_us[15]_i_5_n_0 ),
        .I1(position11_in[14]),
        .I2(position12_in),
        .I3(\current_us[14]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[0] [14]),
        .O(p_34_out[14]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[14]_i_2 
       (.I0(\pending_reg[0] [14]),
        .I1(\current_us[15]_i_30_n_0 ),
        .I2(\current_us[15]_i_31_n_0 ),
        .I3(\current_us[15]_i_32_n_0 ),
        .I4(\current_us[15]_i_33_n_0 ),
        .I5(position1[14]),
        .O(\current_us[14]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h2222202200000000)) 
    \current_us[15]_i_1 
       (.I0(\sub_tick[4]_i_2_n_0 ),
        .I1(\current_us[95]_i_4_n_0 ),
        .I2(position12_in),
        .I3(armed),
        .I4(p_1_in),
        .I5(armed_i_2_n_0),
        .O(\current_us[15]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[15]_i_10 
       (.I0(\pending_reg[0] [12]),
        .I1(current_us[12]),
        .I2(current_us[13]),
        .I3(\pending_reg[0] [13]),
        .O(\current_us[15]_i_10_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[15]_i_11 
       (.I0(\pending_reg[0] [10]),
        .I1(current_us[10]),
        .I2(current_us[11]),
        .I3(\pending_reg[0] [11]),
        .O(\current_us[15]_i_11_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[15]_i_12 
       (.I0(\pending_reg[0] [8]),
        .I1(current_us[8]),
        .I2(current_us[9]),
        .I3(\pending_reg[0] [9]),
        .O(\current_us[15]_i_12_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[15]_i_13 
       (.I0(current_us[14]),
        .I1(\pending_reg[0] [14]),
        .I2(\pending_reg[0] [15]),
        .I3(current_us[15]),
        .O(\current_us[15]_i_13_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[15]_i_14 
       (.I0(current_us[12]),
        .I1(\pending_reg[0] [12]),
        .I2(\pending_reg[0] [13]),
        .I3(current_us[13]),
        .O(\current_us[15]_i_14_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[15]_i_15 
       (.I0(current_us[10]),
        .I1(\pending_reg[0] [10]),
        .I2(\pending_reg[0] [11]),
        .I3(current_us[11]),
        .O(\current_us[15]_i_15_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[15]_i_16 
       (.I0(current_us[8]),
        .I1(\pending_reg[0] [8]),
        .I2(\pending_reg[0] [9]),
        .I3(current_us[9]),
        .O(\current_us[15]_i_16_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[15]_i_18 
       (.I0(current_us[14]),
        .I1(\pending_reg[0] [14]),
        .I2(\pending_reg[0] [15]),
        .I3(current_us[15]),
        .O(\current_us[15]_i_18_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[15]_i_19 
       (.I0(current_us[12]),
        .I1(\pending_reg[0] [12]),
        .I2(\pending_reg[0] [13]),
        .I3(current_us[13]),
        .O(\current_us[15]_i_19_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[15]_i_2 
       (.I0(\current_us[15]_i_5_n_0 ),
        .I1(position11_in[15]),
        .I2(position12_in),
        .I3(\current_us[15]_i_7_n_0 ),
        .I4(armed),
        .I5(\pending_reg[0] [15]),
        .O(p_34_out[15]));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[15]_i_20 
       (.I0(current_us[10]),
        .I1(\pending_reg[0] [10]),
        .I2(\pending_reg[0] [11]),
        .I3(current_us[11]),
        .O(\current_us[15]_i_20_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[15]_i_21 
       (.I0(current_us[8]),
        .I1(\pending_reg[0] [8]),
        .I2(\pending_reg[0] [9]),
        .I3(current_us[9]),
        .O(\current_us[15]_i_21_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[15]_i_22 
       (.I0(current_us[14]),
        .I1(\pending_reg[0] [14]),
        .I2(\pending_reg[0] [15]),
        .I3(current_us[15]),
        .O(\current_us[15]_i_22_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[15]_i_23 
       (.I0(current_us[12]),
        .I1(\pending_reg[0] [12]),
        .I2(\pending_reg[0] [13]),
        .I3(current_us[13]),
        .O(\current_us[15]_i_23_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[15]_i_24 
       (.I0(current_us[10]),
        .I1(\pending_reg[0] [10]),
        .I2(\pending_reg[0] [11]),
        .I3(current_us[11]),
        .O(\current_us[15]_i_24_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[15]_i_25 
       (.I0(current_us[8]),
        .I1(\pending_reg[0] [8]),
        .I2(\pending_reg[0] [9]),
        .I3(current_us[9]),
        .O(\current_us[15]_i_25_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \current_us[15]_i_26 
       (.I0(\current_us_reg[15]_i_51_n_5 ),
        .I1(\current_us_reg[15]_i_51_n_4 ),
        .I2(\current_us_reg[15]_i_27_n_7 ),
        .I3(\current_us_reg[15]_i_27_n_6 ),
        .O(\current_us[15]_i_26_n_0 ));
  LUT6 #(
    .INIT(64'hDDDDDDDDD5D5D555)) 
    \current_us[15]_i_28 
       (.I0(\current_us_reg[15]_i_56_n_3 ),
        .I1(\current_us_reg[15]_i_57_n_7 ),
        .I2(\current_us_reg[15]_i_58_n_5 ),
        .I3(\current_us_reg[15]_i_58_n_7 ),
        .I4(\current_us_reg[15]_i_58_n_6 ),
        .I5(\current_us_reg[15]_i_58_n_4 ),
        .O(\current_us[15]_i_28_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \current_us[15]_i_29 
       (.I0(\current_us_reg[15]_i_57_n_6 ),
        .I1(\current_us_reg[15]_i_57_n_4 ),
        .I2(\current_us_reg[15]_i_57_n_5 ),
        .I3(\current_us_reg[15]_i_51_n_6 ),
        .I4(\current_us_reg[15]_i_51_n_7 ),
        .O(\current_us[15]_i_29_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \current_us[15]_i_30 
       (.I0(\current_us_reg[15]_i_59_n_5 ),
        .I1(\current_us_reg[15]_i_59_n_4 ),
        .I2(\current_us_reg[0]_i_3_n_7 ),
        .I3(\current_us_reg[0]_i_3_n_6 ),
        .O(\current_us[15]_i_30_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \current_us[15]_i_31 
       (.I0(\current_us_reg[0]_i_3_n_4 ),
        .I1(\current_us_reg[0]_i_3_n_5 ),
        .O(\current_us[15]_i_31_n_0 ));
  LUT6 #(
    .INIT(64'hDDDDDDDDD5D5D555)) 
    \current_us[15]_i_32 
       (.I0(\current_us_reg[15]_i_60_n_3 ),
        .I1(\current_us_reg[15]_i_61_n_7 ),
        .I2(\current_us_reg[15]_i_62_n_5 ),
        .I3(\current_us_reg[15]_i_62_n_7 ),
        .I4(\current_us_reg[15]_i_62_n_6 ),
        .I5(\current_us_reg[15]_i_62_n_4 ),
        .O(\current_us[15]_i_32_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \current_us[15]_i_33 
       (.I0(\current_us_reg[15]_i_61_n_6 ),
        .I1(\current_us_reg[15]_i_61_n_4 ),
        .I2(\current_us_reg[15]_i_61_n_5 ),
        .I3(\current_us_reg[15]_i_59_n_6 ),
        .I4(\current_us_reg[15]_i_59_n_7 ),
        .O(\current_us[15]_i_33_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[15]_i_35 
       (.I0(\pending_reg[0] [6]),
        .I1(current_us[6]),
        .I2(current_us[7]),
        .I3(\pending_reg[0] [7]),
        .O(\current_us[15]_i_35_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[15]_i_36 
       (.I0(\pending_reg[0] [4]),
        .I1(current_us[4]),
        .I2(current_us[5]),
        .I3(\pending_reg[0] [5]),
        .O(\current_us[15]_i_36_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[15]_i_37 
       (.I0(\pending_reg[0] [2]),
        .I1(current_us[2]),
        .I2(current_us[3]),
        .I3(\pending_reg[0] [3]),
        .O(\current_us[15]_i_37_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[15]_i_38 
       (.I0(\pending_reg[0] [0]),
        .I1(current_us[0]),
        .I2(current_us[1]),
        .I3(\pending_reg[0] [1]),
        .O(\current_us[15]_i_38_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[15]_i_39 
       (.I0(current_us[6]),
        .I1(\pending_reg[0] [6]),
        .I2(\pending_reg[0] [7]),
        .I3(current_us[7]),
        .O(\current_us[15]_i_39_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[15]_i_40 
       (.I0(current_us[4]),
        .I1(\pending_reg[0] [4]),
        .I2(\pending_reg[0] [5]),
        .I3(current_us[5]),
        .O(\current_us[15]_i_40_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[15]_i_41 
       (.I0(current_us[2]),
        .I1(\pending_reg[0] [2]),
        .I2(\pending_reg[0] [3]),
        .I3(current_us[3]),
        .O(\current_us[15]_i_41_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[15]_i_42 
       (.I0(current_us[0]),
        .I1(\pending_reg[0] [0]),
        .I2(\pending_reg[0] [1]),
        .I3(current_us[1]),
        .O(\current_us[15]_i_42_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[15]_i_43 
       (.I0(current_us[6]),
        .I1(\pending_reg[0] [6]),
        .I2(\pending_reg[0] [7]),
        .I3(current_us[7]),
        .O(\current_us[15]_i_43_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[15]_i_44 
       (.I0(current_us[4]),
        .I1(\pending_reg[0] [4]),
        .I2(\pending_reg[0] [5]),
        .I3(current_us[5]),
        .O(\current_us[15]_i_44_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[15]_i_45 
       (.I0(current_us[2]),
        .I1(\pending_reg[0] [2]),
        .I2(\pending_reg[0] [3]),
        .I3(current_us[3]),
        .O(\current_us[15]_i_45_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[15]_i_46 
       (.I0(current_us[0]),
        .I1(\pending_reg[0] [0]),
        .I2(\pending_reg[0] [1]),
        .I3(current_us[1]),
        .O(\current_us[15]_i_46_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[15]_i_47 
       (.I0(current_us[6]),
        .I1(\pending_reg[0] [6]),
        .I2(\pending_reg[0] [7]),
        .I3(current_us[7]),
        .O(\current_us[15]_i_47_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[15]_i_48 
       (.I0(current_us[4]),
        .I1(\pending_reg[0] [4]),
        .I2(\pending_reg[0] [5]),
        .I3(current_us[5]),
        .O(\current_us[15]_i_48_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[15]_i_49 
       (.I0(current_us[2]),
        .I1(\pending_reg[0] [2]),
        .I2(\pending_reg[0] [3]),
        .I3(current_us[3]),
        .O(\current_us[15]_i_49_n_0 ));
  LUT5 #(
    .INIT(32'h00000001)) 
    \current_us[15]_i_5 
       (.I0(\current_us[15]_i_26_n_0 ),
        .I1(\current_us_reg[15]_i_27_n_5 ),
        .I2(\current_us_reg[15]_i_27_n_4 ),
        .I3(\current_us[15]_i_28_n_0 ),
        .I4(\current_us[15]_i_29_n_0 ),
        .O(\current_us[15]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[15]_i_50 
       (.I0(current_us[0]),
        .I1(\pending_reg[0] [0]),
        .I2(\pending_reg[0] [1]),
        .I3(current_us[1]),
        .O(\current_us[15]_i_50_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[15]_i_52 
       (.I0(\pending_reg[0] [15]),
        .I1(current_us[15]),
        .O(\current_us[15]_i_52_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[15]_i_53 
       (.I0(\pending_reg[0] [14]),
        .I1(current_us[14]),
        .O(\current_us[15]_i_53_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[15]_i_54 
       (.I0(\pending_reg[0] [13]),
        .I1(current_us[13]),
        .O(\current_us[15]_i_54_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[15]_i_55 
       (.I0(\pending_reg[0] [12]),
        .I1(current_us[12]),
        .O(\current_us[15]_i_55_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[15]_i_63 
       (.I0(current_us[15]),
        .O(\current_us[15]_i_63_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[15]_i_64 
       (.I0(current_us[14]),
        .O(\current_us[15]_i_64_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[15]_i_65 
       (.I0(current_us[13]),
        .O(\current_us[15]_i_65_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[15]_i_66 
       (.I0(\pending_reg[0] [11]),
        .I1(current_us[11]),
        .O(\current_us[15]_i_66_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[15]_i_67 
       (.I0(\pending_reg[0] [10]),
        .I1(current_us[10]),
        .O(\current_us[15]_i_67_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[15]_i_68 
       (.I0(\pending_reg[0] [9]),
        .I1(current_us[9]),
        .O(\current_us[15]_i_68_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[15]_i_69 
       (.I0(\pending_reg[0] [8]),
        .I1(current_us[8]),
        .O(\current_us[15]_i_69_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[15]_i_7 
       (.I0(\pending_reg[0] [15]),
        .I1(\current_us[15]_i_30_n_0 ),
        .I2(\current_us[15]_i_31_n_0 ),
        .I3(\current_us[15]_i_32_n_0 ),
        .I4(\current_us[15]_i_33_n_0 ),
        .I5(position1[15]),
        .O(\current_us[15]_i_7_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[15]_i_70 
       (.I0(\pending_reg[0] [7]),
        .I1(current_us[7]),
        .O(\current_us[15]_i_70_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[15]_i_71 
       (.I0(\pending_reg[0] [6]),
        .I1(current_us[6]),
        .O(\current_us[15]_i_71_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[15]_i_72 
       (.I0(\pending_reg[0] [5]),
        .I1(current_us[5]),
        .O(\current_us[15]_i_72_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[15]_i_73 
       (.I0(\pending_reg[0] [4]),
        .I1(current_us[4]),
        .O(\current_us[15]_i_73_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[15]_i_74 
       (.I0(\pending_reg[0] [3]),
        .I1(current_us[3]),
        .O(\current_us[15]_i_74_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[15]_i_75 
       (.I0(\pending_reg[0] [2]),
        .I1(current_us[2]),
        .O(\current_us[15]_i_75_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[15]_i_76 
       (.I0(\pending_reg[0] [1]),
        .I1(current_us[1]),
        .O(\current_us[15]_i_76_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[15]_i_77 
       (.I0(\pending_reg[0] [0]),
        .I1(current_us[0]),
        .O(\current_us[15]_i_77_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[15]_i_78 
       (.I0(current_us[11]),
        .I1(\pending_reg[0] [11]),
        .O(\current_us[15]_i_78_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[15]_i_79 
       (.I0(current_us[10]),
        .I1(\pending_reg[0] [10]),
        .O(\current_us[15]_i_79_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[15]_i_80 
       (.I0(current_us[9]),
        .I1(\pending_reg[0] [9]),
        .O(\current_us[15]_i_80_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[15]_i_81 
       (.I0(current_us[8]),
        .I1(\pending_reg[0] [8]),
        .O(\current_us[15]_i_81_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[15]_i_82 
       (.I0(current_us[7]),
        .I1(\pending_reg[0] [7]),
        .O(\current_us[15]_i_82_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[15]_i_83 
       (.I0(current_us[6]),
        .I1(\pending_reg[0] [6]),
        .O(\current_us[15]_i_83_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[15]_i_84 
       (.I0(current_us[5]),
        .I1(\pending_reg[0] [5]),
        .O(\current_us[15]_i_84_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[15]_i_85 
       (.I0(current_us[4]),
        .I1(\pending_reg[0] [4]),
        .O(\current_us[15]_i_85_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[15]_i_86 
       (.I0(current_us[3]),
        .I1(\pending_reg[0] [3]),
        .O(\current_us[15]_i_86_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[15]_i_87 
       (.I0(current_us[2]),
        .I1(\pending_reg[0] [2]),
        .O(\current_us[15]_i_87_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[15]_i_88 
       (.I0(current_us[1]),
        .I1(\pending_reg[0] [1]),
        .O(\current_us[15]_i_88_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[15]_i_89 
       (.I0(current_us[0]),
        .I1(\pending_reg[0] [0]),
        .O(\current_us[15]_i_89_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[15]_i_9 
       (.I0(\pending_reg[0] [14]),
        .I1(current_us[14]),
        .I2(current_us[15]),
        .I3(\pending_reg[0] [15]),
        .O(\current_us[15]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hFFB8FFFF47000000)) 
    \current_us[16]_i_1 
       (.I0(\current_us[31]_i_5_n_0 ),
        .I1(position17_in),
        .I2(\current_us[16]_i_2_n_0 ),
        .I3(current_us[16]),
        .I4(armed),
        .I5(\pending_reg[1] [0]),
        .O(p_34_out[16]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT5 #(
    .INIT(32'h00000001)) 
    \current_us[16]_i_2 
       (.I0(\current_us[31]_i_30_n_0 ),
        .I1(\current_us_reg[16]_i_3_n_5 ),
        .I2(\current_us_reg[16]_i_3_n_4 ),
        .I3(\current_us[31]_i_32_n_0 ),
        .I4(\current_us[31]_i_33_n_0 ),
        .O(\current_us[16]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[16]_i_4 
       (.I0(current_us[31]),
        .I1(\pending_reg[1] [15]),
        .O(\current_us[16]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[16]_i_5 
       (.I0(current_us[30]),
        .I1(\pending_reg[1] [14]),
        .O(\current_us[16]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[16]_i_6 
       (.I0(current_us[29]),
        .I1(\pending_reg[1] [13]),
        .O(\current_us[16]_i_6_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[16]_i_7 
       (.I0(current_us[28]),
        .I1(\pending_reg[1] [12]),
        .O(\current_us[16]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[17]_i_1 
       (.I0(\current_us[31]_i_5_n_0 ),
        .I1(position16_in[1]),
        .I2(position17_in),
        .I3(\current_us[17]_i_3_n_0 ),
        .I4(armed),
        .I5(\pending_reg[1] [1]),
        .O(p_34_out[17]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[17]_i_3 
       (.I0(\pending_reg[1] [1]),
        .I1(\current_us[31]_i_30_n_0 ),
        .I2(\current_us[31]_i_31_n_0 ),
        .I3(\current_us[31]_i_32_n_0 ),
        .I4(\current_us[31]_i_33_n_0 ),
        .I5(current_us[17]),
        .O(\current_us[17]_i_3_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[17]_i_4 
       (.I0(current_us[19]),
        .O(\current_us[17]_i_4_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[17]_i_5 
       (.I0(current_us[18]),
        .O(\current_us[17]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[18]_i_1 
       (.I0(\current_us[31]_i_5_n_0 ),
        .I1(position16_in[2]),
        .I2(position17_in),
        .I3(\current_us[18]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[1] [2]),
        .O(p_34_out[18]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[18]_i_2 
       (.I0(\pending_reg[1] [2]),
        .I1(\current_us[31]_i_30_n_0 ),
        .I2(\current_us[31]_i_31_n_0 ),
        .I3(\current_us[31]_i_32_n_0 ),
        .I4(\current_us[31]_i_33_n_0 ),
        .I5(position14_in[2]),
        .O(\current_us[18]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[19]_i_1 
       (.I0(\current_us[31]_i_5_n_0 ),
        .I1(position16_in[3]),
        .I2(position17_in),
        .I3(\current_us[19]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[1] [3]),
        .O(p_34_out[19]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[19]_i_2 
       (.I0(\pending_reg[1] [3]),
        .I1(\current_us[31]_i_30_n_0 ),
        .I2(\current_us[31]_i_31_n_0 ),
        .I3(\current_us[31]_i_32_n_0 ),
        .I4(\current_us[31]_i_33_n_0 ),
        .I5(position14_in[3]),
        .O(\current_us[19]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[1]_i_1 
       (.I0(\current_us[15]_i_5_n_0 ),
        .I1(position11_in[1]),
        .I2(position12_in),
        .I3(\current_us[1]_i_3_n_0 ),
        .I4(armed),
        .I5(\pending_reg[0] [1]),
        .O(p_34_out[1]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[1]_i_3 
       (.I0(\pending_reg[0] [1]),
        .I1(\current_us[15]_i_30_n_0 ),
        .I2(\current_us[15]_i_31_n_0 ),
        .I3(\current_us[15]_i_32_n_0 ),
        .I4(\current_us[15]_i_33_n_0 ),
        .I5(current_us[1]),
        .O(\current_us[1]_i_3_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[1]_i_4 
       (.I0(current_us[3]),
        .O(\current_us[1]_i_4_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[1]_i_5 
       (.I0(current_us[2]),
        .O(\current_us[1]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[20]_i_1 
       (.I0(\current_us[31]_i_5_n_0 ),
        .I1(position16_in[4]),
        .I2(position17_in),
        .I3(\current_us[20]_i_3_n_0 ),
        .I4(armed),
        .I5(\pending_reg[1] [4]),
        .O(p_34_out[20]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[20]_i_3 
       (.I0(\pending_reg[1] [4]),
        .I1(\current_us[31]_i_30_n_0 ),
        .I2(\current_us[31]_i_31_n_0 ),
        .I3(\current_us[31]_i_32_n_0 ),
        .I4(\current_us[31]_i_33_n_0 ),
        .I5(position14_in[4]),
        .O(\current_us[20]_i_3_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[20]_i_4 
       (.I0(current_us[20]),
        .O(\current_us[20]_i_4_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[20]_i_5 
       (.I0(current_us[18]),
        .O(\current_us[20]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[21]_i_1 
       (.I0(\current_us[31]_i_5_n_0 ),
        .I1(position16_in[5]),
        .I2(position17_in),
        .I3(\current_us[21]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[1] [5]),
        .O(p_34_out[21]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[21]_i_2 
       (.I0(\pending_reg[1] [5]),
        .I1(\current_us[31]_i_30_n_0 ),
        .I2(\current_us[31]_i_31_n_0 ),
        .I3(\current_us[31]_i_32_n_0 ),
        .I4(\current_us[31]_i_33_n_0 ),
        .I5(position14_in[5]),
        .O(\current_us[21]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[22]_i_1 
       (.I0(\current_us[31]_i_5_n_0 ),
        .I1(position16_in[6]),
        .I2(position17_in),
        .I3(\current_us[22]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[1] [6]),
        .O(p_34_out[22]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[22]_i_2 
       (.I0(\pending_reg[1] [6]),
        .I1(\current_us[31]_i_30_n_0 ),
        .I2(\current_us[31]_i_31_n_0 ),
        .I3(\current_us[31]_i_32_n_0 ),
        .I4(\current_us[31]_i_33_n_0 ),
        .I5(position14_in[6]),
        .O(\current_us[22]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[23]_i_1 
       (.I0(\current_us[31]_i_5_n_0 ),
        .I1(position16_in[7]),
        .I2(position17_in),
        .I3(\current_us[23]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[1] [7]),
        .O(p_34_out[23]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[23]_i_2 
       (.I0(\pending_reg[1] [7]),
        .I1(\current_us[31]_i_30_n_0 ),
        .I2(\current_us[31]_i_31_n_0 ),
        .I3(\current_us[31]_i_32_n_0 ),
        .I4(\current_us[31]_i_33_n_0 ),
        .I5(position14_in[7]),
        .O(\current_us[23]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[24]_i_1 
       (.I0(\current_us[31]_i_5_n_0 ),
        .I1(position16_in[8]),
        .I2(position17_in),
        .I3(\current_us[24]_i_3_n_0 ),
        .I4(armed),
        .I5(\pending_reg[1] [8]),
        .O(p_34_out[24]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[24]_i_3 
       (.I0(\pending_reg[1] [8]),
        .I1(\current_us[31]_i_30_n_0 ),
        .I2(\current_us[31]_i_31_n_0 ),
        .I3(\current_us[31]_i_32_n_0 ),
        .I4(\current_us[31]_i_33_n_0 ),
        .I5(position14_in[8]),
        .O(\current_us[24]_i_3_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[24]_i_5 
       (.I0(current_us[24]),
        .O(\current_us[24]_i_5_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[24]_i_6 
       (.I0(current_us[23]),
        .O(\current_us[24]_i_6_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[24]_i_7 
       (.I0(current_us[22]),
        .O(\current_us[24]_i_7_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[24]_i_8 
       (.I0(current_us[21]),
        .O(\current_us[24]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[25]_i_1 
       (.I0(\current_us[31]_i_5_n_0 ),
        .I1(position16_in[9]),
        .I2(position17_in),
        .I3(\current_us[25]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[1] [9]),
        .O(p_34_out[25]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[25]_i_2 
       (.I0(\pending_reg[1] [9]),
        .I1(\current_us[31]_i_30_n_0 ),
        .I2(\current_us[31]_i_31_n_0 ),
        .I3(\current_us[31]_i_32_n_0 ),
        .I4(\current_us[31]_i_33_n_0 ),
        .I5(position14_in[9]),
        .O(\current_us[25]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[26]_i_1 
       (.I0(\current_us[31]_i_5_n_0 ),
        .I1(position16_in[10]),
        .I2(position17_in),
        .I3(\current_us[26]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[1] [10]),
        .O(p_34_out[26]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[26]_i_2 
       (.I0(\pending_reg[1] [10]),
        .I1(\current_us[31]_i_30_n_0 ),
        .I2(\current_us[31]_i_31_n_0 ),
        .I3(\current_us[31]_i_32_n_0 ),
        .I4(\current_us[31]_i_33_n_0 ),
        .I5(position14_in[10]),
        .O(\current_us[26]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[27]_i_1 
       (.I0(\current_us[31]_i_5_n_0 ),
        .I1(position16_in[11]),
        .I2(position17_in),
        .I3(\current_us[27]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[1] [11]),
        .O(p_34_out[27]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[27]_i_2 
       (.I0(\pending_reg[1] [11]),
        .I1(\current_us[31]_i_30_n_0 ),
        .I2(\current_us[31]_i_31_n_0 ),
        .I3(\current_us[31]_i_32_n_0 ),
        .I4(\current_us[31]_i_33_n_0 ),
        .I5(position14_in[11]),
        .O(\current_us[27]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[28]_i_1 
       (.I0(\current_us[31]_i_5_n_0 ),
        .I1(position16_in[12]),
        .I2(position17_in),
        .I3(\current_us[28]_i_3_n_0 ),
        .I4(armed),
        .I5(\pending_reg[1] [12]),
        .O(p_34_out[28]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[28]_i_3 
       (.I0(\pending_reg[1] [12]),
        .I1(\current_us[31]_i_30_n_0 ),
        .I2(\current_us[31]_i_31_n_0 ),
        .I3(\current_us[31]_i_32_n_0 ),
        .I4(\current_us[31]_i_33_n_0 ),
        .I5(position14_in[12]),
        .O(\current_us[28]_i_3_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[28]_i_5 
       (.I0(current_us[28]),
        .O(\current_us[28]_i_5_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[28]_i_6 
       (.I0(current_us[27]),
        .O(\current_us[28]_i_6_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[28]_i_7 
       (.I0(current_us[26]),
        .O(\current_us[28]_i_7_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[28]_i_8 
       (.I0(current_us[25]),
        .O(\current_us[28]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[29]_i_1 
       (.I0(\current_us[31]_i_5_n_0 ),
        .I1(position16_in[13]),
        .I2(position17_in),
        .I3(\current_us[29]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[1] [13]),
        .O(p_34_out[29]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[29]_i_2 
       (.I0(\pending_reg[1] [13]),
        .I1(\current_us[31]_i_30_n_0 ),
        .I2(\current_us[31]_i_31_n_0 ),
        .I3(\current_us[31]_i_32_n_0 ),
        .I4(\current_us[31]_i_33_n_0 ),
        .I5(position14_in[13]),
        .O(\current_us[29]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[2]_i_1 
       (.I0(\current_us[15]_i_5_n_0 ),
        .I1(position11_in[2]),
        .I2(position12_in),
        .I3(\current_us[2]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[0] [2]),
        .O(p_34_out[2]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[2]_i_2 
       (.I0(\pending_reg[0] [2]),
        .I1(\current_us[15]_i_30_n_0 ),
        .I2(\current_us[15]_i_31_n_0 ),
        .I3(\current_us[15]_i_32_n_0 ),
        .I4(\current_us[15]_i_33_n_0 ),
        .I5(position1[2]),
        .O(\current_us[2]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[30]_i_1 
       (.I0(\current_us[31]_i_5_n_0 ),
        .I1(position16_in[14]),
        .I2(position17_in),
        .I3(\current_us[30]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[1] [14]),
        .O(p_34_out[30]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[30]_i_2 
       (.I0(\pending_reg[1] [14]),
        .I1(\current_us[31]_i_30_n_0 ),
        .I2(\current_us[31]_i_31_n_0 ),
        .I3(\current_us[31]_i_32_n_0 ),
        .I4(\current_us[31]_i_33_n_0 ),
        .I5(position14_in[14]),
        .O(\current_us[30]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h2222202200000000)) 
    \current_us[31]_i_1 
       (.I0(\sub_tick[4]_i_2_n_0 ),
        .I1(\current_us[95]_i_4_n_0 ),
        .I2(position17_in),
        .I3(armed),
        .I4(\current_us_reg[31]_i_4_n_0 ),
        .I5(armed_i_2_n_0),
        .O(\current_us[31]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[31]_i_10 
       (.I0(\pending_reg[1] [12]),
        .I1(current_us[28]),
        .I2(current_us[29]),
        .I3(\pending_reg[1] [13]),
        .O(\current_us[31]_i_10_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[31]_i_11 
       (.I0(\pending_reg[1] [10]),
        .I1(current_us[26]),
        .I2(current_us[27]),
        .I3(\pending_reg[1] [11]),
        .O(\current_us[31]_i_11_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[31]_i_12 
       (.I0(\pending_reg[1] [8]),
        .I1(current_us[24]),
        .I2(current_us[25]),
        .I3(\pending_reg[1] [9]),
        .O(\current_us[31]_i_12_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[31]_i_13 
       (.I0(current_us[30]),
        .I1(\pending_reg[1] [14]),
        .I2(\pending_reg[1] [15]),
        .I3(current_us[31]),
        .O(\current_us[31]_i_13_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[31]_i_14 
       (.I0(current_us[28]),
        .I1(\pending_reg[1] [12]),
        .I2(\pending_reg[1] [13]),
        .I3(current_us[29]),
        .O(\current_us[31]_i_14_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[31]_i_15 
       (.I0(current_us[26]),
        .I1(\pending_reg[1] [10]),
        .I2(\pending_reg[1] [11]),
        .I3(current_us[27]),
        .O(\current_us[31]_i_15_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[31]_i_16 
       (.I0(current_us[24]),
        .I1(\pending_reg[1] [8]),
        .I2(\pending_reg[1] [9]),
        .I3(current_us[25]),
        .O(\current_us[31]_i_16_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[31]_i_18 
       (.I0(current_us[30]),
        .I1(\pending_reg[1] [14]),
        .I2(\pending_reg[1] [15]),
        .I3(current_us[31]),
        .O(\current_us[31]_i_18_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[31]_i_19 
       (.I0(current_us[28]),
        .I1(\pending_reg[1] [12]),
        .I2(\pending_reg[1] [13]),
        .I3(current_us[29]),
        .O(\current_us[31]_i_19_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[31]_i_2 
       (.I0(\current_us[31]_i_5_n_0 ),
        .I1(position16_in[15]),
        .I2(position17_in),
        .I3(\current_us[31]_i_7_n_0 ),
        .I4(armed),
        .I5(\pending_reg[1] [15]),
        .O(p_34_out[31]));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[31]_i_20 
       (.I0(current_us[26]),
        .I1(\pending_reg[1] [10]),
        .I2(\pending_reg[1] [11]),
        .I3(current_us[27]),
        .O(\current_us[31]_i_20_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[31]_i_21 
       (.I0(current_us[24]),
        .I1(\pending_reg[1] [8]),
        .I2(\pending_reg[1] [9]),
        .I3(current_us[25]),
        .O(\current_us[31]_i_21_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[31]_i_22 
       (.I0(current_us[30]),
        .I1(\pending_reg[1] [14]),
        .I2(\pending_reg[1] [15]),
        .I3(current_us[31]),
        .O(\current_us[31]_i_22_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[31]_i_23 
       (.I0(current_us[28]),
        .I1(\pending_reg[1] [12]),
        .I2(\pending_reg[1] [13]),
        .I3(current_us[29]),
        .O(\current_us[31]_i_23_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[31]_i_24 
       (.I0(current_us[26]),
        .I1(\pending_reg[1] [10]),
        .I2(\pending_reg[1] [11]),
        .I3(current_us[27]),
        .O(\current_us[31]_i_24_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[31]_i_25 
       (.I0(current_us[24]),
        .I1(\pending_reg[1] [8]),
        .I2(\pending_reg[1] [9]),
        .I3(current_us[25]),
        .O(\current_us[31]_i_25_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \current_us[31]_i_26 
       (.I0(\current_us_reg[31]_i_51_n_5 ),
        .I1(\current_us_reg[31]_i_51_n_4 ),
        .I2(\current_us_reg[31]_i_27_n_7 ),
        .I3(\current_us_reg[31]_i_27_n_6 ),
        .O(\current_us[31]_i_26_n_0 ));
  LUT6 #(
    .INIT(64'hDDDDDDDDD5D5D555)) 
    \current_us[31]_i_28 
       (.I0(\current_us_reg[31]_i_56_n_3 ),
        .I1(\current_us_reg[31]_i_57_n_7 ),
        .I2(\current_us_reg[31]_i_58_n_5 ),
        .I3(\current_us_reg[31]_i_58_n_7 ),
        .I4(\current_us_reg[31]_i_58_n_6 ),
        .I5(\current_us_reg[31]_i_58_n_4 ),
        .O(\current_us[31]_i_28_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \current_us[31]_i_29 
       (.I0(\current_us_reg[31]_i_57_n_6 ),
        .I1(\current_us_reg[31]_i_57_n_4 ),
        .I2(\current_us_reg[31]_i_57_n_5 ),
        .I3(\current_us_reg[31]_i_51_n_6 ),
        .I4(\current_us_reg[31]_i_51_n_7 ),
        .O(\current_us[31]_i_29_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \current_us[31]_i_30 
       (.I0(\current_us_reg[31]_i_59_n_5 ),
        .I1(\current_us_reg[31]_i_59_n_4 ),
        .I2(\current_us_reg[16]_i_3_n_7 ),
        .I3(\current_us_reg[16]_i_3_n_6 ),
        .O(\current_us[31]_i_30_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \current_us[31]_i_31 
       (.I0(\current_us_reg[16]_i_3_n_4 ),
        .I1(\current_us_reg[16]_i_3_n_5 ),
        .O(\current_us[31]_i_31_n_0 ));
  LUT6 #(
    .INIT(64'hDDDDDDDDD5D5D555)) 
    \current_us[31]_i_32 
       (.I0(\current_us_reg[31]_i_60_n_3 ),
        .I1(\current_us_reg[31]_i_61_n_7 ),
        .I2(\current_us_reg[31]_i_62_n_5 ),
        .I3(\current_us_reg[31]_i_62_n_7 ),
        .I4(\current_us_reg[31]_i_62_n_6 ),
        .I5(\current_us_reg[31]_i_62_n_4 ),
        .O(\current_us[31]_i_32_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \current_us[31]_i_33 
       (.I0(\current_us_reg[31]_i_61_n_6 ),
        .I1(\current_us_reg[31]_i_61_n_4 ),
        .I2(\current_us_reg[31]_i_61_n_5 ),
        .I3(\current_us_reg[31]_i_59_n_6 ),
        .I4(\current_us_reg[31]_i_59_n_7 ),
        .O(\current_us[31]_i_33_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[31]_i_35 
       (.I0(\pending_reg[1] [6]),
        .I1(current_us[22]),
        .I2(current_us[23]),
        .I3(\pending_reg[1] [7]),
        .O(\current_us[31]_i_35_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[31]_i_36 
       (.I0(\pending_reg[1] [4]),
        .I1(current_us[20]),
        .I2(current_us[21]),
        .I3(\pending_reg[1] [5]),
        .O(\current_us[31]_i_36_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[31]_i_37 
       (.I0(\pending_reg[1] [2]),
        .I1(current_us[18]),
        .I2(current_us[19]),
        .I3(\pending_reg[1] [3]),
        .O(\current_us[31]_i_37_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[31]_i_38 
       (.I0(\pending_reg[1] [0]),
        .I1(current_us[16]),
        .I2(current_us[17]),
        .I3(\pending_reg[1] [1]),
        .O(\current_us[31]_i_38_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[31]_i_39 
       (.I0(current_us[22]),
        .I1(\pending_reg[1] [6]),
        .I2(\pending_reg[1] [7]),
        .I3(current_us[23]),
        .O(\current_us[31]_i_39_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[31]_i_40 
       (.I0(current_us[20]),
        .I1(\pending_reg[1] [4]),
        .I2(\pending_reg[1] [5]),
        .I3(current_us[21]),
        .O(\current_us[31]_i_40_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[31]_i_41 
       (.I0(current_us[18]),
        .I1(\pending_reg[1] [2]),
        .I2(\pending_reg[1] [3]),
        .I3(current_us[19]),
        .O(\current_us[31]_i_41_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[31]_i_42 
       (.I0(current_us[16]),
        .I1(\pending_reg[1] [0]),
        .I2(\pending_reg[1] [1]),
        .I3(current_us[17]),
        .O(\current_us[31]_i_42_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[31]_i_43 
       (.I0(current_us[22]),
        .I1(\pending_reg[1] [6]),
        .I2(\pending_reg[1] [7]),
        .I3(current_us[23]),
        .O(\current_us[31]_i_43_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[31]_i_44 
       (.I0(current_us[20]),
        .I1(\pending_reg[1] [4]),
        .I2(\pending_reg[1] [5]),
        .I3(current_us[21]),
        .O(\current_us[31]_i_44_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[31]_i_45 
       (.I0(current_us[18]),
        .I1(\pending_reg[1] [2]),
        .I2(\pending_reg[1] [3]),
        .I3(current_us[19]),
        .O(\current_us[31]_i_45_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[31]_i_46 
       (.I0(current_us[16]),
        .I1(\pending_reg[1] [0]),
        .I2(\pending_reg[1] [1]),
        .I3(current_us[17]),
        .O(\current_us[31]_i_46_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[31]_i_47 
       (.I0(current_us[22]),
        .I1(\pending_reg[1] [6]),
        .I2(\pending_reg[1] [7]),
        .I3(current_us[23]),
        .O(\current_us[31]_i_47_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[31]_i_48 
       (.I0(current_us[20]),
        .I1(\pending_reg[1] [4]),
        .I2(\pending_reg[1] [5]),
        .I3(current_us[21]),
        .O(\current_us[31]_i_48_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[31]_i_49 
       (.I0(current_us[18]),
        .I1(\pending_reg[1] [2]),
        .I2(\pending_reg[1] [3]),
        .I3(current_us[19]),
        .O(\current_us[31]_i_49_n_0 ));
  LUT5 #(
    .INIT(32'h00000001)) 
    \current_us[31]_i_5 
       (.I0(\current_us[31]_i_26_n_0 ),
        .I1(\current_us_reg[31]_i_27_n_5 ),
        .I2(\current_us_reg[31]_i_27_n_4 ),
        .I3(\current_us[31]_i_28_n_0 ),
        .I4(\current_us[31]_i_29_n_0 ),
        .O(\current_us[31]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[31]_i_50 
       (.I0(current_us[16]),
        .I1(\pending_reg[1] [0]),
        .I2(\pending_reg[1] [1]),
        .I3(current_us[17]),
        .O(\current_us[31]_i_50_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[31]_i_52 
       (.I0(\pending_reg[1] [15]),
        .I1(current_us[31]),
        .O(\current_us[31]_i_52_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[31]_i_53 
       (.I0(\pending_reg[1] [14]),
        .I1(current_us[30]),
        .O(\current_us[31]_i_53_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[31]_i_54 
       (.I0(\pending_reg[1] [13]),
        .I1(current_us[29]),
        .O(\current_us[31]_i_54_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[31]_i_55 
       (.I0(\pending_reg[1] [12]),
        .I1(current_us[28]),
        .O(\current_us[31]_i_55_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[31]_i_63 
       (.I0(current_us[31]),
        .O(\current_us[31]_i_63_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[31]_i_64 
       (.I0(current_us[30]),
        .O(\current_us[31]_i_64_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[31]_i_65 
       (.I0(current_us[29]),
        .O(\current_us[31]_i_65_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[31]_i_66 
       (.I0(\pending_reg[1] [11]),
        .I1(current_us[27]),
        .O(\current_us[31]_i_66_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[31]_i_67 
       (.I0(\pending_reg[1] [10]),
        .I1(current_us[26]),
        .O(\current_us[31]_i_67_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[31]_i_68 
       (.I0(\pending_reg[1] [9]),
        .I1(current_us[25]),
        .O(\current_us[31]_i_68_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[31]_i_69 
       (.I0(\pending_reg[1] [8]),
        .I1(current_us[24]),
        .O(\current_us[31]_i_69_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[31]_i_7 
       (.I0(\pending_reg[1] [15]),
        .I1(\current_us[31]_i_30_n_0 ),
        .I2(\current_us[31]_i_31_n_0 ),
        .I3(\current_us[31]_i_32_n_0 ),
        .I4(\current_us[31]_i_33_n_0 ),
        .I5(position14_in[15]),
        .O(\current_us[31]_i_7_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[31]_i_70 
       (.I0(\pending_reg[1] [7]),
        .I1(current_us[23]),
        .O(\current_us[31]_i_70_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[31]_i_71 
       (.I0(\pending_reg[1] [6]),
        .I1(current_us[22]),
        .O(\current_us[31]_i_71_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[31]_i_72 
       (.I0(\pending_reg[1] [5]),
        .I1(current_us[21]),
        .O(\current_us[31]_i_72_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[31]_i_73 
       (.I0(\pending_reg[1] [4]),
        .I1(current_us[20]),
        .O(\current_us[31]_i_73_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[31]_i_74 
       (.I0(\pending_reg[1] [3]),
        .I1(current_us[19]),
        .O(\current_us[31]_i_74_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[31]_i_75 
       (.I0(\pending_reg[1] [2]),
        .I1(current_us[18]),
        .O(\current_us[31]_i_75_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[31]_i_76 
       (.I0(\pending_reg[1] [1]),
        .I1(current_us[17]),
        .O(\current_us[31]_i_76_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[31]_i_77 
       (.I0(\pending_reg[1] [0]),
        .I1(current_us[16]),
        .O(\current_us[31]_i_77_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[31]_i_78 
       (.I0(current_us[27]),
        .I1(\pending_reg[1] [11]),
        .O(\current_us[31]_i_78_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[31]_i_79 
       (.I0(current_us[26]),
        .I1(\pending_reg[1] [10]),
        .O(\current_us[31]_i_79_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[31]_i_80 
       (.I0(current_us[25]),
        .I1(\pending_reg[1] [9]),
        .O(\current_us[31]_i_80_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[31]_i_81 
       (.I0(current_us[24]),
        .I1(\pending_reg[1] [8]),
        .O(\current_us[31]_i_81_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[31]_i_82 
       (.I0(current_us[23]),
        .I1(\pending_reg[1] [7]),
        .O(\current_us[31]_i_82_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[31]_i_83 
       (.I0(current_us[22]),
        .I1(\pending_reg[1] [6]),
        .O(\current_us[31]_i_83_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[31]_i_84 
       (.I0(current_us[21]),
        .I1(\pending_reg[1] [5]),
        .O(\current_us[31]_i_84_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[31]_i_85 
       (.I0(current_us[20]),
        .I1(\pending_reg[1] [4]),
        .O(\current_us[31]_i_85_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[31]_i_86 
       (.I0(current_us[19]),
        .I1(\pending_reg[1] [3]),
        .O(\current_us[31]_i_86_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[31]_i_87 
       (.I0(current_us[18]),
        .I1(\pending_reg[1] [2]),
        .O(\current_us[31]_i_87_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[31]_i_88 
       (.I0(current_us[17]),
        .I1(\pending_reg[1] [1]),
        .O(\current_us[31]_i_88_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[31]_i_89 
       (.I0(current_us[16]),
        .I1(\pending_reg[1] [0]),
        .O(\current_us[31]_i_89_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[31]_i_9 
       (.I0(\pending_reg[1] [14]),
        .I1(current_us[30]),
        .I2(current_us[31]),
        .I3(\pending_reg[1] [15]),
        .O(\current_us[31]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hFFB8FFFF47000000)) 
    \current_us[32]_i_1 
       (.I0(\current_us[47]_i_5_n_0 ),
        .I1(position112_in),
        .I2(\current_us[32]_i_2_n_0 ),
        .I3(current_us[32]),
        .I4(armed),
        .I5(\pending_reg[2] [0]),
        .O(p_34_out[32]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT5 #(
    .INIT(32'h00000001)) 
    \current_us[32]_i_2 
       (.I0(\current_us[47]_i_30_n_0 ),
        .I1(\current_us_reg[32]_i_3_n_5 ),
        .I2(\current_us_reg[32]_i_3_n_4 ),
        .I3(\current_us[47]_i_32_n_0 ),
        .I4(\current_us[47]_i_33_n_0 ),
        .O(\current_us[32]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[32]_i_4 
       (.I0(current_us[47]),
        .I1(\pending_reg[2] [15]),
        .O(\current_us[32]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[32]_i_5 
       (.I0(current_us[46]),
        .I1(\pending_reg[2] [14]),
        .O(\current_us[32]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[32]_i_6 
       (.I0(current_us[45]),
        .I1(\pending_reg[2] [13]),
        .O(\current_us[32]_i_6_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[32]_i_7 
       (.I0(current_us[44]),
        .I1(\pending_reg[2] [12]),
        .O(\current_us[32]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[33]_i_1 
       (.I0(\current_us[47]_i_5_n_0 ),
        .I1(position111_in[1]),
        .I2(position112_in),
        .I3(\current_us[33]_i_3_n_0 ),
        .I4(armed),
        .I5(\pending_reg[2] [1]),
        .O(p_34_out[33]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[33]_i_3 
       (.I0(\pending_reg[2] [1]),
        .I1(\current_us[47]_i_30_n_0 ),
        .I2(\current_us[47]_i_31_n_0 ),
        .I3(\current_us[47]_i_32_n_0 ),
        .I4(\current_us[47]_i_33_n_0 ),
        .I5(current_us[33]),
        .O(\current_us[33]_i_3_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[33]_i_4 
       (.I0(current_us[35]),
        .O(\current_us[33]_i_4_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[33]_i_5 
       (.I0(current_us[34]),
        .O(\current_us[33]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[34]_i_1 
       (.I0(\current_us[47]_i_5_n_0 ),
        .I1(position111_in[2]),
        .I2(position112_in),
        .I3(\current_us[34]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[2] [2]),
        .O(p_34_out[34]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[34]_i_2 
       (.I0(\pending_reg[2] [2]),
        .I1(\current_us[47]_i_30_n_0 ),
        .I2(\current_us[47]_i_31_n_0 ),
        .I3(\current_us[47]_i_32_n_0 ),
        .I4(\current_us[47]_i_33_n_0 ),
        .I5(position19_in[2]),
        .O(\current_us[34]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[35]_i_1 
       (.I0(\current_us[47]_i_5_n_0 ),
        .I1(position111_in[3]),
        .I2(position112_in),
        .I3(\current_us[35]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[2] [3]),
        .O(p_34_out[35]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[35]_i_2 
       (.I0(\pending_reg[2] [3]),
        .I1(\current_us[47]_i_30_n_0 ),
        .I2(\current_us[47]_i_31_n_0 ),
        .I3(\current_us[47]_i_32_n_0 ),
        .I4(\current_us[47]_i_33_n_0 ),
        .I5(position19_in[3]),
        .O(\current_us[35]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[36]_i_1 
       (.I0(\current_us[47]_i_5_n_0 ),
        .I1(position111_in[4]),
        .I2(position112_in),
        .I3(\current_us[36]_i_3_n_0 ),
        .I4(armed),
        .I5(\pending_reg[2] [4]),
        .O(p_34_out[36]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[36]_i_3 
       (.I0(\pending_reg[2] [4]),
        .I1(\current_us[47]_i_30_n_0 ),
        .I2(\current_us[47]_i_31_n_0 ),
        .I3(\current_us[47]_i_32_n_0 ),
        .I4(\current_us[47]_i_33_n_0 ),
        .I5(position19_in[4]),
        .O(\current_us[36]_i_3_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[36]_i_4 
       (.I0(current_us[36]),
        .O(\current_us[36]_i_4_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[36]_i_5 
       (.I0(current_us[34]),
        .O(\current_us[36]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[37]_i_1 
       (.I0(\current_us[47]_i_5_n_0 ),
        .I1(position111_in[5]),
        .I2(position112_in),
        .I3(\current_us[37]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[2] [5]),
        .O(p_34_out[37]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[37]_i_2 
       (.I0(\pending_reg[2] [5]),
        .I1(\current_us[47]_i_30_n_0 ),
        .I2(\current_us[47]_i_31_n_0 ),
        .I3(\current_us[47]_i_32_n_0 ),
        .I4(\current_us[47]_i_33_n_0 ),
        .I5(position19_in[5]),
        .O(\current_us[37]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[38]_i_1 
       (.I0(\current_us[47]_i_5_n_0 ),
        .I1(position111_in[6]),
        .I2(position112_in),
        .I3(\current_us[38]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[2] [6]),
        .O(p_34_out[38]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[38]_i_2 
       (.I0(\pending_reg[2] [6]),
        .I1(\current_us[47]_i_30_n_0 ),
        .I2(\current_us[47]_i_31_n_0 ),
        .I3(\current_us[47]_i_32_n_0 ),
        .I4(\current_us[47]_i_33_n_0 ),
        .I5(position19_in[6]),
        .O(\current_us[38]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[39]_i_1 
       (.I0(\current_us[47]_i_5_n_0 ),
        .I1(position111_in[7]),
        .I2(position112_in),
        .I3(\current_us[39]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[2] [7]),
        .O(p_34_out[39]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[39]_i_2 
       (.I0(\pending_reg[2] [7]),
        .I1(\current_us[47]_i_30_n_0 ),
        .I2(\current_us[47]_i_31_n_0 ),
        .I3(\current_us[47]_i_32_n_0 ),
        .I4(\current_us[47]_i_33_n_0 ),
        .I5(position19_in[7]),
        .O(\current_us[39]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[3]_i_1 
       (.I0(\current_us[15]_i_5_n_0 ),
        .I1(position11_in[3]),
        .I2(position12_in),
        .I3(\current_us[3]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[0] [3]),
        .O(p_34_out[3]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[3]_i_2 
       (.I0(\pending_reg[0] [3]),
        .I1(\current_us[15]_i_30_n_0 ),
        .I2(\current_us[15]_i_31_n_0 ),
        .I3(\current_us[15]_i_32_n_0 ),
        .I4(\current_us[15]_i_33_n_0 ),
        .I5(position1[3]),
        .O(\current_us[3]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[40]_i_1 
       (.I0(\current_us[47]_i_5_n_0 ),
        .I1(position111_in[8]),
        .I2(position112_in),
        .I3(\current_us[40]_i_3_n_0 ),
        .I4(armed),
        .I5(\pending_reg[2] [8]),
        .O(p_34_out[40]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[40]_i_3 
       (.I0(\pending_reg[2] [8]),
        .I1(\current_us[47]_i_30_n_0 ),
        .I2(\current_us[47]_i_31_n_0 ),
        .I3(\current_us[47]_i_32_n_0 ),
        .I4(\current_us[47]_i_33_n_0 ),
        .I5(position19_in[8]),
        .O(\current_us[40]_i_3_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[40]_i_5 
       (.I0(current_us[40]),
        .O(\current_us[40]_i_5_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[40]_i_6 
       (.I0(current_us[39]),
        .O(\current_us[40]_i_6_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[40]_i_7 
       (.I0(current_us[38]),
        .O(\current_us[40]_i_7_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[40]_i_8 
       (.I0(current_us[37]),
        .O(\current_us[40]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[41]_i_1 
       (.I0(\current_us[47]_i_5_n_0 ),
        .I1(position111_in[9]),
        .I2(position112_in),
        .I3(\current_us[41]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[2] [9]),
        .O(p_34_out[41]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[41]_i_2 
       (.I0(\pending_reg[2] [9]),
        .I1(\current_us[47]_i_30_n_0 ),
        .I2(\current_us[47]_i_31_n_0 ),
        .I3(\current_us[47]_i_32_n_0 ),
        .I4(\current_us[47]_i_33_n_0 ),
        .I5(position19_in[9]),
        .O(\current_us[41]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[42]_i_1 
       (.I0(\current_us[47]_i_5_n_0 ),
        .I1(position111_in[10]),
        .I2(position112_in),
        .I3(\current_us[42]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[2] [10]),
        .O(p_34_out[42]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[42]_i_2 
       (.I0(\pending_reg[2] [10]),
        .I1(\current_us[47]_i_30_n_0 ),
        .I2(\current_us[47]_i_31_n_0 ),
        .I3(\current_us[47]_i_32_n_0 ),
        .I4(\current_us[47]_i_33_n_0 ),
        .I5(position19_in[10]),
        .O(\current_us[42]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[43]_i_1 
       (.I0(\current_us[47]_i_5_n_0 ),
        .I1(position111_in[11]),
        .I2(position112_in),
        .I3(\current_us[43]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[2] [11]),
        .O(p_34_out[43]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[43]_i_2 
       (.I0(\pending_reg[2] [11]),
        .I1(\current_us[47]_i_30_n_0 ),
        .I2(\current_us[47]_i_31_n_0 ),
        .I3(\current_us[47]_i_32_n_0 ),
        .I4(\current_us[47]_i_33_n_0 ),
        .I5(position19_in[11]),
        .O(\current_us[43]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[44]_i_1 
       (.I0(\current_us[47]_i_5_n_0 ),
        .I1(position111_in[12]),
        .I2(position112_in),
        .I3(\current_us[44]_i_3_n_0 ),
        .I4(armed),
        .I5(\pending_reg[2] [12]),
        .O(p_34_out[44]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[44]_i_3 
       (.I0(\pending_reg[2] [12]),
        .I1(\current_us[47]_i_30_n_0 ),
        .I2(\current_us[47]_i_31_n_0 ),
        .I3(\current_us[47]_i_32_n_0 ),
        .I4(\current_us[47]_i_33_n_0 ),
        .I5(position19_in[12]),
        .O(\current_us[44]_i_3_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[44]_i_5 
       (.I0(current_us[44]),
        .O(\current_us[44]_i_5_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[44]_i_6 
       (.I0(current_us[43]),
        .O(\current_us[44]_i_6_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[44]_i_7 
       (.I0(current_us[42]),
        .O(\current_us[44]_i_7_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[44]_i_8 
       (.I0(current_us[41]),
        .O(\current_us[44]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[45]_i_1 
       (.I0(\current_us[47]_i_5_n_0 ),
        .I1(position111_in[13]),
        .I2(position112_in),
        .I3(\current_us[45]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[2] [13]),
        .O(p_34_out[45]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[45]_i_2 
       (.I0(\pending_reg[2] [13]),
        .I1(\current_us[47]_i_30_n_0 ),
        .I2(\current_us[47]_i_31_n_0 ),
        .I3(\current_us[47]_i_32_n_0 ),
        .I4(\current_us[47]_i_33_n_0 ),
        .I5(position19_in[13]),
        .O(\current_us[45]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[46]_i_1 
       (.I0(\current_us[47]_i_5_n_0 ),
        .I1(position111_in[14]),
        .I2(position112_in),
        .I3(\current_us[46]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[2] [14]),
        .O(p_34_out[46]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[46]_i_2 
       (.I0(\pending_reg[2] [14]),
        .I1(\current_us[47]_i_30_n_0 ),
        .I2(\current_us[47]_i_31_n_0 ),
        .I3(\current_us[47]_i_32_n_0 ),
        .I4(\current_us[47]_i_33_n_0 ),
        .I5(position19_in[14]),
        .O(\current_us[46]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h2222202200000000)) 
    \current_us[47]_i_1 
       (.I0(\sub_tick[4]_i_2_n_0 ),
        .I1(\current_us[95]_i_4_n_0 ),
        .I2(position112_in),
        .I3(armed),
        .I4(p_5_in),
        .I5(armed_i_2_n_0),
        .O(\current_us[47]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[47]_i_10 
       (.I0(\pending_reg[2] [12]),
        .I1(current_us[44]),
        .I2(current_us[45]),
        .I3(\pending_reg[2] [13]),
        .O(\current_us[47]_i_10_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[47]_i_11 
       (.I0(\pending_reg[2] [10]),
        .I1(current_us[42]),
        .I2(current_us[43]),
        .I3(\pending_reg[2] [11]),
        .O(\current_us[47]_i_11_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[47]_i_12 
       (.I0(\pending_reg[2] [8]),
        .I1(current_us[40]),
        .I2(current_us[41]),
        .I3(\pending_reg[2] [9]),
        .O(\current_us[47]_i_12_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[47]_i_13 
       (.I0(current_us[46]),
        .I1(\pending_reg[2] [14]),
        .I2(\pending_reg[2] [15]),
        .I3(current_us[47]),
        .O(\current_us[47]_i_13_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[47]_i_14 
       (.I0(current_us[44]),
        .I1(\pending_reg[2] [12]),
        .I2(\pending_reg[2] [13]),
        .I3(current_us[45]),
        .O(\current_us[47]_i_14_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[47]_i_15 
       (.I0(current_us[42]),
        .I1(\pending_reg[2] [10]),
        .I2(\pending_reg[2] [11]),
        .I3(current_us[43]),
        .O(\current_us[47]_i_15_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[47]_i_16 
       (.I0(current_us[40]),
        .I1(\pending_reg[2] [8]),
        .I2(\pending_reg[2] [9]),
        .I3(current_us[41]),
        .O(\current_us[47]_i_16_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[47]_i_18 
       (.I0(current_us[46]),
        .I1(\pending_reg[2] [14]),
        .I2(\pending_reg[2] [15]),
        .I3(current_us[47]),
        .O(\current_us[47]_i_18_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[47]_i_19 
       (.I0(current_us[44]),
        .I1(\pending_reg[2] [12]),
        .I2(\pending_reg[2] [13]),
        .I3(current_us[45]),
        .O(\current_us[47]_i_19_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[47]_i_2 
       (.I0(\current_us[47]_i_5_n_0 ),
        .I1(position111_in[15]),
        .I2(position112_in),
        .I3(\current_us[47]_i_7_n_0 ),
        .I4(armed),
        .I5(\pending_reg[2] [15]),
        .O(p_34_out[47]));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[47]_i_20 
       (.I0(current_us[42]),
        .I1(\pending_reg[2] [10]),
        .I2(\pending_reg[2] [11]),
        .I3(current_us[43]),
        .O(\current_us[47]_i_20_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[47]_i_21 
       (.I0(current_us[40]),
        .I1(\pending_reg[2] [8]),
        .I2(\pending_reg[2] [9]),
        .I3(current_us[41]),
        .O(\current_us[47]_i_21_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[47]_i_22 
       (.I0(current_us[46]),
        .I1(\pending_reg[2] [14]),
        .I2(\pending_reg[2] [15]),
        .I3(current_us[47]),
        .O(\current_us[47]_i_22_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[47]_i_23 
       (.I0(current_us[44]),
        .I1(\pending_reg[2] [12]),
        .I2(\pending_reg[2] [13]),
        .I3(current_us[45]),
        .O(\current_us[47]_i_23_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[47]_i_24 
       (.I0(current_us[42]),
        .I1(\pending_reg[2] [10]),
        .I2(\pending_reg[2] [11]),
        .I3(current_us[43]),
        .O(\current_us[47]_i_24_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[47]_i_25 
       (.I0(current_us[40]),
        .I1(\pending_reg[2] [8]),
        .I2(\pending_reg[2] [9]),
        .I3(current_us[41]),
        .O(\current_us[47]_i_25_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \current_us[47]_i_26 
       (.I0(\current_us_reg[47]_i_51_n_5 ),
        .I1(\current_us_reg[47]_i_51_n_4 ),
        .I2(\current_us_reg[47]_i_27_n_7 ),
        .I3(\current_us_reg[47]_i_27_n_6 ),
        .O(\current_us[47]_i_26_n_0 ));
  LUT6 #(
    .INIT(64'hDDDDDDDDD5D5D555)) 
    \current_us[47]_i_28 
       (.I0(\current_us_reg[47]_i_56_n_3 ),
        .I1(\current_us_reg[47]_i_57_n_7 ),
        .I2(\current_us_reg[47]_i_58_n_5 ),
        .I3(\current_us_reg[47]_i_58_n_7 ),
        .I4(\current_us_reg[47]_i_58_n_6 ),
        .I5(\current_us_reg[47]_i_58_n_4 ),
        .O(\current_us[47]_i_28_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \current_us[47]_i_29 
       (.I0(\current_us_reg[47]_i_57_n_6 ),
        .I1(\current_us_reg[47]_i_57_n_4 ),
        .I2(\current_us_reg[47]_i_57_n_5 ),
        .I3(\current_us_reg[47]_i_51_n_6 ),
        .I4(\current_us_reg[47]_i_51_n_7 ),
        .O(\current_us[47]_i_29_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \current_us[47]_i_30 
       (.I0(\current_us_reg[47]_i_59_n_5 ),
        .I1(\current_us_reg[47]_i_59_n_4 ),
        .I2(\current_us_reg[32]_i_3_n_7 ),
        .I3(\current_us_reg[32]_i_3_n_6 ),
        .O(\current_us[47]_i_30_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \current_us[47]_i_31 
       (.I0(\current_us_reg[32]_i_3_n_4 ),
        .I1(\current_us_reg[32]_i_3_n_5 ),
        .O(\current_us[47]_i_31_n_0 ));
  LUT6 #(
    .INIT(64'hDDDDDDDDD5D5D555)) 
    \current_us[47]_i_32 
       (.I0(\current_us_reg[47]_i_60_n_3 ),
        .I1(\current_us_reg[47]_i_61_n_7 ),
        .I2(\current_us_reg[47]_i_62_n_5 ),
        .I3(\current_us_reg[47]_i_62_n_7 ),
        .I4(\current_us_reg[47]_i_62_n_6 ),
        .I5(\current_us_reg[47]_i_62_n_4 ),
        .O(\current_us[47]_i_32_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \current_us[47]_i_33 
       (.I0(\current_us_reg[47]_i_61_n_6 ),
        .I1(\current_us_reg[47]_i_61_n_4 ),
        .I2(\current_us_reg[47]_i_61_n_5 ),
        .I3(\current_us_reg[47]_i_59_n_6 ),
        .I4(\current_us_reg[47]_i_59_n_7 ),
        .O(\current_us[47]_i_33_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[47]_i_35 
       (.I0(\pending_reg[2] [6]),
        .I1(current_us[38]),
        .I2(current_us[39]),
        .I3(\pending_reg[2] [7]),
        .O(\current_us[47]_i_35_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[47]_i_36 
       (.I0(\pending_reg[2] [4]),
        .I1(current_us[36]),
        .I2(current_us[37]),
        .I3(\pending_reg[2] [5]),
        .O(\current_us[47]_i_36_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[47]_i_37 
       (.I0(\pending_reg[2] [2]),
        .I1(current_us[34]),
        .I2(current_us[35]),
        .I3(\pending_reg[2] [3]),
        .O(\current_us[47]_i_37_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[47]_i_38 
       (.I0(\pending_reg[2] [0]),
        .I1(current_us[32]),
        .I2(current_us[33]),
        .I3(\pending_reg[2] [1]),
        .O(\current_us[47]_i_38_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[47]_i_39 
       (.I0(current_us[38]),
        .I1(\pending_reg[2] [6]),
        .I2(\pending_reg[2] [7]),
        .I3(current_us[39]),
        .O(\current_us[47]_i_39_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[47]_i_40 
       (.I0(current_us[36]),
        .I1(\pending_reg[2] [4]),
        .I2(\pending_reg[2] [5]),
        .I3(current_us[37]),
        .O(\current_us[47]_i_40_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[47]_i_41 
       (.I0(current_us[34]),
        .I1(\pending_reg[2] [2]),
        .I2(\pending_reg[2] [3]),
        .I3(current_us[35]),
        .O(\current_us[47]_i_41_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[47]_i_42 
       (.I0(current_us[32]),
        .I1(\pending_reg[2] [0]),
        .I2(\pending_reg[2] [1]),
        .I3(current_us[33]),
        .O(\current_us[47]_i_42_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[47]_i_43 
       (.I0(current_us[38]),
        .I1(\pending_reg[2] [6]),
        .I2(\pending_reg[2] [7]),
        .I3(current_us[39]),
        .O(\current_us[47]_i_43_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[47]_i_44 
       (.I0(current_us[36]),
        .I1(\pending_reg[2] [4]),
        .I2(\pending_reg[2] [5]),
        .I3(current_us[37]),
        .O(\current_us[47]_i_44_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[47]_i_45 
       (.I0(current_us[34]),
        .I1(\pending_reg[2] [2]),
        .I2(\pending_reg[2] [3]),
        .I3(current_us[35]),
        .O(\current_us[47]_i_45_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[47]_i_46 
       (.I0(current_us[32]),
        .I1(\pending_reg[2] [0]),
        .I2(\pending_reg[2] [1]),
        .I3(current_us[33]),
        .O(\current_us[47]_i_46_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[47]_i_47 
       (.I0(current_us[38]),
        .I1(\pending_reg[2] [6]),
        .I2(\pending_reg[2] [7]),
        .I3(current_us[39]),
        .O(\current_us[47]_i_47_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[47]_i_48 
       (.I0(current_us[36]),
        .I1(\pending_reg[2] [4]),
        .I2(\pending_reg[2] [5]),
        .I3(current_us[37]),
        .O(\current_us[47]_i_48_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[47]_i_49 
       (.I0(current_us[34]),
        .I1(\pending_reg[2] [2]),
        .I2(\pending_reg[2] [3]),
        .I3(current_us[35]),
        .O(\current_us[47]_i_49_n_0 ));
  LUT5 #(
    .INIT(32'h00000001)) 
    \current_us[47]_i_5 
       (.I0(\current_us[47]_i_26_n_0 ),
        .I1(\current_us_reg[47]_i_27_n_5 ),
        .I2(\current_us_reg[47]_i_27_n_4 ),
        .I3(\current_us[47]_i_28_n_0 ),
        .I4(\current_us[47]_i_29_n_0 ),
        .O(\current_us[47]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[47]_i_50 
       (.I0(current_us[32]),
        .I1(\pending_reg[2] [0]),
        .I2(\pending_reg[2] [1]),
        .I3(current_us[33]),
        .O(\current_us[47]_i_50_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[47]_i_52 
       (.I0(\pending_reg[2] [15]),
        .I1(current_us[47]),
        .O(\current_us[47]_i_52_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[47]_i_53 
       (.I0(\pending_reg[2] [14]),
        .I1(current_us[46]),
        .O(\current_us[47]_i_53_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[47]_i_54 
       (.I0(\pending_reg[2] [13]),
        .I1(current_us[45]),
        .O(\current_us[47]_i_54_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[47]_i_55 
       (.I0(\pending_reg[2] [12]),
        .I1(current_us[44]),
        .O(\current_us[47]_i_55_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[47]_i_63 
       (.I0(current_us[47]),
        .O(\current_us[47]_i_63_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[47]_i_64 
       (.I0(current_us[46]),
        .O(\current_us[47]_i_64_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[47]_i_65 
       (.I0(current_us[45]),
        .O(\current_us[47]_i_65_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[47]_i_66 
       (.I0(\pending_reg[2] [11]),
        .I1(current_us[43]),
        .O(\current_us[47]_i_66_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[47]_i_67 
       (.I0(\pending_reg[2] [10]),
        .I1(current_us[42]),
        .O(\current_us[47]_i_67_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[47]_i_68 
       (.I0(\pending_reg[2] [9]),
        .I1(current_us[41]),
        .O(\current_us[47]_i_68_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[47]_i_69 
       (.I0(\pending_reg[2] [8]),
        .I1(current_us[40]),
        .O(\current_us[47]_i_69_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[47]_i_7 
       (.I0(\pending_reg[2] [15]),
        .I1(\current_us[47]_i_30_n_0 ),
        .I2(\current_us[47]_i_31_n_0 ),
        .I3(\current_us[47]_i_32_n_0 ),
        .I4(\current_us[47]_i_33_n_0 ),
        .I5(position19_in[15]),
        .O(\current_us[47]_i_7_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[47]_i_70 
       (.I0(\pending_reg[2] [7]),
        .I1(current_us[39]),
        .O(\current_us[47]_i_70_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[47]_i_71 
       (.I0(\pending_reg[2] [6]),
        .I1(current_us[38]),
        .O(\current_us[47]_i_71_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[47]_i_72 
       (.I0(\pending_reg[2] [5]),
        .I1(current_us[37]),
        .O(\current_us[47]_i_72_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[47]_i_73 
       (.I0(\pending_reg[2] [4]),
        .I1(current_us[36]),
        .O(\current_us[47]_i_73_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[47]_i_74 
       (.I0(\pending_reg[2] [3]),
        .I1(current_us[35]),
        .O(\current_us[47]_i_74_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[47]_i_75 
       (.I0(\pending_reg[2] [2]),
        .I1(current_us[34]),
        .O(\current_us[47]_i_75_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[47]_i_76 
       (.I0(\pending_reg[2] [1]),
        .I1(current_us[33]),
        .O(\current_us[47]_i_76_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[47]_i_77 
       (.I0(\pending_reg[2] [0]),
        .I1(current_us[32]),
        .O(\current_us[47]_i_77_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[47]_i_78 
       (.I0(current_us[43]),
        .I1(\pending_reg[2] [11]),
        .O(\current_us[47]_i_78_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[47]_i_79 
       (.I0(current_us[42]),
        .I1(\pending_reg[2] [10]),
        .O(\current_us[47]_i_79_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[47]_i_80 
       (.I0(current_us[41]),
        .I1(\pending_reg[2] [9]),
        .O(\current_us[47]_i_80_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[47]_i_81 
       (.I0(current_us[40]),
        .I1(\pending_reg[2] [8]),
        .O(\current_us[47]_i_81_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[47]_i_82 
       (.I0(current_us[39]),
        .I1(\pending_reg[2] [7]),
        .O(\current_us[47]_i_82_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[47]_i_83 
       (.I0(current_us[38]),
        .I1(\pending_reg[2] [6]),
        .O(\current_us[47]_i_83_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[47]_i_84 
       (.I0(current_us[37]),
        .I1(\pending_reg[2] [5]),
        .O(\current_us[47]_i_84_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[47]_i_85 
       (.I0(current_us[36]),
        .I1(\pending_reg[2] [4]),
        .O(\current_us[47]_i_85_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[47]_i_86 
       (.I0(current_us[35]),
        .I1(\pending_reg[2] [3]),
        .O(\current_us[47]_i_86_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[47]_i_87 
       (.I0(current_us[34]),
        .I1(\pending_reg[2] [2]),
        .O(\current_us[47]_i_87_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[47]_i_88 
       (.I0(current_us[33]),
        .I1(\pending_reg[2] [1]),
        .O(\current_us[47]_i_88_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[47]_i_89 
       (.I0(current_us[32]),
        .I1(\pending_reg[2] [0]),
        .O(\current_us[47]_i_89_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[47]_i_9 
       (.I0(\pending_reg[2] [14]),
        .I1(current_us[46]),
        .I2(current_us[47]),
        .I3(\pending_reg[2] [15]),
        .O(\current_us[47]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hFFB8FFFF47000000)) 
    \current_us[48]_i_1 
       (.I0(\current_us[63]_i_5_n_0 ),
        .I1(position117_in),
        .I2(\current_us[48]_i_2_n_0 ),
        .I3(current_us[48]),
        .I4(armed),
        .I5(\pending_reg[3] [0]),
        .O(p_34_out[48]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT5 #(
    .INIT(32'h00000001)) 
    \current_us[48]_i_2 
       (.I0(\current_us[63]_i_30_n_0 ),
        .I1(\current_us_reg[48]_i_3_n_5 ),
        .I2(\current_us_reg[48]_i_3_n_4 ),
        .I3(\current_us[63]_i_32_n_0 ),
        .I4(\current_us[63]_i_33_n_0 ),
        .O(\current_us[48]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[48]_i_4 
       (.I0(current_us[63]),
        .I1(\pending_reg[3] [15]),
        .O(\current_us[48]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[48]_i_5 
       (.I0(current_us[62]),
        .I1(\pending_reg[3] [14]),
        .O(\current_us[48]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[48]_i_6 
       (.I0(current_us[61]),
        .I1(\pending_reg[3] [13]),
        .O(\current_us[48]_i_6_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[48]_i_7 
       (.I0(current_us[60]),
        .I1(\pending_reg[3] [12]),
        .O(\current_us[48]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[49]_i_1 
       (.I0(\current_us[63]_i_5_n_0 ),
        .I1(position116_in[1]),
        .I2(position117_in),
        .I3(\current_us[49]_i_3_n_0 ),
        .I4(armed),
        .I5(\pending_reg[3] [1]),
        .O(p_34_out[49]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[49]_i_3 
       (.I0(\pending_reg[3] [1]),
        .I1(\current_us[63]_i_30_n_0 ),
        .I2(\current_us[63]_i_31_n_0 ),
        .I3(\current_us[63]_i_32_n_0 ),
        .I4(\current_us[63]_i_33_n_0 ),
        .I5(current_us[49]),
        .O(\current_us[49]_i_3_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[49]_i_4 
       (.I0(current_us[51]),
        .O(\current_us[49]_i_4_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[49]_i_5 
       (.I0(current_us[50]),
        .O(\current_us[49]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[4]_i_1 
       (.I0(\current_us[15]_i_5_n_0 ),
        .I1(position11_in[4]),
        .I2(position12_in),
        .I3(\current_us[4]_i_3_n_0 ),
        .I4(armed),
        .I5(\pending_reg[0] [4]),
        .O(p_34_out[4]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[4]_i_3 
       (.I0(\pending_reg[0] [4]),
        .I1(\current_us[15]_i_30_n_0 ),
        .I2(\current_us[15]_i_31_n_0 ),
        .I3(\current_us[15]_i_32_n_0 ),
        .I4(\current_us[15]_i_33_n_0 ),
        .I5(position1[4]),
        .O(\current_us[4]_i_3_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[4]_i_4 
       (.I0(current_us[4]),
        .O(\current_us[4]_i_4_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[4]_i_5 
       (.I0(current_us[2]),
        .O(\current_us[4]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[50]_i_1 
       (.I0(\current_us[63]_i_5_n_0 ),
        .I1(position116_in[2]),
        .I2(position117_in),
        .I3(\current_us[50]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[3] [2]),
        .O(p_34_out[50]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[50]_i_2 
       (.I0(\pending_reg[3] [2]),
        .I1(\current_us[63]_i_30_n_0 ),
        .I2(\current_us[63]_i_31_n_0 ),
        .I3(\current_us[63]_i_32_n_0 ),
        .I4(\current_us[63]_i_33_n_0 ),
        .I5(position114_in[2]),
        .O(\current_us[50]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[51]_i_1 
       (.I0(\current_us[63]_i_5_n_0 ),
        .I1(position116_in[3]),
        .I2(position117_in),
        .I3(\current_us[51]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[3] [3]),
        .O(p_34_out[51]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[51]_i_2 
       (.I0(\pending_reg[3] [3]),
        .I1(\current_us[63]_i_30_n_0 ),
        .I2(\current_us[63]_i_31_n_0 ),
        .I3(\current_us[63]_i_32_n_0 ),
        .I4(\current_us[63]_i_33_n_0 ),
        .I5(position114_in[3]),
        .O(\current_us[51]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[52]_i_1 
       (.I0(\current_us[63]_i_5_n_0 ),
        .I1(position116_in[4]),
        .I2(position117_in),
        .I3(\current_us[52]_i_3_n_0 ),
        .I4(armed),
        .I5(\pending_reg[3] [4]),
        .O(p_34_out[52]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[52]_i_3 
       (.I0(\pending_reg[3] [4]),
        .I1(\current_us[63]_i_30_n_0 ),
        .I2(\current_us[63]_i_31_n_0 ),
        .I3(\current_us[63]_i_32_n_0 ),
        .I4(\current_us[63]_i_33_n_0 ),
        .I5(position114_in[4]),
        .O(\current_us[52]_i_3_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[52]_i_4 
       (.I0(current_us[52]),
        .O(\current_us[52]_i_4_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[52]_i_5 
       (.I0(current_us[50]),
        .O(\current_us[52]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[53]_i_1 
       (.I0(\current_us[63]_i_5_n_0 ),
        .I1(position116_in[5]),
        .I2(position117_in),
        .I3(\current_us[53]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[3] [5]),
        .O(p_34_out[53]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[53]_i_2 
       (.I0(\pending_reg[3] [5]),
        .I1(\current_us[63]_i_30_n_0 ),
        .I2(\current_us[63]_i_31_n_0 ),
        .I3(\current_us[63]_i_32_n_0 ),
        .I4(\current_us[63]_i_33_n_0 ),
        .I5(position114_in[5]),
        .O(\current_us[53]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[54]_i_1 
       (.I0(\current_us[63]_i_5_n_0 ),
        .I1(position116_in[6]),
        .I2(position117_in),
        .I3(\current_us[54]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[3] [6]),
        .O(p_34_out[54]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[54]_i_2 
       (.I0(\pending_reg[3] [6]),
        .I1(\current_us[63]_i_30_n_0 ),
        .I2(\current_us[63]_i_31_n_0 ),
        .I3(\current_us[63]_i_32_n_0 ),
        .I4(\current_us[63]_i_33_n_0 ),
        .I5(position114_in[6]),
        .O(\current_us[54]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[55]_i_1 
       (.I0(\current_us[63]_i_5_n_0 ),
        .I1(position116_in[7]),
        .I2(position117_in),
        .I3(\current_us[55]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[3] [7]),
        .O(p_34_out[55]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[55]_i_2 
       (.I0(\pending_reg[3] [7]),
        .I1(\current_us[63]_i_30_n_0 ),
        .I2(\current_us[63]_i_31_n_0 ),
        .I3(\current_us[63]_i_32_n_0 ),
        .I4(\current_us[63]_i_33_n_0 ),
        .I5(position114_in[7]),
        .O(\current_us[55]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[56]_i_1 
       (.I0(\current_us[63]_i_5_n_0 ),
        .I1(position116_in[8]),
        .I2(position117_in),
        .I3(\current_us[56]_i_3_n_0 ),
        .I4(armed),
        .I5(\pending_reg[3] [8]),
        .O(p_34_out[56]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[56]_i_3 
       (.I0(\pending_reg[3] [8]),
        .I1(\current_us[63]_i_30_n_0 ),
        .I2(\current_us[63]_i_31_n_0 ),
        .I3(\current_us[63]_i_32_n_0 ),
        .I4(\current_us[63]_i_33_n_0 ),
        .I5(position114_in[8]),
        .O(\current_us[56]_i_3_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[56]_i_5 
       (.I0(current_us[56]),
        .O(\current_us[56]_i_5_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[56]_i_6 
       (.I0(current_us[55]),
        .O(\current_us[56]_i_6_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[56]_i_7 
       (.I0(current_us[54]),
        .O(\current_us[56]_i_7_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[56]_i_8 
       (.I0(current_us[53]),
        .O(\current_us[56]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[57]_i_1 
       (.I0(\current_us[63]_i_5_n_0 ),
        .I1(position116_in[9]),
        .I2(position117_in),
        .I3(\current_us[57]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[3] [9]),
        .O(p_34_out[57]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[57]_i_2 
       (.I0(\pending_reg[3] [9]),
        .I1(\current_us[63]_i_30_n_0 ),
        .I2(\current_us[63]_i_31_n_0 ),
        .I3(\current_us[63]_i_32_n_0 ),
        .I4(\current_us[63]_i_33_n_0 ),
        .I5(position114_in[9]),
        .O(\current_us[57]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[58]_i_1 
       (.I0(\current_us[63]_i_5_n_0 ),
        .I1(position116_in[10]),
        .I2(position117_in),
        .I3(\current_us[58]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[3] [10]),
        .O(p_34_out[58]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[58]_i_2 
       (.I0(\pending_reg[3] [10]),
        .I1(\current_us[63]_i_30_n_0 ),
        .I2(\current_us[63]_i_31_n_0 ),
        .I3(\current_us[63]_i_32_n_0 ),
        .I4(\current_us[63]_i_33_n_0 ),
        .I5(position114_in[10]),
        .O(\current_us[58]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[59]_i_1 
       (.I0(\current_us[63]_i_5_n_0 ),
        .I1(position116_in[11]),
        .I2(position117_in),
        .I3(\current_us[59]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[3] [11]),
        .O(p_34_out[59]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[59]_i_2 
       (.I0(\pending_reg[3] [11]),
        .I1(\current_us[63]_i_30_n_0 ),
        .I2(\current_us[63]_i_31_n_0 ),
        .I3(\current_us[63]_i_32_n_0 ),
        .I4(\current_us[63]_i_33_n_0 ),
        .I5(position114_in[11]),
        .O(\current_us[59]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[5]_i_1 
       (.I0(\current_us[15]_i_5_n_0 ),
        .I1(position11_in[5]),
        .I2(position12_in),
        .I3(\current_us[5]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[0] [5]),
        .O(p_34_out[5]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[5]_i_2 
       (.I0(\pending_reg[0] [5]),
        .I1(\current_us[15]_i_30_n_0 ),
        .I2(\current_us[15]_i_31_n_0 ),
        .I3(\current_us[15]_i_32_n_0 ),
        .I4(\current_us[15]_i_33_n_0 ),
        .I5(position1[5]),
        .O(\current_us[5]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[60]_i_1 
       (.I0(\current_us[63]_i_5_n_0 ),
        .I1(position116_in[12]),
        .I2(position117_in),
        .I3(\current_us[60]_i_3_n_0 ),
        .I4(armed),
        .I5(\pending_reg[3] [12]),
        .O(p_34_out[60]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[60]_i_3 
       (.I0(\pending_reg[3] [12]),
        .I1(\current_us[63]_i_30_n_0 ),
        .I2(\current_us[63]_i_31_n_0 ),
        .I3(\current_us[63]_i_32_n_0 ),
        .I4(\current_us[63]_i_33_n_0 ),
        .I5(position114_in[12]),
        .O(\current_us[60]_i_3_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[60]_i_5 
       (.I0(current_us[60]),
        .O(\current_us[60]_i_5_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[60]_i_6 
       (.I0(current_us[59]),
        .O(\current_us[60]_i_6_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[60]_i_7 
       (.I0(current_us[58]),
        .O(\current_us[60]_i_7_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[60]_i_8 
       (.I0(current_us[57]),
        .O(\current_us[60]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[61]_i_1 
       (.I0(\current_us[63]_i_5_n_0 ),
        .I1(position116_in[13]),
        .I2(position117_in),
        .I3(\current_us[61]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[3] [13]),
        .O(p_34_out[61]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[61]_i_2 
       (.I0(\pending_reg[3] [13]),
        .I1(\current_us[63]_i_30_n_0 ),
        .I2(\current_us[63]_i_31_n_0 ),
        .I3(\current_us[63]_i_32_n_0 ),
        .I4(\current_us[63]_i_33_n_0 ),
        .I5(position114_in[13]),
        .O(\current_us[61]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[62]_i_1 
       (.I0(\current_us[63]_i_5_n_0 ),
        .I1(position116_in[14]),
        .I2(position117_in),
        .I3(\current_us[62]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[3] [14]),
        .O(p_34_out[62]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[62]_i_2 
       (.I0(\pending_reg[3] [14]),
        .I1(\current_us[63]_i_30_n_0 ),
        .I2(\current_us[63]_i_31_n_0 ),
        .I3(\current_us[63]_i_32_n_0 ),
        .I4(\current_us[63]_i_33_n_0 ),
        .I5(position114_in[14]),
        .O(\current_us[62]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h2222202200000000)) 
    \current_us[63]_i_1 
       (.I0(\sub_tick[4]_i_2_n_0 ),
        .I1(\current_us[95]_i_4_n_0 ),
        .I2(position117_in),
        .I3(armed),
        .I4(p_7_in),
        .I5(armed_i_2_n_0),
        .O(\current_us[63]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[63]_i_10 
       (.I0(\pending_reg[3] [12]),
        .I1(current_us[60]),
        .I2(current_us[61]),
        .I3(\pending_reg[3] [13]),
        .O(\current_us[63]_i_10_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[63]_i_11 
       (.I0(\pending_reg[3] [10]),
        .I1(current_us[58]),
        .I2(current_us[59]),
        .I3(\pending_reg[3] [11]),
        .O(\current_us[63]_i_11_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[63]_i_12 
       (.I0(\pending_reg[3] [8]),
        .I1(current_us[56]),
        .I2(current_us[57]),
        .I3(\pending_reg[3] [9]),
        .O(\current_us[63]_i_12_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[63]_i_13 
       (.I0(current_us[62]),
        .I1(\pending_reg[3] [14]),
        .I2(\pending_reg[3] [15]),
        .I3(current_us[63]),
        .O(\current_us[63]_i_13_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[63]_i_14 
       (.I0(current_us[60]),
        .I1(\pending_reg[3] [12]),
        .I2(\pending_reg[3] [13]),
        .I3(current_us[61]),
        .O(\current_us[63]_i_14_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[63]_i_15 
       (.I0(current_us[58]),
        .I1(\pending_reg[3] [10]),
        .I2(\pending_reg[3] [11]),
        .I3(current_us[59]),
        .O(\current_us[63]_i_15_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[63]_i_16 
       (.I0(current_us[56]),
        .I1(\pending_reg[3] [8]),
        .I2(\pending_reg[3] [9]),
        .I3(current_us[57]),
        .O(\current_us[63]_i_16_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[63]_i_18 
       (.I0(current_us[62]),
        .I1(\pending_reg[3] [14]),
        .I2(\pending_reg[3] [15]),
        .I3(current_us[63]),
        .O(\current_us[63]_i_18_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[63]_i_19 
       (.I0(current_us[60]),
        .I1(\pending_reg[3] [12]),
        .I2(\pending_reg[3] [13]),
        .I3(current_us[61]),
        .O(\current_us[63]_i_19_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[63]_i_2 
       (.I0(\current_us[63]_i_5_n_0 ),
        .I1(position116_in[15]),
        .I2(position117_in),
        .I3(\current_us[63]_i_7_n_0 ),
        .I4(armed),
        .I5(\pending_reg[3] [15]),
        .O(p_34_out[63]));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[63]_i_20 
       (.I0(current_us[58]),
        .I1(\pending_reg[3] [10]),
        .I2(\pending_reg[3] [11]),
        .I3(current_us[59]),
        .O(\current_us[63]_i_20_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[63]_i_21 
       (.I0(current_us[56]),
        .I1(\pending_reg[3] [8]),
        .I2(\pending_reg[3] [9]),
        .I3(current_us[57]),
        .O(\current_us[63]_i_21_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[63]_i_22 
       (.I0(current_us[62]),
        .I1(\pending_reg[3] [14]),
        .I2(\pending_reg[3] [15]),
        .I3(current_us[63]),
        .O(\current_us[63]_i_22_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[63]_i_23 
       (.I0(current_us[60]),
        .I1(\pending_reg[3] [12]),
        .I2(\pending_reg[3] [13]),
        .I3(current_us[61]),
        .O(\current_us[63]_i_23_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[63]_i_24 
       (.I0(current_us[58]),
        .I1(\pending_reg[3] [10]),
        .I2(\pending_reg[3] [11]),
        .I3(current_us[59]),
        .O(\current_us[63]_i_24_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[63]_i_25 
       (.I0(current_us[56]),
        .I1(\pending_reg[3] [8]),
        .I2(\pending_reg[3] [9]),
        .I3(current_us[57]),
        .O(\current_us[63]_i_25_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \current_us[63]_i_26 
       (.I0(\current_us_reg[63]_i_51_n_5 ),
        .I1(\current_us_reg[63]_i_51_n_4 ),
        .I2(\current_us_reg[63]_i_27_n_7 ),
        .I3(\current_us_reg[63]_i_27_n_6 ),
        .O(\current_us[63]_i_26_n_0 ));
  LUT6 #(
    .INIT(64'hDDDDDDDDD5D5D555)) 
    \current_us[63]_i_28 
       (.I0(\current_us_reg[63]_i_56_n_3 ),
        .I1(\current_us_reg[63]_i_57_n_7 ),
        .I2(\current_us_reg[63]_i_58_n_5 ),
        .I3(\current_us_reg[63]_i_58_n_7 ),
        .I4(\current_us_reg[63]_i_58_n_6 ),
        .I5(\current_us_reg[63]_i_58_n_4 ),
        .O(\current_us[63]_i_28_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \current_us[63]_i_29 
       (.I0(\current_us_reg[63]_i_57_n_6 ),
        .I1(\current_us_reg[63]_i_57_n_4 ),
        .I2(\current_us_reg[63]_i_57_n_5 ),
        .I3(\current_us_reg[63]_i_51_n_6 ),
        .I4(\current_us_reg[63]_i_51_n_7 ),
        .O(\current_us[63]_i_29_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \current_us[63]_i_30 
       (.I0(\current_us_reg[63]_i_59_n_5 ),
        .I1(\current_us_reg[63]_i_59_n_4 ),
        .I2(\current_us_reg[48]_i_3_n_7 ),
        .I3(\current_us_reg[48]_i_3_n_6 ),
        .O(\current_us[63]_i_30_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \current_us[63]_i_31 
       (.I0(\current_us_reg[48]_i_3_n_4 ),
        .I1(\current_us_reg[48]_i_3_n_5 ),
        .O(\current_us[63]_i_31_n_0 ));
  LUT6 #(
    .INIT(64'hDDDDDDDDD5D5D555)) 
    \current_us[63]_i_32 
       (.I0(\current_us_reg[63]_i_60_n_3 ),
        .I1(\current_us_reg[63]_i_61_n_7 ),
        .I2(\current_us_reg[63]_i_62_n_5 ),
        .I3(\current_us_reg[63]_i_62_n_7 ),
        .I4(\current_us_reg[63]_i_62_n_6 ),
        .I5(\current_us_reg[63]_i_62_n_4 ),
        .O(\current_us[63]_i_32_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \current_us[63]_i_33 
       (.I0(\current_us_reg[63]_i_61_n_6 ),
        .I1(\current_us_reg[63]_i_61_n_4 ),
        .I2(\current_us_reg[63]_i_61_n_5 ),
        .I3(\current_us_reg[63]_i_59_n_6 ),
        .I4(\current_us_reg[63]_i_59_n_7 ),
        .O(\current_us[63]_i_33_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[63]_i_35 
       (.I0(\pending_reg[3] [6]),
        .I1(current_us[54]),
        .I2(current_us[55]),
        .I3(\pending_reg[3] [7]),
        .O(\current_us[63]_i_35_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[63]_i_36 
       (.I0(\pending_reg[3] [4]),
        .I1(current_us[52]),
        .I2(current_us[53]),
        .I3(\pending_reg[3] [5]),
        .O(\current_us[63]_i_36_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[63]_i_37 
       (.I0(\pending_reg[3] [2]),
        .I1(current_us[50]),
        .I2(current_us[51]),
        .I3(\pending_reg[3] [3]),
        .O(\current_us[63]_i_37_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[63]_i_38 
       (.I0(\pending_reg[3] [0]),
        .I1(current_us[48]),
        .I2(current_us[49]),
        .I3(\pending_reg[3] [1]),
        .O(\current_us[63]_i_38_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[63]_i_39 
       (.I0(current_us[54]),
        .I1(\pending_reg[3] [6]),
        .I2(\pending_reg[3] [7]),
        .I3(current_us[55]),
        .O(\current_us[63]_i_39_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[63]_i_40 
       (.I0(current_us[52]),
        .I1(\pending_reg[3] [4]),
        .I2(\pending_reg[3] [5]),
        .I3(current_us[53]),
        .O(\current_us[63]_i_40_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[63]_i_41 
       (.I0(current_us[50]),
        .I1(\pending_reg[3] [2]),
        .I2(\pending_reg[3] [3]),
        .I3(current_us[51]),
        .O(\current_us[63]_i_41_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[63]_i_42 
       (.I0(current_us[48]),
        .I1(\pending_reg[3] [0]),
        .I2(\pending_reg[3] [1]),
        .I3(current_us[49]),
        .O(\current_us[63]_i_42_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[63]_i_43 
       (.I0(current_us[54]),
        .I1(\pending_reg[3] [6]),
        .I2(\pending_reg[3] [7]),
        .I3(current_us[55]),
        .O(\current_us[63]_i_43_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[63]_i_44 
       (.I0(current_us[52]),
        .I1(\pending_reg[3] [4]),
        .I2(\pending_reg[3] [5]),
        .I3(current_us[53]),
        .O(\current_us[63]_i_44_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[63]_i_45 
       (.I0(current_us[50]),
        .I1(\pending_reg[3] [2]),
        .I2(\pending_reg[3] [3]),
        .I3(current_us[51]),
        .O(\current_us[63]_i_45_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[63]_i_46 
       (.I0(current_us[48]),
        .I1(\pending_reg[3] [0]),
        .I2(\pending_reg[3] [1]),
        .I3(current_us[49]),
        .O(\current_us[63]_i_46_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[63]_i_47 
       (.I0(current_us[54]),
        .I1(\pending_reg[3] [6]),
        .I2(\pending_reg[3] [7]),
        .I3(current_us[55]),
        .O(\current_us[63]_i_47_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[63]_i_48 
       (.I0(current_us[52]),
        .I1(\pending_reg[3] [4]),
        .I2(\pending_reg[3] [5]),
        .I3(current_us[53]),
        .O(\current_us[63]_i_48_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[63]_i_49 
       (.I0(current_us[50]),
        .I1(\pending_reg[3] [2]),
        .I2(\pending_reg[3] [3]),
        .I3(current_us[51]),
        .O(\current_us[63]_i_49_n_0 ));
  LUT5 #(
    .INIT(32'h00000001)) 
    \current_us[63]_i_5 
       (.I0(\current_us[63]_i_26_n_0 ),
        .I1(\current_us_reg[63]_i_27_n_5 ),
        .I2(\current_us_reg[63]_i_27_n_4 ),
        .I3(\current_us[63]_i_28_n_0 ),
        .I4(\current_us[63]_i_29_n_0 ),
        .O(\current_us[63]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[63]_i_50 
       (.I0(current_us[48]),
        .I1(\pending_reg[3] [0]),
        .I2(\pending_reg[3] [1]),
        .I3(current_us[49]),
        .O(\current_us[63]_i_50_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[63]_i_52 
       (.I0(\pending_reg[3] [15]),
        .I1(current_us[63]),
        .O(\current_us[63]_i_52_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[63]_i_53 
       (.I0(\pending_reg[3] [14]),
        .I1(current_us[62]),
        .O(\current_us[63]_i_53_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[63]_i_54 
       (.I0(\pending_reg[3] [13]),
        .I1(current_us[61]),
        .O(\current_us[63]_i_54_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[63]_i_55 
       (.I0(\pending_reg[3] [12]),
        .I1(current_us[60]),
        .O(\current_us[63]_i_55_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[63]_i_63 
       (.I0(current_us[63]),
        .O(\current_us[63]_i_63_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[63]_i_64 
       (.I0(current_us[62]),
        .O(\current_us[63]_i_64_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[63]_i_65 
       (.I0(current_us[61]),
        .O(\current_us[63]_i_65_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[63]_i_66 
       (.I0(\pending_reg[3] [11]),
        .I1(current_us[59]),
        .O(\current_us[63]_i_66_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[63]_i_67 
       (.I0(\pending_reg[3] [10]),
        .I1(current_us[58]),
        .O(\current_us[63]_i_67_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[63]_i_68 
       (.I0(\pending_reg[3] [9]),
        .I1(current_us[57]),
        .O(\current_us[63]_i_68_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[63]_i_69 
       (.I0(\pending_reg[3] [8]),
        .I1(current_us[56]),
        .O(\current_us[63]_i_69_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[63]_i_7 
       (.I0(\pending_reg[3] [15]),
        .I1(\current_us[63]_i_30_n_0 ),
        .I2(\current_us[63]_i_31_n_0 ),
        .I3(\current_us[63]_i_32_n_0 ),
        .I4(\current_us[63]_i_33_n_0 ),
        .I5(position114_in[15]),
        .O(\current_us[63]_i_7_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[63]_i_70 
       (.I0(\pending_reg[3] [7]),
        .I1(current_us[55]),
        .O(\current_us[63]_i_70_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[63]_i_71 
       (.I0(\pending_reg[3] [6]),
        .I1(current_us[54]),
        .O(\current_us[63]_i_71_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[63]_i_72 
       (.I0(\pending_reg[3] [5]),
        .I1(current_us[53]),
        .O(\current_us[63]_i_72_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[63]_i_73 
       (.I0(\pending_reg[3] [4]),
        .I1(current_us[52]),
        .O(\current_us[63]_i_73_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[63]_i_74 
       (.I0(\pending_reg[3] [3]),
        .I1(current_us[51]),
        .O(\current_us[63]_i_74_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[63]_i_75 
       (.I0(\pending_reg[3] [2]),
        .I1(current_us[50]),
        .O(\current_us[63]_i_75_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[63]_i_76 
       (.I0(\pending_reg[3] [1]),
        .I1(current_us[49]),
        .O(\current_us[63]_i_76_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[63]_i_77 
       (.I0(\pending_reg[3] [0]),
        .I1(current_us[48]),
        .O(\current_us[63]_i_77_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[63]_i_78 
       (.I0(current_us[59]),
        .I1(\pending_reg[3] [11]),
        .O(\current_us[63]_i_78_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[63]_i_79 
       (.I0(current_us[58]),
        .I1(\pending_reg[3] [10]),
        .O(\current_us[63]_i_79_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[63]_i_80 
       (.I0(current_us[57]),
        .I1(\pending_reg[3] [9]),
        .O(\current_us[63]_i_80_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[63]_i_81 
       (.I0(current_us[56]),
        .I1(\pending_reg[3] [8]),
        .O(\current_us[63]_i_81_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[63]_i_82 
       (.I0(current_us[55]),
        .I1(\pending_reg[3] [7]),
        .O(\current_us[63]_i_82_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[63]_i_83 
       (.I0(current_us[54]),
        .I1(\pending_reg[3] [6]),
        .O(\current_us[63]_i_83_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[63]_i_84 
       (.I0(current_us[53]),
        .I1(\pending_reg[3] [5]),
        .O(\current_us[63]_i_84_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[63]_i_85 
       (.I0(current_us[52]),
        .I1(\pending_reg[3] [4]),
        .O(\current_us[63]_i_85_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[63]_i_86 
       (.I0(current_us[51]),
        .I1(\pending_reg[3] [3]),
        .O(\current_us[63]_i_86_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[63]_i_87 
       (.I0(current_us[50]),
        .I1(\pending_reg[3] [2]),
        .O(\current_us[63]_i_87_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[63]_i_88 
       (.I0(current_us[49]),
        .I1(\pending_reg[3] [1]),
        .O(\current_us[63]_i_88_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[63]_i_89 
       (.I0(current_us[48]),
        .I1(\pending_reg[3] [0]),
        .O(\current_us[63]_i_89_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[63]_i_9 
       (.I0(\pending_reg[3] [14]),
        .I1(current_us[62]),
        .I2(current_us[63]),
        .I3(\pending_reg[3] [15]),
        .O(\current_us[63]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hFFB8FFFF47000000)) 
    \current_us[64]_i_1 
       (.I0(\current_us[79]_i_5_n_0 ),
        .I1(position122_in),
        .I2(\current_us[64]_i_2_n_0 ),
        .I3(current_us[64]),
        .I4(armed),
        .I5(\pending_reg[4] [0]),
        .O(p_34_out[64]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'h00000001)) 
    \current_us[64]_i_2 
       (.I0(\current_us[79]_i_30_n_0 ),
        .I1(\current_us_reg[64]_i_3_n_5 ),
        .I2(\current_us_reg[64]_i_3_n_4 ),
        .I3(\current_us[79]_i_32_n_0 ),
        .I4(\current_us[79]_i_33_n_0 ),
        .O(\current_us[64]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[64]_i_4 
       (.I0(current_us[79]),
        .I1(\pending_reg[4] [15]),
        .O(\current_us[64]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[64]_i_5 
       (.I0(current_us[78]),
        .I1(\pending_reg[4] [14]),
        .O(\current_us[64]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[64]_i_6 
       (.I0(current_us[77]),
        .I1(\pending_reg[4] [13]),
        .O(\current_us[64]_i_6_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[64]_i_7 
       (.I0(current_us[76]),
        .I1(\pending_reg[4] [12]),
        .O(\current_us[64]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[65]_i_1 
       (.I0(\current_us[79]_i_5_n_0 ),
        .I1(position121_in[1]),
        .I2(position122_in),
        .I3(\current_us[65]_i_3_n_0 ),
        .I4(armed),
        .I5(\pending_reg[4] [1]),
        .O(p_34_out[65]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[65]_i_3 
       (.I0(\pending_reg[4] [1]),
        .I1(\current_us[79]_i_30_n_0 ),
        .I2(\current_us[79]_i_31_n_0 ),
        .I3(\current_us[79]_i_32_n_0 ),
        .I4(\current_us[79]_i_33_n_0 ),
        .I5(current_us[65]),
        .O(\current_us[65]_i_3_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[65]_i_4 
       (.I0(current_us[67]),
        .O(\current_us[65]_i_4_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[65]_i_5 
       (.I0(current_us[66]),
        .O(\current_us[65]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[66]_i_1 
       (.I0(\current_us[79]_i_5_n_0 ),
        .I1(position121_in[2]),
        .I2(position122_in),
        .I3(\current_us[66]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[4] [2]),
        .O(p_34_out[66]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[66]_i_2 
       (.I0(\pending_reg[4] [2]),
        .I1(\current_us[79]_i_30_n_0 ),
        .I2(\current_us[79]_i_31_n_0 ),
        .I3(\current_us[79]_i_32_n_0 ),
        .I4(\current_us[79]_i_33_n_0 ),
        .I5(position119_in[2]),
        .O(\current_us[66]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[67]_i_1 
       (.I0(\current_us[79]_i_5_n_0 ),
        .I1(position121_in[3]),
        .I2(position122_in),
        .I3(\current_us[67]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[4] [3]),
        .O(p_34_out[67]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[67]_i_2 
       (.I0(\pending_reg[4] [3]),
        .I1(\current_us[79]_i_30_n_0 ),
        .I2(\current_us[79]_i_31_n_0 ),
        .I3(\current_us[79]_i_32_n_0 ),
        .I4(\current_us[79]_i_33_n_0 ),
        .I5(position119_in[3]),
        .O(\current_us[67]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[68]_i_1 
       (.I0(\current_us[79]_i_5_n_0 ),
        .I1(position121_in[4]),
        .I2(position122_in),
        .I3(\current_us[68]_i_3_n_0 ),
        .I4(armed),
        .I5(\pending_reg[4] [4]),
        .O(p_34_out[68]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[68]_i_3 
       (.I0(\pending_reg[4] [4]),
        .I1(\current_us[79]_i_30_n_0 ),
        .I2(\current_us[79]_i_31_n_0 ),
        .I3(\current_us[79]_i_32_n_0 ),
        .I4(\current_us[79]_i_33_n_0 ),
        .I5(position119_in[4]),
        .O(\current_us[68]_i_3_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[68]_i_4 
       (.I0(current_us[68]),
        .O(\current_us[68]_i_4_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[68]_i_5 
       (.I0(current_us[66]),
        .O(\current_us[68]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[69]_i_1 
       (.I0(\current_us[79]_i_5_n_0 ),
        .I1(position121_in[5]),
        .I2(position122_in),
        .I3(\current_us[69]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[4] [5]),
        .O(p_34_out[69]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[69]_i_2 
       (.I0(\pending_reg[4] [5]),
        .I1(\current_us[79]_i_30_n_0 ),
        .I2(\current_us[79]_i_31_n_0 ),
        .I3(\current_us[79]_i_32_n_0 ),
        .I4(\current_us[79]_i_33_n_0 ),
        .I5(position119_in[5]),
        .O(\current_us[69]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[6]_i_1 
       (.I0(\current_us[15]_i_5_n_0 ),
        .I1(position11_in[6]),
        .I2(position12_in),
        .I3(\current_us[6]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[0] [6]),
        .O(p_34_out[6]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[6]_i_2 
       (.I0(\pending_reg[0] [6]),
        .I1(\current_us[15]_i_30_n_0 ),
        .I2(\current_us[15]_i_31_n_0 ),
        .I3(\current_us[15]_i_32_n_0 ),
        .I4(\current_us[15]_i_33_n_0 ),
        .I5(position1[6]),
        .O(\current_us[6]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[70]_i_1 
       (.I0(\current_us[79]_i_5_n_0 ),
        .I1(position121_in[6]),
        .I2(position122_in),
        .I3(\current_us[70]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[4] [6]),
        .O(p_34_out[70]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[70]_i_2 
       (.I0(\pending_reg[4] [6]),
        .I1(\current_us[79]_i_30_n_0 ),
        .I2(\current_us[79]_i_31_n_0 ),
        .I3(\current_us[79]_i_32_n_0 ),
        .I4(\current_us[79]_i_33_n_0 ),
        .I5(position119_in[6]),
        .O(\current_us[70]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[71]_i_1 
       (.I0(\current_us[79]_i_5_n_0 ),
        .I1(position121_in[7]),
        .I2(position122_in),
        .I3(\current_us[71]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[4] [7]),
        .O(p_34_out[71]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[71]_i_2 
       (.I0(\pending_reg[4] [7]),
        .I1(\current_us[79]_i_30_n_0 ),
        .I2(\current_us[79]_i_31_n_0 ),
        .I3(\current_us[79]_i_32_n_0 ),
        .I4(\current_us[79]_i_33_n_0 ),
        .I5(position119_in[7]),
        .O(\current_us[71]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[72]_i_1 
       (.I0(\current_us[79]_i_5_n_0 ),
        .I1(position121_in[8]),
        .I2(position122_in),
        .I3(\current_us[72]_i_3_n_0 ),
        .I4(armed),
        .I5(\pending_reg[4] [8]),
        .O(p_34_out[72]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[72]_i_3 
       (.I0(\pending_reg[4] [8]),
        .I1(\current_us[79]_i_30_n_0 ),
        .I2(\current_us[79]_i_31_n_0 ),
        .I3(\current_us[79]_i_32_n_0 ),
        .I4(\current_us[79]_i_33_n_0 ),
        .I5(position119_in[8]),
        .O(\current_us[72]_i_3_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[72]_i_5 
       (.I0(current_us[72]),
        .O(\current_us[72]_i_5_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[72]_i_6 
       (.I0(current_us[71]),
        .O(\current_us[72]_i_6_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[72]_i_7 
       (.I0(current_us[70]),
        .O(\current_us[72]_i_7_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[72]_i_8 
       (.I0(current_us[69]),
        .O(\current_us[72]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[73]_i_1 
       (.I0(\current_us[79]_i_5_n_0 ),
        .I1(position121_in[9]),
        .I2(position122_in),
        .I3(\current_us[73]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[4] [9]),
        .O(p_34_out[73]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[73]_i_2 
       (.I0(\pending_reg[4] [9]),
        .I1(\current_us[79]_i_30_n_0 ),
        .I2(\current_us[79]_i_31_n_0 ),
        .I3(\current_us[79]_i_32_n_0 ),
        .I4(\current_us[79]_i_33_n_0 ),
        .I5(position119_in[9]),
        .O(\current_us[73]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[74]_i_1 
       (.I0(\current_us[79]_i_5_n_0 ),
        .I1(position121_in[10]),
        .I2(position122_in),
        .I3(\current_us[74]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[4] [10]),
        .O(p_34_out[74]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[74]_i_2 
       (.I0(\pending_reg[4] [10]),
        .I1(\current_us[79]_i_30_n_0 ),
        .I2(\current_us[79]_i_31_n_0 ),
        .I3(\current_us[79]_i_32_n_0 ),
        .I4(\current_us[79]_i_33_n_0 ),
        .I5(position119_in[10]),
        .O(\current_us[74]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[75]_i_1 
       (.I0(\current_us[79]_i_5_n_0 ),
        .I1(position121_in[11]),
        .I2(position122_in),
        .I3(\current_us[75]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[4] [11]),
        .O(p_34_out[75]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[75]_i_2 
       (.I0(\pending_reg[4] [11]),
        .I1(\current_us[79]_i_30_n_0 ),
        .I2(\current_us[79]_i_31_n_0 ),
        .I3(\current_us[79]_i_32_n_0 ),
        .I4(\current_us[79]_i_33_n_0 ),
        .I5(position119_in[11]),
        .O(\current_us[75]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[76]_i_1 
       (.I0(\current_us[79]_i_5_n_0 ),
        .I1(position121_in[12]),
        .I2(position122_in),
        .I3(\current_us[76]_i_3_n_0 ),
        .I4(armed),
        .I5(\pending_reg[4] [12]),
        .O(p_34_out[76]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[76]_i_3 
       (.I0(\pending_reg[4] [12]),
        .I1(\current_us[79]_i_30_n_0 ),
        .I2(\current_us[79]_i_31_n_0 ),
        .I3(\current_us[79]_i_32_n_0 ),
        .I4(\current_us[79]_i_33_n_0 ),
        .I5(position119_in[12]),
        .O(\current_us[76]_i_3_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[76]_i_5 
       (.I0(current_us[76]),
        .O(\current_us[76]_i_5_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[76]_i_6 
       (.I0(current_us[75]),
        .O(\current_us[76]_i_6_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[76]_i_7 
       (.I0(current_us[74]),
        .O(\current_us[76]_i_7_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[76]_i_8 
       (.I0(current_us[73]),
        .O(\current_us[76]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[77]_i_1 
       (.I0(\current_us[79]_i_5_n_0 ),
        .I1(position121_in[13]),
        .I2(position122_in),
        .I3(\current_us[77]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[4] [13]),
        .O(p_34_out[77]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[77]_i_2 
       (.I0(\pending_reg[4] [13]),
        .I1(\current_us[79]_i_30_n_0 ),
        .I2(\current_us[79]_i_31_n_0 ),
        .I3(\current_us[79]_i_32_n_0 ),
        .I4(\current_us[79]_i_33_n_0 ),
        .I5(position119_in[13]),
        .O(\current_us[77]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[78]_i_1 
       (.I0(\current_us[79]_i_5_n_0 ),
        .I1(position121_in[14]),
        .I2(position122_in),
        .I3(\current_us[78]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[4] [14]),
        .O(p_34_out[78]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[78]_i_2 
       (.I0(\pending_reg[4] [14]),
        .I1(\current_us[79]_i_30_n_0 ),
        .I2(\current_us[79]_i_31_n_0 ),
        .I3(\current_us[79]_i_32_n_0 ),
        .I4(\current_us[79]_i_33_n_0 ),
        .I5(position119_in[14]),
        .O(\current_us[78]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h2222202200000000)) 
    \current_us[79]_i_1 
       (.I0(\sub_tick[4]_i_2_n_0 ),
        .I1(\current_us[95]_i_4_n_0 ),
        .I2(position122_in),
        .I3(armed),
        .I4(p_9_in),
        .I5(armed_i_2_n_0),
        .O(\current_us[79]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[79]_i_10 
       (.I0(\pending_reg[4] [12]),
        .I1(current_us[76]),
        .I2(current_us[77]),
        .I3(\pending_reg[4] [13]),
        .O(\current_us[79]_i_10_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[79]_i_11 
       (.I0(\pending_reg[4] [10]),
        .I1(current_us[74]),
        .I2(current_us[75]),
        .I3(\pending_reg[4] [11]),
        .O(\current_us[79]_i_11_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[79]_i_12 
       (.I0(\pending_reg[4] [8]),
        .I1(current_us[72]),
        .I2(current_us[73]),
        .I3(\pending_reg[4] [9]),
        .O(\current_us[79]_i_12_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[79]_i_13 
       (.I0(current_us[78]),
        .I1(\pending_reg[4] [14]),
        .I2(\pending_reg[4] [15]),
        .I3(current_us[79]),
        .O(\current_us[79]_i_13_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[79]_i_14 
       (.I0(current_us[76]),
        .I1(\pending_reg[4] [12]),
        .I2(\pending_reg[4] [13]),
        .I3(current_us[77]),
        .O(\current_us[79]_i_14_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[79]_i_15 
       (.I0(current_us[74]),
        .I1(\pending_reg[4] [10]),
        .I2(\pending_reg[4] [11]),
        .I3(current_us[75]),
        .O(\current_us[79]_i_15_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[79]_i_16 
       (.I0(current_us[72]),
        .I1(\pending_reg[4] [8]),
        .I2(\pending_reg[4] [9]),
        .I3(current_us[73]),
        .O(\current_us[79]_i_16_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[79]_i_18 
       (.I0(current_us[78]),
        .I1(\pending_reg[4] [14]),
        .I2(\pending_reg[4] [15]),
        .I3(current_us[79]),
        .O(\current_us[79]_i_18_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[79]_i_19 
       (.I0(current_us[76]),
        .I1(\pending_reg[4] [12]),
        .I2(\pending_reg[4] [13]),
        .I3(current_us[77]),
        .O(\current_us[79]_i_19_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[79]_i_2 
       (.I0(\current_us[79]_i_5_n_0 ),
        .I1(position121_in[15]),
        .I2(position122_in),
        .I3(\current_us[79]_i_7_n_0 ),
        .I4(armed),
        .I5(\pending_reg[4] [15]),
        .O(p_34_out[79]));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[79]_i_20 
       (.I0(current_us[74]),
        .I1(\pending_reg[4] [10]),
        .I2(\pending_reg[4] [11]),
        .I3(current_us[75]),
        .O(\current_us[79]_i_20_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[79]_i_21 
       (.I0(current_us[72]),
        .I1(\pending_reg[4] [8]),
        .I2(\pending_reg[4] [9]),
        .I3(current_us[73]),
        .O(\current_us[79]_i_21_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[79]_i_22 
       (.I0(current_us[78]),
        .I1(\pending_reg[4] [14]),
        .I2(\pending_reg[4] [15]),
        .I3(current_us[79]),
        .O(\current_us[79]_i_22_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[79]_i_23 
       (.I0(current_us[76]),
        .I1(\pending_reg[4] [12]),
        .I2(\pending_reg[4] [13]),
        .I3(current_us[77]),
        .O(\current_us[79]_i_23_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[79]_i_24 
       (.I0(current_us[74]),
        .I1(\pending_reg[4] [10]),
        .I2(\pending_reg[4] [11]),
        .I3(current_us[75]),
        .O(\current_us[79]_i_24_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[79]_i_25 
       (.I0(current_us[72]),
        .I1(\pending_reg[4] [8]),
        .I2(\pending_reg[4] [9]),
        .I3(current_us[73]),
        .O(\current_us[79]_i_25_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \current_us[79]_i_26 
       (.I0(\current_us_reg[79]_i_51_n_5 ),
        .I1(\current_us_reg[79]_i_51_n_4 ),
        .I2(\current_us_reg[79]_i_27_n_7 ),
        .I3(\current_us_reg[79]_i_27_n_6 ),
        .O(\current_us[79]_i_26_n_0 ));
  LUT6 #(
    .INIT(64'hDDDDDDDDD5D5D555)) 
    \current_us[79]_i_28 
       (.I0(\current_us_reg[79]_i_56_n_3 ),
        .I1(\current_us_reg[79]_i_57_n_7 ),
        .I2(\current_us_reg[79]_i_58_n_5 ),
        .I3(\current_us_reg[79]_i_58_n_7 ),
        .I4(\current_us_reg[79]_i_58_n_6 ),
        .I5(\current_us_reg[79]_i_58_n_4 ),
        .O(\current_us[79]_i_28_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \current_us[79]_i_29 
       (.I0(\current_us_reg[79]_i_57_n_6 ),
        .I1(\current_us_reg[79]_i_57_n_4 ),
        .I2(\current_us_reg[79]_i_57_n_5 ),
        .I3(\current_us_reg[79]_i_51_n_6 ),
        .I4(\current_us_reg[79]_i_51_n_7 ),
        .O(\current_us[79]_i_29_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \current_us[79]_i_30 
       (.I0(\current_us_reg[79]_i_59_n_5 ),
        .I1(\current_us_reg[79]_i_59_n_4 ),
        .I2(\current_us_reg[64]_i_3_n_7 ),
        .I3(\current_us_reg[64]_i_3_n_6 ),
        .O(\current_us[79]_i_30_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \current_us[79]_i_31 
       (.I0(\current_us_reg[64]_i_3_n_4 ),
        .I1(\current_us_reg[64]_i_3_n_5 ),
        .O(\current_us[79]_i_31_n_0 ));
  LUT6 #(
    .INIT(64'hDDDDDDDDD5D5D555)) 
    \current_us[79]_i_32 
       (.I0(\current_us_reg[79]_i_60_n_3 ),
        .I1(\current_us_reg[79]_i_61_n_7 ),
        .I2(\current_us_reg[79]_i_62_n_5 ),
        .I3(\current_us_reg[79]_i_62_n_7 ),
        .I4(\current_us_reg[79]_i_62_n_6 ),
        .I5(\current_us_reg[79]_i_62_n_4 ),
        .O(\current_us[79]_i_32_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \current_us[79]_i_33 
       (.I0(\current_us_reg[79]_i_61_n_6 ),
        .I1(\current_us_reg[79]_i_61_n_4 ),
        .I2(\current_us_reg[79]_i_61_n_5 ),
        .I3(\current_us_reg[79]_i_59_n_6 ),
        .I4(\current_us_reg[79]_i_59_n_7 ),
        .O(\current_us[79]_i_33_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[79]_i_35 
       (.I0(\pending_reg[4] [6]),
        .I1(current_us[70]),
        .I2(current_us[71]),
        .I3(\pending_reg[4] [7]),
        .O(\current_us[79]_i_35_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[79]_i_36 
       (.I0(\pending_reg[4] [4]),
        .I1(current_us[68]),
        .I2(current_us[69]),
        .I3(\pending_reg[4] [5]),
        .O(\current_us[79]_i_36_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[79]_i_37 
       (.I0(\pending_reg[4] [2]),
        .I1(current_us[66]),
        .I2(current_us[67]),
        .I3(\pending_reg[4] [3]),
        .O(\current_us[79]_i_37_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[79]_i_38 
       (.I0(\pending_reg[4] [0]),
        .I1(current_us[64]),
        .I2(current_us[65]),
        .I3(\pending_reg[4] [1]),
        .O(\current_us[79]_i_38_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[79]_i_39 
       (.I0(current_us[70]),
        .I1(\pending_reg[4] [6]),
        .I2(\pending_reg[4] [7]),
        .I3(current_us[71]),
        .O(\current_us[79]_i_39_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[79]_i_40 
       (.I0(current_us[68]),
        .I1(\pending_reg[4] [4]),
        .I2(\pending_reg[4] [5]),
        .I3(current_us[69]),
        .O(\current_us[79]_i_40_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[79]_i_41 
       (.I0(current_us[66]),
        .I1(\pending_reg[4] [2]),
        .I2(\pending_reg[4] [3]),
        .I3(current_us[67]),
        .O(\current_us[79]_i_41_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[79]_i_42 
       (.I0(current_us[64]),
        .I1(\pending_reg[4] [0]),
        .I2(\pending_reg[4] [1]),
        .I3(current_us[65]),
        .O(\current_us[79]_i_42_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[79]_i_43 
       (.I0(current_us[70]),
        .I1(\pending_reg[4] [6]),
        .I2(\pending_reg[4] [7]),
        .I3(current_us[71]),
        .O(\current_us[79]_i_43_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[79]_i_44 
       (.I0(current_us[68]),
        .I1(\pending_reg[4] [4]),
        .I2(\pending_reg[4] [5]),
        .I3(current_us[69]),
        .O(\current_us[79]_i_44_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[79]_i_45 
       (.I0(current_us[66]),
        .I1(\pending_reg[4] [2]),
        .I2(\pending_reg[4] [3]),
        .I3(current_us[67]),
        .O(\current_us[79]_i_45_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[79]_i_46 
       (.I0(current_us[64]),
        .I1(\pending_reg[4] [0]),
        .I2(\pending_reg[4] [1]),
        .I3(current_us[65]),
        .O(\current_us[79]_i_46_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[79]_i_47 
       (.I0(current_us[70]),
        .I1(\pending_reg[4] [6]),
        .I2(\pending_reg[4] [7]),
        .I3(current_us[71]),
        .O(\current_us[79]_i_47_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[79]_i_48 
       (.I0(current_us[68]),
        .I1(\pending_reg[4] [4]),
        .I2(\pending_reg[4] [5]),
        .I3(current_us[69]),
        .O(\current_us[79]_i_48_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[79]_i_49 
       (.I0(current_us[66]),
        .I1(\pending_reg[4] [2]),
        .I2(\pending_reg[4] [3]),
        .I3(current_us[67]),
        .O(\current_us[79]_i_49_n_0 ));
  LUT5 #(
    .INIT(32'h00000001)) 
    \current_us[79]_i_5 
       (.I0(\current_us[79]_i_26_n_0 ),
        .I1(\current_us_reg[79]_i_27_n_5 ),
        .I2(\current_us_reg[79]_i_27_n_4 ),
        .I3(\current_us[79]_i_28_n_0 ),
        .I4(\current_us[79]_i_29_n_0 ),
        .O(\current_us[79]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[79]_i_50 
       (.I0(current_us[64]),
        .I1(\pending_reg[4] [0]),
        .I2(\pending_reg[4] [1]),
        .I3(current_us[65]),
        .O(\current_us[79]_i_50_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[79]_i_52 
       (.I0(\pending_reg[4] [15]),
        .I1(current_us[79]),
        .O(\current_us[79]_i_52_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[79]_i_53 
       (.I0(\pending_reg[4] [14]),
        .I1(current_us[78]),
        .O(\current_us[79]_i_53_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[79]_i_54 
       (.I0(\pending_reg[4] [13]),
        .I1(current_us[77]),
        .O(\current_us[79]_i_54_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[79]_i_55 
       (.I0(\pending_reg[4] [12]),
        .I1(current_us[76]),
        .O(\current_us[79]_i_55_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[79]_i_63 
       (.I0(current_us[79]),
        .O(\current_us[79]_i_63_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[79]_i_64 
       (.I0(current_us[78]),
        .O(\current_us[79]_i_64_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[79]_i_65 
       (.I0(current_us[77]),
        .O(\current_us[79]_i_65_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[79]_i_66 
       (.I0(\pending_reg[4] [11]),
        .I1(current_us[75]),
        .O(\current_us[79]_i_66_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[79]_i_67 
       (.I0(\pending_reg[4] [10]),
        .I1(current_us[74]),
        .O(\current_us[79]_i_67_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[79]_i_68 
       (.I0(\pending_reg[4] [9]),
        .I1(current_us[73]),
        .O(\current_us[79]_i_68_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[79]_i_69 
       (.I0(\pending_reg[4] [8]),
        .I1(current_us[72]),
        .O(\current_us[79]_i_69_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[79]_i_7 
       (.I0(\pending_reg[4] [15]),
        .I1(\current_us[79]_i_30_n_0 ),
        .I2(\current_us[79]_i_31_n_0 ),
        .I3(\current_us[79]_i_32_n_0 ),
        .I4(\current_us[79]_i_33_n_0 ),
        .I5(position119_in[15]),
        .O(\current_us[79]_i_7_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[79]_i_70 
       (.I0(\pending_reg[4] [7]),
        .I1(current_us[71]),
        .O(\current_us[79]_i_70_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[79]_i_71 
       (.I0(\pending_reg[4] [6]),
        .I1(current_us[70]),
        .O(\current_us[79]_i_71_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[79]_i_72 
       (.I0(\pending_reg[4] [5]),
        .I1(current_us[69]),
        .O(\current_us[79]_i_72_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[79]_i_73 
       (.I0(\pending_reg[4] [4]),
        .I1(current_us[68]),
        .O(\current_us[79]_i_73_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[79]_i_74 
       (.I0(\pending_reg[4] [3]),
        .I1(current_us[67]),
        .O(\current_us[79]_i_74_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[79]_i_75 
       (.I0(\pending_reg[4] [2]),
        .I1(current_us[66]),
        .O(\current_us[79]_i_75_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[79]_i_76 
       (.I0(\pending_reg[4] [1]),
        .I1(current_us[65]),
        .O(\current_us[79]_i_76_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[79]_i_77 
       (.I0(\pending_reg[4] [0]),
        .I1(current_us[64]),
        .O(\current_us[79]_i_77_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[79]_i_78 
       (.I0(current_us[75]),
        .I1(\pending_reg[4] [11]),
        .O(\current_us[79]_i_78_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[79]_i_79 
       (.I0(current_us[74]),
        .I1(\pending_reg[4] [10]),
        .O(\current_us[79]_i_79_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[79]_i_80 
       (.I0(current_us[73]),
        .I1(\pending_reg[4] [9]),
        .O(\current_us[79]_i_80_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[79]_i_81 
       (.I0(current_us[72]),
        .I1(\pending_reg[4] [8]),
        .O(\current_us[79]_i_81_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[79]_i_82 
       (.I0(current_us[71]),
        .I1(\pending_reg[4] [7]),
        .O(\current_us[79]_i_82_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[79]_i_83 
       (.I0(current_us[70]),
        .I1(\pending_reg[4] [6]),
        .O(\current_us[79]_i_83_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[79]_i_84 
       (.I0(current_us[69]),
        .I1(\pending_reg[4] [5]),
        .O(\current_us[79]_i_84_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[79]_i_85 
       (.I0(current_us[68]),
        .I1(\pending_reg[4] [4]),
        .O(\current_us[79]_i_85_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[79]_i_86 
       (.I0(current_us[67]),
        .I1(\pending_reg[4] [3]),
        .O(\current_us[79]_i_86_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[79]_i_87 
       (.I0(current_us[66]),
        .I1(\pending_reg[4] [2]),
        .O(\current_us[79]_i_87_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[79]_i_88 
       (.I0(current_us[65]),
        .I1(\pending_reg[4] [1]),
        .O(\current_us[79]_i_88_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[79]_i_89 
       (.I0(current_us[64]),
        .I1(\pending_reg[4] [0]),
        .O(\current_us[79]_i_89_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[79]_i_9 
       (.I0(\pending_reg[4] [14]),
        .I1(current_us[78]),
        .I2(current_us[79]),
        .I3(\pending_reg[4] [15]),
        .O(\current_us[79]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[7]_i_1 
       (.I0(\current_us[15]_i_5_n_0 ),
        .I1(position11_in[7]),
        .I2(position12_in),
        .I3(\current_us[7]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[0] [7]),
        .O(p_34_out[7]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[7]_i_2 
       (.I0(\pending_reg[0] [7]),
        .I1(\current_us[15]_i_30_n_0 ),
        .I2(\current_us[15]_i_31_n_0 ),
        .I3(\current_us[15]_i_32_n_0 ),
        .I4(\current_us[15]_i_33_n_0 ),
        .I5(position1[7]),
        .O(\current_us[7]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFB8FFFF47000000)) 
    \current_us[80]_i_1 
       (.I0(\current_us[95]_i_7_n_0 ),
        .I1(position127_in),
        .I2(\current_us[80]_i_2_n_0 ),
        .I3(current_us[80]),
        .I4(armed),
        .I5(\pending_reg[5] [0]),
        .O(p_34_out[80]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h00000001)) 
    \current_us[80]_i_2 
       (.I0(\current_us[95]_i_32_n_0 ),
        .I1(\current_us_reg[80]_i_3_n_5 ),
        .I2(\current_us_reg[80]_i_3_n_4 ),
        .I3(\current_us[95]_i_34_n_0 ),
        .I4(\current_us[95]_i_35_n_0 ),
        .O(\current_us[80]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[80]_i_4 
       (.I0(current_us[95]),
        .I1(\pending_reg[5] [15]),
        .O(\current_us[80]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[80]_i_5 
       (.I0(current_us[94]),
        .I1(\pending_reg[5] [14]),
        .O(\current_us[80]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[80]_i_6 
       (.I0(current_us[93]),
        .I1(\pending_reg[5] [13]),
        .O(\current_us[80]_i_6_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[80]_i_7 
       (.I0(current_us[92]),
        .I1(\pending_reg[5] [12]),
        .O(\current_us[80]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[81]_i_1 
       (.I0(\current_us[95]_i_7_n_0 ),
        .I1(position126_in[1]),
        .I2(position127_in),
        .I3(\current_us[81]_i_3_n_0 ),
        .I4(armed),
        .I5(\pending_reg[5] [1]),
        .O(p_34_out[81]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[81]_i_3 
       (.I0(\pending_reg[5] [1]),
        .I1(\current_us[95]_i_32_n_0 ),
        .I2(\current_us[95]_i_33_n_0 ),
        .I3(\current_us[95]_i_34_n_0 ),
        .I4(\current_us[95]_i_35_n_0 ),
        .I5(current_us[81]),
        .O(\current_us[81]_i_3_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[81]_i_4 
       (.I0(current_us[83]),
        .O(\current_us[81]_i_4_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[81]_i_5 
       (.I0(current_us[82]),
        .O(\current_us[81]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[82]_i_1 
       (.I0(\current_us[95]_i_7_n_0 ),
        .I1(position126_in[2]),
        .I2(position127_in),
        .I3(\current_us[82]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[5] [2]),
        .O(p_34_out[82]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[82]_i_2 
       (.I0(\pending_reg[5] [2]),
        .I1(\current_us[95]_i_32_n_0 ),
        .I2(\current_us[95]_i_33_n_0 ),
        .I3(\current_us[95]_i_34_n_0 ),
        .I4(\current_us[95]_i_35_n_0 ),
        .I5(position124_in[2]),
        .O(\current_us[82]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[83]_i_1 
       (.I0(\current_us[95]_i_7_n_0 ),
        .I1(position126_in[3]),
        .I2(position127_in),
        .I3(\current_us[83]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[5] [3]),
        .O(p_34_out[83]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[83]_i_2 
       (.I0(\pending_reg[5] [3]),
        .I1(\current_us[95]_i_32_n_0 ),
        .I2(\current_us[95]_i_33_n_0 ),
        .I3(\current_us[95]_i_34_n_0 ),
        .I4(\current_us[95]_i_35_n_0 ),
        .I5(position124_in[3]),
        .O(\current_us[83]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[84]_i_1 
       (.I0(\current_us[95]_i_7_n_0 ),
        .I1(position126_in[4]),
        .I2(position127_in),
        .I3(\current_us[84]_i_3_n_0 ),
        .I4(armed),
        .I5(\pending_reg[5] [4]),
        .O(p_34_out[84]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[84]_i_3 
       (.I0(\pending_reg[5] [4]),
        .I1(\current_us[95]_i_32_n_0 ),
        .I2(\current_us[95]_i_33_n_0 ),
        .I3(\current_us[95]_i_34_n_0 ),
        .I4(\current_us[95]_i_35_n_0 ),
        .I5(position124_in[4]),
        .O(\current_us[84]_i_3_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[84]_i_4 
       (.I0(current_us[84]),
        .O(\current_us[84]_i_4_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[84]_i_5 
       (.I0(current_us[82]),
        .O(\current_us[84]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[85]_i_1 
       (.I0(\current_us[95]_i_7_n_0 ),
        .I1(position126_in[5]),
        .I2(position127_in),
        .I3(\current_us[85]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[5] [5]),
        .O(p_34_out[85]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[85]_i_2 
       (.I0(\pending_reg[5] [5]),
        .I1(\current_us[95]_i_32_n_0 ),
        .I2(\current_us[95]_i_33_n_0 ),
        .I3(\current_us[95]_i_34_n_0 ),
        .I4(\current_us[95]_i_35_n_0 ),
        .I5(position124_in[5]),
        .O(\current_us[85]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[86]_i_1 
       (.I0(\current_us[95]_i_7_n_0 ),
        .I1(position126_in[6]),
        .I2(position127_in),
        .I3(\current_us[86]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[5] [6]),
        .O(p_34_out[86]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[86]_i_2 
       (.I0(\pending_reg[5] [6]),
        .I1(\current_us[95]_i_32_n_0 ),
        .I2(\current_us[95]_i_33_n_0 ),
        .I3(\current_us[95]_i_34_n_0 ),
        .I4(\current_us[95]_i_35_n_0 ),
        .I5(position124_in[6]),
        .O(\current_us[86]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[87]_i_1 
       (.I0(\current_us[95]_i_7_n_0 ),
        .I1(position126_in[7]),
        .I2(position127_in),
        .I3(\current_us[87]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[5] [7]),
        .O(p_34_out[87]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[87]_i_2 
       (.I0(\pending_reg[5] [7]),
        .I1(\current_us[95]_i_32_n_0 ),
        .I2(\current_us[95]_i_33_n_0 ),
        .I3(\current_us[95]_i_34_n_0 ),
        .I4(\current_us[95]_i_35_n_0 ),
        .I5(position124_in[7]),
        .O(\current_us[87]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[88]_i_1 
       (.I0(\current_us[95]_i_7_n_0 ),
        .I1(position126_in[8]),
        .I2(position127_in),
        .I3(\current_us[88]_i_3_n_0 ),
        .I4(armed),
        .I5(\pending_reg[5] [8]),
        .O(p_34_out[88]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[88]_i_3 
       (.I0(\pending_reg[5] [8]),
        .I1(\current_us[95]_i_32_n_0 ),
        .I2(\current_us[95]_i_33_n_0 ),
        .I3(\current_us[95]_i_34_n_0 ),
        .I4(\current_us[95]_i_35_n_0 ),
        .I5(position124_in[8]),
        .O(\current_us[88]_i_3_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[88]_i_5 
       (.I0(current_us[88]),
        .O(\current_us[88]_i_5_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[88]_i_6 
       (.I0(current_us[87]),
        .O(\current_us[88]_i_6_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[88]_i_7 
       (.I0(current_us[86]),
        .O(\current_us[88]_i_7_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[88]_i_8 
       (.I0(current_us[85]),
        .O(\current_us[88]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[89]_i_1 
       (.I0(\current_us[95]_i_7_n_0 ),
        .I1(position126_in[9]),
        .I2(position127_in),
        .I3(\current_us[89]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[5] [9]),
        .O(p_34_out[89]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[89]_i_2 
       (.I0(\pending_reg[5] [9]),
        .I1(\current_us[95]_i_32_n_0 ),
        .I2(\current_us[95]_i_33_n_0 ),
        .I3(\current_us[95]_i_34_n_0 ),
        .I4(\current_us[95]_i_35_n_0 ),
        .I5(position124_in[9]),
        .O(\current_us[89]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[8]_i_1 
       (.I0(\current_us[15]_i_5_n_0 ),
        .I1(position11_in[8]),
        .I2(position12_in),
        .I3(\current_us[8]_i_3_n_0 ),
        .I4(armed),
        .I5(\pending_reg[0] [8]),
        .O(p_34_out[8]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[8]_i_3 
       (.I0(\pending_reg[0] [8]),
        .I1(\current_us[15]_i_30_n_0 ),
        .I2(\current_us[15]_i_31_n_0 ),
        .I3(\current_us[15]_i_32_n_0 ),
        .I4(\current_us[15]_i_33_n_0 ),
        .I5(position1[8]),
        .O(\current_us[8]_i_3_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[8]_i_5 
       (.I0(current_us[8]),
        .O(\current_us[8]_i_5_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[8]_i_6 
       (.I0(current_us[7]),
        .O(\current_us[8]_i_6_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[8]_i_7 
       (.I0(current_us[6]),
        .O(\current_us[8]_i_7_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[8]_i_8 
       (.I0(current_us[5]),
        .O(\current_us[8]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[90]_i_1 
       (.I0(\current_us[95]_i_7_n_0 ),
        .I1(position126_in[10]),
        .I2(position127_in),
        .I3(\current_us[90]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[5] [10]),
        .O(p_34_out[90]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[90]_i_2 
       (.I0(\pending_reg[5] [10]),
        .I1(\current_us[95]_i_32_n_0 ),
        .I2(\current_us[95]_i_33_n_0 ),
        .I3(\current_us[95]_i_34_n_0 ),
        .I4(\current_us[95]_i_35_n_0 ),
        .I5(position124_in[10]),
        .O(\current_us[90]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[91]_i_1 
       (.I0(\current_us[95]_i_7_n_0 ),
        .I1(position126_in[11]),
        .I2(position127_in),
        .I3(\current_us[91]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[5] [11]),
        .O(p_34_out[91]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[91]_i_2 
       (.I0(\pending_reg[5] [11]),
        .I1(\current_us[95]_i_32_n_0 ),
        .I2(\current_us[95]_i_33_n_0 ),
        .I3(\current_us[95]_i_34_n_0 ),
        .I4(\current_us[95]_i_35_n_0 ),
        .I5(position124_in[11]),
        .O(\current_us[91]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[92]_i_1 
       (.I0(\current_us[95]_i_7_n_0 ),
        .I1(position126_in[12]),
        .I2(position127_in),
        .I3(\current_us[92]_i_3_n_0 ),
        .I4(armed),
        .I5(\pending_reg[5] [12]),
        .O(p_34_out[92]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[92]_i_3 
       (.I0(\pending_reg[5] [12]),
        .I1(\current_us[95]_i_32_n_0 ),
        .I2(\current_us[95]_i_33_n_0 ),
        .I3(\current_us[95]_i_34_n_0 ),
        .I4(\current_us[95]_i_35_n_0 ),
        .I5(position124_in[12]),
        .O(\current_us[92]_i_3_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[92]_i_5 
       (.I0(current_us[92]),
        .O(\current_us[92]_i_5_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[92]_i_6 
       (.I0(current_us[91]),
        .O(\current_us[92]_i_6_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[92]_i_7 
       (.I0(current_us[90]),
        .O(\current_us[92]_i_7_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[92]_i_8 
       (.I0(current_us[89]),
        .O(\current_us[92]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[93]_i_1 
       (.I0(\current_us[95]_i_7_n_0 ),
        .I1(position126_in[13]),
        .I2(position127_in),
        .I3(\current_us[93]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[5] [13]),
        .O(p_34_out[93]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[93]_i_2 
       (.I0(\pending_reg[5] [13]),
        .I1(\current_us[95]_i_32_n_0 ),
        .I2(\current_us[95]_i_33_n_0 ),
        .I3(\current_us[95]_i_34_n_0 ),
        .I4(\current_us[95]_i_35_n_0 ),
        .I5(position124_in[13]),
        .O(\current_us[93]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[94]_i_1 
       (.I0(\current_us[95]_i_7_n_0 ),
        .I1(position126_in[14]),
        .I2(position127_in),
        .I3(\current_us[94]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[5] [14]),
        .O(p_34_out[94]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[94]_i_2 
       (.I0(\pending_reg[5] [14]),
        .I1(\current_us[95]_i_32_n_0 ),
        .I2(\current_us[95]_i_33_n_0 ),
        .I3(\current_us[95]_i_34_n_0 ),
        .I4(\current_us[95]_i_35_n_0 ),
        .I5(position124_in[14]),
        .O(\current_us[94]_i_2_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[95]_i_1 
       (.I0(rst_n),
        .O(p_0_in));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[95]_i_11 
       (.I0(\pending_reg[5] [14]),
        .I1(current_us[94]),
        .I2(current_us[95]),
        .I3(\pending_reg[5] [15]),
        .O(\current_us[95]_i_11_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[95]_i_12 
       (.I0(\pending_reg[5] [12]),
        .I1(current_us[92]),
        .I2(current_us[93]),
        .I3(\pending_reg[5] [13]),
        .O(\current_us[95]_i_12_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[95]_i_13 
       (.I0(\pending_reg[5] [10]),
        .I1(current_us[90]),
        .I2(current_us[91]),
        .I3(\pending_reg[5] [11]),
        .O(\current_us[95]_i_13_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[95]_i_14 
       (.I0(\pending_reg[5] [8]),
        .I1(current_us[88]),
        .I2(current_us[89]),
        .I3(\pending_reg[5] [9]),
        .O(\current_us[95]_i_14_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[95]_i_15 
       (.I0(current_us[94]),
        .I1(\pending_reg[5] [14]),
        .I2(\pending_reg[5] [15]),
        .I3(current_us[95]),
        .O(\current_us[95]_i_15_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[95]_i_16 
       (.I0(current_us[92]),
        .I1(\pending_reg[5] [12]),
        .I2(\pending_reg[5] [13]),
        .I3(current_us[93]),
        .O(\current_us[95]_i_16_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[95]_i_17 
       (.I0(current_us[90]),
        .I1(\pending_reg[5] [10]),
        .I2(\pending_reg[5] [11]),
        .I3(current_us[91]),
        .O(\current_us[95]_i_17_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[95]_i_18 
       (.I0(current_us[88]),
        .I1(\pending_reg[5] [8]),
        .I2(\pending_reg[5] [9]),
        .I3(current_us[89]),
        .O(\current_us[95]_i_18_n_0 ));
  LUT6 #(
    .INIT(64'h2222202200000000)) 
    \current_us[95]_i_2 
       (.I0(\sub_tick[4]_i_2_n_0 ),
        .I1(\current_us[95]_i_4_n_0 ),
        .I2(position127_in),
        .I3(armed),
        .I4(p_11_in),
        .I5(armed_i_2_n_0),
        .O(\current_us[95]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[95]_i_20 
       (.I0(current_us[94]),
        .I1(\pending_reg[5] [14]),
        .I2(\pending_reg[5] [15]),
        .I3(current_us[95]),
        .O(\current_us[95]_i_20_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[95]_i_21 
       (.I0(current_us[92]),
        .I1(\pending_reg[5] [12]),
        .I2(\pending_reg[5] [13]),
        .I3(current_us[93]),
        .O(\current_us[95]_i_21_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[95]_i_22 
       (.I0(current_us[90]),
        .I1(\pending_reg[5] [10]),
        .I2(\pending_reg[5] [11]),
        .I3(current_us[91]),
        .O(\current_us[95]_i_22_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[95]_i_23 
       (.I0(current_us[88]),
        .I1(\pending_reg[5] [8]),
        .I2(\pending_reg[5] [9]),
        .I3(current_us[89]),
        .O(\current_us[95]_i_23_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[95]_i_24 
       (.I0(current_us[94]),
        .I1(\pending_reg[5] [14]),
        .I2(\pending_reg[5] [15]),
        .I3(current_us[95]),
        .O(\current_us[95]_i_24_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[95]_i_25 
       (.I0(current_us[92]),
        .I1(\pending_reg[5] [12]),
        .I2(\pending_reg[5] [13]),
        .I3(current_us[93]),
        .O(\current_us[95]_i_25_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[95]_i_26 
       (.I0(current_us[90]),
        .I1(\pending_reg[5] [10]),
        .I2(\pending_reg[5] [11]),
        .I3(current_us[91]),
        .O(\current_us[95]_i_26_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[95]_i_27 
       (.I0(current_us[88]),
        .I1(\pending_reg[5] [8]),
        .I2(\pending_reg[5] [9]),
        .I3(current_us[89]),
        .O(\current_us[95]_i_27_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \current_us[95]_i_28 
       (.I0(position3[10]),
        .I1(position3[11]),
        .I2(position3[12]),
        .I3(position3[13]),
        .O(\current_us[95]_i_28_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[95]_i_3 
       (.I0(\current_us[95]_i_7_n_0 ),
        .I1(position126_in[15]),
        .I2(position127_in),
        .I3(\current_us[95]_i_9_n_0 ),
        .I4(armed),
        .I5(\pending_reg[5] [15]),
        .O(p_34_out[95]));
  LUT6 #(
    .INIT(64'hDDDDDDDDD5D5D555)) 
    \current_us[95]_i_30 
       (.I0(\current_us_reg[95]_i_58_n_3 ),
        .I1(position3[4]),
        .I2(position3[2]),
        .I3(position3[0]),
        .I4(position3[1]),
        .I5(position3[3]),
        .O(\current_us[95]_i_30_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \current_us[95]_i_31 
       (.I0(position3[5]),
        .I1(position3[7]),
        .I2(position3[6]),
        .I3(position3[9]),
        .I4(position3[8]),
        .O(\current_us[95]_i_31_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \current_us[95]_i_32 
       (.I0(\current_us_reg[95]_i_61_n_5 ),
        .I1(\current_us_reg[95]_i_61_n_4 ),
        .I2(\current_us_reg[80]_i_3_n_7 ),
        .I3(\current_us_reg[80]_i_3_n_6 ),
        .O(\current_us[95]_i_32_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \current_us[95]_i_33 
       (.I0(\current_us_reg[80]_i_3_n_4 ),
        .I1(\current_us_reg[80]_i_3_n_5 ),
        .O(\current_us[95]_i_33_n_0 ));
  LUT6 #(
    .INIT(64'hDDDDDDDDD5D5D555)) 
    \current_us[95]_i_34 
       (.I0(\current_us_reg[95]_i_62_n_3 ),
        .I1(\current_us_reg[95]_i_63_n_7 ),
        .I2(\current_us_reg[95]_i_64_n_5 ),
        .I3(\current_us_reg[95]_i_64_n_7 ),
        .I4(\current_us_reg[95]_i_64_n_6 ),
        .I5(\current_us_reg[95]_i_64_n_4 ),
        .O(\current_us[95]_i_34_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \current_us[95]_i_35 
       (.I0(\current_us_reg[95]_i_63_n_6 ),
        .I1(\current_us_reg[95]_i_63_n_4 ),
        .I2(\current_us_reg[95]_i_63_n_5 ),
        .I3(\current_us_reg[95]_i_61_n_6 ),
        .I4(\current_us_reg[95]_i_61_n_7 ),
        .O(\current_us[95]_i_35_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[95]_i_37 
       (.I0(\pending_reg[5] [6]),
        .I1(current_us[86]),
        .I2(current_us[87]),
        .I3(\pending_reg[5] [7]),
        .O(\current_us[95]_i_37_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[95]_i_38 
       (.I0(\pending_reg[5] [4]),
        .I1(current_us[84]),
        .I2(current_us[85]),
        .I3(\pending_reg[5] [5]),
        .O(\current_us[95]_i_38_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[95]_i_39 
       (.I0(\pending_reg[5] [2]),
        .I1(current_us[82]),
        .I2(current_us[83]),
        .I3(\pending_reg[5] [3]),
        .O(\current_us[95]_i_39_n_0 ));
  LUT2 #(
    .INIT(4'hB)) 
    \current_us[95]_i_4 
       (.I0(estop),
        .I1(enable),
        .O(\current_us[95]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[95]_i_40 
       (.I0(\pending_reg[5] [0]),
        .I1(current_us[80]),
        .I2(current_us[81]),
        .I3(\pending_reg[5] [1]),
        .O(\current_us[95]_i_40_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[95]_i_41 
       (.I0(current_us[86]),
        .I1(\pending_reg[5] [6]),
        .I2(\pending_reg[5] [7]),
        .I3(current_us[87]),
        .O(\current_us[95]_i_41_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[95]_i_42 
       (.I0(current_us[84]),
        .I1(\pending_reg[5] [4]),
        .I2(\pending_reg[5] [5]),
        .I3(current_us[85]),
        .O(\current_us[95]_i_42_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[95]_i_43 
       (.I0(current_us[82]),
        .I1(\pending_reg[5] [2]),
        .I2(\pending_reg[5] [3]),
        .I3(current_us[83]),
        .O(\current_us[95]_i_43_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[95]_i_44 
       (.I0(current_us[80]),
        .I1(\pending_reg[5] [0]),
        .I2(\pending_reg[5] [1]),
        .I3(current_us[81]),
        .O(\current_us[95]_i_44_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[95]_i_45 
       (.I0(current_us[86]),
        .I1(\pending_reg[5] [6]),
        .I2(\pending_reg[5] [7]),
        .I3(current_us[87]),
        .O(\current_us[95]_i_45_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[95]_i_46 
       (.I0(current_us[84]),
        .I1(\pending_reg[5] [4]),
        .I2(\pending_reg[5] [5]),
        .I3(current_us[85]),
        .O(\current_us[95]_i_46_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[95]_i_47 
       (.I0(current_us[82]),
        .I1(\pending_reg[5] [2]),
        .I2(\pending_reg[5] [3]),
        .I3(current_us[83]),
        .O(\current_us[95]_i_47_n_0 ));
  LUT4 #(
    .INIT(16'h2F02)) 
    \current_us[95]_i_48 
       (.I0(current_us[80]),
        .I1(\pending_reg[5] [0]),
        .I2(\pending_reg[5] [1]),
        .I3(current_us[81]),
        .O(\current_us[95]_i_48_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[95]_i_49 
       (.I0(current_us[86]),
        .I1(\pending_reg[5] [6]),
        .I2(\pending_reg[5] [7]),
        .I3(current_us[87]),
        .O(\current_us[95]_i_49_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[95]_i_50 
       (.I0(current_us[84]),
        .I1(\pending_reg[5] [4]),
        .I2(\pending_reg[5] [5]),
        .I3(current_us[85]),
        .O(\current_us[95]_i_50_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[95]_i_51 
       (.I0(current_us[82]),
        .I1(\pending_reg[5] [2]),
        .I2(\pending_reg[5] [3]),
        .I3(current_us[83]),
        .O(\current_us[95]_i_51_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \current_us[95]_i_52 
       (.I0(current_us[80]),
        .I1(\pending_reg[5] [0]),
        .I2(\pending_reg[5] [1]),
        .I3(current_us[81]),
        .O(\current_us[95]_i_52_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[95]_i_54 
       (.I0(\pending_reg[5] [15]),
        .I1(current_us[95]),
        .O(\current_us[95]_i_54_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[95]_i_55 
       (.I0(\pending_reg[5] [14]),
        .I1(current_us[94]),
        .O(\current_us[95]_i_55_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[95]_i_56 
       (.I0(\pending_reg[5] [13]),
        .I1(current_us[93]),
        .O(\current_us[95]_i_56_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[95]_i_57 
       (.I0(\pending_reg[5] [12]),
        .I1(current_us[92]),
        .O(\current_us[95]_i_57_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[95]_i_65 
       (.I0(current_us[95]),
        .O(\current_us[95]_i_65_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[95]_i_66 
       (.I0(current_us[94]),
        .O(\current_us[95]_i_66_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \current_us[95]_i_67 
       (.I0(current_us[93]),
        .O(\current_us[95]_i_67_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[95]_i_68 
       (.I0(\pending_reg[5] [11]),
        .I1(current_us[91]),
        .O(\current_us[95]_i_68_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[95]_i_69 
       (.I0(\pending_reg[5] [10]),
        .I1(current_us[90]),
        .O(\current_us[95]_i_69_n_0 ));
  LUT5 #(
    .INIT(32'h00000001)) 
    \current_us[95]_i_7 
       (.I0(\current_us[95]_i_28_n_0 ),
        .I1(position3[14]),
        .I2(position3[15]),
        .I3(\current_us[95]_i_30_n_0 ),
        .I4(\current_us[95]_i_31_n_0 ),
        .O(\current_us[95]_i_7_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[95]_i_70 
       (.I0(\pending_reg[5] [9]),
        .I1(current_us[89]),
        .O(\current_us[95]_i_70_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[95]_i_71 
       (.I0(\pending_reg[5] [8]),
        .I1(current_us[88]),
        .O(\current_us[95]_i_71_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[95]_i_72 
       (.I0(\pending_reg[5] [7]),
        .I1(current_us[87]),
        .O(\current_us[95]_i_72_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[95]_i_73 
       (.I0(\pending_reg[5] [6]),
        .I1(current_us[86]),
        .O(\current_us[95]_i_73_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[95]_i_74 
       (.I0(\pending_reg[5] [5]),
        .I1(current_us[85]),
        .O(\current_us[95]_i_74_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[95]_i_75 
       (.I0(\pending_reg[5] [4]),
        .I1(current_us[84]),
        .O(\current_us[95]_i_75_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[95]_i_76 
       (.I0(\pending_reg[5] [3]),
        .I1(current_us[83]),
        .O(\current_us[95]_i_76_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[95]_i_77 
       (.I0(\pending_reg[5] [2]),
        .I1(current_us[82]),
        .O(\current_us[95]_i_77_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[95]_i_78 
       (.I0(\pending_reg[5] [1]),
        .I1(current_us[81]),
        .O(\current_us[95]_i_78_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[95]_i_79 
       (.I0(\pending_reg[5] [0]),
        .I1(current_us[80]),
        .O(\current_us[95]_i_79_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[95]_i_80 
       (.I0(current_us[91]),
        .I1(\pending_reg[5] [11]),
        .O(\current_us[95]_i_80_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[95]_i_81 
       (.I0(current_us[90]),
        .I1(\pending_reg[5] [10]),
        .O(\current_us[95]_i_81_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[95]_i_82 
       (.I0(current_us[89]),
        .I1(\pending_reg[5] [9]),
        .O(\current_us[95]_i_82_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[95]_i_83 
       (.I0(current_us[88]),
        .I1(\pending_reg[5] [8]),
        .O(\current_us[95]_i_83_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[95]_i_84 
       (.I0(current_us[87]),
        .I1(\pending_reg[5] [7]),
        .O(\current_us[95]_i_84_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[95]_i_85 
       (.I0(current_us[86]),
        .I1(\pending_reg[5] [6]),
        .O(\current_us[95]_i_85_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[95]_i_86 
       (.I0(current_us[85]),
        .I1(\pending_reg[5] [5]),
        .O(\current_us[95]_i_86_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[95]_i_87 
       (.I0(current_us[84]),
        .I1(\pending_reg[5] [4]),
        .O(\current_us[95]_i_87_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[95]_i_88 
       (.I0(current_us[83]),
        .I1(\pending_reg[5] [3]),
        .O(\current_us[95]_i_88_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[95]_i_89 
       (.I0(current_us[82]),
        .I1(\pending_reg[5] [2]),
        .O(\current_us[95]_i_89_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[95]_i_9 
       (.I0(\pending_reg[5] [15]),
        .I1(\current_us[95]_i_32_n_0 ),
        .I2(\current_us[95]_i_33_n_0 ),
        .I3(\current_us[95]_i_34_n_0 ),
        .I4(\current_us[95]_i_35_n_0 ),
        .I5(position124_in[15]),
        .O(\current_us[95]_i_9_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[95]_i_90 
       (.I0(current_us[81]),
        .I1(\pending_reg[5] [1]),
        .O(\current_us[95]_i_90_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \current_us[95]_i_91 
       (.I0(current_us[80]),
        .I1(\pending_reg[5] [0]),
        .O(\current_us[95]_i_91_n_0 ));
  LUT6 #(
    .INIT(64'hEFE0FFFF4F400000)) 
    \current_us[9]_i_1 
       (.I0(\current_us[15]_i_5_n_0 ),
        .I1(position11_in[9]),
        .I2(position12_in),
        .I3(\current_us[9]_i_2_n_0 ),
        .I4(armed),
        .I5(\pending_reg[0] [9]),
        .O(p_34_out[9]));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    \current_us[9]_i_2 
       (.I0(\pending_reg[0] [9]),
        .I1(\current_us[15]_i_30_n_0 ),
        .I2(\current_us[15]_i_31_n_0 ),
        .I3(\current_us[15]_i_32_n_0 ),
        .I4(\current_us[15]_i_33_n_0 ),
        .I5(position1[9]),
        .O(\current_us[9]_i_2_n_0 ));
  FDRE \current_us_reg[0] 
       (.C(clk),
        .CE(\current_us[15]_i_1_n_0 ),
        .D(p_34_out[0]),
        .Q(current_us[0]),
        .R(p_0_in));
  CARRY4 \current_us_reg[0]_i_3 
       (.CI(\current_us_reg[15]_i_59_n_0 ),
        .CO({\current_us_reg[0]_i_3_n_0 ,\current_us_reg[0]_i_3_n_1 ,\current_us_reg[0]_i_3_n_2 ,\current_us_reg[0]_i_3_n_3 }),
        .CYINIT(1'b0),
        .DI(current_us[15:12]),
        .O({\current_us_reg[0]_i_3_n_4 ,\current_us_reg[0]_i_3_n_5 ,\current_us_reg[0]_i_3_n_6 ,\current_us_reg[0]_i_3_n_7 }),
        .S({\current_us[0]_i_4_n_0 ,\current_us[0]_i_5_n_0 ,\current_us[0]_i_6_n_0 ,\current_us[0]_i_7_n_0 }));
  FDRE \current_us_reg[10] 
       (.C(clk),
        .CE(\current_us[15]_i_1_n_0 ),
        .D(p_34_out[10]),
        .Q(current_us[10]),
        .R(p_0_in));
  FDRE \current_us_reg[11] 
       (.C(clk),
        .CE(\current_us[15]_i_1_n_0 ),
        .D(p_34_out[11]),
        .Q(current_us[11]),
        .R(p_0_in));
  FDRE \current_us_reg[12] 
       (.C(clk),
        .CE(\current_us[15]_i_1_n_0 ),
        .D(p_34_out[12]),
        .Q(current_us[12]),
        .R(p_0_in));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[12]_i_2 
       (.CI(\current_us_reg[8]_i_2_n_0 ),
        .CO({\current_us_reg[12]_i_2_n_0 ,\current_us_reg[12]_i_2_n_1 ,\current_us_reg[12]_i_2_n_2 ,\current_us_reg[12]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(position11_in[12:9]),
        .S(current_us[12:9]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[12]_i_4 
       (.CI(\current_us_reg[8]_i_4_n_0 ),
        .CO({\current_us_reg[12]_i_4_n_0 ,\current_us_reg[12]_i_4_n_1 ,\current_us_reg[12]_i_4_n_2 ,\current_us_reg[12]_i_4_n_3 }),
        .CYINIT(1'b0),
        .DI(current_us[12:9]),
        .O(position1[12:9]),
        .S({\current_us[12]_i_5_n_0 ,\current_us[12]_i_6_n_0 ,\current_us[12]_i_7_n_0 ,\current_us[12]_i_8_n_0 }));
  FDRE \current_us_reg[13] 
       (.C(clk),
        .CE(\current_us[15]_i_1_n_0 ),
        .D(p_34_out[13]),
        .Q(current_us[13]),
        .R(p_0_in));
  FDRE \current_us_reg[14] 
       (.C(clk),
        .CE(\current_us[15]_i_1_n_0 ),
        .D(p_34_out[14]),
        .Q(current_us[14]),
        .R(p_0_in));
  FDRE \current_us_reg[15] 
       (.C(clk),
        .CE(\current_us[15]_i_1_n_0 ),
        .D(p_34_out[15]),
        .Q(current_us[15]),
        .R(p_0_in));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \current_us_reg[15]_i_17 
       (.CI(1'b0),
        .CO({\current_us_reg[15]_i_17_n_0 ,\current_us_reg[15]_i_17_n_1 ,\current_us_reg[15]_i_17_n_2 ,\current_us_reg[15]_i_17_n_3 }),
        .CYINIT(1'b0),
        .DI({\current_us[15]_i_43_n_0 ,\current_us[15]_i_44_n_0 ,\current_us[15]_i_45_n_0 ,\current_us[15]_i_46_n_0 }),
        .O(\NLW_current_us_reg[15]_i_17_O_UNCONNECTED [3:0]),
        .S({\current_us[15]_i_47_n_0 ,\current_us[15]_i_48_n_0 ,\current_us[15]_i_49_n_0 ,\current_us[15]_i_50_n_0 }));
  CARRY4 \current_us_reg[15]_i_27 
       (.CI(\current_us_reg[15]_i_51_n_0 ),
        .CO({\current_us_reg[15]_i_27_n_0 ,\current_us_reg[15]_i_27_n_1 ,\current_us_reg[15]_i_27_n_2 ,\current_us_reg[15]_i_27_n_3 }),
        .CYINIT(1'b0),
        .DI(\pending_reg[0] [15:12]),
        .O({\current_us_reg[15]_i_27_n_4 ,\current_us_reg[15]_i_27_n_5 ,\current_us_reg[15]_i_27_n_6 ,\current_us_reg[15]_i_27_n_7 }),
        .S({\current_us[15]_i_52_n_0 ,\current_us[15]_i_53_n_0 ,\current_us[15]_i_54_n_0 ,\current_us[15]_i_55_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \current_us_reg[15]_i_3 
       (.CI(\current_us_reg[15]_i_8_n_0 ),
        .CO({position12_in,\current_us_reg[15]_i_3_n_1 ,\current_us_reg[15]_i_3_n_2 ,\current_us_reg[15]_i_3_n_3 }),
        .CYINIT(1'b0),
        .DI({\current_us[15]_i_9_n_0 ,\current_us[15]_i_10_n_0 ,\current_us[15]_i_11_n_0 ,\current_us[15]_i_12_n_0 }),
        .O(\NLW_current_us_reg[15]_i_3_O_UNCONNECTED [3:0]),
        .S({\current_us[15]_i_13_n_0 ,\current_us[15]_i_14_n_0 ,\current_us[15]_i_15_n_0 ,\current_us[15]_i_16_n_0 }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[15]_i_34 
       (.CI(\current_us_reg[12]_i_4_n_0 ),
        .CO({\NLW_current_us_reg[15]_i_34_CO_UNCONNECTED [3:2],\current_us_reg[15]_i_34_n_2 ,\current_us_reg[15]_i_34_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,current_us[14:13]}),
        .O({\NLW_current_us_reg[15]_i_34_O_UNCONNECTED [3],position1[15:13]}),
        .S({1'b0,\current_us[15]_i_63_n_0 ,\current_us[15]_i_64_n_0 ,\current_us[15]_i_65_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \current_us_reg[15]_i_4 
       (.CI(\current_us_reg[15]_i_17_n_0 ),
        .CO({p_1_in,\current_us_reg[15]_i_4_n_1 ,\current_us_reg[15]_i_4_n_2 ,\current_us_reg[15]_i_4_n_3 }),
        .CYINIT(1'b0),
        .DI({\current_us[15]_i_18_n_0 ,\current_us[15]_i_19_n_0 ,\current_us[15]_i_20_n_0 ,\current_us[15]_i_21_n_0 }),
        .O(\NLW_current_us_reg[15]_i_4_O_UNCONNECTED [3:0]),
        .S({\current_us[15]_i_22_n_0 ,\current_us[15]_i_23_n_0 ,\current_us[15]_i_24_n_0 ,\current_us[15]_i_25_n_0 }));
  CARRY4 \current_us_reg[15]_i_51 
       (.CI(\current_us_reg[15]_i_57_n_0 ),
        .CO({\current_us_reg[15]_i_51_n_0 ,\current_us_reg[15]_i_51_n_1 ,\current_us_reg[15]_i_51_n_2 ,\current_us_reg[15]_i_51_n_3 }),
        .CYINIT(1'b0),
        .DI(\pending_reg[0] [11:8]),
        .O({\current_us_reg[15]_i_51_n_4 ,\current_us_reg[15]_i_51_n_5 ,\current_us_reg[15]_i_51_n_6 ,\current_us_reg[15]_i_51_n_7 }),
        .S({\current_us[15]_i_66_n_0 ,\current_us[15]_i_67_n_0 ,\current_us[15]_i_68_n_0 ,\current_us[15]_i_69_n_0 }));
  CARRY4 \current_us_reg[15]_i_56 
       (.CI(\current_us_reg[15]_i_27_n_0 ),
        .CO({\NLW_current_us_reg[15]_i_56_CO_UNCONNECTED [3:1],\current_us_reg[15]_i_56_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(\NLW_current_us_reg[15]_i_56_O_UNCONNECTED [3:0]),
        .S({1'b0,1'b0,1'b0,1'b1}));
  CARRY4 \current_us_reg[15]_i_57 
       (.CI(\current_us_reg[15]_i_58_n_0 ),
        .CO({\current_us_reg[15]_i_57_n_0 ,\current_us_reg[15]_i_57_n_1 ,\current_us_reg[15]_i_57_n_2 ,\current_us_reg[15]_i_57_n_3 }),
        .CYINIT(1'b0),
        .DI(\pending_reg[0] [7:4]),
        .O({\current_us_reg[15]_i_57_n_4 ,\current_us_reg[15]_i_57_n_5 ,\current_us_reg[15]_i_57_n_6 ,\current_us_reg[15]_i_57_n_7 }),
        .S({\current_us[15]_i_70_n_0 ,\current_us[15]_i_71_n_0 ,\current_us[15]_i_72_n_0 ,\current_us[15]_i_73_n_0 }));
  CARRY4 \current_us_reg[15]_i_58 
       (.CI(1'b0),
        .CO({\current_us_reg[15]_i_58_n_0 ,\current_us_reg[15]_i_58_n_1 ,\current_us_reg[15]_i_58_n_2 ,\current_us_reg[15]_i_58_n_3 }),
        .CYINIT(1'b1),
        .DI(\pending_reg[0] [3:0]),
        .O({\current_us_reg[15]_i_58_n_4 ,\current_us_reg[15]_i_58_n_5 ,\current_us_reg[15]_i_58_n_6 ,\current_us_reg[15]_i_58_n_7 }),
        .S({\current_us[15]_i_74_n_0 ,\current_us[15]_i_75_n_0 ,\current_us[15]_i_76_n_0 ,\current_us[15]_i_77_n_0 }));
  CARRY4 \current_us_reg[15]_i_59 
       (.CI(\current_us_reg[15]_i_61_n_0 ),
        .CO({\current_us_reg[15]_i_59_n_0 ,\current_us_reg[15]_i_59_n_1 ,\current_us_reg[15]_i_59_n_2 ,\current_us_reg[15]_i_59_n_3 }),
        .CYINIT(1'b0),
        .DI(current_us[11:8]),
        .O({\current_us_reg[15]_i_59_n_4 ,\current_us_reg[15]_i_59_n_5 ,\current_us_reg[15]_i_59_n_6 ,\current_us_reg[15]_i_59_n_7 }),
        .S({\current_us[15]_i_78_n_0 ,\current_us[15]_i_79_n_0 ,\current_us[15]_i_80_n_0 ,\current_us[15]_i_81_n_0 }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[15]_i_6 
       (.CI(\current_us_reg[12]_i_2_n_0 ),
        .CO({\NLW_current_us_reg[15]_i_6_CO_UNCONNECTED [3:2],\current_us_reg[15]_i_6_n_2 ,\current_us_reg[15]_i_6_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\NLW_current_us_reg[15]_i_6_O_UNCONNECTED [3],position11_in[15:13]}),
        .S({1'b0,current_us[15:13]}));
  CARRY4 \current_us_reg[15]_i_60 
       (.CI(\current_us_reg[0]_i_3_n_0 ),
        .CO({\NLW_current_us_reg[15]_i_60_CO_UNCONNECTED [3:1],\current_us_reg[15]_i_60_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(\NLW_current_us_reg[15]_i_60_O_UNCONNECTED [3:0]),
        .S({1'b0,1'b0,1'b0,1'b1}));
  CARRY4 \current_us_reg[15]_i_61 
       (.CI(\current_us_reg[15]_i_62_n_0 ),
        .CO({\current_us_reg[15]_i_61_n_0 ,\current_us_reg[15]_i_61_n_1 ,\current_us_reg[15]_i_61_n_2 ,\current_us_reg[15]_i_61_n_3 }),
        .CYINIT(1'b0),
        .DI(current_us[7:4]),
        .O({\current_us_reg[15]_i_61_n_4 ,\current_us_reg[15]_i_61_n_5 ,\current_us_reg[15]_i_61_n_6 ,\current_us_reg[15]_i_61_n_7 }),
        .S({\current_us[15]_i_82_n_0 ,\current_us[15]_i_83_n_0 ,\current_us[15]_i_84_n_0 ,\current_us[15]_i_85_n_0 }));
  CARRY4 \current_us_reg[15]_i_62 
       (.CI(1'b0),
        .CO({\current_us_reg[15]_i_62_n_0 ,\current_us_reg[15]_i_62_n_1 ,\current_us_reg[15]_i_62_n_2 ,\current_us_reg[15]_i_62_n_3 }),
        .CYINIT(1'b1),
        .DI(current_us[3:0]),
        .O({\current_us_reg[15]_i_62_n_4 ,\current_us_reg[15]_i_62_n_5 ,\current_us_reg[15]_i_62_n_6 ,\current_us_reg[15]_i_62_n_7 }),
        .S({\current_us[15]_i_86_n_0 ,\current_us[15]_i_87_n_0 ,\current_us[15]_i_88_n_0 ,\current_us[15]_i_89_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \current_us_reg[15]_i_8 
       (.CI(1'b0),
        .CO({\current_us_reg[15]_i_8_n_0 ,\current_us_reg[15]_i_8_n_1 ,\current_us_reg[15]_i_8_n_2 ,\current_us_reg[15]_i_8_n_3 }),
        .CYINIT(1'b0),
        .DI({\current_us[15]_i_35_n_0 ,\current_us[15]_i_36_n_0 ,\current_us[15]_i_37_n_0 ,\current_us[15]_i_38_n_0 }),
        .O(\NLW_current_us_reg[15]_i_8_O_UNCONNECTED [3:0]),
        .S({\current_us[15]_i_39_n_0 ,\current_us[15]_i_40_n_0 ,\current_us[15]_i_41_n_0 ,\current_us[15]_i_42_n_0 }));
  FDRE \current_us_reg[16] 
       (.C(clk),
        .CE(\current_us[31]_i_1_n_0 ),
        .D(p_34_out[16]),
        .Q(current_us[16]),
        .R(p_0_in));
  CARRY4 \current_us_reg[16]_i_3 
       (.CI(\current_us_reg[31]_i_59_n_0 ),
        .CO({\current_us_reg[16]_i_3_n_0 ,\current_us_reg[16]_i_3_n_1 ,\current_us_reg[16]_i_3_n_2 ,\current_us_reg[16]_i_3_n_3 }),
        .CYINIT(1'b0),
        .DI(current_us[31:28]),
        .O({\current_us_reg[16]_i_3_n_4 ,\current_us_reg[16]_i_3_n_5 ,\current_us_reg[16]_i_3_n_6 ,\current_us_reg[16]_i_3_n_7 }),
        .S({\current_us[16]_i_4_n_0 ,\current_us[16]_i_5_n_0 ,\current_us[16]_i_6_n_0 ,\current_us[16]_i_7_n_0 }));
  FDRE \current_us_reg[17] 
       (.C(clk),
        .CE(\current_us[31]_i_1_n_0 ),
        .D(p_34_out[17]),
        .Q(current_us[17]),
        .R(p_0_in));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[17]_i_2 
       (.CI(1'b0),
        .CO({\current_us_reg[17]_i_2_n_0 ,\current_us_reg[17]_i_2_n_1 ,\current_us_reg[17]_i_2_n_2 ,\current_us_reg[17]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,current_us[19:18],1'b0}),
        .O({position14_in[4:2],position16_in[1]}),
        .S({current_us[20],\current_us[17]_i_4_n_0 ,\current_us[17]_i_5_n_0 ,current_us[17]}));
  FDRE \current_us_reg[18] 
       (.C(clk),
        .CE(\current_us[31]_i_1_n_0 ),
        .D(p_34_out[18]),
        .Q(current_us[18]),
        .R(p_0_in));
  FDRE \current_us_reg[19] 
       (.C(clk),
        .CE(\current_us[31]_i_1_n_0 ),
        .D(p_34_out[19]),
        .Q(current_us[19]),
        .R(p_0_in));
  FDRE \current_us_reg[1] 
       (.C(clk),
        .CE(\current_us[15]_i_1_n_0 ),
        .D(p_34_out[1]),
        .Q(current_us[1]),
        .R(p_0_in));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[1]_i_2 
       (.CI(1'b0),
        .CO({\current_us_reg[1]_i_2_n_0 ,\current_us_reg[1]_i_2_n_1 ,\current_us_reg[1]_i_2_n_2 ,\current_us_reg[1]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,current_us[3:2],1'b0}),
        .O({position1[4:2],position11_in[1]}),
        .S({current_us[4],\current_us[1]_i_4_n_0 ,\current_us[1]_i_5_n_0 ,current_us[1]}));
  FDRE \current_us_reg[20] 
       (.C(clk),
        .CE(\current_us[31]_i_1_n_0 ),
        .D(p_34_out[20]),
        .Q(current_us[20]),
        .R(p_0_in));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[20]_i_2 
       (.CI(1'b0),
        .CO({\current_us_reg[20]_i_2_n_0 ,\current_us_reg[20]_i_2_n_1 ,\current_us_reg[20]_i_2_n_2 ,\current_us_reg[20]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({current_us[20],1'b0,current_us[18],1'b0}),
        .O({position16_in[4:2],\NLW_current_us_reg[20]_i_2_O_UNCONNECTED [0]}),
        .S({\current_us[20]_i_4_n_0 ,current_us[19],\current_us[20]_i_5_n_0 ,current_us[17]}));
  FDRE \current_us_reg[21] 
       (.C(clk),
        .CE(\current_us[31]_i_1_n_0 ),
        .D(p_34_out[21]),
        .Q(current_us[21]),
        .R(p_0_in));
  FDRE \current_us_reg[22] 
       (.C(clk),
        .CE(\current_us[31]_i_1_n_0 ),
        .D(p_34_out[22]),
        .Q(current_us[22]),
        .R(p_0_in));
  FDRE \current_us_reg[23] 
       (.C(clk),
        .CE(\current_us[31]_i_1_n_0 ),
        .D(p_34_out[23]),
        .Q(current_us[23]),
        .R(p_0_in));
  FDRE \current_us_reg[24] 
       (.C(clk),
        .CE(\current_us[31]_i_1_n_0 ),
        .D(p_34_out[24]),
        .Q(current_us[24]),
        .R(p_0_in));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[24]_i_2 
       (.CI(\current_us_reg[20]_i_2_n_0 ),
        .CO({\current_us_reg[24]_i_2_n_0 ,\current_us_reg[24]_i_2_n_1 ,\current_us_reg[24]_i_2_n_2 ,\current_us_reg[24]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(position16_in[8:5]),
        .S(current_us[24:21]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[24]_i_4 
       (.CI(\current_us_reg[17]_i_2_n_0 ),
        .CO({\current_us_reg[24]_i_4_n_0 ,\current_us_reg[24]_i_4_n_1 ,\current_us_reg[24]_i_4_n_2 ,\current_us_reg[24]_i_4_n_3 }),
        .CYINIT(1'b0),
        .DI(current_us[24:21]),
        .O(position14_in[8:5]),
        .S({\current_us[24]_i_5_n_0 ,\current_us[24]_i_6_n_0 ,\current_us[24]_i_7_n_0 ,\current_us[24]_i_8_n_0 }));
  FDRE \current_us_reg[25] 
       (.C(clk),
        .CE(\current_us[31]_i_1_n_0 ),
        .D(p_34_out[25]),
        .Q(current_us[25]),
        .R(p_0_in));
  FDRE \current_us_reg[26] 
       (.C(clk),
        .CE(\current_us[31]_i_1_n_0 ),
        .D(p_34_out[26]),
        .Q(current_us[26]),
        .R(p_0_in));
  FDRE \current_us_reg[27] 
       (.C(clk),
        .CE(\current_us[31]_i_1_n_0 ),
        .D(p_34_out[27]),
        .Q(current_us[27]),
        .R(p_0_in));
  FDRE \current_us_reg[28] 
       (.C(clk),
        .CE(\current_us[31]_i_1_n_0 ),
        .D(p_34_out[28]),
        .Q(current_us[28]),
        .R(p_0_in));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[28]_i_2 
       (.CI(\current_us_reg[24]_i_2_n_0 ),
        .CO({\current_us_reg[28]_i_2_n_0 ,\current_us_reg[28]_i_2_n_1 ,\current_us_reg[28]_i_2_n_2 ,\current_us_reg[28]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(position16_in[12:9]),
        .S(current_us[28:25]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[28]_i_4 
       (.CI(\current_us_reg[24]_i_4_n_0 ),
        .CO({\current_us_reg[28]_i_4_n_0 ,\current_us_reg[28]_i_4_n_1 ,\current_us_reg[28]_i_4_n_2 ,\current_us_reg[28]_i_4_n_3 }),
        .CYINIT(1'b0),
        .DI(current_us[28:25]),
        .O(position14_in[12:9]),
        .S({\current_us[28]_i_5_n_0 ,\current_us[28]_i_6_n_0 ,\current_us[28]_i_7_n_0 ,\current_us[28]_i_8_n_0 }));
  FDRE \current_us_reg[29] 
       (.C(clk),
        .CE(\current_us[31]_i_1_n_0 ),
        .D(p_34_out[29]),
        .Q(current_us[29]),
        .R(p_0_in));
  FDRE \current_us_reg[2] 
       (.C(clk),
        .CE(\current_us[15]_i_1_n_0 ),
        .D(p_34_out[2]),
        .Q(current_us[2]),
        .R(p_0_in));
  FDRE \current_us_reg[30] 
       (.C(clk),
        .CE(\current_us[31]_i_1_n_0 ),
        .D(p_34_out[30]),
        .Q(current_us[30]),
        .R(p_0_in));
  FDRE \current_us_reg[31] 
       (.C(clk),
        .CE(\current_us[31]_i_1_n_0 ),
        .D(p_34_out[31]),
        .Q(current_us[31]),
        .R(p_0_in));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \current_us_reg[31]_i_17 
       (.CI(1'b0),
        .CO({\current_us_reg[31]_i_17_n_0 ,\current_us_reg[31]_i_17_n_1 ,\current_us_reg[31]_i_17_n_2 ,\current_us_reg[31]_i_17_n_3 }),
        .CYINIT(1'b0),
        .DI({\current_us[31]_i_43_n_0 ,\current_us[31]_i_44_n_0 ,\current_us[31]_i_45_n_0 ,\current_us[31]_i_46_n_0 }),
        .O(\NLW_current_us_reg[31]_i_17_O_UNCONNECTED [3:0]),
        .S({\current_us[31]_i_47_n_0 ,\current_us[31]_i_48_n_0 ,\current_us[31]_i_49_n_0 ,\current_us[31]_i_50_n_0 }));
  CARRY4 \current_us_reg[31]_i_27 
       (.CI(\current_us_reg[31]_i_51_n_0 ),
        .CO({\current_us_reg[31]_i_27_n_0 ,\current_us_reg[31]_i_27_n_1 ,\current_us_reg[31]_i_27_n_2 ,\current_us_reg[31]_i_27_n_3 }),
        .CYINIT(1'b0),
        .DI(\pending_reg[1] [15:12]),
        .O({\current_us_reg[31]_i_27_n_4 ,\current_us_reg[31]_i_27_n_5 ,\current_us_reg[31]_i_27_n_6 ,\current_us_reg[31]_i_27_n_7 }),
        .S({\current_us[31]_i_52_n_0 ,\current_us[31]_i_53_n_0 ,\current_us[31]_i_54_n_0 ,\current_us[31]_i_55_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \current_us_reg[31]_i_3 
       (.CI(\current_us_reg[31]_i_8_n_0 ),
        .CO({position17_in,\current_us_reg[31]_i_3_n_1 ,\current_us_reg[31]_i_3_n_2 ,\current_us_reg[31]_i_3_n_3 }),
        .CYINIT(1'b0),
        .DI({\current_us[31]_i_9_n_0 ,\current_us[31]_i_10_n_0 ,\current_us[31]_i_11_n_0 ,\current_us[31]_i_12_n_0 }),
        .O(\NLW_current_us_reg[31]_i_3_O_UNCONNECTED [3:0]),
        .S({\current_us[31]_i_13_n_0 ,\current_us[31]_i_14_n_0 ,\current_us[31]_i_15_n_0 ,\current_us[31]_i_16_n_0 }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[31]_i_34 
       (.CI(\current_us_reg[28]_i_4_n_0 ),
        .CO({\NLW_current_us_reg[31]_i_34_CO_UNCONNECTED [3:2],\current_us_reg[31]_i_34_n_2 ,\current_us_reg[31]_i_34_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,current_us[30:29]}),
        .O({\NLW_current_us_reg[31]_i_34_O_UNCONNECTED [3],position14_in[15:13]}),
        .S({1'b0,\current_us[31]_i_63_n_0 ,\current_us[31]_i_64_n_0 ,\current_us[31]_i_65_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \current_us_reg[31]_i_4 
       (.CI(\current_us_reg[31]_i_17_n_0 ),
        .CO({\current_us_reg[31]_i_4_n_0 ,\current_us_reg[31]_i_4_n_1 ,\current_us_reg[31]_i_4_n_2 ,\current_us_reg[31]_i_4_n_3 }),
        .CYINIT(1'b0),
        .DI({\current_us[31]_i_18_n_0 ,\current_us[31]_i_19_n_0 ,\current_us[31]_i_20_n_0 ,\current_us[31]_i_21_n_0 }),
        .O(\NLW_current_us_reg[31]_i_4_O_UNCONNECTED [3:0]),
        .S({\current_us[31]_i_22_n_0 ,\current_us[31]_i_23_n_0 ,\current_us[31]_i_24_n_0 ,\current_us[31]_i_25_n_0 }));
  CARRY4 \current_us_reg[31]_i_51 
       (.CI(\current_us_reg[31]_i_57_n_0 ),
        .CO({\current_us_reg[31]_i_51_n_0 ,\current_us_reg[31]_i_51_n_1 ,\current_us_reg[31]_i_51_n_2 ,\current_us_reg[31]_i_51_n_3 }),
        .CYINIT(1'b0),
        .DI(\pending_reg[1] [11:8]),
        .O({\current_us_reg[31]_i_51_n_4 ,\current_us_reg[31]_i_51_n_5 ,\current_us_reg[31]_i_51_n_6 ,\current_us_reg[31]_i_51_n_7 }),
        .S({\current_us[31]_i_66_n_0 ,\current_us[31]_i_67_n_0 ,\current_us[31]_i_68_n_0 ,\current_us[31]_i_69_n_0 }));
  CARRY4 \current_us_reg[31]_i_56 
       (.CI(\current_us_reg[31]_i_27_n_0 ),
        .CO({\NLW_current_us_reg[31]_i_56_CO_UNCONNECTED [3:1],\current_us_reg[31]_i_56_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(\NLW_current_us_reg[31]_i_56_O_UNCONNECTED [3:0]),
        .S({1'b0,1'b0,1'b0,1'b1}));
  CARRY4 \current_us_reg[31]_i_57 
       (.CI(\current_us_reg[31]_i_58_n_0 ),
        .CO({\current_us_reg[31]_i_57_n_0 ,\current_us_reg[31]_i_57_n_1 ,\current_us_reg[31]_i_57_n_2 ,\current_us_reg[31]_i_57_n_3 }),
        .CYINIT(1'b0),
        .DI(\pending_reg[1] [7:4]),
        .O({\current_us_reg[31]_i_57_n_4 ,\current_us_reg[31]_i_57_n_5 ,\current_us_reg[31]_i_57_n_6 ,\current_us_reg[31]_i_57_n_7 }),
        .S({\current_us[31]_i_70_n_0 ,\current_us[31]_i_71_n_0 ,\current_us[31]_i_72_n_0 ,\current_us[31]_i_73_n_0 }));
  CARRY4 \current_us_reg[31]_i_58 
       (.CI(1'b0),
        .CO({\current_us_reg[31]_i_58_n_0 ,\current_us_reg[31]_i_58_n_1 ,\current_us_reg[31]_i_58_n_2 ,\current_us_reg[31]_i_58_n_3 }),
        .CYINIT(1'b1),
        .DI(\pending_reg[1] [3:0]),
        .O({\current_us_reg[31]_i_58_n_4 ,\current_us_reg[31]_i_58_n_5 ,\current_us_reg[31]_i_58_n_6 ,\current_us_reg[31]_i_58_n_7 }),
        .S({\current_us[31]_i_74_n_0 ,\current_us[31]_i_75_n_0 ,\current_us[31]_i_76_n_0 ,\current_us[31]_i_77_n_0 }));
  CARRY4 \current_us_reg[31]_i_59 
       (.CI(\current_us_reg[31]_i_61_n_0 ),
        .CO({\current_us_reg[31]_i_59_n_0 ,\current_us_reg[31]_i_59_n_1 ,\current_us_reg[31]_i_59_n_2 ,\current_us_reg[31]_i_59_n_3 }),
        .CYINIT(1'b0),
        .DI(current_us[27:24]),
        .O({\current_us_reg[31]_i_59_n_4 ,\current_us_reg[31]_i_59_n_5 ,\current_us_reg[31]_i_59_n_6 ,\current_us_reg[31]_i_59_n_7 }),
        .S({\current_us[31]_i_78_n_0 ,\current_us[31]_i_79_n_0 ,\current_us[31]_i_80_n_0 ,\current_us[31]_i_81_n_0 }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[31]_i_6 
       (.CI(\current_us_reg[28]_i_2_n_0 ),
        .CO({\NLW_current_us_reg[31]_i_6_CO_UNCONNECTED [3:2],\current_us_reg[31]_i_6_n_2 ,\current_us_reg[31]_i_6_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\NLW_current_us_reg[31]_i_6_O_UNCONNECTED [3],position16_in[15:13]}),
        .S({1'b0,current_us[31:29]}));
  CARRY4 \current_us_reg[31]_i_60 
       (.CI(\current_us_reg[16]_i_3_n_0 ),
        .CO({\NLW_current_us_reg[31]_i_60_CO_UNCONNECTED [3:1],\current_us_reg[31]_i_60_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(\NLW_current_us_reg[31]_i_60_O_UNCONNECTED [3:0]),
        .S({1'b0,1'b0,1'b0,1'b1}));
  CARRY4 \current_us_reg[31]_i_61 
       (.CI(\current_us_reg[31]_i_62_n_0 ),
        .CO({\current_us_reg[31]_i_61_n_0 ,\current_us_reg[31]_i_61_n_1 ,\current_us_reg[31]_i_61_n_2 ,\current_us_reg[31]_i_61_n_3 }),
        .CYINIT(1'b0),
        .DI(current_us[23:20]),
        .O({\current_us_reg[31]_i_61_n_4 ,\current_us_reg[31]_i_61_n_5 ,\current_us_reg[31]_i_61_n_6 ,\current_us_reg[31]_i_61_n_7 }),
        .S({\current_us[31]_i_82_n_0 ,\current_us[31]_i_83_n_0 ,\current_us[31]_i_84_n_0 ,\current_us[31]_i_85_n_0 }));
  CARRY4 \current_us_reg[31]_i_62 
       (.CI(1'b0),
        .CO({\current_us_reg[31]_i_62_n_0 ,\current_us_reg[31]_i_62_n_1 ,\current_us_reg[31]_i_62_n_2 ,\current_us_reg[31]_i_62_n_3 }),
        .CYINIT(1'b1),
        .DI(current_us[19:16]),
        .O({\current_us_reg[31]_i_62_n_4 ,\current_us_reg[31]_i_62_n_5 ,\current_us_reg[31]_i_62_n_6 ,\current_us_reg[31]_i_62_n_7 }),
        .S({\current_us[31]_i_86_n_0 ,\current_us[31]_i_87_n_0 ,\current_us[31]_i_88_n_0 ,\current_us[31]_i_89_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \current_us_reg[31]_i_8 
       (.CI(1'b0),
        .CO({\current_us_reg[31]_i_8_n_0 ,\current_us_reg[31]_i_8_n_1 ,\current_us_reg[31]_i_8_n_2 ,\current_us_reg[31]_i_8_n_3 }),
        .CYINIT(1'b0),
        .DI({\current_us[31]_i_35_n_0 ,\current_us[31]_i_36_n_0 ,\current_us[31]_i_37_n_0 ,\current_us[31]_i_38_n_0 }),
        .O(\NLW_current_us_reg[31]_i_8_O_UNCONNECTED [3:0]),
        .S({\current_us[31]_i_39_n_0 ,\current_us[31]_i_40_n_0 ,\current_us[31]_i_41_n_0 ,\current_us[31]_i_42_n_0 }));
  FDRE \current_us_reg[32] 
       (.C(clk),
        .CE(\current_us[47]_i_1_n_0 ),
        .D(p_34_out[32]),
        .Q(current_us[32]),
        .R(p_0_in));
  CARRY4 \current_us_reg[32]_i_3 
       (.CI(\current_us_reg[47]_i_59_n_0 ),
        .CO({\current_us_reg[32]_i_3_n_0 ,\current_us_reg[32]_i_3_n_1 ,\current_us_reg[32]_i_3_n_2 ,\current_us_reg[32]_i_3_n_3 }),
        .CYINIT(1'b0),
        .DI(current_us[47:44]),
        .O({\current_us_reg[32]_i_3_n_4 ,\current_us_reg[32]_i_3_n_5 ,\current_us_reg[32]_i_3_n_6 ,\current_us_reg[32]_i_3_n_7 }),
        .S({\current_us[32]_i_4_n_0 ,\current_us[32]_i_5_n_0 ,\current_us[32]_i_6_n_0 ,\current_us[32]_i_7_n_0 }));
  FDRE \current_us_reg[33] 
       (.C(clk),
        .CE(\current_us[47]_i_1_n_0 ),
        .D(p_34_out[33]),
        .Q(current_us[33]),
        .R(p_0_in));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[33]_i_2 
       (.CI(1'b0),
        .CO({\current_us_reg[33]_i_2_n_0 ,\current_us_reg[33]_i_2_n_1 ,\current_us_reg[33]_i_2_n_2 ,\current_us_reg[33]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,current_us[35:34],1'b0}),
        .O({position19_in[4:2],position111_in[1]}),
        .S({current_us[36],\current_us[33]_i_4_n_0 ,\current_us[33]_i_5_n_0 ,current_us[33]}));
  FDRE \current_us_reg[34] 
       (.C(clk),
        .CE(\current_us[47]_i_1_n_0 ),
        .D(p_34_out[34]),
        .Q(current_us[34]),
        .R(p_0_in));
  FDRE \current_us_reg[35] 
       (.C(clk),
        .CE(\current_us[47]_i_1_n_0 ),
        .D(p_34_out[35]),
        .Q(current_us[35]),
        .R(p_0_in));
  FDRE \current_us_reg[36] 
       (.C(clk),
        .CE(\current_us[47]_i_1_n_0 ),
        .D(p_34_out[36]),
        .Q(current_us[36]),
        .R(p_0_in));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[36]_i_2 
       (.CI(1'b0),
        .CO({\current_us_reg[36]_i_2_n_0 ,\current_us_reg[36]_i_2_n_1 ,\current_us_reg[36]_i_2_n_2 ,\current_us_reg[36]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({current_us[36],1'b0,current_us[34],1'b0}),
        .O({position111_in[4:2],\NLW_current_us_reg[36]_i_2_O_UNCONNECTED [0]}),
        .S({\current_us[36]_i_4_n_0 ,current_us[35],\current_us[36]_i_5_n_0 ,current_us[33]}));
  FDRE \current_us_reg[37] 
       (.C(clk),
        .CE(\current_us[47]_i_1_n_0 ),
        .D(p_34_out[37]),
        .Q(current_us[37]),
        .R(p_0_in));
  FDRE \current_us_reg[38] 
       (.C(clk),
        .CE(\current_us[47]_i_1_n_0 ),
        .D(p_34_out[38]),
        .Q(current_us[38]),
        .R(p_0_in));
  FDRE \current_us_reg[39] 
       (.C(clk),
        .CE(\current_us[47]_i_1_n_0 ),
        .D(p_34_out[39]),
        .Q(current_us[39]),
        .R(p_0_in));
  FDRE \current_us_reg[3] 
       (.C(clk),
        .CE(\current_us[15]_i_1_n_0 ),
        .D(p_34_out[3]),
        .Q(current_us[3]),
        .R(p_0_in));
  FDRE \current_us_reg[40] 
       (.C(clk),
        .CE(\current_us[47]_i_1_n_0 ),
        .D(p_34_out[40]),
        .Q(current_us[40]),
        .R(p_0_in));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[40]_i_2 
       (.CI(\current_us_reg[36]_i_2_n_0 ),
        .CO({\current_us_reg[40]_i_2_n_0 ,\current_us_reg[40]_i_2_n_1 ,\current_us_reg[40]_i_2_n_2 ,\current_us_reg[40]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(position111_in[8:5]),
        .S(current_us[40:37]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[40]_i_4 
       (.CI(\current_us_reg[33]_i_2_n_0 ),
        .CO({\current_us_reg[40]_i_4_n_0 ,\current_us_reg[40]_i_4_n_1 ,\current_us_reg[40]_i_4_n_2 ,\current_us_reg[40]_i_4_n_3 }),
        .CYINIT(1'b0),
        .DI(current_us[40:37]),
        .O(position19_in[8:5]),
        .S({\current_us[40]_i_5_n_0 ,\current_us[40]_i_6_n_0 ,\current_us[40]_i_7_n_0 ,\current_us[40]_i_8_n_0 }));
  FDRE \current_us_reg[41] 
       (.C(clk),
        .CE(\current_us[47]_i_1_n_0 ),
        .D(p_34_out[41]),
        .Q(current_us[41]),
        .R(p_0_in));
  FDRE \current_us_reg[42] 
       (.C(clk),
        .CE(\current_us[47]_i_1_n_0 ),
        .D(p_34_out[42]),
        .Q(current_us[42]),
        .R(p_0_in));
  FDRE \current_us_reg[43] 
       (.C(clk),
        .CE(\current_us[47]_i_1_n_0 ),
        .D(p_34_out[43]),
        .Q(current_us[43]),
        .R(p_0_in));
  FDRE \current_us_reg[44] 
       (.C(clk),
        .CE(\current_us[47]_i_1_n_0 ),
        .D(p_34_out[44]),
        .Q(current_us[44]),
        .R(p_0_in));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[44]_i_2 
       (.CI(\current_us_reg[40]_i_2_n_0 ),
        .CO({\current_us_reg[44]_i_2_n_0 ,\current_us_reg[44]_i_2_n_1 ,\current_us_reg[44]_i_2_n_2 ,\current_us_reg[44]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(position111_in[12:9]),
        .S(current_us[44:41]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[44]_i_4 
       (.CI(\current_us_reg[40]_i_4_n_0 ),
        .CO({\current_us_reg[44]_i_4_n_0 ,\current_us_reg[44]_i_4_n_1 ,\current_us_reg[44]_i_4_n_2 ,\current_us_reg[44]_i_4_n_3 }),
        .CYINIT(1'b0),
        .DI(current_us[44:41]),
        .O(position19_in[12:9]),
        .S({\current_us[44]_i_5_n_0 ,\current_us[44]_i_6_n_0 ,\current_us[44]_i_7_n_0 ,\current_us[44]_i_8_n_0 }));
  FDRE \current_us_reg[45] 
       (.C(clk),
        .CE(\current_us[47]_i_1_n_0 ),
        .D(p_34_out[45]),
        .Q(current_us[45]),
        .R(p_0_in));
  FDRE \current_us_reg[46] 
       (.C(clk),
        .CE(\current_us[47]_i_1_n_0 ),
        .D(p_34_out[46]),
        .Q(current_us[46]),
        .R(p_0_in));
  FDRE \current_us_reg[47] 
       (.C(clk),
        .CE(\current_us[47]_i_1_n_0 ),
        .D(p_34_out[47]),
        .Q(current_us[47]),
        .R(p_0_in));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \current_us_reg[47]_i_17 
       (.CI(1'b0),
        .CO({\current_us_reg[47]_i_17_n_0 ,\current_us_reg[47]_i_17_n_1 ,\current_us_reg[47]_i_17_n_2 ,\current_us_reg[47]_i_17_n_3 }),
        .CYINIT(1'b0),
        .DI({\current_us[47]_i_43_n_0 ,\current_us[47]_i_44_n_0 ,\current_us[47]_i_45_n_0 ,\current_us[47]_i_46_n_0 }),
        .O(\NLW_current_us_reg[47]_i_17_O_UNCONNECTED [3:0]),
        .S({\current_us[47]_i_47_n_0 ,\current_us[47]_i_48_n_0 ,\current_us[47]_i_49_n_0 ,\current_us[47]_i_50_n_0 }));
  CARRY4 \current_us_reg[47]_i_27 
       (.CI(\current_us_reg[47]_i_51_n_0 ),
        .CO({\current_us_reg[47]_i_27_n_0 ,\current_us_reg[47]_i_27_n_1 ,\current_us_reg[47]_i_27_n_2 ,\current_us_reg[47]_i_27_n_3 }),
        .CYINIT(1'b0),
        .DI(\pending_reg[2] [15:12]),
        .O({\current_us_reg[47]_i_27_n_4 ,\current_us_reg[47]_i_27_n_5 ,\current_us_reg[47]_i_27_n_6 ,\current_us_reg[47]_i_27_n_7 }),
        .S({\current_us[47]_i_52_n_0 ,\current_us[47]_i_53_n_0 ,\current_us[47]_i_54_n_0 ,\current_us[47]_i_55_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \current_us_reg[47]_i_3 
       (.CI(\current_us_reg[47]_i_8_n_0 ),
        .CO({position112_in,\current_us_reg[47]_i_3_n_1 ,\current_us_reg[47]_i_3_n_2 ,\current_us_reg[47]_i_3_n_3 }),
        .CYINIT(1'b0),
        .DI({\current_us[47]_i_9_n_0 ,\current_us[47]_i_10_n_0 ,\current_us[47]_i_11_n_0 ,\current_us[47]_i_12_n_0 }),
        .O(\NLW_current_us_reg[47]_i_3_O_UNCONNECTED [3:0]),
        .S({\current_us[47]_i_13_n_0 ,\current_us[47]_i_14_n_0 ,\current_us[47]_i_15_n_0 ,\current_us[47]_i_16_n_0 }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[47]_i_34 
       (.CI(\current_us_reg[44]_i_4_n_0 ),
        .CO({\NLW_current_us_reg[47]_i_34_CO_UNCONNECTED [3:2],\current_us_reg[47]_i_34_n_2 ,\current_us_reg[47]_i_34_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,current_us[46:45]}),
        .O({\NLW_current_us_reg[47]_i_34_O_UNCONNECTED [3],position19_in[15:13]}),
        .S({1'b0,\current_us[47]_i_63_n_0 ,\current_us[47]_i_64_n_0 ,\current_us[47]_i_65_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \current_us_reg[47]_i_4 
       (.CI(\current_us_reg[47]_i_17_n_0 ),
        .CO({p_5_in,\current_us_reg[47]_i_4_n_1 ,\current_us_reg[47]_i_4_n_2 ,\current_us_reg[47]_i_4_n_3 }),
        .CYINIT(1'b0),
        .DI({\current_us[47]_i_18_n_0 ,\current_us[47]_i_19_n_0 ,\current_us[47]_i_20_n_0 ,\current_us[47]_i_21_n_0 }),
        .O(\NLW_current_us_reg[47]_i_4_O_UNCONNECTED [3:0]),
        .S({\current_us[47]_i_22_n_0 ,\current_us[47]_i_23_n_0 ,\current_us[47]_i_24_n_0 ,\current_us[47]_i_25_n_0 }));
  CARRY4 \current_us_reg[47]_i_51 
       (.CI(\current_us_reg[47]_i_57_n_0 ),
        .CO({\current_us_reg[47]_i_51_n_0 ,\current_us_reg[47]_i_51_n_1 ,\current_us_reg[47]_i_51_n_2 ,\current_us_reg[47]_i_51_n_3 }),
        .CYINIT(1'b0),
        .DI(\pending_reg[2] [11:8]),
        .O({\current_us_reg[47]_i_51_n_4 ,\current_us_reg[47]_i_51_n_5 ,\current_us_reg[47]_i_51_n_6 ,\current_us_reg[47]_i_51_n_7 }),
        .S({\current_us[47]_i_66_n_0 ,\current_us[47]_i_67_n_0 ,\current_us[47]_i_68_n_0 ,\current_us[47]_i_69_n_0 }));
  CARRY4 \current_us_reg[47]_i_56 
       (.CI(\current_us_reg[47]_i_27_n_0 ),
        .CO({\NLW_current_us_reg[47]_i_56_CO_UNCONNECTED [3:1],\current_us_reg[47]_i_56_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(\NLW_current_us_reg[47]_i_56_O_UNCONNECTED [3:0]),
        .S({1'b0,1'b0,1'b0,1'b1}));
  CARRY4 \current_us_reg[47]_i_57 
       (.CI(\current_us_reg[47]_i_58_n_0 ),
        .CO({\current_us_reg[47]_i_57_n_0 ,\current_us_reg[47]_i_57_n_1 ,\current_us_reg[47]_i_57_n_2 ,\current_us_reg[47]_i_57_n_3 }),
        .CYINIT(1'b0),
        .DI(\pending_reg[2] [7:4]),
        .O({\current_us_reg[47]_i_57_n_4 ,\current_us_reg[47]_i_57_n_5 ,\current_us_reg[47]_i_57_n_6 ,\current_us_reg[47]_i_57_n_7 }),
        .S({\current_us[47]_i_70_n_0 ,\current_us[47]_i_71_n_0 ,\current_us[47]_i_72_n_0 ,\current_us[47]_i_73_n_0 }));
  CARRY4 \current_us_reg[47]_i_58 
       (.CI(1'b0),
        .CO({\current_us_reg[47]_i_58_n_0 ,\current_us_reg[47]_i_58_n_1 ,\current_us_reg[47]_i_58_n_2 ,\current_us_reg[47]_i_58_n_3 }),
        .CYINIT(1'b1),
        .DI(\pending_reg[2] [3:0]),
        .O({\current_us_reg[47]_i_58_n_4 ,\current_us_reg[47]_i_58_n_5 ,\current_us_reg[47]_i_58_n_6 ,\current_us_reg[47]_i_58_n_7 }),
        .S({\current_us[47]_i_74_n_0 ,\current_us[47]_i_75_n_0 ,\current_us[47]_i_76_n_0 ,\current_us[47]_i_77_n_0 }));
  CARRY4 \current_us_reg[47]_i_59 
       (.CI(\current_us_reg[47]_i_61_n_0 ),
        .CO({\current_us_reg[47]_i_59_n_0 ,\current_us_reg[47]_i_59_n_1 ,\current_us_reg[47]_i_59_n_2 ,\current_us_reg[47]_i_59_n_3 }),
        .CYINIT(1'b0),
        .DI(current_us[43:40]),
        .O({\current_us_reg[47]_i_59_n_4 ,\current_us_reg[47]_i_59_n_5 ,\current_us_reg[47]_i_59_n_6 ,\current_us_reg[47]_i_59_n_7 }),
        .S({\current_us[47]_i_78_n_0 ,\current_us[47]_i_79_n_0 ,\current_us[47]_i_80_n_0 ,\current_us[47]_i_81_n_0 }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[47]_i_6 
       (.CI(\current_us_reg[44]_i_2_n_0 ),
        .CO({\NLW_current_us_reg[47]_i_6_CO_UNCONNECTED [3:2],\current_us_reg[47]_i_6_n_2 ,\current_us_reg[47]_i_6_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\NLW_current_us_reg[47]_i_6_O_UNCONNECTED [3],position111_in[15:13]}),
        .S({1'b0,current_us[47:45]}));
  CARRY4 \current_us_reg[47]_i_60 
       (.CI(\current_us_reg[32]_i_3_n_0 ),
        .CO({\NLW_current_us_reg[47]_i_60_CO_UNCONNECTED [3:1],\current_us_reg[47]_i_60_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(\NLW_current_us_reg[47]_i_60_O_UNCONNECTED [3:0]),
        .S({1'b0,1'b0,1'b0,1'b1}));
  CARRY4 \current_us_reg[47]_i_61 
       (.CI(\current_us_reg[47]_i_62_n_0 ),
        .CO({\current_us_reg[47]_i_61_n_0 ,\current_us_reg[47]_i_61_n_1 ,\current_us_reg[47]_i_61_n_2 ,\current_us_reg[47]_i_61_n_3 }),
        .CYINIT(1'b0),
        .DI(current_us[39:36]),
        .O({\current_us_reg[47]_i_61_n_4 ,\current_us_reg[47]_i_61_n_5 ,\current_us_reg[47]_i_61_n_6 ,\current_us_reg[47]_i_61_n_7 }),
        .S({\current_us[47]_i_82_n_0 ,\current_us[47]_i_83_n_0 ,\current_us[47]_i_84_n_0 ,\current_us[47]_i_85_n_0 }));
  CARRY4 \current_us_reg[47]_i_62 
       (.CI(1'b0),
        .CO({\current_us_reg[47]_i_62_n_0 ,\current_us_reg[47]_i_62_n_1 ,\current_us_reg[47]_i_62_n_2 ,\current_us_reg[47]_i_62_n_3 }),
        .CYINIT(1'b1),
        .DI(current_us[35:32]),
        .O({\current_us_reg[47]_i_62_n_4 ,\current_us_reg[47]_i_62_n_5 ,\current_us_reg[47]_i_62_n_6 ,\current_us_reg[47]_i_62_n_7 }),
        .S({\current_us[47]_i_86_n_0 ,\current_us[47]_i_87_n_0 ,\current_us[47]_i_88_n_0 ,\current_us[47]_i_89_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \current_us_reg[47]_i_8 
       (.CI(1'b0),
        .CO({\current_us_reg[47]_i_8_n_0 ,\current_us_reg[47]_i_8_n_1 ,\current_us_reg[47]_i_8_n_2 ,\current_us_reg[47]_i_8_n_3 }),
        .CYINIT(1'b0),
        .DI({\current_us[47]_i_35_n_0 ,\current_us[47]_i_36_n_0 ,\current_us[47]_i_37_n_0 ,\current_us[47]_i_38_n_0 }),
        .O(\NLW_current_us_reg[47]_i_8_O_UNCONNECTED [3:0]),
        .S({\current_us[47]_i_39_n_0 ,\current_us[47]_i_40_n_0 ,\current_us[47]_i_41_n_0 ,\current_us[47]_i_42_n_0 }));
  FDRE \current_us_reg[48] 
       (.C(clk),
        .CE(\current_us[63]_i_1_n_0 ),
        .D(p_34_out[48]),
        .Q(current_us[48]),
        .R(p_0_in));
  CARRY4 \current_us_reg[48]_i_3 
       (.CI(\current_us_reg[63]_i_59_n_0 ),
        .CO({\current_us_reg[48]_i_3_n_0 ,\current_us_reg[48]_i_3_n_1 ,\current_us_reg[48]_i_3_n_2 ,\current_us_reg[48]_i_3_n_3 }),
        .CYINIT(1'b0),
        .DI(current_us[63:60]),
        .O({\current_us_reg[48]_i_3_n_4 ,\current_us_reg[48]_i_3_n_5 ,\current_us_reg[48]_i_3_n_6 ,\current_us_reg[48]_i_3_n_7 }),
        .S({\current_us[48]_i_4_n_0 ,\current_us[48]_i_5_n_0 ,\current_us[48]_i_6_n_0 ,\current_us[48]_i_7_n_0 }));
  FDRE \current_us_reg[49] 
       (.C(clk),
        .CE(\current_us[63]_i_1_n_0 ),
        .D(p_34_out[49]),
        .Q(current_us[49]),
        .R(p_0_in));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[49]_i_2 
       (.CI(1'b0),
        .CO({\current_us_reg[49]_i_2_n_0 ,\current_us_reg[49]_i_2_n_1 ,\current_us_reg[49]_i_2_n_2 ,\current_us_reg[49]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,current_us[51:50],1'b0}),
        .O({position114_in[4:2],position116_in[1]}),
        .S({current_us[52],\current_us[49]_i_4_n_0 ,\current_us[49]_i_5_n_0 ,current_us[49]}));
  FDRE \current_us_reg[4] 
       (.C(clk),
        .CE(\current_us[15]_i_1_n_0 ),
        .D(p_34_out[4]),
        .Q(current_us[4]),
        .R(p_0_in));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[4]_i_2 
       (.CI(1'b0),
        .CO({\current_us_reg[4]_i_2_n_0 ,\current_us_reg[4]_i_2_n_1 ,\current_us_reg[4]_i_2_n_2 ,\current_us_reg[4]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({current_us[4],1'b0,current_us[2],1'b0}),
        .O({position11_in[4:2],\NLW_current_us_reg[4]_i_2_O_UNCONNECTED [0]}),
        .S({\current_us[4]_i_4_n_0 ,current_us[3],\current_us[4]_i_5_n_0 ,current_us[1]}));
  FDRE \current_us_reg[50] 
       (.C(clk),
        .CE(\current_us[63]_i_1_n_0 ),
        .D(p_34_out[50]),
        .Q(current_us[50]),
        .R(p_0_in));
  FDRE \current_us_reg[51] 
       (.C(clk),
        .CE(\current_us[63]_i_1_n_0 ),
        .D(p_34_out[51]),
        .Q(current_us[51]),
        .R(p_0_in));
  FDRE \current_us_reg[52] 
       (.C(clk),
        .CE(\current_us[63]_i_1_n_0 ),
        .D(p_34_out[52]),
        .Q(current_us[52]),
        .R(p_0_in));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[52]_i_2 
       (.CI(1'b0),
        .CO({\current_us_reg[52]_i_2_n_0 ,\current_us_reg[52]_i_2_n_1 ,\current_us_reg[52]_i_2_n_2 ,\current_us_reg[52]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({current_us[52],1'b0,current_us[50],1'b0}),
        .O({position116_in[4:2],\NLW_current_us_reg[52]_i_2_O_UNCONNECTED [0]}),
        .S({\current_us[52]_i_4_n_0 ,current_us[51],\current_us[52]_i_5_n_0 ,current_us[49]}));
  FDRE \current_us_reg[53] 
       (.C(clk),
        .CE(\current_us[63]_i_1_n_0 ),
        .D(p_34_out[53]),
        .Q(current_us[53]),
        .R(p_0_in));
  FDRE \current_us_reg[54] 
       (.C(clk),
        .CE(\current_us[63]_i_1_n_0 ),
        .D(p_34_out[54]),
        .Q(current_us[54]),
        .R(p_0_in));
  FDRE \current_us_reg[55] 
       (.C(clk),
        .CE(\current_us[63]_i_1_n_0 ),
        .D(p_34_out[55]),
        .Q(current_us[55]),
        .R(p_0_in));
  FDRE \current_us_reg[56] 
       (.C(clk),
        .CE(\current_us[63]_i_1_n_0 ),
        .D(p_34_out[56]),
        .Q(current_us[56]),
        .R(p_0_in));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[56]_i_2 
       (.CI(\current_us_reg[52]_i_2_n_0 ),
        .CO({\current_us_reg[56]_i_2_n_0 ,\current_us_reg[56]_i_2_n_1 ,\current_us_reg[56]_i_2_n_2 ,\current_us_reg[56]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(position116_in[8:5]),
        .S(current_us[56:53]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[56]_i_4 
       (.CI(\current_us_reg[49]_i_2_n_0 ),
        .CO({\current_us_reg[56]_i_4_n_0 ,\current_us_reg[56]_i_4_n_1 ,\current_us_reg[56]_i_4_n_2 ,\current_us_reg[56]_i_4_n_3 }),
        .CYINIT(1'b0),
        .DI(current_us[56:53]),
        .O(position114_in[8:5]),
        .S({\current_us[56]_i_5_n_0 ,\current_us[56]_i_6_n_0 ,\current_us[56]_i_7_n_0 ,\current_us[56]_i_8_n_0 }));
  FDRE \current_us_reg[57] 
       (.C(clk),
        .CE(\current_us[63]_i_1_n_0 ),
        .D(p_34_out[57]),
        .Q(current_us[57]),
        .R(p_0_in));
  FDRE \current_us_reg[58] 
       (.C(clk),
        .CE(\current_us[63]_i_1_n_0 ),
        .D(p_34_out[58]),
        .Q(current_us[58]),
        .R(p_0_in));
  FDRE \current_us_reg[59] 
       (.C(clk),
        .CE(\current_us[63]_i_1_n_0 ),
        .D(p_34_out[59]),
        .Q(current_us[59]),
        .R(p_0_in));
  FDRE \current_us_reg[5] 
       (.C(clk),
        .CE(\current_us[15]_i_1_n_0 ),
        .D(p_34_out[5]),
        .Q(current_us[5]),
        .R(p_0_in));
  FDRE \current_us_reg[60] 
       (.C(clk),
        .CE(\current_us[63]_i_1_n_0 ),
        .D(p_34_out[60]),
        .Q(current_us[60]),
        .R(p_0_in));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[60]_i_2 
       (.CI(\current_us_reg[56]_i_2_n_0 ),
        .CO({\current_us_reg[60]_i_2_n_0 ,\current_us_reg[60]_i_2_n_1 ,\current_us_reg[60]_i_2_n_2 ,\current_us_reg[60]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(position116_in[12:9]),
        .S(current_us[60:57]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[60]_i_4 
       (.CI(\current_us_reg[56]_i_4_n_0 ),
        .CO({\current_us_reg[60]_i_4_n_0 ,\current_us_reg[60]_i_4_n_1 ,\current_us_reg[60]_i_4_n_2 ,\current_us_reg[60]_i_4_n_3 }),
        .CYINIT(1'b0),
        .DI(current_us[60:57]),
        .O(position114_in[12:9]),
        .S({\current_us[60]_i_5_n_0 ,\current_us[60]_i_6_n_0 ,\current_us[60]_i_7_n_0 ,\current_us[60]_i_8_n_0 }));
  FDRE \current_us_reg[61] 
       (.C(clk),
        .CE(\current_us[63]_i_1_n_0 ),
        .D(p_34_out[61]),
        .Q(current_us[61]),
        .R(p_0_in));
  FDRE \current_us_reg[62] 
       (.C(clk),
        .CE(\current_us[63]_i_1_n_0 ),
        .D(p_34_out[62]),
        .Q(current_us[62]),
        .R(p_0_in));
  FDRE \current_us_reg[63] 
       (.C(clk),
        .CE(\current_us[63]_i_1_n_0 ),
        .D(p_34_out[63]),
        .Q(current_us[63]),
        .R(p_0_in));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \current_us_reg[63]_i_17 
       (.CI(1'b0),
        .CO({\current_us_reg[63]_i_17_n_0 ,\current_us_reg[63]_i_17_n_1 ,\current_us_reg[63]_i_17_n_2 ,\current_us_reg[63]_i_17_n_3 }),
        .CYINIT(1'b0),
        .DI({\current_us[63]_i_43_n_0 ,\current_us[63]_i_44_n_0 ,\current_us[63]_i_45_n_0 ,\current_us[63]_i_46_n_0 }),
        .O(\NLW_current_us_reg[63]_i_17_O_UNCONNECTED [3:0]),
        .S({\current_us[63]_i_47_n_0 ,\current_us[63]_i_48_n_0 ,\current_us[63]_i_49_n_0 ,\current_us[63]_i_50_n_0 }));
  CARRY4 \current_us_reg[63]_i_27 
       (.CI(\current_us_reg[63]_i_51_n_0 ),
        .CO({\current_us_reg[63]_i_27_n_0 ,\current_us_reg[63]_i_27_n_1 ,\current_us_reg[63]_i_27_n_2 ,\current_us_reg[63]_i_27_n_3 }),
        .CYINIT(1'b0),
        .DI(\pending_reg[3] [15:12]),
        .O({\current_us_reg[63]_i_27_n_4 ,\current_us_reg[63]_i_27_n_5 ,\current_us_reg[63]_i_27_n_6 ,\current_us_reg[63]_i_27_n_7 }),
        .S({\current_us[63]_i_52_n_0 ,\current_us[63]_i_53_n_0 ,\current_us[63]_i_54_n_0 ,\current_us[63]_i_55_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \current_us_reg[63]_i_3 
       (.CI(\current_us_reg[63]_i_8_n_0 ),
        .CO({position117_in,\current_us_reg[63]_i_3_n_1 ,\current_us_reg[63]_i_3_n_2 ,\current_us_reg[63]_i_3_n_3 }),
        .CYINIT(1'b0),
        .DI({\current_us[63]_i_9_n_0 ,\current_us[63]_i_10_n_0 ,\current_us[63]_i_11_n_0 ,\current_us[63]_i_12_n_0 }),
        .O(\NLW_current_us_reg[63]_i_3_O_UNCONNECTED [3:0]),
        .S({\current_us[63]_i_13_n_0 ,\current_us[63]_i_14_n_0 ,\current_us[63]_i_15_n_0 ,\current_us[63]_i_16_n_0 }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[63]_i_34 
       (.CI(\current_us_reg[60]_i_4_n_0 ),
        .CO({\NLW_current_us_reg[63]_i_34_CO_UNCONNECTED [3:2],\current_us_reg[63]_i_34_n_2 ,\current_us_reg[63]_i_34_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,current_us[62:61]}),
        .O({\NLW_current_us_reg[63]_i_34_O_UNCONNECTED [3],position114_in[15:13]}),
        .S({1'b0,\current_us[63]_i_63_n_0 ,\current_us[63]_i_64_n_0 ,\current_us[63]_i_65_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \current_us_reg[63]_i_4 
       (.CI(\current_us_reg[63]_i_17_n_0 ),
        .CO({p_7_in,\current_us_reg[63]_i_4_n_1 ,\current_us_reg[63]_i_4_n_2 ,\current_us_reg[63]_i_4_n_3 }),
        .CYINIT(1'b0),
        .DI({\current_us[63]_i_18_n_0 ,\current_us[63]_i_19_n_0 ,\current_us[63]_i_20_n_0 ,\current_us[63]_i_21_n_0 }),
        .O(\NLW_current_us_reg[63]_i_4_O_UNCONNECTED [3:0]),
        .S({\current_us[63]_i_22_n_0 ,\current_us[63]_i_23_n_0 ,\current_us[63]_i_24_n_0 ,\current_us[63]_i_25_n_0 }));
  CARRY4 \current_us_reg[63]_i_51 
       (.CI(\current_us_reg[63]_i_57_n_0 ),
        .CO({\current_us_reg[63]_i_51_n_0 ,\current_us_reg[63]_i_51_n_1 ,\current_us_reg[63]_i_51_n_2 ,\current_us_reg[63]_i_51_n_3 }),
        .CYINIT(1'b0),
        .DI(\pending_reg[3] [11:8]),
        .O({\current_us_reg[63]_i_51_n_4 ,\current_us_reg[63]_i_51_n_5 ,\current_us_reg[63]_i_51_n_6 ,\current_us_reg[63]_i_51_n_7 }),
        .S({\current_us[63]_i_66_n_0 ,\current_us[63]_i_67_n_0 ,\current_us[63]_i_68_n_0 ,\current_us[63]_i_69_n_0 }));
  CARRY4 \current_us_reg[63]_i_56 
       (.CI(\current_us_reg[63]_i_27_n_0 ),
        .CO({\NLW_current_us_reg[63]_i_56_CO_UNCONNECTED [3:1],\current_us_reg[63]_i_56_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(\NLW_current_us_reg[63]_i_56_O_UNCONNECTED [3:0]),
        .S({1'b0,1'b0,1'b0,1'b1}));
  CARRY4 \current_us_reg[63]_i_57 
       (.CI(\current_us_reg[63]_i_58_n_0 ),
        .CO({\current_us_reg[63]_i_57_n_0 ,\current_us_reg[63]_i_57_n_1 ,\current_us_reg[63]_i_57_n_2 ,\current_us_reg[63]_i_57_n_3 }),
        .CYINIT(1'b0),
        .DI(\pending_reg[3] [7:4]),
        .O({\current_us_reg[63]_i_57_n_4 ,\current_us_reg[63]_i_57_n_5 ,\current_us_reg[63]_i_57_n_6 ,\current_us_reg[63]_i_57_n_7 }),
        .S({\current_us[63]_i_70_n_0 ,\current_us[63]_i_71_n_0 ,\current_us[63]_i_72_n_0 ,\current_us[63]_i_73_n_0 }));
  CARRY4 \current_us_reg[63]_i_58 
       (.CI(1'b0),
        .CO({\current_us_reg[63]_i_58_n_0 ,\current_us_reg[63]_i_58_n_1 ,\current_us_reg[63]_i_58_n_2 ,\current_us_reg[63]_i_58_n_3 }),
        .CYINIT(1'b1),
        .DI(\pending_reg[3] [3:0]),
        .O({\current_us_reg[63]_i_58_n_4 ,\current_us_reg[63]_i_58_n_5 ,\current_us_reg[63]_i_58_n_6 ,\current_us_reg[63]_i_58_n_7 }),
        .S({\current_us[63]_i_74_n_0 ,\current_us[63]_i_75_n_0 ,\current_us[63]_i_76_n_0 ,\current_us[63]_i_77_n_0 }));
  CARRY4 \current_us_reg[63]_i_59 
       (.CI(\current_us_reg[63]_i_61_n_0 ),
        .CO({\current_us_reg[63]_i_59_n_0 ,\current_us_reg[63]_i_59_n_1 ,\current_us_reg[63]_i_59_n_2 ,\current_us_reg[63]_i_59_n_3 }),
        .CYINIT(1'b0),
        .DI(current_us[59:56]),
        .O({\current_us_reg[63]_i_59_n_4 ,\current_us_reg[63]_i_59_n_5 ,\current_us_reg[63]_i_59_n_6 ,\current_us_reg[63]_i_59_n_7 }),
        .S({\current_us[63]_i_78_n_0 ,\current_us[63]_i_79_n_0 ,\current_us[63]_i_80_n_0 ,\current_us[63]_i_81_n_0 }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[63]_i_6 
       (.CI(\current_us_reg[60]_i_2_n_0 ),
        .CO({\NLW_current_us_reg[63]_i_6_CO_UNCONNECTED [3:2],\current_us_reg[63]_i_6_n_2 ,\current_us_reg[63]_i_6_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\NLW_current_us_reg[63]_i_6_O_UNCONNECTED [3],position116_in[15:13]}),
        .S({1'b0,current_us[63:61]}));
  CARRY4 \current_us_reg[63]_i_60 
       (.CI(\current_us_reg[48]_i_3_n_0 ),
        .CO({\NLW_current_us_reg[63]_i_60_CO_UNCONNECTED [3:1],\current_us_reg[63]_i_60_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(\NLW_current_us_reg[63]_i_60_O_UNCONNECTED [3:0]),
        .S({1'b0,1'b0,1'b0,1'b1}));
  CARRY4 \current_us_reg[63]_i_61 
       (.CI(\current_us_reg[63]_i_62_n_0 ),
        .CO({\current_us_reg[63]_i_61_n_0 ,\current_us_reg[63]_i_61_n_1 ,\current_us_reg[63]_i_61_n_2 ,\current_us_reg[63]_i_61_n_3 }),
        .CYINIT(1'b0),
        .DI(current_us[55:52]),
        .O({\current_us_reg[63]_i_61_n_4 ,\current_us_reg[63]_i_61_n_5 ,\current_us_reg[63]_i_61_n_6 ,\current_us_reg[63]_i_61_n_7 }),
        .S({\current_us[63]_i_82_n_0 ,\current_us[63]_i_83_n_0 ,\current_us[63]_i_84_n_0 ,\current_us[63]_i_85_n_0 }));
  CARRY4 \current_us_reg[63]_i_62 
       (.CI(1'b0),
        .CO({\current_us_reg[63]_i_62_n_0 ,\current_us_reg[63]_i_62_n_1 ,\current_us_reg[63]_i_62_n_2 ,\current_us_reg[63]_i_62_n_3 }),
        .CYINIT(1'b1),
        .DI(current_us[51:48]),
        .O({\current_us_reg[63]_i_62_n_4 ,\current_us_reg[63]_i_62_n_5 ,\current_us_reg[63]_i_62_n_6 ,\current_us_reg[63]_i_62_n_7 }),
        .S({\current_us[63]_i_86_n_0 ,\current_us[63]_i_87_n_0 ,\current_us[63]_i_88_n_0 ,\current_us[63]_i_89_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \current_us_reg[63]_i_8 
       (.CI(1'b0),
        .CO({\current_us_reg[63]_i_8_n_0 ,\current_us_reg[63]_i_8_n_1 ,\current_us_reg[63]_i_8_n_2 ,\current_us_reg[63]_i_8_n_3 }),
        .CYINIT(1'b0),
        .DI({\current_us[63]_i_35_n_0 ,\current_us[63]_i_36_n_0 ,\current_us[63]_i_37_n_0 ,\current_us[63]_i_38_n_0 }),
        .O(\NLW_current_us_reg[63]_i_8_O_UNCONNECTED [3:0]),
        .S({\current_us[63]_i_39_n_0 ,\current_us[63]_i_40_n_0 ,\current_us[63]_i_41_n_0 ,\current_us[63]_i_42_n_0 }));
  FDRE \current_us_reg[64] 
       (.C(clk),
        .CE(\current_us[79]_i_1_n_0 ),
        .D(p_34_out[64]),
        .Q(current_us[64]),
        .R(p_0_in));
  CARRY4 \current_us_reg[64]_i_3 
       (.CI(\current_us_reg[79]_i_59_n_0 ),
        .CO({\current_us_reg[64]_i_3_n_0 ,\current_us_reg[64]_i_3_n_1 ,\current_us_reg[64]_i_3_n_2 ,\current_us_reg[64]_i_3_n_3 }),
        .CYINIT(1'b0),
        .DI(current_us[79:76]),
        .O({\current_us_reg[64]_i_3_n_4 ,\current_us_reg[64]_i_3_n_5 ,\current_us_reg[64]_i_3_n_6 ,\current_us_reg[64]_i_3_n_7 }),
        .S({\current_us[64]_i_4_n_0 ,\current_us[64]_i_5_n_0 ,\current_us[64]_i_6_n_0 ,\current_us[64]_i_7_n_0 }));
  FDRE \current_us_reg[65] 
       (.C(clk),
        .CE(\current_us[79]_i_1_n_0 ),
        .D(p_34_out[65]),
        .Q(current_us[65]),
        .R(p_0_in));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[65]_i_2 
       (.CI(1'b0),
        .CO({\current_us_reg[65]_i_2_n_0 ,\current_us_reg[65]_i_2_n_1 ,\current_us_reg[65]_i_2_n_2 ,\current_us_reg[65]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,current_us[67:66],1'b0}),
        .O({position119_in[4:2],position121_in[1]}),
        .S({current_us[68],\current_us[65]_i_4_n_0 ,\current_us[65]_i_5_n_0 ,current_us[65]}));
  FDRE \current_us_reg[66] 
       (.C(clk),
        .CE(\current_us[79]_i_1_n_0 ),
        .D(p_34_out[66]),
        .Q(current_us[66]),
        .R(p_0_in));
  FDRE \current_us_reg[67] 
       (.C(clk),
        .CE(\current_us[79]_i_1_n_0 ),
        .D(p_34_out[67]),
        .Q(current_us[67]),
        .R(p_0_in));
  FDRE \current_us_reg[68] 
       (.C(clk),
        .CE(\current_us[79]_i_1_n_0 ),
        .D(p_34_out[68]),
        .Q(current_us[68]),
        .R(p_0_in));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[68]_i_2 
       (.CI(1'b0),
        .CO({\current_us_reg[68]_i_2_n_0 ,\current_us_reg[68]_i_2_n_1 ,\current_us_reg[68]_i_2_n_2 ,\current_us_reg[68]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({current_us[68],1'b0,current_us[66],1'b0}),
        .O({position121_in[4:2],\NLW_current_us_reg[68]_i_2_O_UNCONNECTED [0]}),
        .S({\current_us[68]_i_4_n_0 ,current_us[67],\current_us[68]_i_5_n_0 ,current_us[65]}));
  FDRE \current_us_reg[69] 
       (.C(clk),
        .CE(\current_us[79]_i_1_n_0 ),
        .D(p_34_out[69]),
        .Q(current_us[69]),
        .R(p_0_in));
  FDRE \current_us_reg[6] 
       (.C(clk),
        .CE(\current_us[15]_i_1_n_0 ),
        .D(p_34_out[6]),
        .Q(current_us[6]),
        .R(p_0_in));
  FDRE \current_us_reg[70] 
       (.C(clk),
        .CE(\current_us[79]_i_1_n_0 ),
        .D(p_34_out[70]),
        .Q(current_us[70]),
        .R(p_0_in));
  FDRE \current_us_reg[71] 
       (.C(clk),
        .CE(\current_us[79]_i_1_n_0 ),
        .D(p_34_out[71]),
        .Q(current_us[71]),
        .R(p_0_in));
  FDRE \current_us_reg[72] 
       (.C(clk),
        .CE(\current_us[79]_i_1_n_0 ),
        .D(p_34_out[72]),
        .Q(current_us[72]),
        .R(p_0_in));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[72]_i_2 
       (.CI(\current_us_reg[68]_i_2_n_0 ),
        .CO({\current_us_reg[72]_i_2_n_0 ,\current_us_reg[72]_i_2_n_1 ,\current_us_reg[72]_i_2_n_2 ,\current_us_reg[72]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(position121_in[8:5]),
        .S(current_us[72:69]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[72]_i_4 
       (.CI(\current_us_reg[65]_i_2_n_0 ),
        .CO({\current_us_reg[72]_i_4_n_0 ,\current_us_reg[72]_i_4_n_1 ,\current_us_reg[72]_i_4_n_2 ,\current_us_reg[72]_i_4_n_3 }),
        .CYINIT(1'b0),
        .DI(current_us[72:69]),
        .O(position119_in[8:5]),
        .S({\current_us[72]_i_5_n_0 ,\current_us[72]_i_6_n_0 ,\current_us[72]_i_7_n_0 ,\current_us[72]_i_8_n_0 }));
  FDRE \current_us_reg[73] 
       (.C(clk),
        .CE(\current_us[79]_i_1_n_0 ),
        .D(p_34_out[73]),
        .Q(current_us[73]),
        .R(p_0_in));
  FDRE \current_us_reg[74] 
       (.C(clk),
        .CE(\current_us[79]_i_1_n_0 ),
        .D(p_34_out[74]),
        .Q(current_us[74]),
        .R(p_0_in));
  FDRE \current_us_reg[75] 
       (.C(clk),
        .CE(\current_us[79]_i_1_n_0 ),
        .D(p_34_out[75]),
        .Q(current_us[75]),
        .R(p_0_in));
  FDRE \current_us_reg[76] 
       (.C(clk),
        .CE(\current_us[79]_i_1_n_0 ),
        .D(p_34_out[76]),
        .Q(current_us[76]),
        .R(p_0_in));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[76]_i_2 
       (.CI(\current_us_reg[72]_i_2_n_0 ),
        .CO({\current_us_reg[76]_i_2_n_0 ,\current_us_reg[76]_i_2_n_1 ,\current_us_reg[76]_i_2_n_2 ,\current_us_reg[76]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(position121_in[12:9]),
        .S(current_us[76:73]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[76]_i_4 
       (.CI(\current_us_reg[72]_i_4_n_0 ),
        .CO({\current_us_reg[76]_i_4_n_0 ,\current_us_reg[76]_i_4_n_1 ,\current_us_reg[76]_i_4_n_2 ,\current_us_reg[76]_i_4_n_3 }),
        .CYINIT(1'b0),
        .DI(current_us[76:73]),
        .O(position119_in[12:9]),
        .S({\current_us[76]_i_5_n_0 ,\current_us[76]_i_6_n_0 ,\current_us[76]_i_7_n_0 ,\current_us[76]_i_8_n_0 }));
  FDRE \current_us_reg[77] 
       (.C(clk),
        .CE(\current_us[79]_i_1_n_0 ),
        .D(p_34_out[77]),
        .Q(current_us[77]),
        .R(p_0_in));
  FDRE \current_us_reg[78] 
       (.C(clk),
        .CE(\current_us[79]_i_1_n_0 ),
        .D(p_34_out[78]),
        .Q(current_us[78]),
        .R(p_0_in));
  FDRE \current_us_reg[79] 
       (.C(clk),
        .CE(\current_us[79]_i_1_n_0 ),
        .D(p_34_out[79]),
        .Q(current_us[79]),
        .R(p_0_in));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \current_us_reg[79]_i_17 
       (.CI(1'b0),
        .CO({\current_us_reg[79]_i_17_n_0 ,\current_us_reg[79]_i_17_n_1 ,\current_us_reg[79]_i_17_n_2 ,\current_us_reg[79]_i_17_n_3 }),
        .CYINIT(1'b0),
        .DI({\current_us[79]_i_43_n_0 ,\current_us[79]_i_44_n_0 ,\current_us[79]_i_45_n_0 ,\current_us[79]_i_46_n_0 }),
        .O(\NLW_current_us_reg[79]_i_17_O_UNCONNECTED [3:0]),
        .S({\current_us[79]_i_47_n_0 ,\current_us[79]_i_48_n_0 ,\current_us[79]_i_49_n_0 ,\current_us[79]_i_50_n_0 }));
  CARRY4 \current_us_reg[79]_i_27 
       (.CI(\current_us_reg[79]_i_51_n_0 ),
        .CO({\current_us_reg[79]_i_27_n_0 ,\current_us_reg[79]_i_27_n_1 ,\current_us_reg[79]_i_27_n_2 ,\current_us_reg[79]_i_27_n_3 }),
        .CYINIT(1'b0),
        .DI(\pending_reg[4] [15:12]),
        .O({\current_us_reg[79]_i_27_n_4 ,\current_us_reg[79]_i_27_n_5 ,\current_us_reg[79]_i_27_n_6 ,\current_us_reg[79]_i_27_n_7 }),
        .S({\current_us[79]_i_52_n_0 ,\current_us[79]_i_53_n_0 ,\current_us[79]_i_54_n_0 ,\current_us[79]_i_55_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \current_us_reg[79]_i_3 
       (.CI(\current_us_reg[79]_i_8_n_0 ),
        .CO({position122_in,\current_us_reg[79]_i_3_n_1 ,\current_us_reg[79]_i_3_n_2 ,\current_us_reg[79]_i_3_n_3 }),
        .CYINIT(1'b0),
        .DI({\current_us[79]_i_9_n_0 ,\current_us[79]_i_10_n_0 ,\current_us[79]_i_11_n_0 ,\current_us[79]_i_12_n_0 }),
        .O(\NLW_current_us_reg[79]_i_3_O_UNCONNECTED [3:0]),
        .S({\current_us[79]_i_13_n_0 ,\current_us[79]_i_14_n_0 ,\current_us[79]_i_15_n_0 ,\current_us[79]_i_16_n_0 }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[79]_i_34 
       (.CI(\current_us_reg[76]_i_4_n_0 ),
        .CO({\NLW_current_us_reg[79]_i_34_CO_UNCONNECTED [3:2],\current_us_reg[79]_i_34_n_2 ,\current_us_reg[79]_i_34_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,current_us[78:77]}),
        .O({\NLW_current_us_reg[79]_i_34_O_UNCONNECTED [3],position119_in[15:13]}),
        .S({1'b0,\current_us[79]_i_63_n_0 ,\current_us[79]_i_64_n_0 ,\current_us[79]_i_65_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \current_us_reg[79]_i_4 
       (.CI(\current_us_reg[79]_i_17_n_0 ),
        .CO({p_9_in,\current_us_reg[79]_i_4_n_1 ,\current_us_reg[79]_i_4_n_2 ,\current_us_reg[79]_i_4_n_3 }),
        .CYINIT(1'b0),
        .DI({\current_us[79]_i_18_n_0 ,\current_us[79]_i_19_n_0 ,\current_us[79]_i_20_n_0 ,\current_us[79]_i_21_n_0 }),
        .O(\NLW_current_us_reg[79]_i_4_O_UNCONNECTED [3:0]),
        .S({\current_us[79]_i_22_n_0 ,\current_us[79]_i_23_n_0 ,\current_us[79]_i_24_n_0 ,\current_us[79]_i_25_n_0 }));
  CARRY4 \current_us_reg[79]_i_51 
       (.CI(\current_us_reg[79]_i_57_n_0 ),
        .CO({\current_us_reg[79]_i_51_n_0 ,\current_us_reg[79]_i_51_n_1 ,\current_us_reg[79]_i_51_n_2 ,\current_us_reg[79]_i_51_n_3 }),
        .CYINIT(1'b0),
        .DI(\pending_reg[4] [11:8]),
        .O({\current_us_reg[79]_i_51_n_4 ,\current_us_reg[79]_i_51_n_5 ,\current_us_reg[79]_i_51_n_6 ,\current_us_reg[79]_i_51_n_7 }),
        .S({\current_us[79]_i_66_n_0 ,\current_us[79]_i_67_n_0 ,\current_us[79]_i_68_n_0 ,\current_us[79]_i_69_n_0 }));
  CARRY4 \current_us_reg[79]_i_56 
       (.CI(\current_us_reg[79]_i_27_n_0 ),
        .CO({\NLW_current_us_reg[79]_i_56_CO_UNCONNECTED [3:1],\current_us_reg[79]_i_56_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(\NLW_current_us_reg[79]_i_56_O_UNCONNECTED [3:0]),
        .S({1'b0,1'b0,1'b0,1'b1}));
  CARRY4 \current_us_reg[79]_i_57 
       (.CI(\current_us_reg[79]_i_58_n_0 ),
        .CO({\current_us_reg[79]_i_57_n_0 ,\current_us_reg[79]_i_57_n_1 ,\current_us_reg[79]_i_57_n_2 ,\current_us_reg[79]_i_57_n_3 }),
        .CYINIT(1'b0),
        .DI(\pending_reg[4] [7:4]),
        .O({\current_us_reg[79]_i_57_n_4 ,\current_us_reg[79]_i_57_n_5 ,\current_us_reg[79]_i_57_n_6 ,\current_us_reg[79]_i_57_n_7 }),
        .S({\current_us[79]_i_70_n_0 ,\current_us[79]_i_71_n_0 ,\current_us[79]_i_72_n_0 ,\current_us[79]_i_73_n_0 }));
  CARRY4 \current_us_reg[79]_i_58 
       (.CI(1'b0),
        .CO({\current_us_reg[79]_i_58_n_0 ,\current_us_reg[79]_i_58_n_1 ,\current_us_reg[79]_i_58_n_2 ,\current_us_reg[79]_i_58_n_3 }),
        .CYINIT(1'b1),
        .DI(\pending_reg[4] [3:0]),
        .O({\current_us_reg[79]_i_58_n_4 ,\current_us_reg[79]_i_58_n_5 ,\current_us_reg[79]_i_58_n_6 ,\current_us_reg[79]_i_58_n_7 }),
        .S({\current_us[79]_i_74_n_0 ,\current_us[79]_i_75_n_0 ,\current_us[79]_i_76_n_0 ,\current_us[79]_i_77_n_0 }));
  CARRY4 \current_us_reg[79]_i_59 
       (.CI(\current_us_reg[79]_i_61_n_0 ),
        .CO({\current_us_reg[79]_i_59_n_0 ,\current_us_reg[79]_i_59_n_1 ,\current_us_reg[79]_i_59_n_2 ,\current_us_reg[79]_i_59_n_3 }),
        .CYINIT(1'b0),
        .DI(current_us[75:72]),
        .O({\current_us_reg[79]_i_59_n_4 ,\current_us_reg[79]_i_59_n_5 ,\current_us_reg[79]_i_59_n_6 ,\current_us_reg[79]_i_59_n_7 }),
        .S({\current_us[79]_i_78_n_0 ,\current_us[79]_i_79_n_0 ,\current_us[79]_i_80_n_0 ,\current_us[79]_i_81_n_0 }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[79]_i_6 
       (.CI(\current_us_reg[76]_i_2_n_0 ),
        .CO({\NLW_current_us_reg[79]_i_6_CO_UNCONNECTED [3:2],\current_us_reg[79]_i_6_n_2 ,\current_us_reg[79]_i_6_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\NLW_current_us_reg[79]_i_6_O_UNCONNECTED [3],position121_in[15:13]}),
        .S({1'b0,current_us[79:77]}));
  CARRY4 \current_us_reg[79]_i_60 
       (.CI(\current_us_reg[64]_i_3_n_0 ),
        .CO({\NLW_current_us_reg[79]_i_60_CO_UNCONNECTED [3:1],\current_us_reg[79]_i_60_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(\NLW_current_us_reg[79]_i_60_O_UNCONNECTED [3:0]),
        .S({1'b0,1'b0,1'b0,1'b1}));
  CARRY4 \current_us_reg[79]_i_61 
       (.CI(\current_us_reg[79]_i_62_n_0 ),
        .CO({\current_us_reg[79]_i_61_n_0 ,\current_us_reg[79]_i_61_n_1 ,\current_us_reg[79]_i_61_n_2 ,\current_us_reg[79]_i_61_n_3 }),
        .CYINIT(1'b0),
        .DI(current_us[71:68]),
        .O({\current_us_reg[79]_i_61_n_4 ,\current_us_reg[79]_i_61_n_5 ,\current_us_reg[79]_i_61_n_6 ,\current_us_reg[79]_i_61_n_7 }),
        .S({\current_us[79]_i_82_n_0 ,\current_us[79]_i_83_n_0 ,\current_us[79]_i_84_n_0 ,\current_us[79]_i_85_n_0 }));
  CARRY4 \current_us_reg[79]_i_62 
       (.CI(1'b0),
        .CO({\current_us_reg[79]_i_62_n_0 ,\current_us_reg[79]_i_62_n_1 ,\current_us_reg[79]_i_62_n_2 ,\current_us_reg[79]_i_62_n_3 }),
        .CYINIT(1'b1),
        .DI(current_us[67:64]),
        .O({\current_us_reg[79]_i_62_n_4 ,\current_us_reg[79]_i_62_n_5 ,\current_us_reg[79]_i_62_n_6 ,\current_us_reg[79]_i_62_n_7 }),
        .S({\current_us[79]_i_86_n_0 ,\current_us[79]_i_87_n_0 ,\current_us[79]_i_88_n_0 ,\current_us[79]_i_89_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \current_us_reg[79]_i_8 
       (.CI(1'b0),
        .CO({\current_us_reg[79]_i_8_n_0 ,\current_us_reg[79]_i_8_n_1 ,\current_us_reg[79]_i_8_n_2 ,\current_us_reg[79]_i_8_n_3 }),
        .CYINIT(1'b0),
        .DI({\current_us[79]_i_35_n_0 ,\current_us[79]_i_36_n_0 ,\current_us[79]_i_37_n_0 ,\current_us[79]_i_38_n_0 }),
        .O(\NLW_current_us_reg[79]_i_8_O_UNCONNECTED [3:0]),
        .S({\current_us[79]_i_39_n_0 ,\current_us[79]_i_40_n_0 ,\current_us[79]_i_41_n_0 ,\current_us[79]_i_42_n_0 }));
  FDRE \current_us_reg[7] 
       (.C(clk),
        .CE(\current_us[15]_i_1_n_0 ),
        .D(p_34_out[7]),
        .Q(current_us[7]),
        .R(p_0_in));
  FDRE \current_us_reg[80] 
       (.C(clk),
        .CE(\current_us[95]_i_2_n_0 ),
        .D(p_34_out[80]),
        .Q(current_us[80]),
        .R(p_0_in));
  CARRY4 \current_us_reg[80]_i_3 
       (.CI(\current_us_reg[95]_i_61_n_0 ),
        .CO({\current_us_reg[80]_i_3_n_0 ,\current_us_reg[80]_i_3_n_1 ,\current_us_reg[80]_i_3_n_2 ,\current_us_reg[80]_i_3_n_3 }),
        .CYINIT(1'b0),
        .DI(current_us[95:92]),
        .O({\current_us_reg[80]_i_3_n_4 ,\current_us_reg[80]_i_3_n_5 ,\current_us_reg[80]_i_3_n_6 ,\current_us_reg[80]_i_3_n_7 }),
        .S({\current_us[80]_i_4_n_0 ,\current_us[80]_i_5_n_0 ,\current_us[80]_i_6_n_0 ,\current_us[80]_i_7_n_0 }));
  FDRE \current_us_reg[81] 
       (.C(clk),
        .CE(\current_us[95]_i_2_n_0 ),
        .D(p_34_out[81]),
        .Q(current_us[81]),
        .R(p_0_in));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[81]_i_2 
       (.CI(1'b0),
        .CO({\current_us_reg[81]_i_2_n_0 ,\current_us_reg[81]_i_2_n_1 ,\current_us_reg[81]_i_2_n_2 ,\current_us_reg[81]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,current_us[83:82],1'b0}),
        .O({position124_in[4:2],position126_in[1]}),
        .S({current_us[84],\current_us[81]_i_4_n_0 ,\current_us[81]_i_5_n_0 ,current_us[81]}));
  FDRE \current_us_reg[82] 
       (.C(clk),
        .CE(\current_us[95]_i_2_n_0 ),
        .D(p_34_out[82]),
        .Q(current_us[82]),
        .R(p_0_in));
  FDRE \current_us_reg[83] 
       (.C(clk),
        .CE(\current_us[95]_i_2_n_0 ),
        .D(p_34_out[83]),
        .Q(current_us[83]),
        .R(p_0_in));
  FDRE \current_us_reg[84] 
       (.C(clk),
        .CE(\current_us[95]_i_2_n_0 ),
        .D(p_34_out[84]),
        .Q(current_us[84]),
        .R(p_0_in));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[84]_i_2 
       (.CI(1'b0),
        .CO({\current_us_reg[84]_i_2_n_0 ,\current_us_reg[84]_i_2_n_1 ,\current_us_reg[84]_i_2_n_2 ,\current_us_reg[84]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({current_us[84],1'b0,current_us[82],1'b0}),
        .O({position126_in[4:2],\NLW_current_us_reg[84]_i_2_O_UNCONNECTED [0]}),
        .S({\current_us[84]_i_4_n_0 ,current_us[83],\current_us[84]_i_5_n_0 ,current_us[81]}));
  FDRE \current_us_reg[85] 
       (.C(clk),
        .CE(\current_us[95]_i_2_n_0 ),
        .D(p_34_out[85]),
        .Q(current_us[85]),
        .R(p_0_in));
  FDRE \current_us_reg[86] 
       (.C(clk),
        .CE(\current_us[95]_i_2_n_0 ),
        .D(p_34_out[86]),
        .Q(current_us[86]),
        .R(p_0_in));
  FDRE \current_us_reg[87] 
       (.C(clk),
        .CE(\current_us[95]_i_2_n_0 ),
        .D(p_34_out[87]),
        .Q(current_us[87]),
        .R(p_0_in));
  FDRE \current_us_reg[88] 
       (.C(clk),
        .CE(\current_us[95]_i_2_n_0 ),
        .D(p_34_out[88]),
        .Q(current_us[88]),
        .R(p_0_in));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[88]_i_2 
       (.CI(\current_us_reg[84]_i_2_n_0 ),
        .CO({\current_us_reg[88]_i_2_n_0 ,\current_us_reg[88]_i_2_n_1 ,\current_us_reg[88]_i_2_n_2 ,\current_us_reg[88]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(position126_in[8:5]),
        .S(current_us[88:85]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[88]_i_4 
       (.CI(\current_us_reg[81]_i_2_n_0 ),
        .CO({\current_us_reg[88]_i_4_n_0 ,\current_us_reg[88]_i_4_n_1 ,\current_us_reg[88]_i_4_n_2 ,\current_us_reg[88]_i_4_n_3 }),
        .CYINIT(1'b0),
        .DI(current_us[88:85]),
        .O(position124_in[8:5]),
        .S({\current_us[88]_i_5_n_0 ,\current_us[88]_i_6_n_0 ,\current_us[88]_i_7_n_0 ,\current_us[88]_i_8_n_0 }));
  FDRE \current_us_reg[89] 
       (.C(clk),
        .CE(\current_us[95]_i_2_n_0 ),
        .D(p_34_out[89]),
        .Q(current_us[89]),
        .R(p_0_in));
  FDRE \current_us_reg[8] 
       (.C(clk),
        .CE(\current_us[15]_i_1_n_0 ),
        .D(p_34_out[8]),
        .Q(current_us[8]),
        .R(p_0_in));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[8]_i_2 
       (.CI(\current_us_reg[4]_i_2_n_0 ),
        .CO({\current_us_reg[8]_i_2_n_0 ,\current_us_reg[8]_i_2_n_1 ,\current_us_reg[8]_i_2_n_2 ,\current_us_reg[8]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(position11_in[8:5]),
        .S(current_us[8:5]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[8]_i_4 
       (.CI(\current_us_reg[1]_i_2_n_0 ),
        .CO({\current_us_reg[8]_i_4_n_0 ,\current_us_reg[8]_i_4_n_1 ,\current_us_reg[8]_i_4_n_2 ,\current_us_reg[8]_i_4_n_3 }),
        .CYINIT(1'b0),
        .DI(current_us[8:5]),
        .O(position1[8:5]),
        .S({\current_us[8]_i_5_n_0 ,\current_us[8]_i_6_n_0 ,\current_us[8]_i_7_n_0 ,\current_us[8]_i_8_n_0 }));
  FDRE \current_us_reg[90] 
       (.C(clk),
        .CE(\current_us[95]_i_2_n_0 ),
        .D(p_34_out[90]),
        .Q(current_us[90]),
        .R(p_0_in));
  FDRE \current_us_reg[91] 
       (.C(clk),
        .CE(\current_us[95]_i_2_n_0 ),
        .D(p_34_out[91]),
        .Q(current_us[91]),
        .R(p_0_in));
  FDRE \current_us_reg[92] 
       (.C(clk),
        .CE(\current_us[95]_i_2_n_0 ),
        .D(p_34_out[92]),
        .Q(current_us[92]),
        .R(p_0_in));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[92]_i_2 
       (.CI(\current_us_reg[88]_i_2_n_0 ),
        .CO({\current_us_reg[92]_i_2_n_0 ,\current_us_reg[92]_i_2_n_1 ,\current_us_reg[92]_i_2_n_2 ,\current_us_reg[92]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(position126_in[12:9]),
        .S(current_us[92:89]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[92]_i_4 
       (.CI(\current_us_reg[88]_i_4_n_0 ),
        .CO({\current_us_reg[92]_i_4_n_0 ,\current_us_reg[92]_i_4_n_1 ,\current_us_reg[92]_i_4_n_2 ,\current_us_reg[92]_i_4_n_3 }),
        .CYINIT(1'b0),
        .DI(current_us[92:89]),
        .O(position124_in[12:9]),
        .S({\current_us[92]_i_5_n_0 ,\current_us[92]_i_6_n_0 ,\current_us[92]_i_7_n_0 ,\current_us[92]_i_8_n_0 }));
  FDRE \current_us_reg[93] 
       (.C(clk),
        .CE(\current_us[95]_i_2_n_0 ),
        .D(p_34_out[93]),
        .Q(current_us[93]),
        .R(p_0_in));
  FDRE \current_us_reg[94] 
       (.C(clk),
        .CE(\current_us[95]_i_2_n_0 ),
        .D(p_34_out[94]),
        .Q(current_us[94]),
        .R(p_0_in));
  FDRE \current_us_reg[95] 
       (.C(clk),
        .CE(\current_us[95]_i_2_n_0 ),
        .D(p_34_out[95]),
        .Q(current_us[95]),
        .R(p_0_in));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \current_us_reg[95]_i_10 
       (.CI(1'b0),
        .CO({\current_us_reg[95]_i_10_n_0 ,\current_us_reg[95]_i_10_n_1 ,\current_us_reg[95]_i_10_n_2 ,\current_us_reg[95]_i_10_n_3 }),
        .CYINIT(1'b0),
        .DI({\current_us[95]_i_37_n_0 ,\current_us[95]_i_38_n_0 ,\current_us[95]_i_39_n_0 ,\current_us[95]_i_40_n_0 }),
        .O(\NLW_current_us_reg[95]_i_10_O_UNCONNECTED [3:0]),
        .S({\current_us[95]_i_41_n_0 ,\current_us[95]_i_42_n_0 ,\current_us[95]_i_43_n_0 ,\current_us[95]_i_44_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \current_us_reg[95]_i_19 
       (.CI(1'b0),
        .CO({\current_us_reg[95]_i_19_n_0 ,\current_us_reg[95]_i_19_n_1 ,\current_us_reg[95]_i_19_n_2 ,\current_us_reg[95]_i_19_n_3 }),
        .CYINIT(1'b0),
        .DI({\current_us[95]_i_45_n_0 ,\current_us[95]_i_46_n_0 ,\current_us[95]_i_47_n_0 ,\current_us[95]_i_48_n_0 }),
        .O(\NLW_current_us_reg[95]_i_19_O_UNCONNECTED [3:0]),
        .S({\current_us[95]_i_49_n_0 ,\current_us[95]_i_50_n_0 ,\current_us[95]_i_51_n_0 ,\current_us[95]_i_52_n_0 }));
  CARRY4 \current_us_reg[95]_i_29 
       (.CI(\current_us_reg[95]_i_53_n_0 ),
        .CO({\current_us_reg[95]_i_29_n_0 ,\current_us_reg[95]_i_29_n_1 ,\current_us_reg[95]_i_29_n_2 ,\current_us_reg[95]_i_29_n_3 }),
        .CYINIT(1'b0),
        .DI(\pending_reg[5] [15:12]),
        .O(position3[15:12]),
        .S({\current_us[95]_i_54_n_0 ,\current_us[95]_i_55_n_0 ,\current_us[95]_i_56_n_0 ,\current_us[95]_i_57_n_0 }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[95]_i_36 
       (.CI(\current_us_reg[92]_i_4_n_0 ),
        .CO({\NLW_current_us_reg[95]_i_36_CO_UNCONNECTED [3:2],\current_us_reg[95]_i_36_n_2 ,\current_us_reg[95]_i_36_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,current_us[94:93]}),
        .O({\NLW_current_us_reg[95]_i_36_O_UNCONNECTED [3],position124_in[15:13]}),
        .S({1'b0,\current_us[95]_i_65_n_0 ,\current_us[95]_i_66_n_0 ,\current_us[95]_i_67_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \current_us_reg[95]_i_5 
       (.CI(\current_us_reg[95]_i_10_n_0 ),
        .CO({position127_in,\current_us_reg[95]_i_5_n_1 ,\current_us_reg[95]_i_5_n_2 ,\current_us_reg[95]_i_5_n_3 }),
        .CYINIT(1'b0),
        .DI({\current_us[95]_i_11_n_0 ,\current_us[95]_i_12_n_0 ,\current_us[95]_i_13_n_0 ,\current_us[95]_i_14_n_0 }),
        .O(\NLW_current_us_reg[95]_i_5_O_UNCONNECTED [3:0]),
        .S({\current_us[95]_i_15_n_0 ,\current_us[95]_i_16_n_0 ,\current_us[95]_i_17_n_0 ,\current_us[95]_i_18_n_0 }));
  CARRY4 \current_us_reg[95]_i_53 
       (.CI(\current_us_reg[95]_i_59_n_0 ),
        .CO({\current_us_reg[95]_i_53_n_0 ,\current_us_reg[95]_i_53_n_1 ,\current_us_reg[95]_i_53_n_2 ,\current_us_reg[95]_i_53_n_3 }),
        .CYINIT(1'b0),
        .DI(\pending_reg[5] [11:8]),
        .O(position3[11:8]),
        .S({\current_us[95]_i_68_n_0 ,\current_us[95]_i_69_n_0 ,\current_us[95]_i_70_n_0 ,\current_us[95]_i_71_n_0 }));
  CARRY4 \current_us_reg[95]_i_58 
       (.CI(\current_us_reg[95]_i_29_n_0 ),
        .CO({\NLW_current_us_reg[95]_i_58_CO_UNCONNECTED [3:1],\current_us_reg[95]_i_58_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(\NLW_current_us_reg[95]_i_58_O_UNCONNECTED [3:0]),
        .S({1'b0,1'b0,1'b0,1'b1}));
  CARRY4 \current_us_reg[95]_i_59 
       (.CI(\current_us_reg[95]_i_60_n_0 ),
        .CO({\current_us_reg[95]_i_59_n_0 ,\current_us_reg[95]_i_59_n_1 ,\current_us_reg[95]_i_59_n_2 ,\current_us_reg[95]_i_59_n_3 }),
        .CYINIT(1'b0),
        .DI(\pending_reg[5] [7:4]),
        .O(position3[7:4]),
        .S({\current_us[95]_i_72_n_0 ,\current_us[95]_i_73_n_0 ,\current_us[95]_i_74_n_0 ,\current_us[95]_i_75_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \current_us_reg[95]_i_6 
       (.CI(\current_us_reg[95]_i_19_n_0 ),
        .CO({p_11_in,\current_us_reg[95]_i_6_n_1 ,\current_us_reg[95]_i_6_n_2 ,\current_us_reg[95]_i_6_n_3 }),
        .CYINIT(1'b0),
        .DI({\current_us[95]_i_20_n_0 ,\current_us[95]_i_21_n_0 ,\current_us[95]_i_22_n_0 ,\current_us[95]_i_23_n_0 }),
        .O(\NLW_current_us_reg[95]_i_6_O_UNCONNECTED [3:0]),
        .S({\current_us[95]_i_24_n_0 ,\current_us[95]_i_25_n_0 ,\current_us[95]_i_26_n_0 ,\current_us[95]_i_27_n_0 }));
  CARRY4 \current_us_reg[95]_i_60 
       (.CI(1'b0),
        .CO({\current_us_reg[95]_i_60_n_0 ,\current_us_reg[95]_i_60_n_1 ,\current_us_reg[95]_i_60_n_2 ,\current_us_reg[95]_i_60_n_3 }),
        .CYINIT(1'b1),
        .DI(\pending_reg[5] [3:0]),
        .O(position3[3:0]),
        .S({\current_us[95]_i_76_n_0 ,\current_us[95]_i_77_n_0 ,\current_us[95]_i_78_n_0 ,\current_us[95]_i_79_n_0 }));
  CARRY4 \current_us_reg[95]_i_61 
       (.CI(\current_us_reg[95]_i_63_n_0 ),
        .CO({\current_us_reg[95]_i_61_n_0 ,\current_us_reg[95]_i_61_n_1 ,\current_us_reg[95]_i_61_n_2 ,\current_us_reg[95]_i_61_n_3 }),
        .CYINIT(1'b0),
        .DI(current_us[91:88]),
        .O({\current_us_reg[95]_i_61_n_4 ,\current_us_reg[95]_i_61_n_5 ,\current_us_reg[95]_i_61_n_6 ,\current_us_reg[95]_i_61_n_7 }),
        .S({\current_us[95]_i_80_n_0 ,\current_us[95]_i_81_n_0 ,\current_us[95]_i_82_n_0 ,\current_us[95]_i_83_n_0 }));
  CARRY4 \current_us_reg[95]_i_62 
       (.CI(\current_us_reg[80]_i_3_n_0 ),
        .CO({\NLW_current_us_reg[95]_i_62_CO_UNCONNECTED [3:1],\current_us_reg[95]_i_62_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(\NLW_current_us_reg[95]_i_62_O_UNCONNECTED [3:0]),
        .S({1'b0,1'b0,1'b0,1'b1}));
  CARRY4 \current_us_reg[95]_i_63 
       (.CI(\current_us_reg[95]_i_64_n_0 ),
        .CO({\current_us_reg[95]_i_63_n_0 ,\current_us_reg[95]_i_63_n_1 ,\current_us_reg[95]_i_63_n_2 ,\current_us_reg[95]_i_63_n_3 }),
        .CYINIT(1'b0),
        .DI(current_us[87:84]),
        .O({\current_us_reg[95]_i_63_n_4 ,\current_us_reg[95]_i_63_n_5 ,\current_us_reg[95]_i_63_n_6 ,\current_us_reg[95]_i_63_n_7 }),
        .S({\current_us[95]_i_84_n_0 ,\current_us[95]_i_85_n_0 ,\current_us[95]_i_86_n_0 ,\current_us[95]_i_87_n_0 }));
  CARRY4 \current_us_reg[95]_i_64 
       (.CI(1'b0),
        .CO({\current_us_reg[95]_i_64_n_0 ,\current_us_reg[95]_i_64_n_1 ,\current_us_reg[95]_i_64_n_2 ,\current_us_reg[95]_i_64_n_3 }),
        .CYINIT(1'b1),
        .DI(current_us[83:80]),
        .O({\current_us_reg[95]_i_64_n_4 ,\current_us_reg[95]_i_64_n_5 ,\current_us_reg[95]_i_64_n_6 ,\current_us_reg[95]_i_64_n_7 }),
        .S({\current_us[95]_i_88_n_0 ,\current_us[95]_i_89_n_0 ,\current_us[95]_i_90_n_0 ,\current_us[95]_i_91_n_0 }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \current_us_reg[95]_i_8 
       (.CI(\current_us_reg[92]_i_2_n_0 ),
        .CO({\NLW_current_us_reg[95]_i_8_CO_UNCONNECTED [3:2],\current_us_reg[95]_i_8_n_2 ,\current_us_reg[95]_i_8_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\NLW_current_us_reg[95]_i_8_O_UNCONNECTED [3],position126_in[15:13]}),
        .S({1'b0,current_us[95:93]}));
  FDRE \current_us_reg[9] 
       (.C(clk),
        .CE(\current_us[15]_i_1_n_0 ),
        .D(p_34_out[9]),
        .Q(current_us[9]),
        .R(p_0_in));
  LUT6 #(
    .INIT(64'hFFCDFF0000000000)) 
    fault_i_1
       (.I0(have_target2_out),
        .I1(fault),
        .I2(fault_i_3_n_0),
        .I3(estop),
        .I4(enable),
        .I5(rst_n),
        .O(fault_i_1_n_0));
  LUT5 #(
    .INIT(32'h00020000)) 
    fault_i_2
       (.I0(command_valid),
        .I1(fault_i_4_n_0),
        .I2(fault_i_5_n_0),
        .I3(\pwm[5]_i_6_n_0 ),
        .I4(\pwm[5]_i_9_n_0 ),
        .O(have_target2_out));
  LUT2 #(
    .INIT(4'h1)) 
    fault_i_3
       (.I0(command_valid),
        .I1(\sub_tick[4]_i_4_n_0 ),
        .O(fault_i_3_n_0));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT3 #(
    .INIT(8'hFE)) 
    fault_i_4
       (.I0(\pwm[5]_i_28_n_0 ),
        .I1(\pwm[5]_i_23_n_0 ),
        .I2(\pwm[5]_i_27_n_0 ),
        .O(fault_i_4_n_0));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    fault_i_5
       (.I0(\pwm[5]_i_26_n_0 ),
        .I1(\pwm[5]_i_29_n_0 ),
        .I2(\pwm[5]_i_25_n_0 ),
        .I3(\pwm[5]_i_24_n_0 ),
        .O(fault_i_5_n_0));
  FDRE fault_reg
       (.C(clk),
        .CE(1'b1),
        .D(fault_i_1_n_0),
        .Q(fault),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \frame_us[0]_i_1 
       (.I0(\frame_us_reg_n_0_[0] ),
        .O(frame_us[0]));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \frame_us[10]_i_1 
       (.I0(data0[10]),
        .I1(\frame_us[14]_i_4_n_0 ),
        .O(frame_us[10]));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \frame_us[11]_i_1 
       (.I0(data0[11]),
        .I1(\frame_us[14]_i_4_n_0 ),
        .O(frame_us[11]));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \frame_us[12]_i_1 
       (.I0(data0[12]),
        .I1(\frame_us[14]_i_4_n_0 ),
        .O(frame_us[12]));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \frame_us[13]_i_1 
       (.I0(data0[13]),
        .I1(\frame_us[14]_i_4_n_0 ),
        .O(frame_us[13]));
  LUT6 #(
    .INIT(64'h0000000000002000)) 
    \frame_us[14]_i_1 
       (.I0(\sub_tick[4]_i_2_n_0 ),
        .I1(\sub_tick_reg_n_0_[0] ),
        .I2(\sub_tick_reg_n_0_[4] ),
        .I3(\sub_tick_reg_n_0_[3] ),
        .I4(\sub_tick_reg_n_0_[1] ),
        .I5(\sub_tick_reg_n_0_[2] ),
        .O(\frame_us[14]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \frame_us[14]_i_2 
       (.I0(data0[14]),
        .I1(\frame_us[14]_i_4_n_0 ),
        .O(frame_us[14]));
  LUT6 #(
    .INIT(64'h0000000000400000)) 
    \frame_us[14]_i_4 
       (.I0(\frame_us[14]_i_5_n_0 ),
        .I1(\frame_us[14]_i_6_n_0 ),
        .I2(\frame_us_reg_n_0_[4] ),
        .I3(\frame_us_reg_n_0_[8] ),
        .I4(\frame_us_reg_n_0_[9] ),
        .I5(\frame_us[14]_i_7_n_0 ),
        .O(\frame_us[14]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'h7FFF)) 
    \frame_us[14]_i_5 
       (.I0(\frame_us_reg_n_0_[3] ),
        .I1(\frame_us_reg_n_0_[2] ),
        .I2(\frame_us_reg_n_0_[11] ),
        .I3(\frame_us_reg_n_0_[1] ),
        .O(\frame_us[14]_i_5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT4 #(
    .INIT(16'h4000)) 
    \frame_us[14]_i_6 
       (.I0(\frame_us_reg_n_0_[12] ),
        .I1(\frame_us_reg_n_0_[0] ),
        .I2(\frame_us_reg_n_0_[14] ),
        .I3(\frame_us_reg_n_0_[10] ),
        .O(\frame_us[14]_i_6_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \frame_us[14]_i_7 
       (.I0(\frame_us_reg_n_0_[7] ),
        .I1(\frame_us_reg_n_0_[6] ),
        .I2(\frame_us_reg_n_0_[13] ),
        .I3(\frame_us_reg_n_0_[5] ),
        .O(\frame_us[14]_i_7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \frame_us[1]_i_1 
       (.I0(data0[1]),
        .I1(\frame_us[14]_i_4_n_0 ),
        .O(frame_us[1]));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \frame_us[2]_i_1 
       (.I0(data0[2]),
        .I1(\frame_us[14]_i_4_n_0 ),
        .O(frame_us[2]));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \frame_us[3]_i_1 
       (.I0(data0[3]),
        .I1(\frame_us[14]_i_4_n_0 ),
        .O(frame_us[3]));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \frame_us[4]_i_1 
       (.I0(data0[4]),
        .I1(\frame_us[14]_i_4_n_0 ),
        .O(frame_us[4]));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \frame_us[5]_i_1 
       (.I0(data0[5]),
        .I1(\frame_us[14]_i_4_n_0 ),
        .O(frame_us[5]));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \frame_us[6]_i_1 
       (.I0(data0[6]),
        .I1(\frame_us[14]_i_4_n_0 ),
        .O(frame_us[6]));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \frame_us[7]_i_1 
       (.I0(data0[7]),
        .I1(\frame_us[14]_i_4_n_0 ),
        .O(frame_us[7]));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \frame_us[8]_i_1 
       (.I0(data0[8]),
        .I1(\frame_us[14]_i_4_n_0 ),
        .O(frame_us[8]));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \frame_us[9]_i_1 
       (.I0(data0[9]),
        .I1(\frame_us[14]_i_4_n_0 ),
        .O(frame_us[9]));
  FDRE \frame_us_reg[0] 
       (.C(clk),
        .CE(\frame_us[14]_i_1_n_0 ),
        .D(frame_us[0]),
        .Q(\frame_us_reg_n_0_[0] ),
        .R(\sub_tick[4]_i_1_n_0 ));
  FDRE \frame_us_reg[10] 
       (.C(clk),
        .CE(\frame_us[14]_i_1_n_0 ),
        .D(frame_us[10]),
        .Q(\frame_us_reg_n_0_[10] ),
        .R(\sub_tick[4]_i_1_n_0 ));
  FDRE \frame_us_reg[11] 
       (.C(clk),
        .CE(\frame_us[14]_i_1_n_0 ),
        .D(frame_us[11]),
        .Q(\frame_us_reg_n_0_[11] ),
        .R(\sub_tick[4]_i_1_n_0 ));
  FDRE \frame_us_reg[12] 
       (.C(clk),
        .CE(\frame_us[14]_i_1_n_0 ),
        .D(frame_us[12]),
        .Q(\frame_us_reg_n_0_[12] ),
        .R(\sub_tick[4]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \frame_us_reg[12]_i_2 
       (.CI(\frame_us_reg[8]_i_2_n_0 ),
        .CO({\frame_us_reg[12]_i_2_n_0 ,\frame_us_reg[12]_i_2_n_1 ,\frame_us_reg[12]_i_2_n_2 ,\frame_us_reg[12]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(data0[12:9]),
        .S({\frame_us_reg_n_0_[12] ,\frame_us_reg_n_0_[11] ,\frame_us_reg_n_0_[10] ,\frame_us_reg_n_0_[9] }));
  FDRE \frame_us_reg[13] 
       (.C(clk),
        .CE(\frame_us[14]_i_1_n_0 ),
        .D(frame_us[13]),
        .Q(\frame_us_reg_n_0_[13] ),
        .R(\sub_tick[4]_i_1_n_0 ));
  FDRE \frame_us_reg[14] 
       (.C(clk),
        .CE(\frame_us[14]_i_1_n_0 ),
        .D(frame_us[14]),
        .Q(\frame_us_reg_n_0_[14] ),
        .R(\sub_tick[4]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \frame_us_reg[14]_i_3 
       (.CI(\frame_us_reg[12]_i_2_n_0 ),
        .CO({\NLW_frame_us_reg[14]_i_3_CO_UNCONNECTED [3:1],\frame_us_reg[14]_i_3_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\NLW_frame_us_reg[14]_i_3_O_UNCONNECTED [3:2],data0[14:13]}),
        .S({1'b0,1'b0,\frame_us_reg_n_0_[14] ,\frame_us_reg_n_0_[13] }));
  FDRE \frame_us_reg[1] 
       (.C(clk),
        .CE(\frame_us[14]_i_1_n_0 ),
        .D(frame_us[1]),
        .Q(\frame_us_reg_n_0_[1] ),
        .R(\sub_tick[4]_i_1_n_0 ));
  FDRE \frame_us_reg[2] 
       (.C(clk),
        .CE(\frame_us[14]_i_1_n_0 ),
        .D(frame_us[2]),
        .Q(\frame_us_reg_n_0_[2] ),
        .R(\sub_tick[4]_i_1_n_0 ));
  FDRE \frame_us_reg[3] 
       (.C(clk),
        .CE(\frame_us[14]_i_1_n_0 ),
        .D(frame_us[3]),
        .Q(\frame_us_reg_n_0_[3] ),
        .R(\sub_tick[4]_i_1_n_0 ));
  FDRE \frame_us_reg[4] 
       (.C(clk),
        .CE(\frame_us[14]_i_1_n_0 ),
        .D(frame_us[4]),
        .Q(\frame_us_reg_n_0_[4] ),
        .R(\sub_tick[4]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \frame_us_reg[4]_i_2 
       (.CI(1'b0),
        .CO({\frame_us_reg[4]_i_2_n_0 ,\frame_us_reg[4]_i_2_n_1 ,\frame_us_reg[4]_i_2_n_2 ,\frame_us_reg[4]_i_2_n_3 }),
        .CYINIT(\frame_us_reg_n_0_[0] ),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(data0[4:1]),
        .S({\frame_us_reg_n_0_[4] ,\frame_us_reg_n_0_[3] ,\frame_us_reg_n_0_[2] ,\frame_us_reg_n_0_[1] }));
  FDRE \frame_us_reg[5] 
       (.C(clk),
        .CE(\frame_us[14]_i_1_n_0 ),
        .D(frame_us[5]),
        .Q(\frame_us_reg_n_0_[5] ),
        .R(\sub_tick[4]_i_1_n_0 ));
  FDRE \frame_us_reg[6] 
       (.C(clk),
        .CE(\frame_us[14]_i_1_n_0 ),
        .D(frame_us[6]),
        .Q(\frame_us_reg_n_0_[6] ),
        .R(\sub_tick[4]_i_1_n_0 ));
  FDRE \frame_us_reg[7] 
       (.C(clk),
        .CE(\frame_us[14]_i_1_n_0 ),
        .D(frame_us[7]),
        .Q(\frame_us_reg_n_0_[7] ),
        .R(\sub_tick[4]_i_1_n_0 ));
  FDRE \frame_us_reg[8] 
       (.C(clk),
        .CE(\frame_us[14]_i_1_n_0 ),
        .D(frame_us[8]),
        .Q(\frame_us_reg_n_0_[8] ),
        .R(\sub_tick[4]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \frame_us_reg[8]_i_2 
       (.CI(\frame_us_reg[4]_i_2_n_0 ),
        .CO({\frame_us_reg[8]_i_2_n_0 ,\frame_us_reg[8]_i_2_n_1 ,\frame_us_reg[8]_i_2_n_2 ,\frame_us_reg[8]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(data0[8:5]),
        .S({\frame_us_reg_n_0_[8] ,\frame_us_reg_n_0_[7] ,\frame_us_reg_n_0_[6] ,\frame_us_reg_n_0_[5] }));
  FDRE \frame_us_reg[9] 
       (.C(clk),
        .CE(\frame_us[14]_i_1_n_0 ),
        .D(frame_us[9]),
        .Q(\frame_us_reg_n_0_[9] ),
        .R(\sub_tick[4]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT2 #(
    .INIT(4'hE)) 
    have_target_i_1
       (.I0(have_target2_out),
        .I1(have_target_reg_n_0),
        .O(have_target_i_1_n_0));
  FDRE have_target_reg
       (.C(clk),
        .CE(1'b1),
        .D(have_target_i_1_n_0),
        .Q(have_target_reg_n_0),
        .R(\pwm[5]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h0040)) 
    \pending[0][15]_i_1 
       (.I0(fault),
        .I1(have_target2_out),
        .I2(enable),
        .I3(estop),
        .O(\pending[0][15]_i_1_n_0 ));
  FDRE \pending_reg[0][0] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[0]),
        .Q(\pending_reg[0] [0]),
        .R(p_0_in));
  FDRE \pending_reg[0][10] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[10]),
        .Q(\pending_reg[0] [10]),
        .R(p_0_in));
  FDRE \pending_reg[0][11] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[11]),
        .Q(\pending_reg[0] [11]),
        .R(p_0_in));
  FDRE \pending_reg[0][12] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[12]),
        .Q(\pending_reg[0] [12]),
        .R(p_0_in));
  FDRE \pending_reg[0][13] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[13]),
        .Q(\pending_reg[0] [13]),
        .R(p_0_in));
  FDRE \pending_reg[0][14] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[14]),
        .Q(\pending_reg[0] [14]),
        .R(p_0_in));
  FDRE \pending_reg[0][15] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[15]),
        .Q(\pending_reg[0] [15]),
        .R(p_0_in));
  FDRE \pending_reg[0][1] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[1]),
        .Q(\pending_reg[0] [1]),
        .R(p_0_in));
  FDRE \pending_reg[0][2] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[2]),
        .Q(\pending_reg[0] [2]),
        .R(p_0_in));
  FDRE \pending_reg[0][3] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[3]),
        .Q(\pending_reg[0] [3]),
        .R(p_0_in));
  FDRE \pending_reg[0][4] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[4]),
        .Q(\pending_reg[0] [4]),
        .R(p_0_in));
  FDRE \pending_reg[0][5] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[5]),
        .Q(\pending_reg[0] [5]),
        .R(p_0_in));
  FDRE \pending_reg[0][6] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[6]),
        .Q(\pending_reg[0] [6]),
        .R(p_0_in));
  FDRE \pending_reg[0][7] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[7]),
        .Q(\pending_reg[0] [7]),
        .R(p_0_in));
  FDRE \pending_reg[0][8] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[8]),
        .Q(\pending_reg[0] [8]),
        .R(p_0_in));
  FDRE \pending_reg[0][9] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[9]),
        .Q(\pending_reg[0] [9]),
        .R(p_0_in));
  FDRE \pending_reg[1][0] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[16]),
        .Q(\pending_reg[1] [0]),
        .R(p_0_in));
  FDRE \pending_reg[1][10] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[26]),
        .Q(\pending_reg[1] [10]),
        .R(p_0_in));
  FDRE \pending_reg[1][11] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[27]),
        .Q(\pending_reg[1] [11]),
        .R(p_0_in));
  FDRE \pending_reg[1][12] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[28]),
        .Q(\pending_reg[1] [12]),
        .R(p_0_in));
  FDRE \pending_reg[1][13] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[29]),
        .Q(\pending_reg[1] [13]),
        .R(p_0_in));
  FDRE \pending_reg[1][14] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[30]),
        .Q(\pending_reg[1] [14]),
        .R(p_0_in));
  FDRE \pending_reg[1][15] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[31]),
        .Q(\pending_reg[1] [15]),
        .R(p_0_in));
  FDRE \pending_reg[1][1] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[17]),
        .Q(\pending_reg[1] [1]),
        .R(p_0_in));
  FDRE \pending_reg[1][2] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[18]),
        .Q(\pending_reg[1] [2]),
        .R(p_0_in));
  FDRE \pending_reg[1][3] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[19]),
        .Q(\pending_reg[1] [3]),
        .R(p_0_in));
  FDRE \pending_reg[1][4] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[20]),
        .Q(\pending_reg[1] [4]),
        .R(p_0_in));
  FDRE \pending_reg[1][5] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[21]),
        .Q(\pending_reg[1] [5]),
        .R(p_0_in));
  FDRE \pending_reg[1][6] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[22]),
        .Q(\pending_reg[1] [6]),
        .R(p_0_in));
  FDRE \pending_reg[1][7] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[23]),
        .Q(\pending_reg[1] [7]),
        .R(p_0_in));
  FDRE \pending_reg[1][8] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[24]),
        .Q(\pending_reg[1] [8]),
        .R(p_0_in));
  FDRE \pending_reg[1][9] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[25]),
        .Q(\pending_reg[1] [9]),
        .R(p_0_in));
  FDRE \pending_reg[2][0] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[32]),
        .Q(\pending_reg[2] [0]),
        .R(p_0_in));
  FDRE \pending_reg[2][10] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[42]),
        .Q(\pending_reg[2] [10]),
        .R(p_0_in));
  FDRE \pending_reg[2][11] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[43]),
        .Q(\pending_reg[2] [11]),
        .R(p_0_in));
  FDRE \pending_reg[2][12] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[44]),
        .Q(\pending_reg[2] [12]),
        .R(p_0_in));
  FDRE \pending_reg[2][13] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[45]),
        .Q(\pending_reg[2] [13]),
        .R(p_0_in));
  FDRE \pending_reg[2][14] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[46]),
        .Q(\pending_reg[2] [14]),
        .R(p_0_in));
  FDRE \pending_reg[2][15] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[47]),
        .Q(\pending_reg[2] [15]),
        .R(p_0_in));
  FDRE \pending_reg[2][1] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[33]),
        .Q(\pending_reg[2] [1]),
        .R(p_0_in));
  FDRE \pending_reg[2][2] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[34]),
        .Q(\pending_reg[2] [2]),
        .R(p_0_in));
  FDRE \pending_reg[2][3] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[35]),
        .Q(\pending_reg[2] [3]),
        .R(p_0_in));
  FDRE \pending_reg[2][4] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[36]),
        .Q(\pending_reg[2] [4]),
        .R(p_0_in));
  FDRE \pending_reg[2][5] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[37]),
        .Q(\pending_reg[2] [5]),
        .R(p_0_in));
  FDRE \pending_reg[2][6] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[38]),
        .Q(\pending_reg[2] [6]),
        .R(p_0_in));
  FDRE \pending_reg[2][7] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[39]),
        .Q(\pending_reg[2] [7]),
        .R(p_0_in));
  FDRE \pending_reg[2][8] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[40]),
        .Q(\pending_reg[2] [8]),
        .R(p_0_in));
  FDRE \pending_reg[2][9] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[41]),
        .Q(\pending_reg[2] [9]),
        .R(p_0_in));
  FDRE \pending_reg[3][0] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[48]),
        .Q(\pending_reg[3] [0]),
        .R(p_0_in));
  FDRE \pending_reg[3][10] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[58]),
        .Q(\pending_reg[3] [10]),
        .R(p_0_in));
  FDRE \pending_reg[3][11] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[59]),
        .Q(\pending_reg[3] [11]),
        .R(p_0_in));
  FDRE \pending_reg[3][12] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[60]),
        .Q(\pending_reg[3] [12]),
        .R(p_0_in));
  FDRE \pending_reg[3][13] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[61]),
        .Q(\pending_reg[3] [13]),
        .R(p_0_in));
  FDRE \pending_reg[3][14] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[62]),
        .Q(\pending_reg[3] [14]),
        .R(p_0_in));
  FDRE \pending_reg[3][15] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[63]),
        .Q(\pending_reg[3] [15]),
        .R(p_0_in));
  FDRE \pending_reg[3][1] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[49]),
        .Q(\pending_reg[3] [1]),
        .R(p_0_in));
  FDRE \pending_reg[3][2] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[50]),
        .Q(\pending_reg[3] [2]),
        .R(p_0_in));
  FDRE \pending_reg[3][3] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[51]),
        .Q(\pending_reg[3] [3]),
        .R(p_0_in));
  FDRE \pending_reg[3][4] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[52]),
        .Q(\pending_reg[3] [4]),
        .R(p_0_in));
  FDRE \pending_reg[3][5] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[53]),
        .Q(\pending_reg[3] [5]),
        .R(p_0_in));
  FDRE \pending_reg[3][6] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[54]),
        .Q(\pending_reg[3] [6]),
        .R(p_0_in));
  FDRE \pending_reg[3][7] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[55]),
        .Q(\pending_reg[3] [7]),
        .R(p_0_in));
  FDRE \pending_reg[3][8] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[56]),
        .Q(\pending_reg[3] [8]),
        .R(p_0_in));
  FDRE \pending_reg[3][9] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[57]),
        .Q(\pending_reg[3] [9]),
        .R(p_0_in));
  FDRE \pending_reg[4][0] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[64]),
        .Q(\pending_reg[4] [0]),
        .R(p_0_in));
  FDRE \pending_reg[4][10] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[74]),
        .Q(\pending_reg[4] [10]),
        .R(p_0_in));
  FDRE \pending_reg[4][11] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[75]),
        .Q(\pending_reg[4] [11]),
        .R(p_0_in));
  FDRE \pending_reg[4][12] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[76]),
        .Q(\pending_reg[4] [12]),
        .R(p_0_in));
  FDRE \pending_reg[4][13] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[77]),
        .Q(\pending_reg[4] [13]),
        .R(p_0_in));
  FDRE \pending_reg[4][14] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[78]),
        .Q(\pending_reg[4] [14]),
        .R(p_0_in));
  FDRE \pending_reg[4][15] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[79]),
        .Q(\pending_reg[4] [15]),
        .R(p_0_in));
  FDRE \pending_reg[4][1] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[65]),
        .Q(\pending_reg[4] [1]),
        .R(p_0_in));
  FDRE \pending_reg[4][2] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[66]),
        .Q(\pending_reg[4] [2]),
        .R(p_0_in));
  FDRE \pending_reg[4][3] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[67]),
        .Q(\pending_reg[4] [3]),
        .R(p_0_in));
  FDRE \pending_reg[4][4] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[68]),
        .Q(\pending_reg[4] [4]),
        .R(p_0_in));
  FDRE \pending_reg[4][5] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[69]),
        .Q(\pending_reg[4] [5]),
        .R(p_0_in));
  FDRE \pending_reg[4][6] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[70]),
        .Q(\pending_reg[4] [6]),
        .R(p_0_in));
  FDRE \pending_reg[4][7] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[71]),
        .Q(\pending_reg[4] [7]),
        .R(p_0_in));
  FDRE \pending_reg[4][8] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[72]),
        .Q(\pending_reg[4] [8]),
        .R(p_0_in));
  FDRE \pending_reg[4][9] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[73]),
        .Q(\pending_reg[4] [9]),
        .R(p_0_in));
  FDRE \pending_reg[5][0] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[80]),
        .Q(\pending_reg[5] [0]),
        .R(p_0_in));
  FDRE \pending_reg[5][10] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[90]),
        .Q(\pending_reg[5] [10]),
        .R(p_0_in));
  FDRE \pending_reg[5][11] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[91]),
        .Q(\pending_reg[5] [11]),
        .R(p_0_in));
  FDRE \pending_reg[5][12] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[92]),
        .Q(\pending_reg[5] [12]),
        .R(p_0_in));
  FDRE \pending_reg[5][13] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[93]),
        .Q(\pending_reg[5] [13]),
        .R(p_0_in));
  FDRE \pending_reg[5][14] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[94]),
        .Q(\pending_reg[5] [14]),
        .R(p_0_in));
  FDRE \pending_reg[5][15] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[95]),
        .Q(\pending_reg[5] [15]),
        .R(p_0_in));
  FDRE \pending_reg[5][1] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[81]),
        .Q(\pending_reg[5] [1]),
        .R(p_0_in));
  FDRE \pending_reg[5][2] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[82]),
        .Q(\pending_reg[5] [2]),
        .R(p_0_in));
  FDRE \pending_reg[5][3] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[83]),
        .Q(\pending_reg[5] [3]),
        .R(p_0_in));
  FDRE \pending_reg[5][4] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[84]),
        .Q(\pending_reg[5] [4]),
        .R(p_0_in));
  FDRE \pending_reg[5][5] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[85]),
        .Q(\pending_reg[5] [5]),
        .R(p_0_in));
  FDRE \pending_reg[5][6] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[86]),
        .Q(\pending_reg[5] [6]),
        .R(p_0_in));
  FDRE \pending_reg[5][7] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[87]),
        .Q(\pending_reg[5] [7]),
        .R(p_0_in));
  FDRE \pending_reg[5][8] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[88]),
        .Q(\pending_reg[5] [8]),
        .R(p_0_in));
  FDRE \pending_reg[5][9] 
       (.C(clk),
        .CE(\pending[0][15]_i_1_n_0 ),
        .D(command_us[89]),
        .Q(\pending_reg[5] [9]),
        .R(p_0_in));
  LUT4 #(
    .INIT(16'h8B88)) 
    \pwm[0]_i_1 
       (.I0(have_target_reg_n_0),
        .I1(\pwm[5]_i_4_n_0 ),
        .I2(\pwm_reg[0]_i_2_n_0 ),
        .I3(pwm[0]),
        .O(\pwm[0]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[0]_i_10 
       (.I0(\frame_us_reg_n_0_[11] ),
        .I1(current_us[11]),
        .I2(\frame_us_reg_n_0_[10] ),
        .I3(current_us[10]),
        .O(\pwm[0]_i_10_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[0]_i_11 
       (.I0(\frame_us_reg_n_0_[9] ),
        .I1(current_us[9]),
        .I2(\frame_us_reg_n_0_[8] ),
        .I3(current_us[8]),
        .O(\pwm[0]_i_11_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[0]_i_12 
       (.I0(current_us[7]),
        .I1(\frame_us_reg_n_0_[7] ),
        .I2(\frame_us_reg_n_0_[6] ),
        .I3(current_us[6]),
        .O(\pwm[0]_i_12_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[0]_i_13 
       (.I0(current_us[5]),
        .I1(\frame_us_reg_n_0_[5] ),
        .I2(\frame_us_reg_n_0_[4] ),
        .I3(current_us[4]),
        .O(\pwm[0]_i_13_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[0]_i_14 
       (.I0(current_us[3]),
        .I1(\frame_us_reg_n_0_[3] ),
        .I2(\frame_us_reg_n_0_[2] ),
        .I3(current_us[2]),
        .O(\pwm[0]_i_14_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[0]_i_15 
       (.I0(current_us[1]),
        .I1(\frame_us_reg_n_0_[1] ),
        .I2(\frame_us_reg_n_0_[0] ),
        .I3(current_us[0]),
        .O(\pwm[0]_i_15_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[0]_i_16 
       (.I0(\frame_us_reg_n_0_[7] ),
        .I1(current_us[7]),
        .I2(\frame_us_reg_n_0_[6] ),
        .I3(current_us[6]),
        .O(\pwm[0]_i_16_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[0]_i_17 
       (.I0(\frame_us_reg_n_0_[5] ),
        .I1(current_us[5]),
        .I2(\frame_us_reg_n_0_[4] ),
        .I3(current_us[4]),
        .O(\pwm[0]_i_17_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[0]_i_18 
       (.I0(\frame_us_reg_n_0_[3] ),
        .I1(current_us[3]),
        .I2(\frame_us_reg_n_0_[2] ),
        .I3(current_us[2]),
        .O(\pwm[0]_i_18_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[0]_i_19 
       (.I0(\frame_us_reg_n_0_[1] ),
        .I1(current_us[1]),
        .I2(\frame_us_reg_n_0_[0] ),
        .I3(current_us[0]),
        .O(\pwm[0]_i_19_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \pwm[0]_i_4 
       (.I0(current_us[15]),
        .I1(\frame_us_reg_n_0_[14] ),
        .I2(current_us[14]),
        .O(\pwm[0]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[0]_i_5 
       (.I0(current_us[13]),
        .I1(\frame_us_reg_n_0_[13] ),
        .I2(\frame_us_reg_n_0_[12] ),
        .I3(current_us[12]),
        .O(\pwm[0]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[0]_i_6 
       (.I0(current_us[11]),
        .I1(\frame_us_reg_n_0_[11] ),
        .I2(\frame_us_reg_n_0_[10] ),
        .I3(current_us[10]),
        .O(\pwm[0]_i_6_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[0]_i_7 
       (.I0(current_us[9]),
        .I1(\frame_us_reg_n_0_[9] ),
        .I2(\frame_us_reg_n_0_[8] ),
        .I3(current_us[8]),
        .O(\pwm[0]_i_7_n_0 ));
  LUT3 #(
    .INIT(8'h41)) 
    \pwm[0]_i_8 
       (.I0(current_us[15]),
        .I1(\frame_us_reg_n_0_[14] ),
        .I2(current_us[14]),
        .O(\pwm[0]_i_8_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[0]_i_9 
       (.I0(\frame_us_reg_n_0_[13] ),
        .I1(current_us[13]),
        .I2(\frame_us_reg_n_0_[12] ),
        .I3(current_us[12]),
        .O(\pwm[0]_i_9_n_0 ));
  LUT4 #(
    .INIT(16'h8B88)) 
    \pwm[1]_i_1 
       (.I0(have_target_reg_n_0),
        .I1(\pwm[5]_i_4_n_0 ),
        .I2(\pwm_reg[1]_i_2_n_0 ),
        .I3(pwm[1]),
        .O(\pwm[1]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[1]_i_10 
       (.I0(\frame_us_reg_n_0_[11] ),
        .I1(current_us[27]),
        .I2(\frame_us_reg_n_0_[10] ),
        .I3(current_us[26]),
        .O(\pwm[1]_i_10_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[1]_i_11 
       (.I0(\frame_us_reg_n_0_[9] ),
        .I1(current_us[25]),
        .I2(\frame_us_reg_n_0_[8] ),
        .I3(current_us[24]),
        .O(\pwm[1]_i_11_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[1]_i_12 
       (.I0(current_us[23]),
        .I1(\frame_us_reg_n_0_[7] ),
        .I2(\frame_us_reg_n_0_[6] ),
        .I3(current_us[22]),
        .O(\pwm[1]_i_12_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[1]_i_13 
       (.I0(current_us[21]),
        .I1(\frame_us_reg_n_0_[5] ),
        .I2(\frame_us_reg_n_0_[4] ),
        .I3(current_us[20]),
        .O(\pwm[1]_i_13_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[1]_i_14 
       (.I0(current_us[19]),
        .I1(\frame_us_reg_n_0_[3] ),
        .I2(\frame_us_reg_n_0_[2] ),
        .I3(current_us[18]),
        .O(\pwm[1]_i_14_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[1]_i_15 
       (.I0(current_us[17]),
        .I1(\frame_us_reg_n_0_[1] ),
        .I2(\frame_us_reg_n_0_[0] ),
        .I3(current_us[16]),
        .O(\pwm[1]_i_15_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[1]_i_16 
       (.I0(\frame_us_reg_n_0_[7] ),
        .I1(current_us[23]),
        .I2(\frame_us_reg_n_0_[6] ),
        .I3(current_us[22]),
        .O(\pwm[1]_i_16_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[1]_i_17 
       (.I0(\frame_us_reg_n_0_[5] ),
        .I1(current_us[21]),
        .I2(\frame_us_reg_n_0_[4] ),
        .I3(current_us[20]),
        .O(\pwm[1]_i_17_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[1]_i_18 
       (.I0(\frame_us_reg_n_0_[3] ),
        .I1(current_us[19]),
        .I2(\frame_us_reg_n_0_[2] ),
        .I3(current_us[18]),
        .O(\pwm[1]_i_18_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[1]_i_19 
       (.I0(\frame_us_reg_n_0_[1] ),
        .I1(current_us[17]),
        .I2(\frame_us_reg_n_0_[0] ),
        .I3(current_us[16]),
        .O(\pwm[1]_i_19_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \pwm[1]_i_4 
       (.I0(current_us[31]),
        .I1(\frame_us_reg_n_0_[14] ),
        .I2(current_us[30]),
        .O(\pwm[1]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[1]_i_5 
       (.I0(current_us[29]),
        .I1(\frame_us_reg_n_0_[13] ),
        .I2(\frame_us_reg_n_0_[12] ),
        .I3(current_us[28]),
        .O(\pwm[1]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[1]_i_6 
       (.I0(current_us[27]),
        .I1(\frame_us_reg_n_0_[11] ),
        .I2(\frame_us_reg_n_0_[10] ),
        .I3(current_us[26]),
        .O(\pwm[1]_i_6_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[1]_i_7 
       (.I0(current_us[25]),
        .I1(\frame_us_reg_n_0_[9] ),
        .I2(\frame_us_reg_n_0_[8] ),
        .I3(current_us[24]),
        .O(\pwm[1]_i_7_n_0 ));
  LUT3 #(
    .INIT(8'h41)) 
    \pwm[1]_i_8 
       (.I0(current_us[31]),
        .I1(\frame_us_reg_n_0_[14] ),
        .I2(current_us[30]),
        .O(\pwm[1]_i_8_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[1]_i_9 
       (.I0(\frame_us_reg_n_0_[13] ),
        .I1(current_us[29]),
        .I2(\frame_us_reg_n_0_[12] ),
        .I3(current_us[28]),
        .O(\pwm[1]_i_9_n_0 ));
  LUT4 #(
    .INIT(16'h8B88)) 
    \pwm[2]_i_1 
       (.I0(have_target_reg_n_0),
        .I1(\pwm[5]_i_4_n_0 ),
        .I2(\pwm_reg[2]_i_2_n_0 ),
        .I3(pwm[2]),
        .O(\pwm[2]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[2]_i_10 
       (.I0(\frame_us_reg_n_0_[11] ),
        .I1(current_us[43]),
        .I2(\frame_us_reg_n_0_[10] ),
        .I3(current_us[42]),
        .O(\pwm[2]_i_10_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[2]_i_11 
       (.I0(\frame_us_reg_n_0_[9] ),
        .I1(current_us[41]),
        .I2(\frame_us_reg_n_0_[8] ),
        .I3(current_us[40]),
        .O(\pwm[2]_i_11_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[2]_i_12 
       (.I0(current_us[39]),
        .I1(\frame_us_reg_n_0_[7] ),
        .I2(\frame_us_reg_n_0_[6] ),
        .I3(current_us[38]),
        .O(\pwm[2]_i_12_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[2]_i_13 
       (.I0(current_us[37]),
        .I1(\frame_us_reg_n_0_[5] ),
        .I2(\frame_us_reg_n_0_[4] ),
        .I3(current_us[36]),
        .O(\pwm[2]_i_13_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[2]_i_14 
       (.I0(current_us[35]),
        .I1(\frame_us_reg_n_0_[3] ),
        .I2(\frame_us_reg_n_0_[2] ),
        .I3(current_us[34]),
        .O(\pwm[2]_i_14_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[2]_i_15 
       (.I0(current_us[33]),
        .I1(\frame_us_reg_n_0_[1] ),
        .I2(\frame_us_reg_n_0_[0] ),
        .I3(current_us[32]),
        .O(\pwm[2]_i_15_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[2]_i_16 
       (.I0(\frame_us_reg_n_0_[7] ),
        .I1(current_us[39]),
        .I2(\frame_us_reg_n_0_[6] ),
        .I3(current_us[38]),
        .O(\pwm[2]_i_16_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[2]_i_17 
       (.I0(\frame_us_reg_n_0_[5] ),
        .I1(current_us[37]),
        .I2(\frame_us_reg_n_0_[4] ),
        .I3(current_us[36]),
        .O(\pwm[2]_i_17_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[2]_i_18 
       (.I0(\frame_us_reg_n_0_[3] ),
        .I1(current_us[35]),
        .I2(\frame_us_reg_n_0_[2] ),
        .I3(current_us[34]),
        .O(\pwm[2]_i_18_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[2]_i_19 
       (.I0(\frame_us_reg_n_0_[1] ),
        .I1(current_us[33]),
        .I2(\frame_us_reg_n_0_[0] ),
        .I3(current_us[32]),
        .O(\pwm[2]_i_19_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \pwm[2]_i_4 
       (.I0(current_us[47]),
        .I1(\frame_us_reg_n_0_[14] ),
        .I2(current_us[46]),
        .O(\pwm[2]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[2]_i_5 
       (.I0(current_us[45]),
        .I1(\frame_us_reg_n_0_[13] ),
        .I2(\frame_us_reg_n_0_[12] ),
        .I3(current_us[44]),
        .O(\pwm[2]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[2]_i_6 
       (.I0(current_us[43]),
        .I1(\frame_us_reg_n_0_[11] ),
        .I2(\frame_us_reg_n_0_[10] ),
        .I3(current_us[42]),
        .O(\pwm[2]_i_6_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[2]_i_7 
       (.I0(current_us[41]),
        .I1(\frame_us_reg_n_0_[9] ),
        .I2(\frame_us_reg_n_0_[8] ),
        .I3(current_us[40]),
        .O(\pwm[2]_i_7_n_0 ));
  LUT3 #(
    .INIT(8'h41)) 
    \pwm[2]_i_8 
       (.I0(current_us[47]),
        .I1(\frame_us_reg_n_0_[14] ),
        .I2(current_us[46]),
        .O(\pwm[2]_i_8_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[2]_i_9 
       (.I0(\frame_us_reg_n_0_[13] ),
        .I1(current_us[45]),
        .I2(\frame_us_reg_n_0_[12] ),
        .I3(current_us[44]),
        .O(\pwm[2]_i_9_n_0 ));
  LUT4 #(
    .INIT(16'h8B88)) 
    \pwm[3]_i_1 
       (.I0(have_target_reg_n_0),
        .I1(\pwm[5]_i_4_n_0 ),
        .I2(\pwm_reg[3]_i_2_n_0 ),
        .I3(pwm[3]),
        .O(\pwm[3]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[3]_i_10 
       (.I0(\frame_us_reg_n_0_[11] ),
        .I1(current_us[59]),
        .I2(\frame_us_reg_n_0_[10] ),
        .I3(current_us[58]),
        .O(\pwm[3]_i_10_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[3]_i_11 
       (.I0(\frame_us_reg_n_0_[9] ),
        .I1(current_us[57]),
        .I2(\frame_us_reg_n_0_[8] ),
        .I3(current_us[56]),
        .O(\pwm[3]_i_11_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[3]_i_12 
       (.I0(current_us[55]),
        .I1(\frame_us_reg_n_0_[7] ),
        .I2(\frame_us_reg_n_0_[6] ),
        .I3(current_us[54]),
        .O(\pwm[3]_i_12_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[3]_i_13 
       (.I0(current_us[53]),
        .I1(\frame_us_reg_n_0_[5] ),
        .I2(\frame_us_reg_n_0_[4] ),
        .I3(current_us[52]),
        .O(\pwm[3]_i_13_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[3]_i_14 
       (.I0(current_us[51]),
        .I1(\frame_us_reg_n_0_[3] ),
        .I2(\frame_us_reg_n_0_[2] ),
        .I3(current_us[50]),
        .O(\pwm[3]_i_14_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[3]_i_15 
       (.I0(current_us[49]),
        .I1(\frame_us_reg_n_0_[1] ),
        .I2(\frame_us_reg_n_0_[0] ),
        .I3(current_us[48]),
        .O(\pwm[3]_i_15_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[3]_i_16 
       (.I0(\frame_us_reg_n_0_[7] ),
        .I1(current_us[55]),
        .I2(\frame_us_reg_n_0_[6] ),
        .I3(current_us[54]),
        .O(\pwm[3]_i_16_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[3]_i_17 
       (.I0(\frame_us_reg_n_0_[5] ),
        .I1(current_us[53]),
        .I2(\frame_us_reg_n_0_[4] ),
        .I3(current_us[52]),
        .O(\pwm[3]_i_17_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[3]_i_18 
       (.I0(\frame_us_reg_n_0_[3] ),
        .I1(current_us[51]),
        .I2(\frame_us_reg_n_0_[2] ),
        .I3(current_us[50]),
        .O(\pwm[3]_i_18_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[3]_i_19 
       (.I0(\frame_us_reg_n_0_[1] ),
        .I1(current_us[49]),
        .I2(\frame_us_reg_n_0_[0] ),
        .I3(current_us[48]),
        .O(\pwm[3]_i_19_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \pwm[3]_i_4 
       (.I0(current_us[63]),
        .I1(\frame_us_reg_n_0_[14] ),
        .I2(current_us[62]),
        .O(\pwm[3]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[3]_i_5 
       (.I0(current_us[61]),
        .I1(\frame_us_reg_n_0_[13] ),
        .I2(\frame_us_reg_n_0_[12] ),
        .I3(current_us[60]),
        .O(\pwm[3]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[3]_i_6 
       (.I0(current_us[59]),
        .I1(\frame_us_reg_n_0_[11] ),
        .I2(\frame_us_reg_n_0_[10] ),
        .I3(current_us[58]),
        .O(\pwm[3]_i_6_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[3]_i_7 
       (.I0(current_us[57]),
        .I1(\frame_us_reg_n_0_[9] ),
        .I2(\frame_us_reg_n_0_[8] ),
        .I3(current_us[56]),
        .O(\pwm[3]_i_7_n_0 ));
  LUT3 #(
    .INIT(8'h41)) 
    \pwm[3]_i_8 
       (.I0(current_us[63]),
        .I1(\frame_us_reg_n_0_[14] ),
        .I2(current_us[62]),
        .O(\pwm[3]_i_8_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[3]_i_9 
       (.I0(\frame_us_reg_n_0_[13] ),
        .I1(current_us[61]),
        .I2(\frame_us_reg_n_0_[12] ),
        .I3(current_us[60]),
        .O(\pwm[3]_i_9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT4 #(
    .INIT(16'h8B88)) 
    \pwm[4]_i_1 
       (.I0(have_target_reg_n_0),
        .I1(\pwm[5]_i_4_n_0 ),
        .I2(\pwm_reg[4]_i_2_n_0 ),
        .I3(pwm[4]),
        .O(\pwm[4]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[4]_i_10 
       (.I0(\frame_us_reg_n_0_[11] ),
        .I1(current_us[75]),
        .I2(\frame_us_reg_n_0_[10] ),
        .I3(current_us[74]),
        .O(\pwm[4]_i_10_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[4]_i_11 
       (.I0(\frame_us_reg_n_0_[9] ),
        .I1(current_us[73]),
        .I2(\frame_us_reg_n_0_[8] ),
        .I3(current_us[72]),
        .O(\pwm[4]_i_11_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[4]_i_12 
       (.I0(current_us[71]),
        .I1(\frame_us_reg_n_0_[7] ),
        .I2(\frame_us_reg_n_0_[6] ),
        .I3(current_us[70]),
        .O(\pwm[4]_i_12_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[4]_i_13 
       (.I0(current_us[69]),
        .I1(\frame_us_reg_n_0_[5] ),
        .I2(\frame_us_reg_n_0_[4] ),
        .I3(current_us[68]),
        .O(\pwm[4]_i_13_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[4]_i_14 
       (.I0(current_us[67]),
        .I1(\frame_us_reg_n_0_[3] ),
        .I2(\frame_us_reg_n_0_[2] ),
        .I3(current_us[66]),
        .O(\pwm[4]_i_14_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[4]_i_15 
       (.I0(current_us[65]),
        .I1(\frame_us_reg_n_0_[1] ),
        .I2(\frame_us_reg_n_0_[0] ),
        .I3(current_us[64]),
        .O(\pwm[4]_i_15_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[4]_i_16 
       (.I0(\frame_us_reg_n_0_[7] ),
        .I1(current_us[71]),
        .I2(\frame_us_reg_n_0_[6] ),
        .I3(current_us[70]),
        .O(\pwm[4]_i_16_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[4]_i_17 
       (.I0(\frame_us_reg_n_0_[5] ),
        .I1(current_us[69]),
        .I2(\frame_us_reg_n_0_[4] ),
        .I3(current_us[68]),
        .O(\pwm[4]_i_17_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[4]_i_18 
       (.I0(\frame_us_reg_n_0_[3] ),
        .I1(current_us[67]),
        .I2(\frame_us_reg_n_0_[2] ),
        .I3(current_us[66]),
        .O(\pwm[4]_i_18_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[4]_i_19 
       (.I0(\frame_us_reg_n_0_[1] ),
        .I1(current_us[65]),
        .I2(\frame_us_reg_n_0_[0] ),
        .I3(current_us[64]),
        .O(\pwm[4]_i_19_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \pwm[4]_i_4 
       (.I0(current_us[79]),
        .I1(\frame_us_reg_n_0_[14] ),
        .I2(current_us[78]),
        .O(\pwm[4]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[4]_i_5 
       (.I0(current_us[77]),
        .I1(\frame_us_reg_n_0_[13] ),
        .I2(\frame_us_reg_n_0_[12] ),
        .I3(current_us[76]),
        .O(\pwm[4]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[4]_i_6 
       (.I0(current_us[75]),
        .I1(\frame_us_reg_n_0_[11] ),
        .I2(\frame_us_reg_n_0_[10] ),
        .I3(current_us[74]),
        .O(\pwm[4]_i_6_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[4]_i_7 
       (.I0(current_us[73]),
        .I1(\frame_us_reg_n_0_[9] ),
        .I2(\frame_us_reg_n_0_[8] ),
        .I3(current_us[72]),
        .O(\pwm[4]_i_7_n_0 ));
  LUT3 #(
    .INIT(8'h41)) 
    \pwm[4]_i_8 
       (.I0(current_us[79]),
        .I1(\frame_us_reg_n_0_[14] ),
        .I2(current_us[78]),
        .O(\pwm[4]_i_8_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[4]_i_9 
       (.I0(\frame_us_reg_n_0_[13] ),
        .I1(current_us[77]),
        .I2(\frame_us_reg_n_0_[12] ),
        .I3(current_us[76]),
        .O(\pwm[4]_i_9_n_0 ));
  LUT5 #(
    .INIT(32'hFFDFFFFF)) 
    \pwm[5]_i_1 
       (.I0(enable),
        .I1(estop),
        .I2(rst_n),
        .I3(armed6_out),
        .I4(\sub_tick[4]_i_2_n_0 ),
        .O(\pwm[5]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    \pwm[5]_i_10 
       (.I0(\sub_tick_reg_n_0_[2] ),
        .I1(\sub_tick_reg_n_0_[1] ),
        .I2(\frame_us_reg_n_0_[12] ),
        .I3(\frame_us_reg_n_0_[0] ),
        .O(\pwm[5]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \pwm[5]_i_11 
       (.I0(\frame_us[14]_i_7_n_0 ),
        .I1(\pwm[5]_i_34_n_0 ),
        .I2(\sub_tick_reg_n_0_[0] ),
        .I3(\frame_us_reg_n_0_[9] ),
        .I4(\frame_us_reg_n_0_[14] ),
        .I5(\frame_us_reg_n_0_[3] ),
        .O(\pwm[5]_i_11_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \pwm[5]_i_13 
       (.I0(current_us[95]),
        .I1(\frame_us_reg_n_0_[14] ),
        .I2(current_us[94]),
        .O(\pwm[5]_i_13_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[5]_i_14 
       (.I0(current_us[93]),
        .I1(\frame_us_reg_n_0_[13] ),
        .I2(\frame_us_reg_n_0_[12] ),
        .I3(current_us[92]),
        .O(\pwm[5]_i_14_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[5]_i_15 
       (.I0(current_us[91]),
        .I1(\frame_us_reg_n_0_[11] ),
        .I2(\frame_us_reg_n_0_[10] ),
        .I3(current_us[90]),
        .O(\pwm[5]_i_15_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[5]_i_16 
       (.I0(current_us[89]),
        .I1(\frame_us_reg_n_0_[9] ),
        .I2(\frame_us_reg_n_0_[8] ),
        .I3(current_us[88]),
        .O(\pwm[5]_i_16_n_0 ));
  LUT3 #(
    .INIT(8'h41)) 
    \pwm[5]_i_17 
       (.I0(current_us[95]),
        .I1(\frame_us_reg_n_0_[14] ),
        .I2(current_us[94]),
        .O(\pwm[5]_i_17_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[5]_i_18 
       (.I0(\frame_us_reg_n_0_[13] ),
        .I1(current_us[93]),
        .I2(\frame_us_reg_n_0_[12] ),
        .I3(current_us[92]),
        .O(\pwm[5]_i_18_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[5]_i_19 
       (.I0(\frame_us_reg_n_0_[11] ),
        .I1(current_us[91]),
        .I2(\frame_us_reg_n_0_[10] ),
        .I3(current_us[90]),
        .O(\pwm[5]_i_19_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT4 #(
    .INIT(16'h8B88)) 
    \pwm[5]_i_2 
       (.I0(have_target_reg_n_0),
        .I1(\pwm[5]_i_4_n_0 ),
        .I2(\pwm_reg[5]_i_5_n_0 ),
        .I3(pwm[5]),
        .O(\pwm[5]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[5]_i_20 
       (.I0(\frame_us_reg_n_0_[9] ),
        .I1(current_us[89]),
        .I2(\frame_us_reg_n_0_[8] ),
        .I3(current_us[88]),
        .O(\pwm[5]_i_20_n_0 ));
  LUT6 #(
    .INIT(64'h1011111111111111)) 
    \pwm[5]_i_21 
       (.I0(command_us[9]),
        .I1(command_us[10]),
        .I2(\pwm[5]_i_43_n_0 ),
        .I3(command_us[6]),
        .I4(command_us[7]),
        .I5(command_us[8]),
        .O(\pwm[5]_i_21_n_0 ));
  LUT6 #(
    .INIT(64'h1011111111111111)) 
    \pwm[5]_i_22 
       (.I0(command_us[57]),
        .I1(command_us[58]),
        .I2(\pwm[5]_i_44_n_0 ),
        .I3(command_us[54]),
        .I4(command_us[55]),
        .I5(command_us[56]),
        .O(\pwm[5]_i_22_n_0 ));
  LUT5 #(
    .INIT(32'h0000000E)) 
    \pwm[5]_i_23 
       (.I0(\pwm[5]_i_45_n_0 ),
        .I1(\pwm[5]_i_46_n_0 ),
        .I2(command_us[26]),
        .I3(command_us[25]),
        .I4(command_us[27]),
        .O(\pwm[5]_i_23_n_0 ));
  LUT5 #(
    .INIT(32'h0000000E)) 
    \pwm[5]_i_24 
       (.I0(\pwm[5]_i_47_n_0 ),
        .I1(\pwm[5]_i_48_n_0 ),
        .I2(command_us[90]),
        .I3(command_us[89]),
        .I4(command_us[91]),
        .O(\pwm[5]_i_24_n_0 ));
  LUT5 #(
    .INIT(32'h00000007)) 
    \pwm[5]_i_25 
       (.I0(\pwm[5]_i_49_n_0 ),
        .I1(\pwm[5]_i_50_n_0 ),
        .I2(command_us[58]),
        .I3(command_us[57]),
        .I4(command_us[59]),
        .O(\pwm[5]_i_25_n_0 ));
  LUT5 #(
    .INIT(32'h00000007)) 
    \pwm[5]_i_26 
       (.I0(\pwm[5]_i_51_n_0 ),
        .I1(\pwm[5]_i_52_n_0 ),
        .I2(command_us[10]),
        .I3(command_us[9]),
        .I4(command_us[11]),
        .O(\pwm[5]_i_26_n_0 ));
  LUT5 #(
    .INIT(32'h0000000E)) 
    \pwm[5]_i_27 
       (.I0(\pwm[5]_i_53_n_0 ),
        .I1(\pwm[5]_i_54_n_0 ),
        .I2(command_us[42]),
        .I3(command_us[41]),
        .I4(command_us[43]),
        .O(\pwm[5]_i_27_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \pwm[5]_i_28 
       (.I0(\pwm[5]_i_55_n_0 ),
        .I1(\pwm[5]_i_56_n_0 ),
        .I2(\pwm[5]_i_57_n_0 ),
        .I3(\pwm[5]_i_58_n_0 ),
        .I4(\pwm[5]_i_59_n_0 ),
        .I5(\pwm[5]_i_60_n_0 ),
        .O(\pwm[5]_i_28_n_0 ));
  LUT5 #(
    .INIT(32'h0000000E)) 
    \pwm[5]_i_29 
       (.I0(\pwm[5]_i_61_n_0 ),
        .I1(\pwm[5]_i_62_n_0 ),
        .I2(command_us[74]),
        .I3(command_us[73]),
        .I4(command_us[75]),
        .O(\pwm[5]_i_29_n_0 ));
  LUT5 #(
    .INIT(32'hAAA8AAAA)) 
    \pwm[5]_i_3 
       (.I0(command_valid),
        .I1(\pwm[5]_i_6_n_0 ),
        .I2(\pwm[5]_i_7_n_0 ),
        .I3(\pwm[5]_i_8_n_0 ),
        .I4(\pwm[5]_i_9_n_0 ),
        .O(armed6_out));
  LUT6 #(
    .INIT(64'h000000000000FF7F)) 
    \pwm[5]_i_30 
       (.I0(command_us[86]),
        .I1(command_us[87]),
        .I2(command_us[88]),
        .I3(\pwm[5]_i_63_n_0 ),
        .I4(command_us[89]),
        .I5(command_us[90]),
        .O(\pwm[5]_i_30_n_0 ));
  LUT6 #(
    .INIT(64'h000000000000FF7F)) 
    \pwm[5]_i_31 
       (.I0(command_us[38]),
        .I1(command_us[39]),
        .I2(command_us[40]),
        .I3(\pwm[5]_i_64_n_0 ),
        .I4(command_us[41]),
        .I5(command_us[42]),
        .O(\pwm[5]_i_31_n_0 ));
  LUT5 #(
    .INIT(32'hA8A8A8AA)) 
    \pwm[5]_i_32 
       (.I0(command_us[75]),
        .I1(command_us[74]),
        .I2(command_us[73]),
        .I3(\pwm[5]_i_65_n_0 ),
        .I4(\pwm[5]_i_62_n_0 ),
        .O(\pwm[5]_i_32_n_0 ));
  LUT5 #(
    .INIT(32'hA8A8A8AA)) 
    \pwm[5]_i_33 
       (.I0(command_us[27]),
        .I1(command_us[26]),
        .I2(command_us[25]),
        .I3(\pwm[5]_i_66_n_0 ),
        .I4(\pwm[5]_i_46_n_0 ),
        .O(\pwm[5]_i_33_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \pwm[5]_i_34 
       (.I0(\sub_tick_reg_n_0_[4] ),
        .I1(\frame_us_reg_n_0_[1] ),
        .I2(\frame_us_reg_n_0_[8] ),
        .I3(\frame_us_reg_n_0_[4] ),
        .O(\pwm[5]_i_34_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[5]_i_35 
       (.I0(current_us[87]),
        .I1(\frame_us_reg_n_0_[7] ),
        .I2(\frame_us_reg_n_0_[6] ),
        .I3(current_us[86]),
        .O(\pwm[5]_i_35_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[5]_i_36 
       (.I0(current_us[85]),
        .I1(\frame_us_reg_n_0_[5] ),
        .I2(\frame_us_reg_n_0_[4] ),
        .I3(current_us[84]),
        .O(\pwm[5]_i_36_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[5]_i_37 
       (.I0(current_us[83]),
        .I1(\frame_us_reg_n_0_[3] ),
        .I2(\frame_us_reg_n_0_[2] ),
        .I3(current_us[82]),
        .O(\pwm[5]_i_37_n_0 ));
  LUT4 #(
    .INIT(16'h44D4)) 
    \pwm[5]_i_38 
       (.I0(current_us[81]),
        .I1(\frame_us_reg_n_0_[1] ),
        .I2(\frame_us_reg_n_0_[0] ),
        .I3(current_us[80]),
        .O(\pwm[5]_i_38_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[5]_i_39 
       (.I0(\frame_us_reg_n_0_[7] ),
        .I1(current_us[87]),
        .I2(\frame_us_reg_n_0_[6] ),
        .I3(current_us[86]),
        .O(\pwm[5]_i_39_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    \pwm[5]_i_4 
       (.I0(\pwm[5]_i_10_n_0 ),
        .I1(\sub_tick_reg_n_0_[3] ),
        .I2(\frame_us_reg_n_0_[10] ),
        .I3(\frame_us_reg_n_0_[11] ),
        .I4(\frame_us_reg_n_0_[2] ),
        .I5(\pwm[5]_i_11_n_0 ),
        .O(\pwm[5]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[5]_i_40 
       (.I0(\frame_us_reg_n_0_[5] ),
        .I1(current_us[85]),
        .I2(\frame_us_reg_n_0_[4] ),
        .I3(current_us[84]),
        .O(\pwm[5]_i_40_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[5]_i_41 
       (.I0(\frame_us_reg_n_0_[3] ),
        .I1(current_us[83]),
        .I2(\frame_us_reg_n_0_[2] ),
        .I3(current_us[82]),
        .O(\pwm[5]_i_41_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \pwm[5]_i_42 
       (.I0(\frame_us_reg_n_0_[1] ),
        .I1(current_us[81]),
        .I2(\frame_us_reg_n_0_[0] ),
        .I3(current_us[80]),
        .O(\pwm[5]_i_42_n_0 ));
  LUT6 #(
    .INIT(64'h000000000000001F)) 
    \pwm[5]_i_43 
       (.I0(command_us[0]),
        .I1(command_us[1]),
        .I2(command_us[2]),
        .I3(command_us[4]),
        .I4(command_us[3]),
        .I5(command_us[5]),
        .O(\pwm[5]_i_43_n_0 ));
  LUT6 #(
    .INIT(64'h000000000000001F)) 
    \pwm[5]_i_44 
       (.I0(command_us[48]),
        .I1(command_us[49]),
        .I2(command_us[50]),
        .I3(command_us[52]),
        .I4(command_us[51]),
        .I5(command_us[53]),
        .O(\pwm[5]_i_44_n_0 ));
  LUT4 #(
    .INIT(16'h1FFF)) 
    \pwm[5]_i_45 
       (.I0(command_us[19]),
        .I1(command_us[18]),
        .I2(command_us[20]),
        .I3(command_us[21]),
        .O(\pwm[5]_i_45_n_0 ));
  LUT3 #(
    .INIT(8'h7F)) 
    \pwm[5]_i_46 
       (.I0(command_us[22]),
        .I1(command_us[23]),
        .I2(command_us[24]),
        .O(\pwm[5]_i_46_n_0 ));
  LUT4 #(
    .INIT(16'h1FFF)) 
    \pwm[5]_i_47 
       (.I0(command_us[83]),
        .I1(command_us[82]),
        .I2(command_us[84]),
        .I3(command_us[85]),
        .O(\pwm[5]_i_47_n_0 ));
  LUT3 #(
    .INIT(8'h7F)) 
    \pwm[5]_i_48 
       (.I0(command_us[86]),
        .I1(command_us[87]),
        .I2(command_us[88]),
        .O(\pwm[5]_i_48_n_0 ));
  LUT4 #(
    .INIT(16'hE000)) 
    \pwm[5]_i_49 
       (.I0(command_us[51]),
        .I1(command_us[50]),
        .I2(command_us[52]),
        .I3(command_us[53]),
        .O(\pwm[5]_i_49_n_0 ));
  LUT3 #(
    .INIT(8'h80)) 
    \pwm[5]_i_50 
       (.I0(command_us[54]),
        .I1(command_us[55]),
        .I2(command_us[56]),
        .O(\pwm[5]_i_50_n_0 ));
  LUT4 #(
    .INIT(16'hE000)) 
    \pwm[5]_i_51 
       (.I0(command_us[3]),
        .I1(command_us[2]),
        .I2(command_us[4]),
        .I3(command_us[5]),
        .O(\pwm[5]_i_51_n_0 ));
  LUT3 #(
    .INIT(8'h80)) 
    \pwm[5]_i_52 
       (.I0(command_us[6]),
        .I1(command_us[7]),
        .I2(command_us[8]),
        .O(\pwm[5]_i_52_n_0 ));
  LUT4 #(
    .INIT(16'h1FFF)) 
    \pwm[5]_i_53 
       (.I0(command_us[35]),
        .I1(command_us[34]),
        .I2(command_us[36]),
        .I3(command_us[37]),
        .O(\pwm[5]_i_53_n_0 ));
  LUT3 #(
    .INIT(8'h7F)) 
    \pwm[5]_i_54 
       (.I0(command_us[38]),
        .I1(command_us[39]),
        .I2(command_us[40]),
        .O(\pwm[5]_i_54_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \pwm[5]_i_55 
       (.I0(command_us[29]),
        .I1(command_us[12]),
        .I2(command_us[47]),
        .I3(command_us[30]),
        .O(\pwm[5]_i_55_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \pwm[5]_i_56 
       (.I0(command_us[60]),
        .I1(command_us[61]),
        .I2(command_us[77]),
        .I3(command_us[45]),
        .O(\pwm[5]_i_56_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \pwm[5]_i_57 
       (.I0(command_us[62]),
        .I1(command_us[44]),
        .I2(command_us[78]),
        .I3(command_us[79]),
        .O(\pwm[5]_i_57_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \pwm[5]_i_58 
       (.I0(command_us[46]),
        .I1(command_us[28]),
        .I2(command_us[31]),
        .I3(command_us[13]),
        .O(\pwm[5]_i_58_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \pwm[5]_i_59 
       (.I0(command_us[63]),
        .I1(command_us[15]),
        .I2(command_us[92]),
        .I3(command_us[93]),
        .O(\pwm[5]_i_59_n_0 ));
  LUT4 #(
    .INIT(16'h4F44)) 
    \pwm[5]_i_6 
       (.I0(\pwm[5]_i_21_n_0 ),
        .I1(command_us[11]),
        .I2(\pwm[5]_i_22_n_0 ),
        .I3(command_us[59]),
        .O(\pwm[5]_i_6_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \pwm[5]_i_60 
       (.I0(command_us[95]),
        .I1(command_us[76]),
        .I2(command_us[94]),
        .I3(command_us[14]),
        .O(\pwm[5]_i_60_n_0 ));
  LUT4 #(
    .INIT(16'h1FFF)) 
    \pwm[5]_i_61 
       (.I0(command_us[67]),
        .I1(command_us[66]),
        .I2(command_us[68]),
        .I3(command_us[69]),
        .O(\pwm[5]_i_61_n_0 ));
  LUT3 #(
    .INIT(8'h7F)) 
    \pwm[5]_i_62 
       (.I0(command_us[70]),
        .I1(command_us[71]),
        .I2(command_us[72]),
        .O(\pwm[5]_i_62_n_0 ));
  LUT6 #(
    .INIT(64'h000000000000001F)) 
    \pwm[5]_i_63 
       (.I0(command_us[80]),
        .I1(command_us[81]),
        .I2(command_us[82]),
        .I3(command_us[84]),
        .I4(command_us[83]),
        .I5(command_us[85]),
        .O(\pwm[5]_i_63_n_0 ));
  LUT6 #(
    .INIT(64'h000000000000001F)) 
    \pwm[5]_i_64 
       (.I0(command_us[32]),
        .I1(command_us[33]),
        .I2(command_us[34]),
        .I3(command_us[36]),
        .I4(command_us[35]),
        .I5(command_us[37]),
        .O(\pwm[5]_i_64_n_0 ));
  LUT6 #(
    .INIT(64'h000000000000001F)) 
    \pwm[5]_i_65 
       (.I0(command_us[64]),
        .I1(command_us[65]),
        .I2(command_us[66]),
        .I3(command_us[68]),
        .I4(command_us[67]),
        .I5(command_us[69]),
        .O(\pwm[5]_i_65_n_0 ));
  LUT6 #(
    .INIT(64'h000000000000001F)) 
    \pwm[5]_i_66 
       (.I0(command_us[16]),
        .I1(command_us[17]),
        .I2(command_us[18]),
        .I3(command_us[20]),
        .I4(command_us[19]),
        .I5(command_us[21]),
        .O(\pwm[5]_i_66_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    \pwm[5]_i_7 
       (.I0(\pwm[5]_i_23_n_0 ),
        .I1(\pwm[5]_i_24_n_0 ),
        .I2(\pwm[5]_i_25_n_0 ),
        .I3(\pwm[5]_i_26_n_0 ),
        .O(\pwm[5]_i_7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT3 #(
    .INIT(8'hFE)) 
    \pwm[5]_i_8 
       (.I0(\pwm[5]_i_27_n_0 ),
        .I1(\pwm[5]_i_28_n_0 ),
        .I2(\pwm[5]_i_29_n_0 ),
        .O(\pwm[5]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'h000000000000D0DD)) 
    \pwm[5]_i_9 
       (.I0(command_us[91]),
        .I1(\pwm[5]_i_30_n_0 ),
        .I2(\pwm[5]_i_31_n_0 ),
        .I3(command_us[43]),
        .I4(\pwm[5]_i_32_n_0 ),
        .I5(\pwm[5]_i_33_n_0 ),
        .O(\pwm[5]_i_9_n_0 ));
  FDRE \pwm_reg[0] 
       (.C(clk),
        .CE(1'b1),
        .D(\pwm[0]_i_1_n_0 ),
        .Q(pwm[0]),
        .R(\pwm[5]_i_1_n_0 ));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \pwm_reg[0]_i_2 
       (.CI(\pwm_reg[0]_i_3_n_0 ),
        .CO({\pwm_reg[0]_i_2_n_0 ,\pwm_reg[0]_i_2_n_1 ,\pwm_reg[0]_i_2_n_2 ,\pwm_reg[0]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({\pwm[0]_i_4_n_0 ,\pwm[0]_i_5_n_0 ,\pwm[0]_i_6_n_0 ,\pwm[0]_i_7_n_0 }),
        .O(\NLW_pwm_reg[0]_i_2_O_UNCONNECTED [3:0]),
        .S({\pwm[0]_i_8_n_0 ,\pwm[0]_i_9_n_0 ,\pwm[0]_i_10_n_0 ,\pwm[0]_i_11_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \pwm_reg[0]_i_3 
       (.CI(1'b0),
        .CO({\pwm_reg[0]_i_3_n_0 ,\pwm_reg[0]_i_3_n_1 ,\pwm_reg[0]_i_3_n_2 ,\pwm_reg[0]_i_3_n_3 }),
        .CYINIT(1'b1),
        .DI({\pwm[0]_i_12_n_0 ,\pwm[0]_i_13_n_0 ,\pwm[0]_i_14_n_0 ,\pwm[0]_i_15_n_0 }),
        .O(\NLW_pwm_reg[0]_i_3_O_UNCONNECTED [3:0]),
        .S({\pwm[0]_i_16_n_0 ,\pwm[0]_i_17_n_0 ,\pwm[0]_i_18_n_0 ,\pwm[0]_i_19_n_0 }));
  FDRE \pwm_reg[1] 
       (.C(clk),
        .CE(1'b1),
        .D(\pwm[1]_i_1_n_0 ),
        .Q(pwm[1]),
        .R(\pwm[5]_i_1_n_0 ));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \pwm_reg[1]_i_2 
       (.CI(\pwm_reg[1]_i_3_n_0 ),
        .CO({\pwm_reg[1]_i_2_n_0 ,\pwm_reg[1]_i_2_n_1 ,\pwm_reg[1]_i_2_n_2 ,\pwm_reg[1]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({\pwm[1]_i_4_n_0 ,\pwm[1]_i_5_n_0 ,\pwm[1]_i_6_n_0 ,\pwm[1]_i_7_n_0 }),
        .O(\NLW_pwm_reg[1]_i_2_O_UNCONNECTED [3:0]),
        .S({\pwm[1]_i_8_n_0 ,\pwm[1]_i_9_n_0 ,\pwm[1]_i_10_n_0 ,\pwm[1]_i_11_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \pwm_reg[1]_i_3 
       (.CI(1'b0),
        .CO({\pwm_reg[1]_i_3_n_0 ,\pwm_reg[1]_i_3_n_1 ,\pwm_reg[1]_i_3_n_2 ,\pwm_reg[1]_i_3_n_3 }),
        .CYINIT(1'b1),
        .DI({\pwm[1]_i_12_n_0 ,\pwm[1]_i_13_n_0 ,\pwm[1]_i_14_n_0 ,\pwm[1]_i_15_n_0 }),
        .O(\NLW_pwm_reg[1]_i_3_O_UNCONNECTED [3:0]),
        .S({\pwm[1]_i_16_n_0 ,\pwm[1]_i_17_n_0 ,\pwm[1]_i_18_n_0 ,\pwm[1]_i_19_n_0 }));
  FDRE \pwm_reg[2] 
       (.C(clk),
        .CE(1'b1),
        .D(\pwm[2]_i_1_n_0 ),
        .Q(pwm[2]),
        .R(\pwm[5]_i_1_n_0 ));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \pwm_reg[2]_i_2 
       (.CI(\pwm_reg[2]_i_3_n_0 ),
        .CO({\pwm_reg[2]_i_2_n_0 ,\pwm_reg[2]_i_2_n_1 ,\pwm_reg[2]_i_2_n_2 ,\pwm_reg[2]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({\pwm[2]_i_4_n_0 ,\pwm[2]_i_5_n_0 ,\pwm[2]_i_6_n_0 ,\pwm[2]_i_7_n_0 }),
        .O(\NLW_pwm_reg[2]_i_2_O_UNCONNECTED [3:0]),
        .S({\pwm[2]_i_8_n_0 ,\pwm[2]_i_9_n_0 ,\pwm[2]_i_10_n_0 ,\pwm[2]_i_11_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \pwm_reg[2]_i_3 
       (.CI(1'b0),
        .CO({\pwm_reg[2]_i_3_n_0 ,\pwm_reg[2]_i_3_n_1 ,\pwm_reg[2]_i_3_n_2 ,\pwm_reg[2]_i_3_n_3 }),
        .CYINIT(1'b1),
        .DI({\pwm[2]_i_12_n_0 ,\pwm[2]_i_13_n_0 ,\pwm[2]_i_14_n_0 ,\pwm[2]_i_15_n_0 }),
        .O(\NLW_pwm_reg[2]_i_3_O_UNCONNECTED [3:0]),
        .S({\pwm[2]_i_16_n_0 ,\pwm[2]_i_17_n_0 ,\pwm[2]_i_18_n_0 ,\pwm[2]_i_19_n_0 }));
  FDRE \pwm_reg[3] 
       (.C(clk),
        .CE(1'b1),
        .D(\pwm[3]_i_1_n_0 ),
        .Q(pwm[3]),
        .R(\pwm[5]_i_1_n_0 ));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \pwm_reg[3]_i_2 
       (.CI(\pwm_reg[3]_i_3_n_0 ),
        .CO({\pwm_reg[3]_i_2_n_0 ,\pwm_reg[3]_i_2_n_1 ,\pwm_reg[3]_i_2_n_2 ,\pwm_reg[3]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({\pwm[3]_i_4_n_0 ,\pwm[3]_i_5_n_0 ,\pwm[3]_i_6_n_0 ,\pwm[3]_i_7_n_0 }),
        .O(\NLW_pwm_reg[3]_i_2_O_UNCONNECTED [3:0]),
        .S({\pwm[3]_i_8_n_0 ,\pwm[3]_i_9_n_0 ,\pwm[3]_i_10_n_0 ,\pwm[3]_i_11_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \pwm_reg[3]_i_3 
       (.CI(1'b0),
        .CO({\pwm_reg[3]_i_3_n_0 ,\pwm_reg[3]_i_3_n_1 ,\pwm_reg[3]_i_3_n_2 ,\pwm_reg[3]_i_3_n_3 }),
        .CYINIT(1'b1),
        .DI({\pwm[3]_i_12_n_0 ,\pwm[3]_i_13_n_0 ,\pwm[3]_i_14_n_0 ,\pwm[3]_i_15_n_0 }),
        .O(\NLW_pwm_reg[3]_i_3_O_UNCONNECTED [3:0]),
        .S({\pwm[3]_i_16_n_0 ,\pwm[3]_i_17_n_0 ,\pwm[3]_i_18_n_0 ,\pwm[3]_i_19_n_0 }));
  FDRE \pwm_reg[4] 
       (.C(clk),
        .CE(1'b1),
        .D(\pwm[4]_i_1_n_0 ),
        .Q(pwm[4]),
        .R(\pwm[5]_i_1_n_0 ));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \pwm_reg[4]_i_2 
       (.CI(\pwm_reg[4]_i_3_n_0 ),
        .CO({\pwm_reg[4]_i_2_n_0 ,\pwm_reg[4]_i_2_n_1 ,\pwm_reg[4]_i_2_n_2 ,\pwm_reg[4]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({\pwm[4]_i_4_n_0 ,\pwm[4]_i_5_n_0 ,\pwm[4]_i_6_n_0 ,\pwm[4]_i_7_n_0 }),
        .O(\NLW_pwm_reg[4]_i_2_O_UNCONNECTED [3:0]),
        .S({\pwm[4]_i_8_n_0 ,\pwm[4]_i_9_n_0 ,\pwm[4]_i_10_n_0 ,\pwm[4]_i_11_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \pwm_reg[4]_i_3 
       (.CI(1'b0),
        .CO({\pwm_reg[4]_i_3_n_0 ,\pwm_reg[4]_i_3_n_1 ,\pwm_reg[4]_i_3_n_2 ,\pwm_reg[4]_i_3_n_3 }),
        .CYINIT(1'b1),
        .DI({\pwm[4]_i_12_n_0 ,\pwm[4]_i_13_n_0 ,\pwm[4]_i_14_n_0 ,\pwm[4]_i_15_n_0 }),
        .O(\NLW_pwm_reg[4]_i_3_O_UNCONNECTED [3:0]),
        .S({\pwm[4]_i_16_n_0 ,\pwm[4]_i_17_n_0 ,\pwm[4]_i_18_n_0 ,\pwm[4]_i_19_n_0 }));
  FDRE \pwm_reg[5] 
       (.C(clk),
        .CE(1'b1),
        .D(\pwm[5]_i_2_n_0 ),
        .Q(pwm[5]),
        .R(\pwm[5]_i_1_n_0 ));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \pwm_reg[5]_i_12 
       (.CI(1'b0),
        .CO({\pwm_reg[5]_i_12_n_0 ,\pwm_reg[5]_i_12_n_1 ,\pwm_reg[5]_i_12_n_2 ,\pwm_reg[5]_i_12_n_3 }),
        .CYINIT(1'b1),
        .DI({\pwm[5]_i_35_n_0 ,\pwm[5]_i_36_n_0 ,\pwm[5]_i_37_n_0 ,\pwm[5]_i_38_n_0 }),
        .O(\NLW_pwm_reg[5]_i_12_O_UNCONNECTED [3:0]),
        .S({\pwm[5]_i_39_n_0 ,\pwm[5]_i_40_n_0 ,\pwm[5]_i_41_n_0 ,\pwm[5]_i_42_n_0 }));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \pwm_reg[5]_i_5 
       (.CI(\pwm_reg[5]_i_12_n_0 ),
        .CO({\pwm_reg[5]_i_5_n_0 ,\pwm_reg[5]_i_5_n_1 ,\pwm_reg[5]_i_5_n_2 ,\pwm_reg[5]_i_5_n_3 }),
        .CYINIT(1'b0),
        .DI({\pwm[5]_i_13_n_0 ,\pwm[5]_i_14_n_0 ,\pwm[5]_i_15_n_0 ,\pwm[5]_i_16_n_0 }),
        .O(\NLW_pwm_reg[5]_i_5_O_UNCONNECTED [3:0]),
        .S({\pwm[5]_i_17_n_0 ,\pwm[5]_i_18_n_0 ,\pwm[5]_i_19_n_0 ,\pwm[5]_i_20_n_0 }));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h55555515)) 
    \sub_tick[0]_i_1 
       (.I0(\sub_tick_reg_n_0_[0] ),
        .I1(\sub_tick_reg_n_0_[4] ),
        .I2(\sub_tick_reg_n_0_[3] ),
        .I3(\sub_tick_reg_n_0_[1] ),
        .I4(\sub_tick_reg_n_0_[2] ),
        .O(\sub_tick[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \sub_tick[1]_i_1 
       (.I0(\sub_tick_reg_n_0_[1] ),
        .I1(\sub_tick_reg_n_0_[0] ),
        .O(\sub_tick[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT3 #(
    .INIT(8'h6A)) 
    \sub_tick[2]_i_1 
       (.I0(\sub_tick_reg_n_0_[2] ),
        .I1(\sub_tick_reg_n_0_[0] ),
        .I2(\sub_tick_reg_n_0_[1] ),
        .O(\sub_tick[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h5AF0F0B0)) 
    \sub_tick[3]_i_1 
       (.I0(\sub_tick_reg_n_0_[0] ),
        .I1(\sub_tick_reg_n_0_[4] ),
        .I2(\sub_tick_reg_n_0_[3] ),
        .I3(\sub_tick_reg_n_0_[1] ),
        .I4(\sub_tick_reg_n_0_[2] ),
        .O(\sub_tick[3]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hDF)) 
    \sub_tick[4]_i_1 
       (.I0(enable),
        .I1(estop),
        .I2(rst_n),
        .O(\sub_tick[4]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h45)) 
    \sub_tick[4]_i_2 
       (.I0(fault),
        .I1(command_valid),
        .I2(\sub_tick[4]_i_4_n_0 ),
        .O(\sub_tick[4]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT5 #(
    .INIT(32'h7FFD8000)) 
    \sub_tick[4]_i_3 
       (.I0(\sub_tick_reg_n_0_[3] ),
        .I1(\sub_tick_reg_n_0_[1] ),
        .I2(\sub_tick_reg_n_0_[0] ),
        .I3(\sub_tick_reg_n_0_[2] ),
        .I4(\sub_tick_reg_n_0_[4] ),
        .O(\sub_tick[4]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8A88888A88)) 
    \sub_tick[4]_i_4 
       (.I0(age_reg[22]),
        .I1(age_reg[21]),
        .I2(\sub_tick[4]_i_5_n_0 ),
        .I3(age_reg[14]),
        .I4(\sub_tick[4]_i_6_n_0 ),
        .I5(age_reg[15]),
        .O(\sub_tick[4]_i_4_n_0 ));
  LUT5 #(
    .INIT(32'h7FFFFFFF)) 
    \sub_tick[4]_i_5 
       (.I0(age_reg[16]),
        .I1(age_reg[17]),
        .I2(age_reg[19]),
        .I3(age_reg[18]),
        .I4(age_reg[20]),
        .O(\sub_tick[4]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h000000007FFFFFFF)) 
    \sub_tick[4]_i_6 
       (.I0(\sub_tick[4]_i_7_n_0 ),
        .I1(age_reg[9]),
        .I2(age_reg[12]),
        .I3(age_reg[10]),
        .I4(age_reg[11]),
        .I5(age_reg[13]),
        .O(\sub_tick[4]_i_6_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \sub_tick[4]_i_7 
       (.I0(age_reg[7]),
        .I1(age_reg[8]),
        .I2(age_reg[5]),
        .I3(age_reg[4]),
        .I4(age_reg[6]),
        .O(\sub_tick[4]_i_7_n_0 ));
  FDRE \sub_tick_reg[0] 
       (.C(clk),
        .CE(\sub_tick[4]_i_2_n_0 ),
        .D(\sub_tick[0]_i_1_n_0 ),
        .Q(\sub_tick_reg_n_0_[0] ),
        .R(\sub_tick[4]_i_1_n_0 ));
  FDRE \sub_tick_reg[1] 
       (.C(clk),
        .CE(\sub_tick[4]_i_2_n_0 ),
        .D(\sub_tick[1]_i_1_n_0 ),
        .Q(\sub_tick_reg_n_0_[1] ),
        .R(\sub_tick[4]_i_1_n_0 ));
  FDRE \sub_tick_reg[2] 
       (.C(clk),
        .CE(\sub_tick[4]_i_2_n_0 ),
        .D(\sub_tick[2]_i_1_n_0 ),
        .Q(\sub_tick_reg_n_0_[2] ),
        .R(\sub_tick[4]_i_1_n_0 ));
  FDRE \sub_tick_reg[3] 
       (.C(clk),
        .CE(\sub_tick[4]_i_2_n_0 ),
        .D(\sub_tick[3]_i_1_n_0 ),
        .Q(\sub_tick_reg_n_0_[3] ),
        .R(\sub_tick[4]_i_1_n_0 ));
  FDRE \sub_tick_reg[4] 
       (.C(clk),
        .CE(\sub_tick[4]_i_2_n_0 ),
        .D(\sub_tick[4]_i_3_n_0 ),
        .Q(\sub_tick_reg_n_0_[4] ),
        .R(\sub_tick[4]_i_1_n_0 ));
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
