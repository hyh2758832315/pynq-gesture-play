open_hw_manager
connect_hw_server -allow_non_jtag
open_hw_target

set devices [get_hw_devices]
if {[llength $devices] == 0} {
    error "No JTAG devices found"
}

puts "PYNQ_JTAG_DEVICE_COUNT=[llength $devices]"
foreach device $devices {
    puts "PYNQ_JTAG_DEVICE=$device"
    puts "PYNQ_JTAG_PART=[get_property PART $device]"
    puts "PYNQ_JTAG_PROGRAMMED=[get_property PROGRAM.HW_CFGMEM $device]"
}
puts "PYNQ_JTAG_PROBE_STATUS=PASS"

close_hw_target
disconnect_hw_server
close_hw_manager
