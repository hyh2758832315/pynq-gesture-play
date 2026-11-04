"""Explicit current-thread CPU placement, reversible; no hardware or RT policy."""
import os
import threading


class CurrentThreadAffinity:
    def __init__(self, *, api=os, thread_id=threading.get_native_id):
        if not hasattr(api, 'sched_getaffinity') or not hasattr(api, 'sched_setaffinity'):
            raise RuntimeError('CPU affinity unavailable; no hardware start')
        self.api, self.thread_id = api, thread_id
        self.owner_thread = thread_id()
        self.original = set(api.sched_getaffinity(0))
        if len(self.original) < 2:
            raise RuntimeError('Require two allowed CPUs; no hardware start')
        self.capture_cpu, self.worker_cpu = max(self.original), min(self.original)
        self.changed = False

    def pin(self):
        if self.thread_id() != self.owner_thread or self.changed:
            raise RuntimeError('Affinity thread/state mismatch')
        self.changed = True
        try:
            self.api.sched_setaffinity(0, {self.capture_cpu})
            if set(self.api.sched_getaffinity(0)) != {self.capture_cpu}:
                raise RuntimeError('Capture CPU affinity readback failed')
        except BaseException:
            self.restore()
            raise

    def restore(self):
        if not self.changed: return
        if self.thread_id() != self.owner_thread:
            raise RuntimeError('Cannot restore affinity from another thread')
        self.api.sched_setaffinity(0, self.original)
        if set(self.api.sched_getaffinity(0)) != self.original:
            raise RuntimeError('CPU affinity restoration failed')
        self.changed = False


def pin_worker(cpu, *, api=os):
    if cpu is None: return None
    if type(cpu) is not int or cpu < 0:
        raise ValueError('Invalid worker CPU')
    if not hasattr(api, 'sched_setaffinity'):
        raise RuntimeError('Worker CPU affinity unavailable')
    api.sched_setaffinity(0, {cpu})
    if set(api.sched_getaffinity(0)) != {cpu}:
        raise RuntimeError('Worker CPU affinity readback failed')
    return cpu
