log_wave -recursive *
open_vcd ../waves/aer_traditional_structural_race.vcd
log_vcd [get_objects -r /aer_traditional_structural_race_tb/*]
run all
close_vcd
quit
