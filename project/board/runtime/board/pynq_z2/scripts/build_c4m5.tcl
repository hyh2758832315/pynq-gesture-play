set wrapper_dir [file dirname [file normalize [info script]]]
set repo_dir [file normalize [file join $wrapper_dir .. .. ..]]
set project_name c4_runtime_palette
set design_name c4m5
set report_stage c4m5
set core_reference scene2d_c4m5_core
set build_id 0xC0040500
set atlas_init_file [file normalize [file join $repo_dir sim scene2d_gpu vectors c4m4_atlas.mem]]
set enable_runtime_palette_status 1
set extra_rtl_files [list \
    [file join $repo_dir third_party verilog-axis rtl axis_demux.v] \
    [file join $repo_dir rtl scene2d_gpu scene2d_packet_router.sv] \
    [file join $repo_dir rtl scene2d_gpu scene2d_resource_upload.sv] \
    [file join $repo_dir rtl scene2d_gpu scene2d_palette_store.sv] \
    [file join $repo_dir rtl scene2d_gpu scene2d_c4m5_core.sv]]
source [file join $wrapper_dir build_c4m3.tcl]