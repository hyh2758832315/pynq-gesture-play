# PYNQ-Z2 / Vivado2026.1, owned6044 on routed-restored-constraints-r01 only.
# Run: source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/optimize_latency_prewarm_reset.tcl
# Outputs: exclusive reset-fanout-r01 DCP, timing/setup/route/skew/XDC reports.
# Next: inspect real setup/hold/route and all signoff gates; no automatic bit export.
set pwbase {E:/projects/fpga/voice-view-game/build/hosd/c0e/prewarm-r01}
set pwout $pwbase/reset-fanout-r01
if {[file exists $pwout] || [get_property PART [current_design]] ne {xc7z020clg400-1}} {error {wrong fanout stage}}
set pwcell [get_cells -hier -regexp {c6v_i/rst_fclk0/U0/ACTIVE_LOW_PR_OUT_DFF\[0\]\.FDRE_PER_N}]
if {[llength $pwcell]!=1} {error {reset driver identity mismatch}}
set pwnet [get_nets -of_objects [get_pins -of_objects $pwcell -filter {REF_PIN_NAME == Q}]]
if {[llength $pwnet]!=1 || [llength [get_pins -leaf -of_objects $pwnet -filter {DIRECTION == IN}]]!=260} {error {reset topology drift}}
file mkdir $pwout
file copy [info script] $pwout/optimize_latency_prewarm_reset.tcl
set pwfp [open $pwout/target.tcldict {WRONLY CREAT EXCL}]
puts $pwfp [dict create source $pwcell net $pwnet loads 260 rationale {39 of40 worst paths, 10.741ns routed delay, -2.417ns WNS} reference {UG949 Use Physical Optimization}]
close $pwfp
phys_opt_design -force_replication_on_nets $pwnet
write_checkpoint $pwout/after_force.dcp
report_timing_summary -delay_type min_max -report_unconstrained -file $pwout/timing.rpt
report_timing -delay_type max -max_paths 40 -nworst 1 -path_type full_clock_expanded -input_pins -file $pwout/setup_paths.rpt
report_route_status -file $pwout/route.rpt
report_bus_skew -warn_on_violation -file $pwout/bus_skew.rpt
write_xdc -exclude_physical $pwout/effective_timing.xdc
puts C0E_PREWARM_TARGETED_RESET_REPLICATION_COMPLETE_REVIEW_REQUIRED
