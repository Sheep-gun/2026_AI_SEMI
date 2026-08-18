if {![info exists ::env(CLK_PERIOD_NS)]} {
    error "CLK_PERIOD_NS is required"
}
set period $::env(CLK_PERIOD_NS)
set tag [string map {. p} $period]
set report_dir "reports/sweep_${tag}ns"
file mkdir $report_dir

set_db init_lib_search_path [list "$::env(HOME)/FPR/lib"]
set_db init_hdl_search_path [list .]
read_libs typical.lib
read_hdl -sv rtl/aer_improved_hybrid.sv
elaborate aer_improved_hybrid

create_clock -name clk -period $period [get_ports clk]
set_false_path -from [get_ports rst_n]
set_false_path -from [get_ports src_req_async*]
set_input_delay 1.000 -clock clk [get_ports out_ready]
set_output_delay 1.000 -clock clk [get_ports {src_ack_async* out_addr* out_valid}]

syn_generic
syn_map
syn_opt
report_area > "$report_dir/area.rpt"
report_timing -max_paths 1 > "$report_dir/timing.rpt"
write_hdl > "$report_dir/mapped.v"
puts "P1_SWEEP_DONE period_ns=$period"
exit
