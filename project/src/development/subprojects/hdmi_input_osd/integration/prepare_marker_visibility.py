"""Prepare an isolated 4x marker candidate; never modifies frozen R20 inputs.

Run: .venv/Scripts/python.exe -B subprojects/hdmi_input_osd/integration/prepare_marker_visibility.py
Output: subprojects/hdmi_input_osd/marker_visibility_r01/{rtl,sim,tools,constraints,identity.json}.
Next: run copied tools/run_xsim.py and synthesize/route the changed pixel cell.
"""
import hashlib
import json
import math
from pathlib import Path
import shutil

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'marker_visibility_r02'


def main():
    OUT.mkdir(exist_ok=False)
    for name in ('rtl','sim','tools','constraints'):
        shutil.copytree(ROOT/name,OUT/name)
    pixel = OUT/'rtl/input_osd_pixels.sv'
    text = pixel.read_text(encoding='utf-8')
    original = hashlib.sha256(pixel.read_bytes()).hexdigest()
    begin = text.index('            case(radius)')
    end = text.index('    endfunction', begin)
    lines = ['            case(radius)']
    for radius in (48,42,32,26):
        lines.append(f'                {radius}:case(ay)')
        for y in range(radius+1):
            lines.append(f'                    {y}:extent={math.isqrt(radius*radius-y*y)};')
        lines.append('                endcase')
    lines.append('            endcase')
    text = text[:begin]+'\n'.join(lines)+'\n        end\n'+text[end:]
    text = text.replace('    localparam [23:0] RED=',
        "    localparam [23:0] HAND_GREEN=RGB_PACKED ? 24'h00ff00 : 24'h0000ff;\n"
        "    localparam [23:0] HAND_RED=24'hff0000;\n    localparam [23:0] RED=",1)
    replacements = {
        'extent(dy1,fist1 ? 8 : 12)':'extent(dy1,fist1 ? 32 : 48)',
        'extent(dy1,fist1 ? 6 : 10)':'extent(dy1,fist1 ? 26 : 42)',
        '(dx1<=1 && dy1<=1)':'(dx1<=4 && dy1<=4)',
        'hit2<=1;paint2<=fist1 ? RED : GREEN;':'hit2<=1;paint2<=fist1 ? HAND_RED : HAND_GREEN;'}
    for old,new in replacements.items():
        assert text.count(old)==1,old
        text = text.replace(old,new)
    pixel.write_text(text,encoding='utf-8')
    tb = OUT/'sim/tb_input_osd.sv'
    text = tb.read_text(encoding='utf-8')
    text = text.replace('rr=(ex_flags & 4) ? 8:12;ri=rr-2;',
                        'rr=(ex_flags & 4) ? 32:48;ri=rr-6;')
    text = text.replace('dx>=-1 && dx<=1 && dy>=-1 && dy<=1',
                        'dx>=-4 && dx<=4 && dy>=-4 && dy<=4')
    text = text.replace("reference_pixel=(ex_flags & 4) ? 24'hff4848 : 24'h4070e0;",
                        "reference_pixel=(ex_flags & 4) ? 24'hff0000 : 24'h0000ff;")
    # Retain original cases and add full-circle, screen-edge and meter overlap.
    marker='        // Only 1-frame audio lifetime; hand must remain visible independently.'
    assert marker in text
    extra='''        // Visibility candidate: complete rings plus right/bottom clipping and meter priority.
        stage(11,W/2,H/2,90,10,10,15,6);
        ex_x=W/2;ex_y=H/2;ex_level=90;boundary;scan(0);
        stage(15,W/2,H/2,180,11,11,15,6);
        ex_flags=15;ex_level=180;boundary;scan(0);
        stage(11,W-1,H-1,90,12,12,15,6);
        ex_flags=11;ex_x=W-1;ex_y=H-1;ex_level=90;boundary;scan(1);
        stage(15,W-10,H/2,180,13,13,15,6);
        ex_flags=15;ex_x=W-10;ex_y=H/2;ex_level=180;boundary;scan(2);
'''
    text = text.replace(marker,extra+marker)
    # New source IDs remain monotonic; original duplicate-ID lifetime case retained.
    text=text.replace('30,4,4,15,','30,14,14,15,').replace('30,5,5,15,','30,15,15,15,')
    text=text.replace('        ex_x=20;ex_y=40;ex_level=30;boundary;',
                      '        ex_flags=11;ex_x=20;ex_y=40;ex_level=30;boundary;')
    tb.write_text(text,encoding='utf-8')
    record=dict(stage='MARKER_VISIBILITY_SOURCE_READY',board_access=False,
        target='xc7z020clg400-1',vivado='2026.1',original_pixel_sha256=original,
        outer_radius_px=dict(normal=48,fist=32),line_width_px=6,center_dot_px=9,
        colors=dict(normal='#00FF00',fist='#FF0000'),volume_meter_unchanged=True,
        sources={p.relative_to(OUT).as_posix():hashlib.sha256(p.read_bytes()).hexdigest()
                 for directory in ('rtl','sim','constraints') for p in (OUT/directory).glob('*') if p.is_file()})
    (OUT/'identity.json').write_text(json.dumps(record,indent=2),encoding='utf-8')
    print('MARKER_VISIBILITY_SOURCE_READY',OUT)


if __name__=='__main__':
    main()
