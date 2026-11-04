# PYNQ-Z2/Vivado2026.1 owned6044; recover actual saved placement before routing.
# Run: source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/repair_latency_prewarm_placed_reset.tcl
# Output: placed-reset-repair-r01 snapshots and targeted fanout-optimized DCP/reports, no bit/board IO.
# Next: require exact signed-r05 XDC equivalence, then route and measure all setup/hold/skew gates.
set pwrepo {E:/projects/fpga/voice-view-game}
set pwout $pwrepo/build/hosd/c0e/prewarm-r01/placed-reset-repair-r01
if {![file isfile $pwout/input_placed.dcp] || [file exists $pwout/results]} {error {wrong placed-repair stage}}
file mkdir $pwout/results
file copy [info script] $pwout/repair_latency_prewarm_placed_reset.tcl
close_design
open_checkpoint $pwout/input_placed.dcp
source $pwrepo/build/hosd/c0d/postopt_osd.tcl
write_xdc -exclude_physical $pwout/results/effective_timing.xdc
report_timing_summary -delay_type min_max -file $pwout/results/before_timing.rpt
set pwcell [get_cells -hier -regexp {c6v_i/rst_fclk0/U0/ACTIVE_LOW_PR_OUT_DFF\[0\]\.FDRE_PER_N}]
if {[llength $pwcell]!=1} {error {wrong reset driver}}
set pwnet [get_nets -of_objects [get_pins -of_objects $pwcell -filter {REF_PIN_NAME == Q}]]
set pwfp [open $pwout/results/target.tcldict {WRONLY CREAT EXCL}]
puts $pwfp [dict create source $pwcell net $pwnet loads [llength [get_pins -leaf -of_objects $pwnet -filter {DIRECTION == IN}]]]
close $pwfp
phys_opt_design -force_replication_on_nets $pwnet
write_checkpoint $pwout/results/after_force_placed.dcp
report_timing_summary -delay_type min_max -file $pwout/results/after_force_timing.rpt
report_route_status -file $pwout/results/route.rpt
puts C0E_PREWARM_PLACED_RESET_REPLICATION_REQUIRES_ROUTING
