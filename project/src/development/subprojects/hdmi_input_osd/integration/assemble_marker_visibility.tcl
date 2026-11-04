# Vivado2026.1/PYNQ-Z2, source in the new owned session with exact R20 DCP open.
# Output build/hosd/marker-visibility-r02/assembly-r01; no board IO or bitstream.
# Next: opt_design, place_design, route_design, full STA/CDC/DRC audit.
set mvroot E:/projects/fpga/voice-view-game
set mvout $mvroot/build/hosd/marker-visibility-r02/assembly-r01
set mvooc $mvroot/build/hosd/marker-visibility-r02/ooc-r02
if {[file exists $mvout]} {error {preserve assembly evidence}}
if {[version -short] ne {2026.1} || [get_property PART [current_design]] ne {xc7z020clg400-1}} {error {wrong tool/part}}
if {[get_property SLACK [get_timing_paths -delay_type max -max_paths 1]]!=0.002 || [get_property SLACK [get_timing_paths -delay_type min -max_paths 1]]!=0.049} {error {wrong parent timing}}
set fp [open $mvooc/ports.tcldict r];set expected [lsort [read $fp]];close $fp
set rows {};foreach p [get_pins c6v_i/input_osd_0/*] {lappend rows [list [get_property REF_PIN_NAME $p] [get_property DIRECTION $p]]}
if {[lsort $rows] ne $expected} {error {OSD parent interface differs}}
file mkdir $mvout
write_xdc -exclude_physical $mvout/parent_timing.xdc
report_utilization -cells [get_cells c6v_i/input_osd_0] -file $mvout/parent_osd_utilization.rpt
set fp [open $mvout/parent_static_cells.tcldict {WRONLY CREAT EXCL}]
foreach c [get_cells -hier -filter {IS_PRIMITIVE && NAME !~ c6v_i/input_osd_0/*}] {
    puts $fp [list [get_property NAME $c] [get_property REF_NAME $c] [get_property LOC $c] [get_property BEL $c]]
}
close $fp
update_design -cell c6v_i/input_osd_0 -black_box
lock_design -level routing
read_checkpoint -cell c6v_i/input_osd_0 -strict $mvooc/osd.dcp
set ::osd_scope {c6v_i/input_osd_0/inst/impl/}
source $mvroot/subprojects/hdmi_input_osd/marker_visibility_r02/constraints/osd_cdc.tcl
write_xdc -exclude_physical $mvout/assembled_timing.xdc
write_checkpoint $mvout/assembled.dcp
puts MARKER_OSD_STRICT_ASSEMBLY_READY
