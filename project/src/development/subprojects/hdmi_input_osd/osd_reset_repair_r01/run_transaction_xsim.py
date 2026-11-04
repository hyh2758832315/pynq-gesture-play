"""Run bounded AXI/OSD MMIO transaction stress on XSim 2026.1.

Run: .venv/Scripts/python.exe -I -B subprojects/hdmi_input_osd/osd_reset_repair_r01/run_transaction_xsim.py --rtl subprojects/hdmi_input_osd/osd_reset_repair_r01/rtl --output build/hosd/osd-reset-r01/transaction-stress-r01
Outputs: step-0/1/2.log and receipt.json in fresh output directory.
Next: compare any failing transaction with recovered board fsynced phases.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import time

BIN = Path('D:/Xilinx/Vivado/2026.1/Vivado/bin')
SOURCES = ('input_osd_axi.sv', 'input_osd_top.sv',
           'input_osd_ctrl.sv', 'input_osd_pixels.sv')


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--rtl', required=True, type=Path)
    parser.add_argument('--netlist', type=Path,
                        help='Vivado OOC functional netlist; compile with unisims instead of RTL')
    parser.add_argument('--timing-netlist', type=Path,
                        help='Vivado routed timing netlist with embedded SDF annotation')
    parser.add_argument('--timing-corner', choices=('min', 'typ', 'max'), default='typ')
    parser.add_argument('--output', required=True, type=Path)
    args = parser.parse_args()
    rtl = args.rtl.resolve(strict=True)
    tb = Path(__file__).with_name('tb_osd_axi_transactions.sv').resolve(strict=True)
    if args.netlist and args.timing_netlist:
        parser.error('--netlist and --timing-netlist are mutually exclusive')
    if not args.timing_netlist and args.timing_corner != 'typ':
        parser.error('--timing-corner requires --timing-netlist')
    gate = args.timing_netlist or args.netlist
    files = ([gate.resolve(strict=True)] if gate else
             [rtl / name for name in SOURCES]) + [tb]
    assert all(path.is_file() for path in files)
    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=False)
    commands = [
        [str(BIN / 'xvlog.bat'), '--sv',
         *(['--define', 'GATE_NETLIST', '--define', 'ROUTED_CELL'] if args.timing_netlist else
           ['--define', 'GATE_NETLIST'] if args.netlist else []),
         *(str(path) for path in files)],
        [str(BIN / 'xelab.bat'), 'tb_osd_axi_transactions',
         *(['-L', 'simprims_ver', '-L', 'unisims_ver', 'glbl'] if args.timing_netlist else
           ['-L', 'unisims_ver', 'glbl'] if args.netlist else []),
         *(['--maxdelay'] if args.timing_netlist and args.timing_corner == 'max' else
           ['--mindelay'] if args.timing_netlist and args.timing_corner == 'min' else []),
         '-s', 'osd_axi_transaction_stress', '--mt', 'off'],
        [str(BIN / 'xsim.bat'), 'osd_axi_transaction_stress', '-runall'],
    ]
    receipt = dict(simulator='XSim 2026.1', board_access=False,
                   mode='post-route timing' if args.timing_netlist else
                        'post-synthesis functional' if args.netlist else 'RTL',
                   timing_corner=args.timing_corner if args.timing_netlist else None,
                   sources={str(path): hashlib.sha256(path.read_bytes()).hexdigest() for path in files},
                   steps=[], passed=False)
    try:
        for index, command in enumerate(commands):
            start = time.monotonic()
            result = subprocess.run(command, cwd=output, capture_output=True, timeout=180)
            transcript = result.stdout.decode(errors='replace') + result.stderr.decode(errors='replace')
            (output / f'step-{index}.log').write_text(transcript, encoding='utf-8')
            receipt['steps'].append(dict(command=command, returncode=result.returncode,
                                         seconds=time.monotonic() - start))
            print(f'OSD_TRANSACTION_XSIM_STAGE {index} rc={result.returncode}', flush=True)
            if result.returncode or 'Fatal:' in transcript or 'FATAL:' in transcript:
                raise RuntimeError(f'XSim stage {index} failed: {output / f"step-{index}.log"}')
            if index == 2:
                import re
                match = re.search(r'TEST_PASS OSD_AXI_TRANSACTION_STRESS checks=(\d+)', transcript)
                if match is None or int(match.group(1)) < 150:
                    raise RuntimeError(f'missing complete transaction verdict: {output / "step-2.log"}')
                receipt['checks'] = int(match.group(1))
        receipt['passed'] = True
    finally:
        (output / 'receipt.json').write_text(json.dumps(receipt, indent=2), encoding='utf-8')


if __name__ == '__main__':
    main()
