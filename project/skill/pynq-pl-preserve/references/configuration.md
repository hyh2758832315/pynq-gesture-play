# Existing-stimulus preservation

Run on the development PC using Python3.11+ and Vivado. Actual component checks
used Vivado2026.1, xc7z020clg400-1. The workflow runs HDL simulation on the PC.

Save an unchanged reference source before editing. Supply a JSON configuration
with exactly the following fields; paths resolve relative to that JSON file:

```json
{
  "reference": "original.sv",
  "sources": ["rtl/axis_area2x2.sv", "tests/tb_axis_area2x2.sv"],
  "legacy_top": "tb_axis_area2x2",
  "instances": [
    {"path": "small_case.dut", "parameters": {"INPUT_WIDTH": 8, "INPUT_HEIGHT": 6}},
    {"path": "minimum_case.dut", "parameters": {"INPUT_WIDTH": 2, "INPUT_HEIGHT": 2}},
    {"path": "full_case.dut", "parameters": {"INPUT_WIDTH": 1280, "INPUT_HEIGHT": 720}}
  ],
  "clock": "aclk",
  "reset": "aresetn",
  "reset_active": 0,
  "min_checks": 20,
  "watchdog_ns": 200000000,
  "legacy_marker": "TEST_PASS AREA2X2 NUMERIC_BACKPRESSURE_FRAMING_RESET full_output_pixels=230400",
  "part": "xc7z020clg400-1"
}
```

Replace the example bindings with the actual top, hierarchy, parameters and
terminal marker from the selected testbench. Each path is relative to the
legacy top instance. List every declared module parameter explicitly, including
defaults. Values are integers or integral SV literals such as `"32'h50443253"`.
The wrapper compares them against the actual DUT parameters before sampling.
Enumerate all relevant DUT instances; unlisted instances are not monitored.
Choose the minimum samples and watchdog from the test's real duration.

Calibrate the binding on unchanged RTL before relying on a changed-design result.
Inputs should remain stable around the DUT sampling edge. A legacy testbench
that drives blocking updates on that same edge can race the two instances;
resolve this stimulus scheduling boundary before comparing the RTL versions.
Keep the original comparison criteria when correcting testbench scheduling.

From the directory containing `SKILL.md`:

```powershell
python -X utf8 -B scripts/preserve.py build C:/work/config.json --out C:/work/check_01
vivado -mode batch -source C:/work/check_01/run.tcl
python -X utf8 -B scripts/preserve.py verify C:/work/check_01
```

Alternatively source generated `run.tcl` in an owned idle Vivado Tcl session,
executing tasks sequentially within that session. The script creates and closes
a new simulation project. `verify` reads the XSim transcript and requires the
legacy terminal marker, actual finish, every monitor's final coverage result
and a run free of runtime error/fatal messages. This connects the tool result
to the observed RTL behavior. Each run keeps its own outputs and receipts.

Outputs: frozen_reference.sv, monitor.sv, run.tcl, manifest.json, simulation/
compile/elaborate/simulate logs, and verified.json only after successful checking.
The manifest binds the reference, configuration, listed HDL sources and
generated files to the run through hashes. Changed inputs require a new run.
Record external test data, tool versions and environment settings separately
when used, and retain the raw logs for diagnosis and review.

## Supported inputs and validation scope

- All listed sources must be self-contained module-only units. The only allowed
  preprocessing directives are timescale and default_nettype. Includes,
  definitions/conditional macros, packages/imports, binds and compilation-unit
  globals are rejected to keep reference dependencies independent of candidate
  changes. DUT file/env/random dependencies and hierarchical/structured
  dependencies require a separately frozen reference and a checker supporting
  those constructs. The scanner validates the documented source subset; full
  language elaboration and dependency isolation use the corresponding HDL
  tools. Testbench stimulus reaches the DUT through its ports; hierarchical
  state forcing requires a fault-aware reference.
- The DUT must be a leaf module, with no child module/IP instances in either
  version. This makes the reference self-contained. Child instances, escaped
  identifiers, macros that create instances, interfaces and complex elaboration
  constructs are outside the supported subset. Inspect the actual design
  dependency scope before selecting the verification flow.
- The parser supports one-module files with explicit ANSI input/output scalar or
  packed wire/logic/reg ports and simple integral parameters. It rejects interfaces,
  structs, unpacked ports, inout, inherited port declarations, non-ANSI modules,
  string/type parameters and unsupported syntax rather than silently omitting it.
  Testbench helper modules may be in other listed source files. Sources
  must define the actual DUT once; its port and parameter declarations must match
  the frozen interface. Use a full SystemVerilog parser/elaborator for other
  language constructs.
- A selected existing testbench must instantiate without external top ports.
  Use simple named hierarchy paths; generated-index or escaped paths are not
  supported. Reference and current RTL must share the declared semantics of all
  parameters. Runtime literal checks validate the selected configurations, not
  every possible parameter combination or unused default behavior.
- The monitor samples one clock domain after rising/falling edges at 1ps settling offset,
  starting after an active reset sample. It compares every output using four-state
  case inequality, even when VALID is false. It requires both reset and active
  samples. Asynchronous/glitch, CDC, analog and secure zeroization properties
  require their respective checkers. Select the observation contract and
  checker to match the properties under validation.
- The tool reuses existing stimulus and generates the comparison harness.
  Add transactions, error packets, backpressure and reset scenarios according
  to the changed boundary. The frozen original defines the behavior-preservation
  reference; algorithm correctness is assessed against the functional
  specification. Intentional behavior changes require separately specified
  expected results and matching acceptance tests.

## Validation

The packaged checker has been used with existing PYNQ PL testbenches to compare
reset, idle and active output values. A separate package consumer configured it
for a packet upload module: an internal signal rename passed all four outputs;
a changed reset value was identified at the first sample, 5.001 ns. The original
packet assertions passed both variants. The supplied counter example and a
complete return-source optimization verification were also executed in Vivado
2026.1. See the delivery's validation report for the actual inputs and receipts.
