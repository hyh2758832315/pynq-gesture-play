"""Apply audited child-only OSD patches. Run once after stage_runtime.py.

Run: python -B subprojects/hdmi_input_osd/integration/patch_runtime.py
Output: child sources + evidence/g05-runtime-patch.json (NOT a deployment).
Next: private tests, paired hardware export, regenerate manifest and preflight.
"""
import ast
import hashlib
import json
from pathlib import Path


def main():
    here = Path(__file__).resolve().parent
    repo = here.parents[2]
    root = repo / "deliveries/c6i-vision-volume-osd-r16-20261022"
    receipt = here / "evidence/g05-runtime-patch.json"
    if receipt.exists():
        raise FileExistsError(receipt)
    manifest = json.loads((root / "deployment_manifest.json").read_text(encoding="utf-8"))
    before, changes = {}, {}
    for name, digest in manifest["sha256"].items():
        data = (root / name).read_bytes()
        if hashlib.sha256(data).hexdigest().upper() != digest:
            raise ValueError("not the audited r15 copy: " + name)
        before[name] = data
        # This is a C0D-only child distribution, including its paired Studio.
        # Historical bringup records and immutable VVGs remain untouched.
        if name.endswith(".py") and b"C0060C00" in data:
            changes[name] = data.replace(b"C0060C00", b"C0060D00")

    def patch(name, old, new):
        text = changes.get(name, before[name]).decode("utf-8").replace("\r\n", "\n")
        if text.count(old) != 1:
            raise ValueError(f"ambiguous patch {name}: {old[:65]!r}")
        changes[name] = text.replace(old, new).encode("utf-8")

    pkg = "python/pynq_multimodal_game/"
    cli = pkg + "agent/cli.py"
    patch(cli, '    provider = GameVisionInputProvider() if args.vision_game_input else VisionInputProvider()',
          '    from ..input_osd import ObservationHub\n    osd_hub = ObservationHub()\n    provider = GameVisionInputProvider() if args.vision_game_input else VisionInputProvider()')
    patch(cli, '        return runtime.SharedVisionWorker(', '        worker = runtime.SharedVisionWorker(')
    patch(cli, '                                          run_dir=args.vision_output_dir / run_id)',
          '                                          run_dir=args.vision_output_dir / run_id)\n        if fusion_volume:\n            worker.osd_observer = osd_hub.publish\n        return worker')
    patch(cli, '        backend_type = C6IVolumeRuntimeBackend',
          '        from .osd_backend import C6IOsdRuntimeBackend\n        backend_type = C6IOsdRuntimeBackend\n        voice_options["osd_hub"] = osd_hub\n        voice_options["osd_allow_test"] = args.osd_test_stimuli')
    patch(cli, '    parser.add_argument("--build-id", type=_base_zero_int, default=0xC0060700)',
          '    parser.add_argument("--osd-test-stimuli", action="store_true", help="Enable bounded OSD-only fixtures; no gameplay injection")\n    parser.add_argument("--build-id", type=_base_zero_int, default=0xC0060700)')
    patch(cli, '    if args.vision_game_input and args.backend not in',
          '    if args.osd_test_stimuli and args.backend != "c6i-vision-volume":\n        parser.error("OSD fixtures require the C0D volume backend")\n    if args.vision_game_input and args.backend not in')

    scripts = "board/pynq_z2/scripts/"
    patch(scripts + "vision_async_runtime.py",
          '                self.input_provider.publish(packet, config_epoch=self.config_epoch)',
          '                self.input_provider.publish(packet, config_epoch=self.config_epoch)\n                observer = getattr(self, "osd_observer", None)\n                if observer is not None:\n                    observer(observed, run_id=self.run_id, config_epoch=self.config_epoch,\n                             frame_id=self.frame_id, observed_ns=time.monotonic_ns())')
    patch(scripts + "voice_volume_runtime.py", '    def read(self):\n        if not self.lock.acquire(False):',
          '''    def read_observation(self):
        # Read only header/error under the existing nonblocking publication lock.
        # No diagnostics copy, MMIO, ACK, IPC or event latch consumption.
        if not self.lock.acquire(False):
            return None
        try:
            payload = bytes(memoryview(self.storage).cast("B")[:HEADER.size + 512])
        finally:
            self.lock.release()
        magic, version, producer, *words = HEADER.unpack_from(payload)
        if magic == 0:
            return None
        if magic != 0x56564131 or version != 1 or producer.hex() != self.producer_run:
            raise VolumeFault("invalid volume observation page identity")
        return {**dict(zip(FIELDS, words)), "producer_run": producer.hex(),
                "error": payload[HEADER.size:].rstrip(b"\\0").decode("utf-8", errors="replace") or None}

    def read(self):
        if not self.lock.acquire(False):''')
    patch(scripts + "voice_volume_fusion.py", '    def status(self):',
          '    @property\n    def osd_thresholds(self):\n        return self._sums["soft_sum"] / 977, self._sums["loud_sum"] / 977\n\n    def read_observation(self):\n        return None if self._worker is None else self._worker.page.read_observation()\n\n    def status(self):')
    patch(scripts + "verify_vision_integration_sources.py",
          '        expected_parameters = {\n            "gp0_smc": {"NUM_MI": "31"},',
          '        if (ranges.get("input_osd_0") != (0x43C20000, 0x43C20FFF)\n                or modules["input_osd_0"].get("MODTYPE") != "input_osd_axi"):\n            raise ValueError("Candidate OSD module or address mismatch")\n        expected_parameters = {\n            "vision_control_smc": {"NUM_MI": "6"},\n            "gp0_smc": {"NUM_MI": "31"},')
    core = pkg + "agent/core.py"
    patch(core, '    VISION_STATUS = "vision_status"',
          '    INPUT_OSD_SET = "input_osd_set"\n    INPUT_OSD_TEST = "input_osd_test"\n    VISION_STATUS = "vision_status"')
    patch(core, '            elif command is AgentCommand.STAGE:',
          '            elif command in (AgentCommand.INPUT_OSD_SET, AgentCommand.INPUT_OSD_TEST):\n                method = getattr(self._backend, "set_input_osd" if command is AgentCommand.INPUT_OSD_SET else "test_input_osd", None)\n                if method is None:\n                    raise RuntimeError("runtime does not support HDMI OSD")\n                snapshot = method(payload)\n            elif command is AgentCommand.STAGE:')
    patch("start_board_test.py", '    parser.add_argument("--check-only", action="store_true")',
          '    parser.add_argument("--osd-test-stimuli", action="store_true")\n    parser.add_argument("--check-only", action="store_true")')
    patch("start_board_test.py", '    if check_only:\n        arguments.append("--vision-check-only")',
          '    if options.osd_test_stimuli:\n        arguments.append("--osd-test-stimuli")\n    if check_only:\n        arguments.append("--vision-check-only")')
    publisher = (here.parent / "osd_publisher.py").read_text(encoding="utf-8")
    publisher = publisher.replace('        self.commits = self.busy_skips = 0', '        self.commits = self.busy_skips = 0\n        self.last_words = None')
    publisher = publisher.replace('        self.commits += 1', '        self.last_words = words\n        self.commits += 1')
    changes[pkg + "osd_publisher.py"] = publisher.encode("utf-8")
    changes[pkg + "input_osd.py"] = (here / "runtime_osd.py").read_bytes()
    changes[pkg + "agent/osd_backend.py"] = (here / "osd_backend.py").read_bytes()
    for name, data in changes.items():
        ast.parse(data, filename=name, feature_version=(3, 10))
    for name, data in changes.items():
        path = root / name
        if name not in before and path.exists():
            raise FileExistsError(path)
    for name, data in changes.items():
        (root / name).write_bytes(data)
    audit = {"status": "SOURCES_PATCHED_NOT_DEPLOYABLE", "build_id": "0xC0060D00",
             "changes": {name: {"before": None if name not in before else hashlib.sha256(before[name]).hexdigest(),
                                  "after": hashlib.sha256(data).hexdigest()} for name, data in changes.items()},
             "hardware_pending": True, "vvg_retarget_pending": True,
             "manifest_pending": True, "board_access": False}
    with receipt.open("x", encoding="utf-8") as stream:
        json.dump(audit, stream, indent=2)
    print("R16_CHILD_SOURCE_PATCH_PASS", len(changes), "Python3.10 AST PASS")


if __name__ == "__main__":
    main()
