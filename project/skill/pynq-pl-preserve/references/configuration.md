# Existing-stimulus preservation

Run on the development PC using Python3.11+ and Vivado. Actual component checks
used Vivado2026.1, xc7z020clg400-1. This is not a board deployment flow.

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

Use actual top, hierarchy, parameters and marker from the caller's testbench;
these are example bindings, not universal values. Each path is relative to the
legacy top instance. List every declared module parameter explicitly, including
defaults. Values are integers or integral SV literals such as `"32'h50443253"`.
The wrapper compares them against the actual DUT parameters before sampling.
Enumerate all relevant DUT instances; unlisted instances are not monitored.
Choose the minimum samples and watchdog from the test's real duration.

Calibrate the binding on unchanged RTL before relying on a changed-design result.
Inputs should remain stable around the DUT sampling edge. A legacy testbench
that drives blocking updates on that same edge can race the two instances;
the monitor does not resolve such simulator scheduling races. Diagnose that
boundary rather than treating every mismatch as an RTL bug or weakening checks.

From the directory containing `SKILL.md`:

```powershell
python -X utf8 -B scripts/preserve.py build C:/work/config.json --out C:/work/check_01
vivado -mode batch -source C:/work/check_01/run.tcl
python -X utf8 -B scripts/preserve.py verify C:/work/check_01
```

Alternatively source generated `run.tcl` in an owned idle Vivado Tcl session.
Do not share a session concurrently. The script creates a new simulation project
and closes it. `verify` reads the actual XSim transcript and requires the legacy
terminal marker, actual finish, every monitor's final coverage result and no
runtime error/fatal. A failed DUT can produce a zero Vivado tool code; that is
why transcript verification is separate. Do not weaken checks to convert a
failure into a pass. Existing outputs and receipts are never overwritten.

Outputs: frozen_reference.sv, monitor.sv, run.tcl, manifest.json, simulation/
compile/elaborate/simulate logs, and verified.json only after successful checking.
The manifest records reference/config/source/generated-file hashes. Any of those
changing before verification invalidates the result. It hashes listed HDL files,
not external data files, tool binaries or all environment settings; retain those
dependencies separately if the test uses them. Preserve raw logs on failure.

## Deliberate boundaries

- All listed sources must be self-contained module-only units. The only allowed
  preprocessing directives are timescale and default_nettype. Includes,
  definitions/conditional macros, packages/imports, binds and compilation-unit
  globals are rejected. Otherwise a copied original could resolve the same
  changed definition as the DUT and falsely appear preserved. DUT file/env/random
  dependencies and hierarchical/structured dependencies are also outside this
  tool. Do not bypass these guards: use a separately frozen, appropriately
  elaborated reference/checker for such designs. This conservative scanner is
  not a compiler, full symbol resolver or proof of arbitrary source isolation.
  Testbench stimulus must reach the DUT through its ports; hierarchical state
  forcing requires an appropriate fault-aware reference instead.
- The DUT must be a leaf module, with no child module/IP instances in either
  version. Otherwise a reference could silently share a changed dependency.
  Ordinary child-instance syntax is conservatively rejected; the source scanner
  is not a compiler/elaborator, so inspect the actual design dependency scope.
  Escaped identifiers, macros that create instances, interfaces and complex
  elaboration constructs are outside the supported source language.
- The parser supports one-module files with explicit ANSI input/output scalar or
  packed wire/logic/reg ports and simple integral parameters. It rejects interfaces,
  structs, unpacked ports, inout, inherited port declarations, non-ANSI modules,
  string/type parameters and unsupported syntax rather than silently omitting it.
  Testbench helper modules may be in other listed source files. Sources
  must define the actual DUT once; its port and parameter declarations must match
  the frozen interface. It is not a general SystemVerilog parser or compiler.
- A selected existing testbench must instantiate without external top ports.
  Use simple named hierarchy paths; generated-index or escaped paths are not
  supported. Reference and current RTL must share the declared semantics of all
  parameters. Runtime literal checks validate the selected configurations, not
  every possible parameter combination or unused default behavior.
- The monitor samples one clock domain after rising/falling edges at 1ps settling offset,
  starting after an active reset sample. It compares every output using four-state
  case inequality, even when VALID is false. It requires both reset and active
  samples. It is not an asynchronous/glitch, CDC or analog checker, nor secure
  zeroization verification. Designs requiring a different observation contract
  need an appropriate checker rather than suppressed mismatches.
- It adds no transactions, error packets, backpressure or reset scenarios. Its
  strength is reusing existing stimulus without rewriting the comparison harness.
  Cover missing cases independently. The frozen original defines preservation,
  not correctness; a bug shared with it remains a bug. Intentional changes require
  a separately specified expected behavior and must not use strict equality as
  their entire acceptance test.

## Validation

The packaged checker has been used with existing PYNQ PL testbenches to compare
reset, idle and active output values. A separate package consumer configured it
for a packet upload module: an internal signal rename passed all four outputs;
a changed reset value was identified at the first sample, 5.001 ns. The original
packet assertions passed both variants. The supplied counter example and a
complete return-source optimization verification were also executed in Vivado
2026.1. See the delivery's validation report for the actual inputs and receipts.
