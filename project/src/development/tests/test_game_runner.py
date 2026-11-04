from __future__ import annotations

from pathlib import Path

from pynq_multimodal_game.game_package import GamePackageBuilder
from pynq_multimodal_game.game_project import GameProject
from pynq_multimodal_game.game_runner import GamePreviewProcess, GameRunner
from pynq_multimodal_game.game_sdk import GameInput
from pynq_multimodal_game.scene import LOGICAL_HEIGHT, LOGICAL_WIDTH


def _package(tmp_path: Path) -> Path:
    project = GameProject.create(
        tmp_path / "project", game_id="preview", display_name="Preview"
    )
    return GamePackageBuilder().build(project.root, tmp_path / "preview.vvg").path


def _input(tick_id: int) -> GameInput:
    return GameInput.from_logical_position(
        tick_id=tick_id,
        timestamp_ns=tick_id * 16_666_667,
        x=200,
        y=100,
        fist_sequence=1,
        fist_event=tick_id == 1,
    )


def test_final_game_package_runs_through_renderer_and_compiler(tmp_path: Path) -> None:
    with GameRunner(_package(tmp_path), seed=7) as runner:
        first = runner.step(_input(1))
        second = runner.step(_input(2))

    assert first.snapshot.values == {"x": 200, "y": 100}
    assert len(first.rgb) == LOGICAL_WIDTH * LOGICAL_HEIGHT * 3
    assert first.command_count == 2
    assert first.scene_sha256 != second.scene_sha256
    assert first.asset_packet is not None
    assert first.palette_packet is not None
    assert first.tilemap_packet is not None
    assert second.asset_packet is None
    assert second.palette_packet is None
    assert second.tilemap_packet is None


def test_preview_pipe_keeps_exact_frames_and_closes_endpoints(tmp_path):
    package = _package(tmp_path)
    preview = GamePreviewProcess(package, render_rgb=False)
    try:
        preview.start()
        assert preview._worker_channel.closed
        with GameRunner(package, render_rgb=False) as runner:
            for tick in range(12):
                assert preview.step(_input(tick)) == runner.step(_input(tick))
    finally:
        preview.stop()
    assert not preview._process.is_alive() and preview._channel.closed


def test_preview_split_request_preserves_exact_frames_and_single_inflight(tmp_path):
    import pytest
    package = _package(tmp_path)
    preview = GamePreviewProcess(package, render_rgb=False)
    try:
        preview.start()
        with pytest.raises(RuntimeError, match="not pending"):
            preview.finish_step()
        with GameRunner(package, render_rgb=False) as runner:
            for tick in range(12):
                preview.begin_step(_input(tick))
                with pytest.raises(RuntimeError, match="already pending"):
                    preview.begin_step(_input(tick + 1))
                assert preview.finish_step() == runner.step(_input(tick))
    finally:
        preview.stop()
    assert preview._request_timing is None and preview._process.exitcode == 0


def test_preview_stop_finishes_pending_rgb_response_without_termination(tmp_path):
    preview = GamePreviewProcess(_package(tmp_path))
    preview.start()
    preview.begin_step(_input(0))
    preview.stop()
    assert preview._request_timing is None and preview._process.exitcode == 0
    assert preview._channel.closed and preview._worker_channel.closed


def test_preview_pipe_receive_preserves_timeout_exception():
    from queue import Empty
    from types import SimpleNamespace
    import pytest
    preview = object.__new__(GamePreviewProcess)
    preview._channel = SimpleNamespace(poll=lambda timeout: False)
    with pytest.raises(Empty):
        preview._receive(.01)


def test_asset_packet_reuse_keeps_exact_bytes_and_invalidates_content_and_generation(tmp_path, monkeypatch):
    from dataclasses import replace
    from pynq_multimodal_game import game_runner
    original = game_runner.pack_asset_bundle_packet
    calls = []

    def pack(assets, *, generation):
        calls.append((assets, generation))
        return original(assets, generation=generation)

    monkeypatch.setattr(game_runner, "pack_asset_bundle_packet", pack)
    with GameRunner(_package(tmp_path), render_rgb=False) as runner:
        first = runner.step(_input(0))
        assert first.asset_packet == original(runner._compiler.assets, generation=runner._generation)
        assert runner.step(_input(1)).asset_packet is None and len(calls) == 1
        asset = runner._compiler.assets[0]
        runner._compiler.assets = (replace(asset, pixels=bytes(
            [(asset.pixels[0] + 1) % 16]) + asset.pixels[1:]), *runner._compiler.assets[1:])
        changed = runner.step(_input(2))
        assert changed.asset_packet == original(runner._compiler.assets, generation=runner._generation)
        assert changed.asset_packet != first.asset_packet and len(calls) == 2
        runner._generation += 1
        regenerated = runner.step(_input(3))
        assert regenerated.asset_packet == original(runner._compiler.assets, generation=runner._generation)
        assert regenerated.asset_packet != changed.asset_packet and len(calls) == 3
        assert runner.step(_input(4)).asset_packet is None and len(calls) == 3


def test_mutable_asset_pixels_are_repacked_instead_of_reused(tmp_path, monkeypatch):
    from dataclasses import replace
    from pynq_multimodal_game import game_runner
    original = game_runner.pack_asset_bundle_packet
    calls = []

    def pack(assets, *, generation):
        calls.append(assets)
        return original(assets, generation=generation)

    monkeypatch.setattr(game_runner, "pack_asset_bundle_packet", pack)
    with GameRunner(_package(tmp_path), render_rgb=False) as runner:
        asset = runner._compiler.assets[0]
        pixels = bytearray(asset.pixels)
        runner._compiler.assets = (replace(asset, pixels=pixels), *runner._compiler.assets[1:])
        first = runner.step(_input(0))
        pixels[0] = (pixels[0] + 1) % 16
        changed = runner.step(_input(1))
        assert changed.asset_packet != first.asset_packet and len(calls) == 2


def test_palette_and_tilemap_reuse_invalidates_content_and_generation(tmp_path, monkeypatch):
    from dataclasses import replace
    from pynq_multimodal_game import game_runner
    from pynq_multimodal_game.scene import TileDescriptor, TileLayer
    original_palette, original_tilemap = game_runner.pack_palette_packet, game_runner.pack_tilemap_packet
    palette_calls, tilemap_calls = [], []

    def palette(banks, *, generation):
        palette_calls.append(banks)
        return original_palette(banks, generation=generation)

    def tilemap(layer, *, target_id, generation):
        tilemap_calls.append(layer)
        return original_tilemap(layer, target_id=target_id, generation=generation)

    monkeypatch.setattr(game_runner, "pack_palette_packet", palette)
    monkeypatch.setattr(game_runner, "pack_tilemap_packet", tilemap)
    with GameRunner(_package(tmp_path), render_rgb=False) as runner:
        first = runner.step(_input(0))
        assert runner.step(_input(1)).palette_packet is None
        assert len(palette_calls) == len(tilemap_calls) == 1
        palettes = runner._compiler.palettes
        color = palettes.banks[0][1]
        runner._compiler.palettes = replace(palettes, banks=(
            (palettes.banks[0][0], ((color[0] + 1) % 256, *color[1:]),
             *palettes.banks[0][2:]), *palettes.banks[1:]))
        changed_palette = runner.step(_input(2))
        assert changed_palette.palette_packet == original_palette(palette_calls[-1], generation=runner._generation)
        assert changed_palette.palette_packet != first.palette_packet
        assert changed_palette.asset_packet is None and changed_palette.tilemap_packet is None
        build_scene = runner._plugin.build_scene
        layer = TileLayer(2, 1, (TileDescriptor(0, flip_x=True), TileDescriptor(0)))
        monkeypatch.setattr(runner._plugin, "build_scene", lambda: replace(build_scene(), tile_layer=layer))
        changed_tilemap = runner.step(_input(3))
        assert changed_tilemap.tilemap_packet == original_tilemap(layer, target_id=0, generation=runner._generation)
        assert changed_tilemap.tilemap_packet != first.tilemap_packet
        assert changed_tilemap.asset_packet is None and changed_tilemap.palette_packet is None
        assert len(palette_calls) == len(tilemap_calls) == 2
        runner._generation += 1
        regenerated = runner.step(_input(4))
        assert regenerated.palette_packet == original_palette(palette_calls[-1], generation=runner._generation)
        assert regenerated.tilemap_packet == original_tilemap(layer, target_id=0, generation=runner._generation)
        assert regenerated.asset_packet is not None
        assert len(palette_calls) == len(tilemap_calls) == 3


def test_side_scroller_project_template_builds_and_runs(tmp_path: Path) -> None:
    project = GameProject.create(
        tmp_path / "side-scroller",
        game_id="side-scroller-test",
        display_name="Side Scroller Test",
        template="side-scroller",
    )
    package = GamePackageBuilder().build(project.root, tmp_path / "side-scroller.vvg")

    with GameRunner(package.path) as runner:
        frame = runner.step(
            GameInput.from_logical_position(
                tick_id=0,
                timestamp_ns=0,
                x=319,
                y=90,
                fist_sequence=0,
                fist_event=False,
            )
        )

    assert frame.snapshot.values is not None
    assert frame.snapshot.values["world_x"] == 4
    assert frame.snapshot.status == "RUNNING"
    assert frame.command_count >= 2


def test_sequential_packages_with_same_entrypoint_are_isolated(tmp_path: Path) -> None:
    first_package = _package(tmp_path / "first")
    second_package = _package(tmp_path / "second")

    with GameRunner(first_package) as runner:
        assert runner.step(_input(1)).snapshot.values == {"x": 200, "y": 100}
    with GameRunner(second_package) as runner:
        assert runner.step(_input(2)).snapshot.values == {"x": 200, "y": 100}


def test_game_package_runs_in_isolated_preview_process(tmp_path: Path) -> None:
    preview = GamePreviewProcess(_package(tmp_path), seed=7)
    try:
        info = preview.start()
        frame = preview.step(_input(1))
    finally:
        preview.stop()

    assert info.manifest.game_id == "preview"
    assert frame.snapshot.tick_id == 1
    assert len(frame.rgb) == LOGICAL_WIDTH * LOGICAL_HEIGHT * 3


def test_board_preview_process_skips_rgb_rendering(tmp_path: Path) -> None:
    preview = GamePreviewProcess(_package(tmp_path), render_rgb=False)
    try:
        preview.start()
        frame = preview.step(_input(1))
    finally:
        preview.stop()

    assert frame.rgb == b""
    assert frame.frame_crc32 == 0
    assert frame.scene_packet
    timing = preview.last_step_timing
    assert timing["worker_cpu_ns"] >= 0 and timing["caller_cpu_ns"] >= 0
    assert timing["request_started_ns"] <= timing["worker_started_ns"]
    assert timing["worker_started_ns"] <= timing["worker_finished_ns"] <= timing["response_received_ns"]
    assert timing["worker_wall_ns"] == timing["worker_finished_ns"] - timing["worker_started_ns"]
    assert timing["request_wall_ns"] == timing["response_received_ns"] - timing["request_started_ns"]
