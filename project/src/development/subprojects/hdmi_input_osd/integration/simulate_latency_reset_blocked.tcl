# Real-BD reset-held read negative test; no board access.
# Run after prior sim command terminal: source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/simulate_latency_reset_blocked.tcl
# Output: reset-sim-blocked-r05 source/batch/transcript/WDB evidence.
# Next: require actual BAD_READ=1 and terminal blocked-read PASS; retain failures.
if {[file normalize [get_property DIRECTORY [current_project]]] ne {E:/vvl/c0e}} {error {wrong candidate}}
set blocked_repo {E:/projects/fpga/voice-view-game}
set blocked_dir [file join $blocked_repo subprojects hdmi_input_osd integration]
set blocked_out [file join $blocked_dir evidence reset-sim-blocked-r05]
if {[file exists $blocked_out]} {error {preserve existing evidence}}
file mkdir $blocked_out
file copy [info script] [file join $blocked_out simulate_latency_reset_blocked.tcl]
foreach name {tb_c0e_reset.sv tb_c0e_reset_blocked.sv} {
    file copy [file join $blocked_dir $name] [file join $blocked_out $name]
}
set blocked_set [get_filesets c0e_reset_sim]
current_fileset -simset c0e_reset_sim
if {[current_fileset -simset] ne $blocked_set} {error {simulation fileset not active}}
set blocked_wrapper [file join $blocked_dir tb_c0e_reset_blocked.sv]
if {![llength [get_files -quiet -of_objects $blocked_set $blocked_wrapper]]} {
    add_files -fileset c0e_reset_sim -norecurse $blocked_wrapper
}
set_property TOP tb_c0e_reset_blocked $blocked_set
set_property GENERIC {} $blocked_set
set_property xsim.elaborate.xelab.more_options {} $blocked_set
set_property xsim.simulate.runtime 0ns $blocked_set
update_compile_order -fileset c0e_reset_sim
puts "C0E_BLOCKED_STRUCTURAL_PREFLIGHT active=[current_fileset -simset] top=[get_property TOP $blocked_set]"
launch_simulation -simset c0e_reset_sim -mode behavioral
set blocked_run [file join [get_property DIRECTORY [current_project]] c6_latency.sim c0e_reset_sim behav xsim]
set blocked_file [open [file join $blocked_run elaborate.bat] r]
set blocked_command [read $blocked_file]
close $blocked_file
file copy [file join $blocked_run elaborate.bat] [file join $blocked_out elaborate.bat]
if {[string first {xil_defaultlib.tb_c0e_reset_blocked} $blocked_command]<0} {error {generated xelab selected wrong structural top}}
set blocked_root /tb_c0e_reset_blocked/scenario
log_wave $blocked_root/phase $blocked_root/current_address $blocked_root/reads $blocked_root/writes $blocked_root/blocked_cycles
log_wave $blocked_root/capture_reset_n $blocked_root/dut/c6v_i/capture_status/s_axi_arvalid $blocked_root/dut/c6v_i/capture_status/s_axi_arready
log_wave $blocked_root/dut/c6v_i/capture_status/s_axi_rvalid $blocked_root/dut/c6v_i/capture_status/s_axi_rready
run 1 ms
close_sim
foreach name {compile.log elaborate.log simulate.log tb_c0e_reset_blocked_behav.wdb} {
    file copy [file join $blocked_run $name] [file join $blocked_out $name]
}
set blocked_file [open [file join $blocked_out simulate.log] r]
set blocked_text [read $blocked_file]
close $blocked_file
if {[string first {C0E_RESET_CASE BAD_READ=1} $blocked_text]<0 ||
    [string first {TEST_PASS C0E_RESET_HELD_READ_BLOCKED} $blocked_text]<0 ||
    [regexp {Fatal:|FATAL:|C0E_[A-Z_]*(TIMEOUT|WATCHDOG|NOT_|RESPONSE|VALUE|INVALID)} $blocked_text]} {
    error {structural blocked reset test failed; preserve full evidence}
}
puts "SUCCESS:C0E_STRUCTURAL_BLOCKED_RESET_SIM $blocked_out"
