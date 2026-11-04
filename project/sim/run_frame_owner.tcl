# Vivado 2026.1: vivado -mode batch -source sim/run_frame_owner.tcl
# Optional -tclargs NEW_OUTPUT_DIR. Output: project, simulation logs and result.txt.
# Next: read TEST_PASS and scenario count; no claim of full-system simulation.
set root [file normalize [file join [file dirname [info script]] ..]]
set output [file join $root build/output/frame_owner_01]
if {$argc == 1} {set output [file normalize [lindex $argv 0]]}
if {$argc > 1} {error {At most one fresh output directory is accepted}}
if {[file exists $output]} {error {Output already exists; preserve earlier evidence or choose a clean package copy}}
create_project frame_owner $output -part xc7z020clg400-1
add_files [file join $root build/hardware/c6_latency/c6_latency.srcs/sources_1/imports/rtl/vision_frame_owner.sv]
add_files -fileset sim_1 [file join $root src/development/tests/rtl/tb_vision_frame_owner.sv]
set_property top tb_vision_frame_owner [get_filesets sim_1]
set_property target_simulator XSim [current_project]
set_property xsim.simulate.runtime all [get_filesets sim_1]
update_compile_order -fileset sim_1
launch_simulation -simset sim_1 -mode behavioral
close_sim
set transcript [file join $output frame_owner.sim/sim_1/behav/xsim/simulate.log]
set f [open $transcript r]
set body [read $f]
close $f
if {![regexp {TEST_PASS VISION_FRAME_OWNER scenarios=14 checks=([0-9]+)} $body -> checks] || [regexp -nocase {fatal:|test_fail} $body]} {error {Simulation did not satisfy terminal success contract}}
set f [open [file join $output result.txt] w]
puts $f "PASS scenarios=14 checks=$checks"
close $f
close_project
puts FRAME_OWNER_SIMULATION_PASS
