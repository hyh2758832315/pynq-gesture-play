# Included by build_hardware.tcl after opening the routed checkpoint outside the project.
# Requires result_dir. Outputs final timing/DRC/resources and paired hardware files.
# Preserve the complete routed solution; route corrections require a measured failing path.
# Next: require signoff checks and verify exported bit/HWH before any deployment.
# Do not call from open_run: include_bit can use the run's earlier uncorrected bit.
if {![info exists result_dir]} {error {result_dir required}}
file mkdir $result_dir
# Run acceptance checks on the post-route checkpoint without changing routing.
report_timing_summary -delay_type min_max -report_unconstrained -file $result_dir/timing.rpt
report_drc -file $result_dir/drc.rpt
report_route_status -file $result_dir/route.rpt
report_bus_skew -warn_on_violation -file $result_dir/bus_skew.rpt
report_cdc -details -file $result_dir/cdc.rpt
report_utilization -file $result_dir/utilization.rpt
foreach kind {max min} {
    set path [get_timing_paths -delay_type $kind -max_paths 1]
    if {[llength $path] != 1 || [get_property SLACK $path] < 0} {error "Timing failed: $kind"}
}
if {[llength [get_drc_violations -filter {SEVERITY == "Error" || SEVERITY == "Critical Warning"}]]} {error {DRC failed}}
set report_handle [open $result_dir/timing.rpt r]
set timing_text [read $report_handle]
close $report_handle
set summary [string range $timing_text [string first {Design Timing Summary} $timing_text] end]
if {![regexp {\n\s*(-?[0-9]+\.[0-9]+)\s+(-?[0-9]+\.[0-9]+)\s+[0-9]+\s+[0-9]+\s+(-?[0-9]+\.[0-9]+)\s+(-?[0-9]+\.[0-9]+)\s+[0-9]+\s+[0-9]+\s+(-?[0-9]+\.[0-9]+)\s+(-?[0-9]+\.[0-9]+)} $summary -> wns tns whs ths wpws tpws]} {error {Missing timing summary}}
foreach slack [list $wns $tns $whs $ths $wpws $tpws] {if {$slack < 0} {error {Timing/pulse-width failure}}}
set report_handle [open $result_dir/route.rpt r]
set route_text [read $report_handle]
close $report_handle
if {![regexp {nets with routing errors\.*\s*:\s*0\s*:} $route_text]} {error {Routing incomplete}}
write_checkpoint $result_dir/candidate.dcp
write_bitstream $result_dir/c6v_candidate.bit
write_hw_platform -fixed -include_bit -file $result_dir/c6v_candidate.xsa
puts TIMING_REBUILD_READY_FOR_INTERFACE_VALIDATION
