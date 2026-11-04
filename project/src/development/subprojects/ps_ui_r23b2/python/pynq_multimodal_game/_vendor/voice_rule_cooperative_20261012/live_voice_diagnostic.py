"""Bounded diagnostic consuming an already-owned driver; no hardware binding."""
import time
import json
from collections import deque
import numpy as np


def record_live(driver, stream, *, seconds=2, clock=time.monotonic,
                timer=time.perf_counter, sleep=time.sleep, announce=print, poll_timeout=.01,
                poll_profiler=None):
    if seconds not in (2,18) or driver.state != 'NEW':
        raise ValueError('Require fresh driver and exactly2 or18 seconds')
    if seconds==18 and not getattr(stream,'game_rules',False):
        raise ValueError('18-second session requires CPU rule observer')
    target_packets=seconds*50
    if poll_timeout not in (.01, .015) or (poll_timeout == .015 and not callable(getattr(stream, 'finish', None))):
        raise ValueError('Only10ms or CPU-worker15ms poll budget allowed')
    blocks, costs, events, arrivals = [], [], [], []
    last_poll_start, max_poll_gap, waiting_poll_seconds = None, 0.0, 0.0
    reader, original_read = None, None
    recent_reads = deque(maxlen=32)
    first_fault = None
    driver.live_failure_report = None
    def snapshot_profile():
        return dict(calls=getattr(reader,'calls',None),
            stage_ceiling_ms=None if reader is None else 1000*getattr(reader,'stage_ceiling_seconds',.005),
            last_wall_ms=getattr(reader,'last_wall_ms',None),
            last_thread_cpu_ms=getattr(reader,'last_thread_cpu_ms',None),
            max_wall_ms=getattr(reader,'max_wall_ms',None))
    # Notebook output can block: never print while capture is active.
    announce('LIVE_READY: capture starts now; follow the requested test sound instructions.', flush=True)
    try:
        driver.start(timeout=.05)
        deadline = clock()+seconds+2
        binding = getattr(driver.health, '__self__', None) if hasattr(driver, 'health') else None
        reader = getattr(binding, 'reader', None)
        if reader is not None:
            original_read = reader.read32
            def traced_read(offset):
                value = original_read(offset)
                recent_reads.append((offset, value))
                return value
            # Records only reads the strict reader already performs. No added
            # MMIO, snapshot commands, cached health, or relaxed checks.
            reader.read32 = traced_read
        while len(blocks) < target_packets:
            if clock() >= deadline:
                raise TimeoutError('Live diagnostic incomplete')
            t = timer()
            if last_poll_start is not None:
                max_poll_gap = max(max_poll_gap, t-last_poll_start)
            last_poll_start = t
            packet = (driver.poll_packet(timeout=poll_timeout) if poll_profiler is None
                      else poll_profiler.poll_packet(timeout=poll_timeout))
            poll_seconds = timer()-t
            if packet is None:
                waiting_poll_seconds += poll_seconds
                sleep(.0001)
                continue
            if packet.epoch != driver.epoch or packet.index != len(blocks):
                raise ValueError('Live PCM epoch/index discontinuity')
            if not isinstance(packet.data, bytes) or len(packet.data) != 3840:
                raise ValueError('Incomplete PCM packet')
            words = np.frombuffer(packet.data, dtype='<i4')
            if np.any(words < -32768) or np.any(words > 32767):
                raise ValueError('PCM sign extension invalid')
            processing_start = timer()
            detected, _ = stream.process(words.astype(np.float64)/32768.0)
            processing_seconds = timer()-processing_start
            accepted_at = clock()
            for kind, start in detected:
                events.append(dict(event=kind, feature_start_sample_8k=start,
                    sample_axis_ready_seconds=(start+stream.win-1)/stream.rate,
                    packet_index=packet.index, copied_to_decision_ms=(accepted_at-packet.copied_at)*1000,
                    decision_monotonic_seconds=accepted_at))
            blocks.append(words.astype('<i2').tobytes())
            arrivals.append(packet.copied_at)
            costs.append((poll_seconds, processing_seconds, timer()-t))
    except BaseException as exc:
        first_fault = (type(exc).__name__, str(exc))
        driver.live_failure_report = dict(
            first_fault=first_fault, processed_packets=len(blocks), poll_budget_ms=poll_timeout*1000,
            recent_completed_block_costs_ms=[[v*1000 for v in row] for row in costs[-16:]],
            cost_columns=['poll', 'algorithm', 'whole_iteration'],
            max_poll_start_gap_ms=max_poll_gap*1000,
            completed_poll_seconds=sum(row[0] for row in costs),
            algorithm_seconds=sum(row[1] for row in costs),
            waiting_poll_seconds=waiting_poll_seconds,
            poll_profiles=poll_profiler.reports() if poll_profiler is not None else None,
            snapshot_profile=snapshot_profile(),
            receive_timing=dict(cooperative=getattr(driver,'cooperative_timing',False),
                last_cpu_ms=getattr(driver,'last_poll_cpu_ms',None),last_wall_ms=getattr(driver,'last_poll_wall_ms',None)),
            partial_rule_observations=list(getattr(stream,'rule_rows',[])),
            partial_recognition_events=list(getattr(stream,'worker_events',[])),
            partial_trace_is_acceptance=False,
            recent_existing_capture_reads=[{'offset': hex(o), 'value': hex(v)} for o,v in recent_reads],
            hardware_reads_added=0, game_input_permitted=False,
            note='Historical reads before cleanup, not a coherent new snapshot.')
        raise
    finally:
        if reader is not None and original_read is not None:
            reader.read32 = original_read
        # Same proven DMA-halt -> source-off driver. Never free here.
        try:
            driver.stop(timeout=.05)
        finally:
            if first_fault is not None:
                # Preserve evidence even if stop itself raises. No output is
                # attempted before the bounded stop attempt has completed.
                announce('LIVE_FAILURE_EVIDENCE:', json.dumps(driver.live_failure_report), flush=True)
    if driver.release_safe is not True:
        raise RuntimeError('Live stop unconfirmed: retain pool/owner')
    if hasattr(stream, 'finish'):
        try:
            events = stream.finish(timeout=3)
            for event in events:
                index = event['input_packet_index']
                if not 0 <= index < len(arrivals):
                    raise RuntimeError('Worker event packet index invalid')
                event['copied_to_worker_decision_ms'] = (
                    event['decision_monotonic_seconds']-arrivals[index])*1000
                if event['copied_to_worker_decision_ms'] < 0:
                    raise RuntimeError('Worker decision clock regressed')
        except BaseException as exc:
            # DMA is off, but incomplete CPU output must not produce a success
            # WAV/permission. Keep the original pool/lease recoverable using
            # the same explicit retained-FAULT cleanup workflow.
            if hasattr(driver, '_fail'):
                driver._fail(exc)
            else:
                driver.state, driver.release_safe = 'FAULT', False
            raise
    c = np.asarray(costs)
    pcm = b''.join(blocks)
    values = np.frombuffer(pcm, dtype='<i2').astype(np.float64)
    rule_rows=getattr(stream,'rule_rows',[])
    for row in rule_rows:
        row['seconds_after_first_packet_copy']=row['time_ns']/1e9-arrivals[0]
        row['shield_deadline_after_first_packet_copy']=row['shield_deadline_ns']/1e9-arrivals[0]
    rule_summary=dict(
        attack_requests=sum(bool(r.get('attack_request')) for r in rule_rows),
        cooldown_blocks=sum(r.get('reason')=='attack_blocked_by_cooldown' for r in rule_rows),
        shield_blocks=sum(r.get('reason')=='attack_blocked_by_shield' for r in rule_rows),
        accepted_oh_edges=sum(r.get('event')=='shield_on' and r.get('reason')=='shield_refresh' for r in rule_rows),
        shield_expiries=sum(r.get('kind')=='action' and r.get('event')=='shield_off' for r in rule_rows),
        note='Zero blocked events means that case was NOT exercised, not PASS.')
    return pcm, dict(mode='LIVE_GAME1_RULES_DIAGNOSTIC_ONLY' if seconds==18 else 'LIVE_AUDIO_EVENTS_DIAGNOSTIC_ONLY', packet_count=len(blocks),
        duration_seconds=seconds,rule_observations=getattr(stream,'rule_rows',None),
        rule_summary=rule_summary if seconds==18 else None,
        rule_clock='worker decision monotonic clock; no game dispatch',
        sample_count=len(values), first_index=0, last_index=len(blocks)-1,
        poll_budget_ms=poll_timeout*1000,
        poll_budget_clock='thread CPU' if getattr(driver,'cooperative_timing',False) else 'wall',
        dc=float(values.mean()), ac_rms=float(values.std()), peak=float(np.abs(values).max()),
        clipped_samples=int(np.sum((values == -32768) | (values == 32767))),
        copied_first=arrivals[0], copied_last=arrivals[-1], events=events,
        poll_plus_process_p95_ms=float(np.percentile(c[:, 2], 95)*1000),
        poll_plus_process_max_ms=float(c[:, 2].max()*1000),
        completed_blocks_over_20ms=int(np.sum(c[:, 2]>.02)),
        algorithm_seconds=float(getattr(stream, 'processing_seconds', c[:, 1].sum())),
        parent_submit_or_processing_seconds=float(c[:, 1].sum()),
        cpu_worker_used=hasattr(stream, 'finish'),
        relative_onset_candidate=bool(getattr(stream, 'relative_onset', False)),
        energy_onset_candidate=bool(getattr(stream, 'energy_onset', False)),
        capture_control_budget_ms=1000*getattr(
            getattr(getattr(driver,'set_capture',None),'__self__',None),
            'control_budget_seconds',.005),
        pll_startup_read_wall_ms=getattr(getattr(driver,'pll_transport',None),'pll_last_wall_ms',None),
        pll_startup_read_thread_cpu_ms=getattr(getattr(driver,'pll_transport',None),'pll_last_thread_cpu_ms',None),
        capture_cpu=getattr(stream, 'capture_cpu', None),
        worker_cpu=getattr(stream, 'worker_cpu', None),
        poll_profiles=poll_profiler.reports() if poll_profiler is not None else None,
        snapshot_profile=snapshot_profile(),
        receive_timing=dict(cooperative=getattr(driver,'cooperative_timing',False),
            max_cpu_ms=getattr(driver,'max_poll_cpu_ms',None),max_wall_ms=getattr(driver,'max_poll_wall_ms',None),
            note=('CPU work budget15ms; source hard wall/service limit50ms;20ms target still reported'
                  if getattr(driver,'cooperative_timing',False) else 'Legacy wall-clock receive budget')),
        worker_max_inflight_packets=getattr(stream, 'max_inflight', None),
        completed_poll_seconds=float(c[:, 0].sum()),
        waiting_poll_seconds=waiting_poll_seconds, max_poll_start_gap_ms=max_poll_gap*1000,
        stopped_confirmed=True, nominal_sample_rate=48000,
        processing_during_capture=True,
        source_onset_to_response_latency_measured=False,
        note=('Worker decision clock is not measured microphone-onset latency; events printed after stop.'
              if hasattr(stream, 'finish') else
              'Copied-to-decision excludes source acquisition/queue delay; events printed after stop.'),
        sample_rate_verified=False, freshness_verified=False,
        recognition_validated=False, latency_validated=False, game_input_permitted=False)
