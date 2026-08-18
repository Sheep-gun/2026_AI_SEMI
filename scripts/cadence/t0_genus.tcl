set_db init_lib_search_path [list "$::env(HOME)/FPR/lib"]
set_db init_hdl_search_path [list .]

read_libs typical.lib
read_hdl -sv rtl/aer_traditional_structural.sv
elaborate aer_traditional_structural
check_design -unresolved

syn_generic
syn_map
syn_opt

report_area > reports/genus_area.rpt
report_gates > reports/genus_gates.rpt
report_timing > reports/genus_timing.rpt
report_power > reports/genus_power.rpt
write_hdl > outputs/aer_traditional_structural_mapped.v
write_sdf > outputs/aer_traditional_structural_mapped.sdf

puts "T0_GENUS_FLOW_DONE"
exit
