#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  harness_audit.sh [target_dir] [--strict]

Options:
  --strict   exit with non-zero if any required check fails
EOF
}

TARGET="."
STRICT=0
POSITIONAL_COUNT=0

for arg in "$@"; do
  case "$arg" in
    --help|-h)
      usage
      exit 0
      ;;
    --strict)
      STRICT=1
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

PASS_COUNT=0
FAIL_COUNT=0

pass() {
  local check_name="$1"
  PASS_COUNT=$((PASS_COUNT + 1))
  printf "[PASS] %s\n" "$check_name"
}

fail() {
  local check_name="$1"
  local detail="${2:-}"
  FAIL_COUNT=$((FAIL_COUNT + 1))
  if [ -n "$detail" ]; then
    printf "[FAIL] %s - %s\n" "$check_name" "$detail"
  else
    printf "[FAIL] %s\n" "$check_name"
  fi
}

check_file() {
  local check_name="$1"
  local path="$2"
  if [ -f "$TARGET/$path" ]; then
    pass "$check_name"
  else
    fail "$check_name" "$path not found"
  fi
}

check_dir_nonempty() {
  local check_name="$1"
  local dir="$2"
  if [ -d "$TARGET/$dir" ] && find "$TARGET/$dir" -maxdepth 1 -type f | grep -q .; then
    pass "$check_name"
  else
    fail "$check_name" "$dir is missing or empty"
  fi
}

check_contains() {
  local check_name="$1"
  local path="$2"
  local pattern="$3"
  if [ -f "$TARGET/$path" ] && grep -Eq "$pattern" "$TARGET/$path"; then
    pass "$check_name"
  else
    fail "$check_name" "$path does not include required pattern"
  fi
}

check_any_automation() {
  local check_name="$1"
  if [ -f "$TARGET/Makefile" ] && grep -Eq '^(lint|test|build):' "$TARGET/Makefile"; then
    pass "$check_name"
    return 0
  fi
  if [ -f "$TARGET/package.json" ] && grep -Eq '"(lint|test|build)"\s*:' "$TARGET/package.json"; then
    pass "$check_name"
    return 0
  fi
  if [ -d "$TARGET/scripts" ] && find "$TARGET/scripts" -maxdepth 1 -type f | grep -Eq '(lint|test|check)'; then
    pass "$check_name"
    return 0
  fi
  fail "$check_name" "no lint/test/build automation found"
}

check_ci_workflow() {
  local check_name="$1"
  if [ -d "$TARGET/.github/workflows" ] && find "$TARGET/.github/workflows" -maxdepth 1 -type f \( -name '*.yml' -o -name '*.yaml' \) | grep -q .; then
    pass "$check_name"
  else
    fail "$check_name" ".github/workflows has no workflow files"
  fi
}

check_file "Root agent contract" "AGENTS.md"
check_file "Harness index" "docs/harness/README.md"
check_file "Architecture boundaries" "docs/harness/architecture-boundaries.md"
check_file "Operational runbook" "docs/harness/runbook.md"
check_file "Decision log" "docs/harness/decision-log.md"
check_file "Harness backlog" "docs/harness/backlog.md"
check_contains "AGENTS links harness docs" "AGENTS.md" 'docs/harness/'
check_contains "Boundaries include enforcement section" "docs/harness/architecture-boundaries.md" 'Enforcement|enforcement'
check_ci_workflow "Repository has CI workflows"
check_any_automation "Repository has automation entrypoints"
check_dir_nonempty "Harness docs directory is populated" "docs/harness"

TOTAL=$((PASS_COUNT + FAIL_COUNT))
echo
echo "Harness audit result: $PASS_COUNT/$TOTAL checks passed."

if [ "$STRICT" = "1" ] && [ "$FAIL_COUNT" -gt 0 ]; then
  exit 1
fi

if [ "$FAIL_COUNT" -gt 0 ]; then
  exit 0
fi

exit 0
