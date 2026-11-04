# Local marker session only; preserve third failed route, release diagnosed GND
# aliases and one exact demosaic signal. Run with source -notrace <this file>.
# Outputs failed-route-r03 snapshots/blockers. Next: route_design then full STA.
set mvout E:/projects/fpga/voice-view-game/build/hosd/marker-visibility-r02/failed-route-r03
if {[file exists $mvout]} {error {preserve third route failure}}
if {[version -short] ne {2026.1} || [get_property PART [current_design]] ne {xc7z020clg400-1}} {error {wrong tool/part}}
file mkdir $mvout
report_route_status -file $mvout/route.rpt
report_timing_summary -delay_type min_max -file $mvout/timing.rpt
write_checkpoint $mvout/failed.dcp
set grounds [get_nets -of_objects [get_pins -of_objects [get_cells -hier -filter {REF_NAME == GND}] -filter {DIRECTION == OUT}]]
if {![llength $grounds]} {error {missing GND alias inventory}}
set names {}
foreach net $grounds {
    if {[get_property TYPE $net] ne {GROUND}} {error "non-ground constant: $net"}
    lappend names [get_property NAME $net]
}
set target {c6v_i/demosaic/inst/Debayer_U0/width_val8_c4_U/U_c6v_demosaic_0_fifo_w12_d2_S_ShiftReg/SRL_SIG_reg[0]_4[11]}
set signal [get_nets -hier -filter [format {NAME == "%s"} $target]]
if {[llength $signal]!=1 || [get_property TYPE $signal] ne {SIGNAL}} {error {wrong demosaic blocker}}
set fp [open $mvout/blockers.tcldict {WRONLY CREAT EXCL}]
puts $fp [list ground_count [llength $grounds] ground_aliases $names signal $target]
close $fp
set nets [concat $grounds $signal]
set_property IS_ROUTE_FIXED false $nets
reset_property FIXED_ROUTE $nets
route_design -unroute -nets $nets
puts MARKER_GROUND_AND_EXACT_DEMOSAIC_BLOCKER_RELEASED
