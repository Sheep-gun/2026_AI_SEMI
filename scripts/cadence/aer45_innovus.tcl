foreach required_env {AER45_TOP AER45_TAG AER45_NETLIST AER45_OUT AER45_VIEW AER45_SDC AER45_SYNC_FF AER45_HOLD_TARGET AER45_NUM_SOURCES AER45_ADDR_W} {
    if {![info exists ::env($required_env)]} {error "$required_env is required"}
}
setMultiCpuUsage -localCpu 4
set pdk_root "$::env(HOME)/aer_2026/pdk45_digital"
set top $::env(AER45_TOP)
set tag $::env(AER45_TAG)
set netlist_file $::env(AER45_NETLIST)
set out_root $::env(AER45_OUT)
set view_file $::env(AER45_VIEW)
set expected_sync $::env(AER45_SYNC_FF)
set hold_target $::env(AER45_HOLD_TARGET)
set num_sources $::env(AER45_NUM_SOURCES)
set addr_w $::env(AER45_ADDR_W)
set report_dir [file join $out_root reports]
set output_dir [file join $out_root outputs]
set db_dir [file join $out_root db]
foreach f [list $netlist_file $view_file \
    "$pdk_root/gsclib045/lef/gsclib045_tech.lef" \
    "$pdk_root/gsclib045/lef/gsclib045_macro.lef" \
    "$pdk_root/gsclib045/lef/gsclib045_multibitsDFF.lef"] {
    if {![file exists $f]} {error "AER45 Innovus input missing: $f"}
}
file mkdir $report_dir $output_dir $db_dir
set init_lef_file [list \
    "$pdk_root/gsclib045/lef/gsclib045_tech.lef" \
    "$pdk_root/gsclib045/lef/gsclib045_macro.lef" \
    "$pdk_root/gsclib045/lef/gsclib045_multibitsDFF.lef"]
set init_verilog [list $netlist_file]
set init_top_cell $top
set init_pwr_net VDD
set init_gnd_net VSS
set init_mmmc_file $view_file
init_design
setDesignMode -process 45
floorPlan -site CoreSite -r 1.0 0.60 5 5 5 5

set synchronizer_count [expr {
    [llength [get_db insts *req_meta_q_reg*]]+
    [llength [get_db insts *req_sync_q_reg*]]+
    [llength [get_db insts *reset_release_q_reg*]]
}]
puts "AER45_INNOVUS_SYNCHRONIZER_COUNT=$synchronizer_count expected=$expected_sync"
if {$synchronizer_count!=$expected_sync} {error "$tag synchronizer count mismatch"}
set_dont_touch true [get_cells *req_meta_q_reg*]
set_dont_touch true [get_cells *req_sync_q_reg*]
set_dont_touch true [get_cells *reset_release_q_reg*]

set input_pins [list clk rst_n out_ready]
set output_pins [list out_valid]
for {set i 0} {$i<$num_sources} {incr i} {
    lappend input_pins [format {src_req_async[%d]} $i]
    lappend output_pins [format {src_ack_async[%d]} $i]
}
for {set i 0} {$i<$addr_w} {incr i} {lappend output_pins [format {out_addr[%d]} $i]}
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
clock_opt_design
optDesign -postCTS
setOptMode -holdTargetSlack $hold_target
optDesign -postCTS -hold
setNanoRouteMode -routeBottomRoutingLayer 1
setNanoRouteMode -routeTopRoutingLayer 9
routeDesign
setAnalysisMode -analysisType onChipVariation
setOptMode -holdTargetSlack $hold_target
optDesign -postRoute -hold
setExtractRCMode -engine postRoute -coupled true
extractRC

setAnalysisMode -checkType setup
report_area > [file join $report_dir postroute_area.rpt]
report_timing -max_paths 100 > [file join $report_dir postroute_setup_timing.rpt]
report_timing -from [get_pins -hierarchical *req_sync_q_reg*/Q*] -max_paths 100 > [file join $report_dir postroute_core_setup_timing.rpt]
report_timing -from [get_pins -hierarchical *req_meta_q_reg*/Q] -to [get_pins -hierarchical *req_sync_q_reg*/D] -max_paths 256 > [file join $report_dir postroute_cdc_setup_timing.rpt]
catch {report_timing -check_type recovery -max_paths 20 > [file join $report_dir postroute_recovery_timing.rpt]}
setAnalysisMode -checkType hold
report_timing -max_paths 100 > [file join $report_dir postroute_hold_timing.rpt]
report_timing -from [get_pins -hierarchical *req_meta_q_reg*/Q] -to [get_pins -hierarchical *req_sync_q_reg*/D] -max_paths 256 > [file join $report_dir postroute_cdc_hold_timing.rpt]
catch {report_timing -check_type removal -max_paths 20 > [file join $report_dir postroute_removal_timing.rpt]}
setAnalysisMode -checkType setup
report_power -outfile [file join $report_dir postroute_power.rpt]
verify_drc -report [file join $report_dir postroute_drc.rpt]
verifyConnectivity -type regular -report [file join $report_dir postroute_connectivity.rpt]
report_ccopt_clock_trees -summary -num_cap_violating_pins 20 -file [file join $report_dir postroute_clock_tree.rpt]
defOut -routing [file join $output_dir ${top}_postroute.def]
saveNetlist [file join $output_dir ${top}_postroute.v]
write_sdf [file join $output_dir ${top}_postroute.sdf]
rcOut -spef [file join $output_dir ${top}_postroute.spef]
saveDesign [file join $db_dir ${top}_postroute.enc] -rc
puts "AER45_INNOVUS_DONE tag=$tag top=$top hold_target=$hold_target"
exit
