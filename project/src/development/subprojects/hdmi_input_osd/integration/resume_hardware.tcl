# G03b: continue the preserved, partially attached NEW candidate. No recreate.
proc osd_resume_connections {} {
    foreach {from to osd_in osd_out} {
        vid_data vid_pData in_rgb out_rgb vid_de vid_pVDE in_de out_de
        vid_hsync vid_pHSync in_hs out_hs vid_vsync vid_pVSync in_vs out_vs
    } {
        set original [get_bd_nets -of_objects [get_bd_pins core/$from]]
        set dvi_pin [get_bd_pins rgb2dvi/$to]
        set current [get_bd_nets -quiet -of_objects $dvi_pin]
        set osd_pin [get_bd_pins input_osd_0/$osd_in]
        set input_net [get_bd_nets -quiet -of_objects $osd_pin]
        if {$input_net eq ""} {connect_bd_net -net $original $osd_pin} \
        elseif {$input_net ne $original} {error "OSD input connected to wrong net"}
        if {$current eq $original} {disconnect_bd_net $original $dvi_pin;set current {}}
        set output_pin [get_bd_pins input_osd_0/$osd_out]
        set output_net [get_bd_nets -quiet -of_objects $output_pin]
        if {$current eq ""} {
            if {$output_net eq ""} {connect_bd_net $output_pin $dvi_pin} \
            else {connect_bd_net -net $output_net $dvi_pin}
        } elseif {$current ne $output_net} {error "DVI sink has unexpected owner"}
    }
    set segment [get_bd_addr_segs -of_objects [get_bd_intf_pins input_osd_0/S_AXI]]
    assign_bd_address -offset 0x43C20000 -range 4K -target_address_space [get_bd_addr_spaces ps7_0/Data] $segment
    validate_bd_design
    return "SUCCESS:OSD_BD_RESUME_PASS"
}
set result [ipcfg::capture E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/evidence/g03b-resume.[clock clicks].tcldict \
    {osd_resume_connections} {SUCCESS:OSD_BD_RESUME_PASS}]
puts $result
if {[dict get $result status] ne "OK"} {error "OSD resume gate failed"}
dict for {segment pair} $osd_before_addresses {
    if {[list [get_property OFFSET $segment] [get_property RANGE $segment]] ne $pair} {error "parent address changed"}
}
puts [ipcfg::audit_requirements]
save_bd_design
write_bd_tcl E:/projects/fpga/voice-view-game/build/hosd/c0d/recreate_osd_bd.tcl
puts "OSD_BD_GATE_PASS BUILD_ID=0xC0060D00 BASE=0x43C20000"
