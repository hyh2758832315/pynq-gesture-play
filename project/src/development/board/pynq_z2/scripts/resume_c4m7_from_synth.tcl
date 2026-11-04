set script_dir [file dirname [file normalize [info script]]]
set board_dir [file normalize [file join $script_dir ..]]
set project_name c4_runtime_tilemap
set design_name c4m7
set report_stage c4m7
set build_id 0xC0040700
set project_dir [file join $board_dir build $project_name]
set project_file [file join $project_dir ${project_name}.xpr]
set output_dir [file join $board_dir output]
set report_dir [file join $output_dir reports $report_stage]
set cdc_constraints [file normalize [file join $board_dir constraints c4m3_cdc.xdc]]
set synth_checkpoint [file join $project_dir ${project_name}.runs synth_1 ${design_name}_wrapper.dcp]
set synth_log [file join $project_dir ${project_name}.runs synth_1 runme.log]
set routed_checkpoint [file join $project_dir ${project_name}.runs impl_1 ${design_name}_wrapper_routed.dcp]
set check_only [expr {[info exists ::env(C4M7_RESUME_CHECK_ONLY)] && $::env(C4M7_RESUME_CHECK_ONLY) eq "1"}]
set reuse_synthesis [expr {[info exists ::env(C4M7_REUSE_SYNTH)] && $::env(C4M7_REUSE_SYNTH) eq "1"}]

foreach required [list $project_file $cdc_constraints $synth_checkpoint] {
    if {![file exists $required]} {
        error "C4M7 resume dependency is missing: $required"
    }
}

open_project $project_file
set cdc_file [get_files -quiet $cdc_constraints]
if {[llength $cdc_file] != 1} {
    error "Expected exactly one C4M7 CDC constraint file, found [llength $cdc_file]"
}
set_property USED_IN_SYNTHESIS false $cdc_file
set_property USED_IN_IMPLEMENTATION true $cdc_file

set synth_run [get_runs synth_1]
if {[get_property PROGRESS $synth_run] ne "100%"} {
    error "C4M7 synth_1 is incomplete: [get_property STATUS $synth_run]"
}
open_run synth_1
if {[llength [get_cells -hierarchical -quiet]] == 0} {
    error "C4M7 synthesized checkpoint contains no cells"
}
close_design

set core_checkpoint [file join $project_dir ${project_name}.runs c4m7_core_0_synth_1 c4m7_core_0.dcp]
if {![file exists $core_checkpoint]} {
    error "C4M7 core OOC checkpoint is missing: $core_checkpoint"
}

if {$check_only} {
    puts "C4M7_RESUME_CHECK=PASS"
    close_project
    exit
}

file mkdir $output_dir
file mkdir $report_dir
foreach stale_output [list \
    [file join $output_dir ${project_name}.bit] \
    [file join $output_dir ${project_name}.hwh] \
    [file join $output_dir ${project_name}.xsa] \
    [file join $output_dir ${project_name}_manifest.txt]] {
    file delete -force $stale_output
}

reset_run impl_1
if {!$reuse_synthesis} {
    reset_run synth_1
    launch_runs synth_1 -jobs 1
    wait_on_run synth_1
    if {[get_property PROGRESS [get_runs synth_1]] ne "100%"} {
        error "$report_stage synthesis failed: [get_property STATUS [get_runs synth_1]]"
    }
}
set synth_log_file [open $synth_log r]
set synth_log_text [read $synth_log_file]
close $synth_log_file
if {[string first "CRITICAL WARNING:" $synth_log_text] >= 0} {
    error "$report_stage synthesis log contains Critical Warnings: $synth_log"
}

set_property STRATEGY Performance_ExplorePostRoutePhysOpt [get_runs impl_1]
launch_runs impl_1 -to_step route_design -jobs 1
wait_on_run impl_1
if {![file exists $routed_checkpoint]} {
    error "$report_stage route_design did not generate $routed_checkpoint"
}

open_checkpoint $routed_checkpoint
set pixel_clocks [get_clocks -quiet clk_out1_${design_name}_pixel_clock_0]
if {[llength $pixel_clocks] != 1} {
    error "Expected exactly one $report_stage pixel clock, found [llength $pixel_clocks]"
}
report_timing_summary -delay_type min_max -report_unconstrained -file [file join $report_dir timing_summary.rpt]
set setup_paths [get_timing_paths -delay_type max -max_paths 1 -nworst 1]
set hold_paths [get_timing_paths -delay_type min -max_paths 1 -nworst 1]
if {[llength $setup_paths] == 0 || [llength $hold_paths] == 0} {
    error "$report_stage timing gate could not find setup and hold paths"
}
set setup_wns [get_property SLACK $setup_paths]
set hold_whs [get_property SLACK $hold_paths]
report_utilization -file [file join $report_dir utilization.rpt]
report_drc -file [file join $report_dir drc.rpt]
set drc_failures [get_drc_violations -quiet -filter {SEVERITY == "Error" || SEVERITY == "Critical Warning"}]
set methodology_path [file join $report_dir methodology.rpt]
report_methodology -file $methodology_path
set methodology_file [open $methodology_path r]
set methodology_text [read $methodology_file]
close $methodology_file
report_clock_interaction -file [file join $report_dir clock_interaction.rpt]
report_cdc -details -file [file join $report_dir cdc.rpt]

if {$setup_wns < 0.0 || $hold_whs < 0.0} {
    error "$report_stage timing failed: WNS=$setup_wns ns, WHS=$hold_whs ns"
}
if {[llength $drc_failures] != 0} {
    error "$report_stage DRC contains [llength $drc_failures] Error/Critical Warning violations"
}
if {[string first "Critical Warning" $methodology_text] >= 0} {
    error "$report_stage methodology report contains Critical Warnings: $methodology_path"
}

set bit_source [file join $project_dir ${project_name}.runs impl_1 ${design_name}_wrapper.bit]
write_bitstream -force $bit_source
set hwh_source [file join $project_dir ${project_name}.gen sources_1 bd $design_name hw_handoff ${design_name}.hwh]
file copy -force $bit_source [file join $output_dir ${project_name}.bit]
file copy -force $hwh_source [file join $output_dir ${project_name}.hwh]
write_hw_platform -fixed -include_bit -force [file join $output_dir ${project_name}.xsa]

set manifest [open [file join $output_dir ${project_name}_manifest.txt] w]
puts $manifest "PROJECT=$project_name"
puts $manifest "PART=xc7z020clg400-1"
puts $manifest "VIVADO=[version -short]"
puts $manifest "BUILD_ID=$build_id"
puts $manifest "DMA_CONTROL_ADDRESS=0x40400000"
puts $manifest "BUILD_ID_ADDRESS=0x41200000"
puts $manifest "PRESENT_COMPLETION_ADDRESS=0x412B0000"
puts $manifest "FRAMEBUFFER_STATUS_ADDRESS=0x412C0000"
puts $manifest "PIXEL_CLOCK_MHZ=74.25"
puts $manifest "VIDEO_MODE=1280x720p60"
puts $manifest "LOGICAL_MODE=320x180_4X"
puts $manifest "FRAMEBUFFER_BANKS=2"
puts $manifest "FRAMEBUFFER_BYTES_PER_BANK=57600"
puts $manifest "ATLAS_INIT_FILE=none"
puts $manifest "ROUTER_STATUS_ADDRESS=0x412D0000"
puts $manifest "PALETTE_PACKET_STATUS_ADDRESS=0x412E0000"
puts $manifest "PALETTE_GENERATION_STATUS_ADDRESS=0x412F0000"
puts $manifest "PALETTE_STATE_STATUS_ADDRESS=0x41300000"
puts $manifest "ASSET_PACKET_STATUS_ADDRESS=0x41310000"
puts $manifest "ASSET_GENERATION_STATUS_ADDRESS=0x41320000"
puts $manifest "ASSET_STATE_STATUS_ADDRESS=0x41330000"
puts $manifest "TILEMAP_PACKET_STATUS_ADDRESS=0x41340000"
puts $manifest "TILEMAP_GENERATION_STATUS_ADDRESS=0x41350000"
puts $manifest "TILEMAP_STATE_STATUS_ADDRESS=0x41360000"
puts $manifest "WNS_NS=$setup_wns"
puts $manifest "WHS_NS=$hold_whs"
close $manifest

puts "C4M7_RESUME_BUILD_STATUS=PASS"
close_project