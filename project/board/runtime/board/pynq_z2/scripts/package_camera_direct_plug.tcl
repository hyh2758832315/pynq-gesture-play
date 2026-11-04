set script_dir [file dirname [file normalize [info script]]]
set board_dir [file normalize [file join $script_dir ..]]
set iic_probe [expr {[info exists ::env(CAMERA_IIC_PROBE)] && $::env(CAMERA_IIC_PROBE) eq "1"}]
set corrected_pins [expr {[info exists ::env(CAMERA_CORRECTED_PINS)] && $::env(CAMERA_CORRECTED_PINS) eq "1"}]
set project_name [expr {$iic_probe ? "camera_direct_plug_ila" : "camera_direct_plug"}]
if {$corrected_pins} {
    append project_name _corrected
}
set hdmi [expr {[info exists ::env(CAMERA_HDMI)] && $::env(CAMERA_HDMI) eq "1"}]
if {$hdmi} {
    if {!$corrected_pins || $iic_probe} {
        error "CAMERA_HDMI requires corrected pins without IIC probe"
    }
    append project_name _hdmi
}
set project_dir [file join $board_dir build $project_name]
if {$corrected_pins && [info exists ::env(CAMERA_BUILD_ROOT)]} {
    set project_dir [file normalize [file join $::env(CAMERA_BUILD_ROOT) $project_name]]
}
set output_dir [file join $board_dir output]
if {$iic_probe || $corrected_pins} {
    set output_dir [file join $output_dir $project_name]
}
set checkpoint [file join $project_dir ${project_name}.runs impl_1 camera_wrapper_routed_probe.dcp]
set hwh_source [file join $project_dir ${project_name}.gen sources_1 bd camera hw_handoff camera.hwh]

foreach required_file [list $checkpoint $hwh_source] {
    if {![file exists $required_file]} {
        error "Missing camera prototype input: $required_file"
    }
}

open_checkpoint $checkpoint
file mkdir $output_dir
set artifact_name $project_name
if {$corrected_pins} {
    set_property PULLUP true [get_ports {vid_iic_scl_io vid_iic_sda_io}]
    foreach {port_name expected_pin} {
        vid_xclk U19 vid_pclk Y19 vid_vsync W18 vid_hsync Y16
        vid_iic_scl_io Y17 vid_iic_sda_io W19
        {vid_data[0]} W13 {vid_data[1]} T10 {vid_data[2]} V12 {vid_data[3]} T11
        {vid_data[4]} W16 {vid_data[5]} Y14 {vid_data[6]} V16 {vid_data[7]} W14
    } {
        set port [get_ports $port_name]
        if {[get_property PACKAGE_PIN $port] ne $expected_pin || [get_property IOSTANDARD $port] ne "LVCMOS33"} {
            error "Corrected camera IO contract failed: $port_name"
        }
        puts "CAMERA_CORRECTED_PIN=$port_name:$expected_pin"
    }
    foreach port_name {vid_iic_scl_io vid_iic_sda_io} {
        if {![get_property PULLUP [get_ports $port_name]]} {
            error "Corrected camera SCCB pullup contract failed: $port_name"
        }
        puts "CAMERA_CORRECTED_PULLUP=$port_name:true"
    }
    if {$hdmi} {
        foreach {port_name expected_pin} {
            hdmi_out_clk_n L17 hdmi_out_clk_p L16
            {hdmi_out_data_n[0]} K18 {hdmi_out_data_p[0]} K17
            {hdmi_out_data_n[1]} J19 {hdmi_out_data_p[1]} K19
            {hdmi_out_data_n[2]} H18 {hdmi_out_data_p[2]} J18
        } {
            set port [get_ports $port_name]
            if {[get_property PACKAGE_PIN $port] ne $expected_pin || [get_property IOSTANDARD $port] ne "TMDS_33"} {
                error "Camera HDMI IO contract failed: $port_name"
            }
            puts "CAMERA_HDMI_PIN=$port_name:$expected_pin"
        }
    }
    set report_dir [file join $board_dir output reports $project_name]
    file mkdir $report_dir
    report_drc -file [file join $report_dir drc_package.rpt]
    if {[llength [get_drc_violations -filter {SEVERITY == Error}]] > 0} {
        error "Corrected camera DRC failed"
    }
    report_timing_summary -delay_type min_max -report_unconstrained -file [file join $report_dir timing_package.rpt]
    report_clock_interaction -file [file join $report_dir clocks_package.rpt]
    report_cdc -details -file [file join $report_dir cdc_package.rpt]
    report_methodology -file [file join $report_dir methodology_package.rpt]
    foreach delay_type {max min} {
        set paths [get_timing_paths -delay_type $delay_type -max_paths 1 -nworst 1]
        if {[llength $paths] == 0} {
            error "Corrected camera $delay_type timing path is missing"
        }
        set slack [get_property SLACK [lindex $paths 0]]
        puts "CAMERA_CORRECTED_SLACK_${delay_type}=$slack"
        if {$slack < 0} {
            error "Corrected camera $delay_type timing failed"
        }
    }
    set clock_route [string toupper [get_property CLOCK_DEDICATED_ROUTE [get_nets vid_pclk_IBUF]]]
    set offline_clock [expr {$clock_route eq "FALSE" || $clock_route eq "0"}]
    puts "CAMERA_CORRECTED_CLOCK_DEDICATED_ROUTE=$clock_route"
    if {[info exists ::env(CAMERA_PACKAGE_CHECK_ONLY)] && $::env(CAMERA_PACKAGE_CHECK_ONLY) eq "1"} {
        puts "CAMERA_CORRECTED_CHECK_STATUS=PASS"
        puts "CAMERA_CORRECTED_SIGNOFF_STATUS=[expr {$offline_clock ? "OFFLINE_MODEL_ONLY" : "MODEL_PASS"}]"
        close_project
        exit 0
    }
    if {$offline_clock} {
        if {![info exists ::env(CAMERA_ALLOW_NONDEDICATED_PCLK)] || $::env(CAMERA_ALLOW_NONDEDICATED_PCLK) ne "1"} {
            error "Corrected camera checkpoint uses an offline non-dedicated clock probe; signed-off bitstream generation is blocked"
        }
        append artifact_name _prototype
        set output_dir [file join $output_dir prototype]
        file mkdir $output_dir
        puts "CAMERA_CORRECTED_SIGNOFF_STATUS=NONDEDICATED_PROTOTYPE"
    }
}
set bitstream [file join $output_dir ${artifact_name}.bit]
write_bitstream -force $bitstream
file copy -force $hwh_source [file join $output_dir ${artifact_name}.hwh]
if {$iic_probe} {
    write_debug_probes -force [file join $output_dir ${artifact_name}.ltx]
}
puts "CAMERA_DIRECT_PLUG_BIT=$bitstream"
puts "CAMERA_DIRECT_PLUG_PACKAGE_STATUS=PASS"