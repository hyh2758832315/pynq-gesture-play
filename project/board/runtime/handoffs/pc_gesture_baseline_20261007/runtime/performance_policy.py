"""Explicit opt-in policy; never change DMA or gesture safety gates."""
def configure_tracker(runtime, mode):
    if mode not in ('validation', 'performance'):
        raise ValueError('Unknown vision mode')
    base = runtime.FullFrameTracker
    class ModeTracker(base):
        def __init__(self, *args, **kwargs):
            super().__init__(*args, **kwargs)
            self.skin_validate = mode == 'validation'
    runtime.FullFrameTracker = ModeTracker
    return ModeTracker
