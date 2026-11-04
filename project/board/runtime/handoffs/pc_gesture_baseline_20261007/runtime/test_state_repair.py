import hashlib
import json
import pytest
from start_jump_board_test import repaired_state


def test_repair_retains_shutdown_and_psddr_and_hash(tmp_path):
    bit = tmp_path / 'c6v_candidate.bit'
    bit.write_bytes(b'verified bit fixture')
    old = '/tmp/voice-view-c6i-vision-fixture/c6v_candidate.bit'
    state = dict(bitfile_name=old, active_name=old, timestamp='old',
                 bitfile_hash=hashlib.sha1(bit.read_bytes()).hexdigest(),
                 shutdown_ips={'dma': {'name': 'dma', 'base_addr': 123}}, psddr={'a': 4})
    fixed = json.loads(repaired_state(json.dumps(state), bit))
    assert fixed['bitfile_name'] == str(bit.resolve())
    assert fixed['active_name'] == str(bit.resolve())
    for key in ('timestamp', 'bitfile_hash', 'shutdown_ips', 'psddr'):
        assert fixed[key] == state[key]
    assert repaired_state(json.dumps(fixed), bit) is None


@pytest.mark.parametrize('path', ['/tmp/unrelated/c6v_candidate.bit', '/tmp/voice-view-c6i-vision-x/other.bit'])
def test_unrelated_state_rejected(tmp_path, path):
    bit = tmp_path / 'bit'
    bit.write_bytes(b'bit')
    state = dict(bitfile_name=path, bitfile_hash=hashlib.sha1(b'bit').hexdigest())
    with pytest.raises(ValueError, match='unrelated'):
        repaired_state(json.dumps(state), bit)


def test_wrong_hash_rejected(tmp_path):
    bit = tmp_path / 'bit'
    bit.write_bytes(b'bit')
    state = dict(bitfile_name='/tmp/voice-view-c6i-vision-x/c6v_candidate.bit', bitfile_hash='wrong')
    with pytest.raises(ValueError, match='hash differs'):
        repaired_state(json.dumps(state), bit)
