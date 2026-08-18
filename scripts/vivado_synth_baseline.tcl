set report_dir reports/baseline/vivado_sanity
file mkdir $report_dir

set preferred_part xc7a35tcpg236-1
set available_parts [get_parts -quiet $preferred_part]
if {[llength $available_parts] == 0} {
    set available_parts [get_parts -quiet -filter {FAMILY == "Artix-7"}]
}
if {[llength $available_parts] == 0} {
    error "No supported FPGA part is installed for the Vivado synthesis sanity check"
}
set sanity_part [lindex $available_parts 0]

set rtl_file rtl/baseline/aer_traditional.sv
if {![file exists $rtl_file]} {
    error "Run Vivado from the repository root; missing $rtl_file"
}
read_verilog -sv $rtl_file
synth_design -top aer_traditional -part $sanity_part -flatten_hierarchy rebuilt

# These constraints exist only to expose structural timing problems in Vivado.
# They are not the final ASIC SDC and their timing is not an ASIC PPA result.
create_clock -name clk -period 10.000 [get_ports clk]
set_false_path -from [get_ports rst_n]
set data_inputs [get_ports -quiet -filter {DIRECTION == IN && NAME != clk && NAME != rst_n}]
if {[llength $data_inputs] > 0} {
    set_input_delay 1.000 -clock [get_clocks clk] $data_inputs
}
if {[llength [all_outputs]] > 0} {
    set_output_delay 1.000 -clock [get_clocks clk] [all_outputs]
}

opt_design

report_utilization -hierarchical -file [file join $report_dir utilization.rpt]
report_timing_summary -delay_type max -max_paths 10 -report_unconstrained \
    -file [file join $report_dir timing_summary.rpt]
report_high_fanout_nets -timing -load_types -max_nets 20 \
    -file [file join $report_dir high_fanout.rpt]
check_timing -verbose -file [file join $report_dir check_timing.rpt]
write_checkpoint -force [file join $report_dir aer_traditional_synth.dcp]

set summary_file [file join $report_dir summary.txt]
set summary_handle [open $summary_file w]
puts $summary_handle "purpose=FPGA structural synthesis sanity only"
puts $summary_handle "vivado_version=[version -short]"
puts $summary_handle "part=$sanity_part"
puts $summary_handle "top=aer_traditional"
puts $summary_handle "num_sources=16"
puts $summary_handle "addr_width=4"
puts $summary_handle "clock_period_ns=10.000"
puts $summary_handle "primitive_cells=[llength [get_cells -hierarchical -filter {IS_PRIMITIVE}]]"
set worst_path [get_timing_paths -quiet -delay_type max -max_paths 1]
if {[llength $worst_path] > 0} {
    puts $summary_handle "estimated_setup_slack_ns=[get_property SLACK $worst_path]"
    puts $summary_handle "estimated_datapath_delay_ns=[get_property DATAPATH_DELAY $worst_path]"
}
puts $summary_handle "SANITY_PASS"
close $summary_handle

puts "BASELINE_SANITY_PART=$sanity_part"
puts "BASELINE_SANITY_REPORT_DIR=$report_dir"
puts "BASELINE_SANITY_PASS"
