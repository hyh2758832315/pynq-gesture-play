# Vivado 2026.1 / PYNQ-Z2 xc7z020clg400-1.
# Run: D:/Xilinx/Vivado/2026.1/Vivado/bin/vivado.bat -mode batch -nojournal -source subprojects/hdmi_input_osd/osd_reset_repair_r01/tools/export_osd_funcsim.tcl -tclargs build/hosd/osd-reset-r01/netlist-r01
# Output: fresh netlist-r01/osd_funcsim.v and source SHA context.
# Next: use XSim with tb_osd_axi_transactions.sv and unisims_ver.
if {$argc != 1} {error {expected one fresh output directory}}
set root E:/projects/fpga/voice-view-game
set out [file normalize [lindex $argv 0]]
set dcp $root/build/hosd/osd-reset-r01/wrapper-ooc-r01/osd.dcp
if {[version -short] ne {2026.1} || [file exists $out] || ![file isfile $dcp]} {error {tool/output/DCP mismatch}}
file mkdir $out
open_checkpoint $dcp
if {[get_property PART [current_design]] ne {xc7z020clg400-1}} {error {wrong target}}
write_verilog -force -mode funcsim $out/osd_funcsim.v
set fp [open $out/context.tcldict {WRONLY CREAT EXCL}]
puts $fp [list part [get_property PART [current_design]] top [get_property NAME [current_design]] dcp $dcp]
close $fp
puts OSD_FUNCSIM_NETLIST_READY
