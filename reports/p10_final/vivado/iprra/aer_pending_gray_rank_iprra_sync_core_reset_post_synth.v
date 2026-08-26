// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Fri Aug 21 15:28:28 2026
// Host        : <LOCAL_HOST> running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               reports/p10_candidates/vivado/iprra/aer_pending_gray_rank_iprra_sync_core_reset_post_synth.v
// Design      : aer_pending_gray_rank_iprra_sync_core_reset
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* NETLIST_CHECKSUM = "8b413bfe" *) 
(* NotValidForBitStream *)
module aer_pending_gray_rank_iprra_sync_core_reset
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
  aer_pending_rank_reuse_core core
       (.CLK(clk_IBUF_BUFG),
        .out_addr_OBUF(out_addr_OBUF),
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

module aer_pending_rank_reuse_core
   (out_addr_OBUF,
    out_valid_OBUF,
    src_ack_async_OBUF,
    src_req_async,
    CLK,
    rst_n_IBUF,
    out_ready_IBUF);
  output [3:0]out_addr_OBUF;
  output out_valid_OBUF;
  output [15:0]src_ack_async_OBUF;
  input [15:0]src_req_async;
  input CLK;
  input rst_n_IBUF;
  input out_ready_IBUF;

  wire CLK;
  wire [15:0]accepted_pending_rank;
  wire [15:0]ack_rank_d;
  wire [15:0]ack_rank_q;
  wire can_load_output;
  wire grant_valid;
  wire \iprra_selector.selector/(null)[0].ls049_in ;
  wire \iprra_selector.selector/(null)[0].ls1 ;
  wire \iprra_selector.selector/(null)[0].ls1224_in ;
  wire \iprra_selector.selector/(null)[0].rs0107_in ;
  wire \iprra_selector.selector/(null)[0].rs051_in ;
  wire \iprra_selector.selector/(null)[0].rs079_in ;
  wire \iprra_selector.selector/(null)[0].rs093_in ;
  wire \iprra_selector.selector/(null)[0].rs1 ;
  wire \iprra_selector.selector/(null)[0].rs1217_in ;
  wire \iprra_selector.selector/(null)[0].rs152_in ;
  wire \iprra_selector.selector/combine_state_return014_out ;
  wire \iprra_selector.selector/combine_state_return027_out ;
  wire \iprra_selector.selector/combine_state_return066_out ;
  wire \iprra_selector.selector/combine_state_return069_out ;
  wire \iprra_selector.selector/combine_state_return079_out ;
  wire \iprra_selector.selector/combine_state_return0__0 ;
  wire \iprra_selector.selector/gl_root ;
  wire \iprra_selector.selector/local_branch_return012_out ;
  wire \iprra_selector.selector/local_branch_return03_out ;
  wire \iprra_selector.selector/local_branch_return0__4 ;
  wire [3:0]out_addr_OBUF;
  wire out_rank_d;
  wire \out_rank_q[0]_i_11_n_0 ;
  wire \out_rank_q[0]_i_12_n_0 ;
  wire \out_rank_q[0]_i_13_n_0 ;
  wire \out_rank_q[0]_i_14_n_0 ;
  wire \out_rank_q[0]_i_15_n_0 ;
  wire \out_rank_q[0]_i_16_n_0 ;
  wire \out_rank_q[0]_i_18_n_0 ;
  wire \out_rank_q[0]_i_19_n_0 ;
  wire \out_rank_q[0]_i_20_n_0 ;
  wire \out_rank_q[0]_i_21_n_0 ;
  wire \out_rank_q[0]_i_22_n_0 ;
  wire \out_rank_q[0]_i_23_n_0 ;
  wire \out_rank_q[0]_i_24_n_0 ;
  wire \out_rank_q[0]_i_2_n_0 ;
  wire \out_rank_q[0]_i_3_n_0 ;
  wire \out_rank_q[0]_i_4_n_0 ;
  wire \out_rank_q[0]_i_5_n_0 ;
  wire \out_rank_q[0]_i_6_n_0 ;
  wire \out_rank_q[0]_i_7_n_0 ;
  wire \out_rank_q[0]_i_8_n_0 ;
  wire \out_rank_q[0]_i_9_n_0 ;
  wire \out_rank_q[1]_i_2_n_0 ;
  wire \out_rank_q[1]_i_3_n_0 ;
  wire \out_rank_q[1]_i_4_n_0 ;
  wire \out_rank_q[1]_i_5_n_0 ;
  wire \out_rank_q[1]_i_6_n_0 ;
  wire \out_rank_q[1]_i_8_n_0 ;
  wire \out_rank_q[1]_i_9_n_0 ;
  wire \out_rank_q[2]_i_10_n_0 ;
  wire \out_rank_q[2]_i_11_n_0 ;
  wire \out_rank_q[2]_i_12_n_0 ;
  wire \out_rank_q[2]_i_2_n_0 ;
  wire \out_rank_q[2]_i_3_n_0 ;
  wire \out_rank_q[2]_i_6_n_0 ;
  wire \out_rank_q[2]_i_7_n_0 ;
  wire \out_rank_q[2]_i_9_n_0 ;
  wire \out_rank_q[3]_i_10_n_0 ;
  wire \out_rank_q[3]_i_11_n_0 ;
  wire \out_rank_q[3]_i_12_n_0 ;
  wire \out_rank_q[3]_i_13_n_0 ;
  wire \out_rank_q[3]_i_14_n_0 ;
  wire \out_rank_q[3]_i_15_n_0 ;
  wire \out_rank_q[3]_i_16_n_0 ;
  wire \out_rank_q[3]_i_17_n_0 ;
  wire \out_rank_q[3]_i_19_n_0 ;
  wire \out_rank_q[3]_i_1_n_0 ;
  wire \out_rank_q[3]_i_20_n_0 ;
  wire \out_rank_q[3]_i_21_n_0 ;
  wire \out_rank_q[3]_i_23_n_0 ;
  wire \out_rank_q[3]_i_24_n_0 ;
  wire \out_rank_q[3]_i_25_n_0 ;
  wire \out_rank_q[3]_i_27_n_0 ;
  wire \out_rank_q[3]_i_36_n_0 ;
  wire \out_rank_q[3]_i_5_n_0 ;
  wire \out_rank_q[3]_i_6_n_0 ;
  wire \out_rank_q[3]_i_7_n_0 ;
  wire out_ready_IBUF;
  wire out_valid_OBUF;
  wire out_valid_q;
  wire out_valid_q_i_1_n_0;
  wire [9:5]p_0_in;
  wire [15:0]pending_rank_d;
  wire [15:0]pending_rank_q;
  wire \pending_rank_q[11]_i_2_n_0 ;
  wire \pending_rank_q[15]_i_2_n_0 ;
  wire \pending_rank_q[15]_i_5_n_0 ;
  wire \pending_rank_q[15]_i_6_n_0 ;
  wire \pending_rank_q[15]_i_7_n_0 ;
  wire \pending_rank_q[15]_i_8_n_0 ;
  wire \pending_rank_q[15]_i_9_n_0 ;
  wire \pending_rank_q[3]_i_2_n_0 ;
  wire \pending_rank_q[7]_i_2_n_0 ;
  wire [2:0]rank;
  (* async_reg = "true" *) wire [15:0]req_meta_q;
  (* async_reg = "true" *) wire [15:0]req_sync_q;
  (* async_reg = "true" *) wire [1:0]reset_release_q;
  wire \reset_release_q[1]_i_1_n_0 ;
  wire rst_n_IBUF;
  wire [3:0]selected_rank;
  wire [15:0]src_ack_async_OBUF;
  wire [15:0]src_req_async;

  LUT3 #(
    .INIT(8'h8C)) 
    \ack_rank_q[0]_i_1 
       (.I0(ack_rank_q[0]),
        .I1(req_sync_q[0]),
        .I2(pending_rank_q[0]),
        .O(ack_rank_d[0]));
  LUT3 #(
    .INIT(8'h8C)) 
    \ack_rank_q[10]_i_1 
       (.I0(ack_rank_q[10]),
        .I1(req_sync_q[15]),
        .I2(pending_rank_q[10]),
        .O(ack_rank_d[10]));
  LUT3 #(
    .INIT(8'h8C)) 
    \ack_rank_q[11]_i_1 
       (.I0(ack_rank_q[11]),
        .I1(req_sync_q[14]),
        .I2(pending_rank_q[11]),
        .O(ack_rank_d[11]));
  LUT3 #(
    .INIT(8'h8C)) 
    \ack_rank_q[12]_i_1 
       (.I0(ack_rank_q[12]),
        .I1(req_sync_q[10]),
        .I2(pending_rank_q[12]),
        .O(ack_rank_d[12]));
  LUT3 #(
    .INIT(8'h8C)) 
    \ack_rank_q[13]_i_1 
       (.I0(ack_rank_q[13]),
        .I1(req_sync_q[11]),
        .I2(pending_rank_q[13]),
        .O(ack_rank_d[13]));
  LUT3 #(
    .INIT(8'h8C)) 
    \ack_rank_q[14]_i_1 
       (.I0(ack_rank_q[14]),
        .I1(req_sync_q[9]),
        .I2(pending_rank_q[14]),
        .O(ack_rank_d[14]));
  LUT3 #(
    .INIT(8'h8C)) 
    \ack_rank_q[15]_i_1 
       (.I0(ack_rank_q[15]),
        .I1(req_sync_q[8]),
        .I2(pending_rank_q[15]),
        .O(ack_rank_d[15]));
  LUT3 #(
    .INIT(8'h8C)) 
    \ack_rank_q[1]_i_1 
       (.I0(ack_rank_q[1]),
        .I1(req_sync_q[1]),
        .I2(pending_rank_q[1]),
        .O(ack_rank_d[1]));
  LUT3 #(
    .INIT(8'h8C)) 
    \ack_rank_q[2]_i_1 
       (.I0(ack_rank_q[2]),
        .I1(req_sync_q[3]),
        .I2(pending_rank_q[2]),
        .O(ack_rank_d[2]));
  LUT3 #(
    .INIT(8'h8C)) 
    \ack_rank_q[3]_i_1 
       (.I0(ack_rank_q[3]),
        .I1(req_sync_q[2]),
        .I2(pending_rank_q[3]),
        .O(ack_rank_d[3]));
  LUT3 #(
    .INIT(8'h8C)) 
    \ack_rank_q[4]_i_1 
       (.I0(ack_rank_q[4]),
        .I1(req_sync_q[6]),
        .I2(pending_rank_q[4]),
        .O(ack_rank_d[4]));
  LUT3 #(
    .INIT(8'h8C)) 
    \ack_rank_q[5]_i_1 
       (.I0(ack_rank_q[5]),
        .I1(req_sync_q[7]),
        .I2(pending_rank_q[5]),
        .O(ack_rank_d[5]));
  LUT3 #(
    .INIT(8'h8C)) 
    \ack_rank_q[6]_i_1 
       (.I0(ack_rank_q[6]),
        .I1(req_sync_q[5]),
        .I2(pending_rank_q[6]),
        .O(ack_rank_d[6]));
  LUT3 #(
    .INIT(8'h8C)) 
    \ack_rank_q[7]_i_1 
       (.I0(ack_rank_q[7]),
        .I1(req_sync_q[4]),
        .I2(pending_rank_q[7]),
        .O(ack_rank_d[7]));
  LUT3 #(
    .INIT(8'h8C)) 
    \ack_rank_q[8]_i_1 
       (.I0(ack_rank_q[8]),
        .I1(req_sync_q[12]),
        .I2(pending_rank_q[8]),
        .O(ack_rank_d[8]));
  LUT3 #(
    .INIT(8'h8C)) 
    \ack_rank_q[9]_i_1 
       (.I0(ack_rank_q[9]),
        .I1(req_sync_q[13]),
        .I2(pending_rank_q[9]),
        .O(ack_rank_d[9]));
  FDRE \ack_rank_q_reg[0] 
       (.C(CLK),
        .CE(1'b1),
        .D(ack_rank_d[0]),
        .Q(ack_rank_q[0]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \ack_rank_q_reg[10] 
       (.C(CLK),
        .CE(1'b1),
        .D(ack_rank_d[10]),
        .Q(ack_rank_q[10]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \ack_rank_q_reg[11] 
       (.C(CLK),
        .CE(1'b1),
        .D(ack_rank_d[11]),
        .Q(ack_rank_q[11]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \ack_rank_q_reg[12] 
       (.C(CLK),
        .CE(1'b1),
        .D(ack_rank_d[12]),
        .Q(ack_rank_q[12]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \ack_rank_q_reg[13] 
       (.C(CLK),
        .CE(1'b1),
        .D(ack_rank_d[13]),
        .Q(ack_rank_q[13]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \ack_rank_q_reg[14] 
       (.C(CLK),
        .CE(1'b1),
        .D(ack_rank_d[14]),
        .Q(ack_rank_q[14]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \ack_rank_q_reg[15] 
       (.C(CLK),
        .CE(1'b1),
        .D(ack_rank_d[15]),
        .Q(ack_rank_q[15]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \ack_rank_q_reg[1] 
       (.C(CLK),
        .CE(1'b1),
        .D(ack_rank_d[1]),
        .Q(ack_rank_q[1]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \ack_rank_q_reg[2] 
       (.C(CLK),
        .CE(1'b1),
        .D(ack_rank_d[2]),
        .Q(ack_rank_q[2]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \ack_rank_q_reg[3] 
       (.C(CLK),
        .CE(1'b1),
        .D(ack_rank_d[3]),
        .Q(ack_rank_q[3]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \ack_rank_q_reg[4] 
       (.C(CLK),
        .CE(1'b1),
        .D(ack_rank_d[4]),
        .Q(ack_rank_q[4]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \ack_rank_q_reg[5] 
       (.C(CLK),
        .CE(1'b1),
        .D(ack_rank_d[5]),
        .Q(ack_rank_q[5]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \ack_rank_q_reg[6] 
       (.C(CLK),
        .CE(1'b1),
        .D(ack_rank_d[6]),
        .Q(ack_rank_q[6]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \ack_rank_q_reg[7] 
       (.C(CLK),
        .CE(1'b1),
        .D(ack_rank_d[7]),
        .Q(ack_rank_q[7]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \ack_rank_q_reg[8] 
       (.C(CLK),
        .CE(1'b1),
        .D(ack_rank_d[8]),
        .Q(ack_rank_q[8]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \ack_rank_q_reg[9] 
       (.C(CLK),
        .CE(1'b1),
        .D(ack_rank_d[9]),
        .Q(ack_rank_q[9]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \out_addr_OBUF[0]_inst_i_1 
       (.I0(rank[0]),
        .I1(rank[1]),
        .O(out_addr_OBUF[0]));
  LUT2 #(
    .INIT(4'h6)) 
    \out_addr_OBUF[1]_inst_i_1 
       (.I0(rank[2]),
        .I1(rank[1]),
        .O(out_addr_OBUF[1]));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \out_addr_OBUF[2]_inst_i_1 
       (.I0(out_addr_OBUF[3]),
        .I1(rank[2]),
        .O(out_addr_OBUF[2]));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFF1)) 
    \out_rank_q[0]_i_1 
       (.I0(\out_rank_q[0]_i_2_n_0 ),
        .I1(\out_rank_q[0]_i_3_n_0 ),
        .I2(\out_rank_q[0]_i_4_n_0 ),
        .I3(\out_rank_q[0]_i_5_n_0 ),
        .I4(\out_rank_q[0]_i_6_n_0 ),
        .I5(\out_rank_q[0]_i_7_n_0 ),
        .O(selected_rank[0]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT4 #(
    .INIT(16'h0004)) 
    \out_rank_q[0]_i_10 
       (.I0(rank[2]),
        .I1(out_addr_OBUF[3]),
        .I2(rank[0]),
        .I3(rank[1]),
        .O(p_0_in[9]));
  LUT6 #(
    .INIT(64'hEFEEEEEEEEEEFEEE)) 
    \out_rank_q[0]_i_11 
       (.I0(accepted_pending_rank[13]),
        .I1(accepted_pending_rank[12]),
        .I2(rank[2]),
        .I3(out_addr_OBUF[3]),
        .I4(rank[0]),
        .I5(rank[1]),
        .O(\out_rank_q[0]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'h1FF5111111111111)) 
    \out_rank_q[0]_i_12 
       (.I0(accepted_pending_rank[13]),
        .I1(accepted_pending_rank[12]),
        .I2(rank[1]),
        .I3(rank[0]),
        .I4(out_addr_OBUF[3]),
        .I5(rank[2]),
        .O(\out_rank_q[0]_i_12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT5 #(
    .INIT(32'hA2AAAAAA)) 
    \out_rank_q[0]_i_13 
       (.I0(accepted_pending_rank[14]),
        .I1(rank[1]),
        .I2(rank[0]),
        .I3(out_addr_OBUF[3]),
        .I4(rank[2]),
        .O(\out_rank_q[0]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'h31FF31FF30FF30FA)) 
    \out_rank_q[0]_i_14 
       (.I0(\iprra_selector.selector/(null)[0].ls1 ),
        .I1(\iprra_selector.selector/(null)[0].rs1 ),
        .I2(\iprra_selector.selector/(null)[0].ls049_in ),
        .I3(\iprra_selector.selector/combine_state_return027_out ),
        .I4(\iprra_selector.selector/(null)[0].ls1224_in ),
        .I5(\iprra_selector.selector/combine_state_return014_out ),
        .O(\out_rank_q[0]_i_14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT5 #(
    .INIT(32'h33333BB3)) 
    \out_rank_q[0]_i_15 
       (.I0(\iprra_selector.selector/(null)[0].rs0107_in ),
        .I1(accepted_pending_rank[1]),
        .I2(rank[1]),
        .I3(rank[0]),
        .I4(\out_rank_q[1]_i_9_n_0 ),
        .O(\out_rank_q[0]_i_15_n_0 ));
  LUT6 #(
    .INIT(64'h55555555DFDDDDDD)) 
    \out_rank_q[0]_i_16 
       (.I0(\iprra_selector.selector/local_branch_return012_out ),
        .I1(accepted_pending_rank[0]),
        .I2(\out_rank_q[1]_i_9_n_0 ),
        .I3(rank[0]),
        .I4(rank[1]),
        .I5(accepted_pending_rank[1]),
        .O(\out_rank_q[0]_i_16_n_0 ));
  LUT6 #(
    .INIT(64'h802A00AAEABFAAFF)) 
    \out_rank_q[0]_i_17 
       (.I0(\iprra_selector.selector/combine_state_return014_out ),
        .I1(rank[1]),
        .I2(rank[0]),
        .I3(out_addr_OBUF[3]),
        .I4(rank[2]),
        .I5(\iprra_selector.selector/combine_state_return0__0 ),
        .O(\iprra_selector.selector/gl_root ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'hAAAAAAA8)) 
    \out_rank_q[0]_i_18 
       (.I0(accepted_pending_rank[0]),
        .I1(rank[1]),
        .I2(rank[0]),
        .I3(out_addr_OBUF[3]),
        .I4(rank[2]),
        .O(\out_rank_q[0]_i_18_n_0 ));
  LUT6 #(
    .INIT(64'hFFFD0000FFFFFFFF)) 
    \out_rank_q[0]_i_19 
       (.I0(rank[2]),
        .I1(out_addr_OBUF[3]),
        .I2(rank[0]),
        .I3(rank[1]),
        .I4(accepted_pending_rank[4]),
        .I5(accepted_pending_rank[5]),
        .O(\out_rank_q[0]_i_19_n_0 ));
  LUT6 #(
    .INIT(64'hFBFF0000FFFFFFFF)) 
    \out_rank_q[0]_i_2 
       (.I0(rank[2]),
        .I1(out_addr_OBUF[3]),
        .I2(rank[0]),
        .I3(rank[1]),
        .I4(accepted_pending_rank[10]),
        .I5(accepted_pending_rank[11]),
        .O(\out_rank_q[0]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEEEEEEEFEEEEFEEE)) 
    \out_rank_q[0]_i_20 
       (.I0(accepted_pending_rank[5]),
        .I1(accepted_pending_rank[4]),
        .I2(rank[1]),
        .I3(rank[0]),
        .I4(out_addr_OBUF[3]),
        .I5(rank[2]),
        .O(\out_rank_q[0]_i_20_n_0 ));
  LUT6 #(
    .INIT(64'h11111FF511111111)) 
    \out_rank_q[0]_i_21 
       (.I0(accepted_pending_rank[5]),
        .I1(accepted_pending_rank[4]),
        .I2(rank[1]),
        .I3(rank[0]),
        .I4(out_addr_OBUF[3]),
        .I5(rank[2]),
        .O(\out_rank_q[0]_i_21_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'hAAA2AAAA)) 
    \out_rank_q[0]_i_22 
       (.I0(accepted_pending_rank[6]),
        .I1(rank[1]),
        .I2(rank[0]),
        .I3(out_addr_OBUF[3]),
        .I4(rank[2]),
        .O(\out_rank_q[0]_i_22_n_0 ));
  LUT6 #(
    .INIT(64'hBB33AA00FFFFFBFB)) 
    \out_rank_q[0]_i_23 
       (.I0(\iprra_selector.selector/combine_state_return0__0 ),
        .I1(\iprra_selector.selector/(null)[0].rs152_in ),
        .I2(\iprra_selector.selector/combine_state_return069_out ),
        .I3(\iprra_selector.selector/(null)[0].rs1217_in ),
        .I4(\iprra_selector.selector/combine_state_return066_out ),
        .I5(\iprra_selector.selector/(null)[0].rs051_in ),
        .O(\out_rank_q[0]_i_23_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT4 #(
    .INIT(16'hBDDD)) 
    \out_rank_q[0]_i_24 
       (.I0(out_addr_OBUF[3]),
        .I1(rank[2]),
        .I2(rank[0]),
        .I3(rank[1]),
        .O(\out_rank_q[0]_i_24_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \out_rank_q[0]_i_25 
       (.I0(\iprra_selector.selector/(null)[0].rs079_in ),
        .I1(\out_rank_q[0]_i_9_n_0 ),
        .O(\iprra_selector.selector/(null)[0].ls049_in ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \out_rank_q[0]_i_26 
       (.I0(\iprra_selector.selector/combine_state_return079_out ),
        .I1(\out_rank_q[0]_i_12_n_0 ),
        .O(\iprra_selector.selector/combine_state_return027_out ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT5 #(
    .INIT(32'hDDDDFDFF)) 
    \out_rank_q[0]_i_27 
       (.I0(\out_rank_q[0]_i_12_n_0 ),
        .I1(\iprra_selector.selector/combine_state_return079_out ),
        .I2(\iprra_selector.selector/(null)[0].rs079_in ),
        .I3(\out_rank_q[0]_i_9_n_0 ),
        .I4(\iprra_selector.selector/(null)[0].rs1 ),
        .O(\iprra_selector.selector/combine_state_return0__0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT4 #(
    .INIT(16'h78F0)) 
    \out_rank_q[0]_i_28 
       (.I0(rank[1]),
        .I1(rank[0]),
        .I2(out_addr_OBUF[3]),
        .I3(rank[2]),
        .O(\iprra_selector.selector/(null)[0].rs1217_in ));
  LUT2 #(
    .INIT(4'hB)) 
    \out_rank_q[0]_i_29 
       (.I0(\iprra_selector.selector/(null)[0].rs0107_in ),
        .I1(\out_rank_q[1]_i_8_n_0 ),
        .O(\iprra_selector.selector/combine_state_return066_out ));
  LUT6 #(
    .INIT(64'hFFB0FFFFFFFFFFFF)) 
    \out_rank_q[0]_i_3 
       (.I0(\iprra_selector.selector/combine_state_return014_out ),
        .I1(\out_rank_q[3]_i_19_n_0 ),
        .I2(\out_rank_q[3]_i_20_n_0 ),
        .I3(\out_rank_q[0]_i_8_n_0 ),
        .I4(\iprra_selector.selector/local_branch_return03_out ),
        .I5(\out_rank_q[0]_i_9_n_0 ),
        .O(\out_rank_q[0]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h4444444404040004)) 
    \out_rank_q[0]_i_4 
       (.I0(\out_rank_q[3]_i_7_n_0 ),
        .I1(accepted_pending_rank[9]),
        .I2(pending_rank_q[8]),
        .I3(req_sync_q[12]),
        .I4(ack_rank_q[8]),
        .I5(p_0_in[9]),
        .O(\out_rank_q[0]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h000000000404F444)) 
    \out_rank_q[0]_i_5 
       (.I0(\out_rank_q[3]_i_17_n_0 ),
        .I1(\out_rank_q[0]_i_11_n_0 ),
        .I2(\out_rank_q[0]_i_12_n_0 ),
        .I3(accepted_pending_rank[15]),
        .I4(\out_rank_q[0]_i_13_n_0 ),
        .I5(\out_rank_q[0]_i_14_n_0 ),
        .O(\out_rank_q[0]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h11111111111F1111)) 
    \out_rank_q[0]_i_6 
       (.I0(\out_rank_q[1]_i_2_n_0 ),
        .I1(\out_rank_q[1]_i_4_n_0 ),
        .I2(\out_rank_q[0]_i_15_n_0 ),
        .I3(\out_rank_q[0]_i_16_n_0 ),
        .I4(\iprra_selector.selector/gl_root ),
        .I5(\out_rank_q[0]_i_18_n_0 ),
        .O(\out_rank_q[0]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h000000000404F444)) 
    \out_rank_q[0]_i_7 
       (.I0(\out_rank_q[0]_i_19_n_0 ),
        .I1(\out_rank_q[0]_i_20_n_0 ),
        .I2(\out_rank_q[0]_i_21_n_0 ),
        .I3(accepted_pending_rank[7]),
        .I4(\out_rank_q[0]_i_22_n_0 ),
        .I5(\out_rank_q[0]_i_23_n_0 ),
        .O(\out_rank_q[0]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFFFF41)) 
    \out_rank_q[0]_i_8 
       (.I0(\out_rank_q[0]_i_24_n_0 ),
        .I1(rank[0]),
        .I2(rank[1]),
        .I3(accepted_pending_rank[8]),
        .I4(accepted_pending_rank[9]),
        .I5(\iprra_selector.selector/(null)[0].rs079_in ),
        .O(\out_rank_q[0]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'h111111111FF51111)) 
    \out_rank_q[0]_i_9 
       (.I0(accepted_pending_rank[9]),
        .I1(accepted_pending_rank[8]),
        .I2(rank[1]),
        .I3(rank[0]),
        .I4(out_addr_OBUF[3]),
        .I5(rank[2]),
        .O(\out_rank_q[0]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hFFFCFFFDFFFCFFFF)) 
    \out_rank_q[1]_i_1 
       (.I0(\out_rank_q[1]_i_2_n_0 ),
        .I1(\out_rank_q[1]_i_3_n_0 ),
        .I2(\out_rank_q[2]_i_2_n_0 ),
        .I3(\out_rank_q[3]_i_6_n_0 ),
        .I4(\out_rank_q[1]_i_4_n_0 ),
        .I5(\out_rank_q[1]_i_5_n_0 ),
        .O(selected_rank[1]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT4 #(
    .INIT(16'h8111)) 
    \out_rank_q[1]_i_10 
       (.I0(rank[2]),
        .I1(out_addr_OBUF[3]),
        .I2(rank[0]),
        .I3(rank[1]),
        .O(\iprra_selector.selector/combine_state_return069_out ));
  LUT6 #(
    .INIT(64'hFEFF0000FFFFFFFF)) 
    \out_rank_q[1]_i_2 
       (.I0(rank[2]),
        .I1(out_addr_OBUF[3]),
        .I2(rank[0]),
        .I3(rank[1]),
        .I4(accepted_pending_rank[2]),
        .I5(accepted_pending_rank[3]),
        .O(\out_rank_q[1]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h0000EEFE)) 
    \out_rank_q[1]_i_3 
       (.I0(accepted_pending_rank[15]),
        .I1(pending_rank_q[14]),
        .I2(req_sync_q[9]),
        .I3(ack_rank_q[14]),
        .I4(\out_rank_q[3]_i_14_n_0 ),
        .O(\out_rank_q[1]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFF70FFFFFFFFFFFF)) 
    \out_rank_q[1]_i_4 
       (.I0(\iprra_selector.selector/combine_state_return014_out ),
        .I1(\out_rank_q[3]_i_20_n_0 ),
        .I2(\out_rank_q[3]_i_19_n_0 ),
        .I3(\out_rank_q[1]_i_6_n_0 ),
        .I4(\iprra_selector.selector/local_branch_return012_out ),
        .I5(\out_rank_q[1]_i_8_n_0 ),
        .O(\out_rank_q[1]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h00020000FFFFFFFF)) 
    \out_rank_q[1]_i_5 
       (.I0(accepted_pending_rank[3]),
        .I1(rank[2]),
        .I2(out_addr_OBUF[3]),
        .I3(rank[0]),
        .I4(rank[1]),
        .I5(accepted_pending_rank[2]),
        .O(\out_rank_q[1]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFFFF41)) 
    \out_rank_q[1]_i_6 
       (.I0(\out_rank_q[1]_i_9_n_0 ),
        .I1(rank[0]),
        .I2(rank[1]),
        .I3(accepted_pending_rank[0]),
        .I4(accepted_pending_rank[1]),
        .I5(\iprra_selector.selector/(null)[0].rs0107_in ),
        .O(\out_rank_q[1]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h44404444FF40FFFF)) 
    \out_rank_q[1]_i_7 
       (.I0(\iprra_selector.selector/(null)[0].rs093_in ),
        .I1(\out_rank_q[0]_i_21_n_0 ),
        .I2(\iprra_selector.selector/combine_state_return069_out ),
        .I3(\iprra_selector.selector/(null)[0].rs0107_in ),
        .I4(\out_rank_q[1]_i_8_n_0 ),
        .I5(\iprra_selector.selector/(null)[0].rs152_in ),
        .O(\iprra_selector.selector/local_branch_return012_out ));
  LUT6 #(
    .INIT(64'h1111111111111FF5)) 
    \out_rank_q[1]_i_8 
       (.I0(accepted_pending_rank[1]),
        .I1(accepted_pending_rank[0]),
        .I2(rank[1]),
        .I3(rank[0]),
        .I4(out_addr_OBUF[3]),
        .I5(rank[2]),
        .O(\out_rank_q[1]_i_8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT4 #(
    .INIT(16'h7EEE)) 
    \out_rank_q[1]_i_9 
       (.I0(out_addr_OBUF[3]),
        .I1(rank[2]),
        .I2(rank[0]),
        .I3(rank[1]),
        .O(\out_rank_q[1]_i_9_n_0 ));
  LUT5 #(
    .INIT(32'hEFEFEFEE)) 
    \out_rank_q[2]_i_1 
       (.I0(\out_rank_q[3]_i_5_n_0 ),
        .I1(\out_rank_q[2]_i_2_n_0 ),
        .I2(\out_rank_q[2]_i_3_n_0 ),
        .I3(accepted_pending_rank[4]),
        .I4(accepted_pending_rank[5]),
        .O(selected_rank[2]));
  LUT6 #(
    .INIT(64'hFFFFFFFF8007FFFF)) 
    \out_rank_q[2]_i_10 
       (.I0(rank[1]),
        .I1(rank[0]),
        .I2(out_addr_OBUF[3]),
        .I3(rank[2]),
        .I4(\out_rank_q[1]_i_8_n_0 ),
        .I5(\iprra_selector.selector/(null)[0].rs0107_in ),
        .O(\out_rank_q[2]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hFDDFFDDFFDDD1001)) 
    \out_rank_q[2]_i_11 
       (.I0(\iprra_selector.selector/(null)[0].rs093_in ),
        .I1(\out_rank_q[2]_i_12_n_0 ),
        .I2(rank[0]),
        .I3(rank[1]),
        .I4(accepted_pending_rank[4]),
        .I5(accepted_pending_rank[5]),
        .O(\out_rank_q[2]_i_11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT4 #(
    .INIT(16'hEBBB)) 
    \out_rank_q[2]_i_12 
       (.I0(out_addr_OBUF[3]),
        .I1(rank[2]),
        .I2(rank[1]),
        .I3(rank[0]),
        .O(\out_rank_q[2]_i_12_n_0 ));
  LUT5 #(
    .INIT(32'h0000EEFE)) 
    \out_rank_q[2]_i_2 
       (.I0(accepted_pending_rank[7]),
        .I1(pending_rank_q[6]),
        .I2(req_sync_q[5]),
        .I3(ack_rank_q[6]),
        .I4(\out_rank_q[2]_i_6_n_0 ),
        .O(\out_rank_q[2]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hBFFFBFBFBAFFAAAA)) 
    \out_rank_q[2]_i_3 
       (.I0(\out_rank_q[2]_i_7_n_0 ),
        .I1(\iprra_selector.selector/(null)[0].rs051_in ),
        .I2(\out_rank_q[2]_i_9_n_0 ),
        .I3(\out_rank_q[3]_i_20_n_0 ),
        .I4(\out_rank_q[3]_i_19_n_0 ),
        .I5(\out_rank_q[2]_i_10_n_0 ),
        .O(\out_rank_q[2]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'hF4)) 
    \out_rank_q[2]_i_4 
       (.I0(ack_rank_q[4]),
        .I1(req_sync_q[6]),
        .I2(pending_rank_q[4]),
        .O(accepted_pending_rank[4]));
  LUT3 #(
    .INIT(8'hF4)) 
    \out_rank_q[2]_i_5 
       (.I0(ack_rank_q[5]),
        .I1(req_sync_q[7]),
        .I2(pending_rank_q[5]),
        .O(accepted_pending_rank[5]));
  LUT6 #(
    .INIT(64'hBFFFBFBFBAFFAAAA)) 
    \out_rank_q[2]_i_6 
       (.I0(\out_rank_q[2]_i_11_n_0 ),
        .I1(\iprra_selector.selector/(null)[0].rs051_in ),
        .I2(\out_rank_q[2]_i_9_n_0 ),
        .I3(\out_rank_q[3]_i_20_n_0 ),
        .I4(\out_rank_q[3]_i_19_n_0 ),
        .I5(\out_rank_q[2]_i_10_n_0 ),
        .O(\out_rank_q[2]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h022002200222EFFE)) 
    \out_rank_q[2]_i_7 
       (.I0(\iprra_selector.selector/(null)[0].rs093_in ),
        .I1(\out_rank_q[2]_i_12_n_0 ),
        .I2(rank[0]),
        .I3(rank[1]),
        .I4(accepted_pending_rank[4]),
        .I5(accepted_pending_rank[5]),
        .O(\out_rank_q[2]_i_7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \out_rank_q[2]_i_8 
       (.I0(\iprra_selector.selector/(null)[0].rs093_in ),
        .I1(\out_rank_q[0]_i_21_n_0 ),
        .O(\iprra_selector.selector/(null)[0].rs051_in ));
  LUT6 #(
    .INIT(64'h07080708FFFF0708)) 
    \out_rank_q[2]_i_9 
       (.I0(rank[1]),
        .I1(rank[0]),
        .I2(out_addr_OBUF[3]),
        .I3(rank[2]),
        .I4(\out_rank_q[1]_i_8_n_0 ),
        .I5(\iprra_selector.selector/(null)[0].rs0107_in ),
        .O(\out_rank_q[2]_i_9_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \out_rank_q[3]_i_1 
       (.I0(reset_release_q[1]),
        .O(\out_rank_q[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFBA)) 
    \out_rank_q[3]_i_10 
       (.I0(accepted_pending_rank[11]),
        .I1(ack_rank_q[10]),
        .I2(req_sync_q[15]),
        .I3(pending_rank_q[10]),
        .I4(accepted_pending_rank[9]),
        .I5(accepted_pending_rank[8]),
        .O(\out_rank_q[3]_i_10_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \out_rank_q[3]_i_11 
       (.I0(accepted_pending_rank[4]),
        .I1(accepted_pending_rank[5]),
        .I2(accepted_pending_rank[6]),
        .I3(accepted_pending_rank[7]),
        .I4(\out_rank_q[3]_i_24_n_0 ),
        .O(\out_rank_q[3]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hF7FF0000FFFFFFFF)) 
    \out_rank_q[3]_i_12 
       (.I0(rank[2]),
        .I1(out_addr_OBUF[3]),
        .I2(rank[0]),
        .I3(rank[1]),
        .I4(accepted_pending_rank[14]),
        .I5(accepted_pending_rank[15]),
        .O(\out_rank_q[3]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'h00800000FFFFFFFF)) 
    \out_rank_q[3]_i_13 
       (.I0(accepted_pending_rank[15]),
        .I1(rank[2]),
        .I2(out_addr_OBUF[3]),
        .I3(rank[0]),
        .I4(rank[1]),
        .I5(accepted_pending_rank[14]),
        .O(\out_rank_q[3]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hEFFFAAAAFFFFFFFF)) 
    \out_rank_q[3]_i_14 
       (.I0(\out_rank_q[3]_i_25_n_0 ),
        .I1(\iprra_selector.selector/(null)[0].rs051_in ),
        .I2(\out_rank_q[2]_i_9_n_0 ),
        .I3(\out_rank_q[3]_i_19_n_0 ),
        .I4(\out_rank_q[3]_i_20_n_0 ),
        .I5(\iprra_selector.selector/local_branch_return0__4 ),
        .O(\out_rank_q[3]_i_14_n_0 ));
  LUT6 #(
    .INIT(64'h00000080FFFFFFFF)) 
    \out_rank_q[3]_i_15 
       (.I0(accepted_pending_rank[13]),
        .I1(rank[2]),
        .I2(out_addr_OBUF[3]),
        .I3(rank[0]),
        .I4(rank[1]),
        .I5(accepted_pending_rank[12]),
        .O(\out_rank_q[3]_i_15_n_0 ));
  LUT6 #(
    .INIT(64'hEFFFAAAAFFFFFFFF)) 
    \out_rank_q[3]_i_16 
       (.I0(\out_rank_q[3]_i_27_n_0 ),
        .I1(\iprra_selector.selector/(null)[0].rs051_in ),
        .I2(\out_rank_q[2]_i_9_n_0 ),
        .I3(\out_rank_q[3]_i_19_n_0 ),
        .I4(\out_rank_q[3]_i_20_n_0 ),
        .I5(\iprra_selector.selector/local_branch_return0__4 ),
        .O(\out_rank_q[3]_i_16_n_0 ));
  LUT6 #(
    .INIT(64'hFFF70000FFFFFFFF)) 
    \out_rank_q[3]_i_17 
       (.I0(rank[2]),
        .I1(out_addr_OBUF[3]),
        .I2(rank[0]),
        .I3(rank[1]),
        .I4(accepted_pending_rank[12]),
        .I5(accepted_pending_rank[13]),
        .O(\out_rank_q[3]_i_17_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'hDDDDFDFF)) 
    \out_rank_q[3]_i_18 
       (.I0(\out_rank_q[0]_i_21_n_0 ),
        .I1(\iprra_selector.selector/(null)[0].rs093_in ),
        .I2(\iprra_selector.selector/(null)[0].rs0107_in ),
        .I3(\out_rank_q[1]_i_8_n_0 ),
        .I4(\iprra_selector.selector/(null)[0].rs152_in ),
        .O(\iprra_selector.selector/combine_state_return014_out ));
  LUT6 #(
    .INIT(64'hFF51FFFFFFFFFFFF)) 
    \out_rank_q[3]_i_19 
       (.I0(\iprra_selector.selector/(null)[0].rs1 ),
        .I1(\out_rank_q[0]_i_9_n_0 ),
        .I2(\iprra_selector.selector/(null)[0].rs079_in ),
        .I3(\iprra_selector.selector/combine_state_return079_out ),
        .I4(\out_rank_q[0]_i_12_n_0 ),
        .I5(\iprra_selector.selector/(null)[0].ls1224_in ),
        .O(\out_rank_q[3]_i_19_n_0 ));
  LUT3 #(
    .INIT(8'hD0)) 
    \out_rank_q[3]_i_2 
       (.I0(out_valid_q),
        .I1(out_ready_IBUF),
        .I2(grant_valid),
        .O(out_rank_d));
  LUT6 #(
    .INIT(64'h1111DDFD11111111)) 
    \out_rank_q[3]_i_20 
       (.I0(\iprra_selector.selector/(null)[0].ls1 ),
        .I1(\iprra_selector.selector/(null)[0].rs1 ),
        .I2(\out_rank_q[0]_i_9_n_0 ),
        .I3(\iprra_selector.selector/(null)[0].rs079_in ),
        .I4(\iprra_selector.selector/combine_state_return079_out ),
        .I5(\out_rank_q[0]_i_12_n_0 ),
        .O(\out_rank_q[3]_i_20_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \out_rank_q[3]_i_21 
       (.I0(\out_rank_q[0]_i_9_n_0 ),
        .I1(\iprra_selector.selector/(null)[0].rs079_in ),
        .O(\out_rank_q[3]_i_21_n_0 ));
  LUT6 #(
    .INIT(64'h44404444FF40FFFF)) 
    \out_rank_q[3]_i_22 
       (.I0(\iprra_selector.selector/combine_state_return079_out ),
        .I1(\out_rank_q[0]_i_12_n_0 ),
        .I2(\iprra_selector.selector/(null)[0].ls1 ),
        .I3(\iprra_selector.selector/(null)[0].rs079_in ),
        .I4(\out_rank_q[0]_i_9_n_0 ),
        .I5(\iprra_selector.selector/(null)[0].rs1 ),
        .O(\iprra_selector.selector/local_branch_return03_out ));
  LUT6 #(
    .INIT(64'hEEEEFEEEEEEFEEEE)) 
    \out_rank_q[3]_i_23 
       (.I0(accepted_pending_rank[9]),
        .I1(accepted_pending_rank[8]),
        .I2(rank[1]),
        .I3(rank[0]),
        .I4(out_addr_OBUF[3]),
        .I5(rank[2]),
        .O(\out_rank_q[3]_i_23_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFBA)) 
    \out_rank_q[3]_i_24 
       (.I0(accepted_pending_rank[3]),
        .I1(ack_rank_q[2]),
        .I2(req_sync_q[3]),
        .I3(pending_rank_q[2]),
        .I4(accepted_pending_rank[1]),
        .I5(accepted_pending_rank[0]),
        .O(\out_rank_q[3]_i_24_n_0 ));
  LUT6 #(
    .INIT(64'hFDDFFDDFFDDD1001)) 
    \out_rank_q[3]_i_25 
       (.I0(\iprra_selector.selector/combine_state_return079_out ),
        .I1(\out_rank_q[3]_i_36_n_0 ),
        .I2(rank[0]),
        .I3(rank[1]),
        .I4(accepted_pending_rank[12]),
        .I5(accepted_pending_rank[13]),
        .O(\out_rank_q[3]_i_25_n_0 ));
  LUT6 #(
    .INIT(64'hB0BBB0B0B0FFB0B0)) 
    \out_rank_q[3]_i_26 
       (.I0(\iprra_selector.selector/combine_state_return079_out ),
        .I1(\out_rank_q[0]_i_12_n_0 ),
        .I2(\iprra_selector.selector/(null)[0].rs1 ),
        .I3(\iprra_selector.selector/(null)[0].rs079_in ),
        .I4(\out_rank_q[0]_i_9_n_0 ),
        .I5(\iprra_selector.selector/(null)[0].ls1 ),
        .O(\iprra_selector.selector/local_branch_return0__4 ));
  LUT6 #(
    .INIT(64'h00280028002AFFBE)) 
    \out_rank_q[3]_i_27 
       (.I0(\iprra_selector.selector/combine_state_return079_out ),
        .I1(rank[1]),
        .I2(rank[0]),
        .I3(\out_rank_q[3]_i_36_n_0 ),
        .I4(accepted_pending_rank[12]),
        .I5(accepted_pending_rank[13]),
        .O(\out_rank_q[3]_i_27_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFDFF0000)) 
    \out_rank_q[3]_i_28 
       (.I0(rank[2]),
        .I1(out_addr_OBUF[3]),
        .I2(rank[0]),
        .I3(rank[1]),
        .I4(accepted_pending_rank[6]),
        .I5(accepted_pending_rank[7]),
        .O(\iprra_selector.selector/(null)[0].rs093_in ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFEFF0000)) 
    \out_rank_q[3]_i_29 
       (.I0(rank[2]),
        .I1(out_addr_OBUF[3]),
        .I2(rank[0]),
        .I3(rank[1]),
        .I4(accepted_pending_rank[2]),
        .I5(accepted_pending_rank[3]),
        .O(\iprra_selector.selector/(null)[0].rs0107_in ));
  LUT5 #(
    .INIT(32'hEFEFEFEE)) 
    \out_rank_q[3]_i_3 
       (.I0(\out_rank_q[3]_i_5_n_0 ),
        .I1(\out_rank_q[3]_i_6_n_0 ),
        .I2(\out_rank_q[3]_i_7_n_0 ),
        .I3(accepted_pending_rank[8]),
        .I4(accepted_pending_rank[9]),
        .O(selected_rank[3]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'h1222)) 
    \out_rank_q[3]_i_30 
       (.I0(rank[2]),
        .I1(out_addr_OBUF[3]),
        .I2(rank[0]),
        .I3(rank[1]),
        .O(\iprra_selector.selector/(null)[0].rs152_in ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT4 #(
    .INIT(16'h4888)) 
    \out_rank_q[3]_i_31 
       (.I0(rank[2]),
        .I1(out_addr_OBUF[3]),
        .I2(rank[0]),
        .I3(rank[1]),
        .O(\iprra_selector.selector/(null)[0].rs1 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFBFF0000)) 
    \out_rank_q[3]_i_32 
       (.I0(rank[2]),
        .I1(out_addr_OBUF[3]),
        .I2(rank[0]),
        .I3(rank[1]),
        .I4(accepted_pending_rank[10]),
        .I5(accepted_pending_rank[11]),
        .O(\iprra_selector.selector/(null)[0].rs079_in ));
  LUT6 #(
    .INIT(64'hFFFFFFFFF7FF0000)) 
    \out_rank_q[3]_i_33 
       (.I0(rank[2]),
        .I1(out_addr_OBUF[3]),
        .I2(rank[0]),
        .I3(rank[1]),
        .I4(accepted_pending_rank[14]),
        .I5(accepted_pending_rank[15]),
        .O(\iprra_selector.selector/combine_state_return079_out ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'h870F)) 
    \out_rank_q[3]_i_34 
       (.I0(rank[1]),
        .I1(rank[0]),
        .I2(out_addr_OBUF[3]),
        .I3(rank[2]),
        .O(\iprra_selector.selector/(null)[0].ls1224_in ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT4 #(
    .INIT(16'h2444)) 
    \out_rank_q[3]_i_35 
       (.I0(rank[2]),
        .I1(out_addr_OBUF[3]),
        .I2(rank[0]),
        .I3(rank[1]),
        .O(\iprra_selector.selector/(null)[0].ls1 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT4 #(
    .INIT(16'hD777)) 
    \out_rank_q[3]_i_36 
       (.I0(out_addr_OBUF[3]),
        .I1(rank[2]),
        .I2(rank[1]),
        .I3(rank[0]),
        .O(\out_rank_q[3]_i_36_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \out_rank_q[3]_i_4 
       (.I0(\out_rank_q[3]_i_10_n_0 ),
        .I1(accepted_pending_rank[15]),
        .I2(accepted_pending_rank[14]),
        .I3(accepted_pending_rank[13]),
        .I4(accepted_pending_rank[12]),
        .I5(\out_rank_q[3]_i_11_n_0 ),
        .O(grant_valid));
  LUT6 #(
    .INIT(64'h070707FF0707FFFF)) 
    \out_rank_q[3]_i_5 
       (.I0(\out_rank_q[3]_i_12_n_0 ),
        .I1(\out_rank_q[3]_i_13_n_0 ),
        .I2(\out_rank_q[3]_i_14_n_0 ),
        .I3(\out_rank_q[3]_i_15_n_0 ),
        .I4(\out_rank_q[3]_i_16_n_0 ),
        .I5(\out_rank_q[3]_i_17_n_0 ),
        .O(\out_rank_q[3]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'h0000EEFE)) 
    \out_rank_q[3]_i_6 
       (.I0(accepted_pending_rank[11]),
        .I1(pending_rank_q[10]),
        .I2(req_sync_q[15]),
        .I3(ack_rank_q[10]),
        .I4(\out_rank_q[0]_i_3_n_0 ),
        .O(\out_rank_q[3]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hFFB0FFFFFFFFFFFF)) 
    \out_rank_q[3]_i_7 
       (.I0(\iprra_selector.selector/combine_state_return014_out ),
        .I1(\out_rank_q[3]_i_19_n_0 ),
        .I2(\out_rank_q[3]_i_20_n_0 ),
        .I3(\out_rank_q[3]_i_21_n_0 ),
        .I4(\iprra_selector.selector/local_branch_return03_out ),
        .I5(\out_rank_q[3]_i_23_n_0 ),
        .O(\out_rank_q[3]_i_7_n_0 ));
  LUT3 #(
    .INIT(8'hF4)) 
    \out_rank_q[3]_i_8 
       (.I0(ack_rank_q[8]),
        .I1(req_sync_q[12]),
        .I2(pending_rank_q[8]),
        .O(accepted_pending_rank[8]));
  LUT3 #(
    .INIT(8'hF4)) 
    \out_rank_q[3]_i_9 
       (.I0(ack_rank_q[9]),
        .I1(req_sync_q[13]),
        .I2(pending_rank_q[9]),
        .O(accepted_pending_rank[9]));
  FDSE \out_rank_q_reg[0] 
       (.C(CLK),
        .CE(out_rank_d),
        .D(selected_rank[0]),
        .Q(rank[0]),
        .S(\out_rank_q[3]_i_1_n_0 ));
  FDSE \out_rank_q_reg[1] 
       (.C(CLK),
        .CE(out_rank_d),
        .D(selected_rank[1]),
        .Q(rank[1]),
        .S(\out_rank_q[3]_i_1_n_0 ));
  FDSE \out_rank_q_reg[2] 
       (.C(CLK),
        .CE(out_rank_d),
        .D(selected_rank[2]),
        .Q(rank[2]),
        .S(\out_rank_q[3]_i_1_n_0 ));
  FDSE \out_rank_q_reg[3] 
       (.C(CLK),
        .CE(out_rank_d),
        .D(selected_rank[3]),
        .Q(out_addr_OBUF[3]),
        .S(\out_rank_q[3]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    out_valid_OBUF_inst_i_1
       (.I0(out_valid_q),
        .I1(reset_release_q[1]),
        .O(out_valid_OBUF));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT3 #(
    .INIT(8'hBA)) 
    out_valid_q_i_1
       (.I0(grant_valid),
        .I1(out_ready_IBUF),
        .I2(out_valid_q),
        .O(out_valid_q_i_1_n_0));
  FDRE out_valid_q_reg
       (.C(CLK),
        .CE(1'b1),
        .D(out_valid_q_i_1_n_0),
        .Q(out_valid_q),
        .R(\out_rank_q[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFEFFFFFF00000000)) 
    \pending_rank_q[0]_i_1 
       (.I0(\pending_rank_q[3]_i_2_n_0 ),
        .I1(selected_rank[1]),
        .I2(selected_rank[0]),
        .I3(grant_valid),
        .I4(can_load_output),
        .I5(accepted_pending_rank[0]),
        .O(pending_rank_d[0]));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_rank_q[0]_i_2 
       (.I0(ack_rank_q[0]),
        .I1(req_sync_q[0]),
        .I2(pending_rank_q[0]),
        .O(accepted_pending_rank[0]));
  LUT6 #(
    .INIT(64'hFBFFFFFF00000000)) 
    \pending_rank_q[10]_i_1 
       (.I0(\pending_rank_q[11]_i_2_n_0 ),
        .I1(selected_rank[1]),
        .I2(selected_rank[0]),
        .I3(grant_valid),
        .I4(can_load_output),
        .I5(accepted_pending_rank[10]),
        .O(pending_rank_d[10]));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_rank_q[10]_i_2 
       (.I0(ack_rank_q[10]),
        .I1(req_sync_q[15]),
        .I2(pending_rank_q[10]),
        .O(accepted_pending_rank[10]));
  LUT6 #(
    .INIT(64'hBFFFFFFF00000000)) 
    \pending_rank_q[11]_i_1 
       (.I0(\pending_rank_q[11]_i_2_n_0 ),
        .I1(selected_rank[0]),
        .I2(selected_rank[1]),
        .I3(grant_valid),
        .I4(can_load_output),
        .I5(accepted_pending_rank[11]),
        .O(pending_rank_d[11]));
  LUT6 #(
    .INIT(64'hFFFFFFFFEEEEEEEF)) 
    \pending_rank_q[11]_i_2 
       (.I0(\pending_rank_q[15]_i_7_n_0 ),
        .I1(\pending_rank_q[15]_i_8_n_0 ),
        .I2(\pending_rank_q[15]_i_5_n_0 ),
        .I3(\out_rank_q[3]_i_6_n_0 ),
        .I4(\pending_rank_q[15]_i_6_n_0 ),
        .I5(\out_rank_q[3]_i_5_n_0 ),
        .O(\pending_rank_q[11]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_rank_q[11]_i_3 
       (.I0(ack_rank_q[11]),
        .I1(req_sync_q[14]),
        .I2(pending_rank_q[11]),
        .O(accepted_pending_rank[11]));
  LUT6 #(
    .INIT(64'hFEFFFFFF00000000)) 
    \pending_rank_q[12]_i_1 
       (.I0(\pending_rank_q[15]_i_2_n_0 ),
        .I1(selected_rank[1]),
        .I2(selected_rank[0]),
        .I3(grant_valid),
        .I4(can_load_output),
        .I5(accepted_pending_rank[12]),
        .O(pending_rank_d[12]));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_rank_q[12]_i_2 
       (.I0(ack_rank_q[12]),
        .I1(req_sync_q[10]),
        .I2(pending_rank_q[12]),
        .O(accepted_pending_rank[12]));
  LUT6 #(
    .INIT(64'hFBFFFFFF00000000)) 
    \pending_rank_q[13]_i_1 
       (.I0(\pending_rank_q[15]_i_2_n_0 ),
        .I1(selected_rank[0]),
        .I2(selected_rank[1]),
        .I3(grant_valid),
        .I4(can_load_output),
        .I5(accepted_pending_rank[13]),
        .O(pending_rank_d[13]));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_rank_q[13]_i_2 
       (.I0(ack_rank_q[13]),
        .I1(req_sync_q[11]),
        .I2(pending_rank_q[13]),
        .O(accepted_pending_rank[13]));
  LUT6 #(
    .INIT(64'hFBFFFFFF00000000)) 
    \pending_rank_q[14]_i_1 
       (.I0(\pending_rank_q[15]_i_2_n_0 ),
        .I1(selected_rank[1]),
        .I2(selected_rank[0]),
        .I3(grant_valid),
        .I4(can_load_output),
        .I5(accepted_pending_rank[14]),
        .O(pending_rank_d[14]));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_rank_q[14]_i_2 
       (.I0(ack_rank_q[14]),
        .I1(req_sync_q[9]),
        .I2(pending_rank_q[14]),
        .O(accepted_pending_rank[14]));
  LUT6 #(
    .INIT(64'hBFFFFFFF00000000)) 
    \pending_rank_q[15]_i_1 
       (.I0(\pending_rank_q[15]_i_2_n_0 ),
        .I1(selected_rank[0]),
        .I2(selected_rank[1]),
        .I3(grant_valid),
        .I4(can_load_output),
        .I5(accepted_pending_rank[15]),
        .O(pending_rank_d[15]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT4 #(
    .INIT(16'h0002)) 
    \pending_rank_q[15]_i_10 
       (.I0(rank[2]),
        .I1(out_addr_OBUF[3]),
        .I2(rank[0]),
        .I3(rank[1]),
        .O(p_0_in[5]));
  LUT6 #(
    .INIT(64'h00000000010101FF)) 
    \pending_rank_q[15]_i_2 
       (.I0(\pending_rank_q[15]_i_5_n_0 ),
        .I1(\out_rank_q[3]_i_6_n_0 ),
        .I2(\pending_rank_q[15]_i_6_n_0 ),
        .I3(\pending_rank_q[15]_i_7_n_0 ),
        .I4(\pending_rank_q[15]_i_8_n_0 ),
        .I5(\out_rank_q[3]_i_5_n_0 ),
        .O(\pending_rank_q[15]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \pending_rank_q[15]_i_3 
       (.I0(out_ready_IBUF),
        .I1(out_valid_q),
        .O(can_load_output));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_rank_q[15]_i_4 
       (.I0(ack_rank_q[15]),
        .I1(req_sync_q[8]),
        .I2(pending_rank_q[15]),
        .O(accepted_pending_rank[15]));
  LUT6 #(
    .INIT(64'h0000551055105510)) 
    \pending_rank_q[15]_i_5 
       (.I0(\out_rank_q[3]_i_7_n_0 ),
        .I1(ack_rank_q[8]),
        .I2(req_sync_q[12]),
        .I3(pending_rank_q[8]),
        .I4(p_0_in[9]),
        .I5(accepted_pending_rank[9]),
        .O(\pending_rank_q[15]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h00000000AAAA2202)) 
    \pending_rank_q[15]_i_6 
       (.I0(accepted_pending_rank[9]),
        .I1(pending_rank_q[8]),
        .I2(req_sync_q[12]),
        .I3(ack_rank_q[8]),
        .I4(p_0_in[9]),
        .I5(\out_rank_q[3]_i_7_n_0 ),
        .O(\pending_rank_q[15]_i_6_n_0 ));
  LUT5 #(
    .INIT(32'h1F1F1F11)) 
    \pending_rank_q[15]_i_7 
       (.I0(\pending_rank_q[15]_i_9_n_0 ),
        .I1(\out_rank_q[2]_i_3_n_0 ),
        .I2(\out_rank_q[2]_i_6_n_0 ),
        .I3(accepted_pending_rank[6]),
        .I4(accepted_pending_rank[7]),
        .O(\pending_rank_q[15]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h00000000AAAA2202)) 
    \pending_rank_q[15]_i_8 
       (.I0(accepted_pending_rank[5]),
        .I1(pending_rank_q[4]),
        .I2(req_sync_q[6]),
        .I3(ack_rank_q[4]),
        .I4(p_0_in[5]),
        .I5(\out_rank_q[2]_i_3_n_0 ),
        .O(\pending_rank_q[15]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'h00000008FFFFFFFF)) 
    \pending_rank_q[15]_i_9 
       (.I0(accepted_pending_rank[5]),
        .I1(rank[2]),
        .I2(out_addr_OBUF[3]),
        .I3(rank[0]),
        .I4(rank[1]),
        .I5(accepted_pending_rank[4]),
        .O(\pending_rank_q[15]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hFBFFFFFF00000000)) 
    \pending_rank_q[1]_i_1 
       (.I0(\pending_rank_q[3]_i_2_n_0 ),
        .I1(selected_rank[0]),
        .I2(selected_rank[1]),
        .I3(grant_valid),
        .I4(can_load_output),
        .I5(accepted_pending_rank[1]),
        .O(pending_rank_d[1]));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_rank_q[1]_i_2 
       (.I0(ack_rank_q[1]),
        .I1(req_sync_q[1]),
        .I2(pending_rank_q[1]),
        .O(accepted_pending_rank[1]));
  LUT6 #(
    .INIT(64'hFBFFFFFF00000000)) 
    \pending_rank_q[2]_i_1 
       (.I0(\pending_rank_q[3]_i_2_n_0 ),
        .I1(selected_rank[1]),
        .I2(selected_rank[0]),
        .I3(grant_valid),
        .I4(can_load_output),
        .I5(accepted_pending_rank[2]),
        .O(pending_rank_d[2]));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_rank_q[2]_i_2 
       (.I0(ack_rank_q[2]),
        .I1(req_sync_q[3]),
        .I2(pending_rank_q[2]),
        .O(accepted_pending_rank[2]));
  LUT6 #(
    .INIT(64'hBFFFFFFF00000000)) 
    \pending_rank_q[3]_i_1 
       (.I0(\pending_rank_q[3]_i_2_n_0 ),
        .I1(selected_rank[0]),
        .I2(selected_rank[1]),
        .I3(grant_valid),
        .I4(can_load_output),
        .I5(accepted_pending_rank[3]),
        .O(pending_rank_d[3]));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \pending_rank_q[3]_i_2 
       (.I0(\pending_rank_q[15]_i_7_n_0 ),
        .I1(\pending_rank_q[15]_i_8_n_0 ),
        .I2(\pending_rank_q[15]_i_5_n_0 ),
        .I3(\out_rank_q[3]_i_6_n_0 ),
        .I4(\pending_rank_q[15]_i_6_n_0 ),
        .I5(\out_rank_q[3]_i_5_n_0 ),
        .O(\pending_rank_q[3]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_rank_q[3]_i_3 
       (.I0(ack_rank_q[3]),
        .I1(req_sync_q[2]),
        .I2(pending_rank_q[3]),
        .O(accepted_pending_rank[3]));
  LUT6 #(
    .INIT(64'hFEFFFFFF00000000)) 
    \pending_rank_q[4]_i_1 
       (.I0(\pending_rank_q[7]_i_2_n_0 ),
        .I1(selected_rank[1]),
        .I2(selected_rank[0]),
        .I3(grant_valid),
        .I4(can_load_output),
        .I5(accepted_pending_rank[4]),
        .O(pending_rank_d[4]));
  LUT6 #(
    .INIT(64'hFBFFFFFF00000000)) 
    \pending_rank_q[5]_i_1 
       (.I0(\pending_rank_q[7]_i_2_n_0 ),
        .I1(selected_rank[0]),
        .I2(selected_rank[1]),
        .I3(grant_valid),
        .I4(can_load_output),
        .I5(accepted_pending_rank[5]),
        .O(pending_rank_d[5]));
  LUT6 #(
    .INIT(64'hFBFFFFFF00000000)) 
    \pending_rank_q[6]_i_1 
       (.I0(\pending_rank_q[7]_i_2_n_0 ),
        .I1(selected_rank[1]),
        .I2(selected_rank[0]),
        .I3(grant_valid),
        .I4(can_load_output),
        .I5(accepted_pending_rank[6]),
        .O(pending_rank_d[6]));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_rank_q[6]_i_2 
       (.I0(ack_rank_q[6]),
        .I1(req_sync_q[5]),
        .I2(pending_rank_q[6]),
        .O(accepted_pending_rank[6]));
  LUT6 #(
    .INIT(64'hBFFFFFFF00000000)) 
    \pending_rank_q[7]_i_1 
       (.I0(\pending_rank_q[7]_i_2_n_0 ),
        .I1(selected_rank[0]),
        .I2(selected_rank[1]),
        .I3(grant_valid),
        .I4(can_load_output),
        .I5(accepted_pending_rank[7]),
        .O(pending_rank_d[7]));
  LUT6 #(
    .INIT(64'hFFFFFFFFFEFEFEFF)) 
    \pending_rank_q[7]_i_2 
       (.I0(\pending_rank_q[15]_i_5_n_0 ),
        .I1(\out_rank_q[3]_i_6_n_0 ),
        .I2(\pending_rank_q[15]_i_6_n_0 ),
        .I3(\pending_rank_q[15]_i_7_n_0 ),
        .I4(\pending_rank_q[15]_i_8_n_0 ),
        .I5(\out_rank_q[3]_i_5_n_0 ),
        .O(\pending_rank_q[7]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_rank_q[7]_i_3 
       (.I0(ack_rank_q[7]),
        .I1(req_sync_q[4]),
        .I2(pending_rank_q[7]),
        .O(accepted_pending_rank[7]));
  LUT6 #(
    .INIT(64'hFEFFFFFF00000000)) 
    \pending_rank_q[8]_i_1 
       (.I0(\pending_rank_q[11]_i_2_n_0 ),
        .I1(selected_rank[1]),
        .I2(selected_rank[0]),
        .I3(grant_valid),
        .I4(can_load_output),
        .I5(accepted_pending_rank[8]),
        .O(pending_rank_d[8]));
  LUT6 #(
    .INIT(64'hFBFFFFFF00000000)) 
    \pending_rank_q[9]_i_1 
       (.I0(\pending_rank_q[11]_i_2_n_0 ),
        .I1(selected_rank[0]),
        .I2(selected_rank[1]),
        .I3(grant_valid),
        .I4(can_load_output),
        .I5(accepted_pending_rank[9]),
        .O(pending_rank_d[9]));
  FDRE \pending_rank_q_reg[0] 
       (.C(CLK),
        .CE(1'b1),
        .D(pending_rank_d[0]),
        .Q(pending_rank_q[0]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \pending_rank_q_reg[10] 
       (.C(CLK),
        .CE(1'b1),
        .D(pending_rank_d[10]),
        .Q(pending_rank_q[10]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \pending_rank_q_reg[11] 
       (.C(CLK),
        .CE(1'b1),
        .D(pending_rank_d[11]),
        .Q(pending_rank_q[11]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \pending_rank_q_reg[12] 
       (.C(CLK),
        .CE(1'b1),
        .D(pending_rank_d[12]),
        .Q(pending_rank_q[12]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \pending_rank_q_reg[13] 
       (.C(CLK),
        .CE(1'b1),
        .D(pending_rank_d[13]),
        .Q(pending_rank_q[13]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \pending_rank_q_reg[14] 
       (.C(CLK),
        .CE(1'b1),
        .D(pending_rank_d[14]),
        .Q(pending_rank_q[14]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \pending_rank_q_reg[15] 
       (.C(CLK),
        .CE(1'b1),
        .D(pending_rank_d[15]),
        .Q(pending_rank_q[15]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \pending_rank_q_reg[1] 
       (.C(CLK),
        .CE(1'b1),
        .D(pending_rank_d[1]),
        .Q(pending_rank_q[1]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \pending_rank_q_reg[2] 
       (.C(CLK),
        .CE(1'b1),
        .D(pending_rank_d[2]),
        .Q(pending_rank_q[2]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \pending_rank_q_reg[3] 
       (.C(CLK),
        .CE(1'b1),
        .D(pending_rank_d[3]),
        .Q(pending_rank_q[3]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \pending_rank_q_reg[4] 
       (.C(CLK),
        .CE(1'b1),
        .D(pending_rank_d[4]),
        .Q(pending_rank_q[4]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \pending_rank_q_reg[5] 
       (.C(CLK),
        .CE(1'b1),
        .D(pending_rank_d[5]),
        .Q(pending_rank_q[5]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \pending_rank_q_reg[6] 
       (.C(CLK),
        .CE(1'b1),
        .D(pending_rank_d[6]),
        .Q(pending_rank_q[6]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \pending_rank_q_reg[7] 
       (.C(CLK),
        .CE(1'b1),
        .D(pending_rank_d[7]),
        .Q(pending_rank_q[7]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \pending_rank_q_reg[8] 
       (.C(CLK),
        .CE(1'b1),
        .D(pending_rank_d[8]),
        .Q(pending_rank_q[8]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \pending_rank_q_reg[9] 
       (.C(CLK),
        .CE(1'b1),
        .D(pending_rank_d[9]),
        .Q(pending_rank_q[9]),
        .R(\out_rank_q[3]_i_1_n_0 ));
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
       (.I0(ack_rank_q[0]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[0]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[10]_inst_i_1 
       (.I0(ack_rank_q[12]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[10]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[11]_inst_i_1 
       (.I0(ack_rank_q[13]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[11]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[12]_inst_i_1 
       (.I0(ack_rank_q[8]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[12]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[13]_inst_i_1 
       (.I0(ack_rank_q[9]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[13]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[14]_inst_i_1 
       (.I0(ack_rank_q[11]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[14]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[15]_inst_i_1 
       (.I0(ack_rank_q[10]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[15]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[1]_inst_i_1 
       (.I0(ack_rank_q[1]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[1]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[2]_inst_i_1 
       (.I0(ack_rank_q[3]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[2]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[3]_inst_i_1 
       (.I0(ack_rank_q[2]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[3]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[4]_inst_i_1 
       (.I0(ack_rank_q[7]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[4]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[5]_inst_i_1 
       (.I0(ack_rank_q[6]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[5]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[6]_inst_i_1 
       (.I0(ack_rank_q[4]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[6]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[7]_inst_i_1 
       (.I0(ack_rank_q[5]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[7]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[8]_inst_i_1 
       (.I0(ack_rank_q[15]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[8]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[9]_inst_i_1 
       (.I0(ack_rank_q[14]),
        .I1(reset_release_q[1]),
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
