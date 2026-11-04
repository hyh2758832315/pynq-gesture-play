"""Reproduce the upload-module preservation experiment with the delivered Skill.

Run: python -B run_validation.py --out NEW_DIR --vivado PATH_TO_VIVADO
Outputs: configurations, raw logs, receipts.json and result.json in NEW_DIR.
Next: inspect result.json and the first mismatch in variant_b's simulate.log.
Requires Python 3.11 and Vivado/XSim (validated with 2026.1); no board access.
"""
from pathlib import Path
import argparse
import hashlib
import json
import re
import shutil
import subprocess
import sys


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--out', type=Path, required=True)
    parser.add_argument('--vivado', default='vivado')
    args = parser.parse_args()
    root = Path(__file__).resolve().parent
    inputs = root / 'inputs'
    skill = root.parent / 'pynq-pl-preserve/scripts/preserve.py'
    executable = shutil.which(args.vivado)
    if executable is None:
        parser.error('Vivado not found: supply --vivado with the installed launcher')
    out = args.out.resolve()
    if any(c in str(out) + str(root) for c in '{}\r\n'):
        parser.error('Tcl paths must not contain braces or newlines')
    protected = {p.name: sha(p) for p in inputs.glob('*.sv')}
    if set(protected) != {'original.sv', 'variant_a.sv', 'variant_b.sv', 'tb.sv'}:
        parser.error('Expected the four delivered input files')
    out.mkdir(parents=True, exist_ok=False)
    receipts, checks = [], {}

    def save(name, value):
        (out / name).write_text(json.dumps(value, indent=2) + '\n', encoding='utf-8')

    def run(label, argv, cwd):
        log = out / (label + '.log')
        with log.open('w', encoding='utf-8') as handle:
            try:
                code = subprocess.run([str(x) for x in argv], cwd=cwd,
                    stdout=handle, stderr=subprocess.STDOUT, timeout=600).returncode
            except (OSError, subprocess.TimeoutExpired) as exc:
                handle.write('\nRUNNER_ERROR: ' + str(exc) + '\n')
                code = 125
        receipts.append(dict(label=label, argv=[str(x) for x in argv],
            cwd=str(cwd), exit_code=code, log=log.name, log_sha256=sha(log)))
        save('receipts.json', receipts)
        print(label, code, flush=True)
        return code

    marker = 'SCENE2D_UPLOAD_SINK=PASS crc=cbf43926 bytes=9 packets=1'
    for label, source in [('calibration', 'original.sv'), ('variant_a', 'variant_a.sv'),
                          ('variant_b', 'variant_b.sv')]:
        cfg = dict(reference=str(inputs / 'original.sv'),
            sources=[str(inputs / source), str(inputs / 'tb.sv')],
            legacy_top='tb_scene2d_upload_sink', instances=[dict(path='dut', parameters={})],
            clock='aclk', reset='aresetn', reset_active=0, min_checks=20,
            watchdog_ns=1000, legacy_marker=marker, part='xc7z020clg400-1')
        save(label + '.json', cfg)
        target = out / label
        build = run(label + '_build', [sys.executable, '-X', 'utf8', '-B', skill,
            'build', out / (label + '.json'), '--out', target], root)
        sim = verify = 125
        if build == 0:
            sim = run(label + '_vivado', [executable, '-mode', 'batch', '-nojournal',
                '-log', target / 'vivado.log', '-source', target / 'run.tcl'], target)
            verify = run(label + '_verify', [sys.executable, '-X', 'utf8', '-B', skill,
                'verify', target], root)
        transcript = target / 'simulation/preservation.sim/sim_1/behav/xsim/simulate.log'
        body = transcript.read_text(errors='replace') if transcript.exists() else ''
        if label == 'variant_b':
            checks[label] = (build == 0 and sim == 0 and verify == 1
                and 'PRESERVE_OUTPUT_MISMATCH instance=0 port=completed_crc32' in body
                and not (target / 'verified.json').exists())
        else:
            checks[label] = (build == sim == verify == 0 and (target / 'verified.json').exists())

        legacy = out / (label + '_legacy')
        legacy.mkdir()
        (legacy / 'guard.sv').write_text('`timescale 1ns/1ps\nmodule legacy_guard;\n'
            'tb_scene2d_upload_sink legacy();\n'
            'initial begin #1000; $fatal(1,"LEGACY_WATCHDOG"); end\nendmodule\n')
        def tp(path):
            return '{' + path.as_posix() + '}'
        (legacy / 'run.tcl').write_text('\n'.join([
            '# Run: vivado -mode batch -source run.tcl',
            '# Outputs: simulation/ logs; next inspect the packet terminal assertion.',
            f'create_project legacy_packet {tp(legacy / "simulation")} -part xc7z020clg400-1',
            f'add_files [list {tp(inputs / source)} {tp(inputs / "tb.sv")}]',
            f'add_files -fileset sim_1 {tp(legacy / "guard.sv")}',
            'set_property top legacy_guard [get_filesets sim_1]',
            'set_property target_simulator XSim [current_project]',
            'set_property xsim.simulate.runtime all [get_filesets sim_1]',
            'update_compile_order -fileset sim_1',
            'launch_simulation -simset sim_1 -mode behavioral',
            'close_sim', 'close_project', '']), encoding='utf-8')
        code = run(label + '_legacy_vivado', [executable, '-mode', 'batch', '-nojournal',
            '-log', legacy / 'vivado.log', '-source', legacy / 'run.tcl'], legacy)
        transcript = legacy / 'simulation/legacy_packet.sim/sim_1/behav/xsim/simulate.log'
        body = transcript.read_text(errors='replace') if transcript.exists() else ''
        checks[label + '_legacy'] = (code == 0 and marker in body and '$finish called' in body
            and re.search(r'\b(?:fatal|error)\s*:', body, re.I) is None
            and 'LEGACY_WATCHDOG' not in body)
        save(label + '_legacy_receipt.json', dict(pass_assertions=checks[label + '_legacy'],
            transcript=str(transcript), sha256=sha(transcript) if transcript.exists() else None))

    checks['inputs_unchanged'] = protected == {p.name: sha(p) for p in inputs.glob('*.sv')}
    result = dict(status='PASS' if all(checks.values()) else 'FAIL', checks=checks,
        inputs_sha256=protected, skill_script_sha256=sha(skill),
        scope='Finite preservation and deliberate defect detection under the supplied stimulus')
    save('result.json', result)
    print(json.dumps(result, indent=2))
    return 0 if all(checks.values()) else 1


if __name__ == '__main__':
    raise SystemExit(main())
