create_clock -name clk -period 10.000 -waveform {0.000 5.000} [get_ports clk]
set_clock_uncertainty 0.200 [get_clocks clk]

set_false_path -from [get_ports rst_n]
set_false_path -from [get_ports src_req_async*]
set_input_delay 1.000 -clock clk [get_ports out_ready]
set_output_delay 1.000 -clock clk [get_ports {src_ack_async* out_addr* out_valid}]

set_max_transition 2.000 [current_design]
set_max_fanout 16 [current_design]
