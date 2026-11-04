"""Causal stateful CPU audio core; no DMA, Codec, PYNQ or game writes."""
import numpy as np


class Preprocessor:
    def __init__(self, cfg, reference, *, decimated_fir=False):
        self.a = float(cfg['dc_block_a'])
        if not 0 < self.a < 1 or (cfg['fs_input'], cfg['fs_processed']) != (48000, 8000):
            raise ValueError('Unsupported streaming format')
        self.weights = self.a**np.arange(256, dtype=np.float64)
        self.carry, self.previous, self.input_count = 0.0, 0.0, 0
        self.coeff = reference.design_fir(float(cfg['fir_fc_hz']), int(cfg['fs_input']),
            int(cfg['fir_taps']), str(cfg['fir_window']), float(cfg['fir_stop_hz']), float(cfg['fir_stop_db']))
        self.history = np.zeros(len(self.coeff)-1)
        self.fft_size = 1 << (960+2*len(self.history)-1).bit_length()
        self.coeff_fft = np.fft.rfft(self.coeff, self.fft_size)
        self.decimated_fir = decimated_fir

    def process(self, samples):
        x = np.asarray(samples, dtype=np.float64)
        if x.ndim != 1 or not 0 < len(x) <= 960 or not np.all(np.isfinite(x)):
            raise ValueError('Require 1..960 finite mono input samples')
        dc = np.empty_like(x)
        for start in range(0, len(x), 256):
            chunk = x[start:start+256]
            d = np.empty_like(chunk)
            d[0] = chunk[0]-self.previous
            d[1:] = np.diff(chunk)
            w = self.weights[:len(chunk)]
            values = w*(self.a*self.carry+np.cumsum(d/w))
            dc[start:start+len(chunk)] = values
            self.carry, self.previous = float(values[-1]), float(chunk[-1])
        extended = np.concatenate((self.history, dc))
        n = len(self.history)
        phase = (-self.input_count)%6
        if self.decimated_fir:
            # Compute only the causal outputs retained by the original 6:1
            # decimator. Read-only strided views avoid copying a FIR matrix;
            # no taps, input samples, or output phases are approximated/skipped.
            windows = np.lib.stride_tricks.sliding_window_view(extended, len(self.coeff))[phase::6]
            output = np.einsum('ij,j->i', windows, self.coeff[::-1], optimize=False)
        else:
            y = np.fft.irfft(np.fft.rfft(extended, self.fft_size)*self.coeff_fft, self.fft_size)
            output = y[n:n+len(dc)][phase::6].copy()
        self.history = extended[-n:].copy()
        self.input_count += len(x)
        return output


class VoiceStream:
    def __init__(self, cfg, reference, feature_type, *, batched=False, decimated_fir=False):
        self.preprocessor = Preprocessor(cfg, reference, decimated_fir=decimated_fir)
        self.feature = feature_type(cfg, fft_autocorrelation=True)
        self.detector = reference.MultiphaseDetector(dict(cfg, high_pre_silence_windows=3,
                                                       shield_on_windows=32, shield_on_ms=500))
        self.win, self.stride, self.rate = int(cfg['win']), int(cfg['feature_stride']), int(cfg['fs_processed'])
        self.buffer, self.next_start = np.empty(0), 0
        self.shield = False
        self.batched = batched

    def process(self, samples, *, audit=False):
        processed = self.preprocessor.process(samples)
        self.buffer = np.concatenate((self.buffer, processed))
        records, events, consumed = [], [], 0
        count = max(0, (len(self.buffer)-self.win)//self.stride+1)
        if self.batched and count:
            windows = np.stack([self.buffer[s*self.stride:s*self.stride+self.win] for s in range(count)])
            features = self.feature.batch(windows)
        else:
            features = [self.feature(self.buffer[s*self.stride:s*self.stride+self.win]) for s in range(count)]
        for feature in features:
            power, zcr, lag, pitch, q, hi, low, valid = feature
            row = self.detector.step(self.next_start, power, q, hi, zcr, pitch, low)
            if row['high_event']:
                events.append(['attack', self.next_start])
            current = bool(row['low_active'])
            if current != self.shield:
                events.append(['shield_on' if current else 'shield_off', self.next_start])
            self.shield = current
            if audit:
                records.append(feature)
            consumed += self.stride
            self.next_start += self.stride
        self.buffer = self.buffer[consumed:].copy()
        return events, (processed, records) if audit else None
