from pynq_multimodal_game.game_sdk import HandGesture


CHOICES = (HandGesture.FIST, HandGesture.SCISSORS, HandGesture.PAPER)
BEATS = {
    HandGesture.FIST: HandGesture.SCISSORS,
    HandGesture.SCISSORS: HandGesture.PAPER,
    HandGesture.PAPER: HandGesture.FIST,
}


def judge(human: HandGesture, robot: HandGesture) -> str:
    if human is robot:
        return "DRAW"
    return "WIN" if BEATS[human] is robot else "LOSE"


class RpsMatch:
    def __init__(self, random_source, tick_hz: int, *, stability_ticks: int | None = None) -> None:
        if tick_hz <= 0:
            raise ValueError("tick rate must be positive")
        self.random = random_source
        self.tick_hz = tick_hz
        self.stability_ticks = max(1, (tick_hz + 1) // 2) if stability_ticks is None else stability_ticks
        if self.stability_ticks < 1:
            raise ValueError("stability interval must be positive")
        self.stable_ticks = 0
        self._stable_gesture = None
        self.countdown_ticks = tick_hz * 3
        self.reveal_ticks = max(1, (tick_hz * 3 + 1) // 2)
        self.intermission_ticks = max(1, (tick_hz + 1) // 2)
        self.tick_id = -1
        self.phase = "READY"
        self.phase_start = 0
        self.status = "RUNNING"
        self.round_index = 1
        self.human_live = None
        self.human_locked = None
        self.robot_locked = None
        self.outcome = None
        self.history = []
        self._robot_commit = None

    @property
    def human_wins(self) -> int:
        return sum(record["outcome"] == "WIN" for record in self.history)

    @property
    def robot_wins(self) -> int:
        return sum(record["outcome"] == "LOSE" for record in self.history)

    @property
    def countdown_remaining(self) -> int:
        if self.phase != "COUNTDOWN":
            return 0
        return max(0, self.countdown_ticks - (self.tick_id - self.phase_start))

    def step(self, tick_id: int, gesture: HandGesture | None) -> None:
        if tick_id != self.tick_id + 1:
            raise ValueError("game2 requires consecutive ticks starting at zero")
        self.tick_id = tick_id
        if self.phase == "DONE":
            return
        self.human_live = gesture
        elapsed = tick_id - self.phase_start
        if self.phase == "READY":
            self._wait_for_stability(tick_id, gesture)
        elif self.phase == "COUNTDOWN" and elapsed >= self.countdown_ticks:
            if gesture is None:
                self.phase = "READY"
                self.phase_start = tick_id
                self.stable_ticks = 0
                self._stable_gesture = None
            else:
                self.human_locked = gesture
                self.robot_locked = self._robot_commit
                self.outcome = judge(gesture, self.robot_locked)
                self.history.append({
                    "round": self.round_index,
                    "human": gesture.value,
                    "robot": self.robot_locked.value,
                    "outcome": self.outcome,
                    "locked_tick": tick_id,
                })
                self.phase = "REVEAL"
                self.phase_start = tick_id
        elif self.phase == "REVEAL" and elapsed >= self.reveal_ticks:
            self.phase_start = tick_id
            if len(self.history) == 3:
                self.phase = "DONE"
                self.status = "WON" if self.human_wins > self.robot_wins else "LOST" if self.robot_wins > self.human_wins else "DRAW"
            else:
                self.phase = "INTERMISSION"
        elif self.phase == "INTERMISSION" and elapsed >= self.intermission_ticks:
            self.round_index += 1
            self.human_locked = self.robot_locked = self.outcome = None
            self._robot_commit = None
            self.phase = "READY"
            self.phase_start = tick_id
            self.stable_ticks = 0
            self._stable_gesture = None
            self._wait_for_stability(tick_id, gesture)

    def _wait_for_stability(self, tick_id: int, gesture: HandGesture | None) -> None:
        if gesture is None:
            self.stable_ticks = 0
        elif gesture is self._stable_gesture:
            self.stable_ticks += 1
        else:
            self.stable_ticks = 1
        self._stable_gesture = gesture
        if self.stable_ticks >= self.stability_ticks:
            self._begin_round(tick_id)

    def _begin_round(self, tick_id: int) -> None:
        if self._robot_commit is None:
            self._robot_commit = self.random.choice(CHOICES)
        self.phase = "COUNTDOWN"
        self.phase_start = tick_id