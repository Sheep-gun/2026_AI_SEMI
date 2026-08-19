setMultiCpuUsage -localCpu 4
set kit_root "$::env(HOME)/FPR"

set init_lef_file [list "$kit_root/lef/all.lef"]
set init_verilog [list "inputs/aer_traditional_latch_paa_pnr.v"]
set init_top_cell aer_traditional_latch_paa
set init_pwr_net VDD
set init_gnd_net VSS
set init_mmmc_file "scripts/t0_paa_pnr.view"

file mkdir reports outputs db
init_design
set delay_cells [get_cells *delay_cell*]
set_dont_touch true $delay_cells
puts "T0_PAA_INNOVUS_DELAY_CELLS_PROTECTED=[llength $delay_cells]"
setDesignMode -process 180
floorPlan -site tsm3site -r 1.0 0.60 20 20 20 20

set input_pins [list rst_n aer_ack]
set output_pins [list aer_req]
for {set i 0} {$i < 16} {incr i} {
    lappend input_pins [format {src_req[%d]} $i]
    lappend output_pins [format {src_ack[%d]} $i]
}
for {set i 0} {$i < 4} {incr i} {
    lappend output_pins [format {aer_addr[%d]} $i]
}
editPin -pin $input_pins -side Left -layer Metal3 -spreadType SIDE -fixedPin
editPin -pin $output_pins -side Right -layer Metal3 -spreadType SIDE -fixedPin

globalNetConnect VDD -type pgpin -pin VDD -inst *
globalNetConnect VSS -type pgpin -pin VSS -inst *
addRing -nets {VDD VSS} -type core_rings -follow core \
    -layer {top Metal6 bottom Metal6 left Metal5 right Metal5} \
    -width {top 2.0 bottom 2.0 left 2.0 right 2.0} \
    -spacing {top 1.0 bottom 1.0 left 1.0 right 1.0} \
    -offset {top 2.0 bottom 2.0 left 2.0 right 2.0}
sroute -connect {corePin} -nets {VDD VSS}

# There is no clock tree in the traditional self-timed baseline.
place_design

setNanoRouteMode -routeBottomRoutingLayer 1
setNanoRouteMode -routeTopRoutingLayer 6
routeDesign
setExtractRCMode -engine postRoute -coupled true
extractRC

report_area > reports/postroute_area.rpt
report_timing -max_paths 100 > reports/postroute_timing.rpt
report_timing -unconstrained -max_paths 100 > reports/postroute_unconstrained.rpt
report_power -outfile reports/postroute_power.rpt
verify_drc -report reports/postroute_drc.rpt
verifyConnectivity -type regular -report reports/postroute_connectivity.rpt

defOut -routing outputs/aer_traditional_latch_paa_postroute.def
saveNetlist outputs/aer_traditional_latch_paa_postroute.v
write_sdf outputs/aer_traditional_latch_paa_postroute.sdf
rcOut -spef outputs/aer_traditional_latch_paa_postroute.spef
saveDesign db/aer_traditional_latch_paa_postroute.enc -rc

puts "T0_PAA_INNOVUS_180NM_DONE"
exit
