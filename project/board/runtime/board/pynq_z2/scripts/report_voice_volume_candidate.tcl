set volume_repo [file normalize [file join [file dirname [info script]] .. .. ..]]
set volume_evidence [file join $volume_repo results game-validation voice-volume-only-20261019]
if {[info exists ::env(VOLUME_EVIDENCE_ROOT)]} {set volume_evidence [file normalize $::env(VOLUME_EVIDENCE_ROOT)]}
file mkdir $volume_evidence
report_methodology -file [file join $volume_evidence routed-methodology.rpt]
report_timing_summary -report_unconstrained -max_paths 10 -file [file join $volume_evidence routed-timing.rpt]
report_utilization -hierarchical -file [file join $volume_evidence routed-util.rpt]
report_drc -file [file join $volume_evidence routed-drc.rpt]
report_cdc -details -file [file join $volume_evidence routed-cdc.rpt]
report_clocks -file [file join $volume_evidence routed-clocks.rpt]
report_route_status -file [file join $volume_evidence routed-status.rpt]
check_timing -verbose -file [file join $volume_evidence routed-check-timing.rpt]
write_xdc -exclude_physical [file join $volume_evidence routed-effective.xdc]
if {[llength [get_timing_paths -quiet -delay_type max -slack_lesser_than 0]] ||
    [llength [get_timing_paths -quiet -delay_type min -slack_lesser_than 0]]} {error VOLUME_TIMING_FAILED}
if {[llength [get_drc_violations -quiet -filter {SEVERITY == Error || SEVERITY == {Critical Warning}}]]} {error VOLUME_DRC_FAILED}
if {[llength [get_methodology_violations -quiet -filter {SEVERITY == Error || SEVERITY == {Critical Warning}}]]} {error VOLUME_METHODOLOGY_FAILED}
if {[llength [get_clocks clk_fpga_0]] != 1 || [get_property PERIOD [get_clocks clk_fpga_0]] != 10.0} {error VOLUME_CLOCK_FAILED}
if {[llength [get_clocks audio_bclk]] != 1 || [get_property PERIOD [get_clocks audio_bclk]] != 320.0} {error VOLUME_BCLK_FAILED}
if {[llength [get_pins -hier -regexp {.*receiver/sdata_sync_reg\[0\]/D}]] != 1} {error VOLUME_SYNC_TARGET_FAILED}
puts VOLUME_ROUTED_GATES_PASS