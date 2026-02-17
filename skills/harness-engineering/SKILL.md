---
name: harness-engineering
description: Build and evolve an agent-first engineering harness for any software repository. Use when Codex needs to set up or improve AGENTS.md conventions, docs/harness knowledge structure, architecture guardrails, CI checks, and operating loops so agents can ship safely at high throughput.
---

# Harness Engineering

## Overview

Convert a repository from chat-driven coordination into repository-driven coordination.
Keep policies short, executable, and machine-checkable so agents can iterate fast without silent drift.

## Workflow

1. Baseline current repository
- Inspect tree, language/toolchain, CI setup, and existing policy docs.
- Identify what is agent-visible versus chat-only or tribal knowledge.
- Record unknowns and missing contracts in `docs/harness/backlog.md`.

2. Establish the harness contract
- Keep `AGENTS.md` short and directive.
- Move operational detail into `docs/harness/*.md`.
- Make each non-trivial rule point to a file path under version control.

3. Encode architecture guardrails
- Define explicit boundaries in `docs/harness/architecture-boundaries.md`.
- Attach each boundary to an enforcement mechanism (lint/test/check script).
- Prefer simple static checks over complex policy engines.

4. Close the loop with automation
- Add CI jobs that run harness checks and fail on contract regression.
- Keep a decision log for major changes and reversals.
- Prefer fast checks that run on every pull request.

5. Operate and prune
- Run harness audit on every substantial repo change.
- Schedule recurring cleanup for stale docs, dead checks, and obsolete rules.
- Remove complexity before adding new process.

## Quick Start

Run bootstrap to create a minimal harness:

```bash
bash scripts/bootstrap_harness.sh .
```

Run audit to score harness maturity:

```bash
bash scripts/harness_audit.sh . --strict
```

## Decision Rules

- Prefer one clear policy file over many overlapping docs.
- Prefer deterministic scripts over long natural-language procedures.
- Prefer minimum viable gates first, then tighten.
- Reject rules with no owner, no enforcement, or no measurable outcome.

## Resources

### scripts/bootstrap_harness.sh
Create minimal harness files (`AGENTS.md`, `docs/harness/*`) without overwriting existing files unless `--force` is set.

### scripts/harness_audit.sh
Check harness coverage and produce a pass/fail report with an optional strict exit code.

### references/harness-engineering-playbook.md
Contain migration playbook, anti-patterns, and rollout guidance.

### references/harness-templates.md
Provide drop-in templates for `AGENTS.md`, architecture boundaries, and decision logs.
