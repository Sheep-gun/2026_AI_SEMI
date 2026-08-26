foreach required_env {AER45_TOP AER45_DB AER45_SAIF AER45_REPORT} {
    if {![info exists ::env($required_env)]} {error "$required_env is required"}
}
set top $::env(AER45_TOP)
set db $::env(AER45_DB)
set saif $::env(AER45_SAIF)
set report $::env(AER45_REPORT)
foreach f [list $db $saif] {if {![file exists $f]} {error "AER45 SAIF input missing: $f"}}
restoreDesign $db $top
reset_power_activity
set_power_analysis_mode -analysis_view setup_view -method static -report_missing_nets true
read_activity_file $saif -format SAIF
report_power -outfile $report
puts "AER45_POSTROUTE_SAIF_DONE"
exit
