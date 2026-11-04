# PYNQ-Z2 xc7z020clg400-1 / Vivado 2026.1, owned C0E project session only.
# Run: source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/install_latency_prewarm.tcl
# Outputs: build/hosd/c0e/prewarm-r01 source/BD snapshots and new synth/impl_prewarm_r01 runs.
# Next: launch_runs synth_prewarm_r01 -jobs 8; then separately wait_on_run synth_prewarm_r01.
# Simulation-gated source installation only; no bit generation or board operation.
if {[file normalize [get_property DIRECTORY [current_project]]] ne {E:/vvl/c0e}} {error {wrong project}}
if {[get_property PART [current_project]] ne {xc7z020clg400-1}} {error {wrong part}}
set pwrepo {E:/projects/fpga/voice-view-game}
set pwout $pwrepo/build/hosd/c0e/prewarm-r01
set pwold {E:/vvl/c0e/latency-r02/rtl/axis_binary_dilate9.sv}
set pwnew $pwrepo/subprojects/hdmi_input_osd/latency_rtl/axis_binary_dilate9.sv
set pwsha c2a60d3490c616762bd76493087ea593fa550a251a170372feb4a5f1f06771a6
proc prewarm_text {path} {set f [open $path r]; set t [read $f]; close $f; return $t}
if {[file exists $pwout] || [llength [get_runs -quiet synth_prewarm_r01]] || [llength [get_runs -quiet impl_prewarm_r01]]} {error {preserve existing prewarm build}}
set pwnumeric [prewarm_text $pwrepo/build/hosd/c0e-prewarm-numeric-r01/receipt.json]
set pwab [prewarm_text $pwrepo/subprojects/hdmi_input_osd/integration/evidence/latency-prewarm-ab-r01.json]
if {![regexp {"status": "BGR_FRONTEND_AND_CAPTURE_NUMERIC_PASS"} $pwnumeric] || [string first $pwsha $pwnumeric]<0} {error {numeric gate not passed for this source}}
if {![regexp {"status": "VIDEO_PREFIX_CAUSAL_AB_PASS"} $pwab] || [string first $pwsha $pwab]<0} {error {causal A/B gate not passed}}
set pwactual [exec $pwrepo/.venv/Scripts/python.exe -B -c {import hashlib,sys; print(hashlib.sha256(open(sys.argv[1],'rb').read()).hexdigest())} $pwnew]
if {$pwactual ne $pwsha} {error {source changed after verification}}
if {[llength [get_files -quiet $pwold]]!=1 || [llength [get_files -quiet $pwnew]]} {error {unexpected source binding}}
current_bd_design [get_bd_designs c6v]
if {[get_property CONFIG.CONST_VAL [get_bd_cells build_id_constant]] ne {0xC0060E00}} {error {wrong build identity}}
if {[ipcfg::audit_requirements] ne {REQ:OK 23/23}} {error {requirements differ}}
file mkdir $pwout
file copy [info script] $pwout/install_latency_prewarm.tcl
file copy E:/vvl/c0e/c6_latency.xpr $pwout/project_before.xpr
file copy $pwold $pwout/axis_binary_dilate9_before.sv
file copy $pwnew $pwout/axis_binary_dilate9_after.sv
write_bd_tcl $pwout/bd_before.tcl
remove_files [get_files $pwold]
add_files -norecurse $pwnew
update_compile_order -fileset sources_1
update_module_reference [get_ips c6v_dual_mask_capture_0]
validate_bd_design
if {[llength [get_files -quiet $pwold]] || [llength [get_files -quiet $pwnew]]!=1} {error {source replacement failed}}
if {[ipcfg::audit_requirements] ne {REQ:OK 23/23}} {error {requirements changed}}
save_bd_design
write_bd_tcl $pwout/bd_after.tcl
report_ip_status -file $pwout/ip_status.rpt
create_run synth_prewarm_r01 -flow [get_property FLOW [get_runs synth_1]] -strategy [get_property STRATEGY [get_runs synth_1]] -constrset constrs_1
create_run impl_prewarm_r01 -parent_run synth_prewarm_r01 -flow [get_property FLOW [get_runs impl_1]] -strategy [get_property STRATEGY [get_runs impl_1]] -constrset constrs_1
set pwhook [get_property STEPS.OPT_DESIGN.TCL.POST [get_runs impl_1]]
if {![file isfile $pwhook]} {error {parent post-opt hook missing}}
set_property STEPS.OPT_DESIGN.TCL.POST $pwhook [get_runs impl_prewarm_r01]
set_property STEPS.PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_prewarm_r01]
set_property STEPS.PHYS_OPT_DESIGN.ARGS.DIRECTIVE AggressiveExplore [get_runs impl_prewarm_r01]
set_property STEPS.ROUTE_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_prewarm_r01]
set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_prewarm_r01]
set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_prewarm_r01]
set pwf [open $pwout/install-receipt.tcldict {WRONLY CREAT EXCL}]
puts $pwf [dict create status C0E_PREWARM_SIM_GATED_SOURCE_INSTALLED sha256 $pwsha requirements [ipcfg::audit_requirements] synth_run synth_prewarm_r01 impl_run impl_prewarm_r01 board_access false full_frame_rate_test_pending true]
close $pwf
puts C0E_PREWARM_SOURCE_INSTALLED_NEW_RUNS_READY
