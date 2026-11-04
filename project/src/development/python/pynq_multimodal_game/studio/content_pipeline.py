"""Prepare every item before touching the device; retain explicit per-item receipts."""
from dataclasses import dataclass
import hashlib
import json
from pathlib import Path
import shutil
import threading
import uuid
from zipfile import ZipFile

from ..game_testing import GameTestCase
from ..game_validation import build_verified_game, run_game_test
from ..video_codec import S2V1Reader, decode_video_frames, encode_rgb_frames
from .device import video_library_identity


@dataclass(frozen=True)
class ContentItem:
    kind: str
    path: Path
    title: str


def file_identity(path):
    digest = hashlib.sha256()
    length = 0
    with Path(path).open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
            length += len(chunk)
    return {"sha256": digest.hexdigest(), "length": length}


def load_content(items, device, output, *, stop_event=None, progress=None, prepare_only=False):
    """Build/test/encode once, then install serially; never start hardware playback.

    A failed batch is not atomic on the board. receipt.json preserves each confirmed
    install and any ambiguous in-flight install, including failures and cancellation.
    """
    stop = stop_event if stop_event is not None else threading.Event()
    report = progress or (lambda message: None)
    output = Path(output)
    output.mkdir(parents=True, exist_ok=False)
    receipt = {"status": "preparing", "target_build_id": device.expected_build_id,
               "items": [], "error": None}

    def save():
        pending = output / "receipt.pending"
        pending.write_text(json.dumps(receipt, ensure_ascii=False, indent=2), encoding="utf-8")
        pending.replace(output / "receipt.json")

    def check():
        if stop.is_set():
            raise RuntimeError("任务已取消")

    try:
        if not items:
            raise ValueError("请选择需要加载的内容")
        prepared = []
        identities = set()
        for index, item in enumerate(items):
            check()
            record = {"kind": item.kind, "source": str(item.path), "title": item.title,
                      "state": "preparing"}
            receipt["items"].append(record)
            folder = output / str(index + 1)
            folder.mkdir()
            report(f"准备 {index + 1}/{len(items)}：{item.title}")
            if item.kind == "game":
                package = folder / "game.vvg"
                info = build_verified_game(item.path, package,
                                           target_build_id=device.expected_build_id)
                key = ("game", info.manifest.game_id)
                if key in identities:
                    raise ValueError(f"重复的游戏 ID：{info.manifest.game_id}")
                identities.add(key)
                with ZipFile(package) as archive:
                    cases = [GameTestCase.from_json(archive.read(name))
                             for name in sorted(archive.namelist())
                             if name.startswith("tests/replays/") and name.endswith(".json")]
                if not cases:
                    cases = [GameTestCase(test_id="load-smoke", name="加载烟测", max_ticks=60)]
                record["tests"] = []
                for case_index, case in enumerate(cases):
                    check()
                    report(f"PC 验证 {item.title} · {case.name}")
                    result = run_game_test(package, case, stop_event=stop)
                    result.save(folder / f"test-{case_index + 1}.json")
                    record["tests"].append({"name": case.name, "passed": result.passed,
                                             "assertions": len(case.assertions)})
                    if not result.passed:
                        raise RuntimeError(f"{item.title} 的 PC 测试未通过：{case.name}")
                record["item_id"] = info.manifest.game_id
            elif item.kind == "video":
                # Freeze the selected source, including files outside the workspace.
                frozen = folder / "frozen"
                frozen.mkdir()
                source = frozen / ("source" + item.path.suffix.lower())
                before = file_identity(item.path)
                record['source_identity']=before
                shutil.copyfile(item.path, source)
                if file_identity(source) != before or file_identity(item.path) != before:
                    raise RuntimeError("源视频在准备时发生变化，请重新加载")
                stem = "".join(c if c.isascii() and c.isalnum() else "-"
                               for c in item.path.stem).strip("-")[:40] or "video"
                package = folder / f"{stem}.s2v"
                from .. import video_codec
                encoder_identity=file_identity(Path(video_codec.__file__))['sha256']
                cache_key=hashlib.sha256(json.dumps([before,encoder_identity,'spatial-resident'],sort_keys=True).encode()).hexdigest()
                cache=output.parent/'.video-cache'/cache_key
                cached=None
                try:
                    metadata=json.loads((cache/'verified.json').read_text(encoding='utf-8'))
                    if (metadata['source']==before and metadata['encoder']==encoder_identity
                            and file_identity(cache/'video.s2v')==metadata['encoded']):cached=metadata
                except (OSError,ValueError,KeyError):pass
                if cached:
                    report(f'复用已验证视频：{item.title}')
                    shutil.copyfile(cache/'video.s2v',package)
                elif source.suffix == ".s2v":
                    shutil.copyfile(source, package)
                else:
                    def frames():
                        for number,frame in enumerate(decode_video_frames(source),1):
                            check()
                            if number%300==0:report(f'转换 {item.title} · {number} 帧')
                            yield frame
                    report(f"转换视频：{item.title}")
                    encode_rgb_frames(frames(), package, quality_profile="spatial-resident")
                check()
                with S2V1Reader(package) as reader:
                    count=cached['frames'] if cached else 0
                    if not cached:
                        for frame in reader.iter_frames():
                            check()
                            count += 1
                    if count != reader.frame_count or not count:
                        raise ValueError("视频帧数校验失败")
                if not cached:
                    cache.mkdir(parents=True,exist_ok=True)
                    token=uuid.uuid4().hex
                    temporary=cache/(token+'.s2v')
                    shutil.copyfile(package,temporary);temporary.replace(cache/'video.s2v')
                    metadata=dict(source=before,encoder=encoder_identity,frames=count,encoded=file_identity(package))
                    temporary=cache/(token+'.json')
                    temporary.write_text(json.dumps(metadata),encoding='utf-8')
                    temporary.replace(cache/'verified.json')
                record['video_validation']='sha-verified-cache' if cached else 'full-decode'
                record["frames"] = count
                record["item_id"], record["display_name"] = video_library_identity(package, item.title)
                key = ("video", record["item_id"])
                if key in identities:
                    raise ValueError(f"重复的视频：{item.title}")
                identities.add(key)
                source.unlink()
                frozen.rmdir()
            else:
                raise ValueError(f"不支持的内容类型：{item.kind}")
            check()
            record.update(file_identity(package))
            record.update(package=str(package), state="validated")
            prepared.append((item, package, record))
            save()

        if prepare_only:
            receipt['status']='validated'
            save()
            return receipt
        # No uploads happen until all selected content has passed local validation.
        receipt["status"] = "installing"
        save()
        known=device.list_library().get('library_items',[])
        for item, package, record in prepared:
            check()
            if file_identity(package) != {k: record[k] for k in ("sha256", "length")}:
                raise RuntimeError("已验证文件发生变化，停止上传")
            same=next((entry for entry in known if entry.get('kind')==item.kind
                       and entry.get('item_id')==record['item_id']
                       and entry.get('sha256')==record['sha256']
                       and entry.get('length')==record['length']
                       and (item.kind!='video' or entry.get('display_name')==record['display_name'])),None)
            if same is not None:
                record.update(state='installed',installation='already_present',library=same)
                report(f'已在板端，身份一致：{item.title}')
                save()
                continue
            record["state"] = "installing"
            save()
            report(f"上传并安装：{item.title}")
            last_percent = -1
            def upload_progress(received, total):
                nonlocal last_percent
                check()
                percent = round(received * 100 / max(1, total))
                if percent != last_percent:
                    report(f"上传 {item.title} · {percent}%")
                    last_percent = percent
            if item.kind == "game":
                result = device.install_game(package, progress=upload_progress)
            else:
                result = device.install_s2v(package, progress=upload_progress,
                                            display_name=record["display_name"])
            record["install_receipt"] = result
            # Both game and video require library identity readback.
            listing = device.list_library(item.kind)
            matches = [entry for entry in listing.get("library_items", [])
                       if isinstance(entry, dict)
                       and entry.get("sha256") == record["sha256"]
                       and entry.get("length") == record["length"]
                       and entry.get("item_id") == record["item_id"]
                       and (item.kind != "video" or entry.get("display_name") == record["display_name"])]
            if not matches:
                raise RuntimeError(f"{item.title} 安装后身份回读不一致")
            record.update(state="installed", library=matches[0])
            save()
        receipt["status"] = "complete"
    except Exception as error:
        receipt["status"] = "cancelled" if stop.is_set() else "failed"
        receipt["error"] = str(error)
        for record in receipt["items"]:
            if record["state"] == "installing":
                record["state"] = "unconfirmed"
        save()
        raise
    save()
    return receipt
