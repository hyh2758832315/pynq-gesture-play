# PYNQ-Z2 / Vivado 2026.1. Owned71000 c6_latency project/BD context only.
# source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/export_latency_admission_platform.tcl
# Outputs: physical-r04/platform-r01 HWH/XSA, context/source facts, reviewed run-staging copy.
# Next: verify XSA members against the signed bit/HWH, then independently restore a new package.
# No synthesis, implementation, programming, board IO, or Copilot actions.
set aprepo E:/projects/fpga/voice-view-game
set aproot $aprepo/build/hosd/c0e/admission-r01/physical-r04
set apout $aproot/platform-r01
set apbit $aproot/export-r02/c6v_candidate.bit
set appython $aprepo/.venv/Scripts/python.exe
if {[file exists $apout]} {error {preserve platform export evidence}}
if {[file normalize [get_property DIRECTORY [current_project]]] ne {E:/vvl/c0e} || [version -short] ne {2026.1}} {error {wrong project/tool}}
if {[current_bd_design] ne {c6v} || [get_property CONFIG.CONST_VAL [get_bd_cells build_id_constant]] ne {0xC0060E00}} {error {wrong BD/build}}
if {[ipcfg::audit_requirements] ne {REQ:OK 23/23} || [get_property NEEDS_REFRESH [get_runs synth_admission_r01]]} {error {configuration/source drift}}
set apcheck [exec $appython -E -B $aprepo/subprojects/hdmi_input_osd/integration/verify_latency_admission_export.py --verify-existing]
if {$apcheck ne {ADMISSION_BIT_EXPORT_PREFLIGHT_PASS d93553902fbfc2c0295200641fb0185e09716b2d5b10c90e6a44573ad3ec8346}} {error {signoff changed}}
set apbitsha [exec $appython -E -B -c {import hashlib,sys; print(hashlib.sha256(open(sys.argv[1],'rb').read()).hexdigest())} $apbit]
if {$apbitsha ne {ddab12d94487c01b4b526ed1e73e3bf12efe42301bcce1c0da543e60d6709106}} {error {wrong reviewed bit}}
set aphwh E:/vvl/c0e/c6_latency.gen/sources_1/bd/c6v/hw_handoff/c6v.hwh
set aphwhsha [exec $appython -E -B -c {import hashlib,sys; print(hashlib.sha256(open(sys.argv[1],'rb').read()).hexdigest())} $aphwh]
if {$aphwhsha ne {be2401b61307228c9c72d6f8963f7edc59b2f92e2bfb116c2c7a7a3abcdae097}} {error {HWH changed since context review}}
set aprundir [get_property DIRECTORY [get_runs impl_admission_r01]]
set apstage [file normalize $aprundir/c6v_wrapper.bit]
if {$apstage ne {E:/vvl/c0e/c6_latency.runs/impl_admission_r01/c6v_wrapper.bit} || [file exists $apstage]} {error {unexpected staging bit path}}
file mkdir $apout
file copy [info script] $apout/export_latency_admission_platform.tcl
set apfp [open $apout/project_sources.txt {WRONLY CREAT EXCL}]
foreach apfile [get_files -compile_order sources -used_in synthesis] {puts $apfp $apfile}
close $apfp
set apoldsynt [current_run -synthesis]
set apoldimpl [current_run -implementation]
set apfp [open $apout/context.tcldict {WRONLY CREAT EXCL}]
puts $apfp [list project [current_project] bd [current_bd_design] requirements [ipcfg::audit_requirements] bit_sha256 $apbitsha hwh_sha256 $aphwhsha staging $apstage previous_synth $apoldsynt previous_impl $apoldimpl]
close $apfp
# UG835 project export reads the selected run's bit. Stage only the independently
# reviewed bit; the old failed run DCP and timing reports remain untouched.
file copy $apbit $apstage
file copy $aphwh $apout/c6v_candidate.hwh
current_run -synthesis [get_runs synth_admission_r01]
current_run -implementation [get_runs impl_admission_r01]
write_hw_platform -fixed -include_bit $apout/c6v_candidate.xsa
# Preserve the staging copy as evidence while restoring the run's original absence of a bit.
file rename $apstage $apout/run-staged-reviewed.bit
current_run -synthesis [get_runs $apoldsynt]
current_run -implementation [get_runs $apoldimpl]
puts C0E_ADMISSION_PLATFORM_EXPORTED_BYTE_PAIR_REVIEW_PENDING
