set c0c_repo [file normalize [file join [file dirname [info script]] .. .. ..]]
if {[get_property DIRECTORY [current_project]] ne "E:/vvfv/f53bd"} {
    error "C0C diagnostic must run in the isolated project copy"
}
set c0c_case $::env(C0C_BD_CASE)
if {$c0c_case ni {baseline vision video}} {error "C0C_BD_CASE must be baseline, vision or video"}
set c0c_vision [expr {$c0c_case ne "baseline"}]
set c0c_frames [expr {$c0c_case eq "video" ? 3 : 0}]
set c0c_round [expr {$c0c_case eq "video" ? "f56b" : "f54"}]
set c0c_evidence [file join $c0c_repo results game-validation game-volume-fusion-20261022 $c0c_round-bd-$c0c_case]
if {[file exists $c0c_evidence]} {error "refuse reused C0C evidence directory"}
file mkdir $c0c_evidence
file copy [file join $c0c_repo sim voice_volume tb_c6i_volume_bd.sv] [file join $c0c_evidence tb_c6i_volume_bd.sv]
file copy [info script] [file join $c0c_evidence simulate_c6i_volume_bd.tcl]
write_bd_tcl [file join $c0c_evidence c0c_bd.tcl]
generate_target simulation [get_files */c6v.bd]
if {![llength [get_files -quiet *tb_c6i_volume_bd.sv]]} {
    add_files -fileset sim_1 -norecurse [file join $c0c_repo sim voice_volume tb_c6i_volume_bd.sv]
}
set_property top tb_c6i_volume_bd [get_filesets sim_1]
set_property generic "VISION_START=$c0c_vision VIDEO_FRAMES=$c0c_frames" [get_filesets sim_1]
set_property target_simulator XSim [current_project]
set_property xsim.simulate.runtime 0ns [get_filesets sim_1]
update_compile_order -fileset sim_1
puts "C0C_BD_SIMULATION_PREPARED project=[current_project] part=[get_property PART [current_project]]"
launch_simulation -simset sim_1 -mode behavioral
log_wave /tb_c6i_volume_bd/phase /tb_c6i_volume_bd/current_address /tb_c6i_volume_bd/reads /tb_c6i_volume_bd/writes /tb_c6i_volume_bd/volume_reset_n
log_wave /tb_c6i_volume_bd/dut/c6v_i/ps7_0/M_AXI_GP0_ARVALID /tb_c6i_volume_bd/dut/c6v_i/ps7_0/M_AXI_GP0_ARREADY /tb_c6i_volume_bd/dut/c6v_i/ps7_0/M_AXI_GP0_RVALID /tb_c6i_volume_bd/dut/c6v_i/ps7_0/M_AXI_GP0_RREADY
log_wave /tb_c6i_volume_bd/dut/c6v_i/voice_volume_0/*
if {$c0c_frames > 0} {
    log_wave /tb_c6i_volume_bd/camera_active /tb_c6i_volume_bd/camera_vsync /tb_c6i_volume_bd/native_pixels /tb_c6i_volume_bd/rgb_pixels /tb_c6i_volume_bd/rgb_frames /tb_c6i_volume_bd/hp_addresses /tb_c6i_volume_bd/hp_responses /tb_c6i_volume_bd/hp_bytes
    log_wave /tb_c6i_volume_bd/dut/c6v_i/ps7_0/S_AXI_HP1_*
}
run 2 ms
close_sim
set c0c_xsim [file join [get_property DIRECTORY [current_project]] c0c_diag.sim sim_1 behav xsim]
foreach c0c_name {compile.log elaborate.log simulate.log tb_c6i_volume_bd_behav.wdb} {
    file copy [file join $c0c_xsim $c0c_name] [file join $c0c_evidence $c0c_name]
}
set c0c_handle [open [file join $c0c_evidence simulate.log] r]
set c0c_log [read $c0c_handle]
close $c0c_handle
if {![string match *C0C_BD_CONTROL_PASS* $c0c_log] || [regexp {Fatal:|_TIMEOUT|_WATCHDOG|_STUCK|_DROPPED} $c0c_log]} {
    error "C0C simulation failed; preserve raw artifacts at $c0c_evidence"
}
if {$c0c_frames > 0 && ![string match *C0C_BD_VIDEO_PASS* $c0c_log]} {
    error "C0C video/DDR proof missing; preserve raw artifacts at $c0c_evidence"
}
puts "C0C_BD_SIMULATION_PASS evidence=$c0c_evidence"