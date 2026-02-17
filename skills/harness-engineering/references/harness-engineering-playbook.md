# Harness Engineering Playbook

## Principles

1. Keep critical knowledge in the repository, not in chat history.
2. Keep agent instructions short; link details through versioned docs.
3. Convert policies into executable checks.
4. Prefer architecture constraints over manual review heroics.
5. Treat maintenance and cleanup as first-class recurring work.

## Rollout Plan

1. Baseline
- Inventory docs, CI, test/lint paths, and architecture boundaries.
- Mark missing contracts.

2. Contract
- Keep `AGENTS.md` concise.
- Move detail into `docs/harness/*`.
- Ensure each policy has ownership.

3. Guardrails
- Define dependency rules by layer and module.
- Enforce with lint/check scripts and CI.

4. Loop Closure
- Run checks on pull requests.
- Keep decision log and backlog current.
- Add periodic cleanup issue or job.

## Anti-Patterns

- Long AGENTS files containing everything.
- Rules with no automated enforcement.
- Cross-team conventions only documented in chat.
- Slow CI gates that block all iteration.
- Extra process that does not remove defects.

## Practical Metrics

- Mean time from prompt to merged pull request.
- Number of regressions caught pre-merge versus post-merge.
- Percentage of architecture rules that are automatically enforced.
- Ratio of stale harness docs older than one release cycle.
