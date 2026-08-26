foreach required_env {AER45_RTL AER45_NETLIST AER45_TOP AER45_OUT AER45_TAG} {
    if {![info exists ::env($required_env)]} {error "$required_env is required"}
}
tclmode
set_screen_display -noprogress
set_dofile_abort exit
set rtl $::env(AER45_RTL)
set netlist $::env(AER45_NETLIST)
set top $::env(AER45_TOP)
set out $::env(AER45_OUT)
set tag $::env(AER45_TAG)
set lib "$::env(HOME)/aer_2026/pdk45_digital/gsclib045/timing/slow_vdd1v0_basicCells.lib"
set mbff_lib "$::env(HOME)/aer_2026/pdk45_digital/gsclib045/timing/slow_vdd1v0_multibitsDFF.lib"
foreach f [list $rtl $netlist $lib] {if {![file exists $f]} {error "AER45 LEC input missing: $f"}}
file mkdir $out
set_log_file [file join $out lec.rpt] -replace
set_mapping_method -sensitive
set_undefined_cell black_box -noascend -both
read_library -liberty -both -append $lib
if {[info exists ::env(AER45_USE_MBFF)] && $::env(AER45_USE_MBFF)==1} {
    read_library -liberty -both -append $mbff_lib
}
read_design -systemverilog -golden -lastmod -noelab $rtl
elaborate_design -golden -root $top
read_design -verilog95 -revised -lastmod -noelab $netlist
elaborate_design -revised -root $top
set_flatten_model -seq_constant
set_flatten_model -hier_seq_merge
set_flatten_model -gated_clock
set_system_mode lec
report_unmapped_points -summary
add_compared_points -all
compare
report_verification -verbose
report_statistics
set noneq [get_compare_points -NONequivalent -count]
set abort [get_compare_points -abort -count]
set unknown [get_compare_points -unknown -count]
puts "AER45_LEC_COUNTS tag=$tag noneq=$noneq abort=$abort unknown=$unknown"
if {$noneq>0||$abort>0||$unknown>0} {error "$tag LEC failed"}
puts "AER45_LEC_PASS tag=$tag"
exit 0
