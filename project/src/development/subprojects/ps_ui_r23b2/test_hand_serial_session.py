"""Offline serial-owner integration with real UDP and SDK memory packets.

Run: subprojects/pynq_usb_hand/.venv/Scripts/python.exe -B subprojects/ps_ui_r23b2/test_hand_serial_session.py
Expected: unittest pass; no output files outside temporary test directories.
Next: observe the isolated approval-window candidate on the board.
"""

import copy
import importlib.util
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import threading
import time
from types import SimpleNamespace
import unittest
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[2]
HAND = Path(os.environ.get('HAND_CANDIDATE_ROOT', ROOT / 'build/hand-r43-creative-r06')).resolve()
CANDIDATE = ROOT / "subprojects/ps_ui_r23b2"
sys.path[:0] = [str(CANDIDATE / "python"), str(HAND / "src"), str(HAND / "tests")]

from pynq_multimodal_game.hand_serial_session import SerialHandActionSession
from pynq_multimodal_game.hand_shadow_bridge import create_serial_action_session
from pynq_usb_hand.orca_backend import OrcaModel
from memory_hand import MemoryHand

spec = importlib.util.spec_from_file_location("serial_child_under_test", CANDIDATE / "hand_child/serial_motion_receiver.py")
child_entry = importlib.util.module_from_spec(spec)
spec.loader.exec_module(child_entry)


class Provider:
    frame = 0

    def peek_hand_classification(self):
        self.frame += 1
        now = time.monotonic()
        return dict(run_id="run", config_epoch="config", frame_id=self.frame,
                    observed_at=now, source_at=now, valid=True, gesture="paper")


class SerialSessionTests(unittest.TestCase):
    def gate(self):
        return SimpleNamespace(passed=True, report_path=Path("checked-report.json"),
                               root=HAND, python=Path(sys.executable), port=child_entry.PORT)

    def test_parent_udp_child_and_real_sdk_all_off(self):
        self.exercise_parent()

    def test_bounded_validation_uses_the_same_checked_owner(self):
        self.exercise_parent(seconds=3)

    def test_cpu_model_warmup_precedes_source_channel_and_motor_connect(self):
        self.exercise_parent(warm_seconds=.8)

    def test_whole_approval_window_propagates_through_real_udp_and_sdk(self):
        self.exercise_parent(hold_seconds=.6, approval_seconds=.3)

    def exercise_parent(self, hold_seconds=.25, seconds=None, warm_seconds=0, approval_seconds=None,
                        preview_interlock=False, preview_cycles=1, stop_paused=False, initial_preview=False,
                        inject_unlabelled=False, source_gap=False, source_gap_preview=False, page_mode='live', cancel_demo=False,
                        video_pause=False, paused_page_delay=0, control_gap=False, page_storage_gap=False,
                        demo_page_gap=False, repeat_follow=False, coexist=False, coexist_video=False):
        model = OrcaModel(HAND)
        backends = []
        warming = threading.Event()
        frozen = threading.Event()
        gesture = ['paper']
        model_loads = []
        publishers = []
        encoding_busy = [False]
        silent = threading.Event()
        page_silent = threading.Event()
        from pynq_usb_hand.game_bridge import DatagramPublisher
        def publisher_factory(*args,**kwargs):
            publisher=DatagramPublisher(*args,**kwargs)
            publish=publisher.publish
            publisher.publish=lambda: False if silent.is_set() else publish()
            publishers.append(publisher);return publisher
        class WarmProvider(Provider):
            previous = None
            def peek_hand_classification(self):
                if (warming.is_set() or frozen.is_set()) and self.previous is not None:
                    return self.previous
                self.previous = super().peek_hand_classification()
                self.previous['gesture'] = gesture[0]
                return self.previous
        def model_factory(_root):
            model_loads.append(_root)
            warming.set()
            time.sleep(warm_seconds)
            warming.clear()
            return model

        def backend_factory(*args, **kwargs):
            backend = MemoryHand(model)
            backends.append(backend)
            return backend

        class ThreadChild:
            def __init__(self, command, **kwargs):
                self.pid = os.getpid()
                self.returncode = None
                def option(name):
                    return command[command.index(name) + 1]
                args = SimpleNamespace(
                    hand_root=Path(option("--hand-root")), session=option("--session"),
                    game_run=option("--game-run"), peer_port=int(option("--peer-port")),
                    output_dir=Path(option("--output-dir")),
                    seconds=float(option("--seconds")) if "--seconds" in command else None,
                    approval_seconds=float(option("--approval-seconds")) if "--approval-seconds" in command else None,
                    port=option("--port"), enable_motion="--enable-motion" in command,
                    preview_interlock='--preview-interlock' in command,
                    page_control='--page-control' in command,
                    stage_waits=tuple(map(float, command[command.index("--stage-waits") + 1:
                                                          command.index("--stage-waits") + 4])),
                )
                def target():
                    report = child_entry.run(args)
                    self.returncode = 0 if report["active"] and report["release_confirmed"] else 1
                self.thread = threading.Thread(target=target)
                self.thread.start()

            def poll(self):
                return self.returncode

            def wait(self, timeout):
                self.thread.join(timeout)
                if self.thread.is_alive():
                    raise subprocess.TimeoutExpired("thread-child", timeout)
                return self.returncode

            def terminate(self):
                raise AssertionError("serial owner must never be killed")

        with tempfile.TemporaryDirectory() as temporary, \
                patch("serial.Serial.open", side_effect=AssertionError("REAL_SERIAL_FORBIDDEN")), \
                patch.object(child_entry, "verify_serial_device"), \
                patch.object(child_entry.signal, "signal"), \
                patch("pynq_usb_hand.orca_backend.OrcaModel", side_effect=model_factory), \
                patch("pynq_usb_hand.orca_backend.OrcaBackend", side_effect=backend_factory), \
                patch('pynq_usb_hand.game_bridge.DatagramPublisher',side_effect=publisher_factory), \
                patch("pynq_multimodal_game.hand_serial_session.subprocess.Popen", ThreadChild):
            session = create_serial_action_session(
                WarmProvider(), gate=self.gate(), package_root=CANDIDATE,
                output_dir=Path(temporary), stage_waits=(.001,) * 3, seconds=seconds,
                approval_seconds=approval_seconds,
            )
            session.set_page_mode(page_mode)
            publish_page=session._publish_page
            def delayed_page():
                if page_silent.is_set():return
                if paused_page_delay and session.status()['phase']=='PAUSED':
                    time.sleep(paused_page_delay)
                publish_page()
            session._publish_page=delayed_page
            class Preview:
                allow_preview=None
                requested=False
                def requested_modes(self,*,blocking=False):return frozenset({'video'}) if self.requested else frozenset()
                def demand(self):return self.requested_modes() if self.allow_preview() else frozenset()
            preview=Preview()
            preview.requested=initial_preview
            if preview_interlock:session.attach_preview(preview,SimpleNamespace(idle=lambda:not encoding_busy[0]))
            if coexist:
                session.set_preview_activity(lambda:True)
                preview.requested=True
            try:
                session.start()
                if initial_preview:
                    until=time.monotonic()+1
                    while session.status()['phase']!='PAUSED' and time.monotonic()<until:time.sleep(.01)
                    self.assertEqual(session.status()['phase'],'PAUSED')
                    self.assertTrue(preview.demand())
                    self.assertIsNone(session.status()['child_pid'])
                    self.assertFalse(model_loads or backends)
                    time.sleep(.6)
                    self.assertFalse(model_loads or backends)
                    preview.requested=False
                deadline = time.monotonic() + 2
                while session.status()["phase"] != "ACTIVE" and time.monotonic() < deadline:
                    if session.finished.wait(.02):
                        break
                self.assertEqual(session.status()["phase"], "ACTIVE", session.status())
                if coexist:self.assertTrue(preview.demand())
                if coexist_video:
                    pid=session.status()['child_pid']
                    session.set_video_paused(True)
                    until=time.monotonic()+3
                    while session.status()['phase']!='PAUSED' and time.monotonic()<until:time.sleep(.02)
                    self.assertEqual(session.status()['phase'],'PAUSED',session.status())
                    self.assertFalse(any(backends[0].torque.values()))
                    self.assertFalse(preview.demand())
                    encoding_busy[0]=True
                    session.set_video_paused(False)
                    gesture[0]='scissors'
                    until=time.monotonic()+3
                    while session.status()['phase']!='ACTIVE' and time.monotonic()<until:time.sleep(.02)
                    self.assertEqual(session.status()['phase'],'ACTIVE',session.status())
                    self.assertTrue(preview.demand())
                    self.assertTrue(encoding_busy[0])
                    self.assertEqual(session.status()['child_pid'],pid)
                    self.assertEqual(len(model_loads),1)
                    self.assertEqual(len(backends),1)
                if repeat_follow:
                    # Same live page/generation: six subsequent approvals must
                    # cross the real UDP receiver, arbiter, SDK and owner latch.
                    time.sleep(.4)
                    generation=session._page_generation
                    child_pid=session.status()['child_pid']
                    for item,state in (('fist','rock'),('scissors','scissors'),('paper','paper'))*2:
                        previous=(session.page_status().get('follow') or {}).get('request_id') or 0
                        gesture[0]=item
                        until=time.monotonic()+2
                        while time.monotonic()<until:
                            self.assertFalse(session.finished.is_set(),session.status())
                            follow=session.page_status().get('follow') or {}
                            if follow.get('state')==state and (follow.get('request_id') or 0)>previous:break
                            time.sleep(.02)
                        else:self.fail('same-page follow did not advance: '+str(session.status()))
                        time.sleep(.35)
                    self.assertEqual(session._page_generation,generation)
                    self.assertEqual(session.status()['child_pid'],child_pid)
                    self.assertEqual(len(model_loads),1)
                    self.assertEqual(len(backends),1)
                if demo_page_gap:
                    until=time.monotonic()+2
                    while session.page_status().get('phase')!='PLAYING' and time.monotonic()<until:time.sleep(.01)
                    self.assertEqual(session.page_status()['phase'],'PLAYING')
                    child_pid=session.status()['child_pid']
                    page_silent.set();time.sleep(3.84)
                    self.assertFalse(session.finished.is_set(),session.status())
                    state=json.loads((session.output_dir/'page-state.json').read_text())
                    self.assertEqual(state['phase'],'WAITING_COMMAND')
                    self.assertTrue(state['off'])
                    self.assertFalse(any(backends[0].torque.values()))
                    self.assertGreater(state['index'],0)
                    self.assertLess(state['index'],11)
                    page_silent.clear()
                    until=time.monotonic()+3
                    while session.page_status().get('command_resumes',0)!=1 and time.monotonic()<until:time.sleep(.01)
                    self.assertEqual(session.page_status()['command_resumes'],1)
                    self.assertEqual(session.status()['child_pid'],child_pid)
                    self.assertEqual(len(backends),1)
                if page_storage_gap:
                    time.sleep(.4)
                    session.set_page_mode('idle')
                    until=time.monotonic()+3
                    while not session.page_status().get('off') and time.monotonic()<until:time.sleep(.02)
                    self.assertTrue(session.page_status().get('off'))
                    before=len(backends[0].packets);child_pid=session.status()['child_pid']
                    page_silent.set();time.sleep(3.2)
                    self.assertFalse(session.finished.is_set(),session.status())
                    self.assertFalse(any(backends[0].torque.values()))
                    self.assertEqual(len(backends[0].packets),before)
                    state=json.loads((session.output_dir/'page-state.json').read_text())
                    self.assertEqual(state['phase'],'WAITING_COMMAND')
                    session.set_page_mode('live');page_silent.clear()
                    until=time.monotonic()+3
                    while session.page_status().get('phase')!='LIVE' and time.monotonic()<until:time.sleep(.02)
                    self.assertEqual(session.page_status()['phase'],'LIVE')
                    self.assertEqual(session.status()['child_pid'],child_pid)
                    self.assertEqual(len(backends),1)
                if page_mode=='demo':
                    until=time.monotonic()+8
                    if cancel_demo:
                        while session.page_status().get('phase')!='PLAYING' and time.monotonic()<until:time.sleep(.02)
                        session.set_page_mode('idle')
                    while not session.page_status().get('off') and time.monotonic()<until:
                        self.assertFalse(session.finished.is_set(),session.status());time.sleep(.02)
                    self.assertTrue(session.page_status().get('off'),session.page_status())
                    self.assertEqual(session.page_status()['phase'],'IDLE' if cancel_demo else 'DONE')
                    self.assertFalse(any(backends[0].torque.values()))
                    self.assertEqual(len(backends),1)
                if preview_interlock and not coexist:
                    def wait_phase(phase,seconds=3):
                        until=time.monotonic()+seconds
                        while session.status()['phase']!=phase and time.monotonic()<until:
                            self.assertFalse(session.finished.is_set(),session.status());time.sleep(.02)
                        self.assertEqual(session.status()['phase'],phase,session.status())
                    if source_gap:
                        child_pid=session.status()['child_pid']
                        time.sleep(.2);frozen.set()
                        wait_phase('WAITING_SOURCE_OFF')
                        self.assertFalse(preview.demand())
                        self.assertFalse(any(backends[0].torque.values()))
                        if source_gap_preview:
                            preview.requested=True;wait_phase('PAUSED')
                            self.assertTrue(preview.demand())
                            preview.requested=False;wait_phase('RESUMING')
                        gesture[0]='scissors';frozen.clear()
                        wait_phase('ACTIVE')
                        self.assertEqual(session.status()['child_pid'],child_pid)
                        self.assertEqual(len(model_loads),1)
                        self.assertEqual(len(backends),1)
                    for cycle in range(0 if source_gap else preview_cycles):
                        time.sleep(.2)
                        child_pid=session.status()['child_pid']
                        if video_pause:session.set_video_paused(True)
                        else:preview.requested=True
                        self.assertFalse(preview.demand())
                        wait_phase('PAUSED')
                        self.assertEqual(bool(preview.demand()),not video_pause)
                        self.assertFalse(any(backends[0].torque.values()))
                        self.assertEqual(len(backends),1)
                        before=len(backends[0].packets)
                        if control_gap:
                            silent.set();time.sleep(3.6)
                            self.assertEqual(session.status()['phase'],'PAUSED',session.status())
                            self.assertFalse(any(backends[0].torque.values()))
                            self.assertEqual(before,len(backends[0].packets))
                            silent.clear()
                        if inject_unlabelled:
                            # A delayed ordinary data frame is not permission
                            # to resume while the preview subscription remains ON.
                            publisher=publishers[0];publisher.sequence+=1;now=time.monotonic()
                            observation=dict(vars(session.feed._latest.observation),
                                frame_id=session.feed._latest.observation.frame_id+100,
                                observed_at=now,source_at=now,gesture='fist',valid=True)
                            publisher.sock.send(json.dumps(dict(schema='hand-passive-v1',
                                session=session.session,sequence=publisher.sequence,revoked=None,
                                value=dict(game_run=session._source,observation=observation))).encode())
                            time.sleep(.2)
                            self.assertEqual(before,len(backends[0].packets),
                                'ordinary data frame resumed a preview-paused hand')
                        frozen.set();gesture[0]='fist';time.sleep(max(.7,paused_page_delay+1))
                        self.assertEqual(session.status()['phase'],'PAUSED')
                        self.assertFalse(any(backends[0].torque.values()))
                        self.assertEqual(before,len(backends[0].packets))
                        if stop_paused:break
                        encoding_busy[0]=True
                        if video_pause:session.set_video_paused(False)
                        else:preview.requested=False
                        time.sleep(.3)
                        self.assertEqual(session.status()['phase'],'PAUSED')
                        self.assertFalse(any(backends[0].torque.values()))
                        encoding_busy[0]=False
                        wait_phase('RESUMING')
                        self.assertFalse(preview.demand())
                        time.sleep(.6)
                        self.assertFalse(any(backends[0].torque.values()))
                        gesture[0]='scissors';frozen.clear()
                        wait_phase('ACTIVE')
                        self.assertEqual(session.status()['child_pid'],child_pid)
                        self.assertEqual(len(backends),1)
                        self.assertEqual(len(model_loads),1)
                stop_at = time.monotonic() + hold_seconds
                if coexist:self.assertTrue(preview.demand())
                while time.monotonic() < stop_at:
                    self.assertEqual(session.status()["phase"], "PAUSED" if stop_paused else "ACTIVE", session.status())
                    time.sleep(min(.25, max(0, stop_at - time.monotonic())))
            finally:
                session.close()
            self.assertTrue(session.status()["release_confirmed"])
            if stop_paused:self.assertTrue(preview.demand())
            report = json.loads((session.output_dir / "serial-motion.json").read_text())
            self.assertEqual(report["operations"][0]["state"], "demo:0" if page_mode=='demo' else "paper")
            if repeat_follow:
                self.assertEqual([p['state'] for p in report['operations']],
                    ['paper','rock','scissors','paper','rock','scissors','paper'])
            if page_mode=='demo' and not cancel_demo:
                from pynq_usb_hand.page_playback import DEMO_STATES
                self.assertEqual([item['state'] for item in report['operations']],[*DEMO_STATES,'default'])
            self.assertFalse([packet for phase,packet in backends[0].packets if phase=='playback' and packet[4]==2])
            self.assertFalse(any(backends[0].torque.values()))
            self.assertTrue(backends[0].closed)
            self.assertFalse(backends[0].responses)
            self.assertEqual(report["max_seconds"], seconds)
            self.assertEqual(report["approval_seconds"], approval_seconds)
            if approval_seconds is not None:
                operation=report['controller']['operation']
                self.assertEqual(operation['status'],'played')
                expected_hold=0 if operation['state']=='default' else approval_seconds
                self.assertAlmostEqual(operation['ready_at']-operation['approved_at'],expected_hold)
                self.assertGreaterEqual(operation['completed_at'],operation['ready_at'])
            if preview_interlock and not coexist:
                self.assertEqual(report['preview_pauses'],preview_cycles)
                self.assertEqual(report['preview_resumes'],0 if stop_paused else preview_cycles)
                self.assertNotIn('rock',[v['state'] for v in report['operations']])
                self.assertEqual(report['controller']['operation']['state'],'paper' if stop_paused else 'scissors')
                self.assertFalse(any(packet[4]==2 for phase,packet in backends[0].packets if phase=='playback'))
                self.assertEqual(sum(packet[4]==2 for phase,packet in backends[0].packets if phase=='connect'),17)
            return report

    def test_same_live_menu_repeats_three_gestures_twice_without_restarting_sdk_owner(self):
        self.exercise_parent(hold_seconds=.1,approval_seconds=.3,repeat_follow=True)

    def test_exclusive_preview_keeps_same_hand_following_all_three_states(self):
        report=self.exercise_parent(hold_seconds=.1,approval_seconds=.3,
            repeat_follow=True,preview_interlock=True,coexist=True)
        self.assertEqual(report['preview_pauses'],0)
        self.assertEqual(report['preview_resumes'],0)

    def test_video_to_exclusive_preview_resumes_same_sdk_owner_during_continuous_encoding(self):
        report=self.exercise_parent(hold_seconds=.6,approval_seconds=.3,
            preview_interlock=True,coexist=True,coexist_video=True)
        self.assertEqual(report['preview_pauses'],1)
        self.assertEqual(report['preview_resumes'],1)

    def test_source_gap_recovers_same_model_and_sdk_owner_without_playback_reads(self):
        report=self.exercise_parent(hold_seconds=.6,approval_seconds=.3,
            preview_interlock=True,preview_cycles=0,source_gap=True)
        self.assertEqual(report['source_waits'],1)
        self.assertEqual(report['source_resumes'],1)

    def test_preview_takes_over_source_wait_and_only_fresh_resume_can_arm(self):
        report=self.exercise_parent(hold_seconds=.6,approval_seconds=.3,
            preview_interlock=True,source_gap=True,source_gap_preview=True)
        self.assertEqual(report['source_waits'],1)

    def test_preview_requires_off_then_reuses_same_controller_and_only_fresh_latest(self):
        self.exercise_parent(hold_seconds=.6,approval_seconds=.3,preview_interlock=True)

    def test_repeated_preview_cycles_reuse_model_backend_and_serial_child(self):
        self.exercise_parent(hold_seconds=.6,approval_seconds=.3,preview_interlock=True,preview_cycles=2)

    def test_video_pause_reuses_off_and_fresh_resume_without_any_preview_subscription(self):
        self.exercise_parent(hold_seconds=.6,approval_seconds=.3,preview_interlock=True,
                             preview_cycles=2,video_pause=True)

    def test_video_off_heartbeat_is_independent_of_slow_unused_page_storage(self):
        self.exercise_parent(hold_seconds=.6,approval_seconds=.3,preview_interlock=True,
                             video_pause=True,paused_page_delay=3.5)

    def test_confirmed_off_control_gap_waits_without_writes_and_resumes_only_fresh(self):
        report=self.exercise_parent(hold_seconds=.6,approval_seconds=.3,preview_interlock=True,
                                   video_pause=True,control_gap=True)
        self.assertGreaterEqual(report['preview_control_waits'],1)

    def test_close_while_preview_is_active_confirms_off_without_resume(self):
        self.exercise_parent(hold_seconds=.1,approval_seconds=.3,preview_interlock=True,stop_paused=True)

    def test_preview_already_requested_defers_hand_model_and_backend_until_needed(self):
        self.exercise_parent(hold_seconds=.6,approval_seconds=.3,preview_interlock=True,initial_preview=True)

    def test_delayed_data_without_explicit_resume_cannot_enable_hand_during_preview(self):
        self.exercise_parent(hold_seconds=.6,approval_seconds=.3,preview_interlock=True,inject_unlabelled=True)

    def test_complete_demo_through_real_udp_and_sdk_without_playback_reads(self):
        self.exercise_parent(hold_seconds=.1,approval_seconds=.3,page_mode='demo')

    def test_active_demo_page_gap_recovers_remaining_sequence_on_same_serial_owner(self):
        self.exercise_parent(hold_seconds=.1,approval_seconds=.3,page_mode='demo',demo_page_gap=True)

    def test_slow_page_storage_cannot_lock_hdmi_status_or_return_selection(self):
        with tempfile.TemporaryDirectory() as temporary:
            session=create_serial_action_session(Provider(),gate=self.gate(),package_root=CANDIDATE,
                output_dir=Path(temporary),stage_waits=(.001,)*3)
            session._source='run'
            session.output_dir.mkdir()
            entered=threading.Event();release=threading.Event();ui_done=threading.Event()
            original=Path.write_text
            def slow_write(path,*args,**kwargs):
                if path.name=='page-command.tmp':
                    entered.set();release.wait(3)
                return original(path,*args,**kwargs)
            def ui():
                session.page_status();session.set_page_mode('idle',restart=True);ui_done.set()
            with patch.object(Path,'write_text',slow_write):
                worker=threading.Thread(target=session._publish_page);worker.start()
                self.assertTrue(entered.wait(1))
                reader=threading.Thread(target=ui);reader.start()
                try:self.assertTrue(ui_done.wait(.3),'SD write held HDMI/menu ownership lock')
                finally:release.set();worker.join(2);reader.join(2)
            # A selection during the old write must force publication of the new generation.
            session._publish_page()
            command=json.loads((session.output_dir/'page-command.json').read_text())
            self.assertEqual(command['generation'],1)

    def test_old_cached_off_is_not_authority_during_parent_poll_gap(self):
        owner=SerialHandActionSession.__new__(SerialHandActionSession)
        owner._page_lock=threading.Lock();owner._page_generation=1
        owner._page_status=dict(generation=1,phase='IDLE',off=True,
                               release_confirmed_ids=list(range(1,18)))
        owner._page_last_poll=time.monotonic()-3.84
        state=owner.page_status()
        self.assertEqual(state['phase'],'WAITING_COMMAND')
        self.assertFalse(state['off']);self.assertEqual(state['release_confirmed_ids'],[])
        self.assertTrue(owner._page_status['off'])  # Preserve the historical receipt.
        owner._page_last_poll=time.monotonic()
        self.assertTrue(owner.page_status()['off'])

    def test_idle_off_page_storage_gap_waits_without_packets_then_resumes_same_owner(self):
        self.exercise_parent(hold_seconds=.6,approval_seconds=.3,page_storage_gap=True)

    def test_cancel_demo_through_real_udp_returns_default_and_off(self):
        self.exercise_parent(hold_seconds=.1,approval_seconds=.3,page_mode='demo',cancel_demo=True)

    def test_stuck_child_is_retained_and_never_terminated(self):
        calls = []

        class StuckChild:
            pid = 123

            def __init__(self, command, **kwargs):
                directory = Path(command[command.index("--output-dir") + 1])
                (directory / "ready.json").write_text('{"pid":0}')

            def poll(self):
                return None

            def wait(self, timeout):
                calls.append("wait")
                raise subprocess.TimeoutExpired("stuck", timeout)

            def terminate(self):
                calls.append("terminate")
                raise AssertionError("must retain a serial owner")

        with tempfile.TemporaryDirectory() as temporary, \
                patch("pynq_multimodal_game.hand_serial_session.subprocess.Popen", StuckChild):
            session = create_serial_action_session(
                Provider(), gate=self.gate(), package_root=CANDIDATE,
                output_dir=Path(temporary), stage_waits=(.1,) * 3,
            )
            session.start()
            self.assertTrue(session.finished.wait(2))
            with self.assertRaisesRegex(RuntimeError, "physical release UNKNOWN"):
                session.close()
            self.assertEqual(calls, ["wait"])
            self.assertFalse(session.status()["release_confirmed"])

    def test_incomplete_off_receipts_are_rejected(self):
        owner = SerialHandActionSession.__new__(SerialHandActionSession)
        owner.session = "session"
        receipt = dict(schema="vision-hand-actuator-owner-v1", session="session", game_run="run",
                       actuator="serial-fixed-playback", arm_attempted=True, backend_closed=True,
                       release_confirmed=True, release_confirmed_ids=list(range(1, 18)),
                       release_attempts=[dict(failed_ids=[], error=None)],
                       controller=dict(lifecycle="CLOSED", error=None))
        owner._verify_release(receipt, "run", 0)
        for key, value in (("release_confirmed_ids", list(range(1, 17))),
                           ("release_attempts", [dict(failed_ids=[7], error=None)]),
                           ("session", "other"), ("backend_closed", False)):
            invalid = copy.deepcopy(receipt)
            invalid[key] = value
            with self.subTest(key=key), self.assertRaisesRegex(RuntimeError, "physical release UNKNOWN"):
                owner._verify_release(invalid, "run", 0)


if __name__ == "__main__":
    unittest.main()
