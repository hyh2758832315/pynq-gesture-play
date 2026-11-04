# Run after opening the exact implemented/physopt design, not an old run.
# set ::osd_report_dir E:/.../build/hosd/c0d/signoff-r02
# source .../integration/collect_reports.tcl
# Produces complete reports + candidate.dcp; no bitstream or board IO.
# Next: review all gates, then separately export the same current design.
if {![info exists ::osd_report_dir]} {error "set an exclusive osd_report_dir"}
set dest [file normalize $::osd_report_dir]
if {[file exists $dest]} {error "preserve previous reports: $dest"}
file mkdir $dest
write_checkpoint $dest/candidate.dcp
report_timing_summary -delay_type min_max -report_unconstrained -max_paths 20 -file $dest/timing.rpt
report_timing -delay_type max -max_paths 20 -input_pins -file $dest/worst_setup.rpt
report_timing -delay_type min -max_paths 10 -input_pins -file $dest/worst_hold.rpt
report_route_status -file $dest/route.rpt
report_drc -file $dest/drc.rpt
report_methodology -file $dest/methodology.rpt
report_cdc -details -file $dest/cdc.rpt
report_bus_skew -warn_on_violation -file $dest/bus_skew.rpt
report_clock_interaction -file $dest/clock_interaction.rpt
report_exceptions -file $dest/exceptions.rpt
report_utilization -hierarchical -file $dest/utilization_hier.rpt
report_utilization -file $dest/utilization.rpt
report_clocks -file $dest/clocks.rpt
write_xdc -exclude_physical $dest/effective_timing.xdc
set setup [get_timing_paths -delay_type max -max_paths 1]
set hold [get_timing_paths -delay_type min -max_paths 1]
set report [dict create design [current_design] report_dir $dest \
    wns [get_property SLACK $setup] whs [get_property SLACK $hold] \
    setup_start [get_property STARTPOINT_PIN $setup] setup_end [get_property ENDPOINT_PIN $setup]]
set fp [open $dest/summary.tcldict {WRONLY CREAT EXCL}]
puts $fp $report
close $fp
puts "OSD_REPORTS_COLLECTED $report"
