# Actual C0E BD/PS7VIP ARM reproduction, no board operations or DUT modifications.
# source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/simulate_latency_arm.tcl
# Output: arm-sim-r01 logs, sources, generated xelab and WDB. Next: inspect first failure/waves before fixing.
if {[file normalize [get_property DIRECTORY [current_project]]] ne {E:/vvl/c0e}} {error {wrong project}}
set armdir {E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration}
set armout $armdir/evidence/arm-sim-r01
if {[file exists $armout]} {error {preserve prior evidence}}
file mkdir $armout
file copy [info script] $armout/simulate_latency_arm.tcl
file copy $armdir/tb_c0e_arm.sv $armout/tb_c0e_arm.sv
if {![llength [get_filesets -quiet c0e_arm_sim]]} {create_fileset -simset c0e_arm_sim}
current_fileset -simset c0e_arm_sim
add_files -fileset c0e_arm_sim -norecurse $armdir/tb_c0e_arm.sv
set_property TOP tb_c0e_arm [get_filesets c0e_arm_sim]
set_property xsim.simulate.runtime 0ns [get_filesets c0e_arm_sim]
update_compile_order -fileset c0e_arm_sim
launch_simulation -simset c0e_arm_sim -mode behavioral
set armrun [get_property DIRECTORY [current_project]]/c6_latency.sim/c0e_arm_sim/behav/xsim
file copy $armrun/elaborate.bat $armout/elaborate.bat
log_wave /tb_c0e_arm/phase /tb_c0e_arm/value /tb_c0e_arm/reads /tb_c0e_arm/writes
log_wave /tb_c0e_arm/dut/c6v_i/capture_status/* /tb_c0e_arm/dut/c6v_i/capture_lifecycle/*
run 1 ms
close_sim
foreach name {compile.log elaborate.log simulate.log tb_c0e_arm_behav.wdb} {
    file copy $armrun/$name $armout/$name
}
set fp [open $armout/simulate.log r]
set armtext [read $fp]
close $fp
if {[string first {TEST_PASS C0E_ARM_NO_VIDEO_STABLE} $armtext]<0 || [regexp {Fatal:|FATAL:} $armtext]} {error {C0E ARM simulation failed; inspect sealed transcript/waves}}
puts C0E_ARM_SIM_PASSED_NO_VIDEO_SCOPE_ONLY
