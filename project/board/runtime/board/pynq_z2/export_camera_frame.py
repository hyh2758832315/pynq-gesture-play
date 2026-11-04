from __future__ import annotations

import argparse
import os
import time
from pathlib import Path
from typing import Protocol

if __package__:
    from .camera_driver import MmioLike, decode_camera_status
    from .ov5640_vga import RegisterBus, configure_vga_yuv
else:
    from camera_driver import MmioLike, decode_camera_status
    from ov5640_vga import RegisterBus, configure_vga_yuv


class CaptureBus(RegisterBus, Protocol):
    def set_xclk_enabled(self, enabled: bool) -> None: ...

    def recover(self) -> None: ...

    def release_bus(self) -> None: ...


FRAME_BUILD_ID = 0xC00A0004
FRAME_WIDTH = 160
FRAME_HEIGHT = 120
FRAME_DONE = 1 << 8
FRAME_ERROR = 1 << 9
CAPTURE_ENABLE = 1 << 15


def read_grayscale_frame(frame_mmio: MmioLike) -> bytes:
    status = frame_mmio.read(0x8)
    if status & FRAME_ERROR:
        raise RuntimeError("DVP frame capture rejected an incomplete frame")
    if not status & FRAME_DONE:
        raise RuntimeError("DVP frame capture is not complete")

    pixels = bytearray(FRAME_WIDTH * FRAME_HEIGHT)
    for address in range(len(pixels)):
        frame_mmio.write(0x0, CAPTURE_ENABLE | address)
        pixels[address] = frame_mmio.read(0x8) & 0xFF

    if frame_mmio.read(0x8) & (FRAME_DONE | FRAME_ERROR) != FRAME_DONE:
        raise RuntimeError("DVP frame changed during readout")
    return bytes(pixels)


def save_grayscale_frame(frame_mmio: MmioLike, output: Path) -> None:
    pixels = read_grayscale_frame(frame_mmio)
    output.write_bytes(f"P5\n{FRAME_WIDTH} {FRAME_HEIGHT}\n255\n".encode("ascii") + pixels)


def capture_and_save(
    bus: CaptureBus, frame_mmio: MmioLike, output: Path, timeout_s: float = 3.0,
    diagnostic_mmio: MmioLike | None = None, probe_sensor: bool = False,
) -> None:
    vsync_samples = 0
    vsync_high_samples = 0
    vsync_rises = 0
    previous_vsync = False

    def report_status(phase: str) -> None:
        if diagnostic_mmio is not None:
            dvp = decode_camera_status(diagnostic_mmio.read(0x8))
            print(f"CAMERA_{phase}_DVP={dvp} FRAME=0x{frame_mmio.read(0x8):08X}", flush=True)
            if phase in ("DONE", "ERROR", "TIMEOUT"):
                print(
                    f"CAMERA_{phase}_LIVE_VSYNC samples={vsync_samples} "
                    f"high={vsync_high_samples} rises={vsync_rises}", flush=True,
                )

    def report_sensor(phase: str) -> None:
        if probe_sensor:
            registers = (
                0x3008, 0x300E, 0x3017, 0x3018, 0x3034, 0x3035, 0x3036,
                0x3037, 0x3108, 0x3500, 0x3501, 0x3502, 0x3503, 0x350C,
                0x350D, 0x380C, 0x380D, 0x380E, 0x380F, 0x3A00, 0x4740,
            )
            values = {f"0x{register:04X}": f"0x{bus.read_register(0x3C, register):02X}" for register in registers}
            print(f"CAMERA_{phase}_REGISTERS={values}", flush=True)

    try:
        try:
            bus.set_xclk_enabled(True)
            time.sleep(0.05)
            bus.recover()
            report_status("BEFORE_CONFIG")
            configure_vga_yuv(bus)
            frame_mmio.write(0x0, 0)
            time.sleep(0.005)
            frame_mmio.write(0x0, CAPTURE_ENABLE)
            report_sensor("STREAM_START")
            deadline = time.monotonic() + timeout_s
            retries = 0
            started = time.monotonic()
            next_sample = started
            report_status("STREAM_START")
            while True:
                if diagnostic_mmio is not None:
                    vsync = bool(diagnostic_mmio.read(0x8) & (1 << 11))
                    vsync_samples += 1
                    vsync_high_samples += vsync
                    vsync_rises += vsync and not previous_vsync
                    previous_vsync = vsync
                status = frame_mmio.read(0x8)
                if status & FRAME_ERROR:
                    print(f"CAMERA_FRAME_ERROR elapsed_s={time.monotonic() - started:.3f}", flush=True)
                    report_status("ERROR")
                    if retries >= 2 or time.monotonic() >= deadline:
                        raise RuntimeError("DVP frame capture rejected the sensor output")
                    frame_mmio.write(0x0, 0)
                    time.sleep(0.005)
                    frame_mmio.write(0x0, CAPTURE_ENABLE)
                    retries += 1
                    print(f"CAMERA_FRAME_RETRY={retries}", flush=True)
                    continue
                if status & FRAME_DONE:
                    report_status("DONE")
                    break
                now = time.monotonic()
                if now >= deadline:
                    report_status("TIMEOUT")
                    report_sensor("TIMEOUT")
                    raise TimeoutError("Waiting for a complete OV5640 VGA frame timed out")
                if now >= next_sample:
                    report_status("STREAM")
                    next_sample = now + 0.25
                time.sleep(0.0001 if diagnostic_mmio is not None and now - started < 1.0 else 0.01)
        finally:
            try:
                bus.write_register(0x3C, 0x3008, 0x42)
            finally:
                try:
                    bus.release_bus()
                finally:
                    bus.set_xclk_enabled(False)
        save_grayscale_frame(frame_mmio, output)
    finally:
        frame_mmio.write(0x0, 0)


def main() -> None:
    parser = argparse.ArgumentParser(description="Export a completed OV5640 frame as PGM")
    parser.add_argument("bitstream", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("--timeout", type=float, default=3.0)
    parser.add_argument("--probe-sensor", action="store_true")
    args = parser.parse_args()

    from camera_driver import SccbBus
    from pynq import Overlay
    from verify_camera import get_mmio

    if os.geteuid() != 0:
        raise PermissionError("Camera MMIO access requires root")
    bitstream = args.bitstream.resolve()
    if not bitstream.is_file() or not bitstream.with_suffix(".hwh").is_file():
        raise FileNotFoundError("Camera bitstream and HWH must both exist")
    overlay = Overlay(str(bitstream), download=False)
    build_id = get_mmio(overlay, "build_id_gpio").read(0x0)
    if build_id != FRAME_BUILD_ID:
        raise RuntimeError(f"Frame-capable Overlay 0x{FRAME_BUILD_ID:08X} required; found 0x{build_id:08X}")
    control_mmio = get_mmio(overlay, "camera_control_gpio")
    frame_mmio = get_mmio(overlay, "camera_frame_gpio")
    bus = SccbBus(control_mmio)
    try:
        capture_and_save(
            bus, frame_mmio, args.output, timeout_s=args.timeout,
            diagnostic_mmio=control_mmio, probe_sensor=args.probe_sensor,
        )
    except Exception:
        print(f"CAMERA_DVP_STATUS={decode_camera_status(control_mmio.read(0x8))}", flush=True)
        print(f"CAMERA_FRAME_STATUS=0x{frame_mmio.read(0x8):08X}", flush=True)
        raise
    print(f"CAMERA_FRAME_PGM={args.output.resolve()} size={FRAME_WIDTH}x{FRAME_HEIGHT}")


if __name__ == "__main__":
    main()