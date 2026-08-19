if {![info exists ::env(CLK_PERIOD_NS)]} { error "CLK_PERIOD_NS is required" }
set period $::env(CLK_PERIOD_NS)
set tag [string map {. p} $period]
set dir "reports/sweep_${tag}ns"
file mkdir $dir
set_db init_lib_search_path [list "$::env(HOME)/FPR/lib"]
read_libs typical.lib
read_hdl -sv rtl/aer_improved_depth1.sv
elaborate aer_improved_depth1
set scan_cells [get_db lib_cells *SDFF*]
if {[llength $scan_cells] > 0} { set_db $scan_cells .avoid true }
create_clock -name clk -period $period [get_ports clk]
set_false_path -from [get_ports rst_n]
set_false_path -from [get_ports src_req_async*]
set_input_delay 1.000 -clock clk [get_ports out_ready]
set_output_delay 1.000 -clock clk [get_ports {src_ack_async* out_addr* out_valid}]
syn_generic
syn_map
syn_opt
report_area > "$dir/area.rpt"
report_timing -max_paths 1 > "$dir/timing.rpt"
puts "P3_SWEEP_DONE period_ns=$period"
exit
