if {$argc != 3} {
    error "usage: vivado_synth_p9_candidate.tcl <rtl_file> <top> <report_dir>"
}

set rtl_file   [lindex $argv 0]
set top_name   [lindex $argv 1]
set report_dir [lindex $argv 2]
set part xc7a35tcpg236-1
file mkdir $report_dir

read_verilog -sv $rtl_file
synth_design -top $top_name -part $part -flatten_hierarchy rebuilt

create_clock -name clk -period 10 [get_ports clk]
set_false_path -from [get_ports rst_n]
set_false_path -from [get_ports src_req_async*]
set_input_delay 1 -clock clk [get_ports out_ready]
set_output_delay 1 -clock clk [get_ports {src_ack_async* out_addr* out_valid}]
opt_design

report_utilization -hierarchical -file [file join $report_dir utilization.rpt]
report_timing_summary -delay_type max -max_paths 10 -report_unconstrained \
    -file [file join $report_dir timing_summary.rpt]
report_timing -delay_type max -max_paths 20 -from [all_registers] \
    -to [all_registers] -file [file join $report_dir reg2reg_timing.rpt]
check_timing -verbose -file [file join $report_dir check_timing.rpt]

set summary [open [file join $report_dir summary.txt] w]
set reg_path [get_timing_paths -quiet -delay_type max -max_paths 1 \
    -from [all_registers] -to [all_registers]]
if {[llength $reg_path] > 0} {
    puts $summary "reg2reg_slack_ns=[get_property SLACK $reg_path]"
    puts $summary "reg2reg_datapath_delay_ns=[get_property DATAPATH_DELAY $reg_path]"
    puts $summary "reg2reg_startpoint=[get_property STARTPOINT_PIN $reg_path]"
    puts $summary "reg2reg_endpoint=[get_property ENDPOINT_PIN $reg_path]"
}
puts $summary "top=$top_name"
puts $summary "reset_mode=async_2ff_release_sync_core_clear_output_isolation"
puts $summary "epoch_mode=direct_reflected_gray"
puts $summary "P9_CANDIDATE_SYNTH_PASS"
close $summary

write_verilog -force -mode funcsim \
    [file join $report_dir ${top_name}_post_synth.v]
puts "P9_CANDIDATE_SYNTH_PASS top=$top_name"
