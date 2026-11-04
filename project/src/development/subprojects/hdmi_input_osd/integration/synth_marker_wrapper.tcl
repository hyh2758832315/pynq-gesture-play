# Vivado2026.1/PYNQ-Z2. Run source -notrace .../integration/synth_marker_wrapper.tcl.
# Output build/hosd/marker-visibility-r02/ooc-r02, then full routed candidate audit.
# No board or existing-project edits; only the owned independent checkpoint session.
set mvroot E:/projects/fpga/voice-view-game
set mvsrc $mvroot/subprojects/hdmi_input_osd/marker_visibility_r02
set mvout $mvroot/build/hosd/marker-visibility-r02/ooc-r02
if {[file exists $mvout]} {error {preserve prior wrapper OOC}}
file mkdir $mvout
close_project
create_project -in_memory marker_wrapper -part xc7z020clg400-1
set_param general.maxThreads 4
read_verilog -sv [glob $mvsrc/rtl/*.sv]
synth_design -top c6v_input_osd_0_0 -part xc7z020clg400-1 -mode out_of_context
create_clock -name osd_axi -period 10.000 [get_ports s_axi_aclk]
create_clock -name osd_pixel -period 13.468 [get_ports pclk]
set ::osd_scope {inst/impl/}
source $mvsrc/constraints/osd_cdc.tcl
report_utilization -file $mvout/utilization.rpt
report_timing_summary -file $mvout/timing.rpt
report_bus_skew -file $mvout/bus_skew.rpt
set rows {};foreach p [get_ports] {lappend rows [list [get_property NAME $p] [get_property DIRECTION $p]]}
set fp [open $mvout/ports.tcldict {WRONLY CREAT EXCL}];puts $fp $rows;close $fp
# Strip this independent OOC estimation view only. Full parent constraints remain
# in the untouched R20 DCP and must be revalidated/rebound after insertion.
reset_timing -invalid
write_checkpoint $mvout/osd.dcp
puts MARKER_WRAPPER_OOC_READY
