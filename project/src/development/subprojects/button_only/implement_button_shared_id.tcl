# PYNQ-Z2 xc7z020clg400-1, Vivado 2026.1 full route, post-route physical optimization and XSA export.
# Run: D:/Xilinx/Vivado/2026.1/Vivado/bin/vivado.bat -mode batch -source E:/projects/fpga/voice-view-game/subprojects/button_only/implement_button_shared_id.tcl -log D:/vvg_button_only_r23b/implement.log
# Output: D:/vvg_button_only_r23b/final_*.rpt, impl_button_r23/c6v_wrapper_postroute_physopt.dcp, exports/c6v_candidate.xsa.
# Next: require nonnegative WNS/WHS/WPWS, clean DRC and verified HWH/bit pairing before board access.
set stage {D:/vvg_button_only_r23b}
if {[version -short] ne {2026.1} || ![file exists $stage/synth_receipt.txt]} {
    error {R23 full synthesis missing or wrong Vivado version}
}
open_project $stage/c6_latency.xpr
if {[get_property PART [current_project]] ne {xc7z020clg400-1}} {error {wrong part}}
set synth [get_runs synth_button_r23]
set impl [get_runs impl_button_r23]
if {[llength $synth] != 1 || [llength $impl] != 1 ||
    [get_property PROGRESS $synth] ne {100%} ||
    [get_property INCREMENTAL_CHECKPOINT $impl] ne {} ||
    [file exists $stage/c6_latency.runs/impl_button_r23/c6v_wrapper_routed.dcp]} {
    error {wrong synthesis, implementation, or preexisting route}
}
launch_runs impl_button_r23 -to_step write_bitstream -jobs 4
wait_on_run impl_button_r23
set status [get_property STATUS $impl]
if {![string match {*write_bitstream Complete*} $status]} {
    error "implementation incomplete: $status"
}
open_run impl_button_r23
report_timing_summary -delay_type min_max -report_unconstrained -file $stage/final_timing.rpt
report_route_status -file $stage/final_route_status.rpt
report_drc -file $stage/final_drc.rpt
report_cdc -details -file $stage/final_cdc.rpt
report_bus_skew -warn_on_violation -file $stage/final_bus_skew.rpt
report_utilization -file $stage/final_utilization.rpt
set export_dir $stage/exports
file mkdir $export_dir
write_hw_platform -fixed -include_bit -force -file $export_dir/c6v_candidate.xsa
set out [open $stage/implementation_receipt.txt w]
puts $out "status=$status"
puts $out "xsa=$export_dir/c6v_candidate.xsa"
puts $out {board_access=false}
close $out
close_project
puts BUTTON_SHARED_ID_IMPLEMENTATION_REPORT_READY
