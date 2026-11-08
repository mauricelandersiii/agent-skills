#!/usr/bin/env bash
# Symlink every skill in ./skills into the global Claude Code and Cursor skill folders.
# Existing non-symlink copies are moved to ~/.agent-skills-backup/<timestamp>/ first.
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
TARGETS=("$HOME/.claude/skills" "$HOME/.cursor/skills")
BACKUP="$HOME/.agent-skills-backup/$(date +%Y%m%d-%H%M%S)"

for target in "${TARGETS[@]}"; do
  mkdir -p "$target"
  for skill in "$REPO"/skills/*/; do
    name="$(basename "$skill")"
    dest="$target/$name"
    if [ -L "$dest" ]; then
      rm "$dest"
    elif [ -e "$dest" ]; then
      mkdir -p "$BACKUP/$(basename "$(dirname "$target")")"
      mv "$dest" "$BACKUP/$(basename "$(dirname "$target")")/$name"
      echo "backed up $dest"
    fi
    ln -s "${skill%/}" "$dest"
    echo "linked $dest"
  done
done
