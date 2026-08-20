// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Fri Aug 21 03:49:02 2026
// Host        : <LOCAL_HOST> running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               reports/p9_candidates/vivado_onehot_tree/aer_pending_direct_gray_scr_onehot_tree_post_synth.v
// Design      : aer_pending_direct_gray_scr_onehot_tree
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* NETLIST_CHECKSUM = "d05b39cf" *) 
(* NotValidForBitStream *)
module aer_pending_direct_gray_scr_onehot_tree
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

  wire [15:0]ack_d;
  wire [15:0]ack_q;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire \epoch_gray_q[0]_i_1_n_0 ;
  wire \epoch_gray_q[1]_i_1_n_0 ;
  wire \epoch_gray_q[2]_i_1_n_0 ;
  wire \epoch_gray_q[3]_i_1_n_0 ;
  wire \epoch_gray_q[3]_i_3_n_0 ;
  wire \epoch_gray_q[3]_i_4_n_0 ;
  wire \epoch_gray_q_reg_n_0_[0] ;
  wire \epoch_gray_q_reg_n_0_[2] ;
  wire \epoch_gray_q_reg_n_0_[3] ;
  wire [3:0]out_addr;
  wire [3:0]out_addr_OBUF;
  wire out_addr_d;
  wire \out_addr_q[0]_i_10_n_0 ;
  wire \out_addr_q[0]_i_11_n_0 ;
  wire \out_addr_q[0]_i_1_n_0 ;
  wire \out_addr_q[0]_i_2_n_0 ;
  wire \out_addr_q[0]_i_3_n_0 ;
  wire \out_addr_q[0]_i_4_n_0 ;
  wire \out_addr_q[0]_i_5_n_0 ;
  wire \out_addr_q[0]_i_6_n_0 ;
  wire \out_addr_q[0]_i_7_n_0 ;
  wire \out_addr_q[0]_i_8_n_0 ;
  wire \out_addr_q[0]_i_9_n_0 ;
  wire out_ready;
  wire out_ready_IBUF;
  wire out_valid;
  wire out_valid_OBUF;
  wire out_valid_q;
  wire out_valid_q_i_1_n_0;
  wire p_0_in;
  wire p_0_in12_in;
  wire p_0_in14_in;
  wire p_0_in16_in;
  wire p_0_in19_in;
  wire p_0_in22_in;
  wire p_0_in25_in;
  wire p_0_in28_in;
  wire p_0_in31_in;
  wire p_0_in34_in;
  wire p_1_in;
  wire p_1_in105_in;
  wire p_1_in13_in;
  wire p_1_in17_in;
  wire p_1_in20_in;
  wire p_1_in23_in;
  wire p_1_in24_in;
  wire p_1_in26_in;
  wire p_1_in29_in;
  wire p_1_in32_in;
  wire p_1_in36_in;
  wire p_1_in46_in;
  wire p_1_in67_in;
  wire p_2_in35_in;
  wire p_3_in;
  wire p_4_in;
  wire p_5_in;
  wire p_6_in;
  wire [15:0]pending_d;
  wire [15:0]pending_q;
  wire \pending_q[0]_i_2_n_0 ;
  wire \pending_q[0]_i_3_n_0 ;
  wire \pending_q[11]_i_5_n_0 ;
  wire \pending_q[11]_i_6_n_0 ;
  wire \pending_q[15]_i_5_n_0 ;
  wire \pending_q[15]_i_6_n_0 ;
  wire \pending_q[3]_i_5_n_0 ;
  wire \pending_q[3]_i_6_n_0 ;
  wire \pending_q[3]_i_7_n_0 ;
  wire \pending_q[6]_i_5_n_0 ;
  wire \pending_q[6]_i_6_n_0 ;
  wire \pending_q[6]_i_7_n_0 ;
  (* async_reg = "true" *) wire [15:0]req_meta_q;
  (* async_reg = "true" *) wire [15:0]req_sync_q;
  (* async_reg = "true" *) wire [1:0]reset_release_q;
  wire \reset_release_q[1]_i_1_n_0 ;
  wire rst_n;
  wire rst_n_IBUF;
  wire [2:1]selected_addr;
  wire selected_half1;
  wire selected_half15_out;
  wire selected_half18_out;
  wire [7:1]selected_onehot;
  wire [15:0]src_ack_async;
  wire [15:0]src_ack_async_OBUF;
  wire [15:0]src_req_async;
  wire [15:0]src_req_async_IBUF;

  LUT3 #(
    .INIT(8'hB0)) 
    \ack_q[0]_i_1 
       (.I0(ack_q[0]),
        .I1(pending_q[0]),
        .I2(req_sync_q[0]),
        .O(ack_d[0]));
  LUT3 #(
    .INIT(8'hB0)) 
    \ack_q[10]_i_1 
       (.I0(ack_q[10]),
        .I1(pending_q[10]),
        .I2(req_sync_q[10]),
        .O(ack_d[10]));
  LUT3 #(
    .INIT(8'hB0)) 
    \ack_q[11]_i_1 
       (.I0(ack_q[11]),
        .I1(pending_q[11]),
        .I2(req_sync_q[11]),
        .O(ack_d[11]));
  LUT3 #(
    .INIT(8'hB0)) 
    \ack_q[12]_i_1 
       (.I0(ack_q[12]),
        .I1(pending_q[12]),
        .I2(req_sync_q[12]),
        .O(ack_d[12]));
  LUT3 #(
    .INIT(8'hB0)) 
    \ack_q[13]_i_1 
       (.I0(ack_q[13]),
        .I1(pending_q[13]),
        .I2(req_sync_q[13]),
        .O(ack_d[13]));
  LUT3 #(
    .INIT(8'hB0)) 
    \ack_q[14]_i_1 
       (.I0(ack_q[14]),
        .I1(pending_q[14]),
        .I2(req_sync_q[14]),
        .O(ack_d[14]));
  LUT3 #(
    .INIT(8'hB0)) 
    \ack_q[15]_i_1 
       (.I0(ack_q[15]),
        .I1(pending_q[15]),
        .I2(req_sync_q[15]),
        .O(ack_d[15]));
  LUT3 #(
    .INIT(8'hB0)) 
    \ack_q[1]_i_1 
       (.I0(ack_q[1]),
        .I1(pending_q[1]),
        .I2(req_sync_q[1]),
        .O(ack_d[1]));
  LUT3 #(
    .INIT(8'hB0)) 
    \ack_q[2]_i_1 
       (.I0(ack_q[2]),
        .I1(pending_q[2]),
        .I2(req_sync_q[2]),
        .O(ack_d[2]));
  LUT3 #(
    .INIT(8'hB0)) 
    \ack_q[3]_i_1 
       (.I0(ack_q[3]),
        .I1(pending_q[3]),
        .I2(req_sync_q[3]),
        .O(ack_d[3]));
  LUT3 #(
    .INIT(8'hB0)) 
    \ack_q[4]_i_1 
       (.I0(ack_q[4]),
        .I1(pending_q[4]),
        .I2(req_sync_q[4]),
        .O(ack_d[4]));
  LUT3 #(
    .INIT(8'hB0)) 
    \ack_q[5]_i_1 
       (.I0(ack_q[5]),
        .I1(pending_q[5]),
        .I2(req_sync_q[5]),
        .O(ack_d[5]));
  LUT3 #(
    .INIT(8'hB0)) 
    \ack_q[6]_i_1 
       (.I0(ack_q[6]),
        .I1(pending_q[6]),
        .I2(req_sync_q[6]),
        .O(ack_d[6]));
  LUT3 #(
    .INIT(8'hB0)) 
    \ack_q[7]_i_1 
       (.I0(ack_q[7]),
        .I1(pending_q[7]),
        .I2(req_sync_q[7]),
        .O(ack_d[7]));
  LUT3 #(
    .INIT(8'hB0)) 
    \ack_q[8]_i_1 
       (.I0(ack_q[8]),
        .I1(pending_q[8]),
        .I2(req_sync_q[8]),
        .O(ack_d[8]));
  LUT3 #(
    .INIT(8'hB0)) 
    \ack_q[9]_i_1 
       (.I0(ack_q[9]),
        .I1(pending_q[9]),
        .I2(req_sync_q[9]),
        .O(ack_d[9]));
  FDRE \ack_q_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(ack_d[0]),
        .Q(ack_q[0]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \ack_q_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(ack_d[10]),
        .Q(ack_q[10]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \ack_q_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(ack_d[11]),
        .Q(ack_q[11]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \ack_q_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(ack_d[12]),
        .Q(ack_q[12]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \ack_q_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(ack_d[13]),
        .Q(ack_q[13]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \ack_q_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(ack_d[14]),
        .Q(ack_q[14]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \ack_q_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(ack_d[15]),
        .Q(ack_q[15]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \ack_q_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(ack_d[1]),
        .Q(ack_q[1]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \ack_q_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(ack_d[2]),
        .Q(ack_q[2]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \ack_q_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(ack_d[3]),
        .Q(ack_q[3]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \ack_q_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(ack_d[4]),
        .Q(ack_q[4]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \ack_q_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(ack_d[5]),
        .Q(ack_q[5]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \ack_q_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(ack_d[6]),
        .Q(ack_q[6]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \ack_q_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(ack_d[7]),
        .Q(ack_q[7]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \ack_q_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(ack_d[8]),
        .Q(ack_q[8]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \ack_q_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(ack_d[9]),
        .Q(ack_q[9]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  BUFG clk_IBUF_BUFG_inst
       (.I(clk_IBUF),
        .O(clk_IBUF_BUFG));
  IBUF clk_IBUF_inst
       (.I(clk),
        .O(clk_IBUF));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT3 #(
    .INIT(8'h69)) 
    \epoch_gray_q[0]_i_1 
       (.I0(p_0_in),
        .I1(\epoch_gray_q_reg_n_0_[2] ),
        .I2(\epoch_gray_q_reg_n_0_[3] ),
        .O(\epoch_gray_q[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT4 #(
    .INIT(16'hD782)) 
    \epoch_gray_q[1]_i_1 
       (.I0(\epoch_gray_q_reg_n_0_[0] ),
        .I1(\epoch_gray_q_reg_n_0_[2] ),
        .I2(\epoch_gray_q_reg_n_0_[3] ),
        .I3(p_0_in),
        .O(\epoch_gray_q[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT4 #(
    .INIT(16'hF702)) 
    \epoch_gray_q[2]_i_1 
       (.I0(p_0_in),
        .I1(\epoch_gray_q_reg_n_0_[3] ),
        .I2(\epoch_gray_q_reg_n_0_[0] ),
        .I3(\epoch_gray_q_reg_n_0_[2] ),
        .O(\epoch_gray_q[2]_i_1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \epoch_gray_q[3]_i_1 
       (.I0(reset_release_q[1]),
        .O(\epoch_gray_q[3]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hEE0E)) 
    \epoch_gray_q[3]_i_2 
       (.I0(\epoch_gray_q[3]_i_4_n_0 ),
        .I1(p_6_in),
        .I2(out_valid_q),
        .I3(out_ready_IBUF),
        .O(out_addr_d));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT4 #(
    .INIT(16'hFE04)) 
    \epoch_gray_q[3]_i_3 
       (.I0(p_0_in),
        .I1(\epoch_gray_q_reg_n_0_[2] ),
        .I2(\epoch_gray_q_reg_n_0_[0] ),
        .I3(\epoch_gray_q_reg_n_0_[3] ),
        .O(\epoch_gray_q[3]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h57575700)) 
    \epoch_gray_q[3]_i_4 
       (.I0(\epoch_gray_q_reg_n_0_[3] ),
        .I1(p_1_in),
        .I2(selected_half1),
        .I3(selected_half18_out),
        .I4(selected_half15_out),
        .O(\epoch_gray_q[3]_i_4_n_0 ));
  FDRE \epoch_gray_q_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(out_addr_d),
        .D(\epoch_gray_q[0]_i_1_n_0 ),
        .Q(\epoch_gray_q_reg_n_0_[0] ),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \epoch_gray_q_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(out_addr_d),
        .D(\epoch_gray_q[1]_i_1_n_0 ),
        .Q(p_0_in),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \epoch_gray_q_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(out_addr_d),
        .D(\epoch_gray_q[2]_i_1_n_0 ),
        .Q(\epoch_gray_q_reg_n_0_[2] ),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \epoch_gray_q_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(out_addr_d),
        .D(\epoch_gray_q[3]_i_3_n_0 ),
        .Q(\epoch_gray_q_reg_n_0_[3] ),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
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
    .INIT(64'hFFFFFFFFFFFFFFF8)) 
    \out_addr_q[0]_i_1 
       (.I0(p_1_in24_in),
        .I1(\out_addr_q[0]_i_2_n_0 ),
        .I2(selected_onehot[7]),
        .I3(\out_addr_q[0]_i_3_n_0 ),
        .I4(\out_addr_q[0]_i_4_n_0 ),
        .I5(\out_addr_q[0]_i_5_n_0 ),
        .O(\out_addr_q[0]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hFF0B0000)) 
    \out_addr_q[0]_i_10 
       (.I0(ack_q[10]),
        .I1(req_sync_q[10]),
        .I2(pending_q[10]),
        .I3(\epoch_gray_q_reg_n_0_[0] ),
        .I4(p_0_in28_in),
        .O(\out_addr_q[0]_i_10_n_0 ));
  LUT5 #(
    .INIT(32'hFF0B0000)) 
    \out_addr_q[0]_i_11 
       (.I0(ack_q[8]),
        .I1(req_sync_q[8]),
        .I2(pending_q[8]),
        .I3(\epoch_gray_q_reg_n_0_[0] ),
        .I4(p_0_in25_in),
        .O(\out_addr_q[0]_i_11_n_0 ));
  LUT5 #(
    .INIT(32'hFF0B0000)) 
    \out_addr_q[0]_i_2 
       (.I0(ack_q[4]),
        .I1(req_sync_q[4]),
        .I2(pending_q[4]),
        .I3(\epoch_gray_q_reg_n_0_[0] ),
        .I4(p_0_in19_in),
        .O(\out_addr_q[0]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hACEC0000A0200000)) 
    \out_addr_q[0]_i_3 
       (.I0(\out_addr_q[0]_i_6_n_0 ),
        .I1(\pending_q[15]_i_5_n_0 ),
        .I2(\pending_q[15]_i_6_n_0 ),
        .I3(p_0_in),
        .I4(p_4_in),
        .I5(\out_addr_q[0]_i_7_n_0 ),
        .O(\out_addr_q[0]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hF8B8000008880000)) 
    \out_addr_q[0]_i_4 
       (.I0(\out_addr_q[0]_i_8_n_0 ),
        .I1(\pending_q[3]_i_5_n_0 ),
        .I2(\pending_q[3]_i_6_n_0 ),
        .I3(p_0_in),
        .I4(\pending_q[3]_i_7_n_0 ),
        .I5(\out_addr_q[0]_i_9_n_0 ),
        .O(\out_addr_q[0]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hACEC0000A0200000)) 
    \out_addr_q[0]_i_5 
       (.I0(\out_addr_q[0]_i_10_n_0 ),
        .I1(\pending_q[11]_i_5_n_0 ),
        .I2(\pending_q[11]_i_6_n_0 ),
        .I3(p_0_in),
        .I4(p_1_in105_in),
        .I5(\out_addr_q[0]_i_11_n_0 ),
        .O(\out_addr_q[0]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'hFF0B0000)) 
    \out_addr_q[0]_i_6 
       (.I0(ack_q[14]),
        .I1(req_sync_q[14]),
        .I2(pending_q[14]),
        .I3(\epoch_gray_q_reg_n_0_[0] ),
        .I4(p_0_in12_in),
        .O(\out_addr_q[0]_i_6_n_0 ));
  LUT5 #(
    .INIT(32'hFF0B0000)) 
    \out_addr_q[0]_i_7 
       (.I0(ack_q[12]),
        .I1(req_sync_q[12]),
        .I2(pending_q[12]),
        .I3(\epoch_gray_q_reg_n_0_[0] ),
        .I4(p_0_in31_in),
        .O(\out_addr_q[0]_i_7_n_0 ));
  LUT5 #(
    .INIT(32'hFF0B0000)) 
    \out_addr_q[0]_i_8 
       (.I0(ack_q[0]),
        .I1(req_sync_q[0]),
        .I2(pending_q[0]),
        .I3(\epoch_gray_q_reg_n_0_[0] ),
        .I4(p_0_in14_in),
        .O(\out_addr_q[0]_i_8_n_0 ));
  LUT5 #(
    .INIT(32'hFF0B0000)) 
    \out_addr_q[0]_i_9 
       (.I0(ack_q[2]),
        .I1(req_sync_q[2]),
        .I2(pending_q[2]),
        .I3(\epoch_gray_q_reg_n_0_[0] ),
        .I4(p_0_in16_in),
        .O(\out_addr_q[0]_i_9_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \out_addr_q[1]_i_1 
       (.I0(p_0_in34_in),
        .I1(p_2_in35_in),
        .I2(p_3_in),
        .I3(p_1_in36_in),
        .O(selected_addr[1]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \out_addr_q[2]_i_1 
       (.I0(p_5_in),
        .I1(p_4_in),
        .O(selected_addr[2]));
  LUT6 #(
    .INIT(64'h222A0000333F0000)) 
    \out_addr_q[2]_i_2 
       (.I0(\epoch_gray_q_reg_n_0_[2] ),
        .I1(\epoch_gray_q_reg_n_0_[3] ),
        .I2(p_1_in),
        .I3(selected_half1),
        .I4(selected_half18_out),
        .I5(selected_half15_out),
        .O(p_5_in));
  LUT6 #(
    .INIT(64'hAA02FF0300000000)) 
    \out_addr_q[2]_i_3 
       (.I0(\epoch_gray_q_reg_n_0_[2] ),
        .I1(selected_half15_out),
        .I2(selected_half18_out),
        .I3(\epoch_gray_q_reg_n_0_[3] ),
        .I4(p_1_in),
        .I5(selected_half1),
        .O(p_4_in));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'hF1F1F100)) 
    \out_addr_q[3]_i_1 
       (.I0(selected_half15_out),
        .I1(selected_half18_out),
        .I2(\epoch_gray_q_reg_n_0_[3] ),
        .I3(p_1_in),
        .I4(selected_half1),
        .O(p_6_in));
  LUT5 #(
    .INIT(32'hFFFFFFBA)) 
    \out_addr_q[3]_i_2 
       (.I0(p_0_in16_in),
        .I1(ack_q[2]),
        .I2(req_sync_q[2]),
        .I3(pending_q[2]),
        .I4(\pending_q[3]_i_5_n_0 ),
        .O(selected_half15_out));
  LUT5 #(
    .INIT(32'hFFFFFFBA)) 
    \out_addr_q[3]_i_3 
       (.I0(p_0_in22_in),
        .I1(ack_q[6]),
        .I2(req_sync_q[6]),
        .I3(pending_q[6]),
        .I4(\pending_q[6]_i_7_n_0 ),
        .O(selected_half18_out));
  LUT5 #(
    .INIT(32'hFFFFFFBA)) 
    \out_addr_q[3]_i_4 
       (.I0(p_0_in28_in),
        .I1(ack_q[10]),
        .I2(req_sync_q[10]),
        .I3(pending_q[10]),
        .I4(\pending_q[11]_i_5_n_0 ),
        .O(p_1_in));
  LUT5 #(
    .INIT(32'hFFFFFFBA)) 
    \out_addr_q[3]_i_5 
       (.I0(p_0_in12_in),
        .I1(ack_q[14]),
        .I2(req_sync_q[14]),
        .I3(pending_q[14]),
        .I4(\pending_q[15]_i_5_n_0 ),
        .O(selected_half1));
  FDRE \out_addr_q_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(out_addr_d),
        .D(\out_addr_q[0]_i_1_n_0 ),
        .Q(out_addr_OBUF[0]),
        .R(1'b0));
  FDRE \out_addr_q_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(out_addr_d),
        .D(selected_addr[1]),
        .Q(out_addr_OBUF[1]),
        .R(1'b0));
  FDRE \out_addr_q_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(out_addr_d),
        .D(selected_addr[2]),
        .Q(out_addr_OBUF[2]),
        .R(1'b0));
  FDRE \out_addr_q_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(out_addr_d),
        .D(p_6_in),
        .Q(out_addr_OBUF[3]),
        .R(1'b0));
  IBUF out_ready_IBUF_inst
       (.I(out_ready),
        .O(out_ready_IBUF));
  OBUF out_valid_OBUF_inst
       (.I(out_valid_OBUF),
        .O(out_valid));
  LUT2 #(
    .INIT(4'h8)) 
    out_valid_OBUF_inst_i_1
       (.I0(out_valid_q),
        .I1(reset_release_q[1]),
        .O(out_valid_OBUF));
  LUT4 #(
    .INIT(16'hEFEE)) 
    out_valid_q_i_1
       (.I0(\epoch_gray_q[3]_i_4_n_0 ),
        .I1(p_6_in),
        .I2(out_ready_IBUF),
        .I3(out_valid_q),
        .O(out_valid_q_i_1_n_0));
  FDRE out_valid_q_reg
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(out_valid_q_i_1_n_0),
        .Q(out_valid_q),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFF005D005D005D00)) 
    \pending_q[0]_i_1 
       (.I0(\pending_q[0]_i_2_n_0 ),
        .I1(out_valid_q),
        .I2(out_ready_IBUF),
        .I3(\pending_q[0]_i_3_n_0 ),
        .I4(p_0_in14_in),
        .I5(\epoch_gray_q_reg_n_0_[0] ),
        .O(pending_d[0]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'h2A00)) 
    \pending_q[0]_i_2 
       (.I0(\pending_q[3]_i_5_n_0 ),
        .I1(\pending_q[3]_i_6_n_0 ),
        .I2(p_0_in),
        .I3(\pending_q[3]_i_7_n_0 ),
        .O(\pending_q[0]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_q[0]_i_3 
       (.I0(ack_q[0]),
        .I1(req_sync_q[0]),
        .I2(pending_q[0]),
        .O(\pending_q[0]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_q[0]_i_4 
       (.I0(ack_q[1]),
        .I1(req_sync_q[1]),
        .I2(pending_q[1]),
        .O(p_0_in14_in));
  LUT6 #(
    .INIT(64'h80F080F0F0F080F0)) 
    \pending_q[10]_i_1 
       (.I0(p_0_in28_in),
        .I1(\epoch_gray_q_reg_n_0_[0] ),
        .I2(p_1_in29_in),
        .I3(p_2_in35_in),
        .I4(out_valid_q),
        .I5(out_ready_IBUF),
        .O(pending_d[10]));
  LUT6 #(
    .INIT(64'h40F040F0F0F040F0)) 
    \pending_q[11]_i_1 
       (.I0(\epoch_gray_q_reg_n_0_[0] ),
        .I1(p_1_in29_in),
        .I2(p_0_in28_in),
        .I3(p_2_in35_in),
        .I4(out_valid_q),
        .I5(out_ready_IBUF),
        .O(pending_d[11]));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_q[11]_i_2 
       (.I0(ack_q[10]),
        .I1(req_sync_q[10]),
        .I2(pending_q[10]),
        .O(p_1_in29_in));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_q[11]_i_3 
       (.I0(ack_q[11]),
        .I1(req_sync_q[11]),
        .I2(pending_q[11]),
        .O(p_0_in28_in));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'hC400)) 
    \pending_q[11]_i_4 
       (.I0(\pending_q[11]_i_5_n_0 ),
        .I1(\pending_q[11]_i_6_n_0 ),
        .I2(p_0_in),
        .I3(p_1_in105_in),
        .O(p_2_in35_in));
  LUT6 #(
    .INIT(64'hFFAEFFAEFFFFFFAE)) 
    \pending_q[11]_i_5 
       (.I0(pending_q[8]),
        .I1(req_sync_q[8]),
        .I2(ack_q[8]),
        .I3(pending_q[9]),
        .I4(req_sync_q[9]),
        .I5(ack_q[9]),
        .O(\pending_q[11]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hFFAEFFAEFFFFFFAE)) 
    \pending_q[11]_i_6 
       (.I0(pending_q[10]),
        .I1(req_sync_q[10]),
        .I2(ack_q[10]),
        .I3(pending_q[11]),
        .I4(req_sync_q[11]),
        .I5(ack_q[11]),
        .O(\pending_q[11]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h7000700070007070)) 
    \pending_q[11]_i_7 
       (.I0(\epoch_gray_q_reg_n_0_[2] ),
        .I1(selected_half1),
        .I2(p_1_in),
        .I3(\epoch_gray_q_reg_n_0_[3] ),
        .I4(selected_half18_out),
        .I5(selected_half15_out),
        .O(p_1_in105_in));
  LUT6 #(
    .INIT(64'h80F080F0F0F080F0)) 
    \pending_q[12]_i_1 
       (.I0(p_0_in31_in),
        .I1(\epoch_gray_q_reg_n_0_[0] ),
        .I2(p_1_in32_in),
        .I3(p_1_in67_in),
        .I4(out_valid_q),
        .I5(out_ready_IBUF),
        .O(pending_d[12]));
  LUT6 #(
    .INIT(64'h40F040F0F0F040F0)) 
    \pending_q[13]_i_1 
       (.I0(\epoch_gray_q_reg_n_0_[0] ),
        .I1(p_1_in32_in),
        .I2(p_0_in31_in),
        .I3(p_1_in67_in),
        .I4(out_valid_q),
        .I5(out_ready_IBUF),
        .O(pending_d[13]));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_q[13]_i_2 
       (.I0(ack_q[12]),
        .I1(req_sync_q[12]),
        .I2(pending_q[12]),
        .O(p_1_in32_in));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_q[13]_i_3 
       (.I0(ack_q[13]),
        .I1(req_sync_q[13]),
        .I2(pending_q[13]),
        .O(p_0_in31_in));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'h2A00)) 
    \pending_q[13]_i_4 
       (.I0(\pending_q[15]_i_5_n_0 ),
        .I1(\pending_q[15]_i_6_n_0 ),
        .I2(p_0_in),
        .I3(p_4_in),
        .O(p_1_in67_in));
  LUT6 #(
    .INIT(64'h80F080F0F0F080F0)) 
    \pending_q[14]_i_1 
       (.I0(p_0_in12_in),
        .I1(\epoch_gray_q_reg_n_0_[0] ),
        .I2(p_1_in13_in),
        .I3(p_3_in),
        .I4(out_valid_q),
        .I5(out_ready_IBUF),
        .O(pending_d[14]));
  LUT6 #(
    .INIT(64'h40F040F0F0F040F0)) 
    \pending_q[15]_i_1 
       (.I0(\epoch_gray_q_reg_n_0_[0] ),
        .I1(p_1_in13_in),
        .I2(p_0_in12_in),
        .I3(p_3_in),
        .I4(out_valid_q),
        .I5(out_ready_IBUF),
        .O(pending_d[15]));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_q[15]_i_2 
       (.I0(ack_q[14]),
        .I1(req_sync_q[14]),
        .I2(pending_q[14]),
        .O(p_1_in13_in));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_q[15]_i_3 
       (.I0(ack_q[15]),
        .I1(req_sync_q[15]),
        .I2(pending_q[15]),
        .O(p_0_in12_in));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'hC400)) 
    \pending_q[15]_i_4 
       (.I0(\pending_q[15]_i_5_n_0 ),
        .I1(\pending_q[15]_i_6_n_0 ),
        .I2(p_0_in),
        .I3(p_4_in),
        .O(p_3_in));
  LUT6 #(
    .INIT(64'hFFAEFFAEFFFFFFAE)) 
    \pending_q[15]_i_5 
       (.I0(pending_q[12]),
        .I1(req_sync_q[12]),
        .I2(ack_q[12]),
        .I3(pending_q[13]),
        .I4(req_sync_q[13]),
        .I5(ack_q[13]),
        .O(\pending_q[15]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hFFAEFFAEFFFFFFAE)) 
    \pending_q[15]_i_6 
       (.I0(pending_q[14]),
        .I1(req_sync_q[14]),
        .I2(ack_q[14]),
        .I3(pending_q[15]),
        .I4(req_sync_q[15]),
        .I5(ack_q[15]),
        .O(\pending_q[15]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h7575757500750000)) 
    \pending_q[1]_i_1 
       (.I0(selected_onehot[1]),
        .I1(out_ready_IBUF),
        .I2(out_valid_q),
        .I3(ack_q[1]),
        .I4(req_sync_q[1]),
        .I5(pending_q[1]),
        .O(pending_d[1]));
  LUT6 #(
    .INIT(64'h088800000CCC0000)) 
    \pending_q[1]_i_2 
       (.I0(\epoch_gray_q_reg_n_0_[0] ),
        .I1(\pending_q[3]_i_7_n_0 ),
        .I2(p_0_in),
        .I3(\pending_q[3]_i_6_n_0 ),
        .I4(p_0_in14_in),
        .I5(\pending_q[0]_i_3_n_0 ),
        .O(selected_onehot[1]));
  LUT6 #(
    .INIT(64'hFF005D005D005D00)) 
    \pending_q[2]_i_1 
       (.I0(p_1_in36_in),
        .I1(out_valid_q),
        .I2(out_ready_IBUF),
        .I3(p_1_in17_in),
        .I4(p_0_in16_in),
        .I5(\epoch_gray_q_reg_n_0_[0] ),
        .O(pending_d[2]));
  LUT6 #(
    .INIT(64'h4FFF4F4F00000000)) 
    \pending_q[3]_i_1 
       (.I0(\epoch_gray_q_reg_n_0_[0] ),
        .I1(p_1_in17_in),
        .I2(p_1_in36_in),
        .I3(out_ready_IBUF),
        .I4(out_valid_q),
        .I5(p_0_in16_in),
        .O(pending_d[3]));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_q[3]_i_2 
       (.I0(ack_q[2]),
        .I1(req_sync_q[2]),
        .I2(pending_q[2]),
        .O(p_1_in17_in));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'hC400)) 
    \pending_q[3]_i_3 
       (.I0(\pending_q[3]_i_5_n_0 ),
        .I1(\pending_q[3]_i_6_n_0 ),
        .I2(p_0_in),
        .I3(\pending_q[3]_i_7_n_0 ),
        .O(p_1_in36_in));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_q[3]_i_4 
       (.I0(ack_q[3]),
        .I1(req_sync_q[3]),
        .I2(pending_q[3]),
        .O(p_0_in16_in));
  LUT6 #(
    .INIT(64'hFFAEFFAEFFFFFFAE)) 
    \pending_q[3]_i_5 
       (.I0(pending_q[0]),
        .I1(req_sync_q[0]),
        .I2(ack_q[0]),
        .I3(pending_q[1]),
        .I4(req_sync_q[1]),
        .I5(ack_q[1]),
        .O(\pending_q[3]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hFFAEFFAEFFFFFFAE)) 
    \pending_q[3]_i_6 
       (.I0(pending_q[2]),
        .I1(req_sync_q[2]),
        .I2(ack_q[2]),
        .I3(pending_q[3]),
        .I4(req_sync_q[3]),
        .I5(ack_q[3]),
        .O(\pending_q[3]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h0000004C4C4C4C4C)) 
    \pending_q[3]_i_7 
       (.I0(\epoch_gray_q_reg_n_0_[2] ),
        .I1(selected_half15_out),
        .I2(selected_half18_out),
        .I3(selected_half1),
        .I4(p_1_in),
        .I5(\epoch_gray_q_reg_n_0_[3] ),
        .O(\pending_q[3]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hFF005D005D005D00)) 
    \pending_q[4]_i_1 
       (.I0(p_1_in24_in),
        .I1(out_valid_q),
        .I2(out_ready_IBUF),
        .I3(p_1_in20_in),
        .I4(p_0_in19_in),
        .I5(\epoch_gray_q_reg_n_0_[0] ),
        .O(pending_d[4]));
  LUT6 #(
    .INIT(64'h4FFF4F4F00000000)) 
    \pending_q[5]_i_1 
       (.I0(\epoch_gray_q_reg_n_0_[0] ),
        .I1(p_1_in20_in),
        .I2(p_1_in24_in),
        .I3(out_ready_IBUF),
        .I4(out_valid_q),
        .I5(p_0_in19_in),
        .O(pending_d[5]));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_q[5]_i_2 
       (.I0(ack_q[4]),
        .I1(req_sync_q[4]),
        .I2(pending_q[4]),
        .O(p_1_in20_in));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT4 #(
    .INIT(16'h2A00)) 
    \pending_q[5]_i_3 
       (.I0(\pending_q[6]_i_7_n_0 ),
        .I1(\pending_q[6]_i_5_n_0 ),
        .I2(p_0_in),
        .I3(p_5_in),
        .O(p_1_in24_in));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_q[5]_i_4 
       (.I0(ack_q[5]),
        .I1(req_sync_q[5]),
        .I2(pending_q[5]),
        .O(p_0_in19_in));
  LUT6 #(
    .INIT(64'hFF005D005D005D00)) 
    \pending_q[6]_i_1 
       (.I0(p_0_in34_in),
        .I1(out_valid_q),
        .I2(out_ready_IBUF),
        .I3(p_1_in23_in),
        .I4(p_0_in22_in),
        .I5(\epoch_gray_q_reg_n_0_[0] ),
        .O(pending_d[6]));
  LUT6 #(
    .INIT(64'h8000A0008800AA00)) 
    \pending_q[6]_i_2 
       (.I0(\pending_q[6]_i_5_n_0 ),
        .I1(p_0_in),
        .I2(\epoch_gray_q_reg_n_0_[2] ),
        .I3(\pending_q[6]_i_6_n_0 ),
        .I4(\pending_q[6]_i_7_n_0 ),
        .I5(selected_half15_out),
        .O(p_0_in34_in));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_q[6]_i_3 
       (.I0(ack_q[6]),
        .I1(req_sync_q[6]),
        .I2(pending_q[6]),
        .O(p_1_in23_in));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_q[6]_i_4 
       (.I0(ack_q[7]),
        .I1(req_sync_q[7]),
        .I2(pending_q[7]),
        .O(p_0_in22_in));
  LUT6 #(
    .INIT(64'hFFAEFFAEFFFFFFAE)) 
    \pending_q[6]_i_5 
       (.I0(pending_q[6]),
        .I1(req_sync_q[6]),
        .I2(ack_q[6]),
        .I3(pending_q[7]),
        .I4(req_sync_q[7]),
        .I5(ack_q[7]),
        .O(\pending_q[6]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'h0001FFFF)) 
    \pending_q[6]_i_6 
       (.I0(\pending_q[15]_i_6_n_0 ),
        .I1(\pending_q[15]_i_5_n_0 ),
        .I2(\pending_q[11]_i_6_n_0 ),
        .I3(\pending_q[11]_i_5_n_0 ),
        .I4(\epoch_gray_q_reg_n_0_[3] ),
        .O(\pending_q[6]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hFFAEFFAEFFFFFFAE)) 
    \pending_q[6]_i_7 
       (.I0(pending_q[4]),
        .I1(req_sync_q[4]),
        .I2(ack_q[4]),
        .I3(pending_q[5]),
        .I4(req_sync_q[5]),
        .I5(ack_q[5]),
        .O(\pending_q[6]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h7575757500750000)) 
    \pending_q[7]_i_1 
       (.I0(selected_onehot[7]),
        .I1(out_ready_IBUF),
        .I2(out_valid_q),
        .I3(ack_q[7]),
        .I4(req_sync_q[7]),
        .I5(pending_q[7]),
        .O(pending_d[7]));
  LUT6 #(
    .INIT(64'h8A8A888A00000000)) 
    \pending_q[7]_i_2 
       (.I0(p_0_in22_in),
        .I1(\epoch_gray_q_reg_n_0_[0] ),
        .I2(pending_q[6]),
        .I3(req_sync_q[6]),
        .I4(ack_q[6]),
        .I5(p_0_in34_in),
        .O(selected_onehot[7]));
  LUT6 #(
    .INIT(64'h80F080F0F0F080F0)) 
    \pending_q[8]_i_1 
       (.I0(p_0_in25_in),
        .I1(\epoch_gray_q_reg_n_0_[0] ),
        .I2(p_1_in26_in),
        .I3(p_1_in46_in),
        .I4(out_valid_q),
        .I5(out_ready_IBUF),
        .O(pending_d[8]));
  LUT6 #(
    .INIT(64'h40F040F0F0F040F0)) 
    \pending_q[9]_i_1 
       (.I0(\epoch_gray_q_reg_n_0_[0] ),
        .I1(p_1_in26_in),
        .I2(p_0_in25_in),
        .I3(p_1_in46_in),
        .I4(out_valid_q),
        .I5(out_ready_IBUF),
        .O(pending_d[9]));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_q[9]_i_2 
       (.I0(ack_q[8]),
        .I1(req_sync_q[8]),
        .I2(pending_q[8]),
        .O(p_1_in26_in));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_q[9]_i_3 
       (.I0(ack_q[9]),
        .I1(req_sync_q[9]),
        .I2(pending_q[9]),
        .O(p_0_in25_in));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'h2A00)) 
    \pending_q[9]_i_4 
       (.I0(\pending_q[11]_i_5_n_0 ),
        .I1(\pending_q[11]_i_6_n_0 ),
        .I2(p_0_in),
        .I3(p_1_in105_in),
        .O(p_1_in46_in));
  FDRE \pending_q_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(pending_d[0]),
        .Q(pending_q[0]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \pending_q_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(pending_d[10]),
        .Q(pending_q[10]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \pending_q_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(pending_d[11]),
        .Q(pending_q[11]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \pending_q_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(pending_d[12]),
        .Q(pending_q[12]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \pending_q_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(pending_d[13]),
        .Q(pending_q[13]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \pending_q_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(pending_d[14]),
        .Q(pending_q[14]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \pending_q_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(pending_d[15]),
        .Q(pending_q[15]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \pending_q_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(pending_d[1]),
        .Q(pending_q[1]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \pending_q_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(pending_d[2]),
        .Q(pending_q[2]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \pending_q_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(pending_d[3]),
        .Q(pending_q[3]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \pending_q_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(pending_d[4]),
        .Q(pending_q[4]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \pending_q_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(pending_d[5]),
        .Q(pending_q[5]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \pending_q_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(pending_d[6]),
        .Q(pending_q[6]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \pending_q_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(pending_d[7]),
        .Q(pending_q[7]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \pending_q_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(pending_d[8]),
        .Q(pending_q[8]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \pending_q_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(pending_d[9]),
        .Q(pending_q[9]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_meta_q_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(src_req_async_IBUF[0]),
        .Q(req_meta_q[0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_meta_q_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(src_req_async_IBUF[10]),
        .Q(req_meta_q[10]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_meta_q_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(src_req_async_IBUF[11]),
        .Q(req_meta_q[11]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_meta_q_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(src_req_async_IBUF[12]),
        .Q(req_meta_q[12]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_meta_q_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(src_req_async_IBUF[13]),
        .Q(req_meta_q[13]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_meta_q_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(src_req_async_IBUF[14]),
        .Q(req_meta_q[14]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_meta_q_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(src_req_async_IBUF[15]),
        .Q(req_meta_q[15]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_meta_q_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(src_req_async_IBUF[1]),
        .Q(req_meta_q[1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_meta_q_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(src_req_async_IBUF[2]),
        .Q(req_meta_q[2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_meta_q_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(src_req_async_IBUF[3]),
        .Q(req_meta_q[3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_meta_q_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(src_req_async_IBUF[4]),
        .Q(req_meta_q[4]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_meta_q_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(src_req_async_IBUF[5]),
        .Q(req_meta_q[5]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_meta_q_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(src_req_async_IBUF[6]),
        .Q(req_meta_q[6]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_meta_q_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(src_req_async_IBUF[7]),
        .Q(req_meta_q[7]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_meta_q_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(src_req_async_IBUF[8]),
        .Q(req_meta_q[8]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_meta_q_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(src_req_async_IBUF[9]),
        .Q(req_meta_q[9]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_sync_q_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(req_meta_q[0]),
        .Q(req_sync_q[0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_sync_q_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(req_meta_q[10]),
        .Q(req_sync_q[10]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_sync_q_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(req_meta_q[11]),
        .Q(req_sync_q[11]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_sync_q_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(req_meta_q[12]),
        .Q(req_sync_q[12]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_sync_q_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(req_meta_q[13]),
        .Q(req_sync_q[13]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_sync_q_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(req_meta_q[14]),
        .Q(req_sync_q[14]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_sync_q_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(req_meta_q[15]),
        .Q(req_sync_q[15]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_sync_q_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(req_meta_q[1]),
        .Q(req_sync_q[1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_sync_q_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(req_meta_q[2]),
        .Q(req_sync_q[2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_sync_q_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(req_meta_q[3]),
        .Q(req_sync_q[3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_sync_q_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(req_meta_q[4]),
        .Q(req_sync_q[4]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_sync_q_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(req_meta_q[5]),
        .Q(req_sync_q[5]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_sync_q_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(req_meta_q[6]),
        .Q(req_sync_q[6]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_sync_q_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(req_meta_q[7]),
        .Q(req_sync_q[7]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_sync_q_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(req_meta_q[8]),
        .Q(req_sync_q[8]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_sync_q_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(req_meta_q[9]),
        .Q(req_sync_q[9]),
        .R(1'b0));
  LUT1 #(
    .INIT(2'h1)) 
    \reset_release_q[1]_i_1 
       (.I0(rst_n_IBUF),
        .O(\reset_release_q[1]_i_1_n_0 ));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \reset_release_q_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\reset_release_q[1]_i_1_n_0 ),
        .D(1'b1),
        .Q(reset_release_q[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \reset_release_q_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\reset_release_q[1]_i_1_n_0 ),
        .D(reset_release_q[0]),
        .Q(reset_release_q[1]));
  IBUF rst_n_IBUF_inst
       (.I(rst_n),
        .O(rst_n_IBUF));
  OBUF \src_ack_async_OBUF[0]_inst 
       (.I(src_ack_async_OBUF[0]),
        .O(src_ack_async[0]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[0]_inst_i_1 
       (.I0(ack_q[0]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[0]));
  OBUF \src_ack_async_OBUF[10]_inst 
       (.I(src_ack_async_OBUF[10]),
        .O(src_ack_async[10]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[10]_inst_i_1 
       (.I0(ack_q[10]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[10]));
  OBUF \src_ack_async_OBUF[11]_inst 
       (.I(src_ack_async_OBUF[11]),
        .O(src_ack_async[11]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[11]_inst_i_1 
       (.I0(ack_q[11]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[11]));
  OBUF \src_ack_async_OBUF[12]_inst 
       (.I(src_ack_async_OBUF[12]),
        .O(src_ack_async[12]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[12]_inst_i_1 
       (.I0(ack_q[12]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[12]));
  OBUF \src_ack_async_OBUF[13]_inst 
       (.I(src_ack_async_OBUF[13]),
        .O(src_ack_async[13]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[13]_inst_i_1 
       (.I0(ack_q[13]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[13]));
  OBUF \src_ack_async_OBUF[14]_inst 
       (.I(src_ack_async_OBUF[14]),
        .O(src_ack_async[14]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[14]_inst_i_1 
       (.I0(ack_q[14]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[14]));
  OBUF \src_ack_async_OBUF[15]_inst 
       (.I(src_ack_async_OBUF[15]),
        .O(src_ack_async[15]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[15]_inst_i_1 
       (.I0(ack_q[15]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[15]));
  OBUF \src_ack_async_OBUF[1]_inst 
       (.I(src_ack_async_OBUF[1]),
        .O(src_ack_async[1]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[1]_inst_i_1 
       (.I0(ack_q[1]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[1]));
  OBUF \src_ack_async_OBUF[2]_inst 
       (.I(src_ack_async_OBUF[2]),
        .O(src_ack_async[2]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[2]_inst_i_1 
       (.I0(ack_q[2]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[2]));
  OBUF \src_ack_async_OBUF[3]_inst 
       (.I(src_ack_async_OBUF[3]),
        .O(src_ack_async[3]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[3]_inst_i_1 
       (.I0(ack_q[3]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[3]));
  OBUF \src_ack_async_OBUF[4]_inst 
       (.I(src_ack_async_OBUF[4]),
        .O(src_ack_async[4]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[4]_inst_i_1 
       (.I0(ack_q[4]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[4]));
  OBUF \src_ack_async_OBUF[5]_inst 
       (.I(src_ack_async_OBUF[5]),
        .O(src_ack_async[5]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[5]_inst_i_1 
       (.I0(ack_q[5]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[5]));
  OBUF \src_ack_async_OBUF[6]_inst 
       (.I(src_ack_async_OBUF[6]),
        .O(src_ack_async[6]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[6]_inst_i_1 
       (.I0(ack_q[6]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[6]));
  OBUF \src_ack_async_OBUF[7]_inst 
       (.I(src_ack_async_OBUF[7]),
        .O(src_ack_async[7]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[7]_inst_i_1 
       (.I0(ack_q[7]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[7]));
  OBUF \src_ack_async_OBUF[8]_inst 
       (.I(src_ack_async_OBUF[8]),
        .O(src_ack_async[8]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[8]_inst_i_1 
       (.I0(ack_q[8]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[8]));
  OBUF \src_ack_async_OBUF[9]_inst 
       (.I(src_ack_async_OBUF[9]),
        .O(src_ack_async[9]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[9]_inst_i_1 
       (.I0(ack_q[9]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[9]));
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
