setMultiCpuUsage -localCpu 4
set kit_root "$::env(HOME)/FPR"
set init_lef_file [list "$kit_root/lef/all.lef"]
set init_verilog [list "inputs/aer_pending_gray_epoch_pnr.v"]
set init_top_cell aer_pending_gray_epoch
set init_pwr_net VDD
set init_gnd_net VSS
set init_mmmc_file "scripts/p7ge_pnr.view"
file mkdir reports/p7ge_pnr outputs/p7ge_pnr db
init_design
setDesignMode -process 180
floorPlan -site tsm3site -r 1.0 0.60 20 20 20 20

set input_pins [list clk rst_n out_ready]
set output_pins [list out_valid]
for {set i 0} {$i < 16} {incr i} {
    lappend input_pins [format {src_req_async[%d]} $i]
    lappend output_pins [format {src_ack_async[%d]} $i]
}
for {set i 0} {$i < 4} {incr i} {
    lappend output_pins [format {out_addr[%d]} $i]
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

place_design
optDesign -preCTS
timeDesign -preCTS -outDir reports/p7ge_pnr/prects
clock_opt_design
optDesign -postCTS
setOptMode -holdTargetSlack 0.005
optDesign -postCTS -hold
timeDesign -postCTS -outDir reports/p7ge_pnr/postcts

setNanoRouteMode -routeBottomRoutingLayer 1
setNanoRouteMode -routeTopRoutingLayer 6
routeDesign
setAnalysisMode -analysisType onChipVariation
setOptMode -holdTargetSlack 0.005
optDesign -postRoute -hold
setExtractRCMode -engine postRoute -coupled true
extractRC

setAnalysisMode -checkType setup
report_area > reports/p7ge_pnr/postroute_area.rpt
report_timing -max_paths 50 > reports/p7ge_pnr/postroute_setup_timing.rpt
set recovery_status [catch {report_timing -check_type recovery -max_paths 20 > reports/p7ge_pnr/postroute_recovery_timing.rpt} recovery_message]
setAnalysisMode -checkType hold
report_timing -max_paths 50 > reports/p7ge_pnr/postroute_hold_timing.rpt
set removal_status [catch {report_timing -check_type removal -max_paths 20 > reports/p7ge_pnr/postroute_removal_timing.rpt} removal_message]
setAnalysisMode -checkType setup
report_power -outfile reports/p7ge_pnr/postroute_power.rpt
verify_drc -report reports/p7ge_pnr/postroute_drc.rpt
verifyConnectivity -type regular -report reports/p7ge_pnr/postroute_connectivity.rpt

set reset_report [open reports/p7ge_pnr/reset_timing_command_status.txt w]
puts $reset_report "recovery_command_status=$recovery_status"
puts $reset_report "recovery_command_message=$recovery_message"
puts $reset_report "removal_command_status=$removal_status"
puts $reset_report "removal_command_message=$removal_message"
close $reset_report

defOut -routing outputs/p7ge_pnr/aer_pending_gray_epoch_postroute.def
saveNetlist outputs/p7ge_pnr/aer_pending_gray_epoch_postroute.v
write_sdf outputs/p7ge_pnr/aer_pending_gray_epoch_postroute.sdf
rcOut -spef outputs/p7ge_pnr/aer_pending_gray_epoch_postroute.spef
saveDesign db/aer_pending_gray_epoch_postroute.enc -rc
puts "P7GE_INNOVUS_180NM_DONE"
exit
