# Vivado 2026.1 / PYNQ-Z2. Run from workspace root:
# D:/Xilinx/Vivado/2026.1/Vivado/bin/vivado.bat -mode batch -nojournal -source subprojects/hdmi_input_osd/osd_reset_repair_r01/tools/build_wrapper_ooc.tcl -tclargs build/hosd/osd-reset-r01/wrapper-ooc-r01
# Outputs osd.dcp, ports.tcldict, utilization/timing/CDC/bus-skew reports.
# Next: use the checkpoint in assemble_full.tcl against the frozen R21 parent.
if {$argc != 1} {error {expected one fresh output directory}}
set root E:/projects/fpga/voice-view-game
set src $root/subprojects/hdmi_input_osd/osd_reset_repair_r01
set out [file normalize [lindex $argv 0]]
if {[file exists $out]} {error {output exists; preserve previous evidence}}
if {[version -short] ne {2026.1}} {error {wrong Vivado version}}
file mkdir $out
create_project -in_memory osd_reset_wrapper -part xc7z020clg400-1
set_param general.maxThreads 4
read_verilog -sv [glob $src/rtl/*.sv]
synth_design -top c6v_input_osd_0_0 -part xc7z020clg400-1 -mode out_of_context
create_clock -name osd_axi -period 10.000 [get_ports s_axi_aclk]
create_clock -name osd_pixel -period 13.468 [get_ports pclk]
set ::osd_scope {inst/impl/}
source $src/constraints/osd_cdc.tcl
report_utilization -file $out/utilization.rpt
report_timing_summary -file $out/timing.rpt
report_cdc -details -file $out/cdc.rpt
report_bus_skew -file $out/bus_skew.rpt
set rows {}
foreach p [get_ports] {lappend rows [list [get_property NAME $p] [get_property DIRECTION $p]]}
set fp [open $out/ports.tcldict {WRONLY CREAT EXCL}]
puts $fp $rows
close $fp
reset_timing -invalid
write_checkpoint $out/osd.dcp
puts OSD_RESET_WRAPPER_OOC_READY
