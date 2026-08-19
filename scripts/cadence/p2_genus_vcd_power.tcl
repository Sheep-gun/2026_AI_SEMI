set_db init_lib_search_path [list "$::env(HOME)/FPR/lib"]
set_db init_hdl_search_path [list .]
read_libs typical.lib
read_hdl -sv rtl/aer_improved_hierarchical.sv
elaborate aer_improved_hierarchical

create_clock -name clk -period 10.000 [get_ports clk]
set_false_path -from [get_ports rst_n]
set_false_path -from [get_ports src_req_async*]
set_input_delay 1.000 -clock clk [get_ports out_ready]
set_output_delay 1.000 -clock clk [get_ports {src_ack_async* out_addr* out_valid}]

syn_generic
syn_map
syn_opt

read_vcd -static -vcd_scope aer_improved_hybrid_tb/dut/implementation aer_improved_hierarchical.vcd
report_power > reports/genus_power_vcd.rpt
puts "P2_VCD_POWER_DONE"
exit
