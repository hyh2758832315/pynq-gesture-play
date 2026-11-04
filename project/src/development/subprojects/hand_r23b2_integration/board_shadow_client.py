"""Read the frozen R23b2 Agent and run one already installed game for shadow observation.

Run: .venv/Scripts/python.exe -B subprojects/hand_r23b2_integration/board_shadow_client.py list|run-game2|pause --output NEW.json
Output: an exclusive JSON Agent response and timestamp.
Next: inspect board shadow publisher/receiver receipts and compare STATUS counters.
"""

import argparse
import json
from pathlib import Path
import sys
import time
from uuid import uuid4

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'deliveries/c6i-pl-vision-button-osd-r23b2-shared-id-boardtest-20261024/python'))
from pynq_multimodal_game.agent.core import AgentCommand  # noqa: E402
from pynq_multimodal_game.agent.transport import AgentClient  # noqa: E402


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action', choices=('list', 'run-game2', 'pause'))
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    client = AgentClient('192.168.2.99', 8765, timeout=12, source_address='192.168.2.1')
    try:
        hello = client.connect()
        if hello['build_id'] != 0xC0061000:
            raise RuntimeError('Unexpected build ID')
        if args.action == 'list':
            response = client.command(uuid4().hex, AgentCommand.LIBRARY_LIST, library_kind='game')
        elif args.action == 'run-game2':
            listing = client.command(uuid4().hex, AgentCommand.LIBRARY_LIST, library_kind='game')
            if not listing['ok']:
                raise RuntimeError(listing)
            matches = [item for item in listing['library_items']
                       if 'game2' in (item['item_id'] + item.get('display_name', '')).lower()]
            if len(matches) != 1:
                raise RuntimeError(f'Expected one Game2 package, found {matches}')
            response = client.command(uuid4().hex, AgentCommand.LIBRARY_RUN,
                                      item_id=matches[0]['item_id'], library_kind='game')
        else:
            response = client.command(uuid4().hex, AgentCommand.GAME_PAUSE)
    finally:
        client.close()
    if not response['ok']:
        raise RuntimeError(response)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with args.output.open('x', encoding='utf-8') as output:
        json.dump({'action': args.action, 'unix_time': time.time(), 'hello': hello,
                   'response': response}, output, ensure_ascii=False, indent=2)
    print(json.dumps({'action': args.action, 'state': response['snapshot']['state'],
                      'mode': response['snapshot']['runtime_mode'],
                      'library_items': [item['item_id'] for item in (response.get('library_items') or [])]},
                     ensure_ascii=False), flush=True)


if __name__ == '__main__':
    main()
