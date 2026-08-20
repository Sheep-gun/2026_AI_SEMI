set script_dir [file dirname [file normalize [info script]]]
set project_root [file normalize [file join $script_dir ../..]]
set rtl_file [file join $project_root rtl experiments aer_pending_gray_rank_reuse_sync_core_reset.sv]
set report_dir [file join $project_root reports p9grr]
set input_dir [file join $project_root inputs]
set top aer_pending_gray_rank_reuse_sync_core_reset
puts "P9GRR_PROJECT_ROOT=$project_root"

if {![file exists $rtl_file]} {
    error "P9-GRR RTL not found at bundle-relative path: $rtl_file"
}

set_db init_lib_search_path [list "$::env(HOME)/FPR/lib"]
set_db init_hdl_search_path [list $project_root [file dirname $rtl_file]]
read_libs typical.lib
read_hdl -sv $rtl_file
elaborate $top
check_design -unresolved

set scan_cells [get_db lib_cells *SDFF*]
if {[llength $scan_cells] > 0} {
    set_db $scan_cells .avoid true
}

create_clock -name clk -period 10.000 [get_ports clk]
# rst_n reaches the asynchronous reset pins of reset_release_q[1:0].  Keep
# recovery/removal timing enabled for those two flops.
set_false_path -from [get_ports src_req_async*]
set_input_delay 1.000 -clock clk [get_ports out_ready]
set_output_delay 1.000 -clock clk \
    [get_ports {src_ack_async* out_addr* out_valid}]
set_max_transition 2.000 [current_design]
set_max_fanout 16 [current_design]

syn_generic
syn_map

# This Genus release does not consume the Vivado ASYNC_REG attribute.  Fail
# closed unless all 32 request synchronizer flops and both reset-release flops
# are present, then preserve them through optimization.
set synchronizer_insts [concat \
    [get_db insts *req_meta_q_reg*] \
    [get_db insts *req_sync_q_reg*] \
    [get_db insts *reset_release_q_reg*]]
set synchronizer_count [llength $synchronizer_insts]
puts "P9GRR_SYNCHRONIZER_INSTS_FOUND=$synchronizer_count"
if {$synchronizer_count != 34} {
    error "P9-GRR expected 34 request/reset synchronizer flops; found $synchronizer_count"
}
set_db $synchronizer_insts .preserve true
puts "P9GRR_SYNCHRONIZER_INSTS_PRESERVED=$synchronizer_count"

syn_opt

file mkdir $report_dir $input_dir
report_area > [file join $report_dir genus_area.rpt]
report_gates > [file join $report_dir genus_gates.rpt]
report_timing -max_paths 50 > [file join $report_dir genus_timing.rpt]
report_power > [file join $report_dir genus_power.rpt]
report_qor > [file join $report_dir genus_qor.rpt]
write_hdl > [file join $input_dir ${top}_pnr.v]
puts "P9GRR_GENUS_DONE"
exit
