"""Replay the observed hand fault -> video rejection -> dead menu -> preview chain."""
import threading
from types import SimpleNamespace
from unittest.mock import Mock
import pytest
from pynq_multimodal_game.agent.c6i_shell import C6IShellRuntimeBackend,ShellMode


def runtime():
    r=C6IShellRuntimeBackend(SimpleNamespace(build_id=0xC0061000),menu_fps=30,timeout_seconds=.01)
    r._sink=SimpleNamespace(close=lambda:None)
    r._drain_sink=Mock();r._upload_menu_resources_locked=Mock();r._submit_menu_frame_locked=Mock()
    r._show_content_loading=Mock();r._select_page_locked=Mock()
    return r


def test_failed_video_from_menu_thread_keeps_accepting_later_input():
    r=runtime();r._video_entries={'v':object()}
    r._live_input=SimpleNamespace(sample_menu_control=lambda **_:None)
    continued=threading.Event();calls=[]
    def pause(value):
        if value:raise RuntimeError('Cannot start video before hand OFF: FAULT')
    r._set_video_hand_pause=pause
    def control(_):
        calls.append(1)
        if len(calls)==1:r.play_library_video('v')
        else:continued.set();r._menu_stop.set()
    r.handle_control=control
    with r._lock:r._start_menu_locked();worker=r._menu_thread
    try:
        assert continued.wait(1),'Video failure killed the restored menu input loop'
        worker.join(1)
        assert 'Cannot start video' in r._last_error
    finally:
        r._menu_stop.set();worker.join(1)


def test_preview_close_restores_logical_menu_even_after_menu_worker_died():
    r=runtime();demand=[True]
    r._menu_active=False;r._mode=ShellMode.MENU
    r._preview_modes=lambda:{'video'} if demand[0] else set()
    r._stop_menu=Mock();r._show_preview_pause=Mock();r._set_video_hand_pause=Mock()
    r._start_menu_locked=Mock()
    r._sync_preview_activity()
    assert r._preview_ready
    demand[0]=False;r._sync_preview_activity()
    r._start_menu_locked.assert_called_once()
    assert not r._preview_active


@pytest.mark.parametrize('released',[True,False,None])
def test_hand_fault_video_gate_uses_verified_final_release(released,monkeypatch):
    r=runtime()
    r._hand_session=SimpleNamespace(set_video_paused=Mock(),status=lambda:dict(
        phase='FAULT',error='serial source stopped unexpectedly: owner_failed',release_confirmed=released))
    if released is True:r._set_video_hand_pause(True)
    else:
        ticks=iter((0.,21.))
        monkeypatch.setattr('pynq_multimodal_game.agent.c6i_shell.time.monotonic',lambda:next(ticks))
        with pytest.raises(TimeoutError,match='Hand OFF'):r._set_video_hand_pause(True)
