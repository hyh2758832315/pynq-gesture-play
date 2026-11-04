"""Optional PC game-provider/hand integration test; never starts the Agent."""
import argparse
import hashlib
import io
import json
from pathlib import Path
import socket
import sys
import unittest
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[1]
REPO = ROOT.parents[1]
sys.path.insert(0, str(ROOT / "src"))


def main(output):
    if output.exists() or output.with_suffix(".log").exists():
        raise FileExistsError(output)
    import serial
    log = io.StringIO()
    with patch.object(serial.Serial, "open", side_effect=AssertionError("SERIAL_FORBIDDEN")) as opened, \
            patch.object(socket.socket, "connect", side_effect=AssertionError("NETWORK_FORBIDDEN")):
        suite = unittest.defaultTestLoader.discover(str(ROOT / "integration"))
        result = unittest.TextTestRunner(stream=log, verbosity=2).run(suite)
    output.parent.mkdir(parents=True, exist_ok=True)
    output.with_suffix(".log").write_text(log.getvalue(), encoding="utf-8")
    if not result.wasSuccessful() or result.testsRun == 0 or result.skipped:
        raise AssertionError(log.getvalue())
    files = [ROOT / "src/pynq_usb_hand/gesture_consumer.py", ROOT / "integration/test_game_observation.py",
             REPO / "python/pynq_multimodal_game/vision_input.py", REPO / "python/pynq_multimodal_game/game_sdk.py",
             REPO / "python/pynq_multimodal_game/studio/vision_receiver.py"]
    report = {"result": "PASSIVE_GAME_OBSERVATION_PASS", "tests_run": result.testsRun,
              "hardware_tested": False, "serial_open_calls": opened.call_count,
              "main_project_modified": False, "runtime_hook_installed": False,
              "source_sha256": {str(path.relative_to(REPO)).replace('\\', '/'): hashlib.sha256(path.read_bytes()).hexdigest() for path in files}}
    with output.open("x", encoding="utf-8") as stream:
        json.dump(report, stream, indent=2)
        stream.write("\n")
    print(report["result"])


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    main(parser.parse_args().output)
