# PYNQ-Z2 / Vivado 2026.1, read-only optimized-design evidence.
# Run: source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/collect_latency_admission_opt_aliases.tcl
# Output: opt-review-r02/reset_scope_aliases.tcldict bound to its candidate.dcp.
# Next: audit exact XDC delta before resuming placement. No board operations.
set ::osd_report_dir {E:/projects/fpga/voice-view-game/build/hosd/c0e/admission-r01/opt-review-r02}
set ::latency_ext_dir $::osd_report_dir
if {[file exists $::osd_report_dir/reset_scope_aliases.tcldict]} {error {preserve evidence}}
open_checkpoint $::osd_report_dir/candidate.dcp
source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/collect_latency_reset_aliases.tcl
close_design
puts C0E_ADMISSION_OPT_ALIAS_PROOF_COMPLETE
