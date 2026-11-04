# Whole capture-chain deadline audit, 2026-10-12

All stages retain fail-closed guards. No cached owner/snapshot, automatic retry,
reset, dropped-packet waiver or relaxed PCM/model/game gates. Python cannot
interrupt native bus hangs or guarantee Linux scheduling. Board stability
remains pending even if all local injected-fault tests pass.

| Stage | Ceiling | Enclosing limit |
| --- | --- | --- |
| Capture enable/disable |20ms |remaining driver start/stop50ms phase |
| PLL six-byte readiness read |25ms |remaining driver start50ms; preflight separate bounded read |
| Live fresh status snapshot |10ms |remaining current poll15ms; never extend that poll |
| Receive packet whole operation |15ms |unchanged |
| Service gap/packet stall |50ms |unchanged, fault entire epoch |
| Worker input/output |4/8 queues |full queue invalidates session, no drop or retry |
| End CPU drain |3s |only after confirmed source/DMA stop |
| Whole18s session |20s watchdog |not permission to exceed per-packet limits |

Startup5ms control fault and PLL10ms read fault occurred before PCM capture.
The later StatusTimeout occurred atpacket573/~11.46s while reading final
snapshot sequence words, inside internal5ms, despite wholepoll elapsed10.708ms
<15ms. Exact OS-vs-MMIO/owner delay source unmeasured. These are related
short wallclock-budget boundaries, not proof of one physical hardware defect
or resource leak. Previous cleanup was user-confirmedCLEANUP_OK.

--health-budget uses original snapshot implementation with an effective budget
min(10ms,remaining enclosing deadline). Dynamic timeout/poll interval restored
after every attempt. Same ABI/capture epoch/request/sequence/repeated sequence,
torn64-bit reads/lossflags/drop/counter regression andfresh snapshot checks.
Full binding ownership before/after snapshot remains; cached snapshots forbidden.
Deadline violations still invalidate epoch, return no usable packet and retain
unsafe buffers. Failure output includes partial historical CPU/rule trace as
NOT acceptance plus snapshot wall/threadCPU times; no extra hardware reads.

Local tests reproduce original5ms false boundary with0.3ms modeled reads,
then validate new bounded snapshot;1000 repeats with no timeout drift;
outer remainder4ms still rejects; torn/drop/ABI/epoch/owner loss/noack rejected.
Original IIC,control,driver/cache/stop andpolicy suites also run. These models
are not physical board/RTL performance tests or a long-run reliability claim.

Recognition/core/model and gamepolicy unchanged. New complete directory
voice_rule_guarded_20261012; use previous18s protocol or simplifiedshield
sequence. Run once only after clean pool/lease, same loaded audiooverlay/Codec:

```python
%run /home/xilinx/jupyter_notebooks/voice_rule_guarded_20261012/run_rules_check.py
```

Expected900packets/stopped/buffers/ownerrelease true. No game dispatch. Error
STOP, retain notebook, send entire output; no repeated capture/reset/reload.
Do not claim cooler/shield/refresh PASS if recognition case not exercised.
Known strict500ms shield-vowel variability and physical freshness/rate/game
latency remain separately unaccepted. Classification thresholds unchanged.
