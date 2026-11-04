set volume_repo [file normalize [file join [file dirname [info script]] .. .. ..]]
set volume_root [file normalize $::env(VOLUME_BD_SIM_ROOT)]
set volume_evidence [file normalize $::env(VOLUME_EVIDENCE_ROOT)]
set volume_reference [file normalize $::env(VOLUME_BD_REFERENCE)]
if {[llength [get_projects -quiet]] || [file exists $volume_root] || [file exists $volume_evidence]} {
    error "refuse occupied project or reused BD simulation/evidence directory"
}
if {![file isfile $volume_reference]} {error "frozen BD recreation script missing"}
file mkdir $volume_evidence
create_project voice_volume_bd $volume_root -part xc7z020clg400-1
add_files -norecurse [glob [file join $volume_repo rtl voice_volume *.sv]]
source $volume_reference
validate_bd_design
foreach {parameter expected} {C_EXT_RESET_HIGH 0 C_AUX_RESET_HIGH 1} {
    if {[get_property CONFIG.$parameter [get_bd_cells control_reset]] != $expected} {
        error "BD simulation reset contract mismatch $parameter"
    }
}
set volume_bd [get_files */volume.bd]
generate_target all $volume_bd
add_files -norecurse [make_wrapper -files $volume_bd -top]
set_property top volume_wrapper [get_filesets sources_1]
set_property target_simulator XSim [current_project]
add_files -fileset sim_1 -norecurse [file join $volume_repo sim voice_volume tb_voice_volume_bd.sv]
set_property top tb_voice_volume_bd [get_filesets sim_1]
set_property generic {EXPECT_STUCK=0 EXTENDED=1} [get_filesets sim_1]
set_property xsim.simulate.runtime 30ms [get_filesets sim_1]
update_compile_order -fileset sim_1
write_bd_tcl [file join $volume_evidence recreated_volume_bd.tcl]
launch_simulation -simset sim_1 -mode behavioral
close_sim
set volume_xsim [file join $volume_root voice_volume_bd.sim sim_1 behav xsim]
foreach name {compile.log elaborate.log simulate.log tb_voice_volume_bd_behav.wdb} {
    file copy [file join $volume_xsim $name] [file join $volume_evidence $name]
}
set volume_handle [open [file join $volume_evidence simulate.log] r]
set volume_log [read $volume_handle]
close $volume_handle
if {![string match *VOLUME_BD_STARTUP_WRITES_PASS* $volume_log] ||
    ![string match *VOLUME_BD_EXTENDED_PASS* $volume_log] ||
    ![string match *VOLUME_BD_HANDSHAKES_PASS* $volume_log] ||
    [regexp {Fatal:|_FAIL|_WATCHDOG} $volume_log]} {
    error "BD simulation failed; raw artifacts preserved at $volume_evidence"
}
puts "VOLUME_BD_SIMULATION_PASS evidence=$volume_evidence"