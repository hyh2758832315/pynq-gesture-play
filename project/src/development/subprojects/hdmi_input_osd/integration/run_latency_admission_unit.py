"""Build the admission unit test in an independent copy of generated XSim libraries.

Run: .venv/Scripts/python.exe -B subprojects/hdmi_input_osd/integration/run_latency_admission_unit.py --output build/hosd/c0e-admission-unit-r01
Output: exclusive directory with source hashes, commands, logs, VCD/WDB and receipt.
Next: if unit checks pass, test the candidate with actual generated video IP.
No board access, project edits, or changes to frozen packages.
"""
import argparse
import hashlib
import json
from pathlib import Path
import shutil
import subprocess
import time

from run_latency_video_rate import ORIGINAL, REPO, TOOLS, HERE


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--negative-overadmission', action='store_true',
                        help='Mutate only the isolated copy to bypass capacity; require the checker to reject it')
    options = parser.parse_args()
    out = options.output.resolve()
    assert out.is_relative_to(REPO / 'build/hosd') and not out.exists()
    assert 'TEST_PASS C0E_ARM_NO_VIDEO_STABLE' in (ORIGINAL / 'simulate.log').read_text()
    out.mkdir()
    receipt = dict(status='RUNNING', board_access=False, sources={}, cache_sha256={}, steps=[])
    try:
        shutil.copytree(ORIGINAL / 'xsim.dir', out / 'xsim.dir')
        for path in sorted((out / 'xsim.dir').rglob('*')):
            if path.is_file():
                receipt['cache_sha256'][path.relative_to(out).as_posix()] = sha(path)
        for path in ORIGINAL.iterdir():
            if path.is_file() and (path.suffix in ('.dat', '.mem') or path.name == 'xsim.ini'):
                shutil.copyfile(path, out / path.name)
        original_command = ORIGINAL / 'elaborate.bat'
        shutil.copyfile(original_command, out / 'original-elaborate.bat')
        receipt['original_command_sha256'] = sha(original_command)
        sources = sorted((HERE.parent / 'latency_rtl/admission_r01').glob('*.sv'))
        assert len(sources) == 3
        sources.append(REPO / 'build/hosd/c0e/prewarm-package-restore-r01/overlay/pl-vision-source/vision_source_budget_cdc.sv')
        sources.append(HERE / 'tb_c0e_admission_unit.sv')
        copied = []
        for source in sources:
            target = out / source.name
            shutil.copyfile(source, target)
            if options.negative_overadmission and source.name == 'vision_source_admission.sv':
                original = target.read_text()
                assert original.count('&& slot_available &&') == 1
                target.write_text(original.replace('&& slot_available &&', "&& 1'b1 &&"))
                receipt['negative_control'] = dict(mutation='Bypass slot_available only in copied admission source',
                                                   original_sha256=sha(source), mutated_sha256=sha(target))
            copied.append(str(target))
            receipt['sources'][source.name] = dict(origin=str(source), sha256=sha(target))
        tcl = out / 'run.tcl'
        tcl.write_text('log_wave /tb_c0e_admission_unit/*\nopen_vcd admission.vcd\nlog_vcd /tb_c0e_admission_unit/*\nrun 2 ms\nflush_vcd\nclose_vcd\nquit\n')
        args = next(line for line in original_command.read_text().splitlines() if line.startswith('call xelab ')).split()[2:]
        args = [arg.replace('tb_c0e_arm', 'tb_c0e_admission_unit') for arg in args]
        commands = [[str(TOOLS / 'xvlog.bat'), '--sv', '--work', 'xil_defaultlib', *copied],
                    [str(TOOLS / 'xelab.bat'), *args],
                    [str(TOOLS / 'xsim.bat'), 'tb_c0e_admission_unit_behav', '-tclbatch', tcl.as_posix()]]
        for index, command in enumerate(commands):
            started = time.monotonic()
            result = subprocess.run(command, cwd=out, capture_output=True, timeout=180)
            log = (result.stdout + result.stderr).decode('utf-8', errors='replace')
            (out / f'step-{index}.log').write_text(log, encoding='utf-8')
            receipt['steps'].append(dict(command=command, returncode=result.returncode, seconds=time.monotonic()-started))
            if index == 2 and options.negative_overadmission:
                assert result.returncode in (0, 1), log[-4000:]
                assert log.count('Fatal:') == 1 and 'FRAME_SELECTION_CHANGED selected=0 actual=1' in log, log[-4000:]
                assert 'TEST_PASS' not in log, log[-4000:]
                receipt['verdict'] = 'EXPECTED_FAILURE: capacity-bypass mutation rejected at the first skipped frame'
                break
            assert result.returncode == 0 and 'Fatal:' not in log and 'FATAL:' not in log, log[-4000:]
            if index == 2:
                assert log.count('TEST_PASS C0E_ADMISSION_UNIT ') == 1, log[-4000:]
                receipt['verdict'] = next(line for line in log.splitlines() if 'TEST_PASS C0E_ADMISSION_UNIT ' in line)
            print('ADMISSION_UNIT_STAGE_PASS', index, flush=True)
        receipt['status'] = 'ADMISSION_NEGATIVE_CONTROL_REJECTED' if options.negative_overadmission else 'ADMISSION_UNIT_PASS'
    except BaseException as error:
        receipt.update(status='FAIL', error=repr(error))
        raise
    finally:
        (out / 'receipt.json').write_text(json.dumps(receipt, indent=2), encoding='utf-8')
    print(receipt['verdict'], flush=True)


if __name__ == '__main__':
    main()
