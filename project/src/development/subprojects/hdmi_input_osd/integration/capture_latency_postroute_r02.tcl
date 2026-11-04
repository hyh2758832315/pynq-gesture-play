# C0E post-route Explore-r02 evidence capture, Vivado 2026.1.
# Run only in owned session vivado-20261022-232226-f395dc09 with its optimized design still open.
# Command: source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/capture_latency_postroute_r02.tcl
# Outputs: immutable optimized DCP, timing/methodology/utilization/route reports, effective XDC.
# Next: inspect actual remaining paths before choosing another physical or RTL change. No bit/export.
set out {E:/projects/fpga/voice-view-game/build/hosd/c0e/postroute-r02/results}
if {[file exists $out]} {error {refuse existing evidence directory}}
if {[get_property PART [current_design]] ne {xc7z020clg400-1}} {error {wrong part}}
file mkdir $out
write_checkpoint [file join $out c0e_postroute_explore.dcp]
report_timing_summary -delay_type min_max -report_unconstrained -check_timing_verbose -file [file join $out timing_summary.rpt]
report_timing -delay_type max -max_paths 40 -nworst 1 -path_type full_clock_expanded -input_pins -nets -file [file join $out setup_paths.rpt]
report_methodology -json [file join $out methodology.json]
report_utilization -hierarchical -file [file join $out utilization.rpt]
report_route_status -file [file join $out route_status.rpt]
write_xdc -exclude_physical [file join $out constraints.xdc]
puts "C0E_POSTROUTE_R02_EVIDENCE $out"

