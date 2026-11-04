"""Read-only frozen-model WAV verification. No PYNQ or hardware operations."""
from pathlib import Path
import argparse
import hashlib
import importlib
import json
import sys
import time
import wave

FROZEN = {
    'audio_config.json': '367b8f092e6faefc138a9dc61ea108d9693195ad287b99a9abc1377c431a615f',
    'audio_reference.py': '1cc86d1c193d7ffcfa1f44dec4a870cfb4d49669353820230bf54c43707cba3a',
    'pl_feature_stream.py': 'df5955bd30dd51eb397f658f6be31bcd00c702a07f77aae959e2c9cd26a6a255',
    'pl_ps_hybrid_classifier.py': 'a8780e7ee90db4cc66fd41901e459523273824cf2376a39487536cdc60009b93',
    'pl_ps_hybrid_model_2p0s.npz': '081767ea2b14427fe0f4c30f9827f7c67738cecd0277a90d24f6675f97d5c1a2',
}


def predict_wav(path):
    root = Path(__file__).resolve().parent
    for name, expected in FROZEN.items():
        file = root / name
        if file.is_symlink() or hashlib.sha256(file.read_bytes()).hexdigest() != expected:
            raise ValueError('Frozen file mismatch: ' + name)
    path = Path(path).resolve(strict=True)
    with wave.open(str(path), 'rb') as wav:
        if (wav.getnchannels(), wav.getsampwidth(), wav.getframerate(),
                wav.getnframes(), wav.getcomptype()) != (1, 2, 48000, 96000, 'NONE'):
            raise ValueError('Require complete two-second mono signed16 nominal48k WAV')
        if len(wav.readframes(96000)) != 192000:
            raise ValueError('Truncated PCM payload')
    names = ('audio_reference', 'pl_feature_stream', 'pl_ps_hybrid_classifier')
    old = {name: sys.modules.get(name) for name in names}
    old_path = sys.path[:]
    try:
        for name in names:
            sys.modules.pop(name, None)
        sys.path.insert(0, str(root))
        importlib.invalidate_caches()
        classifier = importlib.import_module('pl_ps_hybrid_classifier')
        for name in names:
            if Path(sys.modules[name].__file__).resolve() != root / (name + '.py'):
                raise RuntimeError('Wrong classifier module origin: ' + name)
        started = time.monotonic()
        result = classifier.predict(root / 'pl_ps_hybrid_model_2p0s.npz',
                                    path, root / 'audio_config.json')
        result.update(wav=str(path), wav_sha256=hashlib.sha256(path.read_bytes()).hexdigest(),
                      mode='PS_WAV_DIAGNOSTIC_ONLY',
                      inference_seconds=time.monotonic() - started,
                      hardware_operations=False, game_input_permitted=False,
                      recognition_validated=False, sample_rate_verified=False,
                      freshness_verified=False, latency_validated=False)
        return result
    finally:
        sys.path[:] = old_path
        for name in names:
            sys.modules.pop(name, None)
            if old[name] is not None:
                sys.modules[name] = old[name]


def main(args=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--wav', required=True)
    args = parser.parse_args(args)
    print(json.dumps(predict_wav(args.wav), ensure_ascii=False, indent=2))


if __name__ == '__main__':
    main()
