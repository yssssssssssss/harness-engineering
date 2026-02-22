---
name: harness-governance
description: Operate and prune a repository harness over time. Use when asked to run recurring documentation cleanup, decision-log hygiene, backlog triage, or entropy-control loops for agent-generated changes.
---

# Harness Governance

## Overview

Keep harness quality stable as the repository evolves.
This skill focuses on recurring maintenance, not first-time bootstrap.

## When To Use

Use this skill when the user asks to:
- set up recurring harness maintenance loops
- clean stale docs and obsolete policy rules
- enforce decision-log and backlog hygiene
- reduce entropy from drifting agent-generated changes

Do not use this skill to create the initial harness from scratch.
Use `harness-init` first if baseline files are missing.

## Workflow

1. Snapshot current state
- Review `AGENTS.md` and `docs/harness/*` for stale or duplicated policy text.
- Run strict harness audit to establish baseline quality.

2. Prune and align
- Remove obsolete rules and dead references.
- Keep `AGENTS.md` short and link details to versioned docs.
- Update `docs/harness/decision-log.md` for major changes.
- Triage `docs/harness/backlog.md` into must-fix vs optional.

3. Automate recurrence
- Add CI or scheduled jobs for strict audit and docs hygiene.
- Define ownership and review cadence for harness docs.
- Track a small set of metrics (lead time, pre-merge catch rate, stale-doc ratio).

## Suggested Cadence

- On every PR: strict harness audit.
- Weekly: backlog and stale-doc sweep.
- Per release: decision-log review and boundary check recalibration.

## Decision Rules

- Delete process that does not reduce defects.
- Prefer deterministic checks over policy prose.
- Keep every governance rule tied to an owner and recurrence.
- Prune before adding new governance artifacts.

## Resources

- `references/harness-engineering-playbook.md`
Rollout model, anti-patterns, and practical metrics.

- `references/harness-templates.md`
Templates for concise AGENTS and enforceable boundaries.
