set script_dir [file dirname [file normalize [info script]]]
set board_dir [file normalize [file join $script_dir ..]]
set iic_probe [expr {[info exists ::env(CAMERA_IIC_PROBE)] && $::env(CAMERA_IIC_PROBE) eq "1"}]
set corrected_pins [expr {[info exists ::env(CAMERA_CORRECTED_PINS)] && $::env(CAMERA_CORRECTED_PINS) eq "1"}]
set project_name [expr {$iic_probe ? "camera_direct_plug_ila" : "camera_direct_plug"}]
if {$corrected_pins} {
    append project_name _corrected
}
if {[info exists ::env(CAMERA_HDMI)] && $::env(CAMERA_HDMI) eq "1"} {
    if {!$corrected_pins || $iic_probe} {
        error "CAMERA_HDMI requires corrected pins without IIC probe"
    }
    append project_name _hdmi
}
set project_dir [file join $board_dir build $project_name]
if {$corrected_pins && [info exists ::env(CAMERA_BUILD_ROOT)]} {
    set project_dir [file normalize [file join $::env(CAMERA_BUILD_ROOT) $project_name]]
}
set report_dir [file join $board_dir output reports $project_name]
set checkpoint [file join $project_dir ${project_name}.runs impl_1 camera_wrapper_placed.dcp]
set clock_info [expr {[info exists ::env(CAMERA_CLOCK_INFO_ONLY)] && $::env(CAMERA_CLOCK_INFO_ONLY) eq "1"}]

if {$clock_info || (($iic_probe || $corrected_pins) && [info exists ::env(CAMERA_PLACE_PROBE)] && $::env(CAMERA_PLACE_PROBE) eq "1")} {
    set optimized [file join $project_dir ${project_name}.runs impl_1 camera_wrapper_opt.dcp]
    if {![file exists $optimized]} {
        error "Missing optimized checkpoint: $optimized"
    }
    open_checkpoint $optimized
    set pclk_net [get_nets -quiet vid_pclk_IBUF]
    if {[llength $pclk_net] != 1} {
        error "Expected one vid_pclk_IBUF net, found [llength $pclk_net]"
    }
    if {$clock_info} {
        foreach pin_name {Y19 U19} {
            puts "CAMERA_CLOCK_PACKAGE_PIN=$pin_name"
            report_property [get_package_pins $pin_name]
        }
        report_property [get_cells vid_pclk_IBUF_BUFG_inst]
        puts "CAMERA_CLOCK_INFO_STATUS=PASS"
        close_project
        exit 0
    }
    read_xdc [file join $board_dir constraints camera_direct_plug_clock_probe.xdc]
    puts "CAMERA_CLOCK_PROBE=NONDEDICATED_OFFLINE_ONLY"
    place_design
    write_checkpoint -force $checkpoint
} else {
    if {![file exists $checkpoint]} {
        error "Missing placed checkpoint: $checkpoint"
    }
    open_checkpoint $checkpoint
}
file mkdir $report_dir
report_drc -file [file join $report_dir drc_placed.rpt]
report_timing_summary -delay_type min_max -report_unconstrained \
    -file [file join $report_dir timing_placed.rpt]
report_clock_interaction -file [file join $report_dir clocks_placed.rpt]
puts "CAMERA_DIRECT_PLUG_PLACED_REPORTS=PASS"
if {[info exists ::env(CAMERA_ROUTE_PROBE)] && $::env(CAMERA_ROUTE_PROBE) eq "1"} {
    phys_opt_design
    route_design
    write_checkpoint -force [file join $project_dir ${project_name}.runs impl_1 camera_wrapper_routed_probe.dcp]
    report_drc -file [file join $report_dir drc_routed_probe.rpt]
    report_timing_summary -delay_type min_max -report_unconstrained \
        -file [file join $report_dir timing_routed_probe.rpt]
    report_clock_interaction -file [file join $report_dir clocks_routed_probe.rpt]
    puts "CAMERA_DIRECT_PLUG_ROUTE_PROBE=PASS"
}
close_project