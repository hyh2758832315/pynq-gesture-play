# Owned6044 on reset-route-r01, original clocks and bounded OSD CDC constraints restored.
# Run: source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/optimize_latency_prewarm_postroute.tcl
# Outputs: postroute-reset-r01 DCP and actual complete timing/setup/hold/route/skew/XDC reports.
# Next: all setup/hold/skew checks and scoped review; no automatic bit export or board load.
set pwout {E:/projects/fpga/voice-view-game/build/hosd/c0e/prewarm-r01/postroute-reset-r01}
if {[file exists $pwout] || [get_property PART [current_design]] ne {xc7z020clg400-1}} {error {wrong postroute stage}}
if {[get_property SLACK [get_timing_paths -delay_type max -max_paths 1]] != -0.404} {error {unexpected input timing}}
file mkdir $pwout
file copy [info script] $pwout/optimize_latency_prewarm_postroute.tcl
phys_opt_design -directive Explore
write_checkpoint $pwout/optimized.dcp
report_timing_summary -delay_type min_max -report_unconstrained -file $pwout/timing.rpt
report_timing -delay_type max -max_paths 40 -nworst 1 -path_type full_clock_expanded -input_pins -file $pwout/setup_paths.rpt
report_timing -delay_type min -max_paths 10 -nworst 1 -path_type full_clock_expanded -input_pins -file $pwout/hold_paths.rpt
report_route_status -file $pwout/route.rpt
report_bus_skew -warn_on_violation -file $pwout/bus_skew.rpt
write_xdc -exclude_physical $pwout/effective_timing.xdc
puts C0E_PREWARM_POSTROUTE_COMPLETE_ACTUAL_REPORTS_REQUIRED
