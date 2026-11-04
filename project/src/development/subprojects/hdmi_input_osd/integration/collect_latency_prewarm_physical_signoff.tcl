# Owned non-project6044 on exact postroute-reset-r01/optimized.dcp state, Vivado2026.1/PYNQ-Z2.
# Run: source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/collect_latency_prewarm_physical_signoff.tcl
# Outputs: prewarm-r01/signoff and extended complete reports/DCP/source bindings/reset-selector proof.
# Next: independent scoped audit with the new numeric receipt, then export the exact reviewed DCP only.
if {[get_property PART [current_design]] ne {xc7z020clg400-1}} {error {wrong part}}
if {[get_property SLACK [get_timing_paths -delay_type max -max_paths 1]] != 0.003 || [get_property SLACK [get_timing_paths -delay_type min -max_paths 1]] != 0.051} {error {wrong optimized input}}
set pwdir {E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration}
set pwroot {E:/projects/fpga/voice-view-game/build/hosd/c0e/prewarm-r01}
set ::osd_report_dir $pwroot/signoff
source $pwdir/collect_reports.tcl
set ::latency_ext_dir $pwroot/extended
source $pwdir/collect_latency_extended.tcl
file copy $pwroot/project_synthesis_files.txt $pwroot/extended/project_synthesis_files.txt
source $pwdir/collect_latency_reset_aliases.tcl
file copy [info script] $pwroot/collect_latency_prewarm_physical_signoff.tcl
puts C0E_PREWARM_PHYSICAL_COMPLETE_REPORTS_READY_FOR_SCOPED_AUDIT
