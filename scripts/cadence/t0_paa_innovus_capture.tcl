restoreDesign db/aer_traditional_latch_paa_postroute.enc.dat \
    aer_traditional_latch_paa

after 5000 {set ::gui_ready 1}
vwait ::gui_ready
fit
redraw
after 2000 {set ::layout_ready 1}
vwait ::layout_ready

gui_dump_picture outputs/t0_paa_180nm_innovus_postroute.png \
    -format PNG -width 1800 -height 1400

if {![file exists outputs/t0_paa_180nm_innovus_postroute.png]} {
    error "Innovus native PNG was not created"
}
puts "T0_PAA_INNOVUS_NATIVE_CAPTURE_DONE"
exit
