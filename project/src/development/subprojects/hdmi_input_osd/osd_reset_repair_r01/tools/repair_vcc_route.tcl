# Vivado 2026.1 / PYNQ-Z2. Use only after full-r01.log reports Route 35-341
# fixed VCCNet conflicts. Run from workspace root:
# D:/Xilinx/Vivado/2026.1/Vivado/bin/vivado.bat -mode batch -nojournal -source subprojects/hdmi_input_osd/osd_reset_repair_r01/tools/repair_vcc_route.tcl -tclargs build/hosd/osd-reset-r01/full-r01/routed.dcp build/hosd/osd-reset-r01/route-vcc-r01
# Outputs named alias list, routed.dcp and route/timing reports.
# Next: review all routing diagnostics; only run further targeted repairs if named blockers remain.
if {$argc != 2} {error {expected failed checkpoint and fresh output directory}}
set checkpoint [file normalize [lindex $argv 0]]
set out [file normalize [lindex $argv 1]]
if {[version -short] ne {2026.1} || ![file isfile $checkpoint] || [file exists $out]} {error {tool/checkpoint/output mismatch}}
open_checkpoint $checkpoint
if {[get_property PART [current_design]] ne {xc7z020clg400-1}} {error {wrong part}}
set nets [get_nets -of_objects [get_pins -of_objects [get_cells -hier -filter {REF_NAME == VCC}] -filter {DIRECTION == OUT}]]
if {[llength $nets] < 1500} {error {unexpectedly small VCC alias inventory}}
set names {}
foreach net $nets {
    if {[get_property TYPE $net] ne {POWER}} {error "non-POWER net in VCC alias list: $net"}
    lappend names [get_property NAME $net]
}
file mkdir $out
set fp [open $out/vcc_aliases.tcldict {WRONLY CREAT EXCL}]
puts $fp [list count [llength $names] type POWER names $names]
close $fp
set_property IS_ROUTE_FIXED false $nets
reset_property FIXED_ROUTE $nets
route_design -unroute -nets $nets
write_checkpoint $out/unrouted-vcc.dcp
route_design -directive Explore
write_checkpoint $out/routed.dcp
report_route_status -file $out/route.rpt
report_timing_summary -delay_type min_max -report_unconstrained -max_paths 20 -file $out/timing.rpt
puts OSD_RESET_VCC_ROUTE_REVIEW_PENDING
