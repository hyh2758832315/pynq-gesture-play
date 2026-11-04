# Vivado 2026.1 / PYNQ-Z2 xc7z020clg400-1.
# Run: D:/Xilinx/Vivado/2026.1/Vivado/bin/vivado.bat -mode batch -nojournal -source subprojects/hdmi_input_osd/osd_reset_repair_r01/tools/export_osd_route_timesim.tcl -tclargs build/hosd/osd-reset-r01/route-timesim-r01
# Outputs: osd_route.v, osd_route.sdf, context.tcldict in a fresh output directory.
# Next: run the bounded OSD AXI transaction XSim bench with this timing netlist.
if {$argc != 1} {error {expected one fresh output directory}}
set root E:/projects/fpga/voice-view-game
set out [file normalize [lindex $argv 0]]
set dcp $root/build/hosd/osd-reset-r01/route-vcc-r01/signoff/candidate.dcp
if {[version -short] ne {2026.1} || [file exists $out] || ![file isfile $dcp]} {error {tool/output/DCP mismatch}}
file mkdir $out
open_checkpoint $dcp
if {[get_property PART [current_design]] ne {xc7z020clg400-1}} {error {wrong target}}
set cell [get_cells -quiet c6v_i/input_osd_0]
if {[llength $cell] != 1} {error {OSD hierarchical cell missing}}
write_verilog -force -cell $cell -mode timesim -rename_top c6v_input_osd_0_0 -sdf_anno true -sdf_file $out/osd_route.sdf $out/osd_route.v
write_sdf -force -cell $cell $out/osd_route.sdf
set fp [open $out/context.tcldict {WRONLY CREAT EXCL}]
puts $fp [list part [get_property PART [current_design]] top [get_property NAME [current_design]] cell [get_property NAME $cell] dcp $dcp]
close $fp
puts OSD_ROUTE_TIMESIM_READY
