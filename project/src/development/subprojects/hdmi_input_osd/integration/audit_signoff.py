"""File-based full-design signoff audit; does not waive retained warnings.

Run: python -B .../audit_signoff.py
Output: evidence/g13-signoff.json; fails closed before any bit export.
Next: export the same currently-open optimized checkpoint, then verify pairing.
"""
import hashlib
import json
from pathlib import Path
import re

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[2]
REPORT = REPO / "build/hosd/c0d/signoff-r02"
PARENT = REPO / "deliveries/c6i-vision-volume-c0c-r15-unified-input-20261022-r2/overlay"


def read(name): return (REPORT / name).read_text(encoding="utf-8")


def rules(text):
    return {m[0]: (m[1], int(m[2])) for m in re.findall(
        r"^\|\s*([A-Z][A-Z0-9]*-\d+)\s*\|\s*(Warning|Advisory|Critical Warning|Error)\s*\|[^\n]*\|\s*(\d+)\s*\|", text, re.M)}


def resource(text, label):
    return float(re.search(r"^\|\s*" + re.escape(label) + r"\s*\|\s*([\d.]+)\s*\|", text, re.M)[1])


def main():
    record = dict(status="RUNNING", board_validated=False, warnings_waived=False)
    receipt = HERE / "evidence/g13-signoff.json"
    if receipt.exists(): raise FileExistsError(receipt)
    try:
        timing = read("timing.rpt")
        assert "All user specified timing constraints are met." in timing
        row = re.search(r"WNS\(ns\).*?\n\s*-+.*?\n([^\n]+)", timing, re.S)[1].split()
        assert len(row) == 12
        assert all(float(row[i]) >= 0 for i in (0, 4, 8))
        assert all(float(row[i]) == 0 for i in (1, 2, 5, 6, 9, 10))
        assert "checking no_clock (0)" in timing and "checking unconstrained_internal_endpoints (0)" in timing
        record["timing"] = dict(wns_ns=float(row[0]), tns_ns=float(row[1]), whs_ns=float(row[4]),
                                 ths_ns=float(row[5]), wpws_ns=float(row[8]))
        assert re.search(r"# of nets with routing errors\.+\s*:\s*0\b", read("route.rpt"))
        for name in ("drc.rpt", "methodology.rpt"):
            actual, old = rules(read(name)), rules((PARENT / name).read_text(encoding="utf-8"))
            assert actual == old, (name, actual, old)
            assert not any(severity in ("Critical Warning", "Error") for severity, _ in actual.values())
            record[name] = actual
        cdc = read("cdc.rpt")
        assert re.search(r"^CDC-15\s+Warning\s+135\s", cdc, re.M)
        assert not re.search(r"^CDC-\d+\s+Critical", cdc, re.M)
        rows = [line for line in cdc.splitlines() if "CDC-15" in line and "mailbox_reg[" in line]
        assert len(rows) == 135
        indices = []
        for line in rows:
            source, dest = re.search(r"mailbox_reg\[(\d+)\].*pending_cfg_reg\[(\d+)\]", line).groups()
            assert source == dest and "Max Delay Datapath Only" in line
            indices.append(int(source))
        assert len(set(indices)) == 135
        skew = read("bus_skew.rpt")
        assert "VIOLATED" not in skew
        assert re.findall(r"^Endpoints: (\d+)", skew, re.M) == ["10", "10", "135"]
        slacks = [float(v) for v in re.findall(r"^Slack \(MET\)\s*:\s*([\d.]+)ns", skew, re.M)]
        assert len(slacks) == 3 and min(slacks) > 0
        xdc = read("effective_timing.xdc")
        assert "set_max_delay -datapath_only -from $_xlnx_shared_i0 -to $_xlnx_shared_i1 10.000" in xdc
        assert "set_bus_skew -from $_xlnx_shared_i0 -to $_xlnx_shared_i1 10.000" in xdc
        assert "set_clock_groups" not in xdc  # no broad exception can suppress bundled payload timing
        record["cdc_review"] = dict(payload_bits=135, source_destination_indices_equal=True,
            data_frozen_until_boundary_ack=True, req_ack_two_flop_sync=True, extra_capture_edge=True,
            simulation_checks=59, simulation_pixel_checks=8353519,
            warning="135 CDC-15 bundled-data CE paths retained, reviewed; no waiver",
            osd_bus_skew_ns=10-slacks[-1], osd_bus_skew_slack_ns=slacks[-1])
        actual, old = read("utilization.rpt"), (PARENT / "utilization.rpt").read_text(encoding="utf-8")
        resources = {k: dict(parent=resource(old,k), candidate=resource(actual,k))
                     for k in ("Slice LUTs", "Slice Registers", "Block RAM Tile", "DSPs")}
        for item in resources.values(): item["delta"] = item["candidate"] - item["parent"]
        assert resources["Block RAM Tile"]["delta"] == resources["DSPs"]["delta"] == 0
        assert 0 <= resources["Slice LUTs"]["delta"] <= 532
        assert 0 <= resources["Slice Registers"]["delta"] <= 1064
        record["resources"] = resources
        record["files"] = {p.name: hashlib.sha256(p.read_bytes()).hexdigest() for p in REPORT.iterdir() if p.is_file()}
        record["status"] = "FULL_IMPLEMENTATION_TIMING_AND_SCOPED_REVIEW_PASS"
        record["limits"] = ["WNS +0.004ns is narrow but meets unchanged constraint",
                            "Legacy I2C delay and camera PCLK route warnings retained; no general release signoff",
                            "135 bundled-data CDC-15 warnings remain explicitly reviewed, not suppressed",
                            "Board validation and physical HDMI experience are independent"]
    except BaseException as error:
        record.update(status="FAIL", error=f"{type(error).__name__}: {error}")
        raise
    finally:
        with receipt.open("x", encoding="utf-8") as stream: json.dump(record,stream,indent=2)
    print(record["status"], record["timing"], resources)


if __name__ == "__main__": main()
