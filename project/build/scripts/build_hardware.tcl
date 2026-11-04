# Vivado 2026.1 / PYNQ-Z2 xc7z020clg400-1, full non-incremental rebuild.
# Run: vivado -mode batch -source build/scripts/build_hardware.tcl -tclargs NEW_OUTPUT_DIR [GPU_PROFILE]
# Output: NEW_OUTPUT_DIR/gesture_play plus result/{candidate.dcp,*.bit,*.xsa,*.rpt}.
# Next: verify timing/DRC, exported interface and software pairing before board use.
set script_dir [file dirname [file normalize [info script]]]
if {[version -short] ne {2026.1} || $argc < 1 || $argc > 2} {error {Vivado 2026.1 and a fresh output directory required}}
set gpu_profile [expr {$argc == 2 ? [lindex $argv 1] : {cache_pipeline_pair}}]
if {$gpu_profile ni {baseline cache_pipeline cache_pipeline_pair}} {error {Unknown GPU profile}}
set destination [file normalize [lindex $argv 0]]
if {[file exists $destination]} {error {Output exists; preserve earlier evidence}}
file mkdir $destination
cd $destination
set ::user_project_name gesture_play
set ::argc 0
set ::argv {}
source [file join $script_dir recreate_project.tcl]
source [file join $script_dir apply_gpu_profile.tcl]
current_run -synthesis [get_runs synth_button_r23]
current_run -implementation [get_runs impl_button_r23]
set_property AUTO_INCREMENTAL_CHECKPOINT 0 [get_runs synth_button_r23]
set_property AUTO_INCREMENTAL_CHECKPOINT 0 [get_runs impl_button_r23]
set_property INCREMENTAL_CHECKPOINT {} [get_runs impl_button_r23]
launch_runs synth_button_r23 -jobs 4
wait_on_run synth_button_r23
if {[get_property PROGRESS [get_runs synth_button_r23]] ne {100%}} {error {Synthesis incomplete}}
launch_runs impl_button_r23 -to_step write_bitstream -jobs 4
wait_on_run impl_button_r23
if {![string match {*write_bitstream Complete*} [get_property STATUS [get_runs impl_button_r23]]]} {error {Implementation incomplete}}
set completed_checkpoint [file join [get_property DIRECTORY [get_runs impl_button_r23]] c6v_wrapper_postroute_physopt.dcp]
if {![file exists $completed_checkpoint]} {error {Post-route physical optimization checkpoint missing}}
# Export in checkpoint mode: project mode include_bit can select the old run bit.
close_project
open_checkpoint $completed_checkpoint
set result_dir [file join $destination result]
source [file join $script_dir finish_timing.tcl]
close_design
puts FULL_REBUILD_COMPLETE
