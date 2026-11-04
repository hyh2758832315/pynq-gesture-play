from __future__ import annotations

import argparse
import hashlib
import json
import os
import time
from datetime import datetime, timezone
from pathlib import Path

if __package__:
    from .camera_driver import SccbBus, decode_camera_status
else:
    from camera_driver import SccbBus, decode_camera_status


EXPECTED_BUILD_ID = 0xC00A0004
EXPECTED_CHIP_ID = 0x5640
XCLK_HZ = 12_500_000
BUILD_ID_IP = "build_id_gpio"
CAMERA_CONTROL_IP = "camera_control_gpio"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as source:
        for block in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest().upper()


def get_mmio(overlay: object, ip_name: str) -> object:
    from pynq import MMIO

    description = overlay.ip_dict.get(ip_name)
    if description is None:
        names = ", ".join(sorted(overlay.ip_dict))
        raise RuntimeError(f"{ip_name!r} is absent from HWH; available IP: {names}")
    return MMIO(int(description["phys_addr"]), int(description["addr_range"]))


def verify_camera(
    bitstream: Path,
    reads: int,
    half_period_us: float,
    *,
    download: bool,
    load_only: bool,
    xclk_only: bool,
    dvp_only: bool,
) -> dict[str, object]:
    from pynq import Overlay

    if os.geteuid() != 0:
        raise PermissionError("PYNQ Overlay loading requires root; run this script with sudo")
    if not bitstream.is_file():
        raise FileNotFoundError(bitstream)
    hwh = bitstream.with_suffix(".hwh")
    if not hwh.is_file():
        raise FileNotFoundError(hwh)

    print(f"CAMERA_PHASE={'overlay_load' if download else 'overlay_attach'}", flush=True)
    overlay = Overlay(str(bitstream), download=download)
    build_id_mmio = get_mmio(overlay, BUILD_ID_IP)
    actual_build_id = build_id_mmio.read(0)
    print(f"CAMERA_BUILD_ID=0x{actual_build_id:08X}", flush=True)
    if actual_build_id != EXPECTED_BUILD_ID:
        raise RuntimeError(
            f"BUILD_ID mismatch: expected 0x{EXPECTED_BUILD_ID:08X}, "
            f"got 0x{actual_build_id:08X}"
        )

    if load_only:
        print("CAMERA_LOAD_ONLY_STATUS=PASS", flush=True)
        return {
            "status": "PASS",
            "mode": "load-only",
            "timestamp_utc": datetime.now(timezone.utc).isoformat(),
            "bitstream": str(bitstream),
            "bitstream_sha256": sha256(bitstream),
            "hwh_sha256": sha256(hwh),
            "build_id": f"0x{actual_build_id:08X}",
            "download": download,
        }

    control_mmio = get_mmio(overlay, CAMERA_CONTROL_IP)
    bus = SccbBus(control_mmio, half_period_s=half_period_us / 1_000_000)
    if xclk_only:
        print("CAMERA_PHASE=xclk_test", flush=True)
        started = time.monotonic()
        try:
            bus.set_xclk_enabled(True)
            time.sleep(0.25)
        finally:
            bus.release_bus()
            bus.set_xclk_enabled(False)
        elapsed = time.monotonic() - started
        print("CAMERA_XCLK_STATUS=PASS", flush=True)
        return {
            "status": "PASS",
            "mode": "xclk-only",
            "timestamp_utc": datetime.now(timezone.utc).isoformat(),
            "bitstream": str(bitstream),
            "bitstream_sha256": sha256(bitstream),
            "hwh_sha256": sha256(hwh),
            "build_id": f"0x{actual_build_id:08X}",
            "xclk_hz": XCLK_HZ,
            "elapsed_s": elapsed,
            "download": download,
        }

    if dvp_only:
        print("CAMERA_PHASE=dvp_monitor", flush=True)
        started = time.monotonic()
        before_status: dict[str, int] | None = None
        status: dict[str, int] | None = None
        data_values: set[int] = set()
        try:
            bus.set_xclk_enabled(True)
            time.sleep(0.05)
            before_status = decode_camera_status(control_mmio.read(SccbBus.SAMPLE_OFFSET))
            for register, value in (
                (0x300E, 0x18),
                (0x3017, 0x7F),
                (0x3018, 0xFC),
                (0x503D, 0x84),
                (0x3008, 0x02),
            ):
                bus.write_register(0x3C, register, value)
            time.sleep(0.1)
            for _ in range(1000):
                status = decode_camera_status(control_mmio.read(SccbBus.SAMPLE_OFFSET))
                data_values.add(status["data"])
                time.sleep(0.002)
        finally:
            for register, value in (
                (0x503D, 0x00),
                (0x3017, 0x00),
                (0x3018, 0x00),
                (0x3008, 0x42),
            ):
                try:
                    bus.write_register(0x3C, register, value)
                except Exception:
                    pass
            bus.release_bus()
            bus.set_xclk_enabled(False)
        if before_status is None or status is None:
            raise RuntimeError("DVP status sampling did not complete")
        elapsed = time.monotonic() - started
        print(
            "CAMERA_DVP_EDGES_BEFORE="
            f"pclk:{before_status['pclk_edges']},"
            f"vsync:{before_status['vsync_edges']},href:{before_status['href_edges']}",
            flush=True,
        )
        print(
            "CAMERA_DVP_EDGES_AFTER="
            f"pclk:{status['pclk_edges']},vsync:{status['vsync_edges']},href:{status['href_edges']}",
            flush=True,
        )
        missing = [
            signal
            for signal in ("pclk", "vsync", "href")
            if status[f"{signal}_edges"] <= before_status[f"{signal}_edges"]
            and before_status[f"{signal}_edges"] != 0x3F
        ]
        if missing:
            raise RuntimeError(f"DVP edge counters did not advance: {', '.join(missing)}")
        if len(data_values) < 2:
            raise RuntimeError(f"DVP data bus did not vary: {sorted(data_values)}")
        print(f"CAMERA_DVP_DATA_VALUES={len(data_values)}", flush=True)
        print("CAMERA_DVP_MONITOR_STATUS=PASS", flush=True)
        return {
            "status": "PASS",
            "mode": "dvp-monitor",
            "timestamp_utc": datetime.now(timezone.utc).isoformat(),
            "bitstream": str(bitstream),
            "bitstream_sha256": sha256(bitstream),
            "hwh_sha256": sha256(hwh),
            "build_id": f"0x{actual_build_id:08X}",
            "xclk_hz": XCLK_HZ,
            "camera_status_before": before_status,
            "camera_status": status,
            "data_value_count": len(data_values),
            "data_value_min": min(data_values),
            "data_value_max": max(data_values),
            "elapsed_s": elapsed,
            "download": download,
        }

    print("CAMERA_PHASE=sccb_prepare", flush=True)
    chip_ids: list[int] = []
    started = time.monotonic()
    try:
        bus.set_xclk_enabled(True)
        time.sleep(0.05)
        bus.recover()
        for index in range(1, reads + 1):
            chip_id = bus.read_ov5640_chip_id()
            chip_ids.append(chip_id)
            print(f"OV5640_ID_{index:03d}=0x{chip_id:04X}", flush=True)
            if chip_id != EXPECTED_CHIP_ID:
                raise RuntimeError(
                    f"OV5640 chip ID mismatch on read {index}: "
                    f"expected 0x{EXPECTED_CHIP_ID:04X}, got 0x{chip_id:04X}"
                )
    finally:
        bus.release_bus()
        bus.set_xclk_enabled(False)

    elapsed = time.monotonic() - started
    print(f"CAMERA_ID_VERIFY_STATUS=PASS ({reads}/{reads})", flush=True)
    return {
        "status": "PASS",
        "timestamp_utc": datetime.now(timezone.utc).isoformat(),
        "bitstream": str(bitstream),
        "bitstream_sha256": sha256(bitstream),
        "hwh_sha256": sha256(hwh),
        "build_id": f"0x{actual_build_id:08X}",
        "expected_chip_id": f"0x{EXPECTED_CHIP_ID:04X}",
        "reads": reads,
        "chip_ids": [f"0x{chip_id:04X}" for chip_id in chip_ids],
        "half_period_us": half_period_us,
        "elapsed_s": elapsed,
        "download": download,
    }


def main() -> None:
    parser = argparse.ArgumentParser(description="Verify OV5640 SCCB on PYNQ-Z2")
    parser.add_argument("bitstream", type=Path, help="Path to camera_overlay.bit")
    parser.add_argument("--reads", type=int, default=100)
    parser.add_argument("--half-period-us", type=float, default=50.0)
    parser.add_argument("--evidence", type=Path)
    phase = parser.add_mutually_exclusive_group()
    phase.add_argument("--load-only", action="store_true")
    phase.add_argument("--xclk-only", action="store_true")
    phase.add_argument("--dvp-only", action="store_true")
    parser.add_argument("--no-download", action="store_true")
    args = parser.parse_args()
    if args.reads < 1:
        parser.error("--reads must be at least 1")
    if args.half_period_us <= 0:
        parser.error("--half-period-us must be positive")

    bitstream = args.bitstream.resolve()
    try:
        evidence = verify_camera(
            bitstream,
            args.reads,
            args.half_period_us,
            download=not args.no_download,
            load_only=args.load_only,
            xclk_only=args.xclk_only,
            dvp_only=args.dvp_only,
        )
    except Exception as error:
        evidence = {
            "status": "FAIL",
            "timestamp_utc": datetime.now(timezone.utc).isoformat(),
            "bitstream": str(bitstream),
            "error": f"{type(error).__name__}: {error}",
        }
        if args.evidence is not None:
            args.evidence.write_text(json.dumps(evidence, indent=2) + "\n", encoding="utf-8")
        raise

    if args.evidence is not None:
        args.evidence.write_text(json.dumps(evidence, indent=2) + "\n", encoding="utf-8")
        print(f"CAMERA_EVIDENCE={args.evidence.resolve()}", flush=True)


if __name__ == "__main__":
    main()
