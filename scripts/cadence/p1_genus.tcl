set_db init_lib_search_path [list "$::env(HOME)/FPR/lib"]
set_db init_hdl_search_path [list .]

read_libs typical.lib
read_hdl -sv rtl/aer_improved_hybrid.sv
elaborate aer_improved_hybrid
check_design -unresolved

create_clock -name clk -period 10.000 [get_ports clk]
set_false_path -from [get_ports rst_n]
set_false_path -from [get_ports src_req_async*]
set_input_delay 1.000 -clock clk [get_ports out_ready]
set_output_delay 1.000 -clock clk [get_ports {src_ack_async* out_addr* out_valid}]

syn_generic
syn_map
syn_opt

report_area > reports/genus_area.rpt
report_gates > reports/genus_gates.rpt
report_timing -max_paths 20 > reports/genus_timing.rpt
report_power > reports/genus_power.rpt
write_hdl > outputs/aer_improved_hybrid_mapped.v
write_sdf > outputs/aer_improved_hybrid_mapped.sdf

puts "P1_GENUS_FLOW_DONE"
exit
