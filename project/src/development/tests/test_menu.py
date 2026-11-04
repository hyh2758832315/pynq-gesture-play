from __future__ import annotations

from dataclasses import replace
import hashlib

from pynq_multimodal_game.controls import (
    ControlSource,
    ControlState,
    Direction,
    StaleFlag,
)
from pynq_multimodal_game.gpu_abi import COMMAND_CAPACITY, pack_asset_bundle_packet
from pynq_multimodal_game.menu import (
    HOME_TARGETS,
    MenuIcon,
    MenuInputController,
    MenuPage,
    build_menu_scene,
    create_menu_assets,
    game_targets,
    hand_display_selection,
    hand_display_targets,
    library_targets,
    normalize_menu_label,
    placeholder_targets,
)
from pynq_multimodal_game.return_button import (
    RETURN_CENTER, RETURN_DWELL_NS, RETURN_HIT_RADIUS, RETURN_SIZE,
)
from pynq_multimodal_game.scene_compiler import CommandRenderer, SceneCompiler


def _control(**changes: object) -> ControlState:
    state = ControlState(
        tick_id=0,
        timestamp_ns=0,
        gesture_source=ControlSource.REAL,
        gesture_seq=0,
        hand_valid=True,
        hand_x=-0.42,
        hand_y=-0.38,
        direction=Direction.IDLE,
        fist_score=0.0,
        fist_event=False,
        voice_source=ControlSource.REAL,
        voice_seq=0,
        audio_valid=False,
        low_voice_active=False,
        high_voice_event=False,
        low_confidence=0.0,
        high_confidence=0.0,
    )
    return replace(state, **changes)


def test_home_scene_has_distinct_circular_icons_and_fits_hardware_budget() -> None:
    assets = create_menu_assets()
    compiler = SceneCompiler(
        sprite_atlas=assets.sprite_atlas,
        tile_atlas=assets.tile_atlas,
        palettes=assets.palettes,
    )
    scene = build_menu_scene(12, hovered_id="videos", animate=False)
    frame = compiler.compile(scene)
    rendered = CommandRenderer().render(frame)

    assert len(scene.sprites) == 5
    assert len(frame.commands) == 7
    assert scene.sprites[0].x == scene.sprites[0].y == 0
    assert scene.sprites[0].width == scene.sprites[0].height == 24
    assert len(frame.commands) <= COMMAND_CAPACITY
    assert len(pack_asset_bundle_packet(frame.assets, generation=1)) < 32 * 1024
    assert len(rendered) == 320 * 180 * 3
    icon_hashes = {
        hashlib.sha256(
            b"".join(
                assets.sprite_atlas.pixels[
                    y * assets.sprite_atlas.width + index * 48 :
                    y * assets.sprite_atlas.width + (index + 1) * 48
                ]
                for y in range(48)
            )
        ).hexdigest()
        for index in range(4)
    }
    assert len(icon_hashes) == 4
    assert assets.sprite_atlas.pixels[0] == 0


def test_menu_requires_stable_hover_then_activates_once_per_gesture() -> None:
    controller = MenuInputController(stable_ticks=3)

    assert controller.update(_control(tick_id=0)).hovered_id is None
    assert controller.update(_control(tick_id=1)).hovered_id is None
    hovered = controller.update(_control(tick_id=2))
    activated = controller.update(
        _control(tick_id=3, gesture_seq=1, fist_event=True, fist_score=1.0)
    )
    duplicate = controller.update(
        _control(tick_id=4, gesture_seq=1, fist_event=True, fist_score=1.0)
    )

    assert hovered.hovered_id == "games"
    assert activated.activated_id == "games"
    assert duplicate.activated_id is None


def test_menu_clears_hover_for_invalid_or_stale_gesture() -> None:
    controller = MenuInputController(stable_ticks=1)
    assert controller.update(_control()).hovered_id == "games"

    invalid = controller.update(_control(hand_valid=False))
    stale = controller.update(
        _control(stale_flags=StaleFlag.GESTURE, tick_id=2)
    )

    assert invalid.hovered_id is None
    assert invalid.pointer_x is None
    assert stale.hovered_id is None


def test_menu_mirror_and_library_pagination_use_fixed_targets() -> None:
    normal = MenuInputController(stable_ticks=1)
    mirrored = MenuInputController(stable_ticks=1, mirror_horizontal=True)

    assert normal.update(_control()).hovered_id == "games"
    assert mirrored.update(_control()).hovered_id == "videos"
    targets = library_targets(
        MenuIcon.VIDEO,
        ("one", "two", "three", "four", "five"),
        page=1,
    )
    assert [target.item_id for target in targets] == ["back", "five"]
    assert targets[1].center_x == HOME_TARGETS[1].center_x


def test_placeholder_pages_expose_only_content_and_back_targets() -> None:
    hand_targets = placeholder_targets(MenuPage.HAND_PLACEHOLDER)
    reserved_targets = placeholder_targets(MenuPage.RESERVED)

    assert [target.item_id for target in hand_targets] == [
        "back",
        "hand-placeholder",
    ]
    assert hand_targets[1].icon is MenuIcon.HAND
    assert reserved_targets[1].icon is MenuIcon.RESERVED


def test_hand_page_shows_four_display_only_poses_with_one_selected() -> None:
    targets = hand_display_targets()
    assert [target.item_id for target in targets] == [
        "back", "hand:default", "hand:paper", "hand:scissors", "hand:rock",
    ]
    assert all(not target.enabled for target in targets[1:])
    assert hand_display_selection(None) == "hand:default"
    assert hand_display_selection({"valid": True, "gesture": "paper"}) == "hand:paper"
    assert hand_display_selection({"valid": True, "gesture": "scissors"}) == "hand:scissors"
    assert hand_display_selection({"valid": True, "gesture": "fist"}) == "hand:rock"
    assert hand_display_selection({"valid": False, "gesture": "fist"}) == "hand:default"
    scene = build_menu_scene(1, targets, hovered_id="hand:rock", animate=False,
                             label_texts=("DEFAULT", "PAPER", "SCISSORS", "ROCK"))
    assert len(scene.sprites) == 9
    icon_sprites = [sprite for sprite in scene.sprites if sprite.height in (24, 48)]
    assert [sprite.atlas_y for sprite in icon_sprites] == [0, 0, 0, 0, 48]
    assets = create_menu_assets(("DEFAULT", "PAPER", "SCISSORS", "ROCK"))
    frame = SceneCompiler(sprite_atlas=assets.sprite_atlas,
                          tile_atlas=assets.tile_atlas,
                          palettes=assets.palettes).compile(scene)
    assert len(frame.commands) <= COMMAND_CAPACITY
    assert len(assets.sprite_atlas.pixels) <= 65536
    assert len(assets.sprite_atlas.pixels) == len(
        create_menu_assets(("GAME", "VIDEO", "HAND", "MORE")).sprite_atlas.pixels)
    control = _control(fist_event=True, gesture_seq=1)
    assert MenuInputController(stable_ticks=1).update(control, targets).activated_id is None


def test_game_page_has_four_positions_with_inactive_future_slot() -> None:
    targets = game_targets(("game1", "game2", "game3"))
    assert [target.item_id for target in targets] == [
        "back", "game:game1", "game:game2", "game:game3", "game-slot:4"
    ]
    assert targets[-1].enabled is False
    assert [target.center_x for target in targets[1:]] == [92, 228, 92, 228]
    controller = MenuInputController(stable_ticks=1)
    slot = targets[-1]
    result = controller.update(_control(hand_x=slot.center_x * 2 / 319 - 1,
                                        hand_y=slot.center_y * 2 / 179 - 1,
                                        fist_event=True, gesture_seq=1), targets)
    assert result.activated_id is None
    assert result.hovered_id is None


def test_library_labels_share_atlas_and_fit_sprite_budget() -> None:
    labels = ("SINTEL DEMO", "VIDEO 2", "VIDEO-3", "VIDEO 4")
    assets = create_menu_assets(labels)
    targets = library_targets(
        MenuIcon.VIDEO, ("one", "two", "three", "four"), page=0
    )
    scene = build_menu_scene(1, targets, label_texts=labels, animate=False)
    frame = SceneCompiler(
        sprite_atlas=assets.sprite_atlas,
        tile_atlas=assets.tile_atlas,
        palettes=assets.palettes,
    ).compile(scene)

    assert len(scene.sprites) == 9
    assert len(scene.sprites) <= 16
    assert len(frame.commands) == 11
    assert len(pack_asset_bundle_packet(frame.assets, generation=1)) < 32 * 1024
    assert normalize_menu_label("Sintel_demo.mp4") == "SINTEL DEMO"


def test_back_requires_two_seconds_of_continuous_valid_hover_without_fist() -> None:
    controller = MenuInputController(stable_ticks=1)
    back = HOME_TARGETS[0]
    position = dict(hand_x=back.center_x * 2 / 319 - 1,
                    hand_y=back.center_y * 2 / 179 - 1)
    assert controller.update(_control(timestamp_ns=100, **position)).activated_id is None
    assert controller.update(_control(timestamp_ns=100 + RETURN_DWELL_NS - 1, **position)).activated_id is None
    assert controller.update(_control(timestamp_ns=100 + RETURN_DWELL_NS, **position)).activated_id == "back"
    assert controller.update(_control(timestamp_ns=100 + RETURN_DWELL_NS + 1, **position)).activated_id is None
    controller.update(_control(timestamp_ns=100 + RETURN_DWELL_NS + 2, hand_valid=False))
    assert controller.update(_control(timestamp_ns=100 + RETURN_DWELL_NS + 3, **position)).activated_id is None


def test_back_dwell_starts_at_circle_entry_even_before_hover_is_stable() -> None:
    controller = MenuInputController(stable_ticks=3)
    back = HOME_TARGETS[0]
    position = dict(hand_x=back.center_x * 2 / 319 - 1,
                    hand_y=back.center_y * 2 / 179 - 1)
    assert RETURN_SIZE == 24
    assert (back.center_x, back.center_y, back.hit_radius) == (
        *RETURN_CENTER, RETURN_HIT_RADIUS)
    assert controller.update(_control(timestamp_ns=100, **position)).hovered_id is None
    assert controller.update(_control(timestamp_ns=100 + 1_000_000_000,
                                      fist_event=True, gesture_seq=1,
                                      **position)).activated_id is None
    result = controller.update(_control(timestamp_ns=100 + RETURN_DWELL_NS,
                                        **position))
    assert result.hovered_id == result.activated_id == "back"
    assert controller.update(_control(timestamp_ns=100 + RETURN_DWELL_NS + 1,
                                      **position)).activated_id is None


def test_all_menu_pages_keep_back_at_canvas_origin() -> None:
    pages = (HOME_TARGETS, game_targets(("game1", "game2", "game3")),
             library_targets(MenuIcon.VIDEO, ("video",)),
             hand_display_targets(), placeholder_targets(MenuPage.RESERVED))
    for targets in pages:
        back = targets[0]
        sprite = build_menu_scene(0, targets, animate=False).sprites[0]
        assert back.item_id == "back"
        assert (sprite.x, sprite.y, sprite.width, sprite.height) == (
            0, 0, RETURN_SIZE, RETURN_SIZE)
