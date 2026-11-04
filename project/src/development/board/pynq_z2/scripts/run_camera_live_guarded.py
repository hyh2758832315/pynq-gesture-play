import mmap
import os
import signal
import subprocess
import sys
import time
from pathlib import Path
from xml.etree import ElementTree


def stop_frame_dma(hwh: Path, memory_device: Path = Path("/dev/mem")) -> tuple[int, int]:
    modules = ElementTree.parse(hwh).iter("MODULE")
    frame_dma = next(module for module in modules if module.get("INSTANCE") == "frame_dma")
    address = int(next(parameter.get("VALUE") for parameter in frame_dma.iter("PARAMETER") if parameter.get("NAME") == "C_BASEADDR"), 0)
    descriptor = os.open(memory_device, os.O_RDWR | getattr(os, "O_SYNC", 0))
    try:
        with mmap.mmap(descriptor, 4096, offset=address) as registers:
            stopped = (0x00011080).to_bytes(4, "little")
            registers[0x30:0x34] = stopped
            registers[0:4] = stopped
            states = tuple(int.from_bytes(registers[offset:offset + 4], "little") for offset in (0x34, 0x04))
    finally:
        os.close(descriptor)
    print(f"CAMERA_VDMA_GUARD_STOP={states}", flush=True)
    return states


def main() -> int:
    if os.geteuid() != 0 or len(sys.argv) < 4 or "--live" not in sys.argv[3:]:
        raise RuntimeError("Run as root: guarded.py CAPTURE_SCRIPT BITSTREAM OUTPUT --live [options]")
    script = Path(sys.argv[1]).resolve()
    bitstream = Path(sys.argv[2]).resolve()
    if not script.is_file() or not bitstream.is_file() or not bitstream.with_suffix(".hwh").is_file():
        raise FileNotFoundError("Capture script and matching bitstream/HWH are required")
    environment = {**os.environ, "XILINX_XRT": "/usr", "PYTHONDONTWRITEBYTECODE": "1", "PYTHONFAULTHANDLER": "1"}
    started = time.monotonic()
    child = subprocess.Popen(["/usr/local/share/pynq-venv/bin/python", "-u", str(script), str(bitstream), *sys.argv[3:]], env=environment)

    def forward_signal(number: int, frame: object) -> None:
        if child.poll() is None:
            child.send_signal(number)

    for number in (signal.SIGINT, signal.SIGTERM, signal.SIGHUP):
        signal.signal(number, forward_signal)
    try:
        return child.wait()
    finally:
        if child.poll() is None:
            child.terminate()
            try:
                child.wait(timeout=5)
            except subprocess.TimeoutExpired:
                child.kill()
                child.wait()
        print(f"CAMERA_LIVE_CHILD_EXIT={child.returncode} at={time.monotonic():.3f} elapsed={time.monotonic() - started:.3f}", flush=True)
        stop_frame_dma(bitstream.with_suffix(".hwh"))


if __name__ == "__main__":
    sys.exit(main())