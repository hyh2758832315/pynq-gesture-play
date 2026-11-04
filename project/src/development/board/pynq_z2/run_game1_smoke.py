from __future__ import annotations

import argparse
import json
from pathlib import Path

from pynq_multimodal_game.game_package import GamePackageBuilder
from pynq_multimodal_game.studio.device import DeviceState, RemoteDeviceSession


def main() -> None:
    parser = argparse.ArgumentParser(description="Build, install, and run game1 on PYNQ")
    parser.add_argument("--host", default="192.168.2.99")
    parser.add_argument("--port", type=int, default=8765)
    parser.add_argument("--source-address", default="192.168.2.1")
    parser.add_argument("--timeout", type=float, default=5.0)
    parser.add_argument("--project", type=Path, default=Path("games/game1"))
    parser.add_argument(
        "--output",
        type=Path,
        default=Path("games/.build/game1-1.0.0.vvg"),
    )
    args = parser.parse_args()

    package = GamePackageBuilder().build(args.project, args.output)
    print(f"GAME1_PACKAGE_SHA256={package.sha256}")
    print(f"GAME1_PACKAGE_BYTES={package.length}")

    session = RemoteDeviceSession(
        args.host,
        args.port,
        expected_build_id=0xC0060700,
        timeout=args.timeout,
        source_address=args.source_address,
    )
    try:
        snapshot = session.connect()
        print(f"GAME1_AGENT_STATE={snapshot.state.value}")
        build_id = "NONE" if snapshot.build_id is None else f"0x{snapshot.build_id:08X}"
        print(f"GAME1_AGENT_BUILD_ID={build_id}")
        if snapshot.state is not DeviceState.READY:
            raise RuntimeError(snapshot.message)

        installed = session.install_game(package.path)
        library = installed["library"]
        print(f"GAME1_LIBRARY_ID={library['item_id']}")
        print(f"GAME1_LIBRARY_SHA256={library['sha256']}")
        running = session.run_game("game1")
        print("GAME1_RUN_RESULT=" + json.dumps(running, sort_keys=True))
        print("GAME1_SMOKE_STATUS=PASS")
    finally:
        session.disconnect()


if __name__ == "__main__":
    main()
