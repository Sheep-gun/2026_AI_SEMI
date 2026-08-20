tclmode
set_screen_display -noprogress
set_dofile_abort exit

set script_dir [file dirname [file normalize [info script]]]
set project_root [file normalize [file join $script_dir ../..]]
set p8_rtl_file [file join $project_root rtl improved aer_pending_direct_gray_sync_core_reset.sv]
set p9oht_rtl_file [file join $project_root rtl improved aer_pending_direct_gray_scr_onehot_tree.sv]
set report_dir [file join $project_root reports p9oht]

foreach required_file [list $p8_rtl_file $p9oht_rtl_file] {
    if {![file exists $required_file]} {
        error "P8/P9-OHT sequential LEC input not found: $required_file"
    }
}

file mkdir $report_dir
set_log_file [file join $report_dir p9oht_vs_p8_seq_lec.rpt] -replace
set_mapping_method -sensitive

# The two RTLs deliberately keep the same ports and architectural state.  The
# revised implementation changes only the combinational arbitration/consume
# network, so a full sequential comparison is stronger than a trace test.
read_design -systemverilog -golden -lastmod -noelab $p8_rtl_file
elaborate_design -golden -root aer_pending_direct_gray_sync_core_reset
read_design -systemverilog -revised -lastmod -noelab $p9oht_rtl_file
elaborate_design -revised -root aer_pending_direct_gray_scr_onehot_tree

# Do not weaken the comparison by replacing unknown initial state with zero.
# The resetless request synchronizers and output-address register therefore
# retain the same unconstrained initial-state treatment on both sides.
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
puts "P9OHT_P8_SEQ_LEC_NONEQUIVALENT=$noneq_count"
puts "P9OHT_P8_SEQ_LEC_ABORT=$abort_count"
puts "P9OHT_P8_SEQ_LEC_UNKNOWN=$unknown_count"
if {$noneq_count > 0 || $abort_count > 0 || $unknown_count > 0} {
    error "P8-DG-SCR versus P9-OHT sequential equivalence failed"
}
puts "P9OHT_P8_SEQ_LEC_PASS"
exit 0
