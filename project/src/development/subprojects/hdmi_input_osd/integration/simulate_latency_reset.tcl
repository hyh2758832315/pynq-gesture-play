# Run in the owned C0E project after target generation:
# set latency_bad_read 0; source -notrace .../simulate_latency_reset.tcl
# Then use latency_bad_read=1 with a fresh evidence directory.
# Output: compile/elaborate/simulate logs and focused WDB under reset-sim-CASE-r01.
# Next: inspect explicit PASS plus no unexpected Fatal; streaming/STOP remain separate.
if {[file normalize [get_property DIRECTORY [current_project]]] ne {E:/vvl/c0e}} {error {wrong candidate}}
if {![info exists latency_bad_read] || $latency_bad_read ni {0 1}} {error {explicit latency_bad_read 0/1 required}}
set latency_repo {E:/projects/fpga/voice-view-game}
set latency_simset c0e_reset_sim
set latency_case [expr {$latency_bad_read ? "blocked" : "safe"}]
if {![info exists latency_sim_round]} {set latency_sim_round r01}
if {![regexp {^r[0-9][0-9]$} $latency_sim_round]} {error {unsafe simulation round}}
set latency_output [file join $latency_repo subprojects hdmi_input_osd integration evidence reset-sim-$latency_case-$latency_sim_round]
if {[file exists $latency_output]} {error {refuse reused simulation evidence}}
file mkdir $latency_output
file copy [info script] [file join $latency_output simulate_latency_reset.tcl]
set latency_tb [file join $latency_repo subprojects hdmi_input_osd integration tb_c0e_reset.sv]
file copy $latency_tb [file join $latency_output tb_c0e_reset.sv]
if {![llength [get_filesets -quiet $latency_simset]]} {create_fileset -simset $latency_simset}
if {![llength [get_files -quiet -of_objects [get_filesets $latency_simset] *tb_c0e_reset.sv]]} {
    add_files -fileset $latency_simset -norecurse $latency_tb
}
set_property TOP tb_c0e_reset [get_filesets $latency_simset]
set_property GENERIC BAD_READ=$latency_bad_read [get_filesets $latency_simset]
# The prior generated xelab command omitted fileset GENERIC for this SV top.
# Use the documented xelab override explicitly, and verify it before advancing time.
set_property -dict [list xsim.elaborate.xelab.more_options "-generic_top BAD_READ=$latency_bad_read"] [get_filesets $latency_simset]
set_property target_simulator XSim [current_project]
set_property xsim.simulate.runtime 0ns [get_filesets $latency_simset]
update_compile_order -fileset $latency_simset
puts "C0E_RESET_PREFLIGHT part=[get_property PART [current_project]] top=[get_property TOP [get_filesets $latency_simset]] case=$latency_case"
launch_simulation -simset $latency_simset -mode behavioral
set latency_directory [file join [get_property DIRECTORY [current_project]] c6_latency.sim $latency_simset behav xsim]
set latency_elab_input [open [file join $latency_directory elaborate.bat] r]
set latency_elab_command [read $latency_elab_input]
close $latency_elab_input
file copy [file join $latency_directory elaborate.bat] [file join $latency_output elaborate.bat]
if {[string first "-generic_top BAD_READ=$latency_bad_read" $latency_elab_command]<0} {
    error {generated xelab command omitted explicit BAD_READ; no simulation proof}
}
log_wave /tb_c0e_reset/phase /tb_c0e_reset/current_address /tb_c0e_reset/reads /tb_c0e_reset/writes /tb_c0e_reset/blocked_cycles
log_wave /tb_c0e_reset/capture_reset_n /tb_c0e_reset/dut/c6v_i/capture_status/s_axi_arvalid /tb_c0e_reset/dut/c6v_i/capture_status/s_axi_arready
log_wave /tb_c0e_reset/dut/c6v_i/capture_status/s_axi_rvalid /tb_c0e_reset/dut/c6v_i/capture_status/s_axi_rready
run 1 ms
close_sim
set latency_directory [file join [get_property DIRECTORY [current_project]] c6_latency.sim $latency_simset behav xsim]
foreach name {compile.log elaborate.log simulate.log tb_c0e_reset_behav.wdb} {
    file copy [file join $latency_directory $name] [file join $latency_output $name]
}
set input [open [file join $latency_output simulate.log] r]
set transcript [read $input]
close $input
set marker [expr {$latency_bad_read ? "TEST_PASS C0E_RESET_HELD_READ_BLOCKED" : "TEST_PASS C0E_SAFE_RESET_RELEASE"}]
if {[string first $marker $transcript]<0 || [regexp {Fatal:|FATAL:|C0E_[A-Z_]*(TIMEOUT|WATCHDOG|NOT_|RESPONSE|VALUE)} $transcript]} {
    error "C0E reset simulation failed; preserve $latency_output"
}
if {[string first "C0E_RESET_CASE BAD_READ=$latency_bad_read" $transcript]<0} {
    error {actual elaborated BAD_READ not proven by runtime transcript}
}
puts "SUCCESS:C0E_RESET_SIM case=$latency_case evidence=$latency_output"
