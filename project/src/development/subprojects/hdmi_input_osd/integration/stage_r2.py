"""Create a new software-only child of sealed first C0D; hardware unchanged.

Run: .venv/Scripts/python.exe -B .../stage_r2.py
Output: deliveries/c6i-vision-volume-osd-r16-20261023-r2, evidence/g24-r2-source.json.
Next: scoped local/ARM tests, seal a new identity, normal owner-bound deployment.
"""
import ast
import hashlib
import json
from pathlib import Path
import zipfile

HERE=Path(__file__).resolve().parent
REPO=HERE.parents[2]
R2=REPO/'deliveries/c6i-vision-volume-osd-r16-20261023-r2'


def main():
    expected='2e49d7fc2cb1f60a89ffd69b6d9510278d99897bdc06d609604f581e5a8fbb67'
    parent=REPO/'deliveries/c6i-vision-volume-osd-r16-20261022.zip'
    assert hashlib.sha256(parent.read_bytes()).hexdigest()==expected
    if R2.exists(): raise FileExistsError(R2)
    R2.mkdir()
    with zipfile.ZipFile(parent) as archive:
        assert archive.testzip() is None
        marker=next(n for n in archive.namelist() if n.endswith('/deployment_manifest.json'))
        prefix=marker[:-len('deployment_manifest.json')]
        manifest=json.loads(archive.read(marker))
        for name,digest in manifest['sha256'].items():
            data=archive.read(prefix+name)
            assert hashlib.sha256(data).hexdigest().upper()==digest
            path=(R2/name).resolve()
            assert path.is_relative_to(R2)
            path.parent.mkdir(parents=True,exist_ok=True)
            path.write_bytes(data)
        (R2/'deployment_manifest.json').write_bytes(archive.read(marker))
    pkg=R2/'python/pynq_multimodal_game'
    changes={}
    for source,target in ((HERE/'runtime_osd.py',pkg/'input_osd.py'),
                          (HERE/'osd_backend.py',pkg/'agent/osd_backend.py'),
                          (HERE/'osd_registers.py',pkg/'osd_registers.py'),
                          (HERE/'test_runtime_osd.py',R2/'tools/osd_runtime_contract.py')):
        changes[target]=source.read_bytes()
    publisher=pkg/'osd_publisher.py'
    text=publisher.read_text(encoding='utf-8').replace('\r\n','\n')
    old='        for index, value in enumerate(words):\n            self.io.write(0x10 + 4 * index, value)'
    assert text.count(old)==1
    text=text.replace(old,'        bulk = getattr(self.io, "write_shadow", None)\n        if bulk is not None:\n            bulk(words)\n        else:\n            for index, value in enumerate(words):\n                self.io.write(0x10 + 4 * index, value)')
    changes[publisher]=text.encode()
    core=pkg/'agent/core.py'
    text=core.read_text(encoding='utf-8').replace('\r\n','\n')
    old='    INPUT_OSD_TEST = "input_osd_test"'
    assert text.count(old)==1
    text=text.replace(old,old+'\n    INPUT_OSD_PROBE = "input_osd_probe"')
    old='            elif command in (AgentCommand.INPUT_OSD_SET, AgentCommand.INPUT_OSD_TEST):'
    assert text.count(old)==1
    text=text.replace(old,'            elif command is AgentCommand.INPUT_OSD_PROBE:\n                method = getattr(self._backend, "probe_input_osd", None)\n                if method is None:\n                    raise RuntimeError("runtime does not support HDMI OSD probe")\n                snapshot = method(payload)\n'+old)
    changes[core]=text.encode()
    preview=pkg/'vision_preview.py'
    text=preview.read_text(encoding='utf-8').replace('\r\n','\n')
    replacements=[
        ('        if not self._closed and not self._stop.is_set():',
         '        if not self._closed and not self._stop.is_set() and self._cleanup != "STOPPING":'),
        ('            "CLOSED" if self._closed else "DEGRADED" if self._fatal_reason or (',
         '            "CLOSED" if self._closed else "STOPPING" if self._cleanup == "STOPPING" else "DEGRADED" if self._fatal_reason or ('),
        ('            if not self._stop.is_set():\n                self._fault(f"Preview relay transport failed: {type(error).__name__}: {error}")',
         '            if not self._stop.is_set() and not self._codec_stop.value:\n                self._fault(f"Preview relay transport failed: {type(error).__name__}: {error}")'),
        ('        self._stop.set()\n        self._codec_stop.value = True',
         '        # Keep the relay draining an in-flight encoded result while the codec\n        # observes its stop flag; stopping the reader first can fill the pipe.\n        self._codec_stop.value = True'),
        ('            self._process.join(1)\n        if self._thread.ident is not None:',
         '            self._process.join(1)\n        self._stop.set()\n        if self._thread.ident is not None:')]
    for old,new in replacements:
        assert text.count(old)==1,old
        text=text.replace(old,new)
    changes[preview]=text.encode()
    record=dict(status='R2_SOURCES_PATCHED_NOT_DEPLOYABLE',parent_sha256=expected,changes={},hardware_unchanged=True)
    for path,data in changes.items():
        ast.parse(data,filename=str(path),feature_version=(3,10))
        old=path.read_bytes() if path.exists() else None
        record['changes'][path.relative_to(R2).as_posix()]=dict(before=None if old is None else hashlib.sha256(old).hexdigest(),after=hashlib.sha256(data).hexdigest())
        path.write_bytes(data)
    for name,digest in manifest['sha256'].items():
        if name.startswith('overlay/'):
            assert hashlib.sha256((R2/name).read_bytes()).hexdigest().upper()==digest
    with (HERE/'evidence/g24-r2-source.json').open('x',encoding='utf-8') as output: json.dump(record,output,indent=2)
    print(record['status'],len(changes),'Python3.10 AST PASS; all overlay members unchanged')


if __name__=='__main__': main()
