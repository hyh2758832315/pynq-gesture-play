"""Extract full C0E STA/route evidence without claiming complete hardware signoff.

Run: .venv/Scripts/python.exe -B subprojects/hdmi_input_osd/integration/audit_latency_timing.py
     --reports build/hosd/c0e/preroute-r04/results --receipt <new JSON path>
Output: exclusive JSON with measured setup/hold/pulse, route and constraint facts.
Next: full CDC/bus-skew/DRC/methodology/resource review, then paired export only if all gates pass.
"""
import argparse
import hashlib
import json
from pathlib import Path
import re


def active_xdc(path):
    # Ignore generated headers/blank lines only; never normalize away constraint values.
    return [line.strip() for line in path.read_text(encoding="utf-8").splitlines()
            if line.strip() and not line.lstrip().startswith("#")]


def extract(reports):
    timing = (reports / "timing_summary.rpt").read_text(encoding="utf-8")
    route = (reports / "route_status.rpt").read_text(encoding="utf-8")
    summary = timing.split("| Design Timing Summary", 1)[1]
    match = re.search(r"WNS\(ns\)[^\n]*\n\s*[- ]+\n([^\n]+)", summary)
    values = match[1].split() if match else []
    if len(values) != 12:
        raise ValueError("full STA summary with exactly 12 fields required")
    fields = ("wns_ns", "tns_ns", "setup_failing_endpoints", "setup_total_endpoints",
              "whs_ns", "ths_ns", "hold_failing_endpoints", "hold_total_endpoints",
              "wpws_ns", "tpws_ns", "pulse_failing_endpoints", "pulse_total_endpoints")
    sta = dict(zip(fields, map(float, values)))
    for index in (2, 3, 6, 7, 10, 11):
        if not sta[fields[index]].is_integer():
            raise ValueError("nonintegral endpoint count")
        sta[fields[index]] = int(sta[fields[index]])
    sta_pass = (all(float(values[i]) >= 0 for i in (0, 4, 8)) and
                all(float(values[i]) == 0 for i in (1, 2, 5, 6, 9, 10)) and
                "All user specified timing constraints are met." in summary)
    route_facts = {}
    for name, label in (("routable_nets", "routable nets"), ("fully_routed_nets", "fully routed nets"),
                        ("routing_errors", "nets with routing errors")):
        found = re.search(r"# of " + label + r"\.+\s*:\s*(\d+)\b", route)
        if not found:
            raise ValueError("missing route field: " + label)
        route_facts[name] = int(found[1])
    route_pass = (route_facts["routing_errors"] == 0 and route_facts["routable_nets"] > 0 and
                  route_facts["routable_nets"] == route_facts["fully_routed_nets"])
    internal_pass = all("checking " + item + " (0)" in timing for item in
                        ("no_clock", "unconstrained_internal_endpoints", "loops", "multiple_clock"))
    before, after = reports / "constraints_before.xdc", reports / "constraints_after.xdc"
    if before.exists() != after.exists():
        raise ValueError("only one constraint comparison file exists")
    constraints_unchanged = active_xdc(before) == active_xdc(after) if before.exists() else None
    return dict(status="STA_ROUTE_PASS_OTHER_REVIEWS_PENDING" if sta_pass and route_pass and
                internal_pass and constraints_unchanged is not False else "STA_ROUTE_FAIL",
                timing=sta, sta_pass=sta_pass, route=route_facts, route_pass=route_pass,
                internal_timing_checks_pass=internal_pass, constraints_unchanged=constraints_unchanged,
                release_ready=False, board_validated=False, warnings_waived=False,
                files={p.name: hashlib.sha256(p.read_bytes()).hexdigest()
                       for p in sorted(reports.iterdir()) if p.is_file()},
                pending=["CDC and bundled-data protocol review", "bus skew", "DRC and methodology",
                         "resources", "paired export and restoration", "ARM and board acceptance"])


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--reports", type=Path, required=True)
    parser.add_argument("--receipt", type=Path, required=True)
    args = parser.parse_args()
    if args.receipt.exists():
        raise FileExistsError(args.receipt)
    try:
        result = extract(args.reports)
    except Exception as error:
        result = dict(status="AUDIT_INPUT_FAIL", error=f"{type(error).__name__}: {error}", release_ready=False)
    with args.receipt.open("x", encoding="utf-8") as stream:
        json.dump(result, stream, indent=2)
    print(json.dumps({k: v for k, v in result.items() if k != "files"}, indent=2))
    return 0 if result["status"] == "STA_ROUTE_PASS_OTHER_REVIEWS_PENDING" else 1


if __name__ == "__main__":
    raise SystemExit(main())
