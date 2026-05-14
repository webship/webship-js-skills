#!/bin/bash
# Install webship-js skills for GitHub Copilot.
#
# Writes:
#   <target>/copilot-instructions.md
#   <target>/prompts/webship-js-init.prompt.md
#   <target>/prompts/webship-js-create.prompt.md
#   <target>/prompts/webship-js-run.prompt.md
#   <target>/prompts/webship-js-steps.prompt.md
#
# Usage:
#   bash install-copilot.sh                    # global:  ~/.config/github-copilot/
#   bash install-copilot.sh --project /path    # project: <path>/.github/

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
  target="$PROJECT/.github"
else
  target="$HOME/.config/github-copilot"
fi
mkdir -p "$target/prompts"

cat > "$target/copilot-instructions.md" <<'EOF'
# Copilot instructions — webship-js testing

This project uses [webship-js 2.0.x](https://webship.co/docs/webship-js/2.0.x)
(Playwright + Cucumber-js) for automated functional acceptance testing.

When the user asks for webship-js help, prefer the four prompts below:

- `webship-js-init`   — scaffold a new webship-js project (Node.js or DDEV).
- `webship-js-create` — author `.feature` tests for a page.
- `webship-js-run`    — run the suite, generate HTML report, analyze failures.
- `webship-js-steps`  — reference lookup for every Given/When/Then step.

Source of truth for step definitions (read before recommending syntax):
`node_modules/webship-js/tests/step-definitions/*.js` and
https://github.com/webship/webship-js/tree/2.0.x.

Critical rules:
1. After `When I press "Submit"` chain `And I wait for AJAX to finish`.
2. For `href`/`src` use the link-by-attribute form, not `response should contain`.
3. DDEV projects run tests via `ddev npm run test:*`, not host `npm`.
4. `npx init-webship-js` is idempotent — preserve user files.
EOF

for name in "${SKILL_NAMES[@]}"; do
  cp "$SKILLS_DIR/$name/SKILL.md" "$target/prompts/$name.prompt.md"
done
echo "[copilot] installed to $target/"
