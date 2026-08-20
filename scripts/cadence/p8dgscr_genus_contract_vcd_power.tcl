set script_dir [file dirname [file normalize [info script]]]
set project_root [file normalize [file join $script_dir ../..]]
set rtl_file [file join $project_root rtl improved aer_pending_direct_gray_sync_core_reset.sv]
set vcd_file [file join $project_root sim waves contract_fairness_p8_direct_gray_sync_core_reset.vcd]
set report_dir [file join $project_root reports p8dgscr_contract_vcd]

foreach required_file [list $rtl_file $vcd_file] {
    if {![file exists $required_file]} {
        error "P8-DG-SCR VCD-power input not found: $required_file"
    }
}

set_db init_lib_search_path [list "$::env(HOME)/FPR/lib"]
set_db init_hdl_search_path [list $project_root [file dirname $rtl_file]]
read_libs typical.lib
read_hdl -sv $rtl_file
elaborate aer_pending_direct_gray_sync_core_reset
check_design -unresolved

set scan_cells [get_db lib_cells *SDFF*]
if {[llength $scan_cells] > 0} {
    set_db $scan_cells .avoid true
}

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
set_db $synchronizer_insts .preserve true
puts "P8DGSCR_SYNCHRONIZER_INSTS_PRESERVED=[llength $synchronizer_insts]"
syn_opt

file mkdir $report_dir
rtlstim2gate -load
rtlstim2gate -infer_rules
read_vcd -static -vcd_scope aer_contract_fairness_tb/dut/u_dut $vcd_file
report_power > [file join $report_dir p8dgscr_genus_power_vcd.rpt]
puts "P8DGSCR_CONTRACT_VCD_POWER_DONE"
exit
