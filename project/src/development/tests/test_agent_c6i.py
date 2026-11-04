from __future__ import annotations


def test_native_game_controls_require_explicit_fusion_opt_in(tmp_path, monkeypatch):
    import pytest
    from unittest.mock import MagicMock
    from pynq_multimodal_game.agent import cli

    assert not cli.build_parser().parse_args([]).vision_game_input
    for backend in ("mock", "c6i-shell", "c6i-video", "vision-only"):
        with pytest.raises(SystemExit) as error:
            cli.main(["--backend", backend, "--vision-game-input"])
        assert error.value.code == 2
    monkeypatch.setattr(cli.sys, "platform", "linux")
    monkeypatch.setattr(cli.os, "geteuid", lambda: 0, raising=False)
    monkeypatch.setattr(cli, "C6IOverlaySession", MagicMock())
    monkeypatch.setattr(cli, "C6IVisionRuntimeBackend", MagicMock())
    old_provider, game_provider = MagicMock(), MagicMock()
    monkeypatch.setattr(cli, "VisionInputProvider", old_provider)
    monkeypatch.setattr(cli, "GameVisionInputProvider", game_provider)
    arguments = ["--backend", "c6i-vision", "--library-root", str(tmp_path / "library")]
    cli._create_shared_vision_backend(cli.build_parser().parse_args(arguments))
    old_provider.assert_called_once_with()
    game_provider.assert_not_called()
    cli._create_shared_vision_backend(cli.build_parser().parse_args(arguments + ["--vision-game-input"]))
    game_provider.assert_called_once_with()


def test_native_deployment_rejects_invalid_extra_games_before_writing(tmp_path, monkeypatch):
    import importlib
    from pathlib import Path
    from types import SimpleNamespace
    import pytest
    from pynq_multimodal_game import game_validation
    from pynq_multimodal_game.game_testing import GameTestCase

    monkeypatch.syspath_prepend(str(Path(__file__).resolve().parents[1] / "board/pynq_z2/scripts"))
    prepare = importlib.import_module("prepare_c6i_vision_board_test")
    monkeypatch.setattr(prepare, "verify_candidate_bundle", lambda _path: {})
    monkeypatch.setattr(prepare, "verify_sources", lambda *_args: None)
    monkeypatch.setattr(prepare.subprocess, "run", lambda *_args, **_kwargs: None)
    for fault in ("no_assertions", "failed_golden", "wrong_target", "duplicate"):
        cases = iter((SimpleNamespace(assertions=[True]),
                      SimpleNamespace(assertions=[] if fault == "no_assertions" else [True])))
        first = SimpleNamespace(passed=True, package=SimpleNamespace(manifest=SimpleNamespace(
            game_id="game1", target_build_id=0xC0060800)))
        second = SimpleNamespace(passed=fault != "failed_golden", package=SimpleNamespace(manifest=SimpleNamespace(
            game_id="game1" if fault == "duplicate" else "game2",
            target_build_id=0xC0060700 if fault == "wrong_target" else 0xC0060800)))
        reports = iter((first, second))
        monkeypatch.setattr(GameTestCase, "load", lambda _path: next(cases))
        monkeypatch.setattr(game_validation, "run_game_test", lambda *_args: next(reports))
        output = tmp_path / fault
        with pytest.raises(ValueError, match="Unique fusion games"):
            prepare.prepare(tmp_path, tmp_path / "candidate", tmp_path / "first.vvg", tmp_path / "first.json",
                            output, additional_games=((tmp_path / "extra.vvg", tmp_path / "extra.json"),))
        assert not output.exists() and not output.with_name(output.name + ".zip").exists()


def test_shared_overlay_borrowers_block_owner_close_and_limit_ip_access(tmp_path):
    from types import SimpleNamespace
    from pynq_multimodal_game.agent.c6i_backend import C6IOverlaySession

    session = C6IOverlaySession(tmp_path / "fusion.bit", require_root=False,
                                mmio_factory=lambda *args: args, allocate=lambda **kwargs: kwargs)
    session._overlay = SimpleNamespace(ip_dict={"moments_dma": {"phys_addr": 0x41000000, "addr_range": 0x10000}},
                                       moments_dma=object(), axi_dma=object())
    vision = session.borrow("vision", instances=frozenset({"moments_dma"}))
    gpu = session.borrow("GPU", instances=frozenset({"axi_dma"}))
    assert vision.moments_dma is session._overlay.moments_dma
    assert vision.mmio("moments_dma") == (0x41000000, 0x10000)
    assert vision.allocate(shape=(2,))["shape"] == (2,)
    with pytest.raises(ValueError, match="borrower contract"):
        vision.mmio("axi_dma")
    with pytest.raises(AttributeError, match="borrower contract"):
        getattr(vision, "download")
    with pytest.raises(RuntimeError, match="vision, GPU"):
        session.close()
    vision.close()
    with pytest.raises(RuntimeError, match="GPU"):
        session.close()
    with pytest.raises(RuntimeError, match="borrower is closed"):
        vision.allocate(shape=(1,))
    gpu.close()
    session.close()
    assert not session.is_open


from pathlib import Path
from types import SimpleNamespace
import threading
from typing import Any

import pytest

from pynq_multimodal_game.agent import cli
from pynq_multimodal_game import streaming


def test_volume_process_guard_requires_disable_and_exit_before_release(tmp_path):
    from pynq_multimodal_game.agent.c6i_backend import C6IOverlaySession
    session = C6IOverlaySession(tmp_path / "fusion.bit", require_root=False,
                                lock_path=tmp_path / "owner.lock",
                                expected_build_id=0xC0060C00)
    session._overlay = SimpleNamespace()
    session._volume_guard = {"schema": "c6i-volume-owner-v1", "state": "ACTIVE",
                             "producer_run": "a" * 32}
    volume = session.borrow("voice-volume", instances=frozenset({"voice_volume_0"}))
    gpu = session.borrow("GPU", instances=frozenset({"axi_dma"}))
    with pytest.raises(RuntimeError, match="cleanup unconfirmed"):
        volume.close()
    for disabled, exited, run in ((False, True, "a" * 32), (True, False, "a" * 32),
                                  (True, True, "b" * 32)):
        with pytest.raises(RuntimeError, match="confirmation required"):
            volume.confirm_process_stopped(run, disabled=disabled, exited=exited)
    volume.confirm_process_stopped("a" * 32, disabled=True, exited=True)
    volume.close()
    with pytest.raises(RuntimeError, match="GPU"):
        session.close()
    assert not session._volume_journal.exists()
    gpu.close()
    session.close()
    import json
    assert json.loads(session._volume_journal.read_text())["state"] == "CLEAN"


@pytest.mark.parametrize("state", ("ACTIVE", "RETAINED", "ORPHAN_RETAINED"))
def test_volume_unclean_journal_blocks_overlay_download(tmp_path, monkeypatch, state):
    import json
    from unittest.mock import MagicMock
    from pynq_multimodal_game.agent import c6i_backend
    bitstream = tmp_path / "fusion.bit"
    bitstream.write_bytes(b"fixture")
    bitstream.with_suffix(".hwh").write_text("<SYSTEM/>")
    session = c6i_backend.C6IOverlaySession(bitstream, lock_path=tmp_path / "owner.lock",
                                           require_root=False)
    session._volume_journal.write_text(json.dumps({"schema": "c6i-volume-owner-v1", "state": state}))
    factory = MagicMock()
    session._overlay_factory = factory
    monkeypatch.setattr(c6i_backend.importlib, "import_module", lambda _name: MagicMock())
    with pytest.raises(RuntimeError, match="unclean volume owner"):
        session.open()
    factory.assert_not_called()


@pytest.mark.parametrize("backend", ("c6i-vision", "c6i-voice-fusion", "c6i-vision-volume"))
@pytest.mark.parametrize("mode", (None, "validate", "performance"))
def test_shared_vision_skin_mode_reaches_worker(tmp_path, monkeypatch, backend, mode):
    from types import ModuleType
    from unittest.mock import MagicMock
    from pynq_multimodal_game.agent import voice_backend

    root = Path(cli.__file__).resolve().parents[3]
    runtime = ModuleType("vision_async_runtime")
    runtime.__file__ = str(root / "board/pynq_z2/scripts/vision_async_runtime.py")
    runtime.RUNTIME_DIR = root / "handoffs/gesture_vision_v61/runtime"
    recognizer = SimpleNamespace()
    runtime.FullFrameTracker = MagicMock(return_value=recognizer)
    runtime.SharedVisionHardware = MagicMock()
    runtime.SharedVisionWorker = MagicMock()
    runtime.prepare_skin_factory = MagicMock()
    camera = ModuleType("capture_camera_direct_plug")
    camera.__file__ = str(tmp_path / "capture_camera_direct_plug.py")
    monkeypatch.setitem(cli.sys.modules, runtime.__name__, runtime)
    monkeypatch.setitem(cli.sys.modules, camera.__name__, camera)
    for name, attributes in {
        "pynq": {}, "pynq.lib": {}, "pynq.lib.iic": {"AxiIIC": MagicMock()},
        "pynq.lib.video": {"VideoMode": MagicMock()}, "skin_dma": {"SkinDMA": MagicMock()},
        "gesture_control": {"GestureControl": MagicMock()},
    }.items():
        module = ModuleType(name)
        vars(module).update(attributes)
        monkeypatch.setitem(cli.sys.modules, name, module)
    monkeypatch.setattr(cli.sys, "platform", "linux")
    monkeypatch.setattr(cli.os, "geteuid", lambda: 0, raising=False)
    monkeypatch.setattr(cli, "C6IOverlaySession", MagicMock())
    monkeypatch.setattr(cli, "C6IVisionRuntimeBackend", MagicMock())
    monkeypatch.setattr(cli, "C6IVolumeRuntimeBackend", MagicMock())
    monkeypatch.setattr(voice_backend, "C6IVoiceFusionRuntimeBackend", MagicMock())
    for name in ("voice_volume_fusion", "voice_volume_board", "voice_volume_control"):
        module = ModuleType(name)
        module.__file__ = str(root / "board/pynq_z2/scripts" / (name + ".py"))
        if name == "voice_volume_fusion":
            module.BorrowedVolumeControl = MagicMock()
        monkeypatch.setitem(cli.sys.modules, name, module)
    supervisor = MagicMock()
    monkeypatch.setattr(cli, "SharedVisionSupervisor", supervisor)
    monkeypatch.setattr(cli.sys, "path", list(cli.sys.path))
    arguments = ["--backend", backend, "--library-root", str(tmp_path / "library"),
                 "--vision-camera-dir", str(tmp_path), "--vision-output-dir", str(tmp_path / "runs")]
    if backend == "c6i-vision-volume":
        arguments.extend(("--volume-soft-mean-abs", "16", "--volume-loud-mean-abs", "28"))
    if mode is not None:
        arguments.extend(("--vision-pl-skin-mode", mode))
    cli._create_shared_vision_backend(cli.build_parser().parse_args(arguments))
    supervisor.call_args.args[0]("skin-mode")
    runtime.FullFrameTracker.assert_called_once_with(dilate_iterations=4)
    assert recognizer.skin_validate is (mode != "performance")
    assert runtime.SharedVisionWorker.call_args.args[1] is recognizer
    if backend == "c6i-vision-volume":
        session = cli.C6IOverlaySession.return_value
        runtime.prepare_skin_factory.assert_called_once_with(
            cli.sys.modules["skin_dma"].SkinDMA, session.bitstream.with_suffix('.hwh'))
        assert runtime.SharedVisionHardware.call_args.args[2] is runtime.prepare_skin_factory.return_value
        supervisor.call_args.args[0]("skin-mode-second")
        runtime.prepare_skin_factory.assert_called_once()
        cli.C6IOverlaySession.assert_called_once()
        assert cli.C6IOverlaySession.call_args.kwargs["expected_build_id"] == 0xC0060C00
        session.open.assert_not_called()
        session.borrow.assert_not_called()
        cli.C6IVolumeRuntimeBackend.assert_called_once()
        assert cli.C6IVolumeRuntimeBackend.call_args.args[0] is session
        cli.C6IVolumeRuntimeBackend.call_args.kwargs["volume_factory"](session)
        volume_runtime = cli.sys.modules["voice_volume_fusion"]
        volume_runtime.BorrowedVolumeControl.assert_called_once_with(session, thresholds=(11, 16, 28), sampling_enabled=True)
        assert cli.C6IVolumeRuntimeBackend.call_args.kwargs["volume_sampling_enabled"] is True
        cli._create_shared_vision_backend(cli.build_parser().parse_args(arguments + ["--volume-disable-sampling"]))
        assert cli.C6IVolumeRuntimeBackend.call_args.kwargs["volume_sampling_enabled"] is False
        supervisor.call_args.args[0]("skin-disabled")
        assert runtime.SharedVisionHardware.call_args.args[2] is cli.sys.modules["skin_dma"].SkinDMA
        runtime.prepare_skin_factory.assert_called_once()
        cli.C6IVolumeRuntimeBackend.call_args.kwargs["volume_factory"](session)
        volume_runtime.BorrowedVolumeControl.assert_called_with(session, thresholds=(11, 16, 28), sampling_enabled=False)
        volume_runtime.__file__ = str(tmp_path / "voice_volume_fusion.py")
        with pytest.raises(ImportError, match="Unexpected fused volume runtime module"):
            cli._create_shared_vision_backend(cli.build_parser().parse_args(arguments))
    else:
        runtime.prepare_skin_factory.assert_not_called()


def test_shared_vision_skin_mode_rejects_unknown_value():
    with pytest.raises(SystemExit) as error:
        cli.build_parser().parse_args(["--vision-pl-skin-mode", "unknown"])
    assert error.value.code == 2


def test_pl_factory_uses_one_unopened_owner_and_dual_masks(tmp_path, monkeypatch):
    import sys
    from types import ModuleType
    from unittest.mock import MagicMock
    from pynq_multimodal_game.agent import vision_pl_fusion as fusion, c6i_backend, voice_backend
    from board.pynq_z2 import vision_owner_gate
    root = Path(fusion.__file__).resolve().parents[3]
    scripts = root / 'board/pynq_z2/scripts'
    runtime = ModuleType('vision_async_runtime')
    runtime.__file__ = str(scripts / 'vision_async_runtime.py')
    runtime.RUNTIME_DIR = root / 'handoffs/gesture_vision_v61/runtime'
    for name in ('SharedDualMaskHardware', 'SharedDualMaskWorker', 'DualMaskFullFrameTracker', 'BytesPreview'):
        setattr(runtime, name, MagicMock())
    verifier = ModuleType('verify_vision_integration_sources')
    verifier.__file__ = str(scripts / 'verify_vision_integration_sources.py')
    verifier.verify_sources = MagicMock()
    camera = ModuleType('capture_camera_direct_plug')
    camera.__file__ = str(tmp_path / 'capture_camera_direct_plug.py')
    for module in (runtime, verifier, camera):
        monkeypatch.setitem(sys.modules, module.__name__, module)
    for name, attributes in {'pynq.lib.iic': {'AxiIIC': MagicMock()},
                             'gesture_control': {'GestureControl': MagicMock()}}.items():
        module = ModuleType(name)
        vars(module).update(attributes)
        monkeypatch.setitem(sys.modules, name, module)
    monkeypatch.setattr(fusion.sys, 'platform', 'linux')
    monkeypatch.setattr(fusion.os, 'geteuid', lambda: 0, raising=False)
    monkeypatch.setattr(fusion, 'verify_pl_candidate', MagicMock())
    monkeypatch.setattr(voice_backend, 'verify_driver_sources', MagicMock())
    monkeypatch.setattr(cli, '_verify_shared_camera_sources', MagicMock())
    owner, backend_type = MagicMock(), MagicMock()
    monkeypatch.setattr(vision_owner_gate, 'PlGuardedOverlaySession', owner)
    monkeypatch.setattr(fusion, 'C6IPlVoiceFusionRuntimeBackend', backend_type)
    monkeypatch.setattr(sys, 'path', list(sys.path))
    arguments = cli.build_parser().parse_args([
        '--bitstream', str(tmp_path / 'c6v_b00_candidate.bit'),
        '--voice-fusion-manifest', str(tmp_path / 'receipt.json'),
        '--voice-driver-dir', str(tmp_path / 'audio'), '--allow-audio-dma-reset',
        '--physical-audio-confirmed', '--vision-camera-dir', str(tmp_path),
        '--vision-output-dir', str(tmp_path / 'vision'), '--library-root', str(tmp_path / 'library')])
    transport = SimpleNamespace(cpu_feature_library=('cpu.so', 'sha256'))
    session, backend = fusion.create_pl_backend(arguments, epoch=17, native_transport=transport,
                                               owner_preflight=tmp_path / 'owner.json')
    assert session is owner.return_value and backend is backend_type.return_value
    assert owner.call_args.kwargs['expected_build_id'] == 0xC0060B00
    supervisor = backend_type.call_args.args[1]
    supervisor._worker_factory('run17')
    assert runtime.SharedDualMaskHardware.call_args.args[0] is session
    assert runtime.SharedDualMaskHardware.call_args.kwargs == {
        'epoch': 17, 'config_id': 1, 'thresholds': (0, 20, 70, 20, 255, 255)}
    runtime.DualMaskFullFrameTracker.assert_called_once_with(dilate_iterations=4)
    assert runtime.SharedDualMaskWorker.call_args.kwargs['video_fps'] == 10
    assert runtime.SharedDualMaskWorker.call_args.kwargs['debug_fps'] == 5
    voice = backend_type.call_args.kwargs['voice_factory']()
    assert type(voice) is voice_backend.NativeVoiceSupervisor
    assert voice.packet_limit == 900
    session.open.assert_not_called()


@pytest.mark.parametrize("field,value", (("release_ready", 0), ("runtime_registered", 1),
                                         ("cdc_paths", True), ("setup_ns", -0.001),
                                         ("hold_ns", float("nan")), ("setup_ns", "0.015")))
def test_voice_fusion_rejects_invalid_receipt(field, value):
    from pynq_multimodal_game.agent.voice_fusion import validate_receipt

    receipt = {"schema": "voice-fusion-implementation-receipt-v1", "build_id": "0xC0060900",
               "setup_ns": 0.015, "hold_ns": 0.051, "cdc_paths": 4, "cdc_limit_ns": 10.0,
               "drc_errors": 0, "methodology_critical": 0, "methodology_warnings": 42,
               "assigned_pins": 161, "runtime_registered": False, "board_pending": True,
               "release_ready": False}
    validate_receipt(receipt)
    receipt[field] = value
    with pytest.raises(ValueError):
        validate_receipt(receipt)


def test_voice_fusion_check_only_never_loads_hardware(monkeypatch, tmp_path):
    from unittest.mock import MagicMock
    from pynq_multimodal_game.agent import voice_fusion

    verify, session, server = MagicMock(), MagicMock(), MagicMock()
    monkeypatch.setattr(voice_fusion, "verify_candidate", verify)
    monkeypatch.setattr(cli, "C6IOverlaySession", session)
    monkeypatch.setattr(cli, "AgentServer", server)
    arguments = ["--backend", "c6i-voice-fusion", "--build-id", "0xC0060900",
                 "--bitstream", str(tmp_path / "c6v_candidate.bit"),
                 "--voice-fusion-manifest", str(tmp_path / "candidate.json"), "--voice-check-only"]
    assert cli.main(arguments) == 0
    verify.assert_called_once()
    verify.side_effect = ValueError("altered identity")
    assert cli.main(arguments) == 1
    session.assert_not_called()
    server.assert_not_called()
    with pytest.raises(SystemExit):
        cli.main(arguments[:-1])
    with pytest.raises(SystemExit):
        cli.main(["--voice-check-only"])


@pytest.mark.parametrize("fault", (None, "bit", "schema", "build", "release", "missing_release", "receipt", "dma"))
def test_voice_fusion_full_candidate_contract(tmp_path, monkeypatch, fault):
    import hashlib
    import json
    from xml.etree import ElementTree as ET
    from pynq_multimodal_game.agent import voice_fusion

    document = ET.Element("SYSTEM")
    constant = ET.SubElement(document, "MODULE", INSTANCE="build_id_constant")
    ET.SubElement(constant, "PARAMETER", NAME="CONST_VAL", VALUE="0xC0060900")
    for name, base, modtype in (("voice_pcm_dma", 0x40430000, "axi_dma"),
                                ("voice_capture", 0x413E0000, "voice_i2s_dma_capture_axi"),
                                ("voice_codec_iic", 0x43C10000, "axi_iic")):
        module = ET.SubElement(document, "MODULE", INSTANCE=name, MODTYPE=modtype)
        ET.SubElement(document, "MEMRANGE", INSTANCE=name, MEMTYPE="REGISTER",
                      BASEVALUE=hex(base), HIGHVALUE=hex(base + 0xFFFF))
        if name == "voice_pcm_dma":
            for key, value in voice_fusion.DMA_PARAMETERS.items():
                if fault == "dma" and key == "C_INCLUDE_SG":
                    value = 0
                ET.SubElement(module, "PARAMETER", NAME=key, VALUE=str(value))
    for index in range(58):
        ET.SubElement(document, "MODULE", INSTANCE="fixture_" + str(index))
    for name in voice_fusion.ARTIFACT_SHA256:
        (tmp_path / name).write_bytes(b"explicit offline unit fixture")
    ET.ElementTree(document).write(tmp_path / "c6v_candidate.hwh", encoding="utf-8")
    digests = {name: hashlib.sha256((tmp_path / name).read_bytes()).hexdigest()
               for name in voice_fusion.ARTIFACT_SHA256}
    monkeypatch.setattr(voice_fusion, "ARTIFACT_SHA256", digests)
    monkeypatch.setattr(voice_fusion, "verify_frozen_source", lambda: {"source_commit": "unit-fixture"})
    payload = {"schema": voice_fusion.SCHEMA, "profile": voice_fusion.PROFILE, "build_id": "0xC0060900",
        "runtime_registered": False, "board_pending": True, "release_ready": False,
        "voice_source_commit": "unit-fixture", "sha256": digests,
        "implementation_receipt": {"schema": "voice-fusion-implementation-receipt-v1", "build_id": "0xC0060900",
            "setup_ns": 0.015, "hold_ns": 0.051, "cdc_paths": 4, "cdc_limit_ns": 10.0,
            "drc_errors": 0, "methodology_critical": 0, "methodology_warnings": 42, "assigned_pins": 161,
            "runtime_registered": False, "board_pending": True, "release_ready": False}}
    if fault in ("schema", "build", "release"):
        payload[{"schema": "schema", "build": "build_id", "release": "release_ready"}[fault]] = "invalid"
    elif fault == "missing_release":
        del payload["release_ready"]
    elif fault == "receipt":
        payload["implementation_receipt"]["setup_ns"] = -0.001
    path = tmp_path / "candidate.json"
    path.write_text(json.dumps(payload), encoding="utf-8")
    if fault == "bit":
        (tmp_path / "c6v_candidate.bit").write_bytes(b"altered")
    if fault is None:
        assert voice_fusion.verify_candidate(tmp_path / "c6v_candidate.bit", path) == payload
    else:
        with pytest.raises(ValueError):
            voice_fusion.verify_candidate(tmp_path / "c6v_candidate.bit", path)


@pytest.mark.parametrize("fail", (False, True))
def test_shared_vision_overlay_isolates_pynq_metadata_and_retains_pair(monkeypatch, tmp_path, fail):
    import gc
    import sys

    source = tmp_path / "c6v_candidate.bit"
    source.write_bytes(b"paired-bitstream")
    source.with_suffix(".hwh").write_bytes(b"paired-hwh")
    source.with_suffix(".xsa").write_bytes(b"official-audit-xsa")
    captured = []

    def load(bitstream, *, download):
        runtime = Path(bitstream)
        captured.append(runtime)
        assert download is False
        assert runtime.parent != source.parent
        assert {path.name for path in runtime.parent.iterdir()} == {source.name, "c6v_candidate.hwh"}
        assert runtime.read_bytes() == source.read_bytes()
        assert runtime.with_suffix(".hwh").read_bytes() == source.with_suffix(".hwh").read_bytes()
        if fail:
            raise RuntimeError("parser rejected metadata")
        return SimpleNamespace(bitfile_name=bitstream, download=lambda: None)

    monkeypatch.setitem(sys.modules, "pynq", SimpleNamespace(Overlay=load))
    monkeypatch.setattr(cli, "_restore_shared_vision_interrupts", lambda *args: None)
    if fail:
        with pytest.raises(RuntimeError, match="parser rejected metadata"):
            cli._load_shared_vision_overlay(str(source), download=True)
    else:
        overlay = cli._load_shared_vision_overlay(str(source), download=True)
        assert captured[0].is_file()
        assert overlay._voice_view_load_directory == captured[0].parent
        del overlay
        gc.collect()
        assert captured[0].read_bytes() == source.read_bytes()
        second = cli._load_shared_vision_overlay(str(source), download=True)
        assert captured[1] == captured[0]
        del second
        gc.collect()
        captured[0].with_suffix(".hwh").write_bytes(b"altered-runtime-pair")
        with pytest.raises(ValueError, match="paired identity mismatch"):
            cli._load_shared_vision_overlay(str(source), download=True)
    assert captured[0].parent.exists()
    assert source.with_suffix(".xsa").read_bytes() == b"official-audit-xsa"


@pytest.mark.parametrize("mismatch", [None, "controller", "pin", "address", "ip-pin"])
def test_shared_vision_interrupts_use_native_hwh_and_reject_conflicts(monkeypatch, tmp_path, mismatch):
    import copy
    import sys

    hwh = tmp_path / "candidate.hwh"
    hwh.write_text("native-hwh-fixture", encoding="utf-8")
    pin = {"controller": "", "index": 2, "fullpath": "frame_dma/s2mm_introut", "raw_irq": 63}
    legacy = SimpleNamespace(
        interrupt_controllers={}, interrupt_pins={"frame_dma/s2mm_introut": pin},
        ip_dict={"frame_dma": {"phys_addr": 0x43000000, "addr_range": 0x10000,
                               "interrupts": {"s2mm_introut": pin}}},
    )

    def parse(*, hwh_data):
        assert hwh_data == "native-hwh-fixture"
        return legacy

    for name in ("pynq", "pynq.pl_server"):
        monkeypatch.setitem(sys.modules, name, SimpleNamespace(__path__=[]))
    monkeypatch.setitem(sys.modules, "pynq.pl_server.hwh_parser", SimpleNamespace(HWH=parse))

    class CopyOnReadDict(dict):
        def __getitem__(self, key):
            return copy.deepcopy(super().__getitem__(key))

    current = {"frame_dma": {"phys_addr": 0x43000000, "addr_range": 0x10000, "interrupts": {}}}
    overlay = SimpleNamespace(interrupt_controllers={}, interrupt_pins={}, ip_dict=CopyOnReadDict(copy.deepcopy(current)),
                              parser=SimpleNamespace(interrupt_pins={}, ip_dict=copy.deepcopy(current)),
                              hierarchy_dict={}, mem_dict={}, ignore_version=False, device=None, _ip_map=None)

    def refresh(source):
        overlay.ip_dict = CopyOnReadDict(copy.deepcopy(source.ip_dict))
        overlay.interrupt_pins = copy.deepcopy(source.interrupt_pins)

    overlay._deepcopy_dict_from = refresh
    monkeypatch.setitem(sys.modules, "pynq.overlay", SimpleNamespace(
        _complete_description=lambda ip, *args: {"ip": copy.deepcopy(dict(ip))},
        _IPMap=lambda description: SimpleNamespace(_description=description),
    ))
    if mismatch == "controller":
        overlay.interrupt_controllers["unexpected"] = {}
    elif mismatch == "pin":
        overlay.parser.interrupt_pins["frame_dma/s2mm_introut"] = {**pin, "raw_irq": 64}
    elif mismatch == "address":
        overlay.parser.ip_dict["frame_dma"]["phys_addr"] += 0x10000
    elif mismatch == "ip-pin":
        overlay.parser.ip_dict["frame_dma"]["interrupts"]["s2mm_introut"] = {**pin, "raw_irq": 64}
    before = copy.deepcopy(overlay)
    if mismatch:
        with pytest.raises(ValueError, match="differs"):
            cli._restore_shared_vision_interrupts(overlay, hwh)
        assert overlay == before
    else:
        cli._restore_shared_vision_interrupts(overlay, hwh)
        for view in (overlay, overlay.parser):
            assert view.interrupt_pins == legacy.interrupt_pins
            assert view.ip_dict["frame_dma"]["interrupts"] == legacy.ip_dict["frame_dma"]["interrupts"]
        assert overlay._ip_map._description["ip"]["frame_dma"]["interrupts"] == legacy.ip_dict["frame_dma"]["interrupts"]


class FakeSource:
    def __init__(
        self,
        payloads: list[bytes] | None = None,
        error: BaseException | None = None,
    ) -> None:
        self.payloads = payloads or []
        self.error = error
        self.seeds: list[int] = []
        self.close_count = 0
        self.stats = SimpleNamespace(transfers=0, total_bytes=0)

    def receive(self, seed: int) -> bytes:
        self.seeds.append(seed)
        if self.error is not None:
            raise self.error
        payload = self.payloads[len(self.seeds) - 1]
        self.stats.transfers += 1
        self.stats.total_bytes += len(payload)
        return payload

    def close(self) -> None:
        self.close_count += 1


def _vision_arguments():
    return ["--backend", "vision-only", "--bitstream", "vision.bit",
            "--vision-camera-dir", "camera", "--vision-camera-sha256", "0" * 64,
            "--vision-output-dir", "results"]


def test_shared_vision_cli_requires_manifest_before_hardware(monkeypatch, tmp_path):
    from unittest.mock import MagicMock

    session, server = MagicMock(), MagicMock()
    monkeypatch.setattr(cli, "C6IOverlaySession", session)
    monkeypatch.setattr(cli, "AgentServer", server)
    arguments = _vision_arguments()
    arguments[1] = "c6i-vision"
    with pytest.raises(SystemExit) as raised:
        cli.main(arguments)
    assert raised.value.code == 2
    assert cli.main(arguments + ["--build-id", "0xC0060800", "--vision-manifest",
                                 str(tmp_path / "missing.json"), "--vision-check-only"]) == 1
    session.assert_not_called()
    server.assert_not_called()


@pytest.mark.parametrize("extra", (["--fixtures"], ["--return-source", "c6i"]))
@pytest.mark.parametrize("shared", (False, True))
def test_vision_cli_refuses_mixed_hardware_sources(extra, shared):
    arguments = _vision_arguments()
    if shared:
        arguments[1] = "c6i-vision"
    with pytest.raises(SystemExit) as raised:
        cli.main(arguments + extra)
    assert raised.value.code == 2


@pytest.mark.parametrize("fault", (None, "timing", "bit", "hwh", "release_false",
                                  "release_missing", "release_number", "release_string", "candidate_schema"))
@pytest.mark.parametrize("board_test", (False, True))
@pytest.mark.parametrize("volume_mode", (False, True))
def test_shared_vision_cli_checks_pair_without_loading_hardware(tmp_path, monkeypatch, fault, board_test, volume_mode):
    import hashlib
    import json
    from unittest.mock import MagicMock
    from xml.etree import ElementTree as ET
    from zipfile import ZipFile
    from board.pynq_z2.scripts import verify_vision_integration_sources as verifier

    bitstream = tmp_path / ("c6v_candidate.bit" if board_test else "fixture.bit")
    bitstream.write_bytes(b"explicit offline fixture, not a deployable bitstream")
    hwh = bitstream.with_suffix(".hwh")
    document = ET.Element("SYSTEM")
    addresses = {"axi_dma": 0x40400000, "return_dma": 0x40410000,
                 "build_id_gpio": 0x41200000, "render_trace_gpio": 0x41280000,
                 "render_cycles_gpio": 0x41290000, "present_completion_gpio": 0x412B0000,
                 "moments_dma": 0x40420000, "moments_reset": 0x413D0000,
                 "frame_dma": 0x43000000, "camera_iic": 0x41600000, "demosaic": 0x43C00000}
    if volume_mode:
        addresses["voice_volume_0"] = 0x43C10000
    for name, base in addresses.items():
        ET.SubElement(document, "MODULE", INSTANCE=name)
        ET.SubElement(document, "MEMRANGE", INSTANCE=name, BASEVALUE=hex(base),
                      HIGHVALUE=hex(base + (0xFFF if name == "voice_volume_0" else 0xFFFF)))
    if volume_mode:
        document.find("MODULE[@INSTANCE='voice_volume_0']").set("MODTYPE", "voice_volume_top")
        for instance, parameters in {
                "gp0_smc": {"NUM_MI": "31"},
                "ps7_0": {"PCW_EN_EMIO_I2C1": "1", "PCW_EN_I2C1": "1",
                           "PCW_I2C1_GRP_INT_ENABLE": "1", "PCW_I2C1_GRP_INT_IO": "EMIO",
                           "PCW_I2C1_I2C1_IO": "EMIO", "PCW_I2C1_PERIPHERAL_ENABLE": "1"},
                "audio_mclk": {"PRIM_IN_FREQ": "100.000", "CLKOUT1_REQUESTED_OUT_FREQ": "10.000"}}.items():
            module = ET.SubElement(document, "MODULE", INSTANCE=instance)
            for name, value in parameters.items():
                ET.SubElement(module, "PARAMETER", NAME=name, VALUE=value)
    ET.SubElement(document, "MODULE", INSTANCE="skin_kernel", MODTYPE="bgr_skin_dma")
    frame = document.find("MODULE[@INSTANCE='frame_dma']")
    assert frame is not None
    ET.SubElement(frame, "PARAMETER", NAME="C_INCLUDE_MM2S", VALUE="0")
    build_id = ET.SubElement(document, "MODULE", INSTANCE="build_id_constant")
    selected_build_id = "0xC0060C00" if volume_mode else "0xC0060800"
    ET.SubElement(build_id, "PARAMETER", NAME="CONST_VAL", VALUE=selected_build_id)
    pipeline = ET.SubElement(document, "MODULE", INSTANCE="vision_gp0_slice")
    for channel in ("AW", "AR", "W", "R", "B"):
        for prefix in ("REG_", "C_REG_CONFIG_"):
            ET.SubElement(pipeline, "PARAMETER", NAME=prefix + channel, VALUE="1")
    ET.ElementTree(document).write(hwh, encoding="utf-8")
    manifest = tmp_path / "fixture.json"
    payload = {"schema": "c6i-vision-package-v1", "profile": "C6I_VISION",
        "build_id": "0xC0060800", "timing_pass": fault != "timing",
        "release_ready": {"release_false": False, "release_number": 1, "release_string": "true"}.get(fault, True),
        "sha256": {path.name: hashlib.sha256(path.read_bytes()).hexdigest().upper()
                   for path in (bitstream, hwh)}}
    if volume_mode:
        payload.update(schema="c6i-vision-volume-package-v1", profile="C6I_VISION_VOLUME_V1", build_id=selected_build_id)
    if fault == "release_missing":
        del payload["release_ready"]
    if fault == "candidate_schema":
        payload["schema"] = "c6i-vision-offline-candidate-v1"
    if board_test:
        for name in verifier.CANDIDATE_FILES:
            if name not in (bitstream.name, hwh.name, "c6v_candidate.xsa"):
                (tmp_path / name).write_bytes(b"explicit offline report/DCP fixture")
        with ZipFile(tmp_path / "c6v_candidate.xsa", "w") as archive:
            archive.write(bitstream, "c6v_candidate.bit")
            archive.write(hwh, "c6v.hwh")
        payload = verifier.verify_volume_candidate_bundle(tmp_path) if volume_mode else verifier.verify_candidate_bundle(tmp_path)
        if fault == "timing":
            payload["timing_pass"] = True
        if fault == "release_false":
            payload["release_ready"] = True
        if fault == "release_missing":
            del payload["release_ready"]
        if fault in ("release_number", "release_string"):
            payload["release_ready"] = 0 if fault == "release_number" else "false"
        if fault == "candidate_schema":
            payload["schema"] = "c6i-vision-package-v1"
    manifest.write_text(json.dumps(payload), encoding="utf-8")
    if fault == "hwh":
        hwh.write_bytes(b"<SYSTEM><malformed>")
    if fault == "bit":
        bitstream.write_bytes(b"changed fixture")
    session, server, factory = MagicMock(), MagicMock(), MagicMock()
    monkeypatch.setattr(cli, "C6IOverlaySession", session)
    monkeypatch.setattr(cli, "AgentServer", server)
    monkeypatch.setattr(cli, "_create_shared_vision_backend", factory)
    root = Path(__file__).resolve().parents[1]
    arguments = ["--backend", "c6i-vision", "--build-id", "0xC0060800", "--bitstream", str(bitstream),
                 "--vision-manifest", str(manifest), "--vision-camera-dir", str(root / "board/pynq_z2"),
                 "--vision-camera-sha256", "B79C5735EA5C81B0EA4A95E805AEF3CDDF45D221BBD1906D76326D79B9E2E253",
                 "--vision-output-dir", str(tmp_path / "results"), "--vision-check-only"]
    if volume_mode:
        arguments[1], arguments[3] = "c6i-vision-volume", selected_build_id
    if board_test:
        arguments.append("--vision-board-test")
    assert cli.main(arguments) == (0 if fault is None else 1)
    session.assert_not_called()
    server.assert_not_called()
    factory.assert_not_called()
    assert not (tmp_path / "results").exists()
    if volume_mode and fault is None:
        original = hwh.read_bytes()
        for instance, parameter in (("gp0_smc", "NUM_MI"), ("ps7_0", "PCW_I2C1_I2C1_IO"),
                                    ("audio_mclk", "CLKOUT1_REQUESTED_OUT_FREQ"), ("vision_gp0_slice", "REG_AW")):
            mutated = ET.fromstring(original)
            mutated.find(f"MODULE[@INSTANCE='{instance}']/PARAMETER[@NAME='{parameter}']").set("VALUE", "0")
            ET.ElementTree(mutated).write(hwh, encoding="utf-8")
            with pytest.raises(ValueError):
                verifier.verify_volume_candidate_hwh(hwh)
        hwh.write_bytes(original)


def test_vision_board_test_requires_explicit_fusion_backend():
    with pytest.raises(SystemExit) as raised:
        cli.main(["--vision-board-test"])
    assert raised.value.code == 2


def test_shared_vision_cli_rejects_standalone_duration():
    arguments = _vision_arguments()
    arguments[1] = "c6i-vision"
    with pytest.raises(SystemExit) as raised:
        cli.main(arguments + ["--vision-manifest", "fixture.json", "--vision-duration", "10"])
    assert raised.value.code == 2


def test_vision_cli_preflight_failure_never_creates_gpu_or_listener(monkeypatch):
    from unittest.mock import MagicMock

    gpu, server = MagicMock(), MagicMock()
    monkeypatch.setattr(cli, "C6IOverlaySession", gpu)
    monkeypatch.setattr(cli, "AgentServer", server)
    monkeypatch.setattr(cli, "_create_vision_backend", MagicMock(side_effect=ValueError("Camera SHA mismatch")))
    assert cli.main(_vision_arguments()) == 1
    gpu.assert_not_called()
    server.assert_not_called()


@pytest.mark.parametrize("fail_cleanup", (False, True))
@pytest.mark.parametrize("shared", (False, True))
def test_vision_cli_shutdown_keeps_failed_owner(monkeypatch, fail_cleanup, shared, tmp_path):
    from unittest.mock import MagicMock
    from pynq_multimodal_game.agent.vision_backend import C6IVisionRuntimeBackend, VisionRuntimeBackend

    supervisor = MagicMock()
    supervisor.status.return_value = {"state": "IDLE", "owner_held": False}
    backend = VisionRuntimeBackend(supervisor)
    if fail_cleanup:
        supervisor.stop.side_effect = RuntimeError("owner retained")
    session = MagicMock()
    arguments = _vision_arguments()
    if shared:
        backend = MagicMock(spec=C6IVisionRuntimeBackend)
        if fail_cleanup:
            backend.close.side_effect = RuntimeError("owner retained")
        monkeypatch.setattr(cli, "_preflight_shared_vision", lambda _args: None)
        monkeypatch.setattr(cli, "_create_shared_vision_backend", lambda _args: (session, backend))
        arguments[1] = "c6i-vision"
        arguments += ["--build-id", "0xC0060800", "--vision-manifest", str(tmp_path / "pair.json")]
    handlers = {}
    server = MagicMock()
    server.address = ("127.0.0.1", 12345)
    server.start.side_effect = lambda: handlers[cli.signal.SIGINT]()
    monkeypatch.setattr(cli.signal, "signal", lambda number, handler: handlers.update({number: handler}))
    monkeypatch.setattr(cli, "AgentServer", lambda *_args, **_kwargs: server)
    gpu = MagicMock()
    monkeypatch.setattr(cli, "C6IOverlaySession", gpu)
    monkeypatch.setattr(cli, "_create_vision_backend", lambda _args: backend)
    real_event = threading.Event
    events = []
    def create_event():
        if not events:
            event = real_event()
        else:
            event = MagicMock()
            event.wait.side_effect = SystemExit(77)
        events.append(event)
        return event
    monkeypatch.setattr(cli.threading, "Event", create_event)
    if fail_cleanup:
        with pytest.raises(SystemExit) as raised:
            cli.main(arguments)
        assert raised.value.code == 77 and len(events) == 2
    else:
        assert cli.main(arguments) == 0
    gpu.assert_not_called()
    assert server.close.called
    if shared:
        session.open.assert_called_once()
        backend.close.assert_called_once()
        if fail_cleanup:
            session.close.assert_not_called()
        else:
            session.close.assert_called_once()
    else:
        assert supervisor.stop.called


def test_vision_cli_check_only_never_opens_server_or_starts_worker(monkeypatch):
    from unittest.mock import MagicMock

    backend, server = MagicMock(), MagicMock()
    monkeypatch.setattr(cli, "_create_vision_backend", lambda _args: backend)
    monkeypatch.setattr(cli, "AgentServer", server)
    assert cli.main(_vision_arguments() + ["--vision-check-only"]) == 0
    server.assert_not_called()
    backend.start_vision.assert_not_called()
    backend.close.assert_not_called()


def test_vision_cli_real_check_only_validates_frozen_package_on_pc(tmp_path, monkeypatch):
    import hashlib
    from unittest.mock import MagicMock

    camera = tmp_path / "capture_camera_direct_plug.py"
    camera.write_bytes(b"offline identity fixture")
    bit = Path(cli.__file__).resolve().parents[3] / "handoffs/gesture_vision_v61/runtime/camera_hand_skin_v6.bit"
    server, gpu = MagicMock(), MagicMock()
    monkeypatch.setattr(cli, "AgentServer", server)
    monkeypatch.setattr(cli, "C6IOverlaySession", gpu)
    assert cli.main(["--backend", "vision-only", "--bitstream", str(bit),
        "--vision-camera-dir", str(tmp_path), "--vision-camera-sha256",
        hashlib.sha256(camera.read_bytes()).hexdigest(), "--vision-output-dir", str(tmp_path / "run"),
        "--vision-check-only"]) == 0
    server.assert_not_called()
    gpu.assert_not_called()
    assert not (tmp_path / "run").exists()


class FakePublishingServer:
    def __init__(self, stopped: threading.Event, stop_after: int) -> None:
        self.stopped = stopped
        self.stop_after = stop_after
        self.frames: list[tuple[bytes, int]] = []

    def publish_data(self, payload: bytes, *, source_id: int) -> None:
        self.frames.append((payload, source_id))
        if len(self.frames) == self.stop_after:
            self.stopped.set()


def test_parser_defaults_and_all_c6i_parameters() -> None:
    defaults = cli.build_parser().parse_args([])
    configured = cli.build_parser().parse_args(
        [
            "--return-source", "c6i",
            "--bitstream", "build/c6i.bit",
            "--return-size", "4096",
            "--return-rate", "25.5",
            "--return-timeout", "1.25",
            "--return-source-id", "0x30",
            "--seed-base", "0xFFFF0000",
            "--lock-path", "run/c6i.lock",
        ]
    )

    assert defaults.return_source == "none"
    assert defaults.backend == "mock"
    assert defaults.bitstream is None
    assert defaults.return_size == 65536
    assert defaults.return_rate == 10.0
    assert defaults.return_timeout == 5.0
    assert defaults.return_source_id == streaming.C6I_OPAQUE_RETURN_SOURCE_ID
    assert defaults.seed_base == 0xC6D00000
    assert defaults.lock_path == Path("/var/lock/voice-view-c6i.lock")
    assert configured.return_source == "c6i"
    assert configured.bitstream == Path("build/c6i.bit")
    assert configured.return_size == 4096
    assert configured.return_rate == 25.5
    assert configured.return_timeout == 1.25
    assert configured.return_source_id == 0x30
    assert configured.seed_base == 0xFFFF0000
    assert configured.lock_path == Path("run/c6i.lock")


@pytest.mark.parametrize(
    "arguments, message",
    [
        (["--fixtures", "--return-source", "c6i", "--bitstream", "c6i.bit"], "mutually exclusive"),
        (["--return-source", "c6i"], "--bitstream is required"),
        (["--backend", "c6i-video"], "--bitstream is required"),
        (
            ["--backend", "c6i-video", "--return-source", "c6i", "--bitstream", "c6i.bit"],
            "mutually exclusive",
        ),
        (["--return-size", "0"], "--return-size must be positive"),
        (["--return-rate", "0"], "--return-rate must be positive"),
        (["--return-timeout", "0"], "--return-timeout must be positive"),
        (["--return-source-id", "0x100000000"], "--return-source-id must fit in uint32"),
        (["--seed-base", "-1"], "--seed-base must fit in uint32"),
    ],
)
def test_main_rejects_invalid_c6i_arguments(
    arguments: list[str], message: str, capsys: pytest.CaptureFixture[str]
) -> None:
    with pytest.raises(SystemExit) as raised:
        cli.main(arguments)

    assert raised.value.code == 2
    assert message in capsys.readouterr().err


def test_publisher_emits_source_three_increments_seed_and_closes() -> None:
    stopped = threading.Event()
    source = FakeSource([b"one", b"two", b"three"])
    server = FakePublishingServer(stopped, stop_after=3)
    failures: list[BaseException] = []

    cli._publish_c6i_returns(
        server,
        source,
        stopped,
        1000.0,
        streaming.C6I_OPAQUE_RETURN_SOURCE_ID,
        0xFFFFFFFE,
        failures,
    )

    assert server.frames == [
        (b"one", 3),
        (b"two", 3),
        (b"three", 3),
    ]
    assert source.seeds == [0xFFFFFFFE, 0xFFFFFFFF, 0]
    assert source.close_count == 1
    assert failures == []


def test_publisher_source_failure_stops_and_records_error(
    capsys: pytest.CaptureFixture[str],
) -> None:
    stopped = threading.Event()
    error = RuntimeError("DMA failed")
    source = FakeSource(error=error)
    server = FakePublishingServer(stopped, stop_after=1)
    failures: list[BaseException] = []

    cli._publish_c6i_returns(server, source, stopped, 10.0, 3, 5, failures)

    assert stopped.is_set()
    assert failures == [error]
    assert source.close_count == 1
    assert server.frames == []
    assert "C6I publisher failed: RuntimeError: DMA failed" in capsys.readouterr().err


def test_c6i_initialization_failure_does_not_start_server(
    monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str]
) -> None:
    events: dict[str, Any] = {"server_started": False, "source_closed": 0}

    class FailingSource:
        def __init__(self, *_args: Any, **_kwargs: Any) -> None:
            pass

        def open(self) -> None:
            raise RuntimeError("BUILD_ID mismatch")

        def close(self) -> None:
            events["source_closed"] += 1

    class FakeServer:
        def __init__(self, *_args: Any, **_kwargs: Any) -> None:
            pass

        def start(self) -> None:
            events["server_started"] = True

        def close(self) -> None:
            events["server_closed"] = True

    class FakeSession:
        def __init__(self, *_args: Any, **_kwargs: Any) -> None:
            pass

        def open(self) -> None:
            return None

        def close(self) -> None:
            events["session_closed"] = events.get("session_closed", 0) + 1

    monkeypatch.setattr(cli, "C6IOverlaySession", FakeSession)
    monkeypatch.setattr(cli, "C6IReturnSource", FailingSource)
    monkeypatch.setattr(cli, "AgentServer", FakeServer)

    result = cli.main(["--return-source", "c6i", "--bitstream", "c6i.bit"])

    assert result == 1
    assert events["server_started"] is False
    assert events["server_closed"] is True
    assert events["source_closed"] == 1
    assert "C6I initialization failed: RuntimeError: BUILD_ID mismatch" in capsys.readouterr().err


def test_c6i_video_initialization_failure_does_not_start_server(
    monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str]
) -> None:
    events: dict[str, Any] = {"server_started": False}

    class FailingSession:
        build_id = 0xC0060700

        def __init__(self, *_args: Any, **_kwargs: Any) -> None:
            pass

        def open(self) -> None:
            raise RuntimeError("BUILD_ID mismatch")

        def close(self) -> None:
            events["session_closed"] = events.get("session_closed", 0) + 1

    class FakeServer:
        def __init__(self, *_args: Any, **_kwargs: Any) -> None:
            pass

        def start(self) -> None:
            events["server_started"] = True

        def close(self) -> None:
            events["server_closed"] = True

    monkeypatch.setattr(cli, "C6IOverlaySession", FailingSession)
    monkeypatch.setattr(cli, "AgentServer", FakeServer)

    result = cli.main(["--backend", "c6i-video", "--bitstream", "c6i.bit"])

    assert result == 1
    assert events["server_started"] is False
    assert events["server_closed"] is True
    assert events["session_closed"] == 1
    assert "C6I initialization failed: RuntimeError: BUILD_ID mismatch" in capsys.readouterr().err