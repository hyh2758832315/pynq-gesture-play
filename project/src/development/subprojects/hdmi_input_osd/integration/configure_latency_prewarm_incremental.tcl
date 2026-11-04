# PYNQ-Z2 / Vivado 2026.1; preserve the signed C0E route as an incremental physical reference.
# Run: source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/configure_latency_prewarm_incremental.tcl
# Output: prewarm-r01/incremental_reference.dcp (SHA-pinned) and explicit impl_prewarm_r01 settings.
# Next: launch synthesis then wait; implementation must independently pass all timing/CDC/DRC checks.
if {[file normalize [get_property DIRECTORY [current_project]]] ne {E:/vvl/c0e}} {error {wrong project}}
set pwr {E:/projects/fpga/voice-view-game}
set pwref $pwr/build/hosd/c0e/postroute-r05/signoff/candidate.dcp
set pwdest $pwr/build/hosd/c0e/prewarm-r01/incremental_reference.dcp
if {[file exists $pwdest] || [get_property STATUS [get_runs synth_prewarm_r01]] ne {Not started}} {error {unexpected stage}}
set pwactual [exec $pwr/.venv/Scripts/python.exe -B -c {import hashlib,sys; print(hashlib.sha256(open(sys.argv[1],'rb').read()).hexdigest())} $pwref]
if {$pwactual ne {af0db359703c500ae049b9ea6b9b2ae77e1b4db0ac71b962bb0c10996f24ed9c}} {error {incremental reference changed}}
file copy $pwref $pwdest
file copy [info script] $pwr/build/hosd/c0e/prewarm-r01/configure_latency_prewarm_incremental.tcl
add_files -fileset utils_1 -norecurse $pwdest
set_property AUTO_INCREMENTAL_CHECKPOINT 0 [get_runs impl_prewarm_r01]
set_property INCREMENTAL_CHECKPOINT $pwdest [get_runs impl_prewarm_r01]
puts [list C0E_PREWARM_EXPLICIT_INCREMENTAL_REFERENCE [get_property INCREMENTAL_CHECKPOINT [get_runs impl_prewarm_r01]] $pwactual]
