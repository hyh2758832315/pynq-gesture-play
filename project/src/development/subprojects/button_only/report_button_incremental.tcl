# PYNQ-Z2 xc7z020clg400-1, Vivado 2026.1 incremental signoff inspection.
# Run: D:/Xilinx/Vivado/2026.1/Vivado/bin/vivado.bat -mode batch -source E:/projects/fpga/voice-view-game/subprojects/button_only/report_button_incremental.tcl -log D:/vvg_button_only_r22/incremental_report.log
# Output: D:/vvg_button_only_r22/incremental_final_*.rpt, exports/c6v_incremental.xsa, incremental_final_receipt.txt.
# Next: admit the incremental bit/HWH only after nonnegative timing, DRC and topology checks; recheck the board gate before deployment.
set stage {D:/vvg_button_only_r22}
if {[version -short] ne {2026.1}} {error {wrong Vivado version}}
open_project $stage/c6_latency.xpr
if {[get_property PART [current_project]] ne {xc7z020clg400-1}} {error {wrong part}}
set run [get_runs impl_button_incremental_r22]
if {[llength $run] != 1 ||
    ![string match {*write_bitstream Complete*} [get_property STATUS $run]] ||
    ![file exists $stage/c6_latency.runs/impl_button_incremental_r22/c6v_wrapper.bit]} {
    error {incremental bitstream is incomplete}
}
open_run impl_button_incremental_r22
report_timing_summary -delay_type min_max -report_unconstrained -file $stage/incremental_final_timing.rpt
report_route_status -file $stage/incremental_final_route_status.rpt
report_drc -file $stage/incremental_final_drc.rpt
report_cdc -details -file $stage/incremental_final_cdc.rpt
report_bus_skew -warn_on_violation -file $stage/incremental_final_bus_skew.rpt
set export_dir $stage/exports
file mkdir $export_dir
write_hw_platform -fixed -include_bit -force -file $export_dir/c6v_incremental.xsa
set out [open $stage/incremental_final_receipt.txt w]
puts $out "status=[get_property STATUS $run]"
puts $out "xsa=$export_dir/c6v_incremental.xsa"
puts $out {board_access=false}
close $out
close_project
puts BUTTON_ONLY_INCREMENTAL_REPORT_READY
