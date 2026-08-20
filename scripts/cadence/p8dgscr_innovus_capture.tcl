set script_dir [file dirname [file normalize [info script]]]
set project_root [file normalize [file join $script_dir ../..]]
set design_db [file join $project_root db aer_pending_direct_gray_sync_core_reset_postroute.enc.dat]
set picture_file [file join $project_root outputs p8dgscr_180nm_innovus_postroute.png]

if {![file exists $design_db]} {
    error "P8-DG-SCR Innovus database not found: $design_db"
}

restoreDesign $design_db aer_pending_direct_gray_sync_core_reset
after 5000 {set ::gui_ready 1}
vwait ::gui_ready
fit
redraw
after 2000 {set ::layout_ready 1}
vwait ::layout_ready
gui_dump_picture $picture_file -format PNG -width 1800 -height 1400
if {![file exists $picture_file]} {
    error "P8-DG-SCR Innovus native PNG was not created"
}
puts "P8DGSCR_INNOVUS_NATIVE_CAPTURE_DONE"
exit
