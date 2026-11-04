set wrapper_dir [file dirname [file normalize [info script]]]
set repo_dir [file normalize [file join $wrapper_dir .. .. ..]]
set project_name c5_live_input
set design_name c5
set report_stage c5
set core_reference scene2d_c4m7_core
set build_id 0xC0050000
set impl_strategy Performance_ExplorePostRoutePhysOpt
set enable_runtime_palette_status 1
set enable_runtime_asset_status 1
set enable_runtime_tilemap_status 1
set enable_board_inputs 1
set extra_rtl_files [list \
    [file join $repo_dir third_party verilog-axis rtl axis_demux.v] \
    [file join $repo_dir rtl scene2d_gpu scene2d_packet_router.sv] \
    [file join $repo_dir rtl scene2d_gpu scene2d_resource_upload.sv] \
    [file join $repo_dir rtl scene2d_gpu scene2d_palette_store.sv] \
    [file join $repo_dir rtl scene2d_gpu scene2d_asset_bundle_store.sv] \
    [file join $repo_dir rtl scene2d_gpu scene2d_tilemap_store.sv] \
    [file join $repo_dir rtl scene2d_gpu scene2d_index4_asset_blit.sv] \
    [file join $repo_dir rtl scene2d_gpu scene2d_draw_tile_layer.sv] \
    [file join $repo_dir rtl scene2d_gpu scene2d_c4m7_core.sv]]
source [file join $wrapper_dir build_c4m3.tcl]