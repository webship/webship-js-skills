#!/bin/bash
# Install webship-js skills for Codex CLI.
#
# Writes:
#   <root>/AGENTS.md
#   <root>/.codex/prompts/webship-js-init.md
#   <root>/.codex/prompts/webship-js-create.md
#   <root>/.codex/prompts/webship-js-run.md
#   <root>/.codex/prompts/webship-js-steps.md
#
# Usage:
#   bash install-codex.sh                    # global:  $HOME/AGENTS.md + ~/.codex/prompts/
#   bash install-codex.sh --project /path    # project: <path>/AGENTS.md + <path>/.codex/prompts/

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR/.claude/skills"

if [ ! -d "$SKILLS_DIR" ]; then
  echo "Error: skills source not found at $SKILLS_DIR" >&2
  exit 1
fi

PROJECT=""
while [ $# -gt 0 ]; do
  case "$1" in
    --global)  PROJECT="" ;;
    --project) PROJECT="$2"; shift ;;
    -h|--help)
      sed -n '2,14p' "$0" | sed 's/^# //;s/^#//'
      exit 0 ;;
    *) echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
  shift
done

SKILL_NAMES=(webship-js-init webship-js-create webship-js-run webship-js-steps webship-js-audit)

if [ -n "$PROJECT" ]; then
  root="$PROJECT"
  target_prompts="$PROJECT/.codex/prompts"
else
  root="$HOME"
  target_prompts="$HOME/.codex/prompts"
fi
mkdir -p "$target_prompts"

cat > "$root/AGENTS.md" <<'EOF'
# AGENTS.md — webship-js testing

This repository uses [webship-js 2.0.x](https://webship.co/docs/webship-js/2.0.x)
(Playwright + Cucumber-js) for automated functional acceptance testing.

## Available prompts

| Prompt               | Purpose                                                 |
|----------------------|---------------------------------------------------------|
| `webship-js-init`    | Scaffold a new webship-js project (Node.js or DDEV).    |
| `webship-js-create`  | Author `.feature` tests for a page.                     |
| `webship-js-run`     | Run suite + HTML report + failure analysis.             |
| `webship-js-steps`   | Step-definition reference.                              |

## Conventions

- Source of truth for step phrasing: `node_modules/webship-js/tests/step-definitions/*.js`.
  If missing, fetch from https://github.com/webship/webship-js/tree/2.0.x.
- After `When I press "Submit"`, always chain `And I wait for AJAX to finish`.
- For `href`/`src` assertions use the link-by-attribute form, never
  `response should contain`.
- DDEV projects: run tests via `ddev npm run test:*` or `ddev exec`.
- `npx init-webship-js` is idempotent; keep user files unless `--force` is
  explicitly requested.

## Commands

```bash
npm install --no-save webship-js
npx init-webship-js                         # scaffold / re-scaffold
npm test                                    # default browser (chromium)
BROWSER=firefox npm test
LAUNCH_URL=https://example.com npm test
npx cucumber-js --config cucumber.js tests/features/<file>.feature
npm run generate-reports                    # HTML report
```

DDEV:

```bash
ddev add-on get webship/ddev-webship-js
ddev restart
ddev npm run test:chromium
ddev exec npx init-webship-js
```
EOF

for name in "${SKILL_NAMES[@]}"; do
  cp "$SKILLS_DIR/$name/SKILL.md" "$target_prompts/$name.md"
done
echo "[codex] AGENTS.md at $root/AGENTS.md; prompts at $target_prompts/"
