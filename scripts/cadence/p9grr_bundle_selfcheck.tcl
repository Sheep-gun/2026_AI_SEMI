set script_dir [file dirname [file normalize [info script]]]
set project_root [file normalize [file join $script_dir ../..]]
set expected_script_dir [file normalize \
    [file join $project_root scripts cadence]]
set phase [expr {[llength $argv] > 0 ? [lindex $argv 0] : "static"}]

if {$script_dir ne $expected_script_dir} {
    error "P9-GRR bundle layout is invalid: script_dir=$script_dir expected=$expected_script_dir"
}

set static_files [list \
    [file join $project_root rtl experiments aer_pending_gray_rank_reuse_sync_core_reset.sv] \
    [file join $project_root sim waves p9_grr_contract.vcd] \
    [file join $script_dir p9grr_genus_explore.tcl] \
    [file join $script_dir p9grr_genus_contract_vcd_power.tcl] \
    [file join $script_dir p9grr_postroute_saif_power.tcl] \
    [file join $script_dir p9grr_lec.tcl] \
    [file join $script_dir p9grr_pnr.sdc] \
    [file join $script_dir p9grr_pnr.view] \
    [file join $script_dir p9grr_innovus.tcl] \
    [file join $script_dir p9grr_innovus_capture.tcl] \
    [file join $script_dir p9grr_bundle_selfcheck.tcl] \
    [file join $script_dir P9GRR_FLOW_NOTES.md]]

foreach required_file $static_files {
    if {![file exists $required_file]} {
        error "P9-GRR static bundle input missing: $required_file"
    }
}

# Tcl parses a complete command before executing it.  `info complete` catches
# unbalanced braces, quotes, and command substitutions without requiring any
# Cadence command to exist in this standalone interpreter.  It also checks the
# SDC and MMMC view, which are Tcl dialect files.
set syntax_files [list \
    [file join $script_dir p9grr_genus_explore.tcl] \
    [file join $script_dir p9grr_genus_contract_vcd_power.tcl] \
    [file join $script_dir p9grr_postroute_saif_power.tcl] \
    [file join $script_dir p9grr_lec.tcl] \
    [file join $script_dir p9grr_pnr.sdc] \
    [file join $script_dir p9grr_pnr.view] \
    [file join $script_dir p9grr_innovus.tcl] \
    [file join $script_dir p9grr_innovus_capture.tcl] \
    [file join $script_dir p9grr_bundle_selfcheck.tcl]]
set forbidden_pwd_token [format {[%s]} pwd]
foreach syntax_file $syntax_files {
    set channel [open $syntax_file r]
    set contents [read $channel]
    close $channel
    if {![info complete $contents]} {
        error "P9-GRR Tcl syntax is incomplete: $syntax_file"
    }
    if {[string first $forbidden_pwd_token $contents] >= 0} {
        error "P9-GRR script uses forbidden pwd-based path: $syntax_file"
    }
}

if {$phase eq "post_genus" || $phase eq "post_innovus"} {
    set netlist_file [file join $project_root inputs \
        aer_pending_gray_rank_reuse_sync_core_reset_pnr.v]
    if {![file exists $netlist_file]} {
        error "P9-GRR mapped netlist missing after Genus: $netlist_file"
    }
}

if {$phase eq "post_innovus"} {
    set design_db [file join $project_root db \
        aer_pending_gray_rank_reuse_sync_core_reset_postroute.enc.dat]
    if {![file exists $design_db]} {
        error "P9-GRR Innovus database missing: $design_db"
    }
}

if {$phase ni {static post_genus post_innovus}} {
    error "Unknown P9-GRR self-check phase: $phase"
}

puts "P9GRR_BUNDLE_SELFCHECK_PHASE=$phase"
puts "P9GRR_BUNDLE_ROOT=$project_root"
puts "P9GRR_BUNDLE_SELFCHECK_PASS"
