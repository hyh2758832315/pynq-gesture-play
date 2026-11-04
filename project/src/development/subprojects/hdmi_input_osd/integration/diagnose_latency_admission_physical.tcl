# PYNQ-Z2 / Vivado 2026.1; local evidence only, no design mutation or board IO.
# Run: source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/diagnose_latency_admission_physical.tcl
# Output: admission-r01/diagnostic-r01 clock topology for parent/opt/placed/final and final QoR RQS.
# Next: review exact differences before selecting a physical repair experiment.
set adrepo E:/projects/fpga/voice-view-game
set adout $adrepo/build/hosd/c0e/admission-r01/diagnostic-r01
if {[file exists $adout]} {error {preserve diagnostic evidence}}
file mkdir $adout
file copy [info script] $adout/diagnose_latency_admission_physical.tcl
foreach {adname addcp} [list parent $adrepo/build/hosd/c0e/prewarm-r01/signoff/candidate.dcp opt $adrepo/build/hosd/c0e/admission-r01/opt-review-r02/candidate.dcp placed E:/vvl/c0e/c6_latency.runs/impl_admission_r01/c6v_wrapper_placed.dcp final $adrepo/build/hosd/c0e/admission-r01/physical-r01/signoff/candidate.dcp] {
    open_checkpoint $addcp
    set adsha [exec $adrepo/.venv/Scripts/python.exe -B -c {import hashlib,sys; print(hashlib.sha256(open(sys.argv[1],'rb').read()).hexdigest())} $addcp]
    set adfp [open $adout/${adname}_clock_topology.tcldict {WRONLY CREAT EXCL}]
    puts $adfp [list checkpoint $addcp sha256 $adsha]
    foreach adcell [lsort [get_cells -hier -filter {NAME =~ *buffer_fclk_clk_0* && REF_NAME =~ BUFG*}]] {
        set adin [get_nets -segments -of_objects [get_pins $adcell/I]]
        set adon [get_nets -segments -of_objects [get_pins $adcell/O]]
        puts $adfp [list cell $adcell ref [get_property REF_NAME $adcell] loc [get_property LOC $adcell] input_drivers [get_pins -leaf -of_objects $adin -filter {DIRECTION == OUT}] output_loads [llength [get_pins -leaf -of_objects $adon -filter {DIRECTION == IN}]]]
    }
    close $adfp
    if {$adname eq {final}} {
        report_qor_suggestions -max_paths 100 -file $adout/qor_suggestions.rpt
        write_qor_suggestions -tcl_output_dir $adout/qor_tcl $adout/qor.rqs
        set adfp [open $adout/qor_properties.txt {WRONLY CREAT EXCL}]
        foreach adq [get_qor_suggestions] {
            puts $adfp "SUGGESTION $adq"
            foreach adprop [list_property $adq] {puts $adfp [list $adprop [get_property $adprop $adq]]}
        }
        close $adfp
    }
    close_design
}
puts C0E_ADMISSION_PHYSICAL_DIAGNOSTIC_COLLECTED
