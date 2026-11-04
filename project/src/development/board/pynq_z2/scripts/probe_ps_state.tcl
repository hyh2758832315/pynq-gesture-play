if {[catch {set channel [connect -url tcp:127.0.0.1:3121]} message]} {
    puts "PYNQ_PS_PROBE_CONNECT_ERROR=$message"
    exit 2
}

puts "PYNQ_PS_PROBE_CHANNEL=$channel"
puts "PYNQ_PS_PROBE_TARGETS_BEGIN"
puts [targets]
puts "PYNQ_PS_PROBE_TARGETS_END"

targets -set -filter {name == "APU"}
puts "PYNQ_PS_FPGA0_CLK_CTRL_BEGIN"
puts [mrd -force 0xF8000170]
puts "PYNQ_PS_FPGA0_CLK_CTRL_END"
puts "PYNQ_PS_FPGA_RST_CTRL_BEGIN"
puts [mrd -force 0xF8000240]
puts "PYNQ_PS_FPGA_RST_CTRL_END"
puts "PYNQ_PS_LVL_SHFTR_EN_BEGIN"
puts [mrd -force 0xF8000900]
puts "PYNQ_PS_LVL_SHFTR_EN_END"

disconnect
puts "PYNQ_PS_PROBE_STATUS=PASS"
