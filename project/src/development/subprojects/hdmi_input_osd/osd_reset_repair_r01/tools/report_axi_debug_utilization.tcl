# Vivado 2026.1 / PYNQ-Z2, read-only utilization analysis of a failed debug build.
# Run from repository root:
# D:/Xilinx/Vivado/2026.1/Vivado/bin/vivado.bat -mode batch -nojournal -source subprojects/hdmi_input_osd/osd_reset_repair_r01/tools/report_axi_debug_utilization.tcl -tclargs build/hosd/osd-reset-r01/axi-debug-r04/optimized.dcp build/hosd/osd-reset-r01/axi-debug-util-r01.rpt
# Outputs: summary and hierarchical utilization reports. Next: compare the
# limiting Slice footprint with the frozen R22 signoff baseline.
if {$argc != 2} {error {expected optimized checkpoint and fresh report file}}
set checkpoint [file normalize [lindex $argv 0]]
set output [file normalize [lindex $argv 1]]
if {[version -short] ne {2026.1} || ![file isfile $checkpoint] || [file exists $output]} {
    error {tool, checkpoint or output mismatch}
}
open_checkpoint $checkpoint
if {[get_property PART [current_design]] ne {xc7z020clg400-1}} {error {wrong part}}
report_utilization -hierarchical -file $output
report_utilization -file $output.summary.rpt
puts [list AXI_DEBUG_UTILIZATION_REPORTED $output]
