"""Fault injection without hardware: same-owner retry, backoff and fresh restart.

Run with PS overlay PYTHONPATH: python -m pytest this_file.py -q.
Output: pytest results; next run lifecycle/preview and SDK boundary suites.
"""
from pathlib import Path
from types import SimpleNamespace as NS
from unittest.mock import Mock
import threading
import pytest
from pynq_multimodal_game.agent.c6i_shell import C6IShellRuntimeBackend, ShellMode
from pynq_multimodal_game.agent.vision_backend import C6IButtonRuntimeBackend
from pynq_multimodal_game.agent.cli import _close_vision_runtime_with_retry
from pynq_multimodal_game.agent.core import AgentState
from pynq_multimodal_game.hand_serial_session import SerialHandActionSession


def shell():
    r=C6IShellRuntimeBackend(NS(build_id=0xC0061000),menu_fps=0)
    r._sink=NS(_poison=None)
    return r


def test_video_wait_rechecks_late_off_instead_of_rejecting_fault():
    r=shell();state=dict(phase='FAULT',release_confirmed=False,error='late receipt')
    def recover():state['release_confirmed']=True
    owner=NS(status=lambda:state,set_video_paused=Mock(),recover_release=Mock(side_effect=recover))
    r._hand_session=owner;r._set_video_hand_pause(True)
    owner.recover_release.assert_called_once()


@pytest.mark.parametrize('thread_alive,child_alive',[(True,False),(False,True)])
def test_release_recovery_never_touches_an_active_owner(thread_alive,child_alive):
    h=SerialHandActionSession.__new__(SerialHandActionSession)
    h.finished=threading.Event();h.finished.set()
    h._thread=NS(is_alive=lambda:thread_alive)
    h._child=NS(poll=lambda:None if child_alive else 0)
    h.close=Mock()
    assert h.recover_release() is False
    h.close.assert_not_called()


def test_cleanup_retries_same_runtime_with_capped_backoff():
    r=NS(close=Mock(side_effect=[RuntimeError('busy')]*8+[None]))
    waits=[];_close_vision_runtime_with_retry(r,wait=waits.append)
    assert waits==[1,2,4,8,16,30,30,30] and r.close.call_count==9


def test_pending_menu_recovery_retains_owner_until_stop_succeeds():
    r=shell();r._menu_recovery_pending=True
    game=NS(stop=Mock(side_effect=[RuntimeError('busy'),None]))
    r._game=game;r._resume_menu=Mock()
    with pytest.raises(RuntimeError):r._service_recovery()
    assert r._game is game;r._resume_menu.assert_not_called()
    r._service_recovery()
    assert r._game is None;r._resume_menu.assert_called_once()


def test_recovery_does_not_race_live_menu_or_preview():
    r=shell();r._menu_recovery_pending=True;r.return_to_menu=Mock()
    r._menu_thread=NS(is_alive=lambda:True);r._service_recovery()
    r._menu_thread=None;r._preview_active=True;r._service_recovery()
    r.return_to_menu.assert_not_called()


def test_poisoned_gpu_requests_existing_clean_restart_once():
    r=shell();r._menu_recovery_pending=True;r._sink._poison='timeout'
    r._restart_callback=Mock();r.return_to_menu=Mock()
    r._service_recovery();r._service_recovery()
    r._restart_callback.assert_called_once();r.return_to_menu.assert_not_called()


def hand_backend(monkeypatch):
    provider=object()
    supervisor=NS(input_provider=provider,_worker=NS(preview=object(),preview_encoder=object()))
    replacement=NS(attach_preview=Mock(),set_preview_activity=Mock(),
                   set_page_mode=Mock(),start=Mock())
    r=C6IButtonRuntimeBackend(NS(build_id=0xC0061000),supervisor,
        startup_hand=lambda:True,hand_session_factory=Mock(return_value=replacement),menu_fps=0)
    r._hand_permissions_closed=False
    old=NS(seconds=None,status=lambda:dict(phase='FAULT'),recover_release=Mock(return_value=True),
        gate=NS(root=Path('root'),python=Path('python'),port='sim'),output_dir=Path('receipts'))
    r._hand_session=old
    gate=Mock(return_value=True)
    monkeypatch.setattr('pynq_multimodal_game.hand_startup.HandStartupGate',Mock(return_value=gate))
    return r,old,replacement,gate,provider


def test_hand_fault_restarts_fresh_session_after_release_and_new_check(monkeypatch):
    r,old,new,gate,provider=hand_backend(monkeypatch)
    r._recover_hand_session()
    old.recover_release.assert_called_once();gate.assert_called_once()
    r._hand_session_factory.assert_called_once_with(provider)
    assert r._hand_session is new and new.gate is gate
    new.start.assert_called_once();new.set_page_mode.assert_called_once_with('live')


@pytest.mark.parametrize('condition',['unknown_off','video','video_loading','preview_transfer','bounded','closing'])
def test_hand_recovery_does_not_spawn_conflicting_or_bounded_owner(monkeypatch,condition):
    r,old,new,gate,_=hand_backend(monkeypatch)
    if condition=='unknown_off':old.recover_release.return_value=False
    if condition=='video':r._mode=ShellMode.VIDEO
    if condition=='video_loading':old._video_paused=True
    if condition=='preview_transfer':r._preview_active=True;r._preview_ready=False
    if condition=='bounded':old.seconds=30
    if condition=='closing':r._closing=True
    r._recover_hand_session()
    r._hand_session_factory.assert_not_called();new.start.assert_not_called()


def test_hand_failed_recheck_backs_off_and_can_succeed_later(monkeypatch):
    r,old,new,gate,_=hand_backend(monkeypatch)
    gate.side_effect=[RuntimeError('USB unavailable'),True]
    r._recover_hand_session();r._recover_hand_session()
    assert gate.call_count==1 and r._hand_session is old
    assert 'USB unavailable' in r._hand_recovery_error
    r._hand_retry_at=0;r._recover_hand_session()
    new.start.assert_called_once();assert r._hand_recovery_error is None


def test_healthy_hand_does_not_read_status_or_probe(monkeypatch):
    r,old,new,gate,_=hand_backend(monkeypatch)
    old.finished=threading.Event();old.status=Mock(side_effect=AssertionError('extra status read'))
    r._recover_hand_session()
    old.status.assert_not_called();gate.assert_not_called()


def test_video_permission_arriving_during_hand_check_prevents_rearm(monkeypatch):
    r,old,new,gate,_=hand_backend(monkeypatch)
    def check():old._video_paused=True;return True
    gate.side_effect=check;r._recover_hand_session()
    r._hand_session_factory.assert_not_called()


def test_failed_game_is_cleaned_then_menu_recovers_without_user_click():
    r=shell();r._mode=ShellMode.GAME
    r._game=NS(last_error='game input failed',stop=Mock())
    old=r._game;r._resume_menu=Mock();r._service_recovery()
    old.stop.assert_called_once();r._resume_menu.assert_called_once()
    assert r._game is None and 'game input failed' in r._last_error


def test_preview_during_failed_game_releases_it_before_restore():
    r=shell();r._mode=ShellMode.GAME
    r._game=NS(last_error='worker ended',stop=Mock(),paused=False)
    old=r._game;r._preview_modes=lambda:{'debug'}
    r._stop_menu=Mock();r._select_page_locked=Mock();r._show_preview_pause=Mock()
    r._sync_preview_activity()
    old.stop.assert_called_once()
    assert r._preview_ready and r._game is None
    assert r._preview_saved['menu'] and r._preview_saved['game'] is None


def test_preview_during_failed_video_retries_cleanup_before_menu():
    r=shell();r._mode=ShellMode.VIDEO;r._preview_modes=lambda:{'debug'}
    complete=[False]
    r._video=NS(snapshot=NS(state=AgentState.ERROR),stop=Mock(),
                cleanup_complete=lambda:complete[0],set_preview_exclusive=Mock())
    r._select_page_locked=Mock();r._stop_menu=Mock();r._show_preview_pause=Mock()
    with pytest.raises(RuntimeError,match='Retrying'):r._sync_preview_activity()
    r._select_page_locked.assert_not_called()
    complete[0]=True;r._sync_preview_activity()
    assert r._video.stop.call_count==2 and r._preview_ready
    assert r._preview_saved['menu'] and not r._preview_saved['video']


def test_video_failure_at_preview_close_restores_menu():
    r=shell();r._preview_active=True;r._preview_ready=True
    r._preview_saved=dict(video=True,video_running=True,game=None,menu=False,demo=False)
    r._video=NS(snapshot=NS(state=AgentState.ERROR),stop=Mock(),
                cleanup_complete=lambda:True,set_preview_exclusive=Mock())
    r._select_page_locked=Mock();r._start_menu_locked=Mock()
    r._sync_preview_activity()
    assert not r._preview_active;r._start_menu_locked.assert_called_once()
    r._video.set_preview_exclusive.assert_called_once_with(False)
