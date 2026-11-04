# Owned non-project6044, actual postroute-r05 optimized design only.
# source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/export_latency_bit.tcl
# Output: reviewed C0E c6v_candidate.bit; no programming or board access.
# Next: project-based paired XSA/HWH export and byte identity verification.
set root {E:/projects/fpga/voice-view-game}
set output $root/build/hosd/c0e/postroute-r05/signoff
set receipt $root/subprojects/hdmi_input_osd/integration/evidence/latency-signoff-r05.json
# Later independently reviewed candidates may select new immutable paths. The
# exact +.003/+.051 live timing signature remains a mandatory gate here.
if {[info exists ::latency_export_root]} {set output $::latency_export_root/signoff}
if {[info exists ::latency_export_review]} {set receipt $::latency_export_review}
if {![file isfile $receipt] || ![file isfile $output/candidate.dcp]} {error {review missing}}
set fp [open $receipt r]
set review [read $fp]
close $fp
if {![string match {*C0E_TIMING_ROUTE_AND_SCOPED_REVIEW_PASS*} $review]} {error {review failed}}
if {[get_property PART [current_design]] ne {xc7z020clg400-1}} {error {wrong part}}
if {[get_property SLACK [get_timing_paths -delay_type max -max_paths 1]] != 0.003 ||
    [get_property SLACK [get_timing_paths -delay_type min -max_paths 1]] != 0.051} {error {reviewed timing differs}}
if {[file exists $output/c6v_candidate.bit]} {error {preserve bit export}}
write_bitstream $output/c6v_candidate.bit
puts C0E_REVIEWED_BIT_EXPORTED_NOT_BOARD_VALIDATED
