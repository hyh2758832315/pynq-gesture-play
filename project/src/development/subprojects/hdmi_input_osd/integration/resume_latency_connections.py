"""Generate a connection-only continuation for the proven partial C0E state.

Run: .venv/Scripts/python.exe -B subprojects/hdmi_input_osd/integration/resume_latency_connections.py
Output: evidence/latency-connect-r03.tcl (exclusive), no Vivado/board action.
Next: source this script in the existing owned Vivado C0E session, then validate.
"""
import hashlib
import json
from pathlib import Path

from prepare_latency import CELLS, quote

HERE=Path(__file__).resolve().parent
INPUTS=Path('E:/vvl/c0e/latency-r02/inputs.json')


def generate():
    saved=json.loads(INPUTS.read_text(encoding='utf-8'))
    topology=saved['topology']
    lines=[
        '# Connection continuation only; no configuration replay or board operations.',
        'if {[file normalize [get_property DIRECTORY [current_project]]] ne {E:/vvl/c0e}} {error {wrong candidate}}',
        'if {[get_property CONFIG.CONST_VAL [get_bd_cells build_id_constant]] ne {0xC0060E00}} {error {wrong identity}}',
        'if {[get_property CONFIG.PCW_USE_S_AXI_GP0 [get_bd_cells ps7_0]] ne {0}} {error {parent boundary changed}}',
        'if {[ipcfg::audit_requirements] ne {REQ:OK 23/23}} {error {configuration changed}}',
        'if {![info exists latency_addresses] || ![dict size $latency_addresses]} {error {original addresses missing}}',
        'source -notrace '+quote((HERE/'scalar_connections.tcl').as_posix()),
        'set latency_groups {}',
    ]
    for name,pins in topology['interface_nets']:
        values=' '.join(quote(pin) for pin in pins)
        lines += [
            'set pins [get_bd_intf_pins [list '+values+']]',
            'if {[llength $pins]!='+str(len(pins))+'} {error '+quote('missing interface '+name)+'}',
            'set nets [lsort -unique [get_bd_intf_nets -quiet -of_objects $pins]]',
            'if {[llength $nets]!=1 || [llength [get_bd_intf_pins -of_objects $nets]]!='+str(len(pins))+'} {error '+quote('interface stage differs '+name)+'}',
        ]
    for name,pins in topology['nets']:
        pins=[pin for pin in pins if pin!='ps7_0/S_AXI_GP0_ACLK']
        lines.append('set pins {}')
        for pin in pins:
            command='get_bd_pins' if '/' in pin else 'get_bd_ports'
            lines += ['set pin ['+command+' -quiet '+quote(pin)+']',
                      'if {[llength $pin]!=1} {error '+quote('missing scalar '+pin)+'}',
                      'lappend pins $pin']
        lines += ['latency_scalar_plan $pins','lappend latency_groups $pins']
    lines += [
        'proc latency_finish_connections {} {',
        '    global latency_groups latency_addresses',
        '    set changed 0; set unchanged 0',
        '    foreach pins $latency_groups {if {[latency_connect_scalar $pins] eq {CONNECTED}} {incr changed} else {incr unchanged}}',
        '    foreach {cell offset} {capture_control 0x413F0000 capture_status 0x41410000} {assign_bd_address -offset $offset -range 0x10000 -target_address_space [get_bd_addr_spaces ps7_0/Data] [get_bd_addr_segs -of_objects [get_bd_intf_pins $cell/s_axi]]}',
        '    assign_bd_address -offset 0x00000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces moments_dma/Data_SG] [get_bd_addr_segs ps7_0/S_AXI_HP3/HP3_DDR_LOWOCM]',
        '    dict for {segment pair} $latency_addresses {if {[list [get_property OFFSET $segment] [get_property RANGE $segment]] ne $pair} {error "retained address changed: $segment"}}',
        '    set xdc {E:/vvl/c0e/latency-r02/rtl/vision_capture_cdc.xdc}',
        '    if {![llength [get_files -quiet $xdc]]} {add_files -fileset constrs_1 -norecurse $xdc}',
        '    set_property USED_IN_SYNTHESIS false [get_files $xdc]',
        '    if {[ipcfg::audit_requirements] ne {REQ:OK 23/23}} {error {final requirements changed}}',
        '    save_bd_design',
        '    write_bd_tcl '+quote((HERE/'evidence/latency-connected-r03.tcl').as_posix()),
        '    return "CONNECTED_NOT_VALIDATED changed=$changed unchanged=$unchanged"',
        '}',
        'set result [ipcfg::capture '+quote((HERE/'evidence/latency-connect-r03.tcldict').as_posix())+' {latency_finish_connections} {CONNECTED_NOT_VALIDATED*}]',
        'puts $result',
        'if {[dict get $result status] ne {OK}} {error {connection capture failed; retain evidence}}',
    ]
    destination=HERE/'evidence/latency-connect-r03.tcl'
    with destination.open('x',encoding='utf-8') as stream: stream.write('\n'.join(lines)+'\n')
    print(json.dumps(dict(output=str(destination),sha256=hashlib.sha256(destination.read_bytes()).hexdigest(),
                         scalar_groups=len(topology['nets']),interfaces=len(topology['interface_nets']),board_operations=False)))


if __name__=='__main__':
    generate()
