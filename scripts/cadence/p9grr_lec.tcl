tclmode
set_screen_display -noprogress
set_dofile_abort exit

set script_dir [file dirname [file normalize [info script]]]
set project_root [file normalize [file join $script_dir ../..]]
set rtl_file [file join $project_root rtl experiments aer_pending_gray_rank_reuse_sync_core_reset.sv]
set netlist_file [file join $project_root inputs aer_pending_gray_rank_reuse_sync_core_reset_pnr.v]
set report_dir [file join $project_root reports p9grr_pnr]
set top aer_pending_gray_rank_reuse_sync_core_reset
puts "P9GRR_LEC_PROJECT_ROOT=$project_root"

foreach required_file [list $rtl_file $netlist_file] {
    if {![file exists $required_file]} {
        error "P9-GRR LEC input not found: $required_file"
    }
}

file mkdir $report_dir
set_log_file [file join $report_dir p9grr_lec.rpt] -replace
set_mapping_method -sensitive
set_undefined_cell black_box -noascend -both
add_search_path "$env(HOME)/FPR/lib" -library -both
read_library -liberty -both -append "$env(HOME)/FPR/lib/typical.lib"
read_design -systemverilog -golden -lastmod -noelab $rtl_file
elaborate_design -golden -root $top
read_design -verilog95 -revised -lastmod -noelab $netlist_file
elaborate_design -revised -root $top

# P9-GRR has 32 intentionally resetless request CDC flops, 37 synchronously
# initialized core flops, and two asynchronous reset-release flops.  Do not
# force unknown resetless initial values to zero during equivalence checking.
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
puts "P9GRR_LEC_NONEQUIVALENT=$noneq_count"
puts "P9GRR_LEC_ABORT=$abort_count"
puts "P9GRR_LEC_UNKNOWN=$unknown_count"
if {$noneq_count > 0 || $abort_count > 0 || $unknown_count > 0} {
    error "P9-GRR RTL/netlist sequential equivalence failed"
}
puts "P9GRR_LEC_EXPECTED_PRIMARY_OUTPUTS=21"
puts "P9GRR_LEC_EXPECTED_STATE_POINTS=71"
puts "P9GRR_LEC_PASS"
exit 0
