# C0D HDMI OSD integration handoff

**NEW USER GOAL — 2026-10-23:** 用户明确提出修复PL下沉时序并实现硬件加速，现恢复独立C0E实验；最新事实见 [时序修复记录](../../../docs/bringup/2026-10-23_pynq-z2_pl_timing_repair.md)。R1仍保留，C0E签核前不切换；下文FINAL为此前暂停快照。

**FINAL USER DECISION — 2026-10-23 07:45 +08:00: retain only R1 (~2.5% of one ARM core) and hand off. Stop new R2/C0E work. [FINAL_HANDOFF](../../../docs/bringup/2026-10-23_pynq-z2_osd_FINAL_HANDOFF.md) supersedes all continuation statements, old identities and stale pending items below. R1 eight real-GPU goldens/modes/10-minute soak PASS; selected ZIP unchanged. Latest historical board log `var/osd-live-vl02`, Agent760/start_ticks17079, boot `0dd40186-dc2d-472f-b75c-1c6ec883ec31`. Two prior host-only Vivado commands remained running at snapshot; exact sessions/logs and limitations are recorded. No candidate deployment or new board/Copilot operation.**

**Active continuation, 2026-10-23:** the user subsequently authorized autonomous R1 board acceptance and a feasible PL vision acceleration candidate. Current facts superseding the historical handoff are in [visual latency bringup](../../../docs/bringup/2026-10-23_pynq-z2_visual_latency.md) and [detailed acceleration plan](../../../docs/vision_latency_acceleration_plan_20261023.md). R1 eight real-GPU goldens, modes, two-minute and ten-minute ABBA/soak now PASS under the tested no-Studio conditions. Ten-minute OSD: 27.57 Hz / 2.443% one core, no fault/ACK errors. New C0E is independent: connected, BD validated, targets generated, synthesis completed; real-BD reset simulation is in progress. It has not replaced R1; R2 remains unselected. Do not infer full release or acceleration success from this progress.

**2026-10-23 user decision: retain the running R1 (~2.48% of one ARM core), stop optimization and hand off. R2 is not selected or activated.**

Authoritative current handoff: [2026-10-23 handoff](../../../docs/bringup/2026-10-23_pynq-z2_hdmi_input_osd_handoff.md). Detailed chronological attempts: [integration bringup](../../../docs/bringup/2026-10-22_pynq-z2_hdmi_input_osd_integration.md). Earlier entries describe historical states.

Selected package: `deliveries/c6i-vision-volume-osd-r16-20261022.zip`, SHA256 `2e49d7fc2cb1f60a89ffd69b6d9510278d99897bdc06d609604f581e5a8fbb67`. Board root `/home/xilinx/voice-view-game/c6i-vision-volume-osd-r16-20261022`, log `var/osd-live-r02`, BUILD_ID `0xC0060D00`. Last verified boot `b40bc22c-b967-4418-a6fb-f614f37376cf`, Agent 921/start_ticks 29986. Refresh identity read-only before any future action; these are historical observations, not a fresh ownership check.

Full implementation/export, R1 package restore/ARM contracts, default-menu operation and OSD-only fixture/expiry/toggle checks have evidence. G21 measured 26.9245 Hz OSD commits, 2.47960994% single-core thread CPU, no fault/ACK errors. Its historical FAIL under the former <1% assertion is preserved; the user accepts the ~2.5% version. Physical HDMI visibility has not been established by mailbox receipts.

Pending: eight C0D real-GPU goldens, live game/pause/video mode tests, on/off A/B and longer stability, human gesture/acoustic/HDMI acceptance. `release_ready=false` remains appropriate.

R2 archive `deliveries/c6i-vision-volume-osd-r16-20261023-r2.zip` is an unselected experiment, staged only. Its ARM preview contract timed out during startup before checking shutdown; no board CPU reduction or ARM cleanup fix is established. **The integration `runtime_osd.py`, `osd_backend.py` and `test_runtime_osd.py` are R2 prototypes. Use the frozen R1 package/tree for the selected source.**

Do not replay deployment/recovery scripts or blindly use their historical defaults. No stop, restart, Overlay download or R2 switch is needed for this handoff. Preserve failures and locks; do not force-kill owners or reset DMA to bypass recovery. Copilot and mainline/r15 remain untouched.
