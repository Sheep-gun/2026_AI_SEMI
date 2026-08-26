foreach required_env {AER45_RTL AER45_TOP AER45_TAG AER45_OUT AER45_MODE} {
    if {![info exists ::env($required_env)]} {error "$required_env is required"}
}
set pdk_root "$::env(HOME)/aer_2026/pdk45_digital"
set basic "$pdk_root/gsclib045/timing/slow_vdd1v0_basicCells.lib"
set mbff "$pdk_root/gsclib045/timing/slow_vdd1v0_multibitsDFF.lib"
set rtl $::env(AER45_RTL)
set top $::env(AER45_TOP)
set tag $::env(AER45_TAG)
set out $::env(AER45_OUT)
set mode $::env(AER45_MODE)
file mkdir $out
if {$mode eq "mbff" || $mode eq "both"} {
    read_libs [list $basic $mbff]
    set_db use_multibit_cells true
    set_db multibit_mapping_effort_level high
    set_db multibit_preserve_inferred_instances true
} else {read_libs $basic}
if {$mode eq "icg" || $mode eq "both"} {
    set_db lp_insert_clock_gating true
    set_db lp_clock_gating_infer_enable true
    set_db lp_clock_gating_coverage_effort high
}
read_hdl -sv $rtl
elaborate $top
check_design -unresolved
set synchronizer_insts [concat [get_db insts *req_meta_q_reg*] [get_db insts *req_sync_q_reg*] [get_db insts *reset_release_q_reg*]]
if {[llength $synchronizer_insts]!=34} {error "$tag pre-map synchronizer count mismatch"}
if {$mode eq "mbff" || $mode eq "both"} {set_db $synchronizer_insts .dont_merge_multibit true}
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
set synchronizer_insts [concat [get_db insts *req_meta_q_reg*] [get_db insts *req_sync_q_reg*] [get_db insts *reset_release_q_reg*]]
if {[llength $synchronizer_insts]!=34} {error "$tag synchronizer count mismatch"}
set_db $synchronizer_insts .preserve true
if {$mode eq "mbff" || $mode eq "both"} {merge_to_multibit_cells}
syn_opt
report_area > [file join $out genus_area.rpt]
report_gates > [file join $out genus_gates.rpt]
report_timing -max_paths 100 > [file join $out genus_timing.rpt]
report_power > [file join $out genus_power.rpt]
report_qor > [file join $out genus_qor.rpt]
catch {report_multibit_inferencing > [file join $out multibit.rpt]}
catch {report_clock_gating_quality > [file join $out clock_gating.rpt]}
if {[info exists ::env(AER45_VCD)] && [info exists ::env(AER45_VCD_SCOPE)]} {
    rtlstim2gate -load
    rtlstim2gate -infer_rules
    read_vcd -static -vcd_scope $::env(AER45_VCD_SCOPE) $::env(AER45_VCD)
    report_power > [file join $out genus_power_vcd.rpt]
    write_saif -computed > [file join $out mapped_activity.saif]
}
write_hdl > [file join $out ${top}_mapped.v]
puts "AER45_LOWPOWER_DONE tag=$tag mode=$mode"
exit
