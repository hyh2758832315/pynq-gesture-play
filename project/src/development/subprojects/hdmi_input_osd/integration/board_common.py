"""Identity-bound helpers. No board operation occurs on import."""
import ast
import json
from pathlib import Path
import runpy
import subprocess
import time

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[2]
CHILD = REPO / "deliveries/c6i-vision-volume-osd-r16-20261022"
BOARD = "/home/xilinx/voice-view-game/c6i-vision-volume-osd-r16-20261022"
OLD = "/home/xilinx/voice-view-game/c6i-vision-volume-c0c-r15-unified-input-20261022-r2"
OLD_LOG = "var/unified-live-20261022-r2"
LOG = "var/osd-live-r01"
SSH = ["ssh", "-b", "192.168.2.1", "-o", "BatchMode=yes", "-o", "ConnectTimeout=8", "pynq-z2"]


def save(name, value):
    path = HERE / "evidence" / (name + ".json")
    with path.open("x", encoding="utf-8") as stream:
        json.dump(value, stream, indent=2, allow_nan=False)
    return value


def load(name):
    return json.loads((HERE / "evidence" / (name + ".json")).read_text(encoding="utf-8"))


def remote(name, source, *, timeout=60, hardware_access=False):
    destination = HERE / "evidence" / (name + ".json")
    if destination.exists():
        raise FileExistsError(destination)
    ast.parse(source, feature_version=(3, 10))
    command = SSH + ["sudo -n /usr/local/share/pynq-venv/bin/python -B -"]
    started = time.time()
    receipt = dict(command=command, remote_code=source, hardware_access=hardware_access,
                   started_unix=started, returncode=None)
    try:
        result = subprocess.run(command, input=source, capture_output=True, text=True,
                                encoding="utf-8", errors="replace", timeout=timeout)
        receipt.update(returncode=result.returncode, stdout=result.stdout, stderr=result.stderr)
    except BaseException as error:
        receipt["error"] = f"{type(error).__name__}: {error}"
        raise
    finally:
        receipt["elapsed_seconds"] = time.time() - started
        save(name, receipt)
    if result.returncode != 0:
        raise RuntimeError(f"remote failed ({result.returncode}); preserve {destination}")
    print(name + " PASS", flush=True)
    return receipt


def inspect_source(*, current=OLD, log=OLD_LOG):
    functions = runpy.run_path(str(REPO / "results/game-validation/vision-gpu-v0-board-20261022/workflow.py"))
    source = "import contextlib, io, json, pathlib\nbuffer=io.StringIO()\nwith contextlib.redirect_stdout(buffer):\n    exec(compile(" + repr(functions["INSPECT"]) + ", '<readonly>', 'exec'), {})\nstate=json.loads(buffer.getvalue())\n"
    source += f"root=pathlib.Path({current!r}) / {log!r}\n"
    source += '''for key,path in [('service_start',root/'service-start.json'),('service_exit',root/'service-exit.json'),
                 ('volume_journal',pathlib.Path('/var/lock/voice-view-c6i-volume-owner.json'))]:
    state[key]=json.loads(path.read_text()) if path.exists() else None
for key,name in [('stdout_tail','stdout.log'),('stderr_tail','stderr.log')]:
    path=root/name
    state[key]=path.read_text(errors='replace')[-12000:] if path.exists() else None
print(json.dumps(state),flush=True)
'''
    return source
