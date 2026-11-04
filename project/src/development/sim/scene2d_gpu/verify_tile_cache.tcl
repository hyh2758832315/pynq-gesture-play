set script_dir [file dirname [file normalize [info script]]]
set repo_dir [file normalize [file join $script_dir .. ..]]
set verify_scope tile
if {[info exists gpu_verify_scope]} {
    set verify_scope $gpu_verify_scope
    unset gpu_verify_scope
}
if {$verify_scope ni {tile blit blit_unit tile_pipeline tile_pipeline_unit tile_pair tile_pair_unit blit_pair_unit raster_pair_unit raster_core_unit stage3 stage4 command_overlap_unit upload_overlap_unit}} { error "Invalid GPU verification scope: $verify_scope" }
set tile_pair_scope [expr {$verify_scope in {tile_pair tile_pair_unit stage3}}]
set tile_pipeline_scope [expr {$verify_scope in {tile_pipeline tile_pipeline_unit}}]
set unit_scope [expr {$verify_scope in {blit_unit tile_pipeline_unit tile_pair_unit blit_pair_unit raster_pair_unit raster_core_unit command_overlap_unit upload_overlap_unit stage4}}]
set output_dir [file join $repo_dir results gpu-${verify_scope}-verify-[clock milliseconds]]
set rtl_dir [file join $repo_dir rtl scene2d_gpu]
file mkdir $output_dir
create_project tile_cache_verify [file join $output_dir simulation] -part xc7z020clg400-1
set_property target_simulator XSim [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY XPM_FIFO} [current_project]
set sources [list]
foreach name {
    scene2d_upload_sink scene2d_command_upload scene2d_index4_blit
    scene2d_index4_atlas scene2d_clear_fill_renderer scene2d_video_timing
    scene2d_framebuffer scene2d_frame_swap scene2d_palette_scanout
    scene2d_c4m3_core scene2d_packet_router scene2d_resource_upload
    scene2d_palette_store scene2d_asset_bundle_store scene2d_tilemap_store
    scene2d_index4_asset_blit scene2d_draw_tile_layer scene2d_c4m7_core
} {
    lappend sources [file join $rtl_dir ${name}.sv]
}
lappend sources [file join $repo_dir third_party verilog-axis rtl axis_demux.v]
add_files $sources
foreach top {tb_scene2d_draw_tile_layer tb_scene2d_c4m7_core tb_scene2d_clear_fill_renderer tb_scene2d_index4_asset_blit tb_scene2d_framebuffer_scanout tb_scene2d_command_upload} {
    add_files -fileset sim_1 [file join $script_dir ${top}.sv]
}
set_property top scene2d_c4m7_core [get_filesets sources_1]
update_compile_order -fileset sim_1

proc verify_simulation {top generic marker label {runtime 4ms}} {
    global output_dir script_dir
    set simset [get_filesets sim_1]
    set_property top $top $simset
    set_property generic $generic $simset
    set_property xsim.simulate.runtime $runtime $simset
    update_compile_order -fileset sim_1
    set run_dir [file join $output_dir simulation tile_cache_verify.sim sim_1 behav xsim]
    set vector_dir [file join $run_dir sim scene2d_gpu vectors]
    file mkdir $vector_dir
    foreach vector [glob [file join $script_dir vectors *.mem]] {
        file copy -force $vector $vector_dir
    }
    launch_simulation -simset sim_1 -mode behavioral
    close_sim -force
    set transcript [file join $run_dir simulate.log]
    set stream [open $transcript r]
    set content [read $stream]
    close $stream
    file copy $transcript [file join $output_dir ${label}.log]
    if {[string first $marker $content] < 0 || [regexp -nocase {fatal:|error:|watchdog expired} $content]} {
        error "Simulation failed: $label; see $transcript"
    }
    puts "GPU_CACHE_SIM_PASS=$label"
}

if {$verify_scope in {upload_overlap_unit stage4}} {
    foreach enabled {0 1} {
        verify_simulation tb_scene2d_c4m7_core \
            "TILE_DESCRIPTOR_CACHE_ENABLE=1 BLIT_PIXEL_PIPELINE_ENABLE=1 TILE_PIXEL_PIPELINE_ENABLE=1 TILE_PIXEL_PAIR_ENABLE=1 BLIT_PIXEL_PAIR_ENABLE=1 CLEAR_FILL_PIXEL_PAIR_ENABLE=1 UPLOAD_RENDER_OVERLAP_ENABLE=$enabled TEST_UPLOAD_OVERLAP=1" \
            [expr {$enabled ? "SCENE2D_UPLOAD_BOUNDARIES=PASS" : "SCENE2D_UPLOAD_OVERLAP=PASS overlap=0"}] upload_overlap_$enabled 30ms
    }
} elseif {$verify_scope eq "command_overlap_unit"} {
    foreach enabled {0 1} {
        verify_simulation tb_scene2d_command_upload \
            "UPLOAD_RENDER_OVERLAP_ENABLE=$enabled TEST_UPLOAD_OVERLAP=1" \
            "SCENE2D_COMMAND_BANK_PIN=PASS overlap=$enabled" command_bank_pin_$enabled
    }
} elseif {$verify_scope in {blit_pair_unit stage3}} {
    verify_simulation tb_scene2d_index4_asset_blit {TEST_BLIT_PAIR_CASES=1} \
        {SCENE2D_BLIT_PAIR=PASS cases=28 pixels_per_clock=2} blit_pair_unit
} elseif {$verify_scope ni {tile tile_pipeline_unit raster_pair_unit raster_core_unit}} {
    verify_simulation tb_scene2d_index4_asset_blit {} {SCENE2D_INDEX4_ASSET_BLIT=PASS cases=24 pipeline_II=1} blit_unit
}
if {$verify_scope eq "stage4"} {
    foreach enabled {0 1} {
        verify_simulation tb_scene2d_command_upload \
            "UPLOAD_RENDER_OVERLAP_ENABLE=$enabled TEST_UPLOAD_OVERLAP=1" \
            "SCENE2D_COMMAND_BANK_PIN=PASS overlap=$enabled" command_bank_pin_$enabled
        foreach blit {0 1} {
            foreach solid {0 1} {
                verify_simulation tb_scene2d_c4m7_core \
                    "TILE_DESCRIPTOR_CACHE_ENABLE=1 BLIT_PIXEL_PIPELINE_ENABLE=1 TILE_PIXEL_PIPELINE_ENABLE=1 TILE_PIXEL_PAIR_ENABLE=1 BLIT_PIXEL_PAIR_ENABLE=$blit CLEAR_FILL_PIXEL_PAIR_ENABLE=$solid UPLOAD_RENDER_OVERLAP_ENABLE=$enabled TEST_RASTER_PAIR_SCENES=1" \
                    "SCENE2D_C4M7_RASTER_PAIR=PASS blit=$blit solid=$solid frames=3" p4_raster_${enabled}_${blit}_${solid} 30ms
            }
        }
        foreach kind {blit tile pair} {
            set generic "TILE_DESCRIPTOR_CACHE_ENABLE=1 BLIT_PIXEL_PIPELINE_ENABLE=1 TILE_PIXEL_PIPELINE_ENABLE=1 TILE_PIXEL_PAIR_ENABLE=1 BLIT_PIXEL_PAIR_ENABLE=1 CLEAR_FILL_PIXEL_PAIR_ENABLE=1 UPLOAD_RENDER_OVERLAP_ENABLE=$enabled TEST_BLIT_SCENES=1"
            set marker "SCENE2D_C4M7_BLIT=PASS cache=1 pipeline=1 frames=6"
            if {$kind in {tile pair}} {
                append generic " TEST_TILE_PIPELINE_SCENES=1"
                set marker "SCENE2D_C4M7_TILE_PIPELINE=PASS pipeline=1 frames=4"
            }
            if {$kind eq "pair"} {
                append generic " TEST_TILE_PAIR_SCENES=1"
                set marker "SCENE2D_C4M7_TILE_PAIR=PASS pair=1 frames=2"
            }
            verify_simulation tb_scene2d_c4m7_core $generic $marker p4_${kind}_$enabled
        }
    }
}
if {$verify_scope in {raster_pair_unit stage3}} {
    foreach blit {0 1} {
        foreach solid {0 1} {
            verify_simulation tb_scene2d_clear_fill_renderer \
                "BLIT_PIXEL_PAIR_ENABLE=$blit CLEAR_FILL_PIXEL_PAIR_ENABLE=$solid TEST_RASTER_PAIR_CASES=1" \
                {SCENE2D_RASTER_PAIR=PASS} renderer_raster_${blit}_${solid}
        }
        verify_simulation tb_scene2d_clear_fill_renderer \
            "BLIT_PIXEL_PAIR_ENABLE=$blit TEST_BLIT_PAIR_CANCEL=1" \
            {SCENE2D_BLIT_CANCEL=PASS} renderer_blit_cancel_$blit
    }
}
if {$verify_scope in {raster_core_unit stage3}} {
    foreach blit {0 1} {
        foreach solid {0 1} {
            set tile_pair [expr {$blit == $solid}]
            verify_simulation tb_scene2d_c4m7_core \
                "TILE_DESCRIPTOR_CACHE_ENABLE=1 BLIT_PIXEL_PIPELINE_ENABLE=1 TILE_PIXEL_PIPELINE_ENABLE=1 TILE_PIXEL_PAIR_ENABLE=$tile_pair BLIT_PIXEL_PAIR_ENABLE=$blit CLEAR_FILL_PIXEL_PAIR_ENABLE=$solid TEST_RASTER_PAIR_SCENES=1" \
                "SCENE2D_C4M7_RASTER_PAIR=PASS blit=$blit solid=$solid frames=3" core_raster_${blit}_${solid} 30ms
        }
    }
}
if {$tile_pipeline_scope} {
    foreach cache {0 1} {
        foreach pipeline {0 1} {
            verify_simulation tb_scene2d_draw_tile_layer \
                "CACHED_DESCRIPTOR_ENABLE=$cache TILE_PIXEL_PIPELINE_ENABLE=$pipeline TEST_TILE_PIPELINE_CASES=1" \
                "SCENE2D_TILE_PIPELINE=PASS cache=$cache pipeline=$pipeline cases=31" tile_matrix_${cache}_${pipeline}
        }
    }
}
if {$tile_pair_scope} {
    foreach enabled {0 1} {
        verify_simulation tb_scene2d_framebuffer_scanout "DUAL_PIXEL_WRITE_ENABLE=$enabled" \
            {SCENE2D_FRAMEBUFFER_SCANOUT=PASS} framebuffer_pair_$enabled
    }
    foreach cache {0 1} {
        foreach pipeline {0 1} {
            foreach pair {0 1} {
                set case_count [expr {$pair ? 34 : 31}]
                verify_simulation tb_scene2d_draw_tile_layer \
                    "CACHED_DESCRIPTOR_ENABLE=$cache TILE_PIXEL_PIPELINE_ENABLE=$pipeline TILE_PIXEL_PAIR_ENABLE=$pair TEST_TILE_PIPELINE_CASES=1" \
                    "SCENE2D_TILE_PAIR=PASS cache=$cache pipeline=$pipeline pair=$pair cases=$case_count" tile_pair_matrix_${cache}_${pipeline}_${pair}
            }
        }
    }
}
if {!$unit_scope} {
    verify_simulation tb_scene2d_draw_tile_layer {} {SCENE2D_DRAW_TILE_LAYER=PASS cases=22} tile_unit
    verify_simulation tb_scene2d_c4m7_core {TILE_DESCRIPTOR_CACHE_ENABLE=0} {SCENE2D_C4M7_CORE=PASS cache=0} core_off
    verify_simulation tb_scene2d_c4m7_core {TILE_DESCRIPTOR_CACHE_ENABLE=1} {SCENE2D_C4M7_CORE=PASS cache=1} core_on
    verify_simulation tb_scene2d_clear_fill_renderer {} {SCENE2D_CLEAR_FILL=PASS} renderer_default
    if {$verify_scope in {blit tile_pipeline tile_pair stage3}} {
        foreach enabled {0 1} {
            verify_simulation tb_scene2d_c4m7_core \
                "TILE_DESCRIPTOR_CACHE_ENABLE=1 BLIT_PIXEL_PIPELINE_ENABLE=$enabled TEST_BLIT_SCENES=1" \
                "SCENE2D_C4M7_BLIT=PASS cache=1 pipeline=$enabled frames=6" blit_core_$enabled
        }
    }
    if {$verify_scope in {tile_pipeline tile_pair stage3}} {
        verify_simulation tb_scene2d_clear_fill_renderer {TEST_TILE_PIPELINE_CANCEL=1} \
            {SCENE2D_TILE_CANCEL=PASS} renderer_tile_cancel
        foreach enabled {0 1} {
            verify_simulation tb_scene2d_c4m7_core \
                "TILE_DESCRIPTOR_CACHE_ENABLE=1 BLIT_PIXEL_PIPELINE_ENABLE=1 TILE_PIXEL_PIPELINE_ENABLE=$enabled TEST_BLIT_SCENES=1 TEST_TILE_PIPELINE_SCENES=1" \
                "SCENE2D_C4M7_TILE_PIPELINE=PASS pipeline=$enabled frames=4" tile_core_$enabled
        }
    }
    if {$verify_scope in {tile_pair stage3}} {
        foreach enabled {0 1} {
            verify_simulation tb_scene2d_clear_fill_renderer \
                "TEST_TILE_PIPELINE_CANCEL=1 TILE_PIXEL_PAIR_ENABLE=$enabled" \
                {SCENE2D_TILE_CANCEL=PASS} renderer_pair_cancel_$enabled
            verify_simulation tb_scene2d_c4m7_core \
                "TILE_DESCRIPTOR_CACHE_ENABLE=1 BLIT_PIXEL_PIPELINE_ENABLE=1 TILE_PIXEL_PIPELINE_ENABLE=1 TILE_PIXEL_PAIR_ENABLE=$enabled TEST_BLIT_SCENES=1 TEST_TILE_PIPELINE_SCENES=1 TEST_TILE_PAIR_SCENES=1" \
                "SCENE2D_C4M7_TILE_PAIR=PASS pair=$enabled frames=2" core_pair_$enabled
        }
    }
}
close_project

if {!$unit_scope} {
    set probe_top [expr {$verify_scope in {tile tile_pipeline tile_pair} ? "scene2d_draw_tile_layer" : "scene2d_index4_asset_blit"}]
    set probe_parameter [expr {$verify_scope eq "stage3" ? "BLIT_PIXEL_PAIR_ENABLE" : $verify_scope eq "tile_pair" ? "TILE_PIXEL_PAIR_ENABLE" : $verify_scope eq "tile_pipeline" ? "TILE_PIXEL_PIPELINE_ENABLE" :
        $verify_scope eq "tile" ? "TILE_DESCRIPTOR_CACHE_ENABLE" : "BLIT_PIXEL_PIPELINE_ENABLE"}]
    foreach enabled {0 1} {
    create_project -in_memory gpu_ooc_$enabled -part xc7z020clg400-1
    read_verilog -sv [file join $rtl_dir ${probe_top}.sv]
    set probe_generic ${probe_parameter}=$enabled
    if {$verify_scope eq "tile_pipeline"} { lappend probe_generic TILE_DESCRIPTOR_CACHE_ENABLE=1 }
    if {$verify_scope eq "tile_pair"} { lappend probe_generic TILE_DESCRIPTOR_CACHE_ENABLE=1 TILE_PIXEL_PIPELINE_ENABLE=1 }
    if {$verify_scope eq "stage3"} { lappend probe_generic BLIT_PIXEL_PIPELINE_ENABLE=1 }
    synth_design -top $probe_top -part xc7z020clg400-1 -mode out_of_context -generic $probe_generic
    create_clock -name render_clk -period 10.000 [get_ports aclk]
    opt_design
    place_design
    route_design
    report_utilization -file [file join $output_dir ${verify_scope}_ooc_${enabled}_utilization.rpt]
    report_timing_summary -delay_type min_max -report_unconstrained \
        -file [file join $output_dir ${verify_scope}_ooc_${enabled}_timing.rpt]
    report_drc -file [file join $output_dir ${verify_scope}_ooc_${enabled}_drc.rpt]
    write_checkpoint [file join $output_dir ${verify_scope}_ooc_${enabled}.dcp]
    puts "GPU_CACHE_OOC_DONE=$enabled"
    close_project
    }
    if {$verify_scope in {tile_pair stage3}} {
        foreach enabled {0 1} {
            create_project -in_memory renderer_pair_ooc_$enabled -part xc7z020clg400-1
            foreach name {scene2d_draw_tile_layer scene2d_index4_asset_blit scene2d_index4_blit scene2d_clear_fill_renderer} {
                read_verilog -sv [file join $rtl_dir ${name}.sv]
            }
            set renderer_generic "TILE_DESCRIPTOR_CACHE_ENABLE=1 BLIT_PIXEL_PIPELINE_ENABLE=1 TILE_PIXEL_PIPELINE_ENABLE=1 TILE_PIXEL_PAIR_ENABLE=$enabled"
            if {$verify_scope eq "stage3"} {
                set renderer_generic "TILE_DESCRIPTOR_CACHE_ENABLE=1 BLIT_PIXEL_PIPELINE_ENABLE=1 TILE_PIXEL_PIPELINE_ENABLE=1 TILE_PIXEL_PAIR_ENABLE=1 BLIT_PIXEL_PAIR_ENABLE=$enabled CLEAR_FILL_PIXEL_PAIR_ENABLE=$enabled"
            }
            synth_design -top scene2d_clear_fill_renderer -part xc7z020clg400-1 -mode out_of_context -generic $renderer_generic
            create_clock -name render_clk -period 10.000 [get_ports aclk]
            opt_design
            place_design
            route_design
            report_utilization -file [file join $output_dir renderer_pair_${enabled}_utilization.rpt]
            report_timing_summary -delay_type min_max -report_unconstrained \
                -file [file join $output_dir renderer_pair_${enabled}_timing.rpt]
            report_drc -file [file join $output_dir renderer_pair_${enabled}_drc.rpt]
            write_checkpoint [file join $output_dir renderer_pair_${enabled}.dcp]
            close_project
        }
    }
}
puts "GPU_CACHE_VERIFY_ARTIFACTS=$output_dir"