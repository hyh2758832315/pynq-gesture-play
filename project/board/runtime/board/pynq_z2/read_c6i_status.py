from __future__ import annotations

import argparse
import json
from pathlib import Path
import xml.etree.ElementTree as ET


STATUS_IPS = (
    "packet_status_gpio",
    "command_status_gpio",
    "error_status_gpio",
    "render_completion_gpio",
    "present_completion_gpio",
    "framebuffer_status_gpio",
    "render_status_gpio",
    "router_status_gpio",
    "palette_packet_status_gpio",
    "palette_generation_status_gpio",
    "asset_packet_status_gpio",
    "asset_generation_status_gpio",
    "tilemap_packet_status_gpio",
    "tilemap_generation_status_gpio",
)


def ip_address(hwh: Path, instance: str) -> tuple[int, int]:
    root = ET.parse(hwh).getroot()
    for memory_range in root.iter("MEMRANGE"):
        if memory_range.get("INSTANCE") == instance:
            base = int(memory_range.attrib["BASEVALUE"], 0)
            high = int(memory_range.attrib["HIGHVALUE"], 0)
            return base, high - base + 1
    raise KeyError(instance)


def main() -> None:
    parser = argparse.ArgumentParser(description="Read C6I status without loading an Overlay")
    parser.add_argument("hwh", type=Path)
    args = parser.parse_args()

    from pynq import MMIO

    values = {}
    for instance in STATUS_IPS:
        mmio = MMIO(*ip_address(args.hwh, instance))
        values[instance] = {
            "channel_1": int(mmio.read(0)),
            "channel_2": int(mmio.read(8)),
        }
    print(json.dumps(values, sort_keys=True))


if __name__ == "__main__":
    main()