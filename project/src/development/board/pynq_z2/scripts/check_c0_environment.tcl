set part_name xc7z020clg400-1
set ps_vlnv xilinx.com:ip:processing_system7:5.5

set part [get_parts -quiet $part_name]
if {[llength $part] == 1} {
    create_project -in_memory -part $part_name
}
set ps_ip [get_ipdefs -quiet $ps_vlnv]
set board_parts [get_board_parts -quiet *pynq*z2*]

puts "C0_PART=$part_name"
puts "C0_PART_AVAILABLE=[expr {[llength $part] == 1}]"
puts "C0_PS_IP=$ps_vlnv"
puts "C0_PS_IP_AVAILABLE=[expr {[llength $ps_ip] == 1}]"
puts "C0_PYNQ_Z2_BOARD_PARTS=$board_parts"

if {[llength $part] != 1} {
    error "Required PYNQ-Z2 part is unavailable"
}
if {[llength $ps_ip] != 1} {
    error "Required Zynq-7000 processing_system7 IP is unavailable"
}