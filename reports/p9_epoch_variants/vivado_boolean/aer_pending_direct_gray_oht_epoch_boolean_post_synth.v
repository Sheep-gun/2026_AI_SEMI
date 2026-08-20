// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Fri Aug 21 04:32:00 2026
// Host        : <LOCAL_HOST> running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               reports/p9_epoch_variants/vivado_boolean/aer_pending_direct_gray_oht_epoch_boolean_post_synth.v
// Design      : aer_pending_direct_gray_oht_epoch_boolean
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* NETLIST_CHECKSUM = "32c7f18b" *) 
(* NotValidForBitStream *)
module aer_pending_direct_gray_oht_epoch_boolean
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

  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire [3:0]out_addr;
  wire [3:0]out_addr_OBUF;
  wire out_ready;
  wire out_ready_IBUF;
  wire out_valid;
  wire out_valid_OBUF;
  wire rst_n;
  wire rst_n_IBUF;
  wire [15:0]src_ack_async;
  wire [15:0]src_ack_async_OBUF;
  wire [15:0]src_req_async;
  wire [15:0]src_req_async_IBUF;

  BUFG clk_IBUF_BUFG_inst
       (.I(clk_IBUF),
        .O(clk_IBUF_BUFG));
  IBUF clk_IBUF_inst
       (.I(clk),
        .O(clk_IBUF));
  aer_pending_direct_gray_oht_epoch_core core
       (.CLK(clk_IBUF_BUFG),
        .Q(out_addr_OBUF),
        .out_ready_IBUF(out_ready_IBUF),
        .out_valid_OBUF(out_valid_OBUF),
        .rst_n_IBUF(rst_n_IBUF),
        .src_ack_async_OBUF(src_ack_async_OBUF),
        .src_req_async(src_req_async_IBUF));
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
  IBUF out_ready_IBUF_inst
       (.I(out_ready),
        .O(out_ready_IBUF));
  OBUF out_valid_OBUF_inst
       (.I(out_valid_OBUF),
        .O(out_valid));
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

module aer_pending_direct_gray_oht_epoch_core
   (Q,
    out_valid_OBUF,
    src_ack_async_OBUF,
    out_ready_IBUF,
    src_req_async,
    CLK,
    rst_n_IBUF);
  output [3:0]Q;
  output out_valid_OBUF;
  output [15:0]src_ack_async_OBUF;
  input out_ready_IBUF;
  input [15:0]src_req_async;
  input CLK;
  input rst_n_IBUF;

  wire CLK;
  wire [3:0]Q;
  wire [15:0]ack_d;
  wire [15:0]ack_q;
  wire \epoch_gray_q[0]_i_1_n_0 ;
  wire \epoch_gray_q[1]_i_1_n_0 ;
  wire \epoch_gray_q[2]_i_1_n_0 ;
  wire \epoch_gray_q[3]_i_1_n_0 ;
  wire \epoch_gray_q[3]_i_2_n_0 ;
  wire \epoch_gray_q_reg_n_0_[0] ;
  wire out_addr_d;
  wire \out_addr_q[0]_i_10_n_0 ;
  wire \out_addr_q[0]_i_11_n_0 ;
  wire \out_addr_q[0]_i_12_n_0 ;
  wire \out_addr_q[0]_i_13_n_0 ;
  wire \out_addr_q[0]_i_14_n_0 ;
  wire \out_addr_q[0]_i_15_n_0 ;
  wire \out_addr_q[0]_i_16_n_0 ;
  wire \out_addr_q[0]_i_17_n_0 ;
  wire \out_addr_q[0]_i_18_n_0 ;
  wire \out_addr_q[0]_i_19_n_0 ;
  wire \out_addr_q[0]_i_1_n_0 ;
  wire \out_addr_q[0]_i_20_n_0 ;
  wire \out_addr_q[0]_i_21_n_0 ;
  wire \out_addr_q[0]_i_22_n_0 ;
  wire \out_addr_q[0]_i_23_n_0 ;
  wire \out_addr_q[0]_i_2_n_0 ;
  wire \out_addr_q[0]_i_3_n_0 ;
  wire \out_addr_q[0]_i_4_n_0 ;
  wire \out_addr_q[0]_i_5_n_0 ;
  wire \out_addr_q[0]_i_6_n_0 ;
  wire \out_addr_q[0]_i_7_n_0 ;
  wire \out_addr_q[0]_i_8_n_0 ;
  wire \out_addr_q[0]_i_9_n_0 ;
  wire \out_addr_q[2]_i_2_n_0 ;
  wire \out_addr_q[2]_i_3_n_0 ;
  wire \out_addr_q[2]_i_4_n_0 ;
  wire \out_addr_q[2]_i_5_n_0 ;
  wire \out_addr_q[3]_i_3_n_0 ;
  wire \out_addr_q[3]_i_4_n_0 ;
  wire \out_addr_q[3]_i_5_n_0 ;
  wire \out_addr_q[3]_i_6_n_0 ;
  wire out_ready_IBUF;
  wire out_valid_OBUF;
  wire out_valid_q;
  wire out_valid_q_i_1_n_0;
  wire p_0_in;
  wire p_1_in;
  wire p_2_in;
  wire p_6_in;
  wire [15:0]pending_d;
  wire [15:0]pending_q;
  wire \pending_q[11]_i_2_n_0 ;
  wire \pending_q[11]_i_3_n_0 ;
  wire \pending_q[11]_i_4_n_0 ;
  wire \pending_q[13]_i_2_n_0 ;
  wire \pending_q[13]_i_3_n_0 ;
  wire \pending_q[13]_i_4_n_0 ;
  wire \pending_q[15]_i_2_n_0 ;
  wire \pending_q[15]_i_3_n_0 ;
  wire \pending_q[15]_i_4_n_0 ;
  wire \pending_q[15]_i_5_n_0 ;
  wire \pending_q[15]_i_6_n_0 ;
  wire \pending_q[15]_i_7_n_0 ;
  wire \pending_q[1]_i_2_n_0 ;
  wire \pending_q[1]_i_3_n_0 ;
  wire \pending_q[1]_i_4_n_0 ;
  wire \pending_q[3]_i_2_n_0 ;
  wire \pending_q[3]_i_3_n_0 ;
  wire \pending_q[3]_i_4_n_0 ;
  wire \pending_q[5]_i_2_n_0 ;
  wire \pending_q[5]_i_3_n_0 ;
  wire \pending_q[5]_i_4_n_0 ;
  wire \pending_q[5]_i_5_n_0 ;
  wire \pending_q[5]_i_6_n_0 ;
  wire \pending_q[7]_i_2_n_0 ;
  wire \pending_q[7]_i_3_n_0 ;
  wire \pending_q[7]_i_4_n_0 ;
  wire \pending_q[7]_i_5_n_0 ;
  wire \pending_q[7]_i_6_n_0 ;
  wire \pending_q[7]_i_7_n_0 ;
  wire \pending_q[7]_i_8_n_0 ;
  wire \pending_q[9]_i_2_n_0 ;
  wire \pending_q[9]_i_3_n_0 ;
  wire \pending_q[9]_i_4_n_0 ;
  (* async_reg = "true" *) wire [15:0]req_meta_q;
  (* async_reg = "true" *) wire [15:0]req_sync_q;
  (* async_reg = "true" *) wire [1:0]reset_release_q;
  wire \reset_release_q[1]_i_1_n_0 ;
  wire rst_n_IBUF;
  wire [2:1]selected_addr;
  wire [15:0]src_ack_async_OBUF;
  wire [15:0]src_req_async;

  LUT3 #(
    .INIT(8'h8A)) 
    \ack_q[0]_i_1 
       (.I0(req_sync_q[0]),
        .I1(ack_q[0]),
        .I2(pending_q[0]),
        .O(ack_d[0]));
  LUT3 #(
    .INIT(8'h8A)) 
    \ack_q[10]_i_1 
       (.I0(req_sync_q[10]),
        .I1(ack_q[10]),
        .I2(pending_q[10]),
        .O(ack_d[10]));
  LUT3 #(
    .INIT(8'h8A)) 
    \ack_q[11]_i_1 
       (.I0(req_sync_q[11]),
        .I1(ack_q[11]),
        .I2(pending_q[11]),
        .O(ack_d[11]));
  LUT3 #(
    .INIT(8'h8A)) 
    \ack_q[12]_i_1 
       (.I0(req_sync_q[12]),
        .I1(ack_q[12]),
        .I2(pending_q[12]),
        .O(ack_d[12]));
  LUT3 #(
    .INIT(8'h8A)) 
    \ack_q[13]_i_1 
       (.I0(req_sync_q[13]),
        .I1(ack_q[13]),
        .I2(pending_q[13]),
        .O(ack_d[13]));
  LUT3 #(
    .INIT(8'h8A)) 
    \ack_q[14]_i_1 
       (.I0(req_sync_q[14]),
        .I1(ack_q[14]),
        .I2(pending_q[14]),
        .O(ack_d[14]));
  LUT3 #(
    .INIT(8'h8A)) 
    \ack_q[15]_i_1 
       (.I0(req_sync_q[15]),
        .I1(ack_q[15]),
        .I2(pending_q[15]),
        .O(ack_d[15]));
  LUT3 #(
    .INIT(8'h8A)) 
    \ack_q[1]_i_1 
       (.I0(req_sync_q[1]),
        .I1(ack_q[1]),
        .I2(pending_q[1]),
        .O(ack_d[1]));
  LUT3 #(
    .INIT(8'h8A)) 
    \ack_q[2]_i_1 
       (.I0(req_sync_q[2]),
        .I1(ack_q[2]),
        .I2(pending_q[2]),
        .O(ack_d[2]));
  LUT3 #(
    .INIT(8'h8A)) 
    \ack_q[3]_i_1 
       (.I0(req_sync_q[3]),
        .I1(ack_q[3]),
        .I2(pending_q[3]),
        .O(ack_d[3]));
  LUT3 #(
    .INIT(8'h8A)) 
    \ack_q[4]_i_1 
       (.I0(req_sync_q[4]),
        .I1(ack_q[4]),
        .I2(pending_q[4]),
        .O(ack_d[4]));
  LUT3 #(
    .INIT(8'h8A)) 
    \ack_q[5]_i_1 
       (.I0(req_sync_q[5]),
        .I1(ack_q[5]),
        .I2(pending_q[5]),
        .O(ack_d[5]));
  LUT3 #(
    .INIT(8'h8A)) 
    \ack_q[6]_i_1 
       (.I0(req_sync_q[6]),
        .I1(ack_q[6]),
        .I2(pending_q[6]),
        .O(ack_d[6]));
  LUT3 #(
    .INIT(8'h8A)) 
    \ack_q[7]_i_1 
       (.I0(req_sync_q[7]),
        .I1(ack_q[7]),
        .I2(pending_q[7]),
        .O(ack_d[7]));
  LUT3 #(
    .INIT(8'h8A)) 
    \ack_q[8]_i_1 
       (.I0(req_sync_q[8]),
        .I1(ack_q[8]),
        .I2(pending_q[8]),
        .O(ack_d[8]));
  LUT3 #(
    .INIT(8'h8A)) 
    \ack_q[9]_i_1 
       (.I0(req_sync_q[9]),
        .I1(ack_q[9]),
        .I2(pending_q[9]),
        .O(ack_d[9]));
  FDRE \ack_q_reg[0] 
       (.C(CLK),
        .CE(1'b1),
        .D(ack_d[0]),
        .Q(ack_q[0]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \ack_q_reg[10] 
       (.C(CLK),
        .CE(1'b1),
        .D(ack_d[10]),
        .Q(ack_q[10]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \ack_q_reg[11] 
       (.C(CLK),
        .CE(1'b1),
        .D(ack_d[11]),
        .Q(ack_q[11]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \ack_q_reg[12] 
       (.C(CLK),
        .CE(1'b1),
        .D(ack_d[12]),
        .Q(ack_q[12]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \ack_q_reg[13] 
       (.C(CLK),
        .CE(1'b1),
        .D(ack_d[13]),
        .Q(ack_q[13]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \ack_q_reg[14] 
       (.C(CLK),
        .CE(1'b1),
        .D(ack_d[14]),
        .Q(ack_q[14]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \ack_q_reg[15] 
       (.C(CLK),
        .CE(1'b1),
        .D(ack_d[15]),
        .Q(ack_q[15]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \ack_q_reg[1] 
       (.C(CLK),
        .CE(1'b1),
        .D(ack_d[1]),
        .Q(ack_q[1]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \ack_q_reg[2] 
       (.C(CLK),
        .CE(1'b1),
        .D(ack_d[2]),
        .Q(ack_q[2]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \ack_q_reg[3] 
       (.C(CLK),
        .CE(1'b1),
        .D(ack_d[3]),
        .Q(ack_q[3]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \ack_q_reg[4] 
       (.C(CLK),
        .CE(1'b1),
        .D(ack_d[4]),
        .Q(ack_q[4]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \ack_q_reg[5] 
       (.C(CLK),
        .CE(1'b1),
        .D(ack_d[5]),
        .Q(ack_q[5]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \ack_q_reg[6] 
       (.C(CLK),
        .CE(1'b1),
        .D(ack_d[6]),
        .Q(ack_q[6]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \ack_q_reg[7] 
       (.C(CLK),
        .CE(1'b1),
        .D(ack_d[7]),
        .Q(ack_q[7]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \ack_q_reg[8] 
       (.C(CLK),
        .CE(1'b1),
        .D(ack_d[8]),
        .Q(ack_q[8]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \ack_q_reg[9] 
       (.C(CLK),
        .CE(1'b1),
        .D(ack_d[9]),
        .Q(ack_q[9]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  (* OPT_MODIFIED = "RETARGET" *) 
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'h69FF6900)) 
    \epoch_gray_q[0]_i_1 
       (.I0(p_0_in),
        .I1(p_2_in),
        .I2(p_1_in),
        .I3(out_addr_d),
        .I4(\epoch_gray_q_reg_n_0_[0] ),
        .O(\epoch_gray_q[0]_i_1_n_0 ));
  (* OPT_MODIFIED = "RETARGET" *) 
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'h9FFF9000)) 
    \epoch_gray_q[1]_i_1 
       (.I0(p_2_in),
        .I1(p_1_in),
        .I2(\epoch_gray_q_reg_n_0_[0] ),
        .I3(out_addr_d),
        .I4(p_0_in),
        .O(\epoch_gray_q[1]_i_1_n_0 ));
  (* OPT_MODIFIED = "RETARGET" *) 
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'hFF7F0040)) 
    \epoch_gray_q[2]_i_1 
       (.I0(p_1_in),
        .I1(p_0_in),
        .I2(out_addr_d),
        .I3(\epoch_gray_q_reg_n_0_[0] ),
        .I4(p_2_in),
        .O(\epoch_gray_q[2]_i_1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \epoch_gray_q[3]_i_1 
       (.I0(reset_release_q[1]),
        .O(\epoch_gray_q[3]_i_1_n_0 ));
  (* OPT_MODIFIED = "RETARGET" *) 
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'hFFEF0020)) 
    \epoch_gray_q[3]_i_2 
       (.I0(p_2_in),
        .I1(p_0_in),
        .I2(out_addr_d),
        .I3(\epoch_gray_q_reg_n_0_[0] ),
        .I4(p_1_in),
        .O(\epoch_gray_q[3]_i_2_n_0 ));
  (* OPT_MODIFIED = "RETARGET" *) 
  LUT6 #(
    .INIT(64'h0BBBBBBBBBBBBBBB)) 
    \epoch_gray_q[3]_i_3 
       (.I0(out_ready_IBUF),
        .I1(out_valid_q),
        .I2(\out_addr_q[3]_i_4_n_0 ),
        .I3(\out_addr_q[3]_i_5_n_0 ),
        .I4(\out_addr_q[3]_i_6_n_0 ),
        .I5(\out_addr_q[3]_i_3_n_0 ),
        .O(out_addr_d));
  (* FSM_ENCODING = "none" *) 
  FDRE \epoch_gray_q_reg[0] 
       (.C(CLK),
        .CE(1'b1),
        .D(\epoch_gray_q[0]_i_1_n_0 ),
        .Q(\epoch_gray_q_reg_n_0_[0] ),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  (* FSM_ENCODING = "none" *) 
  FDRE \epoch_gray_q_reg[1] 
       (.C(CLK),
        .CE(1'b1),
        .D(\epoch_gray_q[1]_i_1_n_0 ),
        .Q(p_0_in),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  (* FSM_ENCODING = "none" *) 
  FDRE \epoch_gray_q_reg[2] 
       (.C(CLK),
        .CE(1'b1),
        .D(\epoch_gray_q[2]_i_1_n_0 ),
        .Q(p_2_in),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  (* FSM_ENCODING = "none" *) 
  FDRE \epoch_gray_q_reg[3] 
       (.C(CLK),
        .CE(1'b1),
        .D(\epoch_gray_q[3]_i_2_n_0 ),
        .Q(p_1_in),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \out_addr_q[0]_i_1 
       (.I0(\out_addr_q[0]_i_2_n_0 ),
        .I1(\out_addr_q[0]_i_3_n_0 ),
        .I2(\out_addr_q[0]_i_4_n_0 ),
        .I3(\out_addr_q[0]_i_5_n_0 ),
        .I4(\out_addr_q[0]_i_6_n_0 ),
        .I5(\out_addr_q[0]_i_7_n_0 ),
        .O(\out_addr_q[0]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hBABBBABA)) 
    \out_addr_q[0]_i_10 
       (.I0(\pending_q[1]_i_4_n_0 ),
        .I1(\epoch_gray_q_reg_n_0_[0] ),
        .I2(pending_q[0]),
        .I3(ack_q[0]),
        .I4(req_sync_q[0]),
        .O(\out_addr_q[0]_i_10_n_0 ));
  LUT5 #(
    .INIT(32'hFF8F8888)) 
    \out_addr_q[0]_i_11 
       (.I0(\out_addr_q[3]_i_5_n_0 ),
        .I1(\out_addr_q[3]_i_6_n_0 ),
        .I2(\pending_q[7]_i_7_n_0 ),
        .I3(\pending_q[7]_i_8_n_0 ),
        .I4(p_2_in),
        .O(\out_addr_q[0]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'h4500FFFF45004500)) 
    \out_addr_q[0]_i_12 
       (.I0(pending_q[0]),
        .I1(ack_q[0]),
        .I2(req_sync_q[0]),
        .I3(\pending_q[1]_i_4_n_0 ),
        .I4(\out_addr_q[3]_i_6_n_0 ),
        .I5(p_0_in),
        .O(\out_addr_q[0]_i_12_n_0 ));
  LUT5 #(
    .INIT(32'hBABBBABA)) 
    \out_addr_q[0]_i_13 
       (.I0(\pending_q[11]_i_4_n_0 ),
        .I1(\epoch_gray_q_reg_n_0_[0] ),
        .I2(pending_q[10]),
        .I3(ack_q[10]),
        .I4(req_sync_q[10]),
        .O(\out_addr_q[0]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'h450045004500FFFF)) 
    \out_addr_q[0]_i_14 
       (.I0(pending_q[10]),
        .I1(ack_q[10]),
        .I2(req_sync_q[10]),
        .I3(\pending_q[11]_i_4_n_0 ),
        .I4(\out_addr_q[2]_i_5_n_0 ),
        .I5(p_0_in),
        .O(\out_addr_q[0]_i_14_n_0 ));
  LUT5 #(
    .INIT(32'hBABBBABA)) 
    \out_addr_q[0]_i_15 
       (.I0(\pending_q[9]_i_4_n_0 ),
        .I1(\epoch_gray_q_reg_n_0_[0] ),
        .I2(pending_q[8]),
        .I3(ack_q[8]),
        .I4(req_sync_q[8]),
        .O(\out_addr_q[0]_i_15_n_0 ));
  LUT5 #(
    .INIT(32'h00707777)) 
    \out_addr_q[0]_i_16 
       (.I0(\out_addr_q[2]_i_5_n_0 ),
        .I1(\out_addr_q[2]_i_4_n_0 ),
        .I2(\pending_q[15]_i_7_n_0 ),
        .I3(\pending_q[15]_i_6_n_0 ),
        .I4(p_2_in),
        .O(\out_addr_q[0]_i_16_n_0 ));
  LUT6 #(
    .INIT(64'h4500FFFF45004500)) 
    \out_addr_q[0]_i_17 
       (.I0(pending_q[8]),
        .I1(ack_q[8]),
        .I2(req_sync_q[8]),
        .I3(\pending_q[9]_i_4_n_0 ),
        .I4(\out_addr_q[2]_i_4_n_0 ),
        .I5(p_0_in),
        .O(\out_addr_q[0]_i_17_n_0 ));
  LUT6 #(
    .INIT(64'hDDDDDDDD5D5DDD5D)) 
    \out_addr_q[0]_i_18 
       (.I0(\pending_q[15]_i_6_n_0 ),
        .I1(p_0_in),
        .I2(\pending_q[15]_i_4_n_0 ),
        .I3(req_sync_q[14]),
        .I4(ack_q[14]),
        .I5(pending_q[14]),
        .O(\out_addr_q[0]_i_18_n_0 ));
  LUT5 #(
    .INIT(32'h4544FFFF)) 
    \out_addr_q[0]_i_19 
       (.I0(\epoch_gray_q_reg_n_0_[0] ),
        .I1(pending_q[12]),
        .I2(ack_q[12]),
        .I3(req_sync_q[12]),
        .I4(\pending_q[13]_i_3_n_0 ),
        .O(\out_addr_q[0]_i_19_n_0 ));
  LUT6 #(
    .INIT(64'h00110000001F0000)) 
    \out_addr_q[0]_i_2 
       (.I0(\out_addr_q[0]_i_8_n_0 ),
        .I1(\out_addr_q[0]_i_9_n_0 ),
        .I2(\out_addr_q[0]_i_10_n_0 ),
        .I3(\out_addr_q[0]_i_11_n_0 ),
        .I4(\pending_q[7]_i_6_n_0 ),
        .I5(\out_addr_q[0]_i_12_n_0 ),
        .O(\out_addr_q[0]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h5555DFDD)) 
    \out_addr_q[0]_i_20 
       (.I0(\pending_q[5]_i_6_n_0 ),
        .I1(pending_q[4]),
        .I2(ack_q[4]),
        .I3(req_sync_q[4]),
        .I4(\epoch_gray_q_reg_n_0_[0] ),
        .O(\out_addr_q[0]_i_20_n_0 ));
  LUT6 #(
    .INIT(64'h4500FFFF45004500)) 
    \out_addr_q[0]_i_21 
       (.I0(pending_q[14]),
        .I1(ack_q[14]),
        .I2(req_sync_q[14]),
        .I3(\pending_q[15]_i_4_n_0 ),
        .I4(p_0_in),
        .I5(\pending_q[15]_i_6_n_0 ),
        .O(\out_addr_q[0]_i_21_n_0 ));
  LUT5 #(
    .INIT(32'hBABBBABA)) 
    \out_addr_q[0]_i_22 
       (.I0(\pending_q[15]_i_4_n_0 ),
        .I1(\epoch_gray_q_reg_n_0_[0] ),
        .I2(pending_q[14]),
        .I3(ack_q[14]),
        .I4(req_sync_q[14]),
        .O(\out_addr_q[0]_i_22_n_0 ));
  LUT5 #(
    .INIT(32'hBABBBABA)) 
    \out_addr_q[0]_i_23 
       (.I0(\pending_q[7]_i_4_n_0 ),
        .I1(\epoch_gray_q_reg_n_0_[0] ),
        .I2(pending_q[6]),
        .I3(ack_q[6]),
        .I4(req_sync_q[6]),
        .O(\out_addr_q[0]_i_23_n_0 ));
  LUT6 #(
    .INIT(64'h00110000001F0000)) 
    \out_addr_q[0]_i_3 
       (.I0(\out_addr_q[0]_i_13_n_0 ),
        .I1(\out_addr_q[0]_i_14_n_0 ),
        .I2(\out_addr_q[0]_i_15_n_0 ),
        .I3(\out_addr_q[2]_i_2_n_0 ),
        .I4(\out_addr_q[0]_i_16_n_0 ),
        .I5(\out_addr_q[0]_i_17_n_0 ),
        .O(\out_addr_q[0]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000100011)) 
    \out_addr_q[0]_i_4 
       (.I0(\out_addr_q[0]_i_18_n_0 ),
        .I1(\out_addr_q[2]_i_2_n_0 ),
        .I2(p_2_in),
        .I3(\out_addr_q[2]_i_3_n_0 ),
        .I4(\pending_q[15]_i_5_n_0 ),
        .I5(\out_addr_q[0]_i_19_n_0 ),
        .O(\out_addr_q[0]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h00000000B0000000)) 
    \out_addr_q[0]_i_5 
       (.I0(\pending_q[7]_i_7_n_0 ),
        .I1(p_0_in),
        .I2(\pending_q[7]_i_8_n_0 ),
        .I3(\pending_q[7]_i_6_n_0 ),
        .I4(\out_addr_q[0]_i_11_n_0 ),
        .I5(\out_addr_q[0]_i_20_n_0 ),
        .O(\out_addr_q[0]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000100011)) 
    \out_addr_q[0]_i_6 
       (.I0(\out_addr_q[0]_i_21_n_0 ),
        .I1(\out_addr_q[2]_i_2_n_0 ),
        .I2(p_2_in),
        .I3(\out_addr_q[2]_i_3_n_0 ),
        .I4(\pending_q[15]_i_5_n_0 ),
        .I5(\out_addr_q[0]_i_22_n_0 ),
        .O(\out_addr_q[0]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h000000000D000000)) 
    \out_addr_q[0]_i_7 
       (.I0(\pending_q[7]_i_8_n_0 ),
        .I1(p_0_in),
        .I2(\pending_q[7]_i_7_n_0 ),
        .I3(\pending_q[7]_i_6_n_0 ),
        .I4(\out_addr_q[0]_i_11_n_0 ),
        .I5(\out_addr_q[0]_i_23_n_0 ),
        .O(\out_addr_q[0]_i_7_n_0 ));
  LUT5 #(
    .INIT(32'hBABBBABA)) 
    \out_addr_q[0]_i_8 
       (.I0(\pending_q[3]_i_4_n_0 ),
        .I1(\epoch_gray_q_reg_n_0_[0] ),
        .I2(pending_q[2]),
        .I3(ack_q[2]),
        .I4(req_sync_q[2]),
        .O(\out_addr_q[0]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'h450045004500FFFF)) 
    \out_addr_q[0]_i_9 
       (.I0(pending_q[2]),
        .I1(ack_q[2]),
        .I2(req_sync_q[2]),
        .I3(\pending_q[3]_i_4_n_0 ),
        .I4(\out_addr_q[3]_i_5_n_0 ),
        .I5(p_0_in),
        .O(\out_addr_q[0]_i_9_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \out_addr_q[1]_i_1 
       (.I0(\pending_q[15]_i_2_n_0 ),
        .I1(\pending_q[11]_i_2_n_0 ),
        .I2(\pending_q[3]_i_2_n_0 ),
        .I3(\pending_q[7]_i_2_n_0 ),
        .O(selected_addr[1]));
  LUT6 #(
    .INIT(64'hFFFFFFFF05040404)) 
    \out_addr_q[2]_i_1 
       (.I0(\out_addr_q[2]_i_2_n_0 ),
        .I1(p_2_in),
        .I2(\out_addr_q[2]_i_3_n_0 ),
        .I3(\out_addr_q[2]_i_4_n_0 ),
        .I4(\out_addr_q[2]_i_5_n_0 ),
        .I5(\pending_q[5]_i_4_n_0 ),
        .O(selected_addr[2]));
  LUT5 #(
    .INIT(32'h0000FF7F)) 
    \out_addr_q[2]_i_2 
       (.I0(\out_addr_q[3]_i_6_n_0 ),
        .I1(\out_addr_q[3]_i_5_n_0 ),
        .I2(\pending_q[7]_i_7_n_0 ),
        .I3(\pending_q[7]_i_8_n_0 ),
        .I4(p_1_in),
        .O(\out_addr_q[2]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h00004500)) 
    \out_addr_q[2]_i_3 
       (.I0(pending_q[14]),
        .I1(ack_q[14]),
        .I2(req_sync_q[14]),
        .I3(\pending_q[15]_i_4_n_0 ),
        .I4(\pending_q[15]_i_6_n_0 ),
        .O(\out_addr_q[2]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h000000000D0D000D)) 
    \out_addr_q[2]_i_4 
       (.I0(req_sync_q[11]),
        .I1(ack_q[11]),
        .I2(pending_q[11]),
        .I3(req_sync_q[10]),
        .I4(ack_q[10]),
        .I5(pending_q[10]),
        .O(\out_addr_q[2]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h000000000D0D000D)) 
    \out_addr_q[2]_i_5 
       (.I0(req_sync_q[9]),
        .I1(ack_q[9]),
        .I2(pending_q[9]),
        .I3(req_sync_q[8]),
        .I4(ack_q[8]),
        .I5(pending_q[8]),
        .O(\out_addr_q[2]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'h54444444)) 
    \out_addr_q[3]_i_2 
       (.I0(\out_addr_q[3]_i_3_n_0 ),
        .I1(p_1_in),
        .I2(\out_addr_q[3]_i_4_n_0 ),
        .I3(\out_addr_q[3]_i_5_n_0 ),
        .I4(\out_addr_q[3]_i_6_n_0 ),
        .O(p_6_in));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h4000)) 
    \out_addr_q[3]_i_3 
       (.I0(\pending_q[15]_i_6_n_0 ),
        .I1(\pending_q[15]_i_7_n_0 ),
        .I2(\out_addr_q[2]_i_5_n_0 ),
        .I3(\out_addr_q[2]_i_4_n_0 ),
        .O(\out_addr_q[3]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'h00002022)) 
    \out_addr_q[3]_i_4 
       (.I0(\pending_q[7]_i_7_n_0 ),
        .I1(pending_q[4]),
        .I2(ack_q[4]),
        .I3(req_sync_q[4]),
        .I4(\pending_q[5]_i_6_n_0 ),
        .O(\out_addr_q[3]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h000000000D0D000D)) 
    \out_addr_q[3]_i_5 
       (.I0(req_sync_q[1]),
        .I1(ack_q[1]),
        .I2(pending_q[1]),
        .I3(req_sync_q[0]),
        .I4(ack_q[0]),
        .I5(pending_q[0]),
        .O(\out_addr_q[3]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h000000000D0D000D)) 
    \out_addr_q[3]_i_6 
       (.I0(req_sync_q[3]),
        .I1(ack_q[3]),
        .I2(pending_q[3]),
        .I3(req_sync_q[2]),
        .I4(ack_q[2]),
        .I5(pending_q[2]),
        .O(\out_addr_q[3]_i_6_n_0 ));
  FDRE \out_addr_q_reg[0] 
       (.C(CLK),
        .CE(out_addr_d),
        .D(\out_addr_q[0]_i_1_n_0 ),
        .Q(Q[0]),
        .R(1'b0));
  FDRE \out_addr_q_reg[1] 
       (.C(CLK),
        .CE(out_addr_d),
        .D(selected_addr[1]),
        .Q(Q[1]),
        .R(1'b0));
  FDRE \out_addr_q_reg[2] 
       (.C(CLK),
        .CE(out_addr_d),
        .D(selected_addr[2]),
        .Q(Q[2]),
        .R(1'b0));
  FDRE \out_addr_q_reg[3] 
       (.C(CLK),
        .CE(out_addr_d),
        .D(p_6_in),
        .Q(Q[3]),
        .R(1'b0));
  LUT2 #(
    .INIT(4'h8)) 
    out_valid_OBUF_inst_i_1
       (.I0(out_valid_q),
        .I1(reset_release_q[1]),
        .O(out_valid_OBUF));
  LUT6 #(
    .INIT(64'h7FFF7FFFFFFF7FFF)) 
    out_valid_q_i_1
       (.I0(\out_addr_q[3]_i_3_n_0 ),
        .I1(\out_addr_q[3]_i_6_n_0 ),
        .I2(\out_addr_q[3]_i_5_n_0 ),
        .I3(\out_addr_q[3]_i_4_n_0 ),
        .I4(out_valid_q),
        .I5(out_ready_IBUF),
        .O(out_valid_q_i_1_n_0));
  FDRE out_valid_q_reg
       (.C(CLK),
        .CE(1'b1),
        .D(out_valid_q_i_1_n_0),
        .Q(out_valid_q),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h20AA2020AAAAAAAA)) 
    \pending_q[0]_i_1 
       (.I0(\pending_q[1]_i_3_n_0 ),
        .I1(out_ready_IBUF),
        .I2(out_valid_q),
        .I3(\pending_q[1]_i_4_n_0 ),
        .I4(\epoch_gray_q_reg_n_0_[0] ),
        .I5(\pending_q[1]_i_2_n_0 ),
        .O(pending_d[0]));
  LUT6 #(
    .INIT(64'h20AA2020AAAAAAAA)) 
    \pending_q[10]_i_1 
       (.I0(\pending_q[11]_i_3_n_0 ),
        .I1(out_ready_IBUF),
        .I2(out_valid_q),
        .I3(\pending_q[11]_i_4_n_0 ),
        .I4(\epoch_gray_q_reg_n_0_[0] ),
        .I5(\pending_q[11]_i_2_n_0 ),
        .O(pending_d[10]));
  LUT6 #(
    .INIT(64'h000000002F2FFF2F)) 
    \pending_q[11]_i_1 
       (.I0(out_valid_q),
        .I1(out_ready_IBUF),
        .I2(\pending_q[11]_i_2_n_0 ),
        .I3(\pending_q[11]_i_3_n_0 ),
        .I4(\epoch_gray_q_reg_n_0_[0] ),
        .I5(\pending_q[11]_i_4_n_0 ),
        .O(pending_d[11]));
  LUT6 #(
    .INIT(64'h0000000045454500)) 
    \pending_q[11]_i_2 
       (.I0(\out_addr_q[2]_i_2_n_0 ),
        .I1(\out_addr_q[2]_i_3_n_0 ),
        .I2(p_2_in),
        .I3(p_0_in),
        .I4(\out_addr_q[2]_i_5_n_0 ),
        .I5(\out_addr_q[2]_i_4_n_0 ),
        .O(\pending_q[11]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hBA)) 
    \pending_q[11]_i_3 
       (.I0(pending_q[10]),
        .I1(ack_q[10]),
        .I2(req_sync_q[10]),
        .O(\pending_q[11]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'h45)) 
    \pending_q[11]_i_4 
       (.I0(pending_q[11]),
        .I1(ack_q[11]),
        .I2(req_sync_q[11]),
        .O(\pending_q[11]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAA202020AAAAAAAA)) 
    \pending_q[12]_i_1 
       (.I0(\pending_q[13]_i_4_n_0 ),
        .I1(out_ready_IBUF),
        .I2(out_valid_q),
        .I3(\epoch_gray_q_reg_n_0_[0] ),
        .I4(\pending_q[13]_i_3_n_0 ),
        .I5(\pending_q[13]_i_2_n_0 ),
        .O(pending_d[12]));
  LUT6 #(
    .INIT(64'h2F002F00FF002F00)) 
    \pending_q[13]_i_1 
       (.I0(out_valid_q),
        .I1(out_ready_IBUF),
        .I2(\pending_q[13]_i_2_n_0 ),
        .I3(\pending_q[13]_i_3_n_0 ),
        .I4(\pending_q[13]_i_4_n_0 ),
        .I5(\epoch_gray_q_reg_n_0_[0] ),
        .O(pending_d[13]));
  LUT6 #(
    .INIT(64'h0D000D0D00000000)) 
    \pending_q[13]_i_2 
       (.I0(\pending_q[15]_i_5_n_0 ),
        .I1(p_2_in),
        .I2(\out_addr_q[2]_i_2_n_0 ),
        .I3(\pending_q[15]_i_7_n_0 ),
        .I4(p_0_in),
        .I5(\pending_q[15]_i_6_n_0 ),
        .O(\pending_q[13]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hBA)) 
    \pending_q[13]_i_3 
       (.I0(pending_q[13]),
        .I1(ack_q[13]),
        .I2(req_sync_q[13]),
        .O(\pending_q[13]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'hBA)) 
    \pending_q[13]_i_4 
       (.I0(pending_q[12]),
        .I1(ack_q[12]),
        .I2(req_sync_q[12]),
        .O(\pending_q[13]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h20AA2020AAAAAAAA)) 
    \pending_q[14]_i_1 
       (.I0(\pending_q[15]_i_3_n_0 ),
        .I1(out_ready_IBUF),
        .I2(out_valid_q),
        .I3(\pending_q[15]_i_4_n_0 ),
        .I4(\epoch_gray_q_reg_n_0_[0] ),
        .I5(\pending_q[15]_i_2_n_0 ),
        .O(pending_d[14]));
  LUT6 #(
    .INIT(64'h000000002F2FFF2F)) 
    \pending_q[15]_i_1 
       (.I0(out_valid_q),
        .I1(out_ready_IBUF),
        .I2(\pending_q[15]_i_2_n_0 ),
        .I3(\pending_q[15]_i_3_n_0 ),
        .I4(\epoch_gray_q_reg_n_0_[0] ),
        .I5(\pending_q[15]_i_4_n_0 ),
        .O(pending_d[15]));
  LUT6 #(
    .INIT(64'h000000000D0D000D)) 
    \pending_q[15]_i_2 
       (.I0(\pending_q[15]_i_5_n_0 ),
        .I1(p_2_in),
        .I2(\out_addr_q[2]_i_2_n_0 ),
        .I3(\pending_q[15]_i_6_n_0 ),
        .I4(p_0_in),
        .I5(\pending_q[15]_i_7_n_0 ),
        .O(\pending_q[15]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hBA)) 
    \pending_q[15]_i_3 
       (.I0(pending_q[14]),
        .I1(ack_q[14]),
        .I2(req_sync_q[14]),
        .O(\pending_q[15]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'h45)) 
    \pending_q[15]_i_4 
       (.I0(pending_q[15]),
        .I1(ack_q[15]),
        .I2(req_sync_q[15]),
        .O(\pending_q[15]_i_4_n_0 ));
  LUT5 #(
    .INIT(32'hBAFFFFFF)) 
    \pending_q[15]_i_5 
       (.I0(pending_q[10]),
        .I1(ack_q[10]),
        .I2(req_sync_q[10]),
        .I3(\pending_q[11]_i_4_n_0 ),
        .I4(\out_addr_q[2]_i_5_n_0 ),
        .O(\pending_q[15]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFF2F2FFF2)) 
    \pending_q[15]_i_6 
       (.I0(req_sync_q[13]),
        .I1(ack_q[13]),
        .I2(pending_q[13]),
        .I3(req_sync_q[12]),
        .I4(ack_q[12]),
        .I5(pending_q[12]),
        .O(\pending_q[15]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h000000000D0D000D)) 
    \pending_q[15]_i_7 
       (.I0(req_sync_q[15]),
        .I1(ack_q[15]),
        .I2(pending_q[15]),
        .I3(req_sync_q[14]),
        .I4(ack_q[14]),
        .I5(pending_q[14]),
        .O(\pending_q[15]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h000000002F2FFF2F)) 
    \pending_q[1]_i_1 
       (.I0(out_valid_q),
        .I1(out_ready_IBUF),
        .I2(\pending_q[1]_i_2_n_0 ),
        .I3(\pending_q[1]_i_3_n_0 ),
        .I4(\epoch_gray_q_reg_n_0_[0] ),
        .I5(\pending_q[1]_i_4_n_0 ),
        .O(pending_d[1]));
  LUT6 #(
    .INIT(64'h00000000B0B000B0)) 
    \pending_q[1]_i_2 
       (.I0(\out_addr_q[3]_i_4_n_0 ),
        .I1(p_2_in),
        .I2(\pending_q[7]_i_6_n_0 ),
        .I3(p_0_in),
        .I4(\out_addr_q[3]_i_6_n_0 ),
        .I5(\out_addr_q[3]_i_5_n_0 ),
        .O(\pending_q[1]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hBA)) 
    \pending_q[1]_i_3 
       (.I0(pending_q[0]),
        .I1(ack_q[0]),
        .I2(req_sync_q[0]),
        .O(\pending_q[1]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'h45)) 
    \pending_q[1]_i_4 
       (.I0(pending_q[1]),
        .I1(ack_q[1]),
        .I2(req_sync_q[1]),
        .O(\pending_q[1]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h20AA2020AAAAAAAA)) 
    \pending_q[2]_i_1 
       (.I0(\pending_q[3]_i_3_n_0 ),
        .I1(out_ready_IBUF),
        .I2(out_valid_q),
        .I3(\pending_q[3]_i_4_n_0 ),
        .I4(\epoch_gray_q_reg_n_0_[0] ),
        .I5(\pending_q[3]_i_2_n_0 ),
        .O(pending_d[2]));
  LUT6 #(
    .INIT(64'h000000002F2FFF2F)) 
    \pending_q[3]_i_1 
       (.I0(out_valid_q),
        .I1(out_ready_IBUF),
        .I2(\pending_q[3]_i_2_n_0 ),
        .I3(\pending_q[3]_i_3_n_0 ),
        .I4(\epoch_gray_q_reg_n_0_[0] ),
        .I5(\pending_q[3]_i_4_n_0 ),
        .O(pending_d[3]));
  LUT6 #(
    .INIT(64'h00000000B0B0B000)) 
    \pending_q[3]_i_2 
       (.I0(\out_addr_q[3]_i_4_n_0 ),
        .I1(p_2_in),
        .I2(\pending_q[7]_i_6_n_0 ),
        .I3(p_0_in),
        .I4(\out_addr_q[3]_i_5_n_0 ),
        .I5(\out_addr_q[3]_i_6_n_0 ),
        .O(\pending_q[3]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hBA)) 
    \pending_q[3]_i_3 
       (.I0(pending_q[2]),
        .I1(ack_q[2]),
        .I2(req_sync_q[2]),
        .O(\pending_q[3]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'h45)) 
    \pending_q[3]_i_4 
       (.I0(pending_q[3]),
        .I1(ack_q[3]),
        .I2(req_sync_q[3]),
        .O(\pending_q[3]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAAAAAAAAA888AAAA)) 
    \pending_q[4]_i_1 
       (.I0(\pending_q[5]_i_5_n_0 ),
        .I1(\pending_q[5]_i_2_n_0 ),
        .I2(\epoch_gray_q_reg_n_0_[0] ),
        .I3(\pending_q[5]_i_6_n_0 ),
        .I4(\pending_q[5]_i_4_n_0 ),
        .I5(\pending_q[5]_i_3_n_0 ),
        .O(pending_d[4]));
  LUT6 #(
    .INIT(64'hEFFFEFEF00000000)) 
    \pending_q[5]_i_1 
       (.I0(\pending_q[5]_i_2_n_0 ),
        .I1(\pending_q[5]_i_3_n_0 ),
        .I2(\pending_q[5]_i_4_n_0 ),
        .I3(\epoch_gray_q_reg_n_0_[0] ),
        .I4(\pending_q[5]_i_5_n_0 ),
        .I5(\pending_q[5]_i_6_n_0 ),
        .O(pending_d[5]));
  LUT2 #(
    .INIT(4'h2)) 
    \pending_q[5]_i_2 
       (.I0(out_valid_q),
        .I1(out_ready_IBUF),
        .O(\pending_q[5]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h444444444F444F4F)) 
    \pending_q[5]_i_3 
       (.I0(\pending_q[7]_i_7_n_0 ),
        .I1(p_0_in),
        .I2(pending_q[4]),
        .I3(ack_q[4]),
        .I4(req_sync_q[4]),
        .I5(\pending_q[5]_i_6_n_0 ),
        .O(\pending_q[5]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0000DDDD0000D000)) 
    \pending_q[5]_i_4 
       (.I0(p_1_in),
        .I1(\out_addr_q[3]_i_3_n_0 ),
        .I2(\out_addr_q[3]_i_5_n_0 ),
        .I3(\out_addr_q[3]_i_6_n_0 ),
        .I4(\out_addr_q[3]_i_4_n_0 ),
        .I5(p_2_in),
        .O(\pending_q[5]_i_4_n_0 ));
  LUT3 #(
    .INIT(8'hBA)) 
    \pending_q[5]_i_5 
       (.I0(pending_q[4]),
        .I1(ack_q[4]),
        .I2(req_sync_q[4]),
        .O(\pending_q[5]_i_5_n_0 ));
  LUT3 #(
    .INIT(8'hBA)) 
    \pending_q[5]_i_6 
       (.I0(pending_q[5]),
        .I1(ack_q[5]),
        .I2(req_sync_q[5]),
        .O(\pending_q[5]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h20AA2020AAAAAAAA)) 
    \pending_q[6]_i_1 
       (.I0(\pending_q[7]_i_3_n_0 ),
        .I1(out_ready_IBUF),
        .I2(out_valid_q),
        .I3(\pending_q[7]_i_4_n_0 ),
        .I4(\epoch_gray_q_reg_n_0_[0] ),
        .I5(\pending_q[7]_i_2_n_0 ),
        .O(pending_d[6]));
  LUT6 #(
    .INIT(64'h000000002F2FFF2F)) 
    \pending_q[7]_i_1 
       (.I0(out_valid_q),
        .I1(out_ready_IBUF),
        .I2(\pending_q[7]_i_2_n_0 ),
        .I3(\pending_q[7]_i_3_n_0 ),
        .I4(\epoch_gray_q_reg_n_0_[0] ),
        .I5(\pending_q[7]_i_4_n_0 ),
        .O(pending_d[7]));
  LUT6 #(
    .INIT(64'h00E0000000E000E0)) 
    \pending_q[7]_i_2 
       (.I0(p_2_in),
        .I1(\pending_q[7]_i_5_n_0 ),
        .I2(\pending_q[7]_i_6_n_0 ),
        .I3(\pending_q[7]_i_7_n_0 ),
        .I4(p_0_in),
        .I5(\pending_q[7]_i_8_n_0 ),
        .O(\pending_q[7]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hBA)) 
    \pending_q[7]_i_3 
       (.I0(pending_q[6]),
        .I1(ack_q[6]),
        .I2(req_sync_q[6]),
        .O(\pending_q[7]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'h45)) 
    \pending_q[7]_i_4 
       (.I0(pending_q[7]),
        .I1(ack_q[7]),
        .I2(req_sync_q[7]),
        .O(\pending_q[7]_i_4_n_0 ));
  LUT5 #(
    .INIT(32'h45000000)) 
    \pending_q[7]_i_5 
       (.I0(pending_q[2]),
        .I1(ack_q[2]),
        .I2(req_sync_q[2]),
        .I3(\pending_q[3]_i_4_n_0 ),
        .I4(\out_addr_q[3]_i_5_n_0 ),
        .O(\pending_q[7]_i_5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h0080FFFF)) 
    \pending_q[7]_i_6 
       (.I0(\out_addr_q[2]_i_4_n_0 ),
        .I1(\out_addr_q[2]_i_5_n_0 ),
        .I2(\pending_q[15]_i_7_n_0 ),
        .I3(\pending_q[15]_i_6_n_0 ),
        .I4(p_1_in),
        .O(\pending_q[7]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h000000000D0D000D)) 
    \pending_q[7]_i_7 
       (.I0(req_sync_q[7]),
        .I1(ack_q[7]),
        .I2(pending_q[7]),
        .I3(req_sync_q[6]),
        .I4(ack_q[6]),
        .I5(pending_q[6]),
        .O(\pending_q[7]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFF2F2FFF2)) 
    \pending_q[7]_i_8 
       (.I0(req_sync_q[5]),
        .I1(ack_q[5]),
        .I2(pending_q[5]),
        .I3(req_sync_q[4]),
        .I4(ack_q[4]),
        .I5(pending_q[4]),
        .O(\pending_q[7]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'h20AA2020AAAAAAAA)) 
    \pending_q[8]_i_1 
       (.I0(\pending_q[9]_i_3_n_0 ),
        .I1(out_ready_IBUF),
        .I2(out_valid_q),
        .I3(\pending_q[9]_i_4_n_0 ),
        .I4(\epoch_gray_q_reg_n_0_[0] ),
        .I5(\pending_q[9]_i_2_n_0 ),
        .O(pending_d[8]));
  LUT6 #(
    .INIT(64'h000000002F2FFF2F)) 
    \pending_q[9]_i_1 
       (.I0(out_valid_q),
        .I1(out_ready_IBUF),
        .I2(\pending_q[9]_i_2_n_0 ),
        .I3(\pending_q[9]_i_3_n_0 ),
        .I4(\epoch_gray_q_reg_n_0_[0] ),
        .I5(\pending_q[9]_i_4_n_0 ),
        .O(pending_d[9]));
  LUT6 #(
    .INIT(64'h0000000045450045)) 
    \pending_q[9]_i_2 
       (.I0(\out_addr_q[2]_i_2_n_0 ),
        .I1(\out_addr_q[2]_i_3_n_0 ),
        .I2(p_2_in),
        .I3(p_0_in),
        .I4(\out_addr_q[2]_i_4_n_0 ),
        .I5(\out_addr_q[2]_i_5_n_0 ),
        .O(\pending_q[9]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hBA)) 
    \pending_q[9]_i_3 
       (.I0(pending_q[8]),
        .I1(ack_q[8]),
        .I2(req_sync_q[8]),
        .O(\pending_q[9]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'h45)) 
    \pending_q[9]_i_4 
       (.I0(pending_q[9]),
        .I1(ack_q[9]),
        .I2(req_sync_q[9]),
        .O(\pending_q[9]_i_4_n_0 ));
  FDRE \pending_q_reg[0] 
       (.C(CLK),
        .CE(1'b1),
        .D(pending_d[0]),
        .Q(pending_q[0]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \pending_q_reg[10] 
       (.C(CLK),
        .CE(1'b1),
        .D(pending_d[10]),
        .Q(pending_q[10]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \pending_q_reg[11] 
       (.C(CLK),
        .CE(1'b1),
        .D(pending_d[11]),
        .Q(pending_q[11]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \pending_q_reg[12] 
       (.C(CLK),
        .CE(1'b1),
        .D(pending_d[12]),
        .Q(pending_q[12]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \pending_q_reg[13] 
       (.C(CLK),
        .CE(1'b1),
        .D(pending_d[13]),
        .Q(pending_q[13]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \pending_q_reg[14] 
       (.C(CLK),
        .CE(1'b1),
        .D(pending_d[14]),
        .Q(pending_q[14]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \pending_q_reg[15] 
       (.C(CLK),
        .CE(1'b1),
        .D(pending_d[15]),
        .Q(pending_q[15]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \pending_q_reg[1] 
       (.C(CLK),
        .CE(1'b1),
        .D(pending_d[1]),
        .Q(pending_q[1]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \pending_q_reg[2] 
       (.C(CLK),
        .CE(1'b1),
        .D(pending_d[2]),
        .Q(pending_q[2]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \pending_q_reg[3] 
       (.C(CLK),
        .CE(1'b1),
        .D(pending_d[3]),
        .Q(pending_q[3]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \pending_q_reg[4] 
       (.C(CLK),
        .CE(1'b1),
        .D(pending_d[4]),
        .Q(pending_q[4]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \pending_q_reg[5] 
       (.C(CLK),
        .CE(1'b1),
        .D(pending_d[5]),
        .Q(pending_q[5]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \pending_q_reg[6] 
       (.C(CLK),
        .CE(1'b1),
        .D(pending_d[6]),
        .Q(pending_q[6]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \pending_q_reg[7] 
       (.C(CLK),
        .CE(1'b1),
        .D(pending_d[7]),
        .Q(pending_q[7]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \pending_q_reg[8] 
       (.C(CLK),
        .CE(1'b1),
        .D(pending_d[8]),
        .Q(pending_q[8]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  FDRE \pending_q_reg[9] 
       (.C(CLK),
        .CE(1'b1),
        .D(pending_d[9]),
        .Q(pending_q[9]),
        .R(\epoch_gray_q[3]_i_1_n_0 ));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_meta_q_reg[0] 
       (.C(CLK),
        .CE(1'b1),
        .D(src_req_async[0]),
        .Q(req_meta_q[0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_meta_q_reg[10] 
       (.C(CLK),
        .CE(1'b1),
        .D(src_req_async[10]),
        .Q(req_meta_q[10]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_meta_q_reg[11] 
       (.C(CLK),
        .CE(1'b1),
        .D(src_req_async[11]),
        .Q(req_meta_q[11]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_meta_q_reg[12] 
       (.C(CLK),
        .CE(1'b1),
        .D(src_req_async[12]),
        .Q(req_meta_q[12]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_meta_q_reg[13] 
       (.C(CLK),
        .CE(1'b1),
        .D(src_req_async[13]),
        .Q(req_meta_q[13]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_meta_q_reg[14] 
       (.C(CLK),
        .CE(1'b1),
        .D(src_req_async[14]),
        .Q(req_meta_q[14]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_meta_q_reg[15] 
       (.C(CLK),
        .CE(1'b1),
        .D(src_req_async[15]),
        .Q(req_meta_q[15]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_meta_q_reg[1] 
       (.C(CLK),
        .CE(1'b1),
        .D(src_req_async[1]),
        .Q(req_meta_q[1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_meta_q_reg[2] 
       (.C(CLK),
        .CE(1'b1),
        .D(src_req_async[2]),
        .Q(req_meta_q[2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_meta_q_reg[3] 
       (.C(CLK),
        .CE(1'b1),
        .D(src_req_async[3]),
        .Q(req_meta_q[3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_meta_q_reg[4] 
       (.C(CLK),
        .CE(1'b1),
        .D(src_req_async[4]),
        .Q(req_meta_q[4]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_meta_q_reg[5] 
       (.C(CLK),
        .CE(1'b1),
        .D(src_req_async[5]),
        .Q(req_meta_q[5]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_meta_q_reg[6] 
       (.C(CLK),
        .CE(1'b1),
        .D(src_req_async[6]),
        .Q(req_meta_q[6]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_meta_q_reg[7] 
       (.C(CLK),
        .CE(1'b1),
        .D(src_req_async[7]),
        .Q(req_meta_q[7]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_meta_q_reg[8] 
       (.C(CLK),
        .CE(1'b1),
        .D(src_req_async[8]),
        .Q(req_meta_q[8]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_meta_q_reg[9] 
       (.C(CLK),
        .CE(1'b1),
        .D(src_req_async[9]),
        .Q(req_meta_q[9]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_sync_q_reg[0] 
       (.C(CLK),
        .CE(1'b1),
        .D(req_meta_q[0]),
        .Q(req_sync_q[0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_sync_q_reg[10] 
       (.C(CLK),
        .CE(1'b1),
        .D(req_meta_q[10]),
        .Q(req_sync_q[10]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_sync_q_reg[11] 
       (.C(CLK),
        .CE(1'b1),
        .D(req_meta_q[11]),
        .Q(req_sync_q[11]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_sync_q_reg[12] 
       (.C(CLK),
        .CE(1'b1),
        .D(req_meta_q[12]),
        .Q(req_sync_q[12]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_sync_q_reg[13] 
       (.C(CLK),
        .CE(1'b1),
        .D(req_meta_q[13]),
        .Q(req_sync_q[13]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_sync_q_reg[14] 
       (.C(CLK),
        .CE(1'b1),
        .D(req_meta_q[14]),
        .Q(req_sync_q[14]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_sync_q_reg[15] 
       (.C(CLK),
        .CE(1'b1),
        .D(req_meta_q[15]),
        .Q(req_sync_q[15]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_sync_q_reg[1] 
       (.C(CLK),
        .CE(1'b1),
        .D(req_meta_q[1]),
        .Q(req_sync_q[1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_sync_q_reg[2] 
       (.C(CLK),
        .CE(1'b1),
        .D(req_meta_q[2]),
        .Q(req_sync_q[2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_sync_q_reg[3] 
       (.C(CLK),
        .CE(1'b1),
        .D(req_meta_q[3]),
        .Q(req_sync_q[3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_sync_q_reg[4] 
       (.C(CLK),
        .CE(1'b1),
        .D(req_meta_q[4]),
        .Q(req_sync_q[4]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_sync_q_reg[5] 
       (.C(CLK),
        .CE(1'b1),
        .D(req_meta_q[5]),
        .Q(req_sync_q[5]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_sync_q_reg[6] 
       (.C(CLK),
        .CE(1'b1),
        .D(req_meta_q[6]),
        .Q(req_sync_q[6]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_sync_q_reg[7] 
       (.C(CLK),
        .CE(1'b1),
        .D(req_meta_q[7]),
        .Q(req_sync_q[7]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_sync_q_reg[8] 
       (.C(CLK),
        .CE(1'b1),
        .D(req_meta_q[8]),
        .Q(req_sync_q[8]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \req_sync_q_reg[9] 
       (.C(CLK),
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
       (.C(CLK),
        .CE(1'b1),
        .CLR(\reset_release_q[1]_i_1_n_0 ),
        .D(1'b1),
        .Q(reset_release_q[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \reset_release_q_reg[1] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(\reset_release_q[1]_i_1_n_0 ),
        .D(reset_release_q[0]),
        .Q(reset_release_q[1]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[0]_inst_i_1 
       (.I0(reset_release_q[1]),
        .I1(ack_q[0]),
        .O(src_ack_async_OBUF[0]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[10]_inst_i_1 
       (.I0(reset_release_q[1]),
        .I1(ack_q[10]),
        .O(src_ack_async_OBUF[10]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[11]_inst_i_1 
       (.I0(reset_release_q[1]),
        .I1(ack_q[11]),
        .O(src_ack_async_OBUF[11]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[12]_inst_i_1 
       (.I0(reset_release_q[1]),
        .I1(ack_q[12]),
        .O(src_ack_async_OBUF[12]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[13]_inst_i_1 
       (.I0(reset_release_q[1]),
        .I1(ack_q[13]),
        .O(src_ack_async_OBUF[13]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[14]_inst_i_1 
       (.I0(reset_release_q[1]),
        .I1(ack_q[14]),
        .O(src_ack_async_OBUF[14]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[15]_inst_i_1 
       (.I0(reset_release_q[1]),
        .I1(ack_q[15]),
        .O(src_ack_async_OBUF[15]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[1]_inst_i_1 
       (.I0(reset_release_q[1]),
        .I1(ack_q[1]),
        .O(src_ack_async_OBUF[1]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[2]_inst_i_1 
       (.I0(reset_release_q[1]),
        .I1(ack_q[2]),
        .O(src_ack_async_OBUF[2]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[3]_inst_i_1 
       (.I0(reset_release_q[1]),
        .I1(ack_q[3]),
        .O(src_ack_async_OBUF[3]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[4]_inst_i_1 
       (.I0(reset_release_q[1]),
        .I1(ack_q[4]),
        .O(src_ack_async_OBUF[4]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[5]_inst_i_1 
       (.I0(reset_release_q[1]),
        .I1(ack_q[5]),
        .O(src_ack_async_OBUF[5]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[6]_inst_i_1 
       (.I0(reset_release_q[1]),
        .I1(ack_q[6]),
        .O(src_ack_async_OBUF[6]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[7]_inst_i_1 
       (.I0(reset_release_q[1]),
        .I1(ack_q[7]),
        .O(src_ack_async_OBUF[7]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[8]_inst_i_1 
       (.I0(reset_release_q[1]),
        .I1(ack_q[8]),
        .O(src_ack_async_OBUF[8]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[9]_inst_i_1 
       (.I0(reset_release_q[1]),
        .I1(ack_q[9]),
        .O(src_ack_async_OBUF[9]));
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
