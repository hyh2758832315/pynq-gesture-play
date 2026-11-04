# PYNQ-Z2 xc7z020clg400-1 / Vivado 2026.1. Offline incremental TimingClosure experiment.
# Run: source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/place_latency_admission_closure.tcl
# Outputs: physical-r04 input/reference snapshots, reuse report, placed DCP and timing.
# Next: inspect actual reuse/timing/constraints, then route and complete physical signoff.
# Reference WNS=-0.195ns is a failed experiment input, not a release candidate.
set acrepo E:/projects/fpga/voice-view-game
set acbase $acrepo/build/hosd/c0e/admission-r01
set acout $acbase/physical-r04
if {[file exists $acout]} {error {preserve previous closure experiment}}
set acinput $acbase/opt-review-r02/candidate.dcp
set acreference $acbase/physical-r03/signoff/candidate.dcp
foreach {acfile acexpected} [list $acinput 84d691039e5626b0f4c93f9a70c85e5a6f866c6a61206c11f73a7a767750d7c7 $acreference ca7097fc86e206e3b6347fabf5a96f7feab104182634c1ec5f0f3771dbafda07] {
    set acactual [exec $acrepo/.venv/Scripts/python.exe -B -c {import hashlib,sys; print(hashlib.sha256(open(sys.argv[1],'rb').read()).hexdigest())} $acfile]
    if {$acactual ne $acexpected} {error {unreviewed closure input identity}}
}
file mkdir $acout
file copy [info script] $acout/place_latency_admission_closure.tcl
file copy $acinput $acout/input_opt.dcp
file copy $acreference $acout/reference.dcp
file copy $acbase/physical-r03/project_synthesis_files.txt $acout/project_synthesis_files.txt
open_checkpoint $acout/input_opt.dcp
if {[get_property PART [current_design]] ne {xc7z020clg400-1} || [version -short] ne {2026.1}} {error {wrong device/tool}}
set acnet [get_nets {c6v_i/capture_write_pair/inst/rgb/frame_completion.read_pointer[1]}]
if {[llength $acnet]!=1} {error {QoR target drift}}
set_property MAX_FANOUT_MODE CLOCK_REGION $acnet
set_property FORCE_MAX_FANOUT 3 $acnet
read_checkpoint -incremental -directive TimingClosure $acout/reference.dcp
report_incremental_reuse -file $acout/reuse_before_place.rpt
write_xdc -exclude_physical $acout/before_place_timing.xdc
exec $acrepo/.venv/Scripts/python.exe -B -c {from pathlib import Path; import sys; active=lambda p:[s.strip() for s in Path(p).read_text().splitlines() if s.strip() and not s.lstrip().startswith('#')]; assert active(sys.argv[1])==active(sys.argv[2]),'inherited timing constraints changed'; print('CLOSURE_TIMING_CONSTRAINTS_EXACT')} $acbase/opt-review-r02/effective_timing.xdc $acout/before_place_timing.xdc
place_design -directive Explore
write_checkpoint $acout/placed.dcp
report_timing_summary -delay_type min_max -report_unconstrained -file $acout/placed_timing.rpt
report_timing -delay_type max -max_paths 40 -nworst 1 -input_pins -file $acout/placed_setup.rpt
report_utilization -file $acout/placed_utilization.rpt
write_xdc -exclude_physical $acout/after_place_timing.xdc
puts C0E_ADMISSION_TIMING_CLOSURE_PLACED_REQUIRES_ROUTE
