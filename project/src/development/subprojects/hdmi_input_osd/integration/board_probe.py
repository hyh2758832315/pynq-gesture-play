"""Read-only board identity/owner probe; never imports PYNQ or writes MMIO."""
from __future__ import annotations

import argparse
import ast
import json
from pathlib import Path
import runpy
import subprocess


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    repo = Path(__file__).resolve().parents[3]
    args.output.parent.mkdir(parents=True, exist_ok=True)
    if args.output.exists():
        raise FileExistsError(args.output)
    previous = runpy.run_path(str(repo / "results/game-validation/vision-gpu-v0-board-20261022/workflow.py"))
    prefix = "import contextlib, io, json, pathlib\nbuffer=io.StringIO()\nwith contextlib.redirect_stdout(buffer):\n    exec(compile(" + repr(previous["INSPECT"]) + ", '<readonly>', 'exec'), {})\nstate=json.loads(buffer.getvalue())\n"
    source = prefix + r'''
board_root=pathlib.Path('/home/xilinx/voice-view-game/c6i-vision-volume-c0c-r15-unified-input-20261022-r2')
log_root=board_root/'var/unified-live-20261022-r2'
for key,path in [('service_start',log_root/'service-start.json'),('service_exit',log_root/'service-exit.json'),
                 ('volume_journal',pathlib.Path('/var/lock/voice-view-c6i-volume-owner.json'))]:
    state[key]=json.loads(path.read_text()) if path.exists() else None
for key,name in [('stdout_tail','stdout.log'),('stderr_tail','stderr.log')]:
    path=log_root/name
    state[key]=path.read_text(errors='replace')[-5000:] if path.exists() else None
state['board_root']=str(board_root)
print(json.dumps(state),flush=True)
'''
    ast.parse(source, feature_version=(3, 10))
    command = previous["SSH"] + ["sudo -n /usr/local/share/pynq-venv/bin/python -B -"]
    try:
        process = subprocess.run(command, input=source, text=True, encoding="utf-8", errors="replace",
                                 capture_output=True, timeout=45)
        receipt = {"command": command, "remote_code": source, "returncode": process.returncode,
                   "stdout": process.stdout, "stderr": process.stderr, "hardware_access": False}
    except subprocess.TimeoutExpired as error:
        receipt = {"command": command, "remote_code": source, "returncode": None,
                   "error": str(error), "hardware_access": False}
    with args.output.open("x", encoding="utf-8") as stream:
        json.dump(receipt, stream, indent=2)
    if receipt["returncode"] != 0:
        raise RuntimeError(f"read-only board probe failed; preserve {args.output}")
    state = json.loads(receipt["stdout"])
    print(json.dumps({"boot_id": state["boot_id"], "service_start": state["service_start"],
                      "service_exit": state["service_exit"], "mapper_count": len(state["hardware_mappers"]),
                      "journal_state": None if state["volume_journal"] is None else state["volume_journal"]["state"]}))


if __name__ == "__main__":
    main()
