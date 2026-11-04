"""Scoped software timing only. No additional owner checks, MMIO or writes."""
from collections import deque
import time


class PollProfiler:
    def __init__(self, driver, *, wall=time.perf_counter, cpu=time.thread_time):
        self.driver, self.wall, self.cpu = driver, wall, cpu
        self.history, self.last_report = deque(maxlen=16), None
        self.active = False

    def reports(self):
        if not self.history: return []
        worst = max(self.history, key=lambda r: r['wall_ms'])
        return [self.last_report] if worst is self.last_report else [worst, self.last_report]

    def poll_packet(self, *, timeout):
        if self.active: raise RuntimeError('Concurrent profiling rejected')
        self.active = True
        driver = self.driver
        original_call = driver._call
        call_override = vars(driver).get('_call')
        had_call_override = '_call' in vars(driver)
        owner = getattr(driver.owner, '__self__', None)
        backend = getattr(owner, 'backend', None)
        original_confirmed = getattr(backend, 'confirmed', None)
        had_backend_override = backend is not None and 'confirmed' in vars(backend)
        backend_override = vars(backend).get('confirmed') if backend is not None else None
        callbacks = []
        owner_count, owner_wall, owner_cpu = 0, 0., 0.

        def timed_owner():
            nonlocal owner_count, owner_wall, owner_cpu
            w, c = self.wall(), self.cpu()
            try: return original_confirmed()
            finally:
                owner_count += 1
                owner_wall += self.wall()-w
                owner_cpu += self.cpu()-c

        def timed_call(callback, *args):
            w, c = self.wall(), self.cpu()
            name = getattr(callback, '__qualname__', type(callback).__name__)
            try: return original_call(callback, *args)
            finally:
                callbacks.append((name, self.wall()-w, self.cpu()-c))

        installed_call, installed_owner = False, False
        w, c = self.wall(), self.cpu()
        failure = None
        try:
            driver._call = timed_call
            installed_call = True
            if original_confirmed is not None:
                backend.confirmed = timed_owner
                installed_owner = True
            return driver.poll_packet(timeout=timeout)
        except BaseException as exc:
            failure = (type(exc).__name__, str(exc))
            raise
        finally:
            # Restore even on deadline/ownership/native callback errors, before
            # any caller stop/release. Pool/driver owner identity never changes.
            if installed_owner:
                if had_backend_override: backend.confirmed = backend_override
                else: del backend.confirmed
            if installed_call:
                if had_call_override: driver._call = call_override
                else: del driver._call
            elapsed, cpu_elapsed = self.wall()-w, self.cpu()-c
            self.last_report = dict(
                wall_ms=elapsed*1000, thread_cpu_ms=cpu_elapsed*1000,
                wall_minus_thread_cpu_ms=max(0., elapsed-cpu_elapsed)*1000,
                owner_backend_calls=owner_count, owner_backend_wall_ms=owner_wall*1000,
                owner_backend_thread_cpu_ms=owner_cpu*1000,
                driver_call_envelopes_wall_ms=sum(r[1] for r in callbacks)*1000,
                outside_call_envelopes_wall_ms=(elapsed-sum(r[1] for r in callbacks))*1000,
                callback_envelopes=[dict(name=n, wall_ms=a*1000, thread_cpu_ms=b*1000)
                                    for n,a,b in callbacks[-32:]],
                fault=failure, profiling_overhead_included=True,
                hardware_operations_added=0, owner_checks_added=0,
                note='Owner timings overlap call envelopes: do NOT add them. Wall minus CPU includes sleeps/blocking/preemption, not just scheduler delay.')
            self.history.append(self.last_report)
            self.active = False
