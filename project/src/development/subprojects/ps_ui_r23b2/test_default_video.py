"""Default content through the real library, menu and packet playback paths."""
from dataclasses import replace
import hashlib
from pathlib import Path
import shutil
import threading
import time
from types import SimpleNamespace

import numpy as np
import pytest

from pynq_multimodal_game.agent.c6i_shell import C6IShellRuntimeBackend, ShellMode
from pynq_multimodal_game.agent.core import AgentState
from pynq_multimodal_game.controls import ControlSource, MockControlAdapter, MockInput
from pynq_multimodal_game.library import AssetLibrary, LibraryKind
from pynq_multimodal_game.menu import MenuPage
from pynq_multimodal_game.video_codec import S2V1Reader, encode_rgb_frames
from pynq_multimodal_game.video_seeds import (
    BUTTON_BUILD_ID, SEED_VIDEO_ID, SEED_VIDEO_PATH, ensure_seed_videos,
)
from subprojects.ps_ui_r23b2.tools.build_default_video import FRAME_COUNT, frame_at

SOURCE = Path(__file__).resolve().parent


@pytest.fixture
def library(tmp_path):
    return AssetLibrary(tmp_path / "library", minimum_free_bytes=0, minimum_free_fraction=0)


def test_bundled_clip_is_complete_dynamic_and_loopable():
    source = SOURCE / SEED_VIDEO_PATH
    assert source.stat().st_size < 7 * 1024 * 1024
    assert np.array_equal(frame_at(0), frame_at(FRAME_COUNT))
    decoded = set()
    with S2V1Reader(source) as reader:
        assert reader.frame_count == FRAME_COUNT == 180
        assert len(reader.manifest["gops"]) == 1
        assert reader.manifest["video"]["fps"] == [30, 1]
        for frame in reader.iter_frames():
            assert len(frame.rgb) == 320 * 180 * 3
            decoded.add(hashlib.sha256(frame.rgb).digest())
        packets = list(reader.iter_packet_frames())
        assert sum(frame.palette_packet is not None for frame in packets) == 1
        assert max(len(frame.asset_packet) for frame in packets) == 30897
        assert max(len(frame.scene_packet) for frame in packets) == 4160
    assert len(decoded) > 90


def test_check_only_has_no_library_side_effect_and_restart_is_idempotent(library):
    assert ensure_seed_videos(SOURCE, library, install=False) == (SEED_VIDEO_ID,)
    assert not library.root.exists()
    assert ensure_seed_videos(SOURCE, library, install=True) == (SEED_VIDEO_ID,)
    entry, = library.scan(LibraryKind.VIDEO).entries
    before = (entry.directory / "manifest.json").read_bytes()
    assert ensure_seed_videos(SOURCE, library, install=True) == ()
    assert (entry.directory / "manifest.json").read_bytes() == before
    assert entry.manifest.display_name == "SUNSET"
    assert entry.manifest.sha256 == hashlib.sha256((SOURCE / SEED_VIDEO_PATH).read_bytes()).hexdigest()


def test_user_replacement_and_other_video_survive_startup(library, tmp_path):
    custom = tmp_path / "custom.s2v"
    encode_rgb_frames([frame_at(45)], custom)
    for item_id in (SEED_VIDEO_ID, "my-video"):
        library.install_file(custom, item_id=item_id, display_name="My video",
                             kind=LibraryKind.VIDEO, target_build_id=BUTTON_BUILD_ID)
    before = [(entry.manifest, entry.asset.read_bytes()) for entry in library.scan(LibraryKind.VIDEO).entries]
    assert ensure_seed_videos(SOURCE, library, install=True) == ()
    after = [(entry.manifest, entry.asset.read_bytes()) for entry in library.scan(LibraryKind.VIDEO).entries]
    assert before == after


@pytest.mark.parametrize("fault", ["corrupt", "wrong-build", "wrong-abi"])
def test_invalid_existing_seed_is_preserved_and_rejected(library, tmp_path, fault):
    source = tmp_path / "existing.s2v"
    if fault == "corrupt":
        source.write_bytes(b"not a video")
    else:
        shutil.copy2(SOURCE / SEED_VIDEO_PATH, source)
    entry = library.install_file(source, item_id=SEED_VIDEO_ID, display_name="Preserve me",
                                 kind=LibraryKind.VIDEO,
                                 target_build_id=0 if fault == "wrong-build" else BUTTON_BUILD_ID,
                                 abi_major=2 if fault == "wrong-abi" else 1)
    before = entry.asset.read_bytes()
    with pytest.raises(RuntimeError, match="installed default video"):
        ensure_seed_videos(SOURCE, library, install=True)
    assert entry.asset.read_bytes() == before


def test_bad_bundled_video_cannot_create_library(tmp_path, library):
    source = tmp_path / SEED_VIDEO_PATH
    source.parent.mkdir()
    source.write_bytes(b"bad zip")
    with pytest.raises(Exception):
        ensure_seed_videos(tmp_path, library, install=True)
    assert not library.root.exists()


def test_default_menu_selection_loop_pause_seek_and_return(library):
    ensure_seed_videos(SOURCE, library, install=True)

    class Sink:
        def __init__(self):
            self.scenes = 0
            self.presented = threading.Event()
        def upload_asset(self, packet): pass
        def upload_palette(self, packet): pass
        def upload_tilemap(self, packet): pass
        def submit_scene(self, packet):
            self.scenes += 1
            self.presented.set()
        def close(self): pass

    sink = Sink()
    session = SimpleNamespace(build_id=BUTTON_BUILD_ID, open=lambda: None)
    shell = C6IShellRuntimeBackend(session, menu_fps=0, library=library,
                                  sink_factory=lambda *_: sink)
    base = MockControlAdapter(ControlSource.KEYBOARD).sample(MockInput(), tick_id=0, timestamp_ns=0)

    def choose(item_id, sequence):
        target = next(target for target in shell._targets if target.item_id == item_id)
        # Each page requires a fresh release; holding the same fist across
        # pages must not activate a second item.
        for tick in range(2):
            shell.handle_control(replace(base, fist_event=False, fist_score=0.,
                timestamp_ns=(sequence * 10 + tick) * 100_000_000))
        results = []
        for tick in range(2, 5):
            results.append(shell.handle_control(replace(base,
                hand_x=target.center_x * 2 / 319 - 1, hand_y=target.center_y * 2 / 179 - 1,
                fist_score=1., gesture_seq=sequence, timestamp_ns=(sequence * 10 + tick) * 100_000_000)))
        assert results.count(item_id) == 1

    try:
        shell.open()
        choose("videos", 1)
        assert shell.page is MenuPage.VIDEOS and shell._labels[0] == "SUNSET"
        sink.presented.clear()
        choose("video:" + SEED_VIDEO_ID, 2)
        assert shell.mode is ShellMode.VIDEO
        assert sink.presented.wait(2)
        deadline = time.monotonic() + 9
        while shell._video.stats.completed_loops < 1 and time.monotonic() < deadline:
            time.sleep(.02)
        assert shell._video.stats.completed_loops >= 1
        assert shell._video.stats.presented_frames >= FRAME_COUNT
        assert shell._video.stats.last_error is None
        assert shell.pause().state is AgentState.PAUSED
        assert shell.seek(90).state is AgentState.PAUSED
        assert shell.run().state is AgentState.RUNNING
        assert shell.return_to_menu().state is AgentState.IDLE
        assert shell.mode is ShellMode.MENU and shell.page is MenuPage.HOME
        assert shell._video._thread is None
    finally:
        shell.close()
