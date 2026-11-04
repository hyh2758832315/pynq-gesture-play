# PYNQ-Z2 / Vivado 2026.1. Offline correction of measured routed timing violations.
# Run after close_design:
# source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/postroute_latency_admission_qor.tcl
# Optional: set ::admission_postroute_root to the physical-r04 directory.
# For physical-r04 also set ::admission_postroute_checkpoint to the actual reviewed route DCP.
# Outputs: selected root/postroute-r01/optimized.dcp, timing/route/skew/XDC, phase facts.
# Next: complete physical report collection and independent signoff; no bit or board access.
set apcommon E:/projects/fpga/voice-view-game/build/hosd/c0e/admission-r01
if {[info exists ::admission_postroute_root]} {
    set apbase [file normalize $::admission_postroute_root]
} else {
    set apbase $apcommon/physical-r03
}
if {$apbase ni [list $apcommon/physical-r03 $apcommon/physical-r04]} {error {unrecognized post-route root}}
if {[info exists ::admission_postroute_checkpoint]} {
    set apinput [file normalize $::admission_postroute_checkpoint]
} elseif {$apbase eq "$apcommon/physical-r03"} {
    set apinput $apbase/route-r01/routed.dcp
} else {
    error {select actual physical-r04 route checkpoint}
}
if {$apinput ni [list $apbase/route-r01/routed.dcp $apbase/route-r02/routed.dcp]} {error {unrecognized post-route input}}
set apout $apbase/postroute-r01
if {[file exists $apout]} {error {preserve post-route evidence}}
file mkdir $apout
file copy [info script] $apout/postroute_latency_admission_qor.tcl
open_checkpoint $apinput
set apwns [get_property SLACK [get_timing_paths -delay_type max -max_paths 1]]
set apwhs [get_property SLACK [get_timing_paths -delay_type min -max_paths 1]]
set apfp [open $apout/phases.tcldict {WRONLY CREAT EXCL}]
puts $apfp [list input $apinput]
puts $apfp [list phase input wns $apwns whs $apwhs]
if {$apwns>=0 && $apwhs>=0} {close $apfp; error {input already meets timing; inspect before unnecessary optimization}}
if {$apwns<0} {
    phys_opt_design -directive Explore
    report_timing_summary -delay_type min_max -file $apout/after_explore_timing.rpt
    puts $apfp [list phase explore wns [get_property SLACK [get_timing_paths -delay_type max -max_paths 1]] whs [get_property SLACK [get_timing_paths -delay_type min -max_paths 1]]]
}
if {[get_property SLACK [get_timing_paths -delay_type min -max_paths 1]]<0} {
    phys_opt_design -hold_fix
    puts $apfp [list phase hold_fix wns [get_property SLACK [get_timing_paths -delay_type max -max_paths 1]] whs [get_property SLACK [get_timing_paths -delay_type min -max_paths 1]]]
}
close $apfp
write_checkpoint $apout/optimized.dcp
report_timing_summary -delay_type min_max -report_unconstrained -file $apout/timing.rpt
report_timing -delay_type max -max_paths 40 -nworst 1 -input_pins -file $apout/setup.rpt
report_timing -delay_type min -max_paths 10 -nworst 1 -input_pins -file $apout/hold.rpt
report_route_status -file $apout/route.rpt
report_bus_skew -warn_on_violation -file $apout/bus_skew.rpt
write_xdc -exclude_physical $apout/effective_timing.xdc
puts C0E_ADMISSION_QOR_POSTROUTE_COMPLETE_REQUIRES_FULL_SIGNOFF
