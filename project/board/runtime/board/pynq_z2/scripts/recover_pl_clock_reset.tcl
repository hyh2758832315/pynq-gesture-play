if {[catch {set channel [connect -url tcp:127.0.0.1:3121]} message]} {
    puts "PYNQ_PL_RECOVERY_CONNECT_ERROR=$message"
    exit 2
}

targets -set -filter {name == "APU"}
set clock_before [mrd -force 0xF8000170]
set reset_before [mrd -force 0xF8000240]
set shifter_before [mrd -force 0xF8000900]
puts "PYNQ_PL_RECOVERY_CLOCK_BEFORE=$clock_before"
puts "PYNQ_PL_RECOVERY_RESET_BEFORE=$reset_before"
puts "PYNQ_PL_RECOVERY_SHIFTER_BEFORE=$shifter_before"

if {![string match "*00200500*" $clock_before]} {
    error "Unexpected FPGA0_CLK_CTRL before recovery"
}
if {![string match "*0000000F*" $reset_before] &&
    ![string match "*00000000*" $reset_before]} {
    error "Unexpected FPGA_RST_CTRL before recovery"
}
if {![string match "*0000000A*" $shifter_before] &&
    ![string match "*0000000F*" $shifter_before]} {
    error "Unexpected LVL_SHFTR_EN before recovery"
}

mwr -force 0xF8000008 0x0000DF0D
mwr -force 0xF8000900 0x0000000F
mwr -force 0xF8000240 0x00000000
mwr -force 0xF8000004 0x0000767B

set clock_after [mrd -force 0xF8000170]
set reset_after [mrd -force 0xF8000240]
set shifter_after [mrd -force 0xF8000900]
puts "PYNQ_PL_RECOVERY_CLOCK_AFTER=$clock_after"
puts "PYNQ_PL_RECOVERY_RESET_AFTER=$reset_after"
puts "PYNQ_PL_RECOVERY_SHIFTER_AFTER=$shifter_after"

if {![string match "*00200500*" $clock_after] ||
    ![string match "*00000000*" $reset_after] ||
    ![string match "*0000000F*" $shifter_after]} {
    error "PL clock/reset recovery readback mismatch"
}

disconnect
puts "PYNQ_PL_RECOVERY_STATUS=PASS"
