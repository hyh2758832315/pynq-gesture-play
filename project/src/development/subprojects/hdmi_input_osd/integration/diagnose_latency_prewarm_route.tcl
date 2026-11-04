# Owned non-project session6044; does not touch the project run or board.
# Run: source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/diagnose_latency_prewarm_route.tcl
# Input: exclusive completed routed checkpoint snapshot. Outputs: full clock-expanded setup paths and summary.
# Next: classify actual critical paths before changing RTL or implementation settings.
set pwdiag {E:/projects/fpga/voice-view-game/build/hosd/c0e/prewarm-r01/routed-diagnostic-r01}
if {![file isfile $pwdiag/input.dcp] || [file exists $pwdiag/results]} {error {unexpected diagnostic stage}}
file mkdir $pwdiag/results
file copy [info script] $pwdiag/diagnose_latency_prewarm_route.tcl
close_design
open_checkpoint $pwdiag/input.dcp
if {[get_property PART [current_design]] ne {xc7z020clg400-1}} {error {wrong part}}
report_timing_summary -delay_type min_max -report_unconstrained -file $pwdiag/results/timing.rpt
report_timing -delay_type max -max_paths 40 -nworst 1 -path_type full_clock_expanded -input_pins -file $pwdiag/results/setup_paths.rpt
report_route_status -file $pwdiag/results/route.rpt
write_xdc -exclude_physical $pwdiag/results/effective_timing.xdc
puts C0E_PREWARM_ROUTED_DIAGNOSTIC_PATHS_READY_NOT_FINAL
