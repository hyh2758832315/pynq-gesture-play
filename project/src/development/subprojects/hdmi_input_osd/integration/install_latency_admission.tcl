# PYNQ-Z2 xc7z020clg400-1 / Vivado 2026.1, owned C0E project session only.
# Run: source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/install_latency_admission.tcl
# Output: build/hosd/c0e/admission-r01 immutable input snapshots, explicit parent
# reference DCP, BD snapshots and independent synth_admission_r01/impl_admission_r01.
# Next: launch_runs synth_admission_r01 -jobs 8; then separately wait_on_run.
# After synthesis, independently implement and audit all timing/CDC/DRC; no bit or board action here.
if {[file normalize [get_property DIRECTORY [current_project]]] ne {E:/vvl/c0e}} {error {wrong admission project}}
if {[get_property PART [current_project]] ne {xc7z020clg400-1} || [version -short] ne {2026.1}} {error {wrong admission target/tool}}
set adrepo {E:/projects/fpga/voice-view-game}
set adhere $adrepo/subprojects/hdmi_input_osd/integration
set adsrc $adrepo/subprojects/hdmi_input_osd/latency_rtl/admission_r01
set adout $adrepo/build/hosd/c0e/admission-r01
if {[file exists $adout] || [llength [get_runs -quiet synth_admission_r01]] || [llength [get_runs -quiet impl_admission_r01]]} {error {preserve prior admission run}}
# This performs no project mutation and fails closed while any simulation is pending.
set adgate [exec $adrepo/.venv/Scripts/python.exe -B $adhere/verify_latency_admission_gates.py]
if {$adgate ne {ADMISSION_OFFLINE_GATES_PASS}} {error {offline admission gates not passed}}
current_bd_design [get_bd_designs c6v]
if {[get_property CONFIG.CONST_VAL [get_bd_cells build_id_constant]] ne {0xC0060E00}} {error {wrong build identity}}
if {[ipcfg::audit_requirements] ne {REQ:OK 23/23}} {error {requirements differ before admission change}}
foreach name {vision_source_admission.sv vision_capture_lifecycle.sv} {
    if {[llength [get_files -quiet E:/vvl/c0e/latency-r02/rtl/$name]]!=1 ||
        [llength [get_files -quiet $adsrc/$name]]} {error "unexpected source binding: $name"}
}
if {[llength [get_files -all -quiet *vision_release_credit_cdc.sv]]} {error {release credit CDC already present}}
file mkdir $adout
file mkdir $adout/source
file copy [info script] $adout/install_latency_admission.tcl
file copy E:/vvl/c0e/c6_latency.xpr $adout/project_before.xpr
file copy $adhere/postopt_latency_admission.tcl $adout/postopt_latency_admission.tcl
file copy $adrepo/build/hosd/c0d/postopt_osd.tcl $adout/inherited_postopt_osd.tcl
file copy $adrepo/build/hosd/c0d/postopt_parent.tcl $adout/inherited_postopt_parent.tcl
file copy $adrepo/build/hosd/c0d/osd_cdc.tcl $adout/inherited_osd_cdc.tcl
proc admission_snapshot_map {path replacements} {
    set stream [open $path r];set contents [read $stream];close $stream
    set contents [string map $replacements $contents]
    set stream [open $path w];puts -nonewline $stream $contents;close $stream
}
admission_snapshot_map $adout/postopt_latency_admission.tcl [list $adrepo/build/hosd/c0d/postopt_osd.tcl $adout/inherited_postopt_osd.tcl]
admission_snapshot_map $adout/inherited_postopt_osd.tcl [list $adrepo/build/hosd/c0d/postopt_parent.tcl $adout/inherited_postopt_parent.tcl $adrepo/build/hosd/c0d/osd_cdc.tcl $adout/inherited_osd_cdc.tcl]
exec $adrepo/.venv/Scripts/python.exe -B $adhere/verify_latency_admission_gates.py --output $adout/offline-gates.json
write_bd_tcl $adout/bd_before.tcl
foreach name {vision_source_admission.sv vision_capture_lifecycle.sv vision_release_credit_cdc.sv} {
    file copy $adsrc/$name $adout/source/$name
}
foreach name {vision_source_admission.sv vision_capture_lifecycle.sv} {
    file copy E:/vvl/c0e/latency-r02/rtl/$name $adout/${name}.before
    remove_files [get_files E:/vvl/c0e/latency-r02/rtl/$name]
}
# Bind the gate-checked snapshot, not a mutable work file that could change mid-run.
add_files -norecurse [glob $adout/source/*.sv]
update_compile_order -fileset sources_1
update_module_reference [get_ips c6v_capture_lifecycle_0]
validate_bd_design
if {[ipcfg::audit_requirements] ne {REQ:OK 23/23}} {error {requirements changed after admission installation}}
save_bd_design
write_bd_tcl $adout/bd_after.tcl
report_ip_status -file $adout/ip_status.rpt
create_run synth_admission_r01 -flow [get_property FLOW [get_runs synth_1]] -strategy [get_property STRATEGY [get_runs synth_1]] -constrset constrs_1
create_run impl_admission_r01 -parent_run synth_admission_r01 -flow [get_property FLOW [get_runs impl_1]] -strategy [get_property STRATEGY [get_runs impl_1]] -constrset constrs_1
add_files -fileset utils_1 -norecurse [list $adout/postopt_latency_admission.tcl $adout/inherited_postopt_osd.tcl $adout/inherited_postopt_parent.tcl $adout/inherited_osd_cdc.tcl]
# Never inherit the historical impl_prewarm_r01 empty hook or its failed routed DCP.
set_property STEPS.OPT_DESIGN.TCL.POST $adout/postopt_latency_admission.tcl [get_runs impl_admission_r01]
set_property STEPS.PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_admission_r01]
set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_admission_r01]
set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_admission_r01]
file copy $adrepo/build/hosd/c0e/prewarm-r01/signoff/candidate.dcp $adout/incremental_reference.dcp
add_files -fileset utils_1 -norecurse $adout/incremental_reference.dcp
set_property AUTO_INCREMENTAL_CHECKPOINT 0 [get_runs impl_admission_r01]
set_property INCREMENTAL_CHECKPOINT $adout/incremental_reference.dcp [get_runs impl_admission_r01]
if {[get_property STEPS.OPT_DESIGN.TCL.POST [get_runs impl_admission_r01]] ne "$adout/postopt_latency_admission.tcl"} {error {new admission hook binding failed}}
set adhook_hashes [dict create]
foreach adhook_name {postopt_latency_admission.tcl inherited_postopt_osd.tcl inherited_postopt_parent.tcl inherited_osd_cdc.tcl} {
    dict set adhook_hashes $adhook_name [exec $adrepo/.venv/Scripts/python.exe -B -c {import hashlib,sys; print(hashlib.sha256(open(sys.argv[1],'rb').read()).hexdigest())} $adout/$adhook_name]
}
set adfile [open $adout/install-receipt.tcldict {WRONLY CREAT EXCL}]
puts $adfile [dict create status C0E_ADMISSION_SIM_GATED_SOURCE_INSTALLED requirements [ipcfg::audit_requirements] synth_run synth_admission_r01 impl_run impl_admission_r01 hook_sha256 $adhook_hashes board_access false candidate_timing_verified false]
close $adfile
puts C0E_ADMISSION_SOURCE_INSTALLED_NEW_RUNS_READY
