# R22 AXI read-path diagnostic Overlay, PYNQ-Z2 xc7z020clg400-1, Vivado 2026.1.
# Run from repository root:
# D:/Xilinx/Vivado/2026.1/Vivado/bin/vivado.bat -mode batch -nojournal -log build/hosd/osd-reset-r01/axi-debug-r05.log -source subprojects/hdmi_input_osd/osd_reset_repair_r01/tools/build_axi_debug.tcl -tclargs build/hosd/osd-reset-r01/axi-debug-r05 incremental minimal
# Expected outputs: probe_map.tcldict, optimized/placed/routed DCPs, route/timing/DRC
# reports and, only when the gates pass, c6v_axi_debug.bit plus c6v_axi_debug.ltx.
# Next: verify a JTAG target, load this separate diagnostic bitstream, arm the
# trigger (exact address only in wide mode; bit 2 in quiet minimal mode), then
# make exactly one controlled 0x43c20004 read.
# This script does not modify the source project, R22 baseline, or the board.
if {$argc != 3} {error {expected fresh output directory, incremental|full mode, and minimal|wide profile}}
set root E:/projects/fpga/voice-view-game
set src $root/build/hosd/osd-reset-r01/full-r01/assembled.dcp
set ref $root/build/hosd/osd-reset-r01/route-vcc-r01/signoff/candidate.dcp
set out [file normalize [lindex $argv 0]]
set mode [lindex $argv 1]
set profile [lindex $argv 2]
if {$mode ni {incremental full}} {error {mode must be incremental or full}}
if {$profile ni {minimal wide}} {error {profile must be minimal or wide}}
if {[version -short] ne {2026.1} || [file exists $out] || ![file isfile $src] || ![file isfile $ref]} {
    error {tool, output or R22 checkpoint mismatch}
}
set py $root/.venv/Scripts/python.exe
foreach {file expected} [list \
    $src 6c9b82a8994993e02fd2dbb34812c031f5b13f5724cd33104a50541978be815e \
    $ref 62d07a8e1f7f1ce6c5de924086aeee179605ac32c6ca17a94d1e4f4f9d9fbd7d] {
    set actual [exec $py -I -B -c {import hashlib,sys;print(hashlib.sha256(open(sys.argv[1],"rb").read()).hexdigest())} $file]
    if {$actual ne $expected} {error "R22 checkpoint drift: $file"}
}
open_checkpoint $src
if {[get_property PART [current_design]] ne {xc7z020clg400-1}} {error {wrong target part}}

set ila_name u_ila_axi_r22
create_debug_core $ila_name ila
set ila [get_debug_cores $ila_name]
set_property C_DATA_DEPTH 1024 $ila
set_property C_ADV_TRIGGER false $ila
set_property C_EN_STRG_QUAL false $ila
set_property C_INPUT_PIPE_STAGES 1 $ila
set_property ALL_PROBE_SAME_MU true $ila
set_property ALL_PROBE_SAME_MU_CNT 1 $ila
set clock_net [get_nets -quiet c6v_i/ps7_0_FCLK_CLK0]
if {[llength $clock_net] != 1} {error {FCLK0 debug clock missing}}
connect_debug_port $ila_name/clk $clock_net

file mkdir $out
set fp [open $out/probe_map.tcldict {WRONLY CREAT EXCL}]
puts $fp [list clock [get_property NAME $clock_net] frequency_domain FCLK_CLK0]
set ::probe_index 0
proc add_group {fp ila_name label names} {
    set port $ila_name/probe$::probe_index
    if {$::probe_index != 0} {create_debug_port $ila_name probe}
    set objects {}
    foreach name $names {
        set net [get_nets -quiet [list $name]]
        if {[llength $net] != 1} {error "missing or ambiguous debug net: $name"}
        lappend objects $net
    }
    set_property port_width [llength $objects] [get_debug_ports $port]
    connect_debug_port $port $objects
    puts $fp [list $port $label bit_order_low_to_high $names]
    incr ::probe_index
}

# The wide profile captures the exact 32-bit PS address. The minimal profile
# captures only address bit 2 and requires an otherwise quiet MMIO reproducer.
# A one-cycle ILA input pipeline delays every group equally.
set ps_addr {}
if {$profile eq {minimal}} {
    set ps_bits {2}
} else {
    set ps_bits {0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31}
}
foreach i $ps_bits {
    lappend ps_addr [format {c6v_i/ps7_0_M_AXI_GP0_ARADDR[%d]} $i]
}
add_group $fp $ila_name ps_araddr $ps_addr
add_group $fp $ila_name ps_side {
    c6v_i/ps7_0_M_AXI_GP0_ARVALID
    c6v_i/ps7_0_M_AXI_GP0_ARREADY
    c6v_i/ps7_0_M_AXI_GP0_RVALID
    c6v_i/ps7_0_M_AXI_GP0_RREADY
}
add_group $fp $ila_name slice_out {
    c6v_i/vision_gp0_slice_M_AXI_ARVALID
    c6v_i/vision_gp0_slice_M_AXI_ARREADY
    c6v_i/vision_gp0_slice_M_AXI_RVALID
    c6v_i/vision_gp0_slice_M_AXI_RREADY
}
add_group $fp $ila_name gp0_to_vision {
    c6v_i/gp0_smc_M29_AXI_ARVALID
    c6v_i/gp0_smc_M29_AXI_ARREADY
    c6v_i/gp0_smc_M29_AXI_RVALID
    c6v_i/gp0_smc_M29_AXI_RREADY
}
add_group $fp $ila_name osd_side {
    c6v_i/vision_control_smc_M05_AXI_ARVALID
    c6v_i/vision_control_smc_M05_AXI_ARREADY
    c6v_i/vision_control_smc_M05_AXI_RVALID
    c6v_i/vision_control_smc_M05_AXI_RREADY
}
set osd_addr {}
if {$profile eq {minimal}} {set osd_bits {2}} else {set osd_bits {0 1 2 3 4 5 6}}
foreach i $osd_bits {
    lappend osd_addr [format {c6v_i/vision_control_smc_M05_AXI_ARADDR[%d]} $i]
}
add_group $fp $ila_name osd_araddr $osd_addr
add_group $fp $ila_name responses {
    {c6v_i/ps7_0_M_AXI_GP0_RRESP[0]}
    {c6v_i/ps7_0_M_AXI_GP0_RRESP[1]}
    {c6v_i/vision_control_smc_M05_AXI_RRESP[1]}
}
add_group $fp $ila_name fclk_resets {
    {c6v_i/rst_fclk0_interconnect_aresetn[0]}
    {c6v_i/rst_fclk0_peripheral_aresetn[0]}
}
close $fp

# AMD UG908 non-project incremental debug sequence. R22's assembled DCP has
# a locked parent implementation and newly synthesized OSD. Full mode is the
# isolated fallback when incremental placement cannot fit new debug shapes.
opt_design
write_checkpoint $out/optimized.dcp
if {$mode eq {incremental}} {read_checkpoint -incremental $ref}
if {$mode eq {full}} {
    place_design -directive Explore
} else {
    place_design
}
write_checkpoint $out/placed.dcp
route_design
write_checkpoint $out/routed.dcp
report_route_status -file $out/route.rpt
report_timing_summary -delay_type min_max -report_unconstrained -max_paths 20 -file $out/timing.rpt
report_drc -file $out/drc.rpt
set setup [get_property SLACK [get_timing_paths -delay_type max -max_paths 1]]
set hold [get_property SLACK [get_timing_paths -delay_type min -max_paths 1]]
set fp [open $out/gates.tcldict {WRONLY CREAT EXCL}]
puts $fp [list setup_ns $setup hold_ns $hold]
close $fp
if {$setup < 0 || $hold < 0} {error {diagnostic design does not meet timing; bitstream withheld}}
write_debug_probes $out/c6v_axi_debug.ltx
write_bitstream $out/c6v_axi_debug.bit
puts [list AXI_DEBUG_BIT_READY $out]
