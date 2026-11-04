# PYNQ-Z2 xc7z020clg400-1, Vivado 2026.1 post-route optimization and export.
# Run: D:/Xilinx/Vivado/2026.1/Vivado/bin/vivado.bat -mode batch -source E:/projects/fpga/voice-view-game/subprojects/button_only/postroute_button_only.tcl -log D:/vvg_button_only_r22/postroute.log
# Output: final_timing.rpt, final_drc.rpt, candidate bitstream and XSA.
# Next: admit only if final timing, DRC and paired HWH checks pass; then recheck board gate.
set stage {D:/vvg_button_only_r22}
if {[version -short] ne {2026.1} || ![file exists $stage/route_receipt.txt]} {
    error {route is incomplete or Vivado version is wrong}
}
open_project $stage/c6_latency.xpr
if {[get_property PART [current_project]] ne {xc7z020clg400-1}} {error {wrong part}}
set impl [get_runs impl_button_r22]
if {[llength $impl] != 1 ||
    [get_property INCREMENTAL_CHECKPOINT $impl] ne {} ||
    ![file exists $stage/c6_latency.runs/impl_button_r22/c6v_wrapper_routed.dcp]} {
    error {wrong routed implementation}
}
launch_runs impl_button_r22 -to_step write_bitstream -jobs 4
wait_on_run impl_button_r22
set status [get_property STATUS $impl]
if {![string match {*write_bitstream Complete*} $status]} {
    error "bitstream build incomplete: $status"
}
open_run impl_button_r22
report_timing_summary -delay_type min_max -report_unconstrained -file $stage/final_timing.rpt
report_route_status -file $stage/final_route_status.rpt
report_drc -file $stage/final_drc.rpt
report_cdc -details -file $stage/final_cdc.rpt
report_bus_skew -warn_on_violation -file $stage/final_bus_skew.rpt
set export_dir $stage/exports
file mkdir $export_dir
write_hw_platform -fixed -include_bit -force -file $export_dir/c6v_candidate.xsa
set out [open $stage/postroute_receipt.txt w]
puts $out "status=$status"
puts $out "xsa=$export_dir/c6v_candidate.xsa"
puts $out "board_access=false"
close $out
close_project
puts BUTTON_ONLY_POSTROUTE_EXPORT_READY
