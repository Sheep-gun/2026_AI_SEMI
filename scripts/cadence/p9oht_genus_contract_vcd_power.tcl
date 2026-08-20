set script_dir [file dirname [file normalize [info script]]]
set project_root [file normalize [file join $script_dir ../..]]
set rtl_file [file join $project_root rtl improved aer_pending_direct_gray_scr_onehot_tree.sv]
set vcd_file [file join $project_root sim waves p9_onehot_tree_contract.vcd]
set report_dir [file join $project_root reports p9oht_contract_vcd]
set top aer_pending_direct_gray_scr_onehot_tree
puts "P9OHT_VCD_PROJECT_ROOT=$project_root"

foreach required_file [list $rtl_file $vcd_file] {
    if {![file exists $required_file]} {
        error "P9-OHT VCD-power input not found: $required_file"
    }
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
set_false_path -from [get_ports src_req_async*]
set_input_delay 1.000 -clock clk [get_ports out_ready]
set_output_delay 1.000 -clock clk \
    [get_ports {src_ack_async* out_addr* out_valid}]
set_max_transition 2.000 [current_design]
set_max_fanout 16 [current_design]

syn_generic
syn_map
set synchronizer_insts [concat \
    [get_db insts *req_meta_q_reg*] \
    [get_db insts *req_sync_q_reg*] \
    [get_db insts *reset_release_q_reg*]]
set synchronizer_count [llength $synchronizer_insts]
if {$synchronizer_count != 34} {
    error "P9-OHT VCD flow expected 34 synchronizer flops; found $synchronizer_count"
}
set_db $synchronizer_insts .preserve true
syn_opt

file mkdir $report_dir
rtlstim2gate -load
rtlstim2gate -infer_rules
read_vcd -static \
    -vcd_scope aer_contract_fairness_tb/dut/implementation/implementation \
    $vcd_file
report_power > [file join $report_dir p9oht_genus_power_vcd.rpt]
write_saif -computed > [file join $report_dir p9oht_mapped_activity.saif]
puts "P9OHT_CONTRACT_VCD_POWER_DONE"
exit
