"""Small, shared PS return control for menu, game and video scenes."""

from __future__ import annotations

import struct
import hashlib
import math
from functools import lru_cache
from dataclasses import dataclass, replace

from .controls import ControlState, StaleFlag
from .gpu_abi import (
    COMMAND_CAPACITY, GpuCommand, Opcode, PacketType,
    pack_resource_packet, unpack_resource_packet,
)
from .scene import LOGICAL_HEIGHT, LOGICAL_WIDTH
from .scene_compiler import SYSTEM_COLORS, SYSTEM_PALETTE_BANK


RETURN_SIZE = 24
RETURN_CENTER = (RETURN_SIZE // 2, RETURN_SIZE // 2)
RETURN_HIT_RADIUS = 12
RETURN_DWELL_NS = 2_000_000_000


@dataclass
class ReturnDwell:
    entered_ns: int | None = None
    fired: bool = False
    last_timestamp_ns: int = 0

    def reset(self) -> None:
        self.entered_ns = None
        self.fired = False
        self.last_timestamp_ns = 0

    @property
    def progress(self) -> float | None:
        if self.entered_ns is None:
            return None
        return min(1., max(0., (self.last_timestamp_ns-self.entered_ns)/RETURN_DWELL_NS))

    def update(self, inside: bool, timestamp_ns: int) -> bool:
        if not inside:
            self.reset()
            return False
        self.last_timestamp_ns = timestamp_ns
        if self.entered_ns is None or timestamp_ns < self.entered_ns:
            self.entered_ns = timestamp_ns
            self.fired = False
            return False
        if not self.fired and timestamp_ns - self.entered_ns >= RETURN_DWELL_NS:
            self.fired = True
            return True
        return False


def return_contains(control: ControlState) -> bool:
    if not control.hand_valid or control.stale_flags & (StaleFlag.GESTURE | StaleFlag.ADAPTER_ERROR):
        return False
    x = round((control.hand_x + 1.0) * (LOGICAL_WIDTH - 1) / 2.0)
    y = round((control.hand_y + 1.0) * (LOGICAL_HEIGHT - 1) / 2.0)
    return (x - RETURN_CENTER[0]) ** 2 + (y - RETURN_CENTER[1]) ** 2 <= RETURN_HIT_RADIUS ** 2


_FILL = (SYSTEM_PALETTE_BANK << 4) | 5
_GLYPH = (SYSTEM_PALETTE_BANK << 4) | 10
RETURN_COMMANDS = tuple(
    GpuCommand.fill_rect(x=x, y=y, width=w, height=h, token=token)
    for x, y, w, h, token in (
        (6, 0, 12, 2, _FILL), (3, 2, 18, 3, _FILL),
        (1, 5, 22, 14, _FILL), (3, 19, 18, 3, _FILL),
        (6, 22, 12, 2, _FILL),
        (6, 10, 13, 4, _GLYPH), (5, 11, 3, 2, _GLYPH),
        (7, 8, 3, 3, _GLYPH), (9, 6, 3, 3, _GLYPH),
        (7, 13, 3, 3, _GLYPH), (9, 15, 3, 3, _GLYPH),
    )
)
RETURN_EXTRA_CYCLES = len(RETURN_COMMANDS) * 8 + sum(
    (command.words[3] & 0xFFFF) * (command.words[3] >> 16) for command in RETURN_COMMANDS
)


@lru_cache(maxsize=25)
def _ring_commands(steps: int):
    bank = SYSTEM_PALETTE_BANK << 4
    commands = []
    # 24 steps / 2 seconds = one visible update about every 83 ms.
    for index in range(24):
        angle = index * 2 * math.pi / 24
        x = round(12 + 11*math.sin(angle)) - 1
        y = round(12 - 11*math.cos(angle)) - 1
        commands.append(GpuCommand.fill_rect(x=x,y=y,width=2,height=2,
                        token=bank | (7 if index < steps else 4)))
    commands.append(GpuCommand.fill_rect(x=26,y=7,width=11,height=9,token=bank|1))
    for ox, rows in ((28, ('111','001','111','100','111')),
                     (32, ('111','100','111','001','111'))):
        for y, row in enumerate(rows):
            start = row.find('1')
            commands.append(GpuCommand.fill_rect(x=ox+start,y=9+y,
                            width=row.count('1'),height=1,token=bank|10))
    return tuple(commands)


def return_progress_commands(progress: float | None):
    if progress is None:
        return ()
    if not math.isfinite(progress) or not 0 <= progress <= 1:
        raise ValueError('return progress must be between zero and one')
    return _ring_commands(min(24, int(progress*24)))


def _cycles(commands):
    return len(commands)*8 + sum((c.words[3]&0xffff)*(c.words[3]>>16) for c in commands)


def add_return_progress_to_compiled(frame, progress):
    extra = return_progress_commands(progress)
    if not extra:
        return frame
    commands = (*frame.commands[:-1], *extra, frame.commands[-1])
    return replace(frame, commands=commands, header=replace(frame.header,
        command_count=len(commands),predicted_cycles=frame.header.predicted_cycles+_cycles(extra)))


def add_return_to_scene_packet(packet: bytes, progress: float | None = None) -> bytes:
    """Append the button before END_FRAME; keep the fixed scene packet size."""
    if len(packet) != 64 + COMMAND_CAPACITY * 32:
        raise ValueError("scene packet has unexpected size")
    header = list(struct.unpack_from("<16I", packet))
    count = header[4]
    if not 1 <= count <= COMMAND_CAPACITY:
        raise ValueError("scene command bank has no room for return button")
    base = b''.join(c.to_bytes() for c in RETURN_COMMANDS)
    if count > COMMAND_CAPACITY-len(RETURN_COMMANDS) and base not in packet[64:64+(count-1)*32]:
        raise ValueError('scene command bank has no room for return button')
    end_offset = 64 + (count - 1) * 32
    if struct.unpack_from("<I", packet, end_offset)[0] & 0xFF != Opcode.END_FRAME:
        raise ValueError("scene does not end with END_FRAME")
    additions = (*RETURN_COMMANDS, *return_progress_commands(progress))
    tail = b''.join(c.to_bytes() for c in additions)
    if packet[64:end_offset].endswith(tail):
        return packet
    # Replacing a previously decorated packet must not accumulate indicators.
    start = packet.find(base,64,end_offset)
    if start >= 0 and (start-64)%32 == 0:
        removed = [GpuCommand(tuple(struct.unpack_from('<8I',packet,offset)))
                   for offset in range(start,end_offset,32)]
        header[9] -= _cycles(removed)
        count -= (end_offset-start)//32
        end_offset = start
    if count + len(additions) > COMMAND_CAPACITY:
        raise ValueError('scene command bank has no room for return progress')
    header[4] = count + len(additions)
    header[9] = (header[9] + _cycles(additions)) & 0xFFFFFFFF
    commands = packet[64:end_offset] + tail
    commands += GpuCommand.end_frame().to_bytes()
    return struct.pack("<16I", *header) + commands.ljust(COMMAND_CAPACITY * 32, b"\0")


def add_return_to_game_frame(frame, progress: float | None = None):
    packet = add_return_to_scene_packet(frame.scene_packet, progress)
    header = struct.unpack_from('<16I', packet)
    return replace(frame, scene_packet=packet,
                   scene_sha256=hashlib.sha256(packet).hexdigest(),
                   command_count=header[4], predicted_cycles=header[9])


def add_return_to_video_palette(packet: bytes) -> bytes:
    """Populate the video format's reserved system bank without touching its colors."""
    header, payload = unpack_resource_packet(packet)
    if header.packet_type is not PacketType.PALETTE or len(payload) != 256 * 4:
        raise ValueError("expected a full palette packet")
    patched = bytearray(payload)
    for index, (red, green, blue) in enumerate(SYSTEM_COLORS):
        struct.pack_into("<I", patched, (15 * 16 + index) * 4, (red << 16) | (green << 8) | blue)
    return pack_resource_packet(PacketType.PALETTE, bytes(patched),
                                target_id=header.target_id, generation=header.generation,
                                flags=header.flags)
