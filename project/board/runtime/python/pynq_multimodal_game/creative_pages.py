"""Bounded canvas and pixel robot pages; no device, thread or input queue."""
from functools import lru_cache
from dataclasses import replace
import math

from .controls import StaleFlag
from .menu import _MENU_GLYPHS,MenuInputController,MenuTarget,MenuIcon
from .return_button import (ReturnDwell, return_contains, add_return_progress_to_compiled,
                            RETURN_COMMANDS, RETURN_EXTRA_CYCLES,return_progress_commands)
from .scene import IndexedImage, PalettePack, Scene, SpriteDescriptor
from .scene_compiler import SceneCompiler
from .gpu_abi import (pack_assets,pack_resource_packet,PacketType,ASSET_BUNDLE_CAPACITY_BYTES,
                      GpuCommand,COMMAND_CAPACITY)
from .shell_theme import PALETTE, draw_header_brand

WIDTH, HEIGHT, CANVAS_WIDTH = 320, 180, 256
SIZES = (8, 12, 16, 22, 30, 40)
SHAPES = ('triangle', 'square', 'circle', 'star')
SHAPE_CENTERS = (39, 71, 103, 135)
COLORS = (3, 4, 5, 6)
DIALOG_TARGETS = (('continue',10),('save',86),('clear',162),('home',238))


def album_contains(control):
    x=round((control.hand_x+1)*319/2);y=round((control.hand_y+1)*179/2)
    return (x-12)**2+(y-168)**2<=12**2


def _move_command(command,dy):
    x=command.words[2]&65535;y=command.words[2]>>16
    return GpuCommand.fill_rect(x=x,y=y+dy,width=command.words[3]&65535,
                               height=command.words[3]>>16,token=command.words[1]&255)


# Same 24-pixel round control and ring as the universal top-left return.
ALBUM_COMMANDS=tuple(_move_command(c,156) for c in RETURN_COMMANDS[:5])+tuple(
    GpuCommand.fill_rect(x=x,y=y,width=w,height=h,token=token)
    for x,y,w,h,token in ((5,161,15,13,250),(7,163,11,9,245),
                         (9,164,3,3,250),(8,170,9,2,250),(12,168,4,3,250)))


def add_album_control(frame,progress=None):
    commands=(*frame.commands[:-1],*ALBUM_COMMANDS,
              *(_move_command(c,156) for c in return_progress_commands(progress)),frame.commands[-1])
    if len(commands)>COMMAND_CAPACITY:raise ValueError('Canvas controls exceed command capacity')
    return replace(frame,commands=commands,header=replace(frame.header,
        command_count=len(commands),predicted_cycles=SceneCompiler._predict_cycles(commands)))


def rect(pixels, x, y, w, h, color, *, stride=WIDTH, height=HEIGHT):
    x0, x1 = max(0,x), min(stride,x+w)
    if x1 <= x0:
        return
    row = bytes([color]) * (x1-x0)
    for yy in range(max(0,y), min(height,y+h)):
        pixels[yy*stride+x0:yy*stride+x1] = row


def text(pixels, value, x, y, *, color=9, scale=1):
    for i, char in enumerate(value.upper()):
        for yy, row in enumerate(_MENU_GLYPHS.get(char, _MENU_GLYPHS[' '])):
            for xx, dot in enumerate(row):
                if dot == '1':
                    rect(pixels, x+(4*i+xx)*scale, y+yy*scale, scale, scale, color)


def header_title(pixels,value,*,height=48,subtitle=None):
    """Readable page names centered in the space between the two wordmarks."""
    center=160 if height<48 else 165
    lines=value.split() if len(value)*4*3-3>70 and ' ' in value else [value]
    scale=min(3,70//max(len(line)*4-1 for line in lines))
    block_height=len(lines)*5*scale+(len(lines)-1)*3
    available_height=height-(8 if subtitle else 0)
    y=(available_height-block_height)//2
    for line in lines:
        width=(len(line)*4-1)*scale
        text(pixels,line,center-width//2,y,color=9,scale=scale)
        y+=5*scale+3
    if subtitle:
        text(pixels,subtitle,center-(len(subtitle)*4-1)//2,height-8,color=7)


def polygon(points, x, y):
    inside = False
    for (ax,ay), (bx,by) in zip(points, points[1:]+points[:1]):
        if (ay>y) != (by>y) and x < (bx-ax)*(y-ay)/(by-ay)+ax:
            inside = not inside
    return inside


@lru_cache(maxsize=24)
def mask(shape, size):
    r = size/2
    star = tuple((r+(r if i%2 == 0 else r*.43)*math.sin(i*math.pi/5),
                  r-(r if i%2 == 0 else r*.43)*math.cos(i*math.pi/5)) for i in range(10))
    return tuple((x,y) for y in range(size) for x in range(size)
                 if (shape == 'square'
                     or shape == 'circle' and (x+.5-r)**2+(y+.5-r)**2 <= r*r
                     or shape == 'triangle' and abs(x+.5-r) <= (y+.5)/2
                     or shape == 'star' and polygon(star,x+.5,y+.5)))


@lru_cache(maxsize=24)
def mask_runs(shape, size):
    """Exact horizontal runs, shared by saved strokes and GPU preview commands."""
    runs=[]
    for x,y in mask(shape,size):
        if runs and runs[-1][1]==y and runs[-1][0]+runs[-1][2]==x:
            sx,sy,w=runs[-1];runs[-1]=(sx,sy,w+1)
        else:
            runs.append((x,y,1))
    return tuple(runs)


def stamp(pixels, shape, size, x, y, color, *, stride=WIDTH, height=HEIGHT):
    changed=False
    for dx,dy,w in mask_runs(shape,size):
        xx,yy=x+dx-size//2,y+dy-size//2
        lo,hi=max(0,xx),min(stride,xx+w)
        if lo<hi and 0<=yy<height:
            start,end=yy*stride+lo,yy*stride+hi
            row=bytes([color])*(hi-lo)
            if pixels[start:end]!=row:
                pixels[start:end]=row
                changed=True
    return changed


class CanvasPage:
    """Fixed 46 KiB raster; stamps are merged, never accumulated as objects."""
    def __init__(self):
        self.pixels = bytearray([2]) * (CANVAS_WIDTH*HEIGHT)
        self.shape = None
        self.size_index = 2
        self.pointer = None
        self.revision = 0
        self.dialog = False
        self.back = ReturnDwell()
        self.album_dwell = ReturnDwell()
        self.saved = False
        self.dialog_dwell = ReturnDwell()
        self.dialog_target = None
        self.wait_exit = True
        self._last_time = -1
        self._frame = None
        self._last_brush = None
        self._choices=MenuInputController()
        self._choice_targets=tuple(MenuTarget(shape,MenuIcon.RESERVED,288,cy,
            hit_width=64,hit_height=28) for shape,cy in zip(SHAPES,SHAPE_CENTERS))+(
            MenuTarget('smaller',MenuIcon.RESERVED,272,167,hit_width=32,hit_height=24),
            MenuTarget('larger',MenuIcon.RESERVED,304,167,hit_width=32,hit_height=24))
        self._last_stamp_at = -1

    @property
    def size(self): return SIZES[self.size_index]

    def background_key(self):
        return (self.revision, self.shape, self.size_index,self.saved,
                self.dialog, self.dialog_target)

    def preview_pointer(self):
        return self.pointer if self.shape and not self.dialog and self.pointer and self.pointer[0]<256 else None

    def view_key(self):
        return (self.background_key(),self._choices.hovered_id,self.preview_pointer(),round(24*(self.back.progress or 0)),
                round(24*(self.album_dwell.progress or 0)),round(24*(self.dialog_dwell.progress or 0)))

    def update(self, control, observation):
        now = control.timestamp_ns
        if now <= self._last_time:
            return None
        self._last_time = now
        valid = control.hand_valid and not control.stale_flags & (StaleFlag.GESTURE|StaleFlag.ADAPTER_ERROR)
        self.pointer = (round((control.hand_x+1)*319/2),round((control.hand_y+1)*179/2)) if valid else None
        if not valid:
            self._choices.update(control,self._choice_targets,observation=observation)
            self.back.reset(); self.album_dwell.reset(); self.dialog_dwell.reset()
            self._last_brush = None
            return None
        x,y = self.pointer
        inside = return_contains(control)
        if self.wait_exit:
            if inside:
                return None
            self.wait_exit = False
        if self.dialog:
            target = next((name for name,left in DIALOG_TARGETS if left<=x<left+72 and 66<=y<124),None)
            if target != self.dialog_target:
                self.dialog_dwell.reset()
                self.dialog_target = target
            if self.dialog_dwell.update(target is not None,now):
                self.dialog = False
                self.dialog_dwell.reset(); self.back.reset()
                self.wait_exit = True
                self._last_brush = None
                if target == 'clear':
                    self.pixels[:] = bytes([2])*len(self.pixels)
                    self.revision += 1
                    self.saved=False
                if target == 'save':self.saved=True
                return 'home' if target == 'home' else target
            return None
        if self.back.update(inside,now):
            self._choices.reset(require_release=True)
            self.dialog = True
            self.dialog_target = None
            self._last_brush = None
            return 'dialog'
        if inside:
            self._last_brush = None
            return None
        if self.album_dwell.update(album_contains(control),now):
            self._last_brush=None
            return 'album'
        if album_contains(control):
            self._last_brush=None
            return None
        # Same latest control, pending confirmation and release latch as menus.
        choice=self._choices.update(control,self._choice_targets,observation=observation)
        if x>=CANVAS_WIDTH:
            self._last_brush=None
            target=choice.activated_id
            if target in SHAPES:
                self.shape=target
                return 'select'
            if target in ('smaller','larger') and self.shape:
                self.size_index=max(0,min(len(SIZES)-1,self.size_index+(-1 if target=='smaller' else 1)))
                return 'select'
            return None
        obs = observation or {}
        frame = (obs.get('run_id'),obs.get('config_epoch'),obs.get('frame_id'))
        # Use the same fresh, authorized UI fist as menu confirmation. The
        # classifier snapshot supplies identity only: an UNKNOWN/edge result
        # must not veto a fist already accepted by the live UI provider.
        fist = control.fist_event or control.fist_score >= 1.0
        if not fist:
            self._last_brush=None
            self._frame=frame
            return None
        if frame == self._frame:return None
        if self._frame is not None and frame[:2] != self._frame[:2]:self._last_brush=None
        if not (8 <= x < 248 and 26 <= y < 172):
            self._last_brush = None
            self._frame=frame
            return None
        if self.shape is None:
            self._last_brush = None
            return None
        if now-self._last_stamp_at < 66_666_667:
            # Leave this latest frame eligible for the next UI poll. Never
            # enqueue strokes, or consume a frame before its stamp is allowed.
            return None
        self._frame=frame
        color = COLORS[SHAPES.index(self.shape)]
        points = [(x,y)]
        if self._last_brush is not None:
            ox,oy = self._last_brush
            distance = math.hypot(x-ox,y-oy)
            if distance < max(2,self.size/4):
                return None
            # Bound work on a jump; never draw a bridge across tracking loss.
            if distance <= 60:
                steps = min(16,max(1,math.ceil(distance/max(2,self.size/4))))
                points = [(round(ox+(x-ox)*i/steps),round(oy+(y-oy)*i/steps)) for i in range(1,steps+1)]
        changed=False
        for px,py in points:
            changed=stamp(self.pixels,self.shape,self.size,px,py,color,stride=CANVAS_WIDTH) or changed
        self._last_brush = (x,y)
        self._last_stamp_at = now
        if not changed:
            return None
        self.revision += 1
        self.saved=False
        return 'paint'

    def render(self, *, preview=True,progress=True,hover=True):
        from .shell_pages import panel, border
        pixels = bytearray([1])*(WIDTH*HEIGHT)
        rect(pixels,9,28,241,146,12)
        for y in range(26,172):
            pixels[y*WIDTH+8:y*WIDTH+248] = self.pixels[y*CANVAS_WIDTH+8:y*CANVAS_WIDTH+248]
        if self.revision==0 and self.shape is None:
            text(pixels,'MAKE SOMETHING',76,80,color=8,scale=2)
            text(pixels,'CHOOSE A SHAPE TO BEGIN',85,100,color=8)
        rect(pixels,256,0,64,180,11)
        for i,cy in enumerate(SHAPE_CENTERS):
            panel(pixels,262,cy-14,52,28,2)
            highlighted=self.shape==SHAPES[i] or hover and self._choices.hovered_id==SHAPES[i]
            border(pixels,262,cy-14,52,28,7 if highlighted else 12,2 if highlighted else 1)
            stamp(pixels,SHAPES[i],18,288,cy,COLORS[i])
        panel(pixels,261,158,26,20,2); panel(pixels,290,158,26,20,2)
        for target,left in (('smaller',261),('larger',290)):
            if hover and self._choices.hovered_id==target:border(pixels,left,158,26,20,7,2)
        rect(pixels,268,167,12,2,9); rect(pixels,297,167,12,2,9); rect(pixels,302,162,2,12,9)
        text(pixels,str(self.size),285,151,color=9)
        if preview and self.shape and self.pointer and not self.dialog:
            x,y=self.pointer
            if x<256:
                # Preview is composited on a copy, never baked into the canvas.
                preview=bytearray(self.pixels)
                stamp(preview,self.shape,self.size,x,y,COLORS[SHAPES.index(self.shape)],stride=256)
                for yy in range(max(26,y-self.size//2),min(172,y+self.size//2+1)):
                    pixels[yy*320+8:yy*320+248]=preview[yy*256+8:yy*256+248]
        border(pixels,7,25,242,148,12)
        text(pixels,'SAVED TO ALBUM' if self.saved else 'FIST TO DRAW',128,175,color=8)
        rect(pixels,0,0,320,25,11)
        draw_header_brand(pixels,max_height=21)
        header_title(pixels,'CANVAS',height=25)
        if self.dialog:
            pixels[:] = bytes([1])*len(pixels)
            rect(pixels,0,0,320,50,11)
            text(pixels,'CANVAS',113,23,color=9,scale=4)
            from .shell_pages import action_icon
            for target,x in DIALOG_TARGETS:
                label={'continue':'PLAY','save':'SAVE','clear':'CLEAR','home':'MENU'}[target]
                panel(pixels,x,68,72,58,12);panel(pixels,x,66,72,58,2)
                border(pixels,x,66,72,58,7 if target==self.dialog_target else 12,2)
                cx=x+36
                if target in ('continue','home'):
                    action_icon(pixels,'resume' if target=='continue' else 'main-menu',cx,90)
                elif target=='save':
                    rect(pixels,cx-12,77,24,25,9);rect(pixels,cx-7,77,14,10,2)
                    rect(pixels,cx-7,91,14,11,2);rect(pixels,cx+3,79,3,6,7)
                else:
                    rect(pixels,cx-9,83,18,20,9);rect(pixels,cx-13,78,26,3,9)
                    rect(pixels,cx-5,74,10,3,7)
                    for dx in (-4,3):rect(pixels,cx+dx,86,2,13,2)
                text(pixels,label,cx-(len(label)*4-1)//2,111,color=8)
                if progress and target==self.dialog_target:
                    rect(pixels,x,120,round(72*(self.dialog_dwell.progress or 0)),4,10)
            text(pixels,'HOLD AN OPTION FOR 2 SEC',114-47,148,color=8)
        return bytes(pixels)


@lru_cache(maxsize=1)
def album_frame(saved):
    """Latest in-memory drawing only; no pointer, controls or disk persistence."""
    from .shell_pages import border
    pixels=bytearray([1])*57600
    rect(pixels,0,0,320,25,11)
    draw_header_brand(pixels,max_height=21)
    header_title(pixels,'ALBUM',height=25)
    if saved is None:
        text(pixels,'NO SAVED DRAWING',100,82,color=9,scale=2)
        text(pixels,'SAVE YOUR CANVAS FIRST',118-1,107,color=8)
    else:
        if len(saved)!=CANVAS_WIDTH*HEIGHT:raise ValueError('Invalid album raster')
        for y in range(26,172):
            pixels[y*320+40:y*320+280]=saved[y*256+8:y*256+248]
        border(pixels,39,25,242,148,12)
    return bytes(pixels)


class PixelPageRenderer:
    """One 28.8 KiB INDEX4 frame plus font fits the frozen 32 KiB GPU bank."""
    def compile_canvas(self,page,frame_id,generation):
        # Cache one background only. Moving the preview never rebuilds or
        # uploads the raster; the frozen GPU draws bounded horizontal spans.
        key=(page,generation,page.background_key())
        if getattr(self,'_canvas_key',None)!=key:
            pixels=page.render(preview=False,progress=False,hover=False)
            if getattr(self,'_canvas_key',None) is not None and self._canvas_key[:2]==key[:2]:
                # Geometry/font/palettes are immutable within this page. Only
                # replace the bounded raster when paint or selection changes.
                self._canvas_base=replace(self._canvas_base,assets=(
                    IndexedImage(WIDTH,HEIGHT,pixels),*self._canvas_base.assets[1:]))
            else:
                self._canvas_base=self.compile(pixels,0,generation)
            self._canvas_key=key
        base=self._canvas_base
        extra=[]
        hovered=page._choices.hovered_id
        if not page.dialog and hovered is not None:
            if hovered in SHAPES:
                x,y,w,h=262,SHAPE_CENTERS[SHAPES.index(hovered)]-14,52,28
            else:
                x,y,w,h=261 if hovered=='smaller' else 290,158,26,20
            extra.extend(GpuCommand.fill_rect(x=xx,y=yy,width=ww,height=hh,token=7)
                         for xx,yy,ww,hh in ((x+3,y,w-6,2),(x+3,y+h-2,w-6,2),
                                             (x,y+3,2,h-6),(x+w-2,y+3,2,h-6)))
        if page.dialog and page.dialog_target is not None:
            x=next(x for target,x in DIALOG_TARGETS if target==page.dialog_target)
            width=round(72*(page.dialog_dwell.progress or 0))
            if width:extra.append(GpuCommand.fill_rect(x=x,y=120,width=width,height=4,token=10))
        point=page.preview_pointer()
        if point:
            x,y=point
            color=COLORS[SHAPES.index(page.shape)]
            for dx,dy,w in mask_runs(page.shape,page.size):
                xx,yy=x+dx-page.size//2,y+dy-page.size//2
                lo,hi=max(8,xx),min(248,xx+w)
                if lo<hi and 26<=yy<172:
                    extra.append(GpuCommand.fill_rect(x=lo,y=yy,width=hi-lo,height=1,token=color))
        commands=(*base.commands[:-1],*extra,base.commands[-1])
        frame=replace(base,commands=commands,header=replace(base.header,
            frame_id=frame_id,submit_seq=0xC6A10000+frame_id,
            command_count=len(commands),predicted_cycles=SceneCompiler._predict_cycles(commands)))
        frame=add_return_progress_to_compiled(frame,page.back.progress)
        if len(frame.commands)>COMMAND_CAPACITY:
            raise ValueError('Canvas preview exceeds frozen command bank')
        return add_album_control(frame,page.album_dwell.progress) if not page.dialog else frame

    def compile_static(self,pixels,frame_id,generation,progress=None):
        key=(pixels,generation)
        if getattr(self,'_static_key',None)!=key:
            self._static_base=self.compile(pixels,0,generation)
            self._static_key=key
        frame=replace(self._static_base,header=replace(self._static_base.header,
            frame_id=frame_id,submit_seq=0xC6A10000+frame_id))
        return add_return_progress_to_compiled(frame,progress)

    def compile(self,pixels,frame_id,generation,progress=None,*,show_return=True):
        compiler=SceneCompiler(sprite_atlas=IndexedImage(320,180,pixels),
            tile_atlas=IndexedImage(1,1,b'\x00'),palettes=PalettePack((PALETTE,)))
        frame=compiler.compile(Scene(frame_id=frame_id,camera_x=0,background_color=PALETTE[1],
            sprites=(SpriteDescriptor(x=0,y=0,width=320,height=180,atlas_x=0,atlas_y=0,
                                      palette_bank=0,priority=1),)),
            submit_seq=0xC6A10000+frame_id,palette_generation=generation,
            asset_generation=generation,tilemap_generation=generation)
        if not show_return:
            return frame
        commands=(*frame.commands[:-1],*RETURN_COMMANDS,frame.commands[-1])
        frame=replace(frame,commands=commands,header=replace(frame.header,
            command_count=len(commands),predicted_cycles=frame.header.predicted_cycles+RETURN_EXTRA_CYCLES))
        return add_return_progress_to_compiled(frame,progress)

    def pack_assets(self,frame,generation):
        image=frame.assets[0]
        if (image.width,image.height)!=(320,180):
            raise ValueError('Pixel page requires the fixed 320x180 layout')
        key=(generation & 255,frame.assets[1:])
        if getattr(self,'_layout_key',None)!=key:
            template=pack_assets((IndexedImage(320,180,bytes(57600)),*frame.assets[1:]),generation=generation & 255)
            if len(template.payload)>ASSET_BUNDLE_CAPACITY_BYTES:
                raise ValueError('Pixel page exceeds frozen asset bank')
            self._layout=(template.descriptor_table,template.payload[28800:])
            self._layout_key=key
        # The page is even-width INDEX4. Bytes slicing and bigint bitwise ops
        # pack in C without a per-pixel Python loop or a NumPy dependency.
        low=int.from_bytes(image.pixels[::2],'little')
        high=int.from_bytes(image.pixels[1::2],'little')
        packed=(low | high<<4).to_bytes(28800,'little')
        prefix,tail=self._layout
        return pack_resource_packet(PacketType.ASSET,prefix+packed+tail,target_id=0,generation=generation)


@lru_cache(maxsize=24)
def _robot_hand_pixels(curls,bases,spread,opposition):
    """Cached motor-derived schematic, palm view of a right hand.

    The calibrated finger order is index/middle/ring/little/thumb. Draw in
    local left-thumb coordinates and mirror only the hand, never UI text.
    """
    pixels=bytearray([1])*(WIDTH*HEIGHT)
    def plate(x,y,w,h):
        rect(pixels,x,y,w,h,9)
        rect(pixels,x+2,y+2,w-4,h-4,8)
        rect(pixels,x+3,y+2,w-7,h-5,13)
        rect(pixels,x+4,y+3,w-9,2,2)
    def link(points,width,color):
        for (ax,ay),(bx,by) in zip(points,points[1:]):
            steps=max(abs(bx-ax),abs(by-ay),1)
            for n in range(steps+1):
                rect(pixels,round(ax+(bx-ax)*n/steps)-width//2,
                     round(ay+(by-ay)*n/steps)-width//2,width,width,color)
    def joint(x,y):
        rect(pixels,x-5,y-4,11,9,9);rect(pixels,x-4,y-5,9,11,9)
        rect(pixels,x-3,y-3,7,7,8);rect(pixels,x-2,y-2,4,4,3)
        rect(pixels,x-1,y-1,2,2,2)
    def finger(points):
        link(points,12,9);link(points,8,8);link(points,6,13)
        link(tuple((x-1,y-1) for x,y in points),2,2)
        for x,y in points[1:-1]:joint(x,y)
        x,y=points[-1];rect(pixels,x-3,y-3,6,5,10);rect(pixels,x-2,y-3,3,1,5)
    # Layered wrist, actuator channels and palm plates replace the old face.
    plate(140,137,42,19)
    for x in (146,155,164,173):rect(pixels,x,140,3,13,9)
    rect(pixels,141,154,40,3,10)
    plate(124,97,73,47)
    for x in (132,150,168,186):
        rect(pixels,x-1,105,3,28,8);rect(pixels,x,105,1,25,2)
    plate(132,117,57,22)
    rect(pixels,143,122,35,10,9)
    for x in (148,157,166):rect(pixels,x,125,5,3,10)
    for x,y in ((129,112),(191,112),(137,134),(184,134)):
        rect(pixels,x,y,3,3,9);rect(pixels,x,y,1,1,2)
    for i,(x,length) in enumerate(((132,36),(150,44),(168,42),(186,33))):
        offset=round(spread[i]*9)
        if bases[i]>.6:
            # Base flexion is distinct from the open-base hook used for nine.
            plate(x-7,93,15,23);joint(x,98)
            rect(pixels,x-4,106,9,2,9);rect(pixels,x-3,110,7,3,10)
        elif curls[i]>.6:
            finger(((x,102),(x+offset,79),(x+offset+5,72),
                    (x+offset+17,72),(x+offset+22,79),(x+offset+22,86)))
        else:
            finger(((x,102),(x+offset,87),(x+offset,110-length),(x+offset,102-length)))
    if opposition>.6 and bases[0]>.6 and curls[0]<.55:
        finger(((132,104),(141,89),(126,70)))
        finger(((126,120),(116,98),(142,76)))
    elif bases[4]>.6:
        finger(((124,119),(130,108),(151,103)))
    else:
        finger(((125,120),(110,108),(92,94)))
    return b''.join(pixels[y*WIDTH:(y+1)*WIDTH][::-1] for y in range(HEIGHT))


def robot_frame(pose='default',phase='WAITING',index=0, geometry=None):
    """Schematic motor-derived pose; cached artwork has no device access."""
    if phase=='WAITING_COMMAND':phase='RECONNECTING...'
    values=(geometry or {}).get(pose,{})
    curls=tuple(values.get('curls',[.4]*5))
    pixels=bytearray(_robot_hand_pixels(curls,tuple(values.get('bases',curls)),
        tuple(values.get('spread',[0]*5)),values.get('thumb_opposition',0)))
    rect(pixels,0,0,320,49,11)
    draw_header_brand(pixels)
    caption=pose.replace('demo:','').upper()
    header_title(pixels,'HAND SHOW',subtitle=caption)
    text(pixels,'RIGHT',240,113,color=10)
    text(pixels,'HAND',240,121,color=8)
    if pose=='demo:heart':
        for yy,row in enumerate(('0110110','1111111','1111111','0111110','0011100','0001000')):
            for xx,bit in enumerate(row):
                if bit=='1': rect(pixels,221+xx*2,64+yy*2,2,2,6)
    text(pixels,phase[:25],max(38,(320-(len(phase[:25])*4-1))//2),166,color=8)
    rect(pixels,62,176,196,2,7); rect(pixels,62,176,round(196*min(11,index)/11),2,10)
    return bytes(pixels)
