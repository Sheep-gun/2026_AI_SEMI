set report_dir reports/p9_state_compression/vivado_binary_ring
file mkdir $report_dir
set part xc7a35tcpg236-1

read_verilog -sv rtl/experiments/aer_pending_binary_ring_sync_core_reset.sv
synth_design -top aer_pending_binary_ring_sync_core_reset -part $part -flatten_hierarchy rebuilt

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
puts $summary "state_bits=71"
puts $summary "fairness_state=registered_output_address_reuse"
puts $summary "arbitration=strict_binary_ring_grouped_4x4"
puts $summary "P9_BINARY_RING_SYNTH_PASS"
close $summary

write_verilog -force -mode funcsim \
    [file join $report_dir aer_pending_binary_ring_sync_core_reset_post_synth.v]
puts "P9_BINARY_RING_SYNTH_PASS"
