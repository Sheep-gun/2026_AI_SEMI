set_db init_lib_search_path [list "$::env(HOME)/FPR/lib"]
set_db init_hdl_search_path [list .]

read_libs typical.lib
read_hdl -sv rtl/aer_improved_hierarchical.sv
elaborate aer_improved_hierarchical
check_design -unresolved

# Scan flops were previously used as logic muxes through SE/SI. They are legal
# for synthesis but confuse placement scan-chain checks, so the physical-flow
# netlist deliberately uses ordinary flops only.
set scan_cells [get_db lib_cells *SDFF*]
puts "P2_SCAN_CELLS_AVOIDED=[llength $scan_cells]"
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

report_area > reports/genus_pnr_area.rpt
report_gates > reports/genus_pnr_gates.rpt
report_timing -max_paths 20 > reports/genus_pnr_timing.rpt
write_hdl > inputs/aer_improved_hierarchical_pnr.v

puts "P2_GENUS_PNR_NETLIST_DONE"
exit
