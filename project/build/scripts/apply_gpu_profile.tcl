# Vivado 2026.1 / PYNQ-Z2. Source after recreating the project.
# Input gpu_profile: baseline, cache_pipeline, or cache_pipeline_pair (default).
# Output: regenerated BD with checked parameters; next: full non-incremental build.
if {![info exists gpu_profile]} {set gpu_profile cache_pipeline_pair}
if {$gpu_profile ni {baseline cache_pipeline cache_pipeline_pair}} {error {Unknown GPU profile}}
if {[get_property PART [current_project]] ne {xc7z020clg400-1}} {error {Wrong device}}
open_bd_design [get_files c6v.bd]
set core [get_bd_cells /core]
foreach flag {TILE_DESCRIPTOR_CACHE_ENABLE BLIT_PIXEL_PIPELINE_ENABLE TILE_PIXEL_PIPELINE_ENABLE} {
    set_property CONFIG.$flag [expr {$gpu_profile ne {baseline}}] $core
}
foreach flag {TILE_PIXEL_PAIR_ENABLE BLIT_PIXEL_PAIR_ENABLE CLEAR_FILL_PIXEL_PAIR_ENABLE} {
    set_property CONFIG.$flag [expr {$gpu_profile eq {cache_pipeline_pair}}] $core
}
set_property CONFIG.UPLOAD_RENDER_OVERLAP_ENABLE 0 $core
validate_bd_design
save_bd_design
generate_target all [get_files c6v.bd]
export_ip_user_files -of_objects [get_files c6v.bd] -no_script -sync -force -quiet
foreach flag {TILE_DESCRIPTOR_CACHE_ENABLE BLIT_PIXEL_PIPELINE_ENABLE TILE_PIXEL_PIPELINE_ENABLE TILE_PIXEL_PAIR_ENABLE BLIT_PIXEL_PAIR_ENABLE CLEAR_FILL_PIXEL_PAIR_ENABLE UPLOAD_RENDER_OVERLAP_ENABLE} {
    puts "GPU_PROFILE $gpu_profile $flag=[get_property CONFIG.$flag $core]"
}
