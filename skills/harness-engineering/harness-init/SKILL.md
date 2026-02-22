---
name: harness-init
description: Initialize or re-bootstrap an agent-first repository harness. Use when asked to create or reset AGENTS.md, docs/harness structure, baseline guardrail docs, or starter CI harness workflow files.
---

# Harness Init

## Overview

Create a minimal, deterministic harness foundation for a repository.
Use this skill for first-time setup or controlled re-bootstrap of harness files.

## When To Use

Use this skill when the user asks to:
- initialize AGENTS and harness docs in a repo
- scaffold `docs/harness/*` with templates
- create baseline runbook, decision log, and backlog files
- add starter harness CI workflow

Do not use this skill for maturity scoring or recurring governance loops.
Use `harness-audit` for scoring and `harness-governance` for recurring maintenance.

## Workflow

1. Baseline current repo
- Inspect whether `AGENTS.md`, `docs/harness`, `scripts`, and CI workflows already exist.
- Decide whether to preserve existing files or force replacement.

2. Bootstrap files
- Run the bootstrap script with target path.
- Use `--with-github-ci` when CI scaffolding is requested.
- Use `--force` only when explicit overwrite is approved.

3. Verify setup
- Confirm required files exist and are readable.
- Run a strict harness audit after bootstrap.

## Commands

Bootstrap in current repository:

```bash
bash scripts/bootstrap_harness.sh .
```

Bootstrap with GitHub workflow:

```bash
bash scripts/bootstrap_harness.sh . --with-github-ci
```

Force overwrite existing files:

```bash
bash scripts/bootstrap_harness.sh . --force
```

Verify result:

```bash
bash scripts/harness_audit.sh . --strict
```

## Decision Rules

- Prefer non-destructive bootstrap by default.
- Do not overwrite files unless explicitly requested.
- Keep AGENTS concise and move details into `docs/harness/*`.
- Finish by running a strict audit.

## Resources

- `scripts/bootstrap_harness.sh`
Scaffold minimal harness contract and docs.

- `references/harness-templates.md`
Drop-in templates for AGENTS, architecture boundaries, and decision log.

- `references/harness-engineering-playbook.md`
Migration and rollout guidance for staged adoption.

- `scripts/harness_audit.sh`
Post-bootstrap strict validation for required harness controls.
