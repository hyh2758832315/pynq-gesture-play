# Startup/stop-only control budget improvement

Original binding gives all identity/owner/request/ack/epoch checks5ms inside
outer50ms start. Reported fault occurred during stopped() identity read before
capture enable, atdriverelapsed37.38ms. Original buffers/lease were retained;
explicit user recovery reset endedCLEANUP_OK. Native Python wallclock deadlines
are not hard-real-time and cannot interrupt a hung MMIO call.

This new directory retains the previous energy-onset recognizer byte-for-byte.
--control-budget selects a scopedCaptureBinding subclass: control deadline is
min(now+20ms,current enclosing driver deadline). No timeout removed; strict
owner,ABI,epoch,request/ack/fault/pollceiling checks unchanged. Health reader
retains5ms. Poll15ms, servicegap50ms, cache/PCM/sequencechecks unchanged.
No automatic recovery, retry, freeing buffers, BIT load or camera/game changes.
Recognized audio is unaffected by this control-only software change.20ms is
an engineering margin, not a proven bound on OS scheduling or a board guarantee.

After uploading/extracting into NEWvoice_live_control_20261012 (not overwrite),
only run if earlier cleanup reportedCLEANUP_OK and audiooverlay/Codec remain
loaded, and no other recording:

```python
%run /home/xilinx/jupyter_notebooks/voice_live_control_20261012/run_live_voice_test.py --live-2s --reset-audio-dma-before-record --cpu-worker --poll-budget-ms 15 --optimize-receive --pin-cpu --energy-onset-candidate --control-budget
```

Remain quiet for this first control-path test. Wait forLIVE_READY and allow2s.
Expected100packets, stopped/buffers/owner releasedtrue; any failure STOP, do
not retry/reload/kernelrestart. Send fullfirstfault andfailureevidence.
No recognition/latency/game acceptance is implied by one successful startup.
Old packages/driverdiskfiles remain unchanged; restored classes after runner,
but original modules retain any failed resources for safe explicit cleanup.
