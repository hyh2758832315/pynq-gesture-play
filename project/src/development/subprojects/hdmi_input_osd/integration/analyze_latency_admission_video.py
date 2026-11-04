"""Validate complete-frame admission recovery, normal STOP and every DMS1 packet.

Run: .venv/Scripts/python.exe -B subprojects/hdmi_input_osd/integration/analyze_latency_admission_video.py --run build/hosd/c0e-admission-video-r01 --label latency-admission-video-r01
Output: exclusive evidence/<label>.json with waveform, packet and source hashes.
Next: numerical regression, CDC/STA and paired artifact audit before any board test.
No board access. Always-ready completion model does not establish real DDR performance.
"""
import argparse
import hashlib
import importlib.util
import json
from pathlib import Path
import struct
import sys

import numpy as np

from analyze_latency_prewarm import analyze
from board_common import REPO, save


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--run', required=True, type=Path)
    parser.add_argument('--label', required=True)
    args = parser.parse_args()
    run = args.run.resolve()
    assert run.is_relative_to(REPO / 'build/hosd')
    assert args.label.replace('-', '').isalnum()
    receipt = json.loads((run / 'receipt.json').read_text())
    assert receipt['status'] == 'ISOLATED_VIDEO_RATE_TEST_TERMINATED'
    assert 'ADMISSION_RECOVERY' in receipt['verdict']
    assert all(step['returncode'] == 0 for step in receipt['steps'])
    for name, digest in receipt['source_sha256'].items():
        assert sha(run / name) == digest
    waveform = analyze(run / 'first-fault.vcd')
    assert not set(waveform['first_events']) & {'rgb_backpressure', 'overflow', 'owner_fault', 'capture_fault'}
    final = waveform['final_values']
    for field in ('granted', 'released_frames', 'admitted_frames', 'closed_frame_count', 'packet_frames'):
        assert final[field] == 4, (field, final[field])
    for field in ('admitted_pixels', 'closed_pixel_count', 'rgb_taken'):
        assert final[field] == 3686400, (field, final[field])
    for field in ('source_closed', 'pipeline_drained', 'owner_drained', 'barrier_complete', 'epoch_sealed'):
        assert final[field] == 1, (field, final[field])
    for field in ('stalls', 'axis_enable', 'budget_fault', 'boundary_fault'):
        assert final[field] == 0, (field, final[field])

    frozen = REPO / 'build/hosd/c0e/latest-package-restore-r01/board/pynq_z2/dual_mask_packet.py'
    spec = importlib.util.spec_from_file_location('admission_packet_oracle', frozen)
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    rows = (run / 'accepted-packets.hex').read_text().splitlines()
    assert len(rows) == 460864 and all(len(row) == 8 for row in rows)
    packets = []
    baseline = None
    for index in range(4):
        values = [int(row, 16) for row in rows[index*115216:(index+1)*115216]]
        packet = struct.pack('<115216I', *values)
        frame = module.decode_dual_mask(packet, width=640, height=360, frame_id=index+1,
                                       config_id=1, epoch=0x12345678,
                                       thresholds=(0,20,20,255,70,255))
        raw_nonzero = int(np.count_nonzero(frame.raw))
        filtered_nonzero = int(np.count_nonzero(frame.filtered))
        assert 0 < raw_nonzero < frame.raw.size, ('uninformative raw mask', index)
        assert 0 < filtered_nonzero < frame.filtered.size, ('uninformative filtered mask', index)
        if baseline is None:
            baseline = frame
        else:
            assert np.array_equal(frame.raw, baseline.raw), ('raw masks differ', index)
            assert np.array_equal(frame.filtered, baseline.filtered), ('filtered masks differ', index)
        packets.append(dict(frame_id=index+1, bytes=len(packet), crc32=values[-1],
                            raw_nonzero=raw_nonzero, filtered_nonzero=filtered_nonzero,
                            sha256=hashlib.sha256(packet).hexdigest(),
                            raw_sha256=hashlib.sha256(frame.raw.tobytes()).hexdigest(),
                            filtered_sha256=hashlib.sha256(frame.filtered.tobytes()).hexdigest()))
    result = dict(status='ADMISSION_VIDEO_RECOVERY_AND_STOP_PASS', board_access=False,
                  verdict=receipt['verdict'], waveform=waveform, packets=packets,
                  receipt_sha256=sha(run / 'receipt.json'), oracle_sha256=sha(frozen),
                  analyzer_sha256=sha(Path(__file__)), packet_file_sha256=sha(run / 'accepted-packets.hex'),
                  scope='Five physical 720p frames; one full skip; accepted identity1..4 and CRC; identical repeated Bayer input masks; normal STOP budget and owner seal. Actual video IP, modeled always-ready DMA; not board or physical CDC/timing proof.')
    save(args.label, result)
    print(result['status'])


if __name__ == '__main__':
    main()
