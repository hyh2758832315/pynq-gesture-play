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

Run generated `run.tcl` using the project's authorized Vivado session or batch
flow. Run `preserve.py verify` afterward: simulator exit zero alone is not a
pass. Preserve first failures and their logs; rebuild into a fresh directory
after source/config changes. Keep hardware, shared sessions and production
deployment outside this check's scope.

A source-language/dependency rejection is a limit of this checker, not an RTL
failure. Continue the requested task with an appropriate independently frozen
reference/verification flow; do not delete checks or rewrite protected inputs
merely to make this tool accept them.

The result covers only the named instances and stimulus actually exercised.
Review the existing tests for the changed boundary and add missing scenarios
when needed; this tool does not create stimulus or prove algorithm correctness.
Resource/timing checks remain separate. Report actual behavior, sampled scope,
limitations and any necessary corrections. The packaged control experiments validate defect detection; resource and timing
results are reported separately for the tested RTL candidate.


## Related project diagnosis

For build/export, tool-result, startup or ownership symptoms, consult only the
matching group in [PYNQ debug cards](../pynq-debug-cards/SKILL.md). Those historical
cards do not add mandatory checks to a local RTL preservation task.
