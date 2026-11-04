"""Bounded maximum-volume stimulus with endpoint and own-session metering.

Run: .venv/Scripts/python subprojects/volume_response_offline/verified_speaker.py
     --output build/volume-response/speaker-meter-a01.json
Output: exclusive JSON including playback, digital peaks and volume restoration.
Next: correlate with separately recorded board samples; peaks are not sound pressure.
"""
import argparse
import json
import os
import time
from pathlib import Path


class VerifiedSpeaker:
    def __init__(self):
        import comtypes
        from PySide6.QtCore import QCoreApplication
        from PySide6.QtMultimedia import QAudioFormat, QAudioSink, QMediaDevices
        from pycaw.pycaw import AudioUtilities
        from pycaw.api.endpointvolume import IAudioMeterInformation
        self.app = QCoreApplication.instance() or QCoreApplication([])
        device, = (d for d in QMediaDevices.audioOutputs() if 'Senary' in d.description())
        speaker = AudioUtilities.GetSpeakers()
        assert bytes(device.id()).decode() == speaker.id
        self.endpoint = speaker.EndpointVolume
        self.meter = speaker._dev.Activate(IAudioMeterInformation._iid_, comtypes.CLSCTX_ALL, None).QueryInterface(IAudioMeterInformation)
        self.before = dict(scalar=self.endpoint.GetMasterVolumeLevelScalar(), mute=bool(self.endpoint.GetMute()))
        self.receipt = dict(device_id=speaker.id, before=self.before, sessions=[], plays=[])
        fmt = QAudioFormat()
        fmt.setSampleRate(48000)
        fmt.setChannelCount(1)
        fmt.setSampleFormat(QAudioFormat.SampleFormat.Int16)
        assert device.isFormatSupported(fmt)
        self.sink = QAudioSink(device, fmt)
        self.buffer = None
        self.sessions = []

    def pump(self, duration):
        until = time.monotonic() + duration
        while time.monotonic() < until:
            self.app.processEvents()
            time.sleep(.01)

    def _start(self, pcm):
        from PySide6.QtCore import QByteArray, QBuffer, QIODevice
        self.sink.stop()
        self.buffer = QBuffer(self.sink)
        self.buffer.setData(QByteArray(pcm))
        assert self.buffer.open(QIODevice.OpenModeFlag.ReadOnly)
        self.sink.start(self.buffer)

    def prepare(self):
        from pycaw.pycaw import AudioUtilities
        from pycaw.api.endpointvolume import IAudioMeterInformation
        # Establish our audio session with silence before modifying its settings.
        self._start(bytes(96000))
        self.pump(.15)
        own = [s for s in AudioUtilities.GetAllSessions() if s.ProcessId == os.getpid()]
        assert own, 'own playback session missing'
        for session in own:
            vol = session.SimpleAudioVolume
            before = dict(scalar=vol.GetMasterVolume(), mute=bool(vol.GetMute()))
            self.sessions.append((vol, before, session._ctl.QueryInterface(IAudioMeterInformation)))
            self.receipt['sessions'].append(dict(pid=os.getpid(), before=before))
            vol.SetMasterVolume(1.0, None)
            vol.SetMute(False, None)
            assert abs(vol.GetMasterVolume()-1) < 1e-5 and not vol.GetMute()
        self.sink.stop()
        self.endpoint.SetMasterVolumeLevelScalar(1.0, None)
        self.endpoint.SetMute(False, None)
        assert abs(self.endpoint.GetMasterVolumeLevelScalar()-1) < 1e-5 and not self.endpoint.GetMute()

    def play(self, frequency=1000, seconds=1.5):
        import numpy as np
        assert 100 <= frequency <= 5000 and .1 <= seconds <= 3
        t = np.arange(round(48000*seconds))/48000
        envelope = np.minimum(1, np.minimum(t/.01, (seconds-t)/.01))
        pcm = np.rint(32767*np.sin(2*np.pi*frequency*t)*envelope).astype('<i2').tobytes()
        entry = dict(frequency=frequency, seconds=seconds, started_ns=time.monotonic_ns(), samples=[])
        self.receipt['plays'].append(entry)
        self._start(pcm)
        until = time.monotonic()+seconds+.2
        while time.monotonic() < until:
            self.app.processEvents()
            entry['samples'].append(dict(pc_ns=time.monotonic_ns(), endpoint_peak=self.meter.GetPeakValue(), session_peaks=[m.GetPeakValue() for _, _, m in self.sessions]))
            time.sleep(.02)
        entry.update(processed_us=self.sink.processedUSecs(), remaining=self.buffer.bytesAvailable(), error=self.sink.error().value,
                     master_scalar=self.endpoint.GetMasterVolumeLevelScalar(), mute=bool(self.endpoint.GetMute()))
        self.sink.stop()
        assert entry['processed_us'] >= seconds*1e6-1000 and entry['remaining'] == 0 and entry['error'] == 0
        entry['peak_max'] = max(s['endpoint_peak'] for s in entry['samples'])
        assert entry['peak_max'] > .5, 'digital endpoint amplitude insufficient'
        return entry

    def close(self):
        self.sink.stop()
        for vol, before, _ in self.sessions:
            vol.SetMasterVolume(before['scalar'], None)
            vol.SetMute(before['mute'], None)
        self.endpoint.SetMasterVolumeLevelScalar(self.before['scalar'], None)
        self.endpoint.SetMute(self.before['mute'], None)
        after = dict(scalar=self.endpoint.GetMasterVolumeLevelScalar(), mute=bool(self.endpoint.GetMute()))
        self.receipt.update(after=after, restored=after['mute'] == self.before['mute'] and abs(after['scalar']-self.before['scalar']) < 1e-5)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with args.output.open('x', encoding='utf-8') as file:
        record = dict(status='STARTED')
        speaker = None
        try:
            speaker = VerifiedSpeaker()
            record['speaker'] = speaker.receipt
            speaker.prepare()
            speaker.play()
            record['status'] = 'DIGITAL_PLAYBACK_VERIFIED'
        except BaseException as error:
            record.update(status='FAIL', error=repr(error))
            raise
        finally:
            if speaker: speaker.close()
            json.dump(record, file, indent=2)
        print(record['status'], 'peak', speaker.receipt['plays'][0]['peak_max'], 'sessions', speaker.receipt['sessions'])


if __name__ == '__main__':
    main()
