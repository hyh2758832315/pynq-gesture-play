"""Tiny fixed atlas: 12 eight-pixel tiles and a few pixel text labels."""
from pynq_multimodal_game.game_sdk import GameAssets
from pynq_multimodal_game.scene import IndexedImage,PalettePack

PALETTE=((0,0,0),(255,245,249),(34,29,43),(73,54,68),(241,47,129),(129,92,114),
         (255,105,124),(255,218,101),(189,221,196),(66,182,125),(123,246,168),
         (239,202,220),(214,164,190),(66,202,223),(248,251,255),(255,255,255))
FONT={
 'A':'010101111101101','B':'110101110101110','C':'111100100100111',
 'D':'110101101101110','E':'111100110100111','F':'111100110100100',
 'I':'111010010010111','K':'101101110101101','L':'100100100100111',
 'M':'101111111101101','N':'101111111111101','O':'111101101101111',
 'P':'110101110100100','R':'110101110101101','S':'111100111001111',
 'T':'111010010010010','U':'101101101101111','V':'101101101101010',
 'W':'101101111111101','Y':'101101010010010',' ':'000000000000000',
 '0':'111101101101111','1':'010110010010111','2':'111001111100111',
 '3':'111001111001111','4':'101101111001001','5':'111100111001111',
 '6':'111100111101111','7':'111001001001001','8':'111101111101111',
 '9':'111101111001111'}


def create_assets():
    width=256;pixels=bytearray(width*64);labels={};x=y=0
    for label,scale in [('SNAKE DUEL',2),('YOU',1),('BOT',1),
                        ('POINT TO STEER  FIST BOOST',1),('BOOST',1),('READY',2),
                        *[(str(n),2) for n in range(10)]]:
        w=(len(label)*4-1)*scale;h=5*scale
        if x+w>width:x=0;y+=12
        labels[label]=(x,y,w,h)
        for i,c in enumerate(label):
            for j,bit in enumerate(FONT[c]):
                if bit=='1':
                    for yy in range(scale):
                        for xx in range(scale):pixels[(y+j//3*scale+yy)*width+x+i*4*scale+j%3*scale+xx]=14 if label=='READY' else 2
        x+=w+2
    tiles=bytearray(128*8)
    for t in range(12):
        for yy in range(8):
            for xx in range(8):
                color=2
                if t==0:color=3 if xx==0 and yy==0 else 2
                elif t in (1,2):
                    color=(9 if t==1 else 4) if 1<=xx<=6 and 1<=yy<=6 else 2
                    if 2<=xx<=3 and yy==2:color=10 if t==1 else 11
                elif t==3:
                    if 2<=xx<=5 and 2<=yy<=6:color=6
                    if xx==4 and yy==1:color=10
                    if xx==2 and yy==3:color=14
                else:
                    robot=t>=8;direction=(t-8 if robot else t-4)
                    if 1<=xx<=6 and 1<=yy<=6:color=4 if robot else 10
                    eyes=(((5,2),(5,5)),((2,5),(5,5)),((2,2),(2,5)),((2,2),(5,2)))[direction]
                    if (xx,yy) in eyes:color=2
                tiles[yy*128+t*8+xx]=color
    return GameAssets(IndexedImage(width,64,bytes(pixels)),IndexedImage(128,8,bytes(tiles)),
                      PalettePack((PALETTE,))),labels
