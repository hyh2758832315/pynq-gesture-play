"""18-second rule capture; identical original setup and fail-retention sequence."""
from pathlib import Path
import json
import time
import uuid
import importlib.util

def helpers(directory):
    spec=importlib.util.spec_from_file_location('_original_rule_capture_helpers',Path(directory)/'pcm_capture_test.py')
    module=importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module

def descriptions(directory): return helpers(directory).descriptions(directory)

def prepare_clean_dma(dma,stopped,owner):
    # Caller supplies the same exact verified audio directory.
    directory=Path('/home/xilinx/jupyter_notebooks/audio_only_capture_test_dmafix_20261011')
    return helpers(directory).prepare_clean_dma(dma,stopped,owner)

def record(directory, *, seconds=18):
    if seconds != 18:
        raise ValueError('Require exactly18 seconds for rule diagnostic')
    from pynq import MMIO, allocate
    from voice_owner import AudioOwner
    from voice_axi_iic import VoiceAxiIIC
    from voice_codec_init import EXPECTED, PLL
    from voice_pcm_sg import VoicePcmSG
    from voice_pynq_binding import PcmBufferPool, CaptureBinding
    from voice_capture_diagnostic import record_diagnostic, save_diagnostic_wav
    desc = descriptions(directory)
    cap = MMIO(desc['voice_capture']['phys_addr'], 0x100)
    dma = MMIO(desc['voice_pcm_dma']['phys_addr'], 0x100)
    iic = MMIO(desc['voice_codec_iic']['phys_addr'], 0x200)
    owner = AudioOwner()

    def stopped(locked):
        if not locked() or cap.read(0) != 0x56535431 or cap.read(0x24) != 0x10001:
            return False
        status = dma.read(0x34)
        return (cap.read(0x28) == 0 and cap.read(0x2c) == 0
                and status & 9 == 9 and status & 0x4770 == 0
                and dma.read(0x30) & 0x1d == 0 and locked() is True)

    owner.acquire(stopped)
    prepare_clean_dma(dma, stopped, owner.confirmed)
    transport = VoiceAxiIIC(iic.read, iic.write,
        description=desc['voice_codec_iic'], owner_confirmed=owner.confirmed,
        stopped_confirmed=lambda: stopped(owner.confirmed))
    transport.initialize(timeout=.05)  # IIC only; does not change Codec profile.

    def pll_ready():
        value = transport.read(0x4002, 6, .01)
        return value[:5] == PLL[:5] and value[5] == 3

    deadline = time.monotonic() + .5
    for reg, value in EXPECTED.items():
        remaining = deadline - time.monotonic()
        if remaining <= 0 or transport.read(reg, 1, remaining) != bytes([value]):
            raise RuntimeError('existing Codec profile verification failed')
    if not pll_ready():
        raise RuntimeError('Codec PLL not ready')
    binding = CaptureBinding(cap, desc['voice_capture'], owner_confirmed=owner.confirmed)
    predicate = owner.confirmed  # exact same bound-method object for pool/driver.
    pool = PcmBufferPool(allocate, owner_confirmed=predicate, count=8)
    driver = VoicePcmSG(dma.read, dma.write, desc['voice_pcm_dma'], pool.slots,
        owner_confirmed=predicate, capture_stopped=binding.stopped,
        set_capture=binding.set_capture, health=binding.health, codec_ready=pll_ready)
    pool.attach(driver)
    print('RECORDING: 18 seconds; follow the rule test timeline after LIVE_READY', flush=True)
    # Failure deliberately retains pool+driver+owner; recorder attempts bounded
    # stop but runner never retries/reset/reloads or frees unconfirmed buffers.
    try:
        pcm, report = record_diagnostic(driver, seconds=seconds)
    except BaseException:
        print('FIRST_DRIVER_FAULT:', driver.fault, flush=True)
        print('FIRST_FAULT_ELAPSED_SECONDS:', driver.fault_elapsed, flush=True)
        print('FIRST_FAULT_CALLBACKS_SECONDS:', driver.fault_callback_trace, flush=True)
        print('CLEANUP_CALLBACKS_SECONDS:', driver.callback_trace, flush=True)
        print('PACKETS_ACCEPTED:', driver.index, 'STOP_CONFIRMED:', driver.release_safe, flush=True)
        raise
    pool.release()
    owner.release(stopped, buffers_safe=lambda: pool.released)
    path = Path(directory) / ('rules_18s_' + uuid.uuid4().hex + '.wav')
    save_diagnostic_wav(path, pcm)
    report.update(wav_path=str(path), buffers_released=True, owner_released=True,
                  codec_register_readback_passed=True, recognition_validated=False)
    print(json.dumps(report, indent=2), flush=True)
