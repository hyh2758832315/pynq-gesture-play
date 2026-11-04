if {![info exists ::env(VOICE_P1_ROOT)] || $::env(VOICE_P1_ROOT) eq ""} {
    error "VOICE_P1_ROOT must name a new isolated candidate"
}
if {[version -short] ne "2026.1"} {
    error "Voice P1 requires Vivado 2026.1"
}
set p1_script_dir [file dirname [file normalize [info script]]]
set p1_source_root [file normalize [file join $p1_script_dir .. .. .. .. voice_2s_20261005]]
set p1_candidate_root [file normalize $::env(VOICE_P1_ROOT)]
if {[string equal -nocase $p1_candidate_root $p1_source_root] ||
    [string match -nocase "${p1_source_root}/*" $p1_candidate_root]} {
    error "Voice P1 must not generate files in the original handoff"
}
set p1_hardware [file join $p1_candidate_root hardware]
set p1_vivado [file join $p1_hardware vivado]
foreach p1_name {create_voice_fft_512.tcl create_voice_magnitude_cordic.tcl create_voice_hybrid_dma_project.tcl} {
    if {![file isfile [file join $p1_vivado $p1_name]]} {
        error "Missing candidate source: $p1_name"
    }
}
set p1_project [file join $p1_hardware build voice_hybrid_2s_dma_project voice_hybrid_2s_dma.xpr]
if {[file exists $p1_project]} {
    error "Candidate project already exists; inspect it before regenerating"
}
set ::env(VOICE_CAPTURE_SECONDS) 2
cd $p1_vivado
source [file join $p1_vivado create_voice_fft_512.tcl]
source [file join $p1_vivado create_voice_magnitude_cordic.tcl]
source [file join $p1_vivado create_voice_hybrid_dma_project.tcl]
set p1_records [get_property CONFIG.RECORDS_PER_BATCH [get_bd_cells voice_hybrid_i2s_0]]
if {$p1_records != 485} {
    error "Voice P1 expected 485 records; got $p1_records"
}
puts "VOICE_P1_PREPARE_PASS root=$p1_candidate_root records=$p1_records"
puts "VOICE_P1_PUBLICATION_BLOCKED numeric_and_routed_signoff_required"