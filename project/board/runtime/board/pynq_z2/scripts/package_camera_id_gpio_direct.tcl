set script_dir [file dirname [file normalize [info script]]]
set board_dir [file normalize [file join $script_dir ..]]
set project_name camera_id_gpio_direct
set project_dir [file join $board_dir build $project_name]
set output_dir [file join $board_dir output $project_name]
set report_dir [file join $board_dir output reports $project_name]
set checkpoint [file join $project_dir ${project_name}.runs impl_1 camera_wrapper_routed.dcp]
set hwh_source [file join $project_dir ${project_name}.gen sources_1 bd camera hw_handoff camera.hwh]

foreach required_file [list $checkpoint $hwh_source] {
    if {![file exists $required_file]} {
        error "Missing GPIO camera input: $required_file"
    }
}

open_checkpoint $checkpoint
foreach {port_name package_pin} {camera_xclk Y19 camera_scl W19 camera_sda Y17} {
    set port [get_ports $port_name]
    if {[get_property PACKAGE_PIN $port] ne $package_pin || [get_property IOSTANDARD $port] ne "LVCMOS33"} {
        error "Unexpected GPIO camera IO mapping: $port_name"
    }
    puts "CAMERA_ID_GPIO_PIN=$port_name:$package_pin"
}
foreach port_name {camera_scl camera_sda} {
    if {![get_property PULLUP [get_ports $port_name]]} {
        error "Historical GPIO pullup missing: $port_name"
    }
}
file mkdir $report_dir
report_drc -file [file join $report_dir drc_package.rpt]
set errors [get_drc_violations -quiet -filter {SEVERITY == Error}]
if {[llength $errors] != 0} {
    error "GPIO camera DRC errors: $errors"
}
report_timing_summary -delay_type min_max -report_unconstrained -file [file join $report_dir timing_package.rpt]
foreach delay_type {max min} {
    set paths [get_timing_paths -delay_type $delay_type -max_paths 1 -nworst 1]
    if {[llength $paths] == 0 || [get_property SLACK [lindex $paths 0]] < 0} {
        error "GPIO camera $delay_type timing gate failed"
    }
    puts "CAMERA_ID_GPIO_SLACK_${delay_type}=[get_property SLACK [lindex $paths 0]]"
}
file mkdir $output_dir
write_bitstream -force [file join $output_dir ${project_name}.bit]
file copy -force $hwh_source [file join $output_dir ${project_name}.hwh]
puts "CAMERA_ID_GPIO_PACKAGE_STATUS=PASS"
close_design