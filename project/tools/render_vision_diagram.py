"""Render a JSON system diagram as SVG, draw.io, PNG and vector PDF.

Run: python -B render_diagram.py scene.json --output figures/system
Requires PySide6. Next: visually inspect the PNG and edit the JSON or draw.io.
"""
import argparse
import html
import json
import os
from pathlib import Path
import xml.etree.ElementTree as ET

os.environ.setdefault('QT_QPA_PLATFORM', 'windows' if os.name=='nt' else 'offscreen')
from PySide6.QtCore import QRectF, QSizeF, Qt
from PySide6.QtGui import QGuiApplication, QImage, QPainter, QPdfWriter, QPageSize
from PySide6.QtSvg import QSvgRenderer


def render(scene, output):
    width,height=scene['width'],scene['height']
    nodes=scene['nodes'];edges=scene['edges'];ids={n['id'] for n in nodes}
    if len(ids)!=len(nodes):raise ValueError('Duplicate node IDs')
    for n in nodes:
        if not (0<=n['x'] and 0<=n['y'] and n['x']+n['w']<=width and n['y']+n['h']<=height):
            raise ValueError('Node outside canvas: '+n['id'])
    for e in edges:
        if e['source'] not in ids or e['target'] not in ids:raise ValueError('Missing edge endpoint')
        if any(a[0]!=b[0] and a[1]!=b[1] for a,b in zip(e['points'],e['points'][1:])):
            raise ValueError('Expected orthogonal routing')
    output.parent.mkdir(parents=True,exist_ok=True)
    colors=sorted({e.get('color','#475569') for e in edges})
    markers={c:'arrow'+str(i) for i,c in enumerate(colors)}
    svg=[f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}">',
         f'<rect x="0" y="0" width="{width}" height="{height}" fill="#ffffff"/>','<defs>']
    for c,m in markers.items():
        svg.append(f'<marker id="{m}" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="8" markerHeight="8" orient="auto-start-reverse"><path d="M0,0 L10,5 L0,10 z" fill="{c}"/></marker>')
    svg.append('</defs><g font-family="Microsoft YaHei" fill="#172b3a">')

    root=ET.Element('mxfile',host='app.diagrams.net',version='24.7.17')
    diag=ET.SubElement(root,'diagram',name=scene['title'],id='system')
    model=ET.SubElement(diag,'mxGraphModel',dx=str(width),dy=str(height),grid='1',gridSize='10',page='1',pageWidth=str(width),pageHeight=str(height))
    cells=ET.SubElement(model,'root');ET.SubElement(cells,'mxCell',id='0');ET.SubElement(cells,'mxCell',id='1',parent='0')

    def node(n):
        x,y,w,h=n['x'],n['y'],n['w'],n['h'];kind=n.get('kind','box')
        size=n.get('font_size',25);fill=n.get('fill','#ffffff');stroke=n.get('stroke','#64748b')
        lines=n['lines'].split('\n');group=kind=='group'
        if kind=='ellipse':svg.append(f'<ellipse cx="{x+w/2}" cy="{y+h/2}" rx="{w/2}" ry="{h/2}" fill="{fill}" stroke="{stroke}" stroke-width="3"/>')
        elif kind!='text':svg.append(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{0 if group else 6}" fill="{fill}" stroke="{stroke}" stroke-width="{2.6 if group else 2}"/>')
        if group:
            tx,ty,anchor=x+22,y+38,'start'
        else:tx,ty,anchor=x+w/2,y+h/2-(len(lines)-1)*size*.65+size*.34,'middle'
        for i,line in enumerate(lines):
            svg.append(f'<text x="{tx}" y="{ty+i*size*1.3}" text-anchor="{anchor}" font-size="{size}" font-weight="{600 if i==0 else 400}">{html.escape(line)}</text>')
        style=f'rounded=0;whiteSpace=wrap;html=0;fillColor={fill};strokeColor={stroke};fontColor=#172b3a;fontFamily=Microsoft YaHei;fontSize={size};spacing=12;'
        if kind=='text':style+='fillColor=none;strokeColor=none;'
        if kind=='ellipse':style+='ellipse;'
        if group:style+='verticalAlign=top;align=left;spacingTop=12;spacingLeft=14;'
        cell=ET.SubElement(cells,'mxCell',id=n['id'],value=n['lines'],style=style,vertex='1',parent='1')
        ET.SubElement(cell,'mxGeometry',x=str(x),y=str(y),width=str(w),height=str(h),attrib={'as':'geometry'})

    groups=[n for n in nodes if n.get('kind')=='group']
    for n in groups:node(n)
    # Draw connectors before foreground boxes so they do not cover text.
    by_id={n['id']:n for n in nodes}
    for i,e in enumerate(edges):
        c=e.get('color','#475569');pts=e['points'];m=markers[c]
        path='M'+' L'.join(f'{x},{y}' for x,y in pts)
        attrs=f' stroke-dasharray="9 6"' if e.get('dashed') else ''
        start=f' marker-start="url(#{m})"' if e.get('both') else ''
        svg.append(f'<path d="{path}" fill="none" stroke="{c}" stroke-width="2.7" marker-end="url(#{m})"{start}{attrs}/>')
        style=f'edgeStyle=segmentEdgeStyle;rounded=0;html=0;strokeColor={c};strokeWidth=2;endArrow=block;endFill=1;fontSize=19;fontFamily=Microsoft YaHei;labelBackgroundColor=#ffffff;'
        if e.get('dashed'):style+='dashed=1;'
        if e.get('both'):style+='startArrow=block;startFill=1;'
        for role,p in [('exit',pts[0]),('entry',pts[-1])]:
            n=by_id[e['source'] if role=='exit' else e['target']]
            style+=f'{role}X={(p[0]-n["x"])/n["w"]};{role}Y={(p[1]-n["y"])/n["h"]};{role}Perimeter=0;'
        cell=ET.SubElement(cells,'mxCell',id='edge'+str(i),value='',style=style,edge='1',parent='1',source=e['source'],target=e['target'])
        geo=ET.SubElement(cell,'mxGeometry',relative='1',attrib={'as':'geometry'})
        arr=ET.SubElement(geo,'Array',attrib={'as':'points'})
        for x,y in pts[1:-1]:ET.SubElement(arr,'mxPoint',x=str(x),y=str(y))
    for n in nodes:
        if n.get('kind')!='group':node(n)
    for i,e in enumerate(edges):
        if not e.get('label'):continue
        x,y=e['label_x'],e['label_y'];label=e['label'];size=scene.get('edge_font_size',18)
        # CJK-aware approximate width; the SVG text is also measured below.
        from PySide6.QtGui import QFont,QFontMetricsF
        font=QFont('Microsoft YaHei');font.setPixelSize(size)
        w=QFontMetricsF(font).horizontalAdvance(label)+18
        label_h=size+9;label_top=y-size-2
        background=e.get('label_background','#ffffff')
        svg.append(f'<rect x="{x-w/2}" y="{label_top}" width="{w}" height="{label_h}" fill="{background}"/>')
        svg.append(f'<text x="{x}" y="{y}" font-size="{size}" text-anchor="middle" fill="{e.get("color","#475569")}">{html.escape(label)}</text>')
        cell=ET.SubElement(cells,'mxCell',id='label'+str(i),value=label,style=f'text;html=0;whiteSpace=wrap;fillColor={background};strokeColor=none;fontSize={size};fontFamily=Microsoft YaHei;',vertex='1',parent='1')
        ET.SubElement(cell,'mxGeometry',x=str(x-w/2),y=str(label_top),width=str(w),height=str(label_h),attrib={'as':'geometry'})
    svg.append('</g></svg>')
    raw='\n'.join(svg).encode('utf-8');output.with_suffix('.svg').write_bytes(raw)
    ET.indent(root);ET.ElementTree(root).write(output.with_suffix('.drawio'),encoding='utf-8',xml_declaration=True)
    renderer=QSvgRenderer(raw)
    if not renderer.isValid():raise ValueError('SVG failed to load')
    image=QImage(width*2,height*2,QImage.Format_RGB32);image.fill(Qt.white)
    painter=QPainter(image);renderer.render(painter,QRectF(0,0,width*2,height*2));painter.end()
    if not image.save(str(output.with_suffix('.png'))):raise RuntimeError('PNG export failed')
    pdf=QPdfWriter(str(output.with_suffix('.pdf')));pdf.setResolution(144)
    pdf.setPageSize(QPageSize(QSizeF(width/6,height/6),QPageSize.Millimeter))
    from PySide6.QtGui import QPageLayout
    from PySide6.QtCore import QMarginsF
    pdf.setPageMargins(QMarginsF(0,0,0,0),QPageLayout.Millimeter)
    painter=QPainter(pdf);renderer.render(painter,QRectF(0,0,pdf.width(),pdf.height()));painter.end()
    print(json.dumps(dict(output=str(output),nodes=len(nodes),edges=len(edges),formats=['svg','drawio','png','pdf'])))


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('scene',type=Path);p.add_argument('--output',type=Path,required=True)
    a=p.parse_args();app=QGuiApplication([])
    if os.name=='nt':
        from PySide6.QtGui import QFontDatabase
        for name in ('msyh.ttc','msyhbd.ttc','arial.ttf'):
            QFontDatabase.addApplicationFont('C:/Windows/Fonts/'+name)
    render(json.loads(a.scene.read_text(encoding='utf-8')),a.output)


if __name__=='__main__':main()
