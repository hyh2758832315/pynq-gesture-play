# Owned session6044, exact completed routed-diagnostic-r01 input already open.
# Run: source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/restore_latency_prewarm_constraints.tcl
# Outputs: new restored-constraints DCP, full timing/setup/CDC/skew/effective-XDC reports; no bit or board IO.
# Next: require exact effective-XDC equivalence with signed r05, then assess real remaining timing failures.
set pwrepo {E:/projects/fpga/voice-view-game}
set pwroot $pwrepo/build/hosd/c0e/prewarm-r01
set pwout $pwroot/routed-restored-constraints-r01
if {[file exists $pwout] || [get_property PART [current_design]] ne {xc7z020clg400-1}} {error {wrong restore stage}}
set pwsrc [get_cells -hier -regexp {c6v_i/input_osd_0/inst/impl/ctrl/mailbox_reg\[.*\]}]
set pwdst [get_cells -hier -regexp {c6v_i/input_osd_0/inst/impl/ctrl/pending_cfg_reg\[.*\]}]
if {[llength $pwsrc]!=135 || [llength $pwdst]!=135} {error {OSD endpoint identity mismatch}}
file mkdir $pwout
file copy [info script] $pwout/restore_latency_prewarm_constraints.tcl
file copy $pwrepo/build/hosd/c0d/postopt_osd.tcl $pwout/postopt_osd.tcl
file copy $pwrepo/build/hosd/c0d/postopt_parent.tcl $pwout/postopt_parent.tcl
file copy $pwrepo/build/hosd/c0d/osd_cdc.tcl $pwout/osd_cdc.tcl
source $pwrepo/build/hosd/c0d/postopt_osd.tcl
write_xdc -exclude_physical $pwout/effective_timing.xdc
write_checkpoint $pwout/candidate.dcp
report_timing_summary -delay_type min_max -report_unconstrained -file $pwout/timing.rpt
report_timing -delay_type max -max_paths 40 -nworst 1 -path_type full_clock_expanded -input_pins -file $pwout/setup_paths.rpt
report_cdc -details -file $pwout/cdc.rpt
report_bus_skew -warn_on_violation -file $pwout/bus_skew.rpt
puts C0E_PREWARM_PARENT_HOOK_RESTORED_REQUIRE_XDC_DIFF_AND_STA
