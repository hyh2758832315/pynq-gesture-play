# Vivado 2026.1 / PYNQ-Z2. Read-only parent IPI project; no project save.
# Run from workspace root:
# D:/Xilinx/Vivado/2026.1/Vivado/bin/vivado.bat -mode batch -nojournal -source subprojects/hdmi_input_osd/osd_reset_repair_r01/tools/export_platform.tcl -tclargs build/hosd/osd-reset-r01/platform-r01
# Outputs c6v_candidate.xsa, c6v_candidate.hwh, context.tcldict and staged-bit recovery copy.
# Next: verify XSA bit and every HWH member by SHA before packaging/upboard.
if {$argc != 1} {error {expected fresh output directory}}
set root E:/projects/fpga/voice-view-game
set out [file normalize [lindex $argv 0]]
set bit $root/build/hosd/osd-reset-r01/bit-r01/c6v_candidate.bit
set parent_hwh $root/deliveries/c6i-pl-vision-volume-osd-r21-marker-r02-20261023/overlay/c6v_candidate.hwh
set stage E:/vvl/c0e/c6_latency.runs/impl_admission_r01/c6v_wrapper.bit
set python $root/.venv/Scripts/python.exe
if {[version -short] ne {2026.1} || [file exists $out] || [file exists $stage]} {error {tool, output or staging mismatch}}
if {![file isfile $bit] || ![file isfile $parent_hwh]} {error {bit/HWH missing}}
set bit_sha [exec $python -I -B -c {import hashlib,sys;print(hashlib.sha256(open(sys.argv[1],"rb").read()).hexdigest())} $bit]
set hwh_sha [exec $python -I -B -c {import hashlib,sys;print(hashlib.sha256(open(sys.argv[1],"rb").read()).hexdigest())} $parent_hwh]
if {$bit_sha ne {507833ade953e9fe33c51cf8ef0c76943026a8b2a3d8ed2ed93aa1c1f2c1cd42} || $hwh_sha ne {be2401b61307228c9c72d6f8963f7edc59b2f92e2bfb116c2c7a7a3abcdae097}} {error {source identity drift}}
open_project -read_only E:/vvl/c0e/c6_latency.xpr
set bd_file [get_files -quiet E:/vvl/c0e/c6_latency.srcs/sources_1/bd/c6v/c6v.bd]
if {[file normalize [get_property DIRECTORY [current_project]]] ne {E:/vvl/c0e} ||
    [llength $bd_file] != 1} {error {wrong IPI project or missing BD}}
open_bd_design $bd_file
if {[current_bd_design] ne {c6v} ||
    [get_property CONFIG.CONST_VAL [get_bd_cells build_id_constant]] ne {0xC0060E00}} {error {wrong IPI project or BUILD_ID}}
file mkdir $out
file copy $parent_hwh $out/c6v_candidate.hwh
set old_synth [current_run -synthesis]
set old_impl [current_run -implementation]
set fp [open $out/context.tcldict {WRONLY CREAT EXCL}]
puts $fp [list bit_sha256 $bit_sha hwh_sha256 $hwh_sha old_synth $old_synth old_impl $old_impl project_read_only true]
close $fp
file copy $bit $stage
try {
    current_run -synthesis [get_runs synth_admission_r01]
    current_run -implementation [get_runs impl_admission_r01]
    write_hw_platform -fixed -include_bit $out/c6v_candidate.xsa
} finally {
    if {[file exists $stage]} {file rename $stage $out/run-staged-bit.bit}
    current_run -synthesis [get_runs $old_synth]
    current_run -implementation [get_runs $old_impl]
}
puts OSD_RESET_PLATFORM_EXPORT_BYTE_VERIFICATION_PENDING
