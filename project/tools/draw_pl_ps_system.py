"""Generate bilingual, expanded PL diagrams from the independent v3.0 package.

Run inside contest_v3 with a Python environment containing PySide6:
 python -B tools/draw_pl_ps_system.py
 python -B tools/render_system_diagram.py report/figures/pl_ps_v3/system_zh.json --output report/figures/pl_ps_v3/system_zh
 python -B tools/render_system_diagram.py report/figures/pl_ps_v3/system_en.json --output report/figures/pl_ps_v3/system_en
Outputs: bilingual scene JSON, evidence.json; renderer exports draw.io/SVG/PNG/PDF.
Next: inspect both exports, then replace peripheral photo placeholders as needed.
No hardware build, board access or runtime edits are performed.
"""
import copy
import hashlib
import json
from pathlib import Path
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'report/figures/pl_ps_v3'
RTL = 'build/hardware/c6_latency/c6_latency.srcs/sources_1/imports/'
BLUE, GREEN, PURPLE, GRAY = '#276c96', '#287963', '#77539a', '#697887'


def make_scene():
    nodes, edges, english = [], [], {}

    def box(key, x, y, w, h, zh, en, fill='#ffffff', stroke=GRAY,
            size=27, kind='box'):
        nodes.append(dict(id=key, x=x, y=y, w=w, h=h, lines=zh,
                          fill=fill, stroke=stroke, font_size=size, kind=kind))
        english[key] = en

    def edge(source, target, points, color=GRAY, label='', pos=None,
             dashed=False, both=False, en_label=None):
        item = dict(source=source, target=target, points=points,
                    color=color, dashed=dashed, both=both)
        if label:
            item.update(label=label, label_x=pos[0], label_y=pos[1],
                        label_background='#f1f7f3' if source == 'recognizer' else 'none')
            if en_label:
                item['en_label'] = en_label
        edges.append(item)

    box('title', 30, 20, 3020, 65, 'GESTURE PLAY v3.0  |  PL–PS 系统架构',
        'GESTURE PLAY v3.0  |  PL–PS System Architecture', size=42, kind='text')
    box('soc', 290, 130, 2440, 1435, 'PYNQ-Z2 · Zynq-7020',
        'PYNQ-Z2 · Zynq-7020', stroke='#3a5061', size=29, kind='group')
    box('pl', 320, 205, 1660, 1325, 'PL / 可编程逻辑', 'PL / Programmable Logic',
        fill='#f8fafc', stroke='#7893aa', size=34, kind='group')
    box('ps', 2190, 205, 510, 1325, 'PS / 处理系统', 'PS / Processing System',
        fill='#f1f7f3', stroke=GREEN, size=34, kind='group')
    box('cpu', 2220, 260, 450, 45, 'ARM Cortex-A9 · Linux / PYNQ',
        'ARM Cortex-A9 · Linux / PYNQ', size=25, kind='text')
    box('vision', 350, 285, 1410, 505, '视觉处理', 'Vision Processing',
        fill='#eaf4fb', stroke=BLUE, size=30, kind='group')
    box('division', 350, 815, 1410, 3, '', '', fill='#526575', stroke='#526575')
    box('graphics', 350, 850, 1410, 560, '渲染 GPU', 'Rendering GPU',
        fill='#f3eef8', stroke=PURPLE, size=30, kind='group')

    # Capture: RGB bypass, raw/filtered mask pairing, distinct DMA channels.
    box('camera_i2c', 390, 340, 210, 65, '相机 I²C', 'Camera I²C', size=25)
    box('input', 390, 435, 210, 90, 'DVP / 去马赛克\nRGB 输出',
        'Camera Input\nDemosaic', stroke=BLUE, size=25)
    box('hsv', 700, 435, 255, 90, '缩减 / HSV\n肤色阈值',
        'Downscale / HSV\nSkin Threshold', stroke=BLUE, size=26)
    box('raw', 1065, 435, 255, 90, '原始掩膜\n对齐 FIFO',
        'Raw Mask\nAlignment FIFO', stroke=BLUE, size=26)
    box('filter', 1065, 575, 255, 90, '形态 / 高斯滤波',
        'Dilation / Gaussian', stroke=BLUE, size=24)
    box('packet', 1430, 575, 280, 90, '双掩膜打包\n帧标识 / 状态',
        'Dual-Mask Packet\nFrame / Status', stroke=BLUE, size=26)
    box('rgb_dma', 1450, 340, 260, 70, 'RGB VDMA', 'RGB VDMA', stroke=BLUE)
    box('mask_dma', 1450, 710, 260, 65, '掩膜 DMA（SG）',
        'Mask DMA (SG)', stroke=BLUE, size=26)
    box('lifecycle', 390, 710, 550, 65, '帧准入 / 三槽管理',
        'Frame Admission / 3-Slot Control', size=25)
    box('hp', 1820, 340, 115, 1005, 'AXI HP\n互连', 'AXI HP\nFabric',
        fill='#eef1f4', size=22)

    # Scene packet types fan out to commands, assets and palette stores.
    box('upload', 1480, 950, 230, 70, '上传 DMA', 'Upload DMA', stroke=PURPLE)
    box('router', 1180, 950, 230, 70, '包解析 / 分发', 'Packet Router', stroke=PURPLE, size=26)
    box('command', 880, 950, 230, 70, '命令缓冲', 'Command Buffer', stroke=PURPLE, size=24)
    box('assets', 1180, 1110, 230, 90, '图集 / 图块\n资源存储',
        'Atlas / Tilemap\nResource Store', stroke=PURPLE, size=24)
    box('palette', 1480, 1110, 230, 90, '调色板存储', 'Palette Store', stroke=PURPLE, size=25)
    box('raster', 670, 1075, 440, 130, 'Scene2D 绘制', 'Scene2D Renderer',
        fill='#e9e0f2', stroke=PURPLE, size=26, kind='group')
    box('fill', 690, 1135, 110, 50, '填充', 'Fill', stroke=PURPLE, size=23)
    box('sprite', 830, 1135, 110, 50, '精灵', 'Sprite', stroke=PURPLE, size=23)
    box('tile', 970, 1135, 120, 50, '图块', 'Tiles', stroke=PURPLE, size=23)
    box('fb', 650, 1280, 460, 65, 'BRAM 双帧缓冲', 'BRAM Double Buffer', stroke=PURPLE)
    box('swap', 1180, 1260, 230, 85, '消隐期帧交换', 'Frame Swap\nVBlank', stroke=PURPLE, size=25)
    box('scan', 390, 1280, 200, 65, '调色 / 扫描\n4× 放大',
        'Palette Scanout\n4× Scaling', stroke=PURPLE, size=23)
    box('osd', 390, 1110, 200, 90, '独立 OSD\nHDMI 输出',
        'OSD Overlay\nHDMI Output', stroke=PURPLE, size=25)
    box('control', 390, 1460, 1545, 45, 'AXI-Lite 控制 / 状态寄存器',
        'AXI-Lite Control / Status Registers', fill='#eef1f4', size=26)

    box('agent', 2230, 345, 430, 80, 'Agent / 内容管理',
        'Agent / Content Management', stroke=GREEN, size=27)
    box('recognizer', 2230, 505, 430, 115, '手势识别\nOpenCV',
        'Gesture Recognition\nOpenCV', stroke=GREEN, size=30)
    box('app', 2230, 1015, 430, 115, '交互应用\nScene 编译',
        'Interaction Logic\nScene Compiler', stroke=GREEN, size=30)
    box('hand', 2230, 1300, 430, 90, '灵巧手调度',
        'Hand Control', stroke=GREEN, size=30)
    box('driver', 2230, 1450, 430, 65, 'MMIO / 设备驱动',
        'MMIO / Device Drivers', stroke=GREEN, size=26)
    box('camera', 30, 390, 210, 230, 'OV5640\n\n照片预留',
        'OV5640\n\nPhoto Area', fill='#fafafa', size=27)
    box('monitor', 30, 1070, 210, 230, 'HDMI 显示器\n\n画面预留',
        'HDMI Display\n\nImage Area', fill='#fafafa', size=25)
    box('pc', 2810, 330, 230, 230, '上位机 Studio\n\n界面预留',
        'Studio Host\n\nScreenshot', fill='#fafafa', size=26)
    box('hand_external', 2810, 1190, 230, 230, '灵巧手\n\n照片预留',
        'Robotic Hand\n\nPhoto Area', fill='#fafafa', size=27)

    edge('camera', 'input', [[240, 480], [390, 480]], BLUE, 'DVP', (300, 459))
    edge('camera_i2c', 'camera', [[390, 372], [270, 372], [270, 420], [240, 420]],
         GRAY, dashed=True)
    edge('input', 'hsv', [[600, 480], [700, 480]], BLUE)
    edge('input', 'rgb_dma', [[600, 480], [645, 480], [645, 375], [1450, 375]],
         BLUE, 'RGB', (1240, 359))
    edge('hsv', 'raw', [[955, 480], [1065, 480]], BLUE)
    edge('hsv', 'filter', [[955, 480], [1015, 480], [1015, 620], [1065, 620]], BLUE)
    edge('raw', 'packet', [[1320, 480], [1380, 480], [1380, 595], [1430, 595]], BLUE)
    edge('filter', 'packet', [[1320, 635], [1430, 635]], BLUE)
    edge('packet', 'mask_dma', [[1580, 665], [1580, 710]], BLUE)
    edge('rgb_dma', 'hp', [[1710, 375], [1820, 375]], BLUE, 'HP1', (1765, 354))
    edge('mask_dma', 'hp', [[1710, 742], [1820, 742]], BLUE, 'HP3', (1765, 720))
    edge('lifecycle', 'input', [[495, 710], [495, 525]], GRAY, dashed=True)
    edge('lifecycle', 'packet', [[940, 742], [1360, 742], [1360, 655], [1430, 655]],
         GRAY, dashed=True)
    edge('hp', 'recognizer', [[1935, 550], [2230, 550]], BLUE,
         '图像 / 掩膜 · DDR', (2080, 529), en_label='Frames / Masks · DDR')

    edge('app', 'hp', [[2230, 1070], [1935, 1070]], PURPLE,
         '命令 / 资源 · DDR', (2080, 1049), en_label='Commands / Assets · DDR')
    edge('hp', 'upload', [[1820, 985], [1710, 985]], PURPLE, 'HP0', (1765, 964))
    edge('upload', 'router', [[1480, 985], [1410, 985]], PURPLE)
    edge('router', 'command', [[1180, 985], [1110, 985]], PURPLE)
    edge('router', 'assets', [[1295, 1020], [1295, 1110]], PURPLE)
    edge('router', 'palette', [[1410, 1005], [1445, 1005], [1445, 1080],
                              [1595, 1080], [1595, 1110]], PURPLE)
    edge('command', 'raster', [[995, 1020], [995, 1075]], PURPLE)
    edge('assets', 'raster', [[1180, 1155], [1110, 1155]], PURPLE)
    for source, x in [('fill', 745), ('sprite', 885), ('tile', 1030)]:
        edge(source, 'fb', [[x, 1185], [x, 1280]], PURPLE)
    edge('raster', 'swap', [[1098, 1205], [1098, 1230], [1295, 1230], [1295, 1260]],
         GRAY, dashed=True)
    edge('swap', 'fb', [[1180, 1320], [1110, 1320]], GRAY, dashed=True)
    edge('fb', 'scan', [[650, 1312], [590, 1312]], PURPLE)
    edge('palette', 'scan', [[1595, 1200], [1595, 1375], [490, 1375], [490, 1345]], PURPLE)
    edge('scan', 'osd', [[490, 1280], [490, 1200]], PURPLE)
    edge('osd', 'monitor', [[390, 1155], [240, 1155]], PURPLE, 'HDMI', (300, 1134))

    edge('driver', 'control', [[2230, 1482], [1935, 1482]], GRAY,
         'AXI GP', (2080, 1461), dashed=True, both=True)
    for target, y in [('camera_i2c', 385), ('lifecycle', 750), ('osd', 1180)]:
        edge('control', target, [[390, 1482], [365, 1482], [365, y], [390, y]],
             GRAY, dashed=True)
    edge('pc', 'agent', [[2810, 385], [2660, 385]], GRAY,
         'Ethernet', (2735, 364), both=True)
    edge('recognizer', 'app', [[2445, 620], [2445, 1015]], GREEN,
         '手势 / 位置', (2445, 815), en_label='Gesture / Position')
    edge('recognizer', 'hand', [[2660, 595], [2680, 595], [2680, 1260],
                               [2570, 1260], [2570, 1300]], GREEN)
    edge('hand', 'hand_external', [[2660, 1345], [2810, 1345]], GREEN,
         'USB', (2735, 1324))
    box('note', 290, 1590, 2440, 35,
        '蓝：视觉数据    紫：绘图数据    灰虚线：控制 / 状态    ·    图元按命令调度，共享帧缓冲',
        'Blue: vision data    Purple: graphics data    Dashed: control / status    |    Primitives share the framebuffer',
        size=25, kind='text')
    scene = dict(width=3080, height=1640, title='GESTURE PLAY v3.0 PL–PS',
                 subtitle='Expanded functional architecture of independent contest_v3',
                 edge_font_size=23, nodes=nodes, edges=edges)
    return scene, english


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    zh, english = make_scene()
    en = copy.deepcopy(zh)
    for node in en['nodes']:
        node['lines'] = english[node['id']]
        if node['id'] == 'agent':
            node['font_size'] = 25
        if node['id'] == 'command':
            node['font_size'] = 23
        if node['id'] == 'scan':
            node['font_size'] = 22
    for item in en['edges']:
        if 'en_label' in item:
            item['label'] = item['en_label']
    for language, scene in [('zh', zh), ('en', en)]:
        scene['language'] = language
        for item in scene['edges']:
            item.pop('en_label', None)
        (OUT / f'system_{language}.json').write_text(
            json.dumps(scene, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

    paths = ['README.md', 'report/design_report.md', 'board/runtime/deployment_manifest.json',
             'board/runtime/overlay/c6v_candidate.hwh',
             'build/hardware/c6_latency/c6_latency.srcs/sources_1/bd/c6v/c6v.bd',
             'board/runtime/board/pynq_z2/scripts/vision_async_runtime.py',
             'board/runtime/python/pynq_multimodal_game/agent/c6i_video.py',
             'board/runtime/python/pynq_multimodal_game/agent/c6i_shell.py']
    paths += [RTL + p for p in [
        'rtl/axis_rgb_dual_mask_capture.sv', 'rtl/axis_binary_mask_pair.sv',
        'voice-view-game/subprojects/hdmi_input_osd/latency_rtl/axis_rgb_mask_frontend.sv',
        'scene2d_c4m7_core.sv', 'scene2d_c4m3_core.sv', 'scene2d_clear_fill_renderer.sv']]
    hashes = {p: hashlib.sha256((ROOT / p).read_bytes()).hexdigest() for p in paths}
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
    record = dict(source='contest_v3', layout='landscape_bilingual_expanded_v3',
                  runtime_manifest_sha256=hashes[paths[2]], sha256=hashes,
                  verified_modules=required, verified_bus_nets=nets,
                  visual_references=[
                      'https://github.com/VincentttWang/FPGA_SocChina_2025/blob/main/doc/img/System%20Graph.png',
                      'https://xilinx.github.io/PYNQ-ZU/overlays'])
    (OUT / 'evidence.json').write_text(
        json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(json.dumps(dict(output=str(OUT), nodes=len(zh['nodes']),
                          edges=len(zh['edges']), languages=['zh', 'en'], source_checks='PASS')))


if __name__ == '__main__':
    main()
