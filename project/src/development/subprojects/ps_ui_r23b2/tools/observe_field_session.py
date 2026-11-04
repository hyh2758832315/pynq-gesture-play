"""Read-only field recorder. It never starts/stops the board or requests images.

Run: .venv/Scripts/python.exe -B subprojects/ps_ui_r23b2/tools/observe_field_session.py --output-dir build/r14-field-01
Outputs: status.jsonl, summary.json, operator-observations.json on the PC.
Next: collect operator observations, then separately confirm normal OFF/DMA cleanup.
"""
from __future__ import annotations
import argparse
import json
import math
from pathlib import Path
import sys
import time

ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT / 'python'))


def positive(value):
    number = float(value)
    if not math.isfinite(number) or not 0 < number <= 3600:
        raise argparse.ArgumentTypeError('Expected finite seconds in (0, 3600]')
    return number


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output-dir', type=Path, required=True)
    parser.add_argument('--seconds', type=positive, default=1800)
    parser.add_argument('--startup-timeout', type=positive, default=120)
    args = parser.parse_args()
    output = args.output_dir.resolve()
    if not output.is_relative_to((ROOT / 'build').resolve()):
        parser.error('Output must be inside this workspace build directory')
    output.mkdir(parents=True, exist_ok=False)
    pending = {key: {'result': 'PENDING', 'observations': ''} for key in (
        'loading_hdmi', 'paper_rock_scissors_3s', 'latest_only_while_busy',
        'circle_tracking_and_fist', 'return_ring_and_pause', 'result_restart_menu',
        'preview_off_and_resume', 'motion_delay_and_temperature')}
    (output / 'operator-observations.json').write_text(json.dumps(pending, indent=2), encoding='utf-8')
    from pynq_multimodal_game.studio.device import RemoteDeviceSession
    device = RemoteDeviceSession('192.168.2.99', 8765, expected_build_id=0xC0061000,
                                 source_address='192.168.2.1', timeout=3)
    summary = dict(result='OPERATOR_PENDING', board_cleanup_confirmed=False,
                   session=None, child_pid=None, samples=0, error=None,
                   scope='normal RPC status only; no image demand, input, or actuator commands')
    last_display = None
    code = 0
    try:
        startup = time.monotonic()
        while device.connect().state.value != 'ready':
            if time.monotonic() - startup >= args.startup_timeout:
                raise TimeoutError('Agent did not become ready; inspect the loading screen and startup log')
            print('WAITING FOR AGENT; board is not restarted by this recorder', flush=True)
            time.sleep(1)
        began = time.monotonic()
        with (output / 'status.jsonl').open('x', encoding='utf-8') as stream:
            while time.monotonic() - began < args.seconds:
                snapshot = device.video_status()['snapshot']
                vision = snapshot.get('vision') or {}
                hand = vision.get('hand_session')
                if not isinstance(hand, dict) or hand.get('mode') != 'serial-fixed-playback':
                    raise RuntimeError('A real serial hand session is required; this recorder will not enable one')
                if summary['session'] is None:
                    summary['session'] = hand['session']
                if hand['session'] != summary['session']:
                    raise RuntimeError('Hand session changed; preserve this run and start a new recording')
                if summary['child_pid'] is None and hand.get('child_pid') is not None:
                    summary['child_pid'] = hand['child_pid']
                if summary['child_pid'] is not None and hand.get('child_pid') != summary['child_pid']:
                    raise RuntimeError('Hand process changed during the field recording')
                row = dict(pc_monotonic=time.monotonic(), mode=snapshot.get('runtime_mode'),
                           game_tick=snapshot.get('game_tick'), game_status=snapshot.get('game_status'),
                           vision_frame=vision.get('frame_id'), hand=hand,
                           hand_osd=vision.get('hdmi_osd'), last_error=snapshot.get('last_error'))
                stream.write(json.dumps(row) + '\n')
                stream.flush()
                summary['samples'] += 1
                display = (row['mode'], row['game_status'], hand['phase'], hand.get('error'))
                if display != last_display:
                    print('FIELD', *display, 'session=' + hand['session'], flush=True)
                    last_display = display
                if row['last_error'] or hand.get('error') or hand['phase'] == 'FAULT' or (row['hand_osd'] or {}).get('error'):
                    raise RuntimeError(str(row))
                if hand['phase'] in ('CLOSING', 'VERIFYING_RELEASE', 'CLOSED'):
                    summary['ended_because'] = 'hand_session_closing_or_closed'
                    break
                time.sleep(1)
            else:
                summary['ended_because'] = 'recorder_time_limit'
    except KeyboardInterrupt:
        summary['ended_because'] = 'recorder_interrupted'
    except Exception as error:
        summary.update(result='RECORDING_ERROR', error=f'{type(error).__name__}: {error}')
        code = 1
    finally:
        device.disconnect()
        (output / 'summary.json').write_text(json.dumps(summary, indent=2), encoding='utf-8')
        print('Recorder ended; this does not stop the board or confirm DMA/servo cleanup.', flush=True)
    return code


if __name__ == '__main__':
    raise SystemExit(main())
