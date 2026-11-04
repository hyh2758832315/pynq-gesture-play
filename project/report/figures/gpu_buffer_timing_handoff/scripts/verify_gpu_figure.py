"""Verify GPU illustration examples against frozen ABI and sink implementation.

Run: python -B tools/verify_gpu_figure.py --source-root . --output report/figures/gpu_buffer_timing/data
Requires NumPy. Outputs ABI binaries, CSV tables, driver_trace.csv and verification.json.
Uses a deterministic in-memory DMA/MMIO fixture; no PYNQ imports, network or hardware.
Next: preserve the constructed-example scope when drawing timing and storage charts.
"""
from pathlib import Path
import argparse,ast,csv,hashlib,importlib,json,struct,sys,time,types
from dataclasses import dataclass,field
from typing import Any,Callable
import numpy as np

def csv_out(path,rows):
    with path.open('w',encoding='utf-8-sig',newline='') as f:
        w=csv.DictWriter(f,fieldnames=list(rows[0]));w.writeheader();w.writerows(rows)

def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--source-root',type=Path,required=True);ap.add_argument('--output',type=Path,required=True)
    args=ap.parse_args();root=args.source_root;out=args.output;out.mkdir(parents=True,exist_ok=True)
    def src(name,rel):
        p=root/'reference_only'/name
        return p if p.exists() else root/rel
    py='board/runtime/python/pynq_multimodal_game/'
    rtl='build/hardware/c6_latency/c6_latency.srcs/sources_1/imports/'
    paths={name:src(name,rel) for name,rel in {
        'gpu_abi.py':py+'gpu_abi.py','scene.py':py+'scene.py',
        'c6i_video.py':py+'agent/c6i_video.py','c6i_backend.py':py+'agent/c6i_backend.py',
        'scene2d_c4m3_core.sv':rtl+'scene2d_c4m3_core.sv',
        'scene2d_c4m7_core.sv':rtl+'scene2d_c4m7_core.sv',
        'scene2d_frame_swap.sv':rtl+'scene2d_frame_swap.sv',
        'scene2d_video_timing.sv':rtl+'scene2d_video_timing.sv',
        'c6v.bd':'build/hardware/c6_latency/c6_latency.srcs/sources_1/bd/c6v/c6v.bd'}.items()}
    pkg=types.ModuleType('figure_gpu_reference');pkg.__path__=[str(paths['gpu_abi.py'].parent)];sys.modules[pkg.__name__]=pkg
    abi=importlib.import_module(pkg.__name__+'.gpu_abi');scene=importlib.import_module(pkg.__name__+'.scene')
    cmds=(abi.GpuCommand.clear(),abi.GpuCommand.fill_rect(x=10,y=20,width=32,height=16,token=0xF7),abi.GpuCommand.end_frame())
    def make_scene(seq,palette=0):
        h=abi.SceneHeader(frame_id=seq,submit_seq=seq,command_count=3,camera_x=0,camera_y=0,
            background_color=(0,0,0),palette_generation=palette)
        return h.to_bytes()+abi.pack_command_bank(cmds)
    packet=make_scene(7);assert len(packet)==4160
    assert struct.unpack_from('<8I',packet,96)==(4,247,0x0014000A,0x00100020,0,0,0,0)
    assert packet[160:]==bytes(4000)
    (out/'scene_example.bin').write_bytes(packet)
    assert abi.pack_index4(scene.IndexedImage(4,1,bytes([1,2,3,4])))==bytes.fromhex('21 43')
    try:abi.pack_command_bank(tuple([cmds[0]]*129))
    except ValueError:pass
    else:raise AssertionError('command overflow not rejected')
    palette=tuple(tuple((0,0,0) for _ in range(16)) for _ in range(16))
    palette_packet=abi.pack_palette_packet(palette,generation=1)
    ph,payload=abi.unpack_resource_packet(palette_packet);assert len(payload)==1024 and len(palette_packet)==1088
    (out/'palette_example.bin').write_bytes(palette_packet)
    names=['magic','version','frame_id','submit_seq','command_count','camera_x','camera_y','background_rgb',
        'palette_generation','predicted_cycles','asset_generation','tilemap_generation','reserved12','reserved13','reserved14','reserved15']
    csv_out(out/'scene_header.csv',[dict(word=i,offset=4*i,field=name,hex=f'0x{value:08X}',value=value)
        for i,(name,value) in enumerate(zip(names,struct.unpack_from('<16I',packet)))])
    csv_out(out/'commands.csv',[dict(command=c,offset=64+c*32,word=i,hex=f'0x{v:08X}',value=v)
        for c,cmd in enumerate(cmds) for i,v in enumerate(cmd.words)])

    # Execute unmodified class bodies, injecting only their imported dependencies.
    # The actual production methods, including wait order and buffer ownership, run here.
    mod=types.ModuleType('figure_gpu_sink');sys.modules[mod.__name__]=mod
    env=mod.__dict__;env.update(dataclass=dataclass,field=field,Path=Path,struct=struct,time=time,Any=Any,Callable=Callable,
        C6IOverlaySession=object,PacketType=abi.PacketType,unpack_resource_packet=abi.unpack_resource_packet,
        ASSET_BUNDLE_CAPACITY_BYTES=abi.ASSET_BUNDLE_CAPACITY_BYTES,ASSET_BUNDLE_SLOT_COUNT=abi.ASSET_BUNDLE_SLOT_COUNT,
        PACKET_HEADER_BYTES=abi.PACKET_HEADER_BYTES)
    for name in ('c6i_backend.py','c6i_video.py'):
        tree=ast.parse(paths[name].read_text(encoding='utf-8'))
        nodes=[ast.ImportFrom(module='__future__',names=[ast.alias(name='annotations')],level=0)]
        nodes += [n for n in tree.body if isinstance(n,ast.Assign)]
        if name=='c6i_video.py':nodes += [n for n in tree.body if isinstance(n,ast.ClassDef)]
        exec(compile(ast.fix_missing_locations(ast.Module(body=nodes,type_ignores=[])),str(paths[name]),'exec'),env)
    trace=[]
    def log(component,action,value=''):
        trace.append(dict(step=len(trace),component=component,action=action,value=value))
    class Buffer(np.ndarray):
        def __new__(cls,shape,dtype):return np.zeros(shape,dtype=dtype).view(cls)
        def flush(self):log('DDR buffer','flush')
        def freebuffer(self):log('DDR buffer','free')
    class Fixture:
        def __init__(self):
            self.reg={};self.pending=None;self.render_reads=0;self.present_reads=0;self.generation_reads=0
            self._overlay=types.SimpleNamespace(axi_dma=types.SimpleNamespace(sendchannel=Channel(self)))
        def open(self):return self
        def supports_upload_render_overlap(self):return False
        def allocate(self,shape,dtype):return Buffer(shape,dtype)
        def mmio(self,name):return MMIO(self,name)
        def accepted(self,packet):
            if packet[:4]==b'S2DG':
                seq=struct.unpack_from('<I',packet,12)[0]
                for off in (0,8):self.reg[('packet_status_gpio',off)]=self.reg.get(('packet_status_gpio',off),0)+1
                self.reg[('present_completion_gpio',0)]=seq # early seq latch, not proof of presentation
                self.pending=seq;self.render_reads=0;self.present_reads=0
                log('fixture','accepted / present_seq already latched',seq)
            else:
                h,_=abi.unpack_resource_packet(packet)
                assert h.packet_type is abi.PacketType.PALETTE
                self.reg[('palette_packet_status_gpio',0)]=self.reg.get(('palette_packet_status_gpio',0),0)+1
                self.pending_generation=h.generation;self.generation_reads=0
        def read(self,name,offset):
            if name=='build_id_gpio':value=0xC0061000
            else:
                if self.pending is not None and name=='render_completion_gpio' and offset==8:
                    self.render_reads+=1
                    if self.render_reads==2:
                        self.reg[(name,8)]=self.reg.get((name,8),0)+1
                        self.reg[(name,0)]=self.pending
                if self.pending is not None and name=='present_completion_gpio' and offset==8:
                    self.present_reads+=1
                    if self.present_reads==3:
                        self.reg[(name,8)]=self.reg.get((name,8),0)+1;self.pending=None
                if name=='palette_generation_status_gpio' and hasattr(self,'pending_generation'):
                    self.generation_reads+=1
                    if self.generation_reads==2:self.reg[(name,0)]=self.pending_generation
                value=self.reg.get((name,offset),0)
            log(name,f'read 0x{offset:02X}',value);return value
    class MMIO:
        def __init__(self,owner,name):self.owner=owner;self.name=name
        def read(self,offset):return self.owner.read(self.name,offset)
    class Channel:
        error=False;running=False
        def __init__(self,owner):self.owner=owner;self.reads=0
        def transfer(self,buffer,nbytes):
            self.packet=bytes(buffer[:nbytes]);self.reads=0;self.running=True
            log('DMA','transfer',nbytes)
        @property
        def idle(self):
            self.reads+=1;log('DMA','idle',self.reads>=2)
            if self.reads==2:self.owner.accepted(self.packet)
            return self.reads>=2
        def wait(self):self.running=False;log('DMA','wait returned')
    fx=Fixture();sink=env['C6IVideoSink'](session=fx,timeout_seconds=.25)
    trace.clear();sink.submit_scene(packet)
    assert not sink._tickets and fx.present_reads==3 and fx.render_reads==2
    assert trace[0]['action']=='flush' and trace[1]['action']=='transfer'
    present_reads=[r for r in trace if r['component']=='present_completion_gpio' and r['action']=='read 0x08']
    assert [r['value'] for r in present_reads]==[0,0,1]
    sink.upload_palette(palette_packet)
    # resource_generations needs all three kinds; inspect just the acknowledged palette entry here.
    assert sink._resource_generations[abi.PacketType.PALETTE]==1 and fx.generation_reads>=2
    sink.submit_scene(make_scene(8,1));assert not sink._tickets and fx.reg[('present_completion_gpio',8)]==2
    before=sum(r['action']=='transfer' for r in trace)
    try:sink.upload_palette(palette_packet[:-1]+bytes([palette_packet[-1]^1]))
    except ValueError:pass
    else:raise AssertionError('resource CRC not rejected')
    assert sum(r['action']=='transfer' for r in trace)==before
    sink.close();assert trace[-1]['action']=='free'
    csv_out(out/'driver_trace.csv',trace)
    bd=json.loads(paths['c6v.bd'].read_text(encoding='utf-8'))['design'];c=bd['components']
    assert c['core'].get('parameters',{}).get('UPLOAD_RENDER_OVERLAP_ENABLE',{}).get('value','0')=='0'
    assert "parameter bit UPLOAD_RENDER_OVERLAP_ENABLE = 1'b0" in paths['scene2d_c4m7_core.sv'].read_text()
    assert '.frame_start(vblank_start)' in paths['scene2d_c4m3_core.sv'].read_text()
    assert 'present_completed_seq <= accepted_seq;' in paths['scene2d_c4m3_core.sv'].read_text()
    assert c['pixel_clock']['parameters']['CLKOUT1_REQUESTED_OUT_FREQ']['value']=='74.250'
    assert c['ps7_0']['parameters']['PCW_FPGA0_PERIPHERAL_FREQMHZ']['value']=='100'
    assert 'if (frame_start && request_sync_2 != request_seen)' in paths['scene2d_frame_swap.sv'].read_text()
    memory=[('Framebuffer token8',2,320*180,115200,'Current logical payload'),
        ('Framebuffer RGB888 comparison',2,320*180*3,345600,'Same resolution comparison only'),
        ('Command banks',2,4096,8192,'Headers stored separately'),
        ('Atlas banks',2,32768,65536,'Excludes descriptors and metadata'),
        ('Tilemap banks',8,4096,32768,'4 slots, 2 banks per slot'),
        ('Palette RGB storage',2,256*3,1536,'Transport uses 256 uint32 = 1024 B per palette'),
        ('PS staging buffer',1,64+48+32768,32880,'One reusable NumPy/PYNQ DMA allocation')]
    csv_out(out/'storage.csv',[dict(item=n,copies=k,bytes_each=v,total_bytes=t,total_KiB=t/1024,scope=s) for n,k,v,t,s in memory])
    csv_out(out/'ownership.csv',[dict(phase=a,display_bank=b,write_bank=c,writes=d) for a,b,c,d in [
        ('rendering','A','B','allowed: B'),('waiting_vblank','A','B','disabled'),
        ('swapped_waiting_ack','B','B','disabled'),('ack_returned','B','A','next render may write A')]])
    timing=dict(h_active=1280,h_front=110,h_sync=40,h_back=220,v_active=720,v_front=5,v_sync=5,v_back=20,
        h_total=1650,v_total=750,pixel_clock_Hz=74250000,render_clock_Hz=100000000,
        frame_period_ms=1650*750/74250000*1000,refresh_Hz=74250000/(1650*750),
        vblank_ms=1650*30/74250000*1000,scale=4,scope='Configuration-derived; not a measured render/interaction latency')
    (out/'timing.json').write_text(json.dumps(timing,indent=2)+'\n',encoding='utf-8')
    result=dict(result='PASS',scope='Production ABI and sink class with deterministic memory fixture; RTL/BD source assertions. No RTL simulation.',
        scene_packet_bytes=4160,palette_packet_bytes=1088,index4_hex='2143',successful_scenes=2,
        old_present_count_reads=2,resource_crc_rejected_before_dma=True,command_overflow_rejected=True,
        driver_trace_rows=len(trace),hardware_access=False,source_sha256={k:hashlib.sha256(v.read_bytes()).hexdigest() for k,v in paths.items()})
    (out/'verification.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
    print(json.dumps({k:v for k,v in result.items() if k!='source_sha256'}))

if __name__=='__main__':main()
