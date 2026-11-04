set wrapper_dir [file dirname [file normalize [info script]]]
set repo_dir [file normalize [file join $wrapper_dir .. .. ..]]
set project_name c6i_tile_cache_p1
set design_name c6i
set report_stage c6i_tile_cache_p1
set experimental_output_dir [file join $repo_dir board pynq_z2 output gpu_cache_experiment]
set core_reference scene2d_c4m7_core
set build_id 0xC0060710
set impl_strategy Performance_ExplorePostRoutePhysOpt
set post_route_phys_opt_directive AggressiveExplore
set enable_runtime_palette_status 1
set enable_runtime_asset_status 1
set enable_runtime_tilemap_status 1
set enable_return_path 1
set tile_descriptor_cache_enable 1
set extra_rtl_files [list \
    [file join $repo_dir third_party verilog-axis rtl axis_demux.v] \
    [file join $repo_dir rtl scene2d_gpu scene2d_packet_router.sv] \
    [file join $repo_dir rtl scene2d_gpu scene2d_resource_upload.sv] \
    [file join $repo_dir rtl scene2d_gpu scene2d_palette_store.sv] \
    [file join $repo_dir rtl scene2d_gpu scene2d_asset_bundle_store.sv] \
    [file join $repo_dir rtl scene2d_gpu scene2d_tilemap_store.sv] \
    [file join $repo_dir rtl scene2d_gpu scene2d_index4_asset_blit.sv] \
    [file join $repo_dir rtl scene2d_gpu scene2d_draw_tile_layer.sv] \
    [file join $repo_dir rtl scene2d_gpu scene2d_c4m7_core.sv] \
    [file join $repo_dir rtl scene2d_gpu scene2d_return_source.sv]]
source [file join $wrapper_dir build_c4m3.tcl]