# Owned new marker session after the documented Route35-341 VCCNet failure.
# Run source -notrace .../integration/repair_marker_constant_route.tcl.
# Output failed-route-r01 DCP/reports and exact property receipt. No board IO.
# Next: route_design -directive Explore, then full signoff.
set mvout E:/projects/fpga/voice-view-game/build/hosd/marker-visibility-r02/failed-route-r01
if {[file exists $mvout]} {error {preserve route failure evidence}}
file mkdir $mvout
report_route_status -file $mvout/route.rpt
write_checkpoint $mvout/failed.dcp
set n [get_nets VCCNet]
if {[llength $n]!=1 || [get_property TYPE $n] ne {POWER}} {error {unexpected constant net}}
set fp [open $mvout/constant_repair.tcldict {WRONLY CREAT EXCL}]
puts $fp [list net [get_property NAME $n] type [get_property TYPE $n] fixed [get_property IS_ROUTE_FIXED $n] fixed_route [get_property FIXED_ROUTE $n]]
close $fp
set_property IS_ROUTE_FIXED false $n
reset_property FIXED_ROUTE $n
route_design -unroute -nets $n
puts MARKER_VCC_ONLY_UNROUTED_RETRY_PENDING
