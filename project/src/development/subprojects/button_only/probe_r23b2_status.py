"""Record read-only R23b2 agent status while it runs on PYNQ-Z2.

Run: .venv/Scripts/python.exe -B subprojects/button_only/probe_r23b2_status.py --output build/button_only/r23b2-status-UNIQUE.json
Output: JSON with HELLO, STATUS and host timestamp at the requested path.
Next: compare two receipts for rising capture/OSD counters and button events.
"""

import argparse
import json
from pathlib import Path
import sys
import time
from uuid import uuid4

ROOT = Path(__file__).resolve().parents[2]
PACKAGE = ROOT / 'deliveries/c6i-pl-vision-button-osd-r23b2-shared-id-boardtest-20261024'
sys.path.insert(0, str(PACKAGE / 'python'))
from pynq_multimodal_game.agent.core import AgentCommand  # noqa: E402
from pynq_multimodal_game.agent.transport import AgentClient  # noqa: E402


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument('--output', required=True, type=Path)
    args = parser.parse_args()
    client = AgentClient('192.168.2.99', 8765, timeout=8, source_address='192.168.2.1')
    try:
        hello = client.connect()
        result = client.command('r23b2-probe-' + uuid4().hex, AgentCommand.STATUS)
    finally:
        client.close()
    if not result['ok'] or hello['build_id'] != 0xC0061000:
        raise RuntimeError('R23b2 board identity/status failed')
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with args.output.open('x', encoding='utf-8') as output:
        json.dump({'unix_time': time.time(), 'hello': hello, 'result': result},
                  output, ensure_ascii=False, indent=2)
    snap = result['snapshot']
    print(json.dumps({'state': snap['state'], 'mode': snap['runtime_mode'],
                      'capture': snap['vision']['capture']['captured'],
                      'osd_commits': snap['vision']['hdmi_osd']['commits'],
                      'button_events': snap['vision']['buttons']['sequence'],
                      'last_error': snap['last_error']}, ensure_ascii=False))


if __name__ == '__main__':
    main()
