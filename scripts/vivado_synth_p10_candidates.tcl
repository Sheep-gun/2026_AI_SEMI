set part xc7a35tcpg236-1
set candidates {
    {iprra aer_pending_gray_rank_iprra_sync_core_reset}
    {xor1 aer_pending_xor1_rank_reuse_sync_core_reset}
    {xor2 aer_pending_xor2_rank_reuse_sync_core_reset}
}
foreach item $candidates {
    lassign $item key top
    set report_dir [file join reports p10_final vivado $key]
    file mkdir $report_dir
    read_verilog -sv rtl/experiments/aer_pending_rank_reuse_p10_candidates.sv
    synth_design -top $top -part $part -flatten_hierarchy rebuilt
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
    set summary [open [file join $report_dir summary.txt] w]
    set path [get_timing_paths -quiet -delay_type max -max_paths 1 \
        -from [all_registers] -to [all_registers]]
    if {[llength $path]>0} {
        puts $summary "reg2reg_slack_ns=[get_property SLACK $path]"
        puts $summary "reg2reg_datapath_delay_ns=[get_property DATAPATH_DELAY $path]"
        puts $summary "reg2reg_startpoint=[get_property STARTPOINT_PIN $path]"
        puts $summary "reg2reg_endpoint=[get_property ENDPOINT_PIN $path]"
    }
    puts $summary "state_ff_contract=71"
    close $summary
    write_verilog -force -mode funcsim [file join $report_dir ${top}_post_synth.v]
    close_design
}
puts "P10_CANDIDATE_SYNTH_PASS"
