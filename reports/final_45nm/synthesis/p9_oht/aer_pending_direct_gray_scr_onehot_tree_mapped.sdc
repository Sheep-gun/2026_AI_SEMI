# ####################################################################

#  Created by Genus(TM) Synthesis Solution 23.14-s090_1 on Wed Aug 26 14:50:34 KST 2026

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design aer_pending_direct_gray_scr_onehot_tree

create_clock -name "clk" -period 10.0 -waveform {0.0 5.0} [get_ports clk]
set_false_path -from [list \
  [get_ports {src_req_async[15]}]  \
  [get_ports {src_req_async[14]}]  \
  [get_ports {src_req_async[13]}]  \
  [get_ports {src_req_async[12]}]  \
  [get_ports {src_req_async[11]}]  \
  [get_ports {src_req_async[10]}]  \
  [get_ports {src_req_async[9]}]  \
  [get_ports {src_req_async[8]}]  \
  [get_ports {src_req_async[7]}]  \
  [get_ports {src_req_async[6]}]  \
  [get_ports {src_req_async[5]}]  \
  [get_ports {src_req_async[4]}]  \
  [get_ports {src_req_async[3]}]  \
  [get_ports {src_req_async[2]}]  \
  [get_ports {src_req_async[1]}]  \
  [get_ports {src_req_async[0]}] ]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports out_ready]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {src_ack_async[15]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {src_ack_async[14]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {src_ack_async[13]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {src_ack_async[12]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {src_ack_async[11]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {src_ack_async[10]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {src_ack_async[9]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {src_ack_async[8]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {src_ack_async[7]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {src_ack_async[6]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {src_ack_async[5]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {src_ack_async[4]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {src_ack_async[3]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {src_ack_async[2]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {src_ack_async[1]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {src_ack_async[0]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {out_addr[3]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {out_addr[2]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {out_addr[1]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {out_addr[0]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports out_valid]
set_max_fanout 16.000 [current_design]
set_max_transition 0.5 [current_design]
set_wire_load_mode "enclosed"
set_dont_touch [get_cells {req_sync_q_reg[6]}]
set_dont_touch [get_cells {req_sync_q_reg[12]}]
set_dont_touch [get_cells {req_sync_q_reg[3]}]
set_dont_touch [get_cells {req_sync_q_reg[11]}]
set_dont_touch [get_cells {req_sync_q_reg[1]}]
set_dont_touch [get_cells {req_sync_q_reg[4]}]
set_dont_touch [get_cells {req_sync_q_reg[15]}]
set_dont_touch [get_cells {req_sync_q_reg[5]}]
set_dont_touch [get_cells {req_sync_q_reg[2]}]
set_dont_touch [get_cells {req_sync_q_reg[8]}]
set_dont_touch [get_cells {req_sync_q_reg[10]}]
set_dont_touch [get_cells {req_sync_q_reg[9]}]
set_dont_touch [get_cells {req_sync_q_reg[13]}]
set_dont_touch [get_cells {req_sync_q_reg[0]}]
set_dont_touch [get_cells {req_sync_q_reg[14]}]
set_dont_touch [get_cells {req_sync_q_reg[7]}]
set_dont_touch [get_cells {reset_release_q_reg[1]}]
set_dont_touch [get_cells {req_meta_q_reg[6]}]
set_dont_touch [get_cells {req_meta_q_reg[12]}]
set_dont_touch [get_cells {req_meta_q_reg[15]}]
set_dont_touch [get_cells {req_meta_q_reg[10]}]
set_dont_touch [get_cells {reset_release_q_reg[0]}]
set_dont_touch [get_cells {req_meta_q_reg[5]}]
set_dont_touch [get_cells {req_meta_q_reg[4]}]
set_dont_touch [get_cells {req_meta_q_reg[8]}]
set_dont_touch [get_cells {req_meta_q_reg[0]}]
set_dont_touch [get_cells {req_meta_q_reg[3]}]
set_dont_touch [get_cells {req_meta_q_reg[11]}]
set_dont_touch [get_cells {req_meta_q_reg[13]}]
set_dont_touch [get_cells {req_meta_q_reg[7]}]
set_dont_touch [get_cells {req_meta_q_reg[9]}]
set_dont_touch [get_cells {req_meta_q_reg[1]}]
set_dont_touch [get_cells {req_meta_q_reg[2]}]
set_dont_touch [get_cells {req_meta_q_reg[14]}]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFHQX1]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFHQX2]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFHQX4]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFHQX8]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFNSRX1]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFNSRX2]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFNSRX4]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFNSRXL]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFQX1]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFQX2]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFQX4]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFQXL]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFRHQX1]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFRHQX2]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFRHQX4]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFRHQX8]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFRX1]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFRX2]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFRX4]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFRXL]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFSHQX1]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFSHQX2]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFSHQX4]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFSHQX8]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFSRHQX1]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFSRHQX2]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFSRHQX4]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFSRHQX8]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFSRX1]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFSRX2]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFSRX4]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFSRXL]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFSX1]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFSX2]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFSX4]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFSXL]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFTRX1]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFTRX2]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFTRX4]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFTRXL]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFX1]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFX2]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFX4]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFXL]
