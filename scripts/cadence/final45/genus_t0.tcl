foreach required_env {AER45_RTL AER45_TOP AER45_OUT} {
    if {![info exists ::env($required_env)]} {error "$required_env is required"}
}
set pdk_root "$::env(HOME)/aer_2026/pdk45_digital"
set slow_lib "$pdk_root/gsclib045/timing/slow_vdd1v0_basicCells.lib"
set rtl_file $::env(AER45_RTL)
set top $::env(AER45_TOP)
set out_dir $::env(AER45_OUT)
file mkdir $out_dir
read_libs $slow_lib
read_hdl -sv $rtl_file
elaborate $top
check_design -unresolved
set delay_insts [get_db insts *delay_cell*]
set latch_insts [concat [get_db insts *grant_latch*] [get_db insts *busy_latch*]]
puts "T0_45_DELAY_CELLS=[llength $delay_insts]"
puts "T0_45_LATCH_CELLS=[llength $latch_insts]"
if {[llength $delay_insts]!=6 || [llength $latch_insts]!=5} {
    error "T0-45 expected 6 delay and 5 latch cells"
}
set_db $delay_insts .preserve true
set_db $latch_insts .preserve true
set scan_cells [get_db lib_cells *SDFF*]
if {[llength $scan_cells]>0} {set_db $scan_cells .avoid true}
set_false_path -from [get_ports rst_n]
set_max_delay 5.000 -from [get_ports src_req*] -to [get_ports {aer_addr* aer_req}]
set_max_delay 5.000 -from [get_ports aer_ack] -to [get_ports src_ack*]
set_max_delay 5.000 -from [get_ports src_req*] -to [get_ports src_ack*]
set_max_transition 0.500 [current_design]
set_max_fanout 16 [current_design]
syn_generic
syn_map
syn_opt
report_area > [file join $out_dir genus_area.rpt]
report_gates > [file join $out_dir genus_gates.rpt]
report_timing -max_paths 100 > [file join $out_dir genus_timing.rpt]
report_timing -unconstrained -max_paths 100 > [file join $out_dir genus_unconstrained.rpt]
report_power > [file join $out_dir genus_power.rpt]
report_qor > [file join $out_dir genus_qor.rpt]
write_hdl > [file join $out_dir ${top}_mapped.v]
puts "T0_PAA_45NM_GENUS_DONE"
exit
