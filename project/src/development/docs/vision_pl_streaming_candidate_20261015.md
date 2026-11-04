# R310-R317 Live owner and sensor checkpoint

Existing sudo -n verified live UID/EUID0 on the frozen board Python3.10.4.
Frozen R218 ZIP identity binds all639 deployed files, all SHA match. Actual
BUILD0xC0060900 and referenced bit/HWH pair verified under simultaneous
c6i/audio locks with CLEAN journal and no business process.

Owned audit found GPU upload MM2S idle but RS1/Halted0. Candidate
C6IVideoSink.close now stops when inflight OR running, and preserves buffer
and session on stop/Halted failure. Three new tests plus existing close
case4PASS; related video/shell/agent regression157PASS. Candidate fix is not
deployed over frozen R218. Single normal RS-clear at exact completed SG0
state verified0x11003 -> 0x11002/readback, all six DMA directions now halted,
no reset or new transfer.

Sensor request used original XILINX_XRT=/usr bootstrap and existing PYNQ
AxiIIC under both owner locks, without Overlay construction/download.
Actual chip0x5640, register0x3008 before0x02/requested0x42/readback0x42;
one three-byte state write, all nine SCCB operation counts exact. Sensor
left in standby; no automatic resume. DMA, journal and PYNQ state unchanged
after request, both locks released. No sensor helper copied over frozen
deployment; independent candidate compiled in memory with source SHA binding.

STANDBY_REGISTER_VERIFIED remains narrower than physical source quiescence.
PCLK cessation and prior video fault settlement/source-domain barrier,
new functional BD/MMIO/capability/driver and DMA/DDR/cache/owner epoch
lifecycle remain pending. source_quiescent=false, epoch_release_ready=false,
NOT_PASSED / board_pending=true / release_ready=false. R312 halt failure,
R315 runtime discovery failure, R316 obsolete source path, and R317 initial
local CRLF guard failure remain original recorded facts, not overwritten.

# Vision PL streaming candidate: feasibility gate

## R226 independent hardware authorization

On 2026-10-15 the user authorized an independent PL candidate with a new
BUILD identity, capability declaration and driver mapping. Frozen BUILD
0xC0060900, its sealed projects, bitstreams and R218 board evidence stay
unchanged. Candidate registration and board deployment remain gated by
numerical, interface, implementation and safety validation.

The first implementation hypothesis is that removing the unused seeded
return branch preserves every retained GPU, camera and audio connection
and address. The first discriminator is a native BD contract comparison:
only declared return cells, their interfaces and memory mapping, associated
interconnect configuration and the new BUILD may differ. A passing BD
comparison is not evidence of routed resource savings or fusion acceptance.
Visual streaming and audio acceleration remain subsequent, separate edits.

Date: 2026-10-15. Status: RESOURCE_CANDIDATE_ROUTED_CAPTURE_OFFLINE_VERIFIED_INTEGRATION_PENDING. This is a new
candidate specification, not a change to deployed BUILD 0xC0060900.
The sealed baseline, hardware ABI, owner rules, audio deadlines, queues,
no-drop and no-replay requirements remain unchanged.

## R238-R242 implementation results

The independent resource-only 0xC0060A00 candidate is routed. After the
baseline postroute Explore step, setup/hold are +0.028/+0.050ns, all65970
routable nets are routed, and all four bus-skew constraints meet timing.
Final use:29604LUT,44900FF,12613Slice(94.83%),87BRAM,14DSP,1960 control sets.
Against frozen0900's final routed12918Slice:305 fewer Slice,
687 free versus382. These figures are measured final physical use, not
hierarchical LUT sums. Remaining42 methodology warnings and external
input/output timing boundaries are retained in the bring-up record.

R239 verifies all37 external source identities against sealed histories.
Area2x2 and binary dilate9 RTL units pass independent numerical/protocol
simulation; dilate9 matches board4.5.4 masks, including continuous-valid
full frames and reset/fault cases, using86LUT/119FF/1RAMB18/0DSP.
R245 extends Gaussian model agreement to48 board images/1844936pixels
across six sizes including2x2 and high-frequency binary patterns. Gaussian
RTL passes the same six-size protocol/numerical regression with2073600
full-size output pixels. A preserved first version had -3.935ns estimated
100MHz setup; pipelining retains exact numerics and raises the fresh
register-to-register synthesis estimate to+2.282ns. Final unit resources:
222LUT/109FF/1RAMB36/0DSP/8control sets. This is an unplaced estimate,
not a route or external-IO signoff. R250 subsequently verifies real
dilate9->Gaussian against10 board images, alongside the full Gaussian
regression. R252 verifies an atomic-fork XPM FIFO raw/filtered pair unit:
691200 full-size pairs, high-water3852 entries under tested768cycle stalls.
Combined synthesis is330LUT/306FF/2.5BRAM/0DSP/17CS, internal100MHz
register-to-register estimate+2.315ns;24 native XPM unused-logic/port
warnings are preserved and classified. Pair framing/config identity,
uninterrupted-camera buffering,
new functional BUILD/driver and full board fusion remain pending.
No new bitstream, deployment or production registration is claimed.

R258-R262 connects exact area2x2 -> sealed HSV -> raw/filtered pair in a
new axis_rgb_mask_frontend wrapper. Input RGB low byte is R; the wrapper
swaps R/B for the existing BGR primitive. Accepted input SOF snapshots
thresholds/frame/config/epoch. The next frame cannot change HSV thresholds
until the previous reduced EOF has entered HSV; four ordered contexts keep
output identity through overlapping frames. Geometry is static per instance.
This four-entry context queue is independent of audio/DMA/CPU queues.

BoardOpenCV4.5.4 generates24 complete frontend references across six input
sizes up to1280x720. R260 compares922468 gold raw/filtered pairs; with
overlap/protocol/reset tests,37 frames/923648 pairs pass. MissingSOF,
earlyEOL, missingEOL, unexpectedSOF reject with sticky fault; midframe
reset clears context and a valid recovery frame passes. R261 combined
synthesis:825LUT/650FF/4BRAM/2DSP/27CS/0latch; internal100MHz unplaced
estimate+0.318ns.88 native warnings are retained and classified (64 fixed
geometry bits,2 XPM unused FF,22 XPM optional ports). The standalone top
exposes internal ports, not a new package pinout or bitstream target.
R262 seals129 entries, including the preserved first coverage-assertion
failure and its corrected regression. No production primitive was changed.

The actual shared BD still connects video_in -> demosaic -> RGB frame_dma,
and PS moments_dma MM2S -> SKN6 -> S2MM separately. A lossless RGB split,
versioned dual-mask packet capture and bounded non-stoppable-camera budget
are not yet connected. New functional BUILD/driver, full route and board
fusion remain required. Full frontend offline verification does not close
those gates or establish measured PS CPU savings.

R263 post-stop recheck verifies seven archives/422 entries, original3369
frozen files,37 external sources and zero known Vivado PIDs. Its first
process-exit gate failed immediately after stop; the unchanged gate passed
after an exact-PID inspection found no process. Original failure and all
sealed histories remain preserved. Board_pending=true/release_ready=false.

R255 adds actual overlapping black/white frames at two sizes: the second
input SOF is accepted before the first output EOF under a6000cycle tail
stall.1152000 full-size pairs pass; observed raw high-water remains3852.
R257 post-stop checkpoint verifies six archives/293 entries, original3369
frozen files,37 external sources and zero known Vivado PIDs. Resource and
unit evidence is closed; functional camera/BUILD/driver and board acceptance
remain pending. The observed lead bound is not a universal camera budget.

## R264-R270 Capture Interface

The independent axis_rgb_dual_mask_capture now connects RGB fork -> exact
frontend -> DMS1 packet, while retaining the original RGB preview stream.
Accepted capture SOF freezes144bit thresholds/frame/config/epoch before
the fork register. Each RGB word reaches both branches exactly once with
independent ready; frame_fault blocks new capture until common reset.
This is an internal backpressurable AXIS module, not a physical pin top.

R267 verifies24 frames across the same six board-reference sizes:
922468 mask pairs and3689872 original RGB pixels match byte-for-byte,
with independent RGB/packet stalls and disturbed post-SOF configuration.
R268 reruns the original frontend37-frame/923648-pair gold/protocol/reset
regression unchanged in behavior. R270 adds packet half-pair and stalled
full-word reset, then reruns12 packets/460826 normal pairs plus six fault
packets within that12-packet total. Python independently checks CRC32 and
all actual exported masks; all37 scoped decoder tests pass.

R269 combined synthesis at10ns:1378LUT/1070FF/4BRAM/2DSP/36control sets,
0latch. Relative to the frontend-only unit:553LUT/420FF/9control sets more,
with unchanged BRAM/DSP. These are separately synthesized unit differences,
not final physical savings or full-candidate use. The ten worst internal
paths meet an unplaced estimate of+0.318ns;242 exposed logical IO exceed
125 package IO and intentionally require internal BD wiring before any
physical implementation. Full24 XPM warnings remain retained/classified.

### DMS1 Version1 Wire Contract

All words and payloads are little-endian. Two pixels occupy each u32:
bits7:0 raw0,15:8 filtered0,23:16 raw1,31:24 filtered1. Raw is0/255;
filtered is any uint8. An odd last pixel has zero upper16bits.
TKEEP=1111 on every word. TLAST is asserted only on trailer word15.
Output geometry is static, at most640x360, with no changes to sensor mode.

| Trailer u32 | Value |
| --- | --- |
| 0 | magic0x31534d44 (bytes DMS1) |
| 1 | 0x00100001: version1, trailer16words |
| 2,3,4 | frame_id, config_id, epoch, supplied by caller |
| 5 | (height << 16) or width |
| 6,7 | actual accepted pixels, padded payload byte length |
| 8 | status: framing1, nonbinary raw2, context mismatch4, upstream fault8 |
| 9,10 | six threshold bytes Hlo,Hhi,Slo,Shi,Vlo,Vhi, remaining16bits zero |
| 11 | pair format0x00010802 |
| 12,13,14 | reserved zero |
| 15 | CRC32/ISO-HDLC, standard zlib.crc32 of all preceding packet bytes |

An error may produce a shorter explicit error packet; raw faults do not
get repaired into a successful frame. The pure decoder requires exact
expected geometry/identity/thresholds, status0, exact byte count, CRC,
padding and binary raw; it returns independent ordinary-memory arrays.
The caller supplies the actual received DMA length, not allocation capacity,
and is responsible for expected frame sequencing/epoch and stale-frame
rejection. CRC is corruption detection, not authentication. No automatic
retry, dropped-frame success, lifecycle policy or new hardware BUILD is
introduced. SKN6 parsing and existing registered capabilities stay intact.

### Continuous Camera Admission Gate

At1280x720, one RGB frame is2764800B and a640x360 DMS1 frame is460864B
(460800B payload+64B trailer). Total retained RGB plus masks is3225664B
per frame, before DDR/AXI overhead. Multiplication by actual FPS is only a
bandwidth lower bound, not a measured sustainable rate.

Let A(t) count sensor-origin RGB arrivals and S(t) count pixels accepted by
both fork branches, in the same clock/time domain. Necessary usable buffer
capacity is at least sup_t(A(t)-S(t)), including CDC margins and existing
occupancy. A stall of T active pixel cycles at input rate R alone needs
ceil(R*T) extra slots; blanking and sustained service must also be bounded.
Average throughput alone does not bound backlog. Raw-mask pairing FIFO
capacity is for filter alignment and cannot be credited as RGB CDC storage.

The shared BD creates asynchronous video_in without an explicit FIFO-depth
override and currently connects demosaic directly to RGB VDMA. Its actual
configured depth, actual sensor PCLK/active/blanking arrival envelope,
demosaic/drain service, and guaranteed worst RGB-VDMA/mask-S2MM/PS rearm
stall are not established by the current offline project. Unbounded downstream
stall admits unbounded backlog for a free-running sensor; no finite FIFO
can provide an unconditional no-drop guarantee. Admission remains BLOCKED
until those bounds and an autonomous receive/lifecycle strategy are verified.
Finite simulation source stalls are observations, not a substitute bound.
No silent frame dropping, rate reduction, queue-size change or timing waiver
is used. Functional BD/BUILD/driver, full route, board fusion and measured
CPU savings remain pending; board_pending=true/release_ready=false.

## R272-R276 Actual Configuration and Source Fault Gate

Read-only generated-HWH audit now verifies the retained camera parameters:
Video-In C_ADDR_WIDTH10/async1/one pixel per clock, RGB VDMA3frame stores/
512line-buffer depth, mask DMA SG0. The1024-entry address space is not a
measured usable FIFO capacity; CDC margin/initial fill remain unestablished.
VDMA frame stores are not a consumer-owned no-overwrite queue. Generated
FCLK0 is100MHz; generated FCLK1 is23.809525MHz versus requested24MHz.
Input PCLK74250000Hz appears only as HWH metadata, not a sensor measurement.
Audit verifies configuration only and always retains admission=false.
Actual HWH SHA and exact values are in r272-capture-config-audit-final.json.

Video-In overflow/underflow have no connections in the retained HWH.
[PG043 Common Interface](https://docs.amd.com/r/en-US/pg043_v_vid_in_axi4s/Common-Interface)
defines overflow synchronous to vid_io_in_clk and underflow synchronous to
aclk. [PG043 Buffer Requirements](https://docs.amd.com/r/en-US/pg043_v_vid_in_axi4s/Buffer-Requirements)
requires enough buffering for downstream service; clock ratio alone is
conditional on downstream accepting the video rate. These references do
not establish actual sensor timing or DDR/PS worst-case service in this project.

The independent capture wrapper now has mandatory source_fault input in
the ACLK domain. A high sample latches fault until common reset, blocks new
capture inputs, and passes upstream error to DMS1. Existing accepted RGB
may drain. Partial data uses status8, not a fabricated successful frame.
Completed packets already serialized cannot be retroactively edited; a
future driver must check sticky source status and invalidate the affected
capture epoch before delivering data. That MMIO/epoch driver is pending.
Do not tie source_fault low in real hardware or directly wire raw asynchronous
overflow to it. The gold-only test ties it low intentionally. Real integration
requires event-preserving overflow CDC, coordinated reset/rearm and verified
fault/status observation; no such crossing is claimed by this unit test.

R273 injects a one-cycle ACLK fault after one accepted mask pair; sticky
stop, explicit partial-packet status8/CRC, stall stability, RGB drain and
common-reset full-frame recovery pass. Python independently verifies both
packets. R274 reruns24 board-gold frames:922468 mask pairs and3689872 RGB
pixels unchanged. R27565 scoped tests pass without skips, including HWH
hierarchy/missing/changed/conflicting parameters and actual exported bytes.
R276 fresh10ns synthesis:1378LUT/1071FF/4BRAM/2DSP/37control sets/0latch,
internal unplaced worst estimate+0.318ns. This supersedes R269 only for the
modified wrapper:one additional FF/control set, unchanged LUT/BRAM/DSP.
Full24 native XPM warnings remain; full candidate route remains pending.
Actual PCLK/arrival envelope, bounded autonomous receive and epoch lifecycle
remain the controlling camera-admission gates. No new BUILD, BD connection,
bitstream, sensor change, board load or fusion success is claimed.

## R278-R283 Video Fault Event Retention and Common Reset

Independent vision_source_fault_cdc now preserves video-clock overflow
as a source-domain sticky bit and synchronizes that level through three
ASYNC_REG stages into ACLK. ACLK underflow is immediately visible and
sticky separately; fault_status exposes the two causes, not an MMIO ABI.
Both local resets use XPM_CDC_ASYNC_RST with asynchronous assertion and
three-stage synchronous release from one common_aresetn. There is no
destination-only clear. Video monitor armed crosses another three-stage
chain; capture_aresetn releases the ACLK capture only after both domains
have progressed. It is not a video-domain reset or runtime clock-loss
detector. The real sensor/Video-In must remain quiescent until arming,
with domain-safe reset release and coordinated owner lifecycle.

Three independent clock ratios/72scenarios pass short pulses, repeated
events, either clock stopped, resets while stopped, pre-arm event retention,
combined causes and recovery. Real capture/DMS1 simulation accepts a4ns
video-clock pulse: explicit status8 packet, two accepted pairs, correct CRC,
RGB drain and clean full-frame recovery. Extra pairs during synchronization
latency are expected, not lost or relabelled as a successful frame. The
original direct-fault fixture also reruns to a new output directory. All67
scoped software tests pass without skips, using independent zlib CRC and
the unchanged decoder on old direct/new CDC/new direct exports.

Fresh isolated synthesis6LUT/15FF/6control sets/0latch/0BRAM/0DSP, native
0warnings. Detailed final CDC:2CDC-3 Info/2CDC-9 Info, all depth3 and no
CDC Warning/Critical. check_timing has0missing clocks/0unconstrained internal
endpoints/0ordinary missing input delays/0missing output delays; the one
explicit common_aresetn false-path reset remains MEDIUM/no_input_delay.
Synthetic20ns video/10ns ACLK and zero-delay port associations validate unit
structure under stated assumptions, not actual sensor timing or board IO.
Initial R282 reports remain immutable; R283 port-associated reports/DCP
are separate. Initial R283 entry-identity failure and its exact probe are
retained; the corrected entry has passed without changing RTL/CDC gates.
Report-stage generic multi-clock warning remains, with explicit asynchronous
groups confirmed in actual clock interaction. No warning suppression.

Physical metastability margin and real BD/reset wiring, status MMIO/epoch
driver, sensor arrival/usable buffer/bounded receiver service, new functional
BUILD/capability and complete route/board fusion remain pending. Completed
packets before delayed fault visibility still require affected-epoch rejection
by the future driver. The existing capture wrapper and frozen builds stay
unchanged; connection currently exists in verification only.

## R285-R288 Read-Only Status and Single-Packet Epoch Quarantine

The independent axi_vision_capture_status candidate presents a read-only
AXI-Lite interface, with independent AW/W consumption and SLVERR on all
writes. No clear, epoch write or software seal command is supported. Full
12bit read decode rejects unaligned/unknown offsets without aliases; accepted
read responses remain stable while backpressured, even if a fault arrives.

| Offset | Read Value |
| --- | --- |
|0x00|VST1 interface magic0x31545356|
|0x04|ABI0x00010000|
|0x08|bit0 ready,bit1 sealed,bit2 any fault; other bits zero|
|0x0C|sticky causes:bit0 overflow,bit1 underflow,bit2 capture/protocol|
|0x10|epoch held at first monitor-ready sample after common reset|

All inputs belong to ACLK. Epoch change or loss of monitor-ready after arming
sets sticky protocol fault; even restored identity/readiness cannot clear it.
The block must share coordinated owner reset with CDC/capture. VST1 magic
is an interface identity, not a registered hardware BUILD or capability.
R28566reads/11rejected writes/10snapshots pass AXI backpressure, independent
AW/W arrival, reset-interrupted transactions and late fault cases. The60
actual exported read values are independently parsed in software.

CaptureEpochStatus and read_capture_epoch_status check interface identity,
reserved bits/types/fault consistency and epoch-before/after equality.
DualMaskEpochGate is a single-owner single-packet quarantine helper: stage
decodes privately and returns no frame; unsealed release returns None;
late fault, identity change or any stage/status/decode error permanently
invalidates the object; successful sealed release delivers once. There is
no overwrite, retry of a failed parse or replay within that object. This
is not a global multi-frame sequence manager or a new Agent/DMA queue.
Original decode_dual_mask wire/numerical behavior stays unchanged.

R286100tests pass/no skips, including33new gate/register cases and actual
RTL snapshots. A CRC-correct staged packet is rejected when the fault arrives
later, including a later seal with fault retained; fresh reset epoch recovers.
The adapter accepts a supplied read32 callable; no physical MMIO address,
Overlay allocation or ownership claim is introduced into the pure helper.

The release condition requires a trusted epoch_sealed input from a future
owner controller: source quiescent, accepted streams/DMA drained and an
explicit source-domain barrier returned after prior fault events are visible.
That controller is still pending. Testbench-generated seals prove consumer
behavior only. Real hardware keeps sealed false until that proof exists;
two clean reads, arbitrary waiting, CRC or DMA completion are insufficient.
This condition is essential because faults can still be crossing CDC after
an otherwise complete packet. Full functional BUILD/capability/driver/BD,
source/service budget and autonomous lifecycle remain pending.
The single owner must enforce non-reused epoch identity across resets and
stop before uint32 wrap, verify BUILD/HWH/instance identity independently,
and serialize reads/delivery against lifecycle changes. The helper does not
establish owner identity, prevent reset ABA by itself or provide global replay
tracking across newly created gate objects. Real integration must enforce
these requirements in addition to the source-domain sealing barrier.

R288 fresh isolated synthesis61LUT/73FF/4control sets/0latch/0BRAM/0DSP,
internal10ns unplaced estimate+6.010ns; check_timing all12categories zero
with analysis-only synchronous port assumptions. Native100warning messages
are fully retained (4constant-SLVERR,96unused read-only write-input reports).
R287 original invalid clock-input-delay warning and API-topic lookup error
are retained in project facts; corrected independent build has identical
netlist checksum and no clock-delay warning. No warning suppression or
full-candidate physical-resource inference is made.

## R290-R293 Explicit Epoch Fence

vision_epoch_fence reuses the fault monitor and adds a single request held
until coordinated reset, video-domain source-quiescence confirmation and
mutually exclusive sticky clean/fault response rails. Each rail crosses
through its own3FF ASYNC_REG chain, so a clean acknowledgement cannot race
an independently synchronized fault payload. Overflow sampled in the same
video cycle as the reply selects fault, including previously sticky events.
ACLK asserts sealed only after a clean reply, pipeline_drained, dma_drained
and no sticky faults. A withdrawn drain after seal locks protocol fault;
withdrawn source quiescence is recorded in the source domain and synchronized.
No response is generated while the source clock is stopped; common reset
asynchronously cancels pending requests/responses even with stopped clocks.

These are owner contracts: source_quiescent means the source is permanently
stopped for this epoch, all prior source-domain fault events have resolved,
and the promise remains held until common reset. It is not blanking or
!TVALID. Pipeline drain covers all accepted internal work, not idle outputs;
DMA drain covers all accepted memory operations and ownership, not TLAST.
Real producers for these promises remain pending. A future fault violating
the stop promise cannot revoke a frame already delivered under that promise.
The fence generates seals from these modeled inputs in tests; real BD
continues to keep seals disabled until the real owner contracts are met.
Non-reused epoch and serialized verified-instance ownership remain required.

R29178scenarios/3clock ratios pass source stop, in-flight reset, both clock
stalls, prior/same-reply/late faults, both independent drains and sticky
withdrawals. Direct connection to the existing AXI status bank exports
15snapshots/90read values; three Python cases feed them through the unchanged
status parser and packet gate using a synthetic CRC-valid DMS1 packet.
The resulting103related tests pass with no skips. R290 first failure was a
testbench same-edge/delta-cycle observation race; original8files are retained,
RTL unchanged and the same safety predicate passes with1ps sample settling.
Original multiline terminal stdout was UNKNOWN; existing103test JUnit was
independently verified rather than overwritten or silently rerun.

R293 fence+monitor standalone synthesis20LUT/38FF/12control sets/0latch/
0BRAM/0DSP, internal unplaced setup+7.295ns; native0warnings. CDC-3 Info6/
CDC-9 Info3 all depth3, no CDC warnings. Ordinary clock/IO/internal timing
coverage complete; common asyncreset falsepath MEDIUM remains explicit.
Analysis10ns/20ns clocks/zeroport delays are not physical sensor constraints.
No additive full-candidate LUT/control-set savings or physical signoff inferred.

NEXT: implement authoritative quiescence/drain producers and owner reset/
epoch lifecycle, then functional BUILD/BD/MMIO/driver/fullroute/board tests.
Whole-system NOT_PASSED, board_pending=true, release_ready=false.

## R304-R308 Explicit Sensor Standby Primitive

Candidate-only board/pynq_z2/ov5640_source_control.py exports
request_sensor_standby(iic). It reads OV5640 register0x3008, refuses reset
bit7, preserves existing bits while setting software standby bit6, performs
one write and exact readback. Every address/data send and receive must have
the exact integer byte count; short transfers/exceptions/mismatch fail
without retry. Existing camera startup/owner paths remain unchanged. The
successful receipt is STANDBY_REGISTER_VERIFIED with source_quiescent=false
and epoch_release_ready=false. Register acknowledgement alone is not source
fault settlement, PCLK liveness, a source-domain barrier or owner release.

R304 original attempt changed the verified camera whole-file SHA and correctly
failed1of82tests; exact failed source/test/checker/receipt5items are preserved.
R305 moves the primitive out, restores original camera SHA B79C5735EA5C81B0EA4A95E805AEF3CDDF45D221BBD1906D76326D79B9E2E253
without changing the verifier, and passes82tests including20new short-transfer/
exception/readback/reset/CFFI-buffer cases. This tests software transports,
not real SCCB timing or a physical sensor transition.

R306/R307 only read SSH metadata. Board host pynq/uid1000 is reachable and
neither known lock inode has a kernel holder at probe time. The audio journal
read returns PermissionError and CLEAN remains unknown. Existing owner also
requires root; its default open downloads Overlay. Real SCCB acceptance is
BLOCKED until operator-authorized privileged journal/atomic dual-lock/active
bit-HWH-BUILD/halted-DMA checks permit an explicitly controlled attach. No
elevation retry, candidate upload, PYNQ import, Overlay download or register
write occurred. Pylance syntax capability search returned0tools; actual
pytest parsing/imports and editor diagnostics supply the available evidence.
Whole-system NOT_PASSED/board_pending=true/release_ready=false.

## R299-R302 AXI Write Response Drain

vision_axi_write_drain adds a passive proof ledger at each DMA master's
unmixed AXI write interface, in its own clock/reset domain. WSTRB byte count
must reach exact EXPECTED_BYTES; AWLEN+1/W beat totals and AW/WLAST/accepted
OKAY B-response totals must balance. Pending VALID or any upstream/integrity
fault prevents completion. Saturating byte/beat counters and post-completion
accepted work fail closed. W may precede AW. MAX_WRITE_BEATS is a proof
capability guard, not a queue or a source-rate control. No ready/valid/data
is driven by the observer and no original capture/DMA/decoder code changes.

This assumes a compliant nonexclusive DMA master and an owner-serialized
epoch with no earlier outstanding traffic. It is not a full AXI checker:
addresses, IDs and individual burst lengths are trusted to the existing
master. Instantiate separately before RGB/mask master traffic mixes. Bind
expected bytes to the finite capture geometry, packet trailer/padding and
epoch frame count; validate any stride/packing-specific write-beat bound.
Do not reinterpret this interface-response proof as physical DDR persistence,
CPU cache visibility or ownership release. The final fence dma_drained must
also include authoritative memory visibility and buffer-owner completion;
source_quiescent still requires actual permanent source stop and all earlier
source faults settled. Arm/reset/reuse only through the serialized owner,
without stale work and without reusing an epoch across resets.

R299/R301 unit regressions44cases at4/8byte widths PASS; final B64cycle stall,
partial/all-byte strobes, independent channel ordering, two outstanding
bursts, all bad responses, saturation, excess work and reset are checked.
R300 uses real tracked capture/fence/two ledgers and an explicitly modeled
single-beat memory-response producer: two double-frame epochs/4actual packets,
held RGB96B and packet144B responses independently prevent seal despite real
pipeline completion and model owner permission. R301107Python tests PASS
against these actual packets. R302 original-default testbench branch10cases/
two epochs/4packets PASS in a new output directory. Hardware sensor/DMA
conversion/memory slave/owner behavior remain unverified by this model.

R302 standalone default64bit/460864byte instance121LUT115FF7control sets,
0BRAM/DSP/latch; internal10ns analysis estimate+2.179ns and12check_timing
categories0, native0warnings/errors. These are not full candidate physical
resources/timing. Actual BD/MMIO/functional BUILD/capability/driver pairing,
service bounds/full route/board Agent/Studio3x900/lifecycle remain pending;
NOT_PASSED/board_pending=true/release_ready=false.

## R295-R297 Real Pipeline Transaction Drain

vision_capture_drain observes actual accepted source RGB, retained RGB
and DMS1 output transactions. Exact static input geometry/EPOCH_FRAMES
determines total source/retained pixels and ceil(mask_pixels/2)+16words
per packet. Each per-frame final trailer must carry TLAST and all words
have full TKEEP. Saturating counters reject extra accepted work; capture
faults and malformed/unsolicited output lock integrity_fault until reset.
Completion requires all expected transactions consumed with no pending
source/RGB/packet VALID and no fault. Partial frames, idle outputs or a
blocked final word cannot assert completion. This predicate uses the
unchanged capture's normal finite one-to-one transaction contract; it
does not inspect CRC or independently verify identity/pixel content.

axis_rgb_capture_tracked instantiates the unchanged capture plus this
passive observer, without gating or changing handshakes/data. Excess work
continues into the original capture and invalidates the epoch, rather
than being silently discarded. EPOCH_FRAMES is a finite transaction budget,
not a queue size or camera-rate setting. The owner must keep identity and
geometry/budget paired and reset only under its coordinated lifecycle.

R295 real tracked capture→new drain→existing fence passes10unit scenarios
and2two-frame epochs/4actual packets. Separate final DMS1 and RGB stalls
each inhibit pipeline completion; after both consume, fence still waits
for independent DMA drain. Partial-input reset, new epoch recovery and
extra accepted input invalidation pass. The4packets'2x2 raw/filtered
pixels, full identity/trailer and CRC are self-checked, then independently
decoded with standard zlib and the unchanged Python decoder. R296107related
tests/no skips/failures/errors pass. Original algorithm/queue limits unchanged.

R297 flat tracked capture1425LUT/1146FF/41control sets/4BRAM/2DSP/0latch;
observer hierarchical44LUT/75FF only. Internal unplaced10ns estimate
worst+0.318ns remains original area→HSV; check_timing12categories zero
under analysis-only zero IO delays. Native24warnings are original XPM
unused sequential/optional ports, retained in full. No whole-design route,
physical delta, sensor timing or board admission is inferred.

The pipeline input to the fence is now computed by real capture traffic
in this test, not manually driven. Source quiescence and DMA drain remain
testbench models. NEXT: authoritative sensor stop and DMA write/ownership
completion with serialized owner epoch/reset lifecycle, real BD/functional
BUILD/capability/driver and bounded service proof. Whole system remains
NOT_PASSED, board_pending=true/release_ready=false; real seals stay disabled
until the remaining real owner contracts have been established.

## Local hypothesis and first discriminator

Hypothesis: full-frame pixel preparation and morphology can move ahead of
DDR capture, reusing the existing HSV primitive. PS can rotate/mirror two
compact masks instead of preparing and uploading a full BGR frame.
This can remove work and transfers; actual CPU savings remain unmeasured.

First discriminator: compare the existing OpenCV order against a CPU
model of this reordered pipeline, byte-for-byte, including both masks,
channel order, rotation, mirroring, threshold boundaries and image edges.
Also check the exact 2x2 resize rounding and four-pass dilation collapse.
These checks validate an ordering hypothesis, not synthesized RTL.

## Owning paths and preserved semantics

- `board/pynq_z2/scripts/vision_async_runtime.py`: SharedVisionHardware.read
  copies 1280x720 RGB; process_rgb resizes to 640x360, normalizes channel
  order, rotates/mirrors, then converts to BGR. OriginalContour.infer uses
  raw skin for selected-pixel statistics and the dilated/blurred mask for
  contour detection. FullFrameTracker uses full-frame ROI and defaults to
  three 3x3 dilation iterations; OriginalContour defaults to four. The
  actual Agent factory explicitly selects four, which defines this candidate.
- `handoffs/gesture_vision_v61/hardware/frontend/rtl/axis_bgr_hsv_skin.sv`:
  existing OpenCV-compatible HSV primitive with inclusive thresholds and
  global backpressure clock-enable. Its actual candidate input identity
  still requires binding to sealed 0900 sources before reuse.
- `handoffs/gesture_vision_v61/hardware/frontend/rtl/bgr_skin_dma.sv`:
  SKN6 accepts tight BGR and returns binary mask plus a trailer. A filtered
  grayscale mask cannot silently replace its binary reply.
- `handoffs/gesture_vision_v61/runtime/skin_dma.py`: current reply decoder
  rejects values other than 0/255. A dual-mask candidate needs an explicitly
  versioned capability, bounded buffers and a separate decoder.

## Proposed first candidate

```text
Existing camera/demosaic RGB stream
  -> exact 2:1 area reduction (1280x720 -> 640x360)
  -> existing HSV threshold primitive
  -> raw binary mask ---------------------------+
  -> 3x3 dilation x4 -> Gaussian 5x5 sigma=100 ---+-> dual-mask capture
  -> PS mask rotate/mirror -> existing contour/statistics/tracker -> game
```

R211 refined integration direction: retain the existing RGB camera VDMA
and HP1 path for capture/preview compatibility. Replace the PS-to-SKN6 BGR
upload path with a camera-stream tap and dual-mask S2MM capture. Evaluate
reusing/reconfiguring the algorithm DMA's S2MM side, removing its MM2S
side and reducing HP3 arbitration, rather than adding a second complete
algorithm subsystem. This remains an unbuilt candidate, not a promised
net saving. Preview selection/ownership and the sensor's no-stall behavior
need an explicit contract before integration.

R214 configuration correction: the Agent factory explicitly constructs
`FullFrameTracker(dilate_iterations=4)`, although the class default is3.
Both the factory and runtime match the deployed R192 ZIP byte-for-byte.
The earlier R210 probe tested three iterations only; it does not certify
this actual configuration. Its original evidence remains unchanged.

First capability: FullFrameTracker, full-frame ROI, four dilations.
Other ROI/dilation settings require an explicit capability rejection or
the unchanged baseline path; they are not silently approximated.

PS keeps contours, convexity defects, statistics, voting, game state and
safety policy. Both outputs must share frame identity, configuration
snapshot and dimensions. Raw mask stays binary; blurred mask is uint8
grayscale. The candidate must preserve raw-mask statistics.

Camera AXI video uses start-of-frame TUSER and end-of-line TLAST; the
existing SKN6 transaction uses end-of-frame semantics. A wrapper must
validate coordinates/counts, translate framing, drain border pixels and
emit exactly one complete mask frame. Raw and filtered masks need latency
alignment before a packed dual-mask capture; the extra alignment FIFO
is not included in the corrected illustrative 11520-byte line-storage subtotal.
Stalls, truncation, frame identity and configuration changes must remain
coherent across both masks.

Rotation is deferred only if exact commutation is demonstrated. A 180-degree
RGB stream reversal otherwise needs frame storage; it is not a free line
operation. ROI clipping and border behavior require separate validation
before extending beyond full-frame mode.

Gaussian sigma=100 must use the actual OpenCV kernel/rounding; a familiar
binomial 5x5 kernel is not an equivalent replacement. PC OpenCV results do
not certify the board's OpenCV 4.5.4 rounding. Validation-only full software
references must be budgeted separately from the production candidate.

## Transparent budgets

For full-frame recognition, RGB8 input and two uint8 output masks:

| Item | Bytes/frame |
| --- | ---: |
| Existing camera RGB DDR write | 2764800 |
| Existing CPU camera read, minimum payload | 2764800 |
| Existing SKN6 input, including header | 691220 |
| Existing SKN6 output, including trailer | 230432 |
| Sum of the four logical transfers | 6451252 |
| Proposed two-mask DMA write, excluding metadata | 460800 |

These are logical payload counts, not measured DDR bandwidth. They omit
cache-line traffic, copies, burst padding, PS reads of the new masks,
debug/preview RGB, GPU and audio traffic. Their different transfer sets
must not be reported as a measured whole-system bandwidth reduction.
The refined first candidate retains the 2764800-byte RGB capture write;
its dual-mask output does not replace that retained preview/capture cost.
Optional RGB preview requires a separately budgeted, bounded branch and
must not backpressure the continuous sensor or primary recognition path.

At 60 camera frames/s: 55296000 incoming pixels/s and 13824000 output
pixels/s. A nominal 100MHz one-pixel/cycle core has an arithmetic rate
budget, not a demonstrated timing/backpressure guarantee. Recognition
consumer FPS and camera stream FPS are separate quantities.

Illustrative logical line storage, excluding banking/port replication,
pipeline registers, frame metadata, FIFOs and HSV ROMs:

- One RGB input row: 1280*3 = 3840 bytes.
- Four dilation passes, two uint8 rows each: 8*640 = 5120 bytes.
- Gaussian four uint8 rows: 4*640 = 2560 bytes, a lower bound only;
  intermediate precision can increase this.
- Corrected total illustrative storage: 11520 bytes. This is not a BRAM allocation
  estimate and does not prove LUT/Slice fit.

The previous three-pass subtotal was10240 bytes. This corrected figure
still excludes raw-mask alignment FIFO, banking and intermediate precision.

Sealed 0900 final implementation: LUT31876/53200, FF48602/106400,
Slice12918/13300, BRAM88.5/140, DSP14/220, 2174 control sets,
WNS0.015ns/WHS0.051ns. Only 382 Slice sites remain unused; unused LUTs
and DSPs do not establish legal packing or routability.

Consequently this candidate is a replacement/reorganization study, not
an approved additive IP plan. Before RTL integration obtain hierarchical
resource/control-set evidence and bind the actual camera-to-capture nets.
Compare removal/reuse of the existing algorithm DMA/adapter against the
new branch, with preview, stop and capture safety accounted for.

R211 read-only final routed DCP audit completed in Vivado2026.1. Reports
are under `results/game-validation/vision-pl-streaming-20261015/`:

| Existing hierarchy | LUT row | FF | BRAM36 equivalent | DSP | Control sets in hierarchy |
| --- | ---: | ---: | ---: | ---: | ---: |
| skin_kernel | 573 | 581 | 0.5 | 4 | 14 |
| moments_dma | 1588 | 2299 | 3 | 0 | 102 |
| skin_hp3_smc | 2138 | 3060 | 0 | 0 | 156 |
| demosaic, retained | 4343 | 5973 | 19 | 8 | 110 |
| frame_dma, retained | 1588 | 2423 | 2.5 | 0 | 104 |
| camera_hp1_smc, retained | 529 | 455 | 0 | 0 | 41 |

The first three LUT rows sum to4299 and FF to5940, with3.5 BRAM36 and4
DSP. This is a hierarchy accounting upper bound, not physically released
LUTs or a net candidate budget: RTL/HSV and capture logic must be retained
or replaced. Control sets can overlap across hierarchies. The hierarchy
report explicitly warns about cross-hierarchy LUT combining: direct LUT
rows sum to31922 while physical top-level LUTs are31876, difference46.
The auditor retains both counts rather than normalizing the discrepancy.
Actual reclaimed Slice sites remain unmeasured.

Seven HWH connections and four frontend source SHA/byte identities match
the existing sealed build provenance. The read-only session closed with
exit0; PID55152 absence was independently confirmed via CIM. Final DCP
and HWH SHA values remain unchanged. Four injected bad-input models pass
in `r213-models.json`; original auditor/terminal failures are preserved.

## Gates and decision

1. CPU ordering probe: exact intermediate masks and resize rounding,
   deterministic boundaries, no hardware access. Initial stdin probe PASS:
   NumPy2.5.3/OpenCV4.14.0, 12 resize/96 raw-mask/96 filtered-mask/24
   dilation checks. Persistent rerunnable entry:
   `results/game-validation/vision-pl-streaming-20261015/r210-ordering-probe.py`.
   This is PC ordering evidence only, not board/RTL equivalence.
2. Source/net/resource ownership audit: sealed identity, four frontend
  sources, seven HWH connections and hierarchical resource accounting
  PASS. Stream no-stall/overflow, preview buffering, framing translation,
  alignment FIFO and net reclaimable resources remain integration gates.
  No guessed net savings or new-route fit claim.
3. Independent RTL simulation: exact outputs, short/long/malformed frames,
   stalls, end-of-frame drain, configuration snapshots, reset/stop and
   overflow behavior; extend existing frontend tests without editing the
   read-only handoff. Pending.
4. Independent synthesis/place/route: unchanged clocks, CDC and strict
   nonnegative setup/hold gates. OOC results alone cannot approve fit.
5. Board numerical and recognition regression against 0900 references,
   then low-overhead CPU/deadline measurement and same-package three
   independent 900-packet complete-system runs. Pending.

Any sustained sensor/consumer rate mismatch needs an explicit bounded
flow-control contract. Mask capture must not quietly introduce dropped
frames, unbounded queues or a sensor stall assumption. New hardware and
capability identities are assigned only after the candidate contract is
reviewed. No bitstream build, board deployment or release is authorized
by this architecture note.

## R214 project-oriented compute review

Read-only classification from the final routed report and paired HWH:

| IP family | Count | Hierarchical LUT row sum | FF sum |
| --- | ---: | ---: | ---: |
| AXI GPIO | 28 | 3024 | 11144 |
| SmartConnect | 7 | 9754 | 11497 |
| AXI DMA | 4 | 4412 | 7236 |
| AXI VDMA | 1 | 1588 | 2423 |

LUT row sums are not unique physical counts or reclaimable resources.
The GPIO and control-tree totals motivate a compact, versioned AXI-Lite
register bank that preserves identity, generation, completion and error
semantics. They do not justify deleting these observations or resetting
the existing timing boundary. Core assets/tilemaps/palettes support the
game renderer and are not classified as disposable diagnostics.

Confirmed CPU validation overhead: the shared factory does not set
skin_validate; OriginalContour.infer defaults that attribute toTrue.
After obtaining a PL mask it recomputes CPU HSV/inRange and compares the
whole mask. A separate acceptance/diagnostic mode could retain this gold
comparison while a reviewed production mode retains frame identity,
length/status/threshold and health checks. This is a mode-separation
candidate, not permission to disable all checks. Board CPU savings and
same-package complete-system benefit remain unmeasured.

Current capture also copies full1280x720x3 frames into normal RAM, then
prepares and uploads640x360 BGR. These are data-path costs, not extra
recognition quality. Stream fusion can replace them for recognition;
preview compatibility still has its separate capture/copy budget.

Audio config has1201 FIR taps,48kHz input/8kHz processed,512-sample
windows and32-sample stride:250 feature windows/s after warm-up. Causal
decimation/filtering, autocorrelation and windowed spectral ratios are
PL candidates; the detector consumes power/Q/spectral ratios/ZCR/pitch,
so these are not identified as unused calculations. Current reference
uses magnitude-L1 spectral ratios, not power-L2. The512-point windowed
spectrum and1024-point zero-padded unwindowed autocorrelation transform
cannot be replaced by one unchanged FFT without further mathematical
and recognition validation. At8kHz, a direct1201-tap decimating FIR has
9608000 tap products/s, a workload estimate rather than measured CPU cost
or a synthesized DSP count. PS can keep event voting and game policy.

Already demand-gated: preview video/debug encoding; current game path
passes render_rgb=False and avoids CPU RGB rendering. Recognition,
freshness/epoch/ownership validation and Scene completion are required
even when the PC disconnects. They are not removable preview work.

R214 PC models passed: four3x3 dilations equal one9x9 dilation, plus48
orientation/filter comparisons. A mock backend demonstrated exactly one
CPU HSV conversion in the default PL-mask validation path versus zero
when disabling the comparison on the isolated test object. No production
setting was changed and no board CPU saving was measured. Evidence:
`results/game-validation/vision-pl-streaming-20261015/r214-resource-review-models.json`.

## R215 optional work and priorities

The real Agent capture_order is BGR. process_rgb converts its reduced
BGR image to RGB, then back to BGR for recognition. R215 exercised that
actual function: two conversions, with byte-exact recognizer input equal
to resize/rotate in BGR directly. RGB output still carries preview
semantics, so a future optimization must create it only when requested,
not reinterpret BGR memory as RGB. This is avoidable recognition-path
work when no preview subscriber needs the RGB result, not a recognition
algorithm change. Evidence is PC-only.

The fusion CLI explicitly requires return_source=none. The existing
scene2d_return_source is a seeded pattern generator, not an HDMI
framebuffer readback. A project-specific runtime hardware profile could
omit that diagnostic subsystem while a diagnostic profile keeps it.
Affected hierarchy row sums:

| Optional seeded-return group | LUT row sum | FF | BRAM36 equivalent |
| --- | ---: | ---: | ---: |
| return_dma/source, four return GPIOs, hp2_smc | 2070 | 3447 | 1.5 |

This group overlaps the GPIO/SmartConnect family totals above and must
not be added to them again. Removal needs a new capability/build profile,
driver/ABI review and full regression. It does not remove camera HTTP
preview, audio observation or HDMI rendering. Net reclaimed Slice sites
and timing still require a new actual implementation.

Recommended order, with measurements after each isolated change:

1. Separate full CPU mask gold comparison into acceptance/diagnostic mode;
  preserve live structural, sequence, owner, status and age checks.
2. Eliminate recognition-only BGR/RGB round trips and avoid large frame
  copies where ownership allows; generate preview data on demand.
3. Make optional seeded-return hardware explicit, and consolidate GPIO
  status/control into a compact versioned register bank without losing
  completion/error/generation observations or clock-domain guarantees.
4. Implement the visual streaming candidate with the actual four-pass
  configuration, preserving both masks and all geometric semantics.
5. Evaluate causal DC/FIR/decimation, then autocorrelation/spectrum/feature
  arithmetic in PL. Preserve48kHz raw scale, all samples/window starts,
  L1 spectrum ratios, phase state and quality thresholds. Fixed-point
  migration requires separate numerical and recognition acceptance.

Keep game state/rules and detector voting in PS initially. The renderer,
asset/tilemap/palette stores, timestamp/epoch freshness and safe halt/
release are part of the project contract. A simpler recognition model,
lower camera resolution or reduced game tick rate is a separate design
decision, not a free resource optimization. None is adopted by this review.

## R216-R217 software candidate

Status: SOFTWARE_CANDIDATE_PC_PASS / BOARD_PENDING. This implements the
first software steps above, not the streaming RTL or a new hardware build.

- Shared Agent CLI exposes --vision-pl-skin-mode validate|performance.
  Default validate retains the historical CPU gold comparison. Explicit
  performance skips that numerical comparison only; backend errors still
  propagate. Per-run config records the actual mode.
- Recognition prepares BGR directly. process_rgb retains RGB preview by
  default; with annotate=False and preview_rgb=False it returns None for
  the image while still publishing recognition. Shared worker requests RGB
  only for due video demand, and intersects prepared/requested modes when
  submitting a snapshot. Debug-only and late subscriptions are covered.
- BGR channel conversions are zero without due video and one with video,
  versus the old unconditional two. These are PC call counts, not measured
  board CPU savings. Full capture-frame copying remains for VDMA ownership.

286 Agent/vision-preview/voice-backend tests passed, including mode wiring
for both shared backends, backend-error propagation, gold mismatch,
pixel-exact geometry/preview and continuous tracking/statistics comparison.
Five files passed Python3.10 syntax parsing. Frozen vision source checks
passed; OriginalContour, FullFrameTracker and standalone main ASTs equal
the pinned R192 deployment. Python3.13.2/NumPy2.5.3/OpenCV4.14.0 were used;
this is not a board3.10/OpenCV4.5.4 runtime result.

Evidence: results/game-validation/vision-pl-streaming-20261015/
r216-software-tests.xml and r217-software-candidate.json. The first long
audit command had incomplete terminal acknowledgement; its r216 JSON is
preserved and the independent short-entry R217 audit completed with exit0.
No package, deployment, hardware access, deadline or algorithm change was
made. Fusion acceptance remains NOT_PASSED; next is an isolated candidate
package and controlled board comparison before claiming performance gains.

## R218-R225 deployed software comparison

The independent R218 package is based only on the pinned R192 archive:
seven whitelisted files changed,632 entries including hardware/audio sources
preserved. ZIP SHA d9f176af0d0c1170f71f93ce542d05684539c53effee17a8b85fff132035e36e.
Exported check-only and311 tests passed; board check-only and original
native transport/CPU feature models passed with the same library hashes
as R192. The acceptance entry now forwards and records the explicit mode.

| Same-package run | Actual mode | PCM packets | Result |
| --- | --- | ---: | --- |
| R221 | validate |21 | voice pending observation expired |
| R223 | performance |60 | voice pending observation expired |

Both returned capture_pass=false/cleanup_confirmed=true and no retained
process. Independent R222/R224 owner checks passed. R225 read-only audit
verified actual run_config modes and deployed source hashes. These are
single bounded diagnostic runs, not a stable speedup measurement or
formal900-packet acceptance. The software changes alone did not satisfy
the contract in these runs; further identical retries are stopped.

The shared worker's pre-existing run_config profile/build labels still
say C6I_VISION/0800; actual0900 identity is checked separately by the paired
manifest/session. This metadata defect is recorded, not used as hardware
identity evidence. Frozen0900 remains unchanged. Next hardware work needs
an independent candidate BUILD/capability and driver-mapping review.
Evidence: results/game-validation/voice-s4-board-20261014/r225-audit.json;
full failures and owner receipts remain unchanged. Overall NOT_PASSED.