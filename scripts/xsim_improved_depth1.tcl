log_wave -recursive *
open_vcd ../waves/aer_improved_depth1.vcd
log_vcd [get_objects -r /aer_improved_hybrid_tb/*]
run all
close_vcd
quit
