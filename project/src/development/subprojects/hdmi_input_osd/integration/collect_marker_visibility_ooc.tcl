# Vivado 2026.1 / xc7z020clg400-1, newly synthesized independent OSD only.
# Run: source -notrace .../integration/collect_marker_visibility_ooc.tcl
# Outputs: build/hosd/marker-visibility-r02/ooc-r01/{osd.dcp,reports,ports.tcldict}.
# Next: insert at the complete OSD interface in a new full-design candidate; no board access.
set mvroot E:/projects/fpga/voice-view-game
set mvsrc $mvroot/subprojects/hdmi_input_osd/marker_visibility_r02
set mvout $mvroot/build/hosd/marker-visibility-r02/ooc-r01
if {[file exists $mvout]} {error {preserve previous OOC evidence}}
if {[version -short] ne {2026.1} || [get_property PART [current_design]] ne {xc7z020clg400-1}} {error {wrong tool/part}}
file mkdir $mvout
create_clock -name osd_axi -period 10.000 [get_ports s_axi_aclk]
create_clock -name osd_pixel -period 13.468 [get_ports pclk]
set ::osd_scope {impl/}
source $mvsrc/constraints/osd_cdc.tcl
report_utilization -file $mvout/utilization.rpt
report_timing_summary -file $mvout/timing.rpt
report_cdc -details -file $mvout/cdc.rpt
report_drc -file $mvout/drc.rpt
set rows {}
foreach p [get_ports] {lappend rows [list [get_property NAME $p] [get_property DIRECTION $p]]}
set fp [open $mvout/ports.tcldict {WRONLY CREAT EXCL}]; puts $fp $rows; close $fp
write_checkpoint $mvout/osd.dcp
puts MARKER_OOC_COMPLETE_FULL_IMPLEMENTATION_PENDING
