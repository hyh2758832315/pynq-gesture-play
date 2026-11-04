"""Generate an evidence-bound diagram of this independent v3.0 package.

Run from repository root:
 .venv/Scripts/python.exe -B contest_v3/tools/draw_pl_ps_system.py
Then render the output JSON with tools/render_system_diagram.py.
Outputs: report/figures/pl_ps_v3/{system.json,evidence.json}; next: inspect exports.
No board access and no modification of the frozen runtime or original manifest.
"""
import hashlib
import json
from pathlib import Path
import xml.etree.ElementTree as ET

ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'report/figures/pl_ps_v3'
BLUE='#286b95';GREEN='#247663';PURPLE='#78549b';GRAY='#64748b'


def main():
    OUT.mkdir(parents=True,exist_ok=True)
    nodes=[];edges=[]
    def box(key,x,y,w,h,lines,fill='#ffffff',stroke=GRAY,size=25,kind='box'):
        nodes.append(dict(id=key,x=x,y=y,w=w,h=h,lines=lines,fill=fill,stroke=stroke,font_size=size,kind=kind))
    def edge(s,t,points,color=GRAY,label='',pos=None,dashed=False,both=False):
        e=dict(source=s,target=t,points=points,color=color,dashed=dashed,both=both)
        if label:e.update(label=label,label_x=pos[0],label_y=pos[1])
        edges.append(e)
    box('title',40,20,2320,62,'GESTURE PLAY v3.0  |  PL–PS 系统架构',size=40,kind='text')
    box('subtitle',40,88,2320,38,'PYNQ-Z2 · Zynq-7020 · xc7z020clg400-1  /  冻结运行包 R15b · 手部运行时 R16 · BUILD_ID 0xC0061000',size=21,kind='text')
    box('soc',350,165,1700,1340,'Zynq-7000 SoC  ·  板内软硬件分工',fill='#ffffff',stroke='#344e61',size=27,kind='group')
    box('pl',375,230,1650,660,'PL  /  可编程逻辑',fill='#f7fafd',stroke='#7396ad',size=28,kind='group')
    box('vision',395,295,720,570,'视觉前端  /  Vision pipeline',fill='#edf6fb',stroke=BLUE,size=27,kind='group')
    box('graphics',1200,295,800,570,'渲染 GPU  /  Scene2D graphics',fill='#f3eff9',stroke=PURPLE,size=27,kind='group')
    box('division',1155,295,3,570,'',fill='#536577',stroke='#536577')
    box('camera',35,320,270,245,'OV5640\n摄像头\n\n[ 实物照片预留 ]',fill='#fafafa',size=27)
    box('monitor',2095,625,270,235,'HDMI 显示器\n\n[ 屏幕 / 实物图预留 ]',fill='#fafafa',size=26)
    box('pc',35,1195,270,240,'上位机 PC\nPYNQ Studio\n\n[ 界面截图预留 ]',fill='#fafafa',size=26)
    box('hand_external',2095,1225,270,220,'灵巧手\nUSB · 17 电机\n\n[ 实物照片预留 ]',fill='#fafafa',size=26)
    box('ddr_external',35,950,270,125,'板载 DDR3\n共享图像 / 命令缓冲',fill='#fff9ed',stroke='#af8844',size=23)
    box('buttons',35,745,270,100,'BTN0 / BTN1\n游戏技能输入',fill='#fafafa',size=24)
    box('input',435,375,640,92,'DVP 接入 → Video In → Demosaic\n1280×720 Bayer → RGB',stroke=BLUE,size=25)
    box('filter',435,510,640,110,'2×2 区域缩减 → HSV 肤色阈值\n9×9 膨胀 → 5×5 高斯处理\n原始 / 滤波双掩膜 · 640×360',stroke=BLUE,size=24)
    box('capture',435,680,640,130,'三槽帧拥有权 / 生命周期控制\nRGB：frame_dma (VDMA)\n双掩膜包 / 状态：moments_dma (SG)',stroke=BLUE,size=24)
    box('upload',1240,375,720,92,'axi_dma (MM2S) → 包解析 / 分派\nScene 命令 · Palette · Atlas · Tilemap',stroke=PURPLE,size=25)
    box('raster',1240,510,720,110,'Scene2D 命令式 2D 光栅化\nClear / Fill · Sprite blit · Tile layer\nINDEX4 资源与调色板',stroke=PURPLE,size=25)
    box('fb',1240,670,320,125,'BRAM 双帧缓冲\n320×180 × 2\n消隐期交换',stroke=PURPLE,size=24)
    box('scan',1640,670,320,125,'4× 扫描放大\n独立 OSD 叠加\nrgb2dvi / TMDS',stroke=PURPLE,size=24)
    box('ps',375,920,1650,555,'PS  /  双核 ARM Cortex-A9 · Linux / PYNQ',fill='#f3f8f5',stroke=GREEN,size=28,kind='group')
    box('memory',430,985,1510,70,'PS DDR 控制器 / AXI HP 端口  ·  RGB / 掩膜 / 状态帧缓冲  ·  命令与资源上传缓冲',fill='#fff9ed',stroke='#af8844',size=24)
    box('recognizer',430,1115,420,110,'OpenCV 轮廓 / 凸包 / 凸缺陷\n质心、方向、握拳 / 剪刀 / 布\nPS 本地识别与有效期检查',stroke=GREEN,size=24)
    box('app',1000,1115,420,110,'菜单 / 游戏 / 画布 / 视频\n本地输入映射与交互状态机\nScene 构建与编译',stroke=GREEN,size=24)
    box('sink',1560,1115,380,110,'共享 Overlay / GPU sink\n命令与资源打包 / DMA\n接收、渲染、呈现回执',stroke=GREEN,size=24)
    box('agent',430,1310,420,110,'SSH 安装 / Agent 管理\nVVGP 内容与控制 · SHA 回读\nHTTP 按需图像 / 结果回传',stroke=GREEN,size=24)
    box('latest',1000,1310,420,110,'最新视觉状态 / 事件\nrun · epoch · frame_id\n多消费者读取，不回放积压队列',stroke=GREEN,size=24)
    box('hand',1560,1310,380,110,'灵巧手独占权限 / 调度\n跟随、示范、超时与正常释放\n独立动作进程 → USB SDK',stroke=GREEN,size=23)
    box('ctl',400,1440,1590,27,'控制面：PS M_AXI_GP0 → AXI-Lite / MMIO → 采集配置、相机 I²C、GPU 状态与 OSD 位置寄存器',size=19,kind='text')

    edge('camera','input',[[305,420],[435,420]],BLUE,'DVP 像素流',(365,397))
    edge('recognizer','camera',[[430,1150],[330,1150],[330,530],[305,530]],GRAY,'I²C / SCCB 配置',(323,655),True)
    edge('input','filter',[[755,467],[755,510]],BLUE)
    edge('filter','capture',[[755,620],[755,680]],BLUE,'RGB 旁路 + 双掩膜',(755,654))
    edge('capture','memory',[[900,810],[900,905],[1910,905],[1910,985]],BLUE,'HP1：RGB / HP3：掩膜与状态',(1460,905))
    edge('memory','recognizer',[[640,1055],[640,1115]],BLUE)
    edge('recognizer','latest',[[640,1225],[640,1265],[1210,1265],[1210,1310]],GREEN,'位置 / 分类 / 帧身份',(855,1258))
    edge('latest','app',[[1100,1310],[1100,1225]],GREEN)
    edge('app','sink',[[1420,1170],[1560,1170]],PURPLE,'Scene',(1490,1153))
    edge('sink','memory',[[1780,1115],[1780,1055]],PURPLE)
    edge('memory','upload',[[1940,1020],[2040,1020],[2040,350],[1600,350],[1600,375]],PURPLE,'HP0：命令 / 资源读取',(1930,340))
    edge('upload','raster',[[1600,467],[1600,510]],PURPLE)
    edge('raster','fb',[[1400,620],[1400,670]],PURPLE)
    edge('fb','scan',[[1560,732],[1640,732]],PURPLE)
    edge('scan','monitor',[[1960,740],[2095,740]],PURPLE,'HDMI 720p',(2034,718))
    edge('latest','scan',[[1310,1420],[1310,1432],[1990,1432],[1990,835],[1800,835],[1800,795]],GRAY,'最新手位置 → OSD（MMIO）',(1800,835),True)
    edge('latest','hand',[[1420,1350],[1560,1350]],GREEN)
    edge('hand','hand_external',[[1940,1350],[2095,1350]],GREEN,'USB 串口 / SDK',(2018,1328))
    edge('pc','agent',[[305,1360],[430,1360]],GRAY,'Ethernet',(364,1338),True,True)
    edge('agent','app',[[850,1335],[920,1335],[920,1190],[1000,1190]],GRAY,'管理 / 内容',(923,1288),True,True)
    edge('ddr_external','memory',[[305,1020],[430,1020]],'#af8844','DDR 总线',(365,999),False,True)
    edge('buttons','app',[[305,800],[345,800],[345,1090],[1210,1090],[1210,1115]],GRAY,'PL 按键同步 → PS 游戏输入',(1210,1083),True)
    box('note',400,1516,1600,28,'视觉与渲染分离：双掩膜送往 DDR / PS 识别，应用生成 Scene 后才进入 GPU；相机画面不直接作为 GPU 帧缓冲。',size=21,kind='text')
    box('legend',40,1565,2320,38,'蓝：视觉数据流    紫：渲染 / 显示流    绿：PS 语义与动作    灰虚线：控制 / 管理    ·    外设框内保留图片位置',size=22,kind='text')
    scene=dict(width=2400,height=1630,title='GESTURE PLAY v3.0 PL–PS',subtitle='Frozen runtime architecture',nodes=nodes,edges=edges)
    (OUT/'system.json').write_text(json.dumps(scene,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    paths=['README.md','report/design_report.md','board/runtime/deployment_manifest.json',
           'board/runtime/overlay/c6v_candidate.hwh',
           'build/hardware/c6_latency/c6_latency.srcs/sources_1/bd/c6v/c6v.bd',
           'board/runtime/board/pynq_z2/scripts/vision_async_runtime.py',
           'board/runtime/python/pynq_multimodal_game/agent/c6i_video.py',
           'board/runtime/python/pynq_multimodal_game/agent/c6i_shell.py']
    evidence={p:hashlib.sha256((ROOT/p).read_bytes()).hexdigest() for p in paths}
    hw=ET.parse(ROOT/paths[3]);modules={m.attrib.get('INSTANCE'):m.attrib.get('MODTYPE') for m in hw.iter('MODULE')}
    required={'core':'scene2d_c4m7_core','dual_mask_capture':'axis_rgb_capture_bd','frame_dma':'axi_vdma','moments_dma':'axi_dma','axi_dma':'axi_dma','input_osd_0':'input_osd_axi'}
    assert all(modules.get(k)==v for k,v in required.items())
    bd=json.loads((ROOT/paths[4]).read_text(encoding='utf-8'))['design']
    nets={k:v for k,v in bd['interface_nets'].items() if 'ps7_0/S_AXI_HP' in str(v) or k in ['axi_dma_M_AXI_MM2S','frame_dma_M_AXI_S2MM','moments_dma_M_AXI_S2MM']}
    (OUT/'evidence.json').write_text(json.dumps(dict(source='contest_v3',runtime_manifest_sha256=evidence[paths[2]],sha256=evidence,verified_modules=required,verified_bus_nets=nets),ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(json.dumps(dict(output=str(OUT),nodes=len(nodes),edges=len(edges),source_checks='PASS')))


if __name__=='__main__':main()
