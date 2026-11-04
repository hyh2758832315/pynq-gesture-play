"""Build a separate SHA-checked, board-pending PS UI candidate from frozen R23b2."""

from __future__ import annotations

import argparse
import ast
import hashlib
import json
from pathlib import Path
import shutil
import sys
from tempfile import TemporaryDirectory


ROOT = Path(__file__).resolve().parents[3]
BASE = ROOT / "deliveries/c6i-pl-vision-button-osd-r23b2-shared-id-boardtest-20261024"
SOURCE = ROOT / "subprojects/ps_ui_r23b2"
DELTA = (
    "python/pynq_multimodal_game/gpu_abi.py",
    "python/pynq_multimodal_game/video_codec.py",
    "python/pynq_multimodal_game/renderer.py",
    "python/pynq_multimodal_game/scene_compiler.py",
    "python/pynq_multimodal_game/scene.py",
    "board/pynq_z2/vision_dma_pool.py",
    "board/pynq_z2/vision_latest_capture.py",
    "board/pynq_z2/scripts/vision_async_runtime.py",
    "hand_child/mock_motion_receiver.py",
    "python/pynq_multimodal_game/button_input.py",
    "python/pynq_multimodal_game/hand_startup.py",
    "python/pynq_multimodal_game/hand_shadow_bridge.py",
    "python/pynq_multimodal_game/hand_mock_session.py",
    "python/pynq_multimodal_game/hand_serial_session.py",
    "hand_child/serial_motion_receiver.py",
    "hand_child/serial_sources.json",
    "python/pynq_multimodal_game/game_seeds.py",
    "python/pynq_multimodal_game/game_runner.py",
    "python/pynq_multimodal_game/video_seeds.py",
    "python/pynq_multimodal_game/menu.py",
    "python/pynq_multimodal_game/creative_pages.py",
    "python/pynq_multimodal_game/shell_pages.py",
    "python/pynq_multimodal_game/shell_theme.py",
    "python/pynq_multimodal_game/data/pynq_wordmark.json",
    "python/pynq_multimodal_game/data/demo_geometry.json",
    "python/pynq_multimodal_game/return_button.py",
    "python/pynq_multimodal_game/pause_menu.py",
    "python/pynq_multimodal_game/startup_checks.py",
    "python/pynq_multimodal_game/startup_ui.py",
    "python/pynq_multimodal_game/vision_input.py",
    "python/pynq_multimodal_game/studio/vision_receiver.py",
    "python/pynq_multimodal_game/vision_preview.py",
    "python/pynq_multimodal_game/preview_recovery.py",
    "python/pynq_multimodal_game/vision_preview_render.py",
    "python/pynq_multimodal_game/agent/c6i_shell.py",
    "python/pynq_multimodal_game/agent/c6i_video.py",
    "python/pynq_multimodal_game/agent/button_osd_backend.py",
    "python/pynq_multimodal_game/agent/cli.py",
    "python/pynq_multimodal_game/agent/game_runtime.py",
    "python/pynq_multimodal_game/agent/video_runtime.py",
    "python/pynq_multimodal_game/agent/vision_backend.py",
    "python/pynq_multimodal_game/agent/pl_button_factory.py",
    "start_board_test.py",
)


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest().upper()


def verify_manifest(root: Path, identities: dict[str, str]) -> None:
    for name, expected in identities.items():
        path = (root / name).resolve(strict=True)
        if not path.is_relative_to(root.resolve()) or digest(path) != expected:
            raise ValueError(f"package SHA mismatch: {name}")


GAME_DISPLAY_NAMES = {"game1": "SKY RUN", "game2": "RPS", "game3": "HAND QUEST", "game4":"SNAKE DUEL"}


def stage_gesture_project(item_id: str, destination: Path, *, include_tests: bool = False) -> None:
    """Materialize one editable source tree used by both Studio and board seeds."""
    original = ROOT / "games" / item_id
    display_name = GAME_DISPLAY_NAMES[item_id]
    destination.mkdir()
    shutil.copytree(original / "src", destination / "src",
                    ignore=shutil.ignore_patterns("__pycache__", "*.pyc"))
    lines = (original / "game.toml").read_text(encoding="utf-8").splitlines()
    matches = [index for index, line in enumerate(lines) if line.startswith("display_name = ")]
    if len(matches) != 1:
        raise ValueError(f"unexpected game display name: {item_id}")
    lines[matches[0]] = f'display_name = "{display_name}"'
    targets = [index for index, line in enumerate(lines) if line.startswith("build_id = ")]
    if len(targets) != 1:
        raise ValueError(f"unexpected game target: {item_id}")
    lines[targets[0]] = "build_id = 3221622784"  # 0xC0061000
    (destination / "game.toml").write_text("\n".join(lines) + "\n", encoding="utf-8")
    if item_id in ("game1", "game3"):
        shutil.copy2(SOURCE / "game_overrides" / f"{item_id}_input_adapter.py",
                     destination / "src/input_adapter.py")
        shutil.copy2(ROOT / "subprojects/button_only/games" / f"{item_id}-button-v1/src/button_main.py",
                     destination / "src/button_main.py")
        manifest_path = destination / "game.toml"
        text = manifest_path.read_text(encoding="utf-8")
        if text.count('entrypoint = "src.main:create_game"') != 1:
            raise ValueError(f"unexpected game entrypoint: {item_id}")
        manifest_path.write_text(text.replace('entrypoint = "src.main:create_game"',
                                             'entrypoint = "src.button_main:create_game"'), encoding="utf-8")
    if item_id == "game1":
        shutil.copy2(SOURCE / "game_overrides/game1_level.py", destination / "src/level.py")
    if item_id == "game3":
        shutil.copy2(SOURCE / "game_overrides/game3_button_main.py", destination / "src/button_main.py")
        shutil.copy2(SOURCE / "game_overrides/game3_scene_builder.py", destination / "src/scene_builder.py")
    if not include_tests:
        return
    replays = destination / "tests/replays"
    replays.mkdir(parents=True)
    if item_id == "game1":
        case = dict(schema_version=2, test_id="hand-no-skills", name="手势不会触发按键技能",
                    seed=0, max_ticks=2,
                    events=[dict(tick=0, kind="gesture", event_id="attack", x=160, y=90, gesture="scissors"),
                            dict(tick=1, kind="gesture", event_id="shield", x=160, y=90, gesture="paper"),
                            dict(tick=2, kind="gesture", event_id="move", x=319, y=90, gesture="paper")],
                    assertions=[dict(tick=0, field="values.attacks_fired", operator="eq", expected=0),
                                dict(tick=1, field="values.shield_active", operator="eq", expected=False),
                                dict(tick=2, field="values.shield_active", operator="eq", expected=False)])
        cases = [("hand-attack-shield.json", case)]
    elif item_id == "game3":
        # The timeline schema has no physical-button events. Keep visual tests
        # honest; actual button mechanisms are covered by GameRunner integration.
        case = dict(schema_version=2, test_id="hand-no-mechanisms", name="手势选角且不触发机关",
                    seed=0, max_ticks=20,
                    events=[dict(tick=0, kind="gesture", event_id="choose", x=319, y=90, gesture="fist"),
                            dict(tick=1, kind="gesture", event_id="scissors", x=160, y=90, gesture="scissors"),
                            dict(tick=10, kind="gesture", event_id="paper", x=160, y=90, gesture="paper")],
                    assertions=[dict(tick=0, field="values.character", operator="eq", expected="female"),
                                dict(tick=20, field="values.note_hits", operator="eq", expected=0),
                                dict(tick=20, field="values.lift_phase", operator="eq", expected="IDLE")])
        cases = [("hand-no-mechanisms.json", case)]
    else:
        cases = [(path.name, json.loads(path.read_text(encoding="utf-8")))
                 for path in sorted((original / "tests/replays").glob("*.json"))]
    if item_id=='game3':
        cases += [(p.name,json.loads(p.read_text(encoding='utf-8'))) for p in
                  sorted((original/'tests/replays').glob('kingdom-0[123]-*.json'))]
    for name, case in cases:
        if any(event["kind"] in ("tone", "voice", "volume") for event in case["events"]):
            raise ValueError("gesture project must not include sound replay events")
        (replays / name).write_text(json.dumps(case, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    if __package__:
        from .pc_examples import example
    else:
        from pc_examples import example
    (replays/'00-pc-example.json').write_text(json.dumps(example(item_id,ROOT),ensure_ascii=False,indent=2)+'\n',encoding='utf-8')


def copy_studio_content(output: Path, receipt_path: Path):
    """Package Studio's validated bytes; never build a second version of a game."""
    sys.path.insert(0,str(ROOT/'python'))
    from pynq_multimodal_game.game_package import validate_game_package
    from pynq_multimodal_game.video_codec import S2V1Reader
    receipt=json.loads(Path(receipt_path).read_text(encoding='utf-8'))
    if receipt.get('status') not in ('validated','complete') or receipt.get('target_build_id')!=0xC0061000:
        raise ValueError('A successful Studio validation receipt is required')
    games={};videos={};catalog=[]
    for record in receipt['items']:
        source=Path(record['package']).resolve(strict=True)
        if not source.is_relative_to(ROOT):raise ValueError('Studio artifact must be in workspace')
        if digest(source).lower()!=record['sha256'] or source.stat().st_size!=record['length']:
            raise ValueError('Studio artifact changed after validation')
        item_id=record['item_id']
        if record['kind']=='game':
            if item_id in games:raise ValueError('Duplicate Studio game')
            info=validate_game_package(source)
            if (info.manifest.game_id!=item_id or info.manifest.target_build_id!=0xC0061000
                    or info.manifest.display_name!=GAME_DISPLAY_NAMES[item_id]
                    or not record['tests'] or not all(t['passed'] and t['assertions'] for t in record['tests'])):
                raise ValueError('Studio game must have passing asserted tests')
            name=f'seed_games/{item_id}.vvg';games[item_id]=name
        else:
            with S2V1Reader(source) as reader:
                if reader.frame_count!=record['frames']:raise ValueError('Studio video frame mismatch')
            name=f'seed_videos/default-{len(catalog)+1}.s2v'
            catalog.append(dict(item_id=item_id,display_name=record['display_name'],path=name,
                                sha256=record['sha256']))
            videos[name]=record['sha256'].upper()
        target=output/name;target.parent.mkdir(exist_ok=True)
        shutil.copy2(source,target)
    if set(games)!=set(GAME_DISPLAY_NAMES) or len(catalog)!=2:
        raise ValueError('Studio receipt must contain four games and two default videos')
    name='seed_videos/catalog.json'
    (output/name).write_text(json.dumps(dict(schema=1,videos=catalog),indent=2)+'\n',encoding='utf-8')
    videos[name]=digest(output/name)
    return {name:digest(output/name) for name in games.values()},videos


def build(output: Path, studio_receipt: Path, hand_candidate: Path | None = None) -> dict:
    output = output.resolve()
    if not output.is_relative_to((ROOT / "build").resolve()):
        raise ValueError("candidate output must be inside the workspace build directory")
    if output.exists():
        raise FileExistsError(f"candidate output already exists: {output}")
    manifest_path = BASE / "deployment_manifest.json"
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    if (manifest.get("backend") != "c6i-vision-button"
            or manifest.get("release_ready") is not False
            or manifest.get("board_pending") is not True):
        raise ValueError("unexpected frozen deployment identity")
    verify_manifest(BASE, manifest["sha256"])
    for name in DELTA:
        if not (SOURCE / name).is_file():
            raise FileNotFoundError(f"candidate source missing: {name}")
    shutil.copytree(BASE, output, ignore=shutil.ignore_patterns("__pycache__", "*.pyc"))
    for name in DELTA:
        target = output / name
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(SOURCE / name, target)
    bundled,bundled_videos=copy_studio_content(output,studio_receipt)
    bundled_hand={}
    if hand_candidate is not None:
        pins=json.loads((SOURCE/'hand_child/serial_sources.json').read_text(encoding='utf-8'))
        for name,expected in pins['sha256'].items():
            if digest(hand_candidate/name).lower()!=expected:
                raise ValueError('Bundled hand source identity mismatch: '+name)
        bridge=ast.parse((output/'python/pynq_multimodal_game/hand_shadow_bridge.py').read_text(encoding='utf-8'))
        constants={target.id:ast.literal_eval(node.value)
                   for node in bridge.body if isinstance(node,ast.Assign)
                   for target in node.targets if isinstance(target,ast.Name)
                   and target.id in ('SHADOW_SOURCE_SHA256','SERIAL_MANIFEST_SHA256')}
        if constants['SERIAL_MANIFEST_SHA256']!=digest(output/'hand_child/serial_sources.json').lower():
            raise ValueError('Bundled hand serial manifest pin mismatch')
        for name,expected in constants['SHADOW_SOURCE_SHA256'].items():
            if digest(hand_candidate/name).lower()!=expected:
                raise ValueError('Bundled hand shadow source pin mismatch: '+name)
        startup=ast.parse((output/'python/pynq_multimodal_game/hand_startup.py').read_text(encoding='utf-8'))
        readonly={target.id:ast.literal_eval(node.value)
                  for node in startup.body if isinstance(node,ast.Assign)
                  for target in node.targets if isinstance(target,ast.Name)
                  and target.id in ('READONLY_SOURCE_SHA256','FROZEN_MANIFEST_SHA256')}
        for name,expected in readonly['READONLY_SOURCE_SHA256'].items():
            if digest(hand_candidate/name).lower()!=expected:
                raise ValueError('Bundled hand read-only source pin mismatch: '+name)
        if digest(hand_candidate/'frozen_manifest.json').lower()!=readonly['FROZEN_MANIFEST_SHA256']:
            raise ValueError('Bundled hand frozen manifest pin mismatch')
        destination=output/'hand-runtime'
        shutil.copytree(hand_candidate,destination,
                        ignore=shutil.ignore_patterns('__pycache__','*.pyc','.pytest_cache'))
        bundled_hand={p.relative_to(output).as_posix():digest(p)
                      for p in destination.rglob('*') if p.is_file()}
    changed = {name: digest(output / name) for name in DELTA}
    record = {
        "schema": "ps-ui-r24-offline-candidate-v1",
        "base_manifest_sha256": digest(manifest_path),
        "changed_sha256": changed,
        "bundled_games_sha256": bundled,
        "bundled_videos_sha256": bundled_videos,
        "bundled_hand_sha256": bundled_hand,
        "board_pending": True,
        "hardware_tested": False,
        "release_ready": False,
        "studio_receipt_sha256":digest(studio_receipt),
    }
    (output / "candidate_delta.json").write_text(
        json.dumps(record, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    manifest["sha256"].update(changed)
    manifest["sha256"].update(bundled)
    manifest["sha256"].update(bundled_videos)
    manifest['sha256'].update(bundled_hand)
    manifest["sha256"]["candidate_delta.json"] = digest(output / "candidate_delta.json")
    (output / "deployment_manifest.json").write_text(
        json.dumps(manifest, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    verify_manifest(output, manifest["sha256"])
    actual = {path.relative_to(output).as_posix() for path in output.rglob("*") if path.is_file()}
    if actual != set(manifest["sha256"]) | {"deployment_manifest.json"}:
        raise ValueError("candidate has unlisted or missing files")
    return {"output": str(output), "files": len(manifest["sha256"]),
            "changed": len(changed), "bundled_games": len(bundled),
            "bundled_videos": len(bundled_videos)-1,
            "manifest_sha256": digest(output / "deployment_manifest.json"),
            "release_ready": False, "board_pending": True}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=ROOT / "build/ps-ui-r24-offline-package")
    parser.add_argument('--studio-receipt',type=Path,required=True)
    parser.add_argument('--hand-candidate',type=Path)
    options=parser.parse_args()
    result = build(options.output,options.studio_receipt,options.hand_candidate)
    print(json.dumps(result, ensure_ascii=False, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
