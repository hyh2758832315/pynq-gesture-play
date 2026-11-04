"""Preview admission requires OFF; ordinary sessions and stale guards stay strict."""
import importlib.util,json,socket,sys,time
from pathlib import Path
from types import SimpleNamespace
import pytest
ROOT=Path(__file__).resolve().parents[2]
sys.path[:0]=[str(ROOT/'subprojects/ps_ui_r23b2/python'),str(ROOT/'build/hand-r28-source-wait-20261026-r04/src')]
from pynq_usb_hand.game_bridge import DatagramReceiver
from pynq_usb_hand.controller import Controller
from pynq_usb_hand.motion import MockBackend,MotionSettings
from pynq_multimodal_game.hand_serial_session import SerialHandActionSession
from pynq_multimodal_game.menu import hand_session_label,HAND_STATUS_LABELS

@pytest.mark.parametrize('enabled,reason,value,expected',[
    (False,'preview_pause:1',None,'producer_revoked'),
    (True,'preview_pause:1',None,'preview_pause:1'),
    (True,'preview_pause:0',None,'producer_revoked'),
    (True,'preview_pause:abc',None,'producer_revoked'),
    (True,'preview_pause:1',{},'producer_revoked'),
    (True,'producer_close',None,'producer_revoked'),
])
def test_only_explicit_valid_pause_is_an_interlock_control(enabled,reason,value,expected):
    sender=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);target=socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
    target.bind(('127.0.0.1',0));sender.connect(target.getsockname())
    try:
        receiver=DatagramReceiver(target,session_id='s',game_run='g',preview_interlock=enabled)
        sender.send(json.dumps(dict(schema='hand-passive-v1',session='s',sequence=1,revoked=reason,value=value)).encode())
        assert receiver.poll(time.monotonic()) is None and receiver.stopped==expected
    finally:sender.close();target.close()

@pytest.mark.parametrize('tamper',[{'release_confirmed_ids':list(range(1,17))},
    {'controller':{'lifecycle':'READY_IDLE','error':None,'enable_epoch':'enabled'}},
    {'pid':99}, {'pause_generation':2}])
def test_missing_or_stale_off_receipt_never_opens_preview(tmp_path,tamper):
    owner=SerialHandActionSession.__new__(SerialHandActionSession)
    owner._preview_requested=lambda:frozenset({'video'});owner._preview_allowed=False
    owner._pause_generation=owner._generation=1;owner._control_phase='PAUSING';owner._control_mtime=None
    owner.output_dir=tmp_path;owner._child=SimpleNamespace(pid=42);owner.session='s';owner._source='g'
    value=dict(schema='hand-preview-interlock-v1',pid=42,session='s',game_run='g',
        actuator='serial-fixed-playback',phase='PAUSED',pause_generation=1,
        controller=dict(lifecycle='CONNECTED_OFF',enable_epoch=None,error=None),release_confirmed_ids=list(range(1,18)))
    value.update(tamper);(tmp_path/'control-state.json').write_text(json.dumps(value))
    try:owner._update_preview()
    except ValueError:pass
    assert not owner._preview_allowed

def test_rearm_requires_explicit_preview_transition_and_keeps_legacy_once_gate():
    for enabled in (False,True):
        backend=MockBackend();controller=Controller(lambda:backend,lease_seconds=5,
            settings=MotionSettings.fixed_playback(stage_waits=(.01,)*3),preview_interlock=enabled)
        try:
            controller.wait_connected();controller.arm();assert controller.wait_idle()
            if enabled:controller.pause_for_preview()
            else:controller.release()
            assert controller.wait_idle() and not backend.torque
            with pytest.raises(RuntimeError):controller.arm()
            if enabled:
                controller.resume_preview();assert controller.wait_idle() and backend.torque
                with pytest.raises(RuntimeError):controller.resume_preview()
            else:
                with pytest.raises(RuntimeError):controller.resume_preview()
        finally:controller.close()

def test_pause_labels_reuse_existing_atlas_strings():
    for phase,label in [('PAUSING','HAND STOP'),('PAUSED','HAND OFF'),('RESUMING','HAND CHECK')]:
        assert hand_session_label({'mode':'serial-fixed-playback','phase':phase})==label
        assert label in HAND_STATUS_LABELS

def test_real_http_result_poll_does_not_request_pixels_but_video_waits_for_admission():
    import http.client,select
    path=ROOT/'subprojects/ps_ui_r23b2/board/pynq_z2/scripts/vision_async_runtime.py'
    spec=importlib.util.spec_from_file_location('interlock_http_runtime',path)
    module=importlib.util.module_from_spec(spec);sys.modules[spec.name]=module;spec.loader.exec_module(module)
    module.RUNTIME_DIR=ROOT/'handoffs/gesture_vision_v61/runtime'
    preview=module.BytesPreview('127.0.0.1',0);admitted=[False]
    preview.allow_preview=lambda:admitted[0]
    address=preview.server.server_address
    poll=http.client.HTTPConnection(*address,timeout=2);stream=http.client.HTTPConnection(*address,timeout=2)
    try:
        poll.request('GET','/result.json');response=poll.getresponse();assert response.status==200;response.read()
        assert not preview.requested_modes()
        stream.request('GET','/camera.mjpg');response=stream.getresponse();assert response.status==200
        assert preview.requested_modes()==frozenset({'video'}) and not preview.demand()
        import threading
        observed=[]
        with preview.lock:
            reader=threading.Thread(target=lambda:observed.append(preview.requested_modes(blocking=True)))
            reader.start();reader.join(.03)
            assert reader.is_alive()  # Lock contention must not look like OFF.
        reader.join(1)
        assert observed==[frozenset({'video'})]
        preview.publish(b'owned-preview')
        assert not select.select([response.fp],[],[],.1)[0]
        admitted[0]=True
        assert preview.demand()==frozenset({'video'})
        assert select.select([response.fp],[],[],1)[0]
        assert response.readline().startswith(b'--frame')
    finally:poll.close();stream.close();preview.close()
