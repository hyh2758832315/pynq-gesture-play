# Continue ONLY the G03/G03b project; do not recreate or repeat CONFIG writes.
proc osd_audit_current_bd {} {
    if {[get_property CONFIG.NUM_MI [get_bd_cells gp0_smc]]!=31 ||
        [get_property CONFIG.NUM_MI [get_bd_cells vision_control_smc]]!=6 ||
        [get_property CONFIG.CONST_VAL [get_bd_cells build_id_constant]]!=0xC0060D00} {error "OSD configuration drift"}
    if {[get_property CONFIG.c_m_axi_s2mm_data_width [get_bd_cells moments_dma]]!=64 ||
        [get_property CONFIG.c_s_axis_s2mm_tdata_width [get_bd_cells moments_dma]]!=32 ||
        [get_property CONFIG.DATA_WIDTH [get_bd_intf_pins moments_dma/M_AXI_S2MM]]!=64 ||
        [get_property CONFIG.TDATA_NUM_BYTES [get_bd_intf_pins moments_dma/S_AXIS_S2MM]]!=4} {
        error "inherited DMA contract changed"
    }
    foreach {from to osd_in osd_out} {
        vid_data vid_pData in_rgb out_rgb vid_de vid_pVDE in_de out_de
        vid_hsync vid_pHSync in_hs out_hs vid_vsync vid_pVSync in_vs out_vs
    } {
        if {[get_bd_nets -of_objects [get_bd_pins core/$from]] ne
            [get_bd_nets -of_objects [get_bd_pins input_osd_0/$osd_in]]} {error "OSD input net mismatch"}
        if {[get_bd_nets -of_objects [get_bd_pins rgb2dvi/$to]] ne
            [get_bd_nets -of_objects [get_bd_pins input_osd_0/$osd_out]]} {error "OSD output net mismatch"}
    }
    dict for {segment pair} $::osd_before_addresses {
        if {[list [get_property OFFSET $segment] [get_property RANGE $segment]] ne $pair} {error "old address drift"}
    }
    set r [ipcfg::audit_requirements]
    if {![string match {REQ:OK*} $r]} {error $r}
    return "SUCCESS:OSD_READBACK_CONNECTIONS_AND_PARENT_DMA_PRESERVED"
}
set evidence E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/evidence
set receipt [ipcfg::capture $evidence/g03c-semantic-audit.[clock clicks].tcldict \
    {osd_audit_current_bd} {SUCCESS:OSD_READBACK_CONNECTIONS_AND_PARENT_DMA_PRESERVED}]
puts $receipt
if {[dict get $receipt status] ne "OK"} {error "readback audit failed"}
# Preserve the G03b validate result and legacy ignored-propagation warning; the
# new intent above is independently checked, not inferred from Tcl exit0.
save_bd_design
write_bd_tcl E:/projects/fpga/voice-view-game/build/hosd/c0d/recreate_osd_bd.tcl
set root E:/projects/fpga/voice-view-game/build/hosd/c0d
import_files -norecurse -force -flat -fileset sources_1 [glob E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/rtl/*.sv]
set cs [get_files -of_objects [get_filesets constrs_1]]
import_files -norecurse -force -flat -fileset constrs_1 $cs
set_property USED_IN_SYNTHESIS false [get_files *c6v_volume_baseline.xdc]
set_property USED_IN_SYNTHESIS false [get_files *c6v_sync_cdc.xdc]
set_property PROCESSING_ORDER LATE [get_files *c6v_sync_cdc.xdc]
file copy E:/projects/fpga/voice-view-game/board/pynq_z2/scripts/check_c6i_volume_postopt.tcl $root/postopt_parent.tcl
file copy E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/constraints/osd_cdc.tcl $root/osd_cdc.tcl
set fp [open $root/postopt_osd.tcl w]
puts $fp "source -notrace {$root/postopt_parent.tcl}"
puts $fp {set ::osd_scope {c6v_i/input_osd_0/inst/impl/}}
puts $fp "source -notrace {$root/osd_cdc.tcl}"
puts $fp {puts OSD_POSTOPT_CDC_BOUND_PASS}
close $fp
set_property STEPS.OPT_DESIGN.TCL.POST $root/postopt_osd.tcl [get_runs impl_1]
update_compile_order -fileset sources_1
puts "OSD_PROJECT_FROZEN_READY_TO_GENERATE"
