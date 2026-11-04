"""Bounded spawned CPU-only recognizer; no PYNQ/MMIO/lease imports or IO."""
from pathlib import Path
import importlib
import multiprocessing as mp
import queue
import time
import sys
import numpy as np


def _start_in_current_main(process):
    # IPython %run temporarily replaces __main__. Patching the notebook module
    # before %run is insufficient: repair the actual module seen by spawn,
    # only for its synchronous startup preparation, then restore exactly.
    main = sys.modules.get('__main__')
    missing = main is not None and not hasattr(main, '__spec__')
    if missing:
        main.__spec__ = None
    try:
        process.start()
    finally:
        if missing:
            del main.__spec__


def _worker(root, incoming, outgoing, worker_cpu=None, relative_onset=False, energy_onset=False, game_rules=False):
    try:
        root = Path(root).resolve()
        affinity = importlib.import_module('voice_cpu_affinity') if worker_cpu is not None else None
        if affinity is not None and Path(affinity.__file__).resolve().parent != root:
            raise RuntimeError('Wrong affinity module origin')
        pinned_cpu = affinity.pin_worker(worker_cpu) if affinity is not None else None
        ref = importlib.import_module('audio_reference')
        core = importlib.import_module('voice_stream_core')
        feat = importlib.import_module('fast_voice_features')
        for module in (ref, core, feat):
            if Path(module.__file__).resolve().parent != root:
                raise RuntimeError('Wrong CPU worker module origin')
        cfg = ref.load_config(str(root/'audio_config.json'))
        # Warm native routines before ownership/capture, using a disposable
        # stream. Fresh detector/history below must never inherit warm-up data.
        warm = core.VoiceStream(cfg, ref, feat.FrameFeatures, batched=True)
        for _ in range(4): warm.process(np.zeros(960))
        stream = core.VoiceStream(cfg, ref, feat.FrameFeatures, batched=True)
        monitor=None
        if game_rules:
            rules=importlib.import_module('rule_action_monitor')
            if Path(rules.__file__).resolve().parent!=root:
                raise RuntimeError('Wrong rule monitor origin')
            bridge_module=importlib.import_module('game1_rules.voice_event_bridge')
            policy_module=importlib.import_module('game1_rules.voice_policy')
            if any(Path(m.__file__).resolve().parent!=root/'game1_rules' for m in (bridge_module,policy_module)):
                raise RuntimeError('Wrong rule policy origin')
            monitor=rules.RuleActionMonitor()
        if relative_onset and energy_onset:
            raise ValueError('Choose only one onset candidate')
        if energy_onset:
            candidate = importlib.import_module('voice_energy_onset_candidate')
            if Path(candidate.__file__).resolve().parent != root:
                raise RuntimeError('Wrong energy candidate module origin')
            stream.detector = candidate.EnergyOnsetDetector(
                dict(cfg,high_pre_silence_windows=3,shield_on_windows=32,shield_on_ms=500),ref)
        if relative_onset:
            candidate = importlib.import_module('voice_relative_onset_candidate')
            if Path(candidate.__file__).resolve().parent != root:
                raise RuntimeError('Wrong onset candidate module origin')
            stream.detector = candidate.RelativeOnsetDetector(
                dict(cfg, high_pre_silence_windows=3, shield_on_windows=32,
                     shield_on_ms=500), ref)
        outgoing.put(('ready', stream.win, stream.rate, pinned_cpu), timeout=1)
        expected = 0
        while True:
            item = incoming.get(timeout=10)
            if item is None:
                outgoing.put(('done', expected), timeout=1)
                return
            index, raw = item
            if index != expected or not isinstance(raw, bytes) or len(raw) != 7680:
                raise RuntimeError('CPU queue sequence/length invalid')
            start = time.perf_counter()
            events, _ = stream.process(np.frombuffer(raw, dtype='<f8'))
            elapsed = time.perf_counter()-start
            decided=time.monotonic()
            result=('result',index,events,elapsed,decided)
            if monitor is not None:
                result+=(monitor.step(round(decided*1e9),events),)
                result=(result[0],result[1],result[2],time.perf_counter()-start,result[4],result[5])
            outgoing.put(result, timeout=1)
            expected += 1
    except BaseException as exc:
        try: outgoing.put(('error', type(exc).__name__, str(exc)), timeout=.2)
        except Exception: pass


class CpuVoiceStream:
    """Single parent producer. Created BEFORE any hardware lease is acquired."""
    def __init__(self, root, *, startup_timeout=20, worker_cpu=None, relative_onset=False, energy_onset=False, game_rules=False):
        if relative_onset and energy_onset:
            raise ValueError('Choose only one onset candidate')
        ctx = mp.get_context('spawn')  # Never fork a notebook/owned DMA process.
        self.incoming, self.outgoing = ctx.Queue(4), ctx.Queue(8)
        self.process_handle = ctx.Process(target=_worker,
            args=(str(root), self.incoming, self.outgoing, worker_cpu, relative_onset, energy_onset, game_rules), daemon=True)
        self.relative_onset = bool(relative_onset)
        self.energy_onset = bool(energy_onset)
        self.game_rules=bool(game_rules)
        self.rule_rows=[]
        self.submitted, self.received = 0, 0
        self.max_inflight = 0
        self.processing_seconds = 0.
        self.worker_events = []
        self.closed = False
        self.process_started = False
        try:
            _start_in_current_main(self.process_handle)
            self.process_started = True
            message = self.outgoing.get(timeout=startup_timeout)
            if message[0] != 'ready': raise RuntimeError('CPU startup failed: '+repr(message))
            _, self.win, self.rate, self.worker_cpu = message
            if self.worker_cpu != worker_cpu:
                raise RuntimeError('Worker CPU confirmation mismatch')
        except BaseException:
            self.close()
            raise

    def _accept(self, message):
        if message[0] != 'result' or message[1] != self.received:
            raise RuntimeError('CPU response invalid: '+repr(message))
        expected_length=6 if getattr(self,'game_rules',False) else 5
        if len(message)!=expected_length:
            raise RuntimeError('CPU rule response shape invalid')
        _, index, events, elapsed, decided_at = message[:5]
        if expected_length==6:
            if not isinstance(message[5],list) or len(self.rule_rows)+len(message[5])>5000:
                raise RuntimeError('CPU rule trace invalid/too large')
            self.rule_rows.extend(message[5])
        self.processing_seconds += elapsed
        self.received += 1
        for kind, start in events:
            self.worker_events.append(dict(event=kind, feature_start_sample_8k=start,
                input_packet_index=index, decision_monotonic_seconds=decided_at,
                sample_axis_ready_seconds=(start+self.win-1)/self.rate))

    def process(self, samples):
        if self.closed or not self.process_handle.is_alive():
            raise RuntimeError('CPU worker unavailable')
        x = np.asarray(samples, dtype='<f8')
        if x.shape != (960,): raise ValueError('Require exactly one PCM block')
        self._drain()
        try: self.incoming.put_nowait((self.submitted, x.tobytes()))
        except queue.Full: raise RuntimeError('CPU input queue full; discard epoch')
        self.submitted += 1
        self.max_inflight = max(self.max_inflight, self.submitted-self.received)
        return [], None  # Events are collected after DMA stops, not game input.

    def _drain(self):
        while True:
            try: message = self.outgoing.get_nowait()
            except queue.Empty: break
            self._accept(message)

    def finish(self, *, timeout=3):
        # Called only after parent confirms source/DMA stop. No acquisition
        # is blocked while waiting for the final CPU results.
        deadline = time.monotonic()+timeout
        self.incoming.put(None, timeout=min(timeout, .5))
        while time.monotonic() < deadline:
            try: message = self.outgoing.get(timeout=max(.001, deadline-time.monotonic()))
            except queue.Empty: break
            if message[0] == 'done':
                if message[1] != self.submitted or self.received != self.submitted:
                    raise RuntimeError('Incomplete CPU result stream')
                return list(self.worker_events)
            self._accept(message)
        raise TimeoutError('CPU drain deadline; no success/game permission')

    def close(self):
        if self.closed: return
        self.closed = True
        if self.process_started:
            self.process_handle.join(timeout=.2)
        if self.process_started and self.process_handle.is_alive():
            # This child owns only copied bytes and CPU state, never hardware.
            self.process_handle.terminate()
            self.process_handle.join(timeout=1)
        for q in (self.incoming, self.outgoing):
            q.cancel_join_thread()
            q.close()
