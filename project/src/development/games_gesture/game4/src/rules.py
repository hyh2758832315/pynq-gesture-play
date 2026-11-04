"""Deterministic simultaneous snake movement; no hardware, timers or threads."""
from collections import deque

WIDTH, HEIGHT = 38, 18
DIRECTIONS = ((1,0),(0,1),(-1,0),(0,-1))
MAX_LENGTH = 96
FRUIT_COUNT = 3


def advance(point, direction):
    return ((point[0]+direction[0])%WIDTH,(point[1]+direction[1])%HEIGHT)


def distance(a,b):
    dx,dy=abs(a[0]-b[0]),abs(a[1]-b[1])
    return min(dx,WIDTH-dx)+min(dy,HEIGHT-dy)


class Duel:
    def __init__(self,random,tick_hz=60):
        self.random=random;self.tick_hz=tick_hz
        self.player=deque((8-i,6) for i in range(6))
        self.robot=deque((29+i,12) for i in range(6))
        self.player_direction=(1,0);self.robot_direction=(-1,0)
        self.pending_direction=self.player_direction
        self.player_credit=self.robot_credit=0
        self.score=self.robot_score=0
        self.tick=-1;self.moves=0;self.revision=0
        self.status='RUNNING';self.reason=None;self.boosted=False
        self.fruits=set();self.refill()

    def refill(self):
        occupied=set(self.player)|set(self.robot)|self.fruits
        # Enumerate a bounded board, rather than repeatedly guessing an empty
        # cell. Even a crowded board cannot hang fruit generation.
        free=[(x,y) for y in range(HEIGHT) for x in range(WIDTH) if (x,y) not in occupied]
        while free and len(self.fruits)<FRUIT_COUNT:
            self.fruits.add(free.pop(self.random.randrange(len(free))))

    def steer(self,direction):
        if direction is not None and direction not in DIRECTIONS:
            raise ValueError('Snake direction must be a screen-relative cardinal vector')
        # Read only the latest screen-relative request. No snake/head target
        # subtraction and no queued pair of turns between movement ticks.
        opposite=tuple(-v for v in self.player_direction)
        self.pending_direction=(direction if direction is not None and direction!=opposite
                                else self.player_direction)

    def robot_turn(self):
        blocked=set(self.player)|set(self.robot)
        # Conservatively retain both tails for AI planning. Actual simultaneous
        # collision resolution below knows precisely which tails really vacate.
        candidates=[]
        opposite=tuple(-v for v in self.robot_direction)
        for direction in DIRECTIONS:
            if direction==opposite:continue
            point=advance(self.robot[0],direction)
            if point in blocked:continue
            exits=sum(advance(point,d) not in blocked for d in DIRECTIONS)
            nearest=min((distance(point,f) for f in self.fruits),default=0)
            # A small local planner: no pathfinding thread or unbounded search.
            candidates.append((exits*8-nearest,direction==self.robot_direction,direction))
        if candidates:self.robot_direction=max(candidates)[2]

    def move(self,move_player,move_robot):
        if move_player:self.player_direction=self.pending_direction
        if move_robot:self.robot_turn()
        p=advance(self.player[0],self.player_direction) if move_player else self.player[0]
        b=advance(self.robot[0],self.robot_direction) if move_robot else self.robot[0]
        eat_p=move_player and p in self.fruits
        eat_b=move_robot and b in self.fruits
        grow_p=eat_p and len(self.player)<MAX_LENGTH
        grow_b=eat_b and len(self.robot)<MAX_LENGTH
        # Only a moving, nongrowing tail vacates. A stationary or eating snake's
        # tail is still solid. Resolve both proposed heads against the same state.
        body_p=set(self.player);body_b=set(self.robot)
        if move_player and not grow_p:body_p.remove(self.player[-1])
        if move_robot and not grow_b:body_b.remove(self.robot[-1])
        dead_p=move_player and (p in body_p or p in body_b)
        dead_b=move_robot and (b in body_p or b in body_b)
        if p==b and (move_player or move_robot):dead_p=dead_b=True
        if move_player and move_robot and p==self.robot[0] and b==self.player[0]:
            dead_p=dead_b=True
        if dead_p or dead_b:
            self.status='LOST' if dead_p else 'WON'
            self.reason='PLAYER COLLISION' if dead_p else 'ROBOT COLLISION'
            return
        if move_player:
            self.player.appendleft(p)
            if not grow_p:self.player.pop()
            self.score+=10*bool(eat_p)
        if move_robot:
            self.robot.appendleft(b)
            if not grow_b:self.robot.pop()
            self.robot_score+=10*bool(eat_b)
        self.fruits.difference_update((p,b))
        if eat_p or eat_b:self.refill()
        self.moves+=bool(move_player);self.revision+=1
        if self.score>=200 or self.robot_score>=200:
            self.status='WON' if self.score>=200 else 'LOST';self.reason='FRUIT TARGET'

    def step(self,tick,direction=None,boost=False):
        if tick!=self.tick+1:raise ValueError('Snake ticks must be consecutive')
        self.tick=tick
        if self.status!='RUNNING':return
        self.steer(direction);self.boosted=bool(boost)
        if tick<2*self.tick_hz:return
        self.player_credit+=12 if boost else 8
        self.robot_credit+=8
        move_p=self.player_credit>=self.tick_hz
        move_b=self.robot_credit>=self.tick_hz
        if move_p:self.player_credit-=self.tick_hz
        if move_b:self.robot_credit-=self.tick_hz
        if move_p or move_b:self.move(move_p,move_b)
        if self.status=='RUNNING' and tick>=122*self.tick_hz:
            self.status='WON' if self.score>self.robot_score else 'LOST' if self.score<self.robot_score else 'DRAW'
            self.reason='TIME UP'
