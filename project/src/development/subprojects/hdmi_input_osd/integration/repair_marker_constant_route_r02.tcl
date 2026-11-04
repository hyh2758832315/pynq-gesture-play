# Continue the same failed-route snapshot; only logical aliases of physical VCC.
# Run source -notrace .../integration/repair_marker_constant_route_r02.tcl.
# Output failed-route-r01/vcc_alias_repair.tcldict. Next: route_design -directive Explore.
set mvout E:/projects/fpga/voice-view-game/build/hosd/marker-visibility-r02/failed-route-r01
set n [get_nets -of_objects [get_pins -of_objects [get_cells -hier -filter {REF_NAME == VCC}] -filter {DIRECTION == OUT}]]
if {[llength $n]!=1993} {error {constant alias inventory changed}}
set names {};foreach net $n {
    if {[get_property TYPE $net] ne {POWER}} {error {non-power net in constant repair}}
    lappend names [get_property NAME $net]
}
set fp [open $mvout/vcc_alias_repair.tcldict {WRONLY CREAT EXCL}]
puts $fp [list type POWER aliases $names count [llength $names]];close $fp
set_property IS_ROUTE_FIXED false $n
reset_property FIXED_ROUTE $n
route_design -unroute -nets $n
puts MARKER_ONLY_POWER_ALIASES_UNFIXED_AND_UNROUTED
