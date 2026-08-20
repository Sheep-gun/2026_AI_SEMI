if {![info exists ::env(AER_FAIR_VCD_PATH)]} {
    error "AER_FAIR_VCD_PATH is required"
}

open_vcd $::env(AER_FAIR_VCD_PATH)

# Log the wrapper and selected implementation only.  Testbench FIFOs and
# scoreboards are deliberately excluded so both VCDs describe the same DUT
# boundary and can be used for post-route activity experiments.
log_vcd [get_objects -r /aer_contract_fairness_tb/dut/*]

run all
close_vcd
quit
