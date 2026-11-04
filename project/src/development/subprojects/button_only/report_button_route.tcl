# Report the already-routed isolated R22 checkpoint without rerunning implementation.
# Run: D:/Xilinx/Vivado/2026.1/Vivado/bin/vivado.bat -mode batch -source E:/projects/fpga/voice-view-game/subprojects/button_only/report_button_route.tcl -log D:/vvg_button_only_r22/report_route.log
# Output: route_{timing,status,drc,cdc,bus_skew}.rpt.
# Next: run postroute_button_only.tcl; inspect final timing/DRC before board access.
set stage {D:/vvg_button_only_r22}
if {[version -short] ne {2026.1} ||
    ![file exists $stage/c6_latency.runs/impl_button_r22/c6v_wrapper_routed.dcp]} {
    error {routed button checkpoint not available}
}
open_checkpoint $stage/c6_latency.runs/impl_button_r22/c6v_wrapper_routed.dcp
if {[get_property PART [current_design]] ne {xc7z020clg400-1}} {error {wrong part}}
report_timing_summary -delay_type min_max -report_unconstrained -file $stage/route_timing.rpt
report_route_status -file $stage/route_status.rpt
report_drc -file $stage/route_drc.rpt
report_cdc -details -file $stage/route_cdc.rpt
report_bus_skew -warn_on_violation -file $stage/route_bus_skew.rpt
close_design
puts BUTTON_ONLY_ROUTE_REPORTS_READY
