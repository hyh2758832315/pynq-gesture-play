from __future__ import annotations

import importlib.util
from pathlib import Path
import sys

import pytest


BOARD_DIR = Path(__file__).parents[1] / "board" / "pynq_z2"
sys.path.insert(0, str(BOARD_DIR))
MODULE_PATH = BOARD_DIR / "run_s3b_acceptance.py"
SPEC = importlib.util.spec_from_file_location("run_s3b_acceptance", MODULE_PATH)
assert SPEC is not None and SPEC.loader is not None
run_s3b_acceptance = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = run_s3b_acceptance
SPEC.loader.exec_module(run_s3b_acceptance)


def test_build_agent_command_uses_only_deployed_paths() -> None:
    command = run_s3b_acceptance.build_agent_command(
        "pynq-z2",
        "/deploy/s3b-agent",
        port=8765,
        size=65536,
        rate=10.0,
        timeout=5.0,
    )

    assert command[:3] == ["ssh", "pynq-z2", "sudo"]
    assert "PYTHONPATH=/deploy/s3b-agent/python" in command
    assert "/deploy/s3b-agent/c6_runtime_return_integrated.bit" in command
    assert "/home/xilinx/voice-view-game/python" not in command


def test_parse_listener_pid_requires_exactly_one_pid() -> None:
    output = 'LISTEN 0 5 0.0.0.0:8765 0.0.0.0:* users:(("python",pid=3174,fd=9))'

    assert run_s3b_acceptance.parse_listener_pid(output) == 3174

    with pytest.raises(RuntimeError, match="expected one listener PID"):
        run_s3b_acceptance.parse_listener_pid("")
    with pytest.raises(RuntimeError, match="expected one listener PID"):
        run_s3b_acceptance.parse_listener_pid(output + " pid=3175")


def test_agent_pid_ignores_sudo_wrapper(monkeypatch: pytest.MonkeyPatch) -> None:
    output = """ 5261 sudo -n env XILINX_XRT=/usr /usr/local/share/pynq-venv/bin/python -u -m pynq_multimodal_game.agent.cli --bitstream /deploy/c6_runtime_return_integrated.bit
 5266 /usr/local/share/pynq-venv/bin/python -u -m pynq_multimodal_game.agent.cli --bitstream /deploy/c6_runtime_return_integrated.bit
"""
    result = run_s3b_acceptance.subprocess.CompletedProcess([], 0, output, "")
    monkeypatch.setattr(run_s3b_acceptance, "run_ssh", lambda *_args: result)

    assert run_s3b_acceptance.agent_pid("pynq-z2", "/deploy") == 5266


def test_run_ssh_detaches_stdin(monkeypatch: pytest.MonkeyPatch) -> None:
    captured = {}

    def fake_run(command, **kwargs):
        captured["command"] = command
        captured.update(kwargs)
        return run_s3b_acceptance.subprocess.CompletedProcess(command, 0, "", "")

    monkeypatch.setattr(run_s3b_acceptance.subprocess, "run", fake_run)

    run_s3b_acceptance.run_ssh("pynq-z2", "true")

    assert captured["stdin"] is run_s3b_acceptance.subprocess.DEVNULL