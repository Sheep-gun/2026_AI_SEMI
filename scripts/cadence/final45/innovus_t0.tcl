foreach required_env {AER45_TOP AER45_NETLIST AER45_OUT AER45_VIEW AER45_SDC} {
    if {![info exists ::env($required_env)]} {error "$required_env is required"}
}
setMultiCpuUsage -localCpu 4
set pdk_root "$::env(HOME)/aer_2026/pdk45_digital"
set top $::env(AER45_TOP)
set netlist_file $::env(AER45_NETLIST)
set out_root $::env(AER45_OUT)
set report_dir [file join $out_root reports]
set output_dir [file join $out_root outputs]
set db_dir [file join $out_root db]
file mkdir $report_dir $output_dir $db_dir
set init_lef_file [list "$pdk_root/gsclib045/lef/gsclib045_tech.lef" "$pdk_root/gsclib045/lef/gsclib045_macro.lef"]
set init_verilog [list $netlist_file]
set init_top_cell $top
set init_pwr_net VDD
set init_gnd_net VSS
set init_mmmc_file $::env(AER45_VIEW)
init_design
setDesignMode -process 45
floorPlan -site CoreSite -r 1.0 0.60 5 5 5 5
set delay_count [llength [get_db insts *delay_cell*]]
set latch_count [expr {[llength [get_db insts *grant_latch*]]+[llength [get_db insts *busy_latch*]]}]
if {$delay_count!=6 || $latch_count!=5} {error "T0-45 physical cell count mismatch delay=$delay_count latch=$latch_count"}
set_dont_touch true [get_cells *delay_cell*]
set_dont_touch true [get_cells *grant_latch*]
set_dont_touch true [get_cells *busy_latch*]
set input_pins [list rst_n aer_ack]
set output_pins [list aer_req]
for {set i 0} {$i<16} {incr i} {
    lappend input_pins [format {src_req[%d]} $i]
    lappend output_pins [format {src_ack[%d]} $i]
}
for {set i 0} {$i<4} {incr i} {lappend output_pins [format {aer_addr[%d]} $i]}
editPin -pin $input_pins -side Left -layer Metal3 -spreadType SIDE -fixedPin
editPin -pin $output_pins -side Right -layer Metal3 -spreadType SIDE -fixedPin
globalNetConnect VDD -type pgpin -pin VDD -inst *
globalNetConnect VSS -type pgpin -pin VSS -inst *
addRing -nets {VDD VSS} -type core_rings -follow core \
    -layer {top Metal10 bottom Metal10 left Metal9 right Metal9} \
    -width {top 1.0 bottom 1.0 left 1.0 right 1.0} \
    -spacing {top 2.0 bottom 2.0 left 2.0 right 2.0} \
    -offset {top 1.0 bottom 1.0 left 1.0 right 1.0}
sroute -connect {corePin} -nets {VDD VSS}
place_design
optDesign -preCTS
setNanoRouteMode -routeBottomRoutingLayer 1
setNanoRouteMode -routeTopRoutingLayer 9
routeDesign
setExtractRCMode -engine postRoute -coupled true
extractRC
setAnalysisMode -checkType setup
report_area > [file join $report_dir postroute_area.rpt]
report_timing -max_paths 100 > [file join $report_dir postroute_timing.rpt]
report_power -outfile [file join $report_dir postroute_power.rpt]
verify_drc -report [file join $report_dir postroute_drc.rpt]
verifyConnectivity -type regular -report [file join $report_dir postroute_connectivity.rpt]
defOut -routing [file join $output_dir ${top}_postroute.def]
saveNetlist [file join $output_dir ${top}_postroute.v]
write_sdf [file join $output_dir ${top}_postroute.sdf]
rcOut -spef [file join $output_dir ${top}_postroute.spef]
saveDesign [file join $db_dir ${top}_postroute.enc] -rc
puts "T0_PAA_45NM_INNOVUS_DONE"
exit
