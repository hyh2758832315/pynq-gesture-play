if {![info exists ::env(VOICE_P1_ROOT)] || [version -short] ne "2026.1"} {
    error "Voice P1 simulation requires VOICE_P1_ROOT and Vivado 2026.1"
}
set p1_sim_script_dir [file dirname [file normalize [info script]]]
set p1_sim_repo [file normalize [file join $p1_sim_script_dir .. .. ..]]
set p1_sim_root [file normalize $::env(VOICE_P1_ROOT)]
set p1_sim_project_dir [file join $p1_sim_root hardware build voice_hybrid_2s_dma_project]
if {[file normalize [get_property DIRECTORY [current_project]]] ne $p1_sim_project_dir} {
    error "Open the isolated P1 project before simulation"
}
set p1_simset [get_filesets sim_1]
foreach p1_sim_source [list \
    [file join $p1_sim_repo sim voice tb_voice_hybrid_pcm_p1.sv] \
    [file join $p1_sim_root hardware rtl fir_coeff_q17.mem] \
    [file join $p1_sim_root hardware rtl hamming_512_q15.mem]] {
    if {![llength [get_files -quiet $p1_sim_source]]} {
        add_files -fileset $p1_simset -norecurse $p1_sim_source
    }
}
set_property target_simulator XSim [current_project]
set p1_sim_smoke [expr {[info exists ::env(VOICE_P1_SMOKE)] && $::env(VOICE_P1_SMOKE) eq "1"}]
set p1_sim_capture_only [expr {[info exists ::env(VOICE_P1_CAPTURE_ONLY)] && $::env(VOICE_P1_CAPTURE_ONLY) eq "1"}]
set p1_sim_profile [expr {[info exists ::env(VOICE_P1_PROFILE_FRONTEND)] && $::env(VOICE_P1_PROFILE_FRONTEND) eq "1"}]
set p1_sim_feature_profile [expr {[info exists ::env(VOICE_P1_PROFILE_FEATURE_CORE)] && $::env(VOICE_P1_PROFILE_FEATURE_CORE) eq "1"}]
if {$p1_sim_smoke + $p1_sim_capture_only + $p1_sim_profile + $p1_sim_feature_profile > 1} {
    error "Select only one P1 simulation mode"
}
if {$p1_sim_profile || $p1_sim_feature_profile} {
    set_property TOP tb_voice_frontend_profile_p1 $p1_simset
    set_property GENERIC "INCLUDE_FEATURE_CORE=$p1_sim_feature_profile" $p1_simset
} elseif {$p1_sim_capture_only} {
    set_property TOP tb_voice_feature_capture_p1 $p1_simset
    set_property GENERIC {} $p1_simset
} else {
    set_property TOP tb_voice_hybrid_pcm_p1 $p1_simset
    set_property GENERIC "SMOKE_ONLY=$p1_sim_smoke" $p1_simset
}
set_property xsim.simulate.runtime all $p1_simset
set_property xsim.simulate.log_all_signals false $p1_simset
set_property xsim.elaborate.debug_level off $p1_simset
set_property xsim.elaborate.xelab.more_options {} $p1_simset
set_property -dict [list xsim.simulate.xsim.more_options {-maxdeltaid 10000 -stats}] $p1_simset
update_compile_order -fileset sim_1
set p1_sim_started [clock milliseconds]
launch_simulation -simset sim_1 -mode behavioral
set p1_sim_elapsed [expr {[clock milliseconds] - $p1_sim_started}]
set p1_sim_dir [file join $p1_sim_project_dir voice_hybrid_2s_dma.sim sim_1 behav xsim]
set p1_sim_log [file join $p1_sim_dir simulate.log]
set p1_sim_handle [open $p1_sim_log r]
set p1_sim_text [read $p1_sim_handle]
close $p1_sim_handle
set p1_sim_marker "VOICE_P1_PCM_PROTOCOL_PASS"
set p1_sim_captures {silence_pcm 6912 silence_features 192 square500_pcm 192000 square500_features 31040}
if {$p1_sim_smoke} {
    set p1_sim_marker "VOICE_P1_BOOTSTRAP_PASS"
    set p1_sim_captures {bootstrap_pcm 12 bootstrap_features 0}
}
if {$p1_sim_capture_only} {
    set p1_sim_marker "VOICE_P1_CAPTURE_PROTOCOL_PASS records=485 words=3880 bytes=31040 stalls=[0-9]+"
    set p1_sim_captures {capture_features 31040}
}
if {$p1_sim_profile} {
    set p1_sim_marker {VOICE_P1_FRONTEND_PROFILE_PASS pcm=6 outputs=1 time=[0-9]+}
    set p1_sim_captures {}
}
if {$p1_sim_feature_profile} {
    set p1_sim_marker {VOICE_P1_FEATURE_IDLE_PROFILE_PASS pcm=6 outputs=1 time=[0-9]+}
    set p1_sim_captures {}
}
if {[regexp -nocase {fatal:|error:} $p1_sim_text] ||
    ![regexp -line "^${p1_sim_marker}\\r?\$" $p1_sim_text]} {
    error "P1 simulation failed or did not reach its terminal PASS; inspect $p1_sim_log"
}
foreach {p1_sim_name p1_sim_size} $p1_sim_captures {
    set p1_sim_capture [file join $p1_sim_dir voice_p1_${p1_sim_name}.bin]
    if {![file isfile $p1_sim_capture] || [file size $p1_sim_capture] != $p1_sim_size} {
        error "P1 capture size mismatch: $p1_sim_capture expected $p1_sim_size"
    }
}
puts "VOICE_P1_SIMULATION_PASS smoke=$p1_sim_smoke capture_only=$p1_sim_capture_only profile=$p1_sim_profile feature_profile=$p1_sim_feature_profile elapsed_ms=$p1_sim_elapsed path=$p1_sim_dir"
puts "VOICE_P1_EQUIVALENCE_PENDING original_2024_reference_required"