setMultiCpuUsage -localCpu 4

set script_dir [file dirname [file normalize [info script]]]
set project_root [file normalize [file join $script_dir ../..]]
set kit_root "$::env(HOME)/FPR"
set top aer_pending_gray_rank_reuse_sync_core_reset
set netlist_file [file join $project_root inputs ${top}_pnr.v]
set view_file [file join $project_root scripts cadence p9grr_pnr.view]
set report_dir [file join $project_root reports p9grr_pnr]
set output_dir [file join $project_root outputs p9grr_pnr]
set db_dir [file join $project_root db]
puts "P9GRR_INNOVUS_PROJECT_ROOT=$project_root"

foreach required_file [list $netlist_file $view_file] {
    if {![file exists $required_file]} {
        error "P9-GRR Innovus input not found: $required_file"
    }
}

file mkdir $report_dir $output_dir $db_dir
set init_lef_file [list "$kit_root/lef/all.lef"]
set init_verilog [list $netlist_file]
set init_top_cell $top
set init_pwr_net VDD
set init_gnd_net VSS
set init_mmmc_file $view_file
init_design
setDesignMode -process 180
floorPlan -site tsm3site -r 1.0 0.60 20 20 20 20

# Genus does not preserve ASYNC_REG semantics by itself in this tool release.
# Assert the exact 34-cell CDC/reset-release set, preserve it, and create 17
# soft physical groups.  The SDC independently constrains pair data delay.
set synchronizer_cells [concat \
    [get_cells *req_meta_q_reg*] \
    [get_cells *req_sync_q_reg*] \
    [get_cells *reset_release_q_reg*]]
set synchronizer_count [llength $synchronizer_cells]
puts "P9GRR_INNOVUS_SYNCHRONIZER_CELLS_FOUND=$synchronizer_count"
if {$synchronizer_count != 34} {
    error "P9-GRR Innovus expected 34 synchronizer/reset-release cells; found $synchronizer_count"
}
set_dont_touch true $synchronizer_cells
for {set i 0} {$i < 16} {incr i} {
    set group_name [format {cdc_pair_%02d} $i]
    createInstGroup $group_name -softGuide -ar 1.0 -density 0.5
    addInstToInstGroup $group_name [list \
        [format {req_meta_q_reg[%d]} $i] \
        [format {req_sync_q_reg[%d]} $i]]
}
createInstGroup reset_release_pair -softGuide -ar 1.0 -density 0.5
addInstToInstGroup reset_release_pair \
    [list {reset_release_q_reg[0]} {reset_release_q_reg[1]}]
puts "P9GRR_CDC_PHYSICAL_GROUPS_CREATED=17"

set input_pins [list clk rst_n out_ready]
set output_pins [list out_valid]
for {set i 0} {$i < 16} {incr i} {
    lappend input_pins [format {src_req_async[%d]} $i]
    lappend output_pins [format {src_ack_async[%d]} $i]
}
for {set i 0} {$i < 4} {incr i} {
    lappend output_pins [format {out_addr[%d]} $i]
}
editPin -pin $input_pins -side Left -layer Metal3 \
    -spreadType SIDE -fixedPin
editPin -pin $output_pins -side Right -layer Metal3 \
    -spreadType SIDE -fixedPin

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
timeDesign -preCTS -outDir [file join $report_dir prects]
set_ccopt_property source_max_capacitance 0.250
clock_opt_design
optDesign -postCTS
setOptMode -holdTargetSlack 0.020
optDesign -postCTS -hold
timeDesign -postCTS -outDir [file join $report_dir postcts]

setNanoRouteMode -routeBottomRoutingLayer 1
setNanoRouteMode -routeTopRoutingLayer 6
routeDesign
setAnalysisMode -analysisType onChipVariation
setOptMode -holdTargetSlack 0.020
optDesign -postRoute -hold
setExtractRCMode -engine postRoute -coupled true
extractRC

setAnalysisMode -checkType setup
report_area > [file join $report_dir postroute_area.rpt]
report_timing -max_paths 50 > \
    [file join $report_dir postroute_setup_timing.rpt]
report_timing \
    -from [get_pins {req_sync_q_reg*/Q*}] \
    -max_paths 50 > \
    [file join $report_dir postroute_core_setup_timing.rpt]
report_timing \
    -from [get_pins {req_meta_q_reg*/Q}] \
    -to [get_pins {req_sync_q_reg*/D}] \
    -max_paths 32 > \
    [file join $report_dir postroute_cdc_setup_timing.rpt]
set recovery_status [catch {
    report_timing -check_type recovery -max_paths 20 > \
        [file join $report_dir postroute_recovery_timing.rpt]
} recovery_message]

setAnalysisMode -checkType hold
report_timing -max_paths 50 > \
    [file join $report_dir postroute_hold_timing.rpt]
report_timing \
    -from [get_pins {req_meta_q_reg*/Q}] \
    -to [get_pins {req_sync_q_reg*/D}] \
    -max_paths 32 > \
    [file join $report_dir postroute_cdc_hold_timing.rpt]
set removal_status [catch {
    report_timing -check_type removal -max_paths 20 > \
        [file join $report_dir postroute_removal_timing.rpt]
} removal_message]

setAnalysisMode -checkType setup
report_power -outfile [file join $report_dir postroute_power.rpt]
verify_drc -report [file join $report_dir postroute_drc.rpt]
verifyConnectivity -type regular \
    -report [file join $report_dir postroute_connectivity.rpt]
report_ccopt_clock_trees -summary -num_cap_violating_pins 20 \
    -file [file join $report_dir postroute_clock_tree.rpt]

set cdc_report [open [file join $report_dir cdc_pair_placement.rpt] w]
puts $cdc_report "source meta_location sync_location manhattan_um"
set max_cdc_manhattan 0.0
for {set i 0} {$i < 16} {incr i} {
    set meta_name [format {req_meta_q_reg[%d]} $i]
    set sync_name [format {req_sync_q_reg[%d]} $i]
    set meta_location [get_db [get_db insts $meta_name] .location]
    set sync_location [get_db [get_db insts $sync_name] .location]
    set manhattan [expr {
        abs([lindex $meta_location 0 0] - [lindex $sync_location 0 0]) +
        abs([lindex $meta_location 0 1] - [lindex $sync_location 0 1])
    }]
    if {$manhattan > $max_cdc_manhattan} {
        set max_cdc_manhattan $manhattan
    }
    puts $cdc_report \
        "$i [lindex $meta_location 0] [lindex $sync_location 0] $manhattan"
}
puts $cdc_report "max_manhattan_um=$max_cdc_manhattan"
close $cdc_report
puts "P9GRR_MAX_CDC_MANHATTAN_UM=$max_cdc_manhattan"

set reset_report [open \
    [file join $report_dir reset_timing_command_status.txt] w]
puts $reset_report "recovery_command_status=$recovery_status"
puts $reset_report "recovery_command_message=$recovery_message"
puts $reset_report "removal_command_status=$removal_status"
puts $reset_report "removal_command_message=$removal_message"
puts $reset_report \
    "expected_async_reset=reset_release_q\[1:0\] (2 FF only)"
puts $reset_report \
    "expected_resetless=req_meta_q\[15:0\],req_sync_q\[15:0\] (32 FF)"
puts $reset_report \
    "expected_sync_clear=ack_rank_q\[15:0\],pending_rank_q\[15:0\],out_rank_q\[3:0\],out_valid_q (37 FF)"
puts $reset_report \
    "note=Only reset_release_q has recovery/removal arcs; core initialization is checked as data setup/hold."
close $reset_report

defOut -routing [file join $output_dir ${top}_postroute.def]
saveNetlist [file join $output_dir ${top}_postroute.v]
write_sdf [file join $output_dir ${top}_postroute.sdf]
rcOut -spef [file join $output_dir ${top}_postroute.spef]
saveDesign [file join $db_dir ${top}_postroute.enc] -rc
puts "P9GRR_INNOVUS_180NM_DONE"
exit
