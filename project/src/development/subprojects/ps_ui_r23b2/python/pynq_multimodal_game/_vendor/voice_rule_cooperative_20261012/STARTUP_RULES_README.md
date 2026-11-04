# Startup stability candidate; gameplay rules fixed separately

Only PLL readiness six-byte read(0x4002,6,.01) gets<=25ms, cappedtoouter
remaining50msdriverstartdeadline. OriginalIICflags,ack,FIFO,owner,pollceiling
andactualPLLreadback remain. No automaticretry/reset/profilewrite. All other
IIC operations,15msDMApoll,5mshealth and recognizerfiles unchanged. Prior
capturecontrol20ms patch retained. Old packages/driverdisk/FPGA unchanged.
ReportedIICfault cleared withuserconfirmedCLEANUP_OK; stillboardproofpending.

Run once onlyafterknownsafepriorcleanup,overlay/Codec loaded,nootherrecording:

```python
%run /home/xilinx/jupyter_notebooks/voice_live_startup_20261012/run_live_voice_test.py --live-2s --reset-audio-dma-before-record --cpu-worker --poll-budget-ms 15 --optimize-receive --pin-cpu --energy-onset-candidate --control-budget --pll-budget
```

Quiet2sstart/stop check; expected100packets,stop/buffers/ownerrelease true.
FailureSTOP,no retry/reload/kernelrestart. Newprofilefields onlywall/threadCPU
ofexistingPLLread; they do notprovewhetherOS vsownerfilesystem vsbusdelay.
Successfulsingletrialnotstabilityacceptance. No gameactions dispatched.

Authoritative localGAME_VOICE_ACCEPTANCE.md: game1attackcooldown0.5s; events
incooldown/5sshield consumednotqueued. Newacceptedohafterrelease refreshes
shield5s; heldohdoesnotrenew; soundoffdoesnotcancelshield. Game3shortsounddoor/
heldsoundlift,no vowelrequirement. Game2/camera/HDMI unchanged.
Gamepolicy local38tests pass; not deployed inVVGorcontinuouslivegameyet.
Do not use arbitraryrapidtwoah recall asgameacceptance. Nextstepsstartup
stabilitythenactualactioncooldown/shieldrefreshcontinuoussession verification.
