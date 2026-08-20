set part xc7a35tcpg236-1
set which [lindex $argv 0]
if {$which eq "grouped"} {
 read_verilog -sv rtl/experiments/aer_pending_gray_rank_reuse_sync_core_reset.sv
 set top aer_gray_rank_ring_selector16
} else {
 read_verilog -sv rtl/experiments/aer_gray_rank_mask_selector16.sv
 set top aer_gray_rank_mask_selector16
}
synth_design -top $top -part $part -flatten_hierarchy rebuilt
create_clock -name virtual_clk -period 10
opt_design
set dir reports/p9_state_compression/selector_$which
file mkdir $dir
report_utilization -hierarchical -file [file join $dir utilization.rpt]
report_timing -max_paths 10 -file [file join $dir timing.rpt]
puts "P9_SELECTOR_COMPARE_DONE which=$which"
