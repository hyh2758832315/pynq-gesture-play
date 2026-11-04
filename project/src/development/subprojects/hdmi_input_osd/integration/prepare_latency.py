import argparse
import hashlib
import json
from pathlib import Path
import shutil


REPO=Path(__file__).resolve().parents[3]
DONOR=Path('E:/vva/s3ap01/c6_epoch_clean.srcs/sources_1/bd/c6v/c6v.bd')
PARENT=Path('E:/vvl/c0e/c6_latency.srcs/sources_1/bd/c6v/c6v.bd')
STATUS=Path('E:/vva/s3ao01/rtl_epoch_guard/axi_vision_capture_status.v')
CELLS=('dual_mask_capture','capture_control','capture_lifecycle','capture_write_pair',
       'capture_status','capture_source_fault','capture_status_inputs','packet_stream_width')
ALIASES={'vision_control_smc/M08_AXI':'vision_control_smc/M06_AXI',
         'vision_control_smc/M09_AXI':'vision_control_smc/M07_AXI',
         'voice_dac_silence_const/dout':'volume_zero/dout'}


def parameter(design,cell,name):
    return design['components'][cell]['parameters'][name]['value']


def connections(donor,parent,kind):
    field='interface_ports' if kind=='interface_nets' else 'ports'
    result=[]
    for name,net in donor[kind].items():
        endpoints=net[field]
        if not any(endpoint.split('/')[0] in CELLS for endpoint in endpoints): continue
        if len(endpoints)==1: continue
        selected=[]
        for endpoint in endpoints:
            endpoint=ALIASES.get(endpoint,endpoint)
            owner=endpoint.split('/')[0]
            if endpoint=='moments_dma/m_axi_mm2s_aclk': continue
            if endpoint=='ps7_0/S_AXI_GP0_ACLK' and parameter(parent,'ps7_0','PCW_USE_S_AXI_GP0')=='0': continue
            if owner in CELLS or owner in parent['components'] or endpoint in parent.get('ports',{}):
                selected.append(endpoint)
            elif kind=='interface_nets' or donor['components'].get(owner,{}).get('ports',{}).get(endpoint.split('/')[-1],{}).get('direction')=='O':
                raise ValueError('missing capture boundary driver: '+endpoint)
        if len(selected)<2:
            raise ValueError('unbound capture connection: '+name)
        result.append((name,selected))
    return result


def inspect(donor,parent):
    assert donor['design_info']['device']==parent['design_info']['device']=='xc7z020clg400-1'
    assert parameter(parent,'build_id_constant','CONST_VAL')=='0xC0060D00'
    assert parameter(parent,'vision_control_smc','NUM_MI')=='6'
    assert parameter(parent,'gp0_smc','NUM_MI')=='31'
    assert parameter(donor,'moments_dma','c_include_sg')=='1'
    assert parameter(donor,'moments_dma','c_include_mm2s')=='0'
    assert all(parameter(donor,'dual_mask_capture',key)=='1' for key in ('CONTINUOUS','SEQUENCE_FRAME_IDS','USE_FRAME_CREDITS'))
    assert not set(CELLS)&set(parent['components'])
    assert len(donor['components']['capture_control']['ports'])>20
    return {kind:connections(donor,parent,kind) for kind in ('interface_nets','nets')}


def quote(value):
    value=str(value)
    if any(character in value for character in '{}\n\r'):
        raise ValueError('unsafe Tcl value')
    return '{'+value+'}'


def interface_lines():
    return [
        'set root [lindex $pins 0]',
        'foreach sink [lrange $pins 1 end] {',
        '    set root_net [get_bd_intf_nets -quiet -of_objects $root]',
        '    set sink_net [get_bd_intf_nets -quiet -of_objects $sink]',
        '    if {[llength $root_net] && $root_net eq $sink_net} {continue}',
        '    set known [concat $root_net $sink_net]',
        '    if {[llength $known]} {connect_bd_intf_net -intf_net [lindex $known 0] $root $sink} else {connect_bd_intf_net $root $sink}',
        '}',
    ]


def config_lines(donor):
    lines=[]
    for cell,settings in (
        ('vision_control_smc',{'NUM_MI':'8'}),
        ('moments_dma',{key:parameter(donor,'moments_dma',key) for key in (
            'c_include_mm2s','c_include_s2mm','c_include_sg','c_m_axi_s2mm_data_width',
            'c_s_axis_s2mm_tdata_width','c_sg_length_width','c_s2mm_burst_size')}),
        ('build_id_constant',{'CONST_VAL':'0xC0060E00'})):
        if cell=='moments_dma':
            settings['c_sg_include_stscntrl_strm']='0'
        pairs=' '.join('CONFIG.'+key+' '+quote(value) for key,value in settings.items())
        lines.append('ipcfg::require '+cell+' [list '+pairs+'] {C0E replacement dual-mask requirements}')
    for cell in CELLS:
        component=donor['components'][cell]
        reference=component.get('reference_info')
        if reference:
            lines.append('create_bd_cell -type module -reference '+quote(reference['ref_name'])+' '+cell)
        else:
            lines.append('create_bd_cell -type ip -vlnv '+quote(component['vlnv'])+' '+cell)
        settings=component.get('parameters',{})
        if settings:
            pairs=' '.join('CONFIG.'+key+' '+quote(value['value']) for key,value in settings.items())
            lines.append('ipcfg::require '+cell+' [list '+pairs+'] {Final B00 capture contract retained}')
    return lines


def generate(output,donor,parent,topology,resume=False):
    output.mkdir()
    frozen=output/'rtl';frozen.mkdir()
    originals=[source for source in sorted((REPO/'rtl/vision_streaming').glob('*.sv'))
               if source.name!='axi_vision_capture_status.sv']+[STATUS]
    originals.append(REPO/'board/pynq_z2/constraints/vision_capture_cdc.xdc')
    hashes={}
    for source in originals:
        destination=frozen/source.name
        shutil.copyfile(source,destination)
        digest=hashlib.sha256(source.read_bytes()).hexdigest()
        assert hashlib.sha256(destination.read_bytes()).hexdigest()==digest
        hashes[str(source)]=digest
    receipt=dict(donor=str(DONOR),donor_sha256=hashlib.sha256(DONOR.read_bytes()).hexdigest(),
                 parent=str(PARENT),parent_sha256=hashlib.sha256(PARENT.read_bytes()).hexdigest(),
                 candidate_build_id='0xC0060E00',topology=topology,source_sha256=hashes,
                 resume_after_disconnect=resume,
                 board_operations=False,release_ready=False)
    with (output/'inputs.json').open('x',encoding='utf-8') as stream: json.dump(receipt,stream,indent=2)
    lines=[
        'if {[file normalize [get_property DIRECTORY [current_project]]] ne {E:/vvl/c0e}} {error {wrong candidate}}',
        'set latency_evidence '+quote(output.as_posix()),
        'if {[get_property CONFIG.CONST_VAL [get_bd_cells build_id_constant]] ne {0xC0060D00}} {error {parent identity differs}}',
    ]
    if resume:
        lines += [
            'if {![info exists latency_addresses] || ![dict size $latency_addresses]} {error {original address snapshot missing}}',
            'foreach cell {skin_kernel '+' '.join(CELLS)+'} {if {[llength [get_bd_cells -quiet $cell]]} {error "unexpected partial stage $cell"}}',
            'foreach pin {demosaic/m_axis_video frame_dma/S_AXIS_S2MM moments_dma/M_AXIS_MM2S moments_dma/M_AXI_MM2S moments_dma/M_AXI_S2MM moments_dma/S_AXIS_S2MM} {if {[llength [get_bd_intf_nets -quiet -of_objects [get_bd_intf_pins $pin]]]} {error "old path still connected $pin"}}',
        ]
    else:
        lines += [
        'set latency_addresses [dict create]',
        'foreach segment [get_bd_addr_segs -of_objects [get_bd_addr_spaces ps7_0/Data]] {dict set latency_addresses $segment [list [get_property OFFSET $segment] [get_property RANGE $segment]]}',
        'foreach pair {{demosaic/m_axis_video frame_dma/S_AXIS_S2MM} {moments_dma/M_AXIS_MM2S skin_kernel/s_axis} {skin_kernel/m_axis moments_dma/S_AXIS_S2MM} {moments_dma/M_AXI_MM2S skin_hp3_smc/S00_AXI} {moments_dma/M_AXI_S2MM skin_hp3_smc/S01_AXI}} {',
        '    lassign $pair first second',
        '    set net [get_bd_intf_nets -of_objects [get_bd_intf_pins $first]]',
        '    if {[lsort [get_bd_intf_pins -of_objects $net]] ne [lsort [list /$first /$second]]} {error "unexpected old path $pair"}',
        '    delete_bd_objs $net',
        '}',
        'delete_bd_objs [get_bd_cells skin_kernel]',
        'disconnect_bd_net [get_bd_nets -of_objects [get_bd_pins moments_dma/m_axi_mm2s_aclk]] [get_bd_pins moments_dma/m_axi_mm2s_aclk]',
        ]
    lines += [
        'add_files -norecurse [glob -directory '+quote(frozen.as_posix())+' *.sv]',
        'add_files -norecurse '+quote((frozen/STATUS.name).as_posix()),
        'update_compile_order -fileset sources_1',
        'proc latency_configure {} {',
        *['    '+line for line in config_lines(donor)],
        '    return SUCCESS:LATENCY_CONFIGURED',
        '}',
        'set latency_receipt [ipcfg::capture [file join $latency_evidence config.tcldict] {latency_configure} {SUCCESS:LATENCY_CONFIGURED}]',
        'puts $latency_receipt',
        'if {[dict get $latency_receipt status] ne {OK}} {error {capture config failed; preserve evidence}}',
        'proc latency_pin {name} {',
        '    if {[string first / $name]<0} {set pin [get_bd_ports $name]} else {set pin [get_bd_pins $name]}',
        '    if {[llength $pin]!=1} {error "missing exact capture pin $name"}',
        '    return $pin',
        '}',
    ]
    for name,endpoints in topology['interface_nets']:
        pins='[get_bd_intf_pins [list '+' '.join(quote(value) for value in endpoints)+']]'
        lines.append('set pins '+pins)
        lines.append('if {[llength $pins]!='+str(len(endpoints))+'} {error '+quote('interface boundary mismatch '+name)+'}')
        lines.append('set existing [lsort -unique [get_bd_intf_nets -quiet -of_objects $pins]]')
        lines.append('if {[llength $existing]>1} {error '+quote('conflicting interface nets '+name)+'}')
        lines.extend(interface_lines())
    for name,endpoints in topology['nets']:
        selected=[value for value in endpoints if value.split('/')[0] in CELLS]
        external=[value for value in endpoints if value not in selected]
        lines+=['set latency_pins {}']
        for endpoint in selected:
            lines.append('lappend latency_pins [latency_pin '+quote(endpoint)+']')
        for endpoint in external:
            lines.append('set boundary [latency_pin '+quote(endpoint)+']')
            lines.append('if {[string first / '+quote(endpoint)+']>=0 && [get_property DIR $boundary] eq {I}} {set old [get_bd_nets -of_objects $boundary]; if {[llength $old]} {disconnect_bd_net $old $boundary}}')
            lines.append('lappend latency_pins $boundary')
        lines.append('connect_bd_net {*}$latency_pins')
    lines += [
        'foreach {cell offset} {capture_control 0x413F0000 capture_status 0x41410000} {assign_bd_address -offset $offset -range 0x10000 -target_address_space [get_bd_addr_spaces ps7_0/Data] [get_bd_addr_segs -of_objects [get_bd_intf_pins $cell/s_axi]]}',
        'assign_bd_address -offset 0x00000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces moments_dma/Data_SG] [get_bd_addr_segs ps7_0/S_AXI_HP3/HP3_DDR_LOWOCM]',
        'dict for {segment pair} $latency_addresses {if {[list [get_property OFFSET $segment] [get_property RANGE $segment]] ne $pair} {error "retained address changed: $segment"}}',
        'add_files -fileset constrs_1 -norecurse '+quote((frozen/'vision_capture_cdc.xdc').as_posix()),
        'set_property USED_IN_SYNTHESIS false [get_files '+quote((frozen/'vision_capture_cdc.xdc').as_posix())+']',
        'set latency_audit [ipcfg::audit_requirements]; puts $latency_audit; if {![string match {REQ:OK*} $latency_audit]} {error {final capture requirements differ}}',
        'save_bd_design',
        'write_bd_tcl [file join $latency_evidence connected-design.tcl]',
        'puts LATENCY_TOPOLOGY_PREPARED_NOT_VALIDATED_NOT_BUILT_NOT_DEPLOYED',
    ]
    with (output/'prepare.tcl').open('x',encoding='utf-8') as stream: stream.write('\n'.join(lines)+'\n')


def main():
    parser=argparse.ArgumentParser()
    parser.add_argument('--check-only',action='store_true')
    parser.add_argument('--output',type=Path,default=Path('E:/vvl/c0e/latency-r01'))
    parser.add_argument('--resume-after-disconnect',action='store_true')
    args=parser.parse_args()
    donor=json.loads(DONOR.read_text(encoding='utf-8'))['design']
    parent=json.loads(PARENT.read_text(encoding='utf-8'))['design']
    topology=inspect(donor,parent)
    assert STATUS.is_file()
    if not args.check_only: generate(args.output,donor,parent,topology,args.resume_after_disconnect)
    print(json.dumps(dict(status='LATENCY_TOPOLOGY_SOURCE_CHECK_PASS',cells=len(CELLS),
                          interfaces=len(topology['interface_nets']),nets=len(topology['nets']),
                          generated=not args.check_only,board_operations=False)))


if __name__=='__main__':
    main()