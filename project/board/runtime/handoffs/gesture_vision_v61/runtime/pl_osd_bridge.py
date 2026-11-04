"""PS results -> existing PL OSD; no overlay download or DMA ownership.

Used by project1_live_ov5640.py --pl-osd on PYNQ-Z2, Vivado 2026.1.
Coordinates refer to the already rotated/mirrored display view.
"""
import math


def metadata_from_result(result, frame_id):
    metadata = dict(enable=1, bbox_valid=0, centroid_valid=0, state=0,
                    x0=0, y0=0, x1=0, y1=0, cx=0, cy=0,
                    result_frame_id=int(frame_id) & 0xffffffff)
    box = result.get('bbox')
    if box is None or result.get('error'):
        return metadata
    if len(box) != 4 or not all(math.isfinite(float(v)) for v in box):
        raise ValueError('Invalid detection box')
    x0, y0, x1, y1 = map(float, box)
    if not (0 <= x0 < x1 <= 640 and 0 <= y0 < y1 <= 360):
        raise ValueError('Box outside display coordinates')
    metadata.update(bbox_valid=1, x0=int(math.floor(2*x0)),
                    y0=int(math.floor(2*y0)), x1=int(math.ceil(2*x1)),
                    y1=int(math.ceil(2*y1)),
                    state={'ROCK':1, 'PAPER':2, 'SCISSORS':3}.get(result.get('rps'),0))
    center = result.get('centroid')
    if center is not None:
        cx, cy = map(float, center)
        if not (math.isfinite(cx) and math.isfinite(cy) and 0 <= cx < 640 and 0 <= cy < 360):
            raise ValueError('Invalid segmented pixel centroid')
        # Nearest full-resolution pixel to the scaled pixel center; half ties upward.
        metadata.update(centroid_valid=1, cx=min(1279,int(math.floor(2*cx+1))),
                        cy=min(719,int(math.floor(2*cy+1))))
    return metadata
