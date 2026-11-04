"""Cached pixel artwork for the HDMI shell; no animation or worker ownership."""
from functools import lru_cache
from dataclasses import replace
from .creative_pages import rect, text, stamp, header_title
from .shell_theme import draw_brand_lockup, brand_lockup, draw_header_brand
from .gpu_abi import GpuCommand


def highlight_frame(frame, target):
    """Hover is four small GPU rectangles; the page atlas remains unchanged."""
    if target is None or target.item_id == 'back':
        return frame
    w,h=target.hit_width or 64,target.hit_height or 34
    x,y=target.center_x-w//2,target.center_y-h//2
    bars=tuple(GpuCommand.fill_rect(x=xx,y=yy,width=ww,height=hh,token=7)
               for xx,yy,ww,hh in ((x+3,y,w-6,2),(x+3,y+h-2,w-6,2),
                                   (x,y+3,2,h-6),(x+w-2,y+3,2,h-6)))
    commands=(*frame.commands[:-1],*bars,frame.commands[-1])
    cycles=sum(8+(b.words[3]&0xffff)*(b.words[3]>>16) for b in bars)
    return replace(frame,commands=commands,header=replace(frame.header,
        command_count=len(commands),predicted_cycles=frame.header.predicted_cycles+cycles))


def panel(p,x,y,w,h,color):
    rect(p,x+3,y,w-6,h,color)
    rect(p,x,y+3,w,h-6,color)


def border(p,x,y,w,h,color,thickness=1):
    rect(p,x+3,y,w-6,thickness,color)
    rect(p,x+3,y+h-thickness,w-6,thickness,color)
    rect(p,x,y+3,thickness,h-6,color)
    rect(p,x+w-thickness,y+3,thickness,h-6,color)


def glyph(p,kind,x,y):
    if kind=='games':
        panel(p,x,y+4,27,18,9)
        rect(p,x+5,y+9,3,8,2);rect(p,x+2,y+12,9,2,2)
        rect(p,x+18,y+9,3,3,7);rect(p,x+22,y+13,3,3,7)
    elif kind=='videos':
        panel(p,x,y+2,27,22,9);rect(p,x+2,y+5,23,16,11)
        for i in range(9):rect(p,x+10+i,y+8+i//2,1,11-i,7)
    elif kind=='hand':
        for i,h in enumerate((13,18,17,13)):
            rect(p,x+5+i*5,y+19-h,3,h,9)
        panel(p,x+3,y+15,22,11,9);rect(p,x,y+13,4,9,7)
        rect(p,x+9,y+18,10,3,11)
    else:
        panel(p,x,y,27,27,2);border(p,x,y,27,27,12)
        stamp(p,'triangle',12,x+9,y+10,3)
        stamp(p,'circle',11,x+19,y+18,5)
        stamp(p,'square',8,x+8,y+20,4)


def action_icon(p,action,cx,cy):
    """Three established actions, readable without sentence-length labels."""
    if action=='resume':
        for dx in range(22):
            rect(p,cx-8+dx,cy-12+dx//2,1,25-dx,9)
    elif action=='restart':
        for y in range(-13,14):
            for x in range(-13,14):
                if 81<=x*x+y*y<=169 and not (x<0 and y<-5):
                    rect(p,cx+x,cy+y,1,1,9)
        # Arrowhead turns towards the beginning of the circular path.
        for dy in range(10):rect(p,cx-13,cy-15+dy,dy+1,1,7)
    else:
        for dy in range(14):rect(p,cx-dy,cy-14+dy,dy*2+1,2,9)
        rect(p,cx-10,cy-1,21,14,9)
        rect(p,cx-3,cy+4,7,9,2)
        rect(p,cx+5,cy-10,4,7,7)


def game_thumbnail(p,item_id,x,y):
    """Small cached pixel scenes, painted once into the menu atlas."""
    panel(p,x,y,122,25,11)
    if item_id=='game:game1':
        rect(p,x,y+21,122,4,9)
        for xx,yy in ((18,16),(54,10),(93,18)):rect(p,x+xx,y+yy,20,3,5)
        rect(p,x+27,y+7,6,7,7);rect(p,x+25,y+14,10,7,4)
        rect(p,x+86,y+12,9,8,10);rect(p,x+88,y+14,2,2,2)
    elif item_id=='game:game2':
        glyph(p,'hand',x+17,y-1)
        text(p,'VS',x+56,y+8,color=4,scale=2)
        rect(p,x+89,y+7,16,14,9);rect(p,x+92,y+9,3,3,7)
        rect(p,x+99,y+9,3,3,7);rect(p,x+94,y+17,8,2,2)
    elif item_id=='game:game3':
        rect(p,x,y+21,122,4,9);rect(p,x+40,y+15,18,3,5)
        rect(p,x+72,y+9,23,3,5);rect(p,x+17,y+9,6,6,7)
        rect(p,x+15,y+15,10,6,4)
        for i in range(4):rect(p,x+57+i*7,y+4+(i%2)*3,3,3,7)
        rect(p,x+106,y+4,2,17,9);rect(p,x+108,y+4,9,6,4)
    else:
        for xx,yy in ((14,10),(22,10),(30,10),(30,18),(38,18)):
            rect(p,x+xx,y+yy,7,6,10)
        for xx,yy in ((100,7),(92,7),(84,7),(84,15),(76,15)):
            rect(p,x+xx,y+yy,7,6,7)
        rect(p,x+16,y+11,2,2,2);rect(p,x+102,y+8,2,2,2)
        stamp(p,'circle',5,x+59,y+12,6)


@lru_cache(maxsize=24)
def _base(page,targets,labels):
    p=bytearray([1])*57600
    header_height=48
    rect(p,0,0,320,header_height,11)
    rect(p,0,header_height,320,1,12)
    draw_header_brand(p)
    if page=='home':
        subtitles=('FOUR ADVENTURES','YOUR VIDEO LIBRARY','GESTURE SHOW','SHAPE YOUR IDEAS')
        for index,target in enumerate(targets[1:]):
            x,y=target.center_x-66,target.center_y-23
            panel(p,x,y+2,132,46,12);panel(p,x,y,132,45,2)
            glyph(p,target.item_id,x+10,y+8)
            text(p,labels[index],x+45,y+10,color=9,scale=2)
            text(p,subtitles[index],x+45,y+28,color=8)
    else:
        title={'games':'GAMES','videos':'VIDEOS','hand-placeholder':'HAND STATUS'}.get(page,'EXPLORE')
        header_title(p,title)
        if len(targets)==1:
            text(p,'NO VIDEOS YET',84,84,color=9,scale=3)
            text(p,'ADD VIDEOS IN STUDIO',122-39,111,color=8,scale=2)
        for index,target in enumerate(targets[1:]):
            w,h=target.hit_width or 64,target.hit_height or 34
            x,y=target.center_x-w//2,target.center_y-h//2
            panel(p,x,y+2,w,h,12);panel(p,x,y,w,h,2 if target.enabled else 13)
            label=labels[index] if index<len(labels) else ''
            color=9 if target.enabled else 8
            if page=='games':
                game_thumbnail(p,target.item_id,x+9,y+5)
                caption=label.upper()[:16]
                text(p,caption,x+(w-(len(caption)*4-1))//2,y+36,color=color)
            elif target.item_id.startswith('video-page:'):
                text(p,label,x+(w-(len(label)*8-2))//2,y+7,color=color,scale=2)
            else:
                panel(p,x+6,y+5,24,h-10,11)
                text(p,str(index+1).zfill(2),x+11,target.center_y-5,color=7,scale=2)
                text(p,label.upper()[:24],x+39,target.center_y-6,color=color,scale=2)
                if target.enabled:
                    for dy in range(-3,4):rect(p,x+w-14-abs(dy),target.center_y+dy,2,1,7)
    return bytes(p)


def render_shell_page(page,targets,labels,selected=None,*,armed=True,status=None):
    p=bytearray(_base(page,tuple(targets),tuple(labels)))
    target=next((t for t in targets if t.item_id==selected and t.item_id!='back'),None)
    if target:
        w,h=target.hit_width or 64,target.hit_height or 34
        x,y=target.center_x-w//2,target.center_y-h//2
        border(p,x,y,w,h,7,2)
        rect(p,x+2,y+7,3,h-14,7)
    hint='POINT THEN FIST' if armed else 'OPEN HAND THEN FIST'
    text(p,hint,(320-(len(hint)*4-1))//2,173,color=8)
    if status and page=='hand-placeholder':text(p,status[:25],80,39,color=10)
    return bytes(p)


@lru_cache(maxsize=24)
def content_loading(title,kind='game',progress=None):
    p=bytearray([1])*57600
    rect(p,0,0,320,7,11);rect(p,0,173,320,7,11)
    width,_,_=brand_lockup()
    draw_brand_lockup(p,(320-width)//2,15)
    text(p,'LOADING',105,79,color=9,scale=4)
    panel(p,60,112,200,10,12);rect(p,62,114,196,6,2);rect(p,62,114,78 if progress is None else round(196*max(0,min(1,progress))),6,7)
    caption=('STARTING ' if kind=='game' else 'OPENING ')+title.upper()[:25]
    text(p,caption,(320-(len(caption)*4-1))//2,137,color=8)
    return bytes(p)


def preview_pause_commands():
    """One static scene using system colors; leave every resource bank intact."""
    from .menu import _MENU_GLYPHS
    commands=[GpuCommand.clear(241)]
    for x in (147,165):
        commands.append(GpuCommand.fill_rect(x=x,y=48,width=9,height=28,token=245))
    for i,char in enumerate('PAUSED'):
        for y,row in enumerate(_MENU_GLYPHS[char]):
            x=0
            while x<len(row):
                if row[x]!='1':x+=1;continue
                end=x+1
                while end<len(row) and row[end]=='1':end+=1
                commands.append(GpuCommand.fill_rect(x=114+(4*i+x)*4,y=99+y*4,
                    width=(end-x)*4,height=4,token=250))
                x=end
    return (*commands,GpuCommand.end_frame())


@lru_cache(maxsize=50)
def home_options(target,steps):
    p=bytearray([1])*57600
    rect(p,0,0,320,48,11);text(p,'MENU',137,20,color=9,scale=3)
    for name,x,label in (('continue',45,'PLAY'),('restart',175,'RESTART')):
        panel(p,x,67,100,63,12);panel(p,x,65,100,63,2)
        border(p,x,65,100,63,7 if target==name else 12,2)
        action_icon(p,'resume' if name=='continue' else 'restart',x+50,91)
        text(p,label,x+50-(len(label)*4-1)//2,116,color=8)
        if target==name:rect(p,x+2,124,round(96*steps/24),3,10)
    text(p,'HOLD AN OPTION FOR 2 SEC',68,151,color=8)
    return bytes(p)


@lru_cache(maxsize=12)
def pause_page(outcome,targets,hovered,score=0):
    p=bytearray([1])*57600
    rect(p,0,0,320,48,11 if outcome is None else 9)
    title={None:'PAUSED','WON':'YOU WIN','LOST':'GAME OVER','DRAW':'DRAW'}[outcome]
    scale=3 if outcome is None else 5
    color=9 if outcome is None else {'WON':3,'LOST':6,'DRAW':4}[outcome]
    text(p,title,(320-(len(title)*4-1)*scale)//2,20 if outcome is None else 13,color=color,scale=scale)
    if outcome is not None:
        rect(p,0,0,320,3,color)
        label='SCORE '+str(min(999999,score))
        text(p,label,(320-(len(label)*4-1)*2)//2,52,color=9,scale=2)
    labels={'resume':'PLAY','restart':'RETRY','main-menu':'MENU'}
    for t in targets[1:]:
        x,y=t.center_x-40,t.center_y-27
        panel(p,x,y+2,80,54,12);panel(p,x,y,80,54,2)
        border(p,x,y,80,54,7 if hovered==t.item_id else 12,2 if hovered==t.item_id else 1)
        label=labels[t.item_id]
        action_icon(p,t.item_id,t.center_x,t.center_y-5)
        text(p,label,t.center_x-(len(label)*4-1)//2,t.center_y+17,color=8)
    text(p,'HOLD AN OPTION FOR 2 SEC',115-47,153,color=8)
    return bytes(p)
