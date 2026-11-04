# PYNQ-Z2 xc7z020clg400-1 / Vivado 2026.1, offline targeted decode replication route.
# Run after close_design:
# source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/route_latency_admission_decode.tcl
# Outputs: physical-r04/route-r02/routed.dcp, input identity, STA/route/skew/reuse/XDC reports.
# Next: compare real routed timing and constraints; full independent signoff is still mandatory.
# No RTL/clock changes, bit export, or board access.
set adrepo E:/projects/fpga/voice-view-game
set adbase $adrepo/build/hosd/c0e/admission-r01/physical-r04
set adinput $adbase/targeted-r03/after_force.dcp
set adout $adbase/route-r02
if {[file exists $adout]} {error {preserve targeted route evidence}}
set adsha [exec $adrepo/.venv/Scripts/python.exe -B -c {import hashlib,sys; print(hashlib.sha256(open(sys.argv[1],'rb').read()).hexdigest())} $adinput]
if {$adsha ne {3aa83c301bd35c2cd379cbdee3863cca67439c8cf3ce1b46a150f926259c1579}} {error {wrong targeted checkpoint identity}}
file mkdir $adout
file copy [info script] $adout/route_latency_admission_decode.tcl
set adfp [open $adout/input.tcldict {WRONLY CREAT EXCL}]
puts $adfp [list input $adinput sha256 $adsha]
close $adfp
open_checkpoint $adinput
if {[get_property PART [current_design]] ne {xc7z020clg400-1} || [version -short] ne {2026.1}} {error {wrong tool/device}}
write_xdc -exclude_physical $adout/before_route_timing.xdc
report_route_status -file $adout/before_route.rpt
route_design -directive Explore -tns_cleanup
write_checkpoint $adout/routed.dcp
report_timing_summary -delay_type min_max -report_unconstrained -file $adout/timing.rpt
report_timing -delay_type max -max_paths 40 -nworst 1 -input_pins -file $adout/setup.rpt
report_timing -delay_type min -max_paths 10 -nworst 1 -input_pins -file $adout/hold.rpt
report_route_status -file $adout/route.rpt
report_bus_skew -warn_on_violation -file $adout/bus_skew.rpt
report_incremental_reuse -file $adout/reuse.rpt
write_xdc -exclude_physical $adout/effective_timing.xdc
puts C0E_ADMISSION_TARGETED_DECODE_ROUTED_REVIEW_REQUIRED
