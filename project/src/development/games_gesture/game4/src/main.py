"""Studio GamePlugin: screen-relative steering, fist boost, cached tile board."""
import hashlib
import json
from pynq_multimodal_game.game_sdk import GameContext,GameSnapshot,HandGesture
from pynq_multimodal_game.scene import Scene,SpriteDescriptor,TileDescriptor,TileLayer
from .assets import create_assets,PALETTE
from .rules import Duel,DIRECTIONS,WIDTH,HEIGHT


class Game:
    def __init__(self):
        self._assets,self._labels=create_assets()
        self.reset(GameContext(seed=0,tick_hz=60))

    def reset(self,context):
        context.random.seed(context.seed)
        self.duel=Duel(context.random,context.tick_hz)
        self._layer_revision=-1;self._layer=None
        self._snapshot=None
        return self.snapshot()

    def step(self,game_input):
        direction=None
        if game_input.hand_valid and max(abs(game_input.hand_x),abs(game_input.hand_y))>=.35:
            x,y=game_input.hand_x,game_input.hand_y
            direction=((1 if x>0 else -1),0) if abs(x)>=abs(y) else (0,(1 if y>0 else -1))
        boost=game_input.hand_valid and (game_input.hand_gesture is HandGesture.FIST or
                  (not game_input.has_gesture_input and game_input.fist_event))
        self.duel.step(game_input.tick_id,direction,boost)
        self._snapshot=None
        return self.snapshot()

    def snapshot(self):
        if self._snapshot is None:
            d=self.duel
            state=[list(d.player),list(d.robot),sorted(d.fruits),d.player_direction,
                   d.robot_direction,d.player_credit,d.robot_credit,d.score,d.robot_score,d.tick,d.status]
            digest=hashlib.sha256(json.dumps(state,separators=(',',':')).encode()).hexdigest()
            self._snapshot=GameSnapshot(max(0,d.tick),d.status,d.score,dict(
                player_head=list(d.player[0]),robot_head=list(d.robot[0]),
                player_length=len(d.player),robot_length=len(d.robot),robot_score=d.robot_score,
                moves=d.moves,boosted=d.boosted,fruits=len(d.fruits),reason=d.reason,
                state_sha256=digest))
        return self._snapshot

    def build_scene(self):
        d=self.duel
        if self._layer_revision!=d.revision:
            cells=[TileDescriptor(0)]*(WIDTH*HEIGHT)
            for x,y in d.fruits:cells[y*WIDTH+x]=TileDescriptor(3)
            for body,tile in ((d.player,1),(d.robot,2)):
                for x,y in body:cells[y*WIDTH+x]=TileDescriptor(tile)
            for body,base,direction in ((d.player,4,d.player_direction),(d.robot,8,d.robot_direction)):
                x,y=body[0];cells[y*WIDTH+x]=TileDescriptor(base+DIRECTIONS.index(direction))
            self._layer=TileLayer(WIDTH,HEIGHT,tuple(cells),origin_x=8,origin_y=32,tile_size=8)
            self._layer_revision=d.revision
        sprites=[]
        def label(value,x,y):
            ax,ay,w,h=self._labels[value]
            sprites.append(SpriteDescriptor(x,y,w,h,ax,ay,0,10+len(sprites)))
        label('SNAKE DUEL',32,5);label('YOU',126,7);label('BOT',220,7)
        for n,value in enumerate((d.score,d.robot_score)):
            for i,c in enumerate(str(value).zfill(3)):label(c,144+n*94+i*8,5)
        if d.tick<2*d.tick_hz:
            label('READY',138,83)
        elif d.boosted:label('BOOST',280,20)
        label('POINT TO STEER  FIST BOOST',8,23)
        return Scene(max(0,d.tick),0,PALETTE[1],tuple(sprites),self._layer)

    def assets(self):return self._assets
    def close(self):pass


def create_game():return Game()
