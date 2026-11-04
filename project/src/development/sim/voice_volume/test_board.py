import importlib.util
import json
import pathlib
import sys
import tempfile
import types
import unittest
from unittest.mock import Mock, patch

ROOT = pathlib.Path(__file__).resolve().parents[2]
SPEC = importlib.util.spec_from_file_location("voice_volume_board", ROOT / "board/pynq_z2/scripts/voice_volume_board.py")
BOARD = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(BOARD)
PACKAGE_SPEC = importlib.util.spec_from_file_location("package_voice_volume", ROOT / "board/pynq_z2/scripts/package_voice_volume.py")
PACKAGE = importlib.util.module_from_spec(PACKAGE_SPEC)
PACKAGE_SPEC.loader.exec_module(PACKAGE)

sys.path.insert(0, str(ROOT / "board/pynq_z2/scripts"))
import voice_volume_fusion as FUSION


class BoardBindingTests(unittest.TestCase):
    def test_pair_rejects_tampering_and_adjacent_xsa(self):
        with tempfile.TemporaryDirectory() as directory:
            root = pathlib.Path(directory)
            artifacts = root / "artifacts"
            artifacts.mkdir()
            expected = {}
            for name in ("voice_volume.bit", "voice_volume.hwh"):
                payload = name.encode("ascii")
                (artifacts / name).write_bytes(payload)
                expected[name] = BOARD.hashlib.sha256(payload).hexdigest()
            with patch.dict(BOARD.VOL1_HASHES, expected, clear=True):
                BOARD.validate_pair(root)
                (artifacts / "voice_volume.xsa").write_bytes(b"unused")
                with self.assertRaisesRegex(RuntimeError, "adjacent XSA"):
                    BOARD.validate_pair(root)
                (artifacts / "voice_volume.xsa").unlink()
                (artifacts / "voice_volume.bit").write_bytes(b"changed")
                with self.assertRaisesRegex(RuntimeError, "pair changed"):
                    BOARD.validate_pair(root)

    def test_package_reset_contract_rejects_old_polarity_and_broken_connection(self):
        hardware = PACKAGE.ET.Element("SYSTEM")
        modules = PACKAGE.ET.SubElement(hardware, "MODULES")
        ports = {
            "constant_low": {"dout": "low"}, "ps7_0": {"FCLK_RESET0_N": "ps_reset"},
            "control_reset": {"aux_reset_in": "low", "ext_reset_in": "ps_reset", "peripheral_aresetn": "released"},
            "control_axi": {"aresetn": "released"}, "voice_volume_0": {"s_axi_aresetn": "released"},
        }
        for instance, signals in ports.items():
            module = PACKAGE.ET.SubElement(modules, "MODULE", INSTANCE=instance)
            node = PACKAGE.ET.SubElement(module, "PORTS")
            for name, signal in signals.items():
                PACKAGE.ET.SubElement(node, "PORT", NAME=name, SIGNAME=signal)
        parameters = PACKAGE.ET.SubElement(hardware.find(".//MODULE[@INSTANCE='control_reset']"), "PARAMETERS")
        PACKAGE.ET.SubElement(parameters, "PARAMETER", NAME="C_EXT_RESET_HIGH", VALUE="0")
        auxiliary = PACKAGE.ET.SubElement(parameters, "PARAMETER", NAME="C_AUX_RESET_HIGH", VALUE="1")
        self.assertEqual(PACKAGE.validate_reset_contract(hardware)["connections"], 4)
        auxiliary.set("VALUE", "0")
        with self.assertRaisesRegex(ValueError, "polarity"):
            PACKAGE.validate_reset_contract(hardware)
        auxiliary.set("VALUE", "1")
        hardware.find(".//MODULE[@INSTANCE='voice_volume_0']/PORTS/PORT").set("SIGNAME", "wrong_net")
        with self.assertRaisesRegex(ValueError, "connection"):
            PACKAGE.validate_reset_contract(hardware)

    def test_startup_and_disable_failures_still_close_transport(self):
        for failure in ("disable", "checkpoint"):
            with self.subTest(failure=failure):
                control = Mock()
                control.configure.side_effect = [None, None, RuntimeError("disable failed")]
                transport = Mock(failed=False)
                transport.call.return_value = b"\x00"
                transport.process.is_alive.return_value = False
                fake_control = types.SimpleNamespace(
                    ProcessTransport=lambda *args, **kwargs: transport,
                    VolumeControl=lambda *args, **kwargs: control,
                    configure_codec=lambda *args, **kwargs: None,
                )
                def checkpoint(root, phase):
                    if failure == "checkpoint" and phase == "transport_spawn_returned":
                        raise RuntimeError("checkpoint failed")
                fake_fcntl = types.SimpleNamespace(LOCK_EX=1, LOCK_NB=2, flock=lambda *args: None)
                with tempfile.TemporaryDirectory() as directory:
                    root = pathlib.Path(directory)
                    with patch.dict(sys.modules, {"fcntl": fake_fcntl, "pynq": types.SimpleNamespace(Overlay=Mock()),
                                                  "voice_volume_control": fake_control}), \
                            patch.object(BOARD, "validate_pair"), patch.object(BOARD, "audit_base", return_value=[]), \
                            patch.object(BOARD, "checkpoint", side_effect=checkpoint), patch.object(BOARD, "open", create=True) as stream, \
                            patch.object(BOARD, "Path", side_effect=lambda value: root if value == "/run/lock" else pathlib.Path(value)):
                        stream.return_value.__enter__.return_value.read.return_value = b""
                        with self.assertRaisesRegex(RuntimeError, failure + " failed"):
                            with BOARD.managed_control(root, "unit-boot", trace_startup=True, thresholds=(11, 16, 28)):
                                transport.stop_trace.assert_called_once_with()
                transport.close.assert_called_once_with()
                if failure == "checkpoint":
                    control.configure.assert_not_called()
                else:
                    self.assertEqual(control.configure.call_args_list[0].kwargs,
                                     {"quiet_sum": 10747, "soft_sum": 15632, "loud_sum": 27356, "enable": False})
                    self.assertEqual(control.configure.call_args_list[1].kwargs,
                                     {"quiet_sum": 10747, "soft_sum": 15632, "loud_sum": 27356, "enable": True})

    def test_fixed_thresholds_require_explicit_ordered_integer_values(self):
        self.assertEqual(BOARD.threshold_sums(), {"quiet_sum": 1, "soft_sum": 0xFFFFFFFE, "loud_sum": 0xFFFFFFFF})
        self.assertEqual(BOARD.threshold_sums([11, 16, 28]), {"quiet_sum": 10747, "soft_sum": 15632, "loud_sum": 27356})
        for invalid in ((True, 16, 28), (11, 16.0, 28), (11, 16), (11, 16, 65536),
                        (-1, 16, 28), (16, 16, 28), (11, 28, 16), "11,16,28"):
            with self.subTest(invalid=invalid), self.assertRaises(ValueError):
                BOARD.threshold_sums(invalid)

    def test_fixed_thresholds_are_passed_only_to_local_owner_factory(self):
        with patch.dict(BOARD.os.environ, {"VOL1_ACCEPTANCE_ROOT": "local-unit", "VOL1_ACCEPTANCE_BOOT": "unit-boot",
                                         "VOL1_FIXED_THRESHOLDS": "[11, 16, 28]"}), \
                patch.object(BOARD, "managed_control") as managed:
            BOARD.create()
            self.assertEqual(managed.call_args.kwargs["thresholds"], [11, 16, 28])

    def test_trace_is_explicit_and_check_only_does_not_start(self):
        with patch.dict(BOARD.os.environ, {"VOL1_ACCEPTANCE_ROOT": "local-unit", "VOL1_ACCEPTANCE_BOOT": "unit-boot"}), \
                patch.object(BOARD, "managed_control") as managed:
            BOARD.os.environ.pop("VOL1_STARTUP_TRACE", None)
            BOARD.create()
            self.assertFalse(managed.call_args.kwargs["trace_startup"])
            BOARD.os.environ["VOL1_STARTUP_TRACE"] = "1"
            BOARD.create()
            self.assertTrue(managed.call_args.kwargs["trace_startup"])
        with patch.object(BOARD, "validate_pair"), patch.object(BOARD, "managed_control") as managed, \
                patch.object(sys, "argv", ["voice_volume_board.py", "--root", "local-unit", "--boot-id", "OFFLINE_CHECK_ONLY", "--check-only", "--trace-startup"]):
            self.assertEqual(BOARD.main(), 0)
            managed.assert_not_called()
        self.assertNotIn("pynq", sys.modules)

    def test_dma_register_pair_uses_two_aligned_word_reads(self):
        window = bytearray(4096)
        original = BOARD.ctypes.c_uint32
        original.from_buffer(window, 0x30).value = 69634
        original.from_buffer(window, 0x34).value = 1
        with patch.object(BOARD.ctypes, "c_uint32") as word:
            word.from_buffer.side_effect = original.from_buffer
            self.assertEqual(BOARD.read_dma_registers(window, 0x30), (69634, 1))
            self.assertEqual([call.args[1] for call in word.from_buffer.call_args_list], [0x30, 0x34])
        self.assertEqual(original.from_buffer(window, 0x30).value, 69634)
        self.assertEqual(original.from_buffer(window, 0x34).value, 1)

    def test_checkpoint_persists_order_without_hardware(self):
        with tempfile.TemporaryDirectory() as directory:
            root = pathlib.Path(directory)
            BOARD.checkpoint(root, "overlay_load_begin")
            BOARD.checkpoint(root, "overlay_load_returned")
            entries = [json.loads(line) for line in (root / "startup-phases.jsonl").read_text().splitlines()]
            self.assertEqual([entry["phase"] for entry in entries], ["overlay_load_begin", "overlay_load_returned"])
            self.assertEqual(entries[0]["pid"], entries[1]["pid"])
            self.assertLessEqual(entries[0]["monotonic_ns"], entries[1]["monotonic_ns"])

    def test_import_does_not_load_pynq(self):
        self.assertNotIn("pynq", sys.modules)

    def test_word_register_access_and_bounds(self):
        backend = BOARD.LinuxBackend.__new__(BOARD.LinuxBackend)
        backend.window = bytearray(4096)
        backend.write32(4, 0xC00C0001)
        self.assertEqual(backend.read32(4), 0xC00C0001)
        for offset in (-4, 1, 4096, True):
            with self.subTest(offset=offset), self.assertRaises(ValueError):
                backend.read32(offset)
        for value in (-1, 2**32, True):
            with self.subTest(value=value), self.assertRaises(ValueError):
                backend.write32(0, value)

    def test_explicit_fusion_window_keeps_original_default_and_codec_bus(self):
        fake = types.SimpleNamespace(ioctl=Mock())
        for arguments, address in (({}, 0x43C00000), ({"base_address": 0x43C10000}, 0x43C10000)):
            with self.subTest(address=address), patch.dict(sys.modules, {"fcntl": fake}), \
                    patch.object(BOARD, "Path") as path, patch.object(BOARD.os, "open", side_effect=[101, 102]) as opened, \
                    patch.object(BOARD.os, "close") as closed, patch.object(BOARD.mmap, "mmap") as mapped, \
                    patch.object(BOARD.os, "O_SYNC", 0x101000, create=True), \
                    patch.object(BOARD.os, "O_CLOEXEC", 0x80000, create=True):
                path.return_value.resolve.return_value = "/sys/devices/platform/e0005000.i2c/i2c-1"
                backend = BOARD.LinuxBackend(**arguments)
                mapped.assert_called_once_with(101, 4096, offset=address)
                self.assertEqual(opened.call_args_list[-1].args[0], "/dev/i2c-1")
                backend.close()
                mapped.return_value.close.assert_called_once_with()
                self.assertEqual([call.args[0] for call in closed.call_args_list], [101, 102])
        for address in (True, 0x43C00001, 0x43C20000, "0x43C10000", -1):
            with self.subTest(address=address), self.assertRaises(ValueError):
                BOARD.LinuxBackend(base_address=address)

    def test_fusion_borrows_once_without_overlay_reload_and_closes_after_disable(self):
        operations = []
        session = Mock(build_id=FUSION.BUILD_ID, is_open=True)
        lease = session.borrow.return_value
        lease.bitfile_name = "fused.bit"
        session.ip_address.return_value = (FUSION.BASE_ADDRESS, 4096)
        transport, control, thread = Mock(), Mock(), Mock()
        transport.process.is_alive.return_value = False
        control.monitor.return_value = {"enabled": False, "faults": 0, "ack_error": False}
        thread.is_alive.return_value = False
        control.configure.side_effect = lambda **keywords: operations.append(("configure", keywords["enable"]))
        transport.close.side_effect = lambda: operations.append(("transport", "closed"))
        lease.close.side_effect = lambda: operations.append(("lease", "closed"))
        with patch.object(FUSION, "ProcessTransport", return_value=transport) as factory, \
                patch.object(FUSION, "VolumeControl", return_value=control), \
                patch.object(FUSION, "configure_codec") as codec, patch.object(FUSION.threading, "Thread", return_value=thread):
            owner = FUSION.BorrowedVolumeControl(session, thresholds=(11, 16, 28)).open()
            session.borrow.assert_called_once_with("voice-volume", instances=frozenset({"voice_volume_0"}))
            session.open.assert_not_called()
            self.assertEqual(factory.call_args.args[0].keywords, {"base_address": FUSION.BASE_ADDRESS})
            codec.assert_called_once_with(transport, stopped=True, straps_confirmed=True, mclk_hz=10_000_000)
            self.assertTrue(owner.latch.status()["released"])
            owner.close()
        self.assertEqual(operations, [("configure", False), ("configure", True), ("configure", False),
                                      ("transport", "closed"), ("lease", "closed")])
        self.assertFalse(owner.status()["lease_retained"])

    def test_fusion_rejects_old_build_before_borrowing(self):
        session = Mock(build_id=0xC0060800, is_open=True)
        with self.assertRaisesRegex(RuntimeError, "already-open"):
            FUSION.BorrowedVolumeControl(session, thresholds=(11, 16, 28)).open()
        session.borrow.assert_not_called()

    def test_fusion_retains_overlay_lease_if_disable_fails_but_closes_child(self):
        session = Mock(build_id=FUSION.BUILD_ID, is_open=True)
        lease = session.borrow.return_value
        lease.bitfile_name = "fused.bit"
        session.ip_address.return_value = (FUSION.BASE_ADDRESS, 4096)
        transport, control, thread = Mock(), Mock(), Mock()
        transport.process.is_alive.return_value = False
        thread.is_alive.return_value = False
        with patch.object(FUSION, "ProcessTransport", return_value=transport), \
                patch.object(FUSION, "VolumeControl", return_value=control), \
                patch.object(FUSION, "configure_codec"), patch.object(FUSION.threading, "Thread", return_value=thread):
            owner = FUSION.BorrowedVolumeControl(session, thresholds=(11, 16, 28)).open()
            control.configure.side_effect = RuntimeError("sampling cannot stop")
            with self.assertRaisesRegex(RuntimeError, "retain Overlay lease"):
                owner.close()
        transport.close.assert_called_once_with()
        lease.close.assert_not_called()
        self.assertTrue(owner.status()["lease_retained"])

    def test_combined_i2c_read_and_short_transfer(self):
        backend = BOARD.LinuxBackend.__new__(BOARD.LinuxBackend)
        backend.i2c = 123
        def ioctl(descriptor, request, argument):
            self.assertEqual((descriptor, request), (123, 0x0707))
            transfer = BOARD.I2CTransfer.from_buffer(argument)
            self.assertEqual(transfer.count, 2)
            self.assertEqual(bytes(transfer.messages[0].buffer[:2]), b"\x40\x02")
            self.assertEqual((transfer.messages[1].addr, transfer.messages[1].flags), (0x3B, 1))
            for index, value in enumerate(b"\x00\x00\x00\x00\x28\x03"):
                transfer.messages[1].buffer[index] = value
            return 2
        fake = types.SimpleNamespace(ioctl=ioctl)
        with patch.dict(sys.modules, {"fcntl": fake}):
            self.assertEqual(backend.codec_read(0x4002, 6), b"\x00\x00\x00\x00\x28\x03")
        with patch.dict(sys.modules, {"fcntl": types.SimpleNamespace(ioctl=lambda *arguments: 1)}):
            with self.assertRaisesRegex(RuntimeError, "short"):
                backend.codec_read(0x4002, 6)

    def test_command_write_never_reads_destination(self):
        backend = BOARD.LinuxBackend.__new__(BOARD.LinuxBackend)
        backend.window = bytearray(4096)
        words = Mock(itemsize=4)
        words.__setitem__ = Mock()
        words.__getitem__ = Mock(side_effect=AssertionError("write-only register read"))
        view = Mock()
        view.cast.return_value.__enter__ = Mock(return_value=words)
        view.cast.return_value.__exit__ = Mock(return_value=False)
        with patch.object(BOARD, "memoryview", return_value=view, create=True), \
                patch.object(BOARD.ctypes, "c_uint32") as legacy:
            for offset, value in ((0x20, 1000), (0x24, 3000), (0x28, 500), (0x2C, 0), (0x30, 1)):
                backend.write32(offset, value)
            self.assertEqual([call.args for call in words.__setitem__.call_args_list],
                             [(8, 1000), (9, 3000), (10, 500), (11, 0), (12, 1)])
            words.__getitem__.assert_not_called()
            legacy.from_buffer.assert_not_called()
            words.itemsize = 8
            with self.assertRaisesRegex(RuntimeError, "32-bit"):
                backend.write32(0x30, 1)
            self.assertEqual(words.__setitem__.call_count, 5)

    def test_codec_write_and_limits(self):
        backend = BOARD.LinuxBackend.__new__(BOARD.LinuxBackend)
        backend.i2c = 123
        captured = []
        def ioctl(descriptor, request, argument):
            transfer = BOARD.I2CTransfer.from_buffer(argument)
            captured.append(bytes(transfer.messages[0].buffer[:transfer.messages[0].length]))
            return transfer.count
        with patch.dict(sys.modules, {"fcntl": types.SimpleNamespace(ioctl=ioctl)}):
            self.assertEqual(backend.codec_write(0x4011, b"\x00"), 1)
            self.assertEqual(captured, [b"\x40\x11\x00"])
            for length in (0, 33, True):
                with self.subTest(length=length), self.assertRaises(ValueError):
                    backend.codec_read(0x4000, length)


if __name__ == "__main__":
    unittest.main(verbosity=2)