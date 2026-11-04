# Unified energy-onset candidate (not recognition acceptance)

This independent directory does not replace old ZIPs, BIT/HWH, camera, model,
threshold config or original DMA drivers. No game dispatch. Scope: PS software.

Weak voiced background no longer starts attack age. Eight low-energy phase
decisions128ms establish release and retain a fixed quiet floor until real
energy >=8x floor and originalhigh_power_min. Then one fixed8-window128ms
onset interval permits unchanged spectral/Q/pitch/rise/two-phase confirmation.
Onsets in cooldown are consumed, not delayed until cooldown ends. Continuous
high-energy sound cannot renew onset. Separate oh detector unchanged.
Attacks without an established low-energy release deliberately rejected.
This changes attack timing/release semantics, not just a48ms patch.

14 recorded clips checked together, including both independent double-ah
failures; 4oh/4none preserved. Some attack timestamps change: oldf18 by8ms
earlier. Synthetic variable ramps, sustained sound, five commands, shortgap,
cooldown and Q/spectral/pitch vetoes checked. Local actual spawn tests include
both failures, oh and speech. Small corpus is not arbitrary noise acceptance.

Upload complete ZIP and extract to NEW voice_live_energy_20261012 directory.
First verify failed recording on ARM without touching hardware:

```python
%run /home/xilinx/jupyter_notebooks/voice_live_energy_20261012/replay_onset_wav.py --energy-onset --wav /home/xilinx/jupyter_notebooks/audio_only_capture_test_dmafix_20261011/mic_2s_16b748cef92c4ddab346d34a838f6ae3.wav
```

Expected two attacks at3456/10304, recording-axis0.495875/1.351875s.
CPU timing excludes DMA. Desktop speed is not board performance.
After replay review, separate live check (already loaded audio overlay,
Codec verified and all prior buffers/lease released; no other recording):

```python
%run /home/xilinx/jupyter_notebooks/voice_live_energy_20261012/run_live_voice_test.py --live-2s --reset-audio-dma-before-record --cpu-worker --poll-budget-ms 15 --optimize-receive --pin-cpu --energy-onset-candidate
```

Wait for LIVE_READY; shortah around0.4s and1.3s, silence between. No shouting.
Failure: do not retry/reload/restart kernel; preserve notebook for cleanup.
Expected100packets,2attacks, source stopped/buffers/owner released true. All
game/recognition/freshness/sample-rate/true latency acceptance remains open.
