from __future__ import annotations

import argparse
import asyncio
import hashlib
import io
import os
import time
from collections import deque
from http.server import BaseHTTPRequestHandler, HTTPServer
from pathlib import Path
from threading import Condition, Event, Thread
from typing import Protocol, cast

import numpy as np

if __package__:
    from .ov5640_direct_plug_config import SENSOR_CONFIG
else:
    from ov5640_direct_plug_config import SENSOR_CONFIG


WIDTH = 1280
HEIGHT = 720
SENSOR_ADDRESS = 0x3C
REQUIRED_IP = {"camera_iic", "demosaic", "frame_dma"}


class FrameDonePoller:
    def __init__(self, mmio: object, timeout: float = 3.0) -> None:
        self.mmio = mmio
        self.timeout = timeout

    async def wait(self) -> None:
        deadline = time.monotonic() + self.timeout
        while not self.mmio.read(0x34) & 0x1000:
            if time.monotonic() >= deadline:
                raise TimeoutError("S2MM frame completion timed out")
            await asyncio.sleep(0.005)


def configure_sensor(iic: object) -> None:
    for index, (register, value) in enumerate(SENSOR_CONFIG, start=1):
        packet = bytes((register >> 8, register & 0xFF, value))
        try:
            transferred = iic.send(SENSOR_ADDRESS, packet, len(packet))
        except RuntimeError as error:
            raise RuntimeError(
                f"OV5640 write {index}/{len(SENSOR_CONFIG)} at 0x{register:04X} failed; "
                f"AXI IIC CR=0x{iic.read(0x100):02X}, SR=0x{iic.read(0x104):02X}"
            ) from error
        if transferred != len(packet):
            raise RuntimeError(f"OV5640 register 0x{register:04X}: sent {transferred}/3 bytes")
        if (register, value) == (0x3008, 0x82):
            time.sleep(0.01)


def probe_first_write(iic: object) -> None:
    register, value = SENSOR_CONFIG[0]
    packet = bytes((register >> 8, register & 0xFF, value))
    print(f"CAMERA_IIC_BEFORE=CR:0x{iic.read(0x100):02X} SR:0x{iic.read(0x104):02X} IISR:0x{iic.read(0x20):02X}", flush=True)
    try:
        transferred = iic.send(SENSOR_ADDRESS, packet, len(packet))
    finally:
        print(f"CAMERA_IIC_AFTER=CR:0x{iic.read(0x100):02X} SR:0x{iic.read(0x104):02X} IISR:0x{iic.read(0x20):02X}", flush=True)
    if transferred != len(packet):
        raise RuntimeError(f"OV5640 first write at 0x{register:04X}: sent {transferred}/3 bytes")
    print("CAMERA_IIC_FIRST_WRITE=PASS", flush=True)


def probe_chip_id(iic: object) -> int:
    time.sleep(0.05)
    values = []
    for register in (0x300A, 0x300B):
        print(f"CAMERA_IIC_ID_REGISTER=0x{register:04X}", flush=True)
        address = bytes((register >> 8, register & 0xFF))
        sent = iic.send(SENSOR_ADDRESS, address, len(address))
        if sent != len(address):
            raise RuntimeError(f"OV5640 register 0x{register:04X}: sent {sent}/2 address bytes")
        ffi = getattr(iic, "_ffi", None)
        data = ffi.new("unsigned char[1]") if ffi is not None else bytearray(1)
        received = iic.receive(SENSOR_ADDRESS, data, len(data))
        if received != len(data):
            raise RuntimeError(f"OV5640 register 0x{register:04X}: received {received}/1 byte")
        values.append(data[0])
    chip_id = (values[0] << 8) | values[1]
    print(f"CAMERA_IIC_CHIP_ID=0x{chip_id:04X}", flush=True)
    if chip_id != 0x5640:
        raise RuntimeError(f"Unexpected OV5640 chip ID: 0x{chip_id:04X}")
    print("CAMERA_IIC_CHIP_ID_STATUS=PASS", flush=True)
    return chip_id


def save_frame(frame: np.ndarray, output: Path) -> dict[str, float | int]:
    if frame.shape != (HEIGHT, WIDTH, 3) or frame.dtype != np.uint8:
        raise RuntimeError(f"Unexpected VDMA frame: shape={frame.shape}, dtype={frame.dtype}")
    minimum = int(frame.min())
    maximum = int(frame.max())
    deviation = float(frame.std())
    if maximum - minimum < 8 or deviation < 2:
        raise RuntimeError(f"Nearly constant camera frame: range={minimum}..{maximum}, std={deviation:.2f}")
    output.write_bytes(f"P6\n{WIDTH} {HEIGHT}\n255\n".encode("ascii") + frame.tobytes())
    return {"min": minimum, "max": maximum, "std": deviation}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as source:
        for block in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest().upper()


class LatestFrameSource:
    def __init__(self) -> None:
        self.condition = Condition()
        self.frame: np.ndarray | None = None
        self.generation = 0
        self.last_read = 0
        self.error: Exception | None = None

    def publish(self, frame: np.ndarray) -> None:
        with self.condition:
            self.frame = frame
            self.generation += 1
            self.condition.notify_all()

    def fail(self, error: Exception) -> None:
        with self.condition:
            self.error = error
            self.condition.notify_all()

    def readframe(self) -> np.ndarray:
        with self.condition:
            if not self.condition.wait_for(lambda: self.generation > self.last_read or self.error is not None, 5):
                raise TimeoutError("Isolated camera frame timed out")
            if self.error is not None:
                raise RuntimeError("Isolated camera pump failed") from self.error
            self.last_read = self.generation
            assert self.frame is not None
            return self.frame


class CapturedFrame(Protocol):
    def freebuffer(self) -> None: ...


class FrameReader(Protocol):
    def readframe(self) -> CapturedFrame: ...


class FrameWriter(Protocol):
    def newframe(self) -> np.ndarray: ...

    def writeframe(self, frame: np.ndarray) -> None: ...


def drive_isolated_display(channel: FrameReader, display: FrameWriter, source: LatestFrameSource, stop: Event) -> None:
    loop = asyncio.new_event_loop()
    asyncio.set_event_loop(loop)
    retained: deque[CapturedFrame] = deque(maxlen=12)
    try:
        while not stop.is_set():
            captured = channel.readframe()
            try:
                output = display.newframe()
                if source.generation < 15:
                    print(f"CAMERA_ISOLATED_COPY_START={source.generation + 1} captured=0x{getattr(captured, 'virtual_address', 0):X} output=0x{getattr(output, 'virtual_address', 0):X}", flush=True)
                np.copyto(output, np.asarray(captured))
                snapshot = np.asarray(captured).copy()
                display.writeframe(output)
                source.publish(snapshot)
                if source.generation <= 3 or source.generation % 100 == 0:
                    print(f"CAMERA_ISOLATED_FRAME={source.generation} at={time.monotonic():.3f}", flush=True)
            finally:
                retained.append(captured)
    except Exception as error:
        print(f"CAMERA_ISOLATED_PUMP_ERROR={type(error).__name__}: {error}", flush=True)
        source.fail(error)
    finally:
        loop.close()


def serve_mjpeg(channel: object, bind: str, port: int, probe_retain_frames: int = 0) -> None:
    from PIL import Image

    retained = []
    isolated_source = channel if isinstance(channel, LatestFrameSource) else None

    class CameraServer(HTTPServer):
        def service_actions(self) -> None:
            if isolated_source is not None and isolated_source.error is not None:
                raise RuntimeError("Isolated camera pump stopped") from isolated_source.error

    class CameraStream(BaseHTTPRequestHandler):
        def do_GET(self) -> None:
            if self.path != "/camera.mjpg":
                self.send_error(404)
                return
            if probe_retain_frames and len(retained) >= probe_retain_frames:
                self.send_error(503)
                return
            started = time.monotonic()
            frames = 0
            phase = "headers"
            print(f"CAMERA_MJPEG_CLIENT_OPEN={self.client_address[0]} at={started:.3f}", flush=True)
            self.send_response(200)
            self.send_header("Content-Type", "multipart/x-mixed-replace; boundary=frame")
            self.send_header("Cache-Control", "no-store")
            self.end_headers()
            try:
                while True:
                    phase = "readframe"
                    buffer = channel.readframe()
                    try:
                        phase = "encode"
                        encoded = io.BytesIO()
                        Image.fromarray(np.asarray(buffer), "RGB").save(encoded, format="JPEG", quality=80)
                        jpeg = encoded.getvalue()
                    finally:
                        phase = "freebuffer"
                        if probe_retain_frames:
                            retained.append(buffer)
                        elif isolated_source is None:
                            cast(CapturedFrame, buffer).freebuffer()
                    phase = "write_header"
                    self.wfile.write(b"--frame\r\nContent-Type: image/jpeg\r\nContent-Length: " + str(len(jpeg)).encode("ascii") + b"\r\n\r\n")
                    phase = "write_body"
                    self.wfile.write(jpeg + b"\r\n")
                    frames += 1
                    if frames <= 3 or frames % 100 == 0:
                        print(f"CAMERA_MJPEG_FRAME={frames} elapsed={time.monotonic() - started:.3f}", flush=True)
                    if probe_retain_frames and len(retained) >= probe_retain_frames:
                        return
            except (BrokenPipeError, ConnectionResetError) as error:
                print(f"CAMERA_MJPEG_CLIENT_CLOSE={type(error).__name__} phase={phase} frames={frames} elapsed={time.monotonic() - started:.3f}", flush=True)
                return
            except Exception as error:
                print(f"CAMERA_MJPEG_CLIENT_ERROR={type(error).__name__} phase={phase} frames={frames} elapsed={time.monotonic() - started:.3f}", flush=True)
                raise

    with CameraServer((bind, port), CameraStream) as server:
        print(f"CAMERA_MJPEG_URL=http://{bind}:{port}/camera.mjpg", flush=True)
        print(f"CAMERA_MJPEG_LISTEN_AT={time.monotonic():.3f}", flush=True)
        server.serve_forever()


def open_frame_dma(overlay: object, hwh: Path) -> object:
    from pynq.lib.video.dma import AxiVDMA

    description = dict(overlay.ip_dict["frame_dma"])
    interrupts = dict(description["interrupts"])
    expected = {"s2mm_introut"}
    if description["parameters"].get("C_INCLUDE_MM2S") == "1":
        expected.add("mm2s_introut")
    if not expected <= interrupts.keys():
        from pynq.pl_server.hwh_parser import HWH

        legacy = HWH(str(hwh))
        recovered = legacy.ip_dict["frame_dma"]["interrupts"]
        if not expected <= recovered.keys():
            raise RuntimeError(f"VDMA interrupts missing from HWH: {sorted(expected - recovered.keys())}")
        overlay.device.interrupt_pins = {**overlay.device.interrupt_pins, **legacy.interrupt_pins}
        overlay.device.interrupt_controllers = {**overlay.device.interrupt_controllers, **legacy.interrupt_controllers}
        interrupts.update({name: recovered[name] for name in expected})
        description["interrupts"] = interrupts
        print("CAMERA_VDMA_INTERRUPTS_RECOVERED_FROM_HWH=PASS", flush=True)
    dma = AxiVDMA(description)
    if dma.readchannel._interrupt is None:
        dma.readchannel._interrupt = FrameDonePoller(dma.mmio)
        print("CAMERA_VDMA_S2MM_POLL_FALLBACK=PASS", flush=True)
    return dma


def main() -> None:
    parser = argparse.ArgumentParser(description="Capture one OV5640 Bayer frame with the direct-plug video pipeline")
    parser.add_argument("bitstream", type=Path)
    parser.add_argument("output", type=Path, nargs="?")
    parser.add_argument("--load-only", action="store_true")
    parser.add_argument("--no-download", action="store_true")
    parser.add_argument("--live", action="store_true")
    parser.add_argument("--bind", default="0.0.0.0")
    parser.add_argument("--port", type=int, default=8088)
    parser.add_argument("--isolated-live", action="store_true")
    parser.add_argument("--shared-live", action="store_true")
    parser.add_argument("--probe-retain-frames", type=int, default=0)
    probe = parser.add_mutually_exclusive_group()
    probe.add_argument("--first-write-only", action="store_true")
    probe.add_argument("--chip-id-only", action="store_true")
    args = parser.parse_args()

    if os.geteuid() != 0:
        raise PermissionError("PYNQ Overlay access requires root")
    bitstream = args.bitstream.resolve()
    hwh = bitstream.with_suffix(".hwh")
    if not bitstream.is_file() or not hwh.is_file():
        raise FileNotFoundError("Direct-plug bitstream and matching HWH are required")
    if (args.first_write_only or args.chip_id_only) and (args.load_only or not args.no_download):
        parser.error("probe mode requires --no-download and excludes --load-only")
    if args.live and (args.load_only or args.first_write_only or args.chip_id_only):
        parser.error("--live cannot be combined with probe or load-only modes")
    if args.isolated_live and (not args.live or args.shared_live):
        parser.error("--isolated-live requires --live without --shared-live")
    if args.shared_live and not args.live:
        parser.error("--shared-live requires --live")
    if not 0 <= args.probe_retain_frames <= 8 or (args.probe_retain_frames and not args.shared_live):
        parser.error("--probe-retain-frames requires --shared-live and a count from 1 to 8")
    if not args.load_only and not args.first_write_only and not args.chip_id_only and args.output is None:
        parser.error("output PPM path is required for capture")

    from pynq import Overlay, PL

    if args.no_download and (not PL.bitfile_name or Path(PL.bitfile_name).resolve() != bitstream):
        raise RuntimeError("Active PL bitstream does not match the requested camera bitstream")
    overlay = Overlay(str(bitstream), download=not args.no_download)
    missing = REQUIRED_IP - overlay.ip_dict.keys()
    if missing:
        raise RuntimeError(f"Missing camera video IP in HWH: {sorted(missing)}")
    if args.live and overlay.ip_dict["frame_dma"].get("parameters", {}).get("C_INCLUDE_MM2S") != "1":
        raise RuntimeError("Live mode requires the bidirectional camera HDMI overlay")
    print(f"CAMERA_DIRECT_PLUG_BIT_SHA256={sha256(bitstream)}", flush=True)
    print(f"CAMERA_DIRECT_PLUG_HWH_SHA256={sha256(hwh)}", flush=True)
    if args.load_only:
        print("CAMERA_DIRECT_PLUG_LOAD_STATUS=PASS", flush=True)
        return

    from pynq.lib.iic import AxiIIC

    iic = AxiIIC(overlay.ip_dict["camera_iic"])
    if args.first_write_only:
        probe_first_write(iic)
        return
    if args.chip_id_only:
        probe_chip_id(iic)
        return

    from pynq.lib.video import VideoMode

    probe_chip_id(iic)
    configure_sensor(iic)
    print(f"CAMERA_DIRECT_PLUG_SENSOR_CONFIG={len(SENSOR_CONFIG)}", flush=True)
    demosaic = overlay.demosaic
    demosaic.write(0x10, WIDTH)
    demosaic.write(0x18, HEIGHT)
    demosaic.write(0x28, 1)
    demosaic.write(0x00, 0x81)

    frame_dma = open_frame_dma(overlay, hwh)
    channel = frame_dma.readchannel
    channel.mode = VideoMode(WIDTH, HEIGHT, 24)
    display = frame_dma.writechannel if args.live else None
    if display is not None:
        display.mode = channel.mode
    capture_started = False
    display_started = False
    pump: Thread | None = None
    stop = Event()
    startup_frames = []
    try:
        channel.start()
        capture_started = True
        for _ in range(2):
            buffer = channel.readframe()
            try:
                frame = np.asarray(buffer).copy()
            finally:
                startup_frames.append(buffer)
        statistics = save_frame(frame, args.output)
        print(f"CAMERA_DIRECT_PLUG_FRAME={args.output.resolve()}", flush=True)
        print(f"CAMERA_DIRECT_PLUG_FRAME_SHA256={sha256(args.output)}", flush=True)
        print(f"CAMERA_DIRECT_PLUG_FRAME_STATS={statistics}", flush=True)
        print("CAMERA_DIRECT_PLUG_CAPTURE_STATUS=PASS", flush=True)
        if display is not None:
            display.start()
            display_started = True
            if not args.shared_live:
                source = LatestFrameSource()
                pump = Thread(target=drive_isolated_display, args=(cast(FrameReader, channel), cast(FrameWriter, display), source, stop), daemon=True)
                pump.start()
                print(f"CAMERA_HDMI_COPY_STARTED_AT={time.monotonic():.3f}", flush=True)
                serve_mjpeg(source, args.bind, args.port)
            else:
                channel.tie(display)
                print("CAMERA_HDMI_TIE_STATUS=PASS", flush=True)
                print(f"CAMERA_HDMI_TIE_AT={time.monotonic():.3f}", flush=True)
                serve_mjpeg(channel, args.bind, args.port, args.probe_retain_frames)
    finally:
        if pump is not None:
            stop.set()
            pump.join(timeout=5)
            if pump.is_alive():
                raise RuntimeError("Isolated camera pump did not stop")
        if capture_started:
            channel.tie(None)
        if display is not None and display_started:
            display.stop()
        if capture_started:
            channel.stop()
        demosaic.write(0x00, 0)


if __name__ == "__main__":
    main()