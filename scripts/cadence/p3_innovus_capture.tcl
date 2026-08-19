restoreDesign db/aer_improved_depth1_postroute.enc.dat \
    aer_improved_depth1

# Xvfb 환경에서 Innovus GUI 캔버스가 완전히 그려질 때까지 기다린다.
after 5000 {set ::gui_ready 1}
vwait ::gui_ready
fit
redraw
after 2000 {set ::layout_ready 1}
vwait ::layout_ready

gui_dump_picture outputs/p3_180nm_innovus_postroute.png \
    -format PNG -width 1800 -height 1400

if {![file exists outputs/p3_180nm_innovus_postroute.png]} {
    error "Innovus native PNG was not created"
}
puts "P3_INNOVUS_NATIVE_CAPTURE_DONE"
exit
