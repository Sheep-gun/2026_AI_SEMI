// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Thu Aug 20 02:16:18 2026
// Host        : DESKTOP-F81OJT8 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               reports/improved_cutthrough/vivado_sanity/aer_improved_cutthrough_post_synth.v
// Design      : aer_improved_cutthrough
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* ADDR_W = "4" *) (* GROUP_SIZE = "4" *) (* GROUP_W = "2" *) 
(* LOCAL_W = "2" *) (* NETLIST_CHECKSUM = "75c370b0" *) (* NUM_GROUPS = "4" *) 
(* NUM_SOURCES = "16" *) 
(* NotValidForBitStream *)
module aer_improved_cutthrough
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
  wire group_rr_d;
  wire [1:0]group_rr_q;
  wire \group_rr_q[0]_i_1_n_0 ;
  wire \group_rr_q[1]_i_1_n_0 ;
  wire \group_rr_q[1]_i_2_n_0 ;
  wire \group_rr_q[1]_i_3_n_0 ;
  wire local_rr_d;
  wire \local_rr_q[0][0]_i_1_n_0 ;
  wire \local_rr_q[0][1]_i_10_n_0 ;
  wire \local_rr_q[0][1]_i_11_n_0 ;
  wire \local_rr_q[0][1]_i_12_n_0 ;
  wire \local_rr_q[0][1]_i_1_n_0 ;
  wire \local_rr_q[0][1]_i_2_n_0 ;
  wire \local_rr_q[0][1]_i_3_n_0 ;
  wire \local_rr_q[0][1]_i_4_n_0 ;
  wire \local_rr_q[0][1]_i_5_n_0 ;
  wire \local_rr_q[0][1]_i_6_n_0 ;
  wire \local_rr_q[0][1]_i_7_n_0 ;
  wire \local_rr_q[0][1]_i_8_n_0 ;
  wire \local_rr_q[0][1]_i_9_n_0 ;
  wire \local_rr_q[1][0]_i_1_n_0 ;
  wire \local_rr_q[1][1]_i_1_n_0 ;
  wire \local_rr_q[1][1]_i_2_n_0 ;
  wire \local_rr_q[2][0]_i_1_n_0 ;
  wire \local_rr_q[2][1]_i_1_n_0 ;
  wire \local_rr_q[2][1]_i_2_n_0 ;
  wire \local_rr_q[3][0]_i_1_n_0 ;
  wire \local_rr_q[3][1]_i_1_n_0 ;
  wire [1:0]\local_rr_q_reg[0] ;
  wire [1:0]\local_rr_q_reg[1] ;
  wire \local_rr_q_reg_n_0_[2][0] ;
  wire \local_rr_q_reg_n_0_[2][1] ;
  wire \local_rr_q_reg_n_0_[3][0] ;
  wire \local_rr_q_reg_n_0_[3][1] ;
  wire [2:2]local_valid;
  wire [1:1]local_valid0_in;
  wire local_valid136_out;
  wire local_valid139_out;
  wire local_valid142_out;
  wire [3:3]local_valid2_out;
  wire [3:0]out_addr;
  wire [3:0]out_addr_OBUF;
  wire \out_addr_q[0]_i_1_n_0 ;
  wire \out_addr_q[0]_i_2_n_0 ;
  wire \out_addr_q[0]_i_3_n_0 ;
  wire \out_addr_q[0]_i_4_n_0 ;
  wire \out_addr_q[0]_i_5_n_0 ;
  wire \out_addr_q[1]_i_1_n_0 ;
  wire \out_addr_q[1]_i_2_n_0 ;
  wire \out_addr_q[1]_i_3_n_0 ;
  wire \out_addr_q[1]_i_4_n_0 ;
  wire \out_addr_q[1]_i_5_n_0 ;
  wire \out_addr_q[1]_i_6_n_0 ;
  wire \out_addr_q[1]_i_7_n_0 ;
  wire \out_addr_q[2]_i_1_n_0 ;
  wire \out_addr_q[3]_i_2_n_0 ;
  wire \out_addr_q[3]_i_6_n_0 ;
  wire out_ready;
  wire out_ready_IBUF;
  wire out_valid;
  wire out_valid_OBUF;
  wire out_valid_q_i_1_n_0;
  wire p_0_in;
  wire [1:1]pending_d2_out__0;
  wire [2:2]pending_d2_out__1;
  wire [11:11]pending_d2_out__10;
  wire [12:12]pending_d2_out__11;
  wire [13:13]pending_d2_out__12;
  wire [3:3]pending_d2_out__2;
  wire [4:4]pending_d2_out__3;
  wire [5:5]pending_d2_out__4;
  wire [6:6]pending_d2_out__5;
  wire [7:7]pending_d2_out__6;
  wire [8:8]pending_d2_out__7;
  wire [9:9]pending_d2_out__8;
  wire [10:10]pending_d2_out__9;
  wire [0:0]pending_d__0;
  wire [14:14]pending_d__1;
  wire [15:0]pending_d__2;
  wire \pending_q[15]_i_2_n_0 ;
  wire \pending_q[15]_i_3_n_0 ;
  wire \pending_q_reg_n_0_[0] ;
  wire \pending_q_reg_n_0_[10] ;
  wire \pending_q_reg_n_0_[11] ;
  wire \pending_q_reg_n_0_[12] ;
  wire \pending_q_reg_n_0_[13] ;
  wire \pending_q_reg_n_0_[14] ;
  wire \pending_q_reg_n_0_[15] ;
  wire \pending_q_reg_n_0_[2] ;
  wire \pending_q_reg_n_0_[3] ;
  wire \pending_q_reg_n_0_[4] ;
  wire \pending_q_reg_n_0_[5] ;
  wire \pending_q_reg_n_0_[6] ;
  wire \pending_q_reg_n_0_[7] ;
  wire \pending_q_reg_n_0_[8] ;
  wire \pending_q_reg_n_0_[9] ;
  (* async_reg = "true" *) wire [15:0]req_meta_q;
  (* async_reg = "true" *) wire [15:0]req_sync_q;
  wire rst_n;
  wire rst_n_IBUF;
  wire [15:0]src_ack_async;
  wire [15:0]src_ack_async_OBUF;
  wire [15:0]src_req_async;
  wire [15:0]src_req_async_IBUF;

  LUT3 #(
    .INIT(8'hC4)) 
    \ack_q[0]_i_1 
       (.I0(\pending_q_reg_n_0_[0] ),
        .I1(req_sync_q[0]),
        .I2(src_ack_async_OBUF[0]),
        .O(\ack_q[0]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hC4)) 
    \ack_q[10]_i_1 
       (.I0(\pending_q_reg_n_0_[10] ),
        .I1(req_sync_q[10]),
        .I2(src_ack_async_OBUF[10]),
        .O(\ack_q[10]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hC4)) 
    \ack_q[11]_i_1 
       (.I0(\pending_q_reg_n_0_[11] ),
        .I1(req_sync_q[11]),
        .I2(src_ack_async_OBUF[11]),
        .O(\ack_q[11]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hC4)) 
    \ack_q[12]_i_1 
       (.I0(\pending_q_reg_n_0_[12] ),
        .I1(req_sync_q[12]),
        .I2(src_ack_async_OBUF[12]),
        .O(\ack_q[12]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hC4)) 
    \ack_q[13]_i_1 
       (.I0(\pending_q_reg_n_0_[13] ),
        .I1(req_sync_q[13]),
        .I2(src_ack_async_OBUF[13]),
        .O(\ack_q[13]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hC4)) 
    \ack_q[14]_i_1 
       (.I0(\pending_q_reg_n_0_[14] ),
        .I1(req_sync_q[14]),
        .I2(src_ack_async_OBUF[14]),
        .O(\ack_q[14]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hC4)) 
    \ack_q[15]_i_1 
       (.I0(\pending_q_reg_n_0_[15] ),
        .I1(req_sync_q[15]),
        .I2(src_ack_async_OBUF[15]),
        .O(\ack_q[15]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hC4)) 
    \ack_q[1]_i_1 
       (.I0(p_0_in),
        .I1(req_sync_q[1]),
        .I2(src_ack_async_OBUF[1]),
        .O(\ack_q[1]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hC4)) 
    \ack_q[2]_i_1 
       (.I0(\pending_q_reg_n_0_[2] ),
        .I1(req_sync_q[2]),
        .I2(src_ack_async_OBUF[2]),
        .O(\ack_q[2]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hC4)) 
    \ack_q[3]_i_1 
       (.I0(\pending_q_reg_n_0_[3] ),
        .I1(req_sync_q[3]),
        .I2(src_ack_async_OBUF[3]),
        .O(\ack_q[3]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hC4)) 
    \ack_q[4]_i_1 
       (.I0(\pending_q_reg_n_0_[4] ),
        .I1(req_sync_q[4]),
        .I2(src_ack_async_OBUF[4]),
        .O(\ack_q[4]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hC4)) 
    \ack_q[5]_i_1 
       (.I0(\pending_q_reg_n_0_[5] ),
        .I1(req_sync_q[5]),
        .I2(src_ack_async_OBUF[5]),
        .O(\ack_q[5]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hC4)) 
    \ack_q[6]_i_1 
       (.I0(\pending_q_reg_n_0_[6] ),
        .I1(req_sync_q[6]),
        .I2(src_ack_async_OBUF[6]),
        .O(\ack_q[6]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hC4)) 
    \ack_q[7]_i_1 
       (.I0(\pending_q_reg_n_0_[7] ),
        .I1(req_sync_q[7]),
        .I2(src_ack_async_OBUF[7]),
        .O(\ack_q[7]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hC4)) 
    \ack_q[8]_i_1 
       (.I0(\pending_q_reg_n_0_[8] ),
        .I1(req_sync_q[8]),
        .I2(src_ack_async_OBUF[8]),
        .O(\ack_q[8]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hC4)) 
    \ack_q[9]_i_1 
       (.I0(\pending_q_reg_n_0_[9] ),
        .I1(req_sync_q[9]),
        .I2(src_ack_async_OBUF[9]),
        .O(\ack_q[9]_i_1_n_0 ));
  FDCE \ack_q_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(\ack_q[0]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[0]));
  FDCE \ack_q_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(\ack_q[10]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[10]));
  FDCE \ack_q_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(\ack_q[11]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[11]));
  FDCE \ack_q_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(\ack_q[12]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[12]));
  FDCE \ack_q_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(\ack_q[13]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[13]));
  FDCE \ack_q_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(\ack_q[14]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[14]));
  FDCE \ack_q_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(\ack_q[15]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[15]));
  FDCE \ack_q_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(\ack_q[1]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[1]));
  FDCE \ack_q_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(\ack_q[2]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[2]));
  FDCE \ack_q_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(\ack_q[3]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[3]));
  FDCE \ack_q_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(\ack_q[4]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[4]));
  FDCE \ack_q_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(\ack_q[5]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[5]));
  FDCE \ack_q_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(\ack_q[6]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[6]));
  FDCE \ack_q_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(\ack_q[7]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[7]));
  FDCE \ack_q_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(\ack_q[8]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[8]));
  FDCE \ack_q_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(\ack_q[9]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[9]));
  BUFG clk_IBUF_BUFG_inst
       (.I(clk_IBUF),
        .O(clk_IBUF_BUFG));
  IBUF clk_IBUF_inst
       (.I(clk),
        .O(clk_IBUF));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'h5DFF00A2)) 
    \group_rr_q[0]_i_1 
       (.I0(\group_rr_q[1]_i_3_n_0 ),
        .I1(out_valid_OBUF),
        .I2(out_ready_IBUF),
        .I3(\out_addr_q[2]_i_1_n_0 ),
        .I4(group_rr_q[0]),
        .O(\group_rr_q[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h5DFFFF5D00A2A200)) 
    \group_rr_q[1]_i_1 
       (.I0(\group_rr_q[1]_i_3_n_0 ),
        .I1(out_valid_OBUF),
        .I2(out_ready_IBUF),
        .I3(\out_addr_q[2]_i_1_n_0 ),
        .I4(\out_addr_q[3]_i_2_n_0 ),
        .I5(group_rr_q[1]),
        .O(\group_rr_q[1]_i_1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \group_rr_q[1]_i_2 
       (.I0(rst_n_IBUF),
        .O(\group_rr_q[1]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \group_rr_q[1]_i_3 
       (.I0(\out_addr_q[3]_i_6_n_0 ),
        .I1(local_valid0_in),
        .I2(local_valid),
        .I3(local_valid2_out),
        .O(\group_rr_q[1]_i_3_n_0 ));
  FDCE \group_rr_q_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(\group_rr_q[0]_i_1_n_0 ),
        .Q(group_rr_q[0]));
  FDCE \group_rr_q_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(\group_rr_q[1]_i_1_n_0 ),
        .Q(group_rr_q[1]));
  LUT4 #(
    .INIT(16'hF101)) 
    \local_rr_q[0][0]_i_1 
       (.I0(\local_rr_q[0][1]_i_4_n_0 ),
        .I1(\local_rr_q[0][1]_i_5_n_0 ),
        .I2(\local_rr_q[0][1]_i_6_n_0 ),
        .I3(\local_rr_q_reg[0] [0]),
        .O(\local_rr_q[0][0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFF111E0000111E)) 
    \local_rr_q[0][1]_i_1 
       (.I0(\local_rr_q[0][1]_i_2_n_0 ),
        .I1(\local_rr_q[0][1]_i_3_n_0 ),
        .I2(\local_rr_q[0][1]_i_4_n_0 ),
        .I3(\local_rr_q[0][1]_i_5_n_0 ),
        .I4(\local_rr_q[0][1]_i_6_n_0 ),
        .I5(\local_rr_q_reg[0] [1]),
        .O(\local_rr_q[0][1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hCC00FF0D00000400)) 
    \local_rr_q[0][1]_i_10 
       (.I0(\out_addr_q[3]_i_6_n_0 ),
        .I1(group_rr_q[0]),
        .I2(local_valid0_in),
        .I3(group_rr_q[1]),
        .I4(local_valid),
        .I5(local_valid2_out),
        .O(\local_rr_q[0][1]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA22020FFB33F22)) 
    \local_rr_q[0][1]_i_11 
       (.I0(pending_d2_out__2),
        .I1(pending_d2_out__1),
        .I2(\local_rr_q_reg[0] [1]),
        .I3(pending_d2_out__0),
        .I4(\local_rr_q_reg[0] [0]),
        .I5(pending_d__0),
        .O(\local_rr_q[0][1]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hAFA22020FFB33F22)) 
    \local_rr_q[0][1]_i_12 
       (.I0(\pending_q[15]_i_2_n_0 ),
        .I1(pending_d__1),
        .I2(\local_rr_q_reg_n_0_[3][1] ),
        .I3(pending_d2_out__12),
        .I4(\local_rr_q_reg_n_0_[3][0] ),
        .I5(pending_d2_out__11),
        .O(\local_rr_q[0][1]_i_12_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \local_rr_q[0][1]_i_2 
       (.I0(\out_addr_q[1]_i_7_n_0 ),
        .I1(\out_addr_q[1]_i_6_n_0 ),
        .I2(\local_rr_q[0][1]_i_7_n_0 ),
        .I3(\local_rr_q[0][1]_i_8_n_0 ),
        .O(\local_rr_q[0][1]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \local_rr_q[0][1]_i_3 
       (.I0(\local_rr_q[0][1]_i_9_n_0 ),
        .I1(\local_rr_q[0][1]_i_10_n_0 ),
        .I2(\out_addr_q[1]_i_3_n_0 ),
        .I3(\out_addr_q[1]_i_2_n_0 ),
        .O(\local_rr_q[0][1]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \local_rr_q[0][1]_i_4 
       (.I0(\out_addr_q[0]_i_5_n_0 ),
        .I1(\out_addr_q[1]_i_6_n_0 ),
        .I2(\local_rr_q[0][1]_i_11_n_0 ),
        .I3(\local_rr_q[0][1]_i_8_n_0 ),
        .O(\local_rr_q[0][1]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \local_rr_q[0][1]_i_5 
       (.I0(\local_rr_q[0][1]_i_12_n_0 ),
        .I1(\local_rr_q[0][1]_i_10_n_0 ),
        .I2(\out_addr_q[0]_i_2_n_0 ),
        .I3(\out_addr_q[1]_i_2_n_0 ),
        .O(\local_rr_q[0][1]_i_5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'hFFFFBBFB)) 
    \local_rr_q[0][1]_i_6 
       (.I0(\out_addr_q[3]_i_2_n_0 ),
        .I1(\group_rr_q[1]_i_3_n_0 ),
        .I2(out_valid_OBUF),
        .I3(out_ready_IBUF),
        .I4(\out_addr_q[2]_i_1_n_0 ),
        .O(\local_rr_q[0][1]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hA0AEE0E0A0FEE0FE)) 
    \local_rr_q[0][1]_i_7 
       (.I0(pending_d2_out__2),
        .I1(pending_d2_out__1),
        .I2(\local_rr_q_reg[0] [1]),
        .I3(pending_d2_out__0),
        .I4(\local_rr_q_reg[0] [0]),
        .I5(pending_d__0),
        .O(\local_rr_q[0][1]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h002200228822AA2B)) 
    \local_rr_q[0][1]_i_8 
       (.I0(\out_addr_q[3]_i_6_n_0 ),
        .I1(group_rr_q[0]),
        .I2(local_valid0_in),
        .I3(group_rr_q[1]),
        .I4(local_valid),
        .I5(local_valid2_out),
        .O(\local_rr_q[0][1]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hA0AEE0E0A0FEE0FE)) 
    \local_rr_q[0][1]_i_9 
       (.I0(\pending_q[15]_i_2_n_0 ),
        .I1(pending_d__1),
        .I2(\local_rr_q_reg_n_0_[3][1] ),
        .I3(pending_d2_out__12),
        .I4(\local_rr_q_reg_n_0_[3][0] ),
        .I5(pending_d2_out__11),
        .O(\local_rr_q[0][1]_i_9_n_0 ));
  LUT4 #(
    .INIT(16'hF101)) 
    \local_rr_q[1][0]_i_1 
       (.I0(\local_rr_q[0][1]_i_4_n_0 ),
        .I1(\local_rr_q[0][1]_i_5_n_0 ),
        .I2(\local_rr_q[1][1]_i_2_n_0 ),
        .I3(\local_rr_q_reg[1] [0]),
        .O(\local_rr_q[1][0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFF111E0000111E)) 
    \local_rr_q[1][1]_i_1 
       (.I0(\local_rr_q[0][1]_i_2_n_0 ),
        .I1(\local_rr_q[0][1]_i_3_n_0 ),
        .I2(\local_rr_q[0][1]_i_4_n_0 ),
        .I3(\local_rr_q[0][1]_i_5_n_0 ),
        .I4(\local_rr_q[1][1]_i_2_n_0 ),
        .I5(\local_rr_q_reg[1] [1]),
        .O(\local_rr_q[1][1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'hBBFBFFFF)) 
    \local_rr_q[1][1]_i_2 
       (.I0(\out_addr_q[3]_i_2_n_0 ),
        .I1(\group_rr_q[1]_i_3_n_0 ),
        .I2(out_valid_OBUF),
        .I3(out_ready_IBUF),
        .I4(\out_addr_q[2]_i_1_n_0 ),
        .O(\local_rr_q[1][1]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'hF101)) 
    \local_rr_q[2][0]_i_1 
       (.I0(\local_rr_q[0][1]_i_4_n_0 ),
        .I1(\local_rr_q[0][1]_i_5_n_0 ),
        .I2(\local_rr_q[2][1]_i_2_n_0 ),
        .I3(\local_rr_q_reg_n_0_[2][0] ),
        .O(\local_rr_q[2][0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFF111E0000111E)) 
    \local_rr_q[2][1]_i_1 
       (.I0(\local_rr_q[0][1]_i_2_n_0 ),
        .I1(\local_rr_q[0][1]_i_3_n_0 ),
        .I2(\local_rr_q[0][1]_i_4_n_0 ),
        .I3(\local_rr_q[0][1]_i_5_n_0 ),
        .I4(\local_rr_q[2][1]_i_2_n_0 ),
        .I5(\local_rr_q_reg_n_0_[2][1] ),
        .O(\local_rr_q[2][1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'hDFDDFFFF)) 
    \local_rr_q[2][1]_i_2 
       (.I0(\out_addr_q[3]_i_2_n_0 ),
        .I1(\out_addr_q[2]_i_1_n_0 ),
        .I2(out_ready_IBUF),
        .I3(out_valid_OBUF),
        .I4(\group_rr_q[1]_i_3_n_0 ),
        .O(\local_rr_q[2][1]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'h1F10)) 
    \local_rr_q[3][0]_i_1 
       (.I0(\local_rr_q[0][1]_i_4_n_0 ),
        .I1(\local_rr_q[0][1]_i_5_n_0 ),
        .I2(local_rr_d),
        .I3(\local_rr_q_reg_n_0_[3][0] ),
        .O(\local_rr_q[3][0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h111EFFFF111E0000)) 
    \local_rr_q[3][1]_i_1 
       (.I0(\local_rr_q[0][1]_i_2_n_0 ),
        .I1(\local_rr_q[0][1]_i_3_n_0 ),
        .I2(\local_rr_q[0][1]_i_4_n_0 ),
        .I3(\local_rr_q[0][1]_i_5_n_0 ),
        .I4(local_rr_d),
        .I5(\local_rr_q_reg_n_0_[3][1] ),
        .O(\local_rr_q[3][1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'hA2000000)) 
    \local_rr_q[3][1]_i_2 
       (.I0(\group_rr_q[1]_i_3_n_0 ),
        .I1(out_valid_OBUF),
        .I2(out_ready_IBUF),
        .I3(\out_addr_q[3]_i_2_n_0 ),
        .I4(\out_addr_q[2]_i_1_n_0 ),
        .O(local_rr_d));
  FDCE \local_rr_q_reg[0][0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(\local_rr_q[0][0]_i_1_n_0 ),
        .Q(\local_rr_q_reg[0] [0]));
  FDCE \local_rr_q_reg[0][1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(\local_rr_q[0][1]_i_1_n_0 ),
        .Q(\local_rr_q_reg[0] [1]));
  FDCE \local_rr_q_reg[1][0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(\local_rr_q[1][0]_i_1_n_0 ),
        .Q(\local_rr_q_reg[1] [0]));
  FDCE \local_rr_q_reg[1][1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(\local_rr_q[1][1]_i_1_n_0 ),
        .Q(\local_rr_q_reg[1] [1]));
  FDCE \local_rr_q_reg[2][0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(\local_rr_q[2][0]_i_1_n_0 ),
        .Q(\local_rr_q_reg_n_0_[2][0] ));
  FDCE \local_rr_q_reg[2][1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(\local_rr_q[2][1]_i_1_n_0 ),
        .Q(\local_rr_q_reg_n_0_[2][1] ));
  FDCE \local_rr_q_reg[3][0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(\local_rr_q[3][0]_i_1_n_0 ),
        .Q(\local_rr_q_reg_n_0_[3][0] ));
  FDCE \local_rr_q_reg[3][1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(\local_rr_q[3][1]_i_1_n_0 ),
        .Q(\local_rr_q_reg_n_0_[3][1] ));
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
    .INIT(64'hFFFFFFF8FFF8FFF8)) 
    \out_addr_q[0]_i_1 
       (.I0(\out_addr_q[1]_i_2_n_0 ),
        .I1(\out_addr_q[0]_i_2_n_0 ),
        .I2(\out_addr_q[0]_i_3_n_0 ),
        .I3(\out_addr_q[0]_i_4_n_0 ),
        .I4(\out_addr_q[1]_i_6_n_0 ),
        .I5(\out_addr_q[0]_i_5_n_0 ),
        .O(\out_addr_q[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA22020FFB33F22)) 
    \out_addr_q[0]_i_2 
       (.I0(pending_d2_out__10),
        .I1(pending_d2_out__9),
        .I2(\local_rr_q_reg_n_0_[2][1] ),
        .I3(pending_d2_out__8),
        .I4(\local_rr_q_reg_n_0_[2][0] ),
        .I5(pending_d2_out__7),
        .O(\out_addr_q[0]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hB8880000)) 
    \out_addr_q[0]_i_3 
       (.I0(\local_rr_q[0][1]_i_10_n_0 ),
        .I1(\group_rr_q[1]_i_3_n_0 ),
        .I2(group_rr_q[1]),
        .I3(group_rr_q[0]),
        .I4(\local_rr_q[0][1]_i_12_n_0 ),
        .O(\out_addr_q[0]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'h080AA2A0)) 
    \out_addr_q[0]_i_4 
       (.I0(\local_rr_q[0][1]_i_8_n_0 ),
        .I1(local_valid139_out),
        .I2(local_valid142_out),
        .I3(local_valid136_out),
        .I4(\local_rr_q_reg[0] [0]),
        .O(\out_addr_q[0]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA22020FFB33F22)) 
    \out_addr_q[0]_i_5 
       (.I0(pending_d2_out__6),
        .I1(pending_d2_out__5),
        .I2(\local_rr_q_reg[1] [1]),
        .I3(pending_d2_out__4),
        .I4(\local_rr_q_reg[1] [0]),
        .I5(pending_d2_out__3),
        .O(\out_addr_q[0]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFF8FFF8FFF8)) 
    \out_addr_q[1]_i_1 
       (.I0(\out_addr_q[1]_i_2_n_0 ),
        .I1(\out_addr_q[1]_i_3_n_0 ),
        .I2(\out_addr_q[1]_i_4_n_0 ),
        .I3(\out_addr_q[1]_i_5_n_0 ),
        .I4(\out_addr_q[1]_i_6_n_0 ),
        .I5(\out_addr_q[1]_i_7_n_0 ),
        .O(\out_addr_q[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h505C2020000C2F20)) 
    \out_addr_q[1]_i_10 
       (.I0(pending_d2_out__2),
        .I1(pending_d2_out__1),
        .I2(\local_rr_q_reg[0] [1]),
        .I3(pending_d2_out__0),
        .I4(\local_rr_q_reg[0] [0]),
        .I5(pending_d__0),
        .O(local_valid136_out));
  LUT6 #(
    .INIT(64'h330D0000370D0100)) 
    \out_addr_q[1]_i_2 
       (.I0(\out_addr_q[3]_i_6_n_0 ),
        .I1(group_rr_q[0]),
        .I2(local_valid0_in),
        .I3(group_rr_q[1]),
        .I4(local_valid),
        .I5(local_valid2_out),
        .O(\out_addr_q[1]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hA0AEE0E0A0FEE0FE)) 
    \out_addr_q[1]_i_3 
       (.I0(pending_d2_out__10),
        .I1(pending_d2_out__9),
        .I2(\local_rr_q_reg_n_0_[2][1] ),
        .I3(pending_d2_out__8),
        .I4(\local_rr_q_reg_n_0_[2][0] ),
        .I5(pending_d2_out__7),
        .O(\out_addr_q[1]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'hB8880000)) 
    \out_addr_q[1]_i_4 
       (.I0(\local_rr_q[0][1]_i_10_n_0 ),
        .I1(\group_rr_q[1]_i_3_n_0 ),
        .I2(group_rr_q[1]),
        .I3(group_rr_q[0]),
        .I4(\local_rr_q[0][1]_i_9_n_0 ),
        .O(\out_addr_q[1]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h880222A8880A22A0)) 
    \out_addr_q[1]_i_5 
       (.I0(\local_rr_q[0][1]_i_8_n_0 ),
        .I1(\local_rr_q_reg[0] [0]),
        .I2(local_valid139_out),
        .I3(local_valid142_out),
        .I4(\local_rr_q_reg[0] [1]),
        .I5(local_valid136_out),
        .O(\out_addr_q[1]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h00D000D040D050D4)) 
    \out_addr_q[1]_i_6 
       (.I0(\out_addr_q[3]_i_6_n_0 ),
        .I1(group_rr_q[0]),
        .I2(local_valid0_in),
        .I3(group_rr_q[1]),
        .I4(local_valid),
        .I5(local_valid2_out),
        .O(\out_addr_q[1]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hA0AEE0E0A0FEE0FE)) 
    \out_addr_q[1]_i_7 
       (.I0(pending_d2_out__6),
        .I1(pending_d2_out__5),
        .I2(\local_rr_q_reg[1] [1]),
        .I3(pending_d2_out__4),
        .I4(\local_rr_q_reg[1] [0]),
        .I5(pending_d2_out__3),
        .O(\out_addr_q[1]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h0001000C40016200)) 
    \out_addr_q[1]_i_8 
       (.I0(pending_d__0),
        .I1(\local_rr_q_reg[0] [0]),
        .I2(pending_d2_out__0),
        .I3(\local_rr_q_reg[0] [1]),
        .I4(pending_d2_out__1),
        .I5(pending_d2_out__2),
        .O(local_valid139_out));
  LUT6 #(
    .INIT(64'h0001000000401002)) 
    \out_addr_q[1]_i_9 
       (.I0(pending_d2_out__2),
        .I1(pending_d2_out__1),
        .I2(\local_rr_q_reg[0] [1]),
        .I3(pending_d2_out__0),
        .I4(\local_rr_q_reg[0] [0]),
        .I5(pending_d__0),
        .O(local_valid142_out));
  LUT6 #(
    .INIT(64'hAFA22020FFB33F22)) 
    \out_addr_q[2]_i_1 
       (.I0(local_valid2_out),
        .I1(local_valid),
        .I2(group_rr_q[1]),
        .I3(local_valid0_in),
        .I4(group_rr_q[0]),
        .I5(\out_addr_q[3]_i_6_n_0 ),
        .O(\out_addr_q[2]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hA2)) 
    \out_addr_q[3]_i_1 
       (.I0(\group_rr_q[1]_i_3_n_0 ),
        .I1(out_valid_OBUF),
        .I2(out_ready_IBUF),
        .O(group_rr_d));
  LUT6 #(
    .INIT(64'hA0AEE0E0A0FEE0FE)) 
    \out_addr_q[3]_i_2 
       (.I0(local_valid2_out),
        .I1(local_valid),
        .I2(group_rr_q[1]),
        .I3(local_valid0_in),
        .I4(group_rr_q[0]),
        .I5(\out_addr_q[3]_i_6_n_0 ),
        .O(\out_addr_q[3]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \out_addr_q[3]_i_3 
       (.I0(pending_d2_out__11),
        .I1(pending_d2_out__12),
        .I2(pending_d__1),
        .I3(\pending_q[15]_i_2_n_0 ),
        .O(local_valid2_out));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \out_addr_q[3]_i_4 
       (.I0(pending_d2_out__7),
        .I1(pending_d2_out__8),
        .I2(pending_d2_out__9),
        .I3(pending_d2_out__10),
        .O(local_valid));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \out_addr_q[3]_i_5 
       (.I0(pending_d2_out__3),
        .I1(pending_d2_out__4),
        .I2(pending_d2_out__5),
        .I3(pending_d2_out__6),
        .O(local_valid0_in));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \out_addr_q[3]_i_6 
       (.I0(pending_d__0),
        .I1(pending_d2_out__0),
        .I2(pending_d2_out__1),
        .I3(pending_d2_out__2),
        .O(\out_addr_q[3]_i_6_n_0 ));
  FDCE \out_addr_q_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(group_rr_d),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(\out_addr_q[0]_i_1_n_0 ),
        .Q(out_addr_OBUF[0]));
  FDCE \out_addr_q_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(group_rr_d),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(\out_addr_q[1]_i_1_n_0 ),
        .Q(out_addr_OBUF[1]));
  FDCE \out_addr_q_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(group_rr_d),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(\out_addr_q[2]_i_1_n_0 ),
        .Q(out_addr_OBUF[2]));
  FDCE \out_addr_q_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(group_rr_d),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(\out_addr_q[3]_i_2_n_0 ),
        .Q(out_addr_OBUF[3]));
  IBUF out_ready_IBUF_inst
       (.I(out_ready),
        .O(out_ready_IBUF));
  OBUF out_valid_OBUF_inst
       (.I(out_valid_OBUF),
        .O(out_valid));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'hBA)) 
    out_valid_q_i_1
       (.I0(\group_rr_q[1]_i_3_n_0 ),
        .I1(out_ready_IBUF),
        .I2(out_valid_OBUF),
        .O(out_valid_q_i_1_n_0));
  FDCE out_valid_q_reg
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(out_valid_q_i_1_n_0),
        .Q(out_valid_OBUF));
  LUT6 #(
    .INIT(64'hFFFF0000FFFE0000)) 
    \pending_q[0]_i_1 
       (.I0(\local_rr_q[0][1]_i_2_n_0 ),
        .I1(\local_rr_q[0][1]_i_3_n_0 ),
        .I2(\local_rr_q[0][1]_i_4_n_0 ),
        .I3(\local_rr_q[0][1]_i_5_n_0 ),
        .I4(pending_d__0),
        .I5(\local_rr_q[0][1]_i_6_n_0 ),
        .O(pending_d__2[0]));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_q[0]_i_2 
       (.I0(src_ack_async_OBUF[0]),
        .I1(req_sync_q[0]),
        .I2(\pending_q_reg_n_0_[0] ),
        .O(pending_d__0));
  LUT6 #(
    .INIT(64'hCCC8CCC8CCC8CCCC)) 
    \pending_q[10]_i_1 
       (.I0(\local_rr_q[2][1]_i_2_n_0 ),
        .I1(pending_d2_out__9),
        .I2(\local_rr_q[0][1]_i_4_n_0 ),
        .I3(\local_rr_q[0][1]_i_5_n_0 ),
        .I4(\local_rr_q[0][1]_i_2_n_0 ),
        .I5(\local_rr_q[0][1]_i_3_n_0 ),
        .O(pending_d__2[10]));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_q[10]_i_2 
       (.I0(src_ack_async_OBUF[10]),
        .I1(req_sync_q[10]),
        .I2(\pending_q_reg_n_0_[10] ),
        .O(pending_d2_out__9));
  LUT6 #(
    .INIT(64'h888C888C888CCCCC)) 
    \pending_q[11]_i_1 
       (.I0(\local_rr_q[2][1]_i_2_n_0 ),
        .I1(pending_d2_out__10),
        .I2(\local_rr_q[0][1]_i_2_n_0 ),
        .I3(\local_rr_q[0][1]_i_3_n_0 ),
        .I4(\local_rr_q[0][1]_i_4_n_0 ),
        .I5(\local_rr_q[0][1]_i_5_n_0 ),
        .O(pending_d__2[11]));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_q[11]_i_2 
       (.I0(src_ack_async_OBUF[11]),
        .I1(req_sync_q[11]),
        .I2(\pending_q_reg_n_0_[11] ),
        .O(pending_d2_out__10));
  LUT6 #(
    .INIT(64'hCCCCCCCCCCCCCCC8)) 
    \pending_q[12]_i_1 
       (.I0(\pending_q[15]_i_3_n_0 ),
        .I1(pending_d2_out__11),
        .I2(\local_rr_q[0][1]_i_2_n_0 ),
        .I3(\local_rr_q[0][1]_i_3_n_0 ),
        .I4(\local_rr_q[0][1]_i_4_n_0 ),
        .I5(\local_rr_q[0][1]_i_5_n_0 ),
        .O(pending_d__2[12]));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_q[12]_i_2 
       (.I0(src_ack_async_OBUF[12]),
        .I1(req_sync_q[12]),
        .I2(\pending_q_reg_n_0_[12] ),
        .O(pending_d2_out__11));
  LUT6 #(
    .INIT(64'hCCC8CCC8CCC8CCCC)) 
    \pending_q[13]_i_1 
       (.I0(\pending_q[15]_i_3_n_0 ),
        .I1(pending_d2_out__12),
        .I2(\local_rr_q[0][1]_i_2_n_0 ),
        .I3(\local_rr_q[0][1]_i_3_n_0 ),
        .I4(\local_rr_q[0][1]_i_4_n_0 ),
        .I5(\local_rr_q[0][1]_i_5_n_0 ),
        .O(pending_d__2[13]));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_q[13]_i_2 
       (.I0(src_ack_async_OBUF[13]),
        .I1(req_sync_q[13]),
        .I2(\pending_q_reg_n_0_[13] ),
        .O(pending_d2_out__12));
  LUT6 #(
    .INIT(64'hCCC8CCC8CCC8CCCC)) 
    \pending_q[14]_i_1 
       (.I0(\pending_q[15]_i_3_n_0 ),
        .I1(pending_d__1),
        .I2(\local_rr_q[0][1]_i_4_n_0 ),
        .I3(\local_rr_q[0][1]_i_5_n_0 ),
        .I4(\local_rr_q[0][1]_i_2_n_0 ),
        .I5(\local_rr_q[0][1]_i_3_n_0 ),
        .O(pending_d__2[14]));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_q[14]_i_2 
       (.I0(src_ack_async_OBUF[14]),
        .I1(req_sync_q[14]),
        .I2(\pending_q_reg_n_0_[14] ),
        .O(pending_d__1));
  LUT6 #(
    .INIT(64'hFFFF0000111F0000)) 
    \pending_q[15]_i_1 
       (.I0(\local_rr_q[0][1]_i_2_n_0 ),
        .I1(\local_rr_q[0][1]_i_3_n_0 ),
        .I2(\local_rr_q[0][1]_i_4_n_0 ),
        .I3(\local_rr_q[0][1]_i_5_n_0 ),
        .I4(\pending_q[15]_i_2_n_0 ),
        .I5(\pending_q[15]_i_3_n_0 ),
        .O(pending_d__2[15]));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_q[15]_i_2 
       (.I0(src_ack_async_OBUF[15]),
        .I1(req_sync_q[15]),
        .I2(\pending_q_reg_n_0_[15] ),
        .O(\pending_q[15]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'h4FFF)) 
    \pending_q[15]_i_3 
       (.I0(out_ready_IBUF),
        .I1(out_valid_OBUF),
        .I2(\group_rr_q[1]_i_3_n_0 ),
        .I3(\local_rr_q[0][1]_i_10_n_0 ),
        .O(\pending_q[15]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFFFF0000EEEF0000)) 
    \pending_q[1]_i_1 
       (.I0(\local_rr_q[0][1]_i_2_n_0 ),
        .I1(\local_rr_q[0][1]_i_3_n_0 ),
        .I2(\local_rr_q[0][1]_i_4_n_0 ),
        .I3(\local_rr_q[0][1]_i_5_n_0 ),
        .I4(pending_d2_out__0),
        .I5(\local_rr_q[0][1]_i_6_n_0 ),
        .O(pending_d__2[1]));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_q[1]_i_2 
       (.I0(src_ack_async_OBUF[1]),
        .I1(req_sync_q[1]),
        .I2(p_0_in),
        .O(pending_d2_out__0));
  LUT6 #(
    .INIT(64'hFFFF0000EEEF0000)) 
    \pending_q[2]_i_1 
       (.I0(\local_rr_q[0][1]_i_4_n_0 ),
        .I1(\local_rr_q[0][1]_i_5_n_0 ),
        .I2(\local_rr_q[0][1]_i_2_n_0 ),
        .I3(\local_rr_q[0][1]_i_3_n_0 ),
        .I4(pending_d2_out__1),
        .I5(\local_rr_q[0][1]_i_6_n_0 ),
        .O(pending_d__2[2]));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_q[2]_i_2 
       (.I0(src_ack_async_OBUF[2]),
        .I1(req_sync_q[2]),
        .I2(\pending_q_reg_n_0_[2] ),
        .O(pending_d2_out__1));
  LUT6 #(
    .INIT(64'hFFFF0000111F0000)) 
    \pending_q[3]_i_1 
       (.I0(\local_rr_q[0][1]_i_2_n_0 ),
        .I1(\local_rr_q[0][1]_i_3_n_0 ),
        .I2(\local_rr_q[0][1]_i_4_n_0 ),
        .I3(\local_rr_q[0][1]_i_5_n_0 ),
        .I4(pending_d2_out__2),
        .I5(\local_rr_q[0][1]_i_6_n_0 ),
        .O(pending_d__2[3]));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_q[3]_i_2 
       (.I0(src_ack_async_OBUF[3]),
        .I1(req_sync_q[3]),
        .I2(\pending_q_reg_n_0_[3] ),
        .O(pending_d2_out__2));
  LUT6 #(
    .INIT(64'hFFFF0000FFFE0000)) 
    \pending_q[4]_i_1 
       (.I0(\local_rr_q[0][1]_i_2_n_0 ),
        .I1(\local_rr_q[0][1]_i_3_n_0 ),
        .I2(\local_rr_q[0][1]_i_4_n_0 ),
        .I3(\local_rr_q[0][1]_i_5_n_0 ),
        .I4(pending_d2_out__3),
        .I5(\local_rr_q[1][1]_i_2_n_0 ),
        .O(pending_d__2[4]));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_q[4]_i_2 
       (.I0(src_ack_async_OBUF[4]),
        .I1(req_sync_q[4]),
        .I2(\pending_q_reg_n_0_[4] ),
        .O(pending_d2_out__3));
  LUT6 #(
    .INIT(64'hFFFF0000EEEF0000)) 
    \pending_q[5]_i_1 
       (.I0(\local_rr_q[0][1]_i_2_n_0 ),
        .I1(\local_rr_q[0][1]_i_3_n_0 ),
        .I2(\local_rr_q[0][1]_i_4_n_0 ),
        .I3(\local_rr_q[0][1]_i_5_n_0 ),
        .I4(pending_d2_out__4),
        .I5(\local_rr_q[1][1]_i_2_n_0 ),
        .O(pending_d__2[5]));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_q[5]_i_2 
       (.I0(src_ack_async_OBUF[5]),
        .I1(req_sync_q[5]),
        .I2(\pending_q_reg_n_0_[5] ),
        .O(pending_d2_out__4));
  LUT6 #(
    .INIT(64'hFFFF0000EEEF0000)) 
    \pending_q[6]_i_1 
       (.I0(\local_rr_q[0][1]_i_4_n_0 ),
        .I1(\local_rr_q[0][1]_i_5_n_0 ),
        .I2(\local_rr_q[0][1]_i_2_n_0 ),
        .I3(\local_rr_q[0][1]_i_3_n_0 ),
        .I4(pending_d2_out__5),
        .I5(\local_rr_q[1][1]_i_2_n_0 ),
        .O(pending_d__2[6]));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_q[6]_i_2 
       (.I0(src_ack_async_OBUF[6]),
        .I1(req_sync_q[6]),
        .I2(\pending_q_reg_n_0_[6] ),
        .O(pending_d2_out__5));
  LUT6 #(
    .INIT(64'hFFFF0000111F0000)) 
    \pending_q[7]_i_1 
       (.I0(\local_rr_q[0][1]_i_2_n_0 ),
        .I1(\local_rr_q[0][1]_i_3_n_0 ),
        .I2(\local_rr_q[0][1]_i_4_n_0 ),
        .I3(\local_rr_q[0][1]_i_5_n_0 ),
        .I4(pending_d2_out__6),
        .I5(\local_rr_q[1][1]_i_2_n_0 ),
        .O(pending_d__2[7]));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_q[7]_i_2 
       (.I0(src_ack_async_OBUF[7]),
        .I1(req_sync_q[7]),
        .I2(\pending_q_reg_n_0_[7] ),
        .O(pending_d2_out__6));
  LUT6 #(
    .INIT(64'hCCCCCCCCCCCCCCC8)) 
    \pending_q[8]_i_1 
       (.I0(\local_rr_q[2][1]_i_2_n_0 ),
        .I1(pending_d2_out__7),
        .I2(\local_rr_q[0][1]_i_2_n_0 ),
        .I3(\local_rr_q[0][1]_i_3_n_0 ),
        .I4(\local_rr_q[0][1]_i_4_n_0 ),
        .I5(\local_rr_q[0][1]_i_5_n_0 ),
        .O(pending_d__2[8]));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_q[8]_i_2 
       (.I0(src_ack_async_OBUF[8]),
        .I1(req_sync_q[8]),
        .I2(\pending_q_reg_n_0_[8] ),
        .O(pending_d2_out__7));
  LUT6 #(
    .INIT(64'hCCC8CCC8CCC8CCCC)) 
    \pending_q[9]_i_1 
       (.I0(\local_rr_q[2][1]_i_2_n_0 ),
        .I1(pending_d2_out__8),
        .I2(\local_rr_q[0][1]_i_2_n_0 ),
        .I3(\local_rr_q[0][1]_i_3_n_0 ),
        .I4(\local_rr_q[0][1]_i_4_n_0 ),
        .I5(\local_rr_q[0][1]_i_5_n_0 ),
        .O(pending_d__2[9]));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_q[9]_i_2 
       (.I0(src_ack_async_OBUF[9]),
        .I1(req_sync_q[9]),
        .I2(\pending_q_reg_n_0_[9] ),
        .O(pending_d2_out__8));
  FDCE \pending_q_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(pending_d__2[0]),
        .Q(\pending_q_reg_n_0_[0] ));
  FDCE \pending_q_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(pending_d__2[10]),
        .Q(\pending_q_reg_n_0_[10] ));
  FDCE \pending_q_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(pending_d__2[11]),
        .Q(\pending_q_reg_n_0_[11] ));
  FDCE \pending_q_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(pending_d__2[12]),
        .Q(\pending_q_reg_n_0_[12] ));
  FDCE \pending_q_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(pending_d__2[13]),
        .Q(\pending_q_reg_n_0_[13] ));
  FDCE \pending_q_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(pending_d__2[14]),
        .Q(\pending_q_reg_n_0_[14] ));
  FDCE \pending_q_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(pending_d__2[15]),
        .Q(\pending_q_reg_n_0_[15] ));
  FDCE \pending_q_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(pending_d__2[1]),
        .Q(p_0_in));
  FDCE \pending_q_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(pending_d__2[2]),
        .Q(\pending_q_reg_n_0_[2] ));
  FDCE \pending_q_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(pending_d__2[3]),
        .Q(\pending_q_reg_n_0_[3] ));
  FDCE \pending_q_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(pending_d__2[4]),
        .Q(\pending_q_reg_n_0_[4] ));
  FDCE \pending_q_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(pending_d__2[5]),
        .Q(\pending_q_reg_n_0_[5] ));
  FDCE \pending_q_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(pending_d__2[6]),
        .Q(\pending_q_reg_n_0_[6] ));
  FDCE \pending_q_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(pending_d__2[7]),
        .Q(\pending_q_reg_n_0_[7] ));
  FDCE \pending_q_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(pending_d__2[8]),
        .Q(\pending_q_reg_n_0_[8] ));
  FDCE \pending_q_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(pending_d__2[9]),
        .Q(\pending_q_reg_n_0_[9] ));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(src_req_async_IBUF[0]),
        .Q(req_meta_q[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(src_req_async_IBUF[10]),
        .Q(req_meta_q[10]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(src_req_async_IBUF[11]),
        .Q(req_meta_q[11]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(src_req_async_IBUF[12]),
        .Q(req_meta_q[12]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(src_req_async_IBUF[13]),
        .Q(req_meta_q[13]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(src_req_async_IBUF[14]),
        .Q(req_meta_q[14]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(src_req_async_IBUF[15]),
        .Q(req_meta_q[15]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(src_req_async_IBUF[1]),
        .Q(req_meta_q[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(src_req_async_IBUF[2]),
        .Q(req_meta_q[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(src_req_async_IBUF[3]),
        .Q(req_meta_q[3]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(src_req_async_IBUF[4]),
        .Q(req_meta_q[4]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(src_req_async_IBUF[5]),
        .Q(req_meta_q[5]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(src_req_async_IBUF[6]),
        .Q(req_meta_q[6]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(src_req_async_IBUF[7]),
        .Q(req_meta_q[7]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(src_req_async_IBUF[8]),
        .Q(req_meta_q[8]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(src_req_async_IBUF[9]),
        .Q(req_meta_q[9]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(req_meta_q[0]),
        .Q(req_sync_q[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(req_meta_q[10]),
        .Q(req_sync_q[10]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(req_meta_q[11]),
        .Q(req_sync_q[11]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(req_meta_q[12]),
        .Q(req_sync_q[12]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(req_meta_q[13]),
        .Q(req_sync_q[13]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(req_meta_q[14]),
        .Q(req_sync_q[14]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(req_meta_q[15]),
        .Q(req_sync_q[15]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(req_meta_q[1]),
        .Q(req_sync_q[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(req_meta_q[2]),
        .Q(req_sync_q[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(req_meta_q[3]),
        .Q(req_sync_q[3]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(req_meta_q[4]),
        .Q(req_sync_q[4]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(req_meta_q[5]),
        .Q(req_sync_q[5]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(req_meta_q[6]),
        .Q(req_sync_q[6]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(req_meta_q[7]),
        .Q(req_sync_q[7]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(req_meta_q[8]),
        .Q(req_sync_q[8]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\group_rr_q[1]_i_2_n_0 ),
        .D(req_meta_q[9]),
        .Q(req_sync_q[9]));
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
