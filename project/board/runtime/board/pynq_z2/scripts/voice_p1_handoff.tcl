if {[version -short] ne "2026.1"} {
    error "This handoff requires Vivado 2026.1"
}
set p1_handoff_scripts [file dirname [file normalize [info script]]]
set p1_handoff_root [file normalize [file join $p1_handoff_scripts .. .. ..]]
set p1_handoff_action prepare
if {[info exists ::env(VOICE_P1_ACTION)]} {
    set p1_handoff_action $::env(VOICE_P1_ACTION)
} elseif {[info exists argc] && $argc > 0} {
    set p1_handoff_action [lindex $argv 0]
}
if {$p1_handoff_action ni {prepare smoke capture profile_frontend profile_feature full synth route}} {
    error "Action must be prepare, smoke, capture, profile_frontend, profile_feature, full, synth or route"
}
set ::env(VOICE_P1_ROOT) $p1_handoff_root
unset -nocomplain ::env(VOICE_ALLOW_UNVALIDATED_TOOL) ::env(VOICE_P1_SMOKE) \
    ::env(VOICE_P1_CAPTURE_ONLY) ::env(VOICE_P1_PROFILE_FRONTEND) ::env(VOICE_P1_PROFILE_FEATURE_CORE)
if {$p1_handoff_action eq "prepare"} {
    source [file join $p1_handoff_scripts voice_p1_prepare.tcl]
} elseif {$p1_handoff_action in {synth route}} {
    set ::env(VOICE_P1_BUILD_STAGE) $p1_handoff_action
    source [file join $p1_handoff_scripts voice_p1_build.tcl]
} else {
    set p1_handoff_project [file join $p1_handoff_root hardware build voice_hybrid_2s_dma_project voice_hybrid_2s_dma.xpr]
    if {![file isfile $p1_handoff_project]} {
        error "Run prepare first: $p1_handoff_project"
    }
    if {[current_project -quiet] eq ""} {
        open_project $p1_handoff_project
    }
    switch $p1_handoff_action {
        smoke {set ::env(VOICE_P1_SMOKE) 1}
        capture {set ::env(VOICE_P1_CAPTURE_ONLY) 1}
        profile_frontend {set ::env(VOICE_P1_PROFILE_FRONTEND) 1}
        profile_feature {set ::env(VOICE_P1_PROFILE_FEATURE_CORE) 1}
    }
    source [file join $p1_handoff_scripts voice_p1_simulate.tcl]
}
puts "VOICE_2026_HANDOFF_ACTION_PASS action=$p1_handoff_action root=$p1_handoff_root"