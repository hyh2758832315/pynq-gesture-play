# Owned71000 actual C0E project; bit was generated from reviewed non-project6044 DCP.
# source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/export_latency_platform.tcl
# Output: c6v_candidate.hwh/.xsa beside reviewed bit. No new implementation or board operation.
# Next: byte-compare XSA bit/HWH members and verifier topology before packaging.
if {[file normalize [get_property DIRECTORY [current_project]]] ne {E:/vvl/c0e}} {error {wrong project}}
if {[get_property CONFIG.CONST_VAL [get_bd_cells build_id_constant]] ne {0xC0060E00}} {error {wrong identity}}
set platform_synth_run synth_1
set platform_impl_run impl_1
if {[info exists ::latency_export_synth_run]} {set platform_synth_run $::latency_export_synth_run}
if {[info exists ::latency_export_impl_run]} {set platform_impl_run $::latency_export_impl_run}
if {[ipcfg::audit_requirements] ne {REQ:OK 23/23} || [get_property NEEDS_REFRESH [get_runs $platform_synth_run]]} {error {configuration/source drift}}
set platform_out {E:/projects/fpga/voice-view-game/build/hosd/c0e/postroute-r05/signoff}
if {[info exists ::latency_export_root]} {set platform_out $::latency_export_root/signoff}
set run_dir [get_property DIRECTORY [get_runs $platform_impl_run]]
if {![file isfile $platform_out/c6v_candidate.bit] || [file exists $run_dir/c6v_wrapper.bit]} {error {unexpected bit stage}}
foreach name {c6v_candidate.hwh c6v_candidate.xsa} {
    if {[file exists $platform_out/$name]} {error {preserve exported artifact}}
}
file copy $platform_out/c6v_candidate.bit $run_dir/c6v_wrapper.bit
file copy E:/vvl/c0e/c6_latency.gen/sources_1/bd/c6v/hw_handoff/c6v.hwh $platform_out/c6v_candidate.hwh
current_run -synthesis [get_runs $platform_synth_run]
current_run -implementation [get_runs $platform_impl_run]
write_hw_platform -fixed -include_bit $platform_out/c6v_candidate.xsa
puts C0E_PLATFORM_EXPORTED_REQUIRES_BYTE_PAIR_CHECK
