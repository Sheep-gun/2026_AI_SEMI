tclmode
set_screen_display -noprogress
set_dofile_abort exit

set script_dir [file dirname [file normalize [info script]]]
set project_root [file normalize [file join $script_dir ../..]]
set rtl_file [file join $project_root rtl improved aer_pending_direct_gray_scr_onehot_tree.sv]
set netlist_file [file join $project_root inputs aer_pending_direct_gray_scr_onehot_tree_pnr.v]
set report_dir [file join $project_root reports p9oht]

foreach required_file [list $rtl_file $netlist_file] {
    if {![file exists $required_file]} {
        error "P9-OHT LEC input not found: $required_file"
    }
}

file mkdir $report_dir
set_log_file [file join $report_dir p9oht_lec.rpt] -replace
set_mapping_method -sensitive
set_undefined_cell black_box -noascend -both
add_search_path "$env(HOME)/FPR/lib" -library -both
read_library -liberty -both -append "$env(HOME)/FPR/lib/typical.lib"
read_design -systemverilog -golden -lastmod -noelab $rtl_file
elaborate_design -golden -root aer_pending_direct_gray_scr_onehot_tree
read_design -verilog95 -revised -lastmod -noelab $netlist_file
elaborate_design -revised -root aer_pending_direct_gray_scr_onehot_tree

# Preserve the actual initialization semantics.  The 36 resetless flops must
# not be silently forced to zero while checking RTL against the mapped design.
set_flatten_model -seq_constant
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
puts "P9OHT_LEC_NONEQUIVALENT=$noneq_count"
puts "P9OHT_LEC_ABORT=$abort_count"
puts "P9OHT_LEC_UNKNOWN=$unknown_count"
if {$noneq_count > 0 || $abort_count > 0 || $unknown_count > 0} {
    error "P9-OHT RTL/netlist sequential equivalence failed"
}
puts "P9OHT_LEC_PASS"
exit 0
