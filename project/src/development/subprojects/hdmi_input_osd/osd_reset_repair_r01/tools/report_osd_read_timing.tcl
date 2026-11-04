# Vivado 2026.1 / PYNQ-Z2 xc7z020clg400-1.
# Run: D:/Xilinx/Vivado/2026.1/Vivado/bin/vivado.bat -mode batch -nojournal -source subprojects/hdmi_input_osd/osd_reset_repair_r01/tools/report_osd_read_timing.tcl -tclargs build/hosd/osd-reset-r01/read-timing-r01
# Outputs: routed OSD AXI read-register timing report and matched cell list.
# Next: compare OSD read slack with the physically observed second-read stall.
if {$argc != 1} {error {expected one fresh output directory}}
set root E:/projects/fpga/voice-view-game
set out [file normalize [lindex $argv 0]]
set dcp $root/build/hosd/osd-reset-r01/route-vcc-r01/signoff/candidate.dcp
if {[version -short] ne {2026.1} || [file exists $out] || ![file isfile $dcp]} {error {tool/output/DCP mismatch}}
file mkdir $out
open_checkpoint $dcp
if {[get_property PART [current_design]] ne {xc7z020clg400-1}} {error {wrong target}}
set all [get_cells -hier -filter {NAME =~ c6v_i/input_osd_0/* && IS_PRIMITIVE}]
set selected {}
foreach cell $all {
    set name [get_property NAME $cell]
    if {[regexp {(rvalid|rdata|rresp|araddr|arready|ack_sync|req_toggle)} $name]} {
        lappend selected $cell
    }
}
set fp [open $out/cells.txt {WRONLY CREAT EXCL}]
foreach cell $selected {puts $fp [get_property NAME $cell]}
close $fp
if {[llength $selected] == 0} {error {OSD read cells not found}}
set targets [get_pins -of_objects $selected -filter {REF_PIN_NAME == D}]
if {[llength $targets] == 0} {error {OSD read D pins not found}}
report_timing -delay_type max -to $targets -max_paths 30 -file $out/osd_read_setup.rpt
report_timing -delay_type min -to $targets -max_paths 30 -file $out/osd_read_hold.rpt
puts [list OSD_READ_TIMING_REPORTED cells [llength $selected] endpoints [llength $targets]]
