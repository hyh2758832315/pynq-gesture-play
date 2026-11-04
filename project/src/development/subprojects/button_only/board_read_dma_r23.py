"""Read only the R23b2 DMA/control registers after a retained stop.

Run: .venv/Scripts/python.exe -I -B subprojects/hdmi_input_osd/osd_reset_repair_r01/remote_r22.py subprojects/button_only/board_read_dma_r23.py --output build/button_only/r23b2-dma-read-UNIQUE.json --timeout 30
Output: remote receipt with two MMIO snapshots, 0.5 seconds apart.
Next: diagnose the exact halt state before recovery; do not write to DMA registers.
"""

import json
import mmap
import os
import struct
import time


REGISTERS = {
    'frame_dma': (0x43000000, (0x30, 0x34)),
    'moments_dma': (0x40420000, (0x30, 0x34)),
    'capture_status': (0x41410000, (0x00, 0x04, 0x08, 0x0C)),
    'capture_control': (0x413F0000, (0x00, 0x04, 0x08, 0x0C)),
    'moments_reset': (0x413D0000, (0x00, 0x04)),
    'build_id_gpio': (0x41200000, (0x00, 0x08)),
}


def snapshot():
    result = {}
    fd = os.open('/dev/mem', os.O_RDONLY | os.O_SYNC)
    try:
        for name, (base, offsets) in REGISTERS.items():
            with mmap.mmap(fd, mmap.PAGESIZE, access=mmap.ACCESS_READ, offset=base) as window:
                result[name] = {f'0x{offset:02X}': f'0x{struct.unpack_from("<I", window, offset)[0]:08X}'
                                for offset in offsets}
    finally:
        os.close(fd)
    return result


first = snapshot()
time.sleep(0.5)
second = snapshot()
print(json.dumps({'first': first, 'second': second}, ensure_ascii=False), flush=True)
