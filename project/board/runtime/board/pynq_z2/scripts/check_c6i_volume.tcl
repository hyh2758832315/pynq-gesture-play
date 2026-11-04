proc check_c6i_volume {} {
    if {[get_property PART [current_project]] ne "xc7z020clg400-1"} {error "fusion part mismatch"}
    foreach {cell key wanted} {
        build_id_constant CONFIG.CONST_VAL 0xC0060C00
        gp0_smc CONFIG.NUM_MI 31
        ps7_0 CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ 100
        ps7_0 CONFIG.PCW_I2C1_PERIPHERAL_ENABLE 1
        ps7_0 CONFIG.PCW_I2C1_I2C1_IO EMIO
        audio_mclk CONFIG.PRIM_IN_FREQ 100.000
        audio_mclk CONFIG.CLKOUT1_REQUESTED_OUT_FREQ 10.000
        audio_mclk CONFIG.USE_RESET false
        vision_gp0_slice CONFIG.REG_AW 1
        vision_gp0_slice CONFIG.REG_AR 1
        vision_gp0_slice CONFIG.REG_W 1
        vision_gp0_slice CONFIG.REG_R 1
        vision_gp0_slice CONFIG.REG_B 1
    } {
        set actual [get_property $key [get_bd_cells $cell]]
        if {[string is double -strict $wanted] && [string is double -strict $actual]} {
            if {$actual != $wanted} {error "fusion $cell $key wanted=$wanted got=$actual"}
        } elseif {$actual ne $wanted} {error "fusion $cell $key wanted=$wanted got=$actual"}
    }
    foreach {source target} {
        ps7_0/FCLK_CLK0 voice_volume_0/s_axi_aclk
        rst_fclk0/peripheral_aresetn voice_volume_0/s_axi_aresetn
        ps7_0/FCLK_CLK0 audio_mclk/clk_in1
        audio_mclk/locked voice_volume_0/codec_mclk_locked
    } {
        set origin [get_bd_nets -of_objects [get_bd_pins $source]]
        if {[llength $origin] != 1 || $origin ne [get_bd_nets -of_objects [get_bd_pins $target]]} {
            error "fusion connection mismatch $source -> $target"
        }
    }
    set control [get_bd_intf_nets -of_objects [get_bd_intf_pins gp0_smc/M30_AXI]]
    if {[llength $control] != 1 || $control ne [get_bd_intf_nets -of_objects [get_bd_intf_pins voice_volume_0/s_axi]]} {
        error "fusion control is not the appended GP0 branch"
    }
    set matched 0
    foreach segment [get_bd_addr_segs -of_objects [get_bd_addr_spaces ps7_0/Data]] {
        set offset [get_property OFFSET $segment]
        set range [get_property RANGE $segment]
        if {[string match *voice_volume_0* $segment]} {
            if {$offset != 0x43C10000 || $range != 4096} {error "fusion volume address mismatch"}
            incr matched
        } elseif {$offset < 0x43C11000 && $offset + $range > 0x43C10000} {
            error "fusion volume overlaps $segment"
        }
    }
    if {$matched != 1} {error "expected one PS volume mapping, got $matched"}
    return "SUCCESS:already C6V_VOLUME_CONTRACT_PASS BUILD_ID=0xC0060C00 GP0_MI=31 BASE=0x43C10000 RANGE=4096"
}
puts [check_c6i_volume]