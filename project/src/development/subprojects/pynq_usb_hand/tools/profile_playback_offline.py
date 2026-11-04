"""Local CPU evidence only. Never opens serial, sockets or board devices.

Run with this subproject's Python and --output <new.json>. Output includes
profiled initialization and unprofiled memory-SDK playback, never ARM estimates.
"""
import argparse
import cProfile
import hashlib
import json
from pathlib import Path
import platform
import pstats
import socket
import sys
import time
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "src"))
sys.path.insert(0, str(ROOT / "tests"))


def measure(call):
    wall, cpu = time.perf_counter(), time.process_time()
    result = call()
    return result, {"wall_seconds": time.perf_counter() - wall, "cpu_seconds": time.process_time() - cpu}


def main(output):
    if output.exists():
        raise FileExistsError(output)
    import serial
    from pynq_usb_hand.assets import verify_frozen
    from pynq_usb_hand.motion import Cancellation, Motion, MotionSettings
    from pynq_usb_hand.orca_backend import OrcaModel
    from memory_hand import MemoryHand

    with patch.object(serial.Serial, "open", side_effect=AssertionError("SERIAL_OPEN_FORBIDDEN")) as serial_open, \
            patch.object(socket.socket, "connect", side_effect=AssertionError("NETWORK_FORBIDDEN")):
        manifest, hashes = measure(lambda: verify_frozen(ROOT))
        profiler = cProfile.Profile()
        profiler.enable()
        model, initialization = measure(lambda: OrcaModel(ROOT))
        profiler.disable()
        stats = pstats.Stats(profiler)
        hotspots = [{"file": key[0], "line": key[1], "function": key[2], "calls": value[1],
                     "self_elapsed_seconds": value[2], "cumulative_elapsed_seconds": value[3]}
                    for key, value in sorted(stats.stats.items(), key=lambda row: row[1][3], reverse=True)[:20]]
        backend = MemoryHand(model)
        motion, preparation = measure(lambda: Motion(backend, MotionSettings.fixed_playback(stage_waits=(0.1, 0.2, 0.3))))
        cancel = Cancellation(time.monotonic() + 60)
        backend.connect(cancel)
        backend.arm(cancel)
        backend.packets.clear()
        counts = {"plays": 0, "position_writes": 0, "register_reads": 0}

        def plays():
            for _ in range(2500):
                for state in ("default", "paper", "scissors", "rock"):
                    motion.run(state, cancel)
                    counts["plays"] += 1
                    counts["position_writes"] += sum(p[4] == 3 for _, p in backend.packets)
                    counts["register_reads"] += sum(p[4] == 2 for _, p in backend.packets)
                    backend.packets.clear()

        try:
            # No real wait: measure Python + SDK + ideal responder CPU work only.
            with patch.object(cancel, "wait", side_effect=lambda duration: cancel.check()):
                _, playback = measure(plays)
            if counts["register_reads"] or backend.responses:
                raise AssertionError("Unexpected READ or unconsumed ACK")
        finally:
            failed = backend.release()
            backend.close()
        if failed or any(backend.torque.values()) or not backend.closed:
            raise AssertionError("Simulated cleanup failed")
        report = {"result": "OFFLINE_CPU_PROFILE_PASS", "platform": platform.platform(), "python": sys.version,
                  "hardware_tested": False, "serial_open_calls": serial_open.call_count,
                  "frozen_files": len(manifest["sha256"]), "standalone_hash_verification": hashes,
                  "model_initialization_profiled": initialization, "initialization_hotspots": hotspots,
                  "profile_timer": "cProfile default elapsed time; cumulative rows overlap, do not add",
                  "route_preparation": preparation, "unique_compiled_targets": len({id(target) for route in motion.playback_routes.values() for _, target, _ in route}),
                  "route_stages": sum(map(len, motion.playback_routes.values())),
                  "memory_sdk_playback_unprofiled": {**playback, **counts},
                  "limits": "PC process CPU only. Ideal memory servo, no physical delays, no ARM/USB/thermal/100ms peak claims.",
                  "source_sha256": {str(path.relative_to(ROOT)).replace('\\', '/'): hashlib.sha256(path.read_bytes()).hexdigest()
                                    for folder in ("src", "tests", "tools") for path in (ROOT / folder).rglob("*.py")}}
    output.parent.mkdir(parents=True, exist_ok=True)
    with output.open("x", encoding="utf-8") as stream:
        json.dump(report, stream, indent=2)
        stream.write("\n")
    print(json.dumps({k: report[k] for k in ("result", "serial_open_calls", "unique_compiled_targets", "memory_sdk_playback_unprofiled")}))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    main(parser.parse_args().output)
