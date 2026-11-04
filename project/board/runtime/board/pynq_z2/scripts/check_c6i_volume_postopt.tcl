foreach fusion_pclk_name {vid_pclk_IBUF vid_pclk_IBUF_BUFG} {
    set fusion_pclk_net [get_nets -quiet $fusion_pclk_name]
    if {[llength $fusion_pclk_net] != 1} {
        error "fusion post-opt missing inherited camera clock net: $fusion_pclk_name"
    }
    set_property CLOCK_DEDICATED_ROUTE FALSE $fusion_pclk_net
    if {[get_property CLOCK_DEDICATED_ROUTE $fusion_pclk_net] ne "FALSE"} {
        error "fusion post-opt inherited camera clock property mismatch: $fusion_pclk_name"
    }
}
puts C6V_VOLUME_POSTOPT_BASELINE_PASS