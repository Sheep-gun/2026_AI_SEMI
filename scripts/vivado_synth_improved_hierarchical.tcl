set report_dir reports/improved_hierarchical/vivado_sanity
file mkdir $report_dir

set part xc7a35tcpg236-1
read_verilog -sv rtl/improved/aer_improved_hierarchical.sv
synth_design -top aer_improved_hierarchical -part $part -flatten_hierarchy rebuilt

create_clock -name clk -period 10.000 [get_ports clk]
set_false_path -from [get_ports rst_n]
set_false_path -from [get_ports src_req_async*]
set_input_delay 1.000 -clock clk [get_ports out_ready]
set_output_delay 1.000 -clock clk [get_ports {src_ack_async* out_addr* out_valid}]

opt_design
report_utilization -hierarchical -file [file join $report_dir utilization.rpt]
report_timing_summary -delay_type max -max_paths 10 -report_unconstrained \
    -file [file join $report_dir timing_summary.rpt]
check_timing -verbose -file [file join $report_dir check_timing.rpt]
write_verilog -force -mode funcsim [file join $report_dir aer_improved_hierarchical_post_synth.v]
write_sdf -force [file join $report_dir aer_improved_hierarchical_post_synth.sdf]

set summary [open [file join $report_dir summary.txt] w]
puts $summary "purpose=P2 hierarchical FPGA structural synthesis sanity"
puts $summary "vivado_version=[version -short]"
puts $summary "part=$part"
puts $summary "clock_period_ns=10.000"
set worst_path [get_timing_paths -quiet -delay_type max -max_paths 1]
if {[llength $worst_path] > 0} {
    puts $summary "estimated_setup_slack_ns=[get_property SLACK $worst_path]"
    puts $summary "estimated_datapath_delay_ns=[get_property DATAPATH_DELAY $worst_path]"
}
puts $summary "P2_SYNTH_PASS"
close $summary
puts "P2_SYNTH_PASS"
