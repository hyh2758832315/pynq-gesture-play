from pathlib import Path
import struct
import threading
import time

from pynq_multimodal_game.agent import AgentCommand, AgentController, ArtifactManifest
from pynq_multimodal_game.agent.core import AgentState
from pynq_multimodal_game.agent.video_runtime import C6IVideoRuntimeBackend
from pynq_multimodal_game.video_codec import S2V1_HEIGHT, S2V1_WIDTH, encode_rgb_frames


BUILD_ID = 0xC0060700


class _RecordingSink:
    def __init__(self, presented: threading.Event, *, error: Exception | None = None) -> None:
        self.presented = presented
        self.error = error
        self.tilemap_count = 0
        self.scene_count = 0
        self.scene_sequences: list[int] = []
        self.closed = False

    def upload_tilemap(self, packet: bytes) -> None:
        self.tilemap_count += 1

    def upload_palette(self, packet: bytes) -> None:
        pass

    def upload_asset(self, packet: bytes) -> None:
        pass

    def submit_scene(self, packet: bytes) -> None:
        if self.error is not None:
            raise self.error
        self.scene_count += 1
        self.scene_sequences.append(struct.unpack_from("<I", packet, 8)[0])
        self.presented.set()

    def close(self) -> None:
        self.closed = True


class _Session:
    build_id = BUILD_ID


def _video(path: Path) -> ArtifactManifest:
    rgb = bytes((8, 16, 24)) * (S2V1_WIDTH * S2V1_HEIGHT)
    encode_rgb_frames([rgb], path)
    return ArtifactManifest.for_path(
        path,
        artifact_kind="video.s2v",
        target_build_id=BUILD_ID,
        abi_major=1,
        abi_minor=0,
    )


def _video_with_frames(path: Path, frame_count: int) -> ArtifactManifest:
    frames = [
        bytes((index, 16, 24)) * (S2V1_WIDTH * S2V1_HEIGHT)
        for index in range(frame_count)
    ]
    encode_rgb_frames(frames, path)
    return ArtifactManifest.for_path(
        path,
        artifact_kind="video.s2v",
        target_build_id=BUILD_ID,
        abi_major=1,
        abi_minor=0,
    )


def test_video_runtime_stages_plays_and_stops_to_idle(tmp_path: Path) -> None:
    path = tmp_path / "fixture.s2v"
    manifest = _video(path)
    presented = threading.Event()
    sink = _RecordingSink(presented)
    runtime = C6IVideoRuntimeBackend(
        _Session(),  # type: ignore[arg-type]
        timeout_seconds=0.2,
        sink_factory=lambda _session, _timeout: sink,
    )

    assert runtime.stage_file(manifest, path).state is AgentState.STAGED
    assert runtime.activate().state is AgentState.ACTIVE
    assert runtime.run().state is AgentState.RUNNING
    assert presented.wait(1.0)
    assert runtime.snapshot.frame_count == 1
    assert runtime.snapshot.presented_frames >= 1
    assert runtime.snapshot.frame_index == 0
    stopped = runtime.stop()

    assert stopped.state is AgentState.IDLE
    assert sink.tilemap_count == 1
    assert sink.scene_count >= 1
    assert sink.closed is True
    assert runtime.stats.presented_frames >= 1


def test_video_runtime_reports_playback_failure(tmp_path: Path) -> None:
    path = tmp_path / "fixture.s2v"
    manifest = _video(path)
    presented = threading.Event()
    sink = _RecordingSink(presented, error=RuntimeError("renderer failed"))
    runtime = C6IVideoRuntimeBackend(
        _Session(),  # type: ignore[arg-type]
        timeout_seconds=0.2,
        sink_factory=lambda _session, _timeout: sink,
    )
    runtime.stage_file(manifest, path)
    runtime.activate()
    runtime.run()

    deadline = time.monotonic() + 1.0
    while runtime.snapshot.state is AgentState.RUNNING and time.monotonic() < deadline:
        time.sleep(0.01)

    assert runtime.snapshot.state is AgentState.ERROR
    assert runtime.stats.last_error == "renderer failed"
    assert sink.closed is True


def test_video_runtime_pauses_seeks_and_resumes(tmp_path: Path) -> None:
    path = tmp_path / "seekable.s2v"
    manifest = _video_with_frames(path, 3)
    presented = threading.Event()
    sink = _RecordingSink(presented)
    runtime = C6IVideoRuntimeBackend(
        _Session(),  # type: ignore[arg-type]
        timeout_seconds=0.2,
        sink_factory=lambda _session, _timeout: sink,
    )
    runtime.stage_file(manifest, path)
    runtime.activate()
    assert runtime.run().state is AgentState.RUNNING
    assert presented.wait(1.0)
    assert runtime.pause().state is AgentState.PAUSED
    submitted_before_pause = sink.scene_count
    time.sleep(0.1)
    assert sink.scene_count == submitted_before_pause

    assert runtime.seek(1).state is AgentState.PAUSED
    presented.clear()
    assert runtime.run().state is AgentState.RUNNING
    assert presented.wait(1.0)
    assert sink.scene_sequences[submitted_before_pause] == 1
    assert runtime.stop().state is AgentState.IDLE


def test_controller_commits_chunked_video_to_runtime_and_stops(tmp_path: Path) -> None:
    path = tmp_path / "fixture.s2v"
    manifest = _video(path)
    payload = path.read_bytes()
    presented = threading.Event()
    sink = _RecordingSink(presented)
    runtime = C6IVideoRuntimeBackend(
        _Session(),  # type: ignore[arg-type]
        timeout_seconds=0.2,
        sink_factory=lambda _session, _timeout: sink,
    )
    controller = AgentController(runtime, upload_directory=tmp_path / "uploads")
    try:
        assert controller.execute(
            "begin",
            AgentCommand.UPLOAD_BEGIN,
            manifest=manifest,
            upload_id="video",
        ).ok
        assert controller.execute(
            "chunk",
            AgentCommand.UPLOAD_CHUNK,
            upload_id="video",
            offset=0,
            chunk_sha256=manifest.sha256,
            payload=payload,
        ).ok
        assert controller.execute(
            "commit", AgentCommand.UPLOAD_COMMIT, upload_id="video"
        ).state is AgentState.STAGED
        assert controller.execute("activate", AgentCommand.ACTIVATE).state is AgentState.ACTIVE
        assert controller.execute("run", AgentCommand.RUN).state is AgentState.RUNNING
        assert presented.wait(1.0)
        assert controller.execute("stop", AgentCommand.STOP).state is AgentState.IDLE
    finally:
        runtime.close()
        controller.close()