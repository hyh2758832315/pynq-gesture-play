---
name: pynq-pl-preserve
description: Reuse an existing HDL testbench to check all-output cycle preservation against a frozen original when optimizing or refactoring self-contained single-clock PYNQ PL leaf modules. Provides a generated reference monitor and transcript verification; use only when the observed behavior is meant to remain unchanged.
license: MIT
metadata:
  version: '0.1.0'
  validation: 'Vivado 2026.1; packaged examples, complete PL task replay and independent consumer verified'
---

# Preserve existing PL behavior

Use this tool for a strict unchanged-output contract on a self-contained leaf module in one
clock domain, including invalid cycles and reset values. It is unsuitable for
intentional behavior or interface changes and modules with child IP dependencies.
Keep the original before editing RTL. Select an authorized existing testbench,
its source dependencies and the DUT instances whose behavior must be preserved.

Read [configuration and limits](references/configuration.md), then use the bundled
`scripts/preserve.py` to build in a fresh directory. It generates a renamed
original reference and monitors all declared outputs using the existing DUT's
input signals, without editing or replacing the testbench stimulus. Runtime
parameter checks prevent a reference configured for a different test instance.

Run generated `run.tcl` in an idle Vivado session or batch flow, then run
`preserve.py verify`. The verifier combines the terminal marker, monitor
coverage, actual simulation finish and runtime diagnostics. Keep each run and
its logs in a separate directory so the result remains bound to its inputs.
This workflow performs development-PC simulation; hardware deployment uses
the project's board validation flow.

For source language or dependencies beyond the supported subset, use a
verification flow that supports those constructs. Retain an independently
frozen reference, the original inputs and equivalent comparison criteria.

The result covers the configured instances and exercised stimulus. Review
tests against the changed boundary and add the required scenarios. Use the
functional specification and an independent algorithm reference to assess
correctness; use synthesis and implementation for resource/timing results.
Record the sampled scope, comparison result and applicable conditions.
The packaged control experiments demonstrate defect detection, while the
RTL candidate reports quantify resource and timing effects.


## Related project diagnosis

For build/export, tool-result, startup or ownership symptoms, select the
matching group in [PYNQ debug cards](../pynq-debug-cards/SKILL.md). Each card
provides its own trigger, handling steps and completion criteria.
