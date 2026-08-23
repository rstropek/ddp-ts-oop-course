#!/usr/bin/env bash
# Create (or refresh) the workspace the student agent works in. Idempotent.
#
#   setup.sh            -> prints the workspace path
#   setup.sh --fresh    -> also wipes work/ and reports/ (start over at 1.1)
#
# Layout (outside the repo, so the agent cannot wander into later chapters):
#   $WORKSPACE/tooling/          @playwright/cli and its bundled skill
#   $WORKSPACE/starter-template/       vite-ts-starter, no .git
#   $WORKSPACE/starter-template-tests/ vite-ts-starter-tests, no .git
#   $WORKSPACE/book/             staged chapters and exercise files (stage.sh)
#   $WORKSPACE/work/             the agent's projects, carried over between runs
#   $WORKSPACE/reports/          one report per chapter
set -euo pipefail

WORKSPACE="${EXERCISE_TEST_WORKSPACE:-$HOME/.cache/creative-coding-2-exercise-tests}"
mkdir -p "$WORKSPACE"/{tooling,book,work,reports}

if [[ "${1:-}" == "--fresh" ]]; then
  rm -rf "$WORKSPACE/work" "$WORKSPACE/reports" "$WORKSPACE/book"
  mkdir -p "$WORKSPACE"/{book,work,reports}
fi

clone_starter() {
  local repo="$1" dir="$2"
  if [[ ! -d "$WORKSPACE/$dir" ]]; then
    git clone -q --depth 1 "https://github.com/Teaching-HTL-Leonding/$repo" "$WORKSPACE/$dir"
    rm -rf "$WORKSPACE/$dir/.git"
  fi
}
clone_starter vite-ts-starter starter-template
clone_starter vite-ts-starter-tests starter-template-tests

if [[ ! -x "$WORKSPACE/tooling/node_modules/.bin/playwright-cli" ]]; then
  (cd "$WORKSPACE/tooling" && npm init -y >/dev/null && npm install --silent @playwright/cli >/dev/null)
fi

# The agent reads the CLI's own skill from the folder it works in.
mkdir -p "$WORKSPACE/work/.claude/skills"
rm -rf "$WORKSPACE/work/.claude/skills/playwright-cli"
cp -r "$WORKSPACE/tooling/node_modules/@playwright/cli/skills/playwright-cli" "$WORKSPACE/work/.claude/skills/"

# Headless Chromium must be present once; the install is a no-op afterwards.
(cd "$WORKSPACE/tooling" && npx --no playwright install chromium >/dev/null 2>&1 || true)

echo "$WORKSPACE"
