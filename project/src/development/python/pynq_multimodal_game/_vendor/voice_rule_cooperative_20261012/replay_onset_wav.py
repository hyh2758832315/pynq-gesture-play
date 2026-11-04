"""Exact-path offline candidate WAV replay. No PYNQ, DMA or Codec operations."""
from pathlib import Path
import argparse
import hashlib
import importlib.util
import json
import wave
import time
import numpy as np


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def replay(path, *, energy_onset=False):
    root = Path(__file__).resolve().parent
    gate = load('_offline_frozen_gate',root/'predict_recorded_wav.py')
    for name,digest in gate.FROZEN.items():
        if hashlib.sha256((root/name).read_bytes()).hexdigest()!=digest:
            raise ValueError('Frozen file mismatch: '+name)
    reference = load('_offline_reference',root/'audio_reference.py')
    core = load('_offline_core',root/'voice_stream_core.py')
    feature = load('_offline_feature',root/'fast_voice_features.py')
    candidate = load('_offline_onset',root/('voice_energy_onset_candidate.py' if energy_onset
                                         else 'voice_relative_onset_candidate.py'))
    path = Path(path)
    with wave.open(str(path)) as w:
        if (w.getnchannels(),w.getsampwidth(),w.getframerate(),w.getnframes())!=(1,2,48000,96000):
            raise ValueError('Require one mono16 48k two-second recording')
        x = np.frombuffer(w.readframes(96000),dtype='<i2').astype(float)/32768
    cfg = reference.load_config(str(root/'audio_config.json'))
    stream = core.VoiceStream(cfg,reference,feature.FrameFeatures,batched=True)
    detector_type = candidate.EnergyOnsetDetector if energy_onset else candidate.RelativeOnsetDetector
    stream.detector = detector_type(dict(cfg,
        high_pre_silence_windows=3,shield_on_windows=32,shield_on_ms=500),reference)
    events, costs = [], []
    for start in range(0,len(x),960):
        begun = time.perf_counter()
        rows,_ = stream.process(x[start:start+960])
        costs.append((time.perf_counter()-begun)*1000)
        events.extend(dict(event=kind,feature_start_sample_8k=s,
            sample_axis_ready_seconds=(s+stream.win-1)/stream.rate) for kind,s in rows)
    return dict(mode='OFFLINE_ENERGY_ONSET_REPLAY_ONLY' if energy_onset else 'OFFLINE_RAMP_FIXED_REPLAY_ONLY',wav=str(path),
        wav_sha256=hashlib.sha256(path.read_bytes()).hexdigest(),events=events,
        attack_count=sum(e['event']=='attack' for e in events),
        block_p95_ms=float(np.percentile(costs,95)),block_max_ms=max(costs),
        timing_excludes_dma=True,hardware_operations=False,capture_started=False,
        game_input_permitted=False,recognition_validated=False,latency_validated=False)


if __name__=='__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--wav',required=True)
    parser.add_argument('--energy-onset',action='store_true')
    options=parser.parse_args()
    print(json.dumps(replay(options.wav,energy_onset=options.energy_onset),indent=2))
