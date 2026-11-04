"""Explicit two-second live diagnostic; reuses original capture setup/cleanup."""
from pathlib import Path
import argparse
import hashlib
import importlib
import importlib.util
import sys

CAPTURE = Path('/home/xilinx/jupyter_notebooks/audio_only_capture_test_dmafix_20261011')
DRIVER_HASHES = {
    'pcm_capture_test.py': '232256061f27528ac246d26676af81cf3112d3aed945da0cf6817d9248141355',
    'audio_import_guard.py': '68c73a9b893b8731c5f50a81ff42fd22ef1b23644e3da1719d758e888d464f7b',
    'voice_pcm_sg.py': '12d00c7571e778b0ffca55156378823eaadc3e69bc1b4b84f18a0944a6db6775',
    'voice_pynq_binding.py': '6b0142bbacf21acc563df1513fc09aa131c800d8c4713f872031607f408bcc5a',
}


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def main(args=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--live-2s', action='store_true')
    parser.add_argument('--rules-18s', action='store_true')
    parser.add_argument('--reset-audio-dma-before-record', action='store_true')
    parser.add_argument('--cpu-worker', action='store_true')
    parser.add_argument('--poll-budget-ms', type=int, choices=(10, 15), default=10)
    parser.add_argument('--profile-poll', action='store_true')
    parser.add_argument('--optimize-receive', action='store_true')
    parser.add_argument('--pin-cpu', action='store_true')
    parser.add_argument('--relative-onset-candidate', action='store_true')
    parser.add_argument('--energy-onset-candidate', action='store_true')
    parser.add_argument('--control-budget', action='store_true')
    parser.add_argument('--pll-budget', action='store_true')
    parser.add_argument('--health-budget', action='store_true')
    parser.add_argument('--cooperative-deadlines', action='store_true')
    options = parser.parse_args(args)
    if options.live_2s==options.rules_18s or not options.reset_audio_dma_before_record:
        raise RuntimeError('Both explicit live/reset flags required; no hardware operations performed')
    if options.rules_18s and not (options.cpu_worker and options.energy_onset_candidate
                                 and options.control_budget and options.pll_budget):
        raise RuntimeError('Rule session requires CPU/energy/control/PLL flags; no hardware operations performed')
    if options.health_budget and not options.control_budget:
        raise RuntimeError('Coordinated health requires control binding; no hardware operations performed')
    if options.cooperative_deadlines and not (options.cpu_worker and options.optimize_receive
            and options.control_budget and options.pll_budget and options.health_budget
            and options.poll_budget_ms==15):
        raise RuntimeError('Cooperative deadline dependencies missing; no hardware operations performed')
    if options.poll_budget_ms == 15 and not options.cpu_worker:
        raise RuntimeError('15ms poll budget requires CPU worker; no hardware operations performed')
    if options.optimize_receive and not options.cpu_worker:
        raise RuntimeError('Receive optimization requires CPU worker; no hardware operations performed')
    if options.pin_cpu and not options.cpu_worker:
        raise RuntimeError('CPU placement requires CPU worker; no hardware operations performed')
    if options.relative_onset_candidate and not options.cpu_worker:
        raise RuntimeError('Onset candidate requires CPU worker; no hardware operations performed')
    if options.energy_onset_candidate and (not options.cpu_worker or options.relative_onset_candidate):
        raise RuntimeError('Energy onset requires CPU worker and no other onset flag; no hardware operations performed')
    if sys.platform != 'linux':
        raise RuntimeError('Run only in the existing PYNQ notebook, not a subprocess')
    root = Path(__file__).resolve().parent
    gate = load('_live_frozen_gate', root/'predict_recorded_wav.py')
    for directory, expected in ((root, gate.FROZEN), (CAPTURE, DRIVER_HASHES)):
        for name, digest in expected.items():
            file = directory/name
            if file.is_symlink() or hashlib.sha256(file.read_bytes()).hexdigest() != digest:
                raise RuntimeError('File mismatch before hardware access: '+str(file))
    names = ('audio_reference', 'pl_feature_stream', 'pl_ps_hybrid_classifier')
    old, old_path = {n: sys.modules.get(n) for n in names}, sys.path[:]
    diagnostic, original_recorder, stream = None, None, None
    driver_module, original_driver_class = None, None
    binding_module, original_binding_class = None, None
    iic_module, original_iic_class = None, None
    affinity = None
    try:
        for name in names:
            sys.modules.pop(name, None)
        sys.path.insert(0, str(root))
        reference = importlib.import_module('audio_reference')
        if Path(reference.__file__).resolve() != root/'audio_reference.py':
            raise RuntimeError('Wrong algorithm origin')
        cfg = reference.load_config(str(root/'audio_config.json'))
        feature_type = load('_live_features', root/'fast_voice_features.py').FrameFeatures
        if options.cpu_worker:
            # Spawn before guard/acquire/start: no inherited audio resources.
            if any(vars(m).get('_HELD_POOLS') or vars(m).get('_HELD_OWNERS')
                   for m in tuple(sys.modules.values()) if m is not None):
                raise RuntimeError('Retained audio resources: no worker or hardware start')
            sys.modules.pop('voice_cpu_worker', None)
            worker = importlib.import_module('voice_cpu_worker')
            if Path(worker.__file__).resolve() != root/'voice_cpu_worker.py':
                raise RuntimeError('Wrong worker origin')
            if options.pin_cpu:
                affinity = load('_capture_cpu_placement', root/'voice_cpu_affinity.py').CurrentThreadAffinity()
            stream = worker.CpuVoiceStream(root,
                worker_cpu=affinity.worker_cpu if affinity is not None else None,
                relative_onset=options.relative_onset_candidate,
                energy_onset=options.energy_onset_candidate,
                game_rules=options.rules_18s)
            if affinity is not None:
                affinity.pin()
                stream.capture_cpu = affinity.capture_cpu
        else:
            stream = load('_live_stream', root/'voice_stream_core.py').VoiceStream(
                cfg, reference, feature_type, batched=True)
        record_live = load('_live_record', root/'live_voice_diagnostic.py').record_live
        # Original guard refuses retained owners/pools before changing imports.
        guard = load('_live_audio_guard', CAPTURE/'audio_import_guard.py')
        guard.prepare(CAPTURE)
        if options.optimize_receive:
            driver_module = sys.modules['voice_pcm_sg']
            original_driver_class = driver_module.VoicePcmSG
            memory_type = sys.modules['voice_pynq_binding'].PynqMemory
            driver_module.VoicePcmSG = load('_receive_candidate',
                root/'voice_receive_optimized.py').build_driver(driver_module, memory_type)
        if options.control_budget:
            driver_module=sys.modules['voice_pcm_sg']
            if original_driver_class is None:
                original_driver_class=driver_module.VoicePcmSG
            binding_module=sys.modules['voice_pynq_binding']
            original_binding_class=binding_module.CaptureBinding
            if options.cooperative_deadlines:
                reader_type=load('_cooperative_reader',root/'voice_cooperative_deadlines.py').build_reader(binding_module)
            else:
                reader_type=(load('_health_budget',root/'voice_health_budget.py').build_reader(binding_module)
                             if options.health_budget else None)
            binding_type,driver_type=load('_control_budget',root/'voice_control_budget.py').build_types(
                binding_module,driver_module.VoicePcmSG,status_reader_type=reader_type,
                control_ceiling=.05 if options.cooperative_deadlines else .02)
            binding_module.CaptureBinding=binding_type
            driver_module.VoicePcmSG=driver_type
        if options.pll_budget:
            driver_module=sys.modules['voice_pcm_sg']
            if original_driver_class is None:
                original_driver_class=driver_module.VoicePcmSG
            iic_module=sys.modules['voice_axi_iic']
            original_iic_class=iic_module.VoiceAxiIIC
            iic_type,driver_type=load('_pll_budget',root/'voice_pll_budget.py').build_types(
                iic_module,driver_module.VoicePcmSG,
                stage_ceiling=.05 if options.cooperative_deadlines else .025)
            iic_module.VoiceAxiIIC=iic_type
            driver_module.VoicePcmSG=driver_type
        if options.cooperative_deadlines:
            driver_module.VoicePcmSG=load('_cooperative_driver',root/'voice_cooperative_deadlines.py').build_driver(
                driver_module.VoicePcmSG)
        diagnostic = sys.modules['voice_capture_diagnostic']
        original_recorder = diagnostic.record_diagnostic
        # Scoped recorder substitution only. Original runner retains identical
        # HWH/Codec/ownership/clean-start/allocation/cleanup/WAV handling.
        def recorder(driver, seconds=2):
            profiler = None
            if options.profile_poll:
                profiler = load('_live_poll_profile', root/'voice_poll_profile.py').PollProfiler(driver)
            return record_live(driver, stream, seconds=seconds,
                poll_timeout=options.poll_budget_ms/1000, poll_profiler=profiler)
        diagnostic.record_diagnostic = recorder
        capture = load('_existing_capture_setup',root/'rule_capture_setup.py' if options.rules_18s
                       else CAPTURE/'pcm_capture_test.py')
        print('LIVE_TEST_PREPARED: wait for LIVE_READY before speaking; no game input.', flush=True)
        capture.record(CAPTURE)
    except BaseException:
        print('STOP: no retry/reload/kernel restart; retain notebook and send complete output.', flush=True)
        raise
    finally:
        try:
            if driver_module is not None and original_driver_class is not None:
                driver_module.VoicePcmSG = original_driver_class
            if binding_module is not None and original_binding_class is not None:
                binding_module.CaptureBinding = original_binding_class
            if iic_module is not None and original_iic_class is not None:
                iic_module.VoiceAxiIIC = original_iic_class
            try:
                if stream is not None and hasattr(stream, 'close'):
                    stream.close()
            finally:
                if diagnostic is not None and original_recorder is not None:
                    diagnostic.record_diagnostic = original_recorder
                # Never unload audio driver modules: they retain faulted DMA resources.
                sys.path[:] = old_path
                for name in names:
                    sys.modules.pop(name, None)
                    if old[name] is not None:
                        sys.modules[name] = old[name]
        finally:
            if affinity is not None:
                affinity.restore()


if __name__ == '__main__':
    main()
