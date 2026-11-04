# PYNQ-Z2 xc7z020clg400-1, Vivado 2026.1 full synthesis for shared BUILD_ID/button GPIO.
# Run: D:/Xilinx/Vivado/2026.1/Vivado/bin/vivado.bat -mode batch -source E:/projects/fpga/voice-view-game/subprojects/button_only/synthesize_button_shared_id.tcl -log D:/vvg_button_only_r23b/synth.log
# Output: D:/vvg_button_only_r23b/c6_latency.runs/synth_button_r23/c6v_wrapper.dcp and synth_receipt.txt.
# Next: run independent implementation; inspect final timing and DRC before pairing software or boarding.
set stage {D:/vvg_button_only_r23b}
if {[version -short] ne {2026.1} || ![file exists $stage/configured_receipt.txt]} {
    error {R23 button-only stage incomplete or wrong Vivado version}
}
open_project $stage/c6_latency.xpr
if {[get_property PART [current_project]] ne {xc7z020clg400-1}} {error {wrong part}}
if {[llength [get_files -quiet *voice_volume*.sv]] ||
    [llength [get_files -quiet *c6v_volume*.xdc]] ||
    [llength [get_files -quiet *button_only.xdc]] != 1} {
    error {audio sources/constraints remain or button constraints missing}
}
reset_runs c6v_input_osd_0_0_synth_1
if {[llength [get_runs -quiet synth_button_r23]] != 0} {error {preserve existing synthesis trial}}
create_run synth_button_r23 -flow [get_property FLOW [get_runs synth_1]] -strategy [get_property STRATEGY [get_runs synth_1]] -constrset constrs_1
create_run impl_button_r23 -parent_run synth_button_r23 -flow [get_property FLOW [get_runs impl_1]] -strategy [get_property STRATEGY [get_runs impl_1]] -constrset constrs_1
set synth [get_runs synth_button_r23]
set impl [get_runs impl_button_r23]
set_property AUTO_INCREMENTAL_CHECKPOINT 0 $synth
set_property AUTO_INCREMENTAL_CHECKPOINT 0 $impl
set_property INCREMENTAL_CHECKPOINT {} $impl
set_property STEPS.OPT_DESIGN.TCL.POST {E:/projects/fpga/voice-view-game/subprojects/button_only/constraints/postopt_button_admission.tcl} $impl
set_property STEPS.PHYS_OPT_DESIGN.IS_ENABLED true $impl
set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.IS_ENABLED true $impl
set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.ARGS.DIRECTIVE Explore $impl
update_compile_order -fileset sources_1
report_ip_status -file $stage/synth_ip_status.rpt
launch_runs synth_button_r23 -jobs 8
wait_on_run synth_button_r23
set status [get_property STATUS $synth]
set progress [get_property PROGRESS $synth]
set out [open $stage/synth_receipt.txt w]
puts $out "status=$status"
puts $out "progress=$progress"
puts $out {incremental_checkpoint=none}
puts $out {board_access=false}
close $out
if {$progress ne {100%} || ![string match {*Complete*} $status]} {
    error "R23 button synthesis failed: $status $progress"
}
close_project
puts BUTTON_SHARED_ID_SYNTH_PASS
