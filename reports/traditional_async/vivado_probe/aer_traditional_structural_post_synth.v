// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Wed Aug 19 03:17:19 2026
// Host        : DESKTOP-F81OJT8 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               reports/traditional_async/vivado_probe/aer_traditional_structural_post_synth.v
// Design      : aer_traditional_structural
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* dont_touch = "yes" *) (* keep_hierarchy = "yes" *) 
module aer_async_d_latch
   (d_i,
    enable_i,
    rst_n,
    q_o);
  input d_i;
  input enable_i;
  input rst_n;
  output q_o;

  wire d_i;
  wire enable_i;
  wire q_o;
  wire reset_i;
  wire rst_n;
  wire set_i;

  (* DONT_TOUCH *) 
  (* KEEP_HIERARCHY = "yes" *) 
  aer_async_sr_latch__1 storage
       (.q_o(q_o),
        .reset_i(reset_i),
        .rst_n(rst_n),
        .set_i(set_i));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h8)) 
    storage_i_1
       (.I0(enable_i),
        .I1(d_i),
        .O(set_i));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h2)) 
    storage_i_2
       (.I0(enable_i),
        .I1(d_i),
        .O(reset_i));
endmodule

(* ORIG_REF_NAME = "aer_async_d_latch" *) (* dont_touch = "yes" *) (* keep_hierarchy = "yes" *) 
module aer_async_d_latch__1
   (d_i,
    enable_i,
    rst_n,
    q_o);
  input d_i;
  input enable_i;
  input rst_n;
  output q_o;

  wire d_i;
  wire enable_i;
  wire q_o;
  wire reset_i;
  wire rst_n;
  wire set_i;

  (* DONT_TOUCH *) 
  (* KEEP_HIERARCHY = "yes" *) 
  aer_async_sr_latch__2 storage
       (.q_o(q_o),
        .reset_i(reset_i),
        .rst_n(rst_n),
        .set_i(set_i));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h8)) 
    storage_i_1
       (.I0(enable_i),
        .I1(d_i),
        .O(set_i));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h2)) 
    storage_i_2
       (.I0(enable_i),
        .I1(d_i),
        .O(reset_i));
endmodule

(* ORIG_REF_NAME = "aer_async_d_latch" *) (* dont_touch = "yes" *) (* keep_hierarchy = "yes" *) 
module aer_async_d_latch__2
   (d_i,
    enable_i,
    rst_n,
    q_o);
  input d_i;
  input enable_i;
  input rst_n;
  output q_o;

  wire d_i;
  wire enable_i;
  wire q_o;
  wire reset_i;
  wire rst_n;
  wire set_i;

  (* DONT_TOUCH *) 
  (* KEEP_HIERARCHY = "yes" *) 
  aer_async_sr_latch__3 storage
       (.q_o(q_o),
        .reset_i(reset_i),
        .rst_n(rst_n),
        .set_i(set_i));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h8)) 
    storage_i_1
       (.I0(enable_i),
        .I1(d_i),
        .O(set_i));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h2)) 
    storage_i_2
       (.I0(enable_i),
        .I1(d_i),
        .O(reset_i));
endmodule

(* ORIG_REF_NAME = "aer_async_d_latch" *) (* dont_touch = "yes" *) (* keep_hierarchy = "yes" *) 
module aer_async_d_latch__3
   (d_i,
    enable_i,
    rst_n,
    q_o);
  input d_i;
  input enable_i;
  input rst_n;
  output q_o;

  wire d_i;
  wire enable_i;
  wire q_o;
  wire reset_i;
  wire rst_n;
  wire set_i;

  (* DONT_TOUCH *) 
  (* KEEP_HIERARCHY = "yes" *) 
  aer_async_sr_latch__4 storage
       (.q_o(q_o),
        .reset_i(reset_i),
        .rst_n(rst_n),
        .set_i(set_i));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h8)) 
    storage_i_1
       (.I0(enable_i),
        .I1(d_i),
        .O(set_i));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h2)) 
    storage_i_2
       (.I0(enable_i),
        .I1(d_i),
        .O(reset_i));
endmodule

(* dont_touch = "yes" *) (* keep_hierarchy = "yes" *) 
module aer_async_sr_latch
   (set_i,
    reset_i,
    rst_n,
    q_o);
  input set_i;
  input reset_i;
  input rst_n;
  output q_o;

  (* RTL_KEEP = "true" *) wire q_n;
  wire q_o;
  wire reset_i;
  (* RTL_KEEP = "true" *) wire reset_safe;
  wire rst_n;
  wire set_i;
  (* RTL_KEEP = "true" *) wire set_safe;

  LUT3 #(
    .INIT(8'h54)) 
    q_n_inferred_i_1
       (.I0(set_safe),
        .I1(q_n),
        .I2(reset_safe),
        .O(q_n));
  LUT2 #(
    .INIT(4'h1)) 
    q_o_INST_0
       (.I0(reset_safe),
        .I1(q_n),
        .O(q_o));
  LUT2 #(
    .INIT(4'hB)) 
    reset_safe_inferred_i_1
       (.I0(reset_i),
        .I1(rst_n),
        .O(reset_safe));
  LUT2 #(
    .INIT(4'h8)) 
    set_safe_inferred_i_1
       (.I0(set_i),
        .I1(rst_n),
        .O(set_safe));
endmodule

(* ORIG_REF_NAME = "aer_async_sr_latch" *) (* dont_touch = "yes" *) (* keep_hierarchy = "yes" *) 
module aer_async_sr_latch__1
   (set_i,
    reset_i,
    rst_n,
    q_o);
  input set_i;
  input reset_i;
  input rst_n;
  output q_o;

  (* RTL_KEEP = "true" *) wire q_n;
  wire q_o;
  wire reset_i;
  (* RTL_KEEP = "true" *) wire reset_safe;
  wire rst_n;
  wire set_i;
  (* RTL_KEEP = "true" *) wire set_safe;

  LUT3 #(
    .INIT(8'h54)) 
    q_n_inferred_i_1
       (.I0(set_safe),
        .I1(q_n),
        .I2(reset_safe),
        .O(q_n));
  LUT2 #(
    .INIT(4'h1)) 
    q_o_INST_0
       (.I0(reset_safe),
        .I1(q_n),
        .O(q_o));
  LUT2 #(
    .INIT(4'hB)) 
    reset_safe_inferred_i_1
       (.I0(reset_i),
        .I1(rst_n),
        .O(reset_safe));
  LUT2 #(
    .INIT(4'h8)) 
    set_safe_inferred_i_1
       (.I0(set_i),
        .I1(rst_n),
        .O(set_safe));
endmodule

(* ORIG_REF_NAME = "aer_async_sr_latch" *) (* dont_touch = "yes" *) (* keep_hierarchy = "yes" *) 
module aer_async_sr_latch__2
   (set_i,
    reset_i,
    rst_n,
    q_o);
  input set_i;
  input reset_i;
  input rst_n;
  output q_o;

  (* RTL_KEEP = "true" *) wire q_n;
  wire q_o;
  wire reset_i;
  (* RTL_KEEP = "true" *) wire reset_safe;
  wire rst_n;
  wire set_i;
  (* RTL_KEEP = "true" *) wire set_safe;

  LUT3 #(
    .INIT(8'h54)) 
    q_n_inferred_i_1
       (.I0(set_safe),
        .I1(q_n),
        .I2(reset_safe),
        .O(q_n));
  LUT2 #(
    .INIT(4'h1)) 
    q_o_INST_0
       (.I0(reset_safe),
        .I1(q_n),
        .O(q_o));
  LUT2 #(
    .INIT(4'hB)) 
    reset_safe_inferred_i_1
       (.I0(reset_i),
        .I1(rst_n),
        .O(reset_safe));
  LUT2 #(
    .INIT(4'h8)) 
    set_safe_inferred_i_1
       (.I0(set_i),
        .I1(rst_n),
        .O(set_safe));
endmodule

(* ORIG_REF_NAME = "aer_async_sr_latch" *) (* dont_touch = "yes" *) (* keep_hierarchy = "yes" *) 
module aer_async_sr_latch__3
   (set_i,
    reset_i,
    rst_n,
    q_o);
  input set_i;
  input reset_i;
  input rst_n;
  output q_o;

  (* RTL_KEEP = "true" *) wire q_n;
  wire q_o;
  wire reset_i;
  (* RTL_KEEP = "true" *) wire reset_safe;
  wire rst_n;
  wire set_i;
  (* RTL_KEEP = "true" *) wire set_safe;

  LUT3 #(
    .INIT(8'h54)) 
    q_n_inferred_i_1
       (.I0(set_safe),
        .I1(q_n),
        .I2(reset_safe),
        .O(q_n));
  LUT2 #(
    .INIT(4'h1)) 
    q_o_INST_0
       (.I0(reset_safe),
        .I1(q_n),
        .O(q_o));
  LUT2 #(
    .INIT(4'hB)) 
    reset_safe_inferred_i_1
       (.I0(reset_i),
        .I1(rst_n),
        .O(reset_safe));
  LUT2 #(
    .INIT(4'h8)) 
    set_safe_inferred_i_1
       (.I0(set_i),
        .I1(rst_n),
        .O(set_safe));
endmodule

(* ORIG_REF_NAME = "aer_async_sr_latch" *) (* dont_touch = "yes" *) (* keep_hierarchy = "yes" *) 
module aer_async_sr_latch__4
   (set_i,
    reset_i,
    rst_n,
    q_o);
  input set_i;
  input reset_i;
  input rst_n;
  output q_o;

  (* RTL_KEEP = "true" *) wire q_n;
  wire q_o;
  wire reset_i;
  (* RTL_KEEP = "true" *) wire reset_safe;
  wire rst_n;
  wire set_i;
  (* RTL_KEEP = "true" *) wire set_safe;

  LUT3 #(
    .INIT(8'h54)) 
    q_n_inferred_i_1
       (.I0(set_safe),
        .I1(q_n),
        .I2(reset_safe),
        .O(q_n));
  LUT2 #(
    .INIT(4'h1)) 
    q_o_INST_0
       (.I0(reset_safe),
        .I1(q_n),
        .O(q_o));
  LUT2 #(
    .INIT(4'hB)) 
    reset_safe_inferred_i_1
       (.I0(reset_i),
        .I1(rst_n),
        .O(reset_safe));
  LUT2 #(
    .INIT(4'h8)) 
    set_safe_inferred_i_1
       (.I0(set_i),
        .I1(rst_n),
        .O(set_safe));
endmodule

(* ADDR_W = "4" *) (* IDX_W = "4" *) (* NUM_SOURCES = "16" *) 
(* NotValidForBitStream *)
module aer_traditional_structural
   (rst_n,
    src_req,
    src_ack,
    aer_addr,
    aer_req,
    aer_ack);
  input rst_n;
  input [15:0]src_req;
  output [15:0]src_ack;
  output [3:0]aer_addr;
  output aer_req;
  input aer_ack;

  wire aer_ack;
  wire aer_ack_IBUF;
  wire [3:0]aer_addr;
  wire [3:0]aer_addr_OBUF;
  wire aer_req;
  wire aer_req_OBUF;
  wire busy_q;
  wire capture_grant;
  wire \g_grant_latch[0].grant_latch_i_10_n_0 ;
  wire \g_grant_latch[0].grant_latch_i_11_n_0 ;
  wire \g_grant_latch[0].grant_latch_i_12_n_0 ;
  wire \g_grant_latch[0].grant_latch_i_1_n_0 ;
  wire \g_grant_latch[0].grant_latch_i_3_n_0 ;
  wire \g_grant_latch[0].grant_latch_i_4_n_0 ;
  wire \g_grant_latch[0].grant_latch_i_5_n_0 ;
  wire \g_grant_latch[0].grant_latch_i_6_n_0 ;
  wire \g_grant_latch[0].grant_latch_i_7_n_0 ;
  wire \g_grant_latch[0].grant_latch_i_8_n_0 ;
  wire \g_grant_latch[0].grant_latch_i_9_n_0 ;
  wire \g_grant_latch[1].grant_latch_i_1_n_0 ;
  wire \g_grant_latch[1].grant_latch_i_2_n_0 ;
  wire \g_grant_latch[1].grant_latch_i_3_n_0 ;
  wire \g_grant_latch[2].grant_latch_i_1_n_0 ;
  wire \g_grant_latch[2].grant_latch_i_2_n_0 ;
  wire \g_grant_latch[2].grant_latch_i_3_n_0 ;
  wire \g_grant_latch[3].grant_latch_i_1_n_0 ;
  wire \g_grant_latch[3].grant_latch_i_2_n_0 ;
  wire release_busy;
  wire rst_n;
  wire rst_n_IBUF;
  wire [15:0]src_ack;
  wire [15:0]src_ack_OBUF;
  wire \src_ack_OBUF[10]_inst_i_2_n_0 ;
  wire \src_ack_OBUF[12]_inst_i_2_n_0 ;
  wire \src_ack_OBUF[13]_inst_i_2_n_0 ;
  wire \src_ack_OBUF[14]_inst_i_2_n_0 ;
  wire \src_ack_OBUF[15]_inst_i_10_n_0 ;
  wire \src_ack_OBUF[15]_inst_i_11_n_0 ;
  wire \src_ack_OBUF[15]_inst_i_2_n_0 ;
  wire \src_ack_OBUF[15]_inst_i_3_n_0 ;
  wire \src_ack_OBUF[15]_inst_i_4_n_0 ;
  wire \src_ack_OBUF[15]_inst_i_5_n_0 ;
  wire \src_ack_OBUF[15]_inst_i_6_n_0 ;
  wire \src_ack_OBUF[15]_inst_i_7_n_0 ;
  wire \src_ack_OBUF[15]_inst_i_8_n_0 ;
  wire \src_ack_OBUF[15]_inst_i_9_n_0 ;
  wire \src_ack_OBUF[3]_inst_i_2_n_0 ;
  wire \src_ack_OBUF[6]_inst_i_2_n_0 ;
  wire [15:0]src_req;
  wire [15:0]src_req_IBUF;

  IBUF aer_ack_IBUF_inst
       (.I(aer_ack),
        .O(aer_ack_IBUF));
  OBUF \aer_addr_OBUF[0]_inst 
       (.I(aer_addr_OBUF[0]),
        .O(aer_addr[0]));
  OBUF \aer_addr_OBUF[1]_inst 
       (.I(aer_addr_OBUF[1]),
        .O(aer_addr[1]));
  OBUF \aer_addr_OBUF[2]_inst 
       (.I(aer_addr_OBUF[2]),
        .O(aer_addr[2]));
  OBUF \aer_addr_OBUF[3]_inst 
       (.I(aer_addr_OBUF[3]),
        .O(aer_addr[3]));
  OBUF aer_req_OBUF_inst
       (.I(aer_req_OBUF),
        .O(aer_req));
  LUT2 #(
    .INIT(4'h2)) 
    aer_req_OBUF_inst_i_1
       (.I0(busy_q),
        .I1(\src_ack_OBUF[15]_inst_i_3_n_0 ),
        .O(aer_req_OBUF));
  (* DONT_TOUCH *) 
  (* KEEP_HIERARCHY = "yes" *) 
  aer_async_sr_latch busy_latch
       (.q_o(busy_q),
        .reset_i(release_busy),
        .rst_n(rst_n_IBUF),
        .set_i(capture_grant));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'h08)) 
    busy_latch_i_1
       (.I0(\src_ack_OBUF[15]_inst_i_3_n_0 ),
        .I1(busy_q),
        .I2(aer_ack_IBUF),
        .O(release_busy));
  (* DONT_TOUCH *) 
  (* KEEP_HIERARCHY = "yes" *) 
  aer_async_d_latch__1 \g_grant_latch[0].grant_latch 
       (.d_i(\g_grant_latch[0].grant_latch_i_1_n_0 ),
        .enable_i(capture_grant),
        .q_o(aer_addr_OBUF[0]),
        .rst_n(rst_n_IBUF));
  LUT6 #(
    .INIT(64'hFFFF0000FFF4FFF4)) 
    \g_grant_latch[0].grant_latch_i_1 
       (.I0(\g_grant_latch[0].grant_latch_i_3_n_0 ),
        .I1(src_req_IBUF[9]),
        .I2(\g_grant_latch[0].grant_latch_i_4_n_0 ),
        .I3(\g_grant_latch[0].grant_latch_i_5_n_0 ),
        .I4(\g_grant_latch[0].grant_latch_i_6_n_0 ),
        .I5(\g_grant_latch[0].grant_latch_i_7_n_0 ),
        .O(\g_grant_latch[0].grant_latch_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h00000001)) 
    \g_grant_latch[0].grant_latch_i_10 
       (.I0(src_req_IBUF[9]),
        .I1(src_req_IBUF[7]),
        .I2(\g_grant_latch[0].grant_latch_i_12_n_0 ),
        .I3(\g_grant_latch[2].grant_latch_i_3_n_0 ),
        .I4(src_req_IBUF[8]),
        .O(\g_grant_latch[0].grant_latch_i_10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT4 #(
    .INIT(16'hFEFF)) 
    \g_grant_latch[0].grant_latch_i_11 
       (.I0(src_req_IBUF[12]),
        .I1(src_req_IBUF[13]),
        .I2(src_req_IBUF[14]),
        .I3(src_req_IBUF[15]),
        .O(\g_grant_latch[0].grant_latch_i_11_n_0 ));
  LUT3 #(
    .INIT(8'hFE)) 
    \g_grant_latch[0].grant_latch_i_12 
       (.I0(src_req_IBUF[6]),
        .I1(src_req_IBUF[5]),
        .I2(src_req_IBUF[4]),
        .O(\g_grant_latch[0].grant_latch_i_12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT4 #(
    .INIT(16'h0007)) 
    \g_grant_latch[0].grant_latch_i_2 
       (.I0(\g_grant_latch[0].grant_latch_i_8_n_0 ),
        .I1(\g_grant_latch[0].grant_latch_i_9_n_0 ),
        .I2(aer_ack_IBUF),
        .I3(busy_q),
        .O(capture_grant));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \g_grant_latch[0].grant_latch_i_3 
       (.I0(src_req_IBUF[8]),
        .I1(\g_grant_latch[2].grant_latch_i_3_n_0 ),
        .I2(src_req_IBUF[4]),
        .I3(src_req_IBUF[5]),
        .I4(src_req_IBUF[6]),
        .I5(src_req_IBUF[7]),
        .O(\g_grant_latch[0].grant_latch_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0F0F0F0F00000F02)) 
    \g_grant_latch[0].grant_latch_i_4 
       (.I0(src_req_IBUF[5]),
        .I1(src_req_IBUF[4]),
        .I2(src_req_IBUF[0]),
        .I3(src_req_IBUF[3]),
        .I4(src_req_IBUF[2]),
        .I5(src_req_IBUF[1]),
        .O(\g_grant_latch[0].grant_latch_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT5 #(
    .INIT(32'h00000002)) 
    \g_grant_latch[0].grant_latch_i_5 
       (.I0(src_req_IBUF[7]),
        .I1(src_req_IBUF[6]),
        .I2(src_req_IBUF[5]),
        .I3(src_req_IBUF[4]),
        .I4(\g_grant_latch[2].grant_latch_i_3_n_0 ),
        .O(\g_grant_latch[0].grant_latch_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h0000F0400000F0F0)) 
    \g_grant_latch[0].grant_latch_i_6 
       (.I0(src_req_IBUF[12]),
        .I1(src_req_IBUF[13]),
        .I2(\g_grant_latch[0].grant_latch_i_10_n_0 ),
        .I3(src_req_IBUF[11]),
        .I4(src_req_IBUF[10]),
        .I5(\g_grant_latch[0].grant_latch_i_11_n_0 ),
        .O(\g_grant_latch[0].grant_latch_i_6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT4 #(
    .INIT(16'hCCC4)) 
    \g_grant_latch[0].grant_latch_i_7 
       (.I0(\g_grant_latch[0].grant_latch_i_8_n_0 ),
        .I1(\g_grant_latch[0].grant_latch_i_10_n_0 ),
        .I2(src_req_IBUF[11]),
        .I3(src_req_IBUF[10]),
        .O(\g_grant_latch[0].grant_latch_i_7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT4 #(
    .INIT(16'h0001)) 
    \g_grant_latch[0].grant_latch_i_8 
       (.I0(src_req_IBUF[15]),
        .I1(src_req_IBUF[12]),
        .I2(src_req_IBUF[13]),
        .I3(src_req_IBUF[14]),
        .O(\g_grant_latch[0].grant_latch_i_8_n_0 ));
  LUT3 #(
    .INIT(8'h02)) 
    \g_grant_latch[0].grant_latch_i_9 
       (.I0(\g_grant_latch[0].grant_latch_i_10_n_0 ),
        .I1(src_req_IBUF[11]),
        .I2(src_req_IBUF[10]),
        .O(\g_grant_latch[0].grant_latch_i_9_n_0 ));
  (* DONT_TOUCH *) 
  (* KEEP_HIERARCHY = "yes" *) 
  aer_async_d_latch__2 \g_grant_latch[1].grant_latch 
       (.d_i(\g_grant_latch[1].grant_latch_i_1_n_0 ),
        .enable_i(capture_grant),
        .q_o(aer_addr_OBUF[1]),
        .rst_n(rst_n_IBUF));
  LUT6 #(
    .INIT(64'h000000FEFEFEFEFE)) 
    \g_grant_latch[1].grant_latch_i_1 
       (.I0(\g_grant_latch[0].grant_latch_i_5_n_0 ),
        .I1(\g_grant_latch[0].grant_latch_i_7_n_0 ),
        .I2(\g_grant_latch[1].grant_latch_i_2_n_0 ),
        .I3(src_req_IBUF[12]),
        .I4(src_req_IBUF[13]),
        .I5(\g_grant_latch[0].grant_latch_i_9_n_0 ),
        .O(\g_grant_latch[1].grant_latch_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFFFF02)) 
    \g_grant_latch[1].grant_latch_i_2 
       (.I0(src_req_IBUF[6]),
        .I1(src_req_IBUF[5]),
        .I2(src_req_IBUF[4]),
        .I3(src_req_IBUF[2]),
        .I4(src_req_IBUF[3]),
        .I5(\g_grant_latch[1].grant_latch_i_3_n_0 ),
        .O(\g_grant_latch[1].grant_latch_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \g_grant_latch[1].grant_latch_i_3 
       (.I0(src_req_IBUF[0]),
        .I1(src_req_IBUF[1]),
        .O(\g_grant_latch[1].grant_latch_i_3_n_0 ));
  (* DONT_TOUCH *) 
  (* KEEP_HIERARCHY = "yes" *) 
  aer_async_d_latch__3 \g_grant_latch[2].grant_latch 
       (.d_i(\g_grant_latch[2].grant_latch_i_1_n_0 ),
        .enable_i(capture_grant),
        .q_o(aer_addr_OBUF[2]),
        .rst_n(rst_n_IBUF));
  LUT6 #(
    .INIT(64'hAAAAFFFFAAAAFFFE)) 
    \g_grant_latch[2].grant_latch_i_1 
       (.I0(\g_grant_latch[2].grant_latch_i_2_n_0 ),
        .I1(src_req_IBUF[4]),
        .I2(src_req_IBUF[5]),
        .I3(src_req_IBUF[6]),
        .I4(\g_grant_latch[2].grant_latch_i_3_n_0 ),
        .I5(src_req_IBUF[7]),
        .O(\g_grant_latch[2].grant_latch_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT4 #(
    .INIT(16'h0010)) 
    \g_grant_latch[2].grant_latch_i_2 
       (.I0(src_req_IBUF[10]),
        .I1(src_req_IBUF[11]),
        .I2(\g_grant_latch[0].grant_latch_i_10_n_0 ),
        .I3(\g_grant_latch[0].grant_latch_i_8_n_0 ),
        .O(\g_grant_latch[2].grant_latch_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    \g_grant_latch[2].grant_latch_i_3 
       (.I0(src_req_IBUF[1]),
        .I1(src_req_IBUF[0]),
        .I2(src_req_IBUF[3]),
        .I3(src_req_IBUF[2]),
        .O(\g_grant_latch[2].grant_latch_i_3_n_0 ));
  (* DONT_TOUCH *) 
  (* KEEP_HIERARCHY = "yes" *) 
  aer_async_d_latch \g_grant_latch[3].grant_latch 
       (.d_i(\g_grant_latch[3].grant_latch_i_1_n_0 ),
        .enable_i(capture_grant),
        .q_o(aer_addr_OBUF[3]),
        .rst_n(rst_n_IBUF));
  LUT6 #(
    .INIT(64'h0000FFFF0000FFEF)) 
    \g_grant_latch[3].grant_latch_i_1 
       (.I0(src_req_IBUF[10]),
        .I1(src_req_IBUF[11]),
        .I2(\g_grant_latch[0].grant_latch_i_8_n_0 ),
        .I3(src_req_IBUF[9]),
        .I4(\g_grant_latch[3].grant_latch_i_2_n_0 ),
        .I5(src_req_IBUF[8]),
        .O(\g_grant_latch[3].grant_latch_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \g_grant_latch[3].grant_latch_i_2 
       (.I0(src_req_IBUF[7]),
        .I1(src_req_IBUF[6]),
        .I2(src_req_IBUF[5]),
        .I3(src_req_IBUF[4]),
        .I4(\g_grant_latch[2].grant_latch_i_3_n_0 ),
        .O(\g_grant_latch[3].grant_latch_i_2_n_0 ));
  IBUF rst_n_IBUF_inst
       (.I(rst_n),
        .O(rst_n_IBUF));
  OBUF \src_ack_OBUF[0]_inst 
       (.I(src_ack_OBUF[0]),
        .O(src_ack[0]));
  LUT6 #(
    .INIT(64'h0000010000000000)) 
    \src_ack_OBUF[0]_inst_i_1 
       (.I0(\src_ack_OBUF[3]_inst_i_2_n_0 ),
        .I1(aer_addr_OBUF[0]),
        .I2(aer_addr_OBUF[1]),
        .I3(busy_q),
        .I4(\src_ack_OBUF[15]_inst_i_3_n_0 ),
        .I5(aer_ack_IBUF),
        .O(src_ack_OBUF[0]));
  OBUF \src_ack_OBUF[10]_inst 
       (.I(src_ack_OBUF[10]),
        .O(src_ack[10]));
  LUT6 #(
    .INIT(64'h0000100000000000)) 
    \src_ack_OBUF[10]_inst_i_1 
       (.I0(\src_ack_OBUF[10]_inst_i_2_n_0 ),
        .I1(aer_addr_OBUF[0]),
        .I2(aer_addr_OBUF[1]),
        .I3(busy_q),
        .I4(\src_ack_OBUF[15]_inst_i_3_n_0 ),
        .I5(aer_ack_IBUF),
        .O(src_ack_OBUF[10]));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \src_ack_OBUF[10]_inst_i_2 
       (.I0(aer_addr_OBUF[2]),
        .I1(aer_addr_OBUF[3]),
        .O(\src_ack_OBUF[10]_inst_i_2_n_0 ));
  OBUF \src_ack_OBUF[11]_inst 
       (.I(src_ack_OBUF[11]),
        .O(src_ack[11]));
  LUT6 #(
    .INIT(64'h0000100000000000)) 
    \src_ack_OBUF[11]_inst_i_1 
       (.I0(\src_ack_OBUF[15]_inst_i_2_n_0 ),
        .I1(aer_addr_OBUF[2]),
        .I2(aer_addr_OBUF[3]),
        .I3(busy_q),
        .I4(\src_ack_OBUF[15]_inst_i_3_n_0 ),
        .I5(aer_ack_IBUF),
        .O(src_ack_OBUF[11]));
  OBUF \src_ack_OBUF[12]_inst 
       (.I(src_ack_OBUF[12]),
        .O(src_ack[12]));
  LUT6 #(
    .INIT(64'h0000400000000000)) 
    \src_ack_OBUF[12]_inst_i_1 
       (.I0(\src_ack_OBUF[12]_inst_i_2_n_0 ),
        .I1(aer_addr_OBUF[2]),
        .I2(aer_addr_OBUF[3]),
        .I3(busy_q),
        .I4(\src_ack_OBUF[15]_inst_i_3_n_0 ),
        .I5(aer_ack_IBUF),
        .O(src_ack_OBUF[12]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \src_ack_OBUF[12]_inst_i_2 
       (.I0(aer_addr_OBUF[0]),
        .I1(aer_addr_OBUF[1]),
        .O(\src_ack_OBUF[12]_inst_i_2_n_0 ));
  OBUF \src_ack_OBUF[13]_inst 
       (.I(src_ack_OBUF[13]),
        .O(src_ack[13]));
  LUT6 #(
    .INIT(64'h0000400000000000)) 
    \src_ack_OBUF[13]_inst_i_1 
       (.I0(\src_ack_OBUF[13]_inst_i_2_n_0 ),
        .I1(aer_addr_OBUF[2]),
        .I2(aer_addr_OBUF[3]),
        .I3(busy_q),
        .I4(\src_ack_OBUF[15]_inst_i_3_n_0 ),
        .I5(aer_ack_IBUF),
        .O(src_ack_OBUF[13]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \src_ack_OBUF[13]_inst_i_2 
       (.I0(aer_addr_OBUF[1]),
        .I1(aer_addr_OBUF[0]),
        .O(\src_ack_OBUF[13]_inst_i_2_n_0 ));
  OBUF \src_ack_OBUF[14]_inst 
       (.I(src_ack_OBUF[14]),
        .O(src_ack[14]));
  LUT6 #(
    .INIT(64'h0000100000000000)) 
    \src_ack_OBUF[14]_inst_i_1 
       (.I0(\src_ack_OBUF[14]_inst_i_2_n_0 ),
        .I1(aer_addr_OBUF[0]),
        .I2(aer_addr_OBUF[1]),
        .I3(busy_q),
        .I4(\src_ack_OBUF[15]_inst_i_3_n_0 ),
        .I5(aer_ack_IBUF),
        .O(src_ack_OBUF[14]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT2 #(
    .INIT(4'h7)) 
    \src_ack_OBUF[14]_inst_i_2 
       (.I0(aer_addr_OBUF[2]),
        .I1(aer_addr_OBUF[3]),
        .O(\src_ack_OBUF[14]_inst_i_2_n_0 ));
  OBUF \src_ack_OBUF[15]_inst 
       (.I(src_ack_OBUF[15]),
        .O(src_ack[15]));
  LUT6 #(
    .INIT(64'h0000400000000000)) 
    \src_ack_OBUF[15]_inst_i_1 
       (.I0(\src_ack_OBUF[15]_inst_i_2_n_0 ),
        .I1(aer_addr_OBUF[2]),
        .I2(aer_addr_OBUF[3]),
        .I3(busy_q),
        .I4(\src_ack_OBUF[15]_inst_i_3_n_0 ),
        .I5(aer_ack_IBUF),
        .O(src_ack_OBUF[15]));
  LUT6 #(
    .INIT(64'h8000000C80000000)) 
    \src_ack_OBUF[15]_inst_i_10 
       (.I0(src_req_IBUF[15]),
        .I1(aer_addr_OBUF[2]),
        .I2(aer_addr_OBUF[3]),
        .I3(aer_addr_OBUF[1]),
        .I4(aer_addr_OBUF[0]),
        .I5(src_req_IBUF[4]),
        .O(\src_ack_OBUF[15]_inst_i_10_n_0 ));
  LUT6 #(
    .INIT(64'h0E00000002000000)) 
    \src_ack_OBUF[15]_inst_i_11 
       (.I0(src_req_IBUF[3]),
        .I1(aer_addr_OBUF[3]),
        .I2(aer_addr_OBUF[2]),
        .I3(aer_addr_OBUF[1]),
        .I4(aer_addr_OBUF[0]),
        .I5(src_req_IBUF[11]),
        .O(\src_ack_OBUF[15]_inst_i_11_n_0 ));
  LUT2 #(
    .INIT(4'h7)) 
    \src_ack_OBUF[15]_inst_i_2 
       (.I0(aer_addr_OBUF[0]),
        .I1(aer_addr_OBUF[1]),
        .O(\src_ack_OBUF[15]_inst_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000010)) 
    \src_ack_OBUF[15]_inst_i_3 
       (.I0(\src_ack_OBUF[15]_inst_i_4_n_0 ),
        .I1(\src_ack_OBUF[15]_inst_i_5_n_0 ),
        .I2(\src_ack_OBUF[15]_inst_i_6_n_0 ),
        .I3(\src_ack_OBUF[15]_inst_i_7_n_0 ),
        .I4(\src_ack_OBUF[15]_inst_i_8_n_0 ),
        .I5(\src_ack_OBUF[15]_inst_i_9_n_0 ),
        .O(\src_ack_OBUF[15]_inst_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h2000000C20000000)) 
    \src_ack_OBUF[15]_inst_i_4 
       (.I0(src_req_IBUF[7]),
        .I1(aer_addr_OBUF[3]),
        .I2(aer_addr_OBUF[2]),
        .I3(aer_addr_OBUF[1]),
        .I4(aer_addr_OBUF[0]),
        .I5(src_req_IBUF[8]),
        .O(\src_ack_OBUF[15]_inst_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h0000C00200000002)) 
    \src_ack_OBUF[15]_inst_i_5 
       (.I0(src_req_IBUF[0]),
        .I1(aer_addr_OBUF[3]),
        .I2(aer_addr_OBUF[2]),
        .I3(aer_addr_OBUF[0]),
        .I4(aer_addr_OBUF[1]),
        .I5(src_req_IBUF[13]),
        .O(\src_ack_OBUF[15]_inst_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hF7FFF3FFF7FFFFFF)) 
    \src_ack_OBUF[15]_inst_i_6 
       (.I0(src_req_IBUF[14]),
        .I1(aer_addr_OBUF[1]),
        .I2(aer_addr_OBUF[0]),
        .I3(aer_addr_OBUF[2]),
        .I4(aer_addr_OBUF[3]),
        .I5(src_req_IBUF[6]),
        .O(\src_ack_OBUF[15]_inst_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h000008C000000800)) 
    \src_ack_OBUF[15]_inst_i_7 
       (.I0(src_req_IBUF[10]),
        .I1(aer_addr_OBUF[3]),
        .I2(aer_addr_OBUF[2]),
        .I3(aer_addr_OBUF[1]),
        .I4(aer_addr_OBUF[0]),
        .I5(src_req_IBUF[12]),
        .O(\src_ack_OBUF[15]_inst_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAAAEAFAAAAAEAAAA)) 
    \src_ack_OBUF[15]_inst_i_8 
       (.I0(\src_ack_OBUF[15]_inst_i_10_n_0 ),
        .I1(src_req_IBUF[5]),
        .I2(\src_ack_OBUF[13]_inst_i_2_n_0 ),
        .I3(aer_addr_OBUF[3]),
        .I4(aer_addr_OBUF[2]),
        .I5(src_req_IBUF[9]),
        .O(\src_ack_OBUF[15]_inst_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF02300200)) 
    \src_ack_OBUF[15]_inst_i_9 
       (.I0(src_req_IBUF[2]),
        .I1(\src_ack_OBUF[3]_inst_i_2_n_0 ),
        .I2(aer_addr_OBUF[0]),
        .I3(aer_addr_OBUF[1]),
        .I4(src_req_IBUF[1]),
        .I5(\src_ack_OBUF[15]_inst_i_11_n_0 ),
        .O(\src_ack_OBUF[15]_inst_i_9_n_0 ));
  OBUF \src_ack_OBUF[1]_inst 
       (.I(src_ack_OBUF[1]),
        .O(src_ack[1]));
  LUT6 #(
    .INIT(64'h0000010000000000)) 
    \src_ack_OBUF[1]_inst_i_1 
       (.I0(\src_ack_OBUF[13]_inst_i_2_n_0 ),
        .I1(aer_addr_OBUF[2]),
        .I2(aer_addr_OBUF[3]),
        .I3(busy_q),
        .I4(\src_ack_OBUF[15]_inst_i_3_n_0 ),
        .I5(aer_ack_IBUF),
        .O(src_ack_OBUF[1]));
  OBUF \src_ack_OBUF[2]_inst 
       (.I(src_ack_OBUF[2]),
        .O(src_ack[2]));
  LUT6 #(
    .INIT(64'h0000100000000000)) 
    \src_ack_OBUF[2]_inst_i_1 
       (.I0(\src_ack_OBUF[3]_inst_i_2_n_0 ),
        .I1(aer_addr_OBUF[0]),
        .I2(aer_addr_OBUF[1]),
        .I3(busy_q),
        .I4(\src_ack_OBUF[15]_inst_i_3_n_0 ),
        .I5(aer_ack_IBUF),
        .O(src_ack_OBUF[2]));
  OBUF \src_ack_OBUF[3]_inst 
       (.I(src_ack_OBUF[3]),
        .O(src_ack[3]));
  LUT6 #(
    .INIT(64'h0000400000000000)) 
    \src_ack_OBUF[3]_inst_i_1 
       (.I0(\src_ack_OBUF[3]_inst_i_2_n_0 ),
        .I1(aer_addr_OBUF[0]),
        .I2(aer_addr_OBUF[1]),
        .I3(busy_q),
        .I4(\src_ack_OBUF[15]_inst_i_3_n_0 ),
        .I5(aer_ack_IBUF),
        .O(src_ack_OBUF[3]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \src_ack_OBUF[3]_inst_i_2 
       (.I0(aer_addr_OBUF[2]),
        .I1(aer_addr_OBUF[3]),
        .O(\src_ack_OBUF[3]_inst_i_2_n_0 ));
  OBUF \src_ack_OBUF[4]_inst 
       (.I(src_ack_OBUF[4]),
        .O(src_ack[4]));
  LUT6 #(
    .INIT(64'h0000100000000000)) 
    \src_ack_OBUF[4]_inst_i_1 
       (.I0(\src_ack_OBUF[12]_inst_i_2_n_0 ),
        .I1(aer_addr_OBUF[3]),
        .I2(aer_addr_OBUF[2]),
        .I3(busy_q),
        .I4(\src_ack_OBUF[15]_inst_i_3_n_0 ),
        .I5(aer_ack_IBUF),
        .O(src_ack_OBUF[4]));
  OBUF \src_ack_OBUF[5]_inst 
       (.I(src_ack_OBUF[5]),
        .O(src_ack[5]));
  LUT6 #(
    .INIT(64'h0000100000000000)) 
    \src_ack_OBUF[5]_inst_i_1 
       (.I0(\src_ack_OBUF[13]_inst_i_2_n_0 ),
        .I1(aer_addr_OBUF[3]),
        .I2(aer_addr_OBUF[2]),
        .I3(busy_q),
        .I4(\src_ack_OBUF[15]_inst_i_3_n_0 ),
        .I5(aer_ack_IBUF),
        .O(src_ack_OBUF[5]));
  OBUF \src_ack_OBUF[6]_inst 
       (.I(src_ack_OBUF[6]),
        .O(src_ack[6]));
  LUT6 #(
    .INIT(64'h0000100000000000)) 
    \src_ack_OBUF[6]_inst_i_1 
       (.I0(\src_ack_OBUF[6]_inst_i_2_n_0 ),
        .I1(aer_addr_OBUF[0]),
        .I2(aer_addr_OBUF[1]),
        .I3(busy_q),
        .I4(\src_ack_OBUF[15]_inst_i_3_n_0 ),
        .I5(aer_ack_IBUF),
        .O(src_ack_OBUF[6]));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \src_ack_OBUF[6]_inst_i_2 
       (.I0(aer_addr_OBUF[3]),
        .I1(aer_addr_OBUF[2]),
        .O(\src_ack_OBUF[6]_inst_i_2_n_0 ));
  OBUF \src_ack_OBUF[7]_inst 
       (.I(src_ack_OBUF[7]),
        .O(src_ack[7]));
  LUT6 #(
    .INIT(64'h0000100000000000)) 
    \src_ack_OBUF[7]_inst_i_1 
       (.I0(\src_ack_OBUF[15]_inst_i_2_n_0 ),
        .I1(aer_addr_OBUF[3]),
        .I2(aer_addr_OBUF[2]),
        .I3(busy_q),
        .I4(\src_ack_OBUF[15]_inst_i_3_n_0 ),
        .I5(aer_ack_IBUF),
        .O(src_ack_OBUF[7]));
  OBUF \src_ack_OBUF[8]_inst 
       (.I(src_ack_OBUF[8]),
        .O(src_ack[8]));
  LUT6 #(
    .INIT(64'h0000100000000000)) 
    \src_ack_OBUF[8]_inst_i_1 
       (.I0(\src_ack_OBUF[12]_inst_i_2_n_0 ),
        .I1(aer_addr_OBUF[2]),
        .I2(aer_addr_OBUF[3]),
        .I3(busy_q),
        .I4(\src_ack_OBUF[15]_inst_i_3_n_0 ),
        .I5(aer_ack_IBUF),
        .O(src_ack_OBUF[8]));
  OBUF \src_ack_OBUF[9]_inst 
       (.I(src_ack_OBUF[9]),
        .O(src_ack[9]));
  LUT6 #(
    .INIT(64'h0000100000000000)) 
    \src_ack_OBUF[9]_inst_i_1 
       (.I0(\src_ack_OBUF[13]_inst_i_2_n_0 ),
        .I1(aer_addr_OBUF[2]),
        .I2(aer_addr_OBUF[3]),
        .I3(busy_q),
        .I4(\src_ack_OBUF[15]_inst_i_3_n_0 ),
        .I5(aer_ack_IBUF),
        .O(src_ack_OBUF[9]));
  IBUF \src_req_IBUF[0]_inst 
       (.I(src_req[0]),
        .O(src_req_IBUF[0]));
  IBUF \src_req_IBUF[10]_inst 
       (.I(src_req[10]),
        .O(src_req_IBUF[10]));
  IBUF \src_req_IBUF[11]_inst 
       (.I(src_req[11]),
        .O(src_req_IBUF[11]));
  IBUF \src_req_IBUF[12]_inst 
       (.I(src_req[12]),
        .O(src_req_IBUF[12]));
  IBUF \src_req_IBUF[13]_inst 
       (.I(src_req[13]),
        .O(src_req_IBUF[13]));
  IBUF \src_req_IBUF[14]_inst 
       (.I(src_req[14]),
        .O(src_req_IBUF[14]));
  IBUF \src_req_IBUF[15]_inst 
       (.I(src_req[15]),
        .O(src_req_IBUF[15]));
  IBUF \src_req_IBUF[1]_inst 
       (.I(src_req[1]),
        .O(src_req_IBUF[1]));
  IBUF \src_req_IBUF[2]_inst 
       (.I(src_req[2]),
        .O(src_req_IBUF[2]));
  IBUF \src_req_IBUF[3]_inst 
       (.I(src_req[3]),
        .O(src_req_IBUF[3]));
  IBUF \src_req_IBUF[4]_inst 
       (.I(src_req[4]),
        .O(src_req_IBUF[4]));
  IBUF \src_req_IBUF[5]_inst 
       (.I(src_req[5]),
        .O(src_req_IBUF[5]));
  IBUF \src_req_IBUF[6]_inst 
       (.I(src_req[6]),
        .O(src_req_IBUF[6]));
  IBUF \src_req_IBUF[7]_inst 
       (.I(src_req[7]),
        .O(src_req_IBUF[7]));
  IBUF \src_req_IBUF[8]_inst 
       (.I(src_req[8]),
        .O(src_req_IBUF[8]));
  IBUF \src_req_IBUF[9]_inst 
       (.I(src_req[9]),
        .O(src_req_IBUF[9]));
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
