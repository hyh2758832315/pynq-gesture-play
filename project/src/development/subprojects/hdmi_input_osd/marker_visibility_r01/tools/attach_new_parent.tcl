# Defines a callable integration procedure only. Sourcing never edits a BD.
# Before calling: a NEW candidate project, unique platform BUILD_ID, dedicated
# unused GP0 AXI master and approved free 4KiB aperture must already exist.
# Example invocation and required arguments are in INTEGRATION.md.
proc attach_input_osd {new_root master_pin base_address parent_build_id new_build_id} {
    set project [current_project]
    if {$project eq ""} {error "no candidate project open"}
    set candidate_dir [file normalize [get_property DIRECTORY $project]]
    set new_root [file normalize $new_root]
    if {![string match "${new_root}/*" "${candidate_dir}/"]} {
        error "current project is outside the explicit new candidate root"
    }
    if {$parent_build_id == $new_build_id} {error "OSD requires a distinct platform identity"}
    if {[get_property CONFIG.CONST_VAL [get_bd_cells build_id_constant]] != $new_build_id} {
        error "candidate BUILD_ID must already match the separately allocated new identity"
    }
    if {[llength [get_bd_cells -quiet input_osd_0]]} {error "OSD already exists"}
    set master [get_bd_intf_pins $master_pin]
    if {[llength $master]!=1 || [get_property MODE $master] ne "Master" ||
        [llength [get_bd_intf_nets -quiet -of_objects $master]]} {
        error "expected one unused, dedicated AXI master: $master_pin"
    }
    foreach pin {core/vid_data core/vid_de core/vid_hsync core/vid_vsync
                 rgb2dvi/vid_pData rgb2dvi/vid_pVDE rgb2dvi/vid_pHSync rgb2dvi/vid_pVSync
                 ps7_0/FCLK_CLK0 rst_fclk0/peripheral_aresetn
                 pixel_clock/clk_out1 rst_pixel/peripheral_aresetn} {
        if {[llength [get_bd_pins -quiet $pin]]!=1} {error "parent pin identity mismatch: $pin"}
    }
    foreach {from to} {vid_data vid_pData vid_de vid_pVDE vid_hsync vid_pHSync vid_vsync vid_pVSync} {
        set osd_from_net [get_bd_nets -of_objects [get_bd_pins core/$from]]
        set osd_to_net [get_bd_nets -of_objects [get_bd_pins rgb2dvi/$to]]
        if {[llength $osd_from_net]!=1 || $osd_from_net ne $osd_to_net} {
            error "unreviewed display mux/net topology: $from -> $to"
        }
    }
    # Validate the address BEFORE editing any connection. A cloned parent's
    # explicit assigned ranges must not overlap the requested new aperture.
    if {$base_address & 4095} {error "OSD aperture must be 4KiB aligned"}
    foreach segment [get_bd_addr_segs -of_objects [get_bd_addr_spaces ps7_0/Data]] {
        set offset [get_property OFFSET $segment]
        set span [get_property RANGE $segment]
        if {$offset eq "" || $span eq ""} {error "unassigned parent address segment"}
        if {$base_address < $offset+$span && $offset < $base_address+4096} {
            error "OSD aperture overlaps $segment"
        }
    }
    create_bd_cell -type module -reference input_osd_axi input_osd_0
    connect_bd_intf_net $master [get_bd_intf_pins input_osd_0/S_AXI]
    foreach {source destination} {
        ps7_0/FCLK_CLK0 s_axi_aclk rst_fclk0/peripheral_aresetn s_axi_aresetn
        pixel_clock/clk_out1 pclk rst_pixel/peripheral_aresetn presetn
    } {connect_bd_net [get_bd_pins $source] [get_bd_pins input_osd_0/$destination]}
    foreach {from to osd_in osd_out} {
        vid_data vid_pData in_rgb out_rgb vid_de vid_pVDE in_de out_de
        vid_hsync vid_pHSync in_hs out_hs vid_vsync vid_pVSync in_vs out_vs
    } {
        set old_net [get_bd_nets -of_objects [get_bd_pins core/$from]]
        disconnect_bd_net $old_net [get_bd_pins rgb2dvi/$to]
        connect_bd_net $old_net [get_bd_pins input_osd_0/$osd_in]
        connect_bd_net [get_bd_pins input_osd_0/$osd_out] [get_bd_pins rgb2dvi/$to]
    }
    set osd_segment [get_bd_addr_segs -of_objects [get_bd_intf_pins input_osd_0/S_AXI]]
    if {[llength $osd_segment]!=1} {error "OSD slave segment inference failed"}
    assign_bd_address -offset $base_address -range 4K -target_address_space [get_bd_addr_spaces ps7_0/Data] $osd_segment
    validate_bd_design
    return "OSD_ATTACHED_TO_NEW_PARENT_NOT_BUILT_NOT_DEPLOYED"
}
