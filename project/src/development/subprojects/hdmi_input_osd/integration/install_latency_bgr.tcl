# Owned C0E session only, after previous simulation has reached a terminal state.
# source -notrace .../install_latency_bgr.tcl
# Outputs: new source binding + immutable capture, then regenerate/re-synthesize.
if {[file normalize [get_property DIRECTORY [current_project]]] ne {E:/vvl/c0e}} {error {wrong candidate}}
if {[get_property CONFIG.CONST_VAL [get_bd_cells build_id_constant]] ne {0xC0060E00}} {error {wrong identity}}
if {[ipcfg::audit_requirements] ne {REQ:OK 23/23}} {error {requirements differ}}
proc latency_install_bgr {} {
    set old {E:/vvl/c0e/latency-r02/rtl/axis_rgb_mask_frontend.sv}
    set replacement {E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/latency_rtl/axis_rgb_mask_frontend.sv}
    if {[llength [get_files -quiet $old]]!=1 || [llength [get_files -quiet $replacement]]} {error {unexpected source stage}}
    remove_files [get_files $old]
    add_files -norecurse $replacement
    update_compile_order -fileset sources_1
    update_module_reference [get_ips c6v_dual_mask_capture_0]
    if {[llength [get_files -quiet $old]] || [llength [get_files -quiet $replacement]]!=1} {error {BGR source binding failed}}
    if {[ipcfg::audit_requirements] ne {REQ:OK 23/23}} {error {requirements changed}}
    save_bd_design
    return SUCCESS:C0E_BGR_SOURCE_INSTALLED
}
set result [ipcfg::capture E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/evidence/latency-bgr-install-r01.tcldict {latency_install_bgr} {SUCCESS:C0E_BGR_SOURCE_INSTALLED}]
puts $result
if {[dict get $result status] ne {OK}} {error {BGR source installation failed; preserve evidence}}
