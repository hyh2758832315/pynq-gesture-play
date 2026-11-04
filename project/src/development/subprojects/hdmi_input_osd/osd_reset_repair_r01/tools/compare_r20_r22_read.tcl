# PYNQ-Z2 xc7z020clg400-1, Vivado 2026.1; read-only routed DCP comparison.
# Run: D:/Xilinx/Vivado/2026.1/Vivado/bin/vivado.bat -mode batch -nojournal -log build/hosd/osd-reset-r01/compare-r20-r22-read-r01.log -source subprojects/hdmi_input_osd/osd_reset_repair_r01/tools/compare_r20_r22_read.tcl -tclargs build/hosd/osd-reset-r01/compare-r20-r22-read-r01
# Outputs: fresh directory with r20/r22 cell summaries, rvalid setup and hold reports, plus summary.tcldict.
# Next: compare reset gating and response-state timing; do not treat static timing as an observed board handshake.
if {$argc != 1} {error {expected one fresh output directory}}
if {[version -short] ne {2026.1}} {error {Vivado version mismatch}}
set root E:/projects/fpga/voice-view-game
set output [file normalize [lindex $argv 0]]
if {[file exists $output]} {error {output directory already exists}}
set designs [list \
    r20 $root/deliveries/c6i-pl-vision-volume-osd-r20-admission-r03-20261023/overlay/candidate.dcp \
    r22 $root/build/hosd/osd-reset-r01/route-vcc-r01/signoff/candidate.dcp]
foreach {label checkpoint} $designs {
    if {![file isfile $checkpoint]} {error "missing $label checkpoint"}
}
file mkdir $output
set summary [open $output/summary.tcldict {WRONLY CREAT EXCL}]
foreach {label checkpoint} $designs {
    open_checkpoint $checkpoint
    if {[get_property PART [current_design]] ne {xc7z020clg400-1}} {error "wrong $label part"}
    set all [get_cells -hier -filter {NAME =~ c6v_i/input_osd_0/* && IS_PRIMITIVE}]
    set selected {}
    set responses {}
    set readies {}
    foreach cell $all {
        set name [get_property NAME $cell]
        if {[string match *rvalid* $name]} {lappend selected $cell}
        if {[regexp {(^|/)rvalid_reg$} $name]} {lappend responses $cell}
        if {[string match *arready* $name]} {lappend readies $cell}
    }
    if {[llength $responses] != 1} {error "expected one $label OSD rvalid register; got $responses"}
    set response [lindex $responses 0]
    set cells [open $output/$label.read_cells.txt {WRONLY CREAT EXCL}]
    foreach cell $selected {
        puts $cells [list [get_property NAME $cell] [get_property REF_NAME $cell] \
            [get_property LOC $cell] [get_property BEL $cell]]
    }
    foreach cell [concat [list $response] $readies] {
        puts $cells [list DETAIL [get_property NAME $cell] [get_property REF_NAME $cell] \
            [get_property LOC $cell] [get_property BEL $cell]]
    }
    close $cells
    set d [get_pins -quiet -of_objects $response -filter {REF_PIN_NAME == D}]
    if {[llength $d] != 1} {error "missing $label rvalid/D"}
    report_timing -delay_type max -to $d -max_paths 10 -file $output/$label.rvalid_setup.rpt
    report_timing -delay_type min -to $d -max_paths 10 -file $output/$label.rvalid_hold.rpt
    set path [get_timing_paths -delay_type max -to $d -max_paths 1]
    if {[llength $path] != 1} {error "missing $label rvalid timing path"}
    puts $summary [list $label rvalid_setup_slack_ns [get_property SLACK $path] \
        rvalid_cell [get_property REF_NAME $response] ready_cells [llength $readies] \
        read_cells [llength $selected]]
    close_design
}
close $summary
puts [list R20_R22_READ_COMPARE_PASS $output]
