"""Decode exact 192-bit core snapshot; no board/register access.

Record little endian: area u32, sum_x u64, sum_y u64, frame_id u32.
Never call whole-scene skin moments a selected-hand centroid.
"""
import struct


def decode_snapshot(data, width, height, expected_frame_id=None, error=False):
    if error:
        raise ValueError('Malformed frame/config: reject hardware snapshot')
    if len(data)!=24 or not (1<=width<=1280 and 1<=height<=720):
        raise ValueError('Invalid snapshot or dimensions')
    area,sx,sy,fid=struct.unpack('<IQQI',data)
    if expected_frame_id is not None and fid != expected_frame_id:
        raise ValueError('Snapshot does not belong to the requested frame')
    if area>width*height or sx>area*(width-1) or sy>area*(height-1):
        raise ValueError('Moments outside frame bounds')
    return dict(frame_id=fid,area=area,sum_x=sx,sum_y=sy,
                centroid=(sx/area,sy/area) if area else None)
