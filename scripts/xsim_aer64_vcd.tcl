if {![info exists ::env(AER64_VCD_PATH)]} {error "AER64_VCD_PATH is required"}
open_vcd $::env(AER64_VCD_PATH)
log_vcd [get_objects -r /aer64_pending_rr_tb/grouped_dut/*]
log_vcd [get_objects -r /aer64_pending_rr_tb/iprra_dut/*]
run all
close_vcd
quit
