import hashlib
import importlib
import json
import subprocess
from dataclasses import replace
from pathlib import Path
from unittest.mock import MagicMock

import pytest


@pytest.fixture
def guard(monkeypatch):
    monkeypatch.syspath_prepend(str(Path(__file__).resolve().parents[1] / "board/pynq_z2/scripts"))
    return importlib.import_module("run_vision_guarded")


@pytest.fixture
def launch(guard, tmp_path):
    bit = tmp_path / "camera_hand_skin_v6.bit"
    bit.write_bytes(b"bit fixture")
    bit.with_suffix(".hwh").write_bytes(b"hwh fixture")
    camera = tmp_path / "capture_camera_direct_plug.py"
    camera.write_bytes(b"camera fixture")
    return guard.VisionLaunch(bit, tmp_path, hashlib.sha256(camera.read_bytes()).hexdigest(), tmp_path / "runs")


def test_guard_command_is_fixed_candidate_and_safe_profile(guard, launch):
    command = launch.command()
    assert command[:3] == [launch.python, "-u", str(guard.CANDIDATE)]
    for required in ("--host-only", "--live", "--pl-skin", "--tracking", "--no-record"):
        assert required in command
    assert "--shared-live" not in command
    with pytest.raises(ValueError, match="SHA-256 mismatch"):
        replace(launch, camera_sha256="0" * 64).command()


@pytest.mark.parametrize("options", [{"port": True}, {"port": 0}, {"duration": float("nan")},
                                    {"preview_fps": 31}, {"debug_fps": float("inf")}, {"bind": "::1"},
                                    {"duration": True}, {"preview_fps": True}])
def test_guard_command_rejects_invalid_configuration(launch, options):
    with pytest.raises(ValueError):
        replace(launch, **options).command()


def test_guard_recognizes_old_new_and_gpu_owners_without_substring_false_positive(guard, tmp_path):
    commands = {
        1: b"python\0/x/vision_async_runtime.py\0",
        2: b"python\0/x/run_accel_guarded.py\0",
        3: b"python\0-m\0pynq_multimodal_game.agent\0--backend\0c6i-shell\0",
        4: b"editor\0notes_vision_async_runtime.py.txt\0",
        5: b"python\0-m\0pynq_multimodal_game.agent\0--backend\0mock\0",
        6: b"python\0/x/run_vision_guarded.py\0",
    }
    for pid, command in commands.items():
        directory = tmp_path / str(pid)
        directory.mkdir()
        (directory / "cmdline").write_bytes(command)
    assert guard.conflicting_owners(tmp_path, {6}) == [1, 2, 3]


@pytest.fixture
def supervised(guard, launch, monkeypatch):
    monkeypatch.setattr(guard.signal, "SIGSTOP", 19, raising=False)
    lease = MagicMock()
    lease.fileno.return_value = 99
    child = MagicMock(pid=456)
    child.poll.return_value = None
    spawn = MagicMock(return_value=child)
    halt = MagicMock(return_value=True)
    kill = MagicMock(side_effect=lambda _: setattr(child.poll, "return_value", -9 if child.poll() is None else child.poll()))
    worker = guard.GuardedVisionProcess(launch, process_factory=spawn, lease_factory=lambda _: lease,
                                       verifier=MagicMock(), halt=halt, terminate_group=kill, scan=lambda: [])
    yield worker, child, lease, spawn, halt, kill
    if worker._log is not None:
        worker._log.close()


def receipt(worker, child, **values):
    packet = dict(owner_pid=child.pid, session_id=worker._launch.output_dir.name,
                  state="RUNNING", frame_id=1)
    packet.update(values)
    (worker._launch.output_dir / "worker_lifecycle.json").write_text(json.dumps(packet), encoding="utf-8")


def test_supervisor_readiness_duplicate_start_and_clean_stop(supervised):
    worker, child, lease, spawn, halt, kill = supervised
    assert worker.start()["state"] == "STARTING"
    receipt(worker, child, owner_pid=123)
    assert worker.status()["state"] == "STARTING"
    receipt(worker, child, session_id="foreign")
    assert worker.status()["state"] == "STARTING"
    receipt(worker, child, frame_id=True)
    assert worker.status()["state"] == "STARTING"
    receipt(worker, child)
    assert worker.status()["state"] == "RUNNING"
    assert worker.start()["state"] == "RUNNING"
    spawn.assert_called_once()
    assert spawn.call_args.kwargs["pass_fds"] == (99,)
    child.poll.return_value = 0
    stopped = worker.stop()
    assert stopped["state"] == "IDLE" and stopped["cleanup_confirmed"] and not stopped["owner_held"]
    halt.assert_called_once()
    lease.close.assert_called_once()
    worker.stop()
    halt.assert_called_once()


@pytest.mark.parametrize("failure", [False, TimeoutError("DMA halt timeout")])
def test_supervisor_unconfirmed_halt_retains_child_and_owner(supervised, failure):
    worker, child, lease, spawn, halt, kill = supervised
    worker.start()
    child.wait.side_effect = subprocess.TimeoutExpired("fixture", 10)
    if isinstance(failure, Exception):
        halt.side_effect = failure
    else:
        halt.return_value = failure
    with pytest.raises(RuntimeError, match="hardware owner retained"):
        worker.stop()
    assert worker.status()["state"] == "FAULT"
    assert worker.status()["owner_held"] and not worker.status()["cleanup_confirmed"]
    lease.close.assert_not_called()
    kill.assert_not_called()
    assert child.send_signal.call_args_list[-1].args == (19,)
    with pytest.raises(RuntimeError, match="recovery required"):
        worker.start()
    spawn.assert_called_once()


def test_supervisor_confirmed_halt_precedes_group_kill_and_release(supervised):
    worker, child, lease, spawn, halt, kill = supervised
    events = []
    halt.side_effect = lambda _: events.append("halt") or True
    kill.side_effect = lambda _: (events.append("kill"), setattr(child.poll, "return_value", -9))
    lease.close.side_effect = lambda: events.append("release")
    worker.start()
    receipt(worker, child, state="FAULT", retaining_buffers=True)
    assert worker.status()["state"] == "FAULT"
    stopped = worker.stop()
    assert events == ["halt", "kill", "release"]
    child.send_signal.assert_called_once_with(19)
    assert stopped["state"] == "FAULT" and stopped["cleanup_confirmed"]


def test_supervisor_spawn_failure_releases_unused_owner(supervised):
    worker, child, lease, spawn, halt, kill = supervised
    spawn.side_effect = OSError("spawn failed")
    with pytest.raises(OSError, match="spawn failed"):
        worker.start()
    lease.close.assert_called_once()
    halt.assert_not_called()
    assert not worker.status()["owner_held"]


def test_supervisor_conflict_and_readiness_timeout(supervised):
    worker, child, lease, spawn, halt, kill = supervised
    worker._scan = lambda: [100]
    with pytest.raises(RuntimeError, match="Another hardware owner"):
        worker.start()
    spawn.assert_not_called()
    worker._scan = lambda: []
    worker.start()
    worker._started -= 31
    assert worker.status()["state"] == "FAULT"
    assert "readiness timed out" in worker.status()["last_error"]
    assert worker.status()["owner_held"]
    child.poll.return_value = 0
    stopped = worker.stop()
    assert stopped["state"] == "FAULT" and stopped["cleanup_confirmed"]
    assert "readiness timed out" in stopped["last_error"]


def test_supervisor_normal_expiry_requires_cleanup_not_false_fault(supervised):
    worker, child, lease, spawn, halt, kill = supervised
    worker.start()
    receipt(worker, child)
    assert worker.status()["state"] == "RUNNING"
    child.poll.return_value = 0
    assert worker.status()["state"] == "STOPPING"
    assert worker.status()["owner_held"] and not worker.status()["cleanup_confirmed"]
    assert worker.stop()["state"] == "IDLE"


def test_supervisor_exit_before_readiness_is_fault_even_with_zero_code(supervised):
    worker, child, lease, spawn, halt, kill = supervised
    worker.start()
    child.poll.return_value = 0
    assert worker.status()["state"] == "FAULT"
    assert worker.stop()["state"] == "FAULT"


def test_supervisor_lock_denial_and_post_lock_conflict_never_spawn(supervised):
    worker, child, lease, spawn, halt, kill = supervised
    worker._lease_factory = MagicMock(side_effect=BlockingIOError("owner lock busy"))
    with pytest.raises(BlockingIOError):
        worker.start()
    spawn.assert_not_called()
    worker._lease_factory = lambda _: lease
    worker._scan = MagicMock(side_effect=[[], [100]])
    with pytest.raises(RuntimeError, match="Another hardware owner"):
        worker.start()
    lease.close.assert_called_once()
    spawn.assert_not_called()


def test_guard_receipt_atomic_pid_session_and_cleanup(monkeypatch, tmp_path):
    monkeypatch.syspath_prepend(str(Path(__file__).resolve().parents[1] / "board/pynq_z2/scripts"))
    module = importlib.import_module("vision_async_runtime")
    path = tmp_path / "worker_lifecycle.json"
    module.write_guard_receipt(path, "RUNNING", "run-a", 1)
    packet = json.loads(path.read_text())
    assert packet["session_id"] == tmp_path.name
    assert packet["owner_pid"] == module.os.getpid()
    assert packet["frame_id"] == 1
    assert not path.with_suffix(".tmp").exists()
    module.write_guard_receipt(path, "FAULT", "run-a", 1, {"hardware": ["DMA timeout"]}, True)
    packet = json.loads(path.read_text())
    assert packet["retaining_buffers"] and packet["cleanup"]["hardware"]


def test_package_preflight_uses_frozen_skn6_identity(guard, tmp_path):
    guard.verify_package(guard.RUNTIME)
    (tmp_path / "manifest.json").write_text(json.dumps({"protocol": "other"}))
    with pytest.raises(ValueError, match="SKN6"):
        guard.verify_package(tmp_path)


def test_package_preflight_rejects_rehashed_hardware_identity(guard, tmp_path):
    manifest = json.loads((guard.RUNTIME / "manifest.json").read_text(encoding="utf-8-sig"))
    manifest["sha256"]["camera_hand_skin_v6.bit"] = "0" * 64
    (tmp_path / "manifest.json").write_text(json.dumps(manifest))
    with pytest.raises(ValueError, match="Frozen hardware identity mismatch"):
        guard.verify_package(tmp_path)


def test_supervisor_explicit_cleanup_retry_releases_only_after_confirmation(supervised):
    worker, child, lease, spawn, halt, kill = supervised
    worker.start()
    child.wait.side_effect = subprocess.TimeoutExpired("fixture", 10)
    halt.return_value = False
    with pytest.raises(RuntimeError, match="owner retained"):
        worker.stop()
    lease.close.assert_not_called()
    kill.assert_not_called()
    halt.return_value = True
    child.wait.side_effect = None
    stopped = worker.stop()
    assert stopped["cleanup_confirmed"] and not stopped["owner_held"]
    assert stopped["state"] == "FAULT"
    assert "owner retained" not in stopped["last_error"]
    lease.close.assert_called_once()
    kill.assert_called_once()


def test_cli_check_only_does_not_spawn_or_create_run(guard, launch, monkeypatch, capsys):
    verified = MagicMock()
    started = MagicMock()
    monkeypatch.setattr(guard, "verify_package", verified)
    monkeypatch.setattr(guard.GuardedVisionProcess, "start", started)
    assert guard.main([str(launch.bitstream), str(launch.output_dir), "--camera-dir", str(launch.camera_dir),
                       "--camera-sha256", launch.camera_sha256, "--check-only"]) == 0
    verified.assert_called_once()
    started.assert_not_called()
    assert not launch.output_dir.exists()
    assert json.loads(capsys.readouterr().out)["board_validated"] is False


def test_cli_live_requires_linux_root(guard, launch, monkeypatch):
    monkeypatch.setattr(guard.sys, "platform", "win32")
    started = MagicMock()
    monkeypatch.setattr(guard.GuardedVisionProcess, "start", started)
    with pytest.raises(SystemExit) as error:
        guard.main([str(launch.bitstream), str(launch.output_dir), "--camera-dir", str(launch.camera_dir),
                    "--camera-sha256", launch.camera_sha256])
    assert error.value.code == 2
    started.assert_not_called()