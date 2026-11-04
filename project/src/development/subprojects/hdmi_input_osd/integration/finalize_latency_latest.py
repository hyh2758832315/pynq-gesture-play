"""Freeze tested R19 software with the exact signed R18 hardware.

Run: .venv/Scripts/python.exe -B subprojects/hdmi_input_osd/integration/finalize_latency_latest.py
Outputs: R19 ZIP, independent latest-package-restore-r01 and immutable receipts.
Next: CPU-only ARM contracts before recovering/reloading the board.
"""
import ast
import json
from pathlib import Path
import finalize_latency_candidate as base

HERE = Path(__file__).resolve().parent
TARGET = base.REPO / 'deliveries/c6i-pl-vision-volume-osd-r19-latest-20261023'
PARENT = TARGET.with_name('c6i-pl-vision-volume-osd-r18-prewarm-20261023.zip')


def main():
    assert base.sha(PARENT) == '7619be5d51043b3289906784c1d8add6d11601840c9897c462c5b9b27c097a8b'
    contract = base.load(base.EVIDENCE / 'latency-latest-contract-r02.json')
    assert contract['status'] == 'LATEST_CAPTURE_PC_CONTRACT_PASS'
    for name, digest in contract['source_sha256'].items():
        assert base.sha(TARGET / name) == digest
    # Carry the exact tested pure-CPU contracts in the board package. Only their
    # source-root/import adapters change; assertions and test stimuli stay exact.
    capture = (HERE / 'test_latest_capture.py').read_text(encoding='utf-8')
    capture = capture.replace("Path(__file__).resolve().parents[1] / 'latency_runtime/vision_latest_capture.py'",
                              "Path(__file__).resolve().parents[1] / 'board/pynq_z2/vision_latest_capture.py'")
    runtime = (HERE / 'test_latest_runtime.py').read_text(encoding='utf-8')
    runtime = runtime.replace("Path(__file__).resolve().parents[3] / 'deliveries/c6i-pl-vision-volume-osd-r19-latest-20261023'",
                              'Path(__file__).resolve().parents[1]')
    runtime = runtime.replace('from test_latest_capture import ', 'from latest_capture_contract import ')
    for name, source in (('latest_capture_contract.py', capture), ('latest_runtime_contract.py', runtime)):
        ast.parse(source, filename=name, feature_version=(3, 10))
        with (TARGET / 'tools' / name).open('x', encoding='utf-8') as stream:
            stream.write(source)
    base.TARGET = TARGET
    base.ROOT = base.REPO / 'build/hosd/c0e/prewarm-r01'
    base.REPORT = base.ROOT / 'signoff'
    base.RECEIPT = base.EVIDENCE / 'latency-latest-package-r01.json'
    base.RESTORED = base.REPO / 'build/hosd/c0e/latest-package-restore-r01'
    base.REVIEW_RECEIPT = base.EVIDENCE / 'latency-prewarm-signoff-r01.json'
    base.PAIR_RECEIPT = base.EVIDENCE / 'latency-latest-pair-r01.json'
    base.VERIFICATION_RECEIPTS = ('latency-prewarm-signoff-r01.json', 'latency-latest-contract-r02.json',
        'latency-source-contract-r03.json', 'latency-games-r01.json', 'latency-bgr-packet-decode-r02.json')
    base.CANDIDATE_WARNING = 'Latest-frame software and signed prewarm hardware paired. ARM/board throughput, STOP, GPU coexistence and physical latency acceptance remain pending.'
    base.main()


if __name__ == '__main__':
    main()
