set script_dir [file dirname [file normalize [info script]]]
set project_root [file normalize [file join $script_dir ../..]]
set top aer_pending_gray_rank_reuse_sync_core_reset
set design_db [file join $project_root db ${top}_postroute.enc.dat]
set picture_file [file join $project_root outputs p9grr_180nm_innovus_postroute.png]
puts "P9GRR_CAPTURE_PROJECT_ROOT=$project_root"

if {![file exists $design_db]} {
    error "P9-GRR Innovus database not found: $design_db"
}

restoreDesign $design_db $top
after 5000 {set ::p9grr_gui_ready 1}
vwait ::p9grr_gui_ready
fit
redraw
after 2000 {set ::p9grr_layout_ready 1}
vwait ::p9grr_layout_ready
gui_dump_picture $picture_file -format PNG -width 1800 -height 1400
if {![file exists $picture_file]} {
    error "P9-GRR Innovus native PNG was not created"
}
puts "P9GRR_INNOVUS_NATIVE_CAPTURE_DONE=$picture_file"
exit
