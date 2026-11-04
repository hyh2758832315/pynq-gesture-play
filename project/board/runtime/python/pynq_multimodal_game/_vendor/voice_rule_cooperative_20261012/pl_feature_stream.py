#!/usr/bin/env python3
"""Decode and aggregate V1 64-byte PL voice-feature records.

The module contains no PYNQ dependency.  On the board, pass the completed
AXI-DMA receive buffer (uint64 words or bytes) to ``parse_feature_records``.
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import Iterable, List, Sequence

import numpy as np


RECORD_VERSION = 1
WORDS_PER_RECORD = 8
BYTES_PER_RECORD = 64
FRAME_STRIDE_8K = 32
EPS = 1e-12


@dataclass(frozen=True)
class PLFeatureRecord:
    frame_start_8k: int
    phase_id: int
    status: int
    power_q31: int
    zcr_q16: int
    band_80_300_l1: int
    band_300_800_l1: int
    band_800_2000_l1: int
    band_2000_4000_l1: int
    total_l1: int
    weighted_bin_l1: int


def _as_words(payload: object) -> np.ndarray:
    if isinstance(payload, (bytes, bytearray, memoryview)):
        raw = memoryview(payload)
        if len(raw) % 8:
            raise ValueError("DMA payload byte count is not divisible by 8")
        return np.frombuffer(raw, dtype="<u8")
    words = np.asarray(payload)
    if words.dtype.kind not in "ui":
        raise TypeError("DMA payload must contain integer words")
    return words.astype(np.uint64, copy=False).reshape(-1)


def parse_feature_records(payload: object, *, strict_sequence: bool = True) -> List[PLFeatureRecord]:
    """Parse complete V1 records and fail closed on format or PL errors."""
    words = _as_words(payload)
    if words.size == 0 or words.size % WORDS_PER_RECORD:
        raise ValueError("DMA payload must contain a non-zero whole number of 8-word records")

    records: List[PLFeatureRecord] = []
    previous_start = None
    mask48 = (1 << 48) - 1
    mask56 = (1 << 56) - 1
    for offset in range(0, words.size, WORDS_PER_RECORD):
        w = [int(value) for value in words[offset:offset + WORDS_PER_RECORD]]
        frame_start = w[0] & 0xFFFFFFFF
        phase = (w[0] >> 32) & 0x3
        status = (w[0] >> 34) & 0xFF
        version = (w[0] >> 42) & 0xFF
        if version != RECORD_VERSION:
            raise ValueError("unsupported PL feature record version {}".format(version))
        if (w[0] >> 50) or (w[1] >> 48) or any(word >> 48 for word in w[2:7]) or (w[7] >> 56):
            raise ValueError("non-zero reserved bits in PL feature record")
        if status:
            raise ValueError("PL feature status is non-zero: 0x{:02x}".format(status))
        if phase != ((frame_start // FRAME_STRIDE_8K) & 0x3):
            raise ValueError("phase_id does not match frame_start_8k")
        if strict_sequence and previous_start is not None and frame_start != previous_start + FRAME_STRIDE_8K:
            raise ValueError("non-contiguous PL frame sequence: {} after {}".format(frame_start, previous_start))
        previous_start = frame_start
        total = w[6] & mask48
        if total == 0:
            raise ValueError("zero total spectrum magnitude")
        records.append(PLFeatureRecord(
            frame_start_8k=frame_start,
            phase_id=phase,
            status=status,
            power_q31=w[1] & 0xFFFFFFFF,
            zcr_q16=(w[1] >> 32) & 0xFFFF,
            band_80_300_l1=w[2] & mask48,
            band_300_800_l1=w[3] & mask48,
            band_800_2000_l1=w[4] & mask48,
            band_2000_4000_l1=w[5] & mask48,
            total_l1=total,
            weighted_bin_l1=w[7] & mask56,
        ))
    return records


def aggregate_feature_arrays(
    power: Sequence[float], zcr: Sequence[float], bands: np.ndarray,
    total: Sequence[float], weighted_bin: Sequence[float],
    *, sample_rate: int = 8000, frame_size: int = 512,
) -> np.ndarray:
    """Build the frozen 13-element PS feature vector from per-frame values."""
    power = np.asarray(power, dtype=np.float64)
    zcr = np.asarray(zcr, dtype=np.float64)
    bands = np.asarray(bands, dtype=np.float64)
    total = np.asarray(total, dtype=np.float64)
    weighted_bin = np.asarray(weighted_bin, dtype=np.float64)
    count = power.size
    if count == 0 or zcr.shape != (count,) or total.shape != (count,) or weighted_bin.shape != (count,):
        raise ValueError("inconsistent or empty PL feature arrays")
    if bands.shape != (count, 4) or np.any(power < 0) or np.any(total <= 0):
        raise ValueError("invalid PL feature values")

    recording_rms = float(np.sqrt(np.mean(power)) + EPS)
    frame_rms = np.sqrt(power + EPS)
    relative_rms = frame_rms / recording_rms
    active = relative_rms > 0.80
    transitions = int(np.count_nonzero(active[1:] != active[:-1]))
    segments = int(np.count_nonzero(active & np.r_[True, ~active[:-1]]))
    edges = np.flatnonzero(np.diff(np.r_[False, active, False].astype(np.int8)))
    runs = edges[1::2] - edges[::2]
    longest = float(np.max(runs)) / count if runs.size else 0.0
    median_power = float(np.median(power)) + EPS
    peak_to_median = (float(np.max(power)) + EPS) / median_power
    total_sum = float(np.sum(total)) + EPS
    centroid_khz = (
        float(np.sum(weighted_bin)) / total_sum * sample_rate / frame_size / 1000.0
    )
    return np.asarray([
        np.log10(recording_rms),
        np.log10(peak_to_median),
        float(np.mean(active)),
        float(np.std(relative_rms) / (np.mean(relative_rms) + EPS)),
        float(transitions), float(segments), longest, centroid_khz,
        *(float(np.sum(bands[:, index])) / total_sum for index in range(4)),
        float(np.mean(zcr)),
    ], dtype=np.float64)


def aggregate_records(records: Iterable[PLFeatureRecord]) -> np.ndarray:
    """Convert parsed fixed-point PL records to the classifier feature vector."""
    rows = list(records)
    if not rows:
        raise ValueError("no PL feature records")
    # RTL power_q31 is normalized mean-square power in Q0.31.
    power = np.asarray([row.power_q31 for row in rows], dtype=np.float64) / (1 << 31)
    zcr = np.asarray([row.zcr_q16 for row in rows], dtype=np.float64) / (1 << 16)
    bands = np.asarray([
        [row.band_80_300_l1, row.band_300_800_l1,
         row.band_800_2000_l1, row.band_2000_4000_l1]
        for row in rows
    ], dtype=np.float64)
    total = np.asarray([row.total_l1 for row in rows], dtype=np.float64)
    weighted = np.asarray([row.weighted_bin_l1 for row in rows], dtype=np.float64)
    return aggregate_feature_arrays(power, zcr, bands, total, weighted)


def records_to_bytes(records: Iterable[PLFeatureRecord]) -> bytes:
    """Test/debug encoder using the exact V1 little-endian DMA layout."""
    words = []
    for row in records:
        words.extend([
            row.frame_start_8k | (row.phase_id << 32) | (row.status << 34) | (RECORD_VERSION << 42),
            row.power_q31 | (row.zcr_q16 << 32),
            row.band_80_300_l1, row.band_300_800_l1,
            row.band_800_2000_l1, row.band_2000_4000_l1,
            row.total_l1, row.weighted_bin_l1,
        ])
    return np.asarray(words, dtype="<u8").tobytes()
