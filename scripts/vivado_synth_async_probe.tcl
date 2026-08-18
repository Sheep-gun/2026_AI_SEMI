set report_dir reports/async_baseline/vivado_probe
file mkdir $report_dir

set preferred_part xc7a35tcpg236-1
set available_parts [get_parts -quiet $preferred_part]
if {[llength $available_parts] == 0} {
    set available_parts [get_parts -quiet -filter {FAMILY == "Artix-7"}]
}
if {[llength $available_parts] == 0} {
    error "No supported FPGA part is installed for the asynchronous synthesis probe"
}
set probe_part [lindex $available_parts 0]

set rtl_file rtl/async_baseline/aer_traditional_async.sv
if {![file exists $rtl_file]} {
    error "Run Vivado from the repository root; missing $rtl_file"
}

read_verilog -sv $rtl_file
synth_design -top aer_traditional_async -part $probe_part -flatten_hierarchy rebuilt
opt_design

report_utilization -hierarchical -file [file join $report_dir utilization.rpt]
check_timing -verbose -file [file join $report_dir check_timing.rpt]

set latch_cells [get_cells -hierarchical -quiet -filter {REF_NAME =~ LD*}]
set summary_file [file join $report_dir summary.txt]
set summary_handle [open $summary_file w]
puts $summary_handle "purpose=FPGA structural synthesis probe only"
puts $summary_handle "vivado_version=[version -short]"
puts $summary_handle "part=$probe_part"
puts $summary_handle "top=aer_traditional_async"
puts $summary_handle "global_clock=none"
puts $summary_handle "num_sources=16"
puts $summary_handle "addr_width=4"
puts $summary_handle "latch_primitives=[llength $latch_cells]"
puts $summary_handle "timing_status=UNCONSTRAINED_NOT_SIGNOFF"
puts $summary_handle "metastability_status=MUTEX_NOT_IMPLEMENTED"
puts $summary_handle "ASYNC_SYNTH_PROBE_PASS"
close $summary_handle

puts "ASYNC_SYNTH_PROBE_PART=$probe_part"
puts "ASYNC_SYNTH_PROBE_REPORT_DIR=$report_dir"
puts "ASYNC_SYNTH_PROBE_PASS"
