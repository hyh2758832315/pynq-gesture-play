"""Prepare the unchanged module-reference boundary for strict OSD replacement.
Run with project Python; outputs r02/rtl/c6v_input_osd_0_0.sv + wrapper_identity.json.
Next: source synth_marker_wrapper.tcl in the owned Vivado session. No board IO.
"""
from pathlib import Path
import hashlib
import json
import re
import tkinter

REPO=Path(__file__).resolve().parents[3]
ROOT=REPO/'subprojects/hdmi_input_osd/marker_visibility_r02'
STUB=Path('E:/vvl/c0e/c6_latency.gen/sources_1/bd/c6v/ip/c6v_input_osd_0_0/c6v_input_osd_0_0_stub.v')

if __name__=='__main__':
    raw=STUB.read_text(encoding='utf-8')
    assert 'WIDTH=1280,HEIGHT=720,RGB_PACKED=0' in raw
    source=re.sub(r'\(\*.*?\*\)', '', raw, flags=re.S)
    source=re.sub(r'/\*.*?\*/', '', source, flags=re.S)
    header=re.search(r'module c6v_input_osd_0_0\((.*?)\)',source,re.S)
    assert header
    ports=[value.strip() for value in header[1].split(',')]
    split=tkinter.Tcl().splitlist
    declared=(REPO/'build/hosd/marker-visibility-r02/ooc-r01/ports.tcldict').read_text(encoding='utf-8')
    expected={re.sub(r'\[\d+\]$','',split(row)[0]) for row in split(declared)}
    assert len(ports)==len(set(ports)) and set(ports)==expected
    instance='input_osd_axi #(.WIDTH(1280),.HEIGHT(720),.RGB_PACKED(0)) inst(\n'
    instance+=',\n'.join('    .'+name+'('+name+')' for name in ports)+'\n);\n'
    assert source.count('endmodule')==1
    source=source.replace('endmodule',instance+'endmodule')
    target=ROOT/'rtl/c6v_input_osd_0_0.sv'
    with target.open('x',encoding='utf-8') as output:output.write(source)
    record=dict(stub=str(STUB),stub_sha256=hashlib.sha256(STUB.read_bytes()).hexdigest(),
        ports=ports,sources={p.relative_to(ROOT).as_posix():hashlib.sha256(p.read_bytes()).hexdigest()
                            for p in (ROOT/'rtl').glob('*.sv')})
    with (ROOT/'wrapper_identity.json').open('x',encoding='utf-8') as output:json.dump(record,output,indent=2)
    print('MARKER_WRAPPER_READY',len(ports))
