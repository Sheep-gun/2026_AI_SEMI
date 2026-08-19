tclmode
set_screen_display -noprogress
set_dofile_abort exit
set_log_file reports/p4c_pnr/p4c_lec.rpt -replace
set_mapping_method -sensitive
set_undefined_cell black_box -noascend -both
add_search_path "$env(HOME)/FPR/lib" -library -both
read_library -liberty -both -append "$env(HOME)/FPR/lib/typical.lib"
read_design -systemverilog -golden -lastmod -noelab rtl/aer_improved_cutthrough.sv
elaborate_design -golden -root aer_improved_cutthrough
read_design -verilog95 -revised -lastmod -noelab inputs/aer_improved_cutthrough_pnr.v
elaborate_design -revised -root aer_improved_cutthrough
set_flatten_model -seq_constant
set_flatten_model -seq_constant_x_to 0
set_flatten_model -hier_seq_merge
set_system_mode lec
report_unmapped_points -summary
add_compared_points -all
compare
report_verification -verbose
report_statistics
set noneq_count [get_compare_points -NONequivalent -count]
set abort_count [get_compare_points -abort -count]
set unknown_count [get_compare_points -unknown -count]
puts "P4C_LEC_NONEQUIVALENT=$noneq_count"
puts "P4C_LEC_ABORT=$abort_count"
puts "P4C_LEC_UNKNOWN=$unknown_count"
if {$noneq_count > 0 || $abort_count > 0 || $unknown_count > 0} {
    error "P4-C RTL/netlist equivalence failed"
}
puts "P4C_LEC_PASS"
exit 0
