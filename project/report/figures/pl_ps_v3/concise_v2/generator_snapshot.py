"""Generate bilingual landscape diagrams of the independent v3.0 package.

From contest_v3 with Python / PySide6:
 python -B tools/draw_pl_ps_system.py
 python -B tools/render_system_diagram.py report/figures/pl_ps_v3/system_zh.json --output report/figures/pl_ps_v3/system_zh
 python -B tools/render_system_diagram.py report/figures/pl_ps_v3/system_en.json --output report/figures/pl_ps_v3/system_en
Outputs: two scenes and evidence.json; renderer exports draw.io / SVG / PNG / PDF.
Next: inspect both figures and replace peripheral photo placeholders as needed.
No hardware build, board access or frozen-package edits are performed.
"""
import copy
import hashlib
import json
from pathlib import Path
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'report/figures/pl_ps_v3'
BLUE = '#276c96'
GREEN = '#287963'
PURPLE = '#77539a'
GRAY = '#697887'


def make_scene():
    nodes, edges = [], []

    def box(key, x, y, w, h, lines, fill='#ffffff', stroke=GRAY,
            size=27, kind='box'):
        nodes.append(dict(id=key, x=x, y=y, w=w, h=h, lines=lines,
                          fill=fill, stroke=stroke, font_size=size, kind=kind))

    def edge(source, target, points, color=GRAY, label='', pos=None,
             dashed=False, both=False):
        item = dict(source=source, target=target, points=points,
                    color=color, dashed=dashed, both=both)
        if label:
            item.update(label=label, label_x=pos[0], label_y=pos[1],
                        label_background='#f1f7f3' if source == 'recognizer' else 'none')
        edges.append(item)

    box('title', 30, 20, 2340, 65,
        'GESTURE PLAY v3.0  |  PL–PS 系统架构', size=39, kind='text')
    box('soc', 305, 135, 1775, 815, 'PYNQ-Z2  ·  Zynq-7020',
        stroke='#3a5061', size=27, kind='group')
    box('pl', 335, 205, 1135, 715, 'PL  /  可编程逻辑',
        fill='#f8fafc', stroke='#7893aa', size=32, kind='group')
    box('ps', 1610, 205, 440, 715, 'PS  /  处理系统',
        fill='#f1f7f3', stroke=GREEN, size=32, kind='group')
    box('cpu', 1630, 255, 400, 35, 'ARM Cortex-A9 · Linux / PYNQ',
        size=22, kind='text')

    # Two independent PL pipelines; the wide horizontal separator is intentional.
    box('vision', 360, 295, 1085, 240, '视觉处理',
        fill='#eaf4fb', stroke=BLUE, size=29, kind='group')
    box('division', 360, 565, 1085, 3, '', fill='#526575', stroke='#526575')
    box('graphics', 360, 595, 1085, 250, '渲染 GPU',
        fill='#f3eef8', stroke=PURPLE, size=29, kind='group')
    box('input', 400, 400, 235, 95, 'DVP 接入\nBayer → RGB', stroke=BLUE)
    box('filter', 705, 400, 305, 95, '肤色分割 / 滤波\n双掩膜生成', stroke=BLUE)
    box('capture', 1080, 400, 325, 95, '帧采集 / DMA\nRGB · 双掩膜', stroke=BLUE)

    # GPU commands travel right-to-left, returning from the PS to the display.
    box('upload', 1240, 700, 165, 95, '命令 DMA\n资源上传', stroke=PURPLE, size=24)
    box('raster', 930, 700, 245, 95, 'Scene2D GPU\n2D 光栅化', stroke=PURPLE)
    box('fb', 665, 700, 210, 95, '双帧缓冲\nBRAM', stroke=PURPLE)
    box('scan', 400, 700, 210, 95, 'OSD 叠加\nHDMI 输出', stroke=PURPLE)
    box('control', 400, 865, 1005, 40, 'AXI-Lite  ·  采集配置 / GPU / OSD',
        fill='#eef1f4', stroke=GRAY, size=23)

    box('agent', 1645, 310, 370, 65, 'Agent / 内容管理', stroke=GREEN, size=26)
    box('recognizer', 1645, 400, 370, 95, '手势识别\nOpenCV', stroke=GREEN)
    box('app', 1645, 700, 370, 95, '交互应用\nScene 编译', stroke=GREEN)
    box('hand', 1645, 840, 370, 60, '灵巧手调度', stroke=GREEN, size=26)

    # These off-chip boxes reserve space for real photographs / screenshots.
    box('camera', 30, 335, 225, 220, 'OV5640\n\n照片预留', fill='#fafafa')
    box('monitor', 30, 655, 225, 220, 'HDMI 显示器\n\n画面预留', fill='#fafafa', size=26)
    box('pc', 2160, 235, 210, 220, '上位机 Studio\n\n界面预留', fill='#fafafa', size=25)
    box('hand_external', 2160, 765, 210, 220, '灵巧手\n\n照片预留', fill='#fafafa')

    edge('camera', 'input', [[255, 447], [400, 447]], BLUE, 'DVP', (325, 425))
    edge('input', 'filter', [[635, 447], [705, 447]], BLUE)
    edge('input', 'capture', [[635, 447], [665, 447], [665, 375],
                             [1250, 375], [1250, 400]], BLUE, 'RGB', (1090, 363))
    edge('filter', 'capture', [[1010, 447], [1080, 447]], BLUE)
    # HP arrows abstract DDR transfers, not direct DMA-to-software wires.
    edge('capture', 'recognizer', [[1405, 447], [1645, 447]], BLUE,
         'AXI HP / DDR', (1540, 425))
    edge('recognizer', 'app', [[1830, 495], [1830, 700]], GREEN,
         '手势 / 位置', (1830, 605))
    edge('app', 'upload', [[1645, 747], [1405, 747]], PURPLE,
         'AXI HP / DDR', (1540, 725))
    edge('upload', 'raster', [[1240, 747], [1175, 747]], PURPLE)
    edge('raster', 'fb', [[930, 747], [875, 747]], PURPLE)
    edge('fb', 'scan', [[665, 747], [610, 747]], PURPLE)
    edge('scan', 'monitor', [[400, 747], [255, 747]], PURPLE,
         'HDMI', (325, 725))
    edge('pc', 'agent', [[2160, 342], [2015, 342]], GRAY,
         'Ethernet', (2090, 320), both=True)
    edge('recognizer', 'hand', [[2015, 475], [2032, 475], [2032, 815],
                               [1950, 815], [1950, 840]], GREEN)
    edge('hand', 'hand_external', [[2015, 870], [2160, 870]], GREEN,
         'USB', (2090, 848))
    edge('app', 'control', [[1645, 778], [1575, 778], [1575, 885],
                           [1405, 885]], GRAY, 'AXI GP', (1515, 863), dashed=True)
    box('note', 305, 990, 1775, 38,
        '蓝：视觉数据    紫：绘图数据    灰虚线：控制    ·    PL 与 PS 经 DDR 交换数据',
        size=23, kind='text')
    return dict(width=2400, height=1060, title='GESTURE PLAY v3.0 PL–PS',
                subtitle='Landscape architecture; independent contest_v3 runtime',
                edge_font_size=21, nodes=nodes, edges=edges)


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    zh = make_scene()
    en = copy.deepcopy(zh)
    labels = {
        'title': 'GESTURE PLAY v3.0  |  PL–PS System Architecture',
        'soc': 'PYNQ-Z2  ·  Zynq-7020',
        'pl': 'PL  /  Programmable Logic', 'ps': 'PS  /  Processing System',
        'cpu': 'ARM Cortex-A9 · Linux / PYNQ',
        'vision': 'Vision Processing', 'division': '', 'graphics': 'Rendering GPU',
        'input': 'DVP Input\nBayer → RGB',
        'filter': 'Skin Segmentation\nFilter / Dual Masks',
        'capture': 'Frame Capture / DMA\nRGB / Dual Masks',
        'upload': 'DMA Upload\nCmd / Assets',
        'raster': 'Scene2D GPU\n2D Rasterization',
        'fb': 'Double Buffer\nBRAM', 'scan': 'OSD Overlay\nHDMI Output',
        'control': 'AXI-Lite  /  Capture Configuration / GPU / OSD',
        'agent': 'Agent / Content Management',
        'recognizer': 'Gesture Recognition\nOpenCV',
        'app': 'Interaction Logic\nScene Compiler', 'hand': 'Hand Control',
        'camera': 'OV5640\n\nPhoto Area',
        'monitor': 'HDMI Display\n\nImage Area',
        'pc': 'Studio Host\n\nScreenshot',
        'hand_external': 'Robotic Hand\n\nPhoto Area',
        'note': 'Blue: vision data    Purple: drawing data    Dashed: control    |    PL–PS data transfer via DDR',
    }
    assert set(labels) == {n['id'] for n in en['nodes']}
    for node in en['nodes']:
        node['lines'] = labels[node['id']]
        if node['id'] == 'ps':
            node['font_size'] = 29
        if node['id'] == 'agent':
            node['font_size'] = 22
        if node['id'] == 'upload':
            node['font_size'] = 21
        if node['id'] in ('raster', 'fb'):
            node['font_size'] = 26
    for item in en['edges']:
        if item.get('label') == '手势 / 位置':
            item['label'] = 'Gesture / Position'
    for language, scene in [('zh', zh), ('en', en)]:
        scene['language'] = language
        (OUT / f'system_{language}.json').write_text(
            json.dumps(scene, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

    paths = [
        'README.md', 'report/design_report.md', 'board/runtime/deployment_manifest.json',
        'board/runtime/overlay/c6v_candidate.hwh',
        'build/hardware/c6_latency/c6_latency.srcs/sources_1/bd/c6v/c6v.bd',
        'board/runtime/board/pynq_z2/scripts/vision_async_runtime.py',
        'board/runtime/python/pynq_multimodal_game/agent/c6i_video.py',
        'board/runtime/python/pynq_multimodal_game/agent/c6i_shell.py',
    ]
    evidence = {p: hashlib.sha256((ROOT / p).read_bytes()).hexdigest() for p in paths}
    hw = ET.parse(ROOT / paths[3])
    modules = {m.attrib.get('INSTANCE'): m.attrib.get('MODTYPE') for m in hw.iter('MODULE')}
    required = {'core': 'scene2d_c4m7_core', 'dual_mask_capture': 'axis_rgb_capture_bd',
                'frame_dma': 'axi_vdma', 'moments_dma': 'axi_dma',
                'axi_dma': 'axi_dma', 'input_osd_0': 'input_osd_axi'}
    assert all(modules.get(k) == v for k, v in required.items())
    bd = json.loads((ROOT / paths[4]).read_text(encoding='utf-8'))['design']
    nets = {k: v for k, v in bd['interface_nets'].items()
            if 'ps7_0/S_AXI_HP' in str(v)
            or k in ['axi_dma_M_AXI_MM2S', 'frame_dma_M_AXI_S2MM', 'moments_dma_M_AXI_S2MM']}
    record = dict(source='contest_v3', layout='landscape_bilingual_v2',
                  runtime_manifest_sha256=evidence[paths[2]], sha256=evidence,
                  verified_modules=required, verified_bus_nets=nets,
                  visual_references=[
                      'https://github.com/VincentttWang/FPGA_SocChina_2025/blob/main/doc/img/System%20Graph.png',
                      'https://xilinx.github.io/PYNQ-ZU/overlays',
                  ])
    (OUT / 'evidence.json').write_text(
        json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(json.dumps(dict(output=str(OUT), nodes=len(zh['nodes']),
                          edges=len(zh['edges']), languages=['zh', 'en'], source_checks='PASS')))


if __name__ == '__main__':
    main()
