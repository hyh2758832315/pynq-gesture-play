"""Observe default-menu volume source/OSD/PC STATUS with an optional voice cue.

Run: python observe_integrated_audio.py --output <new.json> --seconds 25 --cue
Output: original bounded STATUS snapshots, cue/restoration receipt, summaries.
Next: locate the first layer that loses real amplitude; no game/fixture injection.
"""
import argparse,hashlib,json,sys,threading,time
from pathlib import Path
from uuid import uuid4

REPO=Path(__file__).resolve().parents[2]
CANDIDATE=REPO/'deliveries/c6i-pl-vision-volume-osd-r20-admission-r03-20261023'


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True);p.add_argument('--seconds',type=float,default=6)
    modes=p.add_mutually_exclusive_group();modes.add_argument('--cue',action='store_true');modes.add_argument('--speaker-test',action='store_true');args=p.parse_args()
    assert 1<=args.seconds<=40
    sys.path.insert(0,str(CANDIDATE/'python'))
    from pynq_multimodal_game.agent.core import AgentCommand
    from pynq_multimodal_game.agent.transport import AgentClient
    record=dict(status='RUNNING',client_package=CANDIDATE.name,
                client_manifest_sha256=hashlib.sha256((CANDIDATE/'deployment_manifest.json').read_bytes()).hexdigest(),
                game_started=False,test_injected=False,snapshots=[])
    args.output.parent.mkdir(parents=True,exist_ok=True)
    client=AgentClient('192.168.2.99',8765,source_address='192.168.2.1',timeout=4)
    endpoint=sink=app=None;before=None;cue_done=False;buffers=[]
    with args.output.open('x',encoding='utf-8') as output:
        try:
            if args.cue or args.speaker_test:
                from PySide6.QtCore import QByteArray,QBuffer,QCoreApplication,QIODevice
                from PySide6.QtMultimedia import QAudio,QAudioFormat,QAudioSink,QMediaDevices
                from pycaw.pycaw import AudioUtilities
                from base_acoustic_probe import waveform
                app=QCoreApplication.instance() or QCoreApplication([])
                device,=(d for d in QMediaDevices.audioOutputs() if 'Senary' in d.description())
                speaker=AudioUtilities.GetSpeakers();assert bytes(device.id()).decode()==speaker.id
                endpoint=speaker.EndpointVolume;before=dict(mute=bool(endpoint.GetMute()),scalar=endpoint.GetMasterVolumeLevelScalar())
                fmt=QAudioFormat();fmt.setSampleRate(48000);fmt.setChannelCount(1);fmt.setSampleFormat(QAudioFormat.SampleFormat.Int16)
                assert device.isFormatSupported(fmt)
                sink=QAudioSink(device,fmt);record['speaker']=dict(id=speaker.id,before=before)
            record['hello']=client.connect();start=time.monotonic()
            stimuli=((2.0,1.0,640),(5.0,1.0,1000),(8.0,1.0,3000)) if args.speaker_test else ()
            next_stimulus=0;active_stimulus=None;record['speaker_test']=[]
            while time.monotonic()-start<args.seconds:
                elapsed=time.monotonic()-start
                if args.cue and not cue_done and elapsed>=2:
                    endpoint.SetMasterVolumeLevelScalar(1.0,None);endpoint.SetMute(False,None)
                    buffer=QBuffer(sink);buffer.setData(QByteArray(waveform(.1,1000)));assert buffer.open(QIODevice.OpenModeFlag.ReadOnly);buffers.append(buffer)
                    sink.start(buffer);cue_start=time.monotonic()
                    while time.monotonic()-cue_start<.65:app.processEvents();threading.Event().wait(.01)
                    record['cue']=dict(elapsed=elapsed,processed_us=sink.processedUSecs(),remaining=buffer.bytesAvailable(),error=sink.error().value)
                    assert record['cue']['processed_us']>=490000 and record['cue']['remaining']==0 and record['cue']['error']==QAudio.Error.NoError.value
                    sink.stop();cue_done=True;print('INTEGRATED_VOICE_CUE_COMPLETE',flush=True)
                if args.speaker_test and active_stimulus is None and next_stimulus<len(stimuli) and elapsed>=stimuli[next_stimulus][0]:
                    _,amplitude,hz=stimuli[next_stimulus]
                    endpoint.SetMasterVolumeLevelScalar(1.0,None);endpoint.SetMute(False,None)
                    applied_scalar=endpoint.GetMasterVolumeLevelScalar()
                    assert abs(applied_scalar-1.0)<1e-5 and not endpoint.GetMute()
                    buffer=QBuffer(sink);buffer.setData(QByteArray(waveform(amplitude,hz)));assert buffer.open(QIODevice.OpenModeFlag.ReadOnly);buffers.append(buffer)
                    active_stimulus=dict(index=next_stimulus,amplitude=amplitude,hz=hz,started_elapsed=elapsed,master_scalar=applied_scalar)
                    sink.start(buffer);next_stimulus+=1
                requested=time.monotonic_ns();response=client.command(uuid4().hex,AgentCommand.STATUS)
                record['snapshots'].append(dict(pc_ns=requested,response=response));assert response['ok']
                if app:app.processEvents()
                if active_stimulus is not None and time.monotonic()-start-active_stimulus['started_elapsed']>=.65:
                    active_stimulus.update(processed_us=sink.processedUSecs(),remaining=buffers[-1].bytesAvailable(),error=sink.error().value)
                    assert active_stimulus['processed_us']>=490000 and active_stimulus['remaining']==0 and active_stimulus['error']==QAudio.Error.NoError.value
                    sink.stop();record['speaker_test'].append(active_stimulus);active_stimulus=None
                threading.Event().wait(.03)
            snapshots=[s['response']['snapshot'] for s in record['snapshots']]
            workers=[s['volume']['worker'] for s in snapshots]
            levels=[w['l1_sum']/977 for w in workers]
            osds=[s['vision']['hdmi_osd'] for s in snapshots]
            record['summary']=dict(samples=len(snapshots),pl_page_min=min(levels),pl_page_max=max(levels),
                soft_samples=sum(v>=16 for v in levels),loud_samples=sum(v>=28 for v in levels),
                ack_count_first=workers[0]['ack_count'],ack_count_last=workers[-1]['ack_count'],
                states=sorted(set(w['state'] for w in workers)),faults=sorted(set(w['faults'] for w in workers)),
                windows_first=workers[0]['window_count'],windows_last=workers[-1]['window_count'],
                osd_audio_min=min(o['audio_source']['mean_abs'] for o in osds),osd_audio_max=max(o['audio_source']['mean_abs'] for o in osds),
                osd_height_min=min(o['last_submitted_words'][2]&0xffff for o in osds),osd_height_max=max(o['last_submitted_words'][2]&0xffff for o in osds),
                osd_invalid_samples=sum(not(o['last_submitted_words'][0]&8) for o in osds),
                errors=[s['volume']['error'] for s in snapshots if s['volume']['error'] is not None],runtime_modes=sorted(set(s['runtime_mode'] for s in snapshots)))
            record['status']='INTEGRATED_AUDIO_STATUS_CAPTURE_COMPLETE';print(json.dumps(record['summary']),flush=True)
        except BaseException as error:record.update(status='FAIL',error=repr(error));raise
        finally:
            client.close()
            if sink:sink.stop()
            if endpoint:
                endpoint.SetMasterVolumeLevelScalar(before['scalar'],None);endpoint.SetMute(before['mute'],None)
                after=dict(mute=bool(endpoint.GetMute()),scalar=endpoint.GetMasterVolumeLevelScalar());record['speaker'].update(after=after,restored=before['mute']==after['mute'] and abs(before['scalar']-after['scalar'])<1e-5)
            json.dump(record,output,indent=2)


if __name__=='__main__':main()
