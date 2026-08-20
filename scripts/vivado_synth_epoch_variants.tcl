set part xc7a35tcpg236-1
set rtl rtl/experiments/aer_pending_epoch_variants.sv
set variants {
    aer_pending_epoch_binary_exp
    aer_pending_epoch_xor1_exp
    aer_pending_epoch_xor2_exp
    aer_pending_epoch_direct_gray_exp
    aer_pending_epoch_lfsr_zero_exp
    aer_pending_gray_ring_reuse_exp
    aer_pending_epoch_gray_control_exp
}

foreach top $variants {
    set report_dir [file join reports epoch_variants vivado $top]
    file mkdir $report_dir
    read_verilog -sv $rtl
    synth_design -top $top -part $part -flatten_hierarchy rebuilt
    create_clock -name clk -period 10 [get_ports clk]
    set_false_path -from [get_ports rst_n]
    set_false_path -from [get_ports src_req_async*]
    set_input_delay 1 -clock clk [get_ports out_ready]
    set_output_delay 1 -clock clk \
        [get_ports {src_ack_async* out_addr* out_valid}]
    opt_design

    report_utilization -hierarchical -file \
        [file join $report_dir utilization.rpt]
    report_timing_summary -delay_type max -max_paths 10 \
        -report_unconstrained -file [file join $report_dir timing_summary.rpt]
    report_timing -delay_type max -max_paths 10 -from [all_registers] \
        -to [all_registers] -file [file join $report_dir reg2reg_timing.rpt]

    set summary [open [file join $report_dir summary.txt] w]
    set cells [get_cells -hierarchical -filter {REF_NAME =~ LUT*}]
    puts $summary "top=$top"
    # These are raw primitive objects.  Packed LUT utilization is reported by
    # utilization.rpt and is the comparison number used in the result note.
    puts $summary "primitive_lut_cell_objects=[llength $cells]"
    puts $summary "primitive_ff_cell_objects=[llength [get_cells -hierarchical -filter {REF_NAME =~ FD*}]]"
    set path [get_timing_paths -quiet -delay_type max -max_paths 1 \
        -from [all_registers] -to [all_registers]]
    if {[llength $path] > 0} {
        puts $summary "reg2reg_slack_ns=[get_property SLACK $path]"
        puts $summary "reg2reg_datapath_delay_ns=[get_property DATAPATH_DELAY $path]"
        puts $summary "reg2reg_startpoint=[get_property STARTPOINT_PIN $path]"
        puts $summary "reg2reg_endpoint=[get_property ENDPOINT_PIN $path]"
    }
    close $summary
    close_design
}
puts "P7_EPOCH_VARIANT_SYNTH_PASS"
