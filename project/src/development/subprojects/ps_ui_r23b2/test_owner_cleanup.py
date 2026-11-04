"""Offline fault injection: software cleanup must not fake owner release."""
from pathlib import Path
from queue import Empty
from types import SimpleNamespace
from unittest.mock import Mock
import json
import sys
import threading

import pytest

from pynq_multimodal_game import hand_serial_session as hand
from pynq_multimodal_game.game_runner import GamePreviewProcess


def release_receipt():
    return dict(schema="vision-hand-actuator-owner-v1", session="audit", game_run="source",
                actuator="serial-fixed-playback", arm_attempted=True, backend_closed=True,
                release_confirmed=True, release_confirmed_ids=list(range(1, 18)),
                release_attempts=[dict(failed_ids=[], error=None)],
                controller=dict(lifecycle="CLOSED", error=None), active=True, error=None,
                stop_reason="owner_stop", receiver_stop="producer_revoked")


def memory_owner(tmp_path, monkeypatch, *, fail_during_run=False, receipt=None, child_stuck=False):
    owner = object.__new__(hand.SerialHandActionSession)
    owner._stop = threading.Event()
    feed = SimpleNamespace(revoked=None, read=lambda: SimpleNamespace(game_run="source"))
    feed.revoke = lambda reason: setattr(feed, "revoked", reason)
    owner.feed = feed
    owner.seconds = None
    owner.session = "audit"
    owner.output_dir = tmp_path
    owner._requested = lambda: False
    owner._preview_idle = lambda: True
    owner._preview_requested = None
    owner.gate = SimpleNamespace(python="never-started", root="unused", port="unused", passed=True)
    owner.entry = "unused"
    owner.stage_waits = (3, 3, 3)
    owner.approval_seconds = 3
    owner._child = None
    owner._thread = None
    owner._active = False
    owner._release_confirmed = None
    owner.error = None
    owner.finished = threading.Event()
    owner._source_stop_reason = None
    owner._generation = 0
    owner._pause_generation = None
    owner._control_phase = None
    owner._await_receipt = lambda *args, **kwargs: {"address": ["127.0.0.1", 44001]}
    owner._update_preview = lambda: None
    owner._publish_page = lambda: None
    owner._page_mode = "live"
    owner._preview_allowed = False
    owner.page_status = lambda: {}

    class Publisher:
        calls = 0
        def __init__(self, *args, **kwargs): pass
        def publish(self):
            self.calls += 1
            if fail_during_run or self.calls > 1:
                raise OSError("injected UDP failure")
            owner._stop.set()

    monkeypatch.setitem(sys.modules, "pynq_usb_hand.game_bridge", SimpleNamespace(DatagramPublisher=Publisher))
    sock = Mock()
    sock.getsockname.return_value = ("127.0.0.1", 44000)
    monkeypatch.setattr(hand.socket, "socket", lambda *_: sock)
    child = Mock(pid=99)
    child.poll.return_value = None
    def wait(timeout):
        if child_stuck:
            raise hand.subprocess.TimeoutExpired("memory-child", timeout)
        child.poll.return_value = 0
        value = release_receipt() if receipt is None else receipt
        (tmp_path / "serial-motion.json").write_text(json.dumps(value), encoding="utf-8")
        return 0
    child.wait.side_effect = wait
    child.terminate.side_effect = AssertionError("serial owner must never be killed")
    monkeypatch.setattr(hand.subprocess, "Popen", lambda *args, **kwargs: child)
    return owner, child, sock


@pytest.mark.parametrize("fail_during_run", [False, True])
def test_udp_final_notification_failure_still_waits_for_verified_off(tmp_path, monkeypatch, fail_during_run):
    owner, child, sock = memory_owner(tmp_path, monkeypatch, fail_during_run=fail_during_run)
    owner._run()
    assert owner.finished.is_set()
    assert owner.error == "OSError: injected UDP failure"
    assert owner._release_confirmed is True
    assert owner.status()["phase"] == "FAULT"
    child.wait.assert_called_once_with(timeout=15)
    child.terminate.assert_not_called()
    sock.close.assert_called_once()
    report = json.loads((tmp_path / "parent.json").read_text())
    assert report["release_confirmed"] is True and report["error"] == owner.error
    owner.close()


@pytest.mark.parametrize("bad_release", ["missing-motor", "stuck-child"])
def test_notification_failure_never_turns_unknown_release_into_success(tmp_path, monkeypatch, bad_release):
    receipt = release_receipt()
    receipt["release_confirmed_ids"] = list(range(1, 17))
    owner, child, sock = memory_owner(tmp_path, monkeypatch, receipt=receipt,
                                      child_stuck=bad_release == "stuck-child")
    owner._run()
    assert owner.finished.is_set() and owner.status()["phase"] == "FAULT"
    assert owner._release_confirmed is False
    assert owner.error == "OSError: injected UDP failure"
    with pytest.raises(RuntimeError):
        owner.close()
    child.terminate.assert_not_called()
    sock.close.assert_called_once()
    report = json.loads((tmp_path / "parent.json").read_text())
    assert report["release_confirmed"] is False


def test_game_preview_retains_handles_if_termination_did_not_finish():
    preview = object.__new__(GamePreviewProcess)
    preview._request_timing = None
    preview._process = Mock()
    preview._process.is_alive.return_value = True
    preview._channel = Mock()
    preview._worker_channel = Mock()
    with pytest.raises(RuntimeError, match="still running"):
        preview.stop()
    preview._channel.close.assert_not_called()
    preview._worker_channel.close.assert_not_called()
    preview._process.terminate.assert_called_once()
    preview._process.is_alive.return_value = False
    preview.stop()
    preview._channel.close.assert_called_once()
    preview._worker_channel.close.assert_called_once()

@pytest.mark.parametrize('late', ['valid', 'nonzero-exit', 'missing-motor', 'wrong-session', 'wrong-source', 'controller-fault', 'still-running', 'missing-file', 'invalid-json'])
def test_explicit_close_rechecks_late_child_exit_without_restarting_or_killing(tmp_path, monkeypatch, late):
    owner, child, sock = memory_owner(tmp_path, monkeypatch, child_stuck=True)
    owner._run()
    original_error = owner.error
    assert owner.finished.is_set() and owner._release_confirmed is False
    value = release_receipt()
    if late == 'missing-motor': value['release_confirmed_ids'] = list(range(1,17))
    if late == 'wrong-session': value['session'] = 'other-session'
    if late == 'wrong-source': value['game_run'] = 'other-source'
    if late == 'controller-fault': value['controller']['error'] = 'motor OFF incomplete'
    if late != 'missing-file':
        (tmp_path/'serial-motion.json').write_text(json.dumps(value), encoding='utf-8')
    if late == 'invalid-json': (tmp_path/'serial-motion.json').write_text('{', encoding='utf-8')
    child.poll.return_value = None if late == 'still-running' else 1 if late == 'nonzero-exit' else 0
    if late in ('valid', 'nonzero-exit'):
        owner.close()
        assert owner._release_confirmed is True
        assert owner.status()['phase'] == 'FAULT'  # original transport error remains visible
        assert owner._preview_allowed is True
        late_record = json.loads((tmp_path/'cleanup-release.json').read_text())
        assert late_record['child_exit'] == child.poll.return_value
        assert late_record['error'] == original_error
        assert late_record['release_confirmed'] is True
        assert late_record['child_receipt'] == value
        assert json.loads((tmp_path/'parent.json').read_text())['release_confirmed'] is False
        owner.close()  # idempotent verified release
    else:
        with pytest.raises(RuntimeError): owner.close()
        assert owner._release_confirmed is False
        assert owner._preview_allowed is False
    assert owner.error == original_error
    child.terminate.assert_not_called()
    child.kill.assert_not_called()
    # No new wait/loop is introduced by an explicit cleanup retry.
    child.wait.assert_called_once_with(timeout=15)
    sock.close.assert_called_once()


def test_late_release_receipt_write_failure_is_retryable_without_losing_first_error(tmp_path, monkeypatch):
    owner, child, sock = memory_owner(tmp_path, monkeypatch, child_stuck=True)
    owner._run()
    original_error = owner.error
    (tmp_path/'serial-motion.json').write_text(json.dumps(release_receipt()), encoding='utf-8')
    child.poll.return_value = 0
    write = Path.write_text
    def fail_once(path, *args, **kwargs):
        if path.name == 'cleanup-release.tmp': raise OSError('receipt disk failure')
        return write(path, *args, **kwargs)
    with monkeypatch.context() as patch:
        patch.setattr(Path, 'write_text', fail_once)
        with pytest.raises(RuntimeError) as failure: owner.close()
        assert 'receipt disk failure' in str(failure.value.__cause__)
    assert owner._release_confirmed is False and owner.error == original_error
    owner.close()
    assert owner._release_confirmed is True and owner.error == original_error
    assert json.loads((tmp_path/'cleanup-release.json').read_text())['release_confirmed'] is True
    child.terminate.assert_not_called()

@pytest.mark.parametrize('valid_off', [True, False])
def test_real_late_subprocess_exit_requires_valid_receipt_before_releasing(tmp_path, monkeypatch, valid_off):
    import subprocess
    # A CPU-only child blocks on stdin, then writes a model receipt and exits.
    # It never imports an SDK or opens a device, and does not busy-poll.
    value = release_receipt()
    if not valid_off:
        value['release_confirmed_ids'] = list(range(1,17))
    script = ('import sys; from pathlib import Path; '
              'sys.stdin.buffer.read(1); '
              'Path(sys.argv[1]).write_text(sys.argv[2], encoding="utf-8")')
    process = subprocess.Popen([sys.executable, '-I', '-B', '-c', script,
                                str(tmp_path/'serial-motion.json'), json.dumps(value)],
                               stdin=subprocess.PIPE, stdout=subprocess.DEVNULL,
                               stderr=subprocess.PIPE)
    try:
        owner, _, sock = memory_owner(tmp_path, monkeypatch, child_stuck=True)
        child = Mock(pid=process.pid)
        child.poll.side_effect = process.poll
        # Exercise an actual timeout with a shorter offline budget. Production
        # keeps its existing 15s bound; no real device delay is injected.
        child.wait.side_effect = lambda timeout: process.wait(timeout=.02)
        child.terminate.side_effect = AssertionError('cannot kill a serial owner')
        child.kill.side_effect = AssertionError('cannot kill a serial owner')
        monkeypatch.setattr(hand.subprocess, 'Popen', lambda *a, **kw: child)
        owner._thread = threading.Thread(target=owner._run, name='offline-hand-parent')
        owner._thread.start()
        owner._thread.join(2)
        assert not owner._thread.is_alive() and owner.finished.is_set()
        assert process.poll() is None
        assert owner._release_confirmed is False
        with pytest.raises(RuntimeError, match='still owns process'):
            owner.close()
        # Permit the real child to complete only AFTER the bounded parent wait.
        process.stdin.write(b'x'); process.stdin.flush(); process.stdin.close()
        assert process.wait(timeout=3) == 0
        if valid_off:
            owner.close()
            assert owner._release_confirmed is True
            assert json.loads((tmp_path/'cleanup-release.json').read_text())['child_pid'] == process.pid
        else:
            with pytest.raises(RuntimeError): owner.close()
            assert owner._release_confirmed is False
            assert not (tmp_path/'cleanup-release.json').exists()
        assert not owner._thread.is_alive() and child.poll() == 0
        child.terminate.assert_not_called(); child.kill.assert_not_called()
        child.wait.assert_called_once_with(timeout=15)
        sock.close.assert_called_once()
    finally:
        if process.stdin is not None and not process.stdin.closed:
            process.stdin.close()
        try:
            process.wait(timeout=3)
        except subprocess.TimeoutExpired:
            process.kill(); process.wait(timeout=3)  # test-only CPU child cleanup
        if process.stderr is not None:
            process.stderr.close()
