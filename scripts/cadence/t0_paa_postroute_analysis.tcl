restoreDesign db/aer_traditional_latch_paa_postroute.enc.dat \
    aer_traditional_latch_paa

# Conservative bundled-data comparison. A level-sensitive latch makes the
# source-to-address output a sequential boundary, so compare the latest source
# data arrival at the grant-latch D pins with the earliest delayed launch at the
# busy-latch D pin. Request assertion has another protected DLY4 stage after Q.
report_timing -unconstrained -from [get_ports src_req*] \
    -to [get_pins *grant_latch*/D] \
    -view setup_view -late -max_paths 200 \
    > reports/bundled_data_address_late_slow.rpt
report_timing -unconstrained -from [get_ports src_req*] \
    -to [get_pins busy_latch/D] \
    -view hold_view -early -max_paths 200 \
    > reports/bundled_data_request_early_fast.rpt

report_timing -unconstrained -from [get_pins busy_latch/Q] \
    -to [get_ports aer_req] -view hold_view -early -max_paths 20 \
    > reports/busy_to_request_early_fast.rpt

report_timing -from [get_ports src_req*] -to [get_ports aer_req] \
    -view setup_view -late -max_paths 200 \
    > reports/request_late_slow.rpt
report_timing -from [get_ports aer_ack] -to [get_ports src_ack*] \
    -view setup_view -late -max_paths 200 \
    > reports/ack_response_late_slow.rpt

puts "T0_PAA_POSTROUTE_ANALYSIS_DONE"
exit
