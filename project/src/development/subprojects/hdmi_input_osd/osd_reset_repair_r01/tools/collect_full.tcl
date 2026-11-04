# Vivado 2026.1 / PYNQ-Z2. Run from workspace root after assemble_full.tcl:
# D:/Xilinx/Vivado/2026.1/Vivado/bin/vivado.bat -mode batch -nojournal -source subprojects/hdmi_input_osd/osd_reset_repair_r01/tools/collect_full.tcl -tclargs build/hosd/osd-reset-r01/route-vcc-r01/routed.dcp build/hosd/osd-reset-r01/route-vcc-r01
# Outputs signoff/ and extended/ full-design reports, static-final.tcldict in the route directory.
# Next: compare against frozen R21 and require all route/timing checks before bit export.
if {$argc != 2} {error {expected routed checkpoint and route output directory}}
set root E:/projects/fpga/voice-view-game
set checkpoint [file normalize [lindex $argv 0]]
set out [file normalize [lindex $argv 1]]
if {[version -short] ne {2026.1} || ![file isfile $checkpoint] || ![file isdirectory $out] || [file exists $out/signoff]} {error {missing routed checkpoint or reports exist}}
open_checkpoint $checkpoint
if {[get_property PART [current_design]] ne {xc7z020clg400-1}} {error {wrong part}}
set ::osd_report_dir $out/signoff
source $root/subprojects/hdmi_input_osd/integration/collect_reports.tcl
set ::latency_ext_dir $out/extended
source $root/subprojects/hdmi_input_osd/integration/collect_latency_extended.tcl
set fp [open $out/static-final.tcldict {WRONLY CREAT EXCL}]
foreach c [get_cells -hier -filter {IS_PRIMITIVE && NAME !~ c6v_i/input_osd_0/*}] {
    puts $fp [list [get_property NAME $c] [get_property REF_NAME $c] [get_property LOC $c] [get_property BEL $c]]
}
close $fp
puts OSD_RESET_FULL_REPORTS_COLLECTED_REVIEW_PENDING
