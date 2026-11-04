"""NumPy frame feature candidate. Same equations/gates; no hardware access."""
import numpy as np


class FrameFeatures:
    def __init__(self, cfg, *, fft_autocorrelation=False):
        self.cfg = cfg
        self.fft_autocorrelation = fft_autocorrelation
        self.n = int(cfg['win'])
        self.fs = cfg['fs_processed']
        self.lags = np.arange(max(int(self.fs/cfg['low_band_hz'][1]), 1),
                              min(int(self.fs/cfg['low_band_hz'][0]), self.n-1)+1)
        self.window = (np.hamming(self.n) if cfg['fft_window'] == 'hamming' else
                       np.hanning(self.n) if cfg['fft_window'] == 'hann' else np.ones(self.n))
        self.low_first = int(np.ceil(cfg['low_band_hz'][0]*self.n/self.fs))
        self.low_last = int(np.floor(cfg['low_band_hz'][1]*self.n/self.fs))

    def __call__(self, samples):
        if len(samples) != self.n:
            raise ValueError('Wrong feature window length')
        w = np.asarray(samples, dtype=np.float64)
        w = w-w.mean()
        power = float(np.dot(w, w))/self.n
        zcr = float(np.mean(np.abs(np.diff(np.sign(w))))/2) if self.n > 1 else 0.0
        # One native correlation replaces three Python dot calls for each lag.
        if self.fft_autocorrelation:
            # Zero padding prevents cyclic wrap; retain the same positive lags.
            size = 1 << (2*self.n-2).bit_length()
            spectrum_ac = np.fft.rfft(w, size)
            correlation = np.fft.irfft(spectrum_ac*np.conj(spectrum_ac), size)[self.lags]
        else:
            correlation = np.correlate(w, w, mode='full')[self.n-1+self.lags]
        energy = w*w
        prefix = np.concatenate(([0.0], np.cumsum(energy)))
        suffix = np.concatenate((np.cumsum(energy[::-1])[::-1], [0.0]))
        e1, e2 = suffix[self.lags], prefix[self.n-self.lags]
        eps = float(self.cfg['autocorr_eps'])
        valid = (correlation > 0) & (e1 > eps) & (e2 > eps)
        quality = np.zeros(len(self.lags))
        quality[valid] = correlation[valid]**2/(e1[valid]*e2[valid]+eps)
        index = int(np.argmax(quality))
        q = min(1.0, max(0.0, float(quality[index])))
        pitch_valid = q >= float(self.cfg['q_min'])
        best_k = int(self.lags[index]) if pitch_valid else 0
        pitch = self.fs/best_k if pitch_valid else 0.0
        spectrum = np.abs(np.fft.rfft(w*self.window))
        total = float(spectrum.sum())
        if total > float(self.cfg['spectrum_eps']):
            hi = float(spectrum[int(self.cfg['hi_first_bin']):].sum())/total
            low = float(spectrum[self.low_first:self.low_last+1].sum())/total
        else:
            hi = low = 0.0
        return power, zcr, best_k, pitch, q, hi, low, pitch_valid

    def batch(self, samples):
        """Independent windows already available in one block; no skipped frames."""
        w = np.asarray(samples, dtype=np.float64)
        if w.ndim != 2 or w.shape[1] != self.n or not len(w):
            raise ValueError('Require nonempty matrix of complete feature windows')
        w = w-w.mean(axis=1, keepdims=True)
        energy = w*w
        power = energy.sum(axis=1)/self.n
        zcr = np.mean(np.abs(np.diff(np.sign(w), axis=1)), axis=1)/2
        size = 1 << (2*self.n-2).bit_length()
        ac = np.fft.rfft(w, size, axis=1)
        correlation = np.fft.irfft(ac*np.conj(ac), size, axis=1)[:, self.lags]
        prefix = np.concatenate((np.zeros((len(w), 1)), np.cumsum(energy, axis=1)), axis=1)
        suffix = np.concatenate((np.cumsum(energy[:, ::-1], axis=1)[:, ::-1],
                                 np.zeros((len(w), 1))), axis=1)
        e1, e2 = suffix[:, self.lags], prefix[:, self.n-self.lags]
        eps = float(self.cfg['autocorr_eps'])
        valid = (correlation > 0) & (e1 > eps) & (e2 > eps)
        quality = np.zeros_like(correlation)
        quality[valid] = correlation[valid]**2/(e1[valid]*e2[valid]+eps)
        indices = np.argmax(quality, axis=1)
        q = np.clip(quality[np.arange(len(w)), indices], 0, 1)
        pitch_valid = q >= float(self.cfg['q_min'])
        lags = np.where(pitch_valid, self.lags[indices], 0)
        pitch = np.divide(self.fs, lags, out=np.zeros(len(w)), where=pitch_valid)
        spectrum = np.abs(np.fft.rfft(w*self.window, axis=1))
        total = spectrum.sum(axis=1)
        spectral_valid = total > float(self.cfg['spectrum_eps'])
        hi = np.divide(spectrum[:, int(self.cfg['hi_first_bin']):].sum(axis=1), total,
                       out=np.zeros(len(w)), where=spectral_valid)
        low = np.divide(spectrum[:, self.low_first:self.low_last+1].sum(axis=1), total,
                        out=np.zeros(len(w)), where=spectral_valid)
        return [(float(power[i]), float(zcr[i]), int(lags[i]), float(pitch[i]),
                 float(q[i]), float(hi[i]), float(low[i]), bool(pitch_valid[i]))
                for i in range(len(w))]
