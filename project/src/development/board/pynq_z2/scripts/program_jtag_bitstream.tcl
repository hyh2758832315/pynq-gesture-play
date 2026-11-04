if {![info exists ::env(BITSTREAM)] || $::env(BITSTREAM) eq ""} {
    error "BITSTREAM environment variable is required"
}
set bitstream [file normalize $::env(BITSTREAM)]
if {![file exists $bitstream]} {
    error "Bitstream not found: $bitstream"
}

open_hw_manager
connect_hw_server -allow_non_jtag
open_hw_target

set devices [get_hw_devices -filter {PART == "xc7z020"}]
if {[llength $devices] != 1} {
    error "Expected one xc7z020 JTAG device, found [llength $devices]"
}
set device [lindex $devices 0]
puts "PYNQ_JTAG_PROGRAM_DEVICE=$device"
puts "PYNQ_JTAG_PROGRAM_BITSTREAM=$bitstream"
set_property PROGRAM.FILE $bitstream $device
program_hw_devices $device
refresh_hw_device $device
puts "PYNQ_JTAG_PROGRAM_STATUS=PASS"

close_hw_target
disconnect_hw_server
close_hw_manager
