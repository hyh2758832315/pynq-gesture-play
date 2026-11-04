# Run in existing C0E project: source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/simulate_latency_video_rate.tcl
# Outputs: video-rate-sim-r01 transcript, WDB, source and xelab command.
# Next: inspect the first stall/fault; this isolated always-ready-sink test does not prove DDR or board behavior.
if {[file normalize [get_property DIRECTORY [current_project]]] ne {E:/vvl/c0e}} {error {wrong project}}
set vrdir {E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration}
set vrout $vrdir/evidence/video-rate-sim-r01
if {[file exists $vrout]} {error {preserve prior evidence}}
file mkdir $vrout
file copy [info script] $vrout/simulate_latency_video_rate.tcl
file copy $vrdir/tb_c0e_video_rate.sv $vrout/tb_c0e_video_rate.sv
if {![llength [get_filesets -quiet c0e_video_rate_sim]]} {create_fileset -simset c0e_video_rate_sim}
current_fileset -simset c0e_video_rate_sim
add_files -fileset c0e_video_rate_sim -norecurse $vrdir/tb_c0e_video_rate.sv
set_property TOP tb_c0e_video_rate [get_filesets c0e_video_rate_sim]
set_property xsim.simulate.runtime 0ns [get_filesets c0e_video_rate_sim]
update_compile_order -fileset c0e_video_rate_sim
launch_simulation -simset c0e_video_rate_sim -mode behavioral
set vrrun [get_property DIRECTORY [current_project]]/c6_latency.sim/c0e_video_rate_sim/behav/xsim
file copy $vrrun/elaborate.bat $vrout/elaborate.bat
log_wave /tb_c0e_video_rate/de /tb_c0e_video_rate/vsync /tb_c0e_video_rate/overflow /tb_c0e_video_rate/faults /tb_c0e_video_rate/owner_causes /tb_c0e_video_rate/bv /tb_c0e_video_rate/br /tb_c0e_video_rate/rv /tb_c0e_video_rate/rr /tb_c0e_video_rate/ov /tb_c0e_video_rate/line_number /tb_c0e_video_rate/rgb_taken /tb_c0e_video_rate/stalls
run 2 ms
close_sim
foreach name {compile.log elaborate.log simulate.log tb_c0e_video_rate_behav.wdb} {file copy $vrrun/$name $vrout/$name}
set fp [open $vrout/simulate.log r]
set vrtext [read $fp]
close $fp
if {[string first {TEST_PASS C0E_VIDEO_RATE_} $vrtext]<0 || [regexp {Fatal:|FATAL:} $vrtext]} {error {Video-rate test failed; inspect preserved evidence}}
puts C0E_VIDEO_RATE_SIM_TERMINATED_INSPECT_SCOPE
