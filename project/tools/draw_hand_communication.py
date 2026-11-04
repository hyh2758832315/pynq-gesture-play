"""Draw three source-grounded hand-control technical plates without hardware access.

Run from contest_v3: python -B tools/draw_hand_communication.py
Requires an existing Python environment with PySide6.
Outputs: report/figures/hand_communication/{01_logic,02_sequence,03_packet}.*
Formats: editable draw.io, SVG, PNG and vector PDF; scene JSON and source hashes.
Next: inspect PNG/PDF typography and use the same plates across video/report/poster.
"""
from pathlib import Path
import hashlib
import importlib.util
import json
import os

from PySide6.QtWidgets import QApplication
from PySide6.QtGui import QFontDatabase

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'report/figures/hand_communication'
spec = importlib.util.spec_from_file_location('diagram_renderer', ROOT/'tools/render_system_diagram.py')
renderer = importlib.util.module_from_spec(spec)
spec.loader.exec_module(renderer)
PINK='#bf286e'; PALE='#fff0f6'; BLUE='#25638d'; BP='#edf5fb'
TEAL='#197b71'; TP='#edf8f5'; AMBER='#a66c22'; AP='#fff7e9'
GRAY='#697586'; GP='#f5f7fa'; LINE='#d8dfe7'; DARK='#172b3a'


class Plate:
    def __init__(self, title, subtitle, number, height=1400):
        self.scene=dict(width=2200,height=height,title=title,subtitle=subtitle,
                        edge_font_size=24,nodes=[],edges=[])
        self.text('kicker',60,24,2080,36,'PYNQ  /  灵巧手驱动与低负荷通信  /  '+number,21)
        self.text('title',60,74,2080,80,title,49)
        self.text('subtitle',60,164,2080,48,subtitle,25)
        self.text('footer',60,height-52,2080,34,
                  'GESTURE PLAY  ·  v3.0 / 手部运行时 R16  ·  按已交付源码绘制  ·  技术示意',18)

    def node(self,id,x,y,w,h,label,fill='#ffffff',stroke=LINE,size=26,kind='box'):
        self.scene['nodes'].append(dict(id=id,x=x,y=y,w=w,h=h,lines=label,
                                       fill=fill,stroke=stroke,font_size=size,kind=kind))
        return id

    def text(self,id,x,y,w,h,label,size=25):
        return self.node(id,x,y,w,h,label,size=size,kind='text')

    def group(self,id,x,y,w,h,label,fill='#ffffff',stroke=LINE):
        return self.node(id,x,y,w,h,label,fill,stroke,27,'group')

    def edge(self,a,b,points,color=PINK,label=None,lx=None,ly=None,dashed=False):
        e=dict(source=a,target=b,points=points,color=color,dashed=dashed)
        if label:e.update(label=label,label_x=lx,label_y=ly)
        self.scene['edges'].append(e)

    def point(self,id,x,y):
        return self.text(id,x,y,1,1,'',1)

    def save(self,name):
        (OUT/(name+'.json')).write_text(json.dumps(self.scene,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
        renderer.render(self.scene,OUT/name)


def logic():
    p=Plate('只消费最新状态，动作不会排队','已观察 ≠ 已消费；动作获批时开始计时，空闲边界再读取当前有效状态','01  消费逻辑')
    p.group('flow',60,240,2080,360,'01 / 从视觉状态到动作批准')
    boxes=[('input',100,'读取最新状态\n手势 · 帧号 · 来源时间',BP,BLUE),
           ('valid',620,'身份与时效检查\n来源一致，输入仍新鲜',TP,TEAL),
           ('ready',1140,'动作状态检查\nREADY_IDLE 才能提交',PALE,PINK),
           ('change',1660,'姿态变化检查\n不同姿态 → 批准动作',PALE,PINK)]
    for id,x,label,fill,c in boxes:p.node(id,x,333,440,105,label,fill,c,27)
    for a,b,x in [('input','valid',540),('valid','ready',1060),('ready','change',1580)]:
        p.edge(a,b,[(x,385),(x+80,385)])
    for id,x,label in [('n1',100,'单个最新槽\n新帧覆盖旧帧'),('n2',620,'过期输入进入来源恢复流程\n读取不刷新原始 source_at'),
                       ('n3',1140,'MOVING：只更新最新状态\n保留空闲后消费的资格'),('n4',1660,'相同姿态继续保持\n避免重复下发动作')]:
        p.text(id,x,475,440,80,label,24)
    p.group('timing',60,635,2080,490,'02 / 忙时发生两次变化，下一次只执行最后的剪刀手势')
    x0=390; scale=1290; window_end=x0+scale
    p.text('axislabel',85,737,250,55,'示意时间',24)
    p.point('tbegin',x0,765);p.point('tend',2070,765)
    p.edge('tbegin','tend',[(x0,765),(2070,765)],GRAY)
    for k,fraction,label in [('start',0,'0 · 握拳获批'),('change1',.2,'t₁'),('change2',.9,'t₂'),('window_end',1,'t')]:
        x=x0+fraction*scale
        # Offset the two nearby time labels on separate vertical levels.
        p.text(k,x-105,686 if fraction!=.9 else 726,210,38,label,22)
        p.point(k+'top',x,766);p.point(k+'bottom',x,1078)
        p.edge(k+'top',k+'bottom',[(x,766),(x,1078)],LINE,dashed=True)
    p.text('mailboxlabel',85,808,250,60,'最新状态槽',27)
    p.node('fist',x0,812,.2*scale,62,'握拳',BP,BLUE,25)
    p.node('paper',x0+.2*scale,812,.7*scale,62,'张手（随后被剪刀覆盖）',GP,GRAY,25)
    p.node('scissors',x0+.9*scale,812,2070-(x0+.9*scale),62,'剪刀',TP,TEAL,25)
    p.text('actionlabel',85,936,250,60,'执行中的动作',27)
    p.node('current',x0,940,scale,78,'当前握拳动作窗口 · 时长 t（从批准时起算）',PALE,PINK,27)
    p.node('next',window_end,940,2070-window_end,78,'下一动作：剪刀',TP,TEAL,26)
    p.edge('scissors','next',[(1900,874),(1900,940)],TEAL,'读取最新有效状态',1900,916)
    p.text('timeline_note',370,1043,1660,44,'0 < t₁ < t₂ < t；期间的张手不会补播。到点且当前动作完成后，才可批准下一动作。',22)
    p.node('same',60,1160,660,112,'同态 → 保持\n最新姿态未变，不重复播放',GP,LINE,25)
    p.node('default',770,1160,660,112,'default → 无需额外等待\n下发默认目标后即可接受后续状态',GP,LINE,25)
    p.node('scope',1480,1160,660,112,'执行进度与物理到位分开\n正常播放不持续采集位置反馈',GP,LINE,25)
    p.save('01_logic')


def sequence():
    p=Plate('按阶段通信，等待期间不轮询位置','PYNQ PS 独立动作进程 → USB 串口 / SDK → 17 个电机；每次写入仍检查状态应答','02  通信时序',1600)
    p.group('startup',60,340,2080,280,'启动检查',TP)
    p.group('playback',60,650,2080,480,'正常播放',PALE)
    p.group('exit',60,1160,2080,345,'退出 / 卸力',AP)
    for id,x,label,fill,c in [('ps',580,'PS 动作调度',PALE,PINK),('sdk',1140,'SDK / 有界串口事务',BP,BLUE),('motor',1840,'电机 ID i',TP,TEAL)]:
        p.node(id,x-195,245,390,70,label,fill,c,26)
        p.point(id+'_end',x,1480)
        p.edge(id,id+'_end',[(x,315),(x,1480)],LINE,dashed=True)
    def msg(id,a,b,y,label,c=PINK):
        xs={'ps':580,'sdk':1140,'motor':1840};x1,x2=xs[a],xs[b]
        p.point(id+'a',x1,y);p.point(id+'b',x2,y)
        p.edge(id+'a',id+'b',[(x1,y),(x2,y)],c,label,(x1+x2)/2,y-14)
    p.text('startnote',86,430,270,100,'载入模型与标定\n检查后受控使能',24)
    msg('connect','ps','sdk',405,'连接并启动检查')
    msg('read','sdk','motor',465,'逐 ID：READ(0x10, 48 B)',BLUE)
    msg('feedback','motor','sdk',520,'反馈块 + 状态，检查通信 / error',TEAL)
    msg('checked','sdk','ps',580,'完成检查后进入 READY_IDLE',TEAL)
    p.text('playnote',86,780,270,155,'每个阶段\n仅写需要变化的目标\n各 ID 顺序执行',24)
    msg('stage','ps','sdk',730,'预编译目标 (ID, raw, speed)')
    msg('write','sdk','motor',790,'WritePos：13 B 指令',BLUE)
    msg('ack','motor','sdk',850,'6 B 状态应答（非位置到位反馈）',TEAL)
    msg('return','sdk','ps',910,'通信成功且 error = 0',TEAL)
    p.node('wait',420,952,520,74,'Event.wait(阶段剩余时间)', '#ffffff',PINK,25)
    p.text('quiet',1050,951,980,82,'等待时不循环 READ 位置\n相同 (raw, speed) 命中缓存则跳过写入',25)
    p.text('nextstage',450,1050,1580,45,'下一阶段复用同一串口 owner；有界事务等待，保留取消 / 超时检查。',23)
    p.text('stopnote',86,1300,270,95,'逐电机确认 OFF\n再关闭串口',25)
    msg('off','ps','sdk',1225,'退出请求')
    msg('offwrite','sdk','motor',1270,'WRITE torque(0x28) = 0',BLUE)
    msg('offack','motor','sdk',1315,'写入状态应答',TEAL)
    msg('offcheck','sdk','motor',1360,'READ torque(0x28)',BLUE)
    msg('offresult','motor','sdk',1405,'读回值 = 0，确认 OFF',TEAL)
    msg('closed','sdk','ps',1460,'全部确认后释放 / 关闭',TEAL)
    p.save('02_sequence')


def packet():
    p=Plate('从关节目标到串口字节流','SCSCL 单电机位置指令 · 1 Mbaud / 8N1 · 16 位字段高字节在前','03  编码与校验',1450)
    for id,x,label,fill,c in [('pose',70,'关节目标 θ\n结合标定与传动映射',BP,BLUE),
        ('raw',610,'量化为 raw\nround(电机角度 / POS_SCALE)',TP,TEAL),
        ('encoded',1150,'预编译目标元组\n(ID, raw, speed)',PALE,PINK),
        ('tx',1690,'逐 ID 编码发送\n并检查每条状态应答',PALE,PINK)]:
        p.node(id,x,245,440,110,label,fill,c,25)
    for a,b,x in [('pose','raw',510),('raw','encoded',1050),('encoded','tx',1590)]:
        p.edge(a,b,[(x,300),(x+100,300)])
    p.text('example',70,395,2060,52,'编码示例  ·  ID = 1   /   raw = 2048 (0x0800)   /   time = 0   /   speed = 500 (0x01F4)',28)
    values=['FF','FF','01','09','03','2A','08','00','00','00','01','F4','CB']
    labels=['帧头','帧头','ID','LENGTH','WRITE','起始地址','POS 高','POS 低','TIME 高','TIME 低','SPEED 高','SPEED 低','CHECKSUM']
    fills=[GP,GP,AP,GP,PALE,BP,TP,TP,TP,TP,TP,TP,AP]
    colors=[GRAY,GRAY,AMBER,GRAY,PINK,BLUE,TEAL,TEAL,TEAL,TEAL,TEAL,TEAL,AMBER]
    x0=60;cw=160
    for i,(v,label,fill,c) in enumerate(zip(values,labels,fills,colors)):
        p.text('index'+str(i),x0+i*cw,467,cw,32,f'byte {i}',18)
        p.node('byte'+str(i),x0+i*cw,513,cw,78,v,fill,c,35)
        p.text('field'+str(i),x0+i*cw,605,cw,42,label,21)
    p.text('lengthnote',60,665,2080,46,'LENGTH = 7 个参数字节 + 2 = 9    ｜    起始地址 0x2A    ｜    连续写入位置、时间、速度，共 6 B 数据',25)
    p.node('checksum',60,750,1190,120,'校验和 = ~(ID + LENGTH + 指令 + 参数之和) & 0xFF\n示例：~0x0134 & 0xFF = 0xCB',AP,AMBER,27)
    p.node('endian',1290,750,850,120,'高字节在前：2048 → 08 00\n当前 scscl 构造设置 scs_end = 1',BP,BLUE,27)
    p.group('ackpanel',60,915,1060,260,'成功状态应答 / 6 B')
    for i,(v,label) in enumerate(zip(['FF','FF','01','02','00','FC'],['帧头','帧头','ID','LENGTH','ERROR','校验和'])):
        p.node('ack'+str(i),100+i*160,1000,145,66,v,TP,TEAL,31)
        p.text('ackfield'+str(i),100+i*160,1077,145,40,label,21)
    p.node('handling',1160,970,980,160,'接收检查：帧头、ID、长度、校验和、error\n成功 → 记录本次目标缓存\n错误 / 超时 → 清除缓存，交由 owner 处理',GP,LINE,27)
    p.node('cost',60,1220,2080,116,'单次成功写入往返：13 + 6 = 19 B；仅按 1 Mbaud / 8N1 计算的线速下限为 190 μs\n以上为编码示例与理论线速，不含 USB、设备处理或调度耗时；示例未向实体电机发送。',GP,LINE,25)
    p.save('03_packet')


def main():
    OUT.mkdir(parents=True,exist_ok=True)
    app=QApplication([])
    if os.name=='nt':
        for f in ['msyh.ttc','msyhbd.ttc','arial.ttf']:
            QFontDatabase.addApplicationFont('C:/Windows/Fonts/'+f)
    logic();sequence();packet()
    sources=['board/runtime/hand-runtime/assets/config.yaml',
             'board/runtime/hand_child/serial_motion_receiver.py',
             'board/runtime/python/pynq_multimodal_game/hand_serial_session.py']
    sources += ['board/runtime/hand-runtime/src/pynq_usb_hand/'+n+'.py' for n in
                ['gesture_consumer','controller','motion','orca_backend','transport','actuator_owner']]
    save={n:hashlib.sha256((ROOT/n).read_bytes()).hexdigest() for n in sources}
    sdk=ROOT.parent/'subprojects/pynq_usb_hand/.venv/Lib/site-packages/scservo_sdk'
    sdk_files=['scscl.py','protocol_packet_handler.py','port_handler.py','scservo_def.py']
    sdk_hashes={n:hashlib.sha256((sdk/n).read_bytes()).hexdigest()
                for n in sdk_files if (sdk/n).is_file()}
    (OUT/'evidence.json').write_text(json.dumps(dict(baseline='contest_v3 / R15b / R16',
        sources=save,local_sdk=dict(path=str(sdk),sha256=sdk_hashes,
        scope='Local SDK used for the offline packet check; not a live-board SDK capture.'),
        packet_test='packet_check.json',notes=[
        'Timeline input times are illustrative, not measured latency.',
        'Normal playback uses per-ID WritePos with status replies, not broadcast SyncWrite.',
        'Startup row summarizes checks and arm; shutdown row summarizes writes and readback.',
        'Packet example verified with local scservo_sdk and memory transport; no device opened.',
        'No CPU percentage, physical arrival time, mechanical degree-of-freedom claim.']),ensure_ascii=False,indent=2)+'\n',encoding='utf-8')


if __name__=='__main__':
    main()
