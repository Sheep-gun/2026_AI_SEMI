set script_dir [file dirname [file normalize [info script]]]
set project_root [file normalize [file join $script_dir ../..]]
set top aer_pending_direct_gray_scr_onehot_tree
set design_db [file join $project_root db ${top}_postroute.enc.dat]
set saif_file [file join $project_root reports p9oht_contract_vcd p9oht_mapped_activity.saif]
set report_file [file join $project_root reports p9oht_pnr postroute_power_saif.rpt]

foreach required_file [list $design_db $saif_file] {
    if {![file exists $required_file]} {
        error "P9-OHT post-route SAIF input missing: $required_file"
    }
}

restoreDesign $design_db $top
reset_power_activity
set_power_analysis_mode \
    -analysis_view setup_view \
    -method static \
    -report_missing_nets true
read_activity_file $saif_file -format SAIF
report_power -outfile $report_file
puts "P9OHT_POSTROUTE_SAIF_POWER_DONE"
exit
