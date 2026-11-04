set script_dir [file dirname [file normalize [info script]]]
set board_dir [file normalize [file join $script_dir ..]]
set output_dir [file join $board_dir output camera_direct_plug_ila]
set bitstream [file join $output_dir camera_direct_plug_ila.bit]
set probes [file join $output_dir camera_direct_plug_ila.ltx]
set mode [expr {[info exists ::env(CAMERA_ILA_MODE)] ? $::env(CAMERA_ILA_MODE) : "preflight"}]
set capture_tag [expr {[info exists ::env(CAMERA_ILA_TAG)] ? $::env(CAMERA_ILA_TAG) : ""}]
if {$mode ni {preflight idle transaction}} {
    error "CAMERA_ILA_MODE must be preflight, idle or transaction"
}
if {$capture_tag ne "" && ![regexp {^[a-zA-Z0-9_-]+$} $capture_tag]} {
    error "CAMERA_ILA_TAG must contain only letters, digits, underscores or hyphens"
}
foreach required_file [list $bitstream $probes] {
    if {![file exists $required_file]} {
        error "Missing diagnostic artifact: $required_file"
    }
}

open_hw_manager
connect_hw_server -allow_non_jtag
open_hw_target
set devices [get_hw_devices -filter {PART == "xc7z020"}]
if {[llength $devices] != 1} {
    error "Expected one xc7z020 JTAG device, found [llength $devices]"
}
set device [lindex $devices 0]
set_property PROBES.FILE $probes $device
if {$mode eq "preflight"} {
    set_property PROGRAM.FILE $bitstream $device
    program_hw_devices $device
    puts "CAMERA_ILA_PROGRAM_STATUS=PASS"
}
refresh_hw_device $device
set ilas [get_hw_ilas -of_objects $device]
if {[llength $ilas] != 1} {
    error "Expected one camera ILA, found [llength $ilas]"
}
set ila [lindex $ilas 0]
puts "CAMERA_ILA_CORE=$ila"
puts "CAMERA_ILA_PROBES=[get_hw_probes -of_objects $ila]"
set_property CONTROL.DATA_DEPTH 16384 $ila
set_property CONTROL.WINDOW_COUNT 1 $ila
set_property CONTROL.TRIGGER_POSITION 128 $ila

if {$mode ne "transaction"} {
    run_hw_ila -trigger_now $ila
} else {
    set data_probes [get_hw_probes -of_objects $ila -filter {NAME =~ *iic_tap_probe*}]
    if {[llength $data_probes] != 1} {
        error "Expected one 6-bit IIC tap probe, found [llength $data_probes]"
    }
    set_property TRIGGER_COMPARE_VALUE {eq6'b1x1xx0} $data_probes
    set_property CONTROL.TRIGGER_CONDITION AND $ila
    run_hw_ila $ila
    puts "CAMERA_ILA_ARMED=PASS"
    flush stdout
    set remote_command "sudo -n timeout 30s env XILINX_XRT=/usr /usr/local/share/pynq-venv/bin/python -u /home/xilinx/voice-view-game/camera-direct-plug/ila/capture_camera_direct_plug.py /home/xilinx/voice-view-game/camera-direct-plug/ila/camera_direct_plug_ila.bit --no-download --first-write-only"
    set remote_failed [catch {exec ssh -o BatchMode=yes -o ConnectTimeout=8 -b 192.168.2.1 pynq-z2 $remote_command 2>@1} remote_output]
    puts "CAMERA_ILA_REMOTE_OUTPUT=$remote_output"
    puts "CAMERA_ILA_REMOTE_FAILED=$remote_failed"
}

wait_on_hw_ila -timeout 0.5 $ila
set samples [upload_hw_ila_data $ila]
set basename [file join $output_dir camera_iic_${mode}${capture_tag}]
write_hw_ila_data -force $basename $samples
write_hw_ila_data -force -csv_file $basename $samples
puts "CAMERA_ILA_CAPTURE=$basename"
if {$mode eq "transaction" && $remote_failed} {
    error "The single OV5640 write failed; ILA samples were saved"
}
puts "CAMERA_ILA_CAPTURE_STATUS=PASS"
close_hw_target
disconnect_hw_server
close_hw_manager