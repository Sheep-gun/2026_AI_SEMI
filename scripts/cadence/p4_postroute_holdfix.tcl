restoreDesign db/aer_improved_homeostatic_postroute.enc.dat \
    aer_improved_homeostatic
setAnalysisMode -analysisType onChipVariation
setOptMode -holdTargetSlack 0.005
optDesign -postRoute -hold
setExtractRCMode -engine postRoute -coupled true
extractRC
report_area > reports/postroute_area.rpt
report_timing -max_paths 20 > reports/postroute_timing.rpt
setAnalysisMode -checkType hold
report_timing -max_paths 20 > reports/postroute_hold_timing.rpt
setAnalysisMode -checkType setup
report_power -outfile reports/postroute_power.rpt
verify_drc -report reports/postroute_drc.rpt
verifyConnectivity -type regular -report reports/postroute_connectivity.rpt
defOut -routing outputs/aer_improved_homeostatic_postroute.def
saveNetlist outputs/aer_improved_homeostatic_postroute.v
write_sdf outputs/aer_improved_homeostatic_postroute.sdf
rcOut -spef outputs/aer_improved_homeostatic_postroute.spef
saveDesign db/aer_improved_homeostatic_postroute_holdfix.enc -rc
puts "P4_POSTROUTE_HOLDFIX_DONE"
exit
