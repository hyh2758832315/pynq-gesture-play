# Owned6044 on exact after_force_placed.dcp state; original1322 active constraints verified identical.
# Run: source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/route_latency_prewarm_reset.tcl
# Output: reset-route-r01 routed DCP, full setup/hold/timing/route/skew/constraints. No bit/board access.
# Next: inspect real routing and timing, then independent full signoff only if setup/hold pass.
set pwout {E:/projects/fpga/voice-view-game/build/hosd/c0e/prewarm-r01/reset-route-r01}
if {[file exists $pwout] || [get_property PART [current_design]] ne {xc7z020clg400-1}} {error {wrong reset-route stage}}
file mkdir $pwout
file copy [info script] $pwout/route_latency_prewarm_reset.tcl
route_design -directive Explore -tns_cleanup
write_checkpoint $pwout/routed.dcp
report_timing_summary -delay_type min_max -report_unconstrained -file $pwout/timing.rpt
report_timing -delay_type max -max_paths 40 -nworst 1 -path_type full_clock_expanded -input_pins -file $pwout/setup_paths.rpt
report_timing -delay_type min -max_paths 10 -nworst 1 -path_type full_clock_expanded -input_pins -file $pwout/hold_paths.rpt
report_route_status -file $pwout/route.rpt
report_bus_skew -warn_on_violation -file $pwout/bus_skew.rpt
write_xdc -exclude_physical $pwout/effective_timing.xdc
puts C0E_PREWARM_RESET_ROUTE_REPORTS_READY_REVIEW_REQUIRED
