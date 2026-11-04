# Run ONLY in cloned build/hosd/c0d/c6_osd.xpr. Parent was opened read-only.
# source -notrace <this-file>; outputs config capture and new BD in that project.
# Next: generate_target then normal synth/impl with reviewed independent hooks.
set osd_repo E:/projects/fpga/voice-view-game
set osd_project_root $osd_repo/build/hosd/c0d
if {[file normalize [get_property DIRECTORY [current_project]]] ne $osd_project_root} {
    error "wrong project; never change the running parent's project"
}
if {[get_property PART [current_project]] ne "xc7z020clg400-1"} {error "wrong part"}
set osd_evidence $osd_repo/subprojects/hdmi_input_osd/integration/evidence
file mkdir $osd_evidence
set osd_external {}
foreach f [get_files -of_objects [get_filesets sources_1]] {
    if {![string match "${osd_project_root}/*" [file normalize $f]] && [file isfile $f]} {
        lappend osd_external $f
    }
}
if {[llength $osd_external]} {import_files -fileset sources_1 -norecurse -force -flat $osd_external}
foreach f [get_files -of_objects [get_filesets sources_1]] {
    if {![string match "${osd_project_root}/*" [file normalize $f]]} {error "unfrozen source: $f"}
}
add_files -norecurse [glob $osd_repo/subprojects/hdmi_input_osd/rtl/*.sv]
update_compile_order -fileset sources_1
set osd_before_addresses [dict create]
foreach segment [get_bd_addr_segs -of_objects [get_bd_addr_spaces ps7_0/Data]] {
    dict set osd_before_addresses $segment [list [get_property OFFSET $segment] [get_property RANGE $segment]]
}
if {[get_property CONFIG.NUM_MI [get_bd_cells gp0_smc]] != 31 ||
    [get_property CONFIG.NUM_MI [get_bd_cells vision_control_smc]] != 5} {error "parent interconnect differs"}
proc osd_configure_new_parent {} {
    set r [ipcfg::require vision_control_smc [list CONFIG.NUM_MI 6] {OSD one dedicated observation-only register slave}]
    if {![string match {REQ:pinned+applied*} $r]} {error $r}
    set r [ipcfg::require build_id_constant [list CONFIG.CONST_VAL 0xC0060D00] {New OSD hardware candidate identity}]
    if {![string match {REQ:pinned+applied*} $r]} {error $r}
    if {[get_property CONFIG.NUM_MI [get_bd_cells vision_control_smc]] != 6 ||
        [llength [get_bd_intf_pins vision_control_smc/M05_AXI]] != 1} {error "master count/pin readback failed"}
    source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/tools/attach_new_parent.tcl
    set result [attach_input_osd E:/projects/fpga/voice-view-game/build/hosd/c0d \
        vision_control_smc/M05_AXI 0x43C20000 0xC0060C00 0xC0060D00]
    if {$result ne "OSD_ATTACHED_TO_NEW_PARENT_NOT_BUILT_NOT_DEPLOYED"} {error $result}
    return "SUCCESS:OSD_BD_ATTACHED"
}
set osd_config_receipt [ipcfg::capture $osd_evidence/g03-config.[clock clicks].tcldict \
    {osd_configure_new_parent} {SUCCESS:OSD_BD_ATTACHED}]
puts $osd_config_receipt
if {[dict get $osd_config_receipt status] ne "OK"} {error "OSD config gate failed; retain evidence"}
dict for {segment pair} $osd_before_addresses {
    if {[list [get_property OFFSET $segment] [get_property RANGE $segment]] ne $pair} {
        error "parent address changed: $segment"
    }
}
puts [ipcfg::audit_requirements]
save_bd_design
write_bd_tcl $osd_project_root/recreate_osd_bd.tcl
puts "OSD_PREPARED build=0xC0060D00 base=0x43C20000 gp0=31 vision=6"
