"""Read-only board inventory; run with remote.py; output a03; next verify package.
No register access, downloads, serial opens, process or service changes.
"""
import hashlib
import json
import pathlib
import subprocess
from importlib.metadata import distribution

assert pathlib.Path('/proc/sys/kernel/random/boot_id').read_text().strip() == '15a410e0-d375-45ef-8d01-7b9a02e21a8e'
root = pathlib.Path('/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r21-marker-r02-20261023')
manifest = json.loads((root/'deployment_manifest.json').read_text())
for name, digest in manifest['sha256'].items():
    path = (root/name).resolve()
    assert path.is_relative_to(root) and hashlib.sha256(path.read_bytes()).hexdigest().upper() == digest, name
pynq = pathlib.Path(distribution('pynq').locate_file('pynq'))
sources = {}
for name in ('overlay.py', 'bitstream.py', 'pl_server/embedded_device.py', 'pl_server/xrt_device.py'):
    sources[name] = (pynq/name).read_text()
usb = pathlib.Path('/dev/serial/by-id')
state = dict(package_count=len(manifest['sha256']), bit_sha256=hashlib.sha256((root/'overlay/c6v_candidate.bit').read_bytes()).hexdigest(),
             markers={str(p):p.read_text() for p in pathlib.Path('/run/lock').glob('vision-v0-base-normal-stop-*')},
             usb={p.name:str(p.resolve()) for p in usb.glob('*')} if usb.exists() else {},
             sources=sources, kernel=subprocess.run(['dmesg','--color=never'], capture_output=True,text=True,check=True).stdout[-6000:])
print(json.dumps(state), flush=True)
