---
name: harness-audit
description: Audit repository harness maturity and fail fast on missing guardrails. Use when asked to score harness coverage, run strict checks in CI, or identify concrete gaps in AGENTS/docs/automation contracts.
---

# Harness Audit

## Overview

Evaluate whether a repository harness is complete enough to support reliable agent execution.
Prefer deterministic pass/fail checks over subjective review.

## When To Use

Use this skill when the user asks to:
- audit harness completeness
- add strict harness checks to CI
- diagnose missing `AGENTS.md` and `docs/harness` contracts
- produce actionable fail items for missing enforcement

Do not use this skill to scaffold files from scratch.
Use `harness-init` for first-time setup.

## Workflow

1. Run audit
- Execute audit in normal mode for reporting.
- Execute with `--strict` for CI-gating behavior.

2. Classify gaps
- Separate hard failures (missing files/checks) from improvements.
- Map each failure to a concrete file or command fix.

3. Close gaps
- Add missing files/checks or call `harness-init` for bootstrap.
- Re-run strict audit until clean.

## Commands

Report mode:

```bash
bash scripts/harness_audit.sh .
```

Strict mode (non-zero exit on required failures):

```bash
bash scripts/harness_audit.sh . --strict
```

GitHub Actions example step:

```bash
bash scripts/harness_audit.sh . --strict
```

## Decision Rules

- Treat strict-mode failures as merge blockers.
- Keep checks fast enough for pull-request execution.
- Every rule should map to an enforceable check.
- Prefer fewer high-signal checks over noisy broad scans.

## Resources

- `scripts/harness_audit.sh`
Deterministic harness checks for docs, CI presence, and automation entrypoints.

- `references/harness-engineering-playbook.md`
Guidance for anti-patterns and practical quality metrics.
