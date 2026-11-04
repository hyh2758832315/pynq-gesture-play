"""Real Agent/GPU OSD acceptance. All responses and failed attempts persist.

Run with project venv/network: .../board_acceptance.py ACTION --label UNIQUE
Actions: observe, fixtures, goldens, modes, performance, live.
Outputs: evidence/LABEL.json + complete per-golden reports.
Next: inspect all automatic gates and retain final human HDMI/gesture/acoustic test.
"""
import argparse
import hashlib
import json
from pathlib import Path
import statistics
import sys
import threading
import time
from uuid import uuid4

HERE=Path(__file__).resolve().parent
REPO=HERE.parents[2]
bootstrap=argparse.ArgumentParser(add_help=False)
bootstrap.add_argument('--candidate',type=Path)
configuration,_=bootstrap.parse_known_args()
CHILD=configuration.candidate.resolve() if configuration.candidate is not None else REPO/'deliveries/c6i-pl-vision-volume-osd-r17-20261023'
GAMES=CHILD/'games/pl-c0e-r01'
sys.path.insert(0,str(CHILD/'python'))
from pynq_multimodal_game.agent.core import AgentCommand,ArtifactManifest
from pynq_multimodal_game.agent.transport import AgentClient
from pynq_multimodal_game.game_validation import compare_test_reports


def load(path): return json.loads(path.read_text(encoding='utf-8'))
def save(path,data):
    with path.open('x',encoding='utf-8') as output: json.dump(data,output,indent=2,allow_nan=False)


def validate_video_pause(paused,first,last,settled_first,settled_last):
    assert all(snapshot['state']=='paused' for snapshot in (paused,first,last,settled_first,settled_last))
    assert 0<=last['presented_frames']-paused['presented_frames']<=1
    assert first['presented_frames']<=last['presented_frames']
    assert last['presented_frames']==settled_first['presented_frames']==settled_last['presented_frames']
    assert last['frame_index']==settled_first['frame_index']==settled_last['frame_index']


def audio_source_valid(snapshot):
    osd=snapshot['vision']['hdmi_osd']
    source=osd['audio_source']
    return (source['healthy'] and 0<=source['age_ms']<100 and
            (not osd.get('enabled',True) or bool(osd['last_submitted_words'][0]&8)))


def distribution(values):
    values=[value for value in values if value is not None]
    if not values: return None
    percentiles=statistics.quantiles(values,n=100,method='inclusive') if len(values)>1 else values*99
    return dict(count=len(values),p50=statistics.median(values),p95=percentiles[94],p99=percentiles[98],maximum=max(values))


class Acceptance:
    def __init__(self,args):
        self.args=args
        self.destination=HERE/'evidence'/(args.label+'.json')
        if self.destination.exists(): raise FileExistsError(self.destination)
        self.record=dict(status='RUNNING',action=args.action,responses=[],observations=[],summaries=[],error=None)
        self.client=AgentClient('192.168.2.99',8765,source_address='192.168.2.1',timeout=120)

    def command(self,kind,**kwargs):
        started=time.monotonic()
        response=self.client.command(uuid4().hex,kind,**kwargs)
        self.record['responses'].append(dict(command=kind.value,elapsed_s=time.monotonic()-started,response=response))
        assert response['ok'],response
        assert response['snapshot']['last_error'] is None,response
        return response

    def status(self):
        snapshot=self.command(AgentCommand.STATUS)['snapshot']
        volume=snapshot['volume']
        assert volume['error'] is None and volume['sampling_enabled'] and volume['poller_alive'],volume
        assert volume['worker']['faults']==0 and not volume['worker']['ack_error'],volume
        vision=snapshot['vision']
        assert vision['state']=='RUNNING' and vision['last_error'] is None,vision
        osd=vision['hdmi_osd']
        assert osd['thread_alive'] and osd['error'] is None,osd
        assert osd.get('register_io','scalar-register-io')=='scalar-register-io',osd
        return snapshot

    def observe(self,seconds,label):
        started=time.monotonic()
        samples=[]
        while True:
            snap=self.status()
            samples.append(snap)
            if time.monotonic()-started>=seconds: break
            threading.Event().wait(.25)
        first,last=samples[0],samples[-1]
        elapsed=time.monotonic()-started
        a,b=first['vision']['hdmi_osd'],last['vision']['hdmi_osd']
        assert last['vision']['frame_id']>first['vision']['frame_id']
        assert last['volume']['worker']['monitor_count']>first['volume']['worker']['monitor_count']
        assert b['commits']>a['commits']
        commits=(b['commits']-a['commits'])/elapsed
        cpu=(b['cpu_ns']-a['cpu_ns'])/(elapsed*1e9)*100
        metrics=[dict(hand_age_ms=sample['vision']['hdmi_osd'].get('hand_source',{}).get('age_ms'),
                  audio_age_ms=sample['vision']['hdmi_osd']['audio_source']['age_ms'],
                  osd_tick_age_ms=sample['vision']['hdmi_osd']['last_tick_age_ms']) for sample in samples]
        summary=dict(label=label,seconds=elapsed,osd_commits_hz=commits,osd_thread_one_core_percent=cpu,
            osd_cpu_reference_one_core_percent=2.47960994,
            osd_cpu_limit_percent=getattr(self.args,'max_osd_cpu_percent',None),
            vision_fps=(last['vision']['frame_id']-first['vision']['frame_id'])/elapsed,
            volume_monitor_hz=(last['volume']['worker']['monitor_count']-first['volume']['worker']['monitor_count'])/elapsed,
            max_osd_tick_age_ms=max(s['vision']['hdmi_osd']['last_tick_age_ms'] for s in samples),
            max_audio_source_age_ms=max(s['vision']['hdmi_osd']['audio_source']['age_ms'] for s in samples),
            audio_valid_fraction=sum(audio_source_valid(s) for s in samples)/len(samples),
            sampled_ages=metrics,age_distributions={key:distribution(item[key] for item in metrics) for key in metrics[0]},
            age_semantics='Same-board observation publication age, not camera SOF or physical display latency.',
            first=first,last=last)
        self.record['summaries'].append(summary)
        assert commits>=20,summary
        assert 0<=cpu<=100,summary
        if summary['osd_cpu_limit_percent'] is not None:
            assert cpu<=summary['osd_cpu_limit_percent'],summary
        assert summary['max_osd_tick_age_ms']<100,summary
        assert summary['audio_valid_fraction']>=.8,summary
        print('OSD_OBSERVE_PASS',label,round(commits,2),round(cpu,3),flush=True)
        return first,last

    def install(self,name,kind='game'):
        path=GAMES/name if kind=='game' else HERE/'evidence'/name
        artifact=ArtifactManifest.for_path(path,artifact_kind='game.vvg' if kind=='game' else 'video.s2v',
                                           target_build_id=0xC0060E00,abi_major=1,abi_minor=0)
        item_id='r17-'+path.stem.lower()
        listing=self.command(AgentCommand.LIBRARY_LIST,library_kind=kind)['library_items']
        installed={item['item_id']:item for item in listing}
        if item_id not in installed:
            result=self.client.upload_file(path,artifact,upload_id=uuid4().hex)
            self.record['responses'].append(dict(command='upload',response=result))
            self.command(AgentCommand.LIBRARY_INSTALL,item_id=item_id,library_kind=kind,display_name='C0E '+path.stem)
            installed={item['item_id']:item for item in self.command(AgentCommand.LIBRARY_LIST,library_kind=kind)['library_items']}
        assert installed[item_id]['sha256']==artifact.sha256 and installed[item_id]['length']==artifact.length
        return item_id

    def fixture(self,fist=False,x=0.,y=0.):
        payload=dict(x=x,y=y,position_valid=True,fist=fist,mean_abs=20.,soft=16.,loud=28.,hold_ms=1000)
        self.command(AgentCommand.INPUT_OSD_TEST,payload=json.dumps(payload).encode())
        deadline=time.monotonic()+.25
        flags=15 if fist else 11
        while True:
            snap=self.status()
            osd=snap['vision']['hdmi_osd']
            words=osd['last_submitted_words']
            if words[0]==flags and osd['hand_source']['run'].startswith('OSD_TEST:'): break
            assert time.monotonic()<deadline,osd
            threading.Event().wait(.005)
        assert (words[1]&2047)==round((x+1)*1279/2)
        assert ((words[1]>>16)&1023)==round((y+1)*719/2)
        assert (words[2]&1023)==86 and (words[2]>>16)==69 and (words[3]&1023)==120
        threading.Event().wait(.32)
        expired=self.status()['vision']['hdmi_osd']
        assert expired['test_active'] and expired['last_submitted_words'][0]==1,expired
        assert expired['hand_source']['age_ms']>=250 and expired['audio_source']['age_ms']>=100
        self.command(AgentCommand.INPUT_OSD_TEST,payload=b'{}')
        print('OSD_FIXTURE_AND_TTL_PASS',fist,x,y,flush=True)

    def goldens(self):
        metadata=load(GAMES/'verification.json')
        entries=[entry for entry in metadata['cases'] if not self.args.ids or entry['test_id'] in self.args.ids]
        assert entries
        for entry in entries:
            report_path=HERE/'evidence'/(self.args.label+'-'+entry['test_id']+'-gpu.json')
            if report_path.exists(): raise FileExistsError(report_path)
            pc=load(GAMES/(entry['test_id']+'.pc-report.json'))
            assert pc['status']=='passed'
            item=self.install(entry['package'])
            self.command(AgentCommand.LIBRARY_RUN,item_id=item,library_kind='game',test_case_json=json.dumps(pc['test_case']))
            deadline=time.monotonic()+180
            while True:
                snapshot=self.status()
                if snapshot['test_complete']:
                    comparison=compare_test_reports(pc,snapshot['game_test_report'])
                    save(report_path,dict(comparison=comparison,report=snapshot['game_test_report']))
                    assert comparison['status']=='passed',comparison
                    print('C0E_REAL_GPU_GOLDEN_PASS',entry['test_id'],comparison['matched_ticks'],flush=True)
                    break
                assert time.monotonic()<deadline,entry
                threading.Event().wait(.5)
            assert self.command(AgentCommand.STOP)['snapshot']['runtime_mode']=='menu'

    def modes(self):
        item=self.install('game1-volume-v1.vvg')
        self.command(AgentCommand.LIBRARY_RUN,item_id=item,library_kind='game')
        self.observe(3,'live-game')
        self.command(AgentCommand.GAME_PAUSE)
        first,last=self.observe(3,'paused-game')
        assert first['game_tick']==last['game_tick'] and last['state']=='paused'
        self.fixture(fist=True)
        self.command(AgentCommand.GAME_RESUME)
        self.command(AgentCommand.STOP)
        self.observe(3,'returned-default-menu')
        video=HERE/'evidence/c0e-osd-static-120.s2v'
        if not video.exists():
            import numpy as np
            from pynq_multimodal_game.video_codec import encode_rgb_frames
            frame=np.zeros((180,320,3),dtype=np.uint8)
            frame[:90,:,1]=120;frame[90:,:,2]=100
            encode_rgb_frames((frame for _ in range(120)),video)
        item=self.install(video.name,'video')
        self.command(AgentCommand.LIBRARY_RUN,item_id=item,library_kind='video')
        self.observe(1,'playing-static-video')
        paused=self.command(AgentCommand.PAUSE)['snapshot']
        first,last=self.observe(3,'paused-static-video')
        settled_first,settled_last=self.observe(1,'settled-paused-static-video')
        validate_video_pause(paused,first,last,settled_first,settled_last)
        self.record['video_pause_contract']='At most one already admitted frame may finish; counters and frame must then remain frozen.'
        self.fixture()
        self.command(AgentCommand.STOP)
        self.record['image_scope']='Image playback is an existing placeholder; overlay is on the common final HDMI path for every submenu. No new image player was introduced.'

    def performance(self):
        assert self.status()['runtime_mode']=='menu'
        for enabled in (False,True,True,False):
            self.command(AgentCommand.INPUT_OSD_SET,payload=json.dumps(dict(enabled=enabled)).encode())
            self.observe(15,'menu-osd-'+str(enabled))
        self.command(AgentCommand.INPUT_OSD_SET,payload=b'{"enabled":true}')
        self.observe(self.args.seconds,'enabled-menu-soak')

    def run(self):
        try:
            hello=self.client.connect()
            self.record['hello']=hello
            assert hello['build_id']==0xC0060E00 and hello['profile']=='C6I_PL_VISION_VOLUME_OSD_V1'
            assert hello['game_sdk']==dict(major=1,minor=3) and hello['input_schema_version']==4
            deadline=time.monotonic()+30
            while True:
                startup=self.command(AgentCommand.STATUS)['snapshot']
                if startup['vision']['state']=='RUNNING': break
                assert startup['vision']['state']=='STARTING' and time.monotonic()<deadline,startup
                threading.Event().wait(.25)
            self.status()
            if self.args.action=='observe': self.observe(10,'default-menu-startup')
            elif self.args.action=='fixtures':
                for x,y,fist in ((-.8,-.8,False),(0.,0.,False),(.8,.8,True)): self.fixture(fist,x,y)
                self.command(AgentCommand.INPUT_OSD_SET,payload=b'{"enabled":false}')
                threading.Event().wait(.1)
                assert not self.status()['vision']['hdmi_osd']['last_submitted_words'][0]&1
                self.command(AgentCommand.INPUT_OSD_SET,payload=b'{"enabled":true}')
            elif self.args.action=='goldens': self.goldens()
            elif self.args.action=='modes': self.modes()
            elif self.args.action=='performance': self.performance()
            elif self.args.action=='live':
                item=self.install('game3-volume-v1.vvg')
                self.command(AgentCommand.LIBRARY_RUN,item_id=item,library_kind='game')
                self.observe(self.args.seconds,'final-live-game3')
            elif self.args.action=='production':
                osd=self.status()['vision']['hdmi_osd']
                assert osd['enabled'] and not osd['test_allowed'] and not osd['test_active']
                for kind in (AgentCommand.INPUT_OSD_TEST,):
                    response=self.client.command(uuid4().hex,kind,payload=b'{}')
                    self.record['responses'].append(dict(command=kind.value,response=response,expected_denial=True))
                    assert not response['ok'],response
                self.status()
            self.record['status']='PASS'
        except BaseException as error:
            self.record.update(status='FAIL',error=f'{type(error).__name__}: {error}')
            raise
        finally:
            self.client.close()
            save(self.destination,self.record)
        print('C0E_BOARD_ACCEPTANCE_PASS',self.args.action,flush=True)


if __name__=='__main__':
    parser=argparse.ArgumentParser()
    parser.add_argument('action',choices=('observe','fixtures','goldens','modes','performance','live','production'))
    parser.add_argument('--candidate',type=Path)
    parser.add_argument('--label',required=True)
    parser.add_argument('--ids',nargs='*')
    parser.add_argument('--seconds',type=int,default=120)
    parser.add_argument('--max-osd-cpu-percent',type=float)
    args=parser.parse_args()
    if args.max_osd_cpu_percent is not None and not 0<args.max_osd_cpu_percent<=100:
        parser.error('--max-osd-cpu-percent must be within (0,100]')
    if not args.label.replace('-','').isalnum(): raise ValueError('unsafe label')
    Acceptance(args).run()
