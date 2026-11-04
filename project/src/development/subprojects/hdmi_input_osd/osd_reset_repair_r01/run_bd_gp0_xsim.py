"""Replay R22 OSD MMIO transactions through the full C6V BD and PS7 BFM.

Run: .venv/Scripts/python.exe -I -B subprojects/hdmi_input_osd/osd_reset_repair_r01/run_bd_gp0_xsim.py --output build/hosd/osd-reset-r01/bd-gp0-sim-r01
Outputs: a fresh output directory containing Vivado source lists, stage logs and receipt.json.
Next: inspect the first failing PS/OSD handshake, or retain the passing full-path result.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import re
import shutil
import subprocess
import time

BASE = Path('E:/vvl/c0e/c6_latency.sim/c0e_arm_sim/behav/xsim')
RTL = Path(__file__).with_name('rtl')
TB = Path(__file__).with_name('tb_osd_bd_gp0.sv')
BIN = Path('D:/Xilinx/Vivado/2026.1/Vivado/bin')
OLD_TB = 'tb_c0e_arm.sv'
SOURCES = ('input_osd_axi.sv', 'input_osd_top.sv',
           'input_osd_ctrl.sv', 'input_osd_pixels.sv')


def absolute_project(source: Path, output: Path) -> None:
    data = source.read_text(encoding='utf-8')

    def resolve(match: re.Match[str]) -> str:
        value = match.group(1)
        if value.startswith('../'):
            return '"' + (BASE / value).resolve().as_posix() + '"'
        return match.group(0)

    data = re.sub(r'"([^"]+)"', resolve, data)
    for name in SOURCES:
        data = re.sub(r'"[^"]*/input_osd_' + name.split('input_osd_')[1] + r'"',
                      '"' + (RTL / name).resolve().as_posix() + '"', data)
    data = re.sub(r'"[^"]*/' + OLD_TB + r'"', '"' + TB.resolve().as_posix() + '"', data)
    if source.name.endswith('_vlog.prj'):
        assert str(TB.resolve().as_posix()) in data
        for name in SOURCES:
            assert str((RTL / name).resolve().as_posix()) in data
    assert OLD_TB not in data
    (output / source.name.replace('tb_c0e_arm', 'tb_osd_bd_gp0')).write_text(data, encoding='utf-8')


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=False)
    for suffix in ('vlog', 'vhdl'):
        absolute_project(BASE / f'tb_c0e_arm_{suffix}.prj', output)
    shutil.copyfile(BASE / 'glbl.v', output / 'glbl.v')
    for suffix in ('*.mem', '*.dat'):
        for item in BASE.glob(suffix):
            shutil.copyfile(item, output / item.name)
    libraries = re.findall(r'-L\s+([^\s]+)',
                           next(line for line in (BASE / 'elaborate.bat').read_text().splitlines()
                                if line.startswith('call xelab')))
    commands = [
        [str(BIN / 'xvlog.bat'), '--relax', '-L', 'uvm', '-L', 'smartconnect_v1_0',
         '-L', 'axi_vip_v1_1_23', '-L', 'processing_system7_vip_v1_0_25',
         '-L', 'xilinx_vip', '-prj', str(output / 'tb_osd_bd_gp0_vlog.prj')],
        [str(BIN / 'xvhdl.bat'), '-prj', str(output / 'tb_osd_bd_gp0_vhdl.prj')],
        [str(BIN / 'xelab.bat'), '--debug', 'typical', '--relax', '--mt', '2',
         *(part for name in libraries for part in ('-L', name)),
         '--snapshot', 'osd_bd_gp0', 'xil_defaultlib.tb_osd_bd_gp0',
         'xil_defaultlib.glbl'],
        [str(BIN / 'xsim.bat'), 'osd_bd_gp0', '-runall'],
    ]
    sources = [TB, *(RTL / name for name in SOURCES),
               Path('E:/vvl/c0e/c6_latency.srcs/sources_1/bd/c6v/c6v.bd')]
    receipt = dict(simulator='XSim 2026.1', mode='full BD PS7 BFM', board_access=False,
                   sources={str(path): hashlib.sha256(path.read_bytes()).hexdigest()
                            for path in sources}, steps=[], passed=False)
    try:
        for index, command in enumerate(commands):
            started = time.monotonic()
            result = subprocess.run(command, cwd=output, capture_output=True,
                                    timeout=(600 if index < 3 else 300))
            transcript = result.stdout.decode(errors='replace') + result.stderr.decode(errors='replace')
            (output / f'step-{index}.log').write_text(transcript, encoding='utf-8')
            receipt['steps'].append(dict(command=command, returncode=result.returncode,
                                         seconds=time.monotonic()-started))
            print(f'OSD_BD_GP0_XSIM_STAGE {index} rc={result.returncode}', flush=True)
            if result.returncode or 'Fatal:' in transcript or 'FATAL:' in transcript:
                raise RuntimeError(f'XSim stage {index} failed: {output / f"step-{index}.log"}')
            if index == 3:
                match = re.search(r'TEST_PASS OSD_BD_GP0 reads=(\d+) writes=(\d+)', transcript)
                if match is None or int(match.group(1)) < 200 or int(match.group(2)) != 7:
                    raise RuntimeError(f'incomplete full BD verdict: {output / "step-3.log"}')
                receipt['reads'], receipt['writes'] = map(int, match.groups())
        receipt['passed'] = True
    finally:
        (output / 'receipt.json').write_text(json.dumps(receipt, indent=2), encoding='utf-8')


if __name__ == '__main__':
    main()
