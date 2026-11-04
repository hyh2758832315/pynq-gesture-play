"""Game1 action policy for accepted recognition edges, not raw audio/pitch."""
from dataclasses import dataclass

SHIELD_NS = 5_000_000_000
ATTACK_COOLDOWN_NS = 500_000_000


@dataclass(frozen=True)
class VoiceDecision:
    attack: bool
    shield: bool
    remaining_ns: int
    reason: str


class VoicePolicy:
    def __init__(self):
        self.reset()

    def reset(self):
        self.deadline_ns = 0
        self.last_time_ns = None
        self.last_sequence = -1
        self.remaining_ns = 0
        self.attack_deadline_ns = 0

    def update(self, now_ns, label=None, sequence=None):
        if (type(now_ns) is not int or now_ns < 0
                or (self.last_time_ns is not None and now_ns < self.last_time_ns)):
            self.reset()
            raise ValueError('Voice time must be monotonic nonnegative integer ns')
        if label not in (None, 'none', 'attack', 'shield'):
            self.reset()
            raise ValueError('Only accepted attack/shield edges or safe none allowed')
        fresh = False
        if label in ('attack', 'shield'):
            if type(sequence) is not int or sequence < 0:
                self.reset()
                raise ValueError('Recognition edge requires nonnegative integer sequence')
            fresh = sequence > self.last_sequence
            if fresh:
                # Consume even suppressed attacks, so they cannot be queued.
                self.last_sequence = sequence
        self.last_time_ns = now_ns
        if label == 'shield' and fresh:
            self.deadline_ns = now_ns + SHIELD_NS
        self.remaining_ns = max(0, self.deadline_ns - now_ns)
        shield = self.remaining_ns > 0
        cooling = now_ns < self.attack_deadline_ns
        attack = label == 'attack' and fresh and not shield and not cooling
        if attack:
            self.attack_deadline_ns = now_ns + ATTACK_COOLDOWN_NS
        reason = ('shield_refresh' if label == 'shield' and fresh else
                  'attack_blocked_by_shield' if label == 'attack' and fresh and shield else
                  'attack_blocked_by_cooldown' if label == 'attack' and fresh and cooling else
                  'attack_request' if attack else 'no_new_action')
        return VoiceDecision(attack, shield, self.remaining_ns, reason)
