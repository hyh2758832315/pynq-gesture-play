# Vivado 2026.1 / PYNQ-Z2. Called only after audit_full.py reports PASS.
# Run: D:/Xilinx/Vivado/2026.1/Vivado/bin/vivado.bat -mode batch -nojournal -source subprojects/hdmi_input_osd/osd_reset_repair_r01/tools/export_bit.tcl -tclargs build/hosd/osd-reset-r01/route-vcc-r01/signoff/candidate.dcp EXPECTED_SIGNOFF_DCP_SHA256 build/hosd/osd-reset-r01/bit-r01
# Output: c6v_candidate.bit, identity.tcldict. Next: pair with exact R21 HWH/XSA and recheck board state.
if {$argc != 3} {error {expected signoff DCP, its SHA256 and fresh output directory}}
set root E:/projects/fpga/voice-view-game
set dcp [file normalize [lindex $argv 0]]
set expected [lindex $argv 1]
set out [file normalize [lindex $argv 2]]
if {[version -short] ne {2026.1} || [file exists $out] || ![file isfile $dcp]} {error {tool, output or checkpoint mismatch}}
set actual [exec $root/.venv/Scripts/python.exe -I -B -c {import hashlib,sys;print(hashlib.sha256(open(sys.argv[1],"rb").read()).hexdigest())} $dcp]
if {$actual ne $expected} {error {signoff DCP drift}}
open_checkpoint $dcp
if {[get_property PART [current_design]] ne {xc7z020clg400-1}} {error {wrong part}}
set setup [get_property SLACK [get_timing_paths -delay_type max -max_paths 1]]
set hold [get_property SLACK [get_timing_paths -delay_type min -max_paths 1]]
if {$setup < 0 || $hold < 0} {error {negative full-design slack}}
file mkdir $out
set fp [open $out/identity.tcldict {WRONLY CREAT EXCL}]
puts $fp [list dcp_sha256 $actual setup_ns $setup hold_ns $hold]
close $fp
write_bitstream $out/c6v_candidate.bit
puts OSD_RESET_BIT_READY_PAIR_PENDING
