set volume_build [get_property DIRECTORY [current_project]]
set volume_segments [get_bd_addr_segs -of_objects [get_bd_intf_pins voice_volume_0/s_axi]]
if {[llength $volume_segments] != 1} {error "expected one VOL1 address segment, got $volume_segments"}
assign_bd_address -offset 0x43C00000 -range 4K -target_address_space [get_bd_addr_spaces ps7_0/Data] $volume_segments
validate_bd_design
foreach {parameter expected} {C_EXT_RESET_HIGH 0 C_AUX_RESET_HIGH 1} {
	set actual [get_property CONFIG.$parameter [get_bd_cells control_reset]]
	if {$actual != $expected} {error "VOLUME_RESET_POLARITY_FAILED $parameter wanted=$expected got=$actual"}
}
foreach {source destination} {
	constant_low/dout control_reset/aux_reset_in
	ps7_0/FCLK_RESET0_N control_reset/ext_reset_in
	control_reset/peripheral_aresetn control_axi/aresetn
	control_reset/peripheral_aresetn voice_volume_0/s_axi_aresetn
} {
	set source_net [get_bd_nets -of_objects [get_bd_pins $source]]
	set destination_net [get_bd_nets -of_objects [get_bd_pins $destination]]
	if {[llength $source_net] != 1 || $source_net ne $destination_net} {
		error "VOLUME_RESET_CONNECTION_FAILED $source -> $destination"
	}
}
puts VOLUME_RESET_CONTRACT_PASS
save_bd_design
set volume_bd [get_files */volume.bd]
generate_target all $volume_bd
set volume_wrapper [make_wrapper -files $volume_bd -top]
add_files -norecurse $volume_wrapper
set_property top volume_wrapper [get_filesets sources_1]
set_property STEPS.SYNTH_DESIGN.ARGS.FLATTEN_HIERARCHY rebuilt [get_runs synth_1]
update_compile_order -fileset sources_1
write_bd_tcl [file join $volume_build recreate_volume_bd.tcl]
puts "VOLUME_PROJECT_READY build=$volume_build part=[get_property PART [current_project]] cells=[llength [get_bd_cells]]"