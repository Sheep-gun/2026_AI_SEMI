restoreDesign db/aer_improved_cutthrough_postroute.enc.dat \
    aer_improved_cutthrough
after 5000 {set ::gui_ready 1}
vwait ::gui_ready
fit
redraw
after 2000 {set ::layout_ready 1}
vwait ::layout_ready
gui_dump_picture outputs/p4c_180nm_innovus_postroute.png \
    -format PNG -width 1800 -height 1400
if {![file exists outputs/p4c_180nm_innovus_postroute.png]} {
    error "Innovus native PNG was not created"
}
puts "P4C_INNOVUS_NATIVE_CAPTURE_DONE"
exit
