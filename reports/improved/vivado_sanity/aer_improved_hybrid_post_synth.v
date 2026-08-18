// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Wed Aug 19 04:19:15 2026
// Host        : DESKTOP-F81OJT8 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim reports/improved/vivado_sanity/aer_improved_hybrid_post_synth.v
// Design      : aer_improved_hybrid
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* ADDR_W = "4" *) (* IDX_W = "4" *) (* NETLIST_CHECKSUM = "3e281644" *) 
(* NUM_SOURCES = "16" *) 
(* NotValidForBitStream *)
module aer_improved_hybrid
   (clk,
    rst_n,
    src_req_async,
    src_ack_async,
    out_addr,
    out_valid,
    out_ready);
  input clk;
  input rst_n;
  input [15:0]src_req_async;
  output [15:0]src_ack_async;
  output [3:0]out_addr;
  output out_valid;
  input out_ready;

  wire \ack_q[0]_i_1_n_0 ;
  wire \ack_q[10]_i_1_n_0 ;
  wire \ack_q[11]_i_1_n_0 ;
  wire \ack_q[12]_i_1_n_0 ;
  wire \ack_q[13]_i_1_n_0 ;
  wire \ack_q[14]_i_1_n_0 ;
  wire \ack_q[15]_i_1_n_0 ;
  wire \ack_q[1]_i_1_n_0 ;
  wire \ack_q[2]_i_1_n_0 ;
  wire \ack_q[3]_i_1_n_0 ;
  wire \ack_q[4]_i_1_n_0 ;
  wire \ack_q[5]_i_1_n_0 ;
  wire \ack_q[6]_i_1_n_0 ;
  wire \ack_q[7]_i_1_n_0 ;
  wire \ack_q[8]_i_1_n_0 ;
  wire \ack_q[9]_i_1_n_0 ;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire [3:0]out_addr;
  wire [3:0]out_addr_OBUF;
  wire \out_addr_q[0]_i_10_n_0 ;
  wire \out_addr_q[0]_i_11_n_0 ;
  wire \out_addr_q[0]_i_12_n_0 ;
  wire \out_addr_q[0]_i_13_n_0 ;
  wire \out_addr_q[0]_i_14_n_0 ;
  wire \out_addr_q[0]_i_15_n_0 ;
  wire \out_addr_q[0]_i_16_n_0 ;
  wire \out_addr_q[0]_i_17_n_0 ;
  wire \out_addr_q[0]_i_1_n_0 ;
  wire \out_addr_q[0]_i_2_n_0 ;
  wire \out_addr_q[0]_i_3_n_0 ;
  wire \out_addr_q[0]_i_4_n_0 ;
  wire \out_addr_q[0]_i_5_n_0 ;
  wire \out_addr_q[0]_i_6_n_0 ;
  wire \out_addr_q[0]_i_7_n_0 ;
  wire \out_addr_q[0]_i_8_n_0 ;
  wire \out_addr_q[0]_i_9_n_0 ;
  wire \out_addr_q[1]_i_1_n_0 ;
  wire \out_addr_q[2]_i_1_n_0 ;
  wire \out_addr_q[2]_i_2_n_0 ;
  wire \out_addr_q[2]_i_3_n_0 ;
  wire \out_addr_q[2]_i_4_n_0 ;
  wire \out_addr_q[2]_i_5_n_0 ;
  wire \out_addr_q[2]_i_6_n_0 ;
  wire \out_addr_q[2]_i_7_n_0 ;
  wire \out_addr_q[2]_i_8_n_0 ;
  wire \out_addr_q[3]_i_10_n_0 ;
  wire \out_addr_q[3]_i_11_n_0 ;
  wire \out_addr_q[3]_i_12_n_0 ;
  wire \out_addr_q[3]_i_13_n_0 ;
  wire \out_addr_q[3]_i_14_n_0 ;
  wire \out_addr_q[3]_i_15_n_0 ;
  wire \out_addr_q[3]_i_16_n_0 ;
  wire \out_addr_q[3]_i_17_n_0 ;
  wire \out_addr_q[3]_i_18_n_0 ;
  wire \out_addr_q[3]_i_19_n_0 ;
  wire \out_addr_q[3]_i_1_n_0 ;
  wire \out_addr_q[3]_i_20_n_0 ;
  wire \out_addr_q[3]_i_21_n_0 ;
  wire \out_addr_q[3]_i_22_n_0 ;
  wire \out_addr_q[3]_i_23_n_0 ;
  wire \out_addr_q[3]_i_24_n_0 ;
  wire \out_addr_q[3]_i_25_n_0 ;
  wire \out_addr_q[3]_i_26_n_0 ;
  wire \out_addr_q[3]_i_27_n_0 ;
  wire \out_addr_q[3]_i_28_n_0 ;
  wire \out_addr_q[3]_i_29_n_0 ;
  wire \out_addr_q[3]_i_2_n_0 ;
  wire \out_addr_q[3]_i_30_n_0 ;
  wire \out_addr_q[3]_i_31_n_0 ;
  wire \out_addr_q[3]_i_32_n_0 ;
  wire \out_addr_q[3]_i_33_n_0 ;
  wire \out_addr_q[3]_i_34_n_0 ;
  wire \out_addr_q[3]_i_35_n_0 ;
  wire \out_addr_q[3]_i_36_n_0 ;
  wire \out_addr_q[3]_i_37_n_0 ;
  wire \out_addr_q[3]_i_38_n_0 ;
  wire \out_addr_q[3]_i_39_n_0 ;
  wire \out_addr_q[3]_i_3_n_0 ;
  wire \out_addr_q[3]_i_40_n_0 ;
  wire \out_addr_q[3]_i_4_n_0 ;
  wire \out_addr_q[3]_i_5_n_0 ;
  wire \out_addr_q[3]_i_6_n_0 ;
  wire \out_addr_q[3]_i_7_n_0 ;
  wire \out_addr_q[3]_i_8_n_0 ;
  wire \out_addr_q[3]_i_9_n_0 ;
  wire out_ready;
  wire out_ready_IBUF;
  wire out_valid;
  wire out_valid_OBUF;
  wire out_valid_q_i_1_n_0;
  wire [3:0]p_0_in;
  wire [1:0]\queue_count_d[0]__0 ;
  wire [1:0]\queue_count_d[10] ;
  wire [1:0]\queue_count_d[11] ;
  wire [1:0]\queue_count_d[12] ;
  wire [1:0]\queue_count_d[13] ;
  wire [1:0]\queue_count_d[14] ;
  wire [1:0]\queue_count_d[15] ;
  wire [1:0]\queue_count_d[1]__0 ;
  wire [1:0]\queue_count_d[2] ;
  wire [1:0]\queue_count_d[3] ;
  wire [1:0]\queue_count_d[4] ;
  wire [1:0]\queue_count_d[5] ;
  wire [1:0]\queue_count_d[6] ;
  wire [1:0]\queue_count_d[7] ;
  wire [1:0]\queue_count_d[8] ;
  wire [1:0]\queue_count_d[9] ;
  wire \queue_count_q[0][1]_i_2_n_0 ;
  wire \queue_count_q[0][1]_i_3_n_0 ;
  wire \queue_count_q[10][1]_i_2_n_0 ;
  wire \queue_count_q[10][1]_i_3_n_0 ;
  wire \queue_count_q[11][1]_i_2_n_0 ;
  wire \queue_count_q[11][1]_i_3_n_0 ;
  wire \queue_count_q[12][1]_i_2_n_0 ;
  wire \queue_count_q[12][1]_i_3_n_0 ;
  wire \queue_count_q[13][1]_i_2_n_0 ;
  wire \queue_count_q[13][1]_i_3_n_0 ;
  wire \queue_count_q[14][1]_i_2_n_0 ;
  wire \queue_count_q[14][1]_i_3_n_0 ;
  wire \queue_count_q[14][1]_i_4_n_0 ;
  wire \queue_count_q[14][1]_i_5_n_0 ;
  wire \queue_count_q[15][0]_i_2_n_0 ;
  wire \queue_count_q[15][1]_i_10_n_0 ;
  wire \queue_count_q[15][1]_i_11_n_0 ;
  wire \queue_count_q[15][1]_i_12_n_0 ;
  wire \queue_count_q[15][1]_i_13_n_0 ;
  wire \queue_count_q[15][1]_i_14_n_0 ;
  wire \queue_count_q[15][1]_i_15_n_0 ;
  wire \queue_count_q[15][1]_i_16_n_0 ;
  wire \queue_count_q[15][1]_i_17_n_0 ;
  wire \queue_count_q[15][1]_i_18_n_0 ;
  wire \queue_count_q[15][1]_i_19_n_0 ;
  wire \queue_count_q[15][1]_i_20_n_0 ;
  wire \queue_count_q[15][1]_i_21_n_0 ;
  wire \queue_count_q[15][1]_i_22_n_0 ;
  wire \queue_count_q[15][1]_i_23_n_0 ;
  wire \queue_count_q[15][1]_i_24_n_0 ;
  wire \queue_count_q[15][1]_i_25_n_0 ;
  wire \queue_count_q[15][1]_i_26_n_0 ;
  wire \queue_count_q[15][1]_i_27_n_0 ;
  wire \queue_count_q[15][1]_i_28_n_0 ;
  wire \queue_count_q[15][1]_i_29_n_0 ;
  wire \queue_count_q[15][1]_i_2_n_0 ;
  wire \queue_count_q[15][1]_i_30_n_0 ;
  wire \queue_count_q[15][1]_i_31_n_0 ;
  wire \queue_count_q[15][1]_i_32_n_0 ;
  wire \queue_count_q[15][1]_i_33_n_0 ;
  wire \queue_count_q[15][1]_i_34_n_0 ;
  wire \queue_count_q[15][1]_i_35_n_0 ;
  wire \queue_count_q[15][1]_i_36_n_0 ;
  wire \queue_count_q[15][1]_i_37_n_0 ;
  wire \queue_count_q[15][1]_i_38_n_0 ;
  wire \queue_count_q[15][1]_i_39_n_0 ;
  wire \queue_count_q[15][1]_i_3_n_0 ;
  wire \queue_count_q[15][1]_i_40_n_0 ;
  wire \queue_count_q[15][1]_i_41_n_0 ;
  wire \queue_count_q[15][1]_i_43_n_0 ;
  wire \queue_count_q[15][1]_i_44_n_0 ;
  wire \queue_count_q[15][1]_i_45_n_0 ;
  wire \queue_count_q[15][1]_i_46_n_0 ;
  wire \queue_count_q[15][1]_i_47_n_0 ;
  wire \queue_count_q[15][1]_i_48_n_0 ;
  wire \queue_count_q[15][1]_i_49_n_0 ;
  wire \queue_count_q[15][1]_i_4_n_0 ;
  wire \queue_count_q[15][1]_i_50_n_0 ;
  wire \queue_count_q[15][1]_i_51_n_0 ;
  wire \queue_count_q[15][1]_i_52_n_0 ;
  wire \queue_count_q[15][1]_i_53_n_0 ;
  wire \queue_count_q[15][1]_i_54_n_0 ;
  wire \queue_count_q[15][1]_i_55_n_0 ;
  wire \queue_count_q[15][1]_i_56_n_0 ;
  wire \queue_count_q[15][1]_i_57_n_0 ;
  wire \queue_count_q[15][1]_i_58_n_0 ;
  wire \queue_count_q[15][1]_i_59_n_0 ;
  wire \queue_count_q[15][1]_i_5_n_0 ;
  wire \queue_count_q[15][1]_i_60_n_0 ;
  wire \queue_count_q[15][1]_i_61_n_0 ;
  wire \queue_count_q[15][1]_i_62_n_0 ;
  wire \queue_count_q[15][1]_i_63_n_0 ;
  wire \queue_count_q[15][1]_i_64_n_0 ;
  wire \queue_count_q[15][1]_i_65_n_0 ;
  wire \queue_count_q[15][1]_i_66_n_0 ;
  wire \queue_count_q[15][1]_i_67_n_0 ;
  wire \queue_count_q[15][1]_i_68_n_0 ;
  wire \queue_count_q[15][1]_i_69_n_0 ;
  wire \queue_count_q[15][1]_i_6_n_0 ;
  wire \queue_count_q[15][1]_i_70_n_0 ;
  wire \queue_count_q[15][1]_i_71_n_0 ;
  wire \queue_count_q[15][1]_i_72_n_0 ;
  wire \queue_count_q[15][1]_i_73_n_0 ;
  wire \queue_count_q[15][1]_i_74_n_0 ;
  wire \queue_count_q[15][1]_i_75_n_0 ;
  wire \queue_count_q[15][1]_i_76_n_0 ;
  wire \queue_count_q[15][1]_i_77_n_0 ;
  wire \queue_count_q[15][1]_i_78_n_0 ;
  wire \queue_count_q[15][1]_i_79_n_0 ;
  wire \queue_count_q[15][1]_i_7_n_0 ;
  wire \queue_count_q[15][1]_i_80_n_0 ;
  wire \queue_count_q[15][1]_i_81_n_0 ;
  wire \queue_count_q[15][1]_i_82_n_0 ;
  wire \queue_count_q[15][1]_i_83_n_0 ;
  wire \queue_count_q[15][1]_i_84_n_0 ;
  wire \queue_count_q[15][1]_i_85_n_0 ;
  wire \queue_count_q[15][1]_i_8_n_0 ;
  wire \queue_count_q[15][1]_i_9_n_0 ;
  wire \queue_count_q[1][1]_i_2_n_0 ;
  wire \queue_count_q[1][1]_i_3_n_0 ;
  wire \queue_count_q[2][1]_i_2_n_0 ;
  wire \queue_count_q[2][1]_i_3_n_0 ;
  wire \queue_count_q[3][1]_i_2_n_0 ;
  wire \queue_count_q[3][1]_i_3_n_0 ;
  wire \queue_count_q[4][1]_i_2_n_0 ;
  wire \queue_count_q[4][1]_i_3_n_0 ;
  wire \queue_count_q[5][1]_i_2_n_0 ;
  wire \queue_count_q[5][1]_i_3_n_0 ;
  wire \queue_count_q[6][1]_i_2_n_0 ;
  wire \queue_count_q[6][1]_i_3_n_0 ;
  wire \queue_count_q[7][1]_i_2_n_0 ;
  wire \queue_count_q[7][1]_i_3_n_0 ;
  wire \queue_count_q[8][1]_i_2_n_0 ;
  wire \queue_count_q[8][1]_i_3_n_0 ;
  wire \queue_count_q[9][1]_i_2_n_0 ;
  wire \queue_count_q[9][1]_i_3_n_0 ;
  wire \queue_count_q_reg[15][1]_i_42_n_0 ;
  wire \queue_count_q_reg_n_0_[0][0] ;
  wire \queue_count_q_reg_n_0_[0][1] ;
  wire \queue_count_q_reg_n_0_[10][0] ;
  wire \queue_count_q_reg_n_0_[10][1] ;
  wire \queue_count_q_reg_n_0_[11][0] ;
  wire \queue_count_q_reg_n_0_[11][1] ;
  wire \queue_count_q_reg_n_0_[12][0] ;
  wire \queue_count_q_reg_n_0_[12][1] ;
  wire \queue_count_q_reg_n_0_[13][0] ;
  wire \queue_count_q_reg_n_0_[13][1] ;
  wire \queue_count_q_reg_n_0_[14][0] ;
  wire \queue_count_q_reg_n_0_[14][1] ;
  wire \queue_count_q_reg_n_0_[15][0] ;
  wire \queue_count_q_reg_n_0_[15][1] ;
  wire \queue_count_q_reg_n_0_[1][0] ;
  wire \queue_count_q_reg_n_0_[1][1] ;
  wire \queue_count_q_reg_n_0_[2][0] ;
  wire \queue_count_q_reg_n_0_[2][1] ;
  wire \queue_count_q_reg_n_0_[3][0] ;
  wire \queue_count_q_reg_n_0_[3][1] ;
  wire \queue_count_q_reg_n_0_[4][0] ;
  wire \queue_count_q_reg_n_0_[4][1] ;
  wire \queue_count_q_reg_n_0_[5][0] ;
  wire \queue_count_q_reg_n_0_[5][1] ;
  wire \queue_count_q_reg_n_0_[6][0] ;
  wire \queue_count_q_reg_n_0_[6][1] ;
  wire \queue_count_q_reg_n_0_[7][0] ;
  wire \queue_count_q_reg_n_0_[7][1] ;
  wire \queue_count_q_reg_n_0_[8][0] ;
  wire \queue_count_q_reg_n_0_[8][1] ;
  wire \queue_count_q_reg_n_0_[9][0] ;
  wire \queue_count_q_reg_n_0_[9][1] ;
  (* async_reg = "true" *) wire [15:0]req_meta_q;
  wire \req_meta_q[15]_i_1_n_0 ;
  (* async_reg = "true" *) wire [15:0]req_sync_q;
  wire [3:0]rr_ptr_q;
  wire \rr_ptr_q[1]_i_1_n_0 ;
  wire \rr_ptr_q[2]_i_1_n_0 ;
  wire \rr_ptr_q[3]_i_1_n_0 ;
  wire \rr_ptr_q[3]_i_4_n_0 ;
  wire \rr_ptr_q[3]_i_5_n_0 ;
  wire \rr_ptr_q[3]_i_6_n_0 ;
  wire \rr_ptr_q[3]_i_7_n_0 ;
  wire \rr_ptr_q[3]_i_8_n_0 ;
  wire rst_n;
  wire rst_n_IBUF;
  wire [15:0]src_ack_async;
  wire [15:0]src_ack_async_OBUF;
  wire [15:0]src_req_async;
  wire [15:0]src_req_async_IBUF;

  LUT3 #(
    .INIT(8'hC4)) 
    \ack_q[0]_i_1 
       (.I0(\queue_count_q_reg_n_0_[0][1] ),
        .I1(req_sync_q[0]),
        .I2(src_ack_async_OBUF[0]),
        .O(\ack_q[0]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hD0)) 
    \ack_q[10]_i_1 
       (.I0(\queue_count_q_reg_n_0_[10][1] ),
        .I1(src_ack_async_OBUF[10]),
        .I2(req_sync_q[10]),
        .O(\ack_q[10]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hD0)) 
    \ack_q[11]_i_1 
       (.I0(\queue_count_q_reg_n_0_[11][1] ),
        .I1(src_ack_async_OBUF[11]),
        .I2(req_sync_q[11]),
        .O(\ack_q[11]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hD0)) 
    \ack_q[12]_i_1 
       (.I0(\queue_count_q_reg_n_0_[12][1] ),
        .I1(src_ack_async_OBUF[12]),
        .I2(req_sync_q[12]),
        .O(\ack_q[12]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hD0)) 
    \ack_q[13]_i_1 
       (.I0(\queue_count_q_reg_n_0_[13][1] ),
        .I1(src_ack_async_OBUF[13]),
        .I2(req_sync_q[13]),
        .O(\ack_q[13]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hD0)) 
    \ack_q[14]_i_1 
       (.I0(\queue_count_q_reg_n_0_[14][1] ),
        .I1(src_ack_async_OBUF[14]),
        .I2(req_sync_q[14]),
        .O(\ack_q[14]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hD0)) 
    \ack_q[15]_i_1 
       (.I0(\queue_count_q_reg_n_0_[15][1] ),
        .I1(src_ack_async_OBUF[15]),
        .I2(req_sync_q[15]),
        .O(\ack_q[15]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hD0)) 
    \ack_q[1]_i_1 
       (.I0(\queue_count_q_reg_n_0_[1][1] ),
        .I1(src_ack_async_OBUF[1]),
        .I2(req_sync_q[1]),
        .O(\ack_q[1]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hD0)) 
    \ack_q[2]_i_1 
       (.I0(\queue_count_q_reg_n_0_[2][1] ),
        .I1(src_ack_async_OBUF[2]),
        .I2(req_sync_q[2]),
        .O(\ack_q[2]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hD0)) 
    \ack_q[3]_i_1 
       (.I0(\queue_count_q_reg_n_0_[3][1] ),
        .I1(src_ack_async_OBUF[3]),
        .I2(req_sync_q[3]),
        .O(\ack_q[3]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hD0)) 
    \ack_q[4]_i_1 
       (.I0(\queue_count_q_reg_n_0_[4][1] ),
        .I1(src_ack_async_OBUF[4]),
        .I2(req_sync_q[4]),
        .O(\ack_q[4]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hD0)) 
    \ack_q[5]_i_1 
       (.I0(\queue_count_q_reg_n_0_[5][1] ),
        .I1(src_ack_async_OBUF[5]),
        .I2(req_sync_q[5]),
        .O(\ack_q[5]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hD0)) 
    \ack_q[6]_i_1 
       (.I0(\queue_count_q_reg_n_0_[6][1] ),
        .I1(src_ack_async_OBUF[6]),
        .I2(req_sync_q[6]),
        .O(\ack_q[6]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hD0)) 
    \ack_q[7]_i_1 
       (.I0(\queue_count_q_reg_n_0_[7][1] ),
        .I1(src_ack_async_OBUF[7]),
        .I2(req_sync_q[7]),
        .O(\ack_q[7]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hD0)) 
    \ack_q[8]_i_1 
       (.I0(\queue_count_q_reg_n_0_[8][1] ),
        .I1(src_ack_async_OBUF[8]),
        .I2(req_sync_q[8]),
        .O(\ack_q[8]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hD0)) 
    \ack_q[9]_i_1 
       (.I0(\queue_count_q_reg_n_0_[9][1] ),
        .I1(src_ack_async_OBUF[9]),
        .I2(req_sync_q[9]),
        .O(\ack_q[9]_i_1_n_0 ));
  FDCE \ack_q_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\ack_q[0]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[0]));
  FDCE \ack_q_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\ack_q[10]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[10]));
  FDCE \ack_q_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\ack_q[11]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[11]));
  FDCE \ack_q_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\ack_q[12]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[12]));
  FDCE \ack_q_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\ack_q[13]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[13]));
  FDCE \ack_q_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\ack_q[14]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[14]));
  FDCE \ack_q_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\ack_q[15]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[15]));
  FDCE \ack_q_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\ack_q[1]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[1]));
  FDCE \ack_q_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\ack_q[2]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[2]));
  FDCE \ack_q_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\ack_q[3]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[3]));
  FDCE \ack_q_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\ack_q[4]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[4]));
  FDCE \ack_q_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\ack_q[5]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[5]));
  FDCE \ack_q_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\ack_q[6]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[6]));
  FDCE \ack_q_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\ack_q[7]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[7]));
  FDCE \ack_q_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\ack_q[8]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[8]));
  FDCE \ack_q_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\ack_q[9]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[9]));
  BUFG clk_IBUF_BUFG_inst
       (.I(clk_IBUF),
        .O(clk_IBUF_BUFG));
  IBUF clk_IBUF_inst
       (.I(clk),
        .O(clk_IBUF));
  OBUF \out_addr_OBUF[0]_inst 
       (.I(out_addr_OBUF[0]),
        .O(out_addr[0]));
  OBUF \out_addr_OBUF[1]_inst 
       (.I(out_addr_OBUF[1]),
        .O(out_addr[1]));
  OBUF \out_addr_OBUF[2]_inst 
       (.I(out_addr_OBUF[2]),
        .O(out_addr[2]));
  OBUF \out_addr_OBUF[3]_inst 
       (.I(out_addr_OBUF[3]),
        .O(out_addr[3]));
  LUT6 #(
    .INIT(64'hCCDDEEFFCFDDEEFF)) 
    \out_addr_q[0]_i_1 
       (.I0(rr_ptr_q[0]),
        .I1(\out_addr_q[0]_i_2_n_0 ),
        .I2(\out_addr_q[0]_i_3_n_0 ),
        .I3(\out_addr_q[0]_i_4_n_0 ),
        .I4(\out_addr_q[0]_i_5_n_0 ),
        .I5(\out_addr_q[0]_i_6_n_0 ),
        .O(\out_addr_q[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \out_addr_q[0]_i_10 
       (.I0(\out_addr_q[3]_i_36_n_0 ),
        .I1(\out_addr_q[3]_i_34_n_0 ),
        .I2(\out_addr_q[3]_i_31_n_0 ),
        .O(\out_addr_q[0]_i_10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT4 #(
    .INIT(16'h7F3F)) 
    \out_addr_q[0]_i_11 
       (.I0(\queue_count_q[15][1]_i_37_n_0 ),
        .I1(\queue_count_q[15][1]_i_40_n_0 ),
        .I2(\queue_count_q[15][1]_i_39_n_0 ),
        .I3(\queue_count_q[15][1]_i_38_n_0 ),
        .O(\out_addr_q[0]_i_11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT4 #(
    .INIT(16'hBFFF)) 
    \out_addr_q[0]_i_12 
       (.I0(\queue_count_q[15][1]_i_37_n_0 ),
        .I1(\queue_count_q[15][1]_i_38_n_0 ),
        .I2(\queue_count_q[15][1]_i_39_n_0 ),
        .I3(\queue_count_q[15][1]_i_40_n_0 ),
        .O(\out_addr_q[0]_i_12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT5 #(
    .INIT(32'hCAACACAC)) 
    \out_addr_q[0]_i_13 
       (.I0(\out_addr_q[0]_i_16_n_0 ),
        .I1(\out_addr_q[0]_i_17_n_0 ),
        .I2(rr_ptr_q[3]),
        .I3(rr_ptr_q[2]),
        .I4(rr_ptr_q[1]),
        .O(\out_addr_q[0]_i_13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT5 #(
    .INIT(32'hFFFACCFA)) 
    \out_addr_q[0]_i_14 
       (.I0(\queue_count_q[15][1]_i_83_n_0 ),
        .I1(\queue_count_q[15][1]_i_82_n_0 ),
        .I2(\queue_count_q[15][1]_i_85_n_0 ),
        .I3(\queue_count_q[15][1]_i_80_n_0 ),
        .I4(\queue_count_q[15][1]_i_84_n_0 ),
        .O(\out_addr_q[0]_i_14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT5 #(
    .INIT(32'hFFFACCFA)) 
    \out_addr_q[0]_i_15 
       (.I0(\queue_count_q[15][1]_i_78_n_0 ),
        .I1(\queue_count_q[15][1]_i_77_n_0 ),
        .I2(\queue_count_q[15][1]_i_81_n_0 ),
        .I3(\queue_count_q[15][1]_i_80_n_0 ),
        .I4(\queue_count_q[15][1]_i_79_n_0 ),
        .O(\out_addr_q[0]_i_15_n_0 ));
  LUT6 #(
    .INIT(64'h0500000505333305)) 
    \out_addr_q[0]_i_16 
       (.I0(\queue_count_q[15][1]_i_74_n_0 ),
        .I1(\queue_count_q[15][1]_i_73_n_0 ),
        .I2(\queue_count_q[15][1]_i_76_n_0 ),
        .I3(rr_ptr_q[2]),
        .I4(rr_ptr_q[1]),
        .I5(\queue_count_q[15][1]_i_75_n_0 ),
        .O(\out_addr_q[0]_i_16_n_0 ));
  LUT6 #(
    .INIT(64'h0500000505333305)) 
    \out_addr_q[0]_i_17 
       (.I0(\queue_count_q[15][1]_i_70_n_0 ),
        .I1(\queue_count_q[15][1]_i_69_n_0 ),
        .I2(\queue_count_q[15][1]_i_72_n_0 ),
        .I3(rr_ptr_q[2]),
        .I4(rr_ptr_q[1]),
        .I5(\queue_count_q[15][1]_i_71_n_0 ),
        .O(\out_addr_q[0]_i_17_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF10231003)) 
    \out_addr_q[0]_i_2 
       (.I0(\queue_count_q[15][1]_i_17_n_0 ),
        .I1(\out_addr_q[0]_i_7_n_0 ),
        .I2(\out_addr_q[0]_i_8_n_0 ),
        .I3(rr_ptr_q[0]),
        .I4(\queue_count_q[15][1]_i_18_n_0 ),
        .I5(\out_addr_q[0]_i_9_n_0 ),
        .O(\out_addr_q[0]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h5555555400000003)) 
    \out_addr_q[0]_i_3 
       (.I0(\out_addr_q[3]_i_25_n_0 ),
        .I1(\out_addr_q[3]_i_22_n_0 ),
        .I2(\out_addr_q[0]_i_10_n_0 ),
        .I3(\out_addr_q[3]_i_24_n_0 ),
        .I4(\out_addr_q[3]_i_27_n_0 ),
        .I5(rr_ptr_q[0]),
        .O(\out_addr_q[0]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT5 #(
    .INIT(32'hFFFFDFFF)) 
    \out_addr_q[0]_i_4 
       (.I0(\queue_count_q[15][1]_i_19_n_0 ),
        .I1(\queue_count_q[15][1]_i_18_n_0 ),
        .I2(\queue_count_q[15][1]_i_17_n_0 ),
        .I3(\queue_count_q[15][1]_i_16_n_0 ),
        .I4(\queue_count_q[15][1]_i_20_n_0 ),
        .O(\out_addr_q[0]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT4 #(
    .INIT(16'hFFF7)) 
    \out_addr_q[0]_i_5 
       (.I0(\queue_count_q[15][1]_i_16_n_0 ),
        .I1(\queue_count_q[15][1]_i_17_n_0 ),
        .I2(\queue_count_q[15][1]_i_18_n_0 ),
        .I3(\queue_count_q[15][1]_i_19_n_0 ),
        .O(\out_addr_q[0]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h00FFF7FF00FFFFFF)) 
    \out_addr_q[0]_i_6 
       (.I0(\queue_count_q[15][1]_i_17_n_0 ),
        .I1(\out_addr_q[0]_i_8_n_0 ),
        .I2(\queue_count_q[15][1]_i_18_n_0 ),
        .I3(\out_addr_q[0]_i_11_n_0 ),
        .I4(\out_addr_q[0]_i_12_n_0 ),
        .I5(\out_addr_q[0]_i_13_n_0 ),
        .O(\out_addr_q[0]_i_6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'hFF7FFFFF)) 
    \out_addr_q[0]_i_7 
       (.I0(\queue_count_q[15][1]_i_40_n_0 ),
        .I1(\queue_count_q[15][1]_i_39_n_0 ),
        .I2(\queue_count_q[15][1]_i_38_n_0 ),
        .I3(\queue_count_q[15][1]_i_37_n_0 ),
        .I4(\out_addr_q[0]_i_13_n_0 ),
        .O(\out_addr_q[0]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h11144444DDD77777)) 
    \out_addr_q[0]_i_8 
       (.I0(\out_addr_q[0]_i_14_n_0 ),
        .I1(rr_ptr_q[3]),
        .I2(rr_ptr_q[0]),
        .I3(rr_ptr_q[1]),
        .I4(rr_ptr_q[2]),
        .I5(\out_addr_q[0]_i_15_n_0 ),
        .O(\out_addr_q[0]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'h1000F000C0000000)) 
    \out_addr_q[0]_i_9 
       (.I0(\out_addr_q[0]_i_13_n_0 ),
        .I1(\queue_count_q[15][1]_i_37_n_0 ),
        .I2(\queue_count_q[15][1]_i_40_n_0 ),
        .I3(\queue_count_q[15][1]_i_39_n_0 ),
        .I4(\queue_count_q[15][1]_i_38_n_0 ),
        .I5(rr_ptr_q[0]),
        .O(\out_addr_q[0]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFDFFFDFDFDFD)) 
    \out_addr_q[2]_i_1 
       (.I0(\out_addr_q[2]_i_2_n_0 ),
        .I1(\out_addr_q[2]_i_3_n_0 ),
        .I2(\out_addr_q[2]_i_4_n_0 ),
        .I3(\out_addr_q[2]_i_5_n_0 ),
        .I4(\out_addr_q[2]_i_6_n_0 ),
        .I5(\out_addr_q[3]_i_7_n_0 ),
        .O(\out_addr_q[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'hA0BBFFE0)) 
    \out_addr_q[2]_i_2 
       (.I0(\out_addr_q[0]_i_4_n_0 ),
        .I1(rr_ptr_q[0]),
        .I2(\out_addr_q[0]_i_5_n_0 ),
        .I3(rr_ptr_q[1]),
        .I4(rr_ptr_q[2]),
        .O(\out_addr_q[2]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0FDD00DF00DF55CF)) 
    \out_addr_q[2]_i_3 
       (.I0(\out_addr_q[3]_i_9_n_0 ),
        .I1(\out_addr_q[3]_i_11_n_0 ),
        .I2(\out_addr_q[3]_i_12_n_0 ),
        .I3(rr_ptr_q[2]),
        .I4(rr_ptr_q[1]),
        .I5(rr_ptr_q[0]),
        .O(\out_addr_q[2]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFD5000CDDD500)) 
    \out_addr_q[2]_i_4 
       (.I0(\out_addr_q[3]_i_14_n_0 ),
        .I1(\out_addr_q[3]_i_17_n_0 ),
        .I2(rr_ptr_q[0]),
        .I3(rr_ptr_q[1]),
        .I4(rr_ptr_q[2]),
        .I5(\out_addr_q[3]_i_16_n_0 ),
        .O(\out_addr_q[2]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h55DF555555DF55DF)) 
    \out_addr_q[2]_i_5 
       (.I0(\out_addr_q[3]_i_19_n_0 ),
        .I1(\out_addr_q[2]_i_7_n_0 ),
        .I2(\out_addr_q[3]_i_22_n_0 ),
        .I3(\out_addr_q[2]_i_8_n_0 ),
        .I4(\out_addr_q[3]_i_21_n_0 ),
        .I5(rr_ptr_q[2]),
        .O(\out_addr_q[2]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hF0AFFC0FE0ACAC0E)) 
    \out_addr_q[2]_i_6 
       (.I0(\out_addr_q[3]_i_24_n_0 ),
        .I1(\out_addr_q[3]_i_27_n_0 ),
        .I2(rr_ptr_q[2]),
        .I3(rr_ptr_q[1]),
        .I4(rr_ptr_q[0]),
        .I5(\out_addr_q[3]_i_25_n_0 ),
        .O(\out_addr_q[2]_i_6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT3 #(
    .INIT(8'h95)) 
    \out_addr_q[2]_i_7 
       (.I0(rr_ptr_q[2]),
        .I1(rr_ptr_q[1]),
        .I2(rr_ptr_q[0]),
        .O(\out_addr_q[2]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h0FCF0ECA0FFA0ECA)) 
    \out_addr_q[2]_i_8 
       (.I0(\out_addr_q[3]_i_29_n_0 ),
        .I1(\out_addr_q[3]_i_30_n_0 ),
        .I2(rr_ptr_q[2]),
        .I3(rr_ptr_q[1]),
        .I4(\out_addr_q[0]_i_10_n_0 ),
        .I5(rr_ptr_q[0]),
        .O(\out_addr_q[2]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFDFDFDFDFD)) 
    \out_addr_q[3]_i_1 
       (.I0(\out_addr_q[3]_i_2_n_0 ),
        .I1(\out_addr_q[3]_i_3_n_0 ),
        .I2(\out_addr_q[3]_i_4_n_0 ),
        .I3(\out_addr_q[3]_i_5_n_0 ),
        .I4(\out_addr_q[3]_i_6_n_0 ),
        .I5(\out_addr_q[3]_i_7_n_0 ),
        .O(\out_addr_q[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT2 #(
    .INIT(4'h9)) 
    \out_addr_q[3]_i_10 
       (.I0(rr_ptr_q[3]),
        .I1(rr_ptr_q[2]),
        .O(\out_addr_q[3]_i_10_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \out_addr_q[3]_i_11 
       (.I0(\queue_count_q[15][1]_i_16_n_0 ),
        .I1(\queue_count_q[15][1]_i_17_n_0 ),
        .O(\out_addr_q[3]_i_11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT3 #(
    .INIT(8'h7F)) 
    \out_addr_q[3]_i_12 
       (.I0(\queue_count_q[15][1]_i_17_n_0 ),
        .I1(\queue_count_q[15][1]_i_16_n_0 ),
        .I2(\queue_count_q[15][1]_i_18_n_0 ),
        .O(\out_addr_q[3]_i_12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT4 #(
    .INIT(16'hAA95)) 
    \out_addr_q[3]_i_13 
       (.I0(rr_ptr_q[3]),
        .I1(rr_ptr_q[0]),
        .I2(rr_ptr_q[1]),
        .I3(rr_ptr_q[2]),
        .O(\out_addr_q[3]_i_13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'hFFFFFF7F)) 
    \out_addr_q[3]_i_14 
       (.I0(\queue_count_q[15][1]_i_40_n_0 ),
        .I1(\queue_count_q[15][1]_i_39_n_0 ),
        .I2(\queue_count_q[15][1]_i_38_n_0 ),
        .I3(\queue_count_q[15][1]_i_37_n_0 ),
        .I4(\out_addr_q[0]_i_13_n_0 ),
        .O(\out_addr_q[3]_i_14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT3 #(
    .INIT(8'h95)) 
    \out_addr_q[3]_i_15 
       (.I0(rr_ptr_q[3]),
        .I1(rr_ptr_q[2]),
        .I2(rr_ptr_q[1]),
        .O(\out_addr_q[3]_i_15_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \out_addr_q[3]_i_16 
       (.I0(\queue_count_q[15][1]_i_40_n_0 ),
        .I1(\queue_count_q[15][1]_i_39_n_0 ),
        .I2(\queue_count_q[15][1]_i_38_n_0 ),
        .O(\out_addr_q[3]_i_16_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT4 #(
    .INIT(16'h8000)) 
    \out_addr_q[3]_i_17 
       (.I0(\queue_count_q[15][1]_i_38_n_0 ),
        .I1(\queue_count_q[15][1]_i_39_n_0 ),
        .I2(\queue_count_q[15][1]_i_40_n_0 ),
        .I3(\queue_count_q[15][1]_i_37_n_0 ),
        .O(\out_addr_q[3]_i_17_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT4 #(
    .INIT(16'h6AAA)) 
    \out_addr_q[3]_i_18 
       (.I0(rr_ptr_q[3]),
        .I1(rr_ptr_q[0]),
        .I2(rr_ptr_q[1]),
        .I3(rr_ptr_q[2]),
        .O(\out_addr_q[3]_i_18_n_0 ));
  LUT3 #(
    .INIT(8'h01)) 
    \out_addr_q[3]_i_19 
       (.I0(\out_addr_q[3]_i_24_n_0 ),
        .I1(\out_addr_q[3]_i_27_n_0 ),
        .I2(\out_addr_q[3]_i_25_n_0 ),
        .O(\out_addr_q[3]_i_19_n_0 ));
  LUT6 #(
    .INIT(64'hC0FFC0FFC0FFDDE0)) 
    \out_addr_q[3]_i_2 
       (.I0(rr_ptr_q[0]),
        .I1(\out_addr_q[0]_i_4_n_0 ),
        .I2(\out_addr_q[0]_i_5_n_0 ),
        .I3(rr_ptr_q[3]),
        .I4(rr_ptr_q[2]),
        .I5(rr_ptr_q[1]),
        .O(\out_addr_q[3]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h44F444F4FFFF44F4)) 
    \out_addr_q[3]_i_20 
       (.I0(\out_addr_q[3]_i_10_n_0 ),
        .I1(\out_addr_q[3]_i_29_n_0 ),
        .I2(\out_addr_q[0]_i_10_n_0 ),
        .I3(\out_addr_q[3]_i_8_n_0 ),
        .I4(\out_addr_q[3]_i_30_n_0 ),
        .I5(\out_addr_q[3]_i_15_n_0 ),
        .O(\out_addr_q[3]_i_20_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT5 #(
    .INIT(32'hF0F0E0F0)) 
    \out_addr_q[3]_i_21 
       (.I0(\out_addr_q[3]_i_31_n_0 ),
        .I1(\out_addr_q[3]_i_32_n_0 ),
        .I2(\out_addr_q[3]_i_33_n_0 ),
        .I3(\out_addr_q[3]_i_34_n_0 ),
        .I4(\out_addr_q[3]_i_35_n_0 ),
        .O(\out_addr_q[3]_i_21_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \out_addr_q[3]_i_22 
       (.I0(\out_addr_q[3]_i_33_n_0 ),
        .I1(\out_addr_q[3]_i_32_n_0 ),
        .O(\out_addr_q[3]_i_22_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT4 #(
    .INIT(16'hAAA9)) 
    \out_addr_q[3]_i_23 
       (.I0(rr_ptr_q[3]),
        .I1(rr_ptr_q[0]),
        .I2(rr_ptr_q[1]),
        .I3(rr_ptr_q[2]),
        .O(\out_addr_q[3]_i_23_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \out_addr_q[3]_i_24 
       (.I0(\queue_count_q[15][1]_i_39_n_0 ),
        .I1(\queue_count_q[15][1]_i_40_n_0 ),
        .O(\out_addr_q[3]_i_24_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000040)) 
    \out_addr_q[3]_i_25 
       (.I0(\out_addr_q[3]_i_35_n_0 ),
        .I1(\out_addr_q[3]_i_34_n_0 ),
        .I2(\out_addr_q[3]_i_36_n_0 ),
        .I3(\out_addr_q[3]_i_31_n_0 ),
        .I4(\out_addr_q[3]_i_37_n_0 ),
        .I5(\out_addr_q[3]_i_38_n_0 ),
        .O(\out_addr_q[3]_i_25_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT3 #(
    .INIT(8'hA9)) 
    \out_addr_q[3]_i_26 
       (.I0(rr_ptr_q[3]),
        .I1(rr_ptr_q[2]),
        .I2(rr_ptr_q[1]),
        .O(\out_addr_q[3]_i_26_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT5 #(
    .INIT(32'h00400000)) 
    \out_addr_q[3]_i_27 
       (.I0(\out_addr_q[3]_i_31_n_0 ),
        .I1(\out_addr_q[3]_i_36_n_0 ),
        .I2(\out_addr_q[3]_i_34_n_0 ),
        .I3(\out_addr_q[3]_i_35_n_0 ),
        .I4(\out_addr_q[3]_i_37_n_0 ),
        .O(\out_addr_q[3]_i_27_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'hFD)) 
    \out_addr_q[3]_i_28 
       (.I0(\out_addr_q[3]_i_14_n_0 ),
        .I1(\out_addr_q[3]_i_17_n_0 ),
        .I2(\out_addr_q[3]_i_16_n_0 ),
        .O(\out_addr_q[3]_i_28_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT4 #(
    .INIT(16'h0800)) 
    \out_addr_q[3]_i_29 
       (.I0(\out_addr_q[3]_i_34_n_0 ),
        .I1(\out_addr_q[3]_i_36_n_0 ),
        .I2(\out_addr_q[3]_i_31_n_0 ),
        .I3(\out_addr_q[3]_i_35_n_0 ),
        .O(\out_addr_q[3]_i_29_n_0 ));
  LUT6 #(
    .INIT(64'hF222FFFFF222F222)) 
    \out_addr_q[3]_i_3 
       (.I0(\out_addr_q[3]_i_8_n_0 ),
        .I1(\out_addr_q[3]_i_9_n_0 ),
        .I2(\out_addr_q[3]_i_10_n_0 ),
        .I3(\out_addr_q[3]_i_11_n_0 ),
        .I4(\out_addr_q[3]_i_12_n_0 ),
        .I5(\out_addr_q[3]_i_13_n_0 ),
        .O(\out_addr_q[3]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \out_addr_q[3]_i_30 
       (.I0(\out_addr_q[3]_i_36_n_0 ),
        .I1(\out_addr_q[3]_i_34_n_0 ),
        .O(\out_addr_q[3]_i_30_n_0 ));
  LUT6 #(
    .INIT(64'hBBBEEEEE88822222)) 
    \out_addr_q[3]_i_31 
       (.I0(\out_addr_q[0]_i_14_n_0 ),
        .I1(rr_ptr_q[3]),
        .I2(rr_ptr_q[0]),
        .I3(rr_ptr_q[1]),
        .I4(rr_ptr_q[2]),
        .I5(\out_addr_q[0]_i_15_n_0 ),
        .O(\out_addr_q[3]_i_31_n_0 ));
  LUT6 #(
    .INIT(64'hEBBBBBBB28888888)) 
    \out_addr_q[3]_i_32 
       (.I0(\queue_count_q[15][1]_i_51_n_0 ),
        .I1(rr_ptr_q[3]),
        .I2(rr_ptr_q[0]),
        .I3(rr_ptr_q[1]),
        .I4(rr_ptr_q[2]),
        .I5(\queue_count_q[15][1]_i_50_n_0 ),
        .O(\out_addr_q[3]_i_32_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT5 #(
    .INIT(32'hB8FFB800)) 
    \out_addr_q[3]_i_33 
       (.I0(\queue_count_q_reg[15][1]_i_42_n_0 ),
        .I1(rr_ptr_q[2]),
        .I2(\queue_count_q[15][1]_i_41_n_0 ),
        .I3(rr_ptr_q[3]),
        .I4(\queue_count_q[15][1]_i_52_n_0 ),
        .O(\out_addr_q[3]_i_33_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT5 #(
    .INIT(32'hBEEE8222)) 
    \out_addr_q[3]_i_34 
       (.I0(\out_addr_q[0]_i_16_n_0 ),
        .I1(rr_ptr_q[3]),
        .I2(rr_ptr_q[2]),
        .I3(rr_ptr_q[1]),
        .I4(\out_addr_q[0]_i_17_n_0 ),
        .O(\out_addr_q[3]_i_34_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT5 #(
    .INIT(32'h82B28EBE)) 
    \out_addr_q[3]_i_35 
       (.I0(\queue_count_q[15][1]_i_43_n_0 ),
        .I1(rr_ptr_q[3]),
        .I2(rr_ptr_q[2]),
        .I3(\queue_count_q[15][1]_i_41_n_0 ),
        .I4(\queue_count_q_reg[15][1]_i_42_n_0 ),
        .O(\out_addr_q[3]_i_35_n_0 ));
  LUT6 #(
    .INIT(64'h000000E2E2E200E2)) 
    \out_addr_q[3]_i_36 
       (.I0(\queue_count_q[15][1]_i_52_n_0 ),
        .I1(rr_ptr_q[3]),
        .I2(\out_addr_q[3]_i_39_n_0 ),
        .I3(\queue_count_q[15][1]_i_50_n_0 ),
        .I4(\out_addr_q[3]_i_18_n_0 ),
        .I5(\queue_count_q[15][1]_i_51_n_0 ),
        .O(\out_addr_q[3]_i_36_n_0 ));
  LUT6 #(
    .INIT(64'hBBBBBEEE88888222)) 
    \out_addr_q[3]_i_37 
       (.I0(\queue_count_q[15][1]_i_45_n_0 ),
        .I1(rr_ptr_q[3]),
        .I2(rr_ptr_q[0]),
        .I3(rr_ptr_q[1]),
        .I4(rr_ptr_q[2]),
        .I5(\queue_count_q[15][1]_i_44_n_0 ),
        .O(\out_addr_q[3]_i_37_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT5 #(
    .INIT(32'hBBBE8882)) 
    \out_addr_q[3]_i_38 
       (.I0(\queue_count_q[15][1]_i_47_n_0 ),
        .I1(rr_ptr_q[3]),
        .I2(rr_ptr_q[2]),
        .I3(rr_ptr_q[1]),
        .I4(\queue_count_q[15][1]_i_46_n_0 ),
        .O(\out_addr_q[3]_i_38_n_0 ));
  LUT6 #(
    .INIT(64'hB800B800B800B8FF)) 
    \out_addr_q[3]_i_39 
       (.I0(\queue_count_q[15][1]_i_56_n_0 ),
        .I1(rr_ptr_q[1]),
        .I2(\queue_count_q[15][1]_i_55_n_0 ),
        .I3(rr_ptr_q[2]),
        .I4(\out_addr_q[3]_i_40_n_0 ),
        .I5(\queue_count_q[15][1]_i_54_n_0 ),
        .O(\out_addr_q[3]_i_39_n_0 ));
  LUT6 #(
    .INIT(64'h44F444F4FFFF44F4)) 
    \out_addr_q[3]_i_4 
       (.I0(\out_addr_q[3]_i_14_n_0 ),
        .I1(\out_addr_q[3]_i_15_n_0 ),
        .I2(\out_addr_q[3]_i_16_n_0 ),
        .I3(rr_ptr_q[3]),
        .I4(\out_addr_q[3]_i_17_n_0 ),
        .I5(\out_addr_q[3]_i_18_n_0 ),
        .O(\out_addr_q[3]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \out_addr_q[3]_i_40 
       (.I0(\queue_count_q_reg_n_0_[11][0] ),
        .I1(\queue_count_q_reg_n_0_[10][0] ),
        .I2(rr_ptr_q[1]),
        .I3(\queue_count_q_reg_n_0_[9][0] ),
        .I4(rr_ptr_q[0]),
        .I5(\queue_count_q_reg_n_0_[8][0] ),
        .O(\out_addr_q[3]_i_40_n_0 ));
  LUT6 #(
    .INIT(64'hAAAA8A888A888A88)) 
    \out_addr_q[3]_i_5 
       (.I0(\out_addr_q[3]_i_19_n_0 ),
        .I1(\out_addr_q[3]_i_20_n_0 ),
        .I2(\out_addr_q[3]_i_21_n_0 ),
        .I3(rr_ptr_q[3]),
        .I4(\out_addr_q[3]_i_18_n_0 ),
        .I5(\out_addr_q[3]_i_22_n_0 ),
        .O(\out_addr_q[3]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h44F444F4FFFF44F4)) 
    \out_addr_q[3]_i_6 
       (.I0(\out_addr_q[3]_i_23_n_0 ),
        .I1(\out_addr_q[3]_i_24_n_0 ),
        .I2(\out_addr_q[3]_i_25_n_0 ),
        .I3(\out_addr_q[3]_i_26_n_0 ),
        .I4(\out_addr_q[3]_i_27_n_0 ),
        .I5(\out_addr_q[3]_i_13_n_0 ),
        .O(\out_addr_q[3]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h0000080000000000)) 
    \out_addr_q[3]_i_7 
       (.I0(\out_addr_q[0]_i_4_n_0 ),
        .I1(\out_addr_q[0]_i_5_n_0 ),
        .I2(\out_addr_q[3]_i_28_n_0 ),
        .I3(\out_addr_q[3]_i_12_n_0 ),
        .I4(\out_addr_q[3]_i_11_n_0 ),
        .I5(\out_addr_q[3]_i_9_n_0 ),
        .O(\out_addr_q[3]_i_7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT4 #(
    .INIT(16'hA955)) 
    \out_addr_q[3]_i_8 
       (.I0(rr_ptr_q[3]),
        .I1(rr_ptr_q[0]),
        .I2(rr_ptr_q[1]),
        .I3(rr_ptr_q[2]),
        .O(\out_addr_q[3]_i_8_n_0 ));
  LUT2 #(
    .INIT(4'hE)) 
    \out_addr_q[3]_i_9 
       (.I0(\out_addr_q[0]_i_7_n_0 ),
        .I1(\out_addr_q[0]_i_8_n_0 ),
        .O(\out_addr_q[3]_i_9_n_0 ));
  FDCE \out_addr_q_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\rr_ptr_q[3]_i_1_n_0 ),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\out_addr_q[0]_i_1_n_0 ),
        .Q(out_addr_OBUF[0]));
  FDCE \out_addr_q_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\rr_ptr_q[3]_i_1_n_0 ),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\out_addr_q[1]_i_1_n_0 ),
        .Q(out_addr_OBUF[1]));
  FDCE \out_addr_q_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\rr_ptr_q[3]_i_1_n_0 ),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\out_addr_q[2]_i_1_n_0 ),
        .Q(out_addr_OBUF[2]));
  FDCE \out_addr_q_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\rr_ptr_q[3]_i_1_n_0 ),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\out_addr_q[3]_i_1_n_0 ),
        .Q(out_addr_OBUF[3]));
  IBUF out_ready_IBUF_inst
       (.I(out_ready),
        .O(out_ready_IBUF));
  OBUF out_valid_OBUF_inst
       (.I(out_valid_OBUF),
        .O(out_valid));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT3 #(
    .INIT(8'h75)) 
    out_valid_q_i_1
       (.I0(\queue_count_q[15][1]_i_7_n_0 ),
        .I1(out_ready_IBUF),
        .I2(out_valid_OBUF),
        .O(out_valid_q_i_1_n_0));
  FDCE out_valid_q_reg
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(out_valid_q_i_1_n_0),
        .Q(out_valid_OBUF));
  LUT6 #(
    .INIT(64'hAA9AFFFFAA9A0000)) 
    \queue_count_q[0][0]_i_1 
       (.I0(\queue_count_q_reg_n_0_[0][0] ),
        .I1(src_ack_async_OBUF[0]),
        .I2(req_sync_q[0]),
        .I3(\queue_count_q_reg_n_0_[0][1] ),
        .I4(\queue_count_q[0][1]_i_3_n_0 ),
        .I5(\queue_count_q[15][1]_i_3_n_0 ),
        .O(\queue_count_d[0]__0 [0]));
  LUT5 #(
    .INIT(32'h00FF2D2D)) 
    \queue_count_q[0][1]_i_1 
       (.I0(\queue_count_q[14][1]_i_2_n_0 ),
        .I1(\queue_count_q[14][1]_i_3_n_0 ),
        .I2(\queue_count_q[15][1]_i_3_n_0 ),
        .I3(\queue_count_q[0][1]_i_2_n_0 ),
        .I4(\queue_count_q[0][1]_i_3_n_0 ),
        .O(\queue_count_d[0]__0 [1]));
  LUT4 #(
    .INIT(16'h5155)) 
    \queue_count_q[0][1]_i_2 
       (.I0(\queue_count_q_reg_n_0_[0][1] ),
        .I1(req_sync_q[0]),
        .I2(src_ack_async_OBUF[0]),
        .I3(\queue_count_q_reg_n_0_[0][0] ),
        .O(\queue_count_q[0][1]_i_2_n_0 ));
  (* OPT_MODIFIED = "RETARGET" *) 
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT5 #(
    .INIT(32'hFFFFFFEF)) 
    \queue_count_q[0][1]_i_3 
       (.I0(\out_addr_q[1]_i_1_n_0 ),
        .I1(\out_addr_q[0]_i_1_n_0 ),
        .I2(\rr_ptr_q[3]_i_1_n_0 ),
        .I3(\out_addr_q[3]_i_1_n_0 ),
        .I4(\out_addr_q[2]_i_1_n_0 ),
        .O(\queue_count_q[0][1]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAA9AFFFFAA9A0000)) 
    \queue_count_q[10][0]_i_1 
       (.I0(\queue_count_q_reg_n_0_[10][0] ),
        .I1(src_ack_async_OBUF[10]),
        .I2(req_sync_q[10]),
        .I3(\queue_count_q_reg_n_0_[10][1] ),
        .I4(\queue_count_q[10][1]_i_3_n_0 ),
        .I5(\queue_count_q[15][1]_i_3_n_0 ),
        .O(\queue_count_d[10] [0]));
  LUT5 #(
    .INIT(32'h44747747)) 
    \queue_count_q[10][1]_i_1 
       (.I0(\queue_count_q[10][1]_i_2_n_0 ),
        .I1(\queue_count_q[10][1]_i_3_n_0 ),
        .I2(\queue_count_q[14][1]_i_2_n_0 ),
        .I3(\queue_count_q[14][1]_i_3_n_0 ),
        .I4(\queue_count_q[15][1]_i_3_n_0 ),
        .O(\queue_count_d[10] [1]));
  LUT4 #(
    .INIT(16'h5155)) 
    \queue_count_q[10][1]_i_2 
       (.I0(\queue_count_q_reg_n_0_[10][1] ),
        .I1(req_sync_q[10]),
        .I2(src_ack_async_OBUF[10]),
        .I3(\queue_count_q_reg_n_0_[10][0] ),
        .O(\queue_count_q[10][1]_i_2_n_0 ));
  (* OPT_MODIFIED = "RETARGET" *) 
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT5 #(
    .INIT(32'hFFBFFFFF)) 
    \queue_count_q[10][1]_i_3 
       (.I0(\out_addr_q[0]_i_1_n_0 ),
        .I1(\out_addr_q[1]_i_1_n_0 ),
        .I2(\rr_ptr_q[3]_i_1_n_0 ),
        .I3(\out_addr_q[2]_i_1_n_0 ),
        .I4(\out_addr_q[3]_i_1_n_0 ),
        .O(\queue_count_q[10][1]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAA9AFFFFAA9A0000)) 
    \queue_count_q[11][0]_i_1 
       (.I0(\queue_count_q_reg_n_0_[11][0] ),
        .I1(src_ack_async_OBUF[11]),
        .I2(req_sync_q[11]),
        .I3(\queue_count_q_reg_n_0_[11][1] ),
        .I4(\queue_count_q[11][1]_i_3_n_0 ),
        .I5(\queue_count_q[15][1]_i_3_n_0 ),
        .O(\queue_count_d[11] [0]));
  LUT5 #(
    .INIT(32'h44747747)) 
    \queue_count_q[11][1]_i_1 
       (.I0(\queue_count_q[11][1]_i_2_n_0 ),
        .I1(\queue_count_q[11][1]_i_3_n_0 ),
        .I2(\queue_count_q[14][1]_i_2_n_0 ),
        .I3(\queue_count_q[14][1]_i_3_n_0 ),
        .I4(\queue_count_q[15][1]_i_3_n_0 ),
        .O(\queue_count_d[11] [1]));
  LUT4 #(
    .INIT(16'h5155)) 
    \queue_count_q[11][1]_i_2 
       (.I0(\queue_count_q_reg_n_0_[11][1] ),
        .I1(req_sync_q[11]),
        .I2(src_ack_async_OBUF[11]),
        .I3(\queue_count_q_reg_n_0_[11][0] ),
        .O(\queue_count_q[11][1]_i_2_n_0 ));
  (* OPT_MODIFIED = "RETARGET" *) 
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT5 #(
    .INIT(32'hF7FFFFFF)) 
    \queue_count_q[11][1]_i_3 
       (.I0(\out_addr_q[1]_i_1_n_0 ),
        .I1(\out_addr_q[0]_i_1_n_0 ),
        .I2(\out_addr_q[2]_i_1_n_0 ),
        .I3(\out_addr_q[3]_i_1_n_0 ),
        .I4(\rr_ptr_q[3]_i_1_n_0 ),
        .O(\queue_count_q[11][1]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAA9AFFFFAA9A0000)) 
    \queue_count_q[12][0]_i_1 
       (.I0(\queue_count_q_reg_n_0_[12][0] ),
        .I1(src_ack_async_OBUF[12]),
        .I2(req_sync_q[12]),
        .I3(\queue_count_q_reg_n_0_[12][1] ),
        .I4(\queue_count_q[12][1]_i_3_n_0 ),
        .I5(\queue_count_q[15][1]_i_3_n_0 ),
        .O(\queue_count_d[12] [0]));
  LUT5 #(
    .INIT(32'h00FF2D2D)) 
    \queue_count_q[12][1]_i_1 
       (.I0(\queue_count_q[14][1]_i_2_n_0 ),
        .I1(\queue_count_q[14][1]_i_3_n_0 ),
        .I2(\queue_count_q[15][1]_i_3_n_0 ),
        .I3(\queue_count_q[12][1]_i_2_n_0 ),
        .I4(\queue_count_q[12][1]_i_3_n_0 ),
        .O(\queue_count_d[12] [1]));
  LUT4 #(
    .INIT(16'h5155)) 
    \queue_count_q[12][1]_i_2 
       (.I0(\queue_count_q_reg_n_0_[12][1] ),
        .I1(req_sync_q[12]),
        .I2(src_ack_async_OBUF[12]),
        .I3(\queue_count_q_reg_n_0_[12][0] ),
        .O(\queue_count_q[12][1]_i_2_n_0 ));
  (* OPT_MODIFIED = "RETARGET" *) 
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT5 #(
    .INIT(32'hEFFFFFFF)) 
    \queue_count_q[12][1]_i_3 
       (.I0(\out_addr_q[1]_i_1_n_0 ),
        .I1(\out_addr_q[0]_i_1_n_0 ),
        .I2(\rr_ptr_q[3]_i_1_n_0 ),
        .I3(\out_addr_q[3]_i_1_n_0 ),
        .I4(\out_addr_q[2]_i_1_n_0 ),
        .O(\queue_count_q[12][1]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAA9AFFFFAA9A0000)) 
    \queue_count_q[13][0]_i_1 
       (.I0(\queue_count_q_reg_n_0_[13][0] ),
        .I1(src_ack_async_OBUF[13]),
        .I2(req_sync_q[13]),
        .I3(\queue_count_q_reg_n_0_[13][1] ),
        .I4(\queue_count_q[13][1]_i_3_n_0 ),
        .I5(\queue_count_q[15][1]_i_3_n_0 ),
        .O(\queue_count_d[13] [0]));
  LUT5 #(
    .INIT(32'h44747747)) 
    \queue_count_q[13][1]_i_1 
       (.I0(\queue_count_q[13][1]_i_2_n_0 ),
        .I1(\queue_count_q[13][1]_i_3_n_0 ),
        .I2(\queue_count_q[14][1]_i_2_n_0 ),
        .I3(\queue_count_q[14][1]_i_3_n_0 ),
        .I4(\queue_count_q[15][1]_i_3_n_0 ),
        .O(\queue_count_d[13] [1]));
  LUT4 #(
    .INIT(16'h5155)) 
    \queue_count_q[13][1]_i_2 
       (.I0(\queue_count_q_reg_n_0_[13][1] ),
        .I1(req_sync_q[13]),
        .I2(src_ack_async_OBUF[13]),
        .I3(\queue_count_q_reg_n_0_[13][0] ),
        .O(\queue_count_q[13][1]_i_2_n_0 ));
  (* OPT_MODIFIED = "RETARGET" *) 
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT5 #(
    .INIT(32'hDFFFFFFF)) 
    \queue_count_q[13][1]_i_3 
       (.I0(\out_addr_q[0]_i_1_n_0 ),
        .I1(\out_addr_q[1]_i_1_n_0 ),
        .I2(\rr_ptr_q[3]_i_1_n_0 ),
        .I3(\out_addr_q[3]_i_1_n_0 ),
        .I4(\out_addr_q[2]_i_1_n_0 ),
        .O(\queue_count_q[13][1]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAA9AFFFFAA9A0000)) 
    \queue_count_q[14][0]_i_1 
       (.I0(\queue_count_q_reg_n_0_[14][0] ),
        .I1(src_ack_async_OBUF[14]),
        .I2(req_sync_q[14]),
        .I3(\queue_count_q_reg_n_0_[14][1] ),
        .I4(\queue_count_q[14][1]_i_5_n_0 ),
        .I5(\queue_count_q[15][1]_i_3_n_0 ),
        .O(\queue_count_d[14] [0]));
  LUT5 #(
    .INIT(32'h00FF2D2D)) 
    \queue_count_q[14][1]_i_1 
       (.I0(\queue_count_q[14][1]_i_2_n_0 ),
        .I1(\queue_count_q[14][1]_i_3_n_0 ),
        .I2(\queue_count_q[15][1]_i_3_n_0 ),
        .I3(\queue_count_q[14][1]_i_4_n_0 ),
        .I4(\queue_count_q[14][1]_i_5_n_0 ),
        .O(\queue_count_d[14] [1]));
  LUT4 #(
    .INIT(16'hFB73)) 
    \queue_count_q[14][1]_i_2 
       (.I0(\out_addr_q[3]_i_1_n_0 ),
        .I1(\out_addr_q[2]_i_1_n_0 ),
        .I2(\queue_count_q[15][1]_i_11_n_0 ),
        .I3(\queue_count_q[15][1]_i_10_n_0 ),
        .O(\queue_count_q[14][1]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'h0415)) 
    \queue_count_q[14][1]_i_3 
       (.I0(\out_addr_q[2]_i_1_n_0 ),
        .I1(\out_addr_q[3]_i_1_n_0 ),
        .I2(\queue_count_q[15][1]_i_9_n_0 ),
        .I3(\queue_count_q[15][1]_i_8_n_0 ),
        .O(\queue_count_q[14][1]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h5155)) 
    \queue_count_q[14][1]_i_4 
       (.I0(\queue_count_q_reg_n_0_[14][1] ),
        .I1(req_sync_q[14]),
        .I2(src_ack_async_OBUF[14]),
        .I3(\queue_count_q_reg_n_0_[14][0] ),
        .O(\queue_count_q[14][1]_i_4_n_0 ));
  (* OPT_MODIFIED = "RETARGET" *) 
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT5 #(
    .INIT(32'hBFFFFFFF)) 
    \queue_count_q[14][1]_i_5 
       (.I0(\out_addr_q[0]_i_1_n_0 ),
        .I1(\out_addr_q[1]_i_1_n_0 ),
        .I2(\rr_ptr_q[3]_i_1_n_0 ),
        .I3(\out_addr_q[3]_i_1_n_0 ),
        .I4(\out_addr_q[2]_i_1_n_0 ),
        .O(\queue_count_q[14][1]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hB8B8B8B8B88BB8B8)) 
    \queue_count_q[15][0]_i_1 
       (.I0(\queue_count_q[15][1]_i_3_n_0 ),
        .I1(\queue_count_q[15][0]_i_2_n_0 ),
        .I2(\queue_count_q_reg_n_0_[15][0] ),
        .I3(src_ack_async_OBUF[15]),
        .I4(req_sync_q[15]),
        .I5(\queue_count_q_reg_n_0_[15][1] ),
        .O(\queue_count_d[15] [0]));
  (* OPT_MODIFIED = "RETARGET" *) 
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT5 #(
    .INIT(32'h80000000)) 
    \queue_count_q[15][0]_i_2 
       (.I0(\out_addr_q[1]_i_1_n_0 ),
        .I1(\out_addr_q[0]_i_1_n_0 ),
        .I2(\out_addr_q[3]_i_1_n_0 ),
        .I3(\out_addr_q[2]_i_1_n_0 ),
        .I4(\rr_ptr_q[3]_i_1_n_0 ),
        .O(\queue_count_q[15][0]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000FFFF0006FFF6)) 
    \queue_count_q[15][1]_i_1 
       (.I0(\queue_count_q[15][1]_i_2_n_0 ),
        .I1(\queue_count_q[15][1]_i_3_n_0 ),
        .I2(\queue_count_q[15][1]_i_4_n_0 ),
        .I3(\queue_count_q[15][1]_i_5_n_0 ),
        .I4(\queue_count_q[15][1]_i_6_n_0 ),
        .I5(\queue_count_q[15][1]_i_7_n_0 ),
        .O(\queue_count_d[15] [1]));
  (* OPT_MODIFIED = "RETARGET" *) 
  LUT6 #(
    .INIT(64'hFA0AFCFCFA0A0C0C)) 
    \queue_count_q[15][1]_i_10 
       (.I0(\queue_count_q[13][1]_i_2_n_0 ),
        .I1(\queue_count_q[12][1]_i_2_n_0 ),
        .I2(\out_addr_q[1]_i_1_n_0 ),
        .I3(\queue_count_q[15][1]_i_6_n_0 ),
        .I4(\out_addr_q[0]_i_1_n_0 ),
        .I5(\queue_count_q[14][1]_i_4_n_0 ),
        .O(\queue_count_q[15][1]_i_10_n_0 ));
  (* OPT_MODIFIED = "RETARGET" *) 
  LUT6 #(
    .INIT(64'hFA0AFCFCFA0A0C0C)) 
    \queue_count_q[15][1]_i_11 
       (.I0(\queue_count_q[5][1]_i_2_n_0 ),
        .I1(\queue_count_q[4][1]_i_2_n_0 ),
        .I2(\out_addr_q[1]_i_1_n_0 ),
        .I3(\queue_count_q[7][1]_i_2_n_0 ),
        .I4(\out_addr_q[0]_i_1_n_0 ),
        .I5(\queue_count_q[6][1]_i_2_n_0 ),
        .O(\queue_count_q[15][1]_i_11_n_0 ));
  (* OPT_MODIFIED = "RETARGET" *) 
  LUT6 #(
    .INIT(64'h05F5030305F5F3F3)) 
    \queue_count_q[15][1]_i_12 
       (.I0(\queue_count_q[15][1]_i_21_n_0 ),
        .I1(\queue_count_q[15][1]_i_22_n_0 ),
        .I2(\out_addr_q[1]_i_1_n_0 ),
        .I3(\queue_count_q[15][1]_i_23_n_0 ),
        .I4(\out_addr_q[0]_i_1_n_0 ),
        .I5(\queue_count_q[15][1]_i_24_n_0 ),
        .O(\queue_count_q[15][1]_i_12_n_0 ));
  (* OPT_MODIFIED = "RETARGET" *) 
  LUT6 #(
    .INIT(64'h05F5030305F5F3F3)) 
    \queue_count_q[15][1]_i_13 
       (.I0(\queue_count_q[15][1]_i_25_n_0 ),
        .I1(\queue_count_q[15][1]_i_26_n_0 ),
        .I2(\out_addr_q[1]_i_1_n_0 ),
        .I3(\queue_count_q[15][1]_i_27_n_0 ),
        .I4(\out_addr_q[0]_i_1_n_0 ),
        .I5(\queue_count_q[15][1]_i_28_n_0 ),
        .O(\queue_count_q[15][1]_i_13_n_0 ));
  (* OPT_MODIFIED = "RETARGET" *) 
  LUT6 #(
    .INIT(64'h05F5030305F5F3F3)) 
    \queue_count_q[15][1]_i_14 
       (.I0(\queue_count_q[15][1]_i_29_n_0 ),
        .I1(\queue_count_q[15][1]_i_30_n_0 ),
        .I2(\out_addr_q[1]_i_1_n_0 ),
        .I3(\queue_count_q[15][1]_i_31_n_0 ),
        .I4(\out_addr_q[0]_i_1_n_0 ),
        .I5(\queue_count_q[15][1]_i_32_n_0 ),
        .O(\queue_count_q[15][1]_i_14_n_0 ));
  (* OPT_MODIFIED = "RETARGET" *) 
  LUT6 #(
    .INIT(64'h05F5030305F5F3F3)) 
    \queue_count_q[15][1]_i_15 
       (.I0(\queue_count_q[15][1]_i_33_n_0 ),
        .I1(\queue_count_q[15][1]_i_34_n_0 ),
        .I2(\out_addr_q[1]_i_1_n_0 ),
        .I3(\queue_count_q[15][1]_i_35_n_0 ),
        .I4(\out_addr_q[0]_i_1_n_0 ),
        .I5(\queue_count_q[15][1]_i_36_n_0 ),
        .O(\queue_count_q[15][1]_i_15_n_0 ));
  LUT6 #(
    .INIT(64'h0800000000000000)) 
    \queue_count_q[15][1]_i_16 
       (.I0(\out_addr_q[0]_i_8_n_0 ),
        .I1(\out_addr_q[0]_i_13_n_0 ),
        .I2(\queue_count_q[15][1]_i_37_n_0 ),
        .I3(\queue_count_q[15][1]_i_38_n_0 ),
        .I4(\queue_count_q[15][1]_i_39_n_0 ),
        .I5(\queue_count_q[15][1]_i_40_n_0 ),
        .O(\queue_count_q[15][1]_i_16_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT5 #(
    .INIT(32'hA0AF0CFC)) 
    \queue_count_q[15][1]_i_17 
       (.I0(\queue_count_q[15][1]_i_41_n_0 ),
        .I1(\queue_count_q_reg[15][1]_i_42_n_0 ),
        .I2(rr_ptr_q[2]),
        .I3(\queue_count_q[15][1]_i_43_n_0 ),
        .I4(rr_ptr_q[3]),
        .O(\queue_count_q[15][1]_i_17_n_0 ));
  LUT6 #(
    .INIT(64'hBBBBBEEE88888222)) 
    \queue_count_q[15][1]_i_18 
       (.I0(\queue_count_q[15][1]_i_44_n_0 ),
        .I1(rr_ptr_q[3]),
        .I2(rr_ptr_q[0]),
        .I3(rr_ptr_q[1]),
        .I4(rr_ptr_q[2]),
        .I5(\queue_count_q[15][1]_i_45_n_0 ),
        .O(\queue_count_q[15][1]_i_18_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT5 #(
    .INIT(32'hACACACCA)) 
    \queue_count_q[15][1]_i_19 
       (.I0(\queue_count_q[15][1]_i_46_n_0 ),
        .I1(\queue_count_q[15][1]_i_47_n_0 ),
        .I2(rr_ptr_q[3]),
        .I3(rr_ptr_q[2]),
        .I4(rr_ptr_q[1]),
        .O(\queue_count_q[15][1]_i_19_n_0 ));
  LUT6 #(
    .INIT(64'h0305F30503F5F3F5)) 
    \queue_count_q[15][1]_i_2 
       (.I0(\queue_count_q[15][1]_i_8_n_0 ),
        .I1(\queue_count_q[15][1]_i_9_n_0 ),
        .I2(\out_addr_q[2]_i_1_n_0 ),
        .I3(\out_addr_q[3]_i_1_n_0 ),
        .I4(\queue_count_q[15][1]_i_10_n_0 ),
        .I5(\queue_count_q[15][1]_i_11_n_0 ),
        .O(\queue_count_q[15][1]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hBBBBBBBE88888882)) 
    \queue_count_q[15][1]_i_20 
       (.I0(\queue_count_q[15][1]_i_48_n_0 ),
        .I1(rr_ptr_q[3]),
        .I2(rr_ptr_q[0]),
        .I3(rr_ptr_q[1]),
        .I4(rr_ptr_q[2]),
        .I5(\queue_count_q[15][1]_i_49_n_0 ),
        .O(\queue_count_q[15][1]_i_20_n_0 ));
  LUT4 #(
    .INIT(16'hAA9A)) 
    \queue_count_q[15][1]_i_21 
       (.I0(\queue_count_q_reg_n_0_[13][0] ),
        .I1(src_ack_async_OBUF[13]),
        .I2(req_sync_q[13]),
        .I3(\queue_count_q_reg_n_0_[13][1] ),
        .O(\queue_count_q[15][1]_i_21_n_0 ));
  LUT4 #(
    .INIT(16'hAA9A)) 
    \queue_count_q[15][1]_i_22 
       (.I0(\queue_count_q_reg_n_0_[12][0] ),
        .I1(src_ack_async_OBUF[12]),
        .I2(req_sync_q[12]),
        .I3(\queue_count_q_reg_n_0_[12][1] ),
        .O(\queue_count_q[15][1]_i_22_n_0 ));
  LUT4 #(
    .INIT(16'hAA9A)) 
    \queue_count_q[15][1]_i_23 
       (.I0(\queue_count_q_reg_n_0_[15][0] ),
        .I1(src_ack_async_OBUF[15]),
        .I2(req_sync_q[15]),
        .I3(\queue_count_q_reg_n_0_[15][1] ),
        .O(\queue_count_q[15][1]_i_23_n_0 ));
  LUT4 #(
    .INIT(16'hAA9A)) 
    \queue_count_q[15][1]_i_24 
       (.I0(\queue_count_q_reg_n_0_[14][0] ),
        .I1(src_ack_async_OBUF[14]),
        .I2(req_sync_q[14]),
        .I3(\queue_count_q_reg_n_0_[14][1] ),
        .O(\queue_count_q[15][1]_i_24_n_0 ));
  LUT4 #(
    .INIT(16'hAA9A)) 
    \queue_count_q[15][1]_i_25 
       (.I0(\queue_count_q_reg_n_0_[9][0] ),
        .I1(src_ack_async_OBUF[9]),
        .I2(req_sync_q[9]),
        .I3(\queue_count_q_reg_n_0_[9][1] ),
        .O(\queue_count_q[15][1]_i_25_n_0 ));
  LUT4 #(
    .INIT(16'hAA9A)) 
    \queue_count_q[15][1]_i_26 
       (.I0(\queue_count_q_reg_n_0_[8][0] ),
        .I1(src_ack_async_OBUF[8]),
        .I2(req_sync_q[8]),
        .I3(\queue_count_q_reg_n_0_[8][1] ),
        .O(\queue_count_q[15][1]_i_26_n_0 ));
  LUT4 #(
    .INIT(16'hAA9A)) 
    \queue_count_q[15][1]_i_27 
       (.I0(\queue_count_q_reg_n_0_[11][0] ),
        .I1(src_ack_async_OBUF[11]),
        .I2(req_sync_q[11]),
        .I3(\queue_count_q_reg_n_0_[11][1] ),
        .O(\queue_count_q[15][1]_i_27_n_0 ));
  LUT4 #(
    .INIT(16'hAA9A)) 
    \queue_count_q[15][1]_i_28 
       (.I0(\queue_count_q_reg_n_0_[10][0] ),
        .I1(src_ack_async_OBUF[10]),
        .I2(req_sync_q[10]),
        .I3(\queue_count_q_reg_n_0_[10][1] ),
        .O(\queue_count_q[15][1]_i_28_n_0 ));
  LUT4 #(
    .INIT(16'hAA9A)) 
    \queue_count_q[15][1]_i_29 
       (.I0(\queue_count_q_reg_n_0_[5][0] ),
        .I1(src_ack_async_OBUF[5]),
        .I2(req_sync_q[5]),
        .I3(\queue_count_q_reg_n_0_[5][1] ),
        .O(\queue_count_q[15][1]_i_29_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \queue_count_q[15][1]_i_3 
       (.I0(\queue_count_q[15][1]_i_12_n_0 ),
        .I1(\queue_count_q[15][1]_i_13_n_0 ),
        .I2(\out_addr_q[3]_i_1_n_0 ),
        .I3(\queue_count_q[15][1]_i_14_n_0 ),
        .I4(\out_addr_q[2]_i_1_n_0 ),
        .I5(\queue_count_q[15][1]_i_15_n_0 ),
        .O(\queue_count_q[15][1]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'hAA9A)) 
    \queue_count_q[15][1]_i_30 
       (.I0(\queue_count_q_reg_n_0_[4][0] ),
        .I1(src_ack_async_OBUF[4]),
        .I2(req_sync_q[4]),
        .I3(\queue_count_q_reg_n_0_[4][1] ),
        .O(\queue_count_q[15][1]_i_30_n_0 ));
  LUT4 #(
    .INIT(16'hAA9A)) 
    \queue_count_q[15][1]_i_31 
       (.I0(\queue_count_q_reg_n_0_[7][0] ),
        .I1(src_ack_async_OBUF[7]),
        .I2(req_sync_q[7]),
        .I3(\queue_count_q_reg_n_0_[7][1] ),
        .O(\queue_count_q[15][1]_i_31_n_0 ));
  LUT4 #(
    .INIT(16'hAA9A)) 
    \queue_count_q[15][1]_i_32 
       (.I0(\queue_count_q_reg_n_0_[6][0] ),
        .I1(src_ack_async_OBUF[6]),
        .I2(req_sync_q[6]),
        .I3(\queue_count_q_reg_n_0_[6][1] ),
        .O(\queue_count_q[15][1]_i_32_n_0 ));
  LUT4 #(
    .INIT(16'hAA9A)) 
    \queue_count_q[15][1]_i_33 
       (.I0(\queue_count_q_reg_n_0_[1][0] ),
        .I1(src_ack_async_OBUF[1]),
        .I2(req_sync_q[1]),
        .I3(\queue_count_q_reg_n_0_[1][1] ),
        .O(\queue_count_q[15][1]_i_33_n_0 ));
  LUT4 #(
    .INIT(16'hAA9A)) 
    \queue_count_q[15][1]_i_34 
       (.I0(\queue_count_q_reg_n_0_[0][0] ),
        .I1(src_ack_async_OBUF[0]),
        .I2(req_sync_q[0]),
        .I3(\queue_count_q_reg_n_0_[0][1] ),
        .O(\queue_count_q[15][1]_i_34_n_0 ));
  LUT4 #(
    .INIT(16'hAA9A)) 
    \queue_count_q[15][1]_i_35 
       (.I0(\queue_count_q_reg_n_0_[3][0] ),
        .I1(src_ack_async_OBUF[3]),
        .I2(req_sync_q[3]),
        .I3(\queue_count_q_reg_n_0_[3][1] ),
        .O(\queue_count_q[15][1]_i_35_n_0 ));
  LUT4 #(
    .INIT(16'hAA9A)) 
    \queue_count_q[15][1]_i_36 
       (.I0(\queue_count_q_reg_n_0_[2][0] ),
        .I1(src_ack_async_OBUF[2]),
        .I2(req_sync_q[2]),
        .I3(\queue_count_q_reg_n_0_[2][1] ),
        .O(\queue_count_q[15][1]_i_36_n_0 ));
  LUT6 #(
    .INIT(64'hEBBBBBBB28888888)) 
    \queue_count_q[15][1]_i_37 
       (.I0(\queue_count_q[15][1]_i_50_n_0 ),
        .I1(rr_ptr_q[3]),
        .I2(rr_ptr_q[0]),
        .I3(rr_ptr_q[1]),
        .I4(rr_ptr_q[2]),
        .I5(\queue_count_q[15][1]_i_51_n_0 ),
        .O(\queue_count_q[15][1]_i_37_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT5 #(
    .INIT(32'hB8BBB888)) 
    \queue_count_q[15][1]_i_38 
       (.I0(\queue_count_q[15][1]_i_52_n_0 ),
        .I1(rr_ptr_q[3]),
        .I2(\queue_count_q_reg[15][1]_i_42_n_0 ),
        .I3(rr_ptr_q[2]),
        .I4(\queue_count_q[15][1]_i_41_n_0 ),
        .O(\queue_count_q[15][1]_i_38_n_0 ));
  LUT6 #(
    .INIT(64'h0000100000000000)) 
    \queue_count_q[15][1]_i_39 
       (.I0(\out_addr_q[3]_i_37_n_0 ),
        .I1(\out_addr_q[3]_i_31_n_0 ),
        .I2(\out_addr_q[3]_i_36_n_0 ),
        .I3(\out_addr_q[3]_i_34_n_0 ),
        .I4(\out_addr_q[3]_i_35_n_0 ),
        .I5(\out_addr_q[3]_i_38_n_0 ),
        .O(\queue_count_q[15][1]_i_39_n_0 ));
  (* OPT_MODIFIED = "RETARGET" *) 
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT4 #(
    .INIT(16'h7FFF)) 
    \queue_count_q[15][1]_i_4 
       (.I0(\out_addr_q[1]_i_1_n_0 ),
        .I1(\out_addr_q[0]_i_1_n_0 ),
        .I2(\out_addr_q[3]_i_1_n_0 ),
        .I3(\out_addr_q[2]_i_1_n_0 ),
        .O(\queue_count_q[15][1]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hBBBBBBBE88888882)) 
    \queue_count_q[15][1]_i_40 
       (.I0(\queue_count_q[15][1]_i_49_n_0 ),
        .I1(rr_ptr_q[3]),
        .I2(rr_ptr_q[0]),
        .I3(rr_ptr_q[1]),
        .I4(rr_ptr_q[2]),
        .I5(\queue_count_q[15][1]_i_48_n_0 ),
        .O(\queue_count_q[15][1]_i_40_n_0 ));
  LUT6 #(
    .INIT(64'h00000000111DDD1D)) 
    \queue_count_q[15][1]_i_41 
       (.I0(\queue_count_q[15][1]_i_53_n_0 ),
        .I1(rr_ptr_q[1]),
        .I2(\queue_count_q_reg_n_0_[10][0] ),
        .I3(rr_ptr_q[0]),
        .I4(\queue_count_q_reg_n_0_[11][0] ),
        .I5(\queue_count_q[15][1]_i_54_n_0 ),
        .O(\queue_count_q[15][1]_i_41_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT5 #(
    .INIT(32'hFFFACCFA)) 
    \queue_count_q[15][1]_i_43 
       (.I0(\queue_count_q[15][1]_i_57_n_0 ),
        .I1(\queue_count_q[15][1]_i_58_n_0 ),
        .I2(\queue_count_q[15][1]_i_59_n_0 ),
        .I3(rr_ptr_q[2]),
        .I4(\queue_count_q[15][1]_i_60_n_0 ),
        .O(\queue_count_q[15][1]_i_43_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT5 #(
    .INIT(32'hFFFCAAFC)) 
    \queue_count_q[15][1]_i_44 
       (.I0(\queue_count_q[15][1]_i_61_n_0 ),
        .I1(\queue_count_q[15][1]_i_62_n_0 ),
        .I2(\queue_count_q[15][1]_i_63_n_0 ),
        .I3(\out_addr_q[2]_i_7_n_0 ),
        .I4(\queue_count_q[15][1]_i_64_n_0 ),
        .O(\queue_count_q[15][1]_i_44_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT5 #(
    .INIT(32'hFFFCAAFC)) 
    \queue_count_q[15][1]_i_45 
       (.I0(\queue_count_q[15][1]_i_65_n_0 ),
        .I1(\queue_count_q[15][1]_i_66_n_0 ),
        .I2(\queue_count_q[15][1]_i_67_n_0 ),
        .I3(\out_addr_q[2]_i_7_n_0 ),
        .I4(\queue_count_q[15][1]_i_68_n_0 ),
        .O(\queue_count_q[15][1]_i_45_n_0 ));
  LUT6 #(
    .INIT(64'h0500000505333305)) 
    \queue_count_q[15][1]_i_46 
       (.I0(\queue_count_q[15][1]_i_69_n_0 ),
        .I1(\queue_count_q[15][1]_i_70_n_0 ),
        .I2(\queue_count_q[15][1]_i_71_n_0 ),
        .I3(rr_ptr_q[2]),
        .I4(rr_ptr_q[1]),
        .I5(\queue_count_q[15][1]_i_72_n_0 ),
        .O(\queue_count_q[15][1]_i_46_n_0 ));
  LUT6 #(
    .INIT(64'h0500000505333305)) 
    \queue_count_q[15][1]_i_47 
       (.I0(\queue_count_q[15][1]_i_73_n_0 ),
        .I1(\queue_count_q[15][1]_i_74_n_0 ),
        .I2(\queue_count_q[15][1]_i_75_n_0 ),
        .I3(rr_ptr_q[2]),
        .I4(rr_ptr_q[1]),
        .I5(\queue_count_q[15][1]_i_76_n_0 ),
        .O(\queue_count_q[15][1]_i_47_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT5 #(
    .INIT(32'h00053305)) 
    \queue_count_q[15][1]_i_48 
       (.I0(\queue_count_q[15][1]_i_77_n_0 ),
        .I1(\queue_count_q[15][1]_i_78_n_0 ),
        .I2(\queue_count_q[15][1]_i_79_n_0 ),
        .I3(\queue_count_q[15][1]_i_80_n_0 ),
        .I4(\queue_count_q[15][1]_i_81_n_0 ),
        .O(\queue_count_q[15][1]_i_48_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT5 #(
    .INIT(32'h00053305)) 
    \queue_count_q[15][1]_i_49 
       (.I0(\queue_count_q[15][1]_i_82_n_0 ),
        .I1(\queue_count_q[15][1]_i_83_n_0 ),
        .I2(\queue_count_q[15][1]_i_84_n_0 ),
        .I3(\queue_count_q[15][1]_i_80_n_0 ),
        .I4(\queue_count_q[15][1]_i_85_n_0 ),
        .O(\queue_count_q[15][1]_i_49_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \queue_count_q[15][1]_i_5 
       (.I0(out_valid_OBUF),
        .I1(out_ready_IBUF),
        .O(\queue_count_q[15][1]_i_5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT5 #(
    .INIT(32'hFCFFFCAA)) 
    \queue_count_q[15][1]_i_50 
       (.I0(\queue_count_q[15][1]_i_65_n_0 ),
        .I1(\queue_count_q[15][1]_i_66_n_0 ),
        .I2(\queue_count_q[15][1]_i_67_n_0 ),
        .I3(\out_addr_q[2]_i_7_n_0 ),
        .I4(\queue_count_q[15][1]_i_68_n_0 ),
        .O(\queue_count_q[15][1]_i_50_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT5 #(
    .INIT(32'hFCFFFCAA)) 
    \queue_count_q[15][1]_i_51 
       (.I0(\queue_count_q[15][1]_i_61_n_0 ),
        .I1(\queue_count_q[15][1]_i_62_n_0 ),
        .I2(\queue_count_q[15][1]_i_63_n_0 ),
        .I3(\out_addr_q[2]_i_7_n_0 ),
        .I4(\queue_count_q[15][1]_i_64_n_0 ),
        .O(\queue_count_q[15][1]_i_51_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT5 #(
    .INIT(32'h00053305)) 
    \queue_count_q[15][1]_i_52 
       (.I0(\queue_count_q[15][1]_i_60_n_0 ),
        .I1(\queue_count_q[15][1]_i_59_n_0 ),
        .I2(\queue_count_q[15][1]_i_58_n_0 ),
        .I3(rr_ptr_q[2]),
        .I4(\queue_count_q[15][1]_i_57_n_0 ),
        .O(\queue_count_q[15][1]_i_52_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \queue_count_q[15][1]_i_53 
       (.I0(\queue_count_q_reg_n_0_[9][0] ),
        .I1(rr_ptr_q[0]),
        .I2(\queue_count_q_reg_n_0_[8][0] ),
        .O(\queue_count_q[15][1]_i_53_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \queue_count_q[15][1]_i_54 
       (.I0(\queue_count_q_reg_n_0_[11][1] ),
        .I1(\queue_count_q_reg_n_0_[10][1] ),
        .I2(rr_ptr_q[1]),
        .I3(\queue_count_q_reg_n_0_[9][1] ),
        .I4(rr_ptr_q[0]),
        .I5(\queue_count_q_reg_n_0_[8][1] ),
        .O(\queue_count_q[15][1]_i_54_n_0 ));
  LUT5 #(
    .INIT(32'h00053305)) 
    \queue_count_q[15][1]_i_55 
       (.I0(\queue_count_q_reg_n_0_[12][1] ),
        .I1(\queue_count_q_reg_n_0_[13][1] ),
        .I2(\queue_count_q_reg_n_0_[12][0] ),
        .I3(rr_ptr_q[0]),
        .I4(\queue_count_q_reg_n_0_[13][0] ),
        .O(\queue_count_q[15][1]_i_55_n_0 ));
  LUT5 #(
    .INIT(32'h00053305)) 
    \queue_count_q[15][1]_i_56 
       (.I0(\queue_count_q_reg_n_0_[14][1] ),
        .I1(\queue_count_q_reg_n_0_[15][1] ),
        .I2(\queue_count_q_reg_n_0_[14][0] ),
        .I3(rr_ptr_q[0]),
        .I4(\queue_count_q_reg_n_0_[15][0] ),
        .O(\queue_count_q[15][1]_i_56_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \queue_count_q[15][1]_i_57 
       (.I0(\queue_count_q_reg_n_0_[7][0] ),
        .I1(\queue_count_q_reg_n_0_[6][0] ),
        .I2(rr_ptr_q[1]),
        .I3(\queue_count_q_reg_n_0_[5][0] ),
        .I4(rr_ptr_q[0]),
        .I5(\queue_count_q_reg_n_0_[4][0] ),
        .O(\queue_count_q[15][1]_i_57_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \queue_count_q[15][1]_i_58 
       (.I0(\queue_count_q_reg_n_0_[3][0] ),
        .I1(\queue_count_q_reg_n_0_[2][0] ),
        .I2(rr_ptr_q[1]),
        .I3(\queue_count_q_reg_n_0_[1][0] ),
        .I4(rr_ptr_q[0]),
        .I5(\queue_count_q_reg_n_0_[0][0] ),
        .O(\queue_count_q[15][1]_i_58_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \queue_count_q[15][1]_i_59 
       (.I0(\queue_count_q_reg_n_0_[7][1] ),
        .I1(\queue_count_q_reg_n_0_[6][1] ),
        .I2(rr_ptr_q[1]),
        .I3(\queue_count_q_reg_n_0_[5][1] ),
        .I4(rr_ptr_q[0]),
        .I5(\queue_count_q_reg_n_0_[4][1] ),
        .O(\queue_count_q[15][1]_i_59_n_0 ));
  LUT4 #(
    .INIT(16'h5155)) 
    \queue_count_q[15][1]_i_6 
       (.I0(\queue_count_q_reg_n_0_[15][1] ),
        .I1(req_sync_q[15]),
        .I2(src_ack_async_OBUF[15]),
        .I3(\queue_count_q_reg_n_0_[15][0] ),
        .O(\queue_count_q[15][1]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \queue_count_q[15][1]_i_60 
       (.I0(\queue_count_q_reg_n_0_[3][1] ),
        .I1(\queue_count_q_reg_n_0_[2][1] ),
        .I2(rr_ptr_q[1]),
        .I3(\queue_count_q_reg_n_0_[1][1] ),
        .I4(rr_ptr_q[0]),
        .I5(\queue_count_q_reg_n_0_[0][1] ),
        .O(\queue_count_q[15][1]_i_60_n_0 ));
  LUT6 #(
    .INIT(64'hFCAF0CAFFCA00CA0)) 
    \queue_count_q[15][1]_i_61 
       (.I0(\queue_count_q_reg_n_0_[14][0] ),
        .I1(\queue_count_q_reg_n_0_[15][0] ),
        .I2(rr_ptr_q[0]),
        .I3(rr_ptr_q[1]),
        .I4(\queue_count_q_reg_n_0_[12][0] ),
        .I5(\queue_count_q_reg_n_0_[13][0] ),
        .O(\queue_count_q[15][1]_i_61_n_0 ));
  LUT6 #(
    .INIT(64'hFCAF0CAFFCA00CA0)) 
    \queue_count_q[15][1]_i_62 
       (.I0(\queue_count_q_reg_n_0_[10][0] ),
        .I1(\queue_count_q_reg_n_0_[11][0] ),
        .I2(rr_ptr_q[0]),
        .I3(rr_ptr_q[1]),
        .I4(\queue_count_q_reg_n_0_[8][0] ),
        .I5(\queue_count_q_reg_n_0_[9][0] ),
        .O(\queue_count_q[15][1]_i_62_n_0 ));
  LUT6 #(
    .INIT(64'hFCAF0CAFFCA00CA0)) 
    \queue_count_q[15][1]_i_63 
       (.I0(\queue_count_q_reg_n_0_[10][1] ),
        .I1(\queue_count_q_reg_n_0_[11][1] ),
        .I2(rr_ptr_q[0]),
        .I3(rr_ptr_q[1]),
        .I4(\queue_count_q_reg_n_0_[8][1] ),
        .I5(\queue_count_q_reg_n_0_[9][1] ),
        .O(\queue_count_q[15][1]_i_63_n_0 ));
  LUT6 #(
    .INIT(64'hFCAF0CAFFCA00CA0)) 
    \queue_count_q[15][1]_i_64 
       (.I0(\queue_count_q_reg_n_0_[14][1] ),
        .I1(\queue_count_q_reg_n_0_[15][1] ),
        .I2(rr_ptr_q[0]),
        .I3(rr_ptr_q[1]),
        .I4(\queue_count_q_reg_n_0_[12][1] ),
        .I5(\queue_count_q_reg_n_0_[13][1] ),
        .O(\queue_count_q[15][1]_i_64_n_0 ));
  LUT6 #(
    .INIT(64'hFCAF0CAFFCA00CA0)) 
    \queue_count_q[15][1]_i_65 
       (.I0(\queue_count_q_reg_n_0_[6][0] ),
        .I1(\queue_count_q_reg_n_0_[7][0] ),
        .I2(rr_ptr_q[0]),
        .I3(rr_ptr_q[1]),
        .I4(\queue_count_q_reg_n_0_[4][0] ),
        .I5(\queue_count_q_reg_n_0_[5][0] ),
        .O(\queue_count_q[15][1]_i_65_n_0 ));
  LUT6 #(
    .INIT(64'hFCAF0CAFFCA00CA0)) 
    \queue_count_q[15][1]_i_66 
       (.I0(\queue_count_q_reg_n_0_[2][0] ),
        .I1(\queue_count_q_reg_n_0_[3][0] ),
        .I2(rr_ptr_q[0]),
        .I3(rr_ptr_q[1]),
        .I4(\queue_count_q_reg_n_0_[0][0] ),
        .I5(\queue_count_q_reg_n_0_[1][0] ),
        .O(\queue_count_q[15][1]_i_66_n_0 ));
  LUT6 #(
    .INIT(64'hFCAF0CAFFCA00CA0)) 
    \queue_count_q[15][1]_i_67 
       (.I0(\queue_count_q_reg_n_0_[2][1] ),
        .I1(\queue_count_q_reg_n_0_[3][1] ),
        .I2(rr_ptr_q[0]),
        .I3(rr_ptr_q[1]),
        .I4(\queue_count_q_reg_n_0_[0][1] ),
        .I5(\queue_count_q_reg_n_0_[1][1] ),
        .O(\queue_count_q[15][1]_i_67_n_0 ));
  LUT6 #(
    .INIT(64'hFCAF0CAFFCA00CA0)) 
    \queue_count_q[15][1]_i_68 
       (.I0(\queue_count_q_reg_n_0_[6][1] ),
        .I1(\queue_count_q_reg_n_0_[7][1] ),
        .I2(rr_ptr_q[0]),
        .I3(rr_ptr_q[1]),
        .I4(\queue_count_q_reg_n_0_[4][1] ),
        .I5(\queue_count_q_reg_n_0_[5][1] ),
        .O(\queue_count_q[15][1]_i_68_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \queue_count_q[15][1]_i_69 
       (.I0(\queue_count_q_reg_n_0_[13][0] ),
        .I1(\queue_count_q_reg_n_0_[12][0] ),
        .I2(rr_ptr_q[1]),
        .I3(\queue_count_q_reg_n_0_[15][0] ),
        .I4(rr_ptr_q[0]),
        .I5(\queue_count_q_reg_n_0_[14][0] ),
        .O(\queue_count_q[15][1]_i_69_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT5 #(
    .INIT(32'h08000000)) 
    \queue_count_q[15][1]_i_7 
       (.I0(\queue_count_q[15][1]_i_16_n_0 ),
        .I1(\queue_count_q[15][1]_i_17_n_0 ),
        .I2(\queue_count_q[15][1]_i_18_n_0 ),
        .I3(\queue_count_q[15][1]_i_19_n_0 ),
        .I4(\queue_count_q[15][1]_i_20_n_0 ),
        .O(\queue_count_q[15][1]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \queue_count_q[15][1]_i_70 
       (.I0(\queue_count_q_reg_n_0_[9][0] ),
        .I1(\queue_count_q_reg_n_0_[8][0] ),
        .I2(rr_ptr_q[1]),
        .I3(\queue_count_q_reg_n_0_[11][0] ),
        .I4(rr_ptr_q[0]),
        .I5(\queue_count_q_reg_n_0_[10][0] ),
        .O(\queue_count_q[15][1]_i_70_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \queue_count_q[15][1]_i_71 
       (.I0(\queue_count_q_reg_n_0_[13][1] ),
        .I1(\queue_count_q_reg_n_0_[12][1] ),
        .I2(rr_ptr_q[1]),
        .I3(\queue_count_q_reg_n_0_[15][1] ),
        .I4(rr_ptr_q[0]),
        .I5(\queue_count_q_reg_n_0_[14][1] ),
        .O(\queue_count_q[15][1]_i_71_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \queue_count_q[15][1]_i_72 
       (.I0(\queue_count_q_reg_n_0_[9][1] ),
        .I1(\queue_count_q_reg_n_0_[8][1] ),
        .I2(rr_ptr_q[1]),
        .I3(\queue_count_q_reg_n_0_[11][1] ),
        .I4(rr_ptr_q[0]),
        .I5(\queue_count_q_reg_n_0_[10][1] ),
        .O(\queue_count_q[15][1]_i_72_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \queue_count_q[15][1]_i_73 
       (.I0(\queue_count_q_reg_n_0_[5][0] ),
        .I1(\queue_count_q_reg_n_0_[4][0] ),
        .I2(rr_ptr_q[1]),
        .I3(\queue_count_q_reg_n_0_[7][0] ),
        .I4(rr_ptr_q[0]),
        .I5(\queue_count_q_reg_n_0_[6][0] ),
        .O(\queue_count_q[15][1]_i_73_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \queue_count_q[15][1]_i_74 
       (.I0(\queue_count_q_reg_n_0_[1][0] ),
        .I1(\queue_count_q_reg_n_0_[0][0] ),
        .I2(rr_ptr_q[1]),
        .I3(\queue_count_q_reg_n_0_[3][0] ),
        .I4(rr_ptr_q[0]),
        .I5(\queue_count_q_reg_n_0_[2][0] ),
        .O(\queue_count_q[15][1]_i_74_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \queue_count_q[15][1]_i_75 
       (.I0(\queue_count_q_reg_n_0_[5][1] ),
        .I1(\queue_count_q_reg_n_0_[4][1] ),
        .I2(rr_ptr_q[1]),
        .I3(\queue_count_q_reg_n_0_[7][1] ),
        .I4(rr_ptr_q[0]),
        .I5(\queue_count_q_reg_n_0_[6][1] ),
        .O(\queue_count_q[15][1]_i_75_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \queue_count_q[15][1]_i_76 
       (.I0(\queue_count_q_reg_n_0_[1][1] ),
        .I1(\queue_count_q_reg_n_0_[0][1] ),
        .I2(rr_ptr_q[1]),
        .I3(\queue_count_q_reg_n_0_[3][1] ),
        .I4(rr_ptr_q[0]),
        .I5(\queue_count_q_reg_n_0_[2][1] ),
        .O(\queue_count_q[15][1]_i_76_n_0 ));
  LUT6 #(
    .INIT(64'hFCAF0CAFFCA00CA0)) 
    \queue_count_q[15][1]_i_77 
       (.I0(\queue_count_q_reg_n_0_[12][0] ),
        .I1(\queue_count_q_reg_n_0_[13][0] ),
        .I2(rr_ptr_q[0]),
        .I3(rr_ptr_q[1]),
        .I4(\queue_count_q_reg_n_0_[14][0] ),
        .I5(\queue_count_q_reg_n_0_[15][0] ),
        .O(\queue_count_q[15][1]_i_77_n_0 ));
  LUT6 #(
    .INIT(64'hFCAF0CAFFCA00CA0)) 
    \queue_count_q[15][1]_i_78 
       (.I0(\queue_count_q_reg_n_0_[8][0] ),
        .I1(\queue_count_q_reg_n_0_[9][0] ),
        .I2(rr_ptr_q[0]),
        .I3(rr_ptr_q[1]),
        .I4(\queue_count_q_reg_n_0_[10][0] ),
        .I5(\queue_count_q_reg_n_0_[11][0] ),
        .O(\queue_count_q[15][1]_i_78_n_0 ));
  LUT6 #(
    .INIT(64'hFCAF0CAFFCA00CA0)) 
    \queue_count_q[15][1]_i_79 
       (.I0(\queue_count_q_reg_n_0_[12][1] ),
        .I1(\queue_count_q_reg_n_0_[13][1] ),
        .I2(rr_ptr_q[0]),
        .I3(rr_ptr_q[1]),
        .I4(\queue_count_q_reg_n_0_[14][1] ),
        .I5(\queue_count_q_reg_n_0_[15][1] ),
        .O(\queue_count_q[15][1]_i_79_n_0 ));
  (* OPT_MODIFIED = "RETARGET" *) 
  LUT6 #(
    .INIT(64'hFA0AFCFCFA0A0C0C)) 
    \queue_count_q[15][1]_i_8 
       (.I0(\queue_count_q[1][1]_i_2_n_0 ),
        .I1(\queue_count_q[0][1]_i_2_n_0 ),
        .I2(\out_addr_q[1]_i_1_n_0 ),
        .I3(\queue_count_q[3][1]_i_2_n_0 ),
        .I4(\out_addr_q[0]_i_1_n_0 ),
        .I5(\queue_count_q[2][1]_i_2_n_0 ),
        .O(\queue_count_q[15][1]_i_8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT3 #(
    .INIT(8'h56)) 
    \queue_count_q[15][1]_i_80 
       (.I0(rr_ptr_q[2]),
        .I1(rr_ptr_q[1]),
        .I2(rr_ptr_q[0]),
        .O(\queue_count_q[15][1]_i_80_n_0 ));
  LUT6 #(
    .INIT(64'hFCAF0CAFFCA00CA0)) 
    \queue_count_q[15][1]_i_81 
       (.I0(\queue_count_q_reg_n_0_[8][1] ),
        .I1(\queue_count_q_reg_n_0_[9][1] ),
        .I2(rr_ptr_q[0]),
        .I3(rr_ptr_q[1]),
        .I4(\queue_count_q_reg_n_0_[10][1] ),
        .I5(\queue_count_q_reg_n_0_[11][1] ),
        .O(\queue_count_q[15][1]_i_81_n_0 ));
  LUT6 #(
    .INIT(64'hFCAF0CAFFCA00CA0)) 
    \queue_count_q[15][1]_i_82 
       (.I0(\queue_count_q_reg_n_0_[4][0] ),
        .I1(\queue_count_q_reg_n_0_[5][0] ),
        .I2(rr_ptr_q[0]),
        .I3(rr_ptr_q[1]),
        .I4(\queue_count_q_reg_n_0_[6][0] ),
        .I5(\queue_count_q_reg_n_0_[7][0] ),
        .O(\queue_count_q[15][1]_i_82_n_0 ));
  LUT6 #(
    .INIT(64'hFCAF0CAFFCA00CA0)) 
    \queue_count_q[15][1]_i_83 
       (.I0(\queue_count_q_reg_n_0_[0][0] ),
        .I1(\queue_count_q_reg_n_0_[1][0] ),
        .I2(rr_ptr_q[0]),
        .I3(rr_ptr_q[1]),
        .I4(\queue_count_q_reg_n_0_[2][0] ),
        .I5(\queue_count_q_reg_n_0_[3][0] ),
        .O(\queue_count_q[15][1]_i_83_n_0 ));
  LUT6 #(
    .INIT(64'hFCAF0CAFFCA00CA0)) 
    \queue_count_q[15][1]_i_84 
       (.I0(\queue_count_q_reg_n_0_[4][1] ),
        .I1(\queue_count_q_reg_n_0_[5][1] ),
        .I2(rr_ptr_q[0]),
        .I3(rr_ptr_q[1]),
        .I4(\queue_count_q_reg_n_0_[6][1] ),
        .I5(\queue_count_q_reg_n_0_[7][1] ),
        .O(\queue_count_q[15][1]_i_84_n_0 ));
  LUT6 #(
    .INIT(64'hFCAF0CAFFCA00CA0)) 
    \queue_count_q[15][1]_i_85 
       (.I0(\queue_count_q_reg_n_0_[0][1] ),
        .I1(\queue_count_q_reg_n_0_[1][1] ),
        .I2(rr_ptr_q[0]),
        .I3(rr_ptr_q[1]),
        .I4(\queue_count_q_reg_n_0_[2][1] ),
        .I5(\queue_count_q_reg_n_0_[3][1] ),
        .O(\queue_count_q[15][1]_i_85_n_0 ));
  (* OPT_MODIFIED = "RETARGET" *) 
  LUT6 #(
    .INIT(64'hFA0AFCFCFA0A0C0C)) 
    \queue_count_q[15][1]_i_9 
       (.I0(\queue_count_q[9][1]_i_2_n_0 ),
        .I1(\queue_count_q[8][1]_i_2_n_0 ),
        .I2(\out_addr_q[1]_i_1_n_0 ),
        .I3(\queue_count_q[11][1]_i_2_n_0 ),
        .I4(\out_addr_q[0]_i_1_n_0 ),
        .I5(\queue_count_q[10][1]_i_2_n_0 ),
        .O(\queue_count_q[15][1]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAA9AFFFFAA9A0000)) 
    \queue_count_q[1][0]_i_1 
       (.I0(\queue_count_q_reg_n_0_[1][0] ),
        .I1(src_ack_async_OBUF[1]),
        .I2(req_sync_q[1]),
        .I3(\queue_count_q_reg_n_0_[1][1] ),
        .I4(\queue_count_q[1][1]_i_3_n_0 ),
        .I5(\queue_count_q[15][1]_i_3_n_0 ),
        .O(\queue_count_d[1]__0 [0]));
  LUT5 #(
    .INIT(32'h44747747)) 
    \queue_count_q[1][1]_i_1 
       (.I0(\queue_count_q[1][1]_i_2_n_0 ),
        .I1(\queue_count_q[1][1]_i_3_n_0 ),
        .I2(\queue_count_q[14][1]_i_2_n_0 ),
        .I3(\queue_count_q[14][1]_i_3_n_0 ),
        .I4(\queue_count_q[15][1]_i_3_n_0 ),
        .O(\queue_count_d[1]__0 [1]));
  LUT4 #(
    .INIT(16'h5155)) 
    \queue_count_q[1][1]_i_2 
       (.I0(\queue_count_q_reg_n_0_[1][1] ),
        .I1(req_sync_q[1]),
        .I2(src_ack_async_OBUF[1]),
        .I3(\queue_count_q_reg_n_0_[1][0] ),
        .O(\queue_count_q[1][1]_i_2_n_0 ));
  (* OPT_MODIFIED = "RETARGET" *) 
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT5 #(
    .INIT(32'hFFFFFFDF)) 
    \queue_count_q[1][1]_i_3 
       (.I0(\out_addr_q[0]_i_1_n_0 ),
        .I1(\out_addr_q[1]_i_1_n_0 ),
        .I2(\rr_ptr_q[3]_i_1_n_0 ),
        .I3(\out_addr_q[3]_i_1_n_0 ),
        .I4(\out_addr_q[2]_i_1_n_0 ),
        .O(\queue_count_q[1][1]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAA9AFFFFAA9A0000)) 
    \queue_count_q[2][0]_i_1 
       (.I0(\queue_count_q_reg_n_0_[2][0] ),
        .I1(src_ack_async_OBUF[2]),
        .I2(req_sync_q[2]),
        .I3(\queue_count_q_reg_n_0_[2][1] ),
        .I4(\queue_count_q[2][1]_i_3_n_0 ),
        .I5(\queue_count_q[15][1]_i_3_n_0 ),
        .O(\queue_count_d[2] [0]));
  LUT5 #(
    .INIT(32'h00FF2D2D)) 
    \queue_count_q[2][1]_i_1 
       (.I0(\queue_count_q[14][1]_i_2_n_0 ),
        .I1(\queue_count_q[14][1]_i_3_n_0 ),
        .I2(\queue_count_q[15][1]_i_3_n_0 ),
        .I3(\queue_count_q[2][1]_i_2_n_0 ),
        .I4(\queue_count_q[2][1]_i_3_n_0 ),
        .O(\queue_count_d[2] [1]));
  LUT4 #(
    .INIT(16'h5155)) 
    \queue_count_q[2][1]_i_2 
       (.I0(\queue_count_q_reg_n_0_[2][1] ),
        .I1(req_sync_q[2]),
        .I2(src_ack_async_OBUF[2]),
        .I3(\queue_count_q_reg_n_0_[2][0] ),
        .O(\queue_count_q[2][1]_i_2_n_0 ));
  (* OPT_MODIFIED = "RETARGET" *) 
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT5 #(
    .INIT(32'hFFFFFFBF)) 
    \queue_count_q[2][1]_i_3 
       (.I0(\out_addr_q[0]_i_1_n_0 ),
        .I1(\out_addr_q[1]_i_1_n_0 ),
        .I2(\rr_ptr_q[3]_i_1_n_0 ),
        .I3(\out_addr_q[3]_i_1_n_0 ),
        .I4(\out_addr_q[2]_i_1_n_0 ),
        .O(\queue_count_q[2][1]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAA9AFFFFAA9A0000)) 
    \queue_count_q[3][0]_i_1 
       (.I0(\queue_count_q_reg_n_0_[3][0] ),
        .I1(src_ack_async_OBUF[3]),
        .I2(req_sync_q[3]),
        .I3(\queue_count_q_reg_n_0_[3][1] ),
        .I4(\queue_count_q[3][1]_i_3_n_0 ),
        .I5(\queue_count_q[15][1]_i_3_n_0 ),
        .O(\queue_count_d[3] [0]));
  LUT5 #(
    .INIT(32'h44747747)) 
    \queue_count_q[3][1]_i_1 
       (.I0(\queue_count_q[3][1]_i_2_n_0 ),
        .I1(\queue_count_q[3][1]_i_3_n_0 ),
        .I2(\queue_count_q[14][1]_i_2_n_0 ),
        .I3(\queue_count_q[14][1]_i_3_n_0 ),
        .I4(\queue_count_q[15][1]_i_3_n_0 ),
        .O(\queue_count_d[3] [1]));
  LUT4 #(
    .INIT(16'h5155)) 
    \queue_count_q[3][1]_i_2 
       (.I0(\queue_count_q_reg_n_0_[3][1] ),
        .I1(req_sync_q[3]),
        .I2(src_ack_async_OBUF[3]),
        .I3(\queue_count_q_reg_n_0_[3][0] ),
        .O(\queue_count_q[3][1]_i_2_n_0 ));
  (* OPT_MODIFIED = "RETARGET" *) 
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT5 #(
    .INIT(32'hFFF7FFFF)) 
    \queue_count_q[3][1]_i_3 
       (.I0(\out_addr_q[1]_i_1_n_0 ),
        .I1(\out_addr_q[0]_i_1_n_0 ),
        .I2(\out_addr_q[3]_i_1_n_0 ),
        .I3(\out_addr_q[2]_i_1_n_0 ),
        .I4(\rr_ptr_q[3]_i_1_n_0 ),
        .O(\queue_count_q[3][1]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAA9AFFFFAA9A0000)) 
    \queue_count_q[4][0]_i_1 
       (.I0(\queue_count_q_reg_n_0_[4][0] ),
        .I1(src_ack_async_OBUF[4]),
        .I2(req_sync_q[4]),
        .I3(\queue_count_q_reg_n_0_[4][1] ),
        .I4(\queue_count_q[4][1]_i_3_n_0 ),
        .I5(\queue_count_q[15][1]_i_3_n_0 ),
        .O(\queue_count_d[4] [0]));
  LUT5 #(
    .INIT(32'h00FF2D2D)) 
    \queue_count_q[4][1]_i_1 
       (.I0(\queue_count_q[14][1]_i_2_n_0 ),
        .I1(\queue_count_q[14][1]_i_3_n_0 ),
        .I2(\queue_count_q[15][1]_i_3_n_0 ),
        .I3(\queue_count_q[4][1]_i_2_n_0 ),
        .I4(\queue_count_q[4][1]_i_3_n_0 ),
        .O(\queue_count_d[4] [1]));
  LUT4 #(
    .INIT(16'h5155)) 
    \queue_count_q[4][1]_i_2 
       (.I0(\queue_count_q_reg_n_0_[4][1] ),
        .I1(req_sync_q[4]),
        .I2(src_ack_async_OBUF[4]),
        .I3(\queue_count_q_reg_n_0_[4][0] ),
        .O(\queue_count_q[4][1]_i_2_n_0 ));
  (* OPT_MODIFIED = "RETARGET" *) 
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT5 #(
    .INIT(32'hFFEFFFFF)) 
    \queue_count_q[4][1]_i_3 
       (.I0(\out_addr_q[1]_i_1_n_0 ),
        .I1(\out_addr_q[0]_i_1_n_0 ),
        .I2(\rr_ptr_q[3]_i_1_n_0 ),
        .I3(\out_addr_q[3]_i_1_n_0 ),
        .I4(\out_addr_q[2]_i_1_n_0 ),
        .O(\queue_count_q[4][1]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAA9AFFFFAA9A0000)) 
    \queue_count_q[5][0]_i_1 
       (.I0(\queue_count_q_reg_n_0_[5][0] ),
        .I1(src_ack_async_OBUF[5]),
        .I2(req_sync_q[5]),
        .I3(\queue_count_q_reg_n_0_[5][1] ),
        .I4(\queue_count_q[5][1]_i_3_n_0 ),
        .I5(\queue_count_q[15][1]_i_3_n_0 ),
        .O(\queue_count_d[5] [0]));
  LUT5 #(
    .INIT(32'h44747747)) 
    \queue_count_q[5][1]_i_1 
       (.I0(\queue_count_q[5][1]_i_2_n_0 ),
        .I1(\queue_count_q[5][1]_i_3_n_0 ),
        .I2(\queue_count_q[14][1]_i_2_n_0 ),
        .I3(\queue_count_q[14][1]_i_3_n_0 ),
        .I4(\queue_count_q[15][1]_i_3_n_0 ),
        .O(\queue_count_d[5] [1]));
  LUT4 #(
    .INIT(16'h5155)) 
    \queue_count_q[5][1]_i_2 
       (.I0(\queue_count_q_reg_n_0_[5][1] ),
        .I1(req_sync_q[5]),
        .I2(src_ack_async_OBUF[5]),
        .I3(\queue_count_q_reg_n_0_[5][0] ),
        .O(\queue_count_q[5][1]_i_2_n_0 ));
  (* OPT_MODIFIED = "RETARGET" *) 
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT5 #(
    .INIT(32'hFFDFFFFF)) 
    \queue_count_q[5][1]_i_3 
       (.I0(\out_addr_q[0]_i_1_n_0 ),
        .I1(\out_addr_q[1]_i_1_n_0 ),
        .I2(\rr_ptr_q[3]_i_1_n_0 ),
        .I3(\out_addr_q[3]_i_1_n_0 ),
        .I4(\out_addr_q[2]_i_1_n_0 ),
        .O(\queue_count_q[5][1]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAA9AFFFFAA9A0000)) 
    \queue_count_q[6][0]_i_1 
       (.I0(\queue_count_q_reg_n_0_[6][0] ),
        .I1(src_ack_async_OBUF[6]),
        .I2(req_sync_q[6]),
        .I3(\queue_count_q_reg_n_0_[6][1] ),
        .I4(\queue_count_q[6][1]_i_3_n_0 ),
        .I5(\queue_count_q[15][1]_i_3_n_0 ),
        .O(\queue_count_d[6] [0]));
  LUT5 #(
    .INIT(32'h00FF2D2D)) 
    \queue_count_q[6][1]_i_1 
       (.I0(\queue_count_q[14][1]_i_2_n_0 ),
        .I1(\queue_count_q[14][1]_i_3_n_0 ),
        .I2(\queue_count_q[15][1]_i_3_n_0 ),
        .I3(\queue_count_q[6][1]_i_2_n_0 ),
        .I4(\queue_count_q[6][1]_i_3_n_0 ),
        .O(\queue_count_d[6] [1]));
  LUT4 #(
    .INIT(16'h5155)) 
    \queue_count_q[6][1]_i_2 
       (.I0(\queue_count_q_reg_n_0_[6][1] ),
        .I1(req_sync_q[6]),
        .I2(src_ack_async_OBUF[6]),
        .I3(\queue_count_q_reg_n_0_[6][0] ),
        .O(\queue_count_q[6][1]_i_2_n_0 ));
  (* OPT_MODIFIED = "RETARGET" *) 
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT5 #(
    .INIT(32'hFFBFFFFF)) 
    \queue_count_q[6][1]_i_3 
       (.I0(\out_addr_q[0]_i_1_n_0 ),
        .I1(\out_addr_q[1]_i_1_n_0 ),
        .I2(\rr_ptr_q[3]_i_1_n_0 ),
        .I3(\out_addr_q[3]_i_1_n_0 ),
        .I4(\out_addr_q[2]_i_1_n_0 ),
        .O(\queue_count_q[6][1]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAA9AFFFFAA9A0000)) 
    \queue_count_q[7][0]_i_1 
       (.I0(\queue_count_q_reg_n_0_[7][0] ),
        .I1(src_ack_async_OBUF[7]),
        .I2(req_sync_q[7]),
        .I3(\queue_count_q_reg_n_0_[7][1] ),
        .I4(\queue_count_q[7][1]_i_3_n_0 ),
        .I5(\queue_count_q[15][1]_i_3_n_0 ),
        .O(\queue_count_d[7] [0]));
  LUT5 #(
    .INIT(32'h44747747)) 
    \queue_count_q[7][1]_i_1 
       (.I0(\queue_count_q[7][1]_i_2_n_0 ),
        .I1(\queue_count_q[7][1]_i_3_n_0 ),
        .I2(\queue_count_q[14][1]_i_2_n_0 ),
        .I3(\queue_count_q[14][1]_i_3_n_0 ),
        .I4(\queue_count_q[15][1]_i_3_n_0 ),
        .O(\queue_count_d[7] [1]));
  LUT4 #(
    .INIT(16'h5155)) 
    \queue_count_q[7][1]_i_2 
       (.I0(\queue_count_q_reg_n_0_[7][1] ),
        .I1(req_sync_q[7]),
        .I2(src_ack_async_OBUF[7]),
        .I3(\queue_count_q_reg_n_0_[7][0] ),
        .O(\queue_count_q[7][1]_i_2_n_0 ));
  (* OPT_MODIFIED = "RETARGET" *) 
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT5 #(
    .INIT(32'hF7FFFFFF)) 
    \queue_count_q[7][1]_i_3 
       (.I0(\out_addr_q[1]_i_1_n_0 ),
        .I1(\out_addr_q[0]_i_1_n_0 ),
        .I2(\out_addr_q[3]_i_1_n_0 ),
        .I3(\out_addr_q[2]_i_1_n_0 ),
        .I4(\rr_ptr_q[3]_i_1_n_0 ),
        .O(\queue_count_q[7][1]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAA9AFFFFAA9A0000)) 
    \queue_count_q[8][0]_i_1 
       (.I0(\queue_count_q_reg_n_0_[8][0] ),
        .I1(src_ack_async_OBUF[8]),
        .I2(req_sync_q[8]),
        .I3(\queue_count_q_reg_n_0_[8][1] ),
        .I4(\queue_count_q[8][1]_i_3_n_0 ),
        .I5(\queue_count_q[15][1]_i_3_n_0 ),
        .O(\queue_count_d[8] [0]));
  LUT5 #(
    .INIT(32'h44747747)) 
    \queue_count_q[8][1]_i_1 
       (.I0(\queue_count_q[8][1]_i_2_n_0 ),
        .I1(\queue_count_q[8][1]_i_3_n_0 ),
        .I2(\queue_count_q[14][1]_i_2_n_0 ),
        .I3(\queue_count_q[14][1]_i_3_n_0 ),
        .I4(\queue_count_q[15][1]_i_3_n_0 ),
        .O(\queue_count_d[8] [1]));
  LUT4 #(
    .INIT(16'h5155)) 
    \queue_count_q[8][1]_i_2 
       (.I0(\queue_count_q_reg_n_0_[8][1] ),
        .I1(req_sync_q[8]),
        .I2(src_ack_async_OBUF[8]),
        .I3(\queue_count_q_reg_n_0_[8][0] ),
        .O(\queue_count_q[8][1]_i_2_n_0 ));
  (* OPT_MODIFIED = "RETARGET" *) 
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT5 #(
    .INIT(32'hFFEFFFFF)) 
    \queue_count_q[8][1]_i_3 
       (.I0(\out_addr_q[1]_i_1_n_0 ),
        .I1(\out_addr_q[0]_i_1_n_0 ),
        .I2(\rr_ptr_q[3]_i_1_n_0 ),
        .I3(\out_addr_q[2]_i_1_n_0 ),
        .I4(\out_addr_q[3]_i_1_n_0 ),
        .O(\queue_count_q[8][1]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAA9AFFFFAA9A0000)) 
    \queue_count_q[9][0]_i_1 
       (.I0(\queue_count_q_reg_n_0_[9][0] ),
        .I1(src_ack_async_OBUF[9]),
        .I2(req_sync_q[9]),
        .I3(\queue_count_q_reg_n_0_[9][1] ),
        .I4(\queue_count_q[9][1]_i_3_n_0 ),
        .I5(\queue_count_q[15][1]_i_3_n_0 ),
        .O(\queue_count_d[9] [0]));
  LUT5 #(
    .INIT(32'h00FF2D2D)) 
    \queue_count_q[9][1]_i_1 
       (.I0(\queue_count_q[14][1]_i_2_n_0 ),
        .I1(\queue_count_q[14][1]_i_3_n_0 ),
        .I2(\queue_count_q[15][1]_i_3_n_0 ),
        .I3(\queue_count_q[9][1]_i_2_n_0 ),
        .I4(\queue_count_q[9][1]_i_3_n_0 ),
        .O(\queue_count_d[9] [1]));
  LUT4 #(
    .INIT(16'h5155)) 
    \queue_count_q[9][1]_i_2 
       (.I0(\queue_count_q_reg_n_0_[9][1] ),
        .I1(req_sync_q[9]),
        .I2(src_ack_async_OBUF[9]),
        .I3(\queue_count_q_reg_n_0_[9][0] ),
        .O(\queue_count_q[9][1]_i_2_n_0 ));
  (* OPT_MODIFIED = "RETARGET" *) 
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT5 #(
    .INIT(32'hFFDFFFFF)) 
    \queue_count_q[9][1]_i_3 
       (.I0(\out_addr_q[0]_i_1_n_0 ),
        .I1(\out_addr_q[1]_i_1_n_0 ),
        .I2(\rr_ptr_q[3]_i_1_n_0 ),
        .I3(\out_addr_q[2]_i_1_n_0 ),
        .I4(\out_addr_q[3]_i_1_n_0 ),
        .O(\queue_count_q[9][1]_i_3_n_0 ));
  FDCE \queue_count_q_reg[0][0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\queue_count_d[0]__0 [0]),
        .Q(\queue_count_q_reg_n_0_[0][0] ));
  FDCE \queue_count_q_reg[0][1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\queue_count_d[0]__0 [1]),
        .Q(\queue_count_q_reg_n_0_[0][1] ));
  FDCE \queue_count_q_reg[10][0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\queue_count_d[10] [0]),
        .Q(\queue_count_q_reg_n_0_[10][0] ));
  FDCE \queue_count_q_reg[10][1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\queue_count_d[10] [1]),
        .Q(\queue_count_q_reg_n_0_[10][1] ));
  FDCE \queue_count_q_reg[11][0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\queue_count_d[11] [0]),
        .Q(\queue_count_q_reg_n_0_[11][0] ));
  FDCE \queue_count_q_reg[11][1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\queue_count_d[11] [1]),
        .Q(\queue_count_q_reg_n_0_[11][1] ));
  FDCE \queue_count_q_reg[12][0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\queue_count_d[12] [0]),
        .Q(\queue_count_q_reg_n_0_[12][0] ));
  FDCE \queue_count_q_reg[12][1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\queue_count_d[12] [1]),
        .Q(\queue_count_q_reg_n_0_[12][1] ));
  FDCE \queue_count_q_reg[13][0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\queue_count_d[13] [0]),
        .Q(\queue_count_q_reg_n_0_[13][0] ));
  FDCE \queue_count_q_reg[13][1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\queue_count_d[13] [1]),
        .Q(\queue_count_q_reg_n_0_[13][1] ));
  FDCE \queue_count_q_reg[14][0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\queue_count_d[14] [0]),
        .Q(\queue_count_q_reg_n_0_[14][0] ));
  FDCE \queue_count_q_reg[14][1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\queue_count_d[14] [1]),
        .Q(\queue_count_q_reg_n_0_[14][1] ));
  FDCE \queue_count_q_reg[15][0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\queue_count_d[15] [0]),
        .Q(\queue_count_q_reg_n_0_[15][0] ));
  FDCE \queue_count_q_reg[15][1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\queue_count_d[15] [1]),
        .Q(\queue_count_q_reg_n_0_[15][1] ));
  MUXF7 \queue_count_q_reg[15][1]_i_42 
       (.I0(\queue_count_q[15][1]_i_55_n_0 ),
        .I1(\queue_count_q[15][1]_i_56_n_0 ),
        .O(\queue_count_q_reg[15][1]_i_42_n_0 ),
        .S(rr_ptr_q[1]));
  FDCE \queue_count_q_reg[1][0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\queue_count_d[1]__0 [0]),
        .Q(\queue_count_q_reg_n_0_[1][0] ));
  FDCE \queue_count_q_reg[1][1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\queue_count_d[1]__0 [1]),
        .Q(\queue_count_q_reg_n_0_[1][1] ));
  FDCE \queue_count_q_reg[2][0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\queue_count_d[2] [0]),
        .Q(\queue_count_q_reg_n_0_[2][0] ));
  FDCE \queue_count_q_reg[2][1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\queue_count_d[2] [1]),
        .Q(\queue_count_q_reg_n_0_[2][1] ));
  FDCE \queue_count_q_reg[3][0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\queue_count_d[3] [0]),
        .Q(\queue_count_q_reg_n_0_[3][0] ));
  FDCE \queue_count_q_reg[3][1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\queue_count_d[3] [1]),
        .Q(\queue_count_q_reg_n_0_[3][1] ));
  FDCE \queue_count_q_reg[4][0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\queue_count_d[4] [0]),
        .Q(\queue_count_q_reg_n_0_[4][0] ));
  FDCE \queue_count_q_reg[4][1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\queue_count_d[4] [1]),
        .Q(\queue_count_q_reg_n_0_[4][1] ));
  FDCE \queue_count_q_reg[5][0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\queue_count_d[5] [0]),
        .Q(\queue_count_q_reg_n_0_[5][0] ));
  FDCE \queue_count_q_reg[5][1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\queue_count_d[5] [1]),
        .Q(\queue_count_q_reg_n_0_[5][1] ));
  FDCE \queue_count_q_reg[6][0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\queue_count_d[6] [0]),
        .Q(\queue_count_q_reg_n_0_[6][0] ));
  FDCE \queue_count_q_reg[6][1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\queue_count_d[6] [1]),
        .Q(\queue_count_q_reg_n_0_[6][1] ));
  FDCE \queue_count_q_reg[7][0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\queue_count_d[7] [0]),
        .Q(\queue_count_q_reg_n_0_[7][0] ));
  FDCE \queue_count_q_reg[7][1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\queue_count_d[7] [1]),
        .Q(\queue_count_q_reg_n_0_[7][1] ));
  FDCE \queue_count_q_reg[8][0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\queue_count_d[8] [0]),
        .Q(\queue_count_q_reg_n_0_[8][0] ));
  FDCE \queue_count_q_reg[8][1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\queue_count_d[8] [1]),
        .Q(\queue_count_q_reg_n_0_[8][1] ));
  FDCE \queue_count_q_reg[9][0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\queue_count_d[9] [0]),
        .Q(\queue_count_q_reg_n_0_[9][0] ));
  FDCE \queue_count_q_reg[9][1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\queue_count_d[9] [1]),
        .Q(\queue_count_q_reg_n_0_[9][1] ));
  LUT1 #(
    .INIT(2'h1)) 
    \req_meta_q[15]_i_1 
       (.I0(rst_n_IBUF),
        .O(\req_meta_q[15]_i_1_n_0 ));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(src_req_async_IBUF[0]),
        .Q(req_meta_q[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(src_req_async_IBUF[10]),
        .Q(req_meta_q[10]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(src_req_async_IBUF[11]),
        .Q(req_meta_q[11]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(src_req_async_IBUF[12]),
        .Q(req_meta_q[12]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(src_req_async_IBUF[13]),
        .Q(req_meta_q[13]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(src_req_async_IBUF[14]),
        .Q(req_meta_q[14]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(src_req_async_IBUF[15]),
        .Q(req_meta_q[15]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(src_req_async_IBUF[1]),
        .Q(req_meta_q[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(src_req_async_IBUF[2]),
        .Q(req_meta_q[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(src_req_async_IBUF[3]),
        .Q(req_meta_q[3]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(src_req_async_IBUF[4]),
        .Q(req_meta_q[4]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(src_req_async_IBUF[5]),
        .Q(req_meta_q[5]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(src_req_async_IBUF[6]),
        .Q(req_meta_q[6]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(src_req_async_IBUF[7]),
        .Q(req_meta_q[7]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(src_req_async_IBUF[8]),
        .Q(req_meta_q[8]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(src_req_async_IBUF[9]),
        .Q(req_meta_q[9]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(req_meta_q[0]),
        .Q(req_sync_q[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(req_meta_q[10]),
        .Q(req_sync_q[10]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(req_meta_q[11]),
        .Q(req_sync_q[11]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(req_meta_q[12]),
        .Q(req_sync_q[12]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(req_meta_q[13]),
        .Q(req_sync_q[13]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(req_meta_q[14]),
        .Q(req_sync_q[14]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(req_meta_q[15]),
        .Q(req_sync_q[15]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(req_meta_q[1]),
        .Q(req_sync_q[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(req_meta_q[2]),
        .Q(req_sync_q[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(req_meta_q[3]),
        .Q(req_sync_q[3]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(req_meta_q[4]),
        .Q(req_sync_q[4]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(req_meta_q[5]),
        .Q(req_sync_q[5]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(req_meta_q[6]),
        .Q(req_sync_q[6]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(req_meta_q[7]),
        .Q(req_sync_q[7]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(req_meta_q[8]),
        .Q(req_sync_q[8]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(req_meta_q[9]),
        .Q(req_sync_q[9]));
  LUT1 #(
    .INIT(2'h1)) 
    \rr_ptr_q[0]_i_1 
       (.I0(\out_addr_q[0]_i_1_n_0 ),
        .O(p_0_in[0]));
  (* OPT_MODIFIED = "RETARGET" *) 
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \rr_ptr_q[1]_i_1 
       (.I0(\out_addr_q[1]_i_1_n_0 ),
        .I1(\out_addr_q[0]_i_1_n_0 ),
        .O(\rr_ptr_q[1]_i_1_n_0 ));
  (* OPT_MODIFIED = "RETARGET" *) 
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \rr_ptr_q[2]_i_1 
       (.I0(\out_addr_q[1]_i_1_n_0 ),
        .I1(\out_addr_q[0]_i_1_n_0 ),
        .I2(\out_addr_q[2]_i_1_n_0 ),
        .O(\rr_ptr_q[2]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h0B)) 
    \rr_ptr_q[3]_i_1 
       (.I0(out_ready_IBUF),
        .I1(out_valid_OBUF),
        .I2(\queue_count_q[15][1]_i_7_n_0 ),
        .O(\rr_ptr_q[3]_i_1_n_0 ));
  (* OPT_MODIFIED = "RETARGET" *) 
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT4 #(
    .INIT(16'h78F0)) 
    \rr_ptr_q[3]_i_2 
       (.I0(\out_addr_q[1]_i_1_n_0 ),
        .I1(\out_addr_q[0]_i_1_n_0 ),
        .I2(\out_addr_q[3]_i_1_n_0 ),
        .I3(\out_addr_q[2]_i_1_n_0 ),
        .O(p_0_in[3]));
  (* OPT_MODIFIED = "RETARGET" *) 
  LUT4 #(
    .INIT(16'hBFBB)) 
    \rr_ptr_q[3]_i_3 
       (.I0(\rr_ptr_q[3]_i_4_n_0 ),
        .I1(\rr_ptr_q[3]_i_5_n_0 ),
        .I2(\rr_ptr_q[3]_i_6_n_0 ),
        .I3(\out_addr_q[3]_i_7_n_0 ),
        .O(\out_addr_q[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hEEFEAABEEFFFEBFF)) 
    \rr_ptr_q[3]_i_4 
       (.I0(\rr_ptr_q[3]_i_7_n_0 ),
        .I1(rr_ptr_q[1]),
        .I2(rr_ptr_q[0]),
        .I3(\out_addr_q[3]_i_12_n_0 ),
        .I4(\out_addr_q[3]_i_11_n_0 ),
        .I5(\out_addr_q[3]_i_9_n_0 ),
        .O(\rr_ptr_q[3]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'hBBE0)) 
    \rr_ptr_q[3]_i_5 
       (.I0(\out_addr_q[0]_i_4_n_0 ),
        .I1(rr_ptr_q[0]),
        .I2(\out_addr_q[0]_i_5_n_0 ),
        .I3(rr_ptr_q[1]),
        .O(\rr_ptr_q[3]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h0300030CCF00CA3A)) 
    \rr_ptr_q[3]_i_6 
       (.I0(\rr_ptr_q[3]_i_8_n_0 ),
        .I1(rr_ptr_q[0]),
        .I2(\out_addr_q[3]_i_27_n_0 ),
        .I3(rr_ptr_q[1]),
        .I4(\out_addr_q[3]_i_25_n_0 ),
        .I5(\out_addr_q[3]_i_24_n_0 ),
        .O(\rr_ptr_q[3]_i_6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'hCFC5F5C5)) 
    \rr_ptr_q[3]_i_7 
       (.I0(\out_addr_q[3]_i_14_n_0 ),
        .I1(\out_addr_q[3]_i_16_n_0 ),
        .I2(rr_ptr_q[1]),
        .I3(\out_addr_q[3]_i_17_n_0 ),
        .I4(rr_ptr_q[0]),
        .O(\rr_ptr_q[3]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h0004003440444333)) 
    \rr_ptr_q[3]_i_8 
       (.I0(\out_addr_q[3]_i_29_n_0 ),
        .I1(rr_ptr_q[1]),
        .I2(rr_ptr_q[0]),
        .I3(\out_addr_q[3]_i_22_n_0 ),
        .I4(\out_addr_q[3]_i_30_n_0 ),
        .I5(\out_addr_q[0]_i_10_n_0 ),
        .O(\rr_ptr_q[3]_i_8_n_0 ));
  FDCE \rr_ptr_q_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\rr_ptr_q[3]_i_1_n_0 ),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(p_0_in[0]),
        .Q(rr_ptr_q[0]));
  FDCE \rr_ptr_q_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\rr_ptr_q[3]_i_1_n_0 ),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\rr_ptr_q[1]_i_1_n_0 ),
        .Q(rr_ptr_q[1]));
  FDCE \rr_ptr_q_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\rr_ptr_q[3]_i_1_n_0 ),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(\rr_ptr_q[2]_i_1_n_0 ),
        .Q(rr_ptr_q[2]));
  FDCE \rr_ptr_q_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\rr_ptr_q[3]_i_1_n_0 ),
        .CLR(\req_meta_q[15]_i_1_n_0 ),
        .D(p_0_in[3]),
        .Q(rr_ptr_q[3]));
  IBUF rst_n_IBUF_inst
       (.I(rst_n),
        .O(rst_n_IBUF));
  OBUF \src_ack_async_OBUF[0]_inst 
       (.I(src_ack_async_OBUF[0]),
        .O(src_ack_async[0]));
  OBUF \src_ack_async_OBUF[10]_inst 
       (.I(src_ack_async_OBUF[10]),
        .O(src_ack_async[10]));
  OBUF \src_ack_async_OBUF[11]_inst 
       (.I(src_ack_async_OBUF[11]),
        .O(src_ack_async[11]));
  OBUF \src_ack_async_OBUF[12]_inst 
       (.I(src_ack_async_OBUF[12]),
        .O(src_ack_async[12]));
  OBUF \src_ack_async_OBUF[13]_inst 
       (.I(src_ack_async_OBUF[13]),
        .O(src_ack_async[13]));
  OBUF \src_ack_async_OBUF[14]_inst 
       (.I(src_ack_async_OBUF[14]),
        .O(src_ack_async[14]));
  OBUF \src_ack_async_OBUF[15]_inst 
       (.I(src_ack_async_OBUF[15]),
        .O(src_ack_async[15]));
  OBUF \src_ack_async_OBUF[1]_inst 
       (.I(src_ack_async_OBUF[1]),
        .O(src_ack_async[1]));
  OBUF \src_ack_async_OBUF[2]_inst 
       (.I(src_ack_async_OBUF[2]),
        .O(src_ack_async[2]));
  OBUF \src_ack_async_OBUF[3]_inst 
       (.I(src_ack_async_OBUF[3]),
        .O(src_ack_async[3]));
  OBUF \src_ack_async_OBUF[4]_inst 
       (.I(src_ack_async_OBUF[4]),
        .O(src_ack_async[4]));
  OBUF \src_ack_async_OBUF[5]_inst 
       (.I(src_ack_async_OBUF[5]),
        .O(src_ack_async[5]));
  OBUF \src_ack_async_OBUF[6]_inst 
       (.I(src_ack_async_OBUF[6]),
        .O(src_ack_async[6]));
  OBUF \src_ack_async_OBUF[7]_inst 
       (.I(src_ack_async_OBUF[7]),
        .O(src_ack_async[7]));
  OBUF \src_ack_async_OBUF[8]_inst 
       (.I(src_ack_async_OBUF[8]),
        .O(src_ack_async[8]));
  OBUF \src_ack_async_OBUF[9]_inst 
       (.I(src_ack_async_OBUF[9]),
        .O(src_ack_async[9]));
  IBUF \src_req_async_IBUF[0]_inst 
       (.I(src_req_async[0]),
        .O(src_req_async_IBUF[0]));
  IBUF \src_req_async_IBUF[10]_inst 
       (.I(src_req_async[10]),
        .O(src_req_async_IBUF[10]));
  IBUF \src_req_async_IBUF[11]_inst 
       (.I(src_req_async[11]),
        .O(src_req_async_IBUF[11]));
  IBUF \src_req_async_IBUF[12]_inst 
       (.I(src_req_async[12]),
        .O(src_req_async_IBUF[12]));
  IBUF \src_req_async_IBUF[13]_inst 
       (.I(src_req_async[13]),
        .O(src_req_async_IBUF[13]));
  IBUF \src_req_async_IBUF[14]_inst 
       (.I(src_req_async[14]),
        .O(src_req_async_IBUF[14]));
  IBUF \src_req_async_IBUF[15]_inst 
       (.I(src_req_async[15]),
        .O(src_req_async_IBUF[15]));
  IBUF \src_req_async_IBUF[1]_inst 
       (.I(src_req_async[1]),
        .O(src_req_async_IBUF[1]));
  IBUF \src_req_async_IBUF[2]_inst 
       (.I(src_req_async[2]),
        .O(src_req_async_IBUF[2]));
  IBUF \src_req_async_IBUF[3]_inst 
       (.I(src_req_async[3]),
        .O(src_req_async_IBUF[3]));
  IBUF \src_req_async_IBUF[4]_inst 
       (.I(src_req_async[4]),
        .O(src_req_async_IBUF[4]));
  IBUF \src_req_async_IBUF[5]_inst 
       (.I(src_req_async[5]),
        .O(src_req_async_IBUF[5]));
  IBUF \src_req_async_IBUF[6]_inst 
       (.I(src_req_async[6]),
        .O(src_req_async_IBUF[6]));
  IBUF \src_req_async_IBUF[7]_inst 
       (.I(src_req_async[7]),
        .O(src_req_async_IBUF[7]));
  IBUF \src_req_async_IBUF[8]_inst 
       (.I(src_req_async[8]),
        .O(src_req_async_IBUF[8]));
  IBUF \src_req_async_IBUF[9]_inst 
       (.I(src_req_async[9]),
        .O(src_req_async_IBUF[9]));
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
