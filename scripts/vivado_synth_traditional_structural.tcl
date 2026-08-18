set report_dir reports/traditional_async/vivado_probe
file mkdir $report_dir

set part xc7a35tcpg236-1
read_verilog -sv rtl/traditional_async/aer_traditional_structural.sv
synth_design -top aer_traditional_structural -part $part -flatten_hierarchy none

report_utilization -hierarchical -file [file join $report_dir utilization.rpt]
check_timing -verbose -file [file join $report_dir check_timing.rpt]
report_drc -file [file join $report_dir drc.rpt]
write_verilog -force -mode funcsim [file join $report_dir aer_traditional_structural_post_synth.v]
write_sdf -force [file join $report_dir aer_traditional_structural_post_synth.sdf]

set summary [open [file join $report_dir summary.txt] w]
puts $summary "purpose=structural clockless FPGA synthesis probe"
puts $summary "vivado_version=[version -short]"
puts $summary "part=$part"
puts $summary "top=aer_traditional_structural"
puts $summary "global_clock=none"
puts $summary "metastability_status=MUTEX_NOT_IMPLEMENTED"
puts $summary "TRADITIONAL_STRUCTURAL_SYNTH_PASS"
close $summary

puts "TRADITIONAL_STRUCTURAL_SYNTH_PASS"
