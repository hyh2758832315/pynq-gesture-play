"""Run the actual VOL1 Python driver/producer and OSD publisher against XSim RTL.

From workspace root (no hardware/network access):
  .venv/Scripts/python subprojects/volume_response_offline/cosim/run_cosim.py \
    --output build/volume-response/cosim-r01 --vivado D:/Xilinx/Vivado/2026.1/Vivado
Outputs: compiled DLL, SHA-bound receipt, PCM/windows/720p bar pixels, AXI and PS
traces, independent assertions. Next: review exclusions before board/QEMU work.
This is host Python functional cosimulation, NOT an ARM/Linux emulation or an
electrical microphone/ADC simulation. Only the backend and time provider adapt.
"""
import argparse
import csv
import hashlib
import json
import math
import multiprocessing
import os
from pathlib import Path
import shutil
import subprocess
import sys
import time

from xsi_bridge import Xsi

ROOT = Path(__file__).resolve().parents[3]
PACKAGE = ROOT/'deliveries/c6i-pl-vision-volume-osd-r20-admission-r03-20261023'
HERE = Path(__file__).resolve().parent


def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


class Backend:
    """Real AXI transactions; narrowly scoped behavioral codec register model.

    Codec accepts the captured project profile. Serial output is enabled only
    when the supported capture-route configuration has been written. This does
    not model analog gain, jack detection, ADC noise, PLL dynamics or I2C wires.
    """
    def __init__(self, x, output):
        self.x = x
        self.tag = 0
        self.registers = {}
        self.axi = (output/'axi.jsonl').open('w', encoding='utf-8')
        self.codec = (output/'codec.jsonl').open('w', encoding='utf-8')

    def transfer(self, target, offset, value=None):
        self.tag += 1
        for name, number in [('target_osd',target), ('address',offset),
                             ('write_data',0 if value is None else value),
                             ('write_request',int(value is not None)), ('request',self.tag)]:
            self.x.put(name,number)
        started = self.x.monotonic_ns()
        for _ in range(100):
            self.x.run_ns(100)
            if self.x.get('completed') == self.tag:
                response = self.x.get('response')
                result = self.x.get('read_data')
                self.axi.write(json.dumps(dict(ns=started,finished_ns=self.x.monotonic_ns(),
                    target=target,offset=offset,write=value,response=response,data=result))+'\n')
                assert response == 0, f'AXI error target={target} offset={offset:#x}: {response}'
                return result
        raise TimeoutError('AXI handshake did not complete in 10 us')

    def read32(self, offset): return self.transfer(0,offset)
    def write32(self, offset, value): self.transfer(0,offset,value)

    def codec_write(self, register, payload):
        self.codec.write(json.dumps(dict(ns=self.x.monotonic_ns(),write=register,payload=payload.hex()))+'\n')
        for i, value in enumerate(payload): self.registers[register+i]=value
        expected={0x4000:0x0f,0x400A:1,0x400C:1,0x400E:0xb3,0x400F:0xb3,
                  0x4010:1,0x4019:0x33,0x40F3:1,0x40FA:3}
        active=all(self.registers.get(k)==v for k,v in expected.items())
        self.x.put('codec_active',int(active))
        self.x.run_ns(1000)  # explicit transaction-level timing assumption
        return len(payload)

    def codec_read(self, register, length):
        value=bytes(self.registers.get(register+i,0) for i in range(length))
        if register==0x4002 and length==6 and value==bytes.fromhex('000000002801'):
            value=value[:-1]+b'\x03'  # ideal PLL lock, not measured/analog modeled
        self.codec.write(json.dumps(dict(ns=self.x.monotonic_ns(),read=register,payload=value.hex()))+'\n')
        self.x.run_ns(1000)
        return value

    def close(self): self.axi.close();self.codec.close()


class OsdIo:
    def __init__(self, backend): self.backend=backend
    def read(self, offset): return self.backend.transfer(1,offset)
    def write(self, offset, value): self.backend.transfer(1,offset,value)


def prepare(output, vivado, reuse_compiled=None):
    manifest=json.loads((PACKAGE/'deployment_manifest.json').read_text())['sha256']
    record={}
    sources=[]
    out_sources=output/'sources';out_sources.mkdir()
    for name in ('voice_volume_core.sv','voice_volume_i2s_rx.sv','voice_volume_top.sv','axi_voice_volume.sv'):
        path=ROOT/'build/hosd/c0d/c6_osd.srcs/sources_1/imports'/name
        # Bind historical build imports, and compare present source without changing it.
        assert digest(path)==digest(ROOT/'rtl/voice_volume'/name),f'drift in {name}'
        dest=out_sources/name;shutil.copyfile(path,dest);sources.append(dest)
        record[str(path.relative_to(ROOT))]=digest(path)
    for name in ('input_osd_ctrl.sv','input_osd_pixels.sv','input_osd_top.sv'):
        relative='overlay/osd-source/'+name;path=PACKAGE/relative
        assert digest(path)==manifest[relative].lower(),f'manifest mismatch {relative}'
        dest=out_sources/name;shutil.copyfile(path,dest);sources.append(dest)
        record[str(path.relative_to(ROOT))]=digest(path)
    for relative in ('board/pynq_z2/scripts/voice_volume_control.py',
                     'board/pynq_z2/scripts/voice_volume_runtime.py',
                     'python/pynq_multimodal_game/volume_monitor.py',
                     'python/pynq_multimodal_game/osd_publisher.py',
                     'python/pynq_multimodal_game/input_osd.py'):
        path=PACKAGE/relative
        assert digest(path)==manifest[relative].lower(),f'manifest mismatch {relative}'
        record[str(path.relative_to(ROOT))]=digest(path)
    for name in ('audio_hdmi_cosim.sv','run_cosim.py','xsi_bridge.py'):
        dest=out_sources/name;shutil.copyfile(HERE/name,dest)
        record[str((HERE/name).relative_to(ROOT))]=digest(HERE/name)
    sources.append(out_sources/'audio_hdmi_cosim.sv')
    if reuse_compiled is not None:
        old=json.loads(reuse_compiled.read_text(encoding='utf-8'))
        assert old['status']=='DIGITAL_FUNCTIONAL_COSIM_PASS'
        for name,sha in record.items():
            if name.endswith('.sv'):
                assert old['source_hashes'][name]==sha,('compiled RTL drift',name)
        source_dir=reuse_compiled.parent/'xsim.dir'
        dll=source_dir/'audio_hdmi/xsimk.dll'
        assert dll.is_file()
        shutil.copytree(source_dir,output/'xsim.dir')
        return record,[dict(status='REUSED_VERIFIED_COMPILED_RTL',
                            prior_receipt_sha256=digest(reuse_compiled),
                            design_dll_sha256=digest(dll))]
    steps=[]
    commands=[[str(vivado/'bin/xvlog.bat'),'--sv',*map(str,sources)],
              [str(vivado/'bin/xelab.bat'),'audio_hdmi_cosim','-s','audio_hdmi',
               '-dll','--debug','typical','--mt','off']]
    for n,command in enumerate(commands):
        started=time.monotonic()
        result=subprocess.run(command,cwd=output,capture_output=True,timeout=240)
        log=(result.stdout+result.stderr).decode(errors='replace')
        (output/f'compile-{n}.log').write_text(log,encoding='utf-8')
        steps.append(dict(command=command,returncode=result.returncode,seconds=time.monotonic()-started))
        assert result.returncode==0,log[-3000:]
    return record,steps


def stimulus(output, scenario, repetitions=1):
    # Input samples at the codec's 24-bit serial boundary. Synthetic 1 kHz tone.
    rate=100_000_000/2048
    length=math.ceil(.82*rate)
    values=[]
    for n in range(length):
        t=n/rate
        amp=32 if .16<=t<.30 else 100 if .46<=t<.60 else 4
        value=round(amp*math.sin(2*math.pi*1000*t))*256
        values.append(value)
    right=values.copy()
    provenance=dict(type='synthetic 1 kHz, signed 16-bit amplitudes 4/32/100 in 24-bit I2S',rate=rate)
    if scenario in ('human','project_human'):
        import numpy as np
        path=(ROOT/'build/volume-response/acoustic-a03-human/board-raw.npy'
              if scenario=='human' else ROOT/'build/volume-response/codec-ab-a01/phase-1-raw.npy')
        raw=np.load(path).reshape(-1,2).astype(np.int64)
        raw=np.where(raw>=0x800000,raw-0x1000000,raw)
        if scenario=='human':
            source_start=1382801
        else:
            capture=json.loads((path.parent/'board-receipt.json').read_text())['captures'][1]
            assert capture['profile']=='project-r20' and digest(path)==capture['file']['sha256']
            measured_fs=capture['sample_len']/((capture['finished_ns']-capture['started_ns'])/1e9)
            source_start=round(4.50*measured_fs)
        begin=math.ceil(.16*rate);end=math.ceil(.40*rate)
        # Exact captured 24-bit words, no gain/normalization. Quiet pre/post rolls
        # are synthetic, so startup bias cannot be mistaken for a human response.
        values=[round(4*math.sin(2*math.pi*1000*n/rate))*256 for n in range(length)]
        right=values.copy()
        values[begin:end]=raw[source_start:source_start+end-begin,0].tolist()
        right[begin:end]=raw[source_start:source_start+end-begin,1].tolist()
        provenance.update(type='unaltered captured human stereo segment with synthetic quiet pre/post roll',
            path=str(path.relative_to(ROOT)),sha256=digest(path),source_start=source_start,
            segment_frames=end-begin,insert_at=begin)
    # The ARM guest takes longer to spawn than the host functional driver.
    # Repeating the same deterministic sequence gives it a complete stimulus
    # after the first enable without changing thresholds, RTL or PCM amplitude.
    assert repetitions in (1,2)
    if repetitions==2:
        values=values*2;right=right*2;length=len(values)
        provenance['repetitions']=2
    # Full declaration length prevents readmemh warnings and makes end silence explicit.
    for name,channel in [('left',values),('right',right)]:
        text=''.join(f'{v & 0xffffff:06x}\n' for v in channel+[0]*(100000-length))
        (output/f'{name}.mem').write_text(text,encoding='ascii')
    return values,provenance


def rows(output,name):
    with (output/name).open() as stream:
        return [{k:int(v) for k,v in row.items()} for row in csv.DictReader(stream)]


def validate(output, values, commits, scenario):
    pcm=rows(output,'pcm.csv');windows=rows(output,'windows.csv')
    frames=rows(output,'frames.csv');bars=rows(output,'bar.csv')
    serial={r['index']:r for r in rows(output,'serialized.csv')}
    assert len(pcm)>30000 and len(windows)>=38,(len(pcm),len(windows))
    assert [r['index'] for r in pcm]==list(range(1,pcm[-1]['index']+1)), 'lost/duplicated I2S frame'
    assert all(b['ns']-a['ns']==20480 for a,b in zip(pcm,pcm[1:])), 'nonuniform I2S sample cadence'
    assert all(r['ns']-serial[r['index']]['ns']==5320 for r in pcm), 'I2S decode latency changed'
    if scenario=='left_missing':
        assert max(abs(r['right']) for r in serial.values())>=100*256, 'right-channel fault stimulus missing'
    expected_samples=[]
    for row in pcm:
        expected=(values[row['index']]>>8) if row['index']<len(values) else 0
        if scenario=='left_missing' or not serial[row['index']]['active']: expected=0
        assert row['actual']==row['expected']==expected,('I2S decode mismatch',row,expected)
        if row['accepted']: expected_samples.append(expected)
    dc=total=0;gold=[]
    for n,sample in enumerate(expected_samples,1):
        scaled=sample<<8;dc+=(scaled-dc)>>10;total+=abs((scaled-dc)>>8)
        if n%977==0: gold.append(total);total=0
    assert len(gold)==len(windows),(len(gold),len(windows))
    for row,expected in zip(windows,gold):
        assert row['sum']==expected and row['samples']==row['window']*977,(row,expected)
        assert row['faults']==0,row
    active=[0]*6;remaining=0;pending_index=0
    expected_frames={0:(active.copy(),False)}
    for frame in frames:
        remaining=max(0,remaining-1)
        if pending_index<len(commits) and commits[pending_index]['ns']<frame['ns']-100:
            words=commits[pending_index]['words'];pending_index+=1
            if words[5]!=active[5]: remaining=min(6,words[3]>>24)
            active=words
        fresh=bool(active[0]&1 and active[0]&8 and remaining)
        actual=[frame[f'w{i}'] for i in range(6)]
        assert actual==active,('CDC atomic payload/boundary mismatch',frame,active)
        assert frame['audio_fresh']==int(fresh),('source lifetime mismatch',frame,remaining)
        expected_frames[frame['frame']]=(active.copy(),fresh)
    for pixel in bars:
        words,fresh=expected_frames[pixel['frame']]
        x,y=pixel['x'],pixel['y'];rgb=pixel['background']
        level=words[2]&1023;soft=(words[2]>>16)&1023;loud=words[3]&1023
        if words[0]&1:
            if 1266<=x<1274:
                rgb=0x202830
                if fresh and 480-y<=level:
                    rgb=0xff4848 if level>=loud else 0xff40cc if level>=soft else 0x4070e0
                if x in (1266,1273) or y in (240,479): rgb=0x707070
            if 1262<=x<1277 and 480-y in (soft,loud): rgb=0xe0e0e0 if fresh else 0x505050
        assert pixel['rgb']==rgb,('HDMI pixel mismatch',pixel,hex(rgb),words,fresh)
    event_kinds=sorted({r['kind'] for r in windows if r['pending']})
    if scenario=='left_missing':
        assert max(gold)==0 and not event_kinds
        assert all((c['words'][2]&1023)==0 for c in commits)
    else:
        assert event_kinds==([2] if scenario in ('human','project_human') else [1,2]),event_kinds
        if scenario=='publisher_paused':
            assert max(c['words'][2]&1023 for c in commits)<120
            stale=[r for r in frames if 550_000_000<r['ns']<660_000_000]
            recovered=[r for r in frames if 730_000_000<r['ns']]
            assert stale and all(r['audio_fresh']==0 for r in stale)
            assert recovered and all(r['audio_fresh']==1 for r in recovered)
        else:
            max_bar=max(c['words'][2]&1023 for c in commits)
            if scenario=='project_human':
                assert max_bar>=120,max_bar
            else:
                assert max_bar==240,max_bar
    first_visible={}
    for name,height in [('soft',69),('loud',120)]:
        qualifying=[r for r in frames if r['audio_fresh'] and (r['w2']&1023)>=height]
        first_visible[name]=qualifying[0]['ns'] if qualifying else None
    return dict(decoded_samples=len(pcm),compared_windows=len(gold),
                mean_min=min(gold)/977,mean_max=max(gold)/977,
                event_kinds=event_kinds,compared_frame_boundaries=len(frames),
                compared_bar_pixels=len(bars),source_lifetime_checked=True,
                no_sample_loss_or_duplicates=True,sample_period_ns=20480,
                first_visible_frame_boundary_ns=first_visible)


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output',type=Path,required=True)
    parser.add_argument('--vivado',type=Path,required=True)
    parser.add_argument('--scenario',choices=('nominal','left_missing','publisher_paused','human','project_human'),default='nominal')
    parser.add_argument('--reuse-compiled',type=Path,help='prior passing receipt with identical RTL; reuse its XSI snapshot')
    parser.add_argument('--diagnostic-ms',type=int,help='bounded diagnostic run; never grants cosim PASS')
    args=parser.parse_args();args.output=args.output.resolve();args.vivado=args.vivado.resolve()
    args.output.mkdir(parents=True,exist_ok=False)
    receipt=dict(status='RUNNING',scenario=args.scenario,board_access=False,
        physical_microphone_verified=False,full_arm_linux_cosimulation=False,
        exclusions=['analog jack/microphone/ADC/PLL electrical behavior',
                    'physical I2C controller/wires; ideal register-level codec profile model',
                    'ARM/Linux scheduling, IPC worker isolation, DDR/PS interconnect',
                    'GPU and network return stream; continuous scanout supplied by testbench',
                    'post-route netlist/timing equivalence to deployed bitstream'])
    started=time.monotonic();x=backend=None;commits=[];polls=[]
    try:
        receipt['source_hashes'],receipt['compile_steps']=prepare(args.output,args.vivado,args.reuse_compiled)
        values,receipt['stimulus']=stimulus(args.output,args.scenario)
        receipt['stimulus_sha256']=digest(args.output/'left.mem')
        sys.path[:0]=[str(PACKAGE/'board/pynq_z2/scripts'),str(PACKAGE/'python')]
        import voice_volume_control as vc
        from voice_volume_runtime import VolumeSharedPage,VolumeProducer
        from pynq_multimodal_game.osd_publisher import OsdPublisher
        from pynq_multimodal_game.input_osd import audio_observation
        os.chdir(args.output)
        x=Xsi(args.vivado,args.output,'audio_hdmi')
        for name,value in dict(resetn=0,codec_locked=1,codec_active=0,request=0,address=0,
                               write_data=0,write_request=0,target_osd=0,sample_length=len(values),
                               source_mode=int(args.scenario=='left_missing'),scene_mode=0).items():
            x.put(name,value)
        x.run_ns(2000);x.put('resetn',1);x.run_ns(1000)
        vc.time=x
        backend=Backend(x,args.output);transport=vc.DirectTransport(backend)
        control=vc.VolumeControl(transport,exclusive_owner=True)
        vc.configure_codec(transport,stopped=True,straps_confirmed=True,mclk_hz=10_000_000)
        control.configure(quiet_sum=11*977,soft_sum=16*977,loud_sum=28*977,enable=True)
        page=VolumeSharedPage(multiprocessing.get_context('spawn'),'01'*16)
        producer=VolumeProducer(control,page,now=x.monotonic_ns)
        publisher=OsdPublisher(OsdIo(backend))
        # Match _volume_worker (20 ms) and InputOsdService._run (33,333,334 ns)
        # with independent deadlines. This models their functional schedule but
        # still does not model Linux/IPC jitter or concurrent CPU execution.
        poll_period=20_000_000;osd_period=33_333_334
        receipt['scheduler']=dict(producer_period_ns=poll_period,osd_period_ns=osd_period,
                                  independent_deadlines=True,linux_jitter_modeled=False)
        next_poll=x.monotonic_ns();next_osd=1_000_000;last_progress=-1
        end_ns=801_000_000 if args.diagnostic_ms is None else args.diagnostic_ms*1_000_000
        while min(next_poll,next_osd)<end_ns:
            x.run_ns(max(0,min(next_poll,next_osd)-x.monotonic_ns()))
            if x.monotonic_ns()>=next_poll:
                producer.poll_once()
                polls.append(page.read_observation())
                next_poll=max(next_poll+poll_period,x.monotonic_ns())
            if x.monotonic_ns()>=next_osd:
                osd_started=x.monotonic_ns()
                observation=page.read_observation()
                t=osd_started/1e9
                x.put('scene_mode',0 if t<.32 else 1 if t<.64 else 2)
                if not (args.scenario=='publisher_paused' and .43<=t<.68):
                    if publisher.tick(None,audio_observation(observation),now_ns=osd_started):
                        commits.append(dict(ns=x.monotonic_ns(),words=list(publisher.last_words),
                                            observed_ns=observation['observed_ns'],sample_count=observation['sample_count']))
                next_osd=osd_started+osd_period
            t=x.monotonic_ns()/1e9
            progress=int(t*10)
            if progress!=last_progress:
                last_progress=progress;observation=polls[-1]
                print(f"sim={t:.3f}s wall={time.monotonic()-started:.1f}s windows={observation['window_count']} ack={observation['ack_count']}",flush=True)
        x.run_ns(max(0,end_ns-x.monotonic_ns()))
        receipt.update(simulation_ns=x.monotonic_ns(),pixel_errors=x.get('pixel_errors'),
                       serial_errors=x.get('serial_errors'),decoded_count=x.get('decoded_count'),
                       background_pixels_checked=x.get('background_pixels_checked'),
                       sync_cycles_checked=x.get('sync_cycles_checked'),
                       osd_commits=publisher.commits,osd_busy_skips=publisher.busy_skips,
                       ack_count=producer.values.get('ack_count',0))
        x.close();x=None
        (args.output/'commits.json').write_text(json.dumps(commits,indent=2),encoding='utf-8')
        (args.output/'polls.jsonl').write_text(''.join(json.dumps(p)+'\n' for p in polls),encoding='utf-8')
        if args.diagnostic_ms is not None:
            receipt['status']='DIAGNOSTIC_ONLY';return
        assert receipt['pixel_errors']==receipt['serial_errors']==0,dict(pixel_errors=receipt['pixel_errors'],serial_errors=receipt['serial_errors'])
        receipt['checks']=validate(args.output,values,commits,args.scenario)
        assert receipt['ack_count']==(0 if args.scenario=='left_missing' else 1 if args.scenario in ('human','project_human') else 2),receipt['ack_count']
        receipt['status']='DIGITAL_FUNCTIONAL_COSIM_PASS'
    except BaseException as error:
        receipt.update(status='FAIL',error=repr(error));raise
    finally:
        if x is not None:x.close()
        if backend is not None:backend.close()
        (args.output/'commits.json').write_text(json.dumps(commits,indent=2),encoding='utf-8')
        (args.output/'polls.jsonl').write_text(''.join(json.dumps(p)+'\n' for p in polls),encoding='utf-8')
        receipt['wall_seconds']=time.monotonic()-started
        (args.output/'receipt.json').write_text(json.dumps(receipt,indent=2),encoding='utf-8')
    print(json.dumps(receipt['checks'],indent=2));print(receipt['status'])


if __name__=='__main__': main()
