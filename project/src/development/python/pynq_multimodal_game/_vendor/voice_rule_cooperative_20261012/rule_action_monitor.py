"""Decision-clock rule observer in CPU worker; never dispatches game actions."""
from game1_rules.voice_event_bridge import VoiceEventBridge

class RuleActionMonitor:
    def __init__(self):
        self.bridge=VoiceEventBridge()
        self.shield=False
        self.last_ns=None
        self.rows=[]

    def step(self, now_ns, events):
        if type(now_ns) is not int or (self.last_ns is not None and now_ns<self.last_ns):
            raise ValueError('Rule observation clock invalid')
        self.last_ns=now_ns
        new=[]
        def observe(event):
            decision=self.bridge.update(now_ns,event)
            if event is not None:
                new.append(dict(kind='recognition',event=event,time_ns=now_ns,
                    attack_request=decision.attack,shield=decision.shield,reason=decision.reason,
                    shield_deadline_ns=self.bridge.policy.deadline_ns))
            if decision.shield!=self.shield:
                new.append(dict(kind='action',event='shield_on' if decision.shield else 'shield_off',
                    time_ns=now_ns,shield_deadline_ns=self.bridge.policy.deadline_ns))
                self.shield=decision.shield
        observe(None) # Real worker tick: expires shield without a sound event.
        for kind,_ in events: observe(kind)
        if len(self.rows)+len(new)>5000:
            raise RuntimeError('Rule trace ceiling exceeded')
        self.rows.extend(new)
        return new
