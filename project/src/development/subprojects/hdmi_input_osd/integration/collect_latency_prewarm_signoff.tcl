# PYNQ-Z2 / Vivado 2026.1; run only after impl_prewarm_r01 has completed and is open.
# Command: open_run impl_prewarm_r01
# Then: source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/collect_latency_prewarm_signoff.tcl
# Outputs: prewarm-r01/signoff and extended with complete reports, DCP and actual synthesis-source list.
# Next: scoped review/audit with the prewarm numeric receipt; do not reuse the old r05 verdict.
if {[file normalize [get_property DIRECTORY [current_project]]] ne {E:/vvl/c0e}} {error {wrong project}}
if {[get_property PROGRESS [get_runs impl_prewarm_r01]] ne {100%}} {error {implementation incomplete}}
if {[get_property PART [current_design]] ne {xc7z020clg400-1}} {error {wrong open design}}
set pwdir {E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration}
set pwroot {E:/projects/fpga/voice-view-game/build/hosd/c0e/prewarm-r01}
set ::osd_report_dir $pwroot/signoff
source $pwdir/collect_reports.tcl
set ::latency_ext_dir $pwroot/extended
source $pwdir/collect_latency_extended.tcl
set pwfp [open $pwroot/extended/project_synthesis_files.txt {WRONLY CREAT EXCL}]
foreach pwfile [get_files -compile_order sources -used_in synthesis] {puts $pwfp [file normalize $pwfile]}
close $pwfp
file copy [info script] $pwroot/collect_latency_prewarm_signoff.tcl
file copy E:/vvl/c0e/c6_latency.runs/impl_prewarm_r01/runme.log $pwroot/implementation-run.log
puts C0E_PREWARM_COMPLETE_SIGNOFF_REPORTS_COLLECTED
