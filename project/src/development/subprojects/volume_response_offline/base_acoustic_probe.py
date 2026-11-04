"""Official Base capture plus explicit physical PC speaker pulse experiment.

Run: .venv/Scripts/python subprojects/volume_response_offline/base_acoustic_probe.py --output build/volume-response/acoustic-a01 --speaker Senary --run
Output: PC/SSH logs, stimulus WAVs, restoration receipt, board capture files.
Next: collect and analyze raw PCM; successful playback is not microphone PASS.
"""
import argparse
from array import array
import hashlib,json,math,queue,re,subprocess,threading,time,wave
from pathlib import Path
from capture_base_source import SOURCE


def waveform(amplitude,hz):
    rate=48000;count=24000
    return array('h',(round(32767*amplitude*min(1,i/240,(count-1-i)/240)*math.sin(2*math.pi*hz*i/rate)) for i in range(count))).tobytes()


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output',type=Path,required=True);parser.add_argument('--speaker',default='Senary');parser.add_argument('--run',action='store_true')
    parser.add_argument('--round',default='a01');parser.add_argument('--gate',type=Path,default=Path('build/volume-response/board-gate-a01.json'))
    parser.add_argument('--manual-voice',action='store_true')
    parser.add_argument('--ready-timeout',type=float,default=30)
    parser.add_argument('--finish-timeout',type=float)
    args=parser.parse_args()
    assert 10<=args.ready_timeout<=180
    finish_timeout=args.finish_timeout if args.finish_timeout is not None else (40 if args.manual_voice else 20)
    assert 10<=finish_timeout<=180
    assert re.fullmatch(r'a\d{2}',args.round)
    source=SOURCE.replace('/volume-response-a01','/volume-response-'+args.round)
    if args.manual_voice:
        source=source.replace('seconds=12','seconds=32').replace('audio.record(12)','audio.record(32)')
    compile(source,'remote-base-capture','exec')
    if not args.run:
        print('BASE_PROBE_CHECK_ONLY_PASS (no board/audio access)');return
    gate=json.loads(args.gate.read_text())
    assert gate['gate']=='READ_ONLY_IDLE_GATE_PASS' and time.time()-gate['finished_unix']<3600
    source=source.replace('db5b70bc-7b6e-4af0-9f3a-6845e782b31c',gate['state']['boot_id'])
    from PySide6.QtCore import QByteArray,QBuffer,QCoreApplication,QIODevice
    from PySide6.QtMultimedia import QAudio,QAudioFormat,QAudioSink,QMediaDevices
    from pycaw.pycaw import AudioUtilities
    app=QCoreApplication.instance() or QCoreApplication([])
    device,=(d for d in QMediaDevices.audioOutputs() if args.speaker in d.description())
    speaker=AudioUtilities.GetSpeakers();assert bytes(device.id()).decode()==speaker.id
    endpoint=speaker.EndpointVolume
    before=dict(mute=bool(endpoint.GetMute()),scalar=endpoint.GetMasterVolumeLevelScalar())
    args.output.mkdir(parents=True,exist_ok=False)
    receipt=dict(status='PREPARED',speaker=dict(name=device.description(),id=speaker.id,before=before),board_source_sha256=hashlib.sha256(source.encode()).hexdigest(),pulses=[],microphone_response_verified=False,ready_timeout=args.ready_timeout,finish_timeout=finish_timeout)
    def save():
        (args.output/'receipt.json').write_text(json.dumps(receipt,indent=2),encoding='utf-8')
    save()
    fmt=QAudioFormat();fmt.setSampleRate(48000);fmt.setChannelCount(1);fmt.setSampleFormat(QAudioFormat.SampleFormat.Int16)
    assert device.isFormatSupported(fmt)
    sink=QAudioSink(device,fmt);buffers=[];lines=[];messages=queue.Queue()
    command=['ssh','-b','192.168.2.1','-o','BatchMode=yes','-o','StrictHostKeyChecking=yes','-o','ConnectTimeout=8','pynq-z2','sudo -n /usr/local/share/pynq-venv/bin/python -B -']
    receipt['command']=command;(args.output/'remote_source.py').write_text(source)
    process=None
    try:
        process=subprocess.Popen(command,stdin=subprocess.PIPE,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True,bufsize=1)
        process.stdin.write(source);process.stdin.close()
        def collect():
            for line in process.stdout:lines.append(line);messages.put(line)
        reader=threading.Thread(target=collect,daemon=True);reader.start()
        deadline=time.monotonic()+args.ready_timeout
        while True:
            if process.poll() is not None:raise RuntimeError('capture exited before ready; inspect board.log')
            try:line=messages.get(timeout=.1)
            except queue.Empty:line=''
            if line.startswith('BASE_CAPTURE_READY '):break
            if time.monotonic()>deadline:raise RuntimeError('native capture readiness timeout; do not kill owner')
        receipt.update(status='RECORDING',ready_pc_ns=time.monotonic_ns());save()
        endpoint.SetMasterVolumeLevelScalar(.65,None);endpoint.SetMute(False,None)
        def wait(seconds):
            deadline=time.monotonic()+seconds
            while time.monotonic()<deadline:app.processEvents();threading.Event().wait(.01)
        wait(1)
        stimuli=((.1,1000),) if args.manual_voice else ((.05,640),(.1,640),(.2,640),(.1,3000),(.2,3000))
        for amplitude,hz in stimuli:
            pcm=waveform(amplitude,hz)
            name=f'pulse-{len(receipt["pulses"])}.wav'
            with wave.open(str(args.output/name),'wb') as wav:wav.setnchannels(1);wav.setsampwidth(2);wav.setframerate(48000);wav.writeframes(pcm)
            buffer=QBuffer(sink);buffer.setData(QByteArray(pcm));assert buffer.open(QIODevice.OpenModeFlag.ReadOnly);buffers.append(buffer)
            trial=dict(amplitude=amplitude,hz=hz,requested_pc_ns=time.monotonic_ns(),pcm_sha256=hashlib.sha256(pcm).hexdigest())
            receipt['pulses'].append(trial);sink.start(buffer);wait(.65)
            trial.update(processed_us=sink.processedUSecs(),bytes_remaining=buffer.bytesAvailable(),error=sink.error().value)
            assert trial['processed_us']>=490000 and trial['bytes_remaining']==0 and trial['error']==QAudio.Error.NoError.value
            sink.stop();save();wait(.65)
        if args.manual_voice:
            receipt['mode']='human_voice_after_single_cue';save()
            print('HUMAN_VOICE_RECORDING_ACTIVE: cue complete; recording the following voice and pauses',flush=True)
        deadline=time.monotonic()+finish_timeout
        while process.poll() is None and time.monotonic()<deadline:wait(.1)
        if process.poll() is None:raise RuntimeError('native capture exit unconfirmed; retain board')
        reader.join(2);assert process.returncode==0
        final=[json.loads(line.removeprefix('BASE_CAPTURE_FINAL ')) for line in lines if line.startswith('BASE_CAPTURE_FINAL ')]
        assert len(final)==1 and final[0]['phase']=='recorded' and final[0]['cleanup_confirmed']
        receipt.update(status='BASE_CAPTURE_AND_PLAYBACK_COMPLETE',capture=final[0])
    except BaseException as e:
        receipt.update(status='FAIL',error=repr(e));raise
    finally:
        sink.stop()
        endpoint.SetMasterVolumeLevelScalar(before['scalar'],None);endpoint.SetMute(before['mute'],None)
        after=dict(mute=bool(endpoint.GetMute()),scalar=endpoint.GetMasterVolumeLevelScalar())
        receipt['speaker'].update(after=after,restored=after['mute']==before['mute'] and abs(after['scalar']-before['scalar'])<1e-5)
        receipt['remote_process_exit']=None if process is None else process.poll()
        (args.output/'board.log').write_text(''.join(lines),encoding='utf-8');save()
        assert receipt['speaker']['restored']
    print(receipt['status'],receipt['capture']['channels'])


if __name__=='__main__':main()
