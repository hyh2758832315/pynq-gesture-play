# Run in owned routed marker session: source -notrace <this file>.
# Outputs marker-visibility-r02/{signoff-r01,extended-r01,static-final.tcldict}.
# Next: audit full reports and static placement/constraints before bit export.
set mvroot E:/projects/fpga/voice-view-game
set mvout $mvroot/build/hosd/marker-visibility-r02
if {[version -short] ne {2026.1} || [get_property PART [current_design]] ne {xc7z020clg400-1}} {error {wrong tool/part}}
set ::osd_report_dir $mvout/signoff-r01
source $mvroot/subprojects/hdmi_input_osd/integration/collect_reports.tcl
set ::latency_ext_dir $mvout/extended-r01
source $mvroot/subprojects/hdmi_input_osd/integration/collect_latency_extended.tcl
set rows {}
foreach c [get_cells -hier -filter {IS_PRIMITIVE && NAME !~ c6v_i/input_osd_0/*}] {
    lappend rows [list [get_property NAME $c] [get_property REF_NAME $c] [get_property LOC $c] [get_property BEL $c]]
}
set fp [open $mvout/static-final.tcldict {WRONLY CREAT EXCL}]
foreach row $rows {puts $fp $row}
close $fp
puts MARKER_FULL_REPORTS_COLLECTED_AUDIT_PENDING
