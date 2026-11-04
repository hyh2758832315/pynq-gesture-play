# Vivado 2026.1 / PYNQ-Z2: deterministic comparison with identical inputs.
# Run: vivado -mode batch -source sim/gpu_optimization/run_compare.tcl -tclargs build/output/gpu_comparison_01
# First generate vectors using generate_vectors.py. Outputs six *.log files.
# Next: python sim/gpu_optimization/summarize.py OUTPUT_DIR
set here [file dirname [file normalize [info script]]]
set project_root [file normalize [file join $here ../..]]
set script_dir [file join $project_root src/development/sim/scene2d_gpu]
set vector_source [file join $here vectors]
if {$argc != 1} {error {One new output directory required}}
set output_dir [file normalize [lindex $argv 0]]
if {[file exists $output_dir]} {error {Output exists; choose a new directory}}
if {![file exists [file join $vector_source c4m2_commands.mem]]} {error {Run generate_vectors.py first}}
set rtl_dir [file join $project_root build/hardware/c6_latency/c6_latency.srcs/sources_1/imports]
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
lappend sources [file join $rtl_dir axis_demux.v]
add_files $sources
foreach top {tb_scene2d_draw_tile_layer tb_scene2d_c4m7_core tb_scene2d_clear_fill_renderer tb_scene2d_index4_asset_blit tb_scene2d_framebuffer_scanout tb_scene2d_command_upload} {
    add_files -fileset sim_1 [file join $script_dir ${top}.sv]
}
set_property top scene2d_c4m7_core [get_filesets sources_1]
update_compile_order -fileset sim_1

proc verify_simulation {top generic marker label {runtime 4ms}} {
    global output_dir script_dir vector_source
    set simset [get_filesets sim_1]
    set_property top $top $simset
    set_property generic $generic $simset
    set_property xsim.simulate.runtime $runtime $simset
    update_compile_order -fileset sim_1
    set run_dir [file join $output_dir simulation tile_cache_verify.sim sim_1 behav xsim]
    set vector_dir [file join $run_dir sim scene2d_gpu vectors]
    file mkdir $vector_dir
    foreach vector [glob [file join $vector_source *.mem]] {
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


# Same unchanged sources/vectors, 100 MHz, baseline/two-feature/three-feature.
# Outputs comparison/{baseline,v35,v40}_{mixed,raster}.log.
# Next: compare frame CRC/writes and cycles; these are RTL kernel measurements.
foreach profile {baseline v35 v40} {
 set pipeline [expr {$profile ne "baseline"}]
 set pair [expr {$profile eq "v40"}]
 set flags "TILE_DESCRIPTOR_CACHE_ENABLE=$pipeline BLIT_PIXEL_PIPELINE_ENABLE=$pipeline TILE_PIXEL_PIPELINE_ENABLE=$pipeline TILE_PIXEL_PAIR_ENABLE=$pair BLIT_PIXEL_PAIR_ENABLE=$pair CLEAR_FILL_PIXEL_PAIR_ENABLE=$pair UPLOAD_RENDER_OVERLAP_ENABLE=0"
 verify_simulation tb_scene2d_c4m7_core "$flags TEST_BLIT_SCENES=1 TEST_TILE_PIPELINE_SCENES=1 TEST_TILE_PAIR_SCENES=1" "SCENE2D_C4M7_TILE_PAIR=PASS pair=$pair frames=2" ${profile}_mixed 4ms
 verify_simulation tb_scene2d_c4m7_core "$flags TEST_RASTER_PAIR_SCENES=1" "SCENE2D_C4M7_RASTER_PAIR=PASS blit=$pair solid=$pair frames=3" ${profile}_raster 30ms
}
close_project
puts GPU_THREE_PROFILE_COMPARISON_PASS
