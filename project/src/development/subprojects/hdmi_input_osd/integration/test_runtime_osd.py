"""Private child tests: real publisher/service/page and Agent command dispatch."""
import json
import multiprocessing
import os
from pathlib import Path
import sys
import tempfile
import time
import unittest
from unittest.mock import patch
from types import SimpleNamespace

ROOT = Path(os.environ.get("VVG_OSD_TEST_ROOT", str(Path(__file__).resolve().parents[3] / "deliveries/c6i-vision-volume-osd-r16-20261022")))
PRIVATE_TMP = Path(os.environ.get("VVG_OSD_TEST_TMP", str(Path(__file__).resolve().parent / "evidence/test-tmp")))
PRIVATE_TMP.mkdir(parents=True, exist_ok=True)
tempfile.tempdir = str(PRIVATE_TMP)
sys.path.insert(0, str(ROOT / "python"))
sys.path.insert(0, str(ROOT / "board/pynq_z2/scripts"))
from pynq_multimodal_game.input_osd import ObservationHub, InputOsdService, audio_observation
from pynq_multimodal_game.osd_publisher import OsdPublisher
from pynq_multimodal_game.agent.core import AgentCommand, AgentController, MockRuntimeBackend
from voice_volume_runtime import VolumeSharedPage


class Registers:
    def __init__(self, busy=False):
        self.words, self.busy, self.writes = {}, busy, []
    def read(self, offset):
        return OsdPublisher.ID if offset == 0 else int(self.busy) if offset == 4 else self.words.get(offset, 0)
    def write(self, offset, value):
        self.words[offset] = value
        self.writes.append((offset, value))


class Lease:
    bitfile_name = "test.bit"
    def __init__(self, regs):
        self.regs, self.closed = regs, False
    def retain(self, value): self.resource = value
    def mmio(self, instance):
        assert instance == "input_osd_0"
        return self.regs
    def close(self): self.closed = True


class Session:
    def __init__(self, regs): self.lease = Lease(regs)
    def borrow(self, name, *, instances):
        assert name == "hdmi-input-osd" and instances == frozenset({"input_osd_0"})
        return self.lease
    def ip_address(self, lease, hwh, instance): return (0x43C20000, 4096)


def page_values(now=None):
    return dict(phase=2, observed_ns=now or time.monotonic_ns(), epoch=2, enabled=1,
                clock_locked=1, snapshot_valid=1, window_count=1, sample_count=977,
                l1_sum=19540, soft=15632, loud=27356)


class RuntimeTests(unittest.TestCase):
    def test_unknown_classification_keeps_position_and_fist_contract(self):
        hub, regs = ObservationHub(), Registers()
        publisher = OsdPublisher(regs)
        args = dict(run_id="vision", config_epoch="epoch", frame_id=1, observed_ns=1_000_000_000)
        observed = dict(bbox=[1, 2, 5, 6], centroid=[200., 100.], stable=None, rps="UNKNOWN")
        hub.publish(observed, **args)
        publisher.tick(hub.hand, None, now_ns=args["observed_ns"])
        self.assertEqual(regs.words[0x10], 3)  # enable + green position, classification unknown
        observed.update(stable="0", rps="ROCK")
        args.update(frame_id=2, observed_ns=1_040_000_000)
        hub.publish(observed, **args)
        publisher.tick(hub.hand, None, now_ns=args["observed_ns"])
        self.assertEqual(regs.words[0x10], 7)
        hub.clear()
        publisher.tick(hub.hand, None, now_ns=1_080_000_000)
        self.assertEqual(regs.words[0x10], 1)
        self.assertEqual(publisher.hand.observed_ns, args["observed_ns"])

    def test_bad_coordinate_fails_closed(self):
        hub = ObservationHub()
        for point in ([640, 20], [20, float("nan")], [20], None):
            hub.publish(dict(bbox=[1, 2, 3, 4], centroid=point), run_id="r", config_epoch="e",
                        frame_id=1, observed_ns=100)
            self.assertTrue(hub.hand is None or not hub.hand.position_valid)

    def test_native_u32_view_matches_scalar_words_and_commit(self):
        import numpy as np
        from pynq_multimodal_game.osd_registers import OsdRegisters
        from pynq_multimodal_game.osd_publisher import HandObservation, AudioObservation
        array=np.zeros(32,dtype=np.uint32)
        array[0]=OsdPublisher.ID
        native=SimpleNamespace(array=array,device=SimpleNamespace(has_capability=lambda name: name=='MEMORY_MAPPED'))
        raw=Registers()
        scalar=OsdPublisher(OsdRegisters(raw))
        mapped=OsdPublisher(OsdRegisters(native))
        hand=HandObservation('r',1,1000000000,.7,-.6,True,True)
        audio=AudioObservation('a',2,977,1000000000,20.,16.,28.,True)
        scalar.tick(hand,audio,now_ns=1000000000)
        mapped.tick(hand,audio,now_ns=1000000000)
        self.assertEqual([raw.words[0x10+4*i] for i in range(6)],array[4:10].tolist())
        self.assertEqual(raw.words[8],int(array[2]))
        self.assertEqual(mapped.io.mode,'native-u32-view')
        self.assertEqual(mapped.io.read_shadow(),mapped.last_words)

    def test_native_wrong_width_rejected_and_probe_is_explicit(self):
        import numpy as np
        from pynq_multimodal_game.osd_registers import OsdRegisters
        native=SimpleNamespace(array=np.zeros(32,dtype=np.uint64),device=SimpleNamespace(has_capability=lambda name: True))
        with self.assertRaisesRegex(ValueError,'uint32'): OsdRegisters(native)
        service=InputOsdService(Session(Registers()),ObservationHub(),lambda: None)
        with self.assertRaisesRegex(RuntimeError,'diagnostic'): service.request_probe()

    def test_probe_reads_shadow_in_owner_thread(self):
        regs=Registers()
        service=InputOsdService(Session(regs),ObservationHub(),lambda: None,allow_test=True).open()
        try:
            service.request_probe()
            deadline=time.monotonic()+1
            while service.probe is None:
                self.assertLess(time.monotonic(),deadline)
                time.sleep(.01)
            self.assertEqual(service.probe['actual'],service.probe['expected'])
        finally: service.close()

    def test_compact_page_read_identity_contention_and_fault(self):
        page = VolumeSharedPage(multiprocessing.get_context("spawn"), "a"*32)
        self.assertIsNone(page.read_observation())
        values = page_values()
        self.assertTrue(page.publish(values, diagnostics=b"x" * (28*512)))
        compact = page.read_observation()
        self.assertNotIn("diagnostics", compact)
        self.assertNotIn("native_milestones_best_effort", compact)
        a = audio_observation(compact)
        self.assertEqual((a.mean_abs, a.soft, a.loud, a.healthy), (20., 16., 28., True))
        page.lock.acquire()
        try: self.assertIsNone(page.read_observation())
        finally: page.lock.release()
        values.update(faults=1)
        page.publish(values)
        self.assertFalse(audio_observation(page.read_observation()).healthy)
        page.storage[0] = 0x10
        with self.assertRaisesRegex(Exception, "identity"):
            page.read_observation()

    def test_independent_scheduler_expiry_and_disable_ack(self):
        regs, hub = Registers(), ObservationHub()
        session = Session(regs)
        service = InputOsdService(session, hub, lambda: None, allow_test=True).open()
        try:
            service.set_test(dict(x=0., y=0., position_valid=True, fist=True,
                                 mean_abs=20., soft=16., loud=28., hold_ms=1000))
            time.sleep(.07)
            self.assertEqual(regs.words[0x10], 15)
            before = service.publisher.commits
            time.sleep(.28)  # no game ticks, frame submissions, preview or new observations
            self.assertGreater(service.publisher.commits, before + 3)
            self.assertEqual(regs.words[0x10], 1)
            self.assertTrue(service.status()["test_active"])
            self.assertGreater(service.status()["hand_source"]["age_ms"], 250)
        finally: service.close()
        self.assertEqual(regs.words[0x10], 0)
        self.assertTrue(session.lease.closed)
        self.assertTrue(service.disabled_confirmed)
        writes = len(regs.writes)
        time.sleep(.04)
        self.assertEqual(len(regs.writes), writes)

    def test_no_test_stimuli_by_default(self):
        service = InputOsdService(Session(Registers()), ObservationHub(), lambda: None)
        with self.assertRaisesRegex(RuntimeError, "explicit"):
            service.set_test({})

    def test_default_menu_starts_vision_and_keeps_two_disabled_audio_thresholds(self):
        from pynq_multimodal_game.agent.osd_backend import C6IOsdRuntimeBackend
        from pynq_multimodal_game.agent.vision_backend import C6IVolumeRuntimeBackend
        backend = C6IOsdRuntimeBackend.__new__(C6IOsdRuntimeBackend)
        backend._session = Session(Registers())
        backend._osd_hub, backend._osd, backend._osd_allow_test = ObservationHub(), None, False
        calls = []
        backend._vision_supervisor = SimpleNamespace(start=lambda: calls.append("vision_started"))
        backend._volume = SimpleNamespace(read_observation=lambda: None, osd_thresholds=(16., 28.))
        with patch.object(C6IVolumeRuntimeBackend, "open", return_value=backend), \
             patch.object(C6IVolumeRuntimeBackend, "close", side_effect=lambda: calls.append("parent_closed")):
            backend.open()  # no game or explicit VISION_START
            self.assertEqual(calls, ["vision_started"])
            time.sleep(.04)
            words = backend._osd.publisher.last_words
            self.assertEqual(words[0], 1)
            self.assertEqual(words[2] >> 16, 69)
            self.assertEqual(words[3] & 1023, 120)
            backend.close()
            self.assertTrue(backend._session.lease.closed)
            self.assertEqual(calls[-1], "parent_closed")

    def test_busy_cleanup_retains_lease(self):
        session = Session(Registers(busy=True))
        service = InputOsdService(session, ObservationHub(), lambda: None).open()
        with self.assertRaisesRegex(RuntimeError, "retain Overlay lease"):
            service.close()
        self.assertFalse(service.thread.is_alive())
        self.assertFalse(session.lease.closed)

    def test_agent_osd_dispatch_is_idempotent_and_gameplay_neutral(self):
        class Backend(MockRuntimeBackend):
            changes = 0
            def set_input_osd(self, payload):
                self.enabled = json.loads(payload)["enabled"]
                self.changes += 1
                return self.snapshot
        backend = Backend(build_id=0xC0060D00)
        controller = AgentController(backend)
        first = controller.execute("osd1", AgentCommand.INPUT_OSD_SET, payload=b'{"enabled":false}')
        self.assertTrue(first.ok, first.message)
        replay = controller.execute("osd1", AgentCommand.INPUT_OSD_SET, payload=b'{"enabled":false}')
        self.assertTrue(replay.replayed)
        self.assertEqual(backend.changes, 1)
        conflict = controller.execute("osd1", AgentCommand.INPUT_OSD_SET, payload=b'{"enabled":true}')
        self.assertFalse(conflict.ok)
        self.assertFalse(backend.enabled)
        controller.close()


if __name__ == "__main__":
    unittest.main(verbosity=2)
