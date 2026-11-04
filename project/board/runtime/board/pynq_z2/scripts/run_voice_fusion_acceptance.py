from __future__ import annotations

import argparse
import copy
import hashlib
import importlib
import importlib.util
import json
import os
from pathlib import Path
import struct
import subprocess
import sys
import sysconfig
import threading
import time
import uuid
import wave


def check_deployment(root: Path) -> dict:
    root = root.resolve(strict=True)
    manifest = json.loads((root / "deployment_manifest.json").read_text(encoding="utf-8"))
    if (manifest.get("schema") != "voice-fusion-board-deployment-v1"
            or manifest.get("build_id") != "0xC0060900"
            or manifest.get("release_ready") is not False or manifest.get("board_pending") is not True
            or manifest.get("runtime_registered") is not False
            or manifest.get("live_authorization_required") is not True):
        raise ValueError("Strict fusion deployment gates required")
    identities = manifest.get("sha256")
    if type(identities) is not dict or not identities:
        raise ValueError("Complete deployment identities required")
    for path in root.rglob("*"):
        if not path.is_file():
            continue
        relative = path.relative_to(root).as_posix()
        if relative not in identities and relative != "deployment_manifest.json" and not relative.startswith("var/"):
            raise ValueError(f"Unlisted fusion deployment file: {relative}")
    for name, digest in identities.items():
        path = (root / name).resolve(strict=True)
        if not path.is_relative_to(root) or hashlib.sha256(path.read_bytes()).hexdigest() != digest:
            raise ValueError(f"Fusion deployment SHA mismatch: {name}")
    sys.path.insert(0, str(root / "python"))
    package = importlib.import_module("pynq_multimodal_game")
    if Path(package.__file__).resolve().parent != root / "python/pynq_multimodal_game":
        raise ImportError("Fusion check must use its isolated software snapshot")
    from pynq_multimodal_game.agent.voice_backend import verify_driver_sources
    from pynq_multimodal_game.agent.voice_fusion import verify_candidate
    from pynq_multimodal_game.game_package import validate_game_package
    verify_candidate(root / "overlay/c6v_candidate.bit", root / "overlay/voice_fusion_manifest.json")
    verify_driver_sources(root / "audio_driver")
    for game_id, description in manifest["games"].items():
        path = (root / description["file"]).resolve(strict=True)
        if not path.is_relative_to(root):
            raise ValueError("Game path escapes fusion deployment")
        game = validate_game_package(path)
        if (game.sha256 != description["sha256"] or game.manifest.game_id != game_id
                or game.manifest.target_build_id != 0xC0060900 or description["assertions"] < 1):
            raise ValueError("Fusion game identity/target mismatch")
    return manifest


def require_no_existing_owner() -> None:
    processes = subprocess.run(["ps", "-ww", "-eo", "pid=,args="], check=True,
                               text=True, capture_output=True).stdout
    owners = ("project1_live_ov5640.py", "capture_camera_direct_plug.py",
              "run_camera_live_guarded.py", "run_accel_guarded.py", "run_vision_guarded.py",
              "pcm_capture_test.py", "rule_capture_setup.py", "pynq_multimodal_game.agent")
    for line in processes.splitlines():
        fields = line.strip().split(None, 1)
        if len(fields) == 2 and int(fields[0]) != os.getpid() and any(name in fields[1] for name in owners):
            raise RuntimeError("Existing camera/audio owner must stop with confirmed DMA cleanup before loading")


def record_runtime_snapshot(result: dict, backend, voice, phase: str) -> None:
    snapshot = {}
    voice = voice if voice is not None else getattr(backend, "_voice", None)
    readers = {}
    if voice is not None:
        readers["audio"] = voice.status
    if backend is not None:
        readers["voice"] = lambda: backend.voice_status
        readers["vision"] = lambda: backend._vision_supervisor.status()
        if backend._game is not None:
            def game_receipts():
                consumed = backend._game.input_consumptions
                return {name: consumed[name] for name in ("presented_frames", "vision", "audio")}
            readers["game_receipts"] = game_receipts
    for name, read in readers.items():
        try:
            snapshot[name] = copy.deepcopy(read())
            result.setdefault(name, snapshot[name])
        except Exception as error:
            snapshot.setdefault("diagnostic_errors", {})[name] = f"{type(error).__name__}: {error}"
    result.setdefault("runtime_snapshots", {})[phase] = snapshot


def start_diagnostic_audio(backend, mode: str):
    backend._stop_menu()
    if mode == "audio-vision":
        backend.start_vision()
    backend._prepare_voice()
    voice = backend._voice
    voice.start()
    return voice


def configure_diagnostic_cpu_split(backend, result):
    get_affinity, set_affinity = getattr(os, "sched_getaffinity", None), getattr(os, "sched_setaffinity", None)
    if get_affinity is None or set_affinity is None or not {0, 1} <= set(get_affinity(0)):
        raise RuntimeError("Diagnostic CPU split requires available CPUs 0 and 1")
    diagnostic = {"classification": "process-local diagnostic-only", "producer_requested_cpu": 0,
                  "worker_requested_cpu": 1, "capture_deadlines_unchanged": True}
    result["diagnostic_cpu_split"] = diagnostic
    original_factory = backend._voice_factory

    def voice_factory(**options):
        supervisor = original_factory(**options)
        service_factory, capture_factory = supervisor._service_factory, supervisor._capture_factory

        def prepare_service(**service_options):
            service = service_factory(**service_options, worker_cpu=1)
            diagnostic["worker_confirmed_cpu"] = service._stream.worker_cpu
            if type(diagnostic["worker_confirmed_cpu"]) is not int or diagnostic["worker_confirmed_cpu"] != 1:
                service.close()
                raise RuntimeError("CPU worker did not confirm diagnostic CPU 1")
            return service

        def prepare_capture():
            diagnostic["producer_original_cpus"] = sorted(get_affinity(0))
            set_affinity(0, {0})
            diagnostic["producer_confirmed_cpus"] = sorted(get_affinity(0))
            if diagnostic["producer_confirmed_cpus"] != [0]:
                raise RuntimeError("Producer did not confirm diagnostic CPU 0")
            return capture_factory()

        supervisor._service_factory, supervisor._capture_factory = prepare_service, prepare_capture
        return supervisor

    backend._voice_factory = voice_factory


def load_diagnostic_native_voice(root, manifest):
    from pynq_multimodal_game.agent.voice_backend import NativeVoiceLibrary
    report = json.loads((root / "var/native_transport.json").read_text())
    source = "board/pynq_z2/scripts/voice_native_transport.cpp"
    if (report.get("source_sha256") != manifest["sha256"].get(source)
            or report.get("hardware_operations") is not False
            or type(report.get("compile_returncode")) is not int or report["compile_returncode"] != 0):
        raise RuntimeError("Native diagnostic requires this package's exact compiled source and CPU-only build receipt")
    models = report.get("models", {})
    if set(models) != {"model", "owner_model", "health_model", "loop_model"} or not all(
            type(values) is list and len(values) == 10 and all(type(value) is int and value == 0 for value in values)
            for values in models.values()):
        raise RuntimeError("Native diagnostic CPU model gate incomplete")
    transport = NativeVoiceLibrary(root / "var/voice_native_transport.so", sha256=report["library_sha256"])
    transport.cpu_feature_library = None
    cpu_source = "board/pynq_z2/scripts/voice_cpu_features.cpp"
    if cpu_source in manifest["sha256"]:
        cpu = json.loads((root / "var/cpu_features.json").read_text())
        library = root / "var/voice_cpu_features.so"
        if (cpu.get("status") != "S4_CPU_FEATURE_BUILD_MODEL_PASS"
                or cpu.get("source_sha256") != manifest["sha256"][cpu_source]
                or cpu.get("hardware_operations") is not False or cpu.get("pynq_imported") is not False
                or cpu.get("compile_returncode") != 0 or cpu.get("model_returncode") != 0
                or cpu.get("model", {}).get("synthetic_exact_windows") != 185
                or cpu.get("model", {}).get("preprocessing_exact_blocks") != 30
                or cpu.get("model", {}).get("spawn_events_exact") is not True
                or hashlib.sha256(library.read_bytes()).hexdigest() != cpu.get("library_sha256")):
            raise RuntimeError("CPU feature diagnostic requires exact source/library and CPU-only model receipt")
        transport.cpu_feature_library = (str(library), cpu["library_sha256"])
    return transport


def configure_diagnostic_native_voice(backend, transport):
    from pynq_multimodal_game.agent.voice_backend import BorrowedVoiceCapture, NativeVoiceSupervisor
    original = backend._voice_factory

    def voice_factory(**options):
        previous = original(**options)

        def capture_factory():
            capture = previous._capture_factory()
            if type(capture) is not BorrowedVoiceCapture or capture.state != "NEW":
                raise RuntimeError("Native diagnostic requires a fresh exact shared BorrowedVoiceCapture")
            capture.native_transport = transport
            return capture

        def service_factory(**service_options):
            cpu_features = transport.cpu_feature_library
            return previous._service_factory(**service_options, measure_processing=True, optimize_features=True,
                optimize_preprocessing=cpu_features is not None, cpu_feature_library=cpu_features)

        return NativeVoiceSupervisor(capture_factory, service_factory=service_factory,
            bus=previous.bus, packet_limit=previous.packet_limit, stop_requested=previous._stop_requested,
            record_pcm=previous._record_pcm)

    backend._voice_factory = voice_factory


def configure_diagnostic_vision_cpu(backend, result):
    supervisor = backend._vision_supervisor
    if supervisor._worker is not None:
        raise RuntimeError("Vision CPU diagnostic requires an unstarted supervisor")
    original = supervisor._worker_factory
    receipt = dict(classification="diagnostic-only", worker_nice_floor=5, workers=[])
    result["diagnostic_vision_cpu"] = receipt

    def worker_factory(*arguments, **options):
        worker = original(*arguments, **options)
        if not hasattr(worker, "cooperative_cpu") or worker._thread is not None:
            raise RuntimeError("Vision CPU diagnostic requires a fresh capable worker")
        worker.cooperative_cpu = True
        receipt["workers"].append(dict(run_id=worker.run_id, scheduling=worker.cpu_scheduling))
        return worker

    supervisor._worker_factory = worker_factory


def configure_diagnostic_vision_timing(backend, result):
    supervisor = backend._vision_supervisor
    if supervisor._worker is not None:
        raise RuntimeError("Vision timing diagnostic requires an unstarted supervisor")
    original = supervisor._worker_factory
    receipt = dict(classification="diagnostic-only", workers=[])
    result["diagnostic_vision_timing"] = receipt

    def worker_factory(*arguments, **options):
        worker = original(*arguments, **options)
        if not hasattr(worker, "measure_processing") or worker._thread is not None:
            raise RuntimeError("Vision timing diagnostic requires a fresh capable worker")
        worker.measure_processing = True
        receipt["workers"].append(dict(run_id=worker.run_id, timing=worker.processing_timing))
        return worker

    supervisor._worker_factory = worker_factory


def configure_diagnostic_vision_cv(result):
    import cv2
    previous = cv2.getNumThreads()
    cv2.setNumThreads(1)
    confirmed = cv2.getNumThreads()
    result["diagnostic_vision_cv"] = dict(classification="process-local diagnostic-only",
        opencv=cv2.__version__, previous_threads=previous, requested_threads=1, confirmed_threads=confirmed)
    if confirmed != 1:
        raise RuntimeError("Vision OpenCV single-thread diagnostic unconfirmed")


def configure_diagnostic_preview_upload(backend, result):
    if backend._game is not None:
        raise RuntimeError("Preview/upload diagnostic requires an unstarted game")
    backend._diagnostic_preview_upload_overlap = True
    result["diagnostic_preview_upload_overlap"] = dict(classification="diagnostic-only",
        max_game_requests=1, max_deferred_scenes=1, additional_threads=0,
        hardware_build_unchanged=True, audio_deadlines_unchanged=True)


def load_diagnostic_cache_sync(root, manifest):
    source = "board/pynq_z2/scripts/voice_xrt_sync.cpp"
    report = json.loads((root / "var/cache_sync.json").read_text())
    library = root / "var/cache-sync" / ("voice_xrt_sync" + sysconfig.get_config_var("EXT_SUFFIX"))
    if (report.get("status") != "S4_CACHE_SYNC_BUILD_MODEL_PASS"
            or report.get("source_sha256") != manifest["sha256"].get(source)
            or source not in manifest["sha256"]
            or report.get("hardware_operations") is not False
            or report.get("model_returncode") != 0
            or report.get("model", {}).get("status") != "CACHE_SYNC_CPU_MODEL_PASS"
            or report.get("compile_returncodes") != [0, 0]
            or hashlib.sha256(library.read_bytes()).hexdigest() != report.get("library_sha256")):
        raise RuntimeError("Cache sync diagnostic requires exact source/library and CPU model receipt")
    if "voice_xrt_sync" in sys.modules:
        raise RuntimeError("Cache sync diagnostic requires an unloaded extension")
    spec = importlib.util.spec_from_file_location("voice_xrt_sync", library)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    if module.abi != 10000 or module.model is not False:
        raise RuntimeError("Cache sync diagnostic ABI/model mismatch")
    return module


def install_diagnostic_cache_sync(device, device_type, module, result):
    names = ("flush", "invalidate")
    if (not isinstance(device, device_type) or any(name in vars(device) for name in names)
            or any(getattr(getattr(device, name), "__func__", None) is not getattr(device_type, name)
                   for name in names)):
        raise RuntimeError("Cache sync diagnostic requires original XrtDevice cache methods")
    receipt = dict(classification="process-local diagnostic-only", flush_calls=0, invalidate_calls=0,
                   full_bo_sync=True, additional_threads=0, restored=False)

    def flush(buffer, offset, pointer, size):
        receipt["flush_calls"] += 1
        try:
            module.sync(buffer, 0)
        except Exception as error:
            raise RuntimeError(f"Buffer Flush Failed: {str(error)}") from error

    def invalidate(buffer, offset, pointer, size):
        receipt["invalidate_calls"] += 1
        try:
            module.sync(buffer, 1)
        except Exception as error:
            raise RuntimeError(f"Buffer Invalidate Failed: {str(error)}") from error

    device.flush, device.invalidate = flush, invalidate
    result["diagnostic_cache_sync"] = receipt

    def restore():
        if device.flush is not flush or device.invalidate is not invalidate:
            raise RuntimeError("Cache sync diagnostic methods changed before restoration")
        del device.flush, device.invalidate
        receipt["restored"] = True

    return restore


def main(argv=None) -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check-only", action="store_true")
    parser.add_argument("--live-board-test", action="store_true")
    parser.add_argument("--mode", choices=("audio", "vision", "scene", "fusion", "audio-vision", "audio-gpu"), default="audio")
    parser.add_argument("--game", default="game1-voice-s2")
    parser.add_argument("--vision-pl-skin-mode", choices=("validate", "performance"), default="validate")
    parser.add_argument("--allow-audio-dma-reset", action="store_true")
    parser.add_argument("--physical-audio-confirmed", action="store_true")
    parser.add_argument("--diagnostic-thread-switch", action="store_true")
    parser.add_argument("--diagnostic-cpu-split", action="store_true")
    parser.add_argument("--diagnostic-native-voice", action="store_true")
    parser.add_argument("--diagnostic-vision-cooperative", action="store_true")
    parser.add_argument("--diagnostic-vision-timing", action="store_true")
    parser.add_argument("--diagnostic-vision-cv-single-thread", action="store_true")
    parser.add_argument("--diagnostic-preview-upload-overlap", action="store_true")
    parser.add_argument("--diagnostic-cache-sync", action="store_true")
    parser.add_argument("--diagnostic-camera-only", action="store_true")
    parser.add_argument("--diagnostic-camera-copy", action="store_true")
    parser.add_argument("--diagnostic-camera-recycle", action="store_true")
    parser.add_argument("--diagnostic-camera-yield", action="store_true")
    args = parser.parse_args(argv)
    if args.diagnostic_vision_cooperative and (not args.diagnostic_native_voice or args.mode != "fusion"):
        parser.error("Vision cooperative CPU diagnostic requires native full fusion")
    if args.diagnostic_vision_timing and (not args.diagnostic_native_voice or args.mode != "fusion"):
        parser.error("Vision timing diagnostic requires native full fusion")
    if args.diagnostic_vision_cv_single_thread and (not args.diagnostic_native_voice or args.mode != "fusion"):
        parser.error("Vision OpenCV diagnostic requires native full fusion")
    if args.diagnostic_preview_upload_overlap and (not args.diagnostic_native_voice or args.mode != "fusion"):
        parser.error("Preview/upload diagnostic requires native full fusion")
    if args.diagnostic_cache_sync and (not args.diagnostic_native_voice or args.mode != "fusion"):
        parser.error("Cache sync diagnostic requires native full fusion")
    if args.diagnostic_native_voice and (args.mode not in ("audio", "fusion", "audio-vision", "audio-gpu")
                                         or args.diagnostic_thread_switch or args.diagnostic_camera_only):
        parser.error("Native voice is a separate audio/fusion/audio-vision/audio-gpu diagnostic")
    if args.diagnostic_camera_yield and not args.diagnostic_camera_recycle:
        parser.error("Camera copy yielding requires the camera-recycle diagnostic")
    if args.diagnostic_camera_recycle and not args.diagnostic_camera_copy:
        parser.error("Camera recycling requires the camera-copy diagnostic")
    if args.diagnostic_camera_copy and not args.diagnostic_camera_only:
        parser.error("Camera copy requires the camera-only diagnostic")
    if args.diagnostic_camera_only and (args.mode != "audio-vision" or args.diagnostic_thread_switch):
        parser.error("Camera-only is an audio-vision hardware-load diagnostic")
    if args.diagnostic_cpu_split and (args.diagnostic_thread_switch or args.mode not in ("fusion", "audio-vision", "audio-gpu")):
        parser.error("CPU split is a separate fusion/audio-vision/audio-gpu diagnostic")
    root = Path(__file__).resolve().parent
    if not args.check_only and not args.live_board_test:
        parser.error("Use check-only or explicit live-board-test; default performs no board operations")
    manifest = check_deployment(root)
    if args.check_only:
        print("VOICE_FUSION_DEPLOYMENT_CHECK_PASS files=" + str(len(manifest["sha256"])) +
              " runtime_registered=false board_pending=true release_ready=false", flush=True)
        return 0
    if sys.platform != "linux" or getattr(os, "geteuid", lambda: -1)() != 0 or sys.version_info[:2] != (3, 10):
        raise RuntimeError("Use the frozen PYNQ Linux Python 3.10 interpreter with sudo -n")
    if args.mode in ("audio", "fusion", "audio-vision", "audio-gpu") and not (args.allow_audio_dma_reset and args.physical_audio_confirmed):
        parser.error("Audio writes require explicit reset and physical 10MHz MCLK/0x3b strap confirmation")
    if args.game not in manifest["games"]:
        parser.error("Unknown SHA-verified game")
    for name in ("pynq", "numpy", "cv2", "collision", "tomli"):
        module = importlib.import_module(name)
        print("DEPENDENCY", name, getattr(module, "__version__", "available"), module.__file__, flush=True)
    require_no_existing_owner()
    os.environ["XILINX_XRT"] = "/usr"
    os.environ["VVG_VISION_RUNTIME_DIR"] = str(root / "handoffs/gesture_vision_v61/runtime")
    from pynq_multimodal_game.agent import cli
    from pynq_multimodal_game.agent.c6i_backend import C6IOverlaySession
    from pynq_multimodal_game.agent.voice_backend import BorrowedVoiceCapture, NativeVoiceSupervisor, VoiceSupervisor
    from pynq_multimodal_game.library import LibraryKind

    directory = root / "var" / ("acceptance-" + uuid.uuid4().hex)
    directory.mkdir(parents=True)
    session = backend = voice = camera_probe = None
    cache_sync_restore = None
    result = {"schema": "voice-fusion-live-acceptance-v1", "mode": args.mode,
              "vision_pl_skin_mode": args.vision_pl_skin_mode,
              "build_id": "0xC0060900", "board_pending": True, "release_ready": False,
              "recognition_quality": "pending", "hdmi_visual_acceptance": "pending",
              "source_age_verified": False, "deployment_sha256": hashlib.sha256(
                  (root / "deployment_manifest.json").read_bytes()).hexdigest()}
    if args.diagnostic_thread_switch:
        result["diagnostic_scheduler"] = {"classification": "process-local diagnostic-only",
            "original_thread_switch_seconds": sys.getswitchinterval(),
            "requested_thread_switch_seconds": .001, "capture_deadlines_unchanged": True}
        sys.setswitchinterval(.001)
    try:
        if args.diagnostic_vision_cv_single_thread:
            configure_diagnostic_vision_cv(result)
        cache_sync = load_diagnostic_cache_sync(root, manifest) if args.diagnostic_cache_sync else None
        native_transport = load_diagnostic_native_voice(root, manifest) if args.diagnostic_native_voice else None
        if native_transport is not None:
            result["diagnostic_native_voice"] = {"classification": "diagnostic-only", "library_sha256": native_transport.sha256,
                "fixed_pcm_slots": 4, "capture_deadlines_unchanged": True, "recognition_sources_unchanged": True,
                "cpu_features_enabled": args.mode != "audio" and native_transport.cpu_feature_library is not None,
                "cpu_feature_library": native_transport.cpu_feature_library}
        if args.mode == "audio":
            session = C6IOverlaySession(root / "overlay/c6v_candidate.bit", expected_build_id=0xC0060900,
                                       overlay_factory=cli._load_shared_vision_overlay)
            session.open()
            def capture_factory():
                capture = BorrowedVoiceCapture(session, root / "audio_driver",
                    allow_dma_reset=args.allow_audio_dma_reset, physical_audio_confirmed=args.physical_audio_confirmed)
                capture.native_transport = native_transport
                return capture

            supervisor_type = NativeVoiceSupervisor if native_transport is not None else VoiceSupervisor
            voice = supervisor_type(capture_factory, record_pcm=True)
            voice.prepare()
            voice.start()
        else:
            sys.path.insert(0, str(root / "board/pynq_z2/scripts"))
            from verify_vision_integration_sources import CAMERA_SHA256
            options = cli.build_parser().parse_args([
                "--backend", "c6i-voice-fusion", "--build-id", "0xC0060900",
                "--bitstream", str(root / "overlay/c6v_candidate.bit"),
                "--voice-driver-dir", str(root / "audio_driver"), "--vision-game-input",
                "--vision-camera-dir", str(root / "board/pynq_z2"),
                "--vision-camera-sha256", CAMERA_SHA256,
                "--vision-pl-skin-mode", args.vision_pl_skin_mode,
                "--vision-output-dir", str(directory / "vision"),
                "--library-root", str(directory / "library")])
            options.allow_audio_dma_reset, options.physical_audio_confirmed = args.allow_audio_dma_reset, args.physical_audio_confirmed
            options.voice_record_pcm = args.mode in ("fusion", "audio-vision", "audio-gpu")
            session, backend = cli._create_shared_vision_backend(options)
            if native_transport is not None:
                configure_diagnostic_native_voice(backend, native_transport)
            if args.diagnostic_cpu_split:
                configure_diagnostic_cpu_split(backend, result)
            if args.diagnostic_vision_cooperative:
                configure_diagnostic_vision_cpu(backend, result)
            if args.diagnostic_vision_timing:
                configure_diagnostic_vision_timing(backend, result)
            if args.diagnostic_preview_upload_overlap:
                configure_diagnostic_preview_upload(backend, result)
            session.open()
            if cache_sync is not None:
                from pynq.pl_server.device import Device
                from pynq.pl_server.xrt_device import XrtDevice
                cache_sync_restore = install_diagnostic_cache_sync(Device.active_device, XrtDevice, cache_sync, result)
            if args.mode == "fusion":
                game = manifest["games"][args.game]
                backend._library.install_file(root / game["file"], item_id=args.game, display_name=args.game,
                    kind=LibraryKind.GAME, target_build_id=0xC0060900)
            backend.open()
            if args.mode in ("vision", "fusion"):
                backend.start_vision()
            if args.mode == "fusion":
                backend.start_game(args.game)
                voice = backend._voice
            if args.mode in ("audio-vision", "audio-gpu"):
                result["diagnostic_load"] = {"classification": "diagnostic-only",
                    "vision_enabled": args.mode == "audio-vision" and not args.diagnostic_camera_only,
                    "gpu_scene_submission_enabled": args.mode == "audio-gpu", "scene_submissions": 0}
                if args.diagnostic_camera_only:
                    result["diagnostic_load"].update(camera_hardware_enabled=True, ps_vision_processing_enabled=False)
                    if args.diagnostic_camera_copy:
                        result["diagnostic_load"].update(camera_frames_copied=0, camera_copy_max_seconds=0.)
                    backend._stop_menu()
                    backend._prepare_voice()
                    voice = backend._voice
                    camera_probe = backend._vision_supervisor._worker_factory("diagnostic-camera-" + uuid.uuid4().hex).hardware
                    if args.diagnostic_camera_recycle:
                        camera_probe.recycle_frames = True
                        camera_probe.cooperative_copy = args.diagnostic_camera_yield
                    camera_probe.start()
                    result["diagnostic_load"]["camera_hardware_state"] = camera_probe.state
                    if args.diagnostic_camera_recycle:
                        camera_probe.read()
                        result["diagnostic_load"]["camera_warmup_read_timing"] = camera_probe.last_read_timing
                    voice.start()
                else:
                    voice = start_diagnostic_audio(backend, args.mode)
        print("LIVE_READY mode=" + args.mode, flush=True)
        deadline = time.monotonic() + (30 if voice is not None else 18)
        next_scene_at = time.monotonic()
        while time.monotonic() < deadline:
            if voice is not None and voice.status()["state"] in ("STOPPED", "FAULT", "RETAINED"):
                break
            if args.diagnostic_camera_copy:
                started = time.monotonic()
                frame = camera_probe.read()
                elapsed = time.monotonic() - started
                load = result["diagnostic_load"]
                load["camera_frames_copied"] += 1
                load["camera_frame_shape"] = list(frame.shape)
                load["camera_copy_max_seconds"] = max(load["camera_copy_max_seconds"], elapsed)
                if args.diagnostic_camera_recycle:
                    load["camera_last_read_timing"] = camera_probe.last_read_timing
                del frame
            if args.mode == "audio-gpu" and time.monotonic() >= next_scene_at:
                with backend._lock:
                    backend._submit_menu_frame_locked()
                result["diagnostic_load"]["scene_submissions"] += 1
                next_scene_at = time.monotonic() + 1 / max(1, backend._menu_fps)
            threading.Event().wait(.02)
        record_runtime_snapshot(result, backend, voice, "before_stop")
        if voice is not None:
            result["audio"] = voice.stop()
            result["capture_pass"] = (result["audio"].get("first_error") is None
                and result["audio"]["packets"] == 900 and result["audio"]["samples"] == 864000
                and result["audio"]["cpu"]["submitted"] == result["audio"]["cpu"]["received"] == 900)
            if camera_probe is not None:
                status = int(camera_probe.dma.mmio.read(0x34))
                result["diagnostic_load"].update(frame_dma_status_after_audio_stop=hex(status),
                                                 frame_completion_observed=bool(status & 0x1000))
                result["capture_pass"] = result["capture_pass"] and bool(status & 0x1000)
                if args.diagnostic_camera_copy:
                    result["capture_pass"] = result["capture_pass"] and result["diagnostic_load"]["camera_frames_copied"] > 0
            pcm = voice.recorded_pcm
            if pcm:
                samples = [sample[0] for sample in struct.iter_unpack("<i", pcm)]
                with wave.open(str(directory / "capture.wav"), "wb") as wav:
                    wav.setnchannels(1)
                    wav.setsampwidth(2)
                    wav.setframerate(48000)
                    wav.writeframes(struct.pack("<" + str(len(samples)) + "h", *samples))
        if backend is not None:
            result["voice"] = backend.voice_status
            if backend._game is not None:
                consumed = backend._game.input_consumptions
                result["game_receipts"] = {name: consumed[name] for name in ("presented_frames", "vision", "audio")}
            result["vision"] = backend._vision_supervisor.status()
    except BaseException as error:
        result["first_error"] = f"{type(error).__name__}: {error}"
        raise
    finally:
        record_runtime_snapshot(result, backend, voice, "before_cleanup")
        try:
            if camera_probe is not None:
                result["diagnostic_load"]["camera_hardware_state_before_cleanup"] = camera_probe.state
                camera_probe.stop()
                result["diagnostic_load"]["camera_hardware_state_after_cleanup"] = camera_probe.state
            if backend is not None:
                backend.close()
            elif voice is not None:
                voice.stop()
            if session is not None:
                session.close()
            if cache_sync_restore is not None:
                cache_sync_restore()
            result["cleanup_confirmed"] = True
        except BaseException as error:
            result["cleanup_confirmed"] = False
            result["cleanup_error"] = f"{type(error).__name__}: {error}"
            record_runtime_snapshot(result, backend, voice, "after_cleanup")
            (directory / "receipt.json").write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
            print("RETAINED: no restart, reload or process exit; operator recovery required", flush=True)
            threading.Event().wait()
            raise
        record_runtime_snapshot(result, backend, voice, "after_cleanup")
        (directory / "receipt.json").write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(result, indent=2), flush=True)
    return 1 if result.get("capture_pass") is False else 0


if __name__ == "__main__":
    raise SystemExit(main())