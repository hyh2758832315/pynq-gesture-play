# In the existing owned Vivado C0E session:
# source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/generate_latency.tcl
# Outputs: regenerated C0E BD targets, validated BD Tcl and immutable capture receipt.
# Next: launch_runs synth_1, wait_on_run synth_1; no board deployment here.
if {[file normalize [get_property DIRECTORY [current_project]]] ne {E:/vvl/c0e}} {error {wrong candidate}}
if {[get_property CONFIG.CONST_VAL [get_bd_cells build_id_constant]] ne {0xC0060E00}} {error {wrong identity}}
if {[ipcfg::audit_requirements] ne {REQ:OK 23/23}} {error {configuration changed}}
set evidence {E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/evidence}
set input [open [file join $evidence latency-validate-r04.tcldict] r]
set validation [dict get [read $input] data]
close $input
if {[dict get $validation status] ne {OK} || [dict get $validation raw] ne {SUCCESS:LATENCY_VALIDATED}} {error {validation not passed}}
proc latency_generate_targets {} {
    global evidence
    save_bd_design
    write_bd_tcl [file join $evidence latency-connected-validated-r04.tcl]
    generate_target all [get_files E:/vvl/c0e/c6_latency.srcs/sources_1/bd/c6v/c6v.bd]
    return SUCCESS:LATENCY_TARGETS_GENERATED
}
set result [ipcfg::capture [file join $evidence latency-generate-r04.tcldict] {latency_generate_targets} {SUCCESS:LATENCY_TARGETS_GENERATED}]
puts $result
if {[dict get $result status] ne {OK}} {error {target generation failed; preserve evidence}}
