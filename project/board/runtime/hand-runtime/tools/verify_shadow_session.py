"""Actual frozen game hook + publisher thread + independent shadow interpreter.
Run: hand-python -I -B tools/verify_shadow_session.py --candidate DIR --output NEW.json
Outputs: receipt and unique child directory/logs. Next: ARM same-host repeat.
No Agent startup, SDK hand, serial, MMIO or hardware motion.
"""
import argparse
import hashlib
import json
from pathlib import Path
import sys
import threading
import time

ROOT=Path(__file__).resolve().parents[1]


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--candidate',type=Path,required=True)
    parser.add_argument('--output',type=Path,required=True)
    args=parser.parse_args()
    candidate=args.candidate.resolve(strict=True)
    if args.output.exists():raise FileExistsError(args.output)
    manifest=json.loads((candidate/'deployment_manifest.json').read_text())
    for name,digest in manifest['sha256'].items():
        if name.startswith('python/'):
            assert hashlib.sha256((candidate/name).read_bytes()).hexdigest().upper()==digest,name
    sys.path[:0]=[str(ROOT/'src'),str(candidate/'python')]
    from pynq_usb_hand.game_bridge import GameFeed,install_game_observer
    from pynq_usb_hand.shadow_session import HandShadowSession
    from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime
    from pynq_multimodal_game.vision_input import GameVisionInputProvider
    args.output.parent.mkdir(parents=True,exist_ok=True)
    directory=args.output.with_suffix('')
    feed=GameFeed()
    session=HandShadowSession(feed,python=sys.executable,hand_root=ROOT,output_dir=directory,seconds=8)
    provider=GameVisionInputProvider(clock=time.monotonic)
    runtime=object.__new__(PackagedGameRuntime)
    runtime._live_input=provider;runtime._game_id='game2';runtime._game_run='shadow-verification'
    runtime._test_case=None;runtime._paused=threading.Event();runtime._thread=None;runtime._last_error=None
    uninstall=install_game_observer(PackagedGameRuntime,feed)
    record=dict(status='RUNNING',hardware_motion=False,serial_opened=False)
    with args.output.open('x') as output:
        try:
            session.start()
            frame=0
            for stable,label in (('5','PAPER'),('0','ROCK'),('2','SCISSORS')):
                for index in range(12):
                    frame+=1
                    provider.publish(dict(run_id='shadow-vision',server_age_ms=0,stable=stable,rps=label,
                        control=dict(schema='gesture-control-v1',frame_id=frame,action_event_seq=0,valid=True,direction='LEFT')),
                        config_epoch='shadow-config')
                    runtime._sample_live_input(frame)
                    time.sleep(.05)
            try:runtime.pause()
            except RuntimeError:pass # Original runtime is deliberately not rendering; hook still revokes first.
            assert session.finished.wait(4),'Shadow cleanup deadline'
            assert session.error is None,session.error
            child=json.loads((directory/'shadow.json').read_text())
            publisher=json.loads((directory/'publisher.json').read_text())
            assert child['status']=='SHADOW_OBSERVED' and child['frames']>=6,child
            assert set(child['gestures'])=={'paper','fist','scissors'},child
            assert child['stop_reason']=='producer_revoked' and not child['forbidden_modules'],child
            assert publisher['child_exit']==0 and not publisher.get('child_terminated',False),publisher
            assert child['pid']==publisher['child_pid']!=publisher['producer_pid']
            record.update(status='FROZEN_RUNTIME_TWO_PROCESS_SHADOW_PASS',sampled_frames=frame,child=child,publisher=publisher)
            # A stopped producer must expire without a pause/revoke message.
            silent_feed=GameFeed()
            silent_dir=directory.with_name(directory.name+'-silent')
            silent=HandShadowSession(silent_feed,python=sys.executable,hand_root=ROOT,output_dir=silent_dir,seconds=5)
            try:
                silent.start()
                for index in range(12):
                    frame+=1
                    provider.publish(dict(run_id='shadow-vision',server_age_ms=0,stable='5',rps='PAPER',
                        control=dict(schema='gesture-control-v1',frame_id=frame,action_event_seq=0,valid=True,direction='LEFT')),
                        config_epoch='shadow-config')
                    value,receipt=provider.sample_for_game('game2',tick_id=frame)
                    silent_feed.offer('silent-game',value,receipt,now=time.monotonic())
                    time.sleep(.05)
                assert silent.finished.wait(3),'Silent source did not expire'
                assert silent.error is None,silent.error
                silent_child=json.loads((silent_dir/'shadow.json').read_text())
                assert silent_child['frames']>0 and silent_child['stop_reason']=='stale_source',silent_child
                record['source_silence']=silent_child
            finally:silent.close()
            # Waiting for a game does not create a child; explicit close is bounded.
            empty_feed=GameFeed()
            empty_dir=directory.with_name(directory.name+'-empty')
            empty=HandShadowSession(empty_feed,python=sys.executable,hand_root=ROOT,output_dir=empty_dir,seconds=60)
            empty.start();empty.close()
            empty_result=json.loads((empty_dir/'publisher.json').read_text())
            assert empty.error is None and 'launch_pid' not in empty_result and empty.finished.is_set(),empty_result
            record['close_before_game']=empty_result
        except BaseException as error:
            record.update(status='FAIL',error=repr(error));raise
        finally:
            uninstall();session.close()
            files=[Path(__file__),ROOT/'src/pynq_usb_hand/game_bridge.py',ROOT/'src/pynq_usb_hand/shadow_session.py',
                   ROOT/'tools/shadow_receiver.py',candidate/'python/pynq_multimodal_game/agent/game_runtime.py']
            record['source_sha256']={str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in files}
            json.dump(record,output,indent=2)
    print(record['status'])


if __name__=='__main__':main()
