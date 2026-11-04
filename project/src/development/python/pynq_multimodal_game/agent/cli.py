from __future__ import annotations

import argparse
import hashlib
import json
import math
import importlib
import importlib.util
import os
import signal
import shutil
import sys
import threading
from collections.abc import Sequence
from pathlib import Path
from xml.etree.ElementTree import ParseError
from zipfile import BadZipFile

from .c6i_backend import C6IOverlaySession, C6IReturnSource
from .c6i_shell import C6IShellRuntimeBackend
from .core import AgentController, MockRuntimeBackend
from .transport import AgentServer
from .video_runtime import C6IVideoRuntimeBackend
from .vision_backend import C6IVisionRuntimeBackend, C6IVolumeRuntimeBackend, SharedVisionSupervisor, VisionRuntimeBackend
from ..vision_input import GameVisionInputProvider, VisionInputProvider
from .. import streaming


def _base_zero_int(value: str) -> int:
    return int(value, 0)


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Voice View PYNQ Render Agent")
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=8765)
    parser.add_argument("--build-id", type=_base_zero_int, default=0xC0060700)
    parser.add_argument(
        "--backend", choices=("mock", "c6i-video", "c6i-shell", "vision-only", "c6i-vision", "c6i-voice-fusion", "c6i-vision-volume"), default="mock"
    )
    parser.add_argument("--fixtures", action="store_true")
    parser.add_argument("--fixture-rate", type=float, default=10.0)
    parser.add_argument("--return-source", choices=("none", "c6i"), default="none")
    parser.add_argument("--bitstream", type=Path)
    parser.add_argument("--return-size", type=int, default=65536)
    parser.add_argument("--return-rate", type=float, default=10.0)
    parser.add_argument("--return-timeout", type=float, default=5.0)
    parser.add_argument(
        "--return-source-id",
        type=_base_zero_int,
        default=streaming.C6I_OPAQUE_RETURN_SOURCE_ID,
    )
    parser.add_argument("--seed-base", type=_base_zero_int, default=0xC6D00000)
    parser.add_argument(
        "--lock-path",
        type=Path,
        default=Path("/var/lock/voice-view-c6i.lock"),
    )
    parser.add_argument(
        "--library-root",
        type=Path,
        default=Path("/home/xilinx/voice-view-game/library"),
    )
    parser.add_argument("--shell-settle-seconds", type=float, default=2.0)
    parser.add_argument("--vision-camera-dir", type=Path)
    parser.add_argument("--vision-camera-sha256")
    parser.add_argument("--vision-output-dir", type=Path)
    parser.add_argument("--vision-bind", default="127.0.0.1")
    parser.add_argument("--vision-port", type=int, default=8081)
    parser.add_argument("--vision-duration", type=float, default=None,
                        help="Standalone vision-only duration; shared vision uses explicit lifecycle commands")
    parser.add_argument("--vision-preview-fps", type=float, default=10.0)
    parser.add_argument("--vision-debug-fps", type=float, default=5.0)
    parser.add_argument("--vision-pl-skin-mode", choices=("validate", "performance"), default="validate",
                        help="Validate compares every PL skin mask with the CPU reference")
    parser.add_argument("--vision-check-only", action="store_true")
    parser.add_argument("--vision-game-input", action="store_true",
                        help="Opt in to process-local game1/2/3 gesture controls")
    parser.add_argument("--vision-manifest", type=Path)
    parser.add_argument("--vision-board-test", action="store_true",
                        help="Explicitly allow a fully paired offline candidate for board acceptance only")
    parser.add_argument("--voice-fusion-manifest", type=Path)
    parser.add_argument("--voice-check-only", action="store_true")
    parser.add_argument("--voice-board-test", action="store_true")
    parser.add_argument("--voice-driver-dir", type=Path)
    parser.add_argument("--allow-audio-dma-reset", action="store_true")
    parser.add_argument("--physical-audio-confirmed", action="store_true")
    parser.add_argument("--volume-soft-mean-abs", type=int)
    parser.add_argument("--volume-loud-mean-abs", type=int)
    parser.add_argument("--volume-disable-sampling", action="store_true")
    return parser


def _preflight_shared_vision(args: argparse.Namespace) -> None:
    volume = args.backend == "c6i-vision-volume"
    build_id = "0xC0060C00" if volume else "0xC0060800"
    profile = "C6I_VISION_VOLUME_V1" if volume else "C6I_VISION"
    schema = "c6i-vision-volume" if volume else "c6i-vision"
    if args.build_id != int(build_id, 0):
        raise ValueError(f"{args.backend} requires explicit --build-id {build_id}")
    manifest = json.loads(args.vision_manifest.read_text(encoding="utf-8-sig"))
    if (not isinstance(manifest, dict) or manifest.get("profile") != profile
            or manifest.get("build_id") != build_id):
        raise ValueError(f"Signed-off {profile} paired manifest required")
    if args.vision_board_test:
        if (manifest.get("schema") != schema + "-offline-candidate-v1"
                or manifest.get("release_ready") is not False
                or manifest.get("board_pending") is not True):
            raise ValueError("Board test requires an unmodified offline candidate receipt")
    elif (manifest.get("schema") != schema + "-package-v1"
          or manifest.get("timing_pass") is not True or manifest.get("release_ready") is not True):
        raise ValueError(f"Signed-off {profile} paired manifest required")
    bitstream = args.bitstream.resolve()
    if bitstream.suffix != ".bit":
        raise ValueError("Fusion bitstream must have .bit suffix")
    identities = manifest.get("sha256")
    if not isinstance(identities, dict):
        raise ValueError("Fusion bit/HWH identities required")
    for path in (bitstream, bitstream.with_suffix(".hwh")):
        if identities.get(path.name) != hashlib.sha256(path.read_bytes()).hexdigest().upper():
            raise ValueError(f"Fusion paired identity mismatch: {path.name}")
    root = Path(__file__).resolve().parents[3]
    spec = importlib.util.spec_from_file_location(
        "_voice_view_shared_vision_preflight", root / "board/pynq_z2/scripts/verify_vision_integration_sources.py")
    if spec is None or spec.loader is None:
        raise ImportError("Fixed shared vision verifier is unavailable")
    verifier = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(verifier)
    verifier.verify_sources(root, root / "handoffs/gesture_vision_v61")
    verify_hwh = verifier.verify_volume_candidate_hwh if volume else verifier.verify_candidate_hwh
    verify_bundle = verifier.verify_volume_candidate_bundle if volume else verifier.verify_candidate_bundle
    verify_hwh(bitstream.with_suffix(".hwh"))
    if args.vision_board_test:
        if (bitstream.name != "c6v_candidate.bit"
                or manifest != verify_bundle(bitstream.parent)):
            raise ValueError("Board test candidate receipt differs from verified artifacts")
    _verify_shared_camera_sources(args, verifier)


def _verify_shared_camera_sources(args: argparse.Namespace, verifier) -> None:
    root = Path(__file__).resolve().parents[3]
    frozen = root / "handoffs/gesture_vision_v61/runtime"
    frozen_manifest = json.loads((frozen / "manifest.json").read_text(encoding="utf-8-sig"))
    for name, digest in frozen_manifest["sha256"].items():
        if Path(name).name != name or hashlib.sha256((frozen / name).read_bytes()).hexdigest().upper() != digest:
            raise ValueError(f"Frozen vision runtime identity mismatch: {name}")
    camera = args.vision_camera_dir / "capture_camera_direct_plug.py"
    if (args.vision_camera_sha256.upper() != verifier.CAMERA_SHA256
            or hashlib.sha256(camera.read_bytes()).hexdigest().upper() != verifier.CAMERA_SHA256):
        raise ValueError("Fusion camera differs from verified source")
    for name in ("ov5640_direct_plug_config.py", "camera_driver.py"):
        if (args.vision_camera_dir / name).read_bytes() != (root / "board/pynq_z2" / name).read_bytes():
            raise ValueError(f"Fusion camera dependency differs: {name}")


def _create_vision_backend(args: argparse.Namespace) -> VisionRuntimeBackend:
    if not args.vision_check_only and (sys.platform != "linux" or getattr(os, "geteuid")() != 0):
        raise RuntimeError("vision-only requires root on the PYNQ Linux host")
    path = Path(__file__).resolve().parents[3] / "board/pynq_z2/scripts/run_vision_guarded.py"
    name = "_voice_view_agent_vision_guard"
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise ImportError("Fixed vision guard is unavailable")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    launch = module.VisionLaunch(
        args.bitstream, args.vision_camera_dir, args.vision_camera_sha256,
        args.vision_output_dir, args.vision_bind, args.vision_port,
        args.vision_duration if args.vision_duration is not None else 3600.0,
        args.vision_preview_fps, args.vision_debug_fps,
    )
    launch.command()
    module.verify_package(launch.bitstream.resolve().parent)
    return VisionRuntimeBackend(module.GuardedVisionProcess(launch, lock_path=args.lock_path))


def _restore_shared_vision_interrupts(overlay, hwh: Path) -> None:
    from pynq.overlay import _complete_description, _IPMap
    from pynq.pl_server.hwh_parser import HWH

    legacy = HWH(hwh_data=hwh.read_text(encoding="utf-8"))
    if legacy.interrupt_controllers != overlay.interrupt_controllers:
        raise ValueError("Fusion interrupt controller metadata differs")
    for pin, description in legacy.interrupt_pins.items():
        for view in (overlay.interrupt_pins, overlay.parser.interrupt_pins):
            if pin in view and view[pin] != description:
                raise ValueError(f"Fusion interrupt metadata differs: {pin}")
    for name, description in legacy.ip_dict.items():
        if not description.get("interrupts"):
            continue
        for view in (overlay.ip_dict, overlay.parser.ip_dict):
            current = view[name]
            if (current["phys_addr"], current["addr_range"]) != (description["phys_addr"], description["addr_range"]):
                raise ValueError(f"Fusion interrupt IP address differs: {name}")
            for pin, interrupt in description["interrupts"].items():
                if pin in current["interrupts"] and current["interrupts"][pin] != interrupt:
                    raise ValueError(f"Fusion interrupt metadata differs: {name}/{pin}")
    overlay.parser.interrupt_pins.update(legacy.interrupt_pins)
    for name, description in legacy.ip_dict.items():
        if description.get("interrupts"):
            overlay.parser.ip_dict[name]["interrupts"].update(description["interrupts"])
    overlay._deepcopy_dict_from(overlay.parser)
    overlay._ip_map = _IPMap(_complete_description(
        overlay.ip_dict, overlay.hierarchy_dict, overlay.ignore_version,
        overlay.mem_dict, overlay.device, overlay,
    ))


def _load_shared_vision_overlay(bitstream: str, *, download: bool):
    from pynq import Overlay

    source = Path(bitstream).resolve(strict=True)
    paired = (source, source.with_suffix(".hwh"))
    identity = hashlib.sha256(str(source).encode("utf-8"))
    for path in paired:
        identity.update(path.read_bytes())
    runtime = source.parent.parent / "var/pynq-runtime-pairs" / identity.hexdigest()
    runtime.mkdir(parents=True, exist_ok=True)
    if runtime.is_symlink() or any(runtime.glob("*.xsa")):
        raise ValueError("Fusion runtime pair directory must not contain XSA or be a symlink")
    for path in paired:
        destination = runtime / path.name
        if destination.is_symlink():
            raise ValueError(f"Fusion runtime paired identity mismatch: {path.name}")
        if not destination.exists():
            shutil.copy2(path, destination)
        if hashlib.sha256(destination.read_bytes()).digest() != hashlib.sha256(path.read_bytes()).digest():
            raise ValueError(f"Fusion runtime paired identity mismatch: {path.name}")
    overlay = Overlay(str(runtime / source.name), download=False)
    _restore_shared_vision_interrupts(overlay, runtime / source.with_suffix(".hwh").name)
    if download:
        overlay.download()
    overlay._voice_view_load_directory = runtime
    return overlay


def _create_shared_vision_backend(args: argparse.Namespace) -> tuple[C6IOverlaySession, C6IVisionRuntimeBackend]:
    from ..library import AssetLibrary

    if sys.platform != "linux" or getattr(os, "geteuid")() != 0:
        raise RuntimeError("c6i-vision requires root on the PYNQ Linux host")
    root = Path(__file__).resolve().parents[3]
    provider = GameVisionInputProvider() if args.vision_game_input else VisionInputProvider()
    fusion_voice = args.backend == "c6i-voice-fusion"
    fusion_volume = args.backend == "c6i-vision-volume"
    diagnostic_root = os.environ.get("VVG_C0C_DIAGNOSTIC_DIR") if fusion_volume else None
    if diagnostic_root is not None and not Path(diagnostic_root).is_dir():
        raise ValueError("C0C diagnostic directory must already exist")
    diagnostic_stages = [] if diagnostic_root is not None else None
    session = C6IOverlaySession(args.bitstream, lock_path=args.lock_path,
                               expected_build_id=0xC0060900 if fusion_voice else 0xC0060C00 if fusion_volume else 0xC0060800,
                               overlay_factory=_load_shared_vision_overlay)
    cached_skin_factory = None

    def create_worker(run_id: str):
        nonlocal cached_skin_factory
        scripts = root / "board/pynq_z2/scripts"
        sys.path.insert(0, str(scripts))
        runtime = importlib.import_module("vision_async_runtime")
        if Path(runtime.__file__).resolve() != scripts / "vision_async_runtime.py":
            raise ImportError("Unexpected shared vision runtime module")
        if runtime.RUNTIME_DIR.resolve() != root / "handoffs/gesture_vision_v61/runtime":
            raise ImportError("Shared vision requires the frozen runtime directory")
        sys.path.insert(0, str(args.vision_camera_dir.resolve()))
        camera = importlib.import_module("capture_camera_direct_plug")
        if Path(camera.__file__).resolve() != args.vision_camera_dir.resolve() / "capture_camera_direct_plug.py":
            raise ImportError("Unexpected camera module")
        from pynq.lib.iic import AxiIIC
        from pynq.lib.video import VideoMode
        from skin_dma import SkinDMA
        from gesture_control import GestureControl

        if fusion_volume and not args.volume_disable_sampling and cached_skin_factory is None:
            cached_skin_factory = runtime.prepare_skin_factory(SkinDMA, session.bitstream.with_suffix('.hwh'))
        recognizer = runtime.FullFrameTracker(dilate_iterations=4)
        recognizer.skin_validate = args.vision_pl_skin_mode == "validate"
        controller = GestureControl()
        hardware = runtime.SharedVisionHardware(session, camera, cached_skin_factory or SkinDMA, AxiIIC, VideoMode,
                               skin_frame_shape=(360, 640) if fusion_voice else None)
        if diagnostic_stages is not None:
            hardware.stage_trace = diagnostic_stages
        return runtime.SharedVisionWorker(hardware, recognizer, controller, provider,
                                          run_id=run_id, config_epoch="C6I_VISION-v1",
                                          capture_order="bgr",
                                          preview_factory=lambda: runtime.BytesPreview(args.vision_bind, args.vision_port),
                                          video_fps=args.vision_preview_fps, debug_fps=args.vision_debug_fps,
                                          run_dir=args.vision_output_dir / run_id)

    backend_type = C6IVisionRuntimeBackend
    voice_options = {}
    if fusion_volume:
        scripts = root / "board/pynq_z2/scripts"
        sys.path.insert(0, str(scripts))
        volume_runtime = importlib.import_module("voice_volume_fusion")
        for name in ("voice_volume_fusion", "voice_volume_board", "voice_volume_control", "voice_volume_runtime"):
            if Path(sys.modules[name].__file__).resolve() != scripts / (name + ".py"):
                raise ImportError("Unexpected fused volume runtime module")
        backend_type = C6IVolumeRuntimeBackend
        voice_options["volume_sampling_enabled"] = not args.volume_disable_sampling
        diagnostic_options = {} if diagnostic_root is None else {
            "diagnostic_root": diagnostic_root, "diagnostic_context": diagnostic_stages}
        voice_options["volume_factory"] = lambda owner: volume_runtime.BorrowedVolumeControl(
            owner, thresholds=(11, args.volume_soft_mean_abs, args.volume_loud_mean_abs),
            sampling_enabled=not args.volume_disable_sampling, **diagnostic_options)
    if fusion_voice:
        from .voice_backend import BorrowedVoiceCapture, C6IVoiceFusionRuntimeBackend, VoiceSupervisor
        backend_type = C6IVoiceFusionRuntimeBackend
        voice_options["voice_factory"] = lambda **options: VoiceSupervisor(
            lambda: BorrowedVoiceCapture(session, args.voice_driver_dir,
                allow_dma_reset=args.allow_audio_dma_reset,
                physical_audio_confirmed=args.physical_audio_confirmed),
            record_pcm=getattr(args, "voice_record_pcm", False), **options)
    backend = backend_type(
        session, SharedVisionSupervisor(create_worker, provider), **voice_options,
        timeout_seconds=args.return_timeout, startup_settle_seconds=args.shell_settle_seconds,
        library=AssetLibrary(args.library_root))
    return session, backend


def main(argv: Sequence[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    if args.vision_game_input and args.backend not in ("c6i-vision", "c6i-voice-fusion", "c6i-vision-volume"):
        parser.error("--vision-game-input requires --backend c6i-vision")
    if args.vision_board_test and args.backend not in ("c6i-vision", "c6i-vision-volume"):
        parser.error("--vision-board-test requires --backend c6i-vision")
    if args.fixture_rate <= 0:
        parser.error("--fixture-rate must be positive")
    if args.return_size <= 0:
        parser.error("--return-size must be positive")
    if args.return_rate <= 0:
        parser.error("--return-rate must be positive")
    if args.return_timeout <= 0:
        parser.error("--return-timeout must be positive")
    if args.shell_settle_seconds < 0:
        parser.error("--shell-settle-seconds must be non-negative")
    if not 0 <= args.return_source_id <= 0xFFFFFFFF:
        parser.error("--return-source-id must fit in uint32")
    if not 0 <= args.seed_base <= 0xFFFFFFFF:
        parser.error("--seed-base must fit in uint32")
    if args.fixtures and args.return_source == "c6i":
        parser.error("--fixtures and --return-source c6i are mutually exclusive")
    if (
        (args.return_source == "c6i" or args.backend in ("c6i-video", "c6i-shell"))
        and args.bitstream is None
    ):
        parser.error("--bitstream is required with --return-source c6i or --backend c6i-video")
    if args.backend in ("c6i-video", "c6i-shell") and args.return_source == "c6i":
        parser.error("C6I runtime backends and --return-source c6i are mutually exclusive")
    if args.backend == "c6i-vision-volume":
        args.volume_soft_mean_abs = 16 if args.volume_soft_mean_abs is None else args.volume_soft_mean_abs
        args.volume_loud_mean_abs = 28 if args.volume_loud_mean_abs is None else args.volume_loud_mean_abs
        if not 11 < args.volume_soft_mean_abs < args.volume_loud_mean_abs <= 65535:
            parser.error("volume thresholds require 11 < SOFT < LOUD <= 65535")
        if not args.vision_check_only and not (
                args.vision_board_test and args.vision_game_input and args.physical_audio_confirmed):
            parser.error("Volume candidate requires board-test, game-input and physical-audio-confirmed")
    elif args.volume_soft_mean_abs is not None or args.volume_loud_mean_abs is not None or args.volume_disable_sampling:
        parser.error("volume thresholds require c6i-vision-volume")
    if args.backend == "c6i-voice-fusion":
        if (args.build_id != 0xC0060900 or args.bitstream is None
                or args.voice_fusion_manifest is None):
            parser.error("c6i-voice-fusion requires BUILD_ID 0xC0060900, bitstream and voice-fusion-manifest")
        if args.fixtures or args.return_source != "none" or args.vision_check_only:
            parser.error("Fusion candidate preflight cannot start hardware or fixture sources")
        if not args.voice_check_only:
            if not (args.voice_board_test and args.allow_audio_dma_reset and args.physical_audio_confirmed
                    and args.voice_driver_dir and args.vision_game_input):
                parser.error("Live candidate requires voice-board-test, voice-driver-dir, vision-game-input and explicit reset/physical confirmation")
            if any(value is None for value in (args.vision_camera_dir, args.vision_camera_sha256,
                                               args.vision_output_dir)):
                parser.error("Live fusion candidate requires frozen vision camera and output paths")
            if args.vision_duration is not None or not 0 <= args.vision_port <= 65535:
                parser.error("Fusion uses explicit lifecycle and a uint16 preview port")
            if any(not math.isfinite(rate) or not 0 <= rate <= 30 for rate in
                   (args.vision_preview_fps, args.vision_debug_fps)):
                parser.error("fusion diagnostic rates must be finite and in 0..30")
        from .voice_fusion import verify_candidate
        try:
            verify_candidate(args.bitstream, args.voice_fusion_manifest)
            if args.voice_driver_dir is not None:
                from .voice_backend import verify_driver_sources
                verify_driver_sources(args.voice_driver_dir)
            if not args.voice_check_only:
                root = Path(__file__).resolve().parents[3]
                scripts = root / "board/pynq_z2/scripts"
                sys.path.insert(0, str(scripts))
                verifier = importlib.import_module("verify_vision_integration_sources")
                if Path(verifier.__file__).resolve() != scripts / "verify_vision_integration_sources.py":
                    raise ImportError("Wrong frozen vision verifier origin")
                verifier.verify_sources(root, root / "handoffs/gesture_vision_v61")
                _verify_shared_camera_sources(args, verifier)
        except (OSError, RuntimeError, ValueError, ImportError, KeyError, ParseError) as error:
            print(f"VOICE_FUSION_PREFLIGHT_FAILED: {error}", file=sys.stderr, flush=True)
            return 1
        if args.voice_check_only:
            print("VOICE_FUSION_PREFLIGHT_PASS: runtime_registered=false; board_pending=true; release_ready=false", flush=True)
            return 0
    elif (args.voice_check_only or args.voice_fusion_manifest is not None or args.voice_board_test
          or args.voice_driver_dir is not None or args.allow_audio_dma_reset
          or args.physical_audio_confirmed and args.backend != "c6i-vision-volume"):
        parser.error("Voice candidate options require c6i-voice-fusion")
    if args.backend in ("vision-only", "c6i-vision", "c6i-vision-volume"):
        if args.fixtures or args.return_source != "none":
            parser.error("vision backends cannot publish fixtures or separate C6I returns")
        if any(value is None for value in (args.bitstream, args.vision_camera_dir,
                                           args.vision_camera_sha256, args.vision_output_dir)):
            parser.error("vision backends require bitstream, vision-camera-dir/SHA and vision-output-dir")
        if args.backend in ("c6i-vision", "c6i-vision-volume") and args.vision_manifest is None:
            parser.error("c6i-vision requires --vision-manifest")
        if args.backend in ("c6i-vision", "c6i-vision-volume"):
            if args.vision_duration is not None:
                parser.error("c6i-vision uses VISION_START/VISION_STOP, not --vision-duration")
            if not 0 <= args.vision_port <= 65535:
                parser.error("--vision-port must fit in uint16")
            if any(not math.isfinite(rate) or not 0 <= rate <= 30 for rate in
                   (args.vision_preview_fps, args.vision_debug_fps)):
                parser.error("fusion diagnostic rates must be finite and in 0..30")
    elif args.vision_check_only:
        parser.error("--vision-check-only requires a vision backend")

    if args.backend in ("c6i-vision", "c6i-vision-volume"):
        try:
            _preflight_shared_vision(args)
        except (OSError, RuntimeError, ValueError, ImportError, KeyError, ParseError, BadZipFile) as error:
            print(f"voice-view-agent fusion preflight failed: {error}", file=sys.stderr, flush=True)
            return 1
        if args.vision_check_only:
            profile = "C6I_VISION_VOLUME" if args.backend == "c6i-vision-volume" else "C6I_VISION"
            mode = profile + ("_BOARD_TEST_PREFLIGHT_PASS" if args.vision_board_test else "_PREFLIGHT_PASS")
            print(f"{mode}: paired identity; NOT board validated", flush=True)
            return 0
        if args.vision_board_test:
            print("C6I_VISION_BOARD_TEST: candidate acceptance only; release_ready=false", flush=True)

    session: C6IOverlaySession | None = None
    runtime: C6IVideoRuntimeBackend | C6IShellRuntimeBackend | VisionRuntimeBackend | None = None
    controller: AgentController | None = None
    server: AgentServer | None = None
    if args.return_source == "c6i" or args.backend in ("c6i-video", "c6i-shell"):
        session = C6IOverlaySession(
            args.bitstream,
            lock_path=args.lock_path,
            expected_build_id=args.build_id,
        )
    if args.backend in ("c6i-vision", "c6i-voice-fusion", "c6i-vision-volume"):
        try:
            session, runtime = _create_shared_vision_backend(args)
        except (OSError, RuntimeError, ValueError, ImportError) as error:
            print(f"voice-view-agent fusion initialization failed: {error}", file=sys.stderr, flush=True)
            return 1
        controller = AgentController(runtime)
    elif args.backend == "vision-only":
        try:
            runtime = _create_vision_backend(args)
        except (OSError, RuntimeError, ValueError, ImportError) as error:
            print(f"voice-view-agent vision preflight failed: {error}", file=sys.stderr, flush=True)
            return 1
        if args.vision_check_only:
            print("VISION_PREFLIGHT_PASS: frozen package/camera identity; NOT board validated", flush=True)
            return 0
        controller = AgentController(runtime)
    elif args.backend == "c6i-video":
        assert session is not None
        runtime = C6IVideoRuntimeBackend(session, timeout_seconds=args.return_timeout)
        controller = AgentController(runtime)
    elif args.backend == "c6i-shell":
        from ..library import AssetLibrary

        assert session is not None
        runtime = C6IShellRuntimeBackend(
            session,
            timeout_seconds=args.return_timeout,
            startup_settle_seconds=args.shell_settle_seconds,
            library=AssetLibrary(args.library_root),
        )
        controller = AgentController(runtime)
    else:
        controller = AgentController(MockRuntimeBackend(build_id=args.build_id))
    server = AgentServer(controller, host=args.host, port=args.port)
    stopped = threading.Event()
    source: C6IReturnSource | None = None
    publisher_thread: threading.Thread | None = None
    source_failures: list[BaseException] = []

    def stop(*_args: object) -> None:
        stopped.set()

    signal.signal(signal.SIGINT, stop)
    if hasattr(signal, "SIGTERM"):
        signal.signal(signal.SIGTERM, stop)

    try:
        if args.return_source == "c6i":
            try:
                assert session is not None
                session.open()
                source = C6IReturnSource(
                    size=args.return_size,
                    timeout_seconds=args.return_timeout,
                    session=session,
                )
                source.open()
            except BaseException as error:
                print(
                    f"voice-view-agent C6I initialization failed: "
                    f"{type(error).__name__}: {error}",
                    file=sys.stderr,
                    flush=True,
                )
                source_failures.append(error)
                return 1
        elif session is not None:
            try:
                session.open()
            except BaseException as error:
                print(
                    f"voice-view-agent C6I initialization failed: "
                    f"{type(error).__name__}: {error}",
                    file=sys.stderr,
                    flush=True,
                )
                source_failures.append(error)
                return 1
        if isinstance(runtime, C6IShellRuntimeBackend):
            try:
                runtime.open()
            except BaseException as error:
                print(
                    f"voice-view-agent shell initialization failed: "
                    f"{type(error).__name__}: {error}",
                    file=sys.stderr,
                    flush=True,
                )
                source_failures.append(error)
                return 1

        try:
            server.start()
        except BaseException as error:
            print(
                f"voice-view-agent server start failed: "
                f"{type(error).__name__}: {error}",
                file=sys.stderr,
                flush=True,
            )
            source_failures.append(error)
            return 1

        if args.fixtures:
            publisher_thread = threading.Thread(
                target=_publish_fixtures,
                args=(server, stopped, args.fixture_rate),
                name="voice-view-fixtures",
                daemon=True,
            )
            publisher_thread.start()
        elif source is not None:
            publisher_thread = threading.Thread(
                target=_publish_c6i_returns,
                args=(
                    server,
                    source,
                    stopped,
                    args.return_rate,
                    args.return_source_id,
                    args.seed_base,
                    source_failures,
                ),
                name="voice-view-c6i-return",
                daemon=True,
            )
            publisher_thread.start()
        host, port = server.address
        print(f"voice-view-agent listening on {host}:{port}", flush=True)
        if isinstance(runtime, VisionRuntimeBackend):
            while not stopped.wait(0.1):
                runtime.poll_cleanup()
        else:
            stopped.wait()
    finally:
        stopped.set()
        if publisher_thread is not None:
            publisher_thread.join(timeout=2.0)
        if source is not None:
            source.close()
        if isinstance(runtime, (VisionRuntimeBackend, C6IVisionRuntimeBackend)):
            server.close()
            controller.close()
            try:
                runtime.close()
            except (OSError, RuntimeError, ValueError) as error:
                print(f"VISION_AGENT_RETAINED: {error}; operator recovery required",
                      file=sys.stderr, flush=True)
                threading.Event().wait()
                raise
        elif runtime is not None:
            runtime.close()
        if session is not None:
            session.close()
        server.close()
        controller.close()
    return 1 if source_failures else 0


def _publish_c6i_returns(
    server: AgentServer,
    source: C6IReturnSource,
    stopped: threading.Event,
    rate: float,
    source_id: int,
    seed_base: int,
    failures: list[BaseException],
) -> None:
    tick = 0
    period = 1.0 / rate
    try:
        while not stopped.is_set():
            seed = (seed_base + tick) & 0xFFFFFFFF
            payload = source.receive(seed)
            server.publish_data(payload, source_id=source_id)
            tick += 1
            if tick % 100 == 0:
                print(
                    "voice-view-agent C6I progress: "
                    f"transfers={source.stats.transfers} "
                    f"bytes={source.stats.total_bytes}",
                    flush=True,
                )
            stopped.wait(period)
    except BaseException as error:
        print(
            f"voice-view-agent C6I publisher failed: "
            f"{type(error).__name__}: {error}",
            file=sys.stderr,
            flush=True,
        )
        failures.append(error)
        stopped.set()
    finally:
        print(
            "voice-view-agent C6I progress: "
            f"transfers={source.stats.transfers} "
            f"bytes={source.stats.total_bytes}",
            flush=True,
        )
        source.close()

def _publish_fixtures(server: AgentServer, stopped: threading.Event, rate: float) -> None:
    tick = 0
    period = 1.0 / rate
    while not stopped.is_set():
        width, height = 64, 36
        rgb = bytearray(width * height * 3)
        for y in range(height):
            for x in range(width):
                offset = (y * width + x) * 3
                rgb[offset] = (x * 4 + tick * 3) & 0xFF
                rgb[offset + 1] = (y * 7 + tick * 2) & 0xFF
                rgb[offset + 2] = ((x + y) * 3) & 0xFF
        phase = tick * 0.15
        values = [math.sin(index * 0.12 + phase) for index in range(128)]
        server.publish_data(
            streaming.encode_fixture_frame(width, height, rgb),
            source_id=streaming.FIXTURE_VISION_SOURCE_ID,
        )
        server.publish_data(
            streaming.encode_fixture_series(values),
            source_id=streaming.FIXTURE_AUDIO_SOURCE_ID,
        )
        tick += 1
        stopped.wait(period)


if __name__ == "__main__":
    raise SystemExit(main())