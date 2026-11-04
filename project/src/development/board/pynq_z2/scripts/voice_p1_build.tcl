if {[version -short] ne "2026.1"} {
    error "Voice P1 build requires Vivado 2026.1"
}
if {![info exists ::env(VOICE_P1_ROOT)] || $::env(VOICE_P1_ROOT) eq ""} {
    error "VOICE_P1_ROOT must name the isolated candidate"
}
set p1_build_root [file normalize $::env(VOICE_P1_ROOT)]
set p1_build_script_dir [file dirname [file normalize [info script]]]
set p1_build_original [file normalize [file join $p1_build_script_dir .. .. .. .. voice_2s_20261005]]
if {[string equal -nocase $p1_build_root $p1_build_original] ||
    [string match -nocase "${p1_build_original}/*" $p1_build_root]} {
    error "Voice P1 build must not modify the original handoff"
}
set p1_build_stage synth
if {[info exists ::env(VOICE_P1_BUILD_STAGE)]} {
    set p1_build_stage $::env(VOICE_P1_BUILD_STAGE)
}
if {$p1_build_stage ni {synth route}} {
    error "VOICE_P1_BUILD_STAGE must be synth or route"
}
set p1_build_hardware [file join $p1_build_root hardware]
set p1_build_project_dir [file join $p1_build_hardware build voice_hybrid_2s_dma_project]
set p1_build_project [file join $p1_build_project_dir voice_hybrid_2s_dma.xpr]
set p1_build_output [file join $p1_build_hardware build voice_hybrid_2s]
if {![file isfile $p1_build_project]} {
    error "Prepare the 2026.1 candidate first: $p1_build_project"
}
file mkdir $p1_build_output
cd [file join $p1_build_hardware vivado]
set_param general.maxThreads 4
if {$p1_build_stage eq "synth"} {
    if {[current_project -quiet] eq ""} {
        open_project $p1_build_project
    }
    if {![string equal -nocase [file normalize [get_property DIRECTORY [current_project]]] $p1_build_project_dir]} {
        error "The current project does not belong to the isolated candidate"
    }
    if {[get_property PART [current_project]] ne "xc7z020clg400-1"} {
        error "Voice P1 build requires xc7z020clg400-1"
    }
    update_ip_catalog
    foreach p1_build_ip_name {voice_fft_512 voice_magnitude_cordic} {
        set p1_build_ip [get_ips -quiet $p1_build_ip_name]
        if {[llength $p1_build_ip] != 1 || [get_property IS_LOCKED $p1_build_ip]} {
            error "Required 2026.1 IP unavailable or locked: $p1_build_ip_name"
        }
        generate_target synthesis $p1_build_ip -force
        synth_ip -force $p1_build_ip
    }
    set p1_build_bd [get_files [file join $p1_build_project_dir voice_hybrid_2s_dma.srcs sources_1 bd voice_hybrid_2s voice_hybrid_2s.bd]]
    open_bd_design $p1_build_bd
    if {[get_property CONFIG.RECORDS_PER_BATCH [get_bd_cells voice_hybrid_i2s_0]] != 485} {
        error "Voice P1 requires 485 records"
    }
    validate_bd_design
    save_bd_design
    set_property synth_checkpoint_mode None $p1_build_bd
    generate_target all $p1_build_bd -force
    export_ip_user_files -of_objects $p1_build_bd -no_script -sync -force -quiet
    foreach p1_build_xdc [get_files -all -quiet *audio_mclk_0.xdc] {
        if {[string match "*audio_mclk_0.xdc" [file tail $p1_build_xdc]]} {
            set_property USED_IN_SYNTHESIS false $p1_build_xdc
            set_property USED_IN_IMPLEMENTATION false $p1_build_xdc
        }
    }
    update_compile_order -fileset sources_1
    synth_design -top voice_hybrid_2s_wrapper -part xc7z020clg400-1 -flatten_hierarchy rebuilt
    write_checkpoint -force [file join $p1_build_output post_synth.dcp]
    report_utilization -file [file join $p1_build_output utilization_synth.rpt]
    report_drc -file [file join $p1_build_output drc_synth.rpt]
} else {
    set p1_build_checkpoint [file join $p1_build_output post_synth.dcp]
    if {![file isfile $p1_build_checkpoint]} {
        error "Complete synthesis before routing: $p1_build_checkpoint"
    }
    if {[current_project -quiet] ne ""} {
        close_project -quiet
    }
    open_checkpoint $p1_build_checkpoint
    opt_design
    place_design
    phys_opt_design
    route_design
    write_checkpoint -force [file join $p1_build_output post_route.dcp]
    report_utilization -file [file join $p1_build_output utilization_placed.rpt]
    report_timing_summary -delay_type min_max -report_unconstrained -file [file join $p1_build_output timing_summary.rpt]
    report_bus_skew -file [file join $p1_build_output bus_skew.rpt]
    report_drc -file [file join $p1_build_output drc.rpt]
    report_methodology -file [file join $p1_build_output methodology.rpt]
    report_cdc -details -file [file join $p1_build_output cdc_details.rpt]
    report_clock_interaction -delay_type min_max -file [file join $p1_build_output clock_interaction.rpt]
}
puts "VOICE_P1_BUILD_PASS stage=$p1_build_stage tool=[version -short] output=$p1_build_output"
puts "VOICE_P1_PUBLICATION_BLOCKED numeric_and_routed_signoff_required"