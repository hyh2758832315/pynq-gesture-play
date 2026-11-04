set volume_script_dir [file dirname [file normalize [info script]]]
set volume_stage regress
if {[info exists ::env(VOLUME_STAGE)]} {set volume_stage $::env(VOLUME_STAGE)}
switch -- $volume_stage {
    regress {
        if {[llength [get_projects -quiet]]} {error "close the current project before regress"}
        if {![info exists ::env(VOLUME_SIM_ROUND)]} {set ::env(VOLUME_SIM_ROUND) final}
        foreach volume_case {core numeric axi i2s link} {
            set ::env(VOLUME_SIM_TEST) $volume_case
            source [file join $volume_script_dir simulate_voice_volume.tcl]
            close_sim
            close_project
        }
        puts VOLUME_REGRESSION_PASS
    }
    prepare {source [file join $volume_script_dir create_voice_volume_project.tcl]}
    synth {
        launch_runs synth_1 -jobs 4
        wait_on_run synth_1
        if {[get_property PROGRESS [get_runs synth_1]] ne "100%"} {error "VOLUME_SYNTH_INCOMPLETE"}
        puts VOLUME_SYNTH_PASS
    }
    route {
        launch_runs impl_1 -to_step route_design -jobs 4
        wait_on_run impl_1
        if {[get_property PROGRESS [get_runs impl_1]] ne "100%"} {error "VOLUME_ROUTE_INCOMPLETE"}
        puts VOLUME_ROUTE_COMPLETE
    }
    bit {
        launch_runs impl_1 -to_step write_bitstream -jobs 4
        wait_on_run impl_1
        if {![string match *write_bitstream\ Complete* [get_property STATUS [get_runs impl_1]]]} {error VOLUME_BIT_INCOMPLETE}
        puts VOLUME_BIT_COMPLETE
    }
    export {
        set volume_export [file join [get_property DIRECTORY [current_project]] export]
        if {[info exists ::env(VOLUME_EXPORT_ROOT)]} {set volume_export [file normalize $::env(VOLUME_EXPORT_ROOT)]}
        if {[file exists $volume_export]} {error "refusing occupied export root: $volume_export"}
        file mkdir $volume_export
        if {![string match *write_bitstream\ Complete* [get_property STATUS [get_runs impl_1]]]} {error VOLUME_BIT_INCOMPLETE}
        write_hw_platform -fixed -include_bit -file [file join $volume_export voice_volume.xsa]
        file copy [file join [get_property DIRECTORY [get_runs impl_1]] volume_wrapper.bit] [file join $volume_export voice_volume.bit]
        file copy [file join [get_property DIRECTORY [current_project]] voice_volume.gen sources_1 bd volume hw_handoff volume.hwh] [file join $volume_export voice_volume.hwh]
        puts VOLUME_EXPORT_PASS
    }
    default {error "unsupported stage $volume_stage: regress, prepare, synth, route, bit, export"}
}