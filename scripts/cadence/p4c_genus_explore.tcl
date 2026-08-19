set_db init_lib_search_path [list "$::env(HOME)/FPR/lib"]
set_db init_hdl_search_path [list .]
read_libs typical.lib
read_hdl -sv rtl/aer_improved_cutthrough.sv
elaborate aer_improved_cutthrough
check_design -unresolved
set scan_cells [get_db lib_cells *SDFF*]
if {[llength $scan_cells] > 0} { set_db $scan_cells .avoid true }
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
file mkdir reports/p4c
report_area > reports/p4c/genus_area.rpt
report_gates > reports/p4c/genus_gates.rpt
report_timing -max_paths 20 > reports/p4c/genus_timing.rpt
report_power > reports/p4c/genus_power.rpt
write_hdl > inputs/aer_improved_cutthrough_pnr.v
puts "P4C_GENUS_EXPLORE_DONE"
exit
