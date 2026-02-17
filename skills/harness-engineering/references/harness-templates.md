# Harness Templates

## Minimal `AGENTS.md`

```markdown
# Agent Contract

## Rules
- Keep this file short.
- Put detailed policy in `docs/harness/`.
- Update `docs/harness/decision-log.md` for major changes.
- Run lint, tests, and harness audit before merging.
```

## `docs/harness/architecture-boundaries.md`

```markdown
# Architecture Boundaries

## Layers
- app -> domain, platform
- domain -> platform
- platform -> (no inward dependencies)

## Enforcement
- Rule: <tool/rule-id>
- Scope: <path glob>
- CI gate: <workflow step name>
```

## `docs/harness/decision-log.md`

```markdown
# Decision Log

| Date (UTC) | Decision | Rationale | Owner | Follow-up |
| --- | --- | --- | --- | --- |
| 2026-02-17 | Introduce dependency-lint check | Prevent layer violations at review time | Platform | Reassess in 2 sprints |
```

## Pull Request Checklist Snippet

```markdown
- [ ] Boundary checks pass
- [ ] Tests pass
- [ ] Harness docs updated (if behavior or policy changed)
```
