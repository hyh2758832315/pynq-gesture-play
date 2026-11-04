from dataclasses import dataclass

from collision import Poly, Vector, collide

from .input_adapter import Command
from .level import Block, COINS, GOAL_X, LIFT_X, NOTE_X, SCALE, WORLD_WIDTH, PITS, level_blocks


def overlaps(first: Block, second: Block) -> bool:
    if first.x >= second.x + second.width or second.x >= first.x + first.width:
        return False
    if first.y >= second.y + second.height or second.y >= first.y + first.height:
        return False
    return bool(collide(
        Poly.from_box(Vector(first.x + first.width / 2, first.y + first.height / 2), first.width, first.height),
        Poly.from_box(Vector(second.x + second.width / 2, second.y + second.height / 2), second.width, second.height),
    ))


@dataclass
class Enemy:
    x: int
    left: int
    right: int
    direction: int = -1
    alive: bool = True


class PlatformGame:
    def __init__(self, tick_hz: int = 60) -> None:
        if tick_hz != 60:
            raise ValueError("game3 uses the frozen 60 Hz physics contract")
        self.tick = -1
        self.status = "SELECT"
        self.character = "male"
        self.x, self.y = 32 * SCALE, 124 * SCALE
        self.vx = self.vy = 0
        self.facing = 1
        self.grounded = True
        self.support = None
        self.coyote = self.buffer = 0
        self.score = 0
        self.health = 5
        self.invulnerable = 0
        self.death_reason = None
        self.finished_tick = None
        self.collected = set()
        self.used_bricks = set()
        self.stomps = 0
        self.head_bumps = 0
        self.gate_open = False
        self.note_hits = 0
        self.lift_y = 144 * SCALE
        self.lift_charge = self.lift_grace = 0
        self.audio_target = None
        self.audio_ticks = 0
        self.audio_sequence = -1
        self.audio_active = False
        self.audio_consumed = -1
        self.lift_direction = 0
        self.falls = 0
        self.enemies = [Enemy(504 * SCALE, 464 * SCALE, 544 * SCALE), Enemy(1300 * SCALE, 1280 * SCALE, 1392 * SCALE), Enemy(1720*SCALE,1580*SCALE,1840*SCALE), Enemy(2320*SCALE,2160*SCALE,2416*SCALE)]

    @property
    def body(self):
        return Block(self.x, self.y, 12 * SCALE, 20 * SCALE)

    @property
    def camera_x(self):
        return max(0, min(WORLD_WIDTH - 320, self.x // SCALE - 112))

    def solids(self):
        blocks = [(index, Block(block.x * SCALE, block.y * SCALE, block.width * SCALE, block.height * SCALE, block.kind))
                  for index, block in enumerate(level_blocks()) if block.kind != "gate" or not self.gate_open]
        blocks.append(("switch", Block(NOTE_X*SCALE,136*SCALE,24*SCALE,8*SCALE,"switch")))
        blocks.append(("lift", Block(LIFT_X * SCALE, self.lift_y, 48 * SCALE, 8 * SCALE, "lift")))
        return blocks

    def step(self, tick: int, command: Command) -> None:
        if tick != self.tick + 1:
            raise ValueError("game3 ticks must be consecutive from zero")
        self.tick = tick
        if self.status == "SELECT":
            if command.direction:
                self.character = "male" if command.direction < 0 else "female"
            if command.jump or command.jump_held:
                self.status = "RUNNING"
            return
        if self.status != "RUNNING":
            if command.jump and self.finished_tick is not None and tick - self.finished_tick >= 60:
                self.__init__()
                self.tick = tick
            return
        self.invulnerable = max(0, self.invulnerable - 1)
        near_lift = abs(self.x + 6*SCALE - (LIFT_X+24)*SCALE) <= 80*SCALE
        self.lift_direction = command.vertical if near_lift else 0
        self._lift()
        self.coyote = 6 if self.grounded else max(0, self.coyote - 1)
        self.buffer = 6 if command.jump or command.jump_held else max(0, self.buffer - 1)
        if self.buffer and self.coyote:
            self.vy = -440
            self.grounded = False
            self.support = None
            self.coyote = self.buffer = 0
        target = command.direction * 144
        change = 24 if command.direction else 32
        self.vx += max(-change, min(change, target - self.vx))
        if command.direction:
            self.facing = command.direction
        self._move_x(self.vx)
        previous_bottom = self.y + 20 * SCALE
        self.vy = min(self.vy + 24, 512)
        self._move_y(self.vy)
        self._enemies(previous_bottom)
        for index, (coin_x, coin_y) in enumerate(COINS):
            if index not in self.collected and overlaps(self.body, Block(coin_x * SCALE, coin_y * SCALE, 8 * SCALE, 12 * SCALE)):
                self.collected.add(index)
                self.score += 10
        if self.y > 212 * SCALE:
            self.health -= 1
            self.falls += 1
            if self.health <= 0:
                self.status, self.death_reason = "LOST", "pit"
            else:
                left = max((a for a,b in PITS if a*SCALE <= self.x+12*SCALE), default=400)
                self.x,self.y=(left-32)*SCALE,124*SCALE
                self.vx=self.vy=0
                self.grounded=True
                self.support=None
                self.buffer=self.coyote=0
                self.invulnerable=120
        elif self.status == "RUNNING" and self.x >= GOAL_X * SCALE and self.grounded:
            self.status = "WON"
            self.score += 100
        if self.status != "RUNNING":
            self.finished_tick = tick

    def _move_x(self, amount: int) -> None:
        self.x = max(0, min((WORLD_WIDTH - 12) * SCALE, self.x + amount))
        blocks = sorted(self.solids(), key=lambda item: item[1].x, reverse=amount < 0)
        for _, block in blocks:
            if block.kind in ("lift", "switch"):
                continue
            if overlaps(self.body, block):
                self.x = block.x - 12 * SCALE if amount > 0 else block.x + block.width
                self.vx = 0

    def _move_y(self, amount: int) -> None:
        previous_bottom=self.y+20*SCALE
        self.y += amount
        self.grounded, self.support = False, None
        blocks = sorted(self.solids(), key=lambda item: (item[1].y, item[1].kind != "lift"), reverse=amount < 0)
        for identifier, block in blocks:
            if block.kind=="switch" and (amount<=0 or previous_bottom>block.y):
                continue
            if block.kind=="lift" and (self.lift_direction>0 or amount<0 or previous_bottom>block.y):
                continue
            if overlaps(self.body, block):
                self.y = block.y - 20 * SCALE if amount > 0 else block.y + block.height
                self.vy = 0
                if amount > 0:
                    if block.kind=="switch" and not self.gate_open:
                        self.gate_open=True;self.note_hits+=1
                    self.grounded, self.support = True, identifier
                elif block.kind in ("brick", "reward"):
                    self.head_bumps += 1
                    if block.kind == "reward" and identifier not in self.used_bricks:
                        self.used_bricks.add(identifier)
                        self.score += 10

    def _enemies(self, previous_bottom: int) -> None:
        for enemy in self.enemies:
            if not enemy.alive:
                continue
            enemy.x += enemy.direction * 32
            if enemy.x <= enemy.left or enemy.x >= enemy.right:
                enemy.x = max(enemy.left, min(enemy.right, enemy.x))
                enemy.direction *= -1
            top = (32 if 1056*SCALE <= enemy.left < 1536*SCALE else 128) * SCALE
            if not overlaps(self.body, Block(enemy.x, top, 16 * SCALE, 16 * SCALE)):
                continue
            if self.vy > 0 and previous_bottom <= top:
                enemy.alive = False
                self.y, self.vy = top - 20 * SCALE, -320
                self.grounded, self.support = False, None
                self.stomps += 1
                self.score += 20
            elif not self.invulnerable:
                self.health -= 1
                self.invulnerable = 90
                if self.health == 0:
                    self.status, self.death_reason = "LOST", "enemy"

    def _near_target(self):
        center_x, center_y = self.x + 6 * SCALE, self.y + 10 * SCALE
        candidates = []
        for target, target_x, target_y in (("note", NOTE_X + 8, 132), ("lift", LIFT_X + 24, self.lift_y // SCALE)):
            distance = abs(center_x - target_x * SCALE)
            if distance <= 64 * SCALE and abs(center_y - target_y * SCALE) <= 48 * SCALE:
                candidates.append((distance, target))
        return min(candidates)[1] if candidates else None

    def _audio(self, tone) -> None:
        active = tone is not None and tone.active
        sequence = tone.sequence if tone is not None else self.audio_sequence
        if self.audio_active and (not active or sequence != self.audio_sequence):
            if self.audio_target == "note" and 3 <= self.audio_ticks <= 24 and self._near_target() == "note":
                self.gate_open = True
                self.note_hits += 1
            self.audio_consumed = self.audio_sequence
            self.audio_active = False
            self.audio_ticks = 0
            self.audio_target = None
        if active and sequence > self.audio_consumed:
            if not self.audio_active:
                self.audio_sequence = sequence
                self.audio_target = self._near_target()
                self.audio_active = True
            if self._near_target() != self.audio_target:
                self.audio_target = None
            self.audio_ticks += 1
        self.lift_charge = min(18, self.audio_ticks) if self.audio_active and self.audio_target == "lift" else 0

    def _lift(self) -> None:
        previous_y = self.lift_y
        if self.lift_direction < 0:
            self.lift_y = max(64 * SCALE, self.lift_y - 48)
            self.lift_grace = 120
        elif self.lift_direction > 0:
            self.lift_y = min(144 * SCALE, self.lift_y + 24)
        delta = self.lift_y - previous_y
        if self.lift_direction > 0:
            if self.support == "lift":self.support=None;self.grounded=False
            return  # Descending platform passes through the character.
        if self.support == "lift" and self.grounded:
            destination = Block(self.x, self.y + delta, 12 * SCALE, 20 * SCALE)
            if any(overlaps(destination, block) for identifier, block in self.solids() if identifier != "lift"):
                self.lift_y = previous_y
            else:
                self.y += delta
        elif delta and overlaps(self.body, Block(LIFT_X * SCALE, self.lift_y, 48 * SCALE, 8 * SCALE)):
            self.lift_y = previous_y