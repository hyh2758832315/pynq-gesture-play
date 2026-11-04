# Standalone offline OOC audit, xc7z020clg400-1 / Vivado 2026.1.
# vivado -mode batch -source tools/synthesize.tcl -tclargs <NEW_OUTPUT_DIRECTORY>
# Outputs: osd_synth.dcp, utilization.rpt, timing.rpt, cdc.rpt, drc.rpt, receipt.txt.
# Next: review resources and paths, then integrate ONLY into a new hardware parent.
if {[llength $argv] != 1} {error "expected a fresh output directory"}
set osd_root [file normalize [file join [file dirname [info script]] ..]]
set osd_out [file normalize [lindex $argv 0]]
if {[file exists $osd_out]} {error "refusing occupied output: $osd_out"}
file mkdir $osd_out
cd $osd_out
set_param general.maxThreads 1
read_verilog -sv [glob [file join $osd_root rtl *.sv]]
synth_design -top input_osd_axi -part xc7z020clg400-1 -mode out_of_context
create_clock -name osd_axi -period 10.000 [get_ports s_axi_aclk]
create_clock -name osd_pixel -period 13.468 [get_ports pclk]
set ::osd_scope {impl/}
source [file join $osd_root constraints osd_cdc.tcl]
report_utilization -file [file join $osd_out utilization.rpt]
report_timing_summary -file [file join $osd_out timing.rpt]
report_bus_skew -file [file join $osd_out bus_skew.rpt]
report_cdc -details -file [file join $osd_out cdc.rpt]
report_drc -file [file join $osd_out drc.rpt]
write_checkpoint [file join $osd_out osd_synth.dcp]
set osd_fp [open [file join $osd_out receipt.txt] w]
puts $osd_fp "OSD_OOC_SYNTH_COMPLETE"
puts $osd_fp "version=[version -short] part=[get_property PART [current_design]]"
puts $osd_fp "NOT_FULL_DESIGN_TIMING_SIGNOFF NOT_BOARD_VALIDATED"
close $osd_fp
