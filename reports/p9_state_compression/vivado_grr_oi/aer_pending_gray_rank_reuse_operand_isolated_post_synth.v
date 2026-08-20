// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Fri Aug 21 04:07:19 2026
// Host        : <LOCAL_HOST> running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               reports/p9_state_compression/vivado_grr_oi/aer_pending_gray_rank_reuse_operand_isolated_post_synth.v
// Design      : aer_pending_gray_rank_reuse_operand_isolated
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* NETLIST_CHECKSUM = "b4412de0" *) 
(* NotValidForBitStream *)
module aer_pending_gray_rank_reuse_operand_isolated
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

  wire [15:0]accepted_pending_rank;
  wire [15:0]ack_rank_d;
  wire [15:0]ack_rank_q;
  wire can_load_output;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire [2:2]fp4_return;
  wire grant_valid;
  wire [3:0]out_addr;
  wire [3:0]out_addr_OBUF;
  wire out_rank_d;
  wire [2:0]out_rank_q;
  wire \out_rank_q[0]_i_2_n_0 ;
  wire \out_rank_q[0]_i_3_n_0 ;
  wire \out_rank_q[0]_i_4_n_0 ;
  wire \out_rank_q[1]_i_10_n_0 ;
  wire \out_rank_q[1]_i_11_n_0 ;
  wire \out_rank_q[1]_i_12_n_0 ;
  wire \out_rank_q[1]_i_13_n_0 ;
  wire \out_rank_q[1]_i_3_n_0 ;
  wire \out_rank_q[1]_i_4_n_0 ;
  wire \out_rank_q[2]_i_2_n_0 ;
  wire \out_rank_q[3]_i_10_n_0 ;
  wire \out_rank_q[3]_i_13_n_0 ;
  wire \out_rank_q[3]_i_1_n_0 ;
  wire \out_rank_q[3]_i_6_n_0 ;
  wire \out_rank_q[3]_i_7_n_0 ;
  wire \out_rank_q[3]_i_8_n_0 ;
  wire \out_rank_q[3]_i_9_n_0 ;
  wire out_ready;
  wire out_ready_IBUF;
  wire out_valid;
  wire out_valid_OBUF;
  wire out_valid_q;
  wire out_valid_q_i_1_n_0;
  wire [15:0]pending_rank_d;
  wire [15:0]pending_rank_q;
  wire \pending_rank_q[11]_i_2_n_0 ;
  wire \pending_rank_q[15]_i_2_n_0 ;
  wire \pending_rank_q[3]_i_2_n_0 ;
  wire \pending_rank_q[7]_i_2_n_0 ;
  (* async_reg = "true" *) wire [15:0]req_meta_q;
  (* async_reg = "true" *) wire [15:0]req_sync_q;
  (* async_reg = "true" *) wire [1:0]reset_release_q;
  wire \reset_release_q[1]_i_1_n_0 ;
  wire rst_n;
  wire rst_n_IBUF;
  wire [14:1]scheduler_candidate;
  wire scheduler_enable;
  wire [3:0]selected_rank;
  wire [1:1]\selector/request ;
  wire [3:1]\selector/start_group_req__25 ;
  wire [15:0]src_ack_async;
  wire [15:0]src_ack_async_OBUF;
  wire [15:0]src_req_async;
  wire [15:0]src_req_async_IBUF;

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
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(ack_rank_d[0]),
        .Q(ack_rank_q[0]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \ack_rank_q_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(ack_rank_d[10]),
        .Q(ack_rank_q[10]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \ack_rank_q_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(ack_rank_d[11]),
        .Q(ack_rank_q[11]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \ack_rank_q_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(ack_rank_d[12]),
        .Q(ack_rank_q[12]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \ack_rank_q_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(ack_rank_d[13]),
        .Q(ack_rank_q[13]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \ack_rank_q_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(ack_rank_d[14]),
        .Q(ack_rank_q[14]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \ack_rank_q_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(ack_rank_d[15]),
        .Q(ack_rank_q[15]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \ack_rank_q_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(ack_rank_d[1]),
        .Q(ack_rank_q[1]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \ack_rank_q_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(ack_rank_d[2]),
        .Q(ack_rank_q[2]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \ack_rank_q_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(ack_rank_d[3]),
        .Q(ack_rank_q[3]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \ack_rank_q_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(ack_rank_d[4]),
        .Q(ack_rank_q[4]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \ack_rank_q_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(ack_rank_d[5]),
        .Q(ack_rank_q[5]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \ack_rank_q_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(ack_rank_d[6]),
        .Q(ack_rank_q[6]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \ack_rank_q_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(ack_rank_d[7]),
        .Q(ack_rank_q[7]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \ack_rank_q_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(ack_rank_d[8]),
        .Q(ack_rank_q[8]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \ack_rank_q_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(ack_rank_d[9]),
        .Q(ack_rank_q[9]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  BUFG clk_IBUF_BUFG_inst
       (.I(clk_IBUF),
        .O(clk_IBUF_BUFG));
  IBUF clk_IBUF_inst
       (.I(clk),
        .O(clk_IBUF));
  OBUF \out_addr_OBUF[0]_inst 
       (.I(out_addr_OBUF[0]),
        .O(out_addr[0]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \out_addr_OBUF[0]_inst_i_1 
       (.I0(out_rank_q[1]),
        .I1(out_rank_q[0]),
        .O(out_addr_OBUF[0]));
  OBUF \out_addr_OBUF[1]_inst 
       (.I(out_addr_OBUF[1]),
        .O(out_addr[1]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \out_addr_OBUF[1]_inst_i_1 
       (.I0(out_rank_q[2]),
        .I1(out_rank_q[1]),
        .O(out_addr_OBUF[1]));
  OBUF \out_addr_OBUF[2]_inst 
       (.I(out_addr_OBUF[2]),
        .O(out_addr[2]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \out_addr_OBUF[2]_inst_i_1 
       (.I0(out_addr_OBUF[3]),
        .I1(out_rank_q[2]),
        .O(out_addr_OBUF[2]));
  OBUF \out_addr_OBUF[3]_inst 
       (.I(out_addr_OBUF[3]),
        .O(out_addr[3]));
  LUT6 #(
    .INIT(64'hBBBBBBBB0F0F000F)) 
    \out_rank_q[0]_i_1 
       (.I0(\selector/request ),
        .I1(\out_rank_q[0]_i_2_n_0 ),
        .I2(\out_rank_q[1]_i_4_n_0 ),
        .I3(\out_rank_q[0]_i_3_n_0 ),
        .I4(\out_rank_q[1]_i_3_n_0 ),
        .I5(fp4_return),
        .O(selected_rank[0]));
  LUT6 #(
    .INIT(64'h00000000EAFAEAAA)) 
    \out_rank_q[0]_i_2 
       (.I0(\out_rank_q[0]_i_4_n_0 ),
        .I1(scheduler_candidate[14]),
        .I2(out_addr_OBUF[3]),
        .I3(out_rank_q[2]),
        .I4(scheduler_candidate[10]),
        .I5(out_rank_q[1]),
        .O(\out_rank_q[0]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFCCAAF000CCAAF0)) 
    \out_rank_q[0]_i_3 
       (.I0(scheduler_candidate[10]),
        .I1(scheduler_candidate[6]),
        .I2(scheduler_candidate[2]),
        .I3(\out_rank_q[3]_i_6_n_0 ),
        .I4(\out_rank_q[2]_i_2_n_0 ),
        .I5(scheduler_candidate[14]),
        .O(\out_rank_q[0]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'h0B080000)) 
    \out_rank_q[0]_i_4 
       (.I0(accepted_pending_rank[6]),
        .I1(out_rank_q[2]),
        .I2(out_addr_OBUF[3]),
        .I3(accepted_pending_rank[2]),
        .I4(scheduler_enable),
        .O(\out_rank_q[0]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAE00AEAE00000000)) 
    \out_rank_q[0]_i_5 
       (.I0(pending_rank_q[14]),
        .I1(req_sync_q[9]),
        .I2(ack_rank_q[14]),
        .I3(out_ready_IBUF),
        .I4(out_valid_q),
        .I5(reset_release_q[1]),
        .O(scheduler_candidate[14]));
  LUT6 #(
    .INIT(64'hAE00AEAE00000000)) 
    \out_rank_q[0]_i_6 
       (.I0(pending_rank_q[10]),
        .I1(req_sync_q[15]),
        .I2(ack_rank_q[10]),
        .I3(out_ready_IBUF),
        .I4(out_valid_q),
        .I5(reset_release_q[1]),
        .O(scheduler_candidate[10]));
  LUT6 #(
    .INIT(64'hAE00AEAE00000000)) 
    \out_rank_q[0]_i_7 
       (.I0(pending_rank_q[6]),
        .I1(req_sync_q[5]),
        .I2(ack_rank_q[6]),
        .I3(out_ready_IBUF),
        .I4(out_valid_q),
        .I5(reset_release_q[1]),
        .O(scheduler_candidate[6]));
  LUT6 #(
    .INIT(64'hAE00AEAE00000000)) 
    \out_rank_q[0]_i_8 
       (.I0(pending_rank_q[2]),
        .I1(req_sync_q[3]),
        .I2(ack_rank_q[2]),
        .I3(out_ready_IBUF),
        .I4(out_valid_q),
        .I5(reset_release_q[1]),
        .O(scheduler_candidate[2]));
  LUT4 #(
    .INIT(16'h5503)) 
    \out_rank_q[1]_i_1 
       (.I0(\selector/request ),
        .I1(\out_rank_q[1]_i_3_n_0 ),
        .I2(\out_rank_q[1]_i_4_n_0 ),
        .I3(fp4_return),
        .O(selected_rank[1]));
  LUT6 #(
    .INIT(64'hB000B000B0B0B000)) 
    \out_rank_q[1]_i_10 
       (.I0(out_ready_IBUF),
        .I1(out_valid_q),
        .I2(reset_release_q[1]),
        .I3(pending_rank_q[8]),
        .I4(req_sync_q[12]),
        .I5(ack_rank_q[8]),
        .O(\out_rank_q[1]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hB000B000B0B0B000)) 
    \out_rank_q[1]_i_11 
       (.I0(out_ready_IBUF),
        .I1(out_valid_q),
        .I2(reset_release_q[1]),
        .I3(pending_rank_q[4]),
        .I4(req_sync_q[6]),
        .I5(ack_rank_q[4]),
        .O(\out_rank_q[1]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hB000B000B0B0B000)) 
    \out_rank_q[1]_i_12 
       (.I0(out_ready_IBUF),
        .I1(out_valid_q),
        .I2(reset_release_q[1]),
        .I3(pending_rank_q[0]),
        .I4(req_sync_q[0]),
        .I5(ack_rank_q[0]),
        .O(\out_rank_q[1]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hB000B000B0B0B000)) 
    \out_rank_q[1]_i_13 
       (.I0(out_ready_IBUF),
        .I1(out_valid_q),
        .I2(reset_release_q[1]),
        .I3(pending_rank_q[12]),
        .I4(req_sync_q[10]),
        .I5(ack_rank_q[12]),
        .O(\out_rank_q[1]_i_13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \out_rank_q[1]_i_2 
       (.I0(out_rank_q[1]),
        .I1(out_rank_q[0]),
        .I2(\selector/start_group_req__25 [1]),
        .O(\selector/request ));
  LUT6 #(
    .INIT(64'hFFCCAAF000CCAAF0)) 
    \out_rank_q[1]_i_3 
       (.I0(scheduler_candidate[9]),
        .I1(scheduler_candidate[5]),
        .I2(scheduler_candidate[1]),
        .I3(\out_rank_q[3]_i_6_n_0 ),
        .I4(\out_rank_q[2]_i_2_n_0 ),
        .I5(scheduler_candidate[13]),
        .O(\out_rank_q[1]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFFCCAAF000CCAAF0)) 
    \out_rank_q[1]_i_4 
       (.I0(\out_rank_q[1]_i_10_n_0 ),
        .I1(\out_rank_q[1]_i_11_n_0 ),
        .I2(\out_rank_q[1]_i_12_n_0 ),
        .I3(\out_rank_q[3]_i_6_n_0 ),
        .I4(\out_rank_q[2]_i_2_n_0 ),
        .I5(\out_rank_q[1]_i_13_n_0 ),
        .O(\out_rank_q[1]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \out_rank_q[1]_i_5 
       (.I0(scheduler_candidate[9]),
        .I1(scheduler_candidate[13]),
        .I2(scheduler_candidate[1]),
        .I3(out_addr_OBUF[3]),
        .I4(out_rank_q[2]),
        .I5(scheduler_candidate[5]),
        .O(\selector/start_group_req__25 [1]));
  LUT6 #(
    .INIT(64'hAE00AEAE00000000)) 
    \out_rank_q[1]_i_6 
       (.I0(pending_rank_q[9]),
        .I1(req_sync_q[13]),
        .I2(ack_rank_q[9]),
        .I3(out_ready_IBUF),
        .I4(out_valid_q),
        .I5(reset_release_q[1]),
        .O(scheduler_candidate[9]));
  LUT6 #(
    .INIT(64'hAE00AEAE00000000)) 
    \out_rank_q[1]_i_7 
       (.I0(pending_rank_q[5]),
        .I1(req_sync_q[7]),
        .I2(ack_rank_q[5]),
        .I3(out_ready_IBUF),
        .I4(out_valid_q),
        .I5(reset_release_q[1]),
        .O(scheduler_candidate[5]));
  LUT6 #(
    .INIT(64'hAE00AEAE00000000)) 
    \out_rank_q[1]_i_8 
       (.I0(pending_rank_q[1]),
        .I1(req_sync_q[1]),
        .I2(ack_rank_q[1]),
        .I3(out_ready_IBUF),
        .I4(out_valid_q),
        .I5(reset_release_q[1]),
        .O(scheduler_candidate[1]));
  LUT6 #(
    .INIT(64'hAE00AEAE00000000)) 
    \out_rank_q[1]_i_9 
       (.I0(pending_rank_q[13]),
        .I1(req_sync_q[11]),
        .I2(ack_rank_q[13]),
        .I3(out_ready_IBUF),
        .I4(out_valid_q),
        .I5(reset_release_q[1]),
        .O(scheduler_candidate[13]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \out_rank_q[2]_i_1 
       (.I0(out_rank_q[2]),
        .I1(fp4_return),
        .I2(\out_rank_q[2]_i_2_n_0 ),
        .O(selected_rank[2]));
  LUT6 #(
    .INIT(64'h10BB1033F5FFB0B0)) 
    \out_rank_q[2]_i_2 
       (.I0(out_addr_OBUF[3]),
        .I1(\out_rank_q[3]_i_7_n_0 ),
        .I2(\out_rank_q[3]_i_8_n_0 ),
        .I3(\out_rank_q[3]_i_9_n_0 ),
        .I4(\out_rank_q[3]_i_10_n_0 ),
        .I5(out_rank_q[2]),
        .O(\out_rank_q[2]_i_2_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \out_rank_q[3]_i_1 
       (.I0(reset_release_q[1]),
        .O(\out_rank_q[3]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hFF00FE00)) 
    \out_rank_q[3]_i_10 
       (.I0(accepted_pending_rank[4]),
        .I1(accepted_pending_rank[7]),
        .I2(accepted_pending_rank[5]),
        .I3(scheduler_enable),
        .I4(accepted_pending_rank[6]),
        .O(\out_rank_q[3]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFA8002000)) 
    \out_rank_q[3]_i_11 
       (.I0(out_addr_OBUF[3]),
        .I1(out_rank_q[2]),
        .I2(accepted_pending_rank[11]),
        .I3(scheduler_enable),
        .I4(accepted_pending_rank[15]),
        .I5(\out_rank_q[3]_i_13_n_0 ),
        .O(\selector/start_group_req__25 [3]));
  LUT3 #(
    .INIT(8'hA2)) 
    \out_rank_q[3]_i_12 
       (.I0(reset_release_q[1]),
        .I1(out_valid_q),
        .I2(out_ready_IBUF),
        .O(scheduler_enable));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT5 #(
    .INIT(32'h008800C0)) 
    \out_rank_q[3]_i_13 
       (.I0(accepted_pending_rank[7]),
        .I1(scheduler_enable),
        .I2(accepted_pending_rank[3]),
        .I3(out_addr_OBUF[3]),
        .I4(out_rank_q[2]),
        .O(\out_rank_q[3]_i_13_n_0 ));
  LUT3 #(
    .INIT(8'hD0)) 
    \out_rank_q[3]_i_2 
       (.I0(out_valid_q),
        .I1(out_ready_IBUF),
        .I2(grant_valid),
        .O(out_rank_d));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \out_rank_q[3]_i_3 
       (.I0(out_addr_OBUF[3]),
        .I1(fp4_return),
        .I2(\out_rank_q[3]_i_6_n_0 ),
        .O(selected_rank[3]));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \out_rank_q[3]_i_4 
       (.I0(\out_rank_q[3]_i_7_n_0 ),
        .I1(\out_rank_q[3]_i_8_n_0 ),
        .I2(\out_rank_q[3]_i_9_n_0 ),
        .I3(\out_rank_q[3]_i_10_n_0 ),
        .O(grant_valid));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'hFFFFFF2A)) 
    \out_rank_q[3]_i_5 
       (.I0(\selector/start_group_req__25 [3]),
        .I1(out_rank_q[1]),
        .I2(out_rank_q[0]),
        .I3(\selector/request ),
        .I4(\out_rank_q[0]_i_2_n_0 ),
        .O(fp4_return));
  LUT6 #(
    .INIT(64'h000FAAAFEEEE00EE)) 
    \out_rank_q[3]_i_6 
       (.I0(\out_rank_q[3]_i_8_n_0 ),
        .I1(\out_rank_q[3]_i_7_n_0 ),
        .I2(\out_rank_q[3]_i_9_n_0 ),
        .I3(\out_rank_q[3]_i_10_n_0 ),
        .I4(out_rank_q[2]),
        .I5(out_addr_OBUF[3]),
        .O(\out_rank_q[3]_i_6_n_0 ));
  LUT5 #(
    .INIT(32'hFF00FE00)) 
    \out_rank_q[3]_i_7 
       (.I0(accepted_pending_rank[8]),
        .I1(accepted_pending_rank[11]),
        .I2(accepted_pending_rank[9]),
        .I3(scheduler_enable),
        .I4(accepted_pending_rank[10]),
        .O(\out_rank_q[3]_i_7_n_0 ));
  LUT5 #(
    .INIT(32'hFF00FE00)) 
    \out_rank_q[3]_i_8 
       (.I0(accepted_pending_rank[12]),
        .I1(accepted_pending_rank[15]),
        .I2(accepted_pending_rank[13]),
        .I3(scheduler_enable),
        .I4(accepted_pending_rank[14]),
        .O(\out_rank_q[3]_i_8_n_0 ));
  LUT5 #(
    .INIT(32'hFF00FE00)) 
    \out_rank_q[3]_i_9 
       (.I0(accepted_pending_rank[0]),
        .I1(accepted_pending_rank[3]),
        .I2(accepted_pending_rank[1]),
        .I3(scheduler_enable),
        .I4(accepted_pending_rank[2]),
        .O(\out_rank_q[3]_i_9_n_0 ));
  FDSE \out_rank_q_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(out_rank_d),
        .D(selected_rank[0]),
        .Q(out_rank_q[0]),
        .S(\out_rank_q[3]_i_1_n_0 ));
  FDSE \out_rank_q_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(out_rank_d),
        .D(selected_rank[1]),
        .Q(out_rank_q[1]),
        .S(\out_rank_q[3]_i_1_n_0 ));
  FDSE \out_rank_q_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(out_rank_d),
        .D(selected_rank[2]),
        .Q(out_rank_q[2]),
        .S(\out_rank_q[3]_i_1_n_0 ));
  FDSE \out_rank_q_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(out_rank_d),
        .D(selected_rank[3]),
        .Q(out_addr_OBUF[3]),
        .S(\out_rank_q[3]_i_1_n_0 ));
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
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT3 #(
    .INIT(8'hBA)) 
    out_valid_q_i_1
       (.I0(grant_valid),
        .I1(out_ready_IBUF),
        .I2(out_valid_q),
        .O(out_valid_q_i_1_n_0));
  FDRE out_valid_q_reg
       (.C(clk_IBUF_BUFG),
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
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'hCCAFFFAF)) 
    \pending_rank_q[11]_i_2 
       (.I0(\out_rank_q[2]_i_2_n_0 ),
        .I1(out_rank_q[2]),
        .I2(\out_rank_q[3]_i_6_n_0 ),
        .I3(fp4_return),
        .I4(out_addr_OBUF[3]),
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
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h335FFF5F)) 
    \pending_rank_q[15]_i_2 
       (.I0(\out_rank_q[3]_i_6_n_0 ),
        .I1(out_addr_OBUF[3]),
        .I2(\out_rank_q[2]_i_2_n_0 ),
        .I3(fp4_return),
        .I4(out_rank_q[2]),
        .O(\pending_rank_q[15]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
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
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'hFFFACCFA)) 
    \pending_rank_q[3]_i_2 
       (.I0(\out_rank_q[2]_i_2_n_0 ),
        .I1(out_rank_q[2]),
        .I2(\out_rank_q[3]_i_6_n_0 ),
        .I3(fp4_return),
        .I4(out_addr_OBUF[3]),
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
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_rank_q[4]_i_2 
       (.I0(ack_rank_q[4]),
        .I1(req_sync_q[6]),
        .I2(pending_rank_q[4]),
        .O(accepted_pending_rank[4]));
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
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_rank_q[5]_i_2 
       (.I0(ack_rank_q[5]),
        .I1(req_sync_q[7]),
        .I2(pending_rank_q[5]),
        .O(accepted_pending_rank[5]));
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
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'hCCAFFFAF)) 
    \pending_rank_q[7]_i_2 
       (.I0(\out_rank_q[3]_i_6_n_0 ),
        .I1(out_addr_OBUF[3]),
        .I2(\out_rank_q[2]_i_2_n_0 ),
        .I3(fp4_return),
        .I4(out_rank_q[2]),
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
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_rank_q[8]_i_2 
       (.I0(ack_rank_q[8]),
        .I1(req_sync_q[12]),
        .I2(pending_rank_q[8]),
        .O(accepted_pending_rank[8]));
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
  LUT3 #(
    .INIT(8'hF4)) 
    \pending_rank_q[9]_i_2 
       (.I0(ack_rank_q[9]),
        .I1(req_sync_q[13]),
        .I2(pending_rank_q[9]),
        .O(accepted_pending_rank[9]));
  FDRE \pending_rank_q_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(pending_rank_d[0]),
        .Q(pending_rank_q[0]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \pending_rank_q_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(pending_rank_d[10]),
        .Q(pending_rank_q[10]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \pending_rank_q_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(pending_rank_d[11]),
        .Q(pending_rank_q[11]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \pending_rank_q_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(pending_rank_d[12]),
        .Q(pending_rank_q[12]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \pending_rank_q_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(pending_rank_d[13]),
        .Q(pending_rank_q[13]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \pending_rank_q_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(pending_rank_d[14]),
        .Q(pending_rank_q[14]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \pending_rank_q_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(pending_rank_d[15]),
        .Q(pending_rank_q[15]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \pending_rank_q_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(pending_rank_d[1]),
        .Q(pending_rank_q[1]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \pending_rank_q_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(pending_rank_d[2]),
        .Q(pending_rank_q[2]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \pending_rank_q_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(pending_rank_d[3]),
        .Q(pending_rank_q[3]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \pending_rank_q_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(pending_rank_d[4]),
        .Q(pending_rank_q[4]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \pending_rank_q_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(pending_rank_d[5]),
        .Q(pending_rank_q[5]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \pending_rank_q_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(pending_rank_d[6]),
        .Q(pending_rank_q[6]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \pending_rank_q_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(pending_rank_d[7]),
        .Q(pending_rank_q[7]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \pending_rank_q_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(pending_rank_d[8]),
        .Q(pending_rank_q[8]),
        .R(\out_rank_q[3]_i_1_n_0 ));
  FDRE \pending_rank_q_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(pending_rank_d[9]),
        .Q(pending_rank_q[9]),
        .R(\out_rank_q[3]_i_1_n_0 ));
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
       (.I0(ack_rank_q[0]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[0]));
  OBUF \src_ack_async_OBUF[10]_inst 
       (.I(src_ack_async_OBUF[10]),
        .O(src_ack_async[10]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[10]_inst_i_1 
       (.I0(ack_rank_q[12]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[10]));
  OBUF \src_ack_async_OBUF[11]_inst 
       (.I(src_ack_async_OBUF[11]),
        .O(src_ack_async[11]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[11]_inst_i_1 
       (.I0(ack_rank_q[13]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[11]));
  OBUF \src_ack_async_OBUF[12]_inst 
       (.I(src_ack_async_OBUF[12]),
        .O(src_ack_async[12]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[12]_inst_i_1 
       (.I0(ack_rank_q[8]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[12]));
  OBUF \src_ack_async_OBUF[13]_inst 
       (.I(src_ack_async_OBUF[13]),
        .O(src_ack_async[13]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[13]_inst_i_1 
       (.I0(ack_rank_q[9]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[13]));
  OBUF \src_ack_async_OBUF[14]_inst 
       (.I(src_ack_async_OBUF[14]),
        .O(src_ack_async[14]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[14]_inst_i_1 
       (.I0(ack_rank_q[11]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[14]));
  OBUF \src_ack_async_OBUF[15]_inst 
       (.I(src_ack_async_OBUF[15]),
        .O(src_ack_async[15]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[15]_inst_i_1 
       (.I0(ack_rank_q[10]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[15]));
  OBUF \src_ack_async_OBUF[1]_inst 
       (.I(src_ack_async_OBUF[1]),
        .O(src_ack_async[1]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[1]_inst_i_1 
       (.I0(ack_rank_q[1]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[1]));
  OBUF \src_ack_async_OBUF[2]_inst 
       (.I(src_ack_async_OBUF[2]),
        .O(src_ack_async[2]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[2]_inst_i_1 
       (.I0(ack_rank_q[3]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[2]));
  OBUF \src_ack_async_OBUF[3]_inst 
       (.I(src_ack_async_OBUF[3]),
        .O(src_ack_async[3]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[3]_inst_i_1 
       (.I0(ack_rank_q[2]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[3]));
  OBUF \src_ack_async_OBUF[4]_inst 
       (.I(src_ack_async_OBUF[4]),
        .O(src_ack_async[4]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[4]_inst_i_1 
       (.I0(ack_rank_q[7]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[4]));
  OBUF \src_ack_async_OBUF[5]_inst 
       (.I(src_ack_async_OBUF[5]),
        .O(src_ack_async[5]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[5]_inst_i_1 
       (.I0(ack_rank_q[6]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[5]));
  OBUF \src_ack_async_OBUF[6]_inst 
       (.I(src_ack_async_OBUF[6]),
        .O(src_ack_async[6]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[6]_inst_i_1 
       (.I0(ack_rank_q[4]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[6]));
  OBUF \src_ack_async_OBUF[7]_inst 
       (.I(src_ack_async_OBUF[7]),
        .O(src_ack_async[7]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[7]_inst_i_1 
       (.I0(ack_rank_q[5]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[7]));
  OBUF \src_ack_async_OBUF[8]_inst 
       (.I(src_ack_async_OBUF[8]),
        .O(src_ack_async[8]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[8]_inst_i_1 
       (.I0(ack_rank_q[15]),
        .I1(reset_release_q[1]),
        .O(src_ack_async_OBUF[8]));
  OBUF \src_ack_async_OBUF[9]_inst 
       (.I(src_ack_async_OBUF[9]),
        .O(src_ack_async[9]));
  LUT2 #(
    .INIT(4'h8)) 
    \src_ack_async_OBUF[9]_inst_i_1 
       (.I0(ack_rank_q[14]),
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
