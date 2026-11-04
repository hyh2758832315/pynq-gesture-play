"""Prepare an isolated, not-yet-deployable R19 software candidate from frozen R18.

Run: .venv/Scripts/python.exe -B subprojects/hdmi_input_osd/integration/prepare_latency_latest.py
Output: deliveries/c6i-pl-vision-volume-osd-r19-latest-20261023 source tree.
Next: candidate runtime/lifecycle tests, freeze manifest/ZIP, ARM then board gates.
"""
import ast
import hashlib
import json
from pathlib import Path
import zipfile

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[2]
PARENT = REPO / 'deliveries/c6i-pl-vision-volume-osd-r18-prewarm-20261023.zip'
TARGET = REPO / 'deliveries/c6i-pl-vision-volume-osd-r19-latest-20261023'
PARENT_SHA = '7619be5d51043b3289906784c1d8add6d11601840c9897c462c5b9b27c097a8b'


def rewrite(path, old, new):
    source = path.read_text(encoding='utf-8-sig')
    assert source.count(old) == 1, (path, old)
    source = source.replace(old, new)
    ast.parse(source, filename=str(path), feature_version=(3, 10))
    path.write_text(source, encoding='utf-8', newline='\n')


def main():
    assert not TARGET.exists() and not TARGET.with_suffix('.zip').exists()
    assert hashlib.sha256(PARENT.read_bytes()).hexdigest() == PARENT_SHA
    with zipfile.ZipFile(PARENT) as archive:
        assert archive.testzip() is None and len(archive.namelist()) == 602
        for name in archive.namelist():
            assert name.startswith(PARENT.stem + '/')
            output = (TARGET / name[len(PARENT.stem) + 1:]).resolve()
            assert output.is_relative_to(TARGET)
            output.parent.mkdir(parents=True, exist_ok=True)
            with output.open('xb') as stream:
                stream.write(archive.read(name))
    manifest = json.loads((TARGET / 'deployment_manifest.json').read_text())
    for name, digest in manifest['sha256'].items():
        assert hashlib.sha256((TARGET / name).read_bytes()).hexdigest().upper() == digest
    marker = json.loads((TARGET / 'candidate_stage.json').read_text())
    marker.update(stage='SOURCE_ONLY_HARDWARE_PENDING', release_ready=False, board_pending=True,
                  immediate_parent_archive_sha256=PARENT_SHA,
                  warning='Latest-frame software candidate under test; manifest not frozen. Do not deploy.')
    (TARGET / 'candidate_stage.json').write_text(json.dumps(marker, indent=2) + '\n', encoding='utf-8')
    manifest['immediate_parent_archive_sha256'] = PARENT_SHA
    (TARGET / 'deployment_manifest.json').write_text(json.dumps(manifest, indent=2) + '\n', encoding='utf-8')
    source = HERE.parent / 'latency_runtime/vision_latest_capture.py'
    (TARGET / 'board/pynq_z2/vision_latest_capture.py').write_bytes(source.read_bytes())
    runtime = TARGET / 'board/pynq_z2/scripts/vision_async_runtime.py'
    rewrite(runtime, '        self.frame_processor = frame_processor\n',
            '        self.frame_processor = frame_processor\n        self.capture_validator = None\n')
    rewrite(runtime, "        if self.frame_processor is not None and raw.frame_id != self.frame_id + 1:\n"
                     "            raise RuntimeError('dual-mask worker frame identity is not consecutive')\n",
            "        capture = {}\n"
            "        if self.frame_processor is not None:\n"
            "            if self.capture_validator is not None:\n"
            "                capture = self.capture_validator(raw)\n"
            "            elif raw.frame_id != self.frame_id + 1:\n"
            "                raise RuntimeError('dual-mask worker frame identity is not consecutive')\n")
    rewrite(runtime, "                packet = dict(run_id=self.run_id, frame=self.frame_id, server_age_ms=0., control=control,\n",
            "                observed_ns = capture['ready_monotonic_ns'] if capture else None\n"
            "                age_ms = max(0., (time.monotonic_ns() - observed_ns) / 1e6) if capture else 0.\n"
            "                packet = dict(run_id=self.run_id, frame=self.frame_id, server_age_ms=age_ms, control=control,\n")
    rewrite(runtime, '                self.input_provider.publish(packet, config_epoch=self.config_epoch)\n',
            "                if capture:\n                    packet['capture'] = dict(capture)\n"
            '                self.input_provider.publish(packet, config_epoch=self.config_epoch)\n')
    rewrite(runtime, '                             frame_id=self.frame_id, observed_ns=time.monotonic_ns())\n',
            '                             frame_id=self.frame_id, observed_ns=observed_ns if capture else time.monotonic_ns())\n')
    rewrite(runtime, "                    sample['server_age_ms'] = ((time.monotonic()-published_at)*1000\n",
            "                    sample['server_age_ms'] = ((sample.get('server_age_ms') or 0.) + (time.monotonic()-published_at)*1000\n")
    factory = TARGET / 'python/pynq_multimodal_game/agent/pl_volume_factory.py'
    rewrite(factory, '    from gesture_control import GestureControl\n',
            '    from gesture_control import GestureControl\n'
            '    from board.pynq_z2.vision_latest_capture import LatestCaptureHardware\n')
    rewrite(factory, '    worker=runtime.SharedDualMaskWorker(hardware,recognizer,GestureControl(),provider,\n',
            '    hardware=LatestCaptureHardware(hardware)\n'
            '    worker=runtime.SharedDualMaskWorker(hardware,recognizer,GestureControl(),provider,\n')
    rewrite(factory, '    worker.osd_observer=osd_hub.publish\n',
            '    worker.capture_validator=hardware.accept_delivery\n'
            '    worker.capture_snapshot=hardware.snapshot\n    worker.osd_observer=osd_hub.publish\n')
    backend = TARGET / 'python/pynq_multimodal_game/agent/vision_backend.py'
    rewrite(backend, '                "input_capabilities": self.input_provider.capabilities,\n',
            '                "input_capabilities": self.input_provider.capabilities,\n'
            '                "capture": (worker.capture_snapshot() if worker is not None\n'
            '                            and callable(getattr(worker, "capture_snapshot", None)) else None),\n')
    print('SOURCE_ONLY_NOT_DEPLOYABLE', TARGET)


if __name__ == '__main__':
    main()
