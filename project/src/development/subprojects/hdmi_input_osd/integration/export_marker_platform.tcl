# Owned parent IPI session only. Run: source -notrace <this file>.
# Outputs workspace marker-visibility-r02/platform-r02 HWH/XSA/context.
# Next: verify XSA members byte-for-byte and create an independent candidate.
# No hardware access; restore parent's current run and original missing bit.
set mvroot E:/projects/fpga/voice-view-game/build/hosd/marker-visibility-r02
set mvout $mvroot/platform-r02
set mvpython E:/projects/fpga/voice-view-game/.venv/Scripts/python.exe
if {[file exists $mvout]} {error {preserve marker platform export}}
if {[version -short] ne {2026.1} || [file normalize [get_property DIRECTORY [current_project]]] ne {E:/vvl/c0e}} {error {wrong tool/project}}
if {[current_bd_design] ne {c6v} || [get_property CONFIG.CONST_VAL [get_bd_cells build_id_constant]] ne {0xC0060E00}} {error {wrong BD/ABI}}
set mvbit $mvroot/marker_visibility.bit
set mvsha [exec $mvpython -E -B -c {import hashlib,sys; print(hashlib.sha256(open(sys.argv[1],'rb').read()).hexdigest())} $mvbit]
if {$mvsha ne {10b01f51e3dc184496c94609d895211215045dac98efdb41b898277f2a10c72f}} {error {marker bit drift}}
set mvhwh E:/vvl/c0e/c6_latency.gen/sources_1/bd/c6v/hw_handoff/c6v.hwh
set mvhwhsha [exec $mvpython -E -B -c {import hashlib,sys; print(hashlib.sha256(open(sys.argv[1],'rb').read()).hexdigest())} $mvhwh]
if {$mvhwhsha ne {be2401b61307228c9c72d6f8963f7edc59b2f92e2bfb116c2c7a7a3abcdae097}} {error {parent ABI/HWH drift}}
set mvstage E:/vvl/c0e/c6_latency.runs/impl_admission_r01/c6v_wrapper.bit
if {[file exists $mvstage]} {error {unexpected existing staging bit}}
file mkdir $mvout
file copy [info script] $mvout/export_marker_platform.tcl
file copy $mvhwh $mvout/c6v_candidate.hwh
set mvoldsynth [current_run -synthesis]
set mvoldimpl [current_run -implementation]
set fp [open $mvout/context.tcldict {WRONLY CREAT EXCL}]
puts $fp [list bit_sha256 $mvsha hwh_sha256 $mvhwhsha parent_static_cells_unchanged 97574 parent_scoped_constraints_unchanged 468 old_synth $mvoldsynth old_impl $mvoldimpl]
close $fp
file copy $mvbit $mvstage
try {
    current_run -synthesis [get_runs synth_admission_r01]
    current_run -implementation [get_runs impl_admission_r01]
    write_hw_platform -fixed -include_bit $mvout/c6v_candidate.xsa
} finally {
    if {[file exists $mvstage]} {file rename $mvstage $mvout/run-staged-marker.bit}
    current_run -synthesis [get_runs $mvoldsynth]
    current_run -implementation [get_runs $mvoldimpl]
}
puts MARKER_PLATFORM_EXPORTED_BYTE_VERIFICATION_PENDING
