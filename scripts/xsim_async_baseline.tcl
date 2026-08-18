log_wave -recursive *
open_vcd ../waves/aer_traditional_async.vcd
log_vcd [get_objects -r /aer_traditional_async_tb/*]
run all
close_vcd
quit
