"""Isolated offline candidate: one coherent energy onset per quiet release.

Original Q/spectral/pitch/confirmation/voting/cooldown and oh equations remain
in the frozen reference. This changes attack onset/arming semantics, not models.
Never imported by the delivered live runner.
"""
class EnergyOnsetDetector:
    def __init__(self, cfg, reference):
        self.cfg = cfg
        self.base = reference.MultiphaseDetector(cfg)
        n = self.base.phase_count
        self.quiet = [0]*n
        self.floor = [cfg['power_min']]*n
        self.ready = [False]*n
        self.age = [0]*n
        self.consumed = [False]*n

    def step(self, start, power, q, hi, zcr=0., pitch=0., low=0.):
        phase = (start//self.base.stride)%self.base.phase_count
        state = self.base.states[phase]
        # Low-energy background is not a voice onset, even when periodic Q is
        # high. Eight phase-local decisions (128ms) establish actual release.
        if power < self.cfg['high_power_min']:
            if self.quiet[phase] == 0:
                self.floor[phase] = max(self.cfg['power_min'],power)
            else:
                self.floor[phase] = max(self.floor[phase],power)
            self.quiet[phase] += 1
            if self.quiet[phase] >= 8:
                self.ready[phase] = True
        else:
            if self.ready[phase] and power >= 8*self.floor[phase]:
                # Consume onsets during cooldown, never queue a held sound
                # for a late attack when cooldown expires.
                self.age[phase] = (1 if state['refract']==0
                    and self.base.global_refract==0 else 0)
                self.consumed[phase] = False
                self.ready[phase] = False
                state.update(high_run=0,rise_seen=False,rise_q_ok=False)
            elif self.age[phase]:
                self.age[phase] += 1
            self.quiet[phase] = 0
        # A fixed onset age, not weak voiced-prefix age or an indefinitely
        # refreshed fallback. Original two-phase vote still decides output.
        allowed = (0 < self.age[phase] <= self.cfg['high_onset_max_windows']
                   and not self.consumed[phase])
        state['high_armed'] = allowed
        state['unvoiced_run'] = 0
        state['utterance_age'] = self.age[phase]-1 if allowed else 0
        row = self.base.step(start,power,q,hi,zcr,pitch,low)
        if row['high_candidate']:
            self.consumed[phase] = True
        return row
