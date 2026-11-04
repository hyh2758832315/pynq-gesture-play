# PYNQ-Z2 Vivado 2026.1: isolated incremental implementation of full R22 synthesis.
# Run: D:/Xilinx/Vivado/2026.1/Vivado/bin/vivado.bat -mode batch -source E:/projects/fpga/voice-view-game/subprojects/button_only/route_button_incremental.tcl -log D:/vvg_button_only_r22/incremental.log
# Output: D:/vvg_button_only_r22/c6_latency.runs/impl_button_incremental_r22/c6v_wrapper.bit and incremental_receipt.txt.
# Next: inspect final timing/DRC/reuse reports; select only a timing-clean candidate.
set stage {D:/vvg_button_only_r22}
set repo {E:/projects/fpga/voice-view-game}
set reference $repo/deliveries/c6i-pl-vision-volume-osd-r21-marker-r02-20261023/overlay/candidate.dcp
set expected_sha {0D2E035785DA9A93E03990FFDF3A6CB61868CE4AF4CF488222516161F44CE3D5}
if {[version -short] ne {2026.1}} {error {wrong Vivado version}}
set actual_sha [string toupper [string trim [exec $repo/.venv/Scripts/python.exe -B -c {import hashlib,sys;print(hashlib.sha256(open(sys.argv[1],'rb').read()).hexdigest())} $reference]]]
if {$actual_sha ne $expected_sha} {error {R21 timing-clean reference DCP changed}}
open_project $stage/c6_latency.xpr
if {[get_property PART [current_project]] ne {xc7z020clg400-1} ||
    [get_property PROGRESS [get_runs synth_button_r22]] ne {100%}} {
    error {wrong part or missing full R22 synthesis}
}
if {[llength [get_runs -quiet impl_button_incremental_r22]] != 0} {
    error {preserve existing incremental trial}
}
add_files -fileset utils_1 -norecurse $reference
create_run impl_button_incremental_r22 -parent_run synth_button_r22 -flow [get_property FLOW [get_runs impl_1]] -strategy [get_property STRATEGY [get_runs impl_1]] -constrset constrs_1
set run [get_runs impl_button_incremental_r22]
set_property AUTO_INCREMENTAL_CHECKPOINT 0 $run
set_property INCREMENTAL_CHECKPOINT $reference $run
set_property STEPS.OPT_DESIGN.TCL.POST $repo/subprojects/button_only/constraints/postopt_button_admission.tcl $run
set_property STEPS.PHYS_OPT_DESIGN.IS_ENABLED true $run
set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.IS_ENABLED true $run
set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.ARGS.DIRECTIVE Explore $run
set out [open $stage/incremental_receipt.txt w]
puts $out "board=PYNQ-Z2 xc7z020clg400-1"
puts $out "vivado=[version -short]"
puts $out "full_synth=synth_button_r22"
puts $out "reference_sha256=$actual_sha"
puts $out "board_access=false"
close $out
launch_runs impl_button_incremental_r22 -to_step write_bitstream -jobs 4
wait_on_run impl_button_incremental_r22
set status [get_property STATUS $run]
set out [open $stage/incremental_receipt.txt a]
puts $out "status=$status"
close $out
if {![file exists $stage/c6_latency.runs/impl_button_incremental_r22/c6v_wrapper.bit]} {
    error "incremental implementation did not make a bitstream: $status"
}
puts BUTTON_ONLY_INCREMENTAL_BIT_READY
close_project
