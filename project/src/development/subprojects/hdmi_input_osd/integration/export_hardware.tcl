# Source ONLY after g13-signoff.json review in the same optimized design.
# Output: signoff-r02/c6v_candidate.{bit,hwh,xsa}; never downloads hardware.
# Next: inspect XSA member identities, exact HWH/bit pairing, child preflight.
set dest E:/projects/fpga/voice-view-game/build/hosd/c0d/signoff-r02
if {[get_property SLACK [get_timing_paths -delay_type max -max_paths 1]] < 0 ||
    [get_property SLACK [get_timing_paths -delay_type min -max_paths 1]] < 0} {error "timing gate failed"}
if {![file exists $dest/candidate.dcp]} {error "reviewed checkpoint missing"}
foreach ext {bit hwh xsa} {
    if {[file exists $dest/c6v_candidate.$ext]} {error "preserve existing export"}
}
write_bitstream $dest/c6v_candidate.bit
# UG835 project-mode XSA reads the implementation run's expected bit path.
# Populate that path with the exact reviewed optimized bit, never launch the
# old negative-timing run's write_bitstream step.
set run [get_property DIRECTORY [get_runs impl_1]]
if {[file exists $run/c6v_wrapper.bit]} {error "unexpected existing run bit"}
file copy $dest/c6v_candidate.bit $run/c6v_wrapper.bit
file copy E:/projects/fpga/voice-view-game/build/hosd/c0d/c6_osd.gen/sources_1/bd/c6v/hw_handoff/c6v.hwh $dest/c6v_candidate.hwh
write_hw_platform -fixed -include_bit $dest/c6v_candidate.xsa
puts OSD_OPTIMIZED_HARDWARE_EXPORTED_REQUIRES_PAIR_VERIFICATION
