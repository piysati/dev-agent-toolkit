#!/usr/bin/env bash
set -euo pipefail

# Sync Super-Dev-Hub's Antigravity harness (.agents/) into any target project repo
# without overwriting unrelated user files.
#
# Usage:
#   ./scripts/sync-to-project.sh /path/to/your-work-repo [--with-gemini-md]

HUB_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <target-project-dir> [--with-gemini-md]"
  exit 1
fi

TARGET_DIR="$1"
WITH_GEMINI_MD="${2:-}"

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "Error: Target directory does not exist: $TARGET_DIR"
  exit 1
fi

TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

if [[ "$TARGET_DIR" == "$HUB_ROOT" ]]; then
  echo "Error: Target directory is already Super-Dev-Hub."
  exit 1
fi

mkdir -p "$TARGET_DIR/.agents/rules" "$TARGET_DIR/.agents/skills" "$TARGET_DIR/.agents/agents" "$TARGET_DIR/.agents/workflows"

cp -R "$HUB_ROOT/.agents/rules/"* "$TARGET_DIR/.agents/rules/"
cp -R "$HUB_ROOT/.agents/skills/"* "$TARGET_DIR/.agents/skills/"
cp -R "$HUB_ROOT/.agents/agents/"* "$TARGET_DIR/.agents/agents/"
cp -R "$HUB_ROOT/.agents/workflows/"* "$TARGET_DIR/.agents/workflows/"

echo "Synced .agents/{rules,skills,agents,workflows} -> $TARGET_DIR/.agents/"

if [[ "$WITH_GEMINI_MD" == "--with-gemini-md" ]]; then
  if [[ -f "$TARGET_DIR/GEMINI.md" ]]; then
    echo "Skipped GEMINI.md: already exists at $TARGET_DIR/GEMINI.md (merge manually if desired)."
  else
    cp "$HUB_ROOT/GEMINI.md" "$TARGET_DIR/GEMINI.md"
    echo "Copied GEMINI.md -> $TARGET_DIR/GEMINI.md"
  fi
else
  echo "Tip: Pass --with-gemini-md to also copy GEMINI.md if your target repo doesn't have one."
fi

echo "Done! Start a new Antigravity conversation in $TARGET_DIR to load the skills."
