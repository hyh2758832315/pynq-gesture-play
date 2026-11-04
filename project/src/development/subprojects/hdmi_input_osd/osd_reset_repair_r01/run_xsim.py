"""Reproduce the R21 OSD reset-held AXI read and verify a repair with XSim.

Run: .venv/Scripts/python.exe -I -B subprojects/hdmi_input_osd/osd_reset_repair_r01/run_xsim.py --bin D:/Xilinx/Vivado/2026.1/Vivado/bin --rtl deliveries/c6i-pl-vision-volume-osd-r21-marker-r02-20261023/overlay/osd-source --output build/hosd/osd-reset-r01/baseline --expect-blocked
For a repair, pass its RTL directory, a fresh output directory, and omit --expect-blocked.
Output: three full stage logs plus an immutable receipt.json with source hashes.
Next: compare the same stimulus on frozen and repaired RTL; do not infer board success.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import time

SOURCES = ('input_osd_axi.sv', 'input_osd_top.sv', 'input_osd_ctrl.sv', 'input_osd_pixels.sv')

def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--bin', type=Path, required=True)
    parser.add_argument('--rtl', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--expect-blocked', action='store_true')
    parser.add_argument('--regression', action='store_true',
                        help='run the original R21 OSD AXI/pixel regression instead')
    parser.add_argument('--full-hdmi', action='store_true')
    args = parser.parse_args()
    assert not args.expect_blocked or not args.regression
    assert not args.full_hdmi or args.regression
    rtl = args.rtl.resolve(strict=True)
    tb = ((Path(__file__).resolve().parents[1] / 'marker_visibility_r02/sim/tb_input_osd.sv')
          if args.regression else Path(__file__).with_name('tb_osd_axi_pixel_reset.sv')).resolve(strict=True)
    sources = [rtl / name for name in SOURCES] + [tb]
    assert all(path.is_file() for path in sources)
    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=False)
    snapshot = 'osd_regression' if args.regression else 'osd_reset_repro'
    commands = [
        [str(args.bin / 'xvlog.bat'), '--sv',
         *(['--define', 'EXPECT_BLOCKED'] if args.expect_blocked else []),
         *(['--define', 'FULL_HDMI'] if args.full_hdmi else []),
         *(str(path) for path in sources)],
        [str(args.bin / 'xelab.bat'),
         'tb_input_osd' if args.regression else 'tb_osd_axi_pixel_reset',
         '-s', snapshot, '--mt', 'off'],
        [str(args.bin / 'xsim.bat'), snapshot, '-runall'],
    ]
    receipt = dict(simulator='XSim 2026.1', board_access=False,
                   expected_blocked=args.expect_blocked,
                   regression=args.regression, full_hdmi=args.full_hdmi,
                   sources={str(path): hashlib.sha256(path.read_bytes()).hexdigest() for path in sources},
                   steps=[], passed=False)
    try:
        for index, command in enumerate(commands):
            begin = time.monotonic()
            result = subprocess.run(command, cwd=output, capture_output=True, timeout=180)
            transcript = result.stdout.decode(errors='replace') + result.stderr.decode(errors='replace')
            (output / f'step-{index}.log').write_text(transcript, encoding='utf-8')
            receipt['steps'].append(dict(command=command, returncode=result.returncode,
                                         seconds=time.monotonic()-begin))
            print(f'OSD_RESET_STAGE {index} rc={result.returncode}', flush=True)
            if result.returncode or 'Fatal:' in transcript or 'FATAL:' in transcript:
                raise RuntimeError(f'XSim stage {index} failed: {output / f"step-{index}.log"}')
            if index == 2:
                expected = (f'TEST_PASS OSD_AXI_PIXEL_RESET expected_blocked={int(args.expect_blocked)}'
                            if not args.regression else 'TEST_PASS input_osd ')
                if transcript.count(expected) != 1:
                    raise RuntimeError(f'missing unique terminal verdict: {output / "step-2.log"}')
                receipt['verdict'] = expected
                print(expected, flush=True)
        receipt['passed'] = True
    finally:
        (output / 'receipt.json').write_text(json.dumps(receipt, indent=2), encoding='utf-8')

if __name__ == '__main__':
    main()
