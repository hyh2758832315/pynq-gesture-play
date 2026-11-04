# Vivado 2026.1 / PYNQ-Z2 xc7z020clg400-1.
# Run: D:/Xilinx/Vivado/2026.1/Vivado/bin/vivado.bat -mode batch -nojournal -source subprojects/hdmi_input_osd/osd_reset_repair_r01/tools/report_osd_upstream_timing.tcl -tclargs build/hosd/osd-reset-r01/upstream-timing-r01
# Outputs: read-channel setup/hold reports for GP0 register slice and both SmartConnect stages.
# Next: compare weak paths against the board's failed second read before changing RTL or placement.
if {$argc != 1} {error {expected one fresh output directory}}
set root E:/projects/fpga/voice-view-game
set out [file normalize [lindex $argv 0]]
set dcp $root/build/hosd/osd-reset-r01/route-vcc-r01/signoff/candidate.dcp
if {[version -short] ne {2026.1} || [file exists $out] || ![file isfile $dcp]} {error {tool/output/DCP mismatch}}
file mkdir $out
open_checkpoint $dcp
if {[get_property PART [current_design]] ne {xc7z020clg400-1}} {error {wrong target}}
set fp [open $out/counts.txt {WRONLY CREAT EXCL}]
foreach block {vision_gp0_slice gp0_smc vision_control_smc} {
    set cells [get_cells -hier -filter "NAME =~ c6v_i/$block/* && IS_PRIMITIVE"]
    set selected {}
    foreach cell $cells {
        set name [get_property NAME $cell]
        if {[regexp -nocase {(/ar[./_]|/r[./_]|/i_ar_|/i_r_|/rdata|/rresp|/rvalid|/araddr|/arvalid|/arready)} $name]} {
            lappend selected $cell
        }
    }
    set targets [get_pins -of_objects $selected -filter {REF_PIN_NAME == D || REF_PIN_NAME == CE}]
    puts $fp [list block $block cells [llength $cells] selected [llength $selected] endpoints [llength $targets]]
    if {[llength $targets] > 0} {
        report_timing -delay_type max -to $targets -max_paths 40 -file $out/$block.setup.rpt
        report_timing -delay_type min -to $targets -max_paths 40 -file $out/$block.hold.rpt
    }
}
close $fp
puts OSD_UPSTREAM_TIMING_REPORTED
