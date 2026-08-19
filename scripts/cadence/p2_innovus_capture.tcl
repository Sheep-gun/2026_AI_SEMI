restoreDesign db/aer_improved_hierarchical_postroute.enc.dat \
    aer_improved_hierarchical

# When run through Xvfb, wait for the GUI layout canvas to finish painting.
after 5000 {set ::gui_ready 1}
vwait ::gui_ready
fit
redraw
after 2000 {set ::layout_ready 1}
vwait ::layout_ready

gui_dump_picture outputs/p2_180nm_innovus_native.png \
    -format PNG -width 1800 -height 1400

if {![file exists outputs/p2_180nm_innovus_native.png]} {
    error "Innovus native PNG was not created"
}
puts "P2_INNOVUS_NATIVE_CAPTURE_DONE"
exit
