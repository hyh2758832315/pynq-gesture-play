# PYNQ-Z2 xc7z020clg400-1 / Vivado 2026.1: reproduce the single-pin R23 timing repair.
# Run: D:/Xilinx/Vivado/2026.1/Vivado/bin/vivado.bat -mode batch -source E:/projects/fpga/voice-view-game/subprojects/button_only/close_timing_shared_id.tcl -log D:/vvg_button_only_r23b/timing_audit_replay/vivado.log
# Output: D:/vvg_button_only_r23b/timing_audit_replay/{timing,drc,route,bus_skew,cdc}.rpt, c6v_timing_closed.dcp/.bit/.xsa.
# Next: require WNS/WHS/WPWS >= 0, no route/DRC errors, then verify the XSA bit/HWH and board gate.
set stage {D:/vvg_button_only_r23b}
set out $stage/timing_audit_replay
file mkdir $out
if {[version -short] ne {2026.1}} {error {Vivado 2026.1 required}}
set checkpoint $stage/c6_latency.runs/impl_button_r23/c6v_wrapper_postroute_physopt.dcp
if {![file exists $checkpoint]} {error {R23 full-route checkpoint missing}}
open_checkpoint $checkpoint
if {[get_property PART [current_design]] ne {xc7z020clg400-1}} {error {wrong target part}}
set pin [get_pins c6v_i/video_in/inst/FORMATTER_INST/de_1_reg/D]
if {[llength $pin] != 1} {error {target pin not unique}}
# The original route has one setup failure at vid_hsync -> this register.
# Auto-delay accounts for both setup and hold. A shortest-delay route fails hold.
route_design -unroute -pins $pin
route_design -pins $pin -auto_delay
report_timing_summary -delay_type min_max -report_unconstrained -file $out/timing.rpt
report_route_status -file $out/route.rpt
report_drc -file $out/drc.rpt
report_bus_skew -warn_on_violation -file $out/bus_skew.rpt
report_cdc -details -file $out/cdc.rpt
foreach type {max min} {
    set paths [get_timing_paths -delay_type $type -max_paths 1]
    if {[llength $paths] != 1} {error "missing $type timing path"}
    set slack [get_property SLACK $paths]
    if {$slack < 0} {error "$type timing failed: $slack ns"}
}
if {[llength [get_drc_violations -filter {SEVERITY == "Error" || SEVERITY == "Critical Warning"}]] != 0} {
    error {DRC errors or critical warnings}
}
write_checkpoint -force $out/c6v_timing_closed.dcp
write_bitstream -force $out/c6v_timing_closed.bit
write_hw_platform -fixed -include_bit -force -file $out/c6v_timing_closed.xsa
puts TIMING_CLOSED_REPLAY_READY
