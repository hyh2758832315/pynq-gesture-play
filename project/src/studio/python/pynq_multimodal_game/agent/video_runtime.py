from __future__ import annotations

from dataclasses import dataclass
import hashlib
from pathlib import Path
import threading
import time
from typing import Callable, Protocol

from ..video_codec import S2V1_FPS, S2V1Reader
from .c6i_backend import C6IOverlaySession
from .c6i_video import C6IVideoSink
from .core import MAX_UPLOAD_CHUNK_SIZE, AgentState, ArtifactManifest, RuntimeSnapshot


class _VideoSink(Protocol):
    def upload_tilemap(self, packet: bytes) -> None: ...

    def upload_palette(self, packet: bytes) -> None: ...

    def upload_asset(self, packet: bytes) -> None: ...

    def submit_scene(self, packet: bytes) -> None: ...

    def close(self) -> None: ...


VideoSinkFactory = Callable[[C6IOverlaySession, float], _VideoSink]


@dataclass(frozen=True)
class C6IVideoStats:
    presented_frames: int = 0
    completed_loops: int = 0
    last_frame_index: int | None = None
    last_error: str | None = None


class C6IVideoRuntimeBackend:
    def __init__(
        self,
        session: C6IOverlaySession,
        *,
        timeout_seconds: float = 2.0,
        sink_factory: VideoSinkFactory | None = None,
    ) -> None:
        if timeout_seconds <= 0:
            raise ValueError("timeout_seconds must be positive")
        self._session = session
        self._timeout_seconds = timeout_seconds
        self._sink_factory = sink_factory or self._create_sink
        self._lock = threading.RLock()
        self._state = AgentState.IDLE
        self._generation = 0
        self._staged: tuple[ArtifactManifest, Path] | None = None
        self._active: tuple[ArtifactManifest, Path] | None = None
        self._thread: threading.Thread | None = None
        self._stopped = threading.Event()
        self._resume = threading.Event()
        self._resumed = threading.Event()
        self._seek_requested: int | None = None
        self._seek_event = threading.Event()
        self._stats = C6IVideoStats()
        self._frame_count: int | None = None

    @property
    def snapshot(self) -> RuntimeSnapshot:
        with self._lock:
            stats = self._stats
            return RuntimeSnapshot(
                state=self._state,
                build_id=self._session.build_id,
                abi_major=1,
                abi_minor=0,
                staged_sha256=None if self._staged is None else self._staged[0].sha256,
                active_sha256=None if self._active is None else self._active[0].sha256,
                generation=self._generation,
                frame_index=stats.last_frame_index,
                frame_count=self._frame_count,
                presented_frames=stats.presented_frames,
                completed_loops=stats.completed_loops,
                last_error=stats.last_error,
            )

    @property
    def stats(self) -> C6IVideoStats:
        with self._lock:
            return self._stats

    def stage(self, manifest: ArtifactManifest, payload: bytes) -> RuntimeSnapshot:
        raise RuntimeError("C6I VIDEO runtime requires a disk-backed artifact upload")

    def stage_file(self, manifest: ArtifactManifest, path: Path) -> RuntimeSnapshot:
        source = Path(path)
        if manifest.artifact_kind != "video.s2v":
            raise ValueError("C6I VIDEO runtime only accepts video.s2v artifacts")
        if not source.is_file():
            raise FileNotFoundError(source)
        if source.stat().st_size != manifest.length:
            raise ValueError("video artifact length mismatch")
        digest = hashlib.sha256()
        with source.open("rb") as stream:
            for chunk in iter(lambda: stream.read(MAX_UPLOAD_CHUNK_SIZE), b""):
                digest.update(chunk)
        if digest.hexdigest() != manifest.sha256:
            raise ValueError("video artifact SHA-256 mismatch")
        with S2V1Reader(source) as reader:
            frame_count = reader.frame_count
        with self._lock:
            if self._state is AgentState.RUNNING:
                raise RuntimeError("cannot stage while VIDEO is running")
            self._staged = (manifest, source)
            self._frame_count = frame_count
            self._set_state(AgentState.STAGED)
            return self.snapshot

    def activate(self) -> RuntimeSnapshot:
        with self._lock:
            if self._state is AgentState.RUNNING:
                raise RuntimeError("cannot activate while VIDEO is running")
            if self._staged is None:
                raise RuntimeError("no staged video artifact")
            self._active = self._staged
            self._staged = None
            self._set_state(AgentState.ACTIVE)
            return self.snapshot

    def run(self) -> RuntimeSnapshot:
        with self._lock:
            if self._active is None:
                raise RuntimeError("no active video artifact")
            if self._state is AgentState.RUNNING:
                return self.snapshot
            if self._state is AgentState.PAUSED:
                self._resume.set()
                self._resumed.set()
                self._set_state(AgentState.RUNNING)
                return self.snapshot
            if self._state is AgentState.ERROR:
                raise RuntimeError("VIDEO runtime is in an error state")
            self._stopped.clear()
            self._resume.set()
            self._resumed.clear()
            self._stats = C6IVideoStats()
            self._set_state(AgentState.RUNNING)
            thread = threading.Thread(
                target=self._play,
                args=(self._active[1],),
                name="voice-view-c6i-video",
                daemon=True,
            )
            self._thread = thread
            thread.start()
            return self.snapshot

    def pause(self) -> RuntimeSnapshot:
        with self._lock:
            if self._state is AgentState.PAUSED:
                return self.snapshot
            if self._state is not AgentState.RUNNING:
                raise RuntimeError("VIDEO runtime is not running")
            self._resume.clear()
            self._set_state(AgentState.PAUSED)
            return self.snapshot

    def seek(self, frame_index: int) -> RuntimeSnapshot:
        if type(frame_index) is not int or frame_index < 0:
            raise ValueError("seek requires a non-negative frame_index")
        with self._lock:
            active = self._active
            if active is None:
                raise RuntimeError("no active video artifact")
            if self._state in (AgentState.IDLE, AgentState.STAGED, AgentState.STOPPING, AgentState.ERROR):
                raise RuntimeError("VIDEO runtime is not seekable")
        with S2V1Reader(active[1]) as reader:
            if frame_index >= reader.frame_count:
                raise ValueError("seek frame is outside the active video")
        with self._lock:
            self._seek_requested = frame_index
            self._seek_event.set()
            self._generation += 1
            return self.snapshot

    def stop(self) -> RuntimeSnapshot:
        with self._lock:
            thread = self._thread
            if thread is None:
                if self._state is not AgentState.ERROR:
                    self._set_state(AgentState.IDLE)
                return self.snapshot
            self._set_state(AgentState.STOPPING)
            self._stopped.set()
            self._resume.set()
            self._seek_event.set()
        thread.join(self._timeout_seconds + 1.0)
        if thread.is_alive():
            with self._lock:
                self._set_error("VIDEO playback thread did not stop before timeout")
                return self.snapshot
        with self._lock:
            self._thread = None
            if self._state is not AgentState.ERROR:
                self._set_state(AgentState.IDLE)
            return self.snapshot

    def close(self) -> None:
        self.stop()

    def _play(self, path: Path) -> None:
        sink: _VideoSink | None = None
        try:
            with S2V1Reader(path) as reader:
                sink = self._sink_factory(self._session, self._timeout_seconds)
                sink.upload_tilemap(reader.read_tilemap_packet())
                period = 1.0 / S2V1_FPS
                presented = 0
                completed_loops = 0
                start_frame = self._consume_seek(default=0)
                target = time.perf_counter()
                while not self._stopped.is_set():
                    seeking = False
                    for frame in reader.iter_packet_frames(start_frame=start_frame):
                        action = self._wait_for_playback_slot(target)
                        if action == "stopped":
                            return
                        if action == "seek":
                            start_frame = self._consume_seek(default=0)
                            target = time.perf_counter()
                            seeking = True
                            break
                        if action == "resume":
                            target = time.perf_counter()
                        if frame.palette_packet is not None:
                            sink.upload_palette(frame.palette_packet)
                        sink.upload_asset(frame.asset_packet)
                        sink.submit_scene(frame.scene_packet)
                        presented += 1
                        with self._lock:
                            self._stats = C6IVideoStats(
                                presented_frames=presented,
                                completed_loops=completed_loops,
                                last_frame_index=frame.frame_index,
                            )
                        target += period
                        if self._seek_event.is_set():
                            start_frame = self._consume_seek(default=0)
                            target = time.perf_counter()
                            seeking = True
                            break
                    if seeking:
                        continue
                    completed_loops += 1
                    start_frame = 0
                    with self._lock:
                        self._stats = C6IVideoStats(
                            presented_frames=presented,
                            completed_loops=completed_loops,
                            last_frame_index=self._stats.last_frame_index,
                        )
        except Exception as error:
            with self._lock:
                self._set_error(str(error))
        finally:
            if sink is not None:
                sink.close()

    def _wait_for_playback_slot(self, target: float) -> str:
        while True:
            if self._stopped.is_set():
                return "stopped"
            if self._seek_event.is_set():
                return "seek"
            if self._resumed.is_set():
                self._resumed.clear()
                return "resume"
            if not self._resume.is_set():
                self._stopped.wait(0.01)
                continue
            delay = target - time.perf_counter()
            if delay <= 0:
                return "play"
            if self._stopped.wait(min(delay, 0.01)):
                return "stopped"

    def _consume_seek(self, *, default: int) -> int:
        with self._lock:
            frame_index = self._seek_requested
            self._seek_requested = None
            self._seek_event.clear()
            return default if frame_index is None else frame_index

    @staticmethod
    def _create_sink(session: C6IOverlaySession, timeout_seconds: float) -> C6IVideoSink:
        return C6IVideoSink(session=session, timeout_seconds=timeout_seconds)

    def _set_state(self, state: AgentState) -> None:
        self._state = state
        self._generation += 1

    def _set_error(self, message: str) -> None:
        self._stats = C6IVideoStats(
            presented_frames=self._stats.presented_frames,
            completed_loops=self._stats.completed_loops,
            last_frame_index=self._stats.last_frame_index,
            last_error=message,
        )
        self._set_state(AgentState.ERROR)