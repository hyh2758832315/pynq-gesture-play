# Vivado 2026.1 / PYNQ-Z2 xc7z020clg400-1.
# Run: D:/Xilinx/Vivado/2026.1/Vivado/bin/vivado.bat -mode batch -nojournal -source subprojects/hdmi_input_osd/osd_reset_repair_r01/tools/list_hw_targets_r22.tcl -tclargs build/hosd/osd-reset-r01/hw-targets-r01.txt
# Output: read-only list of local JTAG targets in a fresh text file.
# Next: only if a PYNQ target exists, prepare a separate debug Overlay for AXI handshake capture.
if {$argc != 1} {error {expected one fresh output file}}
set out [file normalize [lindex $argv 0]]
if {[version -short] ne {2026.1} || [file exists $out]} {error {tool/output mismatch}}
open_hw_manager
connect_hw_server -url localhost:3121
set targets {}
if {[catch {get_hw_targets} found]} {
    puts [list R22_HW_TARGET_DISCOVERY $found]
} else {
    set targets $found
}
set fp [open $out {WRONLY CREAT EXCL}]
puts $fp [list count [llength $targets]]
foreach target $targets {puts $fp [get_property NAME $target]}
close $fp
puts [list R22_HW_TARGET_COUNT [llength $targets]]
disconnect_hw_server
close_hw_manager
