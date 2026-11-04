"""Draw source-grounded vision/dual-follow plates without hardware access.

Run from contest_v3: python -B tools/draw_vision_dual_follow.py
Requires PySide6. Outputs report/figures/vision_dual_follow/01..03 in JSON,
draw.io, SVG, PNG and PDF. Next: inspect previews and retain source/metric scopes.
"""
from pathlib import Path
import importlib.util
import json
import os
from PySide6.QtWidgets import QApplication
from PySide6.QtGui import QFontDatabase

ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'report/figures/vision_dual_follow'
spec=importlib.util.spec_from_file_location('renderer',ROOT/'tools/render_vision_diagram.py')
renderer=importlib.util.module_from_spec(spec);spec.loader.exec_module(renderer)
PINK='#bf286e';PALE='#fff0f6';BLUE='#25638d';BP='#edf5fb';TEAL='#197b71';TP='#edf8f5'
GRAY='#697586';GP='#f5f7fa';LINE='#d8dfe7';AP='#fff7e9';AMBER='#a66c22'


class Plate:
    def __init__(self,title,subtitle,number,height=1660):
        self.scene=dict(width=2200,height=height,title=title,subtitle=subtitle,edge_font_size=23,nodes=[],edges=[])
        self.text('kicker',60,24,2080,36,'PYNQ  /  视觉识别与双路跟随  /  '+number,21)
        self.text('title',60,74,2080,80,title,47)
        self.text('subtitle',60,164,2080,48,subtitle,25)
        self.text('footer',60,height-51,2080,33,'GESTURE PLAY  ·  v3.0 / R15b / R16  ·  BUILD_ID 0xC0061000  ·  源码机制示意',18)
    def node(self,id,x,y,w,h,label,fill='#ffffff',stroke=LINE,size=26,kind='box'):
        self.scene['nodes'].append(dict(id=id,x=x,y=y,w=w,h=h,lines=label,fill=fill,stroke=stroke,font_size=size,kind=kind))
        return id
    def text(self,id,x,y,w,h,label,size=25):return self.node(id,x,y,w,h,label,size=size,kind='text')
    def group(self,id,x,y,w,h,label,fill='#ffffff'):return self.node(id,x,y,w,h,label,fill,LINE,27,'group')
    def edge(self,a,b,pts,color=BLUE,label=None,lx=None,ly=None,dashed=False):
        e=dict(source=a,target=b,points=pts,color=color,dashed=dashed)
        if label:e.update(label=label,label_x=lx,label_y=ly)
        self.scene['edges'].append(e)
    def point(self,id,x,y):return self.text(id,x,y,1,1,'',1)
    def marker(self,id,cx,cy,fist=False):
        r=17 if fist else 25;c='#ff0000' if fist else '#00b73b'
        self.node(id,cx-r,cy-r,2*r,2*r,'','#ffffff',c,1,'ellipse')
        self.node(id+'_dot',cx-5,cy-5,10,10,'',c,c,1,'ellipse')
    def save(self,name):
        (OUT/f'{name}.json').write_text(json.dumps(self.scene,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
        renderer.render(self.scene,OUT/name)


def overview():
    p=Plate('一帧观察，位置与类别分别跟随','位置驱动 HDMI 手圈；类别驱动实体手。两路都读取最新状态，互不消费对方的输入。','01  总览',1680)
    p.group('pl',60,240,2080,430,'PL / 逐像素处理与双掩膜',BP)
    p.node('camera',100,335,270,105,'OV5640 / DVP\n1280 × 720', '#ffffff',BLUE,27)
    p.node('area',410,335,310,105,'2 × 2 区域缩减\n640 × 360', '#ffffff',BLUE,27)
    p.node('hsv',760,335,330,105,'BGR → HSV\n肤色阈值判定', '#ffffff',BLUE,27)
    p.node('raw',1190,310,320,90,'原掩膜 + 对齐 FIFO\nraw：0 或 255', '#ffffff',TEAL,25)
    p.node('filtered',1190,465,320,105,'9 × 9 膨胀\n5 × 5 固定权重平滑', '#ffffff',TEAL,25)
    p.node('dms',1620,375,470,115,'逐像素配对 → DMS1\nraw + filtered + 帧身份', '#ffffff',BLUE,26)
    p.edge('camera','area',[(370,387),(410,387)])
    p.edge('area','hsv',[(720,387),(760,387)])
    p.edge('hsv','raw',[(1090,387),(1140,387),(1140,355),(1190,355)],TEAL)
    p.edge('hsv','filtered',[(1090,387),(1140,387),(1140,517),(1190,517)],TEAL)
    p.edge('raw','dms',[(1510,355),(1560,355),(1560,410),(1620,410)],TEAL)
    p.edge('filtered','dms',[(1510,517),(1560,517),(1560,455),(1620,455)],TEAL)
    p.text('thresholds',100,474,990,92,'当前配置：H 0–20 / S 20–255 / V 70–255\n缩减逐通道计算：(四像素之和 + 2) >> 2',25)
    p.text('pl_note',100,606,1990,40,'RGB 同时由 VDMA 写入 DDR；PS 仅在预览需要时复制 RGB。识别使用双掩膜。',24)
    p.group('ps',60,710,2080,270,'PS / 完成帧快照、最新帧槽与识别',TP)
    for id,x,w,label in [('decode',100,405,'DMA 完成 / DMS1 校验\n复制完成后释放 DMA token'),
                         ('latest',575,405,'采集线程持续读取\n最新帧槽容量 = 1'),
                         ('analysis',1050,405,'轮廓 / 凸包 / 凸缺陷\n位置质心 + 三态确认'),
                         ('publish',1525,565,'发布同帧观察\n位置、类别、帧号、原始来源时间')]:
        p.node(id,x,800,w,108,label,'#ffffff',TEAL,25)
    for a,b,x1,x2 in [('decode','latest',505,575),('latest','analysis',980,1050),('analysis','publish',1455,1525)]:
        p.edge(a,b,[(x1,854),(x2,854)],TEAL)
    p.edge('dms','decode',[(1855,490),(2115,490),(2115,690),(40,690),(40,854),(100,854)],BLUE)
    p.text('mailbox_note',120,928,1940,36,'新帧覆盖待处理旧帧；识别只取最新可用快照。CPU 快照的 ready 时间保留到结果消费者。',23)
    p.group('display',60,1060,1000,465,'A / HDMI 位置跟随',PALE)
    p.group('hand',1140,1060,1000,465,'B / 灵巧手类别跟随',TP)
    p.edge('publish','display',[(1807,908),(1807,1020),(560,1020),(560,1060)],PINK)
    p.edge('publish','hand',[(1807,908),(1807,1020),(1640,1020),(1640,1060)],TEAL)
    p.node('position_slot',100,1160,420,110,'ObservationHub 最新快照\n位置有效性与分类分离','#ffffff',PINK,25)
    p.node('osd',580,1160,440,110,'独立 OSD 线程 → MMIO\nPL 在帧边界切换覆盖参数','#ffffff',PINK,25)
    p.edge('position_slot','osd',[(520,1215),(580,1215)],PINK)
    p.node('hand_slot',1180,1160,420,110,'分类快照 peek\n不消费游戏 / 菜单事件','#ffffff',TEAL,25)
    p.node('owner',1660,1160,440,110,'独立动作 owner → USB SDK\n按 t 窗口执行最新类别','#ffffff',TEAL,25)
    p.edge('hand_slot','owner',[(1600,1215),(1660,1215)],TEAL)
    p.text('display_rules',110,1315,900,94,'有效位置：显示亮绿圈；确认握拳：红圈缩小\n应用画面暂停时，独立覆盖通路仍可更新',25)
    p.text('hand_rules',1190,1315,900,94,'类别待定：保持已批准姿态；明确无手：default\n动作忙时只更新最新状态，后续不补播旧动作',25)
    p.text('display_impl',110,1440,900,43,'最终扫描上叠加 · 常量查表画圈 · 3 像素周期流水',22)
    p.text('hand_impl',1190,1440,900,43,'页面授权 / 暂停交接仍由 owner 管理',22)
    p.text('preview_note',70,1550,2060,48,'PC 回传是按需观察分支：先发布识别结果，再处理 RGB 转换 / 标注 / 编码。',24)
    p.save('01_vision_dual_follow')


def recognition():
    p=Plate('位置可先跟随，类别经过多帧确认','确定手在哪里，与确定是握拳 / 剪刀 / 张手，使用不同特征与有效性条件。','02  识别逻辑',1690)
    p.group('features',60,240,2080,355,'从双掩膜得到几何特征',TP)
    for id,x,label in [('contour',100,'滤波掩膜 → 外轮廓\n候选面积 ≥ 2000 px²'),
                       ('select',620,'选取当前目标\n面积 + 重叠 + 距离连续性'),
                       ('shape',1140,'轮廓 / 凸包 / 凸缺陷\n提取 A、Aₕ、n'),
                       ('center',1660,'原掩膜 ∩ 选中轮廓\n像素矩得到位置质心')]:
        p.node(id,x,325,440,112,label,'#ffffff',TEAL,25)
    for a,b,x in [('contour','select',540),('select','shape',1060),('shape','center',1580)]:
        p.edge(a,b,[(x,381),(x+80,381)],TEAL)
    p.text('score',100,475,990,78,'候选按面积保留至多 8 个\n评分 = A/Amax + 2·IoU + max(0, 1−3d)',24)
    p.text('centroid',1150,475,950,78,'cx = Σx / N，cy = Σy / N\n仅统计原掩膜选中像素，排除膨胀新增区域',24)
    p.group('rules',60,635,1010,490,'三态启发式规则',BP)
    p.text('definitions',95,710,940,75,'r = (Aₕ − A) / A × 100%\nn = 合格凸缺陷数 + 1（形状特征）',27)
    rule_rows=[('握拳 / 0','n = 1 且 r < 15%'),('剪刀 / 2','n = 2 且 r ≥ 15%'),('张手 / 5','3 ≤ n ≤ 5 且 18% ≤ r ≤ 55%')]
    for i,(name,condition) in enumerate(rule_rows):
        y=814+i*76
        p.node('rlabel'+str(i),95,y,245,62,name,'#ffffff',BLUE,25)
        p.text('rcond'+str(i),350,y,680,62,condition,25)
    p.text('defects',95,1048,940,45,'凸缺陷条件：夹角 ≤ 90°，深度 > 随手尺寸缩放的阈值',22)
    p.group('votes',1130,635,1010,490,'最近 5 帧内计票，当前帧必须同类',PALE)
    p.text('vlegend',1170,702,930,55,'同类出现 ≥ 3 次 → 确认；否则 PENDING',25)
    for i,(raw,stable) in enumerate([('0','待定'),('0','待定'),('0','握拳'),('2','待定'),('2','待定'),('2','剪刀')]):
        x=1225+i*145
        p.text('frame'+str(i),x-57,790,114,42,f'F{i+1}',23)
        p.node('raw'+str(i),x-57,843,114,56,raw,'#ffffff',PINK,25)
        p.text('stable'+str(i),x-63,915,126,43,stable,22)
        p.marker('marker'+str(i),x,1000,fist=stable=='握拳')
    p.text('vote_note',1170,1057,930,37,'构造序列示例；位置均有效。圆圈示意不按像素比例。',20)
    p.group('output_meaning',60,1170,2080,390,'同帧观察的两种用途')
    for id,x,w,label in [('th0',100,580,'观察状态'),('th1',730,640,'HDMI 手圈'),('th2',1420,680,'灵巧手')]:
        p.text(id,x,1230,w,46,label,26)
    rows=[('位置有效 / 类别待定','绿圈继续跟随当前质心','保持已批准姿态'),
          ('稳定确认握拳','红圈缩小，仍跟随当前质心','在可执行边界采用握拳'),
          ('明确无手 / 来源过期','无有效新鲜位置 → 隐藏','无手 → default；过期 → 恢复等待')]
    for i,(a,b,c) in enumerate(rows):
        y=1297+i*75
        for j,(x,w,label) in enumerate([(100,580,a),(730,640,b),(1420,680,c)]):
            p.node(f'cell{i}_{j}',x,y,w,59,label,GP,LINE,24)
    p.text('caveat',75,1590,2050,40,'当前分类依据为肤色与几何规则；多帧确认次数表示时序稳定性。',23)
    p.save('02_recognition_logic')


def encoding():
    p=Plate('双掩膜编码与无阻塞 OSD 提交','DMS1 保证同帧数据完整；OSD 用冻结 mailbox 跨时钟，在 HDMI 帧边界更新。','03  编码与时序',1810)
    p.group('packet',60,240,2080,485,'DMS1 / 每帧 460,864 B：像素对 460,800 B + 尾部 64 B',BP)
    for i,(label,fill,c) in enumerate([('raw[0]\n8 bit',TP,TEAL),('filtered[0]\n8 bit',PALE,PINK),
                                      ('raw[1]\n8 bit',TP,TEAL),('filtered[1]\n8 bit',PALE,PINK)]):
        p.node('byte'+str(i),100+i*225,335,225,91,label,fill,c,25)
    p.node('rest',1050,335,350,91,'… 640 × 360 像素\n内存字节顺序','#ffffff',BLUE,24)
    p.node('tail',1460,335,630,91,'16 × uint32 尾部\n小端布局；CRC32 覆盖此前全部字节','#ffffff',BLUE,24)
    p.text('data_types',100,453,1990,45,'raw 仅为 0/255；filtered 为 0–255 平滑值。每个 32 bit 负载字打包两个像素对。',24)
    chunks=[('身份','MAGIC / ABI\nframe_id / config_id / epoch'),
            ('几何与长度','width / height / pixels\npayload_bytes / status'),
            ('配置与格式','6 个 HSV 阈值字节\nPAIR_FORMAT = 0x00010802'),
            ('末尾校验','保留字为 0\nCRC32：多项式 0xEDB88320')]
    for i,(label,body) in enumerate(chunks):
        p.node('tailgroup'+str(i),100+i*510,535,460,125,label+'\n'+body,'#ffffff',BLUE,24)
    p.group('regs',60,765,2080,345,'OSD / 6 个 32 bit 影子寄存器 + COMMIT',PALE)
    reg=[('0x10 / FLAGS','enable · valid · fist'),('0x14 / XY','X | (Y << 16)'),('0x18 / 保留','0'),
         ('0x1C / TTL','剩余帧数 << 16'),('0x20 / HAND_SEQ','新观察序号'),('0x24 / 保留','0')]
    for i,(a,b) in enumerate(reg):p.node('reg'+str(i),90+i*340,850,320,100,a+'\n'+b,'#ffffff',PINK,24)
    p.text('osd_rule',100,987,1990,80,'先读 BUSY：忙则跳过本次提交，不排队；空闲时写 6 个字，再写 0x08 = 1。\n重复帧不刷新原始来源时间；250 ms 新鲜度预算换算为剩余扫描帧，序号重复不续命。',24)
    p.group('timing',60,1150,2080,520,'跨时钟提交 / 控制线程与像素扫描解耦')
    for id,x,label,fill,c in [('ps',430,'PS OSD 线程',PALE,PINK),('axi',1090,'AXI-Lite mailbox',BP,BLUE),('pix',1800,'像素时钟域',TP,TEAL)]:
        p.node(id,x-210,1230,420,65,label,fill,c,25)
        p.point(id+'end',x,1650);p.edge(id,id+'end',[(x,1295),(x,1650)],LINE,dashed=True)
    def msg(id,a,b,y,label,color):
        xs={'ps':430,'axi':1090,'pix':1800}
        p.point(id+'a',xs[a],y);p.point(id+'b',xs[b],y)
        p.edge(id+'a',id+'b',[(xs[a],y),(xs[b],y)],color,label,(xs[a]+xs[b])/2,y-14)
    msg('commit','ps','axi',1350,'COMMIT：冻结数据，翻转 req',PINK)
    msg('pending','axi','pix',1415,'req 经 2FF；捕获 pending_cfg',BLUE)
    p.node('boundary',1545,1460,510,64,'帧边界：切换 active_cfg','#ffffff',TEAL,24)
    msg('ack','pix','axi',1580,'切换后 ACK 返回，经 2FF 同步',TEAL)
    msg('ready','axi','ps',1640,'BUSY 清除，可提交下一份观察',PINK)
    p.text('rate_note',75,1700,2050,48,'OSD 线程目标 30 Hz，HDMI 扫描 60 Hz；这些是配置节拍，不能替代实际识别 FPS 或端到端延迟。',23)
    p.save('03_dms1_osd_timing')


def main():
    OUT.mkdir(parents=True,exist_ok=True)
    app=QApplication([])
    if os.name=='nt':
        for name in ('msyh.ttc','msyhbd.ttc','arial.ttf'):QFontDatabase.addApplicationFont('C:/Windows/Fonts/'+name)
    overview();recognition();encoding()


if __name__=='__main__':main()
