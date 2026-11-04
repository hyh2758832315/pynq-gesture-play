# PYNQ-Z2 xc7z020clg400-1, Vivado 2026.1, full non-incremental synthesis.
# Run: D:/Xilinx/Vivado/2026.1/Vivado/bin/vivado.bat -mode batch -source E:/projects/fpga/voice-view-game/subprojects/button_only/synthesize_button_only.tcl -log D:/vvg_button_only_r22/synth.log -journal D:/vvg_button_only_r22/synth.jou
# Output: D:/vvg_button_only_r22/c6_latency.runs/synth_button_r22/c6v_wrapper.dcp, synth_receipt.txt.
# Next: run implementation and inspect timing/DRC before packaging or board load.
set stage {D:/vvg_button_only_r22}
if {[version -short] ne {2026.1} || ![file exists $stage/configured_receipt.txt]} {
    error {button-only stage is incomplete or Vivado version is wrong}
}
open_project $stage/c6_latency.xpr
if {[get_property PART [current_project]] ne {xc7z020clg400-1}} {error {wrong part}}
if {[llength [get_files -quiet *voice_volume*.sv]] ||
    [llength [get_files -quiet *c6v_volume*.xdc]] ||
    [llength [get_files -quiet *button_only.xdc]] != 1} {
    error {audio sources/constraints remain or button constraints missing}
}
reset_runs c6v_input_osd_0_0_synth_1
if {[llength [get_runs -quiet synth_button_r22]] == 0} {
    create_run synth_button_r22 -flow [get_property FLOW [get_runs synth_1]] -strategy [get_property STRATEGY [get_runs synth_1]] -constrset constrs_1
    create_run impl_button_r22 -parent_run synth_button_r22 -flow [get_property FLOW [get_runs impl_1]] -strategy [get_property STRATEGY [get_runs impl_1]] -constrset constrs_1
}
set_property AUTO_INCREMENTAL_CHECKPOINT 0 [get_runs synth_button_r22]
set_property AUTO_INCREMENTAL_CHECKPOINT 0 [get_runs impl_button_r22]
set_property INCREMENTAL_CHECKPOINT {} [get_runs impl_button_r22]
set_property STEPS.OPT_DESIGN.TCL.POST {E:/projects/fpga/voice-view-game/subprojects/button_only/constraints/postopt_button_admission.tcl} [get_runs impl_button_r22]
set_property STEPS.PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_button_r22]
set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_button_r22]
set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_button_r22]
update_compile_order -fileset sources_1
report_ip_status -file $stage/synth_ip_status.rpt
launch_runs synth_button_r22 -jobs 8
wait_on_run synth_button_r22
set status [get_property STATUS [get_runs synth_button_r22]]
set progress [get_property PROGRESS [get_runs synth_button_r22]]
set out [open $stage/synth_receipt.txt w]
puts $out "status=$status"
puts $out "progress=$progress"
puts $out "incremental_checkpoint=none"
puts $out "board_access=false"
close $out
if {$progress ne {100%} || ![string match {*Complete*} $status]} {
    error "button synthesis failed: $status $progress"
}
close_project
puts BUTTON_ONLY_SYNTH_PASS
