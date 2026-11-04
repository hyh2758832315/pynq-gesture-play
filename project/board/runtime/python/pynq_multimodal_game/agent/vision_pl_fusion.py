from __future__ import annotations

import argparse
import hashlib
import importlib
import json
import os
from pathlib import Path
import sys
from xml.etree import ElementTree as ET

from .voice_backend import BorrowedVoiceCapture, C6IVoiceFusionRuntimeBackend
from .vision_backend import C6IVisionRuntimeBackend
from .voice_fusion import _verify_audio_hwh


BUILD_ID = 0xC0060B00
PROFILE = "C6I_PL_VISION_VOICE_S3"
BIT_SHA256 = "d94cd52634702cea57f8ee34f13489ee2edd5124cb77b7029b0179e61452f01f"
HWH_SHA256 = "dd22e0f736ab8575b26c81f6c366fbb21ca990cf48842c88d8b975baa4e3aa95"
CONFIGURATION_SHA256 = "1b2249930b1d8783dd8822cd74c98f85e4834b35dae4d6db9bfb96268e946210"


def verify_pl_hwh(path: Path) -> None:
    _verify_audio_hwh(path, build_id=BUILD_ID)
    document = ET.parse(path)
    expected = {
        "frame_dma": {"C_INCLUDE_MM2S": 0, "C_INCLUDE_S2MM": 1, "C_INCLUDE_SG": 0,
                      "C_NUM_FSTORES": 3, "C_M_AXI_S2MM_DATA_WIDTH": 64,
                      "C_S_AXIS_S2MM_TDATA_WIDTH": 24, "C_INCLUDE_S2MM_DRE": 0,
                      "C_INCLUDE_S2MM_SF": 1, "C_USE_FSYNC": 1},
        "moments_dma": {"C_INCLUDE_MM2S": 0, "C_INCLUDE_S2MM": 1, "C_INCLUDE_SG": 1,
                        "C_M_AXI_S2MM_DATA_WIDTH": 64, "C_S_AXIS_S2MM_TDATA_WIDTH": 64,
                        "C_M_AXI_SG_DATA_WIDTH": 32, "C_INCLUDE_S2MM_DRE": 0,
                        "C_INCLUDE_S2MM_SF": 1},
    }
    for name, values in expected.items():
        module = document.find(f".//MODULE[@INSTANCE='{name}']")
        if module is None:
            raise ValueError(f"PL fusion DMA missing: {name}")
        parameters = {item.get("NAME"): item.get("VALUE") for item in module.iter("PARAMETER")}
        if any(int(parameters.get(key, "-1"), 0) != value for key, value in values.items()):
            raise ValueError(f"PL fusion DMA capability mismatch: {name}")
    ports = document.findall(".//MODULE[@INSTANCE='capture_status']/PORTS/PORT[@NAME='capture_armed']")
    if len(ports) != 1 or ports[0].get("DIR") != "I":
        raise ValueError("PL fusion status ARM input required")
    connections = ports[0].findall("CONNECTIONS/CONNECTION")
    if (len(connections) != 1 or connections[0].get("INSTANCE") != "capture_control"
            or connections[0].get("PORT") != "armed"):
        raise ValueError("PL fusion ARM connection mismatch")


def verify_pl_candidate(bitstream: Path, receipt_path: Path) -> dict:
    bitstream, receipt_path = Path(bitstream).resolve(strict=True), Path(receipt_path).resolve(strict=True)
    if bitstream.name != "c6v_b00_candidate.bit" or receipt_path.parent != bitstream.parent:
        raise ValueError("Canonical PL fusion pair and colocated receipt required")
    report = json.loads(receipt_path.read_text(encoding="utf-8"))
    required = {
        "status": "OFFICIAL_XSA_NEW_ARM_CANONICAL_PAIR_VERIFIED_NOT_LOADED",
        "bit_sha256": BIT_SHA256, "hwh_sha256": HWH_SHA256,
        "configuration_sha256": CONFIGURATION_SHA256,
        "actual_arm_binding_verified": True, "configuration_payload_equal": True,
        "hwh_equal": True, "board_pending": True, "release_ready": False,
        "overall_status": "NOT_PASSED",
    }
    if type(report) is not dict or any(type(report.get(key)) is not type(value) or report[key] != value
                                       for key, value in required.items()):
        raise ValueError("PL fusion canonical receipt mismatch")
    hwh = bitstream.with_suffix(".hwh").resolve(strict=True)
    if hwh.parent != bitstream.parent:
        raise ValueError("PL fusion HWH escapes canonical directory")
    for path, expected in ((bitstream, BIT_SHA256), (hwh, HWH_SHA256)):
        if hashlib.sha256(path.read_bytes()).hexdigest() != expected:
            raise ValueError(f"PL fusion artifact identity mismatch: {path.name}")
    verify_pl_hwh(hwh)
    return dict(status="PL_FUSION_OFFLINE_PREFLIGHT_PASS", build_id="0xC0060B00", profile=PROFILE,
                bit_sha256=BIT_SHA256, hwh_sha256=HWH_SHA256, hardware_operations=False,
                runtime_registered=False, board_pending=True, release_ready=False,
                live_owner_journal_authorization_required=True, pynq_imported="pynq" in sys.modules)


class PlBorrowedVoiceCapture(BorrowedVoiceCapture):
    def _verify_hwh(self, path):
        verify_pl_hwh(path)


def create_pl_backend(arguments, *, epoch: int, native_transport, owner_preflight: Path,
                      vision_only: bool = False):
    from . import cli
    from .vision_backend import SharedVisionSupervisor
    from .voice_backend import NativeVoiceSupervisor, VoiceRecognitionService, verify_driver_sources
    from ..library import AssetLibrary
    from ..vision_input import GameVisionInputProvider
    from board.pynq_z2.vision_capture_control import capture_context_words
    from board.pynq_z2.vision_owner_gate import PlGuardedOverlaySession

    if sys.platform != "linux" or getattr(os, "geteuid", lambda: -1)() != 0:
        raise RuntimeError("PL fusion requires root on PYNQ Linux")
    thresholds = (0, 20, 70, 20, 255, 255)
    capture_context_words(frame_id=1, config_id=1, epoch=epoch, thresholds=thresholds)
    if not vision_only and not (arguments.allow_audio_dma_reset and arguments.physical_audio_confirmed):
        raise ValueError("PL fusion requires explicit audio reset and physical confirmation")
    if not vision_only and (native_transport is None or native_transport.cpu_feature_library is None):
        raise ValueError("PL fusion requires verified native transport and CPU feature libraries")
    verify_pl_candidate(arguments.bitstream, arguments.voice_fusion_manifest)
    verify_driver_sources(arguments.voice_driver_dir)
    root = Path(__file__).resolve().parents[3]
    scripts = root / "board/pynq_z2/scripts"
    sys.path.insert(0, str(scripts))
    verifier = importlib.import_module("verify_vision_integration_sources")
    if Path(verifier.__file__).resolve() != scripts / "verify_vision_integration_sources.py":
        raise ImportError("Wrong frozen vision verifier origin")
    verifier.verify_sources(root, root / "handoffs/gesture_vision_v61")
    cli._verify_shared_camera_sources(arguments, verifier)
    provider = GameVisionInputProvider()
    session = PlGuardedOverlaySession(arguments.bitstream, lock_path=arguments.lock_path,
        expected_build_id=BUILD_ID, owner_preflight=owner_preflight, overlay_factory=cli._load_shared_vision_overlay)

    def create_worker(run_id):
        runtime = importlib.import_module("vision_async_runtime")
        if (Path(runtime.__file__).resolve() != scripts / "vision_async_runtime.py"
                or runtime.RUNTIME_DIR.resolve() != root / "handoffs/gesture_vision_v61/runtime"):
            raise ImportError("Wrong frozen PL vision runtime origin")
        sys.path.insert(0, str(arguments.vision_camera_dir.resolve()))
        camera = importlib.import_module("capture_camera_direct_plug")
        if Path(camera.__file__).resolve() != arguments.vision_camera_dir.resolve() / "capture_camera_direct_plug.py":
            raise ImportError("Wrong frozen PL camera origin")
        from pynq.lib.iic import AxiIIC
        from gesture_control import GestureControl
        hardware = runtime.SharedDualMaskHardware(session, camera, AxiIIC,
                                                  epoch=epoch, config_id=1, thresholds=thresholds)
        return runtime.SharedDualMaskWorker(
            hardware, runtime.DualMaskFullFrameTracker(dilate_iterations=4), GestureControl(), provider,
            run_id=run_id, config_epoch=f"{PROFILE}-1-{epoch}", capture_order="bgr",
            preview_factory=lambda: runtime.BytesPreview(arguments.vision_bind, arguments.vision_port),
            video_fps=arguments.vision_preview_fps, debug_fps=arguments.vision_debug_fps,
            run_dir=arguments.vision_output_dir / run_id)

    def capture_factory():
        capture = PlBorrowedVoiceCapture(session, arguments.voice_driver_dir,
            allow_dma_reset=arguments.allow_audio_dma_reset,
            physical_audio_confirmed=arguments.physical_audio_confirmed)
        capture.native_transport = native_transport
        return capture

    def service_factory(**options):
        return VoiceRecognitionService(**options, measure_processing=True, optimize_features=True,
            optimize_preprocessing=True, cpu_feature_library=native_transport.cpu_feature_library)

    def voice_factory(**options):
        return NativeVoiceSupervisor(capture_factory, service_factory=service_factory,
            record_pcm=getattr(arguments, "voice_record_pcm", False), **options)

    backend_type = C6IPlVisionRuntimeBackend if vision_only else C6IPlVoiceFusionRuntimeBackend
    voice_options = {} if vision_only else dict(voice_factory=voice_factory)
    return session, backend_type(
        session, SharedVisionSupervisor(create_worker, provider), **voice_options,
        timeout_seconds=arguments.return_timeout, startup_settle_seconds=arguments.shell_settle_seconds,
        library=AssetLibrary(arguments.library_root))


class C6IPlVisionRuntimeBackend(C6IVisionRuntimeBackend):
    BUILD_ID = BUILD_ID
    profile = "C6I_PL_VISION_GPU_ONLY_DIAGNOSTIC"

    def prepare_vision(self):
        return self._vision_supervisor.prepare()


class C6IPlVoiceFusionRuntimeBackend(C6IVoiceFusionRuntimeBackend):
    BUILD_ID = BUILD_ID
    profile = PROFILE
    PAUSE_VISION_FOR_NATIVE_START = False

    def prepare_vision(self):
        return self._vision_supervisor.prepare()

    def __init__(self, *args, **options):
        self._vision_epoch_started = False
        self._prepared_voice = None
        super().__init__(*args, **options)

    def _prepare_voice(self):
        if self._voice is not None:
            status = self.voice_status
            if (self._voice is getattr(self, "_prepared_voice", None)
                    and status.get("state") == "READY" and status.get("first_error") is None
                    and status.get("owner_released") is not True):
                self._vision_ready_for_voice()
                return
            raise RuntimeError("PL fusion audio epoch is one-shot; retain prior owner evidence")
        vision = self._vision_ready_for_voice()
        if vision.get("state") != "IDLE" or vision.get("owner_held") is not False:
            raise RuntimeError("PL fusion audio preparation must precede vision ARM")
        self._voice = self._voice_factory(bus=self._voice_bus, stop_requested=self._game_voice_ended)
        self._voice.prepare()
        self._prepared_voice = self._voice

    def start_vision(self):
        if self._vision_epoch_started:
            status = self._vision_supervisor.status()
            if status.get("state") in ("STARTING", "RUNNING") and not status.get("last_error"):
                return self.snapshot
            raise RuntimeError("PL fusion vision epoch is one-shot; no automatic rearm")
        self._prepare_voice()
        self._vision_epoch_started = True
        return super().start_vision()


def main(argv=None) -> int:
    parser = argparse.ArgumentParser(description="Offline-only canonical B00 fusion preflight")
    parser.add_argument("--bitstream", required=True, type=Path)
    parser.add_argument("--receipt", required=True, type=Path)
    arguments = parser.parse_args(argv)
    print(json.dumps(verify_pl_candidate(arguments.bitstream, arguments.receipt), indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())