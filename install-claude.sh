#!/bin/bash
# Install webship-js skills for Claude Code.
#
# Usage:
#   bash install-claude.sh                    # global:  ~/.claude/skills/
#   bash install-claude.sh --project /path    # project: <path>/.claude/skills/

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
      sed -n '2,6p' "$0" | sed 's/^# //;s/^#//'
      exit 0 ;;
    *) echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
  shift
done

SKILL_NAMES=(webship-js-init webship-js-create webship-js-run webship-js-steps)

if [ -n "$PROJECT" ]; then
  target="$PROJECT/.claude/skills"
else
  target="$HOME/.claude/skills"
fi
mkdir -p "$target"

for name in "${SKILL_NAMES[@]}"; do
  mkdir -p "$target/$name"
  cp "$SKILLS_DIR/$name/SKILL.md" "$target/$name/SKILL.md"
done
echo "[claude] installed to $target/"
