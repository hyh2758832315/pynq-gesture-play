"""Repeatable child-source tests; own logs, copied identity test, no board IO.

Run: python -B .../run_local_validation.py --output .../evidence/g08-r02.json
Outputs: exclusive JSON, full stdout/stderr, private pytest temporary files.
Next: examine all results; hardware and board gates remain independent.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--child", type=Path)
    args = parser.parse_args()
    repo = Path(__file__).resolve().parents[3]
    output = args.output.resolve()
    work = output.with_suffix("")
    if output.exists() or work.exists():
        raise FileExistsError("preserve previous receipt")
    work.mkdir()
    child = args.child.resolve() if args.child is not None else repo / "deliveries/c6i-vision-volume-osd-r16-20261022"
    source = repo / "tests/test_agent_transport.py"
    copied = work / source.name
    data = source.read_text(encoding="utf-8").replace("0xC0060C00", "0xC0060D00")
    data = data.replace('Path(__file__).resolve().parents[1]', repr(str(repo)))
    data = data.replace('root = ' + repr(str(repo)), 'root = Path(' + repr(str(repo)) + ')')
    copied.write_text(data, encoding="utf-8")
    env = {**os.environ, "PYTHONPATH": os.pathsep.join((str(child / "python"), str(repo / "subprojects/hdmi_input_osd"))), "PYTHONDONTWRITEBYTECODE": "1",
           "PYTHONIOENCODING": "utf-8", "VVG_OSD_TEST_ROOT": str(child)}
    record = {"status": "RUNNING", "child": str(child), "board_access": False,
              "copied_transport_test_sha256": hashlib.sha256(copied.read_bytes()).hexdigest(),
              "original_transport_test_sha256": hashlib.sha256(source.read_bytes()).hexdigest(), "runs": []}
    commands = [
        [sys.executable, "-B", str(Path(__file__).with_name("test_runtime_osd.py"))],
        [sys.executable, "-B", "-m", "unittest", "discover", "-s", str(repo / "subprojects/hdmi_input_osd/tests"), "-v"],
        [sys.executable, "-B", "-m", "pytest", "-q", "-p", "no:cacheprovider", "--basetemp", str(work / "tmp"),
         str(copied), "tests/test_multimodal_input.py", "tests/test_vision_receiver.py",
         "tests/test_vision_preview.py",
         str(Path(__file__).with_name("test_preview_shutdown.py"))],
    ]
    try:
        for index, command in enumerate(commands):
            result = subprocess.run(command, cwd=repo, env=env, text=True, encoding="utf-8", errors="replace", capture_output=True)
            log = work / f"{index:02d}.log"
            log.write_text(result.stdout + result.stderr, encoding="utf-8")
            record["runs"].append(dict(command=command, returncode=result.returncode,
                log=str(log), sha256=hashlib.sha256(log.read_bytes()).hexdigest()))
            print(f"LOCAL_SUITE {index} returncode={result.returncode}", flush=True)
        record["status"] = "PASS" if all(r["returncode"] == 0 for r in record["runs"]) else "FAIL"
    finally:
        with output.open("x", encoding="utf-8") as stream:
            json.dump(record, stream, indent=2)
    if record["status"] != "PASS":
        raise SystemExit(1)


if __name__ == "__main__":
    main()
