proc build_c6i_vision_candidate {} {
    set wrapper_dir [file dirname [file normalize [info script]]]
    set repo_dir [file normalize [file join $wrapper_dir .. .. ..]]
    set project_name c6_vision_integrated
    set design_name c6v
    set report_stage c6v
    set core_reference scene2d_c4m7_core
    set build_id 0xC0060800
    set enable_runtime_palette_status 1
    set enable_runtime_asset_status 1
    set enable_runtime_tilemap_status 1
    set enable_return_path 1
    set prepare_only 1
    set build_root E:/vvgvi/20261005
    if {[info exists ::env(VVG_VISION_BUILD_ROOT)]} {
        set build_root [file normalize $::env(VVG_VISION_BUILD_ROOT)]
    }
    set experimental_project_dir [file join $build_root c6v]
    set experimental_output_dir [file join $build_root output]
    if {[file exists $experimental_project_dir]} {
        error "Candidate directory already exists; reopen it for repair: $experimental_project_dir"
    }
    set frozen [file join $repo_dir handoffs gesture_vision_v61]
    set experimental_rgb2dvi_repo [file join $frozen hardware workspace pl_accel_v1_build camera_osd_v1_reference board pynq_z2 generated rgb2dvi_v1_2]
    set extra_bd_script [file join $wrapper_dir add_shared_vision_bd.tcl]
    set extra_rtl_files [list [file join $repo_dir third_party verilog-axis rtl axis_demux.v]]
    foreach name {scene2d_packet_router scene2d_resource_upload scene2d_palette_store scene2d_asset_bundle_store scene2d_tilemap_store scene2d_index4_asset_blit scene2d_draw_tile_layer scene2d_c4m7_core scene2d_return_source} {
        lappend extra_rtl_files [file join $repo_dir rtl scene2d_gpu ${name}.sv]
    }
    foreach name {bgr_skin_dma axis_bgr_hsv_skin axis_mask_pack32} {
        lappend extra_rtl_files [file join $frozen hardware frontend rtl ${name}.sv]
    }
    lappend extra_rtl_files [file join $frozen hardware frontend rtl hsv_reciprocal.svh]
    source [file join $wrapper_dir build_c4m3.tcl]
    add_files -fileset constrs_1 -norecurse [file join $repo_dir board pynq_z2 constraints camera_direct_plug_corrected.xdc]
    if {[info exists ::env(VVG_VISION_CLOCK_PROBE)] && $::env(VVG_VISION_CLOCK_PROBE) eq "1"} {
        add_files -fileset constrs_1 -norecurse [file join $repo_dir board pynq_z2 constraints camera_direct_plug_clock_probe.xdc]
        set_property USED_IN_SYNTHESIS false [get_files camera_direct_plug_clock_probe.xdc]
        puts "VISION_CLOCK_PROBE=NONDEDICATED SIGNOFF_STATUS=OFFLINE_MODEL_ONLY"
    }
    puts "VISION_CANDIDATE_PREPARED=PASS BUILD_ID=0xC0060800 BOARD_PENDING=1"
    return VISION_CANDIDATE_PREPARED
}

proc finish_c6i_vision_candidate {} {
    set project_dir [get_property DIRECTORY [current_project]]
    set project_name [get_property NAME [current_project]]
    if {$project_name ne "c6_vision_integrated" || [get_property PART [current_project]] ne "xc7z020clg400-1"} {
        error "Resume requires the existing C6V candidate project and frozen part"
    }
    if {[llength [get_bd_cells -quiet skin_kernel]] != 1} { error "Resume requires connected SKN6" }
    assign_bd_address
    set fixed_gpu [list 0x40400000 axi_dma/S_AXI_LITE/Reg \
        0x41200000 build_id_gpio/S_AXI/Reg 0x41210000 upload_status_gpio/S_AXI/Reg \
        0x41220000 packet_status_gpio/S_AXI/Reg 0x41230000 command_status_gpio/S_AXI/Reg \
        0x41240000 error_status_gpio/S_AXI/Reg 0x41250000 command_read_address_gpio/S_AXI/Reg \
        0x41260000 command_read_data_gpio/S_AXI/Reg 0x41270000 render_completion_gpio/S_AXI/Reg \
        0x41280000 render_trace_gpio/S_AXI/Reg 0x41290000 render_cycles_gpio/S_AXI/Reg \
        0x412A0000 render_status_gpio/S_AXI/Reg 0x412B0000 present_completion_gpio/S_AXI/Reg \
        0x412C0000 framebuffer_status_gpio/S_AXI/Reg \
        0x412D0000 router_status_gpio/S_AXI/Reg 0x412E0000 palette_packet_status_gpio/S_AXI/Reg \
        0x412F0000 palette_generation_status_gpio/S_AXI/Reg 0x41300000 palette_state_status_gpio/S_AXI/Reg \
        0x41310000 asset_packet_status_gpio/S_AXI/Reg 0x41320000 asset_generation_status_gpio/S_AXI/Reg \
        0x41330000 asset_state_status_gpio/S_AXI/Reg 0x41340000 tilemap_packet_status_gpio/S_AXI/Reg \
        0x41350000 tilemap_generation_status_gpio/S_AXI/Reg 0x41360000 tilemap_state_status_gpio/S_AXI/Reg \
        0x40410000 return_dma/S_AXI_LITE/Reg 0x41380000 return_control_gpio/S_AXI/Reg \
        0x41390000 return_start_gpio/S_AXI/Reg 0x413A0000 return_status_gpio/S_AXI/Reg \
        0x413B0000 return_state_gpio/S_AXI/Reg]
    foreach {offset segment} $fixed_gpu {
        assign_bd_address -offset $offset -range 0x00010000 -target_address_space \
            [get_bd_addr_spaces ps7_0/Data] [get_bd_addr_segs $segment] -force
    }
    set_property PFM_NAME "xilinx.com:pynq:${project_name}:1.0" [get_files c6v.bd]
    set_property PFM.CLOCK {FCLK_CLK0 {id "0" is_default "true" proc_sys_reset "rst_fclk0" status "fixed"}} [get_bd_cells ps7_0]
    validate_bd_design
    save_bd_design
    set bd_file [get_files c6v.bd]
    generate_target all $bd_file
    export_ip_user_files -of_objects $bd_file -no_script -sync -force -quiet
    make_wrapper -files $bd_file -top
    add_files -norecurse [file join $project_dir ${project_name}.gen sources_1 bd c6v hdl c6v_wrapper.v]
    set script_dir [file dirname [file normalize [info script]]]
    foreach name {c3_hdmi_out.xdc c6v_sync_cdc.xdc camera_direct_plug_corrected.xdc} {
        add_files -fileset constrs_1 -norecurse [file join $script_dir .. constraints $name]
    }
    set_property USED_IN_SYNTHESIS false [get_files c6v_sync_cdc.xdc]
    if {[info exists ::env(VVG_VISION_CLOCK_PROBE)] && $::env(VVG_VISION_CLOCK_PROBE) eq "1"} {
        add_files -fileset constrs_1 -norecurse [file join $script_dir .. constraints camera_direct_plug_clock_probe.xdc]
        set_property USED_IN_SYNTHESIS false [get_files camera_direct_plug_clock_probe.xdc]
        puts "VISION_CLOCK_PROBE=NONDEDICATED SIGNOFF_STATUS=OFFLINE_MODEL_ONLY"
    }
    set_property top c6v_wrapper [current_fileset]
    update_compile_order -fileset sources_1
    puts "VISION_CANDIDATE_PREPARED=PASS BUILD_ID=0xC0060800 BOARD_PENDING=1"
}

proc audit_c6v_toggle_cdc {} {
    set write_clock [get_clocks clk_fpga_0]
    set pixel_clock [get_clocks -of_objects [get_pins c6v_i/pixel_clock/inst/mmcm_adv_inst/CLKOUT0]]
    if {[llength $write_clock] != 1 || [llength $pixel_clock] != 1} {
        error "C6V CDC requires the two verified clocks"
    }
    set limit [expr {min([get_property PERIOD $write_clock], [get_property PERIOD $pixel_clock])}]
    set paths 0
    foreach instance {c6v_i/core/inst/core/frame_swap c6v_i/core/inst/palette_store} {
        foreach signal {request acknowledgement} {
            set source [get_cells -quiet ${instance}/${signal}_toggle_reg]
            set first [get_cells -quiet ${instance}/${signal}_sync_1_reg]
            set second [get_cells -quiet ${instance}/${signal}_sync_2_reg]
            if {[llength $source] != 1 || [llength $first] != 1 || [llength $second] != 1} {
                error "C6V CDC missing verified toggle chain: $instance/$signal"
            }
            foreach stage [list $first $second] {
                if {[string toupper [get_property ASYNC_REG $stage]] ni {TRUE 1}} {
                    error "C6V CDC missing ASYNC_REG: $stage"
                }
            }
            if {[get_nets -of_objects [get_pins $source/Q]] ne [get_nets -of_objects [get_pins $first/D]]} {
                error "C6V CDC toggle contains unexpected logic: $instance/$signal"
            }
            if {[get_nets -of_objects [get_pins $first/Q]] ne [get_nets -of_objects [get_pins $second/D]]} {
                error "C6V CDC second stage disconnected: $instance/$signal"
            }
            set path [get_timing_paths -from [get_pins $source/C] -to [get_pins $first/D] -max_paths 1]
            if {[llength $path] != 1 || abs([get_property REQUIREMENT $path] - $limit) > 0.001} {
                error "C6V CDC point-path constraint not effective: $instance/$signal"
            }
            incr paths
        }
    }
    return [dict create paths $paths limit_ns $limit]
}

proc run_c6v_offline {{resume_route 0}} {
    set script_dir [file dirname [file normalize [info script]]]
    if {[get_property NAME [current_project]] ne "c6_vision_integrated" || [get_property PART [current_project]] ne "xc7z020clg400-1"} {
        error "Offline flow requires the existing frozen-part C6V candidate"
    }
    set output [file normalize [file join [get_property DIRECTORY [current_project]] .. output offline_complete]]
    file mkdir $output
    if {!$resume_route} {
        close_design
        foreach name {c4m3_cdc.xdc constraints_sync_probe.xdc} {
            set obsolete [get_files -quiet *$name]
            if {[llength $obsolete]} { remove_files $obsolete }
        }
        set cdc_file [file normalize [file join $script_dir .. constraints c6v_sync_cdc.xdc]]
        if {![llength [get_files -quiet $cdc_file]]} { add_files -fileset constrs_1 -norecurse $cdc_file }
        set_property USED_IN_SYNTHESIS false [get_files $cdc_file]
        set_property PROCESSING_ORDER LATE [get_files $cdc_file]
        reset_runs synth_1
        launch_runs synth_1 -jobs 1
        wait_on_run synth_1
    }
    if {[get_property STATUS [get_runs synth_1]] ne "synth_design Complete!"} { error "C6V synthesis failed" }
    if {!$resume_route} {
        launch_runs impl_1 -to_step route_design -jobs 1
        wait_on_run impl_1
    }
    set route_status [get_property STATUS [get_runs impl_1]]
    if {![string match "route_design Complete*" $route_status] || [get_property PROGRESS [get_runs impl_1]] ne "100%"} {
        error "C6V route incomplete: $route_status"
    }
    open_run impl_1
    write_checkpoint -force [file join $output before_postroute.dcp]
    phys_opt_design -directive Explore
    set cdc_audit [audit_c6v_toggle_cdc]
    report_timing_summary -file [file join $output timing.rpt]
    report_route_status -file [file join $output route.rpt]
    report_drc -file [file join $output drc.rpt]
    report_methodology -file [file join $output methodology.rpt]
    report_clock_interaction -file [file join $output clock_interaction.rpt]
    report_cdc -file [file join $output cdc.rpt]
    report_bus_skew -file [file join $output bus_skew.rpt]
    report_exceptions -file [file join $output exceptions.rpt]
    report_utilization -file [file join $output utilization.rpt]
    write_checkpoint -force [file join $output candidate.dcp]
    write_xdc -force -exclude_physical [file join $output effective_timing.xdc]
    set setup [get_property SLACK [get_timing_paths -delay_type max -max_paths 1]]
    set hold [get_property SLACK [get_timing_paths -delay_type min -max_paths 1]]
    set ::c6v_offline_receipt [dict create setup_ns $setup hold_ns $hold cdc $cdc_audit board_pending 1 release_ready 0 output $output]
    if {$setup < 0 || $hold < 0} { error "C6V offline timing FAIL: $::c6v_offline_receipt" }
    if {[llength [get_drc_violations -filter {SEVERITY == Error}]]} { error "C6V DRC has errors; inspect saved report" }
    export_c6v_candidate $output
    puts "C6V_OFFLINE_CANDIDATE=$::c6v_offline_receipt"
    return $::c6v_offline_receipt
}

proc export_c6v_candidate {output} {
    audit_c6v_toggle_cdc
    set setup [get_property SLACK [get_timing_paths -delay_type max -max_paths 1]]
    set hold [get_property SLACK [get_timing_paths -delay_type min -max_paths 1]]
    if {$setup < 0 || $hold < 0} { error "C6V candidate export requires nonnegative timing" }
    write_bitstream -force [file join $output c6v_candidate.bit]
    set run_bit [file join [get_property DIRECTORY [get_runs impl_1]] c6v_wrapper.bit]
    file copy -force [file join $output c6v_candidate.bit] $run_bit
    write_hw_platform -fixed -include_bit -force -file [file join $output c6v_candidate.xsa]
    set hwh [file join [get_property DIRECTORY [current_project]] c6_vision_integrated.gen sources_1 bd c6v hw_handoff c6v.hwh]
    file copy -force $hwh [file join $output c6v_candidate.hwh]
    return [dict create output $output setup_ns $setup hold_ns $hold board_pending 1 release_ready 0]
}

if {[info exists ::env(VVG_VISION_STAGE)] && $::env(VVG_VISION_STAGE) eq "audit"} {
    audit_c6v_toggle_cdc
} elseif {[info exists ::env(VVG_VISION_STAGE)] && $::env(VVG_VISION_STAGE) eq "offline"} {
    run_c6v_offline
} elseif {[info exists ::env(VVG_VISION_STAGE)] && $::env(VVG_VISION_STAGE) eq "offline-resume"} {
    run_c6v_offline 1
} elseif {[info exists ::env(VVG_VISION_STAGE)] && $::env(VVG_VISION_STAGE) eq "offline-export"} {
    export_c6v_candidate [dict get $::c6v_offline_receipt output]
} elseif {[info exists resume_c6v] && $resume_c6v} {
    finish_c6i_vision_candidate
    unset resume_c6v
} else {
    build_c6i_vision_candidate
}