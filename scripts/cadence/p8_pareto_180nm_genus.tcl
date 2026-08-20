foreach required_env {P8_RTL P8_TOP P8_TAG} {
    if {![info exists ::env($required_env)]} {
        error "$required_env is required"
    }
}

set_db init_lib_search_path [list "$::env(HOME)/FPR/lib"]
set_db init_hdl_search_path [list .]
read_libs typical.lib
read_hdl -sv $::env(P8_RTL)
elaborate $::env(P8_TOP)
check_design -unresolved

set scan_cells [get_db lib_cells *SDFF*]
if {[llength $scan_cells] > 0} {
    set_db $scan_cells .avoid true
}

create_clock -name clk -period 10.000 [get_ports clk]
set_false_path -from [get_ports rst_n]
set_false_path -from [get_ports src_req_async*]
set_input_delay 1.000 -clock clk [get_ports out_ready]
set_output_delay 1.000 -clock clk \
    [get_ports {src_ack_async* out_addr* out_valid}]
set_max_transition 2.000 [current_design]
set_max_fanout 16 [current_design]

syn_generic
syn_map
syn_opt

set tag $::env(P8_TAG)
set top $::env(P8_TOP)
file mkdir "reports/$tag" inputs
report_area > "reports/$tag/genus_area.rpt"
report_gates > "reports/$tag/genus_gates.rpt"
report_timing -max_paths 50 > "reports/$tag/genus_timing.rpt"
report_power > "reports/$tag/genus_power.rpt"
report_qor > "reports/$tag/genus_qor.rpt"
write_hdl > "inputs/${top}_${tag}_pnr.v"
puts "P8_PARETO_180NM_GENUS_DONE tag=$tag top=$top"
exit
