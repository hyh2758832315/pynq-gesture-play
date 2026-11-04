import sys
import tempfile
from pathlib import Path
from types import SimpleNamespace
import unittest
from unittest.mock import patch
import run_accel_guarded as guard


class Registers(bytearray):
    def __enter__(self):return self
    def __exit__(self,*args):return False


class GuardTests(unittest.TestCase):
    def test_not_current_overlay_skips_mmio(self):
        with patch.dict(sys.modules,{'pynq':SimpleNamespace(PL=SimpleNamespace(bitfile_name=''))}):
            with patch.object(guard.os,'open') as opened:
                self.assertFalse(guard.halt_engines(Path('/unused.hwh')))
                opened.assert_not_called()

    def test_both_engines_both_directions_halt(self):
        with tempfile.TemporaryDirectory() as directory:
            hwh=Path(directory)/'new.hwh'
            hwh.write_text('<ROOT><MODULE INSTANCE="moments_dma"><PARAMETER NAME="C_BASEADDR" VALUE="0x40400000"/></MODULE><MODULE INSTANCE="frame_dma"><PARAMETER NAME="C_BASEADDR" VALUE="0x43000000"/></MODULE></ROOT>')
            maps=[]
            def mapped(*args,**kwargs):
                regs=Registers(4096)
                for cr in (0,0x30):regs[cr:cr+4]=(0x81).to_bytes(4,'little')
                for sr in (4,0x34):regs[sr:sr+4]=(1).to_bytes(4,'little')
                maps.append(regs);return regs
            pl=SimpleNamespace(bitfile_name=str(hwh.with_suffix('.bit')))
            with patch.dict(sys.modules,{'pynq':SimpleNamespace(PL=pl)}), patch.object(guard.os,'O_SYNC',0,create=True), patch.object(guard.os,'open',return_value=9), patch.object(guard.os,'close'), patch.object(guard.mmap,'mmap',side_effect=mapped):
                self.assertTrue(guard.halt_engines(hwh))
            self.assertEqual(len(maps),2)
            for regs in maps:
                for cr in (0,0x30):self.assertEqual(int.from_bytes(regs[cr:cr+4],'little'),0x80)


    @patch.object(guard.signal,'SIGSTOP',19,create=True)
    def test_unconfirmed_or_failed_halt_retains_stopped_child(self):
        from unittest.mock import Mock
        for failure in (False,TimeoutError('halt failed')):
            child=Mock(pid=99)
            with patch.object(guard,'halt_engines',side_effect=failure if isinstance(failure,Exception) else None,return_value=False):
                with self.assertRaisesRegex(RuntimeError,'remains STOPPED'):
                    guard.halt_child_or_retain(child,Path('/unused.hwh'))
            child.send_signal.assert_called_once_with(guard.signal.SIGSTOP)
            child.kill.assert_not_called();child.wait.assert_not_called()

    @patch.object(guard.signal,'SIGSTOP',19,create=True)
    def test_confirmed_halt_before_kill(self):
        from unittest.mock import Mock
        child=Mock(pid=100)
        with patch.object(guard,'halt_engines',return_value=True):
            guard.halt_child_or_retain(child,Path('/unused.hwh'))
        child.kill.assert_called_once();child.wait.assert_called_once()


if __name__=='__main__':unittest.main()
