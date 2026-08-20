set_db init_lib_search_path [list "$::env(HOME)/FPR/lib"]
set_db init_hdl_search_path [list .]
read_libs typical.lib
read_hdl -sv rtl/aer_improved_cutthrough.sv
elaborate aer_improved_cutthrough
set scan_cells [get_db lib_cells *SDFF*]
if {[llength $scan_cells] > 0} {
    set_db $scan_cells .avoid true
}
create_clock -name clk -period 10.000 [get_ports clk]
set_false_path -from [get_ports rst_n]
set_false_path -from [get_ports src_req_async*]
set_input_delay 1.000 -clock clk [get_ports out_ready]
set_output_delay 1.000 -clock clk [get_ports {src_ack_async* out_addr* out_valid}]
set_max_transition 2.000 [current_design]
set_max_fanout 16 [current_design]
syn_generic
syn_map
syn_opt
read_vcd -static -vcd_scope aer_contract_fairness_tb/dut/u_dut waves/contract_fairness_p4c.vcd
file mkdir reports/contract_vcd_power
report_power > reports/contract_vcd_power/p4c_genus_power_vcd.rpt
puts "P4C_CONTRACT_VCD_POWER_DONE"
exit
