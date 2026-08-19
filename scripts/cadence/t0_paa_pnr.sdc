set_false_path -from [get_ports rst_n]

# Self-timed external transaction budgets. These constrain request-to-output
# and acknowledge-to-source response paths without introducing a fake clock.
set_max_delay 5.000 -from [get_ports src_req*] -to [get_ports {aer_addr* aer_req}]
set_max_delay 5.000 -from [get_ports aer_ack] -to [get_ports src_ack*]
set_max_delay 5.000 -from [get_ports src_req*] -to [get_ports src_ack*]

set_max_transition 2.000 [current_design]
set_max_fanout 16 [current_design]
