# PYNQ-Z2 / Vivado 2026.1, offline route of the reviewed QoR placement.
# Run after close_design:
# source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/route_latency_admission_qor.tcl
# Outputs: physical-r03/route-r01/routed.dcp and min/max/route/skew/XDC evidence.
# Next: inspect real timing, decide whether post-route optimization is needed, then full signoff.
# Does not export a bitstream or access the board.
set arbase E:/projects/fpga/voice-view-game/build/hosd/c0e/admission-r01/physical-r03
set arout $arbase/route-r01
if {[file exists $arout]} {error {preserve route evidence}}
file mkdir $arout
file copy [info script] $arout/route_latency_admission_qor.tcl
open_checkpoint $arbase/optimization-r01/optimized.dcp
if {[get_property PART [current_design]] ne {xc7z020clg400-1} || [version -short] ne {2026.1}} {error {wrong tool/device}}
route_design -directive Explore -tns_cleanup
write_checkpoint $arout/routed.dcp
report_timing_summary -delay_type min_max -report_unconstrained -file $arout/timing.rpt
report_timing -delay_type max -max_paths 40 -nworst 1 -input_pins -file $arout/setup.rpt
report_timing -delay_type min -max_paths 10 -nworst 1 -input_pins -file $arout/hold.rpt
report_route_status -file $arout/route.rpt
report_bus_skew -warn_on_violation -file $arout/bus_skew.rpt
write_xdc -exclude_physical $arout/effective_timing.xdc
puts C0E_ADMISSION_QOR_ROUTED_REVIEW_REQUIRED
