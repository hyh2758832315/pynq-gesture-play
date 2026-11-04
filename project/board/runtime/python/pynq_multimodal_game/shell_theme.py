"""Shared fixed 16-color HDMI palette and cached official PYNQ wordmark mask."""
from functools import lru_cache
import json
from pathlib import Path

PALETTE = ((0,0,0), (255,244,248), (255,255,255), (252,203,88),
           (82,139,234), (57,159,109), (228,84,101), (232,55,126),
           (128,91,112), (63,39,55), (48,119,109), (247,216,229),
           (214,169,190), (237,229,235), (255,220,167), (155,131,190))


@lru_cache(maxsize=2)
def wordmark(max_height=None):
    value=json.loads((Path(__file__).parent/'data/pynq_wordmark.json').read_text(encoding='utf-8'))
    pixels=bytes.fromhex(value['indices_hex'])
    if len(pixels)!=value['width']*value['height'] or any(p>15 for p in pixels):
        raise ValueError('Invalid PYNQ wordmark mask')
    width,height=value['width'],value['height']
    if max_height is not None and height>max_height:
        new_width=round(width*max_height/height)
        pixels=bytes(pixels[min(height-1,int((y+.5)*height/max_height))*width+
                            min(width-1,int((x+.5)*width/new_width))]
                     for y in range(max_height) for x in range(new_width))
        width,height=new_width,max_height
    return width,height,pixels


def draw_wordmark(pixels,x,y,*,stride=320,max_height=None):
    width,height,mask=wordmark(max_height)
    rows=len(pixels)//stride
    for yy in range(height):
        if 0<=y+yy<rows:
            for xx in range(width):
                value=mask[yy*width+xx]
                if value and 0<=x+xx<stride:
                    pixels[(y+yy)*stride+x+xx]=value
