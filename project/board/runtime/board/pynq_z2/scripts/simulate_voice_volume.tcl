set volume_repo [file normalize [file join [file dirname [info script]] .. .. ..]]
set volume_build E:/vvvol/20261019
set volume_evidence [file join $volume_repo results game-validation voice-volume-only-20261019]
if {[info exists ::env(VOLUME_SIM_ROOT)]} {set volume_build [file normalize $::env(VOLUME_SIM_ROOT)]}
if {[info exists ::env(VOLUME_EVIDENCE_ROOT)]} {set volume_evidence [file normalize $::env(VOLUME_EVIDENCE_ROOT)]}
set volume_test core
set volume_round r01
if {[info exists ::env(VOLUME_SIM_TEST)]} {set volume_test $::env(VOLUME_SIM_TEST)}
if {[info exists ::env(VOLUME_SIM_ROUND)]} {set volume_round $::env(VOLUME_SIM_ROUND)}
set volume_run [file join $volume_build sim-${volume_test}-${volume_round}]
file mkdir $volume_evidence
create_project voice_volume_unit $volume_run -part xc7z020clg400-1
set_property target_simulator XSim [current_project]
add_files -norecurse [glob [file join $volume_repo rtl voice_volume *.sv]]
add_files -fileset sim_1 -norecurse [file join $volume_repo sim voice_volume tb_voice_volume_${volume_test}.sv]
set_property top voice_volume_core [get_filesets sources_1]
set_property top tb_voice_volume_${volume_test} [get_filesets sim_1]
set_property xsim.simulate.runtime 100ms [get_filesets sim_1]
update_compile_order -fileset sim_1
launch_simulation -simset sim_1 -mode behavioral
set volume_log [file join $volume_run voice_volume_unit.sim sim_1 behav xsim simulate.log]
set volume_stream [open $volume_log r]
set volume_text [read $volume_stream]
close $volume_stream
file copy $volume_log [file join $volume_evidence ${volume_test}-${volume_round}.log]
if {![string match *VOLUME_[string toupper $volume_test]_PASS* $volume_text] || [regexp {Fatal:|_FAIL|_WATCHDOG} $volume_text]} {
    error "VOLUME_SIM_FAILED: see $volume_log"
}
puts "VOLUME_[string toupper $volume_test]_VERIFIED"