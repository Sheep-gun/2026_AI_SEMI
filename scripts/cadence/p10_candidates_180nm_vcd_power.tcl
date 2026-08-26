foreach required_env {P10_RTL P10_TOP P10_VCD P10_TAG} {
    if {![info exists ::env($required_env)]} {error "$required_env is required"}
}
foreach required_file [list $::env(P10_RTL) $::env(P10_VCD)] {
    if {![file exists $required_file]} {error "P10 VCD input missing: $required_file"}
}
set_db init_lib_search_path [list "$::env(HOME)/FPR/lib"]
set_db init_hdl_search_path [list .]
read_libs typical.lib
read_hdl -sv $::env(P10_RTL)
elaborate $::env(P10_TOP)
check_design -unresolved
set scan_cells [get_db lib_cells *SDFF*]
if {[llength $scan_cells]>0} {set_db $scan_cells .avoid true}
create_clock -name clk -period 10.000 [get_ports clk]
set_false_path -from [get_ports src_req_async*]
set_input_delay 1.000 -clock clk [get_ports out_ready]
set_output_delay 1.000 -clock clk [get_ports {src_ack_async* out_addr* out_valid}]
set_max_transition 2.000 [current_design]
set_max_fanout 16 [current_design]
syn_generic
syn_map
set synchronizer_insts [concat \
    [get_db insts *req_meta_q_reg*] \
    [get_db insts *req_sync_q_reg*] \
    [get_db insts *reset_release_q_reg*]]
if {[llength $synchronizer_insts]!=34} {
    error "P10 VCD flow expected 34 synchronizer flops; found [llength $synchronizer_insts]"
}
set_db $synchronizer_insts .preserve true
syn_opt
set report_dir "reports/$::env(P10_TAG)_vcd"
file mkdir $report_dir
rtlstim2gate -load
rtlstim2gate -infer_rules
read_vcd -static \
    -vcd_scope aer_contract_fairness_tb/dut/u_dut/implementation \
    $::env(P10_VCD)
report_power > "$report_dir/genus_power_vcd.rpt"
write_saif -computed > "$report_dir/mapped_activity.saif"
puts "P10_180NM_VCD_POWER_DONE tag=$::env(P10_TAG)"
exit
