"""Preview, UI and hand ownership checks without serial, camera or GPU."""
import threading
from types import SimpleNamespace
from unittest.mock import Mock
import pytest
from pynq_multimodal_game.agent.c6i_shell import C6IShellRuntimeBackend,ShellMode
from pynq_multimodal_game.agent.core import AgentState
from pynq_multimodal_game.menu import MenuPage
from pynq_multimodal_game.hand_serial_session import SerialHandActionSession
from pynq_multimodal_game.vision_preview import AsyncPreviewEncoder


def shell():
    runtime=C6IShellRuntimeBackend(SimpleNamespace(build_id=0xC0061000),menu_fps=0)
    request=[True];runtime._preview_modes=lambda:{'video'} if request[0] else set()
    runtime._menu_active=True;runtime._stop_menu=Mock();runtime._start_menu_locked=Mock()
    runtime._set_video_hand_pause=Mock();runtime._request_hand_page=Mock()
    runtime._show_preview_pause=Mock()
    return runtime,request


def test_menu_interactions_and_render_submission_stop_until_preview_closes():
    r,demand=shell();r._sync_preview_activity()
    assert r._preview_ready and r._preview_active
    assert r.handle_control(object()) is None
    r._request_hand_page.assert_called_with('live')
    r._stop_menu.assert_called_once()
    r._show_preview_pause.assert_called_once()
    for action in (lambda:r.start_game('game1'),lambda:r.play_library_video('v'),r.return_to_menu):
        with pytest.raises(RuntimeError,match='回传'):action()
    demand[0]=False;r._sync_preview_activity()
    assert not r._preview_active and not r._preview_ready
    r._start_menu_locked.assert_called_once()


@pytest.mark.parametrize('already_paused',[False,True])
def test_game_keeps_source_and_resume_respects_previous_pause(already_paused):
    r,demand=shell();game=SimpleNamespace(paused=already_paused,pause=Mock(),resume=Mock(),restore_display=Mock())
    r._game=game;r._mode=ShellMode.GAME;r._menu_active=False
    r._sync_preview_activity()
    assert r._preview_ready
    game.pause.assert_called_once_with(keep_source_live=True)
    demand[0]=False;r._sync_preview_activity()
    assert game.resume.call_count==(0 if already_paused else 1)
    game.restore_display.assert_called_once()


def test_video_restores_only_after_hand_off_barrier():
    r,demand=shell();events=[]
    r._mode=ShellMode.VIDEO;r._menu_active=False
    r._video=SimpleNamespace(snapshot=SimpleNamespace(state=AgentState.RUNNING),
        pause=lambda:events.append('pause'),run=lambda:events.append('resume'),set_preview_exclusive=Mock(),
        preview_quiesced=lambda:True,restore_display=lambda:events.append('restore'))
    r._set_video_hand_pause=lambda value:events.append('off' if value else 'follow')
    r._sync_preview_activity();assert events==['pause','follow']
    demand[0]=False;r._sync_preview_activity()
    assert events==['pause','follow','off','restore','resume']


def test_demo_must_confirm_off_before_live_and_returns_home_after_preview():
    r,demand=shell();off=[False];r._page=MenuPage.HAND_DEMO
    r._read_hand_page=lambda:{'off':off[0]}
    r._select_page_locked=Mock()
    r._sync_preview_activity();assert not r._preview_ready
    r._request_hand_page.assert_called_with('idle')
    off[0]=True;r._sync_preview_activity();assert r._preview_ready
    r._request_hand_page.assert_called_with('live')
    demand[0]=False;off[0]=False;r._sync_preview_activity();assert r._preview_active
    off[0]=True;r._sync_preview_activity()
    r._select_page_locked.assert_called_once_with(MenuPage.HOME)
    assert not r._preview_active


def test_coexist_preview_does_not_pause_hand_but_video_still_does():
    owner=SerialHandActionSession.__new__(SerialHandActionSession)
    owner._thread=None;owner._preview_requested=None;owner._preview_allowed=False
    owner._stop=threading.Event();ready=[False]
    preview=SimpleNamespace(allow_preview=None,requested_modes=lambda **_:{'video'})
    owner.attach_preview(preview)
    owner.set_preview_activity(lambda:ready[0])
    assert not owner._requested() and not preview.allow_preview()
    ready[0]=True
    assert not owner._requested() and preview.allow_preview()
    owner.set_video_paused(True)
    assert owner._requested() and not preview.allow_preview()
    owner.set_video_paused(False);owner._stop.set()
    assert not preview.allow_preview()


def test_unlimited_encoder_is_source_driven_and_disabled_modes_stay_disabled():
    from pynq_multimodal_game.vision_preview import PreviewSnapshot
    demand=lambda:frozenset({'video','debug'})
    encoder=AsyncPreviewEncoder(demand,lambda *_:b'jpeg',lambda *_:None,
        video_fps=10,debug_fps=0)
    try:
        encoder._due['video']=100
        assert not encoder.due_modes(1)
        encoder.unlimited=True
        assert encoder.due_modes(1)==frozenset({'video'})
    finally:encoder.close()


def test_automatic_preview_waits_for_new_debug_generation_and_uses_one_mode(monkeypatch):
    import importlib.util
    from pathlib import Path
    from http.client import HTTPConnection
    root=Path(__file__).resolve().parents[2]
    monkeypatch.setenv('VVG_VISION_RUNTIME_DIR',str(root/'handoffs/gesture_vision_v61/runtime'))
    path=Path(__file__).parent/'board/pynq_z2/scripts/vision_async_runtime.py'
    spec=importlib.util.spec_from_file_location('exclusive_http',path)
    module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
    preview=module.BytesPreview('127.0.0.1',0)
    connection=HTTPConnection('127.0.0.1',preview.server.server_port,timeout=2)
    try:
        preview.publish_debug(b'first')
        connection.request('GET','/debug.jpg');r=connection.getresponse()
        assert r.status==200 and r.read()==b'first'
        assert r.getheader('X-Preview-Generation')=='1'
        connection.request('GET','/debug.jpg?after=1');r=connection.getresponse()
        assert r.status==204 and r.read()==b''
        preview.publish_debug(b'newest')
        connection.request('GET','/debug.jpg?after=1');r=connection.getresponse()
        assert r.status==200 and r.read()==b'newest'
        # A Studio session survives a board worker restart with a lower counter.
        connection.request('GET','/debug.jpg?after=999');r=connection.getresponse()
        assert r.status==200 and r.read()==b'newest'
        assert r.getheader('X-Preview-Generation')=='2'
        with preview.lock:preview.video_clients=1
        assert preview.requested_modes()==frozenset({'video'})
        with preview.lock:preview.video_clients=0
    finally:
        connection.close();preview.close()


def test_video_must_park_before_preview_or_hand_follow_is_allowed():
    r,demand=shell();parked=[False]
    r._mode=ShellMode.VIDEO;r._menu_active=False
    r._video=SimpleNamespace(snapshot=SimpleNamespace(state=AgentState.RUNNING),
        pause=Mock(),run=Mock(),set_preview_exclusive=Mock(),
        preview_quiesced=lambda:parked[0])
    r._sync_preview_activity()
    assert not r._preview_ready
    r._set_video_hand_pause.assert_not_called()
    parked[0]=True;r._sync_preview_activity()
    assert r._preview_ready
    assert r._video.pause.call_count==1


def test_hdmi_preview_pause_does_not_upload_or_overwrite_resources():
    from pynq_multimodal_game.gpu_abi import Opcode,COMMAND_CAPACITY
    from pynq_multimodal_game.shell_pages import preview_pause_commands
    r=C6IShellRuntimeBackend(SimpleNamespace(build_id=0xC0061000),menu_fps=0)
    sink=Mock();sink.resource_generations=(17,23,42);r._sink=sink
    r._show_preview_pause()
    assert sink.submit_scene.call_count==1
    import struct
    words=struct.unpack_from('<16I',sink.submit_scene.call_args.args[0])
    assert (words[8],words[10],words[11])==(17,23,42)
    sink.upload_asset.assert_not_called()
    sink.upload_palette.assert_not_called()
    sink.upload_tilemap.assert_not_called()
    commands=preview_pause_commands()
    assert len(commands)<=COMMAND_CAPACITY
    assert set(c.opcode for c in commands)<={Opcode.CLEAR,Opcode.FILL_RECT,Opcode.END_FRAME}


def test_video_restores_previous_scene_without_waiting_for_another_frame():
    from pynq_multimodal_game.agent.c6i_shell import _BorrowedSink
    raw=Mock();sink=_BorrowedSink(raw)
    sink.submit_scene(b'original video scene')
    raw.submit_scene(b'HDMI preview pause')
    sink.restore_scene()
    assert raw.submit_scene.call_args.args==(b'original video scene',)
    raw.upload_asset.assert_not_called()


def test_shutdown_cannot_regrant_hand_permission_or_preview_ready():
    r,demand=shell()
    r._return_monitor_stop.set()
    r._sync_preview_activity()
    assert not r._preview_ready
    r._request_hand_page.assert_not_called()
    # Gate the real permission methods even when a menu callback is in flight.
    r._hand_permissions_closed=True
    owner=Mock();r._hand_session=owner
    C6IShellRuntimeBackend._request_hand_page(r,'live')
    C6IShellRuntimeBackend._set_video_hand_pause(r,False)
    owner.set_page_mode.assert_not_called();owner.set_video_paused.assert_not_called()


def test_exclusive_preview_can_resume_video_paused_hand_while_encoder_is_busy(tmp_path):
    owner=SerialHandActionSession.__new__(SerialHandActionSession)
    owner._preview_requested=lambda:{'video'}
    owner._preview_activity=lambda:True
    owner._preview_idle=lambda:False  # Continuous automatic JPEG production.
    owner._video_paused=False;owner._pause_generation=1
    owner._preview_allowed=True;owner._control_phase='PAUSED'
    owner.output_dir=tmp_path
    owner._update_preview()
    assert owner._pause_generation is None
    assert owner._control_phase=='RESUMING'


def test_failed_preview_transition_revokes_hand_follow_and_never_allows_jpeg():
    r,_=shell();r._preview_active=True;r._preview_ready=True
    def fail():
        r._return_monitor_stop.set()
        raise RuntimeError('render generation stall')
    r._poll_return_control=fail
    r._return_monitor_loop()
    assert not r._preview_ready
    r._request_hand_page.assert_called_with('idle')
    assert 'generation stall' in r._last_error


def test_poisoned_gpu_requests_full_restart_instead_of_leaving_ui_paused():
    r,_=shell();r._preview_active=True
    r._sink=SimpleNamespace(_poison=TimeoutError('render count'))
    r._restart_callback=Mock()
    def fail():r._return_monitor_stop.set();raise RuntimeError('poisoned sink')
    r._poll_return_control=fail;r._return_monitor_loop()
    assert r._restart_requested and r._recovery_requested
    r._restart_callback.assert_called_once()


def test_reinitialization_cannot_bypass_unconfirmed_hardware_or_hand_release():
    from pynq_multimodal_game.agent.vision_backend import C6IButtonRuntimeBackend
    from pynq_multimodal_game.agent.cli import _close_vision_runtime
    owner=C6IButtonRuntimeBackend.__new__(C6IButtonRuntimeBackend)
    owner._recovery_requested=True
    owner._hand_session=owner._button_sampler=owner._osd=owner._game=None
    owner._menu_thread=owner._return_monitor_thread=owner._startup_animation_thread=None
    owner._video=SimpleNamespace(_thread=None)
    vision=[True];owner._vision_supervisor=SimpleNamespace(status=lambda:dict(cleanup_confirmed=vision[0]))
    owner._sink=SimpleNamespace(_closed=True,_buffer=None,_dma_inflight=False)
    assert owner.recovery_cleanup_confirmed()
    for field,value in (('_hand_session',object()),('_button_sampler',object()),('_osd',object())):
        setattr(owner,field,value);assert not owner.recovery_cleanup_confirmed();setattr(owner,field,None)
    vision[0]=False;assert not owner.recovery_cleanup_confirmed();vision[0]=True
    owner._sink._dma_inflight=True;assert not owner.recovery_cleanup_confirmed()
    owner._sink._dma_inflight=False;owner._sink._closed=False;assert not owner.recovery_cleanup_confirmed()
    owner._sink._closed=True
    owner.close=Mock(side_effect=RuntimeError('historical poisoned scene'))
    _close_vision_runtime(owner)
    owner._hand_session=object()
    with pytest.raises(RuntimeError,match='historical poisoned'):_close_vision_runtime(owner)


def test_paused_video_worker_parks_without_refresh_until_resume():
    import time
    from pynq_multimodal_game.agent.video_runtime import C6IVideoRuntimeBackend
    video=C6IVideoRuntimeBackend(SimpleNamespace(build_id=0xC0061000))
    refresh=Mock();result=[]
    video.set_preview_exclusive(True)
    worker=threading.Thread(target=lambda:result.append(video._wait_for_playback_slot(
        time.perf_counter(),paused_refresh=refresh)))
    video._thread=worker
    worker.start()
    try:
        assert video._preview_parked.wait(1)
        assert worker.is_alive() and not refresh.called
        with video._control_changed:
            video._resume.set();video._control_changed.notify_all()
        worker.join(1)
        assert result==['play'] and not refresh.called
    finally:
        video._stopped.set()
        with video._control_changed:video._control_changed.notify_all()
        worker.join(1)
