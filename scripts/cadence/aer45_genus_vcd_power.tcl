foreach required_env {AER45_RTL AER45_TOP AER45_TAG AER45_OUT AER45_SYNC_FF AER45_VCD AER45_VCD_SCOPE} {
    if {![info exists ::env($required_env)]} {error "$required_env is required"}
}
set pdk_root "$::env(HOME)/aer_2026/pdk45_digital"
set slow_lib "$pdk_root/gsclib045/timing/slow_vdd1v0_basicCells.lib"
set rtl_file $::env(AER45_RTL)
set top $::env(AER45_TOP)
set tag $::env(AER45_TAG)
set out_dir $::env(AER45_OUT)
set expected_sync $::env(AER45_SYNC_FF)
set vcd_file $::env(AER45_VCD)
set vcd_scope $::env(AER45_VCD_SCOPE)
foreach required_file [list $slow_lib $rtl_file $vcd_file] {
    if {![file exists $required_file]} {error "AER45 VCD input missing: $required_file"}
}
file mkdir $out_dir
read_libs $slow_lib
read_hdl -sv $rtl_file
elaborate $top
check_design -unresolved
set scan_cells [get_db lib_cells *SDFF*]
if {[llength $scan_cells]>0} {set_db $scan_cells .avoid true}
create_clock -name clk -period 10.000 [get_ports clk]
set_false_path -from [get_ports src_req_async*]
set_input_delay 1.000 -clock clk [get_ports out_ready]
set_output_delay 1.000 -clock clk [get_ports {src_ack_async* out_addr* out_valid}]
set_max_transition 0.500 [current_design]
set_max_fanout 16 [current_design]
syn_generic
syn_map
set synchronizer_insts [concat \
    [get_db insts *req_meta_q_reg*] \
    [get_db insts *req_sync_q_reg*] \
    [get_db insts *reset_release_q_reg*]]
if {[llength $synchronizer_insts]!=$expected_sync} {
    error "$tag expected $expected_sync synchronizer flops; found [llength $synchronizer_insts]"
}
if {[llength $synchronizer_insts]>0} {set_db $synchronizer_insts .preserve true}
syn_opt
rtlstim2gate -load
rtlstim2gate -infer_rules
read_vcd -static -vcd_scope $vcd_scope $vcd_file
report_power > [file join $out_dir genus_power_vcd.rpt]
write_saif -computed > [file join $out_dir mapped_activity.saif]
puts "AER45_VCD_POWER_DONE tag=$tag"
exit
