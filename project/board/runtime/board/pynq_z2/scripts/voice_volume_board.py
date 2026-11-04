"""Explicit, cold-board VOL1 acceptance binding; no hardware action on import."""

import argparse
from contextlib import contextmanager, ExitStack
import ctypes
import hashlib
from importlib.metadata import distribution
import json
import mmap
import os
from pathlib import Path
import signal
import subprocess
import time
from xml.etree import ElementTree as ET


BASE_HASHES = {
    "base.bit": "d9aec0ff1cddeaf109dd08b1510c2ed38b4804bd29ef7648ee80eac8f06de505",
    "base.hwh": "94dee45319dfecb22d9684eb565916e62f910eb999650c9a99fda51bdc9158fe",
}
VOL1_HASHES = {
    "voice_volume.bit": "b2fb95be8c36569f2eae79e8214d4dc4d1ee1ccc194472b574969509497a51a4",
    "voice_volume.hwh": "0409d1e88c40599667962c7818bda55a6a2f6dcbe14cb6f320b3c7cc6760e9e1",
}
BASE_DMA = {"video_axi_vdma": 0x43000000,
            "trace_analyzer_pmodb_axi_dma_0": 0x80420000,
            "trace_analyzer_pi_axi_dma_0": 0x80430000}


def checkpoint(root, phase):
    entry = {"phase": phase, "pid": os.getpid(), "monotonic_ns": time.monotonic_ns()}
    text = json.dumps(entry)
    with (root / "startup-phases.jsonl").open("a", encoding="utf-8") as output:
        output.write(text + "\n")
        output.flush()
        os.fsync(output.fileno())
    print(text, flush=True)


class I2CMessage(ctypes.Structure):
    _fields_ = [("addr", ctypes.c_uint16), ("flags", ctypes.c_uint16),
                ("length", ctypes.c_uint16), ("buffer", ctypes.POINTER(ctypes.c_uint8))]


class I2CTransfer(ctypes.Structure):
    _fields_ = [("messages", ctypes.POINTER(I2CMessage)), ("count", ctypes.c_uint32)]


class LinuxBackend:
    def __init__(self, *, base_address=0x43C00000):
        if type(base_address) is not int or base_address not in (0x43C00000, 0x43C10000):
            raise ValueError("explicit independent or fused VOL1 control address required")
        import fcntl
        self.memory = self.window = self.i2c = None
        try:
            adapter = Path("/sys/class/i2c-adapter/i2c-1")
            if "e0005000" not in str(adapter.resolve()):
                raise RuntimeError("PS IIC1 device mapping changed")
            self.memory = os.open("/dev/mem", os.O_RDWR | os.O_SYNC | os.O_CLOEXEC)
            self.window = mmap.mmap(self.memory, 4096, offset=base_address)
            self.i2c = os.open("/dev/i2c-1", os.O_RDWR | os.O_CLOEXEC)
            fcntl.ioctl(self.i2c, 0x0702, 10)
            fcntl.ioctl(self.i2c, 0x0701, 0)
        except BaseException:
            self.close()
            raise

    def read32(self, offset):
        if type(offset) is not int or offset % 4 or not 0 <= offset < 4096:
            raise ValueError("unaligned/out-of-range VOL1 register")
        return ctypes.c_uint32.from_buffer(self.window, offset).value

    def write32(self, offset, value):
        if type(offset) is not int or offset % 4 or not 0 <= offset < 4096:
            raise ValueError("unaligned/out-of-range VOL1 register")
        if type(value) is not int or not 0 <= value <= 0xFFFFFFFF:
            raise ValueError("uint32 value required")
        with memoryview(self.window).cast("I") as words:
            if words.itemsize != 4:
                raise RuntimeError("32-bit native unsigned int required")
            words[offset // 4] = value

    def _transfer(self, register, payload=None, length=0):
        import fcntl
        if type(register) is not int or not 0 <= register <= 0xFFFF:
            raise ValueError("uint16 codec register required")
        if payload is not None and (type(payload) is not bytes or not 0 < len(payload) <= 32):
            raise ValueError("bounded codec payload required")
        if payload is None and (type(length) is not int or not 0 < length <= 32):
            raise ValueError("bounded codec read required")
        outgoing = register.to_bytes(2, "big") + (payload or b"")
        write_buffer = (ctypes.c_uint8 * len(outgoing)).from_buffer_copy(outgoing)
        read_buffer = (ctypes.c_uint8 * length)()
        count = 1 if payload is not None else 2
        messages = (I2CMessage * count)()
        messages[0] = I2CMessage(0x3B, 0, len(outgoing), write_buffer)
        if count == 2:
            messages[1] = I2CMessage(0x3B, 1, length, read_buffer)
        transfer = I2CTransfer(messages, count)
        result = fcntl.ioctl(self.i2c, 0x0707, bytearray(transfer))
        if result != count:
            raise RuntimeError("short I2C_RDWR transfer")
        return len(payload) if payload is not None else bytes(read_buffer)

    def codec_read(self, register, length):
        return self._transfer(register, length=length)

    def codec_write(self, register, payload):
        return self._transfer(register, payload=payload)

    def close(self):
        if self.window is not None:
            self.window.close()
            self.window = None
        for attribute in ("memory", "i2c"):
            descriptor = getattr(self, attribute)
            if descriptor is not None:
                os.close(descriptor)
                setattr(self, attribute, None)


def validate_pair(root):
    for name, expected in VOL1_HASHES.items():
        if hashlib.sha256((root / "artifacts" / name).read_bytes()).hexdigest() != expected:
            raise RuntimeError("Frozen VOL1 pair changed: " + name)
    if (root / "artifacts/voice_volume.xsa").exists():
        raise RuntimeError("Runtime bit/HWH directory must not contain adjacent XSA")


def read_dma_registers(window, offset):
    control = ctypes.c_uint32.from_buffer(window, offset).value
    status = ctypes.c_uint32.from_buffer(window, offset + 4).value
    return control, status


def audit_base(boot_id):
    if Path("/proc/sys/kernel/random/boot_id").read_text().strip() != boot_id:
        raise RuntimeError("Boot identity changed")
    pynq_root = Path(distribution("pynq").locate_file("pynq"))
    if (pynq_root / "pl_server/global_pl_state_.json").exists():
        raise RuntimeError("Active PL metadata exists; no cold load permitted")
    base = pynq_root / "overlays/base"
    for name, expected in BASE_HASHES.items():
        if hashlib.sha256((base / name).read_bytes()).hexdigest() != expected:
            raise RuntimeError("Official Base identity changed")
    for service in ("bootpy.service", "clear_pl_statefile.service", "voice-view-shell.service"):
        completed = subprocess.run(["systemctl", "show", service, "-p", "ActiveState", "-p", "MainPID", "-p", "Result"],
                                   check=True, capture_output=True, text=True, timeout=5)
        properties = dict(line.split("=", 1) for line in completed.stdout.splitlines() if "=" in line)
        if properties != {"ActiveState": "inactive", "MainPID": "0", "Result": "success"}:
            raise RuntimeError("Startup/business service not quiescent: " + service)
    for process in Path("/proc").glob("[0-9]*/maps"):
        try:
            if "/dev/mem" in process.read_text() or "/dev/uio" in process.read_text():
                raise RuntimeError("Existing hardware mapping: " + str(process))
        except (FileNotFoundError, ProcessLookupError):
            continue
    tree = ET.parse(base / "base.hwh")
    modules = {node.get("INSTANCE"): node for node in tree.iter("MODULE")
               if node.get("MODTYPE") in ("axi_dma", "axi_vdma")}
    addresses = {node.get("INSTANCE"): int(node.get("BASEVALUE"), 0) for node in tree.iter("MEMRANGE")}
    if set(modules) != set(BASE_DMA) or any(addresses.get(name) != address for name, address in BASE_DMA.items()):
        raise RuntimeError("Base DMA inventory changed")
    report = []
    with ExitStack() as resources:
        descriptor = os.open("/dev/mem", os.O_RDWR | os.O_SYNC)
        resources.callback(os.close, descriptor)
        for name, address in BASE_DMA.items():
            parameters = {node.get("NAME"): node.get("VALUE") for node in modules[name].iter("PARAMETER")}
            window = resources.enter_context(mmap.mmap(descriptor, 4096, access=mmap.ACCESS_WRITE, offset=address))
            for direction, offset in (("MM2S", 0), ("S2MM", 0x30)):
                if parameters.get("C_INCLUDE_" + direction) == "1":
                    control, status = read_dma_registers(window, offset)
                    if control & 5 or not status & 1:
                        raise RuntimeError("Base DMA not halted: " + name + "/" + direction)
                    report.append({"instance": name, "direction": direction, "control": control, "status": status})
    return report


def threshold_sums(values=None):
    if values is None:
        return {"quiet_sum": 1, "soft_sum": 0xFFFFFFFE, "loud_sum": 0xFFFFFFFF}
    if type(values) not in (list, tuple) or len(values) != 3 or any(type(value) is not int for value in values):
        raise ValueError("three integer mean-absolute thresholds required")
    quiet, soft, loud = values
    if not 0 <= quiet < soft < loud <= 65535:
        raise ValueError("requires 0 <= quiet < soft < loud <= 65535")
    return dict(zip(("quiet_sum", "soft_sum", "loud_sum"), (value * 977 for value in values)))


@contextmanager
def managed_control(root, boot_id, *, trace_startup=False, thresholds=None):
    sums = threshold_sums(thresholds)
    import fcntl
    from voice_volume_control import ProcessTransport, VolumeControl, configure_codec
    checkpoint(root, "pair_validation_begin")
    validate_pair(root)
    with ExitStack() as resources:
        for name in ("/var/lock/voice-view-c6i.lock", "/run/lock/voice_pcm_audio.lock"):
            stream = resources.enter_context(open(name, "a+b"))
            fcntl.flock(stream.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
            stream.seek(0)
            if stream.read():
                raise RuntimeError("Cold load requires empty initial owner journals")
        checkpoint(root, "cold_audit_begin")
        dma = audit_base(boot_id)
        checkpoint(root, "cold_audit_passed")
        marker = Path("/run/lock") / ("voice-view-cold-" + boot_id + ".attempt")
        with marker.open("x") as output:
            json.dump({"profile": "VOICE_VOLUME_ONLY_V1", "pid": os.getpid(), "dma": dma}, output)
        checkpoint(root, "pynq_import_begin")
        from pynq import Overlay
        checkpoint(root, "overlay_load_begin")
        overlay = Overlay(str(root / "artifacts/voice_volume.bit"))
        checkpoint(root, "overlay_load_returned")
        checkpoint(root, "transport_spawn_begin")
        transport = ProcessTransport(LinuxBackend, timeout=2, trace_root=root if trace_startup else None)
        control = None
        try:
            checkpoint(root, "transport_spawn_returned")
            checkpoint(root, "identity_read_begin")
            control = VolumeControl(transport, exclusive_owner=True)
            checkpoint(root, "identity_read_passed")
            checkpoint(root, "disabled_configuration_begin")
            control.configure(**sums, enable=False)
            checkpoint(root, "disabled_configuration_passed")
            checkpoint(root, "codec_address_probe_begin")
            address_probe = transport.call("codec_read", 0x4000, 1, deadline=time.monotonic() + 0.5)
            print(json.dumps({"phase": "codec_address_confirmed", "address": "0x3b", "value": address_probe.hex()}), flush=True)
            checkpoint(root, "codec_address_probe_passed")
            checkpoint(root, "codec_configuration_begin")
            configure_codec(transport, stopped=True, straps_confirmed=True, mclk_hz=10_000_000, timeout=2)
            checkpoint(root, "codec_configuration_passed")
            control.configure(**sums, enable=True)
            checkpoint(root, "sampling_enabled")
            if trace_startup:
                transport.stop_trace()
                checkpoint(root, "startup_trace_stopped")
            print(json.dumps({"phase": "sampling_enabled", "build_id": "0xc00c0001", "pid": os.getpid(),
                              "event_thresholds": "unreachable-calibration-only" if thresholds is None else thresholds}), flush=True)
            yield control
        finally:
            try:
                if control is not None and not transport.failed:
                    control.configure(**sums, enable=False)
                    print(json.dumps({"phase": "sampling_disabled"}), flush=True)
            finally:
                transport.close()
                print(json.dumps({"phase": "transport_closed", "child_alive": transport.process.is_alive()}), flush=True)


def create():
    return managed_control(Path(os.environ["VOL1_ACCEPTANCE_ROOT"]), os.environ["VOL1_ACCEPTANCE_BOOT"],
                           trace_startup=os.environ.get("VOL1_STARTUP_TRACE") == "1",
                           thresholds=json.loads(os.environ.get("VOL1_FIXED_THRESHOLDS", "null")))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, required=True)
    parser.add_argument("--boot-id", required=True)
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=8771)
    parser.add_argument("--check-only", action="store_true")
    parser.add_argument("--trace-startup", action="store_true")
    parser.add_argument("--thresholds", nargs=3, type=int, metavar=("QUIET", "SOFT", "LOUD"))
    options = parser.parse_args()
    threshold_sums(options.thresholds)
    validate_pair(options.root)
    if options.check_only:
        print("VOL1_BOARD_BINDING_CHECK_ONLY_PASS")
        return 0
    from volume_monitor import main as run_monitor
    os.environ["VOL1_ACCEPTANCE_ROOT"] = str(options.root.resolve())
    os.environ["VOL1_ACCEPTANCE_BOOT"] = options.boot_id
    os.environ["VOL1_STARTUP_TRACE"] = "1" if options.trace_startup else "0"
    os.environ["VOL1_FIXED_THRESHOLDS"] = json.dumps(options.thresholds)
    def stop(signum, frame):
        raise KeyboardInterrupt
    signal.signal(signal.SIGTERM, stop)
    signal.signal(signal.SIGINT, stop)
    return run_monitor(["--control-factory", "voice_volume_board:create", "--host", options.host,
                        "--port", str(options.port)])


if __name__ == "__main__":
    raise SystemExit(main())