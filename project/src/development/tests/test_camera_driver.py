def test_vision_integration_sources_match_verified_camera_and_complete_ip():
    import importlib.util
    from pathlib import Path

    root = Path(__file__).resolve().parents[1]
    path = root / "board/pynq_z2/scripts/verify_vision_integration_sources.py"
    spec = importlib.util.spec_from_file_location("integration_source_check", path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    result = module.verify_sources(root, root / "handoffs/gesture_vision_v61")
    assert result["status"] == "SOURCE_PREFLIGHT_PASS"
    assert result["board_validated"] is False
    assert result["vivado_validated"] is False
    assert result["ip_file_count"] >= 10
    assert any(name.endswith("component.xml") for name in result["sha256"])

import asyncio
from collections import deque
from http.client import HTTPConnection
from http.server import HTTPServer
from pathlib import Path
import sys
from threading import Event, Thread
from types import SimpleNamespace
from unittest.mock import patch

import pytest
import numpy as np

from board.pynq_z2.scripts import verify_vision_integration_sources as integration_check
from board.pynq_z2.camera_driver import SccbBus, decode_camera_status
from board.pynq_z2.capture_camera_direct_plug import HEIGHT, WIDTH, configure_sensor, probe_chip_id, probe_first_write, save_frame
from board.pynq_z2.ov5640_direct_plug_config import SENSOR_CONFIG
from board.pynq_z2.export_camera_frame import (
    CAPTURE_ENABLE,
    FRAME_DONE,
    FRAME_ERROR,
    FRAME_HEIGHT,
    FRAME_WIDTH,
    capture_and_save,
    read_grayscale_frame,
    save_grayscale_frame,
)
from board.pynq_z2.ov5640_vga import configure_vga_yuv
from board.pynq_z2 import verify_camera_id_gpio_direct as gpio_probe
from board.pynq_z2 import capture_camera_direct_plug as direct_capture
from board.pynq_z2.scripts.measure_camera_mjpeg import summarize as summarize_mjpeg
from board.pynq_z2.scripts.run_camera_live_guarded import stop_frame_dma
from board.pynq_z2.ov5640_source_control import request_sensor_standby


class StandbyIic:
    def __init__(self, before=0x02, after=None, short_at=None, raise_at=None, ffi=False):
        self.values = (before, before | 0x40 if after is None else after)
        self.short_at, self.raise_at = short_at, raise_at
        self.calls = []
        self.send_count = self.receive_count = 0
        if ffi:
            self._ffi = SimpleNamespace(new=self.allocate)

    @staticmethod
    def allocate(declaration):
        assert declaration == "unsigned char[1]"
        return bytearray(1)

    def send(self, address, data, length):
        operation = ("send", self.send_count)
        self.send_count += 1
        self.calls.append(("send", address, bytes(data), length))
        if operation == self.raise_at:
            raise RuntimeError("injected SCCB failure")
        return length - 1 if operation == self.short_at else length

    def receive(self, address, data, length):
        operation = ("receive", self.receive_count)
        self.receive_count += 1
        self.calls.append(("receive", address, length))
        if operation == self.raise_at:
            raise RuntimeError("injected SCCB failure")
        if operation == self.short_at:
            return 0
        data[0] = self.values[operation[1]]
        return length


@pytest.mark.parametrize("before", (0x02, 0x12, 0x42))
@pytest.mark.parametrize("ffi", (False, True))
def test_sensor_standby_read_modify_write_is_not_quiescence(before, ffi):
    iic = StandbyIic(before=before, ffi=ffi)
    result = request_sensor_standby(iic)
    assert result == {"status": "STANDBY_REGISTER_VERIFIED", "register": 0x3008,
                      "before": before, "requested": before | 0x40, "readback": before | 0x40,
                      "source_quiescent": False, "epoch_release_ready": False}
    assert iic.calls == [("send", 0x3C, b"\x30\x08", 2), ("receive", 0x3C, 1),
                         ("send", 0x3C, bytes((0x30, 0x08, before | 0x40)), 3),
                         ("send", 0x3C, b"\x30\x08", 2), ("receive", 0x3C, 1)]


@pytest.mark.parametrize("operation,calls", ((('send', 0), 1), (('receive', 0), 2),
                                             (('send', 1), 3), (('send', 2), 4), (('receive', 1), 5)))
@pytest.mark.parametrize("failure", ("short", "raise"))
def test_sensor_standby_transport_failure_stops_without_retry(operation, calls, failure):
    iic = StandbyIic(**{"short_at" if failure == "short" else "raise_at": operation})
    with pytest.raises(RuntimeError, match="OV5640 standby|injected SCCB failure"):
        request_sensor_standby(iic)
    assert len(iic.calls) == calls
    assert sum(call[0] == "send" and call[-1] == 3 for call in iic.calls) <= 1


@pytest.mark.parametrize("after", (0x02, 0x43, 0x82))
def test_sensor_standby_rejects_readback_mismatch(after):
    iic = StandbyIic(after=after)
    with pytest.raises(RuntimeError, match="standby readback"):
        request_sensor_standby(iic)
    assert iic.send_count == 3 and iic.receive_count == 2


def test_sensor_standby_refuses_reset_in_progress_without_write():
    iic = StandbyIic(before=0x82)
    with pytest.raises(RuntimeError, match="refused during software reset"):
        request_sensor_standby(iic)
    assert iic.calls == [("send", 0x3C, b"\x30\x08", 2), ("receive", 0x3C, 1)]


@pytest.mark.parametrize("left", (20, 500))
def test_full_frame_tracker_observes_candidates_outside_original_roi(left):
    from board.pynq_z2.scripts import vision_async_runtime as runtime

    image = np.zeros((360, 640, 3), dtype=np.uint8)
    image[90:260, left:left + 100] = (80, 120, 180)
    tracker = runtime.FullFrameTracker(dilate_iterations=4)
    assert tracker.roi == (0, 0, 640, 360)
    result = tracker.infer(image)
    assert result["tracking"] is True and result["bbox"] is not None
    assert result["centroid"] is not None
    assert result["centroid"][0] < 170 if left == 20 else result["centroid"][0] > 470
    assert runtime.OriginalContour().infer(image)["bbox"] is None


@pytest.mark.parametrize("fault", (None, "bit", "hwh", "missing", "slice", "corrupt_xsa",
                                 "empty_report", "duplicate_bit", "duplicate_hwh", "missing_hwh"))
@pytest.mark.parametrize("volume_mode", (False, True))
def test_offline_vision_candidate_pairing_is_not_release_approval(tmp_path, monkeypatch, fault, volume_mode):
    from xml.etree import ElementTree as ET
    from zipfile import ZipFile

    for name in integration_check.CANDIDATE_FILES:
        (tmp_path / name).write_bytes(b"explicit offline test fixture")
    document = ET.Element("SYSTEM")
    pipeline = ET.SubElement(document, "MODULE", INSTANCE="vision_gp0_slice")
    for channel in ("AW", "AR", "W", "R", "B"):
        for prefix in ("REG_", "C_REG_CONFIG_"):
            ET.SubElement(pipeline, "PARAMETER", NAME=prefix + channel,
                          VALUE="7" if fault == "slice" and channel == "AW" else "1")
    hwh = tmp_path / "c6v_candidate.hwh"
    ET.ElementTree(document).write(hwh, encoding="utf-8")
    monkeypatch.setattr(integration_check, "verify_volume_candidate_hwh" if volume_mode else "verify_candidate_hwh", lambda _path: {
        "status": "fixture topology separately checked", "board_validated": False})
    with ZipFile(tmp_path / "c6v_candidate.xsa", "w") as archive:
        archive.write(tmp_path / "c6v_candidate.bit", "c6v_candidate.bit")
        if fault != "missing_hwh":
            archive.write(hwh, "c6v.hwh")
        if fault == "duplicate_bit":
            archive.write(tmp_path / "c6v_candidate.bit", "extra/c6v_candidate.bit")
        if fault == "duplicate_hwh":
            archive.write(hwh, "extra/c6v.hwh")
    if fault == "bit":
        (tmp_path / "c6v_candidate.bit").write_bytes(b"changed paired fixture")
    if fault == "hwh":
        hwh.write_bytes(hwh.read_bytes() + b"\n")
    if fault == "missing":
        (tmp_path / "candidate.dcp").unlink()
    if fault == "empty_report":
        (tmp_path / "timing.rpt").write_bytes(b"")
    if fault == "corrupt_xsa":
        (tmp_path / "c6v_candidate.xsa").write_bytes(b"not a zip archive")
    verify = integration_check.verify_volume_candidate_bundle if volume_mode else integration_check.verify_candidate_bundle
    if fault is not None:
        with pytest.raises((ValueError, ET.ParseError, integration_check.zipfile.BadZipFile)):
            verify(tmp_path)
        return
    receipt = verify(tmp_path)
    assert receipt["status"] == "OFFLINE_CANDIDATE_PAIR_PASS"
    assert receipt["release_ready"] is False and receipt["board_pending"] is True
    assert receipt["report_review_required"] is True
    assert receipt["xsa_contents_match"] is True and receipt["gp0_full_channels"] == 5
    assert receipt["profile"] == ("C6I_VISION_VOLUME_V1" if volume_mode else "C6I_VISION")
    assert set(receipt["sha256"]) == set(integration_check.CANDIDATE_FILES)
    assert "timing_pass" not in receipt


def test_corrected_direct_plug_constraints_match_user_physical_map() -> None:
    path = Path(__file__).resolve().parents[1] / "board/pynq_z2/constraints/camera_direct_plug_corrected.xdc"
    constraints = path.read_text(encoding="ascii")
    expected = {
        "vid_xclk": "U19", "vid_pclk": "Y19", "vid_vsync": "W18", "vid_hsync": "Y16",
        "vid_iic_scl_io": "Y17", "vid_iic_sda_io": "W19",
        "{vid_data[0]}": "W13", "{vid_data[1]}": "T10", "{vid_data[2]}": "V12",
        "{vid_data[3]}": "T11", "{vid_data[4]}": "W16", "{vid_data[5]}": "Y14",
        "{vid_data[6]}": "V16", "{vid_data[7]}": "W14",
    }
    assert constraints.count("PACKAGE_PIN") == len(expected)
    for port, pin in expected.items():
        assert f"set_property -dict {{PACKAGE_PIN {pin} IOSTANDARD LVCMOS33}} [get_ports {port}]" in constraints.splitlines()


@pytest.mark.parametrize("matches", [True, False, None])
def test_direct_plug_no_download_requires_matching_active_pl(tmp_path: Path, monkeypatch: pytest.MonkeyPatch, matches: bool | None) -> None:
    bitstream = tmp_path / "prototype.bit"
    bitstream.write_bytes(b"test")
    bitstream.with_suffix(".hwh").write_bytes(b"test")
    calls: list[tuple[str, bool]] = []

    def overlay(path: str, download: bool) -> SimpleNamespace:
        calls.append((path, download))
        return SimpleNamespace(ip_dict={name: {} for name in direct_capture.REQUIRED_IP})

    active = str(bitstream) if matches else (None if matches is None else str(tmp_path / "old.bit"))
    monkeypatch.setitem(sys.modules, "pynq", SimpleNamespace(Overlay=overlay, PL=SimpleNamespace(bitfile_name=active)))
    monkeypatch.setattr(direct_capture.os, "geteuid", lambda: 0, raising=False)
    monkeypatch.setattr(sys, "argv", ["capture", str(bitstream), "--load-only", "--no-download"])
    if matches:
        direct_capture.main()
        assert calls == [(str(bitstream.resolve()), False)]
    else:
        with pytest.raises(RuntimeError, match="Active PL bitstream"):
            direct_capture.main()
        assert not calls


def test_direct_plug_live_rejects_capture_only_overlay(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> None:
    bitstream = tmp_path / "capture_only.bit"
    bitstream.write_bytes(b"test")
    bitstream.with_suffix(".hwh").write_bytes(b"test")

    def overlay(path: str, download: bool) -> SimpleNamespace:
        assert not download
        return SimpleNamespace(ip_dict={name: {} for name in direct_capture.REQUIRED_IP})

    monkeypatch.setitem(sys.modules, "pynq", SimpleNamespace(Overlay=overlay, PL=SimpleNamespace(bitfile_name=str(bitstream))))
    monkeypatch.setattr(direct_capture.os, "geteuid", lambda: 0, raising=False)
    monkeypatch.setattr(sys, "argv", ["capture", str(bitstream), str(tmp_path / "frame.ppm"), "--no-download", "--live"])
    with pytest.raises(RuntimeError, match="bidirectional camera HDMI overlay"):
        direct_capture.main()


@pytest.mark.parametrize(("retain_frames", "second_status", "released", "isolated"), [(0, 200, 4, False), (2, 503, 0, False), (0, 200, 0, True)])
def test_direct_plug_mjpeg_stream_releases_frame(monkeypatch: pytest.MonkeyPatch, retain_frames: int, second_status: int, released: int, isolated: bool) -> None:
    ready = Event()
    state: dict[str, int] = {"released": 0}

    class OneRequestServer(HTTPServer):
        def __init__(self, address: tuple[str, int], handler: object) -> None:
            super().__init__((address[0], 0), handler)
            state["port"] = self.server_port
            ready.set()

        def serve_forever(self) -> None:
            self.timeout = 3
            self.handle_request()
            self.handle_request()

    class Frame:
        def __array__(self, dtype: object = None) -> np.ndarray:
            return np.zeros((2, 2, 3), dtype=np.uint8)

        def freebuffer(self) -> None:
            state["released"] += 1

    class Channel:
        def __init__(self) -> None:
            self.calls = 0

        def readframe(self) -> Frame:
            self.calls += 1
            if self.calls % 3 == 0:
                raise BrokenPipeError()
            return Frame()

    class Image:
        def save(self, output: object, format: str, quality: int) -> None:
            assert format == "JPEG" and quality == 80
            output.write(b"test-jpeg")

    monkeypatch.setitem(sys.modules, "PIL", SimpleNamespace(Image=SimpleNamespace(fromarray=lambda array, mode: Image())))
    monkeypatch.setattr(direct_capture, "HTTPServer", OneRequestServer)
    source = direct_capture.LatestFrameSource() if isolated else Channel()
    if isolated:
        monkeypatch.setattr(source, "readframe", Channel().readframe)
    thread = Thread(target=direct_capture.serve_mjpeg, args=(source, "127.0.0.1", 0, retain_frames), daemon=True)
    thread.start()
    assert ready.wait(3)
    for attempt in range(2):
        connection = HTTPConnection("127.0.0.1", int(state["port"]), timeout=3)
        connection.request("GET", "/camera.mjpg")
        response = connection.getresponse()
        assert response.status == (200 if attempt == 0 else second_status)
        if response.status == 200:
            assert response.getheader("Content-Type") == "multipart/x-mixed-replace; boundary=frame"
            assert response.read().count(b"--frame\r\nContent-Type: image/jpeg\r\nContent-Length: 9\r\n\r\ntest-jpeg") == 2
        else:
            response.read()
        connection.close()
    thread.join(3)
    assert not thread.is_alive() and state["released"] == released


def test_direct_plug_isolated_display_owns_distinct_frames() -> None:
    stop = Event()
    source = direct_capture.LatestFrameSource()
    captured = np.full((2, 3, 3), 42, dtype=np.uint8)
    state = {"released": False}

    class Frame:
        def __array__(self, dtype: object = None) -> np.ndarray:
            return captured

        def freebuffer(self) -> None:
            state["released"] = True

    class Channel:
        def readframe(self) -> Frame:
            stop.set()
            return Frame()

    class Display:
        def newframe(self) -> np.ndarray:
            return np.empty_like(captured)

        def writeframe(self, frame: np.ndarray) -> None:
            assert np.all(frame == 42) and not np.shares_memory(frame, captured)

    direct_capture.drive_isolated_display(Channel(), Display(), source, stop)
    captured.fill(0)
    assert not state["released"] and source.generation == 1
    assert np.all(source.readframe() == 42)


def test_direct_plug_mjpeg_measurement_summary() -> None:
    samples = [
        {"timestamp": 1.0, "std": 20.0, "sha256": "first"},
        {"timestamp": 1.1, "std": 0.0, "sha256": "black"},
        {"timestamp": 1.2, "std": 20.0, "sha256": "first"},
    ]
    assert summarize_mjpeg(samples) == {
        "frames": 3, "fps": 10.0, "p50_ms": 100.0, "p95_ms": 100.0,
        "max_ms": 100.0, "black_frames": 1, "unique_frames": 2,
    }


def test_direct_plug_recovers_dma_interrupts_from_matching_hwh(monkeypatch: pytest.MonkeyPatch, tmp_path: Path) -> None:
    hwh = tmp_path / "camera.hwh"
    hwh.write_text("test", encoding="ascii")
    interrupt_names = {"s2mm_introut", "mm2s_introut"}
    recovered = {name: {"fullpath": f"frame_dma/{name}", "index": index} for index, name in enumerate(sorted(interrupt_names))}
    description = {"interrupts": {}, "parameters": {"C_INCLUDE_MM2S": "1"}}
    device = SimpleNamespace(interrupt_pins={}, interrupt_controllers={})
    overlay = SimpleNamespace(ip_dict={"frame_dma": description}, device=device)
    legacy = SimpleNamespace(ip_dict={"frame_dma": {"interrupts": recovered}}, interrupt_pins={entry["fullpath"]: entry for entry in recovered.values()}, interrupt_controllers={})
    monkeypatch.setitem(sys.modules, "pynq.lib.video.dma", SimpleNamespace(AxiVDMA=lambda value: SimpleNamespace(
        description=value, readchannel=SimpleNamespace(_interrupt=None), mmio=SimpleNamespace(read=lambda offset: 0x1000)
    )))
    monkeypatch.setitem(sys.modules, "pynq.pl_server.hwh_parser", SimpleNamespace(HWH=lambda path: legacy))

    driver_description = direct_capture.open_frame_dma(overlay, hwh)
    assert set(driver_description.description["interrupts"]) == interrupt_names
    assert isinstance(driver_description.readchannel._interrupt, direct_capture.FrameDonePoller)
    asyncio.run(driver_description.readchannel._interrupt.wait())
    assert description["interrupts"] == {}
    assert set(device.interrupt_pins) == {f"frame_dma/{name}" for name in interrupt_names}

    legacy.ip_dict["frame_dma"]["interrupts"] = {}
    with pytest.raises(RuntimeError, match="VDMA interrupts missing from HWH"):
        direct_capture.open_frame_dma(overlay, hwh)


def test_direct_plug_s2mm_poll_timeout() -> None:
    poller = direct_capture.FrameDonePoller(SimpleNamespace(read=lambda offset: 0), timeout=0.001)
    with pytest.raises(TimeoutError, match="S2MM frame completion timed out"):
        asyncio.run(poller.wait())


def test_direct_plug_guard_stops_both_dma_channels(tmp_path: Path) -> None:
    hwh = tmp_path / "camera.hwh"
    hwh.write_text('<SYSTEM><MODULE INSTANCE="frame_dma"><PARAMETER NAME="C_BASEADDR" VALUE="0x0"/></MODULE></SYSTEM>', encoding="ascii")
    memory = tmp_path / "registers"
    memory.write_bytes(b"\0" * 4096)
    assert stop_frame_dma(hwh, memory) == (0, 0)
    registers = memory.read_bytes()
    assert registers[0:4] == (0x11080).to_bytes(4, "little")
    assert registers[0x30:0x34] == (0x11080).to_bytes(4, "little")


def test_direct_plug_sensor_uses_upstream_register_sequence() -> None:
    class FakeIic:
        def __init__(self) -> None:
            self.writes: list[bytes] = []

        def send(self, address: int, packet: bytes, length: int) -> int:
            assert address == 0x3C
            self.writes.append(packet)
            return length

    iic = FakeIic()
    with patch("board.pynq_z2.capture_camera_direct_plug.time.sleep", return_value=None):
        configure_sensor(iic)

    assert iic.writes == [bytes((register >> 8, register & 0xFF, value)) for register, value in SENSOR_CONFIG]


def test_direct_plug_sensor_reports_failed_transaction_and_iic_state() -> None:
    class FailedIic:
        def send(self, address: int, packet: bytes, length: int) -> int:
            raise RuntimeError("Could not send I2C data")

        def read(self, offset: int) -> int:
            return {0x100: 0x01, 0x104: 0xC0}[offset]

    with pytest.raises(RuntimeError, match="write 1/253 at 0x3103 failed; AXI IIC CR=0x01, SR=0xC0"):
        configure_sensor(FailedIic())


def test_direct_plug_first_write_probes_once_even_on_failure(capsys: pytest.CaptureFixture[str]) -> None:
    class FailedIic:
        def __init__(self) -> None:
            self.writes: list[tuple[int, bytes, int]] = []

        def send(self, address: int, packet: bytes, length: int) -> int:
            self.writes.append((address, packet, length))
            raise RuntimeError("Could not send I2C data")

        def read(self, offset: int) -> int:
            return {0x100: 0x09, 0x104: 0xC0, 0x20: 0xD6}[offset]

    iic = FailedIic()
    with pytest.raises(RuntimeError, match="Could not send I2C data"):
        probe_first_write(iic)

    assert iic.writes == [(0x3C, b"\x31\x03\x11", 3)]
    assert "CAMERA_IIC_BEFORE=CR:0x09 SR:0xC0 IISR:0xD6" in capsys.readouterr().out


def test_direct_plug_reads_chip_id_with_original_stop_sequence(capsys: pytest.CaptureFixture[str]) -> None:
    class FakeIic:
        def __init__(self) -> None:
            self.transactions: list[tuple[str, int, bytes | int]] = []

        def send(self, address: int, packet: bytes, length: int) -> int:
            self.transactions.append(("send", address, packet))
            return length

        def receive(self, address: int, data: bytearray, length: int) -> int:
            self.transactions.append(("receive", address, length))
            data[0] = (0x56, 0x40)[len(self.transactions) // 2 - 1]
            return length

    iic = FakeIic()
    with patch("board.pynq_z2.capture_camera_direct_plug.time.sleep", return_value=None):
        assert probe_chip_id(iic) == 0x5640

    assert iic.transactions == [
        ("send", 0x3C, b"\x30\x0A"),
        ("receive", 0x3C, 1),
        ("send", 0x3C, b"\x30\x0B"),
        ("receive", 0x3C, 1),
    ]
    assert "CAMERA_IIC_CHIP_ID_STATUS=PASS" in capsys.readouterr().out


def test_direct_plug_chip_id_uses_driver_ffi_receive_buffer() -> None:
    allocations: list[list[int]] = []

    def allocate(declaration: str) -> list[int]:
        assert declaration == "unsigned char[1]"
        buffer = [0]
        allocations.append(buffer)
        return buffer

    class FakeIic:
        _ffi = SimpleNamespace(new=allocate)

        def send(self, address: int, packet: bytes, length: int) -> int:
            return length

        def receive(self, address: int, data: list[int], length: int) -> int:
            assert data is allocations[-1]
            assert not isinstance(data, bytearray)
            data[0] = (0x56, 0x40)[len(allocations) - 1]
            return length

    with patch("board.pynq_z2.capture_camera_direct_plug.time.sleep", return_value=None):
        assert probe_chip_id(FakeIic()) == 0x5640
    assert len(allocations) == 2


def test_direct_plug_chip_id_stops_after_first_nack() -> None:
    class FailedIic:
        def __init__(self) -> None:
            self.calls = 0

        def send(self, address: int, packet: bytes, length: int) -> int:
            self.calls += 1
            raise RuntimeError("Could not send I2C data")

    iic = FailedIic()
    with patch("board.pynq_z2.capture_camera_direct_plug.time.sleep", return_value=None):
        with pytest.raises(RuntimeError, match="Could not send I2C data"):
            probe_chip_id(iic)
    assert iic.calls == 1


def test_direct_plug_frame_rejects_blank_and_saves_ppm(tmp_path: Path) -> None:
    blank = np.zeros((HEIGHT, WIDTH, 3), dtype=np.uint8)
    output = tmp_path / "camera.ppm"
    with pytest.raises(RuntimeError, match="Nearly constant"):
        save_frame(blank, output)
    assert not output.exists()

    frame = blank.copy()
    frame[:, :, 0] = np.arange(WIDTH, dtype=np.uint16) % 256
    stats = save_frame(frame, output)
    assert stats["min"] == 0 and stats["max"] == 255
    assert output.read_bytes() == f"P6\n{WIDTH} {HEIGHT}\n255\n".encode("ascii") + frame.tobytes()


class FakeMmio:
    def __init__(self, samples: list[int]) -> None:
        self.samples = deque(samples)
        self.writes: list[tuple[int, int]] = []

    def read(self, offset: int = 0, length: int = 4) -> int:
        if offset == SccbBus.DATA_OFFSET:
            return self.writes[-1][1]
        assert offset == SccbBus.SAMPLE_OFFSET
        assert length == 4
        return self.samples.popleft()

    def write(self, offset: int, data: int) -> None:
        assert offset == SccbBus.DATA_OFFSET
        self.writes.append((offset, data))


def add_start(samples: list[int]) -> None:
    samples.append(SccbBus.SCL_SAMPLE)


def add_stop(samples: list[int]) -> None:
    samples.append(SccbBus.SCL_SAMPLE)


def add_write_byte(samples: list[int]) -> None:
    samples.extend([SccbBus.SCL_SAMPLE] * 8)
    samples.extend([SccbBus.SCL_SAMPLE, SccbBus.SCL_SAMPLE])


def add_read_byte(samples: list[int], value: int) -> None:
    for shift in range(7, -1, -1):
        samples.append(SccbBus.SCL_SAMPLE)
        samples.append(
            SccbBus.SCL_SAMPLE
            | (SccbBus.SDA_SAMPLE if value & (1 << shift) else 0)
        )
    samples.append(SccbBus.SCL_SAMPLE)


def add_register_read(samples: list[int], value: int) -> None:
    add_start(samples)
    add_write_byte(samples)
    add_write_byte(samples)
    add_write_byte(samples)
    add_stop(samples)
    add_start(samples)
    add_write_byte(samples)
    add_read_byte(samples, value)
    add_stop(samples)


def test_reads_ov5640_chip_id_with_open_drain_transactions() -> None:
    samples: list[int] = []
    add_register_read(samples, 0x56)
    add_register_read(samples, 0x40)
    mmio = FakeMmio(samples)

    with patch("board.pynq_z2.camera_driver.time.sleep", return_value=None):
        bus = SccbBus(mmio)
        assert bus.read_ov5640_chip_id() == 0x5640

    assert not mmio.samples
    assert mmio.writes
    assert all((value & ~0x7) == 0 for _, value in mmio.writes)
    assert mmio.writes[-1][1] & (SccbBus.SCL_LOW | SccbBus.SDA_LOW) == 0


@pytest.mark.parametrize("chip_id", [0x5640, 0xFFFF])
def test_gpio_probe_register_reads_and_cleanup(chip_id: int, capsys: pytest.CaptureFixture[str]) -> None:
    samples = [SccbBus.SCL_SAMPLE] * 10
    add_register_read(samples, chip_id >> 8)
    add_register_read(samples, chip_id & 0xFF)
    mmio = FakeMmio(samples)
    with patch("board.pynq_z2.camera_driver.time.sleep", return_value=None):
        if chip_id == 0x5640:
            assert gpio_probe.probe_gpio_chip_id(mmio) == chip_id
        else:
            with pytest.raises(RuntimeError, match="Unexpected OV5640 chip ID"):
                gpio_probe.probe_gpio_chip_id(mmio)
    assert not mmio.samples
    assert mmio.writes[-1][1] == 0
    output = capsys.readouterr().out
    assert "CAMERA_ID_GPIO_PHASE=read_0x300A" in output
    assert "CAMERA_ID_GPIO_CLEANUP_CONTROL=0x00000000" in output


def test_gpio_probe_first_nack_cleans_up_without_second_read(capsys: pytest.CaptureFixture[str]) -> None:
    samples = [SccbBus.SCL_SAMPLE] * 10
    add_start(samples)
    samples.extend([SccbBus.SCL_SAMPLE] * 9)
    samples.append(SccbBus.SCL_SAMPLE | SccbBus.SDA_SAMPLE)
    add_stop(samples)
    mmio = FakeMmio(samples)
    with patch("board.pynq_z2.camera_driver.time.sleep", return_value=None):
        with pytest.raises(RuntimeError, match="SCCB NACK after byte 0x78"):
            gpio_probe.probe_gpio_chip_id(mmio)
    assert not mmio.samples
    assert mmio.writes[-1][1] == 0
    output = capsys.readouterr().out
    assert "read_0x300B" not in output
    assert "CAMERA_ID_GPIO_CLEANUP_CONTROL=0x00000000" in output


@pytest.mark.parametrize("samples", [[3, 2, 3, 1, 3], [3, 3]])
def test_gpio_line_check_verifies_pull_low_and_release_with_cleanup(samples: list[int]) -> None:
    mmio = FakeMmio(samples)
    with patch.object(gpio_probe.time, "sleep", return_value=None):
        if samples == [3, 2, 3, 1, 3]:
            gpio_probe.probe_gpio_lines(mmio)
            assert [value for _, value in mmio.writes] == [0, 1, 0, 2, 0, 0]
        else:
            with pytest.raises(RuntimeError, match="differs from expected"):
                gpio_probe.probe_gpio_lines(mmio)
    assert not mmio.samples
    assert mmio.writes[-1][1] == 0
    assert all(value & SccbBus.XCLK_ENABLE == 0 for _, value in mmio.writes)


@pytest.mark.parametrize("active_matches", [False, True])
def test_gpio_probe_rejects_wrong_active_pl_or_build_id(tmp_path: Path, active_matches: bool) -> None:
    bitstream = tmp_path / "camera.bit"
    bitstream.touch()
    bitstream.with_suffix(".hwh").touch()
    loaded = []
    def overlay_factory(path: str, *, download: bool) -> object:
        loaded.append(path)
        assert not download
        return object()
    pynq = SimpleNamespace(
        Overlay=overlay_factory,
        PL=SimpleNamespace(bitfile_name=str(bitstream) if active_matches else "other.bit"),
    )
    with patch.dict(sys.modules, {"pynq": pynq}), \
         patch.object(sys, "argv", ["probe", str(bitstream), "--no-download"]), \
         patch.object(gpio_probe.os, "geteuid", return_value=0, create=True), \
         patch.object(gpio_probe, "get_mmio", return_value=SimpleNamespace(read=lambda offset: 0)) as get_mmio:
        with pytest.raises(RuntimeError, match="BUILD_ID" if active_matches else "Active PL bit"):
            gpio_probe.main()
    assert len(loaded) == int(active_matches)
    assert get_mmio.call_count == int(active_matches)


@pytest.mark.parametrize("layout,build_id,accepted", [
    ("direct", 0xC00A00D1, True),
    ("remap", 0xC00A00D2, True),
    ("corrected", 0xC00A00D3, True),
    ("direct", 0xC00A00D2, False),
    ("remap", 0xC00A00D1, False),
    ("corrected", 0xC00A00D1, False),
    ("direct", 0xC00A00D3, False),
    ("remap", 0xC00A00D3, False),
])
def test_gpio_probe_pin_layout_build_id_gate(
    tmp_path: Path, layout: str, build_id: int, accepted: bool,
) -> None:
    bitstream = tmp_path / "camera.bit"
    bitstream.touch()
    bitstream.with_suffix(".hwh").touch()
    pynq = SimpleNamespace(
        Overlay=lambda path, download: object(),
        PL=SimpleNamespace(bitfile_name=str(bitstream)),
    )
    arguments = ["probe", str(bitstream), "--no-download", "--load-only", "--pin-layout", layout]
    with patch.dict(sys.modules, {"pynq": pynq}), \
         patch.object(sys, "argv", arguments), \
         patch.object(gpio_probe.os, "geteuid", return_value=0, create=True), \
         patch.object(gpio_probe, "get_mmio", return_value=SimpleNamespace(read=lambda offset: build_id)) as get_mmio:
        if accepted:
            gpio_probe.main()
        else:
            with pytest.raises(RuntimeError, match="BUILD_ID"):
                gpio_probe.main()
    assert get_mmio.call_count == 1


def test_writes_ov5640_register_with_open_drain_transactions() -> None:
    samples: list[int] = []
    add_start(samples)
    for _ in range(4):
        add_write_byte(samples)
    add_stop(samples)
    mmio = FakeMmio(samples)

    with patch("board.pynq_z2.camera_driver.time.sleep", return_value=None):
        bus = SccbBus(mmio)
        bus.write_register(0x3C, 0x3008, 0x02)

    assert not mmio.samples
    assert all((value & ~0x7) == 0 for _, value in mmio.writes)
    assert mmio.writes[-1][1] & (SccbBus.SCL_LOW | SccbBus.SDA_LOW) == 0


def test_xclk_enable_does_not_drive_sccb() -> None:
    mmio = FakeMmio([])
    bus = SccbBus(mmio)

    bus.set_xclk_enabled(True)
    bus.release_bus()
    bus.set_xclk_enabled(False)

    assert [value for _, value in mmio.writes] == [
        0,
        SccbBus.XCLK_ENABLE,
        SccbBus.XCLK_ENABLE,
        0,
    ]


def test_decodes_camera_status_word() -> None:
    value = (37 << 25) | (29 << 19) | (17 << 13) | (1 << 12) | (1 << 10) | (0xA5 << 2) | 0x3

    assert decode_camera_status(value) == {
        "scl": 1,
        "sda": 1,
        "data": 0xA5,
        "pclk": 1,
        "vsync": 0,
        "href": 1,
        "pclk_edges": 17,
        "vsync_edges": 29,
        "href_edges": 37,
    }


class FakeFrameMmio:
    def __init__(self, pixels: bytes, status: int = FRAME_DONE) -> None:
        self.pixels = pixels
        self.status = status
        self.address = 0
        self.capture_enabled = False

    def read(self, offset: int = 0, length: int = 4) -> int:
        assert offset == 0x8
        return self.status | self.pixels[self.address]

    def write(self, offset: int, data: int) -> None:
        assert offset == 0x0
        if data == 0:
            self.address = 0
            self.capture_enabled = False
            return
        assert data & CAPTURE_ENABLE
        self.capture_enabled = True
        self.address = data & (CAPTURE_ENABLE - 1)


def test_exports_complete_grayscale_frame(tmp_path: Path) -> None:
    pixels = bytes(index % 256 for index in range(FRAME_WIDTH * FRAME_HEIGHT))
    output = tmp_path / "frame.pgm"

    save_grayscale_frame(FakeFrameMmio(pixels), output)

    assert output.read_bytes() == b"P5\n160 120\n255\n" + pixels


@pytest.mark.parametrize("status", [0, FRAME_ERROR, FRAME_DONE | FRAME_ERROR])
def test_rejects_unavailable_grayscale_frame(status: int) -> None:
    with pytest.raises(RuntimeError):
        read_grayscale_frame(FakeFrameMmio(bytes(FRAME_WIDTH * FRAME_HEIGHT), status))


class FakeRegisterBus:
    def __init__(self, chip_id: int = 0x5640) -> None:
        self.chip_id = chip_id
        self.registers: dict[int, int] = {0x3820: 0x46, 0x3821: 0x20, 0x3002: 0, 0x3006: 0}
        self.writes: list[tuple[int, int, int]] = []

    def read_ov5640_chip_id(self) -> int:
        return self.chip_id

    def read_register(self, device_address: int, register: int) -> int:
        assert device_address == 0x3C
        return self.registers[register]

    def write_register(self, device_address: int, register: int, value: int) -> None:
        self.writes.append((device_address, register, value))
        self.registers[register] = value


def test_configures_vga_yuv_only_after_readback() -> None:
    bus = FakeRegisterBus()

    with patch("board.pynq_z2.ov5640_vga.time.sleep"):
        configure_vga_yuv(bus)

    assert bus.writes[0] == (0x3C, 0x3008, 0x42)
    assert bus.writes[-1] == (0x3C, 0x3008, 0x02)
    assert bus.writes.index((0x3C, 0x4740, 0x20)) < bus.writes.index((0x3C, 0x300E, 0x18))
    assert bus.writes.index((0x3C, 0x300E, 0x58)) < bus.writes.index((0x3C, 0x300E, 0x18))
    assert bus.registers[0x3820] & 1
    assert bus.registers[0x3821] & 1
    assert bus.registers[0x3821] & 0x20 == 0
    assert (bus.registers[0x3808], bus.registers[0x3809]) == (0x02, 0x80)
    assert (bus.registers[0x380A], bus.registers[0x380B]) == (0x01, 0xE0)


def test_rejects_sensor_identity_before_register_writes() -> None:
    bus = FakeRegisterBus(chip_id=0x0000)

    with pytest.raises(RuntimeError, match="chip ID"):
        configure_vga_yuv(bus)

    assert not bus.writes


def test_rejects_sensor_readback_before_streaming() -> None:
    bus = FakeRegisterBus()
    original_read = bus.read_register

    def incorrect_read(device_address: int, register: int) -> int:
        if register == 0x3809:
            return 0
        return original_read(device_address, register)

    with patch.object(bus, "read_register", side_effect=incorrect_read):
        with pytest.raises(RuntimeError, match="0x3809"):
            configure_vga_yuv(bus)

    assert bus.writes[-1] != (0x3C, 0x3008, 0x02)


def test_capture_failure_disables_clock_and_releases_bus(tmp_path: Path) -> None:
    class FakeCaptureBus(FakeRegisterBus):
        def __init__(self) -> None:
            super().__init__()
            self.xclk_enabled = False
            self.released = False

        def set_xclk_enabled(self, enabled: bool) -> None:
            self.xclk_enabled = enabled

        def recover(self) -> None:
            pass

        def release_bus(self) -> None:
            self.released = True

    bus = FakeCaptureBus()
    frame_mmio = FakeFrameMmio(bytes(FRAME_WIDTH * FRAME_HEIGHT), status=0)

    with patch("board.pynq_z2.export_camera_frame.time.sleep"):
        with patch("board.pynq_z2.export_camera_frame.configure_vga_yuv", side_effect=RuntimeError("readback")):
            with pytest.raises(RuntimeError, match="readback"):
                capture_and_save(bus, frame_mmio, tmp_path / "frame.pgm")

    assert frame_mmio.address == 0
    assert not frame_mmio.capture_enabled
    assert bus.writes[-1] == (0x3C, 0x3008, 0x42)
    assert bus.released
    assert not bus.xclk_enabled


def test_capture_timeout_disables_clock_and_capture(tmp_path: Path, capsys: pytest.CaptureFixture[str]) -> None:
    bus = FakeRegisterBus()
    frame_mmio = FakeFrameMmio(bytes(FRAME_WIDTH * FRAME_HEIGHT), status=0)
    diagnostic_mmio = FakeMmio([0, 0, 1 << 11, 0])

    with patch("board.pynq_z2.export_camera_frame.configure_vga_yuv"):
        with patch("board.pynq_z2.export_camera_frame.time.sleep"):
            with patch.object(bus, "set_xclk_enabled", create=True) as set_clock:
                with patch.object(bus, "recover", create=True):
                    with patch.object(bus, "release_bus", create=True) as release:
                        with pytest.raises(TimeoutError):
                            capture_and_save(
                                bus, frame_mmio, tmp_path / "frame.pgm", timeout_s=0,
                                diagnostic_mmio=diagnostic_mmio,
                            )

    output = capsys.readouterr().out
    assert "CAMERA_STREAM_START_DVP=" in output
    assert "CAMERA_TIMEOUT_LIVE_VSYNC samples=1 high=1 rises=1" in output
    assert set_clock.call_args_list[-1].args == (False,)
    release.assert_called_once()
    assert not frame_mmio.capture_enabled


def test_capture_retries_incomplete_initial_frame(tmp_path: Path) -> None:
    class RetryFrameMmio(FakeFrameMmio):
        def __init__(self) -> None:
            super().__init__(bytes(FRAME_WIDTH * FRAME_HEIGHT), status=FRAME_ERROR)
            self.resets = 0

        def write(self, offset: int, data: int) -> None:
            super().write(offset, data)
            if data == 0:
                self.resets += 1
                self.status = FRAME_ERROR if self.resets == 1 else FRAME_DONE

    bus = FakeRegisterBus()
    frame_mmio = RetryFrameMmio()
    output = tmp_path / "frame.pgm"

    with patch("board.pynq_z2.export_camera_frame.configure_vga_yuv"):
        with patch("board.pynq_z2.export_camera_frame.time.sleep"):
            with patch.object(bus, "set_xclk_enabled", create=True):
                with patch.object(bus, "recover", create=True):
                    with patch.object(bus, "release_bus", create=True):
                        capture_and_save(bus, frame_mmio, output)

    assert frame_mmio.resets == 3
    assert not frame_mmio.capture_enabled
    assert output.read_bytes() == b"P5\n160 120\n255\n" + bytes(FRAME_WIDTH * FRAME_HEIGHT)
