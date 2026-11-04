# PYNQ-Z2 xc7z020clg400-1 / Vivado 2026.1; export only the frozen reviewed admission DCP.
# First run verify_latency_admission_export.py, then close_design and:
# source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/export_latency_admission_bit.tcl
# Outputs: physical-r04/export-r02/c6v_candidate.bit, export.tcldict, pre-bit XDC, script snapshot.
# Next: pair HWH/XSA and independently verify bytes; no hardware access is performed here.
set aerepo E:/projects/fpga/voice-view-game
set aeroot $aerepo/build/hosd/c0e/admission-r01/physical-r04
set aeout $aeroot/export-r02
set aesha d93553902fbfc2c0295200641fb0185e09716b2d5b10c90e6a44573ad3ec8346
if {[file exists $aeout/c6v_candidate.bit] || [file exists $aeout/export_latency_admission_bit.tcl]} {error {preserve bit export evidence}}
set aecheck [exec $aerepo/.venv/Scripts/python.exe -E -B $aerepo/subprojects/hdmi_input_osd/integration/verify_latency_admission_export.py --verify-existing]
if {$aecheck ne "ADMISSION_BIT_EXPORT_PREFLIGHT_PASS $aesha"} {error {export preflight failed}}
file copy [info script] $aeout/export_latency_admission_bit.tcl
open_checkpoint $aeroot/signoff/candidate.dcp
if {[get_property PART [current_design]] ne {xc7z020clg400-1} || [version -short] ne {2026.1}} {error {wrong tool/device}}
set aewns [get_property SLACK [get_timing_paths -delay_type max -max_paths 1]]
set aewhs [get_property SLACK [get_timing_paths -delay_type min -max_paths 1]]
if {$aewns!=0.002 || $aewhs!=0.049 || [get_property PERIOD [get_clocks clk_fpga_0]]!=10.000} {error {reviewed timing differs}}
write_xdc -exclude_physical $aeout/before_bit_timing.xdc
write_bitstream $aeout/c6v_candidate.bit
set aebitsha [exec $aerepo/.venv/Scripts/python.exe -E -B -c {import hashlib,sys; print(hashlib.sha256(open(sys.argv[1],'rb').read()).hexdigest())} $aeout/c6v_candidate.bit]
set aefp [open $aeout/export.tcldict {WRONLY CREAT EXCL}]
puts $aefp [list candidate_sha256 $aesha bit_sha256 $aebitsha wns $aewns whs $aewhs clock_period [get_property PERIOD [get_clocks clk_fpga_0]]]
close $aefp
puts C0E_ADMISSION_BIT_EXPORTED_PAIR_AND_BOARD_ACCEPTANCE_PENDING
