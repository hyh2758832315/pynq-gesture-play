# PYNQ-Z2 xc7z020clg400-1, Vivado 2026.1 full button-only route.
# Run: D:/Xilinx/Vivado/2026.1/Vivado/bin/vivado.bat -mode batch -source E:/projects/fpga/voice-view-game/subprojects/button_only/route_button_only.tcl -log D:/vvg_button_only_r22/route.log -journal D:/vvg_button_only_r22/route.jou
# Output: D:/vvg_button_only_r22/route_{timing,drc,cdc,status}.rpt and routed DCP.
# Next: admit bitstream only if route, DRC, and timing reports pass.
set stage {D:/vvg_button_only_r22}
if {[version -short] ne {2026.1} || ![file exists $stage/synth_receipt.txt]} {
    error {synthesis is incomplete or Vivado version is wrong}
}
open_project $stage/c6_latency.xpr
if {[get_property PART [current_project]] ne {xc7z020clg400-1}} {error {wrong part}}
set synth [get_runs synth_button_r22]
set impl [get_runs impl_button_r22]
if {[llength $synth] != 1 || [llength $impl] != 1 ||
    [get_property PROGRESS $synth] ne {100%}} {error {full synthesis did not pass}}
if {[get_property AUTO_INCREMENTAL_CHECKPOINT $synth] ||
    [get_property AUTO_INCREMENTAL_CHECKPOINT $impl] ||
    [get_property INCREMENTAL_CHECKPOINT $impl] ne {}} {error {unexpected incremental reference}}
if {[file exists $stage/c6_latency.runs/impl_button_r22/c6v_wrapper_routed.dcp]} {
    error {preserve existing route checkpoint}
}
launch_runs impl_button_r22 -to_step route_design -jobs 4
wait_on_run impl_button_r22
set status [get_property STATUS $impl]
set progress [get_property PROGRESS $impl]
set out [open $stage/route_receipt.txt w]
puts $out "status=$status"
puts $out "progress=$progress"
puts $out "incremental_checkpoint=none"
puts $out "board_access=false"
close $out
if {![file exists $stage/c6_latency.runs/impl_button_r22/c6v_wrapper_routed.dcp]} {
    error "routed checkpoint missing: $status $progress"
}
open_checkpoint $stage/c6_latency.runs/impl_button_r22/c6v_wrapper_routed.dcp
report_timing_summary -delay_type min_max -report_unconstrained -file $stage/route_timing.rpt
report_route_status -file $stage/route_status.rpt
report_drc -file $stage/route_drc.rpt
report_cdc -details -file $stage/route_cdc.rpt
report_bus_skew -warn_on_violation -file $stage/route_bus_skew.rpt
close_design
close_project
puts BUTTON_ONLY_ROUTE_REPORTS_READY
