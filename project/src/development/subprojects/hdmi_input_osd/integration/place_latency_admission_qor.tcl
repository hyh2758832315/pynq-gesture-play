# PYNQ-Z2 xc7z020clg400-1 / Vivado 2026.1. Offline physical experiment only.
# Run: source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/place_latency_admission_qor.tcl
# Outputs: admission-r01/physical-r03/input_opt.dcp, placed.dcp, placement reports and exact target binding.
# Next: inspect placement paths/available QoR driver pins, optimize and route before full signoff.
# No RTL changes, no inherited incremental placement, no board access or bit export.
set aqrepo E:/projects/fpga/voice-view-game
set aqbase $aqrepo/build/hosd/c0e/admission-r01
set aqout $aqbase/physical-r03
if {[file exists $aqout]} {error {preserve prior physical experiment}}
set aqinput $aqbase/opt-review-r02/candidate.dcp
set aqsha [exec $aqrepo/.venv/Scripts/python.exe -B -c {import hashlib,sys; print(hashlib.sha256(open(sys.argv[1],'rb').read()).hexdigest())} $aqinput]
if {$aqsha ne {84d691039e5626b0f4c93f9a70c85e5a6f866c6a61206c11f73a7a767750d7c7}} {error {unreviewed opt input}}
file mkdir $aqout
file copy [info script] $aqout/place_latency_admission_qor.tcl
file copy $aqinput $aqout/input_opt.dcp
file copy $aqbase/physical-r01/project_synthesis_files.txt $aqout/project_synthesis_files.txt
file copy $aqbase/diagnostic-r01/qor_tcl/RQSImpl.tcl $aqout/reviewed_qor_reference.tcl
open_checkpoint $aqout/input_opt.dcp
if {[get_property PART [current_design]] ne {xc7z020clg400-1} || [version -short] ne {2026.1}} {error {wrong target/tool}}
set aqnet [get_nets {c6v_i/capture_write_pair/inst/rgb/frame_completion.read_pointer[1]}]
if {[llength $aqnet]!=1} {error {QoR target missing or ambiguous}}
set aqdriver [get_pins -leaf -of_objects $aqnet -filter {DIRECTION == OUT}]
if {[llength $aqdriver]!=1 || $aqdriver ne {c6v_i/capture_write_pair/inst/rgb/frame_completion.read_pointer_reg[1]/Q}} {error {QoR target driver mismatch}}
set aqfp [open $aqout/target_before.tcldict {WRONLY CREAT EXCL}]
puts $aqfp [dict create input_sha256 $aqsha net $aqnet driver $aqdriver loads [get_pins -leaf -of_objects $aqnet -filter {DIRECTION == IN}] reference RQS_TIMING-3-1]
close $aqfp
set_property MAX_FANOUT_MODE CLOCK_REGION $aqnet
set_property FORCE_MAX_FANOUT 3 $aqnet
if {![string equal -nocase [get_property MAX_FANOUT_MODE $aqnet] {CLOCK_REGION}] || [get_property FORCE_MAX_FANOUT $aqnet]!=3} {error {QoR property did not bind}}
write_xdc -exclude_physical $aqout/before_place_timing.xdc
place_design -directive Explore
write_checkpoint $aqout/placed.dcp
report_timing_summary -delay_type min_max -report_unconstrained -file $aqout/placed_timing.rpt
report_timing -delay_type max -max_paths 40 -nworst 1 -input_pins -file $aqout/placed_setup.rpt
report_utilization -file $aqout/placed_utilization.rpt
write_xdc -exclude_physical $aqout/after_place_timing.xdc
set aqfp [open $aqout/qor_driver_binding.tcldict {WRONLY CREAT EXCL}]
foreach aqpin {
    c6v_i/capture_write_pair/inst/rgb/frame_completion.completed_frames[31]_i_12__0/O
    c6v_i/dual_mask_capture/inst/capture/drain/frame_fault_INST_0/O
    c6v_i/gp0_smc/inst/s00_entry_pipeline/s00_mmu/inst/aw_reg_stall/gen_wroute_reg.wroute_i[10]_i_2/O
    c6v_i/gp0_smc/inst/s00_entry_pipeline/s00_mmu/inst/aw_reg_stall/gen_wroute_reg.wroute_i[7]_i_1/O
    c6v_i/voice_volume_0/inst/registers/core/event_age[31]_i_7/O
    c6v_i/voice_volume_0/inst/registers/core/event_sample[63]_i_1_comp/O
} {
    set aqmatches [get_pins -quiet $aqpin]
    puts $aqfp [list requested $aqpin matches $aqmatches count [llength $aqmatches]]
}
close $aqfp
puts C0E_ADMISSION_QOR_PLACED_REQUIRES_PHYSICAL_REVIEW
