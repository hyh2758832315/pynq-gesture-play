# In the existing owned C0E session: source -notrace .../generate_latency_bgr.tcl
# Outputs: regenerated BGR BD target and exclusive r05 export/capture.
# Next: re-synthesize changed OOC + main, then real-BD reset r02 and route.
if {[file normalize [get_property DIRECTORY [current_project]]] ne {E:/vvl/c0e}} {error {wrong candidate}}
if {[ipcfg::audit_requirements] ne {REQ:OK 23/23}} {error {configuration changed}}
set bgr_evidence {E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/evidence}
set f [open [file join $bgr_evidence latency-bgr-validate-r02.tcldict] r]
set validation [dict get [read $f] data];close $f
if {[dict get $validation status] ne {OK}} {error {BGR validation not passed}}
proc latency_generate_bgr {} {
    global bgr_evidence
    save_bd_design
    write_bd_tcl [file join $bgr_evidence latency-connected-bgr-r05.tcl]
    generate_target all [get_files E:/vvl/c0e/c6_latency.srcs/sources_1/bd/c6v/c6v.bd]
    return SUCCESS:C0E_BGR_TARGETS_GENERATED
}
set result [ipcfg::capture [file join $bgr_evidence latency-generate-bgr-r05.tcldict] {latency_generate_bgr} {SUCCESS:C0E_BGR_TARGETS_GENERATED}]
puts $result
if {[dict get $result status] ne {OK}} {error {BGR generation failed; preserve evidence}}
