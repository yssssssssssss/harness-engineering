---
name: harness
description: Build or improve an agent-first engineering harness in any repository. Use when asked to set up or refactor AGENTS.md conventions, docs/harness knowledge structure, architecture guardrails, CI quality gates, and recurring cleanup loops.
---

# Harness

## Overview

Turn chat-driven engineering into repository-driven engineering.
Keep agent instructions short, move details into versioned docs, and enforce rules with deterministic checks.

## When To Use

Use this skill when the user asks to:
- initialize an agent-first repo contract
- shorten or restructure `AGENTS.md`
- create or clean up `docs/harness/*`
- define architecture dependency boundaries and CI checks
- add recurring maintenance loops for stale docs and tech debt
- audit harness maturity and identify missing controls

## Workflow

1. Baseline
- Inspect repository tree, toolchain, CI, and existing policy docs.
- Record missing contracts and unknowns in `docs/harness/backlog.md`.

2. Establish contract
- Keep `AGENTS.md` short and directive.
- Move operational details into `docs/harness/*.md`.
- Ensure each non-trivial rule points to a versioned file path.

3. Encode guardrails
- Define architecture boundaries in `docs/harness/architecture-boundaries.md`.
- Attach each boundary to enforcement (lint/check script + CI step).
- Prefer fast static checks over complex policy engines.

4. Close loop with automation
- Add CI jobs that run harness checks on pull requests.
- Keep `docs/harness/decision-log.md` updated for major changes.
- Keep checks fast enough for every PR.

5. Operate and prune
- Run harness audit after substantial changes.
- Remove stale docs, dead checks, and obsolete rules before adding new process.

## Quick Start

Bootstrap minimal harness files into a target repository:

```bash
bash scripts/bootstrap_harness.sh .
```

Run harness audit and fail on required check gaps:

```bash
bash scripts/harness_audit.sh . --strict
```

## Decision Rules

- Prefer one clear policy file over many overlapping docs.
- Prefer executable checks over long prose procedures.
- Prefer minimum viable gates first, then tighten.
- Reject rules with no owner, no enforcement, or no measurable outcome.

## Resources

- `scripts/bootstrap_harness.sh`
Create minimal `AGENTS.md` and `docs/harness/*` files. Supports `--force` and `--with-github-ci`.

- `scripts/harness_audit.sh`
Run structural checks for harness coverage and optionally fail in strict mode.

- `references/harness-engineering-playbook.md`
Rollout plan, anti-patterns, and practical metrics.

- `references/harness-templates.md`
Drop-in templates for AGENTS contract, architecture boundaries, and decision log.
