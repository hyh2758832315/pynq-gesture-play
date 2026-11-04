# PYNQ-Z2 xc7z020clg400-1 / Vivado 2026.1 feasibility test.
# Run from repository root:
# D:/Xilinx/Vivado/2026.1/Vivado/bin/vivado.bat -mode batch -nojournal -source subprojects/hdmi_input_osd/osd_reset_repair_r01/tools/try_axi_debug_insertion.tcl -tclargs build/hosd/osd-reset-r01/full-r01/assembled.dcp build/hosd/osd-reset-r01/axi-debug-insert-r01
# Output: an isolated, unimplemented probe checkpoint and probe inventory.
# Next: only after this passes, use a fresh incremental implementation and review timing.
if {$argc != 2} {error {expected assembled checkpoint and fresh output directory}}
set checkpoint [file normalize [lindex $argv 0]]
set out [file normalize [lindex $argv 1]]
if {[version -short] ne {2026.1} || ![file isfile $checkpoint] || [file exists $out]} {
    error {tool, source or output mismatch}
}
open_checkpoint $checkpoint
if {[get_property PART [current_design]] ne {xc7z020clg400-1}} {error {wrong target part}}
set clock_net [get_nets -quiet c6v_i/ps7_0_FCLK_CLK0]
set arvalid_net [get_nets -quiet c6v_i/vision_gp0_slice_M_AXI_ARVALID]
if {[llength $clock_net] != 1 || [llength $arvalid_net] != 1} {
    error {expected clock or GP0 ARVALID net is missing}
}
create_debug_core u_ila_axi_r22 ila
set core [get_debug_cores u_ila_axi_r22]
set_property C_DATA_DEPTH 1024 $core
set_property C_ADV_TRIGGER false $core
set_property C_EN_STRG_QUAL false $core
set_property C_INPUT_PIPE_STAGES 1 $core
set_property port_width 1 [get_debug_ports u_ila_axi_r22/clk]
set_property port_width 1 [get_debug_ports u_ila_axi_r22/probe0]
connect_debug_port u_ila_axi_r22/clk $clock_net
connect_debug_port u_ila_axi_r22/probe0 $arvalid_net
file mkdir $out
set fp [open $out/probes.tcldict {WRONLY CREAT EXCL}]
puts $fp [list clock [get_property NAME $clock_net] probe0 [get_property NAME $arvalid_net]]
close $fp
write_checkpoint $out/debug_unimplemented.dcp
puts [list AXI_DEBUG_INSERTION_PASS $out]
