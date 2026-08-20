set report_dir reports/pending_gray_epoch_fallthrough/vivado_robust
file mkdir $report_dir
set part xc7a35tcpg236-1

read_verilog -sv rtl/improved/aer_pending_gray_epoch_fallthrough.sv
synth_design -top aer_pending_gray_epoch_fallthrough -part $part \
    -flatten_hierarchy rebuilt -generic ROBUST_RESET=1

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
report_timing -delay_type max -max_paths 20 -from [all_registers] \
    -to [get_ports {out_addr* out_valid}] \
    -file [file join $report_dir reg2out_timing.rpt]
report_timing -delay_type max -max_paths 20 -from [get_ports out_ready] \
    -to [all_registers] -file [file join $report_dir input2reg_timing.rpt]
check_timing -verbose -file [file join $report_dir check_timing.rpt]

set summary [open [file join $report_dir summary.txt] w]
set reg_path [get_timing_paths -quiet -delay_type max -max_paths 1 \
    -from [all_registers] -to [all_registers]]
set out_path [get_timing_paths -quiet -delay_type max -max_paths 1 \
    -from [all_registers] -to [get_ports {out_addr* out_valid}]]
set input_path [get_timing_paths -quiet -delay_type max -max_paths 1 \
    -from [get_ports out_ready] -to [all_registers]]
if {[llength $reg_path] > 0} {
    puts $summary "reg2reg_slack_ns=[get_property SLACK $reg_path]"
    puts $summary "reg2reg_datapath_delay_ns=[get_property DATAPATH_DELAY $reg_path]"
    puts $summary "reg2reg_startpoint=[get_property STARTPOINT_PIN $reg_path]"
    puts $summary "reg2reg_endpoint=[get_property ENDPOINT_PIN $reg_path]"
}
if {[llength $out_path] > 0} {
    puts $summary "reg2out_slack_ns=[get_property SLACK $out_path]"
    puts $summary "reg2out_datapath_delay_ns=[get_property DATAPATH_DELAY $out_path]"
    puts $summary "reg2out_startpoint=[get_property STARTPOINT_PIN $out_path]"
    puts $summary "reg2out_endpoint=[get_property ENDPOINT_PIN $out_path]"
}
if {[llength $input_path] > 0} {
    puts $summary "input2reg_slack_ns=[get_property SLACK $input_path]"
    puts $summary "input2reg_datapath_delay_ns=[get_property DATAPATH_DELAY $input_path]"
    puts $summary "input2reg_startpoint=[get_property STARTPOINT_PIN $input_path]"
    puts $summary "input2reg_endpoint=[get_property ENDPOINT_PIN $input_path]"
}
puts $summary "reset_mode=async_assert_sync_deassert_2ff"
puts $summary "P7_GE_FT_ROBUST_SYNTH_PASS"
close $summary

write_verilog -force -mode funcsim \
    [file join $report_dir aer_pending_gray_epoch_fallthrough_post_synth.v]
puts "P7_GE_FT_ROBUST_SYNTH_PASS"
