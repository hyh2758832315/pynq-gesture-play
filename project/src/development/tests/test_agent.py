from dataclasses import replace
import hashlib
from pathlib import Path

from pynq_multimodal_game.agent import (
    AgentCommand,
    AgentController,
    AgentState,
    ArtifactManifest,
    C6IReturnBackend,
    MockRuntimeBackend,
)


BUILD_ID = 0xC0060700


def test_vision_agent_waits_for_guard_readiness_and_rejects_gpu_commands():
    from unittest.mock import MagicMock
    from pynq_multimodal_game.agent.vision_backend import VisionRuntimeBackend

    supervisor = MagicMock()
    supervisor.status.return_value = {"state": "STARTING", "owner_held": True,
                                      "cleanup_confirmed": False, "board_validated": False}
    backend = VisionRuntimeBackend(supervisor)
    controller = AgentController(backend)
    try:
        first = controller.execute("vision-1", AgentCommand.VISION_START)
        assert first.ok and first.state is AgentState.STARTING
        assert first.snapshot.build_id == 0
        assert first.snapshot.profile == "VISION_ONLY"
        assert controller.execute("vision-1", AgentCommand.VISION_START).replayed
        assert supervisor.start.call_count == 1
        for command in (AgentCommand.RUN, AgentCommand.STAGE, AgentCommand.UPLOAD_BEGIN,
                        AgentCommand.LIBRARY_RUN, AgentCommand.STOP):
            assert not controller.execute(command.value, command).ok
        supervisor.status.return_value = {"state": "RUNNING", "owner_held": True}
        assert controller.execute("ready", AgentCommand.VISION_STATUS).state is AgentState.RUNNING
        supervisor.stop.side_effect = RuntimeError("DMA halt unconfirmed; owner retained")
        supervisor.status.return_value = {"state": "FAULT", "owner_held": True,
                                          "cleanup_confirmed": False}
        result = controller.execute("stop", AgentCommand.VISION_STOP)
        assert not result.ok and result.state is AgentState.ERROR
        assert result.snapshot.vision["owner_held"]
    finally:
        controller.close()


def test_gpu_agent_rejects_vision_commands():
    controller = AgentController(MockRuntimeBackend(build_id=BUILD_ID))
    try:
        for command in (AgentCommand.VISION_START, AgentCommand.VISION_STATUS, AgentCommand.VISION_STOP):
            assert not controller.execute(command.value, command).ok
    finally:
        controller.close()


def test_shared_vision_lifecycle_preserves_gpu_and_retains_failed_worker():
    import pytest
    from types import SimpleNamespace
    from unittest.mock import MagicMock
    from pynq_multimodal_game.agent.vision_backend import (
        C6IVisionRuntimeBackend, SharedVisionSupervisor,
    )
    from pynq_multimodal_game.vision_input import VisionInputProvider
    from test_c6i_shell import _Sink

    worker = MagicMock(state="RUNNING", error=None, diagnostic_error=None, frame_id=1)
    factory = MagicMock(return_value=worker)
    supervisor = SharedVisionSupervisor(factory, VisionInputProvider())
    session = SimpleNamespace(build_id=0xC0060800, open=lambda: None)
    sink = _Sink()
    backend = C6IVisionRuntimeBackend(
        session, supervisor, menu_fps=0, sink_factory=lambda *_args: sink,
    )
    controller = AgentController(backend)
    try:
        backend.open()
        first = controller.execute("shared-start", AgentCommand.VISION_START)
        assert first.ok and first.snapshot.profile == "C6I_VISION"
        assert first.snapshot.build_id == 0xC0060800
        assert controller.execute("shared-start", AgentCommand.VISION_START).replayed
        assert factory.call_count == worker.start.call_count == 1
        assert controller.execute("shared-status", AgentCommand.VISION_STATUS).ok
        assert controller.execute("gpu-stop", AgentCommand.STOP).ok
        assert not sink.closed
        worker.stop.side_effect = RuntimeError("DMA halt unconfirmed")
        stopped = controller.execute("shared-stop", AgentCommand.VISION_STOP)
        assert not stopped.ok and stopped.snapshot.vision["owner_held"]
        with pytest.raises(RuntimeError, match="halt unconfirmed"):
            backend.close()
        assert not sink.closed
        assert not controller.execute("restart-before-cleanup", AgentCommand.VISION_START).ok
        worker.stop.side_effect = None
        recovered = controller.execute("retry-stop", AgentCommand.VISION_STOP)
        assert recovered.ok and recovered.snapshot.vision["cleanup_confirmed"]
        assert not sink.closed
        assert controller.execute("new-start", AgentCommand.VISION_START).ok
        assert factory.call_count == 2
        assert factory.call_args.args[0] != first.snapshot.vision["run_id"]
    finally:
        worker.stop.side_effect = None
        backend.close()
        controller.close()
    assert sink.close_count == 1


def _manifest(payload: bytes) -> ArtifactManifest:
    return ArtifactManifest.for_payload(
        payload,
        artifact_kind="fixture.opaque",
        target_build_id=BUILD_ID,
        abi_major=1,
        abi_minor=0,
    )


def test_agent_stages_activates_runs_and_stops() -> None:
    backend = MockRuntimeBackend(build_id=BUILD_ID)
    controller = AgentController(backend)
    payload = b"artifact"

    assert controller.execute("1", AgentCommand.STAGE, manifest=_manifest(payload), payload=payload).state is AgentState.STAGED
    assert controller.execute("2", AgentCommand.ACTIVATE).state is AgentState.ACTIVE
    assert controller.execute("3", AgentCommand.RUN).state is AgentState.RUNNING
    assert controller.execute("4", AgentCommand.STOP).state is AgentState.ACTIVE
    assert controller.snapshot.active_sha256 == _manifest(payload).sha256


def test_failed_stage_preserves_active_artifact() -> None:
    controller = AgentController(MockRuntimeBackend(build_id=BUILD_ID))
    original = b"original"
    controller.execute("1", AgentCommand.STAGE, manifest=_manifest(original), payload=original)
    controller.execute("2", AgentCommand.ACTIVATE)
    active_sha256 = controller.snapshot.active_sha256

    invalid = replace(_manifest(b"replacement"), sha256="0" * 64)
    result = controller.execute("3", AgentCommand.STAGE, manifest=invalid, payload=b"replacement")

    assert result.ok is False
    assert "SHA-256" in result.message
    assert controller.snapshot.active_sha256 == active_sha256
    assert controller.snapshot.state is AgentState.ACTIVE


def test_repeated_request_returns_cached_result_without_reexecution() -> None:
    controller = AgentController(MockRuntimeBackend(build_id=BUILD_ID))
    payload = b"artifact"
    first = controller.execute("same", AgentCommand.STAGE, manifest=_manifest(payload), payload=payload)
    generation = controller.snapshot.generation

    replayed = controller.execute("same", AgentCommand.STAGE, manifest=_manifest(payload), payload=payload)
    conflicting = controller.execute("same", AgentCommand.ACTIVATE)

    assert first.replayed is False
    assert replayed.replayed is True
    assert replayed.state is AgentState.STAGED
    assert conflicting.ok is False
    assert "different request" in conflicting.message
    assert controller.snapshot.generation == generation


def test_agent_rejects_build_and_abi_mismatch() -> None:
    controller = AgentController(MockRuntimeBackend(build_id=BUILD_ID))
    payload = b"artifact"
    manifest = _manifest(payload)

    build_result = controller.execute(
        "build",
        AgentCommand.STAGE,
        manifest=replace(manifest, target_build_id=0xC0040700),
        payload=payload,
    )
    abi_result = controller.execute(
        "abi",
        AgentCommand.STAGE,
        manifest=replace(manifest, abi_minor=1),
        payload=payload,
    )

    assert build_result.ok is False
    assert "BUILD_ID" in build_result.message
    assert abi_result.ok is False
    assert "ABI" in abi_result.message
    assert controller.snapshot.state is AgentState.IDLE


def test_c6i_backend_explicitly_rejects_unvalidated_runtime_operations() -> None:
    controller = AgentController(C6IReturnBackend())

    result = controller.execute("run", AgentCommand.RUN)

    assert result.ok is False
    assert "unavailable until board validation" in result.message
    assert controller.snapshot.build_id == BUILD_ID
    assert controller.snapshot.state is AgentState.IDLE


def test_agent_test_input_is_idempotent() -> None:
    class InputBackend(MockRuntimeBackend):
        def __init__(self) -> None:
            super().__init__(build_id=BUILD_ID)
            self.inputs: list[tuple[object, ...]] = []

        def inject_test_input(self, **values):  # type: ignore[no-untyped-def]
            self.inputs.append(tuple(sorted(values.items())))
            return self.snapshot

    backend = InputBackend()
    controller = AgentController(backend)
    first = controller.execute(
        "input-1",
        AgentCommand.INPUT_INJECT,
        x=123,
        y=45,
        fist=True,
        frequency_hz=440.0,
        duration_ms=500,
    )
    replay = controller.execute(
        "input-1",
        AgentCommand.INPUT_INJECT,
        x=123,
        y=45,
        fist=True,
        frequency_hz=440.0,
        duration_ms=500,
    )

    assert first.ok is True
    assert replay.replayed is True
    assert len(backend.inputs) == 1


def test_agent_gesture_input_is_capability_checked_and_idempotent() -> None:
    class InputBackend(MockRuntimeBackend):
        input_schema_version = 2

        def inject_test_input(self, **values):
            self.received = values
            return self.snapshot

    backend = InputBackend(build_id=BUILD_ID)
    controller = AgentController(backend)
    first = controller.execute("gesture-1", AgentCommand.INPUT_INJECT, x=280, y=90, gesture="scissors")
    assert first.ok and backend.received["gesture"] == "scissors"
    repeated = controller.execute("gesture-1", AgentCommand.INPUT_INJECT, x=280, y=90, gesture="scissors")
    assert repeated.replayed
    different = controller.execute("gesture-1", AgentCommand.INPUT_INJECT, x=280, y=90, gesture="paper")
    assert not different.ok
    invalid = controller.execute("gesture-2", AgentCommand.INPUT_INJECT, x=280, y=90, gesture="invalid")
    assert not invalid.ok


class _FileRecordingBackend(MockRuntimeBackend):
    def __init__(self) -> None:
        super().__init__(build_id=BUILD_ID)
        self.staged_path: Path | None = None

    def stage_file(self, manifest: ArtifactManifest, path: Path):
        self.staged_path = path
        return MockRuntimeBackend.stage(self, manifest, path.read_bytes())


def test_chunked_upload_stages_from_disk(tmp_path: Path) -> None:
    backend = _FileRecordingBackend()
    controller = AgentController(backend, upload_directory=tmp_path)
    payload = b"chunked artifact data"
    manifest = _manifest(payload)

    begin = controller.execute(
        "begin", AgentCommand.UPLOAD_BEGIN, upload_id="upload-1", manifest=manifest
    )
    first = payload[:8]
    chunk = controller.execute(
        "chunk-1",
        AgentCommand.UPLOAD_CHUNK,
        upload_id="upload-1",
        offset=0,
        chunk_sha256=hashlib.sha256(first).hexdigest(),
        payload=first,
    )
    second = payload[8:]
    controller.execute(
        "chunk-2",
        AgentCommand.UPLOAD_CHUNK,
        upload_id="upload-1",
        offset=8,
        chunk_sha256=hashlib.sha256(second).hexdigest(),
        payload=second,
    )
    committed = controller.execute(
        "commit", AgentCommand.UPLOAD_COMMIT, upload_id="upload-1"
    )

    assert begin.transfer is not None and begin.transfer.received_length == 0
    assert chunk.transfer is not None and chunk.transfer.received_length == 8
    assert committed.ok is True
    assert committed.state is AgentState.STAGED
    assert committed.transfer is not None and committed.transfer.state == "staged"
    assert backend.staged_path is not None
    assert backend.staged_path.read_bytes() == payload


def test_chunked_upload_replay_conflict_status_and_abort(tmp_path: Path) -> None:
    controller = AgentController(
        MockRuntimeBackend(build_id=BUILD_ID), upload_directory=tmp_path
    )
    payload = b"abcdefgh"
    controller.execute(
        "begin", AgentCommand.UPLOAD_BEGIN, upload_id="resume", manifest=_manifest(payload)
    )
    first = payload[:4]
    first_sha256 = hashlib.sha256(first).hexdigest()
    controller.execute(
        "first",
        AgentCommand.UPLOAD_CHUNK,
        upload_id="resume",
        offset=0,
        chunk_sha256=first_sha256,
        payload=first,
    )

    replay = controller.execute(
        "replay",
        AgentCommand.UPLOAD_CHUNK,
        upload_id="resume",
        offset=0,
        chunk_sha256=first_sha256,
        payload=first,
    )
    gap = controller.execute(
        "gap",
        AgentCommand.UPLOAD_CHUNK,
        upload_id="resume",
        offset=5,
        chunk_sha256=hashlib.sha256(b"x").hexdigest(),
        payload=b"x",
    )
    conflict = controller.execute(
        "conflict",
        AgentCommand.UPLOAD_CHUNK,
        upload_id="resume",
        offset=0,
        chunk_sha256=hashlib.sha256(b"xxxx").hexdigest(),
        payload=b"xxxx",
    )
    status = controller.execute(
        "status", AgentCommand.UPLOAD_STATUS, upload_id="resume"
    )
    aborted = controller.execute(
        "abort", AgentCommand.UPLOAD_ABORT, upload_id="resume"
    )

    assert replay.ok is True
    assert gap.ok is False and "gap" in gap.message
    assert conflict.ok is False and "conflicts" in conflict.message
    assert status.transfer is not None and status.transfer.received_length == 4
    assert aborted.transfer is not None and aborted.transfer.state == "aborted"
    assert not list(tmp_path.rglob("*.part"))


def test_chunked_upload_supports_artifact_larger_than_protocol_frame(tmp_path: Path) -> None:
    controller = AgentController(
        MockRuntimeBackend(build_id=BUILD_ID), upload_directory=tmp_path
    )
    payload = b"x" * (8 * 1024 * 1024 + 1)
    manifest = _manifest(payload)

    assert manifest.length > 8 * 1024 * 1024
    assert controller.execute(
        "begin-large",
        AgentCommand.UPLOAD_BEGIN,
        upload_id="large",
        manifest=manifest,
    ).ok
    for index, offset in enumerate(range(0, len(payload), 1024 * 1024)):
        chunk = payload[offset : offset + 1024 * 1024]
        result = controller.execute(
            f"large-{index}",
            AgentCommand.UPLOAD_CHUNK,
            upload_id="large",
            offset=offset,
            chunk_sha256=hashlib.sha256(chunk).hexdigest(),
            payload=chunk,
        )
        assert result.ok
    assert controller.execute(
        "commit-large", AgentCommand.UPLOAD_COMMIT, upload_id="large"
    ).ok


def test_video_upload_commit_rejects_invalid_s2v(tmp_path: Path) -> None:
    controller = AgentController(
        MockRuntimeBackend(build_id=BUILD_ID), upload_directory=tmp_path
    )
    payload = b"not an s2v archive"
    manifest = ArtifactManifest.for_payload(
        payload,
        artifact_kind="video.s2v",
        target_build_id=BUILD_ID,
        abi_major=1,
        abi_minor=0,
    )
    controller.execute(
        "video-begin",
        AgentCommand.UPLOAD_BEGIN,
        upload_id="video",
        manifest=manifest,
    )
    controller.execute(
        "video-chunk",
        AgentCommand.UPLOAD_CHUNK,
        upload_id="video",
        offset=0,
        chunk_sha256=hashlib.sha256(payload).hexdigest(),
        payload=payload,
    )

    result = controller.execute(
        "video-commit", AgentCommand.UPLOAD_COMMIT, upload_id="video"
    )

    assert result.ok is False
    assert result.transfer is not None
    assert result.transfer.received_length == len(payload)