if {[catch {set channel [connect -url tcp:127.0.0.1:3121]} message]} {
    puts "PYNQ_SYSTEM_RESET_CONNECT_ERROR=$message"
    exit 2
}

targets -set -filter {name =~ "ARM Cortex-A9 MPCore #0"}
puts "PYNQ_SYSTEM_RESET_TARGET=[targets -target-properties]"
rst -system
puts "PYNQ_SYSTEM_RESET_STATUS=PASS"
disconnect
