# PYNQ-Z2 / Vivado 2026.1, offline TimingClosure route after physical-r04 placement.
# Run after close_design:
# source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/route_latency_admission_closure.tcl
# Outputs: physical-r04/route-r01 DCP, timing/route/skew/reuse/XDC reports.
# Next: inspect actual setup/hold; perform any further optimization in a separate evidence directory.
# No bit export or board access; full signoff remains mandatory.
set arrepo E:/projects/fpga/voice-view-game
set arbase $arrepo/build/hosd/c0e/admission-r01/physical-r04
set arout $arbase/route-r01
if {[file exists $arout]} {error {preserve closure route evidence}}
file mkdir $arout
file copy [info script] $arout/route_latency_admission_closure.tcl
open_checkpoint $arbase/placed.dcp
if {[get_property PART [current_design]] ne {xc7z020clg400-1} || [version -short] ne {2026.1}} {error {wrong tool/device}}
route_design -directive Explore -tns_cleanup
write_checkpoint $arout/routed.dcp
report_timing_summary -delay_type min_max -report_unconstrained -file $arout/timing.rpt
report_timing -delay_type max -max_paths 40 -nworst 1 -input_pins -file $arout/setup.rpt
report_timing -delay_type min -max_paths 10 -nworst 1 -input_pins -file $arout/hold.rpt
report_route_status -file $arout/route.rpt
report_bus_skew -warn_on_violation -file $arout/bus_skew.rpt
report_incremental_reuse -file $arout/reuse.rpt
write_xdc -exclude_physical $arout/effective_timing.xdc
puts C0E_ADMISSION_TIMING_CLOSURE_ROUTED_REVIEW_REQUIRED
