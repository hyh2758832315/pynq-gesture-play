from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path
import struct
import time
from typing import Any, Callable

from ..gpu_abi import (
    ASSET_BUNDLE_CAPACITY_BYTES, ASSET_BUNDLE_SLOT_COUNT, PACKET_HEADER_BYTES,
    PacketType, unpack_resource_packet,
)
from .c6i_backend import (
    BUILD_ID_IP, C6IOverlaySession, GPIO2_DATA_OFFSET, GPIO_DATA_OFFSET,
    OVERLAP_CONTROL_IP, OVERLAP_CREDIT, OVERLAP_COMPLETION_HOLD,
    OVERLAP_PRESENT_DONE, OVERLAP_RELEASE_CONSUMED, OVERLAP_RESOURCE_IDLE,
    OVERLAP_GENERATION_REJECT, UPLOAD_RENDER_OVERLAP_BUILD_ID,
)


SCENE_DMA_IP = "axi_dma"
PACKET_STATUS_IP = "packet_status_gpio"
RENDER_COMPLETION_IP = "render_completion_gpio"
RENDER_CYCLES_IP = "render_cycles_gpio"
RENDER_STATUS_IP = "render_status_gpio"
PRESENT_COMPLETION_IP = "present_completion_gpio"
PALETTE_PACKET_STATUS_IP = "palette_packet_status_gpio"
PALETTE_GENERATION_STATUS_IP = "palette_generation_status_gpio"
ASSET_PACKET_STATUS_IP = "asset_packet_status_gpio"
ASSET_GENERATION_STATUS_IP = "asset_generation_status_gpio"
TILEMAP_PACKET_STATUS_IP = "tilemap_packet_status_gpio"
TILEMAP_GENERATION_STATUS_IP = "tilemap_generation_status_gpio"
SCENE_PACKET_BYTES = 64 + 4096
MAX_PACKET_BYTES = PACKET_HEADER_BYTES + ASSET_BUNDLE_SLOT_COUNT * 16 + ASSET_BUNDLE_CAPACITY_BYTES


@dataclass(eq=False)
class C6ISceneTicket:
    sequence: int
    accepted_count: int
    render_count: int
    present_count: int
    _owner: Any = field(repr=False)
    completed: bool = field(default=False, init=False)


class C6IVideoSink:
    def __init__(
        self,
        bitstream: Path | None = None,
        *,
        timeout_seconds: float,
        expected_build_id: int = 0xC0060700,
        overlay_factory: Callable[..., Any] | None = None,
        mmio_factory: Callable[..., Any] | None = None,
        allocate: Callable[..., Any] | None = None,
        session: C6IOverlaySession | None = None,
        upload_render_overlap: bool = False,
    ) -> None:
        import numpy as np

        if timeout_seconds <= 0:
            raise ValueError("timeout_seconds must be positive")
        if session is None and bitstream is None:
            raise ValueError("bitstream is required without a shared C6I session")
        if session is not None and bitstream is not None:
            raise ValueError("provide either bitstream or session, not both")
        self._session = session or C6IOverlaySession(
            Path(bitstream),
            expected_build_id=expected_build_id,
            overlay_factory=overlay_factory,
            mmio_factory=mmio_factory,
            allocate=allocate,
            require_root=False,
        )
        self._owns_session = session is None
        self._np = np
        self._timeout_seconds = timeout_seconds
        self._tickets: list[C6ISceneTicket] = []
        self._poison: BaseException | None = None
        self._dma_inflight = False
        self._closed = False
        self._overlap_mmio: Any | None = None
        self._overlap_enabled = upload_render_overlap
        self._session.open()
        try:
            capability = getattr(self._session, "supports_upload_render_overlap", None)
            supported = capability is not None and capability()
            actual_build = int(self._session.mmio(BUILD_ID_IP).read(GPIO_DATA_OFFSET))
            supported = supported and actual_build == UPLOAD_RENDER_OVERLAP_BUILD_ID
            if not supported and (upload_render_overlap or actual_build == UPLOAD_RENDER_OVERLAP_BUILD_ID):
                raise RuntimeError("P4 overlap requires matching BUILD_ID, HWH GPIO and enabled manifest")
            if supported:
                self._overlap_mmio = self._session.mmio(OVERLAP_CONTROL_IP)
                self._release_toggle = (
                    int(self._overlap_mmio.read(GPIO2_DATA_OFFSET))
                    & OVERLAP_RELEASE_CONSUMED
                ) >> 5
            self._packet_mmio = self._session.mmio(PACKET_STATUS_IP)
            self._completion_mmio = self._session.mmio(RENDER_COMPLETION_IP)
            self._cycles_mmio = self._session.mmio(RENDER_CYCLES_IP)
            self._render_status_mmio = self._session.mmio(RENDER_STATUS_IP)
            self._present_mmio = self._session.mmio(PRESENT_COMPLETION_IP)
            self._accepted_count = int(self._packet_mmio.read(GPIO2_DATA_OFFSET))
            self._render_count = int(self._completion_mmio.read(GPIO2_DATA_OFFSET))
            self._present_count = int(self._present_mmio.read(GPIO2_DATA_OFFSET))
            self._scene_rejected = (
                int(self._packet_mmio.read(GPIO_DATA_OFFSET)) - self._accepted_count
            ) & 0xFFFFFFFF
            self._resource_status = {
                PacketType.PALETTE: (
                    self._session.mmio(PALETTE_PACKET_STATUS_IP),
                    self._session.mmio(PALETTE_GENERATION_STATUS_IP),
                ),
                PacketType.ASSET: (
                    self._session.mmio(ASSET_PACKET_STATUS_IP),
                    self._session.mmio(ASSET_GENERATION_STATUS_IP),
                ),
                PacketType.TILEMAP: (
                    self._session.mmio(TILEMAP_PACKET_STATUS_IP),
                    self._session.mmio(TILEMAP_GENERATION_STATUS_IP),
                ),
            }
            overlay = self._session._overlay
            assert overlay is not None
            self._dma = getattr(overlay, SCENE_DMA_IP)
            self._buffer = self._session.allocate(
                shape=(MAX_PACKET_BYTES,), dtype=np.uint8
            )
        except BaseException:
            if self._owns_session:
                self._session.close()
            raise
        self._maximum_render_cycles = 0

    @property
    def maximum_render_cycles(self) -> int:
        return self._maximum_render_cycles

    @property
    def upload_render_overlap_enabled(self) -> bool:
        return bool(self._overlap_enabled and self._overlap_mmio is not None)

    def upload_tilemap(self, packet: bytes) -> None:
        self._upload_resource(packet, PacketType.TILEMAP)

    def upload_palette(self, packet: bytes) -> None:
        self._upload_resource(packet, PacketType.PALETTE)

    def upload_asset(self, packet: bytes) -> None:
        self._upload_resource(packet, PacketType.ASSET)

    def submit_scene(self, packet: bytes) -> None:
        self.wait_scene(self.enqueue_scene(packet))

    def enqueue_scene(self, packet: bytes) -> C6ISceneTicket:
        self._ensure_usable()
        if len(packet) != SCENE_PACKET_BYTES:
            raise ValueError("S2V1 scene packet length mismatch")
        submit_seq = struct.unpack_from("<I", packet, 12)[0]
        try:
            if len(self._tickets) >= (2 if self._overlap_enabled else 1):
                self.wait_scene(self._tickets[0])
            if self._overlap_mmio is not None:
                self._wait_overlap(OVERLAP_CREDIT, OVERLAP_CREDIT, "upload credit")
            ticket = C6ISceneTicket(
                submit_seq,
                (self._accepted_count + 1) & 0xFFFFFFFF,
                (self._render_count + 1) & 0xFFFFFFFF,
                (self._present_count + 1) & 0xFFFFFFFF,
                self,
            )
            self._transfer(packet)
            self._wait_for_value(
                self._packet_mmio, GPIO_DATA_OFFSET,
                (ticket.accepted_count + self._scene_rejected) & 0xFFFFFFFF, "scene packet count",
            )
            self._check_scene_rejected()
            self._accepted_count = ticket.accepted_count
            self._render_count = ticket.render_count
            self._present_count = ticket.present_count
            self._tickets.append(ticket)
            if not self._overlap_enabled:
                self.wait_scene(ticket)
            return ticket
        except BaseException as error:
            self._poison = error
            raise

    def wait_scene(self, ticket: C6ISceneTicket) -> None:
        if not isinstance(ticket, C6ISceneTicket) or ticket._owner is not self:
            raise ValueError("scene ticket belongs to another sink")
        if ticket.completed:
            return
        self._ensure_usable()
        if not any(pending is ticket for pending in self._tickets):
            raise ValueError("unknown scene ticket")
        try:
            while self._tickets:
                oldest = self._tickets[0]
                self._retire_scene(oldest)
                self._tickets.pop(0)
                if oldest is ticket:
                    return
        except BaseException as error:
            self._poison = error
            raise

    def drain(self) -> None:
        self._ensure_usable()
        while self._tickets:
            self.wait_scene(self._tickets[0])

    def _retire_scene(self, ticket: C6ISceneTicket) -> None:
        self._wait_for_value(self._completion_mmio, GPIO2_DATA_OFFSET, ticket.render_count, "render completed count")
        self._wait_for_value(self._completion_mmio, GPIO_DATA_OFFSET, ticket.sequence, "render completed sequence")
        self._wait_for_value(self._present_mmio, GPIO2_DATA_OFFSET, ticket.present_count, "present completed count")
        self._wait_for_value(self._present_mmio, GPIO_DATA_OFFSET, ticket.sequence, "present completed sequence")
        if self._overlap_mmio is not None:
            self._wait_overlap(
                OVERLAP_COMPLETION_HOLD | OVERLAP_PRESENT_DONE,
                OVERLAP_COMPLETION_HOLD | OVERLAP_PRESENT_DONE,
                "completion hold/present",
            )
        self._check_scene_rejected()
        status = int(self._render_status_mmio.read(GPIO_DATA_OFFSET))
        if status != 0:
            raise RuntimeError(f"renderer status mismatch: 0x{status:08X}")
        cycles = int(self._cycles_mmio.read(GPIO_DATA_OFFSET))
        if self._overlap_mmio is not None:
            self._release_toggle ^= 1
            self._overlap_mmio.write(GPIO_DATA_OFFSET, self._release_toggle)
            self._wait_overlap(
                OVERLAP_RELEASE_CONSUMED,
                OVERLAP_RELEASE_CONSUMED if self._release_toggle else 0,
                "release acknowledgement",
            )
        self._maximum_render_cycles = max(self._maximum_render_cycles, cycles)
        ticket.completed = True

    def _ensure_usable(self) -> None:
        if self._closed:
            raise RuntimeError("video sink is closed")
        if self._poison is not None:
            raise RuntimeError(
                f"video sink is poisoned: {type(self._poison).__name__}: {self._poison}"
            ) from self._poison

    def _check_scene_rejected(self) -> None:
        uploaded = int(self._packet_mmio.read(GPIO_DATA_OFFSET))
        accepted = int(self._packet_mmio.read(GPIO2_DATA_OFFSET))
        if (uploaded - accepted) & 0xFFFFFFFF != self._scene_rejected:
            raise RuntimeError("scene packet rejected")

    def _wait_overlap(self, mask: int, expected: int, label: str) -> None:
        deadline = time.perf_counter() + self._timeout_seconds
        while True:
            status = int(self._overlap_mmio.read(GPIO2_DATA_OFFSET))
            if status & OVERLAP_GENERATION_REJECT:
                raise RuntimeError("scene generation rejected (sticky)")
            if status >> 8:
                raise RuntimeError(f"reserved overlap status bits set: 0x{status:08X}")
            if status & mask == expected:
                return
            if time.perf_counter() >= deadline:
                raise TimeoutError(f"{label} timeout: status=0x{status:08X}")
            time.sleep(.0001)

    def close(self) -> None:
        if self._closed:
            return
        failure: BaseException | None = self._poison
        if failure is None:
            try:
                self.drain()
            except BaseException as error:
                failure = error
        channel = self._dma.sendchannel
        if self._dma_inflight or channel.running:
            try:
                channel.stop()
                halted = int(channel._mmio.read(channel._offset + 4)) & 1
                if channel.running or not halted:
                    raise RuntimeError("MM2S DMA halt could not be verified")
                self._dma_inflight = False
            except BaseException as error:
                raise RuntimeError("cannot safely stop MM2S DMA; buffer retained, session left open") from error
        buffer = getattr(self, "_buffer", None)
        if buffer is not None:
            buffer.freebuffer()
            self._buffer = None
        self._closed = True
        if self._owns_session:
            self._session.close()
        if failure is not None:
            raise RuntimeError("video sink closed after failure") from failure

    def _upload_resource(self, packet: bytes, expected_type: PacketType) -> None:
        self._ensure_usable()
        header, _ = unpack_resource_packet(packet)
        if header.packet_type is not expected_type:
            raise ValueError(
                f"expected {expected_type.name} packet, got {header.packet_type.name}"
            )
        try:
            self.drain()
            if self._overlap_mmio is not None:
                self._wait_overlap(OVERLAP_RESOURCE_IDLE, OVERLAP_RESOURCE_IDLE, "resource idle")
            self._transfer_resource(packet, expected_type, header.generation)
        except BaseException as error:
            self._poison = error
            raise

    def _transfer_resource(self, packet: bytes, expected_type: PacketType, generation: int) -> None:
        packet_mmio, generation_mmio = self._resource_status[expected_type]
        expected_count = (
            int(packet_mmio.read(GPIO_DATA_OFFSET)) + 1
        ) & 0xFFFFFFFF
        rejected_before = int(packet_mmio.read(GPIO2_DATA_OFFSET))
        self._transfer(packet)
        self._wait_for_value(
            packet_mmio,
            GPIO_DATA_OFFSET,
            expected_count,
            f"{expected_type.name.lower()} accepted count",
        )
        self._wait_for_value(
            generation_mmio,
            GPIO_DATA_OFFSET,
            generation,
            f"{expected_type.name.lower()} generation",
        )
        rejected_after = int(packet_mmio.read(GPIO2_DATA_OFFSET))
        if rejected_after != rejected_before:
            raise RuntimeError(
                f"{expected_type.name.lower()} packet rejected: "
                f"{rejected_before}->{rejected_after}"
            )

    def _transfer(self, payload: bytes) -> None:
        buffer = getattr(self, "_buffer", None)
        if buffer is None:
            raise RuntimeError("video sink is closed")
        if len(payload) > len(buffer):
            raise ValueError("S2V1 packet exceeds the DMA buffer")
        buffer[: len(payload)] = self._np.frombuffer(payload, dtype=self._np.uint8)
        buffer.flush()
        self._dma_inflight = True
        self._dma.sendchannel.transfer(buffer, nbytes=len(payload))
        deadline = time.perf_counter() + self._timeout_seconds
        while True:
            if self._dma.sendchannel.error:
                status = self._dma.sendchannel._mmio.read(
                    self._dma.sendchannel._offset + 4
                )
                raise RuntimeError(f"MM2S DMA error: status=0x{status:08X}")
            if self._dma.sendchannel.idle:
                break
            if time.perf_counter() >= deadline:
                raise TimeoutError("MM2S DMA timeout")
            time.sleep(.0001)
        self._dma.sendchannel.wait()
        self._dma_inflight = False

    def _wait_for_value(
        self, mmio: Any, offset: int, expected: int, label: str
    ) -> None:
        deadline = time.perf_counter() + self._timeout_seconds
        while True:
            if self._overlap_mmio is not None:
                self._wait_overlap(0, 0, "overlap health")
            actual = int(mmio.read(offset))
            if actual == expected:
                return
            if time.perf_counter() >= deadline:
                raise TimeoutError(
                    f"{label} timeout: expected {expected}, got {actual}"
                )
            time.sleep(.0001)
