"""Add SUNSET to a running Agent without starting/stopping any runtime.

Run: .venv/Scripts/python.exe -B subprojects/ps_ui_r23b2/tools/install_default_video.py
Output: build/default-video-install.json (HELLO, install and library identity receipts).
Next: select VIDEO -> SUNSET on HDMI; the existing two-second return button exits.
No subscriptions, status polling, MMIO probes, image demand or servo commands.
"""
from __future__ import annotations

import argparse
import json
from pathlib import Path
import sys
import time
import uuid

SOURCE = Path(__file__).resolve().parents[1]
ROOT = SOURCE.parents[1]
sys.path.insert(0, str(SOURCE / "python"))
from pynq_multimodal_game.agent.core import AgentCommand, ArtifactManifest
from pynq_multimodal_game.agent.transport import AgentClient
from pynq_multimodal_game.video_codec import S2V1Reader
from pynq_multimodal_game.video_seeds import (
    BUTTON_BUILD_ID, SEED_VIDEO_ID, SEED_VIDEO_NAME, SEED_VIDEO_PATH,
)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--host", default="192.168.2.99")
    parser.add_argument("--source-address", default="192.168.2.1")
    parser.add_argument("--port", type=int, default=8765)
    parser.add_argument("--report", type=Path, default=ROOT / "build/default-video-install.json")
    args = parser.parse_args()
    if args.report.exists():
        raise FileExistsError("Preserve the previous install receipt; choose --report")
    source = SOURCE / SEED_VIDEO_PATH
    with S2V1Reader(source):
        pass
    manifest = ArtifactManifest.for_path(source, artifact_kind="video.s2v",
        target_build_id=BUTTON_BUILD_ID, abi_major=1, abi_minor=0)
    client = AgentClient(args.host, args.port, source_address=args.source_address, timeout=15)
    namespace = "default-video-" + uuid.uuid4().hex
    record = dict(schema="default-video-library-install-v1", sha256=manifest.sha256,
                  bytes=manifest.length, result="PENDING", error=None)

    def command(label, kind, **kwargs):
        reply = client.command(namespace + ":" + label, kind, **kwargs)
        record[label] = reply
        if reply.get("ok") is not True:
            raise RuntimeError(reply.get("message", "Agent command failed"))
        return reply

    try:
        hello = record["hello"] = client.connect()
        if hello.get("build_id") != BUTTON_BUILD_ID:
            raise RuntimeError("Expected the current C6I vision/button platform")
        before = command("before", AgentCommand.LIBRARY_LIST, library_kind="video")
        existing = next((item for item in before.get("library_items", [])
                         if item["item_id"] == SEED_VIDEO_ID), None)
        if existing is not None:
            if existing["sha256"] != manifest.sha256:
                raise RuntimeError("Preserving a different user video with the same ID")
            record["result"] = "ALREADY_INSTALLED"
        else:
            if before.get("snapshot", {}).get("runtime_mode") == "video":
                raise RuntimeError("Video is playing; defer installation until the normal menu/game")
            # Seven bounded chunks, with a short PC-side gap to avoid a transfer burst.
            record["upload"] = client.upload_file(source, manifest, upload_id=namespace,
                progress=lambda done, total: time.sleep(.1) if done < total else None)
            command("install", AgentCommand.LIBRARY_INSTALL, item_id=SEED_VIDEO_ID,
                    display_name=SEED_VIDEO_NAME, library_kind="video")
            record["result"] = "INSTALLED"
        listed = command("verified", AgentCommand.LIBRARY_LIST, library_kind="video")
        item = next(item for item in listed["library_items"] if item["item_id"] == SEED_VIDEO_ID)
        if (item["sha256"], item["length"], item["kind"]) != (
                manifest.sha256, manifest.length, "video"):
            raise RuntimeError("Installed video identity mismatch")
        if listed.get("snapshot", {}).get("build_id") != BUTTON_BUILD_ID:
            raise RuntimeError("Runtime identity changed during installation")
    except Exception as error:
        record.update(result="FAIL", error=f"{type(error).__name__}: {error}")
    finally:
        client.close()
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(json.dumps(record, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(dict(result=record["result"], error=record["error"], report=str(args.report))))
    return 1 if record["result"] == "FAIL" else 0


if __name__ == "__main__":
    raise SystemExit(main())
