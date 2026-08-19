set_db init_lib_search_path [list "$::env(HOME)/FPR/lib"]
set_db init_hdl_search_path [list .]

read_libs typical.lib
read_hdl -sv rtl/aer_traditional_latch_paa.sv
elaborate aer_traditional_latch_paa
check_design -unresolved

# DLY4 cells implement the explicit bundled-data relative-timing margin. Their
# Boolean function is identity, so synthesis would remove them unless the
# physical instances are preserved explicitly.
set delay_insts [get_db insts *delay_cell*]
set_db $delay_insts .preserve true
puts "T0_PAA_DELAY_INSTS_PRESERVED=[llength $delay_insts]"

set scan_cells [get_db lib_cells *SDFF*]
if {[llength $scan_cells] > 0} {
    set_db $scan_cells .avoid true
}
puts "T0_PAA_SCAN_CELLS_AVOIDED=[llength $scan_cells]"

# T0-PPA is self-timed and has no global clock. These constraints bound the
# externally visible handshake arcs; Fmax is deliberately not invented.
set_false_path -from [get_ports rst_n]
set_max_delay 5.000 -from [get_ports src_req*] -to [get_ports {aer_addr* aer_req}]
set_max_delay 5.000 -from [get_ports aer_ack] -to [get_ports src_ack*]
set_max_delay 5.000 -from [get_ports src_req*] -to [get_ports src_ack*]
set_max_transition 2.000 [current_design]
set_max_fanout 16 [current_design]

syn_generic
syn_map
syn_opt

report_area > reports/genus_pnr_area.rpt
report_gates > reports/genus_pnr_gates.rpt
report_timing -max_paths 100 > reports/genus_pnr_timing.rpt
report_timing -unconstrained -max_paths 100 > reports/genus_pnr_unconstrained.rpt
report_power > reports/genus_pnr_power.rpt
write_hdl > inputs/aer_traditional_latch_paa_pnr.v

puts "T0_PAA_GENUS_PNR_NETLIST_DONE"
exit
