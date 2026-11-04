# PYNQ-Z2 C0E, Vivado2026.1; source in owned non-project session6044.
# Command: source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/route_latency_r04.tcl
# Input: frozen copy of actual C0E placed DCP. Output: new pre-route optimization/routing DCPs and full reports.
# Next: assess timing/CDC/DRC/methodology; never deploy directly from this script.
set r04 {E:/projects/fpga/voice-view-game/build/hosd/c0e/preroute-r04}
if {![file isfile [file join $r04 input_placed.dcp]] || [file exists [file join $r04 results]]} {error {unexpected r04 stage}}
file mkdir [file join $r04 results]
set r04out [file join $r04 results]
close_design
open_checkpoint [file join $r04 input_placed.dcp]
if {[get_property PART [current_design]] ne {xc7z020clg400-1}} {error {wrong part}}
write_xdc -exclude_physical [file join $r04out constraints_before.xdc]
puts C0E_R04_POSTPLACE_AGGRESSIVE_START
phys_opt_design -directive AggressiveExplore
write_checkpoint [file join $r04out postplace_aggressive.dcp]
report_timing_summary -delay_type min_max -file [file join $r04out postplace_timing.rpt]
puts C0E_R04_ROUTE_EXPLORE_START
route_design -directive Explore -tns_cleanup
write_checkpoint [file join $r04out routed.dcp]
report_timing_summary -delay_type min_max -report_unconstrained -check_timing_verbose -file [file join $r04out timing_summary.rpt]
report_timing -delay_type max -max_paths 40 -nworst 1 -path_type full_clock_expanded -input_pins -file [file join $r04out setup_paths.rpt]
report_route_status -file [file join $r04out route_status.rpt]
report_methodology -json [file join $r04out methodology.json]
report_drc -file [file join $r04out drc.rpt]
report_utilization -hierarchical -file [file join $r04out utilization.rpt]
write_xdc -exclude_physical [file join $r04out constraints_after.xdc]
puts "C0E_R04_REPORTS_COMPLETE $r04out"
