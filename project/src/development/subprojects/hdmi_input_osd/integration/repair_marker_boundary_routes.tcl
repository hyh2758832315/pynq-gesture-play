# Owned marker session after documented second routing attempt, no board IO.
# Run source -notrace .../integration/repair_marker_boundary_routes.tcl.
# Outputs failed-route-r02 with snapshot and exactly five diagnosed blocker nets.
# Next: route_design -directive Explore; require no unrouted/error/critical and full STA.
set mvout E:/projects/fpga/voice-view-game/build/hosd/marker-visibility-r02/failed-route-r02
if {[file exists $mvout]} {error {preserve second route failure}}
file mkdir $mvout
report_route_status -file $mvout/route.rpt
report_timing_summary -delay_type min_max -file $mvout/timing.rpt
write_checkpoint $mvout/failed.dcp
set names [list \
    {c6v_i/core/inst/core/command_upload/upload_sink/active_crc32_reg[7]_0} \
    {c6v_i/core/inst/packet_router/demux/pending_crc32[22]_i_8_n_0} \
    {c6v_i/core/inst/core/renderer/tile_layer/active_tiles_per_row[10]} \
    {c6v_i/core/inst/core/renderer/tile_layer/active_tile_descriptor_reg_n_0_[15]} \
    {c6v_i/skin_hp3_smc/inst/s01_entry_pipeline/s01_si_converter/inst/converter.low_area_converter.low_area_wrap_inst/m_axi_wstrb[0]}]
set nets {}
foreach name $names {
    set net [get_nets -hier -filter [format {NAME == "%s"} $name]]
    if {[llength $net]!=1 || [get_property TYPE $net] ne {SIGNAL}} {error "wrong blocker identity: $name"}
    lappend nets $net
}
set fp [open $mvout/blockers.tcldict {WRONLY CREAT EXCL}];puts $fp $names;close $fp
set_property IS_ROUTE_FIXED false $nets
reset_property FIXED_ROUTE $nets
route_design -unroute -nets $nets
puts MARKER_FIVE_DIAGNOSED_BLOCKER_ROUTES_RELEASED
