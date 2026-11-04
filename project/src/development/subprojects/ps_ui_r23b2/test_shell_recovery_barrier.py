"""Failed startup owners must be cleaned before any producer can take over.

Run with PYTHONPATH=subprojects/ps_ui_r23b2/python;.:
 .venv/Scripts/python.exe -B -m pytest -q subprojects/ps_ui_r23b2/test_shell_recovery_barrier.py
Output: assertions only, no board/process/serial access.
Next: run normal shell mode integration before building a deployment candidate.
"""
from types import SimpleNamespace
from unittest.mock import Mock

import pytest

from pynq_multimodal_game.agent import c6i_shell
from pynq_multimodal_game.agent.c6i_shell import C6IShellRuntimeBackend, ShellMode


def retained_shell():
    value = C6IShellRuntimeBackend(SimpleNamespace(build_id=0xC0061000), menu_fps=0)
    value._sink = SimpleNamespace(upload_palette=Mock(), upload_asset=Mock(),
                                  upload_tilemap=Mock(), submit_scene=Mock())
    value._game = SimpleNamespace(stop=Mock(side_effect=RuntimeError('game owner unconfirmed')))
    return value


def test_return_does_not_discard_retained_game_from_failed_startup():
    value = retained_shell()
    owner = value._game
    with pytest.raises(RuntimeError, match='game owner unconfirmed'):
        value.return_to_menu()
    assert value._game is owner
    value._sink.submit_scene.assert_not_called()
    owner.stop.side_effect = None
    value.return_to_menu()
    assert value._game is None and value.mode is ShellMode.MENU
    assert owner.stop.call_count == 2
    assert value._sink.submit_scene.call_count == 2  # return loading + recovered menu


def test_video_run_cannot_bypass_retained_game():
    value = retained_shell()
    value._video.run = Mock()
    with pytest.raises(RuntimeError, match='game owner unconfirmed'):
        value.run()
    value._video.run.assert_not_called()
    value._sink.submit_scene.assert_not_called()


def test_new_game_cannot_overwrite_failed_startup_owner(monkeypatch):
    value = retained_shell()
    owner = value._game
    value._game_ids = ('game1',)
    value._game_entries = {'game1': SimpleNamespace(asset='unused.vvg',
        manifest=SimpleNamespace(display_name='SKY RUN'))}
    monkeypatch.setattr(c6i_shell, 'validate_game_package',
        lambda *_a, **_kw: SimpleNamespace(manifest=SimpleNamespace(volume_inputs=None)))
    constructor = Mock(side_effect=AssertionError('created another producer'))
    monkeypatch.setattr(c6i_shell, 'PackagedGameRuntime', constructor)
    with pytest.raises(RuntimeError, match='game owner unconfirmed'):
        value.start_game('game1')
    constructor.assert_not_called()
    assert value._game is owner


def test_menu_recovery_does_not_write_over_unknown_video_owner():
    value = retained_shell()
    value._game = None
    value._mode = ShellMode.VIDEO
    value._video._cleanup_sink = object()
    with pytest.raises(RuntimeError, match='VIDEO|video'):
        value._resume_menu()
    assert value.mode is ShellMode.VIDEO
    value._sink.submit_scene.assert_not_called()


def test_menu_recovery_does_not_write_over_retained_game():
    value = retained_shell()
    with pytest.raises(RuntimeError, match='game|GAME'):
        value._resume_menu()
    value._sink.submit_scene.assert_not_called()


def game_catalog(value, monkeypatch):
    value._game_ids = ('game1',)
    value._game_entries = {'game1': SimpleNamespace(asset='unused.vvg',
        manifest=SimpleNamespace(display_name='SKY RUN'))}
    monkeypatch.setattr(c6i_shell, 'validate_game_package',
        lambda *_a, **_kw: SimpleNamespace(manifest=SimpleNamespace(volume_inputs=None)))


def test_real_failed_startup_path_preserves_owner_across_later_commands(monkeypatch):
    value = retained_shell()
    value._game = None
    game_catalog(value, monkeypatch)
    primary, cleanup = RuntimeError('first step failed'), RuntimeError('game owner unconfirmed')
    owner = SimpleNamespace(start=Mock(side_effect=primary), stop=Mock(side_effect=cleanup))
    constructor = Mock(return_value=owner)
    monkeypatch.setattr(c6i_shell, 'PackagedGameRuntime', constructor)
    with pytest.raises(RuntimeError) as raised:
        value.start_game('game1')
    assert raised.value is primary and raised.value.__cause__ is cleanup
    assert value._game is owner and value.mode is ShellMode.MENU
    assert value._sink.submit_scene.call_count == 1  # loading, before the failed owner existed
    with pytest.raises(RuntimeError, match='game owner unconfirmed'):
        value.start_game('game1')
    assert constructor.call_count == 1 and value._game is owner
    assert value._sink.submit_scene.call_count == 1  # retained owner cannot be overwritten
    owner.stop.side_effect = None
    value.return_to_menu()
    assert value._game is None
    assert value._sink.submit_scene.call_count == 3  # start loading + return loading + menu


def test_invalid_test_case_still_closes_allocated_preview_owner(monkeypatch):
    value = retained_shell()
    value._game = None
    game_catalog(value, monkeypatch)
    owner = SimpleNamespace(start=Mock(), stop=Mock(), load_test_case=Mock())
    monkeypatch.setattr(c6i_shell, 'PackagedGameRuntime', Mock(return_value=owner))
    with pytest.raises(ValueError):
        value.start_game('game1', 'invalid-json')
    owner.start.assert_not_called()
    owner.stop.assert_called_once()
    assert value._game is None and value.mode is ShellMode.MENU
    assert value._sink.submit_scene.call_count == 3  # start loading + return loading + menu


def test_failed_video_run_preserves_primary_error_and_never_starts_menu():
    value = retained_shell()
    value._game = None
    primary = RuntimeError('VIDEO is in an error state')
    value._video.run = Mock(side_effect=primary)
    value._video._cleanup_sink = object()
    with pytest.raises(RuntimeError) as raised:
        value.run()
    assert raised.value is primary
    assert raised.value.__cause__ is None  # no attempted takeover/recovery of a retained owner
    assert value.mode is ShellMode.MENU  # preserve the original presentation state
    value._sink.submit_scene.assert_not_called()


def test_page_selection_and_menu_start_do_not_bypass_retained_owner():
    value = retained_shell()
    for operation in (lambda: value._select_page_locked(c6i_shell.MenuPage.GAMES),
                      value._start_menu_locked):
        with pytest.raises(RuntimeError, match='game cleanup'):
            operation()
    assert value.page is c6i_shell.MenuPage.HOME
    value._sink.submit_scene.assert_not_called()
