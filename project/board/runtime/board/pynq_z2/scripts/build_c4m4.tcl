set wrapper_dir [file dirname [file normalize [info script]]]
set project_name c4_blit
set design_name c4m4
set report_stage c4m4
set core_reference scene2d_c4m4_core
set build_id 0xC0040400
set atlas_init_file [file normalize [file join $wrapper_dir .. .. .. sim scene2d_gpu vectors c4m4_atlas.mem]]
source [file join $wrapper_dir build_c4m3.tcl]