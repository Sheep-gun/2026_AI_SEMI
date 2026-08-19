set_db init_lib_search_path [list "$::env(HOME)/FPR/lib"]
set_db init_hdl_search_path [list .]

read_libs typical.lib
read_hdl -sv rtl/aer_traditional.sv
elaborate aer_traditional
check_design -unresolved

set scan_cells [get_db lib_cells *SDFF*]
if {[llength $scan_cells] > 0} {
    set_db $scan_cells .avoid true
}
puts "B0_SCAN_CELLS_AVOIDED=[llength $scan_cells]"

create_clock -name clk -period 10.000 [get_ports clk]
set_false_path -from [get_ports rst_n]
set_input_delay 1.000 -clock clk [get_ports {src_req* aer_ack}]
set_output_delay 1.000 -clock clk [get_ports {src_ack* aer_addr* aer_req}]
set_max_transition 2.000 [current_design]
set_max_fanout 16 [current_design]

syn_generic
syn_map
syn_opt

report_area > reports/genus_pnr_area.rpt
report_gates > reports/genus_pnr_gates.rpt
report_timing -max_paths 20 > reports/genus_pnr_timing.rpt
report_power > reports/genus_pnr_power.rpt
write_hdl > inputs/aer_traditional_pnr.v

puts "B0_GENUS_PNR_NETLIST_DONE"
exit
