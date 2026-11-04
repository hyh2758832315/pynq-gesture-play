from __future__ import annotations

import argparse
import json
import math
from pathlib import Path
import re
import socket
import subprocess
import time
from typing import Any

from verify_s3b_agent import verify_agent


DEFAULT_REMOTE_ROOT = "/home/xilinx/voice-view-game/s3b-agent"
DEFAULT_REMOTE_PYTHON = "/usr/local/share/pynq-venv/bin/python"
PID_PATTERN = re.compile(r'pid=(\d+)')


def build_agent_command(
    ssh_host: str,
    remote_root: str,
    *,
    port: int,
    size: int,
    rate: float,
    timeout: float,
) -> list[str]:
    return [
        "ssh",
        ssh_host,
        "sudo",
        "-n",
        "env",
        "XILINX_XRT=/usr",
        f"PYTHONPATH={remote_root}/python",
        DEFAULT_REMOTE_PYTHON,
        "-u",
        "-m",
        "pynq_multimodal_game.agent.cli",
        "--host",
        "0.0.0.0",
        "--port",
        str(port),
        "--build-id",
        "0xC0060700",
        "--return-source",
        "c6i",
        "--bitstream",
        f"{remote_root}/c6_runtime_return_integrated.bit",
        "--return-size",
        str(size),
        "--return-rate",
        str(rate),
        "--return-timeout",
        str(timeout),
        "--return-source-id",
        "3",
        "--seed-base",
        "0xC6D00000",
    ]


def parse_listener_pid(output: str) -> int:
    pids = {int(value) for value in PID_PATTERN.findall(output)}
    if len(pids) != 1:
        raise RuntimeError(f"expected one listener PID, got {sorted(pids)}")
    return pids.pop()


def run_ssh(ssh_host: str, remote_command: str) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        ["ssh", ssh_host, remote_command],
        check=False,
        capture_output=True,
        stdin=subprocess.DEVNULL,
        text=True,
    )


def wait_for_port(host: str, port: int, timeout: float, *, open_state: bool) -> None:
    deadline = time.monotonic() + timeout
    while True:
        try:
            with socket.create_connection((host, port), timeout=min(timeout, 0.5)):
                is_open = True
        except OSError:
            is_open = False
        if is_open == open_state:
            return
        if time.monotonic() >= deadline:
            state = "open" if open_state else "closed"
            raise TimeoutError(f"port {host}:{port} did not become {state}")
        time.sleep(0.05)


def wait_for_agent(
    process: subprocess.Popen[str], host: str, port: int, timeout: float
) -> None:
    deadline = time.monotonic() + timeout
    while True:
        if process.poll() is not None:
            output, _ = process.communicate()
            raise RuntimeError(
                f"Agent exited {process.returncode} before listening: {output.strip()}"
            )
        try:
            with socket.create_connection((host, port), timeout=0.5):
                return
        except OSError:
            pass
        if time.monotonic() >= deadline:
            raise TimeoutError(f"Agent did not listen on {host}:{port} within {timeout}s")
        time.sleep(0.05)


def listener_pid(ssh_host: str, port: int) -> int:
    result = run_ssh(ssh_host, f"sudo -n ss -ltnp | grep ':{port} '")
    if result.returncode != 0:
        raise RuntimeError(f"listener query failed: {result.stderr.strip()}")
    return parse_listener_pid(result.stdout)


def agent_pid(ssh_host: str, remote_root: str) -> int:
    result = run_ssh(ssh_host, "ps -eo pid=,args=")
    if result.returncode != 0:
        raise RuntimeError(f"process query failed: {result.stderr.strip()}")
    marker = "-m pynq_multimodal_game.agent.cli"
    bitstream = f"{remote_root}/c6_runtime_return_integrated.bit"
    pids = []
    for line in result.stdout.splitlines():
        fields = line.strip().split(maxsplit=1)
        if len(fields) != 2:
            continue
        command = fields[1]
        if command.startswith(DEFAULT_REMOTE_PYTHON) and marker in command and bitstream in command:
            pids.append(int(fields[0]))
    if len(pids) != 1:
        raise RuntimeError(f"expected one Agent process PID, got {pids}")
    return pids[0]


def assert_lock_free(ssh_host: str, lock_path: str) -> None:
    result = run_ssh(ssh_host, f"sudo -n flock -n {lock_path} -c true")
    if result.returncode != 0:
        raise RuntimeError(f"lock remains held: {lock_path}")


def run_once(
    ssh_host: str,
    agent_host: str,
    remote_root: str,
    *,
    port: int,
    size: int,
    rate: float,
    timeout: float,
    startup_timeout: float,
    frames: int,
) -> dict[str, Any]:
    wait_for_port(agent_host, port, timeout, open_state=False)
    assert_lock_free(ssh_host, "/var/lock/voice-view-c6i.lock")
    process = subprocess.Popen(
        build_agent_command(
            ssh_host,
            remote_root,
            port=port,
            size=size,
            rate=rate,
            timeout=timeout,
        ),
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        stdin=subprocess.DEVNULL,
        text=True,
    )
    pid: int | None = None
    output = ""
    try:
        wait_for_agent(process, agent_host, port, startup_timeout)
        pid = listener_pid(ssh_host, port)
        summary = verify_agent(
            agent_host,
            port,
            frames=frames,
            size=size,
            timeout=timeout,
        )
        stopped = run_ssh(ssh_host, f"sudo -n kill -TERM {pid}")
        if stopped.returncode != 0:
            raise RuntimeError(f"SIGTERM failed for PID {pid}: {stopped.stderr.strip()}")
        output, _ = process.communicate(timeout=timeout + 5.0)
        if process.returncode != 0:
            raise RuntimeError(
                f"Agent SSH process exited {process.returncode}: {output.strip()}"
            )
        wait_for_port(agent_host, port, timeout, open_state=False)
        assert_lock_free(ssh_host, "/var/lock/voice-view-c6i.lock")
        result = {
            "pid": pid,
            "agent_exit_code": process.returncode,
            "agent_output": output.strip().splitlines(),
        }
        result.update(summary.__dict__)
        return result
    finally:
        if process.poll() is None:
            if pid is None:
                try:
                    pid = agent_pid(ssh_host, remote_root)
                except RuntimeError:
                    pass
            if pid is not None:
                run_ssh(ssh_host, f"sudo -n kill -TERM {pid}")
            try:
                process.communicate(timeout=timeout + 5.0)
            except subprocess.TimeoutExpired:
                process.terminate()
                process.communicate(timeout=timeout)


def main() -> None:
    parser = argparse.ArgumentParser(description="Run repeatable S3B Agent acceptance")
    parser.add_argument("--ssh-host", default="pynq-z2")
    parser.add_argument("--agent-host", default="192.168.2.99")
    parser.add_argument("--remote-root", default=DEFAULT_REMOTE_ROOT)
    parser.add_argument("--port", type=int, default=8765)
    parser.add_argument("--size", type=int, default=65536)
    parser.add_argument("--rate", type=float, default=10.0)
    parser.add_argument("--timeout", type=float, default=5.0)
    parser.add_argument("--startup-timeout", type=float, default=30.0)
    parser.add_argument("--restart-count", type=int, default=10)
    parser.add_argument("--frames-per-restart", type=int, default=3)
    parser.add_argument("--soak-seconds", type=float, default=0.0)
    args = parser.parse_args()
    if args.restart_count < 0 or args.frames_per_restart < 1 or args.soak_seconds < 0:
        parser.error("restart-count and soak-seconds must be nonnegative; frames must be positive")

    results: list[dict[str, Any]] = []
    try:
        for iteration in range(1, args.restart_count + 1):
            result = run_once(
                args.ssh_host,
                args.agent_host,
                args.remote_root,
                port=args.port,
                size=args.size,
                rate=args.rate,
                timeout=args.timeout,
                startup_timeout=args.startup_timeout,
                frames=args.frames_per_restart,
            )
            result["iteration"] = iteration
            results.append(result)
            print("S3B_RESTART=" + json.dumps(result, sort_keys=True), flush=True)
        if args.soak_seconds > 0:
            soak_frames = max(1, math.ceil(args.soak_seconds * args.rate))
            result = run_once(
                args.ssh_host,
                args.agent_host,
                args.remote_root,
                port=args.port,
                size=args.size,
                rate=args.rate,
                timeout=args.timeout,
                startup_timeout=args.startup_timeout,
                frames=soak_frames,
            )
            result["requested_seconds"] = args.soak_seconds
            result["requested_frames"] = soak_frames
            print("S3B_SOAK=" + json.dumps(result, sort_keys=True), flush=True)
    except (OSError, RuntimeError, TimeoutError, subprocess.SubprocessError) as error:
        print(f"S3B_ACCEPTANCE_STATUS=FAIL error={type(error).__name__}: {error}")
        raise SystemExit(1) from error
    print(f"S3B_ACCEPTANCE_STATUS=PASS restarts={len(results)}", flush=True)


if __name__ == "__main__":
    main()