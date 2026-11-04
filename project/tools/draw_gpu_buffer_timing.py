"""Draw the frozen GPU buffer/presentation mechanism, without hardware access.

Run from repository root: .venv/Scripts/python.exe -B contest_v3/tools/draw_gpu_buffer_timing.py
Requires PySide6. Outputs report/figures/gpu_buffer_timing/01..03 as JSON,
editable draw.io, SVG, PNG and PDF. Next: inspect and assemble the handoff.
"""
from pathlib import Path
import importlib.util
import json
import os
from PySide6.QtGui import QGuiApplication,QFontDatabase

ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'report/figures/gpu_buffer_timing'
spec=importlib.util.spec_from_file_location('renderer',ROOT/'tools/render_vision_diagram.py')
renderer=importlib.util.module_from_spec(spec);spec.loader.exec_module(renderer)
PINK='#bf286e';PALE='#fff0f6';BLUE='#25638d';BP='#edf5fb';TEAL='#197b71';TP='#edf8f5'
GRAY='#697586';GP='#f5f7fa';LINE='#d8dfe7';AP='#fff7e9';AMBER='#a66c22'

class Plate:
    def __init__(self,title,subtitle,number,height=1740):
        self.scene=dict(width=2200,height=height,title=title,subtitle=subtitle,edge_font_size=23,nodes=[],edges=[])
        self.text('kicker',60,24,2080,36,'PYNQ  /  GPU 缓冲与呈现时序  /  '+number,21)
        self.text('title',60,74,2080,80,title,47)
        self.text('subtitle',60,164,2080,48,subtitle,25)
        self.text('footer',60,height-51,2080,33,'GESTURE PLAY · v3.0 / R15b · BUILD_ID 0xC0061000 · 当前源码机制',18)
    def node(self,id,x,y,w,h,label,fill='#ffffff',stroke=LINE,size=26,kind='box'):
        self.scene['nodes'].append(dict(id=id,x=x,y=y,w=w,h=h,lines=label,fill=fill,stroke=stroke,font_size=size,kind=kind));return id
    def text(self,id,x,y,w,h,label,size=25):return self.node(id,x,y,w,h,label,size=size,kind='text')
    def group(self,id,x,y,w,h,label,fill='#ffffff'):return self.node(id,x,y,w,h,label,fill,LINE,27,'group')
    def edge(self,a,b,pts,color=BLUE,label=None,lx=None,ly=None,dashed=False):
        e=dict(source=a,target=b,points=pts,color=color,dashed=dashed)
        if label:e.update(label=label,label_x=lx,label_y=ly)
        self.scene['edges'].append(e)
    def point(self,id,x,y):return self.text(id,x,y,1,1,'',1)
    def save(self,name):
        (OUT/f'{name}.json').write_text(json.dumps(self.scene,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
        renderer.render(self.scene,OUT/name)

def buffers():
    p=Plate('前台持续扫描，后台完成后换页','命令缓冲、图像缓冲和资源缓冲分别管理；双帧缓冲把绘制与 HDMI 扫描分开。','01  缓冲所有权',1700)
    p.group('ps',60,240,2080,275,'PS / 当前页面产生 Scene，共用一个提交入口',TP)
    p.node('owner',100,330,520,112,'菜单 / 游戏 / 视频 / 画布\n页面切换时交接提交权','#ffffff',TEAL,26)
    p.node('compiler',680,330,520,112,'Scene 编译 / 视频包读取\n命令与资源 generation','#ffffff',TEAL,26)
    p.node('dma',1260,330,830,112,'C6IVideoSink → PS DDR 暂存\n拷贝 + flush → 启动 MM2S DMA','#ffffff',TEAL,26)
    p.edge('owner','compiler',[(620,386),(680,386)],TEAL)
    p.edge('compiler','dma',[(1200,386),(1260,386)],TEAL)
    p.text('ps_note',100,465,1990,30,'当前 submit_scene 等待呈现确认后返回；页面切换先停止旧生产者，再 drain 和恢复新资源。',23)
    p.group('pl',60,560,2080,600,'PL / 上传与光栅化 · 100 MHz',BP)
    p.node('router',100,670,260,130,'DMA MM2S / HP0\n64 bit AXIS\n按 magic 分流','#ffffff',BLUE,24)
    p.node('commands',420,670,410,130,'命令 bank 0 / 1\n各 4 KiB · 上传完整后切换','#ffffff',BLUE,25)
    p.node('raster',900,670,440,130,'命令解码 → 光栅化\nCLEAR / BLIT / TILE / RECT','#ffffff',BLUE,25)
    p.group('fb',1410,625,680,470,'两块独立 BRAM 帧缓冲',PALE)
    p.node('back',1450,710,600,112,'B / 后台：本轮写入目标\n320 × 180 × 8 bit = 56.25 KiB','#ffffff',PINK,26)
    p.node('front',1450,900,600,112,'A / 前台：持续被扫描\n完整保留上一幅 token 图像','#ffffff',TEAL,26)
    p.text('fb_flip',1460,838,580,44,'vblank 换显示 bank → ACK 后换写 bank',23)
    p.edge('dma','router',[(2090,386),(2120,386),(2120,535),(40,535),(40,735),(100,735)],BLUE)
    p.edge('router','commands',[(360,735),(420,735)],BLUE)
    p.edge('commands','raster',[(830,735),(900,735)],BLUE)
    p.edge('raster','back',[(1340,766),(1450,766)],PINK)
    p.node('resources',100,890,1240,130,'资源 bank：Atlas / Tilemap / Palette，各自提交\n光栅化启动前检查 Scene 所需 generation；上传资源时先 drain','#ffffff',BLUE,26)
    p.edge('router','resources',[(230,800),(230,890)],BLUE)
    p.edge('resources','raster',[(1120,890),(1120,800)],BLUE)
    p.text('pl_note',100,1072,1240,42,'帧缓冲保存索引 token；扫描期间不读取 PS 的 Scene 包。',24)
    p.group('scan',60,1200,2080,345,'像素时钟域 / 连续扫描 · 74.25 MHz',TP)
    for ident,x,w,label,color in [
        ('read',100,470,'读前台 BRAM\nx / 4，y / 4 → 逻辑像素',TEAL),
        ('palette',630,470,'token → RGB888\n16 组 × 16 色查表',TEAL),
        ('osd',1160,410,'独立 OSD 覆盖\n手圈继续同步',PINK),
        ('hdmi',1630,460,'rgb2dvi → HDMI\n1280 × 720 @ 60 Hz',TEAL)]:
        p.node(ident,x,1310,w,115,label,'#ffffff',color,26)
    for a,b,x1,x2 in [('read','palette',570,630),('palette','osd',1100,1160),('osd','hdmi',1570,1630)]:
        p.edge(a,b,[(x1,1367),(x2,1367)],TEAL)
    p.edge('front','read',[(2050,956),(2120,956),(2120,1180),(40,1180),(40,1367),(100,1367)],TEAL)
    p.text('scan_note',100,1464,1990,44,'扫描路径使用片上存储，不等待 AXI / DDR；本轮尚未完成换页时，继续扫描当前前台。',25)
    p.text('current',80,1582,2040,54,'当前 UPLOAD_RENDER_OVERLAP_ENABLE = 0：上传下一 Scene 与当前渲染串行；绘制与扫描可并行。',24)
    p.save('01_gpu_buffers')

def timing():
    p=Plate('渲染完成 ≠ 已呈现：换页发生在垂直消隐起点','render_done 发起跨时钟请求；像素域换页后回 ACK，写侧才获得可复用的后台。','02  呈现时序',1870)
    p.group('timeline',60,240,2080,700,'一帧成功提交的因果顺序 · 横轴不按实际耗时比例',BP)
    xs=[400,760,1160,1570,1800,2090]
    for i,(x,w,label) in enumerate([(400,360,'上传 + 包接受'),(760,400,'绘制后台 B'),(1160,410,'等待消隐边界'),(1570,230,'ACK 返回'),(1800,290,'提交完成')]):
        p.text('phase'+str(i),x,315,w,45,label,25)
    for i,x in enumerate(xs[:-1]):
        p.point('t'+str(i),x,390);p.point('b'+str(i),x,868)
        p.edge('t'+str(i),'b'+str(i),[(x,390),(x,868)],PINK if i==3 else LINE,dashed=True)
    rows=[('PS / DMA',425),('PL / 后台',545),('HDMI / 前台',665),('完成收据',785)]
    for i,(label,y) in enumerate(rows):p.text('row'+str(i),85,y,285,75,label,26)
    p.node('dma_phase',400,425,360,75,'拷贝 → flush → DMA',TP,TEAL,23)
    p.node('ps_wait',760,425,1040,75,'等待 accepted / render / present 计数与序号',GP,LINE,24)
    p.node('return',1800,425,290,75,'submit_scene 返回',TP,TEAL,23)
    p.node('draw_b',760,545,400,75,'写 B：生成新 token',PALE,PINK,24)
    p.node('frozen_b',1160,545,640,75,'B 已完成；写入停止',GP,LINE,24)
    p.node('next_a',1800,545,290,75,'A 可供下一轮写',PALE,PINK,23)
    p.node('scan_a',400,665,1170,75,'扫描 A / 上一幅图像',TP,TEAL,25)
    p.node('scan_b',1570,665,520,75,'前台切为 B\n随后有效区显示新图像',TP,TEAL,24)
    p.node('accept',400,785,360,75,'accepted 计数增加',GP,BLUE,23)
    p.node('done',760,785,400,75,'render_done / count++',GP,BLUE,23)
    p.node('req',1160,785,410,75,'req toggle 经 2FF 同步',GP,BLUE,23)
    p.node('ack',1570,785,230,75,'ACK 经 2FF',GP,BLUE,22)
    p.node('present',1800,785,290,75,'present count++',GP,BLUE,23)
    p.text('boundary',1400,881,630,35,'换页边界：x = 0，y = 720（vblank_start）',23)
    p.group('ownership',60,980,2080,390,'读写所有权：ACK 交接窗口内也不能写前台',PALE)
    cols=[(100,770),(900,350),(1280,350),(1660,430)]
    for i,(label,(x,w)) in enumerate(zip(['阶段','display_bank','write_bank','允许写像素？'],cols)):
        p.node('h'+str(i),x,1050,w,48,label,PALE,PINK,24)
    states=[('正在渲染 B','A','B','是，仅写 B'),('render_done，等待换页','A','B','否'),('像素域已换页，ACK 尚未返回','B','B','否：指针相同，但写端停用'),('ACK 返回，交接完成','B','A','下一轮可写 A')]
    for r,row in enumerate(states):
        for c,(label,(x,w)) in enumerate(zip(row,cols)):
            p.node('cell'+str(r)+str(c),x,1110+r*53,w,45,label,'#ffffff',LINE,22)
    p.group('late',60,1410,2080,310,'未赶上本次消隐边界：保持旧前台，等待下一次边界',TP)
    p.node('v1',100,1500,460,80,'V₁：同步请求尚不可见\n本次不换页','#ffffff',TEAL,24)
    p.node('late_req',680,1500,700,80,'V₁ 之后请求到达像素域\n前台保持，扫描不会等待渲染器','#ffffff',TEAL,24)
    p.node('v2',1500,1500,590,80,'V₂：请求可见 → 交换 A / B\n随后 ACK 允许写侧交接','#ffffff',TEAL,24)
    p.edge('v1','late_req',[(560,1540),(680,1540)],TEAL)
    p.edge('late_req','v2',[(1378,1540),(1500,1540)],TEAL)
    p.text('cadence',100,1632,1990,45,'720p 时序：1650 × 750 / 74.25 MHz = 16.67 ms / 帧；这是扫描周期，不是渲染耗时。',24)
    p.text('proof',90,1755,2020,54,'呈现须核对 count 与 seq。present_completed_seq 在启动渲染时已写入，单看 seq 不能证明换页完成。',24)
    p.save('02_gpu_present_timing')

def encoding():
    p=Plate('小命令包驱动绘制，索引 token 驱动扫描','Scene 描述怎么画；帧缓冲保存画好的像素索引；调色板在扫描时展开为 RGB。','03  编码与存储',1850)
    p.group('scene',60,240,2080,410,'Scene / 固定 4,160 B，小端 32 bit 字',BP)
    p.node('header',100,330,600,130,'64 B Header / 16 words\nS2DG · frame_id · submit_seq\ncommand_count · 资源 generation','#ffffff',BLUE,25)
    p.node('bank',750,330,1340,130,'4,096 B Command bank = 128 × 32 B\n每条 8 words；未使用区域补 0\nCLEAR 0x01 / TILE 0x02 / BLIT 0x03 / RECT 0x04 / END 0xFF','#ffffff',BLUE,25)
    p.text('rect_label',100,490,600,100,'FILL_RECT 构造示例\nx=10，y=20，w=32，h=16',24)
    p.node('rect',750,490,1340,105,'word0=0x00000004   word1=0x000000F7\nword2=0x0014000A   word3=0x00100020   word4–7=0',GP,LINE,25)
    p.group('pixels',60,690,2080,360,'像素编码 / 素材与帧缓冲使用不同位宽',TP)
    p.node('index4',100,785,550,130,'素材 INDEX4 / 每像素 4 bit\n像素 [1,2,3,4] → 字节 [21,43]hex\nBLIT 遇到 index 0 跳过写入','#ffffff',TEAL,24)
    p.node('token',735,785,670,130,'帧缓冲 token / 每像素 8 bit\n[7:4] 逻辑调色板组 | [3:0] 色号\n0xF7 → 第 15 组，第 7 色','#ffffff',PINK,25)
    p.node('rgb',1490,785,600,130,'Palette 查表 → RGB888\n逻辑 16 组 × 每组 16 色\n物理 active bank 为独立的 0 / 1','#ffffff',TEAL,25)
    p.edge('index4','token',[(650,850),(735,850)],TEAL)
    p.edge('token','rgb',[(1405,850),(1490,850)],PINK)
    p.text('token_note',100,965,1990,44,'逻辑调色板组、物理调色板 bank、命令 bank、帧缓冲 bank 是四种不同索引，不能合并画成一组。',24)
    p.group('size',60,1090,2080,360,'双帧缓冲的逻辑容量 / 同为 320 × 180，按像素编码直接计算',PALE)
    p.text('size8',100,1190,570,60,'当前：2 × 320 × 180 × 1 B',25)
    p.node('bar8',710,1190,400,60,'112.5 KiB','#f4c6db',PINK,24)
    p.text('size24',100,1290,570,60,'对照：2 × 320 × 180 × 3 B',25)
    p.node('bar24',710,1290,1200,60,'337.5 KiB / RGB888',BP,BLUE,24)
    p.text('size_note',100,1385,1990,40,'8 bit token 容量为同分辨率 RGB888 的 1/3；不含 Palette、Atlas、Tilemap 和 BRAM 块取整。',23)
    p.group('resource',60,1490,2080,245,'资源提交与视频节拍',GP)
    p.node('commit',100,1575,930,105,'Atlas / Tilemap：渲染空闲时提交\nPalette：独立等 vblank，ACK 后 generation 生效','#ffffff',BLUE,24)
    p.node('video',1100,1575,990,105,'视频：必要时 Palette → 每帧 Atlas → Scene\n目标 30 fps；每帧串行提交，与 60 Hz HDMI 扫描分开','#ffffff',TEAL,24)
    p.text('cadence_note',80,1760,2040,38,'资源上传前 drain；每份资源确认 accepted 与 generation 后，再提交引用这些版本的 Scene。',24)
    p.save('03_gpu_encoding_storage')

def main():
    OUT.mkdir(parents=True,exist_ok=True)
    app=QGuiApplication([])
    if os.name=='nt':
        for name in ('msyh.ttc','msyhbd.ttc','arial.ttf'):QFontDatabase.addApplicationFont('C:/Windows/Fonts/'+name)
    buffers();timing();encoding()

if __name__=='__main__':main()
