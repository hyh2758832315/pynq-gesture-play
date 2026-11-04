"""Accepted detector edges -> Game1 policy; no hardware or game writes.

Use one bridge per continuous detector epoch. Never concatenate separate clips
as if they proved a voice release. Tick even with no audio event, so the shield
expires after five seconds. Shield-off is sound release, not shield cancellation.
"""
from .voice_policy import VoicePolicy


class VoiceEventBridge:
    def __init__(self):
        self.policy = VoicePolicy()
        self.oh_active = False
        self.sequence = 0

    def update(self, now_ns, event=None):
        if event not in (None, 'attack', 'shield_on', 'shield_off'):
            self.policy.reset()
            self.oh_active = False
            raise ValueError('Unknown recognition event')
        label, sequence = None, None
        # Validate time before changing edge state.
        try:
            self.policy.update(now_ns)
        except ValueError:
            self.reset()
            raise
        if event == 'shield_on' and not self.oh_active:
            self.oh_active = True
            label = 'shield'
        elif event == 'shield_off':
            self.oh_active = False
        elif event == 'attack':
            label = 'attack'
        if label is not None:
            self.sequence += 1
            sequence = self.sequence
        return self.policy.update(now_ns, label, sequence)

    def reset(self):
        self.policy.reset()
        self.oh_active, self.sequence = False, 0
