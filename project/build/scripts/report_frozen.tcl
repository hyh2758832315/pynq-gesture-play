# PYNQ-Z2 xc7z020clg400-1 / Vivado 2026.1. No physical board access.
# Run: vivado -mode batch -source build/scripts/report_frozen.tcl
# Outputs: build/reports/frozen_{utilization,timing,clocks,drc,route}.rpt.
# Next: compare exact DCP SHA with board/runtime and assess final timing/resources.
set root [file normalize [file join [file dirname [info script]] ../..]]
if {[version -short] ne {2026.1}} {error {Vivado 2026.1 required}}
set out [file join $root build reports]
file mkdir $out
open_checkpoint [file join $root board runtime overlay candidate.dcp]
if {[get_property PART [current_design]] ne {xc7z020clg400-1}} {error {wrong part}}
report_utilization -file $out/frozen_utilization.rpt
report_timing_summary -delay_type min_max -report_unconstrained -file $out/frozen_timing.rpt
report_clocks -file $out/frozen_clocks.rpt
report_drc -file $out/frozen_drc.rpt
report_route_status -file $out/frozen_route.rpt
close_design
puts FROZEN_REPORTS_COMPLETE
