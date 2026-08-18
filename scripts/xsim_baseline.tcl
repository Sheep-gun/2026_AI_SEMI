log_wave -recursive *
open_vcd ../waves/aer_traditional.vcd
log_vcd [get_objects -r /aer_traditional_tb/*]
run all
close_vcd
quit
