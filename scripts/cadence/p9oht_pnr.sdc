create_clock -name clk -period 10.000 -waveform {0.000 5.000} [get_ports clk]
set_clock_uncertainty 0.200 [get_clocks clk]

# src_req_async is timed only after the first CDC stage.  rst_n is deliberately
# not false-pathed: it drives the only asynchronous reset arcs remaining in the
# design, on reset_release_q[1:0].  The 37 core state bits clear synchronously
# through their D paths and therefore use ordinary setup/hold analysis.
set_false_path -from [get_ports src_req_async*]
set_input_delay 1.000 -clock clk [get_ports out_ready]
set_output_delay 1.000 -clock clk [get_ports {src_ack_async* out_addr* out_valid}]
set_max_transition 2.000 [current_design]
set_max_fanout 16 [current_design]

# The RTL ASYNC_REG attribute is not interpreted by Genus/Innovus in this
# release.  Bound the physical data delay inside each two-flop request
# synchronizer and the reset-release chain explicitly.  Hold analysis remains
# enabled; the bound only prevents placement/routing from consuming meaningful
# metastability-resolution time.
set_max_delay 0.900 \
    -from [get_pins {req_meta_q_reg*/Q}] \
    -to [get_pins {req_sync_q_reg*/D}]
set_max_delay 1.000 \
    -from [get_pins {reset_release_q_reg*/Q}] \
    -to [get_pins {reset_release_q_reg*/D}]
