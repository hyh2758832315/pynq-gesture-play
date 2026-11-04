# PYNQ-Z2 xc7z020clg400-1 / Vivado 2026.1, read-only checkpoint inventory.
# Run from the repository root:
# D:/Xilinx/Vivado/2026.1/Vivado/bin/vivado.bat -mode batch -nojournal -source subprojects/hdmi_input_osd/osd_reset_repair_r01/tools/inventory_axi_debug.tcl -tclargs build/hosd/osd-reset-r01/full-r01/assembled.dcp build/hosd/osd-reset-r01/axi-debug-inventory-r01.txt
# Output: exact AXI/read/reset pin and net identities plus checkpoint state.
# Next: use only verified identities to prepare a separate incremental debug build.
if {$argc != 2} {error {expected checkpoint and fresh output file}}
set checkpoint [file normalize [lindex $argv 0]]
set output [file normalize [lindex $argv 1]]
if {[version -short] ne {2026.1} || ![file isfile $checkpoint] || [file exists $output]} {
    error {tool, checkpoint or output mismatch}
}
open_checkpoint $checkpoint
if {[get_property PART [current_design]] ne {xc7z020clg400-1}} {error {wrong target part}}
set fp [open $output {WRONLY CREAT EXCL}]
puts $fp [list checkpoint $checkpoint]
puts $fp [list part [get_property PART [current_design]]]
foreach property {DESIGN_MODE IS_IMPLEMENTED IS_PLACED IS_ROUTED} {
    if {![catch {get_property $property [current_design]} value]} {
        puts $fp [list property $property $value]
    }
}
foreach scope {
    c6v_i/vision_gp0_slice
    c6v_i/gp0_smc
    c6v_i/vision_control_smc
    c6v_i/input_osd_0
} {
    puts $fp [list scope $scope]
    set matches [get_pins -quiet $scope/*]
    foreach pin $matches {
        set name [get_property NAME $pin]
        if {![regexp -nocase {(araddr|arvalid|arready|rvalid|rready|rresp|rdata|aresetn|aclk)} $name]} {continue}
        set nets [get_nets -quiet -of_objects $pin]
        set net_names {}
        foreach net $nets {lappend net_names [get_property NAME $net]}
        puts $fp [list pin $name direction [get_property DIRECTION $pin] nets $net_names]
    }
}
close $fp
puts [list AXI_DEBUG_INVENTORY $output]
