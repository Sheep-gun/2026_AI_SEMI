// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Thu Aug 20 12:44:17 2026
// Host        : <LOCAL_HOST> running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               reports/pending_gray_epoch_fallthrough/vivado_robust/aer_pending_gray_epoch_fallthrough_post_synth.v
// Design      : aer_pending_gray_epoch_fallthrough
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* NETLIST_CHECKSUM = "bdda8aee" *) (* ROBUST_RESET = "1'b1" *) 
(* NotValidForBitStream *)
module aer_pending_gray_epoch_fallthrough
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
  wire \ack_q[15]_i_2_n_0 ;
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
  wire [3:0]epoch_bin_q_reg;
  wire \g_robust_reset.reset_release_q[1]_i_1_n_0 ;
  wire hold_addr_d;
  wire [3:0]hold_addr_q;
  wire \hold_addr_q[0]_i_2_n_0 ;
  wire \hold_addr_q[0]_i_3_n_0 ;
  wire \hold_addr_q[0]_i_4_n_0 ;
  wire \hold_addr_q[0]_i_5_n_0 ;
  wire \hold_addr_q[0]_i_6_n_0 ;
  wire \hold_addr_q[0]_i_7_n_0 ;
  wire \hold_addr_q[1]_i_2_n_0 ;
  wire \hold_addr_q[1]_i_3_n_0 ;
  wire \hold_addr_q[1]_i_4_n_0 ;
  wire \hold_addr_q[2]_i_2_n_0 ;
  wire \hold_addr_q[2]_i_3_n_0 ;
  wire \hold_addr_q[2]_i_4_n_0 ;
  wire \hold_addr_q[2]_i_5_n_0 ;
  wire hold_valid_d;
  wire hold_valid_q;
  wire hold_valid_q_i_1_n_0;
  wire [3:0]out_addr;
  wire [3:0]out_addr_OBUF;
  wire \out_addr_OBUF[0]_inst_i_10_n_0 ;
  wire \out_addr_OBUF[0]_inst_i_2_n_0 ;
  wire \out_addr_OBUF[0]_inst_i_3_n_0 ;
  wire \out_addr_OBUF[0]_inst_i_4_n_0 ;
  wire \out_addr_OBUF[0]_inst_i_5_n_0 ;
  wire \out_addr_OBUF[0]_inst_i_6_n_0 ;
  wire \out_addr_OBUF[0]_inst_i_7_n_0 ;
  wire \out_addr_OBUF[0]_inst_i_8_n_0 ;
  wire \out_addr_OBUF[0]_inst_i_9_n_0 ;
  wire \out_addr_OBUF[3]_inst_i_2_n_0 ;
  wire out_ready;
  wire out_ready_IBUF;
  wire out_valid;
  wire out_valid_OBUF;
  wire out_valid_OBUF_inst_i_10_n_0;
  wire out_valid_OBUF_inst_i_11_n_0;
  wire out_valid_OBUF_inst_i_2_n_0;
  wire out_valid_OBUF_inst_i_3_n_0;
  wire out_valid_OBUF_inst_i_4_n_0;
  wire out_valid_OBUF_inst_i_5_n_0;
  wire out_valid_OBUF_inst_i_6_n_0;
  wire out_valid_OBUF_inst_i_7_n_0;
  wire out_valid_OBUF_inst_i_8_n_0;
  wire out_valid_OBUF_inst_i_9_n_0;
  wire [3:0]p_0_in;
  wire p_0_in__0;
  wire p_1_in__0;
  wire [15:0]pending_d__2;
  wire [0:0]pending_q;
  wire \pending_q[0]_i_2_n_0 ;
  wire \pending_q[10]_i_2_n_0 ;
  wire \pending_q[11]_i_2_n_0 ;
  wire \pending_q[11]_i_3_n_0 ;
  wire \pending_q[12]_i_2_n_0 ;
  wire \pending_q[13]_i_2_n_0 ;
  wire \pending_q[14]_i_2_n_0 ;
  wire \pending_q[15]_i_2_n_0 ;
  wire \pending_q[15]_i_4_n_0 ;
  wire \pending_q[1]_i_2_n_0 ;
  wire \pending_q[2]_i_2_n_0 ;
  wire \pending_q[3]_i_2_n_0 ;
  wire \pending_q[3]_i_3_n_0 ;
  wire \pending_q[4]_i_2_n_0 ;
  wire \pending_q[5]_i_2_n_0 ;
  wire \pending_q[6]_i_2_n_0 ;
  wire \pending_q[7]_i_2_n_0 ;
  wire \pending_q[7]_i_3_n_0 ;
  wire \pending_q[8]_i_2_n_0 ;
  wire \pending_q[9]_i_2_n_0 ;
  wire \pending_q_reg[15]_i_3_n_0 ;
  wire \pending_q_reg_n_0_[10] ;
  wire \pending_q_reg_n_0_[11] ;
  wire \pending_q_reg_n_0_[12] ;
  wire \pending_q_reg_n_0_[13] ;
  wire \pending_q_reg_n_0_[14] ;
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
  (* async_reg = "true" *) wire [1:0]reset_release_q;
  wire rst_n;
  wire rst_n_IBUF;
  wire [3:1]selected_addr;
  wire [0:0]selected_addr__0;
  wire [15:0]src_ack_async;
  wire [15:0]src_ack_async_OBUF;
  wire [15:0]src_req_async;
  wire [15:0]src_req_async_IBUF;

  LUT3 #(
    .INIT(8'hC4)) 
    \ack_q[0]_i_1 
       (.I0(pending_q),
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
       (.I0(p_1_in__0),
        .I1(req_sync_q[15]),
        .I2(src_ack_async_OBUF[15]),
        .O(\ack_q[15]_i_1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \ack_q[15]_i_2 
       (.I0(reset_release_q[1]),
        .O(\ack_q[15]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hC4)) 
    \ack_q[1]_i_1 
       (.I0(p_0_in__0),
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
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(\ack_q[0]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[0]));
  FDCE \ack_q_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(\ack_q[10]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[10]));
  FDCE \ack_q_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(\ack_q[11]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[11]));
  FDCE \ack_q_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(\ack_q[12]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[12]));
  FDCE \ack_q_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(\ack_q[13]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[13]));
  FDCE \ack_q_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(\ack_q[14]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[14]));
  FDCE \ack_q_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(\ack_q[15]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[15]));
  FDCE \ack_q_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(\ack_q[1]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[1]));
  FDCE \ack_q_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(\ack_q[2]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[2]));
  FDCE \ack_q_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(\ack_q[3]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[3]));
  FDCE \ack_q_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(\ack_q[4]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[4]));
  FDCE \ack_q_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(\ack_q[5]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[5]));
  FDCE \ack_q_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(\ack_q[6]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[6]));
  FDCE \ack_q_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(\ack_q[7]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[7]));
  FDCE \ack_q_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(\ack_q[8]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[8]));
  FDCE \ack_q_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(\ack_q[9]_i_1_n_0 ),
        .Q(src_ack_async_OBUF[9]));
  BUFG clk_IBUF_BUFG_inst
       (.I(clk_IBUF),
        .O(clk_IBUF_BUFG));
  IBUF clk_IBUF_inst
       (.I(clk),
        .O(clk_IBUF));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \epoch_bin_q[0]_i_1 
       (.I0(epoch_bin_q_reg[0]),
        .O(p_0_in[0]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \epoch_bin_q[1]_i_1 
       (.I0(epoch_bin_q_reg[0]),
        .I1(epoch_bin_q_reg[1]),
        .O(p_0_in[1]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'h6A)) 
    \epoch_bin_q[2]_i_1 
       (.I0(epoch_bin_q_reg[2]),
        .I1(epoch_bin_q_reg[1]),
        .I2(epoch_bin_q_reg[0]),
        .O(p_0_in[2]));
  LUT3 #(
    .INIT(8'h0D)) 
    \epoch_bin_q[3]_i_1 
       (.I0(out_valid_OBUF_inst_i_2_n_0),
        .I1(out_valid_OBUF_inst_i_3_n_0),
        .I2(hold_valid_q),
        .O(hold_valid_d));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'h6AAA)) 
    \epoch_bin_q[3]_i_2 
       (.I0(epoch_bin_q_reg[3]),
        .I1(epoch_bin_q_reg[0]),
        .I2(epoch_bin_q_reg[1]),
        .I3(epoch_bin_q_reg[2]),
        .O(p_0_in[3]));
  FDCE \epoch_bin_q_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(hold_valid_d),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(p_0_in[0]),
        .Q(epoch_bin_q_reg[0]));
  FDCE \epoch_bin_q_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(hold_valid_d),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(p_0_in[1]),
        .Q(epoch_bin_q_reg[1]));
  FDCE \epoch_bin_q_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(hold_valid_d),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(p_0_in[2]),
        .Q(epoch_bin_q_reg[2]));
  FDCE \epoch_bin_q_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(hold_valid_d),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(p_0_in[3]),
        .Q(epoch_bin_q_reg[3]));
  LUT1 #(
    .INIT(2'h1)) 
    \g_robust_reset.reset_release_q[1]_i_1 
       (.I0(rst_n_IBUF),
        .O(\g_robust_reset.reset_release_q[1]_i_1_n_0 ));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \g_robust_reset.reset_release_q_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\g_robust_reset.reset_release_q[1]_i_1_n_0 ),
        .D(1'b1),
        .Q(reset_release_q[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \g_robust_reset.reset_release_q_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\g_robust_reset.reset_release_q[1]_i_1_n_0 ),
        .D(reset_release_q[0]),
        .Q(reset_release_q[1]));
  LUT6 #(
    .INIT(64'h333C993C663CCC3C)) 
    \hold_addr_q[0]_i_1 
       (.I0(selected_addr[2]),
        .I1(p_0_in[1]),
        .I2(\out_addr_OBUF[0]_inst_i_2_n_0 ),
        .I3(\out_addr_OBUF[3]_inst_i_2_n_0 ),
        .I4(\hold_addr_q[0]_i_2_n_0 ),
        .I5(\hold_addr_q[0]_i_3_n_0 ),
        .O(selected_addr__0));
  LUT6 #(
    .INIT(64'hEEEBBBEB22288828)) 
    \hold_addr_q[0]_i_2 
       (.I0(\hold_addr_q[0]_i_4_n_0 ),
        .I1(\hold_addr_q[1]_i_4_n_0 ),
        .I2(\hold_addr_q[1]_i_2_n_0 ),
        .I3(\out_addr_OBUF[3]_inst_i_2_n_0 ),
        .I4(\hold_addr_q[1]_i_3_n_0 ),
        .I5(\hold_addr_q[0]_i_5_n_0 ),
        .O(\hold_addr_q[0]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEEEBBBEB22288828)) 
    \hold_addr_q[0]_i_3 
       (.I0(\hold_addr_q[0]_i_6_n_0 ),
        .I1(\hold_addr_q[1]_i_4_n_0 ),
        .I2(\hold_addr_q[1]_i_2_n_0 ),
        .I3(\out_addr_OBUF[3]_inst_i_2_n_0 ),
        .I4(\hold_addr_q[1]_i_3_n_0 ),
        .I5(\hold_addr_q[0]_i_7_n_0 ),
        .O(\hold_addr_q[0]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h00FF4545454500FF)) 
    \hold_addr_q[0]_i_4 
       (.I0(\pending_q_reg_n_0_[7] ),
        .I1(src_ack_async_OBUF[7]),
        .I2(req_sync_q[7]),
        .I3(\pending_q[6]_i_2_n_0 ),
        .I4(epoch_bin_q_reg[0]),
        .I5(epoch_bin_q_reg[1]),
        .O(\hold_addr_q[0]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h00FF4545454500FF)) 
    \hold_addr_q[0]_i_5 
       (.I0(\pending_q_reg_n_0_[5] ),
        .I1(src_ack_async_OBUF[5]),
        .I2(req_sync_q[5]),
        .I3(\pending_q[4]_i_2_n_0 ),
        .I4(epoch_bin_q_reg[0]),
        .I5(epoch_bin_q_reg[1]),
        .O(\hold_addr_q[0]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h00FF4545454500FF)) 
    \hold_addr_q[0]_i_6 
       (.I0(\pending_q_reg_n_0_[3] ),
        .I1(src_ack_async_OBUF[3]),
        .I2(req_sync_q[3]),
        .I3(\pending_q[2]_i_2_n_0 ),
        .I4(epoch_bin_q_reg[0]),
        .I5(epoch_bin_q_reg[1]),
        .O(\hold_addr_q[0]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h00FF4545454500FF)) 
    \hold_addr_q[0]_i_7 
       (.I0(p_0_in__0),
        .I1(src_ack_async_OBUF[1]),
        .I2(req_sync_q[1]),
        .I3(\pending_q[0]_i_2_n_0 ),
        .I4(epoch_bin_q_reg[0]),
        .I5(epoch_bin_q_reg[1]),
        .O(\hold_addr_q[0]_i_7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h99966696)) 
    \hold_addr_q[1]_i_1 
       (.I0(epoch_bin_q_reg[2]),
        .I1(epoch_bin_q_reg[1]),
        .I2(\hold_addr_q[1]_i_2_n_0 ),
        .I3(\out_addr_OBUF[3]_inst_i_2_n_0 ),
        .I4(\hold_addr_q[1]_i_3_n_0 ),
        .O(selected_addr[1]));
  LUT6 #(
    .INIT(64'hCFCFC0C0505F505F)) 
    \hold_addr_q[1]_i_2 
       (.I0(out_valid_OBUF_inst_i_4_n_0),
        .I1(out_valid_OBUF_inst_i_5_n_0),
        .I2(selected_addr[2]),
        .I3(out_valid_OBUF_inst_i_6_n_0),
        .I4(out_valid_OBUF_inst_i_7_n_0),
        .I5(\hold_addr_q[1]_i_4_n_0 ),
        .O(\hold_addr_q[1]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFCFC0C0C05F505F5)) 
    \hold_addr_q[1]_i_3 
       (.I0(out_valid_OBUF_inst_i_10_n_0),
        .I1(out_valid_OBUF_inst_i_11_n_0),
        .I2(selected_addr[2]),
        .I3(out_valid_OBUF_inst_i_8_n_0),
        .I4(out_valid_OBUF_inst_i_9_n_0),
        .I5(\hold_addr_q[1]_i_4_n_0 ),
        .O(\hold_addr_q[1]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \hold_addr_q[1]_i_4 
       (.I0(epoch_bin_q_reg[1]),
        .I1(epoch_bin_q_reg[2]),
        .O(\hold_addr_q[1]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h8D4E000EFFCE558E)) 
    \hold_addr_q[2]_i_1 
       (.I0(epoch_bin_q_reg[2]),
        .I1(\hold_addr_q[2]_i_2_n_0 ),
        .I2(\hold_addr_q[2]_i_3_n_0 ),
        .I3(epoch_bin_q_reg[3]),
        .I4(\hold_addr_q[2]_i_4_n_0 ),
        .I5(\hold_addr_q[2]_i_5_n_0 ),
        .O(selected_addr[2]));
  LUT5 #(
    .INIT(32'h00001011)) 
    \hold_addr_q[2]_i_2 
       (.I0(\pending_q[2]_i_2_n_0 ),
        .I1(\pending_q_reg_n_0_[3] ),
        .I2(src_ack_async_OBUF[3]),
        .I3(req_sync_q[3]),
        .I4(out_valid_OBUF_inst_i_10_n_0),
        .O(\hold_addr_q[2]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h00001011)) 
    \hold_addr_q[2]_i_3 
       (.I0(\pending_q[6]_i_2_n_0 ),
        .I1(\pending_q_reg_n_0_[7] ),
        .I2(src_ack_async_OBUF[7]),
        .I3(req_sync_q[7]),
        .I4(out_valid_OBUF_inst_i_8_n_0),
        .O(\hold_addr_q[2]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'h00001011)) 
    \hold_addr_q[2]_i_4 
       (.I0(\pending_q[10]_i_2_n_0 ),
        .I1(\pending_q_reg_n_0_[11] ),
        .I2(src_ack_async_OBUF[11]),
        .I3(req_sync_q[11]),
        .I4(out_valid_OBUF_inst_i_6_n_0),
        .O(\hold_addr_q[2]_i_4_n_0 ));
  LUT5 #(
    .INIT(32'h00001011)) 
    \hold_addr_q[2]_i_5 
       (.I0(\pending_q[14]_i_2_n_0 ),
        .I1(p_1_in__0),
        .I2(src_ack_async_OBUF[15]),
        .I3(req_sync_q[15]),
        .I4(out_valid_OBUF_inst_i_4_n_0),
        .O(\hold_addr_q[2]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'h000D)) 
    \hold_addr_q[3]_i_1 
       (.I0(out_valid_OBUF_inst_i_2_n_0),
        .I1(out_valid_OBUF_inst_i_3_n_0),
        .I2(hold_valid_q),
        .I3(out_ready_IBUF),
        .O(hold_addr_d));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \hold_addr_q[3]_i_2 
       (.I0(\out_addr_OBUF[3]_inst_i_2_n_0 ),
        .O(selected_addr[3]));
  FDCE \hold_addr_q_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(hold_addr_d),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(selected_addr__0),
        .Q(hold_addr_q[0]));
  FDCE \hold_addr_q_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(hold_addr_d),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(selected_addr[1]),
        .Q(hold_addr_q[1]));
  FDCE \hold_addr_q_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(hold_addr_d),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(selected_addr[2]),
        .Q(hold_addr_q[2]));
  FDCE \hold_addr_q_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(hold_addr_d),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(selected_addr[3]),
        .Q(hold_addr_q[3]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT4 #(
    .INIT(16'h00FD)) 
    hold_valid_q_i_1
       (.I0(out_valid_OBUF_inst_i_2_n_0),
        .I1(out_valid_OBUF_inst_i_3_n_0),
        .I2(hold_valid_q),
        .I3(out_ready_IBUF),
        .O(hold_valid_q_i_1_n_0));
  FDCE hold_valid_q_reg
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(hold_valid_q_i_1_n_0),
        .Q(hold_valid_q));
  OBUF \out_addr_OBUF[0]_inst 
       (.I(out_addr_OBUF[0]),
        .O(out_addr[0]));
  LUT6 #(
    .INIT(64'h8B8B8BB8B8B88BB8)) 
    \out_addr_OBUF[0]_inst_i_1 
       (.I0(hold_addr_q[0]),
        .I1(hold_valid_q),
        .I2(p_0_in[1]),
        .I3(\out_addr_OBUF[0]_inst_i_2_n_0 ),
        .I4(\out_addr_OBUF[3]_inst_i_2_n_0 ),
        .I5(\out_addr_OBUF[0]_inst_i_3_n_0 ),
        .O(out_addr_OBUF[0]));
  LUT6 #(
    .INIT(64'h00FF4545454500FF)) 
    \out_addr_OBUF[0]_inst_i_10 
       (.I0(\pending_q_reg_n_0_[11] ),
        .I1(src_ack_async_OBUF[11]),
        .I2(req_sync_q[11]),
        .I3(\pending_q[10]_i_2_n_0 ),
        .I4(epoch_bin_q_reg[0]),
        .I5(epoch_bin_q_reg[1]),
        .O(\out_addr_OBUF[0]_inst_i_10_n_0 ));
  MUXF7 \out_addr_OBUF[0]_inst_i_2 
       (.I0(\out_addr_OBUF[0]_inst_i_5_n_0 ),
        .I1(\out_addr_OBUF[0]_inst_i_6_n_0 ),
        .O(\out_addr_OBUF[0]_inst_i_2_n_0 ),
        .S(\out_addr_OBUF[0]_inst_i_4_n_0 ));
  MUXF7 \out_addr_OBUF[0]_inst_i_3 
       (.I0(\hold_addr_q[0]_i_2_n_0 ),
        .I1(\hold_addr_q[0]_i_3_n_0 ),
        .O(\out_addr_OBUF[0]_inst_i_3_n_0 ),
        .S(\out_addr_OBUF[0]_inst_i_4_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \out_addr_OBUF[0]_inst_i_4 
       (.I0(selected_addr[2]),
        .O(\out_addr_OBUF[0]_inst_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hBABFEFEA8A80202A)) 
    \out_addr_OBUF[0]_inst_i_5 
       (.I0(\out_addr_OBUF[0]_inst_i_7_n_0 ),
        .I1(\hold_addr_q[1]_i_3_n_0 ),
        .I2(\out_addr_OBUF[3]_inst_i_2_n_0 ),
        .I3(\hold_addr_q[1]_i_2_n_0 ),
        .I4(\hold_addr_q[1]_i_4_n_0 ),
        .I5(\out_addr_OBUF[0]_inst_i_8_n_0 ),
        .O(\out_addr_OBUF[0]_inst_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hBABFEFEA8A80202A)) 
    \out_addr_OBUF[0]_inst_i_6 
       (.I0(\out_addr_OBUF[0]_inst_i_9_n_0 ),
        .I1(\hold_addr_q[1]_i_3_n_0 ),
        .I2(\out_addr_OBUF[3]_inst_i_2_n_0 ),
        .I3(\hold_addr_q[1]_i_2_n_0 ),
        .I4(\hold_addr_q[1]_i_4_n_0 ),
        .I5(\out_addr_OBUF[0]_inst_i_10_n_0 ),
        .O(\out_addr_OBUF[0]_inst_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h00FF4545454500FF)) 
    \out_addr_OBUF[0]_inst_i_7 
       (.I0(\pending_q_reg_n_0_[13] ),
        .I1(src_ack_async_OBUF[13]),
        .I2(req_sync_q[13]),
        .I3(\pending_q[12]_i_2_n_0 ),
        .I4(epoch_bin_q_reg[0]),
        .I5(epoch_bin_q_reg[1]),
        .O(\out_addr_OBUF[0]_inst_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h00FF4545454500FF)) 
    \out_addr_OBUF[0]_inst_i_8 
       (.I0(p_1_in__0),
        .I1(src_ack_async_OBUF[15]),
        .I2(req_sync_q[15]),
        .I3(\pending_q[14]_i_2_n_0 ),
        .I4(epoch_bin_q_reg[0]),
        .I5(epoch_bin_q_reg[1]),
        .O(\out_addr_OBUF[0]_inst_i_8_n_0 ));
  LUT6 #(
    .INIT(64'h00FF4545454500FF)) 
    \out_addr_OBUF[0]_inst_i_9 
       (.I0(\pending_q_reg_n_0_[9] ),
        .I1(src_ack_async_OBUF[9]),
        .I2(req_sync_q[9]),
        .I3(\pending_q[8]_i_2_n_0 ),
        .I4(epoch_bin_q_reg[0]),
        .I5(epoch_bin_q_reg[1]),
        .O(\out_addr_OBUF[0]_inst_i_9_n_0 ));
  OBUF \out_addr_OBUF[1]_inst 
       (.I(out_addr_OBUF[1]),
        .O(out_addr[1]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \out_addr_OBUF[1]_inst_i_1 
       (.I0(hold_addr_q[1]),
        .I1(hold_valid_q),
        .I2(selected_addr[1]),
        .O(out_addr_OBUF[1]));
  OBUF \out_addr_OBUF[2]_inst 
       (.I(out_addr_OBUF[2]),
        .O(out_addr[2]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \out_addr_OBUF[2]_inst_i_1 
       (.I0(hold_addr_q[2]),
        .I1(hold_valid_q),
        .I2(selected_addr[2]),
        .O(out_addr_OBUF[2]));
  OBUF \out_addr_OBUF[3]_inst 
       (.I(out_addr_OBUF[3]),
        .O(out_addr[3]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT3 #(
    .INIT(8'h8B)) 
    \out_addr_OBUF[3]_inst_i_1 
       (.I0(hold_addr_q[3]),
        .I1(hold_valid_q),
        .I2(\out_addr_OBUF[3]_inst_i_2_n_0 ),
        .O(out_addr_OBUF[3]));
  LUT3 #(
    .INIT(8'hB8)) 
    \out_addr_OBUF[3]_inst_i_2 
       (.I0(out_valid_OBUF_inst_i_2_n_0),
        .I1(epoch_bin_q_reg[3]),
        .I2(out_valid_OBUF_inst_i_3_n_0),
        .O(\out_addr_OBUF[3]_inst_i_2_n_0 ));
  IBUF out_ready_IBUF_inst
       (.I(out_ready),
        .O(out_ready_IBUF));
  OBUF out_valid_OBUF_inst
       (.I(out_valid_OBUF),
        .O(out_valid));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT3 #(
    .INIT(8'hFD)) 
    out_valid_OBUF_inst_i_1
       (.I0(out_valid_OBUF_inst_i_2_n_0),
        .I1(out_valid_OBUF_inst_i_3_n_0),
        .I2(hold_valid_q),
        .O(out_valid_OBUF));
  LUT6 #(
    .INIT(64'hFFFFFFFFF2F2FFF2)) 
    out_valid_OBUF_inst_i_10
       (.I0(req_sync_q[1]),
        .I1(src_ack_async_OBUF[1]),
        .I2(p_0_in__0),
        .I3(req_sync_q[0]),
        .I4(src_ack_async_OBUF[0]),
        .I5(pending_q),
        .O(out_valid_OBUF_inst_i_10_n_0));
  LUT6 #(
    .INIT(64'h000000000D0D000D)) 
    out_valid_OBUF_inst_i_11
       (.I0(req_sync_q[3]),
        .I1(src_ack_async_OBUF[3]),
        .I2(\pending_q_reg_n_0_[3] ),
        .I3(req_sync_q[2]),
        .I4(src_ack_async_OBUF[2]),
        .I5(\pending_q_reg_n_0_[2] ),
        .O(out_valid_OBUF_inst_i_11_n_0));
  LUT4 #(
    .INIT(16'h0400)) 
    out_valid_OBUF_inst_i_2
       (.I0(out_valid_OBUF_inst_i_4_n_0),
        .I1(out_valid_OBUF_inst_i_5_n_0),
        .I2(out_valid_OBUF_inst_i_6_n_0),
        .I3(out_valid_OBUF_inst_i_7_n_0),
        .O(out_valid_OBUF_inst_i_2_n_0));
  LUT4 #(
    .INIT(16'hFBFF)) 
    out_valid_OBUF_inst_i_3
       (.I0(out_valid_OBUF_inst_i_8_n_0),
        .I1(out_valid_OBUF_inst_i_9_n_0),
        .I2(out_valid_OBUF_inst_i_10_n_0),
        .I3(out_valid_OBUF_inst_i_11_n_0),
        .O(out_valid_OBUF_inst_i_3_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFFF2F2FFF2)) 
    out_valid_OBUF_inst_i_4
       (.I0(req_sync_q[13]),
        .I1(src_ack_async_OBUF[13]),
        .I2(\pending_q_reg_n_0_[13] ),
        .I3(req_sync_q[12]),
        .I4(src_ack_async_OBUF[12]),
        .I5(\pending_q_reg_n_0_[12] ),
        .O(out_valid_OBUF_inst_i_4_n_0));
  LUT6 #(
    .INIT(64'h000000000D0D000D)) 
    out_valid_OBUF_inst_i_5
       (.I0(req_sync_q[15]),
        .I1(src_ack_async_OBUF[15]),
        .I2(p_1_in__0),
        .I3(req_sync_q[14]),
        .I4(src_ack_async_OBUF[14]),
        .I5(\pending_q_reg_n_0_[14] ),
        .O(out_valid_OBUF_inst_i_5_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFFF2F2FFF2)) 
    out_valid_OBUF_inst_i_6
       (.I0(req_sync_q[9]),
        .I1(src_ack_async_OBUF[9]),
        .I2(\pending_q_reg_n_0_[9] ),
        .I3(req_sync_q[8]),
        .I4(src_ack_async_OBUF[8]),
        .I5(\pending_q_reg_n_0_[8] ),
        .O(out_valid_OBUF_inst_i_6_n_0));
  LUT6 #(
    .INIT(64'h000000000D0D000D)) 
    out_valid_OBUF_inst_i_7
       (.I0(req_sync_q[11]),
        .I1(src_ack_async_OBUF[11]),
        .I2(\pending_q_reg_n_0_[11] ),
        .I3(req_sync_q[10]),
        .I4(src_ack_async_OBUF[10]),
        .I5(\pending_q_reg_n_0_[10] ),
        .O(out_valid_OBUF_inst_i_7_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFFF2F2FFF2)) 
    out_valid_OBUF_inst_i_8
       (.I0(req_sync_q[5]),
        .I1(src_ack_async_OBUF[5]),
        .I2(\pending_q_reg_n_0_[5] ),
        .I3(req_sync_q[4]),
        .I4(src_ack_async_OBUF[4]),
        .I5(\pending_q_reg_n_0_[4] ),
        .O(out_valid_OBUF_inst_i_8_n_0));
  LUT6 #(
    .INIT(64'h000000000D0D000D)) 
    out_valid_OBUF_inst_i_9
       (.I0(req_sync_q[7]),
        .I1(src_ack_async_OBUF[7]),
        .I2(\pending_q_reg_n_0_[7] ),
        .I3(req_sync_q[6]),
        .I4(src_ack_async_OBUF[6]),
        .I5(\pending_q_reg_n_0_[6] ),
        .O(out_valid_OBUF_inst_i_9_n_0));
  LUT6 #(
    .INIT(64'hAAA8A8AAA8AAAAA8)) 
    \pending_q[0]_i_1 
       (.I0(\pending_q[0]_i_2_n_0 ),
        .I1(\pending_q[3]_i_2_n_0 ),
        .I2(selected_addr[1]),
        .I3(\pending_q_reg[15]_i_3_n_0 ),
        .I4(epoch_bin_q_reg[0]),
        .I5(epoch_bin_q_reg[1]),
        .O(pending_d__2[0]));
  LUT3 #(
    .INIT(8'hBA)) 
    \pending_q[0]_i_2 
       (.I0(pending_q),
        .I1(src_ack_async_OBUF[0]),
        .I2(req_sync_q[0]),
        .O(\pending_q[0]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAA8A8AAA8AAAAA8A)) 
    \pending_q[10]_i_1 
       (.I0(\pending_q[10]_i_2_n_0 ),
        .I1(\pending_q[11]_i_2_n_0 ),
        .I2(selected_addr[1]),
        .I3(\pending_q_reg[15]_i_3_n_0 ),
        .I4(epoch_bin_q_reg[0]),
        .I5(epoch_bin_q_reg[1]),
        .O(pending_d__2[10]));
  LUT3 #(
    .INIT(8'hBA)) 
    \pending_q[10]_i_2 
       (.I0(\pending_q_reg_n_0_[10] ),
        .I1(src_ack_async_OBUF[10]),
        .I2(req_sync_q[10]),
        .O(\pending_q[10]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFF7DD7)) 
    \pending_q[11]_i_1 
       (.I0(selected_addr[1]),
        .I1(epoch_bin_q_reg[1]),
        .I2(epoch_bin_q_reg[0]),
        .I3(\pending_q_reg[15]_i_3_n_0 ),
        .I4(\pending_q[11]_i_2_n_0 ),
        .I5(\pending_q[11]_i_3_n_0 ),
        .O(pending_d__2[11]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'hFFFFFFF2)) 
    \pending_q[11]_i_2 
       (.I0(out_valid_OBUF_inst_i_2_n_0),
        .I1(out_valid_OBUF_inst_i_3_n_0),
        .I2(hold_valid_q),
        .I3(selected_addr[2]),
        .I4(\out_addr_OBUF[3]_inst_i_2_n_0 ),
        .O(\pending_q[11]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'h45)) 
    \pending_q[11]_i_3 
       (.I0(\pending_q_reg_n_0_[11] ),
        .I1(src_ack_async_OBUF[11]),
        .I2(req_sync_q[11]),
        .O(\pending_q[11]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hA88A8AA8AAAAAAAA)) 
    \pending_q[12]_i_1 
       (.I0(\pending_q[12]_i_2_n_0 ),
        .I1(selected_addr[1]),
        .I2(\pending_q_reg[15]_i_3_n_0 ),
        .I3(epoch_bin_q_reg[0]),
        .I4(epoch_bin_q_reg[1]),
        .I5(\pending_q[15]_i_2_n_0 ),
        .O(pending_d__2[12]));
  LUT3 #(
    .INIT(8'hBA)) 
    \pending_q[12]_i_2 
       (.I0(\pending_q_reg_n_0_[12] ),
        .I1(src_ack_async_OBUF[12]),
        .I2(req_sync_q[12]),
        .O(\pending_q[12]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h8AA8A88AAAAAAAAA)) 
    \pending_q[13]_i_1 
       (.I0(\pending_q[13]_i_2_n_0 ),
        .I1(selected_addr[1]),
        .I2(epoch_bin_q_reg[1]),
        .I3(epoch_bin_q_reg[0]),
        .I4(\pending_q_reg[15]_i_3_n_0 ),
        .I5(\pending_q[15]_i_2_n_0 ),
        .O(pending_d__2[13]));
  LUT3 #(
    .INIT(8'hBA)) 
    \pending_q[13]_i_2 
       (.I0(\pending_q_reg_n_0_[13] ),
        .I1(src_ack_async_OBUF[13]),
        .I2(req_sync_q[13]),
        .O(\pending_q[13]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hA22A2AA2AAAAAAAA)) 
    \pending_q[14]_i_1 
       (.I0(\pending_q[14]_i_2_n_0 ),
        .I1(selected_addr[1]),
        .I2(\pending_q_reg[15]_i_3_n_0 ),
        .I3(epoch_bin_q_reg[0]),
        .I4(epoch_bin_q_reg[1]),
        .I5(\pending_q[15]_i_2_n_0 ),
        .O(pending_d__2[14]));
  LUT3 #(
    .INIT(8'hBA)) 
    \pending_q[14]_i_2 
       (.I0(\pending_q_reg_n_0_[14] ),
        .I1(src_ack_async_OBUF[14]),
        .I2(req_sync_q[14]),
        .O(\pending_q[14]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h000000007FF7F77F)) 
    \pending_q[15]_i_1 
       (.I0(\pending_q[15]_i_2_n_0 ),
        .I1(selected_addr[1]),
        .I2(epoch_bin_q_reg[1]),
        .I3(epoch_bin_q_reg[0]),
        .I4(\pending_q_reg[15]_i_3_n_0 ),
        .I5(\pending_q[15]_i_4_n_0 ),
        .O(pending_d__2[15]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'h000000A2)) 
    \pending_q[15]_i_2 
       (.I0(selected_addr[2]),
        .I1(out_valid_OBUF_inst_i_2_n_0),
        .I2(out_valid_OBUF_inst_i_3_n_0),
        .I3(hold_valid_q),
        .I4(\out_addr_OBUF[3]_inst_i_2_n_0 ),
        .O(\pending_q[15]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'h45)) 
    \pending_q[15]_i_4 
       (.I0(p_1_in__0),
        .I1(src_ack_async_OBUF[15]),
        .I2(req_sync_q[15]),
        .O(\pending_q[15]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hA8AAAAA8AAA8A8AA)) 
    \pending_q[1]_i_1 
       (.I0(\pending_q[1]_i_2_n_0 ),
        .I1(\pending_q[3]_i_2_n_0 ),
        .I2(selected_addr[1]),
        .I3(epoch_bin_q_reg[1]),
        .I4(epoch_bin_q_reg[0]),
        .I5(\pending_q_reg[15]_i_3_n_0 ),
        .O(pending_d__2[1]));
  LUT3 #(
    .INIT(8'hBA)) 
    \pending_q[1]_i_2 
       (.I0(p_0_in__0),
        .I1(src_ack_async_OBUF[1]),
        .I2(req_sync_q[1]),
        .O(\pending_q[1]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAA8A8AAA8AAAAA8A)) 
    \pending_q[2]_i_1 
       (.I0(\pending_q[2]_i_2_n_0 ),
        .I1(\pending_q[3]_i_2_n_0 ),
        .I2(selected_addr[1]),
        .I3(\pending_q_reg[15]_i_3_n_0 ),
        .I4(epoch_bin_q_reg[0]),
        .I5(epoch_bin_q_reg[1]),
        .O(pending_d__2[2]));
  LUT3 #(
    .INIT(8'hBA)) 
    \pending_q[2]_i_2 
       (.I0(\pending_q_reg_n_0_[2] ),
        .I1(src_ack_async_OBUF[2]),
        .I2(req_sync_q[2]),
        .O(\pending_q[2]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFF7DD7)) 
    \pending_q[3]_i_1 
       (.I0(selected_addr[1]),
        .I1(epoch_bin_q_reg[1]),
        .I2(epoch_bin_q_reg[0]),
        .I3(\pending_q_reg[15]_i_3_n_0 ),
        .I4(\pending_q[3]_i_2_n_0 ),
        .I5(\pending_q[3]_i_3_n_0 ),
        .O(pending_d__2[3]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'hFFFFF2FF)) 
    \pending_q[3]_i_2 
       (.I0(out_valid_OBUF_inst_i_2_n_0),
        .I1(out_valid_OBUF_inst_i_3_n_0),
        .I2(hold_valid_q),
        .I3(\out_addr_OBUF[3]_inst_i_2_n_0 ),
        .I4(selected_addr[2]),
        .O(\pending_q[3]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'h45)) 
    \pending_q[3]_i_3 
       (.I0(\pending_q_reg_n_0_[3] ),
        .I1(src_ack_async_OBUF[3]),
        .I2(req_sync_q[3]),
        .O(\pending_q[3]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAAA8A8AAA8AAAAA8)) 
    \pending_q[4]_i_1 
       (.I0(\pending_q[4]_i_2_n_0 ),
        .I1(\pending_q[7]_i_2_n_0 ),
        .I2(selected_addr[1]),
        .I3(\pending_q_reg[15]_i_3_n_0 ),
        .I4(epoch_bin_q_reg[0]),
        .I5(epoch_bin_q_reg[1]),
        .O(pending_d__2[4]));
  LUT3 #(
    .INIT(8'hBA)) 
    \pending_q[4]_i_2 
       (.I0(\pending_q_reg_n_0_[4] ),
        .I1(src_ack_async_OBUF[4]),
        .I2(req_sync_q[4]),
        .O(\pending_q[4]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hA8AAAAA8AAA8A8AA)) 
    \pending_q[5]_i_1 
       (.I0(\pending_q[5]_i_2_n_0 ),
        .I1(\pending_q[7]_i_2_n_0 ),
        .I2(selected_addr[1]),
        .I3(epoch_bin_q_reg[1]),
        .I4(epoch_bin_q_reg[0]),
        .I5(\pending_q_reg[15]_i_3_n_0 ),
        .O(pending_d__2[5]));
  LUT3 #(
    .INIT(8'hBA)) 
    \pending_q[5]_i_2 
       (.I0(\pending_q_reg_n_0_[5] ),
        .I1(src_ack_async_OBUF[5]),
        .I2(req_sync_q[5]),
        .O(\pending_q[5]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAA8A8AAA8AAAAA8A)) 
    \pending_q[6]_i_1 
       (.I0(\pending_q[6]_i_2_n_0 ),
        .I1(\pending_q[7]_i_2_n_0 ),
        .I2(selected_addr[1]),
        .I3(\pending_q_reg[15]_i_3_n_0 ),
        .I4(epoch_bin_q_reg[0]),
        .I5(epoch_bin_q_reg[1]),
        .O(pending_d__2[6]));
  LUT3 #(
    .INIT(8'hBA)) 
    \pending_q[6]_i_2 
       (.I0(\pending_q_reg_n_0_[6] ),
        .I1(src_ack_async_OBUF[6]),
        .I2(req_sync_q[6]),
        .O(\pending_q[6]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFF7DD7)) 
    \pending_q[7]_i_1 
       (.I0(selected_addr[1]),
        .I1(epoch_bin_q_reg[1]),
        .I2(epoch_bin_q_reg[0]),
        .I3(\pending_q_reg[15]_i_3_n_0 ),
        .I4(\pending_q[7]_i_2_n_0 ),
        .I5(\pending_q[7]_i_3_n_0 ),
        .O(pending_d__2[7]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'hFF5DFFFF)) 
    \pending_q[7]_i_2 
       (.I0(selected_addr[2]),
        .I1(out_valid_OBUF_inst_i_2_n_0),
        .I2(out_valid_OBUF_inst_i_3_n_0),
        .I3(hold_valid_q),
        .I4(\out_addr_OBUF[3]_inst_i_2_n_0 ),
        .O(\pending_q[7]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'h45)) 
    \pending_q[7]_i_3 
       (.I0(\pending_q_reg_n_0_[7] ),
        .I1(src_ack_async_OBUF[7]),
        .I2(req_sync_q[7]),
        .O(\pending_q[7]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAAA8A8AAA8AAAAA8)) 
    \pending_q[8]_i_1 
       (.I0(\pending_q[8]_i_2_n_0 ),
        .I1(\pending_q[11]_i_2_n_0 ),
        .I2(selected_addr[1]),
        .I3(\pending_q_reg[15]_i_3_n_0 ),
        .I4(epoch_bin_q_reg[0]),
        .I5(epoch_bin_q_reg[1]),
        .O(pending_d__2[8]));
  LUT3 #(
    .INIT(8'hBA)) 
    \pending_q[8]_i_2 
       (.I0(\pending_q_reg_n_0_[8] ),
        .I1(src_ack_async_OBUF[8]),
        .I2(req_sync_q[8]),
        .O(\pending_q[8]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hA8AAAAA8AAA8A8AA)) 
    \pending_q[9]_i_1 
       (.I0(\pending_q[9]_i_2_n_0 ),
        .I1(\pending_q[11]_i_2_n_0 ),
        .I2(selected_addr[1]),
        .I3(epoch_bin_q_reg[1]),
        .I4(epoch_bin_q_reg[0]),
        .I5(\pending_q_reg[15]_i_3_n_0 ),
        .O(pending_d__2[9]));
  LUT3 #(
    .INIT(8'hBA)) 
    \pending_q[9]_i_2 
       (.I0(\pending_q_reg_n_0_[9] ),
        .I1(src_ack_async_OBUF[9]),
        .I2(req_sync_q[9]),
        .O(\pending_q[9]_i_2_n_0 ));
  FDCE \pending_q_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(pending_d__2[0]),
        .Q(pending_q));
  FDCE \pending_q_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(pending_d__2[10]),
        .Q(\pending_q_reg_n_0_[10] ));
  FDCE \pending_q_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(pending_d__2[11]),
        .Q(\pending_q_reg_n_0_[11] ));
  FDCE \pending_q_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(pending_d__2[12]),
        .Q(\pending_q_reg_n_0_[12] ));
  FDCE \pending_q_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(pending_d__2[13]),
        .Q(\pending_q_reg_n_0_[13] ));
  FDCE \pending_q_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(pending_d__2[14]),
        .Q(\pending_q_reg_n_0_[14] ));
  FDCE \pending_q_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(pending_d__2[15]),
        .Q(p_1_in__0));
  MUXF8 \pending_q_reg[15]_i_3 
       (.I0(\out_addr_OBUF[0]_inst_i_2_n_0 ),
        .I1(\out_addr_OBUF[0]_inst_i_3_n_0 ),
        .O(\pending_q_reg[15]_i_3_n_0 ),
        .S(\out_addr_OBUF[3]_inst_i_2_n_0 ));
  FDCE \pending_q_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(pending_d__2[1]),
        .Q(p_0_in__0));
  FDCE \pending_q_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(pending_d__2[2]),
        .Q(\pending_q_reg_n_0_[2] ));
  FDCE \pending_q_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(pending_d__2[3]),
        .Q(\pending_q_reg_n_0_[3] ));
  FDCE \pending_q_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(pending_d__2[4]),
        .Q(\pending_q_reg_n_0_[4] ));
  FDCE \pending_q_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(pending_d__2[5]),
        .Q(\pending_q_reg_n_0_[5] ));
  FDCE \pending_q_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(pending_d__2[6]),
        .Q(\pending_q_reg_n_0_[6] ));
  FDCE \pending_q_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(pending_d__2[7]),
        .Q(\pending_q_reg_n_0_[7] ));
  FDCE \pending_q_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(pending_d__2[8]),
        .Q(\pending_q_reg_n_0_[8] ));
  FDCE \pending_q_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(pending_d__2[9]),
        .Q(\pending_q_reg_n_0_[9] ));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(src_req_async_IBUF[0]),
        .Q(req_meta_q[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(src_req_async_IBUF[10]),
        .Q(req_meta_q[10]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(src_req_async_IBUF[11]),
        .Q(req_meta_q[11]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(src_req_async_IBUF[12]),
        .Q(req_meta_q[12]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(src_req_async_IBUF[13]),
        .Q(req_meta_q[13]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(src_req_async_IBUF[14]),
        .Q(req_meta_q[14]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(src_req_async_IBUF[15]),
        .Q(req_meta_q[15]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(src_req_async_IBUF[1]),
        .Q(req_meta_q[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(src_req_async_IBUF[2]),
        .Q(req_meta_q[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(src_req_async_IBUF[3]),
        .Q(req_meta_q[3]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(src_req_async_IBUF[4]),
        .Q(req_meta_q[4]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(src_req_async_IBUF[5]),
        .Q(req_meta_q[5]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(src_req_async_IBUF[6]),
        .Q(req_meta_q[6]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(src_req_async_IBUF[7]),
        .Q(req_meta_q[7]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(src_req_async_IBUF[8]),
        .Q(req_meta_q[8]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_meta_q_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(src_req_async_IBUF[9]),
        .Q(req_meta_q[9]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(req_meta_q[0]),
        .Q(req_sync_q[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(req_meta_q[10]),
        .Q(req_sync_q[10]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(req_meta_q[11]),
        .Q(req_sync_q[11]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(req_meta_q[12]),
        .Q(req_sync_q[12]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(req_meta_q[13]),
        .Q(req_sync_q[13]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(req_meta_q[14]),
        .Q(req_sync_q[14]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(req_meta_q[15]),
        .Q(req_sync_q[15]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(req_meta_q[1]),
        .Q(req_sync_q[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(req_meta_q[2]),
        .Q(req_sync_q[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(req_meta_q[3]),
        .Q(req_sync_q[3]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(req_meta_q[4]),
        .Q(req_sync_q[4]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(req_meta_q[5]),
        .Q(req_sync_q[5]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(req_meta_q[6]),
        .Q(req_sync_q[6]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(req_meta_q[7]),
        .Q(req_sync_q[7]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
        .D(req_meta_q[8]),
        .Q(req_sync_q[8]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \req_sync_q_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\ack_q[15]_i_2_n_0 ),
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
