#!/bin/bash
# Install webship-js Skills for Claude Code
# Usage: bash install.sh [--global|--project /path/to/project]

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR/.claude/skills"

if [ ! -d "$SKILLS_DIR" ]; then
  echo "Error: Skills directory not found at $SKILLS_DIR"
  exit 1
fi

if [ "$1" = "--global" ] || [ -z "$1" ]; then
  TARGET_DIR="$HOME/.claude/skills"
  mkdir -p "$TARGET_DIR"
  cp "$SKILLS_DIR"/*.md "$TARGET_DIR/"
  echo "Installed webship-js skills globally to $TARGET_DIR/"
elif [ "$1" = "--project" ] && [ -n "$2" ]; then
  TARGET_DIR="$2/.claude/skills"
  mkdir -p "$TARGET_DIR"
  cp "$SKILLS_DIR"/*.md "$TARGET_DIR/"
  echo "Installed webship-js skills to project $TARGET_DIR/"
else
  echo "Usage: bash install.sh [--global|--project /path/to/project]"
  exit 1
fi

echo ""
echo "Available skills:"
echo "  /webship-js-setup  — Initialize a webship-js test project"
echo "  /webship-js-test   — Create & run BDD tests for a page"
echo "  /webship-js-report — Generate & analyze test reports"
echo "  /webship-js-steps  — Step definition quick reference"
echo ""
echo "Done."
