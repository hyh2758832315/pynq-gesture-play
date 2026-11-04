"""Reuse the exact generated, successfully compiled C0E ARM simulation libraries.

Run: .venv/Scripts/python.exe -B subprojects/hdmi_input_osd/integration/run_latency_video_rate.py
Outputs: build/hosd/c0e-video-rate-r02 with isolated cache, source, generated commands, logs and focused VCD/WDB.
Next: inspect first stall/overflow before changing production RTL. No board access or production project edits.

Credit exhaustion reproduction (prewarm production RTL, no CPU release):
  .venv/Scripts/python.exe -B subprojects/hdmi_input_osd/integration/run_latency_video_rate.py --credit-starvation --dilation subprojects/hdmi_input_osd/latency_rtl/axis_binary_dilate9.sv --output build/hosd/c0e-credit-starvation-r01
Outputs: independent receipt.json, transcripts, focused VCD/WDB in --output.
Next: require the specific starvation reproduction marker, then design admission.

Candidate with actual video IP, skipped frame, resumed frame and normal STOP:
  .venv/Scripts/python.exe -B subprojects/hdmi_input_osd/integration/run_latency_video_rate.py --admission-recovery --dilation subprojects/hdmi_input_osd/latency_rtl/axis_binary_dilate9.sv --output build/hosd/c0e-admission-video-r01
"""
import hashlib
import argparse
import json
from pathlib import Path
import shutil
import subprocess
import time

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[2]
ORIGINAL = Path('E:/vvl/c0e/c6_latency.sim/c0e_arm_sim/behav/xsim')
OUT = REPO / 'build/hosd/c0e-video-rate-r02'
TOOLS = Path('D:/Xilinx/Vivado/2026.1/Vivado/bin')


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    global OUT
    parser = argparse.ArgumentParser()
    parser.add_argument('--output', type=Path, default=OUT)
    parser.add_argument('--dilation', type=Path)
    parser.add_argument('--credit-starvation', action='store_true')
    parser.add_argument('--admission-recovery', action='store_true')
    parser.add_argument('--lines', type=int, default=32, choices=(32,720))
    parser.add_argument('--frames', type=int, default=1, choices=(1,2,3))
    options = parser.parse_args()
    assert not (options.credit_starvation and options.admission_recovery)
    if options.credit_starvation or options.admission_recovery:
        assert options.dilation is not None, 'Starvation test requires the prewarm fix'
        assert sha(options.dilation) == 'c2a60d3490c616762bd76493087ea593fa550a251a170372feb4a5f1f06771a6'
        options.lines, options.frames = 720, 5 if options.admission_recovery else 4
    admission_sources = []
    if options.admission_recovery:
        gate_path = REPO / 'build/hosd/c0e-admission-unit-r01/receipt.json'
        gate = json.loads(gate_path.read_text())
        assert gate['status'] == 'ADMISSION_UNIT_PASS'
        admission_sources = sorted((HERE.parent / 'latency_rtl/admission_r01').glob('*.sv'))
        assert len(admission_sources) == 3
        for source in admission_sources:
            assert sha(source) == gate['sources'][source.name]['sha256']
    OUT = options.output.resolve()
    assert OUT.is_relative_to(REPO / 'build/hosd')
    assert not OUT.exists()
    assert 'TEST_PASS C0E_ARM_NO_VIDEO_STABLE' in (ORIGINAL / 'simulate.log').read_text()
    OUT.mkdir()
    record = dict(status='RUNNING', board_access=False, steps=[], source_sha256={}, cache_sha256={}, error=None)
    try:
        shutil.copytree(ORIGINAL / 'xsim.dir', OUT / 'xsim.dir')
        for path in sorted((OUT / 'xsim.dir').rglob('*')):
            if path.is_file():
                record['cache_sha256'][path.relative_to(OUT).as_posix()] = sha(path)
        for path in ORIGINAL.iterdir():
            if path.is_file() and (path.suffix in ('.dat', '.mem') or path.name == 'xsim.ini'):
                shutil.copyfile(path, OUT / path.name)
                record['source_sha256'][path.name] = sha(path)
        for name in ('compile.bat', 'elaborate.bat', 'tb_c0e_arm_vlog.prj', 'tb_c0e_arm_vhdl.prj'):
            shutil.copyfile(ORIGINAL / name, OUT / ('original-' + name))
            record['source_sha256']['original-' + name] = sha(ORIGINAL / name)
        tb = OUT / 'tb_c0e_video_rate.sv'
        tb_source = HERE / ('tb_c0e_admission_video.sv' if options.admission_recovery else
                            'tb_c0e_credit_starvation.sv' if options.credit_starvation else tb.name)
        tb_text=tb_source.read_text()
        record['testbench_origin'] = dict(path=str(tb_source), sha256=sha(tb_source))
        original='localparam integer ACTIVE_LINES=32, FRAME_COUNT=1, BLANK_LINES=30;'
        assert tb_text.count(original)==1
        tb.write_text(tb_text.replace(original,f'localparam integer ACTIVE_LINES={options.lines}, FRAME_COUNT={options.frames}, BLANK_LINES=30;'),encoding='utf-8')
        record['stimulus']=dict(active_lines=options.lines,frames=options.frames,pixel_clock_period_ns=13.468,line_pixels=1650,blank_lines=30)
        record['source_sha256'][tb.name] = sha(tb)
        tcl = OUT / 'run.tcl'
        tcl.write_text('''log_wave /tb_c0e_video_rate/*
open_vcd first-fault.vcd
log_vcd /tb_c0e_video_rate/overflow /tb_c0e_video_rate/underflow /tb_c0e_video_rate/faults /tb_c0e_video_rate/owner_causes /tb_c0e_video_rate/rv /tb_c0e_video_rate/rr /tb_c0e_video_rate/bv /tb_c0e_video_rate/br /tb_c0e_video_rate/ov /tb_c0e_video_rate/de /tb_c0e_video_rate/vsync /tb_c0e_video_rate/rgb_taken /tb_c0e_video_rate/stalls /tb_c0e_video_rate/line_number
log_vcd /tb_c0e_video_rate/dilation_column /tb_c0e_video_rate/dilation_row /tb_c0e_video_rate/dilation_active /tb_c0e_video_rate/skin_ready /tb_c0e_video_rate/skin_valid
log_vcd /tb_c0e_video_rate/granted /tb_c0e_video_rate/credit /tb_c0e_video_rate/credit_request /tb_c0e_video_rate/axis_enable /tb_c0e_video_rate/packet_frames
run 70 ms
flush_vcd
close_vcd
quit
''')
        if options.admission_recovery:
            script = tcl.read_text().replace('run 70 ms',
                'log_vcd /tb_c0e_video_rate/released_frames /tb_c0e_video_rate/admitted_frames /tb_c0e_video_rate/admitted_pixels /tb_c0e_video_rate/closed_frame_count /tb_c0e_video_rate/closed_pixel_count /tb_c0e_video_rate/source_closed /tb_c0e_video_rate/pipeline_drained /tb_c0e_video_rate/owner_drained /tb_c0e_video_rate/barrier_complete /tb_c0e_video_rate/epoch_sealed /tb_c0e_video_rate/budget_fault /tb_c0e_video_rate/boundary_fault\nrun 100 ms')
            tcl.write_text(script)
            record['unit_gate_sha256'] = sha(gate_path)
        line = next(line for line in (ORIGINAL / 'elaborate.bat').read_text().splitlines() if line.startswith('call xelab '))
        arguments = line.split()[2:]
        arguments = [arg.replace('tb_c0e_arm', 'tb_c0e_video_rate') for arg in arguments]
        overrides = []
        if options.dilation is not None:
            override = OUT / 'axis_binary_dilate9.sv'
            shutil.copyfile(options.dilation.resolve(), override)
            record['source_sha256'][override.name] = sha(override)
            overrides.append(str(override))
        for source in admission_sources:
            override = OUT / source.name
            shutil.copyfile(source, override)
            record['source_sha256'][source.name] = sha(override)
            overrides.append(str(override))
        commands = [[str(TOOLS / 'xvlog.bat'), '--sv', '--work', 'xil_defaultlib', *overrides, str(tb)],
                    [str(TOOLS / 'xelab.bat'), *arguments],
                    [str(TOOLS / 'xsim.bat'), 'tb_c0e_video_rate_behav', '-tclbatch', tcl.as_posix()]]
        for index, command in enumerate(commands):
            started = time.monotonic()
            result = subprocess.run(command, cwd=OUT, capture_output=True,
                                    timeout=2400 if options.admission_recovery else 1800 if options.credit_starvation else 900)
            output = (result.stdout + result.stderr).decode('utf-8', errors='replace')
            (OUT / f'step-{index}.log').write_text(output, encoding='utf-8')
            record['steps'].append(dict(command=command, returncode=result.returncode, seconds=time.monotonic() - started))
            assert result.returncode == 0 and 'Fatal:' not in output and 'FATAL:' not in output, output[-4000:]
            if index == 2:
                assert output.count('TEST_PASS C0E_VIDEO_RATE_') == 1, output[-4000:]
                record['verdict'] = next(line for line in output.splitlines() if 'TEST_PASS C0E_VIDEO_RATE_' in line)
                if options.credit_starvation:
                    assert 'CREDIT_STARVATION_REPRODUCED' in record['verdict']
                if options.admission_recovery:
                    assert 'ADMISSION_RECOVERY' in record['verdict']
            print('VIDEO_RATE_STAGE_PASS', index, flush=True)
        record['status'] = 'ISOLATED_VIDEO_RATE_TEST_TERMINATED'
    except BaseException as error:
        record.update(status='FAIL', error=repr(error))
        raise
    finally:
        (OUT / 'receipt.json').write_text(json.dumps(record, indent=2), encoding='utf-8')
    print(record['verdict'], flush=True)


if __name__ == '__main__':
    main()
