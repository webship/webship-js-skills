#!/bin/bash
# Install webship-js skills for Gemini CLI.
#
# Writes:
#   <target>/GEMINI.md
#   <target>/commands/webship-js/init.toml      (invoke: /webship-js:init)
#   <target>/commands/webship-js/create.toml    (invoke: /webship-js:create)
#   <target>/commands/webship-js/run.toml       (invoke: /webship-js:run)
#   <target>/commands/webship-js/steps.toml     (invoke: /webship-js:steps)
#
# Usage:
#   bash install-gemini.sh                    # global:  ~/.gemini/
#   bash install-gemini.sh --project /path    # project: <path>/.gemini/

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

SKILL_NAMES=(webship-js-init webship-js-create webship-js-run webship-js-steps)

if [ -n "$PROJECT" ]; then
  target="$PROJECT/.gemini"
else
  target="$HOME/.gemini"
fi
mkdir -p "$target/commands/webship-js"

cat > "$target/GEMINI.md" <<'EOF'
# Gemini context — webship-js testing

This project uses webship-js 2.0.x (Playwright + Cucumber-js). Four commands
are registered under the `webship-js` namespace:

- `/webship-js:init`    — scaffold project (Node.js or DDEV).
- `/webship-js:create`  — author `.feature` tests for a page.
- `/webship-js:run`     — run suite + HTML report + failure analysis.
- `/webship-js:steps`   — step-definition reference.

Authoritative step source: `node_modules/webship-js/tests/step-definitions/*.js`
or the 2.0.x branch at https://github.com/webship/webship-js.

Always wait after submits (`And I wait for AJAX to finish`). Use the
link-by-attribute form for href/src assertions.
EOF

for name in "${SKILL_NAMES[@]}"; do
  short="${name#webship-js-}"
  dst="$target/commands/webship-js/$short.toml"
  {
    printf 'description = "webship-js %s"\n' "$short"
    printf 'prompt = """\n'
    cat "$SKILLS_DIR/$name/SKILL.md"
    printf '\n"""\n'
  } > "$dst"
done
echo "[gemini] installed to $target/"
