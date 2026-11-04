"""Offline saved-evidence audit; never opens hardware, network or audio devices.

Run: .venv/Scripts/python subprojects/volume_response_offline/audit.py --output build/volume-response/audit-r01
Output: audit.json and byte-identical RTL baseline copies. Next: run_xsim.py.
"""
import argparse
import ast
from collections import Counter
import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
PACKAGE = ROOT / 'deliveries/c6i-pl-vision-volume-osd-r20-admission-r03-20261023'


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def nodes(value):
    if isinstance(value, dict):
        yield value
        for child in value.values():
            yield from nodes(child)
    elif isinstance(value, list):
        for child in value:
            yield from nodes(child)


def summarize(path):
    data = json.loads(path.read_text(encoding='utf-8'))
    seen, rows, games = set(), [], []
    for node in nodes(data):
        volume = node.get('volume')
        if not isinstance(volume, dict) or 'worker' not in volume:
            continue
        worker = volume.get('worker') or {}
        observation = volume.get('observation') or {}
        snap = observation.get('snapshot') or {}
        identity = (worker.get('producer_run'), worker.get('monitor_sequence'))
        if identity in seen or snap.get('mean_abs') is None:
            continue
        seen.add(identity)
        latch = volume.get('latch') or {}
        receipt = node.get('volume_consumption') or {}
        rows.append(dict(mean_abs=snap['mean_abs'], state=snap['state'],
                         ack_count=worker.get('ack_count', 0), consumed=latch.get('consumed', 0),
                         waiting_armed=latch.get('waiting_armed'), released=latch.get('released'),
                         faults=snap['faults'], ack_error=snap['ack_error'],
                         runtime_mode=node.get('runtime_mode'), game_id=receipt.get('game_id')))
        if receipt:
            games.append(dict(game_id=receipt.get('game_id'), tick=node.get('game_tick'),
                              input=receipt.get('input'), source_receipt=receipt.get('source_receipt')))
    return dict(path=str(path.relative_to(ROOT)), sha256=digest(path), snapshots=len(rows),
                observed_mean_range=None if not rows else [min(r['mean_abs'] for r in rows), max(r['mean_abs'] for r in rows)],
                observed_states=dict(Counter(str(r['state']) for r in rows)),
                observed_modes=dict(Counter(str(r['runtime_mode']) for r in rows)),
                observed_over_soft=sum(r['mean_abs'] >= 16 for r in rows),
                observed_over_loud=sum(r['mean_abs'] >= 28 for r in rows),
                ack_count_range=None if not rows else [min(r['ack_count'] for r in rows), max(r['ack_count'] for r in rows)],
                consumed_max=max((r['consumed'] for r in rows), default=0),
                observed_faults=sorted(set(r['faults'] for r in rows)),
                observed_ack_errors=any(r['ack_error'] for r in rows),
                observed_game_ids=sorted(set(r['game_id'] for r in rows if r['game_id'])),
                limitation='Sparse saved STATUS observations; no synchronized human stimulus or PCM; not detection accuracy.')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=False)
    manifest = json.loads((PACKAGE / 'deployment_manifest.json').read_text())['sha256']
    control = PACKAGE / 'board/pynq_z2/scripts/voice_volume_control.py'
    profile = None
    for node in ast.parse(control.read_text()).body:
        if isinstance(node, ast.Assign) and any(isinstance(t, ast.Name) and t.id == 'MIC_PROFILE' for t in node.targets):
            profile = dict(ast.literal_eval(node.value))
    assert profile is not None
    paths = ['board/pynq_z2/scripts/voice_volume_control.py', 'board/pynq_z2/scripts/voice_volume_runtime.py',
             'board/pynq_z2/scripts/voice_volume_fusion.py', 'python/pynq_multimodal_game/volume_input.py']
    sources = {}
    for relative in paths:
        actual = digest(PACKAGE / relative)
        assert actual.lower() == manifest[relative].lower(), relative
        sources[relative] = actual
    rtl = {}
    (args.output / 'rtl').mkdir()
    for name in ('voice_volume_core.sv', 'voice_volume_i2s_rx.sv', 'voice_volume_top.sv'):
        source = ROOT / 'rtl/voice_volume' / name
        imported = ROOT / 'build/hosd/c0d/c6_osd.srcs/sources_1/imports' / name
        assert source.read_bytes() == imported.read_bytes(), name
        (args.output / 'rtl' / name).write_bytes(source.read_bytes())
        rtl[name] = dict(sha256=digest(source), matches_c0d_import=True,
                         scope='Source baseline comparison, not R20 bitstream/netlist equivalence proof.')
    old = ROOT / 'results/game-validation/game-volume-fusion-20261022/round14/f110-r14-sensitivity.json'
    old_data = json.loads(old.read_text())
    trials = [{k: t[k] for k in ('amplitude', 'repetition', 'peak_mean_abs', 'events_delta', 'processed_us')}
              for t in old_data['trials']]
    evidence = ROOT / 'subprojects/hdmi_input_osd/integration/evidence'
    report = dict(schema='volume-response-offline-audit-v1', board_access=False, source_hashes=sources,
                  rtl=rtl, physical_response_verified=False,
                  codec=dict(registers={hex(k): hex(v) for k, v in profile.items()},
                             pga_db=-12 + .75 * (profile[0x400E] >> 2),
                             mixer_boost_db=20 if (profile[0x400B] >> 3) & 3 == 2 else None,
                             left_enabled=bool(profile[0x400E] & 1), left_unmuted=bool(profile[0x400E] & 2),
                             adc_digital_attenuation_db=-.375 * profile[0x401A],
                             mic_bias_enabled=bool(profile[0x4010] & 1),
                             note='Configured values only; no new board readback or physical jack verification.'),
                  r14=dict(path=str(old.relative_to(ROOT)), sha256=digest(old), trials=trials,
                           trials_with_ack=sum(t['events_delta'] > 0 for t in trials),
                           events_total=sum(t['events_delta'] for t in trials)),
                  r20=[summarize(evidence / (name + '.json')) for name in
                       ('r20-b09-menu-observe', 'r20-b10-studio-observe', 'r20-b11-modes', 'r20-b16-final-menu-observe')])
    (args.output / 'audit.json').write_text(json.dumps(report, indent=2), encoding='utf-8')
    print(json.dumps(dict(output=str(args.output), r14_trials=len(trials), r14_trials_with_ack=report['r14']['trials_with_ack'],
                          codec_pga_db=report['codec']['pga_db'], codec_boost_db=report['codec']['mixer_boost_db'],
                          r20=report['r20']), indent=2))


if __name__ == '__main__':
    main()
