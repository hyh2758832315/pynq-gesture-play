"""Run: python -B tools/check_hardware.py build/output/rebuild_01/result

Outputs hardware_check.json and canonical XSA bit/HWH in the result folder.
Verifies timing, route, DRC, configuration payload identity, GPIO/BUILD_ID
topology and software-facing memory ranges before writing either export.
Next: physical validation separately; this script never accesses a board.
"""
from pathlib import Path
import argparse
import hashlib
import importlib.util
import json
from xml.etree import ElementTree as ET
from zipfile import ZipFile

ROOT = Path(__file__).resolve().parents[1]

def interface(data):
    tree = ET.fromstring(data)
    return sorted(tuple(sorted(item.attrib.items())) for item in tree.iter('MEMRANGE'))

def configuration_payload(data):
    # Strictly parse the tagged .bit container; a-d are metadata, e is data.
    if len(data)<16 or data[:11]!=bytes.fromhex('00090ff00ff00ff00ff000'):
        raise ValueError('Unexpected bit container prefix')
    pos=11
    if data[pos:pos+2]!=b'\x00\x01': raise ValueError('Unexpected bit tag length')
    pos+=2
    for expected in b'abcde':
        if pos>=len(data) or data[pos]!=expected: raise ValueError('Unexpected bit tag')
        pos+=1
        width=4 if expected==ord('e') else 2
        if pos+width>len(data): raise ValueError('Truncated bit length')
        size=int.from_bytes(data[pos:pos+width],'big');pos+=width
        if pos+size>len(data): raise ValueError('Truncated bit data')
        if expected==ord('e'):
            if pos+size!=len(data): raise ValueError('Unexpected bit trailer')
            return data[pos:]
        pos+=size
    raise ValueError('Missing configuration data')

def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('result',type=Path)
    args = p.parse_args()
    path = args.result.resolve()
    module_path = ROOT/'src/development/subprojects/button_only/finalize_button_shared_delivery.py'
    spec = importlib.util.spec_from_file_location('hardware_checks', module_path)
    helpers = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(helpers)
    timing = helpers.read_timing(path/'timing.rpt')
    import re
    if not re.search(r'nets with routing errors\.*\s*:\s*0\s*:',(path/'route.rpt').read_text()):
        raise ValueError('Routing errors')
    if re.search(r'(?m)^\|\s*\S+\s*\|\s*(?:Error|Critical Warning)\s*\|',(path/'drc.rpt').read_text()):
        raise ValueError('DRC failed')
    skew_report=(path/'bus_skew.rpt').read_text()
    skew_slacks=[float(x) for x in re.findall(r'(?m)^\s*(?:Slow|Fast)\s+-?\d+\.\d+\s+-?\d+\.\d+\s+(-?\d+\.\d+)\s*$',skew_report)]
    if not skew_slacks or min(skew_slacks)<0 or 'VIOLATED' in skew_report:
        raise ValueError('Bus skew failed or report is missing constraints')
    with ZipFile(path/'c6v_candidate.xsa') as archive:
        bit = helpers.xsa_member(archive,'.bit')
        hwh = helpers.xsa_member(archive,'c6v.hwh')
    helpers.verify_hwh(hwh)
    standalone=(path/'c6v_candidate.bit').read_bytes()
    if configuration_payload(bit)!=configuration_payload(standalone):
        raise ValueError('XSA configuration payload mismatch')
    frozen = (ROOT/'board/runtime/overlay/c6v_candidate.hwh').read_bytes()
    if interface(hwh) != interface(frozen):
        raise ValueError('Software memory interface differs from frozen hardware')
    # Checkpoint-mode export regenerates a .bit with fresh date/time metadata.
    # Only after payload and interface checks, take bit/HWH from the same XSA.
    (path/'c6v_candidate.bit').write_bytes(bit)
    (path/'c6v_candidate.hwh').write_bytes(hwh)
    result = dict(result='PASS',timing=timing,bus_skew_min_slack_ns=min(skew_slacks),software_memranges_equal=True,physical_test=False,
                  configuration_payload_equal=True,normalized_bit_header=bit!=standalone,
                  standalone_bit_sha256=hashlib.sha256(standalone).hexdigest(),
                  sha256={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in path.iterdir() if p.suffix in ('.dcp','.bit','.hwh','.xsa')})
    (path/'hardware_check.json').write_text(json.dumps(result,indent=2)+'\n','utf-8')
    print(json.dumps(result))

if __name__ == '__main__': main()
