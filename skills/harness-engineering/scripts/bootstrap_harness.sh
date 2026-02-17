#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  bootstrap_harness.sh [target_dir] [--force] [--with-github-ci]

Options:
  --force            overwrite existing files
  --with-github-ci   create .github/workflows/harness-audit.yml

Environment:
  FORCE=1            same as --force
EOF
}

TARGET="."
FORCE="${FORCE:-0}"
WITH_GITHUB_CI=0
POSITIONAL_COUNT=0

for arg in "$@"; do
  case "$arg" in
    --help|-h)
      usage
      exit 0
      ;;
    --force)
      FORCE=1
      ;;
    --with-github-ci)
      WITH_GITHUB_CI=1
      ;;
    --*)
      echo "[error] Unknown option: $arg" >&2
      usage
      exit 2
      ;;
    *)
      POSITIONAL_COUNT=$((POSITIONAL_COUNT + 1))
      if [ "$POSITIONAL_COUNT" -gt 1 ]; then
        echo "[error] Too many target directories." >&2
        usage
        exit 2
      fi
      TARGET="$arg"
      ;;
  esac
done

mkdir -p "$TARGET"

write_file() {
  local path="$1"
  local content="$2"
  if [ -e "$path" ] && [ "$FORCE" != "1" ]; then
    echo "[skip] $path (exists)"
    return 0
  fi
  mkdir -p "$(dirname "$path")"
  printf "%s\n" "$content" > "$path"
  if [[ "$path" == */scripts/*.sh ]]; then
    chmod +x "$path"
  fi
  echo "[write] $path"
}

AGENTS_CONTENT=$(cat <<'EOF'
# Agent Contract

## Scope
- Keep this file short and actionable.
- Put detailed policies in `docs/harness/` and link from here.

## Rules
- Read `docs/harness/architecture-boundaries.md` before large refactors.
- Read `docs/harness/runbook.md` before changing CI, release, or migrations.
- Update `docs/harness/decision-log.md` for major technical decisions.
- Keep `docs/harness/backlog.md` current when constraints or unknowns appear.

## Quality Bar
- Prefer simple solutions that remove failure paths.
- Reject complexity without measurable benefit.
- Add tests for behavioral changes.
EOF
)

HARNESS_README_CONTENT=$(cat <<'EOF'
# Harness Docs

This folder holds the agent-readable engineering harness.

## Files
- `architecture-boundaries.md`: module/layer dependency contracts and enforcement.
- `runbook.md`: operational commands and CI expectations.
- `decision-log.md`: immutable record of major technical decisions.
- `backlog.md`: pending gaps, unknowns, and cleanup items.
EOF
)

ARCHITECTURE_CONTENT=$(cat <<'EOF'
# Architecture Boundaries

## Layers
- `app` may depend on `domain` and `platform`.
- `domain` may depend on `platform` only.
- `platform` may not depend on `app` or `domain`.

## Enforcement
- Add a lint or static check for each boundary.
- Fail CI on boundary violations.
- Keep checks fast enough for pull-request execution.
EOF
)

RUNBOOK_CONTENT=$(cat <<'EOF'
# Runbook

## Standard Commands
- `lint`: define and keep deterministic.
- `test`: run fast checks on pull requests.
- `build`: keep reproducible.

## Pull Request Gate
1. Run lint and tests.
2. Run harness audit.
3. Update decision log for major design changes.
EOF
)

DECISION_LOG_CONTENT=$(cat <<'EOF'
# Decision Log

| Date (UTC) | Decision | Rationale | Owner | Follow-up |
| --- | --- | --- | --- | --- |
EOF
)

BACKLOG_CONTENT=$(cat <<'EOF'
# Harness Backlog

## Must Fix
- [ ] Add/verify lint command.
- [ ] Add/verify test command.
- [ ] Add CI workflow to run harness audit.

## Nice To Have
- [ ] Add module dependency check.
- [ ] Add docs freshness check.
EOF
)

CHECK_SCRIPT_CONTENT=$(cat <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

echo "Run project lint/test/build commands here."
echo "Replace this script with real commands for your stack."
EOF
)

GITHUB_WORKFLOW_CONTENT=$(cat <<'EOF'
name: Harness Audit

on:
  pull_request:
  push:
    branches: [main]

jobs:
  harness-audit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run harness audit
        run: bash scripts/harness_audit.sh . --strict
EOF
)

write_file "$TARGET/AGENTS.md" "$AGENTS_CONTENT"
write_file "$TARGET/docs/harness/README.md" "$HARNESS_README_CONTENT"
write_file "$TARGET/docs/harness/architecture-boundaries.md" "$ARCHITECTURE_CONTENT"
write_file "$TARGET/docs/harness/runbook.md" "$RUNBOOK_CONTENT"
write_file "$TARGET/docs/harness/decision-log.md" "$DECISION_LOG_CONTENT"
write_file "$TARGET/docs/harness/backlog.md" "$BACKLOG_CONTENT"
write_file "$TARGET/scripts/check.sh" "$CHECK_SCRIPT_CONTENT"

if [ "$WITH_GITHUB_CI" = "1" ]; then
  write_file "$TARGET/.github/workflows/harness-audit.yml" "$GITHUB_WORKFLOW_CONTENT"
fi

echo "[ok] Harness bootstrap complete at $TARGET"
